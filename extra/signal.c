#include "comscope.h"

#include <utility.h>
#include <OS$tools.h>

MRESULT EXPENTRY fnwpSetColorDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);

extern LONG lYScr;
extern LONG lcyBrdr;
extern LONG lXScr;
extern LONG lcxVSc;
extern LONG lcxBrdr;
extern LONG lcyMenu;
extern LONG lcyTitleBar;

extern WORD wASCIIfont;
extern WORD wHEXfont;

static TRACKINFO stSigTrack;

extern LONG lStatusHeight;

extern BOOL bSendNextKeystroke;
extern HMTX hmtxSigGioBlockedSem;
extern CHARCELL stCell;
extern HWND hwndFrame;
extern HWND hwndClient;
extern HWND hwndStatus;
extern BOOL bStopDisplayThread;

extern HAB habAnchorBlock;

//extern MRESULT EXPENTRY fnwpDisplaySetupDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);

BOOL TrackChildWindow(HAB hab,HWND hwnd,PRECTL prcl,LONG flMoveFrom);
void SignalSize(SIGNAL *pstSignal);
void ColumnPaint(SIGNAL *pstSignal);

extern CSCFG stCFG;

extern BOOL bFrameActivated;

MRESULT EXPENTRY fnwpSignalDisplayClient(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  RECTL   rclRect;
  POINTL ptl;
  LONG lSaveEdge;
  HWND hwndMenu;
  SIGNAL *pstSignal;

  switch(msg)
    {
    case WM_CHAR:
      if (bSendNextKeystroke)
        if (ProcessKeystroke(mp1,mp2))
          return((MRESULT)TRUE);
      return( WinDefWindowProc(hwnd,msg,mp1,mp2));
    case WM_CREATE:
      pstSignal = PVOIDFROMMP(mp2);
      WinSetWindowULong(hwnd,QWL_USER,(ULONG)pstSignal);
      pstSignal->hdcPs = WinOpenWindowDC(hwnd);
      pstSignal->usLastPopupItem = IDMPU_MOVE_WIN;
      pstSignal->bActive = FALSE;
      pstSignal->wLevel = SIG_HIGH;
      usMenuStyle = (PU_POSITIONONITEM | PU_MOUSEBUTTON2 | PU_HCONSTRAIN | PU_VCONSTRAIN | PU_KEYBOARD | PU_MOUSEBUTTON1);
      WinSendMsg(hwnd,UM_TRACKFRAME,0L,0L);
      break;
    case WM_ACTIVATE:
      if(SHORT1FROMMP(mp1))
        {
        if (!bFrameActivated)
          {
          WinSetFocus(HWND_DESKTOP,hwndFrame);
          WinSendMsg(WinQueryHelpInstance(hwndClient),HM_SET_ACTIVE_WINDOW,0L,0L);
          bFrameActivated = TRUE;
          }
        }
      else
        bFrameActivated = FALSE;
      break;
    case WM_COMMAND:
      pstSignal = (SIGNAL *)WinQueryWindowULong(hwnd,QWL_USER);
      switch (SHORT1FROMMP(mp1))
        {
         case IDMPU_COLORS:
          if (!stCFG.bStickyMenus)
            pstSignal->usLastPopupItem = IDMPU_MOVE_WIN;
          else
            pstSignal->usLastPopupItem = IDMPU_COLORS
//          stColor.lForeground = stCFG.lReadColForegrndColor;
//          stColor.lBackground = stCFG.lReadColBackgrndColor;
//          sprintf(stColor.szCaption,"Lexical Receive Data Display Colors");
          if (WinDlgBox(HWND_DESKTOP,
                        hwnd,
                 (PFNWP)fnwpSetColorDlg,
                (USHORT)NULL,
                        CLR_DLG,
                MPFROMP(&pstSignal->stColor)))
            {
//            stCFG.lReadColForegrndColor = stColor.lForeground;
//            stCFG.lReadColBackgrndColor = stColor.lBackground;
//            stRead.lBackgrndColor = stColor.lBackground;
//            stRead.lForegrndColor = stColor.lForeground;
            WinInvalidateRect(hwnd,(PRECTL)NULL,FALSE);
            }
          break;
        }
      break;
//    case WM_CHORD:
    case WM_BUTTON2DOWN:
      if(bFrameActivated)
        {
        pstSignal = (SIGNAL *)WinQueryWindowULong(hwnd,QWL_USER);
        hwndMenu = WinLoadMenu(hwnd,(HMODULE)NULL,IDMPU_COL_DISP_POPUP);
        WinQueryPointerPos(HWND_DESKTOP,&ptl);
        if (!stCFG.bStickyMenus)
          pstSignal->usMenuStyle |= PU_MOUSEBUTTON2DOWN;
        else
          pstSignal->usMenuStyle &= ~PU_MOUSEBUTTON2DOWN;
        WinPopupMenu(HWND_DESKTOP,hwnd,hwndMenu,ptl.x,ptl.y,pstSignal->usLastPopupItem,pstSignal->usMenuStyle);
        }
      else
        return WinDefWindowProc(hwnd,msg,mp1,mp2);
      break;
    case WM_BUTTON1DOWN:
      if(bFrameActivated)
        {
        WinCopyRect(habAnchorBlock,&rclRect,&stRead.rcl);
        lSaveEdge = rclRect.xLeft;
        if (TrackChildWindow(habAnchorBlock,hwndClient,&rclRect,TF_LEFT))
          {
          if (rclRect.xLeft != lSaveEdge)
            {
            WinSendMsg(stWrite.hwndClient,UM_TRACKSIB,0L,(MPARAM)rclRect.xLeft);
            WinSendMsg(stRead.hwndClient,UM_TRACKSIB,(MPARAM)rclRect.xLeft,0L);
            if (stCFG.fLockWidth == LOCK_WRITE)
              stCFG.lLockWidth = ((stWrite.lWidth / stCell.cx) + 1);
            else
              stCFG.lLockWidth = ((stRead.lWidth / stCell.cx) + 1);
            }
          }
        }
      else
        return WinDefWindowProc(hwnd,msg,mp1,mp2);
      break;
    case WM_DESTROY:
      pstSignal = (SIGNAL *)WinQueryWindowULong(hwnd,QWL_USER);
      GpiDestroyPS(pstSignal->hdcPs);
      break;
    case UM_SHOWAGAIN:
      pstSignal = (SIGNAL *)WinQueryWindowULong(hwnd,QWL_USER);
      pstSignal->bActive = TRUE;
      WinShowWindow(hwnd,TRUE);
      WinSendMsg(hwnd,UM_TRACKFRAME,0L,0L);
      WinInvalidateRect(hwnd,(PRECTL)NULL,FALSE);
      WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
      break;    case UM_HIDEWIN:
      pstSignal = (SIGNAL *)WinQueryWindowULong(hDlg,QWL_USER);
      pstSignal->bActive = FALSE;
      WinShowWindow(hwnd,FALSE);
      WinSetWindowPos(hwnd,HWND_BOTTOM,0L,0L,0L,0L,(SWP_MOVE | SWP_SIZE | SWP_ZORDER));
      break;
    case WM_PAINT:
      pstSignal = (SIGNAL *)WinQueryWindowULong(hwnd,QWL_USER);
      SignalPaint(pstSignal);
      break;
#ifdef this_junk
    case UM_TRACKSIB:
      ColumnSize(&stRead,(LONG)mp1,(LONG)mp2,TRUE);
      break;
    case UM_TRACKFRAME:
      ColumnSize(&stRead,(LONG)mp1,(LONG)mp2,FALSE);
      break;
#endif
    case WM_ERASEBACKGROUND:
      return (MRESULT)(TRUE);
    case WM_CLOSE:
      WinPostMsg(hwnd,WM_QUIT,0L,0L);
    default:
      return WinDefWindowProc(hwnd,msg,mp1,mp2);
    }
  return(FALSE);
  }

