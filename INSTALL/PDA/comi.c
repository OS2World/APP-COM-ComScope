#include "COMMON.H"
#include "utility.h"
#include "CONFIG.H"
#include "help.h"
#include "p:\install\install.h"

#include "p:\install\resource.h"


void ClearReadOnly(char szFileSpec[]);
BOOL CopyFile(char *szSourceSpec,char *szDestSpec);
USHORT CompareFileDate(char szSourceFileSpec[],char szDestFileSpec[]);
BOOL DisplayCopyError(char szSource[],char szDest[],APIRET rcErrorCode);

char szFolderName[60] = "OS/tools\r\nUtilities";
char szFolderSetup[] = "OBJECTID=<OS/tools_1833>";
char szFolderID[] = "<OS/tools_1833>";
char szProgramObjectSetup[] = "NOAUTOCLOSE=NO;PROGTYPE=PM;";
char szINFobjectSetup[] = "DEFAULTVIEW=RUNNING;NOPRINT=YES;PROGTYPE=PM;";
char szCOMscopeEXEname[40];
char szInstallEXEname[40];
char szCOMiINFname[40];
char szSetupString[CCHMAXPATH];
char szPDRpath[CCHMAXPATH];
BOOL bLibsDirCreated = FALSE;
char szFileKey[20];
char szMessage[80];
char szCaption[40];
char szDestSpec[CCHMAXPATH];
char szSourceSpec[CCHMAXPATH];
char szFileName[80];
char szInstalledIniPath[CCHMAXPATH];
BOOL bLibrariesRequired = FALSE;
BOOL bWinCOMObject = FALSE;
FILESTATUS3 stFileStatus;
ULONG ulInstalledFileStart;
ULONG ulInstalledObjectStart;
ULONG ulAttr;
char szPath[CCHMAXPATH];

char szFileNumber[40];

//void pfnPrintProgress(char szFrom[],char szTo[]);

#ifdef this_junk
HMODULE hThisModule;

#ifdef __BORLANDC__
ULONG _dllmain(ULONG ulTermCode,HMODULE hModule)
#else
ULONG _System _DLL_InitTerm(HMODULE hMod,ULONG ulTermCode)
#endif
  {
  if (ulTermCode == 0)
    hThisModule = hMod;
  }
#endif

