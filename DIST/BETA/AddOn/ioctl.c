/*******************************************************************************
*
*       Copyright (C) 1988-95 OS/tools Incorporated -- All rights reserved
*
*******************************************************************************/

/*
**  Remove these definitions when OS/2 include files are available.
**
**  They are only here to prove that file will build.
*/
typedef unsigned short USHORT;
typedef int LONG;
typedef unsigned long ULONG;
typedef unsigned long APIRET;
typedef unsigned long HFILE;
typedef unsigned long HAB;
typedef unsigned long HMODULE;
typedef void VOID;
typedef void *PVOID;
typedef char *PSZ;
typedef unsigned long HWND;

APIRET WinMessageBox(HWND hwndParent,
                     HWND hwndOwner,
                     PSZ  szMessage,
                     PSZ  szTitle,
                     USHORT usWindow,
                     LONG flStyle);

APIRET WinLoadString(    HAB hab,
                     HMODULE hModule,
                      USHORT idErrMsg,
                        LONG lLength,
                        char szMsgStr[]);

APIRET DosDevIOCtl( HFILE hCom,
                   USHORT usCategory,
                   USHORT usFunction,
                    PVOID pParam,
                    ULONG ulParamLen,
                    ULONG *ulRetParmLen,
                    PVOID pData,
                    ULONG ulDataLen,
                    ULONG *ulRetDataLen);

#define NO_ERROR 0
#define FALSE 0
#define TRUE 1
#define HWND_DESKTOP 1
#define MB_MOVEABLE 1
#define MB_OK 0
#define MB_CUAWARNING 2

/* end of dummy definitions */

#include <stdio.h>

#include "ioctl.h"

extern char *pszPortName;
extern HAB hab;
extern HMODULE hModule = 0;

static VOID IOctlErrorMessageBox(ULONG idErrMsg,USHORT usFunction,APIRET Error);

APIRET GetDCB(HFILE hCom,DCB *pstComDCB)
  {
  ULONG ulDataLen = sizeof(DCB);
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x73,0L,0L,&ulParmLen,(PVOID)pstComDCB,sizeof(DCB),&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_DCBRD,0x73,rc);
  return(rc);
  }

APIRET SendDCB(HFILE hCom,DCB *pstComDCB)
  {
  ULONG ulDataLen = 0L;
  ULONG ulParmLen = sizeof(DCB);
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x53,(PVOID)pstComDCB,sizeof(DCB),&ulParmLen,0L,0L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_DCBWRT,0x53,rc);
  return(rc);
  }

APIRET SendByteImmediate(HFILE hCom,BYTE bySendByte)
  {
  ULONG ulDataLen = 0L;
  ULONG ulParmLen = 1L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x44,(PVOID)&bySendByte,1L,&ulParmLen,0L,0L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_TXIMM,0x44,rc);
  return(rc);
  }

APIRET GetXmitStatus(HFILE hCom,BYTE *pbyCOMstatus)
  {
  ULONG ulDataLen = 1l;
  ULONG ulParmLen = 0l;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x65,0L,0L,&ulParmLen,(PVOID)pbyCOMstatus,1L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_XMITSTAT,0x65,rc);
  return(rc);
  }

APIRET GetCOMstatus(HFILE hCom,BYTE *pbyCOMstatus)
  {
  ULONG ulDataLen = 1L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x64,0L,0L,&ulParmLen,pbyCOMstatus,1L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_COMSTAT,0x64,rc);
  return(rc);
  }

APIRET GetCOMevent(HFILE hCom,USHORT *pusCOMevent)
  {
  ULONG ulDataLen = 2L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x72,0L,0L,&ulParmLen,pusCOMevent,2L,&ulDataLen)) != 0)
  	IOctlErrorMessageBox(IC_ATM_COMEVENT,0x72,rc);
  return(rc);
  }

