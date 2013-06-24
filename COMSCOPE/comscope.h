#ifndef  _INCL_COMSCOPE_H_

#include "COMMON.H"
#include "COMDD.H"
#include "ioctl.h"
#include "utility.h"
#include "CONFIG.H"
#include "COMcontrol.h"
#include "profile.h"

#include "help.h"
#include "column.h"
#include "usermsg.h"
#include "resource.h"

/* miscellaneous Window IDs */

#define WID_VSCROLL_BAR     21000
#define WID_STATUS_LINE      21001

#define SEND_XON  1
#define SEND_XOFF 2

#define CFG_DELETE  1
#define CFG_LOAD    2
#define CFG_SAVE    3
#define CFG_SAVEAS  4

#define MAX_SEARCH_STRING 512
#define MAX_CPS_SAMPLES 100

#define PORT_NAME_LEN 10

#define DEF_CAP_BUFF_LEN 0x8000
#define MAX_CAP_BUFF_LEN 0x100000L
#define MIN_CAP_BUFF_LEN 0x800L

#define MAX_FONTS 4

#define ASCII_FONT 1
#define HEX_FONT   0

typedef struct
  {
  USHORT cbCFGsize;
  char szPortName[20];
  fBOOL bSilentStatus        :1;
  fBOOL bIsInstall           :1;
  fBOOL bInsert              :1;
  fBOOL bStickyMenus         :1;
  fBOOL bShowCounts          :1;
  fBOOL bCaptureToFile       :1;
  fBOOL bReadWrap            :1;
  fBOOL bWriteWrap           :1;
  fBOOL bDDstatusActivated   :1;
  fBOOL bMIstatusActivated   :1;
  fBOOL bMOstatusActivated   :1;
  fBOOL bRBstatusActivated   :1;
  fBOOL bTBstatusActivated   :1;
  fBOOL bMonitoringStream    :1;
  fBOOL bLoadWindowPosition  :1;
  fBOOL bLoadMonitor         :1;
  fBOOL bAutoSaveConfig      :1;
  fBOOL bOverWriteBuffer     :1;
  fBOOL bErrorOut            :1;
  fBOOL bHiLightImmediateByte:1;
  fBOOL bSampleCounts        :1;
  fBOOL bSkipReadBlankLines  :1;
  fBOOL bSkipWriteBlankLines :1;
  fBOOL bColumnDisplay       :1;
  fBOOL bSyncToWrite         :1;
  fBOOL bSyncToRead          :1;
  fBOOL bReadTestNewLine     :1;
  fBOOL bWriteTestNewLine    :1;
  fBOOL bFilterRead          :1;
  fBOOL bFilterWrite         :1;
  fBOOL bPopupParams         :1;
  fBOOL bLargeFont           :1; //32
  fBOOL fFilterReadMask      :4;
  fBOOL fFilterWriteMask     :4;
  fBOOL fLockWidth           :2;
  fBOOL fDisplaying          :3;
  fBOOL bDispWrite           :1;
  fBOOL bDispRead            :1;
  fBOOL bDispIMM             :1;
  fBOOL bDispModemIn         :1;
  fBOOL bDispModemOut        :1;
  fBOOL bDispOpen            :1;
  fBOOL bDispWriteReq        :1;
  fBOOL bDispReadReq         :1;
  fBOOL bDispDevIOctl        :1;
  fBOOL bDispErrors          :1;
  fBOOL bFindWrap            :1;
  fBOOL bFindForward         :1;
  fBOOL bFindString          :1;
  fBOOL bFindRead            :1;
  fBOOL bFindWrite           :1;
  fBOOL bFindIMM             :1;
  fBOOL bFindModemIn         :1;
  fBOOL bFindModemOut        :1;
  fBOOL bFindOpen            :1; //32
  fBOOL bFindWriteReq        :1;
  fBOOL bFindReadReq         :1;
  fBOOL bFindDevIOctl        :1;
  fBOOL bFindErrors          :1;
  fBOOL bFindStrHEX          :1;
  fBOOL bFindStrNoCase       :1;
  fBOOL bMarkCurrentLine     :1;
  ULONG fTraceEvent;
  LONG lRowScrollIndex;
  LONG lReadColScrollIndex;
  LONG lWriteColScrollIndex;
  BYTE byReadMask;
  BYTE byWriteMask;
  LONG lLockWidth;
  POINTL ptlFrameSize;
  POINTL ptlFramePos;
  POINTL ptlDDstatusPos;
  POINTL ptlMIstatusPos;
  POINTL ptlMOstatusPos;
  POINTL ptlRBstatusPos;
  POINTL ptlTBstatusPos;
  LONG lModemOutBackgrndColor;
  LONG lModemOutForegrndColor;
  LONG lModemInBackgrndColor;
  LONG lModemInForegrndColor;
  LONG lOpenBackgrndColor;
  LONG lOpenForegrndColor;
  LONG lErrorBackgrndColor;
  LONG lErrorForegrndColor;
  LONG lReadReqBackgrndColor;
  LONG lReadReqForegrndColor;
  LONG lWriteReqBackgrndColor;
  LONG lWriteReqForegrndColor;
  LONG lDevIOctlBackgrndColor;
  LONG lDevIOctlForegrndColor;
  LONG lReadBackgrndColor;
  LONG lReadForegrndColor;
  LONG lWriteBackgrndColor;
  LONG lWriteForegrndColor;
  LONG lStatusBackgrndColor;
  LONG lStatusForegrndColor;
  LONG lReadColBackgrndColor;
  LONG lReadColForegrndColor;
  LONG lWriteColBackgrndColor;
  LONG lWriteColForegrndColor;
  BYTE byReadNewLineChar;
  BYTE byWriteNewLineChar;
  WORD wUpdateDelay;
  ULONG ulUserSleepCount;
  LONG lBufferLength;
  WORD wRowFont;
  WORD wColReadFont;
  WORD wColWriteFont;
  int iSampleCount;
  }CSCFG;