BOOL APIENTRY InstallCOMi(INSTALL *pstInst)
  {
  int iIndex;
  int iCountPos;
  int iDestPathEnd;
  int iSourcePathEnd;
  APIRET rc;
  BOOL bSuccess = TRUE;
  HPOINTER hPointer;
  int iLen;
  int iFileCount;
  int iObjectCount;
  int iEnd;
  HOBJECT hObject;
  BOOL bObjectBad;
  unsigned int uiAttrib;
  ULONG ulFileCount;
  ULONG cbDataSize = sizeof(ULONG);
  HINI hInstalledProfile;
  HINI hSourceProfile;

  hSourceProfile = PrfOpenProfile(pstInst->hab,pstInst->pszSourceIniPath);
  iEnd = sprintf(szFileNumber,"File_");
  strcpy(szDestSpec,pstInst->pszAppsPath);
  iDestPathEnd = strlen(szDestSpec);
  szDestSpec[iDestPathEnd++] = '\\';
  szDestSpec[iDestPathEnd] = 0;
  hPointer = WinQuerySysPointer(HWND_DESKTOP,SPTR_WAIT,FALSE);
  WinSetPointer(HWND_DESKTOP,hPointer);

  strcpy(szSourceSpec,pstInst->pszSourcePath);
  iSourcePathEnd = strlen(szSourceSpec);
  szSourceSpec[iSourcePathEnd++] = '\\';

  szCOMscopeEXEname[0] = 0;
  szInstallEXEname[0] = 0;

  sprintf(szInstalledIniPath,"%s%s",szDestSpec,pstInst->paszStrings[UNINSTALLINIFILENAME]);
  if (!MakePath(pstInst->hwndFrame,pstInst->pszAppsPath))
   return(FALSE);
  hInstalledProfile = PrfOpenProfile(pstInst->hab,szInstalledIniPath);
  cbDataSize = sizeof(ULONG);
  if (!PrfQueryProfileData(hInstalledProfile,"Installed","Files",&iFileCount,&cbDataSize))
    iFileCount = 0;
  sprintf(szPath,"%c:\\DELLOCKS.CMD",pstInst->chBootDrive);
  DosForceDelete(szPath);
  if (pstInst->bCopyCOMi)
    {
    strcpy(szDestSpec,pstInst->pszAppsPath);
    iDestPathEnd = strlen(szDestSpec);
    szDestSpec[iDestPathEnd++] = '\\';
    szDestSpec[iDestPathEnd] = 0;
    sprintf(pstInst->paszStrings[DRIVERINISPEC],"%s\\%s",pstInst->pszAppsPath,pstInst->paszStrings[DDNAME]);
    if (strlen(pstInst->paszStrings[CURRENTDRIVERSPEC]) != 0)
      {
      if (strcmp(pstInst->paszStrings[CURRENTDRIVERSPEC],pstInst->paszStrings[DRIVERINISPEC]) != 0)
        {
        strcpy(szPath,pstInst->paszStrings[DDNAME]);
        AppendINI(szPath);
        sprintf(szFileName,"Existing %s",szPath);
        if (pstInst->paszStrings[REMOVEOLDDRIVERSPEC] != NULL)
          strcpy(pstInst->paszStrings[REMOVEOLDDRIVERSPEC],pstInst->paszStrings[CURRENTDRIVERSPEC]);
        AppendINI(pstInst->paszStrings[DRIVERINISPEC]);
        AppendINI(pstInst->paszStrings[CURRENTDRIVERSPEC]);
        pstInst->pfnPrintProgress(szFileName,pstInst->paszStrings[DRIVERINISPEC]);
        if (pstInst->bSavedDriverIniFile)
          {
          sprintf(pstInst->paszStrings[CURRENTDRIVERSPEC],"%c:\\COMDDINI.OLD",pstInst->chBootDrive);
          DosCopy(pstInst->paszStrings[CURRENTDRIVERSPEC],pstInst->paszStrings[DRIVERINISPEC],DCPY_EXISTING);
          pstInst->bSavedDriverIniFile = FALSE;
          if (pstInst->fCurrentIni != UNINSTALL_SAVE_INI)
            DosDelete(pstInst->paszStrings[CURRENTDRIVERSPEC]);
          }
        else
          if (DosCopy(pstInst->paszStrings[CURRENTDRIVERSPEC],pstInst->paszStrings[DRIVERINISPEC],DCPY_EXISTING) != NO_ERROR)
            {
            sprintf(pstInst->paszStrings[CURRENTDRIVERSPEC],"%c:\\COMDDINI.OLD",pstInst->chBootDrive);
            DosCopy(pstInst->paszStrings[CURRENTDRIVERSPEC],pstInst->paszStrings[DRIVERINISPEC],DCPY_EXISTING);
            DosForceDelete(pstInst->paszStrings[CURRENTDRIVERSPEC]);
            }
        }
      else
        {
        rc = DosQueryPathInfo(pstInst->paszStrings[CURRENTDRIVERSPEC],1,&stFileStatus,sizeof(FILESTATUS3));
        if ((rc == ERROR_PATH_NOT_FOUND) || (rc == ERROR_FILE_NOT_FOUND))
          {
          sprintf(pstInst->paszStrings[CURRENTDRIVERSPEC],"%c:\\COMDDINI.OLD",pstInst->chBootDrive);
          DosCopy(pstInst->paszStrings[CURRENTDRIVERSPEC],pstInst->paszStrings[DRIVERINISPEC],DCPY_EXISTING);
          DosForceDelete(pstInst->paszStrings[CURRENTDRIVERSPEC]);
          }
        }
      }
    else
      {
      AppendINI(pstInst->paszStrings[DRIVERINISPEC]);
      rc = DosQueryPathInfo(pstInst->paszStrings[DRIVERINISPEC],1,&stFileStatus,sizeof(FILESTATUS3));
      if ((rc == ERROR_PATH_NOT_FOUND) || (rc == ERROR_FILE_NOT_FOUND))
        {
        sprintf(szPath,"%c:\\COMDDINI.OLD",pstInst->chBootDrive);
        DosCopy(szPath,pstInst->paszStrings[DRIVERINISPEC],DCPY_EXISTING);
        DosForceDelete(szPath);
        }
      }
    AppendINI(pstInst->paszStrings[DRIVERINISPEC]);
    sprintf(&szDestSpec[iDestPathEnd],"%s",pstInst->paszStrings[DDNAME]);
    sprintf(&szSourceSpec[iSourcePathEnd],"%s",pstInst->paszStrings[DDNAME]);
    pstInst->pfnPrintProgress(pstInst->paszStrings[DDNAME],szDestSpec);
    if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
      {
      bSuccess = FALSE;
      if (!DisplayCopyError(pstInst->paszStrings[DDNAME],szDestSpec,rc))
        goto gtFreePathMem;
      }
    ClearReadOnly(szDestSpec);
    itoa(++iFileCount,&szFileNumber[iEnd],10);
    PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
    AppendINI(szSourceSpec);
    if (DosQueryPathInfo(szSourceSpec,FIL_STANDARD,&stFileStatus,sizeof(FILESTATUS3)) == NO_ERROR)
      {
      AppendINI(szDestSpec);
      strcpy(szPath,pstInst->paszStrings[DDNAME]);
      AppendINI(szPath);
      pstInst->pfnPrintProgress(szPath,szDestSpec);
      DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING);
      ClearReadOnly(szDestSpec);
      itoa(++iFileCount,&szFileNumber[iEnd],10);
      PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
      }
    strcpy(szFileKey,"File_");
    iCountPos = strlen(szFileKey);
    ulFileCount = 0;
    PrfQueryProfileData(hSourceProfile,"COMi","Files",&ulFileCount,&cbDataSize);
    for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
      {
      itoa(iIndex,&szFileKey[iCountPos],10);
      if (PrfQueryProfileString(hSourceProfile,"COMi",szFileKey,0,szFileName,18) != 0)
        {
        if (iIndex == 1)
          strcpy(szCOMiINFname,szFileName);
#ifdef this_junk
        if (iIndex == 2)
          strcpy(szConfigEXEname,szFileName);
#endif
        strcpy(&szDestSpec[iDestPathEnd],szFileName);
        strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
        pstInst->pfnPrintProgress(szFileName,szDestSpec);
        if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
          {
          bSuccess = FALSE;
          if (!DisplayCopyError(szFileName,szDestSpec,rc))
            goto gtFreePathMem;
          }
        ClearReadOnly(szDestSpec);
        itoa(++iFileCount,&szFileNumber[iEnd],10);
        PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
        }
      }
    MenuItemEnable(pstInst->hwndFrame,IDM_SETUP,TRUE);
    /*
    ** This entry must be placed here so the the Configuration DLL can "find" the
    ** COMi initialization file, before the device driver is actually loaded.
    */
    PrfWriteProfileString(HINI_USERPROFILE,pstInst->paszStrings[CONFIGDDNAME],"Initialization",pstInst->paszStrings[DRIVERINISPEC]);
    PrfWriteProfileString(HINI_USERPROFILE,pstInst->paszStrings[CONFIGDDNAME],"Version",pstInst->paszStrings[COMIVERSION]);
    }
  if (pstInst->bCopyPDR)
    {
    strcpy(szFileKey,"File_");
    iCountPos = strlen(szFileKey);
    sprintf(szDestSpec,"%c:\\OS2\\DLL",pstInst->chBootDrive);
    strcpy(szPDRpath,szDestSpec);
    iDestPathEnd = strlen(szDestSpec);
    szDestSpec[iDestPathEnd++] = '\\';
    szDestSpec[iDestPathEnd] = 0;
    ulFileCount = 0;
    PrfQueryProfileData(hSourceProfile,"PDR","Files",&ulFileCount,&cbDataSize);
    for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
      {
      itoa(iIndex,&szFileKey[iCountPos],10);
      strcpy(&szDestSpec[iDestPathEnd],szFileName);
      if (PrfQueryProfileString(hSourceProfile,"PDR",szFileKey,0,szFileName,18) != 0)
        {
        strcpy(&szDestSpec[iDestPathEnd],szFileName);
        strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
        pstInst->pfnPrintProgress(szFileName,szDestSpec);
        if ((rc = DosCopy(szSourceSpec,szDestSpec,0L)) != NO_ERROR)
          {
          switch (CompareFileDate(szSourceSpec,szDestSpec))
            {
            case MBID_YES:
              if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
                {
                bSuccess = FALSE;
                if (!DisplayCopyError(szFileName,szDestSpec,rc))
                  goto gtFreePathMem;
                }
              break;
            case MBID_NO:
              continue;
            case MBID_CANCEL:
              bSuccess = FALSE;
              goto gtFreePathMem;

            }
          }
        ClearReadOnly(szDestSpec);
        itoa(++iFileCount,&szFileNumber[iEnd],10);
        PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
        }
      if (bSuccess)
        pstInst->bBaseLibrariesCopied = TRUE;
      }
    if (PrfQueryProfileString(hSourceProfile,"PDR","PDR Library",0,szFileName,18) != 0)
      {
//      strcpy(pstInst->paszStrings[PDRLIBRARYNAME],szFileName);
      strcpy(&szDestSpec[iDestPathEnd],szFileName);
      PrfWriteProfileString(HINI_USERPROFILE,"COMi","Spooler",szDestSpec);
      strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
      pstInst->pfnPrintProgress(szFileName,szDestSpec);
      if ((rc = DosCopy(szSourceSpec,szDestSpec,0L)) != NO_ERROR)
        {
        switch (CompareFileDate(szSourceSpec,szDestSpec))
          {
          case MBID_YES:
            if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
              {
              bSuccess = FALSE;
              if (!DisplayCopyError(szFileName,szDestSpec,rc))
                goto gtFreePathMem;
              }
            break;
          case MBID_NO:
            break;
          case MBID_CANCEL:
            bSuccess = FALSE;
            goto gtFreePathMem;

          }
        }
      ClearReadOnly(szDestSpec);
      itoa(++iFileCount,&szFileNumber[iEnd],10);
      PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
      }
    }
  if (pstInst->bCopyCOMscope)
    {
    bLibrariesRequired = TRUE;
    szCOMscopeEXEname[0] = 0;
    strcpy(szDestSpec,pstInst->pszAppsPath);
    iDestPathEnd = strlen(szDestSpec);
    szDestSpec[iDestPathEnd++] = '\\';
    szDestSpec[iDestPathEnd] = 0;
    strcpy(szFileKey,"File_");
    iCountPos = strlen(szFileKey);
    ulFileCount = 0;
    PrfQueryProfileData(hSourceProfile,"COMscope","Files",&ulFileCount,&cbDataSize);
    for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
      {
      itoa(iIndex,&szFileKey[iCountPos],10);
      if (PrfQueryProfileString(hSourceProfile,"COMscope",szFileKey,0,szFileName,18) != 0)
        {
        if (iIndex == 1)
          strcpy(szCOMscopeEXEname,szFileName);
        strcpy(&szDestSpec[iDestPathEnd],szFileName);
        strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
        pstInst->pfnPrintProgress(szFileName,szDestSpec);
        if (!CopyFile(szSourceSpec,szDestSpec))
          {
          bSuccess = FALSE;
          if (!DisplayCopyError(szFileName,szDestSpec,rc))
            goto gtFreePathMem;
          }
        itoa(++iFileCount,&szFileNumber[iEnd],10);
        PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
        }
      }
    }
  if (pstInst->bCopyUtil)
    {
    strcpy(szDestSpec,pstInst->pszAppsPath);
    iDestPathEnd = strlen(szDestSpec);
    szDestSpec[iDestPathEnd++] = '\\';
    szDestSpec[iDestPathEnd] = 0;
    strcpy(szFileKey,"File_");
    iCountPos = strlen(szFileKey);
    ulFileCount = 0;
    PrfQueryProfileData(hSourceProfile,"Utilities","Files",&ulFileCount,&cbDataSize);
    for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
      {
      itoa(iIndex,&szFileKey[iCountPos],10);
      if (PrfQueryProfileString(hSourceProfile,"Utilities",szFileKey,0,szFileName,18) != 0)
        {
        strcpy(&szDestSpec[iDestPathEnd],szFileName);
        strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
        pstInst->pfnPrintProgress(szFileName,szDestSpec);
        if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
          {
          bSuccess = FALSE;
          if (!DisplayCopyError(szFileName,szDestSpec,rc))
            goto gtFreePathMem;
          }
        if (stricmp(szFileName, "WINCOM.EXE") == 0)
          {
          bLibrariesRequired = TRUE;
          bWinCOMObject = TRUE;
          }
        ClearReadOnly(szDestSpec);
        itoa(++iFileCount,&szFileNumber[iEnd],10);
        PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
        }
      }
    }
  if (pstInst->bCopyInstall)
    {
    bLibrariesRequired = TRUE;
    szInstallEXEname[0] = 0;
    strcpy(szDestSpec,pstInst->pszAppsPath);
    iDestPathEnd = strlen(szDestSpec);
    szDestSpec[iDestPathEnd++] = '\\';
    szDestSpec[iDestPathEnd] = 0;
    sprintf(&szDestSpec[iDestPathEnd],pstInst->paszStrings[INIFILENAME]);
    strcpy(&szSourceSpec[iSourcePathEnd],pstInst->paszStrings[INIFILENAME]);
    PrfCloseProfile(hSourceProfile);
    DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING);
    ClearReadOnly(szDestSpec);
    hSourceProfile = PrfOpenProfile(pstInst->hab,pstInst->pszSourceIniPath);
    itoa(++iFileCount,&szFileNumber[iEnd],10);
    PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
    strcpy(szFileKey,"File_");
    iCountPos = strlen(szFileKey);
    ulFileCount = 0;
    PrfQueryProfileData(hSourceProfile,"Install","Files",&ulFileCount,&cbDataSize);
    for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
      {
      itoa(iIndex,&szFileKey[iCountPos],10);
      if (PrfQueryProfileString(hSourceProfile,"Install",szFileKey,0,szFileName,18) != 0)
        {
        if (iIndex == 1)
          strcpy(szInstallEXEname,szFileName);
        strcpy(&szDestSpec[iDestPathEnd],szFileName);
        strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
        pstInst->pfnPrintProgress(szFileName,szDestSpec);
        if (!CopyFile(szSourceSpec,szDestSpec))
          {
//          bSuccess = FALSE;
          if (!DisplayCopyError(szFileName,szDestSpec,rc))
            goto gtFreePathMem;
          }
        itoa(++iFileCount,&szFileNumber[iEnd],10);
        PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
        }
      }
    }
  if (bLibrariesRequired && (pstInst->bCopyLibraries) && (pstInst->pszDLLpath != NULL))
    {
    if (!bLibsDirCreated)
      if (!MakePath(pstInst->hwndFrame,pstInst->pszDLLpath))
        return(FALSE);
    bLibsDirCreated = TRUE;
    strcpy(szDestSpec,pstInst->pszDLLpath);
    iDestPathEnd = strlen(szDestSpec);
    szDestSpec[iDestPathEnd++] = '\\';
    szDestSpec[iDestPathEnd] = 0;
    strcpy(szFileKey,"File_");
    iCountPos = strlen(szFileKey);
    ulFileCount = 0;
    PrfQueryProfileData(hSourceProfile,"Libraries","Files",&ulFileCount,&cbDataSize);
    for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
      {
      itoa(iIndex,&szFileKey[iCountPos],10);
      if (PrfQueryProfileString(hSourceProfile,"Libraries",szFileKey,0,szFileName,18) != 0)
        {
        strcpy(&szDestSpec[iDestPathEnd],szFileName);
        strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
        pstInst->pfnPrintProgress(szFileName,szDestSpec);
        if ((rc = DosCopy(szSourceSpec,szDestSpec,0L)) != NO_ERROR)
          {
          switch (CompareFileDate(szSourceSpec,szDestSpec))
            {
            case MBID_YES:
              if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
                {
                bSuccess = FALSE;
                if (!DisplayCopyError(szFileName,szDestSpec,rc))
                  goto gtFreePathMem;
                }
              break;
            case MBID_NO:
              continue;
            case MBID_CANCEL:
              bSuccess = FALSE;
              goto gtFreePathMem;

            }
          }
        ClearReadOnly(szDestSpec);
        itoa(++iFileCount,&szFileNumber[iEnd],10);
        PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
        }
      }
    if (!pstInst->bBaseLibrariesCopied)
      {
      strcpy(szFileKey,"Base_file_");
      iCountPos = strlen(szFileKey);
      ulFileCount = 0;
      PrfQueryProfileData(hSourceProfile,"Libraries","Base Files",&ulFileCount,&cbDataSize);
      for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
        {
        itoa(iIndex,&szFileKey[iCountPos],10);
        if (PrfQueryProfileString(hSourceProfile,"Libraries",szFileKey,0,szFileName,18) != 0)
          {
          strcpy(&szDestSpec[iDestPathEnd],szFileName);
          strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
          pstInst->pfnPrintProgress(szFileName,szDestSpec);
          if ((rc = DosCopy(szSourceSpec,szDestSpec,0L)) != NO_ERROR)
            {
            switch (CompareFileDate(szSourceSpec,szDestSpec))
              {
              case MBID_YES:
                if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
                  {
                  bSuccess = FALSE;
                  if (!DisplayCopyError(szFileName,szDestSpec,rc))
                    goto gtFreePathMem;
                  }
                break;
              case MBID_NO:
                continue;
              case MBID_CANCEL:
                bSuccess = FALSE;
                goto gtFreePathMem;

              }
            }
          ClearReadOnly(szDestSpec);
          itoa(++iFileCount,&szFileNumber[iEnd],10);
          PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
          }
        }
      if (bSuccess)
        pstInst->bBaseLibrariesCopied = TRUE;
      }
   if (bLibsDirCreated)
      {
      strcpy(szDestSpec,pstInst->pszAppsPath);
      iDestPathEnd = strlen(szDestSpec);
      szDestSpec[iDestPathEnd++] = '\\';
      szDestSpec[iDestPathEnd] = 0;
      sprintf(&szDestSpec[iDestPathEnd],pstInst->paszStrings[INIFILENAME]);
      PrfWriteProfileString(hInstalledProfile,"Installed","Library Path",pstInst->pszDLLpath);
      }
    }
  PrfWriteProfileString(hInstalledProfile,"Installed","Program Path",pstInst->pszAppsPath);
  PrfWriteProfileData(hInstalledProfile,"Installed","Files",&iFileCount,sizeof(int));
  if (pstInst->bBaseLibrariesCopied)
    {
    if (strlen(pstInst->paszStrings[CONFIGDDLIBRARYSPEC]) != 0)
      {
      if (strlen(szPDRpath) != 0)
        sprintf(pstInst->paszStrings[CONFIGDDLIBRARYSPEC],"%s\\%s.DLL",szPDRpath,pstInst->paszStrings[CONFIGDDLIBRARYNAME]);
      else
        if (pstInst->pszDLLpath != NULL)
          sprintf(pstInst->paszStrings[CONFIGDDLIBRARYSPEC],"%s\\%s.DLL",pstInst->pszDLLpath,pstInst->paszStrings[CONFIGDDLIBRARYNAME]);
      PrfWriteProfileString(HINI_USERPROFILE,"COMi","Configuration",pstInst->paszStrings[CONFIGDDLIBRARYSPEC]);
      }
    MenuItemEnable(pstInst->hwndFrame,IDM_SETUP,TRUE);
    }
  if (strlen(pstInst->paszStrings[CONFIGDDHELPFILENAME]) != 0)
    {
    sprintf(szPath,"%s\\%s",pstInst->pszAppsPath,pstInst->paszStrings[CONFIGDDHELPFILENAME]);
    PrfWriteProfileString(HINI_USERPROFILE,"COMi","Help",szPath);
    }
  if (pstInst->bCreateObjects)
    {
    bObjectBad = FALSE;
    strcpy(szFileNumber,"Object_");
    iEnd = strlen(szFileNumber);
    cbDataSize = sizeof(ULONG);
    if (!PrfQueryProfileData(hInstalledProfile,"Installed","Objects",&iObjectCount,&cbDataSize))
      iObjectCount = 0;
    hObject = WinCreateObject("WPFolder",szFolderName,szFolderSetup,"<WP_DESKTOP>",CO_UPDATEIFEXISTS);
    if (hObject == 0)
      {
      sprintf(&szFolderName[strlen(szFolderName)],":1");
      hObject = WinCreateObject("WPFolder",szFolderName,szFolderSetup,"<WP_DESKTOP>",CO_UPDATEIFEXISTS);
      }
    if (hObject != 0)
      {
      PrfWriteProfileData(hInstalledProfile,"Installed","Folder",&hObject,sizeof(HOBJECT));
      szDestSpec[iDestPathEnd - 1] = 0;
      sprintf(szPath,"<%s>",szFolderName);
      strcpy(szFolderName,szPath);
      if (szCOMiINFname[0] != 0)
        {
        sprintf(szSetupString,"%sEXENAME=VIEW.EXE;PARAMETERS=%s\\%s",szINFobjectSetup,szDestSpec,pstInst->paszStrings[CONFIGDDNAME]);
        sprintf(szPath,"%s Users Guide",pstInst->paszStrings[CONFIGDDNAME]);
        hObject = WinCreateObject("WPProgram",szPath,szSetupString,szFolderID,CO_UPDATEIFEXISTS);
        if (hObject != 0)
          {
          itoa(++iObjectCount,&szFileNumber[iEnd],10);
          PrfWriteProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,sizeof(HOBJECT));
          }
        else
          bObjectBad = TRUE;
        }
      if (szCOMscopeEXEname[0] != 0)
        {
        sprintf(szSetupString,"%sEXENAME=%s\\%s;STARTUPDIR=%s;NODROP=YES",szProgramObjectSetup,szDestSpec,szCOMscopeEXEname,szDestSpec);
        if (pstInst->bCopyUtil)
          strcat(szSetupString,";PARAMETERS=/S /T;CCVIEW=YES");
        hObject = WinCreateObject("WPProgram","COMscope",szSetupString,szFolderID,CO_UPDATEIFEXISTS);
        if (hObject != 0)
          {
          itoa(++iObjectCount,&szFileNumber[iEnd],10);
          PrfWriteProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,sizeof(HOBJECT));
          }
        else
          bObjectBad = TRUE;
        }
      if (szInstallEXEname[0] != 0)
        {
        sprintf(szSetupString,"%sEXENAME=%s\\%s;STARTUPDIR=%s",szProgramObjectSetup,szDestSpec,szInstallEXEname,szDestSpec);
        hObject = WinCreateObject("WPProgram","OS/tools Install",szSetupString,szFolderID,CO_UPDATEIFEXISTS);
        if (hObject != 0)
          {
          itoa(++iObjectCount,&szFileNumber[iEnd],10);
          PrfWriteProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,sizeof(HOBJECT));
          }
        else
          bObjectBad = TRUE;
        }
      if (bWinCOMObject)
        {
        sprintf(szSetupString,"%sEXENAME=%s\\WinCOM.exe;STARTUPDIR=%s",szProgramObjectSetup,szDestSpec,szDestSpec);
        hObject = WinCreateObject("WPProgram","WinCOM",szSetupString,szFolderID,CO_UPDATEIFEXISTS);
        if (hObject != 0)
          {
          itoa(++iObjectCount,&szFileNumber[iEnd],10);
          PrfWriteProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,sizeof(HOBJECT));
          }
        else
          bObjectBad = TRUE;
        }
      PrfWriteProfileData(hInstalledProfile,"Installed","Objects",&iObjectCount,sizeof(int));
      }
    }
  if (bObjectBad || (hObject == 0))
    {
    sprintf(szMessage,"At least one desktop object was not created due to an unknown system error.");
    sprintf(szCaption,"Object(s) Not Created!");
    WinMessageBox(HWND_DESKTOP,
                  HWND_DESKTOP,
                  szMessage,
                  szCaption,
                  0,
                 (MB_MOVEABLE | MB_OK));
    }