APIRET GetCOMerror(HFILE hCom,USHORT *pusCOMerror)
  {
  ULONG ulDataLen = 2L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x6d,0L,0L,&ulParmLen,pusCOMerror,2L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_COMERROR,0x6d,rc);
  return(rc);
  }

APIRET BreakOn(HFILE hCom,USHORT *pusCOMerror)
  {
  ULONG ulDataLen = 2L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x4b,0L,0L,&ulParmLen,pusCOMerror,2L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_BRKON,0x4b,rc);
  return(rc);
  }

APIRET BreakOff(HFILE hCom,USHORT *pusCOMerror)
  {
  ULONG ulDataLen = 2L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x45,0L,0L,&ulParmLen,pusCOMerror,2L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_BRKOFF,0x45,rc);
  return(rc);
  }

APIRET GetReceiveQueueLen(HFILE hCom,USHORT *pusQueueLen,USHORT *pusByteCount)
  {
  ULONG ulDataLen = 4L;
  ULONG ulParmLen = 0L;
  APIRET rc;
  struct
    {
    USHORT usByteCount;
    USHORT usQueueLen;
    }stWordPair;

  if ((rc = DosDevIOCtl(hCom,0x01,0x68,0L,0L,&ulParmLen,&stWordPair,4L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_RCVQLEN,0x68,rc);
  *pusQueueLen = stWordPair.usQueueLen;
  *pusByteCount = stWordPair.usByteCount;
  return(rc);
  }

APIRET GetReceiveQueueCounts(HFILE hCom,BUFCNT *pstCounts)
  {
  ULONG ulDataLen = 6L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x68,0L,0L,&ulParmLen,pstCounts,6L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_RCVQLEN,0x68,rc);
  return(rc);
  }

APIRET GetTransmitQueueLen(HFILE hCom,USHORT *pusQueueLen,USHORT *pusByteCount)
  {
  ULONG ulDataLen = 4L;
  ULONG ulParmLen = 0L;
  APIRET rc;
  struct
    {
    USHORT usByteCount;
    USHORT usQueueLen;
    }stWordPair;

  if ((rc = DosDevIOCtl(hCom,0x01,0x69,0L,0L,&ulParmLen,&stWordPair,4L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_TXQLEN,0x69,rc);
  *pusQueueLen = stWordPair.usQueueLen;
  *pusByteCount = stWordPair.usByteCount;
  return(rc);
  }

APIRET GetTransmitQueueCounts(HFILE hCom,BUFCNT *pstCounts)
  {
  ULONG ulDataLen = 6L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x69,0L,0L,&ulParmLen,pstCounts,6L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_TXQLEN,0x69,rc);
  return(rc);
  }

APIRET GetModemInputSignals(HFILE hCom,BYTE *pbySignals)
  {
  ULONG ulDataLen = 1L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x67,0L,0L,&ulParmLen,pbySignals,1L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_MDMSET,0x67,rc);
  return(rc);
  }

APIRET GetModemOutputSignals(HFILE hCom,BYTE *pbySignals)
  {
  ULONG ulDataLen = 1L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x66,0L,0L,&ulParmLen,pbySignals,1L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_MDMGET,0x66,rc);
  return(rc);
  }

APIRET SetModemSignals(HFILE hCom,BYTE byOnByte,BYTE byOffByte,USHORT *pusCOMerror)
  {
  ULONG ulDataLen = 2L;
  ULONG ulParmLen = 2L;
  APIRET rc;
  MDMSSIG stModemSetSignals;

  stModemSetSignals.ModemSigOn = byOnByte;
  stModemSetSignals.ModemSigOff = byOffByte;

  if ((rc = DosDevIOCtl(hCom,0x01,0x46,&stModemSetSignals,2L,&ulParmLen,pusCOMerror,2L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_MDMSET,0x46,rc);
  return(rc);
  }

APIRET SetLineCharacteristics(HFILE hCom,LINECHAR *pstLineChar)
  {
  ULONG ulDataLen = 0L;
  ULONG ulParmLen = sizeof(LINECHAR);
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x42,pstLineChar,sizeof(LINECHAR),&ulParmLen,0L,0L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_LINEWRT,0x42,rc);
  return(rc);
  }

APIRET GetLineCharacteristics(HFILE hCom,LINECHAR *pstLineChar)
  {
  ULONG ulDataLen = sizeof(LINECHAR);
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x62,0L,0L,&ulParmLen,pstLineChar,sizeof(LINECHAR),&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_LINERD,0x62,rc);
  return(rc);
  }

