#include "serial.h"

BOOL TerminatePort(char szPortName[]);
BOOL InitializePort(char szPortName[]);
BOOL RemovePort(char szPortName[]);
BOOL InstallPort(char szPortName[]);
BOOL SetupPort(char szPortName[]);
ULONG QueryPort(char szPortName[],char achBuffer[],ULONG cbBuffSize);
BOOL EnumeratePorts(char achBuffer[],ULONG cbBuffSize);

BOOL WndSize(HWND hwnd,MPARAM mp2);
VOID CreatePS(HWND hwnd);

MRESULT EXPENTRY fnwpClient(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
VOID cdecl CenterDlgBox(HWND hwnd);
VOID cdecl PaintWindow( HWND hwnd, COLOR clr );
VOID cdecl ClientPaint(HWND hwnd);
VOID ClearScreen(void);

LONG lXScr;
LONG lcxVSc;
LONG lcxBrdr;
WORD wForeground;
WORD wBackground;
USHORT usWndWidth;
USHORT usWndDepth;
CHCELL  stCell;

char szDriverIniPath[CCHMAXPATH];

CHAR szErrorMessage[81];
char szMessage[200];
char szPortName[20] = "COM4";

HDC hdcPs;

CHAR szEXEtitle[] = "Serial PDR Test";
HAB habAnchorBlock;
HFILE hCom = 0;
HWND hwndFrame;
HWND hwndClient;
ERRORID eidError;

char achBuffer[4096];

char szModuleName[260] = "SERIALX.PDR";

ULONG ulItemCount;

SERIALDATA stPortData;

void cdecl main(int argc,char *argv[])
  {
  HMQ hmqQueue;
  QMSG qmsgMessage;
  ULONG flCreate;
  LONG lIndex;

  if (argc >= 2)
    {
    for (lIndex = 1;lIndex < argc;lIndex++)
      {
      if ((argv[lIndex][0] == '/') || (argv[lIndex][0] == '-'))
        {
        switch (argv[lIndex][1] & 0xdf)
          {
          case 'L':
            strcpy(szModuleName,&argv[lIndex][2]);
            break;
	  case 'P':
            strcpy(szPortName,&argv[lIndex][2]);
            break;
          }
        }
      }
    }

  habAnchorBlock = WinInitialize(0);        /* Initialize PM                 */

  hmqQueue   = WinCreateMsgQueue(habAnchorBlock,0);   /* Create application msg queue */

  WinRegisterClass(habAnchorBlock,
                  "ICOMMAIN",
            (PFNWP)fnwpClient,
                   CS_SIZEREDRAW,
                   10);

  flCreate =  (FCF_STANDARD ^ FCF_SHELLPOSITION);

  hwndFrame = WinCreateStdWindow(HWND_DESKTOP,
                                 WS_VISIBLE,
                                &flCreate,
                                "ICOMMAIN",
                                 0,
                                (WS_VISIBLE | WS_CLIPCHILDREN),
                                 0,
				 IDM_SERIAL,
                                &hwndClient);

  if (hwndFrame == 0)
    {
    eidError = WinGetLastError(habAnchorBlock);
    return;
    }

  WinSetWindowText(hwndFrame,szEXEtitle);
  /*
  ** Set up globals used for sizing
  */

  lXScr   = WinQuerySysValue(HWND_DESKTOP,SV_CXSCREEN);
  lcxVSc  = WinQuerySysValue(HWND_DESKTOP,SV_CXVSCROLL);
  lcxBrdr = WinQuerySysValue(HWND_DESKTOP,SV_CXSIZEBORDER);

  while( WinGetMsg(habAnchorBlock,&qmsgMessage,(HWND)0,0,0))
    WinDispatchMsg(habAnchorBlock,&qmsgMessage);

  WinDestroyWindow(hwndFrame);
  WinDestroyMsgQueue(hmqQueue);
  WinTerminate(habAnchorBlock);
//  DosExit(1,0);
  }

MRESULT  EXPENTRY fnwpClient(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  RECTL   rcl;
  USHORT   Command;
  ULONG ulCount;

  switch(msg)
    {
    case WM_CREATE:
      stCell.cy = 12;
      stCell.cx = 8;
      hdcPs = WinOpenWindowDC(hwnd);

      /****************************************************************/
      /* Set the size and position of the frame window by making the  */
      /* client area width and height integral numbers of AVIO cell   */
      /* units.  Calculate the frame window values necessary to       */
      /* achieve this.                                                */
      /****************************************************************/

      rcl.yBottom = 0L;
      rcl.xLeft   = 0L;
      rcl.yTop    = 20 * stCell.cy;
      rcl.xRight  = 40  * stCell.cx;

      WinCalcFrameRect(WinQueryWindow(hwnd,QW_PARENT),
		       &rcl,
                       FALSE );
      WinSetWindowPos(WinQueryWindow(hwnd,QW_PARENT),
                       0,
                       7 * stCell.cx,
                       2 * stCell.cy,
                       (SHORT)(rcl.xRight - rcl.xLeft),
                       (SHORT)(rcl.yTop - rcl.yBottom),
                       SWP_MOVE | SWP_SIZE );

//      WinPostMsg(hwnd,UM_INIT,0L,0L);
      break;
    case WM_ACTIVATE:
      if(LOUSHORT(LONGFROMMP(mp1)))
        WinSetFocus(HWND_DESKTOP,hwnd);
      break;
    case UM_INIT:
      WinShowWindow(hwndFrame,TRUE);
//      WinSetFocus(HWND_DESKTOP,hwndClient);
      ClearScreen();
      break;
    case WM_PAINT:
      ClearScreen();
      break;
    case WM_SIZE:
      WndSize(hwnd,mp2);
      ClearScreen();
      return WinDefWindowProc(hwnd,msg,mp1,mp2);
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case IDM_EXIT:
          WinPostMsg(hwnd,WM_QUIT,0L,0L);
          break;
        case IDM_SETUP:
          SetupPort(szPortName);
          break;
        case IDM_ENUM:
          EnumeratePorts(achBuffer,4096);
          break;
        case IDM_REMOVE:
          RemovePort(szPortName);
          break;
        case IDM_INSTALL:
          InstallPort(szPortName);
          break;
        case IDM_INIT:
          InitializePort(szPortName);
          break;
        case IDM_TERM:
          TerminatePort(szPortName);
          break;
        case IDM_QUERY:
          ulItemCount = QueryPort(szPortName,achBuffer,4096);
          break;
        default:
          return WinDefWindowProc(hwnd,msg,mp1,mp2);
        }
      break;
    case WM_CLOSE:
      WinPostMsg(hwnd,WM_QUIT,0L,0L);  /* Cause termination     */
      break;
    default:
      return WinDefWindowProc(hwnd,msg,mp1,mp2);
    }
  return(FALSE);
  }

