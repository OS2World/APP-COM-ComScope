#include "COMscope.h"

#include "remote.h"

extern PRF_SAVESTR pfnSaveProfileString;

//extern COMICFG stCOMiCFG;

MRESULT EXPENTRY COMscopeOpenFilterProc(HWND hwnd,ULONG message,MPARAM mp1,MPARAM mp2);

MRESULT EXPENTRY fnwpSetColorDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
BOOL TCColorDlg(HWND hwndDlg,HWND hwndSample,USHORT idButton,LONG *plForegrndColor,LONG *plBackgrndColor);
VOID FillSetColorDlg(HWND hwnd,LONG lForeground,LONG lBackground);

extern HAB habAnchorBlock;
extern HWND hwndFrame;
extern HWND hwndClient;

extern DCBHEAD stTempDCBheader;

extern HPROF hProfileInstance;
extern char szEntryCaptureFileSpec[];
extern char szCaptureFileSpec[];
extern char szCaptureFileName[];
extern char szCOMscopeAppName[];
extern char szCOMscopeProFile[];

extern CHARCELL stCell;
extern ULONG ulCalcSleepCount;
extern ULONG ulMonitorSleepCount;
extern ULONG ulCOMscopeBufferSize;

extern BOOL bStopMonitorThread;
extern BOOL bStopDisplayThread;
extern BOOL bBufferWrapped;
extern LONG lWriteIndex;
extern WORD *pwCaptureBuffer;
extern WORD *pwScrollBuffer;
extern HEV hevWaitCOMiDataSem;
extern char szTitle[80];
extern BOOL bPortNotActive;
extern BOOL bDriverNotLoaded;
//extern DCBPOS stDeviceCount;

extern SCREEN stRead;
extern SCREEN stWrite;
extern SCREEN stRow;
extern CSCFG stCFG;

extern USHORT swSearchString[];
extern LONG lSearchStrLen;

extern BOOL bCOMscopeEnabled;
extern char szCurrentPortName[20];

extern IOCTLINST stIOctl;

extern PIPEMSG stPipeMsg;
extern PIPECMD stPipeCmd;
extern BOOL bStopRemotePipe;

extern char szCOMscopePipe[];

typedef struct
  {
  LONG lColor;
  LONG lContrastColor;
  USHORT usContrastID;
  }CLRCON;

static CLRCON astBackgrndContrastTable[16] =  {{CLR_RED       ,CLR_WHITE,CLR_BWHITE},
                                               {CLR_DARKRED   ,CLR_WHITE,CLR_BWHITE},
                                               {CLR_GREEN     ,CLR_BLACK,CLR_BBLACK},
                                               {CLR_DARKGREEN ,CLR_WHITE,CLR_BWHITE},
                                               {CLR_PINK      ,CLR_WHITE,CLR_BWHITE},
                                               {CLR_DARKPINK  ,CLR_WHITE,CLR_BWHITE},
                                               {CLR_BLUE      ,CLR_WHITE,CLR_BWHITE},
                                               {CLR_DARKBLUE  ,CLR_WHITE,CLR_BWHITE},
                                               {CLR_YELLOW    ,CLR_BLACK,CLR_BBLACK},
                                               {CLR_BROWN     ,CLR_WHITE,CLR_BWHITE},
                                               {CLR_PALEGRAY  ,CLR_BLACK,CLR_BBLACK},
                                               {CLR_DARKGRAY  ,CLR_WHITE,CLR_BWHITE},
                                               {CLR_WHITE     ,CLR_BLACK,CLR_BBLACK},
                                               {CLR_BLACK     ,CLR_WHITE,CLR_BWHITE},
                                               {CLR_CYAN      ,CLR_BLACK,CLR_BBLACK},
                                               {CLR_DARKCYAN  ,CLR_WHITE,CLR_BWHITE}};

static CLRCON astForegrndContrastTable[16] =  {{CLR_RED       ,CLR_BLACK,CLR_FBLACK},
                                               {CLR_DARKRED   ,CLR_WHITE,CLR_FWHITE},
                                               {CLR_GREEN     ,CLR_BLACK,CLR_FBLACK},
                                               {CLR_DARKGREEN ,CLR_WHITE,CLR_FWHITE},
                                               {CLR_PINK      ,CLR_BLACK,CLR_FBLACK},
                                               {CLR_DARKPINK  ,CLR_WHITE,CLR_FWHITE},
                                               {CLR_BLUE      ,CLR_WHITE,CLR_FWHITE},
                                               {CLR_DARKBLUE  ,CLR_WHITE,CLR_FWHITE},
                                               {CLR_YELLOW    ,CLR_BLACK,CLR_FBLACK},
                                               {CLR_BROWN     ,CLR_WHITE,CLR_FWHITE},
                                               {CLR_PALEGRAY  ,CLR_BLACK,CLR_FBLACK},
                                               {CLR_DARKGRAY  ,CLR_WHITE,CLR_FWHITE},
                                               {CLR_WHITE     ,CLR_BLACK,CLR_FBLACK},
                                               {CLR_BLACK     ,CLR_WHITE,CLR_FWHITE},
                                               {CLR_CYAN      ,CLR_BLACK,CLR_FBLACK},
                                               {CLR_DARKCYAN  ,CLR_WHITE,CLR_FWHITE}};

USHORT FindContrastingColor(CLRCON astContrastTable[],LONG *plColor)
  {
  int iIndex;

  for (iIndex = 0;iIndex < 16;iIndex++)
    {
    if (astBackgrndContrastTable[iIndex].lColor == *plColor)
      {
      *plColor = astContrastTable[iIndex].lContrastColor;
      return(astContrastTable[iIndex].usContrastID);
      }
    }
  return(0);
  }

void  EnableFilters(HWND hwndDlg,BOOL bEnable)
  {
  ControlEnable(hwndDlg,DISP_PUNCT,bEnable);
  ControlEnable(hwndDlg,DISP_ALPHA,bEnable);
  ControlEnable(hwndDlg,DISP_NUMS,bEnable);
  ControlEnable(hwndDlg,DISP_NPRINT,bEnable);
  ControlEnable(hwndDlg,DISP_FILTERT,bEnable);
  ControlEnable(hwndDlg,DISP_CHAR_MASK,bEnable);
  ControlEnable(hwndDlg,DISP_CHAR_MASKT,bEnable);
  ControlEnable(hwndDlg,DISP_CHAR_MASKTTT,bEnable);
  ControlEnable(hwndDlg,DISP_CHAR_MASKTT,bEnable);
  }

void EnableNewLine(HWND hwndDlg,BOOL bEnable)
  {
  ControlEnable(hwndDlg,DISP_SKP,bEnable);
  ControlEnable(hwndDlg,DISP_NLT,bEnable);
  ControlEnable(hwndDlg,DISP_NLTT,bEnable);
  ControlEnable(hwndDlg,DISP_NLTTT,bEnable);
  ControlEnable(hwndDlg,DISP_NL_CHAR,bEnable);
  ControlEnable(hwndDlg,DISP_WRAP,bEnable);
  ControlEnable(hwndDlg,DISP_SYNC,bEnable);
  }

MRESULT EXPENTRY fnwpBufferSizeDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  LONG lLength;
  char szString[20];
  static CSCFG *pstCFG;
  static CSCFG stCFGtemp;
