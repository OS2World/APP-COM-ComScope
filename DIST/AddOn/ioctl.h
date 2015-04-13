#ifndef IOCTL_HEADER

#define INPUT  1
#define OUTPUT 2

typedef unsigned char BYTE;

/*
** used by function 46h
*/
typedef struct
  {
  BYTE ModemSigOn;
  BYTE ModemSigOff;
  }MDMSSIG;

/*
** used by extension function 7Ah
*/
typedef struct
  {
  ULONG ulBytesReceived;
  ULONG ulBytesTransmitted;
  }DIAGCOUNTS;

/*
** used by functions 42h and 62h
*/
typedef struct
  {
  BYTE DataBits;
  BYTE Parity;
  BYTE StopBits;
  BYTE bTransmittingBreak;    // return value only (function 42h)
  }LINECHAR;

/*
** used by function 43h
*/
typedef struct
  {
  LONG lBaudRate;
  BYTE byFraction;     // byFraction is not used by COMi and will always be zero
  }BAUDRT;

/*
** used by function 43h
*/
typedef struct
  {
  BAUDRT stCurrentBaud;
  BAUDRT stLowestBaud;
  BAUDRT stHighestBaud;
  }BAUDST;

/*
** DCB used by functions 53h and 73h
*/
typedef struct _DCB
  {
  USHORT WrtTimeout;
  USHORT ReadTimeout;
  BYTE Flags1;
  BYTE Flags2;
  BYTE Flags3;
  BYTE ErrChar;
  BYTE BrkChar;
  BYTE XonChar;
  BYTE XoffChar;
 }DCB;

/*
** DCB flag bit definitions
**
** Flags1
**
** bit 7   = Unused
** bit 6   = enable DSR input Handshaking
** bit 5   = enable DCD output Handshaking
** bit 4   = enable DSR output Handshaking
** bit 3   = enable CTS output Handshaking
** bit 2   = Unused
** bit 0-1 = DTR Control Mode
**  BR1 BR0
**   0   0  Disable
**   0   1  Enable
**   1   0  Input Handshaking
**   1   1  Output Handshaking
*/
#define F1_ENABLE_HS_MASK          0x7a
#define F1_DTR_HS_MASK             0x03

#define F1_DISABLE_DTR             0x00
#define F1_ENABLE_DTR              0x01
#define F1_ENABLE_DTR_INPUT_HS     0x02

#define F1_ENABLE_DSR_INPUT_HS     0x40

#define F1_HDW_OUTPUT_HS_MASK      0x38
#define F1_ENABLE_DCD_OUTPUT_HS    0x20
#define F1_ENABLE_DSR_OUTPUT_HS    0x10
#define F1_ENABLE_CTS_OUTPUT_HS    0x08

/*
** Flags2
**
** bit 6-7 = RTS Control Mode
** BR7 BR6
**  0   0  Disable
**  0   1  Enable
**  1   0  Input Handshaking
**  1   1  Toggling on Transmit
**
** bit 5   = Automatic Recevice Flow Control
**       0 = Normal
**       1 = Full_Duplex
**
** bit 4   = enable break replacement
** bit 3   = enable NULL striping
** bit 2   = enable error Replacement
** bit 1   = enable automatic receive flow control (Xon/Xoff)
** bit 0   = enable automatic transmit flow control (Xon/Xoff)
*/

#define F2_RTS_HS_MASK                  0xc0

#define F2_DISABLE_RTS                  0x00
#define F2_ENABLE_RTS                   0x40
#define F2_ENABLE_RTS_INPUT_HS          0x80
#define F2_ENABLE_RTS_TOG_ON_XMIT       0xc0

#define F2_ENABLE_FULL_DUPLEX           0x20

#define F2_ENABLE_BREAK_REPL            0x10
#define F2_ENABLE_NULL_STRIP            0x08
#define F2_ENABLE_ERROR_REPL            0x04

#define F2_ENABLE_XON_XOFF_MASK         0x03

