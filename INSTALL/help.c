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

#include "COMMON.H"
#include "UTILITY.H"
#include "install.h"

#include "resource.h"

extern INSTALL stInst;

char szHelpWindowTitle[] = {"OS/tools Installation Help"};

extern char szAppVersion[];
extern char szCOMiVersion[];
extern char szCOMscopeVersion[];
extern char szInstallVersion[];

extern char szDriverVersionString[];
HWND hwndInstallHelpInstance;

extern BOOL pfnMessageBoxHelpHook(HAB hab,SHORT sMode,SHORT sTopic,SHORT sSubTopic,PRECTL prclPosition);

MRESULT EXPENTRY fnwpAboutBoxDlgProc(HWND hwnd, ULONG msg,MPARAM mp1, MPARAM mp2);
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
HWND HelpInit(char szLibName[],char szWindowTitle[])
  {
  char szMessage[200];
  HELPINIT hini;
  HWND hwndHelpInstance = 0;

  // if we return because of an error, Help will be disabled
  // inititalize help init structure
  hini.cb = sizeof(HELPINIT);
  hini.ulReturnCode = 0L;
  hini.pszTutorialName = (PSZ)NULL;   // if tutorial added, add name here

//  hini.phtHelpTable = (PHELPTABLE)MAKELONG(INSTALL_HELP_TABLE, 0xFFFF);
  hini.phtHelpTable = (PHELPTABLE)0;
  hini.hmodHelpTableModule = (HMODULE)0;
  hini.hmodAccelActionBarModule = (HMODULE)0;
  hini.idAccelTable = 0;
  hini.idActionBar = 0;
  hini.pszHelpWindowTitle = (PSZ)szWindowTitle;

  // if debugging, show panel ids, else don't
#ifdef DEBUG_HELP
  hini.fShowPanelId = CMIC_SHOW_PANEL_ID;
#else
  hini.fShowPanelId = CMIC_HIDE_PANEL_ID;
#endif
  hini.pszHelpLibraryName = (PSZ)szLibName;

  // creating help instance
  hwndHelpInstance = WinCreateHelpInstance(stInst.hab, &hini);

  if((hwndHelpInstance != 0)  && (hini.ulReturnCode == 0))
    {
    // associate help instance with main frame
    if(!WinAssociateHelpInstance(hwndHelpInstance, stInst.hwndFrame))
      {
      sprintf(szMessage,"Unable to associate help instance with file %s - %u",szLibName,stInst.hwndFrame);
      MessageBox(stInst.hwndFrame,szMessage);
      return(0);
      }
    }
  else
    {
    sprintf(szMessage,"Unable to load help file  %s",szLibName);
    MessageBox(stInst.hwndFrame,szMessage);
    return(0);
    }
  WinSetHook(stInst.hab,HMQ_CURRENT,HK_HELP,(PFN)pfnMessageBoxHelpHook,0L);
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
  if(hwndInstallHelpInstance != 0)
    if(WinSendMsg(hwndInstallHelpInstance, HM_DISPLAY_HELP, NULL, NULL))
       MessageBox(stInst.hwndFrame,"Unable to display Help Panel");
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
  if(hwndInstallHelpInstance != 0)

/*
    if (WinSendMsg(hwndInstallHelpInstance,PANEL_EXTENDED_CONTENTS,
                 MPFROMSHORT(PANEL_EXTENDED_CONTENTS), NULL))
       MessageBox(stInst.hwndFrame,
             IDS_HELPDISPLAYERROR,
             MB_OK | MB_ERROR,
             FALSE);
*/
    if(WinSendMsg(hwndInstallHelpInstance, HM_EXT_HELP, NULL, NULL))
       MessageBox(stInst.hwndFrame,"Unable to display Help Panel");
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
  if(hwndInstallHelpInstance != 0)
    if(WinSendMsg(hwndInstallHelpInstance, HM_KEYS_HELP, MPFROMSHORT(HM_KEYS_HELP), NULL))
       MessageBox(stInst.hwndFrame,"Unable to display Help Panel");
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
  if(hwndInstallHelpInstance != 0)
    if(WinSendMsg(hwndInstallHelpInstance, HM_HELP_INDEX, NULL, NULL))
       MessageBox(stInst.hwndFrame,"Unable to display Help Panel");
  }

/****************************************************************\
 *  Processes the About command from the Help menu
 *--------------------------------------------------------------
 *
 *  Name:   HelpAbout(mp2)
 *
 *  Purpose: Processes the WM_COMMAND message posted by the
 *         About item of the Help menu
 *
 *  Usage:  Called from MainCommand when the About
 *       menu item is selected
 *
 *  Method: Calls WinDlgBox to display the about box dialog.
 *
 *  Returns:
 *
\****************************************************************/
VOID  HelpAbout(void)
  {
  /*
  ** display the AboutBox dialog
  */
  WinDlgBox(HWND_DESKTOP,
         stInst.hwndFrame,
         (PFNWP)fnwpAboutBoxDlgProc,
         (HMODULE)0,
         INST_ABOUT,
         (PVOID)NULL);
  }


