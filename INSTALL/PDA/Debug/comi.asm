	title	p:\Install\PDA\comi.c
	.386
	.387
CODE32	segment para use32 public 'CODE'
CODE32	ends
DATA32	segment para use32 public 'DATA'
DATA32	ends
CONST32_RO	segment para use32 public 'CONST'
CONST32_RO	ends
BSS32	segment para use32 public 'BSS'
BSS32	ends
DGROUP	group BSS32, DATA32
	assume	cs:FLAT, ds:FLAT, ss:FLAT, es:FLAT
	public	szFolderName
	public	szFolderSetup
	public	szFolderID
	public	szProgramObjectSetup
	public	szINFobjectSetup
	public	bLibsDirCreated
	public	bLibrariesRequired
	extrn	_dllentry:proc
	extrn	PrfOpenProfile:proc
	extrn	_sprintfieee:proc
	extrn	strcpy:proc
	extrn	strlen:proc
	extrn	WinQuerySysPointer:proc
	extrn	WinSetPointer:proc
	extrn	PrfQueryProfileData:proc
	extrn	DosForceDelete:proc
	extrn	strcmp:proc
	extrn	AppendINI:proc
	extrn	DosCopy:proc
	extrn	DosDelete:proc
	extrn	DosQueryPathInfo:proc
	extrn	_itoa:proc
	extrn	PrfWriteProfileString:proc
	extrn	PrfQueryProfileString:proc
	extrn	MenuItemEnable:proc
	extrn	PrfCloseProfile:proc
	extrn	PrfWriteProfileData:proc
	extrn	WinCreateObject:proc
	extrn	strcat:proc
	extrn	WinMessageBox:proc
	extrn	DosSetPathInfo:proc
	extrn	DosCreateDir:proc
	extrn	DosLoadModule:proc
	extrn	DosQueryProcAddr:proc
	extrn	PrfQueryProfileSize:proc
	extrn	_debug_malloc:proc
	extrn	strncmp:proc
	extrn	_debug_free:proc
	extrn	DosFreeModule:proc
	extrn	CleanConfigSys:proc
	extrn	AppendTMP:proc
	extrn	DosOpen:proc
	extrn	DosWrite:proc
	extrn	WinDestroyObject:proc
	extrn	DosDeleteDir:proc
	extrn	DosClose:proc
	extrn	_fullDump:dword
DATA32	segment
@STAT1	db "File_",0h
	align 04h
@STAT2	db "%s%s",0h
	align 04h
@STAT3	db "Installed",0h
	align 04h
@STAT4	db "Files",0h
	align 04h
@STAT5	db "%c:\DELLOCKS.CMD",0h
	align 04h
@STAT6	db "%s\%s",0h
	align 04h
@STAT7	db "Existing %s",0h
@STAT8	db "%c:\COMDDINI.OLD",0h
	align 04h
@STAT9	db "%c:\COMDDINI.OLD",0h
	align 04h
@STATa	db "%c:\COMDDINI.OLD",0h
	align 04h
@STATb	db "%c:\COMDDINI.OLD",0h
@STATc	db "%s",0h
@STATd	db "%s",0h
	align 04h
@STATe	db "Installed",0h
	align 04h
@STATf	db "Installed",0h
	align 04h
@STAT10	db "File_",0h
	align 04h
@STAT11	db "COMi",0h
	align 04h
@STAT12	db "Files",0h
	align 04h
@STAT13	db "COMi",0h
	align 04h
@STAT14	db "Installed",0h
	align 04h
@STAT15	db "Initialization",0h
	align 04h
@STAT16	db "Version",0h
@STAT17	db "File_",0h
	align 04h
@STAT18	db "%c:\OS2\DLL",0h
@STAT19	db "PDR",0h
@STAT1a	db "Files",0h
	align 04h
@STAT1b	db "PDR",0h
@STAT1c	db "Installed",0h
	align 04h
@STAT1d	db "PDR",0h
@STAT1e	db "PDR Library",0h
@STAT1f	db "COMi",0h
	align 04h
@STAT20	db "Spooler",0h
@STAT21	db "Installed",0h
	align 04h
@STAT22	db "File_",0h
	align 04h
@STAT23	db "COMscope",0h
	align 04h
@STAT24	db "Files",0h
	align 04h
@STAT25	db "COMscope",0h
	align 04h
@STAT26	db "Installed",0h
	align 04h
@STAT27	db "File_",0h
	align 04h
@STAT28	db "Utilities",0h
	align 04h
@STAT29	db "Files",0h
	align 04h
@STAT2a	db "Utilities",0h
	align 04h
@STAT2b	db "Installed",0h
	align 04h
@STAT2c	db "Installed",0h
	align 04h
@STAT2d	db "File_",0h
	align 04h
@STAT2e	db "Install",0h
@STAT2f	db "Files",0h
	align 04h
@STAT30	db "Install",0h
@STAT31	db "Installed",0h
	align 04h
@STAT32	db "File_",0h
	align 04h
@STAT33	db "Libraries",0h
	align 04h
@STAT34	db "Files",0h
	align 04h
@STAT35	db "Libraries",0h
	align 04h
@STAT36	db "Installed",0h
	align 04h
@STAT37	db "Base_file_",0h
	align 04h
@STAT38	db "Libraries",0h
	align 04h
@STAT39	db "Base Files",0h
	align 04h
@STAT3a	db "Libraries",0h
	align 04h
@STAT3b	db "Installed",0h
	align 04h
@STAT3c	db "Installed",0h
	align 04h
@STAT3d	db "Library Path",0h
	align 04h
@STAT3e	db "Installed",0h
	align 04h
@STAT3f	db "Program Path",0h
	align 04h
@STAT40	db "Installed",0h
	align 04h
@STAT41	db "Files",0h
	align 04h
@STAT42	db "%s\%s.DLL",0h
	align 04h
@STAT43	db "%s\%s.DLL",0h
	align 04h
@STAT44	db "COMi",0h
	align 04h
@STAT45	db "Configuration",0h
	align 04h
@STAT46	db "%s\%s",0h
	align 04h
@STAT47	db "COMi",0h
	align 04h
@STAT48	db "Help",0h
	align 04h
@STAT49	db "Object_",0h
@STAT4a	db "Installed",0h
	align 04h
@STAT4b	db "Objects",0h
@STAT4c	db "WPFolder",0h
	align 04h
@STAT4d	db "<WP_DESKTOP>",0h
@STAT4e	db ":1",0h
@STAT4f	db "WPFolder",0h
	align 04h
@STAT50	db "<WP_DESKTOP>",0h
	align 04h
@STAT51	db "Installed",0h
	align 04h
@STAT52	db "Folder",0h
	align 04h
@STAT53	db "<%s>",0h
	align 04h
@STAT54	db "%sEXENAME=VIEW.EXE;PARAM"
db "ETERS=%s\%s",0h
@STAT55	db "%s Users Guide",0h
	align 04h
@STAT56	db "WPProgram",0h
	align 04h
@STAT57	db "Installed",0h
	align 04h
@STAT58	db "%sEXENAME=%s\%s;STARTUPD"
db "IR=%s;NODROP=YES",0h
	align 04h
@STAT59	db ";PARAMETERS=/S /T;CCVIEW"
db "=YES",0h
	align 04h
@STAT5a	db "WPProgram",0h
	align 04h
@STAT5b	db "COMscope",0h
	align 04h
@STAT5c	db "Installed",0h
	align 04h
@STAT5d	db "%sEXENAME=%s\%s;STARTUPD"
db "IR=%s",0h
	align 04h
@STAT5e	db "WPProgram",0h
	align 04h
@STAT5f	db "OS/tools Install",0h
	align 04h
@STAT60	db "Installed",0h
	align 04h
@STAT61	db "Installed",0h
	align 04h
@STAT62	db "Objects",0h
@STAT63	db "At least one desktop obj"
db "ect was not created due "
db "to an unknown system err"
db "or.",0h
@STAT64	db "Object(s) Not Created!",0h
	align 04h
@STAT65	db "Do you want to create th"
db "e directory %s?",0h
@STAT66	db "Directory does not exist"
db "!",0h
	align 04h
@STAT67	db "Unable to create the dir"
db "ectory %s?",0h
	align 04h
@STAT68	db "Invalid Path Specificati"
db "on!",0h
@STAT69	db "%s is invalid.",0h
	align 04h
@STAT6a	db "Invalid Path Specificati"
db "on!",0h
@STAT6b	db "%s is a file.  Please se"
db "lect another directory.",0h
@STAT6c	db "Invalid Path Specificati"
db "on!",0h
@STAT6d	db "%s is the same, or newer"
db ", version than the file "
db "to be installed.",0ah,0ah,"Do you"
db " want to replace it?",0h
	align 04h
@STAT6e	db "Newer file exists!",0h
	align 04h
@STAT6f	db "%s is currently in open "
db "by another process.",0ah,0ah,"Ple"
db "ase correct and reinstal"
db "l.",0h
	align 04h
@STAT70	db "File Currently in Use!",0h
	align 04h
@STAT71	db "Source file not Found!",0h
	align 04h
@STAT72	db "Source path not Found!",0h
	align 04h
@STAT73	db "Access to Destination fi"
db "le is denied!",0h
	align 04h
@STAT74	db "Destination is not DOS d"
db "isk!",0h
	align 04h
@STAT75	db "Invalid Parameter!",0h
	align 04h
@STAT76	db "Destination drive is loc"
db "ked!",0h
	align 04h
@STAT77	db "Destination file name is"
db " a directory!",0h
	align 04h
@STAT78	db "Unexpected Error!",0h
	align 04h
@STAT79	db "Unable to copy %s to %s",0ah
db 0ah,"Do you want to continue"
db " file transfer?",0h
@STAT7a	db "Spooler",0h
@STAT7b	db "SPLPDREMOVEPORT",0h
@STAT7c	db "PM_SPOOLER_PORT",0h
@STAT7d	db "p:\Install\PDA\comi.c",0h
	align 04h
@STAT7e	db "PM_SPOOLER_PORT",0h
@STAT7f	db "COM",0h
@STAT80	db "PM_%s",0h
	align 04h
@STAT81	db "PORTDRIVER",0h
	align 04h
@STAT82	db "COMI_SPL;",0h
	align 04h
@STAT83	db "SPL_DEMO;",0h
	align 04h
@STAT84	db "p:\Install\PDA\comi.c",0h
	align 04h
@STAT85	db "Spooler",0h
@STAT86	db "PM_PORT_DRIVER",0h
	align 04h
@STAT87	db "COMI_SPL",0h
	align 04h
@STAT88	db "PM_PORT_DRIVER",0h
	align 04h
@STAT89	db "SPL_DEMO",0h
	align 04h
@STAT8a	db "%c:\COMDDINI.OLD",0h
	align 04h
@STAT8b	db "File_",0h
	align 04h
@STAT8c	db "Installed",0h
	align 04h
@STAT8d	db "Files",0h
	align 04h
@STAT8e	db "Installed",0h
	align 04h
@STAT8f	db "p:\Install\PDA\comi.c",0h
	align 04h
@STAT90	db "Failed to allocate Delet"
db "e path memory",0h
	align 04h
@STAT91	db "@ECHO OFF",0dh,0ah,"DEL %s > NUL",0dh
db 0ah,0h
	align 04h
@STAT92	db "%c:\DEL_COMi.CMD",0h
	align 04h
@STAT93	db "DEL %s > NUL",0dh,0ah,0h
	align 04h
@STAT94	db "Deleting a folder will c"
db "ause any objects that re"
db "side in that folder to b"
db "e deleted also.",0ah,0ah,"Do you "
db "want to delete the folde"
db "r?",0h
	align 04h
@STAT95	db "Deleting OS/tools Utilit"
db "ies Folder!",0h
@STAT96	db "Installed",0h
	align 04h
@STAT97	db "Folder",0h
	align 04h
@STAT98	db "Installed",0h
	align 04h
@STAT99	db "Object_1",0h
	align 04h
@STAT9a	db "Object_",0h
@STAT9b	db "Installed",0h
	align 04h
@STAT9c	db "Objects",0h
@STAT9d	db "Installed",0h
	align 04h
@STAT9e	db "Installed",0h
	align 04h
@STAT9f	db "Library Path",0h
	align 04h
@STATa0	db "Installed",0h
	align 04h
@STATa1	db "Program Path",0h
	align 04h
@STATa2	db "COMscope",0h
	align 04h
@STATa3	db "COMi",0h
	align 04h
@STATa4	db "One or more files were n"
db "ot deleted because they "
db "were being accessed by t"
db "his or some other proces"
db "s.",0h
	align 04h
@STATa5	db "Access Denied!",0h
	align 04h
@STATa6	db "DEL %c:\DELLOCK.CMD > NU"
db "L",0dh,0ah,0h
@STATa7	db "p:\Install\PDA\comi.c",0h
	align 04h
@STATa8	db "Uninstall Incomplete",0h
	align 04h
@STATa9	db "Uninstall Complete",0h
szFolderName	db "OS/tools",0dh,0ah,"Utilities",0h
	db 028h DUP (00H)
szFolderSetup	db "OBJECTID=<OS/tools_1833>"
db 0h
szFolderID	db "<OS/tools_1833>",0h
szProgramObjectSetup	db "NOAUTOCLOSE=NO;PROGTYPE="
db "PM;",0h
szINFobjectSetup	db "DEFAULTVIEW=RUNNING;NOPR"
db "INT=YES;PROGTYPE=PM;",0h
	dd	_dllentry
DATA32	ends
BSS32	segment
bLibsDirCreated	dd 0h
bLibrariesRequired	dd 0h
comm	szCOMscopeEXEname:byte:028h
comm	szInstallEXEname:byte:028h
comm	szCOMiINFname:byte:028h
comm	szSetupString:byte:0104h
comm	szPDRpath:byte:0104h
comm	szFileKey:byte:014h
comm	szMessage:byte:050h
comm	szCaption:byte:028h
comm	szDestSpec:byte:0104h
comm	szSourceSpec:byte:0104h
comm	szFileName:byte:050h
comm	szInstalledIniPath:byte:0104h
comm	stFileStatus:byte:018h
	align 04h
comm	ulInstalledFileStart:dword
	align 04h
comm	ulInstalledObjectStart:dword
	align 04h
comm	ulAttr:dword
comm	szPath:byte:0104h
comm	szFileNumber:byte:028h
BSS32	ends
CODE32	segment

; 59   {
	align 010h

	public InstallCOMi
InstallCOMi	proc
	push	ebp
	mov	ebp,esp
	sub	esp,048h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,012h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 65   BOOL bSuccess = TRUE;
	mov	dword ptr [ebp-018h],01h;	bSuccess

; 66   HPOINTER hPointer;
; 67   int iLen;
; 68   int iFileCount;
; 69   int iObjectCount;
; 70   int iEnd;
; 71   HOBJECT hObject;
; 72   BOOL bObjectBad;
; 73   unsigned int uiAttrib;
; 74   ULONG ulFileCount;
; 75   ULONG cbDataSize = sizeof(ULONG);
	mov	dword ptr [ebp-040h],04h;	cbDataSize

; 76   HINI hInstalledProfile;
; 77   HINI hSourceProfile;
; 78 
; 79   hSourceProfile = PrfOpenProfile(pstInst->hab,pstInst->pszSourceIniPath);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+028h]
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+0ch]
	call	PrfOpenProfile
	add	esp,08h
	mov	[ebp-048h],eax;	hSourceProfile

; 80   iEnd = sprintf(szFileNumber,"File_");
	mov	edx,offset FLAT:@STAT1
	mov	eax,offset FLAT:szFileNumber
	call	_sprintfieee
	mov	[ebp-02ch],eax;	iEnd

; 81   strcpy(szDestSpec,pstInst->pszAppsPath);
	mov	edx,[ebp+08h];	pstInst
	mov	edx,[edx+01ch]
	mov	eax,offset FLAT:szDestSpec
	call	strcpy

; 82   iDestPathEnd = strlen(szDestSpec);
	mov	eax,offset FLAT:szDestSpec
	call	strlen
	mov	[ebp-0ch],eax;	iDestPathEnd

; 83   szDestSpec[iDestPathEnd++] = '\\';
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],05ch
	mov	eax,[ebp-0ch];	iDestPathEnd
	inc	eax
	mov	[ebp-0ch],eax;	iDestPathEnd

; 84   szDestSpec[iDestPathEnd] = 0;
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],0h

; 85   hPointer = WinQuerySysPointer(HWND_DESKTOP,SPTR_WAIT,FALSE);
	push	0h
	push	03h
	push	01h
	call	WinQuerySysPointer
	add	esp,0ch
	mov	[ebp-01ch],eax;	hPointer

; 86   WinSetPointer(HWND_DESKTOP,hPointer);
	push	dword ptr [ebp-01ch];	hPointer
	push	01h
	call	WinSetPointer
	add	esp,08h

; 87 
; 88   strcpy(szSourceSpec,pstInst->pszSourcePath);
	mov	edx,[ebp+08h];	pstInst
	mov	edx,[edx+024h]
	mov	eax,offset FLAT:szSourceSpec
	call	strcpy

; 89   iSourcePathEnd = strlen(szSourceSpec);
	mov	eax,offset FLAT:szSourceSpec
	call	strlen
	mov	[ebp-010h],eax;	iSourcePathEnd

; 90   szSourceSpec[iSourcePathEnd++] = '\\';
	mov	eax,[ebp-010h];	iSourcePathEnd
	mov	byte ptr [eax+ szSourceSpec],05ch
	mov	eax,[ebp-010h];	iSourcePathEnd
	inc	eax
	mov	[ebp-010h],eax;	iSourcePathEnd

; 91 
; 92   szCOMscopeEXEname[0] = 0;
	mov	byte ptr  szCOMscopeEXEname,0h

; 93   szInstallEXEname[0] = 0;
	mov	byte ptr  szInstallEXEname,0h

; 94 
; 95   sprintf(szInstalledIniPath,"%s%s",szDestSpec,pstInst->paszStrings[UNINSTALLINIFILENAME]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+02ch]
	push	offset FLAT:szDestSpec
	mov	edx,offset FLAT:@STAT2
	mov	eax,offset FLAT:szInstalledIniPath
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 96   if (!MakePath(pstInst->hwndFrame,pstInst->pszAppsPath))
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+01ch]
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+08h]
	call	MakePath
	add	esp,08h
	test	eax,eax
	jne	@BLBL1

; 97    return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL1:

; 98   hInstalledProfile = PrfOpenProfile(pstInst->hab,szInstalledIniPath);
	push	offset FLAT:szInstalledIniPath
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+0ch]
	call	PrfOpenProfile
	add	esp,08h
	mov	[ebp-044h],eax;	hInstalledProfile

