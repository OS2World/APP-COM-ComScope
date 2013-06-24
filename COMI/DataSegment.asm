;************************************************************************
;
; $Revision:   1.7  $
;
; $Log:   P:/archive/comi/DataSegment.asv  $
;
;     Rev 1.7   28 Mar 1996 00:19:56   EMMETT
;  Added resource manager.  Began work on VDD support.
;
;     Rev 1.6   18 Feb 1996 14:17:48   EMMETT
;  Added many features.  Notably:
;  Tracing application DosDevIOCtl function calls and packets.
;  Support for 16650 and 16750 UARTs.
;  Streamlined interrupt routine.
;
;     Rev 1.5   25 Apr 1995 22:16:22   EMMETT
;  Added Support for DigiBoard PC/16.  Changed interrupt Routine for better adapter independence.
;  Changed interrupt routine to allow user to select interrupting device selection algorithim.  Fixed
;  ABIOS interaction for better "non.INI" initialization in MCA machines.  Fixed various initialization
;  message strings.  COMscope and receive buffer are now allocated from system memory, allowing
;  a 32k (word) COMscope buffer and a 64k (byte) receive buffer.
;
;     Rev 1.4   03 Dec 1994 14:42:04   EMMETT
;  Changed segment names to "C" standard.  Added various variable for initialization.
;
;     Rev 1.3   22 Jul 1994 09:11:28   EMMETT
;  Moved all "INCL_" lines for OS2.INC into COMDD.INC.
;
;     Rev 1.2   28 Jun 1994 09:06:06   EMMETT
;  Removed ".VER" includes and placed common version string.
;
;     Rev 1.1   11 Jun 1994 10:37:52   EMMETT
;  Changed all references to "Mirror" to "COMscope".
;
;     Rev 1.0   07 Jun 1994 00:18:58   EMMETT
;  Added support for DigiBoard.
;  Added initialization support for OEM specific loads.
;  Fixed bug in StartWriteStream and ProcessModemSignals that caused handshaking problems.
;  Fixed hardware tests to set baud rate before testing interrupts.
;  Fixed hardware tests off switch to work only for retail version.
;
;************************************************************************

TITLE OS/tools Multi-Port Device Driver
SUBTITLE Data Definitions
PAGE ,132
;*
;* FILE: DATA.ASM
;*
;* COPYRIGHT: (c) OS/tools Incorporated 1988-94.  All rights reserved.
;*
;*
;*******************************************************************************

  IFNDEF x16_BIT
.386P
  ELSE
.286P
  ENDIF
.NOLISTMACRO                   ;suppress macro expansion in listing

.XLIST                  ;suppress listing of INCLUDE files
    INCLUDE SEGMENTS.INC
    INCLUDE COMDD.INC
    INCLUDE PACKET.INC
    INCLUDE ABIOS.INC
    INCLUDE DEVHLP.INC
    INCLUDE DCB.INC
    INCLUDE Hardware.inc
.LIST

HeaderDeviceName EQU <"OS$tools">

RES_DATA SEGMENT
        ASSUME DS:RDGROUP, SS:nothing, ES:nothing

    ORG 0000

START_OF_DATA   EQU   $

__stAuxHeader LABEL BYTE
ComAux            WORD   OFFSET xComAux
ComAuxSeg         WORD   SEG xComAux
  IFNDEF x16_BIT
DevAttributes     WORD   DEV_ATT_COMI_AUX
  ELSE
DevAttributes     WORD   DEV_ATT_COMI
  ENDIF
StrategyOffset    WORD   OFFSET AuxStrategy
;  IFNDEF SHARE
IDCoffset         WORD   OFFSET nDDAttachFunction
;  ELSE
;IDCoffset         WORD   0
;  ENDIF
DeviceName        BYTE   HeaderDeviceName
ReservedWords     WORD   4 DUP (0)
  IFDEF VDD_support
DeviceCaps        DWORD  DEV_CAP_INIT_COMPL
  ELSE
                  DWORD  0
  ENDIF
__stDummyHeader LABEL BYTE
xComAux           DWORD  -1
xDevAttributes    WORD   DEV_ATT_COMI
xStrategyOffset   WORD   OFFSET xAuxStrategy
xIDCoffset        WORD   OFFSET nDDAttachFunction
xDeviceName       BYTE   'sloot$SO'
xReservedWords    WORD   4 DUP (0)
  IF DD_level GT 2
