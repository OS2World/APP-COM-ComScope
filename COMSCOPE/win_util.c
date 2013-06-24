#include "COMscope.h"

extern BOOL bRemoteServer;

extern CSCFG stCFG;
extern HWND hwndFrame;
extern HWND hwndClient;
extern HAB habAnchorBlock;
extern CHARCELL stCell;
extern LONG lLastHeight;
extern LONG lLastWidth;
extern LONG lYScr;
extern LONG lXScr;
extern LONG lcyTitleBar;
extern BOOL bMaximized;
extern BOOL bMinimized;
extern SWP swpLastPosition;

BOOL bDDstatusActivated = FALSE;
BOOL bMIstatusActivated = FALSE;
BOOL bMOstatusActivated = FALSE;
BOOL bRBstatusActivated = FALSE;
BOOL bTBstatusActivated = FALSE;

VOID PopupMenuItemCheck(HWND hwnd,WORD idItem,BOOL bCheck)
  {
  WinSendMsg(hwnd,
             MM_SETITEMATTR,
             MPFROM2SHORT(idItem,TRUE),
             MPFROM2SHORT(MIA_CHECKED, bCheck ? MIA_CHECKED : ~MIA_CHECKED));
  }

VOID MousePosDlgBox(HWND hwnd)
  {
  POINTL ptlMouse;
  SWP swp;

  WinQueryPointerPos(HWND_DESKTOP,&ptlMouse);
  WinQueryWindowPos(hwnd,&swp);

  // adjust position to bo over title bar
  ptlMouse.x -= (swp.cx / 2);
  ptlMouse.y -= (swp.cy - (lcyTitleBar / 2));
  WinSetWindowPos(hwnd,0L,ptlMouse.x,ptlMouse.y,0L,0L,SWP_MOVE);
  }

void SaveWindowPositions(void)
  {
  SWP swp;

  if (stCFG.bLoadWindowPosition)
    {
    if (bMinimized || bMaximized)
      memcpy(&swp,&swpLastPosition,sizeof(SWP));
    else
      WinQueryWindowPos(hwndFrame,&swp);
    stCFG.ptlFramePos.x = swp.x;
    stCFG.ptlFramePos.y = swp.y;
    stCFG.ptlFrameSize.x = swp.cx;
    stCFG.ptlFrameSize.y = swp.cy;
    if (bDDstatusActivated)
      {
      stCFG.bDDstatusActivated = TRUE;
      WinQueryWindowPos(hwndStatDev,&swp);
      stCFG.ptlDDstatusPos.x = swp.x;
      stCFG.ptlDDstatusPos.y = swp.y;
      }
    else
      stCFG.bDDstatusActivated = FALSE;
    if (bMIstatusActivated)
      {
      stCFG.bMIstatusActivated = TRUE;
      WinQueryWindowPos(hwndStatModemIn,&swp);
      stCFG.ptlMIstatusPos.x = swp.x;
      stCFG.ptlMIstatusPos.y = swp.y;
      }
    else
      stCFG.bMIstatusActivated = FALSE;
    if (bMOstatusActivated)
      {
      stCFG.bMOstatusActivated = TRUE;
      WinQueryWindowPos(hwndStatModemOut,&swp);
      stCFG.ptlMOstatusPos.x = swp.x;
      stCFG.ptlMOstatusPos.y = swp.y;
      }
    else
      stCFG.bMOstatusActivated = FALSE;
    if (bRBstatusActivated)
      {
      stCFG.bRBstatusActivated = TRUE;
      WinQueryWindowPos(hwndStatRcvBuf,&swp);
      stCFG.ptlRBstatusPos.x = swp.x;
      stCFG.ptlRBstatusPos.y = swp.y;
      }
    else
      stCFG.bRBstatusActivated = FALSE;
    if (bTBstatusActivated)
      {
      stCFG.bTBstatusActivated = TRUE;
      WinQueryWindowPos(hwndStatXmitBuf,&swp);
      stCFG.ptlTBstatusPos.x = swp.x;
      stCFG.ptlTBstatusPos.y = swp.y;
      }
    else
      stCFG.bTBstatusActivated = FALSE;
    }
  }


