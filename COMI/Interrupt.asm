;************************************************************************
;
; $Revision:   1.12  $
;
; $Log:   P:/archive/comi/int.asv  $
;
;     Rev 1.12   28 Mar 1996 00:20:10   EMMETT
;  Added resource manager.  Began work on VDD support.
;
;     Rev 1.11   21 Feb 1996 12:08:34   EMMETT
;  Fixed COMscope buffer access for DosDevIOCtl function calls
;  so that single byte transfers of packet data would not make write
;  pointer odd.
;
;     Rev 1.10   18 Feb 1996 14:21:38   EMMETT
;  Added many features.  Notably:
;  Tracing of DosDevIOCtl function calls and packets.
;  Added 16650 and 16750 support.
;  Streamlined interrupt routine.
;
;     Rev 1.9   25 Apr 1995 22:16:48   EMMETT
;  Added Support for DigiBoard PC/16.  Changed interrupt Routine for better adapter independence.
;  Changed interrupt routine to allow user to select interrupting device selection algorithim.  Fixed
;  ABIOS interaction for better "non.INI" initialization in MCA machines.  Fixed various initialization
;  message strings.  COMscope and receive buffer are now allocated from system memory, allowing
;  a 32k (word) COMscope buffer and a 64k (byte) receive buffer.
;
;     Rev 1.8   03 Dec 1994 15:09:10   EMMETT
;  Changed segment names.
;
;     Rev 1.7   29 Jun 1994 07:40:30   EMMETT
;  Fixed transmit immediate byte to better handle null.
;
;     Rev 1.6   28 Jun 1994 09:10:52   EMMETT
;  Fixed problem with early transmit time-outs.
;
;     Rev 1.5   11 Jun 1994 10:37:44   EMMETT
;  Changed all references to "Mirror" to "COMscope".
;
;     Rev 1.4   11 Jun 1994 09:24:08   EMMETT
;  added code to fix problems with Comtrol Hostess and Texas Instrument 16C550B
;  UARTs, including adding flag to wLoadFoags to indicate htat UART is present.
;
;
;     Rev 1.3   07 Jun 1994 00:19:14   EMMETT
;  Added support for DigiBoard.
;  Added initialization support for OEM specific loads.
;  Fixed bug in StartWriteStream and ProcessModemSignals that caused handshaking problems.
;  Fixed hardware tests to set baud rate before testing interrupts.
;  Fixed hardware tests off switch to work only for retail version.
;
;     Rev 1.2   27 Apr 1994 22:56:26   EMMETT
;  FIxed ABIOS stuff to work better than before.
;
;     Rev 1.1   18 Apr 1994 23:18:12   EMMETT
;  Changed ABIOS processing and added ability to disallow a port to initialize.
;
;     Rev 1.0   16 Apr 1994 08:35:18   EMMETT
;  Initial version control archive.
;
;************************************************************************

  IFNDEF x16_BIT
.386P
  ELSE
.286P
  ENDIF
.NOLISTMACRO                   ;suppress macro expansion in listing

.XLIST                  ;Suppress listing of INCLUDE files
    INCLUDE SEGMENTS.INC
    INCLUDE COMDD.INC
    INCLUDE MACRO.INC
    INCLUDE DEVHLP.INC
    INCLUDE DCB.INC
    INCLUDE Hardware.inc
.LIST

RES_DATA SEGMENT

    EXTRN device_hlp                    :DWORD
    EXTRN bSharedInterrupts             :WORD
    EXTRN stDeviceParms                 :s_stDeviceParms
    EXTRN wIntIDregister                :WORD
    EXTRN wOEMjumpEntry                 :WORD
    EXTRN wOEMjumpExit                  :WORD
    EXTRN wDeviceIntOffsetTable         :WORD
    EXTRN wLastDeviceParmsOffset        :WORD
    EXTRN byIntStatusMask               :BYTE

RES_DATA ENDS

RES_CODE SEGMENT
    ASSUME CS:RCGROUP, ES:nothing, SS:nothing, DS:RDGROUP

;  util externals

    EXTRN WrtReceiveQueue    :NEAR
    EXTRN StartWriteStream   :NEAR

    EXTRN ProcessModemSignals:NEAR
;-------------------------------------------------------------------------------
; Interrupt Routine
;-------------------------------------------------------------------------------

COM_interrupt_1::                                                               ; makes it global
        cli
        mov     ax,1
        jmp     COM_interrupt

COM_interrupt_2::                                                               ; makes it global
        cli
        mov     ax,2
        jmp     COM_interrupt

COM_interrupt_3::                                                               ; makes it global
        cli
        mov     ax,3
        jmp     COM_interrupt

COM_interrupt_4::                                                               ; makes it global
        cli
        mov     ax,4
        jmp     COM_interrupt

COM_interrupt_5::                                                               ; makes it global
        cli
        mov     ax,5
        jmp     COM_interrupt

COM_interrupt_6::                                                               ; makes it global
        cli
        mov     ax,6
        jmp     COM_interrupt

COM_interrupt_7::                                                               ; makes it global
        cli
        mov     ax,7
        jmp     COM_interrupt

COM_interrupt_8::                                                               ; makes it global
        cli
        mov     ax,8
        jmp     COM_interrupt

COM_interrupt_9::                                                               ; makes it global
        cli
        mov     ax,9
        jmp     COM_interrupt

COM_interrupt_10::                                                               ; makes it global
        cli
        mov     ax,10
        jmp     COM_interrupt

COM_interrupt_11::                                                               ; makes it global
        cli
        mov     ax,11
        jmp     COM_interrupt

COM_interrupt_12::                                                               ; makes it global
        cli
        mov     ax,12
        jmp     COM_interrupt

COM_interrupt_13::                                                               ; makes it global
        cli
        mov     ax,13
        jmp     COM_interrupt

COM_interrupt_14::                                                               ; makes it global
        cli
        mov     ax,14
        jmp     COM_interrupt

