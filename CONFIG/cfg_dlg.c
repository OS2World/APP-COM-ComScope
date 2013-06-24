#include "COMMON.H"
#include "COMDD.H"
#include "ioctl.h"
#include "utility.h"
#include "help.h"

#include "COMi_CFG.H"
#include "resource.h"

static char const *aszOrdinals[] = {"zero","one","two","three","four","five","six","seven","eight","nine","ten","eleven","twelve","thirteen","fourteen","fifteen","sixteen"};

MRESULT EXPENTRY fnwpDeviceSetupDlgProc(HWND hwnd, ULONG  msg, MPARAM mp1, MPARAM mp2);
MRESULT EXPENTRY fnwpPortOEMconfigDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpPortNameDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpPortExtensionsDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpOEMIntAlgorithimDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);

void ClearAllIntDCBheader(char szFileSpec[]);
void AppendOptionList(DCBHEAD *pstDCBheader,char szListString[]);
BOOL GetNewDeviceNameLB(HWND hwndDlg,char szName[]);
//BOOL GetPortInfo(CFGHEAD *pstCFGheader,DCBHEAD *pstDCBheader,DCBPOS *pstHeaderPosition);
void InitReadBufferSize(HWND hwndDlg,ULONG ulBuffLen);
void InitWriteBufferSize(HWND hwndDlg,ULONG ulBuffLen);
void InitCOMscopeBufferSize(HWND hwndDlg,ULONG ulBuffLen);
static int GetPCIadapterName(char szPCIname[], BYTE byOEMtype);

extern BOOL bPCImachine;

BOOL bInsertNewDevice = FALSE;
extern BOOL bCOMiLoaded;
BOOL bShareAccessWarning = FALSE;
BOOL bNonExAccessWarning = FALSE;

int FillDeviceCfgListBox(HWND hwndDlg,DCBPOS stSelectPosition,char szDriverIniSpec[],ULONG ulMaxDeviceCount);

DEVDEF astISAdeviceDefinition[] = {{"COM1",0x3f8,4},{"COM2",0x2f8,3},{"COM3",0x3e8,4},{"COM4",0x2e8,3}};

DEVDEF astMCAdeviceDefinition[] = {{"COM1",0x3f8,4},{"COM2",0x2f8,3},{"COM3",0x3220,3},{"COM4",0x3228,3},
                                   {"COM5",0x4220,3},{"COM6",0x4228,3},{"COM7",0x5220,3},{"COM8",0x5228,3}};
                                   
DEVDEF astPCIdeviceDefinition[] = {{"COM1",0,0},{"COM2",0,0},{"COM3",0,0},{"COM4",0,0},
                                   {"COM5",0,0},{"COM6",0,0},{"COM7",0,0},{"COM8",0,0}};

extern char szPDRlibrarySpec[];

DCBPOS stConfigDeviceCount;
char szHeaderString[] = {" ~Name  Address  Interrupt"};
char szListFormat[] =   {"%5s  0x%04x      %2u"};
char szLoadFormat[] = {"Load %d %s"};
char szDeviceDefFormat[] = {"Device definitions, load %d"};
char szSkipFormat[] =   {"%5s will be not be installed"};
char szPCIdevice[] = {"%5s is PCI PnP device"};
extern char szDriverIniPath[];
extern char szDriverVersionString[];
extern char szOEMname[];
extern BYTE byDDOEMtype;
extern BOOL bLimitLoad;

extern hThisModule;

extern int iPCIadapters;

extern BOOL bWarp4;

char szListString[300];

extern USHORT fIsMCAmachine;
extern WORD wDDmaxDeviceCount;

LINKLIST *pSpoolList = NULL;
LINKLIST *pAddressList = NULL;
LINKLIST *pInterruptList = NULL;
LINKLIST *pLoadAddressList = NULL;
LINKLIST *pLoadInterruptList = NULL;

DCBHEAD stGlobalDCBheader;
CFGHEAD stGlobalCFGheader;
DCBHEAD stTempDCBheader;
CFGHEAD stTempCFGheader;

char szCurrentConfigDeviceName[10];

extern DEVLIST astConfigDeviceList[];

HWND hwndDeviceList;
BYTE byLastIntLevel = 3;
WORD wLastAddress = 0x3f8;
WORD wLastDelayCount = 300;
char szLastName[9] = "COM0";
BOOL bEmptyINI = FALSE;

extern LONG lXScr;
extern LONG lYScr;
extern LONG lYbutton;
extern LONG lXbutton;

int iLoadMaxDevice = 8;
int iOEMloadMaxDevice = 4;
int iDeviceCount = 0;

static void AppendOptionList(DCBHEAD *pstDCBheader,char szListString[])
  {
  int iLen = 0;

  if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_EXT_MODEM_CTL)
    iLen += sprintf(&szListString[iLen],", Ext'd modem cntls");
  if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_TESTS_DISABLE)
    iLen += sprintf(&szListString[iLen],", No init tests");
//  if (pstDCBheader->stComDCB.wConfigFlags2 & CFG_FLAG1_HDW_HS_MASK)
//    iLen += sprintf(&szListString[iLen],", 16650/16750 Hdw HS");
  if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_NORMALIZE_BAUD)
    iLen += sprintf(&szListString[iLen],", Normalize baud");
  if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_EXPLICIT_BAUD_DIVISOR)
    iLen += sprintf(&szListString[iLen],", Explicit baud");
  if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_NO_MODEM_INT)
    iLen += sprintf(&szListString[iLen],", No modem int's");
  }

static void FillOEMstring(char szOEMstring[], BYTE byOEMtype)
  {
  char szPCIname[100];

  if (stGlobalCFGheader.byAdapterType != 0)
    {
    strcpy(szOEMstring," <- adapter type ");
    switch (stGlobalCFGheader.byAdapterType)
      {
      case HDWTYPE_ONE:
        strcat(szOEMstring,"one");
        break;
      case HDWTYPE_TWO:
        strcat(szOEMstring,"two");
        break;
      case HDWTYPE_THREE:
        strcat(szOEMstring,"three");
        break;
      case HDWTYPE_FOUR:
        strcat(szOEMstring,"four");
        break;
      case HDWTYPE_FIVE:
        strcat(szOEMstring,"five");
        break;
      case HDWTYPE_SIX:
        strcat(szOEMstring,"six");
        break;
      case HDWTYPE_SEVEN:
        strcat(szOEMstring,"seven");
        break;
      case HDWTYPE_PCI:
        GetPCIadapterName(szPCIname, byOEMtype);
        strcat(szOEMstring,szPCIname);
        break;
      default:
        strcat(szOEMstring,"UNSUPPORTED!");
        break;
      }
    if ((stGlobalCFGheader.byAdapterType != HDWTYPE_PCI) && (stGlobalCFGheader.wIntIDregister != 0))
      sprintf(&szOEMstring[strlen(szOEMstring)]," -> interrupt ID register at %Xh",stGlobalCFGheader.wIntIDregister);
    }
  else
    {
    stGlobalCFGheader.wIntIDregister = 0;
    szOEMstring[0] = 0;
    }
  }

static void DeleteLoadLists(void)
  {
  LINKLIST *pOld = NULL;
  LINKLIST *pListItem = NULL;
  BYTE *pByte;
  WORD *pWord;

  if (pLoadInterruptList != NULL)
    {
    if (pLoadInterruptList->pData != NULL)
      {
      if (stGlobalCFGheader.byInterruptLevel != 0)
        {
        pOld = FindListByteItem(pInterruptList,stGlobalCFGheader.byInterruptLevel);
        RemoveListItem(pOld);
        }
      else
        {
        pOld = pLoadInterruptList;
        do
          {
          pByte = (BYTE *)pOld->pData;
          if (pByte != NULL)
            {
            *pByte &= '\x80';
            if ((pListItem = FindListByteItem(pInterruptList,*pByte)) != NULL)
              RemoveListItem(pListItem);
            }
          } while ((pOld = GetNextListItem(pOld)) != NULL);
        }
      }
    DestroyList(&pLoadInterruptList);
    }
  if (pLoadAddressList != NULL)
    {
    if (pLoadAddressList->pData != NULL)
      {
      pOld = pLoadAddressList;
      do
        {
        pWord = (WORD *)pOld->pData;
        if (pWord != 0)
          {
          pListItem = FindListWordItem(pAddressList,*pWord);
          RemoveListItem(pListItem);
          }
        } while ((pOld = GetNextListItem(pOld)) != NULL);
      }
    DestroyList(&pLoadAddressList);
    }
  }

static void DeleteListItems(CFGHEAD *pCFGheader,DCBHEAD *pDCBheader)
  {
  LINKLIST *pListItem = NULL;
  COMDCB *pstDCB = &pDCBheader->stComDCB;

  if (pCFGheader->byInterruptLevel == 0)
    {
    if ((pListItem = FindListByteItem(pInterruptList,pstDCB->byInterruptLevel)) != NULL)
      RemoveListItem(pListItem);
    if ((pListItem = FindListByteItem(pLoadInterruptList,pstDCB->byInterruptLevel)) != NULL)
      RemoveListItem(pListItem);
    }
  if ((pListItem = FindListWordItem(pAddressList,pstDCB->wIObaseAddress)) != NULL)
    RemoveListItem(pListItem);
  if ((pListItem = FindListWordItem(pLoadAddressList,pstDCB->wIObaseAddress)) != NULL)
    RemoveListItem(pListItem);
  }

static void UnMarkAllDevices(DEVLIST astDeviceList[])
  {
  int iIndex;

  for (iIndex = 1;iIndex < 100;iIndex++)
    astDeviceList[iIndex].bAvailable = TRUE;
  }

MRESULT EXPENTRY fnwpPortConfigDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static DCBPOS stDCBposition;
  int iItemJustSelected;
  static char szOEMstring[60];
  char szPCIname[100];
  char szString[20];
  int iLen;
  int iIndex;
  static int iItemSelected;
  LONG lNewLoadNumber;
  static COMICFG *pstCOMiCFG;
  BYTE byIntLevel;
//  BOOL bWasOEM;
  static bOEMselected;
  BOOL bOkToEditConfigSYS = FALSE;
  APIRET rc;
  USERBUTTON *pstButton;
  HBITMAP hBitmap;
  static POINTL ptl;
  int iLoadCount;
  LINKLIST *pListItem;
  SPOOLLST *pstSpool;
  PFN pfnProcess;
  HMODULE hMod;
  static BOOL bIniWasEmpty;
  ULONG idDialog;

#if DEBUG > 0
  ERRORID eidError;
  char szMessage[100];
