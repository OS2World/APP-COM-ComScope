#ifndef  CONFIG_HEADER

#if DEBUG > 0
#define CONFIG_LIBRARY "CFG_DEB"
#else
#define CONFIG_LIBRARY "COMi_CFG"
#endif

#define PORT_SELECTED       3
#define NO_PORT_AVAILABLE   4
#define NO_COMSCOPE_AVAIL   5
#define NO_MEMORY_AVAIL     6

typedef struct
  {
  USHORT cbSize;
  HAB hab;
  HWND hwndFrame;
  HWND hwndHelpInstance;
  USHORT idHelpPanel;
  PFN pfnMessageBoxHelpHook;
  char *pszPortName;
  char *pszDriverIniSpec;
  char *pszRemoveOldDriverSpec;
  char *pszHelpFileSpec;
  BYTE byOEMtype;
  ULONG ulMaxDeviceCount;
  char *pDeviceList;
  ULONG cbDevList;
  PVOID pst;
  PVOID pstSpare;
  ULONG ulValue;
  USHORT usValue;
  ULONG ulSpare;
  int iDeviceCount;
  int iLoadCount;
  int bFindCOMscope:    1;
  int bInstallCOMscope: 1;
  int bInitInstall:     1;
  int bEnumCOMscope:    1;
  int bHelpEnabled:     1;
  int bPortActive:      1;
  int bSpoolerConfig:   1;
  int bPCIadapter:      1;
  int bDirtyPage:       1;
  } COMICFG;

typedef struct _COMdefinition
  {
  char szCOMname[9];
  USHORT usAddress;
  BYTE byIntLevel;
  USHORT usLoadNumber;
  USHORT usDCBnumber;
  USHORT usCommandFlags;
  } COMDEF;

typedef APIRET (* EXPENTRY CFG_INSTDEV)(COMICFG *);
typedef APIRET (* EXPENTRY CFG_DIALOG)(HWND,PVOID);
typedef APIRET (* EXPENTRY CFG_FILLLIST)(COMICFG *);

#define CONFIG_HEADER

#endif
