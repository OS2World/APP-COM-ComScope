#ifndef _INCL_UTILITY_H_

/*
** UTIL.C function prototypes
*/
void EXPENTRY RemoveLeadingSpaces(char szString[]);
void EXPENTRY RemoveSpaces(char szString[]);
LONG EXPENTRY ASCIItoBin(char szNumber[],int iRadix);
void EXPENTRY AppendTMP(char szFilePath[]);
void EXPENTRY AppendHLP(char szFilePath[]);
void EXPENTRY AppendINI(char szFilePath[]);
VOID EXPENTRY AppendTripleDS(char szString[]);
BOOL EXPENTRY GetFileName(HWND hwnd,char *pszFileName,char *pszTitle,PFNWP OpenFilterProc);
void EXPENTRY MakeDeviceName(char szName[]);

BOOL EXPENTRY Checked(HWND hwndDlg,SHORT idDlgItem);
USHORT EXPENTRY CheckButton(HWND hwndDlg,USHORT idItem,BOOL bCheck);
VOID EXPENTRY ControlEnable(HWND hwnd,USHORT idItem,BOOL bEnable);
VOID EXPENTRY CenterDlgBox(HWND hwnd);

#ifndef MessageBox  // because Franciscos code defines a message box macro
VOID EXPENTRY MessageBox(HWND hwnd,PSZ pszMessage);
#endif

VOID EXPENTRY MenuItemEnable(HWND hwnd,USHORT idItem,BOOL bEnable);
VOID EXPENTRY MenuItemCheck(HWND hwnd,USHORT idItem,BOOL bCheck);
BOOL EXPENTRY GetLongIntDlgItem(HWND hwndDlg,SHORT idEntryField,LONG *plValue);

VOID EXPENTRY RemoveSystemMenuItem(HWND hwnd,USHORT usMenuItem);

void EXPENTRY AppendPath(BYTE *pbyPathEnd, BYTE *pbyFileName);

BOOL EXPENTRY CleanConfigSys(HWND hwnd,char szDDspec[],USHORT usHelpID,BOOL bAskFirst);
BOOL EXPENTRY AdjustConfigSys(HWND hwnd,char szDDname[],int iLoadCount, BOOL bMakeChanges,USHORT usHelpID);
BOOL EXPENTRY AdjustConfigFile(HWND hwnd,char szFileSpec[], char szConfigLine[],int iLineCount, BOOL bNoPrompt, USHORT usHelpID);

#define _INCL_UTILITY_H_

#endif