; 99   cbDataSize = sizeof(ULONG);
	mov	dword ptr [ebp-040h],04h;	cbDataSize

; 100   if (!PrfQueryProfileData(hInstalledProfile,"Installed","Files",&iFileCount,&cbDataSize))
	lea	eax,[ebp-040h];	cbDataSize
	push	eax
	lea	eax,[ebp-024h];	iFileCount
	push	eax
	push	offset FLAT:@STAT4
	push	offset FLAT:@STAT3
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfQueryProfileData
	add	esp,014h
	test	eax,eax
	jne	@BLBL2

; 101     iFileCount = 0;
	mov	dword ptr [ebp-024h],0h;	iFileCount
@BLBL2:

; 102   sprintf(szPath,"%c:\\DELLOCKS.CMD",pstInst->chBootDrive);
	mov	ecx,[ebp+08h];	pstInst
	xor	eax,eax
	mov	al,[ecx+02h]
	push	eax
	mov	edx,offset FLAT:@STAT5
	mov	eax,offset FLAT:szPath
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 103   DosForceDelete(szPath);
	push	offset FLAT:szPath
	call	DosForceDelete
	add	esp,04h

; 104   if (pstInst->bCopyCOMi)
	mov	eax,[ebp+08h];	pstInst
	test	byte ptr [eax+018h],01h
	je	@BLBL3

; 105     {
; 106     strcpy(szDestSpec,pstInst->pszAppsPath);
	mov	edx,[ebp+08h];	pstInst
	mov	edx,[edx+01ch]
	mov	eax,offset FLAT:szDestSpec
	call	strcpy

; 107     iDestPathEnd = strlen(szDestSpec);
	mov	eax,offset FLAT:szDestSpec
	call	strlen
	mov	[ebp-0ch],eax;	iDestPathEnd

; 108     szDestSpec[iDestPathEnd++] = '\\';
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],05ch
	mov	eax,[ebp-0ch];	iDestPathEnd
	inc	eax
	mov	[ebp-0ch],eax;	iDestPathEnd

; 109     szDestSpec[iDestPathEnd] = 0;
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],0h

; 110     sprintf(pstInst->paszStrings[DRIVERINISPEC],"%s\\%s",pstInst->pszAppsPath,pstInst->paszStrings[DDNAME]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+034h]
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+01ch]
	mov	edx,offset FLAT:@STAT6
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+03ch]
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 111     if (strlen(pstInst->paszStrings[CURRENTDRIVERSPEC]) != 0)
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+044h]
	call	strlen
	test	eax,eax
	je	@BLBL4

; 112       {
; 113       if (strcmp(pstInst->paszStrings[CURRENTDRIVERSPEC],pstInst->paszStrings[DRIVERINISPEC]) != 0)
	mov	edx,[ebp+08h];	pstInst
	mov	edx,[edx+03ch]
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+044h]
	call	strcmp
	test	eax,eax
	je	@BLBL5

; 114         {
; 115         strcpy(szPath,pstInst->paszStrings[DDNAME]);
	mov	edx,[ebp+08h];	pstInst
	mov	edx,[edx+034h]
	mov	eax,offset FLAT:szPath
	call	strcpy

; 116         AppendINI(szPath);
	push	offset FLAT:szPath
	call	AppendINI
	add	esp,04h

; 117         sprintf(szFileName,"Existing %s",szPath);
	push	offset FLAT:szPath
	mov	edx,offset FLAT:@STAT7
	mov	eax,offset FLAT:szFileName
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 118         if (pstInst->paszStrings[REMOVEOLDDRIVERSPEC] != NULL)
	mov	eax,[ebp+08h];	pstInst
	cmp	dword ptr [eax+030h],0h
	je	@BLBL6

; 119           strcpy(pstInst->paszStrings[REMOVEOLDDRIVERSPEC],pstInst->paszStrings[CURRENTDRIVERSPEC]);
	mov	edx,[ebp+08h];	pstInst
	mov	edx,[edx+044h]
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+030h]
	call	strcpy
@BLBL6:

; 120         AppendINI(pstInst->paszStrings[DRIVERINISPEC]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+03ch]
	call	AppendINI
	add	esp,04h

; 121         AppendINI(pstInst->paszStrings[CURRENTDRIVERSPEC]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+044h]
	call	AppendINI
	add	esp,04h

; 122         pstInst->pfnPrintProgress(szFileName,pstInst->paszStrings[DRIVERINISPEC]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+03ch]
	push	offset FLAT:szFileName
	mov	ecx,[ebp+08h];	pstInst
	call	dword ptr [ecx+014h]
	add	esp,08h

; 123         if (pstInst->bSavedDriverIniFile)
	mov	eax,[ebp+08h];	pstInst
	test	byte ptr [eax+018h],04h
	je	@BLBL7

; 124           {
; 125           sprintf(pstInst->paszStrings[CURRENTDRIVERSPEC],"%c:\\COMDDINI.OLD",pstInst->chBootDrive);
	mov	ecx,[ebp+08h];	pstInst
	xor	eax,eax
	mov	al,[ecx+02h]
	push	eax
	mov	edx,offset FLAT:@STAT8
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+044h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 126           DosCopy(pstInst->paszStrings[CURRENTDRIVERSPEC],pstInst->paszStrings[DRIVERINISPEC],DCPY_EXISTING);
	push	01h
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+03ch]
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+044h]
	call	DosCopy
	add	esp,0ch

; 127           pstInst->bSavedDriverIniFile = FALSE;
	mov	eax,[ebp+08h];	pstInst
	and	byte ptr [eax+018h],0fbh

; 128           if (pstInst->fCurrentIni != UNINSTALL_SAVE_INI)
	mov	eax,[ebp+08h];	pstInst
	mov	al,[eax+01ah]
	and	eax,03h
	cmp	eax,02h
	je	@BLBL14

; 129             DosDelete(pstInst->paszStrings[CURRENTDRIVERSPEC]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+044h]
	call	DosDelete
	add	esp,04h

; 130           }
	jmp	@BLBL14
	align 010h
@BLBL7:

; 131         else
; 132           if (DosCopy(pstInst->paszStrings[CURRENTDRIVERSPEC],pstInst->paszStrings[DRIVERINISPEC],DCPY_EXISTING) != NO_ERROR)
	push	01h
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+03ch]
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+044h]
	call	DosCopy
	add	esp,0ch
	test	eax,eax
	je	@BLBL14

; 133             {
; 134             sprintf(pstInst->paszStrings[CURRENTDRIVERSPEC],"%c:\\COMDDINI.OLD",pstInst->chBootDrive);
	mov	ecx,[ebp+08h];	pstInst
	xor	eax,eax
	mov	al,[ecx+02h]
	push	eax
	mov	edx,offset FLAT:@STAT9
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+044h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 135             DosCopy(pstInst->paszStrings[CURRENTDRIVERSPEC],pstInst->paszStrings[DRIVERINISPEC],DCPY_EXISTING);
	push	01h
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+03ch]
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+044h]
	call	DosCopy
	add	esp,0ch

; 136             DosForceDelete(pstInst->paszStrings[CURRENTDRIVERSPEC]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+044h]
	call	DosForceDelete
	add	esp,04h

; 137             }

; 138         }
	jmp	@BLBL14
	align 010h
@BLBL5:

; 139       else
; 140         {
; 141         rc = DosQueryPathInfo(pstInst->paszStrings[CURRENTDRIVERSPEC],1,&stFileStatus,sizeof(FILESTATUS3));
	push	018h
	push	offset FLAT:stFileStatus
	push	01h
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+044h]
	call	DosQueryPathInfo
	add	esp,010h
	mov	[ebp-014h],eax;	rc

; 142         if ((rc == ERROR_PATH_NOT_FOUND) || (rc == ERROR_FILE_NOT_FOUND))
	cmp	dword ptr [ebp-014h],03h;	rc
	je	@BLBL12
	cmp	dword ptr [ebp-014h],02h;	rc
	jne	@BLBL14
@BLBL12:

; 143           {
; 144           sprintf(pstInst->paszStrings[CURRENTDRIVERSPEC],"%c:\\COMDDINI.OLD",pstInst->chBootDrive);
	mov	ecx,[ebp+08h];	pstInst
	xor	eax,eax
	mov	al,[ecx+02h]
	push	eax
	mov	edx,offset FLAT:@STATa
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+044h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 145           DosCopy(pstInst->paszStrings[CURRENTDRIVERSPEC],pstInst->paszStrings[DRIVERINISPEC],DCPY_EXISTING);
	push	01h
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+03ch]
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+044h]
	call	DosCopy
	add	esp,0ch

; 146           DosForceDelete(pstInst->paszStrings[CURRENTDRIVERSPEC]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+044h]
	call	DosForceDelete
	add	esp,04h

; 147           }

; 148         }

; 149       }
	jmp	@BLBL14
	align 010h
@BLBL4:

; 150     else
; 151       {
; 152       AppendINI(pstInst->paszStrings[DRIVERINISPEC]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+03ch]
	call	AppendINI
	add	esp,04h

; 153       rc = DosQueryPathInfo(pstInst->paszStrings[DRIVERINISPEC],1,&stFileStatus,sizeof(FILESTATUS3));
	push	018h
	push	offset FLAT:stFileStatus
	push	01h
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+03ch]
	call	DosQueryPathInfo
	add	esp,010h
	mov	[ebp-014h],eax;	rc

; 154       if ((rc == ERROR_PATH_NOT_FOUND) || (rc == ERROR_FILE_NOT_FOUND))
	cmp	dword ptr [ebp-014h],03h;	rc
	je	@BLBL15
	cmp	dword ptr [ebp-014h],02h;	rc
	jne	@BLBL14
@BLBL15:

; 155         {
; 156         sprintf(szPath,"%c:\\COMDDINI.OLD",pstInst->chBootDrive);
	mov	ecx,[ebp+08h];	pstInst
	xor	eax,eax
	mov	al,[ecx+02h]
	push	eax
	mov	edx,offset FLAT:@STATb
	mov	eax,offset FLAT:szPath
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 157         DosCopy(szPath,pstInst->paszStrings[DRIVERINISPEC],DCPY_EXISTING);
	push	01h
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+03ch]
	push	offset FLAT:szPath
	call	DosCopy
	add	esp,0ch

; 158         DosForceDelete(szPath);
	push	offset FLAT:szPath
	call	DosForceDelete
	add	esp,04h

; 159         }

; 160       }
@BLBL14:

; 161     AppendINI(pstInst->paszStrings[DRIVERINISPEC]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+03ch]
	call	AppendINI
	add	esp,04h

; 162     sprintf(&szDestSpec[iDestPathEnd],"%s",pstInst->paszStrings[DDNAME]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+034h]
	mov	edx,offset FLAT:@STATc
	mov	eax,[ebp-0ch];	iDestPathEnd
	add	eax,offset FLAT:szDestSpec
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 163     sprintf(&szSourceSpec[iSourcePathEnd],"%s",pstInst->paszStrings[DDNAME]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+034h]
	mov	edx,offset FLAT:@STATd
	mov	eax,[ebp-010h];	iSourcePathEnd
	add	eax,offset FLAT:szSourceSpec
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 164     pstInst->pfnPrintProgress(pstInst->paszStrings[DDNAME],szDestSpec);
	push	offset FLAT:szDestSpec
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+034h]
	mov	ecx,[ebp+08h];	pstInst
	call	dword ptr [ecx+014h]
	add	esp,08h

; 165     if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
	push	01h
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	DosCopy
	add	esp,0ch
	mov	[ebp-014h],eax;	rc
	cmp	dword ptr [ebp-014h],0h;	rc
	je	@BLBL17

; 166       {
; 167       bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 168       if (!DisplayCopyError(pstInst->paszStrings[DDNAME],szDestSpec,rc))
	push	dword ptr [ebp-014h];	rc
	push	offset FLAT:szDestSpec
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+034h]
	call	DisplayCopyError
	add	esp,0ch
	test	eax,eax
	je	gtFreePathMem19

; 169         goto gtFreePathMem;
; 170       }
@BLBL17:

; 171     ClearReadOnly(szDestSpec);
	push	offset FLAT:szDestSpec
	call	ClearReadOnly
	add	esp,04h

; 172     itoa(++iFileCount,&szFileNumber[iEnd],10);
	mov	eax,[ebp-024h];	iFileCount
	inc	eax
	mov	[ebp-024h],eax;	iFileCount
	mov	ecx,0ah
	mov	edx,[ebp-02ch];	iEnd
	add	edx,offset FLAT:szFileNumber
	mov	eax,[ebp-024h];	iFileCount
	call	_itoa

; 173     PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileNumber
	push	offset FLAT:@STATe
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileString
	add	esp,010h

; 174     AppendINI(szSourceSpec);
	push	offset FLAT:szSourceSpec
	call	AppendINI
	add	esp,04h

; 175     if (DosQueryPathInfo(szSourceSpec,FIL_STANDARD,&stFileStatus,sizeof(FILESTATUS3)) == NO_ERROR)
	push	018h
	push	offset FLAT:stFileStatus
	push	01h
	push	offset FLAT:szSourceSpec
	call	DosQueryPathInfo
	add	esp,010h
	test	eax,eax
	jne	@BLBL20

; 176       {
; 177       AppendINI(szDestSpec);
	push	offset FLAT:szDestSpec
	call	AppendINI
	add	esp,04h

; 178       strcpy(szPath,pstInst->paszStrings[DDNAME]);
	mov	edx,[ebp+08h];	pstInst
	mov	edx,[edx+034h]
	mov	eax,offset FLAT:szPath
	call	strcpy

; 179       AppendINI(szPath);
	push	offset FLAT:szPath
	call	AppendINI
	add	esp,04h

; 180       pstInst->pfnPrintProgress(szPath,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szPath
	mov	ecx,[ebp+08h];	pstInst
	call	dword ptr [ecx+014h]
	add	esp,08h

; 181       DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING);
	push	01h
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	DosCopy
	add	esp,0ch

; 182       ClearReadOnly(szDestSpec);
	push	offset FLAT:szDestSpec
	call	ClearReadOnly
	add	esp,04h

; 183       itoa(++iFileCount,&szFileNumber[iEnd],10);
	mov	eax,[ebp-024h];	iFileCount
	inc	eax
	mov	[ebp-024h],eax;	iFileCount
	mov	ecx,0ah
	mov	edx,[ebp-02ch];	iEnd
	add	edx,offset FLAT:szFileNumber
	mov	eax,[ebp-024h];	iFileCount
	call	_itoa

; 184       PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileNumber
	push	offset FLAT:@STATf
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileString
	add	esp,010h

; 185       }
@BLBL20:

; 186     strcpy(szFileKey,"File_");
	mov	edx,offset FLAT:@STAT10
	mov	eax,offset FLAT:szFileKey
	call	strcpy

; 187     iCountPos = strlen(szFileKey);
	mov	eax,offset FLAT:szFileKey
	call	strlen
	mov	[ebp-08h],eax;	iCountPos

; 188     ulFileCount = 0;
	mov	dword ptr [ebp-03ch],0h;	ulFileCount

; 189     PrfQueryProfileData(hSourceProfile,"COMi","Files",&ulFileCount,&cbDataSize);
	lea	eax,[ebp-040h];	cbDataSize
	push	eax
	lea	eax,[ebp-03ch];	ulFileCount
	push	eax
	push	offset FLAT:@STAT12
	push	offset FLAT:@STAT11
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfQueryProfileData
	add	esp,014h

; 190     for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
	mov	dword ptr [ebp-04h],01h;	iIndex
	mov	eax,[ebp-04h];	iIndex
	cmp	[ebp-03ch],eax;	ulFileCount
	jb	@BLBL21
	align 010h
@BLBL22:

; 191       {
; 192       itoa(iIndex,&szFileKey[iCountPos],10);
	mov	ecx,0ah
	mov	edx,[ebp-08h];	iCountPos
	add	edx,offset FLAT:szFileKey
	mov	eax,[ebp-04h];	iIndex
	call	_itoa

; 193       if (PrfQueryProfileString(hSourceProfile,"COMi",szFileKey,0,szFileName,18) != 0)
	push	012h
	push	offset FLAT:szFileName
	push	0h
	push	offset FLAT:szFileKey
	push	offset FLAT:@STAT13
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	je	@BLBL23

; 194         {
; 195         if (iIndex == 1)
	cmp	dword ptr [ebp-04h],01h;	iIndex
	jne	@BLBL24

; 196           strcpy(szCOMiINFname,szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,offset FLAT:szCOMiINFname
	call	strcpy
@BLBL24:

; 197 #ifdef this_junk
; 198         if (iIndex == 2)
; 199           strcpy(szConfigEXEname,szFileName);
; 200 #endif
; 201         strcpy(&szDestSpec[iDestPathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-0ch];	iDestPathEnd
	add	eax,offset FLAT:szDestSpec
	call	strcpy

; 202         strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-010h];	iSourcePathEnd
	add	eax,offset FLAT:szSourceSpec
	call	strcpy

; 203         pstInst->pfnPrintProgress(szFileName,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	mov	ecx,[ebp+08h];	pstInst
	call	dword ptr [ecx+014h]
	add	esp,08h

; 204         if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
	push	01h
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	DosCopy
	add	esp,0ch
	mov	[ebp-014h],eax;	rc
	cmp	dword ptr [ebp-014h],0h;	rc
	je	@BLBL25

; 205           {
; 206           bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 207           if (!DisplayCopyError(szFileName,szDestSpec,rc))
	push	dword ptr [ebp-014h];	rc
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	call	DisplayCopyError
	add	esp,0ch
	test	eax,eax
	je	gtFreePathMem19

; 208             goto gtFreePathMem;
; 209           }
@BLBL25:

; 210         ClearReadOnly(szDestSpec);
	push	offset FLAT:szDestSpec
	call	ClearReadOnly
	add	esp,04h

; 211         itoa(++iFileCount,&szFileNumber[iEnd],10);
	mov	eax,[ebp-024h];	iFileCount
	inc	eax
	mov	[ebp-024h],eax;	iFileCount
	mov	ecx,0ah
	mov	edx,[ebp-02ch];	iEnd
	add	edx,offset FLAT:szFileNumber
	mov	eax,[ebp-024h];	iFileCount
	call	_itoa

; 212         PrfWriteProfileString(hInsta
; 212 lledProfile,"Installed",szFileNumber,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileNumber
	push	offset FLAT:@STAT14
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileString
	add	esp,010h

; 213         }
@BLBL23:

; 214       }

; 190     for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	mov	eax,[ebp-04h];	iIndex
	cmp	[ebp-03ch],eax;	ulFileCount
	jae	@BLBL22
@BLBL21:

; 215     MenuItemEnable(pstInst->hwndFrame,IDM_SETUP,TRUE);
	push	01h
	push	01389h
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+08h]
	call	MenuItemEnable
	add	esp,0ch

; 220     PrfWriteProfileString(HINI_USERPROFILE,pstInst->paszStrings[CONFIGDDNAME],"Initialization",pstInst->paszStrings[DRIVERINISPEC]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+03ch]
	push	offset FLAT:@STAT15
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+038h]
	push	0ffffffffh
	call	PrfWriteProfileString
	add	esp,010h

; 221     PrfWriteProfileString(HINI_USERPROFILE,pstInst->paszStrings[CONFIGDDNAME],"Version",pstInst->paszStrings[COMIVERSION]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+054h]
	push	offset FLAT:@STAT16
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+038h]
	push	0ffffffffh
	call	PrfWriteProfileString
	add	esp,010h

