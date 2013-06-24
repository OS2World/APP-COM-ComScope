;************************************************************************
;
; $Revision:   1.3  $
;
; $Log:   P:/archive/comi/mca.asv  $
;  
;     Rev 1.3   28 Mar 1996 00:20:18   EMMETT
;  Added resource manager.  Began work on VDD support.
;  
;     Rev 1.2   19 Feb 1996 10:37:16   EMMETT
;  Added ring zero IDC access for OEM present tests.
;  
;     Rev 1.1   25 Apr 1995 22:17:00   EMMETT
;  Added Support for DigiBoard PC/16.  Changed interrupt Routine for better adapter independence.
;  Changed interrupt routine to allow user to select interrupting device selection algorithim.  Fixed
;  ABIOS interaction for better "non.INI" initialization in MCA machines.  Fixed various initialization
;  message strings.  COMscope and receive buffer are now allocated from system memory, allowing
;  a 32k (word) COMscope buffer and a 64k (byte) receive buffer.
;  
;     Rev 1.0   03 Dec 1994 14:42:50   EMMETT
;  Initial archive.  This file consolodates all ABIOS initialization code.
;  
;************************************************************************

  IFNDEF x16_BIT
.386P
  ELSE
.286P
  ENDIF
.NOLISTMACRO                   ;suppress macro expansion in listing

.XLIST
    INCLUDE SEGMENTS.INC
    INCLUDE COMDD.INC
    INCLUDE PACKET.INC
    INCLUDE INITMACRO.INC
    INCLUDE ABIOS.INC
    INCLUDE DEVHLP.INC
    INCLUDE DCB.INC
    INCLUDE Hardware.inc

.LIST

RES_DATA SEGMENT

    EXTRN bSharedInterrupts     :WORD
  IFNDEF x16_BIT
    EXTRN IDCaccessPM           :DWORD
    EXTRN IDCaccessPDS          :WORD
  ENDIF
    EXTRN device_hlp            :DWORD
  IFDEF OEM
    EXTRN bOEMpresent          :WORD
  ENDIF

RES_DATA ENDS

_DATA SEGMENT

.XLIST
    INCLUDE MSG.INC
.LIST
    EXTRN _szMessage                     :BYTE
    EXTRN _bABIOSpresent        :WORD
    EXTRN _wLoadCount           :WORD

    EXTRN _dwPCIvector          :DWORD

    EXTRN _ADFtable             :WORD
    EXTRN _bIsTheFirst          :WORD

  IFDEF OEM
    EXTRN ISA_bad_msg:             BYTE
    EXTRN MCA_bad_msg:             BYTE
    EXTRN Contact_msg:             BYTE
    EXTRN OS_tools_BLURB:  BYTE
  ENDIF
.LIST

_DATA ENDS

RES_CODE SEGMENT
    ASSUME CS:RCGROUP, ES:nothing, SS:nothing, DS:RDGROUP, GS:DGROUP

;-------------------------------------------------------------------------------
; Initialization procedures are placed after BEGIN_INIT_CODE so they can go
; away once initialization has completed.
;-------------------------------------------------------------------------------

    EXTRN PrintString           :NEAR

;  Test if MCA by testing if the POS device exists.  If no POS device
;  exists then interrupts cannot be shared.

; assume GS = DGROUP
TestMCA PROC USES ax bx cx dx di si

        mov     GS:_bABIOSpresent,TRUE
        mov     bSharedInterrupts,FALSE
        xor     bx,bx

        mov     al,ASYNC_DEV_ID
        mov     dh,NON_DMA_DEV
        mov     dl,DevHlp_GetLIDEntry
        call    device_hlp
        jc      test_ASYNC_error

        mov     dl,DevHlp_FreeLIDEntry
        call    device_hlp
        jmp     test_bus

test_ASYNC_error:
        cmp     ax,ERROR_ABIOS_NOT_PRESENT
        jne     test_bus
        mov     GS:_bABIOSpresent,FALSE
        jmp     exit

test_bus:
        xor     bx,bx
        mov     al,POS_DEV_ID               ;open POS device?
        mov     dh,DMA_POS_DEV
        mov     dl,DevHlp_GetLIDEntry
        call    device_hlp
        jc      test_POS_error              ;error?
        mov     bSharedInterrupts,TRUE     ; if not then a POS device exists
        mov     dl,DevHlp_FreeLIDEntry      ;   and interrupts can be shared
        call    device_hlp
        jmp     exit

test_POS_error:
        cmp     ax,ERROR_LID_ALREADY_OWNED  ;if already owned then it exists
        jne     exit
        mov     bSharedInterrupts,TRUE     ; and interrupts can be shared

exit:
        ret

TestMCA ENDP

;WORD GetLIDentry(WORD _far *pwLID);

; assume DS = DGROUP
GetLIDentry PROC FAR C USES bx dx ds es, pwLID:DWORD

    SetDS     RDGROUP
        mov     al,ASYNC_DEV_ID
        mov     dh,NON_DMA_DEV
        les     bx,pwLID
        mov     bx,ES:[bx]
        mov     dl,DevHlp_GetLIDEntry
        call    device_hlp
        jc      exit
        les     bx,pwLID
        mov     ES:[bx],ax
        xor     ax,ax
exit:
        ret

GetLIDentry ENDP ;returns error code or zero if no error

    IFNDEF x16_BIT
