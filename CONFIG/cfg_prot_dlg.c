#include "COMMON.H"
#include "COMDD.H"
#include "ioctl.h"
#include "utility.h"

#include "COMi_CFG.h"
#include "resource.h"

extern ULONG const aulCfgExtBaudTable[];

extern HWND hwndNoteBookDlg;
extern BOOL bInsertNewDevice;

static char const szBuffSizeFormat[] = "Receive buffer size is %u bytes";

void UnloadASCIIhandshakeDlg(HWND hwndDlg,COMDCB *pstComDCB);
void TCASCIIhandshakeDlg(HWND hwndDlg,USHORT usButtonId);
void FillASCIIhandshakingDlg(HWND hwndDlg,COMDCB *pstComDCB);

void UnloadHDWhandshakDlg(HWND hwndDlg,COMDCB *pstComDCB);
void FillHDWhandshakDlg(HWND hwndDlg,COMDCB *pstComDCB);

BOOL TCCfgProtocolDlg(HWND hwndDlg,USHORT idButton);
VOID UnloadCfgProtocolDlg(HWND hwndDlg,BYTE *pbyLineChar);
VOID FillCfgProtocolDlg(HWND hwndDlg,BYTE byLineChar);

BOOL TCCfgTimeoutDlg(HWND hwndDlg,USHORT idButton);
void UnloadCfgTimeoutDlg(HWND hwndDlg,COMDCB *pstComDCB);
HWND FillCfgTimeoutDlg(HWND hwndDlg,COMDCB *pstComDCB);

VOID EXPENTRY UnloadCfgFilterDlg(HWND hwndDlg,COMDCB *pstComDCB);
VOID FillCfgFilterDlg(HWND hwndDlg,COMDCB *pstComDCB);
void TCCfgFilterDlg(HWND hwndDlg,USHORT usButtonId);

extern LONG lOrgXonHysteresis;
extern LONG lOrgXoffThreshold;
LONG lXonHysteresis;
LONG lXoffThreshold;
ULONG ulReadBufLen;

extern HMODULE hThisModule;

MRESULT EXPENTRY fnwpCfgFilterDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static bAllowClick;
  static NBKPAGECTL *pstPage;
  static COMDCB *pstComDCB;

  switch (msg)
    {
    case WM_INITDLG:
      if (!bInsertNewDevice)
        WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
//        ControlEnable(hwndDlg,DID_INSERT,FALSE);
//      CenterDlgBox(hwndDlg);
      bAllowClick = FALSE;
      pstPage = PVOIDFROMMP(mp2);
      pstPage->bDirtyBit = FALSE;
      pstComDCB = pstPage->pVoidPtrOne;
      FillCfgFilterDlg(hwndDlg,pstComDCB);
      if (pstPage->bSpoolerConfig)
        WinSetDlgItemText(hwndDlg,ST_TITLE,"Port stream filter configuration");
      WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      break;
    case UM_INITLS:
      bAllowClick = TRUE;
      break;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_INSERT:
           WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
           break;
        case DID_CANCEL:
          WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
          return(FALSE);
        case DID_HELP:
          WinSendMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
          return(FALSE);
        case DID_UNDO:
          pstPage->bDirtyBit = FALSE;
          bAllowClick = FALSE;
          FillCfgFilterDlg(hwndDlg,pstComDCB);
          bAllowClick = TRUE;
          return(FALSE);
        }
      break;
    case WM_CONTROL:
      if(SHORT2FROMMP(mp1) == BN_CLICKED)
        {
        if (bAllowClick)
          {
          pstPage->bDirtyBit = TRUE;
          TCCfgFilterDlg(hwndDlg,SHORT1FROMMP(mp1));
          }
        }
      break;
    case UM_SAVE_DATA:
      UnloadCfgFilterDlg(hwndDlg,pstComDCB);
      return((MRESULT)TRUE);
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return(FALSE);
  }

