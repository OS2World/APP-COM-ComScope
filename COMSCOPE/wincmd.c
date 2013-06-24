#include "COMscope.h"

#include "remote.h"

extern CFG_INSTDEV pfnInstallDevice;
extern PRF_MANAGE pfnManageProfile;
extern PRF_SAVESTR pfnSaveProfileString;
extern CFG_DIALOG pfnDialog;

extern HWND hwndHelpInstance;

extern BOOL bPortActive;

extern COMICFG stCOMiCFG;

extern COMCTL stComCtl;

MRESULT EXPENTRY COMscopeOpenFilterProc(HWND hwnd,ULONG message,MPARAM mp1,MPARAM mp2);

LONG SearchCaptureBuffer(USHORT *pusBuffer,LONG lBufLength);

MRESULT WinCommand(HWND hWnd,USHORT Command,CSCFG *pstCFG);
void SelectDevice(HWND hwnd,CSCFG *pstCFG);

void DisplayCharacterInfo(HWND hwnd,LONG lMouseIndex);
MRESULT EXPENTRY FrameSubProc(HWND hwnd,WORD msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpClient(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY StatusProc(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);

extern MRESULT EXPENTRY AboutBoxDlgProc(HWND hwnd, ULONG msg,MPARAM mp1,MPARAM mp2);

extern MRESULT EXPENTRY fnwpCountsSetupDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpSearchConfigDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpEventDispDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpTraceEventDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpHdwModemControlDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpSetColorDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpMonitorSleepDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
//extern MRESULT EXPENTRY fnwpPortConfigDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpPortSelectDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
//extern MRESULT EXPENTRY fnwpHdwProtocolDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
//extern MRESULT EXPENTRY fnwpHdwFilterDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
//extern MRESULT EXPENTRY fnwpHdwFIFOsetupDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
//extern MRESULT EXPENTRY fnwpHandshakeDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
//extern MRESULT EXPENTRY fnwpHdwTimeoutDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
//extern MRESULT EXPENTRY fnwpHdwBaudRateDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpBufferSizeDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
//extern MRESULT EXPENTRY PortConfigDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpModemOutStatusDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpModemInStatusDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpUpdateStatusDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpXmitBufferStatusDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpRcvBufferStatusDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpDeviceStatusDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpDeviceAllStatusDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpDisplaySetupDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);

extern char szIniName[];
extern HWND hwndFrame;
extern HWND hwndClient;

extern SCREEN stRow;
extern SCREEN stRead;
extern SCREEN stWrite;

extern char szDataFileSpec[];
extern char szCaptureFileSpec[];
extern char szEntryDataFileSpec[];
extern char szEntryCaptureFileSpec[];
extern char szCaptureFileName[];

extern char szCurrentPortName[];
extern IOCTLINST stIOctl;

extern WORD wASCIIfont;
extern WORD wHEXfont;

extern ULONG ulUserSleepCount;
extern ULONG ulMonitorSleepCount;
extern ULONG ulCalcSleepCount;
extern BOOL bDataToView;
extern LONG lScrollCount;
extern WORD *pwScrollBuffer;
extern WORD *pwCaptureBuffer;
extern WORD *pwCOMscopeDataSet;

extern BOOL bMaximized;
extern BOOL bMinimized;

extern BOOL bSendNextKeystroke;
extern BOOL bStopMonitorThread;
extern BOOL bStopDisplayThread;
extern HEV hevWaitCOMiDataSem;

int iDeviceCount;

extern TID tidMonitorThread;
extern TID tidDisplayThread;
extern HMTX hmtxRowGioBlockedSem;
extern LONG lWriteIndex;
extern BOOL bBufferWrapped;

extern BOOL bSearchInit;

extern HPROF hProfileInstance;
extern USHORT usLastClientPopupItem;
extern BOOL bNoPaint;

extern HWND hwndStatDev;
extern HWND hwndStatModemIn;
extern HWND hwndStatModemOut;
extern HWND hwndStatRcvBuf;
extern HWND hwndStatXmitBuf;

ULONG ulServerMessage = 0;
extern PIPEMSG stPipeMsg;
extern PIPECMD stPipeCmd;
extern BOOL bRemoteClient;

extern LONG fLastScroll;
char szTempPath[CCHMAXPATH + 1];
extern char szCOMscopePipe[];
extern IPCPIPEMSG stPipe;

MRESULT WinCommand(HWND hWnd,USHORT Command,CSCFG *pstCFG)
  {
  WORD wStatus;
  ULONG ulWordCount;
  char szMessage[80];
  static CLRDLG stColor;
  HPOINTER hPointer;
//  DCB stDCB;
  HMODULE hMod;
//  LINECHAR stLineChar;
  LONG lFoundIndex;

  switch (Command)
    {
    case IDM_HELPFORHELP:
      HelpHelpForHelp();
      return((MRESULT)FALSE);
    case IDM_HELPEXTEND:
      DisplayHelpPanel(HLPP_GENERAL);
      return((MRESULT)FALSE);
    case IDM_HELPINDEX:
      HelpIndex();
      return((MRESULT)FALSE);
    case IDM_HELPKEYS:
      DisplayHelpPanel(HLPP_KEYS);
      return((MRESULT)FALSE);
    case HM_QUERY_KEYS_HELP:
      return (MRESULT)HLPP_KEYS;
    case IDM_EXIT:
      WinPostMsg(hWnd,WM_CLOSE,0L,0L);
      return((MRESULT)FALSE);
    case IDM_INSTALL:
      if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) == NO_ERROR)
        {
        stCOMiCFG.pszPortName = NULL;
        stCOMiCFG.hwndHelpInstance = hwndHelpInstance;
        stCOMiCFG.bInstallCOMscope = TRUE;
        stCOMiCFG.bInitInstall = FALSE;
        stCOMiCFG.pszRemoveOldDriverSpec == NULL;
//        stCOMiCFG.ulMaxDeviceCount = 2;
        if (DosQueryProcAddr(hMod,0,"InstallDevice",(PFN *)&pfnInstallDevice) == NO_ERROR)
          pfnInstallDevice(&stCOMiCFG);
        DosFreeModule(hMod);
        }
      return(FALSE);
    case IDM_SURFACE_THIS:
      WinSendMsg(hwndStatDev,WM_ACTIVATE,0L,0L);
      WinSendMsg(hwndStatModemIn,WM_ACTIVATE,0L,0L);
      WinSendMsg(hwndStatModemOut,WM_ACTIVATE,0L,0L);
      WinSendMsg(hwndStatRcvBuf,WM_ACTIVATE,0L,0L);
      WinSendMsg(hwndStatXmitBuf,WM_ACTIVATE,0L,0L);
      return(FALSE);
    case IDM_SURFACE_ALL:
      ulServerMessage = UM_SURFACE_ALL;
      return(FALSE);
    case IDM_STICKY_MENUS:
      if (pstCFG->bStickyMenus)
        {
        MenuItemCheck(hwndFrame,IDM_STICKY_MENUS,FALSE);
        pstCFG->bStickyMenus = FALSE;
        }
      else
        {
        MenuItemCheck(hwndFrame,IDM_STICKY_MENUS,TRUE);
        pstCFG->bStickyMenus = TRUE;
        }
      break;
    case IDM_SILENT_STATUS:
      if (pstCFG->bSilentStatus)
        pstCFG->bSilentStatus = FALSE;
      else
        pstCFG->bSilentStatus = TRUE;
      MenuItemCheck(hwndFrame,IDM_SILENT_STATUS,pstCFG->bSilentStatus);
//      WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
      break;
    case IDMPU_SILENT_STATUS:
      WinPostMsg(hwndStatus,WM_COMMAND,(MPARAM)IDMPU_SILENT_STATUS,0L);
      break;
    case IDMPU_LAST_COUNT:
      WinPostMsg(hwndStatus,WM_COMMAND,(MPARAM)IDMPU_LAST_COUNT,0L);
      break;
    case IDMPU_LAST_MSG:
      WinPostMsg(hwndStatus,WM_COMMAND,(MPARAM)IDMPU_LAST_MSG,0L);
      break;
    case IDMPU_COLORS:
      WinPostMsg(hwndStatus,WM_COMMAND,(MPARAM)IDMPU_COLORS,0L);
      break;
    case IDMPU_LEX_ASCII_FONT:
      WinPostMsg(stWrite.hwnd,WM_COMMAND,(MPARAM)IDMPU_ASCII_FONT,0L);
      WinPostMsg(stRead.hwnd,WM_COMMAND,(MPARAM)IDMPU_ASCII_FONT,0L);
      break;
    case IDMPU_LEX_HEX_FONT:
      WinPostMsg(stWrite.hwnd,WM_COMMAND,(MPARAM)IDMPU_HEX_FONT,0L);
      WinPostMsg(stRead.hwnd,WM_COMMAND,(MPARAM)IDMPU_HEX_FONT,0L);
      break;
    case IDMPU_SYNC_TX:
      WinPostMsg(stWrite.hwnd,WM_COMMAND,(MPARAM)IDMPU_SYNC,0L);
      break;
    case IDMPU_SYNC_RX:
      WinPostMsg(stRead.hwnd,WM_COMMAND,(MPARAM)IDMPU_SYNC,0L);
      break;
    case IDMPU_TX_COLORS:
      WinPostMsg(stWrite.hwnd,WM_COMMAND,(MPARAM)IDMPU_COLORS,0L);
      break;
    case IDMPU_RX_COLORS:
      WinPostMsg(stRead.hwnd,WM_COMMAND,(MPARAM)IDMPU_COLORS,0L);
      break;
    case IDMPU_TX_LOCK_WIDTH:
      WinPostMsg(stWrite.hwnd,WM_COMMAND,(MPARAM)IDMPU_LOCK_WIDTH,0L);
      break;
    case IDMPU_RX_LOCK_WIDTH:
      WinPostMsg(stRead.hwnd,WM_COMMAND,(MPARAM)IDMPU_LOCK_WIDTH,0L);
      break;
    case IDMPU_TX_DISP_FILTERS:
      WinPostMsg(stWrite.hwnd,WM_COMMAND,(MPARAM)IDMPU_DISP_FILTERS,0L);
      break;
    case IDMPU_RX_DISP_FILTERS:
      WinPostMsg(stRead.hwnd,WM_COMMAND,(MPARAM)IDMPU_DISP_FILTERS,0L);
      break;
    case IDM_TOGGLE_FONT_SIZE:
      if (!bMinimized && !bMaximized)
        {
        if (pstCFG->bLargeFont)
          {
          pstCFG->bLargeFont = FALSE;
          if (pstCFG->wRowFont == wASCIIfont)
            pstCFG->wRowFont = ASCII_FONT;
          else
            pstCFG->wRowFont = HEX_FONT;
          if (pstCFG->wColReadFont == wASCIIfont)
            pstCFG->wRowFont = ASCII_FONT;
          else
            pstCFG->wColReadFont = HEX_FONT;
          if (pstCFG->wColWriteFont == wASCIIfont)
            pstCFG->wColWriteFont = ASCII_FONT;
          else
            pstCFG->wColWriteFont = HEX_FONT;
          wASCIIfont = 1;
          wHEXfont = 0;
          }
        else
          {
          pstCFG->bLargeFont = TRUE;
          if (pstCFG->wRowFont == wASCIIfont)
            pstCFG->wRowFont = ASCII_FONT;
          else
            pstCFG->wRowFont = HEX_FONT;
          if (pstCFG->wColReadFont == wASCIIfont)
            pstCFG->wRowFont = ASCII_FONT;
          else
            pstCFG->wColReadFont = HEX_FONT;
          if (pstCFG->wColWriteFont == wASCIIfont)
            pstCFG->wColWriteFont = ASCII_FONT;
          else
            pstCFG->wColWriteFont = HEX_FONT;
          wASCIIfont = 3;
          wHEXfont = 2;
          pstCFG->wColWriteFont += 2;
          pstCFG->wColReadFont += 2;
          pstCFG->wRowFont += 2;
          }
        WinSendMsg(hwndClient,WM_SYSVALUECHANGED,0L,0L);
        }
      return(FALSE);
    case IDM_TOGGLE_FONT:
      if (!bMinimized)
        {
        if (pstCFG->wRowFont != wASCIIfont)
          pstCFG->wRowFont = wASCIIfont;
        else
          pstCFG->wRowFont = wHEXfont;
        bNoPaint = FALSE;
        WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
        if (pstCFG->wColReadFont != wASCIIfont)
          pstCFG->wColReadFont = wASCIIfont;
        else
          pstCFG->wColReadFont = wHEXfont;
        WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
        if (pstCFG->wColWriteFont != wASCIIfont)
          pstCFG->wColWriteFont = wASCIIfont;
        else
          pstCFG->wColWriteFont = wHEXfont;
        WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
        }
      return(FALSE);
    case IDMPU_ASCII_FONT:
      if (!pstCFG->bStickyMenus)
        usLastClientPopupItem = IDMPU_FONT;
      else
        usLastClientPopupItem = IDMPU_EVENT_DISP;
      pstCFG->wRowFont = wASCIIfont;
      bNoPaint = FALSE;
      WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
      return(FALSE);
    case IDMPU_HEX_FONT:
      if (!pstCFG->bStickyMenus)
        usLastClientPopupItem = IDMPU_FONT;
      else
        usLastClientPopupItem = IDMPU_EVENT_DISP;
      pstCFG->wRowFont = wHEXfont;
      bNoPaint = FALSE;
      WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
      return(FALSE);
    case IDM_TOGGLE_FORMAT:
      if (!bMinimized)
        {
        if (pstCFG->bColumnDisplay)
          {
          MenuItemCheck(hwndFrame,IDM_ROWS,TRUE);
          MenuItemCheck(hwndFrame,IDM_COLUMNS,FALSE);
          pstCFG->bColumnDisplay = FALSE;
          WinSendMsg(stWrite.hwndClient,UM_HIDEWIN,0L,0L);
          WinSendMsg(stRead.hwndClient,UM_HIDEWIN,0L,0L);
          if (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE))
            {
            SetupRowScrolling(&stRow);
            if (pstCFG->bSyncToRead || (fLastScroll == CS_READ))
              stRow.lScrollIndex = stRead.lScrollIndex;
            if (pstCFG->bSyncToWrite || (fLastScroll == CS_WRITE))
              stRow.lScrollIndex = stWrite.lScrollIndex;
            }
          else
            {
            if (KillDisplayThread())
              {
              bStopDisplayThread = FALSE;
              DosCreateThread(&tidDisplayThread,(PFNTHREAD)RowDisplayThread,0L,0L,4096);
              }
            }
          WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
          WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
          }
        else
          {
          MenuItemCheck(hwndFrame,IDM_ROWS,FALSE);
          MenuItemCheck(hwndFrame,IDM_COLUMNS,TRUE);
          pstCFG->bColumnDisplay = TRUE;
          WinSendMsg(stWrite.hwndClient,UM_SHOWAGAIN,0L,0L);
          WinSendMsg(stRead.hwndClient,UM_SHOWAGAIN,0L,0L);
          if (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE))
            ClearRowScrollBar(&stRow);
          else
            if (KillDisplayThread())
              {
              bStopDisplayThread = FALSE;
              DosCreateThread(&tidDisplayThread,(PFNTHREAD)ColumnDisplayThread,0L,0L,4096);
              }
          WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
          }
        }
      return(FALSE);
    case IDM_ROWS:
      if (pstCFG->bColumnDisplay)
        {
        MenuItemCheck(hwndFrame,IDM_ROWS,TRUE);
        MenuItemCheck(hwndFrame,IDM_COLUMNS,FALSE);
        pstCFG->bColumnDisplay = FALSE;
        WinSendMsg(stWrite.hwndClient,UM_HIDEWIN,0L,0L);
        WinSendMsg(stRead.hwndClient,UM_HIDEWIN,0L,0L);
        if (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE))
          {
          SetupRowScrolling(&stRow);
          if (pstCFG->bSyncToRead || (fLastScroll == CS_READ))
            stRow.lScrollIndex = stRead.lScrollIndex;
          if (pstCFG->bSyncToWrite || (fLastScroll == CS_WRITE))
            stRow.lScrollIndex = stWrite.lScrollIndex;
          }
        else
          if (KillDisplayThread())
            {
            bStopDisplayThread = FALSE;
            DosCreateThread(&tidDisplayThread,(PFNTHREAD)RowDisplayThread,0L,0L,4096);
            }
        bNoPaint = FALSE;
        WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
        WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
        }
      return(FALSE);
    case IDM_COLUMNS:
      if (!pstCFG->bColumnDisplay)
        {
        MenuItemCheck(hwndFrame,IDM_ROWS,FALSE);
        MenuItemCheck(hwndFrame,IDM_COLUMNS,TRUE);
        pstCFG->bColumnDisplay = TRUE;
        WinSendMsg(stWrite.hwndClient,UM_SHOWAGAIN,0L,0L);
        WinSendMsg(stRead.hwndClient,UM_SHOWAGAIN,0L,0L);
        if (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE))
          ClearRowScrollBar(&stRow);
        else
          if (KillDisplayThread())
            {
            bStopDisplayThread = FALSE;
            DosCreateThread(&tidDisplayThread,(PFNTHREAD)ColumnDisplayThread,0L,0L,4096);
            }
        bNoPaint = FALSE;
        WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
