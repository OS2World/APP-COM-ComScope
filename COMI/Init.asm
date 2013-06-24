;************************************************************************
;
; $Revision:   1.1  $
;
; $Log:   P:/archive/comi/INIT.ASv  $
;
;     Rev 1.1   28 Mar 1996 00:19:18   EMMETT
;  Added resource manager.  Began work on VDD support.
;
;     Rev 1.0   19 Feb 1996 11:03:06   EMMETT
;
;
;     Rev 1.8   18 Feb 1996 14:18:04   EMMETT
;  Added many features.  Notably:
;  Tracing application DosDevIOCtl function calls and packets.
;  Support for 16650 and 16750 UARTs.
;  Streamlined interrupt routine.
;
;     Rev 1.7   25 Apr 1995 22:16:36   EMMETT
;  Added Support for DigiBoard PC/16.  Changed interrupt Routine for better adapter independence.
;  Changed interrupt routine to allow user to select interrupting device selection algorithim.  Fixed
;  ABIOS interaction for better "non.INI" initialization in MCA machines.  Fixed various initialization
;  message strings.  COMscope and receive buffer are now allocated from system memory, allowing
;  a 32k (word) COMscope buffer and a 64k (byte) receive buffer.
;
;     Rev 1.6   03 Dec 1994 15:07:28   EMMETT
;  Changed segment names.  Streamlined ABIOS machine initialization.
;  Removed most of old "parse" init code.
;
;     Rev 1.5   28 Jun 1994 09:09:30   EMMETT
;  Added "clear all interrupts" to handle interrupt ID register problems when one or more ports
;  on an adapter were in an interrupt state at system reset time.
;
;     Rev 1.4   11 Jun 1994 10:37:40   EMMETT
;  Changed all references to "Mirror" to "COMscope".
;
;     Rev 1.3   07 Jun 1994 00:19:08   EMMETT
;  Added support for DigiBoard.
;  Added initialization support for OEM specific loads.
;  Fixed bug in StartWriteStream and ProcessModemSignals that caused handshaking problems.
;  Fixed hardware tests to set baud rate before testing interrupts.
;  Fixed hardware tests off switch to work only for retail version.
;
;     Rev 1.2   27 Apr 1994 22:56:22   EMMETT
;  FIxed ABIOS stuff to work better than before.
;
;     Rev 1.1   18 Apr 1994 23:18:06   EMMETT
;  Changed ABIOS processing and added ability to disallow a port to initialize.
;
;     Rev 1.0   16 Apr 1994 08:35:14   EMMETT
;  Initial version control archive.
;
;************************************************************************

  IFNDEF x16_BIT
.386P
  ELSE
.286P
  ENDIF
.NOLISTMACRO                   ;suppress macro expansion in listing

.XLIST
    INCLUDE SEGMENTS.INC
    INCLUDE COMDD.INC
    INCLUDE PACKET.INC
    INCLUDE INITMACRO.INC
    INCLUDE ABIOS.INC
    INCLUDE DEVHLP.INC
    INCLUDE DCB.INC
    INCLUDE Hardware.inc
.LIST

RES_DATA SEGMENT

  IFDEF DEMO
    EXTRN wWriteCount                   :WORD
    EXTRN wWriteCountStart              :WORD
  ENDIF
    EXTRN wLastDeviceParmsOffset        :WORD
    EXTRN wClockRate                    :WORD
    EXTRN wClockRate2                   :WORD
    EXTRN device_hlp                    :DWORD
    EXTRN stDeviceParms                 :s_stDeviceParms
    EXTRN wMaxDeviceCount               :WORD
    EXTRN wSystemDebug                  :WORD
    EXTRN wLastEndOfData                :WORD
    EXTRN wDeviceCount                  :WORD
    EXTRN wDeviceOffsetTable            :WORD
    EXTRN abyPath                       :BYTE
    EXTRN wEndOfData                    :WORD
    EXTRN wBusType                      :WORD
    EXTRN byOEMtype                     :BYTE

  IFNDEF x16_BIT
    EXTRN IDCaccess                     :WORD
    EXTRN IDCaccessPM                   :DWORD
    EXTRN IDCaccessPDS                  :WORD
    EXTRN IDCdata                       :WORD
    EXTRN IDCdeviceName                 :BYTE
  ENDIF
    EXTRN wInitTimerCount               :WORD

    EXTRN bSharedInterrupts             :WORD
    EXTRN wIntIDregister                :WORD
    EXTRN ComAux                        :WORD
    EXTRN xComAux                       :WORD
    EXTRN wCOMiLoadNumber               :WORD

 IFDEF OEM
    EXTRN bOEMpresent                   :WORD
 ENDIF

RES_DATA ENDS

_DATA SEGMENT

.XLIST
    INCLUDE MSG.INC
.LIST
    EXTRN _szMessage                     :BYTE

    EXTRN _bUseDDdataSegment            :WORD
    EXTRN _astInstallParms              :WORD
    EXTRN _wLoadNumber                  :WORD
    EXTRN _wLoadCount                   :WORD
    EXTRN _ulRequiredBufferSpace        :DWORD
    EXTRN _ulAvailableBufferSpace       :DWORD
    EXTRN _wSelectorCount               :WORD
    EXTRN _bABIOSpresent                :WORD
    EXTRN _bPCI_BIOSpresent             :WORD

    EXTRN _abyCOMnumbers                :BYTE

    EXTRN _wDriverLoadCount             :WORD
    EXTRN _bTimerAvailable              :WORD

    EXTRN _StackPointer                 :WORD
    EXTRN _wLoadFlags                   :WORD
  IFNDEF x16_BIT
   IFDEF VDD_support
    EXTRN _PDD_VDD_name                 :BYTE
   ENDIF
  ENDIF
    EXTRN _bBadLoad                     :WORD
    EXTRN _bDebugDelay                  :WORD

    EXTRN _byLoadAdapterType            :BYTE
    EXTRN _abyString                    :BYTE
    EXTRN _wEndOfInitData               :WORD

    EXTRN _bDisableRM                   :WORD

  IFDEF COPY_PROTECT
    EXTRN _wInstallCount                :WORD
  ENDIF

    EXTRN _wCurrentDevice               :WORD
    EXTRN _wDelayCount                  :WORD

    EXTRN _stConfigParms                :s_stConfigParms

    EXTRN _wInitTestPort                :WORD
    EXTRN _wInstallTryCount             :WORD
    EXTRN _bWaitForCR                   :WORD
    EXTRN _bWaitingKey                  :WORD

    EXTRN _bVerbose                     :WORD
    EXTRN _bDelay                       :WORD
    EXTRN _bPrintLocation               :WORD

    EXTRN _bPrimaryInit                 :WORD
    EXTRN _byIntIDregisterPreset        :BYTE

    EXTRN _ADFtable                     :WORD

  IFDEF VDD_support
    EXTRN _wVDDdeviceCount              :WORD
    EXTRN _stVDDports                   :s_stVDDports
    EXTRN _bFindMoreVDDs                :WORD
  ENDIF

  IFDEF COPY_PROTECT
    EXTRN _abyConfigFile                :BYTE
    EXTRN _abyDeviceDriverFile          :BYTE
    EXTRN _abyHiddenFile                :BYTE
  ENDIF
    EXTRN _bIsTheFirst                  :WORD
    EXTRN _bContinueParse               :WORD

  IFDEF OEM
    EXTRN Adapter_limit_msg             :BYTE
    EXTRN ISA_bad_msg                   :BYTE
    EXTRN MCA_bad_msg                   :BYTE
    EXTRN Contact_msg                   :BYTE
    EXTRN OS_tools_BLURB                :BYTE
    EXTRN _Ring0Vector                  :DWORD
  ENDIF

