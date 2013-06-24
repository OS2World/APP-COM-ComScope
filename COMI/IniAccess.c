/************************************************************************
**
** $Revision:  $
**
** $Log:   $
**
************************************************************************/

#define INCL_DOSDEVICES
#define INCL_VIO
#define INCL_DOS
#define INCL_DOSERRORS
#define INCL_NOPM
#define building_DD

#include <os2.h>
//#include <memory.h>
//#include <stdlib.h>
//#include <string.h>
#include "COMDD.H"
#include "COMDCB.H"
#include "CUTIL.H"
#include "RMCALLS.H"

#include "message.c"

#define FP_SEG(fp) (*((unsigned _far *)&(fp)+1))
#define FP_OFF(fp) (*((unsigned _far *)&(fp)))

#ifdef use_far
extern DEVHEAD _far _stDummyHeader;
extern BYTE _far _abyPath[];
extern sBOOL _far _bSharedInterrupts;
extern WORD _far _wIntIDregister;
extern WORD _far _wOEMjumpEntry;
extern WORD _far _wOEMjumpExit;

extern WORD _far _wMaxDeviceCount;

extern WORD _far _wEndOfData;
extern DEVDEF _far _stDeviceParms[];
extern WORD _far_ _wBusType;
#else
extern DEVHEAD _stDummyHeader;
extern BYTE _abyPath[];
extern sBOOL _bSharedInterrupts;
extern WORD _wIntIDregister;
extern WORD _wOEMjumpEntry;
extern WORD _wOEMjumpExit;

extern WORD _wMaxDeviceCount;

extern WORD _wEndOfData;
extern DEVDEF _stDeviceParms[];

extern ADDENTRY _stAttachDD;
extern WORD _wBusType;
extern WORD bDisableRM;
extern WORD bPnPcapable;
extern char _szName[];
extern BYTE _byAdapterType;
extern BYTE _byOEMtype;
//extern BYTE byHardwareType;
extern BYTE byNextPCIslot;

#pragma same_seg (_stDummyHeader,_abyPath,_bSharedInterrupts, _wIntIDregister,_wOEMjumpEntry,_wOEMjumpExit,_wMaxDeviceCount,_wEndOfData,_stAttachDD,_szName,_byAdapterType,_wBusType,_byOEMtype)

#endif

extern USHORT FAR RMHELP_GetStatusPort(void);
extern BOOL FAR RMHELP_HasPNPCaps(void);
extern USHORT FAR RMHELP_GetPorts(DCBHEAD *pComInfo, USHORT usPortNumber);
extern USHORT FAR RMHELP_StatusPortInitComplete(void);
extern void RMHELP_CreateDriver(void);
extern void RMHELP_DestroyDriver(void);

/*
** don't need segment
*/
extern VOID NEAR *_pCOMscopeStrategy;
extern VOID NEAR *_pDeviceStrategy;

extern char chFailedReadIni[];
extern char chFailedWriteIni[];
extern char chFailedIniCorrupt_1[];
extern char chFailedIniCorrupt_2[];
extern char chFailedIniNotInit_1[];
extern char chFailedIniNotInit_2[];
extern char chFailedBadPath[];
extern char chFailedBadVersion_1[];
extern char chFailedBadVersion_2[];
#ifndef NO_PCI
extern char chPCIMissing[];
extern char chPCIBadIRQ[];
extern char chTooManyPCIadapters[];
extern char chPCI_LoadOrder_1[];
extern char chPCI_LoadOrder_2[];
extern PCIADPT stPCIadapterTable[];
extern PCIADPT stPCIadapterHold[];
#else
extern char chPCInotSupported[];
#endif

extern COMDCB stConfigParms[];
extern sBOOL bVerbose;
extern BYTE abyFileBuffer[];
extern WORD bPrintLocation;

extern sBOOL bWaitForCR;
extern WORD wLoadNumber;
extern WORD wLoadCount;
extern WORD wLoadFlags;
extern BYTE *pbyData;
extern BYTE abyCOMnumbers[];
extern BYTE byLoadAdapterType;
extern sBOOL bABIOSpresent;
extern sBOOL bIsTheFirst;
extern LIDTAB LIDtable[];
extern ULONG ulAvailableBufferSpace;
extern ULONG ulRequiredBufferSpace;
extern ULONG ulWriteBufferSpace;
extern sBOOL bUseDDdataSegment;

extern WORD _wPCIvendor;
extern WORD _wPCIdevice;
extern WORD wPCIcount;
extern WORD wPCIadapterCount;

extern WORD wDeviceCount;
extern WORD wDriverLoadCount;
extern WORD wDelayCount;

#ifdef OEM
extern sBOOL _bOEMpresent;
extern char chWrongOEM_ss[];
extern char chCompanyName[];
extern char chAdapterName[];
#endif

extern char szMessage[];

extern INSTDEF astInstallParms[];

extern MCAPORT astMCAportTable[];

#ifdef debug_ini
extern char szTIF[];
extern char szDHI[];
extern char szCHR[];
extern char szAS[];
extern char szDHR[];
extern char szCHW[];
extern char szCHA[];
extern char szTLC[];
#endif

/*
**  All variables delcared in this module MUST be initialized in order to force
**  them into the initialized 'C' data segment.
*/
CFGINFO stConfigInfo = {0};
CFGHEAD stConfigHeader = {0};
DCBHEAD stDCBheader = {0};

BOOL bPrevErrorMsg = FALSE;

HFILE hCom = 0;
HFILE hFile = 0;


DEVDEF _far *pDeviceParms = 0;
DEVHEAD _far *pStart = 0;
DEVHEAD _far *pPrevious = 0;
WORD wDeviceStrategy = 0;
extern WORD bSeparateIDreg;

