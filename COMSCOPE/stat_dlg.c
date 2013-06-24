#include "COMscope.h"

char szOn[] = "On";
char szOff[] = "Off";

BOOL ResetHighWater(void);
MRESULT EXPENTRY fnwpCOMeventStatesDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpCOMstatusStatesDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpXmitStatusStatesDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpCOMerrorStatesDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);

//void FillUpdateStatusDlg(HWND hwnd);
//void FillDeviceStatusDlg(HWND hwnd);
//void FillModemInputStatusDlg(HWND hwnd);
//void FillModemOutputStatusDlg(HWND hwnd);
//void FillRcvBufferStatusDlg(HWND hwnd);
//void FillXmitBufferStatusDlg(HWND hwnd);

void UpdateBufferStatusDlg(HWND hwnd);
void UpdateDeviceStatusDlg(HWND hwnd);
void UpdateModemInputStatusDlg(HWND hwnd);
void UpdateModemOutputStatusDlg(HWND hwnd);
void UpdateRcvBufferStatusDlg(HWND hwnd);
void UpdateXmitBufferStatusDlg(HWND hwnd);

//void UnloadUpdateStatusDlg(HWND hwnd);

//extern VOID SetSystemMenu(HWND hwnd);
//extern VOID CenterDlgBox(HWND hwnd);

extern IOCTLINST stIOctl;

extern HWND hwndFrame;
extern HWND hwndClient;
extern habAnchorBlock;
//extern BOOL bViewingData;
extern ULONG ulCOMscopeBufferSize;
extern BOOL bCOMscopeEnabled;
extern CSCFG stCFG;
extern HPROF hProfileInstance;

extern HFILE hCom;

extern BOOL bDDstatusActivated;
extern BOOL bMIstatusActivated;
extern BOOL bMOstatusActivated;
extern BOOL bRBstatusActivated;
extern BOOL bTBstatusActivated;

LONG lStatusWindowCount = 0;

VOID SetSystemMenu(HWND hwnd)
  {
  HWND     hwndSysMenu;                 /* sys menu pull-down handle */
  MENUITEM miTemp;                      /* menu item template        */
  MRESULT  mresItemId;                  /* system menu item ID       */
  SHORT    sItemIndex;                  /* system menu item index    */

  /*******************************************************************/
  /* Get the handle of the system menu pull-down.                    */
  /*******************************************************************/
  if ((hwndSysMenu = WinWindowFromID(hwnd,FID_SYSMENU)) != 0)
    {
    if (WinSendMsg( hwndSysMenu,
                   MM_QUERYITEM,
                   MPFROM2SHORT( SC_SYSMENU, FALSE ),
                   MPFROMP( (PSZ)&miTemp )))
      {
      hwndSysMenu = miTemp.hwndSubMenu;

      /*******************************************************************/
      /* Remove all items from the system menu pull-down that are no     */
      /* longer wanted.                                                  */
      /*******************************************************************/
      for (sItemIndex = 0,mresItemId = 0L;LONGFROMMP(mresItemId) != (LONG)MIT_ERROR;sItemIndex++)
        {
        mresItemId = WinSendMsg(hwndSysMenu,
                                MM_ITEMIDFROMPOSITION,
                                MPFROMSHORT(sItemIndex),
                                NULL);
        if (LONGFROMMP(mresItemId) != (LONG)MIT_ERROR &&
            SHORT1FROMMP(mresItemId) != SC_MOVE   &&
            SHORT1FROMMP(mresItemId) != SC_CLOSE  &&
            SHORT1FROMMP(mresItemId) != SC_TASKMANAGER)
          {
          WinSendMsg(hwndSysMenu,
                     MM_DELETEITEM,
                     MPFROM2SHORT(SHORT1FROMMP(mresItemId),FALSE),
                     NULL);
          sItemIndex--;
          }
        }
      }
    }
  }

