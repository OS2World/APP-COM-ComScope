#include "COMscope.h"
#include "utility.h"

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

TRACKINFO stColTrack;

extern LONG lStatusHeight;

SCREEN stRead;
SCREEN stWrite;
extern SCREEN stRow;

LONG lColumnOffset = 0;

extern BOOL bSendNextKeystroke;
extern HMTX hmtxColGioBlockedSem;
extern CHARCELL stCell;
extern HWND hwndFrame;
extern HWND hwndClient;
extern HWND hwndStatus;
extern HWND hwndScroll;
extern BOOL bStopDisplayThread;

extern HAB habAnchorBlock;
extern SWP aswpDisplays[];

extern PFNWP WriteFrameProcess;
extern PFNWP ReadFrameProcess;

extern MRESULT EXPENTRY fnwpDisplaySetupDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);

BOOL TrackChildWindow(HAB hab,HWND hwnd,PRECTL prcl,LONG flMoveFrom);
void ColumnSize(SCREEN *pstScreen,LONG lReadEdge,LONG lWriteEdge,BOOL bTrackSibling);
void ColumnPaint(SCREEN *pstScreen);

extern CSCFG stCFG;

extern FATTRS astFontAttributes[];
extern USHORT *pwScrollBuffer;

extern BOOL bFrameActivated;
extern LONG lScrollCount;

