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
 * VERSION = V2.0
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



#define  LINT_ARGS                     /* argument checking enabled          */

#define  INCL_DOS
#define  INCL_GPI
#undef   INCL_GPI
#define  INCL_DEV
#define  INCL_DOSMEMMGR                /* Include standard OS/2 support      */
#define  INCL_DOSMODULEMGR             /* For DosLoadModule                  */
#define  INCL_DOSPROCESS
#define  INCL_GPILCIDS
#define  INCL_WINCOMMON                /* Include Window Management support  */
#define  INCL_WINDOWMGR
#define  INCL_WINSWITCHLIST
#define  INCL_WINPROGRAMLIST
#define  INCL_WINMENUS
#define  INCL_WINWINDOWMGR
#define  INCL_WINMESSAGEMGR
#define  INCL_WINDIALOGS
#define  INCL_WINSTATICS
#define  INCL_WINLISTBOXES
#define  INCL_WINMENUS
#define  INCL_WINSYS
#define  INCL_WINFRAMEMGR
#define  INCL_INCLWINACCELERATORS
#define  INCL_WINPOINTERS
#define  INCL_WINERRORS
#define  INCL_WINSHELLDATA

#define  INCL_WINTYPES
#define  INCL_WINACCELERATORS
#define  INCL_WINBUTTONS
#define  INCL_WINENTRYFIELDS
#define  INCL_WINRECTANGLES
#define  INCL_WINTIMER
#define  INCL_WINSCROLLBARS
#define  INCL_WINHEAP
#define  INCL_SHLERRORS
#define  INCL_WININPUT
#define  INCL_WINHELP
#define  INCL_WINSTDSPIN

#define  INCL_SPL
#define  INCL_SPLP
#define  INCL_SPLERRORS
#define  INCL_SHLERRORS
#define  INCL_DOSERRORS
#define  INCL_WINHOOKS

#define INCL_32
//int acrtused=1;                      /* Define variable to say this is a DLL */

#include    <os2.h>

#include    <stdlib.h>
#include    <string.h>

#include    "serial.h"
#include    "port.h"

/*
** structure for setting/getting communications port settings
** These map closely to DosDevIOCtl Category 1 structures
*/
typedef                 struct
{
  USHORT                  BaudRate;
  UCHAR                   DataParityStop[3];
  struct
  {
    USHORT                  WriteTimeout;
    USHORT                  ReadTimeout;
    UCHAR                   Flags1;
    UCHAR                   Flags2;
    UCHAR                   Flags3;
    UCHAR                   ErrorReplacementCharacter;
    UCHAR                   BreakReplacementCharacter;
    UCHAR                   XONCharacter;
    UCHAR                   XOFFCharacter;
  } DeviceCtlBlk;

} COMMINFO;

/*
** If port driver is not defined in INI file yet
**   assume it exists in the boot drive's \OS2\DLL directory
*/
CHAR szDefaultPortDrvPath[] = "?:\\OS2\\DLL\\SERIAL.PDR";


/*
** Below definition of PORTNAMES structure should be defined in
** common header file pmspl.h.
*/
typedef struct _PORTNAMES
{
   PSZ pszPortName;         /* -> name of port(ie "LPT1)                    */
   PSZ pszPortDesc;         /* -> description of port(ie "Parallel Port 1") */
} PORTNAMES, *PPORTNAMES;


/*
** We want to avoid automatically loading the help manager(HELPMGR.DLL),
**   since this takes up lots of memory.
** Do this by only linking to the HELPMGR if user selects help item.
** We replace the WinxxxxHelpInstance calls with our local versions.
** These versions use DosLoadModule() and DosQueryProcAddr() to
**   call the "real" help manager functions.
** The below function pointers, prototypes and variables are used
**   to this end.
*/

BOOL APIENTRY CALLAssociateHelpInstance (HWND hwndHelpInstance, HWND hwndApp);
BOOL APIENTRY CALLDestroyHelpInstance(HWND hwndHelpInstance);
HWND APIENTRY CALLCreateHelpInstance(HAB hab,PHELPINIT phinitHMInitStructure);
HWND APIENTRY CALLQueryHelpInstance(HWND hwndApp);

BOOL (* APIENTRY pfnWinAssociateHelpInstance)(HWND, HWND);
BOOL (* APIENTRY pfnWinCreateHelpInstance)(HAB, PHELPINIT);
BOOL (* APIENTRY pfnWinDestroyHelpInstance)(HWND);
BOOL (* APIENTRY pfnWinQueryHelpInstance)(HWND);

VOID EXPENTRY InitializeHelp(VOID);
BOOL EXPENTRY SetHelpStubHook(VOID);
VOID EXPENTRY ReleaseHelpStubHook(VOID);
INT  EXPENTRY HelpStubHook( HAB AppHAB, USHORT Context, USHORT IdTopic,
                            USHORT IdSubTopic, PRECTL RectLPtr );

/*
** Global handle for helpmgr module, so it is only loaded once
*/
HMODULE  hvHelpmgrModule;

HWND hwndHelp ;
BOOL HelpStubHookIsSet;        /* for help */
BOOL HelpAlreadyInitialized;   /* for help */


/*
** HELPINIT -- help manager initialization structure
*/
static HELPINIT hmiHelpData = {
    sizeof(HELPINIT),
    0L,
    (PSZ)     NULL,
    (PHELPTABLE) NULL,
    (HMODULE) NULL,
    (HMODULE) NULL,
    (USHORT)  NULL,
    (USHORT)  NULL,
    (PSZ)     NULL,
    CMIC_HIDE_PANEL_ID,
    (PSZ)     PRT_HELPFILE_NAME
};

/*
** Local Functions
*/

ULONG   CalcBufLength ( HAB hab, HMODULE hModule );
ULONG   CalcStructLength ( HAB hab, HMODULE hModule, USHORT usID );
ULONG   NumPortsCanFit ( HAB hab, HMODULE hModule, ULONG cbBuf );
VOID    CopyNPorts ( HAB hab, HMODULE hModule, PCH pBuf, ULONG ulReturned );

VOID    CopyStruct ( HAB hab, HMODULE hModule, USHORT usID, PCH pBuf,
                     PULONG pulBeginStruct, PULONG pulBeginText );
BOOL    GetPortDescription ( HAB hab, HMODULE hModule, PSZ pszPortName,
                             PSZ pszPortDesc );
ULONG   OpenSerialPortDlg ( HAB hab, HMODULE hModule, PSZ pszPortName,
                            PSZ pszAppName );

MRESULT EXPENTRY CommDlg( HWND hDlg, USHORT msg, MPARAM mp1, MPARAM mp2 );
BOOL    InitCommDialogBox( HWND hDlg, PSERIALDATA pSerialData );
VOID    GetDialogValues(HWND hDlg, PSZ pszSaveCommSetting);
VOID    SetDialogValues(HWND hDlg, PSZ pszCommSetting);

BOOL    SavePortSettings(PSERIALDATA pSerialData);
BOOL    GetPortSettings(PSERIALDATA pSerialData);
VOID    GetPortDefaultSettings(PSZ pszSaveCommSetting);
VOID    RemoveLeadTrailBlanks (PCH pTarget, PCH pSource);

BOOL    InitializeCommPort(HFILE fh, PSZ pszLogAddress);
PSZ     AsciiToBin (PSZ pszString, USHORT usDef, PUSHORT pusOut);
VOID    DE (PCH str);
USHORT  DisplayError (HWND hwndOwner, HMODULE hModule,
                      USHORT  usStringID, USHORT  usWinStyle );


/****************************************************************************
 *
 * FUNCTION NAME = SplPdEnumPort
 *
 * DESCRIPTION   = Return ports supported by this port driver
 *                 Currently this will return those ports this port
 *                  driver supports by default.
 *                 Future enhancement might be to also return any
 *                  ports that have been added that now use this
 *                  port driver.
 *
 * INPUT         = hab - anchor block handle
 *                 pBuf - buffer to get enumerated PORTNAMES structures
 *                 cbBuf - size(in bytes) of pBuf passed in
 *
 * OUTPUT        = *pulReturned - number of PORTNAMES structures stored in pBuf
 *                 *pulTotal    - total ports supported by this port driver
 *                 *pcbRequired - size(in bytes) of buffer needed to store
 *                                all enumerated PORTNAMES entries.
 *                 pBuf - gets an array(number elements is *pulReturned) of
 *                        PORTNAMES structures.
 *                        Each psz in PORTNAMES structure points to a string
 *                        copied into the end of pBuf.
 *
 *                 typedef struct _PORTNAMES {
 *                         PSZ pszPortName;  // Name of port, example: LPT1
 *                         PSZ pszPortDesc;  // Port description
 *                 } PORTNAMES;
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

APIRET APIENTRY SplPdEnumPort ( HAB hab,
                                PVOID pBuf,
                                ULONG cbBuf,
                                PULONG pulReturned,
                                PULONG pulTotal,
                                PULONG pcbRequired )

{
   HMODULE hModule;
   ULONG   ulBootDrive;
   ULONG   rcLoadMod;
   CHAR    szPathName[260];    /* will contain full path to this port driver */

      /*
      ** ensure pointers not null
      */
   if (!pulReturned ||
       !pulTotal ||
       !pcbRequired)
   {
      return(ERROR_INVALID_PARAMETER);
   }

      /*
      ** if buffer length is supplied then there should be pBuf
      */
   if (!pBuf && cbBuf)
   {
      return(ERROR_INVALID_PARAMETER);
   }

      /*
      ** We need our module handle.
      ** Easiest way to do this is to find the path to our port driver
      **  from the system INI file.
      ** If not found in the INI file
      **  assume it is in the boot drive's \OS2\DLL directory
      */

      /* change ? in szDefaultPortDrvPath to boot drive */
   DosQuerySysInfo (QSV_BOOT_DRIVE, QSV_BOOT_DRIVE, &ulBootDrive,
                    sizeof (ULONG));
   szDefaultPortDrvPath[0] = (CHAR)(ulBootDrive + 'A' - 1);

   PrfQueryProfileString (HINI_SYSTEMPROFILE,
                          "PM_PORT_DRIVER",
                          "SERIAL",
                          szDefaultPortDrvPath,
                          szPathName,
                          256 );

      /*
      ** get module handle for our dll
      */
   rcLoadMod = DosLoadModule (NULL, 0, szPathName, &hModule);

      /*
      ** check if cbBuf is 0 - then return number of ports in pulTotal
      ** and number of bytes required in pcbRequired
      */
   if (cbBuf == 0L)
   {
      *pulReturned = 0;
      *pcbRequired = CalcBufLength (hab, hModule);
      *pulTotal = 4;                /* Currently support COM1 COM2 COM3 COM4 */
      if (!rcLoadMod)
        DosFreeModule (hModule);

           /*
           ** NOTE: early version of the print object checked for
           **       ERROR_MORE_DATA instead of ERROR_INSUFFICIENT_BUFFER
           **       For this reason we return ERROR_MORE_DATA here.
           */
        return(ERROR_MORE_DATA);
   }

      /*
      ** check number of ports info we can fit in supplied buffer
      */
   *pulTotal    = 4;                /* Currently support COM1 COM2 COM3 COM4 */
   *pcbRequired = CalcBufLength (hab, hModule);
   *pulReturned = NumPortsCanFit (hab, hModule, cbBuf);

      /*
      ** return error if we can not fit one port.
      */
   if (!(*pulReturned))
   {
      if (!rcLoadMod)
         DosFreeModule (hModule);
      return(ERROR_INSUFFICIENT_BUFFER);
   }

      /*
      ** copy all the ports which we can store in the pBuf
      */
   CopyNPorts (hab, hModule, (PCH)pBuf, *pulReturned);

      /*
      ** Free the module - we do not need it any more.
      */
   if (!rcLoadMod)
     DosFreeModule (hModule);

      /*
      ** copy all the ports which we can store in the pBuf
      */
   if (*pulReturned < *pulTotal)
   {
      return(ERROR_MORE_DATA);
   }

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

