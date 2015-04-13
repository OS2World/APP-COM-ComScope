#include <COMMON.H>
#include <cfg_dlg.h>
#include "ioctl.h"
#include "utility.h"
#include <OS$tools.h>

ULONG const aulStdBaudTable[] = {50,75,110,150,300,600,1200,2400,4800,7200,
                                 9600,14400,19200,28800,38400,57600,115200,0};

ULONG const aulExtBaudTable[] = {50,75,110,150,300,600,1200,2400,4800,7200,
                                 9600,14400,19200,28800,38400,57600,76800,
                                 92160,115200,153600,230400,460800,0};

VOID EXPENTRY FillHdwFilterDlg(HWND hwnd,DCB *pstComDCB)
  {
  char szReplaceChar[5];

  sprintf(szReplaceChar,"%02X",pstComDCB->ErrChar);
  WinSetDlgItemText(hwnd,HWR_ERRCHAR,szReplaceChar);

  sprintf(szReplaceChar,"%02X",pstComDCB->BrkChar);
  WinSetDlgItemText(hwnd,HWR_BRKCHAR,szReplaceChar);

  if (pstComDCB->Flags2 & F2_ENABLE_ERROR_REPL)
    CheckButton(hwnd,HWR_ENABERR,TRUE);
  else
    {
    ControlEnable(hwnd,HWR_ERRTTT,FALSE);
    ControlEnable(hwnd,HWR_ERRTT,FALSE);
    ControlEnable(hwnd,HWR_ERRT,FALSE);
    ControlEnable(hwnd,HWR_ERRCHAR,FALSE);
    }
  if (pstComDCB->Flags2 & F2_ENABLE_NULL_STRIP)
    CheckButton(hwnd,HWR_ENABNUL,TRUE);

  if (pstComDCB->Flags2 & F2_ENABLE_BREAK_REPL)
    CheckButton(hwnd,HWR_ENABBRK,TRUE);
  else
    {
    ControlEnable(hwnd,HWR_BRKTTT,FALSE);
    ControlEnable(hwnd,HWR_BRKTT,FALSE);
    ControlEnable(hwnd,HWR_BRKT,FALSE);
    ControlEnable(hwnd,HWR_BRKCHAR,FALSE);
    }
  }

VOID EXPENTRY UnloadHdwFilterDlg(HWND hwnd,DCB *pstComDCB)
  {
  char szReplaceChar[5];

  WinQueryDlgItemText(hwnd,HWR_ERRCHAR,3,szReplaceChar);
  pstComDCB->ErrChar = (BYTE)ASCIItoBin(szReplaceChar,16);

  WinQueryDlgItemText(hwnd,HWR_BRKCHAR,3,szReplaceChar);
  pstComDCB->BrkChar = (BYTE)ASCIItoBin(szReplaceChar,16);

  if (Checked(hwnd,HWR_ENABERR))
    pstComDCB->Flags2 |= F2_ENABLE_ERROR_REPL;
  else
    pstComDCB->Flags2 &= ~F2_ENABLE_ERROR_REPL;

  if (Checked(hwnd,HWR_ENABBRK))
    pstComDCB->Flags2 |= F2_ENABLE_BREAK_REPL;
  else
    pstComDCB->Flags2 &= ~F2_ENABLE_BREAK_REPL;

  if (Checked(hwnd,HWR_ENABNUL))
    pstComDCB->Flags2 |= F2_ENABLE_NULL_STRIP;
  else
    pstComDCB->Flags2 &= ~F2_ENABLE_NULL_STRIP;
  }

