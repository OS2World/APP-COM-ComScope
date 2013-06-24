/*******************************************************************************
*
*       Copyright (C) 1988-89 OS/tools Incorporated -- All rights reserved
*
*******************************************************************************/
#include "wCommon.h"

#pragma hdrstop

extern THREAD *pstThread;

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
