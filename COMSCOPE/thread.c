/*******************************************************************************
*
*       Copyright (C) 1988-89 OS/tools Incorporated -- All rights reserved
*
*******************************************************************************/

#include "COMscope.h"

#include "remote.h"

extern TID tidIPCserverThread;
extern ULONG ulCOMscopeBufferSize;
extern TID tidMonitorThread;
extern TID tidDisplayThread;
extern HEV hevWaitQueueStartSem;
extern HEV hevWaitCOMiDataSem;
extern HEV hevDisplayWaitDataSem;
extern HEV hevKillMonitorThreadSem;
extern HEV hevKillDisplayThreadSem;
extern HMTX hmtxColGioBlockedSem;
extern HMTX hmtxRowGioBlockedSem;

extern LONG lStatusHeight;
extern CHARCNT stCharCount;
extern HAB habAnchorBlock;

extern BOOL bRemoteAccess;
extern BOOL bRemoteServer;
extern BOOL bRemoteClient;

extern HWND hwndFrame;
extern HWND hwndClient;
extern SCREEN stRead;
extern SCREEN stWrite;

extern char szCOMscopeIniPath[];

char szServerCommand[100];
BOOL bAbort = FALSE;

extern IOCTLINST stIOctl;

extern HEV hevCOMscopeSem;
extern char szCOMscopePipe[100];

extern BOOL bStopRemotePipe;
extern PIPEMSG stPipeMsg;
extern PIPECMD stPipeCmd;

extern HPIPE hCOMscopePipe;
extern char szIPCpipe[];
extern IPCPIPEMSG stIPCpipe;
extern ULONG ulBytesRead;
extern ULONG ulIPCpipeInstance;
extern BOOL bIPCpipeOpen;
extern BOOL bStopIPCserverThread;
extern char chPipeDebug;
extern char szIPCpipeName[];
extern BOOL bShowServerProcess;
extern HQUEUE hIPCpipe;
extern BOOL bIsTheFirst;

extern HMTX hmtxIPCpipeBlockedSem;
extern STARTDATA stSD;
extern PID pidCSqueueOwner;
extern ULONG ulSessionID;
extern PID pidSession;

extern HDC hdcPs;

extern HPS hpsPs;
extern CHARCELL stCell;

extern LONG lYScr;
extern LONG lcyBrdr;
extern LONG lXScr;
extern LONG lcxVSc;
extern LONG lcxBrdr;

extern BOOL bDataToView;

extern USHORT *pwCaptureBuffer;

extern BOOL bDebuggingCOMscope;

LONG lWriteIndex = 0;
LONG lReadIndex = 0;
BOOL bBufferWrapped = FALSE;

extern LONG lScreenCharWidth;

extern CSCFG stCFG;

extern ULONG ulServerMessage;
extern SCREEN stRow;

extern char szCaptureFileName[];

extern LONG lFontCount;
extern FATTRS astFontAttributes[];
extern BOOL bStopMonitorThread;
extern BOOL bStopDisplayThread;
extern ULONG ulMonitorSleepCount;
extern BOOL bCaptureFileWritten;

POINTL stPosition;

