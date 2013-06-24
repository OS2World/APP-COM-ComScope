/**************************************************************************
 *
 * SOURCE FILE NAME = SERIAL.C
 *
 * DESCRIPTIVE NAME = Serial Port Driver
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
 * VERSION = V2.11
 *
 * DATE
 *
 * DESCRIPTION
 *
 *
 * FUNCTIONS
 *
 * ENTRY POINTS: SplPdEnumPort, SplPdInitPort, SplPdInstallPort,
 *               SplPdGetPortIcon, SplPdQueryPort, SplPdSetPort
 *               SplPdRemovePort, SplPdTermPort
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

#include "spooler.h"
#include "port.h"
#include "help.h"

COMICFG stCOMiCFG;

/*
** If port driver is not defined in INI file yet
** assume it exists in the boot drive's \OS2\DLL directory
CHAR szDefaultPortDrvPath[] = "?:\\OS2\\DLL\\COMi.PDR";
char szLibName[] = "COMI";
*/

#define DRIVER_DESC "COMi Print Spooler Driver "
#define DEVICE_DESC "COMi Serial Port "
#define DEVICE_NAME "COMi COM"

char szMessage[300];

VOID  CopyPortInfo(HAB hab,PCH pBuf,ULONG ulCount);

char szDriverIniPath[CCHMAXPATH];
char szDriverVersion[CCHMAXPATH];
char szConfigLibPath[CCHMAXPATH];

char aszDeviceList[1000];

HMODULE hThisModule;
BOOL bSpoolerEnabled = FALSE;
ULONG ulSignature = 0;

VOID Spl_MessageBox(HWND hwnd,PSZ pszMessage)
  {
  WinMessageBox(HWND_DESKTOP,
                hwnd,
                pszMessage,
#if DEBUG > 0
                "SPL_DEB",
#else
                "COMi Spooler Error!",
#endif
                0,
                MB_MOVEABLE | MB_OK | MB_CUAWARNING);
  }

#ifdef __BORLANDC__
ULONG _dllmain(ULONG ulTermCode,HMODULE hModule)
#else
int _CRT_init(void);

ULONG _System _DLL_InitTerm(HMODULE hMod,ULONG ulTermCode)
#endif
  {
  HMODULE hModule;
  PFN pfnProcess;

  if (ulTermCode == 0)
    {
    hThisModule = hMod;

#ifndef __BORLANDC__
    if (_CRT_init() == -1)
      return(FALSE);
#endif
    if (szConfigLibPath[0] == 0)
      {
      if ((PrfQueryProfileString (HINI_USERPROFILE,"COMi",
                          "Configuration",NULL,szConfigLibPath,
                          (CCHMAXPATH - 1))) == 0)
        {
        sprintf(szMessage,"The COMi device driver and supporting libraries must be properly installed before COMi print spooler support can be installed.\n\nYou will need to delete the file \"\\OS2\\DLL\\%s\" on your boot drive in order install default spooler support.",SERIAL_DLL);
        Spl_MessageBox(HWND_DESKTOP,szMessage);
        return(FALSE);
        }
      else
        {
        if (DosLoadModule(0,0,szConfigLibPath,&hMod) == NO_ERROR)
          {
          stCOMiCFG.pszPortName = NULL;
          if (DosQueryProcAddr(hMod,0,"GetDriverVersion",&pfnProcess) == NO_ERROR)
            if (!pfnProcess(szDriverVersion,&ulSignature))
              {
              sprintf(szMessage,"The COMi device driver must be loaded before COMi print spooler support can be installed.\n\nYou will need to delete the file \"\\OS2\\DLL\\%s\" on your boot drive in order install default spooler support.",SERIAL_DLL);
              Spl_MessageBox(HWND_DESKTOP,szMessage);
              DosFreeModule(hMod);
              return(FALSE);
              }
          DosFreeModule(hMod);
          }
        else
          {
          sprintf(szMessage,"The COMi device driver configuration library, %s, does not exist or is invalid.\n\nYou will need to delete the file \"\\OS2\\DLL\\%s\" on your boot drive in order install default spooler support.",szConfigLibPath,SERIAL_DLL);
          Spl_MessageBox(HWND_DESKTOP,szMessage);
          return(FALSE);
          }
        }
      }
    if (ulSignature != SIGNATURE)
      {
      if (ulSignature == GA_SIGNATURE)
        {
        sprintf(szMessage,"This version of COMspool will work only with the Demonstration version of COMi.\n\nYou will need to delete the file \"\\OS2\\DLL\\%s\" on your boot drive in order install default spooler support.",SERIAL_DLL);
        Spl_MessageBox(HWND_DESKTOP,szMessage);
        }
      else
        if (ulSignature == DEMO_SIGNATURE)
          {
          sprintf(szMessage,"This version of COMspool will not work with the Demonstration version of COMi.\n\nYou will need to delete the file \"\\OS2\\DLL\\%s\" on your boot drive in order install default spooler support.",SERIAL_DLL);
          Spl_MessageBox(HWND_DESKTOP,szMessage);
          }
        else
          {
          sprintf(szMessage,"This version of COMspool will not work with the UNK$%u version of COMi that is loaded.\n\nYou will need to delete the file \"\\OS2\\DLL\\%s\" on your boot drive in order install default spooler support.",ulSignature,SERIAL_DLL);
          Spl_MessageBox(HWND_DESKTOP,szMessage);
          }
      return(FALSE);
      }
    bSpoolerEnabled = TRUE;
    }
  return(TRUE);
  }

