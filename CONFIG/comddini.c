#include "COMMON.H"
#include "COMDD.H"
#include "ioctl.h"
#include "utility.h"
#include "spool.h"
#include "help.h"

#include "COMi_CFG.H"
#include "resource.h"

ULONG ulCOMiSignature = 0;

char szConfigHelpFile[CCHMAXPATH];
HWND hwndHelpInstance;
WORD wDDmaxDeviceCount = 0;

ULONG adwClassCodeTable[] = {PCI_CLASSCODE_GENERIC_SERIAL,
                             PCI_CLASSCODE_SERIAL_16450,  
                             PCI_CLASSCODE_SERIAL_16550,  
                             PCI_CLASSCODE_SERIAL_16650,  
                             PCI_CLASSCODE_SERIAL_16750,  
                             PCI_CLASSCODE_SERIAL_16850,  
                             PCI_CLASSCODE_SERIAL_16950,  
                             PCI_CLASSCODE_MOXA, 
                             PCI_CLASSCODE_MULTIPORT,     
                             PCI_CLASSCODE_GENERIC_MODEM, 
                             PCI_CLASSCODE_16450_MODEM,   
                             PCI_CLASSCODE_16550_MODEM,   
                             PCI_CLASSCODE_16650_MODEM,   
                             PCI_CLASSCODE_16750_MODEM,   
                             PCI_CLASSCODE_16850_MODEM,   
                             PCI_CLASSCODE_16950_MODEM,
                             PCI_CLASSCODE_OTHER,
                             0};

#if DEBUG > 0
char szMessage[200];
BOOL bNoDEBUGhelp = FALSE;
#endif

