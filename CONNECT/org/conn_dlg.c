#include <COMMON.H>
#include <utility.h>
#include "comm.h"
#include "conn_dlg.h"
#include "connect.h"

#include <OS$tools.h>

extern SUBSCRIBER astSubList[];
extern USHORT usSubscriberListCount;
extern GROUP astGroupList[];
extern USHORT usGroupListCount;

extern HEV hevNotifyLoopSem;

extern ULONG ulMessageNumber;
extern BOOL SendMessage(MSG *pMsg);
extern BOOL bNotifyLoop;
static MSG *pNotifyLoopMsg;

MRESULT EXPENTRY fnwpConfigCommDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static COMADDR *pstAddr;

  switch (msg)
    {
    case WM_INITDLG:
      pstAddr = (COMADDR *)mp2;
      WinSendDlgItemMsg(hwnd,CFG_ADDRESS,EM_SETTEXTLIMIT,MPFROMSHORT(40),(MPARAM)NULL);
      WinSetDlgItemText(hwnd,CFG_ADDRESS,pstAddr->szAddressee);
      if (pstAddr->fAddrType == BY_ADDR)
        CheckButton(hwnd,CFG_IS_ADDRESS,TRUE);
      else
        CheckButton(hwnd,CFG_IS_HOST_NAME,TRUE);
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          WinQueryDlgItemText(hwnd,CFG_ADDRESS,40,pstAddr->szAddressee);
          if (Checked(hwnd,CFG_IS_ADDRESS))
            pstAddr->fAddrType = BY_ADDR;
          else
            pstAddr->fAddrType = BY_HOST;
          WinDismissDlg(hwnd,TRUE);
          break;
        case DID_CANCEL:
          WinDismissDlg(hwnd,FALSE);
          break;
        default:
          return(WinDefDlgProc(hwnd,msg,mp1,mp2));
        }
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return(FALSE);
  }

MRESULT EXPENTRY fnwpLogonDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static LOGON *pstLogon;

  switch (msg)
    {
    case WM_INITDLG:
      pstLogon = (LOGON *)mp2;
      WinSendDlgItemMsg(hwnd,LOG_USERID,EM_SETTEXTLIMIT,MPFROMSHORT(40),(MPARAM)NULL);
      WinSetDlgItemText(hwnd,LOG_USERID,pstLogon->szUserName);
      WinSendDlgItemMsg(hwnd,LOG_PASSWORD,EM_SETTEXTLIMIT,MPFROMSHORT(40),(MPARAM)NULL);
      WinSetDlgItemText(hwnd,LOG_PASSWORD,pstLogon->szPassword);
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          WinQueryDlgItemText(hwnd,LOG_USERID,40,pstLogon->szUserName);
          WinQueryDlgItemText(hwnd,LOG_PASSWORD,40,pstLogon->szPassword);
          WinDismissDlg(hwnd,TRUE);
          break;
        case DID_CANCEL:
          WinDismissDlg(hwnd,FALSE);
          break;
        default:
          return(WinDefDlgProc(hwnd,msg,mp1,mp2));
        }
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return(FALSE);
  }

void NotifyLoopThread(MSG *pMsg)
  {
  ULONG ulPostCount;

  DosResetEventSem(hevNotifyLoopSem,&ulPostCount);
  pMsg = pNotifyLoopMsg;
  while (1)
    {
    pMsg->ulMessageNumber = ulMessageNumber++;
    SendMessage(pMsg);
    DosWaitEventSem(hevNotifyLoopSem,5000);
//    DosSleep(300);
    DosResetEventSem(hevNotifyLoopSem,&ulPostCount);
    }
  }

MRESULT EXPENTRY fnwpNotifyDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static MSG *pMessage;
  NOTIFYLST *pNotify;
  ULONG ulSubNumber;
  ULONG ulGroupNumber;
  int iMsgLen;
  USHORT usLength;
  USHORT usSubCount;
  ULONG *pulSubNum;
  char szMessage[80];
  int iIndex;
  static TID tid;
  BYTE *pData;

  switch (msg)
    {
    case WM_INITDLG:
      pMessage = (MSG *)mp2;
      bNotifyLoop = FALSE;
      WinSendDlgItemMsg(hwnd,NOTIFY_SUB_NUMBER,
                                SPBM_SETLIMITS,
                                (MPARAM)usSubscriberListCount,
                                (MPARAM)1);
      WinSendDlgItemMsg(hwnd,NOTIFY_MESSAGE,MLM_FORMAT,(MPARAM)MLFIE_WINFMT,(MPARAM)NULL);
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          if (bNotifyLoop)
            break;
          WinSendDlgItemMsg(hwnd,NOTIFY_SUB_NUMBER,SPBM_QUERYVALUE,&ulSubNumber,MPFROM2SHORT(0,SPBQ_DONOTUPDATE));
          iMsgLen = WinQueryDlgItemTextLength(hwnd,NOTIFY_MESSAGE);
//          iMsgLen = (int)WinSendDlgItemMsg(hwnd,NOTIFY_MESSAGE,MLM_QUERYTEXTLENGTH,(MPARAM)NULL,(MPARAM)NULL);
          if (iMsgLen <= 0)
            {
            sprintf(szMessage,"Message is too short, length = %u",iMsgLen);
            MessageBox(hwnd,szMessage);
            break;
            }
          if (astSubList[ulSubNumber].usMaxMsgLen < iMsgLen)
            {
            sprintf(szMessage,"Message is to long for defined subscriber, remove at least %u characters.",(iMsgLen - astSubList[ulSubNumber].usMaxMsgLen));
            MessageBox(hwnd,szMessage);
            break;
            }
          pNotify = (NOTIFYLST *)&pMessage->byData;
          pNotify->usSubCount = 1;
          pNotify->usGroupCount = 0;
          pNotify->usMsgLen = (USHORT)iMsgLen;
          pData = &pNotify->byData;
          iMsgLen = WinQueryDlgItemText(hwnd,NOTIFY_MESSAGE,(iMsgLen + 1),pData);
          pulSubNum = (ULONG *)(pData + iMsgLen);
          usSubCount = 0;
          for (iIndex = 0;iIndex < pNotify->usSubCount;iIndex++)
            {
            usSubCount++;
            *pulSubNum = (ULONG)ulSubNumber;
            pulSubNum++;
            }
          for (iIndex = 0;iIndex < pNotify->usGroupCount;iIndex++)
            {
            usSubCount++;
            *pulSubNum = (ULONG)ulGroupNumber;
            pulSubNum++;
            }
          usLength = ((sizeof(ULONG) * usSubCount) + (USHORT)iMsgLen);
          pMessage->cbDataSize = (usLength + sizeof(NOTIFYLST) - 1);
          if (Checked(hwnd,NOTIFY_CONTINUOUSLY))
            {
            pMessage->fMessageType = REQ_NOTIFY;
            pMessage->cbSize = (pMessage->cbDataSize + sizeof(MSG) - 1);
            bNotifyLoop = TRUE;
            pNotifyLoopMsg = pMessage;
            DosCreateThread(&tid,(PFNTHREAD)NotifyLoopThread,(ULONG)pMessage,0,8192);
            }
          else
            WinDismissDlg(hwnd,TRUE);
          break;
        case DID_CANCEL:
          if (bNotifyLoop)
            DosKillThread(tid);
          WinDismissDlg(hwnd,FALSE);
          break;
        default:
          return(WinDefDlgProc(hwnd,msg,mp1,mp2));
        }
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return(FALSE);
  }

char szSub[40] = "Emmett Culley";

MRESULT EXPENTRY fnwpSubscriberDlg(HWND hwnd,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static MSG *pMessage;
  int iSubNumber;
  int iMsgLen;
  USHORT usSubCount;
  char szMessage[80];
  SUBREQLST *pSubList;

  switch (msg)
    {
    case WM_INITDLG:
      pMessage = (MSG *)mp2;
      WinSendDlgItemMsg(hwnd,LB_SELECT_SUB,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(szSub));
      break;
    case WM_COMMAND:
      switch(SHORT1FROMMP(mp1))
        {
        case DID_OK:
          if ((iSubNumber = (int)WinSendDlgItemMsg(hwnd,LB_SELECT_SUB,LM_QUERYSELECTION,0L,0L)) == LIT_NONE)
            break;
          usSubCount = 1;
          pSubList = (SUBREQLST *)&pMessage->byData;
          pSubList->usSubCount = usSubCount;
          pSubList->ulSubNumber = (ULONG)iSubNumber;
          pMessage->cbDataSize = (sizeof(SUBREQLST) + (sizeof(ULONG) * usSubCount));
          WinDismissDlg(hwnd,TRUE);
          break;
        case DID_CANCEL:
          WinDismissDlg(hwnd,FALSE);
          break;
        default:
          return(WinDefDlgProc(hwnd,msg,mp1,mp2));
        }
      break;
    default:
      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
    }
  return(FALSE);
  }



