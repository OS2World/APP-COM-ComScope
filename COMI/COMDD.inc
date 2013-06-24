;************************************************************************
;
; $Revision: $
;
; $Log: $
;
;************************************************************************
INCL_NOPMAPI    EQU 1
INCL_DOS        EQU 1
INCL_ERRORS     EQU 1
INCL_VIO        EQU 1
INCL_DOSFILEMGR EQU 1
  INCLUDE OS2.INC
;.LIST

  IFNDEF NO_16650_Xon_HS_support
NO_16650_Xon_HS_support EQU 1
  ENDIF

  IFDEF x16_BIT

SHARE                   EQU 1
NO_ADV_UARTS            EQU 1
NO_COMscope             EQU 1
NO_4x_CLOCK_SUPPORT     EQU 1
DD_level                EQU 1
MAX_DEVICE              EQU 8
%ECHO building 16 bit (OS/2 1.x) version

  ELSEIFDEF SHARE_COMscope

SHARE                   EQU 1
NO_ADV_UARTS            EQU 1
NO_4x_CLOCK_SUPPORT     EQU 1
MAX_DEVICE              EQU 4
%ECHO building Personal COMi with COMscope

  ELSEIFDEF SHARE

NO_COMscope             EQU 1
NO_4x_CLOCK_SUPPORT     EQU 1
NO_ADV_UARTS            EQU 1
MAX_DEVICE              EQU 4
%ECHO building Personal COMi without COMscope

  ENDIF

  IFNDEF DD_level
DD_level                EQU 2
  ELSE
%ECHO Building non-level 2 device driver
  ENDIF

;These constants define device header attribute bits

DEV_ATT_LEVEL_ONE   EQU 0000000010000000B ;Bits 7-9
DEV_ATT_LEVEL_TWO   EQU 0000000100000000B ;Bits 7-9
DEV_ATT_LEVEL_THREE EQU 0000000110000000B ;Bits 7-9
DEV_ATT_CHAR_DEV    EQU 1000000000000000B ;Bit 15 - Device is a character device
DEV_ATT_OPEN_CLOSE  EQU 0000100000000000B ;Bit 11 - Accepts Open/Close
DEV_ATT_SECRET_BIT  EQU 0000000001000000B ;Bit used by IBM AT driver


DEV_ATT_SHARE       EQU 0001000000000000B ;shared devices checking
DEV_ATT_IDC         EQU 0100000000000000B ;support Inter Device Communications

DEV_ATT_COMI_DD        EQU DEV_ATT_OPEN_CLOSE OR \
                           DEV_ATT_SECRET_BIT OR \
                           DEV_ATT_SHARE OR \
                           DEV_ATT_CHAR_DEV

 IF DD_level EQ 1
DEV_ATT_COMI        EQU DEV_ATT_COMI_DD OR DEV_ATT_LEVEL_ONE
 ELSEIF DD_level EQ 2
DEV_ATT_COMI        EQU DEV_ATT_COMI_DD OR DEV_ATT_LEVEL_TWO
 ELSEIF DD_level EQ 3
DEV_ATT_COMI        EQU DEV_ATT_COMI_DD OR DEV_ATT_LEVEL_THREE

DEV_CAP_32BIT_DEVIOCTL EQU 00000001h
DEV_CAP_32BIT_ADDR     EQU 00000002h
DEV_CAP_PARALELL       EQU 00000004h
DEV_CAP_ALT_INIT       EQU 00000008h

DEV_CAP_COMI           EQU DEV_CAP_32BIT_DEVIOCTL
 ENDIF

 IFDEF VDD_support
DEV_CAP_INIT_COMPL     EQU 00000010h

DEV_ATT_COMI_AUX       EQU DEV_ATT_COMI_DD OR \
                           DEV_ATT_IDC OR \
                           DEV_ATT_LEVEL_THREE
 ELSE
DEV_ATT_COMI_AUX       EQU DEV_ATT_COMI OR \
                           DEV_ATT_IDC
 ENDIF

s_stDeviceHeader STRUCT
  pNextHeader           DWORD 0ffffffffh
;  sCodeSegment          WORD 0f  (included in pNextHeader)
  DevAttributes         WORD DEV_ATT_COMI
  StrategyOffset        WORD 0
  IDCoffset             WORD 0
  abyDeviceName         BYTE "COM     "
  wProtectCS            WORD RES_CODE
  wProtectDS            WORD RES_DATA
  wRealCS               WORD 0
  wRealDS               WORD 0
 IF DD_level GT 2
  dwCapStrip            DWORD DEV_CAP_COMI
 ENDIF
