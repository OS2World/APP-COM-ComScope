#include "COMMON.H"
#include "COMDD.H"
#include "ioctl.h"
#include "utility.h"
#include "help.h"
#include "ComControl.h"
#include "COMi_CFG.H"
#include "resource.h"

MRESULT EXPENTRY fnwpDefThresholdDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpReceiveBuffDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpTransmitBuffDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpCOMscopeBuffDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpPortConfigDeviceDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpCfgProtocolDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpCfgTimeoutDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpCfgFilterDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpHdwDefFIFOsetupDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpCfgHDWhandshakeDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpCfgASCIIhandshakeDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpCfgBaudRateDlg(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpPortExtensionsDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);

ULONG InsertNotebookPage(HWND hwndDlg,HWND hwndNoteBook,
                         char szTabText[],
                         char szStatusText[],
                         USHORT usTabType,
                         PFNWP fnwpDlgProc,
                         ULONG ulDlgId,
                         NBKPAGECTL *pstPage);

static BOOL SaveChanges(void);

extern HMODULE hThisModule;
extern BOOL bWarp4;

NBKPAGECTL astPages[MAX_NOTEBOOK_PAGES];

HWND hwndNoteBookDlg;
LONG lOrgXonHysteresis;
LONG lOrgXoffThreshold;
LONG lXonHysteresis;
LONG lXoffThreshold;
ULONG ulOrgReadBuffLen;
ULONG ulReadBuffLen;

extern BOOL bInsertNewDevice;
extern BOOL bSpoolSetupInUse;

static char const szSpoolerDescriptionFormat[] = "Serial Port Settings - %s";
static char szSpoolerDescription[61];

extern DCBHEAD stGlobalCFGheader;
extern DCBHEAD stGlobalDCBheader;
extern DCBHEAD stTempCFGheader;
extern DCBHEAD stTempDCBheader;
extern char szDeviceDescription[];
extern char szInitDeviceDescription[];