//  PFN pfnProcess;
  HMODULE hMod;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwnd);
      WinSetFocus(HWND_DESKTOP,hwnd);
      pstCFG = PVOIDFROMMP(mp2);
      memcpy(&stCFGtemp,pstCFG,sizeof(CSCFG));
      for (lLength = MIN_CAP_BUFF_LEN;lLength <= MAX_CAP_BUFF_LEN;lLength *= 2)
        {
        sprintf(szString,"%-ld",lLength);
        WinSendDlgItemMsg(hwnd,BSZ_LENGTH,LM_INSERTITEM,MPFROM2SHORT(LIT_END,0),MPFROMP(szString));
        }
      sprintf(szString,"%ld",MIN_CAP_BUFF_LEN);
      WinSendDlgItemMsg(hwnd,BSZ_MINLEN,LM_INSERTITEM,MPFROM2SHORT(LIT_END,0),MPFROMP(szString));
      sprintf(szString,"%lu",MAX_CAP_BUFF_LEN);
      WinSendDlgItemMsg(hwnd,BSZ_MAXLEN,LM_INSERTITEM,MPFROM2SHORT(LIT_END,0),MPFROMP(szString));
      WinSendDlgItemMsg(hwnd,BSZ_LENGTH,EM_SETTEXTLIMIT,MPFROMSHORT(12),(MPARAM)NULL);
      sprintf(szString,"%-lu",stCFGtemp.lBufferLength);
      WinSetDlgItemText(hwnd,BSZ_LENGTH,szString);
      sprintf(szString,"%-lu",MIN_CAP_BUFF_LEN);
      WinSetDlgItemText(hwnd,BSZ_MINLEN,szString);
      sprintf(szString,"%-lu",MAX_CAP_BUFF_LEN);
      WinSetDlgItemText(hwnd,BSZ_MAXLEN,szString);
      if (pstCFG->bMonitoringStream)
        {
        ControlEnable(hwnd,BSZ_LENGTH,FALSE);
        ControlEnable(hwnd,BSZ_LENGTHT,FALSE);
        }
      if (stCFGtemp.bCaptureToFile)
        CheckButton(hwnd,BSZ_FILE,TRUE);
      else
        if (stCFGtemp.bOverWriteBuffer)
          CheckButton(hwnd,BSZ_WRAP,TRUE);
        else
          CheckButton(hwnd,BSZ_STOP,TRUE);
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          if (Checked(hwnd,BSZ_FILE))
            {
            if (!stCFGtemp.bMonitoringStream || (stCFGtemp.bMonitoringStream && !stCFGtemp.bCaptureToFile))
              {
              if (!GetFileName(hwndClient,szCaptureFileSpec,"Select file to capture to.",COMscopeOpenFilterProc))
                return(FALSE);
              if ((hProfileInstance != NULL) && (strcmp(szEntryCaptureFileSpec,szCaptureFileSpec) != 0))
                if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
                  {
                  if (DosQueryProcAddr(hMod,0,"SaveProfileString",(PFN *)&pfnSaveProfileString) == NO_ERROR)
                    pfnSaveProfileString(hProfileInstance,"Capture File",szCaptureFileSpec);
                  DosFreeModule(hMod);
                  }
              strcpy(szCaptureFileName,szCaptureFileSpec);
              IncrementFileExt(szCaptureFileName,TRUE);
              if (!WriteCaptureFile(szCaptureFileName,pwCaptureBuffer,0,FOPEN_NORMAL,HLPP_MB_OVERWRT_CAP_FILE))
                return(FALSE);
              }
            stCFGtemp.bCaptureToFile = TRUE;
            }
          else
            {
            stCFGtemp.bCaptureToFile = FALSE;
            if (Checked(hwnd,BSZ_WRAP))
              stCFGtemp.bOverWriteBuffer = TRUE;
            else
              stCFGtemp.bOverWriteBuffer = FALSE;
            }
          if (!stCFGtemp.bMonitoringStream)
            {
            GetLongIntDlgItem(hwnd,BSZ_LENGTH,&lLength);
            if (lLength != stCFGtemp.lBufferLength)
              {
              if (lLength < MIN_CAP_BUFF_LEN)
                stCFGtemp.lBufferLength = MIN_CAP_BUFF_LEN;
              else
                if (lLength > MAX_CAP_BUFF_LEN)
                  stCFGtemp.lBufferLength = MAX_CAP_BUFF_LEN;
                else
                  stCFGtemp.lBufferLength = lLength;
              DosFreeMem(pwCaptureBuffer);
                pwCaptureBuffer = NULL;
              DosAllocMem((PPVOID)&pwCaptureBuffer,(stCFGtemp.lBufferLength * 2),PAG_COMMIT | PAG_READ | PAG_WRITE);
              MenuItemCheck(hwndFrame,IDM_VIEWDAT,FALSE);
              MenuItemEnable(hwndFrame,IDM_VIEWDAT,FALSE);
              lWriteIndex = 0;
              stRow.lLeadIndex = 0;
              bBufferWrapped = FALSE;
              }
            }
          memcpy(pstCFG,&stCFGtemp,sizeof(CSCFG));
        case DID_CANCEL:
           break;
        case DID_HELP:
          DisplayHelpPanel(HLPP_BUFFER_SIZE_DLG);
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

MRESULT EXPENTRY fnwpMonitorSleepDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  char szString[100];
  static ULONG ulFrequency;
  static CSCFG *pstCFG;
  static bAllowClick;
  LONG lBaud;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwnd);
      WinSetFocus(HWND_DESKTOP,hwnd);
      bAllowClick = FALSE;
      pstCFG = PVOIDFROMMP(mp2);
      if (hCom != 0xffffffff)
        if (GetBaudRate(&stIOctl,hCom,&lBaud) == 0)
          CalcThreadSleepCount(lBaud);
      sprintf(szString,"Device Driver Trace Buffer Size = %d bytes",ulCOMscopeBufferSize);
      WinSetDlgItemText(hwnd,MSLEEP_BUFF_SIZE,szString);
      sprintf(szString,"Calculated Update Frequency = %ld milliseconds",ulCalcSleepCount);
      WinSetDlgItemText(hwnd,MSLEEP_CALC_RATE,szString);
      if (pstCFG->ulUserSleepCount == 0)
        {
        ulFrequency = ulCalcSleepCount;
        CheckButton(hwnd,MSLEEP_CALC,TRUE);
        ControlEnable(hwnd,MSLEEP_USER_COUNT,FALSE);
        ControlEnable(hwnd,MSLEEP_USER_COUNTT,FALSE);
        }
      else
        {
        ulFrequency = pstCFG->ulUserSleepCount;
        CheckButton(hwnd,MSLEEP_USER,TRUE);
        }
      if (ulFrequency < 100)
        {
        sprintf(szString,"Recommend increasing");
        WinSetDlgItemText(hwnd,MSLEEP_WARNING,szString);
        sprintf(szString,"device driver trace buffer size!");
        WinSetDlgItemText(hwnd,MSLEEP_WARNING1,szString);
        }
      sprintf(szString,"%ld",ulFrequency);
      WinSendDlgItemMsg(hwnd,MSLEEP_USER_COUNT,EM_SETTEXTLIMIT,MPFROMSHORT(6),(MPARAM)NULL);
      WinSetDlgItemText(hwnd,MSLEEP_USER_COUNT,szString);
      WinPostMsg(hwnd,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      break;
    case UM_INITLS:
      bAllowClick = TRUE;
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          if (Checked(hwnd,MSLEEP_USER))
            {
            WinQueryDlgItemText(hwnd,MSLEEP_USER_COUNT,6,szString);
            ulMonitorSleepCount = (USHORT)atoi(szString);
            pstCFG->ulUserSleepCount = ulMonitorSleepCount;
            }
          else
            {
            pstCFG->ulUserSleepCount = 0;
            ulMonitorSleepCount = ulCalcSleepCount;
            }
          if (pstCFG->fDisplaying & DISP_STREAM)
            if (pstCFG->ulUserSleepCount == 0)
              if (ulMonitorSleepCount > 200)
                ulMonitorSleepCount = 200;
          DosPostEventSem(hevWaitCOMiDataSem);
        case DID_CANCEL:
           break;
        case DID_HELP:
          DisplayHelpPanel(HLPP_MONITOR_UPDATE_DLG);
          return((MRESULT)FALSE);
        default:
          return WinDefDlgProc(hwnd,msg,mp1,mp2);
        }
      WinDismissDlg(hwnd,TRUE);
      break;
    case WM_CONTROL:
      if ((SHORT2FROMMP(mp1) == BN_CLICKED) && bAllowClick)
        {
        switch (SHORT1FROMMP(mp1))
          {
          case MSLEEP_CALC:
            CheckButton(hwnd,MSLEEP_CALC,TRUE);
            CheckButton(hwnd,MSLEEP_USER,FALSE);
            ControlEnable(hwnd,MSLEEP_USER_COUNT,FALSE);
            ControlEnable(hwnd,MSLEEP_USER_COUNTT,FALSE);
            break;
          case MSLEEP_USER:
            CheckButton(hwnd,MSLEEP_CALC,FALSE);
            CheckButton(hwnd,MSLEEP_USER,TRUE);
            ControlEnable(hwnd,MSLEEP_USER_COUNT,TRUE);
            ControlEnable(hwnd,MSLEEP_USER_COUNTT,TRUE);
            break;
          }
        }
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return FALSE;
  }

