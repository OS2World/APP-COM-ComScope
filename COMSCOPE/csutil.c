#include "COMscope.h"

#include "remote.h"

extern CFG_INSTDEV pfnInstallDevice;

extern LONG lScrollCount;

extern COMICFG stCOMiCFG;

extern LONG lScrollCount;
extern WORD *pwScrollBuffer;

extern COMCTL stComCtl;

LONG CountTraceElement(USHORT usChar,USHORT usFlags);

MRESULT EXPENTRY fnwpDCBpacketDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpCOMeventStatesDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpCOMstatusStatesDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpXmitStatusStatesDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpCOMerrorStatesDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY COMscopeOpenFilterProc(HWND hwnd,ULONG message,MPARAM mp1,MPARAM mp2);

extern BOOL bSendNextKeystroke;
extern ULONG ulCOMscopeBufferSize;
extern ULONG ulMonitorSleepCount;
extern ULONG ulCalcSleepCount;
extern BOOL bDriverNotLoaded;
extern CSCFG stCFG;
extern TID tidMonitorThread;
extern TID tidDisplayThread;

extern SCREEN stRow;
extern IOCTLINST stIOctl;

extern BOOL bCOMscopeEnabled;
BOOL bPortActive = FALSE;

extern HWND hwndFrame;
extern HWND hwndClient;
extern CHAR szErrorMessage[];
extern HAB habAnchorBlock;
extern char szDriverIniPath[];

BOOL OpenPort(HWND hwndDlg,HFILE *phCom,CSCFG *pstCFG)
  {
  ULONG ulAction;
  char szMessage[80];
  char szCaption[80];
  char szCOMname[10];
  LONG lBaud;
  APIRET rc;
  DCB stComDCB;
  HMODULE hMod;

  if (bDriverNotLoaded)
    {
    if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) == NO_ERROR)
      {
      stCOMiCFG.pszPortName = pstCFG->szPortName;
      stCOMiCFG.bInstallCOMscope = TRUE;
      if (DosQueryProcAddr(hMod,0,"InstallDevice",(PFN *)&pfnInstallDevice) == NO_ERROR)
        pfnInstallDevice(&stCOMiCFG);
      DosFreeModule(hMod);
      }
    return(FALSE);
    }
  else
    {
    strcpy(szCOMname,pstCFG->szPortName);
    AppendTripleDS(szCOMname);
    if ((rc = DosOpen(szCOMname,phCom,&ulAction,0L,0L,0x0001,0x21c2,0L)) != 0)
      {
      switch (rc)
        {
        case ERROR_BAD_UNIT:
          sprintf(szCaption,"Device Uninstalled!");
          sprintf(szMessage,"%s was uninstalled at initialization by another device driver.",pstCFG->szPortName);
          WinMessageBox(HWND_DESKTOP,
                        hwndDlg,
                        szMessage,
                        szCaption,
                        0L,
                        MB_MOVEABLE | MB_OK | MB_CUAWARNING);
          break;
        case ERROR_DEVICE_IN_USE:
          sprintf(szCaption,"Device In Use!");
          sprintf(szMessage,"%s is currently being accessed by another COMscope session.",pstCFG->szPortName);
          WinMessageBox(HWND_DESKTOP,
                        hwndDlg,
                        szMessage,
                        szCaption,
                        0L,
                        MB_MOVEABLE | MB_OK | MB_CUAWARNING);
          break;
        case ERROR_SHARING_VIOLATION:
          sprintf(szCaption,"COMscope Resource Unavailable");
          sprintf(szMessage,"A resource required by %s is not available?",pstCFG->szPortName);
          WinMessageBox(HWND_DESKTOP,
                        hwndDlg,
                        szMessage,
                        szCaption,
                        HLPP_MB_COMSCOPE_SHARE_ERROR,
                        (MB_MOVEABLE | MB_OK | MB_HELP | MB_ICONQUESTION | MB_DEFBUTTON2));
           break;
        default:
          sprintf(szCaption,"COMscope Device Undefined");
          sprintf(szMessage,"Do you want to Install COMscope support %s?",pstCFG->szPortName);
          if (WinMessageBox(HWND_DESKTOP,
                            hwndDlg,
                            szMessage,
                            szCaption,
                            HLPP_MB_COMSCOPE_ENABLE,
                            (MB_MOVEABLE | MB_YESNO | MB_HELP | MB_ICONQUESTION | MB_DEFBUTTON2)) == MBID_YES)
            if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) == NO_ERROR)
              {
              stCOMiCFG.pszPortName = pstCFG->szPortName;
              stCOMiCFG.bInstallCOMscope = TRUE;
              if (DosQueryProcAddr(hMod,0,"InstallDevice",(PFN *)&pfnInstallDevice) == NO_ERROR)
                pfnInstallDevice(&stCOMiCFG);
              DosFreeModule(hMod);
              }
          break;
        }
      bPortActive = FALSE;
      return(FALSE);
      }
    if (!EnableCOMscope(hwndDlg,*phCom,&ulCOMscopeBufferSize,FALSE))
      {
      DosClose(*phCom);
      *phCom = -1;
      bPortActive = FALSE;
      return(FALSE);
      }
    MenuItemEnable(hwndFrame,IDM_MSLEEP,TRUE);
    if (GetDCB(&stIOctl,hCom,&stComDCB))
      return(FALSE);
    if ((stComDCB.Flags3 & F3_HDW_BUFFER_APO) == 0) // mask only
      MenuItemEnable(hwndFrame,IDM_FIFO,FALSE);
    else
      MenuItemEnable(hwndFrame,IDM_FIFO,TRUE);
    if (GetBaudRate(&stIOctl,hCom,&lBaud) == 0)
      CalcThreadSleepCount(lBaud);
    stComCtl.hCom = hCom;
    }
  bPortActive = TRUE;
  return(TRUE);
  }

void ErrorNotify(CHAR szMessage[])
  {
#ifdef debug
  if (!stCFG.bErrorOut)
#endif
    {
    strcpy(szErrorMessage,szMessage);
    WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
    if (!stCFG.bSilentStatus)
      DosBeep(1540,100);
    }
  }

