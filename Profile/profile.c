#include "COMMON.H"
#include "profile.h"
#include "UTILITY.H"

BOOL EXPENTRY ManageProfile(HWND hwnd,HPROF hInst);
HPROF EXPENTRY InitializeProfile(PROFILE *pstInitProfile);
BOOL EXPENTRY SaveProfileString(HPROF pstInst,char szStringKey[],char *pszString);
void EXPENTRY SaveProfileWindowPos(HPROF pstInst,char szWindowKey[],SWP swp);
BOOL EXPENTRY GetProfileWindowPos(HPROF pstInst,char szWindowKey[],PSWP pswp);
HPROF EXPENTRY CloseProfile(HPROF pstInst);
ULONG EXPENTRY GetProfileString(HPROF pstInst,char szStringKey[],char *pszString,ULONG ulMaxSize);
BOOL EXPENTRY SaveProfileData(HPROF pstInst,char szStringKey[],BYTE *pData,ULONG ulSize);
ULONG EXPENTRY GetProfileData(HPROF pstInst,char szStringKey[],BYTE *pData,ULONG ulMaxSize);
VOID DisplayHelpPanel(HWND hwndHelpInstance,SHORT idPanel);

void CopyProfileApp(HINI hSourceProfile,HINI hDestinationProfile,char szAppName[]);
void DeleteProfileApps(HPROF pstInst);
long FillProfileListBox(HWND hwndDlg,HINI hProfile,HPROF pstInst);

//VOID CenterDlgBox(HWND hwndDlg);
//VOID CheckButton(HWND hwndDlg,USHORT idItem,BOOL bCheck);
//BOOL Checked(HWND hwndDlg,SHORT idDlgItem);

MRESULT EXPENTRY fnwpAppNameDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2);

static char const chDeletedMark1 = '\xae';
//static BYTE chDeletedMark2 = '\xaf';
static char const szDeletedFormat[] = "\xae%s\xaf";

char szDialogTitle[100];

static HMODULE hThisModule;
BOOL bDLLinUse = FALSE;

#ifdef __BORLANDC__
ULONG _dllmain(ULONG ulTermCode,HMODULE hMod)
#else
ULONG _System _DLL_InitTerm(HMODULE hMod,ULONG ulTermCode)
#endif
  {
  if (ulTermCode == 0)
    hThisModule = hMod;
  return(TRUE);
  }

MRESULT EXPENTRY fnwpManageConfigDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  char szListString[80];
  char szString[80];
  static int iItemSelected;
  static HINI hProfile;
  ULONG ulSize;
  static PROFINST *pstInst;
  static PROFILE *pstProfile;
  ULONG flMessageBoxStyle;
  static char *pszEntryAppName;

  switch (msg)
    {
    case WM_INITDLG:
      CenterDlgBox(hwndDlg);
      WinSetFocus(HWND_DESKTOP,hwndDlg);
      iItemSelected = LIT_NONE;
      pstInst = PVOIDFROMMP(mp2);
      pstProfile = pstInst->pstProfile;
      if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) == 0)
        WinDismissDlg(hwndDlg,FALSE);
      pstInst->pszSelectedAppName = malloc(pstProfile->ulMaxProfileString);
      if (pstInst->pszSelectedAppName == NULL)
        {
        PrfCloseProfile(hProfile);
        WinDismissDlg(hwndDlg,FALSE);
        }
      if ((pszEntryAppName = malloc(pstProfile->ulMaxProfileString)) == NULL)
        {
        free(pstInst->pszSelectedAppName);
        PrfCloseProfile(hProfile);
        WinDismissDlg(hwndDlg,FALSE);
        }
      strcpy(pszEntryAppName,pstProfile->szAppName);