MRESULT EXPENTRY fnwpPortSimpleDlgProc(HWND hwndDlg,ULONG msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpHdwFIFOsetupDlg(HWND hwndDlg,ULONG msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpPortConfigDlgProc(HWND hwndDlg,ULONG msg,MPARAM mp1,MPARAM mp2);

APIRET GetDriverInfo(void);

ULONG ReadConfigSys(HFILE *phFile,char **ppBuffer);
ULONG FindLineWith(char szThisString[],char *pszBuffer,ULONG ulOffset,ULONG *pulLength);

char szDriverIniPath[CCHMAXPATH];
char szPDRlibrarySpec[CCHMAXPATH];
extern CFGHEAD stGlobalCFGheader;
  
USHORT fIsMCAmachine;
extern LINKLIST *pAddressList;
extern LINKLIST *pInterruptList;

char szTempFilePath[CCHMAXPATH];

BOOL bCOMiLoaded = FALSE;

char szDriverVersionString[100];
ULONG ulDriverSignature;

DEVLIST astConfigDeviceList[] = {{"COM0",FALSE},
                                 {"COM1",TRUE},{"COM2",TRUE},{"COM3",TRUE},{"COM4",TRUE},{"COM5",TRUE},
                                 {"COM6",TRUE},{"COM7",TRUE},{"COM8",TRUE},{"COM9",TRUE},{"COM10",TRUE},
                                 {"COM11",TRUE},{"COM12",TRUE},{"COM13",TRUE},{"COM14",TRUE},{"COM15",TRUE},
                                 {"COM16",TRUE},{"COM17",TRUE},{"COM18",TRUE},{"COM19",TRUE},{"COM20",TRUE},
                                 {"COM21",TRUE},{"COM22",TRUE},{"COM23",TRUE},{"COM24",TRUE},{"COM25",TRUE},
                                 {"COM26",TRUE},{"COM27",TRUE},{"COM28",TRUE},{"COM29",TRUE},{"COM30",TRUE},
                                 {"COM31",TRUE},{"COM32",TRUE},{"COM33",TRUE},{"COM34",TRUE},{"COM35",TRUE},
                                 {"COM36",TRUE},{"COM37",TRUE},{"COM38",TRUE},{"COM39",TRUE},{"COM40",TRUE},
                                 {"COM41",TRUE},{"COM42",TRUE},{"COM43",TRUE},{"COM44",TRUE},{"COM45",TRUE},
                                 {"COM46",TRUE},{"COM47",TRUE},{"COM48",TRUE},{"COM49",TRUE},{"COM50",TRUE},
                                 {"COM51",TRUE},{"COM52",TRUE},{"COM53",TRUE},{"COM54",TRUE},{"COM55",TRUE},
                                 {"COM56",TRUE},{"COM57",TRUE},{"COM58",TRUE},{"COM59",TRUE},{"COM60",TRUE},
                                 {"COM61",TRUE},{"COM62",TRUE},{"COM63",TRUE},{"COM64",TRUE},{"COM65",TRUE},
                                 {"COM66",TRUE},{"COM67",TRUE},{"COM68",TRUE},{"COM69",TRUE},{"COM70",TRUE},
                                 {"COM71",TRUE},{"COM72",TRUE},{"COM73",TRUE},{"COM74",TRUE},{"COM75",TRUE},
                                 {"COM76",TRUE},{"COM77",TRUE},{"COM78",TRUE},{"COM79",TRUE},{"COM80",TRUE},
                                 {"COM81",TRUE},{"COM82",TRUE},{"COM83",TRUE},{"COM84",TRUE},{"COM85",TRUE},
                                 {"COM86",TRUE},{"COM87",TRUE},{"COM88",TRUE},{"COM89",TRUE},{"COM90",TRUE},
                                 {"COM91",TRUE},{"COM92",TRUE},{"COM93",TRUE},{"COM94",TRUE},{"COM95",TRUE},
                                 {"COM96",TRUE},{"COM97",TRUE},{"COM98",TRUE},{"COM99",TRUE},{"COM100",FALSE}};
extern char szLastName[];

BYTE byDDOEMtype;
BOOL bLimitLoad = FALSE;

char szOEMname[80];

BOOL bPDRinstalled = FALSE;

LONG lYbutton;
LONG lXbutton;
LONG lXScr;
LONG lYScr;

int iPCIadapters = 0;
BOOL bPCImachine = FALSE;
BYTE xSubFunction;
PCIADPT astPCIadapters[MAX_PCI_ADAPTERS];

BOOL bDeviceIniFileSelected = FALSE;

BOOL bWarp4 = TRUE;

OSVER stOSversion;

HMODULE hThisModule;

BOOL bSpoolSetupInUse = FALSE;
BOOL bInstallInUse = FALSE;

#ifdef __BORLANDC__
ULONG _dllmain(ULONG ulTermCode,HMODULE hMod)
#else
int _CRT_init(void);

ULONG _System _DLL_InitTerm(HMODULE hMod,ULONG ulTermCode)
#endif
  {
  if (ulTermCode == 0)
    {
#ifndef __BORLANDC__
    if (_CRT_init() == -1)
       return(FALSE);
#endif
    hThisModule = hMod;
    bCOMiLoaded = GetDriverInfo();
    lXScr  = WinQuerySysValue(HWND_DESKTOP,SV_CXSCREEN);
    if (lXScr > 640)
      if (lXScr > 800)
//        if (lXScr > 1024)
          if (lXScr > 1152)
            if (lXScr > 1280)
              lXbutton = (lXScr / 19);// 1600/1200
            else
              lXbutton = (lXScr / 17);// 1280/1024
          else
            lXbutton = (lXScr / 14);  // 1152/864
        else
          lXbutton = (lXScr / 12);    // 1024/768 and 800/600
//      else
//        lXbutton = (lXScr / 12);      // 800/600
    else
      lXbutton = (lXScr / 10);        // 640/480

    lYScr  = WinQuerySysValue(HWND_DESKTOP,SV_CYSCREEN);
    if (lYScr > 480)
      if (lYScr > 600)
//        if (lYScr > 768)
          if (lYScr > 864)
            if (lYScr > 1024)
              lYbutton = (lYScr / 16);// 1600/1200
            else
              lYbutton = (lYScr / 14);// 1280/1024
          else
            lYbutton = (lYScr / 11);  // 1152/864
        else
          lYbutton = (lYScr / 9);     // 1024/768 and 800/600
//      else
//        lYbutton = (lYScr / 9);       // 800/600
    else
      lYbutton = (lYScr / 7);         // 640/480

    if (PrfQueryProfileString(HINI_SYSTEMPROFILE,"PM_PORT_DRIVER","COMI_SPL",NULL,(PSZ)szPDRlibrarySpec,CCHMAXPATH) == 0)
      PrfQueryProfileString(HINI_SYSTEMPROFILE,"PM_PORT_DRIVER","SPL_DEMO",NULL,(PSZ)szPDRlibrarySpec,CCHMAXPATH);
    }
  bSpoolSetupInUse = FALSE;
  bInstallInUse = FALSE;
  return(TRUE);
  }

BOOL GetPCIadapterInfo(HFILE hFile,PCIADPT *pstAdapter, PCID_DEVICE *pstDevice, int iIndex)
  {
  ULONG ulDataLen;
  ULONG ulParmLen;
  PCID_CONFIG stConfigData;
  PCIP_CONFIG stConfigParm;

  pstAdapter->xDevFuncNum = pstDevice->xDevFuncNum;
  pstAdapter->xBusNum = pstDevice->xBusNum;
  pstAdapter->xIndex = (BYTE)iIndex;
  stConfigParm.xSubFunc = OEMHLP_PCI_GET_DATA;
  stConfigParm.xDevFuncNum = pstDevice->xDevFuncNum;
  stConfigParm.xBusNum = pstDevice->xBusNum;
  stConfigParm.xConfigReg = PCICFG_VEN_DEV_REG;
  stConfigParm.xSize = 4;
  // get device and vendor IDs
  DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
  if (stConfigData.xReturnCode != 0)
    return(FALSE);
  pstAdapter->usVendorID = (USHORT)stConfigData.ulData;
  pstAdapter->usDeviceID = (USHORT)(stConfigData.ulData >> 16);
  // get IRQ
  stConfigParm.xConfigReg = PCICFG_IRQ_REG;
  DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
  pstAdapter->xIRQ = (BYTE)stConfigData.ulData;
  stConfigParm.xConfigReg = PCICFG_BASEADDR_REG;
  // get base address 0 through 5
  DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
  pstAdapter->usBaseAddress0 = (USHORT)stConfigData.ulData;
  stConfigParm.xConfigReg += 4;
  DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
  pstAdapter->usBaseAddress1 = (USHORT)stConfigData.ulData;
  stConfigParm.xConfigReg += 4;
  DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
  pstAdapter->usBaseAddress2 = (USHORT)stConfigData.ulData;
  stConfigParm.xConfigReg += 4;
  DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
  pstAdapter->usBaseAddress3 = (USHORT)stConfigData.ulData;
  stConfigParm.xConfigReg += 4;
  DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
  pstAdapter->usBaseAddress4 = (USHORT)stConfigData.ulData;
  stConfigParm.xConfigReg += 4;
  DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
  pstAdapter->usBaseAddress5 = (USHORT)stConfigData.ulData;
  return(TRUE);
  }

BOOL EXPENTRY InstallDevice(COMICFG *pstCOMiCFG)
  {
  ULONG ulStatus;
  CHAR szMsgString[200];
  CHAR szCaption[80];
  HFILE hFile;
  CFGINFO stConfigInfo;
  DCBPOS stDCBposition;
  ULONG ulAction;
  ULONG ulDataLen;
  ULONG ulParmLen;
  ULONG idDlg;
  PFNWP pfnwpDlgProc;
  BOOL bSuccess = TRUE;
//  HWND hwndSaveHelp;
  ULONG ulCount;
  APIRET rc;
  CFGHEAD stCFGheader;
  DCBPOS stHeaderPos;
  int iIndex;
  ULONG ulTemp;
  int iPCIindex;
  int iClassCodeIndex;
  BOOL bDone;

  PCID_BIOSINFO stBIOSinfo;
  PCID_DEVICE stDeviceData;
  PCIP_DEVICE stDeviceParm;
  PCIP_CLASSCODE stClassCodeParm;

  if (bInstallInUse)
    {
    MessageBox(HWND_DESKTOP,"The COMi Configurartion Library Install Device function is currently being accessed by another process.\n\nTry again later.");
    return(FALSE);
    }
  bInstallInUse = TRUE;
#if DEBUG > 0
  bNoDEBUGhelp = TRUE;
#endif
  HelpInit(pstCOMiCFG);

  if (pstCOMiCFG->pszDriverIniSpec == NULL)
    {
    if (szDriverIniPath[0] == 0)
      {
      if (PrfQueryProfileString(HINI_USERPROFILE,"COMi","Initialization",NULL,(PSZ)szDriverIniPath,CCHMAXPATH) == 0)
        {
        sprintf(szMsgString,"\nYou will need to specify a device driver initialization path and file name.");
        sprintf(szCaption,"Unknown Configuration File Name");
        WinMessageBox(HWND_DESKTOP,
                      HWND_DESKTOP,
                          szMsgString,
                          szCaption,
                          HLPP_MB_NO_INI_FILENAME,
                          MB_OK | MB_HELP | MB_INFORMATION);
        sprintf(szDriverIniPath,"COMDD.INI");
        if (!GetFileName(HWND_DESKTOP,szDriverIniPath,"Specify Initialization File to Create.",0))
          {
          if (pstCOMiCFG->pszPortName == NULL)
            sprintf(szMsgString,"Installation Has Been Aborted");
          else
            sprintf(szMsgString,"Installation of %s Has Been Aborted",pstCOMiCFG->pszPortName);
          MessageBox(HWND_DESKTOP,szMsgString);
          DestroyHelpInstance(pstCOMiCFG);
          bInstallInUse = FALSE;
          return(FALSE);
          }
        strcpy(szTempFilePath,szDriverIniPath);
        AppendTMP(szTempFilePath);
        }
      }
    }
  else
    strcpy(szDriverIniPath,pstCOMiCFG->pszDriverIniSpec);

  DosQuerySysInfo(QSV_VERSION_MAJOR,QSV_VERSION_REVISION,&stOSversion,sizeof(OSVER));
  if ((stOSversion.ulMajor < 20) || (stOSversion.ulMinor <= 30))
    bWarp4 = FALSE;

#if DEBUG > 0
sprintf(szMsgString,"Version is %d.%d", stOSversion.ulMajor, stOSversion.ulMinor);
MessageBox(HWND_DESKTOP, szMsgString);
#endif

//  if (bWarp4)
    {
    if (DosOpen("OEMHLP$",&hFile,&ulAction,0L,0L,0x0001,0x21c2,0L) == NO_ERROR)
      {
      ulTemp = OEMHLP_GET_PCI_BIOS_INFO;
      if ((DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&ulTemp,1,&ulParmLen,(PVOID)&stBIOSinfo,sizeof(PCID_BIOSINFO),&ulDataLen) == NO_ERROR) &&
          (stBIOSinfo.xReturnCode == 0))
        {
        bPCImachine = TRUE;
        if (bWarp4)
          {
          stClassCodeParm.xSubFunc = OEMHLP_PCI_CLASSCODE;
          iClassCodeIndex = 0;
          bDone = FALSE;
          while ((adwClassCodeTable[iClassCodeIndex] != 0) && !bDone)
            {
            stClassCodeParm.ulClassCode = adwClassCodeTable[iClassCodeIndex];
            for (iPCIindex = 0;iPCIindex < MAX_PCI_ADAPTERS; iPCIindex++)
              {
              stClassCodeParm.xIndex = (BYTE)iPCIindex;
              if ((DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stClassCodeParm,sizeof(PCIP_CLASSCODE),&ulParmLen,(PVOID)&stDeviceData,sizeof(PCID_DEVICE),&ulDataLen) != NO_ERROR) ||
                  (stDeviceData.xReturnCode != 0))
                break;
              if (!GetPCIadapterInfo(hFile,&astPCIadapters[iPCIadapters],&stDeviceData,iPCIindex))
                {
                bDone = TRUE;
                break;
                }
              if (++iPCIadapters == MAX_PCI_ADAPTERS)
                {
                bDone = TRUE;
                break;
                }
              }
            iClassCodeIndex++;
            }
          }
        }
      DosClose(hFile);
      }
    }

  fIsMCAmachine = NO;
  if (!bPCImachine)
    {
    if (DosOpen("TESTCFG$",&hFile,&ulAction,0L,0L,0x0001,0x21c2,0L) == NO_ERROR)
      {
      ulAction = 0;
      ulDataLen = 4L;
      ulParmLen = 4L;
      if (DosDevIOCtl(hFile,0x80,0x60,(PVOID)&ulAction,ulParmLen,&ulParmLen,(PVOID)&ulAction,ulDataLen,&ulDataLen) == NO_ERROR)
        {
        if (ulAction == 1)
          fIsMCAmachine = YES;
        }
      else
        fIsMCAmachine = 0xffff;
      DosClose(hFile);
      }
    else
      fIsMCAmachine = 0xffff;
    if (fIsMCAmachine == 0xffff)
      {
      fIsMCAmachine = NO;
      sprintf(szCaption,"Unable to open or access TESTCFG");
      sprintf(szMsgString,"Is this a Micro Channel machine (IBM PS/2 or compatable)?");
      if (WinMessageBox(HWND_DESKTOP,
                        HWND_DESKTOP,
                        szMsgString,
                        szCaption,
                        HLPP_MB_NO_TESTCFG,
                        (MB_MOVEABLE | MB_HELP | MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON2)) == MBID_YES)

        fIsMCAmachine = YES;
      }
    }
  if (strlen(szDriverIniPath) == 0)
    {
    MessageBox(HWND_DESKTOP,"Invalid device driver initialization file specification");
    bSuccess = FALSE;
    }
  else
    {
    stDCBposition.wDCBnumber = 0;
    stDCBposition.wLoadNumber = 0;
    while (DosOpen(szDriverIniPath,&hFile,&ulStatus,0L,0,0x0001,0x1312,(PEAOP2)0L) != NO_ERROR)
      {
      if (AddIniConfigHeader(szDriverIniPath,&stDCBposition) == 0)
        {
        DestroyHelpInstance(pstCOMiCFG);
        bInstallInUse = FALSE;
        return(FALSE);
        }
      }
    if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == NO_ERROR)
      {
      DosClose(hFile);
      if (stConfigInfo.ulSignature != INI_FILE_SIGNATURE)
        {
        DosDelete(szDriverIniPath);
        if (AddIniConfigHeader(szDriverIniPath,&stDCBposition) == 0)
         {
          DestroyHelpInstance(pstCOMiCFG);
          bInstallInUse = FALSE;
          return(FALSE);
          }
        }
      }
    else
      {
      DosClose(hFile);
      DosDelete(szDriverIniPath);
      if (AddIniConfigHeader(szDriverIniPath,&stDCBposition) == 0)
        {
        DestroyHelpInstance(pstCOMiCFG);
        bInstallInUse = FALSE;
        return(FALSE);
        }
      }
    DosCopy(szDriverIniPath,szTempFilePath,0x00000001);

    lXScr = WinQuerySysValue(HWND_DESKTOP,SV_CXSCREEN);

    if (wDDmaxDeviceCount != 0)
      pstCOMiCFG->ulMaxDeviceCount = wDDmaxDeviceCount;
    stHeaderPos.wLoadNumber = 1;
    if (QueryIniCFGheader(szDriverIniPath,&stCFGheader,&stHeaderPos))
      memcpy(&stGlobalCFGheader,&stCFGheader,sizeof(CFGHEAD));
    else
      if (AddIniConfigHeader(szDriverIniPath,&stHeaderPos) == 0)
        {
        DestroyHelpInstance(pstCOMiCFG);
        bInstallInUse = FALSE;
        return(FALSE);
        }
    if (stCFGheader.byAdapterType == HDWTYPE_PCI)
      pstCOMiCFG->bPCIadapter = TRUE;
    else
      pstCOMiCFG->bPCIadapter = FALSE;
    if (((stCFGheader.wLoadFlags & LOAD_FLAG1_ADVANCED_CFG) == 0) || (stCFGheader.wDeviceCount == 0))
      {
      pfnwpDlgProc = fnwpPortSimpleDlgProc;
      if (fIsMCAmachine)
        idDlg = MCA_SIMPLE_DLG;
      else
        if (bPCImachine)
          idDlg = DLG_SIMPLIFIEDDEV;
        else  
          idDlg = ISA_SIMPLE_DLG;
      }
    else
      {
      pfnwpDlgProc = fnwpPortConfigDlgProc;
      if (pstCOMiCFG->byOEMtype != OEM_OTHER)
        idDlg = DLG_ADVANCEDOEM;
      else
        if (fIsMCAmachine)
          idDlg = PCFG_MAIN_MCA;
        else
          idDlg = PCFG_MAIN;
      }
    if (pstCOMiCFG->byOEMtype != 0)
      byDDOEMtype = pstCOMiCFG->byOEMtype;

    if ((rc = WinDlgBox(HWND_DESKTOP,
                  pstCOMiCFG->hwndFrame,
           (PFNWP)pfnwpDlgProc,
                  hThisModule,
                  idDlg,
                  MPFROMP(pstCOMiCFG))) == FALSE)
      {
      DosCopy(szTempFilePath,szDriverIniPath,0x00000001);
      bSuccess = FALSE;
      }
#if DEBUG > 0
    if (rc == DID_ERROR)
      {
      ERRORID idErr;

      idErr = WinGetLastError(pstCOMiCFG->hab);
      }
#endif
    }
  DosDelete(szTempFilePath);
  DestroyHelpInstance(pstCOMiCFG);
  bInstallInUse = FALSE;
  return(bSuccess);
  }

