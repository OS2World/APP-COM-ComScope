/*******************************************************************************
*
*       Copyright (C) 1988-2001 OS/tools Incorporated -- All rights reserved
*
*******************************************************************************/
#include "COMMON.H"
#include "COMDD.H"
#include "ioctl.h"

static VOID IOctlErrorMessageBox(HIOCTL hIOctl,ULONG idErrMsg,WORD wFunction,APIRET Error);

static HMODULE hModule = 0;

#ifndef STATIC_LIB
#ifdef __BORLANDC__
ULONG _dllmain(ULONG ulTermCode,HMODULE hModule)
#else
ULONG _System _DLL_InitTerm(HMODULE hMod,ULONG ulTermCode)
#endif
  {
  if (ulTermCode == 0)
    hModule = hMod;
  return(TRUE);
  }
#endif

APIRET EXPENTRY GetDCB(HIOCTL hIOctl,HFILE hCom,DCB *pstComDCB)
  {
  ULONG ulDataLen = sizeof(DCB);
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x73,0L,0L,&ulParmLen,(PVOID)pstComDCB,sizeof(DCB),&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_DCBRD,0x73,rc);
  return(rc);
  }

APIRET EXPENTRY SendDCB(HIOCTL hIOctl,HFILE hCom,DCB *pstComDCB)
  {
  ULONG ulDataLen = 0L;
  ULONG ulParmLen = sizeof(DCB);
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x53,(PVOID)pstComDCB,sizeof(DCB),&ulParmLen,0L,0L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_DCBWRT,0x53,rc);
  return(rc);
  }

APIRET EXPENTRY SendByteImmediate(HIOCTL hIOctl,HFILE hCom,BYTE bySendByte)
  {
  ULONG ulDataLen = 0L;
  ULONG ulParmLen = 1L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x44,(PVOID)&bySendByte,1L,&ulParmLen,0L,0L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_TXIMM,0x44,rc);
  return(rc);
  }

APIRET EXPENTRY GetXmitStatus(HIOCTL hIOctl,HFILE hCom,BYTE *pbyCOMstatus)
  {
  ULONG ulDataLen = 1l;
  ULONG ulParmLen = 0l;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x65,0L,0L,&ulParmLen,(PVOID)pbyCOMstatus,1L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_XMITSTAT,0x65,rc);
  return(rc);
  }

APIRET EXPENTRY GetCOMstatus(HIOCTL hIOctl,HFILE hCom,BYTE *pbyCOMstatus)
  {
  ULONG ulDataLen = 1L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x64,0L,0L,&ulParmLen,pbyCOMstatus,1L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_COMSTAT,0x64,rc);
  return(rc);
  }

APIRET EXPENTRY GetCOMevent(HIOCTL hIOctl,HFILE hCom,WORD *pwCOMevent)
  {
  ULONG ulDataLen = 2L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x72,0L,0L,&ulParmLen,pwCOMevent,2L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_COMEVENT,0x72,rc);
  return(rc);
  }

APIRET EXPENTRY GetCOMerror(HIOCTL hIOctl,HFILE hCom,WORD *pwCOMerror)
  {
  ULONG ulDataLen = 2L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x6d,0L,0L,&ulParmLen,pwCOMerror,2L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_COMERROR,0x6d,rc);
  return(rc);
  }

APIRET EXPENTRY BreakOn(HIOCTL hIOctl,HFILE hCom,WORD *pwCOMerror)
  {
  ULONG ulDataLen = 2L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x4b,0L,0L,&ulParmLen,pwCOMerror,2L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_BRKON,0x4b,rc);
  return(rc);
  }

APIRET EXPENTRY BreakOff(HIOCTL hIOctl,HFILE hCom,WORD *pwCOMerror)
  {
  ULONG ulDataLen = 2L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x45,0L,0L,&ulParmLen,pwCOMerror,2L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_BRKOFF,0x45,rc);
  return(rc);
  }

