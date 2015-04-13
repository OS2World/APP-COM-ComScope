/*
**  This program uninstalls DRIVER.SRC from delete path to source path.
*/

#include "install.h"
#include <string.h>

extern ULONG ulLastError;

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
