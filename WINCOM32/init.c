#include "wCommon.h"

#pragma hdrstop

#include "dialog.h"

extern PRF_DATA pfnGetProfileData;

extern COMICFG stCOMiCFG;
extern COMCTL stComCtl;
extern IOCTLINST stIOctlInst;

extern LONG lYScr;
extern LONG lYfullScr;
extern LONG lcyBrdr;
extern LONG lXScr;
extern LONG lXfullScr;
extern LONG lcxVSc;
extern LONG lcxBrdr;
extern LONG lcyMenu;
extern LONG lcyTitleBar;

extern SWP swpLastPosition;

extern HAB habAnchorBlock;
extern HWND hwndFrame;
extern HWND hwndClient;
extern CHAR szTitle[];

extern HPROF hProfileInstance;

extern BOOL fLastSize;
extern LONG lLastHeight;
extern LONG lLastWidth;

char szCurrentPortName[20] = "         ";

void WindowInit(THREAD *pstThd)
  {
  CONFIG *pCfg = &pstThd->stCfg;
  THREADCTRL *pThread = &pstThd->stThread;
  VIOPS *pVio = &pstThd->stVio;

  pstThd->hsemStartRead = &pstThd->StartReadSem;
  pstThd->StartReadSem = 0L;
  pstThd->hsemStartWrite = &pstThd->StartWriteSem;
  pstThd->StartWriteSem = 0L;
  pstThd->bBreakOn = FALSE;
  pstThd->pWriteString = NULL;

  pVio->wBackground = WHITE;
  pVio->wForeground = BLACK;

  pThread->KillReadThreadSem = 0L;
  pThread->KillThreadSem = 0L;
  pThread->RestartThreadSem = 0L;
  pThread->bStopThread = TRUE;
  pThread->idThread = 0;
  pThread->idReadThread = 0;

#ifdef this_junk
  pDT->ack_char       = ACK;
  pDT->nak_char       = NAK;
  pDT->soh_char       = SOH;
  pDT->eot_char       = EOT;
  pDT->crc_char       = CRC;
  pDT->wStartDelay    = 10000;
  pDT->wPacketDelay   = 500;
  pDT->wContinueDelay = 1000;
  pDT->wMaxRetries    = 25;
  pDT->wCurRetries      = 0;
  pDT->wPacketSize    = 128;
  pDT->bContinous     = TRUE;
  pDT->error_detection = 1;
  pDT->pszFileName      = NULL;
  pDT->hFile = NULL;

  mk_crctable(crctable);      /* make CRC table */
#endif

  pCfg->wSimulateType = 0;
  pCfg->bAllowWrite = TRUE;
  pCfg->bWriteCharacters = FALSE;
  pCfg->wWriteStringLength = 50;
  pCfg->bSlave = FALSE;
  pCfg->bHalfDuplex = TRUE;
  pCfg->wLoopTime = 0;
  pCfg->bLongString = TRUE;
  pCfg->bMakeAlpha = FALSE;
  pCfg->bWriteAppendSeries = TRUE;
  pCfg->wWriteCounter = 0;
  pCfg->bWriteAppendChar = TRUE;
  pCfg->chWriteAppendChar = 13;
  pCfg->bAllowRead = TRUE;
  pCfg->bReadCharacters = TRUE;
  pCfg->bReadAppendChar = TRUE;
  pCfg->chReadAppendChar = 10;
  pCfg->chReadAppendTriggerChar = 13;
  pCfg->chReadCompleteChar = 13;
  pCfg->wReadStringLength = 80;
  pCfg->bErrorOut = FALSE;
  pCfg->bContinuous = FALSE;
  pCfg->bEnableAnsi = TRUE;
  }

