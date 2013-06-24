#ifndef  _INCL_COMi_CFG_H_

#include "config.h"
#include "linklist.h"

#define INSTALL_SPOOL  1
#define REMOVE_SPOOL   2

typedef struct
  {
  char szPortName[10];
  ULONG fAction;
  }SPOOLLST;

typedef struct
  {
  char szName[9];
  WORD wAddress;
  BYTE byInterruptLevel;
  }DEVDEF;

typedef struct
  {
  char szName[10];
  BOOL bAvailable;
  }DEVLIST;

#define DEV_NUM_INDEX 3

typedef struct
  {
  WORD wLoadNumber;
  WORD wDCBnumber;
  }DCBPOS;

typedef struct
  {
  ULONG ulMajor;
  ULONG ulMinor;
  ULONG ulRevision;
  }OSVER;

#define MAX_NOTEBOOK_PAGES 20

typedef struct
  {
  USHORT cbSize;
  USHORT usHelpId;
  USHORT usFocusId;
  PVOID pVoidPtrOne;
  PVOID pVoidPtrTwo;
  PVOID pVoidPtrThree;
  ULONG ulPageId;
  ULONG ulPrevPageId;
  ULONG ulSubPageId;
  ULONG ulSpare;
  HWND hwnd;
  HWND hwndInitialFocus;
  BITFIELD bDirtyBit :1;
  BITFIELD bTopPage  :1;
  BITFIELD bSubPage  :1;
  BITFIELD bRecalcEach :1;
  BITFIELD bSpoolerConfig:1;
  }NBKPAGECTL;

#define BUFF_TYPE_TX      0
#define BUFF_TYPE_RX      1
#define BUFF_TYPE_CS      2

#define MAX_BAUD       115200

#define UM_INITLS        10000
#define UM_SAVE_DATA     10001
#define UM_RECALCDLG     10002
#define UM_INIT          10003
#define UM_CLOSE         10004
#define UM_VALIDATE_DATA 10005
#define UM_SET_FOCUS     10006

APIRET EXPENTRY FillDeviceNameList(COMICFG *pstCOMiCFG);

BOOL GetNextAvailableInterrupt(char *pbyIntLevel);
BOOL GetNextAvailableAddress(WORD *pwAddress);
int FillDeviceDialogNameListBox(HWND hwndDlg,char szCurrentName[],char szPortName[]);

extern DCBPOS FillDeviceLists(char szDriverIniPath[],LINKLIST *pstAddressList,LINKLIST *pstInterruptList);

/*
** COMDDINI.C function prototypes
*/
extern BOOL PlaceIniCFGheader(char szFileSpec[],CFGHEAD *pstCFGheader,DCBPOS *pstHeaderPosition);
extern BOOL RemoveIniCFGheader(char szFileSpec[],WORD wLoadNumber);
extern BOOL RemoveIniDCBheader(char szFileSpec[],DCBPOS *pstHeaderPosition);
extern BOOL QueryBaseDevice(char szFileSpec[],DCBPOS *pstHeaderPosition);
extern BOOL QueryIniCFGheader(char szFileSpec[],CFGHEAD *pstCFGheader,DCBPOS *pstHeaderPosition);
extern BOOL QueryIniDCBheaderName(char szFileSpec[],CFGHEAD *pstCFGheader,DCBHEAD *pstDCBheader,DCBPOS *pstHeaderPosition);
extern BOOL QueryIniDCBheader(char szFileSpec[],CFGHEAD *pstCFGheader,DCBHEAD *pstDCBheader,DCBPOS *pstHeaderPosition);
extern BOOL PlaceIniDCBheader(char szFileSpec[],CFGHEAD *pstCFGheader,DCBHEAD *pstDCBheader,DCBPOS *pstHeaderPosition);
extern void InitializeCFGheader(CFGHEAD *pstConfigHeader);
extern void InitializeDCBheader(DCBHEAD *pstDCBheader,BOOL bInstallCOMscope);
extern int AddIniConfigHeader(char szFileSpec[],DCBPOS *pstDCBposition);

/*
** HELP.C function prototypes
*/
extern VOID DisplayHelpPanel(COMICFG *pstCOMiCFG,USHORT idPanel);
extern VOID DestroyHelpInstance(COMICFG *pstCOMiCFG);
extern BOOL HelpInit(COMICFG *pstCOMiCFG);

#define _INCL_COMi_CFG_H_

#endif


