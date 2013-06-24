/*******************************************************************************
*
*       Copyright (C) 1988-89 OS/tools Incorporated -- All rights reserved
*
*******************************************************************************/
#include "wCommon.h"

#pragma hdrstop

#include "dialog.h"

extern THREAD *pstThread;

extern HEV hevStartThreadSem;
extern HEV hevRestartThreadSem;
extern HEV hevKillThreadSem;
extern HEV hevKillReadThreadSem;
extern HEV hevKillWriteThreadSem;
extern HEV hevStartReadThreadSem;
extern HEV hevStartWriteThreadSem;
extern HEV hevStartReadSem;
extern HEV hevStartWriteSem;

void DoStringTransfer(THREAD *pstThd);
BOOL ReadCharacters(THREAD *pstThd,CHAR *pString);
BOOL ReadString(THREAD *pstThd,CHAR *pString);
BOOL WriteCharacters(THREAD *pstThd,CHAR *pString,WORD *pwIndex,ULONG ulArgCount);
BOOL WriteString(THREAD *pstThd,CHAR *pString,WORD *pwIndex,ULONG ulArgCount);
void APIENTRY ReadLoopThread(void);

void DoStringTransfer(THREAD *pstThd)
  {
  WORD wIndex = 0;
  BOOL bWriteComplete = TRUE;
  CONFIG *pCfg = &pstThd->stCfg;
  THREADCTRL *pThread = &pstThd->stThread;
  CHAR *pString;
  APIRET rc;
  ULONG ulPostCount;
  ULONG ulStringLength;
  BOOL bSkipWrite = FALSE;
  char szMessage[80];
  WORD ulCount;

  if (pCfg->bAllowRead)
    {
    if (!pCfg->bSlave)
      DosPostEventSem(hevStartWriteSem);
    DosCreateThread(&pThread->idReadThread,(PFNTHREAD)ReadLoopThread,0,0,8192);
    }
  ulStringLength = 0;
//  ulStringLength = strlen(pCfg->pWriteString);
//  DosAllocMem((PPVOID)&pString,(ulStringLength + 100),(PAG_COMMIT | PAG_READ | PAG_WRITE));
  while (!pThread->bStopThread)
    {
    if (pCfg->bAllowWrite)
      {
      if (ulStringLength <= (pCfg->wWriteStringLength + 100));
        {
        DosFreeMem(pString);
        ulStringLength = pCfg->wWriteStringLength;
        DosAllocMem((PPVOID)&pString,(ulStringLength + 100),(PAG_COMMIT | PAG_READ | PAG_WRITE));
        }
      while (!pThread->bStopThread)
        {
        if (pCfg->bHalfDuplex)
          {
          while ((rc = DosWaitEventSem(hevStartWriteSem,-1)) != 0)
            if (rc == ERROR_SEM_TIMEOUT)
              {
              ErrorNotify(pstThd,"Write start semaphore timed out");
              bSkipWrite = TRUE;
              }
            else
              {
              sprintf(szMessage,"Write start semaphore error - rc = %u",rc);
              ErrorNotify(pstThd,szMessage);
              }
          DosResetEventSem(hevStartWriteSem,&ulPostCount);
          }
        if (bSkipWrite)
          bSkipWrite = FALSE;
        else
          {
          ulCount = (ULONG)pCfg->wWriteStringLength;
          memcpy(pString,pstThd->pWriteString,ulCount);
          if (pCfg->bWriteAppendSeries)
            ulCount += sprintf(&pString[ulCount],"[46m_%s_%03u_%05u[0m",
                            pCfg->szPortName,ulCount,pCfg->wWriteCounter++);
          if (pCfg->bWriteAppendChar)
            {
            pString[ulCount] = pCfg->chWriteAppendChar;
            ulCount++;
            }
          wIndex = 0;
          do
            {
            if (!pCfg->bWriteCharacters)
              bWriteComplete = WriteString(pstThd,&pString[wIndex],&wIndex,(ulCount - wIndex));
            else
              bWriteComplete = WriteCharacters(pstThd,pString,&wIndex,ulCount);
            } while (!bWriteComplete && !pThread->bStopThread);
          DosPostEventSem(hevStartReadSem);
          if ((pCfg->wLoopTime != 0) && !pThread->bStopThread)
            DosSleep(pCfg->wLoopTime);
          }
        }
      }
    else
      DosSleep(1000);
    }
  DosFreeMem(pString);
  }

BOOL WriteString(THREAD *pstThd,CHAR *pString,WORD *pwIndex,ULONG ulArgCount)
  {
  ULONG ulCount;
  APIRET rc;
  CONFIG *pCfg = &pstThd->stCfg;
  THREADCTRL *pThd = &pstThd->stThread;
  CHAR szErrorMsg[81];

  if ((rc = DosWrite(pstThd->hCom,(PVOID)pString,ulArgCount,&ulCount)) != 0)
    {
    sprintf(szErrorMsg,"Bad Write - count = %d - error = 0x%04X",ulCount,rc);
    ErrorNotify(pstThd,szErrorMsg);
    return(FALSE);
    }
  else
    {
    if (ulCount != ulArgCount)
      {
      *pwIndex += ulCount;
      sprintf(szErrorMsg,"Write Timeout - Attempted = %u, Transmitted = %u",
                                                     ulArgCount,ulCount);
      ErrorNotify(pstThd,szErrorMsg);
//      if (pThd->bStopThread)
        return(FALSE);
      }
    }
  return(TRUE);
  }

