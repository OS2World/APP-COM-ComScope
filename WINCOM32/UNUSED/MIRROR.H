#define INCL_WINHEAP

#ifndef  include_done

#include <os2.h>


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

typedef unsigned int WORD;
typedef unsigned char BYTE;
typedef unsigned long DWORD;
typedef WORD ERR;

#define SEND_XON  1
#define SEND_XOFF 2

#define INPUT  1
#define OUTPUT 2

#define WRITE_MIRROR 0xaa00
#define READ_MIRROR 0x5500

#define DEFAULT_BUFFER_LEN 400

#ifdef DEMO
#define SIGNATURE 9783
#else
#define SIGNATURE 9784
#endif

#define MAX_FONTS 2

typedef struct
  {
  char szFamilyName[FACESIZE];
  char szFaceName[FACESIZE];
  } FONTNAMES;

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
  BAUDRT stHighestBaud;
  BAUDRT stLowestBaud;
  }BAUDST;

/*
** DCB used by functions 53h and 73h
*/
typedef struct _DCB
    {
    WORD WrtTimeout;
    WORD ReadTimeout;
    BYTE Flags1;
    BYTE Flags2;
    BYTE Flags3;
    BYTE ErrChar;
    BYTE BrkChar;
    BYTE XonChar;
    BYTE XoffChar;
   }DCB;

#define   TID_STATALL     TID_USERMAX - 1
#define   TID_STATDEV     TID_USERMAX - 2
#define   TID_STATRCVBUF  TID_USERMAX - 3
#define   TID_STATXMITBUF TID_USERMAX - 4
#define   TID_STATMDMIN   TID_USERMAX - 5
#define   TID_STATMDMOUT  TID_USERMAX - 6

#define   INITIALHEIGHT   9
#define   INITIALWIDTH    32
#define   PSWIDTH         80
#define   WNDROW          2         /* Scroll unit (chars)  VERT   */
#define   WNDCOL          1         /* Scroll unit (chars)  HORZ   */
#define   MEMALLOC        0xffff    /* ..... 64K .. see spec       */

/*
typedef struct _Orig
   {
   SHORT x;
   SHORT y;
   } ORIG;

typedef ORIG FAR *PORIG;
 
typedef struct _VioCell
   {
   CHAR     vc;
   BYTE     Attr;
   BYTE     ExtAttr;
   BYTE     Spare;
   } VIOCELL;

typedef VIOCELL FAR *PVIOCELL;

typedef struct
  {
  LONG lPsWidth;
  LONG lPsHeight;
  }PRESSPDIM;

typedef struct _PSSIZE
  {
  LONG lXScr;
  LONG lcxVSc;
  LONG lcxBrdr;
  }PSSIZE;

typedef struct _TERMPARMS
  {
  BOOL bLocalEcho;
  BOOL bRemoteEcho;
  BOOL bOutputLF;
  BOOL bInputLF;
  }TERMPARMS;

*/

typedef struct
  {
  LONG cx;
  LONG cy;
  }CHARCELL;

typedef struct _THREADCTRL
  {
  BOOL bStopThread;
  SEL selStack;
  WORD idThread;
  }THREADCTRL;

/*
** Terminal control structure definition
*/
typedef struct _stDataSet
  {
  WORD wCount;
  WORD wDataSet[];
  }DATASET;
 
