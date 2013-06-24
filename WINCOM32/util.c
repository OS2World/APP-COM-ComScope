#include "wCommon.h"

#pragma hdrstop

#include "dialog.h"

extern IOCTLINST stIOctlInst;
extern THREAD *pstThread;
extern CHAR chAnsi[8];

extern BOOL bMaximized;
extern BOOL bMinimized;
extern HWND hwndFrame;
extern SWP swpLastPosition;

extern struct VioClr
         {
         BYTE PSClr;
         CHAR AnsiClr;
         }ClrTable[5];

BYTE QueryAnsiClr(BYTE PSClr);

extern CHAR szErrorMessage[];

void MenuCheckSeries(HWND hwnd,WORD idStart,int iCount,WORD idItem)
  {
  WORD idIndex;
  WORD idLast = idStart + iCount;

  for (idIndex = idStart;idIndex < idLast;idIndex++)
    {
    if (idIndex == idItem)
      MenuItemCheck(hwnd,idItem,TRUE);
    else
      MenuItemCheck(hwnd,idIndex,FALSE);
    }
  }

BOOL OpenPort(THREAD *pstThd)
  {
  ULONG ulAction;
  APIRET rc;
  CHAR szMsgString[200];
  CHAR szCaption[80];

  if ((rc = DosOpen(pstThd->stCfg.szPortName,&pstThd->hCom,&ulAction,0L,0,0x0001,0x21c2,0L)) != 0)
    {
    WinQueryWindowText(pstThd->hwndFrame,sizeof(szCaption),szCaption);
//    WinLoadString(pstThd->habAnchorBlk,NUL,EATM_DOSOPEN,
//                  sizeof(szMsgString),szMsgString);
    sprintf(szMsgString,"Error opening %s\nError Code = %04X",pstThd->stCfg.szPortName,rc);

    WinMessageBox( HWND_DESKTOP,
                   pstThd->hwndDlg,
                   (PSZ)szMsgString,
                   (PSZ)szCaption,
                   NUL,
                   MB_MOVEABLE | MB_OK | MB_CUAWARNING );
    pstThd->hCom = 0;
    return(FALSE);
    }
  return(TRUE);
  }

void ErrorNotify(THREAD *pstThd,CHAR szMessage[])
  {
  if (pstThd->stCfg.bErrorOut)
    {
    strcpy(szErrorMessage,szMessage);
    WinInvalidateRect(pstThd->hwndStatus,(PRECTL)NULL,FALSE);
    }
  }

BOOL GetMessageBuffer(PPVOID ppString,WORD wBufferLength)
  {
  if (*ppString != NULL)
    DosFreeMem(ppString);
  DosAllocMem(ppString,(wBufferLength + 1),(PAG_COMMIT | PAG_READ | PAG_WRITE));
  if (*ppString == NULL)
    return(FALSE);
  return(TRUE);
  }

void MakeLongString(THREAD *pstThd,WORD wLength,BOOL bAlpha)
  {
  BYTE byIndex = '1';
  WORD wIndex;
  CONFIG *pCfg = &pstThd->stCfg;

  if (GetMessageBuffer((PPVOID)&pstThd->pWriteString,wLength))
    {
    for (wIndex = 0;wIndex < wLength;wIndex++)
      {
      pstThd->pWriteString[wIndex] = byIndex;
      if (bAlpha)
        {
        switch (byIndex)
          {
          case 'Z':
            byIndex = 'a';
            break;
          case 'z':
            byIndex = '0';
            break;
          case '9':
            byIndex = 'A';
            break;
          default:
            byIndex++;
            break;
          }
        }
      else
        {
        if (byIndex == '9')
          byIndex = '0';
        else
          byIndex++;
        }
      }
    pstThd->pWriteString[wIndex] = 0;
    pCfg->wWriteStringLength = wLength;
    }
  }

void MakeBinaryString(THREAD *pstThd,WORD wLength,BYTE xStart)
  {
  BYTE xIndex = xStart;
  WORD wIndex;
  CONFIG *pCfg = &pstThd->stCfg;

  if (GetMessageBuffer((PPVOID)&pstThd->pWriteString,wLength))
    {
    for (wIndex = 0;wIndex < wLength;wIndex++)
      pstThd->pWriteString[wIndex] = xIndex++;
    pCfg->wWriteStringLength = wLength;
    }
  }

void PauseThread(THREAD *pstThd)
  {
  WORD wSaveReadTimeout;
  WORD wSaveWriteTimeout;
  BYTE bySaveFlags3;
  DCB stComDCB;

  GetDCB(&stIOctlInst,pstThd->hCom,&stComDCB);
  wSaveReadTimeout = stComDCB.ReadTimeout;
  wSaveWriteTimeout = stComDCB.WrtTimeout;
  bySaveFlags3 = stComDCB.Flags3;
  stComDCB.ReadTimeout = 1;
  stComDCB.WrtTimeout = 1;
  stComDCB.Flags3 = F3_WAIT_NONE;
  SendDCB(&stIOctlInst,pstThd->hCom,&stComDCB);
  KillThread(pstThd);
  stComDCB.WrtTimeout = wSaveWriteTimeout;
  stComDCB.ReadTimeout = wSaveReadTimeout;
  stComDCB.Flags3 = bySaveFlags3;
  SendDCB(&stIOctlInst,pstThd->hCom,&stComDCB);
  }