APIRET APIENTRY SplPdInitPort ( HFILE hFile,
                                PSZ pszPortName )
{
    USHORT usParamPacket= 0;
    USHORT usDataPacket = 0;
    UCHAR  bInfRetry;
    CHAR   chBuf[STR_LEN_PORTNAME];
    CHAR   chInitVal[STR_LEN_PORTNAME];
    PCH    pchPortDriver = chInitVal;

      /*
      ** Check if port name string is NULL. This is an error.
      */
   if (!pszPortName)
   {
      return(ERROR_INVALID_PARAMETER);
   }

      /*
      ** Make Application name string( "PM_PortName" )
      */
   strcpy (chBuf, APPNAME_LEAD_STR);
   strcat (chBuf, pszPortName);

      /*
      ** Check if this port is a serial port.
      ** (See if port driver for this port is "SERIAL")
      */
   if (!(PrfQueryProfileString (HINI_SYSTEMPROFILE, chBuf,
                                KEY_PORTDRIVER, NULL, pchPortDriver,
                                STR_LEN_PORTNAME)))
   {
      return(ERROR_INVALID_PARAMETER);
   }

   if (strcmp (pchPortDriver, DEF_PORTDRIVER))
   {
      return(ERROR_INVALID_PARAMETER);
   }

      /*
      ** Check if this port is installed.
      */
   if (!(PrfQueryProfileString (HINI_SYSTEMPROFILE, chBuf,
                                KEY_INITIALIZATION, NULL, chInitVal,
                                STR_LEN_PORTNAME)))
   {
      return(ERROR_INVALID_PARAMETER);
   }

      /*
      ** Initialize this serial port.
      */
   InitializeCommPort(hFile,pszPortName);

   return(NO_ERROR);

   hFile;
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
 *                          still allow the port to use this port driver).
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

