#include "COMMON.H"

#include "COMDD.H"

void DumpIni(char szFileSpec[], BOOL bDumpSpare);
void DumpLIDmap(char szFileSpec[]);

char szFileSpec[CCHMAXPATH] = {0,0};
BOOL bDumpSpare = FALSE;
BOOL bDumpLIDmap = FALSE;
BOOL bShowSignature = FALSE;

char szLine[200];

void PrintHelp(void)
  {
  printf("\nUSAGE: IniDump ini_file_spec (.INI is default extension)\n"
         "or\n"
         "IniDump LID_map_file_spec M (.MAP is default extension\n\n"
         "If no file_spec is given then the COMi configuration file used by the current\n"
         "COMi load will be dumped.\n");
  }

void main(int argc, char *argv[])
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

  if (argc >= 2)
    {
    if ((argv[1][0] == '?') ||
        (argv[1][1] == '?'))
      {
      PrintHelp();
      return;
      }
    if ((argv[1][0] != '/') && (argv[1][0] != '-'))
      strcpy(szFileSpec,argv[1]);
    for (iIndex = 1;iIndex < argc;iIndex++)
      {
      if ((argv[iIndex][0] == '/') || (argv[iIndex][0] == '-'))
        {
        switch (argv[iIndex][1] & 0xdf)
          {
          case 'X':
            bDumpSpare = TRUE;
            break;
          case 'M':
            bDumpLIDmap = TRUE;
            break;
          case 'S':
            bShowSignature = TRUE;
          }
        }
      }
    }

  if (strlen(szFileSpec) == 0)
    {
    if ((rc = DosOpen(SPECIAL_DEVICE,&hCom,&ulAction,0L,0L,0x0001,0x21c2,0L)) != NO_ERROR)
      {
      printf("COMi is not currently loaded.  You must supply a file specification to dump\n");
      return;
      }
    if ((rc = DosAllocMem((PPVOID)&pstData,(sizeof(EXTDATA) + MAX_DD_PATH),PAG_COMMIT | PAG_READ | PAG_WRITE)) != 0)
      {
      printf("Error Allocating Memory for DD PATH - %X\n",rc);
      DosClose(hCom);
      return;
      }
    else
      {
      /*
      **  Get device driver path
      */
      stParams.wSignature = 0;//SIGNATURE;
      stParams.wDataCount = MAX_DD_PATH;
      stParams.wCommand = EXT_CMD_GET_PATH;
      stParams.wModifier = 0;
      ulDataLen = (ULONG)(sizeof(EXTDATA) + MAX_DD_PATH);
      ulParmLen = (ULONG)sizeof(EXTPARM);
      if ((rc = DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,pstData,(sizeof(EXTDATA) + MAX_DD_PATH),&ulDataLen)) != 0)
        {
        printf("DOS error accessing \"get path\" extension - %X",rc);
        DosFreeMem(pstData);
        DosClose(hCom);
        return;
        }
      else
        {
        if (pstData->wReturnCode != EXT_RSP_SUCCESS)
          {
          if ((pstData->wReturnCode & EXT_BAD_SIGNATURE) != EXT_BAD_SIGNATURE)
            {
            printf("Extension Access Error - %04X-%04X",stParams.wCommand,pstData->wReturnCode);
            DosFreeMem(pstData);
            DosClose(hCom);
            return;
            }
          rc = pstData->wReturnCode;
          }
        }
      pByte = (BYTE *)(&pstData->wData);
      for (iIndex = 0;iIndex < (CCHMAXPATH - 1);iIndex++)
        {
        szFileSpec[iIndex] = toupper(*pByte);
        if (*(pByte++) == ' ')
          break;
        }
      szFileSpec[iIndex] = 0;
      while (szFileSpec[--iIndex] != '.')
        {
        if (iIndex == 0)
          {
          while (szFileSpec[iIndex++] != 0);
          szFileSpec[--iIndex] = '.';
          break;
          }
        }
      szFileSpec[++iIndex] = 'I';
      szFileSpec[++iIndex] = 'N';
      szFileSpec[++iIndex] = 'I';
      szFileSpec[++iIndex] = 0;
      }
    }
  else
    {
    for (iIndex = (strlen(szFileSpec) - 1);iIndex >= 0;iIndex--)
      {
      if (szFileSpec[iIndex] == '.')
        break;
      if (szFileSpec[iIndex] == '\\')
        break;
      }
    if (szFileSpec[iIndex] != '.')
      {
      iIndex = strlen(szFileSpec);
      if (!bDumpLIDmap)
        {
        szFileSpec[iIndex++] = '.';
        szFileSpec[iIndex++] = 'I';
        szFileSpec[iIndex++] = 'N';
        szFileSpec[iIndex++] = 'I';
        szFileSpec[iIndex++] = 0;
        }
      else
        {
        szFileSpec[iIndex++] = '.';
        szFileSpec[iIndex++] = 'M';
        szFileSpec[iIndex++] = 'A';
        szFileSpec[iIndex++] = 'P';
        szFileSpec[iIndex++] = 0;
        DumpLIDmap(szFileSpec);
        return;
        }
      }
    }
  DumpIni(szFileSpec, bDumpSpare);
  }
