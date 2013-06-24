/*
** UTIL.C function prototypes
*/
void RemoveSpaces(char szString[]);
extern LONG ASCIItoBin(char szNumber[],int iRadix);
extern void AppendTMP(char szFilePath[]);
extern void AppendHLP(char szFilePath[]);
extern void AppendINI(char szFilePath[]);
extern VOID AppendTripleDS(char szString[]);
extern BOOL GetFileName(HWND hwnd,char *pszFileName,char *pszTitle,PFNWP OpenFilterProc);

extern BOOL Checked(HWND hwndDlg,SHORT idDlgItem);
extern USHORT CheckButton(HWND hwndDlg,USHORT idItem,BOOL bCheck);
extern VOID ControlEnable(HWND hwnd,WORD idItem,BOOL bEnable);
extern VOID CenterDlgBox(HWND hwnd);
extern VOID MessageBox(HWND hwnd,PSZ pszMessage);

VOID MenuItemEnable(HWND hwnd,WORD idItem,BOOL bEnable);
VOID MenuItemCheck(HWND hwnd,WORD idItem,BOOL bCheck);
BOOL GetLongIntDlgItem(HWND hwndDlg,SHORT idEntryField,LONG *plValue);

VOID SetSystemMenu(HWND hwnd);

extern BOOL CleanConfigSys(HWND hwnd,char szDDspec[],USHORT usHelpID,BOOL bAskFirst);
#ifdef CONFIG_HEADER
BOOL AdjustConfigSys(HWND hwnd,char szDDname[],int iLoadCount,BOOL bMakeChanges,USHORT usHelpID);
#endif
void AppendPath(BYTE *pbyPathEnd, BYTE *pbyFileName);


