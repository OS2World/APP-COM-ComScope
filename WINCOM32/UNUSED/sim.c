/*******************************************************************************
*
*       Copyright (C) 1988-89 OS/tools Incorporated -- All rights reserved
*
*******************************************************************************/
#include <common.h>

#include "wincom.h"
#include <string.h>
#include <stdio.h>
extern THREAD *pstThread;

#ifdef this_junk
void SetCursor(int iRow,int iCol,HVPS hDevice)
  {
  VioSetCurPos(iRow,iCol,hDevice);
  }

WORD awMastNAKrcvCounter;
WORD awSlavNAKrcvCounter;
WORD awMastNAKsendCounter;
WORD awSlavNAKsendCounter;
WORD awSOHrcvCounter;
WORD awSOHsendCounter;
WORD awACKrcvCounter;
WORD awACKsendCounter;
WORD awENQsendCounter;
WORD awENQrcvCounter;
WORD awMastBadMsgCounter;
WORD awMastGoodMsgCounter;
WORD awSlavBadMsgCounter;
WORD awSlavGoodMsgCounter;
WORD awIterationCounter;

void InitRegisterSim(void)
  {
  awMastNAKrcvCounter = 0;
  awSlavNAKrcvCounter = 0;
  awMastNAKsendCounter = 0;
  awSlavNAKsendCounter = 0;
  awSOHrcvCounter = 0;
  awSOHsendCounter = 0;
  awACKrcvCounter = 0;
  awACKsendCounter = 0;
  awENQsendCounter = 0;
  awENQrcvCounter = 0;
  awMastBadMsgCounter = 0;
  awMastGoodMsgCounter = 0;
  awSlavBadMsgCounter = 0;
  awSlavGoodMsgCounter = 0;
  awIterationCounter = 0;
  }