APIRET EXPENTRY GetReceiveQueueLen(HIOCTL hIOctl,HFILE hCom,WORD *pwQueueLen,WORD *pwByteCount)
  {
  ULONG ulDataLen = 4L;
  ULONG ulParmLen = 0L;
  APIRET rc;
  struct
    {
    WORD wByteCount;
    WORD wQueueLen;
    }stWordPair;

  if ((rc = DosDevIOCtl(hCom,0x01,0x68,0L,0L,&ulParmLen,&stWordPair,4L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_RCVQLEN,0x68,rc);
  *pwQueueLen = stWordPair.wQueueLen;
  *pwByteCount = stWordPair.wByteCount;
  return(rc);
  }

APIRET EXPENTRY GetReceiveQueueCounts(HIOCTL hIOctl,HFILE hCom,BUFCNT *pstCounts)
  {
  ULONG ulDataLen = sizeof(BUFCNT);
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x68,0L,0L,&ulParmLen,pstCounts,sizeof(BUFCNT),&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_RCVQLEN,0x68,rc);
  return(rc);
  }

APIRET EXPENTRY GetTransmitQueueLen(HIOCTL hIOctl,HFILE hCom,WORD *pwQueueLen,WORD *pwByteCount)
  {
  ULONG ulDataLen = 4L;
  ULONG ulParmLen = 0L;
  APIRET rc;
  struct
    {
    WORD wByteCount;
    WORD wQueueLen;
    }stWordPair;

  if ((rc = DosDevIOCtl(hCom,0x01,0x69,0L,0L,&ulParmLen,&stWordPair,4L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_TXQLEN,0x69,rc);
  *pwQueueLen = stWordPair.wQueueLen;
  *pwByteCount = stWordPair.wByteCount;
  return(rc);
  }

APIRET EXPENTRY GetTransmitQueueCounts(HIOCTL hIOctl,HFILE hCom,BUFCNT *pstCounts)
  {
  ULONG ulDataLen = 6L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x69,0L,0L,&ulParmLen,pstCounts,6L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_TXQLEN,0x69,rc);
  return(rc);
  }

APIRET EXPENTRY GetModemInputSignals(HIOCTL hIOctl,HFILE hCom,BYTE *pbySignals)
  {
  ULONG ulDataLen = 1L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x67,0L,0L,&ulParmLen,pbySignals,1L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_MDMSET,0x67,rc);
  return(rc);
  }

APIRET EXPENTRY GetModemOutputSignals(HIOCTL hIOctl,HFILE hCom,BYTE *pbySignals)
  {
  ULONG ulDataLen = 1L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x66,0L,0L,&ulParmLen,pbySignals,1L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_MDMGET,0x66,rc);
  return(rc);
  }

APIRET EXPENTRY SetModemSignals(HIOCTL hIOctl,HFILE hCom,BYTE byOnByte,BYTE byOffByte,WORD *pwCOMerror)
  {
  ULONG ulDataLen = 2L;
  ULONG ulParmLen = 2L;
  APIRET rc;
  MDMSSIG stModemSetSignals;

  stModemSetSignals.ModemSigOn = byOnByte;
  stModemSetSignals.ModemSigOff = byOffByte;

  if ((rc = DosDevIOCtl(hCom,0x01,0x46,&stModemSetSignals,2L,&ulParmLen,pwCOMerror,2L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_MDMSET,0x46,rc);
  return(rc);
  }

APIRET EXPENTRY SetLineCharacteristics(HIOCTL hIOctl,HFILE hCom,LINECHAR *pstLineChar)
  {
  ULONG ulDataLen = 0L;
  ULONG ulParmLen = sizeof(LINECHAR);
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x42,pstLineChar,sizeof(LINECHAR),&ulParmLen,0L,0L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_LINEWRT,0x42,rc);
  return(rc);
  }

APIRET EXPENTRY GetLineCharacteristics(HIOCTL hIOctl,HFILE hCom,LINECHAR *pstLineChar)
  {
  ULONG ulDataLen = sizeof(LINECHAR);
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x62,0L,0L,&ulParmLen,pstLineChar,sizeof(LINECHAR),&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_LINERD,0x62,rc);
  return(rc);
  }

