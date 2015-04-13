/************************************************************************
**
** $Revision:   1.1  $
**
** $Log:   P:/archive/comi/PROTECT.C_V  $
** 
**    Rev 1.1   19 Feb 1996 11:18:10   EMMETT
** No Changes
** 
**    Rev 1.0   16 Apr 1994 08:35:36   EMMETT
** Initial version control archive.
**
************************************************************************/

#define INCL_DOSDEVICES
#define building_DD

#include <os2.h>
#include "COMDD.H"

extern BYTE abyPath[];
extern BYTE abyHiddenFile[];
extern BYTE abyDeviceDriverFile[];
extern WORD *pInstallMark;
extern DWORD dwInstallMark;
extern DWORD dwFilePosition;

WORD TestHidden(void)
    {
    WORD wStatus = 0;
    WORD Error;
    HFILE hFile;
    WORD wPathIndex;
    WORD wNameIndex;
    WORD wTargetIndex;
    sBOOL bFoundStart = FALSE;
    DWORD dwCopyKey;
    WORD wCount;

    wPathIndex = 0;
    wNameIndex = 0;
    while (abyPath[wPathIndex] != 0)
        {
        if ((abyPath[wPathIndex++] & 0xdf) == (abyDeviceDriverFile[wNameIndex++] & 0xdf))
            {
            bFoundStart = TRUE;
            wTargetIndex = wPathIndex - 1;
            while (((abyPath[wPathIndex] & 0xdf) ==
                    (abyDeviceDriverFile[wNameIndex] & 0xdf)) &&
                    (abyDeviceDriverFile[wNameIndex] != 0))
                {
                wPathIndex++;
                wNameIndex++;
                }
            }
        wNameIndex = 0;
        if (bFoundStart && ((wPathIndex - wTargetIndex) == 9))
            {
            wPathIndex = wTargetIndex;
            abyPath[wPathIndex++] = (abyHiddenFile[wNameIndex++]);
            while (abyHiddenFile[wNameIndex] != 0)
                abyPath[wPathIndex++] = (abyHiddenFile[wNameIndex++] & '\x3f');
            abyPath[wPathIndex] = 0;
            if ((Error = DosQFileMode(abyPath,&wCount,0L)) != 0)
                return(Error | 0xe000);
            if ((wCount & 0x07) != 0x07)
                return(4);
            if ((Error = DosOpen(abyPath,(PHFILE)&hFile,(PUSHORT)&wStatus,0L,7,1,0x6190,0L)) != 0)
                return(Error | 0xc000);
            DosChgFilePtr(hFile,20,0,&dwFilePosition);
            if ((Error = DosRead(hFile,&(BYTE)dwCopyKey,4,&wCount)) != 0)
                return(Error | 0x8000);
            if (dwCopyKey != dwInstallMark)
                return(3);
            DosClose(hFile);
            return(0);
            }
        bFoundStart = FALSE;
        }
    return(0x8002);
    }
