#include "install.h"
//#include "..\help.h"
#include <CONFIG.H>

void ClearReadOnly(char szFileSpec[]);
BOOL CopyFile(char *szSourceSpec,char *szDestSpec);
USHORT CompareFileDate(char szSourceFileSpec[],char szDestFileSpec[]);
BOOL DisplayCopyError(char szSource[],char szDest[],APIRET rcErrorCode);

char szFolderName[60] = "OS/tools\r\nUtilities";
char szFolderSetup[] = "OBJECTID=<OS/tools_1833>";
char szFolderID[] = "<OS/tools_1833>";
char szProgramObjectSetup[] = "NOAUTOCLOSE=NO;PROGTYPE=PM;";
char szINFobjectSetup[] = "DEFAULTVIEW=RUNNING;NOPRINT=YES;PROGTYPE=PM;";
char szPagerEXEname[40];
char szInstallEXEname[40];
char szCOMiINFname[40];
char szSetupString[800];
char szPDRpath[CCHMAXPATH];
BOOL bLibsDirCreated = FALSE;
char szFileKey[20];
char szMessage[80];
char szCaption[40];
char szDestSpec[CCHMAXPATH];
char szSourceSpec[CCHMAXPATH];
char szFileName[80];
char szInstalledIniPath[CCHMAXPATH];
FILESTATUS3 stFileStatus;
BOOL bCopyLibraries = FALSE;
ULONG ulInstalledFileStart;
ULONG ulInstalledObjectStart;
ULONG ulAttr;
char szPath[CCHMAXPATH];
char szObjectName[60];

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