; 222     }
@BLBL3:

; 223   if (pstInst->bCopyPDR)
	mov	eax,[ebp+08h];	pstInst
	test	byte ptr [eax+018h],08h
	je	@BLBL28

; 225     strcpy(szFileKey,"File_");
	mov	edx,offset FLAT:@STAT17
	mov	eax,offset FLAT:szFileKey
	call	strcpy

; 226     iCountPos = strlen(szFileKey);
	mov	eax,offset FLAT:szFileKey
	call	strlen
	mov	[ebp-08h],eax;	iCountPos

; 227     sprintf(szDestSpec,"%c:\\OS2\\DLL",pstInst->chBootDrive);
	mov	ecx,[ebp+08h];	pstInst
	xor	eax,eax
	mov	al,[ecx+02h]
	push	eax
	mov	edx,offset FLAT:@STAT18
	mov	eax,offset FLAT:szDestSpec
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 228     strcpy(szPDRpath,szDestSpec);
	mov	edx,offset FLAT:szDestSpec
	mov	eax,offset FLAT:szPDRpath
	call	strcpy

; 229     iDestPathEnd = strlen(szDestSpec);
	mov	eax,offset FLAT:szDestSpec
	call	strlen
	mov	[ebp-0ch],eax;	iDestPathEnd

; 230     szDestSpec[iDestPathEnd++] = '\\';
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],05ch
	mov	eax,[ebp-0ch];	iDestPathEnd
	inc	eax
	mov	[ebp-0ch],eax;	iDestPathEnd

; 231     szDestSpec[iDestPathEnd] = 0;
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],0h

; 232     ulFileCount = 0;
	mov	dword ptr [ebp-03ch],0h;	ulFileCount

; 233     PrfQueryProfileData(hSourceProfile,"PDR","Files",&ulFileCount,&cbDataSize);
	lea	eax,[ebp-040h];	cbDataSize
	push	eax
	lea	eax,[ebp-03ch];	ulFileCount
	push	eax
	push	offset FLAT:@STAT1a
	push	offset FLAT:@STAT19
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfQueryProfileData
	add	esp,014h

; 234     for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
	mov	dword ptr [ebp-04h],01h;	iIndex
	mov	eax,[ebp-04h];	iIndex
	cmp	[ebp-03ch],eax;	ulFileCount
	jb	@BLBL29
	align 010h
@BLBL30:

; 236       itoa(iIndex,&szFileKey[iCountPos],10);
	mov	ecx,0ah
	mov	edx,[ebp-08h];	iCountPos
	add	edx,offset FLAT:szFileKey
	mov	eax,[ebp-04h];	iIndex
	call	_itoa

; 237       strcpy(&szDestSpec[iDestPathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-0ch];	iDestPathEnd
	add	eax,offset FLAT:szDestSpec
	call	strcpy

; 238       if (PrfQueryProfileString(hSourceProfile,"PDR",szFileKey,0,szFileName,18) != 0)
	push	012h
	push	offset FLAT:szFileName
	push	0h
	push	offset FLAT:szFileKey
	push	offset FLAT:@STAT1b
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	je	@BLBL31

; 240         strcpy(&szDestSpec[iDestPathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-0ch];	iDestPathEnd
	add	eax,offset FLAT:szDestSpec
	call	strcpy

; 241         strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-010h];	iSourcePathEnd
	add	eax,offset FLAT:szSourceSpec
	call	strcpy

; 242         pstInst->pfnPrintProgress(szFileName,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	mov	ecx,[ebp+08h];	pstInst
	call	dword ptr [ecx+014h]
	add	esp,08h

; 243         if ((rc = DosCopy(szSourceSpec,szDestSpec,0L)) != NO_ERROR)
	push	0h
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	DosCopy
	add	esp,0ch
	mov	[ebp-014h],eax;	rc
	cmp	dword ptr [ebp-014h],0h;	rc
	je	@BLBL32

; 245           switch (CompareFileDate(szSourceSpec,szDestSpec))
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	CompareFileDate
	add	esp,08h
	and	eax,0ffffh
	jmp	@BLBL111
	align 04h
@BLBL112:

; 248               if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
	push	01h
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	DosCopy
	add	esp,0ch
	mov	[ebp-014h],eax;	rc
	cmp	dword ptr [ebp-014h],0h;	rc
	je	@BLBL33

; 250                 bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 251                 if (!DisplayCopyError(szFileName,szDestSpec,rc))
	push	dword ptr [ebp-014h];	rc
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	call	DisplayCopyError
	add	esp,0ch
	test	eax,eax
	je	gtFreePathMem19

; 253                 }
@BLBL33:

; 254               break;
	jmp	@BLBL110
	align 04h
@BLBL113:

; 256               continue;
	jmp	@BLBL35
	align 010h
@BLBL114:

; 258               bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 259               goto gtFreePathMem;
	jmp	gtFreePathMem19
	align 010h
	jmp	@BLBL110
	align 04h
@BLBL111:
	cmp	eax,06h
	je	@BLBL112
	cmp	eax,07h
	je	@BLBL113
	cmp	eax,02h
	je	@BLBL114
@BLBL110:

; 262           }
@BLBL32:

; 263         ClearReadOnly(szDestSpec);
	push	offset FLAT:szDestSpec
	call	ClearReadOnly
	add	esp,04h

; 264         itoa(++iFileCount,&szFileNumber[iEnd],10);
	mov	eax,[ebp-024h];	iFileCount
	inc	eax
	mov	[ebp-024h],eax;	iFileCount
	mov	ecx,0ah
	mov	edx,[ebp-02ch];	iEnd
	add	edx,offset FLAT:szFileNumber
	mov	eax,[ebp-024h];	iFileCount
	call	_itoa

; 265         PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileNumber
	push	offset FLAT:@STAT1c
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileString
	add	esp,010h

; 266         }
@BLBL31:

; 267       if (bSuccess)
	cmp	dword ptr [ebp-018h],0h;	bSuccess
	je	@BLBL35

; 268         pstInst->bBaseLibrariesCopied = TRUE;
	mov	eax,[ebp+08h];	pstInst
	or	byte ptr [eax+018h],080h

; 269       }
@BLBL35:

; 234     for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	mov	eax,[ebp-04h];	iIndex
	cmp	[ebp-03ch],eax;	ulFileCount
	jae	@BLBL30
@BLBL29:

; 270     if (PrfQueryProfileString(hSourceProfile,"PDR","PDR Library",0,szFileName,18) != 0)
	push	012h
	push	offset FLAT:szFileName
	push	0h
	push	offset FLAT:@STAT1e
	push	offset FLAT:@STAT1d
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	je	@BLBL28

; 273       strcpy(&szDestSpec[iDestPathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-0ch];	iDestPathEnd
	add	eax,offset FLAT:szDestSpec
	call	strcpy

; 274       PrfWriteProfileString(HINI_USERPROFILE,"COMi","Spooler",szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:@STAT20
	push	offset FLAT:@STAT1f
	push	0ffffffffh
	call	PrfWriteProfileString
	add	esp,010h

; 275       strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-010h];	iSourcePathEnd
	add	eax,offset FLAT:szSourceSpec
	call	strcpy

; 276       pstInst->pfnPrintProgress(szFileName,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	mov	ecx,[ebp+08h];	pstInst
	call	dword ptr [ecx+014h]
	add	esp,08h

; 277       if ((rc = DosCopy(szSourceSpec,szDestSpec,0L)) != NO_ERROR)
	push	0h
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	DosCopy
	add	esp,0ch
	mov	[ebp-014h],eax;	rc
	cmp	dword ptr [ebp-014h],0h;	rc
	je	@BLBL39

; 279         switch (CompareFileDate(szSourceSpec,szDestSpec))
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	CompareFileDate
	add	esp,08h
	and	eax,0ffffh
	jmp	@BLBL116
	align 04h
@BLBL117:

; 282             if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
	push	01h
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	DosCopy
	add	esp,0ch
	mov	[ebp-014h],eax;	rc
	cmp	dword ptr [ebp-014h],0h;	rc
	je	@BLBL40

; 284               bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 285               if (!DisplayCopyError(szFileName,szDestSpec,rc))
	push	dword ptr [ebp-014h];	rc
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	call	DisplayCopyError
	add	esp,0ch
	test	eax,eax
	je	gtFreePathMem19

; 287               }
@BLBL40:

; 288             break;
	jmp	@BLBL115
	align 04h
@BLBL118:

; 290             break;
	jmp	@BLBL115
	align 04h
@BLBL119:

; 292             bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 293             goto gtFreePathMem;
	jmp	gtFreePathMem19
	align 010h
	jmp	@BLBL115
	align 04h
@BLBL116:
	cmp	eax,06h
	je	@BLBL117
	cmp	eax,07h
	je	@BLBL118
	cmp	eax,02h
	je	@BLBL119
@BLBL115:

; 296         }
@BLBL39:

; 297       ClearReadOnly(szDestSpec);
	push	offset FLAT:szDestSpec
	call	ClearReadOnly
	add	esp,04h

; 298       itoa(++iFileCount,&szFileNumber[iEnd],10);
	mov	eax,[ebp-024h];	iFileCount
	inc	eax
	mov	[ebp-024h],eax;	iFileCount
	mov	ecx,0ah
	mov	edx,[ebp-02ch];	iEnd
	add	edx,offset FLAT:szFileNumber
	mov	eax,[ebp-024h];	iFileCount
	call	_itoa

; 299       PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileNumber
	push	offset FLAT:@STAT21
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileString
	add	esp,010h

; 300       }

; 301     }
@BLBL28:

; 302   if (pstInst->bCopyCOMscope)
	mov	eax,[ebp+08h];	pstInst
	test	byte ptr [eax+018h],02h
	je	@BLBL42

; 304     bLibrariesRequired = TRUE;
	mov	dword ptr  bLibrariesRequired,01h

; 305     szCOMscopeEXEname[0] = 0;
	mov	byte ptr  szCOMscopeEXEname,0h

; 306     strcpy(szDestSpec,pstInst->pszAppsPath);
	mov	edx,[ebp+08h];	pstInst
	mov	edx,[edx+01ch]
	mov	eax,offset FLAT:szDestSpec
	call	strcpy

; 307     iDestPathEnd = strlen(szDestSpec);
	mov	eax,offset FLAT:szDestSpec
	call	strlen
	mov	[ebp-0ch],eax;	iDestPathEnd

; 308     szDestSpec[iDestPathEnd++] = '\\';
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],05ch
	mov	eax,[ebp-0ch];	iDestPathEnd
	inc	eax
	mov	[ebp-0ch],eax;	iDestPathEnd

; 309     szDestSpec[iDestPathEnd] = 0;
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],0h

; 310     strcpy(szFileKey,"File_");
	mov	edx,offset FLAT:@STAT22
	mov	eax,offset FLAT:szFileKey
	call	strcpy

; 311     iCountPos = strlen(szFileKey);
	mov	eax,offset FLAT:szFileKey
	call	strlen
	mov	[ebp-08h],eax;	iCountPos

; 312     ulFileCount = 0;
	mov	dword ptr [ebp-03ch],0h;	ulFileCount

; 313     PrfQueryProfileData(hSourceProfile,"COMscope","Files",&ulFileCount,&cbDataSize);
	lea	eax,[ebp-040h];	cbDataSize
	push	eax
	lea	eax,[ebp-03ch];	ulFileCount
	push	eax
	push	offset FLAT:@STAT24
	push	offset FLAT:@STAT23
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfQueryProfileData
	add	esp,014h

; 314     for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
	mov	dword ptr [ebp-04h],01h;	iIndex
	mov	eax,[ebp-04h];	iIndex
	cmp	[ebp-03ch],eax;	ulFileCount
	jb	@BLBL42
	align 010h
@BLBL44:

; 316       itoa(iIndex,&szFileKey[iCountPos],10);
	mov	ecx,0ah
	mov	edx,[ebp-08h];	iCountPos
	add	edx,offset FLAT:szFileKey
	mov	eax,[ebp-04h];	iIndex
	call	_itoa

; 317       if (PrfQueryProfileString(hSourceProfile,"COMscope",szFileKey,0,szFileName,18) != 0)
	push	012h
	push	offset FLAT:szFileName
	push	0h
	push	offset FLAT:szFileKey
	push	offset FLAT:@STAT25
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	je	@BLBL45

; 319         if (iIndex == 1)
	cmp	dword ptr [ebp-04h],01h;	iIndex
	jne	@BLBL46

; 320           strcpy(szCOMscopeEXEname,szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,offset FLAT:szCOMscopeEXEname
	call	strcpy
@BLBL46:

; 321         strcpy(&szDestSpec[iDestPathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-0ch];	iDestPathEnd
	add	eax,offset FLAT:szDestSpec
	call	strcpy

; 322         strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-010h];	iSourcePathEnd
	add	eax,offset FLAT:szSourceSpec
	call	strcpy

; 323         pstInst->pfnPrintProgress(szFileName,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	mov	ecx,[ebp+08h];	pstInst
	call	dword ptr [ecx+014h]
	add	esp,08h

; 324         if (!CopyFile(szSourceSpec,szDestSpec))
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	CopyFile
	add	esp,08h
	test	eax,eax
	jne	@BLBL47

; 326           bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 327           if (!DisplayCopyError(szFileName,szDestSpec,rc))
	push	dword ptr [ebp-014h];	rc
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	call	DisplayCopyError
	add	esp,0ch
	test	eax,eax
	je	gtFreePathMem19

; 329           }
@BLBL47:

; 330         itoa(++iFileCount,&szFileNumber[iEnd],10);
	mov	eax,[ebp-024h];	iFileCount
	inc	eax
	mov	[ebp-024h],eax;	iFileCount
	mov	ecx,0ah
	mov	edx,[ebp-02ch];	iEnd
	add	edx,offset FLAT:szFileNumber
	mov	eax,[ebp-024h];	iFileCount
	call	_itoa

; 331         PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileNumber
	push	offset FLAT:@STAT26
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileString
	add	esp,010h

; 332         }
@BLBL45:

; 333       }

; 314     for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	mov	eax,[ebp-04h];	iIndex
	cmp	[ebp-03ch],eax;	ulFileCount
	jae	@BLBL44

; 334     }
@BLBL42:

; 335   if (pstInst->bCopyUtil)
	mov	eax,[ebp+08h];	pstInst
	test	byte ptr [eax+018h],040h
	je	@BLBL50

; 337     strcpy(szDestSpec,pstInst->pszAppsPath);
	mov	edx,[ebp+08h];	pstInst
	mov	edx,[edx+01ch]
	mov	eax,offset FLAT:szDestSpec
	call	strcpy

; 338     iDestPathEnd = strlen(szDestSpec);
	mov	eax,offset FLAT:szDestSpec
	call	strlen
	mov	[ebp-0ch],eax;	iDestPathEnd

; 339     szDestSpec[iDestPathEnd++] = '\\';
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],05ch
	mov	eax,[ebp-0ch];	iDestPathEnd
	inc	eax
	mov	[ebp-0ch],eax;	iDestPathEnd

; 340     szDestSpec[iDestPathEnd] = 0;
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],0h

; 341     strcpy(szFileKey,"File_");
	mov	edx,offset FLAT:@STAT27
	mov	eax,offset FLAT:szFileKey
	call	strcpy

; 342     iCountPos = strlen(szFileKey);
	mov	eax,offset FLAT:szFileKey
	call	strlen
	mov	[ebp-08h],eax;	iCountPos

; 343     ulFileCount = 0;
	mov	dword ptr [ebp-03ch],0h;	ulFileCount

; 344     PrfQueryProfileData(hSourceProfile,"Utilities","Files",&ulFileCount,&cbDataSize);
	lea	eax,[ebp-040h];	cbDataSize
	push	eax
	lea	eax,[ebp-03ch];	ulFileCount
	push	eax
	push	offset FLAT:@STAT29
	push	offset FLAT:@STAT28
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfQueryProfileData
	add	esp,014h

; 345     for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
	mov	dword ptr [ebp-04h],01h;	iIndex
	mov	eax,[ebp-04h];	iIndex
	cmp	[ebp-03ch],eax;	ulFileCount
	jb	@BLBL50
	align 010h
@BLBL52:

; 347       itoa(iIndex,&szFileKey[iCountPos],10);
	mov	ecx,0ah
	mov	edx,[ebp-08h];	iCountPos
	add	edx,offset FLAT:szFileKey
	mov	eax,[ebp-04h];	iIndex
	call	_itoa

; 348       if (PrfQueryProfileString(hSourceProfile,"Utilities",szFileKey,0,szFileName,18) != 0)
	push	012h
	push	offset FLAT:szFileName
	push	0h
	push	offset FLAT:szFileKey
	push	offset FLAT:@STAT2a
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	je	@BLBL53

; 350         strcpy(&szDestSpec[iDestPathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-0ch];	iDestPathEnd
	add	eax,offset FLAT:szDestSpec
	call	strcpy

; 351         strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-010h];	iSourcePathEnd
	add	eax,offset FLAT:szSourceSpec
	call	strcpy

; 352         pstInst->pfnPrintProgress(szFileName,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	mov	ecx,[ebp+08h];	pstInst
	call	dword ptr [ecx+014h]
	add	esp,08h

; 353         if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
	push	01h
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	DosCopy
	add	esp,0ch
	mov	[ebp-014h],eax;	rc
	cmp	dword ptr [ebp-014h],0h;	rc
	je	@BLBL54

; 355           bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 356           if (!DisplayCopyError(szFileName,szDestSpec,rc))
	push	dword ptr [ebp-014h];	rc
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	call	DisplayCopyError
	add	esp,0ch
	test	eax,eax
	je	gtFreePathMem19

; 358           }
@BLBL54:

; 359         ClearReadOnly(szDestSpec);
	push	offset FLAT:szDestSpec
	call	ClearReadOnly
	add	esp,04h

; 360         itoa(++iFileCount,&szFileNumber[iEnd],10);
	mov	eax,[ebp-024h];	iFileCount
	inc	eax
	mov	[ebp-024h],eax;	iFileCount
	mov	ecx,0ah
	mov	edx,[ebp-02ch];	iEnd
	add	edx,offset FLAT:szFileNumber
	mov	eax,[ebp-024h];	iFileCount
	call	_itoa

; 361         PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileNumber
	push	offset FLAT:@STAT2b
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileString
	add	esp,010h

; 362         }
@BLBL53:

; 363       }

; 345     for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	mov	eax,[ebp-04h];	iIndex
	cmp	[ebp-03ch],eax;	ulFileCount
	jae	@BLBL52

; 364     }
@BLBL50:

; 365   if (pstInst->bCopyInstall)
	mov	eax,[ebp+08h];	pstInst
	test	byte ptr [eax+018h],020h
	je	@BLBL57

; 367     bLibrariesRequired = TRUE;
	mov	dword ptr  bLibrariesRequired,01h

; 368     szInstallEXEname[0] = 0;
	mov	byte ptr  szInstallEXEname,0h

; 369     strcpy(szDestSpec,pstInst->pszAppsPath);
	mov	edx,[ebp+08h];	pstInst
	mov	edx,[edx+01ch]
	mov	eax,offset FLAT:szDestSpec
	call	strcpy

; 370     iDestPathEnd = strlen(szDestSpec);
	mov	eax,offset FLAT:szDestSpec
	call	strlen
	mov	[ebp-0ch],eax;	iDestPathEnd

; 371     szDestSpec[iDestPathEnd++] = '\\';
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],05ch
	mov	eax,[ebp-0ch];	iDestPathEnd
	inc	eax
	mov	[ebp-0ch],eax;	iDestPathEnd

; 372     szDestSpec[iDestPathEnd] = 0;
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],0h

; 373     sprintf(&szDestSpec[iDestPathEnd],pstInst->paszStrings[INIFILENAME]);
	mov	edx,[ebp+08h];	pstInst
	mov	edx,[edx+040h]
	mov	eax,[ebp-0ch];	iDestPathEnd
	add	eax,offset FLAT:szDestSpec
	call	_sprintfieee

; 374     strcpy(&szSourceSpec[iSourcePathEnd],pstInst->paszStrings[INIFILENAME]);
	mov	edx,[ebp+08h];	pstInst
	mov	edx,[edx+040h]
	mov	eax,[ebp-010h];	iSourcePathEnd
	add	eax,offset FLAT:szSourceSpec
	call	strcpy

; 375     PrfCloseProfile(hSourceProfile);
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfCloseProfile
	add	esp,04h

; 376     DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING);
	push	01h
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	DosCopy
	add	esp,0ch

; 377     ClearReadOnly(szDestSpec);
	push	offset FLAT:szDestSpec
	call	ClearReadOnly
	add	esp,04h

; 378     hSourceProfile = PrfOpenProfile(pstInst->hab,pstInst->pszSourceIniPath);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+028h]
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+0ch]
	call	PrfOpenProfile
	add	esp,08h
	mov	[ebp-048h],eax;	hSourceProfile

; 379     itoa(++iFileCount,&szFileNumber[iEnd],10);
	mov	eax,[ebp-024h];	iFileCount
	inc	eax
	mov	[ebp-024h],eax;	iFileCount
	mov	ecx,0ah
	mov	edx,[ebp-02ch];	iEnd
	add	edx,offset FLAT:szFileNumber
	mov	eax,[ebp-024h];	iFileCount
	call	_itoa

; 380     PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileNumber
	push	offset FLAT:@STAT2c
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileString
	add	esp,010h

; 381     strcpy(szFileKey,"File_");
	mov	edx,offset FLAT:@STAT2d
	mov	eax,offset FLAT:szFileKey
	call	strcpy

; 382     iCountPos = strlen(szFileKey);
	mov	eax,offset FLAT:szFileKey
	call	strlen
	mov	[ebp-08h],eax;	iCountPos

; 383     ulFileCount = 0;
	mov	dword ptr [ebp-03ch],0h;	ulFileCount

; 384     PrfQueryProfileData(hSourceProfile,"Install","Files",&ulFileCount,&cbDataSize);
	lea	eax,[ebp-040h];	cbDataSize
	push	eax
	lea	eax,[ebp-03ch];	ulFileCount
	push	eax
	push	offset FLAT:@STAT2f
	push	offset FLAT:@STAT2e
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfQueryProfileData
	add	esp,014h

; 385     for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
	mov	dword ptr [ebp-04h],01h;	iIndex
	mov	eax,[ebp-04h];	iIndex
	cmp	[ebp-03ch],eax;	ulFileCount
	jb	@BLBL57
	align 010h
@BLBL59:

; 387       itoa(iIndex,&szFileKey[iCountPos],10);
	mov	ecx,0ah
	mov	edx,[ebp-08h];	iCountPos
	add	edx,offset FLAT:szFileKey
	mov	eax,[ebp-04h];	iIndex
	call	_itoa

; 388       if (PrfQueryProfileString(hSourceProfile,"Install",szFileKey,0,szFileName,18) != 0)
	push	012h
	push	offset FLAT:szFileName
	push	0h
	push	offset FLAT:szFileKey
	push	offset FLAT:@STAT30
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	je	@BLBL60

; 390         if (iIndex == 1)
	cmp	dword ptr [ebp-04h],01h;	iIndex
	jne	@BLBL61

; 391           strcpy(szInstallEXEname,szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,offset FLAT:szInstallEXEname
	call	strcpy
@BLBL61:

; 392         strcpy(&szDestSpec[iDestPathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-0ch];	iDestPathEnd
	add	eax,offset FLAT:szDestSpec
	call	strcpy

; 393         strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-010h];	iSourcePathEnd
	add	eax,offset FLAT:szSourceSpec
	call	strcpy

; 394         pstInst->pfnPrintProgress(szFileName,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	mov	ecx,[ebp+08h];	pstInst
	call	dword ptr [ecx+014h]
	add	esp,08h

; 395         if (!CopyFile(szSourceSpec,szDestSpec))
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	CopyFile
	add	esp,08h
	test	eax,eax
	jne	@BLBL62

; 398           if (!DisplayCopyError(szFileName,szDestSpec,rc))
	push	dword ptr [ebp-014h];	rc
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	call	DisplayCopyError
	add	esp,0ch
	test	eax,eax
	je	gtFreePathMem19

; 400           }
@BLBL62:

; 401         itoa(++iFileCount,&szFileNumber[iEnd],10);
	mov	eax,[ebp-024h];	iFileCount
	inc	eax
	mov	[ebp-024h],eax;	iFileCount
	mov	ecx,0ah
	mov	edx,[ebp-02ch];	iEnd
	add	edx,offset FLAT:szFileNumber
	mov	eax,[ebp-024h];	iFileCount
	call	_itoa

; 402         PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileNumber
	push	offset FLAT:@STAT31
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileString
	add	esp,010h

; 403         }
@BLBL60:

; 404       }

; 385     for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	mov	eax,[ebp-04h];	iIndex
	cmp	[ebp-03ch],eax;	ulFileCount
	jae	@BLBL59

; 405     }
@BLBL57:

; 406   if (bLibrariesRequired && (pstInst->bCopyLibraries) && (pstInst->pszDLLpath != NULL))
	cmp	dword ptr  bLibrariesRequired,0h
	je	@BLBL65
	mov	eax,[ebp+08h];	pstInst
	test	byte ptr [eax+019h],04h
	je	@BLBL65
	mov	eax,[ebp+08h];	pstInst
	cmp	dword ptr [eax+020h],0h
	je	@BLBL65

; 408     if (!bLibsDirCreated)
	cmp	dword ptr  bLibsDirCreated,0h
	jne	@BLBL66

; 409       if (!MakePath(pstInst->hwndFrame,pstInst->pszDLLpath))
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+020h]
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+08h]
	call	MakePath
	add	esp,08h
	test	eax,eax
	jne	@BLBL66

; 410         return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL66:

; 411     bLibsDirCreated = TRUE;
	mov	dword ptr  bLibsDirCreated,01h

; 412     strcpy(szDestSpec,pstInst->pszDLLpath);
	mov	edx,[ebp+08h];	pstInst
	mov	edx,[edx+020h]
	mov	eax,offset FLAT:szDestSpec
	call	strcpy

; 413     iDestPathEnd = strlen(szDestSpec);
	mov	eax,offset FLAT:szDestSpec
	call	strlen
	mov	[ebp-0ch],eax;	iDestPathEnd

; 414     szDestSpec[iDestPathEnd++] = '\\';
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],05ch
	mov	eax,[ebp-0ch];	iDestPathEnd
	inc	eax
	mov	[ebp-0ch],eax;	iDestPathEnd

; 415     szDestSpec[iDestPathEnd] = 0;
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],0h

; 416     strcpy(szFileKey,"File_");
	mov	edx,offset FLAT:@STAT32
	mov	eax,offset FLAT:szFileKey
	call	strcpy

; 417     iCountPos = strlen(szFileKey)
; 417 ;
	mov	eax,offset FLAT:szFileKey
	call	strlen
	mov	[ebp-08h],eax;	iCountPos

; 418     ulFileCount = 0;
	mov	dword ptr [ebp-03ch],0h;	ulFileCount

; 419     PrfQueryProfileData(hSourceProfile,"Libraries","Files",&ulFileCount,&cbDataSize);
	lea	eax,[ebp-040h];	cbDataSize
	push	eax
	lea	eax,[ebp-03ch];	ulFileCount
	push	eax
	push	offset FLAT:@STAT34
	push	offset FLAT:@STAT33
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfQueryProfileData
	add	esp,014h

; 420     for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
	mov	dword ptr [ebp-04h],01h;	iIndex
	mov	eax,[ebp-04h];	iIndex
	cmp	[ebp-03ch],eax;	ulFileCount
	jb	@BLBL68
	align 010h
@BLBL69:

; 422       itoa(iIndex,&szFileKey[iCountPos],10);
	mov	ecx,0ah
	mov	edx,[ebp-08h];	iCountPos
	add	edx,offset FLAT:szFileKey
	mov	eax,[ebp-04h];	iIndex
	call	_itoa

; 423       if (PrfQueryProfileString(hSourceProfile,"Libraries",szFileKey,0,szFileName,18) != 0)
	push	012h
	push	offset FLAT:szFileName
	push	0h
	push	offset FLAT:szFileKey
	push	offset FLAT:@STAT35
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	je	@BLBL74

; 425         strcpy(&szDestSpec[iDestPathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-0ch];	iDestPathEnd
	add	eax,offset FLAT:szDestSpec
	call	strcpy

; 426         strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-010h];	iSourcePathEnd
	add	eax,offset FLAT:szSourceSpec
	call	strcpy

; 427         pstInst->pfnPrintProgress(szFileName,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	mov	ecx,[ebp+08h];	pstInst
	call	dword ptr [ecx+014h]
	add	esp,08h

; 428         if ((rc = DosCopy(szSourceSpec,szDestSpec,0L)) != NO_ERROR)
	push	0h
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	DosCopy
	add	esp,0ch
	mov	[ebp-014h],eax;	rc
	cmp	dword ptr [ebp-014h],0h;	rc
	je	@BLBL71

; 430           switch (CompareFileDate(szSourceSpec,szDestSpec))
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	CompareFileDate
	add	esp,08h
	and	eax,0ffffh
	jmp	@BLBL121
	align 04h
@BLBL122:

; 433               if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
	push	01h
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	DosCopy
	add	esp,0ch
	mov	[ebp-014h],eax;	rc
	cmp	dword ptr [ebp-014h],0h;	rc
	je	@BLBL72

; 435                 bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 436                 if (!DisplayCopyError(szFileName,szDestSpec,rc))
	push	dword ptr [ebp-014h];	rc
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	call	DisplayCopyError
	add	esp,0ch
	test	eax,eax
	je	gtFreePathMem19

; 438                 }
@BLBL72:

; 439               break;
	jmp	@BLBL120
	align 04h
@BLBL123:

; 441               continue;
	jmp	@BLBL74
	align 010h
@BLBL124:

; 443               bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 444               goto gtFreePathMem;
	jmp	gtFreePathMem19
	align 010h
	jmp	@BLBL120
	align 04h
@BLBL121:
	cmp	eax,06h
	je	@BLBL122
	cmp	eax,07h
	je	@BLBL123
	cmp	eax,02h
	je	@BLBL124
@BLBL120:

; 447           }
@BLBL71:

; 448         ClearReadOnly(szDestSpec);
	push	offset FLAT:szDestSpec
	call	ClearReadOnly
	add	esp,04h

; 449         itoa(++iFileCount,&szFileNumber[iEnd],10);
	mov	eax,[ebp-024h];	iFileCount
	inc	eax
	mov	[ebp-024h],eax;	iFileCount
	mov	ecx,0ah
	mov	edx,[ebp-02ch];	iEnd
	add	edx,offset FLAT:szFileNumber
	mov	eax,[ebp-024h];	iFileCount
	call	_itoa

; 450         PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileNumber
	push	offset FLAT:@STAT36
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileString
	add	esp,010h

; 451         }

; 452       }
@BLBL74:

; 420     for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	mov	eax,[ebp-04h];	iIndex
	cmp	[ebp-03ch],eax;	ulFileCount
	jae	@BLBL69
@BLBL68:

; 453     if (!pstInst->bBaseLibrariesCopied)
	mov	eax,[ebp+08h];	pstInst
	test	byte ptr [eax+018h],080h
	jne	@BLBL76

; 455       strcpy(szFileKey,"Base_file_");
	mov	edx,offset FLAT:@STAT37
	mov	eax,offset FLAT:szFileKey
	call	strcpy

; 456       iCountPos = strlen(szFileKey);
	mov	eax,offset FLAT:szFileKey
	call	strlen
	mov	[ebp-08h],eax;	iCountPos

; 457       ulFileCount = 0;
	mov	dword ptr [ebp-03ch],0h;	ulFileCount

; 458       PrfQueryProfileData(hSourceProfile,"Libraries","Base Files",&ulFileCount,&cbDataSize);
	lea	eax,[ebp-040h];	cbDataSize
	push	eax
	lea	eax,[ebp-03ch];	ulFileCount
	push	eax
	push	offset FLAT:@STAT39
	push	offset FLAT:@STAT38
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfQueryProfileData
	add	esp,014h

; 459       for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
	mov	dword ptr [ebp-04h],01h;	iIndex
	mov	eax,[ebp-04h];	iIndex
	cmp	[ebp-03ch],eax;	ulFileCount
	jb	@BLBL77
	align 010h
@BLBL78:

; 461         itoa(iIndex,&szFileKey[iCountPos],10);
	mov	ecx,0ah
	mov	edx,[ebp-08h];	iCountPos
	add	edx,offset FLAT:szFileKey
	mov	eax,[ebp-04h];	iIndex
	call	_itoa

; 462         if (PrfQueryProfileString(hSourceProfile,"Libraries",szFileKey,0,szFileName,18) != 0)
	push	012h
	push	offset FLAT:szFileName
	push	0h
	push	offset FLAT:szFileKey
	push	offset FLAT:@STAT3a
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	je	@BLBL83

; 464           strcpy(&szDestSpec[iDestPathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-0ch];	iDestPathEnd
	add	eax,offset FLAT:szDestSpec
	call	strcpy

; 465           strcpy(&szSourceSpec[iSourcePathEnd],szFileName);
	mov	edx,offset FLAT:szFileName
	mov	eax,[ebp-010h];	iSourcePathEnd
	add	eax,offset FLAT:szSourceSpec
	call	strcpy

; 466           pstInst->pfnPrintProgress(szFileName,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	mov	ecx,[ebp+08h];	pstInst
	call	dword ptr [ecx+014h]
	add	esp,08h

; 467           if ((rc = DosCopy(szSourceSpec,szDestSpec,0L)) != NO_ERROR)
	push	0h
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	DosCopy
	add	esp,0ch
	mov	[ebp-014h],eax;	rc
	cmp	dword ptr [ebp-014h],0h;	rc
	je	@BLBL80

; 469             switch (CompareFileDate(szSourceSpec,szDestSpec))
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	CompareFileDate
	add	esp,08h
	and	eax,0ffffh
	jmp	@BLBL126
	align 04h
@BLBL127:

; 472                 if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
	push	01h
	push	offset FLAT:szDestSpec
	push	offset FLAT:szSourceSpec
	call	DosCopy
	add	esp,0ch
	mov	[ebp-014h],eax;	rc
	cmp	dword ptr [ebp-014h],0h;	rc
	je	@BLBL81

; 474                   bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 475                   if (!DisplayCopyError(szFileName,szDestSpec,rc))
	push	dword ptr [ebp-014h];	rc
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileName
	call	DisplayCopyError
	add	esp,0ch
	test	eax,eax
	je	gtFreePathMem19

; 477                   }
@BLBL81:

; 478                 break;
	jmp	@BLBL125
	align 04h
@BLBL128:

; 480                 continue;
	jmp	@BLBL83
	align 010h
@BLBL129:

; 482                 bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 483                 goto gtFreePathMem;
	jmp	gtFreePathMem19
	align 010h
	jmp	@BLBL125
	align 04h
@BLBL126:
	cmp	eax,06h
	je	@BLBL127
	cmp	eax,07h
	je	@BLBL128
	cmp	eax,02h
	je	@BLBL129
@BLBL125:

; 486             }
@BLBL80:

; 487           ClearReadOnly(szDestSpec);
	push	offset FLAT:szDestSpec
	call	ClearReadOnly
	add	esp,04h

; 488           itoa(++iFileCount,&szFileNumber[iEnd],10);
	mov	eax,[ebp-024h];	iFileCount
	inc	eax
	mov	[ebp-024h],eax;	iFileCount
	mov	ecx,0ah
	mov	edx,[ebp-02ch];	iEnd
	add	edx,offset FLAT:szFileNumber
	mov	eax,[ebp-024h];	iFileCount
	call	_itoa

; 489           PrfWriteProfileString(hInstalledProfile,"Installed",szFileNumber,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szFileNumber
	push	offset FLAT:@STAT3b
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileString
	add	esp,010h

; 490           }

; 491         }
@BLBL83:

