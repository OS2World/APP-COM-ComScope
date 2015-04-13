#include <COMMON.H>
#include <ioctl.h>
#include <help.h>

#include "COMi_CFG.H"
#include <utility.h>
#include "atom.h"

#include <OS$tools.h>

char const szDeviceDescriptionFormat[] = "Configuring %s at base address 0x%X, IRQ %u";
char szDeviceDescription[61];
char szInitDeviceDescription[] = "COMi Device Configuration";

extern HWND hwndNoteBookDlg;

//static WORD wHdwAddress;
//static BYTE byHdwIntLevel;

extern hThisModule;
extern BOOL bShareAccessWarning;
extern BOOL bNonExAccessWarning;

extern BOOL bInsert;

extern LINKLIST *pSpoolList;
extern LINKLIST *pAddressList;
extern LINKLIST *pInterruptList;
extern LINKLIST *pLoadAddressList;
extern LINKLIST *pLoadInterruptList;

//extern DCBHEAD stGlobalDCBheader;
//extern CFGHEAD stGlobalCFGheader;
//extern DCBHEAD stTempDCBheader;
//extern CFGHEAD stTempCFGheader;

extern char szCurrentConfigDeviceName[];
extern USHORT fIsMCAmachine;
extern BYTE byLastIntLevel;
extern WORD wLastAddress;
extern DEVLIST astConfigDeviceList[];
extern char szPDRlibrarySpec[];
extern char szLastName[];
extern BOOL bEmptyINI;