s_stDeviceHeader ENDS

  IFDEF DigiBoard
OEM             EQU 1
MAX_DEVICE      EQU 16
MAX_PCI_ADAPTERS EQU 0
%ECHO "building DigiBoard version"
  ELSEIFDEF Comtrol
OEM             EQU 1
MAX_PCI_ADAPTERS EQU 0
%ECHO "building Comtrol Hostess version"
  ELSEIFDEF Quatech
OEM             EQU 1
MAX_PCI_ADAPTERS        EQU 0
%ECHO "building Quatech version"
  ELSEIFDEF ConnecTech
OEM             EQU 1
MAX_PCI_ADAPTERS EQU 1
OEM_PCI_VENDOR EQU PCI_VENDOR_CONNECTECH
%ECHO "building Connect Tech DFLEX version"
  ELSEIFDEF Globetek
OEM             EQU 1
MAX_PCI_ADAPTERS EQU 1
OEM_PCI_VENDOR EQU PCI_VENDOR_GLOBETEK
%ECHO "building Globetek version"
  ELSEIFDEF Sealevel
OEM             EQU 1
NO_COMscope     EQU 1
MAX_PCI_ADAPTERS EQU 1
OEM_PCI_VENDOR EQU PCI_VENDOR_SEALEVEL
%ECHO "building Sealevel Systems OEM version"
  ELSEIFDEF Sealevel_Retail
OEM_GA          EQU 1  ;Sealevel_Retail gets GA equivalent
NO_COMscope     EQU 1
MAX_PCI_ADAPTERS EQU 1
OEM_PCI_VENDOR EQU PCI_VENDOR_SEALEVEL
%ECHO "building Sealevel Systems retail version"
  ELSEIFDEF Neotech
OEM             EQU 1
NoISAsupport    EQU 1
MAX_PCI_ADAPTERS        EQU 0
%ECHO "building Neotech version"
  ELSEIFDEF Moxa
OEM             EQU 1
MAX_PCI_ADAPTERS EQU 1
OEM_PCI_VENDOR EQU PCI_VENDOR_MOXA
%ECHO "building Moxa version"
  ELSEIFDEF Boca
OEM             EQU 1
MAX_PCI_ADAPTERS        EQU 0
%ECHO "building BOCA version"
  ELSEIFNDEF SHARE
PAGE_SUPPORT    EQU 1
MAX_PCI_ADAPTERS        EQU 1
  ENDIF

  IFNDEF MAX_DEVICE
MAX_DEVICE      EQU 8
  ENDIF
  
  IFNDEF MAX_PCI_ADAPTERS
MAX_PCI_ADAPTERS EQU 4
  ENDIF
  
  IFDEF OEM
SHARE             EQU 1
NO_COMscope       EQU 1
  ENDIF

  IFDEF DEMO
%ECHO building evaluation version
  ENDIF

  IF MAX_DEVICE EQ 8
%ECHO MAX_DEVICE = 8
  ELSEIF MAX_DEVICE EQ 16
%ECHO MAX_DEVICE = 16
  ELSEIF MAX_DEVICE EQ 4
%ECHO MAX_DEVICE = 4
  ENDIF

  IFDEF VDD_support
MAX_VDD_PORTS EQU 4
  ENDIF

BUSTYPE_EISA    EQU 1
BUSTYPE_MCA     EQU 2
BUSTYPE_PCMCIA  EQU 3
BUSTYPE_ISA     EQU 4
BUSTYPE_PCI     EQU 5

HDWTYPE_NONE        EQU 0
HDWTYPE_ONE         EQU 1
HDWTYPE_TWO         EQU 2
HDWTYPE_THREE       EQU 3
HDWTYPE_FOUR        EQU 4
HDWTYPE_FIVE        EQU 5
HDWTYPE_SIX         EQU 6
HDWTYPE_SEVEN       EQU 7
HDWTYPE_EIGHT       EQU 8
HDWTYPE_DIGIBOARD   EQU 64h

OEM_OTHER       EQU  0
OEM_SEALEVEL    EQU  1
OEM_COMTROL     EQU  2
OEM_DIGIBOARD08 EQU  3
OEM_QUATECH     EQU  4
OEM_DIGIBOARD16 EQU  5
OEM_NEOTECH     EQU  6
OEM_CONNECTECH  EQU  7
OEM_GLOBETEK    EQU  8
OEM_BOCA        EQU  9
OEM_SEALEVELR   EQU 10
OEM_MOXA        EQU 11

