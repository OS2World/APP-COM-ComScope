#define INCL_AVIO
#define INCL_VIO
#define INCL_DOS
#define INCL_DOSDEVICES

#include <stdio.h>
#include "wincom.h"

#define ERR_LAST_RECORD   1
#define ERR_BAD_TYPE      2
#define ERR_BAD_CHECKSUM  3

#define DATA        00
#define END_RECORD  01

typedef unsigned char BYTE;
typedef unsigned int  WORD;
typedef unsigned int  BOOL;

typedef struct _HexLine
  {
  BYTE byByteCount;
  WORD wAddress;
  BYTE byRecordType;
  BYTE abyCodeData[32];
  }HEXLINE;

#define REPEAT 2

char szPassword[] = "0000";
PSZ aszMasterBaud[] = {"200","300","400","800","1200","1800","2400","4800","9600","19.2K","38.4K"};
PSZ aszOtherBaud[] = {"300","1200","2400","4800","9600"};

char szFileSpec[256] = "j:\\projects\\micro481\\m481dnld.hex";
BYTE byTermBaud = 4;
BYTE byTBOSbaud = 2;
BYTE byModemBaud = 1;
BYTE byMasterBaud = 8;
BYTE byMasterPort = 3;
BYTE byTargetAddress = 1;
BYTE byStationAddress = 1;
BYTE byDialStationAddress = 1;
BYTE byCommandSyncCount = 10;
BYTE byAddressMode = 0;
BYTE byMomentaryTimeoutCount = 50;

BYTE abyHexLine[256];

BYTE abyCodeData[0x6000];

BOOL bFileTranslated;

HFILE hFile;
WORD wLoadChecksum;
WORD wHighAddress;

BYTE ConvertChar(BYTE byChar);
BYTE ASCIIhexToBin(BYTE **ppByte);
WORD ParseHexLine(HEXLINE *pstHexLine,BYTE *pASCIIhexLine);
WORD ReadLine(HFILE hFile,BYTE *pLine);
BOOL SendPacket(BYTE abyPacket[],WORD wCount);
BOOL RequestUpload(THREAD *pstThd);
BOOL UploadBeginningAddress(THREAD *pstThd,WORD wStartAddress);
WORD SendCodePacket(THREAD *pstThd,BYTE *pbyCodeData,int iCount);
WORD UploadChecksum(THREAD *pstThd,WORD wChecksum);
WORD WaitResponse(THREAD *pstThd,BYTE abyResponse[],WORD wCount);

