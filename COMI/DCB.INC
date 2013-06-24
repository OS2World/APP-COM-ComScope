;************************************************************************
;
; $Revision:   1.7  $
;
; $Log:   P:/archive/comi/dcb.inv  $
;
;   Rev 1.7   28 Mar 1996 00:20:00   EMMETT
;Added resource manager.  Began work on VDD support.
;
;   Rev 1.6   19 Feb 1996 10:48:14   EMMETT
;Added many features, notably:
;Added trace of DosDevOICtl function calls and packets.
;Added 16650 and 16750 support.
;Streamlined interrupt routine.
;
;   Rev 1.5   25 Apr 1995 22:16:26   EMMETT
;Added Support for DigiBoard PC/16.  Changed interrupt Routine for better adapter independence.
;Changed interrupt routine to allow user to select interrupting device selection algorithim.  Fixed
;ABIOS interaction for better "non.INI" initialization in MCA machines.  Fixed various initialization
;message strings.  COMscope and receive buffer are now allocated from system memory, allowing
;a 32k (word) COMscope buffer and a 64k (byte) receive buffer.
;
;   Rev 1.4   03 Jul 1994 16:00:24   EMMETT
;Changed defaults to 9600,n,8,1 with NO handshaking enabled.
;
;   Rev 1.3   11 Jun 1994 10:37:38   EMMETT
;Changed all references to "Mirror" to "COMscope".
;
;   Rev 1.2   07 Jun 1994 00:18:58   EMMETT
;Added support for DigiBoard.
;Added initialization support for OEM specific loads.
;Fixed bug in StartWriteStream and ProcessModemSignals that caused handshaking problems.
;Fixed hardware tests to set baud rate before testing interrupts.
;Fixed hardware tests off switch to work only for retail version.
;
;   Rev 1.1   27 Apr 1994 22:56:16   EMMETT
;FIxed ABIOS stuff to work better than before.
;
;   Rev 1.0   16 Apr 1994 08:35:08   EMMETT
;Initial version control archive.
;
;************************************************************************

;   DCB.INC

;   Device Control Block Structure, bit and constant definitions

s_stLineSetupBlock    STRUCT
     DataBit     WORD  0
     Parity      WORD  0
     StopBit     WORD  0
s_stLineSetupBlock    ENDS

s_stDCB STRUCT
     WrtTimeout                WORD   ?
     RdTimeout                 WORD   ?
     Flag1                     BYTE   ?
     Flag2                     BYTE   ?
     Flag3                     BYTE   ?
     ErrorChar                 BYTE   ?
     BreakChar                 BYTE   ?
     XonChar                   BYTE   ?
     XoffChar                  BYTE   ?
s_stDCB ENDS

; DCB flag bit definitions

; Flags1

; bit 7   = Unused

; bit 6   = enable DSR input Handshaking

; bit 5   = enable DCD output Handshaking

; bit 4   = enable DSR output Handshaking

; bit 3   = enable CTS output Handshaking

; bit 2   = Unused

; bit 0-1 = DTR Control Mode
;  BR1 BR0
;   0   0  Disable
;   0   1  Enable
;   1   0  Input Handshaking
;   1   1  Output Handshaking

F1_ENABLE_HS_MASK          EQU 01111010B    ;7ah
F1_DTR_HS_MASK             EQU 00000011B    ;03h

F1_DISABLE_DTR             EQU 00000000B    ;00h
F1_ENABLE_DTR              EQU 00000001B    ;01h
F1_ENABLE_DTR_INPUT_HS     EQU 00000010B    ;02h

F1_ENABLE_DSR_INPUT_HS     EQU 01000000B    ;40h

F1_HDW_OUTPUT_HS_MASK      EQU 00111000B    ;38h
F1_ENABLE_DCD_OUTPUT_HS    EQU 00100000B    ;20h
F1_ENABLE_DSR_OUTPUT_HS    EQU 00010000B    ;10h
F1_ENABLE_CTS_OUTPUT_HS    EQU 00001000B    ;08h

