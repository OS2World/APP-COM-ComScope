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

BYTE abyThisFile[] = "LICENSE.EXE";
BYTE abyDestPath[MAX_PATH_LEN];
BYTE abyConvertFile[] = "COMDD.SYS";

BYTE abyLicenseSourceFailed[] = "Failed to set License Count - Error =";

DWORD dwFilePosition;

WORD wDestPathLength;
BYTE abyTemp[20];

void main(int iArgCount, char *apArgument[])
    {
    WORD Error;
    HFILE hDest;
    WORD wCount;
    WORD wStatus;
    WORD wIndex;
    WORD wArgIndex = 0;
    BOOL bTriedAccess = FALSE;
    WORD wLicenseCount;

    hKbd = 0;
    KbdGetStatus(&stKbdInfo,hKbd);
    stKbdInfo.fsMask &= KEYBOARD_BINARY_MODE;
    stKbdInfo.fsMask |= KEYBOARD_ASCII_MODE;
    KbdSetStatus(&stKbdInfo,hKbd);
    stKbdStringLen.cb = MAX_PATH_LEN;

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
        {
        wLicenseCount = (WORD)atoi(abyTemp);
        if (wLicenseCount > 40000)
            {
            printf("\nRequest for %u licenses denied.  The maximum allowed is 40,000.\n\n",wLicenseCount);
            return;
            }
        }

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
    if (wLicenseCount == 0xaaaa)
      DosSetFileMode(abyDestPath,0x0020,0L);
    else
      DosSetFileMode(abyDestPath,0x0021,0L);
    }
