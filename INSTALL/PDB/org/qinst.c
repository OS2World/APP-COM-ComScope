#include <COMMON.H>

char szFolderName[60] = "OS/tools\r\nUtilities";
char szFolderSetup[] = "OBJECTID=<OS/tools_1833>";
char szFolderID[] = "<OS/tools_1833>";
char szProgramObjectSetup[] = "NOAUTOCLOSE=NO;PROGTYPE=PM;";
char szINFobjectSetup[] = "DEFAULTVIEW=RUNNING;NOPRINT=YES;PROGTYPE=PM;";
char szAppName[40] = "COMi";
char szInstallIniFileName[] = "INST LST.INI";
char szIniFileName[] = "OS_TOOLS.INI";

char szSetupString[500];
HOBJECT hObject;

char szDDversion[200];
char szConfigHelp[40];
char szDestination[CCHMAXPATH + 1];
char szSource[CCHMAXPATH + 1];
char chBootDrive = 'C';
char szRemoveDD[80];
char szOriginalDD[CCHMAXPATH + 1];
char szDDname[20];
char szDeletePath[CCHMAXPATH];
char szPath[CCHMAXPATH + 1];
char szINFname[40];
char szConfigName[40];
char szDDnameRoot[20];

char szSourceSpec[CCHMAXPATH + 1];
char szDestSpec[CCHMAXPATH + 1];
char szCOMiINFname[CCHMAXPATH + 1];
char szConfigEXEname[CCHMAXPATH + 1];

char szFileKey[40];
int iEnd;
int iLoadCount;
int iDestPathEnd;
int iSourcePathEnd;

BOOL bCreateObjects = TRUE;
BOOL bCopyConfigFiles = TRUE;

BOOL CopyFile(char szSourceSpec[],char szDestSpec[]);
void AppendINI(char szFileSpec[]);
BOOL AdjustConfigSys(char szDestPath[],char szDDname[],char szRemoveDD[],char szOriginalDD[],ULONG ulLoadCount);
BOOL MakePath(char szPath[]);
void SetEndOfPath(char szPath[]);
BOOL CreatePath(char szPath[]);