#ifndef NO_COMscope
WORD wCOMscopeStrategy = 0;
VOID MakeCOMscopeName(char _far szString[]);
#endif

DEVHEAD stDefaultDevHeader = {0,0};

WORD bBreakInitialization = FALSE;

WORD StringLength(BYTE abyString[]);

WORD awPorts[17] = {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};

void VerifyABIOSdefinitions(WORD wLoadCount);
/*
** All data MUST be in the data segment of the device driver (RDGROUP)
** for the AttachDD function.
*/
WORD AttachDD(char szName[],ADDENTRY *pstAttachDD);// params assume DS=DGROUP

void MemCopy(char _far *pDest,char _far *pSource,WORD wCount)
  {
  WORD wIndex;

  for (wIndex = 0;wIndex < wCount;wIndex++)
    pDest[wIndex] = pSource[wIndex];
  }

#ifdef OEM
void PrintWrongOEM(void)
  {
  int iLen;
  
  iLen = sprintf(szMessage, 0, chWrongOEM_ss,chCompanyName,chAdapterName);
  VioWrtTTY(szMessage,iLen,0);
//  VioWrtTTY(chCompanyName,StringLength(chCompanyName),0);
//  VioWrtTTY(chWrongOEM_2,StringLength(chWrongOEM_2),0);
//  VioWrtTTY(chAdapterName,StringLength(chAdapterName),0);
//  VioWrtTTY(chWrongOEM_3,StringLength(chWrongOEM_3),0);
  }
#endif

