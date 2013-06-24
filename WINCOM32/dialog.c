#include "wCommon.h"

#pragma hdrstop

#include "utility.h"
#include "ioctl.h"

#include "dialog.h"
#include "usermsg.h"
#include "atom.h"

#ifdef inc_CLP
#include "clp.h"
#endif

CHAR szOn[] = "On";
CHAR szOff[] = "Off";

#define TID_CLPSTATUS TID_USERMAX - 1

BOOL bCLP_StatusActivated = FALSE;                           
USHORT wUpdateDelay = 1000;
extern HAB habAnchorBlock;
extern HEV hevStartReadSem;
extern HEV hevStartWriteSem;
extern HWND hwndFrame;
extern IOCTLINST stIOctlInst;

MRESULT EXPENTRY fnwpProcTerminalDlg(HWND hwndDlg,USHORT msg,
                                         MPARAM mp1,MPARAM mp2);
VOID FillSetColorDlg(THREAD *pstThd);
VOID UnloadSetColorDlg(THREAD *pstThd);

BOOL FillProcStringXferDlg1(THREAD *pstThd);
BOOL FillProcStringXferDlg2(THREAD *pstThd);
void InitEnableProcStringXferDlg1(THREAD *pstThd);
void InitEnableProcStringXferDlg2(THREAD *pstThd);
BOOL UnloadProcStringXferDlg(THREAD *pstThd);
BOOL TCProcStringXferDlg(THREAD *pstThd,USHORT idButton);

extern void MakeBinaryString(THREAD *pstThd,WORD wLength,BYTE xStart);

extern THREAD *pstThread;
extern char szFileSpec[];
extern char szCurrentPortName[20];

MRESULT EXPENTRY fnwpProcStringXferDlg(HWND hwndDlg,USHORT msg,
                                         MPARAM mp1,MPARAM mp2)
  {
  static THREAD *pstThd;
  WORD wLength;
  CHAR szCount[10];
  ULONG ulPostCount;

  switch (msg)
    {
    case WM_INITDLG:
//      pstThd = WinQueryWindowPtr(WinQueryWindow(hwndDlg,QW_OWNER),0);
      pstThd = pstThread;
      pstThd->hwndDlg = hwndDlg;
      CenterDlgBox(hwndDlg);
      pstThd->bAllowClick = FALSE;
      FillProcStringXferDlg1(pstThd);
      WinPostMsg(pstThd->hwndDlg,UM_INIT1,(MPARAM)(0L),(MPARAM)0L);
      break;
    case UM_INIT1:
      FillProcStringXferDlg2(pstThd);
      WinPostMsg(pstThd->hwndDlg,UM_INIT2,(MPARAM)(0L),(MPARAM)0L);
      break;
    case UM_INIT2:
      InitEnableProcStringXferDlg1(pstThd);
      WinPostMsg(pstThd->hwndDlg,UM_INIT3,(MPARAM)(0L),(MPARAM)0L);
      break;
    case UM_INIT3:
      InitEnableProcStringXferDlg2(pstThd);
      WinPostMsg(pstThd->hwndDlg,UM_INIT4,(MPARAM)(0L),(MPARAM)0L);
      break;
    case UM_INIT4:
      pstThd->bAllowClick = TRUE;
      break;
    case UM_INITMLE:
      ControlEnable(hwndDlg,PSTR_ENTSTR,FALSE);
      break;
    case WM_HELP:
      Help(hwndDlg);
      break;
    case WM_CONTROL:
      switch (SHORT2FROMMP(mp1))
        {
        case MLN_CHANGE:
          wLength = WinQueryDlgItemTextLength(hwndDlg,PSTR_ENTSTR);
          sprintf(szCount,"%u",wLength);
          WinSetDlgItemText(pstThd->hwndDlg,PSTR_WSTRLEN,szCount);
          return(FALSE);
        case MLN_SETFOCUS:
          wLength = WinQueryDlgItemTextLength(hwndDlg,PSTR_ENTSTR);
          WinPostMsg(WinWindowFromID(pstThd->hwndDlg,PSTR_ENTSTR),
                      MLM_SETSEL,
                      MPFROMLONG((ULONG)wLength),
                      MPFROMLONG(0L));
          break;
        case BN_CLICKED:
          if (pstThd->bAllowClick)
            if (!TCProcStringXferDlg(pstThd,SHORT1FROMMP(mp1)))
              return(FALSE);
          break;
        default:
          break;
        }
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          UnloadProcStringXferDlg(pstThd);
//          MenuItemEnable(pstThd,IDM_MSTRING,TRUE);
          WinDismissDlg(hwndDlg,TRUE);
          break;
        case DID_CANCEL:
          WinDismissDlg(hwndDlg,FALSE);
          break;
        default:
          return WinDefDlgProc(hwndDlg,msg,mp1,mp2);
        }
      break;
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return FALSE;
  }

