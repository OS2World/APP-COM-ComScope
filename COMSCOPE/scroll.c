#include "COMscope.h"

#if DEBUG > 0
void DisplayLastWindowError(char szMsg[]);
#endif

WORD *pwScrollBuffer = NULL;
LONG lScrollCount;
BOOL bScrolling = FALSE;
LONG fLastScroll = 0;

extern LONG lStatusHeight;

extern SCREEN stRow;

extern CSCFG stCFG;
extern CHARCELL stCell;
extern hwndClient;

extern SCREEN stRead;
extern SCREEN stWrite;

extern HWND hwndFrame;

extern HMTX hmtxRowGioBlockedSem;

static LONG GetPartialCharCount(SCREEN *pstScreen,LONG lStartIndex,LONG lCharCount);
static VOID CalcScrollEndIndex(SCREEN *pstScreen);
static void SetScrollRowCount(SCREEN *pstScreen);
static void SetColScrollRowCount(SCREEN *pstScreen);
static LONG GetColScrollIndex(SCREEN *pstScreen,LONG lRowCount);
static VOID CalcColScrollEndIndex(SCREEN *pstScreen);
/*
** Returns zero of data should not be displayed, returns one if the data should be displayed, and returns other
** value when the "event" is CA_PACKET_DATA.  The second byte of the "event" word is the count of packet data words
** following the "event" word.  Data count will never be zero.
*/
ULONG CountTraceElement(WORD wTraceElement,WORD wDirection)
  {
  WORD wEvent;

  if (((wDirection & (CS_READ | CS_WRITE)) == (CS_READ | CS_WRITE)) ||
      ((wDirection & 0xff00) == CS_PACKET_DATA))
    {
    wEvent = (wTraceElement & 0xff00);
    switch (wEvent)
      {
      case CS_READ:
        if (stCFG.bDispRead)
          return(1);
        break;
      case CS_READ_IMM:
      case CS_WRITE_IMM:
        if (stCFG.bDispIMM)
          return(1);
        break;
      case CS_READ_REQ:
      case CS_READ_CMPLT:
        if (stCFG.bDispReadReq)
          return(1);
        break;
      case CS_MODEM_IN:
        if (stCFG.bDispModemIn)
          return(1);
        break;
      case CS_READ_BUFF_OVERFLOW:
      case CS_HDW_ERROR:
      case CS_BREAK_RX:
        if (stCFG.bDispErrors)
          return(1);
        break;
      case CS_WRITE:
        if (stCFG.bDispWrite)
          return(1);
        break;
      case CS_WRITE_REQ:
      case CS_WRITE_CMPLT:
        if (stCFG.bDispWriteReq)
          return(1);
        break;
      case CS_MODEM_OUT:
        if (stCFG.bDispModemOut)
          return(1);
        break;
      case CS_DEVIOCTL:
        if (stCFG.bDispDevIOctl)
          return(1);
        break;
      case CS_OPEN_ONE:
      case CS_OPEN_TWO:
      case CS_CLOSE_ONE:
      case CS_CLOSE_TWO:
        if (stCFG.bDispOpen)
          return(1);
        break;
      case CS_PACKET_DATA:
        /*
        ** Add 1 here to insure that anytime there is packet data, something other that zero or one is returned.
        **
        ** A return value of zero means "don't display", one means display data, anything else means that this element
        ** is packet data and the value returned is the number of words that represent the data, including the packet
        ** data indicator word (this byte).  A packet data size of zero is not supposed to occur.
        **
        ** I am leaving it up to the calling function to adjust an index (if necessary) because: 1) I don't have to pass a
        ** pointer to the index, and 2) the calling function may not need to adjust an index.
        */
        return((ULONG)(wTraceElement & 0x00ff) + 1);
      case CS_BREAK_TX:
        if (stCFG.bDispDevIOctl)
          return(1);
        break;
      }
    return(0);
    }
  wEvent = ((wTraceElement & 0x0f00) >> 8);
  if (wDirection & CS_READ)
    {
    switch (wEvent)
      {
      case 0:
        if (stCFG.bDispRead)
          return(1);
        break;
      case 1:
        if (stCFG.bDispIMM)
          return(1);
        break;
      case 2:                    // CS_READ_REQ
      case 3:                    // CS_READ_COMPL
        if (stCFG.bDispReadReq)
          return(1);
        break;
      case 4:
        if (stCFG.bDispModemIn)
          return(1);
        break;
      case 5:                    // CS_READ_BUFF_OVERFLOW
      case 6:                    // CS_HWD_ERROR
      case 7:                    // CS_BREAK_RX
        if (stCFG.bDispErrors)
          return(1);
        break;
      }
    return(0);
    }
  if (wDirection & CS_WRITE)
    {
    switch (wEvent)
      {
      case 0:
        if (stCFG.bDispWrite)
          return(1);
        break;
      case 1:
        if (stCFG.bDispIMM)
          return(1);
        break;
      case 2:                  // CS_WRITE_REQ
      case 3:                  // CS_WRITE_COMPL
        if (stCFG.bDispWriteReq)
          return(1);
        break;
      case 4:
        if (stCFG.bDispModemOut)
          return(1);
        break;
      case 5:                   // CS_DEVIOCTL
        if (stCFG.bDispDevIOctl)
          return(1);
        break;
      case 6:                   // CS_OPEN_ONE
      case 7:                   // CS_OPEN_TWO
      case 8:                   // CS_CLOSE_ONE
      case 9:                   // CS_CLOSE_TWO
        if (stCFG.bDispOpen)
          return(1);
        break;
      case 10:                  // CS_BREAK_TX
        if (stCFG.bDispDevIOctl)
          return(1);
        break;
      }
    }
  return(0);
  }

