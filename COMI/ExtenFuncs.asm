;************************************************************************
;
; $Revision:   1.1  $
;
; $Log:   P:/archive/comi/ExtenFuncs.asv  $
;
;     Rev 1.1   28 Mar 1996 00:19:16   EMMETT
;  Added resource manager.  Began work on VDD support.
;
;     Rev 1.0   18 Feb 1996 14:16:00   EMMETT
;  Added many features.  Notably:
;  Tracing application DosDevIOCtl function calls and packets.
;  Support for 16650 and 16750 UARTs.
;  Streamlined interrupt routine.
;
;************************************************************************

.386P
.NOLISTMACRO                   ;suppress macro expansion in listing

.XLIST                       ;Suppress listing of files
    INCLUDE SEGMENTS.INC
    INCLUDE COMDD.INC
    INCLUDE MACRO.INC
    INCLUDE PACKET.INC
    INCLUDE DEVHLP.INC
    INCLUDE DCB.INC
    INCLUDE Hardware.inc

RES_DATA SEGMENT

    EXTRN device_hlp            :DWORD
    EXTRN IDCaccessPM           :DWORD
    EXTRN IDCaccessPDS          :WORD
    EXTRN IDCdata               :WORD

    EXTRN wInterruptsUsed       :WORD

    EXTRN abyPath               :BYTE
    EXTRN wDeviceCount          :WORD
    EXTRN wLastEndOfData        :WORD
    EXTRN wEndOfData            :WORD

 IFNDEF SHARE
    EXTRN ulTriggersSinceReboot :DWORD
    EXTRN wPagerOpenCount       :WORD
    EXTRN bReadTrigger          :BYTE
    EXTRN bWriteTrigger         :BYTE
    EXTRN bOpenTrigger          :BYTE
    EXTRN wMaxDeviceCount       :WORD
    EXTRN wMaxPagerCount        :WORD
 ENDIF
    EXTRN byOEMtype             :BYTE
    EXTRN byAdapterType         :BYTE
    EXTRN stDeviceParms         :WORD
    EXTRN wCOMiLoadNumber       :WORD

 IFDEF OEM
    EXTRN bOEMpresent           :WORD
 ENDIF

RES_DATA ENDS

RES_CODE SEGMENT
    ASSUME CS:RCGROUP, ES:nothing, SS:nothing, DS:RDGROUP

    EXTRN GetReceiveQueueLen    :NEAR

.LIST


; label for this load's addressability

nDDAttachFunction LABEL NEAR

; DS = this load's data segment
; ES = calling load's data segment
; param 1 = function
; param 2 = modifier
; param 3 = offset to calling load's IDC data area

; return data is in AX if negative response

; positive response data is in IDCdata of calling load

; NOTE:
;       This function can be called locally by the first load, or from another
;       device driver load.  All returns and parameters are treated as if it
;       were called from another load.

; Only LocalIDCaccess should be used to call this function

DDAttachFunction PROC FAR C, wFunction:WORD, wModifier:WORD, oDataArea:WORD

        mov     bx,wFunction
        cmp     bx,LAST_ATTACHDD_FUNCTION
        jle     @f
        mov     ax,ADD_ERROR_BAD_FUNCTION
        jmp     negative
@@:
        shl     bx,1
        jmp     CS:AttachDDjumpTable[bx]

; this function is called at INIT time via the DynamicAPI function.
; A positive response is returned only if this is an OEM version AND an OEM
; adapter has been initialized by this (the first) load.

IsOEMpresent:
        mov     ax,SIGNATURE  ;always return this load's signature
 IFDEF OEM
        cmp     bOEMpresent,TRUE
        je      positive
 ENDIF
        jmp     negative

; This function keeps a bit map of interrupts used by all loads of the
; device driver.  This is used to prevent the call RegisterStackUsage from
; being called more than once for each interrupt requested.

; Positive means that RegisterStackUsage should be called
MarkInterruptUsed:
        mov     cx,wModifier
        mov     ax,1
        shl     ax,cl
        test    wInterruptsUsed,ax
        jnz     negative
        or      wInterruptsUsed,ax
        jmp     positive

  IFNDEF NO_COMscope
GetSignature:
        mov     ax,SIGNATURE
        jmp     positive

   IFNDEF SHARE
IsTriggered:
; test if pager is triggerd, if not, return negative response (cy)
; if pager is triggered then mark it untriggered and return positive (nc)

        cmp     bOpenTrigger,TRUE
        jne     negative
        mov     bOpenTrigger,FALSE
        jmp     positive

OpenPager:
; compare current pager count with maximum allowed
; if not too many then increment counter and return positive (nc)
; otherwise return negative (cy)
; the maximum pager count is always returned in AX

        mov     ax,wMaxPagerCount  ;always returns MAX pager count
        cmp     wPagerOpenCount,ax
        jae     negative
        inc     wPagerOpenCount
        mov     bOpenTrigger,TRUE
        jmp     positive