void EXPENTRY FillHdwTimeoutDlg(HWND hwnd,DCB *pstComDCB)
  {
  char szTimeout[8];

  sprintf(szTimeout,"%u",pstComDCB->ReadTimeout);
  WinSetDlgItemText(hwnd,HWT_RTIME,szTimeout);
  WinSendDlgItemMsg(hwnd,HWT_RTIME,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);

  sprintf(szTimeout,"%u",pstComDCB->WrtTimeout);
  WinSendDlgItemMsg(hwnd,HWT_WTIME,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
  WinSetDlgItemText(hwnd,HWT_WTIME,szTimeout);

  if (pstComDCB->Flags3 & F3_INFINITE_WRT_TIMEOUT)
    {
    ControlEnable(hwnd,HWT_WTIMET,FALSE);
    ControlEnable(hwnd,HWT_WTIME,FALSE);
    CheckButton(hwnd,HWT_WINF,TRUE);
    }
  else
    CheckButton(hwnd,HWT_WNORM,TRUE);

  if ((pstComDCB->Flags3 & F3_RTO_MASK) == F3_WAIT_NONE) // first mask significant bits
    {
    ControlEnable(hwnd,HWT_RTIMET,FALSE);
    ControlEnable(hwnd,HWT_RTIME,FALSE);
    CheckButton(hwnd,HWT_RNOWAIT,TRUE);
    }
  else
    {
    if ((pstComDCB->Flags3  & F3_RTO_MASK) == F3_WAIT_SOMETHING)
      CheckButton(hwnd,HWT_RWAITSOME,TRUE);
    else
      CheckButton(hwnd,HWT_RNORM,TRUE);
    }
  }

void EXPENTRY UnloadHdwTimeoutDlg(HWND hwnd,DCB *pstComDCB)
  {
  char szTimeout[9];

  if (Checked(hwnd,HWT_WINF))
    pstComDCB->Flags3 |= F3_INFINITE_WRT_TIMEOUT;
  else
    pstComDCB->Flags3 &= ~F3_INFINITE_WRT_TIMEOUT;

  WinQueryDlgItemText(hwnd,HWT_WTIME,6,szTimeout);
  pstComDCB->WrtTimeout = (WORD)atol(szTimeout);

  pstComDCB->Flags3 &= ~F3_RTO_MASK;
  if (Checked(hwnd,HWT_RNOWAIT))
    pstComDCB->Flags3 |= F3_WAIT_NONE;
  else
    {
    if (Checked(hwnd,HWT_RWAITSOME))
      pstComDCB->Flags3 |= F3_WAIT_SOMETHING;
    else
      pstComDCB->Flags3 |= F3_WAIT_NORM;
    }
  WinQueryDlgItemText(hwnd,HWT_RTIME,6,szTimeout);
  pstComDCB->ReadTimeout = (WORD)atol(szTimeout);
  }

BOOL EXPENTRY TCHdwTimeoutDlg(HWND hwnd,USHORT idButton)
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

VOID EXPENTRY FillHandshakeDlg(HWND hwnd,DCB *pstComDCB,FIFOINF *pstFIFOinfo)
  {
  char szXchar[5];
  WORD idEntryField;
  BOOL bXHS = FALSE;

  if (((pstFIFOinfo->wFIFOsize > 16) || (pstFIFOinfo->wFIFOflags & FIFO_FLG_DEF_HDW_HS)) &&
      ((pstFIFOinfo->wFIFOflags & FIFO_FLG_NO_HDW_HS_SUPPORT) == 0))
    {
    WinSetDlgItemText(hwnd,HS_CTSOUT,"Using CTS................");
    WinShowWindow(WinWindowFromID(hwnd,HWF_HDW_CTS_HS),TRUE);
    WinSetDlgItemText(hwnd,HS_RTSINHS,"Input handshaking................");
    WinShowWindow(WinWindowFromID(hwnd,HWF_HDW_RTS_HS),TRUE);
#ifdef allow_16650_HDW_Xon_HS
    if ((pstFIFOinfo->wFIFOsize < 64) || (pstFIFOinfo->wFIFOflags & FIFO_FLG_DEF_HDW_HS))
      {
      WinSetDlgItemText(hwnd,HS_RXFLOW,"Receive Xon/Xoff................");
      WinShowWindow(WinWindowFromID(hwnd,HWF_HDW_RX_XON_HS),TRUE);
      WinSetDlgItemText(hwnd,HS_TXFLOW,"Transmit Xon/Xoff................");
      WinShowWindow(WinWindowFromID(hwnd,HWF_HDW_TX_XON_HS),TRUE);
      }
#endif
    }
  if ((pstFIFOinfo->wFIFOflags & FIFO_FLG_NO_HDW_HS_SUPPORT) == 0)
    {
    if (pstFIFOinfo->wFIFOflags & FIFO_FLG_HDW_CTS_HS)
      CheckButton(hwnd,HWF_HDW_CTS_HS,TRUE);
    if (pstFIFOinfo->wFIFOflags & FIFO_FLG_HDW_RTS_HS)
      CheckButton(hwnd,HWF_HDW_RTS_HS,TRUE);
#ifdef allow_16650_HDW_Xon_HS
    if (pstFIFOinfo->wFIFOflags & FIFO_FLG_HDW_RX_XON_HS)
      CheckButton(hwnd,HWF_HDW_RX_XON_HS,TRUE);
    if (pstFIFOinfo->wFIFOflags & FIFO_FLG_HDW_TX_XON_HS)
      CheckButton(hwnd,HWF_HDW_TX_XON_HS,TRUE);
#endif
    }
  sprintf(szXchar,"%02X",pstComDCB->XoffChar);
  WinSendDlgItemMsg(hwnd,HS_XOFFCHAR,EM_SETTEXTLIMIT,MPFROMSHORT(3),(MPARAM)NULL);
  WinSetDlgItemText(hwnd,HS_XOFFCHAR,szXchar);

  sprintf(szXchar,"%02X",pstComDCB->XonChar);
  WinSendDlgItemMsg(hwnd,HS_XONCHAR,EM_SETTEXTLIMIT,MPFROMSHORT(3),(MPARAM)NULL);
  WinSetDlgItemText(hwnd,HS_XONCHAR,szXchar);

  if (pstComDCB->Flags2 & F2_ENABLE_XMIT_XON_XOFF_FLOW)
    {
    CheckButton(hwnd,HS_TXFLOW,TRUE);
    bXHS = TRUE;
    }
  if (pstComDCB->Flags2 & F2_ENABLE_RCV_XON_XOFF_FLOW)
    {
    CheckButton(hwnd,HS_RXFLOW,TRUE);
    bXHS = TRUE;
    if (pstComDCB->Flags2 & F2_ENABLE_FULL_DUPLEX)
      CheckButton(hwnd,HS_FULLDUP,TRUE);
#ifdef allow_16650_HDW_Xon_HS
    if (pstFIFOinfo->wFIFOflags & FIFO_FLG_HDW_RX_XON_HS)
      ControlEnable(hwnd,HS_FULLDUP,FALSE);
#endif
    }
  else
    ControlEnable(hwnd,HS_FULLDUP,FALSE);

  if (!bXHS)
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

  switch ((pstComDCB->Flags2 & F2_RTS_MASK) >> 6)
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
  switch (pstComDCB->Flags1 & F1_DTR_MASK)
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
  if (pstComDCB->Flags1 & F1_ENABLE_CTS_OUTPUT_HS)
    CheckButton(hwnd,HS_CTSOUT,TRUE);
  if (pstComDCB->Flags1 & F1_ENABLE_DSR_OUTPUT_HS)
    CheckButton(hwnd,HS_DSROUT,TRUE);
  if (pstComDCB->Flags1 & F1_ENABLE_DCD_OUTPUT_HS)
    CheckButton(hwnd,HS_DCDOUT,TRUE);
  if (pstComDCB->Flags1 & F1_ENABLE_DSR_INPUT_HS)
    CheckButton(hwnd,HS_DSRINSENSE,TRUE);

  }

BOOL EXPENTRY TCHandshakeDlg(HWND hwnd,USHORT idButton)
  {
  switch(idButton)
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
      if (Checked(hwnd,HS_RXFLOW) ||
          Checked(hwnd,HS_TXFLOW))
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
    default:
      return(FALSE);
    }
  return(TRUE);
  }