void CalcThreadSleepCount(LONG lBaud)
  {
  // The maximum number of characters in the device's COMscope buffer, times the number
  // of milliseconds in a second, divided by the baud rate, divided by the number of
  // bits per character (character time for one stop bit, eight data bits, one stop
  // bit, no parity), times one read and one write character* (two).

  // *In full duplex transfers it is possible for two characters to be placed in the buffer
  //  for each character time.
  if (lBaud > 0)
    ulCalcSleepCount = ((ulCOMscopeBufferSize * 1000) / ((lBaud / 10) * 2));
  else
    ulCalcSleepCount = ((ulCOMscopeBufferSize * 1000) / 1);
//  if (ulCalcSleepCount > 3000)
//    ulCalcSleepCount = 3000;
  if (stCFG.ulUserSleepCount != 0)
    ulMonitorSleepCount = stCFG.ulUserSleepCount;
  else
    ulMonitorSleepCount = ulCalcSleepCount;
  }

void SendXonXoff(WORD wSignal)
  {
  DCB stComDCB;
  BYTE byTemp;

  GetDCB(&stIOctl,hCom,&stComDCB);
  if (wSignal == SEND_XON)
    byTemp = stComDCB.XonChar;
  else
    byTemp = stComDCB.XoffChar;

  SendByteImmediate(&stIOctl,hCom,byTemp);
  }

void IncrementFileExt(char szFileSpec[],BOOL bInit)
  {
  int iIndex;
  int iEndIndex;
  ULONG ulExtNumber;
  char *pcEnd;

  iEndIndex = (strlen(szFileSpec) - 1);
  for (iIndex = iEndIndex;iIndex >= (iEndIndex - 3);iIndex--)
    {
    if (szFileSpec[iIndex] == '.')
      {
      iIndex++;
      if (bInit)
        {
        strcpy(&szFileSpec[iIndex],"001");
        return;
        }
      ulExtNumber = strtol(&szFileSpec[iIndex],&pcEnd,16);
      ulExtNumber++;
      if (ulExtNumber > 0xfff)
        ulExtNumber = 0;
      sprintf(&szFileSpec[iIndex],"%03X",ulExtNumber);
      return;
      }
    }
  strcpy(&szFileSpec[iEndIndex + 1],".001");
  }

BOOL WriteCaptureFile(char szFileSpec[],WORD *pwBuffer,ULONG ulWordCount,LONG fWriteMode,LONG lHelp)
  {
  WORD wFileError;
  HFILE hFile;
  ULONG ulAction;
  FILESTATUS3 stFileInfo;
  char szMessage[100];
  char szCaption[80];
  ULONG ulOpenMode;
  ULONG ulOpenFlag;
  ULONG ulFilePosition;
  ULONG ulByteCount;

  if (fWriteMode & FOPEN_NEW_ONLY)
    ulOpenFlag = (OPEN_ACTION_FAIL_IF_EXISTS | OPEN_ACTION_CREATE_IF_NEW);
  else
    if (fWriteMode & FOPEN_EXISTS_ONLY)
      ulOpenFlag = (OPEN_ACTION_OPEN_IF_EXISTS | OPEN_ACTION_FAIL_IF_NEW);
    else
      ulOpenFlag = (OPEN_ACTION_OPEN_IF_EXISTS | OPEN_ACTION_CREATE_IF_NEW);
  ulOpenMode = (OPEN_FLAGS_SEQUENTIAL | OPEN_SHARE_DENYREADWRITE | OPEN_ACCESS_WRITEONLY);
gtNewFile:
  while ((wFileError = DosOpen(szFileSpec,&hFile,&ulAction,0L,0,ulOpenFlag,ulOpenMode,(PEAOP2)0L)) != 0)
    {
    switch (wFileError)
      {
      case ERROR_FILE_NOT_FOUND:
        sprintf(szCaption,"Cannot find file %s.",szFileSpec);
        break;
      case ERROR_PATH_NOT_FOUND:
        sprintf(szCaption,"Cannot find path %s.",szFileSpec);
        break;
      case ERROR_DISK_FULL:
        sprintf(szMessage,"Disk is full, unable to open %s for writing.",szFileSpec);
        ErrorNotify(szMessage);
        return(FALSE);
      case ERROR_ACCESS_DENIED:
        sprintf(szCaption,"Access denied for writing %s.",szFileSpec);
        break;
      default:
        sprintf(szCaption,"Failed to open %s. ec = %u",szFileSpec,wFileError);
        break;
      }
    sprintf(szMessage,"Would you like to select another?");
    if (WinMessageBox(HWND_DESKTOP,
                      hwndFrame,
                      szMessage,
                      szCaption,
                      0L,
                     (MB_MOVEABLE | MB_OKCANCEL | MB_ICONQUESTION | MB_DEFBUTTON1)) != MBID_OK)
      return(FALSE);
    if (!GetFileName(hwndClient,szFileSpec,"Select a different file.",COMscopeOpenFilterProc))
      return(FALSE);
    }
  if (!(fWriteMode & (FOPEN_APPEND | FOPEN_OVERWRITE)))
    {
    DosQueryFileInfo(hFile,1,&stFileInfo,sizeof(FILESTATUS3));
    if ((ulAction == FILE_EXISTED) && (stFileInfo.cbFile > 0))
      {
      sprintf(szCaption,"File already exists.");
      sprintf(szMessage,"The designated file %s already exists.\n\nDo you want to overwrite it?",szFileSpec);
      switch (WinMessageBox(HWND_DESKTOP,
                            hwndFrame,
                            szMessage,
                            szCaption,
                            lHelp,
                           (MB_MOVEABLE | MB_YESNOCANCEL | MB_HELP | MB_ICONQUESTION | MB_DEFBUTTON1)))
//                           (MB_MOVEABLE | MB_YESNOCANCEL | MB_ICONQUESTION | MB_DEFBUTTON1)))
        {
        case MBID_CANCEL:
          DosClose(hFile);
          return(FALSE);
        case MBID_NO:
          DosClose(hFile);
          if (!GetFileName(hwndClient,szFileSpec,"Select a different file.",COMscopeOpenFilterProc))
            return(FALSE);
          goto gtNewFile;
        case MBID_YES:
          DosSetFileSize(hFile,0L);
          break;
        }
      }
    }
  else
    if ((fWriteMode & FOPEN_APPEND) && (ulWordCount != 0))
      DosSetFilePtr(hFile,0L,FILE_END,&ulFilePosition);
    else
      if (fWriteMode & FOPEN_OVERWRITE)
        DosSetFileSize(hFile,0);

  ulByteCount = (ulWordCount * 2);
  if (ulByteCount > 0)
    {
    if ((wFileError = DosWrite(hFile,(PVOID)pwBuffer,ulByteCount,&ulByteCount)) != 0)
      {
      if (wFileError == ERROR_DISK_FULL)
        {
        if (stCFG.bCaptureToFile)
          sprintf(szMessage,"Disk is full, capture to file aborted.");
        else
          sprintf(szMessage,"Disk is full, unable to write to %s.",szFileSpec);
        ErrorNotify(szMessage);
        DosClose(hFile);
        return(FALSE);
        }
      sprintf(szMessage,"Write to %s failed. ec = %u",szFileSpec,wFileError);
      }
    else
      if (fWriteMode & FOPEN_APPEND)
        sprintf(szMessage,"%u total characters written to %s",((ulByteCount + ulFilePosition) / 2),szFileSpec);
      else
        sprintf(szMessage,"%u characters written to %s",(ulByteCount / 2),szFileSpec);
    ErrorNotify(szMessage);
    }
  DosClose(hFile);
  return(TRUE);
  }

