#include <COMMON.H>
#include "utility.h"

static char const *aszCapOrdinals[] = {"Zero","One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten","Eleven","Twelve","Thirteen","Fourteen","Fifteen","Sixteen"};
static char const *aszOrdinals[] = {"zero","one","two","three","four","five","six","seven","eight","nine","ten","eleven","twelve","thirteen","fourteen","fifteen","sixteen"};
BOOL WriteConfigFile(HWND hwndParent,PSZ szFileSpec,PVOID pBuffer,ULONG cbCount);

int ReadConfigFile(HWND hwnd, char szFileSpec[],char **ppBuffer)
  {
  ULONG ulStatus;
  HFILE hFile;
  FILESTATUS3 stFileInfo;
  int iCount;
  char szMessage[CCHMAXPATH];
  APIRET rc;

  if ((rc = DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0022,(PEAOP2)0L)) != 0)
    {
    if (hwnd != NULLHANDLE)
      {
      sprintf(szMessage,"Could not open %s - Error = %u",szFileSpec,rc);
      MessageBox(HWND_DESKTOP,szMessage);
      }
    return(0);
    }
  DosQueryFileInfo(hFile,1,&stFileInfo,sizeof(FILESTATUS3));
  iCount = stFileInfo.cbFile;
  if ((rc = DosAllocMem((PVOID)ppBuffer,(iCount + 10),(PAG_COMMIT | PAG_READ | PAG_WRITE))) != NO_ERROR)
    {
    if (hwnd != NULLHANDLE)
      {
      sprintf(szMessage,"Unable to Allocate memory to read %s - %u",szFileSpec,rc);
      MessageBox(HWND_DESKTOP,szMessage);
      }
    iCount = 0;
    }
  if (DosRead(hFile,(PVOID)*ppBuffer,iCount,(ULONG *)&iCount) != 0)
    {
    DosFreeMem(*ppBuffer);
    iCount = 0;
    }
  else
    {
    /*
    ** ignore/remove EOF character, if present
    */
    if ((*ppBuffer)[(iCount) - 1] == '\x1a')
      iCount--;
    /*
    **  Add LF and CR to end of file, if not already there
    */
    if ((*ppBuffer)[iCount - 1] != '\x0a')
      {
      (*ppBuffer)[(iCount)++] = '\x0d';
      (*ppBuffer)[(iCount)++] = '\x0a';
      }
    }
  DosClose(hFile);
  return(iCount);
  }

