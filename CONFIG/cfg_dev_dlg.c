#include "COMMON.H"
#include "COMDD.H"
#include "ioctl.h"
#include "utility.h"
#include "help.h"
#include "config.h"
#include "COMi_CFG.H"
#include "resource.h"

char const szDeviceDescriptionFormat[] = "Configuring %s at base address 0x%X, IRQ %u";
char const szPCIdeviceDescriptionFormat[] = "Configuring %s in PCI PnP adapter";
char szDeviceDescription[61];
char szInitDeviceDescription[] = "COMi Device Configuration";

extern HWND hwndNoteBookDlg;

//static WORD wHdwAddress;
//static BYTE byHdwIntLevel;

extern hThisModule;
extern BOOL bShareAccessWarning;
extern BOOL bNonExAccessWarning;

extern BOOL bInsertNewDevice;

extern LINKLIST *pSpoolList;
extern LINKLIST *pAddressList;
extern LINKLIST *pInterruptList;
extern LINKLIST *pLoadAddressList;
extern LINKLIST *pLoadInterruptList;

extern char szCurrentConfigDeviceName[];
extern USHORT fIsMCAmachine;
extern BYTE byLastIntLevel;
extern WORD wLastAddress;
extern DEVLIST astConfigDeviceList[];
extern char szPDRlibrarySpec[];
extern char szLastName[];
extern BOOL bEmptyINI;

