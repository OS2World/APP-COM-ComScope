;************************************************************************
;
; $Revision:   1.6  $
;
; $Log:   P:/archive/comi/hdw_test.asv  $
;
;     Rev 1.6   28 Mar 1996 00:20:02   EMMETT
;  Added resource manager.  Began work on VDD support.
;
;     Rev 1.5   18 Feb 1996 14:17:56   EMMETT
;  Added many features.  Notably:
;  Tracing application DosDevIOCtl function calls and packets.
;  Support for 16650 and 16750 UARTs.
;  Streamlined interrupt routine.
;
;     Rev 1.4   25 Apr 1995 22:16:34   EMMETT
;  Added Support for DigiBoard PC/16.  Changed interrupt Routine for better adapter independence.
;  Changed interrupt routine to allow user to select interrupting device selection algorithim.  Fixed
;  ABIOS interaction for better "non.INI" initialization in MCA machines.  Fixed various initialization
;  message strings.  COMscope and receive buffer are now allocated from system memory, allowing
;  a 32k (word) COMscope buffer and a 64k (byte) receive buffer.
;
;     Rev 1.3   03 Dec 1994 14:49:32   EMMETT
;
;
;     Rev 1.2   28 Jun 1994 09:09:28   EMMETT
;  Added "clear all interrupts" to handle interrupt ID register problems when one or more ports
;  on an adapter were in an interrupt state at system reset time.
;
;     Rev 1.1   11 Jun 1994 10:37:54   EMMETT
;  Changed all references to "Mirror" to "COMscope".
;
;     Rev 1.0   07 Jun 1994 00:19:08   EMMETT
;  Added support for DigiBoard.
;  Added initialization support for OEM specific loads.
;  Fixed hardware tests to set baud rate before testing interrupts.
;  Fixed hardware tests off switch to work only for retail version.
;
;************************************************************************

;use_MCA_table EQU 1

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

    EXTRN bSharedInterrupts     :WORD
    EXTRN stDeviceParms         :s_stDeviceParms
    EXTRN wIntIDregister        :WORD
    EXTRN wDeviceIntOffsetTable :WORD
    EXTRN bNoOUT2change         :WORD
    EXTRN device_hlp            :DWORD
    EXTRN wInterruptsUsed       :WORD
    EXTRN IDCdata               :WORD
;    EXTRN byOEMtype             :BYTE
    EXTRN wOEMjumpEntry         :BYTE
    EXTRN byIntStatusMask       :BYTE
    EXTRN wPCIvendor            :WORD
    EXTRN wPCIdevice            :WORD
  IFNDEF NO_4x_CLOCK_SUPPORT
    EXTRN dwTimerCounter        :DWORD
  ENDIF
    EXTRN wInitTimerCount       :WORD
    EXTRN byAdapterType         :BYTE

  IFDEF OEM
    EXTRN bOEMpresent           :WORD
  ENDIF

    EXTRN stStackUsage          :s_stStackUsage

RES_DATA ENDS

_DATA SEGMENT

.XLIST
    INCLUDE MSG.INC

    EXTRN _szMessage            :BYTE

    EXTRN _byInitIntORmask      :BYTE
    EXTRN _byInitIntANDmask     :BYTE
    EXTRN _bABIOSpresent        :WORD
;    EXTRN _abyCOMnumbers        :BYTE

    EXTRN _bTimerAvailable      :WORD


;    EXTRN _wLoadNumber          :WORD
    EXTRN _wLoadFlags           :WORD
    EXTRN _wLoadCount           :WORD
  IFNDEF x16_BIT
    EXTRN _Ring0Vector          :DWORD
  ENDIF
    EXTRN _bBadLoad             :WORD

;    EXTRN _abyString            :BYTE

;    EXTRN _wCurrentDevice       :WORD
;    EXTRN _wDelayCount          :WORD

    EXTRN _stConfigParms       :s_stConfigParms

    EXTRN _bValidIntIDreg       :WORD
    EXTRN _bValidInterrupt      :WORD
    EXTRN _wInitTestPort        :WORD
;    EXTRN _bWaitForCR           :WORD
    EXTRN _bUsesSixteenAddrLines:WORD

    EXTRN _byIntIDregisterPreset:BYTE
;    EXTRN _wInitDebugFlags      :WORD
    EXTRN _xBaudMultiplier      :BYTE

;    EXTRN _ADFtable             :WORD
    EXTRN _bIsTheFirst          :WORD

  IFDEF OEM
    EXTRN ISA_bad_msg           :BYTE
    EXTRN MCA_bad_msg           :BYTE
    EXTRN Contact_msg           :BYTE
    EXTRN OS_tools_BLURB        :BYTE
  ENDIF
.LIST

_DATA ENDS

RES_CODE SEGMENT
    ASSUME CS:RCGROUP, ES:nothing, SS:nothing, DS:RDGROUP, GS:DGROUP

;-------------------------------------------------------------------------------
; Initialization procedures are placed after BEGIN_INIT_CODE so they can go
; away once initialization has completed.
;-------------------------------------------------------------------------------

    EXTRN PrintString           :NEAR
    EXTRN binac_10              :NEAR
    EXTRN binac                 :NEAR
    EXTRN GetCOMnumber          :NEAR
    EXTRN DelayFunction         :NEAR
    EXTRN SetRing0Access        :NEAR

  IFDEF COPY_PROTECT
    EXTRN _TestHidden           :NEAR
  ENDIF