xDeviceCaps       DWORD  DEV_CAP_COMI
  ENDIF
  EVEN

dwSerialNumber   DWORD 0

__wMaxPagerCount LABEL WORD
wMaxPagerCount LABEL WORD
  IFDEF SHARE
                     WORD 0
  ELSEIFDEF OEM
                     WORD 0
  ELSEIFDEF OEM_GA
                     WORD 0
  ELSE
                     WORD 1
  ENDIF

__wMaxDeviceCount LABEL WORD
wMaxDeviceCount LABEL WORD

  IFDEF SHARE
    IFDEF OEM
                      WORD 0
    ELSEIFDEF OEM_GA
                      WORD 0
    ELSEIFDEF x16_BIT
                      WORD 0
    ELSE
                      WORD 4
    ENDIF
  ELSE
                      WORD 0
  ENDIF

  IFDEF x16_BIT
__usDosIOdelayCount LABEL WORD
usDosIOdelayCount  WORD 3
  ENDIF

__byAdapterType LABEL BYTE
byAdapterType BYTE HDWTYPE_NONE

__byOEMtype LABEL BYTE
; these will only be defined when OEM is defined
  IFDEF DigiBoard
byOEMtype      BYTE OEM_DIGIBOARD
  ELSEIFDEF Quatech
byOEMtype      BYTE OEM_QUATECH
  ELSEIFDEF Neotech
byOEMtype      BYTE OEM_NEOTECH
  ELSEIFDEF Comtrol
byOEMtype      BYTE OEM_COMTROL
  ELSEIFDEF Sealevel
byOEMtype      BYTE OEM_SEALEVEL
  ELSEIFDEF ConnecTech
byOEMtype      BYTE OEM_CONNECTECH
  ELSEIFDEF Globetek
byOEMtype      BYTE OEM_GLOBETEK
  ELSEIFDEF Boca
byOEMtype      BYTE OEM_BOCA
  ELSE
; default is not OEM driver
byOEMtype      BYTE 0
  ENDIF
  EVEN
;------------------------- copy protection key ---------------------

  IFDEF COPY_PROTECT
dwInstallMark  DWORD 1
wInstallCount   WORD 1
  ENDIF

;--------------------- variables used at task time -----------------

  IFNDEF x16_BIT
; IDC variables

wIDCsignature    WORD SIGNATURE
wIDCbuffer       WORD 16 DUP (0)
wPagerOpenCount  WORD 0

; Set up IDC access in case this is the first load.
; This is so that all calls to global (IDC) functions are the same
; even for the first load, which will not need to use the IDC
; interface to access the global functions

IDCaccess       LABEL WORD
IDCaccessRM     DWORD 0
IDCaccessRDS    WORD  0
IDCaccessPM     LABEL DWORD
IDCaccessPMoff  WORD  OFFSET nDDAttachFunction
IDCaccessPMseg  WORD  SEG nDDAttachFunction
IDCaccessPDS    WORD  RDGROUP

IDCdata         WORD  32 DUP(0)
  ENDIF
; other

device_hlp      DWORD ?

wClockRate      WORD DEFAULT_CLOCK_RATE
wClockRate2     WORD DEFAULT_CLOCK_RATE * 2

wLastEndOfData  WORD 0
wLastFunctionCall WORD 0
wCurrentTarget WORD 0

__wSystemDebug LABEL WORD
wSystemDebug     WORD 0
__wMiscControl LABEL WORD
wMiscControl      WORD 0

  IFDEF DEMO
wWriteCountStart  WORD EVALUATION_WRITES
wWriteCount       WORD EVALUATION_WRITES
  ENDIF

wIntRegistered  WORD 0
wDeviceCount    WORD 0

wCOMiLoadNumber WORD 0

wTimerAllocCount WORD 0

__wCOMscopeStrategy LABEL WORD
wCOMscopeStrategy WORD 0

wMaskTimerCount WORD 0

abyInterruptCount BYTE 16 DUP(0)

byLastModemOut BYTE 0

bOpenTrigger  BYTE FALSE
bWriteTrigger BYTE FALSE
bReadTrigger BYTE FALSE

__abyPath LABEL BYTE
abyPath         BYTE CCHMAXPATH DUP(0)
  EVEN

  IFDEF VDD_support
dfVCOMaddress   DF   0
wVDDdeviceCount WORD 0
stVDDports s_stVDDports MAX_VDD_PORTS DUP(<>)
  EVEN
  ENDIF