/****************************************************************\
 *  Displays the help panel indicated
 *--------------------------------------------------------------
 *
 *  Name:   DisplayHelpPanel(idPanel)
 *
 *  Purpose: Displays the help panel whose id is given
 *
 *  Usage:  Called whenever a help panel is desired to be
 *       displayed, usually from the WM_HELP processing
 *       of the dialog boxes
 *
 *  Method: Sends HM_DISPLAY_HELP message to the help instance
 *
 *  Returns:
 *
\****************************************************************/
void DisplayHelpPanel(USHORT idPanel) /* ID of help panel to display */
  {
  if (hwndInstallHelpInstance != 0)
    if (WinSendMsg(hwndInstallHelpInstance, HM_DISPLAY_HELP,
                   MPFROM2SHORT(idPanel, NULL), MPFROMSHORT(HM_RESOURCEID)))
       MessageBox(stInst.hwndFrame,"Unable to display Help Panel");
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
VOID DestroyHelpInstance(HWND hwndHelpInstance)
  {
  WinReleaseHook(stInst.hab,HMQ_CURRENT,HK_HELP,(PFN)pfnMessageBoxHelpHook,0L);
  if(hwndHelpInstance != 0)
    WinDestroyHelpInstance(hwndHelpInstance);
  }

MRESULT EXPENTRY fnwpAboutBoxDlgProc(HWND hwndDlg,ULONG msg,MPARAM mp1,MPARAM mp2)
  {
  char szString[80];

  switch(msg)
    {
    case WM_INITDLG:
      CenterWindow(hwndDlg);
      if (strlen(szCOMiVersion) != 0)
        WinSetDlgItemText(hwndDlg,VER_ONE,szCOMiVersion);
      if (strlen(szCOMscopeVersion) != 0)
        WinSetDlgItemText(hwndDlg,VER_TWO,szCOMscopeVersion);
      if (strlen(szAppVersion) != 0)
        WinSetDlgItemText(hwndDlg,VER_THREE,szAppVersion);
      if (strlen(szInstallVersion) != 0)
        WinSetDlgItemText(hwndDlg,VER_INSTALL,szInstallVersion);
      break;
    case WM_COMMAND:
      WinDismissDlg(hwndDlg,TRUE);
      break;
    default:
      return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
    }
  return 0L;
  }

#ifdef this_junk
MRESULT EXPENTRY COMscopeOpenFilterProc(HWND hwnd,ULONG message,MPARAM mp1,MPARAM mp2);
/**************************************************************************
 *** COMscopeOpenFilterProc - This is a procedure that will filter the help
 *                           messages to the open dialog.
***************************************************************************/
MRESULT EXPENTRY COMscopeOpenFilterProc(HWND hwnd,ULONG message,MPARAM mp1,MPARAM mp2)
  {
  if(message == WM_HELP)
    {
    DisplayHelpPanel(HLPP_FILE_OPEN);
    return FALSE ;
    }
  return WinDefFileDlgProc(hwnd,message,mp1,mp2);
  }

/****************************************************************\
 *  Shows the help panel for the given dialog window
 *--------------------------------------------------------------
 *
 *  Name:   ShowDlgHelp(hwnd)
 *
 *  Purpose: Displays the help panel for the current selected
 *        item in the dialog window
 *
 *  Usage:  Called each time a WM_HELP message is posted to
 *       a dialog
 *
 *  Method: gets the id value of the window and determine which
 *       help panel to display.  Then sends a message to
 *       the help instance to display the panel.  If the dialog
 *       or item is not included here, then the unknown dialog
 *       or unknown item panel is displayed.
 *
 *  Returns:
 *
\****************************************************************/
VOID ShowDlgHelp(HWND hwnd)
  {
  USHORT idDlg;
  USHORT idItem;
  USHORT idPanel;
  HWND hwndFocus;

  idDlg = WinQueryWindowUShort(hwnd, QWS_ID);

  // finds which window has the focus and gets its id
  hwndFocus = WinQueryFocus(HWND_DESKTOP);
  idItem = WinQueryWindowUShort(hwndFocus, QWS_ID);
  switch(idDlg)
    {
    case PCFG_MAIN:
      switch(idItem)
        {
        case DID_OEM:
          idPanel = HLPP_OEM_SETUP;
          break;
        case PCFG_DEV_NAME:
#ifndef CONFIG_ONLY
          if (!bIsInstall)
            idPanel = HLPP_DEVICE_NAME;
          else
#endif
            idPanel = HLPP_CONFIG_DEVICE_NAME;
          break;
        case PCFG_ADD_LOAD:
          idPanel = HLPP_ADD_LOAD;
          break;
        case PCFG_DELETE_LOAD:
          idPanel = HLPP_REMOVE_LOAD;
          break;
        case PCFG_VERBOSE:
          idPanel = HLPP_VERBOSE;
          break;
        case PCFG_KEY_WAIT:
          idPanel = HLPP_KEY_WAIT;
          break;
        case PCFG_DEVICE_LIST:
          idPanel = HLPP_DEVICE_LIST;
          break;
        case DID_INSTALL:
          idPanel = HLPP_EDIT_DEVICE;
          break;
        case DID_INSERT:
          idPanel = HLPP_ADD_DEVICE;
          break;
        case DID_DELETE:
          idPanel = HLPP_REMOVE_DEVICE;
          break;
        case DID_CANCEL:
          idPanel = HLPP_CANCEL;
          break;
        case DID_OK:
          idPanel = HLPP_OK;
          break;
        default:
          idPanel = HLPP_UNKNOWN;
          break;
        }
      break;
    default:
      idPanel = HLPP_UNKNOWNDLG;
      break;
    }
  DisplayHelpPanel(idPanel);
  }
#endif
BOOL pfnMessageBoxHelpHook(HAB hab,SHORT sMode,SHORT sTopic,SHORT sSubTopic,PRECTL prclPosition)
  {
  if (sMode == HLPM_WINDOW)
    {
    DisplayHelpPanel(sTopic);
    return(TRUE);
    }
  return(FALSE);
  }