BOOL APIENTRY InstallPager(INSTALL *pstInst)
  {
  int iIndex;
  int iCountPos;
  int iDestPathEnd;
  int iSourcePathEnd;
  APIRET rc;
  BOOL bSuccess = TRUE;
  HPOINTER hPointer;
//  int iLen;
  int iFileCount;
  int iObjectCount;
  int iEnd;
  HOBJECT hObject;
  HOBJECT *phObject;
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

  szPagerEXEname[0] = 0;
  szInstallEXEname[0] = 0;

  sprintf(szInstalledIniPath,"%s%s",szDestSpec,pstInst->paszStrings[UNINSTALLINIFILENAME]);
  if (!MakePath(pstInst->hwndFrame,pstInst->pszAppsPath))
   return(FALSE);
  hInstalledProfile = PrfOpenProfile(pstInst->hab,szInstalledIniPath);
  cbDataSize = sizeof(ULONG);
  if (!PrfQueryProfileData(hInstalledProfile,"Installed","Files",&iFileCount,&cbDataSize))
    iFileCount = 0;
  if (!PrfQueryProfileData(hInstalledProfile,"Installed","Objects",&iObjectCount,&cbDataSize))
    iObjectCount = 0;
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
  if (pstInst->bCopyPager)
    {
    bCopyLibraries = TRUE;
    szPagerEXEname[0] = 0;
    strcpy(szDestSpec,pstInst->pszAppsPath);
    iDestPathEnd = strlen(szDestSpec);
    szDestSpec[iDestPathEnd++] = '\\';
    szDestSpec[iDestPathEnd] = 0;
    strcpy(szFileKey,"File_");
    iCountPos = strlen(szFileKey);
    ulFileCount = 0;
    PrfQueryProfileData(hSourceProfile,"Pager","Files",&ulFileCount,&cbDataSize);
    for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
      {
      itoa(iIndex,&szFileKey[iCountPos],10);
      if (PrfQueryProfileString(hSourceProfile,"Pager",szFileKey,0,szFileName,18) != 0)
        {
        if (iIndex == 1)
          strcpy(szPagerEXEname,szFileName);
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
    PrfWriteProfileString(HINI_USERPROFILE,pstInst->paszStrings[CONFIGAPPNAME],"Version",pstInst->paszStrings[APPVERSION]);
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
        ClearReadOnly(szDestSpec);
        itoa(++iFileCount,&szFileNumber[iEnd],10);
        PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
        }
      }
    }
  if (pstInst->bCopyInstall)
    {
    bCopyLibraries = TRUE;
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
  PrfWriteProfileString(hInstalledProfile,"Installed","Program Path",pstInst->pszAppsPath);
  PrfWriteProfileData(hInstalledProfile,"Installed","Files",&iFileCount,sizeof(int));
  if (strlen(pstInst->paszStrings[CONFIGDDLIBRARYNAME]) != 0)
    {
    sprintf(pstInst->paszStrings[CONFIGAPPLIBRARYSPEC],"%s\\%s",pstInst->pszAppsPath,pstInst->paszStrings[CONFIGDDLIBRARYNAME]);
    PrfWriteProfileString(HINI_USERPROFILE,pstInst->paszStrings[CONFIGDDNAME],"Configuration",pstInst->paszStrings[CONFIGAPPLIBRARYSPEC]);
    }
  if (strlen(pstInst->paszStrings[CONFIGDDHELPFILENAME]) != 0)
    {
    sprintf(szPath,"%s\\%s",pstInst->pszAppsPath,pstInst->paszStrings[CONFIGDDHELPFILENAME]);
    PrfWriteProfileString(HINI_USERPROFILE,pstInst->paszStrings[CONFIGDDNAME],"Help",szPath);
    }
  if (strlen(pstInst->paszStrings[CONFIGAPPLIBRARYNAME]) != 0)
    {
    sprintf(pstInst->paszStrings[CONFIGAPPLIBRARYSPEC],"%s\\%s",pstInst->pszAppsPath,pstInst->paszStrings[CONFIGAPPLIBRARYNAME]);
    PrfWriteProfileString(HINI_USERPROFILE,pstInst->paszStrings[CONFIGAPPNAME],"Configuration",pstInst->paszStrings[CONFIGAPPLIBRARYSPEC]);
    }
  if (strlen(pstInst->paszStrings[CONFIGAPPHELPFILENAME]) != 0)
    {
    sprintf(szPath,"%s\\%s",pstInst->pszAppsPath,pstInst->paszStrings[CONFIGAPPHELPFILENAME]);
    PrfWriteProfileString(HINI_USERPROFILE,pstInst->paszStrings[CONFIGAPPNAME],"Help",szPath);
    }
  pstInst->bFilesCopied = TRUE;
  MenuItemEnable(pstInst->hwndFrame,IDM_SETUP,TRUE);

  if (pstInst->bCreateObjects)
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
      szDestSpec[iDestPathEnd - 1] = 0;
      sprintf(szPath,"<%s>",szFolderName);
      strcpy(szFolderName,szPath);
      if (szCOMiINFname[0] != 0)
        {
        sprintf(szSetupString,"%sEXENAME=VIEW.EXE;PARAMETERS=%s\\%s",szINFobjectSetup,szDestSpec,pstInst->paszStrings[CONFIGDDNAME]);
        sprintf(szObjectName,"%s Users Guide",pstInst->paszStrings[CONFIGDDNAME]);
        hObject = WinCreateObject("WPProgram",szObjectName,szSetupString,szFolderID,CO_UPDATEIFEXISTS);
        if (hObject != 0)
          {
          itoa(++iObjectCount,&szFileNumber[iEnd],10);
          PrfWriteProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,sizeof(HOBJECT));
          }
        else
          bObjectBad = TRUE;
        }
      if (szPagerEXEname[0] != 0)
        {
        iEnd = sprintf(szSetupString,"%sEXENAME=%s\\%s;STARTUPDIR=%s;ASSOCFILTER=*.PAG;PARAMETERS=% /MSG:\"[Message: ]\" /CFG:\"%*\"",szProgramObjectSetup,szDestSpec,szPagerEXEname,szDestSpec);
        if (strlen(pstInst->paszStrings[APPICONFILE]) != 0)
          sprintf(&szSetupString[iEnd],";ICON=%s\\%s",pstInst->pszAppsPath,pstInst->paszStrings[APPICONFILE]);
        strcat(szObjectName,"Drop");
        hObject = WinCreateObject("WPProgram",szObjectName,szSetupString,szFolderID,CO_UPDATEIFEXISTS);
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
  FDATE fdateSourceCreation;
  char szMessage[200];
  char szCaption[40];
  APIRET rc;

  DosQueryPathInfo(szSourceFileSpec,1,&stFileInfo,sizeof(FILESTATUS3));
  fdateSourceCreation = stFileInfo.fdateCreation;
  if ((rc = DosQueryPathInfo(szDestFileSpec,1,&stFileInfo,sizeof(FILESTATUS3))) == NO_ERROR)
    {
    if (fdateSourceCreation.year > stFileInfo.fdateCreation.year)
      return(MBID_YES);
    else
      if (fdateSourceCreation.year == stFileInfo.fdateCreation.year)
        if (fdateSourceCreation.month > stFileInfo.fdateCreation.month)
          return(MBID_YES);
        else
          if (fdateSourceCreation.month == stFileInfo.fdateCreation.month)
            if (fdateSourceCreation.day >= stFileInfo.fdateCreation.day)
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

