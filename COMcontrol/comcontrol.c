#include "COMMON.H"
#include "COMDD.H"
#include "utility.h"
#include "ioctl.h"
#include "help.h"

#include "ComControl.h"
//#include "CTL_DLG.H"
#include "resource.H"



extern ULONG const aulStdBaudTable[];
extern ULONG const aul4xBaudTable[];
extern ULONG const aul12xBaudTable[];

VOID FillHdwProtocolDlg(HWND hwnd,LINECHAR *pstLineChar);
VOID UnloadHdwProtocolDlg(HWND hwnd,LINECHAR *pstLineChar);
BOOL TCHdwProtocolDlg(HWND hwnd,USHORT idButton);

VOID FillHandshakeDlg(HWND hwnd,DCB *pstComDCB,FIFOINF *pstFIFOinfo);
VOID UnloadHandshakeDlg(HWND hwnd,DCB *pstComDCB,FIFOINF *pstFIFOinfo);
BOOL TCHandshakeDlg(HWND hwnd,USHORT idButton,DCB *pstComDCB,FIFOINF *pstFIFOinfo);

VOID FillHdwTimeoutDlg(HWND hwnd,DCB *pstComDCB);
VOID UnloadHdwTimeoutDlg(HWND hwnd,DCB *pstComDCB);
BOOL TCHdwTimeoutDlg(HWND hwnd,USHORT idButton);

VOID FillHdwFilterDlg(HWND hwnd,DCB *pstComDCB);
VOID UnloadHdwFilterDlg(HWND hwnd,DCB *pstComDCB);

BOOL FillHdwFIFOsetupDlg(HWND hwnd,BYTE byFlags,FIFOINF *pstFIFOinfo);
BOOL UnloadHdwFIFOsetupDlg(HWND hwnd,DCB *pstComDCB,FIFOINF *pstFIFOinfo);
BOOL TCHdwFIFOsetupDlg(HWND hwnd,USHORT idButton,FIFOINF *pstFIFOinfo);

#define UM_INITLS 10000

HMODULE hThisModule;

#ifdef __BORLANDC__
ULONG _dllmain(ULONG ulTermCode,HMODULE hMod)
#else
ULONG _System _DLL_InitTerm(HMODULE hMod,ULONG ulTermCode)
#endif
  {
  if (ulTermCode == 0)
    hThisModule = hMod;
  return(TRUE);
  }

VOID DisplayHelpPanel(COMCTL *pstComCtl)
  {
  if (pstComCtl->hwndHelpInstance != 0)
    {
    if (WinSendMsg(pstComCtl->hwndHelpInstance,HM_DISPLAY_HELP,
                   MPFROM2SHORT(pstComCtl->usHelpId,NULL),
                   MPFROMSHORT(HM_RESOURCEID)))
      MessageBox(HWND_DESKTOP,"Unable to display External Help Panel");
    }
  else
    MessageBox(HWND_DESKTOP,"External Help is not Initialized");
  }

MRESULT EXPENTRY fnwpHdwFilterDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static DCB stComDCB;
  static COMCTL *pstComCtl;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwnd);