MRESULT EXPENTRY fnwpReadColumnClient(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static HDC hdcPs;
  RECTL   rclRect;
  POINTL ptl;
  LONG lSaveEdge;
  SWP swp;
  HWND hwndMenu;
  static USHORT usMenuStyle;
  static CLRDLG stColor;
  static USHORT usLastPopupItem;

  switch(msg)
    {
    case WM_CHAR:
      if (bSendNextKeystroke)
        if (ProcessKeystroke(&stCFG,mp1,mp2))
          return((MRESULT)TRUE);
      return( WinDefWindowProc(hwnd,msg,mp1,mp2));
    case WM_CREATE:
      hdcPs = WinOpenWindowDC(hwnd);
      usLastPopupItem = IDMPU_SYNC;
      stRead.lBackgrndColor = stCFG.lReadColBackgrndColor;
      stRead.bActive = FALSE;
      stRead.lScrollIndex = 0;
      stRead.hwndScroll = (HWND)NULL;
      stRead.wDirection = CS_READ;
      stColor.cbSize = sizeof(CLRDLG);
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
    case WM_VSCROLL:
      switch(HIUSHORT(mp2))
        {
        case SB_LINEDOWN:
          ColScroll(&stRead,1,FALSE);
          break;
        case SB_LINEUP:
          ColScroll(&stRead,-1,FALSE);
          break;
        case SB_PAGEDOWN:
          ColScroll(&stRead,stRead.lCharHeight,FALSE);
          break;
        case SB_PAGEUP:
          ColScroll(&stRead,-stRead.lCharHeight,FALSE);
          break;
        case SB_SLIDERPOSITION:
          ColScroll(&stRead,LOUSHORT(mp2),TRUE);
          break;
        }
      break;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case IDMPU_ASCII_FONT:
          if (!stCFG.bStickyMenus)
            usLastPopupItem = IDMPU_FONT;
          else
            usLastPopupItem = IDMPU_SYNC;
          if (stCFG.wColReadFont != wASCIIfont)
            {
            stCFG.wColReadFont = wASCIIfont;
            WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
            }
          break;
        case IDMPU_HEX_FONT:
          if (!stCFG.bStickyMenus)
            usLastPopupItem = IDMPU_FONT;
          else
            usLastPopupItem = IDMPU_SYNC;
          if (stCFG.wColReadFont != wHEXfont)
            {
            stCFG.wColReadFont = wHEXfont;
            WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
            }
          break;
        case IDMPU_SYNC:
          usLastPopupItem = IDMPU_SYNC;
          if (bStopDisplayThread)
            stRead.lScrollIndex = stWrite.lScrollIndex;
          else
            stRead.lScrollIndex = 0;
          stRead.lScrollRow = GetColScrollRow(&stRead,0);
          WinSendMsg(stRead.hwndScroll,
                     SBM_SETPOS,
                     MPFROMSHORT(stRead.lScrollRow),
                     MPFROMSHORT(0));
          if (stRead.bSync)
            {
            stRow.lScrollIndex = stRead.lScrollIndex;
            stRow.lScrollRow = GetRowScrollRow(&stRow);
            }
          WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
          break;
         case IDMPU_COLORS:
          if (!stCFG.bStickyMenus)
            usLastPopupItem = IDMPU_COLORS;
          else
            usLastPopupItem = IDMPU_SYNC;
          stColor.lForeground = stCFG.lReadColForegrndColor;
          stColor.lBackground = stCFG.lReadColBackgrndColor;
          sprintf(stColor.szCaption,"Lexical Receive Data Display Colors");
          if (WinDlgBox(HWND_DESKTOP,
                        hwnd,
                 (PFNWP)fnwpSetColorDlg,
                (USHORT)NULL,
                        CLR_DLG,
                MPFROMP(&stColor)))
            {
            stCFG.lReadColForegrndColor = stColor.lForeground;
            stCFG.lReadColBackgrndColor = stColor.lBackground;
            stRead.lBackgrndColor = stColor.lBackground;
            stRead.lForegrndColor = stColor.lForeground;
            WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
            }
          break;
        case IDMPU_LOCK_WIDTH:
          if (!stCFG.bStickyMenus)
            usLastPopupItem = IDMPU_LOCK_WIDTH;
          else
            usLastPopupItem = IDMPU_SYNC;
          if (stCFG.fLockWidth == LOCK_READ)
            stCFG.fLockWidth = LOCK_NONE;
          else
            {
            stCFG.lLockWidth = ((stRead.lWidth / stCell.cx) + 1);
            stCFG.fLockWidth = LOCK_READ;
            }
          break;
        case IDMPU_DISP_FILTERS:
          if (!stCFG.bStickyMenus)
            usLastPopupItem = IDMPU_DISP_FILTERS;
          else
            usLastPopupItem = IDMPU_SYNC;
          if (WinDlgBox(HWND_DESKTOP,
                        hwnd,
                 (PFNWP)fnwpDisplaySetupDlgProc,
                (USHORT)NULL,
                        DISP_FILTER_DLG,
                MPFROMP(&stRead)))
            {
            stCFG.bReadTestNewLine = stRead.bTestNewLine;
            stCFG.bSkipReadBlankLines = stRead.bSkipBlankLines;
            stCFG.byReadNewLineChar = stRead.byNewLineChar;
            stCFG.bFilterRead = stRead.bFilter;
            stCFG.fFilterReadMask = stRead.fFilterMask;
            stCFG.byReadMask = stRead.byDisplayMask;
            if (stRead.bSync)
              {
              if (!stCFG.bSyncToRead)
                {
                stWrite.bSync = FALSE;
                stCFG.bSyncToWrite = FALSE;
                stCFG.bSyncToRead = TRUE;
                if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
                  {
                  ClearColScrollBar(&stWrite);
                  SetupColScrolling(&stRead);
                  }
                }
              }
            else
              {
              if (stCFG.bSyncToRead)
                {
                stCFG.bSyncToRead = FALSE;
                if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
                  SetupColScrolling(&stWrite);
                }
              }
            WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
            }
          break;
        }
      break;
//    case WM_CHORD:
    case WM_BUTTON2DOWN:
      if(bFrameActivated)
        {
        hwndMenu = WinLoadMenu(stRead.hwnd,(HMODULE)NULL,IDMPU_COL_DISP_POPUP);
        if (mp1 != 0)
          {
          WinQueryPointerPos(HWND_DESKTOP,&ptl);
          if (!stCFG.bStickyMenus)
            usMenuStyle |= PU_MOUSEBUTTON2DOWN;
          else
            usMenuStyle &= ~PU_MOUSEBUTTON2DOWN;
          }
        else
          {
          usMenuStyle &= ~PU_MOUSEBUTTON2DOWN;
          WinQueryWindowPos(hwndFrame,&swp);
          ptl.x = (swp.x + (swp.cx - (swp.cx / 4)));
          ptl.y = (swp.y + (swp.cy / 2));
          }
        if (stCFG.wColReadFont == wASCIIfont)
          PopupMenuItemCheck(hwndMenu,IDMPU_ASCII_FONT,TRUE);
        else
          PopupMenuItemCheck(hwndMenu,IDMPU_HEX_FONT,TRUE);
        if (stCFG.fLockWidth == LOCK_READ)
          PopupMenuItemCheck(hwndMenu,IDMPU_LOCK_WIDTH,TRUE);
        if (!bStopDisplayThread)
          WinSendMsg(hwndMenu,MM_SETITEMTEXT,(MPARAM)IDMPU_SYNC,"~Reset Display");
        WinPopupMenu(HWND_DESKTOP,stRead.hwndClient,hwndMenu,ptl.x,ptl.y,usLastPopupItem,usMenuStyle);
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
      GpiDestroyPS(hdcPs);
      break;
    case UM_SHOWNEW:
      stRead.lScrollIndex = 0;
      stRead.lScrollRow = 0;
      ClearColScrollBar(&stRead);
    case UM_SHOWAGAIN:
      stRead.bActive = TRUE;
      if ((stCFG.fDisplaying & (DISP_DATA | DISP_FILE)) && !stCFG.bSyncToWrite)
        SetupColScrolling(&stRead);
      WinShowWindow(stRead.hwnd,TRUE);
      WinSendMsg(hwnd,UM_TRACKFRAME,0L,0L);
      WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
      WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
      break;
    case UM_HIDEWIN:
      ClearColScrollBar(&stRead);
      stRead.bActive = FALSE;
      WinShowWindow(hwnd,FALSE);
      WinSetWindowPos(stRead.hwnd,HWND_BOTTOM,0L,0L,0L,0L,(SWP_MOVE | SWP_SIZE | SWP_ZORDER));
      break;
    case WM_PAINT:
#ifdef this_junk
      if (!pstCFG->bDisplayingData && (stCFG.bSyncToRead || stCFG.bSyncToWrite))
        ColumnPaint(&stRead,WinPeekMsg(habAnchorBlock,&stQmsg,stWrite.hwndClient,WM_PAINT,WM_PAINT,PM_REMOVE));
      else
#endif
        ColumnPaint(&stRead);
      break;
    case UM_TRACKSIB:
      ColumnSize(&stRead,(LONG)mp1,(LONG)mp2,TRUE);
      break;
    case UM_TRACKFRAME:
      ColumnSize(&stRead,(LONG)mp1,(LONG)mp2,FALSE);
      break;
    case WM_ERASEBACKGROUND:
      return (MRESULT)(TRUE);
    case WM_CLOSE:
      WinPostMsg(hwnd,WM_QUIT,0L,0L);
    default:
      return WinDefWindowProc(hwnd,msg,mp1,mp2);
    }
  return(FALSE);
  }

