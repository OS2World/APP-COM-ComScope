#include <COMMON.H>
#include <UTILITY.H>
#include "conn_dlg.h"
#include "menu.h"
#include "comm.h"
#include "connect.h"

MRESULT EXPENTRY fnwpConfigCommDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpLogonDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);

MRESULT EXPENTRY fnwpSubscriberDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
MRESULT EXPENTRY fnwpNotifyDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);

#define LOAD_NONE   0
#define LOAD_CLIENT 1
#define LOAD_SERVER 2

ULONG ulMaxMessageBufferSize = (4096 - sizeof(MSG));

typedef struct
    {
    SHORT cx;
    SHORT cy;
    }CHCELL;


ULONG ulMessageNumber = 100;

MSG stTestAddressee;

extern LOGON stLogon;
extern COMADDR stAddr;
extern  SUBSCRIBER astSubList[];
extern USHORT usSubscriberListCount;

extern GROUP astGroupList[];
extern USHORT usGroupListCount;

BOOL LoadCOMmod(ULONG fFlags);
BOOL InitializeCOM(HWND hwnd);
BOOL InitializeServer(HWND hwnd);
void COMthreadMonitor(void);

void Paint(void);
void ErrorNotify(char szMessage[]);
void PrintString(char szMessage[],ULONG ulPos);
void DisplayProcessError(APIRET rcErrorCode);
void DisplayMessageError(ULONG ulErrorType,ULONG ulErrorCode);

void ProcessRequest(HWND hwnd,MSG *pMessage);
void ProcessResponse(HWND hwnd,MSG *pMessage);

BOOL SendMessage(MSG *pMsg);

BOOL WndSize(HWND hwnd,MPARAM mp2);
VOID CreatePS(HWND hwnd);

MRESULT EXPENTRY fnwpClient(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2);
VOID PaintWindow( HWND hwnd, COLOR clr );
VOID ClientPaint(HWND hwnd);
VOID ClearScreen(void);

TID tidMonitor;

LONG lXScr;
LONG lcxVSc;
LONG lcxBrdr;
WORD wForeground;
WORD wBackground;
USHORT usWndWidth;
USHORT usWndDepth;
CHCELL  stCell;

ULONG ulWindowWidth;
ULONG ulWindowHeight;

CHAR szErrorMessage[81];
char szMessage[200];

HDC hdcPs;

CHAR szEXEtitle[] = "Aerial COM test";
HAB habAnchorBlock;
HWND hwndFrame;
HWND hwndClient;
ERRORID eidError;

HEV hevKillThreadSem;
HEV hevNotifyLoopSem;
BOOL bNotifyLoop;

char szModName[CCHMAXPATH] = "OS2LS_NC";
char szServerModName[CCHMAXPATH] = "SERVER";
char szClientModName[CCHMAXPATH] = "CLIENT";
BOOL bLoadServer = FALSE;
BOOL bLoadClient = FALSE;

PFN pfnSendMessage;
PFN pfnStopCOM;

HMODULE hMod;
ULONG fLoaded = 0;

void main(int argc,char *argv[])
  {
  HMQ hmqQueue;
  QMSG qmsgMessage;
  ULONG flCreate;
  LONG lIndex;
  APIRET rc;

  if (argc >= 2)
    {
    for (lIndex = 1;lIndex < argc;lIndex++)
      {
      if ((argv[lIndex][0] == '/') || (argv[lIndex][0] == '-'))
        {
        switch (argv[lIndex][1] & 0xdf)
          {
          case 'A':
            strcpy(stAddr.szAddressee,&argv[lIndex][2]);
            stAddr.fAddrType = BY_ADDR;
            break;
          case 'H':
            strcpy(stAddr.szAddressee,&argv[lIndex][2]);
            stAddr.fAddrType = BY_HOST;
            break;
          case 'C':
            strcpy(szModName,szClientModName);
            fLoaded = LOAD_CLIENT;
            break;
          case 'L':
            strcpy(szModName,&argv[lIndex][2]);
            break;
          case 'B':
            ulMaxMessageBufferSize = atoi(&argv[lIndex][2]);
            break;
          case 'S':
            strcpy(szModName,szServerModName);
            fLoaded = LOAD_SERVER;
            break;
          }
        }
      }
    }

  habAnchorBlock = WinInitialize(0);        /* Initialize PM                 */

  hmqQueue   = WinCreateMsgQueue(habAnchorBlock,(64 * sizeof(QMSG)));   /* Create application msg queue */

  WinRegisterClass(habAnchorBlock,
                  "CONNECT",
            (PFNWP)fnwpClient,
                   CS_SIZEREDRAW,
                   10);

  flCreate =  (FCF_STANDARD ^ FCF_SHELLPOSITION);

  hwndFrame = WinCreateStdWindow(HWND_DESKTOP,
                                 WS_VISIBLE,
                                &flCreate,
                                "CONNECT",
                                 0,
                                (WS_VISIBLE | WS_CLIPCHILDREN),
                                 0,
                                IDM_CONNECT,
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

  if (hMod != 0)
    DosFreeModule(hMod);
  WinDestroyWindow(hwndFrame);
  WinDestroyMsgQueue(hmqQueue);
  WinTerminate(habAnchorBlock);
  DosCloseEventSem(hevKillThreadSem);
  }

MRESULT  EXPENTRY fnwpClient(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  APIRET rc;
  RECTL   rcl;
  MSG *pMessage;
//  MSG *pMsg;
  NOTIFYLST *pNotifyList;
  USHORT usSubCount;
  USHORT usGroupCount;
  USHORT usMsgLen;
  LOGON *pLogon;
  ULONG *pulSubNum;
  SUBREQLST *pSubList;
  SERVERLST *pServerList;
  SUBRSPLST *pSubResponseList;
  ULONG *pulGroupNum;
  GROUPREQLST *pGroupList;
  GROUPRSPLST *pGroupResponseList;
  USHORT usCount;
  int iLen;
  char *pData;
  ULONG ulPostCount;
  int iIndex;
  SUBSCRIBER *pSub;
  GROUP *pGroup;

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
      rcl.xRight  = 60 * stCell.cx;

      WinCalcFrameRect(WinQueryWindow(hwnd,QW_PARENT),&rcl,FALSE);

      WinSetWindowPos(WinQueryWindow(hwnd,QW_PARENT),
                      0,
                      7 * stCell.cx,
                      2 * stCell.cy,
              (SHORT)(rcl.xRight - rcl.xLeft),
              (SHORT)(rcl.yTop - rcl.yBottom),
                      SWP_MOVE | SWP_SIZE);

      WinPostMsg(hwnd,UM_INIT,0L,0L);
      break;
    case UM_INIT:
      if ((rc = DosCreateEventSem(0L,&hevNotifyLoopSem,0L,TRUE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
        ErrorNotify(szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        }

      if ((rc = DosCreateEventSem(0L,&hevKillThreadSem,0L,TRUE)) != NO_ERROR)
        {
        sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
        ErrorNotify(szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        }

      if (DosLoadModule(0,0,szModName,&hMod) != NO_ERROR)
        {
        sprintf(szMessage,"Error Loading Module %s",szModName);
        ErrorNotify(szMessage);
        DosSleep(5000);
        WinPostMsg(hwnd,WM_QUIT,0L,0L);
        }

      MenuItemEnable(hwndFrame,IDM_CLIENT,FALSE);
      MenuItemEnable(hwndFrame,IDM_SERVER,FALSE);
      if (fLoaded != 0)
        {
        if (fLoaded == LOAD_SERVER)
          WinPostMsg(hwnd,WM_COMMAND,MPFROMSHORT(IDM_LOADSERVER),0L);
        else
          WinPostMsg(hwnd,WM_COMMAND,MPFROMSHORT(IDM_LOADCLIENT),0L);
//        MenuItemEnable(hwndFrame,IDM_SELECT,FALSE);
        }
      WinSetFocus(HWND_DESKTOP,hwnd);
      WinShowWindow(hwndFrame,TRUE);
      WinQueryWindowRect(hwndClient,&rcl);
      ulWindowWidth = rcl.xRight;
      ulWindowHeight = rcl.yTop;
      ClearScreen();
      DosResetEventSem(hevKillThreadSem,&ulPostCount);
      DosCreateThread(&tidMonitor,(PFNTHREAD)COMthreadMonitor,0,0,4096);
      if (fLoaded != 0)
        WinPostMsg(hwnd,WM_COMMAND,MPFROM2SHORT(0,IDM_INIT),0L);
      break;
    case WM_ACTIVATE:
      if(LOUSHORT(LONGFROMMP(mp1)))
        WinSetFocus(HWND_DESKTOP,hwnd);
      break;
    case UM_COM_THREAD:
      switch ((ULONG)mp1)
        {
        case COM_THREAD_END:
          PrintString("COM thread killed",3);
          break;
        case CON_ACCEPTED:
          sprintf(szMessage,"Connection accepted <%u>",(ULONG)mp2);
          PrintString(szMessage,4);
          break;
        case BUFF_ALLOCATED:
          sprintf(szMessage,"Message buffer allocated <%u>",(ULONG)mp2);
          PrintString(szMessage,5);
          break;
        case BUFF_RECEIVED:
          sprintf(szMessage,"Message Received <%u>",(ULONG)mp2);
          PrintString(szMessage,6);
          break;
        default:
          sprintf(szMessage,"Unknown event <%u>",(ULONG)mp2);
          PrintString(szMessage,7);
          break;
        }
      break;
    case WM_PAINT:
      Paint();
      break;
    case WM_SIZE:
      WndSize(hwnd,mp2);
      ClearScreen();
      return WinDefWindowProc(hwnd,msg,mp1,mp2);
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case IDM_NOTIFY:
          if ((pMessage = malloc(ulMaxMessageBufferSize + sizeof(MSG))) != 0)
            {
            if (WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpNotifyDlg,(USHORT)NULL,NOTIFY_DLG,pMessage))
              {
              pMessage->fMessageType = REQ_NOTIFY;
              pMessage->cbSize = (pMessage->cbDataSize + sizeof(MSG) - 1);
              pMessage->ulMessageNumber = ulMessageNumber++;
              SendMessage(pMessage);
              }

            free(pMessage);
            }
          break;
        case IDM_GET_SUBSCRIBER:
          if ((pMessage = malloc(ulMaxMessageBufferSize + sizeof(MSG))) != 0)
            {
            if (WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpSubscriberDlg,(USHORT)NULL,SUBSCRIBER_DLG,pMessage))
              {
              pMessage->fMessageType = REQ_QUERY_SUBSCRIBER;
              pMessage->cbSize = (pMessage->cbDataSize + sizeof(MSG) - 1);
              pMessage->ulMessageNumber = ulMessageNumber++;
              SendMessage(pMessage);
              }
            free(pMessage);
            }
          break;
        case IDM_GET_GROUP:
          if ((pMessage = malloc(ulMaxMessageBufferSize + sizeof(MSG))) != 0)
            {
            if (WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpSubscriberDlg,(USHORT)NULL,SUBSCRIBER_DLG,pMessage))
              {
              pMessage->fMessageType = REQ_QUERY_GROUP;
              pMessage->cbSize = (pMessage->cbDataSize + sizeof(MSG) - 1);
              pMessage->ulMessageNumber = ulMessageNumber++;
              SendMessage(pMessage);
              }
            free(pMessage);
            }
          break;
        case IDM_GET_SERVER:
          if ((pMessage = malloc(ulMaxMessageBufferSize + sizeof(MSG))) != 0)
            {
            pMessage->fMessageType = REQ_QUERY_SERVER;
            pMessage->cbSize = sizeof(MSG);
            pMessage->ulMessageNumber = ulMessageNumber++;
            SendMessage(pMessage);
            free(pMessage);
            }
          break;
        case IDM_ACK_NOTIFY:
          if ((pMessage = malloc(ulMaxMessageBufferSize + sizeof(MSG))) != 0)
            {
            memcpy(pMessage,&stTestAddressee,sizeof(MSG));
            pMessage->fMessageType = RSP_ACK_NOTIFY;
            pMessage->cbSize = sizeof(MSG);
            SendMessage(pMessage);
            sprintf(szMessage,"Notification acknowleded");
            PrintString(szMessage,11);
            free(pMessage);
            }
          break;
        case IDM_NAK_NOTIFY:
          if ((pMessage = malloc(ulMaxMessageBufferSize + sizeof(MSG))) != 0)
            {
            memcpy(pMessage,&stTestAddressee,sizeof(MSG));
            pMessage->fMessageType = RSP_NAK_NOTIFY;
            pMessage->cbSize = sizeof(MSG);
            pMessage->byData = REQ_ERROR_INVALID_GROUP;
            SendMessage(pMessage);
            sprintf(szMessage,"Notification error reported");
            PrintString(szMessage,11);
            free(pMessage);
            }
          break;
        case IDM_CFG_SERVER_ADDR:
          WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpConfigCommDlg,(USHORT)NULL,CFG_ADDR_DLG,&stAddr);
          break;
        case IDM_SET_PASSWORD:
           WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpLogonDlg,(USHORT)NULL,LOG_DLG,&stLogon);
          break;
        case IDM_EXIT:
        case IDM_EXITT:
          WinPostMsg(hwnd,WM_QUIT,0L,0L);
          break;
        case IDM_STOP_SERVER_THREAD:
          pfnStopCOM();
          MenuItemEnable(hwndFrame,IDM_LOADSERVER,TRUE);
          MenuItemEnable(hwndFrame,IDM_LOADCLIENT,TRUE);
          break;
        case IDM_LOADCLIENT:
          fLoaded = LOAD_CLIENT;
          if (InitializeCOM(hwnd))
            MenuItemEnable(hwndFrame,IDM_LOADCLIENT,FALSE);
          break;
        case IDM_LOADSERVER:
          fLoaded = LOAD_SERVER;
          if (InitializeServer(hwnd))
            MenuItemEnable(hwndFrame,IDM_SERVER,TRUE);
          MenuItemEnable(hwndFrame,IDM_LOADSERVER,FALSE);
          break;
        default:
          return WinDefWindowProc(hwnd,msg,mp1,mp2);
        }
      break;
    case UM_RESPONSE:
      if (mp1 == MESSAGE)
        ProcessResponse(hwnd,(MSG *)mp2);
      else
        {
        PrintString("Response reception error",13);
        DisplayMessageError((ULONG)mp1,(ULONG)mp2);
        }
      break;
    case UM_REQUEST:
      if (mp1 == MESSAGE)
        ProcessRequest(hwnd,(MSG *)mp2);
      else
        {
        PrintString("Request reception error",13);
        DisplayMessageError((ULONG)mp1,(ULONG)mp2);
        }
      break;
    case WM_CLOSE:
      WinPostMsg(hwnd,WM_QUIT,0L,0L);
      break;
    case WM_QUIT:
      if (pfnStopCOM())
        DosWaitEventSem(hevKillThreadSem,20000);
      break;
    default:
      return WinDefWindowProc(hwnd,msg,mp1,mp2);
    }
  return(FALSE);
  }

void COMthreadMonitor(void)
  {
  ULONG ulCount = 0;
  char szMsg[100];
  ULONG ulPostCount;
  BOOL bDone = FALSE;

  while (!bDone)
    {
    DosResetEventSem(hevKillThreadSem,&ulPostCount);
    DosWaitEventSem(hevKillThreadSem,-1);
    sprintf(szMsg,"COM thread ended <%u>",ulCount++);
    PrintString(szMsg,1);
    }
  }

#ifdef this_junk
BOOL LoadCOMmod(ULONG fFlags)
  {
  PFN pfnProcess;
  APIRET rc;

  if (hMod != 0)
    {
    sprintf(szMessage,"Unloading %s",szModName);
    PrintString(szMessage,3);
    DosFreeModule(hMod);
    }
  if (fFlags == LOAD_CLIENT)
    strcpy(szModName,szClientModName);
  else
    strcpy(szModName,szServerModName);
  if (strlen(szModName) != 0)
    if (DosLoadModule(0,0,szModName,&hMod) != NO_ERROR)
      hMod = 0;
  if (hMod == 0)
    {
    WinSetWindowText(hwndFrame,"COMM module not loaded");
    sprintf(szMessage,"Error Loading Module %s",szModName);
    ErrorNotify(szMessage);
    return(FALSE);
    }
  WinSetWindowText(hwndFrame,szModName);
  sprintf(szMessage,"%s loaded",szModName);
  PrintString(szMessage,4);
  return(TRUE);
  }
#endif
BOOL InitializeCOM(HWND hwnd)
  {
  APIRET rc;
  PFN pfnInitCOM;
  PFN pfnEnableDebug;
  ULONG ulLocal;

  sprintf(szMessage,"Initializing %s",szModName);
  PrintString(szMessage,3);
  if (hMod != 0)
    {
    if (DosQueryProcAddr(hMod,0,"SendRequest",(PFN *)&pfnSendMessage) != NO_ERROR)
      {
      ErrorNotify("Error getting SendRequest process address");
      return(FALSE);
      }
    if (DosQueryProcAddr(hMod,0,"StopCOM",(PFN *)&pfnStopCOM) != NO_ERROR)
      {
      ErrorNotify("Error getting StopCOM process address");
      return(FALSE);
      }
    if (DosQueryProcAddr(hMod,0,"EnableDebug",(PFN *)&pfnEnableDebug) != NO_ERROR)
      {
      ErrorNotify("Error getting EnableDebug process address");
      return(FALSE);
      }
    pfnEnableDebug(TRUE);
    if (DosQueryProcAddr(hMod,0,"InitCOM",(PFN *)&pfnInitCOM) == NO_ERROR)
      rc = pfnInitCOM(hwnd,hevKillThreadSem,ulMaxMessageBufferSize,&stAddr,&stLogon);
    else
      {
      ErrorNotify("Error getting InitCOM process address");
      return(FALSE);
      }
    }
  else
    {
    sprintf(szMessage,"Communications module not loaded");
    ErrorNotify(szMessage);
    return(FALSE);
    }
  if (rc != NO_ERROR)
    {
    DisplayProcessError(rc);
    return(FALSE);
    }
  MenuItemEnable(hwndFrame,IDM_INIT,FALSE);
  sprintf(szMessage,"Communications is initialized");
  PrintString(szMessage,4);
  return(TRUE);
  }

BOOL InitializeServer(HWND hwnd)
  {
  PFN pfnInitServer;
  PFN pfnEnableDebug;
  APIRET rc;
  HFILE hCom;
  ULONG ulAction;
  LOGON stLogon;
  COMADDR stAddr;
  ULONG ulLocal;

  sprintf(szMessage,"Initializing %s",szModName);
  PrintString(szMessage,3);
  if (hMod != 0)
    {
    if (DosQueryProcAddr(hMod,0,"SendResponse",(PFN *)&pfnSendMessage) != NO_ERROR)
      {
      ErrorNotify("Error getting SendCommand process address");
      return(FALSE);
      }
    if (DosQueryProcAddr(hMod,0,"StopServer",(PFN *)&pfnStopCOM) != NO_ERROR)
      {
      ErrorNotify("Error getting StopServer process address");
      return(FALSE);
      }
    if (DosQueryProcAddr(hMod,0,"EnableDebug",(PFN *)&pfnEnableDebug) != NO_ERROR)
      {
      ErrorNotify("Error getting EnableDebug process address");
      return(FALSE);
      }
    pfnEnableDebug(TRUE);
    if (DosQueryProcAddr(hMod,0,"InitServer",(PFN *)&pfnInitServer) == NO_ERROR)
      rc = pfnInitServer(hwnd,hevKillThreadSem,ulMaxMessageBufferSize);
    else
      {
      ErrorNotify("Error getting InitServer process address");
      return(FALSE);
      }
    }
  else
    {
    sprintf(szMessage,"Communications module not loaded");
    ErrorNotify(szMessage);
    return(FALSE);
    }
  if (rc != NO_ERROR)
    {
    DisplayProcessError(rc);
    return(FALSE);
    }
  MenuItemEnable(hwndFrame,IDM_INIT,FALSE);
  sprintf(szMessage,"Communications is initialized");
  PrintString(szMessage,4);
  return(TRUE);
  }

BOOL SendMessage(MSG *pMsg)
  {
  APIRET rc;

  rc = pfnSendMessage(pMsg);
  if (rc == NO_ERROR)
    return(TRUE);

  DisplayProcessError(rc);
  return(FALSE);
  }

void DisplayProcessError(APIRET rcErrorCode)
  {
  ULONG ulLocalCode;
  BOOL bSocketError = FALSE;

  PrintString("Process error",13);
  if ((rcErrorCode & 0x80000000) != 0)
    bSocketError = TRUE;
  ulLocalCode = ((rcErrorCode & 0x7f000000) >> 24);
  rcErrorCode &= ~0xff000000;
  if (bSocketError)
    sprintf(szMessage,"Socket error occurred, rc = %u.%u",ulLocalCode,rcErrorCode);
  else
    sprintf(szMessage,"System error occurred, rc = %u.%u",ulLocalCode,rcErrorCode);
  ErrorNotify(szMessage);
  }

void DisplayMessageError(ULONG ulErrorType,ULONG ulErrorCode)
  {
  ULONG ulLocalCode;
  int iLen;

  ulLocalCode = ((ulErrorCode & 0xff000000) >> 24);
  ulErrorCode &= ~0xff000000;
  switch (SHORT1FROMMP(ulErrorType))
    {
    case API_ERROR:
      iLen = sprintf(szMessage,"System");
      break;
    case SOCKET_ERROR:
      iLen = sprintf(szMessage,"Socket");
      break;
    case MSG_ERROR:
      iLen = sprintf(szMessage,"Message");
      break;
    default:
      iLen = sprintf(szMessage,"Unknown");
      break;
    }
  sprintf(&szMessage[iLen]," error occurred, rc = %u.%u",ulLocalCode,ulErrorCode);
  ErrorNotify(szMessage);
  }

void PrintString(char szMessage[],ULONG ulLine)
  {
  HPS    hps;
  RECTL  rcl;
  POINTL ptl;

  ptl.y = (ulWindowHeight - (ulLine * (stCell.cy + 5)));
  ptl.x = stCell.cx;
  rcl.yBottom = (ptl.y - 5);
  rcl.yTop = (ptl.y + stCell.cy);
  rcl.xLeft = 0;
  rcl.xRight = ulWindowWidth;
  hps = WinGetPS(hwndClient);
  WinFillRect(hps,&rcl,CLR_WHITE);
  GpiSetColor(hps,CLR_BLACK);
  GpiCharStringAt(hps,&ptl,strlen(szMessage),szMessage);
  WinReleasePS(hps);
  }

void ErrorNotify(char szMessage[])
  {
  HPS    hps;
  RECTL  rcl;
  POINTL ptl;

  ptl.y = 2;
  ptl.x = stCell.cx;
  rcl.yBottom = 0;
  rcl.yTop = stCell.cy;
  rcl.xLeft = 0;
  rcl.xRight = ulWindowWidth;
  hps = WinGetPS(hwndClient);
  WinFillRect(hps,&rcl,CLR_WHITE);
  GpiSetColor(hps,CLR_RED);
  GpiCharStringAt(hps,&ptl,strlen(szMessage),szMessage);
  WinReleasePS(hps);
  }

void ClearScreen(void)
  {
  HPS     hps;
  RECTL   rcl;

  WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
  hps = WinBeginPaint(hwndClient,(HPS)0,(PRECTL)&rcl);
  GpiSetColor(hps,CLR_WHITE);
  GpiSetBackColor(hps,CLR_WHITE);
  GpiSetBackMix(hps,BM_OVERPAINT);
  GpiSetMix(hps,BM_OVERPAINT);
  WinFillRect(hps,&rcl,CLR_WHITE);
  WinEndPaint(hps);
  }

void Paint(void)
  {
  HPS     hps;
  RECTL   rcl;

  hps = WinBeginPaint(hwndClient,(HPS)0,(PRECTL)&rcl);
  GpiSetColor(hps,CLR_WHITE);
  GpiSetBackColor(hps,CLR_WHITE);
  GpiSetBackMix(hps,BM_OVERPAINT);
  GpiSetMix(hps,BM_OVERPAINT);
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
  RECTL rcl;

  usWndDepth = HIUSHORT(mp2)/ stCell.cy;
  usWndWidth = LOUSHORT(mp2)/ stCell.cx;

  /************************************************************************/
  /* The test below caters for the first instance of WM_SIZE that invokes */
  /* this function BEFORE window creation is complete and the Frame handle*/
  /* has been set.                                                        */
  /************************************************************************/

  hwndFrame = (hwndFrame != (HWND)0) ? hwndFrame : WinQueryWindow(hwnd,QW_PARENT);
  WinQueryWindowRect(hwndClient,&rcl);
  ulWindowWidth = rcl.xRight;
  ulWindowHeight = rcl.yTop;
  WinInvalidateRect(hwnd,(PRECTL)0,FALSE);
  return(TRUE);
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


