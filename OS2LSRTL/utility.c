#include <COMMON.H>
#include <OS$tools.h>

static char *aszCapOrdinals[] = {"Zero","One","Two","Three","Four","Five","Six","Seven","Eight","Nine","Ten","Eleven","Twelve","Thirteen","Fourteen","Fifteen","Sixteen"};
static char *aszOrdinals[] = {"zero","one","two","three","four","five","six","seven","eight","nine","ten","eleven","twelve","thirteen","fourteen","fifteen","sixteen"};

BOOL GetFileName (HWND hwnd,char *pszFileName,char *pszTitle,PFNWP OpenFilterProc)
	{
	FILEDLG fileDlg;

	memset(&fileDlg,0,sizeof(FILEDLG));
	if (pszFileName[0] != 0)
		strcpy(fileDlg.szFullFile,pszFileName);
	fileDlg.cbSize = sizeof(FILEDLG);
	fileDlg.fl = (FDS_CENTER | FDS_OPEN_DIALOG);
	if (OpenFilterProc != NULL)
		{
		fileDlg.fl |= FDS_HELPBUTTON;
		fileDlg.pfnDlgProc = (PFNWP)OpenFilterProc;
		}
	fileDlg.pszTitle = pszTitle;
	WinFileDlg(HWND_DESKTOP,hwnd,&fileDlg);
	if (fileDlg.lReturn != DID_OK)
    return(FALSE);
	strcpy(pszFileName,fileDlg.szFullFile);
  return(TRUE);
  }

void EXPENTRY RemoveSpaces(char szString[])
  {
  int iIndex;

  for (iIndex = 0;iIndex <= 8;iIndex++)
    if (szString[iIndex] == ' ')
      break;
  szString[iIndex] = 0;
 }

LONG EXPENTRY ASCIItoBin(char szNumber[],int iRadix)
  {
  int iIndex = 0;
  LONG lTemp;
  LONG lMultiplier = 1;
  BYTE byTemp;
  LONG lValue = 0;
  int iBeginIndex;

  while ((szNumber[iIndex] == ' ') || (szNumber[iIndex] == '\t'))
    iIndex++;
  iBeginIndex = iIndex;
  byTemp = szNumber[iIndex];
  while ((byTemp != 0) && (byTemp != ' ') && (byTemp != '\t'))
    {
    if (byTemp < '0')
      break;
    if (byTemp > '9')
      {
      if (iRadix != 16)
        break;
      byTemp &= 0xdf;
      if ((byTemp < 'A') || (byTemp > 'F'))
        break;
      szNumber[iIndex] = byTemp;
      }
    byTemp = szNumber[++iIndex];
    }
  for (iIndex--;iIndex >= iBeginIndex;iIndex--)
    {
    byTemp = szNumber[iIndex];
    if ((byTemp >= '0') && (byTemp <= '9'))
      lTemp = (LONG)(byTemp - 0x30);
    else
      lTemp= (LONG)(byTemp - 0x37);
    lValue += (lTemp * lMultiplier);
    lMultiplier *= iRadix;
    }
  return(lValue);
  }

BOOL EXPENTRY Checked(HWND hwndDlg,SHORT idDlgItem)
  {
  return(SHORT1FROMMR(WinSendMsg(WinWindowFromID(hwndDlg,idDlgItem),
                                 BM_QUERYCHECK,0L,0L)));
  }

VOID EXPENTRY MenuItemEnable(HWND hwnd,WORD idItem,BOOL bEnable)
  {
  WinSendMsg(WinWindowFromID(hwnd,FID_MENU),
             MM_SETITEMATTR,
             MPFROM2SHORT(idItem,TRUE),
             MPFROM2SHORT(MIA_DISABLED, bEnable ? ~MIA_DISABLED : MIA_DISABLED));
  }

VOID EXPENTRY MenuItemCheck(HWND hwnd,WORD idItem,BOOL bCheck)
  {
  WinSendMsg(WinWindowFromID(hwnd,FID_MENU),
             MM_SETITEMATTR,
             MPFROM2SHORT(idItem,TRUE),
             MPFROM2SHORT(MIA_CHECKED, bCheck ? MIA_CHECKED : ~MIA_CHECKED));
  }