APIRET APIENTRY SplPdInstallPort ( HAB hab,
                                   PSZ pszPortName )
{
   CHAR    chBuf[STR_LEN_PORTNAME];
   CHAR    chPortDesc[STR_LEN_PORTDESC];
   ULONG   ulBootDrive;
   HMODULE hModule;
   CHAR    szPathName[260];    /* will contain full path to this port driver */

      /*
      ** Check if port name string is NULL. This is an error.
      */
   if (!pszPortName)
   {
      return(ERROR_INVALID_PARAMETER);
   }
      /*
      ** We need our module handle.
      ** Easiest way to do this is to find the path to our port driver
      **  from the system INI file.
      ** If not found in the INI file
      **  assume it is in the boot drive's \OS2\DLL directory
      */

   /* change ? in szDefaultPortDrvPath to boot drive */
   DosQuerySysInfo (QSV_BOOT_DRIVE, QSV_BOOT_DRIVE, &ulBootDrive,
                    sizeof (ULONG));
   szDefaultPortDrvPath[0] = (CHAR)(ulBootDrive + 'A' - 1);

   PrfQueryProfileString (HINI_SYSTEMPROFILE,
                          "PM_PORT_DRIVER",
                          "SERIAL",
                          szDefaultPortDrvPath,
                          szPathName,
                          256 );

   hModule = 0L ;                             /* Init module handle to null */

      /*
      ** get module handle for our dll
      */
   DosLoadModule (NULL, 0, szPathName, &hModule);

      /*
      ** Check if we have description for port
      */
   if (!GetPortDescription (hab, hModule, pszPortName, chPortDesc))
   {
      /*
      ** Port description not found, use port name
      */
      strcpy( chPortDesc, pszPortName );
   }

      /*
      ** Free the module
      */
   DosFreeModule (hModule);

      /*
      ** Make Application name string.
      */
   strcpy (chBuf, APPNAME_LEAD_STR);
   strcat (chBuf, pszPortName);

      /*
      ** Write data for this port in ini file with new format.
      */
   if (!PrfWriteProfileString (HINI_SYSTEMPROFILE,
                               chBuf,
                               KEY_DESCRIPTION,
                               chPortDesc))
   {
      return (WinGetLastError (hab));
   }

   if (!PrfWriteProfileString (HINI_SYSTEMPROFILE,
                               chBuf,
                               KEY_INITIALIZATION,
                               DEF_INITIALIZATION))
   {
      return (WinGetLastError (hab));
   }

   if (!PrfWriteProfileString (HINI_SYSTEMPROFILE,
                               chBuf,
                               KEY_TERMINATION,
                               DEF_TERMINATION))
   {
      return (WinGetLastError (hab));
   }

   if (!PrfWriteProfileString (HINI_SYSTEMPROFILE,
                               chBuf,
                               KEY_PORTDRIVER,
                               DEF_PORTDRIVER))
   {
      return (WinGetLastError (hab));
   }

   if (!PrfWriteProfileString (HINI_SYSTEMPROFILE,
                               chBuf,
                               KEY_TIMEOUT,
                               DEF_TIMEOUT))
   {
      return (WinGetLastError (hab));
   }

      /*
      ** Write data for this port in ini file with old format.
      */
   if (!PrfWriteProfileString (HINI_SYSTEMPROFILE,
                               APPNAME_PM_SPOOLER_PORT,
                               pszPortName,
                               DEF_INITIALIZATION))
   {
      return (WinGetLastError (hab));
   }
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

BOOL   APIENTRY SplPdGetPortIcon ( HAB hab,
                                   PULONG idIcon )
{
      /*
      ** Check for our global port icon ID(is always set)
      */
   if (idIcon)
   {
      *idIcon = SERIAL_ICON;
   }
   return(TRUE);

   hab;
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

APIRET APIENTRY SplPdQueryPort ( HAB hab,
                                 PSZ pszPortName,
                                 PVOID pBufIn,
                                 ULONG cbBuf,
                                 PULONG cItems )
{
   HMODULE hModule;
   CHAR    chString[STR_LEN_DESC];
   USHORT  usNumLines;
   USHORT  usLineID;
   USHORT  usStrLength;
   ULONG   ulBootDrive;
   PCH     pBuf = pBufIn;
   CHAR    szPathName[260];    /* will contain full path to this port driver */

      /*
      ** check pointer to all the return variables is not null
      */
   if (!cItems)
   {
      return(ERROR_INVALID_PARAMETER);
   }

      /*
      ** if pBuf or cbBuf is NULL - it is an error.
      */
   if (!pBuf || !cbBuf)
   {
      return(ERROR_INVALID_PARAMETER);
   }

      /*
      ** We need our module handle.
      ** Easiest way to do this is to find the path to our port driver
      **  from the system INI file.
      ** If not found in the INI file
      **  assume it is in the boot drive's \OS2\DLL directory
      */

   /* change ? in szDefaultPortDrvPath to boot drive */
   DosQuerySysInfo (QSV_BOOT_DRIVE, QSV_BOOT_DRIVE, &ulBootDrive,
                    sizeof (ULONG));
   szDefaultPortDrvPath[0] = (CHAR)(ulBootDrive + 'A' - 1);

   PrfQueryProfileString (HINI_SYSTEMPROFILE,
                          "PM_PORT_DRIVER",
                          "SERIAL",
                          szDefaultPortDrvPath,
                          szPathName,
                          256 );

   hModule = 0L ;                              /* Init module handle to null */

      /*
      ** get module handle for our dll
      */
   DosLoadModule (NULL, 0, szPathName, &hModule);

   chString[0] = '\0' ;

      /*
      ** get number of lines.
      */
   WinLoadString(hab, hModule, (USHORT)ID_NUMBER_OF_DESC_LINES, STR_LEN_DESC,
                 chString);
   usNumLines = (USHORT)atoi (chString);
   usLineID = ID_FIRST_DESC_LINES;
   for (*cItems = 0; *cItems < usNumLines; *cItems++)
   {
      WinLoadString(hab, hModule, usLineID, STR_LEN_DESC, chString);
      if (cbBuf >= (usStrLength = (USHORT)(strlen (chString) + 1)))
      {
         strcpy (pBuf, chString);
         pBuf += usStrLength;
         cbBuf -= usStrLength;
      }
      else
      {
         DosFreeModule (hModule);
         return(ERROR_INSUFFICIENT_BUFFER);
      }
   }
   DosFreeModule (hModule);
   return(NO_ERROR);

   pszPortName;
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

APIRET APIENTRY SplPdSetPort ( HAB hab,
                               PSZ pszPortName,
                               PULONG flModified )
{
    CHAR    chBuf[STR_LEN_PORTNAME];
    CHAR    chPortDriver[STR_LEN_PORTNAME];
    ULONG   ulBootDrive;
    HMODULE hModule;
    CHAR    szPathName[260];   /* will contain full path to this port driver */

      /*
      ** Check if port name string is NULL. This is an error.
      */
   if (!pszPortName || !flModified)
   {
      return(ERROR_INVALID_PARAMETER);
   }

      /*
      ** Make Application name string( "PM_PortName" ).
      */
   strcpy (chBuf, APPNAME_LEAD_STR);
   strcat (chBuf, pszPortName);

      /*
      ** Check if this port is a serial port.
      */
   if (!(PrfQueryProfileString (HINI_SYSTEMPROFILE, chBuf,
                                KEY_PORTDRIVER, NULL, chPortDriver,
                                STR_LEN_PORTNAME)))
   {
      return(ERROR_INVALID_PARAMETER);
   }

   if (strcmp (chPortDriver, DEF_PORTDRIVER))
   {
      return(ERROR_INVALID_PARAMETER);
   }

      /*
      ** We need our module handle.
      ** Easiest way to do this is to find the path to our port driver
      **  from the system INI file.
      ** If not found in the INI file
      **  assume it is in the boot drive's \OS2\DLL directory
      */

      /* change ? in szDefaultPortDrvPath to boot drive */
   DosQuerySysInfo (QSV_BOOT_DRIVE, QSV_BOOT_DRIVE, &ulBootDrive,
                    sizeof (ULONG));
   szDefaultPortDrvPath[0] = (CHAR)(ulBootDrive + 'A' - 1);

   PrfQueryProfileString (HINI_SYSTEMPROFILE,
                          "PM_PORT_DRIVER",
                          "SERIAL",
                          szDefaultPortDrvPath,
                          szPathName,
                          256 );

   hModule = 0L ;                              /* Init module handle to null */

      /*
      ** get module handle for our dll
      */
   DosLoadModule (NULL, 0, szPathName, &hModule);

      /*
      ** Load the dialog for user to change.
      */
   *flModified = OpenSerialPortDlg (hab, hModule, pszPortName, chBuf);

      /*
      ** free the module
      */
   DosFreeModule (hModule);
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

APIRET APIENTRY SplPdRemovePort ( HAB hab,
                                  PSZ pszPortName )
{
    CHAR chBuf[STR_LEN_PORTNAME];
    CHAR chPortDriver[STR_LEN_PORTNAME];

   if (!pszPortName)
      /*
      ** Check if port name string is NULL. This is an error.
      */
   {
      return(ERROR_INVALID_PARAMETER);
   }

      /*
      ** Make Application name string.
      */
   strcpy (chBuf, APPNAME_LEAD_STR);
   strcat (chBuf, pszPortName);

      /*
      ** Check if this port is a serial port.
      */
   if (!(PrfQueryProfileString (HINI_SYSTEMPROFILE, chBuf,
                                KEY_PORTDRIVER, NULL, chPortDriver,
                                STR_LEN_PORTNAME)))
   {
      return(ERROR_INVALID_PARAMETER);
   }

   if (strcmp (chPortDriver, DEF_PORTDRIVER))
   {
      return(ERROR_INVALID_PARAMETER);
   }

      /*
      ** We found port to be removed.
      ** Remove it from new format "PM_portname"
      */
   PrfWriteProfileString (HINI_SYSTEMPROFILE, chBuf, NULL, NULL);

      /*
      ** remove this port from old format.
      */
   PrfWriteProfileString (HINI_SYSTEMPROFILE,
                          APPNAME_PM_SPOOLER_PORT,
                          pszPortName,
                          NULL);
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

APIRET APIENTRY SplPdTermPort ( HFILE hFile,
                                PSZ pszPortName )
{
    CHAR chBuf[STR_LEN_PORTNAME];
    PCH  chPortDriver[STR_LEN_PORTNAME];

      /*
      ** We do not have to take any action. Return NO_ERROR
      */
   return(NO_ERROR);

#ifdef TERM_ACTION_NEEDED
      /*
      ** Check if port name string is NULL. This is an error.
      */
   if (!pszPortName)
   {
      return(ERROR_INVALID_PARAMETER);
   }

   strcpy (chBuf, APPNAME_LEAD_STR);
      /*
      ** Make Application name string.
      */
   strcat (chBuf, pszPortName);

      /*
      ** Check if this port is a serial port.
      */
   if (!(PrfQueryProfileString (HINI_SYSTEMPROFILE, chBuf,
                                  KEY_PORTDRIVER, NULL, chPortDriver, 64)))
   {
      return(ERROR_INVALID_PARAMETER);
   }

   if (strcmp ((PSZ)chPortDriver, DEF_PORTDRIVER))
   {
      return(ERROR_INVALID_PARAMETER);
   }

      /*
      ** We do not have to take any action - return NO_ERROR
      */
   return(NO_ERROR);

#endif

}

/****************************************************************************
 *
 * FUNCTION NAME = CalcBufLength
 *
 * DESCRIPTION   = Determine how big buffer is needed to store all PORTNAMES
 *                 structures
 *
 * INPUT         = hab - anchor block handle
 *                 hModule - this port driver's module handle
 *
 * OUTPUT        = length of buffer necessary to store all default port names
 *                 supported by this port driver.
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

ULONG CalcBufLength ( HAB hab,
                      HMODULE hModule )
{
   ULONG  cbRequired;
   USHORT usID;

   cbRequired = 0;

      /*
      ** calculate length required to fit all the port info.
      */
   for (usID = PORT_ID_FIRST; usID <= PORT_ID_LAST; usID += 2)
   {
      cbRequired += CalcStructLength (hab, hModule, usID);
   }

   return(cbRequired);
}

/****************************************************************************
 *
 * FUNCTION NAME = CalcStructLength
 *
 * DESCRIPTION   = Determine size of buffer needed to store PORTNAMES structure
 *                 for given string ID.
 *
 * INPUT         = hab     - anchor block handle
 *                 hModule - this port driver's module handle
 *                 usID    - string ID for port name
 *
 * OUTPUT        = length of buffer necessary to store this port name
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

ULONG CalcStructLength ( HAB hab,
                         HMODULE hModule,
                         USHORT usID )
{
   ULONG cbRequired;
   CHAR  chString[STR_LEN_PORTDESC];

   cbRequired = 0;

   WinLoadString(hab, hModule, usID, STR_LEN_PORTDESC, chString);
   cbRequired += strlen (chString) + 1;
   WinLoadString(hab, hModule, (USHORT)(usID + 1), STR_LEN_PORTDESC, chString);
   cbRequired += strlen (chString) + 1;
   cbRequired += sizeof (PORTNAMES);
   return(cbRequired);
}

/****************************************************************************
 *
 * FUNCTION NAME = NumPortsCanFit
 *
 * DESCRIPTION   = Determine how many ports can fit in buffer
 *
 * INPUT         = hab     - anchor block handle
 *                 hModule - this port driver's module handle
 *                 cbBuf   - size in bytes of buffer to hold PORTNAMES
 *
 * OUTPUT        = count of PORTNAMES structures that can fit in buffer
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

ULONG NumPortsCanFit ( HAB hab,
                       HMODULE hModule,
                       ULONG cbBuf )
{
   ULONG  cbRequired;
   USHORT usID;
   ULONG  ulNumPort;

   cbRequired = 0;
   ulNumPort = 0;

      /*
      ** calculate how many ports we can fit in buf.
      */
   for (usID = PORT_ID_FIRST; usID <= PORT_ID_LAST; usID += 2)
   {
      cbRequired += CalcStructLength (hab, hModule, usID);
      if (cbRequired > cbBuf)
      {
         return(ulNumPort);
      }
      ulNumPort++;
   }

   return(ulNumPort);
}

/****************************************************************************
 *
 * FUNCTION NAME = CopyNPorts
 *
 * DESCRIPTION   = Copy given number of ports into buffer
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

VOID  CopyNPorts ( HAB hab,
                   HMODULE hModule,
                   PCH pBuf,
                   ULONG ulReturned )
{
   USHORT usID;
   ULONG  ulBeginText;
   ULONG  ulBeginStruct;

   ulBeginText = ulReturned * sizeof (PORTNAMES);
   ulBeginStruct = 0;

   for (usID = PORT_ID_FIRST;
        usID <= PORT_ID_LAST && ulReturned;
        usID += 2, --ulReturned)
   {
      CopyStruct (hab, hModule, usID, pBuf, &ulBeginStruct, &ulBeginText);
   }
}

/****************************************************************************
 *
 * FUNCTION NAME = CopyStruct
 *
 * DESCRIPTION   = Copy single PORTNAMES structure to buffer
 *
 * INPUT         = hab     - anchor block handle
 *                 hModule - this port driver's module handle
 *                 usID    - string ID for port to return
 *                 pBuf    - buffer to get PORTNAMES structures
 *                 pulBeginStruct - offset from begin of pBuf to store next
 *                                  PORTNAMES
 *                 pulBeginText   - offset from pBuf to store next string
 *
 * OUTPUT        = pBuf is updated
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

VOID CopyStruct ( HAB hab,
                  HMODULE hModule,
                  USHORT usID,
                  PCH pBuf,
                  PULONG pulBeginStruct,
                  PULONG pulBeginText )
{
   PPORTNAMES pPortNames;

   pPortNames = (PPORTNAMES)(pBuf + *pulBeginStruct);
   *pulBeginStruct += sizeof (PORTNAMES);

      /*
      ** copy port name in the structure
      */
   pPortNames->pszPortName = pBuf + *pulBeginText;
   WinLoadString(hab, hModule, usID, STR_LEN_PORTDESC, pPortNames->pszPortName);
   *pulBeginText += strlen (pPortNames->pszPortName) + 1;

      /*
      ** copy port description to the structure
      */
   pPortNames->pszPortDesc = pBuf + *pulBeginText;
   WinLoadString(hab, hModule, usID, STR_LEN_PORTDESC, pPortNames->pszPortDesc);
   *pulBeginText += strlen (pPortNames->pszPortDesc) + 1;
}

/****************************************************************************
 *
 * FUNCTION NAME = GetPortDescription
 *
 * DESCRIPTION   = Get port description from our string resources.
 *
 * INPUT         = hab     - anchor block handle
 *                 hModule - this port driver's module handle
 *                 pszPortName - name of port to get description for
 *                 pszPortDesc - gets port description
 *
 * OUTPUT        = TRUE  - if portname description is found
 *                 FALSE - if not
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

BOOL GetPortDescription ( HAB hab,
                          HMODULE hModule,
                          PSZ pszPortName,
                          PSZ pszPortDesc )
{
   USHORT usID;
   CHAR   chBuf[STR_LEN_PORTDESC];

   for (usID = PORT_ID_FIRST; usID <= PORT_ID_LAST; usID += 2)
   {
      WinLoadString(hab, hModule, usID, STR_LEN_PORTDESC, chBuf);
      if (!strcmp (pszPortName, chBuf))
      {
         strcpy (pszPortDesc, chBuf);
         return(TRUE);
      }
   }
   return(FALSE);
}

/****************************************************************************
 *
 * FUNCTION NAME = OpenSerialPortDlg
 *
 * DESCRIPTION   = Display serial port settings dialog
 *
 * INPUT         = hab     - anchor block handle
 *                 hModule - this port driver's module handle
 *                 pszPortName - name of port to get description for
 *                 pszAppName  - INI Appname for port( "PM_Portname").
 *
 * OUTPUT        = TRUE  - if port settings changed
 *                 FALSE - if port settings not changed
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

ULONG OpenSerialPortDlg ( HAB hab,
                          HMODULE hModule,
                          PSZ pszPortName,
                          PSZ pszAppName )
{
   SERIALDATA SerialData;

   memset (&SerialData, 0, sizeof (SERIALDATA));
   SerialData.hAB = hab;
   SerialData.hModule = hModule;
   SerialData.pszPortName = pszPortName;
   SerialData.pszAppName = pszAppName;

   WinDlgBox  (HWND_DESKTOP,
               HWND_DESKTOP,
               (PFNWP)CommDlg,
               (HMODULE)hModule,
               IDD_PORTSERIAL,
               &SerialData);

   return SerialData.lfModified;
}

/****************************************************************************
 *
 * FUNCTION NAME = CommDlg
 *
 * DESCRIPTION   = Port settings dialog procedure
 *
 * INPUT         = hDlg: HWND
 *                 msg:  message
 *                 mp1:  message parameter
 *                 mp2:     "       "
 *
 * OUTPUT        =
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

MRESULT EXPENTRY CommDlg( HWND hDlg, USHORT msg, MPARAM mp1, MPARAM mp2 )
{
    PSERIALDATA pSerialData;
    ULONG       ulTimeOut;

       /*
       ** Procedure for COM port setup dialog
       **
       ** This allows the user to set default values for COM port printing.
       ** It does not set defaults for non-printing Apps or Apps that
       **  do not go through the print spooler.
       ** It is up to each of these other Apps to set the COM port up
       **  for their environment.
       */

    switch (msg) {

        case WM_INITDLG:
            pSerialData = (PSERIALDATA)mp2;
            WinSetWindowULong (hDlg, QWL_USER, (ULONG)pSerialData);

            InitCommDialogBox( hDlg, pSerialData);

            if (!GetPortSettings(pSerialData))
            {
                WinDismissDlg(hDlg, 0L);
                return(FALSE);
            }

            WinSendDlgItemMsg (hDlg, IDC_PSE_TIMEOUT,
                               SPBM_SETCURRENTVALUE,
                               MPFROMSHORT(pSerialData->usOrgTimeOut),
                               MPFROMSHORT(NULL));

            SetDialogValues(hDlg, &pSerialData->szSaveCommSetting[0]);

               /*
               ** Get settings back from dialog fields and store to
               ** allow verifying when changes occur
               */
            GetDialogValues(hDlg, &pSerialData->szOrgCommSetting[0]);

            SetHelpStubHook();

            break;

        case WM_COMMAND:

            pSerialData = (PSERIALDATA)WinQueryWindowULong (hDlg, QWL_USER);
            switch (SHORT1FROMMP(mp1)) {
               case IDC_OK:
                     /*
                     ** transfer the input settings into string
                     ** except the timeout value
                     */
                  GetDialogValues(hDlg, &pSerialData->szSaveCommSetting[0]);

                     /*
                     ** get the timeout value from spin button control
                     */
                  WinSendDlgItemMsg (hDlg, IDC_PSE_TIMEOUT, SPBM_QUERYVALUE,
                                     (MPARAM)&ulTimeOut, (MPARAM)NULL);
                  pSerialData->usSaveTimeOut = (USHORT)ulTimeOut;

                     /*
                     ** Check if user modified the original settings.
                     ** This avoids unnecessary update of port settings.
                     */
                  if (!strcmp (&pSerialData->szSaveCommSetting[0],
                               &pSerialData->szOrgCommSetting[0]) &&
                               pSerialData->usOrgTimeOut ==
                               pSerialData->usSaveTimeOut)
                  {
                     WinDismissDlg(hDlg,0L);
                     break;
                  }
                  if (SavePortSettings(pSerialData))
                  {
                     pSerialData->lfModified = TRUE;
                     WinDismissDlg(hDlg,0L);
                  }
                  break;

               case IDC_RESET:

                     /*
                     ** Reset port dialog to initial settings
                     */
                  SetDialogValues(hDlg, &pSerialData->szOrgCommSetting[0]);
                  WinSendDlgItemMsg (hDlg, IDC_PSE_TIMEOUT,
                                     SPBM_SETCURRENTVALUE,
                                     MPFROMSHORT(pSerialData->usOrgTimeOut),
                                     MPFROMSHORT(NULL));
                  break;

               case IDC_DEFAULT:

                     /*
                     ** Reset port dialog to default settings
                     */
                  GetPortDefaultSettings(&pSerialData->szSaveCommSetting[0]);
                  SetDialogValues(hDlg, &pSerialData->szSaveCommSetting[0]);
                  WinSendDlgItemMsg (hDlg, IDC_PSE_TIMEOUT,
                                     SPBM_SETCURRENTVALUE,
                                     MPFROMSHORT(DEF_TIMEOUT_VALUE),
                                     MPFROMSHORT(NULL));
                  break;

               case IDC_CANCEL:
                  WinDismissDlg(hDlg, MBID_CANCEL);
                  break;

               default:
                  return(WinDefDlgProc(hDlg, msg, mp1, mp2) );
                  break;
            }
           break;

      case WM_HELP:
          InitializeHelp();
          if (hwndHelp)
          {
             WinSendMsg (hwndHelp, HM_DISPLAY_HELP,
                                       (MPARAM)IDH_DLG_EXTENDED, NULL);
             return (MRESULT)TRUE;
          }
          break;

        case WM_DESTROY:

              /*
              ** if we have a help instance - destroy it.
              */
           if (HelpAlreadyInitialized)
           {
              CALLDestroyHelpInstance(hwndHelp);
              hwndHelp = (HWND) NULL;
              HelpAlreadyInitialized = FALSE;
              HelpStubHookIsSet=FALSE;
           }
           ReleaseHelpStubHook();

           break;

        default:
            return(WinDefDlgProc(hDlg, msg, mp1, mp2) );
            break;
    }
    return FALSE;
}

/****************************************************************************
 *
 * FUNCTION NAME = InitCommDialogBox
 *
 * DESCRIPTION   = handle WM_INITDLG message for serial port driver
 *                 settings dialog
 *
 * INPUT         = hDlg          -  handle of dialog window
 *                 pSerialData   -> this port's information
 *
 * OUTPUT        = TRUE          -  successful
 *                 FALSE         -  Unable to query COM driver, using defaults
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

BOOL InitCommDialogBox( HWND hDlg,
                        PSERIALDATA pSerialData )
{
    HFILE       hfPort          = NULLHANDLE;
    ULONG       ulAction        = (ULONG)0;
    ULONG       ulIndex         = (ULONG)0;
    ULONG       ulParamInOutLen = (ULONG)0;
    ULONG       ulDataInOutLen  = (ULONG)0;
    ULONG       ulRet           = (ULONG)0;
    ULONG       ulCnt;
    EXTQUERYBIT eqb;                     /* extended query bitrate structure */

    CHAR        szDesc[ STR_LEN_PORTDESC];
    CHAR        szTitle[ STR_LEN_TITLE + 1];


       /*
       ** Must find range of Baud rates supported by COM device driver.
       **
       ** This is done by opening a COM port and issuing an IOCtl.
       ** (Category 1 Function 63h).
       **
       ** Problem is that if the COM port being setup is not physically
       **  installed(ex: no COM3 port) then we are unable to get
       **  list of supported baud rates.
       **
       ** Temporary solution is to try Opening the port being setup.
       ** If this fails
       **   open COM1 and query it for supported baud rates.
       */

    DosError(0) ; /* disable hard-error popups */

    ulRet = DosOpen(pSerialData->pszPortName,
                    &hfPort,
                    &ulAction,
                    0L,                           /* Filesize Not Applicable */
                    FILE_NORMAL,
                    OPEN_ACTION_OPEN_IF_EXISTS,
                    (ULONG)OPEN_SHARE_DENYREADWRITE |
                           OPEN_ACCESS_READWRITE    |
                           OPEN_FLAGS_NOINHERIT,
                    0L);

    if (ulRet)
    {
          /*
          ** Failed to open port being setup.
          ** Now just open COM.SYS(COM1) and get its supported baud rates.
          */
       ulRet = DosOpen("COM1",
                       &hfPort,
                       &ulAction,
                       0L,                        /* Filesize Not Applicable */
                       FILE_NORMAL,
                       OPEN_ACTION_OPEN_IF_EXISTS,
                       (ULONG)OPEN_SHARE_DENYREADWRITE |
                              OPEN_ACCESS_READWRITE    |
                              OPEN_FLAGS_NOINHERIT,
                       0L);
    }

    if (!ulRet)
    {
          /*
          ** Query Bit Rate - Func 63H, Category 1
          */
       ulRet = DosDevIOCtl(hfPort, 1L, 0x63, NULL, 0L, &ulParamInOutLen,
                          &eqb, sizeof(EXTQUERYBIT), &ulDataInOutLen);
       if (ulRet)
       {
             /*
             ** Use default Index Size
             */
          ulIndex = MAX_NUM_BAUDRATE;
       } else {
             /*
             ** Parse array for valid baud rates
             */
          ulCnt = 0;
          while (atol(szBaudRateAra[ulCnt]) <= eqb.ulMaxBitRate)
          {
             ulCnt++;
          }
          ulIndex = ulCnt;
       }

       DosClose(hfPort);

    } else {
          /*
          ** Unable to query COM.SYS so use default values
          */
       ulIndex = MAX_NUM_BAUDRATE;
    }


    WinSendDlgItemMsg (hDlg, IDC_PSE_TIMEOUT,
                       SPBM_SETLIMITS,
                       MPFROMP(TIMEOUT_UPPER_LIMIT),
                       MPFROMP(TIMEOUT_LOWER_LIMIT));
    WinSendDlgItemMsg (hDlg, IDC_PSE_BAUDRATE,
                       SPBM_SETARRAY,
                       MPFROMP(szBaudRateAra),
                       MPFROMSHORT(ulIndex));

       /*
       ** Get description of port and append to window title
       */
    if (PrfQueryProfileString (HINI_SYSTEMPROFILE,
                               pSerialData->pszAppName,
                               KEY_DESCRIPTION,
                               NULL,
                               (PSZ)szDesc,
                               STR_LEN_PORTDESC))
    {
        WinSetWindowText (WinWindowFromID (hDlg, (USHORT)IDC_PSE_DESC),
                          szDesc);
          /*
          ** full description port name
          */
        WinQueryWindowText (hDlg, STR_LEN_TITLE, szTitle);
        strcat (szTitle, szDesc);
        WinSetWindowText (hDlg, szTitle);
    }
    if (ulRet)
       return(FALSE);
    else
       return(TRUE);

}

