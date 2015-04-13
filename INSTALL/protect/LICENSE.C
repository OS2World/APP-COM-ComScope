/*
**  This program places a license count into the destination file (COMDD.SYS).
**  It also will disable copy protection when an "X" is given for the new
**  license count by placing a count of 0xaaaa in the destination file.
**
**  If a request is made for zero licenses then the current license count of
**  the destination file.
**
**  A "/" as the first parameter displays a help message.
*/
#include "install.h"
#include <stdlib.h>
#include <string.h>

BYTE abyInstallProg[] = "INSTALL.EXE";

extern WORD wLicenseCount;
extern WORD wLicenseAvail;


extern BYTE abyConfigDevEqu[] = {0x0d,0x0a,"DEVICE="};
extern BYTE abyNewLine[] = {0x0d,0x0a,0};
extern BYTE abyInstallFile[] = "INSTALL.EXE";
extern BYTE abySourcePath[MAX_PATH_LEN];
extern BYTE abyDestPath[MAX_PATH_LEN];
extern BYTE abyCommandString[MAX_CMD_LEN];
extern BYTE abyInstallFailed[] = "Installation failed - Error =";

DATETIME stDateTime;

extern WORD wLastError;


BYTE abyThisFile[] = "LICENSE.EXE";
BYTE abyDestPath[MAX_PATH_LEN];
BYTE abyConvertFile[] = "COMDD.SYS";

BYTE abyLicenseSourceFailed[] = "Failed to set License Count - Error =";

DWORD dwFilePosition;

WORD wDestPathLength;
BYTE abyTemp[20];

void License(int iArgCount, char *apArgument[])
    {
    WORD Error;
    HFILE hDest;
    ULONG ulCount;
    ULONG ulStatus;
    WORD wIndex;
    WORD wArgIndex = 0;
    BOOL bTriedAccess = FALSE;
    WORD wLicenseCount;

    wLicenseCount = (WORD)atoi(abyTemp);
    if (wLicenseCount > 40000)
        {
        printf("\nRequest for %u licenses denied.  The maximum allowed is 40,000.\n\n",wLicenseCount);
        return;
        }

    wIndex = 0;
    while (abyDestPath[wIndex] != 0)
        {
        abyDestPath[wIndex] = (BYTE)toupper(abyDestPath[wIndex]);
        wIndex++;
        }

    AppendPath(&abyDestPath[wDestPathLength],abyConvertFile);
//    DosSetFileMode(abyDestPath,0x0000,0L);
    if ((Error = OpenFile(abyDestPath,&hDest,&wStatus,0L,0,1,0x6192)) != 0)
        {
        printf("Cannot open %s\n to set or read license count. ",abyDestPath);
        bTriedAccess = TRUE;
        }
    DosChgFilePtr(hDest,oFileOffset + oCopyCount,0,&dwFilePosition);
    if (wLicenseCount != 0)
        {
        if ((Error = DosWrite(hDest,&(BYTE)wLicenseCount,2,&wCount)) != 0)
            {
            printf("%sWKC%04X\n",abyLicenseSourceFailed,Error | 0x8000);
            return;
            }
        if (wLicenseCount == 0xaaaa)
            printf("\n[1mCopy protection has been disabled for\n\n%s\n\n[0m",abyDestPath);
        else
            printf("\nThe License Count has been set to %u for\n\n%s\n\n",wLicenseCount,abyDestPath);
        }
    else
        {
        if ((Error = DosRead(hDest,&(BYTE)wLicenseCount,2,&wCount)) != 0)
            {
            printf("%sRKC%04X\n",abyLicenseSourceFailed,Error | 0x8000);
            return;
            }
        if (wLicenseCount == 0xaaaa)
            printf("\n[1mCopy protection is disabled for\n\n%s\n\n[0m",abyDestPath);
        else
            printf("\nThe License Count for\n\n%s = %u\n\n",abyDestPath,wLicenseCount);
        }
    DosClose(hDest);
    if (wLicenseCount == 0xaaaa)
      DosSetFileMode(abyDestPath,0x0020,0L);
    else
      DosSetFileMode(abyDestPath,0x0021,0L);
    }