/*
** dialog to set read/write timeouts
*/
MRESULT EXPENTRY fnwpCfgTimeoutDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static NBKPAGECTL *pstPage;
  static COMDCB *pstComDCB;
  static COMDCB stComDCB;
  static bAllowClick;

  switch (msg)
    {
    case WM_INITDLG:
      if (!bInsertNewDevice)
        WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
//        ControlEnable(hwndDlg,DID_INSERT,FALSE);
      bAllowClick = FALSE;
      pstPage = PVOIDFROMMP(mp2);
      pstPage->bDirtyBit = FALSE;
      pstComDCB = pstPage->pVoidPtrOne;
      memcpy(&stComDCB,pstComDCB,sizeof(COMDCB));
      FillCfgTimeoutDlg(hwndDlg,&stComDCB);      // required for potential TOP pages only (so far)
      if (pstPage->bSpoolerConfig)
        WinSetDlgItemText(hwndDlg,ST_TITLE,"Port timeout configuration");
      WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      break;
    case UM_INITLS:
      bAllowClick = TRUE;
      break;
    case UM_SET_FOCUS:
      WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
      break;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_INSERT:
           WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
           break;
        case DID_CANCEL:
          WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
          return(FALSE);
        case DID_HELP:
          WinSendMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
          return(FALSE);
        case DID_UNDO:
          bAllowClick = FALSE;
          pstPage->bDirtyBit = FALSE;
          FillCfgTimeoutDlg(hwndDlg,&stComDCB);
          bAllowClick = TRUE;
          return(FALSE);
        }
      break;
    case WM_CONTROL:
      if (bAllowClick)
        {
        switch (SHORT2FROMMP(mp1))
          {
          case BN_CLICKED:
              {
              pstPage->bDirtyBit = TRUE;
              TCCfgTimeoutDlg(hwndDlg,SHORT1FROMMP(mp1));
              }
            break;
          case EN_CHANGE:
            pstPage->bDirtyBit = TRUE;
            break;
          }
        }
      break;
    case UM_SAVE_DATA:
      UnloadCfgTimeoutDlg(hwndDlg,pstComDCB);
      return((MRESULT)TRUE);
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return(FALSE);
  }

MRESULT EXPENTRY fnwpCfgProtocolDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static bAllowClick;
  static NBKPAGECTL *pstPage;
  static BYTE *pbyLineChar;

  switch (msg)
    {
    case WM_INITDLG:
      if (!bInsertNewDevice)
        WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
//        ControlEnable(hwndDlg,DID_INSERT,FALSE);
      bAllowClick = FALSE;
      pstPage = PVOIDFROMMP(mp2);
      pstPage->bDirtyBit = FALSE;
      pbyLineChar = pstPage->pVoidPtrOne;
      FillCfgProtocolDlg(hwndDlg,*pbyLineChar);
      if (pstPage->bSpoolerConfig)
        WinSetDlgItemText(hwndDlg,ST_TITLE,"Port line characteristics configuration");
      WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      break;
    case UM_INITLS:
      bAllowClick = TRUE;
      break;
    case UM_SET_FOCUS:
      WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
      break;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_INSERT:
           WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
           break;
        case DID_CANCEL:
          WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
          return(FALSE);
        case DID_HELP:
          WinSendMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
          return(FALSE);
        case DID_UNDO:
          bAllowClick = FALSE;
          pstPage->bDirtyBit = FALSE;
          FillCfgProtocolDlg(hwndDlg,*pbyLineChar);
          bAllowClick = TRUE;
          return(FALSE);
        }
      break;
    case WM_CONTROL:
      if (SHORT2FROMMP(mp1) == BN_CLICKED)
        {
        if (bAllowClick)
          {
          pstPage->bDirtyBit = TRUE;
          TCCfgProtocolDlg(hwndDlg,SHORT1FROMMP(mp1));
          }
        }
      break;
    case UM_SAVE_DATA:
      UnloadCfgProtocolDlg(hwndDlg,pbyLineChar);
      return((MRESULT)TRUE);
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return(FALSE);
  }