//      WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_SETITEMHEIGHT,(MPARAM)12,(MPARAM)0);
      if (pstProfile->pfnUpdateCallBack != NULL)
        pstProfile->pfnUpdateCallBack(PROFACTION_ENTER_MANAGE);
      if ((iItemSelected = (int)FillProfileListBox(hwndDlg,hProfile,pstInst)) != LIT_NONE)
        WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_SELECTITEM,MPFROMSHORT(iItemSelected),MPFROMSHORT(TRUE));
      else
        {
        WinEnableWindow(WinWindowFromID(hwndDlg,PROF_LOAD),FALSE);
        WinEnableWindow(WinWindowFromID(hwndDlg,PROF_SAVE),FALSE);
        WinEnableWindow(WinWindowFromID(hwndDlg,PROF_DELETE),FALSE);
        }
      if (pstProfile->bLoadWindowPosition)
        CheckButton(hwndDlg,PROF_LOADWINPOS,TRUE);
      if (pstProfile->bLoadProcess)
        CheckButton(hwndDlg,PROF_LOADPROCESS,TRUE);
      if (pstProfile->bAutoSaveProfile)
        CheckButton(hwndDlg,PROF_AUTOSAVE,TRUE);
      if (strlen(pstProfile->szProcessPrompt) != 0)
        WinSetDlgItemText(hwndDlg,PROF_LOADPROCESS,pstProfile->szProcessPrompt);
      if (strlen(pstProfile->szProfileName) != 0)
        {
        sprintf(szDialogTitle,"%s configuration management",pstProfile->szProfileName);
        WinSetDlgItemText(hwndDlg,PROF_HEADER,szDialogTitle);
        }
      if (pstProfile->pfnUpdateCallBack != NULL)
        pstProfile->pfnUpdateCallBack(PROFACTION_EXIT_MANAGE_INIT);
      return (MRESULT) TRUE;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case PROF_HELP:
          if (pstProfile->phwndHelpInstance != NULL)
            DisplayHelpPanel(*pstProfile->phwndHelpInstance,pstProfile->ulHelpPanel);
          break;
        case PROF_SAVE:
          if (iItemSelected != LIT_NONE)
            {
            if (strcmp(pstProfile->szAppName,pstInst->pszSelectedAppName) != 0)
              {
              sprintf(szString,"Save Profile Name is Different");
              sprintf(szListString,"Do you want to overwrite profile \"%s\" with the current configuration?",pstInst->pszSelectedAppName);
              flMessageBoxStyle = (MB_MOVEABLE | MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON2);
              if (pstProfile->ulHelpPanel != 0)
                flMessageBoxStyle |= MB_HELP;
              if (WinMessageBox(HWND_DESKTOP,
                                pstProfile->hwndOwner,
                                szListString,
                                szString,
                               (pstProfile->ulHelpPanel + HELP_SAVE),
                                flMessageBoxStyle) != MBID_YES)
              break;
              }
            if (pstProfile->pfnUpdateCallBack != NULL)
              {
              pstProfile->bLoadWindowPosition = Checked(hwndDlg,PROF_LOADWINPOS);
              pstProfile->bLoadProcess = Checked(hwndDlg,PROF_LOADPROCESS);
              pstProfile->bAutoSaveProfile = Checked(hwndDlg,PROF_AUTOSAVE);
              pstProfile->pfnUpdateCallBack(PROFACTION_ENTER_SAVE);
              }
            PrfWriteProfileData(hProfile,pstInst->pszSelectedAppName,"Setup",pstProfile->pData,pstProfile->ulDataSize);
            memcpy(pstInst->pStartupData,pstProfile->pData,pstProfile->ulDataSize);
            if (pstProfile->pfnUpdateCallBack != NULL)
              pstProfile->pfnUpdateCallBack(PROFACTION_EXIT_SAVE);
            }
          break;
        case PROF_LOAD:
          if (iItemSelected != LIT_NONE)
            {
            PrfQueryProfileString(hProfile,pstInst->pszSelectedAppName,"Status",0L,pstInst->pszProfileString,pstProfile->ulMaxProfileString);
            if (strcmp(pstInst->pszProfileString,"In Use") == 0)
              {
              sprintf(szString,"Unable to Load Selected Profile");
              sprintf(szListString,"The profile \"%s\" is in use by an active session",pstInst->pszSelectedAppName);
              flMessageBoxStyle = (MB_MOVEABLE | MB_INFORMATION);
              if (pstProfile->ulHelpPanel != 0)
                flMessageBoxStyle |= MB_HELP;
              WinMessageBox(HWND_DESKTOP,
                            pstProfile->hwndOwner,
                            szListString,
                            szString,
                           (pstProfile->ulHelpPanel + HELP_LOAD),
                            flMessageBoxStyle);
              break;
              }
            if (pstProfile->pfnUpdateCallBack != NULL)
              pstProfile->pfnUpdateCallBack(PROFACTION_ENTER_LOAD);
            if (pstProfile->szAppName[0] != 0)
              PrfWriteProfileString(hProfile,pstProfile->szAppName,"Status","Available");
            strcpy(pstProfile->szAppName,pstInst->pszSelectedAppName);
            PrfWriteProfileString(hProfile,pstProfile->szAppName,"Status","In Use");
            ulSize = (pstProfile->ulDataSize);
            if (!PrfQueryProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,&ulSize))
              PrfWriteProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,pstProfile->ulDataSize);
            memcpy(pstInst->pStartupData,pstProfile->pData,pstProfile->ulDataSize);
            if (pstProfile->pfnUpdateCallBack != NULL)
              {
              pstProfile->pfnUpdateCallBack(PROFACTION_PROFILE_LOADED);
              CheckButton(hwndDlg,PROF_LOADWINPOS,pstProfile->bLoadWindowPosition);
              CheckButton(hwndDlg,PROF_LOADPROCESS,pstProfile->bLoadProcess);
              CheckButton(hwndDlg,PROF_AUTOSAVE,pstProfile->bAutoSaveProfile);
              }
            if (pstProfile->pfnUpdateCallBack != NULL)
              pstProfile->pfnUpdateCallBack(PROFACTION_EXIT_LOAD);
            }
          break;
        case PROF_NEW:
          if (WinDlgBox(HWND_DESKTOP,
                    hwndDlg,
             (PFNWP)fnwpAppNameDlgProc,
                    hThisModule,
                    PROF_APPNAME_DLG,
                    pstInst))
            {
            if (pstProfile->szAppName[0] != 0)
              PrfWriteProfileString(hProfile,pstProfile->szAppName,"Status","Available");
            strcpy(pstProfile->szAppName,pstInst->pszSelectedAppName);
            PrfWriteProfileString(hProfile,pstInst->pszSelectedAppName,"Status","In Use");
            PrfWriteProfileData(hProfile,pstInst->pszSelectedAppName,"Setup",pstProfile->pData,pstProfile->ulDataSize);
            memcpy(pstInst->pStartupData,pstProfile->pData,pstProfile->ulDataSize);
            WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(pstInst->pszSelectedAppName));
            iItemSelected = (SHORT)WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_SEARCHSTRING,MPFROM2SHORT(LSS_CASESENSITIVE,LIT_FIRST),MPFROMP(pstInst->pszSelectedAppName));
            WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_SELECTITEM,MPFROMSHORT(iItemSelected),MPFROMSHORT(TRUE));
            }
          break;
        case PROF_DELETE:
          if (iItemSelected != LIT_NONE)
            {
            PrfQueryProfileString(hProfile,pstInst->pszSelectedAppName,"Status",0L,pstInst->pszProfileString,pstProfile->ulMaxProfileString);
            if (strcmp(pstInst->pszProfileString,"In Use") == 0)
              {
              sprintf(szString,"Unable to Delete Selected Profile");
              sprintf(szListString,"The profile \"%s\" is in use by an active session",pstInst->pszSelectedAppName);
              flMessageBoxStyle = (MB_MOVEABLE | MB_INFORMATION);
              if (pstProfile->ulHelpPanel != 0)
                flMessageBoxStyle |= MB_HELP;
              WinMessageBox(HWND_DESKTOP,
                            pstProfile->hwndOwner,
                            szListString,
                            szString,
                           (pstProfile->ulHelpPanel + HELP_DELETE),
                            flMessageBoxStyle);
              break;
              }
            if (strcmp(pstInst->pszProfileString,"Deleted") != 0)
              {
              PrfWriteProfileString(hProfile,pstInst->pszSelectedAppName,"Status","Deleted");
              pstInst->bObjectDeleted = TRUE;
              WinEnableWindow(WinWindowFromID(hwndDlg,PROF_LOAD),FALSE);
              WinEnableWindow(WinWindowFromID(hwndDlg,PROF_SAVE),FALSE);
              WinSetDlgItemText(hwndDlg,PROF_DELETE,"~Undelete");
//              WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_QUERYITEMTEXT,MPFROM2SHORT(iItemSelected,pstProfile->ulMaxProfileString),MPFROMP(pstInst->pszProfileString));
              sprintf(pstInst->pszProfileString,szDeletedFormat,pstInst->pszSelectedAppName);
              WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_SETITEMTEXT,MPFROMSHORT(iItemSelected),MPFROMP(pstInst->pszProfileString));
              }
            else
              {
              PrfWriteProfileString(hProfile,pstInst->pszSelectedAppName,"Status","Available");
              pstInst->bObjectDeleted = TRUE;
              WinEnableWindow(WinWindowFromID(hwndDlg,PROF_LOAD),FALSE);
              WinEnableWindow(WinWindowFromID(hwndDlg,PROF_SAVE),FALSE);
              WinSetDlgItemText(hwndDlg,PROF_DELETE,"~Delete");
              WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_SETITEMTEXT,MPFROMSHORT(iItemSelected),MPFROMP(pstInst->pszSelectedAppName));
              }
            }
          break;
        case PROF_OK:
          PrfCloseProfile(hProfile);
          if (pstProfile->pfnUpdateCallBack != NULL)
            pstProfile->pfnUpdateCallBack(PROFACTION_EXIT_MANAGE);
          if (strcmp(pszEntryAppName,pstProfile->szAppName) != 0)
            WinDismissDlg(hwndDlg,TRUE);
          else
            WinDismissDlg(hwndDlg,FALSE);
          free(pstInst->pszSelectedAppName);
          free(pszEntryAppName);
          return((MRESULT)FALSE);
        default:
          return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
        }
      return((MRESULT)FALSE);
    case WM_CONTROL:
      if (SHORT2FROMMP(mp1) == LN_SELECT)
        if (SHORT1FROMMP(mp1) == PROF_LIST)
          {
          iItemSelected = (int)WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_QUERYSELECTION,0L,0L);
          if (iItemSelected != LIT_NONE)
            {
            WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_QUERYITEMTEXT,MPFROM2SHORT(iItemSelected,pstProfile->ulMaxProfileString + 8),MPFROMP(pstInst->pszProfileString));
            if (pstInst->pszProfileString[0] == chDeletedMark1)
              {
              strcpy(pstInst->pszSelectedAppName,&pstInst->pszProfileString[1]);
              pstInst->pszSelectedAppName[strlen(pstInst->pszSelectedAppName) - 1] = 0;
              WinSetDlgItemText(hwndDlg,PROF_DELETE,"~Undelete");
              WinEnableWindow(WinWindowFromID(hwndDlg,PROF_LOAD),FALSE);
              WinEnableWindow(WinWindowFromID(hwndDlg,PROF_SAVE),FALSE);
              }
            else
              {
              strcpy(pstInst->pszSelectedAppName,pstInst->pszProfileString);
              WinSetDlgItemText(hwndDlg,PROF_DELETE,"~Delete");
              WinEnableWindow(WinWindowFromID(hwndDlg,PROF_LOAD),TRUE);
              WinEnableWindow(WinWindowFromID(hwndDlg,PROF_SAVE),TRUE);
              }
            WinEnableWindow(WinWindowFromID(hwndDlg,PROF_DELETE),TRUE);
            }
          return((MRESULT)TRUE);
          }
        break;
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }

MRESULT EXPENTRY fnwpAppNameDlgProc(HWND hwndDlg,USHORT msg,MPARAM mp1,MPARAM mp2)
  {
  static PROFINST *pstInst;
  static char *pszName;
  static PROFILE *pstProfile;
  char szListString[80];
  char szString[80];
  ULONG flMessageBoxStyle;

  switch (msg)
    {
    case WM_INITDLG:
      CenterDlgBox(hwndDlg);
      pstInst = PVOIDFROMMP(mp2);
      pstProfile = pstInst->pstProfile;
      if ((pszName = malloc(pstProfile->ulMaxProfileString)) == NULL)
        WinDismissDlg(hwndDlg,FALSE);
      WinSendDlgItemMsg(hwndDlg,PROF_APPNAME,EM_SETTEXTLIMIT,MPFROMSHORT(pstProfile->ulMaxProfileString),(MPARAM)NULL);
      WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,PROF_APPNAME));
      return (MRESULT) TRUE;
    case WM_COMMAND:
      switch (SHORT1FROMMP(mp1))
        {
        case PROF_OK:
          WinQueryDlgItemText(hwndDlg,PROF_APPNAME,pstProfile->ulMaxProfileString,pszName);
          if (strlen(pszName) > 0)
            {
            if (pszName[0] == chDeletedMark1)
              {
              sprintf(szString,"Invalid Character in Profile Name");
              sprintf(szListString,"The character \"%c\" cannot be used as the first character in a profile name.",chDeletedMark1);
              flMessageBoxStyle = (MB_MOVEABLE | MB_INFORMATION);
              if (pstProfile->ulHelpPanel != 0)
                flMessageBoxStyle |= MB_HELP;
              WinMessageBox(HWND_DESKTOP,
                            pstProfile->hwndOwner,
                            szListString,
                            szString,
                           (pstProfile->ulHelpPanel + HELP_NAME),
                            flMessageBoxStyle);
              break;
              }
            strcpy(pstInst->pszSelectedAppName,pszName);
            free(pszName);
            WinDismissDlg(hwndDlg,TRUE);
            return((MRESULT)FALSE);
            }
        case PROF_CANCEL:
          free(pszName);
          WinDismissDlg(hwndDlg,FALSE);
          break;
        default:
          return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
        }
      return((MRESULT)FALSE);
    }
  return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
  }

