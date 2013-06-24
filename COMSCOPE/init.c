#include "COMscope.h"

extern PRF_GETSTR pfnGetProfileString;
extern CFG_FILLLIST pfnFillDeviceNameList;

extern COMICFG stCOMiCFG;
extern COMCTL stComCtl;
extern IOCTLINST stIOctl;

extern BOOL bCOMscopeEnabled;

extern BOOL bRemoteServer;

extern LONG lYScr;
extern LONG lYfullScr;
extern LONG lcyBrdr;
extern LONG lXScr;
extern LONG lXfullScr;
extern LONG lcxVSc;
extern LONG lcxBrdr;
extern LONG lcyMenu;
extern LONG lcyTitleBar;

extern LONG lStatusHeight;

extern SWP swpLastPosition;

extern BOOL bSkipInitPos;

extern CHARCELL stCell;

extern HAB habAnchorBlock;
extern HWND hwndFrame;
extern HWND hwndClient;
extern char szDriverIniPath[];
BOOL bDriverNotLoaded = FALSE;
extern char szDriverIniPath[];
extern CHAR szDriverVersionString[];
extern CHAR szTitle[];

extern CSCFG stCFG;
extern HEV hevWaitCOMiDataSem;

extern char szDataFileSpec[];
extern char szCaptureFileSpec[];
extern char szCaptureFileName[];

extern WORD *pwCaptureBuffer;
extern WORD *pwScrollBuffer;
extern HPROF hProfileInstance;

extern LONG lWriteIndex;
extern LONG lScrollCount;

extern SCREEN stRead;
extern SCREEN stWrite;
extern SCREEN stRow;

extern BOOL bLaunchShutdownServer;
extern BOOL bStopMonitorThread;
extern BOOL bStopDisplayThread;
extern ULONG ulMonitorSleepCount;
extern ULONG ulCalcSleepCount;
extern TID tidMonitorThread;
extern TID tidDisplayThread;

extern WORD wASCIIfont;
extern WORD wHEXfont;

extern BOOL fLastSize;
extern LONG lLastHeight;
extern LONG lLastWidth;
extern BOOL bBufferWrapped;

extern BOOL bCommandLineDataFile;
BOOL bBreakOn;

char szCurrentPortName[20];