void main(int argc,char *argv[])
  {
  int iIndex;
  ULONG ulBootDrive;
  HINI hInstalledProfile;
  HINI hSourceProfile;
  ULONG ulFileCount;
  ULONG cbDataSize;
  char szFileName[40];
  APIRET rc;
  int iFileCount = 0;
  int iObjectCount = 0;
  ULONG ulNewLevel;
  char chPrefix;
  ULONG ulAppSize;

  strcpy(szSource,argv[0]);

  if (argc >= 2)
    {
    for (iIndex = 1;iIndex < argc;iIndex++)
      {
      chPrefix = argv[iIndex][0];
      if ((chPrefix == '/') || (chPrefix == '+') || (chPrefix == '-'))
        {
        if (argv[iIndex][1] == '?')
          {
          printf("Usage:  QINST <+|->O <+|->C /A'app name' /D'destination path'\n\n");
          printf("  +O -> create desktop Objects (default)\n  -O -> do not create desktop Objects\n");
          printf("  +C -> transfer Configuration files (default)\n  -C -> do not transfer Configuration files\n");
          printf("  /A -> Application to install, default = 'COMi', name is case sensitive\n");
          printf("  /D -> absolute Destination path, default = 'd:\\COMi'\n        where 'd:' is forced to the boot drive\n");
          DosExit(1,0);
          }
        else
          switch (argv[iIndex][1] & 0xdf)
            {
            case 'D':
              if (argv[iIndex][2] == 0)
                strcpy(szDestination,argv[++iIndex]);
              else
                strcpy(szDestination,&argv[iIndex][2]);
              if (szDestination[strlen(szDestination) - 1] == '\\')
                szDestination[strlen(szDestination) - 1] = 0;
              break;
            case 'A':
              if (argv[iIndex][2] == 0)
                strcpy(szAppName,argv[++iIndex]);
              else
                strcpy(szAppName,&argv[iIndex][2]);
              break;
            case 'O':
              if (chPrefix == '-')
                bCreateObjects = FALSE;
              break;
            case 'C':
              if (chPrefix == '-')
                bCopyConfigFiles = FALSE;
              break;
            }
        }
      }
    }

  printf("\nUse '/?' parameter for command line help\n");

  DosQuerySysInfo(QSV_BOOT_DRIVE,QSV_BOOT_DRIVE,&ulBootDrive,sizeof(ULONG));
  chBootDrive = ('A' + (char)ulBootDrive - 1);

  SetEndOfPath(szSource);
  sprintf(szPath,"%s\\%s",szSource,szIniFileName);

  hSourceProfile = PrfOpenProfile(0,szPath);
  PrfQueryProfileSize(hSourceProfile,0L,0L,&ulAppSize);
  if (ulAppSize == 0)
    {
    printf("\n%s is an invalid Profile!\n",szPath);
    PrfCloseProfile(hSourceProfile);
    DosExit(1,400);
    }

  if (hSourceProfile != 0)
    {
    PrfQueryProfileSize(hSourceProfile,szAppName,0L,&ulAppSize);
    if (ulAppSize == 0)
      {
      printf("\n%s is an invalid application!\n",szAppName);
      PrfCloseProfile(hSourceProfile);
      DosExit(1,401);
      }
    PrfQueryProfileString(hSourceProfile,szAppName,"Remove DD",0,szRemoveDD,80);
    if (strlen(szDestination) == 0)
      PrfQueryProfileString(hSourceProfile,szAppName,"Destination","C:\\COMi",szDestination,CCHMAXPATH);
    PrfQueryProfileString(hSourceProfile,szAppName,"Install DD","COMDD.SYS",szDDname,18);
    PrfQueryProfileString(hSourceProfile,szAppName,"DD Name","COMDD.SYS",szDDnameRoot,18);
    PrfQueryProfileString(hSourceProfile,szAppName,"Delete",0,szDeletePath,CCHMAXPATH);
    PrfQueryProfileString(hSourceProfile,szAppName,"INF",0,szINFname,40);
    PrfQueryProfileString(hSourceProfile,szAppName,"Config",0,szConfigName,40);
    PrfQueryProfileString(hSourceProfile,szAppName,"Version",0,szDDversion,200);
    PrfQueryProfileString(hSourceProfile,szAppName,"Config Help","CONFIG.HLP",szConfigHelp,40);
    PrfQueryProfileString(hSourceProfile,szAppName,"Original DD",0,szOriginalDD,CCHMAXPATH);
    if (!PrfQueryProfileData(hSourceProfile,szAppName,"Load Count",&iLoadCount,&cbDataSize))
      iLoadCount = 1;
    }

  szDestination[0] = chBootDrive;

  iEnd = sprintf(szFileKey,"File_");
  strcpy(szDestSpec,szDestination);
  iDestPathEnd = strlen(szDestSpec);
  szDestSpec[iDestPathEnd++] = '\\';
  szDestSpec[iDestPathEnd] = 0;
  strcpy(szSourceSpec,szSource);
  iSourcePathEnd = strlen(szSourceSpec);
  szSourceSpec[iSourcePathEnd++] = '\\';

  if (!MakePath(szDestination))
    DosExit(1,1);
  cbDataSize = sizeof(ULONG);
  if (PrfQueryProfileData(hSourceProfile,szAppName,"Files",&ulFileCount,&cbDataSize) &&
                     (ulFileCount > 0))
    {
    sprintf(szPath,"%s\\%s",szDestination,szInstallIniFileName);
    hInstalledProfile = PrfOpenProfile(0,szPath);
    for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
      {
      if (iIndex == 3)
        if (!bCopyConfigFiles)
          break;
      itoa(iIndex,&szFileKey[iEnd],10);
      if (PrfQueryProfileString(hSourceProfile,szAppName,szFileKey,0,szFileName,18) != 0)
        {
        strcpy(&szDestSpec[iDestPathEnd],szFileName);
        strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
        printf("Copying %s to %s\n",szFileName,szDestSpec);
        if (!CopyFile(szSourceSpec,szDestSpec))
          {
          if (iIndex == 1)
            printf("\nThe COMi initialization file is missing from the source diskette.\n");
          else
            printf("\nTransfer of %s failed.\n",szDestSpec);
          DosExit(1,2);
          }
        if (hInstalledProfile != 0)
          {
          itoa(++iFileCount,&szFileKey[iEnd],10);
          PrfWriteProfileString(hInstalledProfile,"Installed",szFileKey,szDestSpec);
          }
        }
      }
    }
  szDestSpec[iDestPathEnd] = 0;
  if (strlen(szOriginalDD) != 0)
    szOriginalDD[0] = chBootDrive;
  AdjustConfigSys(szDestination,szDDname,szRemoveDD,szOriginalDD,(ULONG)iLoadCount);
  if (bCreateObjects && ((bCopyConfigFiles && strlen(szConfigName)) || strlen(szINFname)))
    {
    strcpy(szFileKey,"Object_");
    iEnd = strlen(szFileKey);
    hObject = WinCreateObject("WPFolder",szFolderName,szFolderSetup,"<WP_DESKTOP>",CO_UPDATEIFEXISTS);
    if (hObject == 0)
      {
      sprintf(&szFolderName[strlen(szFolderName)],":1");
      hObject = WinCreateObject("WPFolder",szFolderName,szFolderSetup,"<WP_DESKTOP>",CO_UPDATEIFEXISTS);
      }
    if (hObject != 0)
      {
      itoa(++iObjectCount,&szFileKey[iEnd],10);
      PrfWriteProfileData(hInstalledProfile,"Installed",szFileKey,&hObject,sizeof(HOBJECT));
      printf("OS/tools Utilities folder created\n");
      szDestSpec[iDestPathEnd - 1] = 0;
      sprintf(szPath,"<%s>",szFolderName);
      strcpy(szFolderName,szPath);
      if (szINFname[0] != 0)
        {
        sprintf(szSetupString,"%sEXENAME=VIEW.EXE;PARAMETERS=%s\\%s",szINFobjectSetup,szDestSpec,szINFname);
        sprintf(szPath,"%s Users Guide",szAppName);
        hObject = WinCreateObject("WPProgram",szPath,szSetupString,szFolderID,CO_UPDATEIFEXISTS);
        if (hObject != 0)
          {
          itoa(++iObjectCount,&szFileKey[iEnd],10);
          PrfWriteProfileData(hInstalledProfile,"Installed",szFileKey,&hObject,sizeof(HOBJECT));
          printf("Users Guide object created\n");
          }
        }
      if (bCopyConfigFiles && (szConfigName[0] != 0))
        {
        sprintf(szPath,"%s Configuration",szDDnameRoot);
        sprintf(szSetupString,"%sEXENAME=%s\\%s;STARTUPDIR=%s",szProgramObjectSetup,szDestSpec,szConfigName,szDestSpec);
        hObject = WinCreateObject("WPProgram",szPath,szSetupString,szFolderID,CO_UPDATEIFEXISTS);
        if (hObject != 0)
          {
          itoa(++iObjectCount,&szFileKey[iEnd],10);
          PrfWriteProfileData(hInstalledProfile,"Installed",szFileKey,&hObject,sizeof(HOBJECT));
          printf("Device driver configuration object created\n");
          }
        }
      if (iObjectCount != 0)
        PrfWriteProfileData(hInstalledProfile,"Installed","Objects",&iObjectCount,sizeof(int));
      }
    }
  PrfWriteProfileString(HINI_USERPROFILE,"COMi","Version",szDDversion);
  sprintf(szPath,"%s\\%s",szDestination,szDDname);
  AppendINI(szPath);
  PrfWriteProfileString(HINI_USERPROFILE,"COMi","Initialization",szPath);
  if (bCopyConfigFiles)
    {
    sprintf(szPath,"%s\\%s",szDestination,szConfigHelp);
    PrfWriteProfileString(HINI_USERPROFILE,"COMi","Help",szPath);
    sprintf(szPath,"%s\\%s",szDestination,"COMi_CFG.DLL");
    PrfWriteProfileString(HINI_USERPROFILE,"COMi","Configuration",szPath);
    }
  PrfWriteProfileString(hInstalledProfile,"Installed","Program Path",szDestination);
  PrfWriteProfileData(hInstalledProfile,"Installed","Files",&iFileCount,sizeof(int));
  PrfCloseProfile(hSourceProfile);
  if (hInstalledProfile != 0)
    PrfCloseProfile(hInstalledProfile);
  sprintf(szPath,"%s\\%s",szDestination,szIniFileName);
  hSourceProfile = PrfOpenProfile(0,szPath);
  ulNewLevel = 2;
  PrfWriteProfileData(hSourceProfile,"Install","bConfigurationOnly",&ulNewLevel,sizeof(ULONG));
  PrfCloseProfile(hSourceProfile);
  DosBeep(600,500);
  printf("\nOS/tools' Quick Installation Completed\n");
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
//  ClearReadOnly(szDestSpec);
  return(TRUE);
  }