/****************************************************************************
 *
 * FUNCTION NAME = GetDialogValues
 *
 * DESCRIPTION   = Get the user input fields from the port driver settings
 *                 dialog and return their values.
 *
 * INPUT         = hDlg                -  handle of dialog window
 *                 pszSaveCommSettings - receives settings from dialog
 *
 * OUTPUT        = *pszSaveCommSettings -> buffer is updated from dialog
 *
 * RETURN-NORMAL = VOID
 * RETURN-ERROR  =
 *
 ****************************************************************************/

VOID GetDialogValues(HWND hDlg,
                     PSZ pszSaveCommSetting)
{
   CHAR  szBuild[80];               /* build up string to write to win       */
   CHAR  szSuffix[5];               /* additional string to add on end       */


      /*
      ** Format of comm port initialization string to build:
      **
      ** "Baudrate;Parity;Wordlength;StopBits;Handshaking"
      **
      ** Default values are "9600;0;8;1;1;"
      **
      */

      /*
      ** Get Baud rate string, use as first item in initialization string
      */
   WinSendDlgItemMsg (hDlg, IDC_PSE_BAUDRATE, SPBM_QUERYVALUE,
                               (MPARAM)szBuild, (MPARAM)20);
      /*
      ** Get parity
      */
   if (WinSendDlgItemMsg(hDlg,
                         IDC_PSE_PARITYEVEN,
                         BM_QUERYCHECK,
                         (MPARAM)NULL,
                         (MPARAM)NULL))
   {
      strcpy((PSZ)szSuffix,(PSZ)";2");
   }
   if (WinSendDlgItemMsg(hDlg,
                         IDC_PSE_PARITYODD,
                         BM_QUERYCHECK,
                         (MPARAM)NULL,
                         (MPARAM)NULL))
   {
      strcpy((PSZ)szSuffix,(PSZ)";1");
   }
   if (WinSendDlgItemMsg(hDlg,
                         IDC_PSE_PARITYNONE,
                         BM_QUERYCHECK,
                         (MPARAM)NULL,
                         (MPARAM)NULL))
   {
      strcpy((PSZ)szSuffix,(PSZ)";0");
   }
      /*
      ** add suffix to string building
      */
   strcat((PSZ)szBuild,(PSZ)szSuffix);

      /*
      ** Get word length
      */
   if (WinSendDlgItemMsg(hDlg,
                         IDC_PSE_WORDLEN5BITS,
                         BM_QUERYCHECK,
                         (MPARAM)NULL,
                         (MPARAM)NULL))
   {
      strcpy((PSZ)szSuffix,(PSZ)";5");
   }
   if (WinSendDlgItemMsg(hDlg,
                         IDC_PSE_WORDLEN6BITS,
                         BM_QUERYCHECK,
                         (MPARAM)NULL,
                         (MPARAM)NULL))
   {
      strcpy((PSZ)szSuffix,(PSZ)";6");
   }
   if (WinSendDlgItemMsg(hDlg,
                         IDC_PSE_WORDLEN7BITS,
                         BM_QUERYCHECK,
                         (MPARAM)NULL,
                         (MPARAM)NULL))
   {
      strcpy((PSZ)szSuffix,(PSZ)";7");
   }
   if (WinSendDlgItemMsg(hDlg,
                         IDC_PSE_WORDLEN8BITS,
                         BM_QUERYCHECK,
                         (MPARAM)NULL,
                         (MPARAM)NULL))
   {
      strcpy((PSZ)szSuffix,(PSZ)";8");
   }
      /*
      ** add suffix to string building
      */
   strcat((PSZ)szBuild,(PSZ)szSuffix);

      /*
      ** Get stop bits
      */
   if (WinSendDlgItemMsg(hDlg,
                         IDC_PSE_STOPBIT1,
                         BM_QUERYCHECK,
                         (MPARAM)NULL,
                         (MPARAM)NULL))
   {
      strcpy((PSZ)szSuffix,(PSZ)";1");
   }
   if (WinSendDlgItemMsg(hDlg,
                         IDC_PSE_STOPBIT1_5,
                         BM_QUERYCHECK,
                         (MPARAM)NULL,
                         (MPARAM)NULL))
   {
      strcpy((PSZ)szSuffix,(PSZ)";1.5");
   }
   if (WinSendDlgItemMsg(hDlg,
                         IDC_PSE_STOPBIT2,
                         BM_QUERYCHECK,
                         (MPARAM)NULL,
                         (MPARAM)NULL))
   {
      strcpy((PSZ)szSuffix,(PSZ)";2");
   }
      /*
      ** add suffix to string building
      */
   strcat((PSZ)szBuild,(PSZ)szSuffix);
      /*
      ** Get hardware handshaking
      */
   if (WinSendDlgItemMsg(hDlg,
                         IDC_PSE_HSHARDW,
                         BM_QUERYCHECK,
                         (MPARAM)NULL,
                         (MPARAM)NULL))
   {
      strcpy((PSZ)szSuffix,(PSZ)";1;");
   }
   if (WinSendDlgItemMsg(hDlg,
                         IDC_PSE_HSNONE,
                         BM_QUERYCHECK,
                         (MPARAM)NULL,
                         (MPARAM)NULL))
   {
      strcpy((PSZ)szSuffix,(PSZ)";0;");
   }
      /*
      ** add suffix to string building
      */
   strcat((PSZ)szBuild,(PSZ)szSuffix);

   strcpy((PSZ)pszSaveCommSetting, szBuild);

}

