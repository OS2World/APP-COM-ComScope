#ifndef  _INCL_WINCOM_H_

/*************** OS/2 Error codes ****************
*
*   These codes will be used when a system error
* occurs.
*

#define ERROR_UNKNOWN_UNIT  0x01
#define ERROR_DEV_NOT_READY 0x02
#define ERROR_WRITE_FAULT   0x0A
#define ERROR_READ_FAULT    0x0B
#define ERROR_GEN_FAILURE   0x0C
*/

/*************** GIO Error codes *****************
*
*   These codes will be used when a system error arises
* that the device driver can recover from
*

#define ERROR_TIMEOUT       0x80
#define ERROR_NO_HARDWARE   0x30
#define ERROR_BUFF_ALLOC    0x31
#define ERROR_ADDR_CONVERT  0x32
#define ERROR_ADDR_VERIFY   0x33
#define ERROR_NOT_INIT      0x34
#define ERROR_BAD_FUNCTION  0x35
#define ERROR_INVALID_CAT   0x36
#define ERROR_CMD_TIMEOUT   0x37
#define ERROR_OVERFLOW      0x38
*/

//typedef unsigned int USHORT;
//typedef unsigned char BYTE;
//typedef unsigned long DUSHORT;
//typedef USHORT ERR;

/* File transmission contants, types and function declarations	       */

#define NUL   0x00
#define NIL   0x00
#define ACK   0x06
#define NAK   0x15
#define SOH   0x01
#define EOT   0x04
#define ENQ   0x05
#define CRC   0x43

#define OK    0

#define SEND_XON  1
#define SEND_XOFF 2

#define STRING_TRANSFER     1
#define TERMINAL            3
#define CLP_ACCESS          2

#define   TID_STATALL     TID_USERMAX - 1
#define   TID_STATDEV     TID_USERMAX - 2
#define   TID_STATRCVBUF  TID_USERMAX - 3
#define   TID_STATXMITBUF TID_USERMAX - 4
#define   TID_STATMDMIN   TID_USERMAX - 5
#define   TID_STATMDMOUT  TID_USERMAX - 5

#define   INITIALHEIGHT   20
#define   INITIALWIDTH    65
#define   NUMATTR         3         /* Numattr value for 4-byte PS */
#define   PSWIDTH         80
#define   WNDROW          1         /* Scroll unit (chars)  VERT   */
#define   WNDCOL          1         /* Scroll unit (chars)  HORZ   */
#define   MEMALLOC        0xFFFF    /* ..... 64K .. see spec       */

typedef struct _Orig
   {
   SHORT x;
   SHORT y;
   } ORIG;

typedef ORIG *PORIG;

typedef struct _VioCell
   {
   CHAR     vc;
   BYTE     Attr;
   BYTE     ExtAttr;
   BYTE     Spare;
   } VIOCELL;

typedef VIOCELL *PVIOCELL;

typedef struct _VIOPS
  {
  HDC hdcVio;
  HVPS hpsVio;
  USHORT usPsWidth;            /* Presentation space width in AVIO units  */
  USHORT usPsDepth;            /* Presentation space depth in AVIO units  */
  USHORT usWndWidth;           /* Window width in AVIO units              */
  USHORT usWndDepth;           /* Window Depth in AVIO units              */
  USHORT usVioBufLen;          /* Length of AVIO buffer                   */
  PBYTE  pVioBuf;              /* Address of AVIO buffer                  */
  struct _stCell
    {
    SHORT cx;
    SHORT cy;
    } stCell;
  LONG lXScr;
  LONG lcxVSc;
  LONG lcxBrdr;
  USHORT wForeground;
  USHORT wBackground;
  }VIOPS;

typedef struct _Pos
   {
   SHORT x;
   SHORT y;
   }
POS;
typedef POS *PPOS;

typedef struct _CurPos
   {
   USHORT x;
   USHORT y;
   }
CURPOS;
typedef CURPOS *PCURPOS;

/*
** Thread control structure definition
*/
typedef struct _THREADCTRL
  {
  BOOL bStopThread;
  ULONG KillReadThreadSem;
  ULONG KillThreadSem;
  ULONG RestartThreadSem;
  SEL selReadStack;
  SEL selStack;
  TID idThread;
  TID idReadThread;
  }THREADCTRL;

/*
**  XMODEM transfer structure definition
*/
typedef struct             /* File transmission parameters */
  {
  char ack_char;          /* Acknowledgment character     */
  char nak_char;          /* Negative acknowledgment      */
  char soh_char;                      /* Start of data                */
  char crc_char;                      /* CRC start char               */
  char eot_char;          /* End of transmission        */
  USHORT wStartDelay;           /* Delay in trans of start chars*/
  USHORT wPacketDelay;           /* 10 millisecond Tics between each try        */
  USHORT wContinueDelay;
  USHORT wMaxRetries;           /* Maximum number of error tries*/
  USHORT wCurRetries;           /* Current error count        */
  USHORT wPacketSize;           /* Packet size in bytes         */
  int  error_detection;         /* Error detection algorithm    */
  BOOL bContinous;
  BYTE *pszFileName;
  HFILE hFile;
  } DTPARM;

/*
** Terminal control structure definition
*/
typedef struct _TERMPARMS
  {
  BOOL bLocalEcho;
  BOOL bRemoteEcho;
  BOOL bOutputLF;
  BOOL bInputLF;
  }TERMPARMS;