_DATA ENDS

_TEXT SEGMENT

  IFNDEF NO_RESOURCE_MGR
;    EXTRN _RMHELP_CreateDriver          :FAR
    EXTRN _RMHELP_SetDevHelp            :FAR
;    EXTRN _RMHELP_GetPorts              :FAR
    EXTRN _RMHELP_PortDidntInstall      :FAR
    EXTRN _RMHELP_PortInitComplete      :FAR
  ENDIF
    EXTRN _GetIniInfo                   :FAR
    EXTRN _LoadHeadersFromABIOStable    :FAR
    EXTRN _BuildLIDtable                :FAR
  IFDEF OEM
    EXTRN _PrintWrongOEM                :FAR
  ENDIF


_TEXT ENDS

RES_CODE SEGMENT
    ASSUME CS:RCGROUP, ES:nothing, SS:nothing, DS:RDGROUP, GS:DGROUP

BEGIN_INIT_CODE  EQU $
;-------------------------------------------------------------------------------
; Initialization procedurs are placed after BEGIN_INIT_CODE so they can go
; away once initialization has completed.
;-------------------------------------------------------------------------------
    EXTRN _GetLIDentry                  :FAR
  IFDEF VDD_support
    EXTRN BEGIN_VDD_CODE                :NEAR
  ENDIF
    EXTRN TestValidHDW                  :NEAR
    EXTRN TestMCA                       :NEAR
    EXTRN CalcBaudRate                  :NEAR

 IFDEF OEM
    EXTRN CheckPOS                      :NEAR
    EXTRN BadMCAmessage                 :NEAR
 ENDIF

  IFDEF x16_BIT
    EXTRN _ProcessResponseFile          :NEAR
  ENDIF

    EXTRN PrintString                   :NEAR
    EXTRN DelayFunction                 :NEAR
    EXTRN InitTimer                     :NEAR
    EXTRN CalcDelay                     :NEAR
    EXTRN OutputProgress                :NEAR
    EXTRN binac_10                      :NEAR
    EXTRN GetCOMnumber                  :NEAR
    EXTRN binac                         :NEAR
    EXTRN ParseArguments                :NEAR
    EXTRN StorePath                     :NEAR

  IFNDEF x16_BIT
   IFDEF VDD_support
    EXTRN PDD_VDD_comm                  :FAR
   ENDIF
    EXTRN SetRing0Access                :NEAR
    EXTRN _MemorySetup                  :NEAR
  ENDIF

  IFDEF COPY_PROTECT
    EXTRN _TestHidden                   :NEAR
  ENDIF

Location PROC NEAR

        cmp     GS:_bPrintLocation,TRUE
        jne     exit

        lea     bx,BEGIN_INIT_CODE
  IFDEF VDD_support
        cmp     GS:_bIsTheFirst,TRUE
        je      @f
        lea     bx,BEGIN_VDD_CODE
@@:
  ENDIF
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szCodeLocation_xxxxxxx,
               cs,bx,300,ds,wEndOfData,GS:_wEndOfInitData,wLastEndOfData
        INVOKE PrintMessage,ADDR _szMessage,ax
exit:
        ret

Location ENDP

; AX contains strategy target upon entry

Init PROC NEAR C USES ES GS DI, oErrorCode:WORD

;        LOCAL bAutoConfig:WORD
        LOCAL pPacket:DWORD
;  int 3
        mov     WORD PTR pPacket,di
        mov     di,es
        mov     WORD PTR pPacket + 2,di
        les     di,pPacket
        mov     bx,ES:[di].s_stPacket.InitParamPacket.DevHlpOffset
        mov     word ptr device_hlp,bx
        mov     bx,ES:[di].s_stPacket.InitParamPacket.DevHlpOffset + 2
        mov     word ptr device_hlp + 2,bx

;  int 3
    SetGS     DGROUP

        cmp     ax,SPECIAL_STRATEGY
        jne     @f
        mov     GS:_bPrimaryInit,TRUE
        jmp     main_init
@@:
        cmp     ax,DUMMY_STRATEGY
        jne     begin_device_init
        cmp     GS:_bPrimaryInit,TRUE
        jne     main_init

        mov     ax,GS:_wEndOfInitData
        les     di,pPacket
        mov     ES:[di].s_stPacket.InitDataPacket.DataEndOffset,ax
        StoreError oErrorCode,ERROR_I24_GEN_FAILURE
        jmp     set_end_of_code

;------------------------------------------------------------
; First entry into this COMi load.
;------------------------------------------------------------
main_init:
;  int  3
        mov     GS:_bIsTheFirst,TRUE  ; initialize variable

  IFNDEF x16_BIT
        lea     bx,OFFSET IDCdeviceName
        lea     di,OFFSET IDCaccess
        mov     dx,DevHlp_AttachDD
        call    device_hlp
        jc      @f
        mov     GS:_bIsTheFirst,FALSE ; this in NOT the first COMi load
@@:
  ENDIF

        mov     wBusType,BUSTYPE_ISA  ; initialize bus type to ISA

; Try to initialize timer to be used by init process
        mov     ax,OFFSET InitTimer
        mov     dl,DevHlp_SetTimer
        call    device_hlp
        jc      @f
        mov     GS:_bTimerAvailable,TRUE ; timer is initialized
@@:
; Process command line parameters and store driver path
        les     di,pPacket
        les     bx,ES:[di].s_stPacket.InitParamPacket.ArgumentPointer
        call    StorePath

  IFDEF x16_BIT
        mov     ax,OFFSET CR
        call    PrintString
        mov     ax,OFFSET logo_message
        call    PrintString
  ENDIF

        call    ParseArguments
        call    Location
  IFDEF x16_BIT
        jnc     @f
        mov     ax,OFFSET bad_response_file_msg
        call    PrintString
        lea     bx,xComAux
        mov     WORD PTR [bx],0ffffh
        mov     WORD PTR [bx + 2],0ffffh
        mov     GS:_wLoadCount,0
        mov     GS:wInstallTryCount,0
        jmp     error_exit
@@:
        mov     GS:_wDriverLoadCount,1

  ENDIF

; RM environment must be set before any calls to RM functions
; and after command line is parsed so that we can know if we want to
; disable resource manager.

   IFNDEF NO_RESOURCE_MGR
        cmp     GS:_bDisableRM,TRUE
        je      @f
        push    WORD PTR [device_hlp + 2]
        push    WORD PTR [device_hlp]
     SetDS    DGROUP                            ;push-pop
        call    _RMHELP_SetDevHelp
        add     sp,4
     SetDS    RDGROUP
@@:
   ENDIF
;  int 3
; If EXT-INITDELAY is a command line parameter then wait for
; kernal debugger break (^C from debug terminal).
        mov     ax,30
        cmp     GS:_bDebugDelay,TRUE
        jne     AfterDebugDelay