/****************************************************************************
 *
 * FUNCTION NAME = SetDialogValues
 *
 * DESCRIPTION   = Set up the serial port dialog box options from the given
 *                 initialization settings
 *
 * INPUT         = hDlg            - handle of dialog window
 *                 pszCommSettings - values for setting dialog
 *
 * OUTPUT        = Dialog entry fields set to pszCommSetting values
 *
 * RETURN-NORMAL = VOID
 * RETURN-ERROR  =
 *
 ****************************************************************************/

VOID SetDialogValues(HWND hDlg,
                     PSZ pszCommSetting)
{
   CHAR  *pszCur,*pszNext;
   CHAR  szTester[PORT_ENTRY_LEN+1];
   SHORT Temp;
   ULONG Index;

   strcpy(szTester, pszCommSetting);
   pszCur = &szTester[0];

      /*
      ** Format of comm port initialization string:
      ** "Baudrate;Parity;Wordlength;StopBits;Handshaking"
      **
      ** Default values are "9600;0;8;1;1;"
      **
      */
      /*
      ** baud rate
      */
   pszNext = strchr (pszCur,';');
   if (pszNext && *pszNext)
   {
      *pszNext++ = 0;
   }
   RemoveLeadTrailBlanks ((PSZ)pszCur, (PSZ)pszCur);

   if (!*pszCur)
   {
      Index = DEF_BAUD_INDEX;
   }
   else
   {
      for (Index=0; Index<MAX_NUM_BAUDRATE; Index++)
      {
         if (!strcmp (szBaudRateAra[Index], pszCur))
         {
            break;
         }
      }
   }
   WinSendDlgItemMsg (hDlg, IDC_PSE_BAUDRATE,
                      SPBM_SETCURRENTVALUE,
                      MPFROMSHORT((USHORT)Index),
                      MPFROMSHORT(NULL));

   pszCur = pszNext;

      /*
      ** parity
      */
   pszNext = strchr (pszCur,';');
   if (pszNext && *pszNext)
   {
      *pszNext++ = 0;
   }
   RemoveLeadTrailBlanks ((PSZ)pszCur, (PSZ)pszCur);
   WinSendDlgItemMsg(hDlg,
                     IDC_PSE_PARITYODD,
                     BM_SETCHECK,
                     (MPARAM)FALSE,
                     (MPARAM)NULL);
   WinSendDlgItemMsg(hDlg,
                     IDC_PSE_PARITYEVEN,
                     BM_SETCHECK,
                     (MPARAM)FALSE,
                     (MPARAM)NULL);
   WinSendDlgItemMsg(hDlg,
                     IDC_PSE_PARITYNONE,
                     BM_SETCHECK,
                     (MPARAM)FALSE,
                     (MPARAM)NULL);

   switch (*pszCur)
   {
      case '1':
         WinSendDlgItemMsg(hDlg,
                           IDC_PSE_PARITYODD,
                           BM_SETCHECK,
                           (MPARAM)TRUE,
                           (MPARAM)NULL);
         break;
      case '2':
         WinSendDlgItemMsg(hDlg,
                           IDC_PSE_PARITYEVEN,
                           BM_SETCHECK,
                           (MPARAM)TRUE,
                           (MPARAM)NULL);
         break;
      case '0':
         WinSendDlgItemMsg(hDlg,
                           IDC_PSE_PARITYNONE,
                           BM_SETCHECK,
                           (MPARAM)TRUE,
                           (MPARAM)NULL);
         break;
      default:
         WinSendDlgItemMsg(hDlg,
                           DEF_PARITY,
                           BM_SETCHECK,
                           (MPARAM)TRUE,
                           (MPARAM)NULL);
         break;
   }

   pszCur = pszNext;

      /*
      ** Word length
      */
   pszNext = strchr(pszCur,';');
   if (pszNext && *pszNext)
   {
      *pszNext++ = '\0';
   }
   RemoveLeadTrailBlanks ((PSZ)pszCur, (PSZ)pszCur);
   Temp = (SHORT)(*pszCur - '5');
   WinSendDlgItemMsg(hDlg,
                     (IDC_PSE_WORDLEN5BITS),
                     BM_SETCHECK,
                     (MPARAM)FALSE,
                     (MPARAM)NULL);
   WinSendDlgItemMsg(hDlg,
                     (IDC_PSE_WORDLEN6BITS),
                     BM_SETCHECK,
                     (MPARAM)FALSE,
                     (MPARAM)NULL);
   WinSendDlgItemMsg(hDlg,
                     (IDC_PSE_WORDLEN7BITS),
                     BM_SETCHECK,
                     (MPARAM)FALSE,
                     (MPARAM)NULL);
   WinSendDlgItemMsg(hDlg,
                     (IDC_PSE_WORDLEN8BITS),
                     BM_SETCHECK,
                     (MPARAM)FALSE,
                     (MPARAM)NULL);

   if ( (Temp >= 0) && (Temp <= 3) )
   {
        WinSendDlgItemMsg(hDlg,
                          (USHORT)(IDC_PSE_WORDLEN5BITS+Temp),
                          BM_SETCHECK,
                          (MPARAM)TRUE,
                          (MPARAM)NULL);
   }
   else
   {
        WinSendDlgItemMsg(hDlg,
                          DEF_WORD,
                          BM_SETCHECK,
                          (MPARAM)TRUE,
                          (MPARAM)NULL);
   }
   pszCur = pszNext;

      /*
      ** stop bits
      */
   pszNext = strchr(pszCur,';');
   if (pszNext && *pszNext)
   {
      *pszNext++ = '\0';
   }
   RemoveLeadTrailBlanks ((PSZ)pszCur, (PSZ)pszCur);
   WinSendDlgItemMsg(hDlg,
                     IDC_PSE_STOPBIT1,
                     BM_SETCHECK,
                     (MPARAM)FALSE,
                     (MPARAM)NULL);
   WinSendDlgItemMsg(hDlg,
                     IDC_PSE_STOPBIT1_5,
                     BM_SETCHECK,
                     (MPARAM)FALSE,
                     (MPARAM)NULL);
   WinSendDlgItemMsg(hDlg,
                     IDC_PSE_STOPBIT2,
                     BM_SETCHECK,
                     (MPARAM)FALSE,
                     (MPARAM)NULL);

   if (!strcmp((PSZ)pszCur,(PSZ)"1"))
   {
        WinSendDlgItemMsg(hDlg,
                          IDC_PSE_STOPBIT1,
                          BM_SETCHECK,
                          (MPARAM)TRUE,
                          (MPARAM)NULL);
   }
   else
   {
        if (!strcmp((PSZ)pszCur,(PSZ)"1.5"))
        {
             WinSendDlgItemMsg(hDlg,
                               IDC_PSE_STOPBIT1_5,
                               BM_SETCHECK,
                               (MPARAM)TRUE,
                               (MPARAM)NULL);
        }
        else
        {
             if (!strcmp((PSZ)pszCur,(PSZ)"2"))
             {
                  WinSendDlgItemMsg(hDlg,
                                    IDC_PSE_STOPBIT2,
                                    BM_SETCHECK,
                                    (MPARAM)TRUE,
                                    (MPARAM)NULL);
             }
             else
             {
                  WinSendDlgItemMsg(hDlg,
                                    DEF_STOP,
                                    BM_SETCHECK,
                                    (MPARAM)TRUE,
                                    (MPARAM)NULL);
             }
        }
   }
   pszCur = pszNext;

      /*
      ** handshaking: yes or no?
      */
   pszNext = strchr (pszCur,';');
   if (pszNext, *pszNext)
   {
      *pszNext++ = '\0';
   }
   RemoveLeadTrailBlanks ((PSZ)pszCur, (PSZ)pszCur);
   WinSendDlgItemMsg(hDlg,
                     IDC_PSE_HSHARDW,
                     BM_SETCHECK,
                     (MPARAM)FALSE,
                     (MPARAM)NULL);
   WinSendDlgItemMsg(hDlg,
                     IDC_PSE_HSNONE,
                     BM_SETCHECK,
                     (MPARAM)FALSE,
                     (MPARAM)NULL);

   if (*pszCur == '1')
        WinSendDlgItemMsg(hDlg,
                          IDC_PSE_HSHARDW,
                          BM_SETCHECK,
                          (MPARAM)TRUE,
                          (MPARAM)NULL);
   else
        WinSendDlgItemMsg(hDlg,
                          IDC_PSE_HSNONE,
                          BM_SETCHECK,
                          (MPARAM)TRUE,
                          (MPARAM)NULL);
}


