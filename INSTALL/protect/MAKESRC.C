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
#define INCL_DOS

#include "install.h"
#include <stdlib.h>
#include <string.h>

BYTE abyInstallProg[] = "INSTALL.EXE";

extern WORD wLastError;
extern WORD wLicenseCount;
extern WORD wLicenseAvail;

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
    if ((wLastError = DosRead(hSource,&(BYTE)wLicenseAvail,2,&ulCount)) != 0)
      return(SOURCE_FILE_READ);

    if (wLicenseAvail == 0)
      return(SOURCE_NO_LICENSE);

    if (wLicenseAvail < wLicenseCount)
      return(SOURCE_NO_LICENSE);
#ifdef this_junk
    if ((wLastError = DosQFileMode(szDestPath,&wAttrib,0L)) != 0)
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
