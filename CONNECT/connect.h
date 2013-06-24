#ifndef _INCL_CONNECT_H_

#define MAX_NAME_LEN          20
#define MAX_GROUP_NAME_LEN    40
#define MAX_USER_MSGLEN       1024
#define MAX_SUBSCRIBERS       1024

#define MAX_SUBSCRIBER_LIST (MAX_MSG_BUF_SIZE / sizeof(SUBSCRIBER))

#define MAX_GROUPS          100

#define MAX_GROUP_LIST (MAX_MSG_BUF_SIZE / sizeof(GROUP))

#define MAX_GROUP_MEMBERS   100

#define REQ_ERROR_BAD_USERID          1
#define REQ_ERROR_BAD_PASSWORD        2
#define REQ_ERROR_BAD_DATASIZE        3
#define REQ_ERROR_INVALID_SUB         4
#define REQ_ERROR_INVALID_GROUP       5
#define REQ_ERROR_INACTIVE_SUB        6
#define REQ_ERROR_INACTIVE_GROUP      7

#define REQ_ERROR_ALREADY_LOGGED_ON   8

typedef struct
  {
  char szFirstName[MAX_NAME_LEN];
  char szLastName[MAX_NAME_LEN];
  USHORT usMaxMsgLen;
  ULONG ulSubNumber;
  USHORT fFlags;
  }SUBSCRIBER;

/*
** subscriber flags
*/
#define SUB_FLG_ACTIVATED     0x0001
#define SUB_FLG_ALPHAPAGE     0x0002
#define SUB_FLG_NUMERICPAGE   0x0004
#define SUB_FLG_SECONDARY_NUM 0x0008
#define SUB_FLG_RDU           0x0010
#define SUB_FLG_VOICE         0x0020
#define SUB_FLG_GROUP         0x8000

typedef struct
  {
  char szGroupName[MAX_GROUP_NAME_LEN];
  ULONG ulGroupNumber;
//  ULONG aulSubNumbers[MAX_GROUP_MEMBERS];
//  USHORT usMemberCount;
  USHORT usMaxMsgLen;
  USHORT usLargestMsgLen;
  USHORT fFlags;
  }GROUP;

typedef struct
  {
  USHORT usSubCount;
  USHORT usGroupCount;
  USHORT fFlags;
  USHORT usMsgLen;
  BYTE byMsgCount;
  BYTE byData;
  }NOTIFYLST;

typedef struct
   {          
   USHORT usSubCount;
   USHORT usGroupCount;
   USHORT fFlags;
   BYTE byData;
   }NOTIFYNAK;

typedef struct
   {
   USHORT usSubCount;
   ULONG ulSubNumber;
   }SUBREQLST;

typedef struct
   {
   USHORT usSubCount;
   USHORT usMaxMsg;
   USHORT usLargestMsg;
   USHORT fFlags;
   SUBSCRIBER stSubscriber;
   }SUBRSPLST;

typedef struct
   {
   USHORT usGroupCount;
   ULONG ulGroupNumber;
   }GROUPREQLST;

typedef struct
   {
   USHORT usGroupCount;
   USHORT usMaxMsg;
   USHORT usLargestMsg;
   USHORT fFlags;
   GROUP stGroup;
   }GROUPRSPLST;

typedef struct
   {
   USHORT usSubCount;
   USHORT usGroupCount;
   BYTE byData;
   }SERVERLST;

#define _INCL_CONNECT_H_

#endif