void DownloadM481(THREAD *pstThd)
  {
  VIOPS *pVio = &pstThd->stVio;
  WORD wIndex;
  int iIndex;
  BYTE **ppData;
  HEXLINE stHexLine;
  BYTE byTemp;
  char szMessage[256];
  WORD wLen;
  WORD wError;
  WORD wAction;

  if (bFileTranslated)
    {
    wLen = sprintf(szMessage,"File already read and translated\n\r");
    VioWrtTTY(szMessage,wLen,pVio->hpsVio);
    }
  else
    {
    wHighAddress = 0;
    memset(abyCodeData,0,sizeof(abyCodeData));
    wLen = sprintf(szMessage,"Opening %s\n\r",szFileSpec);
    VioWrtTTY(szMessage,wLen,pVio->hpsVio);
    if ((wError = DosOpen(szFileSpec,&hFile,&wAction,0L,0,0x0001,0x2190,0L)) != 0)
      {
      wLen = sprintf(szMessage,"Unable to open %s - error = %X",szFileSpec,wError);
      VioWrtTTY(szMessage,wLen,pVio->hpsVio);
      return;
      }
    wLen = sprintf(szMessage,"Reading and translating HEX file\n\r");
    VioWrtTTY(szMessage,wLen,pVio->hpsVio);
    while (ReadLine(hFile,abyHexLine) != 0 && !pstThd->stThread.bStopThread)
      {
      if ((ParseHexLine(&stHexLine,abyHexLine)) != 0)
        {
        wLen = sprintf(szMessage,"Parse failed");
        VioWrtTTY(szMessage,wLen,pVio->hpsVio);
        DosClose(hFile);
        return;
        }
      VioWrtTTY(".",1,pVio->hpsVio);
      if (stHexLine.byRecordType == END_RECORD)
        break;
      wIndex = stHexLine.wAddress;
      if (wIndex >= 0x2000)
        {
        wIndex -= 0x2000;
        if (wIndex > wHighAddress)
          wHighAddress = wIndex + stHexLine.byByteCount - 1;
        for (iIndex = 0;iIndex < stHexLine.byByteCount;iIndex++,wIndex++)
          {
          if (pstThd->stThread.bStopThread)
            {
            DosClose(hFile);
            return;
            }
          abyCodeData[wIndex] = stHexLine.abyCodeData[iIndex];
          }
        }
      }
    bFileTranslated = TRUE;
    DosClose(hFile);
    if (pstThd->stThread.bStopThread)
      return;
    }
  abyCodeData[8] = byTermBaud;
  abyCodeData[9] = 1;
  abyCodeData[10] = byTBOSbaud;
  abyCodeData[11] = 0;
  abyCodeData[12] = 0;
  abyCodeData[13] = byModemBaud;
  abyCodeData[14] = 2;
  abyCodeData[15] = byMasterBaud;
  abyCodeData[16] = byMasterPort;
  abyCodeData[17] = byStationAddress;
  abyCodeData[18] = byDialStationAddress;
  abyCodeData[19] = byCommandSyncCount;
  abyCodeData[20] = byAddressMode;
  abyCodeData[21] = byMomentaryTimeoutCount;
  if (strlen(szPassword) != 0)
    {
    abyCodeData[27] = FALSE;
    strcpy(&abyCodeData[28],szPassword);
    }
  else
    {
    memset(&abyCodeData[28],'0',4);
    abyCodeData[27] = TRUE;
    }
  while (!pstThd->stThread.bStopThread)
    {
    wLoadChecksum = 0;
    FlushComBuffer(pstThd,INPUT);
    /*
    ** upload code starting at 2300h, leaving code from 2000h to 22ffh
    ** to the last  so that the vector table is not disturbed until
    ** all of the code is in place.
    */
    wLen = sprintf(szMessage,"\n\rRequesting Upload to Remote\n\r");
    VioWrtTTY(szMessage,wLen,pVio->hpsVio);
    if (!RequestUpload(pstThd))
      return;
    if (pstThd->stThread.bStopThread)
      return;
    wLen = sprintf(szMessage,"Sending Code Starting Address to Remote\n\r");
    VioWrtTTY(szMessage,wLen,pVio->hpsVio);
    if (!UploadBeginningAddress(pstThd,0x2300))
      return;
    if (pstThd->stThread.bStopThread)
      return;
    wLen = sprintf(szMessage,"Sending Code\n\r\n\r");
    VioWrtTTY(szMessage,wLen,pVio->hpsVio);
    wIndex = 0x300;
    wLen = sprintf(szMessage,"At Address 0x%4.X - To Address 0x%4.X\n\r",wIndex + 0x2000,wHighAddress + 0x2000);
    VioWrtTTY(szMessage,wLen,pVio->hpsVio);
    while ((wIndex <= wHighAddress) && !pstThd->stThread.bStopThread)
      {
      wLen = sprintf(szMessage,"Sending Block Starting At Address 0x%4.X\n\r",wIndex + 0x2000);
      VioWrtTTY(szMessage,wLen,pVio->hpsVio);
      do
        {
        if ((wError = SendCodePacket(pstThd,&abyCodeData[wIndex],64)) == FALSE)
          return;
        if (wError == REPEAT)
          {
          FlushComBuffer(pstThd,INPUT);
          wLen = sprintf(szMessage,"Sending Code Starting Address to Remote\n\r");
          VioWrtTTY(szMessage,wLen,pVio->hpsVio);
          if (!UploadBeginningAddress(pstThd,wIndex + 0x2000))
            return;
          }
        } while ((wError == REPEAT) && !pstThd->stThread.bStopThread);
      wIndex += 64;
      }
    if (pstThd->stThread.bStopThread)
      return;
    /*
    ** upload code from 2000h to 22ffh (vector table and other stuff)
    */
    wLen = sprintf(szMessage,"Sending Vector Table Starting Address to Remote\n\r");
    VioWrtTTY(szMessage,wLen,pVio->hpsVio);
    if (!UploadBeginningAddress(pstThd,0x2000))
      return;
    if (pstThd->stThread.bStopThread)
      return;
    wLen = sprintf(szMessage,"Sending Vector Table\n\r\n\r");
    VioWrtTTY(szMessage,wLen,pVio->hpsVio);
    wLen = sprintf(szMessage,"At Address 0x2000 - To Address 0x22ff\n\r");
    VioWrtTTY(szMessage,wLen,pVio->hpsVio);
    wIndex = 0;
    while ((wIndex < 0x2ff) && !pstThd->stThread.bStopThread)
      {
      wLen = sprintf(szMessage,"Sending Block Starting At Address 0x%4.X\n\r",wIndex + 0x2000);
      VioWrtTTY(szMessage,wLen,pVio->hpsVio);
      if (!SendCodePacket(pstThd,&abyCodeData[wIndex],64))
        return;
      wIndex += 64;
      }
    if (pstThd->stThread.bStopThread)
      return;
    wLen = sprintf(szMessage,"\n\r\n\rUploading vector checksum - %4.X\n\r",wLoadChecksum);
    VioWrtTTY(szMessage,wLen,pVio->hpsVio);
    if ((wError = UploadChecksum(pstThd,wLoadChecksum)) == FALSE)
      return;
    if (wError != REPEAT)
      {
      wLen = sprintf(szMessage,"Upload successfully completed\n\r");
      VioWrtTTY(szMessage,wLen,pVio->hpsVio);
      pstThd->stThread.bStopThread = TRUE;
      }
    else
      DosSleep(4000);
    }
  }

