;************************************************************************
;
; $Revision:   1.6  $
;
; $Log:   P:/archive/comi/MACRO.INV  $
;
;   Rev 1.6   28 Mar 1996 00:19:22   EMMETT
;Added resource manager.  Began work on VDD support.
;
;   Rev 1.5   21 Feb 1996 12:08:28   EMMETT
;Fixed COMscope buffer access for DosDevIOCtl function calls
;so that single byte transfers of packet data would not make write
;pointer odd.
;
;   Rev 1.4   19 Feb 1996 10:48:10   EMMETT
;Added many features, notably:
;Added trace of DosDevOICtl function calls and packets.
;Added 16650 and 16750 support.
;Streamlined interrupt routine.
;
;   Rev 1.3   28 Jun 1994 09:11:44   EMMETT
;Changed RTStoggleOn macro to include OutByte instruction.
;
;   Rev 1.2   07 Jun 1994 00:19:18   EMMETT
;Added support for DigiBoard.
;Added initialization support for OEM specific loads.
;Fixed bug in StartWriteStream and ProcessModemSignals that caused handshaking problems.
;Fixed hardware tests to set baud rate before testing interrupts.
;Fixed hardware tests off switch to work only for retail version.
;
;   Rev 1.1   27 Apr 1994 22:56:34   EMMETT
;FIxed ABIOS stuff to work better than before.
;
;   Rev 1.0   16 Apr 1994 08:35:22   EMMETT
;Initial version control archive.
;
;************************************************************************

;   MACRO.INC

;   This file contains MACRO definitions

VerifyPacketData MACRO
    LOCAL get_data
    LOCAL exit

; if CX equals zero then use value in GIOdataLength
        or      cx,cx
        jnz     get_data

; if GIOdataLength equals zero then return error
        cmp     ES:[di].s_stPacket.GIOpacket.GIOdataLength,0
        je      error

        mov     cx,ES:[di].s_stPacket.GIOpacket.GIOdataLength

get_data:
        push    di
        lea     bx,pDataAddress
        mov     ax,ES:[di].s_stPacket.GIOpacket.GIOdataOffset + 2
        mov     di,ES:[di].s_stPacket.GIOpacket.GIOdataOffset
        mov     SS:[bx+2],ax
        mov     SS:[bx],di

        mov     dh,DH_VA_READ_WRT_ACCESS        ;verify for read/write access
        mov     dl,DevHlp_VerifyAccess          ;carry set if access denied
        call    device_hlp
        pop     di
        jc      error
exit:
        ENDM

VerifyPacketParams MACRO
    LOCAL get_params
    LOCAL exit

; if CX equals zero then use value in GIOparamLength
        or      cx,cx
        jnz     get_params

; if GIOparamLength equals zero then return error
        cmp     ES:[di].s_stPacket.GIOpacket.GIOparamLength,0
        je      error

        mov     cx,ES:[di].s_stPacket.GIOpacket.GIOparamLength

get_params:
        push    di
        lea     bx,pParamAddress
        mov     ax,ES:[di].s_stPacket.GIOpacket.GIOparamOffset + 2
        mov     di,ES:[di].s_stPacket.GIOpacket.GIOparamOffset
        mov     SS:[bx+2],ax
        mov     SS:[bx],di

        mov     dh,DH_VA_READ_ACCESS            ; verify for read access
        mov     dl,DevHlp_VerifyAccess          ; carry set if access denied
        call    device_hlp
        pop     di
        jc      error
exit:
        ENDM

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

 IFDEF NO_COMscope
COMscopeStream MACRO IndexREG, wTestFlag, byFunction
     ENDM
 ELSE
COMscopeStream MACRO IndexREG, wTestFlag, byFunction
     LOCAL no_wrap
     LOCAL no_trace
     LOCAL store_local_buf
     LOCAL test_wrap

        test    [si].s_stDeviceParms.fCOMscopeFunction,wTestFlag
        jz      no_trace
        mov     ah,byFunction
        mov     IndexREG,[si].s_stDeviceParms.dwCOMscopeQWrtPtr
;        test_DeviceFlag2 DEV_FLAG2_USE_DD_DATA_SEGMENT
;        jnz     store_local_buf
        mov     FS:[IndexREG],ax
;        jmp     test_wrap

;store_local_buf:
;        mov     [IndexREG],ax

test_wrap:
        cmp     IndexREG,[si].s_stDeviceParms.dwCOMscopeBuffExtent
        jb      no_wrap
        mov     IndexREG,[si].s_stDeviceParms.oCOMscopeBuff
        sub     IndexREG,2

no_wrap:
        add     IndexREG,2
        mov     [si].s_stDeviceParms.dwCOMscopeQWrtPtr,IndexREG

no_trace:
        ENDM
  ENDIF ; NO_COMscope

StoreError MACRO pdwErrorCode,byErrorCode

        push    bx
        mov     bx,pdwErrorCode
        mov     BYTE PTR SS:[bx],byErrorCode
        pop     bx
        ENDM

;SI = offset to device parameters
; assumes DX = base I/O address
RTStoggleOn MACRO IndexREG
        LOCAL exit

        test    [si].s_stDeviceParms.wDeviceFlag1,DEV_FLAG1_RTS_TOG_ENABLED
        jz      exit
        test    [si].s_stDeviceParms.wDeviceFlag1,DEV_FLAG1_RTS_TOG_ON
        jnz     exit

        mov     [si].s_stDeviceParms.wRTScount,DEFAULT_RTS_OFF_DELAY
        or      [si].s_stDeviceParms.wDeviceFlag1,DEV_FLAG1_RTS_TOG_ON
        add     dx,MDM_CTL_REG_OFFSET
        push    ax
        InByteImm
        or      al,MDM_CTL_RTS_ACTIVATE

        COMscopeStream IndexREG, CSFUNC_TRACE_MODEM_OUT_SIGNALS, CS_MODEM_OUT
        OutByteDel IndexREG
        pop     ax
        sub     dx,MDM_CTL_REG_OFFSET

exit:
        ENDM

;SI = offset to device parameters
; loads DX from device parameters
RTStoggleOnLoadDX MACRO IndexREG
        LOCAL exit

        test    [si].s_stDeviceParms.wDeviceFlag1,DEV_FLAG1_RTS_TOG_ENABLED
        jz      exit
        test    [si].s_stDeviceParms.wDeviceFlag1,DEV_FLAG1_RTS_TOG_ON
        jnz     exit

        mov     [si].s_stDeviceParms.wRTScount,DEFAULT_RTS_OFF_DELAY
        or      [si].s_stDeviceParms.wDeviceFlag1,DEV_FLAG1_RTS_TOG_ON
        push    dx
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,MDM_CTL_REG_OFFSET
        push    ax
        InByteImm
        or      al,MDM_CTL_RTS_ACTIVATE

        COMscopeStream IndexREG, CSFUNC_TRACE_MODEM_OUT_SIGNALS, CS_MODEM_OUT
        OutByteDel IndexREG
        pop     ax
        pop     dx

exit:
        ENDM

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

BlockYield MACRO ID_high, ID_low, Count:=<100>

        push    dx
        push    bx
        push    ax
        push    di
        push    cx
        mov     bx,ID_high
        mov     ax,ID_low
        xor     di,di
        mov     cx,Count
        xor     dh,dh
        mov     dl,DevHlp_Block
        call    device_hlp
        pop     cx
        pop     di
        pop     ax
        pop     bx
        pop     dx
        ENDM