BOOL SetupPort(char szPortName[])
  {
//APIRET EXPENTRY SplPdSetPort(HAB hab,PSZ pszPortName,PULONG flModified)
  HMODULE hMod;
  PFN pfnProcess;
  BOOL bModified = FALSE;

  if (DosLoadModule(0,0,szModuleName,&hMod) == NO_ERROR)
    {
    if (DosQueryProcAddr(hMod,0,"SPLPDSETPORT",&pfnProcess) == NO_ERROR)
      pfnProcess(habAnchorBlock,szPortName,&bModified);
    DosFreeModule(hMod);
    }
  return(bModified);
  }

ULONG QueryPort(char szPortName[],char achBuffer[],ULONG cbBuffSize)
  {
//APIRET APIENTRY SplPdQueryPort(HAB hab,PSZ pszPortName,PVOID pBufIn,ULONG cbBuf,PULONG cItems)
  HMODULE hMod;
  PFN pfnProcess;
  ULONG ulItemCount = 0;

  if (DosLoadModule(0,0,szModuleName,&hMod) == NO_ERROR)
    {
    if (DosQueryProcAddr(hMod,0,"SPLPDQUERYPORT",&pfnProcess) == NO_ERROR)
      pfnProcess(habAnchorBlock,szPortName,achBuffer,cbBuffSize,&ulItemCount);
    DosFreeModule(hMod);
    }
  return(ulItemCount);
  }