//        WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
//        WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
        }
      return(FALSE);
    case IDMPU_EVENT_DISP:
      usLastClientPopupItem = IDMPU_EVENT_DISP;
      if (WinDlgBox(HWND_DESKTOP,
                    hWnd,
             (PFNWP)fnwpEventDispDlgProc,
            (USHORT)NULL,
                    EVENT_DISP_DLG,
            MPFROMP(pstCFG)))
        {
        bNoPaint = FALSE;
        WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
        }
      return(FALSE);
    case IDMPU_WRITEREQ_COLOR:
      if (pstCFG->bStickyMenus)
        usLastClientPopupItem = IDMPU_COLORS;
      else
        usLastClientPopupItem = IDMPU_EVENT_DISP;
      stColor.cbSize = sizeof(CLRDLG);
      stColor.lForeground = pstCFG->lWriteReqForegrndColor;
      stColor.lBackground = pstCFG->lWriteReqBackgrndColor;
      sprintf(stColor.szCaption,"Write Request Event Display Colors");
      if (WinDlgBox(HWND_DESKTOP,
                    hWnd,
             (PFNWP)fnwpSetColorDlg,
            (USHORT)NULL,
                    CLR_DLG,
            MPFROMP(&stColor)))
        {
        pstCFG->lWriteReqForegrndColor = stColor.lForeground;
        pstCFG->lWriteReqBackgrndColor = stColor.lBackground;
        bNoPaint = FALSE;
        WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
        }
      return(FALSE);
    case IDMPU_READREQ_COLOR:
      if (pstCFG->bStickyMenus)
        usLastClientPopupItem = IDMPU_COLORS;
      else
        usLastClientPopupItem = IDMPU_EVENT_DISP;
      stColor.cbSize = sizeof(CLRDLG);
      stColor.lForeground = pstCFG->lReadReqForegrndColor;
      stColor.lBackground = pstCFG->lReadReqBackgrndColor;
      sprintf(stColor.szCaption,"Read Request Event Display Colors");
      if (WinDlgBox(HWND_DESKTOP,
                    hWnd,
             (PFNWP)fnwpSetColorDlg,
            (USHORT)NULL,
                    CLR_DLG,
            MPFROMP(&stColor)))
        {
        pstCFG->lReadReqForegrndColor = stColor.lForeground;
        pstCFG->lReadReqBackgrndColor = stColor.lBackground;
        bNoPaint = FALSE;
        WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
        }
      return(FALSE);
    case IDMPU_DEVIOCTL_COLOR:
      if (pstCFG->bStickyMenus)
        usLastClientPopupItem = IDMPU_COLORS;
      else
        usLastClientPopupItem = IDMPU_EVENT_DISP;
      stColor.cbSize = sizeof(CLRDLG);
      stColor.lForeground = pstCFG->lDevIOctlForegrndColor;
      stColor.lBackground = pstCFG->lDevIOctlBackgrndColor;
      sprintf(stColor.szCaption,"Device I/O Control Call Event Display Colors");
      if (WinDlgBox(HWND_DESKTOP,
                    hWnd,
             (PFNWP)fnwpSetColorDlg,
            (USHORT)NULL,
                    CLR_DLG,
            MPFROMP(&stColor)))
        {
        pstCFG->lDevIOctlForegrndColor = stColor.lForeground;
        pstCFG->lDevIOctlBackgrndColor = stColor.lBackground;
        bNoPaint = FALSE;
        WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
        }
      return(FALSE);
    case IDMPU_MODEMIN_COLOR:
      if (pstCFG->bStickyMenus)
        usLastClientPopupItem = IDMPU_COLORS;
      else
        usLastClientPopupItem = IDMPU_EVENT_DISP;
      stColor.cbSize = sizeof(CLRDLG);
      stColor.lForeground = pstCFG->lModemInForegrndColor;
      stColor.lBackground = pstCFG->lModemInBackgrndColor;
      sprintf(stColor.szCaption,"Modem Input Signal Event Display Colors");
      if (WinDlgBox(HWND_DESKTOP,
                    hWnd,
             (PFNWP)fnwpSetColorDlg,
            (USHORT)NULL,
                    CLR_DLG,
            MPFROMP(&stColor)))
        {
        pstCFG->lModemInForegrndColor = stColor.lForeground;
        pstCFG->lModemInBackgrndColor = stColor.lBackground;
        bNoPaint = FALSE;
        WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
        }
      return(FALSE);
    case IDMPU_MODEMOUT_COLOR:
      if (pstCFG->bStickyMenus)
        usLastClientPopupItem = IDMPU_COLORS;
      else
        usLastClientPopupItem = IDMPU_EVENT_DISP;
      stColor.cbSize = sizeof(CLRDLG);
      stColor.lForeground = pstCFG->lModemOutForegrndColor;
      stColor.lBackground = pstCFG->lModemOutBackgrndColor;
      sprintf(stColor.szCaption,"Modem Output Signal Event Display Colors");
      if (WinDlgBox(HWND_DESKTOP,
                    hWnd,
             (PFNWP)fnwpSetColorDlg,
            (USHORT)NULL,
                    CLR_DLG,
            MPFROMP(&stColor)))
        {
        pstCFG->lModemOutForegrndColor = stColor.lForeground;
        pstCFG->lModemOutBackgrndColor = stColor.lBackground;
        bNoPaint = FALSE;
        WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
        }
      return(FALSE);
    case IDMPU_ERROR_COLOR:
      if (pstCFG->bStickyMenus)
        usLastClientPopupItem = IDMPU_COLORS;
      else
        usLastClientPopupItem = IDMPU_EVENT_DISP;
      stColor.cbSize = sizeof(CLRDLG);
      stColor.lForeground = pstCFG->lErrorForegrndColor;
      stColor.lBackground = pstCFG->lErrorBackgrndColor;
      sprintf(stColor.szCaption,"Communications Error Event Display Colors");
      if (WinDlgBox(HWND_DESKTOP,
                    hWnd,
             (PFNWP)fnwpSetColorDlg,
            (USHORT)NULL,
                    CLR_DLG,
            MPFROMP(&stColor)))
        {
        pstCFG->lErrorForegrndColor = stColor.lForeground;
        pstCFG->lErrorBackgrndColor = stColor.lBackground;
        bNoPaint = FALSE;
        WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
        }
      return(FALSE);
    case IDMPU_OPEN_COLOR:
      if (pstCFG->bStickyMenus)
        usLastClientPopupItem = IDMPU_COLORS;
      else
        usLastClientPopupItem = IDMPU_EVENT_DISP;
      stColor.cbSize = sizeof(CLRDLG);
      stColor.lForeground = pstCFG->lOpenForegrndColor;
      stColor.lBackground = pstCFG->lOpenBackgrndColor;
      sprintf(stColor.szCaption,"Applicatin Open/Close Event Display Colors");
      if (WinDlgBox(HWND_DESKTOP,
                    hWnd,
             (PFNWP)fnwpSetColorDlg,
            (USHORT)NULL,
                    CLR_DLG,
            MPFROMP(&stColor)))
        {
        pstCFG->lOpenForegrndColor = stColor.lForeground;
        pstCFG->lOpenBackgrndColor = stColor.lBackground;
        bNoPaint = FALSE;
        WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
        }
      return(FALSE);
    case IDMPU_READ_COLOR:
      if (pstCFG->bStickyMenus)
        usLastClientPopupItem = IDMPU_COLORS;
      else
        usLastClientPopupItem = IDMPU_EVENT_DISP;
      stColor.cbSize = sizeof(CLRDLG);
      stColor.lForeground = pstCFG->lReadForegrndColor;
      stColor.lBackground = pstCFG->lReadBackgrndColor;
      sprintf(stColor.szCaption,"Time-relational Receive Data Display Colors");
      if (WinDlgBox(HWND_DESKTOP,
                    hWnd,
             (PFNWP)fnwpSetColorDlg,
            (USHORT)NULL,
                    CLR_DLG,
            MPFROMP(&stColor)))
        {
        pstCFG->lReadForegrndColor = stColor.lForeground;
        pstCFG->lReadBackgrndColor = stColor.lBackground;
        bNoPaint = FALSE;
        WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
        }
      return(FALSE);
    case IDMPU_WRITE_COLOR:
      if (pstCFG->bStickyMenus)
        usLastClientPopupItem = IDMPU_COLORS;
      else
        usLastClientPopupItem = IDMPU_EVENT_DISP;
      stColor.cbSize = sizeof(CLRDLG);
      stColor.lForeground = pstCFG->lWriteForegrndColor;
      stColor.lBackground = pstCFG->lWriteBackgrndColor;
      sprintf(stColor.szCaption,"Time-relational Transmit Data Display Colors");
      if (WinDlgBox(HWND_DESKTOP,
                    hWnd,
             (PFNWP)fnwpSetColorDlg,
            (USHORT)NULL,
                    CLR_DLG,
            MPFROMP(&stColor)))
        {
        pstCFG->lWriteForegrndColor = stColor.lForeground;
        pstCFG->lWriteBackgrndColor = stColor.lBackground;
        bNoPaint = FALSE;
        WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
        }
      return(FALSE);
    case IDM_TRIGGER:
      WinDlgBox(HWND_DESKTOP,
                hWnd,
         (PFNWP)fnwpTraceEventDlgProc,
        (USHORT)NULL,
                TRIG_DLG,
        MPFROMP(pstCFG));
      return(FALSE);
    case IDM_CAP_EVENT:
      WinDlgBox(HWND_DESKTOP,
                hWnd,
         (PFNWP)fnwpTraceEventDlgProc,
        (USHORT)NULL,
                TRACE_DLG,
        MPFROMP(pstCFG));
      return(FALSE);
    case IDM_STINMDM:
      WinPostMsg(hwndStatModemIn,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      return((MRESULT)FALSE);
    case IDM_STOUTMDM:
      WinPostMsg(hwndStatModemOut,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      return((MRESULT)FALSE);
    case IDM_STALL:
      WinPostMsg(hwndStatAll,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      return((MRESULT)FALSE);
    case IDM_STXMITBUF:
      WinPostMsg(hwndStatXmitBuf,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      return((MRESULT)FALSE);
    case IDM_STRCVBUFF:
      WinPostMsg(hwndStatRcvBuf,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      return((MRESULT)FALSE);
    case IDM_STDEVDRV:
      WinPostMsg(hwndStatDev,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      return((MRESULT)FALSE);
    case IDM_SAVEDAT:
      if (szDataFileSpec[0] == 0)
        {
        sprintf(szMessage,"%s - Data File to Save to",pstCFG->szPortName);
        if (!GetFileName(hWnd,szDataFileSpec,szMessage,COMscopeOpenFilterProc))
          return((MRESULT)FALSE);
        }
      if (strcmp(szEntryDataFileSpec,szDataFileSpec) != 0)
        {
        if (hProfileInstance != NULL)
          if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
            {
            if (DosQueryProcAddr(hMod,0,"SaveProfileString",(PFN *)&pfnSaveProfileString) == NO_ERROR)
              pfnSaveProfileString(hProfileInstance,"Data File",szDataFileSpec);
            DosFreeModule(hMod);
            }
        strcpy(szEntryDataFileSpec,szDataFileSpec);
        }
      if (bBufferWrapped)
        ulWordCount = pstCFG->lBufferLength;
      else
        if (lWriteIndex < pstCFG->lBufferLength)
          ulWordCount = lWriteIndex;
        else
          ulWordCount = pstCFG->lBufferLength;
      WriteCaptureFile(szDataFileSpec,pwCaptureBuffer,ulWordCount,FOPEN_NORMAL,HLPP_MB_OVERWRT_FILE);
      return((MRESULT)FALSE);
    case IDM_SAVEDATAS:
      sprintf(szMessage,"%s - Save Data As",pstCFG->szPortName);
      if (!GetFileName(hWnd,szDataFileSpec,szMessage,COMscopeOpenFilterProc))
        return((MRESULT)FALSE);
      if (strcmp(szEntryDataFileSpec,szDataFileSpec) != 0)
        {
        if (hProfileInstance != NULL)
          if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
            {
            if (DosQueryProcAddr(hMod,0,"SaveProfileString",(PFN *)&pfnSaveProfileString) == NO_ERROR)
              pfnSaveProfileString(hProfileInstance,"Data File",szDataFileSpec);
            DosFreeModule(hMod);
            }
        strcpy(szEntryDataFileSpec,szDataFileSpec);
        }
      if (bBufferWrapped)
        ulWordCount = pstCFG->lBufferLength;
      else
        if (lWriteIndex < pstCFG->lBufferLength)
          ulWordCount = lWriteIndex;
        else
          ulWordCount = pstCFG->lBufferLength;
      WriteCaptureFile(szDataFileSpec,pwCaptureBuffer,ulWordCount,FOPEN_NORMAL,HLPP_MB_OVERWRT_FILE);
      return((MRESULT)FALSE);
    case IDM_MANAGE_CFG:
      if (hProfileInstance != NULL)
        if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
          {
          if (DosQueryProcAddr(hMod,0,"ManageProfile",(PFN *)&pfnManageProfile) == NO_ERROR)
            if (pfnManageProfile(hWnd,hProfileInstance))
              StartSystem(pstCFG,TRUE);
          DosFreeModule(hMod);
          }
      break;
    case IDM_LOADDAT:
      if (!GetFileName(hWnd,szDataFileSpec,"Select file to Load.",COMscopeOpenFilterProc))
        return((MRESULT)FALSE);
      hPointer = WinQuerySysPointer(HWND_DESKTOP,SPTR_WAIT,FALSE);
      WinSetPointer(HWND_DESKTOP,hPointer);
      if (strcmp(szEntryDataFileSpec,szDataFileSpec) != 0)
        {
        if (hProfileInstance != NULL)
          if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
            {
            if (DosQueryProcAddr(hMod,0,"SaveProfileString",(PFN *)&pfnSaveProfileString) == NO_ERROR)
              pfnSaveProfileString(hProfileInstance,"Data File",szDataFileSpec);
            DosFreeModule(hMod);
            }
        strcpy(szEntryDataFileSpec,szDataFileSpec);
        }
      ulWordCount = pstCFG->lBufferLength;
      if (pwScrollBuffer != NULL)
        DosFreeMem(pwScrollBuffer);
      if (DosAllocMem((PPVOID)&pwScrollBuffer,(ulWordCount * 2),PAG_COMMIT | PAG_READ | PAG_WRITE) == NO_ERROR)
        {
        if (ReadCaptureFile(szDataFileSpec,&pwScrollBuffer,&ulWordCount,FOPEN_AUTO_ALLOC))
          {
          lWriteIndex = ulWordCount;
          lScrollCount = ulWordCount;
          pstCFG->fDisplaying |= DISP_FILE;
          MenuItemCheck(hwndFrame,IDM_VIEWDAT,FALSE);
          MenuItemEnable(hwndFrame,IDM_VIEWDAT,FALSE);
          MenuItemEnable(hwndFrame,IDM_SAVEDAT,FALSE);
          MenuItemEnable(hwndFrame,IDM_SAVEDATAS,FALSE);
          goto gtViewData;
          }
        DosFreeMem(pwScrollBuffer);
        pwScrollBuffer = NULL;
        }
      else
        {
        sprintf(szMessage,"Unable to allocate Scroll Buffer (Loading Data).");
        ErrorNotify(szMessage);
        }
      WinDestroyPointer(hPointer);
      break;
    case IDM_VIEWDAT:
      if (pstCFG->fDisplaying & DISP_DATA)
        {
        if (pstCFG->bColumnDisplay)
          {
          WinSendMsg(stRead.hwndClient,UM_HIDEWIN,0L,0L);
          WinSendMsg(stWrite.hwndClient,UM_HIDEWIN,0L,0L);
          }
        else
          ClearRowScrollBar(&stRow);
        if (pwScrollBuffer != NULL)
          DosFreeMem(pwScrollBuffer);
        pstCFG->fDisplaying = 0;
        MenuItemCheck(hwndFrame,IDM_VIEWDAT,FALSE);
        }
      else
        {
        KillDisplayThread();
        KillMonitorThread();
        pstCFG->bMonitoringStream = FALSE;
        if (bBufferWrapped)
          lScrollCount = pstCFG->lBufferLength;
        else
          lScrollCount = lWriteIndex;
        if (pwScrollBuffer != NULL)
          DosFreeMem(pwScrollBuffer);
        if (DosAllocMem((PPVOID)&pwScrollBuffer,(lScrollCount * 2),(PAG_COMMIT | PAG_READ | PAG_WRITE)) == NO_ERROR)
          {
          if (bBufferWrapped)
            {
            ulWordCount = lScrollCount - lWriteIndex;
            memcpy(pwScrollBuffer,&pwCaptureBuffer[lWriteIndex],(ulWordCount * 2));
            memcpy(&pwScrollBuffer[ulWordCount],pwCaptureBuffer,(lWriteIndex * 2));
            }
          else
            memcpy(pwScrollBuffer,pwCaptureBuffer,(lScrollCount * 2));
          }
        else
          {
          sprintf(szMessage,"Unable to allocate Scroll Buffer (View Data).");
          ErrorNotify(szMessage);
          break;
          }
        pstCFG->fDisplaying |= DISP_DATA;
        MenuItemCheck(hwndFrame,IDM_VIEWDAT,TRUE);
gtViewData:
        stRead.lScrollIndex = 0;
        stRead.lScrollRow = 0;
        stWrite.lScrollIndex = 0;
        stWrite.lScrollRow = 0;
        stRow.lScrollIndex = 0;
        stRow.lScrollRow = 0;
        MenuItemEnable(hwndFrame,IDM_SEARCH,TRUE);
        MenuItemEnable(hwndFrame,IDM_SEARCH_NEXT,TRUE);
        MenuItemEnable(hwndFrame,IDM_QUERY_INDEX,TRUE);
        if (pstCFG->bColumnDisplay)
          {
          WinSendMsg(stWrite.hwndClient,UM_SHOWAGAIN,0L,0L);
          WinSendMsg(stRead.hwndClient,UM_SHOWAGAIN,0L,0L);
          ClearRowScrollBar(&stRow);
          if (!pstCFG->bSyncToWrite)
            SetupColScrolling(&stRead);
          if (!pstCFG->bSyncToRead)
            SetupColScrolling(&stWrite);
          WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
          WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
          }
        else
          {
          WinSendMsg(stWrite.hwndClient,UM_HIDEWIN,0L,0L);
          WinSendMsg(stRead.hwndClient,UM_HIDEWIN,0L,0L);
          SetupRowScrolling(&stRow);
          WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
          }
        }
      return((MRESULT)FALSE);
    case IDM_MDISPLAY:
      if (KillDisplayThread())
        {
        pstCFG->fDisplaying = 0;
        if (pstCFG->ulUserSleepCount == 0)
          ulMonitorSleepCount = ulCalcSleepCount;
        MenuItemCheck(hwndFrame,IDM_MDISPLAY,FALSE);
        }
      else
        {
        if (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE))
          {
          if (pstCFG->bColumnDisplay)
            {
            ClearColScrollBar(&stRead);
            ClearColScrollBar(&stWrite);
            }
          else
            ClearRowScrollBar(&stRow);
          }
        if (pstCFG->bColumnDisplay)
          {
          WinSendMsg(stWrite.hwndClient,UM_SHOWNEW,0L,0L);
          WinSendMsg(stRead.hwndClient,UM_SHOWNEW,0L,0L);
          }
        else
          WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
        pstCFG->fDisplaying = DISP_STREAM;
        MenuItemCheck(hwndFrame,IDM_MDISPLAY,TRUE);
        if (pstCFG->ulUserSleepCount != 0)
          ulMonitorSleepCount = pstCFG->ulUserSleepCount;
        else
          ulMonitorSleepCount = 200;
        stRow.lLeadIndex = 0;
        bStopDisplayThread = FALSE;
        if (pstCFG->bColumnDisplay)
          DosCreateThread(&tidDisplayThread,(PFNTHREAD)ColumnDisplayThread,0L,0L,4096);
        else
          DosCreateThread(&tidDisplayThread,(PFNTHREAD)RowDisplayThread,0L,0L,4096);
        DosPostEventSem(hevWaitCOMiDataSem);
        WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
        }
      return((MRESULT)FALSE);
    case IDM_MSTREAM:
      KillDisplayThread();
      if (!KillMonitorThread())
        {
        MenuItemEnable(hwndFrame,IDM_SEARCH,FALSE);
        MenuItemEnable(hwndFrame,IDM_SEARCH_NEXT,FALSE);
        MenuItemEnable(hwndFrame,IDM_QUERY_INDEX,FALSE);
        if (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE))
          {
          if (pstCFG->bColumnDisplay)
            {
//            WinSendMsg(stWrite.hwndClient,UM_SHOWNEW,0L,0L);
//            WinSendMsg(stRead.hwndClient,UM_SHOWNEW,0L,0L);
            ClearColScrollBar(&stRead);
            ClearColScrollBar(&stWrite);
            WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
            WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
            }
          else
            {
            ClearRowScrollBar(&stRow);
//            WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
            }
          }
        if (pstCFG->bColumnDisplay)
          {
          WinSendMsg(stWrite.hwndClient,UM_SHOWNEW,0L,0L);
          WinSendMsg(stRead.hwndClient,UM_SHOWNEW,0L,0L);
          }
        else
          WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
        if (pstCFG->bCaptureToFile)
          {
          if (szCaptureFileName[0] == 0)
            {
            strcpy(szCaptureFileName,szCaptureFileSpec);
            IncrementFileExt(szCaptureFileName,TRUE);
            }
          strcpy(szTempPath,szCaptureFileName);
          if (!WriteCaptureFile(szCaptureFileName,pwCaptureBuffer,0,FOPEN_NORMAL,HLPP_MB_OVERWRT_FILE))
            return(FALSE);
          if (strcmp(szTempPath,szCaptureFileName) != 0)
            {
            strcpy(szCaptureFileSpec,szCaptureFileName);
            IncrementFileExt(szCaptureFileSpec,TRUE);
            szCaptureFileSpec[strlen(szCaptureFileSpec) - 4] = 0;
            if (hProfileInstance != NULL)
              if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
                {
                if (DosQueryProcAddr(hMod,0,"SaveProfileString",(PFN *)&pfnSaveProfileString) == NO_ERROR)
                  pfnSaveProfileString(hProfileInstance,"Capture File",szCaptureFileSpec);
                DosFreeModule(hMod);
                }
            strcpy(szEntryCaptureFileSpec,szCaptureFileSpec);
            }
          }
        pstCFG->bMonitoringStream = TRUE;
        bStopMonitorThread = FALSE;
        DosCreateThread(&tidMonitorThread,(PFNTHREAD)MonitorThread,(ULONG)hCom,0L,4096);
        if (pstCFG->fDisplaying & DISP_STREAM)
          {
          pstCFG->fDisplaying = DISP_STREAM;
          if (pstCFG->ulUserSleepCount != 0)
            ulMonitorSleepCount = pstCFG->ulUserSleepCount;
          else
            if (ulMonitorSleepCount > 200)
              ulMonitorSleepCount = 200;
          DosPostEventSem(hevWaitCOMiDataSem);
          stRow.lLeadIndex = 0;
          bStopDisplayThread = FALSE;
          if (pstCFG->bColumnDisplay)
            DosCreateThread(&tidDisplayThread,(PFNTHREAD)ColumnDisplayThread,0L,0L,4096);
          else
            DosCreateThread(&tidDisplayThread,(PFNTHREAD)RowDisplayThread,0L,0L,4096);
          WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
          }
        else
          pstCFG->fDisplaying = 0;
        }
      else
        pstCFG->bMonitoringStream = FALSE;
      return((MRESULT)FALSE);
    case IDM_SHOWCOUNTS:
      WinDlgBox(HWND_DESKTOP,hWnd,(PFNWP)fnwpCountsSetupDlgProc,0,DLG_COUNTS,MPFROMP(pstCFG));
      break;
    case IDM_SENDBRK:
      if (!bBreakOn)
        {
        MenuItemCheck(hwndFrame,IDM_SENDBRK,TRUE);
        bBreakOn = TRUE;
        BreakOn(&stIOctl,hCom,&wStatus);
        }
      else
        {
        MenuItemCheck(hwndFrame,IDM_SENDBRK,FALSE);
        bBreakOn = FALSE;
        BreakOff(&stIOctl,hCom,&wStatus);
        }
      return((MRESULT)FALSE);
    case IDM_SENDIMM:
      if (!bSendNextKeystroke)
        {
        bSendNextKeystroke = TRUE;
        MenuItemCheck(hwndFrame,IDM_SENDIMM,TRUE);
        }
      return((MRESULT)FALSE);
    case IDM_OUT1:
      WinDlgBox(HWND_DESKTOP,hWnd,(PFNWP)fnwpHdwModemControlDlg,0,HWM_DLG,MPFROMP(pstCFG));
      break;
    case IDM_FXON:
      ForceXon(&stIOctl,hCom);
      return((MRESULT)FALSE);
    case IDM_FXOFF:
      ForceXoff(&stIOctl,hCom);
      return((MRESULT)FALSE);
    case IDM_SXON:
      SendXonXoff(SEND_XON);
      return((MRESULT)FALSE);
    case IDM_SXOFF:
      SendXonXoff(SEND_XOFF);
      return((MRESULT)FALSE);
    case IDM_FINPUT:
      FlushComBuffer(&stIOctl,hCom,INPUT);
      return((MRESULT)FALSE);
    case IDM_FOUTPUT:
      FlushComBuffer(&stIOctl,hCom,OUTPUT);
      return((MRESULT)FALSE);
    case IDM_FBOTH:
      FlushComBuffer(&stIOctl,hCom,INPUT);
      FlushComBuffer(&stIOctl,hCom,OUTPUT);
      return((MRESULT)FALSE);
    case IDM_BAUDRATE:
      if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
        {
        if (DosQueryProcAddr(hMod,0,"HdwBaudRateDialog",(PFN *)&pfnDialog) == NO_ERROR)
          {
//          MessageBox(hWnd,"Calling \"HdwBaudRateDialog\"");
          stComCtl.hwndHelpInstance = hwndHelpInstance;
          stComCtl.usHelpId = HLPP_BAUD_DLG;
          pfnDialog(hWnd,&stComCtl);
          }
        else
          MessageBox(hWnd,"COM control function \"HdwBaudRateDialog\" not found");
        DosFreeModule(hMod);
        }
      else
        MessageBox(hWnd,"Unable to load COM control library");
      break;
    case IDM_PROTO:
      if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
        {
        if (DosQueryProcAddr(hMod,0,"HdwProtocolDialog",(PFN *)&pfnDialog) == NO_ERROR)
          {
          stComCtl.hwndHelpInstance = hwndHelpInstance;
          stComCtl.usHelpId = HLPP_LINE_PROTOCOL_DLG;
          pfnDialog(hWnd,&stComCtl);
          }
        else
          MessageBox(hWnd,"COM control function \"HdwProtocolDialog\" not found");
        DosFreeModule(hMod);
        }
      else
        MessageBox(hWnd,"Unable to load COM control library");
      break;
    case IDM_FILTER:
      if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
        {
        if (DosQueryProcAddr(hMod,0,"HdwFilterDialog",(PFN *)&pfnDialog) == NO_ERROR)
          {
          stComCtl.hwndHelpInstance = hwndHelpInstance;
          stComCtl.usHelpId = HLPP_FILTER_DLG;
          pfnDialog(hWnd,&stComCtl);
          }
        else
          MessageBox(hWnd,"COM control function \"HdwFilterDialog\" not found");
        DosFreeModule(hMod);
        }
      else
        MessageBox(hWnd,"Unable to load COM control library");
      break;
    case IDM_FIFO:
      if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
      {
        if (DosQueryProcAddr(hMod,0,"HdwFIFOsetupDialog",(PFN *)&pfnDialog) == NO_ERROR)
          {
          stComCtl.hwndHelpInstance = hwndHelpInstance;
          stComCtl.usHelpId = HLPP_FIFO_DLG;
          pfnDialog(hWnd,&stComCtl);
          }
        else
          MessageBox(hWnd,"COM control function \"HdwFIFOsetupDialog\" not found");
        DosFreeModule(hMod);
        }
      else
        MessageBox(hWnd,"Unable to load COM control library");
      break;
    case IDM_HANDSHAKE:
      if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
        {
        if (DosQueryProcAddr(hMod,0,"HdwHandshakeDialog",(PFN *)&pfnDialog) == NO_ERROR)
          {
          stComCtl.hwndHelpInstance = hwndHelpInstance;
          stComCtl.usHelpId = HLPP_HANDSHAKE_DLG;
          pfnDialog(hWnd,&stComCtl);
          }
        else
          MessageBox(hWnd,"COM control function \"HdwHandshakeDialog\" not found");
        DosFreeModule(hMod);
        }
      else
        MessageBox(hWnd,"Unable to load COM control library");
      break;
    case IDM_TIMEOUT:
      if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
        {
        if (DosQueryProcAddr(hMod,0,"HdwTimeoutDialog",(PFN *)&pfnDialog) == NO_ERROR)
          {
          stComCtl.hwndHelpInstance = hwndHelpInstance;
          stComCtl.usHelpId = HLPP_TIMEOUT_DLG;
          pfnDialog(hWnd,&stComCtl);
          }
        else
          MessageBox(hWnd,"COM control function \"HdwTimeoutDialog\" not found");
        DosFreeModule(hMod);
        }
      else
        MessageBox(hWnd,"Unable to load COM control library");
      break;
    case IDM_QUERY_INDEX:
      if (!pstCFG->bColumnDisplay && (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE)))
        DisplayCharacterInfo(hWnd,0);
      return(FALSE);
    case IDM_SEARCH_NEXT:
      ErrorNotify("  ");
      if (!(pstCFG->fDisplaying & (DISP_DATA | DISP_FILE)))
        break;
      if (bSearchInit)
        {
        if ((lFoundIndex = SearchCaptureBuffer(pwScrollBuffer,lScrollCount)) == -1)
          {
          sprintf(szMessage,"Pattern not Found");
          ErrorNotify(szMessage);
          }
        else
//          if (pstCFG->bShowCounts)
            {
            sprintf(szMessage,"Pattern found at Index %u",lFoundIndex);
            ErrorNotify(szMessage);
            }
        break;
        }
    case IDM_SEARCH:
      ErrorNotify("  ");
      if (!(pstCFG->fDisplaying & (DISP_DATA | DISP_FILE)))
        break;
      if (WinDlgBox(HWND_DESKTOP,hWnd,(PFNWP)fnwpSearchConfigDlgProc,0,FIND_DLG,MPFROMP(pstCFG)))
        {
        if ((lFoundIndex = SearchCaptureBuffer(pwScrollBuffer,lScrollCount)) == -1)
          {
          sprintf(szMessage,"Pattern not Found");
          ErrorNotify(szMessage);
          }
        else
//          if (pstCFG->bShowCounts)
            {
            sprintf(szMessage,"Pattern found at Index %u",lFoundIndex);
            ErrorNotify(szMessage);
            }
        }
      break;
    case IDM_MSLEEP:
      WinDlgBox(HWND_DESKTOP,hWnd,(PFNWP)fnwpMonitorSleepDlg,0,MSLEEP_DLG,MPFROMP(pstCFG));
      break;
    case IDM_HELPABOUT:
      WinDlgBox(HWND_DESKTOP,hWnd,(PFNWP)AboutBoxDlgProc,0,DLG_ABOUTBOX,MPFROMP(pstCFG));
      break;
    case IDM_STUPDATE:
      WinDlgBox(HWND_DESKTOP,hWnd,(PFNWP)fnwpUpdateStatusDlg,0,HWSUD_DLG,MPFROMP(pstCFG));
      break;
    case IDM_BUFFSIZE:
      WinDlgBox(HWND_DESKTOP,hWnd,(PFNWP)fnwpBufferSizeDlg,0,BSZ_DLG,MPFROMP(pstCFG));
      break;
    case IDM_SSELECT:
      SelectDevice(hWnd,pstCFG);
      break;
    default:
      return((MRESULT)FALSE);
    }
  WinInvalidateRect(hWnd, NULL, FALSE );/* Update client area        */
  return(FALSE);
  }

void SelectDevice(HWND hwnd,CSCFG *pstCFG)
  {
  DCB stDCB;
  HMODULE hMod;
  char szMessage[100];
  char szCaption[40];
  char szPortName[20];
  APIRET rc;

#ifdef this_junk
  if (bRemoteClient)
    {
    stPipeCmd.cbMsgSize = sizeof(PIPECMD);
    stPipeCmd.ulCommand = UM_REM_DEVICE_LIST;
    rc = DosCallNPipe(szCOMscopePipe,&stPipeCmd,sizeof(PIPECMD),&stPipeMsg,sizeof(PIPEMSG),&ulBytesRead,10000);
    iDeviceCount = stPipeMsg.Data.wData;
    if (stPipeMsg.ulCommand == UM_PIPE_ACK)
      {
      bDevicesAvail = TRUE;
      pListItem = stCOMiCFG.pstDeviceList;
      pNames = &stPipeMsg.Data.abyData[2];
      for (wIndex = 0;wIndex < (WORD)stPipeMsg.Data.wData;wIndex++)
        {
        AddListItem(pListItem,pNames,8);
        pNames += 8;
        }
      }
    else
      if (stPipeMsg.ulCommand == UM_PIPE_NAK)
        bDevicesAvail = FALSE;
      else
        ErrorNotify("Bad response from remote session");
    }
#endif
  if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) == NO_ERROR)
    {
    if (DosQueryProcAddr(hMod,0,"PortSelectDialog",(PFN *)&pfnDialog) == NO_ERROR)
      {
      stCOMiCFG.bEnumCOMscope = TRUE;
      strcpy(szPortName,pstCFG->szPortName);
      stCOMiCFG.pszPortName = szPortName;
      stCOMiCFG.bPortActive = bPortActive;
      rc = pfnDialog(hwnd,&stCOMiCFG);
      switch (rc)
        {
        case PORT_SELECTED:
          if ((strcmp(szPortName,pstCFG->szPortName) != 0) || (hCom == 0xffffffff))
            {
            strcpy(pstCFG->szPortName,szPortName);
            KillDisplayThread();
            KillMonitorThread();
            pstCFG->bMonitoringStream = FALSE;
            WinSendMsg(hwndStatAll,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0L);
            MenuItemEnable(hwndFrame,IDM_SETUP,FALSE);
            MenuItemEnable(hwndFrame,IDM_STATUS,FALSE);
            MenuItemEnable(hwndFrame,IDM_IOCTL,FALSE);
            if (hCom != 0xffffffff)
              {
              DosClose(hCom);
              hCom = -1;
              }
            if (!OpenPort(hwndFrame,&hCom,pstCFG))
              {
              pstCFG->szPortName[0] = 0;
              WinSendMsg(hwndStatDev,UM_KILL_MONITOR,0L,(MPARAM)0L);
              WinSendMsg(hwndStatRcvBuf,UM_KILL_MONITOR,0L,(MPARAM)0L);
              WinSendMsg(hwndStatXmitBuf,UM_KILL_MONITOR,0L,(MPARAM)0L);
              WinSendMsg(hwndStatModemIn,UM_KILL_MONITOR,0L,(MPARAM)0L);
              WinSendMsg(hwndStatModemOut,UM_KILL_MONITOR,0L,(MPARAM)0L);
              WinDismissDlg(hwnd,TRUE);
              }
            else
              {
              WinSendMsg(hwndStatDev,UM_RESET_NAME,0L,(MPARAM)0L);
              WinSendMsg(hwndStatRcvBuf,UM_RESET_NAME,0L,(MPARAM)0L);
              WinSendMsg(hwndStatXmitBuf,UM_RESET_NAME,0L,(MPARAM)0L);
              WinSendMsg(hwndStatModemIn,UM_RESET_NAME,0L,(MPARAM)0L);
              WinSendMsg(hwndStatModemOut,UM_RESET_NAME,0L,(MPARAM)0L);
              if (GetDCB(&stIOctl,hCom,&stDCB) == NO_ERROR)
                {
                MenuItemEnable(hwndFrame,IDM_MSTREAM,TRUE);
                MenuItemEnable(hwndFrame,IDM_SETUP,TRUE);
                MenuItemEnable(hwndFrame,IDM_STATUS,TRUE);
                MenuItemEnable(hwndFrame,IDM_IOCTL,TRUE);
                if ((stDCB.Flags3 & F3_HDW_BUFFER_APO) == 0) // mask only
                  MenuItemEnable(hwndFrame,IDM_FIFO,FALSE);
                else
                  MenuItemEnable(hwndFrame,IDM_FIFO,TRUE);
                sprintf(szCaption,"COMscope -> %s",pstCFG->szPortName);
                strcpy(szCurrentPortName,pstCFG->szPortName);
                WinSetWindowText(hwndFrame,szCaption);
                }
              }
            }
          break;
        case NO_COMSCOPE_AVAIL:
          sprintf(szCaption,"No Available COMscope Devices");
          sprintf(szMessage,"All COMscope accessable ports have been activated by other COMscope sessions.");
          WinMessageBox(HWND_DESKTOP,
                        hwndFrame,
                        szMessage,
                        szCaption,
                        HLPP_MB_NO_COMSCOPE_LEFT,
                        (MB_OK | MB_HELP | MB_ICONEXCLAMATION));
          break;
        case NO_PORT_AVAILABLE:
          sprintf(szCaption,"No COM Devices Defined");
          sprintf(szMessage,"Select \"Device | Device Install\" to install COM support");
          WinMessageBox(HWND_DESKTOP,
                        hwndFrame,
                        szMessage,
                        szCaption,
                        HLPP_MB_NO_COMSCOPE_LEFT,
                        (MB_OK | MB_HELP | MB_ICONEXCLAMATION));
          break;
        default:
          break;
        }
      }
    DosFreeModule(hMod);
    }
  }