void APIENTRY RowDisplayThread(void)
  {
  HPS hps;
  RECTL rclRect;
  RECTL rclBlankerRect;
  RECTL rclMarkerRect;
  POINTL stPos;
  BOOL bScreenWrapped = FALSE;
  USHORT wChar;
  USHORT wDirection;
  ULONG ulPostCount;
  WORD wLastDirection = CS_READ;
  BOOL bDisplayCharacter = TRUE;
  LONG lCharacterCount;
  BOOL bDisplaySignal = FALSE;
  BOOL bLastWasOverflow = FALSE;
  LONG lPacketCount;
  LONG lMarker;

  WinPostMsg(hwndClient,UM_STARTDISPLAYTHREAD,0L,0L);
  stRow.lCursorReadRow = stRow.lHeight;
  stRow.lCursorWriteRow = stRow.lCursorReadRow - stCell.cy;
  lMarker = (stCell.cy / 2);
  stRow.lLeadReadRow = stRow.lCursorReadRow;
  stRow.lLeadWriteRow = stRow.lCursorWriteRow;
  stRow.Pos.x = 0;
  lReadIndex = lWriteIndex;
  DosSetPriority(PRTYS_THREAD,PRTYC_FOREGROUNDSERVER,-4L,tidDisplayThread);
  lCharacterCount = 50;
  lPacketCount = 0;
  while (!bStopDisplayThread)
    {
    DosWaitEventSem(hevDisplayWaitDataSem,-1);
    if (bStopDisplayThread)
      break;
    DosResetEventSem(hevDisplayWaitDataSem,&ulPostCount);
    wLastDirection = CS_READ;
//  DosRequestMutexSem(hmtxRowGioBlockedSem,10000);
    DosRequestMutexSem(hmtxRowGioBlockedSem,-1);
    hps = WinGetPS(hwndClient);
    GpiCreateLogFont(hps,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wRowFont]);
    GpiSetCharSet(hps,2);
    GpiSetBackMix(hps,BM_OVERPAINT);
    while ((lReadIndex != lWriteIndex) && !bStopDisplayThread)
      {
      if (lPacketCount == 0)
        {
        if (--lCharacterCount == 0)
          {
          WinReleasePS(hps);
          DosReleaseMutexSem(hmtxRowGioBlockedSem);
          DosSleep(0);
          DosRequestMutexSem(hmtxRowGioBlockedSem,-1);
          if (bStopDisplayThread)
            break;
          lCharacterCount = 50;
          hps = WinGetPS(hwndClient);
          GpiCreateLogFont(hps,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wRowFont]);
          GpiSetCharSet(hps,2);
          GpiSetBackMix(hps,BM_OVERPAINT);
          }
        if (lReadIndex >= stCFG.lBufferLength)
          lReadIndex = 0;
        wChar = pwCaptureBuffer[lReadIndex++];
        wDirection = (wChar & 0xff00);
#ifdef this_junk
        if (stCFG.bCompressDisplay && (wLastDirection == CS_WRITE) && (wDirection == CS_READ))
          stRow.Pos.x -= stCell.cx;
#endif
        if (wDirection != CS_READ_BUFF_OVERFLOW)
          bLastWasOverflow = FALSE;
        if (stCFG.bMarkCurrentLine)
          {
          rclBlankerRect.xLeft = stRow.Pos.x;
          rclBlankerRect.xRight = (stRow.Pos.x + stCell.cx);
          }
        switch (wDirection)
          {
          case CS_PACKET_DATA:
            lPacketCount = (wChar & 0xff);
            bDisplayCharacter = FALSE;
            break;
          case CS_READ:
            if (stCFG.bDispRead)
              {
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorWriteRow;
                rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
                }
              stPos.y = stRow.lCursorReadRow;
              GpiSetBackColor(hps,stCFG.lReadBackgrndColor);
              GpiSetColor(hps,stCFG.lReadForegrndColor);
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_WRITE:
            if (stCFG.bDispWrite)
              {
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorReadRow;
                rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
                }
              stPos.y = stRow.lCursorWriteRow;
              GpiSetBackColor(hps,stCFG.lWriteBackgrndColor);
              GpiSetColor(hps,stCFG.lWriteForegrndColor);
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_WRITE_IMM:
            if (stCFG.bDispIMM)
              {
              wDirection = CS_WRITE;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorReadRow;
                rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
                }
              stPos.y = stRow.lCursorWriteRow;
              if (stCFG.bHiLightImmediateByte)
                {
                GpiSetBackColor(hps,stCFG.lWriteForegrndColor);
                GpiSetColor(hps,stCFG.lWriteBackgrndColor);
                }
              else
                {
                GpiSetBackColor(hps,stCFG.lWriteBackgrndColor);
                GpiSetColor(hps,stCFG.lWriteForegrndColor);
                }
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_READ_IMM:
            if (stCFG.bDispIMM)
              {
              wDirection = CS_READ;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorWriteRow;
                rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
                }
              stPos.y = stRow.lCursorReadRow;
              if (stCFG.bHiLightImmediateByte)
                {
                GpiSetBackColor(hps,stCFG.lReadForegrndColor);
                GpiSetColor(hps,stCFG.lReadBackgrndColor);
                }
              else
                {
                GpiSetBackColor(hps,stCFG.lReadBackgrndColor);
                GpiSetColor(hps,stCFG.lReadForegrndColor);
                }
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_MODEM_IN:
            if (stCFG.bDispModemIn)
              {
              bDisplaySignal = TRUE;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorWriteRow;
                rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
                }
              stPos.y = stRow.lCursorReadRow;
              GpiSetBackColor(hps,stCFG.lModemInBackgrndColor);
              GpiSetColor(hps,stCFG.lModemInForegrndColor);
              if (stCFG.wRowFont & 0x01)
                {
                wChar &= 0xf0;
                wChar >>= 4;
                if (wChar < 10)
                  wChar += '0';
                else
                  wChar += ('A' - 10);
                }
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_MODEM_OUT:
            if (stCFG.bDispModemOut)
              {
              bDisplaySignal = TRUE;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorReadRow;
                rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
                }
              stPos.y = stRow.lCursorWriteRow;
              GpiSetBackColor(hps,stCFG.lModemOutBackgrndColor);
              GpiSetColor(hps,stCFG.lModemOutForegrndColor);
              wChar &= 0x03;
              if (stCFG.wRowFont & 0x01)
                wChar += '0';
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_DEVIOCTL:
            if (stCFG.bDispDevIOctl)
              {
              bDisplaySignal = TRUE;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorReadRow;
                rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
                }
              stPos.y = stRow.lCursorWriteRow;
              GpiSetBackColor(hps,stCFG.lDevIOctlBackgrndColor);
              GpiSetColor(hps,stCFG.lDevIOctlForegrndColor);
              if (stCFG.wRowFont & 0x01)
                wChar = 'F';
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_READ_BUFF_OVERFLOW:
            if (stCFG.bDispErrors)
              {
              if (!bLastWasOverflow)
                {
                bLastWasOverflow = TRUE;
                bDisplaySignal = TRUE;
                if (stCFG.bMarkCurrentLine)
                  {
                  rclBlankerRect.yBottom = stRow.lCursorWriteRow;
                  rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
                  WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
                  }
                stPos.y = stRow.lCursorReadRow;
                GpiSetBackColor(hps,stCFG.lErrorBackgrndColor);
                GpiSetColor(hps,stCFG.lErrorForegrndColor);
                if (stCFG.wRowFont & 0x01)
                  wChar = 'V';
                else
                  wChar = 0xff;
                }
              else
                bDisplayCharacter = FALSE;
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_HDW_ERROR:
            if (stCFG.bDispErrors)
              {
              bDisplaySignal = TRUE;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorWriteRow;
                rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
                }
              stPos.y = stRow.lCursorReadRow;
              GpiSetBackColor(hps,stCFG.lErrorBackgrndColor);
              GpiSetColor(hps,stCFG.lErrorForegrndColor);
              if (stCFG.wRowFont & 0x01)
                wChar = 'E';
              else
                wChar &= 0x1e;
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_BREAK_RX:
            if (stCFG.bDispErrors)
              {
              bDisplaySignal = TRUE;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorWriteRow;
                rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
                }
              stPos.y = stRow.lCursorReadRow;
              GpiSetBackColor(hps,stCFG.lErrorBackgrndColor);
              GpiSetColor(hps,stCFG.lErrorForegrndColor);
              if (stCFG.wRowFont & 0x01)
                wChar = 'B';
              else
                wChar = 0xBB;
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_BREAK_TX:
            if (stCFG.bDispModemOut)
              {
              bDisplaySignal = TRUE;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorReadRow;
                rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
                }
              stPos.y = stRow.lCursorWriteRow;
              GpiSetBackColor(hps,stCFG.lModemOutBackgrndColor);
              GpiSetColor(hps,stCFG.lModemOutForegrndColor);
              if (stCFG.wRowFont & 0x01)
                if (wChar & LINE_CTL_SEND_BREAK)
                  wChar = 'B';
                else
                  wChar = 'b';
              else
                if (wChar & LINE_CTL_SEND_BREAK)
                  wChar = 0xB1;
                else
                  wChar = 0xB0;
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_WRITE_REQ:
            if (stCFG.bDispWriteReq)
              {
              bDisplaySignal = TRUE;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorReadRow;
                rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
                }
              stPos.y = stRow.lCursorWriteRow;
              GpiSetBackColor(hps,stCFG.lWriteReqBackgrndColor);
              GpiSetColor(hps,stCFG.lWriteReqForegrndColor);
              if (stCFG.wRowFont & 0x01)
                wChar = 'W';
              else
                if ((wChar & 0xff) == 0)
                  wChar = 0xD0;
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_WRITE_CMPLT:
            if (stCFG.bDispWriteReq)
              {
              bDisplaySignal = TRUE;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorReadRow;
                rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
                }
              stPos.y = stRow.lCursorWriteRow;
              GpiSetBackColor(hps,stCFG.lWriteReqBackgrndColor);
              GpiSetColor(hps,stCFG.lWriteReqForegrndColor);
              if (stCFG.wRowFont & 0x01)
                wChar = 'w';
              else
                if ((wChar & 0xff) == 0)
                  wChar = 0xD1;
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_READ_REQ:
            if (stCFG.bDispReadReq)
              {
              bDisplaySignal = TRUE;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorWriteRow;
                rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
                }
              stPos.y = stRow.lCursorReadRow;
              GpiSetBackColor(hps,stCFG.lReadReqBackgrndColor);
              GpiSetColor(hps,stCFG.lReadReqForegrndColor);
              if (stCFG.wRowFont & 0x01)
                wChar = 'R';
              else
                if ((wChar & 0xff) == 0)
                  wChar = 0xA0;
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_READ_CMPLT:
            if (stCFG.bDispReadReq)
              {
              bDisplaySignal = TRUE;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorWriteRow;
                rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
                }
              stPos.y = stRow.lCursorReadRow;
              GpiSetBackColor(hps,stCFG.lReadReqBackgrndColor);
              GpiSetColor(hps,stCFG.lReadReqForegrndColor);
              if (stCFG.wRowFont & 0x01)
                wChar = 'r';
              else
                if ((wChar & 0xff) == 0)
                  wChar = 0xA1;
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_OPEN_ONE:
            if (stCFG.bDispOpen)
              {
              bDisplaySignal = TRUE;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorReadRow;
                rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
                }
              stPos.y = stRow.lCursorWriteRow;
              GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
              GpiSetColor(hps,stCFG.lOpenForegrndColor);
              if (stCFG.wRowFont & 0x01)
                wChar = 'O';
              else
                wChar = 0x00;
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_OPEN_TWO:
            if (stCFG.bDispOpen)
              {
              bDisplaySignal = TRUE;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorReadRow;
                rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
                }
              stPos.y = stRow.lCursorWriteRow;
              GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
              GpiSetColor(hps,stCFG.lOpenForegrndColor);
              if (stCFG.wRowFont & 0x01)
                wChar = 'o';
              else
                wChar = 0x01;
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_CLOSE_ONE:
            if (stCFG.bDispOpen)
              {
              bDisplaySignal = TRUE;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorReadRow;
                rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
                }
              stPos.y = stRow.lCursorWriteRow;
              GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
              GpiSetColor(hps,stCFG.lOpenForegrndColor);
              if (stCFG.wRowFont & 0x01)
                wChar = 'C';
              else
                wChar = 0xc0;
              }
            else
              bDisplayCharacter = FALSE;
            break;
          case CS_CLOSE_TWO:
            if (stCFG.bDispOpen)
              {
              bDisplaySignal = TRUE;
              if (stCFG.bMarkCurrentLine)
                {
                rclBlankerRect.yBottom = stRow.lCursorReadRow;
                rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
                WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
                }
              stPos.y = stRow.lCursorWriteRow;
              GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
              GpiSetColor(hps,stCFG.lOpenForegrndColor);
              if (stCFG.wRowFont & 0x01)
                wChar = 'c';
              else
                wChar = 0x0c;
              }
            else
              bDisplayCharacter = FALSE;
            break;
          default:
            if (bDebuggingCOMscope)
              {
              wChar >>= 8;
              GpiSetColor(hps,CLR_RED);
              GpiSetColor(hps,CLR_WHITE);
              }
            else
              bDisplayCharacter = FALSE;
            break;
          }
        if (bDisplayCharacter)
          {
          stPos.x = stRow.Pos.x;
          GpiCharStringAt(hps,&stPos,1,(char *)&wChar);
          if (stRow.Pos.x >= stRow.lWidth)
            {
#ifdef this_junk
            if (!bDisplaySignal && stCFG.bCompressDisplay && (lReadIndex < lWriteIndex))
              {
              if (wDirection != CS_READ)
                {
                wChar = pwCaptureBuffer[lReadIndex + 1];
                if (((wChar & 0xff00) == CS_READ) || ((wChar & 0xff00) == CS_READ_IMM))
                  {
                  if ((wChar & 0xff00) == CS_READ)
                    {
                    GpiSetColor(hps,stCFG.lReadForegrndColor);
                    WinFillRect(hps,&rclRect,stCFG.lReadBackgrndColor);
                    }
                  else
                    if (stCFG.bHiLightImmediateByte)
                      {
                      GpiSetColor(hps,stCFG.lWriteForegrndColor);
                      WinFillRect(hps,&rclRect,stCFG.lWriteBackgrndColor);
                      }
                  pwCaptureBuffer[++lWriteIndex] = wChar;
                  stPos.y = stRow.lCursorReadRow;
                  GpiCharStringAt(hps,&stPos,1,(char *)&wChar);
                  wDirection = CS_READ;
                  lReadIndex++;
                  }
                }
              }
            else
#endif
              bDisplaySignal = FALSE;
            if (bScreenWrapped)
              {
              if (stRow.lLeadWriteRow < (stCell.cy * 2))
                stRow.lLeadReadRow = stRow.lHeight;
              else
                stRow.lLeadReadRow -= (stCell.cy * 2);
              stRow.lLeadWriteRow = stRow.lLeadReadRow - stCell.cy;
              stRow.lLeadIndex += stRow.lCharWidth;
              if (stRow.lLeadIndex >= stCFG.lBufferLength)
                stRow.lLeadIndex -= stCFG.lBufferLength;
              }
            rclRect.xLeft = 0L;
            rclRect.xRight = stRow.lWidth + stCell.cx;
            rclMarkerRect.xLeft = 0L;
            rclMarkerRect.xRight = stRow.lWidth + stCell.cx;
            if (stRow.lCursorWriteRow < (stCell.cy * 2))
              {
              stRow.lCursorReadRow = stRow.lHeight;
              stRow.lCursorWriteRow = stRow.lCursorReadRow - stCell.cy;
              rclRect.yBottom = stRow.lCursorReadRow;
              rclRect.yTop = stRow.lCursorReadRow + stCell.cy;
              bScreenWrapped = TRUE;
              stRow.lLeadReadRow = stRow.lHeight - (stCell.cy * 2);
              stRow.lLeadWriteRow = stRow.lLeadReadRow - stCell.cy;
              stRow.lLeadIndex += stRow.lCharWidth;
              if (stRow.lLeadIndex >= stCFG.lBufferLength)
                stRow.lLeadIndex -= stCFG.lBufferLength;
              }
            else
              {
              rclRect.yBottom = stRow.lCursorWriteRow - stCell.cy;
              rclRect.yTop = rclRect.yBottom + stCell.cy;
              stRow.lCursorReadRow -= (stCell.cy * 2);
              stRow.lCursorWriteRow = stRow.lCursorReadRow - stCell.cy;
              }
            WinFillRect(hps,&rclRect,stCFG.lReadBackgrndColor);
            rclRect.yBottom -= stCell.cy;
            if (stCFG.bMarkCurrentLine)
              {
              rclMarkerRect.yTop = (rclRect.yTop - lMarker);
              rclMarkerRect.yBottom = (rclMarkerRect.yTop - 1);
              WinFillRect(hps,&rclMarkerRect,stCFG.lReadForegrndColor);
              }
            if (rclRect.yBottom <= (lStatusHeight + 2))
              rclRect.yBottom -= 4;
            rclRect.yTop -= stCell.cy;
            WinFillRect(hps,&rclRect,stCFG.lWriteBackgrndColor);
            if (stCFG.bMarkCurrentLine)
              {
              rclMarkerRect.yTop = (rclRect.yTop - lMarker);
              rclMarkerRect.yBottom = (rclMarkerRect.yTop - 1);
              WinFillRect(hps,&rclMarkerRect,stCFG.lWriteForegrndColor);
              }
            stRow.Pos.x = 0;
            }
          else
            {
            stRow.Pos.x += stCell.cx;
            wLastDirection = wDirection;
            }
          }
        else
          bDisplayCharacter = TRUE;
        }
      else
        {
        lPacketCount--;
        if (lReadIndex++ >= stCFG.lBufferLength)
          lReadIndex = 0;
        }
      }
    WinReleasePS(hps);
    DosReleaseMutexSem(hmtxRowGioBlockedSem);
    }