/*
**  Modeless Dialog to place device status on screen
*/
MRESULT EXPENTRY fnwpDeviceAllStatusDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  char szCount[10];
  static ULONG idTimer;
  WORD wTemp;
  static BOOL bShowAllActivated;

  switch (msg)
    {
    case WM_INITDLG:
//      SetSystemMenu(hwnd);
//      CenterDlgBox(hwnd);
      bShowAllActivated = FALSE;
      idTimer = 0L;
      break;
    case UM_INITLS:
      if (!bShowAllActivated)
        {
        bShowAllActivated = TRUE;
//        MousePosDlgBox(hwnd);
        WinSetWindowText(hwnd,stCFG.szPortName);
        sprintf(szCount,"%u",stCFG.wUpdateDelay);
        WinSetDlgItemText(hwnd,HWS_UPDATE,szCount);
        WinShowWindow(hwnd,TRUE);
        WinSetFocus(HWND_DESKTOP,hwnd);
        }
      UpdateDeviceStatusDlg(hwnd);
      UpdateModemInputStatusDlg(hwnd);
      UpdateModemOutputStatusDlg(hwnd);
      UpdateBufferStatusDlg(hwnd);
      idTimer = WinStartTimer(habAnchorBlock,
                              hwnd,
                              TID_STATALL,
                              stCFG.wUpdateDelay);
      break;
    case WM_CLOSE:
    case UM_KILL_MONITOR:
      if (idTimer != 0)
        {
        WinStopTimer(habAnchorBlock,
                     hwnd,
                     idTimer);
        idTimer = 0L;
        WinDismissDlg(hwnd,TRUE);
        }
      bShowAllActivated = FALSE;
      break;
    case UM_RESETTIMER:
      if (idTimer != 0L)
        idTimer = WinStartTimer(habAnchorBlock,
                              hwnd,
                              idTimer,
                              stCFG.wUpdateDelay);
      break;
    case WM_TIMER:
      UpdateDeviceStatusDlg(hwnd);
      UpdateModemInputStatusDlg(hwnd);
      UpdateModemOutputStatusDlg(hwnd);
      UpdateBufferStatusDlg(hwnd);
      return(FALSE);
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_UPDATE:
          WinQueryDlgItemText(hwnd,HWS_UPDATE,sizeof(szCount),szCount);
          wTemp = atol(szCount);
          if (wTemp != stCFG.wUpdateDelay)
            {
            stCFG.wUpdateDelay = wTemp;
            WinStartTimer(habAnchorBlock,
                          hwnd,
                          idTimer,
                          stCFG.wUpdateDelay);
            }
          break;
        case DID_OK:
          WinStopTimer(habAnchorBlock,
                       hwnd,
                       idTimer);
          idTimer = 0L;
          WinDismissDlg(hwnd,TRUE);
          bShowAllActivated = FALSE;
          break;
        case DID_HELP:
          DisplayHelpPanel(HLPP_SHOW_ALL_DLG);
          break;
        default:
          return WinDefDlgProc(hwnd,msg,mp1,mp2);
        }
      return(FALSE);
    default:      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return FALSE;
  }

MRESULT EXPENTRY fnwpXmitStatusStatesDlg(HWND hwnd,USHORT msg,
                                         MPARAM mp1,MPARAM mp2)
  {
  BYTE *pwEvent;

  switch (msg)
    {
    case WM_INITDLG:
      WinSetFocus(HWND_DESKTOP,hwnd);
      pwEvent = PVOIDFROMMP(mp2);
      if (*pwEvent & 0x0001)
        CheckButton(hwnd,TST_BIT0,TRUE);
      if (*pwEvent & 0x0002)
        CheckButton(hwnd,TST_BIT1,TRUE);
      if (*pwEvent & 0x0004)
        CheckButton(hwnd,TST_BIT2,TRUE);
      if (*pwEvent & 0x0008)
        CheckButton(hwnd,TST_BIT3,TRUE);
      if (*pwEvent & 0x0010)
        CheckButton(hwnd,TST_BIT4,TRUE);
      if (*pwEvent & 0x0020)
        CheckButton(hwnd,TST_BIT5,TRUE);
      break;
//    case WM_BUTTON1DOWN:
//      WinDismissDlg(hwnd,TRUE);
//      return(FALSE);
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_HELP:
          DisplayHelpPanel(HLPP_XMIT_STATUS_BITS);
          return((MRESULT)FALSE);
        case DID_OK:
        case DID_CANCEL:
          break;
        default:
          return WinDefDlgProc(hwnd,msg,mp1,mp2);
        }
      WinDismissDlg(hwnd,TRUE);
      return((MRESULT)TRUE);
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return FALSE;
  }

MRESULT EXPENTRY fnwpCOMstatusStatesDlg(HWND hwnd,USHORT msg,
                                         MPARAM mp1,MPARAM mp2)
  {
  WORD *pwEvent;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwnd);
      WinSetFocus(HWND_DESKTOP,hwnd);
      pwEvent = PVOIDFROMMP(mp2);
      if (*pwEvent & 0x0001)
        CheckButton(hwnd,CST_BIT0,TRUE);
      if (*pwEvent & 0x0002)
        CheckButton(hwnd,CST_BIT1,TRUE);
      if (*pwEvent & 0x0004)
        CheckButton(hwnd,CST_BIT2,TRUE);
      if (*pwEvent & 0x0008)
        CheckButton(hwnd,CST_BIT3,TRUE);
      if (*pwEvent & 0x0010)
        CheckButton(hwnd,CST_BIT4,TRUE);
      if (*pwEvent & 0x0020)
        CheckButton(hwnd,CST_BIT5,TRUE);
      if (*pwEvent & 0x0040)
        CheckButton(hwnd,CST_BIT6,TRUE);
      if (*pwEvent & 0x0080)
        CheckButton(hwnd,CST_BIT7,TRUE);
      break;
