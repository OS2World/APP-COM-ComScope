#ifndef _INCL_IOCTL_H_

#define INPUT  1
#define OUTPUT 2

/*
** used by function 46h
*/
typedef struct
  {
  BYTE ModemSigOn;
  BYTE ModemSigOff;
  }MDMSSIG;

/*
** used by functions 42h and 62h
*/
typedef struct
  {
  BYTE DataBits;
  BYTE Parity;
  BYTE StopBits;
  BYTE bTransmittingBreak;
  } LINECHAR;

/*
** used by function 43h
*/
typedef struct
  {
  LONG lBaudRate;
  BYTE byFraction;
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

typedef struct  // used by extension function 7A
  {
  ULONG ulBytesReceived;
  ULONG ulBytesTransmitted;
  }DIAGCOUNTS;

typedef struct
  {
  USHORT wByteCount;
  USHORT wQueueLen;
  ULONG dwQueueHigh;
  }BUFCNT;

typedef struct
  {
  HAB hab;
  char *pszPortName;
  ULONG ulReserved;
  }IOCTLINST;

typedef IOCTLINST *HIOCTL;

/*
** IOCTL.DLL function prototypes
*/
APIRET EXPENTRY SetModemSignals(HIOCTL hIOctl,HFILE hCom,BYTE byOnByte,BYTE byOffByte,USHORT *pwCOMerror);
APIRET EXPENTRY GetModemInputSignals(HIOCTL hIOctl,HFILE hCom,BYTE *pbySignals);
APIRET EXPENTRY GetModemOutputSignals(HIOCTL hIOctl,HFILE hCom,BYTE *pbySignals);
APIRET EXPENTRY GetXmitStatus(HIOCTL hIOctl,HFILE hCom,BYTE *pbyCOMstatus);
APIRET EXPENTRY GetReceiveQueueLen(HIOCTL hIOctl,HFILE hCom,USHORT *pwQueueLen,USHORT *pwByteCount);
APIRET EXPENTRY GetReceiveQueueCounts(HIOCTL hIOctl,HFILE hCom,BUFCNT *pstCounts);
APIRET EXPENTRY GetTransmitQueueLen(HIOCTL hIOctl,HFILE hCom,USHORT *pwQueueLen,USHORT *pwByteCount);
APIRET EXPENTRY BreakOff(HIOCTL hIOctl,HFILE hCom,USHORT *pwCOMerror);
APIRET EXPENTRY BreakOn(HIOCTL hIOctl,HFILE hCom,USHORT *pwCOMerror);
APIRET EXPENTRY GetCOMerror(HIOCTL hIOctl,HFILE hCom,USHORT *pwCOMerror);
APIRET EXPENTRY GetCOMstatus(HIOCTL hIOctl,HFILE hCom,BYTE *pbyCOMstatus);
APIRET EXPENTRY GetCOMevent(HIOCTL hIOctl,HFILE hCom,USHORT *pwCOMevent);
APIRET EXPENTRY SendByteImmediate(HIOCTL hIOctl,HFILE hCom,BYTE bySendByte);
APIRET EXPENTRY ForceXon(HIOCTL hIOctl,HFILE hCom);
APIRET EXPENTRY ForceXoff(HIOCTL hIOctl,HFILE hCom);
APIRET EXPENTRY GetDCB(HIOCTL hIOctl,HFILE hCom,DCB *pstComDCB);
APIRET EXPENTRY SendDCB(HIOCTL hIOctl,HFILE hCom,DCB *pstComDCB);
APIRET EXPENTRY GetLineCharacteristics(HIOCTL hIOctl,HFILE hCom,LINECHAR *pstLineChar);
APIRET EXPENTRY SetLineCharacteristics(HIOCTL hIOctl,HFILE hCom,LINECHAR *pstLineChar);
APIRET EXPENTRY SetBaudRate(HIOCTL hIOctl,HFILE hCom,LONG lBaud);
APIRET EXPENTRY GetBaudRate(HIOCTL hIOctl,HFILE hCom,LONG *plBaud);
APIRET EXPENTRY GetBaudRates(HIOCTL hIOctl,HFILE hCom,BAUDST *pstBaudRates);
APIRET EXPENTRY FlushComBuffer(HIOCTL hIOctl,HFILE hCom,USHORT wDirection);
APIRET EXPENTRY GetFIFOinfo(HIOCTL stIOctl,HFILE hCom,FIFOINF *pstFIFOinfo);
APIRET EXPENTRY SetFIFO(HIOCTL stIOctl,HFILE hCom,FIFODEF *pstFIFOcontrol);
APIRET EXPENTRY GetCountsSinceLast(HIOCTL hIOctl,HFILE hCom,DIAGCOUNTS *pstCounts);

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

#define _INCL_IOCTL_H_

#endif
