/*******************************************************************************
*
*       Copyright (C) 1988-89 OS/tools Incorporated -- All rights reserved
*
*******************************************************************************/
#include "wCommon.h"

#pragma hdrstop

#include "dialog.h"

extern THREAD *pstThread;
extern IOCTLINST stIOctlInst;

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

void APIENTRY LoopThread()
  {
  THREAD *pstThd = pstThread;
  CONFIG *pCfg = &pstThd->stCfg;
  THREADCTRL *pThread = &pstThd->stThread;
  int iError;
  CHAR szMessage[81];
  DCB stComDCB;

//  DosSetPriority(PRTYS_THREAD,PRTYC_FOREGROUNDSERVER,-32L,0);
  DosSetPriority(PRTYS_THREAD,PRTYC_REGULAR,-14L,0);
  while (!pThread->bStopThread)
    {
    switch (pCfg->wSimulateType)
      {
      case TERMINAL:
        GetDCB(&stIOctlInst,pstThd->hCom,&stComDCB);
        stComDCB.Flags3 &= ~F3_RTO_MASK;
        stComDCB.Flags3 |= F3_WAIT_SOMETHING;
        stComDCB.ReadTimeout = 100;
        SendDCB(&stIOctlInst,pstThd->hCom,&stComDCB);
        TerminalRead(pstThd);
        break;
      case STRING_TRANSFER:
        DoStringTransfer(pstThd);
        break;
      }
    }
  DosPostEventSem(hevKillThreadSem);
  DosExit(EXIT_THREAD,0);
  }

void APIENTRY ReadLoopThread()
  {
  THREAD *pstThd = pstThread;
  CONFIG *pCfg = &pstThd->stCfg;
  THREADCTRL *pThread = &pstThd->stThread;
  BOOL bReadComplete;
  CHAR *pString;
  APIRET rc;
  BOOL bSkipRead = FALSE;
  char szMessage[80];
  ULONG ulStringLength;
  ULONG ulPostCount;


//  DosSetPriority(PRTYS_THREAD,PRTYC_FOREGROUNDSERVER,-28L,0);
  DosSetPriority(PRTYS_THREAD,PRTYC_REGULAR,-10L,0);
  ulStringLength = pCfg->wReadStringLength;
  DosAllocMem((PPVOID)&pString,10010,(PAG_COMMIT | PAG_WRITE | PAG_READ));
  while (!pThread->bStopThread)
    {
    if (ulStringLength != pCfg->wReadStringLength)
      {
      DosFreeMem(pString);
      ulStringLength = pCfg->wReadStringLength;
      DosAllocMem((PPVOID)&pString,(ulStringLength + 10),(PAG_COMMIT | PAG_WRITE | PAG_READ));
      }
    if (pCfg->bHalfDuplex)
      {
      while ((rc = DosWaitEventSem(hevStartReadSem,10000)) != 0)
        if (rc == ERROR_SEM_TIMEOUT)
          {
          ErrorNotify(pstThd,"Read start semaphore timed out");
          bSkipRead = TRUE;
          }
        else
          {
          sprintf(szMessage,"Read start semaphore error - rc = %u",rc);
          ErrorNotify(pstThd,szMessage);
          }
      DosResetEventSem(hevStartReadSem,&ulPostCount);
      }
    if (bSkipRead)
      bSkipRead = FALSE;
    else
      {
      if (!pCfg->bReadCharacters)
        bReadComplete = ReadString(pstThd,pString);
      else
        bReadComplete = ReadCharacters(pstThd,pString);
      if (bReadComplete)
        DosPostEventSem(hevStartWriteSem);
      }
    }
  DosFreeMem(pString);
  DosPostEventSem(hevKillReadThreadSem);
  DosExit(EXIT_THREAD,0);
  }


