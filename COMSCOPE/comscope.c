/*
**  COMscope.C
**
**  Main source file for COMscope and CONFIG.EXE.
**
**  Command Line:
**
**  If a filename is given on the command line an attempt will be made to open
**  that file as a COMi initialization file.  If the file is not a COMi
**  initialization file it will be ingored.
**
**  Otherwise:
**
**  All command line switched start with a "/" (slash), or "-" (minus/dash).
**  Switch characters are NOT case sensitive.
**
**  COMscope User Command Line:
**
**  T - Enable shutdown server and specify server name.  A pipe name MUST be
**      be specified immediately following the "T"; no space or tab characters.
**
**  L - Enable shutdown server and use default name if no "T" switch is used.
**      Default name is "COMscope"
**
**  V - Give a remote server name for a named pipe - not used yet.
**
**  P - Disable/enable profiles and optionally specify profile name for that
**      COMscope session.  Profile names with spaces or tabs must be quoted.
**
**      A "-" (minus/dash) immediately following the "P" will disable profile
**      access for that session.
**
**  S - Disable/enable profile sequencing and optionally specify a "root"
**      profile name for that COMscope session.    Profile names with spaces or
**      tabs must be quoted.
**
**      A "-" (minus/dash) immediately following the "S" will disable profile
**      access for that session.
**
**  F - Specifies a font file.
**
**  D - Specifies a data file to load.
**
**  X - Remote access function   (NOT implemented)
**
**       XC - remote access as client - Port to monitor is on remote system
**
**       XS - remote access as server - Local port is being monitored remotely
**
**  COMscope Developer Command Line:
**
**  Same as above with these additions:
**
**  L - Enable shutdown server and specify debug options.  A number character
**      immediately following the will be used to set debug level.  Each level
**      includes the level below.
**
**      0 - Causes the process to be started in the foreground.
**
**      1 - Causes watchdog messages to be written to process window.
**
**      2 - Causes various other diagnostic messages to be displayed.
*/
#include "COMscope.h"
#include "remote.h"

BOOL bDebuggingCOMscope = FALSE;

CFG_INSTDEV pfnInstallDevice;
CFG_DIALOG pfnDialog;
PRF_MANAGE pfnManageProfile;
PRF_DATA pfnGetProfileData;
PRF_DATA pfnSaveProfileData;
PRF_GETSTR pfnGetProfileString;
PRF_SAVESTR pfnSaveProfileString;
PRF_INIT pfnInitializeProfile;
PRF_CLOSE pfnCloseProfile;
CFG_FILLLIST pfnFillDeviceNameList;

LONG lMouseButtonCount;

COMICFG stCOMiCFG;
COMCTL stComCtl;

char szCOMscopeProfile[] = "COMscope";
#ifdef DEMO
char szCOMscopeAppName[MAX_PROFILE_STRING + 1] = "COMscope Demo";
char szHelpFileName[CCHMAXPATH + 1] = "CSDEMO.hlp";
char szCOMscopeVersion[] = "Demonstration Version 3.90";
#else
char szCOMscopeVersion[] = "Version 3.90";
char szCOMscopeAppName[MAX_PROFILE_STRING + 1] = "COMscope";
char szHelpFileName[CCHMAXPATH + 1] = "COMscope.hlp";
#endif

#define UM_STARTUP_EXIT_MSG 64000

VOID main(int argc,char *argv[]);

MRESULT WinCommand(HWND hWnd,USHORT Command,CSCFG *pstCFG);

MRESULT EXPENTRY fnwpSetColorDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpModemOutStatusDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpModemInStatusDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpUpdateStatusDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpXmitBufferStatusDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpRcvBufferStatusDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpDeviceStatusDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpDeviceAllStatusDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);

