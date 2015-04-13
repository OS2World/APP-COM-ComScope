#include <COMMON.H>
#include <ioctl.h>
#include <help.h>

#include "COMi_CFG.H"
#include <utility.h>

#include <OS$tools.h>

BOOL APIENTRY  CALLDestroyHelpInstance (HWND hwndHelpInstance);
VOID EXPENTRY InitializeHelp(void);
VOID EXPENTRY ReleaseHelpStubHook(void);
extern BOOL bHelpStubHookIsSet;
extern BOOL bHelpAlreadyInitialized;
extern HWND hwndHelp;

MRESULT EXPENTRY fnwpHdwBaudRateDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpHdwFilterDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpHdwTimeoutDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpHdwFIFOsetupDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpHandshakeDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpHdwProtocolDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpPortConfigBuffersDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpPortExtensionsDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);

extern BOOL bSpoolSetupInUse;

extern HMODULE hThisModule;
extern char szDriverIniPath[];
extern DCBHEAD stTempDCBheader;
extern DCBHEAD stGlobalDCBheader;

MRESULT EXPENTRY fnwpSpoolerSetupDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  char szTitle[200];
  static COMICFG *pstCOMiCFG;
  BYTE byIntLevel;
  APIRET rc;
  static DCBPOS stDCBposition;
  static CFGHEAD stCFGheader;
  static BOOL bRestartRequired;
  static DCB *pstDCB;
  char szPortName[20];
  COMDCB stComDCB;
  ULONG ulTemp;

  switch (msg)
    {
    case WM_INITDLG:
      if (szDriverIniPath[0] == 0)
        {
        MessageBox(HWND_DESKTOP,"The COMi device driver must be loaded before this device can be configured.");
        WinDismissDlg(hwndDlg,FALSE);
        return((MRESULT)TRUE);
        }
      CenterDlgBox(hwndDlg);
      WinSetFocus(HWND_DESKTOP,hwndDlg);
      pstCOMiCFG = PVOIDFROMMP(mp2);
      pstDCB = pstCOMiCFG->pst;
      InitializeDCBheader(&stTempDCBheader,pstCOMiCFG->bInstallCOMscope);
      strcpy(stTempDCBheader.abyPortName,pstCOMiCFG->pszPortName);
      strcpy(szPortName,pstCOMiCFG->pszPortName);
      MakeDeviceName(stTempDCBheader.abyPortName);
      stDCBposition.wDCBnumber = 0;
      stDCBposition.wLoadNumber = 0;
      QueryIniDCBheaderName(szDriverIniPath,&stCFGheader,&stTempDCBheader,&stDCBposition);
      if ((byIntLevel = stCFGheader.byInterruptLevel) == 0)
        byIntLevel = stTempDCBheader.stComDCB.byInterruptLevel;
      sprintf(szTitle,"Configuring %s at base I/O address 0x%X and interrupt %u",szPortName,
                                                                  stTempDCBheader.stComDCB.wIObaseAddress,
                                                                  byIntLevel);
      bRestartRequired = FALSE;
      WinSetDlgItemText(hwndDlg,PCFG_DEV_NAME,szTitle);
      return((MRESULT)TRUE);
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_OK:
          PlaceIniDCBheader(szDriverIniPath,&stCFGheader,&stTempDCBheader,&stDCBposition);
          if (bRestartRequired)
            WinMessageBox(HWND_DESKTOP,hwndDlg,
                "You have changed device driver parameters that will not take effect until after you have shut down and re-started your system.",
                "Please Note:",
                HLPP_MB_REQUIRE_RESTART,
               (MB_HELP | MB_OK | MB_MOVEABLE | MB_INFORMATION));
          WinDismissDlg(hwndDlg,TRUE);
          return(MRESULT)TRUE;
        case DID_CANCEL:
          WinDismissDlg(hwndDlg,FALSE);
          break;
        case DID_HELP:
          DisplayHelpPanel(pstCOMiCFG,HLPP_SPOOL_DLG);
          break;
        case PCFG_EXTENSION_SET:
          if (WinDlgBox(HWND_DESKTOP,hwndDlg,(PFNWP)fnwpPortExtensionsDlgProc,hThisModule,PCFG_EXTENSIONS_DLG,MPFROMP(pstCOMiCFG)))
            bRestartRequired = TRUE;
          break;
        case PCFG_BUFF_SETUP:
          if (WinDlgBox(HWND_DESKTOP,hwndDlg,(PFNWP)fnwpPortConfigBuffersDlgProc,hThisModule,PCFG_BUFF_DLG,MPFROMP(pstCOMiCFG)))
            bRestartRequired = TRUE;
          break;
        case PCFG_HS_SET:
          if (stTempDCBheader.stComDCB.wFlags1 == 0)
            pstDCB->Flags1 = F1_DEFAULT;
          else
            pstDCB->Flags1 = (BYTE)stTempDCBheader.stComDCB.wFlags1;
          if (stTempDCBheader.stComDCB.wFlags2 == 0)
            pstDCB->Flags2 = F2_DEFAULT;
          else
            pstDCB->Flags2 = (BYTE)stTempDCBheader.stComDCB.wFlags2;
          if (stTempDCBheader.stComDCB.byXonChar == 0)
            pstDCB->XonChar = 0x11;
          else
            pstDCB->XonChar = stTempDCBheader.stComDCB.byXonChar;
          if (stTempDCBheader.stComDCB.byXoffChar == 0)
            pstDCB->XoffChar = 0x13;
          else
            pstDCB->XoffChar = stTempDCBheader.stComDCB.byXoffChar;
          if (WinDlgBox(HWND_DESKTOP,hwndDlg,(PFNWP)fnwpHandshakeDlg,hThisModule,HS_DLG,MPFROMP(pstCOMiCFG)))
            {
            stTempDCBheader.stComDCB.wFlags1 = (pstDCB->Flags1 | 0x8000);
            stTempDCBheader.stComDCB.wFlags2 = (pstDCB->Flags2 | 0x8000);
            stTempDCBheader.stComDCB.byXoffChar = pstDCB->XoffChar;
            stTempDCBheader.stComDCB.byXonChar = pstDCB->XonChar;
            }
          break;
        case PCFG_DEV_FIFO_SET:
          if (stTempDCBheader.stComDCB.wFlags3 == 0)
            pstDCB->Flags3 = F3_DEFAULT;
          else
            pstDCB->Flags3 = stTempDCBheader.stComDCB.wFlags3;
          if (WinDlgBox(HWND_DESKTOP,hwndDlg,(PFNWP)fnwpHdwFIFOsetupDlg,hThisModule,HWF_DLG,MPFROMP(pstCOMiCFG)))
            stTempDCBheader.stComDCB.wFlags3 = (pstDCB->Flags3 | 0x8000);
          break;
        case PCFG_DEV_LINE_CHAR:
          pstCOMiCFG->pst = pstCOMiCFG->pstSpare;
          if (WinDlgBox(HWND_DESKTOP,hwndDlg,(PFNWP)fnwpHdwProtocolDlg,hThisModule,HWP_DLG,MPFROMP(pstCOMiCFG)))
            stTempDCBheader.stComDCB.wFlags3 = (pstDCB->Flags3 | 0x8000);
          pstCOMiCFG->pst = pstDCB;
          break;
        case PCFG_DEV_BAUDRATE:
          WinDlgBox(HWND_DESKTOP,hwndDlg,(PFNWP)fnwpHdwBaudRateDlg,hThisModule,HWB_DLG,MPFROMP(pstCOMiCFG));
          break;
        case PCFG_TMO_SET:
          if (stTempDCBheader.stComDCB.wFlags3 == 0)
            pstDCB->Flags3 = F3_DEFAULT;
          else
            pstDCB->Flags3 = (BYTE)stTempDCBheader.stComDCB.wFlags3;
          if (stTempDCBheader.stComDCB.wRdTimeout == 0)
            pstDCB->ReadTimeout = DEF_READ_TIMEOUT;
          else
            pstDCB->ReadTimeout = stTempDCBheader.stComDCB.wRdTimeout;
          if (stTempDCBheader.stComDCB.wWrtTimeout == 0)
            pstDCB->WrtTimeout = DEF_WRITE_TIMEOUT;
          else
            pstDCB->WrtTimeout = stTempDCBheader.stComDCB.wWrtTimeout;
          if (WinDlgBox(HWND_DESKTOP,hwndDlg,(PFNWP)fnwpHdwTimeoutDlg,hThisModule,HWT_DLG,MPFROMP(pstCOMiCFG)))
            {
            stTempDCBheader.stComDCB.wFlags3 = (pstDCB->Flags3 | 0x8000);
            stTempDCBheader.stComDCB.wWrtTimeout = pstDCB->WrtTimeout;
            stTempDCBheader.stComDCB.wRdTimeout = pstDCB->ReadTimeout;
            }
          break;
        case PCFG_DEV_FILTERS_SET:
          if (stTempDCBheader.stComDCB.wFlags2 == 0)
            pstDCB->Flags2 = F2_DEFAULT;
          else
            pstDCB->Flags2 = stTempDCBheader.stComDCB.wFlags2;
          if (WinDlgBox(HWND_DESKTOP,hwndDlg,(PFNWP)fnwpHdwFilterDlg,hThisModule,HWR_DLG,MPFROMP(pstCOMiCFG)))
            stTempDCBheader.stComDCB.wFlags2 = (pstDCB->Flags2 | 0x8000);
          break;
        default:
          return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
        }
      return((MRESULT)FALSE);
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }

APIRET APIENTRY SpoolerSetupDialog(HWND hwnd,COMICFG *pstCOMiCFG)
  {
  BOOL bSuccess;
  HWND hwndSaveHelp;

  if (bSpoolSetupInUse)
    {
    MessageBox(HWND_DESKTOP,"COMspool Port Configuration process is being accessed by another process.\n\nTry again later.");
    return(FALSE);
    }
  bSpoolSetupInUse = TRUE;
  HelpInit(pstCOMiCFG);
#ifdef this_junk
  InitializeHelp();
  hwndSaveHelp = pstCOMiCFG->hwndHelpInstance;
  pstCOMiCFG->hwndHelpInstance = hwndHelp;
#endif
  bSuccess = WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpSpoolerSetupDlgProc,hThisModule,PCFG_DEV_PDR_DLG,MPFROMP(pstCOMiCFG));

  DestroyHelpInstance(pstCOMiCFG);
#ifdef this_junk
  if (bHelpAlreadyInitialized)
    {
    CALLDestroyHelpInstance(hwndHelp);
    hwndHelp = (HWND)NULL;
    bHelpAlreadyInitialized = FALSE;
    bHelpStubHookIsSet=FALSE;
    }
  ReleaseHelpStubHook();
  pstCOMiCFG->hwndHelpInstance = hwndSaveHelp;
#endif
  bSpoolSetupInUse = FALSE;
  return(bSuccess);
  }


