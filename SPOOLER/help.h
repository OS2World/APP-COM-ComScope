/*
**   HELP.H
*/
/*
**   We want to avoid automatically loading the help manager(HELPMGR.DLL),
**   since this takes up lots of memory.
**
**   Do this by only linking to the HELPMGR if user selects help item.
**
**   We replace the WinxxxxHelpInstance calls with our local versions.
**
**   These versions use DosLoadModule() and DosQueryProcAddr() to
**   call the "real" help manager functions.
**
**   The below function pointers, prototypes and variables are used
**   to this end.
*/

BOOL APIENTRY CALLAssociateHelpInstance (HWND hwndHelpInstance, HWND hwndApp);
BOOL APIENTRY CALLDestroyHelpInstance(HWND hwndHelpInstance);
HWND APIENTRY CALLCreateHelpInstance(HAB hab,PHELPINIT phinitHMInitStructure);
HWND APIENTRY CALLQueryHelpInstance(HWND hwndApp);

VOID EXPENTRY InitializeHelp(VOID);
BOOL EXPENTRY SetHelpStubHook(VOID);
VOID EXPENTRY ReleaseHelpStubHook(VOID);
INT  EXPENTRY HelpStubHook( HAB AppHAB, USHORT Context, USHORT IdTopic,
                            USHORT IdSubTopic, PRECTL RectLPtr );

extern HWND hwndHelp;
extern BOOL HelpStubHookIsSet;
extern BOOL HelpAlreadyInitialized;