//      WinSetFocus(HWND_DESKTOP,hwnd);
      pstComCtl = PVOIDFROMMP(mp2);
      if (pstComCtl->pszPortName != NULL)
        WinSetWindowText(hwnd,pstComCtl->pszPortName);
      if (GetDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB))
        {
        WinDismissDlg(hwnd,FALSE);
        return(FALSE);
        }
      FillHdwFilterDlg(hwnd,&stComDCB);
      break;
    case WM_CONTROL:
      if(SHORT2FROMMP(mp1) == BN_CLICKED)
        {
        switch(SHORT1FROMMP(mp1))
          {
          case HWR_ENABERR:
            if (!Checked(hwnd,HWR_ENABERR))
              {
              ControlEnable(hwnd,HWR_ERRTTT,FALSE);
              ControlEnable(hwnd,HWR_ERRTT,FALSE);
              ControlEnable(hwnd,HWR_ERRT,FALSE);
              ControlEnable(hwnd,HWR_ERRCHAR,FALSE);
              }
            else
              {
              ControlEnable(hwnd,HWR_ERRTTT,TRUE);
              ControlEnable(hwnd,HWR_ERRTT,TRUE);
              ControlEnable(hwnd,HWR_ERRT,TRUE);
              ControlEnable(hwnd,HWR_ERRCHAR,TRUE);
              }
            break;
          case HWR_ENABBRK:
            if (!Checked(hwnd,HWR_ENABBRK))
              {
              ControlEnable(hwnd,HWR_BRKTTT,FALSE);
              ControlEnable(hwnd,HWR_BRKTT,FALSE);
              ControlEnable(hwnd,HWR_BRKT,FALSE);
              ControlEnable(hwnd,HWR_BRKCHAR,FALSE);
              }
            else
              {
              ControlEnable(hwnd,HWR_BRKTTT,TRUE);
              ControlEnable(hwnd,HWR_BRKTT,TRUE);
              ControlEnable(hwnd,HWR_BRKT,TRUE);
              ControlEnable(hwnd,HWR_BRKCHAR,TRUE);
              }
            break;
          default:
           return(FALSE);
          }
        }
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          UnloadHdwFilterDlg(hwnd,&stComDCB);
          SendDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB);
          WinDismissDlg(hwnd,TRUE);
          break;
        case DID_CANCEL:
          WinDismissDlg(hwnd,FALSE);
          break;
        case DID_HELP:
          DisplayHelpPanel(pstComCtl);
          break;
        default:
          return WinDefDlgProc(hwnd,msg,mp1,mp2);
        }
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return FALSE;
  }

/*
** dialog to set read/write timeouts
*/
MRESULT EXPENTRY fnwpHdwTimeoutDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static DCB stComDCB;
  static bAllowClick;
  static COMCTL *pstComCtl;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwnd);
//      WinSetFocus(HWND_DESKTOP,hwnd);
      bAllowClick = FALSE;
      pstComCtl = PVOIDFROMMP(mp2);
      if (GetDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB))
        {
        WinDismissDlg(hwnd,FALSE);
        return(FALSE);
        }
      if (pstComCtl->pszPortName != NULL)
        WinSetWindowText(hwnd,pstComCtl->pszPortName);
      WinPostMsg(hwnd,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      break;
    case UM_INITLS:
      FillHdwTimeoutDlg(hwnd,&stComDCB);
      bAllowClick = TRUE;
      break;
    case WM_CONTROL:
      if (SHORT2FROMMP(mp1) == BN_CLICKED)
        if (bAllowClick)
          if (!TCHdwTimeoutDlg(hwnd,SHORT1FROMMP(mp1)))
            return(FALSE);
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          UnloadHdwTimeoutDlg(hwnd,&stComDCB);
          SendDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB);
          WinDismissDlg(hwnd,TRUE);
          break;
        case DID_CANCEL:
          WinDismissDlg(hwnd,FALSE);
          break;
        case DID_HELP:
          DisplayHelpPanel(pstComCtl);
          break;
        default:
          return WinDefDlgProc(hwnd,msg,mp1,mp2);
        }
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return FALSE;
  }

/*
**  Dialog to set handshaking modes
*/
MRESULT EXPENTRY fnwpHandshakeDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static DCB stComDCB;
  static bAllowClick;
  static COMCTL *pstComCtl;
  static FIFOINF stFIFOinfo;
  FIFODEF stFIFOcontrol;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwnd);
