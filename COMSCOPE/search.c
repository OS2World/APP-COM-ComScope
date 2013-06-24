#include "COMscope.h"

extern WORD *pwScrollBuffer;

extern SCREEN stRow;
extern SCREEN stRead;
extern SCREEN stWrite;

extern CSCFG stCFG;
extern CHARCELL stCell;
extern hwndClient;

extern LONG lScrollCount;
extern HWND hwndFrame;
BOOL bSearchInit = FALSE;

USHORT swSearchString[MAX_SEARCH_STRING];
LONG lSearchStrLen = 0;

LONG GetDisplayCount(LONG lSize);

BOOL SearchTraceEvent(WORD wTraceElement)
  {
  switch (wTraceElement & 0xff00)
    {
    case CS_READ:
      if (stCFG.bFindRead)
        return(TRUE);
      break;
    case CS_WRITE:
      if (stCFG.bFindWrite)
        return(TRUE);
      break;
    case CS_READ_IMM:
    case CS_WRITE_IMM:
      if (stCFG.bFindIMM)
        return(TRUE);
      break;
    case CS_READ_REQ:
    case CS_READ_CMPLT:
      if (stCFG.bFindReadReq)
        return(TRUE);
      break;
    case CS_MODEM_IN:
      if (stCFG.bFindModemIn)
        return(TRUE);
      break;
    case CS_READ_BUFF_OVERFLOW:
    case CS_HDW_ERROR:
    case CS_BREAK_RX:
      if (stCFG.bFindErrors)
        return(TRUE);
      break;
    case CS_WRITE_REQ:
    case CS_WRITE_CMPLT:
      if (stCFG.bFindWriteReq)
        return(TRUE);
      break;
    case CS_MODEM_OUT:
      if (stCFG.bFindModemOut)
        return(TRUE);
      break;
    case CS_DEVIOCTL:
      if (stCFG.bFindDevIOctl)
        return(TRUE);
      break;
    case CS_OPEN_ONE:
    case CS_OPEN_TWO:
    case CS_CLOSE_ONE:
    case CS_CLOSE_TWO:
      if (stCFG.bFindOpen)
        return(TRUE);
      break;
    case CS_BREAK_TX:
      if (stCFG.bFindDevIOctl)
        return(TRUE);
      break;
    }
  return(FALSE);
  }

