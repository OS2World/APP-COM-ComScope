
#ifndef _INCL_REMOTE_H_

#define MAX_PIPE_MSG_LEN 4096

#define UM_REM_DEVICE_LIST 22000

typedef struct
  {
  SHORT cbMsgSize;
  ULONG ulCommand;
  ULONG ulInstance;
  }PIPECMD;

typedef struct
  {
  SHORT cbMsgSize;
  ULONG ulCommand;
  ULONG cbDataSize;
  union
    {
    BYTE abyData[MAX_PIPE_MSG_LEN];
    WORD awData[MAX_PIPE_MSG_LEN / sizeof(USHORT)];
    ULONG aulData[MAX_PIPE_MSG_LEN / sizeof(ULONG)];
    LONG alData[MAX_PIPE_MSG_LEN / sizeof(LONG)];
    ULONG ulData;
    LONG lData;
    WORD wData;
    BYTE byData;
    }Data;
  }PIPEMSG;

typedef struct
  {
  WORD cbMessageSize;
  ULONG ulMessage;
  ULONG ulInstance;
  }IPCPIPEMSG;

#ifdef this_junk
extern BOOL bRemoteClient;
extern BOOL bRemoteServer;
extern HEV hevCOMscopeSem;
extern TID tidRemoteServerThread;
extern HPIPE hCOMscopePipe;

extern PIPEMSG stPipeMsg;
extern PIPECMD stPipeCmd;
extern BOOL bStopRemotePipe;
extern char szCOMscopePipe[];
#endif

#define _INCL_REMOTE_H_

#endif