LONG GetDisplayCount(LONG lSize)
  {
  LONG lIndex;
  LONG lCharCount;
  ULONG ulIncrement;

  if (pwScrollBuffer == NULL)
    return(0);
  lCharCount = 0;
  lIndex = 0;
  while (lIndex < lSize)
    {
    if ((ulIncrement = CountTraceElement(pwScrollBuffer[lIndex],(CS_READ | CS_WRITE))) == 1)
      lCharCount++;
    if (ulIncrement > 1)
      lIndex += ulIncrement;
    else
      lIndex++;
    }
  return(lCharCount);
  }

void SetScrollRowCount(SCREEN *pstScreen)
  {
  LONG lActualCharCount;
  LONG lIndex;
  WORD wDirection;
  WORD wLastDirection;
  LONG lRowCount;
  LONG lRowCountedAt;
  ULONG ulElementCount;

  if (pwScrollBuffer == NULL)
    {
    pstScreen->lScrollRowCount = 0;
    return;
    }
  lActualCharCount = 0;
  lRowCount = 0;
  lRowCountedAt = -1;
  CalcScrollEndIndex(pstScreen);
#ifdef this_junk
  if (stCFG.bCompressDisplay)
    {
    wLastDirection = CS_READ;
    lIndex = 0;
    while (lIndex < pstScreen->lScrollEndIndex)
      {
      if ((lActualCharCount % pstScreen->lCharWidth) == 0)
        {
        if (lRowCountedAt != lActualCharCount)
          {
          lRowCountedAt = lActualCharCount;
          wLastDirection = CS_READ;
          lRowCount++;
          }
        }
      wDirection = pwScrollBuffer[lIndex];
      if ((ulElementCount = CountTraceElement(wLastDirection,CS_WRITE)) == 1)
        lActualCharCount++;
      else
        if ((ulElementCount = CountTraceElement(wDirection,CS_READ)) == 1)
          lActualCharCount++;
      if (ulElementCount > 1)
         lIndex += ulElementCount;
      else
         lIndex++;
      wLastDirection = (wDirection & 0xf000);
      }
    }
  else
#endif
    {
    lIndex = 0;
    while (lIndex < lScrollCount)
      {
      if ((ulElementCount = CountTraceElement(pwScrollBuffer[lIndex],(CS_READ | CS_WRITE))) == 1)
        lActualCharCount++;
      if (ulElementCount > 1)
         lIndex += ulElementCount;
      else
         lIndex++;
      }
    lRowCount = (lActualCharCount / pstScreen->lCharWidth);
    if ((lActualCharCount % pstScreen->lCharWidth) != 0)
      lRowCount++;
    }
  pstScreen->lScrollRowCount = lRowCount;
  }