; 459       for (iIndex = 1;iIndex <= ulFileCount;iIndex++)
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	mov	eax,[ebp-04h];	iIndex
	cmp	[ebp-03ch],eax;	ulFileCount
	jae	@BLBL78
@BLBL77:

; 492       if (bSuccess)
	cmp	dword ptr [ebp-018h],0h;	bSuccess
	je	@BLBL76

; 493         pstInst->bBaseLibrariesCopied = TRUE;
	mov	eax,[ebp+08h];	pstInst
	or	byte ptr [eax+018h],080h

; 494       }
@BLBL76:

; 495    if (bLibsDirCreated)
	cmp	dword ptr  bLibsDirCreated,0h
	je	@BLBL65

; 497       strcpy(szDestSpec,pstInst->pszAppsPath);
	mov	edx,[ebp+08h];	pstInst
	mov	edx,[edx+01ch]
	mov	eax,offset FLAT:szDestSpec
	call	strcpy

; 498       iDestPathEnd = strlen(szDestSpec);
	mov	eax,offset FLAT:szDestSpec
	call	strlen
	mov	[ebp-0ch],eax;	iDestPathEnd

; 499       szDestSpec[iDestPathEnd++] = '\\';
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],05ch
	mov	eax,[ebp-0ch];	iDestPathEnd
	inc	eax
	mov	[ebp-0ch],eax;	iDestPathEnd

; 500       szDestSpec[iDestPathEnd] = 0;
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec],0h

; 501       sprintf(&szDestSpec[iDestPathEnd],pstInst->paszStrings[INIFILENAME]);
	mov	edx,[ebp+08h];	pstInst
	mov	edx,[edx+040h]
	mov	eax,[ebp-0ch];	iDestPathEnd
	add	eax,offset FLAT:szDestSpec
	call	_sprintfieee

; 502       PrfWriteProfileString(hInstalledProfile,"Installed","Library Path",pstInst->pszDLLpath);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+020h]
	push	offset FLAT:@STAT3d
	push	offset FLAT:@STAT3c
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileString
	add	esp,010h

; 503       }

; 504     }
@BLBL65:

; 505   PrfWriteProfileString(hInstalledProfile,"Installed","Program Path",pstInst->pszAppsPath);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+01ch]
	push	offset FLAT:@STAT3f
	push	offset FLAT:@STAT3e
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileString
	add	esp,010h

; 506   PrfWriteProfileData(hInstalledProfile,"Installed","Files",&iFileCount,sizeof(int));
	push	04h
	lea	eax,[ebp-024h];	iFileCount
	push	eax
	push	offset FLAT:@STAT41
	push	offset FLAT:@STAT40
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileData
	add	esp,014h

; 507   if (pstInst->bBaseLibrariesCopied)
	mov	eax,[ebp+08h];	pstInst
	test	byte ptr [eax+018h],080h
	je	@BLBL87

; 509     if (strlen(pstInst->paszStrings[CONFIGDDLIBRARYSPEC]) != 0)
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+048h]
	call	strlen
	test	eax,eax
	je	@BLBL88

; 511       if (strlen(szPDRpath) != 0)
	mov	eax,offset FLAT:szPDRpath
	call	strlen
	test	eax,eax
	je	@BLBL89

; 512         sprintf(pstInst->paszStrings[CONFIGDDLIBRARYSPEC],"%s\\%s.DLL",szPDRpath,pstInst->paszStrings[CONFIGDDLIBRARYNAME]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+04ch]
	push	offset FLAT:szPDRpath
	mov	edx,offset FLAT:@STAT42
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+048h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h
	jmp	@BLBL90
	align 010h
@BLBL89:

; 514         if (pstInst->pszDLLpath != NULL)
	mov	eax,[ebp+08h];	pstInst
	cmp	dword ptr [eax+020h],0h
	je	@BLBL90

; 515           sprintf(pstInst->paszStrings[CONFIGDDLIBRARYSPEC],"%s\\%s.DLL",pstInst->pszDLLpath,pstInst->paszStrings[CONFIGDDLIBRARYNAME]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+04ch]
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+020h]
	mov	edx,offset FLAT:@STAT43
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+048h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h
@BLBL90:

; 516       PrfWriteProfileString(HINI_USERPROFILE,"COMi","Configuration",pstInst->paszStrings[CONFIGDDLIBRARYSPEC]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+048h]
	push	offset FLAT:@STAT45
	push	offset FLAT:@STAT44
	push	0ffffffffh
	call	PrfWriteProfileString
	add	esp,010h

; 517       }
@BLBL88:

; 518     MenuItemEnable(pstInst->hwndFrame,IDM_SETUP,TRUE);
	push	01h
	push	01389h
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+08h]
	call	MenuItemEnable
	add	esp,0ch

; 519     }
@BLBL87:

; 520   if (strlen(pstInst->paszStrings[CONFIGDDHELPFILENAME]) != 0)
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+050h]
	call	strlen
	test	eax,eax
	je	@BLBL92

; 522     sprintf(szPath,"%s\\%s",pstInst->pszAppsPath,pstInst->paszStrings[CONFIGDDHELPFILENAME]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+050h]
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+01ch]
	mov	edx,offset FLAT:@STAT46
	mov	eax,offset FLAT:szPath
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 523     PrfWriteProfileString(HINI_USERPROFILE,"COMi","Help",szPath);
	push	offset FLAT:szPath
	push	offset FLAT:@STAT48
	push	offset FLAT:@STAT47
	push	0ffffffffh
	call	PrfWriteProfileString
	add	esp,010h

; 524     }
@BLBL92:

; 525   if (pstInst->bCreateObjects)
	mov	eax,[ebp+08h];	pstInst
	test	byte ptr [eax+019h],02h
	je	@BLBL93

; 527     bObjectBad = FALSE;
	mov	dword ptr [ebp-034h],0h;	bObjectBad

; 528     strcpy(szFileNumber,"Object_");
	mov	edx,offset FLAT:@STAT49
	mov	eax,offset FLAT:szFileNumber
	call	strcpy

; 529     iEnd = strlen(szFileNumber);
	mov	eax,offset FLAT:szFileNumber
	call	strlen
	mov	[ebp-02ch],eax;	iEnd

; 530     cbDataSize = sizeof(ULONG);
	mov	dword ptr [ebp-040h],04h;	cbDataSize

; 531     if (!PrfQueryProfileData(hInstalledProfile,"Installed","Objects",&iObjectCount,&cbDataSize))
	lea	eax,[ebp-040h];	cbDataSize
	push	eax
	lea	eax,[ebp-028h];	iObjectCount
	push	eax
	push	offset FLAT:@STAT4b
	push	offset FLAT:@STAT4a
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfQueryProfileData
	add	esp,014h
	test	eax,eax
	jne	@BLBL94

; 532       iObjectCount = 0;
	mov	dword ptr [ebp-028h],0h;	iObjectCount
@BLBL94:

; 533     hObject = WinCreateObject("WPFolder",szFolderName,szFolderSetup,"<WP_DESKTOP>",CO_UPDATEIFEXISTS);
	push	02h
	push	offset FLAT:@STAT4d
	push	offset FLAT:szFolderSetup
	push	offset FLAT:szFolderName
	push	offset FLAT:@STAT4c
	call	WinCreateObject
	add	esp,014h
	mov	[ebp-030h],eax;	hObject

; 534     if (hObject == 0)
	cmp	dword ptr [ebp-030h],0h;	hObject
	jne	@BLBL95

; 536       sprintf(&szFolderName[strlen(szFolderName)],":1");
	mov	eax,offset FLAT:szFolderName
	call	strlen
	mov	edx,offset FLAT:@STAT4e
	add	eax,offset FLAT:szFolderName
	call	_sprintfieee

; 537       hObject = WinCreateObject("WPFolder",szFolderName,szFolderSetup,"<WP_DESKTOP>",CO_UPDATEIFEXISTS);
	push	02h
	push	offset FLAT:@STAT50
	push	offset FLAT:szFolderSetup
	push	offset FLAT:szFolderName
	push	offset FLAT:@STAT4f
	call	WinCreateObject
	add	esp,014h
	mov	[ebp-030h],eax;	hObject

; 538       }
@BLBL95:

; 539     if (hObject != 0)
	cmp	dword ptr [ebp-030h],0h;	hObject
	je	@BLBL93

; 541       PrfWriteProfileData(hInstalledProfile,"Installed","Folder",&hObject,sizeof(HOBJECT));
	push	04h
	lea	eax,[ebp-030h];	hObject
	push	eax
	push	offset FLAT:@STAT52
	push	offset FLAT:@STAT51
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileData
	add	esp,014h

; 542       szDestSpec[iDestPathEnd - 1] = 0;
	mov	eax,[ebp-0ch];	iDestPathEnd
	mov	byte ptr [eax+ szDestSpec-01h],0h

; 543       sprintf(szPath,"<%s>",szFolderName);
	push	offset FLAT:szFolderName
	mov	edx,offset FLAT:@STAT53
	mov	eax,offset FLAT:szPath
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 544       strcpy(szFolderName,szPath);
	mov	edx,offset FLAT:szPath
	mov	eax,offset FLAT:szFolderName
	call	strcpy

; 545       if (szCOMiINFname[0] != 0)
	cmp	byte ptr  szCOMiINFname,0h
	je	@BLBL97

; 547         sprintf(szSetupString,"%sEXENAME=VIEW.EXE;PARAMETERS=%s\\%s",szINFobjectSetup,szDestSpec,pstInst->paszStrings[CONFIGDDNAME]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+038h]
	push	offset FLAT:szDestSpec
	push	offset FLAT:szINFobjectSetup
	mov	edx,offset FLAT:@STAT54
	mov	eax,offset FLAT:szSetupString
	sub	esp,08h
	call	_sprintfieee
	add	esp,014h

; 548         sprintf(szPath,"%s Users Guide",pstInst->paszStrings[CONFIGDDNAME]);
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+038h]
	mov	edx,offset FLAT:@STAT55
	mov	eax,offset FLAT:szPath
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 549         hObject = WinCreateObject("WPProgram",szPath,szSetupString,szFolderID,CO_UPDATEIFEXISTS);
	push	02h
	push	offset FLAT:szFolderID
	push	offset FLAT:szSetupString
	push	offset FLAT:szPath
	push	offset FLAT:@STAT56
	call	WinCreateObject
	add	esp,014h
	mov	[ebp-030h],eax;	hObject

; 550         if (hObject != 0)
	cmp	dword ptr [ebp-030h],0h;	hObject
	je	@BLBL98

; 552           itoa(++iObjectCount,&szFileNumber[iEnd],10);
	mov	eax,[ebp-028h];	iObjectCount
	inc	eax
	mov	[ebp-028h],eax;	iObjectCount
	mov	ecx,0ah
	mov	edx,[ebp-02ch];	iEnd
	add	edx,offset FLAT:szFileNumber
	mov	eax,[ebp-028h];	iObjectCount
	call	_itoa

; 553           PrfWriteProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,sizeof(HOBJECT));
	push	04h
	lea	eax,[ebp-030h];	hObject
	push	eax
	push	offset FLAT:szFileNumber
	push	offset FLAT:@STAT57
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileData
	add	esp,014h

; 554           }
	jmp	@BLBL97
	align 010h
@BLBL98:

; 556           bObjectBad = TRUE;
	mov	dword ptr [ebp-034h],01h;	bObjectBad

; 557         }
@BLBL97:

; 558       if (szCOMscopeEXEname[0] != 0)
	cmp	byte ptr  szCOMscopeEXEname,0h
	je	@BLBL100

; 560         sprintf(szSetupString,"%sEXENAME=%s\\%s;STARTUPDIR=%s;NODROP=YES",szProgramObjectSetup,szDestSpec,szCOMscopeEXEname,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szCOMscopeEXEname
	push	offset FLAT:szDestSpec
	push	offset FLAT:szProgramObjectSetup
	mov	edx,offset FLAT:@STAT58
	mov	eax,offset FLAT:szSetupString
	sub	esp,08h
	call	_sprintfieee
	add	esp,018h

; 561         if (pstInst->bCopyUtil)
	mov	eax,[ebp+08h];	pstInst
	test	byte ptr [eax+018h],040h
	je	@BLBL101

; 562           strcat(szSetupString,";PARAMETERS=/S /T;CCVIEW=YES");
	mov	edx,offset FLAT:@STAT59
	mov	eax,offset FLAT:szSetupString
	call	strcat
@BLBL101:

; 563         hObject = WinCreateObject("WPProgram","COMscope",szSetupString,szFolderID,CO_UPDATEIFEXISTS);
	push	02h
	push	offset FLAT:szFolderID
	push	offset FLAT:szSetupString
	push	offset FLAT:@STAT5b
	push	offset FLAT:@STAT5a
	call	WinCreateObject
	add	esp,014h
	mov	[ebp-030h],eax;	hObject

; 564         if (hObject != 0)
	cmp	dword ptr [ebp-030h],0h;	hObject
	je	@BLBL102

; 566           itoa(++iObjectCount,&szFileNumber[iEnd],10);
	mov	eax,[ebp-028h];	iObjectCount
	inc	eax
	mov	[ebp-028h],eax;	iObjectCount
	mov	ecx,0ah
	mov	edx,[ebp-02ch];	iEnd
	add	edx,offset FLAT:szFileNumber
	mov	eax,[ebp-028h];	iObjectCount
	call	_itoa

; 567           PrfWriteProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,sizeof(HOBJECT));
	push	04h
	lea	eax,[ebp-030h];	hObject
	push	eax
	push	offset FLAT:szFileNumber
	push	offset FLAT:@STAT5c
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileData
	add	esp,014h

; 568           }
	jmp	@BLBL100
	align 010h
@BLBL102:

; 570           bObjectBad = TRUE;
	mov	dword ptr [ebp-034h],01h;	bObjectBad

; 571         }
@BLBL100:

; 572       if (szInstallEXEname[0] != 0)
	cmp	byte ptr  szInstallEXEname,0h
	je	@BLBL104

; 574         sprintf(szSetupString,"%sEXENAME=%s\\%s;STARTUPDIR=%s",szProgramObjectSetup,szDestSpec,szInstallEXEname,szDestSpec);
	push	offset FLAT:szDestSpec
	push	offset FLAT:szInstallEXEname
	push	offset FLAT:szDestSpec
	push	offset FLAT:szProgramObjectSetup
	mov	edx,offset FLAT:@STAT5d
	mov	eax,offset FLAT:szSetupString
	sub	esp,08h
	call	_sprintfieee
	add	esp,018h

; 575         hObject = WinCreateObject("WPProgram","OS/tools Install",szSetupString,szFolderID,CO_UPDATEIFEXISTS);
	push	02h
	push	offset FLAT:szFolderID
	push	offset FLAT:szSetupString
	push	offset FLAT:@STAT5f
	push	offset FLAT:@STAT5e
	call	WinCreateObject
	add	esp,014h
	mov	[ebp-030h],eax;	hObject

; 576         if (hObject != 0)
	cmp	dword ptr [ebp-030h],0h;	hObject
	je	@BLBL105

; 578           itoa(++iObjectCount,&szFileNumber[iEnd],10);
	mov	eax,[ebp-028h];	iObjectCount
	inc	eax
	mov	[ebp-028h],eax;	iObjectCount
	mov	ecx,0ah
	mov	edx,[ebp-02ch];	iEnd
	add	edx,offset FLAT:szFileNumber
	mov	eax,[ebp-028h];	iObjectCount
	call	_itoa

; 579           PrfWriteProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,sizeof(HOBJECT));
	push	04h
	lea	eax,[ebp-030h];	hObject
	push	eax
	push	offset FLAT:szFileNumber
	push	offset FLAT:@STAT60
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileData
	add	esp,014h

; 580           }
	jmp	@BLBL104
	align 010h
@BLBL105:

; 582           bObjectBad = TRUE;
	mov	dword ptr [ebp-034h],01h;	bObjectBad

; 583         }
@BLBL104:

; 584       PrfWriteProfileData(hInstalledProfile,"Installed","Objects",&iObjectCount,sizeof(int));
	push	04h
	lea	eax,[ebp-028h];	iObjectCount
	push	eax
	push	offset FLAT:@STAT62
	push	offset FLAT:@STAT61
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfWriteProfileData
	add	esp,014h

; 585       }

; 586     }
@BLBL93:

; 587   if (bObjectBad || (hObject == 0))
	cmp	dword ptr [ebp-034h],0h;	bObjectBad
	jne	@BLBL107
	cmp	dword ptr [ebp-030h],0h;	hObject
	jne	gtFreePathMem19
@BLBL107:

; 589     sprintf(szMessage,"At least one desktop object was not created due to an unknown system error.");
	mov	edx,offset FLAT:@STAT63
	mov	eax,offset FLAT:szMessage
	call	_sprintfieee

; 590     sprintf(szCaption,"Object(s) Not Created!");
	mov	edx,offset FLAT:@STAT64
	mov	eax,offset FLAT:szCaption
	call	_sprintfieee

; 591     WinMessageBox(HWND_DESKTOP,
	push	04000h
	push	0h
	push	offset FLAT:szCaption
	push	offset FLAT:szMessage
	push	01h
	push	01h
	call	WinMessageBox
	add	esp,018h

; 597     }

; 598 gtFreePathMem:
gtFreePathMem19:

; 599   PrfCloseProfile(hInstalledProfile);
	push	dword ptr [ebp-044h];	hInstalledProfile
	call	PrfCloseProfile
	add	esp,04h

; 600   PrfCloseProfile(hSourceProfile);
	push	dword ptr [ebp-048h];	hSourceProfile
	call	PrfCloseProfile
	add	esp,04h

; 601   if (bSuccess)
	cmp	dword ptr [ebp-018h],0h;	bSuccess
	je	@BLBL109

; 602     pstInst->bFilesCopied = TRUE;
	mov	eax,[ebp+08h];	pstInst
	or	byte ptr [eax+019h],01h
@BLBL109:

; 603   return(bSuccess);
	mov	eax,[ebp-018h];	bSuccess
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
InstallCOMi	endp