;        jne     @f
        mov     ax,OFFSET _szDebugMessage
        call    PrintString
        mov     ax,30
;@@:
        call    CalcDelay
        Delay   ax

AfterDebugDelay::
        mov     ax,OFFSET _szCRonly
        call    PrintString
  IFNDEF x16_BIT
        cmp     GS:_bIsTheFirst,TRUE
   IFDEF OEM
        jne     test_OEM_present
   ELSE
        jne     test_MCA
   ENDIF
   IFDEF VDD_support
; Register PDD
        push    es
        push    di
        push    si
;        mov     ax,_DATA
;        mov     ds,ax
        mov     si,OFFSET PDD_VDD_name
        mov     ax,cs
        and     al,0fch         ; force to ring 0 selector
        mov     es,ax
        mov     di,OFFSET PDD_VDD_comm
        mov     dl,DevHlp_RegisterPDD
        call    device_hlp
        pop     si
        pop     di
        pop     es
   ENDIF ;VDD_support
        cmp     GS:_bDebugDelay,TRUE
        je      @f
        mov     ax,OFFSET _szCR
        call    PrintString
@@:
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szLogoMessage_s,OFFSET _szSubLogo,GS
        INVOKE PrintMessage,ADDR _szMessage,ax
        jmp     test_MCA

   IFDEF OEM
test_OEM_present:
        ; no longer allowing multiple COMi loads in OEM versions
        mov     ax,OFFSET Adapter_limit_msg
        call    PrintString
        mov     ax,OFFSET Contact_msg
        call    PrintString
        mov     ax,OFFSET OS_tools_BLURB
        call    PrintString
        jmp     abort_COMi_load_exit

        call    SetRing0Access
        jc      test_MCA
        sub     sp,6
        push    OFFSET IDCdata  ; offset to IDC data area
        push    ax              ; dummy - modifier unused for this function
        push    DO_IDC_ACCESS_OEM   ; ring zero IDC function
        call    GS:_Ring0Vector
        jc      test_MCA

        mov     bOEMpresent,TRUE
   ENDIF

test_MCA:
  ENDIF ;NOT x16_BIT
        call    TestMCA
  IFNDEF x16_BIT
        cmp     GS:_bABIOSpresent,TRUE
        je      MCA_build_LID_table

   IFDEF NoISAsupport
    IFDEF Neotech
        mov     ax,OFFSET ISA_bad_msg
        call    PrintString
        mov     ax,OFFSET Contact_msg
    ELSE
        mov     ax,OFFSET NO_ISA_bad_msg
    ENDIF
        call    PrintString
        mov     ax,OFFSET OS_tools_BLURB
        call    PrintString
        jmp     abort_COMi_load_exit
   ELSE
        jmp     get_configuration
   ENDIF
MCA_build_LID_table:
;-------------------------------------------------------------------
; If this is the first COMi load then setup ring zero access and
; build LID table.  LID table is only built if machine is Micro Channel.
;-------------------------------------------------------------------
        cmp     GS:_bIsTheFirst,TRUE
;        jne     test_PCI
        jne     get_configuration
        call    SetRing0Access
;        jc      test_PCI
        jc      get_configuration
    SetDS     DGROUP
        call    _BuildLIDtable
    SetDS     RDGROUP

        mov     wBusType,BUSTYPE_MCA
;        jmp     get_configuration

;test_PCI::
;        call    TestPCI
;        cmp     GS:_bPCI_BIOSpresent,TRUE
;        jne     get_configuration

get_configuration::
  IFDEF OEM
        cmp     GS:_bIsTheFirst,TRUE
        je      ReadConfigFile
; Determine if valid OEM load has occurred
        cmp     bOEMpresent,TRUE
        je      ReadConfigFile

; Test if this is a Micro Channel machine and there isn't a
; valid OEM load, then this is not a valid adapter.

        cmp     GS:_bABIOSpresent,TRUE
        jne     not_OEM

; Check if the MCA POS manufacturer'sID matches an adapter
; supported by this build.

        call    CheckPOS
        jnc     ReadConfigFile

not_OEM:
; Report invalid adapter for this build
        mov     GS:_bWaitForCR,TRUE
        mov     GS:_wDelayCount,1000

        cmp     GS:_bIsTheFirst,TRUE
        jne     not_first_load
    SetDS     DGROUP
        call    _PrintWrongOEM
    SetDS     RDGROUP
        mov     ax,OFFSET Contact_msg
        call    PrintString
        mov     ax,OFFSET OS_tools_BLURB
        call    PrintString

; Cause the device driver load to be aborted
        lea     bx,xComAux
        mov     WORD PTR [bx],0ffffh
        mov     WORD PTR [bx + 2],0ffffh
        jmp     display_finals

not_first_load:
        call    BadMCAmessage
        jmp     abort_COMi_load_exit
;@@:
  ENDIF

ReadConfigFile::
;--------------------------------------------------------------
; Read INI file
;--------------------------------------------------------------
   SetDS      DGROUP
        pusha
        push    gs
        push    ds
        mov     _StackPointer,sp
        call    _GetIniInfo
        pop     ds
        pop     gs
        popa
   SetDS      RDGROUP
;---------------------------------------------------------------
; Test INI file results
;---------------------------------------------------------------
        mov     ax,GS:_wLoadNumber
        mov     wCOMiLoadNumber,ax

; Was valid INI file found?
        cmp     ax,NO_INI_FILE
        jne     test_INI_access
        cmp     GS:_bABIOSpresent,TRUE
        jne     bad_INI_file
        mov     GS:_bVerbose,TRUE

; Since no INI file was found, attempt to load configuration from ABIOS
   SetDS      DGROUP
        call    _LoadHeadersFromABIOStable
   SetDS      RDGROUP
        mov     ax,GS:_wLoadCount
        or      ax,ax
        jz      @f
        mov     GS:_wDriverLoadCount,1
        jmp     continue_initialization
@@:
; No INI file and no ABIOS ports found so abort load
        mov     ax,OFFSET _szNoPortAvailable
        call    PrintString
        jmp     bad_INI_file

test_INI_access:
; Error messages for the following error conditions were displayed from
; within PRELOAD.C.

; Were any serial devices defined in INI file?
        cmp     GS:_wLoadNumber,NO_DEFINED_DEVICES
        je      bad_INI_file

; Test if INI file was invalid or corrupted
        cmp     GS:_wLoadNumber,FILE_ACCESS_ERROR
        jne     continue_initialization

bad_INI_file:
; An error was found in INI file so cause pause to extend display of
; error messages then abort load
;        mov     ax,OFFSET _szWaitKeyMessage
;        call    PrintString
        mov     GS:_bWaitingKey,TRUE
        mov     GS:_wDelayCount,1000
;        Delay   GS:_wDelayCount
;        lea     ax,_szCR
;        call    PrintString
        jmp     abort_COMi_load_exit

continue_initialization::
; serial device were defined in INI file or by ABIOS
  ENDIF ;NOT x16_BIT
  IFDEF OEM
; If this is the first load then bOEMpresent must be checked (after reading INI).
; If it is not the first load then bOEMpresent has already been tested.

        cmp     GS:_bIsTheFirst,TRUE
        jne     @f
        cmp     bOEMpresent,TRUE
        jne     not_OEM