/****************************************************************************
 *
 * FUNCTION NAME = SplPdEnumPort
 *
 * DESCRIPTION   = Return ports supported by this port driver
 *                 Only ports that appear in the COMi initialization
 *                 will be returned.
 *
 * INPUT         = hab - anchor block handle
 *                 pBuf - buffer to get enumerated PORTNAMES structures
 *                 cbBuf - size(in bytes) of pBuf passed in
 *
 * OUTPUT        = *pulReturned - number of PORTNAMES structures stored in pBuf
 *                 *pulTotal    - total ports COMi is configured to support.
 *                 *pcbRequired - size(in bytes) of buffer needed to store
 *                                all enumerated PORTNAMES entries.
 *                 pBuf - gets an array(number elements is *pulReturned) of
 *                        PORTNAMES structures.
 *                        Each psz in PORTNAMES structure points to a string
 *                        copied into the end of pBuf.
 *
 *                 typedef struct _PORTNAMES
 *                   {
 *                   PSZ pszPortName;  // Name of port, example: LPT1
 *                   PSZ pszPortDesc;  // Port description
 *                   } PORTNAMES;
 *
 * RETURN-NORMAL = 0 - if all portnames and descriptions fit in pBuf
 *
 * RETURN-ERROR  = ERROR_INSUFFICIENT_BUFFER - if no PORTNAMES structs
 *                                             could fit in buffer.  Caller
 *                                             uses *pcbRequired to allocate
 *                                             a buffer big enough to store all
 *                                             port names.
 *                 ERROR_MORE_DATA - if some, but not all, PORTNAMES structs
 *                                   could fit in buffer.  Caller
 *                                   uses *pcbRequired to allocate
 *                                   a buffer big enough to store all
 *                                   port names.
 *
 *      NOTE: early versions of the print object expected ERROR_MORE_DATA
 *            to be returned, even when no PORTNAMES structures would fit.
 *            For this reason, we do not return ERROR_INSUFFICIENT_BUFFER
 *
 ****************************************************************************/

