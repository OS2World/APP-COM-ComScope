	title	p:\COMscope\comscope.c
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
	public	bDebuggingCOMscope
	public	szCOMscopeProfile
	public	szCOMscopeVersion
	public	szCOMscopeAppName
	public	szHelpFileName
	public	bIsTheFirst
	public	hCom
	public	pstComListHead
	public	szCOMscopePipeName
	public	bRemoteClient
	public	bRemoteServer
	public	bRemoteAccess
	public	szNetRun
	public	szNetRunParameters
	public	bFirstPosition
	public	bSkipInitPos
	public	wASCIIfont
	public	wHEXfont
	public	bCommandLineDataFile
	public	bExternalKill
	public	szIPCpipeName
	public	bCaptureFileWritten
	public	bFrameActivated
	public	bIsInstall
	public	bSendNextKeystroke
	public	ulMonitorSleepCount
	public	ulCalcSleepCount
	public	bMaximized
	public	bMinimized
	public	bStatusSized
	public	szTitle
	public	szEXEtitle
	public	szFontFileName
	public	bDataToView
	public	bNewFontFile
	public	bNoPaint
	public	bSearchProfileApps
	public	bUseProfile
	public	hProfileInstance
	public	bStopRemotePipe
	public	chPipeDebug
	public	iDebugLevel
	public	bIPCpipeOpen
	public	bLaunchShutdownServer
	public	bShowServerProcess
	public	bEditCmdLineIniFile
	public	bStopIPCserverThread
	extrn	DosClose:proc
	extrn	DosLoadModule:proc
	extrn	DosQueryProcAddr:proc
	extrn	DosFreeModule:proc
	extrn	DosExitList:proc
	extrn	SaveWindowPositions:proc
	extrn	WinGetLastError:proc
	extrn	_sprintfieee:proc
	extrn	MessageBox:proc
	extrn	ErrorNotify:proc
	extrn	_exeentry:proc
	extrn	strcpy:proc
	extrn	strlen:proc
	extrn	WinInitialize:proc
	extrn	WinCreateMsgQueue:proc
	extrn	WinRegisterClass:proc
	extrn	InitializeData:proc
	extrn	fnwpReadColumnClient:proc
	extrn	fnwpWriteColumnClient:proc
	extrn	DosOpen:proc
	extrn	DosCreateMutexSem:proc
	extrn	DosSleep:proc
	extrn	WinPostMsg:proc
	extrn	IPCserverThread:proc
	extrn	DosCreateThread:proc
	extrn	RemoteServerThread:proc
	extrn	WinSetWindowText:proc
	extrn	WinCreateStdWindow:proc
	extrn	exit:proc
	extrn	WinSubclassWindow:proc
	extrn	WinSetFocus:proc
	extrn	WinGetMsg:proc
	extrn	WinDispatchMsg:proc
	extrn	DestroyHelpInstance:proc
	extrn	WinDestroyWindow:proc
	extrn	WinDestroyMsgQueue:proc
	extrn	WinTerminate:proc
	extrn	DosCloseMutexSem:proc
	extrn	DosCloseEventSem:proc
	extrn	DosFreeMem:proc
	extrn	DosCreateEventSem:proc
	extrn	WinSendMsg:proc
	extrn	WinQueryWindow:proc
	extrn	WinSetWindowPos:proc
	extrn	WinCreateWindow:proc
	extrn	fnwpDeviceAllStatusDlg:proc
	extrn	WinLoadDlg:proc
	extrn	fnwpRcvBufferStatusDlg:proc
	extrn	fnwpXmitBufferStatusDlg:proc
	extrn	fnwpModemInStatusDlg:proc
	extrn	fnwpModemOutStatusDlg:proc
	extrn	fnwpDeviceStatusDlg:proc
	extrn	WinQuerySysValue:proc
	extrn	WinQueryWindowPos:proc
	extrn	WinQueryHelpInstance:proc
	extrn	DisplayHelpPanel:proc
	extrn	WinMessageBox:proc
	extrn	WinCommand:proc
	extrn	ClearRowScrollBar:proc
	extrn	RowScroll:proc
	extrn	WinQueryPointerPos:proc
	extrn	DisplayCharacterInfo:proc
	extrn	WinLoadMenu:proc
	extrn	PopupMenuItemCheck:proc
	extrn	WinPopupMenu:proc
	extrn	ProcessKeystroke:proc
	extrn	WinDefWindowProc:proc
	extrn	CreateColumnWindows:proc
	extrn	MenuItemEnable:proc
	extrn	DosStartSession:proc
	extrn	InitializeSystem:proc
	extrn	DosResumeThread:proc
	extrn	MenuItemCheck:proc
	extrn	KillDisplayThread:proc
	extrn	WriteCaptureFile:proc
	extrn	KillMonitorThread:proc
	extrn	DosDelete:proc
	extrn	IncrementFileExt:proc
	extrn	WinInvalidateRect:proc
	extrn	GpiDestroyPS:proc
	extrn	DosCallNPipe:proc
	extrn	DosRequestMutexSem:proc
	extrn	DosReleaseMutexSem:proc
	extrn	WinBeginPaint:proc
	extrn	WinIsWindowShowing:proc
	extrn	WinFillRect:proc
	extrn	GpiCreateLogFont:proc
	extrn	GpiSetCharSet:proc
	extrn	GpiSetBackMix:proc
	extrn	GpiSetBackColor:proc
	extrn	GpiSetColor:proc
	extrn	GpiCharStringAt:proc
	extrn	WinEndPaint:proc
	extrn	DosSearchPath:proc
	extrn	WinOpenWindowDC:proc
	extrn	WinGetPS:proc
	extrn	GpiQueryFontFileDescriptions:proc
	extrn	GpiLoadFonts:proc
	extrn	GpiQueryFonts:proc
	extrn	WinReleasePS:proc
	extrn	SetupRowScrolling:proc
	extrn	memset:proc
	extrn	fnwpSetColorDlg:proc
	extrn	WinDlgBox:proc
	extrn	WinQueryWindowRect:proc
	extrn	WinStartTimer:proc
	extrn	GetCountsSinceLast:proc
	extrn	WinStopTimer:proc
	extrn	atoi:proc
	extrn	_fullDump:dword
	extrn	hwndHelpInstance:dword
	extrn	swSearchString:byte
	extrn	lSearchStrLen:dword
	extrn	stRead:byte
	extrn	stWrite:byte
	extrn	pwScrollBuffer:dword
	extrn	stColTrack:byte
	extrn	lScrollCount:dword
	extrn	_ctype:dword
	extrn	lWriteIndex:dword
DATA32	segment
@STAT1	db "PROFDEB",0h
@STAT2	db "SaveProfileString",0h
	align 04h
@STAT3	db "Capture File",0h
	align 04h
@STAT4	db "CloseProfile",0h
	align 04h
@STAT5	db "Error Severity = %X, Cod"
db "e = %d - 0x%04X, %s",0h
@STAT6	db "COMSCOPE",0h
	align 04h
@STAT7	db "READ COLUMN",0h
@STAT8	db "WRITE COLUMN",0h
	align 04h
@STAT9	db "\\%s\PIPE\%s",0h
	align 04h
@STATa	db "\PIPE\%s",0h
	align 04h
@STATb	db "Open IPC Server is not u"
db "p yet - rc = %u",0h
@STATc	db "DosCreateMutexSem error:"
db " IPC Pipe - return code "
db "= %ld",0h
	align 04h
@STATd	db "\\%s\PIPE\%s",0h
	align 04h
@STATe	db "\PIPE\%s",0h
	align 04h
@STATf	db "PROFDEB",0h
@STAT10	db "Load monitor ~configurat"
db "ion",0h
@STAT11	db "InitializeProfile",0h
	align 04h
@STAT12	db "GetProfileString",0h
	align 04h
@STAT13	db "SaveProfileString",0h
	align 04h
@STAT14	db "Data File",0h
	align 04h
@STAT15	db "Data File",0h
	align 04h
@STAT16	db "Capture File",0h
	align 04h
@STAT17	db "CAPTURE",0h
@STAT18	db "GetProfileData",0h
	align 04h
@STAT19	db "Search String",0h
	align 04h
@STAT1a	db "SUBFRAME",0h
	align 04h
@STAT1b	db "STATUS",0h
	align 04h
@STAT1c	db "COMSCOPE",0h
	align 04h
@STAT1d	db "Bad hwndFrame",0h
	align 04h
@STAT1e	db "Initialization file %s e"
db "ntered on command line",0h
	align 04h
@STAT1f	db "CFG_DEB",0h
@STAT20	db "InstallDevice",0h
	align 04h
@STAT21	db "Unable to load configura"
db "tion library - %s",0h
	align 04h
@STAT22	db "CFG_DEB",0h
@STAT23	db "DosCreateEventSem error:"
db " return code = %ld",0h
	align 04h
@STAT24	db "DosCreateEventSem error:"
db " return code = %ld",0h
	align 04h
@STAT25	db "DosCreateEventSem error:"
db " return code = %ld",0h
	align 04h
@STAT26	db "DosCreateEventSem error:"
db " return code = %ld",0h
	align 04h
@STAT27	db "DosCreateMutexSem error:"
db " RowGio - return code = "
db "%ld",0h
@STAT28	db "DosCreateMutexSem error:"
db " ColGio - return code = "
db "%ld",0h
@STAT29	db "DosCreateMutexSem error:"
db " SigGio - return code = "
db "%ld",0h
@STAT2a	db "STATUS",0h
	align 04h
@STAT2b	db "COMscope Status",0h
@STAT2c	db "Invalid Session ID, star"
db "ting remote server",0h
	align 04h
@STAT2d	db "Error starting remote se"
db "rver - Process not paren"
db "t",0h
	align 04h
@STAT2e	db "Retry Sub-Allocation, st"
db "arting remote server",0h
	align 04h
@STAT2f	db "Unkown Error = %u - star"
db "ting remote server",0h
	align 04h
@STAT30	db "CFG_DEB",0h
@STAT31	db "Unable to load configura"
db "tion library - %s",0h
	align 04h
@STAT32	db "CFG_DEB",0h
@STAT33	db "End of capture buffer",0ah,"%-"
db "ld characters stored",0ah,"Mon"
db "itoring Aborted",0h
@STAT34	db "PROFDEB",0h
@STAT35	db "SaveProfileData",0h
@STAT36	db "Search String",0h
	align 04h
@STAT37	db "SaveProfileString",0h
	align 04h
@STAT38	db "Capture File",0h
	align 04h
@STAT39	db "CloseProfile",0h
	align 04h
@STAT3a	db "Pipe busy, sending proce"
db "ss end message.",0h
@STAT3b	db "DosRequestMutexSem error"
db " in RowPaint: return cod"
db "e = %ld",0h
@STAT3c	db "HEXFONTS",0h
	align 04h
@STAT3d	db "DosReleaseMutexSem error"
db " in RowPaint: return cod"
db "e = %ld",0h
@STAT3e	db "DPATH",0h
	align 04h
@STAT3f	db "Make sure ",022h,"%s",022h," is in the"
db " default directory or in"
db " a directory listed in t"
db "he ",022h,"DPATH",022h," environment v"
db "ariable.",0h
	align 04h
@STAT40	db "Unable to locate font fi"
db "le!",0h
@STAT41	db 022h,"%s",022h," is not valid Font F"
db "ile.",0ah,0ah," Code = (0-%X)",0h
	align 04h
@STAT42	db "Bad Font File!",0h
	align 04h
@STAT43	db 022h,"%s",022h," is not valid Font F"
db "ile.",0ah,0ah," Code = (1-%X)",0h
	align 04h
@STAT44	db "Bad Font File!",0h
	align 04h
@STAT45	db 022h,"%s",022h," is not valid Font F"
db "ile.",0ah,0ah," Code = (2-%X)",0h
	align 04h
@STAT46	db "Bad Font File!",0h
	align 04h
@STAT47	db 022h,"%s",022h," is not valid Font F"
db "ile.",0ah,0ah," Code = (3-%X)",0h
	align 04h
@STAT48	db "Bad Font File!",0h
	align 04h
@STAT49	db "DosRequestMutexSem error"
db " in WndSize: return code"
db " = %ld",0h
	align 04h
@STAT4a	db "DosReleaseMutexSem error"
db " in WndSize: return code"
db " = %ld",0h
	align 04h
@STAT4b	db "Tx(0, 0)   Rx(0, 0)",0h
@STAT4c	db "Tx(0 CPS)   Rx(0 CPS)",0h
	align 04h
@STAT4d	db "Tx(0)   Rx(0)",0h
	align 04h
@STAT4e	db "Status Line Display Colo"
db "rs",0h
	align 04h
@STAT4f	db "Transmit",0h
	align 04h
@STAT50	db "Receive  ",0h
	align 04h
@STAT51	db "Capturing Stream ",0h
	align 04h
@STAT52	db "Viewing %s",0h
	align 04h
@STAT53	db "Viewing Captured Data",0h
	align 04h
@STAT54	db "Tx(%u, %u)",0h
	align 04h
@STAT55	db "Tx(%u CPS)",0h
	align 04h
@STAT56	db "Tx(%u)",0h
	align 04h
@STAT57	db "Rx(%u, %u)",0h
	align 04h
@STAT58	db "Rx(%u CPS)",0h
	align 04h
@STAT59	db " %s",0h
@STAT5a	db "Rx(%u)",0h
	align 04h
@STAT5b	db " %s",0h
szCOMscopeProfile	db "COMscope",0h
szCOMscopeVersion	db "Version 3.90",0h
szCOMscopeAppName	db "COMscope",0h
	db 020h DUP (00H)
szHelpFileName	db "COMscope.hlp",0h
	db 0f8h DUP (00H)
hCom	dd 0ffffffffh
szCOMscopePipeName	db "COMscope",0h
	db 047h DUP (00H)
szNetRun	db "net.exe",0h
szNetRunParameters	db "run csbeta /X /l1 /p",022h,"CSB"
db "ETA 1",022h,0h
	align 04h
bFirstPosition	dd 01h
wASCIIfont	dw 01h
szIPCpipeName	db "COMscope",0h
	db 047h DUP (00H)
	align 04h
ulMonitorSleepCount	dd 0c8h
ulCalcSleepCount	dd 0c8h
szTitle	db "COMscope",0h
	db 047h DUP (00H)
szEXEtitle	db "COMscope",0h
szFontFileName	db "HEXFONTS.FON",0h
	db 07h DUP (00H)
	align 04h
bUseProfile	dd 01h
	dd	_exeentry
DATA32	ends
BSS32	segment
bDebuggingCOMscope	dd 0h
bIsTheFirst	dd 0h
pstComListHead	dd 0h
bRemoteClient	dd 0h
bRemoteServer	dd 0h
bRemoteAccess	dd 0h
bSkipInitPos	dd 0h
wHEXfont	dw 0h
	align 04h
bCommandLineDataFile	dd 0h
bExternalKill	dd 0h
bCaptureFileWritten	dd 0h
bFrameActivated	dd 0h
bIsInstall	dd 0h
bSendNextKeystroke	dd 0h
bMaximized	dd 0h
bMinimized	dd 0h
bStatusSized	dd 0h
bDataToView	dd 0h
bNewFontFile	dd 0h
bNoPaint	dd 0h
bSearchProfileApps	dd 0h
hProfileInstance	dd 0h
bStopRemotePipe	dd 0h
chPipeDebug	db 0h
	align 04h
iDebugLevel	dd 0h
bIPCpipeOpen	dd 0h
bLaunchShutdownServer	dd 0h
bShowServerProcess	dd 0h
bEditCmdLineIniFile	dd 0h
bStopIPCserverThread	dd 0h
@1babLastWasOverflow	dd 0h
@247idTimer	dd 0h
@252ulRxByteCount	dd 0h
@253ulTxByteCount	dd 0h
	align 04h
comm	pfnInstallDevice:dword
	align 04h
comm	pfnDialog:dword
	align 04h
comm	pfnManageProfile:dword
	align 04h
comm	pfnGetProfileData:dword
	align 04h
comm	pfnSaveProfileData:dword
	align 04h
comm	pfnGetProfileString:dword
	align 04h
comm	pfnSaveProfileString:dword
	align 04h
comm	pfnInitializeProfile:dword
	align 04h
comm	pfnCloseProfile:dword
	align 04h
comm	pfnFillDeviceNameList:dword
	align 04h
comm	lMouseButtonCount:dword
comm	stCOMiCFG:byte:04dh
comm	stComCtl:byte:044h
comm	stIOctl:byte:0ch
	align 04h
comm	FrameProcess:dword
	align 04h
comm	ReadFrameProcess:dword
	align 04h
comm	WriteFrameProcess:dword
	align 04h
comm	habAnchorBlock:dword
	align 04h
comm	hwndFrame:dword
	align 04h
comm	hwndClient:dword
	align 04h
comm	hwndDlg:dword
	align 04h
comm	ulFileSize:dword
	align 04h
comm	rc:dword
comm	szCOMscopeIniPath:byte:0105h
	align 04h
comm	ulCOMscopeBufferSize:dword
	align 04h
comm	bCOMscopeEnabled:dword
comm	pszFileContents:byte
comm	stCFG:byte:0e3h
	align 04h
comm	lYScr:dword
	align 04h
comm	lYfullScr:dword
	align 04h
comm	lcyBrdr:dword
	align 04h
comm	lXScr:dword
	align 04h
comm	lXfullScr:dword
	align 04h
comm	lcxVSc:dword
	align 04h
comm	lcxBrdr:dword
	align 04h
comm	lcyMenu:dword
	align 04h
comm	lcyTitleBar:dword
comm	szCOMscopePipe:byte:064h
comm	stPipeMsg:byte:0100ah
comm	stPipeCmd:byte:0ah
comm	stRemote:byte:03ch
	align 04h
comm	hIPCpipe:dword
comm	szIPCpipe:byte:064h
	align 04h
comm	tidIPCserverThread:dword
comm	szDataFileSpec:byte:0105h
comm	szCaptureFileSpec:byte:0105h
comm	szEntryDataFileSpec:byte:0105h
comm	szEntryCaptureFileSpec:byte:0105h
comm	stCharCount:byte:010h
comm	szCaptureFileName:byte:0105h
	align 04h
comm	lLeadWriteIndex:dword
	align 04h
comm	lLeadReadIndex:dword
comm	swpLastPosition:byte:024h
	align 04h
comm	hmtxSigGioBlockedSem:dword
	align 04h
comm	hmtxColGioBlockedSem:dword
	align 04h
comm	hmtxRowGioBlockedSem:dword
	align 04h
comm	hevWaitCOMiDataSem:dword
	align 04h
comm	hevWaitQueueStartSem:dword
	align 04h
comm	hevDisplayWaitDataSem:dword
	align 04h
comm	hevKillMonitorThreadSem:dword
	align 04h
comm	hevKillDisplayThreadSem:dword
comm	szErrorMessage:byte:0c8h
comm	szFontFilePath:byte:0105h
comm	stCell:dword
	align 04h
comm	hdcPs:dword
	align 04h
comm	hpsPs:dword
	align 04h
comm	tidMonitorThread:dword
	align 04h
comm	tidDisplayThread:dword
	align 04h
comm	pwCaptureBuffer:dword
comm	stRow:byte:07fh
	align 04h
comm	lStatusHeight:dword
	align 04h
comm	lFontsAvailable:dword
comm	astFontMetrics:byte:0390h
comm	astFontNames:byte:0100h
comm	astFontAttributes:byte:0e0h
	align 04h
comm	bStopMonitorThread:dword
	align 04h
comm	bStopDisplayThread:dword
comm	szPortName:byte:0ah
	align 04h
comm	lLastHeight:dword
	align 04h
comm	lLastWidth:dword
	align 04h
comm	lMinimumHeight:dword
	align 04h
comm	lMinimumWidth:dword
	align 04h
comm	hwndStatus:dword
	align 04h
comm	hwndStatAll:dword
	align 04h
comm	hwndStatDev:dword
	align 04h
comm	hwndStatModemIn:dword
	align 04h
comm	hwndStatModemOut:dword
	align 04h
comm	hwndStatRcvBuf:dword
	align 04h
comm	hwndStatXmitBuf:dword
	align 04h
comm	frameproc:dword
	align 02h
comm	usLastClientPopupItem:word
comm	stProfile:byte:01f6h
	align 04h
comm	tidRemoteServerThread:dword
	align 04h
comm	hevCOMscopeSem:dword
	align 04h
comm	hCOMscopePipe:dword
	align 04h
comm	hmtxIPCpipeBlockedSem:dword
comm	stIPCpipe:byte:0ah
comm	szPipeServerName:byte:028h
	align 04h
comm	ulBytesRead:dword
	align 04h
comm	ulIPCpipeInstance:dword
comm	stSD:byte:03ch
	align 04h
comm	pidCSqueueOwner:dword
	align 04h
comm	ulSessionID:dword
	align 04h
comm	pidSession:dword
comm	szServerProgram:byte:0104h
comm	szCmdLineIniFileSpec:byte:0104h
@11aulMenuStyle	dd 0h
@1adstPos	db 08h DUP (0h)
@1b7wLastDirection	dw 0h
@244szLastErrorMessage	db 0c8h DUP (0h)
@245usLastPopupItem	dw 0h
@24aszLastCounts	db 050h DUP (0h)
@24blMessageDelay	dd 0h
@24cbLastCount	dd 0h
@24dulMenuStyle	dw 0h
	align 04h
@24ebDiagCountsCapable	dd 0h
@24faulRxByteCount	db 0194h DUP (0h)
@250aulTxByteCount	db 0194h DUP (0h)
@251iWindow	dd 0h
@254iCPSdivisor	dd 0h
@255iCPSmultiplier	dd 0h
BSS32	ends
CODE32	segment

; 311   {
	align 010h

	public ExitRoutine
ExitRoutine	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 315   if (hCom != 0)
	cmp	dword ptr  hCom,0h
	je	@BLBL1

; 316     DosClose(hCom);
	push	dword ptr  hCom
	call	DosClose
	add	esp,04h
@BLBL1:

; 317 //  MessageBox(HWND_DESKTOP,"Exit Routine entered");
; 318   if (hProfileInstance != NULL)
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL2

; 319     {
; 320     if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-04h];	hMod
	push	eax
	push	offset FLAT:@STAT1
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL2

; 321       {
; 322       if (stCFG.bCaptureToFile && (szCaptureFileName[0] != 0))
	test	byte ptr  stCFG+016h,020h
	je	@BLBL4
	cmp	byte ptr  szCaptureFileName,0h
	je	@BLBL4

; 323         if (DosQueryProcAddr(hMod,0,"SaveProfileString",(PFN *)&pfnSaveProfileString) == NO_ERROR)
	push	offset FLAT:pfnSaveProfileString
	push	offset FLAT:@STAT2
	push	0h
	push	dword ptr [ebp-04h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL4

; 324           pfnSaveProfileString(hProfileInstance,"Capture File",szCaptureFileName);
	push	offset FLAT:szCaptureFileName
	push	offset FLAT:@STAT3
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnSaveProfileString
	add	esp,0ch
@BLBL4:

; 325       hProfileInstance->pstProfile->bAutoSaveProfile = TRUE;
	mov	eax,dword ptr  hProfileInstance
	mov	eax,[eax+02h]
	or	byte ptr [eax+01ddh],04h

; 326       if (DosQueryProcAddr(hMod,0,"CloseProfile",(PFN *)&pfnCloseProfile) == NO_ERROR)
	push	offset FLAT:pfnCloseProfile
	push	offset FLAT:@STAT4
	push	0h
	push	dword ptr [ebp-04h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL6

; 327         hProfileInstance = pfnCloseProfile(hProfileInstance);
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnCloseProfile
	add	esp,04h
	mov	dword ptr  hProfileInstance,eax
@BLBL6:

; 328       DosFreeModule(hMod);
	push	dword ptr [ebp-04h];	hMod
	call	DosFreeModule
	add	esp,04h

; 329       }

; 330     }
@BLBL2:

; 331   DosExitList(EXLST_EXIT,ExitRoutine);
	push	offset FLAT: ExitRoutine
	push	03h
	call	DosExitList
	add	esp,08h

; 332   }
	mov	esp,ebp
	pop	ebp
	ret	
ExitRoutine	endp

; 335   {
	align 010h

	public pfnUpdateProfileOptions
pfnUpdateProfileOptions	proc
	push	ebp
	mov	ebp,esp

; 336   switch (iAction)
	mov	eax,[ebp+08h];	iAction
	jmp	@BLBL8
	align 04h
@BLBL9:

; 337     {
; 338     case PROFACTION_ENTER_SAVE:
; 339       stCFG.bLoadWindowPosition = stProfile.bLoadWindowPosition;
	mov	cl,byte ptr  stProfile+01ddh
	and	ecx,01h
	mov	al,byte ptr  stCFG+017h
	and	al,0bfh
	sal	ecx,06h
	and	cl,07fh
	or	al,cl
	mov	byte ptr  stCFG+017h,al

; 340       stCFG.bLoadMonitor = stProfile.bLoadProcess;
	mov	cl,byte ptr  stProfile+01ddh
	and	ecx,03h
	shr	ecx,01h
	mov	al,byte ptr  stCFG+017h
	and	al,07fh
	sal	ecx,07h
	or	al,cl
	mov	byte ptr  stCFG+017h,al

; 341       stCFG.bAutoSaveConfig = stProfile.bAutoSaveProfile;
	mov	cl,byte ptr  stProfile+01ddh
	and	ecx,07h
	shr	ecx,02h
	mov	al,byte ptr  stCFG+018h
	and	al,0feh
	and	cl,01h
	or	al,cl
	mov	byte ptr  stCFG+018h,al

; 342       SaveWindowPositions();
	call	SaveWindowPositions

; 343       break;
	jmp	@BLBL7
	align 04h
@BLBL10:
@BLBL11:

; 344     case PROFACTION_ENTER_MANAGE:
; 345     case PROFACTION_PROFILE_LOADED:
; 346       stProfile.bLoadWindowPosition = stCFG.bLoadWindowPosition;
	mov	cl,byte ptr  stCFG+017h
	and	ecx,07fh
	shr	ecx,06h
	mov	al,byte ptr  stProfile+01ddh
	and	al,0feh
	and	cl,01h
	or	al,cl
	mov	byte ptr  stProfile+01ddh,al

; 347       stProfile.bLoadProcess = stCFG.bLoadMonitor;
	mov	cl,byte ptr  stCFG+017h
	and	ecx,0ffh
	shr	ecx,07h
	mov	al,byte ptr  stProfile+01ddh
	and	al,0fdh
	sal	ecx,01h
	and	cl,03h
	or	al,cl
	mov	byte ptr  stProfile+01ddh,al

; 348       stProfile.bAutoSaveProfile = stCFG.bAutoSaveConfig;
	mov	cl,byte ptr  stCFG+018h
	and	ecx,01h
	mov	al,byte ptr  stProfile+01ddh
	and	al,0fbh
	sal	ecx,02h
	and	cl,07h
	or	al,cl
	mov	byte ptr  stProfile+01ddh,al

; 349       break;
	jmp	@BLBL7
	align 04h
@BLBL12:
@BLBL13:
@BLBL14:
@BLBL15:

; 350     case PROFACTION_EXIT_SAVE:
; 351     case PROFACTION_ENTER_LOAD:
; 352     case PROFACTION_EXIT_LOAD:
; 353     case PROFACTION_EXIT_MANAGE:
; 354       break;
	jmp	@BLBL7
	align 04h
	jmp	@BLBL7
	align 04h
@BLBL8:
	test	eax,eax
	je	@BLBL9
	cmp	eax,07h
	je	@BLBL10
	cmp	eax,03h
	je	@BLBL11
	cmp	eax,01h
	je	@BLBL12
	cmp	eax,02h
	je	@BLBL13
	cmp	eax,04h
	je	@BLBL14
	cmp	eax,06h
	je	@BLBL15
@BLBL7:

; 355     }
; 356   }
	mov	esp,ebp
	pop	ebp
	ret	
pfnUpdateProfileOptions	endp

; 361   {
	align 010h

	public DisplayLastWindowError
DisplayLastWindowError	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0cch
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,033h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 367     eidErrorCode = WinGetLastError(habAnchorBlock);
	push	dword ptr  habAnchorBlock
	call	WinGetLastError
	add	esp,04h
	mov	[ebp-0cch],eax;	eidErrorCode

; 368     if (eidErrorCode != 0)
	cmp	dword ptr [ebp-0cch],0h;	eidErrorCode
	je	@BLBL16

; 369       {
; 370       sprintf(szError,"Error Severity = %X, Code = %d - 0x%04X, %s",ERRORIDSEV(eidErrorCode),
	push	dword ptr [ebp+08h];	szMessage
	mov	ax,[ebp-0cch];	eidErrorCode
	and	eax,0ffffh
	push	eax
	mov	ax,[ebp-0cch];	eidErrorCode
	and	eax,0ffffh
	push	eax
	mov	eax,[ebp-0cch];	eidErrorCode
	shr	eax,010h
	and	eax,0ffffh
	and	eax,0ffffh
	push	eax
	mov	edx,offset FLAT:@STAT5
	lea	eax,[ebp-0c8h];	szError
	sub	esp,08h
	call	_sprintfieee
	add	esp,018h

; 371                                                                     ERRORIDERROR(eidErrorCode),
; 372                                                                     ERRORIDERROR(eidErrorCode),
; 373                                                                     szMessage);
; 374       MessageBox(hwndFrame,szError);
	lea	eax,[ebp-0c8h];	szError
	push	eax
	push	dword ptr  hwndFrame
	call	MessageBox
	add	esp,08h

; 375       ErrorNotify(szError);
	lea	eax,[ebp-0c8h];	szError
	push	eax
	call	ErrorNotify
	add	esp,04h

; 376       }
@BLBL16:

; 377     }

; 378   }
	mov	esp,ebp
	pop	ebp
	ret	
DisplayLastWindowError	endp