MRESULT EXPENTRY fnwpDisplaySetupDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  char szTitle[20];
  static BOOL bAllowClick;
  static SCREEN *pstScreen;
  static SCREEN stScreen;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwndDlg);
      WinSetFocus(HWND_DESKTOP,hwndDlg);
      pstScreen = PVOIDFROMMP(mp2);
      bAllowClick = FALSE;
      memcpy(&stScreen,pstScreen,sizeof(SCREEN));
      WinSendDlgItemMsg(hwndDlg,DISP_NL_CHAR,EM_SETTEXTLIMIT,MPFROMSHORT(2),(MPARAM)NULL);
      sprintf(szTitle,"%02X",(int)stScreen.byNewLineChar);
      WinSetDlgItemText(hwndDlg,DISP_NL_CHAR,szTitle);
      WinSendDlgItemMsg(hwndDlg,DISP_CHAR_MASK,EM_SETTEXTLIMIT,MPFROMSHORT(2),(MPARAM)NULL);
      sprintf(szTitle,"%02X",(int)stScreen.byDisplayMask);
      WinSetDlgItemText(hwndDlg,DISP_CHAR_MASK,szTitle);
      if (stScreen.bSync)
        CheckButton(hwndDlg,DISP_SYNC,TRUE);
      if (stScreen.wDirection == CS_WRITE)
        {
        if (stCFG.bWriteWrap)
          CheckButton(hwndDlg,DISP_WRAP,TRUE);
        }
      else
        if (stCFG.bReadWrap)
          CheckButton(hwndDlg,DISP_WRAP,TRUE);
      if (stScreen.bTestNewLine)
        CheckButton(hwndDlg,DISP_NL,TRUE);
      else
        {
        EnableNewLine(hwndDlg,FALSE);
        ControlEnable(hwndDlg,DISP_SYNC,FALSE);
        }
      if (stScreen.bSkipBlankLines)
        CheckButton(hwndDlg,DISP_SKP,TRUE);
      CheckButton(hwndDlg,DISP_ALPHA,(stScreen.fFilterMask & FILTER_ALPHA));
      CheckButton(hwndDlg,DISP_NUMS,(stScreen.fFilterMask & FILTER_NUMS));
      CheckButton(hwndDlg,DISP_PUNCT,(stScreen.fFilterMask & FILTER_PUNCT));
      CheckButton(hwndDlg,DISP_NPRINT,(stScreen.fFilterMask & FILTER_NPRINT));
      if (stScreen.bFilter)
        CheckButton(hwndDlg,DISP_FILTER,TRUE);
      else
        EnableFilters(hwndDlg,FALSE);
      WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      return((MRESULT)FALSE);
    case UM_INITLS:
      bAllowClick = TRUE;
      return((MRESULT)FALSE);
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_OK:
          if ((stScreen.bTestNewLine = Checked(hwndDlg,DISP_NL)) == TRUE)
            {
            stScreen.bSkipBlankLines = Checked(hwndDlg,DISP_SKP);
            WinQueryDlgItemText(hwndDlg,DISP_NL_CHAR,3,szTitle);
            stScreen.byNewLineChar = (BYTE)ASCIItoBin(szTitle,16);
            stScreen.bSync = Checked(hwndDlg,DISP_SYNC);
            stScreen.bWrap = Checked(hwndDlg,DISP_WRAP);
            if (stScreen.wDirection == CS_WRITE)
              stCFG.bWriteWrap = stScreen.bWrap;
            else
              stCFG.bReadWrap = stScreen.bWrap;
            }
          else
            stScreen.bWrap = TRUE;
          if ((stScreen.bFilter = Checked(hwndDlg,DISP_FILTER)) == TRUE)
            {
            stScreen.fFilterMask = 0;
            if (Checked(hwndDlg,DISP_NPRINT))
              stScreen.fFilterMask |= FILTER_NPRINT;
            if (Checked(hwndDlg,DISP_ALPHA))
              stScreen.fFilterMask |= FILTER_ALPHA;
            if (Checked(hwndDlg,DISP_NUMS))
              stScreen.fFilterMask |= FILTER_NUMS;
            if (Checked(hwndDlg,DISP_PUNCT))
              stScreen.fFilterMask |= FILTER_PUNCT;
            WinQueryDlgItemText(hwndDlg,DISP_CHAR_MASK,3,szTitle);
            stScreen.byDisplayMask = (BYTE)ASCIItoBin(szTitle,16);
            }
          memcpy(pstScreen,&stScreen,sizeof(SCREEN));
          AdjustScrollBar(pstScreen);
          WinDismissDlg(hwndDlg,TRUE);
          return(MRESULT)TRUE;
        case DID_HELP:
          DisplayHelpPanel(HLPP_DISPLAY_DLG);
          return((MRESULT)FALSE);
        case DID_CANCEL:
          WinDismissDlg(hwndDlg,FALSE);
          break;
        default:
          return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
        }
      return(FALSE);
    case WM_CONTROL:
      if ((SHORT2FROMMP(mp1) == BN_CLICKED) && bAllowClick)
        {
        switch (SHORT1FROMMP(mp1))
          {
          case DISP_NL:
            if (Checked(hwndDlg,DISP_NL))
              {
              CheckButton(hwndDlg,DISP_NL,FALSE);
              EnableNewLine(hwndDlg,FALSE);
              }
            else
              {
              CheckButton(hwndDlg,DISP_NL,TRUE);
              EnableNewLine(hwndDlg,TRUE);
              }
            break;
          case DISP_FILTER:
            if (!Checked(hwndDlg,DISP_FILTER))
              {
              CheckButton(hwndDlg,DISP_FILTER,TRUE);
              EnableFilters(hwndDlg,TRUE);
              }
            else
              {
              CheckButton(hwndDlg,DISP_FILTER,FALSE);
              EnableFilters(hwndDlg,FALSE);
              }
            break;
        default:
           return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
          }
        return(FALSE);
        }
      break;
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }

MRESULT EXPENTRY fnwpCountsSetupDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  char szTitle[20];
  static BOOL bAllowClick;
  static CSCFG *pstCFG;
  int iSamples;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwndDlg);
      WinSetFocus(HWND_DESKTOP,hwndDlg);
      pstCFG = PVOIDFROMMP(mp2);
      WinSendDlgItemMsg(hwndDlg,SPB_SAMPLES,SPBM_SETLIMITS,(MPARAM)MAX_CPS_SAMPLES,(MPARAM)0);
      if (pstCFG->iSampleCount == 0)
        iSamples = 1;
      else
        iSamples = pstCFG->iSampleCount;
      WinSendDlgItemMsg(hwndDlg,SPB_SAMPLES,SPBM_SETCURRENTVALUE,(MPARAM)(iSamples - 1),NULL);
      bAllowClick = FALSE;
      if (!pstCFG->bSampleCounts)
        {
        ControlEnable(hwndDlg,SPB_SAMPLES,FALSE);
        ControlEnable(hwndDlg,ST_SAMPLES,FALSE);
        }
      else
        CheckButton(hwndDlg,CB_DISPCPS,TRUE);
      if (pstCFG->bShowCounts)
        CheckButton(hwndDlg,CB_DISPCOUNTS,TRUE);
      WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      return((MRESULT)FALSE);
    case UM_INITLS:
      bAllowClick = TRUE;
      return((MRESULT)FALSE);
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_OK:
          if (Checked(hwndDlg,CB_DISPCOUNTS))
            pstCFG->bShowCounts = TRUE;
          else
            pstCFG->bShowCounts = FALSE;
          if (Checked(hwndDlg,CB_DISPCPS))
            {
            WinSendDlgItemMsg(hwndDlg,SPB_SAMPLES,SPBM_QUERYVALUE,&pstCFG->iSampleCount,MPFROM2SHORT(0,SPBQ_DONOTUPDATE));
            pstCFG->iSampleCount++;
            pstCFG->bSampleCounts = TRUE;
            }
          else
            pstCFG->bSampleCounts = FALSE;

          if (!pstCFG->bShowCounts && !pstCFG->bSampleCounts)
            WinPostMsg(hwndStatus,UM_STOPTIMER,0L,0L);
          else
            {
            WinPostMsg(hwndStatus,UM_RESET_SAMPLES,0L,0L);
            WinPostMsg(hwndStatus,UM_STARTTIMER,0L,0L);
            }
          WinDismissDlg(hwndDlg,TRUE);
          return(MRESULT)TRUE;
        case DID_HELP:
          DisplayHelpPanel(HLPP_COUNTS_DLG);
          return((MRESULT)FALSE);
        case DID_CANCEL:
          WinDismissDlg(hwndDlg,FALSE);
          break;
        default:
          return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
        }
      return(FALSE);
    case WM_CONTROL:
      if ((SHORT2FROMMP(mp1) == BN_CLICKED) && bAllowClick)
        {
        if (SHORT1FROMMP(mp1) == CB_DISPCPS)
          if (Checked(hwndDlg,CB_DISPCPS))
            {
            CheckButton(hwndDlg,CB_DISPCPS,FALSE);
            ControlEnable(hwndDlg,SPB_SAMPLES,FALSE);
            ControlEnable(hwndDlg,ST_SAMPLES,FALSE);
            }
          else
            {
            CheckButton(hwndDlg,CB_DISPCPS,TRUE);
            ControlEnable(hwndDlg,SPB_SAMPLES,TRUE);
            ControlEnable(hwndDlg,ST_SAMPLES,TRUE);
            }
        }
      break;
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }


MRESULT EXPENTRY fnwpHdwModemControlDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  DCB stComDCB;
//  static CSCFG *pstCFG;
  BYTE byOnStates;
  BYTE byOffStates;
  static BOOL bNoOUT1;
  static BOOL bNoRTS;
  static BOOL bNoDTR;
//  BOOL bActive;
  WORD wCOMerror;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwndDlg);
      WinSetFocus(HWND_DESKTOP,hwndDlg);
//      pstCFG = PVOIDFROMMP(mp2);
      GetModemOutputSignals(&stIOctl,hCom,&byOnStates);
      if (byOnStates & 0x01)
        CheckButton(hwndDlg,HWM_DTR_ON,TRUE);
      else
        CheckButton(hwndDlg,HWM_DTR_OFF,TRUE);
      if (byOnStates & 0x02)
        CheckButton(hwndDlg,HWM_RTS_ON,TRUE);
      else
        CheckButton(hwndDlg,HWM_RTS_OFF,TRUE);
      if (!TestOUT1())
        {
        bNoOUT1 = TRUE;
        ControlEnable(hwndDlg,HWM_OUT1T,FALSE);
        ControlEnable(hwndDlg,HWM_OUT1_ON,FALSE);
        ControlEnable(hwndDlg,HWM_OUT1_OFF,FALSE);
        }
      else
        {
        bNoOUT1 = FALSE;
        if (byOnStates & 0x04)
          CheckButton(hwndDlg,HWM_OUT1_ON,TRUE);
        else
          CheckButton(hwndDlg,HWM_OUT1_OFF,TRUE);
        }
      GetDCB(&stIOctl,hCom,&stComDCB);
      if (stComDCB.Flags1 & F1_ENABLE_DTR_INPUT_HS)
        {
        bNoDTR = TRUE;
        ControlEnable(hwndDlg,HWM_DTRT,FALSE);
        ControlEnable(hwndDlg,HWM_DTR_ON,FALSE);
        ControlEnable(hwndDlg,HWM_DTR_OFF,FALSE);
        }
      else
        bNoDTR = FALSE;
      if (((stComDCB.Flags2 & F2_RTS_MASK) == F2_ENABLE_RTS_INPUT_HS) ||
          ((stComDCB.Flags2 & F2_RTS_MASK) == F2_ENABLE_RTS_TOG_ON_XMIT))
        {
        bNoRTS = TRUE;
        ControlEnable(hwndDlg,HWM_RTST,FALSE);
        ControlEnable(hwndDlg,HWM_RTS_ON,FALSE);
        ControlEnable(hwndDlg,HWM_RTS_OFF,FALSE);
        }
      else
        bNoRTS = FALSE;
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          byOffStates = 0xff;
          byOnStates = 0x00;
          if (!bNoDTR)
            {
            if (Checked(hwndDlg,HWM_DTR_ON))
              byOnStates |= 0x01;
            else
              byOffStates &= 0xfe;
            }
          if (!bNoRTS)
            {
            if (Checked(hwndDlg,HWM_RTS_ON))
              byOnStates |= 0x02;
            else
              byOffStates &= 0xfd;
            }
          if (!bNoOUT1)
            {
            if (Checked(hwndDlg,HWM_OUT1_ON))
              byOnStates |= 0x04;
            else
              byOffStates &= 0xfb;
            }
          SetModemSignals(&stIOctl,hCom,byOnStates,byOffStates,&wCOMerror);
        case DID_CANCEL:
          break;
        case DID_HELP:
          DisplayHelpPanel(HLPP_MODEM_SIG_DLG);
          return((MRESULT)TRUE);
        default:
          return WinDefDlgProc(hwndDlg,msg,mp1,mp2);
        }
      WinDismissDlg(hwndDlg,TRUE);
      break;
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return FALSE;
  }

