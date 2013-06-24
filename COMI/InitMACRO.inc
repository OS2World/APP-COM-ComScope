;************************************************************************
;
; $Revision$
;
; $Log$
;
;************************************************************************

;   INITMACRO.INC

;   This file contains initialization MACRO definitions


AND_DeviceFlag1 MACRO Flags
        and    [si].s_stDeviceParms.wDeviceFlag1,Flags
        ENDM

test_DeviceFlag1 MACRO Flags
        test   [si].s_stDeviceParms.wDeviceFlag1,Flags
        ENDM

OR_DeviceFlag1 MACRO Flags
        or     [si].s_stDeviceParms.wDeviceFlag1,Flags
        ENDM

AND_DeviceFlag2 MACRO Flags
        and    [si].s_stDeviceParms.wDeviceFlag2,Flags
        ENDM

test_DeviceFlag2 MACRO Flags
        test   [si].s_stDeviceParms.wDeviceFlag2,Flags
        ENDM

OR_DeviceFlag2 MACRO Flags
        or     [si].s_stDeviceParms.wDeviceFlag2,Flags
        ENDM

StoreError MACRO pdwErrorCode,byErrorCode

        push    bx
        mov     bx,pdwErrorCode
        mov     BYTE PTR SS:[bx],byErrorCode
        pop     bx

        ENDM

Delay MACRO wDelayTime
        push    ax
        mov     ax,wDelayTime
        mov     wInitTimerCount,ax
        call    DelayFunction
        pop     ax

        ENDM

  IFDEF x16_BIT
WriteByte_10 MACRO Value,Address
        LOCAL   single_digit,done

        push    bx
        mov     al,Value
        mov     bx,Address
        mov     BYTE PTR [bx + 1],' '
        mov     BYTE PTR [bx],' '
        call    binac_10
        cmp     dh,'0'
        je      single_digit
        mov     [bx],dh
        mov     [bx + 1],dl
        jmp     done

single_digit:
        mov     [bx],dl
done:
        pop     bx
        ENDM

WriteByte MACRO Value,Address

        push    bx
        mov     al,Value
        mov     bx,Address
        call    binac
        mov     [bx],dh
        mov     [bx + 1],dl
        pop     bx
        ENDM

WriteWord MACRO Value,Address

        push    bx
        mov     ax,Value
        mov     bx,Address
        call    binac
        mov     [bx + 2],dh
        mov     [bx + 3],dl
        mov     al,ah
        call    binac
        mov     [bx],dh
        mov     [bx + 1],dl
        pop     bx
        ENDM

  ELSE

WriteByte_10 MACRO Value,Address
        LOCAL   single_digit,done

        push    es
        push    bx
        mov     al,Value
        mov     bx,_MESSAGE
        mov     es,bx
        mov     bx,Address
        mov     BYTE PTR ES:[bx] + 1,' '
        mov     BYTE PTR ES:[bx],' '
        call    binac_10
        cmp     dh,'0'
        je      single_digit
        mov     ES:[bx],dh
        mov     ES:[bx] + 1,dl
        jmp     done

single_digit:
        mov     ES:[bx],dl
done:
        pop     bx
        pop     es
        ENDM

WriteByte MACRO Value,Address
        push    es
        push    bx
        mov     al,Value
        mov     bx,_MESSAGE
        mov     es,bx
        mov     bx,Address
        call    binac
        mov     ES:[bx],dh
        mov     ES:[bx] + 1,dl

        pop     bx
        pop     es
        ENDM

WriteWord MACRO Value,Address

        push    es
        push    bx
        mov     ax,Value
        mov     bx,_MESSAGE
        mov     es,bx
        mov     bx,Address
        call    binac
        mov     ES:[bx] + 2,dh
        mov     ES:[bx] + 3,dl
        mov     al,ah
        call    binac
        mov     ES:[bx],dh
        mov     ES:[bx] + 1,dl

        pop     bx
        pop     es
        ENDM
  ENDIF ; NOT x16_BIT

IOdelay MACRO CountReg
   LOCAL loop

 IFNDEF x16_BIT
  IFNDEF DOSIODELAYCNT
    EXTRN DOSIODELAYCNT:ABS
  ENDIF
        mov     CountReg,DOSIODELAYCNT
 ELSE
  IFNDEF _DosIOdelayCount
_DATA SEGMENT WORD PUBLIC USE16 'DATA'
        ASSUME DS:DGROUP
    EXTRN _usDosIOdelayCount:WORD
_DATA ENDS
  ENDIF
        mov     CountReg,_usDosIOdelayCount
 ENDIF

loop:
        dec     CountReg
        jnz     loop

        ENDM

InByteDel MACRO CountReg
        IOdelay CountReg
        in      al,dx
        ENDM

InByteImm MACRO
        in      al,dx
        ENDM

OutByteDel MACRO CountReg
        IOdelay CountReg
        out     dx,al
        ENDM

OutByteImm MACRO
        out     dx,al
        ENDM

SetDS   MACRO data_group
        ASSUME DS:data_group

        push    data_group
        pop     ds
        ENDM

SetGS   MACRO data_group
        ASSUME GS:data_group

        push    data_group
        pop     gs
        ENDM
