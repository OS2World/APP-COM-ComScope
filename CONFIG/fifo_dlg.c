#include "COMMON.H"
#include "COMDD.H"
#include "ioctl.h"
#include "utility.h"
#include "help.h"

#include "COMi_CFG.h"
#include "resource.h"


static BOOL FillCfgFIFOsetupDlg(HWND hwnd,WORD wFlags,WORD wTxFIFOload);
static BOOL UnloadCfgFIFOsetupDlg(HWND hwnd,WORD *pwFlags,WORD *pwTxFIFOload);
static BOOL TCCfgFIFOsetupDlg(HWND hwnd,USHORT idButton);

extern HMODULE hThisModule;
extern HWND hwndNoteBookDlg;
extern BOOL bInsertNewDevice;
/*
**  Dialog to set default FIFO modes
*/
MRESULT EXPENTRY fnwpHdwDefFIFOsetupDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static NBKPAGECTL *pstPage;
  static bAllowClick;
  static COMDCB *pstComDCB;
  static WORD wFlags;
  static WORD wTxFIFOload;

  switch (msg)
    {
    case WM_INITDLG:
      if (!bInsertNewDevice)
        WinSetDlgItemText(hwnd,DID_INSERT,"S~ave");
//        ControlEnable(hwnd,DID_INSERT,FALSE);
//      CenterDlgBox(hwnd);
//      WinSetFocus(HWND_DESKTOP,hwnd);
      bAllowClick = FALSE;
      pstPage = PVOIDFROMMP(mp2);
      pstPage->bDirtyBit = FALSE;
      pstComDCB = pstPage->pVoidPtrOne;
      wFlags = pstComDCB->wFlags3;
      wTxFIFOload = pstComDCB->wTxFIFOload;
      FillCfgFIFOsetupDlg(hwnd,wFlags,wTxFIFOload);
      if (pstPage->bSpoolerConfig)
        WinSetDlgItemText(hwnd,ST_TITLE,"Port hardware buffer (FIFO) configuration");
      WinPostMsg(hwnd,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      break;
    case UM_INITLS:
      bAllowClick = TRUE;
      break;
    case UM_SET_FOCUS:
      WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwnd,SHORT1FROMMP(mp1)));
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
           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
           return(FALSE);
        case DID_UNDO:
          bAllowClick = FALSE;
          pstPage->bDirtyBit = FALSE;
          FillCfgFIFOsetupDlg(hwnd,wFlags,wTxFIFOload);
          bAllowClick = TRUE;
        }
      break;
    case WM_CONTROL:
      if (SHORT2FROMMP(mp1) == BN_CLICKED)
        if (bAllowClick)
          {
          pstPage->bDirtyBit = TRUE;
          TCCfgFIFOsetupDlg(hwnd,SHORT1FROMMP(mp1));
          }
      break;
    case UM_SAVE_DATA:
      if (pstPage->bDirtyBit)
        {
        UnloadCfgFIFOsetupDlg(hwnd,&pstComDCB->wFlags3,&pstComDCB->wTxFIFOload);
        pstComDCB->wConfigFlags2 &= ~CFG_FLAG2_EXPLICIT_TX_LOAD;
        }
      return((MRESULT)TRUE);
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return(FALSE);
  }