BOOL RequestUpload(THREAD *pstThd)
  {
  BYTE abyPacket[3];
  WORD wBytesWritten;
  WORD wLen;
  char szMessage[80];
  VIOPS *pVio = &pstThd->stVio;

  abyPacket[0] = 0xd4;
  abyPacket[1] = byTargetAddress;
  abyPacket[2] = byTargetAddress ^ 0xd4;
  DosWrite(pstThd->hCom,abyPacket,3,&wBytesWritten);
  if (WaitResponse(pstThd,abyPacket,3) != 0)
    {
    if (abyPacket[0] == 0x75)
      {
      wLen = sprintf(szMessage,"**Download Request Acknowledged\n\r");
      VioWrtTTY(szMessage,wLen,pVio->hpsVio);
      }
    else
      {
      wLen = sprintf(szMessage,"Uknown Response Received - %X\n\r",abyPacket[0]);
      VioWrtTTY(szMessage,wLen,pVio->hpsVio);
      return(FALSE);
      }
    }
  else
    {
    wLen = sprintf(szMessage,"Timeout\n\r",abyPacket[0]);
    VioWrtTTY(szMessage,wLen,pVio->hpsVio);
    return(FALSE);
    }
  return(TRUE);
  }

BOOL UploadBeginningAddress(THREAD *pstThd,WORD wStartAddress)
  {
  BYTE abyPacket[5];
  WORD wBytesWritten;
  BYTE byLRC;
  WORD wLen;
  char szMessage[80];
  VIOPS *pVio = &pstThd->stVio;

  abyPacket[0] = 0xd7;
  abyPacket[1] = byTargetAddress;
  byLRC = byTargetAddress ^ 0xd7;
  abyPacket[2] = (BYTE)(wStartAddress >> 8);
  byLRC ^= abyPacket[2];
  abyPacket[3] = (BYTE)wStartAddress;
  byLRC ^= abyPacket[3];
  abyPacket[4] = byLRC;
  DosWrite(pstThd->hCom,abyPacket,5,&wBytesWritten);
  if (WaitResponse(pstThd,abyPacket,5) != 0)
    {
    if (abyPacket[0] == 0x76)
      {
      wLen = sprintf(szMessage,"**Download Address Acknowledged\n\r");
      VioWrtTTY(szMessage,wLen,pVio->hpsVio);
      if ((abyPacket[2] != (BYTE)(wStartAddress >> 8)) ||
          (abyPacket[3] != (BYTE)wStartAddress))
        {
        wLen = sprintf(szMessage,"Bad Download Address Returned\n\r");
        VioWrtTTY(szMessage,wLen,pVio->hpsVio);
        return(FALSE);
        }
      }
    else
      {
      wLen = sprintf(szMessage,"Uknown Response Received - %X\n\r",abyPacket[0]);
      VioWrtTTY(szMessage,wLen,pVio->hpsVio);
      return(FALSE);
      }
    }
  else
    {
    wLen = sprintf(szMessage,"Timeout\n\r",abyPacket[0]);
    VioWrtTTY(szMessage,wLen,pVio->hpsVio);
    return(FALSE);
    }
  return(TRUE);
  }