s_stInterruptVars STRUCT
    bRestartTransmit    WORD 0
    bInterruptHit       WORD 0
    wDevCount           WORD 0
s_stInterruptVars ends

s_stConfigParms STRUCT
    cwDeviceFlags1          WORD 0
    cwDeviceFlags2          WORD 0
    cwCOMscopeBuffLen       WORD 0
    cwIObaseAddress         WORD 0
    cwReadBufferLength      WORD 0
    cwWrtBufferLength       WORD 0
    cwTxFIFOdepth           WORD 0
    cwFlags1                WORD 0
    cwFlags2                WORD 0
    cwFlags3                WORD 0
    cwWrtTimeout            WORD 0
    cwRdTimeout             WORD 0
    cdwBaudRate             DWORD 0
    cwIntIDregister         WORD 0
    cbyMaxWritePktCount     BYTE 0
    cbyMaxReadPktCount      BYTE 0
    cbyInterruptLevel       BYTE 0
    cbyLineCharacteristics  BYTE 0
    cbyErrorChar            BYTE 0
    cbyBreakChar            BYTE 0
    cbyXonChar              BYTE 0
    cbyXoffChar             BYTE 0
    cwXonHysteresis         WORD 0
    cwXoffThreshold         WORD 0
s_stConfigParms ends

s_stRMparms STRUCT
    hAdapter                DWORD  0
    hLDev                   DWORD  0
    hSysName                DWORD  0
s_stRMparms ENDS

  IFDEF VDD_support
s_stVDDports STRUCT
  wAddr                 WORD 0
  wIRQ                  WORD 0
  fFlags                WORD 0
  wLoadNumber           WORD 0
  wDeviceNumber         WORD 0
s_stVDDports ENDS
  ENDIF

s_stInstallParms STRUCT
  wLID       WORD 0
s_stInstallParms ENDS

s_stBaudRate STRUCT
  ulCurrentBaud         DWORD 0
  byCurrentFrac         BYTE  0
  ulLowBaud             DWORD 0
  byLowFrac             BYTE  0
  ulHighBaud            DWORD 0
  byHighFrac            BYTE  0
s_stBaudRate ENDS

s_stThresholds STRUCT
    wXon           WORD 0
    wXoff          WORD 0
    byWritePackets BYTE 0
    byReadPackets  BYTE 0
s_stThresholds ENDS

s_stFIFOinfo STRUCT
    wFIFOsize           WORD 0
    wTxFIFOload         WORD 0
    wFIFOflags          WORD 0
    wFIFOcontrolReg     WORD 0
    wReserved           WORD 0
s_stFIFOinfo ENDS

s_stFIFOcontrol STRUCT
  wTxFIFOloadSize       WORD 0
  wFIFOflags            WORD 0
  dwReserved            DWORD 0
s_stFIFOcontrol ENDS

s_stPCIparam_Device STRUCT
  xSubFuncNum           BYTE 0
  wDeviceID             WORD 0
  wVendorID             WORD 0
  xIndex                BYTE 0
s_stPCIparam_Device ENDS

s_stPCIparam_ClassCode STRUCT
  xSubFuncNum           BYTE  0
  dwClassCode           DWORD 0
  xIndex                BYTE  0
s_stPCIparam_ClassCode ENDS

s_stPCIparam_Config STRUCT
  xSubFuncNum           BYTE  0
  xBusNum               BYTE  0
  xDevFuncNum           BYTE  0
  xConfigReg            BYTE  0
  xSize                 BYTE  0
  dwData                DWORD 0
s_stPCIparam_Config ENDS

s_stPCIdata_BIOSinfo STRUCT
  xReturnCode           BYTE 0
  xHdwMechanism         BYTE 0
  xMajorVersion         BYTE 0
  xMinorVersion         BYTE 0
  xLastBus              BYTE 0
s_stPCIdata_BIOSinfo ENDS

s_stPCIdata_Device STRUCT        ; used for both ClassCode and Device return data
 xReturnCode            BYTE 0
 xBusNum                BYTE 0
 xDevFuncNum            BYTE 0
s_stPCIdata_Device ENDS

s_stPCIdata_Config STRUCT
 xReturnCode            BYTE  0
 dwData                 DWORD 0
s_stPCIdata_Config ENDS

