#include "COMMON.H"
#include "UTILITY.H"
#include "help.h"
#include "install.h"
#include "config.h"

#include "resource.h"

extern char szDDname[];

extern COMICFG stCOMiCFG;

extern ULONG ulLibsSize;
extern ULONG ulPDRsize;
extern ULONG ulCOMiSize;
extern ULONG ulPagerSize;
extern ULONG ulUtilSize;
extern ULONG ulCOMscopeSize;
extern ULONG ulInstallSize;

extern BOOL bItemOneLocked;
extern BOOL bItemTwoLocked;
extern BOOL bItemThreeLocked;
extern BOOL bItemFourLocked;
extern BOOL bItemFiveLocked;

extern BOOL bInstallDemo;
extern BOOL bCOMscopeToInstall;
extern BOOL bCOMiToInstall;
extern BOOL bPagerToInstall;
extern BOOL bInstallToInstall;
extern BOOL bUtilToInstall;
extern BOOL bPDRtoInstall;
extern BOOL bLibrariesToInstall;
extern BOOL bObjectsToCreate;

extern const char szIniFileName[];
extern char *pszPath;

extern char szCheckOneCaption[];
extern char szCheckTwoCaption[];
extern char szCheckThreeCaption[];
extern char szCheckFourCaption[];
extern char szCheckFiveCaption[];

extern char szConfigDDname[];
extern char szBannerOne[];
extern char szBannerTwo[];
//extern HWND hwndClient;
extern char *pszUninstallIniPath;

UNINST stUninstall;

//extern char *pszInstallIniPath;
extern char szInfoFileName[];
extern char szInfoCaption[];

extern BOOL bCOMiInstalled;

VOID ClientPaint(HWND hwnd);
BOOL CreatePath(char *pszPath);
ULONG CalcSizeSetCaption(void);

extern INSTALL stInst;

