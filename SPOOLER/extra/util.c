#include "serial.h"

void RemoveSpaces(char szString[]);
//void AppendTripleDS(char szFileSpec[]);
//extern CHAR szErrorMessage[];
//extern CHAR chAnsi[];

extern char szDriverIniPath[];

//extern LONG lXScr;
//extern LONG lcxVSc;
//extern LONG lcxBrdr;
//extern WORD wForeground;
//extern WORD wBackground;
//extern USHORT usWndWidth;
//extern USHORT usWndDepth;
//extern CHCELL  stCell;

//extern CHAR szErrorMessage[];

//extern char szPortName[];

//extern BOOL bTerminal;
//extern BOOL bErrorOut;

extern HAB habAnchorBlock;
//extern HFILE hCom;
//extern HWND hwndFrame;
//extern HWND hwndClient;

//POINTL ptlMsgLine = {20,20};

BOOL Checked(HWND hwnd,SHORT idDlgItem)
  {
  return(SHORT1FROMMR(WinSendMsg(WinWindowFromID(hwnd,idDlgItem),BM_QUERYCHECK,0L,0L)));
  }

VOID CheckButton(HWND hwnd,USHORT idItem,BOOL bCheck)
  {
  WinSendMsg(WinWindowFromID(hwnd,idItem),BM_SETCHECK,MPFROM2SHORT(bCheck,0),0L);
  }

VOID MenuItemEnable(HWND hwnd,WORD idItem,BOOL bEnable)
  {
  WinPostMsg(WinWindowFromID(hwnd,FID_MENU),
	     MM_SETITEMATTR,
	     MPFROM2SHORT(idItem,TRUE),
	     MPFROM2SHORT(MIA_DISABLED, bEnable ? ~MIA_DISABLED : MIA_DISABLED));
  }

VOID MenuItemCheck(HWND hwnd,WORD idItem,BOOL bCheck)
  {
  WinSendMsg(WinWindowFromID(hwnd,FID_MENU),
	     MM_SETITEMATTR,
	     MPFROM2SHORT(idItem,TRUE),
	     MPFROM2SHORT(MIA_CHECKED, bCheck ? MIA_CHECKED : ~MIA_CHECKED));
  }

VOID ControlEnable(HWND hwnd,WORD idItem,BOOL bEnable)
  {
  WinEnableWindow(WinWindowFromID(hwnd,idItem),bEnable);
  }

BOOL GetLongIntDlgItem(HWND hwnd,SHORT idEntryField,ULONG *pulValue)
  {
  CHAR szValue[12];
  SHORT iLength;

  iLength = WinQueryDlgItemText(hwnd,idEntryField,sizeof(szValue),szValue);
  if (iLength > 10)
    return(FALSE);
  szValue[iLength] = 0;
  *pulValue = atol(szValue);
  return(TRUE);
  }

VOID MessageBox(HWND hwnd,PSZ pszMessage)
    {
    WinMessageBox( HWND_DESKTOP,
                   hwnd,
                   pszMessage,
                   0,
                   0,
                   MB_MOVEABLE | MB_OK | MB_CUAWARNING );

    }

BOOL FillDeviceNameList(LINKLIST *pstNameList,DCBPOS *pstCount)
  {
  WORD wStatus;
  HFILE hFile;
  WORD wIndex;
  WORD wDCBindex;
  WORD wCount;
  CFGINFO stConfigInfo;
  CFGHEAD stConfigHeader;
  DCBHEAD stDCBheader;
  ULONG ulFilePosition;
  char szString[9];
  char szTemp[9];
  HFILE hCom;
  ULONG ulAction;
  BOOL bDevicesActive = FALSE;

  pstCount->wLoadNumber = 0;
  pstCount->wDCBnumber = 0;
  if (DosOpen(szDriverIniPath,(PHFILE)&hFile,(PULONG)&wStatus,0L,0,1,0x1312,(PEAOP2)0L) != 0)
    return(FALSE);
  if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),(PULONG)&wCount) == 0)
    {
    if (stConfigInfo.wCFGheaderCount != 0)
      {
      DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
      for (wIndex = 1;wIndex <= stConfigInfo.wCFGheaderCount;wIndex++)
        {
        if (DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),(PULONG)&wCount) == 0)
          {
          if (!stConfigHeader.bHeaderIsInitialized)
            {
            DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
            continue;
            }
          pstCount->wLoadNumber++;
          DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
          for (wDCBindex = 1;wDCBindex <= stConfigHeader.wDCBcount;wDCBindex++)
            {
            if (DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),(PULONG)&wCount) == 0)
              {
              if (stDCBheader.bHeaderIsInitialized)
                {
                if (stDCBheader.stComDCB.wIObaseAddress != 0xffff)
                  {
                  strncpy(szString,stDCBheader.abyPortName,8);
                  strncpy(szTemp,szString,8);
                  pstCount->wDCBnumber++;
                  bDevicesActive = TRUE;
                  RemoveSpaces(szString);
                  AddListItem(pstNameList,szString,8);
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
  return(bDevicesActive);
  }

VOID AppendTripleDS(char szString[])
  {
  szString[9] = 0;
  szString[8] = szString[5];
  szString[7] = szString[4];
  szString[6] = szString[3];
  szString[5] = '$';
  szString[4] = '$';
  szString[3] = '$';
  }

void RemoveSpaces(char szString[])
  {
  int iIndex;

  for (iIndex = 0;iIndex <= 8;iIndex++)
    if (szString[iIndex] == ' ')
      break;
  szString[iIndex] = 0;
  }