;
; push count
; push dest off
; push dest seg
; push src off
; push src seg
; push function
;
Ring0Access PROC FAR uses bx cx si di es ds gs
;   int 3
        LOCAL dwServiceBytes :DWORD
    SetDS     RDGROUP
    SetGS     DGROUP
        mov     ax,SS:[si]
        cmp     ax,TEST_FOR_PCI_BIOS
        jne     test_get_devblk_len

        mov     bx,SS:[si + 4]
        mov     ax,SS:[si + 2]
        mov     cx,0f000h
        mov     dh,3
        mov     dl,DevHlp_PhysToUVirt
        call    device_hlp
        jc      exit

        mov     di,bx
        mov     WORD PTR GS:[_dwPCIvector],bx
        mov     ax,es
        mov     WORD PTR GS:[_dwPCIvector + 2],ax
        mov     dwServiceBytes,"ICP$"
        mov     eax,dwServiceBytes
        xor     ebx,ebx
        push    ds
        push    es
        pop     ds
        call    GS:_dwPCIvector
        pop     ds
        or      al,al
        jnz     no_PCI_BIOS       

set_PCI_BIOS_vector:
        add     GS:[_dwPCIvector],edx
        mov     ah,0b1h
        mov     al,001h
        call    GS:_dwPCIvector
        jnc     BIOS_may_be_present
        jmp     no_PCI_BIOS

BIOS_may_be_present:
        or      al,al
        jnz     no_PCI_BIOS

        mov     dwServiceBytes," ICP"
        mov     edx,dwServiceBytes
        mov     BYTE PTR dwServiceBytes,'P'
        mov     BYTE PTR [dwServiceBytes + 1],'C'
        mov     BYTE PTR [dwServiceBytes + 2],'I'
        mov     BYTE PTR [dwServiceBytes + 3],' '
        cmp     edx,dwServiceBytes
        jne     no_PCI_BIOS

PCI_BIOS_is_viable:
;        mov     ax,es
;        mov     dh,2
;        mov     dl,DevHlp_PhysToUVirt
;        call    device_hlp
        clc 
        jmp     exit

no_PCI_BIOS:
        mov     ax,es
        mov     dh,2
        mov     dl,DevHlp_PhysToUVirt
        call    device_hlp
        mov     ax,1
        stc
        jmp     exit
        
test_get_devblk_len:
        cmp     ax,GET_DEVBLK_LEN
        jne     test_addr

        mov     ax,SS:[si + 4]
        mov     es,ax
        mov     bx,SS:[si + 2]

        mov     ax,ES:[bx]
        stc
        jmp     exit

test_addr:
        cmp     ax,GET_BASE_ADDR
        jne     test_get_blocks

        mov     ax,SS:[si + 4]
        mov     es,ax
        mov     bx,SS:[si + 2]

        mov     ax,ES:[bx].s_stABIOSdeviceBlock.wDataArea
        stc
        jmp     exit

test_get_blocks:
        cmp     ax,GET_KERNAL_DATA
        jne     test_IDC_access_OEM

        mov     cx,SS:[si + 10]         ;count
        mov     ax,SS:[si + 8]          ;destination        
        mov     es,ax
        mov     di,SS:[si + 6]
        mov     ax,SS:[si + 4]          ;source
        mov     ds,ax
        mov     si,SS:[si + 2]
        mov     ax,cx
    rep movsb
        stc
        jmp     exit

test_IDC_access_OEM:
        cmp     ax,DO_IDC_ACCESS_OEM
        jne     test_IDC_access_IRQ
        mov     ax,SS:[si + 4]
        push    ax
        mov     ax,SS:[si + 2]
        push    ax
        mov     ax,ADD_IS_OEM_PRESENT
        push    ax
        push    ds
        pop     es
        mov     ds,ES:IDCaccessPDS
        call    ES:IDCaccessPM
        pop     cx
        pop     cx
        pop     cx      ; popped instead of SUB SP,6 to preserve carry flag
        jmp     exit

test_IDC_access_IRQ:
        cmp     ax,DO_IDC_ACCESS_IRQ
        jne     exit
        mov     ax,SS:[si + 4]
        push    ax
        mov     ax,SS:[si + 2]
        push    ax
        mov     ax,ADD_MARK_IRQ_USED
        push    ax
        push    RDGROUP
        pop     es
        mov     ds,ES:IDCaccessPDS
        call    ES:IDCaccessPM
        pop     cx
        pop     cx
        pop     cx      ; popped instead of SUB SP,6 to preserve carry flag

exit:
        ret

Ring0Access ENDP

  IFDEF OEM

CheckPOS PROC NEAR USES ax bx cx dx di
   ASSUME DS:RDGROUP, GS:DGROUP

        mov     cx,08
        mov     bx,08
check_loop:
        mov     al,bl
        IOdelay di
        out     96h,al
        mov     dx,100h
        InByteDel di
        xchg    al,ah
        inc     dx
        InByteDel di
        xchg    al,ah

        mov     di,OFFSET _ADFtable  ;assume DGROUP - GS = DGROUP

search_loop:
        cmp     WORD PTR GS:[di],ZERO
        je      next_slot
        cmp     ax,WORD PTR GS:[di]
        je      found_valid_board
        add     di,2
        jmp     search_loop

found_valid_board:
        mov     bOEMpresent,TRUE
        xor     al,al
        IOdelay di
        out     96h,al
        clc
        jmp     check_POS_exit

next_slot:
        inc     bl
        loop    check_loop

        xor     al,al
        IOdelay di
        out     96h,al
        stc

check_POS_exit:
        ret

CheckPOS ENDP

BadMCAmessage PROC NEAR

        mov     ax,OFFSET MCA_bad_msg
        call    PrintString
        mov     ax,OFFSET Contact_msg
        call    PrintString
        mov     ax,OFFSET OS_tools_BLURB
        call    PrintString
        ret

BadMCAmessage ENDP
  ENDIF
   ENDIF ; NOT x16_BIT
RES_CODE ENDS

  END