/*
** FindLineWith
**
** Finds "szThisString" in "pszBuffer" starting at "iOffset".
**
** Returns offset of the beginning of the found line and the length of the line.
** The length does not include LF and/or CR characters.  Return -1 if no line was
** found that matches key.
**
** If "bFromBeginingOnly" is TRUE, "szThisString" will only be compared with the
** string segment at the beginning of a "line".
**
** If "bFromBeginingOnly" is FALSE then the entire line will be search to see if
** it contains the string segment defined by "szThisString".
**
** If there is no white space at the begining of "szThisString", then the search
** will begin after any leading white space in "line".
**
** In all cases, if a line starts with the character "REM", it will be ignored.
** Searches are NOT case sensitive.
**
*/
int EXPENTRY FindLineWith(char szThisString[],char *pszBuffer,int iOffset,int *piLength,BOOL bFromBeginingOnly)
  {
  ULONG ulCount;
  ULONG ulIndex;
  char chChar;
  BOOL bDone = FALSE;
  ULONG ulLen;
  char *pchLine;
  BOOL bSkipLeadingWhiteSpace;

  if (DosAllocMem((PVOID)&pchLine,4096,(PAG_COMMIT | PAG_READ | PAG_WRITE)) != NO_ERROR)
    return(-1);
  chChar = szThisString[0];
  if ((chChar == ' ') || (chChar == '\t'))
    bSkipLeadingWhiteSpace = FALSE;
  else
    bSkipLeadingWhiteSpace = TRUE;
  while (!bDone)
    {
    ulCount = 0;
    ulIndex = iOffset;
    chChar = pszBuffer[ulIndex++];
    while((chChar == ' ') || (chChar  == '\t'))
      {
      if (!bSkipLeadingWhiteSpace)
        pchLine[ulCount++] = chChar;
      chChar = pszBuffer[ulIndex++];
      }
    while (chChar != 0)
      {
      pchLine[ulCount++] = toupper(chChar);
      if (chChar == '\x0a')
        break;
      chChar = pszBuffer[ulIndex++];
      }
    if (chChar == 0)
      {
      DosFreeMem(pchLine);
      return(-1);
      }
    ulLen = strlen(szThisString);
//    ulCount++;              // from index to count
    *piLength = ulCount;
    if (ulLen <= ulCount)
      {
      if (!bSkipLeadingWhiteSpace)
        {
        for (ulIndex = 0;ulIndex < 10;ulIndex++)
          {
          chChar = pchLine[ulIndex];
          if ((chChar != ' ') && (chChar != '\t'))
            break;
          }
        }
      else
        ulIndex = 0;
      if (strnicmp("REM ",&pchLine[ulIndex],4) != 0)
        {
        if (bFromBeginingOnly)
          ulCount = 0;
        else
          ulCount = (ulCount - ulLen);
        chChar = toupper(szThisString[0]);
        for (ulIndex = 0;ulIndex <= ulCount;ulIndex++)
          {
          if (pchLine[ulIndex] == chChar)
            {
            if (strnicmp(szThisString,&pchLine[ulIndex],ulLen) == 0)
              {
              DosFreeMem(pchLine);
              return(iOffset);
              }
            }
          }
        }
      }
    iOffset += *piLength;
    }
  DosFreeMem(pchLine);
  return(-1);
  }

BOOL EXPENTRY AdjustConfigSys(HWND hwnd, char szDDspec[],int iLoadCount,BOOL bMakeChanges,USHORT usHelpID)
  {
  int iCount;
  char szDeviceStatement[CCHMAXPATH + 1];
//  char szFileSpec[] = "C:\\CONFIG.sss";
  char szFileSpec[CCHMAXPATH] = "C:\\CONFIG.SYS";

  if (DosQuerySysInfo(QSV_BOOT_DRIVE,QSV_BOOT_DRIVE,&iCount,4L) == 0)
    szFileSpec[0] = ('A' + ((BYTE)iCount - 1));
  sprintf(szDeviceStatement,"DEVICE=%s.SYS",szDDspec);
  return(AdjustConfigFile(hwnd, szFileSpec, szDeviceStatement, iLoadCount, bMakeChanges, usHelpID));
  }