s_stPCIadapter STRUCT  ; used to keep table of initialized PCI adapters
  xDevFuncNum    BYTE 0
  xBusNum        BYTE 0 
  xIndex         BYTE 0
  xIRQ           BYTE 0
  usVendorID     WORD 0
  usDeviceID     WORD 0
  dwClassCode    DWORD 0
  usBaseAddress0 WORD 0
  usBaseAddress1 WORD 0
  usBaseAddress2 WORD 0
  usBaseAddress3 WORD 0
  usBaseAddress4 WORD 0
  usBaseAddress5 WORD 0
s_stPCIadapter ENDS

PCI_CLASSCODE_GENERIC_SERIAL equ 70000h
PCI_CLASSCODE_SERIAL_16450   equ 70001h
PCI_CLASSCODE_SERIAL_16550   equ 70002h
PCI_CLASSCODE_SERIAL_16650   equ 70003h
PCI_CLASSCODE_SERIAL_16750   equ 70004h
PCI_CLASSCODE_SERIAL_16850   equ 70005h
PCI_CLASSCODE_SERIAL_16950   equ 70006h
PCI_CLASSCODE_MOXA           equ 70080h
PCI_CLASSCODE_MULTIPORT      equ 70200h
PCI_CLASSCODE_GENERIC_MODEM  equ 70300h
PCI_CLASSCODE_16450_MODEM    equ 70301h
PCI_CLASSCODE_16550_MODEM    equ 70302h
PCI_CLASSCODE_16650_MODEM    equ 70303h
PCI_CLASSCODE_16750_MODEM    equ 70304h
PCI_CLASSCODE_16850_MODEM    equ 70305h
PCI_CLASSCODE_16950_MODEM    equ 70306h
PCI_CLASSCODE_OTHER          equ 78000h

PCI_VENDOR_3COM         equ 012b9h
PCI_DEVICE_3COM_MODEM   equ 01008h  ; Sportster PCI modem

PCI_VENDOR_GLOBETEK     equ 0151ah
PCI_DEVICE_GT_1002      equ 01002h
PCI_DEVICE_GT_1004      equ 01004h
PCI_DEVICE_GT_1008      equ 01008h

PCI_VENDOR_MOXA         equ 01393h
PCI_DEVICE_MX_C104H     equ 01040h
PCI_DEVICE_MX_C168H     equ 01680h

PCI_VENDOR_SUNIX        equ 01409h
PCI_DEVICE_SU_4055A     equ 07168h  ; 4 port 16750 64 byte FIFOs, 8X clock

PCI_VENDOR_SEALEVEL     equ 0135eh
PCI_DEVICE_SL_7801      equ 07801h   ; eight port
PCI_DEVICE_SL_7201      equ 07201h   ; two port ultra
PCI_DEVICE_SL_7202      equ 07202h   ; two port
PCI_DEVICE_SL_7401      equ 07401h   ; four port ultra
PCI_DEVICE_SL_7402      equ 07402h   ; four port
PCI_DEVICE_SL_7404      equ 07404h   ; four port - RS-485/422
PCI_DEVICE_SL_7101      equ 07101h   ; one port ultra
PCI_DEVICE_SL_7102      equ 07102h   ; 1 Port
PCI_DEVICE_SL_7103      equ 07103h   ; 1 Port
PCI_DEVICE_SL_7104      equ 07104h   ; 1 Port
PCI_DEVICE_SL_7105      equ 07105h   ; 1 Port
PCI_DEVICE_SL_7203      equ 07203h   ; 2 Port
PCI_DEVICE_SL_7405      equ 07405h   ; 4 Port
PCI_DEVICE_SL_7901      equ 07901h   ; 2 Ports
PCI_DEVICE_SL_7903      equ 07903h   ; 2 Ports
PCI_DEVICE_SL_7904      equ 07904h   ; 4 Ports
PCI_DEVICE_SL_7905      equ 07905h   ; 8 Ports


PCI_VENDOR_CONNECTECH   equ 011B0h
PCI_DEVICE_BH_V960      equ 00001h
PCI_DEVICE_BH_V961      equ 00002h
PCI_DEVICE_BH_V962      equ 00004h
PCI_DEVICE_BH_V292      equ 00010h
PCI_DEVICE_BLUEHEAT_MSK equ 00007h

PCI_VENDOR_3COM         equ 012b9h

  IFNDEF NO_16650_Xon_HS_support
FIFO_FLG_HDW_TX_XON_HS                EQU 00100h   ; these must match CFG_FLAG2 bits
FIFO_FLG_HDW_RX_XON_HS                EQU 00200h
FIFO_FLG_HDW_HS_MASK                  EQU 00f00h
  ELSE
