;************************************************************************
;
; $Revision:   1.2  $
;
; $Log:   P:/archive/comi/HDW.INV  $
;
;   Rev 1.2   19 Feb 1996 10:48:08   EMMETT
;Added many features, notably:
;Added trace of DosDevOICtl function calls and packets.
;Added 16650 and 16750 support.
;Streamlined interrupt routine.
;
;   Rev 1.1   27 Apr 1994 22:56:20   EMMETT
;FIxed ABIOS stuff to work better than before.
;
;   Rev 1.0   16 Apr 1994 08:35:12   EMMETT
;Initial version control archive.
;
;************************************************************************

; HDW.INC

MAX_16550_TX_DEPTH      equ 16

MAX_16650_TX_DEPTH      equ 32 ;25
;MIDHI_16650_TX_DEPTH    equ 17
;MIDLO_16650_TX_DEPTH    equ 9
;MIN_16650_TX_DEPTH      equ 3

MAX_16654_TX_DEPTH      equ 64 ;57
;MIDHI_16654_TX_DEPTH    equ 49
;MIDLO_16654_TX_DEPTH    equ 31
;MIN_16654_TX_DEPTH      equ 9

MAX_16750_TX_DEPTH      equ 64

EFR_REG_OFFSET          equ 02h
EFR_ENABLE_16650        equ 010h

  IFNDEF NO_ADV_UARTS
; bit definitions for 16650 hardware HS

EFR_ENABLE_AUTO_CTS     equ 8080h
EFR_DISABLE_AUTO_CTS    equ 007fh
EFR_ENABLE_AUTO_RTS     equ 8040h
EFR_DISABLE_AUTO_RTS    equ 00bfh

EFR_AUTO_CTS            equ 080h
EFR_AUTO_RTS            equ 040h
EFR_SELECT_SPECIAL_CHAR equ 020h
; PDD defined Receive Xon handshaking translates to 16650 Transmit Xon handshaking
EFR_RX_FLOW_MASK        equ 00ch
EFR_RX_BOTH             equ 00ch
EFR_RX_ONE              equ 008h
EFR_RX_TWO              equ 004h
; PDD defined Transmit Xon handshaking translates to 16650 Receive Xon handshaking
EFR_TX_FLOW_MASK        equ 003h
EFR_TX_ONE              equ 002h
EFR_TX_TWO              equ 001h
EFR_TX_MATCH_TX         equ 003h

XON1_REG_OFFSET         equ 04h
XON2_REG_OFFSET         equ 05h
XOFF1_REG_OFFSET        equ 06h
XOFF2_REG_OFFSET        equ 07h
  ENDIF ; NO_ADV_UARTS

; Hardware (UART) register offsets and bit definitions

; UART register bit definitions

DATA_IO_REG_OFFSET      equ 0h

; Interrupt Enable register

INT_EN_REG_OFFSET       equ 01h

INT_EN_RCV_DATA_AVAIL   equ 01h
INT_EN_TX_HOLD_EMPTY    equ 02h
INT_EN_RX_LINE_STAT     equ 04h
INT_EN_MODEM_STAT       equ 08h

INT_EN_SLEEP_MODE       equ 10h

INT_EN_XOFF_RECEIVED    equ 20h
INT_EN_RTS_COS          equ 40h
INT_EN_CTS_COS          equ 80h

; Interrupt Identification register (read only)

INT_ID_REG_OFFSET       equ 02h

INT_ID_INT_PENDING      equ 01h
INT_ID_XMIT_HOLD_EMPTY  equ 02h
INT_ID_CHAR_TIMEOUT     equ 0ch
INT_ID_RCV_DATA_READY   equ 04h
INT_ID_RCV_LINE_STAT    equ 06h
INT_ID_MODEM_STAT       equ 00h

INT_ID_XOFF_RCV         equ 10h   ;16650
INT_ID_HS_COS           equ 20h   ;16650

INT_ID_FIFOS_AVAIL_MASK equ 0c0h

; FIFO Control Register (write only)

FIFO_CTL_REG_OFFSET     equ 02h