LONG GetRowScrollRow(SCREEN *pstScreen)
  {
  LONG lActualCharCount;
  LONG lIndex;
  WORD wDirection;
  WORD wLastDirection;
  LONG lRowCountedAt;
  ULONG ulElementCount;
  LONG lRowCount;

  if (pwScrollBuffer == NULL)
    return(0);
  lRowCount = 0;
  lActualCharCount = 0;
#ifdef this_junk
  if (stCFG.bCompressDisplay)
    {
    lRowCountedAt = -1;
    wLastDirection = CS_READ;
    lIndex = 0;
    while (lIndex < pstScreen->lScrollIndex)
      {
      if ((lActualCharCount % pstScreen->lCharWidth) == 0)
        {
        if (lRowCountedAt != lActualCharCount)
          {
          lRowCountedAt = lActualCharCount;
          wLastDirection = CS_READ;
          lRowCount++;
          }
        }
      wDirection = pwScrollBuffer[lIndex];
      if ((ulElementCount = CountTraceElement(wLastDirection,CS_WRITE)) == 1)
        lActualCharCount++;
      else
        if ((ulElementCount = CountTraceElement(wDirection,CS_READ)) == 1)
          lActualCharCount++;
      if (ulElementCount > 1)
        lIndex += ulElementCount;
      else
        lIndex++;
      wLastDirection = (wDirection & 0xf000);
      }
    }
  else
#endif
    {
    lIndex = 0;
    while (lIndex < pstScreen->lScrollIndex)
      {
      if ((ulElementCount = CountTraceElement(pwScrollBuffer[lIndex],(CS_READ | CS_WRITE))) == 1)
        lActualCharCount++;
      if (ulElementCount > 1)
        lIndex += ulElementCount;
      else
        lIndex++;
      }
    lRowCount = (lActualCharCount / pstScreen->lCharWidth);
    if ((lActualCharCount % pstScreen->lCharWidth) != 0)
      lRowCount++;
    }
  return(lRowCount);
  }

VOID CalcScrollEndIndex(SCREEN *pstScreen)
  {
  LONG lGoal;
  LONG lTemp = 0;
  SHORT sRowCount;
  SHORT sIndex;
  LONG lScrollEndIndex;
  LONG lDisplayChars;
  ULONG ulElementCount;

  lDisplayChars = GetDisplayCount(lScrollCount);
  lGoal = lDisplayChars;
//  lGoal = lScrollCount;
  lTemp = pstScreen->lScrollIndex;
  pstScreen->lScrollIndex = lScrollCount;
  sRowCount = GetRowScrollRow(pstScreen);
  pstScreen->lScrollIndex = lTemp;
  if (sRowCount <= pstScreen->lCharHeight)
    {
    lScrollEndIndex = 0;
    while (lScrollEndIndex < lScrollCount)
      {
      if ((ulElementCount = CountTraceElement(pwScrollBuffer[lScrollEndIndex],(CS_READ | CS_WRITE))) == 1)
        break;
      if (ulElementCount > 1)
        lScrollEndIndex += ulElementCount;
      else
        lScrollEndIndex++;
      }
    if (lScrollEndIndex >= lScrollCount)
      lScrollEndIndex = 0;
    return;
    }
  if (pstScreen->lCharWidth > 0)
    {
#ifdef this_junk
    if (stCFG.bCompressDisplay)
      {
      lGoal = GetPartialCharCount(pstScreen,lScrollCount,-pstScreen->lCharSize);
      for (sIndex = 0;sIndex < sRowCount;sIndex++)
        {
        lTemp = GetPartialCharCount(pstScreen,lTemp,pstScreen->lCharWidth);
        if (lTemp >= lGoal)
          break;
        }
      lScrollEndIndex = lTemp;
      }
    else
#endif
      lScrollEndIndex = GetPartialCharCount(pstScreen,lScrollCount,-pstScreen->lCharSize);

    if (lScrollEndIndex < 0L)
      lScrollEndIndex = 0L;
    }
  pstScreen->lScrollEndIndex = lScrollEndIndex;
  }