//    case WM_BUTTON1DOWN:
//      WinDismissDlg(hwnd,TRUE);
//      return(FALSE);
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_HELP:
          DisplayHelpPanel(HLPP_COM_STATUS_BITS);
          return((MRESULT)FALSE);
        case DID_OK:
        case DID_CANCEL:
          break;
        default:
          return WinDefDlgProc(hwnd,msg,mp1,mp2);
        }
      WinDismissDlg(hwnd,TRUE);
      return((MRESULT)TRUE);
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return FALSE;
  }

MRESULT EXPENTRY fnwpCOMeventStatesDlg(HWND hwnd,USHORT msg,
                                         MPARAM mp1,MPARAM mp2)
  {
  WORD *pwEvent;
  WORD wEvent;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwnd);
      WinSetFocus(HWND_DESKTOP,hwnd);
      pwEvent = PVOIDFROMMP(mp2);
      if (*pwEvent & 0x0001)
        CheckButton(hwnd,CEV_BIT0,TRUE);
      if (*pwEvent & 0x0002)
        CheckButton(hwnd,CEV_BIT1,TRUE);
      if (*pwEvent & 0x0004)
        CheckButton(hwnd,CEV_BIT2,TRUE);
      if (*pwEvent & 0x0008)
        CheckButton(hwnd,CEV_BIT3,TRUE);
      if (*pwEvent & 0x0010)
        CheckButton(hwnd,CEV_BIT4,TRUE);
      if (*pwEvent & 0x0020)
        CheckButton(hwnd,CEV_BIT5,TRUE);
      if (*pwEvent & 0x0040)
        CheckButton(hwnd,CEV_BIT6,TRUE);
      if (*pwEvent & 0x0080)
        CheckButton(hwnd,CEV_BIT7,TRUE);
      if (*pwEvent & 0x0100)
        CheckButton(hwnd,CEV_BIT8,TRUE);
      break;
//    case WM_BUTTON1DOWN:
//      WinDismissDlg(hwnd,TRUE);
//      return(FALSE);
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_HELP:
          DisplayHelpPanel(HLPP_COM_EVENT_BITS);
          return((MRESULT)FALSE);
        case DID_CLEAR:
          if (GetCOMevent(&stIOctl,hCom,&wEvent) != NO_ERROR)
            {
            WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
            WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
            }
        case DID_OK:
        case DID_CANCEL:
          break;
        default:
          return WinDefDlgProc(hwnd,msg,mp1,mp2);
        }
      WinDismissDlg(hwnd,TRUE);
      return((MRESULT)TRUE);
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return FALSE;
  }

MRESULT EXPENTRY fnwpCOMerrorStatesDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  WORD *pwError;
  WORD wError;

  switch (msg)
    {
    case WM_INITDLG:
      WinSetFocus(HWND_DESKTOP,hwnd);
      pwError = PVOIDFROMMP(mp2);
      if (*pwError & 0x0001)
        CheckButton(hwnd,CER_BIT0,TRUE);
      if (*pwError & 0x0002)
        CheckButton(hwnd,CER_BIT1,TRUE);
      if (*pwError & 0x0004)
        CheckButton(hwnd,CER_BIT2,TRUE);
      if (*pwError & 0x0008)
        CheckButton(hwnd,CER_BIT3,TRUE);
      break;
//    case WM_BUTTON1DOWN:
//      WinDismissDlg(hwnd,TRUE);
//      return(FALSE);
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_HELP:
          DisplayHelpPanel(HLPP_COM_ERROR_BITS);
          return((MRESULT)FALSE);
        case DID_CLEAR:
          if (GetCOMerror(&stIOctl,hCom,&wError) != NO_ERROR)
            {
            WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
            WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
            }
        case DID_OK:
        case DID_CANCEL:
          break;
        default:
          return WinDefDlgProc(hwnd,msg,mp1,mp2);
        }
      WinDismissDlg(hwnd,TRUE);
      return((MRESULT)TRUE);
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return FALSE;
  }