LONG SearchCaptureBuffer(USHORT *pusBuffer,LONG lBufLength)
  {
  LONG lStartIndex;
  LONG lStrIndex;
  LONG lIndex;
  USHORT usDirection;
  USHORT usEvent;
  LONG lFoundIndex;
  LONG lCharCount;
  BYTE xSearchByte;
  char szHex[4];

  if (pusBuffer == NULL)
    return(-1);

  szHex[2] = 0;
  if (stCFG.bColumnDisplay)
    {
    if (stCFG.bFindString)
      usDirection = (pusBuffer[0] & 0xf000);
    else
      usDirection = 0;
    if (usDirection == CS_READ)
      lStartIndex = stRead.lScrollIndex;
    else
      {
      if (usDirection == CS_WRITE)
        lStartIndex = stWrite.lScrollIndex;
      else
        {
        if (stRead.lScrollIndex > stWrite.lScrollIndex)
          {
          if (stCFG.bFindForward)
            lStartIndex = stWrite.lScrollIndex;
          else
            lStartIndex = stRead.lScrollIndex;
          }
        else
          {
          if (stCFG.bFindForward)
            lStartIndex = stRead.lScrollIndex;
          else
            lStartIndex = stWrite.lScrollIndex;
          }
        }
      }
    }
  else
    lStartIndex = stRow.lScrollIndex;
  usDirection = (swSearchString[0] & 0xff00);
  if (stCFG.bFindForward)
    {
    lStartIndex++;
    if (lStartIndex > lBufLength)
      return(-1);
    lStrIndex = 0;
    for (lIndex = lStartIndex;lIndex < lBufLength;lIndex++)
      {
      usEvent = pusBuffer[lIndex];
      if (SearchTraceEvent(usEvent))
        goto gtGotIndex;
      if (stCFG.bFindString)
        {
        if ((usEvent & 0xff00) == usDirection)
          {
          xSearchByte = (BYTE)swSearchString[lStrIndex++];
          if (xSearchByte == '\\')
            {
            if ((BYTE)swSearchString[lStrIndex] == 'x')
              {
              lStrIndex++;
              szHex[0] = (BYTE)swSearchString[lStrIndex++];
              szHex[1] = (BYTE)swSearchString[lStrIndex++];
              xSearchByte = (BYTE)strtol(szHex,NULL,16);
              }
            else
              if ((BYTE)swSearchString[lStrIndex] == '\\')
                lStrIndex++;
            }
          if (!stCFG.bFindStrNoCase)
            {
            if (xSearchByte != (BYTE)usEvent)
              lStrIndex = 0;
            else
              {
              if (lStrIndex == 1)
                lFoundIndex = lIndex;
              if (lStrIndex >= lSearchStrLen)
                {
                lIndex = lFoundIndex;
                goto gtGotIndex;
                }
              }
            }
          else
            {
            if (toupper((BYTE)swSearchString[lStrIndex++]) != toupper((BYTE)usEvent))
              lStrIndex = 0;
            else
              {
              if (lStrIndex == 1)
                lFoundIndex = lIndex;
              if (lStrIndex >= lSearchStrLen)
                {
                lIndex = lFoundIndex;
                goto gtGotIndex;
                }
              }
            }
          }
        }
      }
    }
  else
    {
    lStartIndex--;
    if (lStartIndex < 0)
      return(-1);
    lStrIndex = lSearchStrLen;
    for (lIndex = lStartIndex;lIndex >= 0;lIndex--)
      {
      usEvent = pusBuffer[lIndex];
      if (SearchTraceEvent(usEvent))
        goto gtGotIndex;
      if (stCFG.bFindString)
        {
        if ((usEvent & 0xff00) == usDirection)
          {
          if (!stCFG.bFindStrNoCase)
            {
            if (swSearchString[--lStrIndex] != pusBuffer[lIndex])
              lStrIndex = lSearchStrLen;
            }
          else
            {
            if (toupper((BYTE)swSearchString[--lStrIndex]) != toupper((BYTE)pusBuffer[lIndex]))
              lStrIndex = lSearchStrLen;
            }
          if (lStrIndex <= 0)
            goto gtGotIndex;
          }
        }
      }
    }
  if (stCFG.bFindWrap)
    {
    if (stCFG.bFindForward)
      {
      lStrIndex = 0;
      for (lIndex = 0;lIndex <= lStartIndex;lIndex++)
        {
        usEvent = pusBuffer[lIndex];
        if (SearchTraceEvent(usEvent))
          goto gtGotIndex;
        if (stCFG.bFindString)
          {
          if ((usEvent & 0xff00) == usDirection)
            {
            if (!stCFG.bFindStrNoCase)
              {
              if (swSearchString[lStrIndex++] != usEvent)
                lStrIndex = 0;
              else
                {
                if (lStrIndex == 1)
                  lFoundIndex = lIndex;
                if (lStrIndex >= lSearchStrLen)
                  {
                  lIndex = lFoundIndex;
                  goto gtGotIndex;
                  }
                }
              }
            else
              {
              if (toupper((BYTE)swSearchString[lStrIndex++]) != toupper((BYTE)usEvent))
                lStrIndex = 0;
              else
                {
                if (lStrIndex == 1)
                  lFoundIndex = lIndex;
                if (lStrIndex >= lSearchStrLen)
                  {
                  lIndex = lFoundIndex;
                  goto gtGotIndex;
                  }
                }
              }
            }
          }
        }
      }
    else
      {
      lStrIndex = lSearchStrLen;
      for (lIndex = (lBufLength - 1);lIndex >= lStartIndex;lIndex--)
        {
        usEvent = pusBuffer[lIndex];
        if (SearchTraceEvent(usEvent))
          goto gtGotIndex;
        if (stCFG.bFindString)
          {
          if ((usEvent & 0xff00) == usDirection)
            {
            if (!stCFG.bFindStrNoCase)
              {
              if (swSearchString[--lStrIndex] != usEvent)
                lStrIndex = lSearchStrLen;
              }
            else
              {
              if (toupper((BYTE)swSearchString[--lStrIndex]) != toupper((BYTE)usEvent))
                lStrIndex = lSearchStrLen;
              }
            if (lStrIndex <= 0)
              goto gtGotIndex;
            }
          }
        }
      }
    }
  return(-1);

gtGotIndex:
  if (stCFG.bColumnDisplay)
    {
    stRead.lScrollIndex = lIndex;
    lCharCount = GetDisplayCount(lIndex);
    stRead.lScrollRow = (lCharCount / stRead.lCharWidth);
    if (stRead.hwndScroll != 0)
      WinSendMsg(stRead.hwndScroll,SBM_SETSCROLLBAR,MPFROMSHORT(stRead.lScrollRow),MPFROM2SHORT(0,stRead.lScrollRowCount));
    WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
    stWrite.lScrollIndex = lIndex;
    lCharCount = GetDisplayCount(lIndex);
    stWrite.lScrollRow = (lCharCount / stWrite.lCharWidth);
    if (stWrite.hwndScroll != 0)
      WinSendMsg(stWrite.hwndScroll,SBM_SETSCROLLBAR,MPFROMSHORT(stWrite.lScrollRow),MPFROM2SHORT(0,stWrite.lScrollRowCount));
    WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
    }
  else
    {
    stRow.lScrollIndex = lIndex;
    lCharCount = GetDisplayCount(lIndex);
    stRow.lScrollRow = (lCharCount / stRow.lCharWidth);
    WinSendMsg(stRow.hwndScroll,SBM_SETSCROLLBAR,MPFROMSHORT(stRow.lScrollRow),MPFROM2SHORT(0,stRow.lScrollRowCount));
    }
  return(lIndex);
  }