MRESULT EXPENTRY fnwpCfgBaudRateDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static bAllowClick;
  static NBKPAGECTL *pstPage;
  LONG lBaud;
  static char szBaud[12];
  int iIndex;
  static int iCurrentBaudIndex;
//  BYTE byTemp;
  static ULONG *pulBaud;
  ULONG ulMaxBaud;
  BOOL bTestMax;

  switch (msg)
    {
    case WM_INITDLG:
      if (!bInsertNewDevice)
        WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
//        ControlEnable(hwndDlg,DID_INSERT,FALSE);
      bAllowClick = FALSE;
      pstPage = PVOIDFROMMP(mp2);
      pstPage->bDirtyBit = FALSE;
      pulBaud = pstPage->pVoidPtrOne;
      lBaud = *pulBaud;
      if (lBaud == 0)
        lBaud = DEF_BAUD;
      WinSendDlgItemMsg(hwndDlg,HWB_BAUD,EM_SETTEXTLIMIT,MPFROMSHORT(6),(MPARAM)NULL);
      iCurrentBaudIndex = -1;
      iIndex = 0;
      if (pstPage->bSpoolerConfig)
        {
        bTestMax = TRUE;
        ulMaxBaud = pstPage->ulSpare;
        }
      else
        bTestMax = FALSE;
      while (aulCfgExtBaudTable[iIndex] != 0)
        {
        ltoa(aulCfgExtBaudTable[iIndex],szBaud,10);
        WinSendDlgItemMsg(hwndDlg,HWB_BAUD,LM_INSERTITEM,MPFROM2SHORT(LIT_END,0),MPFROMP(szBaud));
        if (aulCfgExtBaudTable[iIndex] == lBaud)
          iCurrentBaudIndex = iIndex;
        if (bTestMax)
          if (aulCfgExtBaudTable[iIndex] >= ulMaxBaud)
            break;
        iIndex++;
        }
      if (iCurrentBaudIndex >= 0)
        WinSendDlgItemMsg(hwndDlg,HWB_BAUD,LM_SELECTITEM,MPFROMSHORT((SHORT)iCurrentBaudIndex),(MPARAM)TRUE);
      ltoa(lBaud,szBaud,10);
      WinSetDlgItemText(hwndDlg,HWB_BAUD,szBaud);
      if (pstPage->bSpoolerConfig)
        WinSetDlgItemText(hwndDlg,ST_TITLE,"Port baud rate configuration");
      WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      break;
    case UM_INITLS:
      bAllowClick = TRUE;
      break;
    case UM_SET_FOCUS:
      WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
      break;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_INSERT:
           WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
           break;
        case DID_CANCEL:
          WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
          return(FALSE);
        case DID_HELP:
          WinSendMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
          return(FALSE);
        case DID_UNDO:
          bAllowClick = FALSE;
          pstPage->bDirtyBit = FALSE;
          WinSetDlgItemText(hwndDlg,HWB_BAUD,szBaud);
          if (iCurrentBaudIndex >= 0)
            WinSendDlgItemMsg(hwndDlg,HWB_BAUD,LM_SELECTITEM,MPFROMSHORT((SHORT)iCurrentBaudIndex),(MPARAM)TRUE);
          bAllowClick = TRUE;
          return(FALSE);
        }
      break;
    case WM_CONTROL:
      switch (SHORT2FROMMP(mp1))
        {
        case CBN_EFCHANGE:
        case CBN_LBSELECT:
        case CBN_ENTER:
          if (bAllowClick)
            pstPage->bDirtyBit = TRUE;
          break;
        }
      break;
    case UM_SAVE_DATA:
      WinQueryDlgItemText(hwndDlg,HWB_BAUD,sizeof(szBaud),szBaud);
      *pulBaud = (ULONG)atol(szBaud);
      return((MRESULT)TRUE);
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return(FALSE);
  }