ClosePager:
; If current pager count is zero then return negative (cy).
; Otherwise decrement pager count and return positive (nc).
; The pager count that was in effect when the function was entered.
; is always returned in AX.

        mov     ax,wPagerOpenCount  ;always return current pager count
        or      ax,ax
        jz      negative
        dec     ax
        mov     wPagerOpenCount,ax
        jmp     positive

; AX is retained by call gate when the carry flag is set upon return.
; AX gets cleared to zero by call gate when the carry flag is cleared
; upon return.
; AX is retained for all other AttachDD function call returns.

; A call gate is used by the DynamicAPI function to call a function at
; Ring 0.  The DynamicAPI function is used only at INIT time to call the
; AttachDD function for the OS$tools device and only to determine
; if an OEM device has already been initialized.

   ENDIF ; NOT SHARE
  ENDIF ; NOT NO_COMscope
negative:
        stc
        jmp     exit

positive:
        clc
        mov     bx,oDataArea
        mov     WORD PTR ES:[BX],ax

exit:
        ret

AttachDDjumpTable LABEL WORD
        WORD    IsOEMpresent
        WORD    MarkInterruptUsed
  IFNDEF NO_COMscope
        WORD    GetSignature
   IFNDEF SHARE
        WORD    OpenPager
        WORD    ClosePager
        WORD    IsTriggered
   ENDIF
  ENDIF

DDAttachFunction ENDP

LocalIDCaccess PROC NEAR USES DS ES CX; AX = function, CX = modifier

        push    OFFSET IDCdata
        push    cx
        push    ax
        push    ds
        pop     es  ; IDC function expects this load's data segment in ES
        mov     ds,IDCaccessPDS
        call    ES:IDCaccessPM
        pop     cx
        pop     cx
        pop     cx  ; popped instead of SUB SP,6 to preserve carry flag
        ret

LocalIDCaccess ENDP ;carry set if error, AX = error code if carry set

ExtensionFunction PROC NEAR C USES SI BX CX, oErrorCode:WORD
              ;AX still contains who was called - COM, OS$tools, or COMscope

        LOCAL   pDataAddress:DWORD
        LOCAL   pParamAddress:DWORD
        LOCAL   wSignature:WORD
        LOCAL   wTarget:WORD
        LOCAL   wDataLength:WORD

        push    es
        push    di
        mov     wTarget,ax       ; save called target

        xor     cx,cx            ; use GIOpacketLength
        VerifyPacketData

        sub     cx,TYPE s_stExtensionDataHeader   ;adjust for header
        js      bad_length

        mov     wDataLength,cx                   ; save count

        mov     cx,TYPE s_stExtensionParams
        VerifyPacketParams

        cmp     cx,TYPE s_stExtensionParams
        jne     bad_length

        les     di,pParamAddress
        mov     ax,ES:[di].s_stExtensionParams.wSignature
        mov     wSignature,ax
        mov     ax,ES:[di].s_stExtensionParams.wCommand
        mov     dx,ES:[di].s_stExtensionParams.wModifier
        mov     cx,ES:[di].s_stExtensionParams.wDataCount

        cmp     cx,wDataLength
        jbe     @f
        mov     cx,wDataLength
@@:
        cmp     ax,MAX_EXT_CMD
        ja      bad_command
        mov     bx,ax
        shl     bx,1
        jmp     CS:ExtensionJumpTable[BX]

GetPath:                                                ; function 2
        or      cx,cx
        jz      bad_length
        cmp     cx,CCHMAXPATH
        jna     @f
        mov     cx,CCHMAXPATH
@@:
        xor     dx,dx
        lea     si,abyPath

find_path_end_loop:
        cmp     BYTE PTR [si],0
        je      @f
        inc     si
        inc     dx
        loop    find_path_end_loop
@@:
        or      cx,cx
        jnz     @f
        cmp     BYTE PTR [si],0
        je      @f
        mov     ax,EXT_ERROR_BAD_PATH
        mov     cx,dx
        jmp     extension_exit
@@:
        lea     si,abyPath
        mov     cx,dx

move_memory:
        or      cx,cx
        jz      @f
        les     di,pDataAddress
        add     di,TYPE s_stExtensionDataHeader
        push    cx
    rep movsb
        pop     cx
@@:
        mov     ax,EXT_RSP_SUCCESS
        jmp     extension_exit

GetSignature:                                           ; function 7
        cmp     cx,TYPE WORD
        jb      bad_length
        les     di,pDataAddress
        mov     ax,SIGNATURE
        add     di,TYPE s_stExtensionDataHeader
        mov     ES:[di],ax
        mov     ax,EXT_RSP_SUCCESS
        jmp     accept_sig_exit

  IFNDEF NO_COMscope
GetConfigFlags:                                         ; function 6
        cmp     cx,TYPE WORD
        jb      bad_length
        les     di,pDataAddress
        mov     ax,[si].s_stDeviceParms.wConfigFlags1
        or      dx,dx                     ;test modifier
        jz      @f
        mov     ax,[si].s_stDeviceParms.wConfigFlags2
@@:
        add     di,TYPE s_stExtensionDataHeader
        mov     ES:[di],ax
        mov     ax,EXT_RSP_SUCCESS
        jmp     extension_exit

GetMemory:                                              ; function 0
; setup memory object address

        or      cx,cx
        jz      bad_length
        cmp     dx,wLastEndOfData
        jna     @f
        mov     ax,EXT_ERROR_BAD_MEMORY_TARGET
        xor     cx,cx
        jmp     extension_exit
@@:
        mov     si,dx
        add     dx,cx
        cmp     dx,wLastEndOfData
        jbe     @f
        mov     cx,wLastEndOfData
        sub     cx,si
@@:
        jmp     move_memory

GetDCB:                                                 ; function 1
        cmp     cx,TYPE s_stDeviceParms
        ja      bad_length

        cmp     dx,wDeviceCount
        jb      @f
        mov     ax,EXT_ERROR_BAD_MODIFIER
        xor     cx,cx
        jmp     extension_exit
@@:
        mov     ax,TYPE s_stDeviceParms
        mul     dx
        mov     si,ax
        add     si,OFFSET stDeviceParms
        jmp     move_memory

GetMemorySize:
        cmp     cx,TYPE WORD
        jb      bad_length
        les     di,pDataAddress
        mov     ax,wLastEndOfData
        add     di,TYPE s_stExtensionDataHeader
        mov     ES:[di],ax
        mov     ax,EXT_RSP_SUCCESS
        jmp     extension_exit

GetVariablesSize:                                       ; function 4
        cmp     cx,TYPE WORD
        jb      bad_length
        les     di,pDataAddress
        mov     ax,wEndOfData
        add     di,TYPE s_stExtensionDataHeader
        mov     ES:[di],ax
        mov     ax,EXT_RSP_SUCCESS
        jmp     extension_exit

GetLoadNumber:
        cmp     cx,TYPE WORD                            ; function 5
        jb      bad_length
        les     di,pDataAddress
        mov     ax,wCOMiLoadNumber
        add     di,TYPE s_stExtensionDataHeader
        mov     ES:[di],ax
        mov     ax,EXT_RSP_SUCCESS
        jmp     extension_exit

GetOEMtype:                                             ; function 8
        cmp     cx,TYPE WORD
        jb      bad_length
        les     di,pDataAddress
        xor     ax,ax
        mov     al,byOEMtype
        add     di,TYPE s_stExtensionDataHeader
        mov     ES:[di],ax
        mov     ax,EXT_RSP_SUCCESS
        jmp     accept_sig_exit

  IFDEF PAGE_SUPPORT
SetOpenTrigger:                                         ; function 9
        test    wTarget,TARGET_OS_tools
        jnz     @f
        mov     ax,EXT_ERROR_BAD_TARGET
        jmp     extension_exit
@@:
        cmp     wSignature,SIGNATURE
        je      @f
        mov     ax,EXT_BAD_SIGNATURE
        jmp     accept_sig_exit
@@:
        mov     ax,ADD_OPEN_PAGER
        call    LocalIDCaccess
        pushf                   ; save flags
        cmp     cx,TYPE WORD    ; if expecting WORD data return MAX count
        jb      @f
        les     di,pDataAddress
        add     di,TYPE s_stExtensionDataHeader
        mov     ES:[di],ax
@@:
        popf                    ; restore flags
        jnc     @f
        mov     ax,EXT_ERROR_BAD_TARGET
        jmp     accept_sig_exit
@@:
        mov     ax,EXT_RSP_SUCCESS
        jmp     accept_sig_exit

GetMaxDeviceCount:                                      ; function 10
        cmp     cx,TYPE WORD
        jb      bad_length
        les     di,pDataAddress
        mov     ax,wMaxDeviceCount
        add     di,TYPE s_stExtensionDataHeader
        mov     ES:[di],ax
        mov     ax,EXT_RSP_SUCCESS
        jmp     accept_sig_exit

SetReadTrigger:                                         ; function 11
        cmp     wSignature,SIGNATURE
        je      @f
        mov     ax,EXT_BAD_SIGNATURE
        jmp     accept_sig_exit
@@:
        mov     bReadTrigger,TRUE
        mov     ax,EXT_RSP_SUCCESS
        jmp     accept_sig_exit

SetWriteTrigger:                                        ; function 12
        cmp     wSignature,SIGNATURE
        je      @f
        mov     ax,EXT_BAD_SIGNATURE
        jmp     accept_sig_exit
@@:
        mov     bWriteTrigger,TRUE
        mov     ax,EXT_RSP_SUCCESS
        jmp     accept_sig_exit

;  This function can only be called from OS$tools
;  therefore it is not necessary to use AttachDD (ADD) function

RollSinceBootCounter:                                   ; function 13
        test    wTarget,TARGET_OS_tools
        jnz     @f
        mov     ax,EXT_ERROR_BAD_TARGET
        jmp     extension_exit
@@:
        cmp     cx,TYPE DWORD
        jb      bad_length
        les     di,pDataAddress
        xor     eax,eax
        mov     ax,dx
        add     ulTriggersSinceReboot,eax
        mov     eax,ulTriggersSinceReboot
        add     di,TYPE s_stExtensionDataHeader
        mov     ES:[di],eax
        mov     ax,EXT_RSP_SUCCESS
        jmp     extension_exit

GetPagerCounts:                                         ; function 14
        cmp     cx,TYPE DWORD
        jb      bad_length
        les     di,pDataAddress
        mov     ax,wPagerOpenCount
        add     di,TYPE s_stExtensionDataHeader
        mov     ES:[di],ax
        mov     ax,wMaxPagerCount
        add     di,2
        mov     ES:[di],ax
        mov     ax,EXT_RSP_SUCCESS
        jmp     accept_sig_exit
   ENDIF ;PAGE_SUPPORT
ResetRcvBuffHigh:                                       ; function 16
        cli
        call    GetReceiveQueueLen
        mov     [si].s_stDeviceParms.dwReadBufferLevel,ecx
        mov     [si].s_stDeviceParms.dwReadBufferHigh,ecx
        sti
        jmp     extension_exit
  ENDIF ;NO_COMscope

GetAdapterType:                                             ; function 17
        cmp     cx,TYPE WORD
        jb      bad_length
        les     di,pDataAddress
        xor     ax,ax
        mov     al,byAdapterType
        add     di,TYPE s_stExtensionDataHeader
        mov     ES:[di],ax
        mov     ax,EXT_RSP_SUCCESS
        jmp     accept_sig_exit

bad_length:
        mov     ax,EXT_ERROR_BAD_LENGTH
        xor     cx,cx
        jmp     extension_exit

bad_command:
        mov     ax,EXT_ERROR_BAD_COMMAND
        xor     cx,cx

extension_exit:
        cmp     wSignature,SIGNATURE
        je      accept_sig_exit
        or      ax,EXT_BAD_SIGNATURE

accept_sig_exit:
        les     di,pDataAddress
        mov     ES:[di].s_stExtensionDataHeader.wReturnCode,ax
        mov     ES:[di].s_stExtensionDataHeader.wByteCount,cx
        add     cx,TYPE s_stExtensionDataHeader
        jmp     exit

error:
        StoreError oErrorCode,ERROR_I24_GEN_FAILURE
        xor     cx,cx

exit:
        pop     di
        pop     es
        mov     ES:[di].s_stPacket.GIOpacket.GIOdataLength,cx ;Length of the data into count
        ret

ExtensionJumpTable LABEL WORD
  IFNDEF NO_COMscope
        WORD    GetMemory
        WORD    GetDCB
        WORD    GetPath
        WORD    GetMemorySize
        WORD    GetVariablesSize
        WORD    GetLoadNumber
        WORD    GetConfigFlags
        WORD    GetSignature
        WORD    GetOEMtype
   IFDEF PAGE_SUPPORT
        WORD    SetOpenTrigger
        WORD    GetMaxDeviceCount
        WORD    SetReadTrigger
        WORD    SetWriteTrigger
        WORD    RollSinceBootCounter
        WORD    GetPagerCounts
   ELSE
        WORD    bad_command
        WORD    bad_command
        WORD    bad_command
        WORD    bad_command
        WORD    bad_command
        WORD    bad_command
   ENDIF
        WORD    ResetRcvBuffHigh
        WORD    GetAdapterType
        WORD    bad_command             ; 18
  ELSE
        WORD    bad_command
        WORD    bad_command
        WORD    GetPath
        WORD    bad_command
        WORD    bad_command
        WORD    bad_command
        WORD    bad_command
        WORD    GetSignature
        WORD    bad_command
        WORD    bad_command
        WORD    bad_command
        WORD    bad_command
        WORD    bad_command
        WORD    bad_command
        WORD    bad_command
        WORD    bad_command
        WORD    bad_command
        WORD    bad_command             ; 18
  ENDIF

ExtensionFunction ENDP

RES_CODE ENDS

    END