LONG GetPartialCharCount(SCREEN *pstScreen,LONG lStartIndex,LONG lCharCount)
  {
  LONG lLogicalCharCount = 0;
  LONG lIndex;
  WORD wDirection;
  WORD wLastDirection;
  WORD *pwBuffer;
  LONG lEndIndex;
  ULONG ulElementCount;
  LONG lRetraceIndex;
  LONG lRetraceCount;
  BOOL bCharValid;

  if (pwScrollBuffer == NULL)
    return(0);
 #ifdef this_junk
  if (stCFG.bCompressDisplay)
    {
    if (lCharCount > 0)
      {
      pwBuffer = &pwScrollBuffer[lStartIndex];
      wLastDirection = CS_READ;
      lIndex = 0;
      while (lIndex < (stCFG.lBufferLength - lStartIndex))
        {
        wDirection = (*(pwBuffer++) & 0xff00);
        if ((ulElementCount = CountTraceElement(wLastDirection,CS_WRITE)) == 1)
          lLogicalCharCount++;
        else
          if ((ulElementCount = CountTraceElement(wDirection,CS_READ)) == 1)
            lLogicalCharCount++;
        if (ulElementCount > 1)
          lIndex += ulElementCount;
        else
          lIndex++;
        if (lLogicalCharCount >= lCharCount)
          break;
        wLastDirection = (wDirection & 0xf000);
        }
      lIndex++;
      }
    else
      {
      if (lStartIndex <= 0)
        return(0);
      wLastDirection = CS_WRITE;
      for (lIndex = (lStartIndex - 1);lIndex >= 0;lIndex--)
        {
        wDirection = (pwScrollBuffer[lIndex] & 0xff00);
        bCharValid = FALSE;
        if ((ulElementCount = CountTraceElement(wDirection,CS_READ)) == 1)
          {
          lCharCount++;
          bCharValid = TRUE;
          }
        else
          if (ulElementCount == 0)
            {
            if ((ulElementCount = CountTraceElement(wLastDirection,CS_WRITE)) == 1)
              {
              lCharCount++;
              bCharValid = TRUE;
              }
            else
              wLastDirection = pwScrollBuffer[lIndex];
            }
        if (ulElementCount > 1)
          for (lRetraceIndex = (lIndex + 1);lRetraceIndex < (wLastDirection & 0xff00);lRetraceIndex++)
            if (CountTraceElement((wLastDirection & 0xff00),(CS_WRITE | CS_READ)) == 1)
              lCharCount--;
        if (bCharValid && (lCharCount >= 0))
          {
          if (CountTraceElement(wDirection,CS_READ) == 1)
            if (lIndex > 0)
              if ((pwScrollBuffer[lIndex - 1] & 0xf000) != CS_READ)
                lIndex--;
          break;
          }
        wLastDirection = (wDirection & 0xf000);
        }
      if (lIndex <= 0)
        lIndex = -lStartIndex;
      else
        lIndex = (lIndex - lStartIndex);
      }
    return(lIndex);
    }
  else
#endif
    {
    lEndIndex = pstScreen->lScrollEndIndex;
    if (lCharCount > 0)
      {
      lIndex = lStartIndex;
      while (lIndex < lEndIndex)
        {
        if ((ulElementCount = CountTraceElement(pwScrollBuffer[lIndex],(CS_READ | CS_WRITE))) == 1)
          if (lCharCount-- <= 0)
            break;
        if (ulElementCount > 1)
          lIndex += ulElementCount;
        else
          lIndex++;
        }
      }
    else
      {
      if (lStartIndex > 0)
        {
        for (lIndex = (lStartIndex - 1);lIndex >= 0;lIndex--)
          {
          if ((ulElementCount = CountTraceElement(pwScrollBuffer[lIndex],(CS_READ | CS_WRITE))) == 1)
            if (++lCharCount >= 0)
              break;
          if (ulElementCount > 1)
            {
            lRetraceCount = (pwScrollBuffer[lIndex] & 0x00ff);
            for (lRetraceIndex = (lIndex + 1);lRetraceIndex < lRetraceCount;lRetraceIndex++)
              if (CountTraceElement((pwScrollBuffer[lRetraceIndex] & 0xff00),(CS_WRITE | CS_READ)) == 1)
                lCharCount--;
            }
          }
#ifdef this_junk
        if (lCharCount != 0)
          {
          lIndex = 0;
          for (lIndex < lEndIndex)
            {
            if ((ulElementCount = CountTraceElement(pwScrollBuffer[lIndex],(CS_READ | CS_WRITE))) == 1)
              break;
            if (ulElementCount > 1)
              lIndex += ulElementCount;
            else
              lIndex++;
            )
          }
#endif
        }
      else
        lIndex = 0;
      }
    return(lIndex);
    }
  }

void ClearRowScrollBar(SCREEN *pstScreen)
  {
  if (pstScreen->hwndScroll != (HWND)NULL)
    {
    WinDestroyWindow(pstScreen->hwndScroll);
    pstScreen->hwndScroll = (HWND)NULL;
    pstScreen->lWidth += stCell.cx;
    pstScreen->lCharWidth += 1;
    pstScreen->lCharSize = (pstScreen->lCharWidth * pstScreen->lCharHeight);
    }
  }