ulTriggersSinceReboot DWORD 0

 IFDEF OEM
__bOEMpresent LABEL WORD
bOEMpresent WORD FALSE
 ENDIF

__wIntIDregister LABEL WORD
wIntIDregister WORD 0

__wOEMjumpEntry LABEL WORD
wOEMjumpEntry WORD 0

__wOEMjumpExit LABEL WORD
wOEMjumpExit WORD 0

__wOEMjumpTest LABEL WORD
wOEMjumpTest   WORD 0

__bSharedInterrupts LABEL WORD
bSharedInterrupts WORD TRUE

__wPCIvendor LABEL WORD
wPCIvendor WORD 0
__wPCIdevice LABEL WORD
wPCIdevice WORD 0

wLastDeviceParmsOffset WORD 0ffffh

byIntStatusMask BYTE 0
  EVEN

__wBusType LABEL WORD
wBusType        WORD 0

bNoOUT2change WORD FALSE

wInterruptsUsed WORD 0

dwInputData_Return DWORD 0

wDeviceIntOffsetTable WORD MAX_DEVICE DUP(0) ;stores device int params offset

  IFDEF VDD_support
wVDDdeviceOffsetTable WORD MAX_VDD_PORTS DUP(0) ;stores device params offset
  ENDIF

wDeviceOffsetTable WORD MAX_DEVICE DUP(0) ;stores device params offset

__wEndOfData LABEL WORD
wEndOfData   WORD OFFSET $

__stDeviceParms LABEL s_stDeviceParms
stDeviceParms s_stDeviceParms MAX_DEVICE DUP(<>)

END_OF_KEEP_DATA LABEL BYTE

wInitTimerCount     WORD 0

  IFNDEF NO_4x_CLOCK_SUPPORT
dwTimerCounter  DWORD 0
  ENDIF

IDCdeviceName      BYTE HeaderDeviceName,0

stABIOSrequestBlock s_stABIOSrequestBlock {}

__stAttachDD LABEL s_stAttachDDentry
stAttachDD s_stAttachDDentry {}

__szName LABEL BYTE
szName BYTE 10 DUP(0)

stStackUsage s_stStackUsage <>

;dwRunTimeEndOfData    DWORD __wEndOfData

        ORG 0ffffh

BUF_DATA_AVAILABLE EQU $ - END_OF_KEEP_DATA

RES_DATA ENDS

_DATA SEGMENT
;--------------------- variables used only at initialization time -----------------

_OEMHLPname      BYTE      "OEMHLP$ ",0    ; OEMHLP$ name
_OEMHLPhandle    WORD      0               ; handle for file access
_Action          WORD      0               ; DOSOPEN parameter

_stPCIdata_BIOSinfo s_stPCIdata_BIOSinfo  <>
_stPCIdata_Config s_stPCIdata_Config  <>
_stPCIdata_Device s_stPCIdata_Device  <>

_stPCIparam_ClassCode s_stPCIparam_ClassCode  <>
_stPCIparam_Config s_stPCIparam_Config  <>
_stPCIparam_Device s_stPCIparam_Device  <>

_wLoadNumber            WORD NO_INI_FILE
_wLoadCount             WORD 0
_wSelectorCount         WORD 0
_wLoadFlags             WORD 0
_bIsTheFirst            WORD TRUE
_bABIOSpresent          WORD TRUE
_byInitIntORmask        BYTE 0
_byInitIntANDmask       BYTE 0ffh
_byNextPCIslot          BYTE 0
_xBaudMultiplier        BYTE 0

_bPnPcapable            WORD FALSE

_bPCI_BIOSpresent       WORD TRUE
_dwPCIvector            DWORD 0

_ulAvailableBufferSpace DWORD BUF_DATA_AVAILABLE
_ulRequiredBufferSpace DWORD ZERO
_ulWriteBufferSpace DWORD ZERO
_bUseDDdataSegment WORD TRUE


  IFDEF VDD_support
_bFindMoreVDDs   WORD TRUE
_PDD_VDD_name    BYTE "COMiVDD",0
  ENDIF

_wInitDebugFlags WORD 0

_bTimerAvailable WORD FALSE

_bDisableRM WORD FALSE

_wDriverLoadCount WORD 0
_stRMparms s_stRMparms MAX_DEVICE + 1 DUP({})

  IFNDEF x16_BIT
_awGDTselectors  WORD (MAX_DEVICE * 2) DUP(0)