MRESULT EXPENTRY fnwpDeviceStatusDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  USHORT idDlg;
  PFNWP  pfnDlgProc;
  static ULONG idTimer;
  char szStatus[80];
  WORD wStatus;
  static BOOL bShowingBits;
  static SHORT sCurrentFocus;

  switch (msg)
    {
    case WM_INITDLG:
      SetSystemMenu(hwnd);
      WinSendDlgItemMsg(hwnd,HWS_COMST,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
      WinSendDlgItemMsg(hwnd,HWS_COMERROR,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
      WinSendDlgItemMsg(hwnd,HWS_COMEVENT,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
      WinSendDlgItemMsg(hwnd,HWS_XMITST,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
      idTimer = 0L;
      bShowingBits = FALSE;
      sCurrentFocus = 0;
      CenterDlgBox(hwnd);
      break;
    case UM_INITLS:
      if (!bDDstatusActivated)
        {
        bDDstatusActivated = TRUE;
        if (lStatusWindowCount++ <= 0)
          MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,TRUE);
        if (stCFG.bLoadWindowPosition && (hProfileInstance != NULL) && (stCFG.ptlDDstatusPos.y > -40))
          WinSetWindowPos(hwnd,HWND_TOP,stCFG.ptlDDstatusPos.x,stCFG.ptlDDstatusPos.y,0L,0L,SWP_MOVE);
        else
          MousePosDlgBox(hwnd);
        WinShowWindow(hwnd,TRUE);
        WinSetFocus(HWND_DESKTOP,hwnd);
        }
      UpdateDeviceStatusDlg(hwnd);
      idTimer = WinStartTimer(habAnchorBlock,
                              hwnd,
                              TID_STATDEV,
                              stCFG.wUpdateDelay);
    case UM_RESET_NAME:
      sprintf(szStatus,"%s - Device Driver Status",stCFG.szPortName);
      WinSetWindowText(hwnd,szStatus);
      break;
    case WM_CLOSE:
    case UM_KILL_MONITOR:
      bDDstatusActivated = FALSE;
      if (--lStatusWindowCount <= 0)
        MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,FALSE);
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
                              stCFG.wUpdateDelay);
      break;
    case WM_CHAR:
      if ((sCurrentFocus != 0) && (!bShowingBits) && (SHORT1FROMMP(mp1) & KC_CHAR) && (SHORT1FROMMP(mp2) == ' '))
        {
        WinPostMsg(hwnd,UM_SHOWBITS,MPFROMSHORT(sCurrentFocus),(MPARAM)0L);
        bShowingBits = TRUE;
        }
      else
        return(WinDefDlgProc(hwnd,msg,mp1,mp2));
      break;
    case WM_BUTTON1UP:
      if ((sCurrentFocus != 0) && (!bShowingBits))
        {
        WinPostMsg(hwnd,UM_SHOWBITS,MPFROMSHORT(sCurrentFocus),(MPARAM)0L);
        bShowingBits = TRUE;
        }
      else
        return(WinDefDlgProc(hwnd,msg,mp1,mp2));
      break;
    case WM_CONTROL:
      if (!bShowingBits)
        {
        switch (SHORT2FROMMP(mp1))
          {
          case EN_SETFOCUS:
            sCurrentFocus = SHORT1FROMMP(mp1);
            break;
          case EN_KILLFOCUS:
            sCurrentFocus = 0;
            break;
          }
        }
      break;
    case UM_SHOWBITS:
        switch(SHORT1FROMMP(mp1))
          {
          case HWS_COMERROR:
            idDlg      = CER_DLG;
            pfnDlgProc = (PFNWP)fnwpCOMerrorStatesDlg;
            WinQueryDlgItemText(hwnd,HWS_COMERROR,sizeof(szStatus),szStatus);
            break;
          case HWS_COMEVENT:
            idDlg      = CEV_DLG;
            pfnDlgProc = (PFNWP)fnwpCOMeventStatesDlg;
            WinQueryDlgItemText(hwnd,HWS_COMEVENT,sizeof(szStatus),szStatus);
            break;
          case HWS_COMST:
            idDlg      = CST_DLG;
            pfnDlgProc = (PFNWP)fnwpCOMstatusStatesDlg;
            WinQueryDlgItemText(hwnd,HWS_COMST,sizeof(szStatus),szStatus);
            break;
          case HWS_XMITST:
            idDlg      = TST_DLG;
            pfnDlgProc = (PFNWP)fnwpXmitStatusStatesDlg;
            WinQueryDlgItemText(hwnd,HWS_XMITST,sizeof(szStatus),szStatus);
            break;
          default:
            return(FALSE);
          }
        wStatus = (WORD)ASCIItoBin(szStatus,16);
        WinDlgBox(HWND_DESKTOP,
                  hwnd,
                  pfnDlgProc,
                  NULLHANDLE,
                  idDlg,
                  &wStatus);
        WinSetFocus(HWND_DESKTOP,hwnd);
        bShowingBits = FALSE;
      break;
    case WM_TIMER:
      UpdateDeviceStatusDlg(hwnd);
      break;
    case WM_ACTIVATE:
      if (bDDstatusActivated)
        WinSetFocus(HWND_DESKTOP,hwnd);
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return FALSE;
  }

MRESULT EXPENTRY fnwpUpdateStatusDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  char szCount[10];

  switch (msg)
    {
    case WM_INITDLG:
      WinSendDlgItemMsg(hwnd,HWS_UPDATE,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
      sprintf(szCount,"%u",stCFG.wUpdateDelay);
      WinSetDlgItemText(hwnd,HWS_UPDATE,szCount);
//      CenterDlgBox(hwnd);
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          WinQueryDlgItemText(hwnd,HWS_UPDATE,sizeof(szCount),szCount);
          stCFG.wUpdateDelay = atol(szCount);
          WinPostMsg(hwndStatus,UM_RESETTIMER,(MPARAM)(0L),(MPARAM)0L);
          WinPostMsg(hwndStatDev,UM_RESETTIMER,(MPARAM)(0L),(MPARAM)0L);
          WinPostMsg(hwndStatAll,UM_RESETTIMER,(MPARAM)(0L),(MPARAM)0L);
          WinPostMsg(hwndStatRcvBuf,UM_RESETTIMER,(MPARAM)(0L),(MPARAM)0L);
          WinPostMsg(hwndStatXmitBuf,UM_RESETTIMER,(MPARAM)(0L),(MPARAM)0L);
          WinPostMsg(hwndStatModemIn,UM_RESETTIMER,(MPARAM)(0L),(MPARAM)0L);
          WinPostMsg(hwndStatModemOut,UM_RESETTIMER,(MPARAM)(0L),(MPARAM)0L);
          break;
        case DID_CANCEL:
          break;
        case DID_HELP:
          DisplayHelpPanel(HLPP_UPDATE_FREQ_DLG);
          return((MRESULT)FALSE);
        default:
          return WinDefDlgProc(hwnd,msg,mp1,mp2);
        }
      WinDismissDlg(hwnd,TRUE);
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return FALSE;
  }

MRESULT EXPENTRY fnwpXmitBufferStatusDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static ULONG idTimer;
  char szCaption[80];

  switch (msg)
    {
    case WM_INITDLG:
      SetSystemMenu(hwnd);
      WinSendDlgItemMsg(hwnd,HWS_BUFLEV,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
      WinSendDlgItemMsg(hwnd,HWS_BUFLEN,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
      idTimer = 0L;
//      CenterDlgBox(hwnd);
      break;
    case UM_INITLS:
      if (!bTBstatusActivated)
        {
        bTBstatusActivated = TRUE;
        if (lStatusWindowCount++ <= 0)
          MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,TRUE);
        if (stCFG.bLoadWindowPosition && (hProfileInstance != NULL) && (stCFG.ptlMIstatusPos.y > -40))
          WinSetWindowPos(hwnd,HWND_TOP,stCFG.ptlTBstatusPos.x,stCFG.ptlTBstatusPos.y,0L,0L,SWP_MOVE);
        else
          MousePosDlgBox(hwnd);
        WinShowWindow(hwnd,TRUE);
        WinSetFocus(HWND_DESKTOP,hwnd);
        }
      UpdateXmitBufferStatusDlg(hwnd);
      idTimer = WinStartTimer(habAnchorBlock,
                              hwnd,
                              TID_STATXMITBUF,
                              stCFG.wUpdateDelay);
    case UM_RESET_NAME:
      sprintf(szCaption,"%s - Transmit Buffer",stCFG.szPortName);
      WinSetWindowText(hwnd,szCaption);
      break;
    case WM_CLOSE:
    case UM_KILL_MONITOR:
      bTBstatusActivated = FALSE;
      if (--lStatusWindowCount <= 0)
        MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,FALSE);
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
                                stCFG.wUpdateDelay);
      break;
    case WM_TIMER:
      UpdateXmitBufferStatusDlg(hwnd);
      return(FALSE);
    case WM_ACTIVATE:
      if (bTBstatusActivated)
        WinSetFocus(HWND_DESKTOP,hwnd);
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return FALSE;
  }