@@:
  ENDIF
  IFDEF DEMO
; If this is evaluation version then print evaluation message if required
        cmp     bx,1
        ja      no_eval_msg
        test    wSystemDebug,SYS_DB_NO_EVAL_MESSAGE
        jnz     no_eval_msg
        mov     ax,OFFSET _szEvaluationMsg
        call    PrintString

eval_message:
        mov     ax,OFFSET _szWaitKeyMessage
        call    PrintString
        mov     GS:_bWaitingKey,TRUE
        Delay   0ffffh
        mov     ax,OFFSET _szCR_2x
        call    PrintString

no_eval_msg:
  ENDIF
   IFNDEF x16_BIT
; Test if there is enough memory available in device driver data segment
; to accomodate all required buffers.  This variable is set in PRELOAD.C
; (GetIniInfo).
        cmp     GS:_bUseDDdataSegment,TRUE
        je      calculate_delay_count

; There is not enough memory in device driver data segment, so allocate
; selectors and buffers
        push    GS:_wLoadCount
        call    _MemorySetup
        pop     ax
        jnc     tell_resources

; There was an error allocating memory for COMi buffers, so print error message
; and abort load.
        mov     ax,OFFSET _szAllocError
        call    PrintString
        mov     ax,OFFSET _szWaitKeyMessage
        call    PrintString
        mov     GS:_bWaitingKey,TRUE
        mov     GS:_wDelayCount,0ffffh
        Delay   GS:_wDelayCount
        lea     ax,_szCR
        call    PrintString
        jmp     abort_COMi_load_exit

tell_resources:
; Display allocated resources used
        mov     ebx,GS:_ulRequiredBufferSpace;
        mov     cx,GS:_wSelectorCount

        INVOKE sprintf,ADDR _szMessage,0,ADDR _szAllocBuffers_ululu,
                                           GS:_wSelectorCount,
                                           GS:_ulRequiredBufferSpace,
                                           GS:_ulAvailableBufferSpace
        INVOKE PrintMessage,ADDR _szMessage,ax

calculate_delay_count::
   ENDIF  ;x16_BIT
; Convert delay count seconds to timer ticks
        mov     ax,GS:_wDelayCount
        call    CalcDelay
        mov     GS:_wDelayCount,ax
  IFDEF DEMO
; Initialize DEMO write counter
        mov     ax,wWriteCountStart
        mov     wWriteCount,ax
  ENDIF
; Set up exit variables
        mov     ax,GS:_wEndOfInitData
        les     di,pPacket
        mov     ES:[di].s_stPacket.InitDataPacket.DataEndOffset,ax

; If this is NOT the first COMi load then the "sloot$OS" device name was
; used to initialize this load.  In that case, we must cause that device name
; to be available for any subsequent load.
        cmp     GS:_bIsTheFirst,TRUE
        je      @f

; Cause "sloot$SO" device to not be loaded
        StoreError oErrorCode,ERROR_I24_GEN_FAILURE
@@:
; If there are no devices to initialize then kill the timer and exit,
; otherwise just exit.
        mov     ax,GS:_wLoadCount
        cmp     ax,GS:_wInstallTryCount
        je      kill_timer
        jmp     set_end_of_code

abort_COMi_load_exit:
; Cause this COMi load to NOT be loaded
        lea     bx,xComAux
        mov     WORD PTR [bx],0ffffh
        mov     WORD PTR [bx + 2],0ffffh
        mov     ax,GS:_wEndOfInitData
        les     di,pPacket
        mov     ES:[di].s_stPacket.InitDataPacket.DataEndOffset,ax
        cmp     GS:_bIsTheFirst,TRUE
        je      @f
        StoreError oErrorCode,ERROR_I24_GEN_FAILURE
@@:
        jmp     test_final_delay

;------------------------------------------------------------
; Entry for each device in this COMi load
;------------------------------------------------------------
begin_device_init::
        test    ax,0ff00h  ; test if device is for COMscope access
        jz      device_init
        mov     bx,ax
        and     bx,000fh
        shl     bx,1
        cmp     wDeviceOffsetTable[bx],ZERO
        jne     @f
        StoreError oErrorCode,ERROR_I24_GEN_FAILURE
@@:
        mov     ax,wLastEndOfData
        les     di,pPacket
        mov     ES:[di].s_stPacket.InitDataPacket.DataEndOffset,ax
        jmp     set_end_of_code

device_init:
; We are initializing the clock variable here so that we won't advertise
; a modified clock rate unless there are devices to initialize.
        mov     GS:_wCurrentDevice,ax
        cmp     ax,0
        ja      start

; Initialize end of data and other variables
        mov     ax,wEndOfData
        mov     wLastEndOfData,ax
        mov     GS:_bBadLoad,FALSE

; We are initializing the clock variable here so that we don't advertise
; a modified clock rate unless there are devices defined.
        cmp     wClockRate,DEFAULT_CLOCK_RATE
        je      start
        mov     bx,wClockRate
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szClockRate_u,bx
        INVOKE PrintMessage,ADDR _szMessage,ax
        call    PrintString

start:
        inc     GS:_wInstallTryCount
        mov     si,TYPE s_stDeviceParms
        mov     ax,wDeviceCount
        mul     si
        mov     si,ax
        add     si,OFFSET stDeviceParms
        mov     di,TYPE s_stConfigParms
        mov     ax,GS:_wCurrentDevice
        mul     di
        mov     di,ax
        add     di,OFFSET _stConfigParms  ; assume in DGROUP - GS = DGROUP

        cmp     GS:_bABIOSpresent,TRUE
        jne     test_user_disable
;------------------------------------------------
; Test for ABIOS access Logical Device override.

; Possible only when INI file present.
;------------------------------------------------
        cmp     GS:[di].s_stConfigParms.cwIObaseAddress,PORT_ADDRESS_INVALID
        jne     @f
        call    GetCOMnumber
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szABIOSaddrInvalid_u,bx
        INVOKE PrintMessage,ADDR _szMessage,ax
        jmp     bad_device
@@:
        cmp     GS:[di].s_stConfigParms.cwIObaseAddress,PORT_ADDRESS_TAKEN
        jne     @f
        call    GetCOMnumber
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szABIOSaddrTaken_u,bx
        INVOKE PrintMessage,ADDR _szMessage,ax
        jmp     bad_device
@@:
;------------------------------------------------
; Possible only without INI file.
;------------------------------------------------
        cmp     GS:[di].s_stConfigParms.cwIObaseAddress,PORT_OWNED_BY_OTHER_DD
        jne     @f
        cmp     GS:_wLoadNumber,NO_INI_FILE
        je      non_device
        call    GetCOMnumber
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szABIOSname_u,bx
        INVOKE PrintMessage,ADDR _szMessage,ax
        jmp     bad_device
@@:
;------------------------------------------------
; Possible with or without INI file.
;------------------------------------------------
        cmp     GS:[di].s_stConfigParms.cwIObaseAddress,PORT_LID_ALREADY_OWNED
        jne     test_user_disable
        cmp     GS:_wLoadNumber,NO_INI_FILE
        je      non_device
        call    GetCOMnumber
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szABIOSowned_u,bx
        INVOKE PrintMessage,ADDR _szMessage,ax
        jmp     bad_device