MRESULT EXPENTRY fnwpPortConfigDeviceDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static bAllowClick;
  static char szAppName[40];
  static BOOL bSpoolEnabled;
  static NBKPAGECTL *pstPage;
  static CFGHEAD *pstCFGheader;
  static DCBHEAD *pstDCBheader;
  static BYTE fDisplayBase = DISP_HEX;
  static WORD wOldAddress;
  static BYTE byIntLevel;
  static COMICFG *pstCOMiCFG;
  static BOOL bAddressNotAdded;
  int iItemSelected;
  char szPortName[9];
  char szPortDriver[40];
  char szTemp[40];
  BOOL bNameChanged;
  SPOOLLST stSpool;
  char szBuffer[15];
  char szString[200];
  LONG lTemp;
  WORD wAddress;
  BYTE byTemp;
  LINKLIST *pListItem;

  switch (msg)
    {
    case WM_INITDLG:
      bAllowClick = FALSE;
      pstPage = PVOIDFROMMP(mp2);
      pstPage->bDirtyBit = FALSE;
      pstDCBheader = pstPage->pVoidPtrOne;
      pstCFGheader = pstPage->pVoidPtrTwo;
      pstCOMiCFG = pstPage->pVoidPtrThree;
      WinSetWindowText(hwndNoteBookDlg,szInitDeviceDescription);
      /*
      **  setup device name
      */
      szPortName[0] = 0;
      iItemSelected = FillDeviceDialogNameListBox(hwndDlg,szCurrentConfigDeviceName,szPortName);
      WinSendDlgItemMsg(hwndDlg,PCFG_NAME_LIST,LM_SELECTITEM,MPFROMSHORT(iItemSelected),MPFROMSHORT(TRUE));
      strcpy(szCurrentConfigDeviceName,szPortName);
      /*
      ** setup device base I/O address
      */
      if ((wAddress = pstDCBheader->stComDCB.wIObaseAddress) == 0)  // is an address defied?
        {
        wAddress = wLastAddress;  // set search starting point
        if (!GetNextAvailableAddress(&wAddress))
          {
          // no valid address ranges are available
          MessageBox(hwndDlg,"There are no I/O address blocks available.\n\nYou will have to delete a device to free up an address block.");
          WinDismissDlg(hwndDlg,FALSE);
          return(MRESULT)TRUE;
          }
        pstDCBheader->stComDCB.wIObaseAddress = wAddress;
        /*
        ** force this address to appear as changed by user to new address during exit
        ** processing (UM_SAVE_DATA).  Mark as device being inserted.
        */
        wOldAddress = 0xffff;
        }
      else
        wOldAddress = wAddress;
      switch (fDisplayBase)
        {
        case DISP_DEC:
          sprintf(szBuffer,"%u",wAddress);
          CheckButton(hwndDlg,PCFG_DISP_DEC,TRUE);
          break;
        case DISP_CHEX:
        default:
          CheckButton(hwndDlg,PCFG_DISP_CHEX,TRUE);
          sprintf(szBuffer,"%X",wAddress);
          break;
        }
      WinSendDlgItemMsg(hwndDlg,PCFG_BASE_ADDR,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
      WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
      WinSendDlgItemMsg(hwndDlg,PCFG_BASE_ADDR,EM_SETSEL,MPFROM2SHORT(0,5),(MPARAM)NULL);
      bAddressNotAdded = TRUE;  // indicate that this address was not added to address linked list
      /*
      ** setup interrupt level
      */
      if ((byIntLevel = pstCFGheader->byInterruptLevel) == 0)
        {
        if ((byIntLevel = pstDCBheader->stComDCB.byInterruptLevel) == 0)
          {
          byIntLevel = byLastIntLevel;
          if (fIsMCAmachine != YES)
            {
            if (!GetNextAvailableInterrupt(&byIntLevel))
              {
              if ((pstDCBheader->stComDCB.wDeviceFlags1 & CFG_FLAG1_MULTI_INT) == 0)
                {
                MessageBox(hwndDlg,"There are no more interrupts available.\n\nYou will have to delete a device to free up an interrupt.");
//                WinDismissDlg(hwndDlg,FALSE);
                return(MRESULT)TRUE;
                }
              }
            }
          pstDCBheader->stComDCB.byInterruptLevel = byIntLevel;
          }
        }
      else
        {
        ControlEnable(hwndDlg,PCFG_INT_LEVEL,FALSE);
        ControlEnable(hwndDlg,PCFG_INT_LEVELT,FALSE);
        }
      WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
                                SPBM_SETLIMITS,
                                (MPARAM)15L,
                                (MPARAM)MIN_INT_LEVEL);

      WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
                                SPBM_SETCURRENTVALUE,
                               (MPARAM)byIntLevel,
                                NULL);
      byLastIntLevel = byIntLevel;
      /*
      ** test and setup COMscope option
      */
      if (!pstCOMiCFG->bInstallCOMscope)
        ControlEnable(hwndDlg,PCFG_ENA_COMSCOPE,FALSE);
      else
        if (pstCOMiCFG->bInitInstall)
          CheckButton(hwndDlg,PCFG_ENA_COMSCOPE,TRUE);
        else
          if (pstDCBheader->stComDCB.wDeviceFlags1 & CFG_FLAG1_COMSCOPE)
            CheckButton(hwndDlg,PCFG_ENA_COMSCOPE,TRUE);
      /*
      ** test and setup spooler option
      */
      bSpoolEnabled = FALSE;
      if ((szPDRlibrarySpec[0] == 0))// || !bCOMiLoaded)
        ControlEnable(hwndDlg,PCFG_DEV_PDR,FALSE);
      else
        {
        sprintf(szAppName,"PM_%s",szPortName);
        if (PrfQueryProfileString(HINI_SYSTEMPROFILE,szAppName,"PORTDRIVER",0,szPortDriver,40) != 0)
          {
          if (strcmp(szPortDriver,"COMI_SPL;") == 0)
            {
            bSpoolEnabled = TRUE;
            CheckButton(hwndDlg,PCFG_DEV_PDR,TRUE);
            }
          else
            ControlEnable(hwndDlg,PCFG_DEV_PDR,FALSE);
          }
        }
      sprintf(szDeviceDescription,szDeviceDescriptionFormat,szCurrentConfigDeviceName,wLastAddress,byLastIntLevel);
      WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      return (MRESULT) TRUE;
    case UM_INITLS:
      bAllowClick = TRUE;
      break;
    case UM_SAVE_DATA:
      /*
      **  get base I/O address
      */
      WinQueryDlgItemText(hwndDlg,PCFG_BASE_ADDR,6,szBuffer);
      if (fDisplayBase == DISP_HEX)
        wAddress = ASCIItoBin(szBuffer,16);
      else
        wAddress = atoi(szBuffer);
      if (wAddress % 8)
        {
        sprintf(szString,"A device address space must start on an eight byte boundry (e.g., 300h, 3228h).  Please enter a different base address.");
        MessageBox(hwndDlg,szString);
        WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,PCFG_BASE_ADDR));
        return((MRESULT)FALSE);
        }
      if (wAddress != wOldAddress)
        {
        /*
        ** either the user changed the address or a new device is bring inserted
        */
        if (FindListWordItem(pAddressList,wAddress) != NULL)
          {
          // the new address is already in use
          if (fDisplayBase == DISP_HEX)
            sprintf(szString,"Device at address %Xh is already defined.  Please address a different device.",wAddress);
          else
            sprintf(szString,"Device at address %u is already defined.  Please address a different device.",wAddress);
          MessageBox(hwndDlg,szString);
          WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,PCFG_BASE_ADDR));
          return((MRESULT)FALSE);
          }
        /*
        **  add new address to address lists
        */
        AddListItem(pLoadAddressList,&wAddress,2);
        AddListItem(pAddressList,&wAddress,2);
        /*
        **  this was not a new (inserted) device then remove the old address from the address lists
        */
        if (wOldAddress != 0xffff)
          {
          if ((pListItem = FindListWordItem(pAddressList,wOldAddress)) != NULL)
            RemoveListItem(pListItem);
          if ((pListItem = FindListWordItem(pLoadAddressList,wOldAddress)) != NULL)
            RemoveListItem(pListItem);
          }
        wOldAddress = wAddress;
        }
      /*
      ** get interrupt level
      */
      if (pstCFGheader->byInterruptLevel == 0)
        {
        WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,SPBM_QUERYVALUE,&lTemp,MPFROM2SHORT(0,SPBQ_DONOTUPDATE));
        byTemp = (BYTE)lTemp;
        if (byIntLevel != byTemp)
          {
          if (fIsMCAmachine != YES)
            {
            if ((FindListByteItem(pLoadInterruptList,(byTemp | '\x80'))) != NULL)
              {
              if ((pstDCBheader->stComDCB.wDeviceFlags1 & CFG_FLAG1_MULTI_INT) == 0)
                {
                sprintf(szString,"Interrupt Level %u is already taken.  Please select a different Interrupt.",byTemp);
                MessageBox(hwndDlg,szString);
                WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,PCFG_INT_LEVEL));
                return((MRESULT)FALSE);
                }
              }
            else
              {
              if (pstDCBheader->stComDCB.wDeviceFlags1 & CFG_FLAG1_MULTI_INT)
                byTemp |= '\x80';
              AddListItem(pLoadInterruptList,&byTemp,1);
              if ((FindListByteItem(pInterruptList,byTemp)) != NULL)
                {
                sprintf(szString,"Interrupt Level %u is already taken.  Please select a different Interrupt.",byTemp);
                MessageBox(hwndDlg,szString);
                WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,PCFG_INT_LEVEL));
                return((MRESULT)FALSE);
                }
              }
            AddListItem(pInterruptList,&byTemp,1);
            if ((pListItem = FindListByteItem(pInterruptList,byIntLevel)) != NULL)
              RemoveListItem(pListItem);
            if ((pListItem = FindListByteItem(pLoadInterruptList,byIntLevel)) != NULL)
              RemoveListItem(pListItem);
            }
          byIntLevel = (byTemp & ~'\x80');
          }