/****************************************************************************
 *
 * FUNCTION NAME = SavePortSettings
 *
 * DESCRIPTION   = save any changed values for this COM port in INI file
 *
 * INPUT         = pSerialData -> this port's information
 *
 * OUTPUT        = TRUE          -  successful
 *                 FALSE         -  PrfWrite failed
 *
 * RETURN-NORMAL = TRUE
 * RETURN-ERROR  = FALSE
 *
 ****************************************************************************/

BOOL SavePortSettings(PSERIALDATA pSerialData)

{
      /*
      ** Only save settings if they don't match original settings
      **
      ** Format of comm port initialization string:
      ** "Baudrate;Parity;Wordlength;StopBits;Handshaking"
      **
      ** Default values are "9600;0;8;1;1;"
      **
      */
   if (strcmp (&pSerialData->szSaveCommSetting[0],
                              &pSerialData->szOrgCommSetting[0]))
   {
         /*
         ** Write data for this port in ini file with new format.
         */
      if (!PrfWriteProfileString (HINI_SYSTEMPROFILE,
                                 pSerialData->pszAppName,
                                 KEY_INITIALIZATION,
                                 pSerialData->szSaveCommSetting))
      {
         DE ("Error in writing to system init file");
         return FALSE;
      }

         /*
         ** Write data for this port in ini file with old format.
         */
      if (!PrfWriteProfileString (HINI_SYSTEMPROFILE,
                             APPNAME_PM_SPOOLER_PORT,
                             pSerialData->pszPortName,
                             pSerialData->szSaveCommSetting))
      {
          DE ("Error in writing to system init file");
          return FALSE;
      }
   }
   if (pSerialData->usOrgTimeOut != pSerialData->usSaveTimeOut)
   {
      CHAR szBuf[20];

      itoa (pSerialData->usSaveTimeOut, szBuf, 10);
      strcat (szBuf, ";");
         /*
         ** Write data for this port in ini file with only new format.
         */
      if (!PrfWriteProfileString (HINI_SYSTEMPROFILE,
                                 pSerialData->pszAppName,
                                 KEY_TIMEOUT,
                                 szBuf))
      {
         DE ("Error in writing to system init file");
         return FALSE;
      }
   }
   return TRUE;
}

/****************************************************************************
 *
 * FUNCTION NAME = GetPortSettings
 *
 * DESCRIPTION   = Get port Initialization settings from INI file
 *
 * INPUT         = pSerialData -> structure containing port name.
 *                                On return this will have port timeout,
 *                                baud rate, word length, parity, stop bits
 *                                and handshake.
 *
 * OUTPUT        = TRUE  - if INI information found for port
 *                 FALSE - if INI info not found
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

BOOL GetPortSettings(PSERIALDATA pSerialData)
{
   CHAR szTimeOut[20];
   PSZ  pszSaveCommSetting = &pSerialData->szSaveCommSetting[0];
   PSZ  pszOrgCommSetting = &pSerialData->szOrgCommSetting[0];

      /*
      ** Get port init value.
      */
   if (!(PrfQueryProfileString (HINI_SYSTEMPROFILE,
                                pSerialData->pszAppName,
                                KEY_INITIALIZATION,
                                NULL,
                                (PSZ)pszOrgCommSetting,
                                STR_LEN_PORTDESC)))
   {
      return FALSE;
   }

   RemoveLeadTrailBlanks ((PSZ)pszOrgCommSetting, (PSZ)pszOrgCommSetting);

   if (strlen(pszOrgCommSetting))
   {
       strcpy(pszSaveCommSetting,
              pszOrgCommSetting);
   } else {

       GetPortDefaultSettings(pszSaveCommSetting);
   }

      /*
      ** Get port timeout value( "PM_COM1" "TIMEOUT" "timeout").
      */
   if (PrfQueryProfileString (HINI_SYSTEMPROFILE,
                              pSerialData->pszAppName,
                              KEY_TIMEOUT,
                              NULL,
                              (PSZ)szTimeOut,
                              STR_LEN_PORTDESC))
   {
      pSerialData->usOrgTimeOut = (USHORT)atoi ((PSZ)szTimeOut);

   } else {

      pSerialData->usOrgTimeOut = DEF_TIMEOUT_VALUE;
   }
   pSerialData->usSaveTimeOut = pSerialData->usOrgTimeOut;
   return(TRUE);
}

/****************************************************************************
 *
 * FUNCTION NAME = GetPortDefaultSettings
 *
 * DESCRIPTION   = Get port Initialization settings from INI file
 *
 * INPUT         = pszSaveCommSetting - gets default port settings
 *
 * OUTPUT        = TRUE  - if INI information found for port
 *                 FALSE - if INI info not found
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

VOID GetPortDefaultSettings(PSZ pszSaveCommSetting)
{
   SHORT setting;                   /* iterative                             */
   CHAR  szBuild[18];               /* build up string to write to win       */
   CHAR  szSuffix[5];               /* additional string to add on end       */

      /*
      ** Format of comm port initialization string:
      ** "Baudrate;Parity;Wordlength;StopBits;Handshaking"
      **
      ** Default values are "9600;0;8;1;1;"
      **
      **
      ** NOTE: this will return a string based on the values
      **       of DEF_ in serial.h
      **       This makes changing your default COM settings
      **       a little easier
      */

      /*
      ** Build default init string starting with Baud Rate
      */
   strcpy((PSZ)szBuild, (PSZ)DEF_BAUD);
   setting = DEF_PARITY;
   switch(setting)
   {
      case IDC_PSE_PARITYEVEN:
         strcpy((PSZ)szSuffix,(PSZ)";2");
         break;
      case IDC_PSE_PARITYODD:
         strcpy((PSZ)szSuffix,(PSZ)";1");
         break;
      case IDC_PSE_PARITYNONE:
         strcpy((PSZ)szSuffix,(PSZ)";0");
         break;
   }  /* end switch */

      /*
      ** add suffix to string building
      */
   strcat((PSZ)szBuild,(PSZ)szSuffix);

   setting = DEF_WORD;
   switch(setting)
   {
      case IDC_PSE_WORDLEN5BITS:
         strcpy((PSZ)szSuffix,(PSZ)";5");
         break;
      case IDC_PSE_WORDLEN6BITS:
         strcpy((PSZ)szSuffix,(PSZ)";6");
         break;
      case IDC_PSE_WORDLEN7BITS:
         strcpy((PSZ)szSuffix,(PSZ)";7");
         break;
      case IDC_PSE_WORDLEN8BITS:
         strcpy((PSZ)szSuffix,(PSZ)";8");
         break;
   }  /* end switch */

      /*
      ** add suffix to string building
      */
   strcat((PSZ)szBuild,(PSZ)szSuffix);

   setting = DEF_STOP;
   switch(setting)
   {
      case IDC_PSE_STOPBIT1:
         strcpy((PSZ)szSuffix,(PSZ)";1");
         break;
      case IDC_PSE_STOPBIT1_5:
         strcpy((PSZ)szSuffix,(PSZ)";1.5");
         break;
      case IDC_PSE_STOPBIT2:
         strcpy((PSZ)szSuffix,(PSZ)";2");
         break;
      }  /* end switch */

      /*
      ** add suffix to string building
      */
   strcat((PSZ)szBuild,(PSZ)szSuffix);

   setting = DEF_SHAKE;
   switch(setting)
   {
      case IDC_PSE_HSHARDW:
         strcpy((PSZ)szSuffix,(PSZ)";1;");
         break;
      case IDC_PSE_HSNONE:
         strcpy((PSZ)szSuffix,(PSZ)";0;");
         break;
      }  /* end switch */

      /*
      ** add suffix to string building
      */
   strcat((PSZ)szBuild,(PSZ)szSuffix);

   strcpy((PSZ)pszSaveCommSetting,szBuild);

}

/****************************************************************************
 *
 * FUNCTION NAME = RemoveLeadTrailBlanks
 *
 * DESCRIPTION   = Remove all the leading blanks and all the trailing blanks
 *                 from the source string. The target string contains no lead
 *                 or trail blanks. Source string is not altered.
 *
 * INPUT         = pTarget   - Target string.
 *                 pSource   - Source string.
 *
 * OUTPUT        = Void function.
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 *      Note : Function accepts the same pointer for both source and target.
 *             This means that same buffer can be used as input and output.
 *
 ****************************************************************************/

VOID RemoveLeadTrailBlanks (PCH pTarget,
                            PCH pSource)
{
   for (; *pSource == ' ' || *pSource == '\t' || *pSource == '\n'; pSource++);
   if (!(*pSource))
   {
      *pTarget = '\0';
      return;
   }
   for (; *pSource; *pTarget++ = *pSource++);
   for (pTarget--; *pTarget == ' ' || *pTarget == '\t' || *pTarget == '\n';
                                                                 pTarget--);
   *++pTarget = '\0';

}