#endif
  switch (msg)
    {
    case WM_INITDLG:
      hwndDeviceList = hwndDlg;
//      CenterDlgBox(hwndDlg);
      WinSetFocus(HWND_DESKTOP,hwndDlg);
      pstCOMiCFG = PVOIDFROMMP(mp2);
      ptl.x = 0;
      ptl.y = 0;
      if ((pSpoolList = InitializeList()) == NULL)
        return(FALSE);
      if ((pInterruptList = InitializeList()) == NULL)
        {
        DestroyList(&pSpoolList);
        return(FALSE);
        }
      if ((pAddressList = InitializeList()) == NULL)
        {
        DestroyList(&pSpoolList);
        DestroyList(&pInterruptList);
        return(FALSE);
        }
      bShareAccessWarning = FALSE;
      bNonExAccessWarning = FALSE;
      stConfigDeviceCount = FillDeviceLists(szDriverIniPath,pAddressList,pInterruptList);
      stDCBposition.wLoadNumber = 1;
      stDCBposition.wDCBnumber = 1;
      if (pstCOMiCFG->bPCIadapter)
//      if (stGlobalCFGheader.byAdapterType == HDWTYPE_PCI)
        {
//        pstCOMiCFG->bPCIadapter = TRUE;
        iLoadMaxDevice = GetPCIadapterName(NULL, 0);
        iOEMloadMaxDevice = iLoadMaxDevice;
        }
//      else
//        pstCOMiCFG->bPCIadapter = FALSE;
      if (pstCOMiCFG->ulMaxDeviceCount != 0)
        {
        if (pstCOMiCFG->ulMaxDeviceCount <= iOEMloadMaxDevice)
          {
          iLoadMaxDevice = pstCOMiCFG->ulMaxDeviceCount;
          bLimitLoad = TRUE;
          }
        }
//      if ((pstCOMiCFG->byOEMtype == OEM_SEALEVEL) && (pstCOMiCFG->byOEMtype == OEM_OTHER))
      if (pstCOMiCFG->byOEMtype != OEM_OTHER)
        bLimitLoad = TRUE;
      if (bLimitLoad)
        {
        bIniWasEmpty = FALSE;
        if (stConfigDeviceCount.wDCBnumber == 0)
          bIniWasEmpty = TRUE;
        ControlEnable(hwndDlg,PCFG_ADD_LOAD,FALSE);
        ControlEnable(hwndDlg,PCFG_LOAD,FALSE);
        stConfigDeviceCount.wLoadNumber = 1;
        }
      iLen = sprintf(szListString,"Defining %s",szDriverIniPath);
      if (szDriverVersionString != NULL)
        sprintf(&szListString[iLen]," for COMi %s",szDriverVersionString);
      WinSetWindowText(hwndDlg,szListString);
      WinSetDlgItemText(hwndDlg,PCFG_DEVT1,szHeaderString);
      InitializeDCBheader(&stGlobalDCBheader,pstCOMiCFG->bInstallCOMscope);
      if (pstCOMiCFG->pszPortName != NULL)
        {
        strncpy(stGlobalDCBheader.abyPortName,pstCOMiCFG->pszPortName,8);
        strncpy(szCurrentConfigDeviceName,pstCOMiCFG->pszPortName,8);
        }
      WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_SETITEMHEIGHT,(MPARAM)12,(MPARAM)0);
      iItemSelected = LIT_NONE;
      if (stConfigDeviceCount.wLoadNumber == 0)
        {
        stConfigDeviceCount.wLoadNumber = 1;
        iDeviceCount = 0;
        stDCBposition.wLoadNumber = 1;
        stDCBposition.wDCBnumber = 0;
        bEmptyINI = TRUE;
        }
      else
        {
        if ((iDeviceCount = FillDeviceCfgListBox(hwndDlg,stDCBposition,szDriverIniPath,pstCOMiCFG->ulMaxDeviceCount)) != 0)
          {
          QueryIniCFGheader(szDriverIniPath,&stGlobalCFGheader,&stDCBposition);
          if (stGlobalCFGheader.wLoadFlags & LOAD_FLAG1_VERBOSE)
            CheckButton(hwndDlg,PCFG_VERBOSE,TRUE);
          if (stGlobalCFGheader.wLoadFlags & LOAD_FLAG1_PRINT_LOCAL)
            CheckButton(hwndDlg,PCFG_LOCAL,TRUE);
          if (!bLimitLoad)
            ControlEnable(hwndDlg,PCFG_ADD_LOAD,TRUE);
          if (stGlobalCFGheader.wDelayCount != 0)
            {
            CheckButton(hwndDlg,PCFG_KEY_WAIT,TRUE);
            wLastDelayCount = stGlobalCFGheader.wDelayCount;
            sprintf(szString,"%u",wLastDelayCount);
            WinSendDlgItemMsg(hwndDlg,PCFG_DELAY,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
            WinSetDlgItemText(hwndDlg,PCFG_DELAY,szString);
            }
          else
            {
            wLastDelayCount = 300;
            sprintf(szString,"%u",wLastDelayCount);
            WinSendDlgItemMsg(hwndDlg,PCFG_DELAY,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
            WinSetDlgItemText(hwndDlg,PCFG_DELAY,szString);
            ControlEnable(hwndDlg,PCFG_DELAYT,FALSE);
            ControlEnable(hwndDlg,PCFG_DELAY,FALSE);
            }
          }
        else
          {
          wLastDelayCount = 300;
          sprintf(szString,"%u",wLastDelayCount);
          WinSendDlgItemMsg(hwndDlg,PCFG_DELAY,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
          WinSetDlgItemText(hwndDlg,PCFG_DELAY,szString);
          ControlEnable(hwndDlg,PCFG_DELAYT,FALSE);
          ControlEnable(hwndDlg,PCFG_DELAY,FALSE);
          ControlEnable(hwndDlg,PCFG_ADD_LOAD,FALSE);
          bEmptyINI = TRUE;
          }
        }
      if (stConfigDeviceCount.wLoadNumber > 1)
        bOEMselected = TRUE;
      else
        bOEMselected = FALSE;
      FillOEMstring(szOEMstring, pstCOMiCFG->byOEMtype);
      sprintf(szListString,szLoadFormat,stDCBposition.wLoadNumber,szOEMstring);
#ifdef this_junk
      if (pstCOMiCFG->bPCIadapter)
        {
        strcat(szListString, " -> ");
        GetPCIadapterName(szPCIname);
        strcat(szListString, szPCIname);
        }
#endif
      WinSetDlgItemText(hwndDlg,PCFG_LOADT,szListString);
      sprintf(szListString,szDeviceDefFormat,stDCBposition.wLoadNumber);
      WinSetDlgItemText(hwndDlg,PCFG_DEVT0,szListString);
      ControlEnable(hwndDlg,PCFG_DELETE_LOAD,FALSE);
      ControlEnable(hwndDlg,DID_DELETE,FALSE);
      ControlEnable(hwndDlg,DID_INSTALL,FALSE);
      if (iDeviceCount >= iLoadMaxDevice)
        ControlEnable(hwndDlg,DID_INSERT,FALSE);
      WinSendDlgItemMsg(hwndDlg,PCFG_LOAD,
                                SPBM_SETLIMITS,
                                (MPARAM)(stConfigDeviceCount.wLoadNumber),
                                (MPARAM)1L);
      return (MRESULT) TRUE;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_OK:
          if (Checked(hwndDlg,PCFG_KEY_WAIT))
            {
            WinQueryDlgItemText(hwndDlg,PCFG_DELAY,6,szString);
            if ((stGlobalCFGheader.wDelayCount = (WORD)atoi(szString)) < 10)
              stGlobalCFGheader.wDelayCount = 10;
            }
          else
            stGlobalCFGheader.wDelayCount = 0;
          if (Checked(hwndDlg,PCFG_VERBOSE))
            stGlobalCFGheader.wLoadFlags |= LOAD_FLAG1_VERBOSE;
          else
            stGlobalCFGheader.wLoadFlags &= ~LOAD_FLAG1_VERBOSE;
//          if ((stConfigDeviceCount.wDCBnumber == 0) &&
//              (stConfigDeviceCount.wLoadNumber == 1))
//            stGlobalCFGheader.wLoadFlags &= ~LOAD_FLAG1_ADVANCED_CFG;
//          else
            stGlobalCFGheader.wLoadFlags |= LOAD_FLAG1_ADVANCED_CFG;
          PlaceIniCFGheader(szDriverIniPath,&stGlobalCFGheader,&stDCBposition);
          strncpy(szListString,szDriverIniPath,(strlen(szDriverIniPath) - 4));
          szListString[strlen(szDriverIniPath) - 4] = 0;
          pListItem = pSpoolList;
          if (pListItem->pData != NULL)
            {
            if (DosLoadModule(0,0,szPDRlibrarySpec,&hMod) == NO_ERROR)
              {
              do
                {
                if (pListItem->pData != NULL)
                  {
                  pstSpool = (SPOOLLST *)pListItem->pData;
                  if (pstSpool->fAction == INSTALL_SPOOL)
                    {
                    if (DosQueryProcAddr(hMod,0,"SPLPDINSTALLPORT",&pfnProcess) == NO_ERROR)
                      rc = pfnProcess(pstCOMiCFG->hab,pstSpool->szPortName);
                    }
                  else
                    {
                    if (DosQueryProcAddr(hMod,0,"SPLPDREMOVEPORT",&pfnProcess) == NO_ERROR)
                      rc = pfnProcess(pstCOMiCFG->hab,pstSpool->szPortName);
                    }
                  }
                } while ((pListItem = GetNextListItem(pListItem)) != NULL);
              DosFreeModule(hMod);
              }
            }
          bOkToEditConfigSYS = FALSE;
//          if (pstCOMiCFG->pszRemoveOldDriverSpec != NULL)
//            bOkToEditConfigSYS = CleanConfigSys(hwndDlg,pstCOMiCFG->pszRemoveOldDriverSpec,HLPP_MB_CONFIGSYS,TRUE);
          stConfigDeviceCount.wDCBnumber = iDeviceCount;
          if ((stConfigDeviceCount.wDCBnumber == 0) &&
              (stConfigDeviceCount.wLoadNumber == 1))
            iLoadCount = 0;
          else
            if (bLimitLoad)
              {
              if (!bIniWasEmpty)
                bOkToEditConfigSYS = TRUE;
              iLoadCount = 1;
              }
            else
              iLoadCount = stConfigDeviceCount.wLoadNumber;
          AdjustConfigSys(hwndDlg,szListString,iLoadCount,bOkToEditConfigSYS,HLPP_MB_CONFIGSYS);
          UnMarkAllDevices(astConfigDeviceList);
          ClearAllIntDCBheader(szDriverIniPath);
          DestroyList(&pAddressList);
          DestroyList(&pInterruptList);
          DestroyList(&pSpoolList);
          DestroyList(&pLoadAddressList);
          DestroyList(&pLoadInterruptList);
          WinDismissDlg(hwndDlg,TRUE);
          return(MRESULT)TRUE;
        case PCFG_DELETE_LOAD:
          DeleteLoadLists();
          for (iIndex = 0;iIndex < iDeviceCount;iIndex++)
            {
            WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_QUERYITEMTEXT,MPFROM2SHORT(iIndex,7),MPFROMP(szCurrentConfigDeviceName));
            astConfigDeviceList[atoi(&szCurrentConfigDeviceName[DEV_NUM_INDEX])].bAvailable = TRUE;
            }
          RemoveIniCFGheader(szDriverIniPath,stDCBposition.wLoadNumber);
          stConfigDeviceCount.wLoadNumber--;
          stDCBposition.wLoadNumber = 1;
          if (stConfigDeviceCount.wLoadNumber == 1)
            ControlEnable(hwndDlg,PCFG_DELETE_LOAD,FALSE);
          WinSendDlgItemMsg(hwndDlg,PCFG_LOAD,
                                    SPBM_SETLIMITS,
                                   (MPARAM)(stConfigDeviceCount.wLoadNumber),
                                   (MPARAM)1L);
          WinSendDlgItemMsg(hwndDlg,PCFG_LOAD,
                                    SPBM_SETCURRENTVALUE,
                                   (MPARAM)stDCBposition.wLoadNumber,
                                    NULL);
          iDeviceCount = FillDeviceCfgListBox(hwndDlg,stDCBposition,szDriverIniPath,pstCOMiCFG->ulMaxDeviceCount);
          QueryIniCFGheader(szDriverIniPath,&stGlobalCFGheader,&stDCBposition);
          if (iDeviceCount >= iLoadMaxDevice)
            ControlEnable(hwndDlg,DID_INSERT,FALSE);
          else
            ControlEnable(hwndDlg,DID_INSERT,TRUE);
          ControlEnable(hwndDlg,DID_DELETE,FALSE);
          ControlEnable(hwndDlg,DID_INSTALL,FALSE);
          FillOEMstring(szOEMstring, pstCOMiCFG->byOEMtype);
          sprintf(szListString,szLoadFormat,stDCBposition.wLoadNumber,szOEMstring);
#ifdef this_junk
          if (stGlobalCFGheader.byAdapterType == HDWTYPE_PCI)
            {
            strcat(szListString, " -> ");
            GetPCIadapterName(szPCIname);
            strcat(szListString, szPCIname);
            }
#endif
          WinSetDlgItemText(hwndDlg,PCFG_LOADT,szListString);
          sprintf(szListString,szDeviceDefFormat,stDCBposition.wLoadNumber);
          WinSetDlgItemText(hwndDlg,PCFG_DEVT0,szListString);
          ControlEnable(hwndDlg,PCFG_ADD_LOAD,TRUE);
          break;
        case PCFG_ADD_LOAD:
          DestroyList(&pLoadAddressList);
          DestroyList(&pLoadInterruptList);
          stConfigDeviceCount.wLoadNumber++;
          WinSendDlgItemMsg(hwndDlg,PCFG_LOAD,SPBM_SETLIMITS,(MPARAM)(stConfigDeviceCount.wLoadNumber),(MPARAM)1L);
          WinSendDlgItemMsg(hwndDlg,PCFG_LOAD,SPBM_SETCURRENTVALUE,(MPARAM)stConfigDeviceCount.wLoadNumber,NULL);
          InitializeCFGheader(&stGlobalCFGheader);
          AddIniConfigHeader(szDriverIniPath,&stDCBposition);
          ControlEnable(hwndDlg,PCFG_ADD_LOAD,FALSE);
          ControlEnable(hwndDlg,PCFG_DELETE_LOAD,TRUE);
          ControlEnable(hwndDlg,DID_INSERT,TRUE);
          ControlEnable(hwndDlg,DID_DELETE,FALSE);
          ControlEnable(hwndDlg,DID_INSTALL,FALSE);
          WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_DELETEALL,0L,0L);
          szOEMstring[0] = 0;
          sprintf(szListString,szLoadFormat,stDCBposition.wLoadNumber,szOEMstring);
#ifdef this_junk
          if (stGlobalCFGheader.byAdapterType == HDWTYPE_PCI)
            {
            int iMaxDevice;

            pstCOMiCFG->bPCIadapter = TRUE;
//            strcat(szListString, " -> ");
//             if ((iMaxDevice = GetPCIadapterName(szPCIname)) != 0)
             if ((iMaxDevice = GetPCIadapterName(NULL, 0)) != 0)
              {
              iOEMloadMaxDevice = iMaxDevice;
              iLoadMaxDevice = iMaxDevice;
              }
//            strcat(szListString, szPCIname);
            }
          else
#endif
            pstCOMiCFG->bPCIadapter = FALSE;
          WinSetDlgItemText(hwndDlg,PCFG_LOADT,szListString);
          sprintf(szListString,szDeviceDefFormat,stDCBposition.wLoadNumber);
          WinSetDlgItemText(hwndDlg,PCFG_DEVT0,szListString);
          iDeviceCount = 0;
          iItemSelected = LIT_NONE;
          if (pstCOMiCFG->ulMaxDeviceCount != 0)
            {
            iLoadMaxDevice = iOEMloadMaxDevice;
            if ((pstCOMiCFG->ulMaxDeviceCount / iOEMloadMaxDevice) > 0)
              if ((stConfigDeviceCount.wLoadNumber / (pstCOMiCFG->ulMaxDeviceCount / iOEMloadMaxDevice)) == 0)
                iLoadMaxDevice = (pstCOMiCFG->ulMaxDeviceCount % iOEMloadMaxDevice);
            }
          break;
        case DID_OEM1:
        case DID_OEM:
//          if ((stGlobalCFGheader.byAdapterType != 0))// && (pstCOMiCFG->byAdapterType != HDWTYPE_PCI))
//            {
//            bWasOEM = TRUE;
//            byIntLevel = stGlobalCFGheader.byInterruptLevel;
//            }
//          else
//            bWasOEM = FALSE;
          if (WinDlgBox(HWND_DESKTOP,
                        hwndDlg,
                 (PFNWP)fnwpPortOEMconfigDlgProc,
                        hThisModule,
                        PCFG_GENERIC_OEM_DLG,
                MPFROMP(pstCOMiCFG)))
            {
            FillOEMstring(szOEMstring, pstCOMiCFG->byOEMtype);
            sprintf(szListString,szLoadFormat,stDCBposition.wLoadNumber,szOEMstring);
            WinSetDlgItemText(hwndDlg,PCFG_LOADT,szListString);
            PlaceIniCFGheader(szDriverIniPath,&stGlobalCFGheader,&stDCBposition);
//            if (bWasOEM)
//              if (stGlobalCFGheader.byInterruptLevel != byIntLevel)
//                bWasOEM = FALSE;
//            if (!bWasOEM)
              {
              iDeviceCount = FillDeviceCfgListBox(hwndDlg,stDCBposition,szDriverIniPath,pstCOMiCFG->ulMaxDeviceCount);
              iItemSelected = LIT_NONE;
              ControlEnable(hwndDlg,DID_DELETE,FALSE);
              ControlEnable(hwndDlg,DID_INSTALL,FALSE);
              }
            }
          break;
        case DID_INSERT:
          stDCBposition.wDCBnumber = 0;
          szCurrentConfigDeviceName[0] = 0;
          bInsertNewDevice = TRUE;
          WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_SELECTITEM,MPFROMSHORT(LIT_NONE),MPFROMSHORT(FALSE));
          InitializeDCBheader(&stGlobalDCBheader,pstCOMiCFG->bInstallCOMscope);