long FillProfileListBox(HWND hwndDlg,HINI hProfile,HPROF pstInst)
  {
  int iIndex;
  int iStartIndex;
  int iAppIndex;
  char *pAppNames;
  ULONG ulSize;
  int iItemToSelect = LIT_NONE;
  PROFILE *pstProfile = pstInst->pstProfile;

  PrfQueryProfileSize(hProfile,0L,0L,&ulSize);
  if ((pAppNames = malloc(ulSize + 1)) != NULL)
    {
    PrfQueryProfileString(hProfile,0L,0L,0L,pAppNames,ulSize);
    iIndex = 0;
    for (iAppIndex = 0;iAppIndex < pstProfile->ulMaxApps;iAppIndex++)
      {
      iStartIndex = iIndex;
      while(pAppNames[iIndex++] != 0);
      if (iItemToSelect == LIT_NONE)
        if (strcmp(&pAppNames[iStartIndex],pstProfile->szAppName) == 0)
          iItemToSelect = iAppIndex;
      if (PrfQueryProfileString(hProfile,&pAppNames[iStartIndex],"Status",0L,pstInst->pszProfileString,pstProfile->ulMaxProfileString) != 0)
        if (strcmp(pstInst->pszProfileString,"Deleted") != 0)
          WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(&pAppNames[iStartIndex]));
        else
          {
          sprintf(pstInst->pszProfileString,szDeletedFormat,&pAppNames[iStartIndex]);
          WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(pstInst->pszProfileString));
          }
      if (pAppNames[iIndex] == 0)
        break;
      }
    }
  free(pAppNames);
  return(iItemToSelect);
  }

