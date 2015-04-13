;*DDK*************************************************************************/
;
; COPYRIGHT (C) Microsoft Corporation, 1989
; COPYRIGHT    Copyright (C) 1995 IBM Corporation
;
;    The following IBM OS/2 WARP source code is provided to you solely for
;    the purpose of assisting you in your development of OS/2 WARP device
;    drivers. You may use this code in accordance with the IBM License
;    Agreement provided in the IBM Device Driver Source Kit for OS/2. This
;    Copyright statement may not be removed.;
;*****************************************************************************/
;       SCCSID = @(#)atmvdm.asm 6.14 92/03/21
; ***************************************************************************
; *
; *
; *
; ***************************************************************************

;;********************** START OF SPECIFICATIONS *********************
;;*
;;* SOURCE FILE NAME:  ATMVDM.ASM
;;*
;;* DESCRIPTIVE NAME:  PCOM MVDM support Routines
;;*
;;* STATUS: RELEASE 2  LEVEL 0
;;*
;;* FUNCTION: This module contains the main VCOM entry point for
;;*           the COM01.SYS.  Also included are the major subroutines that
;;*           handle the IOCTL and high speed read/write routines for VCOM
;;*           support.
;;*
;;*           For IOCTL support, a semaphore is used to assure the TX Q is
;;*           empty BEFORE allowing the IOCTL to proceed.  The main
;;*           strategy routine (Com_Strat) is called after setting up a
;;*           request packet and all registers.
;;*
;;*           This is the Asyncronous Communcications Device Driver for the
;;*           PS/2 systems.  It is based on the design put forth in DCR 29.
;;*           developed by IBM.
;;*
;;* NOTES:
;;*    DEPENDENCIES: ABIOS MUST BE PRESENT
;;*    RESTRICTIONS: Supports only COM1 and COM2 handles
;;*    PATCH LABEL:  0
;;*
;;* ENTRY POINTS:  PCOMEntryVDM, PCOMStackEntry
;;*
;;* EXTERNAL REFERENCES:
;;*
;;*
;;*********************** END OF SPECIFICATIONS **********************
;
;
;       Modification History
;
;       ACW     04/16/91        @PVW Added perfview counters/timers
;       YN      08/28/91        CP20PB726006
;       DJB     08/10/93        @DB70730 - Clear out packet status field before
;                               calling ComStrat on open call
;       WDM     04/21/94        82548 - pvwxport.inc now included in atcom.inc
;

;
;  82548   include pvwxport.inc            ;@PVW
include atcom.inc
.xlist
include devhlp.inc
include devsym.inc
include basemaca.inc
include oldmaca.inc
include error.inc
include infoseg.inc
include filemode.inc
include gas.inc
.list

        extrn   Com1:word
        extrn   Com2:word
        extrn   Rx_Notify:near
        extrn   Tx_Notify:near
        extrn   Ms_Notify:near
        extrn   ProcBlock:near
        extrn   CheckTX:near
        extrn   ComputeWTO:near
        extrn   ComputeRTO:near

EXTRN   Rx_Notify:NEAR
EXTRN   Tx_Notify:NEAR
EXTRN   Ms_Notify:NEAR

EXTRN   ProcBlock:NEAR
EXTRN   CheckTX:NEAR
EXTRN   ComputeWTO:NEAR
EXTRN   ComputeRTO:NEAR

EXTRN   Com1Strat:FAR
EXTRN   Com2Strat:FAR
EXTRN   Com3Strat:FAR
EXTRN   Com4Strat:FAR

EXTRN   Com1:WORD
EXTRN   Com2:WORD
EXTRN   Com3:WORD
EXTRN   Com4:WORD

EXTRN   VCOMAddress:FAR

CSEG    SEGMENT
        ASSUME cs:CSEG
;;********************** START OF SPECIFICATIONS *********************
;;*
;;* SUBROUTINE NAME: PCOMEntryVDM
;;*
;;* DESCRIPTIVE NAME: Communication Device Driver VCOM Service Entry Point
;;*
;;* FUNCTION:  This entry point is used by the VCOM to communicate with the
;;*      Async hardware via this device driver.  VCOM calls this entry point
;;*      to write data to the hardware, read data from the hardware and to
;;*      otherwise manipulate the hardware (setup, reset, etc.)
;;*
;;*      On entry to this routine, the command type is checked and a call
;;*      is made to either the service routine (VDMWriteByte or VDMReadByte) or the
;;*      main IOCTL entry point (ComStrat).
;;*
;;* NOTES:       ABIOS MUST BE PRESENT
;;*
;;* ENTRY POINTS:  PCOMEntryVDM
;;*
;;* LINKAGE:     Far 16:32
;;*
;;* INPUT:  AX    = command
;;*         Dl    = port number
;;*         Bx, Cx are defined on a per command basis
;;*         ES:Si = pointer to input data
;;*         ES:Di = pointer to output data
;;*
;;* OUTPUT: command based
;;*
;;*         if AX = 1    (Open Port)
;;*            Dl = port number
;;*            CX = 0    if normal open
;;*            CX = 1    if no IRQ open
;;*
;;*         returns:
;;*            AX = 0 if no error
;;*            AX = 1 if general error (Protect mode conflict)
;;*            AX = 2 if Com in use by a different DD (cannot get LID)
;;*            AX = 3 if Com not installed
;;*
;;*
;;*         if AX = 2    (Close Port)
;;*            Dl = port number
;;*
;;*         returns:
;;*            AX = error, if any (0 if no error)
;;*
;;*
;;*         if AX = 3    (Get Byte)
;;*            Dl = port number
;;*
;;*         returns:
;;*            Ah = character
;;*            Al = character's LSR
;;*            Cl = more data indicator (1 - MORE_TO_COME)
;;*
;;*
;;*         if AX = 4  (Put Byte)
;;*            Dl = port number
;;*            Bl = character
;;*
;;*         returns:
;;*            Cl = more room indicator
;;*                 Bit 0 : more room in TxQueue (1 - TRUE)
;;*                 Bit 1 - 7 Reserved, set to 0
;;*
;;*
;;*         if AX = 5    (Get DLL/DLM value)
;;*            Dl = port number
;;*
;;*         returns:
;;*            Cl = DLL value
;;*            Ch = DLM value
;;*
;;*
;;*         if AX = 6    (Put DLL/DLM value)
;;*            Dl = port number
;;*            Cl = DLL value
;;*            Ch = DLM value
;;*
;;*         returns:
;;*            none
;;*
;;*
;;*         if AX = 46h  (Set MCR)
;;*            Dl = port number
;;*         ES:Si = pointer to input data
;;*         ES:Di = pointer to output data
;;*
;;*         command specific input data:
;;*
;;*            DB        Mask on
;;*            DB        Mask off
;;*
;;*         returns:
;;*         (command specific output data)
;;*            DW        COM Error code
;;*
;;*
;;*         if AX = 42h  (Set LCR)
;;*            Dl = port number
;;*         ES:Si = pointer to input data
;;*         ES:Di = pointer to output data
;;*
;;*         command specific input data:
;;*            DW        Number of data bits
;;*                DW    Parity
;;*                     DW       Stop bits
;;*
;;*             returns:
;;*             (command specific output data)
;;*                     none
;;*
;;*
;;*             if AX = 4Bh  (Set Break ON)
;;*                     Dl = port number
;;*             ES:Si = pointer to input data
;;*             ES:Di = pointer to output data
;;*
;;*         command specific input data:
;;*            None
;;*
;;*         returns:
;;*         (command specific output data)
;;*            DW        COM Error code
;;*
;;*
;;*         if AX = 45h  (Set Break OFF)
;;*            Dl = port number
;;*         ES:Si = pointer to input data
;;*         ES:Di = pointer to output data
;;*
;;*         command specific input data:
;;*            None
;;*
;;*         returns:
;;*         (command specific output data)
;;*            DW        COM Error code
;;*
;;*
;;*         if AX = 62h  (Get LCR value)
;;*            Dl = port number
;;*         ES:Si = pointer to input data
;;*         ES:Di = pointer to output data
;;*
;;*         command specific input data:
;;*            none
;;*
;;*         returns:
;;*         (command specific output data)
;;*            DB        Data bits
;;*            DB        Parity
;;*            DB        Stop Bits
;;*            DB        Transmitting Break
;;*
;;*
;;*         if AX = 66h  (Get MCR value)
;;*            Dl = port number
;;*         ES:Si = pointer to input data
;;*         ES:Di = pointer to output data
;;*
;;*         command specific input data:
;;*            none
;;*
;;*         returns:
;;*         (command specific output data)
;;*            DB        MCR bits 0 and 1 (DTR and RTS)
;;*                      MCR bits 2 to 7 are undefined
;;*
;;*
;;*         if AX = 67h  (Get MSR value)
;;*            Dl = port number
;;*         ES:Si = pointer to input data
;;*         ES:Di = pointer to output data
;;*
;;*         command specific input data:
;;*            none
;;*
;;*         returns:
;;*         (command specific output data)
;;*            DB        MSR value
;;*                      Bits 0 to 3     undefined
;;*                      Bit 4           Clear to send (CTS)
;;*                      Bit 5           Data set ready (DSR)
;;*                      Bit 6           Ring indicator (RI)
;;*                      Bit 7           Data carrier detect (DCD)
;;*
;;*
;;* EXIT-NORMAL: AX = 0
;;*
;;* EXIT_ERROR:  AX = 1
;;*
;;* EFFECTS:
;;*      ComInfo - Data Structure for a Com port
;;*      Request Packet - Request packet for a Async Device Driver function
;;*
;;* INTERNAL REFERENCES:
;;*      Com1Strat and Com2Strat to process IOCTL commands
;;*      VDMWriteByte                           to write 1 character
;;*      VDMReadByte                           to read 1 character
;;*      VDMGetDLLDLM                    to return the DLL/DLM values
;;*      VDMSetDLLDLM                    to update the DLL/DLM values
;;*      Rx_Notify                       to see if an RX Interrupt should be
;;*                                      reflected at this time (was defered)
;;*      Tx_Notify                       to see if a TX Interrupt should be
;;*                                      reflected at this time (was defered)
;;*      INT_Notify              Macro to see if a TX or RX Interrupt should
;;*                                    be reflected at this time (was defered)
;;*
;;* EXTERNAL REFERENCES:
;;*      DevHlp_SemClear  - release the system semaphore
;*
;;*********************** END OF SPECIFICATIONS **********************
;
;
;PCOMEntryVDM:
Procedure PCOMEntryVDM,FAR
;
;    Save all used registers (except AX)
        .386
        SaveReg <esi,edi,es,ds,ebx,edx,ebp>
        .286
;
;    Get DS addressability
        setDS   DSEG
;
;    Select (Command type)
;
;        Case (Get Byte - 3):
pev060:
        cmp     ax,3
        jne     pev080
;            get correct ComInfo (DL = Port Number)
        call    DLtoComInfo
ifdef PERFVIEW
        pvw_Read START                  ;@PVW start timer
endif
;            call VDMReadByte           ; get byte and status from Rx queues
;       NOTE:   Exits with interrupts disabled to not cause reentrancy
;               problems in VCOM
        call    VDMReadByte
ifdef PERFVIEW
        pvw_Read STOP,VDMCOUNTERS       ;@PVW stop timer, inc num_reads,
endif
                                        ;@PVW update bytes read
;            Break
        jmp     pev200
;
;        Case (Put Byte - 4):
pev080:
        cmp     ax,4
        jne     pev020
;            get correct ComInfo (DL = Port Number)
        call    DLtoComInfo
ifdef PERFVIEW
        pvw_Write START                 ;@PVW start timer
endif
;            call VDMWriteByte          ; put byte at end of Tx queue
        call    VDMWriteByte
;            call Rx_Notify             ; see if Rx int should be reflected
        call    Rx_Notify
ifdef PERFVIEW
        pvw_Write STOP,VDMCOUNTERS      ;@PVW stop timer, inc num_writes,
endif
                                        ;@PVW update bytes written
;            Break
        jmp     pev200
;
;        Case (Open Port - 1):
pev020:
        cmp     ax,1
        ljne    pev040
;            get correct ComInfo (DL = Port Number)
        call    DLtoComInfo
;            IF (ComInfo != 0)
        or      si,si
        jz      pev033
;            THEN
;                IF (OpenCount != 0)     ; see if port already in use
;       cmp     [si].ci_nopens,0
;       je      pev030                   ;|----Fix for CP20PB726384
;                THEN                    ;|
;                    AX = 1              ; VDM-Protect mode app conflict
;       mov     ax,1                     ;|
;       jmp     pev035                   ;|----Fix for CP20PB726384
;                ELSE
pev030:
;                    ComInfo.VDM_flag.InUse = TRUE
        or      [si].ci_vdm_flag,VDM_Flag_InUse
        cmp     cx,0
        je      pev031
        or      [si].ci_vdm_flag,VDM_Flag_No_IRQ_Open
pev031:
;                    Fill in Request packet
        mov     [si].ci_req_pack.IPcommand,Open_Command
        mov     [si].ci_req_pack.IPlen,req_Header+2
        mov     [si].ci_req_pack.PktStatus,0                    ; @DB70730 - Clear out the status field
;                    Set correct parameters for call (ES:BX -> Packet)
        cli
        push    ax
        mov     al,[si].ci_dcb_flags1
        and     al,NOT F1_OUT_DCD_FLOW  ; ODCD=OFF
        mov     [si].ci_dcb_flags1,al
        pop     ax
        sti
        push    ds
        pop     es
        lea     bx,[si].ci_req_pack
;                    call (FAR) ComStrat            ; call strategy routine
        Call_Strat
;                    AX = 0                         ; set AX to NO ERROR
        mov     ax,0
;                  IF Request_packet.status = error ; if an open error occurred
        cmp     [si].ci_req_pack.IPstatus,0
        jne      pev035
;                    THEN
;                        AX = ComInfo.VDM_OpenError  ; set the error code
        mov     ax,[si].ci_vdm_OpenError
;                    ENDIF
;                ENDIF
        jmp     short pev035
;            ELSE
pev033:
;                AX = COMx_NOT_INSTALLED (3)
        mov     ax,3                            ; COMx not installed
;            ENDIF
pev035:
;
        cmp     [si].ci_req_pack.IPstatus,STDON OR STERR OR ERROR_I24_GEN_FAILURE
        jne     pev036
        mov     ax,2

pev036:
        cmp     [si].ci_req_pack.IPstatus,STDON OR STERR OR ERROR_I24_DEVICE_IN_USE
        jne     pev037
        mov     ax,2

pev037:
;            Break
        jmp     pev200
;
;        Case (Close Port - 2):
pev040:
        cmp     ax,2
        ljne     pev100
;            get correct ComInfo (DL = Port Number)
        call    DLtoComInfo
;       set TX/RX to state 1 and enable transmit to empty TX buffer
        mov     [si].ci_vdm_Tx_State,1
        mov     [si].ci_vdm_Rx_State,1
        cli                             ;@@ disable
        call    CheckTX                 ; start Tx if conditions permit........

;            Fill in IOCTL Request packet
        lea     di,[si].ci_req_pack     ; make ES:DI -> req packet for block
        mov     ax,ds
        mov     es,ax
        mov     es:[di].IPcommand,Close_Command
        mov     es:[di].IPlen,req_Header+2
        mov     cx,VDM_TERM_TIMEOUT     ; (dx:cx) = time out
        xor     dx,dx

;            IF (Tx Queue not empty)
        cli
        mov     ax,[si].ci_qout.ioq_count ; ax = size of output queue
        cmp     ax,0
        je      pev041                  ; user data in queue, request not done
;            THEN
;                Block this request
        mov     [si].ci_vdm_Blocked_IOCTL._hi,es
        mov     [si].ci_vdm_Blocked_IOCTL._lo,di
        or      [si].ci_vdm_flag,VDM_Flag_Blocked_IOCTL
        call    ProcBlock
;            ENDIF
pev041:

        sti
;            Set correct parameters for call (ES:BX -> IOCTL Packet)
        mov     bx,di

;PB732220   force cleanup for this port
        mov     [si].ci_nopens,1             ; Per request of Phil Doragh to
                                             ; restore the line
;            call (FAR) ComStrat             ; call strategy routine
        Call_Strat
;            ComInfo.vdm_flag.InUse = FALSE
        and     [si].ci_vdm_flag,NOT VDM_Flag_InUse
        and     [si].ci_vdm_flag,NOT VDM_Flag_No_IRQ_Open
;            IF Request_pack.status = error
        cmp     [si].ci_req_pack.IPstatus,0
        jne     pev058
;            THEN
;                AX = 1
        mov     ax,1
        jmp     short pev059
;            ELSE
pev058:
;                AX = 0
        mov     ax,0
;            ENDIF
pev059:
;            Break
        jmp     pev200
;
;        Case (Get DLL/DLM - 5):
pev100:
        cmp     ax,5
        jne     pev120
;            get correct ComInfo (DL = Port Number)
        call    DLtoComInfo

        call    WaitForOutPut           ; wait for TX queue to empty

;            call VDMGetDLLDLM           ; get DLL/DLM from hardware
        call    VDMGetDLLDLM
;            INT_Notify          ; Macro to see if any ints should be relected
        INT_Notify
;            Break
        jmp     pev200
;
;        Case (Set DLL/DLM - 6):
pev120:
        cmp     ax,6
        jne     pev140
;            get correct ComInfo (DL = Port Number)
        call    DLtoComInfo

        call    WaitForOutPut           ; wait for TX queue to empty

;            call VDMSetDLLDLM           ; set DLL/DLM in hardware
        call    VDMSetDLLDLM
;            INT_Notify          ; Macro to see if any ints should be relected
        INT_Notify
;            Break
        jmp     pev200
;
pev140:
;            get correct ComInfo (DL = Port Number)
        mov     bx,si
        call    DLtoComInfo
;            Fill in IOCTL Request packet
;                    (Data Pointer, Parameter Pointer)
        Fill_IOCTL      es,di,es,bx
;        Case (IOCTL Set LCR       - 42h):
        cmp     ax,42h
        jne      pev141
;            Set data pointer to NULL
        Set_Data        NULL,NULL
        jmp     pev160
pev141:
;        Case (IOCTL Set Break OFF - 45h):
        cmp     ax,45h
        jne      pev142
;            Set parameter pointer to NULL
        Set_Para        NULL,NULL
        jmp     pev160
pev142:
;        Case (IOCTL Set MCR       - 46h):
        cmp     ax,46h
        jne      pev143
        jmp     pev170          ;BUGBUG don't worry about TX Q
;       jmp     pev160
pev143:
;        Case (IOCTL Set Break ON  - 4Bh):
        cmp     ax,4bh
        jne      pev144
;            Set parameter pointer to NULL
        Set_Para        NULL,NULL
        jmp     pev160
pev144:
;        Case (IOCTL Get LCR       - 62h):
        cmp     ax,62h
        jne      pev145
;            Set parameter pointer to NULL
        Set_Para        NULL,NULL
        jmp     short pev160
pev145:
;        Case (IOCTL Get MCR       - 66h):
        cmp     ax,66h
        jne      pev146
;            Set parameter pointer to NULL
        Set_Para        NULL,NULL
        jmp     short pev160
pev146:
;        Case (IOCTL Get MSR       - 67h):
        cmp     ax,67h
        ljne     pev180
;            Set parameter pointer to NULL
        Set_Para        NULL,NULL
pev160:
        ; wait for TX queue to empty
        call    WaitForOutPut
pev170:
;            Set correct parameters for call (ES:BX -> IOCTL Packet)
        mov     bx,ds
        mov     es,bx
        lea     bx,[si].ci_req_pack
;            call (FAR) ComStrat             ; call strategy routine
        Call_Strat
;            IF Request_packet.status = error
        cmp     [si].ci_req_pack.IPstatus,0
        jne     pev178
;                AX = 1
        mov     ax,1
        jmp     short pev179
;            ELSE
pev178:
;                AX = 0
        mov     ax,0
;            ENDIF
pev179:
;            INT_Notify          ; Macro to see if any ints should be relected
        INT_Notify
;            Break
        jmp     pev200
;
;        default:                                ; Invalid function
pev180:
;            AX = 1
        mov     ax,1
;            Break
;       jmp     pev200
;
;    ENDSelect
pev200:
;
;    Restore all used registers (does not include AX)
        .386
        RestoreReg <ebp,edx,ebx,ds,es,edi,esi>
        .286
;
;    RETURN
        db      66h
        ret
;
;END PCOMEntryVDM
EndProc PCOMEntryVDM
;
;;********************** START OF SPECIFICATIONS *********************
;;*
;;*  SUBROUTINE NAME:    VDMWriteByte
;;*
;;*  DESCRIPTIVE NAME:   Fast VDM write byte routine
;;*
;;*  STATUS: RELEASE 2  LEVEL 0
;;*
;;*  FUNCTION:
;;*
;;*  NOTES:  none
;;*
;;*  ENTRY POINTS:   VDMWriteByte
;;*
;;*  LINKAGE:    NEAR
;;*
;;*  USES:
;;*
;;*  INPUT:      AX = 4,  DL = port number, BL = character, pointer to ComInfo
;;*
;;*  OUTPUT:     CL = more room indicator
;;*
;;*  EXIT-NORMAL:  NONE
;;*
;;*  EXIT_ERROR:   NONE
;;*
;;*  EFFECTS:
;;*
;;*  INTERNAL REFERENCES:
;;*
;;*  EXTERNAL REFERENCES:  none
;;*
;;*********************** END OF SPECIFICATIONS **********************
;
;VDMWriteByte:
Procedure VDMWriteByte,near
;
        cli

; Do state updates

;   IF (ComInfo.VDM_Rx_state == 3)       ; are we in receive state 3
        cmp     [si].ci_vdm_Rx_State,3
        jne     vwb020
;   THEN                                 ; yes, increment count
;       ComInfo.VDM_Tx_count = ComInfo.VDM_Tx_count + 1
        inc     [si].ci_vdm_Tx_Count
;       IF (ComInfo.VDM_Tx_count == 16)
        cmp     [si].ci_vdm_Tx_Count,VDM_Max_Tx_Count
        jne     vwb020
;       THEN                             ; 16 chars sent, yes
;           ComInfo.VDM_Tx_count = 0     ; goto receive state 1
        mov     [si].ci_vdm_Tx_Count,0
;           ComInfo.VDM_Rx_state = 1
        mov     [si].ci_vdm_Rx_State,1
;       ENDIF
;   ENDIF
vwb020:
;   IF (character == XOFF)               ; was this an XOFF?
        cmp     cl,XOFFequ
        jne     vwb030
;   THEN                                 ; yes - XOFF
;     IF (ComInfo.VDM_Tx_state != 3)     ; are we in state 3 ?
        cmp     [si].ci_vdm_Tx_State,3
        je      vwb040
;     THEN                               ; no
;       ComInfo.VDM_Tx_state = 2         ; goto transmit state 2
        mov     [si].ci_vdm_Tx_State,2
        jmp     vwb040
;     ENDIF
;   ELSE
vwb030:                                  ; not XOFF
;   ComInfo.VDM_Tx_state = 1             ; set transmit state 1
        mov     [si].ci_vdm_Tx_State,1
;   ComInfo.VDM_Rx_count = 0
        mov     [si].ci_vdm_Rx_Count,0
;   ENDIF
vwb040:

; see if we can transmit character immediately

        jmp     SHORT vwb011

        ; The following block of code causes instablility and timing problem.

        cmp     [si].ci_qout.ioq_count,0
        jnz     vwb011          ; if queue not empty, go queue

        ; check handshaking for busy
        mov     cl,[si].ci_msrshadow    ; (al) = msrshadow
        and     cl,[si].ci_outhhslines  ; mask bits of interest
        cmp     cl,[si].ci_outhhslines
        jne     vwb011                  ; modem lines down, go queue

        cmp     [si].ci_vdm_rx_state,1  ; are we in state 1?
        jne     vwb011                  ; no, go queue

        push    ax              ; save current values
        push    dx

        ; check at the hardware for busy
        mov     dx,[si].ci_port ; get port address

        add     dx,R_INTEN      ; get to IER
        in      al,dx
        test    al,IE_TX
        jnz     vwb010          ; if tx ints are on, go queue

        add     dx,R_LINES-R_INTEN ; get to LSR
        in      al,dx
        test    al,LS_THRE
        jz      vwb010          ; if THRE not empty, go queue

; The queue is empty, the lines are good and the chip is free so send the data.
        add     dx,R_DATA-R_LINES ; get to RBR
        mov     al,bl           ; get character
        out     dx,al           ; its out-a-here!

        pop     dx
        pop     ax

        jmp     vwb013          ; check for more room and return

vwb010:                         ; restore regs
        pop     dx
        pop     ax
vwb011:

;   Add character to end of Tx Queue

        mov     cl,bl
        mov     bx,[si].ci_qout.ioq_in
        inc     bx                              ; adjust in pointer
        cmp     bx,[si].ci_qout.ioq_out
        je      vwb050                          ; (in + 1) == out
        dec     bx
        mov     [bx],cl                         ; put byte in queue
        inc     bx
        cmp     bx,[si].ci_qout.ioq_end
        jne     vwb012                          ; did not wrap

        mov     bx,[si].ci_qout.ioq_base        ; wrapped

vwb012:

        mov     [si].ci_qout.ioq_in,bx           ; update in pointer
        inc     [si].ci_qout.ioq_count           ; adjust count

        call    CheckTX                 ; start Tx if conditions permit........
        cli                             ;@@ disable

vwb013:
;   CL = 1                               ; more room
        mov     cl,1
;   IF (ComInfo.VDM_Rx_state != 1) OR
        cmp     [si].ci_vdm_Rx_State,1
        jne     vwb050
;      (NO more room in TX QUEUE)
        mov     ax,[si].ci_qout.ioq_count       ; ax = size of output queue
        cmp     ax,QO_SIZE-VDM_Delta_QO_SIZE
        jl      vwb060
;   THEN
vwb050:
;       CL = 0                           ; NO more room
        mov     cl,0
;       ComInfo.vdm_flag.notify_the_VCOM_Tx = TRUE
        or      [si].ci_vdm_flag,VDM_Flag_notify_the_VCOM_TX
;   ENDIF
vwb060:
;
;   RETURN                               ; to PCOMEntryVDM

        ret
;
;END  VDMWriteByte
EndProc  VDMWriteByte
;
;;********************** START OF SPECIFICATIONS *********************
;;*
;;*  SUBROUTINE NAME:    VDMReadByte
;;*
;;*  DESCRIPTIVE NAME:   Fast VDM read byte routine
;;*
;;*  STATUS: RELEASE 2  LEVEL 0
;;*
;;*  FUNCTION:
;;*
;;*  NOTES:  none
;;*
;;*  ENTRY POINTS:   VDMReadByte
;;*
;;*  LINKAGE:    NEAR
;;*
;;*  USES:
;;*
;;*  INPUT:      AH = 3,  DL = port number, pointer to ComInfo
;;*
;;*  OUTPUT:     AH = character, AL = this character's LSR,
;;*              CL = more data indicator (bit 0 - physical, bit 1 - logical)
;;*
;;*  EXIT-NORMAL:  NONE
;;*
;;*  EXIT_ERROR:   NONE
;;*
;;*  EFFECTS:   Exits with interrupts disabled !!!!!!!!!
;;*
;;*  INTERNAL REFERENCES:
;;*
;;*  EXTERNAL REFERENCES:  none
;;*
;;*********************** END OF SPECIFICATIONS **********************
;
;VDMReadByte:
Procedure VDMReadByte,near
;
;   Get character from front of Rx Queue into AH
        cli
        mov     bx,[si].ci_qin.ioq_out
        cmp     bx,[si].ci_qin.ioq_in
;       stc                                     ; assume the queue is empty
        push    ax                              ;PB73220
        je      vrb040                          ; queue is empty (out == in)
        pop     ax                              ;PB73220

vrb05:  mov     ah,[bx]                         ; (ah) = byte
        push    bx                              ; save the addr
        dec     [si].ci_qin.ioq_count           ; adjust count
        jnz     vrb10                           ; didn't take last char

vrb10:  inc     bx                              ; adjust out pointer
        cmp     [si].ci_qin.ioq_end,bx          ; clears carry (end >= bx)
        jne     vrb20                           ; did not hit end of queue

         ; Hit the end of the queue, wrap out pointer (out == base).

        mov     bx,[si].ci_qin.ioq_base         ; (bx) = base of queue
vrb20:  mov     [si].ci_qin.ioq_out,bx          ; reset the output pointer

;   Get LSR from front of Rx Status Queue into AL
        pop     bx
        sub     bx,[si].ci_qin.ioq_base
        mov     al,[si+bx].ci_qstat
        sti
;   check for MS interrupts
        push    ax
        call    MS_notify
        pop     ax
        push    ax                       ; save data
;   IF (ComInfo.VDM_Rx_state == 2) AND   ; are we in receive state 2 and
        cli                              ;CP20PB726006 Cannot have int while changing status
        cmp     [si].ci_vdm_Rx_State,2
        jne     vrb020
;      (Character == XOFF) AND           ; is this XOFF character and
        cmp     ah,XOFFequ
        jne     vrb020
;      (Character's LSR == 0) AND        ; is this character valid and
        test    al,LS_OERR+LS_PERR+LS_FERR+LS_BI ;CP20PB726006
        jnz     vrb020
;      (Tx queue not empty)              ; is the transmit Q not empty
        mov     ax,[si].ci_qout.ioq_count       ; ax = size of output queue
        cmp     ax,0
        je      vrb015
;   THEN                                 ; yes
;       ComInfo.VDM_Rx_state = 3         ; goto receive state 3
        mov     [si].ci_vdm_Rx_State,3
        jmp     short   vrb020
;   ELSE
vrb015:
;       ComInfo.VDM_Rx_state = 1         ; go back to receive state 1
        mov     [si].ci_vdm_Rx_State,1
        mov     [si].ci_vdm_Tx_Count,0
;   ENDIF
vrb020:
;   IF (more data in Rx QUEUE) AND
        cli                              ;CP20PB726006 Cannot have int while changing status
        mov     ax,[si].ci_qin.ioq_count       ; ax = size of input queue
        cmp     ax,0
        jz      vrb040
;      (ComInfo.VDM_Tx_state == 1)
        cmp     [si].ci_vdm_Tx_State,1
        jne         vrb040
;   THEN
;       CL = 1                           ; queue not empty
        mov     cl,1
        jmp     short vrb060
;   ELSE
vrb040:
;       CL = 0                           ; NO more data
        mov     cl,0
;       ComInfo.vdm_flag.notify_the_VCOM_Rx = TRUE
        or      [si].ci_vdm_flag,VDM_Flag_notify_the_VCOM_RX
;   ENDIF
vrb060:
;
;   RETURN                                       ; to PCOMEntryVDM
        pop     ax                      ; restore data
        ret
;
;END  VDMReadByte
EndProc  VDMReadByte
;
;;********************** START OF SPECIFICATIONS *********************
;;*
;;*  SUBROUTINE NAME:    VDMGetDLLDLM
;;*
;;*  DESCRIPTIVE NAME:        Get the DLL and DLM registers routine
;;*
;;*  STATUS: RELEASE 2  LEVEL 0
;;*
;;*  FUNCTION:
;;*
;;*  NOTES:  none
;;*
;;*  ENTRY POINTS:   VDMGetDLLDLM
;;*
;;*  LINKAGE:    NEAR
;;*
;;*  USES:
;;*
;;*  INPUT:      AH = 3,  DL = port number, pointer to ComInfo
;;*
;;*  OUTPUT:     CL = DLL, CH = DLM
;;*
;;*  EXIT-NORMAL:  NONE
;;*
;;*  EXIT_ERROR:   NONE
;;*
;;*  EFFECTS:
;;*
;;*  INTERNAL REFERENCES:
;;*
;;*  EXTERNAL REFERENCES:  none
;;*
;;*********************** END OF SPECIFICATIONS **********************
;
;VDMGetDLLDLM:
Procedure VDMGetDLLDLM,near
;
;   read current DLL value into CL
;   read current DLM value into CH

;** IBMIBM *** disable here to prevent interrupts while going direct to hw

        pushf                           ; save flags for later
        cli                             ; DISABLE PROCESSOR INTERRUPTS
        mov     dx,[si].ci_port
        add     dx,R_LINEC              ; (dx) -> LCR
        in      al,dx                   ; (al) = current value of LCR
        mov     ah,al                   ; save original state of LCR
        or      al,LC_DLAB              ; turn on DLAB
        out     dx,al

; Set divisor-latch value.
; (dx) -> R_LINEC

        add     dx,R_BAUDH-R_LINEC      ; (dx) -> MSB of baud latch
        in      al,dx                   ; get MSB of baud latch
        mov     ch,al                   ; (al) = divisor latch MSB
        dec     dx                      ; (dx) -> LSB of baud latch
        in      al,dx                   ; get LSB of baud latch
        mov     cl,al                   ; (al) = divisor latch LSB

; Restore original state of LCR (turn off DLAB)
; (dx) -> R_BAUDL

        add     dx,R_LINEC-R_BAUDL      ; (dx) -> LCR
        mov     al,ah                   ; (al) = original state of LCR
        out     dx,al

;** IBMIBM *** time to re-enable
        popf                            ; restore flags

;
;   RETURN                                       ; to PCOMEntryVDM
        ret
;
;END  VDMGetDLLDLM
EndProc  VDMGetDLLDLM
;
;;********************** START OF SPECIFICATIONS *********************
;;*
;;*  SUBROUTINE NAME:    VDMSetDLLDLM
;;*
;;*  DESCRIPTIVE NAME:   Set the DLL and DLM registers routine
;;*
;;*  STATUS: RELEASE 2  LEVEL 0
;;*
;;*  FUNCTION:
;;*
;;*  NOTES:  none
;;*
;;*  ENTRY POINTS:   VDMSetDLLDLM
;;*
;;*  LINKAGE:    NEAR
;;*
;;*  USES:
;;*
;;*  INPUT:      AH = 3,  DL = port number, pointer to ComInfo
;;*              CL = DLL, CH = DLM
;;*
;;*  OUTPUT:     NONE
;;*
;;*  EXIT-NORMAL:  NONE
;;*
;;*  EXIT_ERROR:   NONE
;;*
;;*  EFFECTS:
;;*
;;*  INTERNAL REFERENCES:
;;*
;;*  EXTERNAL REFERENCES:  none
;;*
;;*********************** END OF SPECIFICATIONS **********************
;
;VDMSetDLLDLM:
Procedure VDMSetDLLDLM,near
;
;   put CL into DLL
;   put CH into DLM
                                        ; if CX is 0 or 1, then the baud rate
        cmp     cx,1                    ; is too high, unsupported.  It will
        jbe     setdd100                ; not fit in a word, and the DIV below
                                        ; will cause a TRAP 0

;** IBMIBM *** disable here to prevent interrupts while going direct to hw

        call    DLtoComInfo
        pushf                           ; This did not exist here before
        cli                             ; DISABLE PROCESSOR INTERRUPTS
        mov     [si].ci_fifobaud,cx     ; store latch values in cominfo

        mov     dx,[si].ci_port
        add     dx,R_LINEC              ; (dx) -> LCR
        min     al,dx                   ; (al) = current value of LCR
        mov     ah,al                   ; save original state of LCR
        or      al,LC_DLAB              ; turn on DLAB
        mout    dx,al

; Set divisor-latch value.
; (dx) -> R_LINEC

        add     dx,R_BAUDH-R_LINEC      ; (dx) -> MSB of baud latch
        mov     al,ch                   ; (al) = divisor latch MSB
        mout    dx,al
        dec     dx                      ; (dx) -> LSB of baud latch
        mov     al,cl                   ; (al) = divisor latch LSB
        mout    dx,al                   ; set LSB of baud latch

; Restore original state of LCR (turn off DLAB)
; (dx) -> R_BAUDL

        add     dx,R_LINEC-R_BAUDL      ; (dx) -> LCR
        mov     al,ah                   ; (al) = original state of LCR
        mout    dx,al

        savereg <ax,dx>
        mov     dx,CLOCK_RATEHI         ; Get clock rate in dx:ax
        mov     ax,CLOCK_RATELO         ; 
        div     cx                      ; 
        mov     bx,ax                   ; bx = baud
        mov     [si].ci_baud,ax         ; ci_baud = baud
        restorereg <dx,ax>

        call    ComputeWTO              ; re-compute write timeout value
        call    ComputeRTO              ; re-compute read  timeout value

setdd90:
        popf                            ; used to be sti here
setdd100:
;
;   RETURN                              ; to PCOMEntryVDM
        ret
;
;END  VDMSetDLLDLM
EndProc  VDMSetDLLDLM
;
;;********************** START OF SPECIFICATIONS *********************
;;*
;;*  SUBROUTINE NAME:    DLtoComInfo
;;*
;;*  DESCRIPTIVE NAME:   Sets DS:SI to point to the correct ComInfo
;;*                      based on DL (0, 1 or 2)
;;*
;;*  STATUS: RELEASE 2  LEVEL 0
;;*
;;*  FUNCTION:
;;*
;;*  NOTES:  none
;;*
;;*  ENTRY POINTS:   DLtoComInfo
;;*
;;*  LINKAGE:    NEAR
;;*
;;*  USES:
;;*
;;*  INPUT:      DL = port number
;;*
;;*  OUTPUT:     DS:SI -> ComInfo for this port
;;*
;;*  EXIT-NORMAL:  NONE
;;*
;;*  EXIT_ERROR:   NONE
;;*
;;*  EFFECTS:
;;*
;;*  INTERNAL REFERENCES:
;;*
;;*  EXTERNAL REFERENCES:  none
;;*
;;*********************** END OF SPECIFICATIONS **********************

Procedure DLtoComInfo,near

        cmp     dl,0                        ; if DL == 0, then SI -> Com1
        jne     DLtoComInfo2
        mov     si,Com1                     ; (DS:SI) -> COM1 info
        jmp     SHORT DLtoComInfo_ret

DLtoComInfo2:
        cmp     dl, 1                       ; if DL == 1, then SI -> Com2
        jne     DLtoComInfo3
        mov     si, Com2                    ; (DS:SI) -> COM2 info
        jmp     SHORT DLtoComInfo_ret

DLtoComInfo3:
        cmp     dl, 2                       ; if DL == 2, then SI -> Com3
        jne     DLtoComInfo4
        mov     si, Com3                    ; (DS:SI) -> COM3 info
        jmp     SHORT DLtoComInfo_ret

DLtoComInfo4:
        mov     si, Com4                    ; (DS:SI) -> COM4 info

DLtoComInfo_ret:
        ret

EndProc  DLtoComInfo

;
;;********************** START OF SPECIFICATIONS *********************
;;*
;;*  SUBROUTINE NAME:    WaitForOutPut
;;*
;;*  DESCRIPTIVE NAME:   Waits for TX queue to empty
;;*
;;*  STATUS: RELEASE 2  LEVEL 0
;;*
;;*  FUNCTION:
;;*
;;*  NOTES:  none
;;*
;;*  ENTRY POINTS:   WaitForOutPut
;;*
;;*  LINKAGE:    NEAR
;;*
;;*  USES:
;;*
;;*  INPUT:      DS:SI -> ComInfo for this port
;;*              ES:DI = ID to block on
;;*              dx:cx = time out value
;;*
;;*  OUTPUT:     None
;;*
;;*  EXIT-NORMAL:  NONE
;;*
;;*  EXIT_ERROR:   NONE
;;*
;;*  EFFECTS:
;;*
;;*  INTERNAL REFERENCES:
;;*
;;*  EXTERNAL REFERENCES:  none
;;*
;;*********************** END OF SPECIFICATIONS **********************

Procedure WaitForOutPut,near

        push    ax
;            IF (Tx Queue not empty)
        cli
        mov     ax,[si].ci_qout.ioq_count ; ax = size of output queue
        cmp     ax,0
        jne     wfop001                 ; user data in queue, request not done
        sti
        pop     ax
        ret
wfop001:
;            THEN
;                Block this request
        push    cx
        push    dx
        push    di
        push    es

        lea     di,[si].ci_req_pack     ; make ES:DI -> req packet for block
        mov     ax,ds
        mov     es,ax
        mov     cx,-1                   ; (dx:cx) = infinite time out
        mov     dx,cx
        mov     [si].ci_vdm_Blocked_IOCTL._hi,es
        mov     [si].ci_vdm_Blocked_IOCTL._lo,di
        or      [si].ci_vdm_flag,VDM_Flag_Blocked_IOCTL
        call    ProcBlock

        sti
        pop     es
        pop     di
        pop     dx
        pop     cx
        pop     ax
        ret
;            ENDIF

EndProc  WaitForOutPut

;;********************** START OF SPECIFICATIONS *********************
;;*
;;* SUBROUTINE NAME: PCOMStackEntry
;;*
;;* DESCRIPTIVE NAME: Communication Device Driver Stack Based VDM Entry Point
;;*
;;* FUNCTION:  This entry point is used by the VDMM to tell PCOM when the VCOM
;;*      does a VDHOpenPDD.  VCOM calls this entry point to get the stack based
;;*      entry point (PCOMEntryVDM) and the structure of the ports to support.
;;*
;;*      On entry to this routine, the command type is checked and the correct
;;*      data is stored and returned.
;;*
;;* NOTES:       ABIOS MUST BE PRESENT
;;*
;;* ENTRY POINTS:  PCOMStackEntry
;;*
;;* LINKAGE:     Far 16:32
;;*
;;* INPUT:  (on the stack)
;;*         Func  = port number
;;*         P1    = pointer 1
;;*         P2    = pointer 2
;;*
;;* OUTPUT: command based
;;*
;;*         if Func = 0    (Register)
;;*            P1.offset  = 0
;;*            P1.segment = VDD's CS
;;*            P2.offset  = low 16-bits of VDD EIP for entry point
;;*            P2.segment = high 16-bits of VDD EIP for entry point
;;*
;;*         returns:
;;*            AX = 1
;;*
;;*         if Func = 1    (Get Reg based entry point)
;;*            P1 -> return area for reg based address
;;*            P2 -> return area for structure of supported ports
;;*
;;*         returns:
;;*            AX = 1
;*
;;*********************** END OF SPECIFICATIONS **********************
;
;PCOMStackEntry:
Procedure PCOMStackEntry,FAR

;
;       set up stack frame pointer
        SaveReg <bp>
        mov     bp,sp
        SaveReg <ds>
;
;    Get DS addressability
        setDS   DSEG
;
;    Select (Function type)
;
;        Case (Register - 0):
pse000:
        .386
        cmp     [bp].uFunc,0
        .286
        jne     pse020
;            Save 16:32 pointer of VCOM notification entry point
;                 in global (fixed) data (VCOMAddress)
        mov     ax,[bp].ul1._lo
        mov     [VCOMAddress].fp_sel,ax
        mov     ax,[bp].ul2._lo
        mov     [VCOMAddress].fp_offlo,ax
        mov     ax,[bp].ul2._hi
        mov     [VCOMAddress].fp_offhi,ax
;            Break
        jmp     pse500
;
;        Case (Initialize PCOM-VCOM connection - 1):
pse020:
        .386
        cmp     [bp].uFunc,1
        .286
        ljne     pse200

;
;       Pass register based entry point to VCOM
;
        SaveReg <es,di,si,cx>           ; save burned regs

        mov     es,[bp].ul1._hi         ; get pointer 1 selector
        mov     di,[bp].ul1._lo         ; get pointer 1 offset
        mov     es:[di].fp_sel,cs       ; set the far pointer selector
        mov     es:[di].fp_offhi,0      ; set the far pointer high offset
        lea     ax,cs:PCOMEntryVDM      ; get the far pointer low offset
        mov     es:[di].fp_offlo,ax     ; set the far pointer low offset

;
;       Set up device dependant structure for VCOM
;
;       struct {
;       word ret_len;
;       word num_com;
;       word @com1,
;            @com2,
;            @com3,
;            @com4
;       word @cm1irq,
;            @cm2irq,
;            @cm3irq,
;            @cm4irq
;       };
;

        mov     es,[bp].ul2._hi         ; get selector of pointer 2
        mov     di,[bp].ul2._lo         ; get offset of pointer 2

        mov     cx,es:[di].ret_len
        cmp     cx,size Device_dependant_VCOM_data
        ljne    pse070                  ; we're done

        push    di                      ; save current pointer
        mov     al,0                    ; what to store
        cld                             ; set direction flag to smaller->larger
        repnz   stosb                   ; zero out the passed structure
        pop     di                      ; restore pointer

        mov     es:[di].num_com,MAXCOMPORTS  ; set number of com ports supported
        xor     cx,cx

        mov     si,com1                 ; get ComInfo for com1
        or      si,si                   ; if not installed
        jz      pse040                  ; we're done with this one
        mov     ax,ds:[si].ci_port      ; get port address
        mov     es:[di].@com1,ax        ; set port address
        mov     cl,ds:[si].ci_irq       ; get irq level
        mov     es:[di].@cm1irq,cx      ; set irq level

pse040:                                 ; 
        mov     si,com2                 ; get ComInfo for com2
        or      si,si                   ; if not installed
        jz      pse050                  ; we're done with this one
        mov     ax,ds:[si].ci_port      ; get port address
        mov     es:[di].@com2,ax        ; set port address
        mov     cl,ds:[si].ci_irq       ; get irq level
        mov     es:[di].@cm2irq,cx        ; set irq level

pse050:                                 ; 
        mov     si,com3                 ; get ComInfo for com3
        or      si,si                   ; if not installed
        jz      pse060                  ; we're done with this one
        mov     ax,ds:[si].ci_port      ; get port address
        mov     es:[di].@com3,ax        ; set port address
        mov     cl,ds:[si].ci_irq       ; get irq level
        mov     es:[di].@cm3irq,cx        ; set irq level

pse060:                                 ; 
        mov     si,com4                 ; get ComInfo for com4
        or      si,si                   ; if not installed
        jz      pse070                  ; we're done with this one
        mov     ax,ds:[si].ci_port      ; get port address
        mov     es:[di].@com4,ax        ; set port address
        mov     cl,ds:[si].ci_irq       ; get irq level
        mov     es:[di].@cm4irq,cx      ; set irq level
pse070:                                 ; 
        RestoreReg <cx,si,di,es>        ; 
;            Break
;       jmp     pse500
;
;
;       Default case (invalid parameter):
;        set     return value
pse200:
         mov    ax,0
         jmp    pse600
;    ENDSelect
pse500:                                 ; 
;
;       set good return value
        mov     ax,1
pse600:
;
;       restore frame pointer
        RestoreReg <ds,bp>
;
;    RETURN (32 bit)
        db      66h
        ret     12
;
;END PCOMStackEntry
EndProc PCOMStackEntry
;
CSEG    ENDS

        END