_Ring0Vector      DWORD 0
  ENDIF
_wLID            WORD 0
_LIDtable       s_stLIDtable 8 dup({})
_astInstallParms s_stInstallParms MAX_DEVICE DUP({})


_wInstallTryCount WORD 0
_byIntIDregisterPreset  BYTE 0

; these will only be defined when OEM is defined
_byLoadAdapterType LABEL BYTE
  IFDEF DigiBoard
                     BYTE HDWTYPE_DIGIBOARD
  ELSEIFDEF Quatech
                     BYTE HDWTYPE_ONE
  ELSEIFDEF Comtrol
                     BYTE HDWTYPE_TWO
  ELSEIFDEF Sealevel
                     BYTE HDWTYPE_ONE
  ELSEIFDEF ConnecTech
                     BYTE HDWTYPE_THREE
  ELSEIFDEF Globetek
                     BYTE HDWTYPE_ONE
  ELSEIFDEF Boca
                     BYTE HDWTYPE_SIX
  ELSE
; default is no hardware type
                     BYTE HDWTYPE_NONE
  ENDIF

_szDefaultPath   BYTE CCHMAXPATH dup(0)

_abyCOMnumbers   BYTE MAX_DEVICE DUP(0)
_bPrimaryInit     WORD FALSE
_bDebugDelay      WORD FALSE

_stConfigParms s_stConfigParms MAX_DEVICE DUP({})
_bSeparateIDreg WORD TRUE

_iIntIDindex     WORD 0
_StackPointer     WORD 0
_iDataIndex      WORD 0
_bIntIDavailable WORD 0
_bContinueParse  WORD 0
_wCurrentDevice   WORD 0
_wBaseDevice      WORD 0

_wDelayCount     WORD DEFAULT_INIT_DELAY
_bOUT1activate  WORD FALSE

_bBadLoad            WORD FALSE

_PreviousLID         WORD 0
_byPortNumber        BYTE 0
_wBufferLength       WORD 0
_abyNumber           BYTE 10 DUP(0)
_abyTemp             BYTE 6 DUP(0)
_bWaitingKey         WORD FALSE
_bValidIntIDreg      WORD FALSE
_bValidInterrupt     WORD FALSE
_wInitTestPort       WORD 0

_bUsesSixteenAddrLines WORD FALSE

_bVerbose           WORD FALSE
_bDelay             WORD FALSE
_bPrintLocation     WORD FALSE

_wPCIcount          WORD 0

_astMCAportTable LABEL s_stMCAportDef
        WORD 03f8h                ;serial 1 = COM1
        BYTE 04
        WORD 02f8h                ;serial 2 = COM2
        BYTE 03
        WORD 3220h                ;serial 3 = COM3
        BYTE 03
        WORD 3228h                ;serial 4 = COM4
        BYTE 03
        WORD 4220h                ;serial 5 = COM5
        BYTE 03
        WORD 4228h                ;serial 6 = COM6
        BYTE 03
        WORD 5220h                ;serial 7 = COM7
        BYTE 03
        WORD 5228h                ;serial 8 = COM8
        BYTE 03
        WORD 0000
        BYTE 00

_PCItable LABEL WORD
  IFDEF ConnecTech
        WORD    6550    ;TBD
  ENDIF
        WORD    0000

_SealevelPCIadapterTable LABEL WORD
       WORD PCI_DEVICE_SL_7801
       WORD PCI_DEVICE_SL_7201
       WORD PCI_DEVICE_SL_7202
       WORD PCI_DEVICE_SL_7401
       WORD PCI_DEVICE_SL_7402
       WORD PCI_DEVICE_SL_7404
       WORD PCI_DEVICE_SL_7101
       WORD 0

_ConnectechPCIadapterTable LABEL WORD
       WORD PCI_DEVICE_BH_V960
       WORD PCI_DEVICE_BH_V961
       WORD PCI_DEVICE_BH_V962
       WORD PCI_DEVICE_BH_V292
       WORD 0

_GlobetekPCIadapterTable LABEL WORD
       WORD PCI_DEVICE_GT_1002
       WORD PCI_DEVICE_GT_1004
       WORD PCI_DEVICE_GT_1008
       WORD 0

_MoxaPCIadapterTable LABEL WORD
       WORD PCI_DEVICE_MX_C104H
       WORD PCI_DEVICE_MX_C168H
       WORD 0