test_user_disable:
;------------------------------------------------
; Possible only when user set port address to 0xffff, to disable port access.
;------------------------------------------------
        cmp     GS:[di].s_stConfigParms.cwIObaseAddress,PORT_USER_DISABLED
        jne     attempt_access
        cmp     GS:_bVerbose,TRUE
        jne     non_device
        call    GetCOMnumber
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szSkippedPort_u,bx
        INVOKE PrintMessage,ADDR _szMessage,ax
        jmp     non_device

bad_device:
  IFNDEF NO_RESOURCE_MGR
; Device is bad so remove it from Resource Manager lists.
        cmp     GS:_bDisableRM,TRUE
        je      @f
        mov     bx,GS:_wInstallTryCount
        dec     bx
        push    bx
        push    ax
   SetDS      DGROUP
        call    _RMHELP_PortDidntInstall
   SetDS      RDGROUP
        add     sp,4
@@:
  ENDIF
        mov     GS:_bWaitForCR,TRUE
        mov     GS:_wDelayCount,1000
        mov     GS:_bBadLoad,TRUE

non_device::
        mov     bx,OFFSET _astInstallParms
        mov     ax,GS:[bx].s_stInstallParms.wLID
        or      ax,ax
        jz      error_exit
        mov     dl,DevHlp_FreeLIDEntry
        call    device_hlp

error_exit:
        StoreError oErrorCode,ERROR_I24_GEN_FAILURE
        jmp     init_exit
;---------------------------------------------------------------------
; Setup minimum device data and test if device is valid
;---------------------------------------------------------------------
attempt_access::
; Has an I/O base address been specified?
        cmp     GS:[di].s_stConfigParms.cwIObaseAddress,ZERO
        je      @f
        mov     dx,GS:[di].s_stConfigParms.cwIObaseAddress
        jmp     set_IO_base_address
@@:
        cmp     wBusType, BUSTYPE_PCI
        jne     @f
        call    GetCOMnumber
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szPCIerror_u,bx
        INVOKE PrintMessage,ADDR _szMessage,ax
        jmp     bad_device
@@:
        call    GetCOMnumber
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szBaseAddrError_u,bx
        INVOKE PrintMessage,ADDR _szMessage,ax
        jmp     bad_device

set_IO_base_address:
        mov     [si].s_stDeviceParms.wIObaseAddress,dx

; Has an interrupt level been specified?
        cmp     GS:[di].s_stConfigParms.cbyInterruptLevel,ZERO
        je      @f
        mov     al,GS:[di].s_stConfigParms.cbyInterruptLevel
        jmp     set_interrupt_level
@@:
        call    GetCOMnumber
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szInterruptLevelError_u,bx
        INVOKE PrintMessage,ADDR _szMessage,ax
        jmp     bad_device

set_interrupt_level:
        mov     [si].s_stDeviceParms.byInterruptLevel,al

        mov     ax,GS:[di].s_stConfigParms.cwDeviceFlags1
        mov     [si].s_stDeviceParms.wConfigFlags1,ax
        mov     ax,GS:[di].s_stConfigParms.cwDeviceFlags2
        mov     [si].s_stDeviceParms.wConfigFlags2,ax

        test    [si].s_stDeviceParms.wConfigFlags1,CFG_FLAG1_FORCE_4X_TEST
        jz      @f
        or    GS:_wLoadFlags,LOAD_FLAG1_FORCE_4X_TEST
;        or      [si].s_stDeviceParms.wDeviceFlag2,DEV_FLAG2_FORCE_4X_TEST
@@:
; Is special interrupt processing required because TI 16550B UART is present.
        test    [si].s_stDeviceParms.wConfigFlags1,CFG_FLAG1_TIB_UART
        jz      @f

; Do not do special processing for other TI UARTs.  This is tested here in case ;;3.83i
; a type two adapter was selected during configuration and we find some other
; TI UART is actually being used.
; This won't prevent an explicit selection of this "feature" or the selection
; of a type two adapter type when no TI UART is present

        test    [si].s_stDeviceParms.wDeviceFlag2,(DEV_FLAG2_16750_UART OR DEV_FLAG2_TI16550C_UART)
        jnz     @f
        or      [si].s_stDeviceParms.wDeviceFlag2,DEV_FLAG2_TIB_UART
@@:
; Set status register preload value
        mov     GS:_byIntIDregisterPreset,0
    IFNDEF OEM
;        cmp     GS:byOEMtype,OEM_BOCA
;        je      @f
        cmp     GS:_byLoadAdapterType,HDWTYPE_DIGIBOARD
        jne     not_DigiBoard
;@@:
        mov     GS:_byIntIDregisterPreset,0ffh

not_DigiBoard:
    ELSEIFDEF DigiBoard
        mov     GS:_byIntIDregisterPreset,0ffh
    ELSEIFDEF Boca
        mov     GS:_byIntIDregisterPreset,0ffh

        test    [si].s_stDeviceParms.wConfigFlags1,CFG_FLAG1_TESTS_DISABLE
        jnz     set_packet_size
    ENDIF
; Test if valid hardware is available.
        call    TestValidHDW
        jc      bad_device

set_packet_size:
; Test read/write packet queue count request.
        mov     al,DEFAULT_WRITE_PKT_QUEUE
        cmp     GS:[di].s_stConfigParms.cbyMaxWritePktCount,ZERO
        je      @f
        mov     al,GS:[di].s_stConfigParms.cbyMaxWritePktCount
@@:
        mov     [si].s_stDeviceParms.byMaxWritePktCount,al

        mov     al,DEFAULT_READ_PKT_QUEUE
        cmp     GS:[di].s_stConfigParms.cbyMaxReadPktCount,ZERO
        je      @f
        mov     al,GS:[di].s_stConfigParms.cbyMaxReadPktCount
@@:
        mov     [si].s_stDeviceParms.byMaxReadPktCount,al

; Transmit buffer space is always allocated in device driver's data segment
; so we must determine if there is enough space available
        xor     eax,eax
        mov     ax,DEF_WRITE_BUFF_LEN
        cmp     GS:[di].s_stConfigParms.cwWrtBufferLength,ZERO
        je      @f
        mov     ax,GS:[di].s_stConfigParms.cwWrtBufferLength
        cmp     ax,MIN_WRITE_BUFF_LEN
        jae     @f
        mov     ax,MIN_WRITE_BUFF_LEN
@@:
        mov     [si].s_stDeviceParms.wWrtBufferLength,ax


        add     ax,wLastEndOfData
        jc      segment_overflow
        cmp     ax,0fffeh

        ja      segment_overflow
  IFNDEF x16_BIT
        cmp     GS:_bUseDDdataSegment,TRUE
        je      set_thresholds

  ENDIF
; Test buffer length request if allocating memory for receive and/or COMscope
; buffers in the device driver's data segment.  If we aren't allocating memory
; in the device driver's data segment then we have already calculated
; required buffer space and compared to available buffer space.

        mov     ebx,DEF_READ_BUFF_LEN      ; also zeros upper word of EBX
        cmp     GS:[di].s_stConfigParms.cwReadBufferLength,ZERO
        je      @f
        mov     bx,GS:[di].s_stConfigParms.cwReadBufferLength
        cmp     ebx,MIN_READ_BUFF_LEN
        jae     @f
        mov     ebx,MIN_READ_BUFF_LEN