void InitializeCFGheader(CFGHEAD *pstConfigHeader)
  {
  memset(pstConfigHeader, 0, sizeof(CFGHEAD));
  pstConfigHeader->bHeaderIsInitialized = TRUE;
  pstConfigHeader->bHeaderIsAvailable = FALSE;
  pstConfigHeader->wDCBcount = 8;
  pstConfigHeader->byAdapterType = HDWTYPE_NONE;
  }

void InitializeDCBheader(DCBHEAD *pstDCBheader,BOOL bInstallCOMscope)
  {
//  memset(pstDCBheader, 0, sizeof(DCBHEAD));
  memset(&pstDCBheader->stComDCB,0,sizeof(COMDCB));
  pstDCBheader->stComDCB.byXonChar = '\x11';
  pstDCBheader->stComDCB.byXoffChar = '\x13';
  pstDCBheader->stComDCB.wWrtTimeout = 6000;
  pstDCBheader->stComDCB.wRdTimeout = 4500;
  pstDCBheader->stComDCB.wFlags1 = (0x8000 | F1_DEFAULT);
  pstDCBheader->stComDCB.wFlags2 = (0x8000 | F2_DEFAULT);
  pstDCBheader->stComDCB.wFlags3 = (0x8000 | F3_DEFAULT);
  pstDCBheader->stComDCB.ulBaudRate = 9600;
  pstDCBheader->stComDCB.byLineCharacteristics = '\x03';
  if (bInstallCOMscope)
    pstDCBheader->stComDCB.wConfigFlags1 |= CFG_FLAG1_COMSCOPE;
  else
    pstDCBheader->stComDCB.wConfigFlags1 = 0;
  pstDCBheader->stComDCB.wConfigFlags2 = 0;
  memset(pstDCBheader->abyPortName,' ',8);
  pstDCBheader->bHeaderIsInitialized = FALSE;
  }