MRESULT EXPENTRY fnwpTransferDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  int iLastChar;
  char szSize[80];
  ULONG cbDataSize;

  switch (msg)
    {
    case WM_INITDLG:
      CenterWindow(hwndDlg);
      if (strlen(szCheckOneCaption) != 0)
        WinSetDlgItemText(hwndDlg,TRAN_ONE,szCheckOneCaption);
      if (strlen(szCheckTwoCaption) != 0)
        WinSetDlgItemText(hwndDlg,TRAN_TWO,szCheckTwoCaption);
      if (strlen(szCheckThreeCaption) != 0)
        WinSetDlgItemText(hwndDlg,TRAN_THREE,szCheckThreeCaption);
      if (strlen(szCheckFourCaption) != 0)
        WinSetDlgItemText(hwndDlg,TRAN_FOUR,szCheckFourCaption);
      if (strlen(szCheckFiveCaption) != 0)
        WinSetDlgItemText(hwndDlg,TRAN_FIVE,szCheckFiveCaption);
      if (bObjectsToCreate)
        {
        if (stInst.bCreateObjects)
          CheckButton(hwndDlg,TRAN_CREATEOBJ,TRUE);
        }
      else
        ControlEnable(hwndDlg,TRAN_CREATEOBJ,FALSE);
      WinSendDlgItemMsg(hwndDlg,TRAN_APPS,EM_SETTEXTLIMIT,MPFROMSHORT(stInst.ulMaxPathLen - 40),(MPARAM)NULL);
      WinSetDlgItemText(hwndDlg,TRAN_APPS,stInst.pszAppsPath);
      if (bLibrariesToInstall)
        {
        WinSendDlgItemMsg(hwndDlg,TRAN_DLL,EM_SETTEXTLIMIT,MPFROMSHORT(stInst.ulMaxPathLen - 40),(MPARAM)NULL);
        WinSetDlgItemText(hwndDlg,TRAN_DLL,stInst.pszDLLpath);
        }
      else
        {
        ControlEnable(hwndDlg,TRAN_DLL,FALSE);
        ControlEnable(hwndDlg,TRAN_DLLT,FALSE);
        }
      if (stInst.bCopyCOMi || bItemOneLocked)
        CheckButton(hwndDlg,TRAN_ONE,TRUE);
      sprintf(szSize,"%u bytes",ulCOMiSize);
      WinSetDlgItemText(hwndDlg,TRAN_ONESIZE,szSize);
      if (!bCOMscopeToInstall)
        {
        ControlEnable(hwndDlg,TRAN_TWO,FALSE);
        ControlEnable(hwndDlg,TRAN_TWOSIZE,FALSE);
        }
      else
        {
        if (stInst.bCopyCOMscope || bItemTwoLocked)
          CheckButton(hwndDlg,TRAN_TWO,TRUE);
        sprintf(szSize,"%u bytes",ulCOMscopeSize);
        WinSetDlgItemText(hwndDlg,TRAN_TWOSIZE,szSize);
        }
      if (!bPagerToInstall)
        {
        if (!bPDRtoInstall)
          {
          ControlEnable(hwndDlg,TRAN_THREE,FALSE);
          ControlEnable(hwndDlg,TRAN_THREESIZE,FALSE);
          }
        }
      else
        {
        if (stInst.bCopyPager || bItemThreeLocked)
          CheckButton(hwndDlg,TRAN_THREE,TRUE);
        sprintf(szSize,"%u bytes",ulPagerSize);
        WinSetDlgItemText(hwndDlg,TRAN_THREESIZE,szSize);
        }
      if (!bPDRtoInstall)
        {
        if (!bPagerToInstall)
          {
          ControlEnable(hwndDlg,TRAN_THREE,FALSE);
          ControlEnable(hwndDlg,TRAN_THREESIZE,FALSE);
          }
        }
      else
        {
        if (stInst.bCopyPDR || bItemThreeLocked)
          CheckButton(hwndDlg,TRAN_THREE,TRUE);
        sprintf(szSize,"%u bytes",ulPDRsize);
        WinSetDlgItemText(hwndDlg,TRAN_THREESIZE,szSize);
        }
      if (bUtilToInstall || bItemFourLocked)
        {
        if (stInst.bCopyUtil)
          CheckButton(hwndDlg,TRAN_FOUR,TRUE);
        sprintf(szSize,"%u bytes",ulUtilSize);
        WinSetDlgItemText(hwndDlg,TRAN_FOURSIZE,szSize);
        }
      else
        {
        ControlEnable(hwndDlg,TRAN_FOUR,FALSE);
        ControlEnable(hwndDlg,TRAN_FOURSIZE,FALSE);
        }
      if (!bInstallDemo)
        {
        if (stInst.bCopyInstall || bItemFiveLocked)
          CheckButton(hwndDlg,TRAN_FIVE,TRUE);
        sprintf(szSize,"%u bytes",ulInstallSize);
        WinSetDlgItemText(hwndDlg,TRAN_FIVESIZE,szSize);
        }
      else
        {
        ControlEnable(hwndDlg,TRAN_FIVE,FALSE);
        ControlEnable(hwndDlg,TRAN_FIVESIZE,FALSE);
        }
      sprintf(szSize,"%u bytes",CalcSizeSetCaption());
      WinSetDlgItemText(hwndDlg,TRAN_SPACE,szSize);
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_HELP:
          DisplayHelpPanel(HLPP_OPTION_DLG);
           return((MRESULT)FALSE);
        case DID_OK:
          if (bObjectsToCreate)
            stInst.bCreateObjects = Checked(hwndDlg,TRAN_CREATEOBJ);
          WinQueryDlgItemText(hwndDlg,TRAN_APPS,(stInst.ulMaxPathLen - 40),pszPath);
          iLastChar = (strlen(pszPath) - 1);
          if (pszPath[iLastChar] == '\\')
            pszPath[iLastChar] = 0;
          strcpy(stInst.pszAppsPath,pszPath);
          if (bLibrariesToInstall)
            {
            WinQueryDlgItemText(hwndDlg,TRAN_DLL,(stInst.ulMaxPathLen - 40),pszPath);
            iLastChar = (strlen(pszPath) - 1);
            if (pszPath[iLastChar] == '\\')
              pszPath[iLastChar] = 0;
            strcpy(stInst.pszDLLpath,pszPath);
            stInst.bCopyLibraries = TRUE;
            }
          else
            stInst.bCopyLibraries = FALSE;
          sprintf(stCOMiCFG.pszDriverIniSpec,"%s\\%s",stInst.pszAppsPath,szDDname);
          AppendINI(stCOMiCFG.pszDriverIniSpec);
          MenuItemEnable(stInst.hwndFrame,IDM_SETUP,FALSE);
          MenuItemEnable(stInst.hwndFrame,IDM_TRANSFER,TRUE);
          WinDismissDlg(hwndDlg,TRUE);
          break;
        case DID_CANCEL:
          WinDismissDlg(hwndDlg,FALSE);
          break;
        default:
          return WinDefDlgProc(hwndDlg,msg,mp1,mp2);
        }
      break;
    case WM_CONTROL:
      if ((SHORT2FROMMP(mp1) == BN_CLICKED))// && bAllowClick)
        {
        switch (SHORT1FROMMP(mp1))
          {
          case TRAN_ONE:
            if (!bItemOneLocked)
              {
              if (Checked(hwndDlg,TRAN_ONE))
                stInst.bCopyCOMi = FALSE;
              else
                stInst.bCopyCOMi = TRUE;
              CheckButton(hwndDlg,TRAN_ONE,stInst.bCopyCOMi);
              sprintf(szSize,"%u bytes",CalcSizeSetCaption());
              WinSetDlgItemText(hwndDlg,TRAN_SPACE,szSize);
              }
            break;
          case TRAN_TWO:
            if (!bItemTwoLocked)
              {
              if (Checked(hwndDlg,TRAN_TWO))
                stInst.bCopyCOMscope = FALSE;
              else
                stInst.bCopyCOMscope = TRUE;
              CheckButton(hwndDlg,TRAN_TWO,stInst.bCopyCOMscope);
              sprintf(szSize,"%u bytes",CalcSizeSetCaption());
              WinSetDlgItemText(hwndDlg,TRAN_SPACE,szSize);
              }
            break;
          case TRAN_THREE:
            if (!bItemThreeLocked)
              {
              if (Checked(hwndDlg,TRAN_THREE))
                {
                stInst.bCopyPDR = FALSE;
                stInst.bCopyPager = FALSE;
                }
              else
                {
                stInst.bCopyPDR = TRUE;
                stInst.bCopyPager = TRUE;
                }
              CheckButton(hwndDlg,TRAN_THREE,stInst.bCopyPDR);
              sprintf(szSize,"%u bytes",CalcSizeSetCaption());
              WinSetDlgItemText(hwndDlg,TRAN_SPACE,szSize);
              }
            break;
          case TRAN_FOUR:
            if (!bItemFourLocked)
              {
              if (Checked(hwndDlg,TRAN_FOUR))
                stInst.bCopyUtil = FALSE;
              else
                stInst.bCopyUtil = TRUE;
              CheckButton(hwndDlg,TRAN_FOUR,stInst.bCopyUtil);
              sprintf(szSize,"%u bytes",CalcSizeSetCaption());
              WinSetDlgItemText(hwndDlg,TRAN_SPACE,szSize);
              }
            break;
          case TRAN_FIVE:
            if (!bItemFiveLocked)
              {
              if (Checked(hwndDlg,TRAN_FIVE))
                stInst.bCopyInstall = FALSE;
              else
                stInst.bCopyInstall = TRUE;
              CheckButton(hwndDlg,TRAN_FIVE,stInst.bCopyInstall);
              sprintf(szSize,"%u bytes",CalcSizeSetCaption());
              WinSetDlgItemText(hwndDlg,TRAN_SPACE,szSize);
              }
            break;
          }
        }
      break;
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return(FALSE);
  }