;F1_DEFAULT                 EQU F1_ENABLE_DTR
F1_DEFAULT                 EQU 0

; Flags2

; bit 6-7 = RTS Control Mode
;  BR7 BR6
;   0   0  Disable
;   0   1  Enable
;   1   0  Input Handshaking
;   1   1  Toggling on Transmit

; bit 5   = Automatic Recevice Flow Control
;       0 = Normal
;       1 = Full_Duplex

; bit 4   = enable break replacement
; bit 3   = enable NULL striping
; bit 2   = enable error Replacement
; bit 1   = enable automatic receive flow control (Xon/Xoff)
; bit 0   = enable automatic transmit flow control (Xon/Xoff)


F2_RTS_HS_MASK                  EQU 11000000B   ;c0h

F2_DISABLE_RTS                  EQU 00000000B   ;00h
F2_ENABLE_RTS                   EQU 01000000B   ;40h
F2_ENABLE_RTS_INPUT_HS          EQU 10000000B   ;80h
F2_ENABLE_RTS_TOG_ON_XMIT       EQU 11000000B   ;c0h

F2_ENABLE_FULL_DUPLEX           EQU 00100000B   ;20h

F2_ENABLE_BREAK_REPL            EQU 00010000B   ;10h
F2_ENABLE_NULL_STRIP            EQU 00001000B   ;08h
F2_ENABLE_ERROR_REPL            EQU 00000100B   ;04h

F2_ENABLE_XON_XOFF_MASK         EQU 00000011B   ;03h

F2_ENABLE_RCV_XON_XOFF_FLOW     EQU 00000010B   ;02h
F2_ENABLE_XMIT_XON_XOFF_FLOW    EQU 00000001B   ;01h

;F2_DEFAULT                      EQU F2_ENABLE_RTS
F2_DEFAULT                      EQU 0

; Flags3

; bit 7    = Transmit Buffer Load Count

; bits 5-6 = receive trigger level
;  BR6 BR5
;   0   0  = one character
;   0   1  = four characters
;   1   0  = eight characters
;   1   1  = fourteen characters

; bits 3-4 = Extended Hardware Buffering
;  BR4 BR3
;   0   0  = not supported - ignored - no change to fifo mode
;   0   1  = extended hardware buffering disabled
;   1   0  = extended hardware buffering enabled
;   1   1  = automatic protocol override

; bits 1-2 = Read Timeout Processing
;  BR2 BR1
;   0   0  = Invalid
;   0   1  = Normal read timeout processing
;   1   0  = Wait for something, read timeout processing
;   1   1  = No wait, read timeout processing

; bit 0    = Enable infinite write timeout processing

F3_USE_TX_BUFFER                EQU 10000000B   ;80h

F3_RECEIVE_TRIG_MASK            EQU 01100000B   ;60h

F3_1_CHARACTER_FIFO             EQU 00000000B   ;00h
F3_4_CHARACTER_FIFO             EQU 00100000B   ;20h
F3_8_CHARACTER_FIFO             EQU 01000000B   ;40h
F3_14_CHARACTER_FIFO            EQU 01100000B   ;60h

F3_HDW_BUFFER_MASK              EQU 00011000B   ;18h

F3_NO_FIFO_CHANGE               EQU 00000000B   ;00H
F3_HDW_BUFFER_DISABLE           EQU 00001000B   ;08h
F3_HDW_BUFFER_ENABLE            EQU 00010000B   ;08h
F3_HDW_BUFFER_APO               EQU 00011000B   ;18h

F3_READ_TIMEOUT_MASK            EQU 00000110B   ;06h

F3_WAIT_NORM                    EQU 00000010B   ;02h
F3_WAIT_NONE                    EQU 00000110B   ;06h
F3_WAIT_SOMETHING               EQU 00000100B   ;04h

F3_INFINITE_WRT_TIMEOUT         EQU 00000001B   ;01h

F3_DEFAULT                      EQU F3_WAIT_NORM OR \
                                    F3_HDW_BUFFER_ENABLE OR \
                                    F3_USE_TX_BUFFER OR \
                                    F3_8_CHARACTER_FIFO