VOID EXPENTRY UnloadHandshakeDlg(HWND hwnd,DCB *pstComDCB,FIFOINF *pstFIFOinfo)
  {
  char szXchar[5];
  BOOL bXHS = FALSE;

  pstFIFOinfo->wFIFOflags &= ~FIFO_FLG_HDW_HS_MASK;
  if ((pstFIFOinfo->wFIFOflags & FIFO_FLG_NO_HDW_HS_SUPPORT) == 0)
    {
    if (Checked(hwnd,HWF_HDW_CTS_HS))
      pstFIFOinfo->wFIFOflags |= FIFO_FLG_HDW_CTS_HS;
    if (Checked(hwnd,HWF_HDW_RTS_HS))
      pstFIFOinfo->wFIFOflags |= FIFO_FLG_HDW_RTS_HS;
#ifdef allow_16650_HDW_Xon_HS
    if (Checked(hwnd,HWF_HDW_RX_XON_HS))
      pstFIFOinfo->wFIFOflags |= FIFO_FLG_HDW_RX_XON_HS;
    if (Checked(hwnd,HWF_HDW_TX_XON_HS))
      pstFIFOinfo->wFIFOflags |= FIFO_FLG_HDW_TX_XON_HS;
#endif
    }
  if (Checked(hwnd,HS_TXFLOW))
    {
    bXHS = TRUE;
    pstComDCB->Flags2 |= F2_ENABLE_XMIT_XON_XOFF_FLOW;
    }
  else
    pstComDCB->Flags2 &= ~F2_ENABLE_XMIT_XON_XOFF_FLOW;

  pstComDCB->Flags2 &= ~F2_ENABLE_FULL_DUPLEX;
  if (Checked(hwnd,HS_RXFLOW))
    {
    bXHS = TRUE;
    pstComDCB->Flags2 |= F2_ENABLE_RCV_XON_XOFF_FLOW;
    if (Checked(hwnd,HS_FULLDUP))
#ifdef allow_16650_HDW_Xon_HS
      if ((pstFIFOinfo->wFIFOflags & FIFO_FLG_HDW_RX_XON_HS) == 0);
#endif
        pstComDCB->Flags2 |= F2_ENABLE_FULL_DUPLEX;
    }
  else
    pstComDCB->Flags2 &= ~F2_ENABLE_RCV_XON_XOFF_FLOW;

  if (bXHS)
    {
    WinQueryDlgItemText(hwnd,HS_XOFFCHAR,3,szXchar);
    pstComDCB->XoffChar = (BYTE)ASCIItoBin(szXchar,16);

    WinQueryDlgItemText(hwnd,HS_XONCHAR,3,szXchar);
    pstComDCB->XonChar = (BYTE)ASCIItoBin(szXchar,16);
    }

  pstComDCB->Flags2 &= ~F2_RTS_MASK;
  if (Checked(hwnd,HS_RTSENAB))
    pstComDCB->Flags2 |= F2_ENABLE_RTS;
  else
    if (Checked(hwnd,HS_RTSINHS))
      pstComDCB->Flags2 |= F2_ENABLE_RTS_INPUT_HS;
    else
      if (Checked(hwnd,HS_RTSTOG))
        pstComDCB->Flags2 |= F2_ENABLE_RTS_TOG_ON_XMIT;

  pstComDCB->Flags1 &= ~F1_DTR_MASK;
  if (Checked(hwnd,HS_DTRENAB))
    pstComDCB->Flags1 |= F1_ENABLE_DTR;
  else
    if (Checked(hwnd,HS_DTRINHS))
      pstComDCB->Flags1 |= F1_ENABLE_DTR_INPUT_HS;

  if (Checked(hwnd,HS_CTSOUT))
    pstComDCB->Flags1 |= F1_ENABLE_CTS_OUTPUT_HS;
  else
    pstComDCB->Flags1 &= ~F1_ENABLE_CTS_OUTPUT_HS;

  if (Checked(hwnd,HS_DSROUT))
    pstComDCB->Flags1 |= F1_ENABLE_DSR_OUTPUT_HS;
  else
    pstComDCB->Flags1 &= ~F1_ENABLE_DSR_OUTPUT_HS;

  if (Checked(hwnd,HS_DCDOUT))
    pstComDCB->Flags1 |= F1_ENABLE_DCD_OUTPUT_HS;
  else
    pstComDCB->Flags1 &= ~F1_ENABLE_DCD_OUTPUT_HS;

  if (Checked(hwnd,HS_DSRINSENSE))
    pstComDCB->Flags1 |= F1_ENABLE_DSR_INPUT_HS;
  else
    pstComDCB->Flags1 &= ~F1_ENABLE_DSR_INPUT_HS;

  }