//      WinSetFocus(HWND_DESKTOP,hwnd);
      bAllowClick = FALSE;
      pstComCtl = PVOIDFROMMP(mp2);
      if (GetDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB))
        return(FALSE);
      if (GetFIFOinfo(pstComCtl->pstIOctl,pstComCtl->hCom,&stFIFOinfo) != NO_ERROR)
        {
        stFIFOinfo.wFIFOsize = 16;
        stFIFOinfo.wTxFIFOload = 16;
        stFIFOinfo.wFIFOflags = 0;
        }
      if (pstComCtl->pszPortName != NULL)
        WinSetWindowText(hwnd,pstComCtl->pszPortName);
      WinPostMsg(hwnd,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      break;
    case UM_INITLS:
      FillHandshakeDlg(hwnd,&stComDCB,&stFIFOinfo);
      bAllowClick = TRUE;
      break;
    case WM_CONTROL:
      if (SHORT2FROMMP(mp1) == BN_CLICKED)
        {
        if (bAllowClick)
          if (!TCHandshakeDlg(hwnd,SHORT1FROMMP(mp1),&stComDCB,&stFIFOinfo))
            return(FALSE);
        }
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          UnloadHandshakeDlg(hwnd,&stComDCB,&stFIFOinfo);
          stFIFOcontrol.wFIFOflags = stFIFOinfo.wFIFOflags;
          stFIFOcontrol.wFIFOflags |= FIFO_FLG_NO_DCB_UPDATE;
          stFIFOcontrol.wTxFIFOload = stFIFOinfo.wTxFIFOload;
          SetFIFO(pstComCtl->pstIOctl,pstComCtl->hCom,&stFIFOcontrol);
          SendDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB);
          WinDismissDlg(hwnd,TRUE);
          break;
        case DID_CANCEL:
          WinDismissDlg(hwnd,FALSE);
          break;
        case DID_HELP:
          DisplayHelpPanel(pstComCtl);
          break;
        default:
          return WinDefDlgProc(hwnd,msg,mp1,mp2);
        }
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return(FALSE);
  }

/*
**  Dialog to set line characteristics
*/
MRESULT EXPENTRY fnwpHdwProtocolDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static LINECHAR stLineChar;
  static COMCTL *pstComCtl;
  static bAllowClick;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwnd);
//      WinSetFocus(HWND_DESKTOP,hwnd);
      bAllowClick = FALSE;
      pstComCtl = PVOIDFROMMP(mp2);
      if (GetLineCharacteristics(pstComCtl->pstIOctl,pstComCtl->hCom,&stLineChar))
        {
        WinDismissDlg(hwnd,FALSE);
        return(FALSE);
        }
      if (pstComCtl->pszPortName != NULL)
        WinSetWindowText(hwnd,pstComCtl->pszPortName);
      WinPostMsg(hwnd,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      break;
    case UM_INITLS:
      FillHdwProtocolDlg(hwnd,&stLineChar);
      bAllowClick = TRUE;
      break;
    case WM_CONTROL:
      switch (SHORT2FROMMP(mp1))
        {
        case BN_CLICKED:
          if (bAllowClick)
            if (!TCHdwProtocolDlg(hwnd,SHORT1FROMMP(mp1)))
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
          UnloadHdwProtocolDlg(hwnd,&stLineChar);
          SetLineCharacteristics(pstComCtl->pstIOctl,pstComCtl->hCom,&stLineChar);
          WinDismissDlg(hwnd,TRUE);
          break;
        case DID_CANCEL:
          WinDismissDlg(hwnd,FALSE);
          break;
        case DID_HELP:
          DisplayHelpPanel(pstComCtl);
          return((MRESULT)TRUE);
        default:
          return WinDefDlgProc(hwnd,msg,mp1,mp2);
        }
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return(FALSE);
  }

MRESULT EXPENTRY fnwpHdwBaudRateDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  LONG lBaud;
  char szBaud[12];
  int iIndex;
  int iCurrentBaudIndex;
  BYTE byTemp;
  static bAllowClick;
  static COMCTL *pstComCtl;
  ULONG *pulBaudTable;
  LONG lMaxBaud;
  BAUDST stBaudRates;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwnd);