int AddIniConfigHeader(char szFileSpec[],DCBPOS *pstDCBposition)
  {
  ULONG ulStatus;
  HFILE hFile;
  int iIndex;
  ULONG ulCount;
  int iDCBindex;
  USHORT oSaveDCBheader;
  USHORT oSaveCFGheader;
  ULONG ulFilePosition;
  ULONG ulSaveConfigHeaderPosition;
  FILESTATUS3 stFileInfo;
  CFGINFO stConfigInfo;
  CFGHEAD stConfigHeader;
  DCBHEAD stDCBheader;
  BOOL bEarlyHeader = FALSE;
  BOOL bInitializeInfoHeader = FALSE;
  char szMessage[100];

  if (DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,0x11,0x1312,(PEAOP2)0L) == NO_ERROR)
    {
    DosQueryFileInfo(hFile,1,&stFileInfo,sizeof(FILESTATUS3));
    if (stFileInfo.cbFile < (sizeof(CFGINFO) + sizeof(CFGHEAD) + (sizeof(DCBHEAD) * 8)))
      bInitializeInfoHeader = TRUE;
    else
      {
      DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount);
      if (stConfigInfo.ulSignature != INI_FILE_SIGNATURE)
        bInitializeInfoHeader = TRUE;
      }
    if (bInitializeInfoHeader)
      {
      memset(&stConfigInfo,0,sizeof(CFGINFO));
      stConfigInfo.byOEMtype = OEM_OTHER;
      stConfigInfo.byNextPCIslot = 0;
      stConfigInfo.wCFGheaderCount = 1;
      stConfigInfo.oFirstCFGheader = sizeof(CFGINFO);
      stConfigInfo.oCOMscopeIniOffset = 0;
      stConfigInfo.ulSignature = INI_FILE_SIGNATURE;
      InitializeCFGheader(&stConfigHeader);
      stConfigHeader.oFirstDCBheader = (sizeof(CFGINFO) + sizeof(CFGHEAD));
      stConfigHeader.oNextCFGheader = (stConfigHeader.oFirstDCBheader + (sizeof(DCBHEAD) * MAX_CFG_DEVICE));
      ulSaveConfigHeaderPosition = sizeof(CFGINFO);
      }
    else
      {
      DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
      if (stConfigInfo.wCFGheaderCount == 0)
        {
        stConfigHeader.oFirstDCBheader = (sizeof(CFGINFO) + sizeof(CFGHEAD));
        stConfigHeader.oNextCFGheader = (stConfigHeader.oFirstDCBheader + (sizeof(DCBHEAD) * MAX_CFG_DEVICE));
        ulSaveConfigHeaderPosition = sizeof(CFGHEAD);
        }
      else
        {
        for (iIndex = 1;iIndex <= stConfigInfo.wCFGheaderCount;iIndex++)
          {
          ulSaveConfigHeaderPosition = ulFilePosition;
          DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
          if (!stConfigHeader.bHeaderIsInitialized)
            {
            bEarlyHeader = TRUE;
            break;
            }
          DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
          }
        }
      if (!bEarlyHeader)
        {
        if (stConfigHeader.oNextCFGheader == ulSaveConfigHeaderPosition)
          // this is to provide upward compatibility for the old system that had the last header point to itself
          stConfigHeader.oNextCFGheader += (sizeof(CFGHEAD) + (sizeof(DCBHEAD) * MAX_CFG_DEVICE));
        ulSaveConfigHeaderPosition = stConfigHeader.oNextCFGheader;
        oSaveDCBheader = (stConfigHeader.oNextCFGheader + sizeof(CFGHEAD));
        oSaveCFGheader = (oSaveDCBheader + (sizeof(DCBHEAD) * MAX_CFG_DEVICE));
        stConfigInfo.wCFGheaderCount++;
        }
      else
        {
        oSaveDCBheader = stConfigHeader.oFirstDCBheader;
        oSaveCFGheader = stConfigHeader.oNextCFGheader;
        }
      InitializeCFGheader(&stConfigHeader);
      stConfigHeader.oFirstDCBheader = oSaveDCBheader;
      stConfigHeader.oNextCFGheader = oSaveCFGheader;
      pstDCBposition->wLoadNumber = iIndex;
      }
    DosChgFilePtr(hFile,0L,0,&ulFilePosition);
    DosWrite(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount);
    DosChgFilePtr(hFile,ulSaveConfigHeaderPosition,0,&ulFilePosition);
    DosWrite(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
    DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
    InitializeDCBheader(&stDCBheader,FALSE);
    stDCBheader.oNextDCBheader = stConfigHeader.oFirstDCBheader;
    for (iDCBindex = 0;iDCBindex < MAX_CFG_DEVICE;iDCBindex++)
      {
      stDCBheader.oNextDCBheader += sizeof(DCBHEAD);
      DosWrite(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
      }
    if (!bEarlyHeader)
      DosSetFileSize(hFile,stDCBheader.oNextDCBheader);
    DosClose(hFile);
    return(iIndex);
    }
  else
    {
    sprintf(szMessage,"Unable to open or create the COMi initialization file %s",szFileSpec);
    MessageBox(HWND_DESKTOP,szMessage);
    }
  pstDCBposition->wDCBnumber = 0;
  return(0);
  }

DCBPOS FillDeviceLists(char szDriverIniSpec[],LINKLIST *pstAddressList,LINKLIST *pstInterruptList)
  {
  ULONG ulAction;
  HFILE hFile;
  WORD iIndex;
  int iDCBindex;
  ULONG ulCount;
  CFGINFO stConfigInfo;
  CFGHEAD stConfigHeader;
  DCBHEAD stDCBheader;
  ULONG ulFilePosition;
  char szString[9];
  DCBPOS stCount;
  BOOL bPCIadapter = TRUE;

  while (DosOpen(szDriverIniSpec,&hFile,&ulAction,0L,0,1,0x1312,(PEAOP2)0L) != NO_ERROR)
    if (AddIniConfigHeader(szDriverIniSpec,&stCount) == 0)
      return(stCount);
  stCount.wLoadNumber = 0;
  stCount.wDCBnumber = 0;
  if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == NO_ERROR)
    {
    if (stConfigInfo.wCFGheaderCount != 0)
      {
      DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
      for (iIndex = 1;iIndex <= stConfigInfo.wCFGheaderCount;iIndex++)
        {
        if (DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount) == NO_ERROR)
          {
          if (!stConfigHeader.bHeaderIsInitialized)
            {
            DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
            continue;
            }
          stCount.wLoadNumber++;
          if (stConfigHeader.byAdapterType != HDWTYPE_PCI)
            {
            bPCIadapter = FALSE;
            if (stConfigHeader.byInterruptLevel != 0)
              AddListItem(pstInterruptList,&(stConfigHeader.byInterruptLevel),1);
            }
          DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
          for (iDCBindex = 1;iDCBindex <= stConfigHeader.wDCBcount;iDCBindex++)
            {
            if (DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount) == 0)
              {
              if (stDCBheader.bHeaderIsInitialized)
                {
                stCount.wDCBnumber++;
                if (!bPCIadapter)
                  {
                  if (stConfigHeader.byInterruptLevel == 0)
                    AddListItem(pstInterruptList,&(stDCBheader.stComDCB.byInterruptLevel),1);
                  if (stDCBheader.stComDCB.wIObaseAddress != 0xffff)
                    AddListItem(pstAddressList,&(stDCBheader.stComDCB.wIObaseAddress),2);
                  }
                strncpy(szString,stDCBheader.abyPortName,8);
                RemoveSpaces(szString);
                astConfigDeviceList[atoi(&szString[DEV_NUM_INDEX])].bAvailable = FALSE;
                }
              }
            DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
            }
          }
        DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
        }
      }
    }
  DosClose(hFile);
  return(stCount);
  }

APIRET EXPENTRY FillDeviceNameList(COMICFG *pstCOMiCFG)
  {
  ULONG ulStatus;
  HFILE hFile;
  int iIndex;
  int iDCBindex;
  ULONG ulCount;
  CFGINFO stConfigInfo;
  CFGHEAD stConfigHeader;
  DCBHEAD stDCBheader;
  ULONG ulFilePosition;
  char szString[10];
  char szTemp[10];
  HFILE hCom;
  ULONG ulAction;
  char *pDeviceList;
  int iCOMscopeAvail = 0;
  BOOL bCountOnly = FALSE;
  char szDriverIniSpec[CCHMAXPATH];

  pstCOMiCFG->iLoadCount = 0;
  pstCOMiCFG->iDeviceCount = 0;
  if (pstCOMiCFG->cbDevList == 0)
    bCountOnly = TRUE;
  if (pstCOMiCFG->pszDriverIniSpec != NULL)
    strcpy(szDriverIniSpec,pstCOMiCFG->pszDriverIniSpec);
  else
    strcpy(szDriverIniSpec,szDriverIniPath);
  if (DosOpen(szDriverIniSpec,&hFile,&ulStatus,0L,0,1,0x1312,(PEAOP2)0L) != 0)
    return(FALSE);
  if (!bCountOnly)
    pDeviceList = pstCOMiCFG->pDeviceList;
  if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
    {
    if (stConfigInfo.wCFGheaderCount != 0)
      {
      DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
      for (iIndex = 1;iIndex <= stConfigInfo.wCFGheaderCount;iIndex++)
        {
        if (DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount) == 0)
          {
          if (!stConfigHeader.bHeaderIsInitialized)
            {
            DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
            continue;
            }
          pstCOMiCFG->iLoadCount++;
          DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
          for (iDCBindex = 1;iDCBindex <= stConfigHeader.wDCBcount;iDCBindex++)
            {
            if (DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount) == 0)
              {
              if (stDCBheader.bHeaderIsInitialized)
                {
                if (stDCBheader.stComDCB.wIObaseAddress != 0xffff)
                  {
                  strncpy(szString,stDCBheader.abyPortName,8);
                  strncpy(szTemp,szString,8);
                  RemoveSpaces(szString);
                  pstCOMiCFG->iDeviceCount++;
                  if (pstCOMiCFG->bEnumCOMscope)
                    {
                    AppendTripleDS(szTemp);
                    if (DosOpen(szTemp,&hCom,&ulAction,0L,0L,0x0001,0x21c2,0L) == 0)
                      {
                      DosClose(hCom);
                      iCOMscopeAvail++;
                      if (pstCOMiCFG->bFindCOMscope)
                        {
                        if (strcmp(szString,pstCOMiCFG->pszPortName) == 0)
                          {
                          DosClose(hFile);
                          if (!bCountOnly)
                            {
                            strcpy(pDeviceList,szString);
                            pDeviceList += (strlen(szString) + 1);
                            }
                          return(TRUE);
                          }
                        }
                      else
                        if (!bCountOnly)
                          {
                          strcpy(pDeviceList,szString);
                          pDeviceList += (strlen(szString) + 1);                                }
                          }
                    }
                  else
                    if (!bCountOnly)
                      {
                      strcpy(pDeviceList,szString);
                      pDeviceList += (strlen(szString) + 1);
                      }
                  }
                }
              }
            DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
            }
          }
        DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
        }
      }
    }
  DosClose(hFile);
  if (pstCOMiCFG->bEnumCOMscope)
    if (pstCOMiCFG->bFindCOMscope)
      return(FALSE);
    else
      return(iCOMscopeAvail);
  else
    return(pstCOMiCFG->iDeviceCount);
  }

