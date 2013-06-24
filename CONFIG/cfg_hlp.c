/**************************************************************************
 *
 *  CFG_HLP.C
 *
 *  COMi conifiguration help routines
 *
 ***************************************************************************/

#include "COMMON.H"
#include "COMDD.H"
#include "ioctl.h"
#include "UTILITY.H"

#include "help.h"
#include "COMi_CFG.H"


#if DEBUG > 0
extern BOOL bNoDEBUGhelp;
#endif
static HWND hwndHelpFrame;
static BOOL bFrameCreated = FALSE;
static HWND hwndHelpInstance;
static HWND hwndSaveHelp;

extern HMODULE hThisModule;

BOOL pfnMessageBoxHelpHook(HAB hab,USHORT sMode,USHORT sTopic,USHORT sSubTopic,PRECTL prclPosition);

VOID DisplayHelpPanel(COMICFG *pstCOMiCFG,USHORT idPanel)
  {
  char szMessage[100];
#if DEBUG > 0
  if (bNoDEBUGhelp)
    {
    MessageBox(HWND_DESKTOP,"Help is disabled for debugging");
    return;
    }
#endif
  if (pstCOMiCFG->hwndHelpInstance != 0)
    {
    if (WinSendMsg(pstCOMiCFG->hwndHelpInstance,HM_DISPLAY_HELP,
                   MPFROM2SHORT(idPanel,NULL),MPFROMSHORT(HM_RESOURCEID)))
       {
       sprintf(szMessage,"Unable to display Help Panel #%u",idPanel);
       MessageBox(HWND_DESKTOP,szMessage);
       }
    }
  else
    MessageBox(HWND_DESKTOP,"Help is not Initialized");
  }


BOOL pfnMessageBoxHelpHook(HAB hab,USHORT sMode,USHORT sTopic,USHORT sSubTopic,PRECTL prclPosition)
  {
  COMICFG stCOMiCFG;

#if DEBUG > 0
  MessageBox(HWND_DESKTOP,"COMi_CFG Message Box Hook Entered");
#endif
  if (sMode == HLPM_WINDOW)
    {
    stCOMiCFG.hwndHelpInstance = hwndHelpInstance;
    DisplayHelpPanel(&stCOMiCFG,sTopic);
    return(TRUE);
    }
  return(FALSE);
  }

BOOL HelpInit(COMICFG *pstCOMiCFG)
  {
  char szMessage[200];
  HELPINIT hini;
  char szLibraryName[CCHMAXPATH];
  HWND hwndActive;
  ULONG flCreate;
  ERRORID eidError;

#if DEBUG > 0
  if (bNoDEBUGhelp)
    return(FALSE);
#endif
  hwndSaveHelp = pstCOMiCFG->hwndHelpInstance;
  pstCOMiCFG->hwndHelpInstance = 0;
  // if we return because of an error, Help will be disabled
//  fHelpEnabled = FALSE;
  // inititalize help init structure
  hini.cb = sizeof(HELPINIT);
  hini.ulReturnCode = 0L;
  hini.pszTutorialName = (PSZ)NULL;   // if tutorial added, add name here

  hini.phtHelpTable = 0;//(PHELPTABLE)MAKELONG(COMSCOPE_HELP_TABLE, 0xFFFF);
  hini.hmodHelpTableModule = (HMODULE)0;
  hini.hmodAccelActionBarModule = (HMODULE)0;
  hini.idAccelTable = 0;
  hini.idActionBar = 0;
  hini.pszHelpWindowTitle = "Device Driver Configuration Help";

  // if debugging, show panel ids, else don't
#if DEBUG > 0
  hini.fShowPanelId = CMIC_SHOW_PANEL_ID;
#else
  hini.fShowPanelId = CMIC_HIDE_PANEL_ID;
#endif
  if (PrfQueryProfileString(HINI_USERPROFILE,"COMi","Help",NULL,(PSZ)szLibraryName,CCHMAXPATH) == 0)
    {
    sprintf(szMessage,"Unable to get Help File name from the user Initialization file.");
    MessageBox(HWND_DESKTOP,szMessage);
    pstCOMiCFG->hwndHelpInstance = hwndSaveHelp;
    return(FALSE);
    }

  hini.pszHelpLibraryName = szLibraryName;

  // creating help instance
  hwndHelpInstance = WinCreateHelpInstance(pstCOMiCFG->hab,&hini);

  if((hwndHelpInstance != 0)  && (hini.ulReturnCode == 0))
    {
    if (pstCOMiCFG->hwndFrame == 0)
      {
      hwndActive = WinQueryActiveWindow(HWND_DESKTOP);
      pstCOMiCFG->hwndFrame = WinQueryWindow(hwndActive,QW_OWNER);
      }
    if (pstCOMiCFG->hwndFrame == (HWND)NULL)
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
        pstCOMiCFG->hwndFrame = WinCreateStdWindow(HWND_DESKTOP,0L,&flCreate,0L,0L,0L,0L,1,0L);
    #if DEBUG > 0
        if (pstCOMiCFG->hwndFrame == 0)
          {
          eidError = WinGetLastError(WinQueryAnchorBlock(hwndActive));
          sprintf(szMessage,"Error Creating Frame Window.\n\n%08X",eidError);
          MessageBox(HWND_DESKTOP,szMessage);
          }
        else
          MessageBox(HWND_DESKTOP,"Frame Created");
    #endif
        bFrameCreated = TRUE;
        }
      }
    // associate help instance with main frame
    if(!WinAssociateHelpInstance(hwndHelpInstance,pstCOMiCFG->hwndFrame))
      {
      sprintf(szMessage,"Unable to associate help instance with file %s - %u",szLibraryName,pstCOMiCFG->hwndFrame);
      MessageBox(HWND_DESKTOP,szMessage);
      return(FALSE);
      }
    }
  else
    {
    sprintf(szMessage,"Unable to load help file %s",szLibraryName);
    pstCOMiCFG->hwndHelpInstance = 0;
    MessageBox(HWND_DESKTOP,szMessage);
    return(FALSE);
    }
  /*
  ** help manager is successfully initialized so set flag to TRUE
  */
//  fHelpEnabled = TRUE;
  pstCOMiCFG->hwndHelpInstance = hwndHelpInstance;
  WinSetHook(pstCOMiCFG->hab,HMQ_CURRENT,HK_HELP,(PFN)pfnMessageBoxHelpHook,0L);
  return(TRUE);
  }

VOID DestroyHelpInstance(COMICFG *pstCOMiCFG)
  {
#if DEBUG > 0
  if (bNoDEBUGhelp)
    return;
#endif
  WinReleaseHook(pstCOMiCFG->hab,HMQ_CURRENT,HK_HELP,(PFN)pfnMessageBoxHelpHook,0L);
  if(pstCOMiCFG->hwndHelpInstance)
    WinDestroyHelpInstance(pstCOMiCFG->hwndHelpInstance);
  if (bFrameCreated)
    {
    WinDestroyWindow(pstCOMiCFG->hwndFrame);
#if DEBUG > 0
    MessageBox(HWND_DESKTOP,"Frame Destoyed");
#endif
    bFrameCreated = FALSE;
    }
  pstCOMiCFG->hwndHelpInstance = hwndSaveHelp;
  }