BOOL EXPENTRY GetLongIntDlgItem(HWND hwndDlg,SHORT idEntryField,LONG *plValue)
  {
  CHAR szValue[12];
  int iLength;

  iLength = WinQueryDlgItemText(hwndDlg,idEntryField,sizeof(szValue),szValue);
  if (iLength > 10)
    return(FALSE);
  szValue[iLength] = 0;
  *plValue = atol(szValue);
  return(TRUE);
  }

USHORT EXPENTRY CheckButton(HWND hwndDlg,USHORT idItem,BOOL bCheck)
  {
  if (bCheck != 0)
    bCheck = 1;
  return(WinCheckButton(hwndDlg,idItem,(USHORT)bCheck));
  }

VOID EXPENTRY ControlEnable(HWND hwndDlg,WORD idItem,BOOL bEnable)
  {
  WinEnableWindow(WinWindowFromID(hwndDlg,idItem),bEnable);
  }

VOID EXPENTRY MessageBox(HWND hwnd,PSZ pszMessage)
  {
//  if (!bRemoteServer)
    WinMessageBox(HWND_DESKTOP,
                  hwnd,
                  pszMessage,
                  NULL,
                  0,
                  MB_MOVEABLE | MB_OK | MB_CUAWARNING);
  }

VOID EXPENTRY CenterDlgBox(HWND hwnd)
  {
  SWP swp;
  LONG lXScr;
  LONG lYScr;

  lXScr = (SHORT)WinQuerySysValue(HWND_DESKTOP,SV_CXSCREEN);
  lYScr = (SHORT)WinQuerySysValue(HWND_DESKTOP,SV_CYSCREEN);

  WinQueryWindowPos(hwnd,&swp);
  WinSetWindowPos(hwnd,0L,((lXScr - swp.cx) / 2),((lYScr - swp.cy) / 2),0,0,SWP_MOVE);
  }

void EXPENTRY AppendTMP(char szFileSpec[])
  {
  WORD wIndex = 0;

  while (szFileSpec[wIndex++] != 0);
  while (szFileSpec[--wIndex] != '.')
    {
    if (wIndex == 0)
      {
      while (szFileSpec[wIndex++] != 0);
      szFileSpec[--wIndex] = '.';
      break;
      }
    }
  szFileSpec[++wIndex] = 'T';
  szFileSpec[++wIndex] = 'M';
  szFileSpec[++wIndex] = 'P';
  szFileSpec[++wIndex] = 0;
  }

void EXPENTRY AppendINI(char szFileSpec[])
  {
  WORD wIndex = 0;

  while (szFileSpec[wIndex++] != 0);
  while (szFileSpec[--wIndex] != '.')
    {
    if (wIndex == 0)
      {
      while (szFileSpec[wIndex++] != 0);
      szFileSpec[--wIndex] = '.';
      break;
      }
    }
  szFileSpec[++wIndex] = 'I';
  szFileSpec[++wIndex] = 'N';
  szFileSpec[++wIndex] = 'I';
  szFileSpec[++wIndex] = 0;
  }

void EXPENTRY AppendHLP(char szFileSpec[])
  {
  WORD wIndex = 0;

  while (szFileSpec[wIndex++] != 0);
  while (szFileSpec[--wIndex] != '.')
    {
    if (wIndex == 0)
      {
      while (szFileSpec[wIndex++] != 0);
      szFileSpec[--wIndex] = '.';
      break;
      }
    }
  szFileSpec[++wIndex] = 'H';
  szFileSpec[++wIndex] = 'L';
  szFileSpec[++wIndex] = 'P';
  szFileSpec[++wIndex] = 0;
  }

void EXPENTRY AppendPath(BYTE *pszPathEnd, BYTE *pszFileName)
    {
    WORD wIndex = 0;
    CHAR *pStringPtr;

    pStringPtr = pszPathEnd;
    pStringPtr--;
    if ((*pStringPtr != '\\') && (*pStringPtr != '/')  && (*pStringPtr != ':'))
      {
      pStringPtr++;
      *pStringPtr = '\\';
      }
    pStringPtr++;
    while (pszFileName[wIndex] != 0)
        *pStringPtr++ = pszFileName[wIndex++];
    *pStringPtr = 0;
    }