void FAR GetIniInfo(void)
  {
  int iLen;
  WORD rc;
  WORD wDCBindex;
  WORD wIndex;
  LONG lSaveOffset;
  LONG lSaveDCBoffset;
  int iPortIndex;
  WORD wSaveExt;
  WORD wDummy;
  BYTE byDummy;
  char abySaveExt[4];
  //WORD wTemp;
  ULONG ulFilePosition;
  ULONG ulHeaderDummy;
  BOOL bPCIadapter = FALSE;
  WORD wError;
  WORD wPCIerror;
#ifdef _32bitAPI
  ULONG ulAction;
  ULONG ulCount;
  ULONG ulFileError;
#else
  WORD ulAction;
  WORD ulCount;
  WORD ulFileError;
#endif

  ulWriteBufferSpace = 0;
  ulRequiredBufferSpace = 0;
  ulFileError = FALSE;
  wLoadNumber = NO_INI_FILE;
  wLoadCount = 0;
  for (wIndex = 0;wIndex < (CCHMAXPATH - 8);wIndex++)
    {
    if (_abyPath[wIndex] == ' ')
      break;
    if (_abyPath[wIndex] == 0)
      break;
    }
  while (_abyPath[wIndex] != '.')
    if (wIndex-- == 0)
      {
      VioWrtTTY(chFailedBadPath,StringLength(chFailedBadPath),0);
      return;
      }
  wSaveExt = ++wIndex;
  abySaveExt[0] = _abyPath[wIndex];
  _abyPath[wIndex] = 'I';
  abySaveExt[1] = _abyPath[++wIndex];
  _abyPath[wIndex] = 'N';
  abySaveExt[2] = _abyPath[++wIndex];
  _abyPath[wIndex] = 'I';
  abySaveExt[3] = _abyPath[++wIndex];
  _abyPath[wIndex] = 0;
#ifndef NO_PCI
  #if MAX_PCI_ADAPTERS > 0
  GetAllSerialPCIAdapters();
  if (wPCIadapterCount > 1)
    {
    WORD awIndexList[MAX_PCI_ADAPTERS + 1];
    BYTE xHighest;
    BYTE xLowest;
    BYTE xCurrent;
    WORD wListIndex;
    WORD wUsedIndex;
    BOOL bSkipIndex;
    
#ifdef OEM
    _bOEMpresent = TRUE;
#endif                               
    for (wIndex = 0; wIndex < MAX_PCI_ADAPTERS; wIndex++)
      awIndexList[wIndex] = -1;
    for (wListIndex = 0; wListIndex < MAX_PCI_ADAPTERS; wListIndex++)  
      {
      xLowest = 0xff;
      for (wIndex = 0; wIndex < MAX_PCI_ADAPTERS; wIndex++)
        {
        if ((xCurrent = stPCIadapterTable[wIndex].xDevFuncNum) == 0)
          break;
        bSkipIndex = FALSE;
        for (wUsedIndex = 0; wUsedIndex < MAX_PCI_ADAPTERS; wUsedIndex++)
          if (awIndexList[wUsedIndex] == wIndex)
            {
            bSkipIndex = TRUE;
            break;
            }
        if (!bSkipIndex)
          if (xCurrent < xLowest)
            {
            awIndexList[wListIndex] = wIndex;
            xLowest = xCurrent;
            }
        }
      }
    for (wIndex = 0; wIndex < MAX_PCI_ADAPTERS; wIndex++)
      if (stPCIadapterTable[wIndex].xDevFuncNum == 0)
        break;
      else
        MemCopy((char _far *)&stPCIadapterHold[wIndex], (char _far *)&stPCIadapterTable[awIndexList[wIndex]], sizeof (PCIADPT));
    MemCopy((char _far *)stPCIadapterTable, (char _far *)stPCIadapterHold, (sizeof (PCIADPT) * MAX_PCI_ADAPTERS));
    }
  #endif
#endif    
  if (DosOpen(_abyPath,&hFile,&ulAction,0L,0,1,0x1312,0L) == 0)
    {
    if ((ulFileError = DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount)) != 0)
      {
      VioWrtTTY(chFailedReadIni,StringLength(chFailedReadIni),0);
      ulFileError |= ERR_FILE_READ;
      goto gtEarlyOut;
      }
    if (stConfigInfo.ulSignature != INI_FILE_SIGNATURE)
      {
      VioWrtTTY(chFailedBadVersion_1,StringLength(chFailedBadVersion_1),0);
      VioWrtTTY(_abyPath,StringLength(_abyPath),0);
      VioWrtTTY(chFailedBadVersion_2,StringLength(chFailedBadVersion_2),0);
      ulFileError = BAD_INI_SIGNATURE;
      goto gtEarlyOut;
      }
    if (stConfigInfo.wCFGheaderCount == 0)
      {
      VioWrtTTY(chFailedIniCorrupt_1,StringLength(chFailedIniCorrupt_1),0);
      VioWrtTTY(_abyPath,StringLength(_abyPath),0);
      VioWrtTTY(chFailedIniCorrupt_2,StringLength(chFailedIniCorrupt_2),0);
      ulFileError |= ERR_FILE_CORRUPT;
      goto gtEarlyOut;
      }
    stConfigInfo.byOEMtype = _byOEMtype;
    wDriverLoadCount = stConfigInfo.wCFGheaderCount;
    lSaveOffset = stConfigInfo.oFirstCFGheader;
    DosChgFilePtr(hFile,lSaveOffset,0,&ulFilePosition);
    _byAdapterType = stConfigHeader.byAdapterType;
    byNextPCIslot = stConfigInfo.byNextPCIslot;
    if (bIsTheFirst)
      {
      byNextPCIslot = 0;
      stConfigInfo.byNextPCIslot = 0;
      /*
      **  Clear HeaderIsAvailable flags for all config headers if this is the
      **  first COMi load.
      */
      DosChgFilePtr(hFile,0,0,&ulFilePosition);
      if ((ulFileError = DosWrite(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount)) != 0)
        {
        VioWrtTTY(chFailedWriteIni,StringLength(chFailedWriteIni),0);
        ulFileError |= ERR_FILE_WRITE;
        goto gtEarlyOut;
        }
      for (wIndex = 0;wIndex < stConfigInfo.wCFGheaderCount;wIndex++)
        {
        if ((ulFileError = DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount)) != 0)
          {
          VioWrtTTY(chFailedReadIni,StringLength(chFailedReadIni),0);
          ulFileError |= ERR_FILE_READ;
          goto gtEarlyOut;
          }
//        byAdapterType = stConfigHeader.byAdapterType;
#ifdef OEM
        if (wIndex == 0)
          {
  #ifdef this_junk //NO_PCI
          int iPCIindex;
          for (iPCIindex = 0; iPCIindex < MAX_PCI_ADAPTERS; iPCIindex++)
            {
            if (stPCIadapterTable[iPCIindex].xDevFuncNum == 0)
              break; 
            if (stPCIadapterTable[wIndex].usVendorID == OEM_PCI_VENDOR)
              {
              _bOEMpresent = TRUE;
              break;
              }
            }
  #endif
          if (!_bOEMpresent)
            if ((byLoadAdapterType != HDWTYPE_NONE) && !_bSharedInterrupts)
              {
              if (byLoadAdapterType != stConfigHeader.byAdapterType)
                {
                if (byLoadAdapterType == HDWTYPE_DIGIBOARD)
                  {
                  if ((stConfigHeader.byAdapterType != HDWTYPE_FIVE) && (stConfigHeader.byAdapterType != HDWTYPE_FOUR))
                    {
                    PrintWrongOEM();
                    ulFileError |= ERR_BAD_OEM;
                    bBreakInitialization = TRUE;
                    }
                  }
                else
                  {
                  PrintWrongOEM();
                  ulFileError |= ERR_BAD_OEM;
                  bBreakInitialization = TRUE;
                  }
                }
              else
                _bOEMpresent = TRUE;
              }
            }
#endif
        DosChgFilePtr(hFile,lSaveOffset,0,&ulFilePosition);
        if (bBreakInitialization)
          stConfigHeader.bHeaderIsAvailable = FALSE;
        else
          stConfigHeader.bHeaderIsAvailable = TRUE;
        if ((ulFileError = DosWrite(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount)) != 0)
          {
          VioWrtTTY(chFailedWriteIni,StringLength(chFailedWriteIni),0);
          ulFileError |= ERR_FILE_WRITE;
          goto gtEarlyOut;
          }
        if ((_wMaxDeviceCount != 0) && !bBreakInitialization)
          {
          DosChgFilePtr(hFile,(LONG)stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
          for (wDCBindex = 0;wDCBindex < stConfigHeader.wDCBcount;wDCBindex++)
            {
            lSaveDCBoffset = ulFilePosition;
            if ((ulFileError = DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount)) != 0)
              {
              VioWrtTTY(chFailedReadIni,StringLength(chFailedReadIni),0);
              ulFileError |= ERR_FILE_READ;
              goto gtEarlyOut;
              }
            if (!bBreakInitialization)
              {
              if (stDCBheader.bHeaderIsInitialized)
                if (++wDeviceCount == _wMaxDeviceCount)
                  bBreakInitialization = TRUE;
              }
            else
              {
              stDCBheader.bHeaderIsInitialized = FALSE;
              DosChgFilePtr(hFile,lSaveDCBoffset,0,&ulFilePosition);
              if ((ulFileError = DosWrite(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount)) != 0)
                {
                VioWrtTTY(chFailedWriteIni,StringLength(chFailedWriteIni),0);
                ulFileError |= ERR_FILE_WRITE;
                goto gtEarlyOut;
                }
              }
            DosChgFilePtr(hFile,(LONG)stDCBheader.oNextDCBheader,0,&ulFilePosition);
            }
          }
        DosChgFilePtr(hFile,(LONG)stConfigHeader.oNextCFGheader,0,&ulFilePosition);
        lSaveOffset = stConfigHeader.oNextCFGheader;
        }
      }