BOOL InitializeSystem(void)
  {
  ULONG ulAction;
  char szCaption[80];
  char szMessage[300];
//  PFN pfnProcess;
  HMODULE hMod;

  if (DosOpen(SPECIAL_DEVICE,&hCom,&ulAction,0L,0L,0x0001,0x21c2,0L) != 0)
    {
    bDriverNotLoaded = TRUE;
    if (!bRemoteServer)
      {
      sprintf(szCaption,"COMi Device Driver not loaded");
      sprintf(szMessage,"You will only be able to configure (install) devices for a future OS/2 session.\n\nDo you Still want to run COMscope?");
      if (WinMessageBox(HWND_DESKTOP,
                      hwndFrame,
                      szMessage,
                      szCaption,
                      HLPP_MB_NO_COMI,
                      (MB_MOVEABLE | MB_YESNO | MB_HELP| MB_ICONQUESTION | MB_DEFBUTTON2)) != MBID_YES)
        return(FALSE);
      }
    MenuItemEnable(hwndFrame,IDM_SSELECT,FALSE);
    MenuItemEnable(hwndFrame,IDM_OPTION,FALSE);
    MenuItemEnable(hwndFrame,IDM_ACTION,FALSE);
    stCFG.bMonitoringStream = FALSE;
    WinShowWindow(hwndFrame,TRUE);
    }
  else
    {
    DosClose(hCom);
    hCom = 0xffffffff;
    if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) == NO_ERROR)
      {
      if (DosQueryProcAddr(hMod,0,"FillDeviceNameList",(PFN *)&pfnFillDeviceNameList) == NO_ERROR)
        {
        stCOMiCFG.pszPortName = stCFG.szPortName;
        stCOMiCFG.bEnumCOMscope = TRUE;
        stCOMiCFG.cbDevList = 0;
        if (pfnFillDeviceNameList(&stCOMiCFG) == 0)
          {
          if (!bRemoteServer)
            {
            sprintf(szCaption,"No Available COMscope Devices");
            if (stCOMiCFG.iDeviceCount != 0)
              {
              sprintf(szMessage,"There are no COMi controlled COM ports available for COMscope access.");
              WinMessageBox(HWND_DESKTOP,
                            hwndFrame,
                            szMessage,
                            szCaption,
                            HLPP_MB_NO_COMSCOPE_AVAIL,
                            (MB_OK | MB_HELP | MB_ICONEXCLAMATION));
              }
            else
              {
              sprintf(szMessage,"There are no COMi controlled serial ports defined.");
              WinMessageBox(HWND_DESKTOP,
                            hwndFrame,
                            szMessage,
                            szCaption,
                            HLPP_MB_NO_COMSCOPE,
                            (MB_OK | MB_HELP | MB_ICONEXCLAMATION));
              }
            }
          MenuItemEnable(hwndFrame,IDM_SSELECT,FALSE);
          MenuItemEnable(hwndFrame,IDM_MSLEEP,FALSE);
          MenuItemEnable(hwndFrame,IDM_BUFFSIZE,FALSE);
          MenuItemEnable(hwndFrame,IDM_ACTION,FALSE);
          MenuItemEnable(hwndFrame,IDM_SETUP,FALSE);
          MenuItemEnable(hwndFrame,IDM_IOCTL,FALSE);
          MenuItemEnable(hwndFrame,IDM_STATUS,FALSE);
          MenuItemEnable(hwndFrame,IDM_SAVEDATAS,FALSE);
          MenuItemEnable(hwndFrame,IDM_SAVEDAT,FALSE);
          stCFG.szPortName[0] = 0;
          stCFG.bMonitoringStream = FALSE;
          WinShowWindow(hwndFrame,TRUE);
          DosFreeModule(hMod);
          return(TRUE);
          }
        }
      DosFreeModule(hMod);
      }
    MenuItemEnable(hwndFrame,IDM_MDISPLAY,FALSE);
    MenuItemEnable(hwndFrame,IDM_MSTREAM,FALSE);
    }
  MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,FALSE);
  MenuItemEnable(hwndFrame,IDM_VIEWDAT,FALSE);
  MenuItemEnable(hwndFrame,IDM_SAVEDAT,FALSE);
  MenuItemEnable(hwndFrame,IDM_SAVEDATAS,FALSE);
  MenuItemEnable(hwndFrame,IDM_MSLEEP,FALSE);
  MenuItemEnable(hwndFrame,IDM_SETUP,FALSE);
  MenuItemEnable(hwndFrame,IDM_IOCTL,FALSE);
  MenuItemEnable(hwndFrame,IDM_STATUS,FALSE);
  StartSystem(&stCFG,FALSE);
  WinShowWindow(hwndFrame,TRUE);
  WinSetFocus(HWND_DESKTOP,hwndFrame);
  WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
  WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
  return(TRUE);
  }