MRESULT EXPENTRY fnwpCfgHDWhandshakeDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static NBKPAGECTL *pstPage;
  static COMDCB *pstComDCB;
  static bAllowClick;
//  WORD idEntryField;

  switch (msg)
    {
    case WM_INITDLG:
      if (!bInsertNewDevice)
        WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
//        ControlEnable(hwndDlg,DID_INSERT,FALSE);
      bAllowClick = FALSE;
      pstPage = PVOIDFROMMP(mp2);
      pstPage->bDirtyBit = FALSE;
      pstComDCB = pstPage->pVoidPtrOne;
      if (pstComDCB->wFlags1 == 0)
        pstComDCB->wFlags1 = F1_DEFAULT;
      if (pstComDCB->wFlags2 == 0)
        pstComDCB->wFlags2 = F2_DEFAULT;
      FillHDWhandshakDlg(hwndDlg,pstComDCB);
      if (pstPage->bSpoolerConfig)
        WinSetDlgItemText(hwndDlg,ST_TITLE,"Hardware handshake configuration");
      WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      break;
    case UM_INITLS:
      bAllowClick = TRUE;
      break;
    case UM_SET_FOCUS:
      WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
      break;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_INSERT:
           WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
           break;
        case DID_CANCEL:
          WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
          return(FALSE);
        case DID_HELP:
          WinSendMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
          return(FALSE);
        case DID_UNDO:
          bAllowClick = FALSE;
          pstPage->bDirtyBit = FALSE;
          FillHDWhandshakDlg(hwndDlg,pstComDCB);
          bAllowClick = TRUE;
          return(FALSE);
        }
      break;
    case WM_CONTROL:
      if (SHORT2FROMMP(mp1) == BN_CLICKED)
        if (bAllowClick)
          pstPage->bDirtyBit = TRUE;
      break;
    case UM_SAVE_DATA:
      UnloadHDWhandshakDlg(hwndDlg,pstComDCB);
      return((MRESULT)TRUE);
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return(FALSE);
  }

MRESULT EXPENTRY fnwpCfgASCIIhandshakeDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static NBKPAGECTL *pstPage;
  static COMDCB *pstComDCB;
  static bAllowClick;

  switch (msg)
    {
    case WM_INITDLG:
      if (!bInsertNewDevice)
        WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
//        ControlEnable(hwndDlg,DID_INSERT,FALSE);
      bAllowClick = FALSE;
      pstPage = PVOIDFROMMP(mp2);
      pstPage->bDirtyBit = FALSE;
      pstComDCB = pstPage->pVoidPtrOne;
      FillASCIIhandshakingDlg(hwndDlg,pstComDCB);
      if (pstPage->bSpoolerConfig)
        WinSetDlgItemText(hwndDlg,ST_TITLE,"Port ASCII handshaking configuration");
      WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      break;
    case UM_INITLS:
      bAllowClick = TRUE;
      break;
    case UM_SET_FOCUS:
      WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
      break;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_INSERT:
           WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
           break;
        case DID_CANCEL:
          WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
          return(FALSE);
        case DID_HELP:
          WinSendMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
          return(FALSE);
        case DID_UNDO:
          bAllowClick = FALSE;
          pstPage->bDirtyBit = FALSE;
          FillASCIIhandshakingDlg(hwndDlg,pstComDCB);
          bAllowClick = TRUE;
          return(FALSE);
        }
      break;
    case WM_CONTROL:
      if (bAllowClick)
        {
        switch (SHORT2FROMMP(mp1))
          {
          case BN_CLICKED:
            pstPage->bDirtyBit = TRUE;
            TCASCIIhandshakeDlg(hwndDlg,SHORT1FROMMP(mp1));
            break;
          case EN_CHANGE:
            pstPage->bDirtyBit = TRUE;
            break;
          }
        }
      break;
    case UM_SAVE_DATA:
      UnloadASCIIhandshakeDlg(hwndDlg,pstComDCB);
      return((MRESULT)TRUE);
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return(FALSE);
  }

MRESULT EXPENTRY fnwpDefThresholdDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static  NBKPAGECTL *pstPage;
  static COMDCB *pstComDCB;
  static BOOL bAllowChange;
  char szMessage[80];

  switch (msg)
    {
    case WM_INITDLG:
      if (!bInsertNewDevice)
        WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
//        ControlEnable(hwndDlg,DID_INSERT,FALSE);
      pstPage = PVOIDFROMMP(mp2);
      pstComDCB = pstPage->pVoidPtrOne;
      pstPage->bDirtyBit = FALSE;
      bAllowChange = FALSE;
      WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(pstComDCB->wReadBufferLength - lOrgXonHysteresis),(MPARAM)1);
      WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_SETCURRENTVALUE,(MPARAM)lOrgXoffThreshold,NULL);
      WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(pstComDCB->wReadBufferLength - lOrgXoffThreshold),(MPARAM)1);
      WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_SETCURRENTVALUE,(MPARAM)lOrgXonHysteresis,NULL);
      sprintf(szMessage,szBuffSizeFormat,pstComDCB->wReadBufferLength);
      WinSetDlgItemText(hwndDlg,PCFG_THRESHOLD_BUFF_SIZE,szMessage);
      WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      break;
    case UM_RECALCDLG:
      WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(ulReadBufLen - lOrgXonHysteresis),(MPARAM)1);
      WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_SETCURRENTVALUE,(MPARAM)lOrgXoffThreshold,NULL);
      WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(ulReadBufLen - lOrgXoffThreshold),(MPARAM)1);
      WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_SETCURRENTVALUE,(MPARAM)lOrgXonHysteresis,NULL);
      sprintf(szMessage,szBuffSizeFormat,ulReadBufLen);
      WinSetDlgItemText(hwndDlg,PCFG_THRESHOLD_BUFF_SIZE,szMessage);
      break;
    case UM_INITLS:
      bAllowChange = TRUE;
      break;
    case UM_SET_FOCUS:
      WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
      break;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_INSERT:
           WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
           break;
        case DID_CANCEL:
          WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
          return(FALSE);
        case DID_HELP:
          WinSendMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
          return(FALSE);
        case DID_UNDO:
          pstPage->bDirtyBit = FALSE;
          bAllowChange = FALSE;
          WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(pstComDCB->wReadBufferLength - lOrgXonHysteresis),(MPARAM)1);
          WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_SETCURRENTVALUE,(MPARAM)lOrgXoffThreshold,NULL);
          WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(pstComDCB->wReadBufferLength - lOrgXoffThreshold),(MPARAM)1);
          WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_SETCURRENTVALUE,(MPARAM)lOrgXonHysteresis,NULL);
          bAllowChange = TRUE;
          return(FALSE);
        }
      break;
    case UM_SAVE_DATA:
      pstComDCB->wXonHysteresis = lXonHysteresis;
      pstComDCB->wXoffThreshold = lXoffThreshold;
      break;
    case WM_CONTROL:
      if (bAllowChange & (SHORT2FROMMP(mp1) == SPBN_CHANGE))
        if (SHORT1FROMMP(mp1) == PCFG_XON_THRESHOLD)
          {
          pstPage->bDirtyBit = TRUE;
          WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_QUERYVALUE,&lXonHysteresis,MPFROM2SHORT(0,SPBQ_ALWAYSUPDATE));
          WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(pstComDCB->wReadBufferLength - lXonHysteresis),(MPARAM)1);
          }
        else
          if (SHORT1FROMMP(mp1) == PCFG_XOFF_THRESHOLD)
            {
            pstPage->bDirtyBit = TRUE;
            WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_QUERYVALUE,&lXoffThreshold,MPFROM2SHORT(0,SPBQ_ALWAYSUPDATE));
            WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(pstComDCB->wReadBufferLength - lXoffThreshold),(MPARAM)1);
            }
      break;
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return(FALSE);
  }