; SI to contain offset to stDeviceParms
; DI to contain offset to _stConfigParms with GS = DGROUP
TestValidHDW PROC NEAR USES ax dx ds

        LOCAL   wSaveBaudDivisor:WORD
        LOCAL   bMaybe16550:WORD
        LOCAL   bMaybeTI_ACE:WORD
        LOCAL   wFIFOcount:WORD
;        LOCAL   wHDWerror:WORD

;        mov     wHDWerror, 0
        mov     bMaybeTI_ACE,FALSE
        mov     bMaybe16550,FALSE

        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,INT_ID_REG_OFFSET

; test if bit four of the interrupt ID register is a zero.  This bit is always
; zero in 16450, 16550, and 16750 UARTs, and is always zero after a reset
; the in 16650 UART.

        InByteImm
        add     dx,MDM_CTL_REG_OFFSET - INT_ID_REG_OFFSET
        test    al,10h
        jz      @f
        jmp     test_16650_UART      ; not a 16550 or 16750, could be 16650
@@:
        mov     bMaybeTI_ACE,TRUE

; test if bit five of the interrupt ID register is a zero.  This bit is always
; zero in 16450 and 16550 UARTs, and is always zero after a reset
; the in 16650 and 16750 UARTs.

        test    al,20h
        jz      @f
        jmp     test_16650_UART      ; not 16550, could be 16650 or 16750
@@:
        mov     bMaybe16550,TRUE

test_16650_UART:
; Test if all support bits of the modem control register can be turned on.
; If this test fails it might be because it is a 16650 UART that has been left
; in the HDW RTS handshaking mode

;        mov     al,0f0h
;        OutByteDel bx
;        InByteDel bx
;        cmp     al,0f0h
;        je      flag_as_16650_UART

; try to enable EFR access, enable 16650 extensions, and clear handshake modes.

        add     dx,LINE_CTL_REG_OFFSET - MDM_CTL_REG_OFFSET
        InByteImm
        mov     ah,al
        test    ah,80h
        jz      @f
        mov     ah,03       ; if DLB bit was on then force LCR to be restored to a normal mode
@@:
        mov     al,0bfh
        OutByteDel bx
        add     dx,EFR_REG_OFFSET - LINE_CTL_REG_OFFSET
        mov     al,EFR_ENABLE_16650
        OutByteDel bx
        add     dx,LINE_CTL_REG_OFFSET - EFR_REG_OFFSET
        mov     al,ah
        OutByteDel bx

; retest modem control register bits

        add     dx,MDM_CTL_REG_OFFSET - LINE_CTL_REG_OFFSET
        mov     al,0b0h
        OutByteDel bx
        InByteDel bx
        cmp     al,0b0h
        je      flag_as_16650_UART
        cmp     bMaybeTI_ACE,TRUE
        je     test_TI_ACE_UART
        cmp     bMaybe16550,TRUE
        je     test_16550_UART
; mov wHDWerror,1
not_UART_1::
        jmp     not_UART

flag_as_16650_UART:
        xor     al,al       ;clear modem control register
        OutByteDel bx
; Turn off 1665x extensions
        add     dx,LINE_CTL_REG_OFFSET - MDM_CTL_REG_OFFSET
        InByteDel bx
        mov     ah,al
        mov     al,0bfh
        OutByteDel bx
        add     dx,EFR_REG_OFFSET - LINE_CTL_REG_OFFSET
        mov     al,0
        OutByteDel bx
        add     dx,LINE_CTL_REG_OFFSET - EFR_REG_OFFSET
        mov     al,ah
        OutByteDel bx

        OR_DeviceFlag2 DEV_FLAG2_16650_UART
        jmp     init_UART

test_TI_ACE_UART:
; Test if only LOOP bit of modem control address register is toggled

        mov     al,0f0h
        OutByteDel bx
        InByteDel bx
        mov     ah,al
        and     ah,0f0h         ; test only upper nibble, HS bits could be on
        cmp     ah,30h          ; LOOP and AFE should be only bits on
        je      test_TI_ACE
        cmp     bMaybe16550,TRUE
        je      test_16550_UART
; mov wHDWerror,2
not_UART_2::
        jmp     not_UART

test_TI_ACE:
        xor     al,al
        OutByteDel bx


        add     dx,LINE_CTL_REG_OFFSET - MDM_CTL_REG_OFFSET
        mov     al,LINE_CTL_DLB_ACCESS
        OutByteDel bx
        add     dx,FIFO_CTL_REG_OFFSET - LINE_CTL_REG_OFFSET
        mov     al,0ffh
        OutByteDel bx
        InByteDel bx
        test    al,FIFO_CTL_16750_64_BYTE_FIFO
        jz      flag_as_TI16550C

        OR_DeviceFlag2 DEV_FLAG2_16750_UART
        jmp     clear_TI_ACE_registers

flag_as_TI16550C:
        OR_DeviceFlag2 DEV_FLAG2_TI16550C_UART

clear_TI_ACE_registers:
        mov     al,0
        OutByteDel bx
        add     dx,LINE_CTL_REG_OFFSET - FIFO_CTL_REG_OFFSET
        OutByteDel bx
        jmp     init_UART



test_16550_UART:
; Test if only LOOP bit of modem control address register is toggled

        or      al,0f0h
        OutByteDel bx
        InByteDel bx
        mov     ah,al
        and     ah,0f0h
        cmp     ah,10h
        je     @f
; mov wHDWerror,3
not_UART_3::
        jmp     not_UART
@@:
;        jne     not_UART
        and     al,0fh
        OutByteDel bx

