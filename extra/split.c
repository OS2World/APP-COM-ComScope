#define INCL_DOS
#define INCL_DOSERRORS
#define INCL_DOSFILEMGR
#define INCL_DOSMEMMGR

#include <os2.h>
#include <string.h>
#include <stdio.h>

#ifdef ver360
/*
** COMscope buffer marker definitions (v3.60)
*/
#define CS_CHAR_MASK          0x00ff
#define CS_FUNC_MASK          0xff00
#define CS_MODEM_IN           0x3000
#define CS_MODEM_OUT          0x4000
#define CS_OPEN_ONE           0x5000
#define CS_OPEN_TWO           0x6000
#define CS_CLOSE_ONE          0x7000
#define CS_CLOSE_TWO          0x8000
#define CS_WRITE              0x9000
#define CS_READ               0xa000
#define CS_WRITE_IMM          0xb000
#define CS_READ_IMM           0xc000
#define CS_BREAK_TX           0xd000
#define CS_WRITE_REQ          0xf000
#define CS_READ_REQ           0x0100
#define CS_WRITE_CMPLT        0x0200
#define CS_READ_CMPLT         0x0300
#define CS_DEVIOCTL           0x0400
#define CS_READ_BUFF_OVERFLOW 0x0500
#define CS_HDW_ERROR          0x0600
#define CS_BREAK_RX           0x0700

#else

/*
** COMscope buffer marker definitions (v3.61 and up)
**
** Changed to make searches and other display functions more efficient.
*/
#define CS_CHAR_MASK          0x00ff
#define CS_FUNC_MASK          0xff00

#define CS_WRITE              0x8000
#define CS_WRITE_IMM          0x8100
#define CS_WRITE_REQ          0x8200
#define CS_WRITE_CMPLT        0x8300
#define CS_MODEM_OUT          0x8400
#define CS_DEVIOCTL           0x8500
#define CS_OPEN_ONE           0x8600
#define CS_OPEN_TWO           0x8700
#define CS_CLOSE_ONE          0x8800
#define CS_CLOSE_TWO          0x8900
#define CS_BREAK_TX           0x8a00

#define CS_READ               0x4000
#define CS_READ_IMM           0x4100
#define CS_READ_REQ           0x4200
#define CS_READ_CMPLT         0x4300
#define CS_MODEM_IN           0x4400
#define CS_READ_BUFF_OVERFLOW 0x4500
#define CS_HDW_ERROR          0x4600
#define CS_BREAK_RX           0x4700

#define CS_PACKET_DATA        0xff00

#endif

char szCaptureFile[CCHMAXPATH];
char szReadDataFile[CCHMAXPATH];
char szWriteDataFile[CCHMAXPATH];
char szJunkDataFile[CCHMAXPATH];
USHORT *pwCaptureBuffer;
BYTE *pbyReadBuffer;
BYTE *pbyWriteBuffer;
BYTE *pbyJunkBuffer;

BOOL WriteFile(char szFileSpec[],BYTE *pbyBuffer,ULONG ulCount)
  {
  FILESTATUS3 stFileInfo;
  USHORT wFileError;
  HFILE hFile;
  ULONG ulStatus;
  BOOL bWriteOK = TRUE;
  char szMessage[100];
  char szCaption[80];

  while ((wFileError = DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,0x12,0x0111,(PEAOP2)0L)) != 0)
    {
    switch (wFileError)
      {
      case ERROR_FILE_NOT_FOUND:
        sprintf(szCaption,"\nWrite Error - Cannot find file %s\n",szFileSpec);
        break;
      case ERROR_PATH_NOT_FOUND:
        sprintf(szCaption,"\nWrite Error - Cannot find path %s\n",szFileSpec);
        break;
      case ERROR_ACCESS_DENIED:
        sprintf(szCaption,"\nWrite Error - Access denied for writing %s\n",szFileSpec);
        break;
      default:
        sprintf(szCaption,"\nWrite Error - Failed to open %s - error = %u\n",szFileSpec,wFileError);
        break;
      }
    printf(szCaption);
    return(FALSE);
    }
  DosQueryFileInfo(hFile,1,&stFileInfo,sizeof(FILESTATUS3));
  if ((ulStatus == FILE_EXISTED) && (stFileInfo.cbFile > 0))
    DosSetFileSize(hFile,0);
  if ((wFileError = DosWrite(hFile,(PVOID)pbyBuffer,ulCount,&ulCount)) != 0)
    {
    bWriteOK = FALSE;
    sprintf(szMessage,"\nWrite to %s failed - error = %u\n",szFileSpec,wFileError);
    }
  else
    sprintf(szMessage,"\n%u bytes written to %s\n",ulCount,szFileSpec);
  printf(szMessage);
  DosClose(hFile);
  return(bWriteOK);
  }