void DeleteProfileApps(HPROF pstInst)
  {
  int iIndex;
  int iStartIndex;
  int iAppIndex;
  char *pAppNames = NULL;
  HINI hSourceProfile;
  ULONG ulSize;
  PROFILE *pstProfile = pstInst->pstProfile;

  if ((hSourceProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
    {
    PrfQueryProfileSize(hSourceProfile,0L,0L,&ulSize);
    if ((pAppNames = (char *)malloc(ulSize + 1)) != NULL)
      {
      PrfQueryProfileString(hSourceProfile,0L,0L,0L,pAppNames,ulSize);
      iIndex = 0;
      for (iAppIndex = 0;iAppIndex < pstProfile->ulMaxApps;iAppIndex++)
        {
        iStartIndex = iIndex;
        while(pAppNames[iIndex++] != 0);
        if ((PrfQueryProfileString(hSourceProfile,
                                  &pAppNames[iStartIndex],
                                  "Status",
                                   0L,
                                   pstInst->pszProfileString,
                                   pstProfile->ulMaxProfileString) == 0) ||
            (strcmp(pstInst->pszProfileString,"Deleted") == 0))
          PrfWriteProfileData(hSourceProfile,&pAppNames[iStartIndex],NULL,NULL,0L);
        if (pAppNames[iIndex] == 0)
          break;
        }
      }
    }
  if (hSourceProfile != 0)
    PrfCloseProfile(hSourceProfile);
  if (pAppNames != NULL)
    free(pAppNames);
  }

BOOL EXPENTRY ManageProfile(HWND hwnd,HPROF hInst)
  {
  APIRET rc;
  char szModName[20];

  rc = WinDlgBox(HWND_DESKTOP,
                 hwnd,
          (PFNWP)fnwpManageConfigDlgProc,
                 hThisModule,
                 PROF_DLG,
                 hInst);
  if (rc == DID_ERROR)
    {
    WinGetLastError(hInst->pstProfile->hab);
    return(FALSE);
    }
  return(rc);
  }

HPROF EXPENTRY InitializeProfile(PROFILE *pstProfile)
  {
  ULONG ulSize;
  HINI hProfile;
  LONG lIndex;
  LONG lStartIndex;
  PROFINST *pstInst;
  LONG lTemp;
  char *pAppNames;

  if ((pstInst = (PROFINST *)malloc(sizeof(PROFINST))) == NULL)
    return(NULL);
  pstInst->cbInstanceData = sizeof(PROFINST);
  pstInst->pstProfile = pstProfile;
  sprintf(&pstProfile->szIniFilePath[strlen(pstProfile->szIniFilePath)],"%s.INI",pstProfile->szProfileName);
  pstInst->bObjectDeleted = FALSE;

  if ((pstInst->pStartupData = malloc(pstProfile->ulDataSize)) == 0)
    {
    free(pstInst);
    return(NULL);
    }
  if ((pstInst->pszProfileString = malloc(pstProfile->ulMaxProfileString + 8)) == NULL)
    {
    free(pstInst->pStartupData);
    free(pstInst);
    return(NULL);
    }
  if (pstProfile->stUserProfile.szAppName[0] != 0)
    {
    lIndex = PrfQueryProfileString(HINI_USERPROFILE,pstProfile->szProfileName,"Version",0L,pstInst->pszProfileString,pstProfile->ulMaxProfileString);
    if ((lIndex == 0) || (strcmp(pstInst->pszProfileString,pstProfile->stUserProfile.szVersionString)))
      {
      PrfWriteProfileString(HINI_USERPROFILE,pstProfile->szProfileName,"Version",pstProfile->stUserProfile.szVersionString);
      DosDelete(pstProfile->szIniFilePath);
      }
    }
  if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
    {
    if (pstProfile->bRestart)
      {
      PrfQueryProfileSize(hProfile,0L,0L,&ulSize);
      if (ulSize != 0)
        {
        if ((pAppNames = malloc(ulSize + 1)) == 0)
          {
          free(pstInst->pszProfileString);
          free(pstInst->pStartupData);
          free(pstInst);
          return(NULL);
          }
        PrfQueryProfileString(hProfile,0L,0L,0L,pAppNames,ulSize);
        lIndex = 0;
        while (pAppNames[lIndex] != 0)
          {
          lStartIndex = lIndex;
          while(pAppNames[lIndex++] != 0)
            PrfWriteProfileString(hProfile,&pAppNames[lStartIndex],"Status","Available");
          }
        free(pAppNames);
        }
      }
    if (pstProfile->bSearchApps)
      {
      lTemp = strlen(pstProfile->szAppName);
      for (lIndex = 1;lIndex <= pstProfile->ulMaxApps;lIndex++)
       {
        pstProfile->szAppName[lTemp] = ' ';
        itoa(lIndex,&(pstProfile->szAppName[lTemp + 1]),10);
        if ((PrfQueryProfileString(hProfile,pstProfile->szAppName,
                            "Status",0L,pstInst->pszProfileString,pstProfile->ulMaxProfileString)) == 0)
          {
          PrfWriteProfileString(hProfile,pstProfile->szAppName,"Status","In Use");
          PrfWriteProfileData(hProfile,pstProfile->szAppName,
                                      "Setup",pstProfile->pData,pstProfile->ulDataSize);
          break;
          }
        else
          {
          if (strcmp(pstInst->pszProfileString,"Available") == 0)
            {
            PrfWriteProfileString(hProfile,pstProfile->szAppName,"Status","In Use");
            if (!PrfQueryProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,&(pstProfile->ulDataSize)))
              PrfWriteProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,pstProfile->ulDataSize);
            break;
            }
          }
        }
      if (lIndex > pstProfile->ulMaxApps)
        pstProfile->szAppName[0] = 0; // if there are no usable apps at the end of the loop then clear "app name"
      }
    else
      {
      PrfWriteProfileString(hProfile,pstProfile->szAppName,"Status","In Use");
      ulSize = pstProfile->ulDataSize;
      if (!PrfQueryProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,&ulSize))
        PrfWriteProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,pstProfile->ulDataSize);
      }
    PrfCloseProfile(hProfile);
    }
  memcpy(pstInst->pStartupData,pstProfile->pData,pstProfile->ulDataSize);
  return(pstInst);
  }