VOID EXPENTRY SetSystemMenu(HWND hwnd)
  {
  HWND     hwndSysMenu;                 /* sys menu pull-down handle */
  MENUITEM miTemp;                      /* menu item template        */
  MRESULT  mresItemId;                  /* system menu item ID       */
  SHORT    sItemIndex;                  /* system menu item index    */

  /*******************************************************************/
  /* Get the handle of the system menu pull-down.                    */
  /*******************************************************************/
  hwndSysMenu = WinWindowFromID(hwnd,FID_SYSMENU);
  WinSendMsg( hwndSysMenu,
              MM_QUERYITEM,
              MPFROM2SHORT( SC_SYSMENU, FALSE ),
              MPFROMP( (PSZ)&miTemp ));
  hwndSysMenu = miTemp.hwndSubMenu;

  /*******************************************************************/
  /* Remove all items from the system menu pull-down that are no     */
  /* longer wanted.                                                  */
  /*******************************************************************/
  for (sItemIndex = 0,mresItemId = 0L;LONGFROMMP(mresItemId) != (LONG)MIT_ERROR;sItemIndex++)
    {
    mresItemId = WinSendMsg(hwndSysMenu,
                            MM_ITEMIDFROMPOSITION,
                            MPFROMSHORT(sItemIndex),
                            NULL);
    if (LONGFROMMP(mresItemId) != (LONG)MIT_ERROR &&
        SHORT1FROMMP(mresItemId) != SC_MOVE   &&
        SHORT1FROMMP(mresItemId) != SC_CLOSE  &&
        SHORT1FROMMP(mresItemId) != SC_TASKMANAGER)
      {
      WinSendMsg(hwndSysMenu,
                 MM_DELETEITEM,
                 MPFROM2SHORT(SHORT1FROMMP(mresItemId),FALSE),
                 NULL);
      sItemIndex--;
      }
		}
	}

void EXPENTRY MakeDeviceName(char szName[])
  {
  WORD wIndex = 0;

  while (szName[wIndex++] != 0);
  wIndex--;
  if (wIndex >= 8)
    return;
  for (;wIndex < 8;wIndex++)
    szName[wIndex] = ' ';
  }

VOID EXPENTRY AppendTripleDS(char szString[])
  {
  szString[9] = 0;
  szString[8] = szString[5];
  szString[7] = szString[4];
  szString[6] = szString[3];
  szString[5] = '$';
  szString[4] = '$';
  szString[3] = '$';
  }

ULONG ReadConfigSys(HFILE *phFile,char **ppBuffer)
  {
  ULONG ulStatus;
  FILESTATUS3 stFileInfo;
//  char szFileSpec[] = "C:\\CONFIG.sss";
  char szFileSpec[] = "C:\\CONFIG.SYS";
  ULONG ulCount;
  char szMessage[CCHMAXPATH];
  APIRET rc;

  if (DosQuerySysInfo(QSV_BOOT_DRIVE,QSV_BOOT_DRIVE,&ulCount,4L) == 0)
    szFileSpec[0] = ('A' + ((BYTE)ulCount - 1));
  if ((rc = DosOpen(szFileSpec,phFile,&ulStatus,0L,0,1,0x0022,(PEAOP2)0L)) != 0)
		{
		sprintf(szMessage,"Could not open %s - Error = %u",szFileSpec,rc);
		MessageBox(HWND_DESKTOP,szMessage);
    return(0);
    }
  DosQueryFileInfo(*phFile,1,&stFileInfo,sizeof(FILESTATUS3));
  ulCount = stFileInfo.cbFile;
  if ((rc = DosAllocMem((PVOID)ppBuffer,(ulCount + 10),(PAG_COMMIT | PAG_READ | PAG_WRITE))) != NO_ERROR)
    {
    sprintf(szMessage,"Unable to Allocate memory to read CONFIG.SYS - %u",rc);
    MessageBox(HWND_DESKTOP,szMessage);
    DosClose(*phFile);
    return(0);
    }
  if (DosRead(*phFile,(PVOID)*ppBuffer,ulCount,&ulCount) != 0)
    {
		DosFreeMem(*ppBuffer);
    DosClose(*phFile);
    return(0);
    }
  return(ulCount);
  }