APIRET SetBaudRate(HFILE hCom,LONG lBaud)
  {
  ULONG ulDataLen = 0l;
  ULONG ulParmLen = sizeof(BAUDRT);
  APIRET rc;
  USHORT usFunction = 0x0041;
  BAUDRT stBaudRate;

  stBaudRate.lBaudRate = lBaud;
  stBaudRate.byFraction = 0;
  if (stBaudRate.lBaudRate > 0xffff)
  usFunction = 0x0043;
  if ((rc = DosDevIOCtl(hCom,0x01,usFunction,&stBaudRate,sizeof(BAUDRT),&ulParmLen,0L,0L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_BAUDWRT,usFunction,rc);
  return(rc);
  }

APIRET GetBaudRate(HFILE hCom,LONG *plBaud)
  {
  ULONG ulDataLen = sizeof(BAUDRT);
  ULONG ulParmLen = 0L;
  APIRET rc;
  BAUDST stBaudRate;

  *plBaud = 0;
  if ((rc = DosDevIOCtl(hCom,0x01,0x63,0L,0L,&ulParmLen,&stBaudRate,sizeof(BAUDRT),&ulDataLen)) != 0)
    rc = DosDevIOCtl(hCom,0x01,0x61,0L,0L,&ulParmLen,&stBaudRate,sizeof(BAUDRT),&ulDataLen);
  if (rc)
    IOctlErrorMessageBox(IC_ATM_BAUDRD,0x63,rc);
  *plBaud = stBaudRate.stCurrentBaud.lBaudRate;
  return(rc);
  }

APIRET GetBaudRates(HFILE hCom,BAUDST *pstBaudRates)
  {
  ULONG ulDataLen = sizeof(BAUDST);
  ULONG ulParmLen = 0L;
  USHORT usBaud = 0;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x63,0L,0L,&ulParmLen,pstBaudRates,sizeof(BAUDST),&ulDataLen)) != 0)
    {
    ulDataLen = sizeof(USHORT);
    if ((rc = DosDevIOCtl(hCom,0x01,0x61,0L,0L,&ulParmLen,&usBaud,sizeof(USHORT),&ulDataLen)) != NO_ERROR)
      IOctlErrorMessageBox(IC_ATM_BAUDRD,0x61,rc);
    }
  if (usBaud != 0)
    {
    pstBaudRates->stCurrentBaud.lBaudRate = (LONG)usBaud;
    pstBaudRates->stHighestBaud.lBaudRate = 57600;
    }
  return(rc);
  }

APIRET ForceXon(HFILE hCom)
  {
  ULONG ulDataLen = 0L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x48,0L,0L,&ulParmLen,0L,0L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_FXON,0x48,rc);
  return(rc);
  }

APIRET ForceXoff(HFILE hCom)
  {
  ULONG ulDataLen = 0L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x47,0L,0L,&ulParmLen,0L,0L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_FXOFF,0x47,rc);
  return(rc);
  }

APIRET FlushComBuffer(HFILE hCom,USHORT usDirection)
  {
	ULONG pcbDataLen = 0;
	ULONG pcbParmLen = 1;
  APIRET rc;
  BYTE byParam = 0;

	if ((rc = DosDevIOCtl(hCom,0x0b,(ULONG)usDirection,&byParam,1L,&pcbParmLen,0L,0L,&pcbDataLen)) != 0)
    IOctlErrorMessageBox(IC_ATM_FLUSH,0x0b,rc);
  return(rc);
  }

