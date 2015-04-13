#include "install.h"
#include <CONFIG.H>

void ClearReadOnly(char szFileSpec[]);
BOOL CopyFile(char *pszSourceSpec,char *pszDestSpec);
USHORT CompareFileDate(char szSourceFileSpec[],char szDestFileSpec[]);
void AppendINI(char szFileSpec[]);
BOOL DisplayCopyError(char szSource[],char szDest[],APIRET rcErrorCode);

extern HWND hwndFrame;

void MemFree(char *pBuffer)
  {
  if (pBuffer != NULL)
    {
    free(pBuffer);
    pBuffer = NULL;
    }
  }

BOOL MemAlloc(char **ppBuffer,ULONG cbSize)
  {
#ifdef no_realloc
  if (*ppBuffer != NULL)
    free(*ppBuffer);
  *ppBuffer = malloc(cbSize);
#else
  *ppBuffer = realloc(*ppBuffer,cbSize);
#endif
  if (*ppBuffer == NULL)
    {
    MessageBox(hwndFrame,"Memory allocation failed");
    return(FALSE);
    }
  return(TRUE);
  }


BOOL CopyFiles(void)
  {
  int iIndex;
  char szFileKey[20];
  char szMessage[80];
  char szCaption[40];
  char *pszDestSpec = NULL;
  char *pszSourceSpec = NULL;
  char szFileName[80];
  char *pszInstalledIniPath = NULL;
  int iCountPos;
  int iDestPathEnd;
  int iSourcePathEnd;
  APIRET rc;
  BOOL bSuccess = TRUE;
  HPOINTER hPointer;
  int iLen;
  FILESTATUS3 stFileStatus;
  int iFileCount;
  int iObjectCount;
  int iEnd;
  HOBJECT hObject;
  BOOL bObjectBad;
  unsigned int uiAttrib;
  BOOL bCopyLibraries = FALSE;
  ULONG ulFileCount;
  ULONG cbDataSize = sizeof(ULONG);
  ULONG ulInstalledFileStart;
  ULONG ulInstalledObjectStart;
  ULONG ulAttr;
  char szFileNumber[40];

  iEnd = sprintf(szFileNumber,"File_");
  MemAlloc(&pszDestSpec,(ulMaxPathLen + 1));
  MemAlloc(&pszSourceSpec,(ulMaxPathLen + 1));
  strcpy(pszDestSpec,pszAppsPath);
  iDestPathEnd = strlen(pszDestSpec);
  pszDestSpec[iDestPathEnd++] = '\\';
  pszDestSpec[iDestPathEnd] = 0;
  hPointer = WinQuerySysPointer(HWND_DESKTOP,SPTR_WAIT,FALSE);
  WinSetPointer(HWND_DESKTOP,hPointer);

  strcpy(pszSourceSpec,pszSourcePath);
  iSourcePathEnd = strlen(pszSourceSpec);
  pszSourceSpec[iSourcePathEnd++] = '\\';

  szCOMscopeEXEname[0] = 0;
  szInstallEXEname[0] = 0;

  MemAlloc(&pszInstalledIniPath,(strlen(pszDestSpec) + strlen(szUninstallIniFileName) + 5));
  sprintf(pszInstalledIniPath,"%s%s",pszDestSpec,szUninstallIniFileName);
  if (!MakePath(hwndFrame,pszAppsPath))
   return(FALSE);
  hInstalledProfile = PrfOpenProfile(habAnchorBlock,pszInstalledIniPath);
  cbDataSize = sizeof(ULONG);
  if (!PrfQueryProfileData(hInstalledProfile,"Installed","Files",&iFileCount,&cbDataSize))
    iFileCount = 0;
  if (!PrfQueryProfileData(hInstalledProfile,"Installed","Objects",&iObjectCount,&cbDataSize))
    iObjectCount = 0;
  sprintf(pszPath,"%c:\\DEL_COMi.CMD",chBootDrive);
  DosForceDelete(pszPath);
  if (bCopyCOMi)
    {
    strcpy(pszDestSpec,pszAppsPath);
    iDestPathEnd = strlen(pszDestSpec);
    pszDestSpec[iDestPathEnd++] = '\\';
    pszDestSpec[iDestPathEnd] = 0;
    MemAlloc(&stCOMiCFG.pszDriverIniSpec,(strlen(pszAppsPath) + strlen(szDDname) + 4));
    sprintf(stCOMiCFG.pszDriverIniSpec,"%s\\%s",pszAppsPath,szDDname);
    if (pszCurrentDriverSpec != NULL)
      {
      if (strcmp(pszCurrentDriverSpec,stCOMiCFG.pszDriverIniSpec) != 0)
        {
        strcpy(pszPath,szDDname);
        AppendINI(pszPath);
        sprintf(szFileName,"Existing %s",pszPath);
        MemAlloc(&stCOMiCFG.pszRemoveOldDriverSpec,(strlen(pszCurrentDriverSpec) + 4));
        strcpy(stCOMiCFG.pszRemoveOldDriverSpec,pszCurrentDriverSpec);
        AppendINI(stCOMiCFG.pszDriverIniSpec);
        AppendINI(pszCurrentDriverSpec);
        PrintProgress(szFileName,stCOMiCFG.pszDriverIniSpec);
        if (bSavedDriverIniFile)
          {
          sprintf(pszCurrentDriverSpec,"%c:\\COMDDINI.OLD",chBootDrive);
          DosCopy(pszCurrentDriverSpec,stCOMiCFG.pszDriverIniSpec,DCPY_EXISTING);
          bSavedDriverIniFile = FALSE;
          if (stUninstall.fCurrentIni != UNINSTALL_SAVE_INI)
            DosDelete(pszCurrentDriverSpec);
          }
        else
          if (DosCopy(pszCurrentDriverSpec,stCOMiCFG.pszDriverIniSpec,DCPY_EXISTING) != NO_ERROR)
            {
            sprintf(pszCurrentDriverSpec,"%c:\\COMDDINI.OLD",chBootDrive);
            DosCopy(pszCurrentDriverSpec,stCOMiCFG.pszDriverIniSpec,DCPY_EXISTING);
            DosForceDelete(pszCurrentDriverSpec);
            }
        }
      else
        {
        rc = DosQueryPathInfo(pszCurrentDriverSpec,1,&stFileStatus,sizeof(FILESTATUS3));
        if ((rc == ERROR_PATH_NOT_FOUND) || (rc == ERROR_FILE_NOT_FOUND))
          {
          sprintf(pszCurrentDriverSpec,"%c:\\COMDDINI.OLD",chBootDrive);
          DosCopy(pszCurrentDriverSpec,stCOMiCFG.pszDriverIniSpec,DCPY_EXISTING);
          DosForceDelete(pszCurrentDriverSpec);
          }
        }
      MemFree(pszCurrentDriverSpec);
      }
    else
      {
      AppendINI(stCOMiCFG.pszDriverIniSpec);
      rc = DosQueryPathInfo(stCOMiCFG.pszDriverIniSpec,1,&stFileStatus,sizeof(FILESTATUS3));
      if ((rc == ERROR_PATH_NOT_FOUND) || (rc == ERROR_FILE_NOT_FOUND))
        {
        sprintf(pszPath,"%c:\\COMDDINI.OLD",chBootDrive);
        DosCopy(pszPath,stCOMiCFG.pszDriverIniSpec,DCPY_EXISTING);
        DosForceDelete(pszPath);
        }
      }
    AppendINI(stCOMiCFG.pszDriverIniSpec);
    stCOMiCFG.byOEMtype = (BYTE)ulOEMtype;
    sprintf(&pszDestSpec[iDestPathEnd],"%s",szDDname);
    sprintf(&pszSourceSpec[iSourcePathEnd],"%s",szDDname);
    PrintProgress(szDDname,pszDestSpec);
    if ((rc = DosCopy(pszSourceSpec,pszDestSpec,DCPY_EXISTING)) != NO_ERROR)
      {
      bSuccess = FALSE;
      if (!DisplayCopyError(szDDname,pszDestSpec,rc))
        goto gtFreePathMem;
      }
    ClearReadOnly(pszDestSpec);
    itoa(++iFileCount,&szFileNumber[iEnd],10);
    PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,pszDestSpec);
    AppendINI(pszSourceSpec);
    if (DosQueryPathInfo(pszSourceSpec,FIL_STANDARD,&stFileStatus,sizeof(FILESTATUS3)) == NO_ERROR)
      {
      AppendINI(pszDestSpec);
      strcpy(pszPath,szDDname);
      AppendINI(pszPath);
      PrintProgress(pszPath,pszDestSpec);
      DosCopy(pszSourceSpec,pszDestSpec,DCPY_EXISTING);
      ClearReadOnly(pszDestSpec);
      itoa(++iFileCount,&szFileNumber[iEnd],10);
      PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,pszDestSpec);
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
        strcpy(&pszDestSpec[iDestPathEnd],szFileName);
        strcpy(&pszSourceSpec[iSourcePathEnd],szFileName);
        PrintProgress(szFileName,pszDestSpec);
        if ((rc = DosCopy(pszSourceSpec,pszDestSpec,DCPY_EXISTING)) != NO_ERROR)
          {
          bSuccess = FALSE;
          if (!DisplayCopyError(szFileName,pszDestSpec,rc))
            goto gtFreePathMem;
          }
        ClearReadOnly(pszDestSpec);
        itoa(++iFileCount,&szFileNumber[iEnd],10);
        PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,pszDestSpec);
        }
      }
    MenuItemEnable(hwndFrame,IDM_SETUP,TRUE);
    /*
    ** This entry must be placed here so the the Configuration DLL can "find" the
    ** COMi initialization file, before the device driver is actually loaded.
    */
    PrfWriteProfileString(HINI_USERPROFILE,"COMi","Initialization",stCOMiCFG.pszDriverIniSpec);
    PrfWriteProfileString(HINI_USERPROFILE,"COMi","Version",szCOMiVersion);
    }
  if (bCopyPDR)
    {
    strcpy(szFileKey,"File_");
    iCountPos = strlen(szFileKey);
    sprintf(pszDestSpec,"%c:\\OS2\\DLL",chBootDrive);
    MemAlloc(&pszPDRpath,(strlen(pszDestSpec) + 40));
    strcpy(pszPDRpath,pszDestSpec);
    iDestPathEnd = strlen(pszDestSpec);
    pszDestSpec[iDestPathEnd++] = '\\';
    pszDestSpec[iDestPathEnd] = 0;
    ulFileCount = 0;
    PrfQueryProfileData(hSourceProfile,"PDR","Files",&ulFileCount,&cbDataSize);
    for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
      {
      itoa(iIndex,&szFileKey[iCountPos],10);
      strcpy(&pszDestSpec[iDestPathEnd],szFileName);
      if (PrfQueryProfileString(hSourceProfile,"PDR",szFileKey,0,szFileName,18) != 0)
        {
        strcpy(&pszDestSpec[iDestPathEnd],szFileName);
        strcpy(&pszSourceSpec[iSourcePathEnd],szFileName);
        PrintProgress(szFileName,pszDestSpec);
        if ((rc = DosCopy(pszSourceSpec,pszDestSpec,0L)) != NO_ERROR)
          {
          switch (CompareFileDate(pszSourceSpec,pszDestSpec))
            {
            case MBID_YES:
              if ((rc = DosCopy(pszSourceSpec,pszDestSpec,DCPY_EXISTING)) != NO_ERROR)
                {
                bSuccess = FALSE;
                if (!DisplayCopyError(szFileName,pszDestSpec,rc))
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
        ClearReadOnly(pszDestSpec);
        itoa(++iFileCount,&szFileNumber[iEnd],10);
        PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,pszDestSpec);
        }
      if (bSuccess)
        bBaseLibrariesCopied = TRUE;
      }
    if (PrfQueryProfileString(hSourceProfile,"PDR","PDR Library",0,szFileName,18) != 0)
      {
      strcpy(szPDRlibraryName,szFileName);
      strcpy(&pszDestSpec[iDestPathEnd],szFileName);
      PrfWriteProfileString(HINI_USERPROFILE,"COMi","Spooler",pszDestSpec);
      strcpy(&pszSourceSpec[iSourcePathEnd],szFileName);
      PrintProgress(szFileName,pszDestSpec);
      if ((rc = DosCopy(pszSourceSpec,pszDestSpec,0L)) != NO_ERROR)
        {
        switch (CompareFileDate(pszSourceSpec,pszDestSpec))
          {
          case MBID_YES:
            if ((rc = DosCopy(pszSourceSpec,pszDestSpec,DCPY_EXISTING)) != NO_ERROR)
              {
              bSuccess = FALSE;
              if (!DisplayCopyError(szFileName,pszDestSpec,rc))
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
      ClearReadOnly(pszDestSpec);
      itoa(++iFileCount,&szFileNumber[iEnd],10);
      PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,pszDestSpec);
      }
    }
  stCOMiCFG.bInstallCOMscope = bCopyCOMscope;
  if (bCopyCOMscope)
    {
    stCOMiCFG.bInstallCOMscope = TRUE;
    bCopyLibraries = TRUE;
    szCOMscopeEXEname[0] = 0;
    strcpy(pszDestSpec,pszAppsPath);
    iDestPathEnd = strlen(pszDestSpec);
    pszDestSpec[iDestPathEnd++] = '\\';
    pszDestSpec[iDestPathEnd] = 0;
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
        strcpy(&pszDestSpec[iDestPathEnd],szFileName);
        strcpy(&pszSourceSpec[iSourcePathEnd],szFileName);
        PrintProgress(szFileName,pszDestSpec);
        if (!CopyFile(pszSourceSpec,pszDestSpec))
          {
          bSuccess = FALSE;
          if (!DisplayCopyError(szFileName,pszDestSpec,rc))
            goto gtFreePathMem;
          }
        itoa(++iFileCount,&szFileNumber[iEnd],10);
        PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,pszDestSpec);
        }
      }
    }
  if (bCopyUtil)
    {
    strcpy(pszDestSpec,pszAppsPath);
    iDestPathEnd = strlen(pszDestSpec);
    pszDestSpec[iDestPathEnd++] = '\\';
    pszDestSpec[iDestPathEnd] = 0;
    strcpy(szFileKey,"File_");
    iCountPos = strlen(szFileKey);
    ulFileCount = 0;
    PrfQueryProfileData(hSourceProfile,"Utilities","Files",&ulFileCount,&cbDataSize);
    for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
      {
      itoa(iIndex,&szFileKey[iCountPos],10);
      if (PrfQueryProfileString(hSourceProfile,"Utilities",szFileKey,0,szFileName,18) != 0)
        {
        strcpy(&pszDestSpec[iDestPathEnd],szFileName);
        strcpy(&pszSourceSpec[iSourcePathEnd],szFileName);
        PrintProgress(szFileName,pszDestSpec);
        if ((rc = DosCopy(pszSourceSpec,pszDestSpec,DCPY_EXISTING)) != NO_ERROR)
          {
          bSuccess = FALSE;
          if (!DisplayCopyError(szFileName,pszDestSpec,rc))
            goto gtFreePathMem;
          }
        ClearReadOnly(pszDestSpec);
        itoa(++iFileCount,&szFileNumber[iEnd],10);
        PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,pszDestSpec);
        }
      }
    }
  if (bCopyInstall)
    {
    bCopyLibraries = TRUE;
    szInstallEXEname[0] = 0;
    strcpy(pszDestSpec,pszAppsPath);
    iDestPathEnd = strlen(pszDestSpec);
    pszDestSpec[iDestPathEnd++] = '\\';
    pszDestSpec[iDestPathEnd] = 0;
    sprintf(&pszDestSpec[iDestPathEnd],szIniFileName);
    strcpy(&pszSourceSpec[iSourcePathEnd],szIniFileName);
    PrfCloseProfile(hSourceProfile);
    DosCopy(pszSourceSpec,pszDestSpec,DCPY_EXISTING);
    ClearReadOnly(pszDestSpec);
    hSourceProfile = PrfOpenProfile(habAnchorBlock,pszSourceIniPath);
    itoa(++iFileCount,&szFileNumber[iEnd],10);
    PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,pszDestSpec);
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
        strcpy(&pszDestSpec[iDestPathEnd],szFileName);
        strcpy(&pszSourceSpec[iSourcePathEnd],szFileName);
        PrintProgress(szFileName,pszDestSpec);
        if (!CopyFile(pszSourceSpec,pszDestSpec))
          {
//          bSuccess = FALSE;
          if (!DisplayCopyError(szFileName,pszDestSpec,rc))
            goto gtFreePathMem;
          }
        itoa(++iFileCount,&szFileNumber[iEnd],10);
        PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,pszDestSpec);
        }
      }
    }
  if ((bCopyLibraries) && (pszDLLpath != NULL))
    {
    if (!bLibsDirCreated)
      if (!MakePath(hwndFrame,pszDLLpath))
        return(FALSE);
    bLibsDirCreated = TRUE;
    strcpy(pszDestSpec,pszDLLpath);
    iDestPathEnd = strlen(pszDestSpec);
    pszDestSpec[iDestPathEnd++] = '\\';
    pszDestSpec[iDestPathEnd] = 0;
    strcpy(szFileKey,"File_");
    iCountPos = strlen(szFileKey);
    ulFileCount = 0;
    PrfQueryProfileData(hSourceProfile,"Libraries","Files",&ulFileCount,&cbDataSize);
    for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
      {
      itoa(iIndex,&szFileKey[iCountPos],10);
      if (PrfQueryProfileString(hSourceProfile,"Libraries",szFileKey,0,szFileName,18) != 0)
        {
        strcpy(&pszDestSpec[iDestPathEnd],szFileName);
        strcpy(&pszSourceSpec[iSourcePathEnd],szFileName);
        PrintProgress(szFileName,pszDestSpec);
        if ((rc = DosCopy(pszSourceSpec,pszDestSpec,0L)) != NO_ERROR)
          {
          switch (CompareFileDate(pszSourceSpec,pszDestSpec))
            {
            case MBID_YES:
              if ((rc = DosCopy(pszSourceSpec,pszDestSpec,DCPY_EXISTING)) != NO_ERROR)
                {
                bSuccess = FALSE;
                if (!DisplayCopyError(szFileName,pszDestSpec,rc))
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
        ClearReadOnly(pszDestSpec);
        itoa(++iFileCount,&szFileNumber[iEnd],10);
        PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,pszDestSpec);
        }
      }
    if (!bBaseLibrariesCopied)
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
          strcpy(&pszDestSpec[iDestPathEnd],szFileName);
          strcpy(&pszSourceSpec[iSourcePathEnd],szFileName);
          PrintProgress(szFileName,pszDestSpec);
          if ((rc = DosCopy(pszSourceSpec,pszDestSpec,0L)) != NO_ERROR)
            {
            switch (CompareFileDate(pszSourceSpec,pszDestSpec))
              {
              case MBID_YES:
                if ((rc = DosCopy(pszSourceSpec,pszDestSpec,DCPY_EXISTING)) != NO_ERROR)
                  {
                  bSuccess = FALSE;
                  if (!DisplayCopyError(szFileName,pszDestSpec,rc))
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
          ClearReadOnly(pszDestSpec);
          itoa(++iFileCount,&szFileNumber[iEnd],10);
          PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,pszDestSpec);
          }
        }
      if (bSuccess)
        bBaseLibrariesCopied = TRUE;
      }
   if (bLibsDirCreated)
      {
      strcpy(pszDestSpec,pszAppsPath);
      iDestPathEnd = strlen(pszDestSpec);
      pszDestSpec[iDestPathEnd++] = '\\';
      pszDestSpec[iDestPathEnd] = 0;
      sprintf(&pszDestSpec[iDestPathEnd],szIniFileName);
      PrfWriteProfileString(hInstalledProfile,"Installed","Library Path",pszDLLpath);
      }
    }
  PrfWriteProfileString(hInstalledProfile,"Installed","Program Path",pszAppsPath);
  PrfWriteProfileData(hInstalledProfile,"Installed","Files",&iFileCount,sizeof(int));
  if (bBaseLibrariesCopied)
    {
    MemAlloc(&pszConfigLibrarySpec,ulMaxPathLen);
    if (pszPDRpath != NULL)
      sprintf(pszConfigLibrarySpec,"%s\\%s",pszPDRpath,szConfigLibraryName);
    else
      if (pszDLLpath != NULL)
        sprintf(pszConfigLibrarySpec,"%s\\%s",pszDLLpath,szConfigLibraryName);
    PrfWriteProfileString(HINI_USERPROFILE,"COMi","Configuration",pszConfigLibrarySpec);
    if (szConfigHelpFileName[0] != 0)
      {
      sprintf(pszPath,"%s\\%s",pszAppsPath,szConfigHelpFileName);
      PrfWriteProfileString(HINI_USERPROFILE,"COMi","Help",pszPath);
      }
    bFilesCopied = TRUE;
    MenuItemEnable(hwndFrame,IDM_SETUP,TRUE);
    }
  if (bCreateObjects)
    {
    bObjectBad = FALSE;
    strcpy(szFileNumber,"Object_");
    iEnd = strlen(szFileNumber);
    hObject = WinCreateObject("WPFolder",szFolderName,szFolderSetup,"<WP_DESKTOP>",CO_UPDATEIFEXISTS);
    if (hObject == 0)
      {
      sprintf(&szFolderName[strlen(szFolderName)],":1");
      hObject = WinCreateObject("WPFolder",szFolderName,szFolderSetup,"<WP_DESKTOP>",CO_UPDATEIFEXISTS);
      }
    if (hObject != 0)
      {
      itoa(++iObjectCount,&szFileNumber[iEnd],10);
      PrfWriteProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,sizeof(HOBJECT));
      MemAlloc(&pszSetupString,(CCHMAXPATH * 3));
      pszDestSpec[iDestPathEnd - 1] = 0;
      sprintf(pszPath,"<%s>",szFolderName);
      strcpy(szFolderName,pszPath);
      if (szCOMiINFname[0] != 0)
        {
        sprintf(pszSetupString,"%sEXENAME=VIEW.EXE;PARAMETERS=%s\\%s",szINFobjectSetup,pszDestSpec,szCOMiINFname);
        sprintf(pszPath,"%s Users Guide",szConfigName);
        hObject = WinCreateObject("WPProgram",pszPath,pszSetupString,szFolderID,CO_UPDATEIFEXISTS);
        if (hObject != 0)
          {
          itoa(++iObjectCount,&szFileNumber[iEnd],10);
          PrfWriteProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,sizeof(HOBJECT));
          }
        else
          bObjectBad = TRUE;
        }
#ifdef this_junk
      if (szQuickPageEXEname[0] != 0)
        {
        sprintf(pszSetupString,"%sEXENAME=%s\\%s;STARTUPDIR=%s;PARAMETERS=% /MSG:\"[Message: ]\" /CFG:\"PAGEDEF.CFG\"",szProgramObjectSetup,pszDestSpec,szQuickPageEXEname,pszDestSpec);
        hObject = WinCreateObject("WPProgram","QuickPage",pszSetupString,szFolderID,CO_UPDATEIFEXISTS);
        if (hObject != 0)
          {
          itoa(++iObjectCount,&szFileNumber[iEnd],10);
          PrfWriteProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,sizeof(HOBJECT));
          }
        else
          bObjectBad = TRUE;
        sprintf(pszSetupString,"%sEXENAME=%s\\%s;STARTUPDIR=%s;PARAMETERS=% /MSG:\"[Message: ]\" /CFG:\"%*\"",szProgramObjectSetup,pszDestSpec,szPagerEXEname,pszDestSpec);
        hObject = WinCreateObject("WPProgram","QuickPageDrop",pszSetupString,szFolderID,CO_UPDATEIFEXISTS);
        if (hObject != 0)
          {
          itoa(++iObjectCount,&szFileNumber[iEnd],10);
          PrfWriteProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,sizeof(HOBJECT));
          }
        else
          bObjectBad = TRUE;
        }