//          InitializeCFGheader(&stGlobalCFGheader);
          ControlEnable(hwndDlg,DID_DELETE,FALSE);
          ControlEnable(hwndDlg,DID_INSTALL,FALSE);
        case DID_INSTALL:
          if (!bInsertNewDevice)
            {
            if ((iItemJustSelected = (int)WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_QUERYSELECTION,0L,0L)) == LIT_NONE)
              break;
            if (iItemJustSelected != iItemSelected)
              {
              iItemSelected = iItemJustSelected;
              WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_QUERYITEMTEXT,MPFROM2SHORT(iItemSelected,7),MPFROMP(szCurrentConfigDeviceName));
              RemoveLeadingSpaces(szCurrentConfigDeviceName);
              RemoveSpaces(szCurrentConfigDeviceName);
              strncpy(stGlobalDCBheader.abyPortName,szCurrentConfigDeviceName,8);
              MakeDeviceName(stGlobalDCBheader.abyPortName);
              if (!QueryIniDCBheaderName(szDriverIniPath,&stGlobalCFGheader,&stGlobalDCBheader,&stDCBposition))
                {
                stGlobalDCBheader.abyPortName[0] = '$';
                QueryIniDCBheaderName(szDriverIniPath,&stGlobalCFGheader,&stGlobalDCBheader,&stDCBposition);
                }
              byLastIntLevel = stGlobalDCBheader.stComDCB.byInterruptLevel;
              wLastAddress = stGlobalDCBheader.stComDCB.wIObaseAddress;
              strcpy(szLastName,szCurrentConfigDeviceName);
              }
            }

          if (bWarp4)
            idDialog = DLG_CONFIGURECOMI_40;
          else
            idDialog = DLG_CONFIGURECOMI_30;

          if ((rc = WinDlgBox(HWND_DESKTOP,
                        hwndDlg,
                 (PFNWP)fnwpDeviceSetupDlgProc,
                        hThisModule,
                        idDialog,
                MPFROMP(pstCOMiCFG))) == TRUE)
            {
            strncpy(stGlobalDCBheader.abyPortName,szCurrentConfigDeviceName,8);
            MakeDeviceName(stGlobalDCBheader.abyPortName);
            strcpy(szLastName,szCurrentConfigDeviceName);
            if (stGlobalDCBheader.stComDCB.wIObaseAddress == 0xffff)
              stGlobalDCBheader.abyPortName[0] = '$';
            if (!PlaceIniDCBheader(szDriverIniPath,&stGlobalCFGheader,&stGlobalDCBheader,&stDCBposition))
              {
              if (bInsertNewDevice)
                {
                stDCBposition.wLoadNumber = 0;
                if (!PlaceIniDCBheader(szDriverIniPath,&stGlobalCFGheader,&stGlobalDCBheader,&stDCBposition))
                  {
                  bInsertNewDevice = FALSE;
                  break;
                  }
                }
              }
            if (stGlobalDCBheader.stComDCB.wIObaseAddress == 0xffff)
              sprintf(szListString,szSkipFormat,szCurrentConfigDeviceName);
            else
              {
              if (!pstCOMiCFG->bPCIadapter)
                {
                if ((byIntLevel = stGlobalCFGheader.byInterruptLevel) == 0)
                  byIntLevel = stGlobalDCBheader.stComDCB.byInterruptLevel;
                iLen = sprintf(szListString,szListFormat,szCurrentConfigDeviceName,
                                                         stGlobalDCBheader.stComDCB.wIObaseAddress,
                                                         byIntLevel);
                }
              else
                iLen = sprintf(szListString,szPCIdevice,szCurrentConfigDeviceName);
              AppendOptionList(&stGlobalDCBheader,&szListString[iLen]);
              }
            if (bInsertNewDevice)
              {
//              bInsertNewDevice = FALSE;
//              if (pstCOMiCFG->byOEMtype != OEM_SEALEVEL)
                {
                if (pstCOMiCFG->ulMaxDeviceCount != 0)
                  {
                  if (stConfigDeviceCount.wLoadNumber < ((pstCOMiCFG->ulMaxDeviceCount / iOEMloadMaxDevice) + 1))
                    ControlEnable(hwndDlg,PCFG_ADD_LOAD,TRUE);
                  }
                else
                  ControlEnable(hwndDlg,PCFG_ADD_LOAD,TRUE);
                }
//              else
//                if (stGlobalCFGheader.byOEMtype != OEM_OTHER)
//                  ControlEnable(hwndDlg,PCFG_ADD_LOAD,TRUE);
              iDeviceCount = FillDeviceCfgListBox(hwndDlg,stDCBposition,szDriverIniPath,pstCOMiCFG->ulMaxDeviceCount);
              if (iDeviceCount >= iLoadMaxDevice)
                ControlEnable(hwndDlg,DID_INSERT,FALSE);
              }
            else
//              if (!pstCOMiCFG->bPCIadapter)
                WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_SETITEMTEXT,MPFROMSHORT(iItemSelected),MPFROMP(szListString));
            }
          else
#if DEBUG > 0
            if (rc == DID_ERROR)
              {
              eidError = WinGetLastError(pstCOMiCFG->hab);
              sprintf(szMessage,"Error loading Port Config Dialog - rc = %08X",eidError);
              MessageBox(HWND_DESKTOP,szMessage);
              }
            {
            }