typedef struct
  {
  USHORT cbSize;
  LONG lBackground;
  LONG lForeground;
  char szCaption[80];
  }CLRDLG;

typedef struct
  {
  LONG lRead;
  LONG lWrite;
  LONG lReadImm;
  LONG lWriteImm;
  }CHARCNT;

#define DISP_STREAM    0x01
#define DISP_DATA      0x02
#define DISP_FILE      0x04

#define LOCK_NONE      0x00
#define LOCK_READ      0x01
#define LOCK_WRITE     0x02

#define FILTER_NONE    0x00
#define FILTER_NPRINT  0x01
#define FILTER_ALPHA   0x02
#define FILTER_NUMS    0x04
#define FILTER_PUNCT   0x08

#define FOPEN_NORMAL       0
#define FOPEN_OVERWRITE    1
#define FOPEN_APPEND       2
#define FOPEN_NEW_ONLY     4
#define FOPEN_EXISTS_ONLY  8

#define FOPEN_AUTO_ALLOC   FALSE
#define FOPEN_ASK_ALLOC    TRUE

typedef struct
  {
  char szFamilyName[FACESIZE];
  char szFaceName[FACESIZE];
  } FONTNAMES;

#define   TID_STATALL     TID_USERMAX - 1
#define   TID_STATDEV     TID_USERMAX - 2
#define   TID_STATRCVBUF  TID_USERMAX - 3
#define   TID_STATXMITBUF TID_USERMAX - 4
#define   TID_STATMDMIN   TID_USERMAX - 5
#define   TID_STATMDMOUT  TID_USERMAX - 6
#define   TID_STATUSBAR   TID_USERMAX - 7

#define   MINHEIGHT     0
#define   MINWIDTH      32
#define   INITHEIGHT    10
#define   INITWIDTH     40

#define   ACTIVE_SIZE     1
#define   INACTIVE_SIZE   2

typedef struct
  {
  SHORT cx;
  SHORT cy;
  }CHARCELL;

typedef struct
  {
  ULONG cbSize;
  USHORT *awData;
  }CSDATA;