extern FATTRS astFontAttributes[];

MRESULT EXPENTRY fnwpSetColorDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static CLRDLG *pstColor;
  static LONG lBackgrndColor;
  static LONG lForegrndColor;
  static BOOL bAllowClick;
  USHORT usContrastID;
  static HWND hwndSample;
  LONG lColor;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwndDlg);
      WinSetFocus(HWND_DESKTOP,hwndDlg);
      bAllowClick = FALSE;
      pstColor = PVOIDFROMMP(mp2);
      WinSetDlgItemText(hwndDlg,CLR_DLG_CAPTION,pstColor->szCaption);
      lForegrndColor = pstColor->lForeground;
      lBackgrndColor = pstColor->lBackground;
      FillSetColorDlg(hwndDlg,lForegrndColor,lBackgrndColor);
      hwndSample = WinWindowFromID(hwndDlg,CLR_SAMPLE);
      WinSetPresParam(hwndSample,PP_FOREGROUNDCOLORINDEX,4,&lForegrndColor);
      WinSetPresParam(hwndSample,PP_BACKGROUNDCOLORINDEX,4,&lBackgrndColor);
      WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      break;
    case UM_INITLS:
      bAllowClick = TRUE;
      break;
//    case WM_PAINT:
//      hps WinBeginPaint(
    case WM_CONTROL:
      if ((SHORT2FROMMP(mp1) == BN_CLICKED) && bAllowClick)
        if (!TCColorDlg(hwndDlg,hwndSample,SHORT1FROMMP(mp1),&lForegrndColor,&lBackgrndColor))
          return(FALSE);
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_AUTOFOREGRND:
          lColor = lBackgrndColor;
          if ((usContrastID = FindContrastingColor(astForegrndContrastTable,&lColor)) != 0)
            {
            lForegrndColor = lColor;
            CheckButton(hwndDlg,usContrastID,TRUE);
            WinSetPresParam(hwndSample,PP_FOREGROUNDCOLORINDEX,4,&lForegrndColor);
            }
          break;
        case DID_AUTOBACKGRND:
          lColor = lForegrndColor;
          if ((usContrastID = FindContrastingColor(astBackgrndContrastTable,&lColor)) != 0)
            {
            lBackgrndColor = lColor;
            CheckButton(hwndDlg,usContrastID,TRUE);
            WinSetPresParam(hwndSample,PP_BACKGROUNDCOLORINDEX,4,&lBackgrndColor);
            }
          break;
        case DID_HELP:
          DisplayHelpPanel(HLPP_COLOR_DLG);
          return((MRESULT)FALSE);
        case DID_OK:
          pstColor->lBackground = lBackgrndColor;
          pstColor->lForeground = lForegrndColor;
          WinDismissDlg(hwndDlg,TRUE);
          break;
        case DID_CANCEL:
          WinDismissDlg(hwndDlg,FALSE);
          break;
        default:
          return WinDefDlgProc(hwndDlg,msg,mp1,mp2);
        }
      break;
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return(FALSE);
  }

BOOL TCColorDlg(HWND hwndDlg,HWND hwndSample,USHORT idButton,LONG *plForegrndColor,LONG *plBackgrndColor)
  {
  LONG lColor;
  BOOL bBackground = FALSE;

  if (Checked(hwndDlg,idButton))
    {
    switch(idButton)
      {
      case CLR_BDRED:
        lColor = CLR_DARKRED;
        bBackground = TRUE;
        break;
      case CLR_BDBLUE:
        lColor = CLR_DARKBLUE;
        bBackground = TRUE;
        break;
      case CLR_BDGRAY:
        lColor = CLR_DARKGRAY;
        bBackground = TRUE;
        break;
      case CLR_BDPINK:
        lColor = CLR_DARKPINK;
        bBackground = TRUE;
        break;
      case CLR_BPINK:
        lColor = CLR_PINK;
        bBackground = TRUE;
        break;
      case CLR_BDGREEN:
        lColor = CLR_DARKGREEN;
        bBackground = TRUE;
        break;
      case CLR_BRED:
        lColor = CLR_RED;
        bBackground = TRUE;
        break;
      case CLR_BBLUE:
        lColor = CLR_BLUE;
        bBackground = TRUE;
        break;
      case CLR_BGRAY:
        lColor = CLR_PALEGRAY;
        bBackground = TRUE;
        break;
      case CLR_BGREEN:
        lColor = CLR_GREEN;
        bBackground = TRUE;
        break;
      case CLR_BCYAN:
        lColor = CLR_CYAN;
        bBackground = TRUE;
        break;
      case CLR_BDCYAN:
        lColor = CLR_DARKCYAN;
        bBackground = TRUE;
        break;
      case CLR_BYELLOW:
        lColor = CLR_YELLOW;
        bBackground = TRUE;
        break;
      case CLR_BBROWN:
        lColor = CLR_BROWN;
        bBackground = TRUE;
        break;
      case CLR_BWHITE:
        lColor = CLR_WHITE;
        bBackground = TRUE;
        break;
      case CLR_BBLACK:
        lColor = CLR_BLACK;
        bBackground = TRUE;
        break;
      case CLR_FDRED:
        lColor = CLR_DARKRED;
        break;
      case CLR_FDBLUE:
        lColor = CLR_DARKBLUE;
        break;
      case CLR_FDPINK:
        lColor = CLR_DARKPINK;
        break;
      case CLR_FPINK:
        lColor = CLR_PINK;
        break;
      case CLR_FDGRAY:
        lColor = CLR_DARKGRAY;
        break;
      case CLR_FDGREEN:
        lColor = CLR_DARKGREEN;
        break;
      case CLR_FRED:
        lColor = CLR_RED;
        break;
      case CLR_FBLUE:
        lColor = CLR_BLUE;
        break;
      case CLR_FGRAY:
        lColor = CLR_PALEGRAY;
        break;
      case CLR_FGREEN:
        lColor = CLR_GREEN;
        break;
      case CLR_FCYAN:
        lColor = CLR_CYAN;
        break;
      case CLR_FDCYAN:
        lColor = CLR_DARKCYAN;
        break;
      case CLR_FYELLOW:
        lColor = CLR_YELLOW;
        break;
      case CLR_FBROWN:
        lColor = CLR_BROWN;
        break;
      case CLR_FWHITE:
        lColor = CLR_WHITE;
        break;
      case CLR_FBLACK:
        lColor = CLR_BLACK;
        break;
      default:
        return(FALSE);
      }
    if (!bBackground)
      {
      *plForegrndColor = lColor;
      WinSetPresParam(hwndSample,PP_FOREGROUNDCOLORINDEX,4,plForegrndColor);
      }
    else
      {
      *plBackgrndColor = lColor;
      WinSetPresParam(hwndSample,PP_BACKGROUNDCOLORINDEX,4,plBackgrndColor);
      }
    }
  return(TRUE);
  }