APIRET APIENTRY SPLPDENUMPORT(HAB hab,
                              PVOID pBuf,
                              ULONG cbBuf,
                              PULONG pulReturned,
                              PULONG pulTotal,
                              PULONG pcbRequired )

  {
  ULONG   rcLoadMod;
  char chString[STR_LEN_PORTDESC];
  PFN pfnProcess;
  HMODULE hMod = 0;
  int iDeviceCount = 0;
  APIRET rc;

#if DEBUG > 3
  Spl_MessageBox(HWND_DESKTOP,"Enumerating Ports");
#endif
  /*
  ** insure pointers not null
  */
  if (!pulReturned || !pulTotal ||!pcbRequired)
    return(ERROR_INVALID_PARAMETER);

  /*
  ** if buffer length is supplied then there should be pBuf
  */
  if (!pBuf && cbBuf)
    return(ERROR_INVALID_PARAMETER);

  *pulReturned = 0;
  *pcbRequired = 0;
  *pulTotal = 0;

//  if ((PrfQueryProfileString (HINI_USERPROFILE,"COMi",
//                        "Configuration",NULL,szConfigLibPath,
//                        (CCHMAXPATH - 1))) == 0)

  if (szConfigLibPath[0] == 0)
    {
#if DEBUG > 0
    Spl_MessageBox(HWND_DESKTOP,"Enum failed - Invalid Configuraton path");
#endif
    return(NO_ERROR);
    }
  else
    {
    if ((rc = DosLoadModule(0,0,szConfigLibPath,&hMod)) == NO_ERROR)
      {
      if (DosQueryProcAddr(hMod,0,"FillDeviceNameList",&pfnProcess) == NO_ERROR)
        {
        stCOMiCFG.bEnumCOMscope = FALSE;
        stCOMiCFG.cbDevList = 0;
        iDeviceCount = pfnProcess(&stCOMiCFG);
        }
#if DEBUG > 0
      else
        Spl_MessageBox(HWND_DESKTOP,"Could not load FillDeviceNameList function address");
      }
    else
      {
      sprintf(szMessage,"Could not load %s - rc = %04X",szConfigLibPath,rc);
      Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
      }
    }

  if (iDeviceCount == 0)
    {
#if DEBUG > 0
    Spl_MessageBox(HWND_DESKTOP,"No COMi devices defined");
#endif
    if (hMod != 0)
      DosFreeModule(hMod);
    return(NO_ERROR);
    }

  if (iDeviceCount > 99)
    iDeviceCount = 99;
  *pulTotal = iDeviceCount;
  *pcbRequired += (strlen(DEVICE_NAME) + 3); // add for two digit number
  *pcbRequired += (strlen(DEVICE_DESC) + 4); // add for space and two digit number
  *pcbRequired += sizeof(PORTNAMES);
  *pcbRequired *= *pulTotal;
  /*
  ** check if cbBuf is 0 - then return number of ports in pulTotal
  ** and number of bytes required in pcbRequired
  */
  if (cbBuf == 0L)
    {
    /*
    ** NOTE: early version of the print object checked for
    **       ERROR_MORE_DATA instead of ERROR_INSUFFICIENT_BUFFER
    **       For this reason we return ERROR_MORE_DATA here.
    */
    if (hMod != 0)
      DosFreeModule(hMod);
    return(ERROR_MORE_DATA);
    }

  /*
  ** check number of ports info we can fit in supplied buffer
  */
  *pulReturned = (cbBuf / (*pcbRequired / *pulTotal));
  if (*pulReturned > *pulTotal)
    *pulReturned = *pulTotal;
  /*
  ** return error if we can not fit one port.
  */
  if ((*pulReturned) == 0)
    {
    if (hMod != 0)
      DosFreeModule(hMod);
     return(ERROR_INSUFFICIENT_BUFFER);
    }
  stCOMiCFG.pDeviceList = aszDeviceList;
  stCOMiCFG.cbDevList = 1000;
  pfnProcess(&stCOMiCFG);
  DosFreeModule(hMod);
  /*
  ** copy all the ports which we can store in the pBuf
  */
  CopyPortInfo(hab,(PCH)pBuf,*pulReturned);

  if (*pulReturned < *pulTotal)
    return(ERROR_MORE_DATA);

  return(NO_ERROR);
  }

/****************************************************************************
 *
 * FUNCTION NAME = SplPdInitPort
 *
 * DESCRIPTION   = Initialize port on behalf of the spooler
 *
 * INPUT         = hFile       - File handle to port
 *                 pszPortName - name of port to initialize
 *
 * OUTPUT        = Sets Serial communications port settings
 *
 * RETURN-NORMAL = 0
 *
 * RETURN-ERROR  = ERROR_INVALID_PARAMETER - if bad port name given
 *
 ****************************************************************************/