BOOL ReadCaptureFile(char szFileSpec[],WORD **ppwBuffer,ULONG *pulWordCount,BOOL bAskLength)
  {
  WORD wFileError;
  HFILE hFile;
  ULONG ulAction;
  FILESTATUS3 stFileInfo;
  char szMessage[100];
  char szCaption[80];
  APIRET rc;
  ULONG ulOpenMode;
  ULONG ulOpenFlag;
  WORD *pwTemp;
  ULONG ulByteCount;

  ulOpenFlag = (OPEN_ACTION_OPEN_IF_EXISTS | OPEN_ACTION_FAIL_IF_NEW);
  ulOpenMode = (OPEN_FLAGS_SEQUENTIAL | OPEN_SHARE_DENYWRITE | OPEN_ACCESS_READONLY);
  while ((wFileError = DosOpen(szFileSpec,&hFile,&ulAction,0L,0,ulOpenFlag,ulOpenMode,(PEAOP2)0L)) != 0)
    {
    switch (wFileError)
      {
      case ERROR_FILE_NOT_FOUND:
        sprintf(szCaption,"Cannot find file %s.",szFileSpec);
        break;
      case ERROR_PATH_NOT_FOUND:
        sprintf(szCaption,"Cannot find path %s.",szFileSpec);
        break;
      case ERROR_ACCESS_DENIED:
        sprintf(szCaption,"Access denied for reading %s.",szFileSpec);
        break;
      default:
        sprintf(szCaption,"Failed to open %s. ec = %u",szFileSpec,wFileError);
        break;
      }
    sprintf(szMessage,"Would you like to select another?");
    if (WinMessageBox(HWND_DESKTOP,
                      hwndFrame,
                      szMessage,
                      szCaption,
                      0L,
                     (MB_MOVEABLE | MB_OKCANCEL | MB_ICONQUESTION | MB_DEFBUTTON1)) != MBID_OK)
      return(FALSE);
    if (!GetFileName(hwndClient,szFileSpec,"Select a different file.",COMscopeOpenFilterProc))
      return(FALSE);
    }
  DosQueryFileInfo(hFile,1,&stFileInfo,sizeof(FILESTATUS3));
  ulByteCount = (*pulWordCount * 2);
  if (ulByteCount > 0)
    {
    if (stFileInfo.cbFile > ulByteCount)
      {
      if (bAskLength)
        {
        sprintf(szCaption,"%s is larger than Buffer size.",szFileSpec);
        sprintf(szMessage,"Do you want to increase buffer size to accomodate size of file?");
        if (WinMessageBox(HWND_DESKTOP,
                          hwndFrame,
                          szMessage,
                          szCaption,
                          HLPP_MB_BUFF_SIZE,
                         (MB_MOVEABLE | MB_YESNO | MB_HELP | MB_ICONQUESTION | MB_DEFBUTTON1)) != MBID_YES)
          return(FALSE);
        }
      if ((rc = DosAllocMem((PPVOID)&pwTemp,stFileInfo.cbFile,PAG_COMMIT | PAG_READ | PAG_WRITE)) != 0)
        {
        if (rc == ERROR_NOT_ENOUGH_MEMORY)
          {
          sprintf(szCaption,"Out of Memory");
          sprintf(szMessage,"Unable to allocate enough memory to read file.");
          }
        else
          {
          sprintf(szCaption,"Memory allocation error. ec = %u",rc);
          sprintf(szMessage,"Unable to allocate memory to read file");
          }
        WinMessageBox(HWND_DESKTOP,
                      hwndFrame,
                      szMessage,
                      szCaption,
                      0L,
                     (MB_MOVEABLE | MB_OK | MB_ICONHAND));
        DosClose(hFile);
        return(FALSE);
        }
      DosFreeMem(*ppwBuffer);
      *ppwBuffer = pwTemp;
      }
    ulByteCount = stFileInfo.cbFile;
    if ((wFileError = DosRead(hFile,(PVOID)*ppwBuffer,ulByteCount,&ulByteCount)) != 0)
      sprintf(szMessage,"Read from %s failed. ec = %u",szFileSpec,wFileError);
    else
      sprintf(szMessage,"%u characters read from %s",(ulByteCount / 2),szFileSpec);
    ErrorNotify(szMessage);
    *pulWordCount = (ulByteCount / 2);
    }
  DosClose(hFile);
  return(TRUE);
  }