; 607   {
	align 010h

	public CopyFile
CopyFile	proc
	push	ebp
	mov	ebp,esp
	sub	esp,01ch
	push	eax
	push	edi
	mov	eax,0aaaaaaaah
	lea	edi,[esp+08h]
	stosd	
	stosd	
	stosd	
	stosd	
	stosd	
	stosd	
	stosd	
	pop	edi
	pop	eax

; 611   if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
	push	01h
	push	dword ptr [ebp+0ch];	szDestSpec
	push	dword ptr [ebp+08h];	szSourceSpec
	call	DosCopy
	add	esp,0ch
	mov	[ebp-01ch],eax;	rc
	cmp	dword ptr [ebp-01ch],0h;	rc
	je	@BLBL130

; 612     {
; 613     if (rc == ERROR_ACCESS_DENIED)
	cmp	dword ptr [ebp-01ch],05h;	rc
	jne	@BLBL131

; 614       {
; 615       if (DosQueryPathInfo(szDestSpec,1,&stFileStatus,sizeof(FILESTATUS3)) == NO_ERROR)
	push	018h
	lea	eax,[ebp-018h];	stFileStatus
	push	eax
	push	01h
	push	dword ptr [ebp+0ch];	szDestSpec
	call	DosQueryPathInfo
	add	esp,010h
	test	eax,eax
	jne	@BLBL132

; 616         {
; 617         if (stFileStatus.attrFile & FILE_HIDDEN)
	test	byte ptr [ebp-04h],02h;	stFileStatus
	je	@BLBL130

; 618           {
; 619           stFileSta
; 619 tus.attrFile &= ~FILE_HIDDEN;
	mov	eax,[ebp-04h];	stFileStatus
	and	al,0fdh
	mov	[ebp-04h],eax;	stFileStatus

; 620           DosSetPathInfo(szDestSpec,1,&stFileStatus,sizeof(FILESTATUS3),0);
	push	0h
	push	018h
	lea	eax,[ebp-018h];	stFileStatus
	push	eax
	push	01h
	push	dword ptr [ebp+0ch];	szDestSpec
	call	DosSetPathInfo
	add	esp,014h

; 621           if ((rc = DosCopy(szSourceSpec,szDestSpec,DCPY_EXISTING)) != NO_ERROR)
	push	01h
	push	dword ptr [ebp+0ch];	szDestSpec
	push	dword ptr [ebp+08h];	szSourceSpec
	call	DosCopy
	add	esp,0ch
	mov	[ebp-01ch],eax;	rc
	cmp	dword ptr [ebp-01ch],0h;	rc
	je	@BLBL130

; 622             return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL132:

; 623           }
; 624         }
; 625       else
; 626         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL131:

; 627       }
; 628     else
; 629       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL130:

; 630     }
; 631   ClearReadOnly(szDestSpec);
	push	dword ptr [ebp+0ch];	szDestSpec
	call	ClearReadOnly
	add	esp,04h

; 632   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
CopyFile	endp

; 636   {
	align 010h

	public ClearReadOnly
ClearReadOnly	proc
	push	ebp
	mov	ebp,esp

; 639   if (DosQueryPathInfo(szFileSpec,1,&stFileStatus,sizeof(FILESTATUS3)) == NO_ERROR)
	push	018h
	push	offset FLAT:stFileStatus
	push	01h
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosQueryPathInfo
	add	esp,010h
	test	eax,eax
	jne	@BLBL137

; 640     if (stFileStatus.attrFile & FILE_READONLY)
	test	byte ptr  stFileStatus+014h,01h
	je	@BLBL137

; 641       {
; 642       stFileStatus.attrFile &= ~FILE_READONLY;
	mov	eax,dword ptr  stFileStatus+014h
	and	al,0feh
	mov	dword ptr  stFileStatus+014h,eax

; 643       DosSetPathInfo(szFileSpec,1,&stFileStatus,sizeof(FILESTATUS3),0);
	push	0h
	push	018h
	push	offset FLAT:stFileStatus
	push	01h
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosSetPathInfo
	add	esp,014h

; 644       }
@BLBL137:

; 645   }
	mov	esp,ebp
	pop	ebp
	ret	
ClearReadOnly	endp

; 648   {
	align 010h

	public MakePath
MakePath	proc
	push	ebp
	mov	ebp,esp
	sub	esp,01c4h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,071h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 653   BOOL bSuccess = TRUE;
	mov	dword ptr [ebp-01c4h],01h;	bSuccess

; 654 
; 655   if ((rc = DosQueryPathInfo(szPath,FIL_STANDARD,&stFileStatus,sizeof(FILESTATUS3))) != NO_ERROR)
	push	018h
	lea	eax,[ebp-01ch];	stFileStatus
	push	eax
	push	01h
	push	dword ptr [ebp+0ch];	szPath
	call	DosQueryPathInfo
	add	esp,010h
	mov	[ebp-04h],eax;	rc
	cmp	dword ptr [ebp-04h],0h;	rc
	je	@BLBL139

; 656     {
; 657     if ((rc == ERROR_PATH_NOT_FOUND) || (rc == ERROR_FILE_NOT_FOUND) )
	cmp	dword ptr [ebp-04h],03h;	rc
	je	@BLBL140
	cmp	dword ptr [ebp-04h],02h;	rc
	jne	@BLBL141
@BLBL140:

; 658       {
; 659       sprintf(szMessage,"Do you want to create the directory %s?",szPath);
	push	dword ptr [ebp+0ch];	szPath
	mov	edx,offset FLAT:@STAT65
	lea	eax,[ebp-0170h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 660       sprintf(szCaption,"Directory does not exist!");
	mov	edx,offset FLAT:@STAT66
	lea	eax,[ebp-01c0h];	szCaption
	call	_sprintfieee

; 661       if (WinMessageBox(HWND_DESKTOP,
	push	04014h
	push	0h
	lea	eax,[ebp-01c0h];	szCaption
	push	eax
	lea	eax,[ebp-0170h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,06h
	jne	@BLBL142

; 662               hwnd,
; 663               szMessage,
; 664               szCaption,
; 665               0,
; 666               MB_MOVEABLE | MB_YESNO | MB_ICONQUESTION) == MBID_YES)
; 667         {
; 668         if (!CreatePath(szPath))
	push	dword ptr [ebp+0ch];	szPath
	call	CreatePath
	add	esp,04h
	test	eax,eax
	jne	@BLBL146

; 669           {
; 670           sprintf(szMessage,"Unable to create the directory %s?",szPath);
	push	dword ptr [ebp+0ch];	szPath
	mov	edx,offset FLAT:@STAT67
	lea	eax,[ebp-0170h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 671           sprintf(szCaption,"Invalid Path Specification!");
	mov	edx,offset FLAT:@STAT68
	lea	eax,[ebp-01c0h];	szCaption
	call	_sprintfieee

; 672           WinMessageBox(HWND_DESKTOP,
	push	04020h
	push	0h
	lea	eax,[ebp-01c0h];	szCaption
	push	eax
	lea	eax,[ebp-0170h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h

; 673                         hwnd,
; 674                         szMessage,
; 675                         szCaption,
; 676                         0,
; 677                         MB_MOVEABLE | MB_OK | MB_ICONEXCLAMATION);
; 678           bSuccess = FALSE;
	mov	dword ptr [ebp-01c4h],0h;	bSuccess

; 679           }

; 680         }
	jmp	@BLBL146
	align 010h
@BLBL142:

; 681       else
; 682         {
; 683         bSuccess = FALSE;
	mov	dword ptr [ebp-01c4h],0h;	bSuccess

; 684         }

; 685       }
	jmp	@BLBL146
	align 010h
@BLBL141:

; 686     else
; 687       {
; 688       sprintf(szMessage,"%s is invalid.",szPath);
	push	dword ptr [ebp+0ch];	szPath
	mov	edx,offset FLAT:@STAT69
	lea	eax,[ebp-0170h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 689       sprintf(szCaption,"Invalid Path Specification!");
	mov	edx,offset FLAT:@STAT6a
	lea	eax,[ebp-01c0h];	szCaption
	call	_sprintfieee

; 690       WinMessageBox(HWND_DESKTOP,
	push	04020h
	push	0h
	lea	eax,[ebp-01c0h];	szCaption
	push	eax
	lea	eax,[ebp-0170h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h

; 691                     hwnd,
; 692                     szMessage,
; 693                     szCaption,
; 694                     0,
; 695                     MB_MOVEABLE | MB_OK | MB_ICONEXCLAMATION);
; 696       bSuccess = FALSE;
	mov	dword ptr [ebp-01c4h],0h;	bSuccess

; 697       }

; 698     }
	jmp	@BLBL146
	align 010h
@BLBL139:

; 699   else
; 700     {
; 701     if ((stFileStatus.attrFile & FILE_DIRECTORY) == 0)
	test	byte ptr [ebp-08h],010h;	stFileStatus
	jne	@BLBL146

; 702       {
; 703       sprintf(szMessage,"%s is a file.  Please select another directory.",szPath);
	push	dword ptr [ebp+0ch];	szPath
	mov	edx,offset FLAT:@STAT6b
	lea	eax,[ebp-0170h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 704       sprintf(szCaption,"Invalid Path Specification!");
	mov	edx,offset FLAT:@STAT6c
	lea	eax,[ebp-01c0h];	szCaption
	call	_sprintfieee

; 705       WinMessageBox(HWND_DESKTOP,
	push	04020h
	push	0h
	lea	eax,[ebp-01c0h];	szCaption
	push	eax
	lea	eax,[ebp-0170h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h

; 706                     hwnd,
; 707                     szMessage,
; 708                     szCaption,
; 709                     0,
; 710                     MB_MOVEABLE | MB_OK | MB_ICONEXCLAMATION);
; 711       bSuccess = FALSE;
	mov	dword ptr [ebp-01c4h],0h;	bSuccess

; 712       }

; 713     }
@BLBL146:

; 714   return(bSuccess);
	mov	eax,[ebp-01c4h];	bSuccess
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
MakePath	endp

; 718   {
	align 010h

	public CreatePath
CreatePath	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax
	sub	esp,04h

; 722   if (DosCreateDir(szPath,0) == NO_ERROR)
	push	0h
	push	dword ptr [ebp+08h];	szPath
	call	DosCreateDir
	add	esp,08h
	test	eax,eax
	jne	@BLBL148

; 723     return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL148:

; 724 
; 725   if ((iLen = strlen(szPath)) == 0)
	mov	eax,[ebp+08h];	szPath
	call	strlen
	mov	[ebp-08h],eax;	iLen
	cmp	dword ptr [ebp-08h],0h;	iLen
	jne	@BLBL149

; 726     return(FALSE);
	xor	eax,eax
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL149:

; 727   for (iIndex = (iLen - 1);iIndex > 0;iIndex--)
	mov	eax,[ebp-08h];	iLen
	dec	eax
	mov	[ebp-04h],eax;	iIndex
	cmp	dword ptr [ebp-04h],0h;	iIndex
	jle	@BLBL150
	align 010h
@BLBL151:

; 728     if (szPath[iIndex] =='\\')
	mov	eax,[ebp+08h];	szPath
	mov	ecx,[ebp-04h];	iIndex
	cmp	byte ptr [eax+ecx],05ch
	jne	@BLBL152

; 729       {
; 730       szPath[iIndex] = 0;
	mov	eax,[ebp+08h];	szPath
	mov	ecx,[ebp-04h];	iIndex
	mov	byte ptr [eax+ecx],0h

; 731       if (CreatePath(szPath))
	push	dword ptr [ebp+08h];	szPath
	call	CreatePath
	add	esp,04h
	test	eax,eax
	je	@BLBL150

; 732         {
; 733         szPath[iIndex] = '\\';
	mov	eax,[ebp+08h];	szPath
	mov	ecx,[ebp-04h];	iIndex
	mov	byte ptr [eax+ecx],05ch

; 734         if (DosCreateDir(szPath,0) == NO_ERROR)
	push	0h
	push	dword ptr [ebp+08h];	szPath
	call	DosCreateDir
	add	esp,08h
	test	eax,eax
	jne	@BLBL150

; 735           return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL152:

; 727   for (iIndex = (iLen - 1);iIndex > 0;iIndex--)
	mov	eax,[ebp-04h];	iIndex
	dec	eax
	mov	[ebp-04h],eax;	iIndex
	cmp	dword ptr [ebp-04h],0h;	iIndex
	jg	@BLBL151
@BLBL150:

; 739   return(FALSE);
	xor	eax,eax
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
CreatePath	endp

; 743   {
	align 010h

	public CompareFileDate
CompareFileDate	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0110h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,044h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 750   DosQueryPathInfo(szSourceFileSpec,1,&stFileInfo,sizeof(FILESTATUS3));
	push	018h
	lea	eax,[ebp-018h];	stFileInfo
	push	eax
	push	01h
	push	dword ptr [ebp+08h];	szSourceFileSpec
	call	DosQueryPathInfo
	add	esp,010h

; 751   fdateSourceLastWrite = stFileInfo.fdateLastWrite;
	lea	edx,[ebp-010h];	stFileInfo
	lea	eax,[ebp-01ah];	fdateSourceLastWrite
	mov	eax,eax
	mov	cx,[edx]
	mov	[eax],cx

; 752   if ((rc = DosQueryPathInfo(szDestFileSpec,1,&stFileInfo,sizeof(FILESTATUS3))) == NO_ERROR)
	push	018h
	lea	eax,[ebp-018h];	stFileInfo
	push	eax
	push	01h
	push	dword ptr [ebp+0ch];	szDestFileSpec
	call	DosQueryPathInfo
	add	esp,010h
	mov	[ebp-0110h],eax;	rc
	cmp	dword ptr [ebp-0110h],0h;	rc
	jne	@BLBL156

; 753     {
; 754     if (fdateSourceLastWrite.year > stFileInfo.fdateLastWrite.year)
	mov	cl,[ebp-0fh];	stFileInfo
	and	ecx,0ffh
	shr	ecx,01h
	mov	al,[ebp-019h];	fdateSourceLastWrite
	and	eax,0ffh
	shr	eax,01h
	cmp	eax,ecx
	jle	@BLBL157

; 755       return(MBID_YES);
	mov	ax,06h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL157:

; 756     else
; 757       if (fdateSourceLastWrite.year == stFileInfo.fdateLastWrite.year)
	mov	cl,[ebp-0fh];	stFileInfo
	and	ecx,0ffh
	shr	ecx,01h
	mov	al,[ebp-019h];	fdateSourceLastWrite
	and	eax,0ffh
	shr	eax,01h
	cmp	eax,ecx
	jne	@BLBL158

; 758         if (fdateSourceLastWrite.month > stFileInfo.fdateLastWrite.month)
	mov	cx,[ebp-010h];	stFileInfo
	and	ecx,01ffh
	shr	ecx,05h
	mov	ax,[ebp-01ah];	fdateSourceLastWrite
	and	eax,01ffh
	shr	eax,05h
	cmp	eax,ecx
	jle	@BLBL160

; 759           return(MBID_YES);
	mov	ax,06h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL160:

; 760         else
; 761           if (fdateSourceLastWrite.month == stFileInfo.fdateLastWrite.month)
	mov	cx,[ebp-010h];	stFileInfo
	and	ecx,01ffh
	shr	ecx,05h
	mov	ax,[ebp-01ah];	fdateSourceLastWrite
	and	eax,01ffh
	shr	eax,05h
	cmp	eax,ecx
	jne	@BLBL158

; 762             if (fdateSourceLastWrite.day >= stFileInfo.fdateLastWrite.day)
	mov	cl,[ebp-010h];	stFileInfo
	and	ecx,01fh
	mov	al,[ebp-01ah];	fdateSourceLastWrite
	and	eax,01fh
	cmp	eax,ecx
	jl	@BLBL158

; 763               return(MBID_YES);
	mov	ax,06h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL158:

; 764     sprintf(szMessage,"%s is the same, or newer, version than the file to be installed.\n\nDo you want to replace it?",szDestFileSpec);
	push	dword ptr [ebp+0ch];	szDestFileSpec
	mov	edx,offset FLAT:@STAT6d
	lea	eax,[ebp-0e2h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 765     sprintf(szCaption,"Newer file exists!");
	mov	edx,offset FLAT:@STAT6e
	lea	eax,[ebp-010ah];	szCaption
	call	_sprintfieee

; 766     return(WinMessageBox(HWND_DESKTOP,HWND_DESKTOP,szMessage,szCaption,
	push	06015h
	push	07725h
	lea	eax,[ebp-010ah];	szCaption
	push	eax
	lea	eax,[ebp-0e2h];	szMessage
	push	eax
	push	01h
	push	01h
	call	WinMessageBox
	add	esp,020h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL156:

; 767                          HLPP_MB_OLD_FILE,
; 768                         (MB_MOVEABLE | MB_HELP | MB_YESNOCANCEL | MB_ICONQUESTION)));
; 769     }
; 770   else
; 771     {
; 772     if (rc == ERROR_SHARING_VIOLATION)
	cmp	dword ptr [ebp-0110h],020h;	rc
	jne	@BLBL164

; 773       {
; 774       sprintf(szMessage,"%s is currently in open by another process.\n\nPlease correct and reinstall.",szDestFileSpec);
	push	dword ptr [ebp+0ch];	szDestFileSpec
	mov	edx,offset FLAT:@STAT6f
	lea	eax,[ebp-0e2h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 775       sprintf(szCaption,"File Currently in Use!");
	mov	edx,offset FLAT:@STAT70
	lea	eax,[ebp-010ah];	szCaption
	call	_sprintfieee

; 776       WinMessageBox(HWND_DESKTOP,
	push	06000h
	push	07726h
	lea	eax,[ebp-010ah];	szCaption
	push	eax
	lea	eax,[ebp-0e2h];	szMessage
	push	eax
	push	01h
	push	01h
	call	WinMessageBox
	add	esp,018h

; 777                     HWND_DESKTOP,
; 778                     szMessage,
; 779                     szCaption,
; 780                     HLPP_MB_FILE_INUSE,
; 781                    (MB_MOVEABLE | MB_OK | MB_HELP));
; 782       return(MBID_CANCEL);
	mov	ax,02h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL164:

; 783       }
; 784     }
; 785   return(MBID_NO);
	mov	ax,07h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
CompareFileDate	endp

; 789   {
	align 010h

	public DisplayCopyError
DisplayCopyError	proc
	push	ebp
	mov	ebp,esp
	sub	esp,01a4h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,069h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 793   switch (rcErrorCode)
	mov	eax,[ebp+010h];	rcErrorCode
	jmp	@BLBL168
	align 04h
@BLBL169:

; 794     {
; 795     case ERROR_FILE_NOT_FOUND:
; 796       strcpy(szCaption,"Source file not Found!");
	mov	edx,offset FLAT:@STAT71
	lea	eax,[ebp-01a4h];	szCaption
	call	strcpy

; 797       break;
	jmp	@BLBL167
	align 04h
@BLBL170:

; 798     case ERROR_PATH_NOT_FOUND:
; 799       strcpy(szCaption,"Source path not Found!");
	mov	edx,offset FLAT:@STAT72
	lea	eax,[ebp-01a4h];	szCaption
	call	strcpy

; 800       break;
	jmp	@BLBL167
	align 04h
@BLBL171:

; 801     case ERROR_ACCESS_DENIED:
; 802       strcpy(szCaption,"Access to Destination file is denied!");
	mov	edx,offset FLAT:@STAT73
	lea	eax,[ebp-01a4h];	szCaption
	call	strcpy

; 803       break;
	jmp	@BLBL167
	align 04h
@BLBL172:

; 804     case ERROR_NOT_DOS_DISK:
; 805       strcpy(szCaption,"Destination is not DOS disk!");
	mov	edx,offset FLAT:@STAT74
	lea	eax,[ebp-01a4h];	szCaption
	call	strcpy

; 806       break;
	jmp	@BLBL167
	align 04h
@BLBL173:

; 807     case ERROR_INVALID_PARAMETER:
; 808       strcpy(szCaption,"Invalid Parameter!");
	mov	edx,offset FLAT:@STAT75
	lea	eax,[ebp-01a4h];	szCaption
	call	strcpy

; 809       break;
	jmp	@BLBL167
	align 04h
@BLBL174:

; 810     case ERROR_DRIVE_LOCKED:
; 811       strcpy(szCaption,"Destination drive is locked!");
	mov	edx,offset FLAT:@STAT76
	lea	eax,[ebp-01a4h];	szCaption
	call	strcpy

; 812       break;
	jmp	@BLBL167
	align 04h
@BLBL175:

; 813     case ERROR_DIRECTORY:
; 814       strcpy(szCaption,"Destination file name is a directory!");
	mov	edx,offset FLAT:@STAT77
	lea	eax,[ebp-01a4h];	szCaption
	call	strcpy

; 815       break;
	jmp	@BLBL167
	align 04h
@BLBL176:

; 816     default:
; 817       strcpy(szCaption,"Unexpected Error!");
	mov	edx,offset FLAT:@STAT78
	lea	eax,[ebp-01a4h];	szCaption
	call	strcpy

; 818       break;
	jmp	@BLBL167
	align 04h
	jmp	@BLBL167
	align 04h
@BLBL168:
	cmp	eax,02h
	je	@BLBL169
	cmp	eax,03h
	je	@BLBL170
	cmp	eax,05h
	je	@BLBL171
	cmp	eax,01ah
	je	@BLBL172
	cmp	eax,057h
	je	@BLBL173
	cmp	eax,06ch
	je	@BLBL174
	cmp	eax,010bh
	je	@BLBL175
	jmp	@BLBL176
	align 04h
@BLBL167:

; 819     }
; 820   sprintf(szMessage,"Unable to copy %s to %s\n\nDo you want to continue file transfer?",szSource,szDest);
	push	dword ptr [ebp+0ch];	szDest
	push	dword ptr [ebp+08h];	szSource
	mov	edx,offset FLAT:@STAT79
	lea	eax,[ebp-0154h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 821   if (WinMessageBox(HWND_DESKTOP,
	push	04111h
	push	0h
	lea	eax,[ebp-01a4h];	szCaption
	push	eax
	lea	eax,[ebp-0154h];	szMessage
	push	eax
	push	01h
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,01h
	je	@BLBL166

; 822                     HWND_DESKTOP,
; 823                     szMessage,
; 824                     szCaption,
; 825                     0L,
; 826                    (MB_MOVEABLE | MB_OKCANCEL | MB_ICONQUESTION | MB_DEFBUTTON2)) != MBID_OK)
; 827     return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL166:

; 828   return(TRUE);
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
DisplayCopyError	endp

; 832   {
	align 010h

	public CleanSystemIni
CleanSystemIni	proc
	push	ebp
	mov	ebp,esp
	sub	esp,070h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,01ch
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 844   pstInst = pstUninstall->pstInst;
	mov	eax,[ebp+0ch];	pstUninstall
	mov	eax,[eax+015h]
	mov	[ebp-070h],eax;	pstInst

; 845   if (PrfQueryProfileString(HINI_USERPROFILE,szApplicationName,"Spooler",NULL,pstUninstall->pszPath,pstInst->ulMaxPathLen))
	mov	eax,[ebp-070h];	pstInst
	push	dword ptr [eax+010h]
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax+04h]
	push	0h
	push	offset FLAT:@STAT7a
	push	dword ptr [ebp+08h];	szApplicationName
	push	0ffffffffh
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	je	@BLBL177

; 846     {
; 847     if (DosLoadModule(0,0,pstUninstall->pszPath,&hMod) == NO_ERROR)
	lea	eax,[ebp-08h];	hMod
	push	eax
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax+04h]
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL178

; 848       {
; 849       if (DosQueryProcAddr(hMod,0,"SPLPDREMOVEPORT",&pfnProcess) == NO_ERROR)
	lea	eax,[ebp-04h];	pfnProcess
	push	eax
	push	offset FLAT:@STAT7b
	push	0h
	push	dword ptr [ebp-08h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL179

; 850         {
; 851         if (PrfQueryProfileSize(HINI_SYSTEMPROFILE,"PM_SPOOLER_PORT",0L,&ulSize))
	lea	eax,[ebp-064h];	ulSize
	push	eax
	push	0h
	push	offset FLAT:@STAT7c
	push	0fffffffeh
	call	PrfQueryProfileSize
	add	esp,010h
	test	eax,eax
	je	@BLBL179

; 852           {
; 853           if ((pKeyNames = malloc(ulSize + 1)) != NULL)
	mov	ecx,0355h
	mov	edx,offset FLAT:@STAT7d
	mov	eax,[ebp-064h];	ulSize
	inc	eax
	call	_debug_malloc
	mov	[ebp-0ch],eax;	pKeyNames
	cmp	dword ptr [ebp-0ch],0h;	pKeyNames
	je	@BLBL179

; 854             {
; 855             pKeyNames[0] = 0;
	mov	eax,[ebp-0ch];	pKeyNames
	mov	byte ptr [eax],0h

; 856             PrfQueryProfileString(HINI_SYSTEMPROFILE,"PM_SPOOLER_PORT",NULL,NULL,pKeyNames,ulSize);
	push	dword ptr [ebp-064h];	ulSize
	push	dword ptr [ebp-0ch];	pKeyNames
	push	0h
	push	0h
	push	offset FLAT:@STAT7e
	push	0fffffffeh
	call	PrfQueryProfileString
	add	esp,018h

; 857             iIndex = 0;
	mov	dword ptr [ebp-068h],0h;	iIndex

; 858             while (pKeyNames[iIndex] != 0)
	mov	eax,[ebp-0ch];	pKeyNames
	mov	ecx,[ebp-068h];	iIndex
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL182
	align 010h
@BLBL183:

; 859               {
; 860               iStartIndex = iIndex;
	mov	eax,[ebp-068h];	iIndex
	mov	[ebp-06ch],eax;	iStartIndex

; 861               while(pKeyNames[iIndex++] != 0);
	mov	eax,[ebp-0ch];	pKeyNames
	mov	ecx,[ebp-068h];	iIndex
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL184
	align 010h
@BLBL185:
	mov	eax,[ebp-068h];	iIndex
	inc	eax
	mov	[ebp-068h],eax;	iIndex
	mov	eax,[ebp-0ch];	pKeyNames
	mov	ecx,[ebp-068h];	iIndex
	cmp	byte ptr [eax+ecx],0h
	jne	@BLBL185
@BLBL184:
	mov	eax,[ebp-068h];	iIndex
	inc	eax
	mov	[ebp-068h],eax;	iIndex

; 862               pKeyName = &pKeyNames[iStartIndex];
	mov	eax,[ebp-0ch];	pKeyNames
	mov	ecx,[ebp-06ch];	iStartIndex
	add	eax,ecx
	mov	[ebp-060h],eax;	pKeyName

; 863               if (strncmp(pKeyName,"COM",3) == 0)
	mov	ecx,03h
	mov	edx,offset FLAT:@STAT7f
	mov	eax,[ebp-060h];	pKeyName
	call	strncmp
	test	eax,eax
	jne	@BLBL191

; 864                 {
; 865                 sprintf(szAppName,"PM_%s",pKeyName);
	push	dword ptr [ebp-060h];	pKeyName
	mov	edx,offset FLAT:@STAT80
	lea	eax,[ebp-034h];	szAppName
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 866                 PrfQueryProfileString(HINI_SYSTEMPROFILE,szAppName,"PORTDRIVER",0L,szDriver,30);
	push	01eh
	lea	eax,[ebp-05ch];	szDriver
	push	eax
	push	0h
	push	offset FLAT:@STAT81
	lea	eax,[ebp-034h];	szAppName
	push	eax
	push	0fffffffeh
	call	PrfQueryProfileString
	add	esp,018h

; 867                 if (strcmp(szDriver,"COMI_SPL;") != 0)
	mov	edx,offset FLAT:@STAT82
	lea	eax,[ebp-05ch];	szDriver
	call	strcmp
	test	eax,eax
	je	@BLBL189

; 868                   if (strcmp(szDriver,"SPL_DEMO;") != 0)
	mov	edx,offset FLAT:@STAT83
	lea	eax,[ebp-05ch];	szDriver
	call	strcmp
	test	eax,eax
	jne	@BLBL191

; 869                     continue;
@BLBL189:

; 870                 pfnProcess(pstInst->hab,pKeyName);
	push	dword ptr [ebp-060h];	pKeyName
	mov	eax,[ebp-070h];	pstInst
	push	dword ptr [eax+0ch]
	call	dword ptr [ebp-04h];	pfnProcess
	add	esp,08h

; 871                 }

; 872               }
@BLBL191:

; 858             while (pKeyNames[iIndex] != 0)
	mov	eax,[ebp-0ch];	pKeyNames
	mov	ecx,[ebp-068h];	iIndex
	cmp	byte ptr [eax+ecx],0h
	jne	@BLBL183
@BLBL182:

; 873             free(pKeyNames);
	mov	ecx,0369h
	mov	edx,offset FLAT:@STAT84
	mov	eax,[ebp-0ch];	pKeyNames
	call	_debug_free

; 874             
; 874 }

; 875           }

; 876         }
@BLBL179:

; 877       DosFreeModule(hMod);
	push	dword ptr [ebp-08h];	hMod
	call	DosFreeModule
	add	esp,04h

; 878       }
@BLBL178:

; 879     PrfWriteProfileString(HINI_USERPROFILE,szApplicationName,"Spooler",NULL);
	push	0h
	push	offset FLAT:@STAT85
	push	dword ptr [ebp+08h];	szApplicationName
	push	0ffffffffh
	call	PrfWriteProfileString
	add	esp,010h

; 880     }
@BLBL177:

; 881   PrfWriteProfileString(HINI_SYSTEMPROFILE,"PM_PORT_DRIVER","COMI_SPL",NULL);
	push	0h
	push	offset FLAT:@STAT87
	push	offset FLAT:@STAT86
	push	0fffffffeh
	call	PrfWriteProfileString
	add	esp,010h

; 882   PrfWriteProfileString(HINI_SYSTEMPROFILE,"PM_PORT_DRIVER","SPL_DEMO",NULL);
	push	0h
	push	offset FLAT:@STAT89
	push	offset FLAT:@STAT88
	push	0fffffffeh
	call	PrfWriteProfileString
	add	esp,010h

; 883   }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
CleanSystemIni	endp

; 886   {
	align 010h

	public Uninstall
Uninstall	proc
	push	ebp
	mov	ebp,esp
	sub	esp,01a4h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,069h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 896   BOOL bDeleteCommandFile = FALSE;
	mov	dword ptr [ebp-015ch],0h;	bDeleteCommandFile

; 897   char *pszDeletePath;
; 898   HFILE hDeleteFile;
; 899   ULONG ulAction;
; 900   ULONG ulBytesWritten;
; 901   APIRET rc;
; 902   HINI hInstalledProfile;
; 903   char szFileNumber[40];
; 904   BOOL bObjectsToDelete;
; 905   INSTALL *pstInst;
; 906 
; 907   pstInst = pstUninstall->pstInst;
	mov	eax,[ebp+0ch];	pstUninstall
	mov	eax,[eax+015h]
	mov	[ebp-01a4h],eax;	pstInst

; 908   if (strlen(pstInst->paszStrings[CURRENTDRIVERSPEC]) != 0)
	mov	eax,[ebp-01a4h];	pstInst
	mov	eax,[eax+044h]
	call	strlen
	test	eax,eax
	je	@BLBL193

; 909     {
; 910     CleanConfigSys(hwnd,pstInst->paszStrings[CURRENTDRIVERSPEC],HLPP_MB_CONFIGSYS_BAD,FALSE);
	push	0h
	push	09ca6h
	mov	eax,[ebp-01a4h];	pstInst
	push	dword ptr [eax+044h]
	push	dword ptr [ebp+08h];	hwnd
	call	CleanConfigSys
	add	esp,010h

; 911     AppendTMP(pstInst->paszStrings[CURRENTDRIVERSPEC]);
	mov	eax,[ebp-01a4h];	pstInst
	push	dword ptr [eax+044h]
	call	AppendTMP
	add	esp,04h

; 912     DosDelete(pstInst->paszStrings[CURRENTDRIVERSPEC]);
	mov	eax,[ebp-01a4h];	pstInst
	push	dword ptr [eax+044h]
	call	DosDelete
	add	esp,04h

; 913     AppendINI(pstInst->paszStrings[CURRENTDRIVERSPEC]);
	mov	eax,[ebp-01a4h];	pstInst
	push	dword ptr [eax+044h]
	call	AppendINI
	add	esp,04h

; 914     }
@BLBL193:

; 915   CleanSystemIni(pstUninstall->pszConfigDDname,pstUninstall);
	push	dword ptr [ebp+0ch];	pstUninstall
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax]
	call	CleanSystemIni
	add	esp,08h

; 916   switch (pstUninstall->fCurrentIni)
	mov	eax,[ebp+0ch];	pstUninstall
	mov	al,[eax+014h]
	and	eax,03h
	jmp	@BLBL231
	align 04h
@BLBL232:
@BLBL233:

; 917     {
; 918     case UNINSTALL_REUSE_INI:
; 919     case UNINSTALL_SAVE_INI:
; 920       sprintf(pstUninstall->pszPath,"%c:\\COMDDINI.OLD",pstInst->chBootDrive);
	mov	ecx,[ebp-01a4h];	pstInst
	xor	eax,eax
	mov	al,[ecx+02h]
	push	eax
	mov	edx,offset FLAT:@STAT8a
	mov	eax,[ebp+0ch];	pstUninstall
	mov	eax,[eax+04h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 921       DosCopy(pstInst->paszStrings[CURRENTDRIVERSPEC],pstUninstall->pszPath,DCPY_EXISTING);
	push	01h
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax+04h]
	mov	eax,[ebp-01a4h];	pstInst
	push	dword ptr [eax+044h]
	call	DosCopy
	add	esp,0ch

; 922       pstInst->bSavedDriverIniFile = TRUE;
	mov	eax,[ebp-01a4h];	pstInst
	or	byte ptr [eax+018h],04h
@BLBL234:

; 923     case UNINSTALL_DEL_INI:
; 924       DosDelete(pstInst->paszStrings[CURRENTDRIVERSPEC]);
	mov	eax,[ebp-01a4h];	pstInst
	push	dword ptr [eax+044h]
	call	DosDelete
	add	esp,04h

; 925       break;
	jmp	@BLBL230
	align 04h
	jmp	@BLBL230
	align 04h
@BLBL231:
	cmp	eax,01h
	je	@BLBL232
	cmp	eax,02h
	je	@BLBL233
	cmp	eax,03h
	je	@BLBL234
@BLBL230:

; 926     }
; 927   if ((hInstalledProfile = PrfOpenProfile(pstInst->hab,pstUninstall->pszUninstallIniPath)) != 0)
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax+010h]
	mov	eax,[ebp-01a4h];	pstInst
	push	dword ptr [eax+0ch]
	call	PrfOpenProfile
	add	esp,08h
	mov	[ebp-0174h],eax;	hInstalledProfile
	cmp	dword ptr [ebp-0174h],0h;	hInstalledProfile
	je	@BLBL194

; 928     {
; 929     iCountPos = sprintf(szFileNumber,"File_");
	mov	edx,offset FLAT:@STAT8b
	lea	eax,[ebp-019ch];	szFileNumber
	call	_sprintfieee
	mov	[ebp-0114h],eax;	iCountPos

; 930     cbDataSize = sizeof(int);
	mov	dword ptr [ebp-010ch],04h;	cbDataSize

; 931     if (PrfQueryProfileData(hInstalledProfile,"Installed","Files",&iFileCount,&cbDataSize))
	lea	eax,[ebp-010ch];	cbDataSize
	push	eax
	lea	eax,[ebp-0110h];	iFileCount
	push	eax
	push	offset FLAT:@STAT8d
	push	offset FLAT:@STAT8c
	push	dword ptr [ebp-0174h];	hInstalledProfile
	call	PrfQueryProfileData
	add	esp,014h
	test	eax,eax
	je	@BLBL195

; 932       {
; 933       for (iIndex = 1;iIndex <= iFileCount;iIndex++)
	mov	dword ptr [ebp-0118h],01h;	iIndex
	mov	eax,[ebp-0110h];	iFileCount
	cmp	[ebp-0118h],eax;	iIndex
	jg	@BLBL195
	align 010h
@BLBL197:

; 934         {
; 935         itoa(iIndex,&szFileNumber[iCountPos],10);
	mov	ecx,0ah
	mov	eax,[ebp-0114h];	iCountPos
	lea	edx,dword ptr [ebp+eax-019ch]
	mov	eax,[ebp-0118h];	iIndex
	call	_itoa

; 936         if (PrfQueryProfileString(hInstalledProfile,"Installed",szFileNumber,0,pstUninstall->pszPath,pstInst->ulMaxPathLen) != 0)
	mov	eax,[ebp-01a4h];	pstInst
	push	dword ptr [eax+010h]
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax+04h]
	push	0h
	lea	eax,[ebp-019ch];	szFileNumber
	push	eax
	push	offset FLAT:@STAT8e
	push	dword ptr [ebp-0174h];	hInstalledProfile
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	je	@BLBL198

; 937           {
; 938           if (strlen(pstUninstall->pszPath) != 0)
	mov	eax,[ebp+0ch];	pstUninstall
	mov	eax,[eax+04h]
	call	strlen
	test	eax,eax
	je	@BLBL198

; 939             {
; 940             if (pstUninstall->pfnPrintProgress != (PFN)NULL)
	mov	eax,[ebp+0ch];	pstUninstall
	cmp	dword ptr [eax+019h],0h
	je	@BLBL200

; 941               pstUninstall->pfnPrintProgress(pstUninstall->pszPath);
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax+04h]
	mov	ecx,[ebp+0ch];	pstUninstall
	call	dword ptr [ecx+019h]
	add	esp,04h
@BLBL200:

; 942             if ((rc = DosForceDelete(pstUninstall->pszPath)) != NO_ERROR)
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax+04h]
	call	DosForceDelete
	add	esp,04h
	mov	[ebp-0170h],eax;	rc
	cmp	dword ptr [ebp-0170h],0h;	rc
	je	@BLBL198

; 943               {
; 944               if ((rc == ERROR_ACCESS_DENIED) || (rc == ERROR_SHARING_VIOLATION))
	cmp	dword ptr [ebp-0170h],05h;	rc
	je	@BLBL202
	cmp	dword ptr [ebp-0170h],020h;	rc
	jne	@BLBL198
@BLBL202:

; 945                 {
; 946                 if (!bDeleteCommandFile)
	cmp	dword ptr [ebp-015ch],0h;	bDeleteCommandFile
	jne	@BLBL204

; 947                   {
; 948                   bDeleteCommandFile = TRUE;
	mov	dword ptr [ebp-015ch],01h;	bDeleteCommandFile

; 949                   pszDeletePath = (PSZ)malloc(pstInst->ulMaxPathLen + 20);
	mov	ecx,03b5h
	mov	edx,offset FLAT:@STAT8f
	mov	eax,[ebp-01a4h];	pstInst
	mov	eax,[eax+010h]
	add	eax,014h
	call	_debug_malloc
	mov	[ebp-0160h],eax;	pszDeletePath

; 950                   if (pszDeletePath == NULL)
	cmp	dword ptr [ebp-0160h],0h;	pszDeletePath
	jne	@BLBL205

; 951                     {
; 952                     strcpy(pstUninstall->pszBannerTwo,"Failed to allocate Delete path memory");
	mov	edx,offset FLAT:@STAT90
	mov	eax,[ebp+0ch];	pstUninstall
	mov	eax,[eax+0ch]
	call	strcpy

; 953                     pstUninstall->pszBannerOne[0] = 0;
	mov	eax,[ebp+0ch];	pstUninstall
	mov	eax,[eax+08h]
	mov	byte ptr [eax],0h

; 954                     return;
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL205:

; 955                     }
; 956                   sprintf(pszDeletePath,"@ECHO OFF\r\nDEL %s > NUL\r\n",pstUninstall->pszPath);
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax+04h]
	mov	edx,offset FLAT:@STAT91
	mov	eax,[ebp-0160h];	pszDeletePath
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 957                   sprintf(szDeleteCmdFile,"%c:\\DEL_COMi.CMD",pstInst->chBootDrive);
	mov	ecx,[ebp-01a4h];	pstInst
	xor	eax,eax
	mov	al,[ecx+02h]
	push	eax
	mov	edx,offset FLAT:@STAT92
	lea	eax,[ebp-0158h];	szDeleteCmdFile
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 958                   if (DosOpen(szDeleteCmdFile,&hDeleteFile,&ulAction,0,0,0x0012,0x0191,0) != NO_ERROR)
	push	0h
	push	0191h
	push	012h
	push	0h
	push	0h
	lea	eax,[ebp-0168h];	ulAction
	push	eax
	lea	eax,[ebp-0164h];	hDeleteFile
	push	eax
	lea	eax,[ebp-0158h];	szDeleteCmdFile
	push	eax
	call	DosOpen
	add	esp,020h
	test	eax,eax
	je	@BLBL206

; 959                     hDeleteFile = 0;
	mov	dword ptr [ebp-0164h],0h;	hDeleteFile
@BLBL206:

; 960                   DosWrite(hDeleteFile,pszDeletePath,strlen(pszDeletePath),&ulBytesWritten);
	mov	eax,[ebp-0160h];	pszDeletePath
	call	strlen
	lea	ecx,[ebp-016ch];	ulBytesWritten
	push	ecx
	push	eax
	push	dword ptr [ebp-0160h];	pszDeletePath
	push	dword ptr [ebp-0164h];	hDeleteFile
	call	DosWrite
	add	esp,010h

; 961                   }
	jmp	@BLBL198
	align 010h
@BLBL204:

; 962                 else
; 963                   if (hDeleteFile != 0)
	cmp	dword ptr [ebp-0164h],0h;	hDeleteFile
	je	@BLBL198

; 964                     {
; 965                     sprintf(pszDeletePath,"DEL %s > NUL\r\n",pstUninstall->pszPath);
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax+04h]
	mov	edx,offset FLAT:@STAT93
	mov	eax,[ebp-0160h];	pszDeletePath
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 966                     DosWrite(hDeleteFile,pszDeletePath,strlen(pszDeletePath),&ulBytesWritten);
	mov	eax,[ebp-0160h];	pszDeletePath
	call	strlen
	lea	ecx,[ebp-016ch];	ulBytesWritten
	push	ecx
	push	eax
	push	dword ptr [ebp-0160h];	pszDeletePath
	push	dword ptr [ebp-0164h];	hDeleteFile
	call	DosWrite
	add	esp,010h

; 967                     }

; 968                 }

; 969               }

; 970             }

; 971           }
@BLBL198:

; 972         }

; 933       for (iIndex = 1;iIndex <= iFileCount;iIndex++)
	mov	eax,[ebp-0118h];	iIndex
	inc	eax
	mov	[ebp-0118h],eax;	iIndex
	mov	eax,[ebp-0110h];	iFileCount
	cmp	[ebp-0118h],eax;	iIndex
	jle	@BLBL197

; 973       }
@BLBL195:

; 974     if (pstUninstall->fObjects != UNINSTALL_NO_OBJ)
	mov	eax,[ebp+0ch];	pstUninstall
	mov	al,[eax+014h]
	and	eax,01fh
	shr	eax,03h
	cmp	eax,02h
	je	@BLBL210

; 976       bObjectsToDelete = TRUE;
	mov	dword ptr [ebp-01a0h],01h;	bObjectsToDelete

; 977       if (pstUninstall->fObjects == UNINSTALL_FOLDERS)
	mov	eax,[ebp+0ch];	pstUninstall
	test	byte ptr [eax+014h],018h
	jne	@BLBL211

; 979         sprintf(szMessage,"Deleting a folder will cause any objects that reside in that folder to be deleted also.\n\nDo you want to delete the folder?");
	mov	edx,offset FLAT:@STAT94
	lea	eax,[ebp-0108h];	szMessage
	call	_sprintfieee

; 980         sprintf(szCaption,"Deleting OS/tools Utilities Folder!");
	mov	edx,offset FLAT:@STAT95
	lea	eax,[ebp-040h];	szCaption
	call	_sprintfieee

; 981         if (WinMessageBox(HWND_DESKTOP,
	push	06004h
	push	07728h
	lea	eax,[ebp-040h];	szCaption
	push	eax
	lea	eax,[ebp-0108h];	szMessage
	push	eax
	push	01h
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,06h
	jne	@BLBL211

; 988           if (PrfQueryProfileData(hInstalledProfile,"Installed","Folder",&hObject,&cbDataSize) != 0)
	lea	eax,[ebp-010ch];	cbDataSize
	push	eax
	lea	eax,[ebp-011ch];	hObject
	push	eax
	push	offset FLAT:@STAT97
	push	offset FLAT:@STAT96
	push	dword ptr [ebp-0174h];	hInstalledProfile
	call	PrfQueryProfileData
	add	esp,014h
	test	eax,eax
	je	@BLBL213

; 990             bObjectsToDelete = FALSE;
	mov	dword ptr [ebp-01a0h],0h;	bObjectsToDelete

; 991             WinDestroyObject(hObject);
	push	dword ptr [ebp-011ch];	hObject
	call	WinDestroyObject
	add	esp,04h

; 992             }
	jmp	@BLBL211
	align 010h
@BLBL213:

; 995             if (PrfQueryProfileData(hInstalledProfile,"Installed","Object_1",&hObject,&cbDataSize) != 0)
	lea	eax,[ebp-010ch];	cbDataSize
	push	eax
	lea	eax,[ebp-011ch];	hObject
	push	eax
	push	offset FLAT:@STAT99
	push	offset FLAT:@STAT98
	push	dword ptr [ebp-0174h];	hInstalledProfile
	call	PrfQueryProfileData
	add	esp,014h
	test	eax,eax
	je	@BLBL211

; 997               bObjectsToDelete = FALSE;
	mov	dword ptr [ebp-01a0h],0h;	bObjectsToDelete

; 998               WinDestroyObject(hObject);
	push	dword ptr [ebp-011ch];	hObject
	call	WinDestroyObject
	add	esp,04h

; 999               }

; 1000             }

; 1001           }

; 1002         }
@BLBL211:

; 1003       if (bObjectsToDelete)
	cmp	dword ptr [ebp-01a0h],0h;	bObjectsToDelete
	je	@BLBL210

; 1005         iCountPos = sprintf(szFileNumber,"Object_");
	mov	edx,offset FLAT:@STAT9a
	lea	eax,[ebp-019ch];	szFileNumber
	call	_sprintfieee
	mov	[ebp-0114h],eax;	iCountPos

; 1006         cbDataSize = sizeof(HOBJECT);
	mov	dword ptr [ebp-010ch],04h;	cbDataSize

; 1007         if (PrfQueryProfileData(hInstalledProfile,"Installed","Objects",&iFileCount,&cbDataSize))
	lea	eax,[ebp-010ch];	cbDataSize
	push	eax
	lea	eax,[ebp-0110h];	iFileCount
	push	eax
	push	offset FLAT:@STAT9c
	push	offset FLAT:@STAT9b
	push	dword ptr [ebp-0174h];	hInstalledProfile
	call	PrfQueryProfileData
	add	esp,014h
	test	eax,eax
	je	@BLBL210

; 1009           for (iIndex = iFileCount;iIndex > 0;iIndex--)
	mov	eax,[ebp-0110h];	iFileCount
	mov	[ebp-0118h],eax;	iIndex
	cmp	dword ptr [ebp-0118h],0h;	iIndex
	jle	@BLBL210
	align 010h
@BLBL219:

; 1011             itoa(iIndex,&szFileNumber[iCountPos],10);
	mov	ecx,0ah
	mov	eax,[ebp-0114h];	iCountPos
	lea	edx,dword ptr [ebp+eax-019ch]
	mov	eax,[ebp-0118h];	iIndex
	call	_itoa

; 1012             if (PrfQueryProfileData(hInstalledProfile,"Installed",szFileNumber,&hObject,&cbDataSize) != 0)
	lea	eax,[ebp-010ch];	cbDataSize
	push	eax
	lea	eax,[ebp-011ch];	hObject
	push	eax
	lea	eax,[ebp-019ch];	szFileNumber
	push	eax
	push	offset FLAT:@STAT9d
	push	dword ptr [ebp-0174h];	hInstalledProfile
	call	PrfQueryProfileData
	add	esp,014h
	test	eax,eax
	je	@BLBL220

; 1013               WinDestroyObject(hObject);
	push	dword ptr [ebp-011ch];	hObject
	call	WinDestroyObject
	add	esp,04h
@BLBL220:

; 1014             }

; 1009           for (iIndex = iFileCount;iIndex > 0;iIndex--)
	mov	eax,[ebp-0118h];	iIndex
	dec	eax
	mov	[ebp-0118h],eax;	iIndex
	cmp	dword ptr [ebp-0118h],0h;	iIndex
	jg	@BLBL219

; 1015           }

; 1016         }

; 1017       }
@BLBL210:

; 1018     if (pstUninstall->bDirs)
	mov	eax,[ebp+0ch];	pstUninstall
	test	byte ptr [eax+014h],04h
	je	@BLBL222

; 1020       if (PrfQueryProfileString(hInstalledProfile,"Installed","Library Path",0,pstUninstall->pszPath,pstInst->ulMaxPathLen) != 0)
	mov	eax,[ebp-01a4h];	pstInst
	push	dword ptr [eax+010h]
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax+04h]
	push	0h
	push	offset FLAT:@STAT9f
	push	offset FLAT:@STAT9e
	push	dword ptr [ebp-0174h];	hInstalledProfile
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	je	@BLBL223

; 1021         DosDeleteDir(pstUninstall->pszPath);
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax+04h]
	call	DosDeleteDir
	add	esp,04h
@BLBL223:

; 1022       if (PrfQueryProfileString(hInstalledProfile,"Installed","Program Path",0,pstUninstall->pszPath,pstInst->ulMaxPathLen) != 0)
	mov	eax,[ebp-01a4h];	pstInst
	push	dword ptr [eax+010h]
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax+04h]
	push	0h
	push	offset FLAT:@STATa1
	push	offset FLAT:@STATa0
	push	dword ptr [ebp-0174h];	hInstalledProfile
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	je	@BLBL224

; 1024         PrfCloseProfile(hInstalledProfile);
	push	dword ptr [ebp-0174h];	hInstalledProfile
	call	PrfCloseProfile
	add	esp,04h

; 1025         DosForceDelete(pstUninstall->pszUninstallIniPath);
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax+010h]
	call	DosForceDelete
	add	esp,04h

; 1026         DosDeleteDir(pstUninstall->pszPath);
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax+04h]
	call	DosDeleteDir
	add	esp,04h