FIFO_FLG_HDW_HS_MASK                  EQU 00c00h
  ENDIF
FIFO_FLG_HDW_CTS_HS                   EQU 00400h
FIFO_FLG_HDW_RTS_HS                   EQU 00800h
  IFNDEF NO_16650_Xon_HS_support
FIFO_FLG_HDW_TX_XON_WAS               EQU 00010h
FIFO_FLG_HDW_RX_XON_WAS               EQU 00020h
FIFO_FLG_HDW_WAS_MASK                 EQU 000f0h
  ELSE
FIFO_FLG_HDW_WAS_MASK                 EQU 000c0h
  ENDIF
FIFO_FLG_HDW_CTS_WAS                  EQU 00040h
FIFO_FLG_HDW_RTS_WAS                  EQU 00080h
FIFO_FLG_EXPLICIT_TX_LOAD             EQU 04000h
FIFO_FLG_HI_16750_TRIG                EQU 08000h
FIFO_FLG_NO_DCB_UPDATE                EQU 02000h
FIFO_FLG_NO_HDW_HS_SUPPORT            EQU 01000h
FIFO_FLG_FUNC_MASK                    EQU 0f000h
FIFO_FLG_TYPE_MASK                    EQU 0000fh ;used to mask device flags2 UART type bits

;other miscellanious constants

ENTER_KEY               EQU  0dh

FALSE                   EQU 0
TRUE                    EQU 1
ZERO                    EQU 0

TARGET_ALL_EXT     EQU 0f000h
TARGET_COMscope    EQU 08000h
TARGET_Pager       EQU 04000h
TARGET_OS_tools    EQU 03000h

MAX_RESP_BUFFER         EQU 8001h

MAX_OPEN_COUNT          EQU 0f000h      ; some ridiculously high number

; I/O control call table limits - MUST match call table in ioctl.asm

MIN_IOCTL        EQU 41h

  IFDEF x16_BIT
MAX_IOCTL        EQU 75h    ; is 75h to accomodate extended FIFO functions
  ELSE
MAX_IOCTL        EQU 7ch    ; is 7ch to allow extentions to be called
  ENDIF

MAX_COMscope_IOCTL EQU 7fh  ; is 7fh instead of 73h to accomodate OS/tools
                            ;    extensions
 IFDEF DEMO
SIGNATURE        EQU 9793   ; will cause function 80h to return bad command
                            ; error if parameter does not match this in
                            ; evaluation version
 ELSEIFDEF NO_COMscope
SIGNATURE        EQU 9795   ; will cause function 80h to return bad command
                            ; error if parameter does not match this in
                            ; share and/or evaluation versions
 ELSE
SIGNATURE        EQU 9794   ; will cause function 80h to return bad command
                            ; error if parameter does not match this in
                            ; non-evaluation non-share versions
 ENDIF

MAX_INT_LEVEL    EQU 15
MIN_INT_LEVEL    EQU 1

; default definitions

DEF_16550_Xoff_THRESHOLD   EQU 128
DEF_16650_Xoff_THRESHOLD   EQU 256
DEF_16654_Xoff_THRESHOLD   EQU 512
DEF_16750_Xoff_THRESHOLD   EQU 512

MIN_READ_BUFF_LEN       EQU   400h
MAX_READ_BUFF_LEN       EQU 10000h  ; the granularity here is 64K until there is a 32-bit PDD spec
DEF_READ_BUFF_LEN       EQU  1000h
MIN_COMscope_BUFF_LEN   EQU   400h
MAX_COMscope_BUFF_ALLOC EQU 10000h
MAX_COMscope_BUFF_LEN   EQU  7ffch  ; this must be this value or less until there is a 32-bit PDD spec
                                    ; this value will insure that the COMscope agent will never request
                                    ; more that the buffer can hold (64k - 4).
DEF_COMscope_BUFF_LEN   EQU  2000h
MAX_WRITE_BUFF_LEN      EQU  4000h
MIN_WRITE_BUFF_LEN      EQU    80h
DEF_WRITE_BUFF_LEN      EQU   100h

DEFAULT_WRITE_PKT_QUEUE EQU 6
DEFAULT_READ_PKT_QUEUE  EQU 6

DEFAULT_RTS_OFF_DELAY        EQU 03h