VOID EXPENTRY FillHdwProtocolDlg(HWND hwnd,LINECHAR *pstLineChar)
  {
  WORD idDisableField;
  WORD idEntryField;

  idDisableField = HWP_15BITS;
  switch (pstLineChar->DataBits)
    {
    case 8:
      idEntryField = HWP_8BITS;
      break;
    case 7:
      idEntryField = HWP_7BITS;
      break;
    case 6:
      idEntryField = HWP_6BITS;
      break;
    case 5:
      idEntryField = HWP_5BITS;
      idDisableField = HWP_2BITS;
      break;
    }
  CheckButton(hwnd,idEntryField,TRUE);
  ControlEnable(hwnd,idDisableField,FALSE);
  switch (pstLineChar->StopBits)
    {
    case 0:
      idEntryField = HWP_1BIT;
      break;
    case 1:
      idEntryField = HWP_15BITS;
      break;
    case 2:
      idEntryField = HWP_2BITS;
      break;
    }
  CheckButton(hwnd,idEntryField,TRUE);
  switch (pstLineChar->Parity)
    {
    case 0:
      idEntryField = HWP_NONE;
      break;
    case 1:
      idEntryField = HWP_ODD;
      break;
    case 2:
      idEntryField = HWP_EVEN;
      break;
    case 3:
      idEntryField = HWP_ZERO;
      break;
    case 4:
      idEntryField = HWP_ONE;
      break;
    }
  CheckButton(hwnd,idEntryField,TRUE);
  }