void SetEndOfPath(char szPath[])
  {
  int iIndex;

  for (iIndex = strlen(szPath);iIndex >= 0;iIndex--)
    {
    if (szPath[iIndex] == '\\')
      {
      szPath[iIndex] = 0;
      break;
      }
    if (szPath[iIndex] == ':')
      {
      szPath[iIndex + 1] = 0;
      break;
      }
    }
  }

void AppendINI(char szFileSpec[])
  {
  WORD wIndex = 0;

  while (szFileSpec[wIndex++] != 0);
  while (szFileSpec[--wIndex] != '.')
    {
    if (wIndex == 0)
      {
      while (szFileSpec[wIndex++] != 0);
      szFileSpec[--wIndex] = '.';
      break;
      }
    }
  szFileSpec[++wIndex] = 'I';
  szFileSpec[++wIndex] = 'N';
  szFileSpec[++wIndex] = 'I';
  szFileSpec[++wIndex] = 0;
  }

ULONG ReadConfigSys(char szFileSpec[],HFILE *phFile,char **ppBuffer)
  {
  ULONG ulStatus;
  FILESTATUS3 stFileInfo;
  ULONG ulCount;
  char szMessage[CCHMAXPATH];
  APIRET rc;

  if ((rc = DosOpen(szFileSpec,phFile,&ulStatus,0L,0,1,0x0022,(PEAOP2)0L)) != 0)
		{
		printf(szMessage,"\nCould not open %s - Error = %u\n",szFileSpec,rc);
    return(0);
    }
  DosQueryFileInfo(*phFile,1,&stFileInfo,sizeof(FILESTATUS3));
  ulCount = stFileInfo.cbFile;
  if ((rc = DosAllocMem((PVOID)ppBuffer,(ulCount + 10),(PAG_COMMIT | PAG_READ | PAG_WRITE))) != NO_ERROR)
    {
    printf("\nUnable to Allocate memory to read CONFIG.SYS - %u\n",rc);
    DosClose(*phFile);
    return(0);
    }
  if (DosRead(*phFile,(PVOID)*ppBuffer,ulCount,&ulCount) != 0)
    {
		DosFreeMem(*ppBuffer);
    DosClose(*phFile);
    return(0);
    }
  return(ulCount);
  }

