#include <COMMON.H>
#include <safepage.h>

#include "QPG_CFG.H"

HMODULE hThisModule;

static char szSetupString[CCHMAXPATH + 100];

extern HWND hwndHelpInstance;

char szConfigFileSpec[CCHMAXPATH + 1];

#ifdef __BORLANDC__
ULONG _dllmain(ULONG ulTermCode,HMODULE hModule)
#else
ULONG _System _DLL_InitTerm(HMODULE hMod,ULONG ulTermCode)
#endif
  {
  if (ulTermCode ==0)
    hThisModule = hMod;
  return(TRUE);
  }


/*--------------------------------------------------------------------------*/
/*      Function: QPageInstall                                              */
/*                                                                          */
/*   Description: This dialog function displays the QuickPage Installation  */
/*                Notebook dialog box.                                      */
/*                                                                          */
/*          Date: Aug 02, 1995                                              */
/*                                                                          */
/*   Modified On: Aug 02, 1995                                              */
/*--------------------------------------------------------------------------*/
MRESULT EXPENTRY QPageInstall(HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2)
{

   HWND                  hwndNoteBook;
   HWND                  hwndSysMenu, hwndTop;
   ULONG                 ulPageId, ulFirstPage ;
   HPOINTER              hptrPrev, hptrWait ;
   RECTL                 rect;
   char                  szPageTitle[20], szWinTitle[25], szMsg[128];
   static HWND           hwndGlobal, hwndModem, hwndService, hwndPins ;
   static                xBkClient, yBkClient;
   static int            bProcess;
   static PAGEMSGINFO    pInfo;
//   static char           szConfigFileSpec[13];
   static PAGECFG *pstCFG;
   int fResult;


   hwndNoteBook = WinWindowFromID(hwnd, IDBK_INSTALL_NOTEBOOK);

   switch(msg)
   {
      case WM_INITDLG:
         pstCFG = (PAGECFG *)mp2;

         sprintf(szConfigFileSpec,"%s\\%s",pstCFG->pszDestPath,pstCFG->pszConfigFileName);
         memset(&pInfo, 0, sizeof(PAGEMSGINFO));
//         memset(&szConfigFileSpec, 0, sizeof(szConfigFileSpec));

         CenterWindow(hwnd, HWND_DESKTOP);

         //-----------------------------------------------------//
         // Set the clock pointer.                              //
         //-----------------------------------------------------//
         hptrPrev = WinQueryPointer(HWND_DESKTOP);
         hptrWait = WinQuerySysPointer(HWND_DESKTOP, SPTR_WAIT, FALSE);
         WinSetPointer(HWND_DESKTOP, hptrWait);

         //---------------------------------------------------//
         // Set Notebook Colors and Dimensions                //
         //---------------------------------------------------//

         WinSendMsg(hwndNoteBook, BKM_SETNOTEBOOKCOLORS,
                    MPFROMLONG(SYSCLR_DIALOGBACKGROUND),
                    MPFROMLONG(BKA_BACKGROUNDPAGECOLORINDEX));

         WinSendMsg(hwndNoteBook, BKM_SETNOTEBOOKCOLORS,
                    MPFROMLONG(SYSCLR_DIALOGBACKGROUND),
                    MPFROMLONG(BKA_BACKGROUNDMAJORCOLORINDEX));

         WinSendMsg(hwndNoteBook, BKM_SETDIMENSIONS,
                    MPFROM2SHORT(150, 25), (MPARAM)BKA_MAJORTAB);

         WinSendMsg(hwndNoteBook, BKM_SETDIMENSIONS,
                    MPFROM2SHORT(0, 0), (MPARAM)BKA_MINORTAB);

         //---------------------------------------------------//
         // Insert Page "Global Settings"                     //
         //---------------------------------------------------//

         memset(&szPageTitle, 0, sizeof(szPageTitle));
         strcpy(szPageTitle, "~Global Settings");

         ulPageId = (ULONG)WinSendMsg(hwndNoteBook, BKM_INSERTPAGE,(MPARAM)NULL,
                                      MPFROM2SHORT( BKA_MAJOR |
                                                    BKA_STATUSTEXTON,
                                                    BKA_LAST));

         WinSendMsg(hwndNoteBook, BKM_SETTABTEXT, (MPARAM)ulPageId,
                    MPFROMP(szPageTitle));

         WinSendMsg(hwndNoteBook, BKM_SETSTATUSLINETEXT, (MPARAM)ulPageId,
                    MPFROMP(szPageTitle+1));

         hwndGlobal = 
         WinLoadDlg(hwnd,
                    hwndNoteBook,
                    DlgGlobalSet,
                    hThisModule,
                    ID_DLG_GLOBAL_SETTINGS,
                    (PVOID)&pInfo);

         WinSetWindowPos( hwndGlobal, HWND_TOP, 0, 0, 0, 0, SWP_MOVE);

         WinSendMsg(hwndNoteBook, BKM_SETPAGEWINDOWHWND,
                    MPFROMLONG(ulPageId),
                    MPFROMHWND(hwndGlobal));


         //---------------------------------------------------//
         // Insert Page "Modem Settings"                      //
         //---------------------------------------------------//

         memset(&szPageTitle, 0, sizeof(szPageTitle));
         strcpy(szPageTitle, "~Modem Definition");

         ulPageId = (ULONG)WinSendMsg(hwndNoteBook, BKM_INSERTPAGE,(MPARAM)NULL,
                                      MPFROM2SHORT( BKA_MAJOR |
                                                    BKA_STATUSTEXTON,
                                                    BKA_LAST));

         WinSendMsg(hwndNoteBook, BKM_SETTABTEXT, (MPARAM)ulPageId,
                    MPFROMP(szPageTitle));

         WinSendMsg(hwndNoteBook, BKM_SETSTATUSLINETEXT, (MPARAM)ulPageId,
                    MPFROMP(szPageTitle+1));

         hwndModem =
         WinLoadDlg(hwnd,
                    hwndNoteBook,
                    DlgModemSet,
                    hThisModule,
                    ID_DLG_MODEM_SETTINGS,
                    (PVOID)&pInfo);

         WinSetWindowPos( hwndModem, HWND_TOP, 0, 0, 0, 0, SWP_MOVE);

         WinSendMsg(hwndNoteBook, BKM_SETPAGEWINDOWHWND,
                    MPFROMLONG(ulPageId),
                    MPFROMHWND(hwndModem));


         //---------------------------------------------------//
         // Insert Page "Paging Service"                      //
         //---------------------------------------------------//

         memset(&szPageTitle, 0, sizeof(szPageTitle));
         strcpy(szPageTitle, "~Paging Service");

         ulPageId = (ULONG)WinSendMsg(hwndNoteBook, BKM_INSERTPAGE,(MPARAM)NULL,
                                      MPFROM2SHORT( BKA_MAJOR |
                                                    BKA_STATUSTEXTON,
                                                    BKA_LAST));

         WinSendMsg(hwndNoteBook, BKM_SETTABTEXT, (MPARAM)ulPageId,
                    MPFROMP(szPageTitle));

         WinSendMsg(hwndNoteBook, BKM_SETSTATUSLINETEXT, (MPARAM)ulPageId,
                    MPFROMP(szPageTitle+1));

         hwndService =
         WinLoadDlg(hwnd,
                    hwndNoteBook,
                    DlgServiceSet,
                    hThisModule,
                    ID_DLG_SERVICES,
                    (PVOID)&pInfo);

         WinSetWindowPos( hwndService, HWND_TOP, 0, 0, 0, 0, SWP_MOVE);

         WinSendMsg(hwndNoteBook, BKM_SETPAGEWINDOWHWND,
                    MPFROMLONG(ulPageId),
                    MPFROMHWND(hwndService));


         //---------------------------------------------------//
         // Insert Page "PIN Definitions"                     //
         //---------------------------------------------------//

         memset(&szPageTitle, 0, sizeof(szPageTitle));
         strcpy(szPageTitle, "~PIN Definitions");

         ulPageId = (ULONG)WinSendMsg(hwndNoteBook, BKM_INSERTPAGE,(MPARAM)NULL,
                                      MPFROM2SHORT( BKA_MAJOR |
                                                    BKA_STATUSTEXTON,
                                                    BKA_LAST));

         WinSendMsg(hwndNoteBook, BKM_SETTABTEXT, (MPARAM)ulPageId,
                    MPFROMP(szPageTitle));

         WinSendMsg(hwndNoteBook, BKM_SETSTATUSLINETEXT, (MPARAM)ulPageId,
                    MPFROMP(szPageTitle+1));

         hwndPins =
         WinLoadDlg(hwnd,
                    hwndNoteBook,
                    DlgPinsList,
                    hThisModule,
                    ID_DLG_DEFINE_PIN,
                    (PVOID)&pInfo);

         WinSetWindowPos( hwndPins, HWND_TOP, 0, 0, 0, 0, SWP_MOVE);

         WinSendMsg(hwndNoteBook, BKM_SETPAGEWINDOWHWND,
                    MPFROMLONG(ulPageId),
                    MPFROMHWND(hwndPins));

         WinSendMsg(hwndNoteBook,
                    BKM_TURNTOPAGE,
                    (MPARAM)ulFirstPage,
                    (MPARAM)0L);

#ifdef this_junk
         hwndHelpInstance = hThisModule;

         //-----------------------------------------------------//
         // Create the help instance                            //
         //-----------------------------------------------------//
         CreateHelpInstance(hwnd, ID_APPLICATION, ID_HELP_FILE);

         //-----------------------------------------------------//
         // If the help file is not available, disable HELP     //
         //-----------------------------------------------------//
         if(!hwndHelpInstance)
         {
            MessageBox("Cannot Load Help File",
                       MB_ERROR | MB_OK | MB_SYSTEMMODAL);
            WinEnableControl (hwnd, IDBTN_HELP, FALSE);
         }
#endif
         WinSetPointer(HWND_DESKTOP, hptrPrev);

         WinPostMsg(hwnd, WM_CONFIG_FILE, 0, 0);

         return MRFROMSHORT(FALSE);


      case WM_CONFIG_FILE:


         WinDlgBox(HWND_DESKTOP,
                   hwnd,
                   (PFNWP)DlgFileName,
                   hThisModule,
                   ID_DLG_CONFIG_FILE,
                   (PVOID)&szConfigFileSpec);

         hwndTop = WinQueryWindow(HWND_DESKTOP, QW_TOP);
         WinSetFocus(HWND_DESKTOP, hwndTop);

         ulFirstPage = (ULONG)
         WinSendMsg(hwndNoteBook,
                    BKM_QUERYPAGEID,
                    (MPARAM)0L,
                     MPFROM2SHORT(BKA_TOP, BKA_MAJOR));

         WinSendMsg(hwndNoteBook,
                    BKM_TURNTOPAGE,
                    (MPARAM)ulFirstPage,
                    (MPARAM)0L);

         return MRFROMSHORT(FALSE);


      case WM_PAINT:


         WinQueryWindowRect(hwnd, &rect);

         WinSetWindowPos( hwndNoteBook,
                          HWND_TOP,
                          rect.xLeft+4,
                          rect.yBottom+95,
                          rect.xRight-15,
                          rect.yTop-120,
                          SWP_MOVE | SWP_SIZE);
         break;




      case WM_COMMAND:

         switch (SHORT1FROMMP(mp1))
         {
            /*------------------------------------------------*/
            /* Close the dialog when the OK button is pressed */
            /*------------------------------------------------*/
            case DID_OK:

               hptrPrev = WinQueryPointer(HWND_DESKTOP);
               hptrWait = WinQuerySysPointer(HWND_DESKTOP, SPTR_WAIT, FALSE);
               WinSetPointer(HWND_DESKTOP, hptrWait);

               if((BOOL)WinSendMsg(hwndGlobal,
                  WM_COLLECT_INFO, 0, 0) == TRUE &&

                  (BOOL)WinSendMsg(hwndModem,
                  WM_COLLECT_INFO, 0, 0) == TRUE &&

                  (BOOL)WinSendMsg(hwndService,
                  WM_COLLECT_INFO, 0, 0) == TRUE &&

                  (BOOL)WinSendMsg(hwndPins,
                  WM_COLLECT_INFO, 0, 0) == TRUE )

                 {
                 if ((fResult = CreateConfigFile( szConfigFileSpec, &pInfo )) != FILE_ERROR)
                   {
                   if (fResult != NO_FILE)
                     {
#ifdef this_junk
                     if (fResult == NEW_FILE)
                       {
                        iEnd = sprintf(szSetupString,"%sEXENAME=%s\\%s;STARTUPDIR=%s;NODROP=YES;PARAMETERS=% /MSG:\"[Message: ]\" /CFG:\"PAGER.PAG\"",szProgramObjectSetup,szDestSpec,szPagerEXEname,szDestSpec);
                        if (strlen(pstInst->paszStrings[APPICONFILE]) != 0)
                          sprintf(&szSetupString[iEnd],";ICON=%s\\%s",pstInst->pszAppsPath,pstInst->paszStrings[APPICONFILE]);
                        strcpy(szObjectName,pstInst->paszStrings[CONFIGAPPNAME]);
                        hObject = WinCreateObject("WPProgram",szObjectName,szSetupString,szFolderID,CO_UPDATEIFEXISTS);
                        if (hObject != 0)
                          {
                          if (pstInst->pAnyData != NULL)
                            {
                            pstInst->byItemCount = 1;
                            phObject = (HOBJECT *)pstInst->pAnyData;
                            *phObject = hObject;
                            PrfWriteProfileData(HINI_USERPROFILE,pstInst->paszStrings[CONFIGAPPNAME],"WPSobject",&hObject,sizeof(HOBJECT));
                            }
                          itoa(++iObjectCount,&szFileNumber[iEnd],10);
                          PrfWriteProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,sizeof(HOBJECT));
                          }
                       }
#endif
                     sprintf(szMsg,
                             "%s Configuration Successfully Created.\n\n"
                             "Do You Want To Create Another One?",
                             szConfigFileSpec);
                     if(MessageBox(szMsg,
                                   MB_YESNO | MB_INFORMATION |
                                   MB_SYSTEMMODAL) != MBID_YES)
                       WinPostMsg(hwnd, WM_CLOSE, 0, 0);
                     }
                   }
                 else
                   {
                   sprintf(szMsg, "Error Creating %s", szConfigFileSpec);
                   MessageBox(szMsg, MB_ERROR | MB_CANCEL | MB_SYSTEMMODAL);
                   }
                 }
               else
                 {
                 sprintf(szMsg, "Error Collecting Information");
                 MessageBox(szMsg, MB_ERROR | MB_CANCEL | MB_SYSTEMMODAL);
                 }
               break;



            case IDBTN_INSTALL_FILENAME:

               WinPostMsg(hwnd, WM_CONFIG_FILE, 0, 0);
               break;



            case DID_CANCEL:

               WinPostMsg(hwnd, WM_CLOSE, 0, 0);
               break;



            case IDBTN_HELP:

              if((LONG)WinSendMsg(hwndHelpInstance,HM_HELP_CONTENTS,(MPARAM)0L,(MPARAM)0L))
                 MessageBox("Unable To Process Help Request", MB_ERROR | MB_OK | MB_SYSTEMMODAL);


               return MRFROMSHORT(FALSE);



         }
         return MRFROMSHORT(FALSE);



      case WM_CLOSE:

         WinDestroyHelpInstance(hwndHelpInstance);
         WinDismissDlg(hwnd, TRUE);
         break;


      default:
         return(WinDefDlgProc(hwnd, msg, mp1, mp2));

   }
   return(WinDefDlgProc(hwnd, msg, mp1, mp2));
}
//--------------------------------------------------------------------------//
// End QPageInstall Procedure                                               //
//--------------------------------------------------------------------------//