init_UART::
        cmp     bSharedInterrupts,TRUE
        je      @f
        cmp     wIntIDregister,0
        je      clear_int_this_device
@@:
; Clear all interrtups also turns on OUT2 for all UARTs in the series
; For now eight UARTs are assumed as this is being added to support
; Sealevel System's eight port adapter.

        call    ClearAllInterrupts

clear_int_this_device:
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,MDM_CTL_REG_OFFSET
        xor     al,al

; set OUT1 as requested

        test    GS:[di].s_stConfigParms.cwDeviceFlags2,CFG_FLAG2_ACTIVATE_OUT1
        jz      @f
        mov     al,MDM_CTL_OUT1_ACTIVATE
@@:
        cmp     bNoOUT2change,TRUE  ; this is the initialization of this state (Sealevel only)
        jne      @f
        or      al,MDM_CTL_OUT2_ACTIVATE
@@:
        OutByteDel bx      ;deactivate all modem signals, except OUT1 and OUT2 if requested
        xor     al,al
        add     dx,INT_EN_REG_OFFSET - MDM_CTL_REG_OFFSET
        OutByteDel bx                 ; disable all interrupts
        add     dx,LINE_ST_REG_OFFSET - INT_EN_REG_OFFSET
        InByteDel bx                  ; clear line and error interrupts
        add     dx,MDM_ST_REG_OFFSET - LINE_ST_REG_OFFSET
        InByteImm                  ; clear modem interrupts
        sub     dx,MDM_ST_REG_OFFSET
        InByteImm                  ; read input buffer

empty_RX_buffer_loop:
        add     dx,LINE_ST_REG_OFFSET
        InByteImm
        sub     dx,LINE_ST_REG_OFFSET
        test    al,LINE_ST_RCV_DATA_READY
        jz      enable_FIFOs
        InByteImm
        jmp     empty_RX_buffer_loop


enable_FIFOs:
        add     dx,FIFO_CTL_REG_OFFSET
        mov     al,07h
        OutByteDel bx
        InByteDel bx
        mov     ah,al     ; save for 16 bit addressing test
        and     al,0c0h
        cmp     al,0c0h
        jne     no_FIFO
        or      [si].s_stDeviceParms.wDeviceFlag2,DEV_FLAG2_FIFO_AVAILABLE
        jmp     @f

no_FIFO:
        and     [si].s_stDeviceParms.byFlag3,NOT F3_HDW_BUFFER_MASK
        and     [si].s_stDeviceParms.wDeviceFlag2,NOT DEV_FLAG2_FIFO_AVAILABLE
;        xor     al,al
;        OutByteDel bx
@@:
; test for 16 bit addressing
        test    dx,0fc00h   ; if bits are on then device is 16 bit addressable
        jnz     is_16_bit_addressable
        or      dx,08000h
        InByteDel bx
        and     dx,07fffh
        cmp     al,ah
        jne     @f

is_16_bit_addressable:
        mov     GS:_bUsesSixteenAddrLines,TRUE
@@:
  IFDEF NO_4x_CLOCK_SUPPORT
; Reset and turn off FIFOs if not testing for 4x clock.
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,FIFO_CTL_REG_OFFSET
        mov     al,(FIFO_CTL_TX_RESET OR FIFO_CTL_RX_RESET)
        OutByteDel bx                 ; reset FIFOs (SMC fix)
        xor     al,al
        OutByteDel bx                    ; disable FIFOs
  ENDIF
set_test_BAUD::  
; set the baud rate for these next tests  
; if LOAD_FLAG1_FORCE_4X_TEST is true then
;   set to 1200 baud
;     The baud rate must be at least 1200 baud (or 10 milliseconds/character).
;     The reason for the low maximum is in case the port is an idiot built-in
;     modem (old hardware).
; else
;   set to 57600 baud
;
; save baud rate (just in case something very low level, debugger maybe,
; has already set up the port).

        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,LINE_CTL_REG_OFFSET
        mov     al,80h
        OutByteDel bx
        add     dx,DLB_LOW_REG_OFFSET - LINE_CTL_REG_OFFSET
        InByteDel bx
        mov     BYTE PTR wSaveBaudDivisor,al
        mov     al,2   ; 57600 baud
        test    GS:_wLoadFlags,LOAD_FLAG1_FORCE_4X_TEST
        jz      @f
        mov     al,96   ; 1200 baud
@@:        
        OutByteDel bx
        add     dx,DLB_HI_REG_OFFSET - DLB_LOW_REG_OFFSET
        InByteDel bx
        mov     BYTE PTR wSaveBaudDivisor + 1,al
        xor     al,al
        OutByteDel bx
        add     dx,LINE_CTL_REG_OFFSET - DLB_HI_REG_OFFSET
; set  8, none, 1 line characteristics for tests
        mov     al,03h ;setup eight bit data for tests
        OutByteDel bx

; Request interrupt for connection test
req_interrupt_test::
        mov     GS:_bValidIntIDreg,FALSE
        mov     GS:_bValidInterrupt,FALSE
        mov     GS:_wInitTestPort,si

        mov     dh,DH_SIRQ_NOT_SHARED
        cmp     bSharedInterrupts,TRUE
        jne     @f
        mov     dh,DH_SIRQ_SHARED
@@:
        mov     ax,OFFSET InitInterrupt
        xor     bx,bx
        mov     bl,[si].s_stDeviceParms.byInterruptLevel
        cmp     bl,MIN_INT_LEVEL
        jb      output_invalid_int_msg
        cmp     bl,MAX_INT_LEVEL
        ja      output_invalid_int_msg
        mov     dl,DevHlp_SetIRQ
        call    device_hlp
        jnc     test_interrupt_used

