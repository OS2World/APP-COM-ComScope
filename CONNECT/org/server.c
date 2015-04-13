#include <COMMON.H>
#include <types.h>
#include <netinet\in.h>
#include <sys\socket.h>
#include "aerial.h"
#include "comm.h"

#include <OS$tools.h>

#ifndef one_executable
USHORT usServerPort = AERIAL_SERVER_PORT;
USHORT usClientPort = AERIAL_CLIENT_PORT;
BOOL bDebug;
ULONG ulMaxMessageBufferSize;
int iLastCOMerror;
#else
extern BOOL bDebug;
extern ULONG ulMaxMessageBufferSize;
extern USHORT usServerPort;
extern USHORT usClientPort;
#endif
void RequestThread(void);

static int iRequestSocket;
static TID tidRequest;
static BOOL bStopRequestThread;
static HEV hevSocketThreadSem;
static ULONG ulIteration;
static HWND hwndCommand;

#ifndef one_executable
void EXPENTRY EnableDebug(BOOL bEnableDebug)
  {
  bDebug = bEnableDebug;
  }
#endif
APIRET EXPENTRY InitServer(HWND hwndCmd,HEV hevSem,ULONG cbMaxBuf)
  {
  SOCKADDRIN stServer;
  int bOptOn;

  hwndCommand = hwndCmd;
  ulMaxMessageBufferSize = cbMaxBuf;
  hevSocketThreadSem = hevSem;

  if ((iRequestSocket = socket(AF_INET,SOCK_STREAM,0)) < 0)
    {
    iLastCOMerror = sock_errno();
    return(ERROR_SOCKET_ERROR | iLastCOMerror | 0x1000000);
    }
  bOptOn = 1;
  if (setsockopt(iRequestSocket,SOL_SOCKET,SO_REUSEADDR,(char *)&bOptOn,sizeof(int)) < 0)
    {
    iLastCOMerror = sock_errno();
    return(ERROR_SOCKET_ERROR | iLastCOMerror | 0x2000000);
    }

  memset(&stServer,0,sizeof(SOCKADDRIN));
  stServer.sin_family = AF_INET;
  stServer.sin_port = htons(usServerPort);
  stServer.sin_addr.s_addr = INADDR_ANY;

  if (bind(iRequestSocket,(SOCKADDR *)&stServer,sizeof(stServer)) == -1)
    {
    iLastCOMerror = sock_errno();
    return(ERROR_SOCKET_ERROR | iLastCOMerror | 0x3000000);
    }

  if (listen(iRequestSocket,10) != 0)
    {
    iLastCOMerror = sock_errno();
    return(ERROR_SOCKET_ERROR | iLastCOMerror | 0x4000000);
    }

  DosCreateThread(&tidRequest,(PFNTHREAD)RequestThread,iRequestSocket,2,8192);

  return(NO_ERROR);
  }

void RequestThread(void)
  {
  SOCKADDR stClient;
  int iClientLen;
  int iAcceptSocket;
  MSG *pRequest;
  ULONG ulPostCount;
  int iBuffSize;
  int iResponseSize;
  APIRET rc;

  DosSetPriority(PRTYS_THREAD,PRTYC_TIMECRITICAL,4L,0);
  DosResetEventSem(hevSocketThreadSem,&ulPostCount);
  bStopRequestThread = FALSE;
  iClientLen = sizeof(SOCKADDR);
  iBuffSize = (ulMaxMessageBufferSize + sizeof(MSG));

  while (!bStopRequestThread)
    {
    if (bDebug)
      ulIteration++;
    memset(&stClient,0,iClientLen);
    if ((iAcceptSocket = accept(iRequestSocket,(SOCKADDR *)&stClient,&iClientLen)) != -1)
      {
      if (bDebug)
        WinPostMsg(hwndCommand,UM_COM_THREAD,(MPARAM)CON_ACCEPTED,(MPARAM)ulIteration);
      if ((rc = DosAllocMem((PPVOID)&pRequest,iBuffSize,(PAG_COMMIT | PAG_READ | PAG_WRITE))) == NO_ERROR)
        {
        if (bDebug)
          WinPostMsg(hwndCommand,UM_COM_THREAD,(MPARAM)BUFF_ALLOCATED,(MPARAM)ulIteration);
        if ((iResponseSize = recv(iAcceptSocket,(PVOID)pRequest,iBuffSize,0)) != -1)
          {
          if (bDebug)
            WinPostMsg(hwndCommand,UM_COM_THREAD,(MPARAM)BUFF_RECEIVED,(MPARAM)ulIteration);
          soclose(iAcceptSocket);
          if (iResponseSize == 0)
            WinPostMsg(hwndCommand,UM_REQUEST,(MPARAM)MSG_ERROR,(MPARAM)(MSG_ERROR_CONNECTION_CLOSED | 0x5000000));
          else
            {
            memcpy(&pRequest->byReserved,&stClient,iClientLen);  // store return address
            ulPostCount = 0;
            while (!WinPostMsg(hwndCommand,UM_REQUEST,(MPARAM)MESSAGE,(MPARAM)pRequest))
              {
              DosSleep(200);
              if (++ulPostCount > MAX_POST_RETRIES)
                {
                DosFreeMem(pRequest);
                bStopRequestThread = TRUE;
                }
              }
            }
          }
        else
          {
          iLastCOMerror = sock_errno();
          DosFreeMem(pRequest);
          while (!WinPostMsg(hwndCommand,UM_REQUEST,(MPARAM)SOCKET_ERROR,(MPARAM)(iLastCOMerror | 0x7000000)));
          bStopRequestThread = TRUE;
          }
        }
      else
        {
        soclose(iAcceptSocket);
        WinPostMsg(hwndCommand,UM_REQUEST,(MPARAM)API_ERROR,(MPARAM)(rc | 0x8000000));
        bStopRequestThread = TRUE;
        }
      }
    else
      {
      iLastCOMerror = sock_errno();
      WinPostMsg(hwndCommand,UM_REQUEST,(MPARAM)SOCKET_ERROR,(MPARAM)(iLastCOMerror | 0x9000000));
      bStopRequestThread = TRUE;
      }
    }
  soclose(iRequestSocket);
  WinPostMsg(hwndCommand,UM_COM_THREAD,(MPARAM)COM_THREAD_END,(MPARAM)0);
  DosPostEventSem(hevSocketThreadSem);
  }

BOOL EXPENTRY StopServer(void)
  {
  if (bStopRequestThread)
    return(FALSE);
  DosKillThread(tidRequest);
  soclose(iRequestSocket);
  DosPostEventSem(hevSocketThreadSem);
  return(TRUE);
  }

APIRET EXPENTRY SendResponse(MSG *pRsp)
  {
  int iSocket;
  SOCKADDRIN stServer;

  if ((iSocket = socket(AF_INET,SOCK_STREAM,0)) < 0)
    {
    iLastCOMerror = sock_errno();
    return(ERROR_SOCKET_ERROR | iLastCOMerror | 0xa000000);
    }

  memcpy(&stServer,&pRsp->byReserved,sizeof(SOCKADDRIN));  // get return address

  memset(&stServer.sin_zero,0,sizeof(stServer.sin_zero));  // clear "zero" bytes
  stServer.sin_family = AF_INET;
  stServer.sin_port = htons(usClientPort);

  if (connect(iSocket,(SOCKADDR *)&stServer, sizeof(SOCKADDR)) < 0)
    {
    iLastCOMerror = sock_errno();
    soclose(iSocket);
    return(ERROR_SOCKET_ERROR | iLastCOMerror | 0xb000000);
    }

  if (send(iSocket,(PVOID)pRsp,pRsp->cbSize,0) < 0)
    {
    iLastCOMerror = sock_errno();
    soclose(iSocket);
    return(ERROR_SOCKET_ERROR | iLastCOMerror | 0xc000000);
    }
  soclose(iSocket);
  return(NO_ERROR);
  }