HPROF EXPENTRY CloseProfile(HPROF pstInst)
  {
  PROFILE *pstProfile;
  HINI hProfile;
  char szCaption[80];
  char szMessage[80];

  if (pstInst != NULL)
    {
    pstProfile = pstInst->pstProfile;
    if (pstInst->bObjectDeleted)
      DeleteProfileApps(pstInst);
    if (pstProfile->szAppName[0] != 0)
      {
      if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
        {
        PrfWriteProfileString(hProfile,pstProfile->szAppName,"Status","Available");
        if (pstProfile->pData != NULL)
          {
          if (memcmp(pstInst->pStartupData,pstProfile->pData,pstProfile->ulDataSize) != 0)
            {
            if (!pstProfile->bAutoSaveProfile)
              {
              sprintf(szCaption,"Application Profile has Changed.");
              sprintf(szMessage,"Do you want to save the profile \"%s\"?",pstProfile->szAppName);
              if (WinMessageBox(HWND_DESKTOP,
                                pstProfile->hwndOwner,
                                szMessage,
                                szCaption,
                                0L,
                               (MB_MOVEABLE | MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON1)) == MBID_YES)
                PrfWriteProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,pstProfile->ulDataSize);
              }
            else
              PrfWriteProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,pstProfile->ulDataSize);
            }
          }
        PrfCloseProfile(hProfile);
        }
      }
    free(pstInst->pszProfileString);
    free(pstInst->pStartupData);
    free(pstInst);
    }
  return(NULL);
  }