ULONG FindLineWith(char szThisString[],char *pszBuffer,ULONG ulOffset,ULONG *pulCount)
  {
  ULONG ulCount;
  ULONG ulIndex = ulOffset;
  ULONG ulStartOffset;
  int iIndex;
  static ULONG ulLen;
  ULONG ulLineIndex;
  char chChar = 0xff;
  char *pchLine;

  if (DosAllocMem((PVOID)&pchLine,4096,(PAG_COMMIT | PAG_READ | PAG_WRITE)) != NO_ERROR)
    return(0);
  ulLen = strlen(szThisString);
  while (chChar != 0)
    {
    ulCount = 1;
    ulStartOffset = ulIndex;
    ulLineIndex = 0;
    chChar = pszBuffer[ulIndex++];
    while((chChar == ' ') || (chChar  == '\t'))
      {
      chChar = pszBuffer[ulIndex++];
      ulCount++;
      }
    while (chChar != 0)
      {
      if (chChar == '\x0a')
        break;
      if (ulLineIndex >= 4096)
        {
        DosFreeMem(pchLine);
        return(ulIndex);
        }
      pchLine[ulLineIndex++] = chChar;
      chChar = pszBuffer[ulIndex++];
      ulCount++;
      }
    if (ulLen <= ulLineIndex)
      {
      if (strnicmp("REM ",pchLine,4) != 0)
        for (iIndex =0;iIndex < (ulLineIndex - ulLen);iIndex++)
          if (strnicmp(szThisString,&pchLine[iIndex],ulLen) == 0)
            {
            *pulCount = ulCount;
            DosFreeMem(pchLine);
            return(ulStartOffset);
            }
      }
    }
  DosFreeMem(pchLine);
  return(0);
	}