APIRET GetFIFOinfo(HFILE hCom,FIFOINF *pstFIFOinfo)
  {
  ULONG ulDataLen = sizeof(FIFOINF);
  ULONG ulParmLen = 0;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x74,0L,0L,&ulParmLen,pstFIFOinfo,ulDataLen,&ulDataLen)) != NO_ERROR)
    {
    IOctlErrorMessageBox(IC_ATM_GET_FIFO,0x74,rc);
    return(FALSE);
    }
  return(NO_ERROR);
  }

APIRET SetFIFO(HFILE hCom,FIFODEF *pstFIFOcontrol)
  {
  ULONG ulDataLen = 0;
  ULONG ulParmLen = sizeof(FIFODEF);
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x54,pstFIFOcontrol,ulParmLen,&ulParmLen,0L,0L,&ulDataLen)) != NO_ERROR)
    {
    IOctlErrorMessageBox(IC_ATM_SET_FIFO_LOAD,0x54,rc);
    return(FALSE);
    }
  return(NO_ERROR);
  }

APIRET EXPENTRY GetCountsSinceLast(HIOCTL hIOctl,HFILE hCom,DIAGCOUNTS *pstCounts)
  {
  ULONG ulDataLen = sizeof(DIAGCOUNTS);
  ULONG ulParmLen = 0;
  EXTPARM stParams;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x7A,0L,0L,&ulParmLen,pstCounts,ulDataLen,&ulDataLen)) != NO_ERROR)
    {
    IOctlErrorMessageBox(hIOctl,IC_ATM_GET_DIAG_COUNTS,0x7A,rc);
    return(FALSE);
    }
  return(NO_ERROR);
  }

VOID IOctlErrorMessageBox(ULONG idErrMsg,USHORT usFunction,APIRET rcError)
  {
  char szErrMsg[80];
  char szMsgString[200];
  LONG lLength;
  ULONG idErrCode;

  lLength = WinLoadString(hab,hModule,idErrMsg,sizeof(szMsgString),szMsgString);
  WinLoadString(hab,hModule,IC_ATM_FUNCTION,sizeof(szErrMsg),szErrMsg);
  lLength += sprintf(&szMsgString[lLength],"\n\n%s 0x%02X",szErrMsg,usFunction);
  lLength += sprintf(&szMsgString[lLength],"\n\n");
  switch (rcError)
    {
    case 0x57:
      WinLoadString(hab,hModule,IC_ATM_ERRMSG_INVALID_PARAM,sizeof(szErrMsg),&szMsgString[lLength]);
      break;
    case 0x1f:
      WinLoadString(hab,hModule,IC_ATM_ERRMSG_GEN_FAIL,sizeof(szErrMsg),&szMsgString[lLength]);
      break;
    case 0x17:
      WinLoadString(hab,hModule,IC_ATM_ERRMSG_BAD_COMMAND,sizeof(szErrMsg),&szMsgString[lLength]);
      break;
    default:
      WinLoadString(hab,hModule,IC_ATM_ERRMSG_UNKNOWN_ERROR,sizeof(szErrMsg),szErrMsg);
      sprintf(&szMsgString[lLength],"%s = %u",szErrMsg,rcError);
      break;
    }
  lLength = WinLoadString(hab,hModule,IC_ATM_IOCTL,sizeof(szErrMsg),szErrMsg);
  if (pszPortName != 0)
    sprintf(&szErrMsg[lLength]," - %s",pszPortName);
  WinMessageBox(HWND_DESKTOP,
                HWND_DESKTOP,
           (PSZ)szMsgString,
           (PSZ)szErrMsg,
                0,
                MB_MOVEABLE | MB_OK | MB_CUAWARNING);
  }