output_invalid_int_msg:
        xor     cx,cx
        mov     cl,bl
        call    GetCOMnumber
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szInterruptError_uu,cx,bx
        INVOKE PrintMessage,ADDR _szMessage,ax
        mov     GS:_bBadLoad,TRUE
        stc
        pushf
        jmp     HDW_test_exit

; determine if we need to call RegisterStackUsage
test_interrupt_used::
        xor     ax,ax
        mov     al,[si].s_stDeviceParms.byInterruptLevel
        mov     cx,ax
        mov     bx,1
        shl     bx,cl
        cmp     GS:_bIsTheFirst,TRUE
        jne     @f
        test    wInterruptsUsed,bx
        jnz     test_interrupts
        or      wInterruptsUsed,bx
        jmp     register_stack_usage
@@:
        call    SetRing0Access
        jc      register_stack_usage
        sub     sp,6            ;API expects to pop 12 words, just pretending to push three words
        push    OFFSET IDCdata  ; offset to IDC data area
        push    ax              ; interrupt level to test
        push    DO_IDC_ACCESS_IRQ   ; ring zero IDC function call
        call    GS:_Ring0Vector
        jc      test_interrupts

register_stack_usage:
        xor     ax,ax
        mov     al,[si].s_stDeviceParms.byInterruptLevel
        lea     bx,stStackUsage
        mov     [bx].s_stStackUsage.wIRQlevel,ax
        mov     dx,DevHlp_RegisterStackUsage
        call    device_hlp
        jc      output_no_stack_msg
        jmp     test_interrupts

output_no_stack_msg:
        xor     cx,cx
        mov     cl,[si].s_stDeviceParms.byInterruptLevel
        call    GetCOMnumber
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szNoStackAvailable_uu,bx,cx
        INVOKE PrintMessage,ADDR _szMessage,ax
        mov     GS:_bBadLoad,TRUE
        stc
        pushf
        jmp     restore_UART

test_interrupts::
; if interrupt ID register is defined then initialize it in case it
; is really a scratch register (user error)
        cmp     wIntIDregister,ZERO
        je      @f
        mov     dx,wIntIDregister
        mov     al,GS:_byIntIDregisterPreset
        OutByteDel bx
@@:
; Make OUT2 active - enables hardware connection for UART interrupts
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,MDM_CTL_REG_OFFSET
        cmp     bNoOUT2change,TRUE
        je      @f
        InByteDel bx
        or      al,MDM_CTL_OUT2_ACTIVATE
        OutByteDel bx
@@:
; enable TX interrupts for interrupt connect test - this should cause an
; interrupt immediately after TX interrupts are enabled.
        add     dx,INT_ID_REG_OFFSET - MDM_CTL_REG_OFFSET
        InByteDel bx
        add     dx,INT_EN_REG_OFFSET - INT_ID_REG_OFFSET
        mov     al,INT_EN_TX_HOLD_EMPTY
        OutByteDel bx
        
        Delay   2
; test if hardware is connected to specified interrupt level

init_interrupt_test_point::
        xor     al,al
        OutByteDel bx                                 ; disable TxRdy interrupt
        add     dx,MDM_CTL_REG_OFFSET - INT_EN_REG_OFFSET
        cmp     bNoOUT2change,TRUE
        je      @f
        InByteDel bx
        and     al,NOT MDM_CTL_OUT2_ACTIVATE
        OutByteDel bx                                 ; deactivate OUT2
@@:
        cmp     GS:_bValidInterrupt,TRUE
        jne     bad_interrupt

  IFDEF OEM
; if this is an ISA machine and this load is OEM specific then test for
; interrupt ID register
        cmp     GS:_bABIOSpresent,TRUE
        je      test_UART

        cmp     wIntIDregister,ZERO
        jne     test_valid_int_ID

        cmp     GS:_bIsTheFirst,TRUE
        je      test_UART
        cmp     bOEMpresent,TRUE
        je      test_UART

; IF this is OEM specific (not Sealevel) then either there is an interrupt
; ID register or there has been a previous load of this device driver for a
; qualified adapter board, otherwise print error and disallow device support.

        call    BadISAmessage

end_load_attempt:
        mov     ax,0ffffh
        mov     WORD PTR [si].s_stDeviceParms.stDeviceHeader.pNextHeader,ax
        mov     WORD PTR [si + 2].s_stDeviceParms.stDeviceHeader.pNextHeader,ax
        jmp     bad_device

test_valid_int_ID:
  ELSE
        cmp     wIntIDregister,ZERO
        je      test_UART
  ENDIF
        cmp     GS:_bValidIntIDreg,TRUE
        jne     bad_int_ID_reg

  IFDEF OEM
        mov     bOEMpresent,TRUE
  ENDIF

test_UART::
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,MDM_CTL_REG_OFFSET
        InByteDel bx
        cmp     bNoOUT2change,TRUE
        je      @f
        and     al,NOT MDM_CTL_OUT2_ACTIVATE
@@:
        or      al,MDM_CTL_LOOPBK_ENABLE
        OutByteDel bx                   ; deactivate OUT2 and enable Loopback
        Delay   2                       ; just in case :-)

; clear receive register (and FIFOs, if any) and test that loop back works

clear_RCV_reg:
        IOdelay bx
        sub     dx,MDM_CTL_REG_OFFSET