MRESULT EXPENTRY fnwpRcvBufferStatusDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static ULONG idTimer;
  char szCaption[80];
  static SHORT sCurrentFocus;

  switch (msg)
    {
    case WM_INITDLG:
      SetSystemMenu(hwnd);
      WinSendDlgItemMsg(hwnd,HWS_BUFLEV,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
      WinSendDlgItemMsg(hwnd,HWS_BUFLEN,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
//      CenterDlgBox(hwnd);
      idTimer = 0L;
      break;
    case UM_INITLS:
      if (!bRBstatusActivated)
        {
        bRBstatusActivated = TRUE;
        if (lStatusWindowCount++ <= 0)
          MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,TRUE);
        if (stCFG.bLoadWindowPosition && (hProfileInstance != NULL) && (stCFG.ptlRBstatusPos.y > -40))
          WinSetWindowPos(hwnd,HWND_TOP,stCFG.ptlRBstatusPos.x,stCFG.ptlRBstatusPos.y,0L,0L,SWP_MOVE);
        else
          MousePosDlgBox(hwnd);
        WinShowWindow(hwnd,TRUE);
        WinSetFocus(HWND_DESKTOP,hwnd);
        stCFG.fTraceEvent |= CSFUNC_TRACE_RX_BUFF_LEVEL;
        if (bCOMscopeEnabled && (hCom != 0xffffffff))
          EnableCOMscope(hwnd,hCom,&ulCOMscopeBufferSize,stCFG.fTraceEvent);
        ResetHighWater();
        }
      UpdateRcvBufferStatusDlg(hwnd);
      idTimer = WinStartTimer(habAnchorBlock,
                              hwnd,
                              TID_STATRCVBUF,
                              stCFG.wUpdateDelay);
      sCurrentFocus = 0;
    case UM_RESET_NAME:
      sprintf(szCaption,"%s - Receive Buffer",stCFG.szPortName);
      WinSetWindowText(hwnd,szCaption);
      break;
    case WM_CLOSE:
    case UM_KILL_MONITOR:
      bRBstatusActivated = FALSE;
      stCFG.fTraceEvent &= ~CSFUNC_TRACE_RX_BUFF_LEVEL;
      if (bCOMscopeEnabled && (hCom != 0xffffffff))
        EnableCOMscope(hwnd,hCom,&ulCOMscopeBufferSize,stCFG.fTraceEvent);
      if (--lStatusWindowCount <= 0)
        MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,FALSE);
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
                              stCFG.wUpdateDelay);
      break;
    case WM_TIMER:
      UpdateRcvBufferStatusDlg(hwnd);
      return(FALSE);
    case WM_CHAR:
      if ((sCurrentFocus != 0) && (SHORT1FROMMP(mp1) & KC_CHAR) && (SHORT1FROMMP(mp2) == ' '))
        ResetHighWater();
      else
        return(WinDefDlgProc(hwnd,msg,mp1,mp2));
      break;
    case WM_BUTTON1UP:
      if (sCurrentFocus != 0)
        ResetHighWater();
      else
        return(WinDefDlgProc(hwnd,msg,mp1,mp2));
      break;
    case WM_CONTROL:
      switch (SHORT2FROMMP(mp1))
        {
        case EN_SETFOCUS:
          if (SHORT1FROMMP(mp1) == HWS_BUFHIGH)
            sCurrentFocus = SHORT1FROMMP(mp1);
          break;
        case EN_KILLFOCUS:
          sCurrentFocus = 0;
          break;
        }
      break;
    case WM_ACTIVATE:
      if (bRBstatusActivated)
        WinSetFocus(HWND_DESKTOP,hwnd);
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return FALSE;
  }