BOOL WriteCharacters(THREAD *pstThd,CHAR *pString,WORD *pwIndex,ULONG ulArgCount)
  {
  ULONG ulCount;
  ULONG ulWrtCount;
  BOOL bDone = FALSE;
  APIRET rc;
  BYTE byCOMstatus;
  CONFIG *pCfg = &pstThd->stCfg;
  THREADCTRL *pThd = &pstThd->stThread;
  HFILE hCom = pstThd->hCom;
  CHAR szErrorMsg[81];
  BYTE byChar;

  for (;*pwIndex < ulArgCount;*pwIndex++)
//  while (pString[*pwIndex] != 0)
    {
    if ((rc = DosWrite(hCom,(PVOID)&pString[*pwIndex],1,&ulCount)) != 0)
      {
      sprintf(szErrorMsg,"Bad write - count = %d - error = 0x%04X",ulCount,rc);
      ErrorNotify(pstThd,szErrorMsg);
      return(TRUE);
      }
    else
      {
      if (ulCount != 1)
        {
        if (ulCount == 0)
          {
          byChar = pString[*pwIndex];
          if (pString[*pwIndex] == ' ')
            byChar = 3;
          if (pString[*pwIndex] == '\x0d')
            byChar = 1;
          if (pString[*pwIndex] == '\x0a')
            byChar = 2;
          sprintf(szErrorMsg,"Write Timeout - last character sent = %c",byChar);
          ErrorNotify(pstThd,szErrorMsg);
          }
        else
          {
          sprintf(szErrorMsg,"Funny Write - count = %d",ulCount);
          ErrorNotify(pstThd,szErrorMsg);
          return(TRUE);
          }
        return(FALSE);
        }
      }
    }
  return(TRUE);
  }

BOOL ReadString(THREAD *pstThd,CHAR *pInString)
  {
  ULONG ulCount;
  BOOL bDone = FALSE;
  APIRET rc;
  BYTE byCOMstatus;
  CONFIG *pCfg = &pstThd->stCfg;
//  THREADCTRL *pThd = &pstThd->stThread;
  HFILE hCom = pstThd->hCom;
  HVPS hPS = pstThd->stVio.hpsVio;
  WORD wLength = pCfg->wReadStringLength;
  CHAR szErrorMsg[81];

  if ((rc = DosRead(hCom,(PVOID)pInString,wLength,&ulCount)) != 0)
    {
    pInString[ulCount] = 0;
    sprintf(szErrorMsg,"Read Error - count = %u - error = 0x%04X",ulCount,rc);
    ErrorNotify(pstThd,szErrorMsg);
    return(FALSE);
    }
  else
    {
    pInString[ulCount] = 0;
    if (ulCount == 0)
      {
      ErrorNotify(pstThd,"Read Timeout");
      return(FALSE);
      }
    else
      {
      if (pCfg->wReadStringLength != ulCount)
        {
        sprintf(szErrorMsg,"Read Timeout - %u of %u were received",
                              ulCount,pCfg->wReadStringLength);
        ErrorNotify(pstThd,szErrorMsg);
        }
      VioWrtTTY(pInString,strlen(pInString),hPS);
      return(FALSE);
      }
    }
  return(TRUE);
  }

BOOL ReadCharacters(THREAD *pstThd,CHAR *pInString)
  {
  int iIndex = 0;
  ULONG ulCount;
  BOOL bDone = FALSE;
  APIRET rc;
  BYTE byChar;
  BYTE byCOMstatus;
  CONFIG *pCfg = &pstThd->stCfg;
  THREADCTRL *pThd = &pstThd->stThread;
  HFILE hCom = pstThd->hCom;
  HVPS hPS = pstThd->stVio.hpsVio;
  CHAR szErrorMsg[81];

  do
    {
    if ((rc = DosRead(hCom,(PVOID)&byChar,1,&ulCount)) != 0)
      {
      pInString[iIndex] = 0;
      sprintf(szErrorMsg,"Read Error - count = %u - error = 0x%04X",ulCount,rc);
      ErrorNotify(pstThd,szErrorMsg);
      }
    else
      {
      if (ulCount == 1)
        {
        pInString[iIndex++] = byChar;
        if (pCfg->bReadAppendChar && (byChar == (BYTE)pCfg->chReadAppendTriggerChar))
          pInString[iIndex++] = pCfg->chReadAppendChar;
        }
      else
        {
        if (ulCount == 0)
          sprintf(szErrorMsg,"Read Timeout");
        else
          sprintf(szErrorMsg,"Funny Read Timeout - count = %u",ulCount);
        ErrorNotify(pstThd,szErrorMsg);
        return(FALSE);
        }
      }
    if (pThd->bStopThread)
      return(FALSE);
    } while ((byChar != (BYTE)pCfg->chReadCompleteChar) && (iIndex < 10000));
  pInString[iIndex] = 0;
  VioWrtTTY(pInString,strlen(pInString),hPS);
  return(TRUE);
  }