WORD Install(CHAR szSourcePath[],CHAR szDestPath)
    {
    HFILE hSource;
    HFILE hDestination;
    WORD wCount;
    WORD wStatus;
    WORD wTemp;
    WORD wAttrib;
    WORD wIndex;
    DWORD dwFilePosition;
    WORD wDestPathLength;
    WORD wSourcePathLength;

    DosGetDateTime(&stDateTime);
    stCodeKey.dwCopyKey = (DWORD)stDateTime.hours;
    stCodeKey.dwCopyKey |= (DWORD)stDateTime.minutes << 4;
    stCodeKey.dwCopyKey |= (DWORD)stDateTime.seconds << 10;
    stCodeKey.dwCopyKey |= (DWORD)stDateTime.hundredths << 16;
    stCodeKey.dwCopyKey |= (DWORD)stDateTime.day << 23;
    stCodeKey.dwCopyKey |= (DWORD)stDateTime.month << 27;
    stCodeKey.dwCopyKey |= (DWORD)stDateTime.year << 31;

    wSourcePathLength = strlen(szSourthPath);
    AppendPath(&szSourcePath[wSourcePathLength)],szSourceFile);
    if (DosSetFileMode(abySourcePath,0x0000,0L));
    if ((wLastError = DosOpen(abySourcePath,(PHFILE)&hSource,(PUSHORT)&wStatus,0L,0,0x01,0x61a2,0L)) != 0)
      return(SOURCE_FILE_OPEN);

    DosChgFilePtr(hSource,oFileOffset + oCopyCount,0,&dwFilePosition);
    if ((wLastError = DosRead(hSource,&(BYTE)wTemp,2,&wCount)) != 0)
      return(SOURCE_FILE_READ);

    if (wTemp == 0)
      return(SOURCE_NO_LICENSE);

    if ((wLastError = DosQFileMode(abyDestPath,&wAttrib,0L)) != 0)
      return(SOURCE_FILE_MODE);

    if ((wAttrib & 0x0010) != 0x0010)
      return(DEST_BAD_PATH);

    wDestPathLength = strlen(szDestPath);
    AppendPath(&szDestPath[wDestPathLength],szDeviceFile);
    if (wLastError = FileCopy(szSourcePath,szDestPath) != 0)
        return(SOURCE_FILE_COPY);

    if ((wLastError = DosOpen(szDestPath,(PHFILE)&hDestination,(PUSHORT)&wStatus,0L,0,1,0x6192,0L)) != 0)
        return(DEST_FILE_OPEN);

    stCodeKey.wCopyCount = 0;
    DosChgFilePtr(hDestination,oFileOffset + oCopyKey,0,&dwFilePosition);
    if ((wLastError = DosWrite(hDestination,&(BYTE)stCodeKey.dwCopyKey,6,&wCount)) != 0)
        return(DEST_WRITE_CODE_KEY);

    DosClose(hDestination);
    DosSetFileMode(abyDestPath,0x0021,0L);
    stCodeKey.wCopyCount = wTemp;

    AppendPath(&abyDestPath[wDestPathLength],abyHiddenFile);
    AppendPath(&abySourcePath[wSourcePathLength],abyHiddenFile);

    if (wLastError = FileCopy(abySourcePath,abyDestPath) != 0)
        {
        DosClose(hSource);
        AppendPath(&abySourcePath[wSourcePathLength],abyDeviceFile);
        DosDelete(abyDestPath,0L);
        return(HIDE_FILE_COPY);
        }

    if ((wLastError = DosOpen(abyDestPath,(PHFILE)&hDestination,(PUSHORT)&wStatus,0L,0,1,0x6192,0L)) != 0)
        {
        DosClose(hSource);
        AppendPath(&abySourcePath[wSourcePathLength],abyDeviceFile);
        DosDelete(abyDestPath,0L);
        return(HIDE_FILE_COPY);
        }

    DosChgFilePtr(hDestination,20,0,&dwFilePosition);
    if ((wLastError = DosWrite(hDestination,(&(BYTE)stCodeKey.dwCopyKey),20,&wCount)) != 0)
        {
        DosClose(hDestination);
        DosClose(hSource);
        AppendPath(&abySourcePath[wSourcePathLength],abyDeviceFile);
        DosDelete(abyDestPath,0L);
        return(HIDE_FILE_WRITE);
        }

    DosClose(hDestination);

    DosSetFileMode(abySourcePath,0x0027,0L);
    DosSetFileMode(abyDestPath,0x0027,0L);

    stCodeKey.wCopyCount--;
    DosChgFilePtr(hSource,oFileOffset + oCopyCount,0,&dwFilePosition);
    if ((wLastError = DosWrite(hSource,&(BYTE)stCodeKey.wCopyCount,2,&wCount)) != 0)
        {
        DosClose(hSource);
        DosSetFileMode(abyDestPath,0x0000,0L);
        DosDelete(abyDestPath,0L);
        return(SOURCE_WRITE_CODE_KEY);
        }
    DosClose(hSource);
    AppendPath(&abyDestPath[wDestPathLength],abyDeviceFile);
    if (FixConfigFile())
        {
        printf("% successfully installed.  You must use UNINST.EXE to move the\n",abyDeviceFile);
        printf("device driver to another machine or directory\n");
        if (stCodeKey.wCopyCount != 0)
            {
            printf("\nThere are %u %s device driver licenses still\n",stCodeKey.wCopyCount,abyDeviceFile);
            printf("available for installation.\n\n");
            }
        }
    }

