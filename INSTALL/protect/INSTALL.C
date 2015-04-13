#include "install.h"
#include <string.h>

extern BYTE abyConfigDevEqu[] = {0x0d,0x0a,"DEVICE="};
extern BYTE abyNewLine[] = {0x0d,0x0a,0};
extern BYTE abyInstallFile[] = "INSTALL.EXE";
extern BYTE abySourcePath[MAX_PATH_LEN];
extern BYTE abyDestPath[MAX_PATH_LEN];
extern BYTE abyCommandString[MAX_CMD_LEN];
extern BYTE abyInstallFailed[] = "Installation failed - Error =";
BYTE abyNewLine[] = {0x0d,0x0a,0};
BYTE abyThisFile[] = "CONVERT.EXE";
BYTE abyDestPath[MAX_PATH_LEN];
BYTE abyConvertFile[] = "COMDD.SYS";

BYTE abyLicenseSourceFailed[] = "Failed to set License Count - Error =";

DWORD dwFilePosition;

WORD wDestPathLength;
BYTE abyTemp[20];

DATETIME stDateTime;

extern WORD wLastError;

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

void Convert(int iArgCount, char *apArgument[])
    {
    WORD Error;
    HFILE hDest;
    WORD wCount;
    WORD wStatus;
    WORD wIndex;
    WORD wArgIndex = 0;
    BOOL bTriedAccess = FALSE;
    WORD wLicenseCount;

    if (iArgCount > 1)
        {
        wArgIndex++;
        wIndex = 0;
        while ((apArgument[wArgIndex][wIndex] != 0) && (wIndex < MAX_PATH_LEN))
            {
            abyTemp[wIndex] = apArgument[wArgIndex][wIndex];
            wIndex++;
            }
        abyTemp[wIndex] = 0;
        }
    else
        {
        printf("Enter License Quantity.\nEnter \"Q\" to abort source transfer.\n-> ");
        if (Error = KbdStringIn(abyTemp,&stKbdStringLen,0,hKbd) != 0)
            {
            printf("\nKeyboard Error - BYE!\n");
            return;
            }
        printf("\n");
        abyTemp[stKbdStringLen.cchIn] = 0;
        }

    wIndex = 0;
    while (abyTemp[wIndex] == ' ')
        wIndex++;
    if (abyTemp[wIndex] == '/')
        {
        printf("LICENSE [count [path]]\n\n");
        printf("Where \"count\" is the number of Licenses to apply and \"path\" is the drive\n");
        printf("and directory of the DRIVER.SRC file to modify or or query.  An \"X\" in the\n");
        printf("\"count\" field will cause the DRIVER.SRC file to have its copy protection\n");
        printf("disabled.  A \"0\" in the \"count\" field will cause the DRIVER.SRC file's\n");
        printf("current License Count to be read and displayed.\n");
        return;
        }
    if ((abyTemp[wIndex] & 0xdf) == 'Q')
        return;
    if ((abyTemp[wIndex] & '\xdf') == 'X')
        {
        printf("\nYou are saying - Disable copy protection for this source!!!\n\n");
        wLicenseCount = 0xaaaa;
        }
    else
        wLicenseCount = (WORD)atoi(abyTemp);

gtGetDestPath:
    if ((!bTriedAccess) && (iArgCount > 2))
        {
        wArgIndex++;
        wIndex = 0;
        while ((apArgument[wArgIndex][wIndex] != 0) && (wIndex < MAX_PATH_LEN))
            {
            abyDestPath[wIndex] = apArgument[wArgIndex][wIndex];
            wIndex++;
            }
        wDestPathLength = wIndex;
        }
    else
        {
        printf("Enter drive and path to write Sources Licenses to.\n-> ");

        if (Error = KbdStringIn(abyDestPath,&stKbdStringLen,0,hKbd) != 0)
            {
            printf("\nKeyboard Error - BYE!\n");
            return;
            }
        printf("\n");
        wIndex = 0;
        while (abyDestPath[wIndex] == ' ')
            wIndex++;
        if ((abyDestPath[wIndex] & 0xdf) == 'Q')
            return;
        wDestPathLength = stKbdStringLen.cchIn;
        }

    if ((abyDestPath[wDestPathLength - 1] != '\\') &&
        (abyDestPath[wDestPathLength - 1] != '/')  &&
        (abyDestPath[wDestPathLength - 1] != ':'))
        abyDestPath[wDestPathLength++] = '\\';
    abyDestPath[wDestPathLength] = 0;

    wIndex = 0;
    while (abyDestPath[wIndex] != 0)
        {
        abyDestPath[wIndex] = (BYTE)toupper(abyDestPath[wIndex]);
        wIndex++;
        }

    AppendPath(&abyDestPath[wDestPathLength],abyConvertFile);
    DosSetFileMode(abyDestPath,0x0000,0L);
    if ((Error = OpenFile(abyDestPath,&hDest,&wStatus,0L,0,1,0x6192)) != 0)
        {
        printf("Cannot open %s\n to set or read license count. ",abyDestPath);
        bTriedAccess = TRUE;
        goto gtGetDestPath;
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
    }