; 1027         }
	jmp	@BLBL226
	align 010h
@BLBL224:

; 1029         PrfCloseProfile(hInstalledProfile);
	push	dword ptr [ebp-0174h];	hInstalledProfile
	call	PrfCloseProfile
	add	esp,04h

; 1030       }
	jmp	@BLBL226
	align 010h
@BLBL222:

; 1032       PrfCloseProfile(hInstalledProfile);
	push	dword ptr [ebp-0174h];	hInstalledProfile
	call	PrfCloseProfile
	add	esp,04h
@BLBL226:

; 1033     if (pstUninstall->pfnPrintProgress != (PFN)NULL)
	mov	eax,[ebp+0ch];	pstUninstall
	cmp	dword ptr [eax+019h],0h
	je	@BLBL194

; 1034       pstUninstall->pfnPrintProgress(pstUninstall->pszUninstallIniPath);
	mov	eax,[ebp+0ch];	pstUninstall
	push	dword ptr [eax+010h]
	mov	ecx,[ebp+0ch];	pstUninstall
	call	dword ptr [ecx+019h]
	add	esp,04h

; 1035     }
@BLBL194:

; 1036   PrfWriteProfileString(HINI_USERPROFILE,"COMscope",0,0);
	push	0h
	push	0h
	push	offset FLAT:@STATa2
	push	0ffffffffh
	call	PrfWriteProfileString
	add	esp,010h

