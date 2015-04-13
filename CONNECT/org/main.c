#include <COMMON.H>
#include <types.h>
#include <netinet\in.h>
#include <sys\socket.h>
#include "aerial.h"
//#include "comm.h"

#include <OS$tools.h>

USHORT usServerPort = AERIAL_SERVER_PORT;
USHORT usClientPort = AERIAL_CLIENT_PORT;
BOOL bDebug;
ULONG ulMaxMessageBufferSize;
int h_errno;

static HMODULE hThisModule;

#ifdef __BORLANDC__
ULONG _dllmain(ULONG ulTermCode,HMODULE hModule)
#else
ULONG _System _DLL_InitTerm(HMODULE hMod,ULONG ulTermCode)
#endif
  {
  if (ulTermCode == 0)
    {
    hThisModule = hMod;
    if (sock_init() != 0)
      return(FALSE);
    }
  return(TRUE);
  }

void EXPENTRY EnableDebug(BOOL bEnableDebug)
  {
  bDebug = bEnableDebug;
  }