MRESULT EXPENTRY fnwpDeviceSetupDlgProc(HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2)
  {
  static COMICFG *pstCOMiCFG;
  static ULONG ulTopPageId;
  static int iPageCount;
  static HWND hwndNoteBook;
  static ULONG ulFocusId;
  PAGESELECTNOTIFY *pPageSelect;
  HPOINTER hptrPrev;
  HPOINTER hptrWait;
  ULONG ulNewPageId;
  static int iPageIndex;
  char szStatusText[41];
  NBKPAGECTL *pstPage;
  static BOOL bAllowControls;
  USHORT usTabType;
  char szTabText[40];

  switch(msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwnd);
      bAllowControls = FALSE;
      hwndNoteBook = WinWindowFromID(hwnd,PCFG_NOTEBOOK);
      hwndNoteBookDlg = hwnd;
      pstCOMiCFG = PVOIDFROMMP(mp2);
      /*
      ** Set the wait pointer.
      */
      hptrPrev = WinQueryPointer(HWND_DESKTOP);
      hptrWait = WinQuerySysPointer(HWND_DESKTOP, SPTR_WAIT, FALSE);
      WinSetPointer(HWND_DESKTOP, hptrWait);
      /*
      ** set notebook globals
      */
      WinSendMsg(hwndNoteBook, BKM_SETNOTEBOOKCOLORS,
                 MPFROMLONG(SYSCLR_DIALOGBACKGROUND),
                 MPFROMLONG(BKA_BACKGROUNDPAGECOLORINDEX));

      WinSendMsg(hwndNoteBook, BKM_SETNOTEBOOKCOLORS,
                 MPFROMLONG(SYSCLR_DIALOGBACKGROUND),
                 MPFROMLONG(BKA_BACKGROUNDMAJORCOLORINDEX));

      WinSendMsg(hwndNoteBook, BKM_SETDIMENSIONS,
                 MPFROM2SHORT(100, 25), (MPARAM)BKA_MAJORTAB);

      if (!bWarp4)
        WinSendMsg(hwndNoteBook, BKM_SETDIMENSIONS,
                   MPFROM2SHORT(100, 25), (MPARAM)BKA_MINORTAB);

      iPageIndex = 0;
      memset(astPages,0,(sizeof(NBKPAGECTL) * MAX_NOTEBOOK_PAGES));
      /*************************************************************************************
      **  Insert Device page (MAJOR)
      **
      **  This is the top page for normal COMi configuration.
      **
      **  The top page cannot have sub pages!  This is restricted by the algorithm used
      **  by this process, not the API.  See DID_OK and BKN_PAGESELECTED processing, below.
      */
      if (!pstCOMiCFG->bSpoolerConfig)
        {
        memcpy(&stTempCFGheader,&stGlobalCFGheader,sizeof(CFGHEAD));
        memcpy(&stTempDCBheader,&stGlobalDCBheader,sizeof(DCBHEAD));
        astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader;
        astPages[iPageIndex].pVoidPtrTwo = &stTempCFGheader;
        astPages[iPageIndex].pVoidPtrThree = pstCOMiCFG;
        astPages[iPageIndex].usHelpId = HLPP_DEVICE_SETUP_DLG;
        ulTopPageId = InsertNotebookPage(hwnd,hwndNoteBook,
                                        "~Interface",0,
                                         BKA_MAJOR,
                                  (PFNWP)fnwpPortConfigDeviceDlgProc,
                                         PCFG_DEV,
                                        &astPages[iPageIndex]);
        astPages[iPageIndex].usFocusId = PCFG_NAME_LIST;
        iPageIndex++;
        }
      /*********************************************************************************
      **  Insert Timeouts Page (MAJOR)
      **
      **  This is the top page for spooler device configuration.
      */
      astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
      if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
        astPages[iPageIndex].usHelpId = HLPP_DEF_TIMEOUT_DLG;
      else
        astPages[iPageIndex].usHelpId = HLPP_TIMEOUT_DLG;
      ulNewPageId = InsertNotebookPage(hwnd,hwndNoteBook,
                                   "~Timeouts",0,
                                    BKA_MAJOR,
                             (PFNWP)fnwpCfgTimeoutDlg,
                                    HWT_DLG,
                                   &astPages[iPageIndex]);
      astPages[iPageIndex].usFocusId = HWT_RNORM;
      iPageIndex++;

      if (pstCOMiCFG->bSpoolerConfig)
        {
        ulTopPageId = ulNewPageId;
        ulFocusId = HWT_RNORM;
        }
       /*********************************************************************************
      ** Insert Protocol pages (MAJOR)
      */
      if (!bWarp4)
        {
        InsertNotebookPage(hwnd,hwndNoteBook,
                          "~Protocols",0,
                           BKA_MAJOR,
                           0,
                           0,
                           &astPages[iPageIndex]);
        astPages[iPageIndex].ulPrevPageId = astPages[iPageIndex - 1].ulPageId;
        iPageIndex++;
        }
      /*************************************************************************************
      **  Insert line porotcol Page (MAJOR/MINOR)
      */
      if (bWarp4)
        {
        usTabType = (BKA_MINOR | BKA_MAJOR | BKA_STATUSTEXTON);
        strcpy(szTabText,"~Protocols");
        }
      else
        {
        usTabType = (BKA_MINOR | BKA_STATUSTEXTON);
        strcpy(szTabText,"~Line Protocol");
        }
      astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB.byLineCharacteristics;
      if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
        astPages[iPageIndex].usHelpId = HLPP_DEF_LINE_PROTOCOL_DLG;
      else
        astPages[iPageIndex].usHelpId = HLPP_LINE_PROTOCOL_DLG;
      ulNewPageId = InsertNotebookPage(hwnd,hwndNoteBook,
                                       szTabText,"Page 1 of 2 ",
                                       usTabType,
                                (PFNWP)fnwpCfgProtocolDlg,
                                       HWPT_DLG,
                                      &astPages[iPageIndex]);
      astPages[iPageIndex - 1].ulSubPageId = ulNewPageId;
      astPages[iPageIndex].usFocusId = HWP_8BITS;
      iPageIndex++;
      /*************************************************************************************
      **  Insert baud rate Page (MINOR)
      */
      if (bWarp4)
        strcpy(szTabText,"~Protocols");
      else
        strcpy(szTabText,"~Baud rate");
      astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB.ulBaudRate;
      if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
        astPages[iPageIndex].usHelpId = HLPP_DEF_BAUD_DLG;
      else
        {
        astPages[iPageIndex].ulSpare = pstCOMiCFG->ulSpare; // set max baud rate
        astPages[iPageIndex].usHelpId = HLPP_BAUD_DLG;
        }
      ulNewPageId = InsertNotebookPage(hwnd,hwndNoteBook,
                                      szTabText,"Page 2 of 2 ",
                                      (BKA_MINOR | BKA_STATUSTEXTON),
                                (PFNWP)fnwpCfgBaudRateDlg,
                                       BAUD_DLG,
                                      &astPages[iPageIndex]);
      astPages[iPageIndex].usFocusId = HWB_BAUD;
      iPageIndex++;
      /*********************************************************************************
      ** Insert Handshaking page (MAJOR)
      */
      if (!bWarp4)
        {
        InsertNotebookPage(hwnd,hwndNoteBook,
                          "~Handshaking",0,
                           BKA_MAJOR,
                           0,
                           0,
                           &astPages[iPageIndex]);
        astPages[iPageIndex].ulPrevPageId = astPages[iPageIndex - 1].ulPageId;
        iPageIndex++;
        }
      /*************************************************************************************
      **  Insert ASCII handshaking Page (MINOR)
      */
      if (bWarp4)
        {
        usTabType = (BKA_MINOR | BKA_MAJOR | BKA_STATUSTEXTON);
        strcpy(szTabText,"~Handshaking");
        }
      else
        {
        usTabType = (BKA_MINOR | BKA_STATUSTEXTON);
        strcpy(szTabText,"~ASCII (Xon/Xoff)");
        }
      astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
      if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
        {
        astPages[iPageIndex].usHelpId = HLPP_DEF_HANDSHAKE_DLG;
        strcpy(szStatusText,"Page 1 of 3 ");
        }
      else
        {
        astPages[iPageIndex].usHelpId = HLPP_HANDSHAKE_DLG;
        strcpy(szStatusText,"Page 1 of 2 ");
        }
      ulNewPageId = InsertNotebookPage(hwnd,hwndNoteBook,
                                   szTabText,szStatusText,
                                   usTabType,
                             (PFNWP)fnwpCfgASCIIhandshakeDlg,
                                    PCFG_ASCII_HS_DLG,
                                   &astPages[iPageIndex]);
      astPages[iPageIndex - 1].ulSubPageId = ulNewPageId;
      astPages[iPageIndex].usFocusId = HS_TXFLOW;
      iPageIndex++;
      /*************************************************************************************
      **  Insert Modem signal handshaking Page (MINOR)
      */
      if (bWarp4)
        strcpy(szTabText,"~Handshaking");
      else
        strcpy(szTabText,"~Hardware (modem)");
      astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
      if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
        {
        astPages[iPageIndex].usHelpId = HLPP_DEF_HANDSHAKE_DLG;
        strcpy(szStatusText,"Page 2 of 3 ");
        }
      else
        {
        astPages[iPageIndex].usHelpId = HLPP_HANDSHAKE_DLG;
        strcpy(szStatusText,"Page 2 of 2 ");
        }
      InsertNotebookPage(hwnd,hwndNoteBook,
                        szTabText,szStatusText,
                         (BKA_MINOR | BKA_STATUSTEXTON),
                 (PFNWP)fnwpCfgHDWhandshakeDlg,
                         PCFG_HDW_HS_DLG,
                         &astPages[iPageIndex]);
      astPages[iPageIndex].usFocusId = HS_CTSOUT;
      iPageIndex++;
      if (!pstCOMiCFG->bSpoolerConfig)
        {
        /*************************************************************************************
        **  Insert Threshold Page (MINOR)
        */
        if (bWarp4)
          strcpy(szTabText,"~Handshaking");
        else
          strcpy(szTabText,"~Thresholds");
        astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
        if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
          astPages[iPageIndex].usHelpId = HLPP_DEF_THRESHOLD_DLG;
        else
          astPages[iPageIndex].usHelpId = HLPP_THRESHOLD_DLG;
        if ((lOrgXoffThreshold = stTempDCBheader.stComDCB.wXoffThreshold) == 0)
          lOrgXoffThreshold = 128;
        if (stTempDCBheader.stComDCB.wXonHysteresis == 0)
          lOrgXonHysteresis = ((stTempDCBheader.stComDCB.wReadBufferLength / 2) - lOrgXoffThreshold);
        else
          lOrgXonHysteresis = stTempDCBheader.stComDCB.wXonHysteresis;
        lXonHysteresis = lOrgXonHysteresis;
        lXoffThreshold = lOrgXoffThreshold;
        astPages[iPageIndex].bRecalcEach = TRUE;
        InsertNotebookPage(hwnd,hwndNoteBook,
                          szTabText,"Page 3 of 3 ",
                           (BKA_MINOR | BKA_STATUSTEXTON),
                    (PFNWP)fnwpDefThresholdDlg,
                           PCFG_THRESHOLDS_DLG,
                           &astPages[iPageIndex]);
        astPages[iPageIndex].usFocusId = PCFG_XOFF_THRESHOLD;
        iPageIndex++;
        }
      /*********************************************************************************
      **  Insert Filters Page (MAJOR)
      */
      astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
      if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
        astPages[iPageIndex].usHelpId = HLPP_DEF_FILTER_DLG;
      else
        astPages[iPageIndex].usHelpId = HLPP_FILTER_DLG;
      InsertNotebookPage(hwnd,hwndNoteBook,
                        "~Stream filters",0,
                         BKA_MAJOR,
                  (PFNWP)fnwpCfgFilterDlg,
                         HWR_DLG,
                         &astPages[iPageIndex]);
      astPages[iPageIndex].usFocusId = HWR_ENABERR;
      iPageIndex++;
      /*************************************************************************************
      **  Insert FIFO Page (MAJOR)
      */
      astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
      if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
        astPages[iPageIndex].usHelpId = HLPP_DEF_FIFO_DLG;
      else
        astPages[iPageIndex].usHelpId = HLPP_FIFO_DLG;
      InsertNotebookPage(hwnd,hwndNoteBook,
                        "~FIFO setup",0,
                         BKA_MAJOR,
                  (PFNWP)fnwpHdwDefFIFOsetupDlg,
                         HWF_DLG,
                         &astPages[iPageIndex]);
      astPages[iPageIndex].usFocusId = HWF_ENABFIFO;
      iPageIndex++;
      if (!pstCOMiCFG->bSpoolerConfig)
        {
        /****************************************************************************
        ** Insert COMi Buffers page (MAJOR)
        */
        if (!bWarp4)
          {
          InsertNotebookPage(hwnd,hwndNoteBook,
                            "~COMi buffers",0,
                             BKA_MAJOR,
                             0,
                             0,
                             &astPages[iPageIndex]);
          astPages[iPageIndex].ulPrevPageId = astPages[iPageIndex - 1].ulPageId;
          iPageIndex++;
          }
        /****************************************************************************
        ** Insert Receive COMi Buffers page (MINOR)
        */
        if (bWarp4)
          {
          usTabType = (BKA_MINOR | BKA_MAJOR | BKA_STATUSTEXTON);
          strcpy(szTabText,"~COMi buffers");
          }
        else
          {
          usTabType = (BKA_MINOR | BKA_STATUSTEXTON);
          strcpy(szTabText, "~Receive");
          }
        astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
        astPages[iPageIndex].usHelpId = HLPP_BUFFER_SETUP_DLG;
        ulReadBuffLen = stTempDCBheader.stComDCB.wReadBufferLength;
        if (ulReadBuffLen == 0)
          ulReadBuffLen = DEF_READ_BUFF_LEN;
        if (ulReadBuffLen == 0xffff)
          ulReadBuffLen = MAX_READ_BUFF_LEN;
        ulOrgReadBuffLen = ulReadBuffLen;
        if (pstCOMiCFG->bInstallCOMscope)
          strcpy(szStatusText,"Page 1 of 3 ");
        else
          strcpy(szStatusText,"Page 1 of 2 ");
        ulNewPageId = InsertNotebookPage(hwnd,hwndNoteBook,
                                     szTabText,szStatusText,
                                     usTabType,
                               (PFNWP)fnwpReceiveBuffDlgProc,
                                      PCFG_BUFF_DLG,
                                     &astPages[iPageIndex]);
        astPages[iPageIndex - 1].ulSubPageId = ulNewPageId;
        astPages[iPageIndex].usFocusId = PCFG_BUFF_DATA;
        iPageIndex++;
        /****************************************************************************
        ** Insert Transmit COMi Buffers page (MINOR)
        */
        if (bWarp4)
          strcpy(szTabText,"~Handsahking");
        else
          strcpy(szTabText,"~Transmit");
        astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB.wWrtBufferLength;
        astPages[iPageIndex].usHelpId = HLPP_BUFFER_SETUP_DLG;
        if (pstCOMiCFG->bInstallCOMscope)
          strcpy(szStatusText,"Page 2 of 3 ");
        else
          strcpy(szStatusText,"Page 2 of 2 ");
        InsertNotebookPage(hwnd,hwndNoteBook,
                          szTabText,szStatusText,
                             (BKA_MINOR | BKA_STATUSTEXTON),
                    (PFNWP)fnwpTransmitBuffDlgProc,
                           PCFG_BUFF_DLG,
                           &astPages[iPageIndex]);
        astPages[iPageIndex].usFocusId = PCFG_BUFF_DATA;
        iPageIndex++;
        /****************************************************************************
        ** Insert COMscope COMi Buffers page (MINOR)
        */
        if (pstCOMiCFG->bInstallCOMscope)
          {
          astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB.wCOMscopeBuffLen;
          astPages[iPageIndex].usHelpId = HLPP_BUFFER_SETUP_DLG;
          InsertNotebookPage(hwnd,hwndNoteBook,
                            "~COMi buffers","Page 3 of 3 ",
                             (BKA_MINOR | BKA_STATUSTEXTON),
                      (PFNWP)fnwpCOMscopeBuffDlgProc,
                             PCFG_BUFF_DLG,
                             &astPages[iPageIndex]);
          astPages[iPageIndex].usFocusId = PCFG_BUFF_DATA;
          iPageIndex++;
          }
        /*************************************************************************************
        **  Insert Extensions Page (MAJOR)
        */
        astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
        astPages[iPageIndex].pVoidPtrTwo = &stTempCFGheader;
        astPages[iPageIndex].usHelpId = HLPP_EXT_DLG;
        InsertNotebookPage(hwnd,hwndNoteBook,
                          "~Extensions",0,
                           BKA_MAJOR,
                    (PFNWP)fnwpPortExtensionsDlgProc,
                           PCFG_EXTENSIONS_DLG,
                           &astPages[iPageIndex]);
        astPages[iPageIndex].usFocusId = PCFG_MDM_EXT;
        iPageIndex++;
        }
      /**********************************************************************************
      **  Turn to top page
      */
      iPageCount = (iPageIndex + 1);
      WinSendMsg(hwndNoteBook,
                 BKM_TURNTOPAGE,
                 (MPARAM)astPages[0].ulPageId,
                 (MPARAM)0L);
      /*
      ** retstore pointer
      */
      WinSetPointer(HWND_DESKTOP, hptrPrev);
      WinPostMsg(hwnd,UM_INIT,(MPARAM)0,(MPARAM)0);
      return MRFROMSHORT(FALSE);
    case UM_INIT:
      if (pstCOMiCFG->bSpoolerConfig)
         WinSetWindowText(hwnd,szSpoolerDescription);
      /*
      **  Set focus to top window field.  Cannot access notebook with keyboard otherwise
      */
      WinSetFocus(HWND_DESKTOP,WinWindowFromID(astPages[0].hwnd,DID_UNDO));
      bAllowControls = TRUE;
      return(FALSE);
    case WM_CONTROL:
      if (bAllowControls)
        {
        if (SHORT2FROMMP(mp1) == BKN_PAGESELECTEDPENDING)
          {
          pPageSelect = PVOIDFROMMP(mp2);
          if ((!pstCOMiCFG->bSpoolerConfig) && (pPageSelect->ulPageIdCur == ulTopPageId))
            {
            /*
            **  If current page is the top page then its data must be validated
            */
            if (pPageSelect->ulPageIdNew != ulTopPageId)
              {
              if (!WinSendMsg(astPages[0].hwnd,UM_VALIDATE_DATA,(MPARAM)0,(MPARAM)0))
                {
                pPageSelect->ulPageIdNew = 0;
                WinPostMsg(astPages[0].hwnd,UM_SET_FOCUS,MPFROMSHORT(astPages[0].usFocusId),(MPARAM)0L);
                return (FALSE);
                }
              }
            }
//          else
          if (!bWarp4)
            {
            pstPage = (NBKPAGECTL *)WinSendMsg(hwndNoteBook,BKM_QUERYPAGEDATA,(MPARAM)pPageSelect->ulPageIdNew,(MPARAM)0);
            if (pstPage->bTopPage)
              {
              ulNewPageId = pstPage->ulSubPageId;
//              if (ulNewPageId == pPageSelect->ulPageIdCur)
//                ulNewPageId = pstPage->ulPrevPageId;
              WinPostMsg(hwndNoteBook,
                         BKM_TURNTOPAGE,
                 (MPARAM)ulNewPageId,
                 (MPARAM)0L);
              pPageSelect->ulPageIdNew = 0;
              return(FALSE);
              }
            }
          }
        else
          if (SHORT2FROMMP(mp1) == BKN_PAGESELECTED)
            {
            pPageSelect = PVOIDFROMMP(mp2);
            pstPage = (NBKPAGECTL *)WinSendMsg(hwndNoteBook,BKM_QUERYPAGEDATA,(MPARAM)pPageSelect->ulPageIdNew,(MPARAM)0);
            if (pstPage->bRecalcEach)
              WinSendMsg(pstPage->hwnd,UM_RECALCDLG,(MPARAM)0,(MPARAM)pstPage);
            WinSetFocus(HWND_DESKTOP,WinWindowFromID(pstPage->hwnd,DID_UNDO));
//            WinSetFocus(HWND_DESKTOP,WinWindowFromID(pstPage->hwnd,pstPage->usFocusId));
            if (!pstCOMiCFG->bSpoolerConfig)
              if (pstPage->ulPageId == ulTopPageId)
                WinSetWindowText(hwnd,szInitDeviceDescription);
              else
                WinSetWindowText(hwnd,szDeviceDescription);
            }
          }
      break;
    case WM_CLOSE:
      if (!bInsertNewDevice)
        {
        for (iPageIndex = 0;iPageIndex <= iPageCount;iPageIndex++)
          if (astPages[iPageIndex].bDirtyBit)
            {
            pstCOMiCFG->bDirtyPage = TRUE;
            break;
            }
        if (pstCOMiCFG->bDirtyPage)
          {
          if (WinMessageBox(HWND_DESKTOP,
                            hwnd,
                           "Are you sure you want to exit without saving?",
                           "Device configuration has changed!",
                            NULL,
                           (MB_YESNO | MB_CUAWARNING | MB_MOVEABLE)) != MBID_YES)
            return(FALSE);
          }
        }
      break;
    case UM_CLOSE:
      if (!WinSendMsg(astPages[0].hwnd,UM_SAVE_DATA,(MPARAM)0,(MPARAM)0))
         WinSendMsg(hwndNoteBook,
                    BKM_TURNTOPAGE,
            (MPARAM)astPages[0].ulPageId,
            (MPARAM)0L);
      else
        {
        for (iPageIndex = 0;iPageIndex < iPageCount;iPageIndex++)
          if (astPages[iPageIndex].bDirtyBit)
            {
            pstCOMiCFG->bDirtyPage = TRUE;
            if (!WinSendMsg(astPages[iPageIndex].hwnd,UM_SAVE_DATA,(MPARAM)0,(MPARAM)0))
              {
              WinSendMsg(hwndNoteBook,
                         BKM_TURNTOPAGE,
                 (MPARAM)astPages[iPageIndex].ulPageId,
                 (MPARAM)0L);
              return (FALSE);
              }
            }
        if (!pstCOMiCFG->bSpoolerConfig)
          {
          memcpy(&stGlobalCFGheader,&stTempCFGheader,sizeof(CFGHEAD));
          memcpy(&stGlobalDCBheader,&stTempDCBheader,sizeof(DCBHEAD));
          }
        WinDismissDlg(hwnd, TRUE);
        }
       return(TRUE);
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_CANCEL:
          if (!bInsertNewDevice)
            {
            for (iPageIndex = 0;iPageIndex <= iPageCount;iPageIndex++)
              if (astPages[iPageIndex].bDirtyBit)
                {
                pstCOMiCFG->bDirtyPage = TRUE;
                break;
                }
            if (pstCOMiCFG->bDirtyPage)
              if (WinMessageBox(HWND_DESKTOP,
                                hwnd,
                               "Are you sure you want to exit without saving?",
                               "Device configuration has changed!",
                                NULL,
                               (MB_YESNO | MB_CUAWARNING | MB_MOVEABLE)) != MBID_YES)
                return(FALSE);
            }
          WinDismissDlg(hwnd, FALSE);
          return(TRUE);
        case DID_HELP:
          ulNewPageId = (ULONG)WinSendMsg(hwndNoteBook,BKM_QUERYPAGEID,(MPARAM)0,MPFROM2SHORT(BKA_TOP,0));
          for (iPageIndex = 0;iPageIndex < iPageCount;iPageIndex++)
            if (astPages[iPageIndex].ulPageId == ulNewPageId)
              DisplayHelpPanel(pstCOMiCFG,astPages[iPageIndex].usHelpId);
          break;
        default:
          return(WinDefDlgProc(hwnd, msg, mp1, mp2));
        }
      return MRFROMSHORT(FALSE);
    }
  return(WinDefDlgProc(hwnd, msg, mp1, mp2));
  }