APIRET EXPENTRY SetBaudRate(HIOCTL hIOctl,HFILE hCom,LONG lBaud)
  {
  ULONG ulDataLen = 0l;
  ULONG ulParmLen = sizeof(BAUDRT);
  APIRET rc;
  WORD wFunction = 0x0041;
  BAUDRT stBaudRate;

  stBaudRate.lBaudRate = lBaud;
  stBaudRate.byFraction = 0;
  if (stBaudRate.lBaudRate > 0xffff)
  wFunction = 0x0043;
  if ((rc = DosDevIOCtl(hCom,0x01,wFunction,&stBaudRate,sizeof(BAUDRT),&ulParmLen,0L,0L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_BAUDWRT,wFunction,rc);
  return(rc);
  }

APIRET EXPENTRY GetBaudRate(HIOCTL hIOctl,HFILE hCom,LONG *plBaud)
  {
  ULONG ulDataLen = sizeof(BAUDRT);
  ULONG ulParmLen = 0L;
  APIRET rc;
  BAUDST stBaudRate;

  *plBaud = 0;
  if ((rc = DosDevIOCtl(hCom,0x01,0x63,0L,0L,&ulParmLen,&stBaudRate,sizeof(BAUDRT),&ulDataLen)) != 0)
    rc = DosDevIOCtl(hCom,0x01,0x61,0L,0L,&ulParmLen,&stBaudRate,sizeof(BAUDRT),&ulDataLen);
  if (rc)
    IOctlErrorMessageBox(hIOctl,IC_ATM_BAUDRD,0x63,rc);
  *plBaud = stBaudRate.stCurrentBaud.lBaudRate;
  return(rc);
  }

APIRET EXPENTRY GetBaudRates(HIOCTL hIOctl,HFILE hCom,BAUDST *pstBaudRates)
  {
  ULONG ulDataLen = sizeof(BAUDST);
  ULONG ulParmLen = 0L;
  USHORT usBaud = 0;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x63,0L,0L,&ulParmLen,pstBaudRates,sizeof(BAUDST),&ulDataLen)) != 0)
    {
    ulDataLen = sizeof(USHORT);
    if ((rc = DosDevIOCtl(hCom,0x01,0x61,0L,0L,&ulParmLen,&usBaud,sizeof(USHORT),&ulDataLen)) != NO_ERROR)
      IOctlErrorMessageBox(hIOctl,IC_ATM_BAUDRD,0x61,rc);
    }
  if (usBaud != 0)
    {
    pstBaudRates->stCurrentBaud.lBaudRate = (LONG)usBaud;
    pstBaudRates->stHighestBaud.lBaudRate = 57600;
    }
  return(rc);
  }

APIRET EXPENTRY ForceXon(HIOCTL hIOctl,HFILE hCom)
  {
  ULONG ulDataLen = 0L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x48,0L,0L,&ulParmLen,0L,0L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_FXON,0x48,rc);
  return(rc);
  }

APIRET EXPENTRY ForceXoff(HIOCTL hIOctl,HFILE hCom)
  {
  ULONG ulDataLen = 0L;
  ULONG ulParmLen = 0L;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x47,0L,0L,&ulParmLen,0L,0L,&ulDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_FXOFF,0x47,rc);
  return(rc);
  }

APIRET EXPENTRY FlushComBuffer(HIOCTL hIOctl,HFILE hCom,WORD wDirection)
  {
  ULONG pcbDataLen = 0;
  ULONG pcbParmLen = 1;
  APIRET rc;
  BYTE byParam = 0;

  if ((rc = DosDevIOCtl(hCom,0x0b,(ULONG)wDirection,&byParam,1L,&pcbParmLen,0L,0L,&pcbDataLen)) != 0)
    IOctlErrorMessageBox(hIOctl,IC_ATM_FLUSH,0x0b,rc);
  return(rc);
  }