DEFAULT_WRITE_TIMEOUT        EQU (100 * 60)  ; = one minute timeout
DEFAULT_READ_TIMEOUT         EQU (100 * 60)  ; = one minute timeout
DEFAULT_DATA_LEN_MASK        EQU 0ffh
DEFAULT_LINE_CHARACTERISTICS EQU 003h
DEFAULT_CLOCK_RATE           EQU 32

  IFDEF DEMO
EVALUATION_WRITES            EQU 1000   ; allow 1000 write requests for evaluation
  ENDIF

DEFAULT_INIT_DELAY           EQU 20   ; two second delay when /VD is selected

DEFAULT_BAUD                 EQU 9600    ;9600 baud
DEFAULT_BAUD_DIVISOR         EQU 12      ;12 = 9600 baud

MIN_BAUD_RATE           EQU 4
MAX_SHORT_BAUD_RATE     EQU 57600
MAX_LONG_BAUD_RATE      EQU 115200
MAX_4X_BAUD_RATE        EQU 460800
MAX_8X_BAUD_RATE        EQU 921699
MAX_12X_BAUD_RATE       EQU 1382400
MAX_16X_BAUD_RATE       EQU 1843200

UART_CLOCK              EQU 0001c200h
UART_4X_CLOCK           EQU 00070800h
UART_8X_CLOCK           EQU 000e1000h
UART_12X_CLOCK          EQU 00151800h
UART_16X_CLOCK          EQU 0026ac00h

; The calculated latch value must produce a baud rate plus or minus .01%
; of the user requested baud rate.
; .01% of 115200 (divisor of one) is 11.52
; the maximum remainder is, therefore, 12 (12/115200 = .0001041)

MAX_REMAINDER           EQU     12  ;on the loose side
MAX_4X_REMAINDER        EQU     46  ;on the tight side
MAX_8X_REMAINDER        EQU     92  ;on the tight side
MAX_12X_REMAINDER       EQU     138 ;on the tight side
MAX_16X_REMAINDER       EQU     184 ;on the tight side

DEV_BUSY                EQU   0200h       ;BUSY bit
DEV_DONE                EQU   0100h       ;DONE bit
ERROR_MASK              EQU   08000h      ;ERROR bit

INTERRUPT_HIT  EQU 01h
FIFO_TO        EQU 02h
OVERRUN        EQU 04h
BREAK          EQU 08h
RCV_BYTE       EQU 10h

_stDeviceControlBlockHeader STRUC
  abyPortName           BYTE 8 DUP(0)
  bHeaderIsInitialized  WORD 0
  oNextDCBheader        WORD 0
  wOptionFlags1         WORD 0
  wOptionFlags2         WORD 0
  stComDCB              s_stConfigParms <>
_stDeviceControlBlockHeader ENDS

ADP_MISC_DATA_SIZE EQU 27  ; this must be adjusted when any changes are made to
                           ; the structure below for downward compatibility.
_stConfigurationHeader STRUC
  wDeviceCount          WORD 0
  wDCBcount             WORD 0
  wDelayCount           WORD 0
  dwCFGheadDummy        DWORD 0
  byAdaptertype         BYTE 0
  byInterruptLevel      BYTE 0
  wOEMentryVector       WORD 0
  wOEMexitVector        WORD 0
  wIntAlgorithim        WORD 0
  wLoadFlags            WORD 0
  wIntIDregister        WORD 0
  bHeaderIsAvailable    WORD 0
  bHeaderIsInitialized  WORD 0
  oNextCFGheader        WORD 0
  oFirstDCBheader       WORD 0
  wPCIVender            WORD 0
  wPCIdevice            WORD 0
  byPCIslot             BYTE 0
  abyData               BYTE ADP_MISC_DATA_SIZE dup(0)
_stConfigurationHeader ENDS

INI_MISC_DATA_SIZE EQU 30  ; this must be adjusted when any changes are made to
                           ; the structure below for downward compatibility.
s_stConfigurationInfo STRUCT
  ulSignature         DWORD 0
  wFlags              WORD 0
  wCFGheaderCount     WORD 0
  oFirstCFGheader     WORD 0
  oCOMscopeIniOffset  WORD 0
  byNextPCIslot       BYTE 0
  byOEMtype           BYTE 0
  abyData             BYTE INI_MISC_DATA_SIZE dup(0)
s_stConfigurationInfo ENDS

s_stMCAportDef STRUCT
        wAddress        WORD 0
        byInterrupt     BYTE 0
s_stMCAportDef ENDS