BOOL AdjustConfigSys(char szDestPath[],char szDDname[],char szRemoveDD[],char szOriginalDD[],ULONG ulLoadCount)
  {
  HFILE hFile;
  ULONG ulCount;
  char *pchFile;
  char *pchNew;
  char szLine[CCHMAXPATH + 1];
  ULONG ulIndex;
  ULONG ulLength;
	int iLen;
  APIRET rc;
  ULONG ulFilePosition;
//  ULONG flStyle;
  ULONG ulOffset;
  ULONG ulAddOffset;
  ULONG ulFileSize;
  BOOL bFileChanged = FALSE;
  ULONG ulStatus;
//  char szFileSpec[] = "C:\\CONFIG.sss";
  char szFileSpec[] = "C:\\CONFIG.SYS";
  char szBackupSpec[] = "C:\\CONFIG.OST";


  szFileSpec[0] = chBootDrive;
  szBackupSpec[0] = chBootDrive;
  if ((ulCount = ReadConfigSys(szFileSpec,&hFile,&pchFile)) == 0)
    {
    printf("\nUnable to open %s\n",szFileSpec);
    return(FALSE);
    }
	DosClose(hFile);
  if (pchFile[ulCount - 1] == '\x1a')
    ulCount--;
  pchFile[ulCount] = 0;
  ulFileSize = ulCount;
  if (DosAllocMem((PVOID)&pchNew,(ulCount * 2),(PAG_COMMIT | PAG_READ | PAG_WRITE)) != NO_ERROR)
    {
    printf("\nUnable to allocate memory to modify %s\n",szFileSpec);
    DosFreeMem(pchFile);
  	DosClose(hFile);
    return(FALSE);
    }
  memcpy(pchNew,pchFile,ulCount);
  if (strlen(szRemoveDD) != 0)
    {
  	ulOffset = 0;
    ulAddOffset = 4;
	  while ((ulOffset = FindLineWith(szRemoveDD,pchFile,ulOffset,&ulLength)) != 0)
		  {
      bFileChanged = TRUE;
      memcpy(&pchNew[ulOffset + ulAddOffset],&pchFile[ulOffset],(ulCount - ulOffset));
      memcpy(&pchNew[ulOffset + (ulAddOffset - 4)],"REM ",4);
      ulFileSize += 4;
      pchNew[ulFileSize] = 0;
      ulOffset += ulLength;
      ulAddOffset += 4;
      }
    }
  if (szOriginalDD)
    {
    ulOffset = 0;
    if (FindLineWith(szOriginalDD,pchFile,ulOffset,&ulLength) == 0)
      {
      bFileChanged = TRUE;
      iLen = sprintf(szLine,"%c%cDEVICE=%s\x0d\x0a",'\x0d','\x0a',szOriginalDD);
      memcpy(&pchNew[ulFileSize],szLine,iLen);
      ulFileSize += iLen;
      }
    }
  if (ulLoadCount != 0)
    {
    ulOffset = 0;
    if (FindLineWith(szDDname,pchFile,ulOffset,&ulLength) == 0)
      {
      bFileChanged = TRUE;
      iLen = sprintf(szLine,"%c%cDEVICE=%s\\%s\x0d\x0a",'\x0d','\x0a',szDestPath,szDDname);
      for (ulIndex = 0;ulIndex < iLoadCount;ulIndex++)
        {
        memcpy(&pchNew[ulFileSize],szLine,iLen);
        ulFileSize += iLen;
        }
      }
    }
  if (bFileChanged)
    {
    DosCopy(szFileSpec,szBackupSpec,DCPY_EXISTING);
    printf("Current CONFIG.SYS copied to %s\nModifying %s\n",szBackupSpec,szFileSpec);
    pchNew[ulFileSize++] = '\x1a';
    if ((rc = DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0022,(PEAOP2)0L)) == NO_ERROR)
      {
      DosSetFileSize(hFile,ulFileSize);
      DosSetFilePtr(hFile,0L,0L,&ulFilePosition);
      DosWrite(hFile,pchNew,ulFileSize,&ulCount);
    	DosClose(hFile);
      }
    else
  		printf("\nUnable to save new %s - Error = %u\n",szFileSpec,rc);
    }
  DosFreeMem(pchNew);
  DosFreeMem(pchFile);
  return(TRUE);
	}

BOOL MakePath(char szPath[])
  {
  APIRET rc;
  FILESTATUS3 stFileStatus;

  if ((rc = DosQueryPathInfo(szPath,FIL_STANDARD,&stFileStatus,sizeof(FILESTATUS3))) != NO_ERROR)
    {
    if ((rc == ERROR_PATH_NOT_FOUND) || (rc == ERROR_FILE_NOT_FOUND) )
      {
      printf("\nCreating Directory %s\n",szPath);
      if (!CreatePath(szPath))
        {
        printf("\nUnable to create the directory %s\n",szPath);
        return(FALSE);
        }
      }
    }
  else
    if ((stFileStatus.attrFile & FILE_DIRECTORY) == 0)
      {
      printf("\nInvalid Path Specification!\n");
      printf("%s is a file.\nPlease select another destination directory.\n  EX:\n    [C:\]QINST /DC:\\COMM\n      Where \"C:\\COMM\" is new destination path\n",szPath);
      return(FALSE);
      }
  return(TRUE);
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