BOOL PlaceIniCFGheader(char szFileSpec[],CFGHEAD *pstCFGheader,DCBPOS *pstHeaderPosition)
  {
  BOOL bPlaced = FALSE;
//  ULONG ulStatus;
  HFILE hFile;
  WORD iIndex;
  ULONG ulCount;
  CFGINFO stConfigInfo;
  CFGHEAD stConfigHeader;
  ULONG ulFilePosition;
  ULONG ulSaveConfigHeaderOffset;
  DCBPOS stCount;
  ULONG ulAction;

  while (DosOpen(szFileSpec,&hFile,&ulAction,0L,0,1,0x1312,(PEAOP2)0L) != NO_ERROR)
    if (AddIniConfigHeader(szFileSpec,&stCount) == 0)
      return(FALSE);
  if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
    {
    if (stConfigInfo.wCFGheaderCount >= pstHeaderPosition->wLoadNumber)
      {
      DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
      for (iIndex = 0;iIndex < pstHeaderPosition->wLoadNumber;iIndex++)
        {
        ulSaveConfigHeaderOffset = ulFilePosition;
        DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
        DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
        }
      pstCFGheader->bHeaderIsInitialized = TRUE;
//      pstCFGheader->wDeviceCount = stConfigHeader.wDeviceCount;
//          pstCFGheader->wDCBcount = stConfigHeader.wDCBcount;
      pstCFGheader->oNextCFGheader = stConfigHeader.oNextCFGheader;
      pstCFGheader->oFirstDCBheader = stConfigHeader.oFirstDCBheader;
      DosChgFilePtr(hFile,ulSaveConfigHeaderOffset,0,&ulFilePosition);
      DosWrite(hFile,(PVOID)pstCFGheader,sizeof(CFGHEAD),&ulCount);
      bPlaced = TRUE;
      }
    }
  DosClose(hFile);
  return(bPlaced);
  }

BOOL PlaceIniDCBheader(char szFileSpec[],CFGHEAD *pstCFGheader,DCBHEAD *pstDCBheader,DCBPOS *pstHeaderPosition)
  {
  BOOL bPlaced = FALSE;
//  ULONG ulStatus;
  HFILE hFile;
  WORD iIndex;
  int iDCBindex;
  ULONG ulCount;
  CFGINFO stConfigInfo;
  CFGHEAD stConfigHeader;
  DCBHEAD stDCBheader;
  ULONG ulFilePosition;
  ULONG ulSaveConfigHeaderOffset;
  ULONG ulSaveDCBheaderOffset;
  BOOL bFindNextLoad = FALSE;
  BOOL bFindNextDevice = FALSE;
  WORD wLoadIndex;
  WORD wDeviceIndex;
  DCBPOS stCount;
  ULONG ulAction;

  while (DosOpen(szFileSpec,&hFile,&ulAction,0L,0,1,0x1312,(PEAOP2)0L) != NO_ERROR)
    if (AddIniConfigHeader(szFileSpec,&stCount) == 0)
      return(FALSE);
  if (pstHeaderPosition->wLoadNumber == 0)
    bFindNextLoad = TRUE;
  if (pstHeaderPosition->wDCBnumber == 0)
    bFindNextDevice = TRUE;
  if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
    {
    if ((stConfigInfo.wCFGheaderCount >= pstHeaderPosition->wLoadNumber) && (stConfigInfo.wCFGheaderCount != 0))
      {
      DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
      if (bFindNextLoad)
        wLoadIndex = MAX_CFG_LOAD;
      else
        wLoadIndex = pstHeaderPosition->wLoadNumber;
      for (iIndex = 0;iIndex < wLoadIndex;iIndex++)
        {
        ulSaveConfigHeaderOffset = ulFilePosition;
        DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
        if (bFindNextLoad && !stConfigHeader.bHeaderIsInitialized)
          {
          pstHeaderPosition->wLoadNumber = iIndex  + 1;
          break;
          }
        DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
        }
      DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
      wDeviceIndex = stConfigHeader.wDCBcount;
      if (!bFindNextDevice)
        {
        if (pstHeaderPosition->wDCBnumber > wDeviceIndex)
          return(FALSE);
        wDeviceIndex = pstHeaderPosition->wDCBnumber;
        }
      for (iDCBindex = 0;iDCBindex < wDeviceIndex;iDCBindex++)
        {
        ulSaveDCBheaderOffset = ulFilePosition;
        DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
        if (bFindNextDevice && !stDCBheader.bHeaderIsInitialized)
          {
          pstHeaderPosition->wDCBnumber = (iDCBindex + 1);
          bPlaced = TRUE;
          break;
          }
        DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
        }
      if (bFindNextDevice && bPlaced)
        stConfigHeader.wDeviceCount++;
      if (!bFindNextDevice || bPlaced)
        {
        pstDCBheader->bHeaderIsInitialized = TRUE;
        pstDCBheader->oNextDCBheader = stDCBheader.oNextDCBheader;
        DosChgFilePtr(hFile,ulSaveDCBheaderOffset,0,&ulFilePosition);
        DosWrite(hFile,(PVOID)pstDCBheader,sizeof(DCBHEAD),&ulCount);
        pstCFGheader->bHeaderIsInitialized = TRUE;
        pstCFGheader->wDeviceCount = stConfigHeader.wDeviceCount;
        pstCFGheader->wDCBcount = stConfigHeader.wDCBcount;
        pstCFGheader->oNextCFGheader = stConfigHeader.oNextCFGheader;
        pstCFGheader->oFirstDCBheader = stConfigHeader.oFirstDCBheader;
        DosChgFilePtr(hFile,ulSaveConfigHeaderOffset,0,&ulFilePosition);
        DosWrite(hFile,(PVOID)pstCFGheader,sizeof(CFGHEAD),&ulCount);
        bPlaced = TRUE;
        }
      }
    }
  DosClose(hFile);
  return(bPlaced);
  }

void ClearAllIntDCBheader(char szFileSpec[])
  {
  ULONG ulStatus;
  HFILE hFile;
  int iDCBindex;
  ULONG ulCount;
  CFGINFO stConfigInfo;
  CFGHEAD stConfigHeader;
  DCBHEAD stDCBheader;
  ULONG ulFilePosition;
  ULONG ulSaveDCBheaderOffset;
  WORD wLoadIndex;

  if (DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x1312,(PEAOP2)0L) == 0)
    {
    if (ulStatus == FILE_EXISTED)
      {
      if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
        {
        for (wLoadIndex = 0;wLoadIndex < stConfigInfo.wCFGheaderCount;wLoadIndex++)
          {
          DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
          DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
          DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
          for (iDCBindex = 0;iDCBindex < stConfigHeader.wDCBcount;iDCBindex++)
            {
            ulSaveDCBheaderOffset = ulFilePosition;
            DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
            if (stConfigHeader.byInterruptLevel != 0)
              {
              stDCBheader.stComDCB.wConfigFlags1 |= CFG_FLAG1_MULTI_INT;
              stDCBheader.stComDCB.wConfigFlags1 &= ~CFG_FLAG1_EXCLUSIVE_ACCESS;
              DosChgFilePtr(hFile,ulSaveDCBheaderOffset,0,&ulFilePosition);
              DosWrite(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
              }
            DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
            }
          }
        }
      }
    DosClose(hFile);
    }
  }