gtFreePathMem:
  PrfCloseProfile(hInstalledProfile);
  PrfCloseProfile(hSourceProfile);
  if (bSuccess)
    pstInst->bFilesCopied = TRUE;
  return(bSuccess);
  }

BOOL CopyFile(char szSourceSpec[],char szDestSpec[])
  {
  FILESTATUS3 stFileStatus;
  APIRET rc;

  if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
    {
    if (rc == ERROR_ACCESS_DENIED)
      {
      if (DosQueryPathInfo(szDestSpec,1,&stFileStatus,sizeof(FILESTATUS3)) == NO_ERROR)
        {
        if (stFileStatus.attrFile & FILE_HIDDEN)
          {
          stFileStatus.attrFile &= ~FILE_HIDDEN;
          DosSetPathInfo(szDestSpec,1,&stFileStatus,sizeof(FILESTATUS3),0);
          if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
            return(FALSE);
          }
        }
      else
        return(FALSE);
      }
    else
      return(FALSE);
    }
  ClearReadOnly(szDestSpec);
  return(TRUE);
  }

void ClearReadOnly(char szFileSpec[])
  {
  ULONG ulAttr;

  if (DosQueryPathInfo(szFileSpec,1,&stFileStatus,sizeof(FILESTATUS3)) == NO_ERROR)
    if (stFileStatus.attrFile & FILE_READONLY)
      {
      stFileStatus.attrFile &= ~FILE_READONLY;
      DosSetPathInfo(szFileSpec,1,&stFileStatus,sizeof(FILESTATUS3),0);
      }
  }