MRESULT EXPENTRY fnwpWriteColumnClient(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static HDC hdcPs;
  RECTL   rclRect;
  LONG lSaveEdge;
  POINTL ptl;
  HWND hwndMenu;
  SWP swp;
  static CLRDLG stColor;
  static USHORT usLastPopupItem;
  static USHORT usMenuStyle;

  switch(msg)
    {
    case WM_CHAR:
      if (bSendNextKeystroke)
        if (ProcessKeystroke(&stCFG,mp1,mp2))
          return((MRESULT)TRUE);
      return( WinDefWindowProc(hwnd,msg,mp1,mp2));
    case WM_CREATE:
      hdcPs = WinOpenWindowDC(hwnd);
      usLastPopupItem = IDMPU_SYNC;
      stWrite.lBackgrndColor = stCFG.lWriteColBackgrndColor;
      stWrite.bActive = FALSE;
      stWrite.cbSize = sizeof(SCREEN);
      stWrite.lScrollIndex = 0;
      stWrite.hwndScroll = (HWND)NULL;
      stWrite.wDirection = CS_WRITE;
      stColor.cbSize = sizeof(CLRDLG);
      usMenuStyle = (PU_POSITIONONITEM | PU_HCONSTRAIN | PU_MOUSEBUTTON2 | PU_VCONSTRAIN | PU_KEYBOARD | PU_MOUSEBUTTON1);
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
    case WM_VSCROLL:
      switch(HIUSHORT(mp2))
        {
        case SB_LINEDOWN:
          ColScroll(&stWrite,1,FALSE);
          break;
        case SB_LINEUP:
          ColScroll(&stWrite,-1,FALSE);
          break;
        case SB_PAGEDOWN:
          ColScroll(&stWrite,stWrite.lCharHeight,FALSE);
          break;
        case SB_PAGEUP:
          ColScroll(&stWrite,-stWrite.lCharHeight,FALSE);
          break;
        case SB_SLIDERPOSITION:
          ColScroll(&stWrite,LOUSHORT(mp2),TRUE);
          break;
        }
      break;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case IDMPU_ASCII_FONT:
          if (!stCFG.bStickyMenus)
            usLastPopupItem = IDMPU_FONT;
          else
            usLastPopupItem = IDMPU_SYNC;
          if (stCFG.wColWriteFont != wASCIIfont)
            {
            stCFG.wColWriteFont = wASCIIfont;
            WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
            }
          break;
        case IDMPU_HEX_FONT:
          if (!stCFG.bStickyMenus)
            usLastPopupItem = IDMPU_FONT;
          else
            usLastPopupItem = IDMPU_SYNC;
          if (stCFG.wColWriteFont != wHEXfont)
            {
            stCFG.wColWriteFont = wHEXfont;
            WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
            }
          break;
        case IDMPU_SYNC:
          usLastPopupItem = IDMPU_SYNC;
          if (bStopDisplayThread)
            stWrite.lScrollIndex = stRead.lScrollIndex;
          else
            stWrite.lScrollIndex = 0;
          stWrite.lScrollRow = GetColScrollRow(&stWrite,0);
          WinSendMsg(stRead.hwndScroll,
                     SBM_SETPOS,
                     MPFROMSHORT(stWrite.lScrollRow),
                     MPFROMSHORT(0));
          if (stWrite.bSync)
            {
            stRow.lScrollIndex = stWrite.lScrollIndex;
            stRow.lScrollRow = GetRowScrollRow(&stRow);
            }
          WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
          break;
        case IDMPU_COLORS:
          if (!stCFG.bStickyMenus)
            usLastPopupItem = IDMPU_COLORS;
          else
            usLastPopupItem = IDMPU_SYNC;
          stColor.lForeground = stCFG.lWriteColForegrndColor;
          stColor.lBackground = stCFG.lWriteColBackgrndColor;
          sprintf(stColor.szCaption,"Lexical Transmit Data Display Colors");
          if (WinDlgBox(HWND_DESKTOP,
                        hwnd,
                  (PFNWP)fnwpSetColorDlg,
                (USHORT)NULL,
                        CLR_DLG,
                MPFROMP(&stColor)))
            {
            stCFG.lWriteColForegrndColor = stColor.lForeground;
            stCFG.lWriteColBackgrndColor = stColor.lBackground;
            stWrite.lBackgrndColor = stColor.lBackground;
            stWrite.lForegrndColor = stColor.lForeground;
            WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
            }
          break;
        case IDMPU_LOCK_WIDTH:
          if (!stCFG.bStickyMenus)
            usLastPopupItem = IDMPU_LOCK_WIDTH;
          else
            usLastPopupItem = IDMPU_SYNC;
          if (stCFG.fLockWidth == LOCK_WRITE)
            stCFG.fLockWidth = LOCK_NONE;
          else
            {
            stCFG.lLockWidth = ((stWrite.lWidth / stCell.cx) + 1);
            stCFG.fLockWidth = LOCK_WRITE;
            }
          break;
        case IDMPU_DISP_FILTERS:
          if (!stCFG.bStickyMenus)
            usLastPopupItem = IDMPU_DISP_FILTERS;
          else
            usLastPopupItem = IDMPU_SYNC;
          if (WinDlgBox(HWND_DESKTOP,
                        hwnd,
                 (PFNWP)fnwpDisplaySetupDlgProc,
                (USHORT)NULL,
                        DISP_FILTER_DLG,
                MPFROMP(&stWrite)))
            {
            stCFG.bWriteTestNewLine = stWrite.bTestNewLine;
            stCFG.bSkipWriteBlankLines = stWrite.bSkipBlankLines;
            stCFG.byWriteNewLineChar = stWrite.byNewLineChar;
            stCFG.bFilterWrite = stWrite.bFilter;
            stCFG.fFilterWriteMask = stWrite.fFilterMask;
            stCFG.byWriteMask = stWrite.byDisplayMask;
            if (stWrite.bSync)
              {
              if (!stCFG.bSyncToWrite)
                {
                stRead.bSync = FALSE;
                stCFG.bSyncToRead = FALSE;
                stCFG.bSyncToWrite = TRUE;
                if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
                  {
                  ClearColScrollBar(&stRead);
                  SetupColScrolling(&stWrite);
                  }
                }
              }
            else
              {
              if (stCFG.bSyncToWrite)
                {
                stCFG.bSyncToWrite = FALSE;
                if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
                  SetupColScrolling(&stRead);
                }
              }
            WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
            }
          break;
        }
      break;
    case WM_BUTTON2DOWN:
      if(bFrameActivated)
        {
        hwndMenu = WinLoadMenu(stWrite.hwnd,(HMODULE)NULL,IDMPU_COL_DISP_POPUP);
        if (mp1 != 0)
          {
          WinQueryPointerPos(HWND_DESKTOP,&ptl);
          if (!stCFG.bStickyMenus)
            usMenuStyle |= PU_MOUSEBUTTON2DOWN;
          else
            usMenuStyle &= ~PU_MOUSEBUTTON2DOWN;
          }
        else
          {
          usMenuStyle &= ~PU_MOUSEBUTTON2DOWN;
          WinQueryWindowPos(hwndFrame,&swp);
          ptl.x = (swp.x + (swp.cx / 4));
          ptl.y = (swp.y + (swp.cy / 2));
          }
        if (stCFG.wColWriteFont == wASCIIfont)
          PopupMenuItemCheck(hwndMenu,IDMPU_ASCII_FONT,TRUE);
        else
          PopupMenuItemCheck(hwndMenu,IDMPU_HEX_FONT,TRUE);
        if (stCFG.fLockWidth == LOCK_WRITE)
          PopupMenuItemCheck(hwndMenu,IDMPU_LOCK_WIDTH,TRUE);
        if (!bStopDisplayThread)
          WinSendMsg(hwndMenu,MM_SETITEMTEXT,(MPARAM)IDMPU_SYNC,"~Reset Display");
        WinPopupMenu(HWND_DESKTOP,stWrite.hwndClient,hwndMenu,ptl.x,ptl.y,usLastPopupItem,usMenuStyle);
        }
      else
        return WinDefWindowProc(hwnd,msg,mp1,mp2);
      break;
    case WM_BUTTON1DOWN:
      if (bFrameActivated)
        {
        WinCopyRect(habAnchorBlock,&rclRect,&stWrite.rcl);
        lSaveEdge = rclRect.xRight;
        if (TrackChildWindow(habAnchorBlock,hwndClient,&rclRect,TF_RIGHT))
          {
          if (rclRect.xRight != lSaveEdge)
            {
            WinSendMsg(stWrite.hwndClient,UM_TRACKSIB,0L,(MPARAM)rclRect.xRight);
            WinSendMsg(stRead.hwndClient,UM_TRACKSIB,(MPARAM)rclRect.xRight,0L);
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
      GpiDestroyPS(hdcPs);
      break;
    case UM_SHOWNEW:
      stWrite.lScrollIndex = 0;
      stWrite.lScrollRow = 0;
      ClearColScrollBar(&stWrite);
    case UM_SHOWAGAIN:
      stWrite.bActive = TRUE;
      if ((stCFG.fDisplaying & (DISP_DATA | DISP_FILE)) && !stCFG.bSyncToRead)
        SetupColScrolling(&stWrite);
      WinShowWindow(stWrite.hwnd,TRUE);
      WinSendMsg(hwnd,UM_TRACKFRAME,0L,0L);
      WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
      WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
      break;
    case UM_HIDEWIN:
      stWrite.bActive = FALSE;
      ClearColScrollBar(&stWrite);
      WinShowWindow(hwnd,FALSE);
      WinSetWindowPos(stWrite.hwnd,HWND_BOTTOM,0L,0L,0L,0L,(SWP_MOVE | SWP_SIZE | SWP_ZORDER));
      break;
    case WM_PAINT:
#ifdef this_junk
      if (!pstCFG->bDisplayingData && (stCFG.bSyncToRead || stCFG.bSyncToWrite))
        ColumnPaint(&stWrite,WinPeekMsg(habAnchorBlock,&stQmsg,stRead.hwndClient,WM_PAINT,WM_PAINT,PM_REMOVE));
      else
#endif
        ColumnPaint(&stWrite);
      break;
    case UM_TRACKSIB:
      ColumnSize(&stWrite,(LONG)mp1,(LONG)mp2,TRUE);
      break;
    case UM_TRACKFRAME:
      ColumnSize(&stWrite,(LONG)mp1,(LONG)mp2,FALSE);
      break;
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

  WinCopyRect(hab,&stColTrack.rclTrack,prcl);

  WinQueryWindowRect(hwndClient,&stColTrack.rclBoundary);
#ifdef this_junk
          stColTrack.cxBorder = 4;
          stColTrack.cyBorder = 4;
          stColTrack.cxGrid = stCell.cx;
          stColTrack.cyGrid = stCell.cy;
          stColTrack.cxKeyboard = stCell.cx;
          stColTrack.cyKeyboard = stCell.cy;
          stColTrack.ptlMinTrackSize.x = (stCell.cx * 4);
          stColTrack.ptlMinTrackSize.y = (stCell.cy * 3);
  stColTrack.ptlMaxTrackSize.x = (stCell.cx * (stRead.lCharWidth + stWrite.lCharWidth - 4));
  stColTrack.ptlMaxTrackSize.y = (stCell.cy * stRead.lCharHeight);
#endif

  stColTrack.fs = (flMoveFrom | TF_ALLINBOUNDARY | TF_SETPOINTERPOS | TF_GRID);

  if (!WinTrackRect(hwnd,0L,&stColTrack))
    return(FALSE);
  WinCopyRect(hab,prcl,&stColTrack.rclTrack);
  return(TRUE);
  }

void ColumnPaint(SCREEN *pstScreen)
  {
  HPS hps;
  RECTL rclRect;
  WORD wChar;
  BOOL bLastWasNewLine = FALSE;
  WORD wDirection;
  LONG lReadIndex;
  WORD wFilterMask;
  BOOL bTestNewLine;
  WORD wNewLine;
  BOOL bWrap;
  BOOL bSkip;
  WORD wFunc;
  LONG lPacketCount;
  LONG lOldTop;

  DosRequestMutexSem(hmtxColGioBlockedSem,10000);
  WinInvalidateRect(pstScreen->hwndClient,(PRECTL)NULL,FALSE);
  hps = WinBeginPaint(pstScreen->hwndClient,(HPS)NULL,&rclRect);
  if (WinIsWindowShowing(pstScreen->hwndClient))
    {
    rclRect.yBottom = 0;
    rclRect.yTop = (pstScreen->lHeight + stCell.cy);
    rclRect.xLeft = 0;
    rclRect.xRight = (pstScreen->lWidth + stCell.cx);
    WinFillRect(hps,&rclRect,pstScreen->lBackgrndColor);
    if (pstScreen->wDirection == CS_WRITE)
      {
      if ((stRead.lBackgrndColor == stWrite.lBackgrndColor) && (stWrite.hwndScroll == (HWND)NULL))
        {
        rclRect.xRight = stWrite.rcl.xRight;
        rclRect.xLeft = stWrite.rcl.xRight - 1;
        rclRect.yBottom = 0;
        rclRect.yTop = stWrite.rcl.yTop;
        if (stWrite.lBackgrndColor == CLR_WHITE)
          WinFillRect(hps,&rclRect,CLR_BLACK);
        else
          WinFillRect(hps,&rclRect,(stWrite.lBackgrndColor ^ stWrite.lBackgrndColor));
        stWrite.rclDisp.xRight = (stWrite.lWidth + stCell.cx - 1);
        }
      else
        stWrite.rclDisp.xRight = (stWrite.lWidth + stCell.cx);
      }
    if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
      {
      pstScreen->Pos.y = pstScreen->lHeight;
      pstScreen->Pos.x = 0;
      lReadIndex = pstScreen->lScrollIndex;
      pstScreen->rclDisp.xLeft = 0L;
      if (pstScreen->wDirection == CS_READ)
        GpiCreateLogFont(hps,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wColReadFont]);
      else
        GpiCreateLogFont(hps,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wColWriteFont]);
      GpiSetCharSet(hps,2);
      GpiSetColor(hps,pstScreen->lForegrndColor);
      if (pstScreen->bFilter)
        wFilterMask = (WORD)pstScreen->byDisplayMask;
      else
        wFilterMask = 0x00ff;
      wNewLine = (WORD)pstScreen->byNewLineChar;
      wDirection = pstScreen->wDirection;
      bTestNewLine = pstScreen->bTestNewLine;
      bSkip = pstScreen->bSkipBlankLines;
      bWrap = pstScreen->bWrap;
      lPacketCount = 0;
      while (lReadIndex < lScrollCount)
        {
        if (lPacketCount == 0)
          {
          wChar = pwScrollBuffer[lReadIndex];
          wFunc = (pwScrollBuffer[lReadIndex++] & 0x0ff00);
          switch (wFunc)
            {
            case CS_PACKET_DATA:
              lPacketCount = (wChar & 0x00ff);
              break;
            case CS_WRITE_IMM:
              if (wFunc != CS_READ)
                wFunc = CS_WRITE;
            case CS_READ_IMM:
              if (wFunc != CS_WRITE)
                wFunc = CS_READ;
            case CS_WRITE:
            case CS_READ:
              if (wFunc != wDirection)
                continue;
              wChar &= wFilterMask;
              if (bTestNewLine && (wChar == wNewLine))
                {
                if (bSkip && bLastWasNewLine)
                  continue;
                if (CharPrintable((BYTE *)&wChar,pstScreen))
                  if (bWrap || (pstScreen->Pos.x <= pstScreen->lWidth))
                    GpiCharStringAt(hps,&pstScreen->Pos,1,(BYTE *)&wChar);
                if (pstScreen->Pos.y <= 0)
                  break;
                pstScreen->Pos.y -= stCell.cy;
                bLastWasNewLine = TRUE;
                pstScreen->Pos.x = 0L;
                }
              else
                {
                if (CharPrintable((BYTE *)&wChar,pstScreen))
                  {
                  bLastWasNewLine = FALSE;
                  if (pstScreen->Pos.x <= pstScreen->lWidth)
                    {
                    GpiCharStringAt(hps,&pstScreen->Pos,1,(BYTE *)&wChar);
                    pstScreen->Pos.x += stCell.cx;
                    }
                  else
                    {
                    if (pstScreen->bWrap)
                      {
                      pstScreen->Pos.x  = 0;
                      pstScreen->Pos.y -= stCell.cy;
                      GpiCharStringAt(hps,&pstScreen->Pos,1,(BYTE *)&wChar);
                      pstScreen->Pos.x += stCell.cx;
                      }
                    if (pstScreen->Pos.y < 0 )
                      break;
                    }
                  }
                }
            }
          }
        else
          {
          lPacketCount--;
          lReadIndex++;
          }
        }
      }
    else
      {
//      pstScreen->lLeadRow = pstScreen->lHeight;
      pstScreen->Pos.y = pstScreen->lHeight;
      pstScreen->Pos.x = 0L;
      }
    }
  WinEndPaint(hps);
  DosReleaseMutexSem(hmtxColGioBlockedSem);
//  WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
  }
/**************************************************************************/
void ColumnSize(SCREEN *pstScreen,LONG lReadEdge,LONG lWriteEdge,BOOL bTrackSibling)
  {
  APIRET rc;
  char szMessage[80];
  RECTL rclClient;
  BOOL bOddScreen;
  BOOL bResetScrollBar = FALSE;

  if (pstScreen->hwndScroll != (HWND)NULL)
    {
    ClearColScrollBar(pstScreen);
    bResetScrollBar = TRUE;
    }
  if ((rc = DosRequestMutexSem(hmtxColGioBlockedSem,10000)) != NO_ERROR)
    {
    sprintf(szMessage,"DosRequestMutexSem error in ColumnSize: return code = %ld", rc);
    ErrorNotify(szMessage);
    }

  if (bTrackSibling)
    {
    if (lReadEdge != 0L)
      pstScreen->rcl.xLeft = lReadEdge;
    else
      if (lWriteEdge != 0L)
        pstScreen->rcl.xRight = lWriteEdge;
    }
  else
    {
    WinQueryWindowRect(hwndClient,&rclClient);

    if (stCFG.fLockWidth == LOCK_NONE)
      {
      if ((rclClient.xRight / 2) % stCell.cx)
        bOddScreen = TRUE;
      else
        bOddScreen = FALSE;

      if (pstScreen->wDirection == CS_WRITE)
        {
        if (bOddScreen)
          rclClient.xRight -= stCell.cx;
        pstScreen->rcl.xRight = (rclClient.xRight / 2);
        pstScreen->rcl.xLeft = rclClient.xLeft;
        }
      else
        {
        pstScreen->rcl.xRight = rclClient.xRight;
        pstScreen->rcl.xLeft = (rclClient.xRight / 2);
        if (bOddScreen)
          pstScreen->rcl.xLeft -= (stCell.cx / 2);
        }
      }
    else
      {
      if (pstScreen->wDirection == CS_WRITE)
        if (stCFG.fLockWidth == LOCK_WRITE)
          pstScreen->rcl.xRight = (stCFG.lLockWidth * stCell.cx);
        else
          pstScreen->rcl.xRight = (rclClient.xRight - (stCFG.lLockWidth * stCell.cx));
      else
        {
        if (stCFG.fLockWidth == LOCK_WRITE)
          pstScreen->rcl.xLeft = (stCFG.lLockWidth * stCell.cx);
        else
          pstScreen->rcl.xLeft = (rclClient.xRight - (stCFG.lLockWidth * stCell.cx));
        pstScreen->rcl.xRight = rclClient.xRight;
        }
      }
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

void CreateColumnWindows(void)
  {
  ULONG flCreateFlags;

  flCreateFlags = (FCF_NOBYTEALIGN);

  stWrite.hwnd = WinCreateStdWindow(hwndClient,
                                    0L,
//                                   (WS_CLIPSIBLINGS | WS_PARENTCLIP | WS_SAVEBITS),
                                   &flCreateFlags,
                                   "WRITE COLUMN",
                                    NULL,
//                                    0L,
                                   (WS_CLIPSIBLINGS | WS_PARENTCLIP | WS_SAVEBITS),
                           (HMODULE)NULL,
                                    IDM_COMSCOPE,
                           (HWND *)&stWrite.hwndClient);

  stRead.hwnd = WinCreateStdWindow(hwndClient,
                                   0L,
//                                  (WS_CLIPSIBLINGS | WS_PARENTCLIP | WS_SAVEBITS),
                                  &flCreateFlags,
                                  "READ COLUMN",
                                   NULL,
//                                   0L,
                                  (WS_CLIPSIBLINGS | WS_PARENTCLIP | WS_SAVEBITS),
                          (HMODULE)NULL,
                                   IDM_COMSCOPE,
                          (HWND *)&stRead.hwndClient);

  }

BOOL CharPrintable(BYTE *pbyChar,SCREEN *pstScreen)
  {
  if (!pstScreen->bFilter)
    return(TRUE);
  *pbyChar &= pstScreen->byDisplayMask;
  switch (pstScreen->fFilterMask)
    {
    case FILTER_NPRINT:
      if (!isprint(*pbyChar))
        return(FALSE);
      break;
    case FILTER_ALPHA:
      if (isalpha(*pbyChar))
        return(FALSE);
      break;
    case (FILTER_ALPHA | FILTER_NPRINT):
      if (!isprint(*pbyChar) || isalpha(*pbyChar))
        return(FALSE);
      break;
    case FILTER_NUMS:
      if (isdigit(*pbyChar))
        return(FALSE);
      break;
    case (FILTER_NUMS | FILTER_NPRINT):
      if (!isprint(*pbyChar) || isdigit(*pbyChar))
        return(FALSE);
      break;
    case (FILTER_NUMS | FILTER_ALPHA):
      if (isdigit(*pbyChar) || isalpha(*pbyChar))
        return(FALSE);
      break;
    case (FILTER_NUMS | FILTER_ALPHA | FILTER_NPRINT):
      if (!isprint(*pbyChar) || isdigit(*pbyChar) || isalpha(*pbyChar))
        return(FALSE);
      break;
    case FILTER_PUNCT:
      if (ispunct(*pbyChar))
        return(FALSE);
      break;
    case (FILTER_PUNCT | FILTER_NPRINT):
      if (!isprint(*pbyChar) || ispunct(*pbyChar))
        return(FALSE);
      break;
    case (FILTER_PUNCT | FILTER_ALPHA):
      if (ispunct(*pbyChar) || isalpha(*pbyChar))
        return(FALSE);
      break;
    case (FILTER_PUNCT | FILTER_ALPHA | FILTER_NPRINT):
      if (!isprint(*pbyChar) || isalpha(*pbyChar) || ispunct(*pbyChar))
        return(FALSE);
      break;
    case (FILTER_PUNCT | FILTER_NUMS):
      if (ispunct(*pbyChar) || isdigit(*pbyChar))
        return(FALSE);
      break;
    case (FILTER_PUNCT | FILTER_NUMS | FILTER_NPRINT):
      if (!isprint(*pbyChar) || ispunct(*pbyChar) || isdigit(*pbyChar))
        return(FALSE);
      break;
    case (FILTER_PUNCT | FILTER_NUMS | FILTER_ALPHA):
      if (ispunct(*pbyChar) || isalpha(*pbyChar) || isdigit(*pbyChar))
        return(FALSE);
      break;
    case (FILTER_NPRINT | FILTER_ALPHA | FILTER_PUNCT | FILTER_NUMS):
      if (!isprint(*pbyChar) || ispunct(*pbyChar) || isalpha(*pbyChar) || isdigit(*pbyChar))
        return(FALSE);
      break;
    }
  return(TRUE);
  }


