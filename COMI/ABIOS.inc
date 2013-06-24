;************************************************************************
;
; $Revision:   1.4  $
;
; $Log:   P:/archive/comi/abios.inv  $
;
;   Rev 1.4   19 Feb 1996 10:48:12   EMMETT
;Added many features, notably:
;Added trace of DosDevOICtl function calls and packets.
;Added 16650 and 16750 support.
;Streamlined interrupt routine.
;
;   Rev 1.3   03 Dec 1994 14:38:28   EMMETT
;Added items necessary for various upgrates and fixes. duh!
;
;   Rev 1.2   27 Apr 1994 22:55:26   EMMETT
;FIxed ABIOS stuff to work better than before.
;
;   Rev 1.1   18 Apr 1994 23:17:14   EMMETT
;Changed ABIOS processing and added ability to disallow a port to initialize.
;
;   Rev 1.0   16 Apr 1994 08:34:50   EMMETT
;Initial version control archive.
;
;************************************************************************

;   ABIOS.INC

;   This file contains ABIOS structure and constant definitions

; LID access constants (GetLIDEntry, FreeLIDEntry)

ASYNC_DEV_ID            equ 06h
POS_DEV_ID              equ 10h
NON_DMA_DEV             equ 00h
DMA_POS_DEV             equ 01h

; error return codes

MSG_MEMORY_ALLOCATION_FAILED   EQU 0
ERROR_LID_ALREADY_OWNED        EQU 1
ERROR_LID_DOES_NOT_EXIST       EQU 2
ERROR_ABIOS_NOT_PRESENT        EQU 3
ERROR_NOT_YOUR_LID             EQU 4
ERROR_INVALID_ENTRY_POINT      EQU 5

; ABIOSCall access constants

ABIOS_START_ENTRY       equ 00H
ABIOS_INTERRUPT_ENTRY   equ 01H
ABIOS_TIMEOUT_ENTRY     equ 02H

; error return codes

ABIOS_NOT_PRESENT       equ 01h
ABIOS_UKN_COMMAND       equ 02h

; ABIOS functions

ABIOS_FNC_DEF_INT               equ 00h
ABIOS_FNC_RET_LID_PARMS         equ 01h
ABIOS_FNC_READ_DEV_PARMS        equ 03h
ABIOS_FNC_SET_DEV_PARMS         equ 04h
ABIOS_FNC_INIT_DEV              equ 05h
ABIOS_FNC_INT_ENABLE            equ 06h
ABIOS_FNC_INT_DISABLE           equ 07h
ABIOS_FNC_READ_DEV              equ 08h
ABIOS_FNC_WRT_DEV               equ 09h
ABIOS_FNC_ADD_DATA_XFER         equ 0Ah


; ABIOS function return codes

RC_SUCCESS              equ 00000h
RC_INCOM_STAGE_ON_INT   equ 000001h
RC_INCOM_NOT_MY_INT     equ 00005h
RC_ATTEN_STAGE_ON_INT   equ 00009h
RC_SPURIOUS_INT         equ 00081h
RC_DEVICE_BUSY_REFUSED  equ 08000h
RC_BAD_COMM_PORT        equ 09000h
RC_INVALID_LID          equ 0c000h
RC_INVALID_FUNCTION     equ 0c001h
RC_INVALID_UNIT_NUM     equ 0c003h
RC_INVALID_REQ_BLK_LEN  equ 0c004h

s_stABIOSdeviceBlock STRUCT
        wDeviceBlockLength      WORD ?
        byRevision              BYTE ?
        bySecondaryID           BYTE ?
        wLogicalID              WORD ?
        wDeviceID               WORD ?
        wExclusivePortPairCount WORD ?
        wCommonPortPairCount    WORD ?
        wDataArea               WORD ?
s_stABIOSdeviceBlock ENDS

s_stABIOSserviceParams STRUCT
        wReserved_10             WORD  0
        lDataPointer_1           DWORD 0
        wReserved_16             WORD  0
        wReserved_18             WORD  0
        lDataPointer_2           DWORD 0
s_stABIOSserviceParams ENDS

s_stDeviceData STRUCT
        byHDWinterruptLevel      BYTE 0
        byArbitrationLevel       BYTE 0
        wDeviceID                WORD 0
        wCountOfUnits            WORD 0
        wLogicalIDflags          WORD 0
        wDevRequestBlockLength   WORD 0
        bySecondaryDeviceID      BYTE 0
        byRevision               BYTE 0
        wReserved_1c             WORD 0
        wReserved_1e             WORD 0
        abyDummy_fill            BYTE 10h dup(0)
        bybNullStripping         BYTE 0    ;28h
s_stDeviceData ENDS

s_stABIOSserviceSpecific STRUCT
        wReserved_10            WORD  0
        TransmitBufferOffset    WORD  0    ;12h
        TransmitBufferSegment   WORD  0    ;14h
        reserved_16h            WORD  0
        reserved_18h            DWORD 0
        reserved_1eh            DWORD 0
        reserved_20h            WORD  0
        RecieveBufferOffset     WORD  0    ;22h
        RecieveBufferSegment    WORD  0    ;24h
        reserved_26h            WORD  0
        UNION
          byRecieveTriggerLevel BYTE  0    ;28h
          ModemControl          BYTE  0    ;28h
        ENDS
        AsyncInterruptStatus    BYTE  0    ;29h
        ReceiveTriggerLevel     BYTE  0    ;2ah
        FIFOmodeStatus          BYTE  0    ;2bh
        TransmitBufferLength    WORD  0    ;2ch
        reserved_2eh            WORD  0
        TransmitHeadPointer     WORD  0    ;30h
        reserved_32h            WORD  0
        TransmitTailPointer     WORD  0    ;34h
        reserved_36h            WORD  0
        RecieveBufferLength     WORD  0    ;38h
        reserved_3ah            WORD  0
        RecieveHeadPointer      WORD  0    ;3ch
        reserved_3eh            WORD  0
        RecieveTailPointer      WORD  0    ;40;
        reserved_42h            WORD  0
        TransmitBaudRate        BYTE  0    ;44h
        ParityType              BYTE  0    ;45h
        StopBits                BYTE  0    ;46h
        CharacterBits           BYTE  0    ;47h
        BreakStatus             BYTE  0    ;48h
        LineStatus              BYTE  0    ;49h
        ModemStatus             BYTE  0    ;4ah
        OperationStatus         WORD  0    ;4bh
        PreviousOperationStatus WORD  0    ;4dh
        PreviousReturnCode      WORD  0    ;4fh
        InterruptTypeToCancel   BYTE  0    ;51h
        WorkArea                BYTE  0ah dup(0)
s_stABIOSserviceSpecific ENDS

s_stABIOSrequestBlock     STRUCT
        wRequestBlockLength      WORD  20h
        wLogicalID               WORD  0
        wUnit                    WORD  0
        wFunction                WORD  01
        wReserved_08             WORD  0
        wReserved_0a             WORD  0
        wReturnCode              WORD  0ffffh
        wTimeOut                 WORD  0
        UNION
          s_stDeviceData           {}
          s_stABIOSserviceParams   {}
        ENDS
s_stABIOSrequestBlock ENDS