/****************************************************************************
 *
 * FUNCTION NAME = InitializeCommPort
 *
 * DESCRIPTION   = Initialize COM port from INI file values.
 *                 Called by SplPdInit to set Baud Rate, ...
 *
 * INPUT         = fh  - file handle to port
 *                 pszLogAddress - name of port being initialized
 *
 * OUTPUT        = Sets serial port settings
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

BOOL InitializeCommPort(HFILE fh,
                        PSZ pszLogAddress)
{
   char     szIni[32];
   PSZ      psz;
   COMMINFO ci;
   USHORT   usData;

   ULONG    cbParmLengthInOut;
   ULONG    cbDataLengthInOut;
   ULONG    ulTempTimeout;

   CHAR     szTimeOut[20];
   CHAR     chBuf[STR_LEN_PORTNAME];

      /*
      ** Load the port initialization string from System INI file.
      **
      ** NOTE: This actually should read from "PM_PortName" "INITIALIZATION"
      **         appname/keyname pair, but we always write to both places
      **         when setting our COM port values.
      */

      /*
      ** Make Application name string("PM_PortName" ex: PM_COM1)
      */
   strcpy (chBuf, APPNAME_LEAD_STR);
   strcat (chBuf, pszLogAddress);

   PrfQueryProfileString (HINI_SYSTEMPROFILE,
                          chBuf,
                          KEY_INITIALIZATION,
                          (PSZ)";;;;;",
                          (PSZ)szIni,
                          sizeof(szIni));

   psz = (PSZ)szIni;

      /*
      ** Default to 9600 baud
      */
   psz = AsciiToBin(psz, 9600, &ci.BaudRate);

   if (psz == NULL)
   {
      goto ERROR;
   }

      /*
      ** Default to no parity
      */
   psz = AsciiToBin(psz, 0, &usData);

   if (psz == NULL)
   {
      goto ERROR;
   }

   ci.DataParityStop[1] = (UCHAR)usData;

      /*
      ** Word length: default to 8 bits/bytes
      */
   psz = AsciiToBin(psz, 8, &usData);

   if (psz == NULL)
   {
      goto ERROR;
   }

   ci.DataParityStop[0] = (UCHAR)usData;

      /*
      ** Number of stop bits
      */
   switch (*psz)
   {
      case ';' :
         usData = 0;
         break;

      case '1' :
         if (psz[1] == '.' && psz[2] == '5')
         {
            usData = 1;
            psz += 3;
         }
         else
         {
            usData = 0;
            psz += 1;
         }
         break;

      case '2' :
         usData = 2;
         psz += 1;
         break;

      default  :
         goto ERROR;
   }


   if (*psz++ != ';')
   {
      goto ERROR;
   }

   ci.DataParityStop[2] = (UCHAR)usData;

      /*
      **
      ** Initialize the handshaking parameters by calling DosDevIOCtl,
      **   then modify them according to port's Initialization string.
      ** Hardware handshaking is controlled by bits 3, 4 and 5 of
      **   the control block flags1, and bit 0 of flags2.
      **   If the next entry in the INI buffer is a semicolon or '0'
      **    then hardware handshaking is disabled.
      **   If it is '1'
      **    then hardware handshaking is enabled.
      */

      /* Query current COM port settings first
      **
      **
      ** NOTE:  Fcn 73h(return device control block info) passes buffer
      **        as the Data Packet.  All other COM IOCtls pass buffer
      **        as the Parameter Packet!
      **
      */
   cbDataLengthInOut = sizeof(ci.DeviceCtlBlk) ;
   cbParmLengthInOut = 0L ;

   if (!DosDevIOCtl(fh,                         /* file(device) handle       */
                    1L,                         /* category                  */
                    0x73L,                      /* function                  */
                    NULL,                       /* pParms                    */
                    0L,                         /* cbParmMax                 */
                    &cbParmLengthInOut,         /* pParmLengthInOut          */
                    (PVOID)&ci.DeviceCtlBlk,    /* pData                     */
                    cbDataLengthInOut,          /* cbDataMax                 */
                    &cbDataLengthInOut ))       /* pDataLengthInOut          */
   {


         /*
         ** Get port timeout from INI file
         */
      PrfQueryProfileString (HINI_SYSTEMPROFILE,
                             chBuf,
                             KEY_TIMEOUT,
                             NULL,
                             (PSZ)szTimeOut,
                             STR_LEN_PORTDESC);

         /*
         ** Write Timeout is in .01 second increments
         */
      ulTempTimeout = (USHORT)(atoi((PSZ)szTimeOut) * 100);

         /*
         ** validate the timeout value fits in a USHORT
         */
      if( ulTempTimeout > IOCTL_TIMEOUT_UPPER_LIMIT )
      {
            /*
            ** Set to default value
            */
         ci.DeviceCtlBlk.WriteTimeout = 4500;
      }
      else
      {
            /*
            ** NOTE: 0 is now an allowable timeout value for COM ports
            */
         ci.DeviceCtlBlk.WriteTimeout = (USHORT)ulTempTimeout;
      }

      if (*psz == ';' || *psz == '0')
      {
            /*
            ** Disable hardware handshaking:
            **           Disable output handshaking using CTS DSR and DCD
            **                (Flags1 bits 5, 4 and 3 to zero)
            **           Enable automatic transmit control(XON) Flags2 bit 0
            */
         ci.DeviceCtlBlk.Flags1 &= 0xc7;
         ci.DeviceCtlBlk.Flags2 |= 0x01;
         ci.DeviceCtlBlk.XONCharacter = 17;
         ci.DeviceCtlBlk.XOFFCharacter = 19;
      }
      else
      {
            /*
            ** Enable hardware handshaking:
            **
            **           Enable output handshaking using CTS and DSR
            **                (Flags1 bits 4 and 3 to one)
            **           Disable output handshaking using DCD
            **                (Flags1 bit 5 to zero)
            **           Disable automatic transmit control(XON) Flags2 bit 0
            */
         ci.DeviceCtlBlk.Flags1 = (UCHAR)((ci.DeviceCtlBlk.Flags1 & 0xdf) | 0x18);
         ci.DeviceCtlBlk.Flags2 &= 0xfe;
      }
   }


   cbParmLengthInOut = sizeof(USHORT) ;
   cbDataLengthInOut = 0L ;

   DosDevIOCtl(fh,                              /* file(device) handle       */
               1L,                              /* category                  */
               0x41L,                           /* function Set Baud Rate    */
               (PVOID)&ci.BaudRate,             /* pParms - value to set     */
               cbParmLengthInOut,               /* cbParmMax                 */
               &cbParmLengthInOut,              /* pParmLengthInOut          */
               NULL,                            /* pData                     */
               cbDataLengthInOut,               /* cbDataMax                 */
               &cbDataLengthInOut );            /* pDataLengthInOut          */


   cbParmLengthInOut = 3 ;                      /* three bytes of parameters */
   cbDataLengthInOut = 0L ;

   DosDevIOCtl(fh,                              /* file(device) handle       */
               1L,                              /* category                  */
               0x42L,                   /* function Set Line characteristics */
               (PVOID)&ci.DataParityStop[0],    /* pParms - value to set     */
               cbParmLengthInOut,               /* cbParmMax                 */
               &cbParmLengthInOut,              /* pParmLengthInOut          */
               NULL,                            /* pData                     */
               cbDataLengthInOut,               /* cbDataMax                 */
               &cbDataLengthInOut );            /* pDataLengthInOut          */

   cbParmLengthInOut = sizeof(ci.DeviceCtlBlk) ;
   cbDataLengthInOut = 0L ;

   DosDevIOCtl(fh,                              /* file(device) handle       */
               1L,                              /* category                  */
               0x53L,                   /* function Set Device Control Block */
               (PVOID)&ci.DeviceCtlBlk,         /* pParms - value to set     */
               cbParmLengthInOut,               /* cbParmMax                 */
               &cbParmLengthInOut,              /* pParmLengthInOut          */
               NULL,                            /* pData                     */
               cbDataLengthInOut,               /* cbDataMax                 */
               &cbDataLengthInOut );            /* pDataLengthInOut          */

   return (TRUE);

ERROR:
   return (FALSE);
}

/****************************************************************************
 *
 * FUNCTION NAME = AsciiToBin
 *
 * DESCRIPTION   = convert given string to numeric value
 *
 * INPUT         = pszString -> semi-colon terminated string
 *                 usDef     -  default value if none found
 *                 pusOut    -> USHORT to receive value
 *
 * OUTPUT        = *pusOut gets value from pszString or usDef
 *
 * RETURN-NORMAL = pointer to next char after semi-colon
 *                 or NULL if no terminating semi-colon
 *
 * RETURN-ERROR  =
 *
 ****************************************************************************/

PSZ AsciiToBin (PSZ pszString,
                USHORT usDef,
                PUSHORT pusOut)
{
   PSZ pszTemp;

   pszTemp = strchr (pszString, ';');
   if (pszTemp)
   {
      *pszTemp = '\0';
   }
   if (strlen (pszString))
   {
      *pusOut = (USHORT)atol (pszString);
   }
   else
   {
      *pusOut = usDef;
   }
   if (pszTemp)
   {
      *pszTemp = ';';
      pszTemp++ ;                       /* index past terminating semi-colon */
   }

   return(pszTemp);
}

/****************************************************************************
 *
 * FUNCTION NAME = DE
 *
 * DESCRIPTION   = Display Error message
 *
 * INPUT         = str  - error message string to display
 *
 * OUTPUT        = None
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

VOID DE (PCH str)
{
       WinMessageBox( HWND_DESKTOP, HWND_DESKTOP,
                 (PCH)str,
                 (PCH)"Error",
                 1,
                 MB_OKCANCEL | MB_APPLMODAL |
                 MB_MOVEABLE | MB_ICONASTERISK);

}

/****************************************************************************
 *
 * FUNCTION NAME = DisplayError
 *
 * DESCRIPTION   = Display error having string from the resource file.
 *
 * INPUT         = hwndOwner     - Owner of message box.
 *                                      if NULL, default is last active window.
 *                 usStringID    - ID of string in resource file.
 *                 usWinStyle    - Window style of message box.
 *                                      if NULL, default is MB_OK.
 *
 * OUTPUT        = User-response value returned by WimMessageBox API.
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

USHORT DisplayError (HWND hwndOwner,
                     HMODULE hModule,
                     USHORT  usStringID,
                     USHORT  usWinStyle )
{
   CHAR   pszTitle[256];               /*  Message-box window title          */
   CHAR   pszText[256];                /*  Message-box window message        */
   USHORT usResponse;
   HAB    hAB;
   ULONG  ulLen = 255L;

   hAB = WinQueryAnchorBlock (HWND_DESKTOP);
   WinLoadString (hAB, hModule, PORT_ERR_TITLE, 255, (PSZ)pszTitle);
   WinLoadString (hAB, hModule, usStringID, 255, (PSZ)pszText);
   if (!hwndOwner)
   {
      hwndOwner = WinQueryActiveWindow (HWND_DESKTOP);
   }
   if (!usWinStyle)
   {
      usWinStyle = MB_OK;
   }
   usResponse = WinMessageBox (HWND_DESKTOP, hwndOwner, pszText, pszTitle, 1,
                              (ULONG)usWinStyle);
   return (usResponse);

}


/*
** Following routines replace Win help manager function calls.
** This is done to avoid automatically loading the help manager
** when the port driver is used.
** DosLoadModule is used to get the help manager function addresses
** and WinHook mechanism is used to get notified of F1 key.
**
** All CallxxHelpxx call equivalent WinxxHelpxx
*/

/****************************************************************************
 *
 * FUNCTION NAME = CALLAssociateHelpInstance
 *
 * DESCRIPTION   =
 *
 * INPUT         =
 *
 * OUTPUT        =
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

BOOL APIENTRY CALLAssociateHelpInstance (HWND hwndHelpInstance,
                                         HWND hwndApp)
{
   ULONG    rc = 0;
   HMODULE  hModule;

   if (!hvHelpmgrModule)
   {
         /*
         ** If there is an error display it and return.
         ** This call should only be made if CreateHelpInstance was called.
         **
         ** This uses an error message from print object and should
         ** be replaced with custom message.
         */
      DosQueryModuleHandle ("WPPRINT", &hModule);

