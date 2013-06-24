#include "wCommon.h"

#pragma hdrstop

#include "usermsg.h"
#include "dialog.h"

//#include "CLP.h"

VOID ComCommand(HWND hWnd,USHORT Command,THREAD *pstThd);

extern MRESULT EXPENTRY fnwpPortSelectDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpSetColorDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpProcStringXferDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpProcTerminalDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
#ifdef inc_CLP      
extern MRESULT EXPENTRY fnwpSetCLP_LEDsDlg(HWND hwndDlg,USHORT msg, MPARAM mp1,MPARAM mp2);
extern MRESULT EXPENTRY fnwpCLP_StatusDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
#endif
extern void StartSystem(THREAD *pstThd,BOOL bRestart);

BOOL bIsTheFirst = FALSE;
BOOL bResetCounter = FALSE;
//extern HWND hwndHelpInstance;

BOOL Scroll(THREAD *pstThd,SHORT sCx,SHORT sCy);
BOOL WndSize(THREAD *pstThd,HWND hwnd,MPARAM mp2);
BYTE QueryAnsiClr(BYTE PSClr);
VOID CreatePS(HWND hwnd,THREAD *pstThd);

COMCTL stComCtl;
IOCTLINST stIOctlInst;

char szWinCOMProfile[] = "WinCOM";
char szWinCOMAppName[40] = "WinCOM";
BOOL bSearchProfileApps = FALSE;
BOOL bUseProfile = TRUE;
PROFILE stProfile;
HPROF hProfileInstance = NULL;

#ifdef inc_CLP      
extern BOOL bCLP_StatusActivated;
HWND hwndCLP_Status;
#endif

BOOL bMaximized = FALSE;
BOOL bMinimized = FALSE;
SWP swpLastPosition;

HEV hevStartThreadSem;
HEV hevRestartThreadSem;
HEV hevKillThreadSem;
HEV hevKillReadThreadSem;
HEV hevKillWriteThreadSem;
HEV hevStartReadThreadSem;
HEV hevStartWriteThreadSem;
HEV hevStartReadSem;
HEV hevStartWriteSem;

HAB habAnchorBlock;
HWND hwndFrame;
HWND hwndClient;
int iDebugLevel = 0;

MRESULT EXPENTRY FrameSubProc(HWND hwnd,WORD msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpClient(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY StatusProc(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);

VOID Help(HWND hwnd);
VOID PaintWindow( HWND hwnd, COLOR clr );
VOID ClientPaint(HWND hwnd);

PRF_MANAGE pfnManageProfile;
PRF_DATA pfnGetProfileData;
PRF_DATA pfnSaveProfileData;
PRF_GETSTR pfnGetProfileString;
PRF_SAVESTR pfnSaveProfileString;
PRF_INIT pfnInitializeProfile;
PRF_CLOSE pfnCloseProfile;

char szMsg[200];

void SaveWindowPositions(CONFIG *pCfg);

CHAR   chAnsi[8] = {0x1B,'[','3','*',';','4','*','m'};

typedef struct
  {
  BYTE PSClr;
  CHAR AnsiClr;
  }VIOCLR;

  VIOCLR ClrTable[] = {{AVIO_BLACK, ANSI_BLACK},
                       {AVIO_WHITE, ANSI_WHITE},
                       {AVIO_RED,   ANSI_RED},
                       {AVIO_GREEN, ANSI_GREEN},
                       {AVIO_BLUE,  ANSI_BLUE}};

char szWinCOMVersion[] = "Version 1.00";
char szWinCOMIniPath[CCHMAXPATH + 1];
THREAD stThisWindow;
THREAD *pstThread = &stThisWindow;

CHAR szErrorMessage[81] = "No Errors Yet";

CHAR  szHelp[] = "Please,   ";                         /* Help message strings    */
CHAR  szHelpMessage[] = "Please me!!";

CHAR szTitle[] = "No Port Selected";

void APIENTRY ExitRoutine(ULONG ulTermCode)
  {
  HMODULE hMod;

  if (stThisWindow.hCom != 0)
    DosClose(stThisWindow.hCom);
//  MessageBox(HWND_DESKTOP,"Exit Routine entered");
  if (hProfileInstance != NULL)
    {
    if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
      {
      if (!stThisWindow.stCfg.bLongString)
        if (DosQueryProcAddr(hMod,0,"SaveProfileData",(PFN *)&pfnSaveProfileData) == NO_ERROR)
          pfnSaveProfileData(hProfileInstance,"Write String",(BYTE *)stThisWindow.pWriteString,stThisWindow.stCfg.wWriteStringLength);
//      if (stThisWindow.stCfg.bLoadMonitor && (stThisWindow.hCom != 0))
//        {
//        GetDCB(&stIOctlInst,stThisWindow.hCom,&stThisWindow.stCfg.stComDCB);
//        GetBaudRate(&stIOctlInst,stThisWindow.hCom,&stThisWindow.stCfg.lBaudRate);
//        GetLineCharacteristics(&stIOctlInst,stThisWindow.hCom,&stThisWindow.stCfg.stLineCharacteristics);
//        }
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
      stThisWindow.stCfg.bLoadWindowPosition = stProfile.bLoadWindowPosition;
      stThisWindow.stCfg.bLoadMonitor = stProfile.bLoadProcess;
      stThisWindow.stCfg.bAutoSaveConfig = stProfile.bAutoSaveProfile;
      SaveWindowPositions(&stThisWindow.stCfg);
      break;
    case PROFACTION_ENTER_MANAGE:
    case PROFACTION_PROFILE_LOADED:
      stProfile.bLoadWindowPosition = stThisWindow.stCfg.bLoadWindowPosition;
      stProfile.bLoadProcess = stThisWindow.stCfg.bLoadMonitor;
      stProfile.bAutoSaveProfile = stThisWindow.stCfg.bAutoSaveConfig;
      break;
    case PROFACTION_EXIT_SAVE:
    case PROFACTION_ENTER_LOAD:
    case PROFACTION_EXIT_LOAD:
    case PROFACTION_EXIT_MANAGE:
      break;
    }
  }

void main(int argc,char *argv[])
  {
  HMQ hmqQueue;                        /* Message queue handle         */
  QMSG qmsgMessage;                      /* Message structure            */
  ULONG flCreate;
  THREAD *pstThd;
  LONG lIndex;
  ULONG ulAction;
  HMODULE hMod;

  if (argc >= 2)
    {
    for (lIndex = 1;lIndex < argc;lIndex++)
      {
      if ((argv[lIndex][0] == '/') || (argv[lIndex][0] == '-'))
        {
        switch (argv[lIndex][1] & 0xdf)
          {
          case 'P':
            if (argv[lIndex][2] == '-')
              bUseProfile = FALSE;
            else
              {
              if (argv[lIndex][2] != 0)
                strcpy(szWinCOMAppName,&argv[lIndex][2]);
              }
            break;
          case 'S':
            if (argv[lIndex][2] == '-')
              bUseProfile = FALSE;
            else
              {
              bSearchProfileApps = TRUE;
              if (argv[lIndex][2] != 0)
                strcpy(szWinCOMAppName,&argv[lIndex][2]);
              }
            break;
          case 'C':
            bResetCounter = TRUE;
          case 'X':
            bIsTheFirst = TRUE;
            break;
          case 'D':
            iDebugLevel = atoi(&argv[lIndex][2]);
            break;
          }
        }
      }
    }

  strcpy(szWinCOMIniPath,argv[0]);
  for (lIndex = strlen(szWinCOMIniPath);lIndex > 0;lIndex--)
    {
    if (argv[0][lIndex] ==  '\\')
      break;
    }
  lIndex++;
  szWinCOMIniPath[lIndex] = 0;

  WindowInit(&stThisWindow);

  habAnchorBlock = WinInitialize(NUL);        /* Initialize PM                 */
  stIOctlInst.hab = habAnchorBlock;

  if (bUseProfile)
    {
    if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
      {
      stProfile.hab = habAnchorBlock;
      stProfile.phwndHelpInstance = NULL;
//      stProfile.phwndHelpInstance = &hwndHelpInstance;
//      stProfile.ulHelpPanel = HLPP_PROFILE_DLG;
      strcpy(stProfile.stUserProfile.szAppName,szWinCOMAppName);
      strcpy(stProfile.stUserProfile.szVersionString,szWinCOMVersion);
      strcpy(stProfile.szIniFilePath,szWinCOMIniPath);
      strcpy(stProfile.szProfileName,szWinCOMProfile);
      strcpy(stProfile.szAppName,szWinCOMAppName);
      stProfile.pData = (void *)&stThisWindow.stCfg;
      stProfile.ulDataSize = sizeof(CONFIG);
      stProfile.ulMaxApps = 99;
      stProfile.pfnUpdateCallBack = pfnUpdateProfileOptions;
      stProfile.ulMaxProfileString = MAX_PROFILE_STRING;
      stProfile.bSearchApps = bSearchProfileApps;
//      if (bLaunchShutdownServer)
//        {
//        stProfile.bLoadProcess = TRUE;
//        stProfile.bAutoSaveProfile = TRUE;
//        }
//     else
        {
        stProfile.bLoadProcess = FALSE;
        stProfile.bAutoSaveProfile = FALSE;
        }
      stProfile.bLoadWindowPosition = FALSE;
      stProfile.bRestart = bIsTheFirst;
      strcpy(stProfile.szProcessPrompt,"Load process ~configuration");
      stProfile.hwndOwner = hwndFrame;

      if (DosQueryProcAddr(hMod,0,"InitializeProfile",(PFN *)&pfnInitializeProfile) == NO_ERROR)
        {
        if ((hProfileInstance = pfnInitializeProfile(&stProfile)) != 0)
          {
          stProfile.bLoadWindowPosition = stThisWindow.stCfg.bLoadWindowPosition;
          stProfile.bLoadProcess = stThisWindow.stCfg.bLoadMonitor;
          stProfile.bAutoSaveProfile = stThisWindow.stCfg.bAutoSaveConfig;
#ifdef this_junk
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
#endif
          }
        }
      DosFreeModule(hMod);
      }
    }

  if (bResetCounter)
    stThisWindow.stCfg.wWriteCounter = 0;

  hmqQueue   = WinCreateMsgQueue(habAnchorBlock,0);   /* Create application msg queue */

  WinRegisterClass(                   /* Register window class        */
      habAnchorBlock,                 /* Anchor block handle          */
      "ICOMMAIN",                     /* Window class name            */
      (PFNWP)fnwpClient,              /* Address of window procedure   */
      CS_SIZEREDRAW,                  /* Class style                  */
      10                               /* Pointer to session parameters*/
      );

  WinRegisterClass(habAnchorBlock,
                  (PSZ)"SUBFRAME",
                  (PFNWP)FrameSubProc,
                  0L,0);

  WinRegisterClass(habAnchorBlock,
                  (PSZ)"STATUS",
                  (PFNWP)StatusProc,
                  CS_SIZEREDRAW,0);

  DosExitList(EXLST_ADD,ExitRoutine);

  pstThd = pstThread;

  /*
  **  Initialize DosDevIOCtl library (COMi_CTL.DLL) structures
  */
  stIOctlInst.pszPortName = pstThd->stCfg.szPortName;
  stComCtl.pszPortName = pstThd->stCfg.szPortName;
  stComCtl.pstIOctl = &stIOctlInst;
  stComCtl.cbSize = sizeof(COMCTL);
  stComCtl.hwndHelpInstance = 0;
  stComCtl.usHelpId = 0;

  flCreate =  FCF_STANDARD ^ FCF_SHELLPOSITION | FCF_VERTSCROLL | FCF_HORZSCROLL;

  hwndFrame = WinCreateStdWindow(
        HWND_DESKTOP,                 /* Desktop window is parent     */
        WS_VISIBLE,                   /* Frame style                  */
        &flCreate,                    /* Control data                 */
        "ICOMMAIN",                   /* Window class name            */
        NUL,                          /* Window text                  */
        (ULONG)WS_VISIBLE | WS_CLIPCHILDREN,
        NUL,                          /* Module handle == this module */
        IDM_PORT,                     /* Window ID                    */
        &hwndClient                   /* Client window handle         */
        );

  WinShowWindow(hwndFrame,TRUE);

  /*
  ** Subclass the frame window procedure in order to implement frame
  ** sizing restrictions.
  ** Messages for the frame window procedure are first passed to
  ** FrameSubProc.  This can either process or ignore the messages, thus
  ** allowing the normal behavior of the frame window to be altered.
  */
  pstThd->frameproc = WinSubclassWindow(hwndFrame,(PFNWP)FrameSubProc);

  WinSetFocus(HWND_DESKTOP,hwndClient);

  /*
  ** Set up globals used for sizing
  */

  pstThd->stVio.lXScr   = WinQuerySysValue(HWND_DESKTOP,SV_CXSCREEN);
  pstThd->stVio.lcxVSc  = WinQuerySysValue(HWND_DESKTOP,SV_CXVSCROLL);
  pstThd->stVio.lcxBrdr = WinQuerySysValue(HWND_DESKTOP,SV_CXSIZEBORDER);

  pstThd->hCom = 0;
  pstThd->hwndFrame = hwndFrame;
  pstThd->hwndClient = hwndClient;
  pstThd->habAnchorBlk = habAnchorBlock;
  WinSetWindowPtr(hwndClient,0,pstThd);
  WinSetWindowPtr(hwndFrame,0,pstThd);

  WinSetWindowText(hwndFrame, szTitle );

  while( WinGetMsg(habAnchorBlock,&qmsgMessage,(HWND)NUL,0,0))
    WinDispatchMsg(habAnchorBlock,&qmsgMessage);

#ifdef inc_CLP      
  WinDestroyWindow(hwndCLP_Status);
#endif  
  WinDestroyWindow(pstThd->hwndFrame);
  WinDestroyWindow(pstThd->hwndStatus);
  WinDestroyMsgQueue(hmqQueue);
  WinTerminate(habAnchorBlock);
  if (pstThd->hCom != 0)
    DosClose(pstThd->hCom);
  KillThread(pstThd);
  DosExit(1,0);
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
  USHORT   Command;               /* Command passed by WM_COMMAND    */
  static THREAD *pstThd;
  static VIOPS *pVio;
  static CONFIG *pCfg;
  APIRET rc;
  ULONG ulCount;
  CHAR szMessage[81];
  TERMPARMS *pTerm;
  THREADCTRL *pThread;
  HMODULE hMod;

  switch(msg)
    {
    case WM_CREATE:
      pstThd = pstThread;
      pVio = &pstThd->stVio;
      pCfg = &pstThd->stCfg;

      if ((rc = DosCreateEventSem(0L,&hevStartThreadSem,0L,TRUE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
        ErrorNotify(pstThd,szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        return(FALSE);
        }
      if ((rc = DosCreateEventSem(0L,&hevRestartThreadSem,0L,TRUE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
        ErrorNotify(pstThd,szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        return(FALSE);
        }
      if ((rc = DosCreateEventSem(0L,&hevKillReadThreadSem,0L,TRUE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
        ErrorNotify(pstThd,szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        return(FALSE);
        }
      if ((rc = DosCreateEventSem(0L,&hevStartReadSem,0L,TRUE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
        ErrorNotify(pstThd,szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        return(FALSE);
        }
      if ((rc = DosCreateEventSem(0L,&hevStartWriteSem,0L,TRUE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
        ErrorNotify(pstThd,szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        return(FALSE);
        }
      if ((rc = DosCreateEventSem(0L,&hevStartReadThreadSem,0L,TRUE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
        ErrorNotify(pstThd,szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        return(FALSE);
        }
      if ((rc = DosCreateEventSem(0L,&hevStartWriteThreadSem,0L,TRUE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
        ErrorNotify(pstThd,szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        return(FALSE);
        }
      if ((rc = DosCreateEventSem(0L,&hevKillThreadSem,0L,TRUE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
        ErrorNotify(pstThd,szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        return(FALSE);
        }
      /*****************************************************************/
      /* Create AVIO PS to go with the client area.                    */
      /*                                                               */
      /* This initializes the global structure stCell, which defines  */
      /* the AVIO character cell size.                                 */
      /*****************************************************************/
      CreatePS(hwnd,pstThd);

         /*****************************************************************/
         /* The status window is a line across the bottom of the client   */
         /* area.  It is one AVIO cell deep.  Text is displayed to show   */
         /* the states of the switches that can be toggles ON or OFF.     */
         /*                                                               */
         /* The status window is a child window of the client.            */
         /* It is created when the AVIO Presentation Space exists and the */
         /* DevCell values are known.                                     */
         /*****************************************************************/
          pstThd->hwndStatus = WinCreateWindow( hwnd,
                                       (PSZ)"STATUS",
                                       (PSZ)"",
                                        WS_VISIBLE,
                                        0,
                                        2,
                                        pVio->stCell.cx * PSWIDTH,
                                        pVio->stCell.cy + 2,
                                        WinQueryWindow(hwnd,
                                                        QW_PARENT),
                                        HWND_TOP,
                                        21,
                                        (PVOID)NULL,
                                        (PVOID)NULL
                                        );
      /****************************************************************/
      /* Set the size and position of the frame window by making the  */
      /* client area width and height integral numbers of AVIO cell   */
      /* units.  Calculate the frame window values necessary to       */
      /* achieve this.                                                */
      /****************************************************************/

      rcl.yBottom = 0L;
      rcl.xLeft   = 0L;
      rcl.yTop    = INITIALHEIGHT * pVio->stCell.cy;
      rcl.xRight  = INITIALWIDTH  * pVio->stCell.cx;

      WinCalcFrameRect( WinQueryWindow( hwnd, QW_PARENT),
                        &rcl,
                        FALSE );
      if (!bUseProfile || !pCfg->bLoadWindowPosition)
        {
        pCfg->ptlFramePos.x = (7 * pVio->stCell.cx);
        pCfg->ptlFramePos.y = (2 * pVio->stCell.cy);
        pCfg->ptlFrameSize.x = (rcl.xRight - rcl.xLeft);
        pCfg->ptlFrameSize.y = (rcl.yTop - rcl.yBottom);
        }
      WinSetWindowPos( WinQueryWindow( hwnd, QW_PARENT),
                       0,
                       pCfg->ptlFramePos.x,
                       pCfg->ptlFramePos.y,
                       pCfg->ptlFrameSize.x,
                       pCfg->ptlFrameSize.y,
                       SWP_MOVE | SWP_SIZE );

      WinPostMsg(hwnd,UM_INITMENUS,0L,0L);
      break;
     case WM_MINMAXFRAME:
     /***********************************************************/
     /* Record the position of the Presentation Space origin if */
     /* the window is being minimized or maximized, and reset   */
     /* it to the saved position when the window size is        */
     /* restored.                                               */
     /***********************************************************/

       pswp = (PSWP)mp1;
       if( pswp->fl & SWP_RESTORE )
          VioSetOrg(OrigRestor.y,OrigRestor.x,pVio->hpsVio);
       else
          VioGetOrg(&OrigRestor.y,&OrigRestor.x,pVio->hpsVio);

       usCxMaxWnd = (SHORT)((pVio->usPsWidth * pVio->stCell.cx) +
                                          (2 * pVio->lcxBrdr ) + pVio->lcxVSc - 1);
       if((pswp->fl & SWP_MAXIMIZE) && (pVio->lXScr >  usCxMaxWnd))
          {
          pswp->cx = usCxMaxWnd;
          pswp->x  = 0;
          }
       return(FALSE);
    case WM_VSCROLL:
#ifdef inc_CLP      
      if (!bCLP_StatusActivated)
#endif      
        {
        VioGetOrg(&Origin.y,&Origin.x,pVio->hpsVio);
        switch(HIUSHORT(mp2))
           {
            case SB_LINEDOWN:
                Scroll(pstThd,0,WNDROW);
                break;
  
            case SB_LINEUP:
                Scroll(pstThd,0,-WNDROW);
                break;
  
            case SB_PAGEDOWN:
                Scroll(pstThd,0,pVio->usWndDepth-2);
                break;
  
            case SB_PAGEUP:
                Scroll(pstThd,0,-(pVio->usWndDepth-2));
                break;
  
           case SB_SLIDERPOSITION:
                Scroll(pstThd,0,LOUSHORT(mp2) - Origin.y);
                break;
  
            default:
                break;
            }
        }
      break;
    case WM_HSCROLL:
#ifdef inc_CLP      
      if (!bCLP_StatusActivated)
#endif      
        {
        VioGetOrg(&Origin.y,&Origin.x,pVio->hpsVio);
        switch(HIUSHORT(mp2))
           {
            case SB_LINELEFT:
                Scroll(pstThd,-WNDCOL,0);
                break;

            case SB_LINERIGHT:
                Scroll(pstThd,WNDCOL,0);
                break;

            case SB_PAGELEFT:
                Scroll(pstThd,-(pVio->usWndWidth-2),0);
                break;

            case SB_PAGERIGHT:
                Scroll(pstThd,pVio->usWndWidth-2,0);
                break;

           case SB_SLIDERPOSITION:
                Scroll(pstThd,LOUSHORT(mp2) - Origin.x,0);
                break;

            default:
                break;
            }
         }
       break;
    case WM_DESTROY:
       VioAssociate((HDC)NULL,pVio->hpsVio);
       VioDestroyPS(pVio->hpsVio);
       break;
    case WM_ACTIVATE:
      if(LOUSHORT(LONGFROMMP(mp1)))
        WinSetFocus(HWND_DESKTOP,hwnd);
      break;
    case UM_INITMENUS:
#ifdef inc_CLP      
      hwndCLP_Status = WinLoadDlg(hwndFrame,hwndClient,(PFNWP)fnwpCLP_StatusDlg,(USHORT)NULL,DLG_PASTATUS,NULL);
#else
      MenuItemEnable(hwndFrame,IDM_MCLP,FALSE);
      MenuItemEnable(hwndFrame,IDM_CLP,FALSE);
#endif      
      if (bIsTheFirst)
        {
        sprintf(szMsg,"Profile \"%s\" reset!",szWinCOMAppName);
        WinMessageBox(HWND_DESKTOP,hwndFrame,"Remove \"/X\" parameter for normal operation.",
                                              szMsg,0L,MB_OK);
        if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
          {
          if (DosQueryProcAddr(hMod,0,"CloseProfile",(PFN *)&pfnCloseProfile) == NO_ERROR)
            hProfileInstance = pfnCloseProfile(hProfileInstance);
          DosFreeModule(hMod);
          }
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        }
      else
        {
        if (hProfileInstance == NULL)
          MenuItemEnable(hwndFrame,IDM_MANAGEPROFILE,FALSE);
        StartSystem(&stThisWindow,TRUE);
        ClearScreen(pstThd);
        }
      break;
     case WM_PAINT:
       hps = WinBeginPaint(hwnd,(HPS)NULL,&rcl);
       /*
       ** Clipping will occur to window boundary, so don't be
       ** selective
       */
       VioShowPS(pVio->usPsDepth,pVio->usPsWidth,0,pVio->hpsVio);
       WinEndPaint(hps);
       break;
     case WM_CHAR:
      if (pCfg->wSimulateType == TERMINAL)
        {
        pTerm = &pstThd->stTerm;
        if (SHORT1FROMMP(mp1) & KC_CHAR)
          {
          chKey = SHORT1FROMMP(mp2);
          if ((rc = DosWrite(pstThd->hCom,(PVOID)&chKey,1,&ulCount)) != 0)
            {
            sprintf(szMessage,"Error Writing to Port - Error = %u",rc);
            ErrorNotify(pstThd,szMessage);
            }
          if (pTerm->bLocalEcho == TRUE)
            VioWrtTTY(&chKey,1,pVio->hpsVio);
          if (chKey == '\x0d')
            {
            chKey = '\x0a';
            if (pTerm->bLocalEcho == TRUE)
              VioWrtTTY(&chKey,1,pVio->hpsVio);
            if (pTerm->bOutputLF)
              {
              if ((rc = DosWrite(pstThd->hCom,(PVOID)&chKey,1,&ulCount)) != 0)
                {
                sprintf(szMessage,"Error Writing to Port - Error = %u",rc);
                ErrorNotify(pstThd,szMessage);
                }
              }
            }
          }
        }
       else
           return( WinDefWindowProc(hwnd,msg,mp1,mp2));
       break;
     case WM_SIZE:
       /*
       ** If the window is associated with an AVIO Presentation Space,
       ** WM_SIZE must call WinDefAVioWindowProc before accessing the
       ** window.
       */
       WinDefAVioWindowProc(hwnd,msg,(USHORT)mp1,(USHORT)mp2);
       WndSize(pstThd,hwnd,mp2);
       /*
       ** Allow to fall through to the normal default window procedure
       */
      return WinDefWindowProc(hwnd,msg,mp1,mp2);
#ifdef this_junk
    case WM_PAINT:
      ClientPaint(hwnd);        /* Invoke window-painting routine  */
      break;
#endif
     case WM_BUTTON1DOWN:
       /*****************************************************************/
       /* If the window is not the active window, take the default      */
       /* action.  Otherwise, position the cursor at the mouse          */
       /* pointer position.                                             */
       /*****************************************************************/
       if((WinQueryActiveWindow(HWND_DESKTOP) == pstThd->hwndFrame))
         {
         ptl.x = (LONG)LOUSHORT(mp1);
         ptl.y = (LONG)HIUSHORT(mp1);

         /*************************************************************/
         /* Convert pointer position to AVIO units and coordinates.   */
         /* Also, pointer position is given relative to BOTTOM left   */
         /* of window & cursor positioning is relative to TOP left.   */
         /*************************************************************/

         ptl.x /= pVio->stCell.cx;
         ptl.y  = pVio->usWndDepth - (ptl.y/pVio->stCell.cy);

         VioGetOrg(&Origin.y,&Origin.x,pVio->hpsVio);
         VioSetCurPos(Origin.y+(SHORT)ptl.y,
                      Origin.x+(SHORT)ptl.x,
                      pVio->hpsVio );
         return(MRESULT)(TRUE);
         }
      return( WinDefWindowProc(hwnd,msg,mp1,mp2));
    case WM_ERASEBACKGROUND:
      return (MRESULT)(TRUE);     /* Erase Client Area               */
    case WM_HELP:
      Help(hwnd);                     /* Invoke private help function    */
      break;
    case UM_KILLTHREAD:
      pThread = &pstThd->stThread;
//      DosFreeSeg(pThread->selReadStack);
//      DosFreeSeg(pThread->selStack);
      pThread->idReadThread = 0;
      pThread->idThread = 0;
      MenuItemCheck(hwndFrame,IDM_SSTART,FALSE);
      MenuItemCheck(hwndFrame,IDM_SPAUSE,TRUE);
      MenuItemEnable(hwndFrame,IDM_SSTART,TRUE);
      MenuItemEnable(hwndFrame,IDM_SPAUSE,FALSE);
      break;
    case WM_COMMAND:
      Command = SHORT1FROMMP(mp1);
      ComCommand(hwnd,Command,pstThd);
      break;
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
      if (!pstThd->stThread.bStopThread)
        PauseThread(pstThd);

      if (hProfileInstance != NULL)
        {
        HMODULE hMod;

        SaveWindowPositions(&stThisWindow.stCfg);
        if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
          {
          if (!pstThd->stCfg.bLongString)
            if (DosQueryProcAddr(hMod,0,"SaveProfileData",(PFN *)&pfnSaveProfileData) == NO_ERROR)
              pfnSaveProfileData(hProfileInstance,"Write String",(BYTE *)pstThd->pWriteString,pstThd->stCfg.wWriteStringLength);
          if (pstThd->stCfg.bLoadMonitor && (pstThd->hCom != 0))
            {
            GetDCB(&stIOctlInst,pstThd->hCom,&pstThd->stCfg.stComDCB);
            GetBaudRate(&stIOctlInst,pstThd->hCom,&pstThd->stCfg.lBaudRate);
            GetLineCharacteristics(&stIOctlInst,pstThd->hCom,&pstThd->stCfg.stLineCharacteristics);
            }
          if (DosQueryProcAddr(hMod,0,"CloseProfile",(PFN *)&pfnCloseProfile) == NO_ERROR)
            hProfileInstance = pfnCloseProfile(hProfileInstance);
          DosFreeModule(hMod);
          }
        }
      WinPostMsg(hwnd,WM_QUIT,0L,0L);
      break;
    default:
      return WinDefWindowProc(hwnd,msg,mp1,mp2);
    }
  return(FALSE);
  }

VOID ComCommand(HWND hWnd,USHORT Command,THREAD *pstThd)
  {
  USHORT idDlg;
  USHORT usStatus;
  BYTE byStatus;
  PFNWP  pfnDlgProc;
  CONFIG *pCfg = &pstThd->stCfg;
  HMODULE hMod;
  CTL_DIALOG pfnDialog;

  switch (Command)
    {
    case IDM_EXIT:
      if (!pstThd->stThread.bStopThread)
        PauseThread(pstThd);
      WinPostMsg(hWnd,WM_CLOSE,0L,0L);
      return;
    case IDM_MANAGEPROFILE:
      if (hProfileInstance != NULL)
        if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
          {
          if (DosQueryProcAddr(hMod,0,"ManageProfile",(PFN *)&pfnManageProfile) == NO_ERROR)
            if (pfnManageProfile(hWnd,hProfileInstance))
              StartSystem(&stThisWindow,TRUE);
          DosFreeModule(hMod);
          }
      break;
    case IDM_FILTER:
      if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
        {
        if (DosQueryProcAddr(hMod,0,"HdwFilterDialog",(PFN *)&pfnDialog) == NO_ERROR)
          {
          stComCtl.hCom = pstThd->hCom;
          pfnDialog(hWnd,&stComCtl);
          }
        else
          MessageBox(hWnd,"COM control function \"HdwFilterDialog\" not found");
        DosFreeModule(hMod);
        }
      else
        MessageBox(hWnd,"Unable to load COM control library");
      return;
    case IDM_PROTO:
      if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
        {
        if (DosQueryProcAddr(hMod,0,"HdwProtocolDialog",(PFN *)&pfnDialog) == NO_ERROR)
          {
          stComCtl.hCom = pstThd->hCom;
          pfnDialog(hWnd,&stComCtl);
          }
        else
          MessageBox(hWnd,"COM control function \"HdwProtocolDialog\" not found");
        DosFreeModule(hMod);
        }
      else
        MessageBox(hWnd,"Unable to load COM control library");
      return;
    case IDM_BAUDRATE:
      if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
        {
        if (DosQueryProcAddr(hMod,0,"HdwBaudRateDialog",(PFN *)&pfnDialog) == NO_ERROR)
          {
          stComCtl.hCom = pstThd->hCom;
          pfnDialog(hWnd,&stComCtl);
          }
        else
          MessageBox(hWnd,"COM control function \"HdwBaudRateDialog\" not found");
        DosFreeModule(hMod);
        }
      else
        MessageBox(hWnd,"Unable to load COM control library");
      return;
    case IDM_FIFO:
      if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
        {
        stComCtl.hCom = pstThd->hCom;
        if (DosQueryProcAddr(hMod,0,"HdwFIFOsetupDialog",(PFN *)&pfnDialog) == NO_ERROR)
          pfnDialog(hWnd,&stComCtl);
        else
          MessageBox(hWnd,"COM control function \"HdwFIFOsetupDialog\" not found");
        DosFreeModule(hMod);
        }
      else
        MessageBox(hWnd,"Unable to load COM control library");
      return;
    case IDM_HANDSHAKE:
      if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
        {
        if (DosQueryProcAddr(hMod,0,"HdwHandshakeDialog",(PFN *)&pfnDialog) == NO_ERROR)
          {
          stComCtl.hCom = pstThd->hCom;
          pfnDialog(hWnd,&stComCtl);
          }
        else
          MessageBox(hWnd,"COM control function \"HdwHandshakeDialog\" not found");
        DosFreeModule(hMod);
        }
      else
        MessageBox(hWnd,"Unable to load COM control library");
      return;
    case IDM_TIMEOUT:
      if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
        {
        if (DosQueryProcAddr(hMod,0,"HdwTimeoutDialog",(PFN *)&pfnDialog) == NO_ERROR)
          {
          stComCtl.hCom = pstThd->hCom;
          pfnDialog(hWnd,&stComCtl);
          }
        else
          MessageBox(hWnd,"COM control function \"HdwTimeoutDialog\" not found");
        DosFreeModule(hMod);
        }
      else
        MessageBox(hWnd,"Unable to load COM control library");
      return;
    case IDM_SPAUSE:
      MenuItemCheck(hwndFrame,IDM_SSTART,FALSE);
      MenuItemCheck(hwndFrame,IDM_SPAUSE,TRUE);
      MenuItemEnable(hwndFrame,IDM_SSTART,TRUE);
      MenuItemEnable(hwndFrame,IDM_SPAUSE,FALSE);
      PauseThread(pstThd);
      stThisWindow.stCfg.bExecuting = FALSE;
      WinInvalidateRect(pstThd->hwndStatus,(PRECTL)NULL,FALSE);
      return;
    case IDM_SSTART:
      MenuItemCheck(hwndFrame,IDM_SSTART,TRUE);
      MenuItemCheck(hwndFrame,IDM_SPAUSE,FALSE);
      MenuItemEnable(hwndFrame,IDM_SSTART,FALSE);
      MenuItemEnable(hwndFrame,IDM_SPAUSE,TRUE);
      if (pstThd->stThread.idThread == 0)
        CreateThread(pstThd);
      else
        DosPostEventSem(hevRestartThreadSem);
      stThisWindow.stCfg.bExecuting = TRUE;
      WinInvalidateRect(pstThd->hwndStatus,(PRECTL)NULL,FALSE);
      return;
    case IDM_SSELECT:
      if (!pstThd->stThread.bStopThread)
        PauseThread(pstThd);
      idDlg = PS_DLG;
      pfnDlgProc = (PFNWP)fnwpPortSelectDlg;
#ifdef inc_CLP      
//      if (pCfg->wSimulateType == CLP_ACCESS)
        CLP_SerialInit(pstThd->hCom);
#endif        
      WinInvalidateRect(pstThd->hwndStatus,(PRECTL)NULL,FALSE);
      break;
    case IDM_ERRDISP:
      if (pCfg->bErrorOut)
        {
        pCfg->bErrorOut = FALSE;
        MenuItemCheck(hwndFrame,IDM_ERRDISP,FALSE);
        }
      else
        {
        pCfg->bErrorOut = TRUE;
        MenuItemCheck(hwndFrame,IDM_ERRDISP,TRUE);
        }
      WinInvalidateRect(pstThd->hwndStatus,(PRECTL)NULL,FALSE);
      break;
    case IDM_ANSI:
      if (pstThd->stCfg.bEnableAnsi)
        {
        pstThd->stCfg.bEnableAnsi = FALSE;
        MenuItemCheck(hwndFrame,IDM_ANSI,FALSE);
        VioSetAnsi (ANSI_OFF,pstThd->stVio.hpsVio);
        }
      else
        {
        pstThd->stCfg.bEnableAnsi = TRUE;
        MenuItemCheck(hwndFrame,IDM_ANSI,TRUE);
        VioSetAnsi (ANSI_ON,pstThd->stVio.hpsVio);
        }
      return;
    case IDM_CLRSCRN:
      ClearScreen(pstThd);
      return;
#ifdef inc_CLP      
    case IDM_CLP:
      idDlg      = DLG_OUTPUTCONTROL;
      pfnDlgProc = (PFNWP)fnwpSetCLP_LEDsDlg;
      break;
#endif      
    case IDM_STRING:
      idDlg      = PSTR_DLG;
      pfnDlgProc = (PFNWP)fnwpProcStringXferDlg;
      break;
    case IDM_COLORS:
      idDlg      = CLR_DLG;
      pfnDlgProc = (PFNWP)fnwpSetColorDlg;
      break;
    case IDM_TERMINAL:
      idDlg      = PTERM_DLG;
      pfnDlgProc = (PFNWP)fnwpProcTerminalDlg;
      break;
    case IDM_MTERMINAL:
      pCfg->wSimulateType = TERMINAL;
      MenuItemCheck(hwndFrame,IDM_MCLP,FALSE);
      MenuItemCheck(hwndFrame,IDM_MSTRING,FALSE);
      MenuItemCheck(hwndFrame,IDM_MTERMINAL,TRUE);
      if (pstThd->hCom != 0)
        MenuItemEnable(hwndFrame,IDM_SSTART,TRUE);
      return;
    case IDM_MSTRING:
      pCfg->wSimulateType = STRING_TRANSFER;
      MenuItemCheck(hwndFrame,IDM_MCLP,FALSE);
      MenuItemCheck(hwndFrame,IDM_MSTRING,TRUE);
      MenuItemCheck(hwndFrame,IDM_MTERMINAL,FALSE);
      if (pstThd->hCom != 0)
        MenuItemEnable(hwndFrame,IDM_SSTART,TRUE);
      return;
#ifdef inc_CLP      
    case IDM_MCLP:
      MenuItemCheck(hwndFrame,IDM_MCLP,TRUE);
      MenuItemCheck(hwndFrame,IDM_MSTRING,FALSE);
      MenuItemCheck(hwndFrame,IDM_MTERMINAL,FALSE);
      MenuItemEnable(hwndFrame,IDM_SSTART,FALSE);
      WinPostMsg(hwndCLP_Status,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      return;
#endif      
    case IDM_SENDBRK:
      if (!pstThd->bBreakOn)
        {
        MenuItemCheck(hwndFrame,IDM_SENDBRK,TRUE);
        pstThd->bBreakOn = TRUE;
        BreakOn(&stIOctlInst,pstThd->hCom,&usStatus);
        }
      else
        {
        MenuItemCheck(hwndFrame,IDM_SENDBRK,FALSE);
        pstThd->bBreakOn = FALSE;
        BreakOff(&stIOctlInst,pstThd->hCom,&usStatus);
        }
      WinInvalidateRect(pstThd->hwndStatus,(PRECTL)NULL,FALSE);
      return;
    case IDM_FXON:
      ForceXon(&stIOctlInst,pstThd->hCom);
      return;
    case IDM_FXOFF:
      ForceXoff(&stIOctlInst,pstThd->hCom);
      return;
    case IDM_SXON:
      SendXonXoff(pstThd,SEND_XOFF);
      return;
    case IDM_SXOFF:
      SendXonXoff(pstThd,SEND_XON);
      return;
    case IDM_FINPUT:
      FlushComBuffer(&stIOctlInst,pstThd->hCom,INPUT);
      return;
    case IDM_FOUTPUT:
      FlushComBuffer(&stIOctlInst,pstThd->hCom,OUTPUT);
      return;
    case IDM_FBOTH:
      FlushComBuffer(&stIOctlInst,pstThd->hCom,INPUT);
      FlushComBuffer(&stIOctlInst,pstThd->hCom,OUTPUT);
      return;
    default:
      return;
    }
  if (WinDlgBox(HWND_DESKTOP,hWnd,pfnDlgProc,NUL,idDlg,&stThisWindow))
    {
    if (idDlg == PTERM_DLG)
      {
      pCfg->wSimulateType = TERMINAL;
      MenuItemEnable(hwndFrame,IDM_MTERMINAL,TRUE);
      MenuItemCheck(hwndFrame,IDM_MTERMINAL,TRUE);
      MenuItemCheck(hwndFrame,IDM_MSTRING,FALSE);
      }
    else
      if (idDlg == PSTR_DLG)
        {
        pCfg->wSimulateType = STRING_TRANSFER;
        MenuItemEnable(hwndFrame,IDM_MSTRING,TRUE);
        MenuItemCheck(hwndFrame,IDM_MSTRING,TRUE);
        MenuItemCheck(hwndFrame,IDM_MTERMINAL,FALSE);
        }
    if (pstThd->hCom != 0)
      MenuItemEnable(hwndFrame,IDM_SSTART,TRUE);
    }
  WinInvalidateRect( hWnd, NUL, FALSE ); /* Update client area */
  }

VOID Help(HWND hwnd)
  {
  CHAR szCaption[100];

  WinQueryWindowText(hwnd,sizeof(szCaption),szCaption);
#ifdef this_junk
  if (pstThd->hCom)
    strcat(szCaption,pstThd->szPortName);
#endif

  WinMessageBox( HWND_DESKTOP,
                 WinQueryActiveWindow(HWND_DESKTOP),
                 (PSZ)szHelpMessage,
                 (PSZ)szCaption,
                 NUL,
                 MB_MOVEABLE | MB_OK | MB_CUANOTIFICATION);
  }

VOID PaintWindow( HWND hwnd, COLOR clr )
  {
  HPS    hps;
  RECTL  rcl;

  hps = WinBeginPaint( hwnd, (HPS)NULL, &rcl );

  /* If no color selected (that is, not R, G, or B),                */
  /* set window color to black.                                     */
  if( clr == CLR_BACKGROUND )
    clr = CLR_BLACK;
  else
    /* If all colors selected (R, G, and B),                        */
    /* set window color to white.                                   */
    if( clr == CLR_NEUTRAL )
      clr = CLR_WHITE;
  WinFillRect( hps, &rcl, clr );

  /* Draw a border,                                                 */
  /* of width given by unit width in device coordinates, multiplied */
  /* by system standard constants, and in system standard color.    */
  WinQueryWindowRect( hwnd, &rcl );
  WinDrawBorder( hps,
                 &rcl,
                 1L,
                 1L,
                 SYSCLR_WINDOWFRAME,
                 SYSCLR_WINDOWFRAME,
                 DB_STANDARD );
  WinEndPaint( hps );
  }

VOID CreateThread(THREAD *pstThd)
  {
  THREADCTRL *pThd = &pstThd->stThread;

  pThd->bStopThread = FALSE;
  DosCreateThread(&pThd->idThread,(PFNTHREAD)LoopThread,0,0,8192);
  }

VOID KillThread(THREAD *pstThd)
  {
  THREADCTRL *pThread = &pstThd->stThread;
  APIRET rc;
  ULONG ulPostCount;

  DosResetEventSem(hevKillThreadSem,&ulPostCount);
  DosResetEventSem(hevKillReadThreadSem,&ulPostCount);
  pThread->bStopThread = TRUE;
  if (pThread->idReadThread != 0)
    {
    DosPostEventSem(hevStartReadSem);
    if ((rc = DosWaitEventSem(hevKillReadThreadSem,1000)) != NO_ERROR)
      {
      if (rc == ERROR_SEM_TIMEOUT)
        ErrorNotify(pstThd,"Read thread semaphore timed out");
      else
        ErrorNotify(pstThd,"Read thread semaphore wierd");
      }
    else
      ErrorNotify(pstThd,"Read thread semaphore Cleared");
    }
  if (pThread->idThread != 0)
    {
    DosPostEventSem(hevStartWriteSem);
    DosPostEventSem(hevRestartThreadSem);
    if ((rc = DosWaitEventSem(hevKillThreadSem,1000)) != 0)
      {
      if (rc == ERROR_SEM_TIMEOUT)
        ErrorNotify(pstThd,"Loop thread semaphore timed out");
      else
        ErrorNotify(pstThd,"Loop thread semaphore wierd");
      }
    else
      ErrorNotify(pstThd,"Loop thread semaphore Cleared");
    }
  WinPostMsg(pstThd->hwndClient,UM_KILLTHREAD,0L,0L);
  }

VOID CreatePS(HWND hwnd,THREAD *pstThd)
  {
  VIOPS *pVio = &pstThd->stVio;

  pVio->hdcVio = WinOpenWindowDC(hwnd);

 /*************************************************************************/
 /* Create a NUMATTR+1 byte/cell Presentation Space.                      */
 /*************************************************************************/
  pVio->usPsWidth   = PSWIDTH;
  pVio->usPsDepth   = 38400 / (NUMATTR + 1 ) / PSWIDTH;

  VioCreatePS((PHVPS)&pVio->hpsVio,pVio->usPsDepth,pVio->usPsWidth,0,NUMATTR,(HVPS)0);
  VioAssociate(pVio->hdcVio,pVio->hpsVio);

 /*************************************************************************/
 /* Initialize Presentation Space global variables.                       */
 /*************************************************************************/
  VioGetDeviceCellSize(&pVio->stCell.cy,&pVio->stCell.cx,pVio->hpsVio);
  VioGetBuf((PULONG)&pVio->pVioBuf,&pVio->usVioBufLen,pVio->hpsVio);
  }

/**************************************************************************/
/* FRAMESUBPROC:                                                          */
/* The purpose of the frame window subclass procedure is to restrict      */
/* frame window sizing so that it is in step with the size of the AVIO    */
/* Presentation Space.                                                    */
/* Messages for the frame window are sent here first, so that             */
/* processing can be carried out should it be necessary to modify the     */
/* operation of the frame window.                                         */
/**************************************************************************/
MRESULT EXPENTRY  FrameSubProc(HWND hwnd,WORD msg,MPARAM mp1,MPARAM mp2 )
  {
  PTRACKINFO pTrack;
  RECTL      rclTrack;
  ORIG       Orig;
  THREAD *pstThd;
  VIOPS *pVio;

  pstThd = pstThread;
  pVio = &pstThd->stVio;
  switch( msg )
    {
    case WM_QUERYTRACKINFO:
        /******************************************************************/
        /* Invoke the normal frame window procedure first.                */
        /* This updates the tracking rectangle to the new position.       */
        /******************************************************************/
        (*pstThd->frameproc)( hwnd, msg, mp1, mp2 );
        pTrack = (PTRACKINFO)mp2;

         /**************************************************************/
         /* Only limit the bounding rectangle if the operation is      */
         /* SIZING. Moving continues as normal.                        */
         /**************************************************************/
        if((( pTrack->fs & TF_MOVE  ) != TF_MOVE ) &&
           (( pTrack->fs & TF_LEFT  ) ||
            ( pTrack->fs & TF_TOP   ) ||
            ( pTrack->fs & TF_RIGHT ) ||
            ( pTrack->fs & TF_BOTTOM ) ||
            ( pTrack->fs & TF_SETPOINTERPOS )))
            {

            WinQueryWindowRect(pstThd->hwndClient, &rclTrack );
            VioGetOrg( &Orig.y, &Orig.x,pVio->hpsVio);

            /**************************************************************/
            /* DefAvioWindow procedure keeps the origin set relative to   */
            /* the top left of the window, so moving the top border       */
            /* upwards reveals more of the Presentation Space.            */
            /**************************************************************/

            pTrack->rclBoundary.yBottom = rclTrack.yTop  - ((pVio->usPsDepth - Orig.y ) * pVio->stCell.cy);
            pTrack->rclBoundary.xRight  = rclTrack.xLeft + ((pVio->usPsWidth - Orig.x) * pVio->stCell.cx);
            pTrack->rclBoundary.yTop    = rclTrack.yTop  + ((pVio->usPsDepth - pVio->usWndDepth+1) * pVio->stCell.cy);
            pTrack->rclBoundary.xLeft   = rclTrack.xLeft - ((pVio->usPsWidth - pVio->usWndWidth ) * pVio->stCell.cx);

            /**************************************************************/
            /* Convert client boundary coordinates to screen coordinates. */
            /**************************************************************/
            WinMapWindowPoints(pstThd->hwndClient,HWND_DESKTOP,(PPOINTL)&pTrack->rclBoundary,2);

            /**************************************************************/
            /* Calculate the equivalent frame boundary from the client    */
            /* boundary data.                                             */
            /**************************************************************/
            WinCalcFrameRect(pstThd->hwndFrame, (PRECTL)&pTrack->rclBoundary, FALSE );
            pTrack->fs |= TF_ALLINBOUNDARY;

            /**************************************************************/
            /* Make sure that the window is only SIZED in character-sized */
            /* steps.                                                     */
            /**************************************************************/
            pTrack->cxGrid = pVio->stCell.cx;
            pTrack->cyGrid = pVio->stCell.cy;
            pTrack->cxKeyboard = pVio->stCell.cx;
            pTrack->cyKeyboard = pVio->stCell.cy;
            pTrack->fs |= TF_GRID;
            }
        else
            /**************************************************************/
            /* Any movement in the y-direction occurs, as usual, in pel   */
            /* units. Movement in the x-direction is in character-sized   */
            /* steps.                                                     */
            /**************************************************************/
            if( ( pTrack->fs & TF_MOVE ) == TF_MOVE )
                {
                pTrack->cxGrid = pVio->stCell.cx;
                pTrack->cyGrid = 1;
                pTrack->cxKeyboard = pVio->stCell.cx;
                pTrack->cyKeyboard = pVio->stCell.cy;
                pTrack->fs |= TF_GRID;
                }

        return(MRESULT)( TRUE );
    default:
        return( (*pstThd->frameproc)( hwnd, msg, mp1, mp2 ));
    }
  return( (MRESULT)NULL );
  }

/**************************************************************************/
/* WNDSIZE:                                                               */
/* This function positions the Presentation Space correctly within a      */
/* sized window.  It adjusts the origin when necessary, so that there     */
/* are no gaps between the edge of the Presentation Space and the window  */
/* border.                                                                */
/**************************************************************************/
BOOL WndSize(THREAD *pstThd,HWND hwnd,MPARAM mp2)
{
 ORIG    Orig;
 CURPOS  Cursor;
 VIOPS *pVio = &pstThd->stVio;

 WinSetWindowPos(pstThd->hwndStatus,
                  0,
                  0,
                  0,
                  LOUSHORT(mp2),
                  pVio->stCell.cy,
                  SWP_MOVE | SWP_SIZE);

  /************************************************************************/
  /* Set window width and depth, in AVIO units.                           */
  /************************************************************************/

  pVio->usWndDepth = HIUSHORT(mp2)/ pVio->stCell.cy-1;
  pVio->usWndWidth = LOUSHORT(mp2)/ pVio->stCell.cx;
  VioGetOrg(&Orig.y,&Orig.x,pVio->hpsVio);
  Orig.x = ((Orig.x + pVio->usWndWidth) > pVio->usPsWidth ) ? pVio->usPsWidth - pVio->usWndWidth : Orig.x;
  Orig.y = ((Orig.y + pVio->usWndDepth ) >= pVio->usPsDepth ) ? pVio->usPsDepth - pVio->usWndDepth-1 : Orig.y;
  VioSetOrg(Orig.y,Orig.x,pVio->hpsVio);

  /************************************************************************/
  /* The test below caters for the first instance of WM_SIZE that invokes */
  /* this function BEFORE window creation is complete and the Frame handle*/
  /* has been set.                                                        */
  /************************************************************************/

  pstThd->hwndFrame = (pstThd->hwndFrame != (HWND)NULL) ? pstThd->hwndFrame : WinQueryWindow(hwnd, QW_PARENT);
  WinSendMsg(WinWindowFromID(pstThd->hwndFrame,FID_VERTSCROLL)
           , SBM_SETSCROLLBAR
           , MPFROMSHORT(Orig.y)
           , MPFROM2SHORT(0, pVio->usPsDepth - pVio->usWndDepth));

  WinSendMsg(   WinWindowFromID(pstThd->hwndFrame,FID_HORZSCROLL)
              , SBM_SETTHUMBSIZE
              , MPFROM2SHORT(pVio->usWndWidth,pVio->usPsWidth)
              , (MPARAM)NULL );

  WinSendMsg(   WinWindowFromID(pstThd->hwndFrame,FID_VERTSCROLL)
              , SBM_SETTHUMBSIZE
              , MPFROM2SHORT(pVio->usWndDepth,pVio->usPsDepth)
              , (MPARAM)NULL);

  WinSendMsg( WinWindowFromID(pstThd->hwndFrame,FID_HORZSCROLL)
           , SBM_SETSCROLLBAR
           , MPFROMSHORT(Orig.x)
           , MPFROM2SHORT(0,pVio->usPsWidth - pVio->usWndWidth));

  /************************************************************************/
  /* Make sure that the cursor is always within the window.               */
  /************************************************************************/

  VioGetCurPos(&Cursor.y,&Cursor.x,pVio->hpsVio );
  Cursor.x = (Cursor.x > (Orig.x + pVio->usWndWidth-1) ) ? Orig.x + pVio->usWndWidth - 1 : Cursor.x;
  Cursor.x = (Cursor.x < Orig.x) ? Orig.x : Cursor.x;
  Cursor.y = (Cursor.y >= (Orig.y + pVio->usWndDepth)) ? Orig.y + pVio->usWndDepth - 1 : Cursor.y;
  Cursor.y = (Cursor.y < Orig.y) ? Orig.y : Cursor.y;
  VioSetCurPos(Cursor.y,Cursor.x,pVio->hpsVio );
  WinInvalidateRect(hwnd,(PRECTL)NULL,FALSE);
  return(TRUE);
}

/**************************************************************************/
/* SCROLL:                                                                */
/* The VIO scroll functions provided by the system cause scrolling        */
/* within the Presentation Space.  The SCROLL routine scrolls the         */
/* window relative to the Presentation Space.                             */
/**************************************************************************/
BOOL Scroll(THREAD *pstThd,SHORT sCx,SHORT sCy)
{
 ORIG   Origin;
 ORIG   OrigNew;
 CURPOS Cursor;
 CURPOS CurNew;
 CURPOS CurRelPos;         /* cursor vertical position relative to window */
 VIOPS *pVio = &pstThd->stVio;

 VioGetOrg(&Origin.y,&Origin.x,pVio->hpsVio);
#ifdef scroll_cur
 VioGetCurPos(&Cursor.y,&Cursor.x,pVio->hpsVio );

  /************************************************************************/
  /* Get relative position of cursor, so it can be restored after scroll. */
  /************************************************************************/

  CurRelPos.y = Cursor.y - Origin.y;
  CurRelPos.x = Cursor.x - Origin.x;
#endif
  // VERTICAL                                                             */
  if(sCy >= 0)
      // Downward (positive)                                              */
      OrigNew.y = (Origin.y + sCy + pVio->usWndDepth > pVio->usPsDepth - 1) ?
                   pVio->usPsDepth - pVio->usWndDepth - 1 : Origin.y + sCy;
  else
     // Upward (negative)                                                 */
      OrigNew.y = (Origin.y + sCy < 0 ) ? 0 : Origin.y + sCy;

  // HORIZONTAL                                                           */
  if(sCx >= 0)
      // Left (positive)                                                  */
      OrigNew.x = (Origin.x + sCx + pVio->usWndWidth > pVio->usPsWidth ) ?
                    pVio->usPsWidth - pVio->usWndWidth : Origin.x + sCx;
  else
      // Right (negative)                                                 */
      OrigNew.x = (Origin.x + sCx < 0) ? 0 : Origin.x + sCx;
  /************************************************************************/
  /* Set window origin & restore cursor relative to window if old cursor  */
  /* position would now be outside the window.                            */
  /************************************************************************/

  VioSetOrg(OrigNew.y,OrigNew.x,pVio->hpsVio);
#ifdef scroll_cur

  CurNew.x = (Cursor.x < OrigNew.x) ? OrigNew.x + CurRelPos.x : Cursor.x;
  CurNew.x = (Cursor.x >= OrigNew.x + pVio->usWndWidth ) ?  OrigNew.x + CurRelPos.x :
                                                                    CurNew.x ;
  CurNew.y = (Cursor.y < OrigNew.y)  ? OrigNew.y + CurRelPos.y : Cursor.y;
  CurNew.y = (Cursor.y >= OrigNew.y + pVio->usWndDepth ) ? OrigNew.y + CurRelPos.y :
                                                                   CurNew.y ;
#endif
  VioSetCurPos(CurNew.y,CurNew.x,pVio->hpsVio);

  /************************************************************************/
  /* Adjust the scroll-bar slider position.                               */
  /************************************************************************/

  WinSendMsg( WinWindowFromID(pstThd->hwndFrame,FID_VERTSCROLL),
              SBM_SETPOS,
              MPFROMLONG(OrigNew.y),
              MPFROMSHORT(0)
              );
  WinSendMsg( WinWindowFromID(pstThd->hwndFrame,FID_HORZSCROLL),
              SBM_SETPOS,
              MPFROMLONG(OrigNew.x),
              MPFROMSHORT(0)
              );

  WinInvalidateRect(pstThd->hwndClient,(PRECTL)NULL, FALSE);
  return( TRUE );
}

/**************************************************************************/
/* STATUSPROC:                                                            */
/* Window procedure for the one-line status window.                       */
/* This displays the current state (ON/OFF) of Insert, Reverse video,     */
/* Underline, and Printing.                                               */
/**************************************************************************/
MRESULT EXPENTRY StatusProc(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  HPS    hps;
  RECTL  rcl;
  POINTL ptl;
  THREAD *pstThd = pstThread;
  THREADCTRL *pThread = &pstThd->stThread;
  CHAR szMessage[20];
  BYTE byStatus;
  USHORT usStatus;
  USHORT usStringSize;
  USHORT usErrorCount;
  static USHORT usWriteErrorCount;
  static USHORT usReadErrorCount;

  switch ( msg )
     {
     case WM_ERASEBACKGROUND:
     /***************************************************************/
     /* The status window is cleared to SYSCLR_WINDOW.              */
     /***************************************************************/
        return(MRESULT)( TRUE );
     case WM_PAINT:
        hps = WinBeginPaint(hwnd,(HPS)NULL, &rcl );
        WinFillRect(hps,&rcl,(LONG)CLR_BROWN);

        GpiSetBackColor(hps,CLR_BROWN);
        GpiSetColor(hps,CLR_WHITE);
        GpiSetBackMix(hps,BM_OVERPAINT);

        ptl.y = 2L;
        ptl.x = 10L;
        if (pstThd->hCom)
          if(!pThread->bStopThread)
            GpiCharStringAt(hps,&ptl,7L,"Running");
          else
            GpiCharStringAt(hps,&ptl,7L,"Stopped");

          ptl.y = 2L;
          ptl.x = 80L;

        if (pstThd->stCfg.bErrorOut)
          {
          if (szErrorMessage[0] == 'R')
            {
            usErrorCount = usReadErrorCount++;
            usStringSize = 1;
            ptl.x = 70L;
            }
          else
            {
            usErrorCount = usWriteErrorCount++;
            ptl.x = 140L;
            usStringSize = strlen(szErrorMessage);
            }
          sprintf(&szErrorMessage[usStringSize]," - %u",usErrorCount);
          GpiCharStringAt(hps,&ptl,(LONG)strlen(szErrorMessage),szErrorMessage);
          szErrorMessage[usStringSize] = 0;
          }
        else
          {
          usReadErrorCount = 0;
          usWriteErrorCount = 0;
          GpiCharStringAt(hps,&ptl,20L,"Error Display is OFF");
          }

#ifdef this_junk
        ptl.y = 2L;
        ptl.x = 220L;
        if (pstThd->hCom)
          GetCOMstatus(pstThd,&byStatus);
        else
          byStatus = 0xff;
        sprintf(szMessage,"CS = %02X",byStatus);
        GpiCharStringAt(hps,&ptl,8L,szMessage);

        ptl.y = 2L;
        ptl.x = 320L;
        if (pstThd->hCom)
          GetCOMevent(pstThd,&wStatus);
        else
          wStatus = 0xffff;
        sprintf(szMessage,"CEv = %04X",wStatus);
        GpiCharStringAt(hps,&ptl,11L,szMessage);

        ptl.y = 2L;
        ptl.x = 420L;
        if (pstThd->hCom)
          GetCOMerror(pstThd,&wStatus);
        else
          wStatus = 0xffff;
        sprintf(szMessage,"CEr = %04X",wStatus);
        GpiCharStringAt(hps,&ptl,11L,szMessage);
#endif

         WinEndPaint( hps );
         break;

     default:
        return(WinDefWindowProc(hwnd, msg, mp1, mp2));
     }
 return( (MRESULT)NULL );
}