typedef struct _THREAD
  {
  HWND hwndDlg;
  HWND hwndStatus;
  HWND hwndStatAll;
  HWND hwndStatDev;
  HWND hwndStatModemIn;
  HWND hwndStatModemOut;
  HWND hwndStatRcvBuf;
  HWND hwndStatXmitBuf;
  PFNWP frameproc;
  HFILE hCom;
  BOOL bEnableAnsi;
  BYTE byComNumber;
  CHAR szPortName[9];
  CHAR szCOMname[10];
  WORD wStatus;
  BOOL bAllowClick;
  BOOL bEnableMirror;
  DATASET *pstDataSet;
  SEL sDataSet;
  BOOL bErrorOut;
  BOOL bCalcString;
  BOOL bBreakOn;
  WORD wWrtRow;
  WORD wRdRow;
  WORD wEndRow;
  WORD wStartRow;
  WORD wCol;
  WORD wUpdateDelay;
  HAB habAnchorBlk;
  THREADCTRL stThread;
  HHEAP hHeap;
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

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

/*
** THREAD.C function prototypes
*/
extern void APIENTRY LoopThread();

/*
** WINCOM.c function prototypes
*/
extern VOID cdecl Help(THREAD *pstThd3);
extern VOID KillThread(THREAD *pstThd);
extern VOID CreateThread(THREAD *pstThd);

/*
** IOCTL.C function prototypes
*/
extern ERR SetModemSignals(THREAD *pstThd,BYTE byOnByte,BYTE byOffByte,WORD *pwCOMerror);
extern ERR GetModemInputSignals(THREAD *pstThd,BYTE *pbySignals);
extern ERR GetModemOutputSignals(THREAD *pstThd,BYTE *pbySignals);
extern ERR GetXmitStatus(THREAD *pstThd,BYTE *pbyCOMstatus);
extern ERR GetReceiveQueueLen(THREAD *pstThd,WORD *pwQueueLen,WORD *pwByteCount);
extern ERR GetTransmitQueueLen(THREAD *pstThd,WORD *pwQueueLen,WORD *pwByteCount);
extern ERR BreakOff(THREAD *pstThd,WORD *pwCOMerror);
extern ERR BreakOn(THREAD *pstThd,WORD *pwCOMerror);
extern ERR GetNoClearComEvent_ComError(THREAD *pstThd,WORD *pwCOMevent,WORD *pwCOMerror);
extern ERR GetCOMerror(THREAD *pstThd,WORD *pwCOMerror);
extern ERR GetCOMstatus(THREAD *pstThd,BYTE *pbyCOMstatus);
extern ERR GetCOMevent(THREAD *pstThd,WORD *pwCOMevent);
extern ERR SendByteImmediate(THREAD *pstThd,BYTE bySendByte);
extern ERR ForceXon(THREAD *pstThd);
extern ERR ForceXoff(THREAD *pstThd);
extern ERR GetDCB(THREAD *pstThd,DCB *pstComDCB);
extern ERR SendDCB(THREAD *pstThd,DCB *pstComDCB);
extern ERR GetLineCharacteristics(THREAD *pstThd,LINECHAR *pstLineChar);
extern ERR SetLineCharacteristics(THREAD *pstThd,LINECHAR *pstLineChar);
extern ERR SetBaudRate(THREAD *pstThd,DWORD lBaud);
extern ERR GetBaudRate(THREAD *pstThd,DWORD *plBaud);
extern WORD EnableMirror(THREAD *pstThd,WORD *pBuffSize,BOOL bEnable);
extern WORD AccessMirror(THREAD *pstThd,DATASET *pstDataSet);

/*
** UTIL.C function prototypes
*/
extern BOOL OpenPort(THREAD *pstThd);
extern BOOL GetLongIntDlgItem(THREAD *pstThd,SHORT idEntryField,LONG *plValue);
extern BOOL Checked(THREAD *pstThd,SHORT idDlgItem);
extern void CheckButton(THREAD *pstThd,USHORT idItem,BOOL bCheck);
extern VOID IOctlErrorMessageBox(THREAD *pstThd,SHORT idEntryField,SHORT idErrorMsg,USHORT wFunction,USHORT wError);
extern VOID MessageBox(HWND hwnd,PSZ pszMessage);
extern VOID MenuItemEnable(THREAD *pstThd,WORD idItem,BOOL bEnable);
extern VOID MenuItemCheck(THREAD *pstThd,WORD idItem,BOOL bCheck);
extern VOID MenuCheckSeries(THREAD *pstThd,WORD idStart,int iCount,WORD idItem);
extern VOID ControlEnable(THREAD *pstThd,WORD idItem,BOOL bEnable);
extern void WindowInit(THREAD *pstThd);
extern void SendXonXoff(THREAD *pstThd,WORD wSignal);
extern void FlushComBuffer(THREAD *pstThd,WORD wDirection);
extern void ErrorNotify(THREAD *pstThd,CHAR szMessage[]);
extern VOID SetScreenColors(THREAD *pstThd);
extern VOID PauseThread(THREAD *pstThd);
extern VOID StartThread(THREAD *pstThd);

/*
** SIM.C function prototypes
*/
extern BOOL SendComString(HFILE hCom,BYTE abyByte[],WORD wByteCount);
extern BOOL SendComByte(HFILE hCom,BYTE byByte);
extern BOOL GetComString(HFILE hCom,BYTE *abyString,WORD *pwByteCount);
extern BOOL GetComByte(HFILE hCom,BYTE *pbyByte);

#define include_done 1

#endif