APIRET APIENTRY SPLPDINITPORT(HFILE hFile,PSZ pszPortName)
  {
  char szAppName[STR_LEN_PORTNAME];
  char chPortDriver[STR_LEN_PORTNAME];
  ULONG ulDataSize;
  PORTINIT stPortInit;
  APIRET rc;

#if DEBUG > 3
  sprintf(szMessage,"Initializing %s",pszPortName);
  Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
  /*
  ** Check if port name string is NULL. This is an error.
  */
  if (!pszPortName)
    {
#if DEBUG > 0
    sprintf(szMessage,"Init failed - bad port name - %s",pszPortName);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }
  /*
  ** Make Application name string( "PM_PortName" )
  */
  strcpy (szAppName,APPNAME_LEAD_STR);
  strcat (szAppName,pszPortName);
  /*
  ** Check if this port is a serial port.
  ** (See if port driver for this port is "COMI_SPL")
  */
  if (!(PrfQueryProfileString (HINI_SYSTEMPROFILE,szAppName,
                                KEY_PORTDRIVER, NULL,chPortDriver,
                                STR_LEN_PORTNAME)))
    {
#if DEBUG > 0
    sprintf(szMessage,"Init failed - getting port driver name - %s",chPortDriver);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }
  if (strcmp(chPortDriver,DEF_PORTDRIVER) != 0)
    {
#if DEBUG > 0
    sprintf(szMessage,"Init failed - bad port driver - %s",chPortDriver);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }
  /*
  ** Check if this port is installed.
  */
  ulDataSize = sizeof(PORTINIT);
  if (!(PrfQueryProfileData(HINI_SYSTEMPROFILE,szAppName,
                             "PortSetup",&stPortInit,
                                &ulDataSize)))
    {
#if DEBUG > 0
    sprintf(szMessage,"Init failed - getting \"PortSetup\" - %s",szAppName);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }
  /*
  ** Initialize this serial port.
  */
  if ((rc = SetBaudRate(0,hFile,stPortInit.ulBaudRate)) != NO_ERROR)
    {
#if DEBUG > 0
    sprintf(szMessage,"Failed setting baud rate - rc = %04X",rc);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }
  if ((rc = SendDCB(0,hFile,&stPortInit.stComDCB)) != NO_ERROR)
    {
#if DEBUG > 0
    sprintf(szMessage,"Failed setting DCB - rc = %04X",rc);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }
  if ((rc = SetLineCharacteristics(0,hFile,&stPortInit.stLine)) != NO_ERROR)
    {
#if DEBUG > 0
    sprintf(szMessage,"Failed setting line char - rc = %04X",rc);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }

  return(NO_ERROR);
  }

/****************************************************************************
 *
 * FUNCTION NAME = SplPdInstallPort
 *
 * DESCRIPTION   = Tells port driver the name of a port that needs to be
 *                   installed.
 *                 Port driver should write Initialization/Termination
 *                   strings to the INI file.
 *                 Typically SplPdSetPort will be called after this.
 *                 This should allow any port to be added for this port driver.
 *                   (ie: if it is not a port we returned in SplPdEnumPort,
 *                    still allow the port to use this port driver).
 *
 * INPUT         = hab         - Anchor block handle
 *                 pszPortName - name of port to be installed
 *
 * OUTPUT        =
 *
 * RETURN-NORMAL = 0
 *
 * RETURN-ERROR  = ERROR_INVALID_PARAMETER - if bad port name given
 *
 ****************************************************************************/