ULONG FindLineWith(char szThisString[],char *pszBuffer,ULONG ulOffset,ULONG *pulCount)
  {
  ULONG ulCount;
  ULONG ulIndex = ulOffset;
  ULONG ulStartOffset;
  int iIndex;
  static ULONG ulLen;
  ULONG ulLineIndex;
  char chChar = 0xff;
  char *pchLine;

  if (DosAllocMem((PVOID)&pchLine,4096,(PAG_COMMIT | PAG_READ | PAG_WRITE)) != NO_ERROR)
    return(0);
  ulLen = strlen(szThisString);
  while (chChar != 0)
    {
    ulCount = 1;
    ulStartOffset = ulIndex;
    ulLineIndex = 0;
    chChar = pszBuffer[ulIndex++];
    while((chChar == ' ') || (chChar  == '\t'))
      {
      chChar = pszBuffer[ulIndex++];
      ulCount++;
      }
    while (chChar != 0)
      {
      if (chChar == '\x0a')
        break;
      if (ulLineIndex >= 4096)
        {
        DosFreeMem(pchLine);
        return(ulIndex);
        }
      pchLine[ulLineIndex++] = chChar;
      chChar = pszBuffer[ulIndex++];
      ulCount++;
      }
    if (ulLen <= ulLineIndex)
      {
      if (strnicmp("REM ",pchLine,4) != 0)
        for (iIndex =0;iIndex < (ulLineIndex - ulLen);iIndex++)
          if (strnicmp(szThisString,&pchLine[iIndex],ulLen) == 0)
            {
            *pulCount = ulCount;
            DosFreeMem(pchLine);
            return(ulStartOffset);
            }
      }
    }
  DosFreeMem(pchLine);
  return(0);
	}