#ifdef this_junk
        else
          if (bEmptyINI)
            {
            AddListItem(pInterruptList,&byTemp,1);
            if (pstDCBheader->stComDCB.wDeviceFlags1 & CFG_FLAG1_MULTI_INT)
              byTemp |= '\x80';
            AddListItem(pLoadInterruptList,&byTemp,1);
            }
        bEmptyINI = FALSE;
#endif
        byLastIntLevel = byIntLevel;
        pstDCBheader->stComDCB.byInterruptLevel = byIntLevel;
        }
//      AddListItem(pAddressList,&wLastAddress,2);
//      AddListItem(pInterruptList,&byLastIntLevel,1);
      /*
      ** get device name
      */
      iItemSelected = (SHORT)WinSendDlgItemMsg(hwndDlg,PCFG_NAME_LIST,LM_QUERYSELECTION,0L,0L);
      WinSendDlgItemMsg(hwndDlg,PCFG_NAME_LIST,LM_QUERYITEMTEXT,MPFROM2SHORT(iItemSelected,9),MPFROMP(szPortName));
      strcpy(szLastName,szPortName);
      RemoveSpaces(szPortName);
      if (strcmp(szCurrentConfigDeviceName,szPortName) != 0)
        {
        bNameChanged = TRUE;
        strcpy(szTemp,szCurrentConfigDeviceName);
        astConfigDeviceList[atoi(&szPortName[DEV_NUM_INDEX])].bAvailable = FALSE;
        if (szCurrentConfigDeviceName[0] != 0)
          astConfigDeviceList[atoi(&szCurrentConfigDeviceName[DEV_NUM_INDEX])].bAvailable = TRUE;
        strcpy(szCurrentConfigDeviceName,szPortName);
        }
      else
        bNameChanged = FALSE;
      /*
      ** get COMscope option
      */
      if (Checked(hwndDlg,PCFG_ENA_COMSCOPE))
        pstDCBheader->stComDCB.wDeviceFlags1 |= CFG_FLAG1_COMSCOPE;
      else
        pstDCBheader->stComDCB.wDeviceFlags1 &= ~CFG_FLAG1_COMSCOPE;
      /*
      ** get spooler option
      */
      if (Checked(hwndDlg,PCFG_DEV_PDR))
        {
        if (!bSpoolEnabled)
          {
          stSpool.fAction = INSTALL_SPOOL;
          strcpy(stSpool.szPortName,szPortName);
          AddListItem(pSpoolList,&stSpool,sizeof(SPOOLLST));
          }
        else
          {
          if (bNameChanged)
            {
            stSpool.fAction = REMOVE_SPOOL;
            strcpy(stSpool.szPortName,szTemp);
            AddListItem(pSpoolList,&stSpool,sizeof(SPOOLLST));
            stSpool.fAction = INSTALL_SPOOL;
            strcpy(stSpool.szPortName,szPortName);
            AddListItem(pSpoolList,&stSpool,sizeof(SPOOLLST));
            }
          }
        }
      else
        {
        if (bSpoolEnabled)
          {
          stSpool.fAction = REMOVE_SPOOL;
          if (bNameChanged)
            strcpy(stSpool.szPortName,szTemp);
          else
            strcpy(stSpool.szPortName,szPortName);
          AddListItem(pSpoolList,&stSpool,sizeof(SPOOLLST));
          }
        }
      pstDCBheader->stComDCB.wIObaseAddress = wAddress;
      wLastAddress = wAddress;
      pstDCBheader->stComDCB.byInterruptLevel = byLastIntLevel;
      sprintf(szDeviceDescription,szDeviceDescriptionFormat,szCurrentConfigDeviceName,wLastAddress,byLastIntLevel);
      pstPage->bDirtyBit = FALSE;
      return (MRESULT) TRUE;
    case WM_CONTROL:
      switch (SHORT2FROMMP(mp1))
        {
        case  BN_CLICKED:
          switch (SHORT1FROMMP(mp1))
            {
            case PCFG_DISP_CHEX:
            case PCFG_DISP_DEC:
              if (Checked(hwndDlg,PCFG_DISP_CHEX))
                {
                if (fDisplayBase != DISP_HEX)
                  {
                  fDisplayBase = DISP_HEX;
                  WinQueryDlgItemText(hwndDlg,PCFG_BASE_ADDR,12,szBuffer);
                  wAddress = atoi(szBuffer);
                  itoa(wAddress,szBuffer,16);
                  WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
                  }
                }
              else
                {
                if (fDisplayBase != DISP_DEC)
                  {
                  fDisplayBase = DISP_DEC;
                  WinQueryDlgItemText(hwndDlg,PCFG_BASE_ADDR,12,szBuffer);
                  wAddress = (WORD)ASCIItoBin(szBuffer,16);
                  itoa(wAddress,szBuffer,10);
                  WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
                  }
                }
              break;
#ifdef this_junk
            case PCFG_ENA_COMSCOPE:
            case PCFG_DEV_PDR:
              if (bAllowClick)
                pstPage->bDirtyBit = TRUE;
              break;
#endif
            }
          break;
#ifdef this_junk
        case SPBN_CHANGE:
        case CBN_ENTER:
        case EN_CHANGE:
          if (bAllowClick)
            pstPage->bDirtyBit = TRUE;
          break;
#endif
        }
      return((MRESULT)TRUE);
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }

MRESULT EXPENTRY fnwpPortExtensionsDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static bAllowClick;
  static CFGHEAD *pstCFGheader;
  static WORD wDeviceFlags;
  static NBKPAGECTL *pstPage;
  static COMDCB *pstComDCB;
  char szMessage[100];
  char szCaption[60];

  switch (msg)
    {
    case WM_INITDLG:
//      CenterDlgBox(hwndDlg);
//      WinSetFocus(HWND_DESKTOP,hwndDlg);
      bAllowClick = FALSE;
      pstPage = PVOIDFROMMP(mp2);
      pstPage->bDirtyBit = FALSE;
      pstComDCB = pstPage->pVoidPtrOne;
      pstCFGheader = pstPage->pVoidPtrTwo;
      wDeviceFlags = pstComDCB->wDeviceFlags1;
      CheckButton(hwndDlg,PCFG_FOR_UART,(wDeviceFlags & CFG_FLAG1_FOREIGN_UART));
      CheckButton(hwndDlg,PCFG_EXP_BAUD,(wDeviceFlags & CFG_FLAG1_EXPLICIT_BAUD_DIVISOR));
      CheckButton(hwndDlg,PCFG_MDM_EXT,(wDeviceFlags & CFG_FLAG1_EXT_MODEM_CTL));
//      CheckButton(hwndDlg,PCFG_EXT_HDW_HS,(wDeviceFlags & CFG_FLAG1_USE_HDW_HS));
      CheckButton(hwndDlg,PCFG_EXT_4xBAUD,(wDeviceFlags & CFG_FLAG1_4X_USER_BAUD));
      CheckButton(hwndDlg,PCFG_DIS_TEST,(wDeviceFlags & CFG_FLAG1_TESTS_DISABLE));
      CheckButton(hwndDlg,PCFG_MDM_INT,(wDeviceFlags & CFG_FLAG1_NO_MODEM_INT));
      if (pstCFGheader->byOEMtype == OEM_TWO)
        ControlEnable(hwndDlg,PCFG_EXT_TIB,FALSE);
      else
        CheckButton(hwndDlg,PCFG_EXT_TIB,(wDeviceFlags & CFG_FLAG1_TIB_UART));
      CheckButton(hwndDlg,PCFG_OUT1,(wDeviceFlags & CFG_FLAG1_ACTIVATE_OUT1));
      if (pstCFGheader->byInterruptLevel == 0)
        {
        if (wDeviceFlags & CFG_FLAG1_MULTI_INT)
          {
          CheckButton(hwndDlg,PCFG_EXT_SHARE_INT,TRUE);
          if(wDeviceFlags & CFG_FLAG1_EXCLUSIVE_ACCESS)
            CheckButton(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
          }
        else
          {
          CheckButton(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
          ControlEnable(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,FALSE);
          }
        }
      else
        {
        CheckButton(hwndDlg,PCFG_EXT_SHARE_INT,TRUE);
        ControlEnable(hwndDlg,PCFG_EXT_SHARE_INT,FALSE);
        ControlEnable(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,FALSE);
        }
      WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      return (MRESULT) TRUE;
    case UM_INITLS:
      bAllowClick = TRUE;
      break;
    case UM_SAVE_DATA:
      if (Checked(hwndDlg,PCFG_FOR_UART))
        wDeviceFlags |= CFG_FLAG1_FOREIGN_UART;
      else
        wDeviceFlags &= ~CFG_FLAG1_FOREIGN_UART;
      if (Checked(hwndDlg,PCFG_EXP_BAUD))
        wDeviceFlags |= CFG_FLAG1_EXPLICIT_BAUD_DIVISOR;
      else
        wDeviceFlags &= ~CFG_FLAG1_EXPLICIT_BAUD_DIVISOR;
      if (Checked(hwndDlg,PCFG_MDM_EXT))
        wDeviceFlags |= CFG_FLAG1_EXT_MODEM_CTL;
      else
        wDeviceFlags &= ~CFG_FLAG1_EXT_MODEM_CTL;
//          if (Checked(hwndDlg,PCFG_EXT_HDW_HS))
//            wDeviceFlags |= CFG_FLAG1_USE_HDW_HS;
//          else
//            wDeviceFlags &= ~CFG_FLAG1_USE_HDW_HS;
      if (Checked(hwndDlg,PCFG_EXT_4xBAUD))
        wDeviceFlags |= CFG_FLAG1_4X_USER_BAUD;
      else
        wDeviceFlags &= ~CFG_FLAG1_4X_USER_BAUD;
      if (Checked(hwndDlg,PCFG_DIS_TEST))
        wDeviceFlags |= CFG_FLAG1_TESTS_DISABLE;
      else
        wDeviceFlags &= ~CFG_FLAG1_TESTS_DISABLE;
      if (Checked(hwndDlg,PCFG_MDM_INT))
        wDeviceFlags |= CFG_FLAG1_NO_MODEM_INT;
      else
        wDeviceFlags &= ~CFG_FLAG1_NO_MODEM_INT;
      if (pstCFGheader->byOEMtype != OEM_TWO)
        if (Checked(hwndDlg,PCFG_EXT_TIB))
          wDeviceFlags |= CFG_FLAG1_TIB_UART;
        else
          wDeviceFlags &= ~CFG_FLAG1_TIB_UART;
      if (Checked(hwndDlg,PCFG_OUT1))
        wDeviceFlags |= CFG_FLAG1_ACTIVATE_OUT1;
      else
        wDeviceFlags &= ~CFG_FLAG1_ACTIVATE_OUT1;
      if (pstCFGheader->byInterruptLevel == 0)
        {
        if (Checked(hwndDlg,PCFG_EXT_SHARE_INT))
          {
          if (!bShareAccessWarning)
            {
            sprintf(szCaption,"Shared Interrupt Connection Selected!");
            sprintf(szMessage,"More than one device connected to an interrupt level can cause unpredictable results!");
            if (WinMessageBox(HWND_DESKTOP,
                              hwndDlg,
                              szMessage,
                              szCaption,
                              HLPP_MB_SHARE_ACCESS,
                              (MB_OKCANCEL | MB_CUAWARNING | MB_HELP | MB_MOVEABLE)) != MBID_OK)
              {
              CheckButton(hwndDlg,PCFG_EXT_SHARE_INT,FALSE);
              CheckButton(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
              ControlEnable(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,FALSE);
              WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,PCFG_EXT_SHARE_INT));
              return(FALSE);
              }
            }
          wDeviceFlags |= CFG_FLAG1_MULTI_INT;
          bShareAccessWarning = TRUE;
          if (Checked(hwndDlg,PCFG_EXT_EXCLUSIVE_INT))
            wDeviceFlags |= CFG_FLAG1_EXCLUSIVE_ACCESS;
          else
            {
            if (!bNonExAccessWarning)
              {
              sprintf(szCaption,"Non-Exclusive Access Selected!");
              sprintf(szMessage,"Giving more than one device access to an interrupt level can cause unpredictable results!");
              if (WinMessageBox(HWND_DESKTOP,
                                hwndDlg,
                                szMessage,
                                szCaption,
                                HLPP_MB_NONEXCLUSIVE_ACCESS,
                                (MB_OKCANCEL | MB_CUAWARNING | MB_HELP | MB_MOVEABLE)) != MBID_OK)
                {
                CheckButton(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
                WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,PCFG_EXT_EXCLUSIVE_INT));
                return(FALSE);
                }
              }
            wDeviceFlags &= ~CFG_FLAG1_EXCLUSIVE_ACCESS;
            bNonExAccessWarning = TRUE;
            }
          }
        else
          wDeviceFlags &= ~(CFG_FLAG1_EXCLUSIVE_ACCESS | CFG_FLAG1_MULTI_INT);
        }
      pstComDCB->wDeviceFlags1 = wDeviceFlags;
      return (MRESULT) TRUE;
    case WM_CONTROL:
      if (SHORT2FROMMP(mp1) == BN_CLICKED)
        {
        if (bAllowClick)
          {
          pstPage->bDirtyBit = TRUE;
          if (SHORT1FROMMP(mp1) == PCFG_EXT_SHARE_INT)
            if (Checked(hwndDlg,PCFG_EXT_SHARE_INT))
              {
              ControlEnable(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,FALSE);
              CheckButton(hwndDlg,PCFG_EXT_SHARE_INT,FALSE);
              }
            else
              {
              ControlEnable(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
              CheckButton(hwndDlg,PCFG_EXT_SHARE_INT,TRUE);
              CheckButton(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
              }
          }
        }
      break;
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }

