#ifdef this_junk
  stSD.Length = sizeof(STARTDATA);
  stSD.Related = SSF_RELATED_CHILD;
  stSD.FgBg = SSF_FGBG_FORE;
  stSD.TraceOpt = SSF_TRACEOPT_NONE;
  stSD.PgmTitle = szEXEtitle;
  stSD.TermQ = szTermQueue;
  stSD.Environment = 0;
  stSD.InheritOpt = SSF_INHERTOPT_PARENT;
  stSD.SessionType = SSF_TYPE_DEFAULT;
  stSD.IconFile = 0;
  stSD.PgmHandle = 0;
  stSD.PgmControl = SSF_CONTROL_INVISIBLE;
  stSD.ObjectBuffer = 0;
  stSD.ObjectBuffLen = 0;
#endif


#ifdef this_junk
    case UM_CONFIG_COMPLETE:
      bRespondToQueue = TRUE;
//      MemFree(pszCurrentDriverSpec);
      bShowingProgress = FALSE;
      if (mp1)
        {
        sprintf(szCaption,"COMi configuration is complete.");
        sprintf(szMessage,"You must shut down your system to activate COMi serial access.");
        WinMessageBox(HWND_DESKTOP,
                      hwndFrame,
                      szMessage,
                      szCaption,
                      HLPP_MB_CONFIG_OK,
                     (MB_OK | MB_HELP | MB_INFORMATION));
        sprintf(szBannerTwo,"Installation is complete");
        szBannerOne[0] = 0;
        ClientPaint(hwndClient);
        if (strlen(szInfoFileName) != 0)
           WinDlgBox(HWND_DESKTOP,
                    hwnd,
             (PFNWP)fnwpInfoDlgProc,
               (LONG)NULL,
                    INST_MSG,
               (LONG)NULL);
        }
      else
        {
        sprintf(szCaption,"COMi configuration is not complete.");
        sprintf(szMessage,"You must select the \"Setup | %s...\" menu item again to complete COMi installation.",szConfigName);
        WinMessageBox(HWND_DESKTOP,
                      hwndFrame,
                      szMessage,
                      szCaption,
                      HLPP_MB_CONFIG_BAD,
                     (MB_OK | MB_HELP | MB_WARNING));
        sprintf(szBannerTwo,"Installation is not complete");
        szBannerOne[0] = 0;
        ClientPaint(hwndClient);
        }
      break;
#endif


#ifdef this_junk
    case IDM_INSTALL:
      stSD.PgmName = (PSZ)pszConfigProgram;
      MemAlloc(&pszConfigCmdLine,(strlen(pszConfigArgs) + strlen(szTermQueue) + 10));
      stSD.PgmInputs = (PSZ)pszConfigCmdLine;
      iLen = sprintf((PSZ)pszConfigCmdLine,"%s /Q%s",pszConfigArgs,szTermQueue);
      pszConfigCmdLine[iLen++] = 0;
      pszConfigCmdLine[iLen] = 0;
      sprintf(szBannerOne,"Please wait");
      sprintf(szBannerTwo,"Configuration program loading");
      ClientPaint(hwndClient);
      bShowingProgress = TRUE;
      DosCreateThread(&tidInstallThread,(PFNTHREAD)InstallThread,0l,0L,4096);
      return;
#endif

#ifdef this_junk
char szCurrentLIBPATH[1024];

void APIENTRY InstallThread(void)
  {
  PID pidSession;
  ULONG ulSessionID;
  int iLen;
  HQUEUE hTermQueue;
  BYTE byPriority = 0;
  BOOL bInstallSuccess = FALSE;
  char szMessage[80];
  APIRET rc;
  REQUESTDATA stRequestData;
  WORD wData;
  ULONG ulDataLen = 2;
  HPOINTER hPointer;


  if (DosCreateQueue(&hTermQueue,(QUE_FIFO | QUE_NOCONVERT_ADDRESS),szTermQueue) == NO_ERROR)
    {
//    if (strlen(pszDLLpath) != 0)
//      {
//      DosQueryExtLIBPATH(szCurrentLIBPATH,BEGIN_LIBPATH);
//      DosSetExtLIBPATH(pszDLLpath,BEGIN_LIBPATH);
//      }
    DosStartSession(&stSD,&ulSessionID,&pidSession);
    DosReadQueue(hTermQueue,(PREQUESTDATA)&stRequestData,&ulDataLen,(PVOID)&wData,0,DCWW_WAIT,&byPriority,0);
    DosStopSession(STOP_SESSION_SPECIFIED,ulSessionID);
    bInstallSuccess = stRequestData.ulData;
    DosCloseQueue(hTermQueue);
//    if (strlen(szCurrentLIBPATH) != 0)
//      DosSetExtLIBPATH(szCurrentLIBPATH,BEGIN_LIBPATH);
    }
  WinPostMsg(hwndClient,UM_CONFIG_COMPLETE,(MPARAM)bInstallSuccess,0L);
//  DosExit(EXIT_THREAD,0);
  }

#endif