#endif
          bInsertNewDevice = FALSE;
          break;
        case DID_DELETE:
          if ((iItemJustSelected = (int)WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_QUERYSELECTION,0L,0L)) == LIT_NONE)
            break;
          if (iItemJustSelected != iItemSelected)
            {
            WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_QUERYITEMTEXT,MPFROM2SHORT(iItemJustSelected,7),MPFROMP(szCurrentConfigDeviceName));
            RemoveLeadingSpaces(szCurrentConfigDeviceName);
            RemoveSpaces(szCurrentConfigDeviceName);
            strncpy(stGlobalDCBheader.abyPortName,szCurrentConfigDeviceName,8);
            MakeDeviceName(stGlobalDCBheader.abyPortName);
            if (!QueryIniDCBheaderName(szDriverIniPath,&stGlobalCFGheader,&stGlobalDCBheader,&stDCBposition))
              {
              stGlobalDCBheader.abyPortName[0] = '$';
              QueryIniDCBheaderName(szDriverIniPath,&stGlobalCFGheader,&stGlobalDCBheader,&stDCBposition);
              }
            }
          DeleteListItems(&stGlobalCFGheader,&stGlobalDCBheader);
          astConfigDeviceList[atoi(&szCurrentConfigDeviceName[DEV_NUM_INDEX])].bAvailable = TRUE;
          szCurrentConfigDeviceName[0] = 0;
          RemoveIniDCBheader(szDriverIniPath,&stDCBposition);
          InitializeDCBheader(&stGlobalDCBheader,pstCOMiCFG->bInstallCOMscope);
          iDeviceCount = FillDeviceCfgListBox(hwndDlg,stDCBposition,szDriverIniPath,pstCOMiCFG->ulMaxDeviceCount);
          if (iDeviceCount == 0)
            ControlEnable(hwndDlg,PCFG_ADD_LOAD,FALSE);
          ControlEnable(hwndDlg,DID_INSERT,TRUE);
          ControlEnable(hwndDlg,DID_INSTALL,FALSE);
          ControlEnable(hwndDlg,DID_DELETE,FALSE);
          iItemSelected = LIT_NONE;
          break;
        case DID_HELP:
          DisplayHelpPanel(pstCOMiCFG,HLPP_INSTALL_DLG);
          return((MRESULT)FALSE);
        case DID_CANCEL:
          UnMarkAllDevices(astConfigDeviceList);
          DestroyList(&pAddressList);
          DestroyList(&pSpoolList);
          DestroyList(&pInterruptList);
          DestroyList(&pLoadAddressList);
          DestroyList(&pLoadInterruptList);
          WinDismissDlg(hwndDlg,FALSE);
          return((MRESULT)FALSE);
        default:
          return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
        }
      return((MRESULT)FALSE);
    case WM_CONTROL:
      switch (SHORT2FROMMP(mp1))
        {
        case BN_PAINT:
          if (SHORT1FROMMP(mp1) == DID_OEM)
            {
            pstButton = PVOIDFROMMP(mp2);
            if (pstButton->fsState == BDS_HILITED)
               hBitmap = GpiLoadBitmap(pstButton->hps,hThisModule,ID_OEM_BITMAP1,lXbutton,lYbutton);
            else
               hBitmap = GpiLoadBitmap(pstButton->hps,hThisModule,ID_OEM_BITMAP2,lXbutton,lYbutton);
            WinDrawBitmap(pstButton->hps,hBitmap,0,&ptl,0,0,DBM_NORMAL);
            }
          break;
        case SPBN_CHANGE:
          WinSendDlgItemMsg(hwndDlg,PCFG_LOAD,
                                    SPBM_QUERYVALUE,
                                    MPFROMP(&lNewLoadNumber),
                                    MPFROM2SHORT(0,SPBQ_UPDATEIFVALID));
          if (stDCBposition.wLoadNumber != (WORD)lNewLoadNumber)
            {
            if (Checked(hwndDlg,PCFG_KEY_WAIT))
              {
              WinQueryDlgItemText(hwndDlg,PCFG_DELAY,6,szString);
              if ((stGlobalCFGheader.wDelayCount = (WORD)atoi(szString)) < 10)
                stGlobalCFGheader.wDelayCount = 10;
              }
            else
              stGlobalCFGheader.wDelayCount = 0;
            if (Checked(hwndDlg,PCFG_VERBOSE))
              stGlobalCFGheader.wLoadFlags |= LOAD_FLAG1_VERBOSE;
            else
              stGlobalCFGheader.wLoadFlags &= ~LOAD_FLAG1_VERBOSE;
            stGlobalCFGheader.wLoadFlags |= LOAD_FLAG1_ADVANCED_CFG;
            PlaceIniCFGheader(szDriverIniPath,&stGlobalCFGheader,&stDCBposition);
            stDCBposition.wLoadNumber = (WORD)lNewLoadNumber;
            iItemSelected = LIT_NONE;
            DestroyList(&pLoadAddressList);
            DestroyList(&pLoadInterruptList);
            iDeviceCount = FillDeviceCfgListBox(hwndDlg,stDCBposition,szDriverIniPath,pstCOMiCFG->ulMaxDeviceCount);
            QueryIniCFGheader(szDriverIniPath,&stGlobalCFGheader,&stDCBposition);
            CheckButton(hwndDlg,PCFG_VERBOSE,(stGlobalCFGheader.wLoadFlags & LOAD_FLAG1_VERBOSE));
            if (stGlobalCFGheader.wDelayCount != 0)
              {
              CheckButton(hwndDlg,PCFG_KEY_WAIT,TRUE);
              wLastDelayCount = stGlobalCFGheader.wDelayCount;
              sprintf(szString,"%u",wLastDelayCount);
              WinSendDlgItemMsg(hwndDlg,PCFG_DELAY,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
              WinSetDlgItemText(hwndDlg,PCFG_DELAY,szString);
              ControlEnable(hwndDlg,PCFG_DELAYT,TRUE);
              ControlEnable(hwndDlg,PCFG_DELAY,TRUE);
              }
            else
              {
              CheckButton(hwndDlg,PCFG_KEY_WAIT,FALSE);
              wLastDelayCount = 300;
              sprintf(szString,"%u",wLastDelayCount);
              WinSendDlgItemMsg(hwndDlg,PCFG_DELAY,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
              WinSetDlgItemText(hwndDlg,PCFG_DELAY,szString);
              ControlEnable(hwndDlg,PCFG_DELAYT,FALSE);
              ControlEnable(hwndDlg,PCFG_DELAY,FALSE);
              }
            FillOEMstring(szOEMstring, pstCOMiCFG->byOEMtype);
            sprintf(szListString,szLoadFormat,stDCBposition.wLoadNumber,szOEMstring);
//            if (stGlobalCFGheader.byAdapterType == HDWTYPE_PCI)
//              {
//              pstCOMiCFG->bPCIadapter = TRUE;
//              strcat(szListString, " -> ");
//              iLoadMaxDevice = GetPCIadapterName(szPCIname);
//              strcat(szListString, szPCIname);
//              }
            WinSetDlgItemText(hwndDlg,PCFG_LOADT,szListString);
            sprintf(szListString,szDeviceDefFormat,stDCBposition.wLoadNumber);
            WinSetDlgItemText(hwndDlg,PCFG_DEVT0,szListString);
            if (stDCBposition.wLoadNumber == 1)
              ControlEnable(hwndDlg,PCFG_DELETE_LOAD,FALSE);
            else
              ControlEnable(hwndDlg,PCFG_DELETE_LOAD,TRUE);
            if (iDeviceCount < 1)
              ControlEnable(hwndDlg,PCFG_ADD_LOAD,FALSE);
            else
              ControlEnable(hwndDlg,PCFG_ADD_LOAD,TRUE);
            if (iDeviceCount < iLoadMaxDevice)
              ControlEnable(hwndDlg,DID_INSERT,TRUE);
            else
              ControlEnable(hwndDlg,DID_INSERT,FALSE);
            ControlEnable(hwndDlg,DID_INSTALL,FALSE);
            ControlEnable(hwndDlg,DID_DELETE,FALSE);
            }
          break;
        case BN_CLICKED: // same as LN_SELECT
          switch (SHORT1FROMMP(mp1))
            {
            case PCFG_KEY_WAIT:
              if (Checked(hwndDlg,PCFG_KEY_WAIT))
                {
                ControlEnable(hwndDlg,PCFG_DELAY,TRUE);
                ControlEnable(hwndDlg,PCFG_DELAYT,TRUE);
                }
              else
                {
                ControlEnable(hwndDlg,PCFG_DELAY,FALSE);
                ControlEnable(hwndDlg,PCFG_DELAYT,FALSE);
                }
            case PCFG_DEV_LIST:
              ControlEnable(hwndDlg,DID_INSTALL,TRUE);
              ControlEnable(hwndDlg,DID_DELETE,TRUE);
              break;
            }
          break;
        case LN_SETFOCUS:
          if (SHORT1FROMMP(mp1) == PCFG_DEV_LIST)
            {
            ControlEnable(hwndDlg,DID_INSTALL,TRUE);
            ControlEnable(hwndDlg,DID_DELETE,TRUE);
            if (iItemSelected == LIT_NONE)
              WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_SELECTITEM,(MPARAM)0,(MPARAM)TRUE);
            else
              WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_SELECTITEM,(MPARAM)iItemSelected,(MPARAM)TRUE);
            }
          break;
        case LN_ENTER:
          WinPostMsg(hwndDlg,WM_COMMAND,MPFROMSHORT(DID_INSTALL),(MPARAM)0);
          break;
        }
      return((MRESULT)TRUE);
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }

int FillDeviceCfgListBox(HWND hwndDlg,DCBPOS stSelectPosition,char szDriverIniSpec[],ULONG ulMaxDeviceCount)
  {
  int iLen;
  ULONG ulStatus;
  HFILE hFile;
  int iIndex;
  int iMaxCount;
  int iDCBindex;
  ULONG ulCount;
  CFGINFO stConfigInfo;
  CFGHEAD stConfigHeader;
  DCBHEAD stDCBheader;
  ULONG ulFilePosition;
  int iItemIndex = 0;
  char szListString[80];
  char szPCIname[100];
  DCBPOS stDCBposition;
  char szString[9];
  BYTE byIntLevel;
  WORD wAddress;
  BOOL bPCIadapter = FALSE;

  if ((pLoadInterruptList = InitializeList()) == NULL)
    return(0);
  if ((pLoadAddressList = InitializeList()) == NULL)
    return(0);
  while (DosOpen(szDriverIniSpec,&hFile,&ulStatus,0L,0,1,0x1312,(PEAOP2)0L) != 0)
    if (AddIniConfigHeader(szDriverIniSpec,&stDCBposition) == 0)
      return(0);
  if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
    {
    WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_DELETEALL,0L,0L);
    if (stConfigInfo.wCFGheaderCount >= stSelectPosition.wLoadNumber)
      {
      DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
      for (iIndex = 1;iIndex <= stSelectPosition.wLoadNumber;iIndex++)
        {
        if (DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount) != 0)
           return(FALSE);
        DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
        }
      if (stConfigHeader.bHeaderIsInitialized)
        {
        if (stConfigHeader.byInterruptLevel != 0)
          {
          byIntLevel =  stConfigHeader.byInterruptLevel;
          AddListItem(pLoadInterruptList,&byIntLevel,1);
          }
        DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
//        if (pstCOMiCFG->bPCIadapter}
        if (stConfigHeader.byAdapterType == HDWTYPE_PCI)
          {
          bPCIadapter = TRUE;
          if ((iMaxCount = GetPCIadapterName(NULL, 0)) != 0)
            iOEMloadMaxDevice = iMaxCount;
          }
        else
          if (ulMaxDeviceCount == 0)
            if (stConfigHeader.wDCBcount == 0)
              iLoadMaxDevice = iOEMloadMaxDevice;
            else
              iLoadMaxDevice = stConfigHeader.wDCBcount;
        for (iDCBindex = 1;iDCBindex <= stConfigHeader.wDCBcount;iDCBindex++)
          {
          if (DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount) == 0)
            {
            if (stDCBheader.bHeaderIsInitialized)
              {
              strncpy(szString,stDCBheader.abyPortName,8);
              RemoveSpaces(szString);
              if (!bPCIadapter)
                {
                if(stConfigHeader.byInterruptLevel == 0)
                  {
                    byIntLevel = stDCBheader.stComDCB.byInterruptLevel;
                  if (stDCBheader.stComDCB.wConfigFlags1 & CFG_FLAG1_MULTI_INT)
                    {
                    if (FindListByteItem(pLoadInterruptList,(byIntLevel | '\x80')) == NULL)
                      AddListItem(pLoadInterruptList,&byIntLevel,1);
                    }
                  else
                    AddListItem(pLoadInterruptList,&byIntLevel,1);
                  }
                if (stDCBheader.stComDCB.wIObaseAddress == 0xffff)
                  {
                  szString[0] = 'C';
                  iLen = sprintf(szListString,szSkipFormat,szString);
                  }
                else
                  {
                  wAddress =  stDCBheader.stComDCB.wIObaseAddress;
                  AddListItem(pLoadAddressList,&wAddress,2);
                  iLen = sprintf(szListString,szListFormat,szString,stDCBheader.stComDCB.wIObaseAddress,byIntLevel);
                  }
                if (stDCBheader.stComDCB.wIObaseAddress != 0xffff)
                  AppendOptionList(&stDCBheader,&szListString[iLen]);
                }
              else
                {
                wAddress =  stDCBheader.stComDCB.wIObaseAddress;
                byIntLevel = stDCBheader.stComDCB.byInterruptLevel;
                iLen = sprintf(szListString,szPCIdevice,szString);
                }
              WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(szListString));
              iItemIndex++;
              }
            }
          DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
          }
        }
      }
    }
  sprintf(szListString,"  ");
  DosClose(hFile);
  return(iItemIndex);
  }

MRESULT EXPENTRY fnwpPortOEMconfigDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static WORD wLoadFlags;
  static BYTE fDisplayBase = DISP_HEX;
  BYTE byOEMtype;
  BYTE byAdapterType;
  char szPCIname[100];