#ifndef NO_RESOURCE_MGR
    if (!bDisableRM)
      {
      bPnPcapable = RMHELP_HasPNPCaps();
      RMHELP_CreateDriver();
      }
#endif
    DosChgFilePtr(hFile,(LONG)stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
    for (wIndex = 0;wIndex < stConfigInfo.wCFGheaderCount;wIndex++)
      {
      if ((ulFileError = DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount)) != 0)
        {
        VioWrtTTY(chFailedReadIni,StringLength(chFailedReadIni),0);
        ulFileError |= ERR_FILE_READ;
        goto gtEarlyOut;
        }
      if (stConfigHeader.bHeaderIsAvailable && (stConfigHeader.wDCBcount != 0))
        {
        if (stConfigInfo.wCFGheaderCount > 1)
          {
          iLen = sprintf(szMessage,0,"Load Number %u\r\n",(wIndex + 1));
          VioWrtTTY(szMessage,iLen,0);
          }
        if ((wDelayCount = stConfigHeader.wDelayCount) != 0)
          bWaitForCR = TRUE;
        wLoadFlags = stConfigHeader.wLoadFlags;
        if (wLoadFlags & LOAD_FLAG1_VERBOSE)
          bVerbose = TRUE;
        if (wLoadFlags & LOAD_FLAG1_PRINT_LOCAL)
          bPrintLocation = TRUE;
        bSeparateIDreg = TRUE;
        if (stConfigHeader.byAdapterType != HDWTYPE_PCI)
          {
          _wIntIDregister = stConfigHeader.wIntIDregister;
          /*
          ** if device is DigiBoard (<=8 port) and interrupt level is even then
          ** increment ID register address
          */
          if (wLoadFlags & LOAD_FLAG1_DIGIBOARD08_INT_ID)
            if ((stConfigHeader.byInterruptLevel & 0x01) == 0)
              _wIntIDregister++;
          if (_wIntIDregister != 0)
            {
            _wOEMjumpEntry = stConfigHeader.wOEMentryVector;
            _wOEMjumpExit = stConfigHeader.wOEMexitVector;
            }
          }
        else
          {
#ifndef NO_PCI
          BOOL bForceInterrupt = FALSE;
          
          if ((wPCIerror = LoadPCIAdapter(wIndex,&stConfigHeader.byInterruptLevel,awPorts)) != NO_ERROR)
            {
            if (wPCIerror == 0xfffe)
              VioWrtTTY(chPCIBadIRQ,StringLength(chPCIBadIRQ),0);
            else
              if (wPCIerror == 0xfffd)
                VioWrtTTY(chTooManyPCIadapters,StringLength(chTooManyPCIadapters),0);
              else
                VioWrtTTY(chPCIMissing,StringLength(chPCIMissing),0);
            bPrevErrorMsg = TRUE;
            goto gtEarlyOut;
            }
          bPCIadapter = TRUE;
          _wBusType = BUSTYPE_PCI;
          byNextPCIslot++;
          stConfigHeader.byPCIslot = byNextPCIslot;
          stConfigHeader.wPCIvendor = stPCIadapterTable[wIndex].usVendorID;
          _wPCIvendor = stConfigHeader.wPCIvendor;
          stConfigHeader.wPCIdevice = stPCIadapterTable[wIndex].usDeviceID;
          _wPCIdevice = stConfigHeader.wPCIdevice;
          stConfigInfo.byNextPCIslot = byNextPCIslot;
          DosChgFilePtr(hFile,0,0,&ulHeaderDummy);
          if ((ulFileError = DosWrite(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount)) != 0)
            {
            VioWrtTTY(chFailedWriteIni,StringLength(chFailedWriteIni),0);
            ulFileError |= ERR_FILE_WRITE;
            goto gtEarlyOut;
            }
#else
          // PCI not allowed in this version
          VioWrtTTY(chPCInotSupported,StringLength(chPCInotSupported),0);
          bPrevErrorMsg = TRUE;
          goto gtEarlyOut;
#endif
          }
        stConfigHeader.bHeaderIsAvailable = FALSE;
        DosChgFilePtr(hFile,ulFilePosition,0,&ulFilePosition);
        if ((ulFileError = DosWrite(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount)) != 0)
          {
          VioWrtTTY(chFailedWriteIni,StringLength(chFailedWriteIni),0);
          ulFileError |= ERR_FILE_WRITE;
          goto gtEarlyOut;
          }
        DosChgFilePtr(hFile,(LONG)stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
        if (stConfigHeader.wDCBcount > MAX_DEVICE)
          stConfigHeader.wDCBcount = MAX_DEVICE;
        pDeviceParms = (DEVDEF _far *)_stDeviceParms;
#ifndef NO_COMscope
        wCOMscopeStrategy = (WORD)&_pCOMscopeStrategy;
#endif
        wDeviceStrategy = (WORD)&_pDeviceStrategy;
        pPrevious = NULL;
//        wEndOfData = ((WORD)DeviceParms + (stConfigHeader.wDCBcount * sizeof(DEVDEF)));
        for (wDCBindex = 0;wDCBindex < stConfigHeader.wDCBcount;wDCBindex++)
          {
          if ((ulFileError = DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount)) != 0)
            {
            VioWrtTTY(chFailedReadIni,StringLength(chFailedReadIni),0);
            ulFileError |= ERR_FILE_READ;
            goto gtEarlyOut;
            }
          if (stDCBheader.bHeaderIsInitialized)
            {
            /*
            ** if global IRQ is defined then make device IRQ equal to
            ** global IRQ
            */
            if (stConfigHeader.byInterruptLevel != 0)
              stDCBheader.stComDCB.byInterruptLevel = stConfigHeader.byInterruptLevel;

            if (bPCIadapter)
              stDCBheader.stComDCB.wIObaseAddress = awPorts[wDCBindex];
            else
              {
              /*
              **  Transfer load flag interrupt status/ID bits to device flags
              */
              stDCBheader.stComDCB.wConfigFlags1 |= (wLoadFlags & LOAD_FLAG1_INT_ID_LOAD_MASK);
              }
#ifndef NO_RESOURCE_MGR
            if (!bDisableRM)
              {
              /*
              ** Test if interrupt status register is inside UART address space
              */
              if ((_wIntIDregister == 0) ||
                  (_wIntIDregister >= stDCBheader.stComDCB.wIObaseAddress) &&
                  (_wIntIDregister <= (stDCBheader.stComDCB.wIObaseAddress + 7)))
                  bSeparateIDreg = FALSE;
//  _asm int 3
              if ((rc = RMHELP_GetPorts(&stDCBheader,wLoadCount)) != 0)
                {
                if (rc != 0xffff)
                  {
                  bPrevErrorMsg = TRUE;
                  goto gtNextDCBheader;
                  }
                }
              }
#endif
            /*
            ** if starting header address is not defined then define it
            ** and set dummy header to point to it
            */
            if (pStart == NULL)
              pStart = &pDeviceParms->stDeviceHeader;
            /*
            ** Initialized device headers
            */
            MemCopy((BYTE _far *)&pDeviceParms->stDeviceHeader.abyDeviceName,(BYTE *)(stDCBheader.abyPortName),8);
            pDeviceParms->stDeviceHeader.StrategyOffset = wDeviceStrategy;
            abyCOMnumbers[wLoadCount] = (BYTE)atoi(&stDCBheader.abyPortName[3]);
            if (pPrevious != NULL)
              pPrevious->pNextHeader = &pDeviceParms->stDeviceHeader;
#ifndef NO_COMscope
            if (stDCBheader.stComDCB.wConfigFlags1 & CFG_FLAG1_COMSCOPE)
              {
              if (stDCBheader.stComDCB.wCOMscopeBuffLen != 0)
                ulRequiredBufferSpace += stDCBheader.stComDCB.wCOMscopeBuffLen;
              else
                ulRequiredBufferSpace += DEF_COMscope_BUFF_LEN;
              MemCopy((BYTE _far *)&pDeviceParms->stCOMscopeHeader.abyDeviceName,(BYTE *)(stDCBheader.abyPortName),8);
              pDeviceParms->stCOMscopeHeader.StrategyOffset = wCOMscopeStrategy;
              MakeCOMscopeName(pDeviceParms->stCOMscopeHeader.abyDeviceName);
              pDeviceParms->stDeviceHeader.pNextHeader = &pDeviceParms->stCOMscopeHeader;
              pPrevious = &pDeviceParms->stCOMscopeHeader;
              pPrevious->pNextHeader = (VOID *)-1;
              }
            else
#endif
              {
              pPrevious = &pDeviceParms->stDeviceHeader;
              pPrevious->pNextHeader = (VOID *)-1;
              }
            if (stDCBheader.stComDCB.wReadBufferLength != 0)
              {
              ulRequiredBufferSpace += stDCBheader.stComDCB.wReadBufferLength;
              if (stDCBheader.stComDCB.wReadBufferLength == 0xffff)
                ulRequiredBufferSpace++;
              }
            else
              ulRequiredBufferSpace += DEF_READ_BUFF_LEN;
            if (stDCBheader.stComDCB.wWrtBufferLength != 0)
              ulWriteBufferSpace += stDCBheader.stComDCB.wWrtBufferLength;
            else
              ulWriteBufferSpace += DEF_WRITE_BUFF_LEN;
            MemCopy((BYTE *)(&stConfigParms[wLoadCount]),(BYTE *)(&stDCBheader.stComDCB),sizeof(COMDCB));
            pDeviceParms++;
#ifndef NO_COMscope
            wCOMscopeStrategy += 6;
#endif
            wDeviceStrategy += 6;
            wLoadCount++;
            }
gtNextDCBheader:
          if (bPCIadapter)
            {
            // write back I/O addresses
            DosChgFilePtr(hFile,ulFilePosition,0,&ulFilePosition);
            if ((ulFileError = DosWrite(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount)) != 0)
              {
              VioWrtTTY(chFailedWriteIni,StringLength(chFailedWriteIni),0);
              ulFileError |= ERR_FILE_WRITE;
              goto gtEarlyOut;
              }
            }
          DosChgFilePtr(hFile,(LONG)stDCBheader.oNextDCBheader,0,&ulFilePosition);
          }
        if (wLoadCount > 0)
          {
          _wEndOfData = ((WORD)_stDeviceParms + (wLoadCount * sizeof(DEVDEF)));
          ulAvailableBufferSpace = (0x10000 - (ulWriteBufferSpace + (ULONG)_wEndOfData));
          if (ulRequiredBufferSpace >= ulAvailableBufferSpace)
            bUseDDdataSegment = FALSE;
          pDeviceParms--;
          _stDummyHeader.pNextHeader = pStart;
#ifdef this_junk
          _stDummyHeader.sCodeSegment = pDeviceParms->stDeviceHeader.sCodeSegment;
 #ifndef NO_COMscope
          if (pDeviceParms->stDeviceHeader.pNextHeader != 0xffff)
            pDeviceParms->stCOMscopeHeader.sCodeSegment = 0xffff;
          else
 #endif
            pDeviceParms->stDeviceHeader.sCodeSegment = 0xffff;
#endif
          wLoadNumber = (wIndex + 1);
#ifndef NO_RESOURCE_MGR
          if (!bDisableRM)
            {
            if (bSeparateIDreg)
              {
//              RMHELP_CreateStatusPort();
              if (RMHELP_GetStatusPort() != 0)
                {
                wLoadCount = 0;
                goto gtEarlyOut;
                }
              RMHELP_StatusPortInitComplete();
              }
            }
#endif
          if (bABIOSpresent && bIsTheFirst)
            VerifyABIOSdefinitions(wLoadCount);
          break;
          }
        }
      else
        DosChgFilePtr(hFile,(LONG)stConfigHeader.oNextCFGheader,0,&ulFilePosition);
      }
