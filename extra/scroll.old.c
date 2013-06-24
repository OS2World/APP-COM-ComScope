#include "comscope.h"
#include <OS$tools.h>

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

extern HMTX hmtxRowGioBlockedSem;

static LONG GetPartialCharCount(LONG lStartIndex,LONG lCharCount);
static VOID CalcScrollEndIndex(SCREEN *pstScreen);
static void SetScrollRowCount(SCREEN *pstScreen);
static void SetColScrollRowCount(SCREEN *pstScreen);
static LONG GetColScrollIndex(SCREEN *pstScreen,LONG lRowCount);
static VOID CalcColScrollEndIndex(SCREEN *pstScreen);

void SetScrollRowCount(SCREEN *pstScreen)
  {
  LONG lActualCharCount = 0;
  LONG lIndex;
  WORD wDirection;
  WORD wLastDirection;
  LONG lRowCount = 0;
  LONG lRowCountedAt = 0xffffffff;

  CalcScrollEndIndex(pstScreen);
  if (stCFG.bCompressDisplay && (pwScrollBuffer != NULL))
    {
    wLastDirection = CS_READ;
    for (lIndex = 0;lIndex < pstScreen->lScrollEndIndex;lIndex++)
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
      if (wLastDirection & CS_WRITE)
        lActualCharCount++;
      else
        if (wDirection & CS_READ)
          lActualCharCount++;
      wLastDirection = wDirection;
      }
    }
  else
    lRowCount = (pstScreen->lScrollEndIndex / pstScreen->lCharWidth);
  pstScreen->lScrollRowCount = lRowCount;
  }

LONG GetRowScrollRow(SCREEN *pstScreen)
  {
  LONG lActualCharCount = 0;
  LONG lIndex;
  WORD wDirection;
  WORD wLastDirection;
  LONG lRowCount = 0;
  LONG lRowCountedAt = 0xffffffff;

  if (stCFG.bCompressDisplay && (pwScrollBuffer != NULL))
    {
    wLastDirection = CS_READ;
    for (lIndex = 0;lIndex < pstScreen->lScrollIndex;lIndex++)
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
      if (wLastDirection & CS_WRITE)
        lActualCharCount++;
      else
        if (wDirection & CS_READ)
          lActualCharCount++;
      wLastDirection = wDirection;
      }
    }
  else
    {
    lRowCount = (pstScreen->lScrollIndex / pstScreen->lCharWidth);
    if ((pstScreen->lScrollIndex % pstScreen->lCharWidth) != 0)
      lRowCount++;
    }
  return(lRowCount);
  }

VOID CalcScrollEndIndex(SCREEN *pstScreen)
  {
  LONG lGoal = lScrollCount;
  LONG lTemp = 0;
  SHORT sRowCount;
  SHORT sIndex;
  LONG lScrollEndIndex;

  lTemp = pstScreen->lScrollIndex;
  pstScreen->lScrollIndex = lScrollCount;
  sRowCount = GetRowScrollRow(pstScreen);
  pstScreen->lScrollIndex = lTemp;
  if (sRowCount <= pstScreen->lCharHeight)
    {
    lScrollEndIndex = 0;
    return;
    }
  if (pstScreen->lCharWidth > 0)
    {
    if (stCFG.bCompressDisplay)
      {
      lGoal += GetPartialCharCount(lScrollCount,-pstScreen->lCharSize);
      for (sIndex = 0;sIndex < sRowCount;sIndex++)
        {
        lTemp += GetPartialCharCount(lTemp,pstScreen->lCharWidth);
        if (lTemp >= lGoal)
          break;
        }
      lScrollEndIndex = lTemp;
      }
    else
      lScrollEndIndex = (lScrollCount - (pstScreen->lCharSize -
                                        (pstScreen->lCharWidth - (lScrollCount % pstScreen->lCharWidth))));
    if (lScrollEndIndex < 0L)
      lScrollEndIndex = 0L;
    }  pstScreen->lScrollEndIndex = lScrollEndIndex;
  }
LONG GetPartialCharCount(LONG lStartIndex,LONG lCharCount)
  {
  LONG lLogicalCharCount = 0;
  LONG lIndex;
  WORD wDirection;
  WORD wLastDirection;
  WORD *pwBuffer;

  if (stCFG.bCompressDisplay && (pwScrollBuffer != NULL))
    {
    if (lCharCount > 0)
      {
      pwBuffer = &pwScrollBuffer[lStartIndex];
      wLastDirection = CS_READ;
      for (lIndex = 0;lIndex < (stCFG.lBufferLength - lStartIndex);lIndex++)
        {
        wDirection = (*(pwBuffer++) & 0xff00);
        if (wLastDirection & CS_WRITE)
          lLogicalCharCount++;
        else
          if (wDirection & CS_READ)
            lLogicalCharCount++;
        if (lLogicalCharCount >= lCharCount)
          break;
        wLastDirection = wDirection;
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
        if (wDirection & CS_READ)
          lCharCount++;
        else
          if (wLastDirection & CS_WRITE)
            lCharCount++;
        if (lCharCount >= 0)
          {
          if (wDirection & CS_READ)
            if (lIndex > 0)
              if ((pwScrollBuffer[lIndex - 1] & 0xff00) != CS_READ)
                lIndex--;
          break;
          }
        wLastDirection = wDirection;
        }
      if (lIndex <= 0)
        lIndex = -lStartIndex;
      else
        lIndex = (lIndex - lStartIndex);
      }
    return(lIndex);
    }
  else
    return(lCharCount);
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
                                          pstScreen->lWidth,lStatusHeight,
                                          stCell.cx,pstScreen->lHeight,
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
#ifdef debug
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
    lScrollIndex = GetPartialCharCount(0L,(pstScreen->lCharWidth * iRows));
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
        lScrollIndex += GetPartialCharCount(lScrollIndex,(pstScreen->lCharWidth * iRows));
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
#ifdef debug
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

  if (pwScrollBuffer == NULL)
    return(0);
  wDirection = pstScreen->wDirection;
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
    for (lIndex = lStartIndex;lIndex < pstScreen->lScrollIndex;lIndex++)
      {
      if ((pwScrollBuffer[lIndex] & 0xff00) == wDirection)
        lCharCount++;
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