//  WinPostMsg(hwndClient,UM_KILLDISPLAYTHREAD,0L,0L);
  DosPostEventSem(hevKillDisplayThreadSem);
//  DosExit(EXIT_THREAD,0);
  }

void APIENTRY ColumnDisplayThread(void)
  {
  HPS hpsRead;
  HPS hpsWrite;
  BYTE byChar;
  LONG lReadSyncLine = 0;
  LONG lWriteSyncLine = 0;
  BOOL bReadSync = FALSE;
  LONG lOldTop;
  BOOL bWriteSync = FALSE;
  BOOL bLastWriteWasNewLine = FALSE;
  BOOL bLastReadWasNewLine= FALSE;
  ULONG ulPostCount;
  LONG lCharacterCount;
  int iPacketCount;
  WORD wFunc;

  WinPostMsg(hwndClient,UM_STARTDISPLAYTHREAD,0L,0L);
  stRead.Pos.y = stRead.lHeight;
  stWrite.Pos.y = stWrite.lHeight;
  stRead.Pos.x = 0;
  stWrite.Pos.x = 0;
  lReadIndex = lWriteIndex;
  DosSetPriority(PRTYS_THREAD,PRTYC_FOREGROUNDSERVER,-4L,tidDisplayThread);
  stRead.rclDisp.xLeft = 0L;
  stWrite.rclDisp.xLeft = 0L;
  lCharacterCount = 50;
  iPacketCount = 0;
  while (!bStopDisplayThread)
    {
    DosWaitEventSem(hevDisplayWaitDataSem,-1);
      if (bStopDisplayThread)
        break;
    DosResetEventSem(hevDisplayWaitDataSem,&ulPostCount);
    DosRequestMutexSem(hmtxColGioBlockedSem,10000);
    hpsRead = WinGetPS(stRead.hwndClient);
    GpiCreateLogFont(hpsRead,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wColReadFont]);
    GpiSetCharSet(hpsRead,2);
    GpiSetColor(hpsRead,stCFG.lReadColForegrndColor);
    hpsWrite = WinGetPS(stWrite.hwndClient);
    GpiCreateLogFont(hpsWrite,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wColWriteFont]);
    GpiSetCharSet(hpsWrite,2);
    GpiSetColor(hpsWrite,stCFG.lWriteColForegrndColor);
    while (lReadIndex != lWriteIndex && !bStopDisplayThread)
      {
      if (iPacketCount == 0)
        {
        if (--lCharacterCount == 0)
          {
          WinReleasePS(hpsRead);
          WinReleasePS(hpsWrite);
          DosReleaseMutexSem(hmtxColGioBlockedSem);
          DosSleep(0);
          DosRequestMutexSem(hmtxColGioBlockedSem,-1);
          if (bStopDisplayThread)
            break;
          lCharacterCount = 50;
          hpsRead = WinGetPS(stRead.hwndClient);
          GpiCreateLogFont(hpsRead,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wColReadFont]);
          GpiSetCharSet(hpsRead,2);
          GpiSetColor(hpsRead,stCFG.lReadColForegrndColor);
          hpsWrite = WinGetPS(stWrite.hwndClient);
          GpiCreateLogFont(hpsWrite,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wColWriteFont]);
          GpiSetCharSet(hpsWrite,2);
          GpiSetColor(hpsWrite,stCFG.lWriteColForegrndColor);
          }
        if (lReadIndex >= stCFG.lBufferLength)
          lReadIndex = 0;
        byChar = (BYTE)pwCaptureBuffer[lReadIndex];
        wFunc = (pwCaptureBuffer[lReadIndex++] & 0x0ff00);
        switch (wFunc)
          {
          case CS_PACKET_DATA:
            iPacketCount = (int)byChar;
            break;
          case CS_READ_IMM:
          case CS_READ:
            if (stRead.bFilter)
              byChar &= stRead.byDisplayMask;
            if (stRead.bTestNewLine && (byChar == stRead.byNewLineChar))
              {
              if (stRead.bSkipBlankLines && bLastReadWasNewLine)
                break;
              bLastReadWasNewLine = TRUE;
              if (CharPrintable(&byChar,&stRead))
                if (stRead.bWrap || (stRead.Pos.x <= stRead.lWidth))
                  GpiCharStringAt(hpsRead,&stRead.Pos,1,&byChar);
              stRead.Pos.x = 0;
              if (stRead.Pos.y <= 0)
                {
                stRead.Pos.y = stRead.lHeight;
                stRead.rclDisp.yBottom = stRead.lHeight;
                stRead.rclDisp.yTop = stRead.lHeight + stCell.cy;
                }
              else
                {
                stRead.rclDisp.yTop = stRead.Pos.y;
                stRead.Pos.y -= stCell.cy;
                stRead.rclDisp.yBottom = stRead.Pos.y;
                }
              WinFillRect(hpsRead,&stRead.rclDisp,stRead.lBackgrndColor);
              if (stWrite.bSync)
                {
                bReadSync = TRUE;
                lWriteSyncLine = stRead.Pos.y;
                }
              }
            else
              {
              bLastReadWasNewLine = FALSE;
              if (CharPrintable(&byChar,&stRead))
                {
                if (bWriteSync && (stRead.Pos.x == 0))
                  {
                  if (stRead.Pos.y > lReadSyncLine)
                    lOldTop = stRead.Pos.y;
                  else
                    lOldTop = (stRead.lHeight + stCell.cy);
                  stRead.Pos.y = lReadSyncLine;
                  stRead.rclDisp.yBottom = (stRead.Pos.y - stCell.cy);
                  stRead.rclDisp.yTop = lOldTop;
                  WinFillRect(hpsRead,&stRead.rclDisp,stRead.lBackgrndColor);
                  bWriteSync = FALSE;
                  }
                GpiCharStringAt(hpsRead,&stRead.Pos,1,&byChar);
                if (stRead.bWrap && (stRead.Pos.x >= stRead.lWidth))
                  {
                  if (stRead.Pos.y <= 0)
                    {
                    stRead.Pos.y = stRead.lHeight;
                    stRead.rclDisp.yBottom = stRead.lHeight;
                    stRead.rclDisp.yTop = (stRead.lHeight + stCell.cy);
                    }
                  else
                    {
                    stRead.rclDisp.yTop = stRead.Pos.y;
                    stRead.Pos.y -= stCell.cy;
                    stRead.rclDisp.yBottom = stRead.Pos.y;
                    }
                  WinFillRect(hpsRead,&stRead.rclDisp,stRead.lBackgrndColor);
                  stRead.Pos.x  = 0;
                  }
                else
                  stRead.Pos.x += stCell.cx;
                }
              }
            break;
          case CS_WRITE_IMM:
          case CS_WRITE:
            if (stWrite.bFilter)
              byChar &= stWrite.byDisplayMask;
            if (stWrite.bTestNewLine && (byChar == stWrite.byNewLineChar))
              {
              if (stWrite.bSkipBlankLines && bLastWriteWasNewLine)
                break;
              bLastWriteWasNewLine = TRUE;
              if (CharPrintable(&byChar,&stWrite))
                if (stWrite.bWrap || (stWrite.Pos.x <= stWrite.lWidth))
                  GpiCharStringAt(hpsWrite,&stWrite.Pos,1,&byChar);
              stWrite.Pos.x = 0L;
              if (stWrite.Pos.y <= 0)
                {
                stWrite.Pos.y = stWrite.lHeight;
                stWrite.rclDisp.yBottom = stWrite.lHeight;
                stWrite.rclDisp.yTop = stWrite.lHeight + stCell.cy;
                }
              else
                {
                stWrite.rclDisp.yTop = stWrite.Pos.y;
                stWrite.Pos.y -= stCell.cy;
                stWrite.rclDisp.yBottom = stWrite.Pos.y;
                }
              WinFillRect(hpsWrite,&stWrite.rclDisp,stWrite.lBackgrndColor);
              if (stRead.bSync)
                {
                bWriteSync = TRUE;
                lReadSyncLine = stWrite.Pos.y;
                }
              }
            else
              {
              bLastWriteWasNewLine = FALSE;
              if (CharPrintable(&byChar,&stWrite))
                {
                if (bReadSync && (stWrite.Pos.x == 0))
                  {
                  if (stWrite.Pos.y > lWriteSyncLine)
                    lOldTop = stWrite.Pos.y;
                  else
                    lOldTop = (stWrite.lHeight + stCell.cy);
                  stWrite.Pos.y = lWriteSyncLine;
                  stWrite.rclDisp.yBottom = (stWrite.Pos.y - stCell.cy);
                  stWrite.rclDisp.yTop = lOldTop;
                  WinFillRect(hpsWrite,&stWrite.rclDisp,stWrite.lBackgrndColor);
                  bReadSync = FALSE;
                  }
                GpiCharStringAt(hpsWrite,&stWrite.Pos,1,&byChar);
                if (stWrite.bWrap && (stWrite.Pos.x >= stWrite.lWidth))
                  {
                  if (stWrite.Pos.y <= 0 )
                    {
                    stWrite.Pos.y = stWrite.lHeight;
                    stWrite.rclDisp.yBottom = stWrite.lHeight;
                    stWrite.rclDisp.yTop = stWrite.lHeight + stCell.cy;
                    }
                 else
                    {
                    stWrite.rclDisp.yTop = stWrite.Pos.y;
                    stWrite.Pos.y -= stCell.cy;
                    stWrite.rclDisp.yBottom = stWrite.Pos.y;
                    }
                  WinFillRect(hpsWrite,&stWrite.rclDisp,stWrite.lBackgrndColor);
                  stWrite.Pos.x  = 0;
                  }
                else
                  stWrite.Pos.x += stCell.cx;
                }
              }
            break;

          }
        }
      else
        {
        iPacketCount--;
        if (lReadIndex++ >= stCFG.lBufferLength)
          lReadIndex = 0;
        }
      }
    WinReleasePS(hpsRead);
    WinReleasePS(hpsWrite);
    DosReleaseMutexSem(hmtxColGioBlockedSem);
    }
