;************************************************************************
;
; $Revision$
;
; $Log$
;
;************************************************************************

.386P

.NOLISTMACRO                   ;suppress macro expansion in listing

.XLIST                  ;suppress listing of INCLUDE files
    INCLUDE .\SEGMENTS.INC
    INCLUDE .\COMDD.INC
    INCLUDE .\DCB.INC
.LIST

VDD_ERR_COMx_NOT_INSTALLED EQU  3
VDD_ERR_PORT_ALREADY_OPEN  EQU  1

s_PhysAddr STRUCT
  _lo     dw      (?)
  _hi     dw      (?)
s_PhysAddr ends

s_Flat_Pointer STRUCT
  fp_offlo       DW      ?
  fp_offhi       DW      ?
  fp_sel         DW      ?
s_Flat_Pointer ENDS

s_VDD_entry_Data STRUCT
  old_bp        dw      ?
  old_cs        dd      ?
  old_ip        dd      ?
  ul2           PhysAddr <>
  ul1           PhysAddr <>
  ulFunction    dd      ?
s_VDD_entry_Data ENDS

;PDDProc function number (stack bases)
GETREGISTERENTRY  equ     1

;Packet to receive initialization data from PCOM
PDD_Port_Info_Pkt   struc
PPI_Length      dw      4+(MAX_VDD_PORTS*4)      ;length of packet (bytes)
PPI_NumPorts    dw      0                     ;number of port addresses
PPI_PortAddr    dw      MAX_VDD_PORTS dup (0)    ;return addresses
PPI_PortIrq     dw      MAX_VDD_PORTS dup (0)    ;return addresses
PDD_Port_Info_Pkt   ends

;PDDProc function numbers (in AH)
OPENPORT        equ     1
CLOSEPORT       equ     2
GETBYTE         equ     3
PUTBYTE         equ     4
GETDLLDLM       equ     5
SETDLLDLM       equ     6
SETMCR          equ     46h
SETLCR          equ     42h
SETBREAKON      equ     4bh
SETBREAKOFF     equ     45h
GETLCR          equ     62h
GETMCR          equ     66h
GETMSR          equ     67h

;INT14h function numbers (in AH)
INT14INIT       equ     0
INT14TX         equ     1
INT14RX         equ     2
INT14STATUS     equ     3
INT14XINIT      equ     4
INT14XCTL       equ     5

;Error indication from normal call
FAILURE         equ     1
SUCCESS         equ     0

RES_DATA SEGMENT

    EXTRN stDeviceParms                 :s_stDeviceParms
    EXTRN dfVCOMaddress                 :FAR
    EXTRN wDeviceCount                  :WORD
    EXTRN wVDDdeviceCount               :WORD
    EXTRN stVDDports                    :s_stVDDports
    EXTRN wVDDdeviceOffsetTable         :WORD

RES_DATA ENDS

RES_CODE SEGMENT
    ASSUME CS:RCGROUP, ES:nothing, SS:nothing, DS:RDGROUP

        EXTRN _Open             :NEAR
        EXTRN _Close            :NEAR

BEGIN_VDD_CODE LABEL NEAR

PDD_VDD_comm PROC FAR

        push    bp
        mov     bp,sp
        push    di
        push    es
        push    ds
        mov     di,RES_DATA
        mov     ds,di

  int 3
        cmp     [bp].VDD_entry_Data.ulFunction ,0
        jne     test_function_1

; Save 16:32 pointer of VCOM notification entry point
; in global (fixed) data (dfVCOMAddress)

        mov     ax,[bp].VDD_entry_Data.ul1._lo
        mov     [dfVCOMaddress].Flat_Pointer.fp_sel,ax

        mov     ax,[bp].VDD_entry_Data.ul2._lo
        mov     [dfVCOMaddress].Flat_Pointer.fp_offlo,ax

        mov     ax,[bp].VDD_entry_Data.ul2._hi
        mov     [dfVCOMaddress].Flat_Pointer.fp_offhi,ax
        jmp     success

test_function_1:
        cmp     [bp].VDD_entry_Data.ulFunction,GETREGISTERENTRY
        jne     bad_function
        mov     es,[bp].VDD_entry_Data.ul1._hi
        mov     di,[bp].VDD_entry_Data.ul1._lo

        mov     es:[di].Flat_Pointer.fp_sel,cs
        mov     es:[di].Flat_Pointer.fp_offhi,0
        mov     ax,OFFSET PDD_VDD_Reg_comm
        mov     es:[di].Flat_Pointer.fp_offlo,ax

        mov     es,[bp].VDD_entry_Data.ul2._hi
        mov     di,[bp].VDD_entry_Data.ul2._lo

        call    GetVDDportInfo
        jmp     exit

bad_function:
        mov     ax,FAILURE
        jmp     exit
success:
        mov     ax,SUCCESS
exit:
        pop     ds
        pop     es
        pop     di
        pop     bp
        db      66h                        ; make return 32 bit
        retf    12

PDD_VDD_comm ENDP

; ES:DI contains address of VDD port structure

GetVDDportInfo PROC NEAR USES CX

  int 3
        mov     ax,wVDDdeviceCount
        push    edi

        mov     ES:[di].PDD_Port_Info_Pkt.PPI_NumPorts,ax
        or      ax,ax
        jnz     @f
        mov     ax,FAILURE
        pop     edi
        jmp     exit
@@:
        mov     cx,ax

clear_loop:
        mov     ES:[di].PDD_Port_Info_Pkt.PPI_PortAddr,0
        mov     ES:[di].PDD_Port_Info_Pkt.PPI_PortIrq,0
        add     di,TYPE PDD_Port_Info_Pkt
        loop    clear_loop
        pop     edi

;        or      ax,ax
;        jz      success

fill_data_block:
        mov     bx,OFFSET stVDDports
        mov     cx,[bx]._stVDDports.wAddr
        mov     ES:[di].PDD_Port_Info_Pkt.PPI_PortAddr,cx
        mov     cx,[bx]._stVDDports.wIRQ
        mov     ES:[di].PDD_Port_Info_Pkt.PPI_PortIrq,cx
        dec     ax
        jz      success
        add     di,2
        add     bx,TYPE _stVDDports
        mov     cx,[bx]._stVDDports.wAddr
        mov     ES:[di].PDD_Port_Info_Pkt.PPI_PortAddr,cx
        mov     cx,[bx]._stVDDports.wIRQ
        mov     ES:[di].PDD_Port_Info_Pkt.PPI_PortIrq,cx
        dec     ax
        jz      success
        add     di,2
        add     bx,TYPE _stVDDports
        mov     cx,[bx]._stVDDports.wAddr
        mov     ES:[di].PDD_Port_Info_Pkt.PPI_PortAddr,cx
        mov     cx,[bx]._stVDDports.wIRQ
        mov     ES:[di].PDD_Port_Info_Pkt.PPI_PortIrq,cx
        dec     ax
        jz      success
        add     di,2
        add     bx,TYPE _stVDDports
        mov     cx,[bx]._stVDDports.wAddr
        mov     ES:[di].PDD_Port_Info_Pkt.PPI_PortAddr,cx
        mov     cx,[bx]._stVDDports.wIRQ
        mov     ES:[di].PDD_Port_Info_Pkt.PPI_PortIrq,cx
success:
        mov     ax,SUCCESS
exit:
        ret

GetVDDportInfo ENDP

SetupVDDstructures PROC NEAR USES AX BX CX DX DS SI ES DI

;   int 3
        mov     cx,MAX_VDD_PORTS
        cmp     cx,wDeviceCount
        jbe     @f
        mov     cx,wDeviceCount
@@:
        mov     ax,40h
        mov     es,ax
        xor     bx,bx
        mov     si,OFFSET _DeviceParms
        mov     di,OFFSET stVDDports

test_var_used_loop:
        cmp     WORD PTR ES:[bx],0
        jne     next_slot
        mov     dx,[si].stDeviceParms.wIObaseAddress
;        or      dx,dx
;        jz      exit
        mov     wVDDdeviceOffsetTable[bx],si
        mov     [di]._stVDDports.wAddr,dx
        mov     ES:[bx],dx
        xor     ax,ax
        mov     al,[si].stDeviceParms.byInterruptLevel
        mov     [di]._stVDDports.wIRQ,ax
        inc     wVDDdeviceCount
        add     si,TYPE stDeviceParms
        add     di,TYPE _stVDDports

next_slot:
        add     bx,2
        loop    test_var_used_loop

exit:
        ret

SetupVDDstructures ENDP

PDD_VDD_Reg_comm PROC FAR
  VDDfunction EQU <ax>
  VDDport EQU <dl>

  int 3
        push    si
        push    bx
        push    ds
        mov     si,RES_DATA
        mov     ds,si
        xor     bx,bx
        mov     bl,VDDport
        cmp     bx,MAX_VDD_PORTS
        jae     no_comm
        mov     si,wVDDdeviceOffsetTable[bx]
        or      si,si
        jnz     @f
no_comm:
        mov     ax,VDD_ERR_COMx_NOT_INSTALLED
        jmp     exit
@@:
    .if (VDDfunction == OPENPORT)
        call    VDD_open_port
        jmp     test_error
    .elseif (VDDfunction == CLOSEPORT)
        call    VDD_close_port
        jmp     test_error
    .elseif (VDDfunction == GETBYTE)
        mov     ax,SUCCESS
    .elseif (VDDfunction == PUTBYTE)
        mov     ax,SUCCESS
    .elseif (VDDfunction == GETDLLDLM)
        mov     ax,SUCCESS
    .elseif (VDDfunction == SETDLLDLM)
        mov     ax,SUCCESS
    .elseif (VDDfunction == SETMCR)
        mov     ax,SUCCESS
    .elseif (VDDfunction == SETLCR)
        mov     ax,SUCCESS
    .elseif (VDDfunction == SETBREAKON)
        mov     ax,SUCCESS
    .elseif (VDDfunction == SETBREAKOFF)
        mov     ax,SUCCESS
    .elseif (VDDfunction == GETLCR)
        mov     ax,SUCCESS
    .elseif (VDDfunction == GETMCR)
        mov     ax,SUCCESS
    .elseif (VDDfunction == GETMSR)
        mov     ax,SUCCESS
    .else
        xor     ax,ax
    .endif

test_error:


exit:
        pop     ds
        pop     bx
        pop     si
        db      66h                        ; make return 32 bit
        retf

PDD_VDD_Reg_comm ENDP

VDD_open_port PROC NEAR C USES BX CX DX ES DI DS SI
        LOCAL byErrorFlag:BYTE

        cmp     [si].stDeviceParms.wOpenCount,0
        jne     @f
        mov     ax,VDD_ERR_PORT_ALREADY_OPEN
        jmp     exit
@@:
        or      cx,cx
        jz      @f
        or      [si].stDeviceParms.wVDDflags,VDD_FLG_NO_IRQ
@@:
        or      [si].stDeviceParms.wVDDflags,VDD_FLG_PORT_IN_USE
        lea     cx,byErrorFlag
        push    cx
        call    _Open
        add     sp,2

        xor     ax,ax
        mov     al,byErrorFlag
        or      ax,ax
        jz      exit
        and     [si].stDeviceParms.wVDDflags,NOT VDD_FLG_PORT_IN_USE
exit:
        ret

VDD_open_port ENDP

VDD_close_port PROC NEAR C USES BX CX DX ES DI DS SI
        LOCAL byErrorFlag:BYTE

        lea     cx,byErrorFlag
        push    cx
        call    _Close
        add     sp,2

        and     [si].stDeviceParms.wVDDflags,NOT (VDD_FLG_NO_IRQ OR VDD_FLG_PORT_IN_USE)

        xor     ax,ax
        mov     al,byErrorFlag
        or      ax,ax
        jnz     @f
        mov     ax,SUCCESS
        jmp     exit
@@:
        mov     ax,FAILURE
exit:
        ret

VDD_close_port ENDP

RES_CODE ENDS

  END