#define F2_ENABLE_RCV_XON_XOFF_FLOW     0x02
#define F2_ENABLE_XMIT_XON_XOFF_FLOW    0x01

/*
** Flags3
**
** bit 7    = Transmit Buffer Load Count
**
** bits 5-6 = receive trigger level
**  BR6 BR5
**   0   0  = one character
**   0   1  = four characters
**   1   0  = eight characters
**   1   1  = fourteen characters
**
** bits 3-4 = Extended Hardware Buffering
**  BR4 BR3
**   0   0  = not supported - ignored - no change to fifo mode
**   0   1  = extended hardware buffering disabled
**   1   0  = extended hardware buffering enabled
**   1   1  = automatic protocol override
**
** bits 1-2 = Read Timeout Processing
**  BR2 BR1
**   0   0  = Invalid
**   0   1  = Normal read timeout processing
**   1   0  = Wait for something, read timeout processing
**   1   1  = No wait, read timeout processing
**
** bit 0    = Enable infinite write timeout processing
*/

#define F3_USE_TX_BUFFER                0x80

#define F3_RECEIVE_TRIG_MASK            0x60

#define F3_1_CHARACTER_FIFO             0x00
#define F3_4_CHARACTER_FIFO             0x20
#define F3_8_CHARACTER_FIFO             0x40
#define F3_14_CHARACTER_FIFO            0x60

#define F3_HDW_BUFFER_MASK              0x18

#define F3_NO_FIFO_CHANGE               0x00
#define F3_HDW_BUFFER_DISABLE           0x08
#define F3_HDW_BUFFER_ENABLE            0x08
#define F3_HDW_BUFFER_APO               0x18

#define F3_READ_TIMEOUT_MASK            0x06

#define F3_WAIT_NORM                    0x02
#define F3_WAIT_NONE                    0x06
#define F3_WAIT_SOMETHING               0x04

#define F3_INFINITE_WRT_TIMEOUT         0x01

typedef struct
  {
  USHORT usByteCount;
  USHORT usQueueLen;
  USHORT usQueueHigh;
  }BUFCNT;

typedef struct
  {
  USHORT usXonThreshold;      // default is receive buffer size divided by two
  USHORT usXoffThreshold;     // default is four times FIFO size, or 32 bytes without FIFOs
  BYTE byMaxWritePackets;     // default is six
  BYTE byMaxReadPackest;      // defualt is six
  }DDTHRESHOLDS;

typedef struct
  {
  USHORT usFIFOsize;          // UART FIFO size
  USHORT usTxFIFOload;        // current transmit FIFO load count
  USHORT usFIFOflags;         // current FIFO flags, see below for definitions
  ULONG ulReserved;
  }FIFOINF;

typedef struct
  {
  USHORT usTxFIFOload;        // new transmit FIFO load count
  USHORT usFIFOflags;         // new FIFO flags, see below
  ULONG ulReserved;
  }FIFODEF;

#ifdef allow_16650_HDW_Xon_HS       // will not be supported until Startech makes it work
 #define FIFO_FLG_HDW_TX_XON_HS           0x0100
 #define FIFO_FLG_HDW_RX_XON_HS           0x0200
 #define FIFO_FLG_HDW_HS_MASK             0x0f00
#else
 #define FIFO_FLG_HDW_HS_MASK             0x0c00
#endif
#define FIFO_FLG_HDW_CTS_HS              0x0400
#define FIFO_FLG_HDW_RTS_HS              0x0800
#define FIFO_FLG_EXPLICIT_TX_LOAD        0x4000
#define FIFO_FLG_LOW_16750_TRIG          0x8000
#define FIFO_FLG_NO_DCB_UPDATE           0x2000
#define FIFO_FLG_NO_HDW_HS_SUPPORT       0x1000
#define FIFO_FLG_MASK                    0xf000