BOOL FillCfgFIFOsetupDlg(HWND hwnd,WORD wFlags,WORD wTxFIFOload)
  {
  WORD idEntryField;
  BOOL bEnable;

  if ((wFlags & F3_HDW_BUFFER_APO) != 0)
    {
    switch ((wFlags & F3_HDW_BUFFER_APO) >> 3)
      {
      case 1:
        CheckButton(hwnd,HWF_DISABFIFO,TRUE);
        CheckButton(hwnd,HWF_ENABFIFO,FALSE);
        CheckButton(hwnd,HWF_APO,FALSE);
        break;
      case 2:
        CheckButton(hwnd,HWF_DISABFIFO,FALSE);
        CheckButton(hwnd,HWF_ENABFIFO,TRUE);
        CheckButton(hwnd,HWF_APO,FALSE);
        break;
      case 3:
        CheckButton(hwnd,HWF_DISABFIFO,FALSE);
        CheckButton(hwnd,HWF_ENABFIFO,FALSE);
        CheckButton(hwnd,HWF_APO,TRUE);
        break;
      default:
        CheckButton(hwnd,HWF_DISABFIFO,TRUE);
        CheckButton(hwnd,HWF_ENABFIFO,FALSE);
        CheckButton(hwnd,HWF_APO,FALSE);
        break;
      }
    switch ((wFlags & F3_14_CHARACTER_FIFO) >> 5)
      {
      case 0:
        idEntryField = HWF_1TRIG;
        break;
      case 1:
        idEntryField = HWF_4TRIG;
        break;
      case 2:
        idEntryField = HWF_8TRIG;
        break;
      default:
        idEntryField = HWF_14TRIG;
        break;
      }
    CheckButton(hwnd,idEntryField,TRUE);

    if (((wFlags & F3_USE_TX_BUFFER) == 0) || (wTxFIFOload == 1))
      idEntryField = HWF_TX_MIN;
    else
      if (wTxFIFOload == 2)
        idEntryField = HWF_TX_HALF;
      else
        if (wTxFIFOload == 3)
          idEntryField = HWF_TX_HIHALF;
        else
          idEntryField = HWF_TX_MAX;

    CheckButton(hwnd,idEntryField,TRUE);
    }
  if ((wFlags & F3_HDW_BUFFER_ENABLE) != F3_HDW_BUFFER_ENABLE)
    bEnable = FALSE;
  else
    bEnable = TRUE;
  ControlEnable(hwnd,HWF_1TRIG,bEnable);
  ControlEnable(hwnd,HWF_4TRIG,bEnable);
  ControlEnable(hwnd,HWF_8TRIG,bEnable);
  ControlEnable(hwnd,HWF_14TRIG,bEnable);
  ControlEnable(hwnd,HWF_TX_HALF,bEnable);
  ControlEnable(hwnd,HWF_TX_MIN,bEnable);
  ControlEnable(hwnd,HWF_TX_HIHALF,bEnable);
  ControlEnable(hwnd,HWF_TX_MAX,bEnable);
  return(TRUE);
  }

BOOL UnloadCfgFIFOsetupDlg(HWND hwnd,WORD *pwFlags,WORD *pwTxFIFOload)
  {
  *pwFlags &= ~F3_FIFO_MASK;
  if (Checked(hwnd,HWF_DISABFIFO))
    *pwFlags |= F3_HDW_BUFFER_DISABLE;
  else
    {
    if (Checked(hwnd,HWF_ENABFIFO))
      *pwFlags |= F3_HDW_BUFFER_ENABLE;
    else
      if (Checked(hwnd,HWF_APO))
        *pwFlags |= F3_HDW_BUFFER_APO;

    if (Checked(hwnd,HWF_4TRIG))
      *pwFlags |= F3_4_CHARACTER_FIFO;
    else
      if (Checked(hwnd,HWF_8TRIG))
        *pwFlags |= F3_8_CHARACTER_FIFO;
      else
        if (Checked(hwnd,HWF_14TRIG))
          *pwFlags |= F3_14_CHARACTER_FIFO;
    /*
    **  Set default TX load count
    */
    if (Checked(hwnd,HWF_TX_MIN))
      {
      *pwFlags &= ~F3_USE_TX_BUFFER;
      *pwTxFIFOload = 1;
      }
    else
      {
      *pwFlags |= F3_USE_TX_BUFFER;
      if (Checked(hwnd,HWF_TX_HALF))
        *pwTxFIFOload = 2;
      else
        if (Checked(hwnd,HWF_TX_HIHALF))
          *pwTxFIFOload = 3;
        else
          *pwTxFIFOload = 4;
      }
     /*
     **  Turn on bit to tell COMi that user has selected defaults for flag3
     */
    *pwFlags |= 0x8000;
    }
  return(TRUE);
  }