@@:
        mov     [si].s_stDeviceParms.dwReadBufferLength,ebx

        add     ax,bx
        jc      segment_overflow
        cmp     ax,0fffeh
        ja      segment_overflow

  IFNDEF NO_COMscope
        test    GS:[di].s_stConfigParms.cwDeviceFlags1,CFG_FLAG1_COMSCOPE
        jz      set_thresholds

        mov     ebx,DEF_COMscope_BUFF_LEN  ; also zeros upper word of EBX
        cmp     GS:[di].s_stConfigParms.cwCOMscopeBuffLen,ZERO
        je      @f
        mov     bx,GS:[di].s_stConfigParms.cwCOMscopeBuffLen
        cmp     ebx,MIN_COMscope_BUFF_LEN
        jae     @f
        mov     ebx,MIN_COMscope_BUFF_LEN
@@:
        mov     [si].s_stDeviceParms.dwCOMscopeBuffLen,ebx

        add     ax,bx
        jc      segment_overflow
        cmp     ax,0fffeh
        jbe     set_thresholds

  ENDIF

segment_overflow:
        call    GetCOMnumber
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szMemoryError_u,bx
        INVOKE PrintMessage,ADDR _szMessage,ax
        jmp     bad_device

set_thresholds::
;  Set handshaking thresholds
        mov     ax,20h
        cmp     GS:[di].s_stConfigParms.cwXoffThreshold,0
        je      @f
        mov     ax,GS:[di].s_stConfigParms.cwXoffThreshold
        mov     [si].s_stDeviceParms.wDefXoffThreshold,ax
@@:
        mov     [si].s_stDeviceParms.wXoffThreshold,ax

        mov     eax,[si].s_stDeviceParms.dwReadBufferLength
        shr     eax,1
        cmp     GS:[di].s_stConfigParms.cwXonHysteresis,0
        je      @f
        mov     eax,[si].s_stDeviceParms.dwReadBufferLength
        sub     ax,GS:[di].s_stConfigParms.cwXonHysteresis
        sub     ax,[si].s_stDeviceParms.wXoffThreshold
        mov     [si].s_stDeviceParms.wDefXonThreshold,ax
@@:
        mov     [si].s_stDeviceParms.wXonThreshold,ax

  IFDEF this_junk ; these were tested and set in valid hardware tests
; unless the user needs to support some foreign UART (eg 82510 or 8250)
; test for FIFO availability

        test    GS:[di].s_stConfigParms.cwDeviceFlags1,CFG_FLAG1_FOREIGN_UART
        jnz     set_DCB_defaults

; test for FIFO availability (16550A)

        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,FIFO_CTL_REG_OFFSET
        mov     al,01h
        OutByteDel bx
        xor     al,al
        InByteDel bx
        and     al,0c0h
        cmp     al,0c0h
        jne     no_FIFO
        cmp     GS:[di].s_stConfigParms.cwXoffThreshold,0
        jne     @f
        mov     [si].s_stDeviceParms.wXoffThreshold,30h
@@:
        or      [si].s_stDeviceParms.wDeviceStatus,DEV_ST_FIFO_AVAILABLE
        jmp     clear_FIFO_control
no_FIFO:
        and     [si].s_stDeviceParms.byFlag3,NOT F3_HDW_BUFFER_MASK
        and     [si].s_stDeviceParms.wDeviceStatus,NOT DEV_ST_FIFO_AVAILABLE

clear_FIFO_control:
        xor     al,al
        OutByteDel bx

set_DCB_defaults::
  ENDIF
; Setup defaults for DCB
        cmp     GS:[di].s_stConfigParms.cwRdTimeout,ZERO
        je      @f
        mov     ax,GS:[di].s_stConfigParms.cwRdTimeout
        mov     [si].s_stDeviceParms.wDefRdTimeout,ax
@@:
        cmp     GS:[di].s_stConfigParms.cwWrtTimeout,ZERO
        je      @f
        mov     ax,GS:[di].s_stConfigParms.cwWrtTimeout
        mov     [si].s_stDeviceParms. wDefWrtTimeout,ax
@@:
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,LINE_CTL_REG_OFFSET
        mov     al,DEFAULT_LINE_CHARACTERISTICS

        cmp     GS:[di].s_stConfigParms.cbyLineCharacteristics,ZERO
        je      @f
        mov     al,GS:[di].s_stConfigParms.cbyLineCharacteristics
        and     al,3fh
@@:
        OutByteDel bx
        and     al,LINE_CTL_WORD_LEN_MASK
        cmp     al,LINE_CTL_WL5
        jne     @f
        mov     [si].s_stDeviceParms.byDataLengthMask,01fh
        jmp     do_def_baud
@@:
        cmp     al,LINE_CTL_WL6
        jne     @f
        mov     [si].s_stDeviceParms.byDataLengthMask,03fh
        jmp     do_def_baud
@@:
        cmp     al,LINE_CTL_WL7
        jne     @f
        mov     [si].s_stDeviceParms.byDataLengthMask,07fh
        jmp     do_def_baud
@@:
        mov     [si].s_stDeviceParms.byDataLengthMask,0ffh

do_def_baud:
  IFNDEF x16_BIT
        cmp     GS:[di].s_stConfigParms.cdwBaudRate,ZERO
        je      do_def_DCB_flags
  ELSE
        cmp     WORD PTR GS:[di].s_stConfigParms.cdwBaudRate,ZERO
        jne     set_baud
        cmp     WORD PTR[di + 2]._stConfigParms.cdwBaudRate,ZERO
        je      do_def_DCB_flags

set_baud:
  ENDIF
  IFNDEF x16_BIT
        mov     eax,GS:[di].s_stConfigParms.cdwBaudRate
  ELSE
        mov     ax,WORD PTR[di]._stConfigParms.cdwBaudRate
        mov     dx,WORD PTR[di + 2]._stConfigParms.cdwBaudRate
  ENDIF
        mov     cx,ax
        and     cx,7fffh      ; limit minimum baud rate
        test    [di].s_stDeviceParms.wConfigFlags1,CFG_FLAG1_EXPLICIT_BAUD_DIVISOR
        jnz     store_baud
  IFNDEF x16_BIT
        test    [si].s_stDeviceParms.wConfigFlags1,CFG_FLAG1_NORMALIZE_BAUD
        jz      @f
IFDEF this_junk
        shl     eax,2
ELSE
        cmp     [si].s_stDeviceParms.xBaudMultiplier,1
        jbe     @f
        xor     ebx,ebx
        mov     bl,[si].s_stDeviceParms.xBaudMultiplier
        mul     ebx
        cmp     edx,0    ; test for overflow
        je      @f
        mov     eax,GS:[di].s_stConfigParms.cdwBaudRate   ; messed up don't multiply (safety net)
ENDIF
@@:
  ENDIF
        call    CalcBaudRate
        jc      do_def_DCB_flags

store_baud:
  IFNDEF x16_BIT
        mov     [si].s_stDeviceParms.dwBaudRate,eax
  ELSE
        mov     WORD PTR[si].s_stDeviceParms.dwBaudRate,ax
        mov     WORD PTR[si + 2].s_stDeviceParms.dwBaudRate,dx
  ENDIF
        mov     [si].s_stDeviceParms.wBaudRateDivisor,cx