_ClassCodeTable LABEL DWORD
       DWORD PCI_CLASSCODE_GENERIC_SERIAL
       DWORD PCI_CLASSCODE_SERIAL_16450  
       DWORD PCI_CLASSCODE_SERIAL_16550  
       DWORD PCI_CLASSCODE_SERIAL_16650  
       DWORD PCI_CLASSCODE_SERIAL_16750  
       DWORD PCI_CLASSCODE_SERIAL_16850  
       DWORD PCI_CLASSCODE_SERIAL_16950  
       DWORD PCI_CLASSCODE_MOXA 
       DWORD PCI_CLASSCODE_MULTIPORT     
       DWORD PCI_CLASSCODE_GENERIC_MODEM 
       DWORD PCI_CLASSCODE_16450_MODEM   
       DWORD PCI_CLASSCODE_16550_MODEM   
       DWORD PCI_CLASSCODE_16650_MODEM   
       DWORD PCI_CLASSCODE_16750_MODEM   
       DWORD PCI_CLASSCODE_16850_MODEM   
       DWORD PCI_CLASSCODE_16950_MODEM   
       DWORD PCI_CLASSCODE_OTHER         
       DWORD 0

_stPCIadapterTable s_stPCIadapter (MAX_PCI_ADAPTERS + 1) dup({0})
_stPCIadapterHold s_stPCIadapter (MAX_PCI_ADAPTERS + 1) dup({0})

_ADFtable LABEL WORD
  IFDEF Globetek
        WORD 6426h      ;M-1002
  ENDIF
  IFDEF Quatech
        WORD 5fd8h      ;ES-2000
        WORD 5fe0h      ;QS-1000
        WORD 5fe3h      ;DS-2000
        WORD 5fe6h      ;DS-1000
        WORD 5fe7h      ;SCL-6100
        WORD 5fe9h      ;SP-1050
        WORD 5fech      ;QS-2000
  ENDIF
  IFDEF Neotech
        WORD 678dh      ;MS4P
        WORD 6789h      ;MS4CRJ
        WORD 6788h      ;MS4B
        WORD 6787h      ;MS4A
        WORD 6780h      ;MS4
        WORD 6781h      ;SS/1
        WORD 6783h      ;SPC/1 SPC/1A
        WORD 6784h      ;MSI/2
        WORD 6785h      ;S485
        WORD 678bh      ;MS/2
        WORD 678ch      ;S2M100
        WORD 6792h      ;SPM321
        WORD 6795h      ;S1M200
  ENDIF
  IFDEF Sealevel
        WORD 61d6h     ;MSA
  ENDIF
        WORD 0000

  IFDEF COPY_PROTECT
_abyConfigFile   BYTE "c:\config.sys",0

_abyHiddenFile   BYTE "z"
                 BYTE "6" OR 0c0h
                 BYTE "5" OR 0c0h
                 BYTE "6" OR 0c0h
                 BYTE "6" OR 0c0h
                 BYTE "9" OR 0c0h
                 BYTE "7" OR 0c0h
                 BYTE "8" OR 0c0h
                 BYTE "." OR 0c0h
                 BYTE "3" OR 0c0h
                 BYTE "5" OR 0c0h
                 BYTE "6" OR 0c0h
                 BYTE 0
  ENDIF

_wDeviceCount WORD 0
_wPCIadapterCount WORD 0

_abyString       BYTE 256 DUP(0)

_bWaitForCR      WORD FALSE

  IFDEF x16_BIT
_wCOMstart              WORD 0
_wCOMlast               WORD 0
_iStartDevice           WORD 0
_iEndDevice             WORD 0
  ENDIF

  IFDEF x16_BIT
INCLUDE MESSAGE.DEF
  ELSE
_chFailedReadIni        BYTE 0dh,0ah,07h,"[1mFailed to read initialization file.[0m",0dh,0ah,0
_chFailedWriteIni       BYTE 0dh,0ah,07h,"[1mFailed on write to initialization file.[0m",0dh,0ah,0
_chFailedBadVersion_1   BYTE 0dh,0ah,07h,"[1mVersion of initialization file ",0
_chFailedBadVersion_2   BYTE 0dh,0ah,"does not match COMi version.  Use correct version of COMscope or Install to",0dh,0ah
                        BYTE         "set-up devices and re-start system.[0m",0dh,0ah,0