FIFO_CTL_RCV_TRIG_MASK  equ 0c0h
FIFO_CTL_RCV_TRIG_1     equ 000h
FIFO_CTL_RCV_TRIG_4     equ 040h
FIFO_CTL_RCV_TRIG_8     equ 080h
FIFO_CTL_RCV_TRIG_14    equ 0c0h

FIFO_CTL_16750_64_BYTE_FIFO equ 020h ;16750

FIFO_CTL_TX_16650_TRIG_MASK   equ 030h
FIFO_CTL_TX_16650_TRIG_16     equ 000h
FIFO_CTL_TX_16650_TRIG_8      equ 010h
FIFO_CTL_TX_16650_TRIG_24     equ 020h
FIFO_CTL_TX_16650_TRIG_30     equ 030h

FIFO_CTL_TX_16654_TRIG_8      equ 000h
FIFO_CTL_TX_16654_TRIG_16     equ 010h
FIFO_CTL_TX_16654_TRIG_32     equ 020h
FIFO_CTL_TX_16654_TRIG_56     equ 030h

FIFO_CTL_DMA_MODE       equ 008h
FIFO_CTL_TX_RESET       equ 005h
FIFO_CTL_RX_RESET       equ 003h
FIFO_CTL_FIFO_ENABLE    equ 001h
FIFO_CTL_RESET_FIFOS    equ 007h

; Line Control Register

LINE_CTL_REG_OFFSET     equ 03h

LINE_CTL_DLB_ACCESS     equ 80h
LINE_CTL_SEND_BREAK     equ 40h

LINE_CTL_NO_PARITY_MASK equ 0C7h
LINE_CTL_PARITY_0       equ 38h
LINE_CTL_PARITY_1       equ 28h
LINE_CTL_ODD_PARITY     equ 08h
LINE_CTL_EVEN_PARITY    equ 18h

LINE_CTL_WORD_LEN_MASK  equ 07h
LINE_CTL_WL5            equ 00h
LINE_CTL_WL6            equ 01h
LINE_CTL_WL7            equ 02h
LINE_CTL_WL8            equ 03h
LINE_CTL_SB1            equ 00h
LINE_CTL_SB1_5          equ 04h
LINE_CTL_SB2            equ 04h

; Modem Control Register

MDM_CTL_REG_OFFSET      equ 04h

MDM_CTL_LOOPBK_ENABLE   equ 10h
MDM_CTL_OUT2_ACTIVATE   equ 08h
MDM_CTL_OUT1_ACTIVATE   equ 04h
MDM_CTL_RTS_ACTIVATE    equ 02h
MDM_CTL_DTR_ACTIVATE    equ 01h

MDM_CTL_DIV_4_CLOCK     equ 080h   ; 16650 only
MDM_CTL_HDW_HS_ENABLE   equ 020h   ; 16750 only

; Line Status Register

LINE_ST_REG_OFFSET      equ 05h

LINE_ST_RCV_DATA_READY  equ 01h

LINE_ST_COM_ERROR_MASK  equ 0eH

LINE_ST_OVERRUN_ERROR   equ 02h
LINE_ST_PARITY_ERROR    equ 04h
LINE_ST_FRAMING_ERROR   equ 08h

LINE_ST_BREAK_DETECT    equ 10h
LINE_ST_TX_HOLD_EMPTY   equ 20h
LINE_ST_TX_EMPTY        equ 40h
LINE_ST_FIFO_RCV_ERROR  equ 80h

; Modem Status Register

MDM_ST_REG_OFFSET       equ 06h

MDM_ST_DELTA_CTS        equ 01h
MDM_ST_DELTA_DSR        equ 02h
MDM_ST_DELTA_TRI        equ 04h
MDM_ST_DELTA_DCD        equ 08h
MDM_ST_CTS              equ 10h
MDM_ST_DSR              equ 20h
MDM_ST_TRI              equ 40h
MDM_ST_DCD              equ 80h

MDM_ST_DELTA_MASK   equ MDM_ST_DELTA_DCD + MDM_ST_DELTA_DSR + MDM_ST_DELTA_CTS + MDM_ST_DELTA_TRI

; Other Registers

SCRATCH_REG_OFFSET      equ 07h
DLB_LOW_REG_OFFSET      equ 00h
DLB_HI_REG_OFFSET       equ 01h
