/*
**  CONTROL.C
**
**  Copyright 1995 OS/tools Incorporated
**
**  This is the only source file for OS/tools Control.EXE.
**
**  Command line:
**
**  All command line switches start with a "/" or "-" (forward slash or minus sign/dash).  Switch
**  characters are not case sensitive.
**
**  The "T" switch preceeds a user specified Named Pipe name.  If no "T" switch is
**  given "COMscope" will be used as the pipe name.  COMscope sessions normally logon to
**  the Pipe server named "COMscope".  If the user specifies a different pipe name
**  on the COMscope command line, this parameter will be used to start CONTROL.EXE with
**  that pipe name.
**
**  The "K" switch causes all COMscope sessions connected to this server (same pipe name) to be
**  "killed".  This "kill" action causes each COMscope session to be exited exactly as if
**  the user had closed that COMscope session; normal shutdown processing is completed before
**  COMscope is exited.
**
**  The "D" switch enables debug messages.  A single digit number immediately following the "D"
**  is the debug level.
**
**       1 - causes "watchdog" messages to be displayed
**       2 - causes various other diagnostic messages to be displayed
**
**  Processing:
**
**  If 10 seconds pass without an incomming message, the pipe will be closed and the program
**  will exit.
**
**  The "K" switch will only send the "abort" message and exit.
*/

#define INCL_VIO
#define INCL_DOS
#define INCL_DOSERRORS
#define INCL_DOSNMPIPES

#include <os2.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

#define UM_ABORT       0xffffffff
#define UM_ABORT_CONTROL 0xfffffffe
#define UM_PIPE_WD     0x801c
#define UM_PIPE_ACK    0x801d
#define UM_PIPE_QUIT   0x801e
#define UM_PIPE_INIT   0x801f
#define UM_PIPE_END    0x8020
#define UM_PIPE_NAK    0x8021
#define UM_RESET_NAME  0x8022
#define UM_SURFACE_ALL 0x8023
#define UM_SURFACE     0x8024
#define UM_HIDE_ALL    0x8025

char szDefaultName[] = "COMscope";
char szCOMscopePipe[80];

#define NPopenMode  (NP_NOWRITEBEHIND | NP_ACCESS_DUPLEX)
#define NPpipeMode  (NP_NOWAIT | NP_TYPE_MESSAGE | NP_READMODE_MESSAGE | 0x01) // one instance
#define NPtimeout   2000

HPIPE hCOMscopePipe;

typedef unsigned short WORD;

typedef struct
  {
  WORD cbMsgSize;
  ULONG ulCommand;
  ULONG ulInstance;
  }PIPEMSG;

typedef struct
  {
  WORD wCurrentCount;
  WORD wTotalCount;
  }PIPECOUNT;

BOOL bKillCOMscope = FALSE;
BOOL bKillControl = FALSE;
int iDebugLevel = 0;
PIPEMSG stPipe;
ULONG ulBytesRead;
ULONG ulBytesWritten;
BOOL bAbort;
ULONG ulClientCount = 0;
ULONG ulAbortCount = 0;
ULONG ulPipeState;
APIRET rc;
HEV hevCOMscopeSem = 0;
ULONG ulPostCount;
PIPECOUNT stBytesAvailable;
char szPipeName[40];
char szPipeServer[40];
BOOL bSurface = FALSE;
int iSurfaceCount;
BOOL bWatchDogTimeout = TRUE;
BOOL bAbortMsgExit = TRUE;
int iWatchDogTimeout = 10000;
USHORT usExplicitCommand;
BOOL bExplicitCommand = FALSE;
BOOL bHide = FALSE;

void ShowHelp(void)
  {
  printf("\nUsage: CONTROL [{-,/}Option]\n\n");
  printf("Option:\n  T - Pipe name - EX: /TCOMscope\n  V - Remote server name - EX: /VSERVER1\n  D - Enable debugging - EX: /D1\n");
  printf("  K - Kill all connected COMscope sessions\n  C - Kill CONTROL session\n  S - Surface all connected COMscope sessions\n");
  printf("  W - Set watchdog time-out (milliseconds)\n    EX: /W10000 - zero disables watchdog timeout\n  A - Disable abort message exit\n");
  printf("  M - Minimize all connected COMscope sessions\n  H - Display this help message\n");
  }