//      WinSetFocus(HWND_DESKTOP,hwnd);
      bAllowClick = FALSE;
      pstComCtl = PVOIDFROMMP(mp2);
      if (GetBaudRates(pstComCtl->pstIOctl,pstComCtl->hCom,&stBaudRates))
        {
        WinDismissDlg(hwnd,FALSE);
        return(FALSE);
        }
      if (pstComCtl->pszPortName != NULL)
        WinSetWindowText(hwnd,pstComCtl->pszPortName);
      lBaud = stBaudRates.stCurrentBaud.lBaudRate;
      lMaxBaud = stBaudRates.stHighestBaud.lBaudRate;
      if (lMaxBaud > 469800)
        pulBaudTable = (ULONG *)aul12xBaudTable;
      else
        if (lMaxBaud > 115200)
          pulBaudTable = (ULONG *)aul4xBaudTable;
        else
          pulBaudTable = (ULONG *)aulStdBaudTable;
      if (lBaud == 0)
        lBaud = DEF_BAUD;
      WinSendDlgItemMsg(hwnd,HWB_BAUD,EM_SETTEXTLIMIT,MPFROMSHORT(6),(MPARAM)NULL);
      iCurrentBaudIndex = -1;
      iIndex = 0;
      while (pulBaudTable[iIndex] != 0)
        {
        ltoa(pulBaudTable[iIndex],szBaud,10);
        WinSendDlgItemMsg(hwnd,HWB_BAUD,LM_INSERTITEM,MPFROM2SHORT(LIT_END,0),MPFROMP(szBaud));
        if (pulBaudTable[iIndex] == lBaud)
          iCurrentBaudIndex = iIndex;
        iIndex++;
        }
      if (iCurrentBaudIndex >= 0)
        WinSendDlgItemMsg(hwnd,HWB_BAUD,LM_SELECTITEM,MPFROMSHORT((SHORT)iCurrentBaudIndex),(MPARAM)TRUE);
      ltoa(lBaud,szBaud,10);
      WinSetDlgItemText(hwnd,HWB_BAUD,szBaud);
      WinPostMsg(hwnd,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      break;
    case UM_INITLS:
      bAllowClick = TRUE;
      break;
    case WM_CONTROL:
      if (SHORT2FROMMP(mp1) == BN_CLICKED)
        if (bAllowClick)
          if (!TCHdwProtocolDlg(hwnd,SHORT1FROMMP(mp1)))
            return(FALSE);
      break;
    case WM_COMMAND:
      switch( SHORT1FROMMP( mp1 ) )
        {
        case DID_OK:
          WinQueryDlgItemText(hwnd,HWB_BAUD,sizeof(szBaud),szBaud);
          SetBaudRate(pstComCtl->pstIOctl,pstComCtl->hCom,atol(szBaud));
          WinDismissDlg(hwnd,TRUE);
          break;
        case DID_CANCEL:
          WinDismissDlg(hwnd,FALSE);
          break;
        case DID_HELP:
          DisplayHelpPanel(pstComCtl);
          return((MRESULT)TRUE);
        default:
          return WinDefDlgProc(hwnd,msg,mp1,mp2);
        }
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return(FALSE);
  }

/*
**  Dialog to set 16650, 16654, and 16750 FIFO modes
*/
MRESULT EXPENTRY fnwpHdwFIFOsetupDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static DCB stComDCB;
  static bAllowClick;
  static COMCTL *pstComCtl;
  static FIFOINF *pstFIFOinfo;
  FIFODEF stFIFOcontrol;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwnd);
      bAllowClick = FALSE;