gtEarlyOut:
    if (wLoadCount == 0)
      {
#ifndef NO_RESOURCE_MGR
      if (!bDisableRM)
        RMHELP_DestroyDriver();
#endif
//#ifdef OEM
      if (ulFileError == 0)
        {
//#endif
        if (!bPrevErrorMsg)
          {
          VioWrtTTY(chFailedIniNotInit_1,StringLength(chFailedIniNotInit_1),0);
          VioWrtTTY(_abyPath,StringLength(_abyPath),0);
          VioWrtTTY(chFailedIniNotInit_2,StringLength(chFailedIniNotInit_2),0);
          }
        wLoadNumber = NO_DEFINED_DEVICES;
//#ifdef OEM
        }
      else
        wLoadNumber = FILE_ACCESS_ERROR;
//#endif
      }
    DosClose(hFile);
    }
  _abyPath[wSaveExt++] = abySaveExt[0];
  _abyPath[wSaveExt++] = abySaveExt[1];
  _abyPath[wSaveExt++] = abySaveExt[2];
  _abyPath[wSaveExt] = abySaveExt[3];
  if (ulFileError != 0)
    DosSleep(1000);
  return;
  }

void VerifyABIOSdefinitions(WORD wLoadCount)
  {
  WORD wDCBindex;
  WORD wIndex;
  WORD wTemp;

  for (wDCBindex = 0;wDCBindex < wLoadCount;wDCBindex++)
    {
    if (LIDtable[wDCBindex].fFlags & LID_ALREADY_OWNED)
      {
      wTemp = LIDtable[wDCBindex].wBaseAddress;
      for (wIndex = 0;wIndex < 8;wIndex++)
      if (stConfigParms[wIndex].wIObaseAddress == wTemp)
        {
        stConfigParms[wIndex].wIObaseAddress = PORT_LID_ALREADY_OWNED;
        break;
        }
      }
    else
      {
      if (stConfigParms[wDCBindex].wIObaseAddress != PORT_USER_DISABLED)
        {
        wTemp = stConfigParms[wDCBindex].wIObaseAddress;
        for (wIndex = 0;wIndex < 8;wIndex++)
          if (astMCAportTable[wIndex].wAddress == wTemp)
            break;
        if (wIndex < 8)
          {
          for (wIndex = 0;wIndex < 8;wIndex++)
            if (LIDtable[wIndex].wBaseAddress == wTemp)
              break;
          if (wIndex >= 8)
            stConfigParms[wDCBindex].wIObaseAddress = PORT_ADDRESS_INVALID;
          else
            {
            MemCopy(_szName,_stDeviceParms[wDCBindex].stDeviceHeader.abyDeviceName,8);
            _szName[8] = 0;
            if (AttachDD(_szName,&_stAttachDD) == DRIVER_ATTACHED)
              {
              if (LIDtable[abyCOMnumbers[wDCBindex] - 1].wBaseAddress != wTemp)
                stConfigParms[wDCBindex].wIObaseAddress = PORT_ADDRESS_TAKEN;
              }
            else
              {
              for (wIndex = 0;wIndex < 8;wIndex++)
                if (LIDtable[wIndex].wBaseAddress == wTemp)
                  {
                  if (LIDtable[wIndex].bNameTaken)
                    stConfigParms[wDCBindex].wIObaseAddress = PORT_ADDRESS_TAKEN;
                  break;
                  }
              }
            }
          }
        }
      }
    }
  }