VOID EXPENTRY UnloadHdwProtocolDlg(HWND hwnd,LINECHAR *pstLineChar)
  {
  if (Checked(hwnd,HWP_8BITS))
    pstLineChar->DataBits = 8;
  else
    if (Checked(hwnd,HWP_7BITS))
      pstLineChar->DataBits = 7;
    else
      if (Checked(hwnd,HWP_6BITS))
        pstLineChar->DataBits = 6;
      else
        if (Checked(hwnd,HWP_5BITS))
          pstLineChar->DataBits = 5;

  if (Checked(hwnd,HWP_1BIT))
    pstLineChar->StopBits = 0;
  else
    if (Checked(hwnd,HWP_15BITS))
      pstLineChar->StopBits = 1;
    else
      if (Checked(hwnd,HWP_2BITS))
        pstLineChar->StopBits = 2;

  if (Checked(hwnd,HWP_NONE))
    pstLineChar->Parity = 0;
  else
    if (Checked(hwnd,HWP_ODD))
      pstLineChar->Parity = 1;
    else
      if (Checked(hwnd,HWP_EVEN))
        pstLineChar->Parity = 2;
      else
        if (Checked(hwnd,HWP_ZERO))
          pstLineChar->Parity = 3;
        else
          if (Checked(hwnd,HWP_ONE))
            pstLineChar->Parity = 4;
  }

BOOL EXPENTRY TCHdwProtocolDlg(HWND hwnd,USHORT idButton)
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

BOOL EXPENTRY FillHdwFIFOsetupDlg(HWND hwnd,BYTE byFlags,FIFOINF *pstFIFOinfo)
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
  if ((byFlags & F3_HDW_BUFFER_APO) != 0)
    {
    switch ((byFlags & F3_HDW_BUFFER_APO) >> 3)
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
      switch ((byFlags & F3_14_CHARACTER_FIFO) >> 5)
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
      switch ((byFlags & F3_14_CHARACTER_FIFO) >> 5)
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
    if ((byFlags & F3_USE_TX_BUFFER) == 0)
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
  if ((byFlags & F3_HDW_BUFFER_ENABLE) != F3_HDW_BUFFER_ENABLE)
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
  return(TRUE);
  }