s_stIDCaccess STRUCT
        IDCrealEntryOff WORD 0
        IDCrealEntrySeg WORD 0
        IDCrealDataSeg  WORD 0
        IDCprotEntryOff WORD 0
        IDCprotEntrySeg WORD 0
        IDCprotDataSeg  WORD 0
s_stIDCaccess ENDS

s_stLIDtable STRUCT
  wDevBlkOffset     WORD 0
  wBlockLen         WORD 0
  wLID              WORD 0
  wBaseAddress      WORD 0
  wDeviceNumber     WORD 0
  bNameTaken        WORD 0
  fFlags            BYTE 0
  byInterruptLevel  BYTE 0
  dummy             WORD 0
s_stLIDtable ENDS

PORT_USER_DISABLED     EQU 0ffffh
PORT_LID_ALREADY_OWNED EQU 0fffeh
PORT_OWNED_BY_OTHER_DD EQU 0fffdh
PORT_ADDRESS_INVALID   EQU 0fffch
PORT_ADDRESS_TAKEN     EQU 0fffbh

NO_INI_FILE            EQU 0ffffh
FILE_ACCESS_ERROR      EQU 0c000h
NO_DEFINED_DEVICES     EQU 08000h

SPECIAL_STRATEGY EQU 0ffffh
DUMMY_STRATEGY   EQU 0fffeh

;Interrupt Algorithim

ALGO_POLL     EQU 0
ALGO_SELECT   EQU 1
ALGO_HYBRID   EQU 2

; LoadFlags bits

LOAD_FLAG1_SCRATCH_IS_INT_ID      EQU  0001h // these must match CFG_FLAG1 bits
LOAD_FLAG1_DIGIBOARD08_INT_ID     EQU  0002h
LOAD_FLAG1_DIGIBOARD16_INT_ID     EQU  0004h
LOAD_FLAG1_TIB_UART               EQU  0008h
LOAD_FLAG1_INT_ID_LOAD_MASK       EQU  000fh

LOAD_FLAG1_FORCE_4X_TEST          EQU  0010h

LOAD_FLAG1_ENABLE_ALL_OUT2        EQU  0400h
LOAD_FLAG1_WAIT_KEY               EQU  8000h
LOAD_FLAG1_VERBOSE                EQU  4000h
LOAD_FLAG1_PRINT_LOCAL            EQU  2000h
LOAD_FLAG1_NO_IRRITATION          EQU  1000h

; SystemDebug bits

SYS_DB_ENABLED                  EQU  0008h
SYS_DB_NO_EVAL_LIMIT            EQU  2000h
SYS_DB_NO_EVAL_MESSAGE          EQU  4000h
SYS_DB_10_BIT_ADDRESSES         EQU  8000h

; InitDebugFlags

INIT_DEB_AGGRESSIVE_TESTS        EQU 0010h

; COMscope event flags

CS_WRITE                equ 080h
CS_WRITE_IMM            equ 081h
CS_WRITE_REQ            equ 082h
CS_WRITE_CMPLT          equ 083h
CS_MODEM_OUT            equ 084h
CS_DEVIOCTL             equ 085h
CS_OPEN_ONE             equ 086h
CS_OPEN_TWO             equ 087h
CS_CLOSE_ONE            equ 088h
CS_CLOSE_TWO            equ 089h
CS_BREAK_TX             equ 08ah
;CS_WRITE_TIME           equ 020h

CS_READ                 equ 040h
CS_READ_IMM             equ 041h
CS_READ_REQ             equ 042h
CS_READ_CMPLT           equ 043h
CS_MODEM_IN             equ 044h
CS_READ_BUFF_OVERFLOW   equ 045h
CS_HDW_ERROR            equ 046h
CS_BREAK_RX             equ 047h
;CS_READ_TIME            equ 021h

;CS_TIME_TAG             equ 0e0h

CS_PACKET_DATA          equ 0ff00h

; COMscope function bits