WORD SendCodePacket(THREAD *pstThd,BYTE *pbyCodeData,int iCount)
  {
  BYTE abyPacket[5];
  WORD wBytesWritten;
  BYTE byLRC;
  int iIndex;
  WORD wLen;
  char szMessage[80];
  VIOPS *pVio = &pstThd->stVio;
  WORD wChecksum = 0;
  BYTE byTemp;
  WORD wSaveSum;

  abyPacket[0] = 0xd5;
  abyPacket[1] = byTargetAddress;
  byLRC = byTargetAddress ^ 0xd5;
  abyPacket[2] = (BYTE)iCount + 4;
  byLRC ^= abyPacket[2];
  wSaveSum = wLoadChecksum;
  for (iIndex = 0;iIndex < iCount;iIndex++)
    {
    byTemp= pbyCodeData[iIndex];
    abyPacket[iIndex + 3] = byTemp;
    byLRC ^= byTemp;
    wChecksum += (WORD)byTemp;
    wLoadChecksum += (WORD)byTemp;
    }
  abyPacket[iIndex + 3] = byLRC;
  DosWrite(pstThd->hCom,abyPacket,iIndex + 4,&wBytesWritten);
  if (WaitResponse(pstThd,abyPacket,5) != 0)
    {
    if (abyPacket[0] == 0x77)
      {
      wLen = sprintf(szMessage,"**Download Packet Acknowledged - 0x%2.X%2.X\n\r",abyPacket[2],abyPacket[3]);
      VioWrtTTY(szMessage,wLen,pVio->hpsVio);
      if ((abyPacket[2] != (BYTE)(wChecksum >> 8)) ||
          (abyPacket[3] != (BYTE)wChecksum))
        {
        wLoadChecksum = wSaveSum;
        wLen = sprintf(szMessage,"Bad Packet Checksum Returned\n\r----Resending Packet\n\r");
        VioWrtTTY(szMessage,wLen,pVio->hpsVio);
        return(REPEAT);
        }
      }
    else
      {
      wLen = sprintf(szMessage,"Uknown Response Received - %X\n\r",abyPacket[0]);
      VioWrtTTY(szMessage,wLen,pVio->hpsVio);
      return(FALSE);
      }
    }
  else
    {
    wLen = sprintf(szMessage,"Timeout\n\r",abyPacket[0]);
    VioWrtTTY(szMessage,wLen,pVio->hpsVio);
    return(FALSE);
    }
  return(TRUE);
  }