void SetupRowScrolling(SCREEN *pstScreen)
  {
  ClearRowScrollBar(pstScreen);
  pstScreen->hwndScroll = WinCreateWindow(pstScreen->hwndClient,
                                          WC_SCROLLBAR,
                                     (PSZ)NULL,
                                          SBS_VERT | WS_VISIBLE,
                                          pstScreen->lWidth,
                                          (lStatusHeight - 1),
                                          (stCell.cx + 1),
                                          (pstScreen->lHeight - 2),
                                          pstScreen->hwndClient,
                                          HWND_TOP,
                                          WID_VSCROLL_BAR,
                                          NULL,NULL);
  if (pstScreen->hwndScroll != (HWND)NULL)
    {
    pstScreen->lWidth -= stCell.cx;
    pstScreen->lCharWidth -= 1;
    pstScreen->lCharSize = (pstScreen->lCharWidth * pstScreen->lCharHeight);
    SetScrollRowCount(pstScreen);
    WinSendMsg(pstScreen->hwndScroll,
               SBM_SETSCROLLBAR,
               MPFROMSHORT(GetRowScrollRow(pstScreen)),
               MPFROM2SHORT(0,pstScreen->lScrollRowCount));
    WinSendMsg(pstScreen->hwndScroll,
               SBM_SETTHUMBSIZE,
//               MPFROM2SHORT(1,(pstScreen->lScrollRowCount)),
//               MPFROM2SHORT(pstScreen->lCharHeight,(pstScreen->lScrollRowCount)),
               MPFROM2SHORT(pstScreen->lCharHeight,((pstScreen->lScrollRowCount) + pstScreen->lCharHeight)),
              (MPARAM)NULL);
    }
#if DEBUG > 0
  else
    DisplayLastWindowError("@ SetupRowScrolling");
#endif
 fLastScroll = 0;
 }

void RowScroll(SCREEN *pstScreen,SHORT iRows,BOOL bIsPosition)
  {
  LONG lScrollIndex = pstScreen->lScrollIndex;
  LONG lOldIndex = lScrollIndex;
  LONG lScrollRow = pstScreen->lScrollRow;

  if (bIsPosition)
    {
    lScrollIndex = GetPartialCharCount(pstScreen,0L,(pstScreen->lCharWidth * iRows));
    lScrollRow = iRows;
    }
  else
    {
    lScrollRow += iRows;
    if (lScrollRow >= pstScreen->lScrollRowCount)
      {
      lScrollRow = pstScreen->lScrollRowCount;
      lScrollIndex = pstScreen->lScrollEndIndex;
      }
    else
      {
      if (lScrollRow <= 0)
        {
        lScrollIndex = 0L;
        lScrollRow = 0;
        }
      else
        {
        lScrollIndex = GetPartialCharCount(pstScreen,lScrollIndex,(pstScreen->lCharWidth * iRows));
        if (lScrollIndex > pstScreen->lScrollEndIndex)
          lScrollIndex = pstScreen->lScrollEndIndex;
        else
          if (lScrollIndex < 0L)
            lScrollIndex = 0L;
        }
      }
    }
  if (lOldIndex != lScrollIndex)
    {
    pstScreen->lScrollIndex = lScrollIndex;
    pstScreen->lScrollRow = lScrollRow;
    WinSendMsg(pstScreen->hwndScroll,
               SBM_SETPOS,
               MPFROMSHORT(lScrollRow),
               MPFROMSHORT(0));
    WinInvalidateRect(pstScreen->hwndClient,(PRECTL)NULL,FALSE);
    if (stWrite.bSync || stRead.bSync)
      {
      stWrite.lScrollIndex = lScrollIndex;
      stWrite.lScrollRow = GetColScrollRow(&stWrite,0);
      stRead.lScrollIndex = lScrollIndex;
      stRead.lScrollRow = GetColScrollRow(&stRead,0);
      }
    }
  }

#ifdef this_junk
void ClearRowScreen(SCREEN *pstScreen)
  {
  HPS hps;
  RECTL rclRect;
  APIRET rc;
  char szMessage[80];

  ClearRowScrollBar(pstScreen);
  if ((rc = DosRequestMutexSem(hmtxRowGioBlockedSem,10000)) != NO_ERROR)
    {
    sprintf(szMessage,"DosRequestMutexSem error in ClearRowScreen: return code = %ld", rc);
    ErrorNotify(szMessage);
    }
  hps = WinBeginPaint(pstScreen->hwndClient,(HPS)NULL,&rclRect);
  rclRect.yBottom = pstScreen->lHeight;
  rclRect.yTop = pstScreen->lHeight + stCell.cy;
  rclRect.xLeft = 0;
  rclRect.xRight = (pstScreen->lWidth + stCell.cx + 2);
  while (rclRect.yBottom > stCell.cy)
    {
    WinFillRect(hps,&rclRect,CLR_BLACK);
    rclRect.yBottom -= stCell.cy;
    rclRect.yTop -= stCell.cy;
    WinFillRect(hps,&rclRect,CLR_WHITE);
    rclRect.yBottom -= stCell.cy;
    rclRect.yTop -= stCell.cy;
    }
  WinEndPaint(hps);
  if ((rc = DosReleaseMutexSem(hmtxRowGioBlockedSem)) != NO_ERROR)
    {
    sprintf(szMessage,"DosReleaseMutexSem error in ClearRowScreen: return code = %ld", rc);
    ErrorNotify(szMessage);
    }
  }