/*
** IOCTL.DLL function prototypes
*/
APIRET SetModemSignals(HFILE hCom,BYTE byOnByte,BYTE byOffByte,USHORT *pwCOMerror);
APIRET GetModemInputSignals(HFILE hCom,BYTE *pbySignals);
APIRET GetModemOutputSignals(HFILE hCom,BYTE *pbySignals);
APIRET GetXmitStatus(HFILE hCom,BYTE *pbyCOMstatus);
APIRET GetReceiveQueueLen(HFILE hCom,USHORT *pwQueueLen,USHORT *pwByteCount);
APIRET GetReceiveQueueCounts(HFILE hCom,BUFCNT *pstCounts);
APIRET GetTransmitQueueLen(HFILE hCom,USHORT *pwQueueLen,USHORT *pwByteCount);
APIRET BreakOff(HFILE hCom,USHORT *pwCOMerror);
APIRET BreakOn(HFILE hCom,USHORT *pwCOMerror);
APIRET GetCOMerror(HFILE hCom,USHORT *pwCOMerror);
APIRET GetCOMstatus(HFILE hCom,BYTE *pbyCOMstatus);
APIRET GetCOMevent(HFILE hCom,USHORT *pwCOMevent);
APIRET SendByteImmediate(HFILE hCom,BYTE bySendByte);
APIRET ForceXon(HFILE hCom);
APIRET ForceXoff(HFILE hCom);
APIRET GetDCB(HFILE hCom,DCB *pstComDCB);
APIRET SendDCB(HFILE hCom,DCB *pstComDCB);
APIRET GetLineCharacteristics(HFILE hCom,LINECHAR *pstLineChar);
APIRET SetLineCharacteristics(HFILE hCom,LINECHAR *pstLineChar);
APIRET SetBaudRate(HFILE hCom,LONG lBaud);
APIRET GetBaudRate(HFILE hCom,LONG *plBaud);
APIRET GetBaudRates(HFILE hCom,BAUDST *pstBaudRates);
APIRET FlushComBuffer(HFILE hCom,USHORT wDirection);
APIRET GetFIFOinfo(HFILE hCom,FIFOINF *pstFIFOinfo);
APIRET SetFIFO(HFILE hCom,FIFODEF *pstFIFOcontrol);
APIRET GetCountsSinceLast(HFILE hCom,DIAGCOUNTS *pstCounts);

#define IC_ATM_ERRMSG_INVALID_PARAM 3626
#define IC_ATM_ERRMSG_GEN_FAIL  3627
#define IC_ATM_ERRMSG_BAD_COMMAND 3628
#define IC_ATM_ERRMSG_UNKNOWN_ERROR 3629
#define IC_ATM_GET_DIAG_COUNTS     3630

#define IC_ATM_SET_FIFO_LOAD 3625
#define IC_ATM_GET_FIFO     3624

#define IC_ATM_TXIMM        3623
#define IC_ATM_ERRORCD      3622
#define IC_ATM_FUNCTION     3621
#define IC_ATM_IOCTL        3620
#define IC_ATM_FLUSH        3619
#define IC_ATM_COMEVENTS    3618
#define IC_ATM_COMEVENT     3617
#define IC_ATM_COMERROR     3616
#define IC_ATM_XMITSTAT     3615
#define IC_ATM_COMSTAT      3614
#define IC_ATM_BRKON        3613
#define IC_ATM_BRKOFF       3612
#define IC_ATM_RCVQLEN      3611
#define IC_ATM_TXQLEN       3610
#define IC_ATM_LINEWRT      3609
#define IC_ATM_LINERD       3608
#define IC_ATM_DCBWRT       3607
#define IC_ATM_DCBRD        3606
#define IC_ATM_BAUDWRT      3605
#define IC_ATM_BAUDRD       3604
#define IC_ATM_FXOFF        3603
#define IC_ATM_FXON         3602
#define IC_ATM_MDMGET       3601
#define IC_ATM_MDMSET       3600

#define IOCTL_HEADER

#endif