BOOL EXPENTRY SaveProfileString(HPROF pstInst,char szStringKey[],char *pszString)
  {
  HINI hProfile;
  PROFILE *pstProfile;

  if (pstInst == (HPROF)NULL)
    return(FALSE);
  pstProfile = pstInst->pstProfile;
  if (pstProfile->szAppName[0] != 0)
    {
    if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
      {
      if (pszString != NULL)
        if (strlen(pszString) == 0)
          pszString = NULL;
      PrfWriteProfileString(hProfile,pstProfile->szAppName,szStringKey,pszString);
      PrfCloseProfile(hProfile);
      }
    }
  return(TRUE);
  }

ULONG EXPENTRY GetProfileString(HPROF pstInst,char szStringKey[],char *pszString,ULONG ulMaxSize)
  {
  HINI hProfile;
  PROFILE *pstProfile;
  ULONG ulSize;

  if (pstInst == (HPROF)NULL)
    return(0);
  pstProfile = pstInst->pstProfile;
  if (pstProfile->szAppName[0] != 0)
    {
    if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
      {

      ulSize = PrfQueryProfileString(hProfile,pstProfile->szAppName,szStringKey,0,pszString,ulMaxSize);
      PrfCloseProfile(hProfile);
      }
    }
  return(ulSize);
  }