BOOL EXPENTRY AdjustConfigSys(HWND hwnd,char szDDspec[],int iLoadCount,BOOL bMakeChanges,USHORT usHelpID)
  {
  HFILE hFile;
  ULONG ulCount;
  char *pchFile;
  char *pchNew;
  char *pchLines;
  ULONG ulIndex;
  ULONG ulOffset;
  int iDDcount = 0;
  ULONG ulLength;
  ULONG ulLastOffset;
  char szCaption[80];
	int iLen;
  ULONG ulFilePosition;
  char szDeviceStatement[CCHMAXPATH];
  ULONG flStyle;

  if (DosAllocMem((PVOID)&pchLines,16384,(PAG_COMMIT | PAG_READ | PAG_WRITE)) != NO_ERROR)
    return(FALSE);
	sprintf(szDeviceStatement,"%s.SYS",szDDspec);
  if ((ulCount = ReadConfigSys(&hFile,&pchFile)) == 0)
    {
    sprintf(szCaption,"Unable to Open System Configuration File");
    sprintf(pchLines,"You will need to add or remove DEVICE=%s statement(s) from your CONFIG.SYS file to complete this configuration.",szDeviceStatement);
    flStyle =  (MB_MOVEABLE | MB_OK | MB_ICONHAND);
    if (usHelpID != 0)
			flStyle |= MB_HELP;
    WinMessageBox(HWND_DESKTOP,
                  hwnd,
                  pchLines,
                  szCaption,
                 (usHelpID + 1),
                  flStyle);
    DosFreeMem(pchLines);
    return(FALSE);
    }
  if (pchFile[ulCount - 1] == '\x1a')
    ulCount--;
  pchFile[ulCount] = 0;
  ulCount = strlen(pchFile);
  ulOffset = 0;
	while ((ulOffset = FindLineWith(szDeviceStatement,pchFile,ulOffset,&ulLength)) != 0)
    {
    iDDcount++;
    ulOffset += ulLength;
    ulLastOffset = ulOffset;
    }
#ifdef this_junk
  if ((pstCount->wLoadNumber == 1) && (pstCount->wDCBnumber == 0))
    iLoadCount = 0;
  else
    iLoadCount = pstCount->wLoadNumber;
#endif
  if (iDDcount != iLoadCount)
    {
    DosSetFilePtr(hFile,0L,0L,&ulFilePosition);
    sprintf(szCaption,"System Configuration File needs to be updated");
    if (iDDcount > iLoadCount)
			{
      iDDcount -=iLoadCount;
      if (!bMakeChanges)
        {
				if (iDDcount > 1)
          sprintf(pchLines,"%s device driver load statements need to be removed from your CONFIG.SYS file.\n\nOK to make changes?",aszCapOrdinals[iDDcount]);
        else
					sprintf(pchLines,"One device driver load statement needs to be removed from your CONFIG.SYS file.\n\nOK to make changes?");
				flStyle =  (MB_MOVEABLE | MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON1);
				if (usHelpID != 0)
					flStyle |= MB_HELP;
				if (WinMessageBox(HWND_DESKTOP,
													hwnd,
													pchLines,
                          szCaption,
													usHelpID,
                          flStyle) != MBID_YES)
          {
          if (iDDcount > 1)
            sprintf(pchLines,"You will need to remove %s DEVICE=%s statements from your CONFIG.SYS file to complete this configuration.",aszOrdinals[iDDcount],szDeviceStatement);
          else
            sprintf(pchLines,"You will need to remove one DEVICE=%s statement from your CONFIG.SYS file to complete this configuration.",szDeviceStatement);
          WinMessageBox(HWND_DESKTOP,
                        hwnd,
                        pchLines,
                        szCaption,
												0L,
                       (MB_MOVEABLE | MB_OK | MB_ICONASTERISK));
          DosClose(hFile);
					DosFreeMem(pchFile);
					DosFreeMem(pchLines);
          return(FALSE);
          }
				}
      for (ulIndex = 0;ulIndex < iDDcount;ulIndex++)
				{
        ulOffset = 0;
        ulOffset = FindLineWith(szDeviceStatement,pchFile,ulOffset,&ulLength);
        ulCount -= ulLength;
				memcpy(&pchFile[ulOffset],&pchFile[ulOffset + ulLength],(ulCount - ulOffset));
        }
      if (iLoadCount == 0)
        if (pchFile[ulCount - 1] == '\x0a')
					ulCount -= 2;
			pchFile[ulCount++] = '\x1a';
			DosSetFileSize(hFile,ulCount);
			DosWrite(hFile,pchFile,ulCount,&ulCount);
			}
		else
			{
			iLoadCount -= iDDcount;
			if (!bMakeChanges)
				{
				if (iLoadCount > 1)
					sprintf(pchLines,"%s COMi load statements need to be added to your CONFIG.SYS file.\n\nOK to make changes?",aszCapOrdinals[iLoadCount]);
				else
					sprintf(pchLines,"One COMi load statement needs to be added to your CONFIG.SYS file.\n\nOK to make changes?");
				flStyle =  (MB_MOVEABLE | MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON1);
				if (usHelpID != 0)
					flStyle |= MB_HELP;
				if (WinMessageBox(HWND_DESKTOP,
													hwnd,
													pchLines,
													szCaption,
													usHelpID,
													flStyle) != MBID_YES)
					{
					if (iLoadCount > 1)
						sprintf(pchLines,"You will need to add %s DEVICE=%s statement lines to your CONFIG.SYS file to complete this configuration.",aszOrdinals[iLoadCount],szDeviceStatement);
          else
            sprintf(pchLines,"You will need to add one DEVICE=%s statement to your CONFIG.SYS file to complete this configuration.",szDeviceStatement);
          WinMessageBox(HWND_DESKTOP,
                        hwnd,
                        pchLines,
                        szCaption,
                        0L,
											 (MB_MOVEABLE | MB_OK | MB_ICONASTERISK));
          DosClose(hFile);
					DosFreeMem(pchFile);
          DosFreeMem(pchLines);
          return(FALSE);
          }
        }
      iLen = 0;
      if (iDDcount == 0)
        iLen = sprintf(pchLines,"\x0d\x0a");
			for (ulIndex = 0;ulIndex < iLoadCount;ulIndex++)
        iLen += sprintf(&pchLines[iLen],"DEVICE=%s\x0d\x0a",szDeviceStatement);
      if (DosAllocMem((PVOID)&pchNew,(ulCount + iLen + 20),(PAG_COMMIT | PAG_READ | PAG_WRITE)) == NO_ERROR)
        {
				memcpy(pchNew,pchFile,ulCount);
        if (iDDcount == 0)
          {
					ulLastOffset = ulCount;
          while (pchNew[ulLastOffset - 1] == '\x1a')
            ulLastOffset--;
          }
        else
					memcpy(&pchNew[ulLastOffset + iLen],&pchFile[ulLastOffset],(ulCount - ulLastOffset));
        memcpy(&pchNew[ulLastOffset],pchLines,iLen);
        ulCount += iLen;
        pchNew[ulCount++] = '\x1a';
        DosSetFileSize(hFile,ulCount);
        DosWrite(hFile,pchNew,ulCount,&ulCount);
        DosFreeMem(pchNew);
        }
      }
    }
	DosClose(hFile);
  DosFreeMem(pchLines);
  DosFreeMem(pchFile);
  return(TRUE);
	}

