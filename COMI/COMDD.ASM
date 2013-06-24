;************************************************************************
;
; $Revision:   1.13  $
;
; $Log:   P:/archive/comi/comdd.asv  $
;
;     Rev 1.13   28 Mar 1996 00:19:44   EMMETT
;  Added resource manager.  Began work on VDD support.
;
;     Rev 1.12   18 Feb 1996 14:16:02   EMMETT
;  Added many features.  Notably:
;  Tracing application DosDevIOCtl function calls and packets.
;  Support for 16650 and 16750 UARTs.
;  Streamlined interrupt routine.
;
;     Rev 1.11   25 Apr 1995 22:16:08   EMMETT
;  Added Support for DigiBoard PC/16.  Changed interrupt Routine for better adapter independence.
;  Changed interrupt routine to allow user to select interrupting device selection algorithim.  Fixed
;  ABIOS interaction for better "non.INI" initialization in MCA machines.  Fixed various initialization
;  message strings.  COMscope and receive buffer are now allocated from system memory, allowing
;  a 32k (word) COMscope buffer and a 64k (byte) receive buffer.
;
;     Rev 1.10   03 Dec 1994 14:45:46   EMMETT
;  Changes segment names.  Simplified DEMO lockup to all 1000 write requests then quit.
;
;     Rev 1.9   29 Jun 1994 09:17:38   EMMETT
;  Changed so that COMscope would process open and close if no application has opened device.
;  This is co that COMscope would initialize and access the device even if no application had previously
;  opened device.
;
;     Rev 1.8   29 Jun 1994 07:38:20   EMMETT
;  Fixed transmit byte immediate to better handle null.
;
;     Rev 1.7   28 Jun 1994 09:04:50   EMMETT
;  Fixed data loss when large packet were transmitted.  Caused by write block timing out.
;  Changed do that semaphore would have infinite time-out whenever
;  Modem interrupts were not disabled by the user.
;
;     Rev 1.6   11 Jun 1994 10:37:32   EMMETT
;  Changed all references to "mirror" to "COMscope".
;
;     Rev 1.5   11 Jun 1994 09:26:16   EMMETT
;  Changed return form write block with more characters to transmit to test
;  line status before writing more data to transmit register.
;
;     Rev 1.4   09 Jun 1994 21:19:50   EMMETT
;  Changed to ALWAYS test modem signals before entering semaphore block.
;
;     Rev 1.3   07 Jun 1994 00:18:40   EMMETT
;  Added support for DigiBoard.
;  Added initialization support for OEM specific loads.
;  Fixed bug in StartWriteStream and ProcessModemSignals that caused handshaking problems.
;  Fixed hardware tests to set baud rate before testing interrupts.
;  Fixed hardware tests off switch to work only for retail version.
;
;     Rev 1.2   27 Apr 1994 22:55:36   EMMETT
;  FIxed ABIOS stuff to work better than before.
;
;     Rev 1.1   18 Apr 1994 23:17:22   EMMETT
;  Changed ABIOS processing and added ability to disallow a port to initialize.
;
;     Rev 1.0   16 Apr 1994 08:34:54   EMMETT
;  Initial version control archive.
;
;************************************************************************

TITLE OS/tools Multi-Port Device Driver
PAGE ,132
;*
;* FILE: COMDD.ASM
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
;.NOLISTMACRO                   ;suppress macro expansion in listing

.NOLIST                  ;suppress listing of INCLUDE files
    INCLUDE SEGMENTS.INC
    INCLUDE COMDD.INC
    INCLUDE DCB.INC
    INCLUDE PACKET.INC
    INCLUDE MACRO.INC
    INCLUDE ABIOS.INC
    INCLUDE DEVHLP.INC
    INCLUDE Hardware.inc

RES_DATA SEGMENT

  IFDEF DEMO
    EXTRN wWriteCount           :WORD
    EXTRN wWriteCountStart      :WORD
  ENDIF
    EXTRN wDeviceOffsetTable    :WORD
    EXTRN stDeviceParms         :WORD
    EXTRN device_hlp            :DWORD
    EXTRN wTimerAllocCount      :WORD
    EXTRN wBusType              :WORD
    EXTRN wDeviceCount          :WORD
    EXTRN wLastFunctionCall     :WORD
    EXTRN wCurrentTarget        :WORD
    EXTRN bNoOUT2change         :WORD
    EXTRN wPCIvendor            :WORD
    EXTRN wPCIdevice            :WORD

    EXTRN wMaskTimerCount       :WORD
    EXTRN wIntRegistered        :WORD

RES_DATA ENDS

RES_CODE SEGMENT
    ASSUME CS:RCGROUP, ES:nothing, SS:nothing, DS:RDGROUP

    EXTRN _Write                :NEAR
    EXTRN _Read                 :NEAR

    EXTRN _GenIOctl             :NEAR

 IFNDEF SHARE
    EXTRN LocalIDCaccess        :NEAR
 ENDIF
    EXTRN FlushInputBuffers     :NEAR
    EXTRN CalcTimeout           :NEAR
    EXTRN ProcessBaud           :NEAR
    EXTRN CalcBaudRate          :NEAR
    EXTRN ProcessFlag1          :NEAR
    EXTRN ProcessFlag2          :NEAR
    EXTRN PROCESSFLAG3          :NEAR
    EXTRN ReleaseInterrupt      :NEAR
    EXTRN RequestInterrupt      :NEAR
    EXTRN StartWriteStream      :NEAR
    EXTRN ReadPath              :NEAR
    EXTRN ClearInputHandshake   :NEAR

;  INIT externals

    EXTRN _Init                 :NEAR

  IFDEF VDD_support
    EXTRN SetupVDDstructures    :NEAR
  ENDIF

.LIST
  EVEN
strat_call_table LABEL WORD

                 DW    _Init        ;Command code 0 initialize driver
                 DW    BadCommand
                 DW    BadCommand
                 DW    BadCommand
                 DW    _Read        ;Command code 4 read from device
                 DW    Peek         ;Command code 5 non-destruct read - no wait
                 DW    InputStatus  ;Command code 6 input status
                 DW    InputFlush   ;Command code 7 flush input buffer
                 DW    _Write       ;Command code 8 write to device
                 DW    BadCommand
                 DW    OutputStatus ;Command code A output status
                 DW    OutputFlushTrace  ;Command code B flush output buffer
                 DW    BadCommand
                 DW    Open         ;Command code D open device
                 DW    Close        ;Command code E close device
                 DW    BadCommand
                 DW    _GenIOctl    ;Command code 10 generic I/O control

  IF DD_level LE 1
max_COM_strat    equ   10h
  ELSE

                 DW    BadCommand   ;11
                 DW    BadCommand   ;12
                 DW    BadCommand   ;13
                 DW    DeInstall    ;Command code 14 deinstall device driver

max_COM_strat    equ   14h

                 DW    BadCommand   ;15
                 DW    BadCommand   ;16
                 DW    BadCommand   ;17
                 DW    BadCommand   ;18
                 DW    BadCommand   ;19
                 DW    BadCommand   ;1A
                 DW    BadCommand   ;1B
                 DW    ShutDown     ;Command code 1C shutdown, not supported
  ENDIF

max_strat        equ   1ch

  IF DD_level GT 1
DeInstall PROC NEAR C oErrorCode:WORD

;        OR_DeviceFlag2 DEV_FLAG2_DEVICE_DEINSTALLED
        StoreError oErrorCode,ERROR_I24_BAD_COMMAND
        ret

DeInstall ENDP

ShutDown PROC NEAR

        ret

ShutDown ENDP
  ENDIF

;------------------------- STRATEGY -------------------------------------
Strategy PROC FAR ; saved by OS - USES eax ebx ecx edx esi edi es ds gs fs

        LOCAL  byErrorFlag:BYTE

; Call appropriate subroutine based on the call table entry specified by
; PktCmd

;  int 3
        mov     di,bx
        xor     bx,bx
        mov     byErrorFlag,0
        mov     bl,ES:[di].s_stPacket.PktCmd

        mov     wLastFunctionCall,bx
        mov     wCurrentTarget,ax

        mov     si,ax
        and     si,000fh
        shl     si,1
        mov     si,wDeviceOffsetTable[si]

  IFDEF NO_COMscope
        test    ax,TARGET_OS_tools      ; is it "OS$tools"?
        jz      test_COM_command
  ELSE
        test    ax,(TARGET_COMscope OR TARGET_OS_tools) ; is it "OS$tools" or "COMscope"?
        jz      test_COM_command

        test    ax,TARGET_OS_tools      ; is it "OS$tools"?
        jnz     test_OS_tools_command

; it is a COMscope command
        or      bx,bx                   ; is it an init command?
        jz      set_command

        cmp     bx,13                   ; is it an open command?
        jne     test_CS_close

        test_DeviceFlag2 DEV_FLAG2_DEVICE_DEINSTALLED
        jz      test_CS_open
        mov     byErrorFlag,ERROR_BAD_UNIT
        jmp     is_error

test_CS_open::                                                               ; makes it global
        test_DeviceFlag1 DEV_FLAG1_COMSCOPE_OPEN
        jz      open_CS
        mov     byErrorFlag,ERROR_DEVICE_IN_USE
        jmp     is_error

open_CS::                                                               ; makes it global
;        test_DeviceFlag2 DEV_FLAG2_USE_DD_DATA_SEGMENT
;        jz      @f
        mov     eax,[si].s_stDeviceParms.oCOMscopeBuff
        mov     [si].s_stDeviceParms.dwCOMscopeQWrtPtr,eax
        mov     [si].s_stDeviceParms.dwCOMscopeQRdPtr,eax
;@@:
        OR_DeviceFlag1 DEV_FLAG1_COMSCOPE_OPEN
        jmp     done

test_CS_close::                                                               ; makes it global
        cmp     bx,14                   ; is it a close command?
        jne     test_CS_read

cs_close::                                                               ; makes it global
        AND_DeviceFlag1 (NOT DEV_FLAG1_COMSCOPE_OPEN)

   IFNDEF NO_ADV_UARTS
; IF this is a 1665x UART and device is not open THEN clear EFR

        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_DEVICE_OPEN
        jnz     done
        test_DeviceFlag2 (DEV_FLAG2_16650_UART OR DEV_FLAG2_16654_UART)
        jz      done
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,LINE_CTL_REG_OFFSET
        InByteDel bx
        mov     ah,al           ;save LCR
        mov     al,0bfh         ;enable EFR
        OutByteDel bx
        add     dx,EFR_REG_OFFSET - LINE_CTL_REG_OFFSET
        xor     al,al
        OutByteImm              ;clear EFR
        add     dx,LINE_CTL_REG_OFFSET - EFR_REG_OFFSET
        mov     al,ah
        OutByteImm              ;restore LCR

   ENDIF ;NO_ADV_UARTS
        jmp     done

test_CS_read::                                                               ; makes it global
        cmp     bx,4                    ; is it a read request?
        jne     test_CS_write
        call    ReadPath
        jmp     done

test_CS_write::                                                               ; makes it global
        cmp     bx,8                    ; is it a write command?
        je      error_out
        jmp     set_command

test_OS_tools_command::                                                               ; makes it global
 ENDIF ;NO_COMscope or x16_BIT
        or      bx,bx                   ; is it an init command?
        jz      set_command
  IFDEF VDD_support
        cmp     bx,01fh                 ; is it an init complete command?
        jne     @f
        call    SetupVDDstructures
        jmp     done
@@:
  ENDIF
        cmp     bx,13                   ; is it an open command?
        je      done
        cmp     bx,14                   ; is it a close command?
        je      done
        cmp     bx,8                    ; is it a write request?
        jne     test_read

  IFNDEF NO_COMscope
        push    di                      ; if write request then clear all COMscope opens
        xor     di,di
        mov     cx,16