//  WinPostMsg(hwndClient,UM_KILLDISPLAYTHREAD,0L,0L);
  DosPostEventSem(hevKillDisplayThreadSem);
//  DosExit(EXIT_THREAD,0);
  }

void APIENTRY MonitorThread(HFILE hCom)
  {
  LONG lIndex;
  LONG lDataLen;
  CSDATA *pstCOMscopeDataSet;
  ULONG ulCount;
  char szMessage[80];
  LONG lBaud;
  WORD *pwBuffer = pwCaptureBuffer;
  ULONG ulPostCount;
  WORD *pwCOMscopeData;
  WORD wChar;

  EnableCOMscope(hwndFrame,hCom,&ulCount,(stCFG.fTraceEvent | CSFUNC_RESET_BUFFERS));
  if (DosAllocMem((PPVOID)&pstCOMscopeDataSet,((ulCount * 2) + sizeof(ULONG)),PAG_COMMIT | PAG_READ | PAG_WRITE) != NO_ERROR)
    {
    EnableCOMscope(hwndFrame,hCom,&ulCount,FALSE);
    sprintf(szMessage,"Unable to allocate COMscope/COMi buffer (Monitor Thread).");
    ErrorNotify(szMessage);
    DosExit(EXIT_THREAD,0);
    }
  if (GetBaudRate(&stIOctl,hCom,&lBaud) == NO_ERROR)
    CalcThreadSleepCount(lBaud);
  else
    if (stCFG.ulUserSleepCount != 0)
      ulMonitorSleepCount = stCFG.ulUserSleepCount;
  pstCOMscopeDataSet->cbSize = (WORD)ulCount;
  pwCOMscopeData = (USHORT *)&pstCOMscopeDataSet->awData;
  bDataToView = FALSE;
  lWriteIndex = 0;
  lReadIndex = 0;
  memset(&stCharCount,0,sizeof(CHARCNT));
  bCaptureFileWritten = FALSE;
  bBufferWrapped = FALSE;
  WinPostMsg(hwndClient,UM_STARTMONITORTHREAD,0L,0L);
  DosSetPriority(PRTYS_THREAD,PRTYC_TIMECRITICAL,4L,tidMonitorThread);
  while (!bStopMonitorThread)
    {
    pstCOMscopeDataSet->cbSize = ulCount;
    AccessCOMscope(hCom,pstCOMscopeDataSet);
    if (pstCOMscopeDataSet->cbSize == 0)
      {
      DosResetEventSem(hevDisplayWaitDataSem,&ulPostCount);
      DosResetEventSem(hevWaitCOMiDataSem,&ulPostCount);
      DosWaitEventSem(hevWaitCOMiDataSem,ulMonitorSleepCount);
//      if (DosWaitEventSem(hevWaitCOMiDataSem,ulMonitorSleepCount) != ERROR_TIMEOUT)
//        bStopMonitorThread = TRUE;
      }
    else
      {
      DosPostEventSem(hevDisplayWaitDataSem);
      if (!bDataToView)
        {
        WinPostMsg(hwndClient,UM_VIEWDAT_ON,0L,0L);
        bDataToView = TRUE;
        }
      lDataLen = pstCOMscopeDataSet->cbSize;
      for (lIndex = 0;lIndex < lDataLen;lIndex++)
        {
        if (lWriteIndex >= stCFG.lBufferLength)
          {
          if (stCFG.bCaptureToFile)
            {
            DosAllocMem((PPVOID)&pwBuffer,(stCFG.lBufferLength * 2),PAG_COMMIT | PAG_READ | PAG_WRITE);
            if (pwBuffer != NULL)
              {
              WinPostMsg(hwndClient,UM_BUFFER_END,(MPARAM)pwCaptureBuffer,0L);
              pwCaptureBuffer = pwBuffer;
              lReadIndex = 0;
              }
            else
              {
              sprintf(szMessage,"Unable to allocate new capture buffer (Monitor Thread).");
              ErrorNotify(szMessage);
              bStopMonitorThread = TRUE;
              break;
              }
            }
          else
            {
            if (!stCFG.bOverWriteBuffer)
              {
              WinPostMsg(hwndClient,UM_BUFFER_END,0L,0L);
              bStopMonitorThread = TRUE;
              break;
              }
            else
              bBufferWrapped = TRUE;
            }
          lWriteIndex = 0;
          }
        wChar = pwCOMscopeData[lIndex];
        switch (wChar & 0xff00)
          {
          case CS_READ:
            stCharCount.lRead++;
            break;
          case CS_WRITE:
            stCharCount.lWrite++;
            break;
          case CS_WRITE_IMM:
            stCharCount.lWriteImm++;
            break;
          case CS_READ_IMM:
            stCharCount.lReadImm++;
            break;
          }
        pwBuffer[lWriteIndex++] = wChar;
//        DosEnterCritSec();
//        if (lWriteIndex == lReadIndex)
//          lReadIndex++;
//        DosExitCritSec();
        }
      }
    }
  EnableCOMscope(hwndFrame,hCom,&ulCount,FALSE);
  DosFreeMem(pstCOMscopeDataSet);
  lReadIndex = lWriteIndex;
  if (stCFG.bCaptureToFile && (lWriteIndex != 0))
    {
    WriteCaptureFile(szCaptureFileName,pwCaptureBuffer,lWriteIndex,FOPEN_OVERWRITE,HLPP_MB_OVERWRT_CAP_FILE);
//  IncrementFileExt(szCaptureFileName,FALSE);
    }
  WinPostMsg(hwndClient,UM_KILLMONITORTHREAD,(MPARAM)lWriteIndex,0L);
  DosPostEventSem(hevKillMonitorThreadSem);
//  DosExit(EXIT_THREAD,0);
  }