ULONG CalcSizeSetCaption(void)
  {
  ULONG ulSize = 0;

  if (stInst.bCopyCOMscope)
    ulSize += ulCOMscopeSize;
  if (stInst.bCopyInstall)
    ulSize += ulInstallSize;
  if (stInst.bCopyPDR)
    ulSize += ulPDRsize;
  if (stInst.bCopyPager)
    ulSize += ulPagerSize;
  if (stInst.bCopyCOMi)
    ulSize += ulCOMiSize;
  if (stInst.bCopyUtil)
    ulSize += ulUtilSize;
  if (stInst.bCopyPDR || stInst.bCopyInstall || stInst.bCopyCOMscope)
    ulSize += ulLibsSize;
  return(ulSize);
  }

MRESULT EXPENTRY fnwpInfoDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  int iLastChar;
  IPT ipt = 0;
  ULONG ulStatus;
  INFODLG *pstInfoDlg;
  FILESTATUS3 stFileInfo;
  char szMessage[100];
  char *pszFileSpec;
  char *pInfoBuffer;
  ULONG ulCount;
  APIRET rc;
  HFILE hFile;

  switch (msg)
    {
    case WM_INITDLG:
      CenterWindow(hwndDlg);
      pstInfoDlg = PVOIDFROMMP(mp2);
      pszFileSpec = 0;
      MemAlloc(&pszFileSpec,(strlen(stInst.pszSourcePath) + strlen(pstInfoDlg->pszFileName) + 4));
      if (pszFileSpec == NULL)
        {
        WinDismissDlg(hwndDlg,TRUE);
        return(FALSE);
        }
      WinSetWindowText(hwndDlg,pstInfoDlg->pszCaption);
      sprintf(pszFileSpec,"%s\\%s",stInst.pszSourcePath,pstInfoDlg->pszFileName);
      if ((rc = DosOpen(pszFileSpec,&hFile,&ulStatus,0L,0,1,0x0040,(PEAOP2)0L)) != 0)
        {
        sprintf(szMessage,"Could not open %s - Error = %u",pszFileSpec,rc);
        MemFree(pszFileSpec);
        MessageBox(stInst.hwndFrame,szMessage);
        WinDismissDlg(hwndDlg,TRUE);
        return(FALSE);
        }
      DosQueryFileInfo(hFile,1,&stFileInfo,sizeof(FILESTATUS3));
      ulCount = stFileInfo.cbFile;
      if ((rc = DosAllocMem((PVOID)&pInfoBuffer,(ulCount + 10),(PAG_COMMIT | PAG_READ | PAG_WRITE))) != NO_ERROR)
        {
        sprintf(szMessage,"Unable to Allocate memory to read %s - %u",pszFileSpec,rc);
        MessageBox(stInst.hwndFrame,szMessage);
        MemFree(pszFileSpec);
        DosClose(hFile);
        WinDismissDlg(hwndDlg,TRUE);
        return(FALSE);
        }
      MemFree(pszFileSpec);
      if (DosRead(hFile,(PVOID)pInfoBuffer,ulCount,&ulCount) != 0)
        {
        DosFreeMem(pInfoBuffer);
        DosClose(hFile);
        WinDismissDlg(hwndDlg,TRUE);
        return(FALSE);
        }
      DosClose(hFile);
      if (pInfoBuffer[ulCount - 1] == '\x1a')
        {
        ulCount--;
        pInfoBuffer[ulCount] = 0;
        }
      WinSendDlgItemMsg(hwndDlg,INST_INFO_MLE,MLM_SETIMPORTEXPORT,(MPARAM)pInfoBuffer,(MPARAM)ulCount);
      WinSendDlgItemMsg(hwndDlg,INST_INFO_MLE,MLM_IMPORT,(MPARAM)&ipt,(MPARAM)ulCount);
      DosFreeMem(pInfoBuffer);
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_CONTINUE:
        case DID_OK:
          WinDismissDlg(hwndDlg,TRUE);
          break;
        case DID_ABORT:
        case DID_CANCEL:
          WinDismissDlg(hwndDlg,FALSE);
          break;
        default:
          return WinDefDlgProc(hwndDlg,msg,mp1,mp2);
        }
      break;
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return(FALSE);
  }