BOOL EnumeratePorts(char achBuffer[],ULONG cbBuffSize)
  {
//APIRET APIENTRY SplPdEnumPort(HAB hab,PVOID pBuf,ULONG cbBuf,PULONG pulReturned,PULONG pulTotal,PULONG pcbRequired);
  ULONG ulReturned;
  ULONG ulTotal;
  ULONG cbRequired;
  HMODULE hMod;
  PFN pfnProcess;
  BOOL bSuccess = FALSE;

  if (DosLoadModule(0,0,szModuleName,&hMod) == NO_ERROR)
    {
    if (DosQueryProcAddr(hMod,0,"SPLPDENUMPORT",&pfnProcess) == NO_ERROR)
      {
      if (pfnProcess(habAnchorBlock,0,0,&ulReturned,&ulTotal,&cbRequired) == ERROR_MORE_DATA)
        if (cbRequired <= 1024)
          if (pfnProcess(habAnchorBlock,achBuffer,cbBuffSize,&ulReturned,&ulTotal,&cbRequired) != NO_ERROR)
            bSuccess = TRUE;
      }
    DosFreeModule(hMod);
    }
  return(bSuccess);
  }

BOOL RemovePort(char szPortName[])
  {
  HMODULE hMod;
  PFN pfnProcess;
  APIRET rc;

  if (DosLoadModule(0,0,szModuleName,&hMod) == NO_ERROR)
    {
    if (DosQueryProcAddr(hMod,0,"SPLPDREMOVEPORT",&pfnProcess) == NO_ERROR)
      rc = pfnProcess(habAnchorBlock,szPortName);
    DosFreeModule(hMod);
    }
  if (rc != NO_ERROR)
    return(TRUE);
  return(FALSE);
  }

BOOL InstallPort(char szPortName[])
  {
//APIRET APIENTRY SplPdInstallPort(HAB hab,PSZ pszPortName)
  HMODULE hMod;
  PFN pfnProcess;
  APIRET rc;

  if (DosLoadModule(0,0,szModuleName,&hMod) == NO_ERROR)
    {
    if (DosQueryProcAddr(hMod,0,"SPLPDINSTALLPORT",&pfnProcess) == NO_ERROR)
      rc = pfnProcess(habAnchorBlock,szPortName);
    DosFreeModule(hMod);
    }
  if (rc == NO_ERROR)
    return(TRUE);
  return(FALSE);
  }

BOOL InitializePort(char szPortName[])
  {
//APIRET APIENTRY SplPdInitPort(HFILE hCom,PSZ pszPortName)
  HMODULE hMod;
  PFN pfnProcess;
  APIRET rc;
  HFILE hCom;
  ULONG ulAction;

  if ((rc = DosOpen(szPortName,&hCom,&ulAction,0L,0L,0x0001,0x21c2,0L)) == NO_ERROR)
    {
    if (DosLoadModule(0,0,szModuleName,&hMod) == NO_ERROR)
      {
      if (DosQueryProcAddr(hMod,0,"SPLPDINITPORT",&pfnProcess) == NO_ERROR)
        rc = pfnProcess(hCom,szPortName);
      DosFreeModule(hMod);
      }
    DosClose(hCom);
    }
  if (rc == NO_ERROR)
    return(TRUE);
  return(FALSE);
  }

BOOL TerminatePort(char szPortName[])
  {
//APIRET APIENTRY SplPdInitPort(HFILE hCom,PSZ pszPortName)
  HMODULE hMod;
  PFN pfnProcess;
  APIRET rc;
  HFILE hCom;
  ULONG ulAction;

  if ((rc = DosOpen(szPortName,&hCom,&ulAction,0L,0L,0x0001,0x21c2,0L)) == NO_ERROR)
    {
    if (DosLoadModule(0,0,szModuleName,&hMod) == NO_ERROR)
      {
      if (DosQueryProcAddr(hMod,0,"SPLPDTERMPORT",&pfnProcess) == NO_ERROR)
        rc = pfnProcess(hCom,szPortName);
      DosFreeModule(hMod);
      }
    DosClose(hCom);
    }
  if (rc == NO_ERROR)
    return(TRUE);
  return(FALSE);
  }

VOID cdecl CenterDlgBox(HWND hwndDlg)
  {
  SHORT iX, iY;
  SHORT iWidth, iDepth;
  SWP swp;

  /* Query width and depth of screen device                          */
  iWidth = (SHORT)WinQuerySysValue(HWND_DESKTOP,SV_CXSCREEN);
  iDepth = (SHORT)WinQuerySysValue(HWND_DESKTOP,SV_CYSCREEN);

  /* Query width and depth of dialog box                             */
  WinQueryWindowPos(hwndDlg,(PSWP)&swp);

  /* Center dialog box within the screen                             */
  iX = (iWidth - swp.cx) / 2;
  iY = (iDepth - swp.cy) / 2;
  WinSetWindowPos(hwndDlg,HWND_TOP,iX,iY,0,0,SWP_MOVE);
  }

VOID cdecl ClientPaint( HWND hwnd )
  {
  POINTL  pt;
  HPS     hps;                          /* Presentation space handle */
  RECTL   rcl;                          /* Window rectangle          */
  CHAR    sz[80];

  /* Obtain a cache PS and set color and background mix attributes   */
  hps = WinBeginPaint(hwnd,(HPS)0,(PRECTL)&rcl);
  GpiSetColor(hps,CLR_WHITE);
  GpiSetBackColor(hps,CLR_BLUE);
  GpiSetBackMix(hps,BM_OVERPAINT);

  /* Build and draw entry field 1 constant text and variable data,   */
  /* ensuring previous contents are overwritten.                     */
  pt.x = 10L;
  pt.y = 70L;
  strcpy( sz, "Here we are");
  strcat( sz, " again" );
  strcat( sz, " " );
  GpiCharStringAt( hps, &pt, (LONG)strlen( sz ), (PSZ)sz );

  /* Build and draw entry field 2 constant text and variable data,   */
  /* ensuring previous contents are overwritten.                     */
  pt.y = 50L;
  strcpy( sz, "There we go" );
  strcat( sz, " still" );
  strcat( sz, " " );
  GpiCharStringAt( hps, &pt, (LONG)strlen( sz ), (PSZ)sz );

  /* Do the same for listbox selection information                   */
  pt.y = 30L;
  strcpy( sz, "Which way did" );
  strcat( sz, " he go" );
  strcat( sz, "          " );
  GpiCharStringAt( hps, &pt, (LONG)strlen( sz ), (PSZ)sz );

  /* Do the same for combobox selection information                  */
  pt.y = 10L;
  strcpy( sz, "He went" );
  strcat( sz, " thataway" );
  strcat( sz, "                    " );
  GpiCharStringAt( hps, &pt, (LONG)strlen( sz ), (PSZ)sz );

  /* Draw constant text below Color Sample child window              */
  pt.x = 250; pt.y = 120;
  GpiCharStringAt( hps, &pt, 12L, (PSZ)sz );
  WinEndPaint( hps );
 }

void ClearScreen(void)
  {
  HPS     hps;
  RECTL   rcl;

  WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
  hps = WinBeginPaint(hwndClient,(HPS)0,(PRECTL)&rcl);
//  GpiSetColor(hps,CLR_WHITE);
//  GpiSetBackColor(hps,CLR_BLUE);
//  GpiSetBackMix(hps,BM_OVERPAINT);
  WinFillRect(hps,&rcl,CLR_WHITE);
  WinEndPaint(hps);
 }


/**************************************************************************/
/* WNDSIZE:                                                               */
/* This function positions the Presentation Space correctly within a      */
/* sized window.  It adjusts the origin when necessary, so that there     */
/* are no gaps between the edge of the Presentation Space and the window  */
/* border.                                                                */
/**************************************************************************/
BOOL WndSize(HWND hwnd,MPARAM mp2)
  {
//  CURPOS  Cursor;

  usWndDepth = HIUSHORT(mp2)/ stCell.cy;
  usWndWidth = LOUSHORT(mp2)/ stCell.cx;

  /************************************************************************/
  /* The test below caters for the first instance of WM_SIZE that invokes */
  /* this function BEFORE window creation is complete and the Frame handle*/
  /* has been set.                                                        */
  /************************************************************************/

  hwndFrame = (hwndFrame != (HWND)0) ? hwndFrame : WinQueryWindow(hwnd,QW_PARENT);
  WinInvalidateRect(hwnd,(PRECTL)0,FALSE);
  return(TRUE);
  }