do_def_DCB_flags:
        cmp     GS:[di].s_stConfigParms.cwFlags1,ZERO
        je      do_def_flags2
        mov     al,BYTE PTR GS:[di].s_stConfigParms.cwFlags1
        mov     [si].s_stDeviceParms.byFlag1,al

do_def_flags2:
        mov     [si].s_stDeviceParms.byFlag2Mask,0ffh
        and     [si].s_stDeviceParms.byFlag2Mask,NOT (F2_ENABLE_BREAK_REPL OR \
                                                     F2_ENABLE_ERROR_REPL OR \
                                                     F2_ENABLE_NULL_STRIP)
        cmp     GS:[di].s_stConfigParms.cwFlags2,ZERO
        je      do_def_flags3
        mov     al,BYTE PTR GS:[di].s_stConfigParms.cwFlags2
        mov     [si].s_stDeviceParms.byFlag2,al
        test    GS:[di].s_stConfigParms.cwFlags2,F2_ENABLE_BREAK_REPL
        jz      @f
        or      [si].s_stDeviceParms.byFlag2Mask,F2_ENABLE_BREAK_REPL
@@:
        test    GS:[di].s_stConfigParms.cwFlags2,F2_ENABLE_ERROR_REPL
        jz      @f
        or      [si].s_stDeviceParms.byFlag2Mask,F2_ENABLE_ERROR_REPL
@@:
        test    GS:[di].s_stConfigParms.cwFlags2,F2_ENABLE_NULL_STRIP
        jz      do_def_flags3
        or      [si].s_stDeviceParms.byFlag2Mask,F2_ENABLE_NULL_STRIP

do_def_flags3:
        cmp     GS:[di].s_stConfigParms.cwFlags3,ZERO
        je      do_def_characters
        mov     al,BYTE PTR GS:[di].s_stConfigParms.cwFlags3
        mov     [si].s_stDeviceParms.byDefFlag3,al
        mov     [si].s_stDeviceParms.byFlag3,al

do_def_characters:
        cmp     GS:[di].s_stConfigParms.cbyErrorChar,ZERO
        je      @f
        mov     al,BYTE PTR GS:[di].s_stConfigParms.cbyErrorChar
        mov     [si].s_stDeviceParms.byDefErrorChar,al
@@:
        cmp     GS:[di].s_stConfigParms.cbyBreakChar,ZERO
        je      @f
        mov     al,BYTE PTR GS:[di].s_stConfigParms.cbyBreakChar
        mov     [si].s_stDeviceParms.byDefBreakChar,al
@@:
        cmp     GS:[di].s_stConfigParms.cbyXoffChar,ZERO
        je      @f
        mov     al,BYTE PTR GS:[di].s_stConfigParms.cbyXoffChar
        mov     [si].s_stDeviceParms.byDefXoffChar,al
@@:
        cmp     GS:[di].s_stConfigParms.cbyXonChar,ZERO
        je      do_def_FIFO_depth
        mov     al,BYTE PTR GS:[di].s_stConfigParms.cbyXonChar
        mov     [si].s_stDeviceParms.byDefXonChar,al

do_def_FIFO_depth::
        mov     ax,1
        test    [si].s_stDeviceParms.wDeviceFlag2,DEV_FLAG2_FIFO_AVAILABLE
        jz      set_FIFO_depth
  IFNDEF x16_BIT
        cmp     GS:[di].s_stConfigParms.cwTxFIFOdepth,ZERO
        jne     set_user_FIFO_depth
  ENDIF
        mov     ax,MAX_16550_TX_DEPTH
        test_DeviceFlag2 DEV_FLAG2_16650_UART
        jz      try_16654
        mov     ax,MAX_16650_TX_DEPTH
        jmp     set_FIFO_depth

try_16654:
        test_DeviceFlag2 DEV_FLAG2_16654_UART
        jz      try_16750
        mov     ax,MAX_16654_TX_DEPTH
        jmp     set_FIFO_depth

try_16750:
        test_DeviceFlag2 DEV_FLAG2_16750_UART
        jz      set_FIFO_depth
        mov     ax,MAX_16750_TX_DEPTH
        jmp     set_FIFO_depth

  IFNDEF x16_BIT
set_user_FIFO_depth:
        mov     ax,GS:[di].s_stConfigParms.cwTxFIFOdepth
        test    [si].s_stDeviceParms.wConfigFlags2,CFG_FLAG2_EXPLICIT_TX_LOAD
        jnz     set_explicit_TX_load
        cmp     ax,1
        je      set_FIFO_depth
        test_DeviceFlag2 DEV_FLAG2_16650_UART
        jz      test_16554

        cmp     ax,2
        jne     test_16650_L3
        mov     ax,16
        jmp     set_FIFO_depth
test_16650_L3:
        cmp     ax,3
        jne     test_16650_L4
        mov     ax,24
        jmp     set_FIFO_depth

test_16650_L4:
        mov     ax,32
        jmp     set_FIFO_depth

test_16554:
        test_DeviceFlag2 (DEV_FLAG2_16654_UART OR DEV_FLAG2_16750_UART)
        jz      set_16550

        cmp     ax,2
        jne     test_64byteFIFO_L3
        mov     ax,32
        jmp     set_FIFO_depth
test_64byteFIFO_L3:
        cmp     ax,3
        jne     test_64byteFIFO_L4
        mov     ax,48
        jmp     set_FIFO_depth

test_64byteFIFO_L4:
        mov     ax,64
        jmp     set_FIFO_depth

set_16550:
        mov     ax,16
        jmp     set_FIFO_depth

set_explicit_TX_load:
        test_DeviceFlag2 DEV_FLAG2_16650_UART
        jz      test_exp_16654
        cmp     ax,MAX_16650_TX_DEPTH
        jna     set_FIFO_depth
        mov     ax,MAX_16650_TX_DEPTH
        jmp     set_FIFO_depth

test_exp_16654:
        test_DeviceFlag2 DEV_FLAG2_16654_UART
        jz      test_exp_16750
        cmp     ax,MAX_16654_TX_DEPTH
        jna     set_FIFO_depth
        mov     ax,MAX_16654_TX_DEPTH
        jmp     set_FIFO_depth

test_exp_16750:
        test_DeviceFlag2 DEV_FLAG2_16750_UART
        jz      set_exp_16550
        cmp     ax,MAX_16750_TX_DEPTH
        jna     set_FIFO_depth
        mov     ax,MAX_16750_TX_DEPTH
        jmp     set_FIFO_depth

set_exp_16550:
        cmp     ax,MAX_16550_TX_DEPTH
        jna     set_FIFO_depth
        mov     ax,MAX_16550_TX_DEPTH
  ENDIF

set_FIFO_depth:
        mov     [si].s_stDeviceParms.wUserTxFIFOdepth,ax

lock_LID::
        cmp     GS:_bIsTheFirst,TRUE
        jne     clear_BIOS_data
        cmp     GS:_bABIOSpresent,TRUE
        jne     clear_BIOS_data
        mov     bx,OFFSET _astInstallParms
        mov     ax,GS:[bx].s_stInstallParms.wLID;
        or      ax,ax
        jz      clear_BIOS_data
    SetDS     DGROUP            ; GetLIDentry get called from 'C' init code
        push    ds
        push    bx
        call    _GetLIDentry
        add     sp,4
    SetDS     RDGROUP

