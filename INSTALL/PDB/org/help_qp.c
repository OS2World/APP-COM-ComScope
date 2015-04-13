/******************************************************************************
*
*  File Name   : HELP.C
*
*  Description : This module contains all the routines for interfacing with
*                the IPF help manager.
*
*  Concepts    : Using the Information Presentation Facility for help
*
*  Entry Points:
*                AboutBoxDlgProc()
*                DestroyHelpInstance()
*                DisplayHelpPanel()
*                HelpAbout()
*                HelpExtended()
*                HelpHelpForHelp()
*                HelpIndex()
*                HelpInit()
*                HelpTutorial()
*                ShowDlgHelp()
*
*  Copyright (C) 1992 IBM Corporation
*
*      DISCLAIMER OF WARRANTIES.  The following [enclosed] code is
*      sample code created by IBM Corporation. This sample code is not
*      part of any standard or IBM product and is provided to you solely
*      for  the purpose of assisting you in the development of your
*      applications.  The code is provided "AS IS", without
*      warranty of any kind.  IBM shall not be liable for any damages
*      arising out of your use of the sample code, even if they have been
*      advised of the possibility of such damages.                                                    *
*
******************************************************************************/

/*--------------------------------------------------------------
 *  Include files, macros, defined constants, and externs
  --------------------------------------------------------------*/

/*
 * If DEBUG is defined, then the help panels will display their
 *  id values on their title bar.  This is useful for determining
 *  which help panels are being shown for each dialog item.  When
 *  the DEBUG directive is not defined, then the panel ids are not
 *  displayed.
 */
#include <COMMON.H>
#include <safepage.h>

#include "QPG_CFG.H"

HWND hwndHelpInstance;
static BOOL fHelpEnabled = FALSE;

static char szHelpTitle[] = "QuickPage Configuration Help";
static char szHelpFileSpec[CCHMAXPATH + 1];

extern BOOL pfnMessageBoxHelpHook(HAB hab,SHORT sMode,SHORT sTopic,SHORT sSubTopic,PRECTL prclPosition);

MRESULT EXPENTRY AboutBoxDlgProc(HWND hwnd, ULONG msg,MPARAM mp1, MPARAM mp2);
VOID ShowDlgHelp(HWND hwnd);

/****************************************************************\
 *  Routine for initializing the help manager
 *--------------------------------------------------------------
 *
 *  Name:   HelpInit()
 *
 *  Purpose: Initializes the IPF help facility
 *
 *  Usage:  Called once during initialization of the program
 *
 *  Method: Initializes the HELPINIT structure and creates the
 *       help instance.  If successful, the help instance
 *       is associated with the main window
 *
 *  Returns:
 *
\****************************************************************/
BOOL HelpInit(PAGECFG *pstCFG)
  {
  char szMessage[200];
  HELPINIT hini;
  HWND hwndHelpInstance;

  fHelpEnabled = FALSE;

  hini.cb = sizeof(HELPINIT);
  hini.ulReturnCode = 0L;
  hini.pszTutorialName = (PSZ)NULL;

  hini.phtHelpTable = 0;//(PHELPTABLE)MAKELONG(COMSCOPE_HELP_TABLE, 0xFFFF);
  hini.hmodHelpTableModule = (HMODULE)0;
  hini.hmodAccelActionBarModule = (HMODULE)0;
  hini.idAccelTable = 0;
  hini.idActionBar = 0;
  hini.pszHelpWindowTitle = szHelpTitle;

  // if debugging, show panel ids, else don't
#if DEBUG > 0
  hini.fShowPanelId = CMIC_SHOW_PANEL_ID;
#else
  hini.fShowPanelId = CMIC_HIDE_PANEL_ID;
#endif
  hini.pszHelpLibraryName = szHelpFileSpec;

  sprintf(szHelpFileSpec,"%s\\%s",pstCFG->pszDestPath,pstCFG->pszHelpFileName);
  // creating help instance
  hwndHelpInstance = WinCreateHelpInstance(pstCFG->hab,&hini);

  if((hwndHelpInstance != 0)  && (hini.ulReturnCode == 0))
    {
    // associate help instance with main frame
    if(!WinAssociateHelpInstance(hwndHelpInstance,pstCFG->hwndFrame))
      {
      sprintf(szMessage,"Unable to associate help instance with file %s - %u",szHelpFileSpec,pstCFG->hwndFrame);
      MessageBox(szMessage,(MB_OK | MB_ERROR));
      return(0);
      }
    }
  else
    {
    sprintf(szMessage,"Unable to load help file %s - %u",szHelpFileSpec,strlen(szHelpFileSpec));
    hwndHelpInstance = 0;
    MessageBox(szMessage,(MB_OK | MB_ERROR));
    return(0);
    }
  /*
  ** help manager is successfully initialized so set flag to TRUE
  */
  fHelpEnabled = TRUE;
  WinSetHook(pstCFG->hab,HMQ_CURRENT,HK_HELP,(PFN)pfnMessageBoxHelpHook,0L);
  return(hwndHelpInstance);
  }