clear_RCV_reg_loop:
        add     dx,LINE_ST_REG_OFFSET
        InByteImm
        sub     dx,LINE_ST_REG_OFFSET
        test    al,LINE_ST_RCV_DATA_READY
        jz      test_loopback
        InByteImm
        jmp     clear_RCV_reg_loop

test_loopback:
        mov     al,0aah
        OutByteDel bx
        Delay   2
        xor     al,al
        InByteDel bx
        cmp     al,0aah
        je     @f
; mov wHDWerror,4
not_UART_4::
        jmp     not_UART
@@:
;        jne     not_UART
        mov     al,55h
        OutByteDel bx
        Delay   2
        xor     al,al
        InByteDel bx
        cmp     al,55h
        je     @f
; mov wHDWerror,5
not_UART_5::
        jmp     not_UART
@@:
;        jne     not_UART

; if not PCI device then clear baud multiplier
        cmp     wPCIvendor,0
        je      test_baud_clock

; if PCI adapter and baud multiplier had already been set then skip test
        cmp     GS:_xBaudMultiplier,0
        je      test_baud_clock
        mov     al,GS:_xBaudMultiplier
        jmp     set_baud_multiplier

; if there are FIFOs available then try to determine baud clock
; (still in loop back mode)
; Could test clock when there are no FIFOs, but it is unlikely that
; a faster clock will be available when there are no FIFOs anyway.
; So why bother?

test_baud_clock::
; If there are no FIFOs then an X clock is NOT supported
        test    [si].s_stDeviceParms.wDeviceFlag2,DEV_FLAG2_FIFO_AVAILABLE
        jz      disable_FIFOs

; If there are FIFOs and the user wants to force an X clock test then allow it
        test    GS:_wLoadFlags,LOAD_FLAG1_FORCE_4X_TEST
        jnz     test_X_clock

; always test clock for PCI devices
        cmp     wPCIvendor,0
        jne     test_X_clock

; Otherwise don't test for X baud clock if UART is 16550.
; There is a problem with some internal modems that will make us think
; there is a X clock when there is none.
        test_DeviceFlag2 (DEV_FLAG2_16650_UART OR DEV_FLAG2_16750_UART OR DEV_FLAG2_16654_UART)
        jz      disable_FIFOs

test_X_clock:
;  setting 75 BPS to allow detecting up to 16x baud clocks
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,LINE_CTL_REG_OFFSET
        mov     al,80h
        OutByteDel bx                                                                             
        add     dx,DLB_LOW_REG_OFFSET - LINE_CTL_REG_OFFSET
        xor     al,al
        OutByteDel bx
        add     dx,DLB_HI_REG_OFFSET - DLB_LOW_REG_OFFSET
        mov     al,06h   ; 75 baud in order to test up to 16x baud clocks
        OutByteDel bx
        add     dx,LINE_CTL_REG_OFFSET - DLB_HI_REG_OFFSET
        mov     al,03h ;setup eight bit data for tests
        OutByteDel bx
        
; Only the 16650 has a bit to select the baud rate divisor.
; Just in case that bit is enabled from before a warm boot we will
; explicitly turn it off.

        test_DeviceFlag2 DEV_FLAG2_16650_UART
        jz      test_timer
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,LINE_CTL_REG_OFFSET
        InByteImm
        mov     ah,al           ;save LCR
        mov     al,0bfh         ;enable EFR access
        OutByteDel bx
        add     dx,EFR_REG_OFFSET - LINE_CTL_REG_OFFSET
        mov     al,EFR_ENABLE_16650
        OutByteDel bx              ; enable 16650 extensions
        add     dx,MDM_CTL_REG_OFFSET - EFR_REG_OFFSET
        InByteDel bx
        and     al,NOT MDM_CTL_DIV_4_CLOCK
        or      al,MDM_CTL_LOOPBK_ENABLE     ; just in case :-)
        OutByteDel bx
        add     dx,EFR_REG_OFFSET - MDM_CTL_REG_OFFSET
        xor     al,al
        OutByteDel bx              ; disable 16650 extensions
        add     dx,LINE_CTL_REG_OFFSET - EFR_REG_OFFSET
        mov     al,ah
        OutByteDel bx              ; restore LCR, disabling EFR access

test_timer:
  IFNDEF NO_4x_CLOCK_SUPPORT
; The Connect Tech BlueHeat PCI adpater uses a 12x baud clock, so don't
; bother to test the baud clock.
;        cmp     wPCIvendor,PCI_VENDOR_MOXA
;        je      test_FIFO_size
;        cmp     wPCIvendor,PCI_VENDOR_CONNECTECH
;        jne     test_4x
;        test    wPCIdevice,PCI_DEVICE_BLUEHEAT_MSK
;        jz      test_4x
;        jmp     test_FIFO_size
;test_4x:
        cmp     GS:_bTimerAvailable,TRUE
        jne     test_FIFO_size
        mov     cx,16
;        IOdelay bx
        mov     dwTimerCounter,0        ; restart timer counter

        mov     dx,[si].s_stDeviceParms.wIObaseAddress

test_fill_loop:                 ; fill FIFO (16 bytes)
        OutByteDel bx
        loop test_fill_loop

        IOdelay bx
        add     dx,LINE_ST_REG_OFFSET

test_wait_loop:                 ; wait for holding register to be empty
        InByteImm
        test    al,LINE_ST_TX_HOLD_EMPTY
        jz      test_wait_loop