BOOL Simulator(THREAD *pstThd)
  {
  int iIndex = 0;
  BYTE byInByte;
  WORD wByteCount;
  WORD wChecksum = 0;
  WORD wCalcChecksum = 0;
  int iMastMessageRow;
  int iMastrcRow;
  int iMessageRow;
  int ircRow;
  int ircCount;
  int iResendCount;
  BOOL bBadMessage;
  int iSlaveENQ_NAKsend;
  WORD wMessageLength;
  BYTE byTemp;
  int iTempRow;
  CHAR szOutString[81];
  BYTE *pMessage;
  BYTE *pInString;
  THREADCTRL *pThread = &pstThd->stThread;
  CONFIG *pCfg = &pstThd->stCfg;
  VIOPS *pVio = &pstThd->stVio;

  if (pCfg->bSlave)
    {
    iMessageRow = 5;
    ircRow = 15;
    iSlaveENQ_NAKsend = 0;
    bBadMessage = FALSE;
    SetCursor(iMessageRow++,0,pVio->hpsVio);
    sprintf(szOutString,"------- Iteration %u --------[37m",++awIterationCounter);
    VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
    pMessage = WinAllocMem(pstThd->hHeap,strlen(pCfg->pWriteString) + 2);
    while (pCfg->pWriteString[iIndex] != 0)
      {
      wChecksum += (WORD)pCfg->pWriteString[iIndex];
      pMessage[iIndex] = pCfg->pWriteString[iIndex];
      iIndex++;
      }
#ifdef bad_message
    if ((awIterationCounter % 20) == 0)
      {
      wChecksum--;
      SetCursor(ircRow,0,pVio->hpsVio);
      sprintf(szOutString,"Sending Bad Checksum - Iteration %u[37m ",awIterationCounter);
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      wChecksum++;
      bBadMessage = TRUE;
      }
#endif
    wMessageLength = iIndex;
    pMessage[iIndex++] = (BYTE)((wChecksum >> 8) & 0x00ff);
    pMessage[iIndex++] = (BYTE)(wChecksum & 0x00ff);
    pMessage[iIndex] = 0;
gtWaitENQ:
    iTempRow = iMessageRow;
    SetCursor(iMessageRow++,0,pVio->hpsVio);
    sprintf(szOutString,"Waiting for ENQ ");
    VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
    ircCount = 0;
    while (!GetComByte(pstThd->hCom,&byInByte))
#ifndef print_to_error
      if (pThread->bStopThread)
        return(FALSE);
#else
     {
     if (ircCount++ > 100)
         return(FALSE);
     if ((pThread->bStopThread) || (!stCfg.bSlave))
         return(FALSE);
     SetCursor(ircRow + 1,0,pVio->hpsVio);
     sprintf(szOutString,"Waiting ENQ Timed out - Wait Count = %u - Iteration %u[37m ",ircCount,awIterationCounter);
    VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
     }
#endif
    if (byInByte != ENQ)
      {
      switch (byInByte)
        {
        case NAK:
          SetCursor(ircRow + 2,0,pVio->hpsVio);
          sprintf(szOutString,"NAK Received waiting for ENQ - %u - Iteration %u[37m ",++awSlavNAKrcvCounter,awIterationCounter);
          break;
        case ACK:
          SetCursor(ircRow + 3,0,pVio->hpsVio);
          sprintf(szOutString,"ACK Received waiting for ENQ - %u - Iteration %u[37m ",++awACKrcvCounter,awIterationCounter);
          break;
        default:
          SetCursor(ircRow + 4,0,pVio->hpsVio);
          sprintf(szOutString,"No ACK/NAK/ENQ waiting for ENQ - Received %c instead - Iteration %u[37m ",byInByte,awIterationCounter);
        }
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      iMessageRow = iTempRow;
      goto gtWaitENQ;
      }
#ifdef bad_message
    if ((awIterationCounter % 7) == 0)
      {
      if (++iSlaveENQ_NAKsend < 6)
        {
        SetCursor(ircRow + 5,0,pVio->hpsVio);
        sprintf("szOutString,"NAK %u sent on receiving ENQ[37m ",++awSlavNAKsendCounter,awIterationCounter++);
        SendComByte(hCom,NAK);
        }
      else
        iSlaveENQ_NAKsend = 0;
      iMessageRow = iTempRow;
      goto gtWaitENQ;
      }
#endif
    SetCursor(iMessageRow++,0,pVio->hpsVio);
    sprintf(szOutString,"ENQ Received - %u[37m ",++awENQrcvCounter);
    VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
    iResendCount = 0;

gtResendSlave:
    SendComByte(pstThd->hCom,SOH);
    SetCursor(iMessageRow++,0,pVio->hpsVio);
    sprintf(szOutString,"SOH Sent %u[37m ",++awSOHsendCounter);
    VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
#ifdef bad_message
    if ((awIterationCounter % 30) == 0)
      {
      SetCursor(ircRow + 6,0,pVio->hpsVio);
      sprintf(szOutString,"Sending wrong Count - Itreation %u[37m ",awIterationCounter++);
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      SendComWord(hCom,wMessageLength + 1);
      bBadMessage = TRUE;
      }
    else
#endif
      SendComWord(pstThd->hCom,wMessageLength);
    SetCursor(iMessageRow++,0,pVio->hpsVio);
    sprintf(szOutString,"Byte Count Sent = %u[37m ",wMessageLength);
    VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
    SendComString(pstThd->hCom,pMessage,wMessageLength + 2);
    WinFreeMem(pstThd->hHeap,pMessage,strlen(pCfg->pWriteString) + 2);

#ifdef show_message
    SetCursor(2,0,pVio->hpsVio);
    sprintf(szOutString,"Message Sent:%sIteration %u[37m ",
                     pCfg->pWriteString,awIterationCounter);
    VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
#endif
    if (bBadMessage)
      {
      bBadMessage = FALSE;
      SetCursor(ircRow + 7,0,pVio->hpsVio);
      sprintf(szOutString,"Bad Message Sent - %u - Iteration %u[37m ",
                  ++awSlavBadMsgCounter,awIterationCounter);
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      }
    else
      {
      SetCursor(iMessageRow,0,pVio->hpsVio);
      sprintf(szOutString,"Good Message Sent - %u -- Checksum = %u[37m ",++awSlavGoodMsgCounter,wChecksum);
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      }
    iMessageRow++;

gtWaitACK:
    iTempRow = iMessageRow;
    ircCount = 0;
    while (!GetComByte(pstThd->hCom,&byInByte))
#ifndef print_to_error
        if (pThread->bStopThread)
          return(FALSE);
#else
      {
      if (ircCount++ > 100)
          return(FALSE);
      SetCursor(ircRow + 8,0,pVio->hpsVio);
      sprintf(szOutMessage,"Timed out Waiting for ACK/NAK/ENQ Wait Count = %u - Iteration %u[37m ",
                          ircCount,awIterationCounter);
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      if (pThread.bStopThread)
          return;
      }
#endif
    if (byInByte == ACK)
      {
      SetCursor(iMessageRow++,0,pVio->hpsVio);
      sprintf(szOutString,"ACK Received waiting for ACK - %u[37m ",++awACKrcvCounter);
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      }
    else
      {
      switch (byInByte)
        {
        case NAK:
            SetCursor(ircRow + 9,0,pVio->hpsVio);
            sprintf(szOutString,"NAK Received waiting for ACK - %u - Iteration %u[37m ",++awSlavNAKrcvCounter,awIterationCounter);
            break;
        case ENQ:
            SetCursor(ircRow + 10,0,pVio->hpsVio);
            sprintf(szOutString,"ENQ Received waiting for ACK - %u - Iteration %u[37m ",++awENQrcvCounter,awIterationCounter);
            break;
        default:
            iMessageRow = iTempRow;
            SetCursor(ircRow + 11,0,pVio->hpsVio);
            sprintf(szOutString,"No ACK/NAK/ENQ waiting ACK - Received %c instead - Iteration %u[37m ",byInByte,awIterationCounter);
            goto gtWaitACK;
        }
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      if (iResendCount++ > 2)
        return(FALSE);

      iMessageRow += 2;

      SetCursor(iMessageRow++,0,pVio->hpsVio);
      sprintf(szOutString,"------- Iteration %u %u--------[37m ",awIterationCounter,iResendCount);
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      goto gtResendSlave;
      }
    }
  else
    {
    iMastMessageRow = 5;
    iMastrcRow = 15;
    SetCursor(iMastMessageRow++,0,pVio->hpsVio);
    sprintf(szOutString,"------- Iteration %u --------[37m ",++awIterationCounter);
    VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
gtResendENQ:
    SendComByte(pstThd->hCom,ENQ);
    SetCursor(iMastMessageRow++,0,pVio->hpsVio);
    sprintf(szOutString,"ENQ Sent %u[37m ",++awENQsendCounter);
    VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
gtWaitSOH:
    iTempRow = iMastMessageRow;
    if (!GetComByte(pstThd->hCom,&byInByte))
      {
      SetCursor(iMastrcRow,0,pVio->hpsVio);
      sprintf(szOutString,"Waiting SOH Timed out - Sending NAK %u - Iteration %u[37m ",++awMastNAKsendCounter,awIterationCounter);
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      SendComByte(pstThd->hCom,NAK);
      return(FALSE);
      }
    SetCursor(iMastMessageRow++,0,pVio->hpsVio);
    switch (byInByte)
      {
      case SOH:
        sprintf(szOutString,"SOH Received %u[37m ",++awSOHrcvCounter);
        VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
        break;
      case NAK:
        SetCursor(iMastrcRow + 1,0,pVio->hpsVio);
        sprintf(szOutString,"NAK Received %u[37m ",++awMastNAKrcvCounter);
        VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
        return(FALSE);
        break;
      default:
        SetCursor(iMastrcRow + 2,0,pVio->hpsVio);
        iMastMessageRow = iTempRow;
        goto gtWaitSOH;
      }
    if (!GetComWord(pstThd->hCom,&wByteCount))
      {
      SetCursor(iMastrcRow + 3,0,pVio->hpsVio);
      sprintf(szOutString,"Waiting Count Timed out - Sending NAK %u - Iteration %u[37m ",++awMastNAKsendCounter,awIterationCounter);
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      SendComByte(pstThd->hCom,NAK);
      return(FALSE);
      }
    if (wByteCount > 518)
      {
      SetCursor(iMastrcRow + 4,0,pVio->hpsVio);
      sprintf(szOutString,"Byte Count to large = %u - Sending NAK %u - Iteration %u[37m ",
              wByteCount,++awMastNAKsendCounter,awIterationCounter);
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      SendComByte(pstThd->hCom,NAK);
      return(FALSE);
      }
    SetCursor(iMastMessageRow++,0,pVio->hpsVio);
    sprintf(szOutString,"Count Received = %u[37m ",wByteCount);
    VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
    pInString = WinAllocMem(pstThd->hHeap,wByteCount + 2);
    if (!GetComString(pstThd->hCom,pInString,wByteCount + 2))
      {
      SetCursor(iMastrcRow + 5,0,pVio->hpsVio);
      sprintf(szOutString,"Waiting Message Timed out - Sending NAK %u - Iteration %u[37m ",
                          ++awMastNAKsendCounter,awIterationCounter);
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      SendComByte(pstThd->hCom,NAK);
      WinFreeMem(pstThd->hHeap,pInString,wByteCount + 2);
      goto gtWaitSOH;
      return(FALSE);
      }
    byTemp = pInString[wByteCount];
    wChecksum = ((WORD)byTemp << 8) & 0xff00;
    byTemp = pInString[wByteCount + 1];
    wChecksum |= (WORD)byTemp & 0x00ff;
    pInString[wByteCount] = 0;

#ifdef show_message
    SetCursor(2,0,pVio->hpsVio);
    sprintf(szOutString,"String Received:%sIteration %u[37m ",
                                                    pInString,awIterationCounter);
    VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
#endif
    for (iIndex = 0;iIndex < wByteCount;iIndex++)
      wCalcChecksum += (WORD)pInString[iIndex];
    if (wCalcChecksum != wChecksum)
      {
      SetCursor(iMastrcRow + 6,0,pVio->hpsVio);
      sprintf(szOutString,"Bad Message received %u - Sending NAK %u - Iteration %u[37m ",
                                        ++awMastBadMsgCounter,
                                        ++awMastNAKsendCounter,
                                        awIterationCounter);
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      SetCursor(2,0,pVio->hpsVio);
      sprintf(szOutString,"[34m%s[37m ",pInString);
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      SendComByte(pstThd->hCom,NAK);
      WinFreeMem(pstThd->hHeap,pInString,wByteCount + 2);
      goto gtWaitSOH;
      }
    else
      {
      SetCursor(iMastMessageRow++,0,pVio->hpsVio);
      sprintf(szOutString,"Valid message received %u -- Checksum = %u - Sending ACK %u[37m ",
             ++awMastGoodMsgCounter,wChecksum,++awACKsendCounter);
      VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
      SendComByte(pstThd->hCom,ACK);
      }
    WinFreeMem(pstThd->hHeap,pInString,wByteCount + 2);
    }
  return(TRUE);
  }
#endif
void TerminalSim(THREAD *pstThd)
  {
  ULONG ulCount;
  BOOL bDone;
  BOOL bTrigger;
  WORD wBack = 0;
  WORD wFor;
  BYTE abyInString[81];
  BYTE szOutString[81];
  CONFIG *pCfg = &pstThd->stCfg;
  THREADCTRL *pThread = &pstThd->stThread;
  VIOPS *pVio = &pstThd->stVio;

  if (strlen(pCfg->pWriteString) >= 10)
    sprintf(&pCfg->pWriteString[pCfg->wWriteStringLength - 10]," - %05u\r",
                                      pCfg->wWriteCounter++);

  while (!pThread->bStopThread)
    {
    bTrigger = FALSE;
    bDone = FALSE;
    while (!bDone && !pThread->bStopThread)
      {
      DosRead(pstThd->hCom,(PVOID)abyInString,80,&ulCount);
      if (ulCount != 0)
        {
        abyInString[ulCount] = 0;
        if (wBack++ >= 7)
          wBack = 0;
        if ((wBack == 7) || (wBack == 6))
          wFor = 1;
        else
          wFor = 7;
        sprintf(szOutString,"[4%u;3%um%s[47;30m\x0a",wBack++,wFor,abyInString);
        VioWrtTTY(szOutString,strlen(szOutString),pVio->hpsVio);
        bTrigger = TRUE;
        }
      else
        if (bTrigger)
          bDone = TRUE;
      }
    SendComString(pstThd->hCom,pCfg->pWriteString,strlen(pCfg->pWriteString));
    }
  }

void TerminalRead(THREAD *pstThd)
  {
  APIRET rc;
  ULONG ulCount;
  BYTE byTemp;
  BYTE abyInString[81];
  THREADCTRL *pThread = &pstThd->stThread;
  VIOPS *pVio = &pstThd->stVio;
  TERMPARMS *pTerm = &pstThd->stTerm;

  while (!pThread->bStopThread)
    {
    if (!pTerm->bInputLF)
      {
      if ((rc = DosRead(pstThd->hCom,(PVOID)abyInString,80,&ulCount)) != 0)
        {
        sprintf(abyInString,"Error Reading Port - rc = %u",rc);
        ErrorNotify(pstThd,abyInString);
        }
      else
        if (ulCount != 0)
          {
          if (pTerm->bRemoteEcho == TRUE)
            if ((rc = DosWrite(pstThd->hCom,(PVOID)abyInString,ulCount,&ulCount)) != 0)
              {
              sprintf(abyInString,"Error Writing Echo to Port - rc = %u",rc);
              ErrorNotify(pstThd,abyInString);
              }
          abyInString[ulCount] = 0;
          VioWrtTTY(abyInString,strlen(abyInString),pVio->hpsVio);
          }
      }
    else
      {
      if ((rc = DosRead(pstThd->hCom,(PVOID)&byTemp,1,&ulCount)) != 0)
        {
        sprintf(abyInString,"Error Reading Port - rc = %u",rc);
        ErrorNotify(pstThd,abyInString);
        }
      else
        if (ulCount != 0)
          {
          if (pTerm->bRemoteEcho == TRUE)
            if ((rc = DosWrite(pstThd->hCom,(PVOID)&byTemp,1,&ulCount)) != 0)
              {
              sprintf(abyInString,"Error Writing Echo to Port - rc = %u",rc);
              ErrorNotify(pstThd,abyInString);
              }
          VioWrtTTY(&byTemp,1,pVio->hpsVio);
          if (byTemp == '\x0d')
            VioWrtTTY("\x0a",1,pVio->hpsVio);
          }
      }
    }
  }


BOOL WaitComByte(HFILE hCom,BYTE byByte)
  {
  BYTE byChar;
  ULONG ulCount;

  do  {
    DosRead(hCom,(PVOID)&byChar,1,&ulCount);
    if (ulCount != 1)
        return(FALSE);
    } while (byChar != byByte);
  return(TRUE);
  }

BOOL GetComByte(HFILE hCom,BYTE *pbyByte)
  {
  ULONG ulCount;

  DosRead(hCom,(PVOID)pbyByte,1,&ulCount);
  if (ulCount == 1)
      return(TRUE);
  else
      return(FALSE);
  }

BOOL GetComWord(HFILE hCom,WORD *pwWord)
  {
  ULONG ulCount;

  DosRead(hCom,(PVOID)pwWord,2,&ulCount);
  if (ulCount != 2)
    {
    *pwWord = 0;
    return(FALSE);
    }
  ulCount = (*pwWord << 8) & 0xff00;
  ulCount |= (*pwWord >> 8) & 0xff;
  *pwWord = ulCount;
  return(TRUE);
  }

BOOL GetComString(HFILE hCom,BYTE *abyString,WORD wByteCount)
  {
  ULONG ulCount;

  DosRead(hCom,(PVOID)abyString,wByteCount,&ulCount);
  if (ulCount == wByteCount)
    return(TRUE);
  else
    return(FALSE);
  }

BOOL SendComByte(HFILE hCom,BYTE byByte)
  {
  ULONG ulCount;

  DosWrite(hCom,(PVOID)&byByte,1,&ulCount);
  if (ulCount == 1)
    return(TRUE);
  else
    return(FALSE);
  }

BOOL SendComWord(HFILE hCom,WORD wWord)
  {
  ULONG ulCount;

  ulCount = (wWord << 8) & 0xff00;
  ulCount |= (wWord >> 8) & 0xff;
  wWord = ulCount;
  ulCount = 0;
  DosWrite(hCom,(PVOID)&wWord,2,&ulCount);
  if (ulCount == 2)
    return(TRUE);
  else
    return(FALSE);
  }

BOOL SendComString(HFILE hCom,BYTE abyByte[],WORD wByteCount)
  {
  ULONG ulCount;

  DosWrite(hCom,(PVOID)abyByte,wByteCount,&ulCount);
  if (ulCount == wByteCount)
    return(TRUE);
  else
    return(FALSE);
  }