BOOL EXPENTRY AdjustConfigFile(HWND hwnd,char szFileSpec[], char szConfigLine[],int iLineCount, BOOL bNoPrompt, USHORT usHelpID)
  {
  int iCount;
  char *pchNew;
  char *pchFile;
  char *pchLines;
  int iIndex;
  int iOffset;
  int iDDcount = 0;
  int iLength;
  int iFirstOffset = 0;
  int iLastOffset = 0;
  char szCaption[80];
  char szMessage[120];
  int iLen;
  ULONG ulFilePosition;
  char szDeviceStatement[CCHMAXPATH];
  ULONG flStyle;

  if ((iCount = ReadConfigFile(hwnd, szFileSpec,&pchFile)) == 0)
    {
    if (hwnd != NULLHANDLE)
      {
      sprintf(szCaption,"Unable to open system configuration File");
      sprintf(szMessage,"You will need to add or remove %s statement(s) from your CONFIG.SYS file to complete this configuration.",szConfigLine);
      flStyle =  (MB_MOVEABLE | MB_OK | MB_ICONHAND);
      if (usHelpID != 0)
        flStyle |= MB_HELP;
      WinMessageBox(HWND_DESKTOP,
                    hwnd,
                    szMessage,
                    szCaption,
                   (usHelpID + 1),
                    flStyle);
      }
//    DosFreeMem(pchLines);
    return(FALSE);
    }
  if (DosAllocMem((PVOID)&pchLines,(iCount * 2),(PAG_COMMIT | PAG_READ | PAG_WRITE)) != NO_ERROR)
    {
    if (hwnd != NULLHANDLE)
      {
      sprintf(szCaption,"Unable to allocate memory to adjust system configuration file");
      sprintf(szMessage,"You will need to add or remove %s statement(s) from your CONFIG.SYS file to complete this configuration.",szConfigLine);
      flStyle =  (MB_MOVEABLE | MB_OK | MB_ICONHAND);
      if (usHelpID != 0)
        flStyle |= MB_HELP;
      WinMessageBox(HWND_DESKTOP,
                    hwnd,
                    szMessage,
                    szCaption,
                   (usHelpID + 2),
                    flStyle);
      }
//    DosFreeMem(pchLines);
    return(FALSE);
    }
  pchFile[iCount] = 0;
//  iCount = strlen(pchFile);
  iOffset = 0;
  while ((iOffset = FindLineWith(szConfigLine,pchFile,iOffset,&iLength,FALSE)) >= 0)
    {
    if (iFirstOffset == 0)
      iFirstOffset = iOffset;
    iDDcount++;
    iOffset += iLength;
    iLastOffset = iOffset;
    }
  if (iDDcount != iLineCount)
    {
//    DosSetFilePtr(hFile,0L,0L,&ulFilePosition);
    if (hwnd != NULLHANDLE)
      sprintf(szCaption,"System configuration file needs to be updated");
    if (iDDcount > iLineCount)
      {
      iDDcount -= iLineCount;
      if (!bNoPrompt)
        {
        if (hwnd != NULLHANDLE)
          {
          if (iDDcount > 1)
            sprintf(szMessage,"%s device driver load statements need to be removed from your CONFIG.SYS file.\n\nOK to make changes?",aszCapOrdinals[iDDcount]);
          else
            sprintf(szMessage,"One device driver load statement needs to be removed from your CONFIG.SYS file.\n\nOK to make changes?");
          flStyle =  (MB_MOVEABLE | MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON1);
          if (usHelpID != 0)
            flStyle |= MB_HELP;
          if (WinMessageBox(HWND_DESKTOP,hwnd,szMessage,szCaption,usHelpID,flStyle) != MBID_YES)
            {
            if (iDDcount > 1)
              sprintf(szMessage,"You will need to remove %s %s statements from your CONFIG.SYS file to complete this configuration.",aszOrdinals[iDDcount],szConfigLine);
            else
              sprintf(szMessage,"You will need to remove one %s statement from your CONFIG.SYS file to complete this configuration.",szConfigLine);
            WinMessageBox(HWND_DESKTOP,hwnd,szMessage,szCaption,0L,(MB_MOVEABLE | MB_OK | MB_ICONASTERISK));
            DosFreeMem(pchFile);
            DosFreeMem(pchLines);
            return(FALSE);
            }
          }
        }
      iOffset = iFirstOffset;
      for (iIndex = 0;iIndex < iDDcount;iIndex++)
        {
        if ((iOffset = FindLineWith(szConfigLine,pchFile,iOffset,&iLength,FALSE)) < 0)
          break;
        iCount -= iLength;
        memcpy(&pchFile[iOffset],&pchFile[iOffset + iLength],(iCount - iOffset));
        }
//      if (iLoadCount == 0)
//        if (pchFile[ulCount - 1] == '\x0a')
//          iCount -= 2;
      WriteConfigFile(hwnd,szFileSpec,pchFile,iCount);
      }
    else
      {
      iLineCount -= iDDcount;
      if (!bNoPrompt)
        {
        if (hwnd != NULLHANDLE)
          {
          if (iLineCount > 1)
            sprintf(szMessage,"%s COMi load statements need to be added to your CONFIG.SYS file.\n\nOK to make changes?",aszCapOrdinals[iLineCount]);
          else
            sprintf(szMessage,"One COMi load statement needs to be added to your CONFIG.SYS file.\n\nOK to make changes?");
          flStyle =  (MB_MOVEABLE | MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON1);
          if (usHelpID != 0)
            flStyle |= MB_HELP;
          if (WinMessageBox(HWND_DESKTOP,hwnd,szMessage,szCaption,usHelpID,flStyle) != MBID_YES)
            {
            if (iLineCount > 1)
              sprintf(szMessage,"You will need to add %s %s statement lines to your CONFIG.SYS file to complete this configuration.",aszOrdinals[iLineCount],szConfigLine);
            else
              sprintf(szMessage,"You will need to add one %s statement to your CONFIG.SYS file to complete this configuration.",szConfigLine);
            WinMessageBox(HWND_DESKTOP,
                          hwnd,
                          szMessage,
                          szCaption,
                          0L,
                         (MB_MOVEABLE | MB_OK | MB_ICONASTERISK));
            DosFreeMem(pchFile);
            DosFreeMem(pchLines);
            return(FALSE);
            }
          }
        }
      iLen = 0;
//      if (iDDcount == 0)
//        iLen = sprintf(pchLines,"\x0d\x0a");
      for (iIndex = 0;iIndex < iLineCount;iIndex++)
        iLen += sprintf(&pchLines[iLen],"%s\x0d\x0a",szConfigLine);
      if (DosAllocMem((PVOID)&pchNew,(iCount + iLen + 20),(PAG_COMMIT | PAG_READ | PAG_WRITE)) == NO_ERROR)
        {
        memcpy(pchNew,pchFile,iCount);
        if (iDDcount == 0)
          {
          iLastOffset = iCount;
          while (pchNew[iLastOffset - 1] == '\x1a')
            iLastOffset--;
          }
        else
          memcpy(&pchNew[iLastOffset + iLen],&pchFile[iLastOffset],(iCount - iLastOffset));
        memcpy(&pchNew[iLastOffset],pchLines,iLen);
        iCount += iLen;
//        pchNew[iCount++] = '\x1a';
        WriteConfigFile(hwnd,szFileSpec,pchNew,iCount);
        DosFreeMem(pchNew);
        }
      }
    }
  DosFreeMem(pchLines);
  DosFreeMem(pchFile);
  return(TRUE);
  }