COM_interrupt_15::                                                               ; makes it global
        cli
        mov     ax,15

COM_interrupt::                                                               ; makes it global

  IFDEF DEBUG_INTS
        wCountIntLoops          EQU <WORD PTR [BP-6]>
  ENDIF
        wInterruptLevel         EQU <WORD PTR [BP-4]>
        fInterruptFlags         EQU <WORD PTR [BP-2]>

        push    bp
        mov     bp, sp
  IFDEF DEBUG_INTS
        sub     sp,((TYPE WORD) * 3)
        mov     wCountIntLoops,1000
  ELSE
        sub     sp,((TYPE WORD) * 2)
  ENDIF
        mov     wInterruptLevel,ax
        mov     fInterruptFlags,ZERO

        mov     bx,wOEMjumpEntry
        jmp     CS:OEM_int_entry_table[bx]

process_initial_interrupt::                                                               ; makes it global
        or      fInterruptFlags,INTERRUPT_HIT
        test    al,0fh
        jz      modem_int

;  What do you suppose would happen if a receive interrupt occurred while
;  the interrupt ID register was being read because of a write interrupt?
;  Well, this next few lines should overcome that little deficiency
;;;  This is only required for 8250 and 16450 support (no FIFOs).
;  This is only required for 8250, 16450, 16550 support (no FIFOs). 

        mov     ah,al           ; save UART interrupt status register (ISR) contents

        test    [si].s_stDeviceParms.wDeviceFlag2,DEV_FLAG2_FIFO_AVAILABLE
        jz      HACK_TX_int
        test_DeviceFlag2 DEV_FLAG2_16650_UART                               ;---- changed to use hack for 16550 UARTS as well - 2/7/02
        jz      get_modem_signals
        
HACK_TX_int:
        add     dx,INT_EN_REG_OFFSET - INT_ID_REG_OFFSET
        InByteImm
        test    al,INT_EN_TX_HOLD_EMPTY
        jz      @f
        and     al,NOT INT_EN_TX_HOLD_EMPTY
        OutByteDel bx
        or      al,INT_EN_TX_HOLD_EMPTY
        OutByteImm
        IOdelay bx
@@:
        add     dx,INT_ID_REG_OFFSET - INT_EN_REG_OFFSET

get_modem_signals::                                                               ; makes it global
        add     dx,MDM_ST_REG_OFFSET - INT_ID_REG_OFFSET
        InByteImm
        add     dx,INT_ID_REG_OFFSET - MDM_ST_REG_OFFSET
        test_DeviceFlag2 DEV_FLAG2_MONITOR_CTS
        jz      test_delta_bits
        mov     bl,al
        and     bl,0f0h
        cmp     bl,[si].s_stDeviceParms.byMSRimage
        je      test_delta_bits
        or      bl,MDM_ST_DELTA_CTS
        mov     [si].s_stDeviceParms.byMSRimage,bl
        jmp     process_modem_signals

test_delta_bits:
        test    al,MDM_ST_DELTA_MASK
        jz      restore_AL

process_modem_signals:
        call    ProcessModemSignals

restore_AL:
        mov     al,ah           ; restore UART interrupt status register (ISR) contents

vector_interrupt::                                                               ; makes it global
        and     fInterruptFlags,NOT FIFO_TO
        mov     bl,al
  IFNDEF NO_16650_Xon_HS_support
        and     bx,3fh
        test_DeviceFlag2 (DEV_FLAG2_16650_UART OR DEV_FLAG2_16654_URAT)
        jnz     @f
        and     bx,0fh
@@:
  ELSE
        and     bx,0fh
  ENDIF
  IFDEF DEBUG_INTS
        dec     wCountIntLoops
        jnz     @f
        int     3
@@:
  ENDIF
        jmp     CS:Interrupt_Vector[bx]

;-----------------------------------------------------------------------------
; test for next highest prioity interrupt for this same device
;-----------------------------------------------------------------------------
retest_int_status::                                                               ; makes it global

        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,INT_ID_REG_OFFSET

read_int_status_reg::                                                               ; makes it global
        InByteImm
        test    al,INT_ID_INT_PENDING
        jz      vector_interrupt
        test    [si].s_stDeviceParms.wDeviceStatus2,DEV_ST2_RESTARTSTREAM
        jz      @f
        call    StartWriteStream
@@:
        mov     cx,wInterruptLevel
        mov     bx,wOEMjumpExit
        jmp     CS:OEM_int_exit_table[bx]

;-----------------------------------------------------------------------------
start_polling::                                                               ; makes it global
        lea     si,stDeviceParms
        mov     cx,wInterruptLevel

polling_loop::                                                               ; makes it global
        cmp     [si].s_stDeviceParms.wInterruptStatus,cx
        jne     poll_next
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,INT_ID_REG_OFFSET
        InByteImm
        test    al,INT_ID_INT_PENDING
        jnz     poll_next
  IFNDEF x16_BIT
;        test_DeviceFlag2 DEV_FLAG2_USE_DD_DATA_SEGMENT
;        jnz     process_initial_interrupt
   IFNDEF NO_COMscope
        mov     fs,[si].s_stDeviceParms.wCOMscopeSelector
   ENDIF
        mov     gs,[si].s_stDeviceParms.wRdBuffSelector
  ENDIF
        jmp     process_initial_interrupt

poll_next::                                                               ; makes it global
        add     si,TYPE stDeviceParms
        cmp     si,wLastDeviceParmsOffset
        jbe     polling_loop

        cli
        cmp     bSharedInterrupts,TRUE
        jne     send_EOI

do_cleanup::                                                               ; makes it global
        test    fInterruptFlags,INTERRUPT_HIT
        jnz     send_EOI
        mov     sp, bp
        pop     bp
        stc
        retf

    IFDEF this_junk
  IFNDEF SHARE