s_stDeviceParms  STRUCT
     wSignature                 WORD   55aah
     wDeviceFlag1               WORD   0                               ;0
     wDeviceFlag2               WORD   0                               ;2
     wDeviceFlag3               WORD   0                               ;4

     wConfigFlags1              WORD   0                               ;6
     wConfigFlags2              WORD   0                               ;8

     wWrtBufferLength           WORD   DEF_WRITE_BUFF_LEN              ;10
     wWrtBufferExtent           WORD   DEF_WRITE_BUFF_LEN - 1          ;12
     dwReadBufferLength         DWORD  DEF_READ_BUFF_LEN               ;14
     dwReadBufferExtent         DWORD  DEF_READ_BUFF_LEN - 1           ;18
  IFNDEF NO_COMscope
     dwCOMscopeBuffLen          DWORD  DEF_COMscope_BUFF_LEN           ;22
     dwCOMscopeBuffExtent       DWORD  DEF_COMscope_BUFF_LEN - 2       ;26
  ENDIF
     wWrtTimeout                WORD   DEFAULT_WRITE_TIMEOUT           ;30
     wRdTimeout                 WORD   DEFAULT_READ_TIMEOUT            ;32
     wBaudRateDivisor           WORD   DEFAULT_BAUD_DIVISOR            ;34
     dwBaudRate                 DWORD  DEFAULT_BAUD                    ;36
     byMaxWritePktCount         BYTE   DEFAULT_WRITE_PKT_QUEUE         ;40
     byMaxReadPktCount          BYTE   DEFAULT_READ_PKT_QUEUE          ;41

     byFlag1                    BYTE   F1_DEFAULT                      ;42
     byFlag2                    BYTE   F2_DEFAULT                      ;43
     byFlag3                    BYTE   F3_DEFAULT                      ;44
     byErrorChar                BYTE   0                               ;45
     byBreakChar                BYTE   0                               ;46
     byXonChar                  BYTE   11h                             ;47
     byXoffChar                 BYTE   13h                             ;48
     byImmediateByte            BYTE   0                               ;49
     wXonThreshold              WORD   DEF_READ_BUFF_LEN / 2           ;50
     wXoffThreshold             WORD   20h                             ;52
     wRTS_DTRoffDelay           WORD   DEFAULT_RTS_OFF_DELAY           ;54

     wIObaseAddress             WORD   0                               ;56
     wIntIDregister             WORD   0                               ;58
     byInterruptLevel           BYTE   0                               ;60
     byDataLengthMask           BYTE   DEFAULT_DATA_LEN_MASK           ;61

     wDefWrtTimeout             WORD   DEFAULT_WRITE_TIMEOUT           ;62
     wDefRdTimeout              WORD   DEFAULT_READ_TIMEOUT            ;64
     byDefXonChar               BYTE   11h                             ;66
     byDefXoffChar              BYTE   13h                             ;67
     byDefErrorChar             BYTE   0                               ;68
     byDefBreakChar             BYTE   0                               ;69
     wDefXoffThreshold          WORD   0                               ;70
     wDefXonThreshold           WORD   0                               ;72
  IFNDEF NO_COMscope
     fCOMscopeFunction          WORD   0                               ;74
  ENDIF
     wCOMevent                  WORD   0                               ;76
     wCOMerror                  WORD   0                               ;78
     wDeviceStatus1             WORD   (DEV_ST1_QUEUE_INIT OR DEV_ST1_INIT);80
     wDeviceStatus2             WORD   0                               ;82
     wInterruptStatus           WORD   0                               ;84
     wOpenCount                 WORD   0                               ;86

  IFNDEF NO_COMscope
     wCOMscopeSelector          WORD   RDGROUP                         ;88
  ENDIF
  IFNDEF x16_BIT
     wRdBuffSelector            WORD   RDGROUP                         ;90
  ENDIF
     wXmitQueueCount            WORD   0                               ;92
     wXmitQueueReadPointer      WORD   0                               ;94
     oWriteBuffer               WORD   0                               ;96
     wWrtTimerCount             WORD   0                               ;98
     wWriteTimerStart           WORD   0                               ;100
     dwRdSemaphore              DWORD  0                               ;102
     dwWrtSemaphore             DWORD  0                               ;106
     dwWriteReqPktQueueHead     DWORD  0                               ;110
     dwReadReqPktQueueHead      DWORD  0                               ;114

     wTxFIFOdepth               WORD   1                               ;118
     wUserTxFIFOdepth           WORD   1                               ;116
     wRTScount                  WORD   0                               ;122
     wReadByteCount             WORD   0                               ;124
     dwReceiveQueueWritePointer DWORD  0                               ;128
     dwReceiveQueueReadPointer  DWORD  0                               ;132
     oReadBuffer                DWORD  0                               ;134
  IFNDEF NO_COMscope
     dwCOMscopeQWrtPtr          DWORD  0                               ;138
     dwCOMscopeQRdPtr           DWORD  0                               ;142
     oCOMscopeBuff              DWORD  0                               ;146
  ENDIF
     wRdTimerCount              WORD   0                               ;150
     wReadTimerStart            WORD   0                               ;152
     wFIFOcontrolImage          WORD   0                               ;154
     xBaudMultiplier            BYTE   0                               ;156
     byMSRimage                 BYTE   0                               ;157
     byReadPktQHead             BYTE   0                               ;158
     byReadPktQTail             BYTE   0                               ;159
     bySNAalertFlags            BYTE   0                               ;160
     byFlag2Mask                BYTE   0                               ;161
     byDefFlag3                 BYTE   0                               ;162
     byHSstatus                 BYTE   0                               ;163
     byWritePktQHead            BYTE   0                               ;164
     byWritePktQTail            BYTE   0                               ;165
  IFNDEF x16_BIT
     dwReceiveCount             DWORD  0                               ;166
     dwTransmitCount            DWORD  0                               ;170
     wWrtBufferHigh             WORD   0                               ;174
     dwReadBufferHigh           DWORD  0                               ;178
     wWrtBufferLevel            WORD   0                               ;180
     dwReadBufferLevel          DWORD  0                               ;182
   IFDEF VDD_support
     wVDDflags                  WORD   0                               ;186
   ENDIF
  ENDIF
     stDeviceHeader       s_stDeviceHeader <>                          ;188
  IFNDEF NO_COMscope
     stCOMscopeHeader     s_stDeviceHeader <>
  ENDIF