/*****************
**
**  test and fix newline
**
**  USAGE:
**          if ((iLen = TestNewLine(iLen,40)) == 0)
**            printf(szLine);
**
***************************/
int TestNewLine(int iLineLen,int iNextLen)
  {
  if (iLineLen > (80 - iNextLen))
    {
    sprintf(&szLine[iLineLen],"\n");
//    printf(szLine);
    iLineLen = 0;
    }
  else
    iLineLen += sprintf(&szLine[iLineLen],", ");
  return(iLineLen);
  }

void DumpIni(char szFileSpec[], BOOL bDumpSpare)
  {
  int iIndex;
  ULONG ulStatus;
  HFILE hFile;
  APIRET rc;
  WORD wIndex;
  WORD wCFGindex;
  ULONG ulCount;
  CFGINFO stConfigInfo;
  CFGHEAD stConfigHeader;
  DCBHEAD stDCBheader;
  ULONG ulFilePosition;
  char szState[20];
  int iLen;

  if ((rc = DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0312,(PEAOP2)0L)) == NO_ERROR)
    {
    if ((rc = DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount)) == NO_ERROR)
      {
      if (bShowSignature)
        printf("\nSignature = %u",stConfigInfo.ulSignature);
      printf("\nCOMi load header count = %u\nFlags = %04X",stConfigInfo.wCFGheaderCount, stConfigInfo.wFlags);
      iLen = 0;
      if (stConfigInfo.byOEMtype != 0)
        iLen += sprintf(szLine,"\nDriver OEM type = %u, ",stConfigInfo.byOEMtype);
      if (stConfigInfo.byNextPCIslot != 0)
        iLen += sprintf(szLine,"Next PCI slot = %u",stConfigInfo.byNextPCIslot);
      else
        szLine[iLen - 2] = 0;
      if (iLen != 0)
        {
        sprintf(&szLine[iLen],"\n");
        printf(szLine);
        }
      if (bDumpSpare)
        if (!isalnum(stConfigInfo.MISC.abyData[0]))
          {
          iLen = 0;
          for (iIndex = 0;iIndex < (INI_MISC_DATA_SIZE / 2);iIndex++)
            iLen += sprintf(&szLine[iLen],"0x%02X ",stConfigInfo.MISC.abyData[iIndex]);
          szLine[iLen - 1] = '\n';
          szLine[iLen] = 0;
          printf(szLine);
          iLen = 0;
          for (;iIndex < INI_MISC_DATA_SIZE;iIndex++)
            iLen += sprintf(&szLine[iLen],"0x%02X ",stConfigInfo.MISC.abyData[iIndex]);
          szLine[iLen - 1] = '\n';
          szLine[iLen] = 0;
          printf(szLine);
          }
        else
          {
          printf(stConfigInfo.MISC.abyData);
          printf("\n");
          if ((iIndex = strlen(stConfigInfo.MISC.abyData)) < (INI_MISC_DATA_SIZE - 1))
            {
            if (iIndex < 15)
              {
              iLen = 0;
              for (;iIndex < (INI_MISC_DATA_SIZE / 2);iIndex++)
                iLen += sprintf(&szLine[iLen],"0x%02X ",stConfigInfo.MISC.abyData[iIndex]);
              szLine[iLen - 1] = '\n';
              szLine[iLen] = 0;
              printf(szLine);
              }
            iLen = 0;
            for (;iIndex < INI_MISC_DATA_SIZE;iIndex++)
              iLen += sprintf(&szLine[iLen],"0x%02X ",stConfigInfo.MISC.abyData[iIndex]);
            szLine[iLen - 1] = '\n';
            szLine[iLen] = 0;
            printf(szLine);
            }
          }
      if (stConfigInfo.wCFGheaderCount >= 1)
        {
        DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
        for (wCFGindex = 0;wCFGindex < stConfigInfo.wCFGheaderCount;wCFGindex++)
          {
          DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
          if (stConfigHeader.bHeaderIsInitialized)
            {
            printf("\n---------------------------- COMi load header number %u ------------------------\n",(wCFGindex + 1));
            printf("Device count = %u, User delay = %u, Adapter type = %u\n",
                      stConfigHeader.wDeviceCount, stConfigHeader.wDelayCount,
                      stConfigHeader.byAdapterType);
            iLen = 0;
            if (stConfigHeader.byInterruptLevel != 0)
              {
              if (stConfigHeader.wIntIDregister != 0)
                printf("Shared IRQ = %u, interrupt status/ID register = 0x%X.\n",
                     stConfigHeader.byInterruptLevel,stConfigHeader.wIntIDregister);
              else
                if (stConfigHeader.byAdapterType == HDWTYPE_PCI)
                  printf("Shared IRQ = %u\n", stConfigHeader.byInterruptLevel);
                else
                  printf("Shared IRQ = %u, no status register defined\n", stConfigHeader.byInterruptLevel);
              if (stConfigHeader.wIntAlgorithim != 0)
                printf("Algorithim = %u, entry vector = %u, exit vector = %u.\n",
                     stConfigHeader.wIntAlgorithim,stConfigHeader.wOEMentryVector,stConfigHeader.wOEMexitVector);
              }
            if (stConfigHeader.byAdapterType == HDWTYPE_PCI)
              printf("PCI slot %d, vendor = 0x%04X, device = 0x%04X\n",stConfigHeader.byPCIslot,
                                                                       stConfigHeader.wPCIvendor,
                                                                       stConfigHeader.wPCIdevice);
            printf("Load flags = 0x%04X\n",stConfigHeader.wLoadFlags);
            DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
            for (wIndex = 0;wIndex < stConfigHeader.wDCBcount;wIndex++)
              {
              DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
              if (stDCBheader.bHeaderIsInitialized)
                {
                printf("------------------------- Device DCB header number %u -------------------------\n",(wIndex + 1));
                for (iIndex = 0;iIndex < 8;iIndex++)
                  if (stDCBheader.abyPortName[iIndex] == ' ')
                    break;
                stDCBheader.abyPortName[iIndex] = 0;
                printf("%s is configured, Optionflags1 = %04X, Optionflags2 = %04X\n",
                      stDCBheader.abyPortName,stDCBheader.wOptionFlags1,stDCBheader.wOptionFlags2);
                printf("DeviceCFGflags1 = %04X, DeviceCFGflags2 = %04X\n",
                      stDCBheader.stComDCB.wConfigFlags1,stDCBheader.stComDCB.wConfigFlags2);
                iLen = sprintf(szLine, "BaseAddr = 0x%X",stDCBheader.stComDCB.wIObaseAddress);
                if (stConfigHeader.byInterruptLevel == 0)
                  iLen += sprintf(&szLine[iLen],", IRQ = %d",stDCBheader.stComDCB.byInterruptLevel);
                if ((stDCBheader.stComDCB.wFlags1 & 0x8000) != 0)
                  iLen += sprintf(&szLine[iLen],", DCBflag1 = 0x%02X",(BYTE)stDCBheader.stComDCB.wFlags1);
                if ((stDCBheader.stComDCB.wFlags2 & 0x8000) != 0)
                  iLen += sprintf(&szLine[iLen],", DCBflag2 = 0x%02X",(BYTE)stDCBheader.stComDCB.wFlags2);
                if ((stDCBheader.stComDCB.wFlags2 & 0x8000) != 0)
                  iLen += sprintf(&szLine[iLen],", DCBflag3 = 0x%02X",(BYTE)stDCBheader.stComDCB.wFlags3);
                printf(szLine);
                printf("\n");
                }
              DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
              }
//          printf("\n");
            }
          DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
          }
        }
      }
    else
      printf("\nUnable to read %s - rc = %u\n",szFileSpec,rc);
    DosClose(hFile);
    }
  else
    printf("\nUnable to open %s - rc = %u\n",szFileSpec,rc);
  }