/****************************************************************\
 *  Processes the Help for Help command from the menu bar
 *--------------------------------------------------------------
 *
 *  Name:   HelpHelpForHelp(mp2)
 *
 *  Purpose: Processes the WM_COMMAND message posted by the
 *         Help for Help item of the Help menu
 *
 *  Usage:  Called from MainCommand when the Help for Help
 *       menu item is selected
 *
 *  Method: Sends an HM_DISPLAY_HELP message to the help
 *       instance so that the default Help For Help is
 *       displayed.
 *
 *  Returns:
 *
\****************************************************************/
VOID  HelpHelpForHelp(void)
  {

  /*
  ** this just displays the system help for help panel
  */
  if(fHelpEnabled)
    if(WinSendMsg(hwndHelpInstance, HM_DISPLAY_HELP, NULL, NULL))
       MessageBox("Unable to display Help Panel",(MB_OK | MB_ERROR));
}


/****************************************************************\
 *  Processes the Extended Help command from the menu bar
 *--------------------------------------------------------------
 *
 *  Name:   HelpExtended( VOID )
 *
 *  Purpose: Processes the WM_COMMAND message posted by the
 *         Extended Help item of the Help menu
 *
 *  Usage:  Called from MainCommand when the Extended Help
 *       menu item is selected
 *
 *  Method: Sends an HM_EXT_HELP message to the help
 *       instance so that the default Extended Help is
 *       displayed.
 *
 *  Returns:
 *
\****************************************************************/
VOID  HelpExtended(VOID)
  {

  /*
  ** this just displays the system extended help panel
  */
  if(fHelpEnabled)

/*
    if (WinSendMsg(hwndHelpInstance,PANEL_EXTENDED_CONTENTS,
                 MPFROMSHORT(PANEL_EXTENDED_CONTENTS), NULL))
       MessageBox(hwndFrame,
             IDS_HELPDISPLAYERROR,
             MB_OK | MB_ERROR,
             FALSE);
*/
    if(WinSendMsg(hwndHelpInstance, HM_EXT_HELP, NULL, NULL))
       MessageBox("Unable to display Help Panel",(MB_OK | MB_ERROR));
  }

/****************************************************************\
 *  Processes the Keys Help command from the menu bar
 *--------------------------------------------------------------
 *
 *  Name:   HelpKeys(mp2)
 *
 *  Purpose: Processes the WM_COMMAND message posted by the
 *         Keys Help item of the Help menu
 *
 *  Usage:  Called from MainCommand when the Keys Help
 *       menu item is selected
 *
 *  Method: Sends an HM_KEYS_HELP message to the help
 *       instance so that the default Keys Help is
 *       displayed.
 *
 *  Returns:
 *
\****************************************************************/
VOID  HelpKeys(void)
  {
  /*
  ** this just displays the system keys help panel
  */
  if(fHelpEnabled)
    if(WinSendMsg(hwndHelpInstance, HM_KEYS_HELP, MPFROMSHORT(HM_KEYS_HELP), NULL))
       MessageBox("Unable to display Help Panel",(MB_OK | MB_ERROR));
  }


/****************************************************************\
 *  Processes the Index Help command from the menu bar
 *--------------------------------------------------------------
 *
 *  Name:   HelpIndex(mp2)
 *
 *  Purpose: Processes the WM_COMMAND message posted by the
 *         Index Help item of the Help menu
 *
 *  Usage:  Called from MainCommand when the Index Help
 *       menu item is selected
 *
 *  Method: Sends an HM_INDEX_HELP message to the help
 *       instance so that the default Index Help is
 *       displayed.
 *
 *  Returns:
 *
\****************************************************************/
VOID  HelpIndex(void)
  {

  /*
  ** this just displays the system help index panel
  */
  if(fHelpEnabled)
    if(WinSendMsg(hwndHelpInstance, HM_HELP_INDEX, NULL, NULL))
       MessageBox("Unable to display Help Panel",(MB_OK | MB_ERROR));
  }

 /****************************************************************\
 *  Destroys the help instance
 *--------------------------------------------------------------
 *
 *  Name:   DestroyHelpInstance(VOID)
 *
 *  Purpose: Destroys the help instance for the application
 *
 *  Usage:  Called after exit from message loop
 *
 *  Method: Calls WinDestroyHelpInstance() to destroy the
 *       help instance
 *
 *  Returns:
 *
\****************************************************************/
VOID DestroyHelpInstance(PAGECFG *pstCFG)
  {
  WinReleaseHook(pstCFG->hab,HMQ_CURRENT,HK_HELP,(PFN)pfnMessageBoxHelpHook,0L);
  if(hwndHelpInstance)
    WinDestroyHelpInstance(hwndHelpInstance);
  hwndHelpInstance = 0;
  }

VOID DisplayHelpPanel(SHORT idPanel)
  {
  if (hwndHelpInstance != 0)
    {
    if (WinSendMsg(hwndHelpInstance,HM_DISPLAY_HELP,
                   MPFROM2SHORT(idPanel,NULL),MPFROMSHORT(HM_RESOURCEID)))
       MessageBox("Unable to display Help Panel",(MB_OK | MB_ERROR));
    }
  else
    MessageBox("Help is not Initialized",(MB_OK | MB_ERROR));
  }

BOOL pfnMessageBoxHelpHook(HAB hab,SHORT sMode,SHORT sTopic,SHORT sSubTopic,PRECTL prclPosition)
  {
  if (sMode == HLPM_WINDOW)
    {
    DisplayHelpPanel(sTopic);
    return(TRUE);
    }
  return(FALSE);
  }


