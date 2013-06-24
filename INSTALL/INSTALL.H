#ifndef  _INCL_INSTALL_H_

#ifndef DEBUGGER
#define COMi_INSTALL_LIB "PDA_INST"
#define COMi_CONFIG_LIB "COMi_CFG"
#else
#define COMi_INSTALL_LIB "PDA_DEB"
#define COMi_CONFIG_LIB "CFG_DEB"
#endif

#define INITHEIGHT 100
#define INITWIDTH 500

#define SOURCE_FILE_OPEN     2048
#define DEST_FILE_MODE_SET   2049
#define DEST_FILE_OPEN       2050
#define DEST_FILE_READ       2051
#define HIDE_FILE_MODE_READ  2052
#define HIDE_FILE_MODE       2053
#define HIDE_FILE_MODE_SET   2054
#define HIDE_FILE_OPEN       2055
#define HIDE_FILE_DELETE     2056
#define HIDE_FILE_READ       2057
#define BAD_CODE_KEY         2064
#define DEST_FILE_DELETE     2065
#define CAT_SOURCE_READ      2066
#define CAT_SOURCE_WRITE     2067
#define DEST_BAD_PATH        2068
#define DEST_FILE_WRITE      2069
#define DEST_FILE_COPY       2070
#define DEST_FILE_MODE       2071
#define SOURCE_NO_LICENSE    2072
#define SOURCE_FILE_READ     2073

#define MAX_BANNER 60
#define MAXARGLEN  80

typedef struct
  {
  USHORT cbSize;
  char *pszFileName;
  char *pszCaption;
  }INFODLG;

#define UNINSTALL_FOLDERS   0
#define UNINSTALL_OBJ_ONLY  1
#define UNINSTALL_NO_OBJ    2

#define UNINSTALL_REUSE_INI 1
#define UNINSTALL_SAVE_INI  2
#define UNINSTALL_DEL_INI   3

#define UNINSTALL_DIRS      1
#define UNINSTALL_NONE      0

typedef struct _stCell
    {
    SHORT cx;
    SHORT cy;
    }CELL;

typedef struct _Orig
   {
   SHORT x;
   SHORT y;
   } ORIG;

typedef ORIG FAR *PORIG;

typedef struct _Pos
   {
   SHORT x;
   SHORT y;
   }POS;
typedef POS FAR *PPOS;

typedef struct _CurPos
   {
   USHORT x;
   USHORT y;
   }CURPOS;
typedef CURPOS FAR *PCURPOS;

#define MAX_PATH_LEN 255
#define MAX_CMD_LEN  128

BOOL MemAlloc(char **pBuffer,ULONG cbSize);
void MemFree(char *pBuffer);

BOOL GetDriverPath(HFILE hCom,char szPath[]);
BOOL UnFixConfigFile(void);
BOOL FixConfigFile(void);
void UninstallError(USHORT usErrorCode,CHAR szSoucePath[],CHAR szDestPath[]);
void InstallError(USHORT usErrorCode,CHAR szSoucePath[],CHAR szDestPath[]);
void MakeSourceError(USHORT usErrorCode,CHAR szSoucePath[],CHAR szDestPath[]);
void PrintBanners(char szBannerOne[],char szBannerTwo[]);
void PrintProgress(char szFrom[],char szTo[]);
BOOL MakePath(HWND hwnd,char *pszPath);
BOOL CreatePath(char *pszPath);
extern void PrintUninstallProgress(char szDelete[]);

USHORT TruncatePath(BYTE *pbyPath,BYTE *pbyFindFile);
USHORT FileCopy(BYTE *pbySource,BYTE *pbyDestination);
USHORT OpenFile(BYTE abySourcePath[],HFILE *phFile,ULONG *pulStatus,
ULONG ulFileSize,ULONG ulFileAttrib,ULONG ulOpenFlag,ULONG ulOpenMode);
void CenterWindow(HWND hwnd);
void SetEndOfPath(char szPath[]);
HWND HelpInit(char szHelpFileName[],char szTitle[]);
VOID  HelpHelpForHelp(void);
VOID  HelpKeys(void);
VOID  HelpIndex(void);
void DisplayHelpPanel(USHORT usHelpPanel);
void DestroyHelpInstance(HWND hwndHelpInstance);
void PrintDebug(char szLineOne[],char szLineTwo[]);

#define UNINSTALLINIFILENAME  0
#define REMOVEOLDDRIVERSPEC   1
#define DDNAME                2
#define CONFIGDDNAME          3
#define DRIVERINISPEC         4
#define INIFILENAME           5
#define CURRENTDRIVERSPEC     6
#define CONFIGDDLIBRARYSPEC   7
#define CONFIGDDLIBRARYNAME   8
#define CONFIGDDHELPFILENAME  9
#define COMIVERSION           10
#define CONFIGAPPNAME         11
#define CONFIGAPPLIBRARYSPEC  12
#define CONFIGAPPLIBRARYNAME  13
#define CONFIGAPPHELPFILENAME 14
#define APPVERSION            15
#define APPICONFILE           16
#define XFERLIBRARYSPEC       17

#define MAXSTRINGS            18

#define bCopyCOMi             bA
#define bCopyCOMscope         bB
#define bSavedDriverIniFile   bC
#define bCopyPDR              bD
#define bCopyPager            bE
#define bCopyInstall          bF
#define bCopyUtil             bG
#define bBaseLibrariesCopied  bH
#define bFilesCopied          bI
#define bCreateObjects        bJ
#define bCopyLibraries        bK
#define bDDconfigured         bL
#define bAppConfigured        bM
#define fCurrentIni           f2bitFlag1

typedef struct
  {
  USHORT cbSize;
  char chBootDrive;
  BYTE byItemCount;
  VOID *pAnyData; // using as list of object that need modification after configuration
  HWND hwndFrame;
  HAB hab;
  ULONG ulMaxPathLen;
  PFN pfnPrintProgress;
  int bA          :1;
  int bB          :1;
  int bC          :1;
  int bD          :1;
  int bE          :1;
  int bF          :1;
  int bG          :1;
  int bH          :1;
  int bI          :1;
  int bJ          :1;
  int bK          :1;
  int bL          :1;
  int bM          :1;
  int bN          :1;
  int bO          :1;
  int bP          :1;
  int f2bitFlag1  :2;
  int fFlags      :14;
  char *pszAppsPath;
  char *pszDLLpath;
  char *pszSourcePath;
  char *pszSourceIniPath;
  char *paszStrings[MAXSTRINGS];
  }INSTALL;

typedef struct
  {
  char *pszConfigDDname;
  char *pszPath;
  char *pszBannerOne;
  char *pszBannerTwo;
  char *pszUninstallIniPath;
  unsigned int f2bitFlag1:  2;
  unsigned int bDirs:       1;
  unsigned int fObjects:    2;
  INSTALL *pstInst;
  PFN pfnPrintProgress;
  }UNINST;

#define _INCL_INSTALL_H_

#endif