_chFailedIniNotInit_1   BYTE 0dh,0ah,07h,"[1mThe initialization file ",0
_chFailedIniNotInit_2   BYTE 0dh,0ah,"is not configured for this COMi load.  Use COMscope or Install to",0dh,0ah
                        BYTE         "setup devices and re-start system.[0m",0dh,0ah,0dh,0ah,0
_chFailedIniCorrupt_1   BYTE 0dh,0ah,07h,"[1mInitialization  file ",0
_chFailedIniCorrupt_2   BYTE 0dh,0ah,"is not correct format.  Delete file and use COMscope or Install to",0dh,0ah
                        BYTE         "setup devices and re-start system.[0m",0dh,0ah,0dh,0ah,0
_chFailedBadPath        BYTE 0dh,0ah,07h,"[1mBad Path Stored at Initialization[0m",0dh,0ah,0

IFNDEF NO_PCI
_chPCI_LoadOrder_1      BYTE "PCI adapters are load order dependant.  You must configure PCI adapters",0dh,0ah,0
_chPCI_LoadOrder_2      BYTE "starting in load one, with each subsequent PCI adapter in succeeding loads.",0dh,0ah,0dh,0ah,0
_chPCIBadIRQ            BYTE 07h,"[1mPCI serial adapter IRQ not assigned, check BIOS PCI settings.[0m",0dh,0ah,0dh,0ah,0
_chTooManyPCIadapters   BYTE 07h,"[1mToo many PCI adapters defined for this version of device driver[0m",0dh,0ah,0dh,0ah,0


 IFDEF ConnectTech
_chPCIMissing           BYTE 07h,"[1mNo Connect Tech BlueHeat PCI serial adapter is installed for this COMi load.[0m",0dh,0ah,0dh,0ah,0
ELSE
  IFDEF Sealevel
_chPCIMissing           BYTE 07h,"[1mNo Selevel Systems PCI serial adapter is installed for this COMi load.[0m",0dh,0ah,0dh,0ah,0
  ELSE
   IFDEF Sealevel_Retail
_chPCIMissing           BYTE 07h,"[1mNo Selevel Systems PCI serial adapter is installed for this COMi load.[0m",0dh,0ah,0dh,0ah,0
   ELSE
_chPCIMissing           BYTE 07h,"[1mNo PCI serial adapter is installed for this COMi load.[0m",0dh,0ah,0dh,0ah,0
   ENDIF
  ENDIF
 ENDIF
ELSE
_chPCInotSupported      BYTE 07h,"[1mPCI serial adapters are not supported in this version of COMi.[0m",0dh,0ah,0dh,0ah,0
ENDIF

  IFDEF OEM
INCLUDE OEM_MSG.DEF
  ENDIF
  IFDEF OEM_GA
INCLUDE OEM_MSG.DEF
  ENDIF

  IFDEF debug_ini
_szTIF BYTE "This is the first load",0dh,0ah,0
_szDHI BYTE "Device Header Initializied",0dh,0ah,0
_szCHR BYTE "Config Header Read",0dh,0ah,0
_szAS  BYTE "Available set",0dh,0ah,0
_szDHR BYTE "Device Header Read",0dh,0ah,0
_szCHW BYTE "Config Header Written",0dh,0ah,0
_szCHA BYTE "Config Header Available",0dh,0ah,0
_szTLC BYTE "Testing LoadCount",0dh,0ah,0
  ENDIF

  ENDIF

_szMessage BYTE 200 DUP(0)
_abyFileBuffer BYTE 8192 DUP(0)

_wEndOfInitData   WORD END_OF_INIT_DATA
END_OF_INIT_DATA EQU $

_DATA ENDS

  IFNDEF x16_BIT
 IFDEF this_junk
_TEXT SEGMENT

  IFNDEF NO_RESOURCE_MGR
    EXTRN _RMHELP_CreateDriver          :FAR
    EXTRN _RMHELP_SetDevHelp            :FAR
    EXTRN _RMHELP_GetPorts              :FAR
    EXTRN _RMHELP_PortDidntInstall      :FAR
    EXTRN _RMHELP_PortInitComplete      :FAR
  ENDIF

_TEXT ENDS
 ENDIF

RES_CODE SEGMENT

    EXTRN AuxStrategy                   :NEAR
    EXTRN xAuxStrategy                  :NEAR
  IFNDEF x16_BIT
    EXTRN nDDAttachFunction             :NEAR
  ENDIF

RES_CODE ENDS

  ENDIF

 END