#endif
      if (szCOMscopeEXEname[0] != 0)
        {
        sprintf(pszSetupString,"%sEXENAME=%s\\%s;STARTUPDIR=%s",szProgramObjectSetup,pszDestSpec,szCOMscopeEXEname,pszDestSpec);
        if (bCopyUtil)
          strcat(pszSetupString,";PARAMETERS=/S /T");
        hObject = WinCreateObject("WPProgram","COMscope",pszSetupString,szFolderID,CO_UPDATEIFEXISTS);
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
        sprintf(pszSetupString,"%sEXENAME=%s\\%s;STARTUPDIR=%s",szProgramObjectSetup,pszDestSpec,szInstallEXEname,pszDestSpec);
        hObject = WinCreateObject("WPProgram","OS/tools Install",pszSetupString,szFolderID,CO_UPDATEIFEXISTS);
        if (hObject != 0)
          {
          itoa(++iObjectCount,&szFileNumber[iEnd],10);
          PrfWriteProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,sizeof(HOBJECT));
          }
        else
          bObjectBad = TRUE;
        }
      MemFree(pszSetupString);
      PrfWriteProfileData(hInstalledProfile,"Installed","Objects",&iObjectCount,sizeof(int));
      }
    }
  if (bObjectBad || (hObject == 0))
    {
    sprintf(szMessage,"At least one desktop object was not created due to an unknown system error.");
    sprintf(szCaption,"Object(s) Not Created!");
    WinMessageBox(HWND_DESKTOP,
                  hwndClient,
                  szMessage,
                  szCaption,
                  0,
                 (MB_MOVEABLE | MB_OK));
    }