s_stDeviceParms  ENDS

INI_BLOCK_SIZE EQU stDeviceParms - IniBlock

; HSstatus - set to match COM status bits IOCntl #64h

TX_WAITING_MASK                 EQU 3fh
TX_WAITING_SIGNAL               EQU 0fh   ; transmit waiting for external signal

TX_WAITING_MODEM_MASK           EQU 07h

TX_WAITING_HDW_MASK             EQU 27h

TX_WAITING_FOR_CTS_ON           EQU 01h
TX_WAITING_FOR_DSR_ON           EQU 02h
TX_WAITING_FOR_DCD_ON           EQU 04h
TX_WAITING_BECAUSE_XOFF_RX      EQU 08h
TX_WAITING_BECAUSE_XOFF_TX      EQU 10h
TX_WAITING_BECAUSE_BREAK_RX     EQU 20h

RX_WAITING_MASK                 EQU 80h

TX_IMM_BYTE_AVAILABLE           EQU 40h
RX_WAITING_FOR_DSR_ON           EQU 80h

;---------- COMMERR error codes ---------

COMERR_RCV_QUEUE_OVERRUN        EQU 01h
COMERR_RCV_HDW_OVERRUN          EQU 02h
COMERR_PARITY_ERROR             EQU 04h
COMERR_FRAMING_ERROR            EQU 08h

; COM event bits

; user mode bit definitions

