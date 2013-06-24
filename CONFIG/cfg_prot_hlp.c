#include "COMMON.H"
#include "COMDD.H"
#include "ioctl.h"
#include "utility.h"

//#include "COMi_CFG.h"
#include "resource.h"

//ULONG const aulCfgStdBaudTable[] = {50,75,110,150,300,600,1200,2400,4800,7200,
//                                9600,14400,19200,28800,38400,57600,115200,0};

ULONG const aulCfgExtBaudTable[] = {50,75,110,150,300,600,1200,2400,4800,7200,
                                 9600,14400,19200,28800,38400,57600,76800,
                                 92160,115200,153600,230400,460800,0};

VOID FillCfgFilterDlg(HWND hwnd,COMDCB *pstComDCB)
  {
  char szReplaceChar[5];
  BOOL bEnable;

  sprintf(szReplaceChar,"%02X",pstComDCB->byErrorChar);
  WinSendDlgItemMsg(hwnd,HWR_ERRCHAR,EM_SETTEXTLIMIT,MPFROMSHORT(2),(MPARAM)NULL);
  WinSetDlgItemText(hwnd,HWR_ERRCHAR,szReplaceChar);

  sprintf(szReplaceChar,"%02X",pstComDCB->byBreakChar);
  WinSendDlgItemMsg(hwnd,HWR_BRKCHAR,EM_SETTEXTLIMIT,MPFROMSHORT(2),(MPARAM)NULL);
  WinSetDlgItemText(hwnd,HWR_BRKCHAR,szReplaceChar);

  if (pstComDCB->wFlags2 & F2_ENABLE_ERROR_REPL)
    bEnable = TRUE;
  else
    bEnable = FALSE;
  CheckButton(hwnd,HWR_ENABERR,bEnable);
  ControlEnable(hwnd,HWR_ERRTTT,bEnable);
  ControlEnable(hwnd,HWR_ERRTT,bEnable);
  ControlEnable(hwnd,HWR_ERRT,bEnable);
  ControlEnable(hwnd,HWR_ERRCHAR,bEnable);

  if (pstComDCB->wFlags2 & F2_ENABLE_NULL_STRIP)
    bEnable = TRUE;
  else
    bEnable = FALSE;
  CheckButton(hwnd,HWR_ENABNUL,bEnable);

  if (pstComDCB->wFlags2 & F2_ENABLE_BREAK_REPL)
    bEnable = TRUE;
  else
    bEnable = FALSE;
  CheckButton(hwnd,HWR_ENABBRK,bEnable);
  ControlEnable(hwnd,HWR_BRKTTT,bEnable);
  ControlEnable(hwnd,HWR_BRKTT,bEnable);
  ControlEnable(hwnd,HWR_BRKT,bEnable);
  ControlEnable(hwnd,HWR_BRKCHAR,bEnable);
  }

VOID EXPENTRY UnloadCfgFilterDlg(HWND hwnd,COMDCB *pstComDCB)
  {
  char szReplaceChar[5];

  WinQueryDlgItemText(hwnd,HWR_ERRCHAR,3,szReplaceChar);
  pstComDCB->byErrorChar = (BYTE)ASCIItoBin(szReplaceChar,16);

  WinQueryDlgItemText(hwnd,HWR_BRKCHAR,3,szReplaceChar);
  pstComDCB->byBreakChar = (BYTE)ASCIItoBin(szReplaceChar,16);

  if (Checked(hwnd,HWR_ENABERR))
    pstComDCB->wFlags2 |= F2_ENABLE_ERROR_REPL;
  else
    pstComDCB->wFlags2 &= ~F2_ENABLE_ERROR_REPL;

  if (Checked(hwnd,HWR_ENABBRK))
    pstComDCB->wFlags2 |= F2_ENABLE_BREAK_REPL;
  else
    pstComDCB->wFlags2 &= ~F2_ENABLE_BREAK_REPL;

  if (Checked(hwnd,HWR_ENABNUL))
    pstComDCB->wFlags2 |= F2_ENABLE_NULL_STRIP;
  else
    pstComDCB->wFlags2 &= ~F2_ENABLE_NULL_STRIP;
  }

void TCCfgFilterDlg(HWND hwnd,USHORT usButtonId)
  {
  switch(usButtonId)
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
    }
  }