APIRET APIENTRY SPLPDINSTALLPORT(HAB hab,PSZ pszPortName)
  {
  char szAppName[STR_LEN_PORTNAME];
  ERRORID eidError;
  BOOL bSetDefaults = TRUE;
  HMODULE hMod;
  PFN pfnProcess;
  PORTINIT stPortInit;
  APIRET rc;

#if DEBUG > 3
 sprintf(szMessage,"Installing %s",pszPortName);
 Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
  /*
  ** Check if port name string is NULL. This is an error.
  */
  if (pszPortName == NULL)
    {
#if DEBUG > 0
    sprintf(szMessage,"Install failed - no port name - %s",pszPortName);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }

  /*
  ** Make Application name string.
  */
  strcpy (szAppName,APPNAME_LEAD_STR);
  strcat (szAppName,pszPortName);

  /*
  ** Write data for this port in ini file with new format.
  */
  if (!PrfWriteProfileString (HINI_SYSTEMPROFILE,
                              szAppName,
                              KEY_DESCRIPTION,
                              DEVICE_DESC))
#if DEBUG > 0
    {
    rc = WinGetLastError(hab);
    sprintf(szMessage,"Install failed - getting description - %s, rc = %04X",szAppName,rc);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
    return(rc);
    }
#else
    return (WinGetLastError (hab));
#endif

#ifdef remote_CFG
//  if ((PrfQueryProfileString (HINI_USERPROFILE,"COMi",
//                        "Configuration",NULL,szConfigLibPath,
//                        (CCHMAXPATH - 1))) == 0)
  if (szConfigLibPath[0] == 0)
    {
#if DEBUG > 0
    sprintf(szMessage,"Can't get Configuration Path\n\n%s was attempted",szConfigLibPath);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(NO_ERROR);
    }
  else
    {
    if ((rc = DosLoadModule(0,0,szConfigLibPath,&hMod)) == NO_ERROR)
      {
      if (DosQueryProcAddr(hMod,0,"GetPortConfig",&pfnProcess) == NO_ERROR)
        if (pfnProcess(pszPortName,&stPortInit))
          bSetDefaults = FALSE;
#if DEBUG > 0
      else
        Spl_MessageBox(HWND_DESKTOP,"Could not load GetPortConfig function address");
#endif
      DosFreeModule(hMod);
      }
#if DEBUG > 0
    else
      {
      sprintf(szMessage,"Could not load %s - rc = %04X",szConfigLibPath,rc);
      Spl_MessageBox(HWND_DESKTOP,szMessage);
      }
#endif
    }

  if (bSetDefaults)
#endif  //remote_CFG
    {
    stPortInit.ulBaudRate = 9600;
    stPortInit.stLine.DataBits = 8;
    stPortInit.stLine.Parity = 0;
    stPortInit.stLine.StopBits = 0;
    stPortInit.stComDCB.WrtTimeout = 4500;
    stPortInit.stComDCB.ReadTimeout = 6000;
    stPortInit.stComDCB.XonChar = '\x11';
    stPortInit.stComDCB.XoffChar = '\x13';
    stPortInit.stComDCB.BrkChar = 0;
    stPortInit.stComDCB.ErrChar = 0;
    stPortInit.stComDCB.Flags1 = F1_ENABLE_CTS_OUTPUT_HS;
    stPortInit.stComDCB.Flags2 = F2_DEFAULT;
    stPortInit.stComDCB.Flags3 = F3_DEFAULT;
    }

  stPortInit.chTerm = ';';
  stPortInit.byTerm = 0;

  if (!PrfWriteProfileString(HINI_SYSTEMPROFILE,
                             szAppName,
                             KEY_INITIALIZATION,
                            "COMi Spooler;"))
    return (WinGetLastError (hab));

  if (!PrfWriteProfileData(HINI_SYSTEMPROFILE,
                           szAppName,
                          "PortSetup",
                          &stPortInit,
                           sizeof(PORTINIT)))
#if DEBUG > 0
    {
    rc = WinGetLastError(hab);
    sprintf(szMessage,"Install failed - getting init parameters - %s, rc = %04X",szAppName,rc);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
    return(rc);
    }
#else
    return (WinGetLastError (hab));
#endif
  if (!PrfWriteProfileString (HINI_SYSTEMPROFILE,
                              szAppName,
                              KEY_PORTDRIVER,
                              DEF_PORTDRIVER))
#if DEBUG > 0
    {
    rc = WinGetLastError(hab);
    sprintf(szMessage,"Install failed - setting port driver - %s",szAppName);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
    return(rc);
    }
#else
    return (WinGetLastError (hab));
#endif
  PrfWriteProfileString (HINI_SYSTEMPROFILE,szAppName,KEY_TERMINATION,";");

  PrfWriteProfileString (HINI_SYSTEMPROFILE,szAppName,KEY_TIMEOUT,"45;");
  /*
  ** Write data for this port in ini file with old format.
  */
  if (!PrfWriteProfileString(HINI_SYSTEMPROFILE,
                           APPNAME_PM_SPOOLER_PORT,
                           pszPortName,
                           "COMi Spooler;"))
#if DEBUG > 0
    {
    rc = WinGetLastError(hab);
    sprintf(szMessage,"Install failed - setting old format key - %s, rc = %04X",pszPortName,rc);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
    return(rc);
    }
#else
    rc = WinGetLastError(hab);
#endif
  return(NO_ERROR);
  }

/****************************************************************************
 *
 * FUNCTION NAME = SplPdGetPortIcon
 *
 * DESCRIPTION   = Return Resource ID of icon representing this port.
 *                 Note: only one icon will represent all ports supported
 *                       by a port driver.
 *
 * INPUT         = hab         - Anchor block handle
 *                 idIcon      - gets Resource ID of icon bit map
 *
 * OUTPUT        =
 *
 * RETURN-NORMAL = TRUE
 *
 * RETURN-ERROR  = FALSE - if unable to return icon Resource ID
 *
 ****************************************************************************/

BOOL APIENTRY SPLPDGETPORTICON(HAB hab,PULONG idIcon)
  {
  /*
  ** Check for our global port icon ID (is always set)
  */
#if DEBUG > 3
  Spl_MessageBox(HWND_DESKTOP,"Getting ICON");
#endif
  if (idIcon)
    *idIcon = SERIAL_ICON;
  return(TRUE);
  }