//  BYTE byLoadOEMtype;
  static WORD wIntAlgorithim;
  char szTitle[200];
  WORD wAddress;
  static COMICFG *pstCOMiCFG;
  ULONG ulNewIntLevel;
  static BYTE byIntLevel;
  WORD wOEMentryVector;
  WORD wOEMexitVector;
  LINKLIST *pListItem;

  switch (msg)
    {
    case WM_INITDLG:
      CenterDlgBox(hwndDlg);
      WinSetFocus(HWND_DESKTOP,hwndDlg);
      pstCOMiCFG = PVOIDFROMMP(mp2);
      byOEMtype = pstCOMiCFG->byOEMtype;
      wIntAlgorithim = stGlobalCFGheader.wIntAlgorithim;
      wAddress = stGlobalCFGheader.wIntIDregister;
      byAdapterType = stGlobalCFGheader.byAdapterType;
//      byOEMtype = stGlobalCFGinfo.byOEMtype;
      byIntLevel = stGlobalCFGheader.byInterruptLevel;
      wLoadFlags = stGlobalCFGheader.wLoadFlags;
      // test if COMi is OEM build
      if (byOEMtype != 0)
        {
        switch (byOEMtype)
          {
          case OEM_DIGIBOARD08:
          case OEM_DIGIBOARD16:
//            if (byOEMtype != OEM_OTHER)
//              byOEMtype = byOEMtype;
//            else
              byAdapterType = HDWTYPE_FOUR;
            break;
          case OEM_COMTROL:
            byAdapterType = HDWTYPE_TWO;
            break;
          case OEM_MOXA:
            byAdapterType = HDWTYPE_PCI;
            break;
          case OEM_QUATECH:
            if (!bLimitLoad)
              byAdapterType = HDWTYPE_ONE;
            break;
          case OEM_GLOBETEK:
            if (byAdapterType != HDWTYPE_PCI)
              if (!bLimitLoad)
                byAdapterType = HDWTYPE_ONE;
            break;
          case OEM_CONNECTECH:
            if (byAdapterType != HDWTYPE_PCI)
              if (!bLimitLoad)
                byAdapterType = HDWTYPE_THREE;
            break;
          case OEM_BOCA:
            byAdapterType = HDWTYPE_SIX;
            break;
          case OEM_SEALEVEL_RET:
            byAdapterType = HDWTYPE_SEVEN;
            break;
          case OEM_SEALEVEL:
            if (byAdapterType != HDWTYPE_PCI)
              if (!bLimitLoad)
                byAdapterType = HDWTYPE_ONE;
          }
        if (stConfigDeviceCount.wLoadNumber == 1)
          {
          ControlEnable(hwndDlg,PCFG_OEM_ONE,FALSE);
          ControlEnable(hwndDlg,PCFG_OEM_TWO,FALSE);
          ControlEnable(hwndDlg,PCFG_OEM_THREE,FALSE);
          ControlEnable(hwndDlg,PCFG_OEM_FOUR,FALSE);
          ControlEnable(hwndDlg,PCFG_OEM_FIVE,FALSE);
          ControlEnable(hwndDlg,PCFG_OEM_SIX,FALSE);
          ControlEnable(hwndDlg,PCFG_OEM_SEVEN,FALSE);
//          ControlEnable(hwndDlg,RB_TYPEPCI,FALSE);
          ControlEnable(hwndDlg,PCFG_OEM_OTHER,FALSE);
          if (byAdapterType == HDWTYPE_DIGIBOARD)
            {
            ControlEnable(hwndDlg,PCFG_OEM_FOUR,TRUE);
            ControlEnable(hwndDlg,PCFG_OEM_FIVE,TRUE);
            }
          else
            {
            if (byAdapterType == HDWTYPE_CONNECTECH )
              {
              ControlEnable(hwndDlg,RB_TYPEPCI,TRUE);
              ControlEnable(hwndDlg,PCFG_OEM_TWO,TRUE);
              }
            else
              {
              switch (byOEMtype)
                {
                case OEM_SEALEVEL:
                  ControlEnable(hwndDlg,RB_TYPEPCI,TRUE);
                  ControlEnable(hwndDlg,PCFG_OEM_OTHER,TRUE);
                  ControlEnable(hwndDlg,PCFG_OEM_ONE,TRUE);
                  break;
                case OEM_GLOBETEK:
                  ControlEnable(hwndDlg,RB_TYPEPCI,TRUE);
                  ControlEnable(hwndDlg,PCFG_OEM_ONE,TRUE);
                  break;
                case OEM_CONNECTECH:
                  ControlEnable(hwndDlg,RB_TYPEPCI,TRUE);
                  ControlEnable(hwndDlg,PCFG_OEM_TWO,TRUE);
                  break;
                case OEM_MOXA:
                  ControlEnable(hwndDlg,RB_TYPEPCI,TRUE);
                  break;
                deault:
                  ControlEnable(hwndDlg,(PCFG_OEM_OTHER + byAdapterType),TRUE);
                  ControlEnable(hwndDlg,PCFG_OEM_OTHER,TRUE);
                  break;
                }
              }
            }
          }
        if ((byOEMtype == OEM_DIGIBOARD08) || (byOEMtype == OEM_DIGIBOARD16))
          {
          WinLoadString(pstCOMiCFG->hab,hThisModule,(LONG)ATM_OEM_DIGIBOARD08,39,(PSZ)szOEMname);
          WinSetDlgItemText(hwndDlg,PCFG_OEM_FOUR,szOEMname);
          WinLoadString(pstCOMiCFG->hab,hThisModule,(LONG)ATM_OEM_DIGIBOARD16,39,(PSZ)szOEMname);
          WinSetDlgItemText(hwndDlg,PCFG_OEM_FIVE,szOEMname);
          }
        else
          {
          if (byOEMtype == OEM_CONNECTECH)
            {
            WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_CONNECTECH_PCI,39,(PSZ)szOEMname);
            WinSetDlgItemText(hwndDlg,RB_TYPEPCI,szOEMname);
            WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_CONNECTECH_SP,39,(PSZ)szOEMname);
            WinSetDlgItemText(hwndDlg,PCFG_OEM_TWO,szOEMname);
            }
          else
          if (byOEMtype == OEM_MOXA)
            {
            WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_MOXA_PCI,39,(PSZ)szOEMname);
            WinSetDlgItemText(hwndDlg,RB_TYPEPCI,szOEMname);
//            WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_MOXA,39,(PSZ)szOEMname);
//            WinSetDlgItemText(hwndDlg,PCFG_OEM_ONE,szOEMname);
            }
          else
          if (byOEMtype == OEM_GLOBETEK)
            {
            WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_GLOBETEK_PCI,39,(PSZ)szOEMname);
            WinSetDlgItemText(hwndDlg,RB_TYPEPCI,szOEMname);
            WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_GLOBETEK_SP,39,(PSZ)szOEMname);
            WinSetDlgItemText(hwndDlg,PCFG_OEM_ONE,szOEMname);
            }
          else
            {
            if (bLimitLoad || (byOEMtype == OEM_SEALEVEL))
              {
//              if (byAdapterType == HDWTYPE_PCI)
                {
                WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_SEALEVEL_PCI,39,(PSZ)szOEMname);
                WinSetDlgItemText(hwndDlg,RB_TYPEPCI,szOEMname);
                }
              WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_SEALEVEL_OTHER,39,(PSZ)szOEMname);
              WinSetDlgItemText(hwndDlg,PCFG_OEM_OTHER,szOEMname);
              WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_SEALEVEL_SP,39,(PSZ)szOEMname);
              WinSetDlgItemText(hwndDlg,PCFG_OEM_ONE,szOEMname);
              }
            else
              {
              WinLoadString(pstCOMiCFG->hab,hThisModule,(LONG)(ATM_OEM_SEALEVEL + (byDDOEMtype - 1)),39,(PSZ)szOEMname);
              WinSetDlgItemText(hwndDlg,(PCFG_OEM_OTHER + byAdapterType),szOEMname);
              }
            }
          }
        }
      if ((byAdapterType == HDWTYPE_PCI) || (byOEMtype == OEM_OTHER))
        {
        ControlEnable(hwndDlg,PCFG_BASE_ADDR,FALSE);
        ControlEnable(hwndDlg,PCFG_DISP_CHEX,FALSE);
        ControlEnable(hwndDlg,PCFG_DISP_DEC,FALSE);
        ControlEnable(hwndDlg,GB_INTERRUPTSTATUSIDADDRESS,FALSE);
        ControlEnable(hwndDlg,GB_ENTRYBASE,FALSE);
        ControlEnable(hwndDlg,PCFG_INT_LEVEL,FALSE);
        ControlEnable(hwndDlg,PCFG_INT_LEVELT,FALSE);
        ControlEnable(hwndDlg,DID_OEM_ALGO,FALSE);
        if (byAdapterType != HDWTYPE_PCI)
          CheckButton(hwndDlg,PCFG_OEM_OTHER,TRUE);
        else
          {
          GetPCIadapterName(szPCIname, byOEMtype);
          WinSetDlgItemText(hwndDlg,ST_PCIADAPTERNAME,szPCIname);
          WinShowWindow(WinWindowFromID(hwndDlg,ST_PCIADAPTERNAME),TRUE);
          CheckButton(hwndDlg,RB_TYPEPCI,TRUE);
          }
        }
      else
        {
        CheckButton(hwndDlg,(PCFG_OEM_OTHER + byAdapterType),TRUE);
        WinSendDlgItemMsg(hwndDlg,PCFG_BASE_ADDR,EM_SETTEXTLIMIT,MPFROMSHORT(12),(MPARAM)NULL);
        switch (fDisplayBase)
          {
          case DISP_DEC:
            sprintf(szTitle,"%u",wAddress);
            CheckButton(hwndDlg,PCFG_DISP_DEC,TRUE);
            break;
          case DISP_CHEX:
          default:
            CheckButton(hwndDlg,PCFG_DISP_CHEX,TRUE);
            sprintf(szTitle,"%X",wAddress);
            break;
          }
        if (wAddress != 0)
          WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szTitle);
        if (byIntLevel == 0)
          if ((byIntLevel = stGlobalDCBheader.stComDCB.byInterruptLevel) == 0)
            {
            byIntLevel = byLastIntLevel;
            if (!GetNextAvailableInterrupt(&byIntLevel))
              {
              MessageBox(hwndDlg,"There are no more interrupts available.\n\nYou will have to delete a device, or remove a load, to free up an interrupt.");
              WinDismissDlg(hwndDlg,FALSE);
              return(MRESULT)TRUE;
              }
            }
        }
      WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,SPBM_SETLIMITS,(MPARAM)15L,(MPARAM)MIN_INT_LEVEL);
      WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,SPBM_SETCURRENTVALUE,(MPARAM)byIntLevel,NULL);
      return (MRESULT) TRUE;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_HELP:
          DisplayHelpPanel(pstCOMiCFG,HLPP_OEM_DLG);
          return((MRESULT)FALSE);
        case DID_OEM_ALGO:
          pstCOMiCFG->usValue = wIntAlgorithim;
          if (WinDlgBox(HWND_DESKTOP,
                        hwndDlg,
                 (PFNWP)fnwpOEMIntAlgorithimDlgProc,
                        hThisModule,
                        PCFG_OEM_ALGO_DLG,
                        pstCOMiCFG))
            wIntAlgorithim = pstCOMiCFG->usValue;
          break;
        case DID_OK:
          pstCOMiCFG->bPCIadapter = FALSE;
          if (!Checked(hwndDlg,RB_TYPEPCI) && !Checked(hwndDlg,PCFG_OEM_OTHER))
            {
            WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,SPBM_QUERYVALUE,&ulNewIntLevel,MPFROM2SHORT(0,SPBQ_DONOTUPDATE));
            if ((ulNewIntLevel <= 1) || (ulNewIntLevel > 15))
              {
              MessageBox(hwndDlg,"The selected interrupt level is out of range.\n\nOnly values between 2 and 15 (inclusive) are valid.");
              break;
              }