IFDEF _4X_baudClockOnly
;; sixteen characters (10 bits each) at 1200 baud (clock divisor = 96)
;;16 * 1/120 = 133 ms with 1.8432MHz clock - EAX will be around 4 (133 / 32)
;;16 * 1/120 =  33 ms with 7.3728MHz clock - EAX will be around 1 ( 33 / 32)
;; if EAX less than 2, must be 4x clock - only 4x clock is supported without
;; enabling explicit baud divisor extension.
        cmp    eax,2
        jb     test_FIFO_size
        OR_DeviceFlag2 DEV_FLAG2_4x_BAUD_CLOCK  ;4x clock
ELSE
; sixteen characters (10 bits each) at 75 baud (clock divisor = 600h (1536))
;16 * 1/7.5 = 2128 ms with 1x (1.8432MHz) clock - EAX will be > 60        - (2128 / 32) = 66.5
;16 * 1/7.5 =  532 ms with 4x (7.3728MHz) clock - EAX will be < 60 & > 10 -  (532 / 32) = 16.6
;16 * 1/7.5 =  266 ms with 8x (14.7456MHz) clock - EAX will be < 15 & > 7 -  (266 / 32) = 8.3
;16 * 1/7.5 =  177 ms with 12x (22.1184MHz) clock - EAX will be < 7 & > 4 -  (177 / 32) = 5.5
;16 * 1/7.5 =  133 ms with 16x (29.4912MHz) clock - EAX will be < 5 & > 3 -  (133 / 32) = 4.2
; if EAX > 60, must be 1x clock

get_baud_multiplier::
        mov     eax,dwTimerCounter  ; save timer counter
        cmp     eax,60
        jae     test_FIFO_size
        cmp     eax,40
        jb      test_4x
        mov     al, 1
        jmp     set_baud_multiplier
test_4x:
        cmp     eax,15
        jb      test_8x
        mov     al, 4
        jmp     set_baud_multiplier
test_8x:
        cmp     eax,7
        jb      test_12x
        mov     al, 8
        jmp     set_baud_multiplier
test_12x:
        cmp     eax,5
        jb      set_16x
        mov     al, 12
        jmp     set_baud_multiplier
set_16x:
        mov     al, 16

set_baud_multiplier::
        mov    GS:_xBaudMultiplier,al
        mov    [si].s_stDeviceParms.xBaudMultiplier,al
ENDIF
  ENDIF ;NOT NO_4x_CLOCK_SUPPORT

; determine FIFO depth - 16650 only
test_FIFO_size::
        test_DeviceFlag2 DEV_FLAG2_16650_UART
        jz      disable_FIFOs

        mov     dx,[si].s_stDeviceParms.wIObaseAddress
;        sub     dx,LINE_ST_REG_OFFSET
        mov     cx,256
        IOdelay bx

empty_FIFO_loop:
;        InByteDel bx
        InByteImm
        loop    empty_FIFO_loop

        mov     cx,128
        mov     ax,1
        IOdelay bx

size_fill_loop:
;        OutByteDel bx
        OutByteImm
        inc     ax
        loop    size_fill_loop

        add     dx,LINE_ST_REG_OFFSET
        IOdelay bx

size_wait_loop:                 ; wait for holding register to be empty
;        InByteDel bx
        InByteImm
        test    al,LINE_ST_TX_HOLD_EMPTY
        jz      size_wait_loop

        mov     cx,256
        sub     dx,LINE_ST_REG_OFFSET
        xor     ax,ax
        mov     wFIFOcount,0
        IOdelay bx

; depending on the read buffer repeating the last character read once the FIFO is empty
size_test_loop:
;        InByteDel bx
        InByteImm
        cmp     al,ah
        je      size_found
        inc     wFIFOcount
        mov     ah,al
        loop    size_test_loop

size_found::
;        cmp     al,40
        cmp     wFIFOcount,40
        jl      disable_FIFOs
        AND_DeviceFlag2 NOT DEV_FLAG2_16650_UART
        OR_DeviceFlag2 DEV_FLAG2_16654_UART

disable_FIFOs::
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,FIFO_CTL_REG_OFFSET
        mov     al,FIFO_CTL_RESET_FIFOS
        OutByteDel bx                 ; reset FIFOs only (SMC fix)
;        xor     al,al
;        OutByteImm                    ; disable FIFOs

clear_RX_FIFO:

        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        cmp     bNoOUT2change,TRUE
        jne     clear_RX_FIFO_loop
        add     dx,MDM_CTL_REG_OFFSET
        InByteDel bx
        mov     al,MDM_CTL_OUT2_ACTIVATE
        OutByteDel bx
        sub     dx,MDM_CTL_REG_OFFSET

clear_RX_FIFO_loop:
        add     dx,LINE_ST_REG_OFFSET
        InByteDel bx
        sub     dx,LINE_ST_REG_OFFSET
        test    al,LINE_ST_RCV_DATA_READY
        jz      valid_exit
        InByteImm
        jmp     clear_RX_FIFO_loop

valid_exit:
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,INT_ID_REG_OFFSET
        InByteImm                       ; clear interrupts
        InByteImm                       ; again, just in case

        clc
        jmp     test_UART_exit

bad_interrupt:
        xor     cx,cx
        mov     cl,[si].s_stDeviceParms.byInterruptLevel
        call    GetCOMnumber
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szHDWinterruptError_uu,
                                          bx,
                                          cx
        INVOKE PrintMessage,ADDR _szMessage,ax
        jmp     bad_device

bad_int_ID_reg:
        call    GetCOMnumber
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szInterruptIDerror_u,bx
        INVOKE PrintMessage,ADDR _szMessage,ax
        jmp     bad_device