BOOL ProcessKeystroke(CSCFG *pstCFG,MPARAM mp1,MPARAM mp2)
  {
  static BOOL bAltKeyDown = FALSE;
  static int iKeyIndex;
  int iIndex;
  long lIncrement;
  static BYTE abyKeys[4];
  BYTE byChar;
  USHORT usFlags;
  MPARAM mpScrollDir;

  usFlags = SHORT1FROMMP(mp1);
  if (bSendNextKeystroke)
    {
    if (usFlags & KC_VIRTUALKEY)
      {
      byChar = SHORT2FROMMP(mp2);
      if (byChar == VK_ALT)
        {
        if (usFlags & KC_KEYUP)
          {
          if (bAltKeyDown)
            {
            bAltKeyDown = FALSE;
            if (iKeyIndex != 0)
              {
              abyKeys[iKeyIndex] = 0;
              SendByteImmediate(&stIOctl,hCom,(BYTE)atoi(abyKeys));
              bSendNextKeystroke = FALSE;
              MenuItemCheck(hwndFrame,IDM_SENDIMM,FALSE);
              return(TRUE);
              }
            }
          }
        else
          {
          if (!bAltKeyDown)
            {
            bAltKeyDown = TRUE;
            iKeyIndex = 0;
            }
          }
        }
      else
        {
        if (bAltKeyDown && (iKeyIndex < 3) && (usFlags & KC_KEYUP))
          {
          switch (byChar)
            {
            case VK_PAGEUP:
              abyKeys[iKeyIndex] = '9';
              break;
            case VK_UP:
              abyKeys[iKeyIndex] = '8';
              break;
            case VK_HOME:
              abyKeys[iKeyIndex] = '7';
              break;
            case VK_RIGHT:
              abyKeys[iKeyIndex] = '6';
              break;
            case VK_LEFT:
              abyKeys[iKeyIndex] = '4';
              break;
            case VK_PAGEDOWN:
              abyKeys[iKeyIndex] = '3';
              break;
            case VK_DOWN:
              abyKeys[iKeyIndex] = '2';
              break;
            case VK_END:
              abyKeys[iKeyIndex] = '1';
              break;
            case VK_INSERT:
              abyKeys[iKeyIndex] = '0';
              break;
            default:
              return(FALSE);
            }
          iKeyIndex++;
          return(TRUE);
          }
        }
      }
    else
      {
      if (usFlags & KC_CHAR)
        {
        byChar = SHORT1FROMMP(mp2);
        SendByteImmediate(&stIOctl,hCom,byChar);
        bSendNextKeystroke = FALSE;
        MenuItemCheck(hwndFrame,IDM_SENDIMM,FALSE);
        return(TRUE);
        }
      else
        {
        if (bAltKeyDown && (usFlags & KC_KEYUP) && (usFlags & KC_SCANCODE))
          {
          if (iKeyIndex < 3)
            abyKeys[iKeyIndex++] = '5';
          return(TRUE);
          }
        }
      }
    }
  else
    {
    if ((usFlags & KC_KEYUP) == 0)
      {
      if (usFlags & KC_VIRTUALKEY)
        {
        byChar = SHORT2FROMMP(mp2);
        if (usFlags & KC_CTRL)
          {
          switch (byChar)
            {
            case VK_RIGHT:
              if (pstCFG->bColumnDisplay)
                WinSendMsg(stRead.hwndClient,WM_BUTTON2DOWN,0L,0L);
//              else
//                WinSendMsg(hwndClient,WM_BUTTON2DOWN,0L,0L);
              return(TRUE);
            case VK_LEFT:
              if (pstCFG->bColumnDisplay)
                WinSendMsg(stWrite.hwndClient,WM_BUTTON2DOWN,0L,0L);
//              else
//                WinSendMsg(hwndClient,WM_BUTTON2DOWN,0L,0L);
              return(TRUE);
            case VK_DOWN:
              WinSendMsg(hwndStatus,WM_BUTTON2DOWN,0L,0L);
              return(TRUE);
            case VK_UP:
              if (!pstCFG->bColumnDisplay)
                WinSendMsg(hwndClient,WM_BUTTON2DOWN,0L,0L);
              return(TRUE);
            default:
              return(FALSE);
            }
          }
        else
          {
          if (pstCFG->fDisplaying & (DISP_FILE | DISP_DATA))
            {
            switch (byChar)
              {
              case VK_PAGEDOWN:
                mpScrollDir = MPFROM2SHORT(0,SB_PAGEDOWN);
                break;
              case VK_PAGEUP:
                mpScrollDir = MPFROM2SHORT(0,SB_PAGEUP);
                break;
              case VK_UP:
                mpScrollDir = MPFROM2SHORT(0,SB_LINEUP);
                break;
              case VK_DOWN:
                mpScrollDir = MPFROM2SHORT(0,SB_LINEDOWN);
                break;
              case VK_HOME:
                mpScrollDir = MPFROM2SHORT(0,SB_SLIDERPOSITION);
                break;
              case VK_END:
                if (pstCFG->bColumnDisplay)
                  {
                  if (!pstCFG->bSyncToRead)
                    WinSendMsg(stWrite.hwndClient,WM_VSCROLL,0L,MPFROM2SHORT(stWrite.lScrollRowCount,SB_SLIDERPOSITION));
                  if (!pstCFG->bSyncToWrite)
                    WinSendMsg(stRead.hwndClient,WM_VSCROLL,0L,MPFROM2SHORT(stRead.lScrollRowCount,SB_SLIDERPOSITION));
                  }
                else
                  WinSendMsg(hwndClient,WM_VSCROLL,0L,MPFROM2SHORT(stRow.lScrollRowCount,SB_SLIDERPOSITION));
                return(TRUE);
              case VK_RIGHT:
                if (pstCFG->bColumnDisplay)
                  {
                  if ((stWrite.lScrollIndex < lScrollCount) && (stRead.lScrollIndex < lScrollCount))
                    {
                    stWrite.lScrollIndex++;
                    stRead.lScrollIndex++;
                    WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
                    WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
                    }
                  }
                else
                  {
                  if (stRow.lScrollIndex < lScrollCount)
                    {
                    iIndex = (stRow.lScrollIndex + 1);
                    while (iIndex < lScrollCount)
                      {
                      if ((lIncrement = CountTraceElement(pwScrollBuffer[iIndex],CS_PACKET_DATA)) == 1)
                        break;
                      if (lIncrement != 0)
                        iIndex += lIncrement;
                      else
                        iIndex++;
                      }
                    if (iIndex < lScrollCount)
                      {
                      stRow.lScrollIndex = iIndex;
                      WinInvalidateRect(stRow.hwndClient,(PRECTL)NULL,FALSE);
                      }
                    }
                  }
                return(TRUE);
              case VK_LEFT:
                if (pstCFG->bColumnDisplay)
                  {
                  if ((stWrite.lScrollIndex > 0) && (stRead.lScrollIndex > 0))
                    {
                    stWrite.lScrollIndex--;
                    stRead.lScrollIndex--;
                    WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
                    WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
                    }
                  }
                else
                  {
                  if (stRow.lScrollIndex > 0)
                    {
                    iIndex = (stRow.lScrollIndex - 1);
                    while (iIndex >= 0)
                      {
                      if ((lIncrement = CountTraceElement(pwScrollBuffer[iIndex],CS_PACKET_DATA)) == 1)
                        break;
                      iIndex--;
                      }
                    if (iIndex >= 0)
                      {
                      stRow.lScrollIndex = iIndex;
                      WinInvalidateRect(stRow.hwndClient,(PRECTL)NULL,FALSE);
                      }
                    }
                  }
                return(TRUE);
              default:
                return(FALSE);
              }
            if (pstCFG->bColumnDisplay)
              {
              if (!pstCFG->bSyncToRead)
                WinSendMsg(stWrite.hwndClient,WM_VSCROLL,0L,mpScrollDir);
              if (!pstCFG->bSyncToWrite)
                WinSendMsg(stRead.hwndClient,WM_VSCROLL,0L,mpScrollDir);
              }
            else
              WinSendMsg(hwndClient,WM_VSCROLL,0L,mpScrollDir);
            return(TRUE);
            }
          }
        }
      }
    }
  return(FALSE);
  }

