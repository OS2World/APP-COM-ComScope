/**************************************************************************
 *
 * SOURCE FILE NAME = SPOOLER.H
 *
 * DESCRIPTIVE NAME = serial port driver header file
 *
 *
 *
 * COPYRIGHT    Copyright (C) 1992 IBM Corporation
 *
 * The following IBM OS/2 2.1 source code is provided to you solely for
 * the purpose of assisting you in your development of OS/2 2.x device
 * drivers. You may use this code in accordance with the IBM License
 * Agreement provided in the IBM Device Driver Source Kit for OS/2. This
 * Copyright statement may not be removed.
 *
 *
 *
 * VERSION = V2.0
 *
 * DATE
 *
 * DESCRIPTION
 *
 *
 * FUNCTIONS
 *
 * ENTRY POINTS:
 *
 * DEPENDENCIES:
 *
 * NOTES
 *
 *
 * STRUCTURES
 *
 * EXTERNAL REFERENCES
 *
 * EXTERNAL FUNCTIONS
 *
 ***************************************************************************/

#ifndef SERIAL_INCL

#include "COMMON.H"
#include "COMDD.H"
#include "IOCTL.H"
#include "UTILITY.H"
#include "menu.h"
#include "usermsg.h"
#include "SPOOL.H"
#include "CONFIG.H"

#include <stdlib.h>
#include <string.h>

#define SERIAL_ICON  7001

typedef struct
    {
    SHORT cx;
    SHORT cy;
    }CHCELL;

#define PRT_HELPFILE_NAME         "CONFIG.HLP"
#if DEBUG > 0
 #define SERIAL_DLL                "SPL_DEB.PDR"
#else
 #ifdef DEMO
  #define SERIAL_DLL                "SPL_DEMO.PDR"
 #else
  #define SERIAL_DLL                "COMi_SPL.PDR"
 #endif
#endif

#define STR_LEN_PORTNAME          64
#define STR_LEN_PORTDESC          256
#define STR_LEN_DESC              81
#define PORT_ENTRY_LEN            256
#define STR_LEN_TITLE             256

#if DEBUG > 0
 #define DEF_PORTDRIVER            "SPL_DEB;" //Must be all upper case
#else
 #ifdef DEMO
  #define DEF_PORTDRIVER            "SPL_DEMO;" //Must be all upper case
 #else
  #define DEF_PORTDRIVER            "COMI_SPL;" //Must be all upper case
 #endif
#endif

#define APPNAME_LEAD_STR          "PM_"

#define KEY_DESCRIPTION           "DESCRIPTION"
#define KEY_INITIALIZATION        "INITIALIZATION"
#define KEY_TERMINATION           "TERMINATION"
#define KEY_PORTDRIVER            "PORTDRIVER"
#define KEY_TIMEOUT               "TIMEOUT"

#define APPNAME_PM_SPOOLER_PORT   "PM_SPOOLER_PORT"

#define IOCTL_TIMEOUT_UPPER_LIMIT (TIMEOUT_UPPER_LIMIT * 100)

/*
** PORTNAMES structure is as defined for PMSPL.H.
*/
typedef struct _PORTNAMES
  {
  PSZ pszPortName;         // -> name of port(ie "COM1)
  PSZ pszPortDesc;         // -> description of port(ie "Serial Port 1")
  } PORTNAMES, *PPORTNAMES;

#ifdef this_junk
typedef struct _SERIALDATA
  {
  HAB hAB;
  HMODULE hModule;
  PSZ  pszPortName;
  PSZ  pszAppName;
  CHAR szSaveCommSetting[PORT_ENTRY_LEN+1];
  CHAR szOrgCommSetting[PORT_ENTRY_LEN+1];
  USHORT usSaveTimeOut;
  USHORT usOrgTimeOut;
  ULONG lfModified;
  }SERIALDATA, *PSERIALDATA;

#pragma pack(1)

typedef struct _EXTQUERYBIT
  {
  ULONG    ulCurBitRate;
  BYTE     ucCurBitRateFrac;
  ULONG    ulMinBitRate;
  BYTE     ucMinBitRateFrac;
  ULONG    ulMaxBitRate;
  BYTE     ucMaxBitRateFrac;
  }EXTQUERYBIT;

EXTQUERYBIT *PEXTQUERYBIT;

#pragma pack()

/*
** structure for setting/getting communications port settings
** These map closely to DosDevIOCtl Category 1 structures
*/
typedef struct
  {
  ULONG ulBaudRate;
  UCHAR DataParityStop[3];
  struct
    {
    USHORT WriteTimeout;
    USHORT ReadTimeout;
    UCHAR Flags1;
    UCHAR Flags2;
    UCHAR Flags3;
    UCHAR ErrorReplacementCharacter;
    UCHAR BreakReplacementCharacter;
    UCHAR XONCharacter;
    UCHAR XOFFCharacter;
    }DeviceCtlBlk;
  }COMMINFO;
#endif

VOID RemoveLeadTrailBlanks (PCH, PCH);

VOID   DE (PSZ);
BOOL  GetPortDescription (HAB, HMODULE, PSZ, PSZ);
VOID    RemoveLeadTrailBlanks (PCH pTarget, PCH pSource);

BOOL    InitializeCommPort(HFILE fh, PSZ pszLogAddress);
VOID    DE (PCH str);

#define SPOOLER_INCL
#endif