MRESULT EXPENTRY fnwpModemInStatusDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static ULONG idTimer;
  char szCaption[80];

  switch (msg)
    {
    case WM_INITDLG:
      SetSystemMenu(hwnd);
      WinSendDlgItemMsg(hwnd,HWS_DCD,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
      WinSendDlgItemMsg(hwnd,HWS_RING,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
      WinSendDlgItemMsg(hwnd,HWS_DSR,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
      WinSendDlgItemMsg(hwnd,HWS_CTS,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
//      CenterDlgBox(hwnd);
      idTimer = 0L;
      break;
    case UM_INITLS:
      if (!bMIstatusActivated)
        {
        bMIstatusActivated = TRUE;
        if (lStatusWindowCount++ <= 0)
          MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,TRUE);
        if (stCFG.bLoadWindowPosition && (hProfileInstance != NULL) && (stCFG.ptlMIstatusPos.y > -40))
          WinSetWindowPos(hwnd,HWND_TOP,stCFG.ptlMIstatusPos.x,stCFG.ptlMIstatusPos.y,0L,0L,SWP_MOVE);
        else
          MousePosDlgBox(hwnd);
        WinShowWindow(hwnd,TRUE);
        WinSetFocus(HWND_DESKTOP,hwnd);
        }
      UpdateModemInputStatusDlg(hwnd);
      idTimer = WinStartTimer(habAnchorBlock,
                              hwnd,
                              TID_STATMDMIN,
                              stCFG.wUpdateDelay);
    case UM_RESET_NAME:
      sprintf(szCaption,"%s - Modem In",stCFG.szPortName);
      WinSetWindowText(hwnd,szCaption);
      break;
    case WM_CLOSE:
    case UM_KILL_MONITOR:
      if (--lStatusWindowCount <= 0)
        MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,FALSE);
      bMIstatusActivated = FALSE;
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
                              stCFG.wUpdateDelay);
      break;
    case WM_TIMER:
      UpdateModemInputStatusDlg(hwnd);
      return(FALSE);
    case WM_ACTIVATE:
      if (bMIstatusActivated)
        WinSetFocus(HWND_DESKTOP,hwnd);
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return FALSE;
  }

MRESULT EXPENTRY fnwpModemOutStatusDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static ULONG idTimer;
  char szCaption[80];

  switch (msg)
    {
    case WM_INITDLG:
      SetSystemMenu(hwnd);
      WinSendDlgItemMsg(hwnd,HWS_DTR,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
      WinSendDlgItemMsg(hwnd,HWS_RTS,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
//      CenterDlgBox(hwnd);
      idTimer = 0L;
      break;
    case UM_INITLS:
      if (!bMOstatusActivated)
        {
        bMOstatusActivated = TRUE;
        if (lStatusWindowCount++ <= 0)
          MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,TRUE);
        if (stCFG.bLoadWindowPosition && (hProfileInstance != NULL) && (stCFG.ptlMOstatusPos.y > -40))
          WinSetWindowPos(hwnd,HWND_TOP,stCFG.ptlMOstatusPos.x,stCFG.ptlMOstatusPos.y,0L,0L,SWP_MOVE);
        else
          MousePosDlgBox(hwnd);
        WinShowWindow(hwnd,TRUE);
        WinSetFocus(HWND_DESKTOP,hwnd);
        }
      UpdateModemOutputStatusDlg(hwnd);
      idTimer = WinStartTimer(habAnchorBlock,
                              hwnd,
                              TID_STATMDMOUT,
                              stCFG.wUpdateDelay);
    case UM_RESET_NAME:
      sprintf(szCaption,"%s - Modem Out",stCFG.szPortName);
      WinSetWindowText(hwnd,szCaption);
      break;
    case WM_CLOSE:
    case UM_KILL_MONITOR:
      bMOstatusActivated = FALSE;
      if (--lStatusWindowCount <= 0)
        MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,FALSE);
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
                              stCFG.wUpdateDelay);
      break;
    case WM_TIMER:
      UpdateModemOutputStatusDlg(hwnd);
      return(FALSE);
    case WM_ACTIVATE:
      if (bMOstatusActivated)
        WinSetFocus(HWND_DESKTOP,hwnd);
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return FALSE;
  }

