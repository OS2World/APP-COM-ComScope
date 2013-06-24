#include "COMMON.H"
#include "utility.h"
#include "install.h"
#include "CONFIG.H"
#include "comdd.h"

extern INSTALL stInst;

extern char szConfigAppName[];

extern char *pszUninstallIniPath;
extern char szConfigDDname[];

extern char szBannerOne[];
extern char szBannerTwo[];

extern UNINST stUninstall;

extern char *pszPath;
extern FATTRS fattMsgFont;
extern CELL stMsgCell;
extern char szDebugLineOne[];
extern char szDebugLineTwo[];

extern HWND hwndClient;

void MemFree(char *pBuffer)
  {
  if (pBuffer != NULL)
    {
    free(pBuffer);
    pBuffer = NULL;
    }
  }

BOOL MemAlloc(char **ppBuffer,ULONG cbSize)
  {
#ifdef no_realloc
  if (*ppBuffer != NULL)
    free(*ppBuffer);
  *ppBuffer = malloc(cbSize);
#else
  *ppBuffer = realloc(*ppBuffer,cbSize);
#endif
  if (*ppBuffer == NULL)
    {
    MessageBox(stInst.hwndFrame,"Memory allocation failed");
    DosExit(0,40);
    }
  memset(*ppBuffer,0,cbSize);
  return(TRUE);
  }

void PrintBanners(char szBannerOne[],char szBannerTwo[])
  {
  HPS hps;
  RECTL rcl;
  LONG lLen;
  POINTL pt;

  hps = WinGetPS(hwndClient);
  WinQueryWindowRect(hwndClient,&rcl);
  rcl.yTop = 60L;
  WinFillRect(hps,&rcl,CLR_WHITE);
  GpiSetBackColor( hps, CLR_WHITE );
  GpiSetBackMix( hps, BM_OVERPAINT );

  GpiCreateLogFont(hps,
                   NULL,
                   3,
                  &fattMsgFont);

  GpiSetColor( hps, CLR_BLACK );
  GpiSetCharSet(hps,3);
  lLen = strlen(szBannerOne);
  pt.x = ((INITWIDTH - (lLen * stMsgCell.cx)) / 2);
  pt.y = 40L;
  GpiCharStringAt(hps,&pt,lLen,szBannerOne );

  lLen = strlen(szBannerTwo);
  pt.x = ((INITWIDTH - (lLen * stMsgCell.cx)) / 2);
  pt.y = 20L;
  GpiCharStringAt( hps, &pt,lLen,szBannerTwo );
  WinReleasePS(hps);
  }

void PrintDebug(char szLineOne[],char szLineTwo[])
  {
  HPS hps;
  RECTL rcl;
  POINTL pt;
  char szMessage[200];
  if (hwndClient != 0)
    {
    hps = WinGetPS(hwndClient);
    WinQueryWindowRect(hwndClient,&rcl);
    rcl.yBottom = 60L;
    WinFillRect(hps,&rcl,CLR_WHITE);
    GpiSetBackColor(hps,CLR_WHITE );
    GpiSetBackMix(hps,BM_OVERPAINT );

    GpiCreateLogFont(hps,NULL,3,&fattMsgFont);

    GpiSetColor( hps, CLR_BLACK );
    GpiSetCharSet(hps,3);
    pt.x = 10;

    pt.y = 82L;
    GpiCharStringAt(hps,&pt,strlen(szLineOne),szLineOne);

    pt.y = 62L;
    GpiCharStringAt(hps,&pt,strlen(szLineTwo),szLineTwo);

    WinReleasePS(hps);
    strcpy(szDebugLineOne,szLineOne);
    strcpy(szDebugLineTwo,szLineTwo);
    }
  }

