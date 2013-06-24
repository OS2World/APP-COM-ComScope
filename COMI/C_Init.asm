;************************************************************************
;
; $Revision$
;
; $Log$
;  
;************************************************************************

.386P
.NOLISTMACRO

.XLIST
    INCLUDE SEGMENTS.INC
    INCLUDE COMDD.INC
    INCLUDE PACKET.INC
    INCLUDE INITMACRO.INC
    INCLUDE DCB.INC
    INCLUDE ABIOS.INC
    INCLUDE DEVHLP.INC
    INCLUDE Hardware.inc
.LIST

RES_DATA SEGMENT

    EXTRN device_hlp            :DWORD
    EXTRN stABIOSrequestBlock  :s_stABIOSrequestBlock

RES_DATA ENDS

_DATA SEGMENT

    EXTRN _bABIOSpresent        :WORD
    EXTRN _Ring0Vector          :DWORD

_DATA ENDS

_TEXT SEGMENT
    ASSUME CS:SCGROUP

;WORD AttachDD(char szName[],DDENTRY *pstAttachDD)
; ASSUME DS = DGROUP, called from 'C' initialization code only
AttachDD PROC FAR C uses bx dx di ds, szName:WORD, pstAttachDD:WORD

;   int 3
     SetDS    RDGROUP
;        mov     ax,1
        mov     di,pstAttachDD
        mov     bx,szName
        mov     dx,DevHlp_AttachDD
        call    device_hlp
        jc      exit
        xor     ax,ax
exit:
        ret

AttachDD ENDP

;GetDeviceInterrupt(WORD wLID);

; ASSUME DS = DGROUP, called from 'C' initialization code only
; DS must point to DD data segment
GetDeviceInterrupt PROC FAR C USES bx dx si ds, wLID:WORD

     SetDS    RDGROUP
        mov     ax,wLID
        mov     si,OFFSET stABIOSrequestBlock
        mov     [si].s_stABIOSrequestBlock.wReturnCode,0ffffh
        mov     [si].s_stABIOSrequestBlock.wLogicalID,ax
        mov     dl,DevHlp_ABIOSCall
        call    device_hlp
        mov     ax,0
        jc      exit

        mov     al,[si].s_stABIOSrequestBlock.byHDWinterruptLevel
exit:
        ret

GetDeviceInterrupt ENDP  ; returns interrupt level in AX

;FreeLIDentry(WORD wLID);

; ASSUME DS = DGROUP, called from 'C' initialization code only
FreeLIDentry PROC FAR C uses bx dx ds, wLID:WORD

     SetDS    RDGROUP
        mov     ax,wLID
        mov     dl,DevHlp_FreeLIDEntry
        call    device_hlp
        ret

FreeLIDentry ENDP ;returns error code or zero if no error

;WORD DeviceBlockLen(wLID);

; ASSUME DS = DGROUP, called from 'C' initialization code only
GetDeviceBlockLen PROC FAR C USES bx cx dx di ds gs, wLID:WORD

;  int 3
     SetDS    RDGROUP
        mov     ax,wLID
        mov     dx,DevHlp_GetDeviceBlock
        call    device_hlp
        mov     ax,0
        jc      exit

     SetDS    DGROUP
        sub     sp,6                    ;API expects to pop 12 words
        push    cx
        push    dx
        push    GET_DEVBLK_LEN
        call    DWORD PTR _Ring0Vector
exit:
        ret

GetDeviceBlockLen ENDP

;WORD DeviceBlockOffset(WORD wLID);

; ASSUME DS = DGROUP, called from 'C' initialization code only
GetDeviceBlockOffset PROC FAR C USES bx cx dx di ds, wLID:WORD

    SetDS     RDGROUP
        mov     ax,wLID
        mov     dx,DevHlp_GetDeviceBlock
        call    device_hlp
        mov     ax,0
        jc      exit

        mov     ax,dx
exit:
        ret

GetDeviceBlockOffset ENDP

;WORD GetDeviceDefinition(DEVDEF *pstDevice);

; ASSUME DS = DGROUP, called from 'C' initialization code only
GetDeviceAddress PROC FAR C USES bx cx dx di ds gs, wLID:WORD

;  int 3
     SetDS    RDGROUP
        mov     ax,wLID
        mov     dx,DevHlp_GetDeviceBlock
        call    device_hlp
        mov     ax,0
        jc      exit

     SetDS    DGROUP
        sub     sp,6                    ;API expects to pop 12 words
        push    cx
        push    dx
        push    GET_BASE_ADDR
        call    DWORD PTR _Ring0Vector
exit:
        ret

GetDeviceAddress ENDP

;WORD GetKernalData(WORD wLID,WORD wSrcOffset,BYTE *pwDest,WORD wCount);

; ASSUME DS = DGROUP, called from 'C' initialization code only
GetKernalData PROC FAR C USES bx cx dx di es ds gs, wLID:WORD, wSrcOffset:WORD, pwDest:WORD, wCount:WORD

;  int 3
     SetDS    RDGROUP
        mov     ax,wLID
        mov     dx,DevHlp_GetDeviceBlock
        call    device_hlp
        mov     ax,0
        jc      exit

        push    cx
        mov     ax,cx
        mov     dx,DevHlp_GetDescInfo
        call    device_hlp
        pop     cx
        jc      exit

        mov     ax,wCount
        sub     dx,wSrcOffset
        cmp     ax,dx
        jbe     @f
        mov     ax,dx
@@:
     SetDS    DGROUP
        push    ax
        push    ax
        push    ds
        mov     ax,pwDest
        push    ax
        push    cx
        mov     ax,wSrcOffset
        push    ax
        push    GET_KERNAL_DATA
        call    DWORD PTR _Ring0Vector
        pop     ax
exit:
        ret

GetKernalData ENDP

_TEXT ENDS

  END