APIRET GetNoClearComEvent_ComError(HFILE hCom,WORD *pwCOMevent,WORD *pwCOMerror)
  {
  ULONG ulDataLen = 4L;
  ULONG ulParmLen = 2L;
  APIRET rc;
  struct _stData
    {
    WORD wComError;
    WORD wComEvent;
    }stData;
  WORD wSignature;

  wSignature = SIGNATURE;
  rc = DosDevIOCtl(hCom,0x01,0x7b,(PVOID)&wSignature,2L,&ulParmLen,(PVOID)&stData,4L,&ulDataLen);
  *pwCOMevent = stData.wComEvent;
  *pwCOMerror = stData.wComError;
  return(rc);
  }

void ProcessPacketData(HWND hwnd,LONG lStartIndex,USHORT usFunction)
  {
  LONG lIndex;
  BYTE byCount;
  int iLen;
  BYTE abyData[256];
  BYTE *pByte;
  char szMessage[256];
  USHORT *pUShort;
  ULONG *pULong;
  BAUDST *pstBaud;

  if ((pwScrollBuffer[lStartIndex] & CS_PACKET_DATA) == CS_PACKET_DATA)
    {
    byCount = (((BYTE)pwScrollBuffer[lStartIndex] & 0x00ff) * 2);
    pByte = (BYTE *)&pwScrollBuffer[lStartIndex + 1];
    for (lIndex = 0;lIndex < byCount;lIndex++)
      abyData[lIndex] = pByte[lIndex];
    }
  else
    byCount = 0;
  /*
  ** test if function is application read/write request/return
  */
  if ((usFunction & 0xff00) != 0)
    {
    switch (usFunction & 0xff00)
      {
      case CS_READ_REQUEST:
        if (byCount)
          {
          pUShort = (USHORT *)abyData;
          iLen = sprintf(szMessage,"%u byte read request",*pUShort);
          }
        else
          iLen = sprintf(szMessage,"Read request");
        if ((usFunction & 0x00ff) != 0)
          sprintf(&szMessage[iLen]," - %u level packet queued");
        break;
      case CS_READ_COMPLETE:
        if (byCount)
          {
          pUShort = (USHORT *)abyData;
          if (*pUShort == 1)
            iLen = sprintf(szMessage,"%u byte read",*pUShort);
          else
            iLen = sprintf(szMessage,"%u bytes read",*pUShort);
          }
        else
          iLen = sprintf(szMessage,"Read completed");
        if ((usFunction & 0x00ff) != 0)
          sprintf(&szMessage[iLen]," - %u level packet dequeued");
        break;
      case CS_WRITE_REQUEST:
        if (byCount)
          {
          pUShort = (USHORT *)abyData;
          iLen = sprintf(szMessage,"%u byte write request",*pUShort);
          }
        else
          iLen = sprintf(szMessage,"Write request");
        if ((usFunction & 0x00ff) != 0)
          sprintf(&szMessage[iLen]," - %u level packet queued");
        break;
      case CS_WRITE_COMPLETE:
        if (byCount)
          {
          pUShort = (USHORT *)abyData;
          if (*pUShort == 1)
            iLen = sprintf(szMessage,"%u byte written",*pUShort);
          else
            iLen = sprintf(szMessage,"%u bytes written",*pUShort);
          }
        else
          iLen = sprintf(szMessage,"Write completed");
        if ((usFunction & 0x00ff) != 0)
          sprintf(&szMessage[iLen]," - %u level packet dequeued");
        break;
      default:
        sprintf(szMessage,"Unknown request -> value is 0x%04X",usFunction);
        break;
      }
    ErrorNotify(szMessage);
    return;
    }
  /*
  **  function is application DevIOCtl call
  */
  switch (usFunction)
    {
    case 0x41:
      iLen = sprintf(szMessage,"DevIOCtl, set baud Rate");
      if (byCount)
        {
        pUShort = (USHORT *)abyData;
        sprintf(&szMessage[iLen]," -> %u",*pUShort);
        }
      break;
    case 0x42:
      iLen = sprintf(szMessage,"DevIOCtl, set line characteristics");
      if (byCount)
        {
        iLen += sprintf(&szMessage[iLen]," -> %u, ",abyData[0]);
        switch (abyData[1])
          {
          case 0:
            iLen += sprintf(&szMessage[iLen],"none, ");
            break;
          case 1:
            iLen += sprintf(&szMessage[iLen],"odd, ");
            break;
          case 2:
            iLen += sprintf(&szMessage[iLen],"even, ");
            break;
          case 3:
            iLen += sprintf(&szMessage[iLen],"one, ");
            break;
          case 4:
            iLen += sprintf(&szMessage[iLen],"zero, ");
            break;
          }
        switch (abyData[2])
          {
          case 0:
            sprintf(&szMessage[iLen],"1");
            break;
          case 1:
            sprintf(&szMessage[iLen],"1.5");
            break;
          case 2:
            sprintf(&szMessage[iLen],"2");
            break;
          }
        }
      break;
    case 0x43:
      iLen = sprintf(szMessage,"DevIOCtl, set extended baud rate");
      if (byCount)
        {
        pULong = (ULONG *)abyData;
        sprintf(&szMessage[iLen]," -> %u",*pULong);
        }
      break;
    case 0x44:
      iLen = sprintf(szMessage,"DevIOCtl, transmit byte immediate");
      if (byCount)
        {
        pByte = (BYTE *)abyData;
        sprintf(&szMessage[iLen]," -> 0x%02X",*pByte);
        }
      break;
    case 0x46:
      iLen = sprintf(szMessage,"DevIOCtl, set modem output signals");
      if (byCount)
        {
        if (abyData[0] & 0x01)
          iLen += sprintf(&szMessage[iLen]," - DTR->on ");
        else
          if ((abyData[1] & 0x01) == 0)
            iLen += sprintf(&szMessage[iLen]," - DTR->off");
        if (abyData[0] & 0x02)
          sprintf(&szMessage[iLen]," RTS->on");
        else
          if ((abyData[1] & 0x02) == 0)
            sprintf(&szMessage[iLen]," RTS->off");
        }
      break;
    case 0x53:
      iLen = sprintf(szMessage,"DevIOCtl, set DCB parameters");
      if (byCount)
        if (stCFG.bPopupParams)
          WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpDCBpacketDlgProc,NULLHANDLE,DCB_PACKET_DLG,abyData);
      break;
    case 0x55:
      iLen = sprintf(szMessage,"DevIOCtl, set extended FIFO processing");
      if (byCount)
        {
        pUShort = (USHORT *)abyData;
        sprintf(&szMessage[iLen]," -> %u",*pUShort);
        }
      break;
    case 0x56:
      iLen = sprintf(szMessage,"DevIOCtl, set thresholds");
      if (byCount)
        {
        pUShort = (USHORT *)abyData;
        sprintf(&szMessage[iLen]," -> %u",*pUShort);
        }
      break;
    case 0x61:
      iLen = sprintf(szMessage,"DevIOCtl, query baud rate");
      if (byCount)
        {
        pUShort = (USHORT *)abyData;
        sprintf(&szMessage[iLen]," -> %u",*pUShort);
        }
      break;
    case 0x62:
      iLen = sprintf(szMessage,"DevIOCtl, query line characteristics");
      if (byCount)
        {
        iLen += sprintf(&szMessage[iLen]," -> %u, ",abyData[0]);
        switch (abyData[1])
          {
          case 0:
            iLen += sprintf(&szMessage[iLen],"none, ");
            break;
          case 1:
            iLen += sprintf(&szMessage[iLen],"odd, ");
            break;
          case 2:
            iLen += sprintf(&szMessage[iLen],"even, ");
            break;
          case 3:
            iLen += sprintf(&szMessage[iLen],"one, ");
            break;
          case 4:
            iLen += sprintf(&szMessage[iLen],"zero, ");
            break;
          }
        switch (abyData[2])
          {
          case 0:
            sprintf(&szMessage[iLen],"1");
            break;
          case 1:
            sprintf(&szMessage[iLen],"1.5");
            break;
          case 2:
            sprintf(&szMessage[iLen],"2");
            break;
          }
        }
      break;
    case 0x63:
      iLen = sprintf(szMessage,"DevIOCtl, query extended baud rate");
      if (byCount)
        {
        pstBaud = (BAUDST *)abyData;
        sprintf(&szMessage[iLen]," -> %u, min=%u, max=%u",pstBaud->stCurrentBaud.lBaudRate,
                                                          pstBaud->stLowestBaud.lBaudRate,
                                                          pstBaud->stHighestBaud.lBaudRate);
        }
      break;
    case 0x64:
      iLen = sprintf(szMessage,"DevIOCtl, query COM status");
      if (byCount)
        sprintf(&szMessage[iLen]," -> 0x%02X",abyData[0]);
      if (stCFG.bPopupParams)
        WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpCOMstatusStatesDlg,NULLHANDLE,CST_DLG,abyData);
      break;
    case 0x65:
      iLen = sprintf(szMessage,"DevIOCtl, query transmit data status");
      if (byCount)
        sprintf(&szMessage[iLen]," -> 0x%02X",abyData[0]);
      if (stCFG.bPopupParams)
        WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpXmitStatusStatesDlg,NULLHANDLE,TST_DLG,abyData);
      break;
    case 0x66:
      iLen = sprintf(szMessage,"DevIOCtl, query output modem signals");
      if (byCount)
        {
        if (abyData[0] & 0x01)
          iLen += sprintf(&szMessage[iLen]," - DTR->on ");
        else
          iLen += sprintf(&szMessage[iLen]," - DTR->off");
        if (abyData[0] & 0x02)
          sprintf(&szMessage[iLen]," RTS->on");
        else
          sprintf(&szMessage[iLen]," RTS->off");
        }
      break;
    case 0x67:
      iLen = sprintf(szMessage,"DevIOCtl, query input modem signals");
      if (byCount)
        {
        if (abyData[0] & 0x10)
          iLen += sprintf(&szMessage[iLen]," - CTS->on  ");
        else
          iLen += sprintf(&szMessage[iLen]," - CTS->off ");
        if (abyData[0] & 0x20)
          iLen += sprintf(&szMessage[iLen],"DSR->on  ");
        else
          iLen += sprintf(&szMessage[iLen],"DSR->off ");
#ifdef this_junk
        if (abyData[0] & 0x40)
          iLen += sprintf(&szMessage[iLen],"RI->on  ");
        else
          iLen += sprintf(&szMessage[iLen],"RI->off ");
#endif
        if (abyData[0] & 0x80)
          sprintf(&szMessage[iLen],"CD->on");
        else
          sprintf(&szMessage[iLen],"CD->off");
        }
      break;
    case 0x68:
      iLen = sprintf(szMessage,"DevIOCtl, query receive queue");
      if (byCount)
        {
        pUShort = (USHORT *)abyData;
        sprintf(&szMessage[iLen]," -> %u in %u byte queue",pUShort[0],pUShort[1]);
        }
      break;
    case 0x69:
      iLen = sprintf(szMessage,"DevIOCtl, query transmit queue");
      if (byCount)
        {
        pUShort = (USHORT *)abyData;
        sprintf(&szMessage[iLen]," -> %u in %u byte queue",pUShort[0],pUShort[1]);
        }
      break;
    case 0x6d:
      iLen = sprintf(szMessage,"DevIOCtl, query COM error");
      if (byCount == sizeof(SHORT))
        {
        pUShort = (USHORT *)abyData;
        sprintf(&szMessage[iLen]," -> 0x%04X",*pUShort);
        if (stCFG.bPopupParams)
          WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpCOMerrorStatesDlg,NULLHANDLE,CER_DLG,pUShort);
        }
      break;
    case 0x72:
      iLen = sprintf(szMessage,"DevIOCtl, query COM event info");
      if (byCount)
        {
        pUShort = (USHORT *)abyData;
        sprintf(&szMessage[iLen]," -> 0x%04X",*pUShort);
        if (stCFG.bPopupParams)
          WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpCOMeventStatesDlg,NULLHANDLE,CEV_DLG,pUShort);
        }
      break;
    case 0x73:
      iLen = sprintf(szMessage,"DevIOCtl, query DCB parameters");
      if (byCount)
        if (stCFG.bPopupParams)
          WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpDCBpacketDlgProc,NULLHANDLE,DCB_PACKET_DLG,abyData);
      break;
    case 0x75:
      iLen = sprintf(szMessage,"DevIOCtl, query FIFO info");
      if (byCount)
        {
        pUShort = (USHORT *)abyData;
        sprintf(&szMessage[iLen]," -> %u",*pUShort);
        }
      break;
    case 0x76:
      iLen = sprintf(szMessage,"DevIOCtl, query threshold info");
      if (byCount)
        {
        pUShort = (USHORT *)abyData;
        sprintf(&szMessage[iLen]," -> %u",*pUShort);
        }
      break;
     default:
      sprintf(szMessage,"Unsupported function -> 0x%02X",(BYTE)usFunction);
      break;
    }
  ErrorNotify(szMessage);
  }

