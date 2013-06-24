#include "COMMON.H"
#include "UTILITY.H"
#include "CONFIG.H"
#include "help.h"

#include "install.h"
#include "instpage.h"
#include "resource.h"

COMICFG stCOMiCFG;

INSTALL stInst;

PAGECFG stPageCFG;

void main(int argc,char *argv[]);


void ConfigQuickPage(HWND hwnd);
void ConfigCOMi(HWND hwnd);
VOID InstallCommand(HWND hwnd,USHORT Command);
extern MRESULT EXPENTRY fnwpUninstallDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
void InsertAppMenu(void);
extern MRESULT EXPENTRY fnwpInfoDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpTransferDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpAboutBoxDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern void SetInitialPosition(HWND hwndFrame);

BOOL CreatePS(HWND hwnd);

MRESULT EXPENTRY fnwpClient(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
VOID Help(HWND hwnd);
VOID ClientPaint(HWND hwnd);
void APIENTRY InstallThread(void);

FILESTATUS stFileStatus;

char szPagerFileName[40];
char szHelpFileName[] = "INSTALL.HLP";
char szHelpName[21];

extern HWND hwndInstallHelpInstance;
extern char szHelpWindowTitle[];

char szDebugLineOne[100];
char szDebugLineTwo[100];

char szCOMiVersion[80];
char szCOMscopeVersion[80];
char szAppVersion[80];
char szInstallVersion[80];

HDC hdcPs;
HPS hpsPs;
CELL stBigCell;
CELL stMsgCell;
FATTRS fattBigFont;
FATTRS fattMsgFont;

char szDriverVersionString[100];

char szHiddenFile[] = "z6566978.356";

CHAR szEXEtitle[61];// = "COMi Device Driver Install";

ULONG ulPagerSize;
ULONG ulLibsSize;
ULONG ulPDRsize;
ULONG ulCOMiSize;
ULONG ulUtilSize;
ULONG ulCOMscopeSize;
ULONG ulInstallSize;

#define UM_INITMENUS        30000
#define UM_CONFIG_COMPLETE  30001
#define UM_EXEC_MSG         30002
#define UM_FALSE_START      30003

BOOL bCOMscopeToInstall = TRUE;
BOOL bCOMiToInstall = TRUE;
BOOL bInstallToInstall = TRUE;
BOOL bUtilToInstall = TRUE;
BOOL bPagerToInstall = TRUE;
BOOL bPDRtoInstall = TRUE;
BOOL bLibrariesToInstall = TRUE;
BOOL bObjectsToCreate = TRUE;
BOOL bShowingProgress = FALSE;
BOOL bFalseStart = FALSE;

BOOL bUninstall = FALSE;

LONG lXScr;
LONG lcxVSc;
LONG lcxBrdr;
HWND hwndClient;

ULONG ulBootDrive;

BOOL bItemOneLocked = TRUE;
BOOL bItemTwoLocked = FALSE;
BOOL bItemThreeLocked = FALSE;
BOOL bItemFourLocked = FALSE;
BOOL bItemFiveLocked = FALSE;

char szTransferLibraryName[60];
char *pszTransferLibrarySpec;
char szConfigAppLibraryName[60];
char szConfigDDlibraryName[60];
char szConfigDDhelpFileName[60];
char szConfigAppHelpFileName[60];
char szTransferFunctionName[60];
char szConfigAppFunctionName[60];
char szConfigDDfunctionName[60];
char szAppIconFile[40];
char *pszHelpFileSpec;
char *pszPath;
char *pszCurrentAppsPath;
char *pszDriverIniPath;
char *pszSourceFile;
char *pszUninstallIniPath;
char szConfigDDname[20];
char szConfigAppName[20];
char szLicenseFileName[21];
char szLicenseCaption[100] = "License Agreement";
char szInfoFileName[21];
char szInfoCaption[100] = "Attention Please!";
char szDefaultAppsPath[61];
char szDefaultDLLpath[61];
char szUninstallIniFileName[] = "INST LST.INI";
char szIniFileName[] = "OS_TOOLS.INI";

BOOL bCOMiInstalled = FALSE;
char szBannerOne[MAX_BANNER + 1];
char szBannerTwo[MAX_BANNER + 1];
ULONG ulOEMtype;
ULONG bConfigurationOnly = FALSE;
char szDDname[40];

char szFalseStart1[400];
char szFalseStart2[400];
char szCheckOneCaption[60];
char szCheckTwoCaption[60];
char szCheckThreeCaption[60];
char szCheckFourCaption[60];
char szCheckFiveCaption[60];
HINI hSourceProfile;
HINI hConfigProfile;
HINI hInstalledProfile;
BOOL bInstallDemo = FALSE;
char szDemoPath[80];
char szFileNumber[10];
BOOL bDebug = FALSE;
BOOL bPreviousInstallation = FALSE;

void main(int argc,char *argv[])
  {
  HMQ hmqQueue;
  QMSG qmsgMessage;
  ULONG flCreate;
  LONG lIndex;
  char szString[80];
  int iIndex;
  HFILE hCom;
  APIRET rc;
  ULONG ulAction;
  ULONG cbDataSize = sizeof(ULONG);

  if (argc >= 2)
    {
    for (lIndex = 1;lIndex < argc;lIndex++)
      {
      if ((argv[lIndex][0] == '/') || (argv[lIndex][0] == '-'))
        {
        switch (argv[lIndex][1] & 0xdf)
          {
          case 'X':
            bDebug = TRUE;
            break;
          default:
            strcpy(szDemoPath,&argv[lIndex][1]);
            bInstallDemo = TRUE;
            break;
          }
        }
      }
    }

  stInst.hab = WinInitialize((USHORT)NULL);

  hmqQueue   = WinCreateMsgQueue(stInst.hab,0);

  WinRegisterClass(stInst.hab,
                  "INSTALL",
            (PFNWP)fnwpClient,
                   0L,
                   4);

  DosQuerySysInfo(QSV_MAX_PATH_LENGTH,QSV_MAX_PATH_LENGTH,&stInst.ulMaxPathLen,sizeof(ULONG));

  MemAlloc(&pszPath,((stInst.ulMaxPathLen * 3) + 20));
  MemAlloc(&stInst.paszStrings[CONFIGDDLIBRARYSPEC],(stInst.ulMaxPathLen + 1));
  MemAlloc(&stInst.pszSourceIniPath,(stInst.ulMaxPathLen + 1));
  MemAlloc(&stInst.paszStrings[CURRENTDRIVERSPEC],(stInst.ulMaxPathLen + 1));
  MemAlloc(&stInst.paszStrings[DRIVERINISPEC],(stInst.ulMaxPathLen + 1));
  MemAlloc(&stInst.paszStrings[XFERLIBRARYSPEC],(stInst.ulMaxPathLen + 1));
  MemAlloc(&stInst.pszDLLpath,(stInst.ulMaxPathLen + 1));
  MemAlloc(&stInst.pszAppsPath,(stInst.ulMaxPathLen + 1));
  MemAlloc(&pszUninstallIniPath,(stInst.ulMaxPathLen + 1));
  MemAlloc(&pszCurrentAppsPath,(stInst.ulMaxPathLen + 1));
  MemAlloc(&stInst.pszSourcePath,(stInst.ulMaxPathLen + 1));
  MemAlloc(&pszHelpFileSpec,(stInst.ulMaxPathLen + 1));
  MemAlloc(&stCOMiCFG.pszDriverIniSpec,(stInst.ulMaxPathLen + 1));
  MemAlloc(&stInst.paszStrings[CONFIGAPPLIBRARYSPEC],(stInst.ulMaxPathLen + 1));

  DosQuerySysInfo(QSV_BOOT_DRIVE,QSV_BOOT_DRIVE,&ulBootDrive,sizeof(ULONG));
  stInst.chBootDrive = ('A' + (char)ulBootDrive - 1);

  if (bDebug)
    PrintDebug("Debug Messaging","is enabled");

  if ((rc = DosOpen(SPECIAL_DEVICE,&hCom,&ulAction,0L,0L,0x0001,0x21c2,0L)) == 0)
    {
    if ((GetDriverPath(hCom,pszPath)) && (pszPath[1] == ':'))
      {
      for (iIndex = 0;iIndex < stInst.ulMaxPathLen;iIndex++)
        {
        if (pszPath[iIndex] == ' ')
          break;
        pszPath[iIndex] = toupper(pszPath[iIndex]);
        }

      strcpy(szDriverVersionString,&pszPath[iIndex + 1]);
      szDriverVersionString[strlen(szDriverVersionString) - 3] = 0;
      pszPath[iIndex] = 0;
      strcpy(stInst.paszStrings[CURRENTDRIVERSPEC],pszPath);
      MemAlloc(&stInst.paszStrings[REMOVEOLDDRIVERSPEC],(stInst.ulMaxPathLen + 1));
      strcpy(stInst.paszStrings[REMOVEOLDDRIVERSPEC],pszPath);
      strcpy(stInst.paszStrings[DRIVERINISPEC],pszPath);
      AppendINI(stInst.paszStrings[DRIVERINISPEC]);
      SetEndOfPath(pszPath);
      strcpy(stInst.pszDLLpath,pszPath);
      strcpy(stInst.pszAppsPath,pszPath);
      sprintf(pszUninstallIniPath,"%s\\%s",pszPath,szUninstallIniFileName);
      bCOMiInstalled = TRUE;
      bItemOneLocked = FALSE;
      }
    DosClose(hCom);
    }

  strcpy(stInst.pszSourcePath,argv[0]);
  SetEndOfPath(stInst.pszSourcePath);
  sprintf(pszHelpFileSpec,"%s\\%s",stInst.pszSourcePath,szHelpFileName);

  if (bInstallDemo)
    {
    if (szDemoPath[strlen(szDemoPath) - 1] =='\\')
      szDemoPath[iIndex - 1] = 0;
    strncpy(pszPath,stInst.pszSourcePath,3);
    iIndex = 3;
    if (pszPath[2] != '\\')
      {
      iIndex = 2;
      pszPath[2] = '\\';
      }
    sprintf(&pszPath[3],"%s\\%s",szDemoPath,&stInst.pszSourcePath[iIndex]);
    strcpy(stInst.pszSourcePath,pszPath);
    }

  sprintf(stInst.pszSourceIniPath,"%s\\%s",stInst.pszSourcePath,szIniFileName);
  if (bDebug)
    PrintDebug("Source Ini File",stInst.pszSourceIniPath);

  stInst.bCopyCOMscope = TRUE;
  stInst.bCopyPager = TRUE;
  stInst.bCopyCOMi = TRUE;
  stInst.bCreateObjects = TRUE;
#ifdef this_junk
  stInst.bCopyInstall = TRUE;
  stInst.bCopyUtil = TRUE;
  stInst.bCopyPDR = TRUE;
  stInst.bCopyLibraries = TRUE;
#endif
  hSourceProfile = PrfOpenProfile(stInst.hab,stInst.pszSourceIniPath);

  if (hSourceProfile != 0)
    {
    PrfQueryProfileString(hSourceProfile,"Install","False Start 1",0,szFalseStart1,400);
    PrfQueryProfileString(hSourceProfile,"Install","False Start 2",0,szFalseStart2,400);
    if (!PrfQueryProfileData(hSourceProfile,"Install","bConfigurationOnly",&bConfigurationOnly,&cbDataSize))
      bConfigurationOnly = FALSE;
    PrfQueryProfileString(hSourceProfile,"COMi","Driver","COMDD.SYS",szDDname,18);
    PrfQueryProfileString(hSourceProfile,"COMi","Version",0,szCOMiVersion,60);
    PrfQueryProfileString(hSourceProfile,"COMscope","Version",0,szCOMscopeVersion,60);
    PrfQueryProfileString(hSourceProfile,"Pager","Pager File","PAGERDEF.PAG",szPagerFileName,20);
    PrfQueryProfileString(hSourceProfile,"Pager","Version",0,szAppVersion,60);
    PrfQueryProfileString(hSourceProfile,"Pager","Icon File",0,szAppIconFile,60);
    PrfQueryProfileString(hSourceProfile,"Install","Banner One","for the",szBannerOne,MAX_BANNER);
    PrfQueryProfileString(hSourceProfile,"Install","Banner Two","COMi Device Driver",szBannerTwo,MAX_BANNER);
    PrfQueryProfileString(hSourceProfile,"Install","Title","COMi Device Driver Install",szEXEtitle,60);
    PrfQueryProfileString(hSourceProfile,"Install","DD Name","COMi",szConfigDDname,20);
    PrfQueryProfileString(hSourceProfile,"Install","App Name",0,szConfigAppName,20);
    PrfQueryProfileString(hSourceProfile,"Install","Apps Path","C:\\COMM",szDefaultAppsPath,60);
    PrfQueryProfileString(hSourceProfile,"Install","Libs Path","C:\\COMM",szDefaultDLLpath,60);
    PrfQueryProfileString(hSourceProfile,"Install","Version",0,szInstallVersion,60);
    PrfQueryProfileString(hSourceProfile,"Install","Info File",0,szInfoFileName,20);
    PrfQueryProfileString(hSourceProfile,"Install","Info Caption",0,szInfoCaption,60);
    PrfQueryProfileString(hSourceProfile,"Install","License File",0,szLicenseFileName,20);
    PrfQueryProfileString(hSourceProfile,"Install","License Caption",0,szLicenseCaption,60);
    PrfQueryProfileString(hSourceProfile,"Install","Check Caption One",0,szCheckOneCaption,60);
    PrfQueryProfileString(hSourceProfile,"Install","Check Caption Two",0,szCheckTwoCaption,60);
    PrfQueryProfileString(hSourceProfile,"Install","Check Caption Three",0,szCheckThreeCaption,60);
    PrfQueryProfileString(hSourceProfile,"Install","Check Caption Four",0,szCheckFourCaption,60);
    PrfQueryProfileString(hSourceProfile,"Install","Check Caption Five",0,szCheckFiveCaption,60);
    PrfQueryProfileString(hSourceProfile,"Install","DD Config Help","COMscope.HLP",szConfigDDhelpFileName,60);
    PrfQueryProfileString(hSourceProfile,"Install","App Config Help",0,szConfigAppHelpFileName,60);
    PrfQueryProfileString(hSourceProfile,"Install","DD Config Library",COMi_CONFIG_LIB,szConfigDDlibraryName,60);
    PrfQueryProfileString(hSourceProfile,"Install","DD Config Function","InstallDevice",szConfigDDfunctionName,60);
    PrfQueryProfileString(hSourceProfile,"Install","Transfer Library",COMi_INSTALL_LIB,szTransferLibraryName,60);
    sprintf(stInst.paszStrings[XFERLIBRARYSPEC],"%s\\%s.DLL",stInst.pszSourcePath,szTransferLibraryName);

    PrfQueryProfileString(hSourceProfile,"Install","Transfer Function","TransferFiles",szTransferFunctionName,60);
    PrfQueryProfileString(hSourceProfile,"Install","App Config Library",0,szConfigAppLibraryName,60);
    PrfQueryProfileString(hSourceProfile,"Install","App Config Function",0,szConfigAppFunctionName,60);
    if (!PrfQueryProfileData(hSourceProfile,"COMi","OEM_type",&ulOEMtype,&cbDataSize))
      ulOEMtype = 0;
    if (!PrfQueryProfileData(hSourceProfile,"COMi","Max Device Count",&stCOMiCFG.ulMaxDeviceCount,&cbDataSize))
      stCOMiCFG.ulMaxDeviceCount = 0;
    if (!PrfQueryProfileData(hSourceProfile,"COMscope","ProgramSize",&ulCOMscopeSize,&cbDataSize))
      {
      stInst.bCopyCOMscope = FALSE;
      bCOMscopeToInstall = FALSE;
      }
    if (!PrfQueryProfileData(hSourceProfile,"Pager","ProgramSize",&ulPagerSize,&cbDataSize))
      {
      stInst.bCopyPager = FALSE;
      bPagerToInstall = FALSE;
      }
    if (!PrfQueryProfileData(hSourceProfile,"COMi","ProgramSize",&ulCOMiSize,&cbDataSize))
      {
      stInst.bCopyCOMi = FALSE;
      bCOMiToInstall = FALSE;
      }
    if (!PrfQueryProfileData(hSourceProfile,"Install","ProgramSize",&ulInstallSize,&cbDataSize))
      {
      stInst.bCopyInstall = FALSE;
      bInstallToInstall = FALSE;
      }
    if (!PrfQueryProfileData(hSourceProfile,"Utilities","ProgramSize",&ulUtilSize,&cbDataSize))
      {
      stInst.bCopyUtil = FALSE;
      bUtilToInstall = FALSE;
      }
    if (!PrfQueryProfileData(hSourceProfile,"PDR","ProgramSize",&ulPDRsize,&cbDataSize))
      {
      stInst.bCopyPDR = FALSE;
      bPDRtoInstall = FALSE;
      }
    if (!PrfQueryProfileData(hSourceProfile,"Libraries","ProgramSize",&ulLibsSize,&cbDataSize))
      {
      stInst.bCopyLibraries = FALSE;
      bLibrariesToInstall = FALSE;
      }
    if (!stInst.bCopyCOMscope)
      stInst.bCopyInstall = TRUE;
    }
  else
    exit(55);

  if (!bCOMiInstalled)
    {
    if (strlen(szFalseStart1) != 0)
      bFalseStart = TRUE;
    else
      {
      if (PrfQueryProfileString(HINI_USERPROFILE,szConfigDDname,"Initialization",0L,
                                                         pszPath,
                                                         stInst.ulMaxPathLen) != 0)
        {
        strcpy(stInst.pszAppsPath,pszPath);
        SetEndOfPath(stInst.pszAppsPath);
        sprintf(pszUninstallIniPath,"%s\\%s",stInst.pszAppsPath,szUninstallIniFileName);
        bPreviousInstallation = TRUE;
        }
      else
        {
        strcpy(stInst.pszAppsPath,szDefaultAppsPath);
        stInst.pszAppsPath[0] = stInst.chBootDrive;
        sprintf(pszUninstallIniPath,"%s\\%s",stInst.pszAppsPath,szUninstallIniFileName);
        strcpy(stInst.pszDLLpath,szDefaultDLLpath);
        stInst.pszDLLpath[0] = stInst.chBootDrive;
        sprintf(pszPath,"%s\\%s",stInst.pszAppsPath,szDDname);
        }
  //    strcpy(stInst.paszStrings[CURRENTDRIVERSPEC],pszPath);
      strcpy(stInst.paszStrings[DRIVERINISPEC],pszPath);
      AppendINI(stInst.paszStrings[DRIVERINISPEC]);
      }
    }

  strcpy(stCOMiCFG.pszDriverIniSpec,stInst.paszStrings[DRIVERINISPEC]);

  if (strlen(pszUninstallIniPath) != 0)
    {
    if (DosQueryPathInfo(pszUninstallIniPath,1,&stFileStatus,sizeof(FILESTATUS3)) == NO_ERROR)
      {
      if ((hInstalledProfile = PrfOpenProfile(stInst.hab,pszUninstallIniPath)) != 0)
        {
        if (PrfQueryProfileString(hInstalledProfile,"Installed","Program Path",0,pszPath,stInst.ulMaxPathLen))
          {
          strcpy(pszCurrentAppsPath,pszPath);
          bUninstall = TRUE;
          }
        if (PrfQueryProfileString(hInstalledProfile,"Installed","Library Path",0,pszPath,stInst.ulMaxPathLen))
          strcpy(stInst.pszDLLpath,pszPath);
        else
          strcpy(stInst.pszDLLpath,stInst.pszAppsPath);
        PrfCloseProfile(hInstalledProfile);
        }
      }
    }

  stInst.cbSize = sizeof(INSTALL);
  sprintf(stInst.paszStrings[CONFIGDDLIBRARYSPEC],"%s\\%s.DLL",stInst.pszSourcePath,szConfigDDlibraryName);
  stCOMiCFG.byOEMtype = (BYTE)ulOEMtype;

  flCreate = (FCF_BORDER | FCF_ACCELTABLE | FCF_TASKLIST | FCF_MENU | FCF_TITLEBAR | FCF_SYSMENU);

  stInst.hwndFrame = WinCreateStdWindow(HWND_DESKTOP,
                                 0L,
                                &flCreate,
                                "INSTALL",
                                 NULL,
                                 WS_CLIPCHILDREN,
                        (HMODULE)NULL,
                                 WIN_INSTALL,
                                &hwndClient);

  WinSetWindowText(stInst.hwndFrame,szEXEtitle);
  SetInitialPosition(stInst.hwndFrame);
  WinShowWindow(stInst.hwndFrame,TRUE);
  WinSetFocus(HWND_DESKTOP,hwndClient);

  if (strlen(szConfigAppName) == 0)
    {
    WinSendMsg(WinWindowFromID(stInst.hwndFrame,FID_MENU),MM_REMOVEITEM,MPFROM2SHORT(IDM_CONFIG_APP,TRUE),(MPARAM)0);
#ifdef this_junk
    bItemThreeLocked = TRUE;
    InsertAppMenu();
    MenuItemEnable(stInst.hwndFrame,IDM_CONFIG_APP,FALSE);
#endif
    }

  if ((hwndInstallHelpInstance = HelpInit(pszHelpFileSpec,szHelpWindowTitle)) == 0)
    {
    MenuItemEnable(stInst.hwndFrame,IDM_HELPINDEX,FALSE);
    MenuItemEnable(stInst.hwndFrame,IDM_HELPEXTEND,FALSE);
    MenuItemEnable(stInst.hwndFrame,IDM_HELPKEYS,FALSE);
    MenuItemEnable(stInst.hwndFrame,IDM_HELPFORHELP,FALSE);
    }

  while(WinGetMsg(stInst.hab,&qmsgMessage,(HWND)NULL,0,0))
    WinDispatchMsg(stInst.hab,&qmsgMessage);

  DestroyHelpInstance(hwndInstallHelpInstance);

  if (hConfigProfile != 0)
    PrfCloseProfile(hConfigProfile);
  if (hSourceProfile != 0)
    PrfCloseProfile(hSourceProfile);

  MemFree(pszPath);
  MemFree(stInst.paszStrings[XFERLIBRARYSPEC]);
  MemFree(stInst.paszStrings[CONFIGDDLIBRARYSPEC]);
  MemFree(stCOMiCFG.pszRemoveOldDriverSpec);
  MemFree(stInst.pszSourceIniPath);
  if (stInst.paszStrings[REMOVEOLDDRIVERSPEC] != NULL)
    MemFree(stInst.paszStrings[REMOVEOLDDRIVERSPEC]);
  MemFree(stInst.paszStrings[CURRENTDRIVERSPEC]);
  MemFree(stInst.paszStrings[DRIVERINISPEC]);
  MemFree(stInst.pszDLLpath);
  MemFree(stInst.pszAppsPath);
  MemFree(pszUninstallIniPath);
  MemFree(pszCurrentAppsPath);
  MemFree(stInst.pszSourcePath);
  MemFree(pszHelpFileSpec);
  MemFree(stCOMiCFG.pszDriverIniSpec);

  WinDestroyWindow(stInst.hwndFrame);
  WinDestroyMsgQueue(hmqQueue);
  WinTerminate(stInst.hab);
  exit(0);
  }

MRESULT  EXPENTRY fnwpClient(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  POINTL  ptl;
  HPS     hps;
  RECTL   rcl;
  ORIG    Origin;
  BYTE    bVkey;
  BYTE    chKey;
  PSWP    pswp;
  USHORT  usCxMaxWnd;
  static  ORIG OrigRestor;
  USHORT   Command;
  CHAR szMessage[100];
  CHAR szCaption[81];
  ULONG cbDataSize;

  switch(msg)
    {
    case WM_CREATE:
      CreatePS(hwnd);
      if (bFalseStart)
        WinPostMsg(hwndClient,UM_FALSE_START,0,0);
      else
        WinPostMsg(hwndClient,UM_INITMENUS,0,0);
      break;
    case UM_FALSE_START:
      if (bConfigurationOnly > 1)
        MessageBox(HWND_DESKTOP,szFalseStart2);
      else
        MessageBox(HWND_DESKTOP,szFalseStart1);
    case WM_CLOSE:
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
      break;
    case UM_INITMENUS:
      sprintf(pszPath,"~%s...",szConfigDDname);
      WinSendMsg(WinWindowFromID(stInst.hwndFrame,FID_MENU),MM_SETITEMTEXT,(MPARAM)IDM_CONFIG_DD,pszPath);
      if (strlen(szConfigAppName) != 0)
        {
        sprintf(pszPath,"~%s...",szConfigAppName);
        WinSendMsg(WinWindowFromID(stInst.hwndFrame,FID_MENU),MM_SETITEMTEXT,(MPARAM)IDM_CONFIG_APP,pszPath);
        PrfQueryProfileString(HINI_USERPROFILE,szConfigAppName,"Configuration",0L,
                                                       stInst.paszStrings[CONFIGAPPLIBRARYSPEC],
                                                       stInst.ulMaxPathLen);
        if (strlen(stInst.paszStrings[CONFIGAPPLIBRARYSPEC]) == 0)
          MenuItemEnable(stInst.hwndFrame,IDM_CONFIG_APP,FALSE);
        cbDataSize = sizeof(HOBJECT);
        if (!PrfQueryProfileData(hSourceProfile,szConfigAppName,"WPSobject",&stPageCFG.hObject,&cbDataSize))
          stPageCFG.hObject = 0;
        }
      if (bConfigurationOnly)
        MenuItemEnable(stInst.hwndFrame,IDM_SELECT,FALSE);
      if (!bUninstall)
        MenuItemEnable(stInst.hwndFrame,IDM_UNINSTALL,FALSE);
      if (!bPreviousInstallation)
        if (!bCOMiInstalled)
          MenuItemEnable(stInst.hwndFrame,IDM_SETUP,FALSE);
//      MenuItemEnable(stInst.hwndFrame,IDM_TRANSFER,FALSE);
      break;
    case WM_DESTROY:
      GpiDestroyPS(hpsPs);
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
    case WM_ACTIVATE:
      if(SHORT1FROMMP(mp1))
        {
        WinSetFocus(HWND_DESKTOP,stInst.hwndFrame);
        WinSendMsg(WinQueryHelpInstance(hwndClient),HM_SET_ACTIVE_WINDOW,0L,0L);
        }
      break;
    case WM_PAINT:
      ClientPaint(hwnd);
      break;
    case WM_COMMAND:
        InstallCommand(hwnd,SHORT1FROMMP(mp1));
      break;
    default:
      return WinDefWindowProc(hwnd,msg,mp1,mp2);
    }
  return(FALSE);
  }

void InstallCommand(HWND hwnd,USHORT Command)
  {
  USHORT wStatus;
  BYTE byStatus;
  char szCaption[40];
  char szMessage[100];
  char szObjName[100];
  APIRET rc;
  FILESTATUS3 stFileAttrs;
  ULONG ulStatus;
  HFILE hFile;
  int iLen;
  BOOL bSuccess;
  HMODULE hMod;
  PFN pfnProcess;
  BOOL bDoTransfer;
  INFODLG stInfoDlg;

  switch (Command)
    {
    case IDM_USINGHELP:
      HelpHelpForHelp();
      return;
    case IDM_GENERALHELP:
      DisplayHelpPanel(HLPP_GENERAL);
      return;
    case IDM_HELPINDEX:
      HelpIndex();
      return;
    case IDM_KEYSHELP:
      DisplayHelpPanel(HLPP_KEYS);
      return;
    case IDM_EXIT:
      WinPostMsg(hwnd,WM_QUIT,0L,0L);
      return;
    case IDM_TRANSFER:
      bShowingProgress = TRUE;
      if (WinDlgBox(HWND_DESKTOP,
                    hwnd,
             (PFNWP)fnwpTransferDlg,
              (LONG)NULL,
                    TRAN_DLG,
              (LONG)NULL))
        {
        if (strlen(szLicenseFileName) != 0)
          {
          stInfoDlg.cbSize = sizeof(INFODLG);
          stInfoDlg.pszFileName = szLicenseFileName;
          stInfoDlg.pszCaption = szLicenseCaption;
          if (WinDlgBox(HWND_DESKTOP,
                        hwnd,
                 (PFNWP)fnwpInfoDlgProc,
                  (LONG)NULL,
                        INST_MSG,
                (PVOID)&stInfoDlg))
            {
            if ((rc = DosLoadModule(0,0,stInst.paszStrings[XFERLIBRARYSPEC],&hMod)) == NO_ERROR)
              {
              if (DosQueryProcAddr(hMod,0,szTransferFunctionName,(PFN *)&pfnProcess) == NO_ERROR)
                {
                stInst.paszStrings[COMIVERSION] = szCOMiVersion;
                stInst.paszStrings[CONFIGDDLIBRARYNAME] = szConfigDDlibraryName;
                stInst.paszStrings[CONFIGDDHELPFILENAME] = szConfigDDhelpFileName;
                stInst.paszStrings[CONFIGAPPLIBRARYNAME] = szConfigAppLibraryName;
                stInst.paszStrings[CONFIGAPPHELPFILENAME] = szConfigAppHelpFileName;
                stInst.paszStrings[INIFILENAME] = szIniFileName;
                stInst.paszStrings[UNINSTALLINIFILENAME] = szUninstallIniFileName;
                stInst.paszStrings[DDNAME] = szDDname;
                stInst.paszStrings[CONFIGDDNAME] = szConfigDDname;
                stInst.paszStrings[CONFIGAPPNAME] = szConfigAppName;
                stInst.paszStrings[APPVERSION] = szAppVersion;
                stInst.paszStrings[APPICONFILE] = szAppIconFile;
                stInst.pfnPrintProgress = (PFN)PrintProgress;
                stInst.pAnyData = (PVOID)&stPageCFG.hObject;
                stInst.byItemCount = 0;
                PrfCloseProfile(hSourceProfile);
                if (pfnProcess(&stInst))
                  {
                  sprintf(szBannerOne,"Files successfully transferred.");
                  sprintf(szBannerTwo,"Select \"Configuration | %s...\" to complete installation.",szConfigDDname);
                  MenuItemEnable(stInst.hwndFrame,IDM_TRANSFER,FALSE);
                  MenuItemEnable(stInst.hwndFrame,IDM_CONFIG_APP,TRUE);
                  }
                else
                  {
                  szBannerOne[0] = 0;
                  sprintf(szBannerTwo,"File transfer incomplete.");
                  DosBeep(500,250);
                  }
                hSourceProfile = PrfOpenProfile(stInst.hab,stInst.pszSourceIniPath);
                }
              else
                {
                szBannerOne[0] = 0;
                sprintf(szBannerTwo,"Transfer Library function does not exist.");
                DosBeep(500,250);
                }
              DosFreeModule(hMod);
              }
            else
              {
              szBannerOne[0] = 0;
              sprintf(szBannerTwo,"Library \"%s\" is invalid, rc = %u.",stInst.paszStrings[XFERLIBRARYSPEC],rc);
              DosBeep(500,250);
              }
            }
          }
        }
      bShowingProgress = FALSE;
      WinInvalidateRect(hwndClient,0,FALSE);
      break;
    case IDM_UNINSTALL:
      WinDlgBox(HWND_DESKTOP,
                hwnd,
         (PFNWP)fnwpUninstallDlgProc,
          (LONG)NULL,
                UNINST_DLG,
          (LONG)NULL);
      WinInvalidateRect( hwnd, NULL, FALSE );
      break;
    case IDM_CONFIG_APP:
      ConfigQuickPage(hwnd);
      return;
    case IDM_CONFIG_DD:
      ConfigCOMi(hwnd);
      return;
    case IDM_PRODUCTINFORMATION:
      WinDlgBox( HWND_DESKTOP,
                 hwnd,
          (PFNWP)fnwpAboutBoxDlgProc,
                 (LONG)NULL,
                 VER_DLG,
                 (LONG)NULL);
      WinInvalidateRect( hwnd, NULL, FALSE );
      break;
    default:
      return;
    }
  }

VOID ClientPaint(HWND hwnd)
  {
  POINTL  pt;
  HPS     hps;
  RECTL   rcl;
  LONG lLen;
  LONG lCenter;

  WinInvalidateRect(hwnd,(PRECTL)NULL,FALSE);
  hps = WinBeginPaint(hwnd,(HPS)NULL,&rcl );
//  if (bShowingProgress)
//    rcl.yBottom = 60L;
  WinFillRect(hps,&rcl,CLR_WHITE);
  lCenter = (INITWIDTH / 2);
  if (bDebug)
    {
    GpiSetBackColor(hps,CLR_WHITE);
    GpiSetBackMix(hps,BM_OVERPAINT);

    GpiCreateLogFont(hps,NULL,3,&fattMsgFont);

    GpiSetColor(hps,CLR_BLACK);
    GpiSetCharSet(hps,3);
    pt.x = 10;

    if (szDebugLineOne[0] != 0)
      {
      pt.y = 82L;
      GpiCharStringAt(hps,&pt,strlen(szDebugLineOne),szDebugLineOne);
      }
    if (szDebugLineTwo[0] != 0)
      {
      pt.y = 62L;
      GpiCharStringAt(hps,&pt,strlen(szDebugLineTwo),szDebugLineTwo);
      }
    }
  else
    {
    GpiSetColor(hps,CLR_CYAN);
    GpiSetBackColor(hps,CLR_WHITE);
    GpiSetBackMix(hps,BM_OVERPAINT);


    GpiCreateLogFont(hps,
                     NULL,
                     2,
                    &fattBigFont);

    GpiSetCharSet(hps,2);
    pt.x = (lCenter - (10 * stBigCell.cx));
    pt.y = 60L;
    GpiCharStringAt(hps,&pt,21,"OS/tools Installation");
    }
  if (!bShowingProgress)
    PrintBanners(szBannerOne,szBannerTwo);
  WinEndPaint(hps);
  }

BOOL CreatePS(HWND hwnd)
  {
  HPS hps;
  int iIndex;
  LONG lWidth;
  LONG lBiggest;
  LONG lFontCount;
  PFONTMETRICS pfmFonts;
  int iBigFont;

  hdcPs = WinOpenWindowDC(hwnd);
  hps = WinGetPS(hwnd);

  lFontCount = 0;
  lFontCount = GpiQueryFonts(hps,
                         QF_PUBLIC,
                         "Helv",
                         &lFontCount,
                         sizeof(FONTMETRICS),
                         NULL);
  if (lFontCount > 0)
    {
    DosAllocMem((PVOID)&pfmFonts,(lFontCount * sizeof(FONTMETRICS)),(PAG_COMMIT | PAG_READ| PAG_WRITE));
    lBiggest = GpiQueryFonts(hps,
                           QF_PUBLIC,
                           "Helv",
                           &lFontCount,
                           sizeof(FONTMETRICS),
                           pfmFonts);

    lBiggest = 0;
    for (iIndex = 0;iIndex < lFontCount;iIndex++)
      {
      lWidth = pfmFonts[iIndex].lAveCharWidth;
      if (lWidth > lBiggest)
        {
        lBiggest = lWidth;
        iBigFont = iIndex;
        }
      }

    fattBigFont.usRecordLength = sizeof(FATTRS);
    fattBigFont.fsSelection = 0;
    fattBigFont.lMatch = pfmFonts[iBigFont].lMatch;
    strcpy(fattBigFont.szFacename,pfmFonts[iBigFont].szFacename);
    fattBigFont.idRegistry = pfmFonts[iBigFont].idRegistry;
    fattBigFont.usCodePage = pfmFonts[iBigFont].usCodePage;
    fattBigFont.lMaxBaselineExt = pfmFonts[iBigFont].lMaxBaselineExt;
    fattBigFont.lAveCharWidth = pfmFonts[iBigFont].lAveCharWidth;
    fattBigFont.fsType = 0;
    fattBigFont.fsFontUse = FATTR_FONTUSE_NOMIX;
    stBigCell.cx = pfmFonts[iBigFont].lAveCharWidth;
    stBigCell.cy = pfmFonts[iBigFont].lXHeight;
    DosFreeMem(pfmFonts);
    }

  lFontCount = 0;
  lFontCount = GpiQueryFonts(hps,
                         QF_PUBLIC,
                         "System VIO",
                         &lFontCount,
                         sizeof(FONTMETRICS),
                         NULL);
  if (lFontCount > 0)
    {
    DosAllocMem((PVOID)&pfmFonts,(lFontCount * sizeof(FONTMETRICS)),(PAG_COMMIT | PAG_READ| PAG_WRITE));
    lBiggest = GpiQueryFonts(hps,
                           QF_PUBLIC,
                           "System VIO",
                           &lFontCount,
                           sizeof(FONTMETRICS),
                           pfmFonts);

    for (iIndex = 0;iIndex < lFontCount;iIndex++)
      if (pfmFonts[iIndex].lAveCharWidth == 8)
        break;
    if (iIndex >= lFontCount)
      iIndex = 0;
    fattMsgFont.usRecordLength = sizeof(FATTRS);
    fattMsgFont.fsSelection = 0;
    fattMsgFont.lMatch = pfmFonts[iIndex].lMatch;
    strcpy(fattMsgFont.szFacename,pfmFonts[iIndex].szFacename);
    fattMsgFont.idRegistry = pfmFonts[iIndex].idRegistry;
    fattMsgFont.usCodePage = pfmFonts[iIndex].usCodePage;
    fattMsgFont.lMaxBaselineExt = pfmFonts[iIndex].lMaxBaselineExt;
    fattMsgFont.lAveCharWidth = pfmFonts[iIndex].lAveCharWidth;
    fattMsgFont.fsType = 0;
    fattMsgFont.fsFontUse = FATTR_FONTUSE_NOMIX;
    stMsgCell.cx = pfmFonts[iIndex].lAveCharWidth;
    stMsgCell.cy = pfmFonts[iIndex].lXHeight;
    DosFreeMem(pfmFonts);
    }
  else
    {
    // this stuff is here because OS/2 version 2.0 does not have System VIO fonts
    lFontCount = 0;
    lFontCount = GpiQueryFonts(hps,
                         QF_PUBLIC,
                         "System Monospaced",
                         &lFontCount,
                         sizeof(FONTMETRICS),
                         NULL);
    if (lFontCount > 0)
      {
      DosAllocMem((PVOID)&pfmFonts,(lFontCount * sizeof(FONTMETRICS)),(PAG_COMMIT | PAG_READ| PAG_WRITE));
      lBiggest = GpiQueryFonts(hps,
                             QF_PUBLIC,
                             "System Monospaced",
                             &lFontCount,
                             sizeof(FONTMETRICS),
                             pfmFonts);

      for (iIndex = 0;iIndex < lFontCount;iIndex++)
        if (pfmFonts[iIndex].lAveCharWidth == 10)
          break;
      if (iIndex >= lFontCount)
        iIndex = 0;
      fattMsgFont.usRecordLength = sizeof(FATTRS);
      fattMsgFont.fsSelection = 0;
      fattMsgFont.lMatch = pfmFonts[iIndex].lMatch;
      strcpy(fattMsgFont.szFacename,pfmFonts[iIndex].szFacename);
      fattMsgFont.idRegistry = pfmFonts[iIndex].idRegistry;
      fattMsgFont.usCodePage = pfmFonts[iIndex].usCodePage;
      fattMsgFont.lMaxBaselineExt = pfmFonts[iIndex].lMaxBaselineExt;
      fattMsgFont.lAveCharWidth = pfmFonts[iIndex].lAveCharWidth;
      fattMsgFont.fsType = 0;
      fattMsgFont.fsFontUse = FATTR_FONTUSE_NOMIX;
      stMsgCell.cx = pfmFonts[iIndex].lAveCharWidth;
      stMsgCell.cy = pfmFonts[iIndex].lXHeight;
      DosFreeMem(pfmFonts);
      }
    }
  WinReleasePS(hps);
  return(TRUE);
  }

void ConfigQuickPage(HWND hwnd)
  {
  BOOL bSuccess = FALSE;
  HMODULE hMod;
  PFN pfnProcess;
  char szCaption[40];
  char szMessage[100];
  INFODLG stInfoDlg;

  stInst.bAppConfigured = FALSE;
  if (stInst.paszStrings[CONFIGAPPLIBRARYSPEC][0] == 0)
    {
    if (PrfQueryProfileString(HINI_USERPROFILE,szConfigAppName,"Configuration",0L,
                                                stInst.paszStrings[CONFIGDDLIBRARYSPEC],
                                                stInst.ulMaxPathLen) == 0)
      strcpy(stInst.paszStrings[CONFIGAPPLIBRARYSPEC],"QPG_CFG.DLL");
    }
  if (DosLoadModule(0,0,stInst.paszStrings[CONFIGAPPLIBRARYSPEC],&hMod) != NO_ERROR)
    {
    sprintf(stInst.paszStrings[CONFIGAPPLIBRARYSPEC],"%s\\QPG_CFG.DLL",stInst.pszSourcePath);
    if (DosLoadModule(0,0,stInst.paszStrings[CONFIGAPPLIBRARYSPEC],&hMod) != NO_ERROR)
      {
      sprintf(szCaption,"Configuration cannot be completed.");
      sprintf(szMessage,"Library %s is invalid or does not exist.",stInst.paszStrings[CONFIGAPPLIBRARYSPEC]);
      WinMessageBox(HWND_DESKTOP,
                    stInst.hwndFrame,
                    szMessage,
                    szCaption,
                    HLPP_MB_LIBRARY_BAD,
                   (MB_OK | MB_HELP | MB_WARNING));
      sprintf(szBannerTwo,"Installation is not complete");
      szBannerOne[0] = 0;
      ClientPaint(hwndClient);
      return;
      }
    }
  else
    {
    if (DosQueryProcAddr(hMod,0,szConfigAppFunctionName,(PFN *)&pfnProcess) == NO_ERROR)
      {
      stPageCFG.cbSize = sizeof(COMICFG);
      stPageCFG.hwndFrame = stInst.hwndFrame;
      stPageCFG.hab = stInst.hab;
      stPageCFG.pszHelpFileName = szConfigAppHelpFileName;
      stPageCFG.pszConfigFileName = szPagerFileName;
      stPageCFG.pszDestPath = pszPath;
      stPageCFG.pszDestPath = stInst.pszAppsPath;
      if (stInst.byItemCount == 0)
        stPageCFG.hObject = 0;
      bSuccess = pfnProcess(&stPageCFG);
      }
    DosFreeModule(hMod);
    }
  if (bSuccess)
    {
    sprintf(szCaption,"Configuration is complete.");
    sprintf(szMessage,"%s has been successfully configured.",szConfigAppName);
    WinMessageBox(HWND_DESKTOP,
                  stInst.hwndFrame,
                  szMessage,
                  szCaption,
                  HLPP_MB_CONFIG_OK,
                 (MB_OK | MB_HELP | MB_INFORMATION));
    stInst.bAppConfigured = TRUE;
//    szBannerOne[0] = 0;
    if (stInst.bFilesCopied)
      {
      if (!stInst.bDDconfigured)
        {
        sprintf(szBannerTwo,"%s Configuration is complete",szConfigAppName);
        sprintf(szBannerOne,"Select \"Configuration | %s...\" to complete Installation",szConfigDDname);
        }
      else
        sprintf(szBannerTwo,"Installation is complete");
      }
    else
      sprintf(szBannerTwo,"%s Configuration is complete",szConfigAppName);
    ClientPaint(hwndClient);
    if (stInst.bFilesCopied)
      {
      if (strlen(szInfoFileName) != 0)
        {
        stInfoDlg.cbSize = sizeof(INFODLG);
        stInfoDlg.pszFileName = szInfoFileName;
        stInfoDlg.pszCaption = szInfoCaption;
        WinDlgBox(HWND_DESKTOP,
                  hwnd,
           (PFNWP)fnwpInfoDlgProc,
            (LONG)NULL,
                  EVAL_MSG,
             (PVOID)&stInfoDlg);
        }
      }
    }
  else
    {
    if (stInst.bFilesCopied)
      {
      sprintf(szCaption,"Configuration is not complete.");
      sprintf(szMessage,"You must select the \"Configuration | %s...\" menu item again to complete installation.",szConfigAppName);
      WinMessageBox(HWND_DESKTOP,
                    stInst.hwndFrame,
                    szMessage,
                    szCaption,
                    HLPP_MB_CONFIG_BAD,
                   (MB_OK | MB_HELP | MB_WARNING));
      sprintf(szBannerTwo,"Installation is not complete");
      szBannerOne[0] = 0;
      ClientPaint(hwndClient);
      }
    }
  }

void ConfigCOMi(HWND hwnd)
  {
  BOOL bSuccess = FALSE;
  HMODULE hMod;
  PFN pfnProcess;
  char szCaption[40];
  char szMessage[100];
  INFODLG stInfoDlg;

  stInst.bDDconfigured = FALSE;
  if (stInst.paszStrings[CONFIGDDLIBRARYSPEC][0] == 0)
    {
    if (PrfQueryProfileString(HINI_USERPROFILE,szConfigDDname,"Configuration",0L,
                                                stInst.paszStrings[CONFIGDDLIBRARYSPEC],
                                                stInst.ulMaxPathLen) == 0)
      sprintf(stInst.paszStrings[CONFIGDDLIBRARYSPEC],"COMi_CFG.DLL");
    }
  if (DosLoadModule(0,0,stInst.paszStrings[CONFIGDDLIBRARYSPEC],&hMod) != NO_ERROR)
    {
    sprintf(stInst.paszStrings[CONFIGDDLIBRARYSPEC],"%s\\%s.DLL",stInst.pszSourcePath,szConfigDDlibraryName);
    if (DosLoadModule(0,0,stInst.paszStrings[CONFIGDDLIBRARYSPEC],&hMod) != NO_ERROR)
      {
      sprintf(szCaption,"Configuration cannot be completed.");
      sprintf(szMessage,"Library %s is invalid or does not exist.",stInst.paszStrings[CONFIGDDLIBRARYSPEC]);
      WinMessageBox(HWND_DESKTOP,
                    stInst.hwndFrame,
                    szMessage,
                    szCaption,
                    HLPP_MB_LIBRARY_BAD,
                   (MB_OK | MB_HELP | MB_WARNING));
      sprintf(szBannerTwo,"Installation is not complete");
      szBannerOne[0] = 0;
      ClientPaint(hwndClient);
      return;
      }
    }
  else
    {
    if (DosQueryProcAddr(hMod,0,szConfigDDfunctionName,(PFN *)&pfnProcess) == NO_ERROR)
      {
      stCOMiCFG.pszPortName = NULL;
      stCOMiCFG.cbSize = sizeof(COMICFG);
      stCOMiCFG.bEnumCOMscope = FALSE;
      stCOMiCFG.bInstallCOMscope = bCOMscopeToInstall;
      stCOMiCFG.bInitInstall = TRUE;
      stCOMiCFG.hwndFrame = stInst.hwndFrame;
      stCOMiCFG.byOEMtype = (BYTE)ulOEMtype;
      stCOMiCFG.hab = stInst.hab;
      if (strlen(stCOMiCFG.pszDriverIniSpec) == 0)
        sprintf(stCOMiCFG.pszDriverIniSpec,"%s\\%s",stInst.pszAppsPath,szDDname);
      bSuccess = pfnProcess(&stCOMiCFG);
      }
    DosFreeModule(hMod);
    }
  if (bSuccess)
    {
    sprintf(szCaption,"Configuration is complete.");
    if (!stInst.bFilesCopied)
      sprintf(szMessage,"You must shut down and re-start your system for any configuration changes to take effect.");
    else
      sprintf(szMessage,"You must shut down your system to activate serial access.");
    WinMessageBox(HWND_DESKTOP,
                  stInst.hwndFrame,
                  szMessage,
                  szCaption,
                  HLPP_MB_CONFIG_OK,
                 (MB_OK | MB_HELP | MB_INFORMATION));
    szBannerOne[0] = 0;
    stInst.bDDconfigured = TRUE;
    if (stInst.bFilesCopied)
      {
      sprintf(szBannerTwo,"Installation is complete");
      if (!stInst.bAppConfigured)
        sprintf(szBannerOne,"%s configuration is complete",szConfigDDname);
      }
    else
      sprintf(szBannerTwo,"%s Configuration is complete",szConfigAppName);
    ClientPaint(hwndClient);
    if (stInst.bFilesCopied)
      {
      if (strlen(szInfoFileName) != 0)
        {
        stInfoDlg.cbSize = sizeof(INFODLG);
        stInfoDlg.pszFileName = szInfoFileName;
        stInfoDlg.pszCaption = szInfoCaption;
        WinDlgBox(HWND_DESKTOP,
                  hwnd,
           (PFNWP)fnwpInfoDlgProc,
            (LONG)NULL,
                  EVAL_MSG,
             (PVOID)&stInfoDlg);
        }
      }
    }
  else
    {
    if (stInst.bFilesCopied)
      {
      sprintf(szCaption,"Configuration is not complete.");
      sprintf(szMessage,"You must select the \"Configuration | %s...\" menu item again to complete installation.",szConfigDDname);
      WinMessageBox(HWND_DESKTOP,
                    stInst.hwndFrame,
                    szMessage,
                    szCaption,
                    HLPP_MB_CONFIG_BAD,
                   (MB_OK | MB_HELP | MB_WARNING));
      sprintf(szBannerTwo,"Installation is not complete");
      szBannerOne[0] = 0;
      ClientPaint(hwndClient);
      }
    }
  }

