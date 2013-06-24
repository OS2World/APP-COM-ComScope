#include "COMMON.H"
#include "COMDD.H"
#include "ioctl.h"
#include "utility.h"
#include "help.h"

#include "COMi_CFG.H"
#include "resource.h"

void InitReadBufferSize(HWND hwndDlg,ULONG ulBuffLen,int iResDevider);
void InitWriteBufferSize(HWND hwndDlg,ULONG ulBuffLen,int iResDevider);
void InitCOMscopeBufferSize(HWND hwndDlg,ULONG ulBuffLen,int iResDevider);

extern HWND hwndNoteBookDlg;
extern LONG lXonHysteresis;
extern LONG lXoffThreshold;
extern LONG lOrgXonHysteresis;
extern LONG lOrgXoffThreshold;
extern ULONG ulReadBuffLen;
extern ULONG ulOrgReadBuffLen;
extern BOOL bInsertNewDevice;
extern LONG lYScr;

MRESULT EXPENTRY fnwpReceiveBuffDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  ULONG ulTemp;
  char acBuffer[15];
  static NBKPAGECTL *pstPage;
  static COMDCB *pstComDCB;
  LONG lTemp;
  static int iResDevider = 1;
  static BOOL bNotFirst;

  switch (msg)
    {
    case WM_INITDLG:
      if (lYScr < 768)
        iResDevider = 2;
      if (!bInsertNewDevice)
        WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
//        ControlEnable(hwndDlg,DID_INSERT,FALSE);
//      CenterDlgBox(hwndDlg);
//      WinSetFocus(HWND_DESKTOP,hwndDlg);
      pstPage = PVOIDFROMMP(mp2);
      pstComDCB = (COMDCB *)pstPage->pVoidPtrOne;
//      pstPage->bDirtyBit = FALSE;
      bNotFirst = FALSE;
//      lXonHysteresis = (pstComDCB->wReadBufferLength - pstComDCB->wXonThreshold - pstComDCB->wXoffThreshold);
//      WinSetDlgItemText(hwndDlg,PCFG_BUFF_NAME,"~Receive buffer");
      WinSetDlgItemText(hwndDlg,PCFG_BUFF_NAME,"Receive buffer");
      WinSetDlgItemText(hwndDlg,ST_TITLE,"Receive Buffer Length Configuration");
      InitReadBufferSize(hwndDlg,ulReadBuffLen,iResDevider);
      return (MRESULT) TRUE;
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
        case DID_UNDO:
          pstPage->bDirtyBit = FALSE;
          ulReadBuffLen = ulOrgReadBuffLen;
          WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSLIDERINFO,
                            MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_RANGEVALUE),MPFROMSHORT((ulReadBuffLen / 256) - 4));
          WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,
                           ltoa(ulReadBuffLen,acBuffer,10));
          return(FALSE);
        }
      break;
    case UM_SET_FOCUS:
      WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
      break;
    case UM_SAVE_DATA:
       pstComDCB->wReadBufferLength = ulReadBuffLen;
       return((MRESULT)TRUE);
    case WM_CONTROL:
      switch (SHORT2FROMMP(mp1))
        {
        case SLN_SLIDERTRACK:
        case SLN_CHANGE:
          if (bNotFirst)
            pstPage->bDirtyBit = TRUE;
          else
            bNotFirst = TRUE;
          ulTemp = (ULONG)WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
                                            SLM_QUERYSLIDERINFO,
                                            MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_INCREMENTVALUE),
                                            NULL);
          ulReadBuffLen = ((ulTemp * 256 * iResDevider) + MIN_READ_BUFF_LEN);
          WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,ltoa(ulReadBuffLen,acBuffer,10));
          if (SHORT2FROMMP(mp1) != SLN_CHANGE)
            break;
          if (ulReadBuffLen >= MAX_READ_BUFF_LEN)
            ulReadBuffLen = (USHORT)0xffff;
          if (lXoffThreshold != 0)
            if ((lXonHysteresis + lXoffThreshold) >= ulReadBuffLen)
              if (lXonHysteresis > lXoffThreshold)
                {
                lTemp = (lXonHysteresis / lXoffThreshold);
                if (lTemp <= 0)
                  lTemp = 1;
                while ((lXonHysteresis + lXoffThreshold) >= ulReadBuffLen)
                  {
                  lXonHysteresis -= lTemp;
                  lXoffThreshold--;
                  }
                }
              else
                {
                lTemp = (lXoffThreshold / lXonHysteresis);
                if (lTemp <= 0)
                  lTemp = 1;
                while ((lXonHysteresis + lXoffThreshold) >= ulReadBuffLen)
                  {
                  lXonHysteresis--;
                  lXoffThreshold -= lTemp;
                  }
                }
          break;
        }
      return (MRESULT) TRUE;
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }

MRESULT EXPENTRY fnwpTransmitBuffDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  ULONG ulTemp;
  char acBuffer[15];
  static ULONG ulBuffLen;
  static ULONG ulOrgBufLen;
  static NBKPAGECTL *pstPage;
  USHORT *pusLen;
  static int iResDevider = 1;
  static BOOL bNotFirst;

  switch (msg)
    {
    case WM_INITDLG:
      if (lYScr < 768)
        iResDevider = 2;
      if (!bInsertNewDevice)
        WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
//        ControlEnable(hwndDlg,DID_INSERT,FALSE);
//      CenterDlgBox(hwndDlg);
//      WinSetFocus(HWND_DESKTOP,hwndDlg);
      pstPage = PVOIDFROMMP(mp2);
//      pstPage->bDirtyBit = FALSE;
      bNotFirst = FALSE;
      ulBuffLen = *(USHORT *)pstPage->pVoidPtrOne;
      if (ulBuffLen == 0)
        ulBuffLen = DEF_WRITE_BUFF_LEN;
      ulOrgBufLen = ulBuffLen;
//      WinSetDlgItemText(hwndDlg,PCFG_BUFF_NAME,"~Transmit buffer");
      WinSetDlgItemText(hwndDlg,PCFG_BUFF_NAME,"Transmit buffer");
      WinSetDlgItemText(hwndDlg,ST_TITLE,"Transmit Buffer Length Configuration");
      InitWriteBufferSize(hwndDlg,ulBuffLen,iResDevider);
      return (MRESULT) TRUE;
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
           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
        case DID_UNDO:
          pstPage->bDirtyBit = FALSE;
          ulBuffLen = ulOrgBufLen;
          WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSLIDERINFO,
                            MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_RANGEVALUE),MPFROMSHORT((ulBuffLen / 32) - 4));
          WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,
                           ltoa(ulBuffLen,acBuffer,10));
          return(FALSE);
        }
      break;
    case WM_CONTROL:
      if (SHORT2FROMMP(mp1) & (SLN_SLIDERTRACK | SLN_CHANGE))
        {
        if (bNotFirst)
          pstPage->bDirtyBit = TRUE;
        else
          bNotFirst = TRUE;
        ulTemp = (ULONG)WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
                                          SLM_QUERYSLIDERINFO,
                                          MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_INCREMENTVALUE),
                                          NULL);
        ulBuffLen = ((ulTemp * 32 * iResDevider) + MIN_WRITE_BUFF_LEN);
        WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,ltoa(ulBuffLen,acBuffer,10));
        }
      return((MRESULT)TRUE);
    case UM_SAVE_DATA:
      pusLen = pstPage->pVoidPtrOne;
      *pusLen = (USHORT)ulBuffLen;
      return (MRESULT) TRUE;
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }

MRESULT EXPENTRY fnwpCOMscopeBuffDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  ULONG ulTemp;
  char acBuffer[15];
  static ULONG ulOrgBuffLen;
  static ULONG ulBuffLen;
  USHORT *pusLen;
  static NBKPAGECTL *pstPage;
  static int iResDevider = 1;
  static BOOL bNotFirst;

  switch (msg)
    {
    case WM_INITDLG:
      if (lYScr < 768)
        iResDevider = 2;
      if (!bInsertNewDevice)
        WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
//        ControlEnable(hwndDlg,DID_INSERT,FALSE);
//      CenterDlgBox(hwndDlg);
//      WinSetFocus(HWND_DESKTOP,hwndDlg);
      pstPage = PVOIDFROMMP(mp2);
//      pstPage->bDirtyBit = FALSE;
      bNotFirst = FALSE;
      ulBuffLen = *(USHORT *)pstPage->pVoidPtrOne;
      if (ulBuffLen == 0)
        ulBuffLen = DEF_COMscope_BUFF_LEN;
      ulOrgBuffLen = ulBuffLen;
//      WinSetDlgItemText(hwndDlg,PCFG_BUFF_NAME,"~COMscope buffer");
      WinSetDlgItemText(hwndDlg,PCFG_BUFF_NAME,"COMscope buffer");
      WinSetDlgItemText(hwndDlg,ST_TITLE,"COMscope Capture Buffer Length Configuration");
      WinSetDlgItemText(hwndDlg,ST_DEVICEINTERFACECONFIGURATION,"element");
      InitCOMscopeBufferSize(hwndDlg,ulBuffLen,iResDevider);
      return (MRESULT) TRUE;
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
        case DID_UNDO:
          if (pstPage->bDirtyBit)
            {
            pstPage->bDirtyBit = FALSE;
            ulBuffLen = ulOrgBuffLen;
            WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSLIDERINFO,
                              MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_RANGEVALUE),MPFROMSHORT((ulBuffLen / 128) - 8));
            WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,
                             ltoa(ulBuffLen,acBuffer,10));
            }
          return(FALSE);
        }
      break;
    case UM_SET_FOCUS:
      WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
      break;
    case WM_CONTROL:
      if (SHORT2FROMMP(mp1) & (SLN_SLIDERTRACK | SLN_CHANGE))
        {
        if (bNotFirst)
          pstPage->bDirtyBit = TRUE;
        else
          bNotFirst = TRUE;
        ulTemp = (ULONG)WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
                                          SLM_QUERYSLIDERINFO,
                                          MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_INCREMENTVALUE),
                                          NULL);
        ulBuffLen = ((ulTemp * 128 * iResDevider) + MIN_COMscope_BUFF_LEN);
        WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,ltoa(ulBuffLen,acBuffer,10));
        }
      return((MRESULT)TRUE);
    case UM_SAVE_DATA:
      pusLen = pstPage->pVoidPtrOne;
      *pusLen = (USHORT)ulBuffLen;
      return (MRESULT) TRUE;
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }

void InitReadBufferSize(HWND hwndDlg,ULONG ulBuffLen,int iResDevider)
  {
  USHORT  usCount;
  SLDCDATA  SliderData;
  WNDPARAMS wprm;
  CHAR   acBuffer[10];
  int iExtent = 253;

  if (iResDevider == 2)
    iExtent = 127;
  SliderData.cbSize = sizeof(SLDCDATA);
  SliderData.usScale1Increments = iExtent;
  SliderData.usScale1Spacing = 1;
  SliderData.usScale2Increments = iExtent;
  SliderData.usScale2Spacing = 1;

  wprm.fsStatus = WPM_CTLDATA;
  wprm.cchText = 0;
  wprm.cbPresParams = 0;
  wprm.cbCtlData = 0;
  wprm.pCtlData = &SliderData;
  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
                    WM_SETWINDOWPARAMS,(MPARAM)&wprm,(MPARAM)NULL ) ;

  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSLIDERINFO,
                    MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_RANGEVALUE),MPFROMSHORT((ulBuffLen / 256 / iResDevider) - (4 / iResDevider)));

  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
                    SLM_SETTICKSIZE,MPFROM2SHORT(0,5),NULL);
  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
                    MPFROMSHORT(0), MPFROMP("1K"));
  for (usCount = 1; usCount < 4; usCount++ )
    {
    WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
                      SLM_SETTICKSIZE,MPFROM2SHORT(((usCount * 64 / iResDevider) - (4 / iResDevider)),5),NULL);
    sprintf(acBuffer,"%uK",(usCount * 16));
    WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
                      MPFROMSHORT(((usCount * 64 / iResDevider) - (4 / iResDevider))), MPFROMP(acBuffer));
    }
  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
                    SLM_SETTICKSIZE,MPFROM2SHORT((iExtent - 1),5),NULL);
  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
                    MPFROMSHORT(iExtent - 1), MPFROMP("64K"));

  WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,
                    ltoa(ulBuffLen,acBuffer,10));
  }