void DisplayCharacterInfo(HWND hwnd,LONG lMouseIndex)
  {
  char szMessage[100];
  LONG lIndex;
  USHORT usKey;
  BYTE byChar;
  int iLen;
  BOOL bIsPrintable;
  ULONG ulIncrement;

  lIndex = stRow.lScrollIndex;
  while (lIndex < lScrollCount)
    {
    if ((ulIncrement = CountTraceElement(pwScrollBuffer[lIndex],0xff00)) != 0)
      {
      if (ulIncrement == 1)
        if (lMouseIndex-- == 0)
          break;
      lIndex += ulIncrement;
      }
    else
      lIndex++;
    }
  if (lIndex >= lScrollCount)
    {
#if DEBUG > 0
    ErrorNotify("No information");
#endif
    return;
    }
  usKey = pwScrollBuffer[lIndex];
  byChar = (BYTE)usKey;
  bIsPrintable = isprint(byChar);
  switch  (usKey & 0xff00)
    {
    case CS_READ:
      iLen = sprintf(szMessage,"Read stream <- ");
      if (byChar != ' ')
        if (bIsPrintable)
          {
          sprintf(&szMessage[iLen],"%c",byChar);
          break;
          }
      sprintf(&szMessage[iLen],"0x%02X ",byChar);
      break;
    case CS_READ_IMM:
      iLen = sprintf(szMessage,"Xon/Xoff character received <- ");
      if (byChar != ' ')
        if (bIsPrintable)
          {
          sprintf(&szMessage[iLen],"%c",byChar);
          break;
          }
      sprintf(&szMessage[iLen],"0x%02X ",byChar);
      break;
    case CS_WRITE:
      iLen = sprintf(szMessage,"Write stream -> ");
      if (byChar != ' ')
        if (bIsPrintable)
          {
          sprintf(&szMessage[iLen],"%c",byChar);
          break;
          }
      sprintf(&szMessage[iLen],"0x%02X ",byChar);
      break;
    case CS_WRITE_IMM:
      iLen = sprintf(szMessage,"Xon/Xoff or transmit byte immediate -> ");
      if (byChar != ' ')
        if (bIsPrintable)
          {
          sprintf(&szMessage[iLen],"%c",byChar);
          break;
          }
      sprintf(&szMessage[iLen],"0x%02X ",byChar);
      break;
    case CS_DEVIOCTL:
      switch (byChar)
        {
        case 0xf0:
          sprintf(szMessage,"Output buffer flushed");
          break;
        case 0xf1:
          sprintf(szMessage,"Input buffer flushed");
          break;
        case 0x45:
          sprintf(szMessage,"DevIOCtl, set line BREAK off");
          break;
        case 0x47:
          sprintf(szMessage,"DevIOCtl, act like Xoff received");
          break;
        case 0x48:
          sprintf(szMessage,"DevIOCtl, act like Xon signal received");
          break;
        case 0x4B:
          sprintf(szMessage,"DevIOCtl, set line BREAK on");
          break;
        case 0x54:
          sprintf(szMessage,"DevIOCtl, set enhanced mode (not supported)");
          break;
        case 0x74:
          sprintf(szMessage,"DevIOCtl, query enhanced mode (not supported)");
          break;
        default:
          ProcessPacketData(hwnd,(lIndex + 1),byChar);
          return;
        }
      break;
    case CS_READ_REQ:
      ProcessPacketData(hwnd,(lIndex + 1),(CS_READ_REQUEST | (USHORT)byChar));
      return;
    case CS_READ_CMPLT:
      ProcessPacketData(hwnd,(lIndex + 1),(CS_READ_COMPLETE | (USHORT)byChar));
      return;
    case CS_WRITE_REQ:
      ProcessPacketData(hwnd,(lIndex + 1),(CS_WRITE_REQUEST | (USHORT)byChar));
      return;
    case CS_WRITE_CMPLT:
      ProcessPacketData(hwnd,(lIndex + 1),(CS_WRITE_COMPLETE | (USHORT)byChar));
      return;
    case CS_OPEN_ONE:
      sprintf(szMessage,"First level DosOpen request");
      break;
    case CS_OPEN_TWO:
      sprintf(szMessage,"Second level DosOpen request");
      break;
    case CS_CLOSE_ONE:
      sprintf(szMessage,"First level DosClose complete");
      break;
    case CS_CLOSE_TWO:
      sprintf(szMessage,"Second level DosClose complete");
      break;
    case CS_BREAK_TX:
      if (byChar & LINE_CTL_SEND_BREAK)
        sprintf(szMessage,"Begin sending line BREAK");
      else
        sprintf(szMessage,"Stop sending line BREAK");
      break;
    case CS_BREAK_RX:
      sprintf(szMessage,"Receive line BREAK detected");
      break;
    case CS_MODEM_IN:
      iLen = sprintf(szMessage,"Modem input signal(s) changed - ");
      if (byChar & MDM_ST_DELTA_CTS)
        if (byChar & MDM_ST_CTS)
          iLen += sprintf(&szMessage[iLen],"CTS->on  ");
        else
          iLen += sprintf(&szMessage[iLen],"CTS->off ");
      if (byChar & MDM_ST_DELTA_DSR)
        if (byChar & MDM_ST_DSR)
          iLen += sprintf(&szMessage[iLen],"DSR->on  ");
        else
          iLen += sprintf(&szMessage[iLen],"DSR->off ");
      if (byChar & MDM_ST_DELTA_TRI)
        if (byChar & MDM_ST_TRI)
          iLen += sprintf(&szMessage[iLen],"RI->on  ");
        else
          iLen += sprintf(&szMessage[iLen],"RI->off ");
      if (byChar & MDM_ST_DELTA_DCD)
        if (byChar & MDM_ST_DCD)
          sprintf(&szMessage[iLen],"CD->on");
        else
          sprintf(&szMessage[iLen],"CD->off");
      break;
    case CS_MODEM_OUT:
      iLen = sprintf(szMessage,"Modem output signals changed - ");
      if (byChar & MDM_CTL_DTR_ACTIVATE)
        iLen += sprintf(&szMessage[iLen],"DTR->on  ");
      else
        iLen += sprintf(&szMessage[iLen],"DTR->off ");
      if (byChar & MDM_CTL_RTS_ACTIVATE)
        sprintf(&szMessage[iLen],"RTS->on");
      else
        sprintf(&szMessage[iLen],"RTS->off");
      break;
    case CS_READ_BUFF_OVERFLOW:
      sprintf(szMessage,"Device driver receive buffer overflow");
      break;
    case CS_HDW_ERROR:
      iLen = sprintf(szMessage,"Hardware error - ");
      if (byChar & LINE_ST_PARITY_ERROR)
        iLen += sprintf(&szMessage[iLen],"Parity ");
      if (byChar & LINE_ST_OVERRUN_ERROR)
        iLen += sprintf(&szMessage[iLen],"Overrun ");
      if (byChar & LINE_ST_FRAMING_ERROR)
        sprintf(&szMessage[iLen]," Framing");
      break;
    default:
      sprintf(szMessage,"Unknown key -> value is 0x%04X",pwScrollBuffer[lIndex]);
      break;
    }
  ErrorNotify(szMessage);
  }