BOOL EXPENTRY CleanConfigSys(HWND hwnd,char szDDspec[],USHORT usHelpID,BOOL bAskFirst)
	{
	HFILE hFile;
	ULONG ulCount;
	char *pchFile;
	char szLine[255];
	char szCaption[80];
	ULONG ulOffset;
	ULONG ulLength;
	ULONG ulFilePosition;
  BOOL bFileChanged = FALSE;
  ULONG flStyle;

	if ((ulCount = ReadConfigSys(&hFile,&pchFile)) == 0)
    {
    sprintf(szCaption,"Unable to Open System Configuration File");
		sprintf(szLine,"You will need to remove all DEVICE=%s.SYS statement(s) from your CONFIG.SYS file to complete this process.",szDDspec);
		flStyle =  (MB_MOVEABLE | MB_OK | MB_ICONHAND);
		if (usHelpID != 0)
			flStyle |= MB_HELP;
		WinMessageBox(HWND_DESKTOP,
									hwnd,
									szLine,
									szCaption,
									(usHelpID + 1),
									flStyle);
		return(FALSE);
		}
	if (pchFile[ulCount - 1] == '\x1a')
	 ulCount--;
	pchFile[ulCount] = 0;
	ulOffset = 0;
	while ((ulOffset = FindLineWith(szDDspec,pchFile,ulOffset,&ulLength)) != 0)
		{
		bFileChanged = TRUE;
		ulCount -= ulLength;
		memcpy(&pchFile[ulOffset],&pchFile[ulOffset + ulLength],(ulCount - ulOffset));
		pchFile[ulCount] = 0;
		ulOffset = 0;
    }
  if (bFileChanged)
    {
    if (bAskFirst)
      {
      sprintf(szCaption,"System Configuration File needs to be updated");
      if (szDDspec[strlen(szDDspec) - 4] == '.')
        szDDspec[strlen(szDDspec) - 4] = 0;
      sprintf(szLine,"All ""DEVICE=%s.SYS"" statements from a previous device driver version need to be removed from your CONFIG.SYS file.\n\nOK to make changes?",szDDspec);
      flStyle =  (MB_MOVEABLE | MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON1);
      if (usHelpID != 0)
        flStyle |= MB_HELP;
      if (WinMessageBox(HWND_DESKTOP,
                        hwnd,
                        szLine,
                        szCaption,
                        usHelpID ,
                        flStyle) != MBID_YES)
        {
        sprintf(szLine,"You will need to remove all DEVICE=%s.SYS statements from your CONFIG.SYS file to complete this configuration.",szDDspec);
        WinMessageBox(HWND_DESKTOP,
                      hwnd,
                      szLine,
                      szCaption,
                      0L,
                     (MB_MOVEABLE | MB_OK | MB_ICONASTERISK));
        bFileChanged = FALSE;
        }
      }
    if (bFileChanged)
      {
      if (pchFile[ulCount - 1] == '\x0a')
        ulCount -= 2;
      pchFile[ulCount++] = '\x1a';
      DosSetFileSize(hFile,ulCount);
      DosSetFilePtr(hFile,0L,0L,&ulFilePosition);
      DosWrite(hFile,pchFile,ulCount,&ulCount);
      }
    }
  DosClose(hFile);
  DosFreeMem(pchFile);
  return(bFileChanged);
  }

#ifdef this_junk
BOOL EXPENTRY  GetDriverPath(HFILE hCom,char szPath[])
  {
  char szError[81];
//  APIRET rc = 0;
  ULONG ulDataLen = (ULONG)(sizeof(EXTDATA) + MAX_DD_PATH);
  ULONG ulParmLen = (ULONG)sizeof(EXTPARM);
  EXTPARM stParams;
  EXTDATA *pstData;
  BOOL bSuccess = FALSE;

  stParams.wSignature = SIGNATURE;
  stParams.wDataCount = MAX_DD_PATH;
  stParams.wCommand = EXT_CMD_GET_PATH;
  stParams.wModifier = 0;
  if (DosAllocMem((PPVOID)&pstData,ulDataLen,(PAG_COMMIT | PAG_READ | PAG_WRITE)) == NO_ERROR)
    {
  	if (DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,pstData,ulDataLen,&ulDataLen) == NO_ERROR)
      {
      strcpy(szPath,(CHAR *)&pstData->byData);
      bSuccess = TRUE;
      }
    DosFreeMem(pstData);
    }
  return(bSuccess);
  }
#endif