/****************************************************************************
 *
 * FUNCTION NAME = SplPdQueryPort
 *
 * DESCRIPTION   = Returns textual data that describes the port configuration.
 *
 * INPUT         = hab         - Anchor block handle
 *                 pszPortName - name of port to get configuration for
 *                 pBufIn      - pointer to buffer of returned data structures
 *                 cbBuf       - Size of pBufIn in bytes
 *                 cItems      - Count of number of strings of descriptions
 *                               returned
 *
 * OUTPUT        =
 *
 * RETURN-NORMAL = 0
 *
 * RETURN-ERROR  = ERROR_INSUFFICIENT_BUFFER - if buffer is too small
 *                 ERROR_INVALID_PARAMETER - if bad port name given
 *
 ****************************************************************************/

APIRET APIENTRY SPLPDQUERYPORT(HAB hab,PSZ pszPortName,PVOID pBufIn,ULONG cbBuf,PULONG cItems)
  {
#if DEBUG > 3
 sprintf(szMessage,"Querying %s",pszPortName);
 Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
  /*
  ** check that pointer to all the return variables is not null
  */
  if (!cItems)
    {
#if DEBUG > 0
    sprintf(szMessage,"Query failed - no items requested - %s",pszPortName);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }
  /*
  ** if pBuf or cbBuf is NULL - it is an error.
  */
  if (!pBufIn || !cbBuf)
    {
#if DEBUG > 0
    sprintf(szMessage,"Query failed - bad destination parameters - %s",pszPortName);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }
  if (strlen(DRIVER_DESC) <= cbBuf)
    {
    *cItems = 1;
    strcpy(pBufIn,DRIVER_DESC);
    }
  else
    {
#if DEBUG > 0
    sprintf(szMessage,"Query failed - not enough buffer space for description - %u",cbBuf);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INSUFFICIENT_BUFFER);
    }
  return(NO_ERROR);
  }

/****************************************************************************
 *
 * FUNCTION NAME = SplPdSetPort
 *
 * DESCRIPTION   = Display a dialog to allow the user to browse and modify
 *                 port configurations.
 *
 * INPUT         = hab         - Anchor block handle
 *                 pszPortName - name of port to configure
 *                 flModified  - Flag to indicate that the configuration
 *                               has been modified.(TRUE if modified).
 *
 * OUTPUT        =
 *
 * RETURN-NORMAL = 0
 *
 * RETURN-ERROR  = ERROR_INVALID_PARAMETER - if bad portname given
 *
 ****************************************************************************/