void StartSystem(CSCFG *pstCFG,BOOL bRestart)
  {
  ULONG ulWordCount;
  char szCaption[80];
  char szMessage[80];
  LONG fWriteMode;
  HMODULE hMod;
  BOOL bPortAvailable;

  KillDisplayThread();
  KillMonitorThread();

  if (pwCaptureBuffer != NULL)
    DosFreeMem(pwCaptureBuffer);
  DosAllocMem((PPVOID)&pwCaptureBuffer,(pstCFG->lBufferLength * 2),(PAG_COMMIT | PAG_READ | PAG_WRITE));

  if (hProfileInstance != NULL)
    if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
      {
      if (DosQueryProcAddr(hMod,0,"GetProfileString",(PFN *)&pfnGetProfileString) == NO_ERROR)
        {
        pfnGetProfileString(hProfileInstance,"Data File",szDataFileSpec,CCHMAXPATH);
        pfnGetProfileString(hProfileInstance,"Capture File",szCaptureFileSpec,CCHMAXPATH);
        }
      DosFreeModule(hMod);
      }

  if (!pstCFG->bColumnDisplay)
    MenuItemCheck(hwndFrame,IDM_ROWS,TRUE);
  else
    MenuItemCheck(hwndFrame,IDM_COLUMNS,TRUE);
  stRow.hwndClient = hwndClient;
  if ((stWrite.bTestNewLine = pstCFG->bWriteTestNewLine) == TRUE)
    stWrite.bWrap = pstCFG->bWriteWrap;
  else
    stWrite.bWrap = TRUE;
  stWrite.bSkipBlankLines = pstCFG->bSkipWriteBlankLines;
  stWrite.byNewLineChar = pstCFG->byWriteNewLineChar;
  stWrite.bFilter = pstCFG->bFilterWrite;
  stWrite.fFilterMask = pstCFG->fFilterWriteMask;
  stWrite.byDisplayMask = pstCFG->byWriteMask;
  stWrite.lBackgrndColor = pstCFG->lWriteColBackgrndColor;
  stWrite.lForegrndColor = pstCFG->lWriteColForegrndColor;
  stWrite.bSync = pstCFG->bSyncToWrite;
  if ((stRead.bTestNewLine = pstCFG->bReadTestNewLine) == TRUE)
    stRead.bWrap = pstCFG->bReadWrap;
  else
    stRead.bWrap = TRUE;
  stRead.bSkipBlankLines = pstCFG->bSkipReadBlankLines;
  stRead.byNewLineChar = pstCFG->byReadNewLineChar;
  stRead.bFilter = pstCFG->bFilterRead;
  stRead.fFilterMask = pstCFG->fFilterReadMask;
  stRead.byDisplayMask = pstCFG->byReadMask;
  stRead.lBackgrndColor = pstCFG->lReadColBackgrndColor;
  stRead.lForegrndColor = pstCFG->lReadColForegrndColor;
  stRead.bSync = pstCFG->bSyncToRead;
  if ((hProfileInstance != NULL) && pstCFG->bLoadWindowPosition && !bRestart && !bSkipInitPos)
    {
    swpLastPosition.x = pstCFG->ptlFramePos.x;
    swpLastPosition.y = pstCFG->ptlFramePos.y;
    swpLastPosition.cx = pstCFG->ptlFrameSize.x;
    swpLastPosition.cy = pstCFG->ptlFrameSize.y;
    WinSetWindowPos(hwndFrame,HWND_TOP,pstCFG->ptlFramePos.x,
                                       pstCFG->ptlFramePos.y,
                                       pstCFG->ptlFrameSize.x,
                                       pstCFG->ptlFrameSize.y,
                                      (SWP_MOVE | SWP_SIZE));
    }
  bSkipInitPos = FALSE;
  if (pstCFG->fDisplaying & DISP_DATA)
    pstCFG->fDisplaying = 0;
  MenuItemEnable(hwndFrame,IDM_SEARCH,FALSE);
  MenuItemEnable(hwndFrame,IDM_SEARCH_NEXT,FALSE);
  MenuItemEnable(hwndFrame,IDM_QUERY_INDEX,FALSE);
  if (pstCFG->bLoadMonitor)
    {
    if (pstCFG->fDisplaying & DISP_FILE)
      {
      pstCFG->fDisplaying = DISP_FILE;
      ulWordCount = pstCFG->lBufferLength;
      if (pwScrollBuffer != NULL)
        DosFreeMem(pwScrollBuffer);
      MenuItemEnable(hwndFrame,IDM_VIEWDAT,FALSE);
      if (DosAllocMem((PPVOID)&pwScrollBuffer,(ulWordCount * 2),(PAG_COMMIT | PAG_READ | PAG_WRITE)) == NO_ERROR)
        {
        if (ReadCaptureFile(szDataFileSpec,&pwScrollBuffer,&ulWordCount,TRUE))
          {
          MenuItemEnable(hwndFrame,IDM_SEARCH,TRUE);
          MenuItemEnable(hwndFrame,IDM_SEARCH_NEXT,TRUE);
          lWriteIndex = ulWordCount;
          lScrollCount = ulWordCount;
          if (pstCFG->bColumnDisplay)
            {
            ClearRowScrollBar(&stRow);
            stRead.lScrollIndex = pstCFG->lReadColScrollIndex;
            stWrite.lScrollIndex = pstCFG->lWriteColScrollIndex;
            WinSendMsg(stWrite.hwndClient,UM_SHOWAGAIN,0L,0L);
            WinSendMsg(stRead.hwndClient,UM_SHOWAGAIN,0L,0L);
            }
          else
            {
            WinSendMsg(stWrite.hwndClient,UM_HIDEWIN,0L,0L);
            WinSendMsg(stRead.hwndClient,UM_HIDEWIN,0L,0L);
            DosSleep(100);
            SetupRowScrolling(&stRow);
            }
          pstCFG->bMonitoringStream = FALSE;
          }
        else
          {
          DosFreeMem(pwScrollBuffer);
          pwScrollBuffer = NULL;
          }
        }
      else
        ErrorNotify("Unable to allocate Scroll Buffer (Auto Loading Data).");
      }
    if (pstCFG->szPortName[0] != 0)
      {
      if (bRestart)
        {
        if (strcmp(szCurrentPortName,stCFG.szPortName) == 0)
//          if (hCom != 0xffffffff)
            {
            DosClose(hCom);
            hCom = 0xffffffff;
            }
        if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) == NO_ERROR)
          {
          stCOMiCFG.pszPortName = stCFG.szPortName;
          stCOMiCFG.bEnumCOMscope = TRUE;
          stCOMiCFG.bFindCOMscope = TRUE;
          stCOMiCFG.cbDevList = 0;
          if (DosQueryProcAddr(hMod,0,"FillDeviceNameList",(PFN *)&pfnFillDeviceNameList) == NO_ERROR)
            bPortAvailable = pfnFillDeviceNameList(&stCOMiCFG);
          DosFreeModule(hMod);
          }
        }
      if (!bPortAvailable)
        {
        if (!bRemoteServer)
          {
          sprintf(szCaption,"Port Not Available");
          sprintf(szMessage,"%s is not accessable.",pstCFG->szPortName);
          WinMessageBox(HWND_DESKTOP,
                        hwndFrame,
                        szMessage,
                        szCaption,
                        HLPP_MB_COMSCOPE_PORT_NOT_AVAIL,
                        (MB_OK | MB_HELP | MB_MOVEABLE | MB_ICONEXCLAMATION));
          }
        pstCFG->szPortName[0] = 0;
        pstCFG->bMonitoringStream = FALSE;
        MenuItemCheck(hwndFrame,IDM_MDISPLAY,FALSE);
        pstCFG->fDisplaying &= ~DISP_STREAM;
        }
      else
        {
        if (OpenPort(hwndFrame,&hCom,&stCFG))
          {
          strcpy(szCurrentPortName,pstCFG->szPortName);
          MenuItemEnable(hwndFrame,IDM_SETUP,TRUE);
          MenuItemEnable(hwndFrame,IDM_STATUS,TRUE);
          MenuItemEnable(hwndFrame,IDM_IOCTL,TRUE);
          MenuItemEnable(hwndFrame,IDM_MSTREAM,TRUE);
          sprintf(szTitle,"COMscope -> %s",pstCFG->szPortName);
          WinSetWindowText(hwndFrame,szTitle);
          if (pstCFG->bLoadWindowPosition)
            {
            if (pstCFG->bDDstatusActivated)
              WinSendMsg(hwndStatDev,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
            if (pstCFG->bMIstatusActivated)
              WinSendMsg(hwndStatModemIn,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
            if (pstCFG->bMOstatusActivated)
              WinSendMsg(hwndStatModemOut,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
            if (pstCFG->bRBstatusActivated)
              WinSendMsg(hwndStatRcvBuf,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
            if (pstCFG->bTBstatusActivated)
              WinSendMsg(hwndStatXmitBuf,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
            }
          if (pstCFG->bMonitoringStream)
            {
            if (pstCFG->bCaptureToFile)
              {
              strcpy(szCaptureFileName,szCaptureFileSpec);
              if (bLaunchShutdownServer)
                IncrementFileExt(szCaptureFileName,FALSE);
              else
                IncrementFileExt(szCaptureFileName,TRUE);
              if (bCommandLineDataFile || bLaunchShutdownServer)
                fWriteMode = FOPEN_OVERWRITE;
              else
                fWriteMode = FOPEN_NORMAL;
              if (!WriteCaptureFile(szCaptureFileName,pwCaptureBuffer,0,fWriteMode,HLPP_MB_OVERWRT_CAP_FILE))
                pstCFG->bCaptureToFile = FALSE;
              }
            bStopMonitorThread = FALSE;
            if (pstCFG->ulUserSleepCount != 0)
              ulMonitorSleepCount = pstCFG->ulUserSleepCount;
            else
              ulMonitorSleepCount = ulCalcSleepCount;
            DosCreateThread(&tidMonitorThread,(PFNTHREAD)MonitorThread,(ULONG)hCom,0L,4096);            ClearRowScrollBar(&stRow);
            if (pstCFG->fDisplaying & DISP_STREAM)
              {
              if (pstCFG->ulUserSleepCount == 0)
                if (ulMonitorSleepCount > 200)                  ulMonitorSleepCount = 200;
              DosPostEventSem(hevWaitCOMiDataSem);
              stRow.lLeadIndex = 0;
              bStopDisplayThread = FALSE;
              if (pstCFG->bColumnDisplay)
                {
                WinSendMsg(stWrite.hwndClient,UM_SHOWNEW,0L,0L);
                WinSendMsg(stRead.hwndClient,UM_SHOWNEW,0L,0L);
                DosCreateThread(&tidDisplayThread,(PFNTHREAD)ColumnDisplayThread,0L,0L,4096);
                }
              else
                {
                WinSendMsg(stWrite.hwndClient,UM_HIDEWIN,0L,0L);
                WinSendMsg(stRead.hwndClient,UM_HIDEWIN,0L,0L);
                DosCreateThread(&tidDisplayThread,(PFNTHREAD)RowDisplayThread,0L,0L,4096);
                WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
                }
              MenuItemCheck(hwndFrame,IDM_MDISPLAY,TRUE);
              WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
              }
            }
          }
        }
      if (pstCFG->szPortName[0] == 0)
        {
        MenuItemEnable(hwndFrame,IDM_SETUP,FALSE);
        MenuItemEnable(hwndFrame,IDM_STATUS,FALSE);
        MenuItemEnable(hwndFrame,IDM_IOCTL,FALSE);
        MenuItemEnable(hwndFrame,IDM_MSTREAM,FALSE);
        sprintf(szTitle,"COMscope");
        WinSetWindowText(hwndFrame,szTitle);
        }
      }
    }
  }

void InitializeData(void)
  {
  stComCtl.cbSize = sizeof(COMCTL);
  stComCtl.pszPortName = stCFG.szPortName;
  stComCtl.pstIOctl = &stIOctl;

  stCFG.iSampleCount = 10;
  stCFG.cbCFGsize = sizeof(CSCFG);
  stCFG.szPortName[0] = 0;
  stCFG.bInsert = FALSE;
  stCFG.bIsInstall = TRUE;
  stCFG.bIsInstall = FALSE;
  bBreakOn = FALSE;
  bCOMscopeEnabled = FALSE;
  bStopDisplayThread = TRUE;
  bStopMonitorThread = TRUE;

  stCFG.bPopupParams = FALSE;
  stCFG.bShowCounts = TRUE;
  stCFG.bReadWrap = TRUE;
  stCFG.bWriteWrap = TRUE;
  stCFG.bErrorOut = FALSE;
  stCFG.wUpdateDelay = 1000;
  stCFG.ulUserSleepCount = 200;
  stCFG.lBufferLength = DEF_CAP_BUFF_LEN;
  stCFG.wRowFont = HEX_FONT;
  stCFG.wColReadFont = ASCII_FONT;
  stCFG.wColWriteFont = ASCII_FONT;
  stCFG.bHiLightImmediateByte = FALSE;
  stCFG.bSampleCounts = TRUE;
  stCFG.fLockWidth = LOCK_NONE;
  stCFG.lLockWidth = 0L;
  stCFG.byReadMask = '\xff';
  stCFG.byWriteMask = '\xff';

  stCFG.bMarkCurrentLine = TRUE;
  stCFG.bSilentStatus = FALSE;
  stCFG.bOverWriteBuffer = TRUE;
  stCFG.bCaptureToFile = FALSE;
  stCFG.bDDstatusActivated = FALSE;
  stCFG.ptlDDstatusPos.y = -40;
  stCFG.bMIstatusActivated = FALSE;
  stCFG.ptlMIstatusPos.y = -40;
  stCFG.bMOstatusActivated = FALSE;
  stCFG.ptlMOstatusPos.y = -40;
  stCFG.bRBstatusActivated = FALSE;
  stCFG.ptlRBstatusPos.y = -40;
  stCFG.bTBstatusActivated = FALSE;
  stCFG.ptlTBstatusPos.y = -40;

  stCFG.fTraceEvent = (CSFUNC_TRACE_INPUT_STREAM |
                       CSFUNC_TRACE_OUTPUT_STREAM);
  stCFG.bDispWrite = TRUE;
  stCFG.bDispRead = TRUE;
  stCFG.bDispIMM = FALSE;
  stCFG.bDispModemOut = FALSE;
  stCFG.bDispModemIn = FALSE;
  stCFG.bDispOpen = FALSE;
  stCFG.bDispWriteReq = FALSE;
  stCFG.bDispReadReq = FALSE;
  stCFG.bDispDevIOctl = FALSE;
  stCFG.bDispErrors = FALSE;

  stCFG.bFindStrNoCase = FALSE;
  stCFG.bFindStrHEX = FALSE;
  stCFG.bFindForward = TRUE;
  stCFG.bFindWrap = FALSE;
  stCFG.bFindWrite = FALSE;
  stCFG.bFindRead = FALSE;
  stCFG.bFindString = FALSE;
  stCFG.bFindIMM = FALSE;
  stCFG.bFindModemOut = FALSE;
  stCFG.bFindModemIn = FALSE;
  stCFG.bFindOpen = FALSE;
  stCFG.bFindWriteReq = FALSE;
  stCFG.bFindReadReq = FALSE;
  stCFG.bFindDevIOctl = FALSE;
  stCFG.bFindErrors = FALSE;

  stCFG.lModemInBackgrndColor = CLR_PALEGRAY;
  stCFG.lModemInForegrndColor = CLR_BLACK;
  stCFG.lModemOutBackgrndColor = CLR_PALEGRAY;
  stCFG.lModemOutForegrndColor = CLR_BLACK;
  stCFG.lWriteReqBackgrndColor = CLR_PALEGRAY;
  stCFG.lWriteReqForegrndColor = CLR_BLUE;
  stCFG.lErrorBackgrndColor = CLR_RED;
  stCFG.lErrorForegrndColor = CLR_YELLOW;
  stCFG.lReadReqBackgrndColor = CLR_PALEGRAY;
  stCFG.lReadReqForegrndColor = CLR_PINK;
  stCFG.lDevIOctlBackgrndColor = CLR_PALEGRAY;
  stCFG.lDevIOctlForegrndColor = CLR_DARKGREEN;
  stCFG.lOpenBackgrndColor = CLR_PALEGRAY;
  stCFG.lOpenForegrndColor = CLR_RED;
  stCFG.lReadBackgrndColor = CLR_BLACK;
  stCFG.lReadForegrndColor = CLR_WHITE;
  stCFG.lWriteBackgrndColor = CLR_WHITE;
  stCFG.lWriteForegrndColor = CLR_BLACK;
  stCFG.lReadColBackgrndColor = CLR_WHITE;
  stCFG.lReadColForegrndColor = CLR_BLACK;
  stCFG.lWriteColBackgrndColor = CLR_WHITE;
  stCFG.lWriteColForegrndColor = CLR_BLACK;
  stCFG.lStatusBackgrndColor = CLR_BROWN;
  stCFG.lStatusForegrndColor = CLR_WHITE;
  stCFG.bStickyMenus = TRUE;
  stCFG.bSyncToWrite = TRUE;
  stCFG.bSyncToRead = FALSE;
  stCFG.fDisplaying = 0;
  stCFG.bMonitoringStream = FALSE;
  if (bLaunchShutdownServer)
    {
    stCFG.bLoadMonitor = TRUE;
    stCFG.bAutoSaveConfig = TRUE;
    }
  else
    {
    stCFG.bLoadMonitor = FALSE;
    stCFG.bAutoSaveConfig = FALSE;
    }
  stCFG.bLoadWindowPosition = FALSE;
  stCFG.bFilterRead = TRUE;
  stCFG.bFilterWrite = TRUE;
  stCFG.fFilterReadMask = FILTER_NPRINT;
  stCFG.fFilterWriteMask = FILTER_NPRINT;
  stCFG.bSkipReadBlankLines = TRUE;
  stCFG.bSkipWriteBlankLines = TRUE;
  stCFG.bColumnDisplay = FALSE;
  stCFG.bReadTestNewLine = TRUE;
  stCFG.bWriteTestNewLine = TRUE;
  stCFG.byReadNewLineChar = '\x0d';
  stCFG.byWriteNewLineChar = '\x0d';
  }