COMscope_clear_loop::                                                               ; makes it global
        mov     si,wDeviceOffsetTable[di]
        or      si,si
        jz      COMscope_clear_done
        AND_DeviceFlag1 (NOT DEV_FLAG1_COMSCOPE_OPEN)
        add     di,2
        loop    COMscope_clear_loop

COMscope_clear_done::                                                               ; makes it global
        pop     di
        jmp     done
  ELSE
        lea     bx,byErrorFlag
        push    bx
        call    BadCommand
        add     sp,2
        jmp     is_error
  ENDIF

test_read::                                                               ; makes it global
        cmp     bx,4                    ; is it a read request?
        jne     @f
        call    ReadPath
        jmp     done
@@:
        xor     si,si
        cmp     bx,16                   ; is it a DosDevIOCtrl command?
        je      do_command

error_out::                                                               ; makes it global
        mov     byErrorFlag,ERROR_I24_GEN_FAILURE
        jmp     is_error

test_COM_command::                                                               ; makes it global
        or      bx,bx
        jnz     @f
        or      si,si
        jz      set_command
        jmp     block_addr_error
@@:
        or      si,si
        jnz     set_command

block_addr_error::                                                               ; makes it global
        mov     byErrorFlag,ERROR_I24_NOT_READY
        jmp     is_error

set_command::                                                               ; makes it global
        or      bx,bx               ;test if INIT command
        jz      do_command          ; if it is then segments are undefined
                                    ; and not needed
  IFNDEF x16_BIT
;        test_DeviceFlag2 DEV_FLAG2_USE_DD_DATA_SEGMENT
;        jnz     do_command
    IFNDEF NO_COMscope
        mov     fs,[si].s_stDeviceParms.wCOMscopeSelector
    ENDIF
        mov     gs,[si].s_stDeviceParms.wRdBuffSelector
  ENDIF

do_command::                                                               ; makes it global
        cmp     bx,max_COM_strat        ;is command larger than those supported
        jna     @f
        lea     bx,byErrorFlag
        push    bx
        call    BadCommand
        add     sp,2
        jmp     is_error
@@:
        shl     bx,1                    ;convert to offset
        push    di
        push    es
        lea     cx,byErrorFlag
        push    cx
        call    CS:strat_call_table[bx]   ;call appropriate routine
        add     sp,2
        pop     es
        pop     di
        cli
        cmp     byErrorFlag,0 ;check if error returned
        jz      done

is_error::                                                               ; makes it global
        mov     al,byErrorFlag
        sti
        xor     ah,ah
        or      ax,ERROR_MASK
        mov     ES:[di].s_stPacket.PktStatus,ax

done::                                                               ; makes it global
        sti
        or      ES:[di].s_stPacket.PktStatus,DEV_DONE
        ret

Strategy ENDP
page

BadCommand PROC NEAR C oErrorCode:WORD

        StoreError oErrorCode,ERROR_I24_BAD_COMMAND
        ret

BadCommand ENDP

;------------------------------ TIMER -----------------------------------

Timer PROC FAR USES ax bx cx dx si

        pushf
        lea     si,stDeviceParms
        mov     cx,wDeviceCount