COM_interrupt_X::        ; interrupt routine entry from IOCTL, should never get here
        push    bp
        mov     bp, sp
        add     sp, 0FFFCh
        mov     wInterruptLevel,cx
        jmp     vector_interrupt
  ENDIF
    ENDIF
;last_device_exit:
;        test    [si].s_stDeviceParms.wDeviceStatus2,DEV_ST2_RESTARTSTREAM
;        jz      @f
;        call    StartWriteStream
;@@:
send_EOI::                                                               ; makes it global
        mov     ax,wInterruptLevel
        mov     dl,DevHlp_EOI
        mov     sp, bp
        pop     bp
        cli
        call    device_hlp
        clc
        retf

  IFNDEF NO_16650_Xon_HS_support
;-----------------------------------------------------------------------------
CTS_RTS_change::                                                               ; makes it global
        jmp     read_int_status_reg

;-----------------------------------------------------------------------------
_16650_Xoff_int::                                                               ; makes it global
        test    al,INT_ID_XOFF_RCV
        jz      set_Xon
        mov     al,[si].s_stDeviceParms.byXoffChar
        COMscopeStream ebx, CSFUNC_TRACE_IMM_STREAM, CS_READ_IMM
        or      [si].s_stDeviceParms.byHSstatus,TX_WAITING_BECAUSE_XOFF_RX
        jmp     read_int_status_reg

set_Xon::                                                               ; makes it global
        mov     al,[si].s_stDeviceParms.byXonChar
        COMscopeStream bx, CSFUNC_TRACE_IMM_STREAM, CS_READ_IMM
        and     [si].s_stDeviceParms.byHSstatus,NOT TX_WAITING_BECAUSE_XOFF_RX
        jmp     read_int_status_reg
  ENDIF
;-----------------------------------------------------------------------------
modem_int::                                                               ; makes it global
        add     dx,MDM_ST_REG_OFFSET - INT_ID_REG_OFFSET
        InByteImm
        mov     [si].s_stDeviceParms.byMSRimage,al
        and     [si].s_stDeviceParms.byMSRimage,0f0h

        add     dx,INT_ID_REG_OFFSET - MDM_ST_REG_OFFSET
        test    al,MDM_ST_DELTA_MASK
        jz      read_int_status_reg

        call    ProcessModemSignals

        test    [si].s_stDeviceParms.wDeviceStatus2,DEV_ST2_RESTARTSTREAM
        jz      read_int_status_reg
        call    StartWriteStream
        jmp     read_int_status_reg

;-----------------------------------------------------------------------------
receive_line_status::                                                               ; makes it global
        xor     cx,cx
        add     dx,LINE_ST_REG_OFFSET - INT_ID_REG_OFFSET
        InByteImm
        test    al,LINE_ST_OVERRUN_ERROR
        jz      @f
        or      cx,OVERRUN