typedef struct _PSSIZE
  {
  LONG lXScr;
  LONG lcxVSc;
  LONG lcxBrdr;
  }PSSIZE;

typedef struct _CONFIG
  {
//  BYTE byComNumber;
  CHAR szPortName[9];
  USHORT wSimulateType;
  USHORT wReadStringLength;
  CHAR chReadAppendChar;
  CHAR chReadAppendTriggerChar;
  CHAR chReadCompleteChar;
  USHORT wWriteStringLength;
  USHORT wLoopTime;
  CHAR chWriteAppendChar;
  USHORT wWriteCounter;
  LINECHAR stLineCharacteristics;
  LONG lBaudRate;
  DCB stComDCB;
  BYTE xStartByte;
//  int iComNumber;
  POINTL ptlFramePos;
  POINTL ptlFrameSize;
  fBOOL bAllowRead           :1;
  fBOOL bReadCharacters      :1;
  fBOOL bEnableAnsi          :1;
  fBOOL bErrorOut            :1;
  fBOOL bContinuous          :1;
  fBOOL bLongString          :1;
  fBOOL bWriteAppendChar     :1;
  fBOOL bWriteAppendSeries   :1;
  fBOOL bHalfDuplex          :1;
  fBOOL bSlave               :1;
  fBOOL bAllowWrite          :1;
  fBOOL bWriteCharacters     :1;
  fBOOL bMakeAlpha           :1;
  fBOOL bReadAppendChar      :1;
  fBOOL bExecuting           :1;
  fBOOL bLoadWindowPosition  :1;
  fBOOL bLoadMonitor         :1;
  fBOOL bAutoSaveConfig      :1;
  fBOOL bBinaryStream        :1;
  }CONFIG;
typedef CONFIG *PCONFIG;

typedef struct _THREAD
  {
  USHORT cbSize;
  CONFIG stCfg;
  HWND hwndDlg;
  HWND hwndFrame;
  HWND hwndClient;
  HWND hwndStatus;
  CHAR *pWriteString;
  USHORT wUpdateDelay;
  BOOL bCLP_StatusActivated;
  HFILE hCom;
  PFNWP frameproc;
  ULONG StartWriteSem;
  HSEM hsemStartWrite;
  ULONG StartReadSem;
  HSEM hsemStartRead;
  USHORT wStatus;
  BOOL bAllowClick;
  BOOL bBreakOn;
  HAB habAnchorBlk;
  THREADCTRL stThread;
  TERMPARMS stTerm;
  VIOPS stVio;
//  DTPARM stDTparms;
  }THREAD;

#define ANSI_BLACK      '0'
#define ANSI_WHITE      '7'
#define ANSI_BLUE       '4'
#define ANSI_GREEN      '2'
#define ANSI_RED        '1'

#define AVIO_BLACK       0
#define AVIO_WHITE       15
#define AVIO_RED         4
#define AVIO_GREEN       2
#define AVIO_BLUE        1

#define ANSI_FORE     3
#define ANSI_BACK     6

#define BLACK         0
#define WHITE         1
#define RED           2
#define GREEN         3
#define BLUE          4

/*
** THREAD.C function prototypes
*/
extern void APIENTRY LoopThread();

/*
** WINCOM.c function prototypes
*/
extern VOID Help(HWND hwnd);
extern VOID KillThread(THREAD *pstThd);
extern VOID CreateThread(THREAD *pstThd);

/*
** UTIL.C function prototypes
*/
//extern BOOL InitSpinButton(HWND hwndDlg,PSZ aszStrings[],int iStringCount,int iBeginString,int iItemNumber);
extern BOOL OpenPort(THREAD *pstThd);
extern void MakeLongString(THREAD *pstThd,USHORT wLength,BOOL bAlpha);
extern BOOL GetMessageBuffer(PPVOID ppString,USHORT wBufferLength);
extern void WindowInit(THREAD *pstThd);
extern void SendXonXoff(THREAD *pstThd,USHORT wSignal);
extern void PauseThread(THREAD *pstThd);
extern void ErrorNotify(THREAD *pstThd,CHAR szMessage[]);
extern VOID ClearScreen(THREAD *pstThd);
extern VOID SetScreenColors(THREAD *pstThd);
extern void InitRegisterSim(THREAD *pstThd);

/*
** SIM.C function prototypes
*/
extern void TerminalSim(THREAD *pstThd);
extern void TerminalRead(THREAD *pstThd);
extern BOOL Simulator(THREAD *pstThd);
extern BOOL SendComString(HFILE hCom,BYTE abyByte[],USHORT wByteCount);
extern BOOL SendComWord(HFILE hCom,USHORT wWord);
extern BOOL SendComByte(HFILE hCom,BYTE byByte);
extern BOOL GetComString(HFILE hCom,BYTE *abyString,USHORT wByteCount);
extern BOOL GetComWord(HFILE hCom,USHORT *pwWord);
extern BOOL GetComByte(HFILE hCom,BYTE *pbyByte);
extern BOOL WaitComByte(HFILE hCom,BYTE byByte);

/*
** DEBUG.C function prototypes
*/
extern void DebugFunction(void);

/*
** XMODEM simulator function prototypes
*/
extern void TransferInit(THREAD *pstThd);
extern int Transfer(THREAD *pstThd);

#define _INCL_WINCOM_H_

#endif