/*--------------------------------------------------------------------------*/
/*      Function: DlgFileName                                               */
/*                                                                          */
/*   Description: This dialog function displays the "Configuration File     */
/*                Name" notebook page dialog box.                           */
/*                                                                          */
/*          Date: Aug 01, 1995                                              */
/*                                                                          */
/*--------------------------------------------------------------------------*/
MRESULT EXPENTRY DlgFileName(  HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2)
{
//   char         szBuffer[13], szTmpBuff[13] ;
   static char  *szFile;
//   int          Index, bInvalidChar ;

   switch(msg)
   {
      case WM_INITDLG:

         szFile = (char *)mp2;

         WinSendDlgItemMsg(hwnd,
                           IDFLD_CONFIG_NAME,
                           EM_SETTEXTLIMIT,
                   (MPARAM)CCHMAXPATH,
                           MPVOID);

         if(szFile[0] == 0)
            strcpy(szFile, "PAGERDEF.PAG");

         WinSetDlgItemText(hwnd,
                           IDFLD_CONFIG_NAME,
                           (PSZ)szFile);

         WinSendDlgItemMsg(hwnd,
                           IDFLD_CONFIG_NAME,
                           EM_SETSEL,
                           MPFROM2SHORT(0, 256),
                           (MPARAM)NULL);

         CenterWindow(hwnd, HWND_DESKTOP);

         return MRFROMSHORT(FALSE);

#ifdef this_junk

      case WM_CONTROL:

         memset(&szBuffer,  0, sizeof(szBuffer));
         memset(&szTmpBuff, 0, sizeof(szTmpBuff));

         switch (SHORT1FROMMP(mp1))
         {
            //----------------------------------------------------------//
            // Validate fields.                                         //
            //----------------------------------------------------------//
            case IDFLD_CONFIG_NAME:
            {
               switch ((USHORT) SHORT2FROMMP(mp1))
               {
                  case EN_CHANGE:
                  {
                     WinQueryDlgItemText(hwnd, SHORT1FROMMP(mp1),
                                         sizeof(szTmpBuff), (PSZ)szTmpBuff);

                     if (strlen(szTmpBuff) > 0)
                     {
                        bInvalidChar = FALSE;
                        for (Index = 0; Index < strlen(szTmpBuff);
                             ++Index)
                        {
                           if (!isalpha(szTmpBuff[Index]))
                           {
                              if(szTmpBuff[Index] != '.')
                                 bInvalidChar = TRUE;
                              else
                                 strncat(szBuffer, szTmpBuff+Index, 1);
                           }
                           else
                              strncat(szBuffer, szTmpBuff+Index, 1);
                        }

                        if (bInvalidChar)
                           WinSetDlgItemText(hwnd, SHORT1FROMMP(mp1),
                                             (PSZ)szBuffer);

                     }
                  }
               }
            }
         }

         WinQueryDlgItemText(hwnd, IDFLD_CONFIG_NAME,
                             sizeof(szBuffer),
                             (PSZ)szBuffer);

         if(strlen(szBuffer) != 0)
            WinEnableControl(hwnd, DID_OK, TRUE);
         else
            WinEnableControl(hwnd, DID_OK, FALSE);

         break;

#endif

      case WM_COMMAND:

         switch (SHORT1FROMMP(mp1))
         {
            /*------------------------------------------------*/
            /* Close the dialog when the OK button is pressed */
            /*------------------------------------------------*/
            case DID_OK:

               WinQueryDlgItemText(hwnd, IDFLD_CONFIG_NAME,
                                   CCHMAXPATH,
                                   (PSZ)szFile);

               WinDismissDlg(hwnd, TRUE);
               break;

         }
         break;


      default:
         return(WinDefDlgProc(hwnd, msg, mp1, mp2));
   }
   return(WinDefDlgProc(hwnd, msg, mp1, mp2));
}
/*--------------------------------------------------------------------------*/
/* End DlgFileName Function                                                 */
/*--------------------------------------------------------------------------*/