BOOL QueryIniCFGheader(char szFileSpec[],CFGHEAD *pstCFGheader,DCBPOS *pstHeaderPosition)
  {
  BOOL bCFGfound = FALSE;
  ULONG ulStatus;
  HFILE hFile;
  WORD iIndex;
  ULONG ulCount;
  CFGINFO stConfigInfo;
  CFGHEAD stConfigHeader;
  ULONG ulFilePosition;

  if (DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0312,(PEAOP2)0L) == 0)
    {
    if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
      {
      if (stConfigInfo.wCFGheaderCount >= pstHeaderPosition->wLoadNumber)
        {
        DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
        iIndex = 0;
//        while (iIndex < pstHeaderPosition->wLoadNumber)
        for (iIndex = 0;iIndex < pstHeaderPosition->wLoadNumber;iIndex++)
          {
          DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
          if (ulCount < sizeof(CFGHEAD))
            {
            stConfigHeader.bHeaderIsInitialized = FALSE;
            break;
            }
//          if (stConfigHeader.bHeaderIsInitialized)
//            iIndex++;
          DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
          }
        if (stConfigHeader.bHeaderIsInitialized)
          bCFGfound = TRUE;
        memcpy(pstCFGheader,&stConfigHeader,sizeof(CFGHEAD));
        }
      }
    DosClose(hFile);
    }
  return(bCFGfound);
  }

BOOL QueryIniDCBheader(char szFileSpec[],CFGHEAD *pstCFGheader,DCBHEAD *pstDCBheader,DCBPOS *pstHeaderPosition)
  {
  BOOL bDevFound = FALSE;
  ULONG ulStatus;
  HFILE hFile;
  WORD iIndex;
  ULONG ulCount;
  CFGINFO stConfigInfo;
  CFGHEAD stConfigHeader;
  DCBHEAD stDCBheader;
  ULONG ulFilePosition;

  if (DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0312,(PEAOP2)0L) == 0)
    {
    if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
      {
      if (stConfigInfo.wCFGheaderCount >= pstHeaderPosition->wLoadNumber)
        {
        DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
        iIndex = 0;
//        while (iIndex < pstHeaderPosition->wLoadNumber)
        for (iIndex = 0;iIndex < pstHeaderPosition->wLoadNumber; iIndex++)
          {
          DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
          if (ulCount < sizeof(CFGHEAD))
            {
            stConfigHeader.bHeaderIsInitialized = FALSE;
            break;
            }
//          if (stConfigHeader.bHeaderIsInitialized)
//            iIndex++;
          DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
          }
        if (stConfigHeader.bHeaderIsInitialized)
          {
          if (pstHeaderPosition->wDCBnumber > stConfigHeader.wDCBcount)
            return(FALSE);
          DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
          for (iIndex = 0;iIndex < pstHeaderPosition->wDCBnumber;iIndex++)
            {
            DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
            DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
            }
          if (stDCBheader.bHeaderIsInitialized)
            {
            memcpy(pstDCBheader,&stDCBheader,sizeof(DCBHEAD));
            memcpy(pstCFGheader,&stConfigHeader,sizeof(CFGHEAD));
            bDevFound = TRUE;
            }
          }
        }
      }
    DosClose(hFile);
    }
  return(bDevFound);
  }

BOOL APIENTRY GetPortConfig(char *pszPortName,PORTINIT *pstPort)
  {
//  BOOL bSuccess;
  CFGHEAD stCFGheader;
  DCBHEAD stDCBheader;
  DCBPOS stDCBpos;
  BYTE byTemp;
  char szDriverIniSpec[CCHMAXPATH];

  if (PrfQueryProfileString(HINI_USERPROFILE,"COMi","Initialization",NULL,(PSZ)szDriverIniSpec,CCHMAXPATH) == 0)
    return(FALSE);
  InitializeCFGheader(&stCFGheader);
  InitializeDCBheader(&stDCBheader,FALSE);
  strcpy(stDCBheader.abyPortName,pszPortName);
  MakeDeviceName(stDCBheader.abyPortName);
  stDCBpos.wLoadNumber = 0;
  stDCBpos.wDCBnumber = 0;
  if (QueryIniDCBheaderName(szDriverIniSpec,&stCFGheader,&stDCBheader,&stDCBpos))
    {
    pstPort->stComDCB.XonChar = stDCBheader.stComDCB.byXonChar;
    pstPort->stComDCB.XoffChar = stDCBheader.stComDCB.byXoffChar;
    pstPort->stComDCB.ErrChar = stDCBheader.stComDCB.byErrorChar;
    pstPort->stComDCB.BrkChar = stDCBheader.stComDCB.byBreakChar;
    pstPort->stComDCB.WrtTimeout = stDCBheader.stComDCB.wWrtTimeout;
    pstPort->stComDCB.ReadTimeout = stDCBheader.stComDCB.wRdTimeout;
    pstPort->stComDCB.Flags1 = (BYTE)stDCBheader.stComDCB.wFlags1;
    pstPort->stComDCB.Flags2 = (BYTE)stDCBheader.stComDCB.wFlags2;
    pstPort->stComDCB.Flags3 = (BYTE)stDCBheader.stComDCB.wFlags3;
    pstPort->ulBaudRate = stDCBheader.stComDCB.ulBaudRate;
    byTemp = (stDCBheader.stComDCB.byLineCharacteristics & 0x3f);
    pstPort->stLine.DataBits = ((byTemp & LINE_CTL_WORD_LEN_MASK) + 5);
    pstPort->stLine.Parity = ((byTemp >> 3) & 0x0f);
    if ((byTemp & 0x04) != 0)
      {
      if (pstPort->stLine.DataBits == 5)
        pstPort->stLine.StopBits = 1;
      else
        pstPort->stLine.StopBits = 2;
      }
    else
      pstPort->stLine.StopBits = 0;
    return(TRUE);
    }
  return(FALSE);
  }

BOOL QueryIniDCBheaderName(char szFileSpec[],CFGHEAD *pstCFGheader,DCBHEAD *pstDCBheader,DCBPOS *pstHeaderPosition)
  {
  BOOL bDevFound = FALSE;
  ULONG ulStatus;
  HFILE hFile;
  WORD iIndex;
  int iDCBindex;
  ULONG ulCount;
  CFGINFO stConfigInfo;
  CFGHEAD stConfigHeader;
  DCBHEAD stDCBheader;
  ULONG ulFilePosition;

  if (DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0312,(PEAOP2)0L) == NO_ERROR)
    {
    if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == NO_ERROR)
      {
      if (stConfigInfo.wCFGheaderCount != 0)
        {
        DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
        for (iIndex = 0;iIndex < stConfigInfo.wCFGheaderCount;iIndex++)
          {
          if (bDevFound)
            break;
          DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
          if (!stConfigHeader.bHeaderIsInitialized)
            continue;
          DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
          for (iDCBindex = 0;iDCBindex < stConfigHeader.wDCBcount;iDCBindex++)
            {
            DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
            if (!stDCBheader.bHeaderIsInitialized)
              continue;
            if (strncmp(pstDCBheader->abyPortName,stDCBheader.abyPortName,8) == 0)
              {
              memcpy(pstDCBheader,&stDCBheader,sizeof(DCBHEAD));
              memcpy(pstCFGheader,&stConfigHeader,sizeof(CFGHEAD));
              pstHeaderPosition->wDCBnumber = iDCBindex + 1;
              pstHeaderPosition->wLoadNumber = iIndex + 1;
              bDevFound = TRUE;
              break;
              }
            DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
            }
          DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
          }
        }
      }
    DosClose(hFile);
    }
  return(bDevFound);
  }