#endif
void ClearColScrollBar(SCREEN *pstScreen)
  {
  if (pstScreen->hwndScroll != (HWND)NULL)
    {
    WinDestroyWindow(pstScreen->hwndScroll);
    pstScreen->hwndScroll = (HWND)NULL;
//    pstScreen->lScrollRow = 0;
    pstScreen->lWidth += stCell.cx;
    pstScreen->lCharWidth += 1;
    pstScreen->lCharSize = (pstScreen->lCharWidth * pstScreen->lCharHeight);
    pstScreen->rclDisp.xRight += stCell.cx;
    }
  }

void ColScroll(SCREEN *pstScreen,SHORT iRows,BOOL bIsPosition)
  {
  LONG lScrollIndex = pstScreen->lScrollIndex;
  LONG lOldIndex = lScrollIndex;
  LONG lScrollRow = pstScreen->lScrollRow;

  if (bIsPosition)
    {
    lScrollIndex = GetColScrollIndex(pstScreen,iRows - lScrollRow);
    lScrollRow = iRows;
    }
  else
    {
    lScrollRow += iRows;
    if (lScrollRow >= pstScreen->lScrollRowCount)
      {
      lScrollRow = pstScreen->lScrollRowCount;
      lScrollIndex = pstScreen->lScrollEndIndex;
      }
    else
      {
      if (lScrollRow <= 0)
        {
        lScrollIndex = 0L;
        lScrollRow = 0L;
        }
      else
        {
        lScrollIndex = GetColScrollIndex(pstScreen,iRows);
        if (lScrollIndex > pstScreen->lScrollEndIndex)
          lScrollIndex = pstScreen->lScrollEndIndex;
        else
          if (lScrollIndex < 0L)
            lScrollIndex = 0L;
        }
      }
    }
  if (lOldIndex != lScrollIndex)
    {
    pstScreen->lScrollIndex = lScrollIndex;
    pstScreen->lScrollRow = lScrollRow;
    WinSendMsg(pstScreen->hwndScroll,
               SBM_SETPOS,
               MPFROMSHORT(pstScreen->lScrollRow),
               MPFROMSHORT(0));
    WinInvalidateRect(pstScreen->hwndClient,(PRECTL)NULL,FALSE);
    if (pstScreen->bSync)
      if (pstScreen->wDirection & CS_WRITE)
        {
        stRead.lScrollIndex = lScrollIndex;
        WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
        }
      else
        {
        stWrite.lScrollIndex = lScrollIndex;
        WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
        }
    fLastScroll = pstScreen->wDirection;
    if (pstScreen->bSync)
      {
      stRow.lScrollIndex = lScrollIndex;
      stRow.lScrollRow = GetRowScrollRow(&stRow);
      }
    }
  }

void AdjustScrollBar(SCREEN *pstScreen)
  {
  SetColScrollRowCount(pstScreen);
  WinSendMsg(pstScreen->hwndScroll,
             SBM_SETSCROLLBAR,
             MPFROMSHORT(pstScreen->lScrollRow),
             MPFROM2SHORT(0,pstScreen->lScrollRowCount));
  WinSendMsg(pstScreen->hwndScroll,
             SBM_SETTHUMBSIZE,
             MPFROM2SHORT(pstScreen->lCharHeight,(pstScreen->lScrollRowCount + pstScreen->lCharHeight)),
            (MPARAM)NULL);
  }

void SetupColScrolling(SCREEN *pstScreen)
  {
  ClearColScrollBar(pstScreen);
  pstScreen->hwndScroll = WinCreateWindow(pstScreen->hwndClient,
                               WC_SCROLLBAR,
                          (PSZ)NULL,
                               SBS_VERT | WS_VISIBLE,
                               pstScreen->lWidth,
                               -1,
                               stCell.cx,
                              (pstScreen->lHeight + stCell.cy + 1),
                               pstScreen->hwndClient,
                               HWND_TOP,
                               WID_VSCROLL_BAR,
                               NULL,NULL);
  if (pstScreen->hwndScroll != (HWND)NULL)
    {
    pstScreen->lWidth -= stCell.cx;
    pstScreen->lCharWidth -= 1;
    pstScreen->lCharSize = (pstScreen->lCharWidth * pstScreen->lCharHeight);
    pstScreen->rclDisp.xRight -= stCell.cx;
    AdjustScrollBar(pstScreen);
    }
#if DEBUG > 0
  else
    DisplayLastWindowError("@ SetupColScrolling");
#endif
  }