extern BOOL bWarp4;

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
  static BOOL bCOMscopeEnabled;
  static int iOrgItemSelected;
  static WORD wAddress;
  static BOOL bPCIadapter = FALSE;
  WORD wNewAddress;
  int iItemSelected;
  char szPortName[9];
  char szPortDriver[40];
  char szTemp[40];
  BOOL bNameChanged;
  SPOOLLST stSpool;
  char szBuffer[15];
  char szString[200];
  LONG lTemp;
  BYTE byTemp;
  LINKLIST *pListItem;

  switch (msg)
    {
    case WM_INITDLG:
      if (!bInsertNewDevice)
        WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
//        ControlEnable(hwndDlg,DID_INSERT,FALSE);
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
      iOrgItemSelected = iItemSelected;
      WinSendDlgItemMsg(hwndDlg,PCFG_NAME_LIST,LM_SELECTITEM,MPFROMSHORT(iItemSelected),MPFROMSHORT(TRUE));
      if (!pstCOMiCFG->bPCIadapter)
        {
        /*
        ** setup device base I/O address
        */
        if ((wAddress = pstDCBheader->stComDCB.wIObaseAddress) == 0)  // is an address defined?
          {
          wAddress = wLastAddress;  // set search starting point
          if (!GetNextAvailableAddress(&wAddress))
            {
            MessageBox(hwndDlg,"There are no I/O address blocks available.\n\nYou will have to delete a device to free up an address block.");
            WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
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
                if ((pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_MULTI_INT) == 0)
                  {
                  MessageBox(hwndDlg,"There are no more interrupts available.\n\nYou will have to remove one or more devices to free up an interrupt.");
                  WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
                  return(MRESULT)TRUE;
                  }
                }
              }
            pstDCBheader->stComDCB.byInterruptLevel = byIntLevel;
            }
          WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
                                    SPBM_SETLIMITS,
                                    (MPARAM)15L,
                                    (MPARAM)MIN_INT_LEVEL);
          }
        else
          {
          ControlEnable(hwndDlg,PCFG_INT_LEVEL,FALSE);
          ControlEnable(hwndDlg,PCFG_INT_LEVELT,FALSE);
          }

        WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
                                  SPBM_SETCURRENTVALUE,
                                 (MPARAM)byIntLevel,
                                  NULL);
        byLastIntLevel = byIntLevel;
        sprintf(szDeviceDescription,szDeviceDescriptionFormat,szCurrentConfigDeviceName,wLastAddress,byLastIntLevel);
        }
      else
        {
        ControlEnable(hwndDlg,GB_IOBASEADDRESS,FALSE);
        ControlEnable(hwndDlg,PCFG_BASE_ADDR,FALSE);
        ControlEnable(hwndDlg,GB_ENTRYBASE,FALSE);
        ControlEnable(hwndDlg,PCFG_DISP_CHEX,FALSE);
        ControlEnable(hwndDlg,PCFG_DISP_DEC,FALSE);
        ControlEnable(hwndDlg,PCFG_INT_LEVEL,FALSE);
        ControlEnable(hwndDlg,PCFG_INT_LEVELT,FALSE);
        WinSetDlgItemText(hwndDlg,ST_ADAPTERNOTE,"This device is part of PCI PnP adapter");
        sprintf(szDeviceDescription,szPCIdeviceDescriptionFormat,szCurrentConfigDeviceName);
        }
      /*
      ** test and setup COMscope option
      */
      bCOMscopeEnabled = TRUE;
      if (!pstCOMiCFG->bInstallCOMscope)
        {
        bCOMscopeEnabled = FALSE;
        ControlEnable(hwndDlg,PCFG_ENA_COMSCOPE,FALSE);
        }
      else
        if (pstCOMiCFG->bInitInstall)
          CheckButton(hwndDlg,PCFG_ENA_COMSCOPE,TRUE);
        else
          if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_COMSCOPE)
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
      WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
      return (MRESULT) TRUE;
    case UM_INITLS:
      bAllowClick = TRUE;
      break;
    case UM_SET_FOCUS:
      WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
      break;
    case UM_VALIDATE_DATA:
      if (!pstCOMiCFG->bPCIadapter)
        {
        /*
        **  validate base I/O address
        */
        WinQueryDlgItemText(hwndDlg,PCFG_BASE_ADDR,6,szBuffer);
        if (fDisplayBase == DISP_HEX)
          wNewAddress = ASCIItoBin(szBuffer,16);
        else
          wNewAddress = atoi(szBuffer);
        if (wNewAddress % 8)
          {
          sprintf(szString,"A device address space must start on an eight byte boundry (e.g., 300h, 3228h).  Please enter a different base address.");
          MessageBox(hwndDlg,szString);
          sprintf(szBuffer,"%X",wAddress);
          CheckButton(hwndDlg,PCFG_DISP_CHEX,TRUE);
          CheckButton(hwndDlg,PCFG_DISP_DEC,FALSE);
          fDisplayBase = DISP_HEX;
          WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
          pstPage->usFocusId = PCFG_BASE_ADDR;
          return((MRESULT)FALSE);
          }
        if (wNewAddress != wOldAddress)
          {
          /*
          ** either the user changed the address or a new device is to be defined
          */
          if (FindListWordItem(pAddressList,wNewAddress) != NULL)
            {
            // the new address is already in use
            if (fDisplayBase == DISP_HEX)
              sprintf(szString,"Device at address %Xh is already defined.  Please address a different device.",wNewAddress);
            else
              sprintf(szString,"Device at address %u is already defined.  Please address a different device.",wNewAddress);
            MessageBox(hwndDlg,szString);
            sprintf(szBuffer,"%X",wAddress);
            CheckButton(hwndDlg,PCFG_DISP_CHEX,TRUE);
            CheckButton(hwndDlg,PCFG_DISP_DEC,FALSE);
            fDisplayBase = DISP_HEX;
            WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
            pstPage->usFocusId = PCFG_BASE_ADDR;
            return((MRESULT)FALSE);
            }
          wOldAddress = wNewAddress;
          }
        /*
        ** validate interrupt level
        */
        if ((fIsMCAmachine != YES) && (pstCFGheader->byInterruptLevel == 0))
          {
          WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,SPBM_QUERYVALUE,&lTemp,MPFROM2SHORT(0,SPBQ_DONOTUPDATE));
          byTemp = (BYTE)lTemp;
          if (byTemp != byIntLevel)
            {
            if ((FindListByteItem(pLoadInterruptList,(byTemp | '\x80'))) != NULL)
              {
              if ((pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_MULTI_INT) == 0)
                {
                sprintf(szString,"Interrupt Level %u is already taken.  Please select a different Interrupt.",byTemp);
                MessageBox(hwndDlg,szString);
                WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
                                          SPBM_SETCURRENTVALUE,
                                  (MPARAM)byIntLevel,
                                          NULL);
                pstPage->usFocusId = PCFG_INT_LEVEL;
                return((MRESULT)FALSE);
                }
              }
            else
              {
              if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_MULTI_INT)
                byTemp |= '\x80';
              if ((FindListByteItem(pInterruptList,byTemp)) != NULL)
                {
                sprintf(szString,"Interrupt Level %u is already taken.  Please select a different Interrupt.",byTemp);
                MessageBox(hwndDlg,szString);
                WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
                                          SPBM_SETCURRENTVALUE,
                                  (MPARAM)byIntLevel,
                                          NULL);
                pstPage->usFocusId = PCFG_INT_LEVEL;
                return((MRESULT)FALSE);
                }
              }
            }
          }
        }
      return (MRESULT) TRUE;
    case UM_SAVE_DATA:
      if (!pstCOMiCFG->bPCIadapter)
        {
        /*
        **  get base I/O address
        */
        WinQueryDlgItemText(hwndDlg,PCFG_BASE_ADDR,6,szBuffer);
        if (fDisplayBase == DISP_HEX)
          wNewAddress = ASCIItoBin(szBuffer,16);
        else
          wNewAddress = atoi(szBuffer);
        if (wNewAddress % 8)
          {
          sprintf(szString,"A device address space must start on an eight byte boundry (e.g., 300h, 3228h).  Please enter a different base address.");
          MessageBox(hwndDlg,szString);
          sprintf(szBuffer,"%X",wAddress);
          CheckButton(hwndDlg,PCFG_DISP_CHEX,TRUE);
          CheckButton(hwndDlg,PCFG_DISP_DEC,FALSE);
          fDisplayBase = DISP_HEX;
          WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
          pstPage->usFocusId = PCFG_BASE_ADDR;
          return((MRESULT)FALSE);
          }
        if (wNewAddress != wOldAddress)
          {
          /*
          ** either the user changed the address or a new device is bring inserted
          */
          if (FindListWordItem(pAddressList,wNewAddress) != NULL)
            {
            // the new address is already in use
            if (fDisplayBase == DISP_HEX)
              sprintf(szString,"Device at address %Xh is already defined.  Please address a different device.",wNewAddress);
            else
              sprintf(szString,"Device at address %u is already defined.  Please address a different device.",wNewAddress);
            MessageBox(hwndDlg,szString);
            sprintf(szBuffer,"%X",wAddress);
            CheckButton(hwndDlg,PCFG_DISP_CHEX,TRUE);
            CheckButton(hwndDlg,PCFG_DISP_DEC,FALSE);
            fDisplayBase = DISP_HEX;
            WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
            pstPage->usFocusId = PCFG_BASE_ADDR;
            return((MRESULT)FALSE);
            }
          /*
          **  add new address to address lists
          */
          AddListItem(pLoadAddressList,&wNewAddress,2);
          AddListItem(pAddressList,&wNewAddress,2);
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
          wOldAddress = wNewAddress;
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
                if ((pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_MULTI_INT) == 0)
                  {
                  sprintf(szString,"Interrupt Level %u is already taken.  Please select a different Interrupt.",byTemp);
                  MessageBox(hwndDlg,szString);
                  WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
                                            SPBM_SETCURRENTVALUE,
                                    (MPARAM)byIntLevel,
                                            NULL);
                  pstPage->usFocusId = PCFG_INT_LEVEL;
                  return((MRESULT)FALSE);
                  }
                }
              else
                {
                if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_MULTI_INT)
                  byTemp |= '\x80';
                AddListItem(pLoadInterruptList,&byTemp,1);
                if ((FindListByteItem(pInterruptList,byTemp)) != NULL)
                  {
                  sprintf(szString,"Interrupt Level %u is already taken.  Please select a different Interrupt.",byTemp);
                  MessageBox(hwndDlg,szString);
                  WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
                                            SPBM_SETCURRENTVALUE,
                                    (MPARAM)byIntLevel,
                                            NULL);
                  pstPage->usFocusId = PCFG_INT_LEVEL;
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
          byLastIntLevel = byIntLevel;
          pstDCBheader->stComDCB.byInterruptLevel = byIntLevel;
          }
        }
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
        pstDCBheader->stComDCB.wConfigFlags1 |= CFG_FLAG1_COMSCOPE;
      else
        pstDCBheader->stComDCB.wConfigFlags1 &= ~CFG_FLAG1_COMSCOPE;
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
      if (!pstCOMiCFG->bPCIadapter)
        {
        pstDCBheader->stComDCB.wIObaseAddress = wNewAddress;
        wLastAddress = wNewAddress;
        pstDCBheader->stComDCB.byInterruptLevel = byLastIntLevel;
        sprintf(szDeviceDescription,szDeviceDescriptionFormat,szCurrentConfigDeviceName,wLastAddress,byLastIntLevel);
        }
      else
        sprintf(szDeviceDescription,szPCIdeviceDescriptionFormat,szCurrentConfigDeviceName);
      pstPage->bDirtyBit = FALSE;
      return (MRESULT) TRUE;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_INSERT:
           WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
           break;
        case DID_CANCEL:
          WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
          return(FALSE);
        case DID_HELP:
           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
           return(FALSE);
        case DID_UNDO:
          bAllowClick = FALSE;
          pstPage->bDirtyBit = FALSE;
          WinSendDlgItemMsg(hwndDlg,PCFG_NAME_LIST,LM_SELECTITEM,MPFROMSHORT(iOrgItemSelected),MPFROMSHORT(TRUE));
          if (!pstCOMiCFG->bPCIadapter)
            {
            sprintf(szBuffer,"%X",wAddress);
            CheckButton(hwndDlg,PCFG_DISP_CHEX,TRUE);
            CheckButton(hwndDlg,PCFG_DISP_DEC,FALSE);
            fDisplayBase = DISP_HEX;
            WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
            WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
                                      SPBM_SETCURRENTVALUE,
                              (MPARAM)byIntLevel,
                                      NULL);
            sprintf(szDeviceDescription,szDeviceDescriptionFormat,szCurrentConfigDeviceName,wLastAddress,byLastIntLevel);
            }
          else
            sprintf(szDeviceDescription,szPCIdeviceDescriptionFormat,szCurrentConfigDeviceName);
          if (bCOMscopeEnabled)
            CheckButton(hwndDlg,PCFG_ENA_COMSCOPE,TRUE);
          else
            CheckButton(hwndDlg,PCFG_ENA_COMSCOPE,FALSE);
          if (bSpoolEnabled)
            CheckButton(hwndDlg,PCFG_DEV_PDR,TRUE);
          else
            CheckButton(hwndDlg,PCFG_DEV_PDR,FALSE);
          bAllowClick = TRUE;
          return(FALSE);
        }
      break;
    case WM_CONTROL:
      switch (SHORT2FROMMP(mp1))
        {
        case  BN_CLICKED:
          if (bAllowClick)
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
  static WORD wConfigFlags1;
  static WORD wConfigFlags2;
//  static WORD wLoadFlags;
  static NBKPAGECTL *pstPage;
  static COMDCB *pstComDCB;
  char szMessage[100];
  char szCaption[60];

  switch (msg)
    {
    case WM_INITDLG:
      if (!bInsertNewDevice)
        WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
//        ControlEnable(hwndDlg,DID_INSERT,FALSE);
//      CenterDlgBox(hwndDlg);
//      WinSetFocus(HWND_DESKTOP,hwndDlg);
      bAllowClick = FALSE;
      pstPage = PVOIDFROMMP(mp2);
      pstPage->bDirtyBit = FALSE;
      pstComDCB = pstPage->pVoidPtrOne;
      pstCFGheader = pstPage->pVoidPtrTwo;
      wConfigFlags1 = pstComDCB->wConfigFlags1;
      wConfigFlags2 = pstComDCB->wConfigFlags2;
//      wLoadFlags = pstCFGheader->wLoadFlags;
      CheckButton(hwndDlg,PCFG_FOR_UART,(wConfigFlags1 & CFG_FLAG1_FOREIGN_UART));
      CheckButton(hwndDlg,PCFG_EXP_BAUD,(wConfigFlags1 & CFG_FLAG1_EXPLICIT_BAUD_DIVISOR));
      CheckButton(hwndDlg,PCFG_MDM_EXT,(wConfigFlags1 & CFG_FLAG1_EXT_MODEM_CTL));
      CheckButton(hwndDlg,PCFG_FORCE_4X_TEST,(wConfigFlags1 & CFG_FLAG1_FORCE_4X_TEST));
      CheckButton(hwndDlg,CB_ALLOW16750RTSCONTROL,(wConfigFlags2 & CFG_FLAG2_ALLOW16750RTSCTL));
      CheckButton(hwndDlg,CB_NOREPORTBRKWITHLINECHAR,(wConfigFlags1 & CFG_FLAG1_NO_BREAK_REPORT));
      CheckButton(hwndDlg,PCFG_EXT_4xBAUD,(wConfigFlags1 & CFG_FLAG1_NORMALIZE_BAUD));
      CheckButton(hwndDlg,PCFG_DIS_TEST,(wConfigFlags1 & CFG_FLAG1_TESTS_DISABLE));
      CheckButton(hwndDlg,PCFG_MDM_INT,(wConfigFlags1 & CFG_FLAG1_NO_MODEM_INT));
      if (pstCFGheader->byAdapterType == HDWTYPE_TWO)
        ControlEnable(hwndDlg,PCFG_EXT_TIB,FALSE);
      else
        CheckButton(hwndDlg,PCFG_EXT_TIB,(wConfigFlags1 & CFG_FLAG1_TIB_UART));
      CheckButton(hwndDlg,PCFG_OUT1,(wConfigFlags2 & CFG_FLAG2_ACTIVATE_OUT1));
      if ((pstCFGheader->byInterruptLevel == 0) &&
          (pstCFGheader->byAdapterType != HDWTYPE_PCI))
        {
        if (wConfigFlags1 & CFG_FLAG1_MULTI_INT)
          {
          CheckButton(hwndDlg,PCFG_EXT_SHARE_INT,TRUE);
          if(wConfigFlags1 & CFG_FLAG1_EXCLUSIVE_ACCESS)
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
    case UM_SET_FOCUS:
      WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
      break;
    case UM_SAVE_DATA:
      if (Checked(hwndDlg,PCFG_FOR_UART))
        wConfigFlags1 |= CFG_FLAG1_FOREIGN_UART;
      else
        wConfigFlags1 &= ~CFG_FLAG1_FOREIGN_UART;
      if (Checked(hwndDlg,PCFG_EXP_BAUD))
        wConfigFlags1 |= CFG_FLAG1_EXPLICIT_BAUD_DIVISOR;
      else
        wConfigFlags1 &= ~CFG_FLAG1_EXPLICIT_BAUD_DIVISOR;
      if (Checked(hwndDlg,PCFG_MDM_EXT))
        wConfigFlags1 |= CFG_FLAG1_EXT_MODEM_CTL;
      else
        wConfigFlags1 &= ~CFG_FLAG1_EXT_MODEM_CTL;
      if (Checked(hwndDlg,CB_NOREPORTBRKWITHLINECHAR))
        wConfigFlags1 |= CFG_FLAG1_NO_BREAK_REPORT;
      else
        wConfigFlags1 &= ~CFG_FLAG1_NO_BREAK_REPORT;
      if (Checked(hwndDlg,PCFG_FORCE_4X_TEST))
        wConfigFlags1 |=CFG_FLAG1_FORCE_4X_TEST;
      else
        wConfigFlags1 &= ~CFG_FLAG1_FORCE_4X_TEST;
      if (Checked(hwndDlg,CB_ALLOW16750RTSCONTROL))
        wConfigFlags2 |= CFG_FLAG2_ALLOW16750RTSCTL;
      else
        wConfigFlags2 &= ~CFG_FLAG2_ALLOW16750RTSCTL;
      if (Checked(hwndDlg,PCFG_EXT_4xBAUD))
        wConfigFlags1 |= CFG_FLAG1_NORMALIZE_BAUD;
      else
        wConfigFlags1 &= ~CFG_FLAG1_NORMALIZE_BAUD;
      if (Checked(hwndDlg,PCFG_DIS_TEST))
        wConfigFlags1 |= CFG_FLAG1_TESTS_DISABLE;
      else
        wConfigFlags1 &= ~CFG_FLAG1_TESTS_DISABLE;
      if (Checked(hwndDlg,PCFG_MDM_INT))
        wConfigFlags1 |= CFG_FLAG1_NO_MODEM_INT;
      else
        wConfigFlags1 &= ~CFG_FLAG1_NO_MODEM_INT;
      if (pstCFGheader->byAdapterType != HDWTYPE_TWO)
        if (Checked(hwndDlg,PCFG_EXT_TIB))
          wConfigFlags1 |= CFG_FLAG1_TIB_UART;
        else
          wConfigFlags1 &= ~CFG_FLAG1_TIB_UART;
      if (Checked(hwndDlg,PCFG_OUT1))
        wConfigFlags2 |= CFG_FLAG2_ACTIVATE_OUT1;
      else
        wConfigFlags2 &= ~CFG_FLAG2_ACTIVATE_OUT1;
      if (pstCFGheader->byInterruptLevel == 0)
        {
        if ((Checked(hwndDlg,PCFG_EXT_SHARE_INT)) &&
            (pstCFGheader->byAdapterType != HDWTYPE_PCI))
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
          wConfigFlags1 |= CFG_FLAG1_MULTI_INT;
          bShareAccessWarning = TRUE;
          if (Checked(hwndDlg,PCFG_EXT_EXCLUSIVE_INT))
            wConfigFlags1 |= CFG_FLAG1_EXCLUSIVE_ACCESS;
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
            wConfigFlags1 &= ~CFG_FLAG1_EXCLUSIVE_ACCESS;
            bNonExAccessWarning = TRUE;
            }
          }
        else
          wConfigFlags1 &= ~(CFG_FLAG1_EXCLUSIVE_ACCESS | CFG_FLAG1_MULTI_INT);
        }
      pstComDCB->wConfigFlags1 = wConfigFlags1;
      pstComDCB->wConfigFlags2 = wConfigFlags2;
//      pstCFGheader->wLoadFlags = wLoadFlags;
      return (MRESULT) TRUE;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case DID_INSERT:
           WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
           break;
        case DID_CANCEL:
          WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
          return(FALSE);
        case DID_HELP:
          WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
          return(FALSE);
        case DID_UNDO:
          bAllowClick = FALSE;
          pstPage->bDirtyBit = FALSE;
          CheckButton(hwndDlg,PCFG_FOR_UART,(wConfigFlags1 & CFG_FLAG1_FOREIGN_UART));
          CheckButton(hwndDlg,PCFG_EXP_BAUD,(wConfigFlags1 & CFG_FLAG1_EXPLICIT_BAUD_DIVISOR));
          CheckButton(hwndDlg,PCFG_MDM_EXT,(wConfigFlags1 & CFG_FLAG1_EXT_MODEM_CTL));
          CheckButton(hwndDlg,PCFG_FORCE_4X_TEST,(wConfigFlags1 & CFG_FLAG1_FORCE_4X_TEST));
          CheckButton(hwndDlg,CB_ALLOW16750RTSCONTROL,(wConfigFlags2 & CFG_FLAG2_ALLOW16750RTSCTL));
          CheckButton(hwndDlg,CB_NOREPORTBRKWITHLINECHAR,(wConfigFlags1 & CFG_FLAG1_NO_BREAK_REPORT));
          CheckButton(hwndDlg,PCFG_EXT_4xBAUD,(wConfigFlags1 & CFG_FLAG1_NORMALIZE_BAUD));
          CheckButton(hwndDlg,PCFG_DIS_TEST,(wConfigFlags1 & CFG_FLAG1_TESTS_DISABLE));
          CheckButton(hwndDlg,PCFG_MDM_INT,(wConfigFlags1 & CFG_FLAG1_NO_MODEM_INT));
          if (pstCFGheader->byAdapterType != HDWTYPE_TWO)
            CheckButton(hwndDlg,PCFG_EXT_TIB,(wConfigFlags1 & CFG_FLAG1_TIB_UART));
          CheckButton(hwndDlg,PCFG_OUT1,(wConfigFlags2 & CFG_FLAG2_ACTIVATE_OUT1));
          if (pstCFGheader->byInterruptLevel == 0)
            {
            if (wConfigFlags1 & CFG_FLAG1_MULTI_INT)
              {
              CheckButton(hwndDlg,PCFG_EXT_SHARE_INT,TRUE);
              if(wConfigFlags1 & CFG_FLAG1_EXCLUSIVE_ACCESS)
                CheckButton(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
              }
            else
              CheckButton(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
            }
          else
            CheckButton(hwndDlg,PCFG_EXT_SHARE_INT,TRUE);
          bAllowClick = TRUE;
          return(FALSE);
        }
      break;
    case WM_CONTROL:
      if (SHORT2FROMMP(mp1) == BN_CLICKED)
        {
        pstPage->bDirtyBit = TRUE;
        if (bAllowClick)
          {
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