void PrintUninstallProgress(char szDelete[])
  {
  HPS hps;
  RECTL rcl;
  char szString[100];
  LONG lLen;
  POINTL pt;
  LONG lPathEnd;
  LONG lMaxChar;
  char *pszString;

  hps = WinGetPS(hwndClient);
  WinQueryWindowRect(hwndClient,&rcl);
  rcl.yTop = 60L;
  WinFillRect(hps,&rcl,CLR_WHITE);
  GpiSetBackColor( hps, CLR_WHITE );
  GpiSetBackMix( hps, BM_OVERPAINT );

  GpiCreateLogFont(hps,
                   NULL,
                   3,
                  &fattMsgFont);

  GpiSetColor( hps, CLR_BLACK );
  GpiSetCharSet(hps,3);
  pt.x = (stMsgCell.cx / 2);

  pt.y = 35L;

  sprintf(szString,"Deleting %s",szDelete);
  lLen = strlen(szDelete);
  lMaxChar = ((INITWIDTH - 1) / stMsgCell.cx);
  if (lLen > lMaxChar)
    {
    lPathEnd = ((lMaxChar / 2) - 15);
    strncpy(szString,szDelete,lPathEnd);
    lPathEnd += sprintf(&szString[lPathEnd],"......%s",&szDelete[lLen - (lMaxChar / 2)]);
    pszString = szString;
    }
  else
    {
    lPathEnd = lLen;
    pszString = szDelete;
    }
  pt.y = 20L;
  GpiCharStringAt( hps,&pt,lPathEnd,pszString );

  WinReleasePS(hps);
  }

void PrintProgress(char szFrom[],char szTo[])
  {
  HPS hps;
  RECTL rcl;
  char szString[100];
  LONG lLen;
  POINTL pt;
  LONG lPathEnd;
  LONG lMaxChar;
  char *pszString;

  hps = WinGetPS(hwndClient);
  WinQueryWindowRect(hwndClient,&rcl);
  rcl.yTop = 60L;
  WinFillRect(hps,&rcl,CLR_WHITE);
  GpiSetBackColor( hps, CLR_WHITE );
  GpiSetBackMix( hps, BM_OVERPAINT );

  GpiCreateLogFont(hps,
                   NULL,
                   3,
                  &fattMsgFont);

  GpiSetColor( hps, CLR_BLACK );
  GpiSetCharSet(hps,3);
  pt.x = (stMsgCell.cx / 2);

  lLen = sprintf(szString,"Copying %s to:",szFrom);
  pt.y = 35L;
  GpiCharStringAt(hps,&pt,lLen,szString );

  lLen = strlen(szTo);
  lMaxChar = ((INITWIDTH - 1) / stMsgCell.cx);
  if (lLen > lMaxChar)
    {
    lPathEnd = ((lMaxChar / 2) - 6);
    strncpy(szString,szTo,lPathEnd);
    lPathEnd += sprintf(&szString[lPathEnd],"......%s",&szTo[lLen - (lMaxChar / 2)]);
    pszString = szString;
    }
  else
    {
    lPathEnd = lLen;
    pszString = szTo;
    }
  pt.y = 10L;
  GpiCharStringAt( hps,&pt,lPathEnd,pszString );

  WinReleasePS(hps);
  }

USHORT OpenFile(BYTE *pbyPath,HFILE *phFile,ULONG *pulStatus,ULONG ulFileSize,ULONG ulFileAttrib,ULONG ulOpenFlag,ULONG ulOpenMode)
  {
  USHORT Error = 0;

  if ((Error = DosOpen(pbyPath,phFile,pulStatus,ulFileSize,ulFileAttrib,ulOpenFlag,ulOpenMode,0L)) != 0)
    {
    if (Error == 87)
      {
      ulOpenMode &= ~0x6f80;
      Error = DosOpen(pbyPath,phFile,pulStatus,ulFileSize,ulFileAttrib,ulOpenFlag,ulOpenMode,0L);
      }
    }
  return(Error);
  }