APIRET EXPENTRY SPLPDSETPORT(HAB hab,PSZ pszPortName,PULONG flModified)
  {
  char szAppName[STR_LEN_PORTNAME];
  CHAR chPortDriver[STR_LEN_PORTNAME];
  APIRET rc;
  HMODULE hMod;
  PFN pfnProcess;
  ULONG ulDataSize;
  BAUDST stBaudRates;
  HFILE hCom;
  ULONG ulAction;
  PORTINIT stPortInit;

#if DEBUG > 3
 sprintf(szMessage,"Setting %s",pszPortName);
 Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
  *flModified = FALSE;
  /*
  ** Check if either parameter is NULL. This is an error.
  */
  if ((pszPortName == NULL ) || (flModified == NULL))
    {
#if DEBUG > 0
    sprintf(szMessage,"Setup failed - bad port name - %s",pszPortName);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }

  stCOMiCFG.ulSpare = 115200; // set default baud rate in case port is not yet installed
  /*
  **  Get baud capabilities (in case 16650 UART is installed)
  */
  if (DosOpen(pszPortName,&hCom,&ulAction,0L,0L,0x0001,0x21c2,0L) == NO_ERROR)
    {
    if (GetBaudRates(0L,hCom,&stBaudRates) == NO_ERROR)
      stCOMiCFG.ulSpare = stBaudRates.stHighestBaud.lBaudRate;
    DosClose(hCom);
    }
  /*
  ** Make Application name string( "PM_PortName" ).
  */
  strcpy (szAppName, APPNAME_LEAD_STR);
  strcat (szAppName, pszPortName);

  /*
  ** Check if this port is a COMspool serial port.
  */
  if (!(PrfQueryProfileString (HINI_SYSTEMPROFILE,szAppName,
                                KEY_PORTDRIVER, NULL, chPortDriver,
                                STR_LEN_PORTNAME)))
    {
#if DEBUG > 0
    sprintf(szMessage,"Setup failed - getting port driver name - %s",chPortDriver);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }
  if (strcmp (chPortDriver, DEF_PORTDRIVER))
    {
#if DEBUG > 0
    sprintf(szMessage,"Setup failed - bad port driver - %s <> %s",chPortDriver,DEF_PORTDRIVER);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }

//  if ((PrfQueryProfileString (HINI_USERPROFILE,"COMi",
//                        "Configuration",NULL,szConfigLibPath,
//                        (CCHMAXPATH - 1))) == 0)

  if (szConfigLibPath[0] == 0)
    {
#if DEBUG > 0
    Spl_MessageBox(HWND_DESKTOP,"Can't get Configuration DLL Path");
#endif
    return(NO_ERROR);
    }
  else
    {
    if ((rc = DosLoadModule(0,0,szConfigLibPath,&hMod)) == NO_ERROR)
      {
      if (DosQueryProcAddr(hMod,0,"SpoolerSetupDialog",&pfnProcess) == NO_ERROR)
        {
        ulDataSize = sizeof(PORTINIT);
        if (PrfQueryProfileData(HINI_SYSTEMPROFILE,szAppName,"PortSetup",&stPortInit,&ulDataSize))
          {
          stCOMiCFG.pszPortName = pszPortName;
          stCOMiCFG.pst = &stPortInit.stComDCB;
          stCOMiCFG.pstSpare = &stPortInit.stLine;
          stCOMiCFG.ulValue = stPortInit.ulBaudRate;
          stCOMiCFG.bSpoolerConfig = TRUE;
          if (pfnProcess(HWND_DESKTOP,&stCOMiCFG))
            {
            stPortInit.ulBaudRate = stCOMiCFG.ulValue;
            PrfWriteProfileData(HINI_SYSTEMPROFILE,
                                szAppName,
                                "PortSetup",
                                &stPortInit,
                                sizeof(PORTINIT));
            *flModified = TRUE;
            }
          }
#if DEBUG > 0
        else
          Spl_MessageBox(HWND_DESKTOP,"Could not get current port initialization parameters");
#endif
        }
#if DEBUG > 0
      else
        Spl_MessageBox(HWND_DESKTOP,"Could not load SpoolerSetupDialog function address");
#endif
      DosFreeModule(hMod);
      }
#if DEBUG > 0
    else
      {
      sprintf(szMessage,"Could not load %s - rc = %04X",szConfigLibPath,rc);
      Spl_MessageBox(HWND_DESKTOP,szMessage);
      }
#endif
    }

  return(NO_ERROR);
  }

/****************************************************************************
 *
 * FUNCTION NAME = SplPdRemovePort
 *
 * DESCRIPTION   = Tells port driver the name of a port that needs to be removed.
 *                 Port driver should remove its data from the INI file.
 *
 * INPUT         = hab         - Anchor block handle
 *                 pszPortName - name of port to be removed
 *
 * OUTPUT        =
 *
 * RETURN-NORMAL = 0
 *
 * RETURN-ERROR  = ERROR_INVALID_PARAMETER - if bad port name given
 *
 ****************************************************************************/

APIRET APIENTRY SPLPDREMOVEPORT(HAB hab,PSZ pszPortName)
  {
  char szAppName[STR_LEN_PORTNAME];
  CHAR chPortDriver[STR_LEN_PORTNAME];

#if DEBUG > 3
 sprintf(szMessage,"Removing %s",pszPortName);
 Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
  /*
  ** Check if port name string is NULL. This is an error.
  */
  if (!pszPortName)
    {
#if DEBUG > 0
    sprintf(szMessage,"Remove failed - bad port name - %s",pszPortName);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }
  /*
  ** Make Application name string.
  */
  strcpy (szAppName, APPNAME_LEAD_STR);
  strcat (szAppName, pszPortName);

  /*
  ** Check if this port is a serial port.
  */
  if (!(PrfQueryProfileString (HINI_SYSTEMPROFILE, szAppName,
                               KEY_PORTDRIVER, NULL, chPortDriver,
                               STR_LEN_PORTNAME)))
    {
#if DEBUG > 0
    sprintf(szMessage,"Remove failed - getting port driver name - %s",chPortDriver);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }
  if (strcmp (chPortDriver, DEF_PORTDRIVER))
    {
#if DEBUG > 0
    sprintf(szMessage,"Remove failed - bad port driver - %s",chPortDriver);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }
  /*
  ** We found port to be removed.
  ** Remove it from new format "PM_portname"
  */
  PrfWriteProfileString(HINI_SYSTEMPROFILE, szAppName, NULL, NULL);

  /*
  ** remove this port from old format.
  */
  PrfWriteProfileString(HINI_SYSTEMPROFILE,APPNAME_PM_SPOOLER_PORT,pszPortName,NULL);
  return(NO_ERROR);
  }