BOOL WriteConfigFile(HWND hwndParent,PSZ szFileSpec,PVOID pBuffer,ULONG cbCount)
  {
  int iIndex;
  HFILE hFile;
  char szBackupSpec[CCHMAXPATH + 1];
  APIRET rc;
  ULONG ulStatus;
  char szMessage[120];
  char szCaption[80];
  char *pchDot;

  strcpy(szBackupSpec,szFileSpec);
  for (iIndex = (strlen(szBackupSpec) - 1);iIndex > 0;iIndex--)
    if (szBackupSpec[iIndex] == '.')
      break;
  iIndex++;
  if (iIndex <= 2)
    {
    iIndex = strlen(szFileSpec);
    szBackupSpec[iIndex++] = '.';
    }
  pchDot = &szBackupSpec[iIndex];
  strcpy(pchDot,"001");
  iIndex = 2;
  while ((rc = DosOpen(szBackupSpec,&hFile,&ulStatus,0L,0,0x0010,0x0020,(PEAOP2)0L)) != 0)
    {
//    if (hwndParent != NULLHANDLE)
//      MessageBox(HWND_DESKTOP,szBackupSpec);
    sprintf(pchDot,"%03X",iIndex++);
    if (iIndex > 0xfff)
      {
      DosClose(hFile);
      if (hwndParent != NULLHANDLE)
        {
        sprintf(szMessage,"%s was not updated!  Could not make backup",szFileSpec,rc);
        MessageBox(HWND_DESKTOP,szMessage);
        }
      return(FALSE);
      }
    }
  DosClose(hFile);
  DosCopy(szFileSpec,szBackupSpec,DCPY_EXISTING);
  if (hwndParent != NULLHANDLE)
    {
    sprintf(szMessage,"The current system configuration file, %s, was renamed to %s",szFileSpec,szBackupSpec);
    sprintf(szCaption,"System configuration file was backed up.");
    WinMessageBox(HWND_DESKTOP,
                  hwndParent,
                  szMessage,
                  szCaption,
                  0L,
                 (MB_OK | MB_ICONASTERISK));
    }
  if ((rc = DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0022,(PEAOP2)0L)) != 0)
    {
    if (hwndParent != NULLHANDLE)
      {
      sprintf(szMessage,"%s was not updated!  Could not reopen - Error = %u",szFileSpec,rc);
      MessageBox(HWND_DESKTOP,szMessage);
      }
    return(FALSE);
    }
  DosSetFileSize(hFile,cbCount);
  DosWrite(hFile,pBuffer,cbCount,&cbCount);
  DosClose(hFile);
  return(TRUE);
  }