BOOL RemoveIniCFGheader(char szFileSpec[],WORD wLoadNumber)
  {
  BOOL bRemoved = FALSE;
  ULONG ulStatus;
  HFILE hFile;
  WORD iIndex;
  ULONG ulCount;
  WORD wOffset;
  CFGINFO stConfigInfo;
  CFGHEAD stConfigHeader;
  DCBHEAD stDCBheader;
  ULONG ulFilePosition;
  ULONG ulSaveConfigHeaderOffset;
  ULONG ulSaveDCBheaderOffset;

  if (DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0312,(PEAOP2)0L) == 0)
    {
    if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
      {
      if ((wLoadNumber == stConfigInfo.wCFGheaderCount) && (stConfigInfo.wCFGheaderCount > 1))
        {
        stConfigInfo.wCFGheaderCount--;
        DosChgFilePtr(hFile,0L,0,&ulFilePosition);
        DosWrite(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount);
        DosSetFileSize(hFile,(sizeof(CFGINFO) +
                             (stConfigInfo.wCFGheaderCount *
                             (sizeof(CFGHEAD) + (sizeof(DCBHEAD) * MAX_CFG_DEVICE)))));
        DosClose(hFile);
        return(bRemoved);
        }
      if (stConfigInfo.wCFGheaderCount >= wLoadNumber)
        {
        if (stConfigInfo.wCFGheaderCount > 1)
          stConfigInfo.wCFGheaderCount--;
        DosChgFilePtr(hFile,0L,0,&ulFilePosition);
        DosWrite(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount);
        DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
        for (iIndex = 0;iIndex < wLoadNumber;iIndex++)
          {
          ulSaveConfigHeaderOffset = ulFilePosition;
          DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
          DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
          }
        DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
        for (iIndex = 0;iIndex < MAX_CFG_DEVICE;iIndex++)
          {
          ulSaveDCBheaderOffset = ulFilePosition;
          DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
          wOffset = stDCBheader.oNextDCBheader;
          if (stDCBheader.bHeaderIsInitialized)
            {
            stDCBheader.bHeaderIsInitialized = FALSE;
            InitializeDCBheader(&stDCBheader,FALSE);
            DosChgFilePtr(hFile,ulSaveDCBheaderOffset,0,&ulFilePosition);
            DosWrite(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
            }
          DosChgFilePtr(hFile,wOffset,0,&ulFilePosition);
          }
        stConfigHeader.wDeviceCount = 0;
        stConfigHeader.wDCBcount = 0;
        stConfigHeader.bHeaderIsInitialized = FALSE;
        stConfigHeader.bHeaderIsAvailable = FALSE;
        stConfigHeader.wIntIDregister = 0;
        stConfigHeader.wDelayCount = 0;
        stConfigHeader.wLoadFlags = 0;
        DosChgFilePtr(hFile,ulSaveConfigHeaderOffset,0,&ulFilePosition);
        DosWrite(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
        bRemoved = TRUE;
        }
      }
    DosClose(hFile);
    }
  return(bRemoved);
  }

BOOL RemoveIniDCBheader(char szFileSpec[],DCBPOS *pstHeaderPosition)
  {
  BOOL bRemoved = FALSE;
  ULONG ulStatus;
  HFILE hFile;
  WORD iIndex;
  ULONG ulCount;
  CFGINFO stConfigInfo;
  CFGHEAD stConfigHeader;
  DCBHEAD stDCBheader;
  ULONG ulFilePosition;
  ULONG ulSaveConfigHeaderOffset;
  ULONG ulSaveDCBheaderOffset;

  if (DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0312,(PEAOP2)0L) == 0)
    {
    if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
      {
      if (stConfigInfo.wCFGheaderCount >= pstHeaderPosition->wLoadNumber)
        {
        DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
        for (iIndex = 0;iIndex < pstHeaderPosition->wLoadNumber;iIndex++)
          {
          ulSaveConfigHeaderOffset = ulFilePosition;
          DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
          DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
          }
        if (stConfigHeader.bHeaderIsInitialized)
          {
          DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
          for (iIndex = 0;iIndex < pstHeaderPosition->wDCBnumber;iIndex++)
            {
            ulSaveDCBheaderOffset = ulFilePosition;
            DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
            DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
            }
          if (stDCBheader.bHeaderIsInitialized)
            {
            stConfigHeader.wDeviceCount--;
            if (stConfigHeader.wDeviceCount == 0)
              {
              if (stConfigInfo.wCFGheaderCount != 1)
                {
                if (pstHeaderPosition->wLoadNumber >= stConfigInfo.wCFGheaderCount)
                  {
                  stConfigInfo.wCFGheaderCount--;
                  DosChgFilePtr(hFile,0L,0,&ulFilePosition);
                  DosWrite(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount);
                  DosSetFileSize(hFile,(sizeof(CFGINFO) + (stConfigInfo.wCFGheaderCount * (sizeof(CFGHEAD) + (sizeof(DCBHEAD) * MAX_CFG_DEVICE)))));
                  DosClose(hFile);
                  return(TRUE);
                  }
                stConfigInfo.wCFGheaderCount--;
                }
              DosChgFilePtr(hFile,0L,0,&ulFilePosition);
              DosWrite(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount);
              stConfigHeader.bHeaderIsInitialized = FALSE;
              stConfigHeader.bHeaderIsAvailable = FALSE;
  //            stConfigHeader.wDCBcount = 0;
              stConfigHeader.wDeviceCount = 0;
              stConfigHeader.wIntIDregister = 0;
              stConfigHeader.wDelayCount = FALSE;
              stConfigHeader.wLoadFlags = 0;
              }
            DosChgFilePtr(hFile,ulSaveConfigHeaderOffset,0,&ulFilePosition);
            DosWrite(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
            InitializeDCBheader(&stDCBheader,FALSE);
            DosChgFilePtr(hFile,ulSaveDCBheaderOffset,0,&ulFilePosition);
            DosWrite(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
            bRemoved = TRUE;
            }
          }
        }
      }
    DosClose(hFile);
    }
  return(bRemoved);
  }

int FillDeviceDialogNameListBox(HWND hwndDlg,char szCurrentName[],char szPortName[])
  {
  int iItemSelected = 0;
  int iIndex;
  int iItemCount = 0;
  BOOL bSelectNext = FALSE;
  char *pszName;
  DEVLIST *pstDevList;

  for (iIndex = 1;iIndex < 100;iIndex++)
    {
    pstDevList = &astConfigDeviceList[iIndex];
    pszName = pstDevList->szName;
    if (pstDevList->bAvailable)
      {
      WinSendDlgItemMsg(hwndDlg,PCFG_NAME_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(pszName));
      if (iItemSelected == 0)
        {
        if (bSelectNext)
          iItemSelected = iItemCount;
        if (szCurrentName[0] != 0)
          {
          if (strcmp(szCurrentName,pszName) == 0)
            {
            strncpy(szPortName,pszName,5);
            iItemSelected = iItemCount;
            }
          }
        else
          if (szLastName[0] != 0)
            {
            if (strcmp(szLastName,pszName) == 0)
              bSelectNext = TRUE;
            }
        }
      iItemCount++;
      }
    else
      {
      if (iItemSelected == 0)
        {
        if (szCurrentName[0] != 0)
          {
          if (strcmp(szCurrentName,pszName) == 0)
            {
            strcpy(szPortName,pszName);
            WinSendDlgItemMsg(hwndDlg,PCFG_NAME_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(pszName));
            iItemSelected = iItemCount;
            }
          }
        else
          {
          if (szLastName[0] != 0)
            if (strcmp(szLastName,pszName) == 0)
              bSelectNext = TRUE;
          }
        }
      }
    }
  return(iItemSelected);
  }

BOOL GetNextAvailableAddress(WORD *pwAddress)
  {
  LINKLIST *pListItem = NULL;
  WORD *pWord;
  WORD wAddress;

  if (pAddressList->pData != NULL)
    {
    for (wAddress = *pwAddress;wAddress <= 0xfff8;wAddress += 8)
      {
      pListItem = pAddressList;
      do
        {
        pWord = (WORD *)pListItem->pData;
        if (wAddress == *pWord)
          break;
        } while ((pListItem = GetNextListItem(pListItem)) != NULL);
      if (wAddress != *pWord)
        break;
      }
    if (wAddress > 0xfff8)
      {
      for (wAddress = 0x100;wAddress <= *pwAddress;wAddress += 8)
        {
        pListItem = pAddressList;
        do
          {
          pWord = (WORD *)pListItem->pData;
          if (wAddress == *pWord)
            break;
          } while ((pListItem = GetNextListItem(pListItem)) != NULL);
        if (wAddress != *pWord)
          break;
        }
      if (wAddress > *pwAddress)
        return(FALSE);
      }
    *pwAddress = wAddress;
    }
  return(TRUE);
  }

BOOL GetNextAvailableInterrupt(char *pbyIntLevel)
  {
  LINKLIST *pListItem = NULL;
  BYTE *pByte;
  BYTE byIntLevel;

  if (pInterruptList->pData != NULL)
    {
    for (byIntLevel = *pbyIntLevel;byIntLevel <= 15;byIntLevel++)
      {
      pListItem = pInterruptList;
      do
        {
        if ((pByte  = (BYTE *)pListItem->pData) == NULL)
          break;
        if (byIntLevel == *pByte)
          break;
        } while ((pListItem = GetNextListItem(pListItem)) != NULL);
      if (byIntLevel != *pByte)
        break;
      }
    if (byIntLevel > 15)
      {
      for (byIntLevel = 2;byIntLevel <= *pbyIntLevel;byIntLevel++)
        {
        pListItem = pInterruptList;
        do                {
          if ((pByte = (BYTE *)pListItem->pData) == NULL)
            break;
          if (byIntLevel == *pByte)
            break;
          } while ((pListItem = GetNextListItem(pListItem)) != NULL);
        if (byIntLevel != *pByte)
          break;
        }
      if (byIntLevel > *pbyIntLevel)
        return(FALSE);
      }
    }
  else
    byIntLevel = 4;
  *pbyIntLevel = byIntLevel;
  return(TRUE);
  }

APIRET APIENTRY GetDriverVersion(char szVersion[],ULONG *pulSignature)
  {
  if (szDriverVersionString[0] == 0)
    return(FALSE);
  strcpy(szVersion,szDriverVersionString);
  *pulSignature = ulCOMiSignature;
  return(TRUE);
  }

APIRET GetDriverInfo(void)
  {
  APIRET rc = 0;
  ULONG ulDataLen;
  ULONG ulParmLen;
  EXTPARM stParams;
  EXTDATA *pstData;
  int iIndex;
  BYTE *pByte;
  WORD *pWord;
  HFILE hCom;
  ULONG ulAction;

  szDriverIniPath[0] = 0;
  szDriverVersionString[0] = 0;
  byDDOEMtype = 0;
  if ((rc = DosOpen(SPECIAL_DEVICE,&hCom,&ulAction,0L,0L,0x0001,0x21c2,0L)) != NO_ERROR)
    return(FALSE);
  if ((rc = DosAllocMem((PPVOID)&pstData,(sizeof(EXTDATA) + MAX_DD_PATH),PAG_COMMIT | PAG_READ | PAG_WRITE)) != 0)
		{
#if DEBUG > 0
    sprintf(szMessage,"Error Allocating Memory for DD PATH - %X",rc);
    MessageBox(HWND_DESKTOP,szMessage);
#endif
    DosClose(hCom);
    return(FALSE);
    }
  else
    {
    /*
    **  Get device driver path
    */
    stParams.wSignature = SIGNATURE;
    stParams.wDataCount = MAX_DD_PATH;
    stParams.wCommand = EXT_CMD_GET_PATH;
    stParams.wModifier = 0;
    ulDataLen = (ULONG)(sizeof(EXTDATA) + MAX_DD_PATH);
    ulParmLen = (ULONG)sizeof(EXTPARM);
    if ((rc = DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,pstData,(sizeof(EXTDATA) + MAX_DD_PATH),&ulDataLen)) != 0)
      {
#if DEBUG > 0
      sprintf(szMessage,"DOS Error Accessing Extension - %X",rc);
      MessageBox(HWND_DESKTOP,szMessage);
#endif
      DosFreeMem(pstData);
      DosClose(hCom);
      return(FALSE);
      }
    else
      {
      if (pstData->wReturnCode != EXT_RSP_SUCCESS)
        {
        if ((pstData->wReturnCode & EXT_BAD_SIGNATURE) != EXT_BAD_SIGNATURE)
          {
#if DEBUG > 0
          sprintf(szMessage,"Extension Access Error - %04X-%04X",stParams.wCommand,pstData->wReturnCode);
          MessageBox(HWND_DESKTOP,szMessage);
#endif
          DosFreeMem(pstData);
          DosClose(hCom);
          return(FALSE);
          }
        rc = pstData->wReturnCode;
        }
      }
    bDeviceIniFileSelected = TRUE;
    pByte = (BYTE *)(&pstData->wData);
    for (iIndex = 0;iIndex < (CCHMAXPATH - 1);iIndex++)
      {
      szDriverIniPath[iIndex] = toupper(*pByte);
      if (*(pByte++) == ' ')
        break;
      }
    szDriverIniPath[iIndex] = 0;
    strcpy(szTempFilePath,szDriverIniPath);
    AppendINI(szDriverIniPath);
    AppendTMP(szTempFilePath);
    strcpy(szDriverVersionString,pByte);
    szDriverVersionString[strlen(szDriverVersionString) - 2] = 0;
    /*
    ** Get device count restrictions
    */
    stParams.wSignature = SIGNATURE;
    stParams.wDataCount = sizeof(USHORT);
    stParams.wCommand = EXT_CMD_GET_MAX_DEVICE_COUNT;
    stParams.wModifier = 0;
    ulDataLen = (ULONG)(sizeof(EXTDATA));
    ulParmLen = (ULONG)sizeof(EXTPARM);
    if (DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,pstData,sizeof(EXTDATA),&ulDataLen) == NO_ERROR)
      {
      if (pstData->wReturnCode == EXT_RSP_SUCCESS)
        {
        pWord = (WORD *)(&pstData->wData);
        wDDmaxDeviceCount = *pWord;
#if DEBUG > 3
        if (wDDmaxDeviceCount != 0)
          {
          sprintf(szMessage,"Device Driver Maximum Devices = %u",wDDmaxDeviceCount);
          MessageBox(HWND_DESKTOP,szMessage);
          }
#endif
        }
#if DEBUG > 0
      else
        {
        sprintf(szMessage,"Unable to get Device Count Restrictions, COMi EXT error = %u",pstData->wReturnCode);
        MessageBox(HWND_DESKTOP,szMessage);
        }
#endif
      }
#if DEBUG > 0
    else
      {
      sprintf(szMessage,"Unable to get Device Count Restrictions, DOS error = %u",rc);
      MessageBox(HWND_DESKTOP,szMessage);
      }
#endif
    /*
    ** Get device OEM type
    */
    stParams.wSignature = SIGNATURE;
    stParams.wDataCount = sizeof(USHORT);
    stParams.wCommand = EXT_CMD_GET_OEM_TYPE;
    stParams.wModifier = 0;
    ulDataLen = sizeof(EXTDATA);
    ulParmLen = sizeof(EXTPARM);
    if (DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,pstData,sizeof(EXTDATA),&ulDataLen) == NO_ERROR)
      {
      if (pstData->wReturnCode == EXT_RSP_SUCCESS)
        {
        pWord = (WORD *)(&pstData->wData);
        byDDOEMtype = (BYTE)*pWord;
        if (byDDOEMtype & 0x80)
          {
          bLimitLoad = TRUE;
          byDDOEMtype &= 0x7f;
          }
#if DEBUG > 3
        if (byDDOEMtype != 0)
          {
          sprintf(szMessage,"Device Driver OEM type = %u",byDDOEMtype);
          MessageBox(HWND_DESKTOP,szMessage);
          }
#endif
        }
#if DEBUG > 0
      else
        {
        sprintf(szMessage,"Unable to get OEM type COMi EXT error = %u",pstData->wReturnCode);
        MessageBox(HWND_DESKTOP,szMessage);
        }
#endif
      }
#if DEBUG > 0
    else
      {
      sprintf(szMessage,"Unable to get OEM type DOS error = %u",rc);
      MessageBox(HWND_DESKTOP,szMessage);
      }
#endif
    /*
    ** Get device driver signature
    */
    stParams.wSignature = SIGNATURE;
    stParams.wDataCount = sizeof(USHORT);
    stParams.wCommand = EXT_CMD_GET_SIGNATURE;
    stParams.wModifier = 0;
    ulDataLen = sizeof(EXTDATA);
    ulParmLen = sizeof(EXTPARM);
    if ((rc = DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,pstData,sizeof(EXTDATA),&ulDataLen)) != 0)
      {
#if DEBUG > 0
      sprintf(szMessage,"DOS Error Accessing COMi Extension - %X",rc);
      MessageBox(HWND_DESKTOP,szMessage);
#endif
      DosFreeMem(pstData);
      DosClose(hCom);
      return(FALSE);
      }
    else
      {
      if (pstData->wReturnCode != EXT_RSP_SUCCESS)
        {
#if DEBUG > 0
        rc = pstData->wReturnCode;
        sprintf(szMessage,"COMi Extension Access Error - %04X-%04X",stParams.wCommand,rc);
        MessageBox(HWND_DESKTOP,szMessage);
#endif
        DosClose(hCom);
        DosFreeMem(pstData);
        return(FALSE);
        }
      }
    pWord = (WORD *)(&pstData->wData);
    ulCOMiSignature = (ULONG)*pWord;
    DosClose(hCom);
    }
  DosFreeMem(pstData);
  return(TRUE);
  }