BOOL MakePath(HWND hwnd,char szPath[])
  {
  APIRET rc;
  FILESTATUS3 stFileStatus;
  char szMessage[CCHMAXPATH + 80];
  char szCaption[80];
  BOOL bSuccess = TRUE;

  if ((rc = DosQueryPathInfo(szPath,FIL_STANDARD,&stFileStatus,sizeof(FILESTATUS3))) != NO_ERROR)
    {
    if ((rc == ERROR_PATH_NOT_FOUND) || (rc == ERROR_FILE_NOT_FOUND) )
      {
      sprintf(szMessage,"Do you want to create the directory %s?",szPath);
      sprintf(szCaption,"Directory does not exist!");
      if (WinMessageBox(HWND_DESKTOP,
              hwnd,
              szMessage,
              szCaption,
              0,
              MB_MOVEABLE | MB_YESNO | MB_ICONQUESTION) == MBID_YES)
        {
        if (!CreatePath(szPath))
          {
          sprintf(szMessage,"Unable to create the directory %s?",szPath);
          sprintf(szCaption,"Invalid Path Specification!");
          WinMessageBox(HWND_DESKTOP,
                        hwnd,
                        szMessage,
                        szCaption,
                        0,
                        MB_MOVEABLE | MB_OK | MB_ICONEXCLAMATION);
          bSuccess = FALSE;
          }
        }
      else
        {
        bSuccess = FALSE;
        }
      }
    else
      {
      sprintf(szMessage,"%s is invalid.",szPath);
      sprintf(szCaption,"Invalid Path Specification!");
      WinMessageBox(HWND_DESKTOP,
                    hwnd,
                    szMessage,
                    szCaption,
                    0,
                    MB_MOVEABLE | MB_OK | MB_ICONEXCLAMATION);
      bSuccess = FALSE;
      }
    }
  else
    {
    if ((stFileStatus.attrFile & FILE_DIRECTORY) == 0)
      {
      sprintf(szMessage,"%s is a file.  Please select another directory.",szPath);
      sprintf(szCaption,"Invalid Path Specification!");
      WinMessageBox(HWND_DESKTOP,
                    hwnd,
                    szMessage,
                    szCaption,
                    0,
                    MB_MOVEABLE | MB_OK | MB_ICONEXCLAMATION);
      bSuccess = FALSE;
      }
    }
  return(bSuccess);
  }