WORD UploadChecksum(THREAD *pstThd,WORD wChecksum)
  {
  BYTE abyPacket[5];
  WORD wBytesWritten;
  BYTE byLRC;
  WORD wLen;
  char szMessage[80];
  VIOPS *pVio = &pstThd->stVio;

  abyPacket[0] = 0xd6;
  abyPacket[1] = byTargetAddress;
  byLRC = byTargetAddress ^ 0xd6;
  abyPacket[2] = (BYTE)(wChecksum >> 8);
  byLRC ^= abyPacket[2];
  abyPacket[3] = (BYTE)wChecksum;
  byLRC ^= abyPacket[3];
  abyPacket[4] = byLRC;
  DosWrite(pstThd->hCom,abyPacket,5,&wBytesWritten);
  if (WaitResponse(pstThd,abyPacket,3) != 0)
    {
    if (abyPacket[0] == 0x78)
      {
      wLen = sprintf(szMessage,"**Download Checksum Acknowledged\n\r");
      VioWrtTTY(szMessage,wLen,pVio->hpsVio);
      }
    else
      {
      if (abyPacket[0] == 0x79)
        if (abyPacket[1] == 0x01)
          {
          wLen = sprintf(szMessage,"Bad Checksum at Remote\n\r----Resending Binary Image\n\r");
          VioWrtTTY(szMessage,wLen,pVio->hpsVio);
          return(REPEAT);
          }
      else
        {
        wLen = sprintf(szMessage,"Uknown Response Received - %X\n\r",abyPacket[0]);
        VioWrtTTY(szMessage,wLen,pVio->hpsVio);
        return(FALSE);
        }
      }
    }
  else
    {
    wLen = sprintf(szMessage,"Timeout\n\r",abyPacket[0]);
    VioWrtTTY(szMessage,wLen,pVio->hpsVio);
    return(FALSE);
    }
  return(TRUE);
  }

WORD WaitResponse(THREAD *pstThd,BYTE abyResponse[],WORD wCount)
  {
  WORD wBytesRead;

  if (DosRead(pstThd->hCom,abyResponse,wCount,&wBytesRead) != 0)
    ErrorNotify(pstThd,"Bad Serial Read");
  return(wBytesRead);
  }

WORD ReadLine(HFILE hFile,BYTE *pLine)
  {
  BYTE byChar;
  WORD wCount;
  WORD wBytesRead;

  for (wCount = 0;wCount < 256;wCount++)
    {
    if (DosRead(hFile,&byChar,1,&wBytesRead) != 0)
      return(wCount);
    if (byChar == 0x0d)
      return(wCount);
    *(pLine++) = byChar;
    }
  return(wCount);
  }

WORD ParseHexLine(HEXLINE *pHexLine,BYTE *pASCIIhexLine)
  {
  BYTE byTemp;
  WORD wTemp;
  int iIndex;
  BYTE byChecksum;

  while (*(pASCIIhexLine++) != ':');
  pHexLine->byByteCount = ASCIIhexToBin(&pASCIIhexLine);
  byChecksum = pHexLine->byByteCount;
  wTemp = (WORD)ASCIIhexToBin(&pASCIIhexLine);
  byChecksum += (BYTE)wTemp;
  wTemp <<= 8;
  wTemp &= 0xff00;
  wTemp += (WORD)ASCIIhexToBin(&pASCIIhexLine);
  byChecksum += (BYTE)wTemp;
  pHexLine->wAddress = wTemp;
  pHexLine->byRecordType = ASCIIhexToBin(&pASCIIhexLine);
  if ((pHexLine->byRecordType != 1) && (pHexLine->byRecordType != 0))
    return(ERR_BAD_TYPE);
  byChecksum += pHexLine->byRecordType;
  for (iIndex = 0;iIndex < pHexLine->byByteCount;iIndex++)
    {
    byTemp = ASCIIhexToBin(&pASCIIhexLine);
    pHexLine->abyCodeData[iIndex] = byTemp;
    byChecksum += byTemp;
    }
  byTemp = byChecksum + ASCIIhexToBin(&pASCIIhexLine);
  if (byTemp != 0)
    return(ERR_BAD_CHECKSUM);
  return(0);
  }

BYTE ASCIIhexToBin(BYTE **ppByte)
  {
  BYTE byResult;

  byResult = ConvertChar(*((*ppByte)++)) << 4;
  byResult += ConvertChar(*((*ppByte)++));
  return(byResult);
  }

BYTE ConvertChar(BYTE byChar)
  {
  if ((byChar <= 0x39) && (byChar >= 0x30))
    return(byChar - 0x30);
  byChar &= 0x5f;
  if ((byChar <= 0x47) && (byChar >= 0x41))
    return(byChar - 0x37);
  return(0);
  }