not_UART:
        call    GetCOMnumber
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szHDWerror_xu,
                                          [si].s_stDeviceParms.wIObaseAddress,
                                          bx
        INVOKE PrintMessage,ADDR _szMessage,ax

bad_device:
        stc

test_UART_exit:
        pushf

; clear interrupt control register - disable all interrupts

        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,INT_EN_REG_OFFSET
        xor     al,al
        OutByteDel bx

; clear OUT2 and LOOP bits

        add     dx,MDM_CTL_REG_OFFSET - INT_EN_REG_OFFSET
        xor     al,al
        test    GS:[di].s_stConfigParms.cwDeviceFlags2,CFG_FLAG2_ACTIVATE_OUT1
        jz      @f
        mov     al,MDM_CTL_OUT1_ACTIVATE
@@:
        cmp     bNoOUT2change,TRUE
        jne     @f
        or      al,MDM_CTL_OUT2_ACTIVATE
@@:
        OutByteDel bx

;restore baud rate and set default line characteristics

restore_UART:

        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,LINE_CTL_REG_OFFSET
        InByteDel bx
        or      al,80h
        OutByteDel bx
        sub     dx,LINE_CTL_REG_OFFSET
        mov     ax,wSaveBaudDivisor
        OutByteDel bx
        xchg    al,ah
        inc     dx
        OutByteDel bx
        dec     dx
        add     dx,LINE_CTL_REG_OFFSET
        InByteDel bx
        mov     al,DEFAULT_LINE_CHARACTERISTICS
        OutByteDel bx

release_interrupt:
        xor     bx,bx
        mov     bl,[si].s_stDeviceParms.byInterruptLevel
        mov     dl,DevHlp_UnSetIRQ
        call    device_hlp

HDW_test_exit::
        popf
        ret

TestValidHDW ENDP       ; CARRY set if no UART found

;-------------------------------------------------------------------------
;
; ClearAllInterrupts
;
; This routine is necessary because if there is one port that is connected
; to an interrupt ID register that has any interrupts enabled, and pending,
; it will cause all ports initialized before it to fail the interrupt
; connection test.  This is because that port will cause the interrupt ID
; register to indicate an interrupt pending to the 8259 interrupt controller
; for that interrupt level, and therefore, until the ID register is cleared
; the 8359 will not cause the initialization interrupt routine to be called.
;
;-------------------------------------------------------------------------

; assume GS = DGROUP
ClearAllInterrupts PROC NEAR USES DI

        lea     di,_stConfigParms
        mov     cx,GS:_wLoadCount
        or      cx,cx
        jz      exit


clear_all_OEM_loop:
        cmp     bSharedInterrupts,TRUE
        je      clear_interrupts

        mov     dx,wIntIDregister
        InByteDel bx
        test    GS:_wLoadFlags,LOAD_FLAG1_DIGIBOARD08_INT_ID
        jnz     DigiBoard_ID
        or      al,al
        jz      done
        jmp     clear_interrupts

DigiBoard_ID:
        test    al,80h
        jnz     done

clear_interrupts:
        mov     dx,GS:[di].s_stConfigParms.cwIObaseAddress
        add     dx,MDM_CTL_REG_OFFSET
        xor     al,al
        OutByteDel bx           ;clear modem comtrol register
        add     dx,INT_EN_REG_OFFSET - MDM_CTL_REG_OFFSET
        OutByteDel bx              ;clear interrupt enable register
        add     dx,MDM_ST_REG_OFFSET - INT_EN_REG_OFFSET
        InByteDel bx               ;read modem status register
        add     dx,LINE_ST_REG_OFFSET - MDM_ST_REG_OFFSET
        InByteImm               ;read line status register
        sub     dx,LINE_ST_REG_OFFSET
        InByteImm               ;read receive register
        InByteImm
        add     dx,INT_ID_REG_OFFSET
        InByteImm               ;read interrupt ID register
        InByteImm

continue_loop:
        add     di,TYPE s_stConfigParms
        dec     cx
        jnz     clear_all_OEM_loop

done:
; do sealevel SNAFU
        test    GS:_wLoadFlags,LOAD_FLAG1_ENABLE_ALL_OUT2
        jz      exit

        mov     dx,wIntIDregister
        sub     dx,(SCRATCH_REG_OFFSET - MDM_CTL_REG_OFFSET)
        mov     cx,8  ; This will change to a variable if a four port adapter
                      ; ever exists with this same problem.  For now only Sealevel's
                      ; eight port adapter is supported.
activate_all_OUT2_loop:
        InByteDel bx
        or      al,MDM_CTL_OUT2_ACTIVATE
        OutByteDel bx
        add     dx,8
        loop    activate_all_OUT2_loop
        mov     bNoOUT2change,TRUE
        and     GS:_wLoadFlags,NOT LOAD_FLAG1_ENABLE_ALL_OUT2
exit:
        ret

ClearAllInterrupts ENDP

InitInterrupt PROC FAR
;  int 3
    SetDS     RDGROUP
    SetGS     DGROUP
        mov     cx,ax
        mov     si,GS:_wInitTestPort
        mov     dx,wIntIDregister
        or      dx,dx
        jz      @f
        InByteDel bx
        mov     ah,al
@@:
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,INT_ID_REG_OFFSET
        InByteDel bx
        test    al,INT_ID_INT_PENDING
        jnz     not_my_interrupt

        cmp     wIntIDregister,ZERO
        je      is_my_interrupt
        test    GS:_wLoadFlags,(LOAD_FLAG1_DIGIBOARD08_INT_ID OR LOAD_FLAG1_DIGIBOARD16_INT_ID)
        jz      @f
        call    test_DigiBoard_ID
        jmp     test_result
@@:
        call    test_ID_is_bits

test_result:
        jnc     is_my_interrupt
  IFDEF OEM
        mov     bOEMpresent,TRUE
  ENDIF
        mov     GS:_bValidIntIDreg,TRUE

is_my_interrupt:
        mov     GS:_bValidInterrupt,TRUE
        mov     al,[si].s_stDeviceParms.byInterruptLevel
        mov     dl,DevHlp_EOI
        call    device_hlp
        clc
        sti
        jmp     exit

not_my_interrupt:
        cmp     bSharedInterrupts,TRUE
        je      @f
        mov     al,[si].s_stDeviceParms.byInterruptLevel
        cli
        mov     dl,DevHlp_EOI
        call    device_hlp
@@:
        stc
        sti
exit:
        ret

InitInterrupt ENDP

IFDEF OEM

BadISAmessage PROC NEAR

        mov     ax,OFFSET ISA_bad_msg
        call    PrintString
        mov     ax,OFFSET Contact_msg
        call    PrintString
        mov     ax,OFFSET OS_tools_BLURB
        call    PrintString
        ret

BadISAmessage ENDP
  ENDIF

IFDEF this_junk
;----------------------------------------------------------------------------
;  OEM interrupt jump table
;----------------------------------------------------------------------------
OEM_call_table LABEL WORD

                 WORD    dummy_return
                 WORD    test_ID_is_bits
                 WORD    test_DigiBoard_ID

dummy_return:
        clc
        ret

ENDIF

test_ID_is_bits PROC NEAR  uses ax

;  int 3
        cmp     byAdapterType,HDWTYPE_SIX
        jne     @f
        not     ah
@@:
        or      ah,GS:_byInitIntORmask
        and     ah,GS:_byInitIntANDmask
        or      ah,ah
        jnz     get_offset

status_invalid:
        clc
        ret

; This algorithym assumes that only higher bits will be "undefined" because
; the there are less than eight ports on adapter.  It also assumes that the
; number of ports will vary by twos (i.e., 2, 4, 6, or 8 ports)

get_offset:
        test    ah,0f0h      ; are any bits on in the upper nibble?
        jz      lo_nibble
        test    ah,00fh      ; are any bits on in the lower nibble
        jz      hi_nibble

; bits in both nibbles are on
        mov     al,ah        ; save status
        and     al,0f0h      ; mask off lower nibble
        cmp     al,0f0h      ; are all bits in the upper nibble on?
        jne     @f

; if so then mask off upper nibble and test lower nibble

        and     ah,NOT 0f0h
        jmp     lo_nibble
@@:
        cmp     al,0c0h      ; are all bits in upper two bits of the upper nibble?
        jne     status_invalid

; if so then mask those bits and test lower nibble

        and     ah,NOT 0c0h

lo_nibble:
        test    ah,00ch      ; are any of upper two bits on
        jz      lo_nibble_lo_bits
        test    ah,003h      ; are any of lower two bits on
        jz      lo_nibble_hi_bits

; bits are on in both upper and lower pairs

        mov     al,ah
        and     al,0ch
        cmp     al,0ch      ; are both upper bits of pair on?
        jne     status_invalid

        and     ah,NOT 0ch

lo_nibble_lo_bits:
        or      ah,ah
        jpe     status_invalid
        test    ah,02h
        jnz     bit_1
        xor     bx,bx
        jmp     set_SI

bit_1:
        mov     bx,1
        jmp     set_SI

lo_nibble_hi_bits:
        or      ah,ah
        jpe     status_invalid
        test    ah,08h
        jnz     bit_3
        mov     bx,2
        jmp     set_SI

bit_3:
        mov     bx,3
        jmp     set_SI

hi_nibble:
        test    ah,0c0h      ; are any of upper two bits on
        jz      hi_nibble_lo_bits
        test    ah,030h      ; are any of lower two bits on
        jz      hi_nibble_hi_bits

; bits are on in both upper and lower pairs

        mov     al,ah
        and     al,0c0h
        cmp     al,0c0h      ; are both upper bits of pair on?
        jne     status_invalid

        and     ah,NOT 0c0h

hi_nibble_lo_bits:
        or      ah,ah
        jpe     status_invalid
        test    ah,020h
        jnz     bit_5
        mov     bx,4
        jmp     set_SI

bit_5:
        mov     bx,5
        jmp     set_SI

hi_nibble_hi_bits:
        or      ah,ah
        jpe     status_invalid
        test    ah,080h
        jnz     bit_7
        mov     bx,6
        jmp     set_SI

bit_7:
        mov     bx,7

set_SI:
        mov     cx,bx
        shl     bx,1
        mov     wDeviceIntOffsetTable[bx],si
        mov     bl,1
        shl     bl,cl
        or      byIntStatusMask,bl
return:
        stc
        ret

test_ID_is_bits ENDP

test_DigiBoard_ID PROC NEAR

;  int 3
        test    ah,0e0h
        jnz     invalid_int_ID

valid_int_ID:
        xor     bx,bx
        mov     bl,ah
        shl     bx,1
        mov     wDeviceIntOffsetTable[bx],si

        stc
        jmp     exit

invalid_int_ID:
        clc

exit:
        ret

test_DigiBoard_ID ENDP

RES_CODE ENDS

     END