ULONG InsertNotebookPage(HWND hwndDlg,HWND hwndNoteBook,char szTabText[],char szStatusText[],USHORT usTabType,PFNWP fnwpDlgProc,ULONG ulDlgId,NBKPAGECTL *pstPage)
  {
  ULONG ulPageId;
  HWND hwndPage;

  pstPage->cbSize = sizeof(NBKPAGECTL);
  ulPageId = (ULONG)WinSendMsg(hwndNoteBook,BKM_INSERTPAGE,(MPARAM)NULL,MPFROM2SHORT(usTabType,BKA_LAST));

  pstPage->ulPageId = ulPageId;
  WinSendMsg(hwndNoteBook,BKM_SETTABTEXT,(MPARAM)ulPageId,MPFROMP(szTabText));
  if (szStatusText != NULL)
    WinSendMsg(hwndNoteBook,BKM_SETSTATUSLINETEXT,(MPARAM)ulPageId,MPFROMP(szStatusText));

  if (ulDlgId == 0)
    pstPage->bTopPage = TRUE;
  else
    {
    hwndPage = WinLoadDlg(hwndDlg,
                          hwndNoteBook,
                          fnwpDlgProc,
                          hThisModule,
                          ulDlgId,
                   (PVOID)pstPage);

    pstPage->hwnd = hwndPage;
    WinSendMsg(hwndNoteBook,BKM_SETPAGEWINDOWHWND,MPFROMLONG(ulPageId),MPFROMHWND(hwndPage));
    WinSetWindowPos(hwndPage,HWND_TOP,0,0,0,0,SWP_MOVE);
    }
  WinSendMsg(hwndNoteBook,BKM_SETPAGEDATA,(MPARAM)ulPageId,(MPARAM)pstPage);
  return(ulPageId);
  }