BOOL TestOUT1(void)
  {
//  APIRET rc = 0;
  ULONG ulDataLen = sizeof(EXTDATA);
  ULONG ulParmLen = sizeof(EXTPARM);
  EXTPARM stParams;
  EXTDATA stData;

  stParams.wSignature = SIGNATURE;
  stParams.wDataCount = sizeof(USHORT);
  stParams.wCommand = EXT_CMD_GET_CONFIG_FLAGS;
  stParams.wModifier = 0;
  if (DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,&stData,sizeof(EXTDATA),&ulDataLen) != NO_ERROR)
    return(FALSE);
  if (stData.wData & CFG_FLAG1_EXT_MODEM_CTL)
    return(TRUE);
  else
    return(FALSE);
  }

BOOL ResetHighWater(void)
  {
  ULONG ulDataLen = sizeof(EXTDATA);
  ULONG ulParmLen = sizeof(EXTPARM);
  EXTPARM stParams;
  EXTDATA stData;

  stParams.wSignature = SIGNATURE;
  stParams.wDataCount = 0;
  stParams.wCommand = EXT_CMD_RESET_RX_HIGH;
  stParams.wModifier = 0;
  if (DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,&stData,sizeof(EXTDATA),&ulDataLen) != NO_ERROR)
    return(FALSE);
  return(TRUE);
  }