void main(int argc,char *argv[])
  {
  BOOL bDone = FALSE;
  int iIndex;
  int iLen = 0;

  if (argc >= 2)
    {
    for (iIndex = 1;iIndex < argc;iIndex++)
      {
      if ((argv[iIndex][0] == '/') || (argv[iIndex][0] == '-'))
        {
        if (argv[iIndex][1] == '?')
          argv[iIndex][1] = 'H';
        switch (argv[iIndex][1] & 0xdf)
          {
          case 'V':
            strcpy(szPipeServer,&argv[iIndex][2]);
            break;
          case 'T':
            strcpy(szPipeName,&argv[iIndex][2]);
            break;
          case 'D':
            iDebugLevel = atoi(&argv[iIndex][2]);
            break;
          case 'H':
            ShowHelp();
            DosExit(1,0);
            break;
          case 'S':
            bSurface = TRUE;
            break;
          case 'M':
            bHide = TRUE;
            break;
          case 'W':
            if ((iWatchDogTimeout = atoi(&argv[iIndex][2])) == 0)
              {
              iWatchDogTimeout = 10000;
              bWatchDogTimeout = FALSE;
              }
            break;
          case 'A':
            bAbortMsgExit = FALSE;
            break;
          case 'K':
            bKillCOMscope = TRUE;
            break;
          case 'C':
            bKillControl = TRUE;
            break;
          case 'X':
            usExplicitCommand = atoi(&argv[iIndex][2]);
            bExplicitCommand = TRUE;
            break;
          }
        }
      }
    }
  if (strlen(szPipeServer) != 0)
    iLen = sprintf(szCOMscopePipe,"\\\\%s",szPipeServer);
  if (strlen(szPipeName) == 0)
    sprintf(&szCOMscopePipe[iLen],"\\PIPE\\%s",szDefaultName);
  else
    sprintf(&szCOMscopePipe[iLen],"\\PIPE\\%s",szPipeName);

  DosSetPriority(PRTYS_PROCESS,PRTYC_TIMECRITICAL,-10L,0);
  stPipe.cbMsgSize = sizeof(PIPEMSG);
  if (bKillCOMscope)
    {
    stPipe.ulCommand = UM_ABORT;
    if (iDebugLevel >= 1)
      printf("Sending ABORT message to \"%s\".\n",szCOMscopePipe);
    while ((rc = DosCallNPipe(szCOMscopePipe,&stPipe,sizeof(PIPEMSG),&stPipe,sizeof(PIPEMSG),&ulBytesRead,10000)) == ERROR_PIPE_BUSY)
      printf("Pipe busy, waiting to kill COMscope\n");
    if (iDebugLevel >= 1)
      printf("ABORT message Sent to \"%s\" - rc = %u.\n",szCOMscopePipe,rc);
    else
      printf("ABORT message Sent to \"%s\".\n",szCOMscopePipe);
    }
  if (bExplicitCommand)
    {
    stPipe.ulCommand = (ULONG)usExplicitCommand;
    if (iDebugLevel >= 1)
      printf("Sending Explicit Command %u to \"%s\".\n",usExplicitCommand,szCOMscopePipe);
    while ((rc = DosCallNPipe(szCOMscopePipe,&stPipe,sizeof(PIPEMSG),&stPipe,sizeof(PIPEMSG),&ulBytesRead,10000)) == ERROR_PIPE_BUSY)
      printf("Pipe busy, waiting to kill COMscope\n");
    if (iDebugLevel >= 1)
      printf("Explicit Command Sent to \"%s\" - rc = %u.\n",szCOMscopePipe,rc);
    else
      printf("Explicit Command Sent to \"%s\".\n",szCOMscopePipe);
    }
  if (bKillControl)
    {
    stPipe.ulCommand = UM_ABORT_CONTROL;
    if (iDebugLevel >= 1)
      printf("Sending ABORT_CONTROL message to \"%s\".\n",szCOMscopePipe);
    while ((rc = DosCallNPipe(szCOMscopePipe,&stPipe,sizeof(PIPEMSG),&stPipe,sizeof(PIPEMSG),&ulBytesRead,10000)) == ERROR_PIPE_BUSY)
      printf("Pipe busy, waiting to kill process\n");
    if (iDebugLevel >= 1)
      printf("ABORT_CONTROL message Sent to \"%s\" - rc = %u.\n",szCOMscopePipe,rc);
    else
      printf("ABORT_CONTROL message Sent to \"%s\".\n",szCOMscopePipe);
    }
  if (bSurface)
    {
    stPipe.ulCommand = UM_SURFACE_ALL;
    if (iDebugLevel >= 1)
      printf("Sending SURFACE_ALL message to \"%s\".\n",szCOMscopePipe);
    while ((rc = DosCallNPipe(szCOMscopePipe,&stPipe,sizeof(PIPEMSG),&stPipe,sizeof(PIPEMSG),&ulBytesRead,10000)) == ERROR_PIPE_BUSY);
      printf("Pipe busy, waiting to surface sessions\n");
    if (iDebugLevel >= 1)
      printf("SURFACE_ALL message Sent to \"%s\" - rc = %u.\n",szCOMscopePipe,rc);
    else
      printf("SURFACE_ALL message Sent to \"%s\".\n",szCOMscopePipe);
    }
  if (bHide)
    {
    stPipe.ulCommand = UM_HIDE_ALL;
    if (iDebugLevel >= 1)
      printf("Sending HIDE_ALL message to \"%s\".\n",szCOMscopePipe);
    while ((rc = DosCallNPipe(szCOMscopePipe,&stPipe,sizeof(PIPEMSG),&stPipe,sizeof(PIPEMSG),&ulBytesRead,10000)) == ERROR_PIPE_BUSY);
      printf("Pipe busy, waiting to minimize sessions\n");
    if (iDebugLevel >= 1)
      printf("HIDE_ALL message Sent to \"%s\" - rc = %u.\n",szCOMscopePipe,rc);
    else
      printf("HIDE_ALL message Sent to \"%s\".\n",szCOMscopePipe);
    }
  if (bHide || bSurface || bKillControl || bKillCOMscope || bExplicitCommand)
    DosExit(1,0);
  if (DosCreateNPipe(szCOMscopePipe,&hCOMscopePipe,NPopenMode,NPpipeMode,sizeof(PIPEMSG),sizeof(PIPEMSG),NPtimeout) == NO_ERROR)
    {
    printf("\nServer Pipe \"%s\" created\n",szCOMscopePipe);
    DosCreateEventSem(0L,&hevCOMscopeSem,TRUE,FALSE);
    if (iDebugLevel >= 2)
      printf("Server Semaphore created\n",szCOMscopePipe);
    DosSetNPipeSem(hCOMscopePipe,(HSEM)hevCOMscopeSem,0L);
    if (iDebugLevel >= 2)
      printf("Server Semaphore assigned\n",szCOMscopePipe);
    while (!bDone)
      {
      rc = DosConnectNPipe(hCOMscopePipe);
      DosResetEventSem(hevCOMscopeSem,&ulPostCount);
      if (iDebugLevel >= 2)
        printf("Setup Post Count = %u\n",ulPostCount);
      rc = DosPeekNPipe(hCOMscopePipe,&stPipe,sizeof(PIPEMSG),&ulBytesRead,(PAVAILDATA)&stBytesAvailable,&ulPipeState);
      if (iDebugLevel >= 2)
        printf("First Peek - rc = %u, Pipe State = %X, Byte Counts = %04X:%04X\n",rc,ulPipeState,
                                                                                stBytesAvailable.wTotalCount,
                                                                                stBytesAvailable.wCurrentCount);
      if (ulPipeState != NP_STATE_CONNECTED)
        {
        if (DosWaitEventSem(hevCOMscopeSem,iWatchDogTimeout) == ERROR_TIMEOUT)
          {
          if (bWatchDogTimeout)
            {
            bDone = TRUE;
            printf("Timed out waiting for connection\n");
            }
          else
            if (iDebugLevel >= 1)
              printf("No watchdog message received for 10 seconds\n");
          }
        else
          {
          rc = DosPeekNPipe(hCOMscopePipe,&stPipe,sizeof(PIPEMSG),&ulBytesRead,(PAVAILDATA)&stBytesAvailable,&ulPipeState);
          if (iDebugLevel >= 2)
            printf("Test Peek - rc = %u, Pipe State = %X, Byte Counts = %04X:%04X\n",rc,ulPipeState,
                                                                                   stBytesAvailable.wTotalCount,
                                                                                   stBytesAvailable.wCurrentCount);
          }
        }
      if (!bDone)
        {
        if (rc == NO_ERROR)
          {
          DosResetEventSem(hevCOMscopeSem,&ulPostCount);
          if (iDebugLevel >= 2)
            printf("Event Post Count = %u\n",ulPostCount);
          if (stBytesAvailable.wCurrentCount == 0)
            {
            if (DosWaitEventSem(hevCOMscopeSem,iWatchDogTimeout) == ERROR_TIMEOUT)
              if (bWatchDogTimeout)
                bDone = TRUE;
            }
          else
            {
            for (iIndex = 0;iIndex < (stBytesAvailable.wCurrentCount / sizeof(PIPEMSG));iIndex++)
              {
              DosRead(hCOMscopePipe,&stPipe,sizeof(PIPEMSG),&ulBytesRead);
              if (ulBytesRead == sizeof(PIPEMSG))
                {
                switch (stPipe.ulCommand)
                  {
                  case UM_PIPE_END:
                    ulClientCount--;
                    printf("Session End message received - %u\n",stPipe.ulInstance);
                    stPipe.ulCommand = UM_PIPE_ACK;
                    DosWrite(hCOMscopePipe,&stPipe,sizeof(PIPEMSG),&ulBytesWritten);
                    break;
                  case UM_PIPE_INIT:
                    ulClientCount++;
                    printf("Initialization message received - %u\n",ulClientCount);
                    stPipe.ulInstance = ulClientCount;
                    stPipe.ulCommand = UM_PIPE_ACK;
                    DosWrite(hCOMscopePipe,&stPipe,sizeof(PIPEMSG),&ulBytesWritten);
                    break;
                  case UM_PIPE_WD:
                    if (iDebugLevel >= 1)
                      printf("Watchdog message received - %u\n",stPipe.ulInstance);
                    if (!bAbort)
                      {
                      if (!bSurface)
                        {
                        if (stPipe.ulInstance == 0)
                          {
                          ulClientCount++;
                          printf("Watchdog received, uknown instance - New instance = %u\n",ulClientCount);
                          stPipe.ulInstance = ulClientCount;
                          stPipe.ulCommand = UM_PIPE_ACK;
                          DosWrite(hCOMscopePipe,&stPipe,sizeof(PIPEMSG),&ulBytesWritten);
                          }
                        stPipe.ulCommand = UM_PIPE_ACK;
                        }
                      else
                        {
                        stPipe.ulCommand = UM_SURFACE;
                        printf("Surface message sent - %u\n",iSurfaceCount);
                        if (--iSurfaceCount <= 0)
                          bSurface = FALSE;
                        }
                      }
                    else
                      {
                      ulAbortCount++;
                      stPipe.ulCommand = UM_PIPE_QUIT;
                      printf("Abort message sent - %u\n",ulClientCount);
                      if (--ulClientCount == 0)
                        if (bAbortMsgExit)
                          bDone = TRUE;
                        else
                          {
                          printf("Process complete - %u COMscope sessions aborted\n",ulAbortCount);
                          bAbort = FALSE;
                          }
                      }
                    DosWrite(hCOMscopePipe,&stPipe,sizeof(PIPEMSG),&ulBytesWritten);
                    if (bDone)
                      DosSleep(1000);
                    break;
                  case UM_SURFACE_ALL:
                    if (ulClientCount > 0)
                      {
                      bSurface = TRUE;
                      iSurfaceCount = (int)ulClientCount;
                      printf("Surface command received\n");
                      }
                    else
                      printf("Surface command received - NO CLIENTS\n");
                    break;
                  case UM_ABORT:
                    if (ulClientCount > 0)
                      bAbort = TRUE;
                    printf("Abort COMscope command received\n");
                    break;
                  case UM_ABORT_CONTROL:
                    bDone = TRUE;
                    printf("Abort CONTROL command received\n");
                    break;
                  default:
                    if (iDebugLevel >= 1)
                      printf("Unknown Message received - %4X\n",stPipe.ulCommand);
                    stPipe.ulCommand = UM_PIPE_NAK;
                    DosWrite(hCOMscopePipe,&stPipe,sizeof(PIPEMSG),&ulBytesWritten);
                    break;
                  }
                if (!bDone)
                  DosSleep(10);
                }
              else
                if (iDebugLevel >= 2)
                  printf("ByteCount = %u\n",ulBytesRead);
              }
            }
          }
        DosDisConnectNPipe(hCOMscopePipe);
        }
      }
    if (ulAbortCount > 0)
      printf("Process complete - %u COMscope sessions aborted\n",ulAbortCount);
    DosDisConnectNPipe(hCOMscopePipe);
    DosClose(hCOMscopePipe);
    DosCloseEventSem(hevCOMscopeSem);
    }
  else
    printf("Server ended - Unable to create Named Pipe\n");
  DosExit(1,0);
  }