APIRET EXPENTRY SpoolerSetupDialog(HWND hwnd,COMICFG *pstCOMiCFG)
  {
  DCB *pstDCB;
  LINECHAR *pstLine;
  BYTE byLine;
  BOOL bSuccess;

  if (bSpoolSetupInUse)
    {
    MessageBox(HWND_DESKTOP,"COMspool Port Configuration process is being accessed by another process.\n\nTry again later.");
    return(FALSE);
    }
  bSpoolSetupInUse = TRUE;
  HelpInit(pstCOMiCFG);

  stTempDCBheader.stComDCB.ulBaudRate = pstCOMiCFG->ulValue;
  pstDCB = pstCOMiCFG->pst;
  stTempDCBheader.stComDCB.wRdTimeout = pstDCB->ReadTimeout;
  stTempDCBheader.stComDCB.wWrtTimeout = pstDCB->WrtTimeout;
  stTempDCBheader.stComDCB.wFlags1 = (USHORT)(pstDCB->Flags1 | 0x8000);
  stTempDCBheader.stComDCB.wFlags2 = (USHORT)(pstDCB->Flags2 | 0x8000);
  stTempDCBheader.stComDCB.wFlags3 = (USHORT)(pstDCB->Flags3 | 0x8000);
  stTempDCBheader.stComDCB.byErrorChar = pstDCB->ErrChar;
  stTempDCBheader.stComDCB.byBreakChar = pstDCB->BrkChar;
  stTempDCBheader.stComDCB.byXonChar = pstDCB->XonChar;
  stTempDCBheader.stComDCB.byXoffChar = pstDCB->XoffChar;
  pstLine = pstCOMiCFG->pstSpare;
  byLine = 0xc0;
  byLine |= (pstLine->DataBits - 5);
  switch (pstLine->Parity)
    {
    case 1:
      byLine |= 0x08;
      break;
    case 2:
      byLine |= 0x18;
      break;
    case 3:
      byLine |= 0x38;
      break;
    case 4:
      byLine |= 0x28;
      break;
    }
  if ((pstLine->StopBits) != 0)
    byLine |= 0x04;
  stTempDCBheader.stComDCB.byLineCharacteristics = byLine;
  sprintf(szSpoolerDescription,szSpoolerDescriptionFormat,pstCOMiCFG->pszPortName);
  bSuccess = WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpDeviceSetupDlgProc,hThisModule,PCFG_NOTEBOOK_DLG,MPFROMP(pstCOMiCFG));

  pstCOMiCFG->ulValue = stTempDCBheader.stComDCB.ulBaudRate;
  pstDCB = pstCOMiCFG->pst;
  pstDCB->ReadTimeout = stTempDCBheader.stComDCB.wRdTimeout;
  pstDCB->WrtTimeout = stTempDCBheader.stComDCB.wWrtTimeout;
  pstDCB->Flags1 = (BYTE)stTempDCBheader.stComDCB.wFlags1;
  pstDCB->Flags2 = (BYTE)stTempDCBheader.stComDCB.wFlags2;
  pstDCB->Flags3 = (BYTE)stTempDCBheader.stComDCB.wFlags3;
  pstDCB->ErrChar = stTempDCBheader.stComDCB.byErrorChar;
  pstDCB->BrkChar = stTempDCBheader.stComDCB.byBreakChar;
  pstDCB->XonChar = stTempDCBheader.stComDCB.byXonChar;
  pstDCB->XoffChar = stTempDCBheader.stComDCB.byXoffChar;
  pstLine = pstCOMiCFG->pstSpare;
  byLine = stTempDCBheader.stComDCB.byLineCharacteristics;
  pstLine->DataBits = ((byLine & 0x03) + 5);
  switch (byLine & 0x38)
    {
    case 0x00:
      pstLine->Parity = 0;
      break;
    case 0x08:
      pstLine->Parity = 1;
      break;
    case 0x18:
      pstLine->Parity = 2;
      break;
    case 0x38:
      pstLine->Parity = 3;
      break;
    case 0x28:
      pstLine->Parity = 4;
      break;
    }
  if ((byLine & 0x04) == 0)
    pstLine->StopBits = 0;
  else
    if (pstLine->DataBits == 5)
      pstLine->StopBits = 1;
    else
      pstLine->StopBits = 2;

  DestroyHelpInstance(pstCOMiCFG);

  bSpoolSetupInUse = FALSE;
  return(bSuccess);
  }