BOOL TCCfgFIFOsetupDlg(HWND hwnd,USHORT idButton)
  {
  switch(idButton)
    {
    case HWF_DISABFIFO:
      if (!Checked(hwnd,HWF_DISABFIFO))
        {
//        CheckButton(hwnd,HWF_1TRIG,TRUE);
//        CheckButton(hwnd,HWF_TX_MIN,TRUE);
        CheckButton(hwnd,HWF_DISABFIFO,TRUE);
        CheckButton(hwnd,HWF_APO,FALSE);
        CheckButton(hwnd,HWF_ENABFIFO,FALSE);
        ControlEnable(hwnd,HWF_1TRIG,FALSE);
        ControlEnable(hwnd,HWF_4TRIG,FALSE);
        ControlEnable(hwnd,HWF_8TRIG,FALSE);
        ControlEnable(hwnd,HWF_14TRIG,FALSE);
        ControlEnable(hwnd,HWF_TX_HALF,FALSE);
        ControlEnable(hwnd,HWF_TX_MIN,FALSE);
        ControlEnable(hwnd,HWF_TX_HIHALF,FALSE);
        ControlEnable(hwnd,HWF_TX_MAX,FALSE);
        }
      break;
    case HWF_APO:
      if (!Checked(hwnd,HWF_APO))
        {
//        if (Checked(hwnd,HWF_DISABFIFO))
//          {
//          CheckButton(hwnd,HWF_14TRIG,TRUE);
//          CheckButton(hwnd,HWF_TX_MAX,TRUE);
//          }
        CheckButton(hwnd,HWF_APO,TRUE);
        CheckButton(hwnd,HWF_ENABFIFO,FALSE);
        CheckButton(hwnd,HWF_DISABFIFO,FALSE);
        ControlEnable(hwnd,HWF_1TRIG,TRUE);
        ControlEnable(hwnd,HWF_4TRIG,TRUE);
        ControlEnable(hwnd,HWF_8TRIG,TRUE);
        ControlEnable(hwnd,HWF_14TRIG,TRUE);
        ControlEnable(hwnd,HWF_TX_HALF,TRUE);
        ControlEnable(hwnd,HWF_TX_MIN,TRUE);
        ControlEnable(hwnd,HWF_TX_HIHALF,TRUE);
        ControlEnable(hwnd,HWF_TX_MAX,TRUE);
        }
      break;
    case HWF_ENABFIFO:
      if (!Checked(hwnd,HWF_ENABFIFO))
        {
//        if (Checked(hwnd,HWF_DISABFIFO))
//          {
//          CheckButton(hwnd,HWF_14TRIG,TRUE);
//          CheckButton(hwnd,HWF_TX_MAX,TRUE);
//          }
        CheckButton(hwnd,HWF_ENABFIFO,TRUE);
        CheckButton(hwnd,HWF_APO,FALSE);
        CheckButton(hwnd,HWF_DISABFIFO,FALSE);
        ControlEnable(hwnd,HWF_1TRIG,TRUE);
        ControlEnable(hwnd,HWF_4TRIG,TRUE);
        ControlEnable(hwnd,HWF_8TRIG,TRUE);
        ControlEnable(hwnd,HWF_14TRIG,TRUE);
        ControlEnable(hwnd,HWF_TX_HALF,TRUE);
        ControlEnable(hwnd,HWF_TX_MIN,TRUE);
        ControlEnable(hwnd,HWF_TX_HIHALF,TRUE);
        ControlEnable(hwnd,HWF_TX_MAX,TRUE);
        }
      break;
    default:
      return(FALSE);
    }
  return(TRUE);
  }