; 382   {
	align 010h

	public main
main	proc
	push	ebp
	mov	ebp,esp
	sub	esp,084h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,021h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 391   if (argc >= 2)
	cmp	dword ptr [ebp+08h],02h;	argc
	jl	@BLBL17

; 392     ParseParms(argc, argv);
	push	dword ptr [ebp+0ch];	argv
	push	dword ptr [ebp+08h];	argc
	call	ParseParms
	add	esp,08h
@BLBL17:

; 393     
; 394   strcpy(szCOMscopeIniPath,argv[0]);
	mov	edx,[ebp+0ch];	argv
	mov	edx,[edx]
	mov	eax,offset FLAT:szCOMscopeIniPath
	call	strcpy

; 395   for (lIndex = strlen(szCOMscopeIniPath);lIndex > 0;lIndex--)
	mov	eax,offset FLAT:szCOMscopeIniPath
	call	strlen
	mov	[ebp-07ch],eax;	lIndex
	cmp	dword ptr [ebp-07ch],0h;	lIndex
	jle	@BLBL18
	align 010h
@BLBL19:

; 396     {
; 397     if (argv[0][lIndex] ==  '\\')
	mov	eax,[ebp+0ch];	argv
	mov	eax,[eax]
	mov	ecx,[ebp-07ch];	lIndex
	cmp	byte ptr [eax+ecx],05ch
	je	@BLBL18

; 398       break;
; 399     }

; 395   for (lIndex = strlen(szCOMscopeIniPath);lIndex > 0;lIndex--)
	mov	eax,[ebp-07ch];	lIndex
	dec	eax
	mov	[ebp-07ch],eax;	lIndex
	cmp	dword ptr [ebp-07ch],0h;	lIndex
	jg	@BLBL19
@BLBL18:

; 400   lIndex++;
	mov	eax,[ebp-07ch];	lIndex
	inc	eax
	mov	[ebp-07ch],eax;	lIndex

; 401   szCOMscopeIniPath[lIndex] = 0;
	mov	eax,[ebp-07ch];	lIndex
	mov	byte ptr [eax+ szCOMscopeIniPath],0h

; 403   habAnchorBlock = WinInitialize((USHORT)NULL);
	push	0h
	call	WinInitialize
	add	esp,04h
	mov	dword ptr  habAnchorBlock,eax

; 404   hmqQueue   = WinCreateMsgQueue(habAnchorBlock,0);
	push	0h
	push	dword ptr  habAnchorBlock
	call	WinCreateMsgQueue
	add	esp,08h
	mov	[ebp-04h],eax;	hmqQueue

; 406   WinRegisterClass(habAnchorBlock,
	push	04h
	push	04h
	push	offset FLAT: fnwpClient
	push	offset FLAT:@STAT6
	push	dword ptr  habAnchorBlock
	call	WinRegisterClass
	add	esp,014h

; 412   DosExitList(EXLST_ADD,ExitRoutine);
	push	offset FLAT: ExitRoutine
	push	01h
	call	DosExitList
	add	esp,08h

; 413   InitializeData();
	call	InitializeData

; 415   WinRegisterClass(habAnchorBlock,
	push	04h
	push	0h
	push	offset FLAT: fnwpReadColumnClient
	push	offset FLAT:@STAT7
	push	dword ptr  habAnchorBlock
	call	WinRegisterClass
	add	esp,014h

; 421   WinRegisterClass(habAnchorBlock,
	push	04h
	push	0h
	push	offset FLAT: fnwpWriteColumnClient
	push	offset FLAT:@STAT8
	push	dword ptr  habAnchorBlock
	call	WinRegisterClass
	add	esp,014h

; 427   if (bLaunchShutdownServer && !bRemoteAccess)
	cmp	dword ptr  bLaunchShutdownServer,0h
	je	@BLBL22
	cmp	dword ptr  bRemoteAccess,0h
	jne	@BLBL22

; 429     if (strlen(szPipeServerName) != 0)
	mov	eax,offset FLAT:szPipeServerName
	call	strlen
	test	eax,eax
	je	@BLBL23

; 430       sprintf(szIPCpipe,"\\\\%s\\PIPE\\%s",szPipeServerName,szIPCpipeName);
	push	offset FLAT:szIPCpipeName
	push	offset FLAT:szPipeServerName
	mov	edx,offset FLAT:@STAT9
	mov	eax,offset FLAT:szIPCpipe
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h
	jmp	@BLBL24
	align 010h
@BLBL23:

; 432       sprintf(szIPCpipe,"\\PIPE\\%s",szIPCpipeName);
	push	offset FLAT:szIPCpipeName
	mov	edx,offset FLAT:@STATa
	mov	eax,offset FLAT:szIPCpipe
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
@BLBL24:

; 433     rc = DosOpen(szIPCpipe,&hIPCpipe,&ulAction,0L,0L,1L,0x42,0L);
	push	0h
	push	042h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-080h];	ulAction
	push	eax
	push	offset FLAT:hIPCpipe
	push	offset FLAT:szIPCpipe
	call	DosOpen
	add	esp,020h
	mov	dword ptr  rc,eax

; 434     if (rc == NO_ERROR)
	cmp	dword ptr  rc,0h
	jne	@BLBL25

; 435       bIPCpipeOpen = TRUE;
	mov	dword ptr  bIPCpipeOpen,01h
	jmp	@BLBL26
	align 010h
@BLBL25:

; 437       if (rc != ERROR_PIPE_BUSY)
	cmp	dword ptr  rc,0e7h
	je	@BLBL26

; 439         bIsTheFirst = TRUE;
	mov	dword ptr  bIsTheFirst,01h

; 440         if (chPipeDebug > '0')
	mov	al,byte ptr  chPipeDebug
	cmp	al,030h
	jbe	@BLBL26

; 442           sprintf(szMessage,"Open IPC Server is not up yet - rc = %u",rc);
	push	dword ptr  rc
	mov	edx,offset FLAT:@STATb
	lea	eax,[ebp-074h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 443           ErrorNotify(szMessage);
	lea	eax,[ebp-074h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 444           }

; 445         }
@BLBL26:

; 446     bStopIPCserverThread = FALSE;
	mov	dword ptr  bStopIPCserverThread,0h

; 447     if ((rc = DosCreateMutexSem(0L,&hmtxIPCpipeBlockedSem,0L,FALSE)) != NO_ERROR)
	push	0h
	push	0h
	push	offset FLAT:hmtxIPCpipeBlockedSem
	push	0h
	call	DosCreateMutexSem
	add	esp,010h
	mov	dword ptr  rc,eax
	cmp	dword ptr  rc,0h
	je	@BLBL29

; 449       sprintf(szMessage,"DosCreateMutexSem error: IPC Pipe - return code = %ld", rc);
	push	dword ptr  rc
	mov	edx,offset FLAT:@STATc
	lea	eax,[ebp-074h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 450       ErrorNotify(szMessage);
	lea	eax,[ebp-074h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 451       DosSleep(5000);
	push	01388h
	call	DosSleep
	add	esp,04h

; 452       WinPostMsg(hwndClient,WM_QUIT,0L,0L);
	push	0h
	push	0h
	push	02ah
	push	dword ptr  hwndClient
	call	WinPostMsg
	add	esp,010h

; 453       }
@BLBL29:

; 454     DosCreateThread(&tidIPCserverThread,(PFNTHREAD)IPCserverThread,0L,TRUE,4096);
	push	01000h
	push	01h
	push	0h
	push	offset FLAT: IPCserverThread
	push	offset FLAT:tidIPCserverThread
	call	DosCreateThread
	add	esp,014h

; 455     }
@BLBL22:

; 457   if (bRemoteAccess)
	cmp	dword ptr  bRemoteAccess,0h
	je	@BLBL30

; 459     bLaunchShutdownServer = FALSE;
	mov	dword ptr  bLaunchShutdownServer,0h

; 460     if (strlen(szPipeServerName) != 0)
	mov	eax,offset FLAT:szPipeServerName
	call	strlen
	test	eax,eax
	je	@BLBL31

; 461       sprintf(szCOMscopePipe,"\\\\%s\\PIPE\\%s",szPipeServerName,szCOMscopePipeName);
	push	offset FLAT:szCOMscopePipeName
	push	offset FLAT:szPipeServerName
	mov	edx,offset FLAT:@STATd
	mov	eax,offset FLAT:szCOMscopePipe
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h
	jmp	@BLBL32
	align 010h
@BLBL31:

; 463       sprintf(szCOMscopePipe,"\\PIPE\\%s",szCOMscopePipeName);
	push	offset FLAT:szCOMscopePipeName
	mov	edx,offset FLAT:@STATe
	mov	eax,offset FLAT:szCOMscopePipe
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
@BLBL32:

; 465     if (bRemoteServer)
	cmp	dword ptr  bRemoteServer,0h
	je	@BLBL30

; 466       DosCreateThread(&tidRemoteServerThread,(PFNTHREAD)RemoteServerThread,0L,0,4096);
	push	01000h
	push	0h
	push	0h
	push	offset FLAT: RemoteServerThread
	push	offset FLAT:tidRemoteServerThread
	call	DosCreateThread
	add	esp,014h

; 467     }
@BLBL30:

; 469   if (bUseProfile && !bRemoteServer)
	cmp	dword ptr  bUseProfile,0h
	je	@BLBL34
	cmp	dword ptr  bRemoteServer,0h
	jne	@BLBL34

; 471     if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-084h];	hMod
	push	eax
	push	offset FLAT:@STATf
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL48

; 473       stProfile.hab = habAnchorBlock;
	mov	eax,dword ptr  habAnchorBlock
	mov	dword ptr  stProfile,eax

; 474       stProfile.phwndHelpInstance = &hwndHelpInstance;
	mov	dword ptr  stProfile+056h,offset FLAT:hwndHelpInstance

; 475       stProfile.ulHelpPanel = HLPP_PROFILE_DLG;
	mov	dword ptr  stProfile+05ah,09c41h

; 476       strcpy(stProfile.stUserProfile.szAppName,szCOMscopeAppName);
	mov	edx,offset FLAT:szCOMscopeAppName
	mov	eax,offset FLAT:stProfile+04h
	call	strcpy

; 477       strcpy(stProfile.stUserProfile.szVersionString,szCOMscopeVersion);
	mov	edx,offset FLAT:szCOMscopeVersion
	mov	eax,offset FLAT:stProfile+02dh
	call	strcpy

; 478       strcpy(stProfile.szIniFilePath,szCOMscopeIniPath);
	mov	edx,offset FLAT:szCOMscopeIniPath
	mov	eax,offset FLAT:stProfile+0d9h
	call	strcpy

; 479       strcpy(stProfile.szProfileName,szCOMscopeProfile);
	mov	edx,offset FLAT:szCOMscopeProfile
	mov	eax,offset FLAT:stProfile+05eh
	call	strcpy

; 480       strcpy(stProfile.szAppName,szCOMscopeAppName);
	mov	edx,offset FLAT:szCOMscopeAppName
	mov	eax,offset FLAT:stProfile+087h
	call	strcpy

; 481       stProfile.pData = (void *)&stCFG;
	mov	dword ptr  stProfile+01f2h,offset FLAT:stCFG

; 482       stProfile.ulDataSize = sizeof(CSCFG);
	mov	dword ptr  stProfile+01eeh,0e3h

; 483       stProfile.ulMaxApps = 99;
	mov	dword ptr  stProfile+01eah,063h

; 484       stProfile.pfnUpdateCallBack = pfnUpdateProfileOptions;
	mov	dword ptr  stProfile+01deh,offset FLAT: pfnUpdateProfileOptions

; 485       stProfile.ulMaxProfileString = MAX_PROFILE_STRING;
	mov	dword ptr  stProfile+01e6h,028h

; 486       stProfile.bSearchApps = bSearchProfileApps;
	mov	ecx,dword ptr  bSearchProfileApps
	mov	al,byte ptr  stProfile+01ddh
	and	al,0f7h
	sal	ecx,03h
	and	cl,0fh
	or	al,cl
	mov	byte ptr  stProfile+01ddh,al

; 487       if (bLaunchShutdownServer)
	cmp	dword ptr  bLaunchShutdownServer,0h
	je	@BLBL36

; 489         stProfile.bLoadProcess = TRUE;
	or	byte ptr  stProfile+01ddh,02h

; 490         stProfile.bAutoSaveProfile = TRUE;
	or	byte ptr  stProfile+01ddh,04h

; 491         }
	jmp	@BLBL37
	align 010h
@BLBL36:

; 494         stProfile.bLoadProcess = FALSE;
	and	byte ptr  stProfile+01ddh,0fdh

; 495         stProfile.bAutoSaveProfile = FALSE;
	and	byte ptr  stProfile+01ddh,0fbh

; 496         }
@BLBL37:

; 497       stProfile.bLoadWindowPosition = FALSE;
	and	byte ptr  stProfile+01ddh,0feh

; 498       stProfile.bRestart = bIsTheFirst;
	mov	ecx,dword ptr  bIsTheFirst
	mov	al,byte ptr  stProfile+01ddh
	and	al,0dfh
	sal	ecx,05h
	and	cl,03fh
	or	al,cl
	mov	byte ptr  stProfile+01ddh,al

; 499       strcpy(stProfile.szProcessPrompt,"Load monitor ~configuration");
	mov	edx,offset FLAT:@STAT10
	mov	eax,offset FLAT:stProfile+0b0h
	call	strcpy

; 500       stProfile.hwndOwner = hwndFrame;
	mov	eax,dword ptr  hwndFrame
	mov	dword ptr  stProfile+01e2h,eax

; 502       if (DosQueryProcAddr(hMod,0,"InitializeProfile",(PFN *)&pfnInitializeProfile) == NO_ERROR)
	push	offset FLAT:pfnInitializeProfile
	push	offset FLAT:@STAT11
	push	0h
	push	dword ptr [ebp-084h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL38

; 504         if ((hProfileInstance = pfnInitializeProfile(&stProfile)) != 0)
	push	offset FLAT:stProfile
	call	dword ptr  pfnInitializeProfile
	add	esp,04h
	mov	dword ptr  hProfileInstance,eax
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL38

; 506           stProfile.bLoadWindowPosition = stCFG.bLoadWindowPosition;
	mov	cl,byte ptr  stCFG+017h
	and	ecx,07fh
	shr	ecx,06h
	mov	al,byte ptr  stProfile+01ddh
	and	al,0feh
	and	cl,01h
	or	al,cl
	mov	byte ptr  stProfile+01ddh,al

; 507           stProfile.bLoadProcess = stCFG.bLoadMonitor;
	mov	cl,byte ptr  stCFG+017h
	and	ecx,0ffh
	shr	ecx,07h
	mov	al,byte ptr  stProfile+01ddh
	and	al,0fdh
	sal	ecx,01h
	and	cl,03h
	or	al,cl
	mov	byte ptr  stProfile+01ddh,al

; 508           stProfile.bAutoSaveProfile = stCFG.bAutoSaveConfig;
	mov	cl,byte ptr  stCFG+018h
	and	ecx,01h
	mov	al,byte ptr  stProfile+01ddh
	and	al,0fbh
	sal	ecx,02h
	and	cl,07h
	or	al,cl
	mov	byte ptr  stProfile+01ddh,al

; 509           if ((DosQueryProcAddr(hMod,0,"GetProfileString",(PFN *)&pfnGetProfileString) == NO_ERROR) &&
	push	offset FLAT:pfnGetProfileString
	push	offset FLAT:@STAT12
	push	0h
	push	dword ptr [ebp-084h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL40

; 510               (DosQueryProcAddr(hMod,0,"SaveProfileString",(PFN *)&pfnSaveProfileString) == NO_ERROR))
	push	offset FLAT:pfnSaveProfileString
	push	offset FLAT:@STAT13
	push	0h
	push	dword ptr [ebp-084h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL40

; 512             if (strlen(szDataFileSpec) == 0)
	mov	eax,offset FLAT:szDataFileSpec
	call	strlen
	test	eax,eax
	jne	@BLBL41

; 514               if (pfnGetProfileString(hProfileInstance,"Data File",szDataFileSpec,CCHMAXPATH) == 0)
	push	0104h
	push	offset FLAT:szDataFileSpec
	push	offset FLAT:@STAT14
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnGetProfileString
	add	esp,010h
	test	eax,eax
	jne	@BLBL43

; 515                 strcpy(szEntryDataFileSpec,szDataFileSpec);
	mov	edx,offset FLAT:szDataFileSpec
	mov	eax,offset FLAT:szEntryDataFileSpec
	call	strcpy

; 516               }
	jmp	@BLBL43
	align 010h
@BLBL41:

; 519               bCommandLineDataFile = TRUE;
	mov	dword ptr  bCommandLineDataFile,01h

; 520               pfnSaveProfileString(hProfileInstance,"Data File",szDataFileSpec);
	push	offset FLAT:szDataFileSpec
	push	offset FLAT:@STAT15
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnSaveProfileString
	add	esp,0ch

; 521               strcpy(szEntryDataFileSpec,szDataFileSpec);
	mov	edx,offset FLAT:szDataFileSpec
	mov	eax,offset FLAT:szEntryDataFileSpec
	call	strcpy

; 522               }
@BLBL43:

; 523             if (pfnGetProfileString(hProfileInstance,"Capture File",szCaptureFileSpec,CCHMAXPATH) == 0)
	push	0104h
	push	offset FLAT:szCaptureFileSpec
	push	offset FLAT:@STAT16
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnGetProfileString
	add	esp,010h
	test	eax,eax
	jne	@BLBL44

; 524               strcpy(szCaptureFileSpec,"CAPTURE");
	mov	edx,offset FLAT:@STAT17
	mov	eax,offset FLAT:szCaptureFileSpec
	call	strcpy
@BLBL44:

; 525             strcpy(szEntryCaptureFileSpec,szCaptureFileSpec);
	mov	edx,offset FLAT:szCaptureFileSpec
	mov	eax,offset FLAT:szEntryCaptureFileSpec
	call	strcpy

; 526             }
@BLBL40:

; 527           if (DosQueryProcAddr(hMod,0,"GetProfileData",(PFN *)&pfnGetProfileData) == NO_ERROR)
	push	offset FLAT:pfnGetProfileData
	push	offset FLAT:@STAT18
	push	0h
	push	dword ptr [ebp-084h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL38

; 528             if ((lSearchStrLen = pfnGetProfileData(hProfileInstance,"Search String",(BYTE *)swSearchString,MAX_SEARCH_STRING)) == 0)
	push	0200h
	push	offset FLAT:swSearchString
	push	offset FLAT:@STAT19
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnGetProfileData
	add	esp,010h
	mov	dword ptr  lSearchStrLen,eax
	cmp	dword ptr  lSearchStrLen,0h
	jne	@BLBL46

; 529               stCFG.bFindString = FALSE;
	and	byte ptr  stCFG+01dh,0fdh
	jmp	@BLBL38
	align 010h
@BLBL46:

; 531               lSearchStrLen /= 2;
	mov	eax,dword ptr  lSearchStrLen
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	mov	dword ptr  lSearchStrLen,eax

; 532           }

; 533         }
@BLBL38:

; 534       DosFreeMod
; 534 ule(hMod);
	push	dword ptr [ebp-084h];	hMod
	call	DosFreeModule
	add	esp,04h

; 535       }

; 536     }
	jmp	@BLBL48
	align 010h
@BLBL34:

; 538     if (strlen(szDataFileSpec) != 0)
	mov	eax,offset FLAT:szDataFileSpec
	call	strlen
	test	eax,eax
	je	@BLBL48

; 539       strcpy(szEntryDataFileSpec,szDataFileSpec);
	mov	edx,offset FLAT:szDataFileSpec
	mov	eax,offset FLAT:szEntryDataFileSpec
	call	strcpy
@BLBL48:

; 541   WinSetWindowText(hwndFrame,szEXEtitle);
	push	offset FLAT:szEXEtitle
	push	dword ptr  hwndFrame
	call	WinSetWindowText
	add	esp,08h

; 543   WinRegisterClass(habAnchorBlock,(PSZ)"SUBFRAME",(PFNWP)FrameSubProc,0L,0);
	push	0h
	push	0h
	push	offset FLAT: FrameSubProc
	push	offset FLAT:@STAT1a
	push	dword ptr  habAnchorBlock
	call	WinRegisterClass
	add	esp,014h

; 545   WinRegisterClass(habAnchorBlock,(PSZ)"STATUS",(PFNWP)StatusProc,CS_SIZEREDRAW,0);
	push	0h
	push	04h
	push	offset FLAT: StatusProc
	push	offset FLAT:@STAT1b
	push	dword ptr  habAnchorBlock
	call	WinRegisterClass
	add	esp,014h

; 547   flCreateFlags =  (FCF_STANDARD ^ FCF_SHELLPOSITION);
	mov	dword ptr [ebp-078h],0c83fh;	flCreateFlags

; 549   hwndFrame = WinCreateStdWindow(HWND_DESKTOP,
	push	offset FLAT:hwndClient
	push	07d0h
	push	0h
	push	020000000h
	push	0h
	push	offset FLAT:@STAT1c
	lea	eax,[ebp-078h];	flCreateFlags
	push	eax
	push	0h
	push	01h
	call	WinCreateStdWindow
	add	esp,024h
	mov	dword ptr  hwndFrame,eax

; 560   if (hwndFrame == (HWND)NULL)
	cmp	dword ptr  hwndFrame,0h
	jne	@BLBL50

; 562     DisplayLastWindowError("Bad hwndFrame");
	push	offset FLAT:@STAT1d
	call	DisplayLastWindowError
	add	esp,04h

; 563     exit(70);
	mov	eax,046h
	call	exit

; 564     }
@BLBL50:

; 573   FrameProcess = WinSubclassWindow(hwndFrame,(PFNWP)FrameSubProc);
	push	offset FLAT: FrameSubProc
	push	dword ptr  hwndFrame
	call	WinSubclassWindow
	add	esp,08h
	mov	dword ptr  FrameProcess,eax

; 575   WinSetFocus(HWND_DESKTOP,hwndClient);
	push	dword ptr  hwndClient
	push	01h
	call	WinSetFocus
	add	esp,08h

; 577   hCom = -1;
	mov	dword ptr  hCom,0ffffffffh

; 587   while(WinGetMsg(habAnchorBlock,&qmsgMessage,(HWND)NULL,0,0))
	push	0h
	push	0h
	push	0h
	lea	eax,[ebp-024h];	qmsgMessage
	push	eax
	push	dword ptr  habAnchorBlock
	call	WinGetMsg
	add	esp,014h
	test	eax,eax
	je	@BLBL51
	align 010h
@BLBL52:

; 588     WinDispatchMsg(habAnchorBlock,&qmsgMessage);
	lea	eax,[ebp-024h];	qmsgMessage
	push	eax
	push	dword ptr  habAnchorBlock
	call	WinDispatchMsg
	add	esp,08h

; 587   while(WinGetMsg(habAnchorBlock,&qmsgMessage,(HWND)NULL,0,0))
	push	0h
	push	0h
	push	0h
	lea	eax,[ebp-024h];	qmsgMessage
	push	eax
	push	dword ptr  habAnchorBlock
	call	WinGetMsg
	add	esp,014h
	test	eax,eax
	jne	@BLBL52
@BLBL51:

; 590   DestroyHelpInstance();
	call	DestroyHelpInstance

; 592   WinDestroyWindow(stRead.hwnd);
	push	dword ptr  stRead+0bh
	call	WinDestroyWindow
	add	esp,04h

; 593   WinDestroyWindow(stWrite.hwnd);
	push	dword ptr  stWrite+0bh
	call	WinDestroyWindow
	add	esp,04h

; 594   WinDestroyWindow(hwndFrame);
	push	dword ptr  hwndFrame
	call	WinDestroyWindow
	add	esp,04h

; 595   WinDestroyWindow(hwndStatus);
	push	dword ptr  hwndStatus
	call	WinDestroyWindow
	add	esp,04h

; 596   WinDestroyWindow(hwndStatAll);
	push	dword ptr  hwndStatAll
	call	WinDestroyWindow
	add	esp,04h

; 597   WinDestroyWindow(hwndStatDev);
	push	dword ptr  hwndStatDev
	call	WinDestroyWindow
	add	esp,04h

; 598   WinDestroyWindow(hwndStatModemIn);
	push	dword ptr  hwndStatModemIn
	call	WinDestroyWindow
	add	esp,04h

; 599   WinDestroyWindow(hwndStatModemOut);
	push	dword ptr  hwndStatModemOut
	call	WinDestroyWindow
	add	esp,04h

; 600   WinDestroyWindow(hwndStatRcvBuf);
	push	dword ptr  hwndStatRcvBuf
	call	WinDestroyWindow
	add	esp,04h

; 601   WinDestroyWindow(hwndStatXmitBuf);
	push	dword ptr  hwndStatXmitBuf
	call	WinDestroyWindow
	add	esp,04h

; 603   WinDestroyMsgQueue(hmqQueue);
	push	dword ptr [ebp-04h];	hmqQueue
	call	WinDestroyMsgQueue
	add	esp,04h

; 604   WinTerminate(habAnchorBlock);
	push	dword ptr  habAnchorBlock
	call	WinTerminate
	add	esp,04h

; 606   DosCloseMutexSem(hmtxIPCpipeBlockedSem);
	push	dword ptr  hmtxIPCpipeBlockedSem
	call	DosCloseMutexSem
	add	esp,04h

; 607   DosCloseEventSem(hevWaitQueueStartSem);
	push	dword ptr  hevWaitQueueStartSem
	call	DosCloseEventSem
	add	esp,04h

; 608   DosCloseEventSem(hevWaitCOMiDataSem);
	push	dword ptr  hevWaitCOMiDataSem
	call	DosCloseEventSem
	add	esp,04h

; 609   DosCloseEventSem(hevDisplayWaitDataSem);
	push	dword ptr  hevDisplayWaitDataSem
	call	DosCloseEventSem
	add	esp,04h

; 610   DosCloseEventSem(hevKillMonitorThreadSem);
	push	dword ptr  hevKillMonitorThreadSem
	call	DosCloseEventSem
	add	esp,04h

; 611   DosCloseEventSem(hevKillDisplayThreadSem);
	push	dword ptr  hevKillDisplayThreadSem
	call	DosCloseEventSem
	add	esp,04h

; 612   DosCloseMutexSem(hmtxSigGioBlockedSem);
	push	dword ptr  hmtxSigGioBlockedSem
	call	DosCloseMutexSem
	add	esp,04h

; 613   DosCloseMutexSem(hmtxRowGioBlockedSem);
	push	dword ptr  hmtxRowGioBlockedSem
	call	DosCloseMutexSem
	add	esp,04h

; 614   DosCloseMutexSem(hmtxColGioBlockedSem);
	push	dword ptr  hmtxColGioBlockedSem
	call	DosCloseMutexSem
	add	esp,04h

; 615   if (pwScrollBuffer != NULL)
	cmp	dword ptr  pwScrollBuffer,0h
	je	@BLBL54

; 616     DosFreeMem(pwScrollBuffer);
	push	dword ptr  pwScrollBuffer
	call	DosFreeMem
	add	esp,04h
@BLBL54:

; 617   DosFreeMem(pwCaptureBuffer);
	push	dword ptr  pwCaptureBuffer
	call	DosFreeMem
	add	esp,04h

; 618   }
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
main	endp