BOOL TrackChildWindow(HAB hab,HWND hwnd,PRECTL prcl,LONG flMoveFrom)
  {

  WinCopyRect(hab,&stSigTrack.rclTrack,prcl);

  WinQueryWindowRect(hwndClient,&stSigTrack.rclBoundary);

  stSigTrack.fs = (flMoveFrom | TF_ALLINBOUNDARY | TF_SETPOINTERPOS | TF_GRID);

  if (!WinTrackRect(hwnd,0L,&stSigTrack))
    return(FALSE);
  WinCopyRect(hab,prcl,&stSigTrack.rclTrack);
  return(TRUE);
  }

void SignalPaint(SIGNAL *pstSignal)
  {
  HPS hps;
  RECTL rclClient;
  RECTL rcl

  DosRequestMutexSem(hmtxSigGioBlockedSem,10000);
  hps = WinBeginPaint(pstSignal->hwnd,(HPS)NULL,&rcl);
  if (WinIsWindowShowing(pstSignal->hwnd))
    {
    WinQueryWindowRect(hwndClient,&rclClient);
    rcl.yBottom = 0;
    rcl.yTop = stCell.cy;
    rcl.xLeft = 0;
    rcl.xRight = rclClient.xRight;
    WinFillRect(hps,&rcl,pstSignal->lBackgrndColor);

    }
  WinEndPaint(hps);
  DosReleaseMutexSem(hmtxSigGioBlockedSem);
  }