CSFUNC_RESET_BUFFERS             EQU 0001h
CSFUNC_TRACE_INPUT_STREAM        EQU 0002h
CSFUNC_TRACE_OUTPUT_STREAM       EQU 0004h
CSFUNC_TRACE_IMM_STREAM          EQU 0008h
CSFUNC_TRACE_MODEM_IN_SIGNALS    EQU 0010h
CSFUNC_TRACE_MODEM_OUT_SIGNALS   EQU 0020h
CSFUNC_TRACE_MODEM_SIGNALS_MASK  EQU 0030h
CSFUNC_TRACE_DEVIOCTL            EQU 0040h
CSFUNC_TRACE_ERRORS              EQU 0080h
CSFUNC_TRACE_OPEN                EQU 0100h
CSFUNC_TRACE_CLOSE               EQU 0200h
CSFUNC_TRACE_READ                EQU 0400h
CSFUNC_TRACE_WRITE               EQU 0800h
CSFUNC_TRACE_MASK                EQU 0ffeh
CSFUNC_TRACE_RX_BUFF_LEVEL       EQU 1000h
CSFUNC_TRACE_TX_BUFF_LEVEL       EQU 2000h
CSFUNC_TRACE_INCLUDE_PACKET      EQU 4000h
;CSFUNC_TRIP_INPUT_STREAM         EQU 4000h
;CSFUNC_TRIP_OUTPUT_STREAM        EQU 8000h

  IFNDEF x16_BIT
; Ring0Access functions

TEST_FOR_PCI_BIOS       EQU 8
DO_IDC_ACCESS_IRQ       EQU 7
DO_IDC_ACCESS_OEM       EQU 6
GET_KERNAL_DATA         EQU 5
GET_DEVBLK_LEN          EQU 3
GET_DEVBLK_OFFSET       EQU 2
GET_BASE_ADDR           EQU 1

; Extension functions

s_stExtensionParams STRUCT
    wSignature      WORD 0
    wCommand        WORD 0
    wModifier       WORD 0
    wDataCount      WORD 0
s_stExtensionParams ENDS

s_stExtensionDataHeader STRUCT
    wReturnCode     WORD 0
    wByteCount      WORD ?
s_stExtensionDataHeader ENDS

EXT_CMD_GET_MEMORY            EQU 0
EXT_CMD_GET_DCB               EQU 1
EXT_CMD_GET_PATH              EQU 2
EXT_CMD_GET_MEMORY_SIZE       EQU 3
EXT_CMD_GET_VAR_SIZE          EQU 4
EXT_CMD_GET_LOAD_NUMBER       EQU 5
EXT_CMD_GET_CONFIG_FLAGS      EQU 6
EXT_CMD_GET_SIGNATURE         EQU 7
EXT_CMD_GET_OEM_TYPE          EQU 8
EXT_CMD_OPEN_PAGER            EQU 9
EXT_CMD_GET_MAX_DEVICE_COUNT  EQU 10
EXT_CMD_TRIG_READ             EQU 11
EXT_CMD_TRIG_WRITE            EQU 12
EXT_CMD_ROLL_COUNT            EQU 13
EXT_CMD_GET_PAGER_COUNTS      EQU 14
EXT_CMD_RESET_RX_HIGH         EQU 15
;EXT_CMD_RESET_TX_HIGH         EQU 16
MAX_EXT_CMD                   EQU 16

EXT_RSP_SUCCESS                  EQU 00f00h

EXT_BAD_SIGNATURE                EQU 0f000h
EXT_ERROR_NO_TX_FIFO_TRIG        EQU 00ff8h
EXT_ERROR_NO_FIFO                EQU 00ff9h
EXT_ERROR_BAD_TARGET             EQU 00ffah
EXT_ERROR_BAD_LENGTH             EQU 00ffbh
EXT_ERROR_BAD_PATH               EQU 00ffch
EXT_ERROR_BAD_COMMAND            EQU 00ffdh
EXT_ERROR_BAD_MODIFIER           EQU 00ffeh
EXT_ERROR_BAD_MEMORY_TARGET      EQU 00fffh


s_stAttachDDentry STRUCT
  IDCaccessRM         DWORD 0
  IDCaccessRDS        WORD  0
  IDCaccessPM         DWORD 0
  IDCaccessPDS        WORD  0
s_stAttachDDentry ENDS

; AttachDD functions

ADD_IS_OEM_PRESENT              EQU 0
ADD_MARK_IRQ_USED               EQU 1
  IFNDEF NO_COMscope
ADD_GET_SIGNATURE               EQU 2
    IFDEF PAGE_SUPPORT
ADD_OPEN_PAGER                  EQU 3
ADD_CLOSE_PAGER                 EQU 4
ADD_IS_TRIGGERED                EQU 5

LAST_ATTACHDD_FUNCTION          EQU 5
    ELSE
LAST_ATTACHDD_FUNCTION          EQU 2
    ENDIF
  ELSE
LAST_ATTACHDD_FUNCTION          EQU 1
  ENDIF
ADD_ERROR_BAD_FUNCTION          EQU 1
ADD_ERROR_BAD_MODIFIER          EQU 2

  ENDIF ; NOT x16_BIT
