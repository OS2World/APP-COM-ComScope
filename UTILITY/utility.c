#include "COMMON.H"
#include "utility.h"


BOOL EXPENTRY GetFileName (HWND hwnd,char *pszFileName,char *pszTitle,PFNWP OpenFilterProc)
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

void EXPENTRY RemoveLeadingSpaces(char szString[])
  {
  int iIndex;
  int iOffset;

  for (iIndex = 0;iIndex <= 8;iIndex++)
    if (szString[iIndex] != ' ')
      break;
  iOffset = 0;
  for (;iIndex < 8;iIndex++)
    szString[iOffset++] = szString[iIndex];
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

VOID EXPENTRY MenuItemEnable(HWND hwnd,USHORT idItem,BOOL bEnable)
  {
  WinSendMsg(WinWindowFromID(hwnd,FID_MENU),
             MM_SETITEMATTR,
             MPFROM2SHORT(idItem,TRUE),
             MPFROM2SHORT(MIA_DISABLED, bEnable ? ~MIA_DISABLED : MIA_DISABLED));
  }

VOID EXPENTRY MenuItemCheck(HWND hwnd,USHORT idItem,BOOL bCheck)
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

VOID EXPENTRY ControlEnable(HWND hwndDlg,USHORT idItem,BOOL bEnable)
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
  USHORT wIndex = 0;

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
  USHORT wIndex = 0;

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
  USHORT wIndex = 0;

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
    USHORT wIndex = 0;
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

VOID EXPENTRY RemoveSystemMenuItem(HWND hwnd,USHORT usMenuItem)
  {
  HWND     hwndSysMenu;                 /* sys menu pull-down handle */
  MENUITEM miTemp;                      /* menu item template        */

  /*******************************************************************/
  /* Get the handle of the system menu pull-down.                    */
  /*******************************************************************/
  if ((hwndSysMenu = WinWindowFromID(hwnd,FID_SYSMENU)) != 0)
    {
    if (WinSendMsg(hwndSysMenu,MM_QUERYITEM,MPFROM2SHORT(SC_SYSMENU,FALSE),MPFROMP(&miTemp)))
      WinSendMsg(miTemp.hwndSubMenu,MM_DELETEITEM,MPFROM2SHORT(usMenuItem,FALSE),NULL);
    }
  }

void EXPENTRY MakeDeviceName(char szName[])
  {
  USHORT wIndex = 0;

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