void UpdateXmitBufferStatusDlg(HWND hwnd)
  {
  WORD wByteCount;
  WORD wQueueLength;
  ULONG ulTemp;
  char szSize[10];

  if (GetTransmitQueueLen(&stIOctl,hCom,&wQueueLength,&wByteCount) != NO_ERROR)
    {
    WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    }
  else
    {
    ulTemp = (ULONG)wByteCount * 100;
    ulTemp /= (ULONG)wQueueLength;
    ltoa(ulTemp,szSize,10);
    WinSetDlgItemText(hwnd,HWS_BUFLEV,szSize);
    ltoa((LONG)wByteCount,szSize,10);
    WinSetDlgItemText(hwnd,HWS_BUFLEN,szSize);
    }
  }

void UpdateRcvBufferStatusDlg(HWND hwnd)
  {
  BUFCNT stCounts;
  ULONG ulQueueLength;
  ULONG ulTemp;
  char szSize[20];

  if (GetReceiveQueueCounts(&stIOctl,hCom,&stCounts) != NO_ERROR)
    {
    WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    }
  else
    {
    if (stCounts.wQueueLen == 0)
      ulQueueLength = 0x10000;
    else
      ulQueueLength = (ULONG)stCounts.wQueueLen;
    ulTemp = (ULONG)stCounts.wByteCount * 100;
    ulTemp /= ulQueueLength;
    ltoa(ulTemp,szSize,10);
    WinSetDlgItemText(hwnd,HWS_BUFLEV,szSize);
    ltoa((LONG)stCounts.wByteCount,szSize,10);
    WinSetDlgItemText(hwnd,HWS_BUFLEN,szSize);
    ltoa((LONG)stCounts.dwQueueHigh,szSize,10);
    WinSetDlgItemText(hwnd,HWS_BUFHIGH,szSize);
    }
  }