#define STR_BASE                   7000
#define STR_DLL_LOAD_ERROR         (STR_BASE + 36)

      DisplayError (HWND_DESKTOP, hModule, STR_DLL_LOAD_ERROR,
                              MB_OK | MB_APPLMODAL | MB_MOVEABLE);
   }
   else
   {
         /*
         ** Check to see if we have the pointer from a previous call
         */
      if (!pfnWinAssociateHelpInstance)
      {
            /*
            ** Get pointer to the location of the function we want.
            */
         rc = DosQueryProcAddr (hvHelpmgrModule,(ULONG)NULL,
                                     (PSZ)"WIN32ASSOCIATEHELPINSTANCE",
                                     (PFN *)&pfnWinAssociateHelpInstance);
      }
         /*
         ** If no error continue.
         */
      if (!rc )
      {
         rc = (*pfnWinAssociateHelpInstance)(hwndHelpInstance, hwndApp);
            /*
            ** Function returns a bool
            */
         if (rc == TRUE)
            return(TRUE);
      }
   }
   return(FALSE);
}

/****************************************************************************
 *
 * FUNCTION NAME = CALLCreateHelpInstance
 *
 * DESCRIPTION   =
 *
 * INPUT         =
 *
 * OUTPUT        =
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

HWND APIENTRY  CALLCreateHelpInstance (HAB hab,
                                        PHELPINIT phinitHMInitStructure)
{
   ULONG    rc = 0;
   HWND     hwnd = (HWND)NULLHANDLE;
   HMODULE  hModule;

      /*
      ** Check to see if we already have the handle
      */
   if (!hvHelpmgrModule)
      rc = DosLoadModule((PSZ)NULL, 0, (PSZ)"HELPMGR",
                                         (PHMODULE)&hvHelpmgrModule);
   if (rc)
   {
         /*
         ** If there is an error dispaly it and return.
         */
      DosQueryModuleHandle ("WPPRINT", &hModule);
      DisplayError (HWND_DESKTOP, hModule, STR_DLL_LOAD_ERROR,
                              MB_OK | MB_APPLMODAL | MB_MOVEABLE);
   }
   else
   {
      if (!pfnWinCreateHelpInstance)
            /*
            ** Next get pointer to the location of the function we want.
            */
         rc = DosQueryProcAddr (hvHelpmgrModule,(ULONG)NULL,
                                     (PSZ)"WIN32CREATEHELPINSTANCE",
                                     (PFN *)&pfnWinCreateHelpInstance);
         /*
         ** If no error continue.
         */
      if (!rc )
         hwnd = (*pfnWinCreateHelpInstance)(hab, phinitHMInitStructure );

   }
   return(hwnd);
}

/****************************************************************************
 *
 * FUNCTION NAME = CALLDestroyHelpInstance
 *
 * DESCRIPTION   =
 *
 * INPUT         =
 *
 * OUTPUT        =
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

BOOL APIENTRY  CALLDestroyHelpInstance (HWND hwndHelpInstance)
{

   ULONG    rc = 0;
   HMODULE  hModule;

   if (!hvHelpmgrModule)
   {
         /*
         ** If there is an error display it and return.
         */
      DosQueryModuleHandle ("WPPRINT", &hModule);
      DisplayError (HWND_DESKTOP, hModule, STR_DLL_LOAD_ERROR,
                              MB_OK | MB_APPLMODAL | MB_MOVEABLE);
   }
   else
   {
      if (!pfnWinDestroyHelpInstance)
            /*
            ** Next get pointer to the location of the function we want.
            */
         rc = DosQueryProcAddr (hvHelpmgrModule,(ULONG)NULL,
                                     (PSZ)"WIN32DESTROYHELPINSTANCE",
                                     (PFN *)&pfnWinDestroyHelpInstance);
         /*
         ** If no error continue.
         */
      if (!rc )
      {
         rc = (*pfnWinDestroyHelpInstance)(hwndHelpInstance);
            /*
            ** Function returns a bool
            */
         if (rc == TRUE)
         {
            return(TRUE);
         }
      }
   }
   return(FALSE);
}

/****************************************************************************
 *
 * FUNCTION NAME = CALLQueryHelpInstance
 *
 * DESCRIPTION   =
 *
 * INPUT         =
 *
 * OUTPUT        =
 *
 * RETURN-NORMAL =
 *
 * RETURN-ERROR  =
 *
 ****************************************************************************/

HWND APIENTRY CALLQueryHelpInstance (HWND hwndApp)
{
   ULONG    rc = 0;
   HWND     hwnd = (HWND)NULLHANDLE;
   HMODULE  hModule;

   if (!hvHelpmgrModule)
   {
         /*
         ** If there is an error display it and return.
         */
      DosQueryModuleHandle ("WPPRINT", &hModule);
      DisplayError (HWND_DESKTOP, hModule, STR_DLL_LOAD_ERROR,
                              MB_OK | MB_APPLMODAL | MB_MOVEABLE);
   }
   else
   {
      if (!pfnWinQueryHelpInstance)
            /*
            ** Get pointer to the location of the function we want.
            */
         rc = DosQueryProcAddr (hvHelpmgrModule,(ULONG)NULL,
                                     (PSZ)"WIN32QUERYHELPINSTANCE",
                                     (PFN *)&pfnWinQueryHelpInstance);
         /*
         ** If no error continue.
         */
      if (!rc )
      {
            /*
            ** Make sure that the handle is associated with this instance
            **
            ** Make call
            */
         hwnd = (*pfnWinQueryHelpInstance)( hwndApp);

      }
   }
   return(hwnd);
}

/****************************************************************************
 *
 * FUNCTION NAME = SetHelpStubHook
 *
 * DESCRIPTION   =
 *
 * INPUT         =
 *
 * OUTPUT        =
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

BOOL EXPENTRY SetHelpStubHook()
{
    if(!HelpStubHookIsSet)
    {
        if(WinSetHook(0L, HMQ_CURRENT, HK_HELP, (PFN)HelpStubHook, 0L))
        {
            HelpStubHookIsSet = TRUE;
            return TRUE;
        }
    }
    return FALSE;
}

/****************************************************************************
 *
 * FUNCTION NAME = ReleaseHelpStubHook
 *
 * DESCRIPTION   =
 *
 * INPUT         =
 *
 * OUTPUT        =
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

VOID EXPENTRY ReleaseHelpStubHook()
{
    if(HelpStubHookIsSet)
    {
        WinReleaseHook(0L, HMQ_CURRENT, HK_HELP, (PFN)HelpStubHook, 0L);
        HelpStubHookIsSet = FALSE;
    }
}

/****************************************************************************
 *
 * FUNCTION NAME = HelpStubHook
 *
 * DESCRIPTION   =
 *
 * INPUT         =
 *
 * OUTPUT        =
 *
 * RETURN-NORMAL =
 *
 * RETURN-ERROR  =
 *
 ****************************************************************************/

INT EXPENTRY HelpStubHook(HAB AppHAB,
                          USHORT Context,
                          USHORT IdTopic,
                          USHORT IdSubTopic,
                          PRECTL RectLPtr )
{
    AppHAB;                            /* avoid compile warning              */
    Context;
    IdTopic;
    IdSubTopic;
    RectLPtr;

    InitializeHelp();

    return FALSE;
}

/****************************************************************************
 *
 * FUNCTION NAME = InitializeHelp
 *
 * DESCRIPTION   =
 *
 * INPUT         =
 *
 * OUTPUT        =
 *
 * RETURN-NORMAL =
 * RETURN-ERROR  =
 *
 ****************************************************************************/

VOID EXPENTRY InitializeHelp()
{
    HAB     hAB;
    HWND    hWnd;
    HWND    hWndActive;
    ULONG   ulBootDrive;
    HMODULE hModule;
    CHAR    szBuf[256];
    CHAR    szPathName[260];   /* will contain full path to this port driver */

    if(HelpAlreadyInitialized)   return;

       /*
       ** Initialize Help
       ** ---------------
       **
       ** Create an instance of the Help Manager, and associate it
       ** with the Frame.  If the Association fails, we handle it
       ** the same way as if the creation fails, ie hwndHelp
       ** (the Help Manager Object Window handle) is set to NULL.
       ** If we can't load the Module containing the Help Panel
       ** definitions, we forget Help altogether.
       */
    hWndActive = WinQueryActiveWindow(HWND_DESKTOP);
    hWnd = WinQueryWindow(hWndActive,QW_OWNER);
       /*
       ** if unable to get active window's owner
       **    use active window
       */
    if (hWnd == (HWND)NULL)
       hWnd = hWndActive ;

       /*
       ** We need our module handle.
       ** Easiest way to do this is to find the path to our port driver
       **  from the system INI file.
       ** If not found in the INI file
       **  assume it is in the boot drive's \OS2\DLL directory
       */

    /* change ? in szDefaultPortDrvPath to boot drive */
    DosQuerySysInfo (QSV_BOOT_DRIVE, QSV_BOOT_DRIVE, &ulBootDrive,
                     sizeof (ULONG));
    szDefaultPortDrvPath[0] = (CHAR)(ulBootDrive + 'A' - 1);

    PrfQueryProfileString (HINI_SYSTEMPROFILE,
                           "PM_PORT_DRIVER",
                           "SERIAL",
                           szDefaultPortDrvPath,
                           szPathName,
                           256 );

       /*
       ** get module handle for our dll
       */
    DosQueryModuleHandle (szPathName, &hModule);

       /*
       ** Initialize a couple of the helpmgr structure elements
       ** First, get the title
       **
       ** Now load the title
       */
    WinLoadString (hAB, hModule,
                      (USHORT)(PORT_HELP_TITLE), (SHORT)(256), szBuf);
    hmiHelpData.pszHelpWindowTitle = (PSZ)szBuf;
    hmiHelpData.pszHelpLibraryName = "WPHELP.HLP";

    hAB = WinQueryAnchorBlock(hWnd);

       /*
       ** Only create a handle if we don't have one.
       */
    if (hwndHelp == 0L)
       hwndHelp = CALLCreateHelpInstance(hAB, &hmiHelpData);

       /*
       ** Always associate the helpmgr handle with the active window
       */
    if (hwndHelp != 0L)
    {
       if(!CALLAssociateHelpInstance(hwndHelp, hWnd) )
       {
           CALLDestroyHelpInstance(hwndHelp);
           hwndHelp = (HWND)0L;
       }
    }

       /*
       ** If help was initialized, get rid of our hook. Otherwise, we have
       ** to ensure that our stub hook is the FIRST hook in the HK_HELP
       ** hook chain.
       */
    if (hwndHelp != 0L)
    {
        HelpAlreadyInitialized = TRUE;
        ReleaseHelpStubHook();
    }
    else
    {
        ReleaseHelpStubHook();
        SetHelpStubHook();
    }
}
