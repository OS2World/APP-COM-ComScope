#ifndef INCLUDE_SPOOL

#if DEBUG > 0
#define SPOOLER_LIBRARY "SPL_DEB.PDR"
#else
#define SPOOLER_LIBRARY "COMI_SPL.PDR"
#endif

typedef struct
  {
  DCB stComDCB;
  ULONG ulBaudRate;
  LINECHAR stLine;
  char chTerm;
  BYTE byTerm;
  }PORTINIT;

#define INCLUDE_SPOOL

#endif