APIRET EXPENTRY GetFIFOinfo(HIOCTL hIOctl,HFILE hCom,FIFOINF *pstFIFOinfo)
  {
  ULONG ulDataLen = sizeof(FIFOINF);
  ULONG ulParmLen = 0;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x75,0L,0L,&ulParmLen,pstFIFOinfo,ulDataLen,&ulDataLen)) != NO_ERROR)
    {
    IOctlErrorMessageBox(hIOctl,IC_ATM_GET_FIFO,0x75,rc);
    return(FALSE);
    }
  return(NO_ERROR);
  }

APIRET EXPENTRY SetFIFO(HIOCTL hIOctl,HFILE hCom,FIFODEF *pstFIFOcontrol)
  {
  ULONG ulDataLen = 0;
  ULONG ulParmLen = sizeof(FIFODEF);
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x55,pstFIFOcontrol,ulParmLen,&ulParmLen,0L,0L,&ulDataLen)) != NO_ERROR)
    {
    IOctlErrorMessageBox(hIOctl,IC_ATM_SET_FIFO_LOAD,0x55,rc);
    return(FALSE);
    }
  return(NO_ERROR);
  }

APIRET EXPENTRY GetCountsSinceLast(HIOCTL hIOctl,HFILE hCom,DIAGCOUNTS *pstCounts)
  {
  ULONG ulDataLen = sizeof(DIAGCOUNTS);
  ULONG ulParmLen = 0;
  APIRET rc;

  if ((rc = DosDevIOCtl(hCom,0x01,0x7A,0L,0L,&ulParmLen,pstCounts,ulDataLen,&ulDataLen)) != NO_ERROR)
    {
    IOctlErrorMessageBox(hIOctl,IC_ATM_GET_DIAG_COUNTS,0x7A,rc);
    return(FALSE);
    }
  return(NO_ERROR);
  }

VOID IOctlErrorMessageBox(HIOCTL hIOctl,ULONG idErrMsg,WORD wFunction,APIRET rcError)
  {
  CHAR szErrMsg[80];
  CHAR szMsgString[200];
  LONG lLength;
  ULONG idErrCode;

  if (hIOctl != 0)
    {
    lLength = WinLoadString(hIOctl->hab,hModule,idErrMsg,sizeof(szMsgString),szMsgString);
    WinLoadString(hIOctl->hab,hModule,IC_ATM_FUNCTION,sizeof(szErrMsg),szErrMsg);
    lLength += sprintf(&szMsgString[lLength],"\n\n%s 0x%02X",szErrMsg,wFunction);
    lLength += sprintf(&szMsgString[lLength],"\n");
    switch (rcError)
      {
      case 87:
        WinLoadString(hIOctl->hab,hModule,IC_ATM_ERRMSG_INVALID_PARAM,sizeof(szErrMsg),&szMsgString[lLength]);
        break;
      case 31:
        WinLoadString(hIOctl->hab,hModule,IC_ATM_ERRMSG_GEN_FAIL,sizeof(szErrMsg),&szMsgString[lLength]);
        break;
      case 22:
        WinLoadString(hIOctl->hab,hModule,IC_ATM_ERRMSG_BAD_COMMAND,sizeof(szErrMsg),&szMsgString[lLength]);
        break;
      default:
        WinLoadString(hIOctl->hab,hModule,IC_ATM_ERRMSG_UNKNOWN_ERROR,sizeof(szErrMsg),szErrMsg);
        sprintf(&szMsgString[lLength],"%s = %u",szErrMsg,rcError);
        break;
      }
    lLength = WinLoadString(hIOctl->hab,hModule,IC_ATM_IOCTL,sizeof(szErrMsg),szErrMsg);
    if (hIOctl->pszPortName != 0)
      sprintf(&szErrMsg[lLength]," - %s",hIOctl->pszPortName);
    WinMessageBox(HWND_DESKTOP,
                  HWND_DESKTOP,
             (PSZ)szMsgString,
             (PSZ)szErrMsg,
                  0,
                  MB_MOVEABLE | MB_OK | MB_CUAWARNING);
    }
  }