/*
**  This program uninstalls DRIVER.SRC from delete path to source path.
*/

WORD Uninstall(CHAR szSourcePath[],CHAR szDeletePath[])
    {
    HFILE hSource;
    HFILE hDelete;
    ULONG ulCopyKey;
    ULONG ulCount;
    ULONG ulStatus;
    ULONG ulTemp;
    ULONG ulFilePosition;
    ULONG ulPathLength;

    AppendPath(&szSourcePath[strlen(szSourcePath)],szSourceFile);

//    DosSetFileMode(szSourcePath,0x0000,0L);
    if ((ulLastError = DosOpen(szSourcePath,(PHFILE)&hSource,&ulStatus,0L,0,0x01,0x61a2,0L)) != 0)
        return(SOURCE_FILE_OPEN);

    ulPathLength = strlen(szDeletePath);

    AppendPath(&szDeletePath[ulPathLength],szDeviceFile);
    /*
    **  read code key from driver to delete
    if ((wLastError = DosSetFileMode(szDeletePath,0x0000,0L)) != 0)
        return(DEST_FILE_MODE_SET);
    */

    if ((wLastError = DosOpen(szDeletePath,(PHFILE)&hDelete,&ulStatus,0L,0,0x01,0x61a2,0L)) != 0)
        return(DEST_FILE_OPEN);

    DosChgFilePtr(hDelete,oFileOffset + oCopyKey,0,&ulFilePosition);

    if ((wLastError = DosRead(hDelete,(BYTE *)&ulCopyKey,4,&ulCount)) != 0)
        return(DEST_FILE_READ);

    DosClose(hDelete);

    AppendPath(&szDeletePath[ulPathLength],szHiddenFile);

#ifdef this_junk
    if ((wLastError = DosQFileMode(szDeletePath,&ulTemp,0L)) != 0)
        return(HIDE_FILE_MODE_READ);

    if ((ulTemp & 0x0007) != 0x0007)
        return(HIDE_FILE_MODE);

    if ((wLastError = DosSetFileMode(szDeletePath,0x0000,0L)) != 0)
        return(HIDE_FILE_MODE_SET);
#endif
    if ((wLastError = DosOpen(szHiddenPath,(PHFILE)&hDelete,(PUSHORT)&ulStatus,0L,0,0x01,0x61a2,0L)) != 0)
        return(HIDE_FILE_OPEN);

    DosChgFilePtr(hDelete,20,0,&ulFilePosition);

    if ((wLastError = DosRead(hDelete,&(BYTE)stCodeKey.ulCopyKey,4,&ulCount)) != 0)
        return(HIDE_FILE_READ);

    DosClose(hDelete);

    if ((wLastError = DosDelete(szHiddenPath,0L)) != 0)
        return(HIDE_FILE_DELETE);

    AppendPath(&szDeletePath[ulPathLength],szDeviceFile);

    if ((wLastError = DosDelete(szDeletePath,0L)) != 0)
        return(DEST_FILE_DELETE);

    if (ulCopyKey != stCodeKey.ulCopyKey)
        return(BAD_CODE_KEY);
    /*
    ** read copy count from .SRC file, increment it, and write it back
    */
    DosChgFilePtr(hSource,oFileOffset + oCopyCount,0,&ulFilePosition);

    if ((wLastError = DosRead(hSource,&(BYTE)stCodeKey.wCopyCount,2,&ulCount)) != 0)
        return(CAT_SOURCE_READ);

    stCodeKey.wCopyCount++;

    DosChgFilePtr(hSource,oFileOffset + oCopyCount,0,&ulFilePosition);

    if ((wLastError = DosWrite(hSource,&(BYTE)stCodeKey.wCopyCount,2,&ulCount)) != 0)
        return(CAT_SOURCE_WRITE);

    DosClose(hSource);
    if (stCodeKey.wCopyCount > 1)
      {
      sprintf(szMessage,"There are %u %s authorized device\ndriver licenses available for installation.",
                        stCodeKey.wCopyCount,abyDeviceFile);
      MessageBox(hwndClient,szMessage)
      }
    }

/*
**  This program is for use by an OEM supplier to create a disk with the
**  the necessary files and license count to supply to an end user.
**
**  reads available license count from source driver file
**  tests if requested licenses are available
**  copies driver source file (DRIVER.SRC) to destination path
**  cop1es hidden file (z6566978.356) to destination path
**  writes license count to destination driver file
**  writes remaining license count to source driver file
*/
WORD MakeSource(CHAR szSourcePath[],CHAR szDestPath[])
    {
    HFILE hSource;
    HFILE hDest;
    ULONG ulCount;
    ULONG ulAttrib;
    ULONG ulCopyKey;
    WORD wTemp;
    WORD wIndex;
    WORD wArgIndex = 0;
    BOOL bTriedAccess = FALSE;
    WORD wLicenseAvail;
    WORD wSourcePathLength;
    WORD wDestPathLength;
    BYTE abyTemp[20];
    ULONG ulFilePosition;

    wSourcePathLength = strlen(szSourcePath);
    wDestPathLength = strlen(szDestPath);
    AppendPath(&szSourcePath[wSourcePathLength],szSourceFile);

//    DosSetFileMode(szSourcePath,0x0000,0L);
    if ((wLastError = OpenFile(szSourcePath,&hSource,&ulCopyKey,0L,0,0x01,0x61a2)) != 0)
      return(SOURCE_FILE_OPEN);

    DosChgFilePtr(hSource,oFileOffset + oCopyCount,0,&ulFilePosition);
    if ((wLastError = DosRead(hSource,&wLicenseAvail,2,&ulCount)) != 0)
      return(SOURCE_FILE_READ);

    if (wLicenseAvail == 0)
      return(SOURCE_NO_LICENSE);

    if (wLicenseAvail < wLicenseCount)
      return(SOURCE_NO_LICENSE);
#ifdef this_junk
    if ((wLastError = DosQFileMode(szDestPath,&ulAttrib,0L)) != 0)
      return(DEST_FILE_MODE);
#endif
    if ((wAttrib & 0x0010) != 0x0010)
      return(DEST_BAD_PATH);

    wDestPathLength = strlen(szDestPath);
    AppendPath(&szDestPath[wDestPathLength],szDestFile);
    if (wLastError = FileCopy(szSourcePath,szDestPath) != 0)
      return(DEST_FILE_COPY);

    if ((wLastError = OpenFile(szDestPath,&hDest,&ulCopyKey,0L,0,1,0x6192)) != 0)
      return(DEST_FILE_OPEN);

    DosChgFilePtr(hDest,oFileOffset + oCopyCount,0,&ulFilePosition);
    if ((wLastError = DosWrite(hDest,&(BYTE)wLicenseCount,2,&ulCount)) != 0)
      return(DEST_FILE_WRITE);

    DosClose(hDest);
//    DosSetFileMode(szDestPath,0x0027,0L);

    AppendPath(&szSourcePath[wSourcePathLength],szHiddenFile);
    AppendPath(&szDestPath[wDestPathLength],szHiddenFile);
//    DosSetFileMode(szSourcePath,0x0000,0L);
    if (wLastError = FileCopy(szSourcePath,szDestPath) != 0)
        return(HIDE_FILE_COPY);

//    DosSetFileMode(szDestPath,0x0027,0L);
//    DosSetFileMode(szSourcePath,0x0027,0L);

//    DosSetFileMode(abyDestPath,0x0021,0L);
    wTemp = wLicenseAvail - wLicenseCount;
    DosChgFilePtr(hSource,oFileOffset + oCopyCount,0,&ulFilePosition);
    if ((wLastError = DosWrite(hSource,&(BYTE)wTemp,2,&ulCount)) != 0)
        {
        printf("\n\n%sSW%04X-%02X\n",abyMakeSourceFailed,wLastError | 0x8000,wTemp);
        printf("[1mCatastrofic Failure -- Move to destination disk failed.  You must have this\n");
        printf("wLastError code to get a replacement for the driver just lost - Write it down and\n");
        printf("call your service representative.[0m\n\n");
        return;
        }
    DosClose(hSource);
    printf("\n\nThe Device Driver Source %s\n",abyDestPath);
    printf("has been transferred successfully.  There are %u authorized Device\n",wTemp);
    printf("Driver Licenses available for transfer.\n\n");

    AppendPath(&abyDestPath[wDestPathLength],abyInstallProg);
    AppendPath(&abySourcePath[wSourcePathLength],abyInstallProg);
    if (wLastError = FileCopy(abySourcePath,abyHiddenPath) != 0)
        printf("Failed to copy INSTALL.EXE\n\n");

    AppendPath(&abyDestPath[wDestPathLength],abyUninstallProg);
    AppendPath(&abySourcePath[wSourcePathLength],abyUninstallProg);
    if (wLastError = FileCopy(abySourcePath,abyHiddenPath) != 0)
        printf("Failed to copy UNINST.EXE\n\n");

    }