BOOL KillMonitorThread(void)
  {
  ULONG ulPostCount;

  if (!bStopMonitorThread)
    {
    DosResetEventSem(hevKillMonitorThreadSem,&ulPostCount);
    bStopMonitorThread = TRUE;
    DosPostEventSem(hevWaitCOMiDataSem);
    DosWaitEventSem(hevKillMonitorThreadSem,10000);
    return(TRUE);
    }
  return(FALSE);
  }

BOOL KillDisplayThread(void)
  {
  ULONG ulPostCount;

  if (!bStopDisplayThread)
    {
    DosResetEventSem(hevKillDisplayThreadSem,&ulPostCount);
    bStopDisplayThread = TRUE;
    DosPostEventSem(hevDisplayWaitDataSem);
    DosWaitEventSem(hevKillDisplayThreadSem,10000);
    return(TRUE);
    }
  return(FALSE);
  }

void APIENTRY IPCserverThread(void)
  {
  APIRET rc;
  char szMessage[40];
  char szServerTitle[80];
  char szServerProgram[CCHMAXPATH];

  DosSetPriority(PRTYS_THREAD,PRTYC_TIMECRITICAL,10L,tidIPCserverThread);
  if (bIsTheFirst)
    {
    stSD.Length = sizeof(STARTDATA);
    stSD.Related = SSF_RELATED_INDEPENDENT;
    if (bShowServerProcess)
      stSD.FgBg = SSF_FGBG_FORE;
    else
      stSD.FgBg = SSF_FGBG_BACK;
    stSD.TraceOpt = SSF_TRACEOPT_NONE;
    stSD.TermQ = 0;
    stSD.Environment = 0;
    stSD.InheritOpt = SSF_INHERTOPT_SHELL;
    stSD.SessionType = SSF_TYPE_WINDOWABLEVIO;
    stSD.IconFile = 0;
    stSD.PgmHandle = 0;
    stSD.ObjectBuffer = 0;
    stSD.ObjectBuffLen = 0;
    sprintf(szServerTitle,"OS/tools IPC Server - %s",szIPCpipeName);
    sprintf(szServerProgram,"%sCONTROL.EXE",szCOMscopeIniPath);
    stSD.PgmTitle = szServerTitle;
    stSD.PgmName = (PSZ)szServerProgram;
    stSD.PgmInputs = szServerCommand;
    if (bShowServerProcess)
      {
      stSD.PgmControl = SSF_CONTROL_NOAUTOCLOSE;
      stSD.FgBg = SSF_FGBG_FORE;
      sprintf(szServerCommand,"/T%s /D%c",szIPCpipeName,chPipeDebug);
      }
    else
      {
      stSD.PgmControl = SSF_CONTROL_INVISIBLE;
      stSD.FgBg = SSF_FGBG_BACK;
      sprintf(szServerCommand,"/T%s",szIPCpipeName);
      }
    rc = DosStartSession(&stSD,&ulSessionID,&pidSession);
    if ((chPipeDebug > '0') && (rc != NO_ERROR))
      switch (rc)
        {
        case ERROR_SMG_INVALID_SESSION_ID:
          ErrorNotify("Invalid Session ID, starting IPC server");
          break;
        case ERROR_SMG_INVALID_CALL:
//          ErrorNotify("Invalid Call, starting IPC server");
          ErrorNotify(szServerProgram);
          break;
        case ERROR_SMG_PROCESS_NOT_PARENT:
          ErrorNotify("Error starting IPC server - Process not parent");
          break;
        case ERROR_SMG_RETRY_SUB_ALLOC:
          ErrorNotify("Retry Sub-Allocation, starting IPC server");
          break;
        default:
          sprintf(szMessage,"Unkown Error = %u - starting IPC server",rc);
          ErrorNotify(szMessage);
          break;
        }
    DosSleep(500);
    }
  stIPCpipe.ulMessage = UM_PIPE_INIT;
  if (bIPCpipeOpen)
    {
    DosTransactNPipe(hIPCpipe,&stIPCpipe,sizeof(IPCPIPEMSG),&stIPCpipe,sizeof(IPCPIPEMSG),&ulBytesRead);
    DosClose(hIPCpipe);
    }
  else
    while (DosCallNPipe(szIPCpipe,&stIPCpipe,sizeof(IPCPIPEMSG),&stIPCpipe,sizeof(IPCPIPEMSG),&ulBytesRead,10000) == ERROR_PIPE_BUSY);

  WinPostMsg(hwndClient,UM_ENABLE_SERVER_ACCESS,0L,0l);
  ulIPCpipeInstance = stIPCpipe.ulInstance;
  while (!bStopIPCserverThread)
    {
    DosRequestMutexSem(hmtxIPCpipeBlockedSem,10000);
    stIPCpipe.ulInstance = ulIPCpipeInstance;
    if (ulServerMessage != 0)
      {
      stIPCpipe.ulMessage = ulServerMessage;
      ulServerMessage = 0;
      }
    else
      stIPCpipe.ulMessage = UM_PIPE_WD;
    while ((rc = DosCallNPipe(szIPCpipe,&stIPCpipe,sizeof(IPCPIPEMSG),&stIPCpipe,sizeof(IPCPIPEMSG),&ulBytesRead,10000)) == ERROR_PIPE_BUSY)
      if (chPipeDebug > '0')
        ErrorNotify("Pipe busy, sending watchdog message");
    if (rc == ERROR_INTERRUPT)
      bStopIPCserverThread = TRUE;
    if (!bStopIPCserverThread)
      if (rc == NO_ERROR)
        {
        ulIPCpipeInstance = stIPCpipe.ulInstance;
        if (stIPCpipe.ulMessage == UM_PIPE_QUIT)
          {
          bAbort = TRUE;
          bStopIPCserverThread = TRUE;
          WinPostMsg(hwndClient,UM_PIPE_QUIT,0,0);
          }
        else
          if (stIPCpipe.ulMessage != UM_PIPE_ACK)
            WinPostMsg(hwndClient,(SHORT)stIPCpipe.ulMessage,0,0);
        }
    DosReleaseMutexSem(hmtxIPCpipeBlockedSem);
    if (!bStopIPCserverThread)
      DosSleep(2000);
    }
//  DosExit(1,0);
  }