BOOL EXPENTRY UnloadHdwFIFOsetupDlg(HWND hwnd,DCB *pstComDCB,FIFOINF *pstFIFOinfo)
  {
  LONG lTemp;
#ifdef this_junk
  BOOL bInputHdw = FALSE;
  BOOL bOutputHdw = FALSE;
#endif
  pstComDCB->Flags3 &= ~F3_FIFO_MASK;
  if (Checked(hwnd,HWF_DISABFIFO))
    pstComDCB->Flags3 |= F3_HDW_BUFFER_DISABLE;
  else
    {
    if (Checked(hwnd,HWF_ENABFIFO))
      pstComDCB->Flags3 |= F3_HDW_BUFFER_ENABLE;
    else
      pstComDCB->Flags3 |= F3_HDW_BUFFER_APO;

#ifdef this_junk
    pstFIFOinfo->wFIFOflags = 0;
    if (pstFIFOinfo->wFIFOsize > 16)
      {
      if (Checked(hwnd,HWF_HDW_CTS_HS))
        {
        pstFIFOinfo->wFIFOflags |= FIFO_FLG_HDW_CTS_HS;
        bOutputHdw = TRUE;
        }
      if (Checked(hwnd,HWF_HDW_RTS_HS))
        {
        pstFIFOinfo->wFIFOflags |= FIFO_FLG_HDW_RTS_HS;
        }
      if (pstFIFOinfo->wFIFOsize == 32)
        {
        if (Checked(hwnd,HWF_HDW_RX_XON_HS))
          {
          pstFIFOinfo->wFIFOflags |= FIFO_FLG_HDW_RX_XON_HS;
          bInputHdw = TRUE;
          }
        if (Checked(hwnd,HWF_HDW_TX_XON_HS))
          {
          pstFIFOinfo->wFIFOflags |= FIFO_FLG_HDW_TX_XON_HS;
          bOutputHdw = TRUE;
          }
        }
      }
#else
    pstFIFOinfo->wFIFOflags &= ~FIFO_FLG_LOW_16750_TRIG;
#endif
    pstComDCB->Flags3 |= F3_USE_TX_BUFFER;
    WinSendDlgItemMsg(hwnd,
                      HWF_TXFIFO_LOAD,
                      SPBM_QUERYVALUE,
                      &lTemp,
                      MPFROM2SHORT(0,SPBQ_DONOTUPDATE));

    pstFIFOinfo->wTxFIFOload = (USHORT)lTemp;

    if (pstFIFOinfo->wTxFIFOload == 1)
      pstComDCB->Flags3 &= ~F3_USE_TX_BUFFER;

    pstComDCB->Flags3 &= ~F3_14_CHARACTER_FIFO;
    if (!Checked(hwnd,HWF_1TRIG))
      {
      if (Checked(hwnd,HWF_16TRIG))
        pstComDCB->Flags3 |= F3_8_CHARACTER_FIFO;
      else
        if (Checked(hwnd,HWF_32TRIG))
          pstComDCB->Flags3 |= F3_4_CHARACTER_FIFO;
        else
          if (Checked(hwnd,HWF_56TRIG))
            pstComDCB->Flags3 |= F3_14_CHARACTER_FIFO;
          else
            {
            if (pstFIFOinfo->wFIFOsize > 32)
              pstFIFOinfo->wFIFOflags |= FIFO_FLG_LOW_16750_TRIG;
            if (Checked(hwnd,HWF_4TRIG))
              pstComDCB->Flags3 |= F3_4_CHARACTER_FIFO;
            else
              if (Checked(hwnd,HWF_8TRIG))
                pstComDCB->Flags3 |= F3_8_CHARACTER_FIFO;
              else
                if (Checked(hwnd,HWF_14TRIG))
                  pstComDCB->Flags3 |= F3_14_CHARACTER_FIFO;
            }
      }
    }
  return(TRUE);
  }

BOOL EXPENTRY TCHdwFIFOsetupDlg(HWND hwnd,USHORT idButton,FIFOINF *pstFIFOinfo)
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