BOOL CreatePath(char szPath[])
  {
  int iIndex;
  int iLen;

  if (DosCreateDir(szPath,0) == NO_ERROR)
    return(TRUE);

  if ((iLen = strlen(szPath)) == 0)
    return(FALSE);
  for (iIndex = (iLen - 1);iIndex > 0;iIndex--)
    if (szPath[iIndex] =='\\')
      {
      szPath[iIndex] = 0;
      if (CreatePath(szPath))
        {
        szPath[iIndex] = '\\';
        if (DosCreateDir(szPath,0) == NO_ERROR)
          return(TRUE);
        }
      break;
      }
  return(FALSE);
  }

USHORT CompareFileDate(char szSourceFileSpec[],char szDestFileSpec[])
  {
  FILESTATUS3 stFileInfo;
  FDATE fdateSourceLastWrite;
  char szMessage[200];
  char szCaption[40];
  APIRET rc;

  DosQueryPathInfo(szSourceFileSpec,1,&stFileInfo,sizeof(FILESTATUS3));
  fdateSourceLastWrite = stFileInfo.fdateLastWrite;
  if ((rc = DosQueryPathInfo(szDestFileSpec,1,&stFileInfo,sizeof(FILESTATUS3))) == NO_ERROR)
    {
    if (fdateSourceLastWrite.year > stFileInfo.fdateLastWrite.year)
      return(MBID_YES);
    else
      if (fdateSourceLastWrite.year == stFileInfo.fdateLastWrite.year)
        if (fdateSourceLastWrite.month > stFileInfo.fdateLastWrite.month)
          return(MBID_YES);
        else
          if (fdateSourceLastWrite.month == stFileInfo.fdateLastWrite.month)
            if (fdateSourceLastWrite.day >= stFileInfo.fdateLastWrite.day)
              return(MBID_YES);
    sprintf(szMessage,"%s is the same, or newer, version than the file to be installed.\n\nDo you want to replace it?",szDestFileSpec);
    sprintf(szCaption,"Newer file exists!");
    return(WinMessageBox(HWND_DESKTOP,HWND_DESKTOP,szMessage,szCaption,
                         HLPP_MB_OLD_FILE,
                        (MB_MOVEABLE | MB_HELP | MB_YESNOCANCEL | MB_ICONQUESTION)));
    }
  else
    {
    if (rc == ERROR_SHARING_VIOLATION)
      {
      sprintf(szMessage,"%s is currently in open by another process.\n\nPlease correct and reinstall.",szDestFileSpec);
      sprintf(szCaption,"File Currently in Use!");
      WinMessageBox(HWND_DESKTOP,
                    HWND_DESKTOP,
                    szMessage,
                    szCaption,
                    HLPP_MB_FILE_INUSE,
                   (MB_MOVEABLE | MB_OK | MB_HELP));
      return(MBID_CANCEL);
      }
    }
  return(MBID_NO);
  }