#ifdef this_junk


/*--------------------------------------------------------------------------*/
/*        Method: CreateHelpInstance                                        */
/*                                                                          */
/*   Description: This method creates a Help Instance to communicate with   */
/*                the help manager.                                         */
/*                                                                          */
/*          Date: Aug 01, 1995                                              */
/*                                                                          */
/*   Modified On: Aug 01, 1995                                              */
/*--------------------------------------------------------------------------*/
BOOL CreateHelpInstance(HWND hwndMainFrame, PSZ ApplicationName, PSZ HelpFile)
{

   HELPINIT    hini;
   CHAR        ApplName[60];

   strcpy(ApplName, ApplicationName);
   strcat(ApplName, " Help");

   /*----------------------------------------------------------*/
   /* Initialize help init structure                           */
   /*----------------------------------------------------------*/
   hini.cb                       = sizeof(HELPINIT);
   hini.ulReturnCode             = 0;
   hini.pszTutorialName          = (PSZ)NULL;
   hini.phtHelpTable             = (PHELPTABLE)MAKELONG(INSTALL_HELP_TABLE, 0xFFFF);
   hini.hmodHelpTableModule      = 0;
   hini.hmodAccelActionBarModule = 0;
   hini.idAccelTable             = 0;
   hini.idActionBar              = 0;
   hini.pszHelpWindowTitle       = ApplName;
   hini.pszHelpLibraryName       = HelpFile;


   /*----------------------------------------------------------*/
   /* Create help instance                                     */
   /*----------------------------------------------------------*/
   hwndHelpInstance = WinCreateHelpInstance(WinQueryAnchorBlock(hwndMainFrame),
                                                  &hini);

   if(hwndHelpInstance == 0L || hini.ulReturnCode)
      return FALSE;
   else
   {
      /*----------------------------------------------------------*/
      /* Associate help instance with object window               */
      /*----------------------------------------------------------*/
      if(!WinAssociateHelpInstance(hwndHelpInstance, hwndMainFrame))
         return FALSE;
   }
   return ( TRUE );
}
//--------------------------------------------------------------------------//
// End CreateHelpInstance Function                                          //
//--------------------------------------------------------------------------//
#endif
static BOOL bQuickPageSetupInUse = FALSE;

APIRET APIENTRY InstallQuickPage(PAGECFG *pstCFG)
  {
  BOOL bSuccess;

  if (bQuickPageSetupInUse)
    {
    MessageBox("QuickPage Configuration process is being accessed by another process.\n\nTry again later.",(MB_OK | MB_ERROR));
    return(FALSE);
    }
  bQuickPageSetupInUse = TRUE;
  HelpInit(pstCFG);
  bSuccess = WinDlgBox(HWND_DESKTOP,pstCFG->hwndFrame,(PFNWP)QPageInstall,hThisModule,ID_DLG_INSTALL,(MPARAM)pstCFG);

  DestroyHelpInstance(pstCFG);
  bQuickPageSetupInUse = FALSE;
  return(bSuccess);
  }