MRESULT EXPENTRY fnwpWriteColumnClient(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpReadColumnClient(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY FrameSubProc(HWND hwnd,WORD msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpClient(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY StatusProc(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);

void DisplayCharacterInfo(HWND hwnd,LONG lMouseIndex);

MPARAM WndSize(HWND hwnd,MPARAM mpOldSize,MPARAM mpNewSize);
BOOL CreatePS(HWND hwnd);

IOCTLINST stIOctl;

VOID RowPaint(HWND hwnd);

BOOL bIsTheFirst = FALSE;

extern HWND hwndHelpInstance;

PFNWP FrameProcess;
PFNWP ReadFrameProcess;
PFNWP WriteFrameProcess;
HAB habAnchorBlock;
HWND hwndFrame;
HWND hwndClient;
HWND hwndDlg;
ULONG ulFileSize;
APIRET rc;
HFILE hCom = 0xffffffff;

/*
** Configuration runtime global Variables
*/
char szCOMscopeIniPath[CCHMAXPATH + 1];
ULONG ulCOMscopeBufferSize;
BOOL bCOMscopeEnabled;
COMDEF *pstComListHead = NULL;
char pszFileContents;

/*
** COMscope configuration global variables
*/
CSCFG stCFG;
LONG lYScr;
LONG lYfullScr;
LONG lcyBrdr;
LONG lXScr;
LONG lXfullScr;
LONG lcxVSc;
LONG lcxBrdr;
LONG lcyMenu;
LONG lcyTitleBar;

char szCOMscopePipeName[80] = "COMscope";
char szCOMscopePipe[100];

PIPEMSG stPipeMsg;
PIPECMD stPipeCmd;

BOOL bRemoteClient = FALSE;
BOOL bRemoteServer = FALSE;
BOOL bRemoteAccess = FALSE;
STARTDATA stRemote;
char szNetRun[] = "net.exe";
char szNetRunParameters[] = "run csbeta /X /l1 /p\"CSBETA 1\"";

BOOL bFirstPosition = TRUE;
BOOL bSkipInitPos = FALSE;

WORD wASCIIfont = 1;
WORD wHEXfont = 0;

BOOL bCommandLineDataFile = FALSE;
BOOL bExternalKill = FALSE;
HPIPE hIPCpipe;
char szIPCpipe[100];
char szIPCpipeName[80] = "COMscope";
//char szServerTitle[80];
TID tidIPCserverThread;

char szDataFileSpec[CCHMAXPATH + 1];
char szCaptureFileSpec[CCHMAXPATH + 1];
char szEntryDataFileSpec[CCHMAXPATH + 1];
char szEntryCaptureFileSpec[CCHMAXPATH + 1];

CHARCNT stCharCount;
BOOL bCaptureFileWritten = FALSE;
char szCaptureFileName[CCHMAXPATH + 1];
/*
** COMscope runtime global variables
*/
extern WORD *pwScrollBuffer;
extern HWND hwndScroll;
extern LONG lScrollCount;

BOOL bFrameActivated = FALSE;

BOOL bIsInstall = FALSE;
BOOL bSendNextKeystroke = FALSE;
ULONG ulMonitorSleepCount = 200;
ULONG ulCalcSleepCount = 200;
LONG lLeadWriteIndex;
LONG lLeadReadIndex;
BOOL bMaximized = FALSE;
BOOL bMinimized = FALSE;
SWP swpLastPosition;
BOOL bStatusSized = FALSE;
HMTX hmtxSigGioBlockedSem;
HMTX hmtxColGioBlockedSem;
HMTX hmtxRowGioBlockedSem;
HEV hevWaitCOMiDataSem;
HEV hevWaitQueueStartSem;
HEV hevDisplayWaitDataSem;
HEV hevKillMonitorThreadSem;
HEV hevKillDisplayThreadSem;

CHAR szErrorMessage[200];
CHAR szTitle[80] = "COMscope";
CHAR szEXEtitle[] = "COMscope";
CHAR szFontFileName[20] = "HEXFONTS.FON";
CHAR szFontFilePath[CCHMAXPATH + 1];
CHARCELL stCell;
HDC hdcPs;
HPS hpsPs;

extern LONG lWriteIndex;
extern BOOL bBufferWrapped;

TID tidMonitorThread;
TID tidDisplayThread;
BOOL bDataToView = FALSE;
WORD *pwCaptureBuffer;

SCREEN stRow;
LONG lStatusHeight;

LONG lFontsAvailable;
FONTMETRICS astFontMetrics[MAX_FONTS];
FONTNAMES astFontNames[MAX_FONTS];
FATTRS astFontAttributes[MAX_FONTS];

BOOL bStopMonitorThread;
BOOL bStopDisplayThread;

char szPortName[10];

LONG lLastHeight;
LONG lLastWidth;
LONG lMinimumHeight;
LONG lMinimumWidth;

HWND hwndStatus;
HWND hwndStatAll;
HWND hwndStatDev;
HWND hwndStatModemIn;
HWND hwndStatModemOut;
HWND hwndStatRcvBuf;
HWND hwndStatXmitBuf;
PFNWP frameproc;
BOOL bNewFontFile = FALSE;

USHORT usLastClientPopupItem;
BOOL bNoPaint = FALSE;

extern USHORT swSearchString[];
extern LONG lSearchStrLen;

BOOL bSearchProfileApps = FALSE;
BOOL bUseProfile = TRUE;

PROFILE stProfile;
HPROF hProfileInstance = NULL;

TID tidRemoteServerThread;
HEV hevCOMscopeSem;

BOOL bStopRemotePipe = FALSE;

HPIPE hCOMscopePipe;

HMTX hmtxIPCpipeBlockedSem;
IPCPIPEMSG stIPCpipe;
char szPipeServerName[40];
ULONG ulBytesRead;
ULONG ulIPCpipeInstance;
char chPipeDebug = 0;
int iDebugLevel = 0;
BOOL bIPCpipeOpen = FALSE;
BOOL bLaunchShutdownServer = FALSE;
BOOL bShowServerProcess = FALSE;
STARTDATA stSD;
PID pidCSqueueOwner;
ULONG ulSessionID;
PID pidSession;
char szServerProgram[CCHMAXPATH];
char szCmdLineIniFileSpec[CCHMAXPATH];
BOOL bEditCmdLineIniFile = FALSE;
BOOL bStopIPCserverThread = FALSE;

void APIENTRY ExitRoutine(ULONG ulTermCode)
  {
  HMODULE hMod;
//  PFN pfnCloseProfile;

  if (hCom != 0)
    DosClose(hCom);
//  MessageBox(HWND_DESKTOP,"Exit Routine entered");
  if (hProfileInstance != NULL)
    {
    if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
      {
      if (stCFG.bCaptureToFile && (szCaptureFileName[0] != 0))
        if (DosQueryProcAddr(hMod,0,"SaveProfileString",(PFN *)&pfnSaveProfileString) == NO_ERROR)
          pfnSaveProfileString(hProfileInstance,"Capture File",szCaptureFileName);
      hProfileInstance->pstProfile->bAutoSaveProfile = TRUE;
      if (DosQueryProcAddr(hMod,0,"CloseProfile",(PFN *)&pfnCloseProfile) == NO_ERROR)
        hProfileInstance = pfnCloseProfile(hProfileInstance);
      DosFreeModule(hMod);
      }
    }
  DosExitList(EXLST_EXIT,ExitRoutine);
  }

void pfnUpdateProfileOptions(int iAction)
  {
  switch (iAction)
    {
    case PROFACTION_ENTER_SAVE:
      stCFG.bLoadWindowPosition = stProfile.bLoadWindowPosition;
      stCFG.bLoadMonitor = stProfile.bLoadProcess;
      stCFG.bAutoSaveConfig = stProfile.bAutoSaveProfile;
      SaveWindowPositions();
      break;
    case PROFACTION_ENTER_MANAGE:
    case PROFACTION_PROFILE_LOADED:
      stProfile.bLoadWindowPosition = stCFG.bLoadWindowPosition;
      stProfile.bLoadProcess = stCFG.bLoadMonitor;
      stProfile.bAutoSaveProfile = stCFG.bAutoSaveConfig;
      break;
    case PROFACTION_EXIT_SAVE:
    case PROFACTION_ENTER_LOAD:
    case PROFACTION_EXIT_LOAD:
    case PROFACTION_EXIT_MANAGE:
      break;
    }
  }

#if DEBUG > 0

void DisplayLastWindowError(char szMessage[])
  {
  char szError[200];
  ERRORID eidErrorCode;

//  if (stCFG.bErrorOut)
    {
    eidErrorCode = WinGetLastError(habAnchorBlock);
    if (eidErrorCode != 0)
      {
      sprintf(szError,"Error Severity = %X, Code = %d - 0x%04X, %s",ERRORIDSEV(eidErrorCode),
                                                                    ERRORIDERROR(eidErrorCode),
                                                                    ERRORIDERROR(eidErrorCode),
                                                                    szMessage);
      MessageBox(hwndFrame,szError);
      ErrorNotify(szError);
      }
    }
  }
#endif

void main(int argc,char *argv[])
  {
  HMQ hmqQueue;
  QMSG qmsgMessage;
  char szMessage [80];
  ULONG flCreateFlags;
  LONG lIndex;
  ULONG ulAction;
  HMODULE hMod;

  if (argc >= 2)
    ParseParms(argc, argv);
    
  strcpy(szCOMscopeIniPath,argv[0]);
  for (lIndex = strlen(szCOMscopeIniPath);lIndex > 0;lIndex--)
    {
    if (argv[0][lIndex] ==  '\\')
      break;
    }
  lIndex++;
  szCOMscopeIniPath[lIndex] = 0;

  habAnchorBlock = WinInitialize((USHORT)NULL);
  hmqQueue   = WinCreateMsgQueue(habAnchorBlock,0);

  WinRegisterClass(habAnchorBlock,
                  (PSZ)"COMSCOPE",
                   (PFNWP)fnwpClient,
                   CS_SIZEREDRAW,
                   sizeof(PVOID));

  DosExitList(EXLST_ADD,ExitRoutine);
  InitializeData();

  WinRegisterClass(habAnchorBlock,
             (PSZ)"READ COLUMN",
            (PFNWP)fnwpReadColumnClient,
                   0L,
                   sizeof(PVOID));

  WinRegisterClass(habAnchorBlock,
             (PSZ)"WRITE COLUMN",
            (PFNWP)fnwpWriteColumnClient,
                   0L,
                   sizeof(PVOID));

  if (bLaunchShutdownServer && !bRemoteAccess)
    {
    if (strlen(szPipeServerName) != 0)
      sprintf(szIPCpipe,"\\\\%s\\PIPE\\%s",szPipeServerName,szIPCpipeName);
    else
      sprintf(szIPCpipe,"\\PIPE\\%s",szIPCpipeName);
    rc = DosOpen(szIPCpipe,&hIPCpipe,&ulAction,0L,0L,1L,0x42,0L);
    if (rc == NO_ERROR)
      bIPCpipeOpen = TRUE;
    else
      if (rc != ERROR_PIPE_BUSY)
        {
        bIsTheFirst = TRUE;
        if (chPipeDebug > '0')
          {
          sprintf(szMessage,"Open IPC Server is not up yet - rc = %u",rc);
          ErrorNotify(szMessage);
          }
        }
    bStopIPCserverThread = FALSE;
    if ((rc = DosCreateMutexSem(0L,&hmtxIPCpipeBlockedSem,0L,FALSE)) != NO_ERROR)
      {
      sprintf(szMessage,"DosCreateMutexSem error: IPC Pipe - return code = %ld", rc);
      ErrorNotify(szMessage);
      DosSleep(5000);
      WinPostMsg(hwndClient,WM_QUIT,0L,0L);
      }
    DosCreateThread(&tidIPCserverThread,(PFNTHREAD)IPCserverThread,0L,TRUE,4096);
    }

  if (bRemoteAccess)
    {
    bLaunchShutdownServer = FALSE;
    if (strlen(szPipeServerName) != 0)
      sprintf(szCOMscopePipe,"\\\\%s\\PIPE\\%s",szPipeServerName,szCOMscopePipeName);
    else
      sprintf(szCOMscopePipe,"\\PIPE\\%s",szCOMscopePipeName);

    if (bRemoteServer)
      DosCreateThread(&tidRemoteServerThread,(PFNTHREAD)RemoteServerThread,0L,0,4096);
    }

  if (bUseProfile && !bRemoteServer)
    {
    if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
      {
      stProfile.hab = habAnchorBlock;
      stProfile.phwndHelpInstance = &hwndHelpInstance;
      stProfile.ulHelpPanel = HLPP_PROFILE_DLG;
      strcpy(stProfile.stUserProfile.szAppName,szCOMscopeAppName);
      strcpy(stProfile.stUserProfile.szVersionString,szCOMscopeVersion);
      strcpy(stProfile.szIniFilePath,szCOMscopeIniPath);
      strcpy(stProfile.szProfileName,szCOMscopeProfile);
      strcpy(stProfile.szAppName,szCOMscopeAppName);
      stProfile.pData = (void *)&stCFG;
      stProfile.ulDataSize = sizeof(CSCFG);
      stProfile.ulMaxApps = 99;
      stProfile.pfnUpdateCallBack = pfnUpdateProfileOptions;
      stProfile.ulMaxProfileString = MAX_PROFILE_STRING;
      stProfile.bSearchApps = bSearchProfileApps;
      if (bLaunchShutdownServer)
        {
        stProfile.bLoadProcess = TRUE;
        stProfile.bAutoSaveProfile = TRUE;
        }
      else
        {
        stProfile.bLoadProcess = FALSE;
        stProfile.bAutoSaveProfile = FALSE;
        }
      stProfile.bLoadWindowPosition = FALSE;
      stProfile.bRestart = bIsTheFirst;
      strcpy(stProfile.szProcessPrompt,"Load monitor ~configuration");
      stProfile.hwndOwner = hwndFrame;

      if (DosQueryProcAddr(hMod,0,"InitializeProfile",(PFN *)&pfnInitializeProfile) == NO_ERROR)
        {
        if ((hProfileInstance = pfnInitializeProfile(&stProfile)) != 0)
          {
          stProfile.bLoadWindowPosition = stCFG.bLoadWindowPosition;
          stProfile.bLoadProcess = stCFG.bLoadMonitor;
          stProfile.bAutoSaveProfile = stCFG.bAutoSaveConfig;
          if ((DosQueryProcAddr(hMod,0,"GetProfileString",(PFN *)&pfnGetProfileString) == NO_ERROR) &&
              (DosQueryProcAddr(hMod,0,"SaveProfileString",(PFN *)&pfnSaveProfileString) == NO_ERROR))
            {
            if (strlen(szDataFileSpec) == 0)
              {
              if (pfnGetProfileString(hProfileInstance,"Data File",szDataFileSpec,CCHMAXPATH) == 0)
                strcpy(szEntryDataFileSpec,szDataFileSpec);
              }
            else
              {
              bCommandLineDataFile = TRUE;
              pfnSaveProfileString(hProfileInstance,"Data File",szDataFileSpec);
              strcpy(szEntryDataFileSpec,szDataFileSpec);
              }
            if (pfnGetProfileString(hProfileInstance,"Capture File",szCaptureFileSpec,CCHMAXPATH) == 0)
              strcpy(szCaptureFileSpec,"CAPTURE");
            strcpy(szEntryCaptureFileSpec,szCaptureFileSpec);
            }
          if (DosQueryProcAddr(hMod,0,"GetProfileData",(PFN *)&pfnGetProfileData) == NO_ERROR)
            if ((lSearchStrLen = pfnGetProfileData(hProfileInstance,"Search String",(BYTE *)swSearchString,MAX_SEARCH_STRING)) == 0)
              stCFG.bFindString = FALSE;
            else
              lSearchStrLen /= 2;
          }
        }
      DosFreeModule(hMod);
      }
    }
  else
    if (strlen(szDataFileSpec) != 0)
      strcpy(szEntryDataFileSpec,szDataFileSpec);

  WinSetWindowText(hwndFrame,szEXEtitle);

  WinRegisterClass(habAnchorBlock,(PSZ)"SUBFRAME",(PFNWP)FrameSubProc,0L,0);

  WinRegisterClass(habAnchorBlock,(PSZ)"STATUS",(PFNWP)StatusProc,CS_SIZEREDRAW,0);

  flCreateFlags =  (FCF_STANDARD ^ FCF_SHELLPOSITION);

  hwndFrame = WinCreateStdWindow(HWND_DESKTOP,
                                 0L,
                                 &flCreateFlags,
                                 "COMSCOPE",
                                 NULL,
                                 WS_CLIPCHILDREN,
                                 (HMODULE)NULL,
                                 IDM_COMSCOPE,
                                 &hwndClient);

#if DEBUG > 0
  if (hwndFrame == (HWND)NULL)
    {
    DisplayLastWindowError("Bad hwndFrame");
    exit(70);
    }
#endif
  /*
  ** Subclass the frame window procedure in order to implement frame
  ** sizing restrictions.
  ** Messages for the frame window procedure are first passed to
  ** FrameSubProc.  This can either process or ignore the messages, thus
  ** allowing the normal behavior of the frame window to be altered.
  */
  FrameProcess = WinSubclassWindow(hwndFrame,(PFNWP)FrameSubProc);

  WinSetFocus(HWND_DESKTOP,hwndClient);

  hCom = -1;
#if DEBUG < 1
  if (!HelpInit(szHelpFileName))
    {
    MenuItemEnable(hwndFrame,IDM_HELPINDEX,FALSE);
    MenuItemEnable(hwndFrame,IDM_HELPEXTEND,FALSE);
    MenuItemEnable(hwndFrame,IDM_HELPKEYS,FALSE);
    MenuItemEnable(hwndFrame,IDM_HELPFORHELP,FALSE);
    }
#endif
  while(WinGetMsg(habAnchorBlock,&qmsgMessage,(HWND)NULL,0,0))
    WinDispatchMsg(habAnchorBlock,&qmsgMessage);

  DestroyHelpInstance();

  WinDestroyWindow(stRead.hwnd);
  WinDestroyWindow(stWrite.hwnd);
  WinDestroyWindow(hwndFrame);
  WinDestroyWindow(hwndStatus);
  WinDestroyWindow(hwndStatAll);
  WinDestroyWindow(hwndStatDev);
  WinDestroyWindow(hwndStatModemIn);
  WinDestroyWindow(hwndStatModemOut);
  WinDestroyWindow(hwndStatRcvBuf);
  WinDestroyWindow(hwndStatXmitBuf);

  WinDestroyMsgQueue(hmqQueue);
  WinTerminate(habAnchorBlock);

  DosCloseMutexSem(hmtxIPCpipeBlockedSem);
  DosCloseEventSem(hevWaitQueueStartSem);
  DosCloseEventSem(hevWaitCOMiDataSem);
  DosCloseEventSem(hevDisplayWaitDataSem);
  DosCloseEventSem(hevKillMonitorThreadSem);
  DosCloseEventSem(hevKillDisplayThreadSem);
  DosCloseMutexSem(hmtxSigGioBlockedSem);
  DosCloseMutexSem(hmtxRowGioBlockedSem);
  DosCloseMutexSem(hmtxColGioBlockedSem);
  if (pwScrollBuffer != NULL)
    DosFreeMem(pwScrollBuffer);
  DosFreeMem(pwCaptureBuffer);
  }

MRESULT EXPENTRY fnwpClient(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  CHAR szMessage[300];
  POINTL ptl;
  HMODULE hMod;
  APIRET rc;
  SWP swp;
  static ULONG ulMenuStyle;
  HWND hwndMenu;
  LONG lMouseRow;
  LONG lMouseCol;

  switch(msg)
    {
    case WM_CREATE:
      if (bEditCmdLineIniFile)
        {
        sprintf(szMessage,"Initialization file %s entered on command line",szCmdLineIniFileSpec);
        MessageBox(HWND_DESKTOP,szMessage);
        if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) == NO_ERROR)
          {
          stCOMiCFG.pszPortName = NULL;
          stCOMiCFG.hwndHelpInstance = hwndHelpInstance;
          stCOMiCFG.bInstallCOMscope = TRUE;
          stCOMiCFG.bInitInstall = FALSE;
          stCOMiCFG.pszRemoveOldDriverSpec == NULL;
          stCOMiCFG.pszDriverIniSpec = szCmdLineIniFileSpec;
          if (DosQueryProcAddr(hMod,0,"InstallDevice",(PFN *)&pfnInstallDevice) == NO_ERROR)
            pfnInstallDevice(&stCOMiCFG);
          DosFreeModule(hMod);
          WinPostMsg(hwnd,WM_QUIT,0L,0L);
          return(FALSE);
          }
        else
          {
          sprintf(szMessage,"Unable to load configuration library - %s",CONFIG_LIBRARY);
          MessageBox(HWND_DESKTOP,szMessage);
          }
        }
      ulMenuStyle = (PU_POSITIONONITEM | PU_MOUSEBUTTON2 | PU_HCONSTRAIN | PU_VCONSTRAIN | PU_KEYBOARD | PU_MOUSEBUTTON1);
      if ((rc = DosCreateEventSem(0L,&hevWaitCOMiDataSem,0L,TRUE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
        ErrorNotify(szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        }

      if ((rc = DosCreateEventSem(0L,&hevDisplayWaitDataSem,0L,TRUE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
        ErrorNotify(szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        }

      if ((rc = DosCreateEventSem(0L,&hevKillDisplayThreadSem,0L,TRUE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
        ErrorNotify(szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        }

      if ((rc = DosCreateEventSem(0L,&hevKillMonitorThreadSem,0L,TRUE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
        ErrorNotify(szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        }

      if ((rc = DosCreateMutexSem(0L,&hmtxRowGioBlockedSem,0L,FALSE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateMutexSem error: RowGio - return code = %ld", rc);
        ErrorNotify(szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        }

      if ((rc = DosCreateMutexSem(0L,&hmtxColGioBlockedSem,0L,FALSE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateMutexSem error: ColGio - return code = %ld", rc);
        ErrorNotify(szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        }

      if ((rc = DosCreateMutexSem(0L,&hmtxSigGioBlockedSem,0L,FALSE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateMutexSem error: SigGio - return code = %ld", rc);
        ErrorNotify(szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        }

      /*
      ** This initializes the global structure stCell, which defines
      ** the character cell size.
      */
      if (CreatePS(hwnd))
        {
        WinSendMsg(hwnd,WM_SYSVALUECHANGED,0L,0L);
        WinSetWindowPos(WinQueryWindow(hwnd,QW_PARENT),
                  (HWND)0,
                        swpLastPosition.x,
                        swpLastPosition.y,
                        lLastWidth,
                        lLastHeight,
                        SWP_MOVE);

        /*
        ** The status window is a line across the bottom of the client
        ** area.  It is one char cell deep.  Text is displayed to show
        **
        ** The status window is a child window of the client.
        ** It is created when the Presentation Space exists and the
        ** Cell values are known.
        */
        hwndStatus = WinCreateWindow(hwnd,
                                    (PSZ)"STATUS",
                                    (PSZ)"COMscope Status",
                                     WS_VISIBLE,
                                     0,0,
                                     lLastWidth,
                                     lStatusHeight,
                                     WinQueryWindow(hwnd,QW_PARENT),
                                     HWND_TOP,
                                     WID_STATUS_LINE,
                                     NULL,NULL);

        hwndStatAll = WinLoadDlg(HWND_DESKTOP,HWND_OBJECT,(PFNWP)fnwpDeviceAllStatusDlg,(USHORT)NULL,HWS_DLG,NULL);
        hwndStatRcvBuf = WinLoadDlg(HWND_DESKTOP,HWND_OBJECT,(PFNWP)fnwpRcvBufferStatusDlg,(USHORT)NULL,HWS_BUFF_DLG,NULL);
        hwndStatXmitBuf = WinLoadDlg(HWND_DESKTOP,HWND_OBJECT,(PFNWP)fnwpXmitBufferStatusDlg,(USHORT)NULL,HWS_TX_BUFF_DLG,NULL);
        hwndStatModemIn = WinLoadDlg(HWND_DESKTOP,HWND_OBJECT,(PFNWP)fnwpModemInStatusDlg,(USHORT)NULL,HWSIS_DLG,NULL);
        hwndStatModemOut = WinLoadDlg(HWND_DESKTOP,HWND_OBJECT,(PFNWP)fnwpModemOutStatusDlg,(USHORT)NULL,HWSOS_DLG,NULL);
        hwndStatDev = WinLoadDlg(HWND_DESKTOP,HWND_OBJECT,(PFNWP)fnwpDeviceStatusDlg,(USHORT)NULL,HWSDS_DLG,NULL);
        WinPostMsg(hwnd,UM_INITMENUS,0L,0L);
        }
      else
        WinPostMsg(hwnd,UM_STARTUP_EXIT_MSG,0L,0L);
      break;
    case WM_SYSVALUECHANGED:
      /*
      ** Set up globals used for sizing
      */
      lMouseButtonCount = WinQuerySysValue(HWND_DESKTOP,SV_CMOUSEBUTTONS);
      lXfullScr   = WinQuerySysValue(HWND_DESKTOP,SV_CXFULLSCREEN);
      lcxVSc  = WinQuerySysValue(HWND_DESKTOP,SV_CXVSCROLL);
      lcxBrdr = WinQuerySysValue(HWND_DESKTOP,SV_CXSIZEBORDER);
      lYfullScr   = WinQuerySysValue(HWND_DESKTOP,SV_CYFULLSCREEN);
      lXScr   = WinQuerySysValue(HWND_DESKTOP,SV_CXSCREEN);
      lYScr   = WinQuerySysValue(HWND_DESKTOP,SV_CYSCREEN);
      lcyBrdr = WinQuerySysValue(HWND_DESKTOP,SV_CYSIZEBORDER);
      lcyMenu = WinQuerySysValue(HWND_DESKTOP,SV_CYMENU);
      lcyTitleBar = WinQuerySysValue(HWND_DESKTOP,SV_CYTITLEBAR);

      if (stCFG.bLargeFont)
        {
        if (lFontsAvailable <= 2)
          {
          bSkipInitPos = TRUE;
          stCFG.bLargeFont = FALSE;
          stCFG.wRowFont = HEX_FONT;
          stCFG.wColReadFont = ASCII_FONT;
          stCFG.wColWriteFont = ASCII_FONT;
          }
        else
          {
          wASCIIfont = 3;
          wHEXfont = 2;
          }
        }
      stCell.cx = astFontMetrics[wASCIIfont].lAveCharWidth;
      stCell.cy = astFontMetrics[wASCIIfont].lXHeight + 1;
      /*
      ** Set the size and position of the frame window by making the
      ** client area width and height integral numbers of cell
      ** units.  Calculate the frame window values necessary to
      ** achieve this.
      */
      lStatusHeight = (stCell.cy + 4);
      lMinimumHeight = ((MINHEIGHT * stCell.cy) + (lcyBrdr * 2) + lcyTitleBar + lcyMenu + lStatusHeight);
      lLastHeight = (lMinimumHeight + ((INITHEIGHT - MINHEIGHT) * stCell.cy)) + 1;
      lMinimumWidth = ((MINWIDTH * stCell.cx) + (lcxBrdr * 2));
      lLastWidth = (lMinimumWidth + ((INITWIDTH - MINWIDTH) * stCell.cx));
      if (!bFirstPosition)
        {
        WinQueryWindowPos(hwndFrame,&swpLastPosition);
        if (swpLastPosition.x < 0)
          swpLastPosition.x = 0;
        else
          if ((swpLastPosition.x + lLastWidth) > lXScr)
            swpLastPosition.x = (lXScr - lLastWidth - lcxBrdr);
        if (swpLastPosition.y < 0)
          swpLastPosition.y = 0;
        else
          if ((swpLastPosition.y + lLastHeight) > lYScr)
            swpLastPosition.y = (lYScr - lLastHeight - lcyBrdr);
        }
      else
        {
        bFirstPosition = FALSE;
        swpLastPosition.x = ((lXScr / 2) - (lLastWidth / 2));
        swpLastPosition.y = ((lYScr / 2) - (lLastHeight / 2));
        }
      swpLastPosition.cx = lLastWidth;
      swpLastPosition.cy = lLastHeight;
      WinSetWindowPos(WinQueryWindow(hwnd,QW_PARENT),
                (HWND)0,
                      swpLastPosition.x,
                      swpLastPosition.y,
                      lLastWidth,
                      lLastHeight,
                      (SWP_SIZE | SWP_MOVE));

      /*
      ** setup column window tracking info structure
      */
      stColTrack.cxBorder = 4;
      stColTrack.cyBorder = 4;
      stColTrack.cxGrid = stCell.cx;
      stColTrack.cyGrid = stCell.cy;
      stColTrack.cxKeyboard = stCell.cx;
      stColTrack.cyKeyboard = stCell.cy;
      stColTrack.ptlMinTrackSize.x = (stCell.cx * 6);
      stColTrack.ptlMinTrackSize.y = 0;
      stColTrack.ptlMaxTrackSize.x = (stCell.cx * (INITWIDTH - 7));
      stColTrack.ptlMaxTrackSize.y = (stCell.cy * INITHEIGHT);
      break;
    case WM_ACTIVATE:
      if(SHORT1FROMMP(mp1)) // activation ?
        {
        if (!bFrameActivated)
          {
          WinSetFocus(HWND_DESKTOP,hwndFrame);
          WinSendMsg(WinQueryHelpInstance(hwndClient),HM_SET_ACTIVE_WINDOW,0L,0L);
          bFrameActivated = TRUE;
          }
        }
      else
        bFrameActivated = FALSE;
      break;
    case WM_HELP:
      if (SHORT1FROMMP(mp2) & CMDSRC_PUSHBUTTON)
        {
        DisplayHelpPanel(SHORT1FROMMP(mp1));
        return((MRESULT)FALSE);
        }
      break;
    case HM_QUERY_KEYS_HELP:
      return (MRESULT)HLPP_KEYS;
    case UM_STARTUP_EXIT_MSG:
      WinMessageBox(HWND_DESKTOP,
                    WinQueryWindow(hwnd,QW_PARENT),
                    szErrorMessage,
                    szTitle,
                    0,
                    MB_MOVEABLE | MB_OK | MB_CUAWARNING);
      WinPostMsg(hwnd,WM_QUIT,0L,0L);
      break;
    case WM_COMMAND:
       return(WinCommand(hwnd,SHORT1FROMMP(mp1),&stCFG));
     case WM_MINMAXFRAME:
        {
        SHORT sScreenTemp;
        LONG lFullScr;
        PSWP pswp = (PSWP)mp1;

        ClearRowScrollBar(&stRow);
        if (pswp->fl & SWP_MAXIMIZE)
          {
          bMaximized = TRUE;
          if (!bMinimized)
            WinQueryWindowPos(hwndFrame,&swpLastPosition);
          lFullScr = (lYScr - lcyMenu - lcyTitleBar);
          stRow.lHeight = (lYScr - (lYScr % (stCell.cy * 2)) + lStatusHeight);// + 2);
          if (stRow.lHeight > lFullScr)
            {
            while (stRow.lHeight > lFullScr)
              stRow.lHeight -= (stCell.cy * 2);
            pswp->cy = (stRow.lHeight + lcyMenu + lcyTitleBar + (lcyBrdr * 2));
            }
          else
            if (stRow.lHeight < lFullScr)
              pswp->cy = (stRow.lHeight + lcyMenu + lcyTitleBar + (lcyBrdr * 2));
          if (pswp->cy <= (lYScr - lcyBrdr))
            {
            sScreenTemp = ((SHORT)pswp->y + lcyBrdr);
            pswp->y = (LONG)sScreenTemp;
            }
          stRow.lWidth = (lXScr - (lXScr % stCell.cx));
          if (stRow.lWidth > lXScr)
            {
            while (stRow.lWidth > lXScr)
              stRow.lWidth -= stCell.cx;
            pswp->cx = (stRow.lWidth + (lcyBrdr * 2));
            }
          else
            if (stRow.lWidth < lXScr)
              pswp->cx = (stRow.lWidth + (lcyBrdr * 2));
          if (pswp->cx <= (lXScr - lcxBrdr))
            {
            sScreenTemp = ((SHORT)pswp->x + lcxBrdr);
            pswp->x = (LONG)sScreenTemp;
            }
          stRow.lCharWidth = (stRow.lWidth / stCell.cx);
          stRow.lCharHeight = (stRow.lHeight / stCell.cy);
          stRow.lHeight -= stCell.cy;
          stRow.lWidth -= stCell.cx;
          stRow.lCharSize = (stRow.lCharWidth * stRow.lCharHeight);
          WinSetWindowText(hwndFrame,szTitle);
          }
        else
          if (pswp->fl & SWP_RESTORE)
            {
            bMaximized = FALSE;
            bMinimized = FALSE;
            WinSetWindowText(hwndFrame,szTitle);
            }
          else
            {
            if (!bMaximized)
              WinQueryWindowPos(hwndFrame,&swpLastPosition);
            bMaximized = FALSE;
            bMinimized = TRUE;
            if (hCom != 0xffffffff)
              WinSetWindowText(hwndFrame,stCFG.szPortName);
            }
        }
      return((MRESULT)FALSE);
    case WM_VSCROLL:
      if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
        {
        switch(HIUSHORT(mp2))
         {
          case SB_LINEDOWN:
              RowScroll(&stRow,1,FALSE);
              break;
          case SB_LINEUP:
              RowScroll(&stRow,-1,FALSE);
              break;
          case SB_PAGEDOWN:
              RowScroll(&stRow,stRow.lCharHeight,FALSE);
              break;
          case SB_PAGEUP:
              RowScroll(&stRow,-stRow.lCharHeight,FALSE);
              break;
         case SB_SLIDERPOSITION:
              RowScroll(&stRow,LOUSHORT(mp2),TRUE);
              break;
          default:
              break;
          }
        }
      break;
    case WM_BUTTON1DOWN:
      if(bFrameActivated)
        {
        if (!stCFG.bColumnDisplay && (stCFG.fDisplaying & (DISP_DATA | DISP_FILE)))
          {
          WinQueryPointerPos(HWND_DESKTOP,&ptl);
          WinQueryWindowPos(hwndFrame,&swp);
          ptl.y -= (swp.y + lcyBrdr + lStatusHeight);
          ptl.x -= (swp.x + lcxBrdr);
          lMouseRow = ((stRow.lCharHeight - (ptl.y / (stCell.cy * 2))) - 1);
          lMouseCol = (ptl.x / stCell.cx);
          DisplayCharacterInfo(hwnd,((lMouseRow * stRow.lCharWidth) + lMouseCol));
          }
        }
      else
        {
        WinSetFocus(HWND_DESKTOP,hwndFrame);
        WinSendMsg(WinQueryHelpInstance(hwndClient),HM_SET_ACTIVE_WINDOW,0L,0L);
        bFrameActivated = TRUE;
        }
      break;
    case WM_BUTTON2DOWN:
      if(bFrameActivated)
        {
        bNoPaint = TRUE;
        hwndMenu = WinLoadMenu(hwndClient,(HMODULE)NULL,IDMPU_ROW_DISP_POPUP);
//        hwndMenu = WinLoadMenu(hwndClient,(HMODULE)NULL,IDM_ROW_POPUP);
        if (mp1 != 0)
          {
          WinQueryPointerPos(HWND_DESKTOP,&ptl);
          if (!stCFG.bStickyMenus)
            ulMenuStyle |= PU_MOUSEBUTTON2DOWN;
          else
            ulMenuStyle &= ~(PU_MOUSEBUTTON2DOWN);
          }
        else
          {
          ulMenuStyle &= ~(PU_MOUSEBUTTON2DOWN);
          WinQueryWindowPos(hwndFrame,&swp);
          ptl.x = (swp.x + (swp.cx / 2));
          ptl.y = (swp.y + (swp.cy / 2));
          }
        if (stCFG.wRowFont == wASCIIfont)
          PopupMenuItemCheck(hwndMenu,IDMPU_ASCII_FONT,TRUE);
        else
          PopupMenuItemCheck(hwndMenu,IDMPU_HEX_FONT,TRUE);
        WinPopupMenu(HWND_DESKTOP,hwndClient,hwndMenu,ptl.x,ptl.y,usLastClientPopupItem,ulMenuStyle);
        }
      else
        {
        WinSetFocus(HWND_DESKTOP,hwndFrame);
        WinSendMsg(WinQueryHelpInstance(hwndClient),HM_SET_ACTIVE_WINDOW,0L,0L);
        bFrameActivated = TRUE;
        }
      break;
    case WM_PAINT:
      RowPaint(hwnd);
      break;
    case WM_CHAR:
      if (ProcessKeystroke(&stCFG,mp1,mp2))
        return((MRESULT)TRUE);
      return( WinDefWindowProc(hwnd,msg,mp1,mp2));
    case WM_SIZE:
      return WinDefWindowProc(hwnd,msg,mp1,WndSize(hwnd,mp1,mp2));
    case WM_ERASEBACKGROUND:
      return (MRESULT)(TRUE);
    case UM_INITMENUS:
      CreateColumnWindows();
      if (lFontsAvailable <= 2)
        MenuItemEnable(hwndFrame,IDM_TOGGLE_FONT_SIZE,FALSE);
      MenuItemEnable(hwndFrame,IDM_SURFACE_ALL,FALSE);
      usLastClientPopupItem = IDMPU_FONT;

      stCOMiCFG.cbSize = sizeof(COMICFG);
      stCOMiCFG.hwndFrame = hwndFrame;
      stCOMiCFG.hab = habAnchorBlock;
      stCOMiCFG.pszDriverIniSpec = NULL;

      stIOctl.hab = habAnchorBlock;
      stIOctl.pszPortName = stCFG.szPortName;

      if (bRemoteClient)
        {
        MenuItemEnable(hwndFrame,IDM_INSTALL,FALSE);
        stRemote.Length = sizeof(STARTDATA);
        stRemote.Related = SSF_RELATED_INDEPENDENT;
        stRemote.TraceOpt = SSF_TRACEOPT_NONE;
        stRemote.TermQ = 0;
        stRemote.Environment = 0;
        stRemote.InheritOpt = SSF_INHERTOPT_PARENT;
        stRemote.SessionType = SSF_TYPE_DEFAULT;
        stRemote.IconFile = 0;
        stRemote.PgmHandle = 0;
        stRemote.ObjectBuffer = 0;
        stRemote.ObjectBuffLen = 0;
        stRemote.PgmName = szNetRun;
        stRemote.PgmInputs = szNetRunParameters;
        stRemote.PgmControl = SSF_CONTROL_INVISIBLE;
        stRemote.FgBg = SSF_FGBG_BACK;
        rc = DosStartSession(&stRemote,&ulSessionID,&pidSession);
        if ((chPipeDebug > '0') && (rc != NO_ERROR))
          {
          switch (rc)
            {
            case ERROR_SMG_INVALID_SESSION_ID:
              ErrorNotify("Invalid Session ID, starting remote server");
              break;
            case ERROR_SMG_INVALID_CALL:
              ErrorNotify(szServerProgram);
              break;
            case ERROR_SMG_PROCESS_NOT_PARENT:
              ErrorNotify("Error starting remote server - Process not parent");
              break;
            case ERROR_SMG_RETRY_SUB_ALLOC:
              ErrorNotify("Retry Sub-Allocation, starting remote server");
              break;
            default:
              sprintf(szMessage,"Unkown Error = %u - starting remote server",rc);
              ErrorNotify(szMessage);
              break;
            }
          }
        }
      else
        {
        if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) != NO_ERROR)
          {
          sprintf(szMessage,"Unable to load configuration library - %s",CONFIG_LIBRARY);
          ErrorNotify(szMessage);
//          DosSleep(2000);
          MenuItemEnable(hwndFrame,IDM_INSTALL,FALSE);
          }
        else
          DosFreeModule(hMod);
        }
      if (hProfileInstance == NULL)
        MenuItemEnable(hwndFrame,IDM_MANAGE_CFG,FALSE);

      if (!InitializeSystem())
        {
        hCom = -1;
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        }
      else
        if (tidIPCserverThread != 0)
          DosResumeThread(tidIPCserverThread);
      if (stCFG.bStickyMenus)
        MenuItemCheck(hwndFrame,IDM_STICKY_MENUS,TRUE);
//      MenuItemEnable(hwndFrame,IDM_TRIGGER,FALSE);
      break;
    case UM_ENABLE_SERVER_ACCESS:
      MenuItemEnable(hwndFrame,IDM_SURFACE_ALL,TRUE);
      break;
    case UM_SURFACE:
      WinSetFocus(HWND_DESKTOP,hwndClient);
      WinSendMsg(hwndStatDev,WM_ACTIVATE,0L,0L);
      WinSendMsg(hwndStatModemIn,WM_ACTIVATE,0L,0L);
      WinSendMsg(hwndStatModemOut,WM_ACTIVATE,0L,0L);
      WinSendMsg(hwndStatRcvBuf,WM_ACTIVATE,0L,0L);
      WinSendMsg(hwndStatXmitBuf,WM_ACTIVATE,0L,0L);
      break;
    case UM_BUFFER_END:
      if (mp1 == NULL)
        {
        KillDisplayThread();
        MenuItemCheck(hwndFrame,IDM_MSTREAM,FALSE);
        MenuItemEnable(hwndFrame,IDM_MDISPLAY,FALSE);
        stCFG.bMonitoringStream = FALSE;
        sprintf(szMessage,"End of capture buffer\n%-ld characters stored\nMonitoring Aborted",stCFG.lBufferLength);
        WinMessageBox(HWND_DESKTOP,
                      hwnd,
                      szMessage,
                      stCFG.szPortName,
                      0,
                      MB_OK | MB_CUANOTIFICATION | MB_INFORMATION);

        }
      else
        {
        if (stCFG.bCaptureToFile)
          if (!WriteCaptureFile(szCaptureFileName,(WORD *)mp1,stCFG.lBufferLength,FOPEN_OVERWRITE,HLPP_MB_OVERWRT_CAP_FILE))
            {
            KillDisplayThread();
            KillMonitorThread();
            stCFG.bMonitoringStream = FALSE;
            DosDelete(szCaptureFileName);
            }
          else
            {
            bCaptureFileWritten = TRUE;
            IncrementFileExt(szCaptureFileName,FALSE);
            }
        DosFreeMem(mp1);
        }
      break;
    case UM_STARTMONITORTHREAD:
      MenuItemEnable(hwndFrame,IDM_LOADDAT,FALSE);
      MenuItemEnable(hwndFrame,IDM_SAVEDAT,FALSE);
      MenuItemEnable(hwndFrame,IDM_SAVEDATAS,FALSE);
      MenuItemCheck(hwndFrame,IDM_MSTREAM,TRUE);
      MenuItemEnable(hwndFrame,IDM_MDISPLAY,TRUE);
      MenuItemEnable(hwndFrame,IDM_VIEWDAT,FALSE);
      MenuItemCheck(hwndFrame,IDM_VIEWDAT,FALSE);
      if (stCFG.bShowCounts || stCFG.bSampleCounts)
        {
        WinSendMsg(hwndStatus,WM_TIMER,0,0);
        WinPostMsg(hwndStatus,UM_STARTTIMER,0L,0L);
        }
      else
        WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
      break;
    case UM_KILLMONITORTHREAD:
      if (!stCFG.bCaptureToFile && bDataToView)
        {
        MenuItemEnable(hwndFrame,IDM_SAVEDAT,TRUE);
        MenuItemEnable(hwndFrame,IDM_SAVEDATAS,TRUE);
        }
      MenuItemEnable(hwndFrame,IDM_LOADDAT,TRUE);
      MenuItemCheck(hwndFrame,IDM_MSTREAM,FALSE);
      MenuItemEnable(hwndFrame,IDM_MDISPLAY,FALSE);
      WinPostMsg(hwndStatus,UM_STOPTIMER,0L,0L);
      WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
      break;
    case UM_VIEWDAT_ON:
      MenuItemEnable(hwndFrame,IDM_VIEWDAT,TRUE);
      break;
    case WM_DESTROY:
      GpiDestroyPS(hpsPs);
      break;
    case UM_PIPE_QUIT:
      bExternalKill = TRUE;
#if DEBUG > 3
      sprintf(szMessage,"PIPE QUIT message received");
      MessageBox(HWND_DESKTOP,szMessage);
      goto gtDoExitStuff;
#endif
    case WM_CLOSE:
#if DEBUG > 3
      sprintf(szMessage,"WM_CLOSE message received");
      MessageBox(HWND_DESKTOP,szMessage);
      goto gtDoExitStuff;
#endif
    case WM_SAVEAPPLICATION:
#if DEBUG > 3
      sprintf(szMessage,"WM_SAVEAPPLICATION message received");
      MessageBox(HWND_DESKTOP,szMessage);
gtDoExitStuff:
#endif
      KillDisplayThread();
      KillMonitorThread();

      if (hProfileInstance != NULL)
        {
        if (stCFG.bLoadMonitor)
          {
          if (stCFG.fDisplaying & DISP_FILE)
            {
            stCFG.lReadColScrollIndex = stRead.lScrollIndex;
            stCFG.lWriteColScrollIndex = stWrite.lScrollIndex;
            stCFG.lRowScrollIndex = stRow.lScrollIndex;
            }
          }
        SaveWindowPositions();
        if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
          {
          if (DosQueryProcAddr(hMod,0,"SaveProfileData",(PFN *)&pfnSaveProfileData) == NO_ERROR)
            pfnSaveProfileData(hProfileInstance,"Search String",(BYTE *)swSearchString,(lSearchStrLen * 2));
          if (stCFG.bAutoSaveConfig && stCFG.bCaptureToFile && (szCaptureFileName[0] != 0))
            if (DosQueryProcAddr(hMod,0,"SaveProfileString",(PFN *)&pfnSaveProfileString) == NO_ERROR)
              pfnSaveProfileString(hProfileInstance,"Capture File",szCaptureFileName);
          if (DosQueryProcAddr(hMod,0,"CloseProfile",(PFN *)&pfnCloseProfile) == NO_ERROR)
            hProfileInstance = pfnCloseProfile(hProfileInstance);
          DosFreeModule(hMod);
          }
        }
      if (bRemoteAccess)
        {
        if (bRemoteClient)
          {
          stPipeCmd.cbMsgSize = sizeof(PIPECMD);
          stPipeCmd.ulCommand = UM_PIPE_QUIT;
          rc = DosCallNPipe(szCOMscopePipe,&stPipeCmd,sizeof(PIPECMD),&stPipeCmd,sizeof(PIPECMD),&ulBytesRead,10000);
          }

        if (bRemoteServer)
          bStopRemotePipe = TRUE;
        }
      else
        {
        if (bLaunchShutdownServer)
          {
          bStopIPCserverThread = TRUE;
          DosSleep(10);
          if (!bExternalKill)
            {
            bExternalKill = TRUE;
            DosRequestMutexSem(hmtxIPCpipeBlockedSem,10000);
            stIPCpipe.ulInstance = ulIPCpipeInstance;
            stIPCpipe.ulMessage = UM_PIPE_END;
            while ((rc = DosCallNPipe(szIPCpipe,&stIPCpipe,sizeof(IPCPIPEMSG),&stIPCpipe,sizeof(IPCPIPEMSG),&ulBytesRead,10000)) == ERROR_PIPE_BUSY)
              if (chPipeDebug > '0')
                ErrorNotify("Pipe busy, sending process end message.");
            DosReleaseMutexSem(hmtxIPCpipeBlockedSem);
            }
          }
        }
      WinPostMsg(hwnd,WM_QUIT,0L,0L);
      break;
    default:
      return WinDefWindowProc(hwnd,msg,mp1,mp2);
    }
  return(FALSE);
  }

VOID RowPaint(HWND hwnd)
  {
  HPS hps;
  RECTL rclRect;
  LONG lIndex;
  static POINTL stPos;
  LONG lWriteRow;
  LONG lReadRow;
  LONG lCol;
  LONG lCount;
  LONG lSaveCount;
  APIRET rc;
  char szMessage[80];
  WORD wChar;
  WORD wDirection;
  static WORD wLastDirection;
  BOOL bDisplayCharacter = TRUE;
  BOOL bDisplaySignal = FALSE;
  static BOOL bLastWasOverflow = FALSE;

  if ((rc = DosRequestMutexSem(hmtxRowGioBlockedSem,-1)) != NO_ERROR)
    {
    sprintf(szMessage,"DosRequestMutexSem error in RowPaint: return code = %ld", rc);
    ErrorNotify(szMessage);
    }
  WinInvalidateRect(hwnd,(PRECTL)NULL,FALSE);
  hps = WinBeginPaint(hwnd,(HPS)NULL,&rclRect);
  if (WinIsWindowShowing(hwnd))
    {
    if (!stCFG.bColumnDisplay && !bNoPaint)
      {
      rclRect.yBottom = stRow.lHeight;
      rclRect.yTop = stRow.lHeight + stCell.cy;
      rclRect.xLeft = 0;
      rclRect.xRight = (stRow.lWidth + stCell.cx + 2);
      while (rclRect.yBottom > lStatusHeight)
        {
        WinFillRect(hps,&rclRect,stCFG.lReadBackgrndColor);
        rclRect.yBottom -= stCell.cy;
        if (rclRect.yBottom <= (lStatusHeight + 2))
          rclRect.yBottom -= 4;        // make sure bottom row overlaps status area
        rclRect.yTop -= stCell.cy;
        WinFillRect(hps,&rclRect,stCFG.lWriteBackgrndColor);
        rclRect.yBottom -= stCell.cy;
        rclRect.yTop -= stCell.cy;
        }
      if (stCFG.bMonitoringStream)
        {
        wLastDirection = CS_READ;
        stRow.lCursorReadRow = stRow.lHeight;
        stRow.lCursorWriteRow = stRow.lCursorReadRow - stCell.cy;
        stRow.lLeadReadRow = stRow.lCursorReadRow;
        stRow.lLeadWriteRow = stRow.lCursorWriteRow;
        stRow.Pos.x= 0;
        }
      else
        {
        if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
          {
          lIndex = stRow.lScrollIndex;
          lReadRow = stRow.lHeight;
          lWriteRow = lReadRow - stCell.cy;
          lCount = lScrollCount;
          lSaveCount = lCount;
          GpiCreateLogFont(hps,
                   (PSTR8)"HEXFONTS",
                           2,
                          &astFontAttributes[stCFG.wRowFont]);
          GpiSetCharSet(hps,2);
          GpiSetBackMix(hps,BM_OVERPAINT);
          lCol = 0;
          wLastDirection = CS_READ;
          while (1)
            {
            if (lIndex == lCount)
              break;
            wChar = pwScrollBuffer[lIndex];
            wDirection = (wChar & 0xff00);
#ifdef this_junk
            if (stCFG.bCompressDisplay &&
               (wLastDirection == CS_WRITE) && (wDirection == CS_READ))
              lCol -= stCell.cx;
#endif
            if (wDirection != CS_READ_BUFF_OVERFLOW)
              bLastWasOverflow = FALSE;
            switch (wDirection)
              {
              case CS_PACKET_DATA:
                lIndex += (wChar & 0xff);
                bDisplayCharacter = FALSE;
                break;
              case CS_READ:
                if (stCFG.bDispRead)
                  {
                  stPos.y = lReadRow;
                  GpiSetBackColor(hps,stCFG.lReadBackgrndColor);
                  GpiSetColor(hps,stCFG.lReadForegrndColor);
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_WRITE:
                if (stCFG.bDispWrite)
                  {
                  stPos.y = lWriteRow;
                  GpiSetBackColor(hps,stCFG.lWriteBackgrndColor);
                  GpiSetColor(hps,stCFG.lWriteForegrndColor);
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_WRITE_IMM:
                if (stCFG.bDispIMM)
                  {
                  wDirection = CS_WRITE;
                  stPos.y = lWriteRow;
                  if (stCFG.bHiLightImmediateByte)
                    {
                    GpiSetBackColor(hps,stCFG.lWriteForegrndColor);
                    GpiSetColor(hps,stCFG.lWriteBackgrndColor);
                    }
                  else
                    {
                    GpiSetBackColor(hps,stCFG.lWriteBackgrndColor);
                    GpiSetColor(hps,stCFG.lWriteForegrndColor);
                    }
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_READ_IMM:
                if (stCFG.bDispIMM)
                  {
                  wDirection = CS_READ;
                  stPos.y = lReadRow;
                  if (stCFG.bHiLightImmediateByte)
                    {
                    GpiSetBackColor(hps,stCFG.lReadForegrndColor);
                    GpiSetColor(hps,stCFG.lReadBackgrndColor);
                    }
                  else
                    {
                    GpiSetBackColor(hps,stCFG.lReadBackgrndColor);
                    GpiSetColor(hps,stCFG.lReadForegrndColor);
                    }
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_MODEM_IN:
                if (stCFG.bDispModemIn)
                  {
                  bDisplaySignal = TRUE;
                  stPos.y = lReadRow;
                  GpiSetBackColor(hps,stCFG.lModemInBackgrndColor);
                  GpiSetColor(hps,stCFG.lModemInForegrndColor);
                  if (stCFG.wRowFont & 0x01)
                    {
                    wChar &= 0xf0;
                    wChar >>= 4;
                    if (wChar < 10)
                      wChar += '0';
                    else
                      wChar += ('A' - 10);
                    }
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_MODEM_OUT:
                if (stCFG.bDispModemOut)
                  {
                  bDisplaySignal = TRUE;
                  stPos.y = lWriteRow;
                  GpiSetBackColor(hps,stCFG.lModemOutBackgrndColor);
                  GpiSetColor(hps,stCFG.lModemOutForegrndColor);
                  wChar &= 0x03;
                  if (stCFG.wRowFont & 0x01)
                    wChar += '0';
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_DEVIOCTL:
                if (stCFG.bDispDevIOctl)
                  {
                  bDisplaySignal = TRUE;
                  stPos.y = lWriteRow;
                  GpiSetBackColor(hps,stCFG.lDevIOctlBackgrndColor);
                  GpiSetColor(hps,stCFG.lDevIOctlForegrndColor);
                  if (stCFG.wRowFont & 0x01)
                    wChar = 'F';
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_HDW_ERROR:
                if (stCFG.bDispErrors)
                  {
                  bDisplaySignal = TRUE;
                  stPos.y = lReadRow;
                  GpiSetBackColor(hps,stCFG.lErrorBackgrndColor);
                  GpiSetColor(hps,stCFG.lErrorForegrndColor);
                  if (stCFG.wRowFont & 0x01)
                    wChar = 'E';
                  else
                    wChar &= 0x1e;
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_READ_BUFF_OVERFLOW:
                if (stCFG.bDispErrors)
                  {
                  if (!bLastWasOverflow)
                    {
                    bDisplaySignal = TRUE;
                    bLastWasOverflow = TRUE;
                    stPos.y = lReadRow;
                    GpiSetBackColor(hps,stCFG.lErrorBackgrndColor);
                    GpiSetColor(hps,stCFG.lErrorForegrndColor);
                    if (stCFG.wRowFont & 0x01)
                      wChar = 'V';
                    else
                      wChar = 0xff;
                    }
                  else
                    bDisplayCharacter = FALSE;
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_BREAK_RX:
                if (stCFG.bDispErrors)
                  {
                  bDisplaySignal = TRUE;
                  stPos.y = lReadRow;
                  GpiSetBackColor(hps,stCFG.lErrorBackgrndColor);
                  GpiSetColor(hps,stCFG.lErrorForegrndColor);
                  if (stCFG.wRowFont & 0x01)
                    wChar = 'B';
                  else
                    wChar = 0xBB;
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_BREAK_TX:
                if (stCFG.bDispModemOut)
                  {
                  bDisplaySignal = TRUE;
                  stPos.y = lWriteRow;
                  GpiSetBackColor(hps,stCFG.lModemOutBackgrndColor);
                  GpiSetColor(hps,stCFG.lModemOutForegrndColor);
                  if (stCFG.wRowFont & 0x01)
                    if (wChar & LINE_CTL_SEND_BREAK)
                      wChar = 'B';
                    else
                      wChar = 'b';
                  else
                    if (wChar & LINE_CTL_SEND_BREAK)
                      wChar = 0xB1;
                    else
                      wChar = 0xB0;
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_WRITE_REQ:
                if (stCFG.bDispWriteReq)
                  {
                  bDisplaySignal = TRUE;
                  stPos.y = lWriteRow;
                  GpiSetBackColor(hps,stCFG.lWriteReqBackgrndColor);
                  GpiSetColor(hps,stCFG.lWriteReqForegrndColor);
                  if (stCFG.wRowFont & 0x01)
                    wChar = 'W';
                  else
                    if ((wChar & 0xff) == 0)
                      wChar = 0xD0;
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_WRITE_CMPLT:
                if (stCFG.bDispWriteReq)
                  {
                  bDisplaySignal = TRUE;
                  stPos.y = lWriteRow;
                  GpiSetBackColor(hps,stCFG.lWriteReqBackgrndColor);
                  GpiSetColor(hps,stCFG.lWriteReqForegrndColor);
                  if (stCFG.wRowFont & 0x01)
                    wChar = 'w';
                  else
                    if ((wChar & 0xff) == 0)
                      wChar = 0xD1;
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_READ_REQ:
                if (stCFG.bDispReadReq)
                  {
                  bDisplaySignal = TRUE;
                  stPos.y = lReadRow;
                  GpiSetBackColor(hps,stCFG.lReadReqBackgrndColor);
                  GpiSetColor(hps,stCFG.lReadReqForegrndColor);
                  if (stCFG.wRowFont & 0x01)
                    wChar = 'R';
                  else
                    if ((wChar & 0xff) == 0)
                      wChar = 0xB0;
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_READ_CMPLT:
                if (stCFG.bDispReadReq)
                  {
                  bDisplaySignal = TRUE;
                  stPos.y = lReadRow;
                  GpiSetBackColor(hps,stCFG.lReadReqBackgrndColor);
                  GpiSetColor(hps,stCFG.lReadReqForegrndColor);
                  if (stCFG.wRowFont & 0x01)
                    wChar = 'r';
                  else
                    if ((wChar & 0xff) == 0)
                      wChar = 0xB1;
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_OPEN_ONE:
                if (stCFG.bDispOpen)
                  {
                  bDisplaySignal = TRUE;
                  stPos.y = lWriteRow;
                  GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
                  GpiSetColor(hps,stCFG.lOpenForegrndColor);
                  if (stCFG.wRowFont & 0x01)
                    wChar = 'O';
                  else
                    wChar = 0x00;
                  }                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_OPEN_TWO:
                if (stCFG.bDispOpen)
                  {
                  bDisplaySignal = TRUE;
                  stPos.y = lWriteRow;
                  GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
                  GpiSetColor(hps,stCFG.lOpenForegrndColor);
                  if (stCFG.wRowFont & 0x01)
                    wChar = 'o';
                  else
                    wChar = 0x01;
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_CLOSE_ONE:
                if (stCFG.bDispOpen)
                  {
                  bDisplaySignal = TRUE;
                  stPos.y = lWriteRow;
                  GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
                  GpiSetColor(hps,stCFG.lOpenForegrndColor);
                  if (stCFG.wRowFont & 0x01)
                    wChar = 'C';
                  else
                    wChar = 0xc0;
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              case CS_CLOSE_TWO:
                if (stCFG.bDispOpen)
                  {
                  bDisplaySignal = TRUE;
                  stPos.y = lWriteRow;
                  GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
                  GpiSetColor(hps,stCFG.lOpenForegrndColor);
                  if (stCFG.wRowFont & 0x01)
                    wChar = 'c';
                  else
                    wChar = 0xc1;
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              default:
                if (bDebuggingCOMscope)
                  {
                  wChar >>= 8;
                  GpiSetBackColor(hps,CLR_RED);
                  GpiSetColor(hps,CLR_WHITE);
                  }
                else
                  bDisplayCharacter = FALSE;
                break;
              }
            if (bDisplayCharacter)
              {
              stPos.x = lCol;
              GpiCharStringAt(hps,&stPos,1,(char *)&wChar);
              if (lCol >= stRow.lWidth)
                {
#ifdef this_junk
                if (!bDisplaySignal && stCFG.bCompressDisplay && (lIndex < lSaveCount))
                  {
                  if (wDirection != CS_READ)
                    {
                    wChar = pwScrollBuffer[lIndex + 1];
                    if (((wChar & 0xff00) == CS_READ) || ((wChar & 0xff00) == CS_READ_IMM))
                      {
                      if ((wChar & 0xff00) == CS_READ)
                        {
                        GpiSetColor(hps,CLR_WHITE);
                        WinFillRect(hps,&rclRect,stCFG.lReadBackgrndColor);
                        }
                      else
                        if (stCFG.bHiLightImmediateByte)
                          {
                          GpiSetColor(hps,CLR_BLACK);
                          WinFillRect(hps,&rclRect,stCFG.lWriteBackgrndColor);
                          }
                      stPos.y = lReadRow;
                      GpiCharStringAt(hps,&stPos,1,(char *)&wChar);
                      wDirection = CS_READ;
                      lIndex++;
                      }
                    }
                  }
                else
#endif
                  bDisplaySignal = FALSE;
                if (lWriteRow < (lStatusHeight + 2))
                  break;
                lReadRow -= (stCell.cy * 2);
                lWriteRow = (lReadRow - stCell.cy);
                lCol = 0;
                }
              else
                {
                lCol += stCell.cx;
                wLastDirection = wDirection;
                }
              }
            else
              bDisplayCharacter = TRUE;
            lIndex++;
            }
          }
        }
      }
    }
  bNoPaint = FALSE;
  WinEndPaint(hps);
  if ((rc = DosReleaseMutexSem(hmtxRowGioBlockedSem)) != NO_ERROR)
    {
    sprintf(szMessage,"DosReleaseMutexSem error in RowPaint: return code = %ld", rc);
    ErrorNotify(szMessage);
    }
  }

BOOL CreatePS(HWND hwnd)
  {
  ERRORID eidWinError = 0;
  LONG lRemainingFonts;
  LONG lFontCount;
  LONG lIndex;
  HPS hps;
  BOOL bSuccess = TRUE;

  if (DosSearchPath(SEARCH_IGNORENETERRS |
                    SEARCH_CUR_DIRECTORY |
                    SEARCH_ENVIRONMENT,
                    "DPATH",
                    szFontFileName,
                    szFontFilePath,
                    CCHMAXPATH) != NO_ERROR)
    {
    lIndex = 0;
    while (szFontFileName[lIndex] != 0)
      {
      szFontFileName[lIndex] = toupper(szFontFileName[lIndex]);
      lIndex++;
      }
    sprintf(szErrorMessage,"Make sure \"%s\" is in the default directory or in a directory listed in the \"DPATH\" environment variable.",szFontFileName);
    sprintf(szTitle,"Unable to locate font file!");
    return(FALSE);
    }
  hdcPs = WinOpenWindowDC(hwnd);
  hps = WinGetPS(hwnd);

  lFontCount = 0;
  lRemainingFonts = GpiQueryFontFileDescriptions(habAnchorBlock,
                                                 szFontFilePath,
                                                 &lFontCount,
                                                 (FFDESCS *)astFontNames);
  if (lRemainingFonts == GPI_ALTERROR)
    {
    eidWinError = WinGetLastError(habAnchorBlock);
    sprintf(szErrorMessage,"\"%s\" is not valid Font File.\n\n Code = (0-%X)",szFontFilePath,eidWinError);
    sprintf(szTitle,"Bad Font File!");
    bSuccess = FALSE;
    }
  else
    {
    lFontCount = lRemainingFonts;
    if (lFontCount > MAX_FONTS)
      lFontCount = MAX_FONTS;
    lRemainingFonts = GpiQueryFontFileDescriptions(habAnchorBlock,
                                                   szFontFilePath,
                                                   &lFontCount,
                                                   (FFDESCS *)astFontNames);
    if (lRemainingFonts != GPI_ALTERROR)
      {
      if (GpiLoadFonts(habAnchorBlock,szFontFilePath))
        {
        lFontsAvailable = lFontCount;
        for (lIndex = 0;lIndex < lFontsAvailable;lIndex++)
          {
          lFontCount = 1;
          lRemainingFonts = GpiQueryFonts(hps,
                                 QF_PRIVATE,
                                 astFontNames[lIndex].szFaceName,
                                 &lFontCount,
                                 sizeof(FONTMETRICS),
                                 &astFontMetrics[lIndex]);
          if (lRemainingFonts != GPI_ALTERROR)
            {
            astFontAttributes[lIndex].usRecordLength = sizeof(FATTRS);
            astFontAttributes[lIndex].fsSelection = 0;
            astFontAttributes[lIndex].lMatch = astFontMetrics[lIndex].lMatch;
            strcpy(astFontAttributes[lIndex].szFacename,astFontMetrics[lIndex].szFacename);
            astFontAttributes[lIndex].idRegistry = astFontMetrics[lIndex].idRegistry;
            astFontAttributes[lIndex].usCodePage = astFontMetrics[lIndex].usCodePage;
            astFontAttributes[lIndex].lMaxBaselineExt = astFontMetrics[lIndex].lMaxBaselineExt;
            astFontAttributes[lIndex].lAveCharWidth = astFontMetrics[lIndex].lAveCharWidth;
            astFontAttributes[lIndex].fsType = 0;
            astFontAttributes[lIndex].fsFontUse = FATTR_FONTUSE_NOMIX;
            }
          else
            {
            eidWinError = WinGetLastError(habAnchorBlock);
            sprintf(szErrorMessage,"\"%s\" is not valid Font File.\n\n Code = (1-%X)",szFontFilePath,eidWinError);
            sprintf(szTitle,"Bad Font File!");
            bSuccess = FALSE;
            }
          }
        }
      else
        {
        eidWinError = WinGetLastError(habAnchorBlock);
        sprintf(szErrorMessage,"\"%s\" is not valid Font File.\n\n Code = (2-%X)",szFontFilePath,eidWinError);
        sprintf(szTitle,"Bad Font File!");
        bSuccess = FALSE;
        }
      }
    else
      {
      eidWinError = WinGetLastError(habAnchorBlock);
      sprintf(szErrorMessage,"\"%s\" is not valid Font File.\n\n Code = (3-%X)",szFontFilePath,eidWinError);
      sprintf(szTitle,"Bad Font File!");
      bSuccess = FALSE;
      }
    }
  WinReleasePS(hps);
  return(bSuccess);
  }

/**************************************************************************/
/* FRAMESUBPROC:                                                          */
/* The purpose of the frame window subclass procedure is to restrict      */
/* frame window sizing so that it is in step with the size of the */
/* Presentation Space.                                                    */
/* Messages for the frame window are sent here first, so that             */
/* processing can be carried out should it be necessary to modify the     */
/* operation of the frame window.                                         */
/**************************************************************************/
MRESULT EXPENTRY  FrameSubProc(HWND hwnd,WORD msg,MPARAM mp1,MPARAM mp2 )
  {
  PTRACKINFO pTrack;

  switch (msg)
    {
#ifdef this_junk
    case WM_CHAR:
      if (bSendNextKeystroke)
        if (ProcessKeystroke(&stCFG,mp1,mp2))
          return((MRESULT)TRUE);
      return( WinDefWindowProc(hwnd,msg,mp1,mp2));
#endif
    case WM_QUERYTRACKINFO:
      /*
      ** Invoke the normal frame window procedure first.
      ** This updates the tracking rectangle to the new position.
      */
      (*FrameProcess)(hwnd,msg,mp1,mp2);
      pTrack = (PTRACKINFO)mp2;

        /*
      if (pTrack->rclTrack.yBottom != pOldTrack->rclTrack.yBottom)
        iTemp = 0;
        ** Only limit the bounding rectangle if the operation is SIZING.
        ** Moving continues as normal.
        */
      if(((pTrack->fs & TF_MOVE) != TF_MOVE) &&
         ((pTrack->fs & TF_LEFT)   ||
          (pTrack->fs & TF_TOP)    ||
          (pTrack->fs & TF_RIGHT)  ||
          (pTrack->fs & TF_BOTTOM) ||
          (pTrack->fs & TF_SETPOINTERPOS)))
        {
        /*
        ** Make sure that the window is only SIZED in (character-height * 2) or
        ** (character-width) steps.
        */
        pTrack->cyGrid = (stCell.cy * 2);
        pTrack->cyKeyboard = (stCell.cy * 2);
        pTrack->cxGrid = stCell.cx;
        pTrack->cxKeyboard = stCell.cx;
        pTrack->fs |= (TF_GRID | TF_ALLINBOUNDARY);

        pTrack->ptlMinTrackSize.x = lMinimumWidth;
        pTrack->ptlMinTrackSize.y = lMinimumHeight;
        pTrack->ptlMaxTrackSize.x = (lXScr - (lcxBrdr * 2) - (lXScr % stCell.cx));
        pTrack->ptlMaxTrackSize.y = (lYScr - (lcyBrdr * 2) - (lYScr % (stCell.cy * 2)) - lStatusHeight);
        }
      else
        /*
        ** Any movement in the x and y directions occurs, as usual, in pel units.
        */
        if( ( pTrack->fs & TF_MOVE ) == TF_MOVE )
          {
          pTrack->cxGrid = 1;
          pTrack->cyGrid = 1;
          pTrack->cxKeyboard = 1;
          pTrack->cyKeyboard = 1;
          pTrack->fs |= TF_GRID;
          }

      return(MRESULT)(TRUE);
    }
  return((*FrameProcess)( hwnd, msg, mp1, mp2 ));
  }

MPARAM WndSize(HWND hwnd,MPARAM mpOldSize,MPARAM mpNewSize)
  {
  APIRET rc;
  char szMessage[80];

  if (hwndFrame == (HWND)NULL)
    hwndFrame = WinQueryWindow(hwnd,QW_PARENT);

  bStatusSized = TRUE;
  WinSetWindowPos(hwndStatus,
                  0,
                  0,
                  0,
                  LOUSHORT(mpNewSize),
                  lStatusHeight,
                  SWP_SIZE);


  ClearRowScrollBar(&stRow);
  if ((rc = DosRequestMutexSem(hmtxRowGioBlockedSem,10000)) != NO_ERROR)
    {
    sprintf(szMessage,"DosRequestMutexSem error in WndSize: return code = %ld", rc);
    ErrorNotify(szMessage);
    }

  lLastHeight = (LONG)HIUSHORT(mpNewSize);
  lLastWidth = (LONG)LOUSHORT(mpNewSize);
  stRow.lCharWidth = (lLastWidth / stCell.cx);
  stRow.lWidth = (lLastWidth - stCell.cx);
  stRow.lCharHeight = ((lLastHeight - lStatusHeight) / (stCell.cy * 2));
  stRow.lHeight = (lLastHeight - stCell.cy);
  stRow.lCharSize = (stRow.lCharWidth * stRow.lCharHeight);

  if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
    {
    if (!stCFG.bColumnDisplay)
      SetupRowScrolling(&stRow);
    }
  else
    if (stCFG.fDisplaying & DISP_STREAM)
      {
      if (stCFG.bColumnDisplay)
        {
        stRead.Pos.y = stRead.lHeight;
        stWrite.Pos.y = stWrite.lHeight;
        stRead.Pos.x = 0L;
        stWrite.Pos.x = 0L;
        }
      else
        {
        stRow.lLeadReadRow = stRow.lHeight;
        stRow.lLeadWriteRow = stRow.lLeadReadRow - stCell.cy;
        stRow.lCursorReadRow = stRow.lLeadReadRow;
        stRow.lCursorWriteRow = stRow.lLeadWriteRow;
        stRow.Pos.x = 0;
        stRow.lLeadIndex = lWriteIndex;
        }
      }

  if ((rc = DosReleaseMutexSem(hmtxRowGioBlockedSem)) != NO_ERROR)
    {
    sprintf(szMessage,"DosReleaseMutexSem error in WndSize: return code = %ld", rc);
    ErrorNotify(szMessage);
    }
  if (stWrite.bActive)
    WinSendMsg(stWrite.hwndClient,UM_TRACKFRAME,0L,0L);
  if (stRead.bActive)
    WinSendMsg(stRead.hwndClient,UM_TRACKFRAME,0L,0L);
  WinInvalidateRect(hwnd,(PRECTL)NULL,FALSE);
  return(mpNewSize);
  }

/*
** STATUSPROC:
** Window procedure for the one-line status window.
** Displays the buffer position, and error messages.  Also displays
** character count calculations.
*/
MRESULT EXPENTRY StatusProc(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  HPS    hps;
  RECTL  rcl;
  POINTL ptl;
  HWND hwndMenu;
  SWP swp;
  int iLen;
  int iIndex;
  CLRDLG stColor;
  DIAGCOUNTS stCounts;
  static char szLastErrorMessage[200];
  static USHORT usLastPopupItem;
  char szString[CCHMAXPATH + 20];
  static ULONG idTimer = 0;
  char szCounts[40];
  ULONG ulByteCount;
  static char szLastCounts[80];
  static lMessageDelay;
  static BOOL bLastCount;
  static USHORT ulMenuStyle;
  static BOOL bDiagCountsCapable;
  static aulRxByteCount[MAX_CPS_SAMPLES + 1];
  static aulTxByteCount[MAX_CPS_SAMPLES + 1];
  static int iWindow;
  static ulRxByteCount = 0;
  static ulTxByteCount = 0;
  static iCPSdivisor;
  static iCPSmultiplier;

  switch (msg)
    {
    case WM_CREATE:
      usLastPopupItem = IDMPU_LAST_MSG;
      stColor.cbSize = sizeof(CLRDLG);
      if (stCFG.bShowCounts && stCFG.bSampleCounts)
        sprintf(szLastCounts,"Tx(0, 0)   Rx(0, 0)");
      else
        if (stCFG.bSampleCounts)
          sprintf(szLastCounts,"Tx(0 CPS)   Rx(0 CPS)");
        else
          sprintf(szLastCounts,"Tx(0)   Rx(0)");
      bDiagCountsCapable = FALSE;
      memset(aulRxByteCount,0,(MAX_CPS_SAMPLES + 1));
      memset(aulTxByteCount,0,(MAX_CPS_SAMPLES + 1));
      if (stCFG.iSampleCount > MAX_CPS_SAMPLES)
        stCFG.iSampleCount = MAX_CPS_SAMPLES;
      ulMenuStyle = (PU_POSITIONONITEM | PU_MOUSEBUTTON2 | PU_HCONSTRAIN | PU_VCONSTRAIN | PU_KEYBOARD | PU_MOUSEBUTTON1);
      break;
    case WM_COMMAND:
        switch (SHORT1FROMMP(mp1))
          {
          case IDMPU_SILENT_STATUS:
            if (!stCFG.bStickyMenus)
              usLastPopupItem = IDMPU_SILENT_STATUS;
            else
              usLastPopupItem = IDMPU_LAST_MSG;
            if (stCFG.bSilentStatus)
              stCFG.bSilentStatus = FALSE;
            else
              stCFG.bSilentStatus = TRUE;
            break;
          case IDMPU_LAST_COUNT:
            if (!stCFG.bStickyMenus)
              usLastPopupItem = IDMPU_LAST_COUNT;
            else
              usLastPopupItem = IDMPU_LAST_MSG;
            if (idTimer == 0)
              {
              strcpy(szErrorMessage,szLastCounts);
              bLastCount = TRUE;
              WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
              }
            break;
          case IDMPU_LAST_MSG:
            usLastPopupItem = IDMPU_LAST_MSG;
            strcpy(szErrorMessage,szLastErrorMessage);
            WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
            if (stCFG.bShowCounts || stCFG.bSampleCounts)
              if (stCFG.wUpdateDelay <= 3000)
                lMessageDelay = (3000 / stCFG.wUpdateDelay);
              else
                lMessageDelay = 1;
            break;
          case IDMPU_COLORS:
            if (!stCFG.bStickyMenus)
              usLastPopupItem = IDMPU_COLORS;
           else
              usLastPopupItem = IDMPU_LAST_MSG;
            stColor.lForeground = stCFG.lStatusForegrndColor;
            stColor.lBackground = stCFG.lStatusBackgrndColor;
            sprintf(stColor.szCaption,"Status Line Display Colors");
            if (WinDlgBox(HWND_DESKTOP,
                          hwnd,
                   (PFNWP)fnwpSetColorDlg,
                  (USHORT)NULL,
                          CLR_DLG,
                  MPFROMP(&stColor)))
              {
              stCFG.lStatusForegrndColor = stColor.lForeground;
              stCFG.lStatusBackgrndColor = stColor.lBackground;
              WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
              }
            break;
          }
        break;
    case WM_BUTTON2DOWN:
      if(bFrameActivated)
        {
        hwndMenu = WinLoadMenu(hwndStatus,(HMODULE)NULL,IDMPU_STATUS_POPUP);
        if (mp1 != 0)
          {
          WinQueryPointerPos(HWND_DESKTOP,&ptl);
          if (!stCFG.bStickyMenus)
            ulMenuStyle |= PU_MOUSEBUTTON2DOWN;
          else
            ulMenuStyle &= ~PU_MOUSEBUTTON2DOWN;
          }
        else
          {
          ulMenuStyle &= ~PU_MOUSEBUTTON2DOWN;
          WinQueryWindowPos(hwndFrame,&swp);
          ptl.x = (swp.x + (swp.cx / 2));
          ptl.y = (swp.y + 5);
          }
        if (stCFG.bSilentStatus)
          PopupMenuItemCheck(hwndMenu,IDMPU_SILENT_STATUS,TRUE);
        else
          PopupMenuItemCheck(hwndMenu,IDMPU_SILENT_STATUS,FALSE);
        WinPopupMenu(HWND_DESKTOP,hwndStatus,hwndMenu,ptl.x,ptl.y,usLastPopupItem,ulMenuStyle);
        }
      else
        {
        WinSetFocus(HWND_DESKTOP,hwndFrame);
        WinSendMsg(WinQueryHelpInstance(hwndClient),HM_SET_ACTIVE_WINDOW,0L,0L);
        bFrameActivated = TRUE;
        }
      break;
    case WM_PAINT:
      WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
      hps = WinBeginPaint(hwnd,(HPS)NULL,&rcl);
      WinQueryWindowRect(hwndClient,&rcl);
      rcl.yTop = lStatusHeight;
      rcl.yBottom = 0;
      rcl.xLeft = 0;

      WinFillRect(hps,&rcl,stCFG.lStatusBackgrndColor);
      GpiSetBackColor(hps,stCFG.lStatusBackgrndColor);
      GpiSetColor(hps,stCFG.lStatusForegrndColor);
      GpiSetBackMix(hps,BM_OVERPAINT);

      ptl.y = ((lStatusHeight / 2) - 5);//5L + iFontSizeIndex;
      ptl.x = 6L;
      if (szErrorMessage[0] != 0)
        {
        GpiCharStringAt(hps,&ptl,(LONG)strlen(szErrorMessage),szErrorMessage);
        if (!bLastCount)
          strcpy(szLastErrorMessage,szErrorMessage);
        else
          bLastCount = FALSE;
        szErrorMessage[0] = 0;
        if (stCFG.bShowCounts || stCFG.bSampleCounts)
          if (stCFG.wUpdateDelay <= 3000)
            lMessageDelay = (3000 / stCFG.wUpdateDelay);
          else
            lMessageDelay = 1;
        }
      else
        {
        if(stCFG.bMonitoringStream)
          {
          if (!stCFG.bShowCounts && !stCFG.bSampleCounts)
            {
            if (stCFG.bColumnDisplay)
              {
              if (stCFG.fDisplaying != 0)
                {
                GpiCharStringAt(hps,&ptl,8L,"Transmit");
                ptl.x += stRead.rcl.xLeft;
                GpiCharStringAt(hps,&ptl,9L,"Receive  ");
                }
              }
            else
              GpiCharStringAt(hps,&ptl,17L,"Capturing Stream ");
            }
          }
        else
          if (stCFG.fDisplaying & DISP_FILE)
            {
            sprintf(szString,"Viewing %s",szDataFileSpec);
            GpiCharStringAt(hps,&ptl,strlen(szString),szString);
            }
          else
            if (stCFG.fDisplaying & DISP_DATA)
              GpiCharStringAt(hps,&ptl,21,"Viewing Captured Data");
        }

      if ((stCFG.bColumnDisplay && ((stCFG.lReadColBackgrndColor == stCFG.lStatusBackgrndColor) ||
                                   (stCFG.lWriteColBackgrndColor == stCFG.lStatusBackgrndColor))) ||
                                   (stCFG.lStatusBackgrndColor == stCFG.lWriteBackgrndColor))
        {
        rcl.yBottom = (rcl.yTop - 1);
        if (stCFG.lStatusBackgrndColor != CLR_WHITE)
          WinFillRect(hps,&rcl,(stCFG.lStatusBackgrndColor ^ stCFG.lStatusBackgrndColor));
        else
          WinFillRect(hps,&rcl,CLR_BLACK);
        }
      WinEndPaint( hps );
      break;
    case UM_STARTTIMER:
      if (idTimer == 0)
        {
        lMessageDelay = 0;
        idTimer = WinStartTimer(habAnchorBlock,
                                hwnd,
                                TID_STATUSBAR,
                                stCFG.wUpdateDelay);
        if (GetCountsSinceLast(&stIOctl,hCom,&stCounts) == NO_ERROR)
          {
          if (stCFG.bSampleCounts)
            {
            if (stCFG.wUpdateDelay <= 1000)
              {
              iCPSdivisor = (1000 / stCFG.wUpdateDelay);
              iCPSmultiplier = 0;
              }
            else
              {
              iCPSmultiplier = (stCFG.wUpdateDelay / 1000);
              iCPSdivisor = 0;
              }
            }
          bDiagCountsCapable = TRUE;
          iWindow = 0;
          memset(aulRxByteCount,0,(MAX_CPS_SAMPLES + 1));
          memset(aulTxByteCount,0,(MAX_CPS_SAMPLES + 1));
//          for (iIndex = 0;iIndex < stCFG.iSampleCount;iIndex++)
//            {
//            aulTxByteCount[iIndex] = stCounts.ulBytesTransmitted;
//            aulRxByteCount[iIndex] = stCounts.ulBytesReceived;
//           }
//          ulTxByteCount = (stCounts.ulBytesTransmitted * stCFG.iSampleCount);
//          ulRxByteCount = (stCounts.ulBytesReceived * stCFG.iSampleCount);
          ulTxByteCount = 0;
          ulRxByteCount = 0;
          }
        }
      break;
    case WM_DESTROY:
    case UM_STOPTIMER:
      if (idTimer != 0)
        {
        WinStopTimer(habAnchorBlock,
                     hwnd,
                     idTimer);
        idTimer = 0L;
        }
      WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
      break;
    case UM_RESET_SAMPLES:
      if (bDiagCountsCapable && stCFG.bSampleCounts)
        {
        GetCountsSinceLast(&stIOctl,hCom,&stCounts);
        iWindow = 0;
        for (iIndex = 0;iIndex < stCFG.iSampleCount;iIndex++)
          {
          aulTxByteCount[iIndex] = stCounts.ulBytesTransmitted;
          aulRxByteCount[iIndex] = stCounts.ulBytesReceived;
          }
        ulTxByteCount = (stCounts.ulBytesTransmitted * stCFG.iSampleCount);
        ulRxByteCount = (stCounts.ulBytesReceived * stCFG.iSampleCount);
        }
    case UM_RESETTIMER:
      if (idTimer != 0L)
        {
        idTimer = WinStartTimer(habAnchorBlock,
                              hwnd,
                              idTimer,
                              stCFG.wUpdateDelay);
        if (bDiagCountsCapable && stCFG.bSampleCounts)
          {
          if (stCFG.wUpdateDelay <= 1000)
            {
            iCPSdivisor = (1000 / stCFG.wUpdateDelay);
            iCPSmultiplier = 0;
            }
          else
            {
            iCPSmultiplier = (stCFG.wUpdateDelay / 1000);
            iCPSdivisor = 0;
            }
          }
        }
      break;
    case WM_TIMER:
      if (lMessageDelay != 0)
        {
        if (--lMessageDelay == 0)
          WinInvalidateRect(hwnd,(PRECTL)NULL,FALSE);
        }
      else
        {
        if (bDiagCountsCapable && stCFG.iSampleCount)
          GetCountsSinceLast(&stIOctl,hCom,&stCounts);
        WinQueryWindowRect(hwndClient,&rcl);
        rcl.yTop = lStatusHeight;
        rcl.yBottom = 0;
        rcl.xLeft = 0;
        ptl.y = ((lStatusHeight / 2) - 5);
        ptl.x = 6L;

        hps = WinGetPS(hwnd);
        WinFillRect(hps,&rcl,stCFG.lStatusBackgrndColor);
        GpiSetBackColor(hps,stCFG.lStatusBackgrndColor);
        GpiSetColor(hps,stCFG.lStatusForegrndColor);
        GpiSetBackMix(hps,BM_OVERPAINT);
        if (bDiagCountsCapable && stCFG.bSampleCounts)
          {
          if (stCFG.iSampleCount > 1)
            {
            if ((ulTxByteCount -= aulTxByteCount[iWindow]) < 0)
              ulTxByteCount = 0;
            if (iCPSmultiplier != 0)
              aulTxByteCount[iWindow] = (stCounts.ulBytesTransmitted / iCPSmultiplier);
            else
              aulTxByteCount[iWindow] = (stCounts.ulBytesTransmitted * iCPSdivisor);
            ulTxByteCount += aulTxByteCount[iWindow];
            ulByteCount = (ulTxByteCount / stCFG.iSampleCount);
            }
          else
            ulByteCount = stCounts.ulBytesTransmitted;
          if (stCFG.bShowCounts)
            iLen = sprintf(szLastCounts,"Tx(%u, %u)",stCharCount.lWrite,ulByteCount);
          else
            iLen = sprintf(szLastCounts,"Tx(%u CPS)",ulByteCount);
          GpiCharStringAt(hps,&ptl,iLen,szLastCounts);
          }
        else
          if (stCFG.bShowCounts)
            {
            iLen = sprintf(szLastCounts,"Tx(%u)",stCharCount.lWrite);
            GpiCharStringAt(hps,&ptl,iLen,szLastCounts);
            }
        if (stCFG.bColumnDisplay)
          ptl.x += stRead.rcl.xLeft;
        else
          ptl.x += 240;
        if (bDiagCountsCapable && stCFG.bSampleCounts)
          {
          if (stCFG.iSampleCount > 1)
            {
            if ((ulRxByteCount -= aulRxByteCount[iWindow]) < 0)
              ulRxByteCount = 0;
            if (iCPSmultiplier != 0)
              aulRxByteCount[iWindow] = (stCounts.ulBytesReceived / iCPSmultiplier);
            else
              aulRxByteCount[iWindow] = (stCounts.ulBytesReceived * iCPSdivisor);
            ulRxByteCount += aulRxByteCount[iWindow];
            ulByteCount = (ulRxByteCount / stCFG.iSampleCount);
            if (++iWindow >= stCFG.iSampleCount)
              iWindow = 0;
            }
          else
            ulByteCount = stCounts.ulBytesReceived;
          if (stCFG.bShowCounts)
            sprintf(szCounts,"Rx(%u, %u)",stCharCount.lRead,ulByteCount);
          else
            sprintf(szCounts,"Rx(%u CPS)",ulByteCount);
          sprintf(&szLastCounts[iLen]," %s",szCounts);
          GpiCharStringAt(hps,&ptl,strlen(szCounts),szCounts);
          }
        else
          {
          if (stCFG.bShowCounts)
            {
            sprintf(szCounts,"Rx(%u)",stCharCount.lRead);
            sprintf(&szLastCounts[iLen]," %s",szCounts);
            GpiCharStringAt(hps,&ptl,strlen(szCounts),szCounts);
            }
          }
        if ((stCFG.bColumnDisplay && ((stCFG.lReadColBackgrndColor == stCFG.lStatusBackgrndColor) ||
                                     (stCFG.lWriteColBackgrndColor == stCFG.lStatusBackgrndColor))) ||
            (stCFG.lStatusBackgrndColor == stCFG.lWriteBackgrndColor))
          {
          rcl.yBottom = (rcl.yTop - 1);
          if (stCFG.lStatusBackgrndColor != CLR_WHITE)
            WinFillRect(hps,&rcl,(stCFG.lStatusBackgrndColor ^ stCFG.lStatusBackgrndColor));
          else
            WinFillRect(hps,&rcl,CLR_BLACK);
          }
        WinReleasePS(hps);
        }
      break;
    default:
      return(WinDefWindowProc(hwnd, msg, mp1, mp2));
    }
  return(FALSE);
  }

ParseParms(int argc, char * argv[])
  {
  long lIndex;
  
  for (lIndex = 1;lIndex < argc;lIndex++)
    {
    if ((argv[lIndex][0] == '/') || (argv[lIndex][0] == '-'))
      {
      switch (argv[lIndex][1] & 0xdf)
        {
        case 'V':
          if (strlen(&argv[lIndex][2]) != 0)
            strcpy(szPipeServerName,&argv[lIndex][2]);
          bLaunchShutdownServer = TRUE;
          break;
        case 'T':
          if (strlen(&argv[lIndex][2]) != 0)
            strcpy(szIPCpipeName,&argv[lIndex][2]);
          bLaunchShutdownServer = TRUE;
          break;
        case 'L':
          bLaunchShutdownServer = TRUE;
          if (argv[lIndex][2] != 0)
            {
            chPipeDebug = argv[lIndex][2];
            bShowServerProcess = TRUE;
            }
          else
            chPipeDebug = '0';
          break;
        case 'P':
          if (argv[lIndex][2] == '-')
            bUseProfile = FALSE;
          else
            {
            if (argv[lIndex][2] != 0)
              strcpy(szCOMscopeAppName,&argv[lIndex][2]);
            }
          break;
        case 'S':
          if (argv[lIndex][2] == '-')
            bUseProfile = FALSE;
          else
            {
            bSearchProfileApps = TRUE;
            if (argv[lIndex][2] != 0)
              strcpy(szCOMscopeAppName,&argv[lIndex][2]);
            }
          break;
        case 'F':
          strcpy(szFontFileName,&argv[lIndex][2]);
          bNewFontFile = TRUE;
          break;
        case 'D':
          strcpy(szDataFileSpec,&argv[lIndex][2]);
          break;
        case 'Y':
          iDebugLevel = atoi(&argv[lIndex][2]);
          break;
        case 'X':
          if ((argv[lIndex][2] & 0xdf) == 'C')
            bRemoteClient = TRUE;
          else
            bRemoteServer = TRUE;
          bRemoteAccess = TRUE;
          break;
        }
      }
    else
      {
      strcpy(szCmdLineIniFileSpec,argv[lIndex]);
      bEditCmdLineIniFile = TRUE;
      }
    }
  }