void SetEndOfPath(char szPath[])
  {
  int iIndex;

  for (iIndex = strlen(szPath);iIndex >= 0;iIndex--)
    {
    if (szPath[iIndex] == '\\')
      {
      szPath[iIndex] = 0;
      break;
      }
    if (szPath[iIndex] == ':')
      {
      szPath[iIndex + 1] = 0;
      break;
      }
    }
  }

BOOL GetDriverPath(HFILE hCom,char szPath[])
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
      strcpy(szPath,(CHAR *)&pstData->wData);
      bSuccess = TRUE;
      }
    DosFreeMem(pstData);
    }
  return(bSuccess);
  }

VOID SetInitialPosition(HWND hwnd)
  {
  LONG lX;
  LONG lY;
  LONG lWidth;
  LONG lcyBrdr;
  LONG lcyMenu;
  LONG lcyTitleBar;
  LONG lXScr;
  LONG lYScr;

  lXScr = (SHORT)WinQuerySysValue(HWND_DESKTOP,SV_CXSCREEN);
  lYScr = (SHORT)WinQuerySysValue(HWND_DESKTOP,SV_CYSCREEN);

  lcyBrdr = WinQuerySysValue(HWND_DESKTOP,SV_CYBORDER);
  lcyTitleBar = WinQuerySysValue(HWND_DESKTOP,SV_CYTITLEBAR);
  lcyMenu = WinQuerySysValue(HWND_DESKTOP,SV_CYMENU);

  lWidth = (INITHEIGHT + (lcyBrdr * 2) + lcyMenu + lcyTitleBar);
  lX = ((lXScr - INITWIDTH) / 2);
  lY = ((lYScr - lWidth) / 2);

  WinSetWindowPos(hwnd,HWND_TOP,lX,lY,INITWIDTH,lWidth,(SWP_MOVE | SWP_SIZE));
  }

VOID CenterWindow(HWND hwnd)
  {
  SHORT iX;
  SHORT iY;
  SHORT iWidth;
  SHORT iDepth;
  SWP   swp;

  iWidth = (SHORT)WinQuerySysValue(HWND_DESKTOP,SV_CXSCREEN);
  iDepth = (SHORT)WinQuerySysValue(HWND_DESKTOP,SV_CYSCREEN);

  WinQueryWindowPos(hwnd,&swp);

  iX = (iWidth - swp.cx) / 2;
  iY = (iDepth - swp.cy) / 2;

  WinSetWindowPos(hwnd,HWND_TOP,iX,iY,0,0,SWP_MOVE);
  }

#ifdef this_junk
void RemoveAppMenu(void)
  {
  MENUITEM mi;
  HWND hwnd;
  char szText[40];

  hwnd = WinWindowFromID(stInst.hwndFrame,FID_MENU);
  WinSendMsg(hwnd,MM_REMOVEITEM,MPFROM2SHORT(IDM_CONFIG_DD,TRUE),(MPARAM)0))
  WinSendMsg(hwnd,MM_REMOVEITEM,MPFROM2SHORT(IDM_CONFIG_DD,TRUE),(MPARAM)0))
    {
    sprintf(szText,"~%s...",szConfigAppName);
    mi.iPosition++;
    mi.id = IDM_CONFIG_APP;
    mi.hwndSubMenu = 0;
    mi.hItem = 0;
//    mi.flStyle |= MIS_SUBMENU;
    WinSendMsg(hwnd,MM_INSERTITEM,MPFROMP(&mi),MPFROMP(szText));
    }
  }