BOOL EXPENTRY CleanConfigSys(HWND hwnd,char szDDspec[],USHORT usHelpID,BOOL bAskFirst)
  {
  int iCount;
  char *pchFile;
  char szLine[255];
  char szCaption[80];
  int iOffset;
  int iLength;
  ULONG ulFilePosition;
  BOOL bFileChanged = FALSE;
  ULONG flStyle;
  char szFileSpec[CCHMAXPATH] = "C:\\CONFIG.SYS";

  if (DosQuerySysInfo(QSV_BOOT_DRIVE,QSV_BOOT_DRIVE,&iCount,4L) == 0)
    szFileSpec[0] = ('A' + ((BYTE)iCount - 1));
  if ((iCount = ReadConfigFile(hwnd, szFileSpec,&pchFile)) == 0)
    {
    if (hwnd != NULLHANDLE)
      {
      sprintf(szCaption,"Unable to Open System Configuration File");
      sprintf(szLine,"You will need to remove all DEVICE=%s.SYS statement(s) from your CONFIG.SYS file to complete this process.",szDDspec);
      flStyle =  (MB_MOVEABLE | MB_OK | MB_ICONHAND);
      if (usHelpID != 0)
        flStyle |= MB_HELP;
      WinMessageBox(HWND_DESKTOP,
                    hwnd,
                    szLine,
                    szCaption,
                    (usHelpID + 1),
                    flStyle);
      }
    return(FALSE);
    }
  pchFile[iCount] = 0;
  iOffset = 0;
  if (hwnd != NULLHANDLE)
    MessageBox(hwnd,szDDspec);
  while ((iOffset = FindLineWith(szDDspec,pchFile,iOffset,&iLength,FALSE)) >= 0)
    {
    bFileChanged = TRUE;
    iCount -= iLength;
    memcpy(&pchFile[iOffset],&pchFile[iOffset + iLength],(iCount - iOffset));
    iOffset += iLength;
    }
//  pchFile[iCount] = 0;
  if (bFileChanged)
    {
    if (bAskFirst)
      {
      if (hwnd != NULLHANDLE)
        {
        sprintf(szCaption,"System configuration file needs to be updated");
        if (szDDspec[strlen(szDDspec) - 4] == '.')
          szDDspec[strlen(szDDspec) - 4] = 0;
        sprintf(szLine,"All ""DEVICE=%s.SYS"" statements from a previous device driver version need to be removed from your CONFIG.SYS file.\n\nOK to make changes?",szDDspec);
        flStyle =  (MB_MOVEABLE | MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON1);
        if (usHelpID != 0)
          flStyle |= MB_HELP;
        if (WinMessageBox(HWND_DESKTOP,
                          hwnd,
                          szLine,
                          szCaption,
                          usHelpID ,
                          flStyle) != MBID_YES)
          {
          sprintf(szLine,"You will need to remove all DEVICE=%s.SYS statements from your CONFIG.SYS file to complete this configuration.",szDDspec);
          WinMessageBox(HWND_DESKTOP,
                        hwnd,
                        szLine,
                        szCaption,
                        0L,
                       (MB_MOVEABLE | MB_OK | MB_ICONASTERISK));

          DosFreeMem(pchFile);
          return(FALSE);
          }
        }
      }
    WriteConfigFile(hwnd,szFileSpec,pchFile,iCount);
    }
  DosFreeMem(pchFile);
  return(bFileChanged);
  }