void InitWriteBufferSize(HWND hwndDlg,ULONG ulBuffLen,int iResDevider)
  {
  USHORT  usCount;
  SLDCDATA  SliderData;
  WNDPARAMS wprm;
  CHAR   acBuffer[10];
  int iExtent = 253;

  if (iResDevider == 2)
    iExtent = 127;
  SliderData.cbSize = sizeof(SLDCDATA);
  SliderData.usScale1Increments = iExtent;
  SliderData.usScale1Spacing = 1;
  SliderData.usScale2Increments = iExtent;
  SliderData.usScale2Spacing = 1;

  wprm.fsStatus = WPM_CTLDATA;
  wprm.cchText = 0;
  wprm.cbPresParams = 0;
  wprm.cbCtlData = 0;
  wprm.pCtlData = &SliderData;
  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
                    WM_SETWINDOWPARAMS,(MPARAM)&wprm,(MPARAM)NULL ) ;

  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSLIDERINFO,
                    MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_RANGEVALUE),MPFROMSHORT((ulBuffLen / 32 / iResDevider) - (4 / iResDevider)));

  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
                    SLM_SETTICKSIZE,MPFROM2SHORT(0,5),NULL);
  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
                    MPFROMSHORT(0), MPFROMP("128"));
  for (usCount = 1; usCount < 4; usCount++ )
    {
    WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
                      SLM_SETTICKSIZE,MPFROM2SHORT(((usCount * 64 / iResDevider) - (4 / iResDevider)),5),NULL);
    sprintf(acBuffer,"%uK",(usCount * 2));
    WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
                      MPFROMSHORT(((usCount * 64 / iResDevider) - (4 / iResDevider))), MPFROMP(acBuffer));
    }
  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
                    SLM_SETTICKSIZE,MPFROM2SHORT((iExtent - 1),5),NULL);
  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
                    MPFROMSHORT(iExtent - 1), MPFROMP("8K"));

  WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,
                    ltoa(ulBuffLen,acBuffer,10));
  }

void InitCOMscopeBufferSize(HWND hwndDlg,ULONG ulBuffLen,int iResDevider)
  {
  USHORT  usCount;
  SLDCDATA  SliderData;
  WNDPARAMS wprm;
  CHAR   acBuffer[10];
  int iExtent = 249;

  if (iResDevider == 2)
    iExtent = 125;
  SliderData.cbSize = sizeof(SLDCDATA);
  SliderData.usScale1Increments = iExtent;
  SliderData.usScale1Spacing = 1;
  SliderData.usScale2Increments = iExtent; // 249
  SliderData.usScale2Spacing = 1;

  wprm.fsStatus = WPM_CTLDATA;
  wprm.cchText = 0;
  wprm.cbPresParams = 0;
  wprm.cbCtlData = 0;
  wprm.pCtlData = &SliderData;
  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
                    WM_SETWINDOWPARAMS,(MPARAM)&wprm,(MPARAM)NULL ) ;

  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSLIDERINFO,
                    MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_RANGEVALUE),MPFROMSHORT((ulBuffLen / 128 / iResDevider) - (8 / iResDevider)));

  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
                    SLM_SETTICKSIZE,MPFROM2SHORT(0,5),NULL);
  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
                    MPFROMSHORT(0), MPFROMP("1k"));
  for (usCount = 1; usCount < 4; usCount++ )
    {
    WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
                      SLM_SETTICKSIZE,MPFROM2SHORT(((usCount * 64 / iResDevider) - (8 / iResDevider)),5),NULL);
    sprintf(acBuffer,"%uK",(usCount * 8));
    WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
                      MPFROMSHORT(((usCount * 64 / iResDevider) - (8 / iResDevider))), MPFROMP(acBuffer));
    }
  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
                    SLM_SETTICKSIZE,MPFROM2SHORT((iExtent - 1),5),NULL);
  WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
                    MPFROMSHORT(iExtent - 1), MPFROMP("32K"));

  WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,
                    ltoa(ulBuffLen,acBuffer,10));
  }