; 621   {
	align 010h

	public fnwpClient
fnwpClient	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0178h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,05eh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 632   switch(msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL156
	align 04h
@BLBL157:

; 633     {
; 634     case WM_CREATE:
; 635       if (bEditCmdLineIniFile)
	cmp	dword ptr  bEditCmdLineIniFile,0h
	je	@BLBL55

; 636         {
; 637         sprintf(szMessage,"Initialization file %s entered on command line",szCmdLineIniFileSpec);
	push	offset FLAT:szCmdLineIniFileSpec
	mov	edx,offset FLAT:@STAT1e
	lea	eax,[ebp-012ch];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 638         MessageBox(HWND_DESKTOP,szMessage);
	lea	eax,[ebp-012ch];	szMessage
	push	eax
	push	01h
	call	MessageBox
	add	esp,08h

; 639         if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-0138h];	hMod
	push	eax
	push	offset FLAT:@STAT1f
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL56

; 640           {
; 641           stCOMiCFG.pszPortName = NULL;
	mov	dword ptr  stCOMiCFG+014h,0h

; 642           stCOMiCFG.hwndHelpInstance = hwndHelpInstance;
	mov	eax,dword ptr  hwndHelpInstance
	mov	dword ptr  stCOMiCFG+0ah,eax

; 643           stCOMiCFG.bInstallCOMscope = TRUE;
	or	byte ptr  stCOMiCFG+04bh,02h

; 644           stCOMiCFG.bInitInstall = FALSE;
	and	byte ptr  stCOMiCFG+04bh,0fbh

; 645           stCOMiCFG.pszRemoveOldDriverSpec == NULL;
; 646           stCOMiCFG.pszDriverIniSpec = szCmdLineIniFileSpec;
	mov	dword ptr  stCOMiCFG+018h,offset FLAT:szCmdLineIniFileSpec

; 647           if (DosQueryProcAddr(hMod,0,"InstallDevice",(PFN *)&pfnInstallDevice) == NO_ERROR)
	push	offset FLAT:pfnInstallDevice
	push	offset FLAT:@STAT20
	push	0h
	push	dword ptr [ebp-0138h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL57

; 648             pfnInstallDevice(&stCOMiCFG);
	push	offset FLAT:stCOMiCFG
	call	dword ptr  pfnInstallDevice
	add	esp,04h
@BLBL57:

; 649           DosFreeModule(hMod);
	push	dword ptr [ebp-0138h];	hMod
	call	DosFreeModule
	add	esp,04h

; 650           WinPostMsg(hwnd,WM_QUIT,0L,0L);
	push	0h
	push	0h
	push	02ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 651           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL56:

; 652           }
; 653         else
; 654           {
; 655           sprintf(szMessage,"Unable to load configuration library - %s",CONFIG_LIBRARY);
	push	offset FLAT:@STAT22
	mov	edx,offset FLAT:@STAT21
	lea	eax,[ebp-012ch];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 656           MessageBox(HWND_DESKTOP,szMessage);
	lea	eax,[ebp-012ch];	szMessage
	push	eax
	push	01h
	call	MessageBox
	add	esp,08h

; 657           }

; 658         }
@BLBL55:

; 659       ulMenuStyle = (PU_POSITIONONITEM | PU_MOUSEBUTTON2 | PU_HCONSTRAIN | PU_VCONSTRAIN | PU_KEYBOARD | PU_MOUSEBUTTON1);
	mov	dword ptr  @11aulMenuStyle,02c7h

; 660       if ((rc = DosCreateEventSem(0L,&hevWaitCOMiDataSem,0L,TRUE)) != NO_ERROR)
	push	01h
	push	0h
	push	offset FLAT:hevWaitCOMiDataSem
	push	0h
	call	DosCreateEventSem
	add	esp,010h
	mov	[ebp-013ch],eax;	rc
	cmp	dword ptr [ebp-013ch],0h;	rc
	je	@BLBL59

; 661         {
; 662         sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
	push	dword ptr [ebp-013ch];	rc
	mov	edx,offset FLAT:@STAT23
	lea	eax,[ebp-012ch];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 663         ErrorNotify(szMessage);
	lea	eax,[ebp-012ch];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 664         DosSleep(5000);
	push	01388h
	call	DosSleep
	add	esp,04h

; 665         WinPostMsg(hwnd,WM_QUIT,0L,0L);
	push	0h
	push	0h
	push	02ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 666         }
@BLBL59:

; 667 
; 668       if ((rc = DosCreateEventSem(0L,&hevDisplayWaitDataSem,0L,TRUE)) != NO_ERROR)
	push	01h
	push	0h
	push	offset FLAT:hevDisplayWaitDataSem
	push	0h
	call	DosCreateEventSem
	add	esp,010h
	mov	[ebp-013ch],eax;	rc
	cmp	dword ptr [ebp-013ch],0h;	rc
	je	@BLBL60

; 669         {
; 670         sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
	push	dword ptr [ebp-013ch];	rc
	mov	edx,offset FLAT:@STAT24
	lea	eax,[ebp-012ch];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 671         ErrorNotify(szMessage);
	lea	eax,[ebp-012ch];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 672         DosSleep(5000);
	push	01388h
	call	DosSleep
	add	esp,04h

; 673         WinPostMsg(hwnd,WM_QUIT,0L,0L);
	push	0h
	push	0h
	push	02ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 674         }
@BLBL60:

; 675 
; 676       if ((rc = DosCreateEventSem(0L,&hevKillDisplayThreadSem,0L,TRUE)) != NO_ERROR)
	push	01h
	push	0h
	push	offset FLAT:hevKillDisplayThreadSem
	push	0h
	call	DosCreateEventSem
	add	esp,010h
	mov	[ebp-013ch],eax;	rc
	cmp	dword ptr [ebp-013ch],0h;	rc
	je	@BLBL61

; 677         {
; 678         sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
	push	dword ptr [ebp-013ch];	rc
	mov	edx,offset FLAT:@STAT25
	lea	eax,[ebp-012ch];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 679         ErrorNotify(szMessage);
	lea	eax,[ebp-012ch];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 680         DosSleep(5000);
	push	01388h
	call	DosSleep
	add	esp,04h

; 681         WinPostMsg(hwnd,WM_QUIT,0L,0L);
	push	0h
	push	0h
	push	02ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 682         }
@BLBL61:

; 683 
; 684       if ((rc = DosCreateEventSem(0L,&hevKillMonitorThreadSem,0L,TRUE)) != NO_ERROR)
	push	01h
	push	0h
	push	offset FLAT:hevKillMonitorThreadSem
	push	0h
	call	DosCreateEventSem
	add	esp,010h
	mov	[ebp-013ch],eax;	rc
	cmp	dword ptr [ebp-013ch],0h;	rc
	je	@BLBL62

; 685         {
; 686         sprintf(szMessage,"DosCreateEventSem error: return code = %ld", rc);
	push	dword ptr [ebp-013ch];	rc
	mov	edx,offset FLAT:@STAT26
	lea	eax,[ebp-012ch];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 687         ErrorNotify(szMessage);
	lea	eax,[ebp-012ch];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 688         DosSleep(5000);
	push	01388h
	call	DosSleep
	add	esp,04h

; 689         WinPostMsg(hwnd,WM_QUIT,0L,0L);
	push	0h
	push	0h
	push	02ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 690         }
@BLBL62:

; 691 
; 692       if ((rc = DosCreateMutexSem(0L,&hmtxRowGioBlockedSem,0L,FALSE)) != NO_ERROR)
	push	0h
	push	0h
	push	offset FLAT:hmtxRowGioBlockedSem
	push	0h
	call	DosCreateMutexSem
	add	esp,010h
	mov	[ebp-013ch],eax;	rc
	cmp	dword ptr [ebp-013ch],0h;	rc
	je	@BLBL63

; 693         {
; 694         sprintf(szMessage,"DosCreateMutexSem error: RowGio - return code = %ld", rc);
	push	dword ptr [ebp-013ch];	rc
	mov	edx,offset FLAT:@STAT27
	lea	eax,[ebp-012ch];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 695         ErrorNotify(szMessage);
	lea	eax,[ebp-012ch];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 696         DosSleep(5000);
	push	01388h
	call	DosSleep
	add	esp,04h

; 697         WinPostMsg(hwnd,WM_QUIT,0L,0L);
	push	0h
	push	0h
	push	02ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 698         }
@BLBL63:

; 699 
; 700       if ((rc = DosCreateMutexSem(0L,&hmtxColGioBlockedSem,0L,FALSE)) != NO_ERROR)
	push	0h
	push	0h
	push	offset FLAT:hmtxColGioBlockedSem
	push	0h
	call	DosCreateMutexSem
	add	esp,010h
	mov	[ebp-013ch],eax;	rc
	cmp	dword ptr [ebp-013ch],0h;	rc
	je	@BLBL64

; 701         {
; 702         sprintf(szMessage,"DosCreateMutexSem error: ColGio - return code = %ld", rc);
	push	dword ptr [ebp-013ch];	rc
	mov	edx,offset FLAT:@STAT28
	lea	eax,[ebp-012ch];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 703         ErrorNotify(szMessage);
	lea	eax,[ebp-012ch];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 704         DosSleep(5000);
	push	01388h
	call	DosSleep
	add	esp,04h

; 705         WinPostMsg(hwnd,WM_QUIT,0L,0L);
	push	0h
	push	0h
	push	02ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 706         }
@BLBL64:

; 707 
; 708       if ((rc = DosCreateMutexSem(0L,&hmtxSigGioBlockedSem,0L,FALSE)) != NO_ERROR)
	push	0h
	push	0h
	push	offset FLAT:hmtxSigGioBlockedSem
	push	0h
	call	DosCreateMutexSem
	add	esp,010h
	mov	[ebp-013ch],eax;	rc
	cmp	dword ptr [ebp-013ch],0h;	rc
	je	@BLBL65

; 709         {
; 710         sprintf(szMessage,"DosCreateMutexSem error: SigGio - return code = %ld", rc);
	push	dword ptr [ebp-013ch];	rc
	mov	edx,offset FLAT:@STAT29
	lea	eax,[ebp-012ch];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 711         ErrorNotify(szMessage);
	lea	eax,[ebp-012ch];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 712         DosSleep(5000);
	push	01388h
	call	DosSleep
	add	esp,04h

; 713         WinPostMsg(hwnd,WM_QUIT,0L,0L);
	push	0h
	push	0h
	push	02ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 714         }
@BLBL65:

; 715 
; 716       /*
; 717       ** This initializes the global structure stCell, which defines
; 718       ** the character cell size.
; 719       */
; 720       if (CreatePS(hwnd))
	push	dword ptr [ebp+08h];	hwnd
	call	CreatePS
	add	esp,04h
	test	eax,eax
	je	@BLBL66

; 721         {
; 722         WinSendMsg(hwnd,WM_SYSVALUECHANGED,0L,0L);
	push	0h
	push	0h
	push	02dh
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendMsg
	add	esp,010h

; 723         WinSetWindowPos(WinQueryWindow(hwnd,QW_PARENT),
	push	05h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryWindow
	add	esp,08h
	push	02h
	push	dword ptr  lLastHeight
	push	dword ptr  lLastWidth
	push	dword ptr  swpLastPosition+0ch
	push	dword ptr  swpLastPosition+010h
	push	0h
	push	eax
	call	WinSetWindowPos
	add	esp,01ch

; 724                   (HWND)0,
; 725                         swpLastPosition.x,
; 726                         swpLastPosition.y,
; 727                         lLastWidth,
; 728                         lLastHeight,
; 729                         SWP_MOVE);
; 730 
; 731         /*
; 732         ** The status window is a line across the bottom of the client
; 733         ** area.  It is one char cell deep.  Text is displayed to show
; 734         **
; 735         ** The status window is a child window of the client.
; 736         ** It is created when the Presentation Space exists and the
; 737         ** Cell values are known.
; 738         */
; 739         hwndStatus = WinCreateWindow(hwnd,
	push	05h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryWindow
	add	esp,08h
	push	0h
	push	0h
	push	05209h
	push	03h
	push	eax
	push	dword ptr  lStatusHeight
	push	dword ptr  lLastWidth
	push	0h
	push	0h
	push	080000000h
	push	offset FLAT:@STAT2b
	push	offset FLAT:@STAT2a
	push	dword ptr [ebp+08h];	hwnd
	call	WinCreateWindow
	add	esp,034h
	mov	dword ptr  hwndStatus,eax

; 740                                     (PSZ)"STATUS",
; 741                                     (PSZ)"COMscope Status",
; 742                                      WS_VISIBLE,
; 743                                      0,0,
; 744                                      lLastWidth,
; 745                                      lStatusHeight,
; 746                                      WinQueryWindow(hwnd,QW_PARENT),
; 747                                      HWND_TOP,
; 748                                      WID_STATUS_LINE,
; 749                                      NULL,NULL);
; 750 
; 751         hwndStatAll = WinLoadDlg(HWND_DESKTOP,HWND_OBJECT,(PFNWP)fnwpDeviceAllStatusDlg,(USHORT)NULL,HWS_DLG,NULL);
	push	0h
	push	0640h
	push	0h
	push	offset FLAT: fnwpDeviceAllStatusDlg
	push	02h
	push	01h
	call	WinLoadDlg
	add	esp,018h
	mov	dword ptr  hwndStatAll,eax

; 752         hwndStatRcvBuf = WinLoadDlg(HWND_DESKTOP,HWND_OBJECT,(PFNWP)fnwpRcvBufferStatusDlg,(USHORT)NULL,HWS_BUFF_DLG,NULL);
	push	0h
	push	04a96h
	push	0h
	push	offset FLAT: fnwpRcvBufferStatusDlg
	push	02h
	push	01h
	call	WinLoadDlg
	add	esp,018h
	mov	dword ptr  hwndStatRcvBuf,eax

; 753         hwndStatXmitBuf = WinLoadDlg(HWND_DESKTOP,HWND_OBJECT,(PFNWP)fnwpXmitBufferStatusDlg,(USHORT)NULL,HWS_TX_BUFF_DLG,NULL);
	push	0h
	push	04a95h
	push	0h
	push	offset FLAT: fnwpXmitBufferStatusDlg
	push	02h
	push	01h
	call	WinLoadDlg
	add	esp,018h
	mov	dword ptr  hwndStatXmitBuf,eax

; 754         hwndStatModemIn = WinLoadDlg(HWND_DESKTOP,HWND_OBJECT,(PFNWP)fnwpModemInStatusDlg,(USHORT)NULL,HWSIS_DLG,NULL);
	push	0h
	push	0655h
	push	0h
	push	offset FLAT: fnwpModemInStatusDlg
	push	02h
	push	01h
	call	WinLoadDlg
	add	esp,018h
	mov	dword ptr  hwndStatModemIn,eax

; 755         hwndStatModemOut = WinLoadDlg(HWND_DESKTOP,HWND_OBJECT,(PFNWP)fnwpModemOutStatusDl
; 755 g,(USHORT)NULL,HWSOS_DLG,NULL);
	push	0h
	push	0656h
	push	0h
	push	offset FLAT: fnwpModemOutStatusDlg
	push	02h
	push	01h
	call	WinLoadDlg
	add	esp,018h
	mov	dword ptr  hwndStatModemOut,eax

; 756         hwndStatDev = WinLoadDlg(HWND_DESKTOP,HWND_OBJECT,(PFNWP)fnwpDeviceStatusDlg,(USHORT)NULL,HWSDS_DLG,NULL);
	push	0h
	push	0651h
	push	0h
	push	offset FLAT: fnwpDeviceStatusDlg
	push	02h
	push	01h
	call	WinLoadDlg
	add	esp,018h
	mov	dword ptr  hwndStatDev,eax

; 757         WinPostMsg(hwnd,UM_INITMENUS,0L,0L);
	push	0h
	push	0h
	push	08000h
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 758         }
	jmp	@BLBL67
	align 010h
@BLBL66:

; 759       else
; 760         WinPostMsg(hwnd,UM_STARTUP_EXIT_MSG,0L,0L);
	push	0h
	push	0h
	push	0fa00h
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h
@BLBL67:

; 761       break;
	jmp	@BLBL155
	align 04h
@BLBL158:

; 762     case WM_SYSVALUECHANGED:
; 763       /*
; 764       ** Set up globals used for sizing
; 765       */
; 766       lMouseButtonCount = WinQuerySysValue(HWND_DESKTOP,SV_CMOUSEBUTTONS);
	push	02bh
	push	01h
	call	WinQuerySysValue
	add	esp,08h
	mov	dword ptr  lMouseButtonCount,eax

; 767       lXfullScr   = WinQuerySysValue(HWND_DESKTOP,SV_CXFULLSCREEN);
	push	024h
	push	01h
	call	WinQuerySysValue
	add	esp,08h
	mov	dword ptr  lXfullScr,eax

; 768       lcxVSc  = WinQuerySysValue(HWND_DESKTOP,SV_CXVSCROLL);
	push	016h
	push	01h
	call	WinQuerySysValue
	add	esp,08h
	mov	dword ptr  lcxVSc,eax

; 769       lcxBrdr = WinQuerySysValue(HWND_DESKTOP,SV_CXSIZEBORDER);
	push	04h
	push	01h
	call	WinQuerySysValue
	add	esp,08h
	mov	dword ptr  lcxBrdr,eax

; 770       lYfullScr   = WinQuerySysValue(HWND_DESKTOP,SV_CYFULLSCREEN);
	push	025h
	push	01h
	call	WinQuerySysValue
	add	esp,08h
	mov	dword ptr  lYfullScr,eax

; 771       lXScr   = WinQuerySysValue(HWND_DESKTOP,SV_CXSCREEN);
	push	014h
	push	01h
	call	WinQuerySysValue
	add	esp,08h
	mov	dword ptr  lXScr,eax

; 772       lYScr   = WinQuerySysValue(HWND_DESKTOP,SV_CYSCREEN);
	push	015h
	push	01h
	call	WinQuerySysValue
	add	esp,08h
	mov	dword ptr  lYScr,eax

; 773       lcyBrdr = WinQuerySysValue(HWND_DESKTOP,SV_CYSIZEBORDER);
	push	05h
	push	01h
	call	WinQuerySysValue
	add	esp,08h
	mov	dword ptr  lcyBrdr,eax

; 774       lcyMenu = WinQuerySysValue(HWND_DESKTOP,SV_CYMENU);
	push	023h
	push	01h
	call	WinQuerySysValue
	add	esp,08h
	mov	dword ptr  lcyMenu,eax

; 775       lcyTitleBar = WinQuerySysValue(HWND_DESKTOP,SV_CYTITLEBAR);
	push	01eh
	push	01h
	call	WinQuerySysValue
	add	esp,08h
	mov	dword ptr  lcyTitleBar,eax

; 776 
; 777       if (stCFG.bLargeFont)
	test	byte ptr  stCFG+019h,080h
	je	@BLBL68

; 778         {
; 779         if (lFontsAvailable <= 2)
	cmp	dword ptr  lFontsAvailable,02h
	jg	@BLBL69

; 780           {
; 781           bSkipInitPos = TRUE;
	mov	dword ptr  bSkipInitPos,01h

; 782           stCFG.bLargeFont = FALSE;
	and	byte ptr  stCFG+019h,07fh

; 783           stCFG.wRowFont = HEX_FONT;
	mov	word ptr  stCFG+0d9h,0h

; 784           stCFG.wColReadFont = ASCII_FONT;
	mov	word ptr  stCFG+0dbh,01h

; 785           stCFG.wColWriteFont = ASCII_FONT;
	mov	word ptr  stCFG+0ddh,01h

; 786           }
	jmp	@BLBL68
	align 010h
@BLBL69:

; 787         else
; 788           {
; 789           wASCIIfont = 3;
	mov	word ptr  wASCIIfont,03h

; 790           wHEXfont = 2;
	mov	word ptr  wHEXfont,02h

; 791           }

; 792         }
@BLBL68:

; 793       stCell.cx = astFontMetrics[wASCIIfont].lAveCharWidth;
	xor	eax,eax
	mov	ax,word ptr  wASCIIfont
	imul	eax,0e4h
	mov	eax,dword ptr [eax+ astFontMetrics+064h]
	mov	word ptr  stCell,ax

; 794       stCell.cy = astFontMetrics[wASCIIfont].lXHeight + 1;
	xor	eax,eax
	mov	ax,word ptr  wASCIIfont
	imul	eax,0e4h
	mov	eax,dword ptr [eax+ astFontMetrics+048h]
	inc	eax
	mov	word ptr  stCell+02h,ax

; 795       /*
; 796       ** Set the size and position of the frame window by making the
; 797       ** client area width and height integral numbers of cell
; 798       ** units.  Calculate the frame window values necessary to
; 799       ** achieve this.
; 800       */
; 801       lStatusHeight = (stCell.cy + 4);
	movsx	eax,word ptr  stCell+02h
	add	eax,04h
	mov	dword ptr  lStatusHeight,eax

; 802       lMinimumHeight = ((MINHEIGHT * stCell.cy) + (lcyBrdr * 2) + lcyTitleBar + lcyMenu + lStatusHeight);
	mov	eax,dword ptr  lcyBrdr
	add	eax,eax
	add	eax,dword ptr  lcyMenu
	add	eax,dword ptr  lcyTitleBar
	add	eax,dword ptr  lStatusHeight
	mov	dword ptr  lMinimumHeight,eax

; 803       lLastHeight = (lMinimumHeight + ((INITHEIGHT - MINHEIGHT) * stCell.cy)) + 1;
	movsx	eax,word ptr  stCell+02h
	imul	eax,0ah
	add	eax,dword ptr  lMinimumHeight
	inc	eax
	mov	dword ptr  lLastHeight,eax

; 804       lMinimumWidth = ((MINWIDTH * stCell.cx) + (lcxBrdr * 2));
	movsx	ecx,word ptr  stCell
	sal	ecx,05h
	mov	eax,dword ptr  lcxBrdr
	add	eax,eax
	add	eax,ecx
	mov	dword ptr  lMinimumWidth,eax

; 805       lLastWidth = (lMinimumWidth + ((INITWIDTH - MINWIDTH) * stCell.cx));
	movsx	eax,word ptr  stCell
	sal	eax,03h
	add	eax,dword ptr  lMinimumWidth
	mov	dword ptr  lLastWidth,eax

; 806       if (!bFirstPosition)
	cmp	dword ptr  bFirstPosition,0h
	jne	@BLBL71

; 807         {
; 808         WinQueryWindowPos(hwndFrame,&swpLastPosition);
	push	offset FLAT:swpLastPosition
	push	dword ptr  hwndFrame
	call	WinQueryWindowPos
	add	esp,08h

; 809         if (swpLastPosition.x < 0)
	cmp	dword ptr  swpLastPosition+010h,0h
	jge	@BLBL72

; 810           swpLastPosition.x = 0;
	mov	dword ptr  swpLastPosition+010h,0h
	jmp	@BLBL73
	align 010h
@BLBL72:

; 811         else
; 812           if ((swpLastPosition.x + lLastWidth) > lXScr)
	mov	eax,dword ptr  lLastWidth
	add	eax,dword ptr  swpLastPosition+010h
	cmp	dword ptr  lXScr,eax
	jge	@BLBL73

; 813             swpLastPosition.x = (lXScr - lLastWidth - lcxBrdr);
	mov	eax,dword ptr  lXScr
	sub	eax,dword ptr  lLastWidth
	sub	eax,dword ptr  lcxBrdr
	mov	dword ptr  swpLastPosition+010h,eax
@BLBL73:

; 814         if (swpLastPosition.y < 0)
	cmp	dword ptr  swpLastPosition+0ch,0h
	jge	@BLBL75

; 815           swpLastPosition.y = 0;
	mov	dword ptr  swpLastPosition+0ch,0h
	jmp	@BLBL78
	align 010h
@BLBL75:

; 816         else
; 817           if ((swpLastPosition.y + lLastHeight) > lYScr)
	mov	eax,dword ptr  lLastHeight
	add	eax,dword ptr  swpLastPosition+0ch
	cmp	dword ptr  lYScr,eax
	jge	@BLBL78

; 818             swpLastPosition.y = (lYScr - lLastHeight - lcyBrdr);
	mov	eax,dword ptr  lYScr
	sub	eax,dword ptr  lLastHeight
	sub	eax,dword ptr  lcyBrdr
	mov	dword ptr  swpLastPosition+0ch,eax

; 819         }
	jmp	@BLBL78
	align 010h
@BLBL71:

; 820       else
; 821         {
; 822         bFirstPosition = FALSE;
	mov	dword ptr  bFirstPosition,0h

; 823         swpLastPosition.x = ((lXScr / 2) - (lLastWidth / 2));
	mov	eax,dword ptr  lXScr
	cdq	
	mov	ecx,eax
	and	edx,01h
	add	ecx,edx
	sar	ecx,01h
	mov	eax,dword ptr  lLastWidth
	cdq	
	xchg	ecx,eax
	and	edx,01h
	add	ecx,edx
	sar	ecx,01h
	sub	eax,ecx
	mov	dword ptr  swpLastPosition+010h,eax

; 824         swpLastPosition.y = ((lYScr / 2) - (lLastHeight / 2));
	mov	eax,dword ptr  lYScr
	cdq	
	mov	ecx,eax
	and	edx,01h
	add	ecx,edx
	sar	ecx,01h
	mov	eax,dword ptr  lLastHeight
	cdq	
	xchg	ecx,eax
	and	edx,01h
	add	ecx,edx
	sar	ecx,01h
	sub	eax,ecx
	mov	dword ptr  swpLastPosition+0ch,eax

; 825         }
@BLBL78:

; 826       swpLastPosition.cx = lLastWidth;
	mov	eax,dword ptr  lLastWidth
	mov	dword ptr  swpLastPosition+08h,eax

; 827       swpLastPosition.cy = lLastHeight;
	mov	eax,dword ptr  lLastHeight
	mov	dword ptr  swpLastPosition+04h,eax

; 828       WinSetWindowPos(WinQueryWindow(hwnd,QW_PARENT),
	push	05h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryWindow
	add	esp,08h
	push	03h
	push	dword ptr  lLastHeight
	push	dword ptr  lLastWidth
	push	dword ptr  swpLastPosition+0ch
	push	dword ptr  swpLastPosition+010h
	push	0h
	push	eax
	call	WinSetWindowPos
	add	esp,01ch

; 829                 (HWND)0,
; 830                       swpLastPosition.x,
; 831                       swpLastPosition.y,
; 832                       lLastWidth,
; 833                       lLastHeight,
; 834                       (SWP_SIZE | SWP_MOVE));
; 835 
; 836       /*
; 837       ** setup column window tracking info structure
; 838       */
; 839       stColTrack.cxBorder = 4;
	mov	dword ptr  stColTrack,04h

; 840       stColTrack.cyBorder = 4;
	mov	dword ptr  stColTrack+04h,04h

; 841       stColTrack.cxGrid = stCell.cx;
	movsx	eax,word ptr  stCell
	mov	dword ptr  stColTrack+08h,eax

; 842       stColTrack.cyGrid = stCell.cy;
	movsx	eax,word ptr  stCell+02h
	mov	dword ptr  stColTrack+0ch,eax

; 843       stColTrack.cxKeyboard = stCell.cx;
	movsx	eax,word ptr  stCell
	mov	dword ptr  stColTrack+010h,eax

; 844       stColTrack.cyKeyboard = stCell.cy;
	movsx	eax,word ptr  stCell+02h
	mov	dword ptr  stColTrack+014h,eax

; 845       stColTrack.ptlMinTrackSize.x = (stCell.cx * 6);
	movsx	eax,word ptr  stCell
	imul	eax,06h
	mov	dword ptr  stColTrack+038h,eax

; 846       stColTrack.ptlMinTrackSize.y = 0;
	mov	dword ptr  stColTrack+03ch,0h

; 847       stColTrack.ptlMaxTrackSize.x = (stCell.cx * (INITWIDTH - 7));
	movsx	eax,word ptr  stCell
	imul	eax,021h
	mov	dword ptr  stColTrack+040h,eax

; 848       stColTrack.ptlMaxTrackSize.y = (stCell.cy * INITHEIGHT);
	movsx	eax,word ptr  stCell+02h
	imul	eax,0ah
	mov	dword ptr  stColTrack+044h,eax

; 849       break;
	jmp	@BLBL155
	align 04h
@BLBL159:

; 850     case WM_ACTIVATE:
; 851       if(SHORT1FROMMP(mp1)) // activation ?
	mov	ax,[ebp+010h];	mp1
	test	ax,ax
	je	@BLBL79

; 852         {
; 853         if (!bFrameActivated)
	cmp	dword ptr  bFrameActivated,0h
	jne	@BLBL81

; 854           {
; 855           WinSetFocus(HWND_DESKTOP,hwndFrame);
	push	dword ptr  hwndFrame
	push	01h
	call	WinSetFocus
	add	esp,08h

; 856           WinSendMsg(WinQueryHelpInstance(hwndClient),HM_SET_ACTIVE_WINDOW,0L,0L);
	push	dword ptr  hwndClient
	call	WinQueryHelpInstance
	add	esp,04h
	push	0h
	push	0h
	push	0224h
	push	eax
	call	WinSendMsg
	add	esp,010h

; 857           bFrameActivated = TRUE;
	mov	dword ptr  bFrameActivated,01h

; 858           }

; 859         }
	jmp	@BLBL81
	align 010h
@BLBL79:

; 860       else
; 861         bFrameActivated = FALSE;
	mov	dword ptr  bFrameActivated,0h
@BLBL81:

; 862       break;
	jmp	@BLBL155
	align 04h
@BLBL160:

; 863     case WM_HELP:
; 864       if (SHORT1FROMMP(mp2) & CMDSRC_PUSHBUTTON)
	mov	ax,[ebp+014h];	mp2
	test	al,01h
	je	@BLBL82

; 865         {
; 866         DisplayHelpPanel(SHORT1FROMMP(mp1));
	mov	ax,[ebp+010h];	mp1
	push	eax
	call	DisplayHelpPanel
	add	esp,04h

; 867         return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL82:

; 868         }
; 869       break;
	jmp	@BLBL155
	align 04h
@BLBL161:

; 870     case HM_QUERY_KEYS_HELP:
; 871       return (MRESULT)HLPP_KEYS;
	mov	eax,07533h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL162:

; 872     case UM_STARTUP_EXIT_MSG:
; 873       WinMessageBox(HWND_DESKTOP,
	push	05h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryWindow
	add	esp,08h
	push	04020h
	push	0h
	push	offset FLAT:szTitle
	push	offset FLAT:szErrorMessage
	push	eax
	push	01h
	call	WinMessageBox
	add	esp,018h

; 874                     WinQueryWindow(hwnd,QW_PARENT),
; 875                     szErrorMessage,
; 876                     szTitle,
; 877                     0,
; 878                     MB_MOVEABLE | MB_OK | MB_CUAWARNING);
; 879       WinPostMsg(hwnd,WM_QUIT,0L,0L);
	push	0h
	push	0h
	push	02ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 880       break;
	jmp	@BLBL155
	align 04h
@BLBL163:

; 881     case WM_COMMAND:
; 882        return(WinCommand(hwnd,SHORT1FROMMP(mp1),&stCFG));
	push	offset FLAT:stCFG
	mov	ax,[ebp+010h];	mp1
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinCommand
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL164:

; 883      case WM_MINMAXFRAME:
; 884         {
; 885         SHORT sScreenTemp;
; 886         LONG lFullScr;
; 887         PSWP pswp = (PSWP)mp1;
	mov	eax,[ebp+010h];	mp1
	mov	[ebp-0178h],eax;	pswp

; 888 
; 889         ClearRowScrollBar(&stRow);
	push	offset FLAT:stRow
	call	ClearRowScrollBar
	add	esp,04h

; 890         if (pswp->fl & SWP_MAXIMIZE)
	mov	eax,[ebp-0178h];	pswp
	test	byte ptr [eax+01h],08h
	je	@BLBL83

; 891           {
; 892           bMaximized = TRUE;
	mov	dword ptr  bMaximized,01h

; 893           if (!bMinimized)
	cmp	dword ptr  bMinimized,0h
	jne	@BLBL84

; 894             WinQueryWindowPos(hwndFrame,&swpLastPosition);
	push	offset FLAT:swpLastPosition
	push	dword ptr  hwndFrame
	call	WinQueryWindowPos
	add	esp,08h
@BLBL84:

; 895           lFullScr = (lYScr - lcyMenu - lcyTitleBar);
	mov	eax,dword ptr  lYScr
	sub	eax,dword ptr  lcyMenu
	sub	eax,dword ptr  lcyTitleBar
	mov	[ebp-0174h],eax;	lFullScr

; 896           stRow.lHeight = (lYScr - (lYScr % (stCell.cy * 2)) + lStatusHeight);// + 2);
	movsx	ecx,word ptr  stCell+02h
	add	ecx,ecx
	mov	eax,dword ptr  lYScr
	cdq	
	idiv	ecx
	mov	eax,dword ptr  lStatusHeight
	add	eax,dword ptr  lYScr
	sub	eax,edx
	mov	dword ptr  stRow+02fh,eax

; 897           if (stRow.lHeight > lFullScr)
	mov	eax,[ebp-0174h];	lFullScr
	cmp	dword ptr  stRow+02fh,eax
	jle	@BLBL85

; 898             {
; 899             while (stRow.lHeight > lFullScr)
	mov	eax,[ebp-0174h];	lFullScr
	cmp	dword ptr  stRow+02fh,eax
	jle	@BLBL86
	align 010h
@BLBL87:

; 900               stRow.lHeight -= (stCell.cy * 2);
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRow+02fh
	sub	eax,ecx
	sub	eax,ecx
	mov	dword ptr  stRow+02fh,eax

; 899             while (stRow.lHeight > lFullScr)
	mov	eax,[ebp-0174h];	lFullScr
	cmp	dword ptr  stRow+02fh,eax
	jg	@BLBL87
@BLBL86:

; 901             pswp->cy = (stRow.lHeight + lcyMenu + lcyTitleBar + (lcyBrdr * 2));
	mov	eax,dword ptr  lcyMenu
	add	eax,dword ptr  stRow+02fh
	add	eax,dword ptr  lcyTitleBar
	mov	ecx,dword ptr  lcyBrdr
	add	ecx,ecx
	add	ecx,eax
	mov	eax,[ebp-0178h];	pswp
	mov	[eax+04h],ecx

; 902             }
	jmp	@BLBL89
	align 010h
@BLBL85:

; 904             if (stRow.lHeight < lFullScr)
	mov	eax,[ebp-0174h];	lFullScr
	cmp	dword ptr  stRow+02fh,eax
	jge	@BLBL89

; 905               pswp->cy = (stRow.lHeight + lcyMenu + lcyTitleBar + (lcyBrdr * 2));
	mov	eax,dword ptr  lcyMenu
	add	eax,dword ptr  stRow+02fh
	add	eax,dword ptr  lcyTitleBar
	mov	ecx,dword ptr  lcyBrdr
	add	ecx,ecx
	add	ecx,eax
	mov	eax,[ebp-0178h];	pswp
	mov	[eax+04h],ecx
@BLBL89:

; 906           if (pswp->cy <= (lYScr - lcyBrdr))
	mov	eax,[ebp-0178h];	pswp
	mov	ecx,dword ptr  lYScr
	sub	ecx,dword ptr  lcyBrdr
	cmp	[eax+04h],ecx
	jg	@BLBL91

; 908             sScreenTemp = ((SHORT)pswp->y + lcyBrdr);
	mov	eax,[ebp-0178h];	pswp
	mov	ax,[eax+0ch]
	movsx	eax,ax
	add	eax,dword ptr  lcyBrdr
	mov	[ebp-016eh],ax;	sScreenTemp

; 909             pswp->y = (LONG)sScreenTemp;
	movsx	ecx,word ptr [ebp-016eh];	sScreenTemp
	mov	eax,[ebp-0178h];	pswp
	mov	[eax+0ch],ecx

; 910             }
@BLBL91:

; 911           stRow.lWidth = (lXScr - (lXScr % stCell.cx));
	movsx	ecx,word ptr  stCell
	mov	eax,dword ptr  lXScr
	cdq	
	idiv	ecx
	mov	eax,dword ptr  lXScr
	sub	eax,edx
	mov	dword ptr  stRow+033h,eax

; 912           if (stRow.lWidth > lXScr)
	mov	eax,dword ptr  lXScr
	cmp	dword ptr  stRow+033h,eax
	jle	@BLBL92

; 914             while (stRow.lWidth > lXScr)
	mov	eax,dword ptr  lXScr
	cmp	dword ptr  stRow+033h,eax
	jle	@BLBL93
	align 010h
@BLBL94:

; 915               stRow.lWidth -= stCell.cx;
	movsx	ecx,word ptr  stCell
	mov	eax,dword ptr  stRow+033h
	sub	eax,ecx
	mov	dword ptr  stRow+033h,eax

; 914             while (stRow.lWidth > lXScr)
	mov	eax,dword ptr  lXScr
	cmp	dword ptr  stRow+033h,eax
	jg	@BLBL94
@BLBL93:

; 916             pswp->cx = (stRow.lWidth + (lcyBrdr * 2));
	mov	ecx,dword ptr  lcyBrdr
	add	ecx,ecx
	add	ecx,dword ptr  stRow+033h
	mov	eax,[ebp-0178h];	pswp
	mov	[eax+08h],ecx

; 917             }
	jmp	@BLBL96
	align 010h
@BLBL92:

; 919             if (stRow.lWidth < lXScr)
	mov	eax,dword ptr  lXScr
	cmp	dword ptr  stRow+033h,eax
	jge	@BLBL96

; 920               pswp->cx = (stRow.lWidth + (lcyBrdr * 2));
	mov	ecx,dword ptr  lcyBrdr
	add	ecx,ecx
	add	ecx,dword ptr  stRow+033h
	mov	eax,[ebp-0178h];	pswp
	mov	[eax+08h],ecx
@BLBL96:

; 921           if (pswp->cx <= (lXScr - lcxBrdr))
	mov	eax,[ebp-0178h];	pswp
	mov	ecx,dword ptr  lXScr
	sub	ecx,dword ptr  lcxBrdr
	cmp	[eax+08h],ecx
	jg	@BLBL98

; 923             sScreenTemp = ((SHORT)pswp->x + lcxBrdr);
	mov	eax,[ebp-0178h];	pswp
	mov	ax,[eax+010h]
	movsx	eax,ax
	add	eax,dword ptr  lcxBrdr
	mov	[ebp-016eh],ax;	sScreenTemp

; 924             pswp->x = (LONG)sScreenTemp;
	movsx	ecx,word ptr [ebp-016eh];	sScreenTemp
	mov	eax,[ebp-0178h];	pswp
	mov	[eax+010h],ecx

; 925             }
@BLBL98:

; 926           stRow.lCharWidth = (stRow.lWidth / stCell.cx);
	movsx	ecx,word ptr  stCell
	mov	eax,dword ptr  stRow+033h
	cdq	
	idiv	ecx
	mov	dword ptr  stRow+027h,eax

; 927           stRow.lCharHeight = (stRow.lHeight / stCell.cy);
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRow+02fh
	cdq	
	idiv	ecx
	mov	dword ptr  stRow+02bh,eax

; 928           stRow.lHeight -= stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRow+02fh
	sub	eax,ecx
	mov	dword ptr  stRow+02fh,eax

; 929           stRow.lWidth -= stCell.cx;
	movsx	ecx,word ptr  stCell
	mov	eax,dword ptr  stRow+033h
	sub	eax,ecx
	mov	dword ptr  stRow+033h,eax

; 930           stRow.lCharSize = (stRow.lCharWidth * stRow.lCharHeight);
	mov	eax,dword ptr  stRow+02bh
	imul	eax,dword ptr  stRow+027h
	mov	dword ptr  stRow+023h,eax

; 931           WinSetWindowText(hwndFrame,szTitle);
	push	offset FLAT:szTitle
	push	dword ptr  hwndFrame
	call	WinSetWindowText
	add	esp,08h

; 932           }
	jmp	@BLBL99
	align 010h
@BLBL83:

; 934           if (pswp->fl & SWP_RESTORE)
	mov	eax,[ebp-0178h];	pswp
	test	byte ptr [eax+01h],010h
	je	@BLBL100

; 936             bMaximized = FALSE;
	mov	dword ptr  bMaximized,0h

; 937             bMinimized = FALSE;
	mov	dword ptr  bMinimized,0h

; 938             WinSetWindowText(hwndFrame,szTitle);
	push	offset FLAT:szTitle
	push	dword ptr  hwndFrame
	call	WinSetWindowText
	add	esp,08h

; 939             }
	jmp	@BLBL99
	align 010h
@BLBL100:

; 942             if (!bMaximized)
	cmp	dword ptr  bMaximized,0h
	jne	@BLBL102

; 943               WinQueryWindowPos(hwndFrame,&swpLastPosition);
	push	offset FLAT:swpLastPosition
	push	dword ptr  hwndFrame
	call	WinQueryWindowPos
	add	esp,08h
@BLBL102:

; 944             bMaximized = FALSE;
	mov	dword ptr  bMaximized,0h

; 945             bMinimized = TRUE;
	mov	dword ptr  bMinimized,01h

; 946             if (hCom != 0xffffffff)
	cmp	dword ptr  hCom,0ffffffffh
	je	@BLBL99

; 947               WinSetWindowText(hwndFrame,stCFG.szPortName);
	push	offset FLAT:stCFG+02h
	push	dword ptr  hwndFrame
	call	WinSetWindowText
	add	esp,08h

; 948             }
@BLBL99:

; 949         }

; 950       return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL165:

; 952       if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
	mov	al,byte ptr  stCFG+01bh
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL104

; 954         switch(HIUSHORT(mp2))
	mov	eax,[ebp+014h];	mp2
	shr	eax,010h
	and	eax,0ffffh
	and	eax,0ffffh
	jmp	@BLBL167
	align 04h
@BLBL168:

; 957               RowScroll(&stRow,1,FALSE);
	push	0h
	push	01h
	push	offset FLAT:stRow
	call	RowScroll
	add	esp,0ch

; 958               break;
	jmp	@BLBL166
	align 04h
@BLBL169:

; 960               RowScroll(&stRow,-1,FALSE);
	push	0h
	push	0ffffffffh
	push	offset FLAT:stRow
	call	RowScroll
	add	esp,0ch

; 961               break;
	jmp	@BLBL166
	align 04h
@BLBL170:

; 963               RowScroll(&stRow,stRow.lCharHeight,FALSE);
	push	0h
	mov	ax,word ptr  stRow+02bh
	push	eax
	push	offset FLAT:stRow
	call	RowScroll
	add	esp,0ch

; 964               break;
	jmp	@BLBL166
	align 04h
@BLBL171:

; 966               RowScroll(&stRow,-stRow.lCharHeight,FALSE);
	push	0h
	mov	eax,dword ptr  stRow+02bh
	neg	eax
	push	eax
	push	offset FLAT:stRow
	call	RowScroll
	add	esp,0ch

; 967               break;
	jmp	@BLBL166
	align 04h
@BLBL172:

; 969               RowScroll(&stRow,LOUSHORT(mp2),TRUE);
	push	01h
	mov	ax,[ebp+014h];	mp2
	push	eax
	push	offset FLAT:stRow
	call	RowScroll
	add	esp,0ch

; 970               break;
	jmp	@BLBL166
	align 04h
@BLBL173:

; 972               break;
	jmp	@BLBL166
	align 04h
	jmp	@BLBL166
	align 04h
@BLBL167:
	cmp	eax,02h
	je	@BLBL168
	cmp	eax,01h
	je	@BLBL169
	cmp	eax,04h
	je	@BLBL170
	cmp	eax,03h
	je	@BLBL171
	cmp	eax,06h
	je	@BLBL172
	jmp	@BLBL173
	align 04h
@BLBL166:

; 974         }
@BLBL104:

; 975       break;
	jmp	@BLBL155
	align 04h
@BLBL174:

; 977       if(bFrameActivated)
	cmp	dword ptr  bFrameActivated,0h
	je	@BLBL105

; 979         if (!stCFG.bColumnDisplay && (stCFG.fDisplaying & (DISP_DATA | DISP_FILE)))
	test	byte ptr  stCFG+018h,080h
	jne	@BLBL107
	mov	al,byte ptr  stCFG+01bh
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL107

; 981           WinQueryPointerPos(HWND_DESKTOP,
; 981 &ptl);
	lea	eax,[ebp-0134h];	ptl
	push	eax
	push	01h
	call	WinQueryPointerPos
	add	esp,08h

; 982           WinQueryWindowPos(hwndFrame,&swp);
	lea	eax,[ebp-0160h];	swp
	push	eax
	push	dword ptr  hwndFrame
	call	WinQueryWindowPos
	add	esp,08h

; 983           ptl.y -= (swp.y + lcyBrdr + lStatusHeight);
	mov	eax,[ebp-0130h];	ptl
	sub	eax,[ebp-0154h];	swp
	sub	eax,dword ptr  lStatusHeight
	sub	eax,dword ptr  lcyBrdr
	mov	[ebp-0130h],eax;	ptl

; 984           ptl.x -= (swp.x + lcxBrdr);
	mov	eax,[ebp-0134h];	ptl
	sub	eax,[ebp-0150h];	swp
	sub	eax,dword ptr  lcxBrdr
	mov	[ebp-0134h],eax;	ptl

; 985           lMouseRow = ((stRow.lCharHeight - (ptl.y / (stCell.cy * 2))) - 1);
	movsx	ecx,word ptr  stCell+02h
	add	ecx,ecx
	mov	eax,[ebp-0130h];	ptl
	cdq	
	idiv	ecx
	mov	ecx,eax
	mov	eax,dword ptr  stRow+02bh
	sub	eax,ecx
	dec	eax
	mov	[ebp-0168h],eax;	lMouseRow

; 986           lMouseCol = (ptl.x / stCell.cx);
	movsx	ecx,word ptr  stCell
	mov	eax,[ebp-0134h];	ptl
	cdq	
	idiv	ecx
	mov	[ebp-016ch],eax;	lMouseCol

; 987           DisplayCharacterInfo(hwnd,((lMouseRow * stRow.lCharWidth) + lMouseCol));
	mov	eax,dword ptr  stRow+027h
	imul	eax,[ebp-0168h];	lMouseRow
	add	eax,[ebp-016ch];	lMouseCol
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	DisplayCharacterInfo
	add	esp,08h

; 988           }

; 989         }
	jmp	@BLBL107
	align 010h
@BLBL105:

; 992         WinSetFocus(HWND_DESKTOP,hwndFrame);
	push	dword ptr  hwndFrame
	push	01h
	call	WinSetFocus
	add	esp,08h

; 993         WinSendMsg(WinQueryHelpInstance(hwndClient),HM_SET_ACTIVE_WINDOW,0L,0L);
	push	dword ptr  hwndClient
	call	WinQueryHelpInstance
	add	esp,04h
	push	0h
	push	0h
	push	0224h
	push	eax
	call	WinSendMsg
	add	esp,010h

; 994         bFrameActivated = TRUE;
	mov	dword ptr  bFrameActivated,01h

; 995         }
@BLBL107:

; 996       break;
	jmp	@BLBL155
	align 04h
@BLBL175:

; 998       if(bFrameActivated)
	cmp	dword ptr  bFrameActivated,0h
	je	@BLBL108

; 1000         bNoPaint = TRUE;
	mov	dword ptr  bNoPaint,01h

; 1001         hwndMenu = WinLoadMenu(hwndClient,(HMODULE)NULL,IDMPU_ROW_DISP_POPUP);
	push	0fa1h
	push	0h
	push	dword ptr  hwndClient
	call	WinLoadMenu
	add	esp,0ch
	mov	[ebp-0164h],eax;	hwndMenu

; 1003         if (mp1 != 0)
	cmp	dword ptr [ebp+010h],0h;	mp1
	je	@BLBL109

; 1005           WinQueryPointerPos(HWND_DESKTOP,&ptl);
	lea	eax,[ebp-0134h];	ptl
	push	eax
	push	01h
	call	WinQueryPointerPos
	add	esp,08h

; 1006           if (!stCFG.bStickyMenus)
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL110

; 1007             ulMenuStyle |= PU_MOUSEBUTTON2DOWN;
	mov	eax,dword ptr  @11aulMenuStyle
	or	al,010h
	mov	dword ptr  @11aulMenuStyle,eax
	jmp	@BLBL112
	align 010h
@BLBL110:

; 1009             ulMenuStyle &= ~(PU_MOUSEBUTTON2DOWN);
	mov	eax,dword ptr  @11aulMenuStyle
	and	al,0efh
	mov	dword ptr  @11aulMenuStyle,eax

; 1010           }
	jmp	@BLBL112
	align 010h
@BLBL109:

; 1013           ulMenuStyle &= ~(PU_MOUSEBUTTON2DOWN);
	mov	eax,dword ptr  @11aulMenuStyle
	and	al,0efh
	mov	dword ptr  @11aulMenuStyle,eax

; 1014           WinQueryWindowPos(hwndFrame,&swp);
	lea	eax,[ebp-0160h];	swp
	push	eax
	push	dword ptr  hwndFrame
	call	WinQueryWindowPos
	add	esp,08h

; 1015           ptl.x = (swp.x + (swp.cx / 2));
	mov	eax,[ebp-0158h];	swp
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	add	eax,[ebp-0150h];	swp
	mov	[ebp-0134h],eax;	ptl

; 1016           ptl.y = (swp.y + (swp.cy / 2));
	mov	eax,[ebp-015ch];	swp
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	add	eax,[ebp-0154h];	swp
	mov	[ebp-0130h],eax;	ptl

; 1017           }
@BLBL112:

; 1018         if (stCFG.wRowFont == wASCIIfont)
	mov	ax,word ptr  wASCIIfont
	cmp	word ptr  stCFG+0d9h,ax
	jne	@BLBL113

; 1019           PopupMenuItemCheck(hwndMenu,IDMPU_ASCII_FONT,TRUE);
	push	01h
	push	0fa8h
	push	dword ptr [ebp-0164h];	hwndMenu
	call	PopupMenuItemCheck
	add	esp,0ch
	jmp	@BLBL114
	align 010h
@BLBL113:

; 1021           PopupMenuItemCheck(hwndMenu,IDMPU_HEX_FONT,TRUE);
	push	01h
	push	0fa9h
	push	dword ptr [ebp-0164h];	hwndMenu
	call	PopupMenuItemCheck
	add	esp,0ch
@BLBL114:

; 1022         WinPopupMenu(HWND_DESKTOP,hwndClient,hwndMenu,ptl.x,ptl.y,usLastClientPopupItem,ulMenuStyle);
	push	dword ptr  @11aulMenuStyle
	xor	eax,eax
	mov	ax,word ptr  usLastClientPopupItem
	push	eax
	push	dword ptr [ebp-0130h];	ptl
	push	dword ptr [ebp-0134h];	ptl
	push	dword ptr [ebp-0164h];	hwndMenu
	push	dword ptr  hwndClient
	push	01h
	call	WinPopupMenu
	add	esp,01ch

; 1023         }
	jmp	@BLBL115
	align 010h
@BLBL108:

; 1026         WinSetFocus(HWND_DESKTOP,hwndFrame);
	push	dword ptr  hwndFrame
	push	01h
	call	WinSetFocus
	add	esp,08h

; 1027         WinSendMsg(WinQueryHelpInstance(hwndClient),HM_SET_ACTIVE_WINDOW,0L,0L);
	push	dword ptr  hwndClient
	call	WinQueryHelpInstance
	add	esp,04h
	push	0h
	push	0h
	push	0224h
	push	eax
	call	WinSendMsg
	add	esp,010h

; 1028         bFrameActivated = TRUE;
	mov	dword ptr  bFrameActivated,01h

; 1029         }
@BLBL115:

; 1030       break;
	jmp	@BLBL155
	align 04h
@BLBL176:

; 1032       RowPaint(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	RowPaint
	add	esp,04h

; 1033       break;
	jmp	@BLBL155
	align 04h
@BLBL177:

; 1035       if (ProcessKeystroke(&stCFG,mp1,mp2))
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	push	offset FLAT:stCFG
	call	ProcessKeystroke
	add	esp,0ch
	test	eax,eax
	je	@BLBL116

; 1036         return((MRESULT)TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL116:

; 1037       return( WinDefWindowProc(hwnd,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefWindowProc
	add	esp,010h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL178:

; 1039       return WinDefWindowProc(hwnd,msg,mp1,WndSize(hwnd,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	push	dword ptr [ebp+08h];	hwnd
	call	WndSize
	add	esp,0ch
	push	eax
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefWindowProc
	add	esp,010h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL179:

; 1041       return (MRESULT)(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL180:

; 1043       CreateColumnWindows();
	call	CreateColumnWindows

; 1044       if (lFontsAvailable <= 2)
	cmp	dword ptr  lFontsAvailable,02h
	jg	@BLBL117

; 1045         MenuItemEnable(hwndFrame,IDM_TOGGLE_FONT_SIZE,FALSE);
	push	0h
	push	081eh
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
@BLBL117:

; 1046       MenuItemEnable(hwndFrame,IDM_SURFACE_ALL,FALSE);
	push	0h
	push	081dh
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1047       usLastClientPopupItem = IDMPU_FONT;
	mov	word ptr  usLastClientPopupItem,0fa7h

; 1049       stCOMiCFG.cbSize = sizeof(COMICFG);
	mov	word ptr  stCOMiCFG,04dh

; 1050       stCOMiCFG.hwndFrame = hwndFrame;
	mov	eax,dword ptr  hwndFrame
	mov	dword ptr  stCOMiCFG+06h,eax

; 1051       stCOMiCFG.hab = habAnchorBlock;
	mov	eax,dword ptr  habAnchorBlock
	mov	dword ptr  stCOMiCFG+02h,eax

; 1052       stCOMiCFG.pszDriverIniSpec = NULL;
	mov	dword ptr  stCOMiCFG+018h,0h

; 1054       stIOctl.hab = habAnchorBlock;
	mov	eax,dword ptr  habAnchorBlock
	mov	dword ptr  stIOctl,eax

; 1055       stIOctl.pszPortName = stCFG.szPortName;
	mov	dword ptr  stIOctl+04h,offset FLAT:stCFG+02h

; 1057       if (bRemoteClient)
	cmp	dword ptr  bRemoteClient,0h
	je	@BLBL118

; 1059         MenuItemEnable(hwndFrame,IDM_INSTALL,FALSE);
	push	0h
	push	07e6h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1060         stRemote.Length = sizeof(STARTDATA);
	mov	word ptr  stRemote,03ch

; 1061         stRemote.Related = SSF_RELATED_INDEPENDENT;
	mov	word ptr  stRemote+02h,0h

; 1062         stRemote.TraceOpt = SSF_TRACEOPT_NONE;
	mov	word ptr  stRemote+06h,0h

; 1063         stRemote.TermQ = 0;
	mov	dword ptr  stRemote+014h,0h

; 1064         stRemote.Environment = 0;
	mov	dword ptr  stRemote+018h,0h

; 1065         stRemote.InheritOpt = SSF_INHERTOPT_PARENT;
	mov	word ptr  stRemote+01ch,01h

; 1066         stRemote.SessionType = SSF_TYPE_DEFAULT;
	mov	word ptr  stRemote+01eh,0h

; 1067         stRemote.IconFile = 0;
	mov	dword ptr  stRemote+020h,0h

; 1068         stRemote.PgmHandle = 0;
	mov	dword ptr  stRemote+024h,0h

; 1069         stRemote.ObjectBuffer = 0;
	mov	dword ptr  stRemote+034h,0h

; 1070         stRemote.ObjectBuffLen = 0;
	mov	dword ptr  stRemote+038h,0h

; 1071         stRemote.PgmName = szNetRun;
	mov	dword ptr  stRemote+0ch,offset FLAT:szNetRun

; 1072         stRemote.PgmInputs = szNetRunParameters;
	mov	dword ptr  stRemote+010h,offset FLAT:szNetRunParameters

; 1073         stRemote.PgmControl = SSF_CONTROL_INVISIBLE;
	mov	word ptr  stRemote+028h,01h

; 1074         stRemote.FgBg = SSF_FGBG_BACK;
	mov	word ptr  stRemote+04h,01h

; 1075         rc = DosStartSession(&stRemote,&ulSessionID,&pidSession);
	push	offset FLAT:pidSession
	push	offset FLAT:ulSessionID
	push	offset FLAT:stRemote
	call	DosStartSession
	add	esp,0ch
	mov	[ebp-013ch],eax;	rc

; 1076         if ((chPipeDebug > '0') && (rc != NO_ERROR))
	mov	al,byte ptr  chPipeDebug
	cmp	al,030h
	jbe	@BLBL120
	cmp	dword ptr [ebp-013ch],0h;	rc
	je	@BLBL120

; 1078           switch (rc)
	mov	eax,[ebp-013ch];	rc
	jmp	@BLBL182
	align 04h
@BLBL183:

; 1081               ErrorNotify("Invalid Session ID, starting remote server");
	push	offset FLAT:@STAT2c
	call	ErrorNotify
	add	esp,04h

; 1082               break;
	jmp	@BLBL181
	align 04h
@BLBL184:

; 1084               ErrorNotify(szServerProgram);
	push	offset FLAT:szServerProgram
	call	ErrorNotify
	add	esp,04h

; 1085               break;
	jmp	@BLBL181
	align 04h
@BLBL185:

; 1087               ErrorNotify("Error starting remote server - Process not parent");
	push	offset FLAT:@STAT2d
	call	ErrorNotify
	add	esp,04h

; 1088               break;
	jmp	@BLBL181
	align 04h
@BLBL186:

; 1090               ErrorNotify("Retry Sub-Allocation, starting remote server");
	push	offset FLAT:@STAT2e
	call	ErrorNotify
	add	esp,04h

; 1091               break;
	jmp	@BLBL181
	align 04h
@BLBL187:

; 1093               sprintf(szMessage,"Unkown Error = %u - starting remote server",rc);
	push	dword ptr [ebp-013ch];	rc
	mov	edx,offset FLAT:@STAT2f
	lea	eax,[ebp-012ch];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1094               ErrorNotify(szMessage);
	lea	eax,[ebp-012ch];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1095               break;
	jmp	@BLBL181
	align 04h
	jmp	@BLBL181
	align 04h
@BLBL182:
	cmp	eax,0171h
	je	@BLBL183
	cmp	eax,01a2h
	je	@BLBL184
	cmp	eax,01cch
	je	@BLBL185
	cmp	eax,01cfh
	je	@BLBL186
	jmp	@BLBL187
	align 04h
@BLBL181:

; 1097           }

; 1098         }
	jmp	@BLBL120
	align 010h
@BLBL118:

; 1101         if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) != NO_ERROR)
	lea	eax,[ebp-0138h];	hMod
	push	eax
	push	offset FLAT:@STAT30
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	je	@BLBL121

; 1103           sprintf(szMessage,"Unable to load configuration library - %s",CONFIG_LIBRARY);
	push	offset FLAT:@STAT32
	mov	edx,offset FLAT:@STAT31
	lea	eax,[ebp-012ch];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1104           ErrorNotify(szMessage);
	lea	eax,[ebp-012ch];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1106           MenuItemEnable(hwndFrame,IDM_INSTALL,FALSE);
	push	0h
	push	07e6h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1107           }
	jmp	@BLBL120
	align 010h
@BLBL121:

; 1109           DosFreeModule(hMod);
	push	dword ptr [ebp-0138h];	hMod
	call	DosFreeModule
	add	esp,04h

; 1110         }
@BLBL120:

; 1111       if (hProfileInstance == NULL)
	cmp	dword ptr  hProfileInstance,0h
	jne	@BLBL123

; 1112         MenuItemEnable(hwndFrame,IDM_MANAGE_CFG,FALSE);
	push	0h
	push	0812h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
@BLBL123:

; 1114       if (!InitializeSystem())
	call	InitializeSystem
	test	eax,eax
	jne	@BLBL124

; 1116         hCom = -1;
	mov	dword ptr  hCom,0ffffffffh

; 1117         WinPostMsg(hwnd,WM_QUIT,0L,0L);
	push	0h
	push	0h
	push	02ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 1118         }
	jmp	@BLBL125
	align 010h
@BLBL124:

; 1120         if (tidIPCserverThread != 0)
	cmp	dword ptr  tidIPCserverThread,0h
	je	@BLBL125

; 1121           DosResumeThread(tidIPCserverThread);
	push	dword ptr  tidIPCserverThread
	call	DosResumeThread
	add	esp,04h
@BLBL125:

; 1122       if (stCFG.bStickyMenus)
	test	byte ptr  stCFG+016h,08h
	je	@BLBL127

; 1123         MenuItemCheck(hwndFrame,IDM_STICKY_MENUS,TRUE);
	push	01h
	push	081ah
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch
@BLBL127:

; 1125       break;
	jmp	@BLBL155
	align 04h
@BLBL188:

; 1127       MenuItemEnable(hwndFrame,IDM_SURFACE_ALL,TRUE);
	push	01h
	push	081dh
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1128       break;
	jmp	@BLBL155
	align 04h
@BLBL189:

; 1130       WinSetFocus(HWND_DESKTOP,hwndClient);
	push	dword ptr  hwndClient
	push	01h
	call	WinSetFocus
	add	esp,08h

; 1131       WinSendMsg(hwndStatDev,WM_ACTIVATE,0L,0L);
	push	0h
	push	0h
	push	0dh
	push	dword ptr  hwndStatDev
	call	WinSendMsg
	add	esp,010h

; 1132       WinSendMsg(hwndStatModemIn,WM_ACTIVATE,0L,0L);
	push	0h
	push	0h
	push	0dh
	push	dword ptr  hwndStatModemIn
	call	WinSendMsg
	add	esp,010h

; 1133       WinSendMsg(hwndStatModemOut,WM_ACTIVATE,0L,0L);
	push	0h
	push	0h
	push	0dh
	push	dword ptr  hwndStatModemOut
	call	WinSendMsg
	add	esp,010h

; 1134       WinSendMsg(hwndStatRcvBuf,WM_ACTIVATE,0L,0L);
	push	0h
	push	0h
	push	0dh
	push	dword ptr  hwndStatRcvBuf
	call	WinSendMsg
	add	esp,010h

; 1135       WinSendMsg(hwndStatXmitBuf,WM_ACTIVATE,0L,0L);
	push	0h
	push	0h
	push	0dh
	push	dword ptr  hwndStatXmitBuf
	call	WinSendMsg
	add	esp,010h

; 1136       break;
	jmp	@BLBL155
	align 04h
@BLBL190:

; 1138       if (mp1 == NULL)
	cmp	dword ptr [ebp+010h],0h;	mp1
	jne	@BLBL128

; 1140         KillDisplayThread();
	call	KillDisplayThread

; 1141         MenuItemCheck(hwndFrame,IDM_MSTREAM,FALSE);
	push	0h
	push	07d9h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 1142         MenuItemEnable(hwndFrame,IDM_MDISPLAY,FALSE);
	push	0h
	push	07e3h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1143         stCFG.bMonitoringStream = FALSE;
	and	byte ptr  stCFG+017h,0dfh

; 1144         sprintf(szMessage,"End of capture buffer\n%-ld characters stored\nMonitoring Aborted",stCFG.lBufferLength);
	push	dword ptr  stCFG+0d5h
	mov	edx,offset FLAT:@STAT33
	lea	eax,[ebp-012ch];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1145         WinMessageBox(HWND_DESKTOP,
	push	030h
	push	0h
	push	offset FLAT:stCFG+02h
	lea	eax,[ebp-012ch];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h

; 1152         }
	jmp	@BLBL129
	align 010h
@BLBL128:

; 1155         if (stCFG.bCaptureToFile)
	test	byte ptr  stCFG+016h,020h
	je	@BLBL130

; 1156           if (!WriteCaptureFile(szCaptureFileName,(WORD *)mp1,stCFG.lBufferLength,FOPEN_OVERWRITE,HLPP_MB_OVERWRT_CAP_FILE))
	push	09ca9h
	push	01h
	mov	eax,dword ptr  stCFG+0d5h
	push	eax
	push	dword ptr [ebp+010h];	mp1
	push	offset FLAT:szCaptureFileName
	call	WriteCaptureFile
	add	esp,014h
	test	eax,eax
	jne	@BLBL131

; 1158             KillDisplayThread();
	call	KillDisplayThread

; 1159             KillMonitorThread();
	call	KillMonitorThread

; 1160             stCFG.bMonitoringStream = FALSE;
	and	byte ptr  stCFG+017h,0dfh

; 1161             DosDelete(szCaptureFileName);
	push	offset FLAT:szCaptureFileName
	call	DosDelete
	add	esp,04h

; 1162             }
	jmp	@BLBL130
	align 010h
@BLBL131:

; 1165             bCaptureFileWritten = TRUE;
	mov	dword ptr  bCaptureFileWritten,01h

; 1166             IncrementFileExt(szCaptureFileName,FALSE);
	push	0h
	push	offset FLAT:szCaptureFileName
	call	IncrementFileExt
	add	esp,08h

; 1167             }
@BLBL130:

; 1168         DosFreeMem(mp1);
	push	dword ptr [ebp+010h];	mp1
	call	DosFreeMem
	add	esp,04h

; 1169         }
@BLBL129:

; 1170       break;
	jmp	@BLBL155
	align 04h
@BLBL191:

; 1172       MenuItemEnable(hwndFrame,IDM_LOADDAT,FALSE);
	push	0h
	push	07d3h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1173       MenuItemEnable(hwndFrame,IDM_SAVEDAT,FALSE);
	push	0h
	push	07d4h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1174       MenuItemEnable(hwndFrame,IDM_SAVEDATAS,FALSE);
	push	0h
	push	07d7h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1175       MenuItemCheck(hwndFrame,IDM_MSTREAM,TRUE);
	push	01h
	push	07d9h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 1176       MenuItemEnable(hwndFrame,IDM_MDISPLAY,TRUE);
	push	01h
	push	07e3h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1177       MenuItemEnable(hwndFrame,IDM_VIEWDAT,FALSE);
	push	0h
	push	07d6h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1178       MenuItemCheck(hwndFrame,IDM_VIEWDAT,FALSE);
	push	0h
	push	07d6h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 1179       if (stCFG.bShowCounts || stCFG.bSampleCounts)
	test	byte ptr  stCFG+016h,010h
	jne	@BLBL133
	test	byte ptr  stCFG+018h,010h
	je	@BLBL134
@BLBL133:

; 1181         WinSendMsg(hwndStatus,WM_TIMER,0,0);
	push	0h
	push	0h
	push	024h
	push	dword ptr  hwndStatus
	call	WinSendMsg
	add	esp,010h

; 1182         WinPostMsg(hwndStatus,UM_STARTTIMER,0L,0L);
	push	0h
	push	0h
	push	0801ah
	push	dword ptr  hwndStatus
	call	WinPostMsg
	add	esp,010h

; 1183         }
	jmp	@BLBL135
	align 010h
@BLBL134:

; 1185         WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch
@BLBL135:

; 1186       break;
	jmp	@BLBL155
	align 04h
@BLBL192:

; 1188       if (!stCFG.bCaptureToFile && bDataToView)
	test	byte ptr  stCFG+016h,020h
	jne	@BLBL136
	cmp	dword ptr  bDataToView,0h
	je	@BLBL136

; 1190         MenuItemEnable(hwndFrame,IDM_SAVEDAT,TRUE);
	push	01h
	push	07d4h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1191         MenuItemEnable(hwndFrame,IDM_SAVEDATAS,TRUE);
	push	01h
	push	07d7h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1192         }
@BLBL136:

; 1193       MenuItemEnable(hwndFrame,IDM_LOADDAT,TRUE);
	push	01h
	push	07d3h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1194       MenuItemCheck(hwndFrame,IDM_MSTREAM,FALSE);
	push	0h
	push	07d9h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 1195       MenuItemEnable(hwndFrame,IDM_MDISPLAY,FALSE);
	push	0h
	push	07e3h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1196       WinPostMsg(hwndStatus,UM_STOPTIMER,0L,0L);
	push	0h
	push	0h
	push	08019h
	push	dword ptr  hwndStatus
	call	WinPostMsg
	add	esp,010h

; 1197       WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 1198       break;
	jmp	@BLBL155
	align 04h
@BLBL193:

; 1200       MenuItemEnable(hwndFrame,IDM_VIEWDAT,TRUE);
	push	01h
	push	07d6h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1201       break;
	jmp	@BLBL155
	align 04h
@BLBL194:

; 1203       GpiDestroyPS(hpsPs);
	push	dword ptr  hpsPs
	call	GpiDestroyPS
	add	esp,04h

; 1204       break;
	jmp	@BLBL155
	align 04h
@BLBL195:

; 1206       bExternalKill = TRUE;
	mov	dword ptr  bExternalKill,01h
@BLBL196:
@BLBL197:

; 1224       KillDisplayThread();
	call	KillDisplayThread

; 1225       KillMonitorThread();
	call	KillMonitorThread

; 1227       if (hProfileInstance != NULL)
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL137

; 1229         if (stCFG.bLoadMonitor)
	test	byte ptr  stCFG+017h,080h
	je	@BLBL138

; 1231           if (stCFG.fDisplaying & DISP_FILE)
	mov	al,byte ptr  stCFG+01bh
	and	eax,01fh
	shr	eax,02h
	test	al,04h
	je	@BLBL138

; 1233             stCFG.lReadColScrollIndex = stRead.lScrollIndex;
	mov	eax,dword ptr  stRead+06fh
	mov	dword ptr  stCFG+027h,eax

; 1234             stCFG.lWriteColScrollIndex = stWrite.lScrollIndex;
	mov	eax,dword ptr  stWrite+06fh
	mov	dword ptr  stCFG+02bh,eax

; 1235             stCFG.lRowScrollIndex = stRow.lScrollIndex;
	mov	eax,dword ptr  stRow+06fh
	mov	dword ptr  stCFG+023h,eax

; 1236             }

; 1237           }
@BLBL138:

; 1238         SaveWindowPositions();
	call	SaveWindowPositions

; 1239         if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-0138h];	hMod
	push	eax
	push	offset FLAT:@STAT34
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL137

; 1241           if (DosQueryProcAddr(hMod,0,"SaveProfileData",(PFN *)&pfnSaveProfileData) == NO_ERROR)
	push	offset FLAT:pfnSaveProfileData
	push	offset FLAT:@STAT35
	push	0h
	push	dword ptr [ebp-0138h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL141

; 1242             pfnSaveProfileData(hProfileInstance,"Search String",(BYTE *)swSearchString,(lSearchStrLen * 2));
	mov	eax,dword ptr  lSearchStrLen
	add	eax,eax
	push	eax
	push	offset FLAT:swSearchString
	push	offset FLAT:@STAT36
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnSaveProfileData
	add	esp,010h
@BLBL141:

; 1243           if (stCFG.bAutoSaveConfig && stCFG.bCaptureToFile && (szCaptureFileName[0] != 0))
	test	byte ptr  stCFG+018h,01h
	je	@BLBL142
	test	byte ptr  stCFG+016h,020h
	je	@BLBL142
	cmp	byte ptr  szCaptureFileName,0h
	je	@BLBL142

; 1244             if (DosQueryProcAddr(hMod,0,"SaveProfileString",(PFN *)&pfnSaveProfileString) == NO_ERROR)
	push	offset FLAT:pfnSaveProfileString
	push	offset FLAT:@STAT37
	push	0h
	push	dword ptr [ebp-0138h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL142

; 1245               pfnSaveProfileString(hProfileInstance,"Capture File",szCaptureFileName);
	push	offset FLAT:szCaptureFileName
	push	offset FLAT:@STAT38
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnSaveProfileString
	add	esp,0ch
@BLBL142:

; 1246           if (DosQueryProcAddr(hMod,0,"CloseProfile",(PFN *)&pfnCloseProfile) == NO_ERROR)
	push	offset FLAT:pfnCloseProfile
	push	offset FLAT:@STAT39
	push	0h
	push	dword ptr [ebp-0138h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL144

; 1247             hProfileInstance = pfnCloseProfile(hProfileInstance);
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnCloseProfile
	add	esp,04h
	mov	dword ptr  hProfileInstance,eax
@BLBL144:

; 1248           DosFreeModule(hMod);
	push	dword ptr [ebp-0138h];	hMod
	call	DosFreeModule
	add	esp,04h

; 1249           }

; 1250         }
@BLBL137:

; 1251       if (bRemoteAccess)
	cmp	dword ptr  bRemoteAccess,0h
	je	@BLBL145

; 1253         if (bRemoteClient)
	cmp	dword ptr  bRemoteClient,0h
	je	@BLBL146

; 1255           stPipeCmd.cbMsgSize = sizeof(PIPECMD);
	mov	word ptr  stPipeCmd,0ah

; 1256           stPipeCmd.ulCommand = UM_PIPE_QUIT;
	mov	dword ptr  stPipeCmd+02h,0801eh

; 1257           rc = DosCallNPipe(szCOMscopePipe,&stPipeCmd,sizeof(PIPECMD),&stPipeCmd,sizeof(PIPECMD),&ulBytesRead,10000);
	push	02710h
	push	offset FLAT:ulBytesRead
	push	0ah
	push	offset FLAT:stPipeCmd
	push	0ah
	push	offset FLAT:stPipeCmd
	push	offset FLAT:szCOMscopePipe
	call	DosCallNPipe
	add	esp,01ch
	mov	[ebp-013ch],eax;	rc

; 1258           }
@BLBL146:

; 1260         if (bRemoteServer)
	cmp	dword ptr  bRemoteServer,0h
	je	@BLBL148

; 1261           bStopRemotePipe = TRUE;
	mov	dword ptr  bStopRemotePipe,01h

; 1262         }
	jmp	@BLBL148
	align 010h
@BLBL145:

; 1265         if (bLaunchShutdownServer)
	cmp	dword ptr  bLaunchShutdownServer,0h
	je	@BLBL148

; 1267           bStopIPCserverThread = TRUE;
	mov	dword ptr  bStopIPCserverThread,01h

; 1268           DosSleep(10);
	push	0ah
	call	DosSleep
	add	esp,04h

; 1269           if (!bExternalKill)
	cmp	dword ptr  bExternalKill,0h
	jne	@BLBL148

; 1271             bExternalKill = TRUE;
	mov	dword ptr  bExternalKill,01h

; 1272             DosRequestMutexSem(hmtxIPCpipeBlockedSem,10000);
	push	02710h
	push	dword ptr  hmtxIPCpipeBlockedSem
	call	DosRequestMutexSem
	add	esp,08h

; 1273             stIPCpipe.ulInstance = ulIPCpipeInstance;
	mov	eax,dword ptr  ulIPCpipeInstance
	mov	dword ptr  stIPCpipe+06h,eax

; 1274             stIPCpipe.ulMessage = UM_PIPE_END;
	mov	dword ptr  stIPCpipe+02h,08020h

; 1275             while ((rc = DosCallNPipe(szIPCpipe,&stIPCpipe,sizeof(IPCPIPEMSG),&stIPCpipe,sizeof(IPCPIPEMSG),&ulBytesRead,10000)) == ERROR_PIPE_BUSY)
	push	02710h
	push	offset FLAT:ulBytesRead
	push	0ah
	push	offset FLAT:stIPCpipe
	push	0ah
	push	offset FLAT:stIPCpipe
	push	offset FLAT:szIPCpipe
	call	DosCallNPipe
	add	esp,01ch
	mov	[ebp-013ch],eax;	rc
	cmp	dword ptr [ebp-013ch],0e7h;	rc
	jne	@BLBL151
	align 010h
@BLBL152:

; 1276               if (chPipeDebug > '0')
	mov	al,byte ptr  chPipeDebug
	cmp	al,030h
	jbe	@BLBL153

; 1277                 ErrorNotify("Pipe busy, sending process end message.");
	push	offset FLAT:@STAT3a
	call	ErrorNotify
	add	esp,04h
@BLBL153:

; 1275             while ((rc = DosCallNPipe(szIPCpipe,&stIPCpipe,sizeof(IPCPIPEMSG),&stIPCpipe,sizeof(IPCPIPEMSG),&ulBytesRead,10000)) == ERROR_PIPE_BUSY)
	push	02710h
	push	offset FLAT:ulBytesRead
	push	0ah
	push	offset FLAT:stIPCpipe
	push	0ah
	push	offset FLAT:stIPCpipe
	push	offset FLAT:szIPCpipe
	call	DosCallNPipe
	add	esp,01ch
	mov	[ebp-013ch],eax;	rc
	cmp	dword ptr [ebp-013ch],0e7h;	rc
	je	@BLBL152
@BLBL151:

; 1278             DosReleaseMutexSem(hmtxIPCpipeBlockedSem);
	push	dword ptr  hmtxIPCpipeBlockedSem
	call	DosReleaseMutexSem
	add	esp,04h

; 1279             }

; 1280           }

; 1281         }
@BLBL148:

; 1282       WinPostMsg(hwnd,WM_QUIT,0L,0L);
	push	0h
	push	0h
	push	02ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 1283       break;
	jmp	@BLBL155
	align 04h
@BLBL198:

; 1285       return WinDefWindowProc(hwnd,msg,mp1,mp2);
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefWindowProc
	add	esp,010h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL155
	align 04h
@BLBL156:
	cmp	eax,01h
	je	@BLBL157
	cmp	eax,02dh
	je	@BLBL158
	cmp	eax,0dh
	je	@BLBL159
	cmp	eax,022h
	je	@BLBL160
	cmp	eax,0230h
	je	@BLBL161
	cmp	eax,0fa00h
	je	@BLBL162
	cmp	eax,020h
	je	@BLBL163
	cmp	eax,046h
	je	@BLBL164
	cmp	eax,031h
	je	@BLBL165
	cmp	eax,071h
	je	@BLBL174
	cmp	eax,074h
	je	@BLBL175
	cmp	eax,023h
	je	@BLBL176
	cmp	eax,07ah
	je	@BLBL177
	cmp	eax,07h
	je	@BLBL178
	cmp	eax,04fh
	je	@BLBL179
	cmp	eax,08000h
	je	@BLBL180
	cmp	eax,08025h
	je	@BLBL188
	cmp	eax,08024h
	je	@BLBL189
	cmp	eax,0800bh
	je	@BLBL190
	cmp	eax,08017h
	je	@BLBL191
	cmp	eax,0800dh
	je	@BLBL192
	cmp	eax,0800ah
	je	@BLBL193
	cmp	eax,02h
	je	@BLBL194
	cmp	eax,0801eh
	je	@BLBL195
	cmp	eax,029h
	je	@BLBL196
	cmp	eax,03eh
	je	@BLBL197
	jmp	@BLBL198
	align 04h
@BLBL155:

; 1287   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpClient	endp

; 1291   {
	align 010h

	public RowPaint
RowPaint	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08ch
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,023h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 1306   BOOL bDisplayCharacter = TRUE;
	mov	dword ptr [ebp-088h],01h;	bDisplayCharacter

; 1307   BOOL bDisplaySignal = FALSE;
	mov	dword ptr [ebp-08ch],0h;	bDisplaySignal

; 1308   static BOOL bLastWasOverflow = FALSE;
; 1309 
; 1310   if ((rc = DosRequestMutexSem(hmtxRowGioBlockedSem,-1)) != NO_ERROR)
	push	0ffffffffh
	push	dword ptr  hmtxRowGioBlockedSem
	call	DosRequestMutexSem
	add	esp,08h
	mov	[ebp-030h],eax;	rc
	cmp	dword ptr [ebp-030h],0h;	rc
	je	@BLBL199

; 1311     {
; 1312     sprintf(szMessage,"DosRequestMutexSem error in RowPaint: return code = %ld", rc);
	push	dword ptr [ebp-030h];	rc
	mov	edx,offset FLAT:@STAT3b
	lea	eax,[ebp-080h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1313     ErrorNotify(szMessage);
	lea	eax,[ebp-080h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1314     }
@BLBL199:

; 1315   WinInvalidateRect(hwnd,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinInvalidateRect
	add	esp,0ch

; 1316   hps = WinBeginPaint(hwnd,(HPS)NULL,&rclRect);
	lea	eax,[ebp-014h];	rclRect
	push	eax
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinBeginPaint
	add	esp,0ch
	mov	[ebp-04h],eax;	hps

; 1317   if (WinIsWindowShowing(hwnd))
	push	dword ptr [ebp+08h];	hwnd
	call	WinIsWindowShowing
	add	esp,04h
	test	eax,eax
	je	@BLBL200

; 1318     {
; 1319     if (!stCFG.bColumnDisplay && !bNoPaint)
	test	byte ptr  stCFG+018h,080h
	jne	@BLBL200
	cmp	dword ptr  bNoPaint,0h
	jne	@BLBL200

; 1320       {
; 1321       rclRect.yBottom = stRow.lHeight;
	mov	eax,dword ptr  stRow+02fh
	mov	[ebp-010h],eax;	rclRect

; 1322       rclRect.yTop = stRow.lHeight + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+02fh
	mov	[ebp-08h],eax;	rclRect

; 1323       rclRect.xLeft = 0;
	mov	dword ptr [ebp-014h],0h;	rclRect

; 1324       rclRect.xRight = (stRow.lWidth + stCell.cx + 2);
	movsx	eax,word ptr  stCell
	add	eax,dword ptr  stRow+033h
	add	eax,02h
	mov	[ebp-0ch],eax;	rclRect

; 1325       while (rclRect.yBottom > lStatusHeight)
	mov	eax,dword ptr  lStatusHeight
	cmp	[ebp-010h],eax;	rclRect
	jle	@BLBL202
	align 010h
@BLBL203:

; 1326         {
; 1327         WinFillRect(hps,&rclRect,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	lea	eax,[ebp-014h];	rclRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 1328         rclRect.yBottom -= stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,[ebp-010h];	rclRect
	sub	eax,ecx
	mov	[ebp-010h],eax;	rclRect

; 1329         if (rclRect.yBottom <= (lStatusHeight + 2))
	mov	eax,dword ptr  lStatusHeight
	add	eax,02h
	cmp	[ebp-010h],eax;	rclRect
	jg	@BLBL204

; 1330           rclRect.yBottom -= 4;        // make sure bottom row overlaps status area
	mov	eax,[ebp-010h];	rclRect
	sub	eax,04h
	mov	[ebp-010h],eax;	rclRect
@BLBL204:

; 1331         rclRect.yTop -= stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,[ebp-08h];	rclRect
	sub	eax,ecx
	mov	[ebp-08h],eax;	rclRect

; 1332         WinFillRect(hps,&rclRect,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	lea	eax,[ebp-014h];	rclRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 1333         rclRect.yBottom -= stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,[ebp-010h];	rclRect
	sub	eax,ecx
	mov	[ebp-010h],eax;	rclRect

; 1334         rclRect.yTop -= stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,[ebp-08h];	rclRect
	sub	eax,ecx
	mov	[ebp-08h],eax;	rclRect

; 1335         }

; 1325       while (rclRect.yBottom > lStatusHeight)
	mov	eax,dword ptr  lStatusHeight
	cmp	[ebp-010h],eax;	rclRect
	jg	@BLBL203
@BLBL202:

; 1336       if (stCFG.bMonitoringStream)
	test	byte ptr  stCFG+017h,020h
	je	@BLBL206

; 1338         wLastDirection = CS_READ;
	mov	word ptr  @1b7wLastDirection,04000h

; 1339         stRow.lCursorReadRow = stRow.lHeight;
	mov	eax,dword ptr  stRow+02fh
	mov	dword ptr  stRow+057h,eax

; 1340         stRow.lCursorWriteRow = stRow.lCursorReadRow - stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRow+057h
	sub	eax,ecx
	mov	dword ptr  stRow+05bh,eax

; 1341         stRow.lLeadReadRow = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	dword ptr  stRow+07bh,eax

; 1342         stRow.lLeadWriteRow = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	dword ptr  stRow+077h,eax

; 1343         stRow.Pos.x= 0;
	mov	dword ptr  stRow+04fh,0h

; 1344         }
	jmp	@BLBL200
	align 010h
@BLBL206:

; 1347         if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
	mov	al,byte ptr  stCFG+01bh
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL200

; 1349           lIndex = stRow.lScrollIndex;
	mov	eax,dword ptr  stRow+06fh
	mov	[ebp-018h],eax;	lIndex

; 1350           lReadRow = stRow.lHeight;
	mov	eax,dword ptr  stRow+02fh
	mov	[ebp-020h],eax;	lReadRow

; 1351           lWriteRow = lReadRow - stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,[ebp-020h];	lReadRow
	sub	eax,ecx
	mov	[ebp-01ch],eax;	lWriteRow

; 1352           lCount = lScrollCount;
	mov	eax,dword ptr  lScrollCount
	mov	[ebp-028h],eax;	lCount

; 1353           lSaveCount = lCount;
	mov	eax,[ebp-028h];	lCount
	mov	[ebp-02ch],eax;	lSaveCount

; 1354           GpiCreateLogFont(hps,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0d9h
	imul	eax,038h
	add	eax,offset FLAT:astFontAttributes
	push	eax
	push	02h
	push	offset FLAT:@STAT3c
	push	dword ptr [ebp-04h];	hps
	call	GpiCreateLogFont
	add	esp,010h

; 1358           GpiSetCharSet(hps,2);
	push	02h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetCharSet
	add	esp,08h

; 1359           GpiSetBackMix(hps,BM_OVERPAINT);
	push	02h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackMix
	add	esp,08h

; 1360           lCol = 0;
	mov	dword ptr [ebp-024h],0h;	lCol

; 1361           wLastDirection = CS_READ;
	mov	word ptr  @1b7wLastDirection,04000h

; 1362           while (1)
	align 010h
@BLBL210:

; 1364             if (lIndex == lCount)
	mov	eax,[ebp-028h];	lCount
	cmp	[ebp-018h],eax;	lIndex
	je	@BLBL200

; 1366             wChar = pwScrollBuffer[lIndex];
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-018h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	mov	[ebp-082h],ax;	wChar

; 1367             wDirection = (wChar & 0xff00);
	mov	ax,[ebp-082h];	wChar
	and	ax,0ff00h
	mov	[ebp-084h],ax;	wDirection

; 1373             if (wDirection != CS_READ_BUFF_OVERFLOW)
	cmp	word ptr [ebp-084h],04500h;	wDirection
	je	@BLBL213

; 1374               bLastWasOverflow = FALSE;
	mov	dword ptr  @1babLastWasOverflow,0h
@BLBL213:

; 1375             switch (wDirection)
	xor	eax,eax
	mov	ax,[ebp-084h];	wDirection
	jmp	@BLBL304
	align 04h
@BLBL305:

; 1378                 lIndex += (wChar & 0xff);
	xor	eax,eax
	mov	ax,[ebp-082h];	wChar
	and	eax,0ffh
	add	eax,[ebp-018h];	lIndex
	mov	[ebp-018h],eax;	lIndex

; 1379                 bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter

; 1380                 break;
	jmp	@BLBL303
	align 04h
@BLBL306:

; 1382                 if (stCFG.bDispRead)
	test	byte ptr  stCFG+01bh,040h
	je	@BLBL214

; 1384                   stPos.y = lReadRow;
	mov	eax,[ebp-020h];	lReadRow
	mov	dword ptr  @1adstPos+04h,eax

; 1385                   GpiSetBackColor(hps,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1386                   GpiSetColor(hps,stCFG.lReadForegrndColor);
	push	dword ptr  stCFG+0a9h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1387                   }
	jmp	@BLBL215
	align 010h
@BLBL214:

; 1389                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL215:

; 1390                 break;
	jmp	@BLBL303
	align 04h
@BLBL307:

; 1392                 if (stCFG.bDispWrite)
	test	byte ptr  stCFG+01bh,020h
	je	@BLBL216

; 1394                   stPos.y = lWriteRow;
	mov	eax,[ebp-01ch];	lWriteRow
	mov	dword ptr  @1adstPos+04h,eax

; 1395                   GpiSetBackColor(hps,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1396                   GpiSetColor(hps,stCFG.lWriteForegrndColor);
	push	dword ptr  stCFG+0b1h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1397                   }
	jmp	@BLBL217
	align 010h
@BLBL216:

; 1399                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL217:

; 1400                 break;
	jmp	@BLBL303
	align 04h
@BLBL308:

; 1402                 if (stCFG.bDispIMM)
	test	byte ptr  stCFG+01bh,080h
	je	@BLBL218

; 1404                   wDirection = CS_WRITE;
	mov	word ptr [ebp-084h],08000h;	wDirection

; 1405                   stPos.y = lWriteRow;
	mov	eax,[ebp-01ch];	lWriteRow
	mov	dword ptr  @1adstPos+04h,eax

; 1406                   if (stCFG.bHiLightImmediateByte)
	test	byte ptr  stCFG+018h,08h
	je	@BLBL219

; 1408                     GpiSetBackColor(hps,stCFG.lWriteForegrndColor);
	push	dword ptr  stCFG+0b1h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1409                     GpiSetColor(hps,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1410                     }
	jmp	@BLBL221
	align 010h
@BLBL219:

; 1413                     GpiSetBackColor(hps,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1414                     GpiSetColor(hps,stCFG.lWriteForegrndColor);
	push	dword ptr  stCFG+0b1h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1415                     }

; 1416                   }
	jmp	@BLBL221
	align 010h
@BLBL218:

; 1418                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL221:

; 1419                 break;
	jmp	@BLBL303
	align 04h
@BLBL309:

; 1421                 if (stCFG.bDispIMM)
	test	byte ptr  stCFG+01bh,080h
	je	@BLBL222

; 1423                   wDirection = CS_READ;
	mov	word ptr [ebp-084h],04000h;	wDirection

; 1424                   stPos.y = lReadRow;
	mov	eax,[ebp-020h];	lReadRow
	mov	dword ptr  @1adstPos+04h,eax

; 1425                   if (stCFG.bHiLightImmediateByte)
	test	byte ptr  stCFG+018h,08h
	je	@BLBL223

; 1427                     GpiSetBackColor(hps,stCFG.lReadForegrndColor);
	push	dword ptr  stCFG+0a9h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1428                     GpiSetColor(hps,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1429                     }
	jmp	@BLBL225
	align 010h
@BLBL223:

; 1432                     GpiSetBackColor(hps,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1433                     GpiSetColor(hps,stCFG.lReadForegrndColor);
	push	dword ptr  stCFG+0a9h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1434                     }

; 1435                   }
	jmp	@BLBL225
	align 010h
@BLBL222:

; 1437                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL225:

; 1438                 break;
	jmp	@BLBL303
	align 04h
@BLBL310:

; 1440                
; 1440  if (stCFG.bDispModemIn)
	test	byte ptr  stCFG+01ch,01h
	je	@BLBL226

; 1442                   bDisplaySignal = TRUE;
	mov	dword ptr [ebp-08ch],01h;	bDisplaySignal

; 1443                   stPos.y = lReadRow;
	mov	eax,[ebp-020h];	lReadRow
	mov	dword ptr  @1adstPos+04h,eax

; 1444                   GpiSetBackColor(hps,stCFG.lModemInBackgrndColor);
	push	dword ptr  stCFG+075h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1445                   GpiSetColor(hps,stCFG.lModemInForegrndColor);
	push	dword ptr  stCFG+079h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1446                   if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL230

; 1448                     wChar &= 0xf0;
	mov	ax,[ebp-082h];	wChar
	and	ax,0f0h
	mov	[ebp-082h],ax;	wChar

; 1449                     wChar >>= 4;
	mov	ax,[ebp-082h];	wChar
	shr	ax,04h
	mov	[ebp-082h],ax;	wChar

; 1450                     if (wChar < 10)
	mov	ax,[ebp-082h];	wChar
	cmp	ax,0ah
	jae	@BLBL228

; 1451                       wChar += '0';
	mov	ax,[ebp-082h];	wChar
	add	ax,030h
	mov	[ebp-082h],ax;	wChar
	jmp	@BLBL230
	align 010h
@BLBL228:

; 1453                       wChar += ('A' - 10);
	mov	ax,[ebp-082h];	wChar
	add	ax,037h
	mov	[ebp-082h],ax;	wChar

; 1454                     }

; 1455                   }
	jmp	@BLBL230
	align 010h
@BLBL226:

; 1457                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL230:

; 1458                 break;
	jmp	@BLBL303
	align 04h
@BLBL311:

; 1460                 if (stCFG.bDispModemOut)
	test	byte ptr  stCFG+01ch,02h
	je	@BLBL231

; 1462                   bDisplaySignal = TRUE;
	mov	dword ptr [ebp-08ch],01h;	bDisplaySignal

; 1463                   stPos.y = lWriteRow;
	mov	eax,[ebp-01ch];	lWriteRow
	mov	dword ptr  @1adstPos+04h,eax

; 1464                   GpiSetBackColor(hps,stCFG.lModemOutBackgrndColor);
	push	dword ptr  stCFG+06dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1465                   GpiSetColor(hps,stCFG.lModemOutForegrndColor);
	push	dword ptr  stCFG+071h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1466                   wChar &= 0x03;
	mov	ax,[ebp-082h];	wChar
	and	ax,03h
	mov	[ebp-082h],ax;	wChar

; 1467                   if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL233

; 1468                     wChar += '0';
	mov	ax,[ebp-082h];	wChar
	add	ax,030h
	mov	[ebp-082h],ax;	wChar

; 1469                   }
	jmp	@BLBL233
	align 010h
@BLBL231:

; 1471                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL233:

; 1472                 break;
	jmp	@BLBL303
	align 04h
@BLBL312:

; 1474                 if (stCFG.bDispDevIOctl)
	test	byte ptr  stCFG+01ch,020h
	je	@BLBL234

; 1476                   bDisplaySignal = TRUE;
	mov	dword ptr [ebp-08ch],01h;	bDisplaySignal

; 1477                   stPos.y = lWriteRow;
	mov	eax,[ebp-01ch];	lWriteRow
	mov	dword ptr  @1adstPos+04h,eax

; 1478                   GpiSetBackColor(hps,stCFG.lDevIOctlBackgrndColor);
	push	dword ptr  stCFG+09dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1479                   GpiSetColor(hps,stCFG.lDevIOctlForegrndColor);
	push	dword ptr  stCFG+0a1h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1480                   if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL236

; 1481                     wChar = 'F';
	mov	word ptr [ebp-082h],046h;	wChar

; 1482                   }
	jmp	@BLBL236
	align 010h
@BLBL234:

; 1484                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL236:

; 1485                 break;
	jmp	@BLBL303
	align 04h
@BLBL313:

; 1487                 if (stCFG.bDispErrors)
	test	byte ptr  stCFG+01ch,040h
	je	@BLBL237

; 1489                   bDisplaySignal = TRUE;
	mov	dword ptr [ebp-08ch],01h;	bDisplaySignal

; 1490                   stPos.y = lReadRow;
	mov	eax,[ebp-020h];	lReadRow
	mov	dword ptr  @1adstPos+04h,eax

; 1491                   GpiSetBackColor(hps,stCFG.lErrorBackgrndColor);
	push	dword ptr  stCFG+085h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1492                   GpiSetColor(hps,stCFG.lErrorForegrndColor);
	push	dword ptr  stCFG+089h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1493                   if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL238

; 1494                     wChar = 'E';
	mov	word ptr [ebp-082h],045h;	wChar
	jmp	@BLBL240
	align 010h
@BLBL238:

; 1496                     wChar &= 0x1e;
	mov	ax,[ebp-082h];	wChar
	and	ax,01eh
	mov	[ebp-082h],ax;	wChar

; 1497                   }
	jmp	@BLBL240
	align 010h
@BLBL237:

; 1499                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL240:

; 1500                 break;
	jmp	@BLBL303
	align 04h
@BLBL314:

; 1502                 if (stCFG.bDispErrors)
	test	byte ptr  stCFG+01ch,040h
	je	@BLBL241

; 1504                   if (!bLastWasOverflow)
	cmp	dword ptr  @1babLastWasOverflow,0h
	jne	@BLBL242

; 1506                     bDisplaySignal = TRUE;
	mov	dword ptr [ebp-08ch],01h;	bDisplaySignal

; 1507                     bLastWasOverflow = TRUE;
	mov	dword ptr  @1babLastWasOverflow,01h

; 1508                     stPos.y = lReadRow;
	mov	eax,[ebp-020h];	lReadRow
	mov	dword ptr  @1adstPos+04h,eax

; 1509                     GpiSetBackColor(hps,stCFG.lErrorBackgrndColor);
	push	dword ptr  stCFG+085h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1510                     GpiSetColor(hps,stCFG.lErrorForegrndColor);
	push	dword ptr  stCFG+089h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1511                     if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL243

; 1512                       wChar = 'V';
	mov	word ptr [ebp-082h],056h;	wChar
	jmp	@BLBL246
	align 010h
@BLBL243:

; 1514                       wChar = 0xff;
	mov	word ptr [ebp-082h],0ffh;	wChar

; 1515                     }
	jmp	@BLBL246
	align 010h
@BLBL242:

; 1517                     bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter

; 1518                   }
	jmp	@BLBL246
	align 010h
@BLBL241:

; 1520                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL246:

; 1521                 break;
	jmp	@BLBL303
	align 04h
@BLBL315:

; 1523                 if (stCFG.bDispErrors)
	test	byte ptr  stCFG+01ch,040h
	je	@BLBL247

; 1525                   bDisplaySignal = TRUE;
	mov	dword ptr [ebp-08ch],01h;	bDisplaySignal

; 1526                   stPos.y = lReadRow;
	mov	eax,[ebp-020h];	lReadRow
	mov	dword ptr  @1adstPos+04h,eax

; 1527                   GpiSetBackColor(hps,stCFG.lErrorBackgrndColor);
	push	dword ptr  stCFG+085h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1528                   GpiSetColor(hps,stCFG.lErrorForegrndColor);
	push	dword ptr  stCFG+089h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1529                   if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL248

; 1530                     wChar = 'B';
	mov	word ptr [ebp-082h],042h;	wChar
	jmp	@BLBL250
	align 010h
@BLBL248:

; 1532                     wChar = 0xBB;
	mov	word ptr [ebp-082h],0bbh;	wChar

; 1533                   }
	jmp	@BLBL250
	align 010h
@BLBL247:

; 1535                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL250:

; 1536                 break;
	jmp	@BLBL303
	align 04h
@BLBL316:

; 1538                 if (stCFG.bDispModemOut)
	test	byte ptr  stCFG+01ch,02h
	je	@BLBL251

; 1540                   bDisplaySignal = TRUE;
	mov	dword ptr [ebp-08ch],01h;	bDisplaySignal

; 1541                   stPos.y = lWriteRow;
	mov	eax,[ebp-01ch];	lWriteRow
	mov	dword ptr  @1adstPos+04h,eax

; 1542                   GpiSetBackColor(hps,stCFG.lModemOutBackgrndColor);
	push	dword ptr  stCFG+06dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1543                   GpiSetColor(hps,stCFG.lModemOutForegrndColor);
	push	dword ptr  stCFG+071h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1544                   if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL252

; 1545                     if (wChar & LINE_CTL_SEND_BREAK)
	test	byte ptr [ebp-082h],040h;	wChar
	je	@BLBL253

; 1546                       wChar = 'B';
	mov	word ptr [ebp-082h],042h;	wChar
	jmp	@BLBL258
	align 010h
@BLBL253:

; 1548                       wChar = 'b';
	mov	word ptr [ebp-082h],062h;	wChar
	jmp	@BLBL258
	align 010h
@BLBL252:

; 1550                     if (wChar & LINE_CTL_SEND_BREAK)
	test	byte ptr [ebp-082h],040h;	wChar
	je	@BLBL256

; 1551                       wChar = 0xB1;
	mov	word ptr [ebp-082h],0b1h;	wChar
	jmp	@BLBL258
	align 010h
@BLBL256:

; 1553                       wChar = 0xB0;
	mov	word ptr [ebp-082h],0b0h;	wChar

; 1554                   }
	jmp	@BLBL258
	align 010h
@BLBL251:

; 1556                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL258:

; 1557                 break;
	jmp	@BLBL303
	align 04h
@BLBL317:

; 1559                 if (stCFG.bDispWriteReq)
	test	byte ptr  stCFG+01ch,08h
	je	@BLBL259

; 1561                   bDisplaySignal = TRUE;
	mov	dword ptr [ebp-08ch],01h;	bDisplaySignal

; 1562                   stPos.y = lWriteRow;
	mov	eax,[ebp-01ch];	lWriteRow
	mov	dword ptr  @1adstPos+04h,eax

; 1563                   GpiSetBackColor(hps,stCFG.lWriteReqBackgrndColor);
	push	dword ptr  stCFG+095h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1564                   GpiSetColor(hps,stCFG.lWriteReqForegrndColor);
	push	dword ptr  stCFG+099h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1565                   if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL260

; 1566                     wChar = 'W';
	mov	word ptr [ebp-082h],057h;	wChar
	jmp	@BLBL263
	align 010h
@BLBL260:

; 1568                     if ((wChar & 0xff) == 0)
	test	byte ptr [ebp-082h],0ffh;	wChar
	jne	@BLBL263

; 1569                       wChar = 0xD0;
	mov	word ptr [ebp-082h],0d0h;	wChar

; 1570                   }
	jmp	@BLBL263
	align 010h
@BLBL259:

; 1572                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL263:

; 1573                 break;
	jmp	@BLBL303
	align 04h
@BLBL318:

; 1575                 if (stCFG.bDispWriteReq)
	test	byte ptr  stCFG+01ch,08h
	je	@BLBL264

; 1577                   bDisplaySignal = TRUE;
	mov	dword ptr [ebp-08ch],01h;	bDisplaySignal

; 1578                   stPos.y = lWriteRow;
	mov	eax,[ebp-01ch];	lWriteRow
	mov	dword ptr  @1adstPos+04h,eax

; 1579                   GpiSetBackColor(hps,stCFG.lWriteReqBackgrndColor);
	push	dword ptr  stCFG+095h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1580                   GpiSetColor(hps,stCFG.lWriteReqForegrndColor);
	push	dword ptr  stCFG+099h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1581                   if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL265

; 1582                     wChar = 'w';
	mov	word ptr [ebp-082h],077h;	wChar
	jmp	@BLBL268
	align 010h
@BLBL265:

; 1584                     if ((wChar & 0xff) == 0)
	test	byte ptr [ebp-082h],0ffh;	wChar
	jne	@BLBL268

; 1585                       wChar = 0xD1;
	mov	word ptr [ebp-082h],0d1h;	wChar

; 1586                   }
	jmp	@BLBL268
	align 010h
@BLBL264:

; 1588                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL268:

; 1589                 break;
	jmp	@BLBL303
	align 04h
@BLBL319:

; 1591                 if (stCFG.bDispReadReq)
	test	byte ptr  stCFG+01ch,010h
	je	@BLBL269

; 1593                   bDisplaySignal = TRUE;
	mov	dword ptr [ebp-08ch],01h;	bDisplaySignal

; 1594                   stPos.y = lReadRow;
	mov	eax,[ebp-020h];	lReadRow
	mov	dword ptr  @1adstPos+04h,eax

; 1595                   GpiSetBackColor(hps,stCFG.lReadReqBackgrndColor);
	push	dword ptr  stCFG+08dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1596                   GpiSetColor(hps,stCFG.lReadReqForegrndColor);
	push	dword ptr  stCFG+091h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1597                   if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL270

; 1598                     wChar = 'R';
	mov	word ptr [ebp-082h],052h;	wChar
	jmp	@BLBL273
	align 010h
@BLBL270:

; 1600                     if ((wChar & 0xff) == 0)
	test	byte ptr [ebp-082h],0ffh;	wChar
	jne	@BLBL273

; 1601                       wChar = 0xB0;
	mov	word ptr [ebp-082h],0b0h;	wChar

; 1602                   }
	jmp	@BLBL273
	align 010h
@BLBL269:

; 1604                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL273:

; 1605                 break;
	jmp	@BLBL303
	align 04h
@BLBL320:

; 1607                 if (stCFG.bDispReadReq)
	test	byte ptr  stCFG+01ch,010h
	je	@BLBL274

; 1609                   bDisplaySignal = TRUE;
	mov	dword ptr [ebp-08ch],01h;	bDisplaySignal

; 1610                   stPos.y = lReadRow;
	mov	eax,[ebp-020h];	lReadRow
	mov	dword ptr  @1adstPos+04h,eax

; 1611                   GpiSetBackColor(hps,stCFG.lReadReqBackgrndColor);
	push	dword ptr  stCFG+08dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1612                   GpiSetColor(hps,stCFG.lReadReqForegrndColor);
	push	dword ptr  stCFG+091h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1613                   if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL275

; 1614                     wChar = 'r';
	mov	word ptr [ebp-082h],072h;	wChar
	jmp	@BLBL278
	align 010h
@BLBL275:

; 1616                     if ((wChar & 0xff) == 0)
	test	byte ptr [ebp-082h],0ffh;	wChar
	jne	@BLBL278

; 1617                       wChar = 0xB1;
	mov	word ptr [ebp-082h],0b1h;	wChar

; 1618                   }
	jmp	@BLBL278
	align 010h
@BLBL274:

; 1620                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL278:

; 1621                 break;
	jmp	@BLBL303
	align 04h
@BLBL321:

; 1623                 if (stCFG.bDispOpen)
	test	byte ptr  stCFG+01ch,04h
	je	@BLBL279

; 1625                   bDisplaySignal = TRUE;
	mov	dword ptr [ebp-08ch],01h;	bDisplaySignal

; 1626                   stPos.y = lWriteRow;
	mov	eax,[ebp-01ch];	lWriteRow
	mov	dword ptr  @1adstPos+04h,eax