void StartSystem(THREAD *pstThd,BOOL bRestart)
  {
  ULONG ulWordCount;
  char szCaption[80];
  char szMessage[80];
  LONG fWriteMode;
  HMODULE hMod;
  BOOL bPortAvailable;
  DCB stComDCB;
  CONFIG *pstCFG = &pstThd->stCfg;

  if ((hProfileInstance != NULL) && pstCFG->bLoadWindowPosition && !bRestart)
    {
    swpLastPosition.x = pstCFG->ptlFramePos.x;
    swpLastPosition.y = pstCFG->ptlFramePos.y;
    swpLastPosition.cx = pstCFG->ptlFrameSize.x;
    swpLastPosition.cy = pstCFG->ptlFrameSize.y;
    WinSetWindowPos(hwndFrame,HWND_TOP,pstCFG->ptlFramePos.x,
                                       pstCFG->ptlFramePos.y,
                                       pstCFG->ptlFrameSize.x,
                                       pstCFG->ptlFrameSize.y,
                                      (SWP_MOVE | SWP_SIZE));
    }
  MenuItemCheck(hwndFrame,IDM_SSTART,FALSE);
  MenuItemCheck(hwndFrame,IDM_SPAUSE,TRUE);
  MenuItemEnable(hwndFrame,IDM_SSTART,FALSE);
  MenuItemEnable(hwndFrame,IDM_SPAUSE,FALSE);
  MenuItemEnable(hwndFrame,IDM_IOCTL,FALSE);
  MenuItemEnable(hwndFrame,IDM_FUNC,FALSE);
  MenuItemEnable(hwndFrame,IDM_MTERMINAL,FALSE);
  MenuItemEnable(hwndFrame,IDM_MSTRING,FALSE);
  switch (pstCFG->wSimulateType)
    {
    case TERMINAL:
      MenuItemEnable(hwndFrame,IDM_MTERMINAL,TRUE);
      break;
    case STRING_TRANSFER:
      MenuItemEnable(hwndFrame,IDM_MSTRING,TRUE);
      break;
    }
  if (!pstCFG->bLongString)
    {
    GetMessageBuffer((PPVOID)&pstThd->pWriteString,pstCFG->wWriteStringLength);
    if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
      {
      if (DosQueryProcAddr(hMod,0,"GetProfileData",(PFN *)&pfnGetProfileData) == NO_ERROR)
        {
        GetMessageBuffer((PPVOID)&pstThd->pWriteString,pstCFG->wWriteStringLength);
        pstCFG->wWriteStringLength = pfnGetProfileData(hProfileInstance,"Write String",(BYTE *)pstThd->pWriteString,pstCFG->wWriteStringLength);
        }
      DosFreeModule(hMod);
      }
    }
  else
    MakeLongString(pstThd,pstCFG->wWriteStringLength,pstCFG->bMakeAlpha);
  MenuItemCheck(hwndFrame,IDM_ANSI,pstCFG->bEnableAnsi);
  MenuItemCheck(hwndFrame,IDM_ERRDISP,pstCFG->bErrorOut);
  sprintf(szTitle,"WinCOM");
  if (pstCFG->bLoadMonitor && (strlen(pstCFG->szPortName) != 0))
    {
    if (strcmp(pstCFG->szPortName,szCurrentPortName) != 0)
      {
      if (pstThd->hCom != 0)
        DosClose(pstThd->hCom);
      OpenPort(pstThd);
      strcpy(szCurrentPortName,pstCFG->szPortName);
      }
    if (pstThd->hCom != 0)
      {
      MenuItemEnable(hwndFrame,IDM_IOCTL,TRUE);
      if (GetDCB(&stIOctlInst,pstThd->hCom,&stComDCB) == NO_ERROR)
        {
        MenuItemEnable(hwndFrame,IDM_FUNC,TRUE);
        if ((stComDCB.Flags3 & 0x18) == 0)
          MenuItemEnable(hwndFrame,IDM_FIFO,FALSE);
        sprintf(szTitle,"WinCOM -> %s",pstCFG->szPortName);
        SendDCB(&stIOctlInst,pstThd->hCom,&pstCFG->stComDCB);
        SetBaudRate(&stIOctlInst,pstThd->hCom,pstCFG->lBaudRate);
        SetLineCharacteristics(&stIOctlInst,pstThd->hCom,&pstCFG->stLineCharacteristics);
        if (bRestart && pstCFG->bExecuting && (pstCFG->wSimulateType != 0))
          {
          MenuItemCheck(hwndFrame,IDM_SSTART,TRUE);
          MenuItemCheck(hwndFrame,IDM_SPAUSE,FALSE);
          MenuItemEnable(hwndFrame,IDM_SPAUSE,TRUE);
          MenuItemEnable(hwndFrame,IDM_SSTART,FALSE);
          if (pstThd->stThread.idThread == 0)
            CreateThread(pstThd);
          WinInvalidateRect(pstThd->hwndStatus,(PRECTL)NULL,FALSE);
          }
        }
      }
    }
  WinSetWindowText(hwndFrame,szTitle);
  }

#ifdef this_junk
void InitializeData(void)
  {
  stComCtl.cbSize = sizeof(COMCTL);
  stComCtl.pszPortName = stThisWindow.stCfg.szPortName;
  stComCtl.pstIOctl = &stIOctl;

  stThisWindow.cbSize = sizeof(THREAD);
  stThisWindow.stCfg.szPortName[0] = 0;
  stThisWindow.stCfg.bErrorOut = FALSE;
  stThisWindow.stCfg.bExecuting = FALSE;
  stThisWindow.stCfg.bLoadMonitor = FALSE;
  stThisWindow.stCfg.bAutoSaveConfig = FALSE;
  stThisWindow.stCfg.bLoadWindowPosition = FALSE;
  }
#endif