void UpdateBufferStatusDlg(HWND hwnd)
  {
  WORD wByteCount;
  WORD wQueueLength;
  ULONG ulQueueLength;
  ULONG ulTemp;
  char szSize[10];

  if (GetTransmitQueueLen(&stIOctl,hCom,&wQueueLength,&wByteCount) != NO_ERROR)
    {
    WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    }
  else
    {
    ulTemp = (ULONG)wByteCount * 100;
    ulTemp /= (ULONG)wQueueLength;
    ltoa(ulTemp,szSize,10);
    WinSetDlgItemText(hwnd,HWS_XMITBUFLEV,szSize);
    ltoa((LONG)wByteCount,szSize,10);
    WinSetDlgItemText(hwnd,HWS_XMITBUFLEN,szSize);
    }
  if (GetReceiveQueueLen(&stIOctl,hCom,&wQueueLength,&wByteCount) != NO_ERROR)
    {
    WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    }
  else
    {
    if (wQueueLength == 0)
      ulQueueLength = 0x10000;
    else
      ulQueueLength = (ULONG)wQueueLength;
    ulTemp = (ULONG)wByteCount * 100;
    ulTemp /= ulQueueLength;
    ltoa(ulTemp,szSize,10);
    WinSetDlgItemText(hwnd,HWS_RCVBUFLEV,szSize);
    ltoa((LONG)wByteCount,szSize,10);
    WinSetDlgItemText(hwnd,HWS_RCVBUFLEN,szSize);
    }
  }

void UpdateDeviceStatusDlg(HWND hwnd)
  {
  BYTE szStatus[10];
  WORD wEvent;
  WORD wStatus;
  BYTE byStatus;
  APIRET rc;

  if (GetCOMstatus(&stIOctl,hCom,&byStatus) != NO_ERROR)
    {
    WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    }
  else
    {
    sprintf(szStatus,"%02X",byStatus);
    WinSetDlgItemText(hwnd,HWS_COMST,szStatus);
    }

  if ((rc = GetNoClearComEvent_ComError(hCom,&wEvent,&wStatus)) != NO_ERROR)
    {
    if ((rc = GetCOMevent(&stIOctl,hCom,&wEvent)) != NO_ERROR)
      rc = GetCOMerror(&stIOctl,hCom,&wStatus);
    }
  if (rc != NO_ERROR)
    {
    WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    }
  else
    {
    sprintf(szStatus,"%04X",wStatus);
    WinSetDlgItemText(hwnd,HWS_COMERROR,szStatus);

    sprintf(szStatus,"%04X",wEvent);
    WinSetDlgItemText(hwnd,HWS_COMEVENT,szStatus);
    }

  if (GetXmitStatus(&stIOctl,hCom,&byStatus) != NO_ERROR)
    {
    WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    }
  else
    {
    sprintf(szStatus,"%02X",byStatus);
    WinSetDlgItemText(hwnd,HWS_XMITST,szStatus);
    }
  }

void UpdateModemOutputStatusDlg(HWND hwnd)
  {
  char szState[4];
  BYTE byOutputSignals;

  if (GetModemOutputSignals(&stIOctl,hCom,&byOutputSignals) != NO_ERROR)
    {
    WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    }
  else
    {
    if (byOutputSignals & 0x01)
      strcpy(szState,szOn);
    else
      strcpy(szState,szOff);
    WinSetDlgItemText(hwnd,HWS_DTR,szState);

    if (byOutputSignals & 0x02)
      strcpy(szState,szOn);
    else
      strcpy(szState,szOff);
    WinSetDlgItemText(hwnd,HWS_RTS,szState);
    }
  }

void UpdateModemInputStatusDlg(HWND hwnd)
  {
  char szState[4];
  BYTE byInputSignals;

  if (GetModemInputSignals(&stIOctl,hCom,&byInputSignals) != NO_ERROR)
    {
    WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
    }
  else
    {
    if (byInputSignals & 0x80)
      strcpy(szState,szOn);
    else
      strcpy(szState,szOff);
    WinSetDlgItemText(hwnd,HWS_DCD,szState);

    if (byInputSignals & 0x40)
      strcpy(szState,szOn);
    else
      strcpy(szState,szOff);
    WinSetDlgItemText(hwnd,HWS_RING,szState);

    if (byInputSignals & 0x20)
      strcpy(szState,szOn);
    else
      strcpy(szState,szOff);
    WinSetDlgItemText(hwnd,HWS_DSR,szState);

    if (byInputSignals & 0x10)
      strcpy(szState,szOn);
    else
      strcpy(szState,szOff);
    WinSetDlgItemText(hwnd,HWS_CTS,szState);
    }
  }