#ifdef this_junk
void FlushComBuffer(THREAD *pstThd,WORD wDirection)
  {
  WORD Error;
  BYTE byParam = 0;

  if ((Error = DosDevIOCtl(NULL,(PVOID)&byParam,wDirection,0x0b,pstThd->hCom)) != 0)
    IOctlErrorMessageBox(pstThd,HWB_BAUD,ATM_DCBWRT,0x0b,Error);
  }
#endif
void SendXonXoff(THREAD *pstThd,WORD wSignal)
  {
  DCB stComDCB;
  BYTE byTemp;

  GetDCB(&stIOctlInst,pstThd->hCom,&stComDCB);
  if (wSignal == SEND_XON)
    byTemp = stComDCB.XonChar;
  else
    byTemp = stComDCB.XoffChar;

  SendByteImmediate(&stIOctlInst,pstThd->hCom,byTemp);
  }

VOID SetScreenColors(THREAD *pstThd)
  {
  VIOCELL Cell;
  VIOPS *pVio = &pstThd->stVio;
  WORD wRow;
  WORD wColumn;
  BYTE byBackground;
  BYTE byForeground;


  byBackground = ClrTable[pVio->wBackground].PSClr;
  byForeground = ClrTable[pVio->wForeground].PSClr;

  Cell.ExtAttr = Cell.Spare = 0;
  Cell.Attr    =  (byBackground << 4) | byForeground;

  DosEnterCritSec();
  VioGetCurPos(&wRow,&wColumn,pVio->hpsVio);
  VioWrtNAttr((PBYTE)&Cell.Attr,pVio->usPsWidth * pVio->usPsDepth,0,0,pVio->hpsVio);
  VioSetCurPos(wRow,wColumn,pVio->hpsVio);
  DosExitCritSec();
  }

VOID ClearScreen(THREAD *pstThd)
  {
  VIOCELL Cell;
  VIOPS *pVio = &pstThd->stVio;
  BYTE byBackground;
  BYTE byForeground;


  byBackground = ClrTable[pVio->wBackground].PSClr;
  byForeground = ClrTable[pVio->wForeground].PSClr;


  /*
  ** Set foreground and background colors in ANSI, so that the
  ** VioWrtTTY function will pick up the correct colors.
  */
  chAnsi[ANSI_FORE] = QueryAnsiClr(byForeground);
  chAnsi[ANSI_BACK] = QueryAnsiClr(byBackground);
  VioSetAnsi (ANSI_ON,pVio->hpsVio);
  VioWrtTTY( (PCH)chAnsi,sizeof(chAnsi),pVio->hpsVio);
  if (!pstThd->stCfg.bEnableAnsi)
    VioSetAnsi (ANSI_OFF,pVio->hpsVio);

  /*
  ** Set Presentation Space to a known state - full of spaces.
  */
  Cell.vc      = ' ';
  Cell.ExtAttr = Cell.Spare = 0;
  Cell.Attr    =  (byBackground << 4) | byForeground;
  VioWrtNCell((PBYTE)&Cell,pVio->usPsWidth * pVio->usPsDepth,0,0,pVio->hpsVio);
  VioSetOrg(0,0,pVio->hpsVio);
  VioSetCurPos(0,0,pVio->hpsVio);

  /*
  ** Zero the scroll bars.
  */
  WinSendMsg(WinWindowFromID(pstThd->hwndFrame,FID_VERTSCROLL),
             SBM_SETPOS,
             MPFROMSHORT(0),
             MPFROMSHORT(0));

  WinSendMsg(WinWindowFromID(pstThd->hwndFrame,FID_HORZSCROLL),
             SBM_SETPOS,
             MPFROMSHORT(0),
             MPFROMSHORT(0));

  WinSendMsg(WinWindowFromID(pstThd->hwndFrame,FID_VERTSCROLL),
              SBM_SETTHUMBSIZE,
              MPFROM2SHORT(pVio->usWndWidth,pVio->usPsWidth),
              (MPARAM)NULL);

  WinSendMsg(WinWindowFromID(pstThd->hwndFrame,FID_HORZSCROLL),
              SBM_SETTHUMBSIZE,
              MPFROM2SHORT(pVio->usWndDepth,pVio->usPsDepth),
              (MPARAM)NULL);

  }

/**************************************************************************/
/* GETANSICLR                                                             */
/* Find equivalent ANSI color value for an EGA value.                     */
/**************************************************************************/
BYTE QueryAnsiClr(BYTE PSClr)
  {
  SHORT i;

  for( i=0; i < sizeof( ClrTable ); i++ )
    if( ClrTable[i].PSClr == PSClr )
      return( ClrTable[i].AnsiClr );
  return(0);                                         /* error */
  }

void SaveWindowPositions(CONFIG *pCfg)
  {
  SWP swp;

  if (pCfg->bLoadWindowPosition)
    {
    if (bMinimized || bMaximized)
      memcpy(&swp,&swpLastPosition,sizeof(SWP));
    else
      WinQueryWindowPos(hwndFrame,&swp);
    pCfg->ptlFramePos.x = swp.x;
    pCfg->ptlFramePos.y = swp.y;
    pCfg->ptlFrameSize.x = swp.cx;
    pCfg->ptlFrameSize.y = swp.cy;
    }
  }