LONG GetColScrollRow(SCREEN *pstScreen,LONG lStartIndex)
  {
  LONG lIndex;
  LONG lRowCount = 0;
  LONG lCharCount = 0;
  BOOL bSkip;
  BOOL bLastWasNewLine = FALSE;
  WORD wNewLine;
  WORD wDirection;
  WORD wChar;
  WORD wFilterMask;
  ULONG ulElementCount;

  if (pwScrollBuffer == NULL)
    return(0);
  wDirection = (pstScreen->wDirection & 0xf000);
  if (pstScreen->bTestNewLine)
    {
    if (pstScreen->bFilter)
      wFilterMask = (WORD)pstScreen->byDisplayMask;
    else
      wFilterMask = 0x00ff;
    bSkip = pstScreen->bSkipBlankLines;
    wNewLine = (WORD)pstScreen->byNewLineChar;
    for (lIndex = lStartIndex;lIndex < pstScreen->lScrollIndex;lIndex++)
      {
      wChar = (pwScrollBuffer[lIndex] & 0xff00);
      if ((wChar & 0xf000) != wDirection)
        continue;
      wChar &= wFilterMask;
      if (wChar == wNewLine)
        {
        if (bSkip)
          {
          if (!bLastWasNewLine)
            {
            bLastWasNewLine = TRUE;
            lRowCount++;
            }
          }
        else
          lRowCount++;
        }
      else
        if (CharPrintable((BYTE *)&wChar,pstScreen))
          bLastWasNewLine = FALSE;
      }
    }
  else
    {
    for (lIndex = lStartIndex;lIndex < pstScreen->lScrollIndex;lIndex++)
      {
      if ((ulElementCount = CountTraceElement(pwScrollBuffer[lIndex],wDirection)) == 1)
        lCharCount++;
      if (ulElementCount > 1)
         lIndex += ulElementCount;
      }
    lRowCount = (lCharCount / pstScreen->lCharWidth);
    }
  return(lRowCount);
  }

void SetColScrollRowCount(SCREEN *pstScreen)
  {
  LONG lIndex;
  LONG lRowCount = 0;
  LONG lCharCount = 0;
  BOOL bSkip;
  BOOL bLastWasNewLine = FALSE;
  WORD wNewLine;
  WORD wDirection;
  WORD wChar;
  WORD wFilterMask;

  if (pwScrollBuffer == NULL)
    {
    pstScreen->lScrollRowCount = 0;
    return;
    }
  CalcColScrollEndIndex(pstScreen);
  wDirection = pstScreen->wDirection;
  if (pstScreen->bTestNewLine)
    {
    if (pstScreen->bFilter)
      wFilterMask = (WORD)pstScreen->byDisplayMask;
    else
      wFilterMask = 0x00ff;
    bSkip = pstScreen->bSkipBlankLines;
    wNewLine = (WORD)pstScreen->byNewLineChar;
    for (lIndex = 0;lIndex < pstScreen->lScrollEndIndex;lIndex++)
      {
      if (((wChar = pwScrollBuffer[lIndex]) & 0xff00) != wDirection)
        continue;
      wChar &= wFilterMask;
      if (wChar == wNewLine)
        {
        if (bSkip)
          {
          if (!bLastWasNewLine)
            {
            bLastWasNewLine = TRUE;
            lRowCount++;
            }
          }
        else
          lRowCount++;
        }
      else
        if (CharPrintable((BYTE *)&wChar,pstScreen))
          bLastWasNewLine = FALSE;
      }
    }
  else
    {
    for (lIndex = 0;lIndex < pstScreen->lScrollEndIndex;lIndex++)
      {
      if ((pwScrollBuffer[lIndex] & 0xff00) == wDirection)
        lCharCount++;
      }
    lRowCount = (lCharCount / pstScreen->lCharWidth);
    }
  pstScreen->lScrollRowCount = lRowCount;
  }