; 1037   PrfWriteProfileString(HINI_USERPROFILE,"COMi",0,0);
	push	0h
	push	0h
	push	offset FLAT:@STATa3
	push	0ffffffffh
	call	PrfWriteProfileString
	add	esp,010h

; 1038   MenuItemEnable(pstInst->hwndFrame,IDM_UNINSTALL,FALSE);
	push	0h
	push	01397h
	mov	eax,[ebp-01a4h];	pstInst
	push	dword ptr [eax+08h]
	call	MenuItemEnable
	add	esp,0ch

; 1039   MenuItemEnable(pstInst->hwndFrame,IDM_SETUP,FALSE);
	push	0h
	push	01389h
	mov	eax,[ebp-01a4h];	pstInst
	push	dword ptr [eax+08h]
	call	MenuItemEnable
	add	esp,0ch

; 1040   MenuItemEnable(pstInst->hwndFrame,IDM_TRANSFER,FALSE);
	push	0h
	push	0138dh
	mov	eax,[ebp-01a4h];	pstInst
	push	dword ptr [eax+08h]
	call	MenuItemEnable
	add	esp,0ch

; 1041   if (bDeleteCommandFile)
	cmp	dword ptr [ebp-015ch],0h;	bDeleteCommandFile
	je	@BLBL228

; 1043     sprintf(szMessage,"One or more files were not deleted because they were being accessed by this or some other process.");
	mov	edx,offset FLAT:@STATa4
	lea	eax,[ebp-0108h];	szMessage
	call	_sprintfieee

; 1044     sprintf(szCaption,"Access Denied!");
	mov	edx,offset FLAT:@STATa5
	lea	eax,[ebp-040h];	szCaption
	call	_sprintfieee

; 1045     WinMessageBox(HWND_DESKTOP,
	push	06000h
	push	07727h
	lea	eax,[ebp-040h];	szCaption
	push	eax
	lea	eax,[ebp-0108h];	szMessage
	push	eax
	push	01h
	push	01h
	call	WinMessageBox
	add	esp,018h

; 1051     sprintf(pszDeletePath,"DEL %c:\\DELLOCK.CMD > NUL\r\n",pstInst->chBootDrive);
	mov	ecx,[ebp-01a4h];	pstInst
	xor	eax,eax
	mov	al,[ecx+02h]
	push	eax
	mov	edx,offset FLAT:@STATa6
	mov	eax,[ebp-0160h];	pszDeletePath
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1052     DosWrite(hDeleteFile,pszDeletePath,strlen(pszDeletePath),&ulBytesWritten);
	mov	eax,[ebp-0160h];	pszDeletePath
	call	strlen
	lea	ecx,[ebp-016ch];	ulBytesWritten
	push	ecx
	push	eax
	push	dword ptr [ebp-0160h];	pszDeletePath
	push	dword ptr [ebp-0164h];	hDeleteFile
	call	DosWrite
	add	esp,010h

; 1053     DosClose(hDeleteFile);
	push	dword ptr [ebp-0164h];	hDeleteFile
	call	DosClose
	add	esp,04h

; 1054     free(pszDeletePath);
	mov	ecx,041eh
	mov	edx,offset FLAT:@STATa7
	mov	eax,[ebp-0160h];	pszDeletePath
	call	_debug_free

; 1055     strcpy(pstUninstall->pszBannerTwo,"Uninstall Incomplete");
	mov	edx,offset FLAT:@STATa8
	mov	eax,[ebp+0ch];	pstUninstall
	mov	eax,[eax+0ch]
	call	strcpy

; 1056     }
	jmp	@BLBL229
	align 010h
@BLBL228:

; 1058     strcpy(pstUninstall->pszBannerTwo,"Uninstall Complete");
	mov	edx,offset FLAT:@STATa9
	mov	eax,[ebp+0ch];	pstUninstall
	mov	eax,[eax+0ch]
	call	strcpy
@BLBL229:

; 1059   pstUninstall->pszBannerOne[0] = 0;
	mov	eax,[ebp+0ch];	pstUninstall
	mov	eax,[eax+08h]
	mov	byte ptr [eax],0h

; 1060   }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
Uninstall	endp
CODE32	ends
end