timer_loop::                                                               ; makes it global
        cmp     [si].s_stDeviceParms.wRdTimerCount,0
        je      test_RTS
        dec     [si].s_stDeviceParms.wRdTimerCount
        jnz     test_RTS
        or      [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_RCV_TIMED_OUT
        mov     ax,ds
        lea     bx,[si].s_stDeviceParms.dwRdSemaphore
        mov     dl,DevHlp_SemClear
        call    device_hlp

test_RTS::                                                               ; makes it global
        cmp     [si].s_stDeviceParms.wRTScount,0
        je      test_Xmit
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,LINE_ST_REG_OFFSET
        InByteImm
        test    al,LINE_ST_TX_HOLD_EMPTY
        jnz     @f
        mov     ax,[si].s_stDeviceParms.wRTS_DTRoffDelay
        mov     [si].s_stDeviceParms.wRTScount,ax
        jmp     test_Xmit
@@:
        dec     [si].s_stDeviceParms.wRTScount
        jnz     test_Xmit
        add     dx,MDM_CTL_REG_OFFSET - LINE_ST_REG_OFFSET
        InByteImm
        and     al,NOT MDM_CTL_RTS_ACTIVATE
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_DEACTIVATE_DTR
        jz      @f
        and     al,NOT MDM_CTL_DTR_ACTIVATE
@@:
   IFNDEF NO_COMscope
;        test_DeviceFlag2 DEV_FLAG2_USE_DD_DATA_SEGMENT
;        jnz     @f
        mov     fs,[si].s_stDeviceParms.wCOMscopeSelector
;@@:
        COMscopeStream ebx, CSFUNC_TRACE_MODEM_OUT_SIGNALS, CS_MODEM_OUT
   ENDIF
        OutByteDel bx
        AND_DeviceFlag1 (NOT DEV_FLAG1_RTS_TOG_ON)

test_Xmit::
        cmp     [si].s_stDeviceParms.wWrtTimerCount,0
        jz      timer_loop_iteration_end
;        je      test_stream_to_start
        dec     [si].s_stDeviceParms.wWrtTimerCount
        jnz     test_stream_to_start
        or      [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_XMIT_TIMED_OUT
        mov     ax,ds
        lea     bx,[si].s_stDeviceParms.dwWrtSemaphore
        mov     dl,DevHlp_SemClear
        call    device_hlp
        jmp     timer_loop_iteration_end

test_stream_to_start::
        test    [si].s_stDeviceParms.wDeviceStatus2,DEV_ST2_RESTARTSTREAM
        jz      timer_loop_iteration_end

timer_start_stream::
        call    StartWriteStream
;        and     [si].s_stDeviceParms.wDeviceStatus2,(NOT DEV_ST2_RESTARTSTREAM)

timer_loop_iteration_end::                                                               ; makes it global
        add     si,TYPE s_stDeviceParms
  IFNDEF x16_BIT
        dec     cx
        jnz     timer_loop
  ELSE
        loop    timer_loopX
        jmp     @f

timer_loopX::                                                               ; makes it global
        jmp     timer_loop
@@:
  ENDIF
        cmp     wBusType,BUSTYPE_MCA
        jne     timer_exit
        inc     wMaskTimerCount
        cmp     wMaskTimerCount,10
        jb      timer_exit
        mov     wMaskTimerCount,0
        mov     dx,wIntRegistered
;        or      dl,dl
;        jz      test_8_15
        in      al,21h
        test    al,dl
        jz      test_8_15
TM1::                                                               ; makes it global
        not     dl
        and     al,dl
        IOdelay bx
        out     21h,al

test_8_15::                                                               ; makes it global
;        or       dh,dh
;        jz      @f
        IOdelay bx
        in      al,0a1h
        test    al,dh
        jz      timer_exit
TM2::                                                               ; makes it global
        not     dh
        and     al,dh
        IOdelay bx
        out    0a1h,al

timer_exit::                                                               ; makes it global
        popf
        ret

Timer ENDP

IFDEF this_junk

;------------------------------ READ --------------------------------------

Read PROC NEAR C, oErrorCode:WORD

        LOCAL   wByteCount      :WORD,
                wBytesLeft      :WORD,
                wSelector       :WORD,
                wOffset         :WORD,
                wStoreCount     :WORD

  IFDEF PCMCIA
    IFNDEF SHARE
        test_DeviceFlag1 DEV_FLAG2_PCMCIA_SUPPORT
        jz      @f
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_PCMCIA_CONNECTED
        StoreError oErrorCode,ERROR_I24_GEN_FAILURE
        ret
@@:
    ENDIF
  ENDIF
        push    es
        push    di
        cli
  IFDEF DEMO
        test_DeviceFlag1 DEV_FLAG1_PAGER_OPEN
        jnz     no_rd_lock_up
        test    wSystemDebug,SYS_DB_NO_EVAL_LIMIT
        jnz     no_rd_lock_up
        cmp     wWriteCountStart,ZERO
        jne     no_rd_lock_up
        mov     wByteCount,0
;        StoreError oErrorCode,ERROR_I24_READ_FAULT
        jmp     abort_read

no_rd_lock_up::                                                               ; makes it global
  ENDIF
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_DEVICE_OPEN
        jz      read_general_fail
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_RX_IN_PROGRESS
        jnz     test_read_was_flushed
        mov     [si].s_stDeviceParms.byReadPktQHead,ZERO
        mov     [si].s_stDeviceParms.byReadPktQTail,ZERO
        mov     al,0

  IFNDEF NO_COMscope
        test    [si].s_stDeviceParms.fCOMscopeFunction,CSFUNC_TRACE_READ
        jz      @f
        push    ES:[di].s_stPacket.RWpacket.IOcount
        mov     ah,CS_READ_REQ
        push    ax
        call    _COMscopeReadWrite
        add     sp,4
@@:
  ENDIF
        jmp     do_read

test_read_was_flushed::                                                               ; makes it global
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_INPUT_FLUSHED
        jz      test_read_packet_depth
        mov     wByteCount,0
        jmp     abort_read

test_read_packet_depth::                                                               ; makes it global
; Receive is blocked so queue packet and wait for some previous
; packet to finish processing.

; have we reached the maximum number of packets queued?

        mov     al,[si].s_stDeviceParms.byReadPktQHead
        sub     al,[si].s_stDeviceParms.byReadPktQTail

  IFNDEF NO_COMscope
        test    [si].s_stDeviceParms.fCOMscopeFunction,CSFUNC_TRACE_READ
        jz      @f
        push    ES:[di].s_stPacket.RWpacket.IOcount
        mov     ah,CS_READ_REQ
        push    ax
        call    _COMscopeReadWrite
        add     sp,4
@@:
  ENDIF
        cmp     al,[si].s_stDeviceParms.byMaxReadPktCount
        jb      queue_packet

read_general_fail::                                                               ; makes it global
        mov     wByteCount,0
        jmp     abort_read

queue_packet::                                                               ; makes it global
        push    si
        lea     si,[si].s_stDeviceParms.dwReadReqPktQueueHead
        mov     bx,di
        mov     dx,DevHlp_PushReqPacket
        call    device_hlp
        pop     si

; we should NEVER have to reset the timer

        cmp     [si].s_stDeviceParms.wRdTimerCount,0
        jne     queue_wait_block
        mov     ax,[si].s_stDeviceParms.wReadTimerStart
        mov     [si].s_stDeviceParms.wRdTimerCount,ax

queue_wait_block::                                                               ; makes it global
        mov     bx,[si].s_stDeviceParms.wIObaseAddress
        mov     ah,80h
        mov     al,[si].s_stDeviceParms.byReadPktQHead
        inc     [si].s_stDeviceParms.byReadPktQHead
        mov     cx,-1
        mov     di,cx
        mov     dx,DevHlp_Block
        call    device_hlp
        cli

pull_req_packet::                                                               ; makes it global
        push    si
        lea     si,[si].s_stDeviceParms.dwReadReqPktQueueHead
        mov     dx,DevHlp_PullReqPacket
        call    device_hlp
        mov     di,bx
        pop     si
        jnc     test_read_flushed
        mov     wByteCount,0
        jmp     clear_read_in_progress_bit

test_read_flushed::                                                               ; makes it global
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_INPUT_FLUSHED
        jz      do_read
        mov     wByteCount,0
        jmp     read_exit

do_read::                                                               ; makes it global
        or      [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_RX_IN_PROGRESS
        and     [si].s_stDeviceParms.wDeviceStatus1,NOT DEV_ST1_INPUT_FLUSHED
        mov     cx,ES:[di].s_stPacket.RWpacket.IOcount
        or      cx,cx
        jnz     @f
        mov     wByteCount,0
        jmp     read_exit
@@:
        sti
        mov     wByteCount,cx
        mov     wBytesLeft,cx
        mov     ax,ES:[di].s_stPacket.RWpacket.IOdataOffset + 2
        mov     wSelector,ax
        mov     bx,ES:[di].s_stPacket.RWpacket.IOdataOffset
        mov     wOffset,bx

        test    [si].s_stDeviceParms.wDeviceFlag2,DEV_FLAG2_FIFO_AVAILABLE
        jz      verify_and_block
        call    ReadFIFO

verify_and_block::                                                               ; makes it global
        mov     cx,wBytesLeft
        mov     dh,1                            ;es and di
        mov     dl,DevHlp_PhysToVirt
        call    device_hlp
        jnc     set_read_loop
        mov     wByteCount,0
        jmp     read_exit

set_read_loop::                                                               ; makes it global
        mov     bl,[si].s_stDeviceParms.byFlag3
        and     bl,F3_READ_TIMEOUT_MASK
        cmp     bl,F3_WAIT_NORM
        je      normal
        cmp     bl,F3_WAIT_NONE
        je      no_wait_loop
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_RCV_QUEUE_EMPTY
        jnz     normal

no_wait_loop::                                                               ; makes it global
        cli
        call    ReadReceiveQueue
        sti
        jc      read_return            ; carry set if no byte read
        mov     ES:[di],al
        inc     di
        dec     wBytesLeft
        jnz     no_wait_loop
        jmp     read_return

normal::                                                               ; makes it global
        mov     wStoreCount,0

normal_loop::                                                               ; makes it global
        cli
        call    ReadReceiveQueue        ;carry set if no byte read
        jc      unconvert_and_block
        sti
        mov     ES:[di],al
        inc     di
        inc     wStoreCount
        dec     wBytesLeft
        jnz     normal_loop

read_return::                                                               ; makes it global
        mov     dl,DevHlp_UnPhysToVirt
        call    device_hlp
        jmp     calc_final_count

unconvert_and_block::                                                               ; makes it global
        mov     dl,DevHlp_UnPhysToVirt
        call    device_hlp

read_block::                                                               ; makes it global
        mov     ax,wBytesLeft
        mov     [si].s_stDeviceParms.wReadByteCount,ax
        mov     cx,wStoreCount
        add     wOffset,cx
        or      [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_RCV_BLOCKED
;        and     [si].s_stDeviceParms.wCOMevent,NOT COM_EVENT_RCV_BYTE
        AND_DeviceFlag1 (NOT DEV_FLAG1_EVENT_RCV_BYTE)
        and     [si].s_stDeviceParms.wDeviceStatus1,NOT DEV_ST1_RCV_TIMED_OUT
        mov     ax,[si].s_stDeviceParms.wReadTimerStart
        mov     [si].s_stDeviceParms.wRdTimerCount,ax
        mov     ax,ds
        lea     bx,[si].s_stDeviceParms.dwRdSemaphore
        mov     cx,0
        mov     di,cx
        mov     dl,DevHlp_SemRequest
        call    device_hlp
  IFNDEF read_timeout_limit
        mov     cx,-1
        mov     di,cx
  ELSE
        mov     cx,0ea60h                ; one minute maximun
        mov     di,0
  ENDIF
        mov     ax,ds
        lea     bx,[si].s_stDeviceParms.dwRdSemaphore
        mov     dl,DevHlp_SemRequest
        call    device_hlp
        cli
        jnc     read_sem_cleared
        and     [si].s_stDeviceParms.wDeviceStatus1,NOT DEV_ST1_RCV_BLOCKED
        jmp     calc_final_count

read_sem_cleared::                                                               ; makes it global
        and     [si].s_stDeviceParms.wDeviceStatus1,NOT DEV_ST1_LAST_CHAR_RCVD
        and     [si].s_stDeviceParms.wDeviceStatus1,NOT DEV_ST1_RCV_BLOCKED

; IF input has been flushed THEN return immediately

        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_INPUT_FLUSHED
        jz      dequeue_bytes
        jmp     calc_final_count

dequeue_bytes::                                                               ; makes it global
; dequeue any bytes that have come in since we blocked

        mov     cx,wBytesLeft
        mov     ax,wSelector
        mov     bx,wOffset
        mov     dh,1                            ;es and di
        mov     dl,DevHlp_PhysToVirt
        call    device_hlp
        jc      conversion_error
        mov     wStoreCount,0

reread_loop::                                                               ; makes it global
        cli
        call    ReadReceiveQueue        ;carry set if no byte read
        jc      test_reentry
        sti
        mov     ES:[di],al
        inc     di
        inc     wStoreCount
        dec     wBytesLeft
        jnz     reread_loop
        mov     dl,DevHlp_UnPhysToVirt
        call    device_hlp
        jmp     read_exit

conversion_error::                                                               ; makes it global
        jmp     calc_final_count

test_reentry::                                                               ; makes it global

; If we didn't read all bytes required then we may have got here because
; either something came in and we are doing "Wait for Something" read
; timeout processing or a Receive FIFO Timeout interrupt occurred, causing
; us to clear the semaphore before all data was received (semaphore cleared
; by COM_interrupt routine, no read timeout flagged).  In this case we will
; block again, forcing us to wait another user specified Read Timeout period.

; Test if Read Interrupt or Timer semaphore clear got us here.

        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_RCV_TIMED_OUT
        jnz     read_timed_out

; Test if we are doing "wait for something" read timeout processing

        mov     cl,[si].s_stDeviceParms.byFlag3
        and     cl,F3_READ_TIMEOUT_MASK
        cmp     cl,F3_WAIT_SOMETHING
        jne     read_block
        jmp     calc_final_count

read_timed_out::                                                               ; makes it global

; IF we have queued data since we blocked THEN block again
; This can only happen if the user selected read timeout value translates
; to less time than it takes to read a full buffer (8 or 14 bytes) or after
; no new character has arrived within the last four character times and the
; user specified Read Timeout period is less than four character times.
; Only if no Receive FIFO Timeout event has occurred (semaphore cleared by
; by TIMER routine, read timeout flagged).

; IF FIFO available THEN read any bytes remaining in FIFO

        test    [si].s_stDeviceParms.wDeviceFlag2,DEV_FLAG2_FIFO_AVAILABLE
        jz      @f
        call    ReadFIFO

; IF there was data in the hardware buffer THEN queue 'em up and block again
; (this is specifically for slow baud rates).

        or      cx,cx
        jz      @f
        mov     ax,wStoreCount
        add     wOffset,ax
        mov     ax,wSelector
        mov     bx,wOffset
        jmp     verify_and_block
@@:

; IF any new data has arrived since we blocked THEN block again
; (this is for user timeouts of less than 8/14 character times)

;        test    [si].s_stDeviceParms.wCOMevent,COM_EVENT_RCV_BYTE
        test_DeviceFlag1 DEV_FLAG1_EVENT_RCV_BYTE
        jnz     read_block

calc_final_count::                                                               ; makes it global
        mov     bx,wBytesLeft
        sub     wByteCount,bx

read_exit::                                                               ; makes it global
        cli
        mov     al,[si].s_stDeviceParms.byReadPktQHead
        sub     al,[si].s_stDeviceParms.byReadPktQTail
  IFNDEF NO_COMscope
        pushf
        test    [si].s_stDeviceParms.fCOMscopeFunction,CSFUNC_TRACE_READ
        jz      @f
        push    wByteCount
        mov     ah,CS_READ_CMPLT
        push    ax
        call    _COMscopeReadWrite
        add     sp,4
@@:
        popf
  ENDIF
        jz      clear_read_in_progress_bit
        mov     bx,[si].s_stDeviceParms.wIObaseAddress
        mov     ah,80h
        mov     al,[si].s_stDeviceParms.byReadPktQTail
        inc     [si].s_stDeviceParms.byReadPktQTail
        mov     dl,DevHlp_Run
        call    device_hlp
        jmp     abort_read

clear_read_in_progress_bit::                                                               ; makes it global
        and     [si].s_stDeviceParms.wDeviceStatus1,NOT DEV_ST1_RX_IN_PROGRESS
        and     [si].s_stDeviceParms.wDeviceStatus1,NOT DEV_ST1_INPUT_FLUSHED

abort_read::                                                               ; makes it global
        sti
        pop     di
        pop     es
        mov     cx,wByteCount
        mov     ES:[di].s_stPacket.RWpacket.IOcount,cx          ;Length of the data into count
        ret

Read ENDP

;------------------ WriteBlock ----------------------------

WriteBlock PROC NEAR USES ax bx cx dx di

begin_wait:
        mov     ax,ds
        lea     bx,[si].s_stDeviceParms.dwWrtSemaphore
        xor     cx,cx
        mov     di,cx
        mov     dl,DevHlp_SemRequest
        call    device_hlp
        mov     ax,ds

; If CTS output handshaking is enabled AND
; device is hardware handshaking capable UART AND
; hardware handshaking is enabled THEN
; setup semaphore polling timeout

        test    [si].s_stDeviceParms.byFlag1,F1_ENABLE_CTS_OUTPUT_HS
        jz      test_all_output_HS_flags
        test_DeviceFlag2 (DEV_FLAG2_16750_UART OR DEV_FLAG2_TI16550C_UART OR \
                          DEV_FLAG2_16650_UART OR DEV_FLAG2_16654_UART)
IFNDEF SHARE        
        jz      test_all_output_HS_flags
        test    [si].s_stDeviceParms.wConfigFlags2,CFG_FLAG2_HDW_CTS_HS
ENDIF
        jnz     polling_TO
; If any output handshaking is enabled and modem interrupts are not enabled THEN
; setup semaphore polling timeout.
test_all_output_HS_flags:
        test    [si].s_stDeviceParms.byFlag1,(F1_ENABLE_CTS_OUTPUT_HS OR \
                                              F1_ENABLE_DSR_OUTPUT_HS OR \
                                              F1_ENABLE_DCD_OUTPUT_HS)
        jz      infinite_TO
        test_DeviceFlag1 DEV_FLAG1_MDM_INT_ENABLED
        jnz     infinite_TO

polling_TO:
        mov     cx,100h
        xor     di,di
        jmp     @f

infinite_TO::                                                               ; makes it global
        mov     cx,0ffffh
        mov     di,cx
@@:
        OR_DeviceFlag1 DEV_FLAG1_WRT_BLOCKED
        lea     bx,[si].s_stDeviceParms.dwWrtSemaphore
        mov     dl,DevHlp_SemRequest
        call    device_hlp
        jnc     exit_write_block
        cmp     ax,ERROR_SEM_TIMEOUT
        jne     exit_write_block

; This can only happen if semaphore was NOT set infinite TO
;        test_DeviceFlag1 DEV_FLAG1_MDM_INT_ENABLED
;        jnz     exit_write_block

; If there are no characters to transmit the end block
        cmp     [si].s_stDeviceParms.wXmitQueueCount,0
        je      exit_write_block

; If there are characters to transmit then update the modem signals and test if it
; is OK to restart transmission.
        call    UpdateModemHandshakeBits
        test    [si].s_stDeviceParms.byHSstatus,TX_WAITING_HDW_MASK

; Block again if it is NOT OK to tramsmit
        jnz     begin_wait

exit_write_block:
        AND_DeviceFlag1 (NOT DEV_FLAG1_WRT_BLOCKED)
        ret

WriteBlock ENDP


;------------------------------ WRITE -------------------------------------

Write  PROC NEAR C, oErrorCode:WORD

        LOCAL   wByteCount      :WORD,
                wSelector       :WORD,
                wOffset         :WORD,
                wBytesLeft      :WORD,
                wLoadCount      :WORD,
                wBlockCount     :WORD,
                bWriteComplete  :WORD

  IFDEF PCMCIA
    IFNDEF SHARE
        test_DeviceFlag1 DEV_FLAG2_PCMCIA_SUPPORT
        jz      @f
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_PCMCIA_CONNECTED
        StoreError oErrorCode,ERROR_I24_GEN_FAILURE
        ret
@@:                                                               ; makes it global
    ENDIF
  ENDIF
        push    es
        push    di


  IFDEF DEMO
        test_DeviceFlag1 DEV_FLAG1_PAGER_OPEN
        jnz     no_wrt_lock_up
        test    wSystemDebug,SYS_DB_NO_EVAL_LIMIT
        jnz     no_wrt_lock_up
        cmp     wWriteCount,ZERO
        je      write_fault
        mov     ax,ES:[di].s_stPacket.RWpacket.IOcount
        or      ax,ax
        jz      no_wrt_lock_up
        xor     dx,dx
        mov     cx,1000
        div     cx
        inc     ax
        sub     wWriteCount,ax
        jnc     no_wrt_lock_up
        mov     wWriteCount,ZERO

write_fault::                                                               ; makes it global
        mov     wByteCount,0
        jmp     abort_write

no_wrt_lock_up::                                                               ; makes it global
  ENDIF
        cli
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_DEVICE_OPEN
        jz      wrt_general_fail
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_TX_IN_PROGRESS
        jnz     test_write_flushed
        mov     [si].s_stDeviceParms.byWritePktQHead,ZERO
        mov     [si].s_stDeviceParms.byWritePktQTail,ZERO
        mov     al,0
  IFNDEF NO_COMscope
        test    [si].s_stDeviceParms.fCOMscopeFunction,CSFUNC_TRACE_WRITE
        jz      do_write
        push    ES:[di].s_stPacket.RWpacket.IOcount
        mov     ah,CS_WRITE_REQ
        push    ax
        call    _COMscopeReadWrite
        add     sp,4
  ENDIF
        jmp     do_write

test_write_flushed::                                                               ; makes it global
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_OUTPUT_FLUSHED
        jz      test_wrt_packet_depth
        mov     wByteCount,0
        jmp     abort_write

test_wrt_packet_depth::                                                               ; makes it global
        mov     al,[si].s_stDeviceParms.byWritePktQHead
        sub     al,[si].s_stDeviceParms.byWritePktQTail
  IFNDEF NO_COMscope
        test    [si].s_stDeviceParms.fCOMscopeFunction,CSFUNC_TRACE_WRITE
        jz      @f
        push    ES:[di].s_stPacket.RWpacket.IOcount
        mov     ah,CS_WRITE_REQ
        push    ax
        call    _COMscopeReadWrite
        add     sp,4
@@:
  ENDIF
        cmp     al,[si].s_stDeviceParms.byMaxWritePktCount
        jb      queue_wrt_packet

wrt_general_fail::                                                               ; makes it global
        mov     wByteCount,0
        jmp     abort_write

queue_wrt_packet::                                                               ; makes it global
        push    si
        lea     si,[si].s_stDeviceParms.dwWriteReqPktQueueHead
        mov     bx,di
        mov     dx,DevHlp_PushReqPacket
        call    device_hlp
        pop     si

; reseting the timer should NEVER be necessary

;        cmp     [si].s_stDeviceParms.wWrtTimerCount,0
;        jne     wait_block
;        mov     ax,[si].s_stDeviceParms.wWriteTimerStart
;        mov     [si].s_stDeviceParms.wWrtTimerCount,ax

wait_block::                                                               ; makes it global
        mov     bx,[si].s_stDeviceParms.wIObaseAddress
        mov     ah,0c0h
        mov     al,[si].s_stDeviceParms.byWritePktQHead
        inc     [si].s_stDeviceParms.byWritePktQHead
        mov     cx,-1
        mov     di,cx
        mov     dl,DevHlp_Block
        call    device_hlp
        cli

pull_wrt_req_packet::                                                               ; makes it global
        push    si
        lea     si,[si].s_stDeviceParms.dwWriteReqPktQueueHead
        mov     dx,DevHlp_PullReqPacket
        call    device_hlp
        mov     di,bx
        pop     si
        jnc     test_wrt_flushed
        mov     wByteCount,0
        jmp     abort_write

test_wrt_flushed::                                                               ; makes it global
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_OUTPUT_FLUSHED
        jz      do_write
        mov     wByteCount,0
        jmp     write_exit

do_write::                                                               ; makes it global
        or      [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_TX_IN_PROGRESS
        mov     cx,ES:[di].s_stPacket.RWpacket.IOcount
        sti
        or      cx,cx
        jne     @f
        mov     wByteCount,0
        jmp     write_exit
@@:
        mov     wByteCount,cx
;        and     [si].s_stDeviceParms.wCOMevent,NOT COM_EVENT_LAST_BYTE
;        and     [si].s_stDeviceParms.wDeviceStatus1,NOT DEV_ST1_OUTPUT_FLUSHED
        mov     ax,ES:[di].s_stPacket.RWpacket.IOdataOffset
        mov     wOffset,ax
        mov     ax,ES:[di].s_stPacket.RWpacket.IOdataOffset + 2
        mov     wSelector,ax

define_buffer::                                                               ; makes it global
        mov     di,wOffset              ;save offset for this move
        mov     bWriteComplete,TRUE

; IF data to write is greater than write buffer length THEN
; adjust load count to buffer length AND
; adjust bytes left count AND
; adjust data offset for next move AND
; flag write not complete

        mov     bx,[si].s_stDeviceParms.wWrtBufferLength
        cmp     cx,bx                   ; is buffer larger
        jbe     clear_bytes_left
        mov     bWriteComplete,FALSE
        sub     cx,bx                   ; cx = bytes left to move
        mov     wBytesLeft,cx
        add     wOffset,bx              ; set offset for next move
        mov     cx,bx                   ; cx = buffer length
        jmp     fill_buffer

clear_bytes_left::                                                               ; makes it global
        mov     wBytesLeft,ZERO

fill_buffer::                                                               ; makes it global
        mov     wLoadCount,cx

; verify user data and move user data to device buffer

        push    si
        push    ds
        mov     ax,ds
        mov     es,ax
        mov     ax,wSelector
        mov     bx,di                   ;restore offset
        mov     di,[si].s_stDeviceParms.oWriteBuffer
        mov     dx,DevHlp_PhysToVirt
        call    device_hlp
        jnc     move_bytes
        pop     ds
        pop     si
        jmp     disable_write_interrupt

move_bytes::                                                               ; makes it global
        shr     cx,1
        jz      byte_only
        cld
    rep movsw
        jnc     unconvert

byte_only::                                                               ; makes it global
        movsb

unconvert::                                                               ; makes it global
        pop     ds
        pop     si
        mov     dl,DevHlp_UnPhysToVirt
        call    device_hlp

        mov     cx,wLoadCount
        mov     wBlockCount,cx
        cli
        mov     [si].s_stDeviceParms.wXmitQueueCount,cx
        mov     ax,[si].s_stDeviceParms.oWriteBuffer
        mov     [si].s_stDeviceParms.wXmitQueueReadPointer,ax
        mov     [si].s_stDeviceParms.wWrtTimerCount,0

prime_write::                                                               ; makes it global
        and     [si].s_stDeviceParms.wDeviceStatus1,NOT DEV_ST1_XMIT_TIMED_OUT
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,LINE_ST_REG_OFFSET

;        jmp     test_HDW_TX_HS  ; testing wait for hold timing

check_TX_holding_register::
        InByteDel bx
        test    al,LINE_ST_TX_HOLD_EMPTY
        jnz     test_HDW_TX_HS
        InByteDel bx
        test    al,LINE_ST_TX_HOLD_EMPTY
        jnz     test_HDW_TX_HS
        test    [si].s_stDeviceParms.byFlag3,F3_INFINITE_WRT_TIMEOUT
        jnz     wait_Tx_empty_loop
        mov     ax,[si].s_stDeviceParms.wWriteTimerStart
        mov     [si].s_stDeviceParms.wWrtTimerCount,ax

wait_Tx_empty_loop::                                                                ; makes it global
 IFDEF this_junk
  IFNDEF NO_ADV_UARTS
   IFNDEF NO_16650_Xon_HS_support
        test    [si].s_stDeviceParms.wConfigFlags2,CFG_FLAG2_HDW_TX_XON_HS
        jz      test_HDW_CTS_HS
        test    [si].s_stDeviceParms.byFlag2,F2_ENABLE_XMIT_XON_XOFF_FLOW
        jnz     wait_prime_block

test_HDW_CTS_HS::                                                               ; makes it global
   ENDIF
        test_DeviceFlag2 (DEV_FLAG2_16750_UART OR \
                          DEV_FLAG2_TI16550C_UART OR \
                          DEV_FLAG2_16650_UART OR \
                          DEV_FLAG2_16654_UART)
IFNDEF SHARE        
        jz      wait_prime_block
        test    [si].s_stDeviceParms.wConfigFlags2,CFG_FLAG2_HDW_CTS_HS
ENDIF
        jnz     wait_yield
        
wait_prime_block::                                                               ; makes it global
        call    WriteBlock
        cli
        jmp     test_timeout

wait_yield::                                                               ; makes it global
  ENDIF
 ENDIF
        call    WriteBlock
;        BlockYield cs, si       ; default is 100 milliseconds

test_timeout::                                                               ; makes it global
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_OUTPUT_FLUSHED OR \
                                                 DEV_ST1_XMIT_TIMED_OUT
        jnz     disable_write_interrupt

;        jmp     test_HDW_TX_HS  ;testing wait for hold timing

        InByteDel bx
        test    al,LINE_ST_TX_HOLD_EMPTY
        jnz     test_HDW_TX_HS
        InByteDel bx
        test    al,LINE_ST_TX_HOLD_EMPTY
        jz      wait_Tx_empty_loop

test_HDW_TX_HS::                                                               ; makes it global
        test    [si].s_stDeviceParms.byFlag3,F3_INFINITE_WRT_TIMEOUT
        jnz     test_HDW_TX_HS_loop
        cli
;        cmp     [si].s_stDeviceParms.wWrtTimerCount,0
;        jne     test_HDW_TX_HS_loop
        mov     ax,[si].s_stDeviceParms.wWriteTimerStart
        mov     [si].s_stDeviceParms.wWrtTimerCount,ax

test_HDW_TX_HS_loop::                                                               ; makes it global
        call    UpdateModemHandshakeBits
        test    [si].s_stDeviceParms.byHSstatus,TX_WAITING_HDW_MASK
        jz      initiate_stream
        RTStoggleOn ebx
        call    WriteBlock
        cli
        test    [si].s_stDeviceParms.wDeviceStatus1,(DEV_ST1_OUTPUT_FLUSHED OR \
                                                     DEV_ST1_XMIT_TIMED_OUT)
        jnz     disable_write_interrupt
        jmp     test_HDW_TX_HS_loop

initiate_stream::                                                               ; makes it global
        sti
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        mov     cx,[si].s_stDeviceParms.wTxFIFOdepth

        test_DeviceFlag1 DEV_FLAG1_IMM_BYTE_WAITING
        jz      test_TX_HS
        mov     al,[si].s_stDeviceParms.byImmediateByte

        RTStoggleOn ebx
        COMscopeStream ebx, CSFUNC_TRACE_OUTPUT_STREAM, CS_WRITE_IMM
        OutByteDel bx
        AND_DeviceFlag1 (NOT DEV_FLAG1_IMM_BYTE_WAITING)
        loop    test_TX_HS
        jmp     enable_write_interrupts

test_TX_HS::                                                               ; makes it global
        cli
        test    [si].s_stDeviceParms.byFlag3,F3_INFINITE_WRT_TIMEOUT
        jnz     test_TX_HS_loop
        cmp     [si].s_stDeviceParms.wWrtTimerCount,0
        je      disable_write_interrupt

test_TX_HS_loop::                                                               ; makes it global
        call    UpdateModemHandshakeBits
        test    [si].s_stDeviceParms.byHSstatus,TX_WAITING_MASK
        jz      start_stream
        RTStoggleOnLoadDX ebx
        call    WriteBlock
        cli
        test    [si].s_stDeviceParms.wDeviceStatus1,(DEV_ST1_OUTPUT_FLUSHED OR \
                                                     DEV_ST1_XMIT_TIMED_OUT)
        jnz     disable_write_interrupt
        jmp     test_TX_HS_loop

start_stream::                                                               ; makes it global
        cli
        cmp     [si].s_stDeviceParms.wXmitQueueCount,0
        je      test_more_data
        mov     di,[si].s_stDeviceParms.wXmitQueueReadPointer
        RTStoggleOn ebx

fill_loop:
        inc     [si].s_stDeviceParms.dwTransmitCount
        mov     al,[di]

        COMscopeStream ebx, CSFUNC_TRACE_OUTPUT_STREAM, CS_WRITE
        OutByteDel bx
        inc     di
        dec     [si].s_stDeviceParms.wXmitQueueCount
        loopnz  fill_loop

        cmp     [si].s_stDeviceParms.wXmitQueueCount,0
        je      test_more_data

        mov     [si].s_stDeviceParms.wXmitQueueReadPointer,di
        sti

enable_write_interrupts::
        and     [si].s_stDeviceParms.wDeviceStatus2,(NOT DEV_ST2_RESTARTSTREAM)
        inc     dx
        InByteDel bx
        or      al,INT_EN_TX_HOLD_EMPTY
        cli
        OutByteDel bx                 ;enable write interrupt

WRT_BLK::                                                               ; makes it global
        test    [si].s_stDeviceParms.byFlag3,F3_INFINITE_WRT_TIMEOUT
        jnz     @f
        cmp     [si].s_stDeviceParms.wWrtTimerCount,0
        je      disable_write_interrupt
;        je      wait_for_last_byte
@@:
        call    WriteBlock
        cli

;   If write block timed out or the output buffer was flushed then
;   cleanup and return

        test    [si].s_stDeviceParms.wDeviceStatus1,(DEV_ST1_OUTPUT_FLUSHED OR \
                                                    DEV_ST1_XMIT_TIMED_OUT )
        jnz     disable_write_interrupt
;        jnz     wait_for_last_byte

;  If the interrupt routine, or StartWriteStream, has transmitted all of
;  bytes in the transmit buffer (wXmitQueueCount == 0) THEN
;    see if there is more data to move to the transmit buffer ELSE
;    try to restart the stream.
;  If write block was cleared after the last character was transmitted or
;  StartWriteStream cleared then test if there is more data to transmit.

        cmp     [si].s_stDeviceParms.wXmitQueueCount,0
        je      test_more_data
        jmp     prime_write
;        jne     prime_write

test_more_data::                                                               ; makes it global
        sti

; IF we didn't complete sending all requested bytes THEN reload the
; transmit buffer and send more (define_buffer, prime_write).

        cmp     bWriteComplete,TRUE
        je      last_out
        mov     cx,wBytesLeft
        jmp     define_buffer

; wait until the last byte is out of the shift register

last_out::                                                               ; makes it global
        or      [si].s_stDeviceParms.wCOMevent,COM_EVENT_LAST_BYTE
        mov     [si].s_stDeviceParms.wWrtTimerCount,0
        sti

;        jmp     disable_write_interrupt  ; for testing if waiting adds too much time

wait_for_last_byte:
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,LINE_ST_REG_OFFSET
        InByteDel bx
        test    al,LINE_ST_TX_HOLD_EMPTY
        jnz     disable_write_interrupt
        InByteDel bx
        test    al,LINE_ST_TX_HOLD_EMPTY
        jnz     disable_write_interrupt
  IFNDEF NO_ADV_UARTS
   IFNDEF NO_16650_Xon_HS_support
        test    [si].s_stDeviceParms.wConfigFlags2,CFG_FLAG2_HDW_TX_XON_HS
        jz      test_HDW_CTS
        test    [si].s_stDeviceParms.byFlag2,F2_ENABLE_XMIT_XON_XOFF_FLOW
        jnz     disable_write_interrupt
test_HDW_CTS::                                                               ; makes it global
   ENDIF
        test_DeviceFlag2 (DEV_FLAG2_16750_UART OR \
                          DEV_FLAG2_TI16550C_UART OR \
                          DEV_FLAG2_16650_UART OR \
                          DEV_FLAG2_16654_UART)
        jz      last_out_loop_setup
IFNDEF SHARE        
        test    [si].s_stDeviceParms.wConfigFlags2,CFG_FLAG2_HDW_CTS_HS
        jz      last_out_loop_setup
ENDIF        
        test    [si].s_stDeviceParms.byFlag1,F1_ENABLE_CTS_OUTPUT_HS
        jnz     disable_write_interrupt

last_out_loop_setup::                                                               ; makes it global
  ENDIF ;NOT NO_ADV_UARTS
        mov     cx,1000

last_out_loop::                                                               ; makes it global
        push    dx
        mov     dl,DevHlp_Yield
        call    device_hlp
        pop     dx
        InByteDel bx
        test    al,LINE_ST_TX_HOLD_EMPTY
        loopz  last_out_loop

disable_write_interrupt::                                                               ; makes it global
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        inc     dx
        InByteDel bx
        test    al,INT_EN_TX_HOLD_EMPTY
        jz      @f
        and     al,NOT INT_EN_TX_HOLD_EMPTY
        OutByteDel bx
@@:
        mov     bx,wLoadCount
        mov     ax,bx
        sub     bx,[si].s_stDeviceParms.wXmitQueueCount
        sub     ax,bx
        add     ax,wBytesLeft
        sub     wByteCount,ax
        mov     [si].s_stDeviceParms.wXmitQueueCount,0

write_exit::                                                               ; makes it global
        cli
        mov     al,[si].s_stDeviceParms.byWritePktQHead
        sub     al,[si].s_stDeviceParms.byWritePktQTail
  IFNDEF NO_COMscope
        pushf
        test    [si].s_stDeviceParms.fCOMscopeFunction,CSFUNC_TRACE_WRITE
        jz      @f
        push    wByteCount
        mov     ah,CS_WRITE_CMPLT
        push    ax
        call    _COMscopeReadWrite
        add     sp,4
@@:                                                               ; makes it global
        popf
  ENDIF
        jz      clear_wrt_in_progress_bit
        mov     bx,[si].s_stDeviceParms.wIObaseAddress
        mov     ah,0c0h
        mov     al,[si].s_stDeviceParms.byWritePktQTail
        inc     [si].s_stDeviceParms.byWritePktQTail
        mov     dl,DevHlp_Run
        call    device_hlp
        jmp     abort_write

clear_wrt_in_progress_bit::                                                               ; makes it global
        and     [si].s_stDeviceParms.wDeviceStatus1,NOT DEV_ST1_TX_IN_PROGRESS
        and     [si].s_stDeviceParms.wDeviceStatus1,NOT DEV_ST1_OUTPUT_FLUSHED

abort_write::                                                               ; makes it global
        sti
        pop     di
        pop     es
        mov     cx,wByteCount
        mov     ES:[di].s_stPacket.RWpacket.IOcount,cx
        ret

Write ENDP

ENDIF

;------------------------- OPEN -----------------------------------------

Open PROC NEAR C, oErrorCode:WORD
;        LOCAL bPagerDevice:WORD

        cli
  IFDEF PCMCIA
    IFNDEF SHARE
        test_DeviceFlag1 DEV_FLAG2_PCMCIA_SUPPORT
        jz      @f
        test      [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_PCMCIA_CONNECTED
        jz      open_general_fail
@@:                                                               ; makes it global
    ENDIF
  ENDIF
  IFDEF PAGE_SUPPORT
; test trigger and clear if it is on

        mov     ax,ADD_IS_TRIGGERED
        call    LocalIDCaccess
        jc      test_pager_open

; if COMi is triggered (nc) then if this device is already opened by a pager then
; decrement pager count and post sharing error
; otherwise open pager

        test_DeviceFlag1 DEV_FLAG1_PAGER_OPEN
        jz      open_pager
        mov     ax,ADD_CLOSE_PAGER
        call    LocalIDCaccess          ;just to decrement counter

; This device is already opened by a pager device and cannot be opened again.
; Since the calling process had to increment the pager count to set the
; trigger we need to decrement it again to be used again at another time.

sharing_error::                                                               ; makes it global
        StoreError oErrorCode,ERROR_SHARING_VIOLATION
        jmp     open_exit

open_pager::                                                               ; makes it global
        OR_DeviceFlag1 DEV_FLAG1_PAGER_OPEN
        jmp     normal_open

test_pager_open::                                                               ; makes it global
; if COMi is not triggered (cy) test if a pager is has device open
; post sharing error if pager has device open

        test_DeviceFlag1 DEV_FLAG1_PAGER_OPEN
        jnz     sharing_error

normal_open::                                                               ; makes it global
  ENDIF  ;PAGE_SUPPORT
        cmp     [si].s_stDeviceParms.wOpenCount,MAX_OPEN_COUNT
        jc      @f

open_general_fail::                                                               ; makes it global
        StoreError oErrorCode,ERROR_I24_GEN_FAILURE
        jmp     open_exit
@@:
        inc     [si].s_stDeviceParms.wOpenCount
        cmp     [si].s_stDeviceParms.wOpenCount,1
        je      init_port
        sti
        COMscopeStream ebx, CSFUNC_TRACE_OPEN, CS_OPEN_TWO
        jmp     open_exit

init_port::                                                               ; makes it global
        sti
  IFDEF DEMO
        test_DeviceFlag1 DEV_FLAG1_PAGER_OPEN
        jnz     @f
        cmp     wWriteCount,ZERO
        jne     @f
        shr     wWriteCountStart,1
        mov     ax,wWriteCountStart
        mov     wWriteCount,ax
@@:
  ENDIF
        COMscopeStream ebx, CSFUNC_TRACE_OPEN, CS_OPEN_ONE
        or      [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_DEVICE_OPEN
  IFDEF COMscope_activates_port
        test_DeviceFlag1 DEV_FLAG1_COMSCOPE_OPEN
        jnz     open_exit
  ENDIF
        call    OpenProcess
        jc      @f
        jmp     open_exit
@@:
        dec     [si].s_stDeviceParms.wOpenCount
        and     [si].s_stDeviceParms.wDeviceStatus1,NOT DEV_ST1_DEVICE_OPEN

        StoreError oErrorCode,al

open_exit::                                                               ; makes it global
        ret

Open ENDP

OpenProcess PROC NEAR C

;        LOCAL   byLineControl:BYTE

        call    RequestInterrupt
        jnc     @f
        mov     ax,ERROR_SHARING_VIOLATION
        jmp     exit
@@:
; Make sure line control register is not corrupted.  Added because UART would sometimes NOT
; get initialized correctly, leaving the DLB bit on.
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,LINE_CTL_REG_OFFSET
        InByteDel bx
        test    al,LINE_CTL_DLB_ACCESS
        jz      @f
        mov     al,03h   ;8, n, 1
        OutByteDel bx
        mov     [si].s_stDeviceParms.byDataLengthMask,DEFAULT_DATA_LEN_MASK
@@:
        mov     [si].s_stDeviceParms.wRTScount,ZERO
        mov     [si].s_stDeviceParms.wRTS_DTRoffDelay,DEFAULT_RTS_OFF_DELAY
        and     [si].s_stDeviceParms.wDeviceStatus1,NOT DEV_ST1_DEACTIVATE_DTR
        sti
        and     [si].s_stDeviceParms.wDeviceStatus1,NOT (DEV_ST1_OUTPUT_FLUSHED OR\
                                                      DEV_ST1_INPUT_FLUSHED OR \
                                                      DEV_ST1_RCV_BLOCKED OR \
                                                      DEV_ST1_TX_IN_PROGRESS OR \
                                                      DEV_ST1_RX_IN_PROGRESS)
        mov     [si].s_stDeviceParms.wCOMevent,0
        mov     [si].s_stDeviceParms.wCOMerror,0
        mov     al,[si].s_stDeviceParms.byDefXonChar
        mov     [si].s_stDeviceParms.byXonChar,al
        mov     al,[si].s_stDeviceParms.byDefXoffChar
        mov     [si].s_stDeviceParms.byXoffChar,al
        mov     al,[si].s_stDeviceParms.byFlag2Mask
        and     [si].s_stDeviceParms.byFlag2,al
        mov     al,[si].s_stDeviceParms.byDefFlag3
        or      al,al
        jz      normal_flag3_init
        and     al,(F3_READ_TIMEOUT_MASK OR F3_INFINITE_WRT_TIMEOUT)
        and     [si].s_stDeviceParms.byFlag3,NOT (F3_READ_TIMEOUT_MASK OR F3_INFINITE_WRT_TIMEOUT)
        or      [si].s_stDeviceParms.byFlag3,al
        jmp     @f

normal_flag3_init::                                                               ; makes it global
        and     [si].s_stDeviceParms.byFlag3,NOT F3_READ_TIMEOUT_MASK
        or      [si].s_stDeviceParms.byFlag3,F3_WAIT_NORM
@@:
        mov     al,[si].s_stDeviceParms.byDefErrorChar
        mov     [si].s_stDeviceParms.byErrorChar,al
        mov     al,[si].s_stDeviceParms.byDefBreakChar
        mov     [si].s_stDeviceParms.byBreakChar,al
        AND_DeviceFlag1 (NOT DEV_FLAG1_IMM_BYTE_WAITING)

        mov     ax,[si].s_stDeviceParms.wDefWrtTimeout
        mov     [si].s_stDeviceParms.wWrtTimeout,ax
        mov     ax,[si].s_stDeviceParms.wDefRdTimeout
        mov     [si].s_stDeviceParms.wRdTimeout,ax

  IFNDEF x16_BIT
        mov     eax,[si].s_stDeviceParms.dwBaudRate
  ELSE
        mov     ax,WORD PTR[si].s_stDeviceParms.dwBaudRate
        mov     dx,WORD PTR[si + 2].stDeviceParms.dwBaudRate
  ENDIF
        mov     cx,ax
        and     cx,07fffh       ;limit minimum baud rate
        test    [si].s_stDeviceParms.wConfigFlags1,CFG_FLAG1_EXPLICIT_BAUD_DIVISOR
        jnz     got_baud

        call    CalcBaudRate
        jnc     got_baud

IFDEF this_junk
  IFNDEF NO_4x_CLOCK_SUPPORT
        cmp     wPCIvendor,PCI_VENDOR_CONNECTECH
        jne     test_4x
        test    wPCIdevice,PCI_DEVICE_BLUEHEAT_MSK
        jz      test_4x
        mov     eax,MAX_12X_BAUD_RATE
        jmp     normalize_baud
test_4x:
        test_DeviceFlag2 DEV_FLAG2_4x_BAUD_CLOCK
        jz      @f
        mov     eax,MAX_4X_BAUD_RATE
        jmp     normalize_baud
@@:
  ENDIF
ENDIF ; this_junk
  IFNDEF x16_BIT
        mov     eax,MAX_LONG_BAUD_RATE
IFNDEF this_junk
        cmp     [si].s_stDeviceParms.xBaudMultiplier,1
        jbe     normalize_baud
        xor     ebx,ebx
        mov     bl,[si].s_stDeviceParms.xBaudMultiplier
        mul     ebx
        cmp     edx,0    ; test for overflow
        je      normalize_baud
        mov     eax,MAX_LONG_BAUD_RATE   ; messed up don't multiply (safety net)
ENDIF

normalize_baud::                                                               ; makes it global
        idiv    ecx            ; CalcBaudRate always clears ECX at start

got_baud::                                                               ; makes it global
        mov     [si].s_stDeviceParms.dwBaudRate,eax
  ELSE
        mov     ax,LOWWORD(MAX_LONG_BAUD_RATE)
        mov     dx,HIGHWORD(MAX_LONG_BAUD_RATE)
        idiv    cx

got_baud::                                                               ; makes it global
        mov     WORD PTR[si].s_stDeviceParms.dwBaudRate,ax
        mov     WORD PTR [si + 2].stDeviceParms.dwBaudRate,dx
  ENDIF
        mov     [si].s_stDeviceParms.wBaudRateDivisor,cx
        call    ProcessBaud

  IFDEF this_junk
;  IFNDEF NO_ADV_UARTS
; IF UART is 1665x then enable 16650 Enhanced Feature Registers (EFR)
        test_DeviceFlag2 (DEV_FLAG2_16650_UART OR DEV_FLAG2_16654_UART)
        jz      clear_RX_buffer
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,LINE_CTL_REG_OFFSET
        InByteDel bx
        mov     ah,al           ;save LCR
        mov     al,0bfh         ;enable EFR
        OutByteDel bx
        add     dx,EFR_REG_OFFSET - LINE_CTL_REG_OFFSET
        mov     al,EFR_ENABLE_16650
        OutByteImm              ;clear EFR
        add     dx,LINE_CTL_REG_OFFSET - EFR_REG_OFFSET
        mov     al,ah
        OutByteImm              ;restore LCR

clear_RX_buffer::                                                               ; makes it global
  ENDIF
        mov     dx,[si].s_stDeviceParms.wIObaseAddress

        mov     cx,66  ; number greater than max FIFO depth (16654 and 16750)
        IOdelay bx

clear_RX_buffer_loop::                                                               ; makes it global
        add     dx,LINE_ST_REG_OFFSET
;        InByteDel bx
        InByteImm
        sub     dx,LINE_ST_REG_OFFSET
        test    al,LINE_ST_RCV_DATA_READY
        jz      test_for_FIFO_availability
;        InByteDel bx
        InByteImm
        loop     clear_RX_buffer_loop

        stc
        mov     ax,ERROR_I24_GEN_FAILURE
        jmp     exit

test_for_FIFO_availability:       ;16550 and up

        test    [si].s_stDeviceParms.wDeviceFlag2,DEV_FLAG2_FIFO_AVAILABLE
        jnz     setup_thresholds         ; TestValidHDW determined

; Just in case UART is part of chipset and was not enabled during initialization
; of COMi, then test if UART can be placed into "16550" mode.

        add     dx,FIFO_CTL_REG_OFFSET ; same as INT_ID REG_OFFSET
        InByteDel bx
        mov     al,01h
        OutByteDel bx
        xor     al,al ;cannot be 16650 or 16654 if FIFOs not available during initialization (SMC fix)
        InByteDel bx
        and     al,INT_ID_FIFOS_AVAIL_MASK
        cmp     al,INT_ID_FIFOS_AVAIL_MASK
        jne     no_FIFO
        or      [si].s_stDeviceParms.wDeviceFlag2,DEV_FLAG2_FIFO_AVAILABLE

setup_thresholds::                                                               ; makes it global
        mov     ax,[si].s_stDeviceParms.wDefXonThreshold
        or      ax,ax
        jz      @f
        mov     [si].s_stDeviceParms.wXonThreshold,ax
@@:
        mov     ax,[si].s_stDeviceParms.wDefXoffThreshold
        or      ax,ax
        jnz     store_threshold

        test_DeviceFlag2 DEV_FLAG2_16650_UART
        jz      test_16750_threshold
        mov     ax,DEF_16650_Xoff_THRESHOLD
        jmp     store_threshold

test_16750_threshold::                                                               ; makes it global
        test_DeviceFlag2 DEV_FLAG2_16750_UART
        jz      test_16654_threshold
        mov     ax,DEF_16750_Xoff_THRESHOLD
        jmp     store_threshold

test_16654_threshold::                                                               ; makes it global
        test_DeviceFlag2 DEV_FLAG2_16654_UART
        jz      set_16550_threshold
        mov     ax,DEF_16654_Xoff_THRESHOLD
        jmp     store_threshold

set_16550_threshold::                                                               ; makes it global
        mov     ax,DEF_16550_Xoff_THRESHOLD

store_threshold::                                                               ; makes it global
        mov     [si].s_stDeviceParms.wDefXoffThreshold,ax
        mov     [si].s_stDeviceParms.wXoffThreshold,ax
        jmp     clear_FIFO_control

no_FIFO::                                                               ; makes it global
        and     [si].s_stDeviceParms.byFlag3,NOT F3_HDW_BUFFER_MASK
        and     [si].s_stDeviceParms.wDeviceFlag2,NOT DEV_FLAG2_FIFO_AVAILABLE

clear_FIFO_control::                                                               ; makes it global
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,FIFO_CTL_REG_OFFSET
        mov     ax,FIFO_CTL_RESET_FIFOS
        mov     [si].s_stDeviceParms.wFIFOcontrolImage,ax
        OutByteDel bx
;        xor     al,al
;        OutByteDel bx

; process flags control
  IFDEF this_junk
;  save current modem control states
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,MDM_CTL_REG_OFFSET
        InByteDel bx
        mov     byLastModemOut,al
  ENDIF
        mov     ah,[si].s_stDeviceParms.byFlag1
        call    ProcessFlag1

        mov     ah,[si].s_stDeviceParms.byFlag2
        call    ProcessFlag2

        mov     ah,[si].s_stDeviceParms.byFlag3
        push    WORD PTR TRUE                  ; force FIFO init
        call    PROCESSFLAG3

; enable OUT2

        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,MDM_CTL_REG_OFFSET
        InByteDel bx
        cmp     bNoOUT2change,TRUE
        je      open_explicit
        or      al,MDM_CTL_OUT2_ACTIVATE

; process modem signals
; Normal flags processing will not write to the register if there is no change
; of state requested.  DTR and RTS are explicitly deactivated during
; close processing, without regard for the states of the flags, but they must
; be set according to those same flags during open processing.  The flags do
; change between close and open processing , but the register may not reflect
; the state the flags required during open processing, therefore we must
; explicitly set these signals after normal flags processing.  Got it?
open_explicit::                                                               ; makes it global

; IF DTR input handshaking or DTR enable THEN turn on DTR

        mov     ah,[si].s_stDeviceParms.byFlag1
        and     ah,F1_DTR_HS_MASK
        cmp     ah,F1_DISABLE_DTR
        je      test_explicit_RTS
        or      al,MDM_CTL_DTR_ACTIVATE

test_explicit_RTS::                                                               ; makes it global
  IFNDEF NO_ADV_UARTS
; If this is UART with hardware handshaking capabilities and CTS hardware
; handshaking is requested then activate RTS and do NOT mess with CTS

        test_DeviceFlag2 (DEV_FLAG2_16750_UART OR \
                          DEV_FLAG2_TI16550C_UART OR \
                          DEV_FLAG2_16650_UART OR \
                          DEV_FLAG2_16654_UART)
        jz      @f
IFNDEF SHARE        
        test    [si].s_stDeviceParms.wConfigFlags2,CFG_FLAG2_HDW_CTS_HS
        jz      @f
ENDIF        
        or      al,MDM_CTL_RTS_ACTIVATE
        jmp     reset_CTS_output_HS_flag
@@:
  ENDIF
; IF RTS input handshaking or RTS enable THEN turn on RTS

        mov     ah,[si].s_stDeviceParms.byFlag2
        and     ah,F2_RTS_HS_MASK
        cmp     ah,F2_DISABLE_RTS
        je      test_open_CTS
        cmp     ah,F2_ENABLE_RTS_TOG_ON_XMIT
        je      test_open_CTS
        or      al,MDM_CTL_RTS_ACTIVATE

test_open_CTS::                                                               ; makes it global
        mov     ah,[si].s_stDeviceParms.byFlag1
        test    ah,F1_ENABLE_CTS_OUTPUT_HS
        jz      reset_CTS_output_HS_flag
        mov     bl,al
        add     dx,MDM_ST_REG_OFFSET - MDM_CTL_REG_OFFSET
        cli
        InByteImm
        xchg    al,bl
        add     dx,MDM_CTL_REG_OFFSET - MDM_ST_REG_OFFSET
        test    bl,MDM_ST_CTS
        jnz     reset_CTS_output_HS_flag
        or      [si].s_stDeviceParms.byHSstatus,TX_WAITING_FOR_CTS_ON
        jmp     set_MDM_CTL_register

reset_CTS_output_HS_flag::                                                               ; makes it global
        and     [si].s_stDeviceParms.byHSstatus,NOT TX_WAITING_FOR_CTS_ON

set_MDM_CTL_register:
        COMscopeStream ebx, CSFUNC_TRACE_MODEM_OUT_SIGNALS, CS_MODEM_OUT
        OutByteDel bx

test_DSR_input_HS::                                                               ; makes it global
; IF we are to enable DSR input handshaking AND DSR is not activated THEN
; set receive waiting for DSR

        add     dx,MDM_ST_REG_OFFSET - MDM_CTL_REG_OFFSET
        cli
        InByteDel bx
        mov     ah,[si].s_stDeviceParms.byFlag1
        test    ah,F1_ENABLE_DSR_INPUT_HS
        jz      reset_DSR_input_HS_flag
        test    al,MDM_ST_DSR
        jnz     reset_DSR_input_HS_flag
        or      [si].s_stDeviceParms.byHSstatus,RX_WAITING_FOR_DSR_ON
        jmp     test_DSR_out

reset_DSR_input_HS_flag::                                                               ; makes it global
        and     [si].s_stDeviceParms.byHSstatus,NOT RX_WAITING_FOR_DSR_ON

test_DSR_out::                                                               ; makes it global
        test    ah,F1_ENABLE_DSR_OUTPUT_HS
        jz      reset_DSR_output_HS_flag
        test    al,MDM_ST_DSR
        jnz     reset_DSR_output_HS_flag
        or      [si].s_stDeviceParms.byHSstatus,TX_WAITING_FOR_DSR_ON
        jmp     test_DCD

reset_DSR_output_HS_flag::                                                               ; makes it global
        and     [si].s_stDeviceParms.byHSstatus,NOT TX_WAITING_FOR_DSR_ON

test_DCD::                                                               ; makes it global
        test    ah,F1_ENABLE_DCD_OUTPUT_HS
        jz      reset_DCD_output_HS_flag
        test    al,MDM_ST_DCD
        jnz     reset_DCD_output_HS_flag
        or      [si].s_stDeviceParms.byHSstatus,TX_WAITING_FOR_DCD_ON
        jmp     enable_interrupts

reset_DCD_output_HS_flag::                                                               ; makes it global
        and     [si].s_stDeviceParms.byHSstatus,NOT TX_WAITING_FOR_DCD_ON
 IFDEF this_junk
set_mdmsig_int_process:
        AND_DeviceFlag2 (NOT (DEV_FLAG2_SAVE_MSR OR DEV_FLAG2_MONITOR_CTS))
        test_DeviceFlag2 (DEV_FLAG2_16750_UART OR DEV_FLAG2_TI16550C_UART OR \
                          DEV_FLAG2_16650_UART OR DEV_FLAG2_16654_UART)
        jz      @f
IFNDEF SHARE        
        test    [si].s_stDeviceParms.wConfigFlags2,CFG_FLAG2_HDW_CTS_HS
        jz      @f
ENDIF        
        test    [si].s_stDeviceParms.byFlag1,F1_ENABLE_CTS_OUTPUT_HS
        jz      @f
        OR_DeviceFlag2 (DEV_FLAG2_MONITOR_CTS OR DEV_FLAG2_SAVE_MSR)
        jmp     enable_interrupts
@@:
        test    [si].s_stDeviceParms.wConfigFlags1,CFG_FLAG1_NO_MODEM_INT
        jz      enable_interrupts
        test    [si].s_stDeviceParms.byFlag1,(F1_ENABLE_CTS_OUTPUT_HS OR \
                                              F1_ENABLE_DSR_OUTPUT_HS OR \
                                              F1_ENABLE_DCD_OUTPUT_HS)
        jz      enable_interrupts
        OR_DeviceFlag2 DEV_FLAG2_SAVE_MSR
 ENDIF
enable_interrupts::                                                               ; makes it global
        xor     cx,cx
        mov     cl,[si].s_stDeviceParms.byInterruptLevel
  IFDEF force_poll
        mov     ax,1
        shl     ax,cl
        or      ax,1              ; bit to force poll when spurious interrupt occurs
        mov     ax,cx
  ENDIF
        mov     [si].s_stDeviceParms.wInterruptStatus,cx
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
;        InByteImm
        add     dx,INT_ID_REG_OFFSET
        InByteImm
        add     dx,LINE_ST_REG_OFFSET - INT_ID_REG_OFFSET
        InByteImm
        add     dx,MDM_ST_REG_OFFSET - LINE_ST_REG_OFFSET
        InByteImm

; Get current contents of MSR
; We are setting them here even though we may not have to
        mov     [si].s_stDeviceParms.byMSRimage,al
        and     [si].s_stDeviceParms.byMSRimage,0f0h

        add     dx,INT_EN_REG_OFFSET - MDM_ST_REG_OFFSET

        mov     al,INT_EN_RCV_DATA_AVAIL
        or      al,INT_EN_RX_LINE_STAT

        AND_DeviceFlag1 (NOT DEV_FLAG1_MDM_INT_ENABLED)
        AND_DeviceFlag2 (NOT (DEV_FLAG2_MONITOR_CTS OR DEV_FLAG2_SAVE_MSR))

; If the user requires that modem interrupts NOT be enabled then we have to make provisions
; for the case that a hardware handshaking capable UART had hardware handshaking is enabled AND
; CTS output handshaking is enabled by the application.
; In this case we have to test MSR for changes of state each time it is read and if CTS output handshaking
; is enabled we have to monitor CTS by polling during write processing.

; Test if the user requested modem interrupts be disabled.
        test    [si].s_stDeviceParms.wConfigFlags1,CFG_FLAG1_NO_MODEM_INT
        jz      allow_modem_interrupts

; Test if DCD or DSR output handshaking is enabled and enable MSR change of state monitoring if either is enabled
        test    [si].s_stDeviceParms.byFlag1,(F1_ENABLE_DSR_OUTPUT_HS OR \
                                              F1_ENABLE_DCD_OUTPUT_HS)
        jz      test_CTS_polling
        OR_DeviceFlag2 DEV_FLAG2_SAVE_MSR

test_CTS_polling:
; Test if CTS output handshaking is enabled and enable MSR change of state monitoring if it is enabled
        test    [si].s_stDeviceParms.byFlag1,F1_ENABLE_CTS_OUTPUT_HS
        jz      out_int_enable_reg
        OR_DeviceFlag2 DEV_FLAG2_SAVE_MSR

; Test if UART is hardware handshaking capable and if not then finish
        test_DeviceFlag2 (DEV_FLAG2_16750_UART OR DEV_FLAG2_TI16550C_UART OR \
                          DEV_FLAG2_16650_UART OR DEV_FLAG2_16654_UART)
        jz      out_int_enable_reg

IFNDEF SHARE        
; Test if user requested hardware handshaking and enable CTS polling if it is requested
        test    [si].s_stDeviceParms.wConfigFlags2,CFG_FLAG2_HDW_CTS_HS
        jz      out_int_enable_reg
ENDIF
; Enable CTS polling during write processing
        OR_DeviceFlag2 DEV_FLAG2_MONITOR_CTS
        jmp     out_int_enable_reg

allow_modem_interrupts:
; If UART is hardware handshaking capable then test CTS handshaking modes
        test_DeviceFlag2 (DEV_FLAG2_16750_UART OR DEV_FLAG2_TI16550C_UART OR \
                          DEV_FLAG2_16650_UART OR DEV_FLAG2_16654_UART)
        jz      test_all_output_handshaking
        test    [si].s_stDeviceParms.byFlag1,F1_ENABLE_CTS_OUTPUT_HS
        jz      test_output_handshaking
IFNDEF SHARE        
        test    [si].s_stDeviceParms.wConfigFlags2,CFG_FLAG2_HDW_CTS_HS
        jz      test_output_handshaking
ENDIF        
; CTS output handshaking is enabled, UART is hardware handshaking capable and the user
; requested CTS hardware handshaking, so cause MSR change of state and CTS state polling
        OR_DeviceFlag2 (DEV_FLAG2_MONITOR_CTS OR DEV_FLAG2_SAVE_MSR)

test_output_handshaking:
; If other modem signal output handshaking is enabled then enable modem interrupts anyway
        test    [si].s_stDeviceParms.byFlag1,(F1_ENABLE_DSR_OUTPUT_HS OR \
                                              F1_ENABLE_DCD_OUTPUT_HS)
  IFDEF NO_COMscope
        jz      out_int_enable_reg
  ELSE
        jz      test_COMscope
  ENDIF
        jmp     enable_mdm_int

test_all_output_handshaking:
; If any modem signal output handshaking is enabled then enable modem interrupts
        test    [si].s_stDeviceParms.byFlag1,(F1_ENABLE_DSR_OUTPUT_HS OR \
                                              F1_ENABLE_DCD_OUTPUT_HS OR \
                                              F1_ENABLE_CTS_OUTPUT_HS)
        jnz     enable_mdm_int
  IFNDEF NO_COMscope
test_COMscope:
; If COMscope is supposed to be monitoring input modem signals then enable them without
; regard for handshaking mode

        test    [si].s_stDeviceParms.fCOMscopeFunction,CSFUNC_TRACE_MODEM_IN_SIGNALS
        jz      out_int_enable_reg
  ENDIF

enable_mdm_int::                                                               ; makes it global
        OR_DeviceFlag1 DEV_FLAG1_MDM_INT_ENABLED
        or      al,INT_EN_MODEM_STAT    ;enable modem interrupts

out_int_enable_reg::                                                               ; makes it global
  IFNDEF NO_ADV_UARTS
    IFNDEF NO_16650_Xon_HS_support
        test_DeviceFlag2 (DEV_FLAG2_16650_UART OR DEV_FLAG2_16654_UART)
        jz      @f
        test    [si].s_stDeviceParms.wConfigFlags2,CFG_FLAG2_HDW_TX_XON_HS
        jz      @f
        or      al,INT_EN_XOFF_RECEIVED
@@:
    ENDIF
  ENDIF
        OutByteDel bx

        inc     wTimerAllocCount
        cmp     wTimerAllocCount,1
        jne     @f
        mov     ax,OFFSET Timer
        mov     dl,DevHlp_SetTimer
        call    device_hlp
@@:
        clc
exit::                                                               ; makes it global
        ret

OpenProcess ENDP

;-------------------------- CLOSE -------------------------------------

Close PROC NEAR C oErrorCode:WORD

        cli
  IFDEF PAGE_SUPPORT
; if this device was opened by a pager then decrement counter
; and close pager

        test_DeviceFlag1 DEV_FLAG1_PAGER_OPEN
        jz      @f
        mov     ax,ADD_CLOSE_PAGER
        call    LocalIDCaccess
        AND_DeviceFlag1 (NOT DEV_FLAG1_PAGER_OPEN)
@@:
  ENDIF ; PAGE_SUPPORT

        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_DEVICE_OPEN
        jnz     @f
        StoreError oErrorCode,ERROR_I24_GEN_FAILURE
        jmp     close_done
@@:
        dec     [si].s_stDeviceParms.wOpenCount
        jz      @f
        sti
        COMscopeStream ebx, CSFUNC_TRACE_OPEN, CS_CLOSE_TWO
        jmp     close_done
@@:
        and     [si].s_stDeviceParms.wDeviceStatus1,NOT DEV_ST1_DEVICE_OPEN
        call    CloseProcess

close_done:
        sti
        ret

Close ENDP

CloseProcess PROC NEAR

        mov     [si].s_stDeviceParms.wRTScount,0
        AND_DeviceFlag1 (NOT DEV_FLAG1_RTS_TOG_ON)
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,INT_EN_REG_OFFSET
        mov     al,ZERO           ;disable all interrupts
        OutByteDel bx
        mov     [si].s_stDeviceParms.wInterruptStatus,ZERO
        add     dx,MDM_CTL_REG_OFFSET - INT_EN_REG_OFFSET
        cmp     bNoOUT2change,TRUE
        je      @f
        InByteDel bx
        and     al,NOT MDM_CTL_OUT2_ACTIVATE
        OutByteDel bx
@@:
        sti

  IFNDEF NO_ADV_UARTS
; IF this is a 1665x UART THEN clear EFR
        test_DeviceFlag2 (DEV_FLAG2_16650_UART OR DEV_FLAG2_16654_UART)
        jz      flush_buffers
;        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,LINE_CTL_REG_OFFSET - MDM_CTL_REG_OFFSET
        InByteDel bx
        mov     ah,al           ;save LCR
        mov     al,0bfh         ;enable EFR
        OutByteDel bx
        add     dx,EFR_REG_OFFSET - LINE_CTL_REG_OFFSET
        xor     al,al
        OutByteImm              ;clear EFR
        add     dx,LINE_CTL_REG_OFFSET - EFR_REG_OFFSET
        mov     al,ah
        OutByteImm              ;restore LCR

flush_buffers::                                                               ; makes it global
  ENDIF
        call    FlushInputBuffers
        call    OutputFlush
        xor     ax,ax
;        mov     [si].s_stDeviceParms.byReadPktQHead,al
;        mov     [si].s_stDeviceParms.byReadPktQTail,al
;        mov     [si].s_stDeviceParms.byWritePktQHead,al
;        mov     [si].s_stDeviceParms.byWritePktQTail,al
        mov     [si].s_stDeviceParms.byHSstatus,al
        mov     [si].s_stDeviceParms.wWrtTimerCount,ax
        mov     [si].s_stDeviceParms.wRdTimerCount,ax

; IF Hardware (RTS or DTR) handshaking is enabled THEN
; carefully deactivate RTS and DTR

;   wait until all characters have been transmitted plus 10 more character times
;   or one second - whichever is less to disable DTR and RTS

        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,MDM_CTL_REG_OFFSET
        InByteDel bx
;        cli
        test    al,MDM_CTL_RTS_ACTIVATE OR MDM_CTL_DTR_ACTIVATE
        jz      clear_break

;        sti
        test    al,MDM_CTL_DTR_ACTIVATE
        jz      set_clear_modem_signals
        or      [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_DEACTIVATE_DTR

set_clear_modem_signals::                                                               ; makes it global
        mov     ax,10h
        test    [si].s_stDeviceParms.wConfigFlags1,CFG_FLAG1_EXPLICIT_BAUD_DIVISOR
        jnz     set_delay

; should possibly change this to process extended baud rates
        mov     ax,[si].s_stDeviceParms.wBaudRateDivisor
        and     ax,07fffh
        xor     dx,dx
        mov     cx,86    ;one character time is about 86% of the divisor / 100
        div     cx
        mov     cx,10   ; times ten character times
        mul     cx
        call    CalcTimeout

set_delay::                                                               ; makes it global
        mov     [si].s_stDeviceParms.wRTScount,ax
        mov     [si].s_stDeviceParms.wRTS_DTRoffDelay,ax

clear_break::                                                               ; makes it global
;        sti
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,LINE_CTL_REG_OFFSET
        InByteDel bx
        and     al,NOT LINE_CTL_SEND_BREAK
        OutByteDel bx
        and     [si].s_stDeviceParms.byHSstatus,NOT TX_WAITING_BECAUSE_BREAK_RX

        test_DeviceFlag1 DEV_FLAG1_INPUT_HS_IN_PROGRESS
        jz      close_end
        AND_DeviceFlag1 (NOT DEV_FLAG1_INPUT_HS_IN_PROGRESS)
        test    [si].s_stDeviceParms.byFlag3,F2_ENABLE_RCV_XON_XOFF_FLOW
        jz      close_end

        test_DeviceFlag1 DEV_FLAG1_RTS_TOG_ENABLED
        jnz     close_end
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,LINE_ST_REG_OFFSET

        IOdelay bx
        mov     cx,10

test_TX_hold_loop::                                                               ; makes it global
        InByteImm
        test    al,LINE_ST_TX_HOLD_EMPTY
        jnz     send_final_Xon
        BlockYield ss, si
        loop    test_TX_hold_loop

send_final_Xon::                                                               ; makes it global
        sub     dx,LINE_ST_REG_OFFSET
        mov     al,[si].s_stDeviceParms.byXonChar
        RTStoggleOn ebx
        OutByteDel bx

close_end:
        dec     wTimerAllocCount
        jnz     close_exit
        mov     ax,OFFSET Timer
        mov     dl,DevHlp_ResetTimer
        call    device_hlp

close_exit:
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,FIFO_CTL_REG_OFFSET
        mov     ax,0c7h
        OutByteDel bx           ; reset FIFOs
        xor     al,al
        OutByteDel bx           ; disable FIFOs

        add     dx,MDM_CTL_REG_OFFSET - FIFO_CTL_REG_OFFSET
        InByteDel bx
        and     al,NOT (MDM_CTL_RTS_ACTIVATE OR MDM_CTL_DTR_ACTIVATE)

        COMscopeStream ebx, CSFUNC_TRACE_MODEM_OUT_SIGNALS, CS_MODEM_OUT
        OutByteDel bx
        mov     bl,[si].s_stDeviceParms.byInterruptLevel
        call    ReleaseInterrupt

        COMscopeStream ebx, CSFUNC_TRACE_OPEN, CS_CLOSE_ONE
        ret

CloseProcess ENDP

InputStatus PROC NEAR

        xor     ax,ax
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_RCV_QUEUE_EMPTY
        jnz     @f
        mov     ax,0100h
@@:
        mov     ES:[di].s_stPacket.PktStatus,ax
        ret

InputStatus ENDP

OutputStatus PROC NEAR

        xor     ax,ax
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_TX_IN_PROGRESS
        jz      @f
        mov     ax,0100h
@@:
        mov     ES:[di].s_stPacket.PktStatus,ax
        ret

OutputStatus ENDP

InputFlush PROC NEAR

        mov     al,0f1h
        COMscopeStream ebx, CSFUNC_TRACE_DEVIOCTL, CS_DEVIOCTL
        cli
        call    FlushInputBuffers
        call    ClearInputHandshake
        sti
        ret

InputFlush ENDP

OutputFlushTrace::                                                               ; makes it global

        mov     al,0f0h
        COMscopeStream ebx, CSFUNC_TRACE_DEVIOCTL, CS_DEVIOCTL

OutputFlush PROC NEAR

        cli
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_TX_IN_PROGRESS
        jz      flush_exit
        mov     dx,[si].s_stDeviceParms.wIObaseAddress
        add     dx,INT_EN_REG_OFFSET
        InByteImm
        and     al,NOT INT_EN_TX_HOLD_EMPTY
        OutByteDel bx
        or      [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_OUTPUT_FLUSHED
        mov     [si].s_stDeviceParms.wWrtTimerCount,0
        test_DeviceFlag1 DEV_FLAG1_WRT_BLOCKED
        jz      flush_exit
        mov     ax,ds
        lea     bx,[si].s_stDeviceParms.dwWrtSemaphore
        mov     dl,DevHlp_SemClear
        call    device_hlp

flush_exit::                                                               ; makes it global
        sti
        ret

OutputFlush ENDP

Peek PROC NEAR

        mov     cx,0100h
        test    [si].s_stDeviceParms.wDeviceStatus1,DEV_ST1_RCV_QUEUE_EMPTY
        jnz     no_byte_in_queue
        mov     ebx,[si].s_stDeviceParms.dwReceiveQueueReadPointer
  IFNDEF x16_BIT
;        test_DeviceFlag2 DEV_FLAG2_USE_DD_DATA_SEGMENT
;        jnz     @f
        mov     al,GS:[ebx]
;        jmp     store_peek
;@@:
  ELSE
        mov     al,bx
  ENDIF
;        mov     al,[ebx]

store_peek::                                                               ; makes it global
        mov     ES:[di].s_stPacket.PktData,al
        xor     cx,cx

no_byte_in_queue::                                                               ; makes it global
        mov     ES:[di].s_stPacket.PktStatus,cx
        ret

Peek ENDP

;------------Strategy Jump Table------------------------------------
; this is here to cause all elements to b a uniform six bytes long
;    (three byte jump instruction)

  EVEN
AuxStrategy::                                                               ; makes it global
        mov     ax,SPECIAL_STRATEGY
        jmp     Strategy

xAuxStrategy::                                                               ; makes it global
        mov     ax,DUMMY_STRATEGY
        jmp     Strategy

__pDeviceStrategy LABEL WORD
Strategy1::                                                               ; makes it global
        mov     ax,0
        jmp     Strategy

Strategy2::                                                               ; makes it global
        mov     ax,1
        jmp     Strategy

Strategy3::                                                               ; makes it global
        mov     ax,2
        jmp     Strategy

Strategy4::                                                               ; makes it global
        mov     ax,3
        jmp     Strategy

Strategy5::                                                               ; makes it global
        mov     ax,4
        jmp     Strategy

Strategy6::                                                               ; makes it global
        mov     ax,5
        jmp     Strategy

Strategy7::                                                               ; makes it global
        mov     ax,6
        jmp     Strategy

Strategy8::                                                               ; makes it global
        mov     ax,7
        jmp     Strategy

Strategy9::                                                               ; makes it global
        mov     ax,8
        jmp     Strategy

Strategy10::                                                               ; makes it global
        mov     ax,9
        jmp     Strategy

Strategy11::                                                               ; makes it global
        mov     ax,10
        jmp     Strategy

Strategy12::                                                               ; makes it global
        mov     ax,11
        jmp     Strategy

Strategy13::                                                               ; makes it global
        mov     ax,12
        jmp     Strategy

Strategy14::                                                               ; makes it global
        mov     ax,13
        jmp     Strategy

Strategy15::                                                               ; makes it global
        mov     ax,14
        jmp     Strategy

Strategy16::                                                               ; makes it global
        mov     ax,15
        jmp     Strategy

__pCOMscopeStrategy LABEL WORD
Strategy1m::                                                               ; makes it global
        mov     ax,08000h
        jmp     Strategy

Strategy2m::                                                               ; makes it global
        mov     ax,08001h
        jmp     Strategy

Strategy3m::                                                               ; makes it global
        mov     ax,08002h
        jmp     Strategy

Strategy4m::                                                               ; makes it global
        mov     ax,08003h
        jmp     Strategy

Strategy5m::                                                               ; makes it global
        mov     ax,08004h
        jmp     Strategy

Strategy6m::                                                               ; makes it global
        mov     ax,08005h
        jmp     Strategy

Strategy7m::                                                               ; makes it global
        mov     ax,08006h
        jmp     Strategy

Strategy8m::                                                               ; makes it global
        mov     ax,08007h
        jmp     Strategy

Strategy9m::                                                               ; makes it global
        mov     ax,08008h
        jmp     Strategy

Strategy10m::                                                               ; makes it global
        mov     ax,08009h
        jmp     Strategy

Strategy11m::                                                               ; makes it global
        mov     ax,0800ah
        jmp     Strategy

Strategy12m::                                                               ; makes it global
        mov     ax,0800bh
        jmp     Strategy

Strategy13m::                                                               ; makes it global
        mov     ax,0800ch
        jmp     Strategy

Strategy14m::                                                               ; makes it global
        mov     ax,0800dh
        jmp     Strategy

Strategy15m::                                                               ; makes it global
        mov     ax,0800eh
        jmp     Strategy

Strategy16m::                                                               ; makes it global
        mov     ax,0800fh
        jmp     Strategy

RES_CODE ENDS

    END