#ifndef x16_BIT
#ifndef RTEST
BYTE GetDeviceInterrupt(WORD wLID);
WORD GetDeviceBlockOffset(WORD wLID);
WORD GetDeviceBlockLen(WORD wLID);
WORD GetKernalData(WORD wLID,WORD wSrcOffset,BYTE *pDest,ULONG ulCount );
WORD GetDeviceAddress(WORD wLID);
WORD _far GetLIDentry(WORD *pwLID);
void FreeLIDentry(WORD wLID);

int iLIDcount = 0;

void _far BuildLIDtable(void)
  {
  int iIndex;
  WORD wError;
  DEVBLK *pstDevBlock;
  WORD wBlockLen;
  WORD wOffset;
  BOOL bDone;
  int iLastAvailable = -1;
  int iFirstAvailable = -1;
  BOOL bDeviceOwned = FALSE;
  BOOL bDeviceAvailable = FALSE;
  WORD *pWord = (WORD *)abyFileBuffer;
  WORD wMaxCount;
  WORD wSaveExt;
  char abySaveExt[4];
  WORD wLID;
#ifdef _32bitAPI
  ULONG ulAction;
  ULONG ulCount;
#else
  WORD ulAction;
  WORD ulCount;
#endif

  for (iIndex = 0;iIndex < 8;iIndex++)
    {
    iLIDcount++;
    wLID = iIndex + 1;
    if ((wError = GetLIDentry(&wLID)) == NO_ERROR)
      {
      bDeviceAvailable = TRUE;
      LIDtable[iIndex].wDeviceNumber = (iIndex + 1);
      LIDtable[iIndex].wLID = wLID;
      LIDtable[iIndex].fFlags = LID_AVAILABLE;
      LIDtable[iIndex].wBaseAddress = GetDeviceAddress(wLID);
      LIDtable[iIndex].wBlockLen = GetDeviceBlockLen(wLID);
      LIDtable[iIndex].wDevBlkOffset = GetDeviceBlockOffset(wLID);
      LIDtable[iIndex].byInterruptLevel = GetDeviceInterrupt(wLID);
      }
    else
      if (wError == ERROR_LID_ALREADY_OWNED)
        {
        bDeviceOwned = TRUE;
        LIDtable[iIndex].wDeviceNumber = (iIndex + 1);
        LIDtable[iIndex].fFlags |= LID_ALREADY_OWNED;
        }
      else
        if (wError == ERROR_LID_DOES_NOT_EXIST)
          {
          iLIDcount--;
          break;
          }
    }
  for (;iIndex < 8;iIndex++)
    LIDtable[iIndex].fFlags |= LID_DOES_NOT_EXIST;

  if (bDeviceOwned && bDeviceAvailable)
    {
    for (iIndex = 0;iIndex < iLIDcount;iIndex++)
      {
      if (LIDtable[iIndex].fFlags & LID_ALREADY_OWNED)
        {
        if (iLastAvailable != -1)
          {
          wLID = LIDtable[iLastAvailable].wLID;
          wBlockLen = LIDtable[iLastAvailable].wBlockLen;
          wOffset = (wBlockLen + LIDtable[iLastAvailable].wDevBlkOffset);
          GetKernalData(wLID,wOffset,abyFileBuffer,(wBlockLen * (iIndex - iLastAvailable)));
          bDone = FALSE;
          pWord = (WORD *)&abyFileBuffer[wBlockLen * (iIndex - iLastAvailable - 1)];
          while (!bDone)
            {
            wMaxCount = wBlockLen;
            while (*pWord != wBlockLen)
              {
              if (--wMaxCount == 0)
                return;
              pWord++;
              }
            pstDevBlock = (DEVBLK *)pWord;
            if (pstDevBlock->wDeviceID == ASYNC_DEVICE_ID)
              bDone = TRUE;
            }
          LIDtable[iIndex].wBaseAddress = pstDevBlock->wDataArea;
          }
        }
      else
        {
        if (iFirstAvailable == -1)
          iFirstAvailable = iIndex;
        iLastAvailable = iIndex;
        }
      }
    if (iFirstAvailable > 0)
      {
      wLID = LIDtable[iFirstAvailable].wLID;
      wBlockLen = LIDtable[iFirstAvailable].wBlockLen;
      wOffset = LIDtable[iFirstAvailable].wDevBlkOffset;
      wOffset -= ((wBlockLen * (iFirstAvailable + 1)) - 8);
      GetKernalData(wLID,wOffset,abyFileBuffer,(wBlockLen * (iFirstAvailable + 2)));
      pWord = (WORD *)abyFileBuffer;
      pWord--;
      wMaxCount = (wBlockLen * 3);
      for (iIndex = iFirstAvailable;iIndex > 0;iIndex--)
        {
        pWord++;
        bDone = FALSE;
        while (!bDone)
          {
          while (*pWord != wBlockLen)
            {
            if (--wMaxCount == 0)
              return;
            pWord++;
            }
          pstDevBlock = (DEVBLK *)pWord;
          if ((pstDevBlock->wDeviceID == ASYNC_DEVICE_ID) &&
              (pstDevBlock->wLogicalID == (wLID - iIndex)))
            bDone = TRUE;
          }
        wMaxCount = wBlockLen;
        LIDtable[iFirstAvailable - iIndex].wBaseAddress = pstDevBlock->wDataArea;
        }
      }
    }
  for (iIndex = 0;iIndex < 8;iIndex++)
    {
    if (LIDtable[iIndex].fFlags & LID_AVAILABLE)
      {
      wLID = LIDtable[iIndex].wLID;
      FreeLIDentry(wLID);
      }
    }
  if (iLIDcount > 0)
    {
//_asm INT 3
    for (iIndex = 0;iIndex < iLIDcount;iIndex++)
      {
      sprintf(_szName,0,"COM%d    ",(iIndex + 1));
      if (AttachDD(_szName,&_stAttachDD) == DRIVER_ATTACHED)
        LIDtable[iIndex].bNameTaken = TRUE;
      }
    iIndex = 0;
    while (iIndex < (CCHMAXPATH - 8))
      {
      if (_abyPath[iIndex] == ' ')
        break;
      if (_abyPath[iIndex] == 0)
        break;
      iIndex++;
      }
    while (_abyPath[iIndex] != '.')
      if (iIndex-- == 0)
        {
        VioWrtTTY(chFailedBadPath,StringLength(chFailedBadPath),0);
        return;
        }
    wSaveExt = ++iIndex;
    abySaveExt[0] = _abyPath[iIndex];
    _abyPath[iIndex] = 'M';
    abySaveExt[1] = _abyPath[++iIndex];
    _abyPath[iIndex] = 'A';
    abySaveExt[2] = _abyPath[++iIndex];
    _abyPath[iIndex] = 'P';
    abySaveExt[3] = _abyPath[++iIndex];
    _abyPath[iIndex] = 0;
    if (DosOpen(_abyPath,&hFile,&ulAction,0L,0,0x0012,0x1012,0L) == 0)
      {
      DosWrite(hFile,&LIDtable,(sizeof(LIDTAB) * 8),&ulCount);
      DosClose(hFile);
      }
    _abyPath[wSaveExt++] = abySaveExt[0];
    _abyPath[wSaveExt++] = abySaveExt[1];
    _abyPath[wSaveExt++] = abySaveExt[2];
    _abyPath[wSaveExt] = abySaveExt[3];
    }
  }

