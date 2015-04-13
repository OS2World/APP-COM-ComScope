/**************************************************************************
 *
 * SOURCE FILE NAME = HELP.C
 *
 * DESCRIPTIVE NAME = Serial Port Driver Help Routines
 *
 *
 *
 * COPYRIGHT    Copyright (C) 1992 IBM Corporation
 *              and 1995 OS/tools Incorporated
 *
 * The following IBM OS/2 2.1 source code is provided to you solely for
 * the purpose of assisting you in your development of OS/2 2.x device
 * drivers. You may use this code in accordance with the IBM License
 * Agreement provided in the IBM Device Driver Source Kit for OS/2. This
 * Copyright statement may not be removed.
 *
 * This is the Help sub-set for the serial PDR driver as described above.
 *
 *
 ***************************************************************************/

#include "COMi_CFG.H"
#include <UTILITY.H>

/*
** Global handle for helpmgr module, so it is only loaded once
*/

static HWND hwndHelpFrame;
BOOL bFrameCreated = FALSE;

HMODULE  hvHelpmgrModule;

extern HMODULE hThisModule;

BOOL EXPENTRY SetHelpStubHook();
VOID EXPENTRY InitializeHelp(void);
BOOL EXPENTRY SetHelpStubHook(void);
int EXPENTRY HelpStubHook(HAB hab,USHORT Context,USHORT IdTopic,USHORT IdSubTopic,PRECTL RectLPtr );

HWND hwndHelp;
BOOL bHelpStubHookIsSet;        /* for help */
BOOL bHelpAlreadyInitialized;   /* for help */
/*
** HELPINIT -- help manager initialization structure
*/
static HELPINIT hmiHelpData = {sizeof(HELPINIT),
                               0L,
                          (PSZ)NULL,
                   (PHELPTABLE)NULL,
                      (HMODULE)NULL,
                      (HMODULE)NULL,
                       (USHORT)NULL,
                       (USHORT)NULL,
                          (PSZ)NULL,
                               CMIC_HIDE_PANEL_ID,
                          (PSZ)"CONFIG.HLP"};



BOOL (* APIENTRY pfnWinAssociateHelpInstance)(HWND, HWND);
BOOL (* APIENTRY pfnWinCreateHelpInstance)(HAB, PHELPINIT);
BOOL (* APIENTRY pfnWinDestroyHelpInstance)(HWND);
BOOL (* APIENTRY pfnWinQueryHelpInstance)(HWND);

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