BOOL FillProcStringXferDlg1(THREAD *pstThd)
  {
  CHAR szCount[10];
  CONFIG *pCfg = &pstThd->stCfg;
  HWND hwndDlg = pstThd->hwndDlg;

  /*
  **  initialize Read process entry fields
  */
  sprintf(szCount,"%u",pCfg->wReadStringLength);
  WinSendDlgItemMsg(hwndDlg,PSTR_RSTRLEN,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
  WinSetDlgItemText(hwndDlg,PSTR_RSTRLEN,szCount);
  sprintf(szCount,"%u",pCfg->chReadAppendChar);
  WinSendDlgItemMsg(hwndDlg,PSTR_APPWHAT,EM_SETTEXTLIMIT,MPFROMSHORT(3),(MPARAM)NULL);
  WinSetDlgItemText(hwndDlg,PSTR_APPWHAT,szCount);
  sprintf(szCount,"%u",pCfg->chReadAppendTriggerChar);
  WinSendDlgItemMsg(hwndDlg,PSTR_APPWHEN,EM_SETTEXTLIMIT,MPFROMSHORT(3),(MPARAM)NULL);
  WinSetDlgItemText(hwndDlg,PSTR_APPWHEN,szCount);
  sprintf(szCount,"%u",pCfg->chReadCompleteChar);
  WinSendDlgItemMsg(hwndDlg,PSTR_RTERMCHAR,EM_SETTEXTLIMIT,MPFROMSHORT(3),(MPARAM)NULL);
  WinSetDlgItemText(hwndDlg,PSTR_RTERMCHAR,szCount);
  /*
  **  initialize Read process buttons
  */
  if (pCfg->bReadAppendChar)
    CheckButton(hwndDlg,PSTR_RAPPEND,TRUE);
  if (pCfg->bAllowRead)
    CheckButton(hwndDlg,PSTR_RENAB,TRUE);
  if (pCfg->bReadCharacters)
    CheckButton(hwndDlg,PSTR_RCHAR,TRUE);
  else
    CheckButton(hwndDlg,PSTR_RSTR,TRUE);
  /*
  **  initialize Write process entry fields
  */
  WinSendDlgItemMsg(hwndDlg,PSTR_ENTSTR,EM_SETTEXTLIMIT,MPFROMSHORT(10000),(MPARAM)NULL);
  if (pstThd->pWriteString != NULL)
    WinSetDlgItemText(pstThd->hwndDlg,PSTR_ENTSTR,pstThd->pWriteString);
  sprintf(szCount,"%u",pCfg->wWriteStringLength);
  WinSendDlgItemMsg(hwndDlg,PSTR_WSTRLEN,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
  WinSetDlgItemText(hwndDlg,PSTR_WSTRLEN,szCount);
  sprintf(szCount,"%u",pCfg->wLoopTime);
  WinSendDlgItemMsg(hwndDlg,PSTR_DLYCNT,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
  WinSetDlgItemText(hwndDlg,PSTR_DLYCNT,szCount);
  return(TRUE);
  }

BOOL FillProcStringXferDlg2(THREAD *pstThd)
  {
  CHAR szCount[10];
  CONFIG *pCfg = &pstThd->stCfg;
  HWND hwndDlg = pstThd->hwndDlg;

  /*
  **  initialize Write process buttons
  */
  if (!pCfg->bSlave)
    CheckButton(hwndDlg,PSTR_STNOW,TRUE);
  else
    CheckButton(hwndDlg,PSTR_WWAIT,TRUE);
  if (!pCfg->bHalfDuplex)
    CheckButton(hwndDlg,PSTR_FULLDUP,TRUE);
  else
    CheckButton(hwndDlg,PSTR_HALFDUP,TRUE);
  if (pCfg->bWriteCharacters)
    CheckButton(hwndDlg,PSTR_WCHAR,TRUE);
  else
    CheckButton(hwndDlg,PSTR_WSTR,TRUE);

  sprintf(szCount,"%u",pCfg->chWriteAppendChar);
  WinSendDlgItemMsg(hwndDlg,PSTR_WAPPWHAT,EM_SETTEXTLIMIT,MPFROMSHORT(3),(MPARAM)NULL);
  WinSetDlgItemText(hwndDlg,PSTR_WAPPWHAT,szCount);

  if (pCfg->bWriteAppendChar)
    CheckButton(hwndDlg,PSTR_WAPPEND,TRUE);
  else
    CheckButton(hwndDlg,PSTR_WAPPEND,FALSE);

  sprintf(szCount,"%X",pCfg->xStartByte);
  WinSendDlgItemMsg(hwndDlg,EF_STARTBYTE,EM_SETTEXTLIMIT,MPFROMSHORT(2),(MPARAM)NULL);
  WinSetDlgItemText(hwndDlg,EF_STARTBYTE,szCount);

  if (!pCfg->bBinaryStream)
    {
    ControlEnable(hwndDlg,EF_STARTBYTE,FALSE);
    ControlEnable(hwndDlg,ST_STARTBYTE,FALSE);
    }

  if (pCfg->bMakeAlpha)
    CheckButton(hwndDlg,PSTR_ALPHALS,TRUE);
  else
    if (pCfg->bBinaryStream)
      CheckButton(hwndDlg,RB_BINARY,TRUE);
    else
      CheckButton(hwndDlg,PSTR_NUMLS,TRUE);

  if (pCfg->bWriteAppendSeries)
    CheckButton(hwndDlg,PSTR_WAPPSER,TRUE);
  else
    CheckButton(hwndDlg,PSTR_WAPPSER,FALSE);

  if (pCfg->bAllowWrite)
    CheckButton(hwndDlg,PSTR_WENAB,TRUE);
  if (pCfg->wLoopTime != 0)
    CheckButton(hwndDlg,PSTR_DODLY,TRUE);

  if (pCfg->bLongString)
    {
    CheckButton(hwndDlg,PSTR_MAKLONG,TRUE);
    }
  else
    CheckButton(hwndDlg,PSTR_EXPSTR,TRUE);

  return(TRUE);
  }

void InitEnableProcStringXferDlg1(THREAD *pstThd)
  {
  CONFIG *pCfg = &pstThd->stCfg;
  HWND hwndDlg = pstThd->hwndDlg;

  if (!pCfg->bAllowRead)
    {
    ControlEnable(hwndDlg,PSTR_RCHAR,FALSE);
    ControlEnable(hwndDlg,PSTR_RSTR,FALSE);
    ControlEnable(hwndDlg,PSTR_RSTRLEN,FALSE);
    ControlEnable(hwndDlg,PSTR_RSTRLENT,FALSE);
    ControlEnable(hwndDlg,PSTR_RAPPEND,FALSE);
    ControlEnable(hwndDlg,PSTR_APPWHAT,FALSE);
    ControlEnable(hwndDlg,PSTR_APPWHATT,FALSE);
    ControlEnable(hwndDlg,PSTR_APPWHEN,FALSE);
    ControlEnable(hwndDlg,PSTR_APPWHENT,FALSE);
    ControlEnable(hwndDlg,PSTR_RTERMCHAR,FALSE);
    ControlEnable(hwndDlg,PSTR_RTERMCHART,FALSE);
    }
  else
    if (pCfg->bReadCharacters)
      {
      ControlEnable(hwndDlg,PSTR_RSTRLEN,FALSE);
      ControlEnable(hwndDlg,PSTR_RSTRLENT,FALSE);
      ControlEnable(hwndDlg,PSTR_RAPPEND,TRUE);
      ControlEnable(hwndDlg,PSTR_APPWHAT,TRUE);
      ControlEnable(hwndDlg,PSTR_APPWHATT,TRUE);
      ControlEnable(hwndDlg,PSTR_APPWHEN,TRUE);
      ControlEnable(hwndDlg,PSTR_APPWHENT,TRUE);
      ControlEnable(hwndDlg,PSTR_RTERMCHAR,TRUE);
      ControlEnable(hwndDlg,PSTR_RTERMCHART,TRUE);
      }
    else
      {
      ControlEnable(hwndDlg,PSTR_RSTRLEN,TRUE);
      ControlEnable(hwndDlg,PSTR_RSTRLENT,TRUE);
      ControlEnable(hwndDlg,PSTR_RAPPEND,FALSE);
      ControlEnable(hwndDlg,PSTR_APPWHAT,FALSE);
      ControlEnable(hwndDlg,PSTR_APPWHATT,FALSE);
      ControlEnable(hwndDlg,PSTR_APPWHEN,FALSE);
      ControlEnable(hwndDlg,PSTR_APPWHENT,FALSE);
      ControlEnable(hwndDlg,PSTR_RTERMCHAR,FALSE);
      ControlEnable(hwndDlg,PSTR_RTERMCHART,FALSE);
      }
  }

void InitEnableProcStringXferDlg2(THREAD *pstThd)
  {
  CONFIG *pCfg = &pstThd->stCfg;
  HWND hwndDlg = pstThd->hwndDlg;

  if (!pCfg->bAllowWrite)
    {
    ControlEnable(hwndDlg,PSTR_WCHAR,FALSE);
    ControlEnable(hwndDlg,PSTR_WSTR,FALSE);
    ControlEnable(hwndDlg,PSTR_STNOW,FALSE);
    ControlEnable(hwndDlg,PSTR_WWAIT,FALSE);
    ControlEnable(hwndDlg,PSTR_FULLDUP,FALSE);
    ControlEnable(hwndDlg,PSTR_HALFDUP,FALSE);
    ControlEnable(hwndDlg,PSTR_DODLY,FALSE);
    ControlEnable(hwndDlg,PSTR_DLYT,FALSE);
    ControlEnable(hwndDlg,PSTR_MILLIT,FALSE);
    ControlEnable(hwndDlg,PSTR_DLYCNT,FALSE);
    ControlEnable(hwndDlg,PSTR_EXPSTR,FALSE);
    ControlEnable(hwndDlg,PSTR_ENTSTR,FALSE);
    ControlEnable(hwndDlg,PSTR_NUMLS,FALSE);
    ControlEnable(hwndDlg,PSTR_ALPHALS,FALSE);
    ControlEnable(hwndDlg,PSTR_WSTRLEN,FALSE);
    ControlEnable(hwndDlg,PSTR_MAKLONG,FALSE);
    ControlEnable(hwndDlg,PSTR_WSTR,FALSE);
    ControlEnable(hwndDlg,PSTR_WCHAR,FALSE);
    ControlEnable(hwndDlg,PSTR_WAPPSER,FALSE);
    ControlEnable(hwndDlg,PSTR_WAPPWHAT,FALSE);
    ControlEnable(hwndDlg,PSTR_WAPPEND,FALSE);
    ControlEnable(hwndDlg,EF_STARTBYTE,FALSE);
    ControlEnable(hwndDlg,ST_STARTBYTE,FALSE);
    ControlEnable(hwndDlg,RB_BINARY,FALSE);
    }
  else
    {
    if (!pCfg->bWriteAppendChar)
      {
      ControlEnable(hwndDlg,PSTR_APPWHAT,FALSE);
      ControlEnable(hwndDlg,PSTR_APPWHATT,FALSE);
      ControlEnable(hwndDlg,PSTR_APPWHEN,FALSE);
      ControlEnable(hwndDlg,PSTR_APPWHENT,FALSE);
      }

    if (pCfg->wLoopTime == 0)
      {
      ControlEnable(hwndDlg,PSTR_DLYT,FALSE);
      ControlEnable(hwndDlg,PSTR_MILLIT,FALSE);
      ControlEnable(hwndDlg,PSTR_DLYCNT,FALSE);
      }
    if (pCfg->bLongString)
      WinPostMsg(pstThd->hwndDlg,UM_INITMLE,(MPARAM)(0L),(MPARAM)0L);
    else
      {
      ControlEnable(hwndDlg,PSTR_ENTSTR,TRUE);
      ControlEnable(hwndDlg,PSTR_NUMLS,FALSE);
      ControlEnable(hwndDlg,PSTR_ALPHALS,FALSE);
      ControlEnable(hwndDlg,EF_STARTBYTE,FALSE);
      ControlEnable(hwndDlg,ST_STARTBYTE,FALSE);
      ControlEnable(hwndDlg,RB_BINARY,FALSE);
      WinSendDlgItemMsg(pstThd->hwndDlg,
                        PSTR_WSTRLEN,
                        EM_SETREADONLY,
                        MPFROMSHORT(TRUE),
                        (MPARAM)NULL);
      }
    }
  }

BOOL UnloadProcStringXferDlg(THREAD *pstThd)
  {
  CHAR szCount[10];
  CONFIG *pCfg = &pstThd->stCfg;
  HWND hwndDlg = pstThd->hwndDlg;
  THREADCTRL *pThread = &pstThd->stThread;
  ULONG ulPostCount;
  char szStartByte[10];
  /*
  **  unload write process parameters
  */
  if (Checked(hwndDlg,CB_RESETCOUNTER))
    pCfg->wWriteCounter = 0;
  if (!Checked(hwndDlg,PSTR_WENAB))
    {
    pCfg->bAllowWrite = FALSE;
    pCfg->bHalfDuplex = FALSE;
    if (!pThread->bStopThread)
      {
      DosResetEventSem(hevStartReadSem,&ulPostCount);
      DosResetEventSem(hevStartWriteSem,&ulPostCount);
      }
    }
  else
    {
    pCfg->bAllowWrite = TRUE;

    if (Checked(hwndDlg,PSTR_DODLY))
      {
//      WinQueryDlgItemShort(hwndDlg,PSTR_DLYCNT,&pCfg->wLoopTime,FALSE);
      WinQueryDlgItemText(hwndDlg,PSTR_DLYCNT,sizeof(szCount),szCount);
      pCfg->wLoopTime = (WORD)atol(szCount);
      }
    else
      pCfg->wLoopTime = 0;

    if (Checked(hwndDlg,PSTR_WCHAR))
      pCfg->bWriteCharacters = TRUE;
    else
      pCfg->bWriteCharacters = FALSE;

    if (Checked(hwndDlg,PSTR_EXPSTR))
      {
      pCfg->bLongString = FALSE;
      pCfg->wWriteStringLength = WinQueryDlgItemTextLength(hwndDlg,PSTR_ENTSTR);
      GetMessageBuffer((PPVOID)&pstThd->pWriteString,pCfg->wWriteStringLength);
      WinQueryDlgItemText(hwndDlg,PSTR_ENTSTR,(pCfg->wWriteStringLength + 1),
                                                      pstThd->pWriteString);
      pstThd->pWriteString[pCfg->wWriteStringLength] = 0;
      }
    else
      {
      pCfg->bLongString = TRUE;
      WinQueryDlgItemText(hwndDlg,PSTR_WSTRLEN,sizeof(szCount),szCount);
      pCfg->wWriteStringLength = (WORD)atol(szCount);
      pCfg->bBinaryStream = FALSE;
      if (Checked(hwndDlg,PSTR_ALPHALS))
        {
        pCfg->bMakeAlpha = TRUE;
        MakeLongString(pstThd,pCfg->wWriteStringLength,TRUE);
        }
      else
        {
        pCfg->bMakeAlpha = FALSE;
        if (Checked(hwndDlg,RB_BINARY))
          {
          pCfg->bBinaryStream = TRUE;
          WinQueryDlgItemText(hwndDlg,EF_STARTBYTE,sizeof(szCount),szCount);
          pCfg->xStartByte = (BYTE)strtol(szCount,NULL,16);
          MakeBinaryString(pstThd,pCfg->wWriteStringLength,pCfg->xStartByte);
          }
        else
          MakeLongString(pstThd,pCfg->wWriteStringLength,FALSE);
        }
      }
    if (Checked(hwndDlg,PSTR_STNOW))
      pCfg->bSlave = FALSE;
    else
      pCfg->bSlave = TRUE;

    if (Checked(hwndDlg,PSTR_HALFDUP) && Checked(hwndDlg,PSTR_RENAB))
      pCfg->bHalfDuplex = TRUE;
    else
      {
      pCfg->bHalfDuplex = FALSE;
      if (!pThread->bStopThread)
        {
        DosResetEventSem(hevStartReadSem,&ulPostCount);
        DosResetEventSem(hevStartWriteSem,&ulPostCount);
        }
      }
    if (Checked(hwndDlg,PSTR_WAPPEND))
      {
      pCfg->bWriteAppendChar = TRUE;
      WinQueryDlgItemText(hwndDlg,PSTR_WAPPWHAT,sizeof(szCount),szCount);
      pCfg->chWriteAppendChar = (BYTE)atoi(szCount);
      }
    else
      pCfg->bWriteAppendChar = FALSE;

    if (Checked(hwndDlg,PSTR_WAPPSER))
      pCfg->bWriteAppendSeries = TRUE;
    else
      pCfg->bWriteAppendSeries = FALSE;
    }
  /*
  **  unload read process parameters
  */
  if (!Checked(hwndDlg,PSTR_RENAB))
    {
    pCfg->bAllowRead = FALSE;
    pCfg->bHalfDuplex = FALSE;
    if (!pThread->bStopThread)
      {
      DosResetEventSem(hevStartReadSem,&ulPostCount);
      DosResetEventSem(hevStartWriteSem,&ulPostCount);
      }
    }
  else
    {
    pCfg->bAllowRead = TRUE;
    if (Checked(hwndDlg,PSTR_HALFDUP) && Checked(hwndDlg,PSTR_WENAB))
      pCfg->bHalfDuplex = TRUE;
    else
      {
      pCfg->bHalfDuplex = FALSE;
      if (!pThread->bStopThread)
        {
        DosResetEventSem(hevStartReadSem,&ulPostCount);
        DosResetEventSem(hevStartWriteSem,&ulPostCount);
        }
      }
    if (Checked(hwndDlg,PSTR_RCHAR))
      {
      pCfg->bReadCharacters = TRUE;
      WinQueryDlgItemText(hwndDlg,PSTR_RTERMCHAR,sizeof(szCount),szCount);
      pCfg->chReadCompleteChar = (BYTE)atoi(szCount);
      if (Checked(hwndDlg,PSTR_RAPPEND))
        {
        pCfg->bReadAppendChar = TRUE;
        WinQueryDlgItemText(hwndDlg,PSTR_APPWHAT,sizeof(szCount),szCount);
        pCfg->chReadAppendChar = (BYTE)atoi(szCount);
        WinQueryDlgItemText(hwndDlg,PSTR_APPWHEN,sizeof(szCount),szCount);
        pCfg->chReadAppendTriggerChar = (BYTE)atoi(szCount);
        }
      else
        pCfg->bReadAppendChar = FALSE;
      }
    else
      {
      pCfg->bReadCharacters = FALSE;
      WinQueryDlgItemText(hwndDlg,PSTR_RSTRLEN,sizeof(szCount),szCount);
      pCfg->wReadStringLength = (WORD)atol(szCount);
      }
    }
  return(TRUE);
  }

BOOL TCProcStringXferDlg(THREAD *pstThd,USHORT idButton)
  {
  CONFIG *pCfg = &pstThd->stCfg;
  HWND hwndDlg = pstThd->hwndDlg;

  switch(idButton)
    {
    case PSTR_NUMLS:
      if (!Checked(hwndDlg,PSTR_NUMLS))
        {
        CheckButton(hwndDlg,PSTR_NUMLS,TRUE);
        CheckButton(hwndDlg,PSTR_ALPHALS,FALSE);
        if (Checked(hwndDlg,RB_BINARY))
          {
          CheckButton(hwndDlg,RB_BINARY,FALSE);
          ControlEnable(hwndDlg,EF_STARTBYTE,FALSE);
          ControlEnable(hwndDlg,ST_STARTBYTE,FALSE);
          }
        }
      break;
    case PSTR_ALPHALS:
      if (!Checked(hwndDlg,PSTR_ALPHALS))
        {
        CheckButton(hwndDlg,PSTR_ALPHALS,TRUE);
        CheckButton(hwndDlg,PSTR_NUMLS,FALSE);
        if (Checked(hwndDlg,RB_BINARY))
          {
          CheckButton(hwndDlg,RB_BINARY,FALSE);
          ControlEnable(hwndDlg,EF_STARTBYTE,FALSE);
          ControlEnable(hwndDlg,ST_STARTBYTE,FALSE);
          }
        }
      break;
    case RB_BINARY:
      if (!Checked(hwndDlg,RB_BINARY))
        {
        CheckButton(hwndDlg,RB_BINARY,TRUE);
        CheckButton(hwndDlg,PSTR_ALPHALS,FALSE);
        CheckButton(hwndDlg,PSTR_NUMLS,FALSE);
        ControlEnable(hwndDlg,EF_STARTBYTE,TRUE);
        ControlEnable(hwndDlg,ST_STARTBYTE,TRUE);
        }
      break;
    case PSTR_MAKLONG:
      ControlEnable(hwndDlg,RB_BINARY,TRUE);
      if (Checked(hwndDlg,RB_BINARY))
        {
        ControlEnable(hwndDlg,EF_STARTBYTE,TRUE);
        ControlEnable(hwndDlg,ST_STARTBYTE,TRUE);
        }
      ControlEnable(hwndDlg,PSTR_NUMLS,TRUE);
      ControlEnable(hwndDlg,PSTR_ALPHALS,TRUE);
      ControlEnable(hwndDlg,PSTR_ENTSTR,FALSE);
      WinSendDlgItemMsg(pstThd->hwndDlg,
                        PSTR_WSTRLEN,
                        EM_SETREADONLY,
                        MPFROMSHORT(FALSE),
                        (MPARAM)NULL);
      break;
    case PSTR_EXPSTR:
      ControlEnable(hwndDlg,RB_BINARY,FALSE);
      ControlEnable(hwndDlg,EF_STARTBYTE,FALSE);
      ControlEnable(hwndDlg,ST_STARTBYTE,FALSE);
      ControlEnable(hwndDlg,PSTR_NUMLS,FALSE);
      ControlEnable(hwndDlg,PSTR_ALPHALS,FALSE);
      ControlEnable(hwndDlg,PSTR_ENTSTR,TRUE);
      WinSendDlgItemMsg(pstThd->hwndDlg,
                        PSTR_WSTRLEN,
                        EM_SETREADONLY,
                        MPFROMSHORT(TRUE),
                        (MPARAM)NULL);
      break;
    case PSTR_DODLY:
      if (!Checked(hwndDlg,PSTR_DODLY))
        {
        ControlEnable(hwndDlg,PSTR_DLYT,FALSE);
        ControlEnable(hwndDlg,PSTR_MILLIT,FALSE);
        ControlEnable(hwndDlg,PSTR_DLYCNT,FALSE);
        }
      else
        {
        ControlEnable(hwndDlg,PSTR_DLYT,TRUE);
        ControlEnable(hwndDlg,PSTR_MILLIT,TRUE);
        ControlEnable(hwndDlg,PSTR_DLYCNT,TRUE);
        }
      break;
    case PSTR_RENAB:
      if (!Checked(hwndDlg,PSTR_RENAB))
        {
        ControlEnable(hwndDlg,PSTR_RCHAR,FALSE);
        ControlEnable(hwndDlg,PSTR_RSTR,FALSE);
        ControlEnable(hwndDlg,PSTR_RSTRLENT,FALSE);
        ControlEnable(hwndDlg,PSTR_RSTRLEN,FALSE);
        ControlEnable(hwndDlg,PSTR_RAPPEND,FALSE);
        ControlEnable(hwndDlg,PSTR_APPWHAT,FALSE);
        ControlEnable(hwndDlg,PSTR_APPWHATT,FALSE);
        ControlEnable(hwndDlg,PSTR_APPWHEN,FALSE);
        ControlEnable(hwndDlg,PSTR_APPWHENT,FALSE);
        ControlEnable(hwndDlg,PSTR_RTERMCHAR,FALSE);
        ControlEnable(hwndDlg,PSTR_RTERMCHART,FALSE);
        ControlEnable(hwndDlg,PSTR_FULLDUP,FALSE);
        ControlEnable(hwndDlg,PSTR_HALFDUP,FALSE);
        }
      else
        {
        ControlEnable(hwndDlg,PSTR_RCHAR,TRUE);
        ControlEnable(hwndDlg,PSTR_RSTR,TRUE);
        if (Checked(hwndDlg,PSTR_WENAB))
          {
          ControlEnable(hwndDlg,PSTR_FULLDUP,TRUE);
          ControlEnable(hwndDlg,PSTR_HALFDUP,TRUE);
          }
        if (Checked(hwndDlg,PSTR_RSTR))
          {
          ControlEnable(hwndDlg,PSTR_RSTRLEN,TRUE);
          ControlEnable(hwndDlg,PSTR_RSTRLENT,TRUE);
          ControlEnable(hwndDlg,PSTR_RAPPEND,FALSE);
          ControlEnable(hwndDlg,PSTR_APPWHAT,FALSE);
          ControlEnable(hwndDlg,PSTR_APPWHATT,FALSE);
          ControlEnable(hwndDlg,PSTR_APPWHEN,FALSE);
          ControlEnable(hwndDlg,PSTR_APPWHENT,FALSE);
          ControlEnable(hwndDlg,PSTR_RTERMCHAR,FALSE);
          ControlEnable(hwndDlg,PSTR_RTERMCHART,FALSE);
          }
        else
          {
          ControlEnable(hwndDlg,PSTR_RSTRLEN,FALSE);
          ControlEnable(hwndDlg,PSTR_RSTRLENT,FALSE);
          ControlEnable(hwndDlg,PSTR_RAPPEND,TRUE);
          if (Checked(hwndDlg,PSTR_RAPPEND))
            {
            ControlEnable(hwndDlg,PSTR_APPWHAT,TRUE);
            ControlEnable(hwndDlg,PSTR_APPWHATT,TRUE);
            ControlEnable(hwndDlg,PSTR_APPWHEN,TRUE);
            ControlEnable(hwndDlg,PSTR_APPWHENT,TRUE);
            }
          else
            {
            ControlEnable(hwndDlg,PSTR_APPWHAT,FALSE);
            ControlEnable(hwndDlg,PSTR_APPWHATT,FALSE);
            ControlEnable(hwndDlg,PSTR_APPWHEN,FALSE);
            ControlEnable(hwndDlg,PSTR_APPWHENT,FALSE);
            }
          ControlEnable(hwndDlg,PSTR_RTERMCHAR,TRUE);
          ControlEnable(hwndDlg,PSTR_RTERMCHART,TRUE);
          }
        }
      break;
    case PSTR_RSTR:
      ControlEnable(hwndDlg,PSTR_RSTRLEN,TRUE);
      ControlEnable(hwndDlg,PSTR_RSTRLENT,TRUE);
      ControlEnable(hwndDlg,PSTR_RAPPEND,FALSE);
      ControlEnable(hwndDlg,PSTR_APPWHAT,FALSE);
      ControlEnable(hwndDlg,PSTR_APPWHATT,FALSE);
      ControlEnable(hwndDlg,PSTR_APPWHEN,FALSE);
      ControlEnable(hwndDlg,PSTR_APPWHENT,FALSE);
      ControlEnable(hwndDlg,PSTR_RTERMCHAR,FALSE);
      ControlEnable(hwndDlg,PSTR_RTERMCHART,FALSE);
      break;
    case PSTR_RCHAR:
      ControlEnable(hwndDlg,PSTR_RSTRLEN,FALSE);
      ControlEnable(hwndDlg,PSTR_RSTRLENT,FALSE);
      ControlEnable(hwndDlg,PSTR_RAPPEND,TRUE);
      ControlEnable(hwndDlg,PSTR_APPWHAT,TRUE);
      ControlEnable(hwndDlg,PSTR_APPWHATT,TRUE);
      ControlEnable(hwndDlg,PSTR_APPWHEN,TRUE);
      ControlEnable(hwndDlg,PSTR_APPWHENT,TRUE);
      ControlEnable(hwndDlg,PSTR_RTERMCHAR,TRUE);
      ControlEnable(hwndDlg,PSTR_RTERMCHART,TRUE);
      break;
    case PSTR_RAPPEND:
      if (Checked(hwndDlg,PSTR_RAPPEND))
        {
        ControlEnable(hwndDlg,PSTR_APPWHAT,TRUE);
        ControlEnable(hwndDlg,PSTR_APPWHATT,TRUE);
        ControlEnable(hwndDlg,PSTR_APPWHEN,TRUE);
        ControlEnable(hwndDlg,PSTR_APPWHENT,TRUE);
        }
      else
        {
        ControlEnable(hwndDlg,PSTR_APPWHAT,FALSE);
        ControlEnable(hwndDlg,PSTR_APPWHATT,FALSE);
        ControlEnable(hwndDlg,PSTR_APPWHEN,FALSE);
        ControlEnable(hwndDlg,PSTR_APPWHENT,FALSE);
        }
      break;
    case PSTR_WENAB:
      if (!Checked(hwndDlg,PSTR_WENAB))
        {
        ControlEnable(hwndDlg,PSTR_WCHAR,FALSE);
        ControlEnable(hwndDlg,PSTR_WSTR,FALSE);
        ControlEnable(hwndDlg,PSTR_STNOW,FALSE);
        ControlEnable(hwndDlg,PSTR_WWAIT,FALSE);
        ControlEnable(hwndDlg,PSTR_FULLDUP,FALSE);
        ControlEnable(hwndDlg,PSTR_HALFDUP,FALSE);
        ControlEnable(hwndDlg,PSTR_DLYT,FALSE);
        ControlEnable(hwndDlg,PSTR_MILLIT,FALSE);
        ControlEnable(hwndDlg,PSTR_DLYCNT,FALSE);
        ControlEnable(hwndDlg,PSTR_DODLY,FALSE);
        ControlEnable(hwndDlg,PSTR_EXPSTR,FALSE);
        ControlEnable(hwndDlg,PSTR_ENTSTR,FALSE);
        ControlEnable(hwndDlg,PSTR_NUMLS,FALSE);
        ControlEnable(hwndDlg,PSTR_ALPHALS,FALSE);
        ControlEnable(hwndDlg,PSTR_WSTRLEN,FALSE);
        ControlEnable(hwndDlg,PSTR_WSTRLENT,FALSE);
        ControlEnable(hwndDlg,PSTR_MAKLONG,FALSE);
        ControlEnable(hwndDlg,PSTR_WSTR,FALSE);
        ControlEnable(hwndDlg,PSTR_WCHAR,FALSE);
        ControlEnable(hwndDlg,PSTR_WAPPSER,FALSE);
        ControlEnable(hwndDlg,PSTR_WAPPWHAT,FALSE);
        ControlEnable(hwndDlg,PSTR_WAPPEND,FALSE);
        }
      else
        {
        ControlEnable(hwndDlg,PSTR_WCHAR,TRUE);
        ControlEnable(hwndDlg,PSTR_WSTR,TRUE);
        ControlEnable(hwndDlg,PSTR_STNOW,TRUE);
        ControlEnable(hwndDlg,PSTR_WWAIT,TRUE);
        ControlEnable(hwndDlg,PSTR_WSTRLENT,TRUE);
        ControlEnable(hwndDlg,RB_BINARY,TRUE);
        if (Checked(hwndDlg,RB_BINARY))
          {
          ControlEnable(hwndDlg,EF_STARTBYTE,TRUE);
          ControlEnable(hwndDlg,ST_STARTBYTE,TRUE);
          }
        if (Checked(hwndDlg,PSTR_RENAB))
          {
          ControlEnable(hwndDlg,PSTR_FULLDUP,TRUE);
          ControlEnable(hwndDlg,PSTR_HALFDUP,TRUE);
          }
        ControlEnable(hwndDlg,PSTR_DODLY,TRUE);
        if (Checked(hwndDlg,PSTR_DODLY))
          {
          ControlEnable(hwndDlg,PSTR_DLYT,TRUE);
          ControlEnable(hwndDlg,PSTR_MILLIT,TRUE);
          ControlEnable(hwndDlg,PSTR_DLYCNT,TRUE);
          }
        else
          {
          ControlEnable(hwndDlg,PSTR_DLYT,FALSE);
          ControlEnable(hwndDlg,PSTR_MILLIT,FALSE);
          ControlEnable(hwndDlg,PSTR_DLYCNT,FALSE);
          }
        ControlEnable(hwndDlg,PSTR_EXPSTR,TRUE);
        ControlEnable(hwndDlg,PSTR_MAKLONG,TRUE);
        if (Checked(hwndDlg,PSTR_MAKLONG))
          {
          ControlEnable(hwndDlg,PSTR_ENTSTR,FALSE);
          ControlEnable(hwndDlg,PSTR_WSTRLEN,TRUE);
          ControlEnable(hwndDlg,PSTR_NUMLS,TRUE);
          ControlEnable(hwndDlg,PSTR_ALPHALS,TRUE);
          }
        else
          {
          ControlEnable(hwndDlg,PSTR_ENTSTR,TRUE);
          ControlEnable(hwndDlg,PSTR_WSTRLEN,FALSE);
          ControlEnable(hwndDlg,PSTR_NUMLS,FALSE);
          ControlEnable(hwndDlg,PSTR_ALPHALS,FALSE);
          }
        ControlEnable(hwndDlg,PSTR_WSTR,TRUE);
        ControlEnable(hwndDlg,PSTR_WCHAR,TRUE);
        ControlEnable(hwndDlg,PSTR_WAPPSER,TRUE);
        ControlEnable(hwndDlg,PSTR_WAPPWHAT,TRUE);
        ControlEnable(hwndDlg,PSTR_WAPPEND,TRUE);
        if (Checked(hwndDlg,PSTR_WAPPEND))
          ControlEnable(hwndDlg,PSTR_WAPPWHAT,TRUE);
        else
          ControlEnable(hwndDlg,PSTR_WAPPWHAT,FALSE);
        }
      break;
    case PSTR_WAPPEND:
      if (Checked(hwndDlg,PSTR_WAPPEND))
        ControlEnable(hwndDlg,PSTR_WAPPWHAT,TRUE);
      else
        ControlEnable(hwndDlg,PSTR_WAPPWHAT,FALSE);
      break;
    default:
     return(FALSE);
    }
  return(TRUE);
  }

MRESULT EXPENTRY fnwpPortSelectDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  DCB stComDCB;
  static THREAD *pstThd;
  CHAR szCOMtitle[20];

  switch (msg)
    {
    case WM_INITDLG:
      CenterDlgBox(hwndDlg);
      pstThd = (THREAD *)mp2;
      break;
    case WM_HELP:
      Help(hwndDlg);
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          pstThd->hwndDlg = hwndDlg;
          WinQueryDlgItemText(hwndDlg,PS_PORTNAME,sizeof(pstThd->stCfg.szPortName),pstThd->stCfg.szPortName);
          if (pstThd->hCom)
            DosClose(pstThd->hCom);
          if (!OpenPort(pstThd))
            return(MRESULT)(TRUE);
          if (GetDCB(&stIOctlInst,pstThd->hCom,&stComDCB))
            return(FALSE);
          MenuItemEnable(hwndFrame,IDM_FUNC,TRUE);
          MenuItemEnable(hwndFrame,IDM_STATUS,TRUE);
          MenuItemEnable(hwndFrame,IDM_IOCTL,TRUE);
          if (pstThd->stCfg.wSimulateType != 0)
            MenuItemEnable(hwndFrame,IDM_SSTART,TRUE);
          if ((stComDCB.Flags3 & 0x18) == 0)
            MenuItemEnable(hwndFrame,IDM_FIFO,FALSE);
          else
            MenuItemEnable(hwndFrame,IDM_FIFO,TRUE);
          strcpy(szCurrentPortName,pstThd->stCfg.szPortName);
          sprintf(szCOMtitle,"WinCOM -> %s",pstThd->stCfg.szPortName);
          WinSetWindowText(hwndFrame,szCOMtitle);
          break;
        case DID_CANCEL:
          break;
        default:
          return WinDefDlgProc(hwndDlg,msg,mp1,mp2);
        }
      WinDismissDlg(hwndDlg,TRUE); /* Finished with dialog box    */
      break;
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return(FALSE);
  }

MRESULT EXPENTRY fnwpSetColorDlg(HWND hwndDlg,USHORT msg, MPARAM mp1,MPARAM mp2)
  {
  static THREAD *pstThd;

  switch (msg)
    {
    case WM_INITDLG:
//      pstThd = WinQueryWindowPtr(WinQueryWindow(hwndDlg,QW_OWNER),0);
      pstThd = pstThread;
      pstThd->hwndDlg = hwndDlg;
      CenterDlgBox(hwndDlg);
      FillSetColorDlg(pstThd);
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          UnloadSetColorDlg(pstThd);
          break;
        case DID_CANCEL:
          break;
        default:
          return WinDefDlgProc(hwndDlg,msg,mp1,mp2);
        }
      WinDismissDlg(hwndDlg,TRUE); /* Finished with dialog box    */
      break;
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return(FALSE);
  }

VOID FillSetColorDlg(THREAD *pstThd)
  {
  VIOPS *pVio = &pstThd->stVio;
  HWND hwndDlg = pstThd->hwndDlg;

  if (pVio->wBackground == WHITE)
    CheckButton(hwndDlg,CLR_BWHITE,TRUE);
  else
    if (pVio->wBackground == BLACK)
      CheckButton(hwndDlg,CLR_BBLACK,TRUE);
    else
      if (pVio->wBackground == BLUE)
        CheckButton(hwndDlg,CLR_BBLUE,TRUE);
      else
        if (pVio->wBackground == RED)
          CheckButton(hwndDlg,CLR_BRED,TRUE);
        else
          CheckButton(hwndDlg,CLR_BGREEN,TRUE);

  if (pVio->wForeground == WHITE)
    CheckButton(hwndDlg,CLR_FWHITE,TRUE);
  else
    if (pVio->wForeground == BLACK)
      CheckButton(hwndDlg,CLR_FBLACK,TRUE);
    else
      if (pVio->wForeground == BLUE)
        CheckButton(hwndDlg,CLR_FBLUE,TRUE);
      else
        if (pVio->wForeground == RED)
          CheckButton(hwndDlg,CLR_FRED,TRUE);
        else
          CheckButton(hwndDlg,CLR_FGREEN,TRUE);
  }

VOID UnloadSetColorDlg(THREAD *pstThd)
  {
  VIOPS *pVio = &pstThd->stVio;
  HWND hwndDlg = pstThd->hwndDlg;

  if (Checked(hwndDlg,CLR_FBLACK))
    pVio->wForeground = BLACK;
  else
    if (Checked(hwndDlg,CLR_FWHITE))
      pVio->wForeground = WHITE;
    else
      if (Checked(hwndDlg,CLR_FBLUE))
        pVio->wForeground = BLUE;
      else
        if (Checked(hwndDlg,CLR_FRED))
          pVio->wForeground = RED;
        else
          pVio->wForeground = GREEN;

  if (Checked(hwndDlg,CLR_BBLACK))
    pVio->wBackground = BLACK;
  else
    if (Checked(hwndDlg,CLR_BWHITE))
      pVio->wBackground = WHITE;
    else
      if (Checked(hwndDlg,CLR_BBLUE))
        pVio->wBackground = BLUE;
      else
        if (Checked(hwndDlg,CLR_BRED))
          pVio->wBackground = RED;
        else
          pVio->wBackground = GREEN;

  SetScreenColors(pstThd);
  }

MRESULT EXPENTRY fnwpProcTerminalDlg(HWND hwndDlg,USHORT msg,
                                         MPARAM mp1,MPARAM mp2)
  {
  static THREAD *pstThd;
  static TERMPARMS *pTerm;

  switch (msg)
    {
    case WM_INITDLG:
//      pstThd = WinQueryWindowPtr(WinQueryWindow(hwndDlg,QW_OWNER),0);
      pstThd = pstThread;
      pstThd->hwndDlg = hwndDlg;
      pTerm = &pstThd->stTerm;
      CenterDlgBox(hwndDlg);
      if (pTerm->bOutputLF)
        CheckButton(hwndDlg,PTERM_WLF,TRUE);
      if (pTerm->bInputLF)
        CheckButton(hwndDlg,PTERM_RLF,TRUE);
      if (pTerm->bLocalEcho)
        CheckButton(hwndDlg,PTERM_LOCECHO,TRUE);
      if (pTerm->bRemoteEcho)
        CheckButton(hwndDlg,PTERM_REMECHO,TRUE);
      break;
    case WM_HELP:
      Help(hwndDlg);
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          if (Checked(hwndDlg,PTERM_REMECHO))
            pTerm->bRemoteEcho = TRUE;
          else
            pTerm->bRemoteEcho = FALSE;
          if (Checked(hwndDlg,PTERM_LOCECHO))
            pTerm->bLocalEcho = TRUE;
          else
            pTerm->bLocalEcho = FALSE;
          if (Checked(hwndDlg,PTERM_RLF))
            pTerm->bInputLF = TRUE;
          else
            pTerm->bInputLF = FALSE;
          if (Checked(hwndDlg,PTERM_WLF))
            pTerm->bOutputLF = TRUE;
          else
            pTerm->bOutputLF = FALSE;
          MenuItemEnable(hwndFrame,IDM_MTERMINAL,TRUE);
          WinDismissDlg(hwndDlg,TRUE);
          break;
        case DID_CANCEL:
          WinDismissDlg(hwndDlg,FALSE);
          break;
        default:
          return WinDefDlgProc(hwndDlg,msg,mp1,mp2);
        }
      break;
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return(FALSE);
  }
#ifdef inc_CLP
MRESULT EXPENTRY fnwpSetCLP_LEDsDlg(HWND hwndDlg,USHORT msg, MPARAM mp1,MPARAM mp2)
  {
  static CLP_PPORTID_T portId = 0;
  static BYTE xData = 0;
  BYTE xNewData;
  static THREAD *pstThd;

  switch (msg)
    {
    case WM_INITDLG:
//      pstThd = WinQueryWindowPtr(WinQueryWindow(hwndDlg,QW_OWNER),0);
      pstThd = pstThread;
      pstThd->hwndDlg = hwndDlg;
      CenterDlgBox(hwndDlg);
      if (CLP_ReadParallelPort(portId, &xData) == COMMAND_SUCCESS)
        {
        if ((xData & 0x01) != 0)
          CheckButton(hwndDlg,RB_LEDONEON,TRUE);
        else
          CheckButton(hwndDlg,RB_LEDONEOFF,TRUE);
        if ((xData & 0x02) != 0)
          CheckButton(hwndDlg,RB_LEDTWOON,TRUE);
        else
          CheckButton(hwndDlg,RB_LEDTWOOFF,TRUE);
        if ((xData & 0x04) != 0)
          CheckButton(hwndDlg,RB_LEDTHREEON,TRUE);
        else
          CheckButton(hwndDlg,RB_LEDTHREEOFF,TRUE);
        if ((xData & 0x08) != 0)
          CheckButton(hwndDlg,RB_LEDFOURON,TRUE);
        else
          CheckButton(hwndDlg,RB_LEDFOUROFF,TRUE);
        }
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_CANCEL:
          break;
        case DID_OK:
        case DID_APPLY:
          xNewData = 0;
          if (Checked(hwndDlg,RB_LEDONEON))
            xNewData |= 0x01;
          if (Checked(hwndDlg,RB_LEDTWOON))
            xNewData |= 0x02;
          if (Checked(hwndDlg,RB_LEDTHREEON))
            xNewData |= 0x04;
          if (Checked(hwndDlg,RB_LEDFOURON))
            xNewData |= 0x08;
          if (xNewData != xData)
            CLP_WriteParallelPort(portId, (xData ^ xNewData), xNewData);
          if (SHORT1FROMMP(mp1) != DID_APPLY)
            break;
        default:
          return WinDefDlgProc(hwndDlg,msg,mp1,mp2);
        }
      WinDismissDlg(hwndDlg,TRUE); // Finished with dialog box   
      break;
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return(FALSE);
  }

UpdateCLP_StatusDlg(HWND hwndDlg)       
  {
  static CLP_PPORTID_T portId = 0;
  static BYTE xData = 0;
  BYTE xNewData;
  
  if (CLP_ReadParallelPort(portId, &xData) == COMMAND_SUCCESS)
    {
    if ((xData & 0x01) != 0)
      CheckButton(hwndDlg,RB_LEDONE,TRUE);
    if ((xData & 0x02) != 0)
      CheckButton(hwndDlg,RB_LEDTWO,TRUE);
    if ((xData & 0x04) != 0)
      CheckButton(hwndDlg,RB_LEDTHREE,TRUE);
    if ((xData & 0x08) != 0)
      CheckButton(hwndDlg,RB_LEDFOUR,TRUE);
    }
  }
        
MRESULT EXPENTRY fnwpCLP_StatusDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static ULONG idTimer;
//  char szCaption[80];

  switch (msg)
    {
    case WM_INITDLG:
      idTimer = 0L;
      CenterDlgBox(hwnd);
      break;
    case UM_INITLS:
      if (!bCLP_StatusActivated)
        {
        bCLP_StatusActivated = TRUE;
        WinSetWindowPos(hwnd,HWND_TOP,10,60,0,0,SWP_MOVE);
        WinShowWindow(hwnd,TRUE);
//        WinSetFocus(HWND_DESKTOP,hwndFrame);
        UpdateCLP_StatusDlg(hwnd);
        idTimer = WinStartTimer(habAnchorBlock,
                                hwnd,
                                TID_CLPSTATUS,
                                wUpdateDelay);
        }
      break;  
    case WM_CLOSE:
//    case UM_KILL_MONITOR:
      bCLP_StatusActivated = FALSE;
      if (idTimer)
        {
        WinStopTimer(habAnchorBlock,
                     hwnd,
                     idTimer);
        idTimer = 0L;
        }
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    case UM_RESETTIMER:
      if (idTimer != 0L)
        idTimer = WinStartTimer(habAnchorBlock,
                                hwnd,
                                idTimer,
                                wUpdateDelay);
      break;
    case WM_TIMER:
      UpdateCLP_StatusDlg(hwnd);
      return(FALSE);
//    case WM_ACTIVATE:
//      if (bCLP_StatusActivated)
//        WinSetFocus(HWND_DESKTOP,hwndFrame);
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return FALSE;
  }
#endif
#ifdef this_junk
/*********************************************************************/
/*                                                                   */
/* PRIVATE FUNCTION: SetSystemMenu                                   */
/*                                                                   */
/* Edit items in the system menu to leave "Move", "Close", and       */
/* "Switch to Task Manager".                                         */
/*                                                                   */
/*********************************************************************/
VOID cdecl SetSystemMenu(THREAD *pstThd)
  {
  HWND     hwndSysMenu;                 /* sys menu pull-down handle */
  MENUITEM miTemp;                      /* menu item template        */
  SHORT    sItemId;                     /* system menu item ID       */
  SHORT    sItemIndex;                  /* system menu item index    */

  /*******************************************************************/
  /* Get the handle of the system menu pull-down.                    */
  /*******************************************************************/
  hwndSysMenu = WinWindowFromID(pstThd->hwndDlg,FID_SYSMENU);
  WinSendMsg( hwndSysMenu,
              MM_QUERYITEM,
              MPFROM2SHORT( SC_SYSMENU, FALSE ),
              MPFROMP( (PSZ)&miTemp ));
  hwndSysMenu = miTemp.hwndSubMenu;

  /*******************************************************************/
  /* Remove all items from the system menu pull-down that are no     */
  /* longer wanted.                                                  */
  /*******************************************************************/
  for (sItemIndex = 0,sItemId = 0;sItemId != MIT_ERROR;sItemIndex++)
    {
    sItemId = (SHORT)WinSendMsg(hwndSysMenu,
                                MM_ITEMIDFROMPOSITION,
                                MPFROMSHORT(sItemIndex),
                                NUL);
    if (sItemId != MIT_ERROR &&
        sItemId != SC_MOVE   &&
        sItemId != SC_CLOSE  &&
        sItemId != SC_TASKMANAGER)
      {
      WinSendMsg(hwndSysMenu,
                 MM_DELETEITEM,
                 MPFROM2SHORT(sItemId,FALSE),
                 NUL);
      sItemIndex--;
      }
    }
  }
#endif
