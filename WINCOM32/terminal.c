/*******************************************************************************
*
*       Copyright (C) 1988-89 OS/tools Incorporated -- All rights reserved
*
*******************************************************************************/
#include "wCommon.h"

#pragma hdrstop

extern THREAD *pstThread;

void TerminalRead(THREAD *pstThd)
  {
  APIRET rc;
  ULONG ulCount;
  BYTE byTemp;
  BYTE abyInString[81];
  THREADCTRL *pThread = &pstThd->stThread;
  VIOPS *pVio = &pstThd->stVio;
  TERMPARMS *pTerm = &pstThd->stTerm;

  ErrorNotify(pstThd,"Entered terminal loop");
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