MRESULT EXPENTRY fnwpSearchConfigDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static CSCFG *pstCFG;
  static bAllowClick;
  char szSearchString[MAX_SEARCH_STRING  + 2];
  static usDirection;
  char szHexByte[4];
  LONG lIndex;
  LONG lHexIndex;
  char szMessage[200];
  LONG lLen;

  switch (msg)
    {
    case WM_INITDLG:
      CenterDlgBox(hwndDlg);
//      WinSetFocus(HWND_DESKTOP,hwndDlg);
      pstCFG = PVOIDFROMMP(mp2);
      bAllowClick = FALSE;
      WinSendDlgItemMsg(hwndDlg,FIND_STR,EM_SETTEXTLIMIT,MPFROMSHORT(MAX_SEARCH_STRING),(MPARAM)NULL);
      usDirection = CS_READ;
      if (pstCFG->bFindStrNoCase)
        CheckButton(hwndDlg,FIND_STR_NO_CASE,TRUE);
      if (pstCFG->bFindStrHEX)
        CheckButton(hwndDlg,FIND_STR_HEX,TRUE);
      else
        CheckButton(hwndDlg,FIND_STR_ASCII,TRUE);
      if (lSearchStrLen > 0)
        {
        if (pstCFG->bFindStrHEX)
          {
          ControlEnable(hwndDlg,FIND_STR_NO_CASE,FALSE);
          lHexIndex = 0;
          for (lIndex = 0;lIndex < lSearchStrLen;lIndex++)
            {
            sprintf(&szSearchString[lHexIndex],"%02X",(swSearchString[lIndex] & 0x00ff));
            lHexIndex += 2;
            }
          szSearchString[lHexIndex] = 0;
          }
        else
          {
          for (lIndex = 0;lIndex < lSearchStrLen;lIndex++)
            szSearchString[lIndex] = (BYTE)swSearchString[lIndex];
          szSearchString[lIndex] = 0;
          }
        WinSetDlgItemText(hwndDlg,FIND_STR,szSearchString);
        if (pstCFG->bFindString)
          {
          usDirection = (swSearchString[0] & 0xff00);
          if (usDirection == CS_READ)
            CheckButton(hwndDlg,FIND_STR_RX,TRUE);
          else
            CheckButton(hwndDlg,FIND_STR_TX,TRUE);
          }
        else
          {
          CheckButton(hwndDlg,FIND_STR_NONE,TRUE);
          ControlEnable(hwndDlg,FIND_STR,FALSE);
          ControlEnable(hwndDlg,FIND_STR_ASCII,FALSE);
          ControlEnable(hwndDlg,FIND_STR_NO_CASE,FALSE);
          ControlEnable(hwndDlg,FIND_STR_HEX,FALSE);
          }
        }
      else
        {
        CheckButton(hwndDlg,FIND_STR_NONE,TRUE);
        ControlEnable(hwndDlg,FIND_STR,FALSE);
        ControlEnable(hwndDlg,FIND_STR_ASCII,FALSE);
        ControlEnable(hwndDlg,FIND_STR_NO_CASE,FALSE);
        ControlEnable(hwndDlg,FIND_STR_HEX,FALSE);
        }
      if (pstCFG->bFindStrHEX)
        CheckButton(hwndDlg,FIND_STR_HEX,TRUE);
      else
        CheckButton(hwndDlg,FIND_STR_ASCII,TRUE);
      if (pstCFG->bFindWrap)
        CheckButton(hwndDlg,FIND_WRAP,TRUE);
      if (pstCFG->bFindForward)
        CheckButton(hwndDlg,FIND_NEXT,TRUE);
      else
        CheckButton(hwndDlg,FIND_PREVIOUS,TRUE);
      if (pstCFG->bFindModemIn)
        CheckButton(hwndDlg,FIND_MODEMIN,TRUE);
      if (pstCFG->bFindModemOut)
        CheckButton(hwndDlg,FIND_MODEMOUT,TRUE);
      if (pstCFG->bFindWriteReq)
        CheckButton(hwndDlg,FIND_WRITE_REQ,TRUE);
      if (pstCFG->bFindReadReq)
        CheckButton(hwndDlg,FIND_READ_REQ,TRUE);
      if (pstCFG->bFindDevIOctl)
        CheckButton(hwndDlg,FIND_DEVIOCTL,TRUE);
      if (pstCFG->bFindErrors)
        CheckButton(hwndDlg,FIND_ERRORS,TRUE);
      if (pstCFG->bFindOpen)
        CheckButton(hwndDlg,FIND_OPEN,TRUE);
      if (pstCFG->bFindRead)
        CheckButton(hwndDlg,FIND_RCV,TRUE);
      if (pstCFG->bFindWrite)
        CheckButton(hwndDlg,FIND_XMIT,TRUE);
      if (pstCFG->bFindIMM)
        CheckButton(hwndDlg,FIND_IMM,TRUE);
      WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      return((MRESULT)FALSE);
    case UM_INITLS:
      bAllowClick = TRUE;
      return((MRESULT)FALSE);
    case WM_CONTROL:
      if ((SHORT2FROMMP(mp1) == BN_CLICKED) && bAllowClick)
        {
        switch (SHORT1FROMMP(mp1))
          {
          case FIND_STR_HEX:
            if (!Checked(hwndDlg,FIND_STR_HEX))
              {
              CheckButton(hwndDlg,FIND_STR_HEX,TRUE);
              CheckButton(hwndDlg,FIND_STR_ASCII,FALSE);
              ControlEnable(hwndDlg,FIND_STR_NO_CASE,FALSE);
              }
            break;
          case FIND_STR_ASCII:
            if (!Checked(hwndDlg,FIND_STR_ASCII))
              {
              CheckButton(hwndDlg,FIND_STR_ASCII,TRUE);
              CheckButton(hwndDlg,FIND_STR_HEX,FALSE);
              ControlEnable(hwndDlg,FIND_STR_NO_CASE,TRUE);
              }
            break;
          case FIND_STR_NONE:
            if (!Checked(hwndDlg,FIND_STR_NONE))
              {
              CheckButton(hwndDlg,FIND_STR_NONE,TRUE);
              CheckButton(hwndDlg,FIND_STR_RX,FALSE);
              CheckButton(hwndDlg,FIND_STR_TX,FALSE);
              ControlEnable(hwndDlg,FIND_STR,FALSE);
              ControlEnable(hwndDlg,FIND_STR_ASCII,FALSE);
              ControlEnable(hwndDlg,FIND_STR_HEX,FALSE);
              ControlEnable(hwndDlg,FIND_STR_NO_CASE,FALSE);
              }
            break;
          case FIND_STR_RX:
            if (!Checked(hwndDlg,FIND_STR_RX))
              {
              CheckButton(hwndDlg,FIND_STR_RX,TRUE);
              CheckButton(hwndDlg,FIND_STR_TX,FALSE);
              if (Checked(hwndDlg,FIND_STR_NONE))
                {
                if (Checked(hwndDlg,FIND_STR_ASCII))
                  ControlEnable(hwndDlg,FIND_STR_NO_CASE,TRUE);
                CheckButton(hwndDlg,FIND_STR_NONE,FALSE);
                ControlEnable(hwndDlg,FIND_STR,TRUE);
                ControlEnable(hwndDlg,FIND_STR_ASCII,TRUE);
                ControlEnable(hwndDlg,FIND_STR_HEX,TRUE);
                }
              }
            break;
          case FIND_STR_TX:
            if (!Checked(hwndDlg,FIND_STR_TX))
              {
              CheckButton(hwndDlg,FIND_STR_TX,TRUE);
              CheckButton(hwndDlg,FIND_STR_RX,FALSE);
              if (Checked(hwndDlg,FIND_STR_NONE))
                {
                if (Checked(hwndDlg,FIND_STR_ASCII))
                  ControlEnable(hwndDlg,FIND_STR_NO_CASE,TRUE);
                CheckButton(hwndDlg,FIND_STR_NONE,FALSE);
                ControlEnable(hwndDlg,FIND_STR,TRUE);
                ControlEnable(hwndDlg,FIND_STR_ASCII,TRUE);
                ControlEnable(hwndDlg,FIND_STR_HEX,TRUE);
                }
              }
            break;
          default:
             return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
          }
        return(FALSE);
        }
      break;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_OK:
          if ((lSearchStrLen = WinQueryDlgItemText(hwndDlg,FIND_STR,MAX_SEARCH_STRING,szSearchString)) == 0)
            {
            if (!Checked(hwndDlg,FIND_STR_NONE))
              if (WinMessageBox(HWND_DESKTOP,hwndDlg,"No character sequence will be searched","A character sequence was not entered.",0,(MB_OKCANCEL | MB_INFORMATION)) == MBID_CANCEL)
                return((MRESULT)TRUE);
            pstCFG->bFindString = FALSE;
            }
          else
            {
            if (Checked(hwndDlg,FIND_STR_NONE))
              pstCFG->bFindString = FALSE;
            else
              {
              pstCFG->bFindString = TRUE;
              if (Checked(hwndDlg,FIND_STR_NO_CASE))
                pstCFG->bFindStrNoCase = TRUE;
              else
                pstCFG->bFindStrNoCase = FALSE;
              if (Checked(hwndDlg,FIND_STR_RX))
                usDirection = CS_READ;
              else
                usDirection = CS_WRITE;
              if (Checked(hwndDlg,FIND_STR_HEX))
                {
                if (lSearchStrLen % 2)
                  {
                  lLen = sprintf(szMessage,"A zero will be assumed before the last digit.\n\n%s will changed to ",szSearchString);
                  szSearchString[lSearchStrLen] = szSearchString[lSearchStrLen - 1];
                  szSearchString[lSearchStrLen - 1] = '0';
                  szSearchString[++lSearchStrLen] = 0;
                  strcpy(&szMessage[lLen],szSearchString);
                  if (WinMessageBox(HWND_DESKTOP,hwndDlg,szMessage,"An even number of digits were not entered.",0,(MB_OKCANCEL | MB_INFORMATION)) == MBID_CANCEL)
                    return((MRESULT)TRUE);
                  }
                stCFG.bFindStrHEX = TRUE;
                szHexByte[2] = 0;
                for (lIndex = 0;lIndex < lSearchStrLen ;lIndex += 2)
                  {
                  if (!isxdigit(szSearchString[lIndex]) || !isxdigit(szSearchString[lIndex + 1]))
                    {
                    MessageBox(hwndDlg,"Invalid charcters in string.\n\nAt least on of the characters in the search string is not a Hexadecimal number.");
                    return((MRESULT)TRUE);
                    }
                  szHexByte[0] = szSearchString[lIndex];
                  szHexByte[1] = szSearchString[lIndex + 1];
                  swSearchString[lIndex / 2] = (USHORT)(strtol(szHexByte,0,16) | usDirection);
                  }
                lSearchStrLen /= 2;
                }
              else
                {
                stCFG.bFindStrHEX = FALSE;
                for (lIndex = 0;lIndex < lSearchStrLen;lIndex++)
                  swSearchString[lIndex] = ((USHORT)(szSearchString[lIndex]) | usDirection);
                }
              }
            }
          if (Checked(hwndDlg,FIND_WRAP))
            pstCFG->bFindWrap = TRUE;
          else
            pstCFG->bFindWrap = FALSE;

          if (Checked(hwndDlg,FIND_NEXT))
            pstCFG->bFindForward = TRUE;
          else
            pstCFG->bFindForward = FALSE;

          if (Checked(hwndDlg,FIND_MODEMIN))
            pstCFG->bFindModemIn = TRUE;
          else
            pstCFG->bFindModemIn = FALSE;

          if (Checked(hwndDlg,FIND_MODEMOUT))
            pstCFG->bFindModemOut = TRUE;
          else
            pstCFG->bFindModemOut = FALSE;

          if (Checked(hwndDlg,FIND_WRITE_REQ))
            pstCFG->bFindWriteReq = TRUE;
          else
            pstCFG->bFindWriteReq = FALSE;

          if (Checked(hwndDlg,FIND_READ_REQ))
            pstCFG->bFindReadReq = TRUE;
          else
            pstCFG->bFindReadReq = FALSE;

          if (Checked(hwndDlg,FIND_DEVIOCTL))
            pstCFG->bFindDevIOctl = TRUE;
          else
            pstCFG->bFindDevIOctl = FALSE;

          if (Checked(hwndDlg,FIND_ERRORS))
            pstCFG->bFindErrors = TRUE;
          else
            pstCFG->bFindErrors = FALSE;

          if (Checked(hwndDlg,FIND_OPEN))
            pstCFG->bFindOpen = TRUE;
          else
            pstCFG->bFindOpen = FALSE;

          if (Checked(hwndDlg,FIND_RCV))
            pstCFG->bFindRead = TRUE;
          else
            pstCFG->bFindRead = FALSE;

          if (Checked(hwndDlg,FIND_XMIT))
            pstCFG->bFindWrite = TRUE;
          else
            pstCFG->bFindWrite = FALSE;

          if (Checked(hwndDlg,FIND_IMM))
            pstCFG->bFindIMM = TRUE;
          else
            pstCFG->bFindIMM = FALSE;
          bSearchInit = TRUE;
          WinDismissDlg(hwndDlg,TRUE);
          return(MRESULT)TRUE;
        case DID_HELP:
          DisplayHelpPanel(HLPP_FIND_DLG);
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