@@:
        mov     bl,[si].s_stDeviceParms.byFlag3
        and     bl,F3_READ_TIMEOUT_MASK
        cmp     bl,F3_WAIT_SOMETHING
        jne     error_read_loop
        or      [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_LAST_CHAR_RCVD

error_read_loop::                                                               ; makes it global
        mov     ah,al
        sub     dx,LINE_ST_REG_OFFSET
        InByteImm
        sti
        and     al,[si].s_stDeviceParms.byDataLengthMask
        test    [si].s_stDeviceParms.byHSstatus,RX_WAITING_MASK
        jnz     get_next_status

        test    ah,LINE_ST_BREAK_DETECT
        jz      test_error_status
        mov     al,ah
        test    cx,BREAK
        jnz     get_next_status
        COMscopeStream ebx, CSFUNC_TRACE_ERRORS, CS_BREAK_RX
        or      cx,BREAK
        or      [si].s_stDeviceParms.wCOMevent,COM_EVENT_BREAK_DETECT
        test    [si].s_stDeviceParms.byFlag2,F2_ENABLE_BREAK_REPL
        jz      get_next_status      ; changed back for 4.0c
;       jz      queue_error_byte     ; changed to fix KFC break, no data byte problem 2/7/02 -> 4.0.b
        mov     al,[si].s_stDeviceParms.byBreakChar
        jmp     queue_error_byte

test_error_status::                                                               ; makes it global
        and     cx,NOT BREAK
        test    ah,(LINE_ST_PARITY_ERROR OR LINE_ST_FRAMING_ERROR)
        jz      test_null
        push    ax
        mov     al,ah
        and     ax,(LINE_ST_PARITY_ERROR OR LINE_ST_FRAMING_ERROR)
        or      [si].s_stDeviceParms.wCOMerror,ax
        COMscopeStream ebx, CSFUNC_TRACE_ERRORS, CS_HDW_ERROR
        pop     ax
        or      [si].s_stDeviceParms.wCOMevent,COM_EVENT_COM_ERROR
        test    [si].s_stDeviceParms.byFlag2,F2_ENABLE_ERROR_REPL
        jz      queue_error_byte
        mov     al,[si].s_stDeviceParms.byErrorChar
        jmp     queue_error_byte

test_null::                                                               ; makes it global

; IF input byte is ZERO AND NULL stripping is enabled THEN
; go get next character

        or      al,al
        jnz     test_XHS_rls
        test    [si].s_stDeviceParms.byFlag2,F2_ENABLE_NULL_STRIP
        jz      test_XHS_rls
        jmp     get_next_status

; IF XMIT Xon/Xoff HS is enabled

test_XHS_rls::                                                               ; makes it global
        test    [si].s_stDeviceParms.byFlag2,F2_ENABLE_XMIT_XON_XOFF_FLOW
        jz      queue_error_byte

; IF Xoff character received THEN flag Tx to wait

        cmp     al,[si].s_stDeviceParms.byXoffChar
        jne     not_Xoff_rls

        COMscopeStream ebx, CSFUNC_TRACE_IMM_STREAM, CS_READ_IMM

        or      [si].s_stDeviceParms.byHSstatus,TX_WAITING_BECAUSE_XOFF_RX
        jmp     get_next_status

; IF Xoff had been received AND Xon was just received THEN
; flag Tx to and try to restart write stream

not_Xoff_rls::                                                               ; makes it global
        test    [si].s_stDeviceParms.byHSstatus,TX_WAITING_BECAUSE_XOFF_RX
        jz      queue_error_byte
        cmp     al,[si].s_stDeviceParms.byXonChar
        jne     queue_error_byte

        COMscopeStream ebx, CSFUNC_TRACE_IMM_STREAM, CS_READ_IMM

        and     [si].s_stDeviceParms.byHSstatus,NOT TX_WAITING_BECAUSE_XOFF_RX
        call    StartWriteStream
        jmp     get_next_status

queue_error_byte::                                                               ; makes it global
        mov     ah,al
        test    cx,OVERRUN
        jnz     @f
        call    WrtReceiveQueue
@@:
; IF we are blocked on read THEN decrement byte counter

        cmp     [si].s_stDeviceParms.wReadByteCount,0
        je      get_next_status
        dec     [si].s_stDeviceParms.wReadByteCount

; IF counter goes to zero THEN mark last character received

        jnz     get_next_status
        or      [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_LAST_CHAR_RCVD

get_next_status::                                                               ; makes it global
        add     dx,LINE_ST_REG_OFFSET
        InByteImm
        test    al,LINE_ST_RCV_DATA_READY
        jz      last_byte
        test    cx,OVERRUN
        jnz     error_read_loop  ; changed from jz for KFC fix to 4.0c, 
        push    ax
        mov     al,ah
        call    WrtReceiveQueue
        pop     ax
        jmp     error_read_loop

last_byte::                                                               ; makes it global
        test    cx,OVERRUN
        jz      line_status_exit
        mov     al,ah
        call    WrtReceiveQueue

        mov     al,LINE_ST_OVERRUN_ERROR
        or      [si].s_stDeviceParms.wCOMerror,ax
        or      [si].s_stDeviceParms.wCOMevent,COM_EVENT_COM_ERROR
        test    [si].s_stDeviceParms.byFlag2,F2_ENABLE_ERROR_REPL
        jz      @f
        push    ax
        mov     al,[si].s_stDeviceParms.byErrorChar
        call    WrtReceiveQueue
        pop     ax
@@:
        COMscopeStream ebx, CSFUNC_TRACE_ERRORS, CS_HDW_ERROR

line_status_exit::                                                               ; makes it global
        add     dx,INT_ID_REG_OFFSET - LINE_ST_REG_OFFSET
;        test    cx,RCV_BYTE
;        jz      read_int_status_reg
        or      [si].s_stDeviceParms.wCOMevent,COM_EVENT_RCV_BYTE
        OR_DeviceFlag1 DEV_FLAG1_EVENT_RCV_BYTE
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_LAST_CHAR_RCVD
        jnz     clear_rd_sem_rls
        cmp     [si].s_stDeviceParms.wReadByteCount,0
        je      read_int_status_reg
        cmp     [si].s_stDeviceParms.wRdTimerCount,ZERO
        je      read_int_status_reg
        mov     ax,[si].s_stDeviceParms.wReadTimerStart
        mov     [si].s_stDeviceParms.wRdTimerCount,ax
        jmp     read_int_status_reg

clear_rd_sem_rls::                                                               ; makes it global
        cmp     [si].s_stDeviceParms.wRdTimerCount,ZERO
        je      read_int_status_reg
        mov     ax,ds
        lea     bx,[si].s_stDeviceParms.dwRdSemaphore
        mov     dl,DevHlp_SemClear
        call    device_hlp
        mov     [si].s_stDeviceParms.wRdTimerCount,ZERO
        jmp     retest_int_status

;-----------------------------------------------------------------------------
read_com_TO::                                                               ; makes it global
        or      [si].s_stDeviceParms.wCOMevent,COM_EVENT_RCV_TO
        or      fInterruptFlags,FIFO_TO

;-----------------------------------------------------------------------------
read_com::                                                               ; makes it global
        mov     cl,[si].s_stDeviceParms.byFlag3
        and     cl,F3_READ_TIMEOUT_MASK
        cmp     cl,F3_WAIT_SOMETHING
        jne     @f
        or      [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_LAST_CHAR_RCVD
@@:
        or      [si].s_stDeviceParms.wCOMevent,COM_EVENT_RCV_BYTE
        OR_DeviceFlag1 DEV_FLAG1_EVENT_RCV_BYTE
        add     dx,LINE_ST_REG_OFFSET - INT_ID_REG_OFFSET

read_loop::                                                               ; makes it global
        InByteImm
        test    al,LINE_ST_RCV_DATA_READY
        jnz     get_byte
        add     dx,INT_ID_REG_OFFSET - LINE_ST_REG_OFFSET
        test    fInterruptFlags,FIFO_TO
        jz      @f
;        test    [si].s_stDeviceParms.wDeviceFlag2,(DEV_FLAG2_TIB_UART OR DEV_FLAG2_16750_UART OR DEV_FLAG2_TI16550C_UART)
        test    [si].s_stDeviceParms.wDeviceFlag2,DEV_FLAG2_TIB_UART
        jz      @f
        InByteImm
        and     al,0fh
        cmp     al,INT_ID_CHAR_TIMEOUT
        jne     @f

FIFO_TO_INT_BAD::           ; Texas Instruments 16550B fixup
        InByteImm
;        test    [si].s_stDeviceParms.wDeviceFlag2,(DEV_FLAG2_16750_UART OR DEV_FLAG2_TI16550C_UART)
;        jz      @f
        add     dx,LINE_ST_REG_OFFSET - INT_ID_REG_OFFSET
        jmp     get_byte
@@:
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_LAST_CHAR_RCVD
        jnz     clear_rd_sem
        cmp     [si].s_stDeviceParms.wReadByteCount,0
        je      read_int_status_reg
        cmp     [si].s_stDeviceParms.wRdTimerCount,ZERO
        je      read_int_status_reg
        mov     ax,[si].s_stDeviceParms.wReadTimerStart
        mov     [si].s_stDeviceParms.wRdTimerCount,ax
        jmp     read_int_status_reg

clear_rd_sem::                                                               ; makes it global
        cmp     [si].s_stDeviceParms.wRdTimerCount,ZERO
        je      read_int_status_reg
        mov     [si].s_stDeviceParms.wRdTimerCount,ZERO
        mov     ax,ds
        lea     bx,[si].s_stDeviceParms.dwRdSemaphore
        mov     dl,DevHlp_SemClear
        call    device_hlp
        jmp     retest_int_status

get_byte::                                                               ; makes it global
        sub     dx,LINE_ST_REG_OFFSET        ; back to receive register
        and     fInterruptFlags,NOT FIFO_TO
        InByteImm
        sti
        test    [si].s_stDeviceParms.byHSstatus,RX_WAITING_MASK
        jnz     test_next

        and     al,[si].s_stDeviceParms.byDataLengthMask

; IF input byte is ZERO AND NULL stripping is enabled THEN
; go get next character

        or      al,al
        jnz     test_XHS
        test    [si].s_stDeviceParms.byFlag2,F2_ENABLE_NULL_STRIP
        jz      test_XHS
        jmp     test_next

; IF XMIT Xon/Xoff HS is enabled

test_XHS::                                                               ; makes it global
        test    [si].s_stDeviceParms.byFlag2,F2_ENABLE_XMIT_XON_XOFF_FLOW
        jz      queue_byte

; IF Xoff character received THEN flag Tx to wait

        cmp     al,[si].s_stDeviceParms.byXoffChar
        jne     not_Xoff

        COMscopeStream ebx, CSFUNC_TRACE_IMM_STREAM, CS_READ_IMM

        or      [si].s_stDeviceParms.byHSstatus,TX_WAITING_BECAUSE_XOFF_RX
        jmp     test_next

; IF Xoff had been received AND Xon was just received THEN
; flag Tx to and try to restart write stream

not_Xoff::                                                               ; makes it global
        test    [si].s_stDeviceParms.byHSstatus,TX_WAITING_BECAUSE_XOFF_RX
        jz      queue_byte
        cmp     al,[si].s_stDeviceParms.byXonChar
        jne     queue_byte

        COMscopeStream ebx, CSFUNC_TRACE_IMM_STREAM, CS_READ_IMM

        and     [si].s_stDeviceParms.byHSstatus,NOT TX_WAITING_BECAUSE_XOFF_RX
        call    StartWriteStream
        jmp     test_next

queue_byte::                                                               ; makes it global
        call    WrtReceiveQueue

; IF we are blocked on read THEN decrement byte counter

        cmp     [si].s_stDeviceParms.wReadByteCount,0
        je      test_next
        dec     [si].s_stDeviceParms.wReadByteCount

; IF counter goes to zero THEN mark last character received

        jnz     test_next
        or      [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_LAST_CHAR_RCVD

test_next::                                                               ; makes it global
        add     dx,LINE_ST_REG_OFFSET
        jmp     read_loop
;-----------------------------------------------------------------------------
write_com::                                                               ; makes it global
        sti
        sub     dx,INT_ID_REG_OFFSET
  IFDEF this_junk ;SHARE
        test_DeviceFlag2 (DEV_FLAG2_16650_UART OR DEV_FLAG2_16654_UART)
        jz      test_TX_HS
        test    ah,INT_ID_XOFF_RCV
        jz      @f
        test    [si].s_stDeviceParms.byFlag2,F2_ENABLE_FULL_DUPLEX
        jnz     @f
        or      [si].s_stDeviceParms.byHSstatus,TX_WAITING_BECAUSE_XOFF_TX
        jmp     test_TX_HS
@@:
        and     [si].s_stDeviceParms.byHSstatus,NOT TX_WAITING_BECAUSE_XOFF_TX
test_TX_HS::                                                               ; makes it global
  ENDIF
; test if CTS, DSR, or DCD handshaking has us in the transmit hold mode
        test    [si].s_stDeviceParms.byHSstatus,TX_WAITING_HDW_MASK
        jnz     disable_TX_interrupt

; set up FIFO counter
        mov     cx,[si].s_stDeviceParms.wTxFIFOdepth

; test if an "immediate" byte needs to be transmitted
        test_DeviceFlag1 DEV_FLAG1_IMM_BYTE_WAITING
        jz      test_queue

; transmit "immediate" byte
        mov     al,[si].s_stDeviceParms.byImmediateByte
        COMscopeStream ebx, CSFUNC_TRACE_IMM_STREAM, CS_WRITE_IMM
        OutByteDel bx
        AND_DeviceFlag1 (NOT DEV_FLAG1_IMM_BYTE_WAITING)
        loop    test_queue
; got here because only one byte is to be written to UART at each interrupt

        IOdelay bx
        cmp     [si].s_stDeviceParms.wXmitQueueCount,0
        je      clear_wrt_sem
        jmp     reset_timer

test_queue::                                                               ; makes it global
        cmp     [si].s_stDeviceParms.wXmitQueueCount,0
        je      clear_wrt_sem
        test    [si].s_stDeviceParms.byHSstatus,TX_WAITING_MASK
        jnz     disable_TX_interrupt
        mov     di,[si].s_stDeviceParms.wXmitQueueReadPointer
        and     [si].s_stDeviceParms.wDeviceStatus2,(NOT DEV_ST2_RESTARTSTREAM)
        IOdelay bx

  IFNDEF NO_COMscope
        test    [si].s_stDeviceParms.fCOMscopeFunction,CSFUNC_TRACE_OUTPUT_STREAM
        jnz     COMscope_fill
  ENDIF
fill_loop:
        inc     [si].s_stDeviceParms.dwTransmitCount
        mov     al,[di]
        OutByteImm
        inc     di
        dec     [si].s_stDeviceParms.wXmitQueueCount
        loopnz  fill_loop

  IFNDEF NO_COMscope
        jmp     store_wrt_pointer

COMscope_fill::                                                               ; makes it global
        mov     ebx,[si].s_stDeviceParms.dwCOMscopeQWrtPtr
        mov     ah,CS_WRITE

COMscope_fill_loop::                                                               ; makes it global
        inc     [si].s_stDeviceParms.dwTransmitCount
        mov     al,[di]
;        test_DeviceFlag2 DEV_FLAG2_USE_DD_DATA_SEGMENT
;        jnz     @f
        mov     FS:[ebx],ax
;        jmp     test_CS_wrap
;@@:
;        mov     [ebx],ax

test_CS_wrap::                                                               ; makes it global
        cmp     ebx,[si].s_stDeviceParms.dwCOMscopeBuffExtent
        jb      no_COMscope_wrap
        mov     ebx,[si].s_stDeviceParms.oCOMscopeBuff
        sub     ebx,2

no_COMscope_wrap::                                                               ; makes it global
        add     ebx,2
        OutByteImm
        inc     di
        dec     [si].s_stDeviceParms.wXmitQueueCount
        loopnz  COMscope_fill_loop

        mov     [si].s_stDeviceParms.dwCOMscopeQWrtPtr,ebx

store_wrt_pointer:
  ENDIF ; NOT NO_COMscope or x16_BIT

        mov     [si].s_stDeviceParms.wXmitQueueReadPointer,di

        IOdelay bx

reset_timer::                                                               ; makes it global
        add     dx,INT_ID_REG_OFFSET
; We have queued data to be transmitted so reinitialize timer if required

        test    [si].s_stDeviceParms.byFlag3,F3_INFINITE_WRT_TIMEOUT
        jnz     read_int_status_reg
        mov     ax,[si].s_stDeviceParms.wWriteTimerStart
        mov     [si].s_stDeviceParms.wWrtTimerCount,ax       ;update timer
        jmp     read_int_status_reg

clear_wrt_sem::                                                               ; makes it global
; The last byte in the buffer has been transmitted so clear the semaphore

;        mov     [si].s_stDeviceParms.wWrtTimerCount,0
        mov     ax,ds
        lea     bx,[si].s_stDeviceParms.dwWrtSemaphore
        mov     dl,DevHlp_SemClear
        call    device_hlp
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,INT_ID_REG_OFFSET
        jmp     read_int_status_reg

disable_TX_interrupt::
; Cannot transmit character so disable write interrupts.  Interrupts will be
; reenabled when StartWriteStream says so.

        inc     dx
        InByteDel bx
        and     al,NOT INT_EN_TX_HOLD_EMPTY
        OutByteDel bx
        inc     dx
        IOdelay bx
        jmp     read_int_status_reg

;-----------------------------------------------------------------------------
test_zero_ID::                                                               ; makes it global
        mov     dx, wIntIDregister
        InByteImm
        and     al,byIntStatusMask
        jz      send_EOI

zero_poll_next::                                                               ; makes it global
        add     si,TYPE s_stDeviceParms
        cmp     si,wLastDeviceParmsOffset
        jbe     zero_poll_loop

zero_is_clear_ID_entry::                                                               ; makes it global
        mov     dx, wIntIDregister
        InByteImm
        and     al,byIntStatusMask
        jz      send_EOI
        lea     si,stDeviceParms
        mov     cx,wInterruptLevel

zero_poll_loop::                                                               ; makes it global
        cmp     [si].s_stDeviceParms.wInterruptStatus,cx
        jne     zero_poll_next
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,INT_ID_REG_OFFSET
        InByteImm
        test    al,INT_ID_INT_PENDING
        jnz     zero_poll_next
  IFNDEF x16_BIT
;        test_DeviceFlag2 DEV_FLAG2_USE_DD_DATA_SEGMENT
;        jnz     process_initial_interrupt
   IFNDEF NO_COMscope
        mov     fs,[si].s_stDeviceParms.wCOMscopeSelector
   ENDIF
        mov     gs,[si].s_stDeviceParms.wRdBuffSelector
  ENDIF
        jmp     process_initial_interrupt

;-----------------------------------------------------------------------------
test_FF_ID::                                                               ; makes it global
        mov     dx,wIntIDregister
        InByteImm
        or      al,byIntStatusMask
        cmp     al,0ffh
        je      send_EOI

FF_poll_next::                                                               ; makes it global
        add     si,TYPE stDeviceParms
        cmp     si,wLastDeviceParmsOffset
        jbe     FF_poll_loop

FF_is_clear_ID_entry::                                                               ; makes it global
        mov     dx,wIntIDregister
        InByteImm
        or      al,byIntStatusMask
        cmp     al,0ffh
        je      send_EOI
        lea     si,stDeviceParms
        mov     cx,wInterruptLevel

FF_poll_loop::                                                               ; makes it global
        cmp     [si].s_stDeviceParms.wInterruptStatus,cx
        jne     FF_poll_next
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,INT_ID_REG_OFFSET
        InByteImm
        test    al,INT_ID_INT_PENDING
        jnz     FF_poll_next
  IFNDEF x16_BIT
;        test_DeviceFlag2 DEV_FLAG2_USE_DD_DATA_SEGMENT
;        jnz     process_initial_interrupt
   IFNDEF NO_COMscope
        mov     fs,[si].s_stDeviceParms.wCOMscopeSelector
   ENDIF
        mov     gs,[si].s_stDeviceParms.wRdBuffSelector
  ENDIF
        jmp     process_initial_interrupt

;COM_interrupt  ENDP

;----------------------------------------------------------------------------
; OEM interrupt vector function

; this function is executed when a new device is to be "polled"
;----------------------------------------------------------------------------
OEM_test_int_status::                                                               ; makes it global
  IFNDEF x16_BIT
;        test_DeviceFlag2 DEV_FLAG2_USE_DD_DATA_SEGMENT
;        jnz     @f
   IFNDEF NO_COMscope
        mov     fs,[si].s_stDeviceParms.wCOMscopeSelector
   ENDIF
        mov     gs,[si].s_stDeviceParms.wRdBuffSelector
;@@:
  ENDIF
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,INT_ID_REG_OFFSET

        InByteImm
        test    al,INT_ID_INT_PENDING
        jz      process_initial_interrupt
        mov     cx,wInterruptLevel
        mov     bx,wOEMjumpExit
        jmp     CS:OEM_int_exit_table[bx]

;----------------------------------------------------------------------------
;  OEM device selection routines
;----------------------------------------------------------------------------
;  Interrupt ID register is zero when no interrupts are pending and
;  bit is on when device is in the interrupt state
;  Mask was added because Comtrol Hostess four port ties unused bits high
;  in inturrupt status byte.
;----------------------------------------------------------------------------
ID_is_bits_on::                                                               ; makes it global

        mov     dx,wIntIDregister
        InByteImm
        and     al,byIntStatusMask            ;test is ID is zero
        jz      send_EOI
        shl     al,1
        jc      device_eight  ;since we had to shift anyway
                              ; side-efect: makes device eight the highest priority
        mov     bl,al
        xor     bh,bh
        jmp     CS:BitIDjumpTable[bx]

;----------------------------------------------------------------------------
;  Interrupt ID register is 0xff when no interrupts are pending and
;  bit is off (zero) when device is in the interrupt state
;    This type is DigiBoard PC/x specific
;----------------------------------------------------------------------------
ID_is_bits_off::                                                               ; makes it global

        mov     dx,wIntIDregister
        InByteImm
        not     al
        and     al,byIntStatusMask            ;test is ID is zero
        jz      send_EOI
        shl     al,1         ; useless for Boca IOAT66
        jc      device_eight ;since we had to shift anyway
                             ; side-efect: makes device eight the highest priority
        mov     bl,al
        xor     bh,bh
        jmp     CS:BitIDjumpTable[bx]

;----------------------------------------------------------------------------
; load SI based on device in interrupt - used by ID_is_bits... functions
;----------------------------------------------------------------------------
device_one::                                                               ; makes it global
        mov     si,wDeviceIntOffsetTable[0]
        jmp     OEM_test_int_status

device_two::                                                               ; makes it global
        mov     si,wDeviceIntOffsetTable[2]
        jmp     OEM_test_int_status

device_three::                                                               ; makes it global
        mov     si,wDeviceIntOffsetTable[4]
        jmp     OEM_test_int_status

device_four::                                                               ; makes it global
        mov     si,wDeviceIntOffsetTable[6]
        jmp     OEM_test_int_status

device_five::                                                               ; makes it global
        mov     si,wDeviceIntOffsetTable[8]
        jmp     OEM_test_int_status

device_six::                                                               ; makes it global
        mov     si,wDeviceIntOffsetTable[10]
        jmp     OEM_test_int_status

device_seven::                                                               ; makes it global
        mov     si,wDeviceIntOffsetTable[12]
        jmp     OEM_test_int_status

device_eight::                                                               ; makes it global
        mov     si,wDeviceIntOffsetTable[14]
        jmp     OEM_test_int_status

;----------------------------------------------------------------------------
;  Interrupt ID register is all ones (0xff) when no interrupts are pending
;----------------------------------------------------------------------------
DigiBoard_ID::                                                               ; makes it global

        mov     dx,wIntIDregister
        InByteImm

        cmp    al,0ffh
        je     send_EOI

db_valid_int::                                                               ; makes it global
        xor     bx,bx
        mov     bl,al
        shl     bx,1
        mov     si,wDeviceIntOffsetTable[bx]
        jmp     OEM_test_int_status

;-------------------------------------------------------------------------------
; Interrupt Jump Table
;-------------------------------------------------------------------------------
EVEN
Interrupt_Vector LABEL WORD

        WORD modem_int                  ;0
        WORD write_com                  ;2
        WORD read_com                   ;4
        WORD receive_line_status        ;6
        WORD dummy_vector_ret           ;  8
        WORD dummy_vector_ret           ;  10
        WORD read_com_TO                ;12
  IFNDEF NO_16650_Xon_HS_support
        WORD dummy_vector_ret           ;  14
        WORD _16650_Xoff_int            ;16
        WORD dummy_vector_ret           ;  18
        WORD dummy_vector_ret           ;  20
        WORD dummy_vector_ret           ;  22
        WORD dummy_vector_ret           ;  24
        WORD dummy_vector_ret           ;  26
        WORD dummy_vector_ret           ;  28
        WORD dummy_vector_ret           ;  30
        WORD CTS_RTS_change             ;32
  ENDIF
dummy_vector_ret::                                                               ; makes it global
        retf

;----------------------------------------------------------------------------
;  OEM interrupt jump tables (non-MCA only)
;----------------------------------------------------------------------------
EVEN
OEM_int_entry_table LABEL WORD

        WORD    start_polling
        WORD    ID_is_bits_on
        WORD    DigiBoard_ID
        WORD    zero_is_clear_ID_entry
        WORD    FF_is_clear_ID_entry
        WORD    ID_is_bits_off

EVEN
OEM_int_exit_table LABEL WORD

        WORD    poll_next
        WORD    ID_is_bits_on
        WORD    DigiBoard_ID
        WORD    test_zero_ID
        WORD    test_FF_ID
        WORD    ID_is_bits_off

EVEN
BitIDjumpTable LABEL WORD
        WORD    send_EOI                ;0
        WORD    device_one              ;00000001  1
        WORD    device_two              ;00000010  2
        WORD    device_one              ;00000011  3
        WORD    device_three            ;00000100  4
        WORD    device_one              ;00000101  5
        WORD    device_two              ;00000110  6
        WORD    device_one              ;00000111  7
        WORD    device_four             ;00001000  8
        WORD    device_one              ;00001001  9
        WORD    device_two              ;00001010  10 a
        WORD    device_one              ;00001011  11 b
        WORD    device_three            ;00001100  12 c
        WORD    device_one              ;00001101  13 d
        WORD    device_two              ;00001110  14 e
        WORD    device_one              ;00001111  15 f
        WORD    device_five             ;00010000  16 10
        WORD    device_one              ;00010001  17 11
        WORD    device_two              ;00010010  18 12
        WORD    device_one              ;00010011  19 13
        WORD    device_three            ;00010100  20 14
        WORD    device_one              ;00010101  21 15
        WORD    device_two              ;00010110  22 16
        WORD    device_one              ;00010111  23 17
        WORD    device_four             ;00011000  24 18
        WORD    device_one              ;00011001  25 19
        WORD    device_two              ;00011010  26 1a
        WORD    device_one              ;00011011  27 1b
        WORD    device_three            ;00011100  28 1c
        WORD    device_one              ;00011101  29 1d
        WORD    device_two              ;00011110  30 1e
        WORD    device_one              ;00011111  31 1f
        WORD    device_six              ;00100000  32 20
        WORD    device_one              ;00100001  33 21
        WORD    device_two              ;00100010  34 22
        WORD    device_one              ;00100011  35 23
        WORD    device_three            ;00100100  36 24
        WORD    device_one              ;00100101  37 25
        WORD    device_two              ;00100110  38 26
        WORD    device_one              ;00100111  39 27
        WORD    device_four             ;00101000  40 28
        WORD    device_one              ;00101001  41 29
        WORD    device_two              ;00101010  42 2a
        WORD    device_one              ;00101011  43 2b
        WORD    device_three            ;00101100  44 2c
        WORD    device_one              ;00101101  45 2d
        WORD    device_two              ;00101110  46 2e
        WORD    device_one              ;00101111  47 2f
        WORD    device_five             ;00110000  48 30
        WORD    device_one              ;00110001  49 31
        WORD    device_two              ;00110010  50 32
        WORD    device_one              ;00110011  51 33
        WORD    device_three            ;00110100  52 34
        WORD    device_one              ;00110101  53 35
        WORD    device_two              ;00110110  54 36
        WORD    device_one              ;00110111  55 37
        WORD    device_four             ;00111000  56 38
        WORD    device_one              ;00111001  57 39
        WORD    device_two              ;00111010  58 3a
        WORD    device_one              ;00111011  59 3b
        WORD    device_three            ;00111100  60 3c
        WORD    device_one              ;00111101  61 3d
        WORD    device_two              ;00111110  62 3e
        WORD    device_one              ;00111111  63 3f
        WORD    device_seven            ;01000000  64  40
        WORD    device_one              ;01000001  1   41
        WORD    device_two              ;01000010  2   42
        WORD    device_one              ;01000011  3   43
        WORD    device_three            ;01000100  4   44
        WORD    device_one              ;01000101  5   45
        WORD    device_two              ;01000110  6   46
        WORD    device_one              ;01000111  7   47
        WORD    device_four             ;01001000  8   48
        WORD    device_one              ;01001001  9   49
        WORD    device_two              ;01001010  10  4a
        WORD    device_one              ;01001011  11  4b
        WORD    device_three            ;01001100  12  4c
        WORD    device_one              ;01001101  13  4d
        WORD    device_two              ;01001110  14  4e
        WORD    device_one              ;01001111  15  4f
        WORD    device_five             ;01010000  16  50
        WORD    device_one              ;01010001  17  51
        WORD    device_two              ;01010010  18  52
        WORD    device_one              ;01010011  19  53
        WORD    device_three            ;01010100  20  54
        WORD    device_one              ;01010101  21  55
        WORD    device_two              ;01010110  22  56
        WORD    device_one              ;01010111  23  57
        WORD    device_four             ;01011000  24  58
        WORD    device_one              ;01011001  25  59
        WORD    device_two              ;01011010  26  5a
        WORD    device_one              ;01011011  27  5b
        WORD    device_three            ;01011100  28  5c
        WORD    device_one              ;01011101  29  5d
        WORD    device_two              ;01011110  30  5e
        WORD    device_one              ;01011111  31  5f
        WORD    device_six              ;01100000  32  60
        WORD    device_one              ;01100001  33  61
        WORD    device_two              ;01100010  34  62
        WORD    device_one              ;01100011  35  63
        WORD    device_three            ;01100100  36  64
        WORD    device_one              ;01100101  37  65
        WORD    device_two              ;01100110  38  66
        WORD    device_one              ;01100111  39  67
        WORD    device_four             ;01101000  40  68
        WORD    device_one              ;01101001  41  69
        WORD    device_two              ;01101010  42  6a
        WORD    device_one              ;01101011  43  6b
        WORD    device_three            ;01101100  44  6c
        WORD    device_one              ;01101101  45  6d
        WORD    device_two              ;01101110  46  6e
        WORD    device_one              ;01101111  47  6f
        WORD    device_five             ;01110000  48  70
        WORD    device_one              ;01110001  49  71
        WORD    device_two              ;01110010  50  72
        WORD    device_one              ;01110011  51  73
        WORD    device_three            ;01110100  52  74
        WORD    device_one              ;01110101  53  75
        WORD    device_two              ;01110110  54  76
        WORD    device_one              ;01110111  55  77
        WORD    device_four             ;01111000  56  78
        WORD    device_one              ;01111001  57  79
        WORD    device_two              ;01111010  58  7a
        WORD    device_one              ;01111011  59  7b
        WORD    device_three            ;01111100  60  7c
        WORD    device_one              ;01111101  61  7d
        WORD    device_two              ;01111110  62  7e
        WORD    device_one              ;01111111  63  7f

RES_CODE ENDS

    END