APIRET AccessCOMscope(HFILE hCom,CSDATA *pstDataSet)
  {
  struct
    {
    USHORT usSignature;
    ULONG ulCount;
    }stCOMscope;
  ULONG ulDataLen = (ULONG)(pstDataSet->cbSize + sizeof(ULONG));
  ULONG ulParmLen = (ULONG)(sizeof(stCOMscope));
  APIRET rc;
  char szError[81];

  stCOMscope.usSignature = SIGNATURE;
  stCOMscope.ulCount = pstDataSet->cbSize;
  if ((rc = DosDevIOCtl(hCom,0x01,0x7d,&stCOMscope,sizeof(stCOMscope),&ulParmLen,pstDataSet,ulDataLen,&ulDataLen)) != 0)
    {
    sprintf(szError,"Error Reading Port - %X",rc);
    ErrorNotify(szError);
    }
  return(rc);
  }

APIRET EnableCOMscope(HWND hwnd,HFILE hCom,ULONG *pulBuffSize,USHORT fTraceEvent)
  {
  ULONG ulDataLen;
  ULONG ulParmLen;
  APIRET rc;
  char szMsgString[300];
  char szCaption[80];
  struct
    {
    USHORT usSignature;
    USHORT fTraceEvents;
    }stCOMscope;
  struct
    {
    USHORT usSignature;
    sBOOL bCOMscopeAvailable;
    USHORT wCount;
    }stData;

  bCOMscopeEnabled = FALSE;
  ulDataLen = sizeof(stData);
  ulParmLen = sizeof(stCOMscope);
  stCOMscope.usSignature = SIGNATURE;
  stCOMscope.fTraceEvents = fTraceEvent;
  if ((rc = DosDevIOCtl(hCom,0x01,0x7e,&stCOMscope,sizeof(stCOMscope),&ulParmLen,&stData,sizeof(stData),&ulDataLen)) != 0)
    {
    sprintf(szMsgString,"DOS error enabling stream monitoring -> 0x%X",rc);
    ErrorNotify(szMsgString);
    return(FALSE);
    }
  *pulBuffSize = stData.wCount;
  if (!stData.bCOMscopeAvailable)
    {
    if (stData.usSignature != stCOMscope.usSignature)
      {
      sprintf(szCaption,"COMscope monitoring is not supported.");
#ifdef DEMO
      if (stData.usSignature == GA_SIGNATURE)
        sprintf(szMsgString,"This version of COMscope is for EVALUATION ONLY, and can only monitor"
                            " a port controlled by the evaluation version of COMi (COMDDE.SYS).\n\nYou may,"
                            " however, use this version to create and/or edit an initialization file for a"
                            " fully functional version of COMi.");
#else
      if (stData.usSignature == DEMO_SIGNATURE)
        sprintf(szMsgString,"This version of COMscope cannot monitor a device controlled by the evaluation"
                            " version of COMi (COMDDE.SYS).\n\nYou may, however, use this version of"
                            " COMscope to create and/or edit an initialization file for the evaluation"
                            " version of COMi.");
#endif
      else
        sprintf(szMsgString,"This version of COMscope is not compatable with the version of COMi that is"
                            " currently loaded.\n\nPlease contact OS/tools Incorporated for upgrade"
                            " information.\n\nSee the \"About COMscope\" dialog in the \"Help\" menu"
                            " for information on COMi and COMscope versions and how to contact OS/tools.");
      }
    else
      {
      sprintf(szCaption,"%s is unable to support COMscope.",stCFG.szPortName);
      sprintf(szMsgString,"This device is not configured for COMscope.  Use Install function to enable COMscope for next OS/2 session.");
      }
    WinMessageBox(HWND_DESKTOP,
                  hwnd,
                  szMsgString,
                  szCaption,
            (LONG)NULL,
                  MB_MOVEABLE | MB_OK | MB_CUAWARNING);
    return(FALSE);
    }
  if (fTraceEvent != 0)
    bCOMscopeEnabled = TRUE;
  return(TRUE);
  }