; 1627                   GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
	push	dword ptr  stCFG+07dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1628                   GpiSetColor(hps,stCFG.lOpenForegrndColor);
	push	dword ptr  stCFG+081h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1629                   if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL280

; 1630                     wChar = 'O';
	mov	word ptr [ebp-082h],04fh;	wChar
	jmp	@BLBL282
	align 010h
@BLBL280:

; 1632                     wChar = 0x00;
	mov	word ptr [ebp-082h],0h;	wChar

; 1633                   }                else
	jmp	@BLBL282
	align 010h
@BLBL279:

; 1634                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL282:

; 1635                 break;
	jmp	@BLBL303
	align 04h
@BLBL322:

; 1637                 if (stCFG.bDispOpen)
	test	byte ptr  stCFG+01ch,04h
	je	@BLBL283

; 1639                   bDisplaySignal = TRUE;
	mov	dword ptr [ebp-08ch],01h;	bDisplaySignal

; 1640                   stPos.y = lWriteRow;
	mov	eax,[ebp-01ch];	lWriteRow
	mov	dword ptr  @1adstPos+04h,eax

; 1641                   GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
	push	dword ptr  stCFG+07dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1642                   GpiSetColor(hps,stCFG.lOpenForegrndColor);
	push	dword ptr  stCFG+081h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1643                   if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL284

; 1644                     wChar = 'o';
	mov	word ptr [ebp-082h],06fh;	wChar
	jmp	@BLBL286
	align 010h
@BLBL284:

; 1646                     wChar = 0x01;
	mov	word ptr [ebp-082h],01h;	wChar

; 1647                   }
	jmp	@BLBL286
	align 010h
@BLBL283:

; 1649                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL286:

; 1650                 break;
	jmp	@BLBL303
	align 04h
@BLBL323:

; 1652                 if (stCFG.bDispOpen)
	test	byte ptr  stCFG+01ch,04h
	je	@BLBL287

; 1654                   bDisplaySignal = TRUE;
	mov	dword ptr [ebp-08ch],01h;	bDisplaySignal

; 1655                   stPos.y = lWriteRow;
	mov	eax,[ebp-01ch];	lWriteRow
	mov	dword ptr  @1adstPos+04h,eax

; 1656                   
; 1656 GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
	push	dword ptr  stCFG+07dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1657                   GpiSetColor(hps,stCFG.lOpenForegrndColor);
	push	dword ptr  stCFG+081h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1658                   if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL288

; 1659                     wChar = 'C';
	mov	word ptr [ebp-082h],043h;	wChar
	jmp	@BLBL290
	align 010h
@BLBL288:

; 1661                     wChar = 0xc0;
	mov	word ptr [ebp-082h],0c0h;	wChar

; 1662                   }
	jmp	@BLBL290
	align 010h
@BLBL287:

; 1664                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL290:

; 1665                 break;
	jmp	@BLBL303
	align 04h
@BLBL324:

; 1667                 if (stCFG.bDispOpen)
	test	byte ptr  stCFG+01ch,04h
	je	@BLBL291

; 1669                   bDisplaySignal = TRUE;
	mov	dword ptr [ebp-08ch],01h;	bDisplaySignal

; 1670                   stPos.y = lWriteRow;
	mov	eax,[ebp-01ch];	lWriteRow
	mov	dword ptr  @1adstPos+04h,eax

; 1671                   GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
	push	dword ptr  stCFG+07dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1672                   GpiSetColor(hps,stCFG.lOpenForegrndColor);
	push	dword ptr  stCFG+081h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1673                   if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL292

; 1674                     wChar = 'c';
	mov	word ptr [ebp-082h],063h;	wChar
	jmp	@BLBL294
	align 010h
@BLBL292:

; 1676                     wChar = 0xc1;
	mov	word ptr [ebp-082h],0c1h;	wChar

; 1677                   }
	jmp	@BLBL294
	align 010h
@BLBL291:

; 1679                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL294:

; 1680                 break;
	jmp	@BLBL303
	align 04h
@BLBL325:

; 1682                 if (bDebuggingCOMscope)
	cmp	dword ptr  bDebuggingCOMscope,0h
	je	@BLBL295

; 1684                   wChar >>= 8;
	mov	ax,[ebp-082h];	wChar
	shr	ax,08h
	mov	[ebp-082h],ax;	wChar

; 1685                   GpiSetBackColor(hps,CLR_RED);
	push	02h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 1686                   GpiSetColor(hps,CLR_WHITE);
	push	0fffffffeh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 1687                   }
	jmp	@BLBL296
	align 010h
@BLBL295:

; 1689                   bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-088h],0h;	bDisplayCharacter
@BLBL296:

; 1690                 break;
	jmp	@BLBL303
	align 04h
	jmp	@BLBL303
	align 04h
@BLBL304:
	cmp	eax,0ff00h
	je	@BLBL305
	cmp	eax,04000h
	je	@BLBL306
	cmp	eax,08000h
	je	@BLBL307
	cmp	eax,08100h
	je	@BLBL308
	cmp	eax,04100h
	je	@BLBL309
	cmp	eax,04400h
	je	@BLBL310
	cmp	eax,08400h
	je	@BLBL311
	cmp	eax,08500h
	je	@BLBL312
	cmp	eax,04600h
	je	@BLBL313
	cmp	eax,04500h
	je	@BLBL314
	cmp	eax,04700h
	je	@BLBL315
	cmp	eax,08a00h
	je	@BLBL316
	cmp	eax,08200h
	je	@BLBL317
	cmp	eax,08300h
	je	@BLBL318
	cmp	eax,04200h
	je	@BLBL319
	cmp	eax,04300h
	je	@BLBL320
	cmp	eax,08600h
	je	@BLBL321
	cmp	eax,08700h
	je	@BLBL322
	cmp	eax,08800h
	je	@BLBL323
	cmp	eax,08900h
	je	@BLBL324
	jmp	@BLBL325
	align 04h
@BLBL303:

; 1692             if (bDisplayCharacter)
	cmp	dword ptr [ebp-088h],0h;	bDisplayCharacter
	je	@BLBL297

; 1694               stPos.x = lCol;
	mov	eax,[ebp-024h];	lCol
	mov	dword ptr  @1adstPos,eax

; 1695               GpiCharStringAt(hps,&stPos,1,(char *)&wChar);
	lea	eax,[ebp-082h];	wChar
	push	eax
	push	01h
	push	offset FLAT:@1adstPos
	push	dword ptr [ebp-04h];	hps
	call	GpiCharStringAt
	add	esp,010h

; 1696               if (lCol >= stRow.lWidth)
	mov	eax,dword ptr  stRow+033h
	cmp	[ebp-024h],eax;	lCol
	jl	@BLBL298

; 1726                   bDisplaySignal = FALSE;
	mov	dword ptr [ebp-08ch],0h;	bDisplaySignal

; 1727                 if (lWriteRow < (lStatusHeight + 2))
	mov	eax,dword ptr  lStatusHeight
	add	eax,02h
	cmp	[ebp-01ch],eax;	lWriteRow
	jl	@BLBL200

; 1729                 lReadRow -= (stCell.cy * 2);
	movsx	ecx,word ptr  stCell+02h
	mov	eax,[ebp-020h];	lReadRow
	sub	eax,ecx
	sub	eax,ecx
	mov	[ebp-020h],eax;	lReadRow

; 1730                 lWriteRow = (lReadRow - stCell.cy);
	movsx	ecx,word ptr  stCell+02h
	mov	eax,[ebp-020h];	lReadRow
	sub	eax,ecx
	mov	[ebp-01ch],eax;	lWriteRow

; 1731                 lCol = 0;
	mov	dword ptr [ebp-024h],0h;	lCol

; 1732                 }
	jmp	@BLBL301
	align 010h
@BLBL298:

; 1735                 lCol += stCell.cx;
	movsx	eax,word ptr  stCell
	add	eax,[ebp-024h];	lCol
	mov	[ebp-024h],eax;	lCol

; 1736                 wLastDirection = wDirection;
	mov	ax,[ebp-084h];	wDirection
	mov	word ptr  @1b7wLastDirection,ax

; 1737                 }

; 1738               }
	jmp	@BLBL301
	align 010h
@BLBL297:

; 1740               bDisplayCharacter = TRUE;
	mov	dword ptr [ebp-088h],01h;	bDisplayCharacter
@BLBL301:

; 1741             lIndex++;
	mov	eax,[ebp-018h];	lIndex
	inc	eax
	mov	[ebp-018h],eax;	lIndex

; 1742             }

; 1362           while (1)
	jmp	@BLBL210
	align 010h
@BLBL200:

; 1747   bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 1748   WinEndPaint(hps);
	push	dword ptr [ebp-04h];	hps
	call	WinEndPaint
	add	esp,04h

; 1749   if ((rc = DosReleaseMutexSem(hmtxRowGioBlockedSem)) != NO_ERROR)
	push	dword ptr  hmtxRowGioBlockedSem
	call	DosReleaseMutexSem
	add	esp,04h
	mov	[ebp-030h],eax;	rc
	cmp	dword ptr [ebp-030h],0h;	rc
	je	@BLBL302

; 1751     sprintf(szMessage,"DosReleaseMutexSem error in RowPaint: return code = %ld", rc);
	push	dword ptr [ebp-030h];	rc
	mov	edx,offset FLAT:@STAT3d
	lea	eax,[ebp-080h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1752     ErrorNotify(szMessage);
	lea	eax,[ebp-080h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1753     }
@BLBL302:

; 1754   }
	mov	esp,ebp
	pop	ebp
	ret	
RowPaint	endp

; 1757   {
	align 010h

	public CreatePS
CreatePS	proc
	push	ebp
	mov	ebp,esp
	sub	esp,018h
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
	pop	edi
	pop	eax
	sub	esp,08h

; 1758   ERRORID eidWinError = 0;
	mov	dword ptr [ebp-04h],0h;	eidWinError

; 1759   LONG lRemainingFonts;
; 1760   LONG lFontCount;
; 1761   LONG lIndex;
; 1762   HPS hps;
; 1763   BOOL bSuccess = TRUE;
	mov	dword ptr [ebp-018h],01h;	bSuccess

; 1764 
; 1765   if (DosSearchPath(SEARCH_IGNORENETERRS |
	push	0104h
	push	offset FLAT:szFontFilePath
	push	offset FLAT:szFontFileName
	push	offset FLAT:@STAT3e
	push	07h
	call	DosSearchPath
	add	esp,014h
	test	eax,eax
	je	@BLBL326

; 1766                     SEARCH_CUR_DIRECTORY |
; 1767                     SEARCH_ENVIRONMENT,
; 1768                     "DPATH",
; 1769                     szFontFileName,
; 1770                     szFontFilePath,
; 1771                     CCHMAXPATH) != NO_ERROR)
; 1772     {
; 1773     lIndex = 0;
	mov	dword ptr [ebp-010h],0h;	lIndex

; 1774     while (szFontFileName[lIndex] != 0)
	mov	eax,[ebp-010h];	lIndex
	cmp	byte ptr [eax+ szFontFileName],0h
	je	@BLBL327
	align 010h
@BLBL328:

; 1775       {
; 1776       szFontFileName[lIndex] = toupper(szFontFileName[lIndex]);
	mov	ecx,dword ptr  _ctype
	mov	edx,[ebp-010h];	lIndex
	xor	eax,eax
	mov	al,byte ptr [edx+ szFontFileName]
	mov	cx,word ptr [ecx+eax*02h+0202h]
	mov	eax,[ebp-010h];	lIndex
	mov	byte ptr [eax+ szFontFileName],cl

; 1777       lIndex++;
	mov	eax,[ebp-010h];	lIndex
	inc	eax
	mov	[ebp-010h],eax;	lIndex

; 1778       }

; 1774     while (szFontFileName[lIndex] != 0)
	mov	eax,[ebp-010h];	lIndex
	cmp	byte ptr [eax+ szFontFileName],0h
	jne	@BLBL328
@BLBL327:

; 1779     sprintf(szErrorMessage,"Make sure \"%s\" is in the default directory or in a directory listed in the \"DPATH\" environment variable.",szFontFileName);
	push	offset FLAT:szFontFileName
	mov	edx,offset FLAT:@STAT3f
	mov	eax,offset FLAT:szErrorMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1780     sprintf(szTitle,"Unable to locate font file!");
	mov	edx,offset FLAT:@STAT40
	mov	eax,offset FLAT:szTitle
	call	_sprintfieee

; 1781     return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL326:

; 1783   hdcPs = WinOpenWindowDC(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	WinOpenWindowDC
	add	esp,04h
	mov	dword ptr  hdcPs,eax

; 1784   hps = WinGetPS(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	WinGetPS
	add	esp,04h
	mov	[ebp-014h],eax;	hps

; 1786   lFontCount = 0;
	mov	dword ptr [ebp-0ch],0h;	lFontCount

; 1787   lRemainingFonts = GpiQueryFontFileDescriptions(habAnchorBlock,
	push	offset FLAT:astFontNames
	lea	eax,[ebp-0ch];	lFontCount
	push	eax
	push	offset FLAT:szFontFilePath
	push	dword ptr  habAnchorBlock
	call	GpiQueryFontFileDescriptions
	add	esp,010h
	mov	[ebp-08h],eax;	lRemainingFonts

; 1791   if (lRemainingFonts == GPI_ALTERROR)
	cmp	dword ptr [ebp-08h],0ffffffffh;	lRemainingFonts
	jne	@BLBL330

; 1793     eidWinError = WinGetLastError(habAnchorBlock);
	push	dword ptr  habAnchorBlock
	call	WinGetLastError
	add	esp,04h
	mov	[ebp-04h],eax;	eidWinError

; 1794     sprintf(szErrorMessage,"\"%s\" is not valid Font File.\n\n Code = (0-%X)",szFontFilePath,eidWinError);
	push	dword ptr [ebp-04h];	eidWinError
	push	offset FLAT:szFontFilePath
	mov	edx,offset FLAT:@STAT41
	mov	eax,offset FLAT:szErrorMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 1795     sprintf(szTitle,"Bad Font File!");
	mov	edx,offset FLAT:@STAT42
	mov	eax,offset FLAT:szTitle
	call	_sprintfieee

; 1796     bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 1797     }
	jmp	@BLBL331
	align 010h
@BLBL330:

; 1800     lFontCount = lRemainingFonts;
	mov	eax,[ebp-08h];	lRemainingFonts
	mov	[ebp-0ch],eax;	lFontCount

; 1801     if (lFontCount > MAX_FONTS)
	cmp	dword ptr [ebp-0ch],04h;	lFontCount
	jle	@BLBL332

; 1802       lFontCount = MAX_FONTS;
	mov	dword ptr [ebp-0ch],04h;	lFontCount
@BLBL332:

; 1803     lRemainingFonts = GpiQueryFontFileDescriptions(habAnchorBlock,
	push	offset FLAT:astFontNames
	lea	eax,[ebp-0ch];	lFontCount
	push	eax
	push	offset FLAT:szFontFilePath
	push	dword ptr  habAnchorBlock
	call	GpiQueryFontFileDescriptions
	add	esp,010h
	mov	[ebp-08h],eax;	lRemainingFonts

; 1807     if (lRemainingFonts != GPI_ALTERROR)
	cmp	dword ptr [ebp-08h],0ffffffffh;	lRemainingFonts
	je	@BLBL333

; 1809       if (GpiLoadFonts(habAnchorBlock,szFontFilePath))
	push	offset FLAT:szFontFilePath
	push	dword ptr  habAnchorBlock
	call	GpiLoadFonts
	add	esp,08h
	test	eax,eax
	je	@BLBL334

; 1811         lFontsAvailable = lFontCount;
	mov	eax,[ebp-0ch];	lFontCount
	mov	dword ptr  lFontsAvailable,eax

; 1812         for (lIndex = 0;lIndex < lFontsAvailable;lIndex++)
	mov	dword ptr [ebp-010h],0h;	lIndex
	mov	eax,dword ptr  lFontsAvailable
	cmp	[ebp-010h],eax;	lIndex
	jge	@BLBL331
	align 010h
@BLBL336:

; 1814           lFontCount = 1;
	mov	dword ptr [ebp-0ch],01h;	lFontCount

; 1815           lRemainingFonts = GpiQueryFonts(hps,
	mov	eax,[ebp-010h];	lIndex
	imul	eax,0e4h
	add	eax,offset FLAT:astFontMetrics
	push	eax
	push	0e4h
	lea	eax,[ebp-0ch];	lFontCount
	push	eax
	mov	eax,[ebp-010h];	lIndex
	imul	eax,040h
	add	eax,offset FLAT:astFontNames+020h
	push	eax
	push	02h
	push	dword ptr [ebp-014h];	hps
	call	GpiQueryFonts
	add	esp,018h
	mov	[ebp-08h],eax;	lRemainingFonts

; 1821           if (lRemainingFonts != GPI_ALTERROR)
	cmp	dword ptr [ebp-08h],0ffffffffh;	lRemainingFonts
	je	@BLBL337

; 1823             astFontAttributes[lIndex].usRecordLength = sizeof(FATTRS);
	mov	eax,[ebp-010h];	lIndex
	imul	eax,038h
	mov	word ptr [eax+ astFontAttributes],038h

; 1824             astFontAttributes[lIndex].fsSelection = 0;
	mov	eax,[ebp-010h];	lIndex
	imul	eax,038h
	mov	word ptr [eax+ astFontAttributes+02h],0h

; 1825             astFontAttributes[lIndex].lMatch = astFontMetrics[lIndex].lMatch;
	mov	ecx,[ebp-010h];	lIndex
	imul	ecx,0e4h
	mov	ecx,dword ptr [ecx+ astFontMetrics+0cch]
	mov	eax,[ebp-010h];	lIndex
	imul	eax,038h
	mov	dword ptr [eax+ astFontAttributes+04h],ecx

; 1826             strcpy(astFontAttributes[lIndex].szFacename,astFontMetrics[lIndex].szFacename);
	mov	edx,[ebp-010h];	lIndex
	imul	edx,0e4h
	add	edx,offset FLAT:astFontMetrics
	add	edx,020h
	mov	eax,[ebp-010h];	lIndex
	imul	eax,038h
	add	eax,offset FLAT:astFontAttributes
	add	eax,08h
	call	strcpy

; 1827             astFontAttributes[lIndex].idRegistry = astFontMetrics[lIndex].idRegistry;
	mov	ecx,[ebp-010h];	lIndex
	imul	ecx,0e4h
	mov	cx,word ptr [ecx+ astFontMetrics+040h]
	mov	eax,[ebp-010h];	lIndex
	imul	eax,038h
	mov	word ptr [eax+ astFontAttributes+028h],cx

; 1828             astFontAttributes[lIndex].usCodePage = astFontMetrics[lIndex].usCodePage;
	mov	ecx,[ebp-010h];	lIndex
	imul	ecx,0e4h
	mov	cx,word ptr [ecx+ astFontMetrics+042h]
	mov	eax,[ebp-010h];	lIndex
	imul	eax,038h
	mov	word ptr [eax+ astFontAttributes+02ah],cx

; 1829             astFontAttributes[lIndex].lMaxBaselineExt = astFontMetrics[lIndex].lMaxBaselineExt;
	mov	ecx,[ebp-010h];	lIndex
	imul	ecx,0e4h
	mov	ecx,dword ptr [ecx+ astFontMetrics+070h]
	mov	eax,[ebp-010h];	lIndex
	imul	eax,038h
	mov	dword ptr [eax+ astFontAttributes+02ch],ecx

; 1830             astFontAttributes[lIndex].lAveCharWidth = astFontMetrics[lIndex].lAveCharWidth;
	mov	ecx,[ebp-010h];	lIndex
	imul	ecx,0e4h
	mov	ecx,dword ptr [ecx+ astFontMetrics+064h]
	mov	eax,[ebp-010h];	lIndex
	imul	eax,038h
	mov	dword ptr [eax+ astFontAttributes+030h],ecx

; 1831             astFontAttributes[lIndex].fsType = 0;
	mov	eax,[ebp-010h];	lIndex
	imul	eax,038h
	mov	word ptr [eax+ astFontAttributes+034h],0h

; 1832             astFontAttributes[lIndex].fsFontUse = FATTR_FONTUSE_NOMIX;
	mov	eax,[ebp-010h];	lIndex
	imul	eax,038h
	mov	word ptr [eax+ astFontAttributes+036h],02h

; 1833             }
	jmp	@BLBL338
	align 010h
@BLBL337:

; 1836             eidWinError = WinGetLastError(habAnchorBlock);
	push	dword ptr  habAnchorBlock
	call	WinGetLastError
	add	esp,04h
	mov	[ebp-04h],eax;	eidWinError

; 1837             sprintf(szErrorMessage,"\"%s\" is not valid Font File.\n\n Code = (1-%X)",szFontFilePath,eidWinError);
	push	dword ptr [ebp-04h];	eidWinError
	push	offset FLAT:szFontFilePath
	mov	edx,offset FLAT:@STAT43
	mov	eax,offset FLAT:szErrorMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 1838             sprintf(szTitle,"Bad Font File!");
	mov	edx,offset FLAT:@STAT44
	mov	eax,offset FLAT:szTitle
	call	_sprintfieee

; 1839             bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 1840             }
@BLBL338:

; 1841           }

; 1812         for (lIndex = 0;lIndex < lFontsAvailable;lIndex++)
	mov	eax,[ebp-010h];	lIndex
	inc	eax
	mov	[ebp-010h],eax;	lIndex
	mov	eax,dword ptr  lFontsAvailable
	cmp	[ebp-010h],eax;	lIndex
	jl	@BLBL336

; 1842         }
	jmp	@BLBL331
	align 010h
@BLBL334:

; 1845         eidWinError = WinGetLastError(habAnchorBlock);
	push	dword ptr  habAnchorBlock
	call	WinGetLastError
	add	esp,04h
	mov	[ebp-04h],eax;	eidWinError

; 1846         sprintf(szErrorMessage,"\"%s\" is not valid Font File.\n\n Code = (2-%X)",szFontFilePath,eidWinError);
	push	dword ptr [ebp-04h];	eidWinError
	push	offset FLAT:szFontFilePath
	mov	edx,offset FLAT:@STAT45
	mov	eax,offset FLAT:szErrorMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 1847         sprintf(szTitle,"Bad Font File!");
	mov	edx,offset FLAT:@STAT46
	mov	eax,offset FLAT:szTitle
	call	_sprintfieee

; 1848         bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 1849         }

; 1850       }
	jmp	@BLBL331
	align 010h
@BLBL333:

; 1853       eidWinError = WinGetLastError(habAnchorBlock);
	push	dword ptr  habAnchorBlock
	call	WinGetLastError
	add	esp,04h
	mov	[ebp-04h],eax;	eidWinError

; 1854       sprintf(szErrorMessage,"\"%s\" is not valid Font File.\n\n Code = (3-%X)",szFontFilePath,eidWinError);
	push	dword ptr [ebp-04h];	eidWinError
	push	offset FLAT:szFontFilePath
	mov	edx,offset FLAT:@STAT47
	mov	eax,offset FLAT:szErrorMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 1855       sprintf(szTitle,"Bad Font File!");
	mov	edx,offset FLAT:@STAT48
	mov	eax,offset FLAT:szTitle
	call	_sprintfieee

; 1856       bSuccess = FALSE;
	mov	dword ptr [ebp-018h],0h;	bSuccess

; 1857       }

; 1858     }
@BLBL331:

; 1859   WinReleasePS(hps);
	push	dword ptr [ebp-014h];	hps
	call	WinReleasePS
	add	esp,04h

; 1860   return(bSuccess);
	mov	eax,[ebp-018h];	bSuccess
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
CreatePS	endp

; 1873   {
	align 010h

	public FrameSubProc
FrameSubProc	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax
	push	ebx

; 1876   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL355
	align 04h
@BLBL356:

; 1877     {
; 1878 #ifdef this_junk
; 1879     case WM_CHAR:
; 1880       if (bSendNextKeystroke)
; 1881         if (ProcessKeystroke(&stCFG,mp1,mp2))
; 1882           return((MRESULT)TRUE);
; 1883       return( WinDefWindowProc(hwnd,msg,mp1,mp2));
; 1884 #endif
; 1885     case WM_QUERYTRACKINFO:
; 1886       /*
; 1887       ** Invoke the normal frame window procedure first.
; 1888       ** This updates the tracking rectangle to the new position.
; 1889       */
; 1890       (*FrameProcess)(hwnd,msg,mp1,mp2);
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	dword ptr  FrameProcess
	add	esp,010h

; 1891       pTrack = (PTRACKINFO)mp2;
	mov	eax,[ebp+014h];	mp2
	mov	[ebp-04h],eax;	pTrack

; 1892 
; 1893         /*
; 1894       if (pTrack->rclTrack.yBottom != pOldTrack->rclTrack.yBottom)
; 1895         iTemp = 0;
; 1896         ** Only limit the bounding rectangle if the operation is SIZING.
; 1897         ** Moving continues as normal.
; 1898         */
; 1899       if(((pTrack->fs & TF_MOVE) != TF_MOVE) &&
	mov	eax,[ebp-04h];	pTrack
	mov	eax,[eax+048h]
	and	eax,0fh
	cmp	eax,0fh
	je	@BLBL350

; 1900          ((pTrack->fs & TF_LEFT)   ||
	mov	eax,[ebp-04h];	pTrack
	test	byte ptr [eax+048h],01h
	jne	@BLBL351

; 1901           (pTrack->fs & TF_TOP)    ||
	mov	eax,[ebp-04h];	pTrack
	test	byte ptr [eax+048h],02h
	jne	@BLBL351

; 1902           (pTrack->fs & TF_RIGHT)  ||
	mov	eax,[ebp-04h];	pTrack
	test	byte ptr [eax+048h],04h
	jne	@BLBL351

; 1903           (pTrack->fs & TF_BOTTOM) ||
	mov	eax,[ebp-04h];	pTrack
	test	byte ptr [eax+048h],08h
	jne	@BLBL351

; 1904           (pTrack->fs & TF_SETPOINTERPOS)))
	mov	eax,[ebp-04h];	pTrack
	test	byte ptr [eax+048h],010h
	je	@BLBL350
@BLBL351:

; 1905         {
; 1906         /*
; 1907         ** Make sure that the window is only SIZED in (character-height * 2) or
; 1908         ** (character-width) steps.
; 1909         */
; 1910         pTrack->cyGrid = (stCell.cy * 2);
	movsx	ecx,word ptr  stCell+02h
	add	ecx,ecx
	mov	eax,[ebp-04h];	pTrack
	mov	[eax+0ch],ecx

; 1911         pTrack->cyKeyboard = (stCell.cy * 2);
	movsx	ecx,word ptr  stCell+02h
	add	ecx,ecx
	mov	eax,[ebp-04h];	pTrack
	mov	[eax+014h],ecx

; 1912         pTrack->cxGrid = stCell.cx;
	movsx	ecx,word ptr  stCell
	mov	eax,[ebp-04h];	pTrack
	mov	[eax+08h],ecx

; 1913         pTrack->cxKeyboard = stCell.cx;
	movsx	ecx,word ptr  stCell
	mov	eax,[ebp-04h];	pTrack
	mov	[eax+010h],ecx

; 1914         pTrack->fs |= (TF_GRID | TF_ALLINBOUNDARY);
	mov	eax,[ebp-04h];	pTrack
	mov	[ebp-0ch],eax;	@CBE93
	mov	eax,[ebp-0ch];	@CBE93
	mov	ecx,[eax+048h]
	or	cl,0a0h
	mov	[eax+048h],ecx

; 1915 
; 1916         pTrack->ptlMinTrackSize.x = lMinimumWidth;
	mov	eax,[ebp-04h];	pTrack
	mov	ecx,dword ptr  lMinimumWidth
	mov	[eax+038h],ecx

; 1917         pTrack->ptlMinTrackSize.y = lMinimumHeight;
	mov	eax,[ebp-04h];	pTrack
	mov	ecx,dword ptr  lMinimumHeight
	mov	[eax+03ch],ecx

; 1918         pTrack->ptlMaxTrackSize.x = (lXScr - (lcxBrdr * 2) - (lXScr % stCell.cx));
	mov	ecx,dword ptr  lXScr
	mov	eax,dword ptr  lcxBrdr
	sub	ecx,eax
	sub	ecx,eax
	movsx	ebx,word ptr  stCell
	mov	eax,dword ptr  lXScr
	cdq	
	idiv	ebx
	sub	ecx,edx
	mov	eax,[ebp-04h];	pTrack
	mov	[eax+040h],ecx

; 1919         pTrack->ptlMaxTrackSize.y = (lYScr - (lcyBrdr * 2) - (lYScr % (stCell.cy * 2)) - lStatusHeight);
	movsx	ecx,word ptr  stCell+02h
	add	ecx,ecx
	mov	eax,dword ptr  lYScr
	cdq	
	idiv	ecx
	mov	ecx,dword ptr  lYScr
	mov	eax,dword ptr  lcyBrdr
	sub	ecx,eax
	sub	ecx,eax
	sub	ecx,edx
	sub	ecx,dword ptr  lStatusHeight
	mov	eax,[ebp-04h];	pTrack
	mov	[eax+044h],ecx

; 1920         }
	jmp	@BLBL352
	align 010h
@BLBL350:

; 1921       else
; 1922         /*
; 1923         ** Any movement in the x and y directions occurs, as usual, in pel units.
; 1924         */
; 1925         if( ( pTrack->fs & TF_MOVE ) == TF_MOVE )
	mov	eax,[ebp-04h];	pTrack
	mov	eax,[eax+048h]
	and	eax,0fh
	cmp	eax,0fh
	jne	@BLBL352

; 1926           {
; 1927           pTrack->cxGrid = 1;
	mov	eax,[ebp-04h];	pTrack
	mov	dword ptr [eax+08h],01h

; 1928           pTrack->cyGrid = 1;
	mov	eax,[ebp-04h];	pTrack
	mov	dword ptr [eax+0ch],01h

; 1929           pTrack->cxKeyboard = 1;
	mov	eax,[ebp-04h];	pTrack
	mov	dword ptr [eax+010h],01h

; 1930           pTrack->cyKeyboard = 1;
	mov	eax,[ebp-04h];	pTrack
	mov	dword ptr [eax+014h],01h

; 1931           pTrack->fs |= TF_GRID;
	mov	eax,[ebp-04h];	pTrack
	mov	[ebp-08h],eax;	@CBE92
	mov	eax,[ebp-08h];	@CBE92
	mov	ebx,[eax+048h]
	or	bl,020h
	mov	[eax+048h],ebx

; 1932           }
@BLBL352:

; 1933 
; 1934       return(MRESULT)(TRUE);
	mov	eax,01h
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL354
	align 04h
@BLBL355:
	cmp	eax,04ch
	je	@BLBL356
@BLBL354:

; 1935     }
; 1936   return((*FrameProcess)( hwnd, msg, mp1, mp2 ));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	dword ptr  FrameProcess
	add	esp,010h
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
FrameSubProc	endp

; 1940   {
	align 010h

	public WndSize
WndSize	proc
	push	ebp
	mov	ebp,esp
	sub	esp,054h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,015h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 1944   if (hwndFrame == (HWND)NULL)
	cmp	dword ptr  hwndFrame,0h
	jne	@BLBL357

; 1945     hwndFrame = WinQueryWindow(hwnd,QW_PARENT);
	push	05h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryWindow
	add	esp,08h
	mov	dword ptr  hwndFrame,eax
@BLBL357:

; 1946 
; 1947   bStatusSized = TRUE;
	mov	dword ptr  bStatusSized,01h

; 1948   WinSetWindowPos(hwndStatus,
	push	01h
	push	dword ptr  lStatusHeight
	mov	ax,[ebp+010h];	mpNewSize
	and	eax,0ffffh
	push	eax
	push	0h
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinSetWindowPos
	add	esp,01ch

; 1949                   0,
; 1950                   0,
; 1951                   0,
; 1952                   LOUSHORT(mpNewSize),
; 1953                   lStatusHeight,
; 1954                   SWP_SIZE);
; 1955 
; 1956 
; 1957   ClearRowScrollBar(&stRow);
	push	offset FLAT:stRow
	call	ClearRowScrollBar
	add	esp,04h

; 1958   if ((rc = DosRequestMutexSem(hmtxRowGioBlockedSem,10000)) != NO_ERROR)
	push	02710h
	push	dword ptr  hmtxRowGioBlockedSem
	call	DosRequestMutexSem
	add	esp,08h
	mov	[ebp-04h],eax;	rc
	cmp	dword ptr [ebp-04h],0h;	rc
	je	@BLBL358

; 1959     {
; 1960     sprintf(szMessage,"DosRequestMutexSem error in WndSize: return code = %ld", rc);
	push	dword ptr [ebp-04h];	rc
	mov	edx,offset FLAT:@STAT49
	lea	eax,[ebp-054h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1961     ErrorNotify(szMessage);
	lea	eax,[ebp-054h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1962     }
@BLBL358:

; 1963 
; 1964   lLastHeight = (LONG)HIUSHORT(mpNewSize);
	mov	eax,[ebp+010h];	mpNewSize
	shr	eax,010h
	and	eax,0ffffh
	and	eax,0ffffh
	mov	dword ptr  lLastHeight,eax

; 1965   lLastWidth = (LONG)LOUSHORT(mpNewSize);
	mov	ax,[ebp+010h];	mpNewSize
	and	eax,0ffffh
	mov	dword ptr  lLastWidth,eax

; 1966   stRow.lCharWidth = (lLastWidth / stCell.cx);
	movsx	ecx,word ptr  stCell
	mov	eax,dword ptr  lLastWidth
	cdq	
	idiv	ecx
	mov	dword ptr  stRow+027h,eax

; 1967   stRow.lWidth = (lLastWidth - stCell.cx);
	movsx	ecx,word ptr  stCell
	mov	eax,dword ptr  lLastWidth
	sub	eax,ecx
	mov	dword ptr  stRow+033h,eax

; 1968   stRow.lCharHeight = ((lLastHeight - lStatusHeight) / (stCell.cy * 2));
	movsx	ecx,word ptr  stCell+02h
	add	ecx,ecx
	mov	eax,dword ptr  lLastHeight
	sub	eax,dword ptr  lStatusHeight
	cdq	
	idiv	ecx
	mov	dword ptr  stRow+02bh,eax

; 1969   stRow.lHeight = (lLastHeight - stCell.cy);
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  lLastHeight
	sub	eax,ecx
	mov	dword ptr  stRow+02fh,eax

; 1970   stRow.lCharSize = (stRow.lCharWidth * stRow.lCharHeight);
	mov	eax,dword ptr  stRow+02bh
	imul	eax,dword ptr  stRow+027h
	mov	dword ptr  stRow+023h,eax

; 1971 
; 1972   if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
	mov	al,byte ptr  stCFG+01bh
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL359

; 1973     {
; 1974     if (!stCFG.bColumnDisplay)
	test	byte ptr  stCFG+018h,080h
	jne	@BLBL361

; 1975       SetupRowScrolling(&stRow);
	push	offset FLAT:stRow
	call	SetupRowScrolling
	add	esp,04h

; 1976     }
	jmp	@BLBL361
	align 010h
@BLBL359:

; 1977   else
; 1978     if (stCFG.fDisplaying & DISP_STREAM)
	mov	al,byte ptr  stCFG+01bh
	and	eax,01fh
	shr	eax,02h
	test	al,01h
	je	@BLBL361

; 1979       {
; 1980       if (stCFG.bColumnDisplay)
	test	byte ptr  stCFG+018h,080h
	je	@BLBL363

; 1981         {
; 1982         stRead.Pos.y = stRead.lHeight;
	mov	eax,dword ptr  stRead+02fh
	mov	dword ptr  stRead+053h,eax

; 1983         stWrite.Pos.y = stWrite.lHeight;
	mov	eax,dword ptr  stWrite+02fh
	mov	dword ptr  stWrite+053h,eax

; 1984         stRead.Pos.x = 0L;
	mov	dword ptr  stRead+04fh,0h

; 1985         stWrite.Pos.x = 0L;
	mov	dword ptr  stWrite+04fh,0h

; 1986         }
	jmp	@BLBL361
	align 010h
@BLBL363:

; 1987       else
; 1988         {
; 1989         stRow.lLeadReadRow = stRow.lHeight;
	mov	eax,dword ptr  stRow+02fh
	mov	dword ptr  stRow+07bh,eax

; 1990         stRow.lLeadWriteRow = stRow.lLeadReadRow - stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRow+07bh
	sub	eax,ecx
	mov	dword ptr  stRow+077h,eax

; 1991         stRow.lCursorReadRow = stRow.lLeadReadRow;
	mov	eax,dword ptr  stRow+07bh
	mov	dword ptr  stRow+057h,eax

; 1992         stRow.lCursorWriteRow = stRow.lLeadWriteRow;
	mov	eax,dword ptr  stRow+077h
	mov	dword ptr  stRow+05bh,eax

; 1993         stRow.Pos.x = 0;
	mov	dword ptr  stRow+04fh,0h

; 1994         stRow.lLeadIndex = lWriteIndex;
	mov	eax,dword ptr  lWriteIndex
	mov	dword ptr  stRow+073h,eax

; 1995         }

; 1996       }
@BLBL361:

; 1997 
; 1998   if ((rc = DosReleaseMutexSem(hmtxRowGioBlockedSem)) != NO_ERROR)
	push	dword ptr  hmtxRowGioBlockedSem
	call	DosReleaseMutexSem
	add	esp,04h
	mov	[ebp-04h],eax;	rc
	cmp	dword ptr [ebp-04h],0h;	rc
	je	@BLBL365

; 1999     {
; 2000     sprintf(szMessage,"DosReleaseMutexSem error in WndSize: return code = %ld", rc);
	push	dword ptr [ebp-04h];	rc
	mov	edx,offset FLAT:@STAT4a
	lea	eax,[ebp-054h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 2001     ErrorNotify(szMessage);
	lea	eax,[ebp-054h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 2002     }
@BLBL365:

; 2003   if (stWrite.bActive)
	test	byte ptr  stWrite+02h,01h
	je	@BLBL366

; 2004     WinSendMsg(stWrite.hwndClient,UM_TRACKFRAME,0L,0L);
	push	0h
	push	0h
	push	08012h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h
@BLBL366:

; 2005   if (stRead.bActive)
	test	byte ptr  stRead+02h,01h
	je	@BLBL367

; 2006     WinSendMsg(stRead.hwndClient,UM_TRACKFRAME,0L,0L);
	push	0h
	push	0h
	push	08012h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h
@BLBL367:

; 2007   WinInvalidateRect(hwnd,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinInvalidateRect
	add	esp,0ch

; 2008   return(mpNewSize);
	mov	eax,[ebp+010h];	mpNewSize
	mov	esp,ebp
	pop	ebp
	ret	
WndSize	endp

; 2018   {
	align 010h

	public StatusProc
StatusProc	proc
	push	ebp
	mov	ebp,esp
	sub	esp,01f4h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,07dh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 2047   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL470
	align 04h
@BLBL471:

; 2048     {
; 2049     case WM_CREATE:
; 2050       usLastPopupItem = IDMPU_LAST_MSG;
	mov	word ptr  @245usLastPopupItem,0fa3h

; 2051       stColor.cbSize = sizeof(CLRDLG);
	mov	word ptr [ebp-0a6h],05ah;	stColor

; 2052       if (stCFG.bShowCounts && stCFG.bSampleCounts)
	test	byte ptr  stCFG+016h,010h
	je	@BLBL368
	test	byte ptr  stCFG+018h,010h
	je	@BLBL368

; 2053         sprintf(szLastCounts,"Tx(0, 0)   Rx(0, 0)");
	mov	edx,offset FLAT:@STAT4b
	mov	eax,offset FLAT:@24aszLastCounts
	call	_sprintfieee
	jmp	@BLBL369
	align 010h
@BLBL368:

; 2054       else
; 2055         if (stCFG.bSampleCounts)
	test	byte ptr  stCFG+018h,010h
	je	@BLBL370

; 2056           sprintf(szLastCounts,"Tx(0 CPS)   Rx(0 CPS)");
	mov	edx,offset FLAT:@STAT4c
	mov	eax,offset FLAT:@24aszLastCounts
	call	_sprintfieee
	jmp	@BLBL369
	align 010h
@BLBL370:

; 2057         else
; 2058           sprintf(szLastCounts,"Tx(0)   Rx(0)");
	mov	edx,offset FLAT:@STAT4d
	mov	eax,offset FLAT:@24aszLastCounts
	call	_sprintfieee
@BLBL369:

; 2059       bDiagCountsCapable = FALSE;
	mov	dword ptr  @24ebDiagCountsCapable,0h

; 2060       memset(aulRxByteCount,0,(MAX_CPS_SAMPLES + 1));
	mov	ecx,065h
	xor	edx,edx
	mov	eax,offset FLAT:@24faulRxByteCount
	call	memset

; 2061       memset(aulTxByteCount,0,(MAX_CPS_SAMPLES + 1));
	mov	ecx,065h
	xor	edx,edx
	mov	eax,offset FLAT:@250aulTxByteCount
	call	memset

; 2062       if (stCFG.iSampleCount > MAX_CPS_SAMPLES)
	cmp	dword ptr  stCFG+0dfh,064h
	jle	@BLBL372

; 2063         stCFG.iSampleCount = MAX_CPS_SAMPLES;
	mov	dword ptr  stCFG+0dfh,064h
@BLBL372:

; 2064       ulMenuStyle = (PU_POSITIONONITEM | PU_MOUSEBUTTON2 | PU_HCONSTRAIN | PU_VCONSTRAIN | PU_KEYBOARD | PU_MOUSEBUTTON1);
	mov	word ptr  @24dulMenuStyle,02c7h

; 2065       break;
	jmp	@BLBL469
	align 04h
@BLBL472:

; 2066     case WM_COMMAND:
; 2067         switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL474
	align 04h
@BLBL475:

; 2068           {
; 2069           case IDMPU_SILENT_STATUS:
; 2070             if (!stCFG.bStickyMenus)
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL373

; 2071               usLastPopupItem = IDMPU_SILENT_STATUS;
	mov	word ptr  @245usLastPopupItem,0fb2h
	jmp	@BLBL374
	align 010h
@BLBL373:

; 2072             else
; 2073               usLastPopupItem = IDMPU_LAST_MSG;
	mov	word ptr  @245usLastPopupItem,0fa3h
@BLBL374:

; 2074             if (stCFG.bSilentStatus)
	test	byte ptr  stCFG+016h,01h
	je	@BLBL375

; 2075               stCFG.bSilentStatus = FALSE;
	and	byte ptr  stCFG+016h,0feh
	jmp	@BLBL376
	align 010h
@BLBL375:

; 2076             else
; 2077               stCFG.bSilentStatus = TRUE;
	or	byte ptr  stCFG+016h,01h
@BLBL376:

; 2078             break;
	jmp	@BLBL473
	align 04h
@BLBL476:

; 2079           case IDMPU_LAST_COUNT:
; 2080             if (!stCFG.bStickyMenus)
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL377

; 2081               usLastPopupItem = IDMPU_LAST_COUNT;
	mov	word ptr  @245usLastPopupItem,0fb1h
	jmp	@BLBL378
	align 010h
@BLBL377:

; 2082             else
; 2083               usLastPopupItem = IDMPU_LAST_MSG;
	mov	word ptr  @245usLastPopupItem,0fa3h
@BLBL378:

; 2084             if (idTimer == 0)
	cmp	dword ptr  @247idTimer,0h
	jne	@BLBL379

; 2085               {
; 2086               strcpy(szErrorMessage,szLastCounts);
	mov	edx,offset FLAT:@24aszLastCounts
	mov	eax,offset FLAT:szErrorMessage
	call	strcpy

; 2087               bLastCount = TRUE;
	mov	dword ptr  @24cbLastCount,01h

; 2088               WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 2089               }
@BLBL379:

; 2090             break;
	jmp	@BLBL473
	align 04h
@BLBL477:

; 2091           case IDMPU_LAST_MSG:
; 2092             usLastPopupItem = IDMPU_LAST_MSG;
	mov	word ptr  @245usLastPopupItem,0fa3h

; 2093             strcpy(szErrorMessage,szLastErrorMessage);
	mov	edx,offset FLAT:@244szLastErrorMessage
	mov	eax,offset FLAT:szErrorMessage
	call	strcpy

; 2094             WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 2095             if (stCFG.bShowCounts || stCFG.bSampleCounts)
	test	byte ptr  stCFG+016h,010h
	jne	@BLBL380
	test	byte ptr  stCFG+018h,010h
	je	@BLBL381
@BLBL380:

; 2096               if (stCFG.wUpdateDelay <= 3000)
	mov	ax,word ptr  stCFG+0cfh
	cmp	ax,0bb8h
	ja	@BLBL382

; 2097                 lMessageDelay = (3000 / stCFG.wUpdateDelay);
	xor	ecx,ecx
	mov	cx,word ptr  stCFG+0cfh
	mov	eax,0bb8h
	cdq	
	idiv	ecx
	mov	dword ptr  @24blMessageDelay,eax
	jmp	@BLBL381
	align 010h
@BLBL382:

; 2098               else
; 2099                 lMessageDelay = 1;
	mov	dword ptr  @24blMessageDelay,01h
@BLBL381:

; 2100             break;
	jmp	@BLBL473
	align 04h
@BLBL478:

; 2101           case IDMPU_COLORS:
; 2102             if (!stCFG.bStickyMenus)
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL384

; 2103               usLastPopupItem = IDMPU_COLORS;
	mov	word ptr  @245usLastPopupItem,0fa4h
	jmp	@BLBL385
	align 010h
@BLBL384:

; 2104            else
; 2105               usLastPopupItem = IDMPU_LAST_MSG;
	mov	word ptr  @245usLastPopupItem,0fa3h
@BLBL385:

; 2106             stColor.lForeground = stCFG.lStatusForegrndColor;
	mov	eax,dword ptr  stCFG+0b9h
	mov	[ebp-0a0h],eax;	stColor

; 2107             stColor.lBackground = stCFG.lStatusBackgrndColor;
	mov	eax,dword ptr  stCFG+0b5h
	mov	[ebp-0a4h],eax;	stColor

; 2108             sprintf(stColor.szCaption,"Status Line Display Colors");
	mov	edx,offset FLAT:@STAT4e
	lea	eax,[ebp-09ch];	stColor
	call	_sprintfieee

; 2109             if (WinDlgBox(HWND_DESKTOP,
	lea	eax,[ebp-0a6h];	stColor
	push	eax
	push	014b4h
	push	0h
	push	offset FLAT: fnwpSetColorDlg
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL386

; 2110                           hwnd,
; 2111                    (PFNWP)fnwpSetColorDlg,
; 2112                   (USHORT)NULL,
; 2113                           CLR_DLG,
; 2114                   MPFROMP(&stColor)))
; 2115    
; 2115            {
; 2116               stCFG.lStatusForegrndColor = stColor.lForeground;
	mov	eax,[ebp-0a0h];	stColor
	mov	dword ptr  stCFG+0b9h,eax

; 2117               stCFG.lStatusBackgrndColor = stColor.lBackground;
	mov	eax,[ebp-0a4h];	stColor
	mov	dword ptr  stCFG+0b5h,eax

; 2118               WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 2119               }
@BLBL386:

; 2120             break;
	jmp	@BLBL473
	align 04h
	jmp	@BLBL473
	align 04h
@BLBL474:
	cmp	eax,0fb2h
	je	@BLBL475
	cmp	eax,0fb1h
	je	@BLBL476
	cmp	eax,0fa3h
	je	@BLBL477
	cmp	eax,0fa4h
	je	@BLBL478
@BLBL473:

; 2121           }
; 2122         break;
	jmp	@BLBL469
	align 04h
@BLBL479:

; 2123     case WM_BUTTON2DOWN:
; 2124       if(bFrameActivated)
	cmp	dword ptr  bFrameActivated,0h
	je	@BLBL387

; 2125         {
; 2126         hwndMenu = WinLoadMenu(hwndStatus,(HMODULE)NULL,IDMPU_STATUS_POPUP);
	push	0fa0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinLoadMenu
	add	esp,0ch
	mov	[ebp-020h],eax;	hwndMenu

; 2127         if (mp1 != 0)
	cmp	dword ptr [ebp+010h],0h;	mp1
	je	@BLBL388

; 2128           {
; 2129           WinQueryPointerPos(HWND_DESKTOP,&ptl);
	lea	eax,[ebp-01ch];	ptl
	push	eax
	push	01h
	call	WinQueryPointerPos
	add	esp,08h

; 2130           if (!stCFG.bStickyMenus)
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL389

; 2131             ulMenuStyle |= PU_MOUSEBUTTON2DOWN;
	mov	ax,word ptr  @24dulMenuStyle
	or	al,010h
	mov	word ptr  @24dulMenuStyle,ax
	jmp	@BLBL391
	align 010h
@BLBL389:

; 2132           else
; 2133             ulMenuStyle &= ~PU_MOUSEBUTTON2DOWN;
	xor	eax,eax
	mov	ax,word ptr  @24dulMenuStyle
	and	al,0efh
	mov	word ptr  @24dulMenuStyle,ax

; 2134           }
	jmp	@BLBL391
	align 010h
@BLBL388:

; 2135         else
; 2136           {
; 2137           ulMenuStyle &= ~PU_MOUSEBUTTON2DOWN;
	xor	eax,eax
	mov	ax,word ptr  @24dulMenuStyle
	and	al,0efh
	mov	word ptr  @24dulMenuStyle,ax

; 2138           WinQueryWindowPos(hwndFrame,&swp);
	lea	eax,[ebp-044h];	swp
	push	eax
	push	dword ptr  hwndFrame
	call	WinQueryWindowPos
	add	esp,08h

; 2139           ptl.x = (swp.x + (swp.cx / 2));
	mov	eax,[ebp-03ch];	swp
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	add	eax,[ebp-034h];	swp
	mov	[ebp-01ch],eax;	ptl

; 2140           ptl.y = (swp.y + 5);
	mov	eax,[ebp-038h];	swp
	add	eax,05h
	mov	[ebp-018h],eax;	ptl

; 2141           }
@BLBL391:

; 2142         if (stCFG.bSilentStatus)
	test	byte ptr  stCFG+016h,01h
	je	@BLBL392

; 2143           PopupMenuItemCheck(hwndMenu,IDMPU_SILENT_STATUS,TRUE);
	push	01h
	push	0fb2h
	push	dword ptr [ebp-020h];	hwndMenu
	call	PopupMenuItemCheck
	add	esp,0ch
	jmp	@BLBL393
	align 010h
@BLBL392:

; 2144         else
; 2145           PopupMenuItemCheck(hwndMenu,IDMPU_SILENT_STATUS,FALSE);
	push	0h
	push	0fb2h
	push	dword ptr [ebp-020h];	hwndMenu
	call	PopupMenuItemCheck
	add	esp,0ch
@BLBL393:

; 2146         WinPopupMenu(HWND_DESKTOP,hwndStatus,hwndMenu,ptl.x,ptl.y,usLastPopupItem,ulMenuStyle);
	xor	eax,eax
	mov	ax,word ptr  @24dulMenuStyle
	push	eax
	xor	eax,eax
	mov	ax,word ptr  @245usLastPopupItem
	push	eax
	push	dword ptr [ebp-018h];	ptl
	push	dword ptr [ebp-01ch];	ptl
	push	dword ptr [ebp-020h];	hwndMenu
	push	dword ptr  hwndStatus
	push	01h
	call	WinPopupMenu
	add	esp,01ch

; 2147         }
	jmp	@BLBL394
	align 010h
@BLBL387:

; 2148       else
; 2149         {
; 2150         WinSetFocus(HWND_DESKTOP,hwndFrame);
	push	dword ptr  hwndFrame
	push	01h
	call	WinSetFocus
	add	esp,08h

; 2151         WinSendMsg(WinQueryHelpInstance(hwndClient),HM_SET_ACTIVE_WINDOW,0L,0L);
	push	dword ptr  hwndClient
	call	WinQueryHelpInstance
	add	esp,04h
	push	0h
	push	0h
	push	0224h
	push	eax
	call	WinSendMsg
	add	esp,010h

; 2152         bFrameActivated = TRUE;
	mov	dword ptr  bFrameActivated,01h

; 2153         }
@BLBL394:

; 2154       break;
	jmp	@BLBL469
	align 04h
@BLBL480:

; 2155     case WM_PAINT:
; 2156       WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 2157       hps = WinBeginPaint(hwnd,(HPS)NULL,&rcl);
	lea	eax,[ebp-014h];	rcl
	push	eax
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinBeginPaint
	add	esp,0ch
	mov	[ebp-04h],eax;	hps

; 2158       WinQueryWindowRect(hwndClient,&rcl);
	lea	eax,[ebp-014h];	rcl
	push	eax
	push	dword ptr  hwndClient
	call	WinQueryWindowRect
	add	esp,08h

; 2159       rcl.yTop = lStatusHeight;
	mov	eax,dword ptr  lStatusHeight
	mov	[ebp-08h],eax;	rcl

; 2160       rcl.yBottom = 0;
	mov	dword ptr [ebp-010h],0h;	rcl

; 2161       rcl.xLeft = 0;
	mov	dword ptr [ebp-014h],0h;	rcl

; 2162 
; 2163       WinFillRect(hps,&rcl,stCFG.lStatusBackgrndColor);
	push	dword ptr  stCFG+0b5h
	lea	eax,[ebp-014h];	rcl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 2164       GpiSetBackColor(hps,stCFG.lStatusBackgrndColor);
	push	dword ptr  stCFG+0b5h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 2165       GpiSetColor(hps,stCFG.lStatusForegrndColor);
	push	dword ptr  stCFG+0b9h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 2166       GpiSetBackMix(hps,BM_OVERPAINT);
	push	02h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackMix
	add	esp,08h

; 2167 
; 2168       ptl.y = ((lStatusHeight / 2) - 5);//5L + iFontSizeIndex;
	mov	eax,dword ptr  lStatusHeight
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	sub	eax,05h
	mov	[ebp-018h],eax;	ptl

; 2169       ptl.x = 6L;
	mov	dword ptr [ebp-01ch],06h;	ptl

; 2170       if (szErrorMessage[0] != 0)
	cmp	byte ptr  szErrorMessage,0h
	je	@BLBL395

; 2171         {
; 2172         GpiCharStringAt(hps,&ptl,(LONG)strlen(szErrorMessage),szErrorMessage);
	mov	eax,offset FLAT:szErrorMessage
	call	strlen
	push	offset FLAT:szErrorMessage
	push	eax
	lea	eax,[ebp-01ch];	ptl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	GpiCharStringAt
	add	esp,010h

; 2173         if (!bLastCount)
	cmp	dword ptr  @24cbLastCount,0h
	jne	@BLBL396

; 2174           strcpy(szLastErrorMessage,szErrorMessage);
	mov	edx,offset FLAT:szErrorMessage
	mov	eax,offset FLAT:@244szLastErrorMessage
	call	strcpy
	jmp	@BLBL397
	align 010h
@BLBL396:

; 2175         else
; 2176           bLastCount = FALSE;
	mov	dword ptr  @24cbLastCount,0h
@BLBL397:

; 2177         szErrorMessage[0] = 0;
	mov	byte ptr  szErrorMessage,0h

; 2178         if (stCFG.bShowCounts || stCFG.bSampleCounts)
	test	byte ptr  stCFG+016h,010h
	jne	@BLBL398
	test	byte ptr  stCFG+018h,010h
	je	@BLBL402
@BLBL398:

; 2179           if (stCFG.wUpdateDelay <= 3000)
	mov	ax,word ptr  stCFG+0cfh
	cmp	ax,0bb8h
	ja	@BLBL400

; 2180             lMessageDelay = (3000 / stCFG.wUpdateDelay);
	xor	ecx,ecx
	mov	cx,word ptr  stCFG+0cfh
	mov	eax,0bb8h
	cdq	
	idiv	ecx
	mov	dword ptr  @24blMessageDelay,eax
	jmp	@BLBL402
	align 010h
@BLBL400:

; 2181           else
; 2182             lMessageDelay = 1;
	mov	dword ptr  @24blMessageDelay,01h

; 2183         }
	jmp	@BLBL402
	align 010h
@BLBL395:

; 2184       else
; 2185         {
; 2186         if(stCFG.bMonitoringStream)
	test	byte ptr  stCFG+017h,020h
	je	@BLBL403

; 2187           {
; 2188           if (!stCFG.bShowCounts && !stCFG.bSampleCounts)
	test	byte ptr  stCFG+016h,010h
	jne	@BLBL402
	test	byte ptr  stCFG+018h,010h
	jne	@BLBL402

; 2189             {
; 2190             if (stCFG.bColumnDisplay)
	test	byte ptr  stCFG+018h,080h
	je	@BLBL405

; 2191               {
; 2192               if (stCFG.fDisplaying != 0)
	test	byte ptr  stCFG+01bh,01ch
	je	@BLBL402

; 2193                 {
; 2194                 GpiCharStringAt(hps,&ptl,8L,"Transmit");
	push	offset FLAT:@STAT4f
	push	08h
	lea	eax,[ebp-01ch];	ptl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	GpiCharStringAt
	add	esp,010h

; 2195                 ptl.x += stRead.rcl.xLeft;
	mov	eax,dword ptr  stRead+013h
	add	eax,[ebp-01ch];	ptl
	mov	[ebp-01ch],eax;	ptl

; 2196                 GpiCharStringAt(hps,&ptl,9L,"Receive  ");
	push	offset FLAT:@STAT50
	push	09h
	lea	eax,[ebp-01ch];	ptl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	GpiCharStringAt
	add	esp,010h

; 2197                 }

; 2198               }
	jmp	@BLBL402
	align 010h
@BLBL405:

; 2199             else
; 2200               GpiCharStringAt(hps,&ptl,17L,"Capturing Stream ");
	push	offset FLAT:@STAT51
	push	011h
	lea	eax,[ebp-01ch];	ptl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	GpiCharStringAt
	add	esp,010h

; 2201             }

; 2202           }
	jmp	@BLBL402
	align 010h
@BLBL403:

; 2203         else
; 2204           if (stCFG.fDisplaying & DISP_FILE)
	mov	al,byte ptr  stCFG+01bh
	and	eax,01fh
	shr	eax,02h
	test	al,04h
	je	@BLBL409

; 2205             {
; 2206             sprintf(szString,"Viewing %s",szDataFileSpec);
	push	offset FLAT:szDataFileSpec
	mov	edx,offset FLAT:@STAT52
	lea	eax,[ebp-01c6h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 2207             GpiCharStringAt(hps,&ptl,strlen(szString),szString);
	lea	eax,[ebp-01c6h];	szString
	call	strlen
	lea	ecx,[ebp-01c6h];	szString
	push	ecx
	push	eax
	lea	eax,[ebp-01ch];	ptl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	GpiCharStringAt
	add	esp,010h

; 2208             }
	jmp	@BLBL402
	align 010h
@BLBL409:

; 2209           else
; 2210             if (stCFG.fDisplaying & DISP_DATA)
	mov	al,byte ptr  stCFG+01bh
	and	eax,01fh
	shr	eax,02h
	test	al,02h
	je	@BLBL402

; 2211               GpiCharStringAt(hps,&ptl,21,"Viewing Captured Data");
	push	offset FLAT:@STAT53
	push	015h
	lea	eax,[ebp-01ch];	ptl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	GpiCharStringAt
	add	esp,010h

; 2212         }
@BLBL402:

; 2213 
; 2214       if ((stCFG.bColumnDisplay && ((stCFG.lReadColBackgrndColor == stCFG.lStatusBackgrndColor) ||
	test	byte ptr  stCFG+018h,080h
	je	@BLBL414
	mov	eax,dword ptr  stCFG+0b5h
	cmp	dword ptr  stCFG+0bdh,eax
	je	@BLBL416

; 2215                                    (stCFG.lWriteColBackgrndColor == stCFG.lStatusBackgrndColor))) ||
	mov	eax,dword ptr  stCFG+0b5h
	cmp	dword ptr  stCFG+0c5h,eax
	je	@BLBL416
@BLBL414:

; 2216                                    (stCFG.lStatusBackgrndColor == stCFG.lWriteBackgrndColor))
	mov	eax,dword ptr  stCFG+0adh
	cmp	dword ptr  stCFG+0b5h,eax
	jne	@BLBL417
@BLBL416:

; 2217         {
; 2218         rcl.yBottom = (rcl.yTop - 1);
	mov	eax,[ebp-08h];	rcl
	dec	eax
	mov	[ebp-010h],eax;	rcl

; 2219         if (stCFG.lStatusBackgrndColor != CLR_WHITE)
	cmp	dword ptr  stCFG+0b5h,0fffffffeh
	je	@BLBL418

; 2220           WinFillRect(hps,&rcl,(stCFG.lStatusBackgrndColor ^ stCFG.lStatusBackgrndColor));
	mov	eax,dword ptr  stCFG+0b5h
	xor	eax,dword ptr  stCFG+0b5h
	push	eax
	lea	eax,[ebp-014h];	rcl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch
	jmp	@BLBL417
	align 010h
@BLBL418:

; 2221         else
; 2222           WinFillRect(hps,&rcl,CLR_BLACK);
	push	0ffffffffh
	lea	eax,[ebp-014h];	rcl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 2223         }
@BLBL417:

; 2224       WinEndPaint( hps );
	push	dword ptr [ebp-04h];	hps
	call	WinEndPaint
	add	esp,04h

; 2225       break;
	jmp	@BLBL469
	align 04h
@BLBL481:

; 2226     case UM_STARTTIMER:
; 2227       if (idTimer == 0)
	cmp	dword ptr  @247idTimer,0h
	jne	@BLBL420

; 2228         {
; 2229         lMessageDelay = 0;
	mov	dword ptr  @24blMessageDelay,0h

; 2230         idTimer = WinStartTimer(habAnchorBlock,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	push	07ff8h
	push	dword ptr [ebp+08h];	hwnd
	push	dword ptr  habAnchorBlock
	call	WinStartTimer
	add	esp,010h
	mov	dword ptr  @247idTimer,eax

; 2231                                 hwnd,
; 2232                                 TID_STATUSBAR,
; 2233                                 stCFG.wUpdateDelay);
; 2234         if (GetCountsSinceLast(&stIOctl,hCom,&stCounts) == NO_ERROR)
	lea	eax,[ebp-0aeh];	stCounts
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetCountsSinceLast
	add	esp,0ch
	test	eax,eax
	jne	@BLBL420

; 2235           {
; 2236           if (stCFG.bSampleCounts)
	test	byte ptr  stCFG+018h,010h
	je	@BLBL422

; 2237             {
; 2238             if (stCFG.wUpdateDelay <= 1000)
	mov	ax,word ptr  stCFG+0cfh
	cmp	ax,03e8h
	ja	@BLBL423

; 2239               {
; 2240               iCPSdivisor = (1000 / stCFG.wUpdateDelay);
	xor	ecx,ecx
	mov	cx,word ptr  stCFG+0cfh
	mov	eax,03e8h
	cdq	
	idiv	ecx
	mov	dword ptr  @254iCPSdivisor,eax

; 2241               iCPSmultiplier = 0;
	mov	dword ptr  @255iCPSmultiplier,0h

; 2242               }
	jmp	@BLBL422
	align 010h
@BLBL423:

; 2243             else
; 2244               {
; 2245               iCPSmultiplier = (stCFG.wUpdateDelay / 1000);
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	mov	ecx,03e8h
	cdq	
	idiv	ecx
	mov	dword ptr  @255iCPSmultiplier,eax

; 2246               iCPSdivisor = 0;
	mov	dword ptr  @254iCPSdivisor,0h

; 2247               }

; 2248             }
@BLBL422:

; 2249           bDiagCountsCapable = TRUE;
	mov	dword ptr  @24ebDiagCountsCapable,01h

; 2250           iWindow = 0;
	mov	dword ptr  @251iWindow,0h

; 2251           memset(aulRxByteCount,0,(MAX_CPS_SAMPLES + 1));
	mov	ecx,065h
	xor	edx,edx
	mov	eax,offset FLAT:@24faulRxByteCount
	call	memset

; 2252           memset(aulTxByteCount,0,(MAX_CPS_SAMPLES + 1));
	mov	ecx,065h
	xor	edx,edx
	mov	eax,offset FLAT:@250aulTxByteCount
	call	memset

; 2253 //          for (iIndex = 0;iIndex < stCFG.iSampleCount;iIndex++)
; 2254 //            {
; 2255 //            aulTxByteCount[iIndex] = stCounts.ulBytesTransmitted;
; 2256 //            aulRxByteCount[iIndex] = stCounts.ulBytesReceived;
; 2257 //           }
; 2258 //          ulTxByteCount = (stCounts.ulBytesTransmitted * stCFG.iSampleCount);
; 2259 //          ulRxByteCount = (stCounts.ulBytesReceived * stCFG.iSampleCount);
; 2260           ulTxByteCount = 0;
	mov	dword ptr  @253ulTxByteCount,0h

; 2261           ulRxByteCount = 0;
	mov	dword ptr  @252ulRxByteCount,0h

; 2262           }

; 2263         }
@BLBL420:

; 2264       break;
	jmp	@BLBL469
	align 04h
@BLBL482:
@BLBL483:

; 2265     case WM_DESTROY:
; 2266     case UM_STOPTIMER:
; 2267       if (idTimer != 0)
	cmp	dword ptr  @247idTimer,0h
	je	@BLBL425

; 2268         {
; 2269         WinStopTimer(habAnchorBlock,
	push	dword ptr  @247idTimer
	push	dword ptr [ebp+08h];	hwnd
	push	dword ptr  habAnchorBlock
	call	WinStopTimer
	add	esp,0ch

; 2270                      hwnd,
; 2271                      idTimer);
; 2272         idTimer = 0L;
	mov	dword ptr  @247idTimer,0h

; 2273         }
@BLBL425:

; 2274       WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 2275       break;
	jmp	@BLBL469
	align 04h
@BLBL484:

; 2276     case UM_RESET_SAMPLES:
; 2277       if (bDiagCountsCapable && stCFG.bSampleCounts)
	cmp	dword ptr  @24ebDiagCountsCapable,0h
	je	@BLBL426
	test	byte ptr  stCFG+018h,010h
	je	@BLBL426

; 2278         {
; 2279         GetCountsSinceLast(&stIOctl,hCom,&stCounts);
	lea	eax,[ebp-0aeh];	stCounts
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetCountsSinceLast
	add	esp,0ch

; 2280         iWindow = 0;
	mov	dword ptr  @251iWindow,0h

; 2281         for (iIndex = 0;iIndex < stCFG.iSampleCount;iIndex++)
	mov	dword ptr [ebp-04ch],0h;	iIndex
	mov	eax,dword ptr  stCFG+0dfh
	cmp	[ebp-04ch],eax;	iIndex
	jge	@BLBL427
	align 010h
@BLBL428:

; 2282           {
; 2283           aulTxByteCount[iIndex] = stCounts.ulBytesTransmitted;
	mov	eax,[ebp-04ch];	iIndex
	mov	ecx,[ebp-0aah];	stCounts
	mov	dword ptr [eax*04h+@250aulTxByteCount],ecx

; 2284           aulRxByteCount[iIndex] = stCounts.ulBytesReceived;
	mov	eax,[ebp-04ch];	iIndex
	mov	ecx,[ebp-0aeh];	stCounts
	mov	dword ptr [eax*04h+@24faulRxByteCount],ecx

; 2285           }

; 2281         for (iIndex = 0;iIndex < stCFG.iSampleCount;iIndex++)
	mov	eax,[ebp-04ch];	iIndex
	inc	eax
	mov	[ebp-04ch],eax;	iIndex
	mov	eax,dword ptr  stCFG+0dfh
	cmp	[ebp-04ch],eax;	iIndex
	jl	@BLBL428
@BLBL427:

; 2286         ulTxByteCount = (stCounts.ulBytesTransmitted * stCFG.iSampleCount);
	mov	eax,dword ptr  stCFG+0dfh
	imul	eax,[ebp-0aah];	stCounts
	mov	dword ptr  @253ulTxByteCount,eax

; 2287         ulRxByteCount = (stCounts.ulBytesReceived * stCFG.iSampleCount);
	mov	eax,dword ptr  stCFG+0dfh
	imul	eax,[ebp-0aeh];	stCounts
	mov	dword ptr  @252ulRxByteCount,eax

; 2288         }
@BLBL426:
@BLBL485:

; 2290       if (idTimer != 0L)
	cmp	dword ptr  @247idTimer,0h
	je	@BLBL430

; 2292         idTimer = WinStartTimer(habAnchorBlock,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	push	dword ptr  @247idTimer
	push	dword ptr [ebp+08h];	hwnd
	push	dword ptr  habAnchorBlock
	call	WinStartTimer
	add	esp,010h
	mov	dword ptr  @247idTimer,eax

; 2296         if (bDiagCountsCapable && stCFG.bSampleCounts)
	cmp	dword ptr  @24ebDiagCountsCapable,0h
	je	@BLBL430
	test	byte ptr  stCFG+018h,010h
	je	@BLBL430

; 2298           if (stCFG.wUpdateDelay <= 1000)
	mov	ax,word ptr  stCFG+0cfh
	cmp	ax,03e8h
	ja	@BLBL432

; 2300             iCPSdivisor = (1000 / stCFG.wUpdateDelay);
	xor	ecx,ecx
	mov	cx,word ptr  stCFG+0cfh
	mov	eax,03e8h
	cdq	
	idiv	ecx
	mov	dword ptr  @254iCPSdivisor,eax

; 2301             iCPSmultiplier = 0;
	mov	dword ptr  @255iCPSmultiplier,0h

; 2302             }
	jmp	@BLBL430
	align 010h
@BLBL432:

; 2305             iCPSmultiplier = (stCFG.wUpdateDelay / 1000);
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	mov	ecx,03e8h
	cdq	
	idiv	ecx
	mov	dword ptr  @255iCPSmultiplier,eax

; 2306             iCPSdivisor = 0;
	mov	dword ptr  @254iCPSdivisor,0h

; 2307             }

; 2308           }

; 2309         }
@BLBL430:

; 2310       break;
	jmp	@BLBL469
	align 04h
@BLBL486:

; 2312       if (lMessageDelay != 0)
	cmp	dword ptr  @24blMessageDelay,0h
	je	@BLBL434

; 2314         if (--lMessageDelay == 0)
	mov	eax,dword ptr  @24blMessageDelay
	dec	eax
	mov	dword ptr  @24blMessageDelay,eax
	cmp	dword ptr  @24blMessageDelay,0h
	jne	@BLBL436

; 2315           WinInvalidateRect(hwnd,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinInvalidateRect
	add	esp,0ch

; 2316         }
	jmp	@BLBL436
	align 010h
@BLBL434:

; 2319         if (bDiagCountsCapable && stCFG.iSampleCount)
	cmp	dword ptr  @24ebDiagCountsCapable,0h
	je	@BLBL437
	cmp	dword ptr  stCFG+0dfh,0h
	je	@BLBL437

; 2320           GetCountsSinceLast(&stIOctl,hCom,&stCounts);
	lea	eax,[ebp-0aeh];	stCounts
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetCountsSinceLast
	add	esp,0ch
@BLBL437:

; 2321         WinQueryWindowRect(hwndClient,&rcl);
	lea	eax,[ebp-014h];	rcl
	push	eax
	push	dword ptr  hwndClient
	call	WinQueryWindowRect
	add	esp,08h

; 2322         rcl.yTop = lStatusHeight;
	mov	eax,dword ptr  lStatusHeight
	mov	[ebp-08h],eax;	rcl

; 2323         rcl.yBottom = 0;
	mov	dword ptr [ebp-010h],0h;	rcl

; 2324         rcl.xLeft = 0;
	mov	dword ptr [ebp-014h],0h;	rcl

; 2325         ptl.y = ((lStatusHeight / 2) - 5);
	mov	eax,dword ptr  lStatusHeight
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	sub	eax,05h
	mov	[ebp-018h],eax;	ptl

; 2326         ptl.x = 6L;
	mov	dword ptr [ebp-01ch],06h;	ptl

; 2328         hps = WinGetPS(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	WinGetPS
	add	esp,04h
	mov	[ebp-04h],eax;	hps

; 2329         WinFillRect(hps,&rcl,stCFG.lStatusBackgrndColor);
	push	dword ptr  stCFG+0b5h
	lea	eax,[ebp-014h];	rcl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 2330         GpiSetBackColor(hps,stCFG.lStatusBackgrndColor);
	push	dword ptr  stCFG+0b5h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 2331         GpiSetColor(hps,stCFG.lStatusForegrndColor);
	push	dword ptr  stCFG+0b9h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 2332         GpiSetBackMix(hps,BM_OVERPAINT);
	push	02h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackMix
	add	esp,08h

; 2333         if (bDiagCountsCapable && stCFG.bSampleCounts)
	cmp	dword ptr  @24ebDiagCountsCapable,0h
	je	@BLBL438
	test	byte ptr  stCFG+018h,010h
	je	@BLBL438

; 2335           if (stCFG.iSampleCount > 1)
	cmp	dword ptr  stCFG+0dfh,01h
	jle	@BLBL439

; 2337             if ((ulTxByteCount -= aulTxByteCount[iWindow]) < 0)
	mov	ecx,dword ptr  @251iWindow
	mov	eax,dword ptr  @253ulTxByteCount
	sub	eax,dword ptr [ecx*04h+@250aulTxByteCount]
	mov	dword ptr  @253ulTxByteCount,eax
	cmp	dword ptr  @253ulTxByteCount,0h
	jge	@BLBL440

; 2338               ulTxByteCount = 0;
	mov	dword ptr  @253ulTxByteCount,0h
@BLBL440:

; 2339             if (iCPSmultiplier != 0)
	cmp	dword ptr  @255iCPSmultiplier,0h
	je	@BLBL441

; 2340               aulTxByteCount[iWindow] = (stCounts.ulBytesTransmitted / iCPSmultiplier);
	mov	ecx,dword ptr  @255iCPSmultiplier
	mov	eax,[ebp-0aah];	stCounts
	xor	edx,edx
	div	ecx
	mov	ecx,eax
	mov	eax,dword ptr  @251iWindow
	mov	dword ptr [eax*04h+@250aulTxByteCount],ecx
	jmp	@BLBL442
	align 010h
@BLBL441:

; 2342               aulTxByteCount[iWindow] = (stCounts.ulBytesTransmitted * iCPSdivisor);
	mov	ecx,dword ptr  @254iCPSdivisor
	imul	ecx,[ebp-0aah];	stCounts
	mov	eax,dword ptr  @251iWindow
	mov	dword ptr [eax*04h+@250aulTxByteCount],ecx
@BLBL442:

; 2343             ulTxByteCount += aulTxByteCount[iWindow];
	mov	ecx,dword ptr  @251iWindow
	mov	eax,dword ptr  @253ulTxByteCount
	add	eax,dword ptr [ecx*04h+@250aulTxByteCount]
	mov	dword ptr  @253ulTxByteCount,eax

; 2344             ulByteCount = (ulTxByteCount / stCFG.iSampleCount);
	mov	eax,dword ptr  @253ulTxByteCount
	cdq	
	idiv	dword ptr  stCFG+0dfh
	mov	[ebp-01f4h],eax;	ulByteCount

; 2345             }
	jmp	@BLBL443
	align 010h
@BLBL439:

; 2347     
; 2347         ulByteCount = stCounts.ulBytesTransmitted;
	mov	eax,[ebp-0aah];	stCounts
	mov	[ebp-01f4h],eax;	ulByteCount
@BLBL443:

; 2348           if (stCFG.bShowCounts)
	test	byte ptr  stCFG+016h,010h
	je	@BLBL444

; 2349             iLen = sprintf(szLastCounts,"Tx(%u, %u)",stCharCount.lWrite,ulByteCount);
	push	dword ptr [ebp-01f4h];	ulByteCount
	push	dword ptr  stCharCount+04h
	mov	edx,offset FLAT:@STAT54
	mov	eax,offset FLAT:@24aszLastCounts
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h
	mov	[ebp-048h],eax;	iLen
	jmp	@BLBL445
	align 010h
@BLBL444:

; 2351             iLen = sprintf(szLastCounts,"Tx(%u CPS)",ulByteCount);
	push	dword ptr [ebp-01f4h];	ulByteCount
	mov	edx,offset FLAT:@STAT55
	mov	eax,offset FLAT:@24aszLastCounts
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	mov	[ebp-048h],eax;	iLen
@BLBL445:

; 2352           GpiCharStringAt(hps,&ptl,iLen,szLastCounts);
	push	offset FLAT:@24aszLastCounts
	push	dword ptr [ebp-048h];	iLen
	lea	eax,[ebp-01ch];	ptl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	GpiCharStringAt
	add	esp,010h

; 2353           }
	jmp	@BLBL446
	align 010h
@BLBL438:

; 2355           if (stCFG.bShowCounts)
	test	byte ptr  stCFG+016h,010h
	je	@BLBL446

; 2357             iLen = sprintf(szLastCounts,"Tx(%u)",stCharCount.lWrite);
	push	dword ptr  stCharCount+04h
	mov	edx,offset FLAT:@STAT56
	mov	eax,offset FLAT:@24aszLastCounts
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	mov	[ebp-048h],eax;	iLen

; 2358             GpiCharStringAt(hps,&ptl,iLen,szLastCounts);
	push	offset FLAT:@24aszLastCounts
	push	dword ptr [ebp-048h];	iLen
	lea	eax,[ebp-01ch];	ptl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	GpiCharStringAt
	add	esp,010h

; 2359             }
@BLBL446:

; 2360         if (stCFG.bColumnDisplay)
	test	byte ptr  stCFG+018h,080h
	je	@BLBL448

; 2361           ptl.x += stRead.rcl.xLeft;
	mov	eax,dword ptr  stRead+013h
	add	eax,[ebp-01ch];	ptl
	mov	[ebp-01ch],eax;	ptl
	jmp	@BLBL449
	align 010h
@BLBL448:

; 2363           ptl.x += 240;
	mov	eax,[ebp-01ch];	ptl
	add	eax,0f0h
	mov	[ebp-01ch],eax;	ptl
@BLBL449:

; 2364         if (bDiagCountsCapable && stCFG.bSampleCounts)
	cmp	dword ptr  @24ebDiagCountsCapable,0h
	je	@BLBL450
	test	byte ptr  stCFG+018h,010h
	je	@BLBL450

; 2366           if (stCFG.iSampleCount > 1)
	cmp	dword ptr  stCFG+0dfh,01h
	jle	@BLBL451

; 2368             if ((ulRxByteCount -= aulRxByteCount[iWindow]) < 0)
	mov	ecx,dword ptr  @251iWindow
	mov	eax,dword ptr  @252ulRxByteCount
	sub	eax,dword ptr [ecx*04h+@24faulRxByteCount]
	mov	dword ptr  @252ulRxByteCount,eax
	cmp	dword ptr  @252ulRxByteCount,0h
	jge	@BLBL452

; 2369               ulRxByteCount = 0;
	mov	dword ptr  @252ulRxByteCount,0h
@BLBL452:

; 2370             if (iCPSmultiplier != 0)
	cmp	dword ptr  @255iCPSmultiplier,0h
	je	@BLBL453

; 2371               aulRxByteCount[iWindow] = (stCounts.ulBytesReceived / iCPSmultiplier);
	mov	ecx,dword ptr  @255iCPSmultiplier
	mov	eax,[ebp-0aeh];	stCounts
	xor	edx,edx
	div	ecx
	mov	ecx,eax
	mov	eax,dword ptr  @251iWindow
	mov	dword ptr [eax*04h+@24faulRxByteCount],ecx
	jmp	@BLBL454
	align 010h
@BLBL453:

; 2373               aulRxByteCount[iWindow] = (stCounts.ulBytesReceived * iCPSdivisor);
	mov	ecx,dword ptr  @254iCPSdivisor
	imul	ecx,[ebp-0aeh];	stCounts
	mov	eax,dword ptr  @251iWindow
	mov	dword ptr [eax*04h+@24faulRxByteCount],ecx
@BLBL454:

; 2374             ulRxByteCount += aulRxByteCount[iWindow];
	mov	ecx,dword ptr  @251iWindow
	mov	eax,dword ptr  @252ulRxByteCount
	add	eax,dword ptr [ecx*04h+@24faulRxByteCount]
	mov	dword ptr  @252ulRxByteCount,eax

; 2375             ulByteCount = (ulRxByteCount / stCFG.iSampleCount);
	mov	eax,dword ptr  @252ulRxByteCount
	cdq	
	idiv	dword ptr  stCFG+0dfh
	mov	[ebp-01f4h],eax;	ulByteCount

; 2376             if (++iWindow >= stCFG.iSampleCount)
	mov	eax,dword ptr  @251iWindow
	inc	eax
	mov	dword ptr  @251iWindow,eax
	mov	eax,dword ptr  stCFG+0dfh
	cmp	dword ptr  @251iWindow,eax
	jl	@BLBL456

; 2377               iWindow = 0;
	mov	dword ptr  @251iWindow,0h

; 2378             }
	jmp	@BLBL456
	align 010h
@BLBL451:

; 2380             ulByteCount = stCounts.ulBytesReceived;
	mov	eax,[ebp-0aeh];	stCounts
	mov	[ebp-01f4h],eax;	ulByteCount
@BLBL456:

; 2381           if (stCFG.bShowCounts)
	test	byte ptr  stCFG+016h,010h
	je	@BLBL457

; 2382             sprintf(szCounts,"Rx(%u, %u)",stCharCount.lRead,ulByteCount);
	push	dword ptr [ebp-01f4h];	ulByteCount
	push	dword ptr  stCharCount
	mov	edx,offset FLAT:@STAT57
	lea	eax,[ebp-01eeh];	szCounts
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h
	jmp	@BLBL458
	align 010h
@BLBL457:

; 2384             sprintf(szCounts,"Rx(%u CPS)",ulByteCount);
	push	dword ptr [ebp-01f4h];	ulByteCount
	mov	edx,offset FLAT:@STAT58
	lea	eax,[ebp-01eeh];	szCounts
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
@BLBL458:

; 2385           sprintf(&szLastCounts[iLen]," %s",szCounts);
	lea	eax,[ebp-01eeh];	szCounts
	push	eax
	mov	edx,offset FLAT:@STAT59
	mov	eax,[ebp-048h];	iLen
	add	eax,offset FLAT:@24aszLastCounts
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 2386           GpiCharStringAt(hps,&ptl,strlen(szCounts),szCounts);
	lea	eax,[ebp-01eeh];	szCounts
	call	strlen
	lea	ecx,[ebp-01eeh];	szCounts
	push	ecx
	push	eax
	lea	eax,[ebp-01ch];	ptl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	GpiCharStringAt
	add	esp,010h

; 2387           }
	jmp	@BLBL459
	align 010h
@BLBL450:

; 2390           if (stCFG.bShowCounts)
	test	byte ptr  stCFG+016h,010h
	je	@BLBL459

; 2392             sprintf(szCounts,"Rx(%u)",stCharCount.lRead);
	push	dword ptr  stCharCount
	mov	edx,offset FLAT:@STAT5a
	lea	eax,[ebp-01eeh];	szCounts
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 2393             sprintf(&szLastCounts[iLen]," %s",szCounts);
	lea	eax,[ebp-01eeh];	szCounts
	push	eax
	mov	edx,offset FLAT:@STAT5b
	mov	eax,[ebp-048h];	iLen
	add	eax,offset FLAT:@24aszLastCounts
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 2394             GpiCharStringAt(hps,&ptl,strlen(szCounts),szCounts);
	lea	eax,[ebp-01eeh];	szCounts
	call	strlen
	lea	ecx,[ebp-01eeh];	szCounts
	push	ecx
	push	eax
	lea	eax,[ebp-01ch];	ptl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	GpiCharStringAt
	add	esp,010h

; 2395             }

; 2396           }
@BLBL459:

; 2397         if ((stCFG.bColumnDisplay && ((stCFG.lReadColBackgrndColor == stCFG.lStatusBackgrndColor) ||
	test	byte ptr  stCFG+018h,080h
	je	@BLBL463
	mov	eax,dword ptr  stCFG+0b5h
	cmp	dword ptr  stCFG+0bdh,eax
	je	@BLBL465

; 2398                                      (stCFG.lWriteColBackgrndColor == stCFG.lStatusBackgrndColor))) ||
	mov	eax,dword ptr  stCFG+0b5h
	cmp	dword ptr  stCFG+0c5h,eax
	je	@BLBL465
@BLBL463:

; 2399             (stCFG.lStatusBackgrndColor == stCFG.lWriteBackgrndColor))
	mov	eax,dword ptr  stCFG+0adh
	cmp	dword ptr  stCFG+0b5h,eax
	jne	@BLBL466
@BLBL465:

; 2401           rcl.yBottom = (rcl.yTop - 1);
	mov	eax,[ebp-08h];	rcl
	dec	eax
	mov	[ebp-010h],eax;	rcl

; 2402           if (stCFG.lStatusBackgrndColor != CLR_WHITE)
	cmp	dword ptr  stCFG+0b5h,0fffffffeh
	je	@BLBL467

; 2403             WinFillRect(hps,&rcl,(stCFG.lStatusBackgrndColor ^ stCFG.lStatusBackgrndColor));
	mov	eax,dword ptr  stCFG+0b5h
	xor	eax,dword ptr  stCFG+0b5h
	push	eax
	lea	eax,[ebp-014h];	rcl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch
	jmp	@BLBL466
	align 010h
@BLBL467:

; 2405             WinFillRect(hps,&rcl,CLR_BLACK);
	push	0ffffffffh
	lea	eax,[ebp-014h];	rcl
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 2406           }
@BLBL466:

; 2407         WinReleasePS(hps);
	push	dword ptr [ebp-04h];	hps
	call	WinReleasePS
	add	esp,04h

; 2408         }
@BLBL436:

; 2409       break;
	jmp	@BLBL469
	align 04h
@BLBL487:

; 2411       return(WinDefWindowProc(hwnd, msg, mp1, mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefWindowProc
	add	esp,01ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL469
	align 04h
@BLBL470:
	cmp	eax,01h
	je	@BLBL471
	cmp	eax,020h
	je	@BLBL472
	cmp	eax,074h
	je	@BLBL479
	cmp	eax,023h
	je	@BLBL480
	cmp	eax,0801ah
	je	@BLBL481
	cmp	eax,02h
	je	@BLBL482
	cmp	eax,08019h
	je	@BLBL483
	cmp	eax,08027h
	je	@BLBL484
	cmp	eax,08007h
	je	@BLBL485
	cmp	eax,024h
	je	@BLBL486
	jmp	@BLBL487
	align 04h
@BLBL469:

; 2413   return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
StatusProc	endp

; 2417   {
	align 010h

	public ParseParms
ParseParms	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah
	sub	esp,08h

; 2420   for (lIndex = 1;lIndex < argc;lIndex++)
	mov	dword ptr [ebp-04h],01h;	lIndex
	mov	eax,[ebp+08h];	argc
	cmp	[ebp-04h],eax;	lIndex
	jge	@BLBL488
	align 010h
@BLBL489:

; 2421     {
; 2422     if ((argv[lIndex][0] == '/') || (argv[lIndex][0] == '-'))
	mov	eax,[ebp+0ch];	argv
	mov	ecx,[ebp-04h];	lIndex
	mov	eax,dword ptr [eax+ecx*04h]
	cmp	byte ptr [eax],02fh
	je	@BLBL490
	mov	eax,[ebp+0ch];	argv
	mov	ecx,[ebp-04h];	lIndex
	mov	eax,dword ptr [eax+ecx*04h]
	cmp	byte ptr [eax],02dh
	jne	@BLBL491
@BLBL490:

; 2423       {
; 2424       switch (argv[lIndex][1] & 0xdf)
	mov	ecx,[ebp+0ch];	argv
	mov	eax,[ebp-04h];	lIndex
	mov	ecx,dword ptr [ecx+eax*04h]
	xor	eax,eax
	mov	al,[ecx+01h]
	and	eax,0dfh
	jmp	@BLBL507
	align 04h
@BLBL508:

; 2425         {
; 2426         case 'V':
; 2427           if (strlen(&argv[lIndex][2]) != 0)
	mov	eax,[ebp+0ch];	argv
	mov	ecx,[ebp-04h];	lIndex
	mov	eax,dword ptr [eax+ecx*04h]
	add	eax,02h
	call	strlen
	test	eax,eax
	je	@BLBL492

; 2428             strcpy(szPipeServerName,&argv[lIndex][2]);
	mov	edx,[ebp+0ch];	argv
	mov	eax,[ebp-04h];	lIndex
	mov	edx,dword ptr [edx+eax*04h]
	add	edx,02h
	mov	eax,offset FLAT:szPipeServerName
	call	strcpy
@BLBL492:

; 2429           bLaunchShutdownServer = TRUE;
	mov	dword ptr  bLaunchShutdownServer,01h

; 2430           break;
	jmp	@BLBL506
	align 04h
@BLBL509:

; 2431         case 'T':
; 2432           if (strlen(&argv[lIndex][2]) != 0)
	mov	eax,[ebp+0ch];	argv
	mov	ecx,[ebp-04h];	lIndex
	mov	eax,dword ptr [eax+ecx*04h]
	add	eax,02h
	call	strlen
	test	eax,eax
	je	@BLBL493

; 2433             strcpy(szIPCpipeName,&argv[lIndex][2]);
	mov	edx,[ebp+0ch];	argv
	mov	eax,[ebp-04h];	lIndex
	mov	edx,dword ptr [edx+eax*04h]
	add	edx,02h
	mov	eax,offset FLAT:szIPCpipeName
	call	strcpy
@BLBL493:

; 2434           bLaunchShutdownServer = TRUE;
	mov	dword ptr  bLaunchShutdownServer,01h

; 2435           break;
	jmp	@BLBL506
	align 04h
@BLBL510:

; 2436         case 'L':
; 2437           bLaunchShutdownServer = TRUE;
	mov	dword ptr  bLaunchShutdownServer,01h

; 2438           if (argv[lIndex][2] != 0)
	mov	eax,[ebp+0ch];	argv
	mov	ecx,[ebp-04h];	lIndex
	mov	eax,dword ptr [eax+ecx*04h]
	cmp	byte ptr [eax+02h],0h
	je	@BLBL494

; 2439             {
; 2440             chPipeDebug = argv[lIndex][2];
	mov	eax,[ebp+0ch];	argv
	mov	ecx,[ebp-04h];	lIndex
	mov	eax,dword ptr [eax+ecx*04h]
	mov	al,[eax+02h]
	mov	byte ptr  chPipeDebug,al

; 2441             bShowServerProcess = TRUE;
	mov	dword ptr  bShowServerProcess,01h

; 2442             }
	jmp	@BLBL495
	align 010h
@BLBL494:

; 2443           else
; 2444             chPipeDebug = '0';
	mov	byte ptr  chPipeDebug,030h
@BLBL495:

; 2445           break;
	jmp	@BLBL506
	align 04h
@BLBL511:

; 2446         case 'P':
; 2447           if (argv[lIndex][2] == '-')
	mov	eax,[ebp+0ch];	argv
	mov	ecx,[ebp-04h];	lIndex
	mov	eax,dword ptr [eax+ecx*04h]
	cmp	byte ptr [eax+02h],02dh
	jne	@BLBL496

; 2448             bUseProfile = FALSE;
	mov	dword ptr  bUseProfile,0h
	jmp	@BLBL497
	align 010h
@BLBL496:

; 2449           else
; 2450             {
; 2451             if (argv[lIndex][2] != 0)
	mov	eax,[ebp+0ch];	argv
	mov	ecx,[ebp-04h];	lIndex
	mov	eax,dword ptr [eax+ecx*04h]
	cmp	byte ptr [eax+02h],0h
	je	@BLBL497

; 2452               strcpy(szCOMscopeAppName,&argv[lIndex][2]);
	mov	edx,[ebp+0ch];	argv
	mov	eax,[ebp-04h];	lIndex
	mov	edx,dword ptr [edx+eax*04h]
	add	edx,02h
	mov	eax,offset FLAT:szCOMscopeAppName
	call	strcpy

; 2453             }
@BLBL497:

; 2454           break;
	jmp	@BLBL506
	align 04h
@BLBL512:

; 2455         case 'S':
; 2456           if (argv[lIndex][2] == '-')
	mov	eax,[ebp+0ch];	argv
	mov	ecx,[ebp-04h];	lIndex
	mov	eax,dword ptr [eax+ecx*04h]
	cmp	byte ptr [eax+02h],02dh
	jne	@BLBL499

; 2457             bUseProfile = FALSE;
	mov	dword ptr  bUseProfile,0h
	jmp	@BLBL500
	align 010h
@BLBL499:

; 2458           else
; 2459             {
; 2460             bSearchProfileApps = TRUE;
	mov	dword ptr  bSearchProfileApps,01h

; 2461             if (argv[lIndex][2] != 0)
	mov	eax,[ebp+0ch];	argv
	mov	ecx,[ebp-04h];	lIndex
	mov	eax,dword ptr [eax+ecx*04h]
	cmp	byte ptr [eax+02h],0h
	je	@BLBL500

; 2462               strcpy(szCOMscopeAppName,&argv[lIndex][2]);
	mov	edx,[ebp+0ch];	argv
	mov	eax,[ebp-04h];	lIndex
	mov	edx,dword ptr [edx+eax*04h]
	add	edx,02h
	mov	eax,offset FLAT:szCOMscopeAppName
	call	strcpy

; 2463             }
@BLBL500:

; 2464           break;
	jmp	@BLBL506
	align 04h
@BLBL513:

; 2465         case 'F':
; 2466           strcpy(szFontFileName,&argv[lIndex][2]);
	mov	edx,[ebp+0ch];	argv
	mov	eax,[ebp-04h];	lIndex
	mov	edx,dword ptr [edx+eax*04h]
	add	edx,02h
	mov	eax,offset FLAT:szFontFileName
	call	strcpy

; 2467           bNewFontFile = TRUE;
	mov	dword ptr  bNewFontFile,01h

; 2468           break;
	jmp	@BLBL506
	align 04h
@BLBL514:

; 2469         case 'D':
; 2470           strcpy(szDataFileSpec,&argv[lIndex][2]);
	mov	edx,[ebp+0ch];	argv
	mov	eax,[ebp-04h];	lIndex
	mov	edx,dword ptr [edx+eax*04h]
	add	edx,02h
	mov	eax,offset FLAT:szDataFileSpec
	call	strcpy

; 2471           break;
	jmp	@BLBL506
	align 04h
@BLBL515:

; 2472         case 'Y':
; 2473           iDebugLevel = atoi(&argv[lIndex][2]);
	mov	eax,[ebp+0ch];	argv
	mov	ecx,[ebp-04h];	lIndex
	mov	eax,dword ptr [eax+ecx*04h]
	add	eax,02h
	call	atoi
	mov	dword ptr  iDebugLevel,eax

; 2474           break;
	jmp	@BLBL506
	align 04h
@BLBL516:

; 2475         case 'X':
; 2476           if ((argv[lIndex][2] & 0xdf) == 'C')
	mov	eax,[ebp+0ch];	argv
	mov	ecx,[ebp-04h];	lIndex
	mov	eax,dword ptr [eax+ecx*04h]
	mov	al,[eax+02h]
	and	al,0dfh
	cmp	al,043h
	jne	@BLBL502

; 2477             bRemoteClient = TRUE;
	mov	dword ptr  bRemoteClient,01h
	jmp	@BLBL503
	align 010h
@BLBL502:

; 2478           else
; 2479             bRemoteServer = TRUE;
	mov	dword ptr  bRemoteServer,01h
@BLBL503:

; 2480           bRemoteAccess = TRUE;
	mov	dword ptr  bRemoteAccess,01h

; 2481           break;
	jmp	@BLBL506
	align 04h
	jmp	@BLBL506
	align 04h
@BLBL507:
	cmp	eax,056h
	je	@BLBL508
	cmp	eax,054h
	je	@BLBL509
	cmp	eax,04ch
	je	@BLBL510
	cmp	eax,050h
	je	@BLBL511
	cmp	eax,053h
	je	@BLBL512
	cmp	eax,046h
	je	@BLBL513
	cmp	eax,044h
	je	@BLBL514
	cmp	eax,059h
	je	@BLBL515
	cmp	eax,058h
	je	@BLBL516
@BLBL506:

; 2482         }
; 2483       }
	jmp	@BLBL504
	align 010h
@BLBL491:

; 2484     else
; 2485       {
; 2486       strcpy(szCmdLineIniFileSpec,argv[lIndex]);
	mov	edx,[ebp+0ch];	argv
	mov	eax,[ebp-04h];	lIndex
	mov	edx,dword ptr [edx+eax*04h]
	mov	eax,offset FLAT:szCmdLineIniFileSpec
	call	strcpy

; 2487       bEditCmdLineIniFile = TRUE;
	mov	dword ptr  bEditCmdLineIniFile,01h

; 2488       }
@BLBL504:

; 2489     }

; 2420   for (lIndex = 1;lIndex < argc;lIndex++)
	mov	eax,[ebp-04h];	lIndex
	inc	eax
	mov	[ebp-04h],eax;	lIndex
	mov	eax,[ebp+08h];	argc
	cmp	[ebp-04h],eax;	lIndex
	jl	@BLBL489
@BLBL488:

; 2490   }
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
ParseParms	endp
CODE32	ends
end