BOOL APIENTRY CALLAssociateHelpInstance(HWND hwndHelpInstance,HWND hwndApp)
  {
  ULONG    rc = 0;
  HMODULE  hModule;
#ifdef DEBUG
  ERRORID eidError;
  char szMessage[80];
#endif

  if (!hvHelpmgrModule)
    {
    MessageBox(HWND_DESKTOP,"Help module not loaded");
#ifdef this_junk
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
#endif
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
#ifdef DEBUG
      eidError = WinGetLastError(WinQueryAnchorBlock(hwndApp));
      sprintf(szMessage,"Unable to associate help instance.\n\nError Code = %08X",eidError);
      DE(szMessage);
#endif
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

HWND APIENTRY CALLCreateHelpInstance(HAB hab,PHELPINIT phinitHMInitStructure)
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
    MessageBox(HWND_DESKTOP,"Unable to load Help module");
#ifdef this_junk
    /*
    ** If there is an error dispaly it and return.
    */
    DosQueryModuleHandle ("WPPRINT", &hModule);
    DisplayError (HWND_DESKTOP, hModule, STR_DLL_LOAD_ERROR,
                              MB_OK | MB_APPLMODAL | MB_MOVEABLE);
#endif
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
  BOOL bSuccess = FALSE;

  if (!hvHelpmgrModule)
    {
    MessageBox(HWND_DESKTOP,"Help module not loaded");
#ifdef this_junk
    /*
    ** If there is an error display it and return.
    */
    DosQueryModuleHandle ("WPPRINT", &hModule);
    DisplayError (HWND_DESKTOP, hModule, STR_DLL_LOAD_ERROR,
                              MB_OK | MB_APPLMODAL | MB_MOVEABLE);
#endif
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
      bSuccess = (*pfnWinDestroyHelpInstance)(hwndHelpInstance);
    }
  if (bFrameCreated)
    {
    WinDestroyWindow(hwndHelpFrame);
#ifdef DEBUG
    DE("Frame Destoyed");
#endif
    bFrameCreated = FALSE;
    }
  return(bSuccess);
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

HWND APIENTRY CALLQueryHelpInstance(HWND hwndApp)
  {
  ULONG    rc = 0;
  HWND     hwnd = (HWND)NULLHANDLE;
  HMODULE  hModule;

  if (!hvHelpmgrModule)
    {
   MessageBox(HWND_DESKTOP,"Help module not loaded");
#ifdef this_junk
    /*
    ** If there is an error display it and return.
    */
    DosQueryModuleHandle ("WPPRINT", &hModule);
    DisplayError (HWND_DESKTOP, hModule, STR_DLL_LOAD_ERROR,
                              MB_OK | MB_APPLMODAL | MB_MOVEABLE);
#endif
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
  if(!bHelpStubHookIsSet)
    {
    if(WinSetHook(0L, HMQ_CURRENT, HK_HELP, (PFN)HelpStubHook, 0L))
      {
      bHelpStubHookIsSet = TRUE;
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

VOID EXPENTRY ReleaseHelpStubHook(void)
  {
  if(bHelpStubHookIsSet)
    {
    WinReleaseHook(0L, HMQ_CURRENT, HK_HELP, (PFN)HelpStubHook, 0L);
    bHelpStubHookIsSet = FALSE;
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

int EXPENTRY HelpStubHook(HAB hab,USHORT Context,USHORT IdTopic,USHORT IdSubTopic,PRECTL RectLPtr )
  {
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

VOID EXPENTRY InitializeHelp(void)
  {
  HAB     hab;
  HWND    hwndActive;
  CHAR    szBuf[256];
  ULONG   flCreate;
  PHWND pClient;
  ERRORID eidError;

  if(bHelpAlreadyInitialized)
    {
#ifdef DEBUG
    DE("Help already initialized");
#endif
    return;
    }

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
  hwndActive = WinQueryActiveWindow(HWND_DESKTOP);
  hab = WinQueryAnchorBlock(hwndActive);
  hwndHelpFrame = WinQueryWindow(hwndActive,QW_OWNER);
  /*
  ** if unable to get active window's owner
  **    use active window
  */
  if (hwndHelpFrame == (HWND)NULL)
    {
    /*
    **  Help won't associate if there is no frame window in the chain
    **
    **  IF there is no parent window handle then we create a frame window
    **  for the help association.
    */
    if (!bFrameCreated)
      {
      flCreate =  FCF_SHELLPOSITION;
      hwndHelpFrame = WinCreateStdWindow(HWND_DESKTOP,0L,&flCreate,0L,0L,0L,0L,1,pClient);
#ifdef DEBUG
      if (hwndHelpFrame == 0)
        {
        eidError = WinGetLastError(hAB);
        sprintf(szBuf,"Error Creating Frame Window.\n\n%08X",eidError);
        DE(szBuf);
        }
      DE("Frame Created");
#endif
      bFrameCreated = TRUE;
      }
    }
  /*
  ** Initialize a couple of the helpmgr structure elements
  ** First, get the title
  **
  ** Now load the title
  hAB = WinQueryAnchorBlock(hwndActive);
  WinLoadString (hAB, hThisModule,
                    (USHORT)(PORT_HELP_TITLE), (SHORT)(256), szBuf);
  */
  hmiHelpData.pszHelpWindowTitle = "COMi Configuration Help";
  hmiHelpData.pszHelpLibraryName = "CONFIG.HLP";


  /*
  ** Only create a handle if we don't have one.
  */
  if (hwndHelp == 0L)
    hwndHelp = CALLCreateHelpInstance(hab, &hmiHelpData);

  /*
  ** Always associate the helpmgr handle with the active window
  */
  if (hwndHelp != 0L)
    {
    if(!CALLAssociateHelpInstance(hwndHelp,hwndHelpFrame))
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
    bHelpAlreadyInitialized = TRUE;
    ReleaseHelpStubHook();
    }
  else
    {
    ReleaseHelpStubHook();
    SetHelpStubHook();
    }
  }