BOOL ReadFile(char szFileSpec[],ULONG *pulCount)
  {
  USHORT wFileError;
  HFILE hFile;
  ULONG ulStatus;
  FILESTATUS3 stFileInfo;
  char szMessage[100];
  char szCaption[80];
  APIRET rc;
  BOOL bReadOK = TRUE;

  if ((wFileError = DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0110,(PEAOP2)0L)) != 0)
    {
    switch (wFileError)
      {
      case ERROR_FILE_NOT_FOUND:
        sprintf(szCaption,"\nRead Error - Cannot find file %s\n",szFileSpec);
        break;
      case ERROR_PATH_NOT_FOUND:
        sprintf(szCaption,"\nRead Error - Cannot find path %s\n",szFileSpec);
        break;
      case ERROR_ACCESS_DENIED:
        sprintf(szCaption,"\nRead Error - Access denied for reading %s\n",szFileSpec);
        break;
      default:
        sprintf(szCaption,"\nRead Error - Failed to open %s - error = %u\n",szFileSpec,wFileError);
        break;
      }
    printf(szCaption);
    return(FALSE);
    }
  DosQueryFileInfo(hFile,1,&stFileInfo,sizeof(FILESTATUS3));
  *pulCount = stFileInfo.cbFile;
  if ((rc = DosAllocMem((PPVOID)&pwCaptureBuffer,*pulCount,PAG_COMMIT | PAG_READ | PAG_WRITE)) != 0)
    {
    bReadOK = FALSE;
    sprintf(szMessage,"\nCapture buffer allocation error = %d\n",rc);
    }
  else
    if ((wFileError = DosRead(hFile,(PVOID)pwCaptureBuffer,*pulCount,pulCount)) != 0)
      {
      bReadOK = FALSE;
      sprintf(szMessage,"\nRead from %s failed - error = %u\n",szFileSpec,wFileError);
      DosFreeMem(pwCaptureBuffer);
      }
    else
      sprintf(szMessage,"\n%u bytes read from %s\n",*pulCount,szFileSpec);
  DosClose(hFile);
  printf(szMessage);
  return(bReadOK);
  }

void AppendRD(char szFileSpec[])
  {
  int iIndex = 0;

  while (szFileSpec[iIndex++] != 0);
  while (szFileSpec[--iIndex] != '.')
    {
    if (iIndex == 0)
      {
      while (szFileSpec[iIndex++] != 0);
      szFileSpec[--iIndex] = '.';
      break;
      }
    }
  szFileSpec[++iIndex] = 'R';
  szFileSpec[++iIndex] = 'D';
  szFileSpec[++iIndex] = 0;
  }

void AppendWRT(char szFileSpec[])
  {
  int iIndex = 0;

  while (szFileSpec[iIndex++] != 0);
  while (szFileSpec[--iIndex] != '.')
    {
    if (iIndex == 0)
      {
      while (szFileSpec[iIndex++] != 0);
      szFileSpec[--iIndex] = '.';
      break;
      }
    }
  szFileSpec[++iIndex] = 'W';
  szFileSpec[++iIndex] = 'R';
  szFileSpec[++iIndex] = 'T';
  szFileSpec[++iIndex] = 0;
  }