#define NPopenMode  (NP_NOWRITEBEHIND | NP_ACCESS_DUPLEX)
#define NPpipeMode  (NP_NOWAIT | NP_TYPE_MESSAGE | NP_READMODE_MESSAGE | 0x01) // one instance
#define NPtimeout   2000

void APIENTRY RemoteServerThread(void)
  {
//  APIRET rc;
  ULONG ulPostCount;
  ULONG ulBytesWritten;
  ULONG ulBytesRead;
  void *pstData;

  ErrorNotify("Remote Server Started");
  if (DosCreateNPipe(szCOMscopePipe,&hCOMscopePipe,NPopenMode,NPpipeMode,sizeof(PIPEMSG),sizeof(PIPEMSG),NPtimeout) == NO_ERROR)
    {
//    DosSetPriority(PRTYS_THREAD,PRTYC_TIMECRITICAL,-10L,tidRemoteServerThread);
    DosCreateEventSem(0L,&hevCOMscopeSem,TRUE,FALSE);
    DosSetNPipeSem(hCOMscopePipe,(HSEM)hevCOMscopeSem,0L);
    stPipeCmd.cbMsgSize = sizeof(PIPECMD);
    bStopRemotePipe = FALSE;
    while (!bStopRemotePipe)
      {
      DosConnectNPipe(hCOMscopePipe);
      DosResetEventSem(hevCOMscopeSem,&ulPostCount);
      DosWaitEventSem(hevCOMscopeSem,-1);
      DosRead(hCOMscopePipe,&stPipeMsg,sizeof(PIPEMSG),&ulBytesRead);
      switch (stPipeMsg.ulCommand)
        {
        case UM_PIPE_END:
          ErrorNotify("Session Close message received - Closing this session");
          stPipeCmd.ulCommand = UM_PIPE_ACK;
          stPipeMsg.cbMsgSize = sizeof(PIPEMSG);
          DosWrite(hCOMscopePipe,&stPipeCmd,sizeof(PIPECMD),&ulBytesWritten);
          DosSleep(2000);
          WinPostMsg(hwndClient,UM_PIPE_QUIT,0,0);
          bStopRemotePipe = TRUE;
          break;
#ifdef this_junk
        case UM_REM_DEVICE_LIST:
//          DestroyList(&pstDeviceList);
//          pstDeviceList = InitializeList(pstDeviceList);
//          if (FillDeviceNameList(pstDeviceList,&stDeviceCount))
//            stPipeMsg.ulCommand = UM_PIPE_ACK;
//          else
//            stPipeMsg.ulCommand = UM_PIPE_NAK;
          ulCount = 10;
          if (stDeviceCount.wDCBnumber > 1)
            {
            stPipeMsg.Data.wData = stDeviceCount.wDCBnumber;
            pbyData = &stPipeMsg.Data.abyData[2];
            pListItem = pstDeviceList;
            for (wIndex = 0;wIndex < stDeviceCount.wDCBnumber;wIndex++)
              {
              strncpy(pstData,pListItem->pData,8);
              pListItem = pListItem->pTail;
              pbyData += 8;
              ulCount += 8;
              }
            }
          else
            stPipeMsg.Data.wData = 0;
          DosWrite(hCOMscopePipe,&stPipeMsg,ulCount,&ulBytesWritten);
          ErrorNotify("Device list received");
          break;
#endif
        default:
          if (stPipeMsg.cbDataSize != 0)
            {
            pstData = malloc(stPipeMsg.cbDataSize + 2);
            memcpy(pstData,&stPipeMsg.Data.abyData,stPipeMsg.cbDataSize);
            WinPostMsg(hwndClient,stPipeMsg.ulCommand,(MPARAM)stPipeMsg.cbDataSize,pstData);
            }
          else
            WinPostMsg(hwndClient,stPipeMsg.ulCommand,0,0);
          stPipeCmd.ulCommand = UM_PIPE_ACK;
          stPipeMsg.cbMsgSize = sizeof(PIPEMSG);
          DosWrite(hCOMscopePipe,&stPipeCmd,sizeof(PIPECMD),&ulBytesWritten);
          break;
        }
      DosDisConnectNPipe(hCOMscopePipe);
      }
    DosDisConnectNPipe(hCOMscopePipe);
    DosClose(hCOMscopePipe);
    DosCloseEventSem(hevCOMscopeSem);
    }
  else
    ErrorNotify("Unable to create remote named pipe\n");
  }