void _far LoadHeadersFromABIOStable(void)
  {
  int iIndex;
  WORD wMaxDevice;

  if (_wMaxDeviceCount == 0)
    wMaxDevice = 8;
  else
    wMaxDevice = _wMaxDeviceCount;
  pDeviceParms = (DEVDEF _far *)_stDeviceParms;
  wDeviceStrategy = (WORD)&_pDeviceStrategy;
  pStart = &pDeviceParms->stDeviceHeader;
  pPrevious = &_stDummyHeader;
  for (iIndex = 0;iIndex < iLIDcount;iIndex++)
    {
    if (LIDtable[iIndex].fFlags & LID_DOES_NOT_EXIST)
      break;
    if ((LIDtable[iIndex].fFlags & LID_ALREADY_OWNED) == 0)
      {
      sprintf(_szName,0,"COM%u    ",(iIndex + 1));
      MemCopy(pDeviceParms->stDeviceHeader.abyDeviceName,_szName,8);
      if (!LIDtable[iIndex].bNameTaken)
        {
        abyCOMnumbers[wLoadCount] = (BYTE)(iIndex + 1);
        stConfigParms[wLoadCount].wIObaseAddress = LIDtable[iIndex].wBaseAddress;
        stConfigParms[wLoadCount].byInterruptLevel = LIDtable[iIndex].byInterruptLevel;
        astInstallParms[wLoadCount].wLID = LIDtable[iIndex].wDeviceNumber;
        pDeviceParms->stDeviceHeader.StrategyOffset = wDeviceStrategy;
        pPrevious->pNextHeader = &pDeviceParms->stDeviceHeader;
        pPrevious = &pDeviceParms->stDeviceHeader;
        pPrevious->pNextHeader = (VOID *)-1;
        pDeviceParms++;
        wDeviceStrategy += 6;
        if (++wLoadCount >= wMaxDevice)
          break;
        }
      }
    }
  if (wLoadCount > 0)
    {
    pDeviceParms--;
//    pDeviceParms->stDeviceHeader.sCodeSegment = 0xffff;
    _stDummyHeader.pNextHeader = pStart;
    }
//  else
//    _stDummyHeader.sCodeSegment = -1;
  _wEndOfData = ((WORD)_stDeviceParms + (wLoadCount * sizeof(DEVDEF)));
  }