HWND FillCfgTimeoutDlg(HWND hwnd,COMDCB *pstComDCB)
  {
  char szTimeout[8];
  USHORT usEntryFocusId;
  BOOL bEnable;

  if (pstComDCB->wFlags3 == 0)
    pstComDCB->wFlags3 = F3_DEFAULT;
  if (pstComDCB->wRdTimeout == 0)
    pstComDCB->wRdTimeout = DEF_READ_TIMEOUT;
  if (pstComDCB->wWrtTimeout == 0)
    pstComDCB->wWrtTimeout = DEF_WRITE_TIMEOUT;

  sprintf(szTimeout,"%u",pstComDCB->wRdTimeout);
  WinSetDlgItemText(hwnd,HWT_RTIME,szTimeout);
  WinSendDlgItemMsg(hwnd,HWT_RTIME,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);

  sprintf(szTimeout,"%u",pstComDCB->wWrtTimeout);
  WinSendDlgItemMsg(hwnd,HWT_WTIME,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
  WinSetDlgItemText(hwnd,HWT_WTIME,szTimeout);

  if (pstComDCB->wFlags3 & F3_INFINITE_WRT_TIMEOUT)
    {
    bEnable = FALSE;
    CheckButton(hwnd,HWT_WINF,TRUE);
    }
  else
    {
    bEnable = TRUE;
    CheckButton(hwnd,HWT_WNORM,TRUE);
    }

  ControlEnable(hwnd,HWT_WTIMET,bEnable);
  ControlEnable(hwnd,HWT_WTIME,bEnable);

  if ((pstComDCB->wFlags3 & F3_RTO_MASK) == F3_WAIT_NONE) // first mask significant bits
    {
    bEnable = FALSE;
    CheckButton(hwnd,HWT_RNOWAIT,TRUE);
    usEntryFocusId = HWT_RNOWAIT;
    }
  else
    {
    bEnable = TRUE;
    if ((pstComDCB->wFlags3  & F3_RTO_MASK) == F3_WAIT_SOMETHING)
      {
      CheckButton(hwnd,HWT_RWAITSOME,TRUE);
      usEntryFocusId = HWT_RWAITSOME;
      }
    else
      {
      CheckButton(hwnd,HWT_RNORM,TRUE);
      usEntryFocusId = HWT_RNORM;
      }
    }

  ControlEnable(hwnd,HWT_RTIMET,bEnable);
  ControlEnable(hwnd,HWT_RTIME,bEnable);

  return(WinWindowFromID(hwnd,usEntryFocusId));
  }

void UnloadCfgTimeoutDlg(HWND hwnd,COMDCB *pstComDCB)
  {
  char szTimeout[9];

  if (Checked(hwnd,HWT_WINF))
    pstComDCB->wFlags3 |= F3_INFINITE_WRT_TIMEOUT;
  else
    pstComDCB->wFlags3 &= ~F3_INFINITE_WRT_TIMEOUT;

  pstComDCB->wFlags3 &= ~F3_RTO_MASK;
  if (Checked(hwnd,HWT_RNOWAIT))
    pstComDCB->wFlags3 |= F3_WAIT_NONE;
  else
    {
    if (Checked(hwnd,HWT_RWAITSOME))
      pstComDCB->wFlags3 |= F3_WAIT_SOMETHING;
    else
      pstComDCB->wFlags3 |= F3_WAIT_NORM;
    }
  pstComDCB->wFlags3 |= 0x8000;

  WinQueryDlgItemText(hwnd,HWT_WTIME,6,szTimeout);
  pstComDCB->wWrtTimeout = (WORD)atol(szTimeout);

  WinQueryDlgItemText(hwnd,HWT_RTIME,6,szTimeout);
  pstComDCB->wRdTimeout = (WORD)atol(szTimeout);
  }

BOOL TCCfgTimeoutDlg(HWND hwnd,USHORT idButton)
  {
  switch(idButton)
    {
    case HWT_RNOWAIT:
      if (Checked(hwnd,HWT_RNOWAIT))
        {
        ControlEnable(hwnd,HWT_RTIMET,FALSE);
        ControlEnable(hwnd,HWT_RTIME,FALSE);
        }
      else
        {
        ControlEnable(hwnd,HWT_RTIMET,TRUE);
        ControlEnable(hwnd,HWT_RTIME,TRUE);
        }
      break;
    case HWT_RNORM:
    case HWT_RWAITSOME:
      if (Checked(hwnd,HWT_RNORM) || Checked(hwnd,HWT_RWAITSOME))
        {
        ControlEnable(hwnd,HWT_RTIMET,TRUE);
        ControlEnable(hwnd,HWT_RTIME,TRUE);
        }
      else
        {
        ControlEnable(hwnd,HWT_RTIMET,FALSE);
        ControlEnable(hwnd,HWT_RTIME,FALSE);
        }
      break;
    case HWT_WINF:
      if (Checked(hwnd,HWT_WINF))
        {
        ControlEnable(hwnd,HWT_WTIMET,FALSE);
        ControlEnable(hwnd,HWT_WTIME,FALSE);
        }
      else
        {
        ControlEnable(hwnd,HWT_WTIMET,TRUE);
        ControlEnable(hwnd,HWT_WTIME,TRUE);
        }
      break;
    case HWT_WNORM:
      if (Checked(hwnd,HWT_WNORM))
        {
        ControlEnable(hwnd,HWT_WTIMET,TRUE);
        ControlEnable(hwnd,HWT_WTIME,TRUE);
        }
      else
        {
        ControlEnable(hwnd,HWT_WTIMET,FALSE);
        ControlEnable(hwnd,HWT_WTIME,FALSE);
        }
      break;
    default:
      return(FALSE);
    }
  return(TRUE);
  }

VOID FillCfgProtocolDlg(HWND hwnd,BYTE byLineChar)
  {
  WORD idDisableField;
  WORD idEntryField;

  if (byLineChar == 0)
    {
    CheckButton(hwnd,HWP_8BITS,TRUE);
    CheckButton(hwnd,HWP_1BIT,TRUE);
    CheckButton(hwnd,HWP_EVEN,TRUE);
    ControlEnable(hwnd,HWP_15BITS,FALSE);
    }
  else
    {
    idDisableField = HWP_15BITS;
    switch (byLineChar & 0x03)
      {
      case 3:
        idEntryField = HWP_8BITS;
        break;
      case 2:
        idEntryField = HWP_7BITS;
        break;
      case 1:
        idEntryField = HWP_6BITS;
        break;
      case 0:
        idEntryField = HWP_5BITS;
        idDisableField = HWP_2BITS;
        break;
      }
    CheckButton(hwnd,idEntryField,TRUE);

    if (idEntryField == HWP_5BITS)
      if ((byLineChar & 0x04) != 0)
        CheckButton(hwnd,HWP_15BITS,TRUE);
      else
        CheckButton(hwnd,HWP_1BIT,TRUE);
    else
      if ((byLineChar & 0x04) != 0)
        CheckButton(hwnd,HWP_2BITS,TRUE);
      else
        CheckButton(hwnd,HWP_1BIT,TRUE);

    ControlEnable(hwnd,idDisableField,FALSE);
    CheckButton(hwnd,idEntryField,TRUE);
    switch (byLineChar & 0x38)
      {
      case 0x00:
        idEntryField = HWP_NONE;
        break;
      case 0x08:
        idEntryField = HWP_ODD;
        break;
      case 0x18:
        idEntryField = HWP_EVEN;
        break;
      case 0x38:
        idEntryField = HWP_ZERO;
        break;
      case 0x28:
        idEntryField = HWP_ONE;
        break;
      }
    CheckButton(hwnd,idEntryField,TRUE);
    }
  }

VOID UnloadCfgProtocolDlg(HWND hwnd,BYTE *pbyLineChar)
  {
  if (Checked(hwnd,HWP_8BITS))
    *pbyLineChar = 0x03;
  else
    if (Checked(hwnd,HWP_7BITS))
      *pbyLineChar = 0x02;
    else
      if (Checked(hwnd,HWP_6BITS))
        *pbyLineChar = 0x01;
      else
        *pbyLineChar = 0x00;

  if (!Checked(hwnd,HWP_1BIT))
    *pbyLineChar |= 0x04;

  if (!Checked(hwnd,HWP_NONE))
    if (Checked(hwnd,HWP_ODD))
      *pbyLineChar |= 0x08;
    else
      if (Checked(hwnd,HWP_EVEN))
        *pbyLineChar |= 0x18;
      else
        if (Checked(hwnd,HWP_ZERO))
          *pbyLineChar |= 0x38;
        else
          *pbyLineChar |= 0x28;

  *pbyLineChar |= 0xc0;
  }

BOOL TCCfgProtocolDlg(HWND hwnd,USHORT idButton)
  {
  switch(idButton)
    {
    case HWP_5BITS:
//      CheckButton(hwnd,idButton,~Checked(hwnd,idButton));
      ControlEnable(hwnd,HWP_15BITS,TRUE);
      ControlEnable(hwnd,HWP_2BITS,FALSE);
      if (Checked(hwnd,HWP_2BITS))
        {
        CheckButton(hwnd,HWP_2BITS,FALSE);
        CheckButton(hwnd,HWP_15BITS,TRUE);
        }
      break;
    case HWP_8BITS:
    case HWP_7BITS:
    case HWP_6BITS:
//      CheckButton(hwnd,idButton,~Checked(hwnd,idButton));
      ControlEnable(hwnd,HWP_15BITS,FALSE);
      ControlEnable(hwnd,HWP_2BITS,TRUE);
      if (Checked(hwnd,HWP_15BITS))
        {
        CheckButton(hwnd,HWP_15BITS,FALSE);
        CheckButton(hwnd,HWP_2BITS,TRUE);
        }
    default:
      return(FALSE);
    }
   return(TRUE);
  }

void FillCfgFIFOsetupDlg(HWND hwnd,WORD wFlags,FIFOINF *pstFIFOinfo)
  {
  WORD idEntryField;
  USHORT usMaxFIFOload;
  USHORT usCurrentFIFOload;

#ifdef this_junk
  if (pstFIFOinfo->wFIFOsize > 16)
    {
    if (pstFIFOinfo->wFIFOflags & CFG_FLAG2_HDW_CTS_HS)
      CheckButton(hwnd,HWF_HDW_CTS_HS,TRUE);
    if (pstFIFOinfo->wFIFOflags & CFG_FLAG2_HDW_RTS_HS)
      CheckButton(hwnd,HWF_HDW_RTS_HS,TRUE);
    if (pstFIFOinfo->wFIFOsize == 32)
      {
      if (pstFIFOinfo->wFIFOflags & CFG_FLAG2_HDW_RX_XON_HS)
        CheckButton(hwnd,HWF_HDW_RX_XON_HS,TRUE);
      if (pstFIFOinfo->wFIFOflags & CFG_FLAG2_HDW_TX_XON_HS)
        CheckButton(hwnd,HWF_HDW_TX_XON_HS,TRUE);
      }
    }
#endif
  if ((wFlags & F3_HDW_BUFFER_APO) != 0)
    {
    switch ((wFlags & F3_HDW_BUFFER_APO) >> 3)
      {
      case 1:
        idEntryField = HWF_DISABFIFO;
        break;
      case 2:
        idEntryField = HWF_ENABFIFO;
        break;
      case 3:
        idEntryField = HWF_APO;
        break;
      default:
        idEntryField = 0;
      }
    if (idEntryField != 0)
      CheckButton(hwnd,idEntryField,TRUE);

    if ((pstFIFOinfo->wFIFOflags & FIFO_FLG_LOW_16750_TRIG) ||
        (pstFIFOinfo->wFIFOsize <= 32))
      {
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
      }
    else
      {
      switch ((wFlags & F3_14_CHARACTER_FIFO) >> 5)
        {
        case 0:
          idEntryField = HWF_1TRIG;
          break;
        case 1:
          idEntryField = HWF_16TRIG;
          break;
        case 2:
          idEntryField = HWF_32TRIG;
          break;
        default:
          idEntryField = HWF_56TRIG;
          break;
        }
      }
    CheckButton(hwnd,idEntryField,TRUE);

    if (pstFIFOinfo->wFIFOsize > 32)
      usMaxFIFOload = 64;
    else
      if (pstFIFOinfo->wFIFOsize > 16)
        usMaxFIFOload = 25;
      else
        usMaxFIFOload = 16;
    if ((wFlags & F3_USE_TX_BUFFER) == 0)
      usCurrentFIFOload = 1;
    else
      usCurrentFIFOload = pstFIFOinfo->wTxFIFOload;

    WinSendDlgItemMsg(hwnd,HWF_TXFIFO_LOAD,
                              SPBM_SETLIMITS,
                      (MPARAM)usMaxFIFOload,
                      (MPARAM)1);

    if (usCurrentFIFOload > usMaxFIFOload)
      usCurrentFIFOload = usMaxFIFOload;
    WinSendDlgItemMsg(hwnd,HWF_TXFIFO_LOAD,
                              SPBM_SETCURRENTVALUE,
                      (MPARAM)usCurrentFIFOload,
                              NULL);
    }
  if ((wFlags & F3_HDW_BUFFER_ENABLE) != F3_HDW_BUFFER_ENABLE)
    {
    ControlEnable(hwnd,HWF_1TRIG,FALSE);
    ControlEnable(hwnd,HWF_4TRIG,FALSE);
    ControlEnable(hwnd,HWF_8TRIG,FALSE);
    ControlEnable(hwnd,HWF_14TRIG,FALSE);
    ControlEnable(hwnd,HWF_TXLOADT,FALSE);
    ControlEnable(hwnd,HWF_TXLOADTT,FALSE);
    ControlEnable(hwnd,HWF_TXFIFO_LOAD,FALSE);
    if (usMaxFIFOload == 64)
      {
      ControlEnable(hwnd,HWF_32TRIG,FALSE);
      ControlEnable(hwnd,HWF_56TRIG,FALSE);
      }
    }
  }

void UnloadCfgFIFOsetupDlg(HWND hwnd,WORD *pwFlags,FIFOINF *pstFIFOinfo)
  {
  LONG lTemp;

  *pwFlags &= ~F3_FIFO_MASK;
  if (Checked(hwnd,HWF_DISABFIFO))
    *pwFlags |= F3_HDW_BUFFER_DISABLE;
  else
    {
    if (Checked(hwnd,HWF_ENABFIFO))
      *pwFlags |= F3_HDW_BUFFER_ENABLE;
    else
      *pwFlags |= F3_HDW_BUFFER_APO;

    *pwFlags |= F3_USE_TX_BUFFER;
    WinSendDlgItemMsg(hwnd,
                      HWF_TXFIFO_LOAD,
                      SPBM_QUERYVALUE,
                      &lTemp,
                      MPFROM2SHORT(0,SPBQ_DONOTUPDATE));

    pstFIFOinfo->wTxFIFOload = (USHORT)lTemp;

    if (pstFIFOinfo->wTxFIFOload == 1)
      *pwFlags &= ~F3_USE_TX_BUFFER;

    pstFIFOinfo->wFIFOflags |= FIFO_FLG_LOW_16750_TRIG;
    *pwFlags &= ~F3_14_CHARACTER_FIFO;
    if (!Checked(hwnd,HWF_1TRIG))
      {
      if (Checked(hwnd,HWF_4TRIG))
        *pwFlags |= F3_4_CHARACTER_FIFO;
      else
        if (Checked(hwnd,HWF_8TRIG))
          *pwFlags |= F3_8_CHARACTER_FIFO;
        else
          if (Checked(hwnd,HWF_14TRIG))
            *pwFlags |= F3_14_CHARACTER_FIFO;
          else
            {
            if (pstFIFOinfo->wFIFOsize > 32)
              pstFIFOinfo->wFIFOflags &= ~FIFO_FLG_LOW_16750_TRIG;
            if (Checked(hwnd,HWF_56TRIG))
              *pwFlags |= F3_14_CHARACTER_FIFO;
            else
              if (Checked(hwnd,HWF_16TRIG))
                *pwFlags |= F3_4_CHARACTER_FIFO;
              else
                *pwFlags |= F3_8_CHARACTER_FIFO;
            }
      }
    }
  }

BOOL EXPENTRY TCCfgFIFOsetupDlg(HWND hwnd,USHORT idButton,FIFOINF *pstFIFOinfo)
  {
  switch(idButton)
    {
    case HWF_DISABFIFO:
      if (!Checked(hwnd,HWF_DISABFIFO))
        {
        CheckButton(hwnd,HWF_1TRIG,TRUE);
        CheckButton(hwnd,HWF_TX_MIN,TRUE);
        CheckButton(hwnd,HWF_DISABFIFO,TRUE);
        CheckButton(hwnd,HWF_APO,FALSE);
        CheckButton(hwnd,HWF_ENABFIFO,FALSE);
        ControlEnable(hwnd,HWF_1TRIG,FALSE);
        ControlEnable(hwnd,HWF_4TRIG,FALSE);
        ControlEnable(hwnd,HWF_8TRIG,FALSE);
        ControlEnable(hwnd,HWF_14TRIG,FALSE);
        if (pstFIFOinfo->wFIFOsize > 32)
          {
          ControlEnable(hwnd,HWF_16TRIG,FALSE);
          ControlEnable(hwnd,HWF_32TRIG,FALSE);
          ControlEnable(hwnd,HWF_56TRIG,FALSE);
          }
        ControlEnable(hwnd,HWF_TXLOADT,FALSE);
        ControlEnable(hwnd,HWF_TXLOADTT,FALSE);
        ControlEnable(hwnd,HWF_TXFIFO_LOAD,FALSE);
        }
      break;
    case HWF_APO:
      if (!Checked(hwnd,HWF_APO))
        {
        if (Checked(hwnd,HWF_DISABFIFO))
          {
          CheckButton(hwnd,HWF_14TRIG,TRUE);
          CheckButton(hwnd,HWF_TX_MAX,TRUE);
          WinSendDlgItemMsg(hwnd,HWF_TXFIFO_LOAD,
                                    SPBM_SETCURRENTVALUE,
                            (MPARAM)pstFIFOinfo->wTxFIFOload,
                                    NULL);
          }
        CheckButton(hwnd,HWF_APO,TRUE);
        CheckButton(hwnd,HWF_ENABFIFO,FALSE);
        CheckButton(hwnd,HWF_DISABFIFO,FALSE);
        ControlEnable(hwnd,HWF_1TRIG,TRUE);
        ControlEnable(hwnd,HWF_4TRIG,TRUE);
        ControlEnable(hwnd,HWF_8TRIG,TRUE);
        ControlEnable(hwnd,HWF_14TRIG,TRUE);
        if (pstFIFOinfo->wFIFOsize > 32)
          {
          ControlEnable(hwnd,HWF_16TRIG,TRUE);
          ControlEnable(hwnd,HWF_32TRIG,TRUE);
          ControlEnable(hwnd,HWF_56TRIG,TRUE);
          }
        ControlEnable(hwnd,HWF_TXLOADT,TRUE);
        ControlEnable(hwnd,HWF_TXLOADTT,TRUE);
        ControlEnable(hwnd,HWF_TXFIFO_LOAD,TRUE);
        }
      break;
    case HWF_ENABFIFO:
      if (!Checked(hwnd,HWF_ENABFIFO))
        {
        if (Checked(hwnd,HWF_DISABFIFO))
          {
          CheckButton(hwnd,HWF_14TRIG,TRUE);
          CheckButton(hwnd,HWF_TX_MAX,TRUE);
          WinSendDlgItemMsg(hwnd,HWF_TXFIFO_LOAD,
                                    SPBM_SETCURRENTVALUE,
                            (MPARAM)pstFIFOinfo->wTxFIFOload,
                                    NULL);
          }
        CheckButton(hwnd,HWF_ENABFIFO,TRUE);
        CheckButton(hwnd,HWF_APO,FALSE);
        CheckButton(hwnd,HWF_DISABFIFO,FALSE);
        ControlEnable(hwnd,HWF_1TRIG,TRUE);
        ControlEnable(hwnd,HWF_4TRIG,TRUE);
        ControlEnable(hwnd,HWF_8TRIG,TRUE);
        ControlEnable(hwnd,HWF_14TRIG,TRUE);
        if (pstFIFOinfo->wFIFOsize > 32)
          {
          ControlEnable(hwnd,HWF_16TRIG,TRUE);
          ControlEnable(hwnd,HWF_32TRIG,TRUE);
          ControlEnable(hwnd,HWF_56TRIG,TRUE);
          }
        ControlEnable(hwnd,HWF_TXLOADT,TRUE);
        ControlEnable(hwnd,HWF_TXLOADTT,TRUE);
        ControlEnable(hwnd,HWF_TXFIFO_LOAD,TRUE);
        }
      break;
    default:
      return(FALSE);
    }
  return(TRUE);
  }

void FillHDWhandshakDlg(HWND hwnd,COMDCB *pstComDCB)
  {
  USHORT idEntryField;

  if (pstComDCB->wConfigFlags2 & FIFO_FLG_HDW_CTS_HS)
    CheckButton(hwnd,HWF_HDW_CTS_HS,TRUE);
  else
    CheckButton(hwnd,HWF_HDW_CTS_HS,FALSE);

  if (pstComDCB->wConfigFlags2 & FIFO_FLG_HDW_RTS_HS)
    CheckButton(hwnd,HWF_HDW_RTS_HS,TRUE);
  else
    CheckButton(hwnd,HWF_HDW_RTS_HS,FALSE);

  switch ((pstComDCB->wFlags2 & F2_RTS_MASK) >> 6)
    {
    case 0:
      idEntryField = HS_RTSDISAB;
      break;
    case 1:
      idEntryField = HS_RTSENAB;
      break;
    case 2:
      idEntryField = HS_RTSINHS;
      break;
    case 3:
      idEntryField = HS_RTSTOG;
      break;
    }
  CheckButton(hwnd,idEntryField,TRUE);

  switch (pstComDCB->wFlags1 & F1_DTR_MASK)
    {
    case 0:
      idEntryField = HS_DTRDISAB;
      break;
    case 1:
      idEntryField = HS_DTRENAB;
      break;
    case 2:
      idEntryField = HS_DTRINHS;
      break;
    }
  CheckButton(hwnd,idEntryField,TRUE);

  if (pstComDCB->wFlags1 & F1_ENABLE_CTS_OUTPUT_HS)
    CheckButton(hwnd,HS_CTSOUT,TRUE);
  else
    CheckButton(hwnd,HS_CTSOUT,FALSE);
  if (pstComDCB->wFlags1 & F1_ENABLE_DSR_OUTPUT_HS)
    CheckButton(hwnd,HS_DSROUT,TRUE);
  else
    CheckButton(hwnd,HS_DSROUT,FALSE);
  if (pstComDCB->wFlags1 & F1_ENABLE_DCD_OUTPUT_HS)
    CheckButton(hwnd,HS_DCDOUT,TRUE);
  else
    CheckButton(hwnd,HS_DCDOUT,FALSE);
  if (pstComDCB->wFlags1 & F1_ENABLE_DSR_INPUT_HS)
    CheckButton(hwnd,HS_DSRINSENSE,TRUE);
  else
    CheckButton(hwnd,HS_DSRINSENSE,FALSE);
  }

void UnloadHDWhandshakDlg(HWND hwnd,COMDCB *pstComDCB)
  {
  pstComDCB->wConfigFlags2 &= ~FIFO_FLG_HDW_HS_MASK;
  if (Checked(hwnd,HWF_HDW_CTS_HS))
    pstComDCB->wConfigFlags2 |= FIFO_FLG_HDW_CTS_HS;
  if (Checked(hwnd,HWF_HDW_RTS_HS))
    pstComDCB->wConfigFlags2 |= FIFO_FLG_HDW_RTS_HS;
  pstComDCB->wFlags2 &= ~F2_RTS_MASK;

  pstComDCB->wFlags2 |= 0x8000;
  if (Checked(hwnd,HS_RTSENAB))
    pstComDCB->wFlags2 |= F2_ENABLE_RTS;
  else
    if (Checked(hwnd,HS_RTSINHS))
      pstComDCB->wFlags2 |= F2_ENABLE_RTS_INPUT_HS;
    else
      if (Checked(hwnd,HS_RTSTOG))
        pstComDCB->wFlags2 |= F2_ENABLE_RTS_TOG_ON_XMIT;

  pstComDCB->wFlags1 &= ~F1_DTR_MASK;
  pstComDCB->wFlags1 |= 0x8000;
  if (Checked(hwnd,HS_DTRENAB))
    pstComDCB->wFlags1 |= F1_ENABLE_DTR;
  else
    if (Checked(hwnd,HS_DTRINHS))
      pstComDCB->wFlags1 |= F1_ENABLE_DTR_INPUT_HS;

  if (Checked(hwnd,HS_CTSOUT))
    pstComDCB->wFlags1 |= F1_ENABLE_CTS_OUTPUT_HS;
  else
    pstComDCB->wFlags1 &= ~F1_ENABLE_CTS_OUTPUT_HS;

  if (Checked(hwnd,HS_DSROUT))
    pstComDCB->wFlags1 |= F1_ENABLE_DSR_OUTPUT_HS;
  else
    pstComDCB->wFlags1 &= ~F1_ENABLE_DSR_OUTPUT_HS;

  if (Checked(hwnd,HS_DCDOUT))
    pstComDCB->wFlags1 |= F1_ENABLE_DCD_OUTPUT_HS;
  else
    pstComDCB->wFlags1 &= ~F1_ENABLE_DCD_OUTPUT_HS;

  if (Checked(hwnd,HS_DSRINSENSE))
    pstComDCB->wFlags1 |= F1_ENABLE_DSR_INPUT_HS;
  else
    pstComDCB->wFlags1 &= ~F1_ENABLE_DSR_INPUT_HS;
  }

void FillASCIIhandshakingDlg(HWND hwnd,COMDCB *pstComDCB)
  {
  char szXchar[5];
  BOOL bXHS = FALSE;

#ifdef allow_16650_HDW_Xon_HS
  WinSetDlgItemText(hwnd,HS_RXFLOW,"Receive Xon/Xoff................");
  WinShowWindow(WinWindowFromID(hwnd,HWF_HDW_RX_XON_HS),TRUE);
  WinSetDlgItemText(hwnd,HS_TXFLOW,"Transmit Xon/Xoff................");
  WinShowWindow(WinWindowFromID(hwnd,HWF_HDW_TX_XON_HS),TRUE);
  if (pstComDCB->wDeviceFlag2 & FIFO_FLG_HDW_RX_XON_HS)
    CheckButton(hwnd,HWF_HDW_RX_XON_HS,TRUE);
  if (pstComDCB->wDeviceFlag2 & FIFO_FLG_HDW_TX_XON_HS)
    CheckButton(hwnd,HWF_HDW_TX_XON_HS,TRUE);
#endif
  sprintf(szXchar,"%02X",pstComDCB->byXoffChar);
  WinSendDlgItemMsg(hwnd,HS_XOFFCHAR,EM_SETTEXTLIMIT,MPFROMSHORT(2),(MPARAM)NULL);
  WinSetDlgItemText(hwnd,HS_XOFFCHAR,szXchar);

  sprintf(szXchar,"%02X",pstComDCB->byXonChar);
  WinSendDlgItemMsg(hwnd,HS_XONCHAR,EM_SETTEXTLIMIT,MPFROMSHORT(2),(MPARAM)NULL);
  WinSetDlgItemText(hwnd,HS_XONCHAR,szXchar);

  if (pstComDCB->wFlags2 & F2_ENABLE_XMIT_XON_XOFF_FLOW)
    {
    CheckButton(hwnd,HS_TXFLOW,TRUE);
    bXHS = TRUE;
    }
 else
   CheckButton(hwnd,HS_TXFLOW,FALSE);

  if (pstComDCB->wFlags2 & F2_ENABLE_FULL_DUPLEX)
    CheckButton(hwnd,HS_FULLDUP,TRUE);
  else
    CheckButton(hwnd,HS_FULLDUP,FALSE);

  if (pstComDCB->wFlags2 & F2_ENABLE_RCV_XON_XOFF_FLOW)
    {
    CheckButton(hwnd,HS_RXFLOW,TRUE);
    bXHS = TRUE;
    ControlEnable(hwnd,HS_FULLDUP,TRUE);
#ifdef allow_16650_HDW_Xon_HS
    if (pstComDCB->wDeviceFlag2 & FIFO_FLG_HDW_RX_XON_HS)
      ControlEnable(hwnd,HS_FULLDUP,FALSE);
#endif
    }
  else
    {
    CheckButton(hwnd,HS_RXFLOW,FALSE);
    ControlEnable(hwnd,HS_FULLDUP,FALSE);
    }

  if (bXHS)
    {
    ControlEnable(hwnd,HS_XOFFCHART,TRUE);
    ControlEnable(hwnd,HS_XONCHART,TRUE);
    ControlEnable(hwnd,HS_XOFFCHAR,TRUE);
    ControlEnable(hwnd,HS_XONCHAR,TRUE);
    ControlEnable(hwnd,HS_XONCHARTT,TRUE);
    ControlEnable(hwnd,HS_XONCHARTTT,TRUE);
    ControlEnable(hwnd,HS_XOFFCHARTT,TRUE);
    ControlEnable(hwnd,HS_XOFFCHARTTT,TRUE);
    }
  else
    {
    ControlEnable(hwnd,HS_XOFFCHART,FALSE);
    ControlEnable(hwnd,HS_XONCHART,FALSE);
    ControlEnable(hwnd,HS_XOFFCHAR,FALSE);
    ControlEnable(hwnd,HS_XONCHAR,FALSE);
    ControlEnable(hwnd,HS_XONCHARTT,FALSE);
    ControlEnable(hwnd,HS_XONCHARTTT,FALSE);
    ControlEnable(hwnd,HS_XOFFCHARTT,FALSE);
    ControlEnable(hwnd,HS_XOFFCHARTTT,FALSE);
    }
  }

void TCASCIIhandshakeDlg(HWND hwnd,USHORT usButtonId)
  {
  switch(usButtonId)
    {
#ifdef allow_16650_HDW_Xon_HS
    case HWF_HDW_RX_XON_HS:
      if (Checked(hwnd,HWF_HDW_RX_XON_HS))
        {
//        CheckButton(hwnd,HWF_HDW_RX_XON_HS,TRUE);
        ControlEnable(hwnd,HS_FULLDUP,FALSE);
        }
      else
        {
//        CheckButton(hwnd,HWF_HDW_RX_XON_HS,FALSE);
        if (Checked(hwnd,HS_RXFLOW))
          ControlEnable(hwnd,HS_FULLDUP,TRUE);
        }
      break;
#endif
    case HS_RXFLOW:
    case HS_TXFLOW:
      if (Checked(hwnd,HS_RXFLOW) || Checked(hwnd,HS_TXFLOW))
        {
        ControlEnable(hwnd,HS_XOFFCHART,TRUE);
        ControlEnable(hwnd,HS_XONCHART,TRUE);
        ControlEnable(hwnd,HS_XOFFCHAR,TRUE);
        ControlEnable(hwnd,HS_XONCHAR,TRUE);
        ControlEnable(hwnd,HS_XONCHARTT,TRUE);
        ControlEnable(hwnd,HS_XONCHARTTT,TRUE);
        ControlEnable(hwnd,HS_XOFFCHARTT,TRUE);
        ControlEnable(hwnd,HS_XOFFCHARTTT,TRUE);
        }
      else
        {
        ControlEnable(hwnd,HS_XOFFCHART,FALSE);
        ControlEnable(hwnd,HS_XONCHART,FALSE);
        ControlEnable(hwnd,HS_XOFFCHAR,FALSE);
        ControlEnable(hwnd,HS_XONCHAR,FALSE);
        ControlEnable(hwnd,HS_XONCHARTT,FALSE);
        ControlEnable(hwnd,HS_XONCHARTTT,FALSE);
        ControlEnable(hwnd,HS_XOFFCHARTT,FALSE);
        ControlEnable(hwnd,HS_XOFFCHARTTT,FALSE);
        }
      if (!Checked(hwnd,HS_RXFLOW))
        ControlEnable(hwnd,HS_FULLDUP,FALSE);
      else
        {
#ifdef allow_16650_HDW_Xon_HS
        if (!Checked(hwnd,HWF_HDW_RX_XON_HS))
#endif
          ControlEnable(hwnd,HS_FULLDUP,TRUE);
        }
      break;
    }
  }

void UnloadASCIIhandshakeDlg(HWND hwnd,COMDCB *pstComDCB)
  {
  char szXchar[5];
  BOOL bXHS = FALSE;

  pstComDCB->wConfigFlags2 &= ~FIFO_FLG_HDW_HS_MASK;
#ifdef allow_16650_HDW_Xon_HS
  if (Checked(hwnd,HWF_HDW_RX_XON_HS))
    pstComDCB->wConfigFlags2 |= FIFO_FLG_HDW_RX_XON_HS;
  if (Checked(hwnd,HWF_HDW_TX_XON_HS))
    pstComDCB->wConfigFlags2 |= FIFO_FLG_HDW_TX_XON_HS;
#endif
  pstComDCB->wFlags2 |= 0x8000;
  if (Checked(hwnd,HS_TXFLOW))
    {
    bXHS = TRUE;
    pstComDCB->wFlags2 |= F2_ENABLE_XMIT_XON_XOFF_FLOW;
    }
  else
    pstComDCB->wFlags2 &= ~F2_ENABLE_XMIT_XON_XOFF_FLOW;

  pstComDCB->wFlags2 &= ~F2_ENABLE_FULL_DUPLEX;
  if (Checked(hwnd,HS_RXFLOW))
    {
    bXHS = TRUE;
    pstComDCB->wFlags2 |= F2_ENABLE_RCV_XON_XOFF_FLOW;
    if (Checked(hwnd,HS_FULLDUP))
#ifdef allow_16650_HDW_Xon_HS
      if ((pstFIFOinfo->wFIFOflags & FIFO_FLG_HDW_RX_XON_HS) == 0);
#endif
        pstComDCB->wFlags2 |= F2_ENABLE_FULL_DUPLEX;
    }
  else
    pstComDCB->wFlags2 &= ~F2_ENABLE_RCV_XON_XOFF_FLOW;

  if (bXHS)
    {
    WinQueryDlgItemText(hwnd,HS_XOFFCHAR,3,szXchar);
    pstComDCB->byXoffChar = (BYTE)ASCIItoBin(szXchar,16);

    WinQueryDlgItemText(hwnd,HS_XONCHAR,3,szXchar);
    pstComDCB->byXonChar = (BYTE)ASCIItoBin(szXchar,16);
    }
  }