COM_EVENT_COM_ERROR     EQU 0080h
COM_EVENT_BREAK_DETECT  EQU 0040h
COM_EVENT_DELTA_TRI     EQU 0100h
COM_EVENT_DELTA_DCD     EQU 0020h
COM_EVENT_DELTA_DSR     EQU 0010h
COM_EVENT_DELTA_CTS     EQU 0008h
COM_EVENT_LAST_BYTE     EQU 0004h
COM_EVENT_RCV_TO        EQU 0002h
COM_EVENT_RCV_BYTE      EQU 0001h

; ConfigFlags1 bits

CFG_FLAG1_FORCE_4X_TEST          EQU  0001h
;CFG_FLAG1_SCRATCH_IS_INT_ID      EQU  0001h
;CFG_FLAG1_DIGIBOARD08_INT_ID     EQU  0002h
;CFG_FLAG1_DIGIBOARD16_INT_ID     EQU  0004h
CFG_FLAG1_TIB_UART               EQU  0008h
;CFG_FLAG1_INT_ID_LOAD_MASK       EQU  000fh

  IFNDEF x16_BIT
CFG_FLAG1_NORMALIZE_BAUD         EQU  0010h
  ENDIF
;CFG_FLAG1_USE_HDW_HS             EQU  0020h

  IFNDEF NO_COMscope
CFG_FLAG1_COMSCOPE               EQU  0040h
  ENDIF
CFG_FLAG1_EXPLICIT_BAUD_DIVISOR  EQU  0080h
CFG_FLAG1_EXT_MODEM_CTL          EQU  0100h
CFG_FLAG1_EXT_ENABLED            EQU  0200h
CFG_FLAG1_NO_BREAK_REPORT        EQU  0400h
CFG_FLAG1_NO_MODEM_INT           EQU  0800h
CFG_FLAG1_TESTS_DISABLE          EQU  1000h
CFG_FLAG1_FOREIGN_UART           EQU  2000h
CFG_FLAG1_MULTI_INT              EQU  4000h
CFG_FLAG1_EXCLUSIVE_ACCESS       EQU  8000h


  IFNDEF NO_ADV_UARTS
    IFNDEF NO_16650_Xon_HS_support
CFG_FLAG2_HDW_TX_XON_HS          EQU  00100h   ; these must match FIFO_FLG bits
CFG_FLAG2_HDW_RX_XON_HS          EQU  00200h
CFG_FLAG2_HDW_XON_MASK           EQU  00330h
    ENDIF
CFG_FLAG2_HDW_CTS_HS             EQU  00400h
CFG_FLAG2_HDW_RTS_HS             EQU  00800h
CFG_FLAG2_HDW_CTS_RTS_MASK       EQU  00cc0h

    IFNDEF NO_16650_Xon_HS_support
CFG_FLAG2_HDW_TX_XON_WAS         EQU  00010h
CFG_FLAG2_HDW_RX_XON_WAS         EQU  00020h
    ENDIF
CFG_FLAG2_HDW_CTS_WAS            EQU  00040h
CFG_FLAG2_HDW_RTS_WAS            EQU  00080h
CFG_FLAG2_HDW_WAS_MASK           EQU  000f0h

CFG_FLAG2_ALLOW16750RTSCTL       EQU  00001h
  ENDIF

CFG_FLAG2_ACTIVATE_OUT1          EQU  00002h

CFG_FLAG2_EXPLICIT_TX_LOAD       EQU  04000h
CFG_FLAG2_LOW_16750_TRIG         EQU  08000h
CFG_FLAG2_NO_DCB_UPDATE          EQU  02000h
CFG_FLAG2_FIFO_MASK              EQU  0e000h

; DeviceStatus bits - includes I/O buffer state and I/O blocked states

DEV_ST1_INIT                 EQU 0000h

DEV_ST1_RCV_BLOCKED          EQU 8000h
DEV_ST1_TIMER_ALLOCATED      EQU 4000h
DEV_ST1_INPUT_FLUSHED        EQU 2000h
DEV_ST1_OUTPUT_FLUSHED       EQU 1000h