#ifdef this_junk
WORD CopyDeviceBlocks(WORD *pwBlockLen)
  {
  int iIndex;
  int iFirstIndex;
  WORD wBlockLen = 0;
  WORD wStartOffset;
  WORD wOffset = 0;
  WORD wFirstLID;
  WORD wError;
  WORD wLIDcount = 0;
  WORD wTableSize = 0;
  WORD wByteIndex;
  int iLastIndex;

  for (iIndex = 0;iIndex < wMaxDevice;iIndex++)
    {
    wLIDcount++;
    wLID = iIndex + 1;
    if ((wError = GetLIDentry(&wLID)) == NO_ERROR)
      {
      wBlockLen = GetDeviceBlockLen(wLID);
      wStartOffset = GetDeviceBlockOffset(wLID);
      break;
      }
    else
      if (wError == ERROR_LID_DOES_NOT_EXIST)
        {
        wLIDcount--;
        break;
        }
    }
  if (wStartOffset != 0)
    {
    wFirstLID = wLID;
    iFirstIndex = iIndex++;
    for (;iIndex < 8;iIndex++)
      {
      wLID = iIndex + 1;
      wLIDcount++;
      if ((wError = GetLIDentry(&wLID)) == NO_ERROR)
        {
        wOffset = GetDeviceBlockOffset(wLID);
        FreeLIDentry(wLID);
        break;
        }
      else
        if (wError == ERROR_LID_DOES_NOT_EXIST)
          {
          wLIDcount--;
          break;
          }
      }
    if (wOffset != 0)
      {
      wBlockLen = ((wOffset - wStartOffset) / (iIndex - iFirstIndex));
      wOffset = (wStartOffset - (iFirstIndex * wBlockLen));
      GetKernalData(wFirstLID,wOffset,abyFileBuffer,(wBlockLen * 8));
      FreeLIDentry(wFirstLID);
      }
    else
      {
      iLastIndex = iIndex;
      wTableSize = GetKernalData(wFirstLID,0,abyFileBuffer,0xffff);
      if (wFirstIndex == 0)
        {
        if (wLIDcount == 1)
          wBlockLen = GetDeviceBlockLen(wFirstLID);
        else
          {
          wCurrentAddress = GetDeviceAddress(wFirstLID);
          for (iIndex = 0;iIndex < 8;iIndex++)
            if (wCurrentAddress == astMCAportTable[iIndex]
              {
              iIndex++;
              break;
              }
          if ((wBlockSize * 9) < wTableSize)
            wTableSize = (wBlockSize * 9);
          for (;iIndex < 8;iIndex++)
            {
            wSearchAddress = astMCAportTable[iIndex]
            for (wByteIndex = wStartOffset;wByteIndex < wTableSize;wByteIndex++)
              {
              if ((abyFileBuffer[wByteIndex] == wSearchAddress) &&
                  (abyFileBuffer[wByteIndex - 0x000c] == wBlockLen) &&
                  (abyFileBuffer[wByteIndex - 0x0008] == ASYNC_DEVICE_ID))
                {
                wBlockLen = (wByteIndex - 0x000c - wStartOffset);
                GetKernalData(wFirstLID,wStartOffset,abyFileBuffer,(wBlockLen * 8));
                FreeLIDentry(wFirstLID);
                break;
                }
              }
            }
          }
        }
      else
        {
        }
      }
    }
  *pwBlockLen = wBlockLen;
  return(wLIDcount);
  }
#endif
#endif /* RTEST */
#endif /* x16_BIT */