void CalcColScrollEndIndex(SCREEN *pstScreen)
  {
  LONG lIndex;
  WORD wNewLine;
//  LONG lCharCount;
  WORD wDirection;
  WORD wChar;
  BOOL bWaitingPrintable;
  LONG lPrintableIndex;
  WORD wFilterMask;

  wDirection = pstScreen->wDirection;
  if (pstScreen->bTestNewLine)
    {
    if (pstScreen->bFilter)
      wFilterMask = (WORD)pstScreen->byDisplayMask;
    else
      wFilterMask = 0x00ff;
    wNewLine = (WORD)pstScreen->byNewLineChar;
    bWaitingPrintable = TRUE;
    lPrintableIndex = 0;
    for (lIndex = (lScrollCount - 1);lIndex >= 0;lIndex--)
      {
      if (((wChar = pwScrollBuffer[lIndex]) & 0xff00) != wDirection)
        continue;
      wChar &= wFilterMask;
      if (wChar == wNewLine)
        {
        if (!bWaitingPrintable)
          break;
        }
      else
        if (CharPrintable((BYTE *)&wChar,pstScreen))
          {
          lPrintableIndex = lIndex;
          bWaitingPrintable = FALSE;
          }
      }
    if (lPrintableIndex < (lScrollCount - pstScreen->lCharSize))
      pstScreen->lScrollEndIndex = (lScrollCount - pstScreen->lCharSize);
    else
      pstScreen->lScrollEndIndex = lPrintableIndex;
    }
  else
    {
    for (lIndex = (lScrollCount - 1);lIndex >= 0;lIndex--)
      if ((pwScrollBuffer[lIndex] & 0xff00) == wDirection)
        {
        pstScreen->lScrollEndIndex = lIndex;
        break;
        }
    }
  }

LONG GetColScrollIndex(SCREEN *pstScreen,LONG lRowCount)
  {
  LONG lIndex;
  BOOL bSkip;
  WORD wNewLine;
  LONG lCharCount;
  BOOL bWaitingPrintable;
  WORD wDirection;
  WORD wChar;
  LONG lStartIndex = pstScreen->lScrollIndex;
  BOOL bLastWasNewLine = FALSE;
  LONG lPrintableIndex = lStartIndex;
  WORD wFilterMask;

  if (lRowCount == 0)
    return(lStartIndex);
  wDirection = pstScreen->wDirection;
  if (pstScreen->bTestNewLine)
    {
    if (pstScreen->bFilter)
      wFilterMask = (WORD)pstScreen->byDisplayMask;
    else
      wFilterMask = 0x00ff;
    wNewLine = (WORD)pstScreen->byNewLineChar;
    if (lRowCount < 0)
      {
      bWaitingPrintable = TRUE;
      for (lIndex = (lStartIndex - 1);lIndex >= 0;lIndex--)
        {
        if (((wChar = pwScrollBuffer[lIndex]) & 0xff00) != wDirection)
          continue;
        wChar &= wFilterMask;
        if (wChar == wNewLine)
          {
          if (!bWaitingPrintable)
            {
            if (++lRowCount >= 0)
              break;
            else
              bWaitingPrintable = TRUE;
            }
          }
        else
          if (CharPrintable((BYTE *)&wChar,pstScreen))
            {
            lPrintableIndex = lIndex;
            bWaitingPrintable = FALSE;
            }
        }
      lIndex = lPrintableIndex;
      }
    else
      {
      bSkip = pstScreen->bSkipBlankLines;
      bWaitingPrintable = FALSE;
      for (lIndex = (lStartIndex + 1);lIndex < lScrollCount;lIndex++)
        {
        if (((wChar = pwScrollBuffer[lIndex]) & 0xff00) != wDirection)
          continue;
        wChar &= wFilterMask;
        if (wChar == wNewLine)
          {
          if (!bWaitingPrintable)
            {
            if (bSkip)
              {
              if (!bLastWasNewLine)
                {
                bLastWasNewLine = TRUE;
                if (--lRowCount <= 0)
                  bWaitingPrintable = TRUE;
                }
              }
            else
              if (--lRowCount <= 0)
                bWaitingPrintable = TRUE;
            }
          }
        else
          {
          if (CharPrintable((BYTE *)&wChar,pstScreen))
            {
            if (bWaitingPrintable)
              break;
            bLastWasNewLine = FALSE;
            }
          }
        }
      }
    }
  else
    {
    lCharCount = (lRowCount * pstScreen->lCharWidth);
    if (lCharCount > 0)
      {
      for (lIndex = (lStartIndex + 1);lIndex < lScrollCount;lIndex++)
        if ((pwScrollBuffer[lIndex] & 0xff00) == wDirection)
          if (lCharCount-- <= 0)
            break;
      }
    else
      {
      for (lIndex = (lStartIndex - 1);lIndex >= 0;lIndex--)
        if ((pwScrollBuffer[lIndex] & 0xff00) == wDirection)
          if (lCharCount++ >= 0)
            break;
      }
    }
  return(lIndex);
  }


