//#define INCL_NLS

//#define INCL_SUB

#define INCL_WIN
#define INCL_DOS
#define INCL_DOSERRORS
#ifdef INCL_ALL_EXP
#define INCL_DOSFILEMGR
#define INCL_DOSPROCESS
#define INCL_DOSMEMMGR
#define INCL_DOSSESMGR
#define INCL_DOSMISC
#define INCL_DOSDEVICES
#endif

#include <os2.h>
#include <ctype.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <memory.h>
//#include <malloc.h>

BYTE *pbyFileData = NULL;
char szFileSpec[CCHMAXPATH + 1];

#define PAGE_COUNT_OFFSET 0x238 // offset is byte index into device driver for max PAGER device count
#define COM_COUNT_OFFSET 0x23a  // offset is byte index into device driver for max COM device count

BOOL bSetCOMcount = FALSE;

void main(int argc,char *argv[])
  {
  HFILE hFile;
  ULONG ulAction;
  FILESTATUS3 stFileInfo;
  APIRET rc;
  ULONG ulOpenMode;
  ULONG ulOpenFlag;
  ULONG ulByteCount;
  int iIndex;
  ULONG ulFilePosition;
  USHORT *pusDeviceCount;
  USHORT usDeviceCount = 0;

  if (argc >= 4)
    {
    strcpy(szFileSpec,argv[1]);
    usDeviceCount = (USHORT)atoi(argv[2]);
    if ((argv[3][0] & '\xdf') == 'C')
      bSetCOMcount = TRUE;
    }
  else
    {
    if (argc >= 3)
      {
      strcpy(szFileSpec,argv[1]);
      usDeviceCount = (USHORT)atoi(argv[2]);
      }
    else
      {
      if (argc >= 2)
        {
        strcpy(szFileSpec,argv[1]);
        usDeviceCount = 1;
        }
      else
        {
        printf("\nUsage:\nSetCount d:\path\driver.SYS device_count type\n\n");
        printf("Where \"device_count\" is the maximum number of Pager devices\n");
        printf("\"driver.SYS\" is to support\n");
        printf("A \"C\" in the type field will cause the total COM devices to be limited\n\n");
        printf("If no extention is given then the \".SYS\" extension is assumed\n");
        return;
        }
      }
    }

  for (iIndex = 0;iIndex < strlen(szFileSpec);iIndex++)
    if (szFileSpec[iIndex] == '.')
      break;
  if (iIndex >= strlen(szFileSpec))
    {
    szFileSpec[iIndex++] = '.';
    szFileSpec[iIndex++] = 'S';
    szFileSpec[iIndex++] = 'Y';
    szFileSpec[iIndex++] = 'S';
    szFileSpec[iIndex] = 0;
    }
  ulOpenFlag = (OPEN_ACTION_OPEN_IF_EXISTS | OPEN_ACTION_FAIL_IF_NEW);
  ulOpenMode = (OPEN_FLAGS_SEQUENTIAL | OPEN_SHARE_DENYREADWRITE | OPEN_ACCESS_READWRITE);
  while ((rc = DosOpen(szFileSpec,&hFile,&ulAction,0L,0,ulOpenFlag,ulOpenMode,(PEAOP2)0L)) != 0)
    {
    switch (rc)
      {
      case ERROR_FILE_NOT_FOUND:
        printf("Cannot find file %s.\n",szFileSpec);
        break;
      case ERROR_PATH_NOT_FOUND:
        printf("Cannot find path %s.\n",szFileSpec);
        break;
      case ERROR_ACCESS_DENIED:
        printf("Access denied for reading %s.\n",szFileSpec);
        break;
      default:
        printf("Failed to open %s. rc = %u\n",szFileSpec,rc);
        break;
      }
    return;
    }
  DosQueryFileInfo(hFile,1,&stFileInfo,sizeof(FILESTATUS3));
  ulByteCount = stFileInfo.cbFile;
  if ((rc = DosAllocMem((PPVOID)&pbyFileData,ulByteCount,PAG_COMMIT | PAG_READ | PAG_WRITE)) != 0)
    {
    if (rc == ERROR_NOT_ENOUGH_MEMORY)
      {
      printf("Out of Memory\n");
      printf("Unable to allocate enough memory to read file.\n");
      }
    else
      {
      printf("Memory allocation error. ec = %u\n",rc);
      printf("Unable to allocate memory to read file\n");
      }
    DosClose(hFile);
    return;
    }
  if ((rc = DosRead(hFile,(PVOID)pbyFileData,ulByteCount,&ulByteCount)) != NO_ERROR)
    printf("Read from %s failed. rc = %u\n",szFileSpec,rc);
  else
    {
    if (!bSetCOMcount)
      pusDeviceCount = (USHORT *)&pbyFileData[PAGE_COUNT_OFFSET];
    else
      pusDeviceCount = (USHORT *)&pbyFileData[COM_COUNT_OFFSET];
    *pusDeviceCount = usDeviceCount;
    DosChgFilePtr(hFile,0L,0,&ulFilePosition);
    if ((rc = DosWrite(hFile,(PVOID)pbyFileData,ulByteCount,&ulByteCount)) != NO_ERROR)
      printf("Write to %s failed. rc = %u\n",szFileSpec,rc);
    }
  DosClose(hFile);
  DosFreeMem(pbyFileData);
  }