void AppendJNK(char szFileSpec[])
  {
  int iIndex = 0;

  while (szFileSpec[iIndex++] != 0);
  while (szFileSpec[--iIndex] != '.')
    {
    if (iIndex == 0)
      {
      while (szFileSpec[iIndex++] != 0);
      szFileSpec[--iIndex] = '.';
      break;
      }
    }
  szFileSpec[++iIndex] = 'J';
  szFileSpec[++iIndex] = 'N';
  szFileSpec[++iIndex] = 'K';
  szFileSpec[++iIndex] = 0;
  }

void main(int argc,char *argv[])
  {
  char szMessage[80];
  LONG lIndex;
  ULONG ulBufferLength;
  LONG lJunkIndex = 0;
  LONG lReadIndex = 0;
  LONG lWriteIndex = 0;
  BOOL bFileNamed;
  APIRET rc;
  USHORT wTemp;

  if (argc >= 2)
    strcpy(szCaptureFile,argv[1]);
  else
    {
    printf("\nUsage:\n\n  [d:\]SPLIT capture.dat\n");
    return;
    }
  strcpy(szWriteDataFile,szCaptureFile);
  AppendWRT(szWriteDataFile);
  strcpy(szReadDataFile,szCaptureFile);
  AppendRD(szReadDataFile);
  strcpy(szJunkDataFile,szCaptureFile);
  AppendJNK(szJunkDataFile);
  if (ReadFile(szCaptureFile,&ulBufferLength))
    {
    ulBufferLength /= 2;
    if (( rc = DosAllocMem((PPVOID)&pbyReadBuffer,ulBufferLength,PAG_COMMIT | PAG_READ | PAG_WRITE)) != 0)
      {
      sprintf(szMessage,"\nRead buffer allocation error = %d\n",rc);
      printf(szMessage);
      DosFreeMem(pwCaptureBuffer);
      }
    else
      {
      if ((rc = DosAllocMem((PPVOID)&pbyWriteBuffer,ulBufferLength,PAG_COMMIT | PAG_READ | PAG_WRITE)) != 0)
        {
        sprintf(szMessage,"/nWrite buffer allocation error = %d\n",rc);
        printf(szMessage);
        DosFreeMem(pwCaptureBuffer);
        DosFreeMem(pbyReadBuffer);
        }
      else
        {
        if ((rc = DosAllocMem((PPVOID)&pbyJunkBuffer,ulBufferLength,PAG_COMMIT | PAG_READ | PAG_WRITE)) != 0)
          {
          sprintf(szMessage,"/nJunk buffer allocation error = %d\n",rc);
          printf(szMessage);
          DosFreeMem(pwCaptureBuffer);
          DosFreeMem(pbyReadBuffer);
          DosFreeMem(pbyWriteBuffer);
          }
        else
          {
          for (lIndex = 0;lIndex < ulBufferLength;lIndex++)
            {
            wTemp = pwCaptureBuffer[lIndex];
            switch (wTemp & 0xff00)
              {
              case CS_READ:
                pbyReadBuffer[lReadIndex++] = (BYTE)wTemp;
                break;
              case CS_WRITE:
                pbyWriteBuffer[lWriteIndex++] = (BYTE)wTemp;
                break;
              deafult:
                pbyJunkBuffer[lJunkIndex++] = (BYTE)wTemp;
                break;
              }
            }
          if (lWriteIndex > 0)
            WriteFile(szWriteDataFile,pbyWriteBuffer,lWriteIndex);
          if (lReadIndex > 0)
            WriteFile(szReadDataFile,pbyReadBuffer,lReadIndex);
          if (lJunkIndex > 0)
            WriteFile(szJunkDataFile,pbyJunkBuffer,lJunkIndex);
          DosFreeMem(pwCaptureBuffer);
          DosFreeMem(pbyWriteBuffer);
          DosFreeMem(pbyReadBuffer);
          DosFreeMem(pbyJunkBuffer);
          }
        }
      }
    }
  printf("\n\x07Split Complete\n");
  }