BOOL DisplayCopyError(char szSource[],char szDest[],APIRET rcErrorCode)
  {
  char szMessage[CCHMAXPATH + 80];
  char szCaption[80];

  switch (rcErrorCode)
    {
    case ERROR_FILE_NOT_FOUND:
      strcpy(szCaption,"Source file not Found!");
      break;
    case ERROR_PATH_NOT_FOUND:
      strcpy(szCaption,"Source path not Found!");
      break;
    case ERROR_ACCESS_DENIED:
      strcpy(szCaption,"Access to Destination file is denied!");
      break;
    case ERROR_NOT_DOS_DISK:
      strcpy(szCaption,"Destination is not DOS disk!");
      break;
    case ERROR_INVALID_PARAMETER:
      strcpy(szCaption,"Invalid Parameter!");
      break;
    case ERROR_DRIVE_LOCKED:
      strcpy(szCaption,"Destination drive is locked!");
      break;
    case ERROR_DIRECTORY:
      strcpy(szCaption,"Destination file name is a directory!");
      break;
    default:
      strcpy(szCaption,"Unexpected Error!");
      break;
    }
  sprintf(szMessage,"Unable to copy %s to %s\n\nDo you want to continue file transfer?",szSource,szDest);
  if (WinMessageBox(HWND_DESKTOP,
                    HWND_DESKTOP,
                    szMessage,
                    szCaption,
                    0L,
                   (MB_MOVEABLE | MB_OKCANCEL | MB_ICONQUESTION | MB_DEFBUTTON2)) != MBID_OK)
    return(FALSE);
  return(TRUE);
  }