extern HWND hwndStatus;
extern HWND hwndStatAll;
extern HWND hwndStatDev;
extern HWND hwndStatModemIn;
extern HWND hwndStatModemOut;
extern HWND hwndStatRcvBuf;
extern HWND hwndStatXmitBuf;
extern PFNWP frameproc;
extern HFILE hCom;
extern BYTE byComNumber;
extern BOOL bEnableCOMscope;
extern WORD wStatus;
extern SEL sDataSet;
extern BOOL bCalcString;
extern BOOL bBreakOn;

extern VOID Help(void);

/*
** THREAD.C function prototypes
*/
extern void APIENTRY MonitorThread(HFILE hCom);
extern void APIENTRY RowDisplayThread(void);
extern void APIENTRY ColumnDisplayThread(void);
extern void APIENTRY IPCserverThread(void);
extern void APIENTRY RemoteServerThread(void);

extern BOOL KillMonitorThread(void);
extern BOOL KillDisplayThread(void);

/*
** WIN_UTIL.C function prototypes
extern BOOL GetLongIntDlgItem(HWND hwndDlg,SHORT idEntryField,LONG *plValue);
extern VOID MenuItemEnable(HWND hwnd,WORD idItem,BOOL bEnable);
extern VOID MenuItemCheck(HWND hwnd,WORD idItem,BOOL bCheck);
extern VOID MenuCheckSeries(WORD idStart,int iCount,WORD idItem);
*/
extern void SaveWindowPositions(void);
extern VOID PopupMenuItemCheck(HWND hwnd,WORD idItem,BOOL bCheck);
extern VOID MousePosDlgBox(HWND hwnd);

/*
** CSUTIL.C function prototypes
*/
extern void SendXonXoff(WORD wSignal);
extern BOOL OpenPort(HWND hwndDlg,HFILE *phCom,CSCFG *pstCFG);
extern BOOL ProcessKeystroke(CSCFG *pstCFG,MPARAM mp1,MPARAM mp2);
extern void ErrorNotify(CHAR szMessage[]);
extern BOOL WriteCaptureFile(char szFileSpec[],WORD *pwBuffer,ULONG ulWordCount,LONG fWriteMode,LONG lHelp);
extern BOOL ReadCaptureFile(char szFileSpec[],WORD **ppwBuffer,ULONG *pulWordCount,BOOL bAskLength);
extern void IncrementFileExt(char szFileSpec[],BOOL bInit);
extern BOOL TestOUT1(void);
extern APIRET EnableCOMscope(HWND hwnd,HFILE hCom,ULONG *pulBuffSize,USHORT fTraceEvent);
extern APIRET AccessCOMscope(HFILE hCom,CSDATA *pstDataSet);
extern void CalcThreadSleepCount(LONG lBaud);
extern APIRET GetNoClearComEvent_ComError(HFILE hCom,WORD *pwCOMevent,WORD *pwCOMerror);
/*
**  Init.c function prototypes
*/
extern void InitializeData(void);
extern BOOL InitializeSystem(void);
extern void StartSystem(CSCFG *pstCFG,BOOL bRestart);

/*
**  HELP.C
*/
extern BOOL HelpInit(char szHelpFileName[]);
extern VOID HelpHelpForHelp(void);
extern VOID HelpExtended(VOID);
extern VOID HelpKeys(void);
extern VOID HelpIndex(void);
extern VOID DisplayHelpPanel(USHORT idPanel);
extern VOID DestroyHelpInstance(VOID);
extern VOID ShowDlgHelp(HWND hwnd);

/*
** SCROLL.C
*/
extern void ClearRowScrollBar(SCREEN *pstScreen);
extern void SetupRowScrolling(SCREEN *pstScreen);
extern void RowScroll(SCREEN *pstScreen,SHORT iRows,BOOL bIsPosition);
//extern void ClearRowScreen(SCREEN *pstScreen);
extern LONG GetRowScrollRow(SCREEN *pstScreen);
extern LONG GetColScrollRow(SCREEN *pstScreen,LONG lStartIndex);
extern void ClearColScrollBar(SCREEN *pstScreen);
extern void SetupColScrolling(SCREEN *pstScreen);
extern void ColScroll(SCREEN *pstScreen,SHORT iRows,BOOL bIsPosition);
extern void AdjustScrollBar(SCREEN *pstScreen);


#define _INCL_COMSCOPE_H_

#endif