BOOL EXPENTRY SaveProfileData(HPROF pstInst,char szStringKey[],BYTE *pData,ULONG ulSize)
  {
  HINI hProfile;
  PROFILE *pstProfile;
  BOOL bSuccess = FALSE;

  if (pstInst == (HPROF)NULL)
    return(FALSE);
  pstProfile = pstInst->pstProfile;
  if (pstProfile->szAppName[0] != 0)
    {
    if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
      {
      if (ulSize == 0)
        pData = NULL;
      if (PrfWriteProfileData(hProfile,pstProfile->szAppName,szStringKey,pData,ulSize))
        bSuccess = TRUE;
      PrfCloseProfile(hProfile);
      }
    }
  return(bSuccess);
  }

ULONG EXPENTRY GetProfileData(HPROF pstInst,char szStringKey[],BYTE *pData,ULONG ulMaxSize)
  {
  HINI hProfile;
  PROFILE *pstProfile;
  ULONG ulSize = 0;

  if (pstInst == (HPROF)NULL)
    return(0);
  pstProfile = pstInst->pstProfile;
  if (pstProfile->szAppName[0] != 0)
    {
    if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
      {
      ulSize = ulMaxSize;
      if (!PrfQueryProfileData(hProfile,pstProfile->szAppName,szStringKey,pData,&ulSize))
        ulSize = 0;
      PrfCloseProfile(hProfile);
      }
    }
  return(ulSize);
  }

void EXPENTRY SaveProfileWindowPos(HPROF pstInst,char szWindowKey[],SWP swp)
  {
  HINI hProfile;
  PROFILE *pstProfile = pstInst->pstProfile;

  if (pstProfile->szAppName[0] != 0)
    {
    if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
      {
      PrfWriteProfileData(hProfile,pstProfile->szAppName,szWindowKey,&swp,sizeof(SWP));
      PrfCloseProfile(hProfile);
      }
    }
  }

BOOL EXPENTRY GetProfileWindowPos(HPROF pstInst,char szWindowKey[],PSWP pswp)
  {
  HINI hProfile;
  ULONG ulSize;
  BOOL bStatus = FALSE;
  PROFILE *pstProfile = pstInst->pstProfile;

  if (pstProfile->szAppName[0] != 0)
    {
    if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
      {
      ulSize = sizeof(SWP);
      if (PrfQueryProfileData(hProfile,pstProfile->szAppName,szWindowKey,pswp,&ulSize))
        bStatus = TRUE;
      PrfCloseProfile(hProfile);
      }
    }
  return(bStatus);
  }

VOID DisplayHelpPanel(HWND hwndHelpInstance,SHORT idPanel)
  {
  if (hwndHelpInstance != 0)
    {
    if (WinSendMsg(hwndHelpInstance,HM_DISPLAY_HELP,
                   MPFROM2SHORT(idPanel,NULL),MPFROMSHORT(HM_RESOURCEID)))
       MessageBox(HWND_DESKTOP,"Unable to display Help Panel");
    }
  else
    MessageBox(HWND_DESKTOP,"Help is not Initialized");
  }