void DumpLIDmap(char szFileSpec[])
  {
  int iIndex;
  ULONG ulStatus;
  HFILE hFile;
  APIRET rc;
  WORD wIndex;
  ULONG ulCount;
  LIDTAB stLIDtable;
  ULONG ulFilePosition;
  char szTaken[20];
  char szFlags[20];

  printf("\n");
  if ((rc = DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0312,(PEAOP2)0L)) == NO_ERROR)
    {
    for (wIndex = 0;wIndex < 8;wIndex++)
      {
      DosRead(hFile,(PVOID)&stLIDtable,sizeof(LIDTAB),&ulCount);
      if (stLIDtable.wLID != 0)
        {
        if (stLIDtable.bNameTaken)
          strcpy(szTaken,"Name Taken");
        else
          strcpy(szTaken,"Name Avail");
        switch (stLIDtable.fFlags)
          {
          case LID_ALREADY_OWNED:
            strcpy(szFlags,"LID already owned");
            break;
          case LID_DOES_NOT_EXIST:
            strcpy(szFlags,"LID does not exist");
            break;
          case LID_AVAILABLE:
            strcpy(szFlags,"LID available");
            break;
          default:
            strcpy(szFlags,"Unknown flag");
            break;
          }
        printf("Dev# = %u, Base Address = 0x%04X, IRQ = %u, %s, %s\n",stLIDtable.wDeviceNumber,
                  stLIDtable.wBaseAddress,stLIDtable.byInterruptLevel,szTaken,szFlags);
        printf("Offset = 0x%04X, Len = %u, LID = %u\n",
                  stLIDtable.wDevBlkOffset,stLIDtable.wBlockLen,stLIDtable.wLID);
        }
      }
    }
  else
    printf("\nUnable to open %s - rc = %u\n",szFileSpec,rc);
  }