//            pstCOMiCFG->bPCIadapter = FALSE;
            wLoadFlags &= ~(LOAD_FLAG1_INT_ID_LOAD_MASK | LOAD_FLAG1_ENABLE_ALL_OUT2);
            stGlobalCFGheader.wIntAlgorithim = wIntAlgorithim;
            if (Checked(hwndDlg,PCFG_OEM_ONE))
              {
              byAdapterType = HDWTYPE_ONE;
              wLoadFlags |= LOAD_FLAG1_SCRATCH_IS_INT_ID;
              iOEMloadMaxDevice = 8;
              switch (wIntAlgorithim)
                {
                case ALGO_POLL:
                  wOEMentryVector = ALGO_VECT_TEST_ZERO;
                  wOEMexitVector = ALGO_VECT_TEST_ZERO;
                  break;
                case ALGO_SELECT:
                  wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
                  wOEMexitVector = ALGO_VECT_ID_IS_BITS_ON;
                  break;
                case ALGO_HYBRID:
                  wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
                  wOEMexitVector = ALGO_VECT_TEST_ZERO;
                  break;
                }
              }
            else
              if (Checked(hwndDlg,PCFG_OEM_TWO))
                {
                byAdapterType = HDWTYPE_TWO;
                wLoadFlags |= (LOAD_FLAG1_SCRATCH_IS_INT_ID | LOAD_FLAG1_TIB_UART);
                iOEMloadMaxDevice = 8;
                switch (wIntAlgorithim)
                  {
                  case ALGO_POLL:
                    wOEMentryVector = ALGO_VECT_TEST_ZERO;
                    wOEMexitVector = ALGO_VECT_TEST_ZERO;
                    break;
                  case ALGO_SELECT:
                    wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
                    wOEMexitVector = ALGO_VECT_ID_IS_BITS_ON;
                    break;
                  case ALGO_HYBRID:
                    wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
                    wOEMexitVector = ALGO_VECT_TEST_ZERO;
                    break;
                  }
                }
              else
                if (Checked(hwndDlg,PCFG_OEM_THREE))
                  {
                  byAdapterType = HDWTYPE_THREE;
//                  wLoadFlags |= LOAD_FLAG1_SCRATCH_IS_INT_ID;
                  iOEMloadMaxDevice = 8;
                  switch (wIntAlgorithim)
                    {
                    case ALGO_POLL:
                      wOEMentryVector = ALGO_VECT_TEST_ZERO;
                      wOEMexitVector = ALGO_VECT_TEST_ZERO;
                      break;
                    case ALGO_SELECT:
                      wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
                      wOEMexitVector = ALGO_VECT_ID_IS_BITS_ON;
                      break;
                    case ALGO_HYBRID:
                      wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
                      wOEMexitVector = ALGO_VECT_TEST_ZERO;
                      break;
                    }
                  }
                else
                    if (Checked(hwndDlg,PCFG_OEM_FOUR))
                      {
                      byAdapterType = HDWTYPE_FOUR;
                      wLoadFlags |= LOAD_FLAG1_DIGIBOARD08_INT_ID;
                      iOEMloadMaxDevice = 8;
                      switch (wIntAlgorithim)
                        {
                        case ALGO_POLL:
                          wOEMentryVector = ALGO_VECT_TEST_FF;
                          wOEMexitVector = ALGO_VECT_TEST_FF;
                          break;
                        case ALGO_SELECT:
                          wOEMentryVector = ALGO_VECT_DigiBoard_ID;
                          wOEMexitVector = ALGO_VECT_DigiBoard_ID;
                          break;
                        case ALGO_HYBRID:
                          wOEMentryVector = ALGO_VECT_DigiBoard_ID;
                          wOEMexitVector = ALGO_VECT_TEST_FF;
                          break;
                        }
                      }
                    else
                      if (Checked(hwndDlg,PCFG_OEM_FIVE))
                        {
                        byAdapterType = HDWTYPE_FIVE;
                        wLoadFlags |= LOAD_FLAG1_DIGIBOARD16_INT_ID;
                        iOEMloadMaxDevice = 16;
                        switch (wIntAlgorithim)
                          {
                          case ALGO_POLL:
                            wOEMentryVector = ALGO_VECT_TEST_FF;
                            wOEMexitVector = ALGO_VECT_TEST_FF;
                            break;
                          case ALGO_SELECT:
                            wOEMentryVector = ALGO_VECT_DigiBoard_ID;
                            wOEMexitVector = ALGO_VECT_DigiBoard_ID;
                            break;
                          case ALGO_HYBRID:
                            wOEMentryVector = ALGO_VECT_DigiBoard_ID;
                            wOEMexitVector = ALGO_VECT_TEST_FF;
                            break;
                          }
                        }
                      else
                        if (Checked(hwndDlg,PCFG_OEM_SIX))
                          {
                          byAdapterType = HDWTYPE_SIX;
//                          wLoadFlags |= LOAD_FLAG1_SCRATCH_IS_INT_ID;
                          iOEMloadMaxDevice = 8;
                          switch (wIntAlgorithim)
                            {
                            case ALGO_POLL:
                              wOEMentryVector = ALGO_VECT_TEST_FF;
                              wOEMexitVector = ALGO_VECT_TEST_FF;
                              break;
                            case ALGO_SELECT:
                              wOEMentryVector = ALGO_VECT_ID_IS_BITS_OFF;
                              wOEMexitVector = ALGO_VECT_ID_IS_BITS_OFF;
                              break;
                            case ALGO_HYBRID:
                              wOEMentryVector = ALGO_VECT_ID_IS_BITS_OFF;
                              wOEMexitVector = ALGO_VECT_TEST_FF;
                              break;
                            }
                          }
                        else
                          if (Checked(hwndDlg,PCFG_OEM_SEVEN))
                            {
                            byAdapterType = HDWTYPE_SEVEN;
                            wLoadFlags |= (LOAD_FLAG1_SCRATCH_IS_INT_ID | LOAD_FLAG1_ENABLE_ALL_OUT2);
                            iOEMloadMaxDevice = 8;
                            switch (wIntAlgorithim)
                              {
                              case ALGO_POLL:
                                wOEMentryVector = ALGO_VECT_TEST_ZERO;
                                wOEMexitVector = ALGO_VECT_TEST_ZERO;
                                break;
                              case ALGO_SELECT:
                                wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
                                wOEMexitVector = ALGO_VECT_ID_IS_BITS_ON;
                                break;
                              case ALGO_HYBRID:
                                wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
                                wOEMexitVector = ALGO_VECT_TEST_ZERO;
                                break;
                              }
                            }
                          else
                            {
                            iOEMloadMaxDevice = 8;
                            wOEMentryVector = ALGO_VECT_POLL;
                            wOEMexitVector = ALGO_VECT_POLL;
                            }
            }
          else
            {
            if (Checked(hwndDlg,PCFG_OEM_OTHER))
              {
              byAdapterType = HDWTYPE_NONE;
              iOEMloadMaxDevice = 8;
              wOEMentryVector = ALGO_VECT_POLL;
              wOEMexitVector = ALGO_VECT_POLL;
              }
            else
              {
              byAdapterType = HDWTYPE_PCI;
              pstCOMiCFG->bPCIadapter = TRUE;
              wOEMentryVector = ALGO_VECT_POLL;
              wOEMexitVector = ALGO_VECT_POLL;
              }
            }
          stGlobalCFGheader.byAdapterType = byAdapterType;
          stGlobalCFGheader.wLoadFlags = wLoadFlags;
          stGlobalCFGheader.wDCBcount = iOEMloadMaxDevice;
          stGlobalCFGheader.wOEMentryVector = wOEMentryVector;
          stGlobalCFGheader.wOEMexitVector = wOEMexitVector;
          stGlobalCFGheader.wIntAlgorithim = wIntAlgorithim;
          if ((byAdapterType != HDWTYPE_NONE) && (byAdapterType != HDWTYPE_PCI))
//          if ((byOEMtype != OEM_OTHER) && (byAdapterType != HDWTYPE_PCI))
            {
            WinQueryDlgItemText(hwndDlg,PCFG_BASE_ADDR,12,szTitle);
            if (fDisplayBase == DISP_HEX)
              wAddress = ASCIItoBin(szTitle,16);
            else
              wAddress = atoi(szTitle);
            if (wAddress == 0)
              {
              MessageBox(hwndDlg,"You must enter an interrupt ID register address if you have selected any adapter type except \"Not interrupt sharing\".");
              return((MRESULT)FALSE);
              }
            switch (byAdapterType)
              {
              case HDWTYPE_THREE:  // DigiBoard PC/4
              case HDWTYPE_FOUR:   // DigiBoard PC/8
                break;
              case HDWTYPE_FIVE:   // DigiBoard PC/16
                if (wLastAddress == 0x3f8)
                  switch (wAddress)
                    {
                    case 0x140:
                      wLastAddress = 0x100;
                      break;
                    case 0x188:
                      wLastAddress = 0x130;
                      break;
                    case 0x289:
                      wLastAddress = 0x230;
                      break;
                    }
//                AddListItem(pLoadAddressList,&wLastAddress,2);
//                AddListItem(pAddressList,&wLastAddress,2);
                if (!pstCOMiCFG->bPCIadapter)
                  {
                  AddListItem(pLoadAddressList,&wAddress,2);
                  AddListItem(pAddressList,&wAddress,2);
                  }
                break;
              default:
                if ((wAddress - 7) % 8)
                  {
                  MessageBox(hwndDlg,"The interrupt ID register must be at the adapter's base I/O address plus seven (e.g., 0x307) for the adapter type you have selected.");
                  return((MRESULT)FALSE);
                  }
                else
                  if (wLastAddress == 0x3f8)
                    wLastAddress = (wAddress - 7);
                break;
              }
            stGlobalCFGheader.wIntIDregister = wAddress;
            if ((byIntLevel != 0) && ((BYTE)ulNewIntLevel != byIntLevel))
              if ((pListItem = FindListByteItem(pInterruptList,byIntLevel)) != NULL)
                RemoveListItem(pListItem);
            byIntLevel = (BYTE)ulNewIntLevel;
            if (FindListByteItem(pInterruptList,byIntLevel) != NULL)
              if ((FindListByteItem(pLoadInterruptList,byIntLevel) == NULL) &&
                  (FindListByteItem(pLoadInterruptList,(byIntLevel | '\x80')) == NULL))
                {
                sprintf(szTitle,"Interrupt level %u is already taken.  Please select a different Interrupt.",byIntLevel);
                MessageBox(hwndDlg,szTitle);
                return((MRESULT)TRUE);
                }
            AddListItem(pInterruptList,&byIntLevel,1);
            byLastIntLevel = byIntLevel;
            stGlobalCFGheader.byInterruptLevel = byIntLevel;
            }
          else
            {
            if (byAdapterType == HDWTYPE_NONE)
//            if (Checked(hwndDlg,PCFG_OEM_OTHER))
              if (byIntLevel != 0)
                {
                if ((pListItem = FindListByteItem(pInterruptList,byIntLevel)) == NULL)
                  pListItem = FindListByteItem(pInterruptList,byIntLevel);
                if (pListItem != NULL)
                  RemoveListItem(pListItem);
                }
            stGlobalCFGheader.byInterruptLevel = 0;
            stGlobalCFGheader.wIntIDregister = 0;
            }
          WinDismissDlg(hwndDlg,TRUE);
          return(MRESULT)TRUE;
        case DID_CANCEL:
          WinDismissDlg(hwndDlg,FALSE);
          break;
        default:
          return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
        }
      return((MRESULT)FALSE);
    case WM_CONTROL:
      switch (SHORT1FROMMP(mp1))
        {
        case PCFG_DISP_CHEX:
        case PCFG_DISP_DEC:
          if (Checked(hwndDlg,PCFG_DISP_CHEX))
            {
            if (fDisplayBase != DISP_HEX)
              {
              fDisplayBase = DISP_HEX;
              WinQueryDlgItemText(hwndDlg,PCFG_BASE_ADDR,12,szTitle);
              wAddress = atoi(szTitle);
              itoa(wAddress,szTitle,16);
              WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szTitle);
              }
            }
          else
            {
            if (fDisplayBase != DISP_DEC)
              {
              fDisplayBase = DISP_DEC;
              WinQueryDlgItemText(hwndDlg,PCFG_BASE_ADDR,12,szTitle);
              wAddress = (WORD)ASCIItoBin(szTitle,16);
              itoa(wAddress,szTitle,10);
              WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szTitle);
              }
            }
        case PCFG_OEM_ONE:
        case PCFG_OEM_TWO:
        case PCFG_OEM_THREE:
        case PCFG_OEM_FOUR:
        case PCFG_OEM_FIVE:
        case PCFG_OEM_SIX:
        case PCFG_OEM_SEVEN:
//        case PCFG_OEM_EIGHT:
          if (Checked(hwndDlg,SHORT1FROMMP(mp1)))
            {
            WinShowWindow(WinWindowFromID(hwndDlg,ST_PCIADAPTERNAME),FALSE);
//            CheckButton(hwndDlg,PCFG_OEM_OTHER,TRUE);
            ControlEnable(hwndDlg,PCFG_BASE_ADDR,TRUE);
            ControlEnable(hwndDlg,PCFG_DISP_CHEX,TRUE);
            ControlEnable(hwndDlg,PCFG_DISP_DEC,TRUE);
            ControlEnable(hwndDlg,GB_INTERRUPTSTATUSIDADDRESS,TRUE);
            ControlEnable(hwndDlg,GB_ENTRYBASE,TRUE);
            ControlEnable(hwndDlg,PCFG_INT_LEVEL,TRUE);
            ControlEnable(hwndDlg,PCFG_INT_LEVELT,TRUE);
            ControlEnable(hwndDlg,DID_OEM_ALGO,TRUE);
            }
          break;
        case PCFG_OEM_OTHER:
          if (Checked(hwndDlg,PCFG_OEM_OTHER))
            {
            WinShowWindow(WinWindowFromID(hwndDlg,ST_PCIADAPTERNAME),FALSE);
//            CheckButton(hwndDlg,PCFG_OEM_OTHER,TRUE);
            ControlEnable(hwndDlg,PCFG_BASE_ADDR,FALSE);
            ControlEnable(hwndDlg,PCFG_DISP_CHEX,FALSE);
            ControlEnable(hwndDlg,PCFG_DISP_DEC,FALSE);
            ControlEnable(hwndDlg,GB_INTERRUPTSTATUSIDADDRESS,FALSE);
            ControlEnable(hwndDlg,GB_ENTRYBASE,FALSE);
            ControlEnable(hwndDlg,PCFG_INT_LEVEL,FALSE);
            ControlEnable(hwndDlg,PCFG_INT_LEVELT,FALSE);
            ControlEnable(hwndDlg,DID_OEM_ALGO,FALSE);
            }
          break;
        case RB_TYPEPCI:
          if (Checked(hwndDlg,RB_TYPEPCI))
            {
            GetPCIadapterName(szPCIname, byOEMtype);
            WinSetDlgItemText(hwndDlg,ST_PCIADAPTERNAME,szPCIname);
            WinShowWindow(WinWindowFromID(hwndDlg,ST_PCIADAPTERNAME),TRUE);
//            CheckButton(hwndDlg,RB_TYPEPCI,TRUE);
            ControlEnable(hwndDlg,PCFG_BASE_ADDR,FALSE);
            ControlEnable(hwndDlg,PCFG_DISP_CHEX,FALSE);
            ControlEnable(hwndDlg,PCFG_DISP_DEC,FALSE);
            ControlEnable(hwndDlg,GB_INTERRUPTSTATUSIDADDRESS,FALSE);
            ControlEnable(hwndDlg,GB_ENTRYBASE,FALSE);
            ControlEnable(hwndDlg,PCFG_INT_LEVEL,FALSE);
            ControlEnable(hwndDlg,PCFG_INT_LEVELT,FALSE);
            ControlEnable(hwndDlg,DID_OEM_ALGO,FALSE);
            }
          break;
        }
      return((MRESULT)TRUE);
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }

int GetPCIadapterName(char szPCIname[], BYTE byOEMtype)
  {
  int iMaxPorts = 0;

  switch (stGlobalCFGheader.wPCIvendor)
    {
    case PCI_VENDOR_MOXA:
      if (szPCIname != NULL)
        if (byOEMtype == OEM_GLOBETEK)
          strcpy(szPCIname,"Globetek model ");
        else
          strcpy(szPCIname,"Moxa model ");
      switch (stGlobalCFGheader.wPCIdevice)
        {
        case PCI_DEVICE_MX_C104H:
          if (szPCIname != NULL)
            strcat(szPCIname, "C104H, four port");
          iMaxPorts = 4;
          break;
        case PCI_DEVICE_MX_C168H:
          if (szPCIname != NULL)
            strcat(szPCIname, "C168H, eight port");
          iMaxPorts = 8;
          break;
        }
      break;
    case PCI_VENDOR_3COM:
//      if (szPCIname != NULL)
//        strcpy(szPCIname,"3COM ");
      switch (stGlobalCFGheader.wPCIdevice)
        {
        default:
        case PCI_DEVICE_3COM_MODEM:
          if (szPCIname != NULL)
            strcpy(szPCIname, "U.S.Robotics PCI modem");
          iMaxPorts = 1;
          break;
        }
      break;
    case PCI_VENDOR_GLOBETEK:
      if (szPCIname != NULL)
        strcpy(szPCIname,"Globetek model ");
      switch (stGlobalCFGheader.wPCIdevice)
        {
        case PCI_DEVICE_GT_1002:
          if (szPCIname != NULL)
            strcat(szPCIname, "1002, two port");
          iMaxPorts = 2;
          break;
        case PCI_DEVICE_GT_1004:
          if (szPCIname != NULL)
            strcat(szPCIname, "1004, four port");
          iMaxPorts = 4;
          break;
        case PCI_DEVICE_GT_1008:
          if (szPCIname != NULL)
            strcat(szPCIname, "1008, eight port");
          iMaxPorts = 8;
          break;
        }
      break;
    case PCI_VENDOR_SEALEVEL:
      if (szPCIname != NULL)
        strcpy(szPCIname,"Sealevel model ");
      switch (stGlobalCFGheader.wPCIdevice)
        {
        case PCI_DEVICE_SL_7101:
          if (szPCIname != NULL)
            strcat(szPCIname,"7101, one port");
          iMaxPorts = 1;
          break;
        case PCI_DEVICE_SL_7102:
          if (szPCIname != NULL)
            strcat(szPCIname,"7102, one port");
          iMaxPorts = 1;
          break;
        case PCI_DEVICE_SL_7103:
          if (szPCIname != NULL)
            strcat(szPCIname,"7103, one port");
          iMaxPorts = 1;
          break;
        case PCI_DEVICE_SL_7104:
          if (szPCIname != NULL)
            strcat(szPCIname,"7104, one port");
          iMaxPorts = 1;
          break;
        case PCI_DEVICE_SL_7105:
          if (szPCIname != NULL)
            strcat(szPCIname,"7105, one port");
          iMaxPorts = 1;
          break;
        case PCI_DEVICE_SL_7201:
          if (szPCIname != NULL)
            strcat(szPCIname,"7201, two port");
          iMaxPorts = 2;
          break;
        case PCI_DEVICE_SL_7202:
          if (szPCIname != NULL)
            strcat(szPCIname,"7202, two port");
          iMaxPorts = 2;
          break;
        case PCI_DEVICE_SL_7203:
          if (szPCIname != NULL)
            strcat(szPCIname,"7203, two port");
          iMaxPorts = 2;
          break;
        case PCI_DEVICE_SL_7901:
          if (szPCIname != NULL)
            strcat(szPCIname,"7901, two port");
          iMaxPorts = 2;
          break;
        case PCI_DEVICE_SL_7903:
          if (szPCIname != NULL)
            strcat(szPCIname,"7903, two port");
          iMaxPorts = 2;
          break;
        case PCI_DEVICE_SL_7401:
          if (szPCIname != NULL)
            strcat(szPCIname,"7401, four port");
          iMaxPorts = 4;
          break;
        case PCI_DEVICE_SL_7402:
          if (szPCIname != NULL)
            strcat(szPCIname,"7402, four port");
          iMaxPorts = 4;
          break;
        case PCI_DEVICE_SL_7404:
          if (szPCIname != NULL)
            strcat(szPCIname,"7404, four port");
          iMaxPorts = 4;
          break;
        case PCI_DEVICE_SL_7405:
          if (szPCIname != NULL)
            strcat(szPCIname,"7405, four port");
          iMaxPorts = 4;
          break;
        case PCI_DEVICE_SL_7904:
          if (szPCIname != NULL)
            strcat(szPCIname,"7904, four port");
          iMaxPorts = 4;
          break;
        case PCI_DEVICE_SL_7801:
          if (szPCIname != NULL)
            strcat(szPCIname,"7801, eight port");
          iMaxPorts = 8;
          break;
        case PCI_DEVICE_SL_7905:
          if (szPCIname != NULL)
            strcat(szPCIname,"7905, eight port");
          iMaxPorts = 8;
          break;
        }
      break;
    case PCI_VENDOR_CONNECTECH:
      if (szPCIname != NULL)
        strcpy(szPCIname,"Blue Heat model ");
      switch (stGlobalCFGheader.wPCIdevice)
        {
        case PCI_DEVICE_BH_V960:
          if (szPCIname != NULL)
            strcat(szPCIname, "V960");
          iMaxPorts = 8;
          break;
        case PCI_DEVICE_BH_V961:
          if (szPCIname != NULL)
            strcat(szPCIname, "V961, eight port");
          iMaxPorts = 8;
          break;
        case PCI_DEVICE_BH_V962:
          if (szPCIname != NULL)
            strcat(szPCIname, "V962");
          iMaxPorts = 8;
          break;
        case PCI_DEVICE_BH_V292:
          if (szPCIname != NULL)
            strcat(szPCIname, "V292");
          iMaxPorts = 8;
          break;
        }
      break;
    default:
      if (szPCIname != NULL)
        strcpy(szPCIname,"Undetermined PCI adapter model");
      iMaxPorts = 8;
      break;
    }
  return(iMaxPorts);
  }

MRESULT EXPENTRY fnwpOEMIntAlgorithimDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static COMICFG *pstCOMiCFG;

  switch (msg)
    {
    case WM_INITDLG:
      CenterDlgBox(hwndDlg);
      WinSetFocus(HWND_DESKTOP,hwndDlg);
      pstCOMiCFG = PVOIDFROMMP(mp2);
      switch (pstCOMiCFG->usValue)
        {
        case ALGO_POLL:
          CheckButton(hwndDlg,PCFG_ALGO_POLL,TRUE);
          break;
        case ALGO_SELECT:
          CheckButton(hwndDlg,PCFG_ALGO_SELECT,TRUE);
          break;
        case ALGO_HYBRID:
          CheckButton(hwndDlg,PCFG_ALGO_HYBRID,TRUE);
          break;
        }
      break;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_HELP:
          DisplayHelpPanel(pstCOMiCFG,HLPP_OEM_ALGO_DLG);
          return((MRESULT)FALSE);
        case DID_OK:
          if (Checked(hwndDlg,PCFG_ALGO_POLL))
            pstCOMiCFG->usValue = ALGO_POLL;
          else
            if (Checked(hwndDlg,PCFG_ALGO_SELECT))
              pstCOMiCFG->usValue = ALGO_SELECT;
            else
              if (Checked(hwndDlg,PCFG_ALGO_HYBRID))
                pstCOMiCFG->usValue = ALGO_HYBRID;
          WinDismissDlg(hwndDlg,TRUE);
          return(MRESULT)TRUE;
        case DID_CANCEL:
          WinDismissDlg(hwndDlg,FALSE);
          break;
        default:
          return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
        }
      return((MRESULT)FALSE);
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }

MRESULT EXPENTRY fnwpPortSelectDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static COMICFG *pstCOMiCFG;
  int iIndex;
  int iItemSelected;
  BOOL bItemSelected;
  int iCOMindex;
  int iTempIndex;
  int iFirstItem;
  char *pDeviceList;

  switch (msg)
    {
    case WM_INITDLG:
      CenterDlgBox(hwnd);
      pstCOMiCFG = PVOIDFROMMP(mp2);
      if ((pDeviceList = (char *)malloc(1000)) == NULL)
        {
        WinDismissDlg(hwnd,NO_MEMORY_AVAIL);
        return(FALSE);
        }
      pstCOMiCFG->pDeviceList = pDeviceList;
      pstCOMiCFG->cbDevList = 1000;
      iDeviceCount = FillDeviceNameList(pstCOMiCFG);
      pstCOMiCFG->cbDevList = 0;
      if (iDeviceCount == 0)
        {
        free(pDeviceList);
        pstCOMiCFG->pDeviceList = NULL;
        WinDismissDlg(hwnd,NO_PORT_AVAILABLE);
        return(FALSE);
        }
      bItemSelected = TRUE;
      iCOMindex = 0;
      if (pstCOMiCFG->bEnumCOMscope)
        {
        if (pstCOMiCFG->bPortActive)
          {
          iFirstItem = atoi(&pDeviceList[3]);
          iCOMindex = atoi(&pstCOMiCFG->pszPortName[3]);
          bItemSelected = FALSE;
          }
        }
      iIndex = 0;
      for (iIndex = 0;iIndex < iDeviceCount;iIndex++)
        {
        WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(pDeviceList));
        if (!bItemSelected)
          {
          iTempIndex = atoi(&pDeviceList[3]);
          if ((iTempIndex + 1) == iCOMindex)
            {
            WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(pstCOMiCFG->pszPortName));
            bItemSelected = TRUE;
            iCOMindex = (iIndex + 1);
            }
          }
        pDeviceList = &pDeviceList[strlen(pDeviceList) + 1];
        }
      free(pstCOMiCFG->pDeviceList);
      pstCOMiCFG->pDeviceList = NULL;
      if (bItemSelected)
        WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_SELECTITEM,MPFROMSHORT(iCOMindex),MPFROMSHORT(TRUE));
      else
        if (iCOMindex < iFirstItem)
          {
          WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_INSERTITEM,MPFROMSHORT(0),MPFROMP(pstCOMiCFG->pszPortName));
          WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_SELECTITEM,MPFROMSHORT(0),MPFROMSHORT(TRUE));
          }
        else
          {
          WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(pstCOMiCFG->pszPortName));
          WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_SELECTITEM,MPFROMSHORT(iIndex),MPFROMSHORT(TRUE));
          }
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          iItemSelected = (SHORT)WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_QUERYSELECTION,0L,0L);
          WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_QUERYITEMTEXT,MPFROM2SHORT(iItemSelected,9),MPFROMP(pstCOMiCFG->pszPortName));
          WinDismissDlg(hwnd,PORT_SELECTED);
          break;
        case DID_CANCEL:
          WinDismissDlg(hwnd,FALSE);
          break;
        default:
          return WinDefDlgProc(hwnd,msg,mp1,mp2);
        }
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return(FALSE);
  }

MRESULT EXPENTRY fnwpPortSimpleDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static COMICFG *pstCOMiCFG;
  char szMessage[100];
