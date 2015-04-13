;************************************************************************
;
;  Small model variable argument functions for use with small model sprintf
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
    INCLUDE HDW.INC
.LIST

_TEXT SEGMENT
    ASSUME CS:SCGROUP

;void vaArgStart(USHORT _far *pArgMarker,void *pLastArgAddr);
vaStart PROC C USES ax si es, pArgMarker:DWORD, pLastArgAddr:PTR

        les     si,pArgMarker
        mov     ax,WORD PTR pLastArgAddr
        add     ax,2
        mov     ES:[si],ax
        ret

vaStart ENDP

;int vaArgValue(USHORT _far *pArgMarker,WORD wSize);
vaArgValue PROC C USES bx si es, pArgMarker:DWORD, wSize:WORD

        les     si,pArgMarker
        mov     bx,ES:[si]
        cmp     wSize,1
        jne     @f
        mov     al,SS:[bx]
        xor     ah,ah
        inc     bx
        jmp     exit
@@:
        cmp     wSize,2
        jne     @f
        mov     ax,SS:[bx]
        add     bx,2
        jmp     exit
@@:
        mov     ax,SS:[bx]
        add     bx,2
        mov     dx,SS:[bx]
        add     bx,2
exit:
        mov     ES:[si],bx
        ret

vaArgValue ENDP

;void *vaArgAddr(USHORT _far *pArgMarker,WORD wSize);
vaArgAddr PROC C USES bx si es, pArgMarker:DWORD, wSize:WORD

        les     si,pArgMarker
        mov     bx,[si]
        cmp     wSize,4
        jbe     @f
        mov     ax,SS:[bx]
        add     bx,2
        jmp     exit
@@:
        mov     ax,SS:[bx]
        add     bx,2
        mov     dx,SS:[bx]
        add     bx,2
exit:
        add     ES:[si],bx
        ret

vaArgAddr ENDP

_TEST ENDS

  END