/****************************************************************************
 *
 * FUNCTION NAME = SplPdTermPort
 *
 * DESCRIPTION   = Terminate port on behalf of the spooler
 *
 * INPUT         = hFile       - File handle to port
 *                 pszPortName - name of port whose job is completing
 *
 * OUTPUT        = None currently
 *
 * RETURN-NORMAL = 0
 *
 * RETURN-ERROR  = ERROR_INVALID_PARAMETER - if bad port name given
 *
 * NOTE: Currently there is nothing done when terminating a print
 *       job sent to a communications port.
 *
 ****************************************************************************/
APIRET APIENTRY SPLPDTERMPORT(HFILE hFile,PSZ pszPortName)
  {
  CHAR szAppName[STR_LEN_PORTNAME];
  PCH  chPortDriver[STR_LEN_PORTNAME];

#if DEBUG > 3
 sprintf(szMessage,"Terminating %s",pszPortName);
 Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
  /*
  ** Check if port name string is NULL. This is an error.
  */
  if (!pszPortName)
    {
#if DEBUG > 0
    sprintf(szMessage,"Terminate failed - bad port name - %s",pszPortName);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }

  strcpy (szAppName, APPNAME_LEAD_STR);
  strcat (szAppName, pszPortName);

  /*
  ** Check if this port is a COMspool serial port.
  */
  if (!(PrfQueryProfileString (HINI_SYSTEMPROFILE, szAppName,
                                  KEY_PORTDRIVER, NULL, chPortDriver, 64)))
    {
#if DEBUG > 0
    sprintf(szMessage,"Terminate failed - getting driver name - %s",chPortDriver);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }
  if (strcmp ((PSZ)chPortDriver, DEF_PORTDRIVER))
    {
#if DEBUG > 0
    sprintf(szMessage,"Terminate failed - bad port driver - %s",chPortDriver);
    Spl_MessageBox(HWND_DESKTOP,szMessage);
#endif
    return(ERROR_INVALID_PARAMETER);
    }

  FlushComBuffer(0,hFile,INPUT);
  FlushComBuffer(0,hFile,OUTPUT);

  /*
  ** We do not have to take any action - return NO_ERROR
  */
  return(NO_ERROR);
  }

/****************************************************************************
 *
 * FUNCTION NAME = CopyPortInfo
 *
 * DESCRIPTION   = Copy port information into buffer
 *
 * INPUT         = hab     - anchor block handle
 *                 hModule - this port driver's module handle
 *                 pBuf    - buffer to get PORTNAMES structures
 *                 ulReturned - number of ports to return
 *
 * OUTPUT        = pBuf is updated
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

VOID  CopyPortInfo(HAB hab,PCH pBuf,ULONG ulCount)
  {
  PPORTNAMES pPortNames;
  ULONG ulBeginStruct;
  ULONG *pPointer;
  ULONG ulBeginText;
  int iIndex;
  char *pchDesc;
  char *pDeviceName;
  char pszPortDesc[STR_LEN_PORTDESC];

  ulBeginText = ulCount * sizeof (PORTNAMES);
  ulBeginStruct = 0;
  pPointer = (ULONG *)pBuf;

  strcpy(pszPortDesc,DEVICE_DESC);
  pchDesc = &pszPortDesc[strlen(pszPortDesc)];

  pDeviceName = aszDeviceList;
  for (iIndex = 0;iIndex < ulCount;iIndex++)
    {
    pPortNames = (PPORTNAMES)(pBuf + ulBeginStruct);
    ulBeginStruct += sizeof (PORTNAMES);
    pPortNames->pszPortName = pBuf + ulBeginText;
    *pPointer = (ULONG)pPortNames->pszPortName;
    pPointer++;
    /*
    ** copy port name in the structure
    */
    strcpy(pPortNames->pszPortName,pDeviceName);
    memset(pchDesc,0,4);

    sprintf(pchDesc," %s",&pDeviceName[3]);
    pDeviceName += (strlen(pDeviceName) + 1);

    ulBeginText += (strlen(pPortNames->pszPortName) + 1);
    /*
    ** copy port description to the structure
    */
    pPortNames->pszPortDesc = pBuf + ulBeginText;
    *pPointer = (ULONG)pPortNames->pszPortDesc;
    pPointer++;
    strcpy(pPortNames->pszPortDesc,pszPortDesc);
    ulBeginText += strlen (pPortNames->pszPortDesc) + 1;
    }
  }