MRESULT EXPENTRY fnwpUninstallDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  HMODULE hMod;
  PFN pfnUninstall;
  char szCaption[60];
  char szMessage[100];
  APIRET rc;

  switch (msg)
    {
    case WM_INITDLG:
      CenterWindow(hwndDlg);
      if (stInst.paszStrings[CURRENTDRIVERSPEC])
        CheckButton(hwndDlg,UNINST_REUSE_INI,TRUE);
      else
        {
        ControlEnable(hwndDlg,UNINST_REUSE_INI,FALSE);
        ControlEnable(hwndDlg,UNINST_SAVE_INI,FALSE);
        ControlEnable(hwndDlg,UNINST_DELETE_INI,FALSE);
        }
      CheckButton(hwndDlg,UNINST_REM_OBJ,TRUE);
      CheckButton(hwndDlg,UNINST_REM_DIR,TRUE);
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_HELP:
          DisplayHelpPanel(HLPP_UNINSTALL_DLG);
           return((MRESULT)FALSE);
        case DID_OK:
          memset(&stUninstall,0,sizeof(UNINST));
          if (Checked(hwndDlg,UNINST_REUSE_INI))
            stUninstall.fCurrentIni = UNINSTALL_REUSE_INI;
          else
            if (Checked(hwndDlg,UNINST_SAVE_INI))
              stUninstall.fCurrentIni = UNINSTALL_SAVE_INI;
            else
              if (Checked(hwndDlg,UNINST_SAVE_INI))
                stUninstall.fCurrentIni = UNINSTALL_DEL_INI;
          if (Checked(hwndDlg,UNINST_REM_DIR))
            stUninstall.bDirs = TRUE;
          if (Checked(hwndDlg,UNINST_REM_ALL))
            stUninstall.fObjects = UNINSTALL_FOLDERS;
          else
            if (Checked(hwndDlg,UNINST_REM_OBJ))
              stUninstall.fObjects = UNINSTALL_OBJ_ONLY;
            else
              if (Checked(hwndDlg,UNINST_NO_OBJ))
                stUninstall.fObjects = UNINSTALL_NO_OBJ;
          WinDismissDlg(hwndDlg,TRUE);
          if ((rc = DosLoadModule(0,0,stInst.paszStrings[XFERLIBRARYSPEC],&hMod)) == NO_ERROR)
            {
            if ((rc = DosQueryProcAddr(hMod,0,"Uninstall",(PFN *)&pfnUninstall)) == NO_ERROR)
              {
              stUninstall.pszConfigDDname = szConfigDDname;
              stUninstall.pszPath = pszPath;
              stUninstall.pszBannerOne = szBannerOne;
              stUninstall.pszBannerTwo = szBannerTwo;
              stUninstall.pszUninstallIniPath = pszUninstallIniPath;
              stUninstall.pstInst = &stInst;
              stUninstall.pfnPrintProgress = (PFN)PrintUninstallProgress;
              pfnUninstall(hwndDlg,&stUninstall);
              }
            else
              {
              szBannerOne[0] = 0;
              sprintf(szBannerTwo,"Uninstall library function does not exist.");
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
          break;
        case DID_CANCEL:
          WinDismissDlg(hwndDlg,FALSE);
          break;
        default:
          return WinDefDlgProc(hwndDlg,msg,mp1,mp2);
        }
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return(FALSE);
  }