//#ifdef this_junk
BOOL RecoverProfile(HINI hProfile)
  {
  HINI hDestProfile;
  HINI hSourceProfile;
  APIRET rc;
  char szTempFile[40];
  char *pIniFile;
  PRFPROFILE stProfileNames;

  stProfileNames.cchUserName = 0;
  stProfileNames.cchSysName = 0;
  PrfQueryProfile(habAnchorBlock,&stProfileNames);
  stProfileNames.pszUserName = malloc(stProfileNames.cchUserName + 1);
  stProfileNames.pszSysName = malloc(stProfileNames.cchSysName + 1);
  PrfQueryProfile(habAnchorBlock,&stProfileNames);
  if (hProfile == HINI_USERPROFILE)
    strcpy(szTempFile,"C:\\OS2\\_USER_.INI");
  else
    strcpy(szTempFile,"C:\\OS2\\_SYSTEM_.INI");
  if ((hDestProfile = PrfOpenProfile(habAnchorBlock,szTempFile)) != 0)
    {
    if (CopyProfile(hProfile,hDestProfile))
      {
      if (PrfCloseProfile(hDestProfile))
        {
        if (hProfile == HINI_USERPROFILE)
          {
          pIniFile = stProfileNames.pszUserName;
          stProfileNames.pszUserName = szTempFile;
          stProfileNames.cchUserName = sizeof(szTempFile);
          }
        else
          {
          pIniFile = stProfileNames.pszSysName;
          stProfileNames.pszSysName = szTempFile;
          stProfileNames.cchSysName = sizeof(szTempFile);
          }
        if (PrfReset(habAnchorBlock,&stProfileNames))
          {
          DosCopy(szTempFile,pIniFile,DCPY_EXISTING);
          if (hProfile == HINI_USERPROFILE)
            {
            stProfileNames.pszUserName = pIniFile;
            stProfileNames.cchUserName = sizeof(pIniFile);
            }
          else
            {
            stProfileNames.pszSysName = pIniFile;
            stProfileNames.cchSysName = sizeof(pIniFile);
            }
          if (PrfReset(habAnchorBlock,&stProfileNames))
            DosDelete(szTempFile);
          }
        }
      }
    else
      PrfCloseProfile(hDestProfile);
    }
  free(stProfileNames.pszUserName);
  free(stProfileNames.pszSysName);
  return(TRUE);
  }

BOOL CopyProfile(HINI hSourceProfile,HINI hDestinationProfile)
  {
  int iAppIndex;
  int iKeyIndex;
  char *pKeyNames;
  char *pAppNames;
  char *pAppName;
  char *pKeyName;
  ULONG ulAppSize;
  ULONG ulDataSize;
  ULONG ulKeySize;
  void *pData;

  PrfQueryProfileSize(hSourceProfile,0L,0L,&ulAppSize);
  if ((pAppNames = malloc(ulAppSize + 1)) == NULL)
    return(FALSE);
  PrfQueryProfileString(hSourceProfile,0L,0L,0L,pAppNames,ulAppSize);
  iAppIndex = 0;
  while (iAppIndex < ulAppSize)
    {
    pAppName = &pAppNames[iAppIndex];
    PrfQueryProfileSize(hSourceProfile,pAppName,0L,&ulKeySize);
    if ((pKeyNames = malloc(ulKeySize + 1)) == NULL)
      {
      free (pAppNames);
      return(FALSE);
      }
    PrfQueryProfileString(hSourceProfile,pAppName,0L,0L,pKeyNames,ulKeySize);
    iKeyIndex = 0;
    while (iKeyIndex < ulKeySize)
      {
      pKeyName = &pKeyNames[iKeyIndex];
      PrfQueryProfileSize(hSourceProfile,pAppName,pKeyName,&ulDataSize);
      if ((pData = malloc(ulDataSize + 1)) != NULL)
        {
        PrfQueryProfileData(hSourceProfile,pAppName,pKeyName,pData,&ulDataSize);
        PrfWriteProfileData(hDestinationProfile,pAppName,pKeyName,pData,ulDataSize);
        free(pData);
        }
      while(pKeyNames[iKeyIndex++] != 0);
      if (pKeyNames[iKeyIndex] == 0)
        break;;
      }
    free(pKeyNames);
    while(pAppNames[iAppIndex++] != 0);
    if (pAppNames[iAppIndex] == 0)
      break;;
    }
  free(pAppNames);
  return(TRUE);
  }
#endif