VOID FillSetColorDlg(HWND hwnd,LONG lForeground,LONG lBackground)
  {

  switch (lBackground)
    {
    case CLR_WHITE:
      CheckButton(hwnd,CLR_BWHITE,TRUE);
      break;
    case CLR_BLACK:
      CheckButton(hwnd,CLR_BBLACK,TRUE);
      break;
    case CLR_DARKBLUE:
      CheckButton(hwnd,CLR_BDBLUE,TRUE);
      break;
    case CLR_BLUE:
      CheckButton(hwnd,CLR_BBLUE,TRUE);
      break;
    case CLR_RED:
      CheckButton(hwnd,CLR_BRED,TRUE);
      break;
    case CLR_GREEN:
      CheckButton(hwnd,CLR_BGREEN,TRUE);
      break;
    case CLR_PINK:
      CheckButton(hwnd,CLR_BPINK,TRUE);
      break;
    case CLR_DARKCYAN:
      CheckButton(hwnd,CLR_BDCYAN,TRUE);
      break;
    case CLR_CYAN:
      CheckButton(hwnd,CLR_BCYAN,TRUE);
      break;
    case CLR_YELLOW:
      CheckButton(hwnd,CLR_BYELLOW,TRUE);
      break;
    case CLR_PALEGRAY:
      CheckButton(hwnd,CLR_BGRAY,TRUE);
      break;
    case CLR_DARKGREEN:
      CheckButton(hwnd,CLR_BDGREEN,TRUE);
      break;
    case CLR_DARKRED:
      CheckButton(hwnd,CLR_BDRED,TRUE);
      break;
    case CLR_DARKPINK:
      CheckButton(hwnd,CLR_BDPINK,TRUE);
      break;
    case CLR_BROWN:
      CheckButton(hwnd,CLR_BBROWN,TRUE);
      break;
    case CLR_DARKGRAY:
      CheckButton(hwnd,CLR_BDGRAY,TRUE);
      break;
    }

  switch (lForeground)
    {
    case CLR_WHITE:
      CheckButton(hwnd,CLR_FWHITE,TRUE);
      break;
    case CLR_BLACK:
      CheckButton(hwnd,CLR_FBLACK,TRUE);
      break;
    case CLR_DARKBLUE:
      CheckButton(hwnd,CLR_FDBLUE,TRUE);
      break;
    case CLR_BLUE:
      CheckButton(hwnd,CLR_FBLUE,TRUE);
      break;
    case CLR_DARKRED:
      CheckButton(hwnd,CLR_FDRED,TRUE);
      break;
    case CLR_RED:
      CheckButton(hwnd,CLR_FRED,TRUE);
      break;
    case CLR_GREEN:
      CheckButton(hwnd,CLR_FGREEN,TRUE);
      break;
    case CLR_PINK:
      CheckButton(hwnd,CLR_FPINK,TRUE);
      break;
    case CLR_DARKCYAN:
      CheckButton(hwnd,CLR_FDCYAN,TRUE);
      break;
    case CLR_CYAN:
      CheckButton(hwnd,CLR_FCYAN,TRUE);
      break;
    case CLR_YELLOW:
      CheckButton(hwnd,CLR_FYELLOW,TRUE);
      break;
    case CLR_PALEGRAY:
      CheckButton(hwnd,CLR_FGRAY,TRUE);
      break;
    case CLR_DARKGREEN:
      CheckButton(hwnd,CLR_FDGREEN,TRUE);
      break;
    case CLR_BROWN:
      CheckButton(hwnd,CLR_FBROWN,TRUE);
      break;
    case CLR_DARKGRAY:
      CheckButton(hwnd,CLR_FDGRAY,TRUE);
      break;
    }
  }

MRESULT EXPENTRY fnwpEventDispDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
//  char szTitle[20];
  static CSCFG *pstCFG;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwndDlg);
      WinSetFocus(HWND_DESKTOP,hwndDlg);
      pstCFG = PVOIDFROMMP(mp2);
      if (pstCFG->bDispModemIn)
        CheckButton(hwndDlg,EVENT_MODEMIN,TRUE);
      if (pstCFG->bDispModemOut)
        CheckButton(hwndDlg,EVENT_MODEMOUT,TRUE);
      if (pstCFG->bDispWriteReq)
        CheckButton(hwndDlg,EVENT_WRITE_REQ,TRUE);
      if (pstCFG->bDispReadReq)
        CheckButton(hwndDlg,EVENT_READ_REQ,TRUE);
      if (pstCFG->bPopupParams)
        CheckButton(hwndDlg,EVENT_POPUP_PARAMS,TRUE);
      if (pstCFG->bDispDevIOctl)
        CheckButton(hwndDlg,EVENT_DEVIOCTL,TRUE);
      if (pstCFG->bDispErrors)
        CheckButton(hwndDlg,EVENT_ERRORS,TRUE);
      if (pstCFG->bDispOpen)
        CheckButton(hwndDlg,EVENT_OPEN,TRUE);
      if (pstCFG->bDispRead)
        CheckButton(hwndDlg,EVENT_RCV,TRUE);
      if (pstCFG->bDispWrite)
        CheckButton(hwndDlg,EVENT_XMIT,TRUE);
      if (pstCFG->bDispIMM)
        CheckButton(hwndDlg,EVENT_IMM,TRUE);
      if (pstCFG->bHiLightImmediateByte)
        CheckButton(hwndDlg,EVENT_DISP_HILIGHT,TRUE);
/*
**  changed to set current line mark instead of compress display
**  compress display is going away
*/
      if (pstCFG->bMarkCurrentLine)
        CheckButton(hwndDlg,EVENT_DISP_COMPRESS,TRUE);
      return((MRESULT)FALSE);
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case PB_ALL:
          CheckButton(hwndDlg,EVENT_MODEMIN,TRUE);
          CheckButton(hwndDlg,EVENT_MODEMOUT,TRUE);
          CheckButton(hwndDlg,EVENT_WRITE_REQ,TRUE);
          CheckButton(hwndDlg,EVENT_READ_REQ,TRUE);
          CheckButton(hwndDlg,EVENT_POPUP_PARAMS,TRUE);
          CheckButton(hwndDlg,EVENT_DEVIOCTL,TRUE);
          CheckButton(hwndDlg,EVENT_ERRORS,TRUE);
          CheckButton(hwndDlg,EVENT_OPEN,TRUE);
          CheckButton(hwndDlg,EVENT_RCV,TRUE);
          CheckButton(hwndDlg,EVENT_XMIT,TRUE);
          CheckButton(hwndDlg,EVENT_IMM,TRUE);
          break;
        case DID_OK:
          if (Checked(hwndDlg,EVENT_MODEMIN))
            pstCFG->bDispModemIn = TRUE;
          else
            pstCFG->bDispModemIn = FALSE;

          if (Checked(hwndDlg,EVENT_MODEMOUT))
            pstCFG->bDispModemOut = TRUE;
          else
            pstCFG->bDispModemOut = FALSE;

          if (Checked(hwndDlg,EVENT_WRITE_REQ))
            pstCFG->bDispWriteReq = TRUE;
          else
            pstCFG->bDispWriteReq = FALSE;

          if (Checked(hwndDlg,EVENT_READ_REQ))
            pstCFG->bDispReadReq = TRUE;
          else
            pstCFG->bDispReadReq = FALSE;

          if (Checked(hwndDlg,EVENT_DEVIOCTL))
            pstCFG->bDispDevIOctl = TRUE;
          else
            pstCFG->bDispDevIOctl = FALSE;

          if (Checked(hwndDlg,EVENT_POPUP_PARAMS))
            pstCFG->bPopupParams = TRUE;
          else
            pstCFG->bPopupParams = FALSE;

          if (Checked(hwndDlg,EVENT_ERRORS))
            pstCFG->bDispErrors = TRUE;
          else
            pstCFG->bDispErrors = FALSE;

          if (Checked(hwndDlg,EVENT_OPEN))
            pstCFG->bDispOpen = TRUE;
          else
            pstCFG->bDispOpen = FALSE;

          if (Checked(hwndDlg,EVENT_RCV))
            pstCFG->bDispRead = TRUE;
          else
            pstCFG->bDispRead = FALSE;

          if (Checked(hwndDlg,EVENT_XMIT))
            pstCFG->bDispWrite = TRUE;
          else
            pstCFG->bDispWrite = FALSE;

          if (Checked(hwndDlg,EVENT_IMM))
            pstCFG->bDispIMM = TRUE;
          else
            pstCFG->bDispIMM = FALSE;

          if (Checked(hwndDlg,EVENT_DISP_COMPRESS))
            pstCFG->bMarkCurrentLine = TRUE;
          else
            pstCFG->bMarkCurrentLine = FALSE;

          if (Checked(hwndDlg,EVENT_DISP_HILIGHT))
            pstCFG->bHiLightImmediateByte = TRUE;
          else
            pstCFG->bHiLightImmediateByte = FALSE;
          if (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE))
            {
            if (!pstCFG->bColumnDisplay)
              {
              SetupRowScrolling(&stRow);
              WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
              }
            }
          WinDismissDlg(hwndDlg,TRUE);
          return(MRESULT)TRUE;
        case DID_HELP:
          DisplayHelpPanel(HLPP_TIME_DISP_DLG);
          return((MRESULT)FALSE);
        case DID_CANCEL:
          WinDismissDlg(hwndDlg,FALSE);
          break;
        default:
          return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
        }
      return(FALSE);
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }

MRESULT EXPENTRY fnwpTraceEventDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
//  char szTitle[20];
  static CSCFG *pstCFG;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwndDlg);
      WinSetFocus(HWND_DESKTOP,hwndDlg);
      pstCFG = PVOIDFROMMP(mp2);
      if (pstCFG->fTraceEvent & CSFUNC_TRACE_MODEM_IN_SIGNALS)
        CheckButton(hwndDlg,TRACE_MODEM_IN,TRUE);

      if (pstCFG->fTraceEvent & CSFUNC_TRACE_MODEM_OUT_SIGNALS)
        CheckButton(hwndDlg,TRACE_MODEM_OUT,TRUE);

      if (pstCFG->fTraceEvent & CSFUNC_TRACE_OPEN)
        CheckButton(hwndDlg,TRACE_OPEN_CLOSE,TRUE);

      if (pstCFG->fTraceEvent & CSFUNC_TRACE_ERRORS)
        CheckButton(hwndDlg,TRACE_ERRORS,TRUE);

      if (pstCFG->fTraceEvent & CSFUNC_TRACE_WRITE)
        CheckButton(hwndDlg,TRACE_WRITE_REQ,TRUE);

      if (pstCFG->fTraceEvent & CSFUNC_TRACE_READ)
        CheckButton(hwndDlg,TRACE_READ_REQ,TRUE);

      if (pstCFG->fTraceEvent & CSFUNC_TRACE_INCLUDE_PACKET)
        CheckButton(hwndDlg,TRACE_FUNC_PARAMS,TRUE);

      if (pstCFG->fTraceEvent & CSFUNC_TRACE_DEVIOCTL)
        CheckButton(hwndDlg,TRACE_DEVIOCTL,TRUE);

      if (pstCFG->fTraceEvent & CSFUNC_TRACE_IMM_STREAM)
        CheckButton(hwndDlg,TRACE_IMM,TRUE);

      if (pstCFG->fTraceEvent & CSFUNC_TRACE_INPUT_STREAM)
        CheckButton(hwndDlg,TRACE_RCV,TRUE);

      if (pstCFG->fTraceEvent & CSFUNC_TRACE_OUTPUT_STREAM)
        CheckButton(hwndDlg,TRACE_XMIT,TRUE);
      return((MRESULT)FALSE);
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case PB_ALL:
          CheckButton(hwndDlg,TRACE_MODEM_IN,TRUE);
          CheckButton(hwndDlg,TRACE_MODEM_OUT,TRUE);
          CheckButton(hwndDlg,TRACE_OPEN_CLOSE,TRUE);
          CheckButton(hwndDlg,TRACE_ERRORS,TRUE);
          CheckButton(hwndDlg,TRACE_WRITE_REQ,TRUE);
          CheckButton(hwndDlg,TRACE_READ_REQ,TRUE);
          CheckButton(hwndDlg,TRACE_FUNC_PARAMS,TRUE);
          CheckButton(hwndDlg,TRACE_DEVIOCTL,TRUE);
          CheckButton(hwndDlg,TRACE_IMM,TRUE);
          CheckButton(hwndDlg,TRACE_RCV,TRUE);
          CheckButton(hwndDlg,TRACE_XMIT,TRUE);
          return((MRESULT)FALSE);
        case DID_OK:
          pstCFG->fTraceEvent &= ~CSFUNC_TRACE_STREAMS_MASK;
          if (Checked(hwndDlg,TRACE_RCV))
            pstCFG->fTraceEvent |= CSFUNC_TRACE_INPUT_STREAM;

          if (Checked(hwndDlg,TRACE_XMIT))
            pstCFG->fTraceEvent |= CSFUNC_TRACE_OUTPUT_STREAM;

          if (Checked(hwndDlg,TRACE_IMM))
            pstCFG->fTraceEvent |= CSFUNC_TRACE_IMM_STREAM;

          if (Checked(hwndDlg,TRACE_MODEM_IN))
            pstCFG->fTraceEvent |= CSFUNC_TRACE_MODEM_IN_SIGNALS;

          if (Checked(hwndDlg,TRACE_MODEM_OUT))
            pstCFG->fTraceEvent |= CSFUNC_TRACE_MODEM_OUT_SIGNALS;

          if (Checked(hwndDlg,TRACE_ERRORS))
            pstCFG->fTraceEvent |= CSFUNC_TRACE_ERRORS;

          if (Checked(hwndDlg,TRACE_OPEN_CLOSE))
            pstCFG->fTraceEvent |= CSFUNC_TRACE_OPEN;

          if (Checked(hwndDlg,TRACE_READ_REQ))
            pstCFG->fTraceEvent |= CSFUNC_TRACE_READ;

          if (Checked(hwndDlg,TRACE_WRITE_REQ))
            pstCFG->fTraceEvent |= CSFUNC_TRACE_WRITE;

          if (Checked(hwndDlg,TRACE_DEVIOCTL))
            pstCFG->fTraceEvent |= CSFUNC_TRACE_DEVIOCTL;

          if (Checked(hwndDlg,TRACE_FUNC_PARAMS))
            pstCFG->fTraceEvent |= CSFUNC_TRACE_INCLUDE_PACKET;

          if (bCOMscopeEnabled && (hCom != 0xffffffff))
            EnableCOMscope(hwndDlg,hCom,&ulCOMscopeBufferSize,pstCFG->fTraceEvent);
          WinDismissDlg(hwndDlg,TRUE);
          return(MRESULT)TRUE;
        case DID_HELP:
          DisplayHelpPanel(HLPP_EVENTS_DLG);
          return((MRESULT)FALSE);
        case DID_CANCEL:
          WinDismissDlg(hwndDlg,FALSE);
          break;
        default:
          return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
        }
      return(FALSE);
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }

MRESULT EXPENTRY fnwpDCBpacketDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static DCB *pstDCB;
  char szString[100];
  BYTE byTemp;

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwndDlg);
      WinSetFocus(HWND_DESKTOP,hwndDlg);
      pstDCB = (DCB *)mp2;
      byTemp = pstDCB->Flags1;
      switch (byTemp & F1_DTR_MASK)
        {
        case 0: //F1_DISABLE_DTR:
          strcpy(szString,"Deactivate DTR");
          break;
        case F1_ENABLE_DTR:
          strcpy(szString,"Activate DTR");
          break;
        case F1_ENABLE_DTR_INPUT_HS:
          strcpy(szString,"DTR input handshaking");
          break;
        default:
          strcpy(szString,"Invalid parameter");
          break;
        }
      WinSetDlgItemText(hwndDlg,DCB_DTR_HS,szString);
      if (byTemp & F1_ENABLE_DSR_OUTPUT_HS)
        strcpy(szString,"Enable");
      else
        strcpy(szString,"Disable");
      WinSetDlgItemText(hwndDlg,DCB_DSR_OUT_HS,szString);
      if (byTemp & F1_ENABLE_DCD_OUTPUT_HS)
        strcpy(szString,"Enable");
      else
        strcpy(szString,"Disable");
      WinSetDlgItemText(hwndDlg,DCB_DCD_OUT_HS,szString);
      if (byTemp & F1_ENABLE_CTS_OUTPUT_HS)
        strcpy(szString,"Enable");
      else
        strcpy(szString,"Disable");
      WinSetDlgItemText(hwndDlg,DCB_CTS_OUT_HS,szString);
      if (byTemp & F1_ENABLE_DSR_INPUT_HS)
        strcpy(szString,"Enable");
      else
        strcpy(szString,"Disable");
      WinSetDlgItemText(hwndDlg,DCB_DSR_IN_SENSE,szString);
      byTemp = pstDCB->Flags2;
      switch (byTemp & F2_RTS_MASK)
        {
        case 0: //F2_DISABLE_RTS:
          strcpy(szString,"Deactivate RTS");
          break;
        case F2_ENABLE_RTS:
          strcpy(szString,"Activate RTS");
          break;
        case F2_ENABLE_RTS_INPUT_HS:
          strcpy(szString,"RTS input handshaking");
          break;
        case F2_ENABLE_RTS_TOG_ON_XMIT:
          strcpy(szString,"RTS toggling on tramsmit");
          break;
        }
      WinSetDlgItemText(hwndDlg,DCB_RTS_HS,szString);
      if (byTemp & F2_ENABLE_BREAK_REPL)
        strcpy(szString,"Enable");
      else
        strcpy(szString,"Disable");
      WinSetDlgItemText(hwndDlg,DCB_BRK_REP,szString);
      sprintf(szString,"'\\x%02X' )",pstDCB->BrkChar);
      WinSetDlgItemText(hwndDlg,DCB_BRK_CHAR,szString);
      if (byTemp & F2_ENABLE_ERROR_REPL)
        strcpy(szString,"Enable");
      else
        strcpy(szString,"Disable");
      WinSetDlgItemText(hwndDlg,DCB_ERR_REP,szString);
      sprintf(szString,"'\\x%02X' )",pstDCB->ErrChar);
      WinSetDlgItemText(hwndDlg,DCB_ERR_CHAR,szString);
      if (byTemp & F2_ENABLE_NULL_STRIP)
        strcpy(szString,"Enable");
      else
        strcpy(szString,"Disable");
      WinSetDlgItemText(hwndDlg,DCB_NULL_STRIP,szString);
      if (byTemp & F2_ENABLE_RCV_XON_XOFF_FLOW)
        strcpy(szString,"Enable");
      else
        strcpy(szString,"Disable");
      WinSetDlgItemText(hwndDlg,DCB_RX_XON_HS,szString);
      if (byTemp & F2_ENABLE_FULL_DUPLEX)
        strcpy(szString,"( full duplex )");
      else
        strcpy(szString,"( half duplex )");
      WinSetDlgItemText(hwndDlg,DCB_FULLDUP,szString);
      if (byTemp & F2_ENABLE_XMIT_XON_XOFF_FLOW)
        strcpy(szString,"Enable");
      else
        strcpy(szString,"Disable");
      WinSetDlgItemText(hwndDlg,DCB_TX_XON_HS,szString);
      sprintf(szString,"'\\x%02X'",pstDCB->XonChar);
      WinSetDlgItemText(hwndDlg,DCB_XON_CHAR,szString);
      sprintf(szString,"'\\x%02X'",pstDCB->XoffChar);
      WinSetDlgItemText(hwndDlg,DCB_XOFF_CHAR,szString);
      byTemp = pstDCB->Flags3;
      if (byTemp & F3_HDW_BUFFER_MASK)
        {
        switch (byTemp & F3_HDW_BUFFER_MASK)
          {
          case F3_HDW_BUFFER_DISABLE:
            strcpy(szString,"Disable FIFOs");
            break;
          case F3_HDW_BUFFER_ENABLE:
            strcpy(szString,"Enable FIFOs");
            break;
          case F3_HDW_BUFFER_APO:
            strcpy(szString,"Automatic Protocol Override");
            break;
          }
        WinSetDlgItemText(hwndDlg,DCB_FIFO,szString);
        switch (byTemp & F3_RECEIVE_TRIG_MASK)
          {
          case F3_1_CHARACTER_FIFO:
            strcpy(szString,"Low receive FIFO threshold");
            break;
          case F3_4_CHARACTER_FIFO:
            strcpy(szString,"Medium-low receive FIFO threshold");
            break;
          case F3_8_CHARACTER_FIFO:
            strcpy(szString,"Medium-high receive FIFO threshold");
            break;
          case F3_14_CHARACTER_FIFO:
            strcpy(szString,"High receive FIFO threshold");
            break;
          }
        WinSetDlgItemText(hwndDlg,DCB_RX_FIFO,szString);
        if (byTemp & F3_USE_TX_BUFFER)
          strcpy(szString,"Enable transmit FIFO");
        else
          strcpy(szString,"Disable transmit FIFO");
        WinSetDlgItemText(hwndDlg,DCB_TX_FIFO,szString);
        }
      else
        {
        strcpy(szString,"FIFOs unavailable or no change to FIFO processing");
        WinSetDlgItemText(hwndDlg,DCB_FIFO,szString);
        }
      if (byTemp & F3_INFINITE_WRT_TIMEOUT)
        strcpy(szString,"Infinite");
      else
        strcpy(szString,"Normal");
      WinSetDlgItemText(hwndDlg,DCB_WRT_TOPROC,szString);
      itoa(pstDCB->WrtTimeout,szString,10);
      WinSetDlgItemText(hwndDlg,DCB_WRT_TO,szString);
      switch (byTemp & F3_RTO_MASK)
        {
        case F3_WAIT_NORM:
          strcpy(szString,"Normal");
          break;
        case F3_WAIT_NONE:
          strcpy(szString,"No wait");
          break;
        case F3_WAIT_SOMETHING:
          strcpy(szString,"Wait for something");
          break;
        default:
          strcpy(szString,"Invalid");
          break;
        }
      WinSetDlgItemText(hwndDlg,DCB_READ_TOPROC,szString);
      itoa(pstDCB->ReadTimeout,szString,10);
      WinSetDlgItemText(hwndDlg,DCB_READ_TO,szString);
      return((MRESULT)FALSE);
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_OK:
          WinDismissDlg(hwndDlg,TRUE);
          return(MRESULT)TRUE;
        case DID_HELP:
          DisplayHelpPanel(HLPP_DCB_DLG);
          return((MRESULT)FALSE);
        case DID_CANCEL:
          WinDismissDlg(hwndDlg,FALSE);
          break;
        default:
          return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
        }
      return(FALSE);
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }


