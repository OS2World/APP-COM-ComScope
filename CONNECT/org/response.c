#include <COMMON.H>
#include <UTILITY.H>
#include "conn_dlg.h"
#include "menu.h"
#include "comm.h"
#include "connect.h"

extern char szMessage[];
extern HEV hevNotifyLoopSem;
extern HWND hwndFrame;

extern MSG stTestAddressee;

extern SUBSCRIBER astSubList[];
extern USHORT usSubscriberListCount;

extern GROUP astGroupList[];
extern USHORT usGroupListCount;

extern LOGON stLogon;

void ErrorNotify(char szMessage[]);
void PrintString(char szMessage[],ULONG ulPos);
void DisplayProcessError(APIRET rcErrorCode);
void DisplayMessageError(ULONG ulErrorType,ULONG ulErrorCode);
BOOL SendMessage(MSG *pMsg);

void ProcessResponse(HWND hwnd,MSG *pMessage)
  {
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
  char *pData;
  ULONG ulPostCount;
  int iIndex;
  SUBSCRIBER *pSub;
  GROUP *pGroup;
  ULONG *pulNums;

  sprintf(szMessage,"Response received <%u>",pMessage->ulMessageNumber);
  PrintString(szMessage,9);
  switch (pMessage->fMessageType)
    {
    case RSP_TIMEOUT:
      break;
    case RSP_ACK_LOGON:
      PrintString("Logon acknowledged",10);
      MenuItemEnable(hwndFrame,IDM_CLIENT,TRUE);
      break;
    case RSP_NAK_LOGON:
      sprintf(szMessage,"Logon failed, reason = %u",pMessage->byData);
      PrintString(szMessage,10);
      break;
    case RSP_ACK_NOTIFY:
      PrintString("Notify successfull",10);
      DosPostEventSem(hevNotifyLoopSem);
      break;
    case RSP_NAK_NOTIFY:
      sprintf(szMessage,"Notify failed, reason = %u",pMessage->byData);
      PrintString(szMessage,10);
      break;
    case RSP_NAK_SUBSCRIBER:
      sprintf(szMessage,"Subscriber query failed, reason = %u",pMessage->byData);
      PrintString(szMessage,10);
      break;
    case RSP_ACK_SUBSCRIBER:
      if (pMessage->cbDataSize == 0)
        PrintString("No active subscribers defined at server",10);
      sprintf(szMessage,"Subscriber query succeeded");
      PrintString(szMessage,10);
      break;
    case RSP_NAK_GROUP:
      sprintf(szMessage,"Group query failed, reason = %u",pMessage->byData);
      PrintString(szMessage,10);
      break;
    case RSP_ACK_GROUP:
      sprintf(szMessage,"Group query succeeded");
      PrintString(szMessage,10);
      break;
    case RSP_SERVER:
      if (pMessage->cbDataSize == 0)
        PrintString("No active subscribers or groups defined at server",10);
      else
        {
        pServerList = (SERVERLST *)&pMessage->byData;
        sprintf(szMessage,"Server sends %u Subscribers and %u Groups",pServerList->usSubCount,pServerList->usGroupCount);
        /*
        **  query subscribers
        */
        if ((pulNums = (ULONG *)malloc(pMessage->cbDataSize)) == 0)
          {
          ErrorNotify("Failed to allocate memory for RSP_SERVER message");
          break;
          }
        pServerList = (SERVERLST *)&pMessage->byData;
        pulSubNum = (ULONG *)&pServerList->byData;
        usSubCount = pServerList->usSubCount;
        usGroupCount = pServerList->usGroupCount;
        memcpy(pulNums,pulSubNum,(sizeof(ULONG) * (usSubCount + usGroupCount)));
        if (usSubCount > 0)
          {
          pSubList = (SUBREQLST *)&pMessage->byData;
          pSubList->usSubCount = usSubCount;
          memcpy(&pSubList->ulSubNumber,pulNums,(sizeof(ULONG) * usSubCount));
          pMessage->fMessageType = REQ_QUERY_SUBSCRIBER;
          pMessage->cbDataSize = ((sizeof(ULONG) * (usSubCount - 1)) + sizeof(SUBREQLST));
          pMessage->cbSize = (pMessage->cbDataSize + sizeof(MSG) - 1);
          SendMessage(pMessage);
          }
        if (usGroupCount > 0)
          {
          pGroupList = (GROUPREQLST *)&pMessage->byData;
          pGroupList->usGroupCount = usGroupCount;
          memcpy(&pGroupList->ulGroupNumber,&pulNums[usSubCount],(sizeof(ULONG) * usGroupCount));
          pMessage->fMessageType = REQ_QUERY_GROUP;
          pMessage->cbDataSize = ((sizeof(ULONG) * (usGroupCount - 1)) + sizeof(GROUPREQLST));
          pMessage->cbSize = (pMessage->cbDataSize + sizeof(MSG) - 1);
          SendMessage(pMessage);
          }
        free(pulNums);
        }
      break;
    default:
      sprintf(szMessage,"Unknown response, type = %u",pMessage->fMessageType);
      PrintString(szMessage,10);
      break;
    }
  DosFreeMem(pMessage);
  }