void SignalSize(SIGNAL *pstSignal)
  {
  APIRET rc;
  char szMessage[80];
  RECTL rclClient;

  if ((rc = DosRequestMutexSem(hmtxSigGioBlockedSem,10000)) != NO_ERROR)
    {
    sprintf(szMessage,"DosRequestMutexSem error in ColumnSize: return code = %ld", rc);
    ErrorNotify(szMessage);
    }

    WinQueryWindowRect(hwndClient,&rclClient);

    pstScreen->rcl.yBottom = (rclClient.yBottom + lStatusHeight);
    pstScreen->rcl.yTop = rclClient.yTop;
    pstScreen->lHeight = (pstScreen->rcl.yTop - pstScreen->rcl.yBottom - stCell.cy);
    pstScreen->lCharHeight = ((pstScreen->lHeight / stCell.cy) + 1);
    stColTrack.ptlMaxTrackSize.y = (stCell.cy * pstScreen->lCharHeight);
//    SetColScrollRowCount(pstScreen);
    }
  pstScreen->lWidth = (pstScreen->rcl.xRight - pstScreen->rcl.xLeft - stCell.cx);
  pstScreen->lCharWidth = ((pstScreen->lWidth  / stCell.cx) + 1);
  pstScreen->lCharSize = (pstScreen->lCharWidth * pstScreen->lCharHeight);
  pstScreen->rclDisp.xRight = (pstScreen->lWidth + stCell.cx);
  stColTrack.ptlMaxTrackSize.x = (stCell.cx * (stRead.lCharWidth + stWrite.lCharWidth - 6));

  WinSetWindowPos(pstScreen->hwnd,
                 0L,
                 pstScreen->rcl.xLeft,
                 pstScreen->rcl.yBottom,
                (pstScreen->rcl.xRight - pstScreen->rcl.xLeft),
                (pstScreen->rcl.yTop - pstScreen->rcl.yBottom),
                (SWP_MOVE | SWP_SIZE));

  if ((rc = DosReleaseMutexSem(hmtxColGioBlockedSem)) != NO_ERROR)
    {
    sprintf(szMessage,"DosReleaseMutexSem error in ColumnSize: return code = %ld", rc);
    ErrorNotify(szMessage);
    }
  if (bResetScrollBar)
    SetupColScrolling(pstScreen);
  WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
  }

void CreateSignalWindow(SIGNAL *pstSignal)
  {
  LONG flCreateFlags;

  flCreateFlags = (FCF_NOBYTEALIGN);

  pstSignal->hwnd = WinCreateStdWindow(hwndClient,
                                    0L,
//                                   (WS_CLIPSIBLINGS | WS_PARENTCLIP | WS_SAVEBITS),
                                   &flCreateFlags,
                                   "SIG DISPLAY",
                                    NULL,
//                                    0L,
                                   (WS_CLIPSIBLINGS | WS_PARENTCLIP | WS_SAVEBITS),
                           (HMODULE)NULL,
                                    IDM_COMSCOPE,
                            (PHWND)&pstSignal.hwndClient);

  }