//  char szCaption[60];
  static DEVDEF *pstDeviceDef;
  int iDevices;
  static int iDeviceCount;
  static char szDriverIniSpec[CCHMAXPATH];
  DCBPOS stHeaderPos;
  static CFGHEAD stCFGheader;
  static DCBHEAD stDCBheader;
  int iIndex;
  USHORT idDlg;
  BOOL bOkToEditConfigSYS = FALSE;
  USHORT usButton;
  static ulButtonOnCount;
  int iDefIndex;
  static BOOL bPCIselected = FALSE;
  static USHORT usVendorID;
  static USHORT usDeviceID;

  switch (msg)
    {
    case WM_INITDLG:
      CenterDlgBox(hwndDlg);
      WinSetFocus(HWND_DESKTOP,hwndDlg);
      pstCOMiCFG = PVOIDFROMMP(mp2);
      ulButtonOnCount = 0;
      if (pstCOMiCFG->pszDriverIniSpec != NULL)
        strcpy(szDriverIniSpec,pstCOMiCFG->pszDriverIniSpec);
      else
        strcpy(szDriverIniSpec,szDriverIniPath);
      if (pstCOMiCFG->ulMaxDeviceCount != 1)
        {
        WinShowWindow(WinWindowFromID(hwndDlg,DID_ADVANCED),TRUE);
        ControlEnable(hwndDlg,DID_ADVANCED,TRUE);
        }
      stHeaderPos.wLoadNumber = 1;
      stHeaderPos.wDCBnumber = 1;
      QueryIniCFGheader(szDriverIniPath,&stCFGheader,&stHeaderPos);
      usVendorID = stCFGheader.wPCIvendor;
      usDeviceID = stCFGheader.wPCIdevice;
      if (fIsMCAmachine)
        {
        pstDeviceDef = &astMCAdeviceDefinition[0];
        iDeviceCount = 8;
        }
      else
        if (bPCImachine)
          {
          WinShowWindow(WinWindowFromID(hwndDlg,DID_SELECTADAPTER),TRUE);
          ControlEnable(hwndDlg,DID_SELECTADAPTER,TRUE);
          if ((stCFGheader.byAdapterType == HDWTYPE_PCI) || (stCFGheader.wDeviceCount == 0))
            {
            pstDeviceDef = &astPCIdeviceDefinition[0];
            iDeviceCount = 8;
            bPCIselected = TRUE;
            }
          else
            {
            pstDeviceDef = &astISAdeviceDefinition[0];
            iDeviceCount = 4;
            bPCIselected = FALSE;
            ControlEnable(hwndDlg,DEV_COM5,FALSE);
            ControlEnable(hwndDlg,DEV_COM6,FALSE);
            ControlEnable(hwndDlg,DEV_COM7,FALSE);
            ControlEnable(hwndDlg,DEV_COM8,FALSE);
            WinSetDlgItemText(hwndDlg,DID_SELECTADAPTER,"Use ISA ports");
            }
          }
        else
          {
          pstDeviceDef = &astISAdeviceDefinition[0];
          iDeviceCount = 4;
          }
      for (iIndex = 0;iIndex < 8;iIndex++)
        {
        if (QueryIniDCBheader(szDriverIniPath,&stCFGheader,&stDCBheader,&stHeaderPos))
          {
          if (strlen(stDCBheader.abyPortName) != 0)
            {
            RemoveSpaces(stDCBheader.abyPortName);
            for (iDefIndex = 0;iDefIndex < iDeviceCount;iDefIndex++)
              {
              if (strcmp(stDCBheader.abyPortName,pstDeviceDef[iDefIndex].szName) == 0)
                break;
              }
            if (iDefIndex < iDeviceCount)
              { 
              if (bPCImachine)
                {
                astPCIdeviceDefinition[iDefIndex].byInterruptLevel = stDCBheader.stComDCB.byInterruptLevel;
                astPCIdeviceDefinition[iDefIndex].wAddress = stDCBheader.stComDCB.wIObaseAddress;
                }
              CheckButton(hwndDlg,(DEV_COM1 + iDefIndex),TRUE);
              if (pstCOMiCFG->ulMaxDeviceCount != 0)
                if (++ulButtonOnCount >= pstCOMiCFG->ulMaxDeviceCount)
                  break;
              }
            }
          }
        stHeaderPos.wDCBnumber++;
        }
      szMessage[0] = 0;  
      if (bPCIselected && pstCOMiCFG->byOEMtype != OEM_OTHER)
        GetPCIadapterName(szMessage, pstCOMiCFG->byOEMtype);
      else 
        if ((pstCOMiCFG->ulMaxDeviceCount != 0) && (pstCOMiCFG->ulMaxDeviceCount < iDeviceCount))
          {
          if (pstCOMiCFG->ulMaxDeviceCount == 1)
            if (bPCImachine)
              sprintf(szMessage,"Select one PCI device");
            else
              sprintf(szMessage,"Select one standard device");
          else
            if (bPCImachine)
              sprintf(szMessage,"Select up to %s PCI devices",aszOrdinals[pstCOMiCFG->ulMaxDeviceCount]);
            else   
              sprintf(szMessage,"Select up to %s standard devices",aszOrdinals[pstCOMiCFG->ulMaxDeviceCount]);
          }
      if (strlen(szMessage) != 0)
        WinSetDlgItemText(hwndDlg,DEV_MAX,szMessage);
      return (MRESULT) TRUE;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_OK:
          DosDelete(szDriverIniPath);
          stHeaderPos.wLoadNumber = 1;
          stHeaderPos.wDCBnumber = 1;
          InitializeCFGheader(&stCFGheader);
          iDevices = 0;
          for (iIndex = 0;iIndex < iDeviceCount;iIndex++)
            if (Checked(hwndDlg,(iIndex + DEV_COM1)))
              {
              InitializeDCBheader(&stDCBheader,pstCOMiCFG->bInstallCOMscope);
              strcpy(stDCBheader.abyPortName,pstDeviceDef[iIndex].szName);
              MakeDeviceName(stDCBheader.abyPortName);
              stDCBheader.stComDCB.byInterruptLevel = pstDeviceDef[iIndex].byInterruptLevel;
              stDCBheader.stComDCB.wIObaseAddress = pstDeviceDef[iIndex].wAddress;
              PlaceIniDCBheader(szDriverIniPath,&stCFGheader,&stDCBheader,&stHeaderPos);
              iDevices++;
              stHeaderPos.wDCBnumber++;
             }
          stCFGheader.wDeviceCount = (WORD)iDevices;
          if (bPCIselected)
            stCFGheader.byAdapterType = HDWTYPE_PCI;
          else  
            stCFGheader.byAdapterType = 0;
          stCFGheader.wPCIvendor = usVendorID;
          stCFGheader.wPCIdevice = usDeviceID;
          stCFGheader.byPCIslot = 0;
          PlaceIniCFGheader(szDriverIniPath,&stCFGheader,&stHeaderPos);
          if (pstCOMiCFG->pszRemoveOldDriverSpec != NULL)
            bOkToEditConfigSYS = CleanConfigSys(hwndDlg,pstCOMiCFG->pszRemoveOldDriverSpec,HLPP_MB_CONFIGSYS,TRUE);
          if (stHeaderPos.wDCBnumber != 0)
            {
            strncpy(szListString,szDriverIniSpec,(strlen(szDriverIniSpec) - 4));
            szListString[strlen(szDriverIniSpec) - 4] = 0;
            AdjustConfigSys(hwndDlg,szListString,1,bOkToEditConfigSYS,HLPP_MB_CONFIGSYS);
            }
          WinDismissDlg(hwndDlg,TRUE);
          return(MRESULT)TRUE;
        case DID_SELECTADAPTER:
          szMessage[0] = 0;
          if (!bPCIselected)
            {
            bPCIselected = TRUE;
            pstDeviceDef = &astPCIdeviceDefinition[0];
            iDeviceCount = 8;
            ControlEnable(hwndDlg,DEV_COM5,TRUE);
            ControlEnable(hwndDlg,DEV_COM6,TRUE);
            ControlEnable(hwndDlg,DEV_COM7,TRUE);
            ControlEnable(hwndDlg,DEV_COM8,TRUE);
            WinSetDlgItemText(hwndDlg,DID_SELECTADAPTER,"Use ISA ports");
            if (pstCOMiCFG->byOEMtype != OEM_OTHER)
              GetPCIadapterName(szMessage, pstCOMiCFG->byOEMtype);
            }
          else
            {
            pstDeviceDef = &astISAdeviceDefinition[0];
            iDeviceCount = 4;
            bPCIselected = FALSE;
            ControlEnable(hwndDlg,DEV_COM5,FALSE);
            ControlEnable(hwndDlg,DEV_COM6,FALSE);
            ControlEnable(hwndDlg,DEV_COM7,FALSE);
            ControlEnable(hwndDlg,DEV_COM8,FALSE);
            WinSetDlgItemText(hwndDlg,DID_SELECTADAPTER,"Use PCI adapter");
            }
          if ((pstCOMiCFG->ulMaxDeviceCount != 0) && (pstCOMiCFG->ulMaxDeviceCount < iDeviceCount))
            {
            if (pstCOMiCFG->ulMaxDeviceCount == 1)
              {
              if (bPCImachine)
                sprintf(szMessage,"Select one PCI device");
              else
                sprintf(szMessage,"Select one standard device");
              }
            else
              {
              if (bPCImachine)
                sprintf(szMessage,"Select up to %s PCI devices",aszOrdinals[pstCOMiCFG->ulMaxDeviceCount]);
              else   
                sprintf(szMessage,"Select up to %s standard devices",aszOrdinals[pstCOMiCFG->ulMaxDeviceCount]);
              }
            }
          WinSetDlgItemText(hwndDlg,DEV_MAX,szMessage);
          return(MRESULT)TRUE;
        case DID_ADVANCED:
          DosDelete(szDriverIniPath);
          stHeaderPos.wLoadNumber = 1;
          InitializeCFGheader(&stCFGheader);
//          iDevices = 0;
          if (bPCIselected)
            stCFGheader.byAdapterType = HDWTYPE_PCI;
          stCFGheader.wPCIvendor = usVendorID;
          stCFGheader.wPCIdevice = usDeviceID;
          for (iIndex = 0;iIndex < iDeviceCount;iIndex++)
            if (Checked(hwndDlg,(iIndex + DEV_COM1)))
              {
              stHeaderPos.wDCBnumber = 0;   // use next available DCB header
              InitializeDCBheader(&stDCBheader,pstCOMiCFG->bInstallCOMscope);
              strcpy(stDCBheader.abyPortName,pstDeviceDef[iIndex].szName);
              MakeDeviceName(stDCBheader.abyPortName);
              stDCBheader.stComDCB.byInterruptLevel = pstDeviceDef[iIndex].byInterruptLevel;
              stDCBheader.stComDCB.wIObaseAddress = pstDeviceDef[iIndex].wAddress;
              PlaceIniDCBheader(szDriverIniPath,&stCFGheader,&stDCBheader,&stHeaderPos);
              }
          if (pstCOMiCFG->byOEMtype != OEM_OTHER)
            idDlg = DLG_ADVANCEDOEM;
          else
            if (fIsMCAmachine)
              idDlg = PCFG_MAIN_MCA;
            else
              idDlg = PCFG_MAIN;

          WinDismissDlg(hwndDlg,TRUE);

          if (WinDlgBox(HWND_DESKTOP,
                        pstCOMiCFG->hwndFrame,
                 (PFNWP)fnwpPortConfigDlgProc,
                        hThisModule,
                        idDlg,
                        MPFROMP(pstCOMiCFG)))
//            WinDismissDlg(hwndDlg,TRUE);
          return(MRESULT)TRUE;
        case DID_HELP:
          DisplayHelpPanel(pstCOMiCFG,HLPP_SIMPLE_CFG_DLG);
          return((MRESULT)FALSE);
        case DID_CANCEL:
          WinDismissDlg(hwndDlg,FALSE);
          break;
        default:
          return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
        }
      return((MRESULT)FALSE);
    case WM_CONTROL:
      if (SHORT2FROMMP(mp1) == BN_CLICKED)
        {
        usButton = SHORT1FROMMP(mp1);
        if ((usButton >= DEV_COM1) && (usButton <= DEV_COM8))
          {
          if (!Checked(hwndDlg,usButton))
            {
            if (pstCOMiCFG->ulMaxDeviceCount != 0)
              {
              if (ulButtonOnCount < pstCOMiCFG->ulMaxDeviceCount)
                {
                ulButtonOnCount++;
                CheckButton(hwndDlg,usButton,TRUE);
                }
              }
            else
              CheckButton(hwndDlg,usButton,TRUE);
            }
          else
            {
            if (pstCOMiCFG->ulMaxDeviceCount != 0)
              ulButtonOnCount--;
            CheckButton(hwndDlg,usButton,FALSE);
            }
          }
        }
      return((MRESULT)FALSE);
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }

APIRET APIENTRY PortSelectDialog(HWND hwnd,COMICFG *pstCOMiCFG)
  {
  return (WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpPortSelectDlg,hThisModule,PS_DLG,MPFROMP(pstCOMiCFG)));
  }