gtFreePathMem:
  PrfCloseProfile(hInstalledProfile);
  MemFree(pszInstalledIniPath);
  MemFree(pszSourceSpec);
  MemFree(pszDestSpec);
  return(bSuccess);
  }

BOOL CopyFile(char *pszSourceSpec,char *pszDestSpec)
  {
  FILESTATUS3 stFileStatus;
  APIRET rc;

  if ((rc = DosCopy(pszSourceSpec,pszDestSpec,DCPY_EXISTING)) != NO_ERROR)
    {
    if (rc == ERROR_ACCESS_DENIED)
      {
      if (DosQueryPathInfo(pszDestSpec,1,&stFileStatus,sizeof(FILESTATUS3)) == NO_ERROR)
        {
        if (stFileStatus.attrFile & FILE_HIDDEN)
          {
          stFileStatus.attrFile &= ~FILE_HIDDEN;
          DosSetPathInfo(pszDestSpec,1,&stFileStatus,sizeof(FILESTATUS3),0);
          if ((rc = DosCopy(pszSourceSpec,pszDestSpec,DCPY_EXISTING)) != NO_ERROR)
            return(FALSE);
          }
        }
      else
        return(FALSE);
      }
    else
      return(FALSE);
    }
  ClearReadOnly(pszDestSpec);
  return(TRUE);
  }

void ClearReadOnly(char szFileSpec[])
  {
  ULONG ulAttr;

  _dos_getfileattr(szFileSpec,&ulAttr);
  if (ulAttr & _A_RDONLY)
    {
    ulAttr &= !_A_RDONLY;
    _dos_setfileattr(szFileSpec,ulAttr);
    }
  }