void CleanSystemIni(char szApplicationName[],UNINST *pstUninstall)
  {
  PFN pfnProcess;
  HMODULE hMod;
  char *pKeyNames;
  char szAppName[40];
  char szDriver[40];
  char *pKeyName;
  ULONG ulSize;
  int iIndex;
  int iStartIndex;
  INSTALL *pstInst;

  pstInst = pstUninstall->pstInst;
  if (PrfQueryProfileString(HINI_USERPROFILE,szApplicationName,"Spooler",NULL,pstUninstall->pszPath,pstInst->ulMaxPathLen))
    {
    if (DosLoadModule(0,0,pstUninstall->pszPath,&hMod) == NO_ERROR)
      {
      if (DosQueryProcAddr(hMod,0,"SPLPDREMOVEPORT",&pfnProcess) == NO_ERROR)
        {
        if (PrfQueryProfileSize(HINI_SYSTEMPROFILE,"PM_SPOOLER_PORT",0L,&ulSize))
          {
          if ((pKeyNames = malloc(ulSize + 1)) != NULL)
            {
            pKeyNames[0] = 0;
            PrfQueryProfileString(HINI_SYSTEMPROFILE,"PM_SPOOLER_PORT",NULL,NULL,pKeyNames,ulSize);
            iIndex = 0;
            while (pKeyNames[iIndex] != 0)
              {
              iStartIndex = iIndex;
              while(pKeyNames[iIndex++] != 0);
              pKeyName = &pKeyNames[iStartIndex];
              if (strncmp(pKeyName,"COM",3) == 0)
                {
                sprintf(szAppName,"PM_%s",pKeyName);
                PrfQueryProfileString(HINI_SYSTEMPROFILE,szAppName,"PORTDRIVER",0L,szDriver,30);
                if (strcmp(szDriver,"COMI_SPL;") != 0)
                  if (strcmp(szDriver,"SPL_DEMO;") != 0)
                    continue;
                pfnProcess(pstInst->hab,pKeyName);
                }
              }
            free(pKeyNames);
            }
          }
        }
      DosFreeModule(hMod);
      }
    PrfWriteProfileString(HINI_USERPROFILE,szApplicationName,"Spooler",NULL);
    }
  PrfWriteProfileString(HINI_SYSTEMPROFILE,"PM_PORT_DRIVER","COMI_SPL",NULL);
  PrfWriteProfileString(HINI_SYSTEMPROFILE,"PM_PORT_DRIVER","SPL_DEMO",NULL);
  }