//      WinSetFocus(HWND_DESKTOP,hwnd);
      pstComCtl = PVOIDFROMMP(mp2);
      pstFIFOinfo = pstComCtl->pVoidPtrOne;
      if (GetDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB))
        return(FALSE);
      if (pstComCtl->pszPortName != NULL)
        WinSetWindowText(hwnd,pstComCtl->pszPortName);
      FillHdwFIFOsetupDlg(hwnd,stComDCB.Flags3,pstFIFOinfo);
      WinPostMsg(hwnd,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      break;
    case UM_INITLS:
      bAllowClick = TRUE;
      break;
    case WM_CONTROL:
      switch (SHORT2FROMMP(mp1))
        {
        case BN_CLICKED:
          if (bAllowClick)
            if (!TCHdwFIFOsetupDlg(hwnd,SHORT1FROMMP(mp1),pstFIFOinfo))
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
          UnloadHdwFIFOsetupDlg(hwnd,&stComDCB,pstFIFOinfo);
          stFIFOcontrol.wFIFOflags = pstFIFOinfo->wFIFOflags;
          stFIFOcontrol.wFIFOflags |= FIFO_FLG_NO_DCB_UPDATE;
          stFIFOcontrol.wTxFIFOload = pstFIFOinfo->wTxFIFOload;
          SetFIFO(pstComCtl->pstIOctl,pstComCtl->hCom,&stFIFOcontrol);
          SendDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB);
          WinDismissDlg(hwnd,TRUE);
          break;
        case DID_CANCEL:
          WinDismissDlg(hwnd,FALSE);
          break;
        case DID_HELP:
          if (pstFIFOinfo->wFIFOflags & FIFO_FLG_TYPE_16750)
            pstComCtl->usHelpId = HLPP_16750_FIFO_DLG;
          else
            if (pstFIFOinfo->wFIFOflags & FIFO_FLG_TYPE_16650)
              pstComCtl->usHelpId = HLPP_16650_FIFO_DLG;
            else
              if (pstFIFOinfo->wFIFOflags & FIFO_FLG_TYPE_16654)
                pstComCtl->usHelpId = HLPP_16654_FIFO_DLG;
              else
                pstComCtl->usHelpId = HLPP_16550_FIFO_DLG;
          DisplayHelpPanel(pstComCtl);
          break;
        default:
          return WinDefDlgProc(hwnd,msg,mp1,mp2);
        }
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return(FALSE);
  }

APIRET EXPENTRY HdwFIFOsetupDialog(HWND hwnd,COMCTL *pstComCtl)
  {
  int iDlgID;
  FIFOINF stFIFOinfo;

  if (GetFIFOinfo(pstComCtl->pstIOctl,pstComCtl->hCom,&stFIFOinfo) != NO_ERROR)
    {
    stFIFOinfo.wFIFOsize = 16;
    stFIFOinfo.wTxFIFOload = 16;
    stFIFOinfo.wFIFOflags = 0;
    iDlgID = HWF_16550_DLG;
    }
  else
    if (stFIFOinfo.wFIFOflags & FIFO_FLG_TYPE_16750)
      iDlgID = HWF_16750_DLG;
    else
      if (stFIFOinfo.wFIFOflags & FIFO_FLG_TYPE_16650)
        iDlgID = HWF_16650_DLG;
      else
        if (stFIFOinfo.wFIFOflags & FIFO_FLG_TYPE_16654)
          iDlgID = HWF_16654_DLG;
        else
          iDlgID = HWF_16550_DLG;

  pstComCtl->pVoidPtrOne = &stFIFOinfo;
  return(WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpHdwFIFOsetupDlg,hThisModule,iDlgID,MPFROMP(pstComCtl)));
  }

APIRET EXPENTRY HdwFilterDialog(HWND hwnd,COMCTL *pstComCtl)
  {
  return(WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpHdwFilterDlg,hThisModule,HWR_DLG,MPFROMP(pstComCtl)));
  }

APIRET EXPENTRY HdwHandshakeDialog(HWND hwnd,COMCTL *pstComCtl)
  {
  return(WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpHandshakeDlg,hThisModule,HS_ALL_DLG,MPFROMP(pstComCtl)));
  }

APIRET EXPENTRY HdwTimeoutDialog(HWND hwnd,COMCTL *pstComCtl)
  {
  return(WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpHdwTimeoutDlg,hThisModule,HWT_DLG,MPFROMP(pstComCtl)));
  }

APIRET EXPENTRY HdwProtocolDialog(HWND hwnd,COMCTL *pstComCtl)
  {
  return(WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpHdwProtocolDlg,hThisModule,HWP_DLG,MPFROMP(pstComCtl)));
  }

APIRET EXPENTRY HdwBaudRateDialog(HWND hwnd,COMCTL *pstComCtl)
  {
  return (WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpHdwBaudRateDlg,hThisModule,HWB_DLG,MPFROMP(pstComCtl)));
  }