clear_BIOS_data:

IFDEF this_junk
; clear BIOS data for this port
        mov     cx,4
        mov     ax,40h
        mov     es,ax
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        xor     bx,bx

test_BIOS_var_loop:
        cmp     ES:[bx],dx
        jne     @f
        mov     WORD PTR ES:[bx],0
        jmp     write_installed_message
@@:
        add     bx,2
        loop    test_BIOS_var_loop
ENDIF

write_installed_message::
        call    OutputProgress

; If COMscpope and receive buffers are to be allocated in device driver's data
; segment then calculate end of data segment and read/write/COMscope buffer offsets

; since the buffer lengths are adjustable at initialization time, it is more
; efficient to adjust the read buffer length variable to fit the queue handling
; algorithims at initialization time, rather than at run time

; Memory requirements were calculated above when the device driver segment is to be used.

        xor     eax,eax
        mov     ax,wLastEndOfData

        mov     [si].s_stDeviceParms.oWriteBuffer,ax
        add     ax,[si].s_stDeviceParms.wWrtBufferLength
        mov     [si].s_stDeviceParms.wWrtBufferExtent,ax
        dec     [si].s_stDeviceParms.wWrtBufferExtent        ;adj for zero base

; If it was determined in PRELOAD.C that there wasn't enough space available
; in the device driver's data segment then skip this, as the COMscope and receive
; buffers were defined in UTIL.ASM (MemorySetup).

        cmp     GS:_bUseDDdataSegment,TRUE
        jne     adjust_last_end_of_data

        OR_DeviceFlag2 DEV_FLAG2_USE_DD_DATA_SEGMENT

        mov     [si].s_stDeviceParms.oReadBuffer,eax
        mov     [si].s_stDeviceParms.dwReceiveQueueWritePointer,eax
        mov     [si].s_stDeviceParms.dwReceiveQueueReadPointer,eax
        add     eax,[si].s_stDeviceParms.dwReadBufferLength
        mov     [si].s_stDeviceParms.dwReadBufferExtent,eax
        dec     [si].s_stDeviceParms.dwReadBufferExtent       ;adj for zero base
        mov     [si].s_stDeviceParms.wRdBuffSelector,RDGROUP

   IFNDEF NO_COMscope
        test    GS:[di].s_stConfigParms.cwDeviceFlags1,CFG_FLAG1_COMSCOPE
        jz      adjust_last_end_of_data

        mov     [si].s_stDeviceParms.oCOMscopeBuff,eax
        mov     [si].s_stDeviceParms.dwCOMscopeQWrtPtr,eax
        mov     [si].s_stDeviceParms.dwCOMscopeQRdPtr,eax
        add     eax,[si].s_stDeviceParms.dwCOMscopeBuffLen
        mov     [si].s_stDeviceParms.dwCOMscopeBuffExtent,eax
        sub     [si].s_stDeviceParms.dwCOMscopeBuffExtent,2   ;adj for zero base
        mov     [si].s_stDeviceParms.wCOMscopeSelector,RDGROUP

   ENDIF
adjust_last_end_of_data::
        mov     wLastEndOfData,ax
        mov     wLastDeviceParmsOffset,si

set_end_of_data_segment::
        les     di,pPacket
        mov     ES:[di].s_stPacket.InitDataPacket.DataEndOffset,ax

        inc     wDeviceCount
        mov     bx,GS:_wCurrentDevice
        shl     bx,1
        mov     wDeviceOffsetTable[bx],si

  IFNDEF NO_RESOURCE_MGR
        cmp     GS:_bDisableRM,TRUE
        je      @f
        mov     bx,wBusType
        push    bx
        mov     ax,GS:_wInstallTryCount
        dec     ax
        push    ax
     SetDS    DGROUP
        call    _RMHELP_PortInitComplete
        add     sp,4
     SetDS    RDGROUP
@@:
  ENDIF
init_exit::
        mov     ax,GS:_wLoadCount
        or      ax,ax
        jz      say_bad_load
        cmp     ax,GS:_wInstallTryCount
        jne     set_end_of_code

display_finals::
        cmp     GS:_bBadLoad,TRUE
        jne     @f

say_bad_load:
        mov     GS:_bWaitForCR,TRUE
        mov     GS:_bDelay,TRUE
        mov     GS:_wDelayCount,60
        mov     ax,OFFSET _szFinalError
        call    PrintString
@@:
        cmp     GS:_bWaitForCR,TRUE
        je      test_copyright
        cmp     GS:_bDelay,TRUE
        jne     test_copyright
        Delay   GS:_wDelayCount

test_copyright:
        cmp     GS:_wLoadNumber,NO_INI_FILE
        je      play_copyright
        mov     ax,GS:_wLoadCount
        cmp     wMaxDeviceCount,0
        je      test_last_load
        cmp     ax,wMaxDeviceCount
        jae     play_copyright

test_last_load:
        mov     ax,GS:_wLoadNumber
        cmp     GS:_wDriverLoadCount,ax
        jne     test_final_delay

play_copyright:
        mov     ax,OFFSET _szCopyright
        call    PrintString
        mov     bx,OFFSET _szVersion

        INVOKE sprintf,ADDR _szMessage,0,ADDR _szVersionString_ss,bx,gs,OFFSET _szVerMod,gs
        INVOKE PrintMessage,ADDR _szMessage,ax
        mov     ax,30
        call    CalcDelay
        Delay   ax

test_final_delay:
        cmp     GS:_bWaitForCR,TRUE
        jne     kill_timer

        cmp     wDeviceCount,0
        jne     @f
        cmp     GS:_bIsTheFirst,TRUE
        jne     kill_timer
@@:
        mov     ax,OFFSET _szWaitKeyMessage
        call    PrintString
        mov     GS:_bWaitingKey,TRUE
        Delay   GS:_wDelayCount
        mov     ax,OFFSET _szCR
        call    PrintString

kill_timer:
        cmp     GS:_bTimerAvailable,TRUE
        jne     set_end_of_code
        mov     GS:_bTimerAvailable,FALSE
        mov     ax,OFFSET InitTimer
        mov     dl,DevHlp_ResetTimer
        call    device_hlp

set_end_of_code:
        lea     ax,BEGIN_INIT_CODE
   IFDEF VDD_support
        cmp     GS:_bIsTheFirst,TRUE
        je     @f
        lea     ax,BEGIN_VDD_CODE
@@:
   ENDIF
        les     di,pPacket
        mov     word ptr ES:[di].s_stPacket.InitDataPacket.CodeEndOffset,ax

; clear other return parameters (as required by OS/2)

        xor     ax,ax
        mov     ES:[di].s_stPacket.InitDataPacket.DeviceCount,al
        mov     WORD PTR ES:[di].s_stPacket.InitDataPacket.BPBoffset,ax
        mov     WORD PTR ES:[di].s_stPacket.InitDataPacket.BPBoffset + 2,ax
        ret

Init ENDP

INIT_CODE_END EQU $

RES_CODE ENDS

     END