DEV_ST1_DEVICE_OPEN          EQU 0400h
DEV_ST1_RCV_TIMED_OUT        EQU 0200h
DEV_ST1_XMIT_TIMED_OUT       EQU 0100h
DEV_ST1_RX_IN_PROGRESS       EQU 0008h
DEV_ST1_TX_IN_PROGRESS       EQU 0004h
DEV_ST1_DEACTIVATE_DTR       EQU 0002h
DEV_ST1_LAST_CHAR_RCVD       EQU 0080h

DEV_ST1_RCV_QUEUE_FULL       EQU 0001h   ;set to match COMerror bit assignment
DEV_ST1_XMIT_QUEUE_EMPTY     EQU 0010h
DEV_ST1_XMIT_QUEUE_FULL      EQU 0020h
DEV_ST1_RCV_QUEUE_EMPTY      EQU 0040h

DEV_ST1_QUEUE_INIT           EQU 0050h  ;rcv buffer empty and xmit buffer empty

DEV_ST2_RESTARTSTREAM        EQU 0001h

; DeviceFlags bits

DEV_FLAG1_INPUT_HS_MASK               EQU  0e000h      ;11100000-00000000B

DEV_FLAG1_HDW_INPUT_HS_MASK           EQU  06000h      ;01100000-00000000B

DEV_FLAG1_RTS_INPUT_HS                EQU  04000h      ;01000000-00000000B
DEV_FLAG1_DTR_INPUT_HS                EQU  02000h      ;00100000-00000000B

DEV_FLAG1_XON_XOFF_HS_MASK            EQU  09000h      ;10010000-00000000B

DEV_FLAG1_INPUT_XON_XOFF_HS           EQU  08000h      ;10000000-00000000B
DEV_FLAG1_OUTPUT_XON_XOFF_HS          EQU  01000h      ;00010000-00000000B

DEV_FLAG1_INPUT_HS_IN_PROGRESS        EQU  00400h      ;00000100-00000000B

DEV_FLAG1_RTS_TOG_ON                  EQU  00200h      ;00000010-00000000B
DEV_FLAG1_RTS_TOG_ENABLED             EQU  00100h      ;00000001-00000000B

DEV_FLAG1_EVENT_RCV_BYTE              EQU  00800h      ;00001000-00000000B
DEV_FLAG1_EVENT_XOFF_SENT             EQU  00010h      ;00000000-00010000B
DEV_FLAG1_EVENT_FIFO_LAST             EQU  00020h      ;00000000-00100000B
  IFNDEF NO_COMscope
DEV_FLAG1_COMSCOPE_OPEN               EQU  00040h
  ENDIF
DEV_FLAG1_WRT_BLOCKED                 EQU  00080h
DEV_FLAG1_MDM_INT_ENABLED             EQU  00008h
DEV_FLAG1_IMM_BYTE_WAITING            EQU  00002h
  IFNDEF SHARE
DEV_FLAG1_PAGER_OPEN                  EQU  00001h
  ENDIF

DEV_FLAG2_16650_UART                  EQU  00001h
DEV_FLAG2_16750_UART                  EQU  00002h
DEV_FLAG2_16654_UART                  EQU  00004h
DEV_FLAG2_TI16550C_UART               EQU  00008h
DEV_FLAG2_TIB_UART                    EQU  00010h
  IFNDEF NO_4x_CLOCK_SUPPORT
;DEV_FLAG2_4X_BAUD_CLOCK               EQU  00800h
DEV_FLAG2_FORCE_4X_TEST               EQU  00400h
  ENDIF

DEV_FLAG2_USE_DD_DATA_SEGMENT         EQU  01000h
DEV_FLAG2_FIFO_AVAILABLE              EQU  02000h
DEV_FLAG2_DEVICE_DEINSTALLED          EQU  04000h
DEV_FLAG2_PCMCIA_PORT                 EQU  08000h

DEV_FLAG2_SAVE_MSR                    EQU  00100h
DEV_FLAG2_MONITOR_CTS                 EQU  00200h

; VDD flags

VDD_FLG_NO_IRQ                          EQU 00001h
VDD_FLG_PORT_IN_USE                     EQU 00002h