void APIENTRY Uninstall(HWND hwnd,UNINST *pstUninstall)
  {
  FILESTATUS3 stFileInfo;
  char szCaption[40];
  char szMessage[200];
  ULONG cbDataSize;
  int iFileCount;
  int iCountPos;
  int iIndex;
  HOBJECT hObject;
  char szDeleteCmdFile[60];
  BOOL bDeleteCommandFile = FALSE;
  char *pszDeletePath;
  HFILE hDeleteFile;
  ULONG ulAction;
  ULONG ulBytesWritten;
  APIRET rc;
  HINI hInstalledProfile;
  char szFileNumber[40];
  BOOL bObjectsToDelete;
  INSTALL *pstInst;

  pstInst = pstUninstall->pstInst;
  if (strlen(pstInst->paszStrings[CURRENTDRIVERSPEC]) != 0)
    {
    CleanConfigSys(hwnd,pstInst->paszStrings[CURRENTDRIVERSPEC],HLPP_MB_CONFIGSYS_BAD,FALSE);
    AppendTMP(pstInst->paszStrings[CURRENTDRIVERSPEC]);
    DosDelete(pstInst->paszStrings[CURRENTDRIVERSPEC]);
    AppendINI(pstInst->paszStrings[CURRENTDRIVERSPEC]);
    }
  CleanSystemIni(pstUninstall->pszConfigDDname,pstUninstall);
  switch (pstUninstall->fCurrentIni)
    {
    case UNINSTALL_REUSE_INI:
    case UNINSTALL_SAVE_INI:
      sprintf(pstUninstall->pszPath,"%c:\\COMDDINI.OLD",pstInst->chBootDrive);
      DosCopy(pstInst->paszStrings[CURRENTDRIVERSPEC],pstUninstall->pszPath,DCPY_EXISTING);
      pstInst->bSavedDriverIniFile = TRUE;
    case UNINSTALL_DEL_INI:
      DosDelete(pstInst->paszStrings[CURRENTDRIVERSPEC]);
      break;
    }
  if ((hInstalledProfile = PrfOpenProfile(pstInst->hab,pstUninstall->pszUninstallIniPath)) != 0)
    {
    iCountPos = sprintf(szFileNumber,"File_");
    cbDataSize = sizeof(int);
    if (PrfQueryProfileData(hInstalledProfile,"Installed","Files",&iFileCount,&cbDataSize))
      {
      for (iIndex = 1;iIndex <= iFileCount;iIndex++)
        {
        itoa(iIndex,&szFileNumber[iCountPos],10);
        if (PrfQueryProfileString(hInstalledProfile,"Installed",szFileNumber,0,pstUninstall->pszPath,pstInst->ulMaxPathLen) != 0)
          {
          if (strlen(pstUninstall->pszPath) != 0)
            {
            if (pstUninstall->pfnPrintProgress != (PFN)NULL)
              pstUninstall->pfnPrintProgress(pstUninstall->pszPath);
            if ((rc = DosForceDelete(pstUninstall->pszPath)) != NO_ERROR)
              {
              if ((rc == ERROR_ACCESS_DENIED) || (rc == ERROR_SHARING_VIOLATION))
                {
                if (!bDeleteCommandFile)
                  {
                  bDeleteCommandFile = TRUE;
                  pszDeletePath = (PSZ)malloc(pstInst->ulMaxPathLen + 20);
                  if (pszDeletePath == NULL)
                    {
                    strcpy(pstUninstall->pszBannerTwo,"Failed to allocate Delete path memory");
                    pstUninstall->pszBannerOne[0] = 0;
                    return;
                    }
                  sprintf(pszDeletePath,"@ECHO OFF\r\nDEL %s > NUL\r\n",pstUninstall->pszPath);
                  sprintf(szDeleteCmdFile,"%c:\\DEL_COMi.CMD",pstInst->chBootDrive);
                  if (DosOpen(szDeleteCmdFile,&hDeleteFile,&ulAction,0,0,0x0012,0x0191,0) != NO_ERROR)
                    hDeleteFile = 0;
                  DosWrite(hDeleteFile,pszDeletePath,strlen(pszDeletePath),&ulBytesWritten);
                  }
                else
                  if (hDeleteFile != 0)
                    {
                    sprintf(pszDeletePath,"DEL %s > NUL\r\n",pstUninstall->pszPath);
                    DosWrite(hDeleteFile,pszDeletePath,strlen(pszDeletePath),&ulBytesWritten);
                    }
                }
              }
            }
          }
        }
      }
    if (pstUninstall->fObjects != UNINSTALL_NO_OBJ)
      {
      bObjectsToDelete = TRUE;
      if (pstUninstall->fObjects == UNINSTALL_FOLDERS)
        {
        sprintf(szMessage,"Deleting a folder will cause any objects that reside in that folder to be deleted also.\n\nDo you want to delete the folder?");
        sprintf(szCaption,"Deleting OS/tools Utilities Folder!");
        if (WinMessageBox(HWND_DESKTOP,
                          HWND_DESKTOP,
                          szMessage,
                          szCaption,
                          HLPP_MB_DELETE_FOLDER,
                         (MB_MOVEABLE | MB_YESNO | MB_HELP)) == MBID_YES)
          {
          if (PrfQueryProfileData(hInstalledProfile,"Installed","Folder",&hObject,&cbDataSize) != 0)
            {
            bObjectsToDelete = FALSE;
            WinDestroyObject(hObject);
            }
          else
            {
            if (PrfQueryProfileData(hInstalledProfile,"Installed","Object_1",&hObject,&cbDataSize) != 0)
              {
              bObjectsToDelete = FALSE;
              WinDestroyObject(hObject);
              }
            }
          }
        }
      if (bObjectsToDelete)
        {
        iCountPos = sprintf(szFileNumber,"Object_");
        cbDataSize = sizeof(HOBJECT);
        if (PrfQueryProfileData(hInstalledProfile,"Installed","Objects",&iFileCount,&cbDataSize))
          {
          for (iIndex = iFileCount;iIndex > 0;iIndex--)
            {
            itoa(iIndex,&szFileNumber[iCountPos],10);
            if (PrfQueryProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,&cbDataSize) != 0)
              WinDestroyObject(hObject);
            }
          }
        }
      }
    if (pstUninstall->bDirs)
      {
      if (PrfQueryProfileString(hInstalledProfile,"Installed","Library Path",0,pstUninstall->pszPath,pstInst->ulMaxPathLen) != 0)
        DosDeleteDir(pstUninstall->pszPath);
      if (PrfQueryProfileString(hInstalledProfile,"Installed","Program Path",0,pstUninstall->pszPath,pstInst->ulMaxPathLen) != 0)
        {
        PrfCloseProfile(hInstalledProfile);
        DosForceDelete(pstUninstall->pszUninstallIniPath);
        DosDeleteDir(pstUninstall->pszPath);
        }
      else
        PrfCloseProfile(hInstalledProfile);
      }
    else
      PrfCloseProfile(hInstalledProfile);
    if (pstUninstall->pfnPrintProgress != (PFN)NULL)
      pstUninstall->pfnPrintProgress(pstUninstall->pszUninstallIniPath);
    }
  PrfWriteProfileString(HINI_USERPROFILE,"COMscope",0,0);
  PrfWriteProfileString(HINI_USERPROFILE,"COMi",0,0);
  MenuItemEnable(pstInst->hwndFrame,IDM_UNINSTALL,FALSE);
  MenuItemEnable(pstInst->hwndFrame,IDM_SETUP,FALSE);
  MenuItemEnable(pstInst->hwndFrame,IDM_TRANSFER,FALSE);
  if (bDeleteCommandFile)
    {
    sprintf(szMessage,"One or more files were not deleted because they were being accessed by this or some other process.");
    sprintf(szCaption,"Access Denied!");
    WinMessageBox(HWND_DESKTOP,
                  HWND_DESKTOP,
                  szMessage,
                  szCaption,
                  HLPP_MB_DELETE_DENIED,
                 (MB_MOVEABLE | MB_OK | MB_HELP));
    sprintf(pszDeletePath,"DEL %c:\\DELLOCK.CMD > NUL\r\n",pstInst->chBootDrive);
    DosWrite(hDeleteFile,pszDeletePath,strlen(pszDeletePath),&ulBytesWritten);
    DosClose(hDeleteFile);
    free(pszDeletePath);
    strcpy(pstUninstall->pszBannerTwo,"Uninstall Incomplete");
    }
  else
    strcpy(pstUninstall->pszBannerTwo,"Uninstall Complete");
  pstUninstall->pszBannerOne[0] = 0;
  }


