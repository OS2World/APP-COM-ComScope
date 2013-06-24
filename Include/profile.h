#ifndef PROFILE_HEADER

#define PROF_HEADER	3000

#if DEBUG > 0
#define PROFILE_LIBRARY "PROFDEB"
#else
#define PROFILE_LIBRARY "OS2LS_PR"
#endif

#define PROF_NULL         -1
#define PROF_APPNAME_DLG  12000
#define PROF_APPNAME      12001
#define PROF_LOADWINPOS   12002
#define PROF_LOADPROCESS  12003
#define PROF_OK           12004
#define PROF_AUTOSAVE	    12005
#define PROF_LOAD	        12006
#define PROF_SAVE	        12007
#define PROF_DLG	        12008
#define PROF_LIST	        12009
#define PROF_CANCEL       12010
#define PROF_HELP         12011
#define PROF_DELETE       12012
#define PROF_NEW          12013

typedef unsigned int fBOOL;

#define MAX_PROFILE_STRING 40

typedef struct
  {
  char szAppName[MAX_PROFILE_STRING + 1];
  char szVersionString[MAX_PROFILE_STRING + 1];
  }USERPROF;

typedef struct
  {
  HAB hab;
  USERPROF stUserProfile;
  HWND *phwndHelpInstance;
  ULONG ulHelpPanel;
  char szProfileName[MAX_PROFILE_STRING + 1];
  char szAppName[MAX_PROFILE_STRING + 1];
  char szProcessPrompt[MAX_PROFILE_STRING + 1];
  char szIniFilePath[CCHMAXPATH];
//  fBOOL ReserveBits          :26;                // reserve bit positions for future use
  fBOOL bLoadWindowPosition  :1;
  fBOOL bLoadProcess         :1;
  fBOOL bAutoSaveProfile     :1;
  fBOOL bSearchApps          :1;
  fBOOL bInitializeAll       :1;
  fBOOL bRestart             :1;
  void (*pfnUpdateCallBack)(int iProfileAction);
  HWND hwndOwner;
  ULONG ulMaxProfileString;
  ULONG ulMaxApps;
  ULONG ulDataSize;
  void *pData;
  }PROFILE;

typedef struct
  {
  USHORT cbInstanceData;
  PROFILE *pstProfile;
  BOOL bObjectDeleted;
  void *pStartupData;
  char *pszProfileString;
  char *pszSelectedAppName;
  }PROFINST;

typedef PROFINST *HPROF;

#define HELP_SAVE   1
#define HELP_DELETE 2
#define HELP_NAME   3
#define HELP_LOAD   4

#define PROFACTION_ENTER_SAVE         0
#define PROFACTION_EXIT_SAVE          1
#define PROFACTION_ENTER_LOAD         2
#define PROFACTION_PROFILE_LOADED     3
#define PROFACTION_EXIT_LOAD          4
#define PROFACTION_EXIT_MANAGE_INIT   5
#define PROFACTION_EXIT_MANAGE        6
#define PROFACTION_ENTER_MANAGE       7


void pfnUpdateCallBack(int iAction);

typedef BOOL  (* APIENTRY PRF_MANAGE)(HWND,HPROF);
typedef APIRET (* APIENTRY PRF_DATA)(HPROF,PSZ,BYTE *,ULONG);
typedef APIRET (* APIENTRY PRF_GETSTR)(HPROF,PSZ,PSZ,ULONG);
typedef APIRET (* APIENTRY PRF_SAVESTR)(HPROF,PSZ,PSZ);
typedef HPROF (* APIENTRY PRF_INIT)(PROFILE *);
typedef HPROF (* APIENTRY PRF_CLOSE)(HPROF);

#define PROFILE_HEADER

#endif
