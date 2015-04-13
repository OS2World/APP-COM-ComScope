	title	p:\COMscope\wincmd.c
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
	public	ulServerMessage
	extrn	HelpHelpForHelp:proc
	extrn	DisplayHelpPanel:proc
	extrn	HelpIndex:proc
	extrn	WinPostMsg:proc
	extrn	DosLoadModule:proc
	extrn	DosQueryProcAddr:proc
	extrn	DosFreeModule:proc
	extrn	WinSendMsg:proc
	extrn	MenuItemCheck:proc
	extrn	WinInvalidateRect:proc
	extrn	SetupRowScrolling:proc
	extrn	KillDisplayThread:proc
	extrn	RowDisplayThread:proc
	extrn	DosCreateThread:proc
	extrn	ClearRowScrollBar:proc
	extrn	ColumnDisplayThread:proc
	extrn	fnwpEventDispDlgProc:proc
	extrn	WinDlgBox:proc
	extrn	_sprintfieee:proc
	extrn	fnwpSetColorDlg:proc
	extrn	fnwpTraceEventDlgProc:proc
	extrn	COMscopeOpenFilterProc:proc
	extrn	GetFileName:proc
	extrn	strcmp:proc
	extrn	strcpy:proc
	extrn	WriteCaptureFile:proc
	extrn	StartSystem:proc
	extrn	WinQuerySysPointer:proc
	extrn	WinSetPointer:proc
	extrn	DosFreeMem:proc
	extrn	DosAllocMem:proc
	extrn	ReadCaptureFile:proc
	extrn	MenuItemEnable:proc
	extrn	ErrorNotify:proc
	extrn	WinDestroyPointer:proc
	extrn	KillMonitorThread:proc
	extrn	memcpy:proc
	extrn	SetupColScrolling:proc
	extrn	ClearColScrollBar:proc
	extrn	DosPostEventSem:proc
	extrn	IncrementFileExt:proc
	extrn	strlen:proc
	extrn	MonitorThread:proc
	extrn	fnwpCountsSetupDlgProc:proc
	extrn	BreakOn:proc
	extrn	BreakOff:proc
	extrn	fnwpHdwModemControlDlg:proc
	extrn	ForceXon:proc
	extrn	ForceXoff:proc
	extrn	SendXonXoff:proc
	extrn	FlushComBuffer:proc
	extrn	MessageBox:proc
	extrn	DisplayCharacterInfo:proc
	extrn	SearchCaptureBuffer:proc
	extrn	fnwpSearchConfigDlgProc:proc
	extrn	fnwpMonitorSleepDlg:proc
	extrn	AboutBoxDlgProc:proc
	extrn	fnwpUpdateStatusDlg:proc
	extrn	fnwpBufferSizeDlg:proc
	extrn	DosClose:proc
	extrn	OpenPort:proc
	extrn	WinDismissDlg:proc
	extrn	GetDCB:proc
	extrn	WinSetWindowText:proc
	extrn	WinMessageBox:proc
	extrn	_fullDump:dword
	extrn	stCOMiCFG:byte
	extrn	hwndHelpInstance:dword
	extrn	pfnInstallDevice:dword
	extrn	hwndStatDev:dword
	extrn	hwndStatModemIn:dword
	extrn	hwndStatModemOut:dword
	extrn	hwndStatRcvBuf:dword
	extrn	hwndStatXmitBuf:dword
	extrn	hwndFrame:dword
	extrn	hwndStatus:dword
	extrn	stWrite:byte
	extrn	stRead:byte
	extrn	bMinimized:dword
	extrn	bMaximized:dword
	extrn	wASCIIfont:word
	extrn	wHEXfont:word
	extrn	hwndClient:dword
	extrn	bNoPaint:dword
	extrn	usLastClientPopupItem:word
	extrn	stRow:byte
	extrn	fLastScroll:dword
	extrn	bStopDisplayThread:dword
	extrn	tidDisplayThread:dword
	extrn	hwndStatAll:dword
	extrn	szDataFileSpec:byte
	extrn	szEntryDataFileSpec:byte
	extrn	hProfileInstance:dword
	extrn	pfnSaveProfileString:dword
	extrn	bBufferWrapped:dword
	extrn	lWriteIndex:dword
	extrn	pwCaptureBuffer:dword
	extrn	pfnManageProfile:dword
	extrn	pwScrollBuffer:dword
	extrn	lScrollCount:dword
	extrn	ulCalcSleepCount:dword
	extrn	ulMonitorSleepCount:dword
	extrn	hevWaitCOMiDataSem:dword
	extrn	szCaptureFileName:byte
	extrn	szCaptureFileSpec:byte
	extrn	szEntryCaptureFileSpec:byte
	extrn	bStopMonitorThread:dword
	extrn	tidMonitorThread:dword
	extrn	hCom:dword
	extrn	bBreakOn:dword
	extrn	stIOctl:byte
	extrn	bSendNextKeystroke:dword
	extrn	pfnDialog:dword
	extrn	stComCtl:byte
	extrn	bSearchInit:dword
	extrn	bPortActive:dword
	extrn	szCurrentPortName:byte
DATA32	segment
@STAT1	db "CFG_DEB",0h
@STAT2	db "InstallDevice",0h
	align 04h
@STAT3	db "Write Request Event Disp"
db "lay Colors",0h
	align 04h
@STAT4	db "Read Request Event Displ"
db "ay Colors",0h
	align 04h
@STAT5	db "Device I/O Control Call "
db "Event Display Colors",0h
	align 04h
@STAT6	db "Modem Input Signal Event"
db " Display Colors",0h
@STAT7	db "Modem Output Signal Even"
db "t Display Colors",0h
	align 04h
@STAT8	db "Communications Error Eve"
db "nt Display Colors",0h
	align 04h
@STAT9	db "Applicatin Open/Close Ev"
db "ent Display Colors",0h
	align 04h
@STATa	db "Time-relational Receive "
db "Data Display Colors",0h
@STATb	db "Time-relational Transmit"
db " Data Display Colors",0h
	align 04h
@STATc	db "%s - Data File to Save t"
db "o",0h
	align 04h
@STATd	db "PROFDEB",0h
@STATe	db "SaveProfileString",0h
	align 04h
@STATf	db "Data File",0h
	align 04h
@STAT10	db "%s - Save Data As",0h
	align 04h
@STAT11	db "PROFDEB",0h
@STAT12	db "SaveProfileString",0h
	align 04h
@STAT13	db "Data File",0h
	align 04h
@STAT14	db "PROFDEB",0h
@STAT15	db "ManageProfile",0h
	align 04h
@STAT16	db "Select file to Load.",0h
	align 04h
@STAT17	db "PROFDEB",0h
@STAT18	db "SaveProfileString",0h
	align 04h
@STAT19	db "Data File",0h
	align 04h
@STAT1a	db "Unable to allocate Scrol"
db "l Buffer (Loading Data)."
db 0h
	align 04h
@STAT1b	db "Unable to allocate Scrol"
db "l Buffer (View Data).",0h
	align 04h
@STAT1c	db "PROFDEB",0h
@STAT1d	db "SaveProfileString",0h
	align 04h
@STAT1e	db "Capture File",0h
	align 04h
@STAT1f	db "CTL_DEB",0h
@STAT20	db "HdwBaudRateDialog",0h
	align 04h
@STAT21	db "COM control function ",022h,"Hd"
db "wBaudRateDialog",022h," not fou"
db "nd",0h
	align 04h
@STAT22	db "Unable to load COM contr"
db "ol library",0h
	align 04h
@STAT23	db "CTL_DEB",0h
@STAT24	db "HdwProtocolDialog",0h
	align 04h
@STAT25	db "COM control function ",022h,"Hd"
db "wProtocolDialog",022h," not fou"
db "nd",0h
	align 04h
@STAT26	db "Unable to load COM contr"
db "ol library",0h
	align 04h
@STAT27	db "CTL_DEB",0h
@STAT28	db "HdwFilterDialog",0h
@STAT29	db "COM control function ",022h,"Hd"
db "wFilterDialog",022h," not found"
db 0h
	align 04h
@STAT2a	db "Unable to load COM contr"
db "ol library",0h
	align 04h
@STAT2b	db "CTL_DEB",0h
@STAT2c	db "HdwFIFOsetupDialog",0h
	align 04h
@STAT2d	db "COM control function ",022h,"Hd"
db "wFIFOsetupDialog",022h," not fo"
db "und",0h
@STAT2e	db "Unable to load COM contr"
db "ol library",0h
	align 04h
@STAT2f	db "CTL_DEB",0h
@STAT30	db "HdwHandshakeDialog",0h
	align 04h
@STAT31	db "COM control function ",022h,"Hd"
db "wHandshakeDialog",022h," not fo"
db "und",0h
@STAT32	db "Unable to load COM contr"
db "ol library",0h
	align 04h
@STAT33	db "CTL_DEB",0h
@STAT34	db "HdwTimeoutDialog",0h
	align 04h
@STAT35	db "COM control function ",022h,"Hd"
db "wTimeoutDialog",022h," not foun"
db "d",0h
	align 04h
@STAT36	db "Unable to load COM contr"
db "ol library",0h
@STAT37	db "  ",0h
	align 04h
@STAT38	db "Pattern not Found",0h
	align 04h
@STAT39	db "Pattern found at Index %"
db "u",0h
@STAT3a	db "  ",0h
	align 04h
@STAT3b	db "Pattern not Found",0h
	align 04h
@STAT3c	db "Pattern found at Index %"
db "u",0h
	align 04h
@STAT3d	db "CFG_DEB",0h
@STAT3e	db "PortSelectDialog",0h
	align 04h
@STAT3f	db "COMscope -> %s",0h
	align 04h
@STAT40	db "No Available COMscope De"
db "vices",0h
	align 04h
@STAT41	db "All COMscope accessable "
db "ports have been activate"
db "d by other COMscope sess"
db "ions.",0h
	align 04h
@STAT42	db "No COM Devices Defined",0h
	align 04h
@STAT43	db "Select ",022h,"Device | Device "
db "Install",022h," to install COM "
db "support",0h
DATA32	ends
BSS32	segment
ulServerMessage	dd 0h
	align 04h
comm	iDeviceCount:dword
comm	szTempPath:byte:0105h
@cstColor	db 05ah DUP (0h)
BSS32	ends
CODE32	segment

; 126   {
	align 010h

	public WinCommand
WinCommand	proc
	push	ebp
	mov	ebp,esp
	sub	esp,078h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,01eh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	push	ebx
	sub	esp,0ch

; 137   switch (Command)
	xor	eax,eax
	mov	ax,[ebp+0ch];	Command
	jmp	@BLBL205
	align 04h
@BLBL206:

; 138     {
; 139     case IDM_HELPFORHELP:
; 140       HelpHelpForHelp();
	call	HelpHelpForHelp

; 141       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL207:

; 142     case IDM_HELPEXTEND:
; 143       DisplayHelpPanel(HLPP_GENERAL);
	push	07534h
	call	DisplayHelpPanel
	add	esp,04h

; 144       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL208:

; 145     case IDM_HELPINDEX:
; 146       HelpIndex();
	call	HelpIndex

; 147       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL209:

; 148     case IDM_HELPKEYS:
; 149       DisplayHelpPanel(HLPP_KEYS);
	push	07533h
	call	DisplayHelpPanel
	add	esp,04h

; 150       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL210:

; 151     case HM_QUERY_KEYS_HELP:
; 152       return (MRESULT)HLPP_KEYS;
	mov	eax,07533h
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL211:

; 153     case IDM_EXIT:
; 154       WinPostMsg(hWnd,WM_CLOSE,0L,0L);
	push	0h
	push	0h
	push	029h
	push	dword ptr [ebp+08h];	hWnd
	call	WinPostMsg
	add	esp,010h

; 155       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL212:

; 156     case IDM_INSTALL:
; 157       if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-060h];	hMod
	push	eax
	push	offset FLAT:@STAT1
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL1

; 158         {
; 159         stCOMiCFG.pszPortName = NULL;
	mov	dword ptr  stCOMiCFG+014h,0h

; 160         stCOMiCFG.hwndHelpInstance = hwndHelpInstance;
	mov	eax,dword ptr  hwndHelpInstance
	mov	dword ptr  stCOMiCFG+0ah,eax

; 161         stCOMiCFG.bInstallCOMscope = TRUE;
	or	byte ptr  stCOMiCFG+04bh,02h

; 162         stCOMiCFG.bInitInstall = FALSE;
	and	byte ptr  stCOMiCFG+04bh,0fbh

; 163         stCOMiCFG.pszRemoveOldDriverSpec == NULL;
; 164 //        stCOMiCFG.ulMaxDeviceCount = 2;
; 165         if (DosQueryProcAddr(hMod,0,"InstallDevice",(PFN *)&pfnInstallDevice) == NO_ERROR)
	push	offset FLAT:pfnInstallDevice
	push	offset FLAT:@STAT2
	push	0h
	push	dword ptr [ebp-060h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL2

; 166           pfnInstallDevice(&stCOMiCFG);
	push	offset FLAT:stCOMiCFG
	call	dword ptr  pfnInstallDevice
	add	esp,04h
@BLBL2:

; 167         DosFreeModule(hMod);
	push	dword ptr [ebp-060h];	hMod
	call	DosFreeModule
	add	esp,04h

; 168         }
@BLBL1:

; 169       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL213:

; 170     case IDM_SURFACE_THIS:
; 171       WinSendMsg(hwndStatDev,WM_ACTIVATE,0L,0L);
	push	0h
	push	0h
	push	0dh
	push	dword ptr  hwndStatDev
	call	WinSendMsg
	add	esp,010h

; 172       WinSendMsg(hwndStatModemIn,WM_ACTIVATE,0L,0L);
	push	0h
	push	0h
	push	0dh
	push	dword ptr  hwndStatModemIn
	call	WinSendMsg
	add	esp,010h

; 173       WinSendMsg(hwndStatModemOut,WM_ACTIVATE,0L,0L);
	push	0h
	push	0h
	push	0dh
	push	dword ptr  hwndStatModemOut
	call	WinSendMsg
	add	esp,010h

; 174       WinSendMsg(hwndStatRcvBuf,WM_ACTIVATE,0L,0L);
	push	0h
	push	0h
	push	0dh
	push	dword ptr  hwndStatRcvBuf
	call	WinSendMsg
	add	esp,010h

; 175       WinSendMsg(hwndStatXmitBuf,WM_ACTIVATE,0L,0L);
	push	0h
	push	0h
	push	0dh
	push	dword ptr  hwndStatXmitBuf
	call	WinSendMsg
	add	esp,010h

; 176       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL214:

; 177     case IDM_SURFACE_ALL:
; 178       ulServerMessage = UM_SURFACE_ALL;
	mov	dword ptr  ulServerMessage,08023h

; 179       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL215:

; 180     case IDM_STICKY_MENUS:
; 181       if (pstCFG->bStickyMenus)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+016h],08h
	je	@BLBL3

; 182         {
; 183         MenuItemCheck(hwndFrame,IDM_STICKY_MENUS,FALSE);
	push	0h
	push	081ah
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 184         pstCFG->bStickyMenus = FALSE;
	mov	eax,[ebp+010h];	pstCFG
	and	byte ptr [eax+016h],0f7h

; 185         }
	jmp	@BLBL4
	align 010h
@BLBL3:

; 186       else
; 187         {
; 188         MenuItemCheck(hwndFrame,IDM_STICKY_MENUS,TRUE);
	push	01h
	push	081ah
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 189         pstCFG->bStickyMenus = TRUE;
	mov	eax,[ebp+010h];	pstCFG
	or	byte ptr [eax+016h],08h

; 190         }
@BLBL4:

; 191       break;
	jmp	@BLBL204
	align 04h
@BLBL216:

; 192     case IDM_SILENT_STATUS:
; 193       if (pstCFG->bSilentStatus)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+016h],01h
	je	@BLBL5

; 194         pstCFG->bSilentStatus = FALSE;
	mov	eax,[ebp+010h];	pstCFG
	and	byte ptr [eax+016h],0feh
	jmp	@BLBL6
	align 010h
@BLBL5:

; 195       else
; 196         pstCFG->bSilentStatus = TRUE;
	mov	eax,[ebp+010h];	pstCFG
	or	byte ptr [eax+016h],01h
@BLBL6:

; 197       MenuItemCheck(hwndFrame,IDM_SILENT_STATUS,pstCFG->bSilentStatus);
	mov	eax,[ebp+010h];	pstCFG
	mov	al,[eax+016h]
	and	eax,01h
	push	eax
	push	081fh
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 198 //      WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
; 199       break;
	jmp	@BLBL204
	align 04h
@BLBL217:

; 200     case IDMPU_SILENT_STATUS:
; 201       WinPostMsg(hwndStatus,WM_COMMAND,(MPARAM)IDMPU_SILENT_STATUS,0L);
	push	0h
	push	0fb2h
	push	020h
	push	dword ptr  hwndStatus
	call	WinPostMsg
	add	esp,010h

; 202       break;
	jmp	@BLBL204
	align 04h
@BLBL218:

; 203     case IDMPU_LAST_COUNT:
; 204       WinPostMsg(hwndStatus,WM_COMMAND,(MPARAM)IDMPU_LAST_COUNT,0L);
	push	0h
	push	0fb1h
	push	020h
	push	dword ptr  hwndStatus
	call	WinPostMsg
	add	esp,010h

; 205       break;
	jmp	@BLBL204
	align 04h
@BLBL219:

; 206     case IDMPU_LAST_MSG:
; 207       WinPostMsg(hwndStatus,WM_COMMAND,(MPARAM)IDMPU_LAST_MSG,0L);
	push	0h
	push	0fa3h
	push	020h
	push	dword ptr  hwndStatus
	call	WinPostMsg
	add	esp,010h

; 208       break;
	jmp	@BLBL204
	align 04h
@BLBL220:

; 209     case IDMPU_COLORS:
; 210       WinPostMsg(hwndStatus,WM_COMMAND,(MPARAM)IDMPU_COLORS,0L);
	push	0h
	push	0fa4h
	push	020h
	push	dword ptr  hwndStatus
	call	WinPostMsg
	add	esp,010h

; 211       break;
	jmp	@BLBL204
	align 04h
@BLBL221:

; 212     case IDMPU_LEX_ASCII_FONT:
; 213       WinPostMsg(stWrite.hwnd,WM_COMMAND,(MPARAM)IDMPU_ASCII_FONT,0L);
	push	0h
	push	0fa8h
	push	020h
	push	dword ptr  stWrite+0bh
	call	WinPostMsg
	add	esp,010h

; 214       WinPostMsg(stRead.hwnd,WM_COMMAND,(MPARAM)IDMPU_ASCII_FONT,0L);
	push	0h
	push	0fa8h
	push	020h
	push	dword ptr  stRead+0bh
	call	WinPostMsg
	add	esp,010h

; 215       break;
	jmp	@BLBL204
	align 04h
@BLBL222:

; 216     case IDMPU_LEX_HEX_FONT:
; 217       WinPostMsg(stWrite.hwnd,WM_COMMAND,(MPARAM)IDMPU_HEX_FONT,0L);
	push	0h
	push	0fa9h
	push	020h
	push	dword ptr  stWrite+0bh
	call	WinPostMsg
	add	esp,010h

; 218       WinPostMsg(stRead.hwnd,WM_COMMAND,(MPARAM)IDMPU_HEX_FONT,0L);
	push	0h
	push	0fa9h
	push	020h
	push	dword ptr  stRead+0bh
	call	WinPostMsg
	add	esp,010h

; 219       break;
	jmp	@BLBL204
	align 04h
@BLBL223:

; 220     case IDMPU_SYNC_TX:
; 221       WinPostMsg(stWrite.hwnd,WM_COMMAND,(MPARAM)IDMPU_SYNC,0L);
	push	0h
	push	0fa6h
	push	020h
	push	dword ptr  stWrite+0bh
	call	WinPostMsg
	add	esp,010h

; 222       break;
	jmp	@BLBL204
	align 04h
@BLBL224:

; 223     case IDMPU_SYNC_RX:
; 224       WinPostMsg(stRea
; 224 d.hwnd,WM_COMMAND,(MPARAM)IDMPU_SYNC,0L);
	push	0h
	push	0fa6h
	push	020h
	push	dword ptr  stRead+0bh
	call	WinPostMsg
	add	esp,010h

; 225       break;
	jmp	@BLBL204
	align 04h
@BLBL225:

; 226     case IDMPU_TX_COLORS:
; 227       WinPostMsg(stWrite.hwnd,WM_COMMAND,(MPARAM)IDMPU_COLORS,0L);
	push	0h
	push	0fa4h
	push	020h
	push	dword ptr  stWrite+0bh
	call	WinPostMsg
	add	esp,010h

; 228       break;
	jmp	@BLBL204
	align 04h
@BLBL226:

; 229     case IDMPU_RX_COLORS:
; 230       WinPostMsg(stRead.hwnd,WM_COMMAND,(MPARAM)IDMPU_COLORS,0L);
	push	0h
	push	0fa4h
	push	020h
	push	dword ptr  stRead+0bh
	call	WinPostMsg
	add	esp,010h

; 231       break;
	jmp	@BLBL204
	align 04h
@BLBL227:

; 232     case IDMPU_TX_LOCK_WIDTH:
; 233       WinPostMsg(stWrite.hwnd,WM_COMMAND,(MPARAM)IDMPU_LOCK_WIDTH,0L);
	push	0h
	push	0fabh
	push	020h
	push	dword ptr  stWrite+0bh
	call	WinPostMsg
	add	esp,010h

; 234       break;
	jmp	@BLBL204
	align 04h
@BLBL228:

; 235     case IDMPU_RX_LOCK_WIDTH:
; 236       WinPostMsg(stRead.hwnd,WM_COMMAND,(MPARAM)IDMPU_LOCK_WIDTH,0L);
	push	0h
	push	0fabh
	push	020h
	push	dword ptr  stRead+0bh
	call	WinPostMsg
	add	esp,010h

; 237       break;
	jmp	@BLBL204
	align 04h
@BLBL229:

; 238     case IDMPU_TX_DISP_FILTERS:
; 239       WinPostMsg(stWrite.hwnd,WM_COMMAND,(MPARAM)IDMPU_DISP_FILTERS,0L);
	push	0h
	push	0faah
	push	020h
	push	dword ptr  stWrite+0bh
	call	WinPostMsg
	add	esp,010h

; 240       break;
	jmp	@BLBL204
	align 04h
@BLBL230:

; 241     case IDMPU_RX_DISP_FILTERS:
; 242       WinPostMsg(stRead.hwnd,WM_COMMAND,(MPARAM)IDMPU_DISP_FILTERS,0L);
	push	0h
	push	0faah
	push	020h
	push	dword ptr  stRead+0bh
	call	WinPostMsg
	add	esp,010h

; 243       break;
	jmp	@BLBL204
	align 04h
@BLBL231:

; 244     case IDM_TOGGLE_FONT_SIZE:
; 245       if (!bMinimized && !bMaximized)
	cmp	dword ptr  bMinimized,0h
	jne	@BLBL7
	cmp	dword ptr  bMaximized,0h
	jne	@BLBL7

; 246         {
; 247         if (pstCFG->bLargeFont)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+019h],080h
	je	@BLBL8

; 248           {
; 249           pstCFG->bLargeFont = FALSE;
	mov	eax,[ebp+010h];	pstCFG
	and	byte ptr [eax+019h],07fh

; 250           if (pstCFG->wRowFont == wASCIIfont)
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wASCIIfont
	cmp	[eax+0d9h],cx
	jne	@BLBL9

; 251             pstCFG->wRowFont = ASCII_FONT;
	mov	eax,[ebp+010h];	pstCFG
	mov	word ptr [eax+0d9h],01h
	jmp	@BLBL10
	align 010h
@BLBL9:

; 252           else
; 253             pstCFG->wRowFont = HEX_FONT;
	mov	eax,[ebp+010h];	pstCFG
	mov	word ptr [eax+0d9h],0h
@BLBL10:

; 254           if (pstCFG->wColReadFont == wASCIIfont)
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wASCIIfont
	cmp	[eax+0dbh],cx
	jne	@BLBL11

; 255             pstCFG->wRowFont = ASCII_FONT;
	mov	eax,[ebp+010h];	pstCFG
	mov	word ptr [eax+0d9h],01h
	jmp	@BLBL12
	align 010h
@BLBL11:

; 256           else
; 257             pstCFG->wColReadFont = HEX_FONT;
	mov	eax,[ebp+010h];	pstCFG
	mov	word ptr [eax+0dbh],0h
@BLBL12:

; 258           if (pstCFG->wColWriteFont == wASCIIfont)
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wASCIIfont
	cmp	[eax+0ddh],cx
	jne	@BLBL13

; 259             pstCFG->wColWriteFont = ASCII_FONT;
	mov	eax,[ebp+010h];	pstCFG
	mov	word ptr [eax+0ddh],01h
	jmp	@BLBL14
	align 010h
@BLBL13:

; 260           else
; 261             pstCFG->wColWriteFont = HEX_FONT;
	mov	eax,[ebp+010h];	pstCFG
	mov	word ptr [eax+0ddh],0h
@BLBL14:

; 262           wASCIIfont = 1;
	mov	word ptr  wASCIIfont,01h

; 263           wHEXfont = 0;
	mov	word ptr  wHEXfont,0h

; 264           }
	jmp	@BLBL15
	align 010h
@BLBL8:

; 265         else
; 266           {
; 267           pstCFG->bLargeFont = TRUE;
	mov	eax,[ebp+010h];	pstCFG
	or	byte ptr [eax+019h],080h

; 268           if (pstCFG->wRowFont == wASCIIfont)
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wASCIIfont
	cmp	[eax+0d9h],cx
	jne	@BLBL16

; 269             pstCFG->wRowFont = ASCII_FONT;
	mov	eax,[ebp+010h];	pstCFG
	mov	word ptr [eax+0d9h],01h
	jmp	@BLBL17
	align 010h
@BLBL16:

; 270           else
; 271             pstCFG->wRowFont = HEX_FONT;
	mov	eax,[ebp+010h];	pstCFG
	mov	word ptr [eax+0d9h],0h
@BLBL17:

; 272           if (pstCFG->wColReadFont == wASCIIfont)
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wASCIIfont
	cmp	[eax+0dbh],cx
	jne	@BLBL18

; 273             pstCFG->wRowFont = ASCII_FONT;
	mov	eax,[ebp+010h];	pstCFG
	mov	word ptr [eax+0d9h],01h
	jmp	@BLBL19
	align 010h
@BLBL18:

; 274           else
; 275             pstCFG->wColReadFont = HEX_FONT;
	mov	eax,[ebp+010h];	pstCFG
	mov	word ptr [eax+0dbh],0h
@BLBL19:

; 276           if (pstCFG->wColWriteFont == wASCIIfont)
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wASCIIfont
	cmp	[eax+0ddh],cx
	jne	@BLBL20

; 277             pstCFG->wColWriteFont = ASCII_FONT;
	mov	eax,[ebp+010h];	pstCFG
	mov	word ptr [eax+0ddh],01h
	jmp	@BLBL21
	align 010h
@BLBL20:

; 278           else
; 279             pstCFG->wColWriteFont = HEX_FONT;
	mov	eax,[ebp+010h];	pstCFG
	mov	word ptr [eax+0ddh],0h
@BLBL21:

; 280           wASCIIfont = 3;
	mov	word ptr  wASCIIfont,03h

; 281           wHEXfont = 2;
	mov	word ptr  wHEXfont,02h

; 282           pstCFG->wColWriteFont += 2;
	mov	eax,[ebp+010h];	pstCFG
	mov	[ebp-078h],eax;	@CBE72
	mov	eax,[ebp-078h];	@CBE72
	mov	cx,[eax+0ddh]
	add	cx,02h
	mov	[eax+0ddh],cx

; 283           pstCFG->wColReadFont += 2;
	mov	eax,[ebp+010h];	pstCFG
	mov	[ebp-074h],eax;	@CBE71
	mov	eax,[ebp-074h];	@CBE71
	mov	cx,[eax+0dbh]
	add	cx,02h
	mov	[eax+0dbh],cx

; 284           pstCFG->wRowFont += 2;
	mov	eax,[ebp+010h];	pstCFG
	mov	[ebp-070h],eax;	@CBE70
	mov	eax,[ebp-070h];	@CBE70
	mov	cx,[eax+0d9h]
	add	cx,02h
	mov	[eax+0d9h],cx

; 285           }
@BLBL15:

; 286         WinSendMsg(hwndClient,WM_SYSVALUECHANGED,0L,0L);
	push	0h
	push	0h
	push	02dh
	push	dword ptr  hwndClient
	call	WinSendMsg
	add	esp,010h

; 287         }
@BLBL7:

; 288       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL232:

; 289     case IDM_TOGGLE_FONT:
; 290       if (!bMinimized)
	cmp	dword ptr  bMinimized,0h
	jne	@BLBL22

; 291         {
; 292         if (pstCFG->wRowFont != wASCIIfont)
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wASCIIfont
	cmp	[eax+0d9h],cx
	je	@BLBL23

; 293           pstCFG->wRowFont = wASCIIfont;
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wASCIIfont
	mov	[eax+0d9h],cx
	jmp	@BLBL24
	align 010h
@BLBL23:

; 294         else
; 295           pstCFG->wRowFont = wHEXfont;
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wHEXfont
	mov	[eax+0d9h],cx
@BLBL24:

; 296         bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 297         WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 298         if (pstCFG->wColReadFont != wASCIIfont)
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wASCIIfont
	cmp	[eax+0dbh],cx
	je	@BLBL25

; 299           pstCFG->wColReadFont = wASCIIfont;
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wASCIIfont
	mov	[eax+0dbh],cx
	jmp	@BLBL26
	align 010h
@BLBL25:

; 300         else
; 301           pstCFG->wColReadFont = wHEXfont;
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wHEXfont
	mov	[eax+0dbh],cx
@BLBL26:

; 302         WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stRead+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 303         if (pstCFG->wColWriteFont != wASCIIfont)
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wASCIIfont
	cmp	[eax+0ddh],cx
	je	@BLBL27

; 304           pstCFG->wColWriteFont = wASCIIfont;
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wASCIIfont
	mov	[eax+0ddh],cx
	jmp	@BLBL28
	align 010h
@BLBL27:

; 305         else
; 306           pstCFG->wColWriteFont = wHEXfont;
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wHEXfont
	mov	[eax+0ddh],cx
@BLBL28:

; 307         WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stWrite+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 308         }
@BLBL22:

; 309       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL233:

; 310     case IDMPU_ASCII_FONT:
; 311       if (!pstCFG->bStickyMenus)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+016h],08h
	jne	@BLBL29

; 312         usLastClientPopupItem = IDMPU_FONT;
	mov	word ptr  usLastClientPopupItem,0fa7h
	jmp	@BLBL30
	align 010h
@BLBL29:

; 313       else
; 314         usLastClientPopupItem = IDMPU_EVENT_DISP;
	mov	word ptr  usLastClientPopupItem,0fb4h
@BLBL30:

; 315       pstCFG->wRowFont = wASCIIfont;
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wASCIIfont
	mov	[eax+0d9h],cx

; 316       bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 317       WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 318       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL234:

; 319     case IDMPU_HEX_FONT:
; 320       if (!pstCFG->bStickyMenus)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+016h],08h
	jne	@BLBL31

; 321         usLastClientPopupItem = IDMPU_FONT;
	mov	word ptr  usLastClientPopupItem,0fa7h
	jmp	@BLBL32
	align 010h
@BLBL31:

; 322       else
; 323         usLastClientPopupItem = IDMPU_EVENT_DISP;
	mov	word ptr  usLastClientPopupItem,0fb4h
@BLBL32:

; 324       pstCFG->wRowFont = wHEXfont;
	mov	eax,[ebp+010h];	pstCFG
	mov	cx,word ptr  wHEXfont
	mov	[eax+0d9h],cx

; 325       bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 326       WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 327       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL235:

; 328     case IDM_TOGGLE_FORMAT:
; 329       if (!bMinimized)
	cmp	dword ptr  bMinimized,0h
	jne	@BLBL33

; 330         {
; 331         if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL34

; 332           {
; 333           MenuItemCheck(hwndFrame,IDM_ROWS,TRUE);
	push	01h
	push	0813h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 334           MenuItemCheck(hwndFrame,IDM_COLUMNS,FALSE);
	push	0h
	push	0814h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 335           pstCFG->bColumnDisplay = FALSE;
	mov	eax,[ebp+010h];	pstCFG
	and	byte ptr [eax+018h],07fh

; 336           WinSendMsg(stWrite.hwndClient,UM_HIDEWIN,0L,0L);
	push	0h
	push	0h
	push	08011h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h

; 337           WinSendMsg(stRead.hwndClient,UM_HIDEWIN,0L,0L);
	push	0h
	push	0h
	push	08011h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 338           if (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE))
	mov	eax,[ebp+010h];	pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL35

; 339             {
; 340             SetupRowScrolling(&stRow);
	push	offset FLAT:stRow
	call	SetupRowScrolling
	add	esp,04h

; 341             if (pstCFG->bSyncToRead || (fLastScroll == CS_READ))
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+019h],02h
	jne	@BLBL36
	cmp	dword ptr  fLastScroll,04000h
	jne	@BLBL37
@BLBL36:

; 342               stRow.lScrollIndex = stRead.lScrollIndex;
	mov	eax,dword ptr  stRead+06fh
	mov	dword ptr  stRow+06fh,eax
@BLBL37:

; 343             if (pstCFG->bSyncToWrite || (fLastScroll == CS_WRITE))
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+019h],01h
	jne	@BLBL38
	cmp	dword ptr  fLastScroll,08000h
	jne	@BLBL40
@BLBL38:

; 344               stRow.lScrollIndex = stWrite.lScrollIndex;
	mov	eax,dword ptr  stWrite+06fh
	mov	dword ptr  stRow+06fh,eax

; 345             }
	jmp	@BLBL40
	align 010h
@BLBL35:

; 346           else
; 347             {
; 348             if (KillDisplayThread())
	call	KillDisplayThread
	test	eax,eax
	je	@BLBL40

; 349               {
; 350               bStopDisplayThread = FALSE;
	mov	dword ptr  bStopDisplayThread,0h

; 351               DosCreateThread(&tidDisplayThread,(PFNTHREAD)RowDisplayThread,0L,0L,4096);
	push	01000h
	push	0h
	push	0h
	push	offset FLAT: RowDisplayThread
	push	offset FLAT:tidDisplayThread
	call	DosCreateThread
	add	esp,014h

; 352               }

; 353             }
@BLBL40:

; 354           WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 355           WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 356           }
	jmp	@BLBL33
	align 010h
@BLBL34:

; 357         else
; 358           {
; 359           MenuItemCheck(hwndFrame,IDM_ROWS,FALSE);
	push	0h
	push	0813h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 360           MenuItemCheck(hwndFrame,IDM_COLUMNS,TRUE);
	push	01h
	push	0814h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 361           pstCFG->bColumnDisplay = TRUE;
	mov	eax,[ebp+010h];	pstCFG
	or	byte ptr [eax+018h],080h

; 362           WinSendMsg(stWrite.hwndClient,UM_SHOWAGAIN,0L,0L);
	push	0h
	push	0h
	push	08010h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h

; 363           WinSendMsg(stRead.hwndClient,UM_SHOWAGAIN,0L,0L);
	push	0h
	push	0h
	push	08010h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 364           if (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE))
	mov	eax,[ebp+010h];	pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL43

; 365             ClearRowScrollBar(&stRow);
	push	offset FLAT:stRow
	call	ClearRowScrollBar
	add	esp,04h
	jmp	@BLBL44
	align 010h
@BLBL43:

; 366           else
; 367             if (KillDisplayThread())
	call	KillDisplayThread
	test	eax,eax
	je	@BLBL44

; 368               {
; 369               bStopDisplayThread = FALSE;
	mov	dword ptr  bStopDisplayThread,0h

; 370               DosCreateThread(&tidDisplayThread,(PFNTHREAD)ColumnDisplayThread,0L,0L,4096);
	push	01000h
	push	0h
	push	0h
	push	offset FLAT: ColumnDisplayThread
	push	offset FLAT:tidDisplayThread
	call	DosCreateThread
	add	esp,014h

; 371               }
@BLBL44:

; 372           WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 373           }

; 374         }
@BLBL33:

; 375       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL236:

; 376     case IDM_ROWS:
; 377       if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL46

; 378         {
; 379         MenuItemCheck(hwndFrame,IDM_ROWS,TRUE);
	push	01h
	push	0813h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 380         MenuItemCheck(hwndFrame,IDM_COLUMNS,FALSE);
	push	0h
	push	0814h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 381         pstCFG->bColumnDisplay = FALSE;
	mov	eax,[ebp+010h];	pstCFG
	and	byte ptr [eax+018h],07fh

; 382         WinSendMsg(stWrite.hwndClient,UM_HIDEWIN,0L,0L);
	push	0h
	push	0h
	push	08011h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h

; 383         WinSendMsg(stRead.hwndClient,UM_HIDEWIN,0L,0L);
	push	0h
	push	0h
	push	08011h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 384         if (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE))
	mov	eax,[ebp+010h];	pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL47

; 385           {
; 386           SetupRowScrolling(&stRow);
	push	offset FLAT:stRow
	call	SetupRowScrolling
	add	esp,04h

; 387           if (pstCFG->bSyncToRead || (fLastScroll == CS_READ))
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+019h],02h
	jne	@BLBL48
	cmp	dword ptr  fLastScroll,04000h
	jne	@BLBL49
@BLBL48:

; 388             stRow.lScrollIndex = stRead.lScrollIndex;
	mov	eax,dword ptr  stRead+06fh
	mov	dword ptr  stRow+06fh,eax
@BLBL49:

; 389           if (pstCFG->bSyncToWrite || (fLastScroll == CS_WRITE))
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+019h],01h
	jne	@BLBL50
	cmp	dword ptr  fLastScroll,08000h
	jne	@BLBL52
@BLBL50:

; 390             stRow.lScrollIndex = stWrite.lScrollIndex;
	mov	eax,dword ptr  stWrite+06fh
	mov	dword ptr  stRow+06fh,eax

; 391           }
	jmp	@BLBL52
	align 010h
@BLBL47:

; 392         else
; 393           if (KillDisplayThread())
	call	KillDisplayThread
	test	eax,eax
	je	@BLBL52

; 394             {
; 395             bStopDisplayThread = FALSE;
	mov	dword ptr  bStopDisplayThread,0h

; 396             DosCreateThread(&tidDisplayThread,(PFNTHREAD)RowDisplayThread,0L,0L,4096);
	push	01000h
	push	0h
	push	0h
	push	offset FLAT: RowDisplayThread
	push	offset FLAT:tidDisplayThread
	call	DosCreateThread
	add	esp,014h

; 397             }
@BLBL52:

; 398         bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 399         WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 400         WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 401         }
@BLBL46:

; 402       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL237:

; 403     case IDM_COLUMNS:
; 404       if (!pstCFG->bColumnDisplay)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+018h],080h
	jne	@BLBL54

; 405         {
; 406         MenuItemCheck(hwndFrame,IDM_ROWS,FALSE);
	push	0h
	push	0813h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 407         MenuItemCheck(hwndFrame,IDM_COLUMNS,TRUE);
	push	01h
	push	0814h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 408         pstCFG->bColumnDisplay = TRUE;
	mov	eax,[ebp+010h];	pstCFG
	or	byte ptr [eax+018h],080h

; 409         WinSendMsg(stWrite.hwndClient,UM_SHOWAGAIN,0L,0L);
	push	0h
	push	0h
	push	08010h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h

; 410         WinSendMsg(stRead.hwndClient,UM_SHOWAGAIN,0L,0L);
	push	0h
	push	0h
	push	08010h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 411         if (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE))
	mov	eax,[ebp+010h];	pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL55

; 412           ClearRowScrollBar(&stRow);
	push	offset FLAT:stRow
	call	ClearRowScrollBar
	add	esp,04h
	jmp	@BLBL56
	align 010h
@BLBL55:

; 413         else
; 414           if (KillDisplayThread())
	call	KillDisplayThread
	test	eax,eax
	je	@BLBL56

; 415             {
; 416             bStopDisplayThread = FALSE;
	mov	dword ptr  bStopDisplayThread,0h

; 417             DosCreateThread(&tidDisplayThread,(PFNTHREAD)ColumnDisplayThread,0L,0L,4096);
	push	01000h
	push	0h
	push	0h
	push	offset FLAT: ColumnDisplayThread
	push	offset FLAT:tidDisplayThread
	call	DosCreateThread
	add	esp,014h

; 418             }
@BLBL56:

; 419         bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 420         WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 421 //        WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
; 422 //        WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
; 423         }
@BLBL54:

; 424       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL238:

; 425     case IDMPU_EVENT_DISP:
; 426       usLastClientPopupItem = IDMPU_EVENT_DISP;
	mov	word ptr  usLastClientPopupItem,0fb4h

; 427       if (WinDlgBox(HWND_DESKTOP,
	push	dword ptr [ebp+010h];	pstCFG
	push	01b58h
	push	0h
	push	offset FLAT: fnwpEventDispDlgProc
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL58

; 428                     hWnd,
; 429              (PFNWP)fnwpEventDispDlgProc,
; 430             (USHORT)NULL,
; 431                     EVENT_DISP_DLG,
; 432             MPFROMP(pstCFG)))
; 433         {
; 434         bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 435         WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 436         }
@BLBL58:

; 437       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL239:

; 438     case IDMPU_WRITEREQ_COLOR:
; 439       if (pstCFG->bStickyMenus)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+016h],08h
	je	@BLBL59

; 440         usLastClientPopupItem = IDMPU_COLORS;
	mov	word ptr  usLastClientPopupItem,0fa4h
	jmp	@BLBL60
	align 010h
@BLBL59:

; 441       else
; 442         usLastClientPopupItem = IDMPU_EVENT_DISP;
	mov	word ptr  usLastClientPopupItem,0fb4h
@BLBL60:

; 443       stColor.cbSize = sizeof(CLRDLG);
	mov	word ptr  @cstColor,05ah

; 444       stColor.lForeground = pstCFG->lWriteReqForegrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+099h]
	mov	dword ptr  @cstColor+06h,eax

; 445       stColor.lBackg
; 445 round = pstCFG->lWriteReqBackgrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+095h]
	mov	dword ptr  @cstColor+02h,eax

; 446       sprintf(stColor.szCaption,"Write Request Event Display Colors");
	mov	edx,offset FLAT:@STAT3
	mov	eax,offset FLAT:@cstColor+0ah
	call	_sprintfieee

; 447       if (WinDlgBox(HWND_DESKTOP,
	push	offset FLAT:@cstColor
	push	014b4h
	push	0h
	push	offset FLAT: fnwpSetColorDlg
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL61

; 448                     hWnd,
; 449              (PFNWP)fnwpSetColorDlg,
; 450             (USHORT)NULL,
; 451                     CLR_DLG,
; 452             MPFROMP(&stColor)))
; 453         {
; 454         pstCFG->lWriteReqForegrndColor = stColor.lForeground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+06h
	mov	[eax+099h],ecx

; 455         pstCFG->lWriteReqBackgrndColor = stColor.lBackground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+02h
	mov	[eax+095h],ecx

; 456         bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 457         WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 458         }
@BLBL61:

; 459       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL240:

; 460     case IDMPU_READREQ_COLOR:
; 461       if (pstCFG->bStickyMenus)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+016h],08h
	je	@BLBL62

; 462         usLastClientPopupItem = IDMPU_COLORS;
	mov	word ptr  usLastClientPopupItem,0fa4h
	jmp	@BLBL63
	align 010h
@BLBL62:

; 463       else
; 464         usLastClientPopupItem = IDMPU_EVENT_DISP;
	mov	word ptr  usLastClientPopupItem,0fb4h
@BLBL63:

; 465       stColor.cbSize = sizeof(CLRDLG);
	mov	word ptr  @cstColor,05ah

; 466       stColor.lForeground = pstCFG->lReadReqForegrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+091h]
	mov	dword ptr  @cstColor+06h,eax

; 467       stColor.lBackground = pstCFG->lReadReqBackgrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+08dh]
	mov	dword ptr  @cstColor+02h,eax

; 468       sprintf(stColor.szCaption,"Read Request Event Display Colors");
	mov	edx,offset FLAT:@STAT4
	mov	eax,offset FLAT:@cstColor+0ah
	call	_sprintfieee

; 469       if (WinDlgBox(HWND_DESKTOP,
	push	offset FLAT:@cstColor
	push	014b4h
	push	0h
	push	offset FLAT: fnwpSetColorDlg
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL64

; 470                     hWnd,
; 471              (PFNWP)fnwpSetColorDlg,
; 472             (USHORT)NULL,
; 473                     CLR_DLG,
; 474             MPFROMP(&stColor)))
; 475         {
; 476         pstCFG->lReadReqForegrndColor = stColor.lForeground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+06h
	mov	[eax+091h],ecx

; 477         pstCFG->lReadReqBackgrndColor = stColor.lBackground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+02h
	mov	[eax+08dh],ecx

; 478         bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 479         WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 480         }
@BLBL64:

; 481       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL241:

; 482     case IDMPU_DEVIOCTL_COLOR:
; 483       if (pstCFG->bStickyMenus)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+016h],08h
	je	@BLBL65

; 484         usLastClientPopupItem = IDMPU_COLORS;
	mov	word ptr  usLastClientPopupItem,0fa4h
	jmp	@BLBL66
	align 010h
@BLBL65:

; 485       else
; 486         usLastClientPopupItem = IDMPU_EVENT_DISP;
	mov	word ptr  usLastClientPopupItem,0fb4h
@BLBL66:

; 487       stColor.cbSize = sizeof(CLRDLG);
	mov	word ptr  @cstColor,05ah

; 488       stColor.lForeground = pstCFG->lDevIOctlForegrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+0a1h]
	mov	dword ptr  @cstColor+06h,eax

; 489       stColor.lBackground = pstCFG->lDevIOctlBackgrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+09dh]
	mov	dword ptr  @cstColor+02h,eax

; 490       sprintf(stColor.szCaption,"Device I/O Control Call Event Display Colors");
	mov	edx,offset FLAT:@STAT5
	mov	eax,offset FLAT:@cstColor+0ah
	call	_sprintfieee

; 491       if (WinDlgBox(HWND_DESKTOP,
	push	offset FLAT:@cstColor
	push	014b4h
	push	0h
	push	offset FLAT: fnwpSetColorDlg
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL67

; 492                     hWnd,
; 493              (PFNWP)fnwpSetColorDlg,
; 494             (USHORT)NULL,
; 495                     CLR_DLG,
; 496             MPFROMP(&stColor)))
; 497         {
; 498         pstCFG->lDevIOctlForegrndColor = stColor.lForeground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+06h
	mov	[eax+0a1h],ecx

; 499         pstCFG->lDevIOctlBackgrndColor = stColor.lBackground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+02h
	mov	[eax+09dh],ecx

; 500         bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 501         WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 502         }
@BLBL67:

; 503       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL242:

; 504     case IDMPU_MODEMIN_COLOR:
; 505       if (pstCFG->bStickyMenus)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+016h],08h
	je	@BLBL68

; 506         usLastClientPopupItem = IDMPU_COLORS;
	mov	word ptr  usLastClientPopupItem,0fa4h
	jmp	@BLBL69
	align 010h
@BLBL68:

; 507       else
; 508         usLastClientPopupItem = IDMPU_EVENT_DISP;
	mov	word ptr  usLastClientPopupItem,0fb4h
@BLBL69:

; 509       stColor.cbSize = sizeof(CLRDLG);
	mov	word ptr  @cstColor,05ah

; 510       stColor.lForeground = pstCFG->lModemInForegrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+079h]
	mov	dword ptr  @cstColor+06h,eax

; 511       stColor.lBackground = pstCFG->lModemInBackgrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+075h]
	mov	dword ptr  @cstColor+02h,eax

; 512       sprintf(stColor.szCaption,"Modem Input Signal Event Display Colors");
	mov	edx,offset FLAT:@STAT6
	mov	eax,offset FLAT:@cstColor+0ah
	call	_sprintfieee

; 513       if (WinDlgBox(HWND_DESKTOP,
	push	offset FLAT:@cstColor
	push	014b4h
	push	0h
	push	offset FLAT: fnwpSetColorDlg
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL70

; 514                     hWnd,
; 515              (PFNWP)fnwpSetColorDlg,
; 516             (USHORT)NULL,
; 517                     CLR_DLG,
; 518             MPFROMP(&stColor)))
; 519         {
; 520         pstCFG->lModemInForegrndColor = stColor.lForeground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+06h
	mov	[eax+079h],ecx

; 521         pstCFG->lModemInBackgrndColor = stColor.lBackground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+02h
	mov	[eax+075h],ecx

; 522         bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 523         WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 524         }
@BLBL70:

; 525       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL243:

; 526     case IDMPU_MODEMOUT_COLOR:
; 527       if (pstCFG->bStickyMenus)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+016h],08h
	je	@BLBL71

; 528         usLastClientPopupItem = IDMPU_COLORS;
	mov	word ptr  usLastClientPopupItem,0fa4h
	jmp	@BLBL72
	align 010h
@BLBL71:

; 529       else
; 530         usLastClientPopupItem = IDMPU_EVENT_DISP;
	mov	word ptr  usLastClientPopupItem,0fb4h
@BLBL72:

; 531       stColor.cbSize = sizeof(CLRDLG);
	mov	word ptr  @cstColor,05ah

; 532       stColor.lForeground = pstCFG->lModemOutForegrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+071h]
	mov	dword ptr  @cstColor+06h,eax

; 533       stColor.lBackground = pstCFG->lModemOutBackgrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+06dh]
	mov	dword ptr  @cstColor+02h,eax

; 534       sprintf(stColor.szCaption,"Modem Output Signal Event Display Colors");
	mov	edx,offset FLAT:@STAT7
	mov	eax,offset FLAT:@cstColor+0ah
	call	_sprintfieee

; 535       if (WinDlgBox(HWND_DESKTOP,
	push	offset FLAT:@cstColor
	push	014b4h
	push	0h
	push	offset FLAT: fnwpSetColorDlg
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL73

; 536                     hWnd,
; 537              (PFNWP)fnwpSetColorDlg,
; 538             (USHORT)NULL,
; 539                     CLR_DLG,
; 540             MPFROMP(&stColor)))
; 541         {
; 542         pstCFG->lModemOutForegrndColor = stColor.lForeground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+06h
	mov	[eax+071h],ecx

; 543         pstCFG->lModemOutBackgrndColor = stColor.lBackground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+02h
	mov	[eax+06dh],ecx

; 544         bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 545         WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 546         }
@BLBL73:

; 547       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL244:

; 548     case IDMPU_ERROR_COLOR:
; 549       if (pstCFG->bStickyMenus)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+016h],08h
	je	@BLBL74

; 550         usLastClientPopupItem = IDMPU_COLORS;
	mov	word ptr  usLastClientPopupItem,0fa4h
	jmp	@BLBL75
	align 010h
@BLBL74:

; 551       else
; 552         usLastClientPopupItem = IDMPU_EVENT_DISP;
	mov	word ptr  usLastClientPopupItem,0fb4h
@BLBL75:

; 553       stColor.cbSize = sizeof(CLRDLG);
	mov	word ptr  @cstColor,05ah

; 554       stColor.lForeground = pstCFG->lErrorForegrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+089h]
	mov	dword ptr  @cstColor+06h,eax

; 555       stColor.lBackground = pstCFG->lErrorBackgrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+085h]
	mov	dword ptr  @cstColor+02h,eax

; 556       sprintf(stColor.szCaption,"Communications Error Event Display Colors");
	mov	edx,offset FLAT:@STAT8
	mov	eax,offset FLAT:@cstColor+0ah
	call	_sprintfieee

; 557       if (WinDlgBox(HWND_DESKTOP,
	push	offset FLAT:@cstColor
	push	014b4h
	push	0h
	push	offset FLAT: fnwpSetColorDlg
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL76

; 558                     hWnd,
; 559              (PFNWP)fnwpSetColorDlg,
; 560             (USHORT)NULL,
; 561                     CLR_DLG,
; 562             MPFROMP(&stColor)))
; 563         {
; 564         pstCFG->lErrorForegrndColor = stColor.lForeground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+06h
	mov	[eax+089h],ecx

; 565         pstCFG->lErrorBackgrndColor = stColor.lBackground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+02h
	mov	[eax+085h],ecx

; 566         bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 567         WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 568         }
@BLBL76:

; 569       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL245:

; 570     case IDMPU_OPEN_COLOR:
; 571       if (pstCFG->bStickyMenus)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+016h],08h
	je	@BLBL77

; 572         usLastClientPopupItem = IDMPU_COLORS;
	mov	word ptr  usLastClientPopupItem,0fa4h
	jmp	@BLBL78
	align 010h
@BLBL77:

; 573       else
; 574         usLastClientPopupItem = IDMPU_EVENT_DISP;
	mov	word ptr  usLastClientPopupItem,0fb4h
@BLBL78:

; 575       stColor.cbSize = sizeof(CLRDLG);
	mov	word ptr  @cstColor,05ah

; 576       stColor.lForeground = pstCFG->lOpenForegrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+081h]
	mov	dword ptr  @cstColor+06h,eax

; 577       stColor.lBackground = pstCFG->lOpenBackgrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+07dh]
	mov	dword ptr  @cstColor+02h,eax

; 578       sprintf(stColor.szCaption,"Applicatin Open/Close Event Display Colors");
	mov	edx,offset FLAT:@STAT9
	mov	eax,offset FLAT:@cstColor+0ah
	call	_sprintfieee

; 579       if (WinDlgBox(HWND_DESKTOP,
	push	offset FLAT:@cstColor
	push	014b4h
	push	0h
	push	offset FLAT: fnwpSetColorDlg
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL79

; 580                     hWnd,
; 581              (PFNWP)fnwpSetColorDlg,
; 582             (USHORT)NULL,
; 583                     CLR_DLG,
; 584             MPFROMP(&stColor)))
; 585         {
; 586         pstCFG->lOpenForegrndColor = stColor.lForeground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+06h
	mov	[eax+081h],ecx

; 587         pstCFG->lOpenBackgrndColor = stColor.lBackground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+02h
	mov	[eax+07dh],ecx

; 588         bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 589         WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 590         }
@BLBL79:

; 591       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL246:

; 592     case IDMPU_READ_COLOR:
; 593       if (pstCFG->bStickyMenus)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+016h],08h
	je	@BLBL80

; 594         usLastClientPopupItem = IDMPU_COLORS;
	mov	word ptr  usLastClientPopupItem,0fa4h
	jmp	@BLBL81
	align 010h
@BLBL80:

; 595       else
; 596         usLastClientPopupItem = IDMPU_EVENT_DISP;
	mov	word ptr  usLastClientPopupItem,0fb4h
@BLBL81:

; 597       stColor.cbSize = sizeof(CLRDLG);
	mov	word ptr  @cstColor,05ah

; 598       stColor.lForeground = pstCFG->lReadForegrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+0a9h]
	mov	dword ptr  @cstColor+06h,eax

; 599       stColor.lBackground = pstCFG->lReadBackgrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+0a5h]
	mov	dword ptr  @cstColor+02h,eax

; 600       sprintf(stColor.szCaption,"Time-relational Receive Data Display Colors");
	mov	edx,offset FLAT:@STATa
	mov	eax,offset FLAT:@cstColor+0ah
	call	_sprintfieee

; 601       if (WinDlgBox(HWND_DESKTOP,
	push	offset FLAT:@cstColor
	push	014b4h
	push	0h
	push	offset FLAT: fnwpSetColorDlg
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL82

; 602                     hWnd,
; 603              (PFNWP)fnwpSetColorDlg,
; 604             (USHORT)NULL,
; 605                     CLR_DLG,
; 606             MPFROMP(&stColor)))
; 607         {
; 608         pstCFG->lReadForegrndColor = stColor.lForeground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+06h
	mov	[eax+0a9h],ecx

; 609         pstCFG->lReadBackgrndColor = stColor.lBackground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+02h
	mov	[eax+0a5h],ecx

; 610         bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 611         WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 612         }
@BLBL82:

; 613       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL247:

; 614     case IDMPU_WRITE_COLOR:
; 615       if (pstCFG->bStickyMenus)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+016h],08h
	je	@BLBL83

; 616         usLastClientPopupItem = IDMPU_COLORS;
	mov	word ptr  usLastClientPopupItem,0fa4h
	jmp	@BLBL84
	align 010h
@BLBL83:

; 617       else
; 618         usLastClientPopupItem = IDMPU_EVENT_DISP;
	mov	word ptr  usLastClientPopupItem,0fb4h
@BLBL84:

; 619       stColor.cbSize = sizeof(CLRDLG);
	mov	word ptr  @cstColor,05ah

; 620       stColor.lForeground = pstCFG->lWriteForegrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+0b1h]
	mov	dword ptr  @cstColor+06h,eax

; 621       stColor.lBackground = pstCFG->lWriteBackgrndColor;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+0adh]
	mov	dword ptr  @cstColor+02h,eax

; 622       sprintf(stColor.szCaption,"Time-relational Transmit Data Display Colors");
	mov	edx,offset FLAT:@STATb
	mov	eax,offset FLAT:@cstColor+0ah
	call	_sprintfieee

; 623       if (WinDlgBox(HWND_DESKTOP,
	push	offset FLAT:@cstColor
	push	014b4h
	push	0h
	push	offset FLAT: fnwpSetColorDlg
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL85

; 624                     hWnd,
; 625              (PFNWP)fnwpSetColorDlg,
; 626             (USHORT)NULL,
; 627                     CLR_DLG,
; 628             MPFROMP(&stColor)))
; 629         {
; 630         pstCFG->lWriteForegrndColor = stColor.lForeground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+06h
	mov	[eax+0b1h],ecx

; 631         pstCFG->lWriteBackgrndColor = stColor.lBackground;
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  @cstColor+02h
	mov	[eax+0adh],ecx

; 632         bNoPaint = FALSE;
	mov	dword ptr  bNoPaint,0h

; 633         WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 634         }
@BLBL85:

; 635       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL248:

; 636     case IDM_TRIGGER:
; 637       WinDlgBox(HWND_DESKTOP,
	push	dword ptr [ebp+010h];	pstCFG
	push	04a38h
	push	0h
	push	offset FLAT: fnwpTraceEventDlgProc
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h

; 638                 hWnd,
; 639          (PFNWP)fnwpTraceEventDlgProc,
; 640         (USHORT)NULL,
; 641                 TRIG_DLG,
; 642         MPFROMP(pstCFG));
; 643       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL249:

; 644     case IDM_CAP_EVENT:
; 645       WinDlgBox(HWND_DESKTOP,
	push	dword ptr [ebp+010h];	pstCFG
	push	01f40h
	push	0h
	push	offset FLAT: fnwpTraceEventDlgProc
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h

; 646                 hWnd,
; 647          (PFNWP)fnwpTraceEventDlgProc,
; 648         (USHORT)NULL,
; 649                 TRACE_DLG,
; 650         MPFROMP(pstCFG));
; 651       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL250:

; 652     case IDM_STINMDM:
; 653       WinPostMsg(hwndStatModemIn,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr  hwndStatModemIn
	call	WinPostMsg
	add	esp,010h

; 654       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL251:

; 655     case IDM_STOUTMDM:
; 656       WinPostMsg(hwndStatModemOut,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr  hwndStatModemOut
	call	WinPostMsg
	add	esp,010h

; 657       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL252:

; 658     case IDM_STALL:
; 659       WinPostMsg(hwndStatAll,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr  hwndStatAll
	call	WinPostMsg
	add	esp,010h

; 660       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL253:

; 661     case IDM_STXMITBUF
; 661 :
; 662       WinPostMsg(hwndStatXmitBuf,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr  hwndStatXmitBuf
	call	WinPostMsg
	add	esp,010h

; 663       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL254:

; 664     case IDM_STRCVBUFF:
; 665       WinPostMsg(hwndStatRcvBuf,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr  hwndStatRcvBuf
	call	WinPostMsg
	add	esp,010h

; 666       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL255:

; 667     case IDM_STDEVDRV:
; 668       WinPostMsg(hwndStatDev,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr  hwndStatDev
	call	WinPostMsg
	add	esp,010h

; 669       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL256:

; 670     case IDM_SAVEDAT:
; 671       if (szDataFileSpec[0] == 0)
	cmp	byte ptr  szDataFileSpec,0h
	jne	@BLBL86

; 672         {
; 673         sprintf(szMessage,"%s - Data File to Save to",pstCFG->szPortName);
	mov	eax,[ebp+010h];	pstCFG
	add	eax,02h
	push	eax
	mov	edx,offset FLAT:@STATc
	lea	eax,[ebp-058h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 674         if (!GetFileName(hWnd,szDataFileSpec,szMessage,COMscopeOpenFilterProc))
	push	offset FLAT: COMscopeOpenFilterProc
	lea	eax,[ebp-058h];	szMessage
	push	eax
	push	offset FLAT:szDataFileSpec
	push	dword ptr [ebp+08h];	hWnd
	call	GetFileName
	add	esp,010h
	test	eax,eax
	jne	@BLBL86

; 675           return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL86:

; 676         }
; 677       if (strcmp(szEntryDataFileSpec,szDataFileSpec) != 0)
	mov	edx,offset FLAT:szDataFileSpec
	mov	eax,offset FLAT:szEntryDataFileSpec
	call	strcmp
	test	eax,eax
	je	@BLBL88

; 678         {
; 679         if (hProfileInstance != NULL)
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL89

; 680           if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-060h];	hMod
	push	eax
	push	offset FLAT:@STATd
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL89

; 681             {
; 682             if (DosQueryProcAddr(hMod,0,"SaveProfileString",(PFN *)&pfnSaveProfileString) == NO_ERROR)
	push	offset FLAT:pfnSaveProfileString
	push	offset FLAT:@STATe
	push	0h
	push	dword ptr [ebp-060h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL91

; 683               pfnSaveProfileString(hProfileInstance,"Data File",szDataFileSpec);
	push	offset FLAT:szDataFileSpec
	push	offset FLAT:@STATf
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnSaveProfileString
	add	esp,0ch
@BLBL91:

; 684             DosFreeModule(hMod);
	push	dword ptr [ebp-060h];	hMod
	call	DosFreeModule
	add	esp,04h

; 685             }
@BLBL89:

; 686         strcpy(szEntryDataFileSpec,szDataFileSpec);
	mov	edx,offset FLAT:szDataFileSpec
	mov	eax,offset FLAT:szEntryDataFileSpec
	call	strcpy

; 687         }
@BLBL88:

; 688       if (bBufferWrapped)
	cmp	dword ptr  bBufferWrapped,0h
	je	@BLBL92

; 689         ulWordCount = pstCFG->lBufferLength;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+0d5h]
	mov	[ebp-08h],eax;	ulWordCount
	jmp	@BLBL93
	align 010h
@BLBL92:

; 690       else
; 691         if (lWriteIndex < pstCFG->lBufferLength)
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  lWriteIndex
	cmp	[eax+0d5h],ecx
	jle	@BLBL94

; 692           ulWordCount = lWriteIndex;
	mov	eax,dword ptr  lWriteIndex
	mov	[ebp-08h],eax;	ulWordCount
	jmp	@BLBL93
	align 010h
@BLBL94:

; 693         else
; 694           ulWordCount = pstCFG->lBufferLength;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+0d5h]
	mov	[ebp-08h],eax;	ulWordCount
@BLBL93:

; 695       WriteCaptureFile(szDataFileSpec,pwCaptureBuffer,ulWordCount,FOPEN_NORMAL,HLPP_MB_OVERWRT_FILE);
	push	09caah
	push	0h
	push	dword ptr [ebp-08h];	ulWordCount
	push	dword ptr  pwCaptureBuffer
	push	offset FLAT:szDataFileSpec
	call	WriteCaptureFile
	add	esp,014h

; 696       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL257:

; 697     case IDM_SAVEDATAS:
; 698       sprintf(szMessage,"%s - Save Data As",pstCFG->szPortName);
	mov	eax,[ebp+010h];	pstCFG
	add	eax,02h
	push	eax
	mov	edx,offset FLAT:@STAT10
	lea	eax,[ebp-058h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 699       if (!GetFileName(hWnd,szDataFileSpec,szMessage,COMscopeOpenFilterProc))
	push	offset FLAT: COMscopeOpenFilterProc
	lea	eax,[ebp-058h];	szMessage
	push	eax
	push	offset FLAT:szDataFileSpec
	push	dword ptr [ebp+08h];	hWnd
	call	GetFileName
	add	esp,010h
	test	eax,eax
	jne	@BLBL96

; 700         return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL96:

; 701       if (strcmp(szEntryDataFileSpec,szDataFileSpec) != 0)
	mov	edx,offset FLAT:szDataFileSpec
	mov	eax,offset FLAT:szEntryDataFileSpec
	call	strcmp
	test	eax,eax
	je	@BLBL97

; 702         {
; 703         if (hProfileInstance != NULL)
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL98

; 704           if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-060h];	hMod
	push	eax
	push	offset FLAT:@STAT11
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL98

; 705             {
; 706             if (DosQueryProcAddr(hMod,0,"SaveProfileString",(PFN *)&pfnSaveProfileString) == NO_ERROR)
	push	offset FLAT:pfnSaveProfileString
	push	offset FLAT:@STAT12
	push	0h
	push	dword ptr [ebp-060h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL100

; 707               pfnSaveProfileString(hProfileInstance,"Data File",szDataFileSpec);
	push	offset FLAT:szDataFileSpec
	push	offset FLAT:@STAT13
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnSaveProfileString
	add	esp,0ch
@BLBL100:

; 708             DosFreeModule(hMod);
	push	dword ptr [ebp-060h];	hMod
	call	DosFreeModule
	add	esp,04h

; 709             }
@BLBL98:

; 710         strcpy(szEntryDataFileSpec,szDataFileSpec);
	mov	edx,offset FLAT:szDataFileSpec
	mov	eax,offset FLAT:szEntryDataFileSpec
	call	strcpy

; 711         }
@BLBL97:

; 712       if (bBufferWrapped)
	cmp	dword ptr  bBufferWrapped,0h
	je	@BLBL101

; 713         ulWordCount = pstCFG->lBufferLength;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+0d5h]
	mov	[ebp-08h],eax;	ulWordCount
	jmp	@BLBL102
	align 010h
@BLBL101:

; 714       else
; 715         if (lWriteIndex < pstCFG->lBufferLength)
	mov	eax,[ebp+010h];	pstCFG
	mov	ecx,dword ptr  lWriteIndex
	cmp	[eax+0d5h],ecx
	jle	@BLBL103

; 716           ulWordCount = lWriteIndex;
	mov	eax,dword ptr  lWriteIndex
	mov	[ebp-08h],eax;	ulWordCount
	jmp	@BLBL102
	align 010h
@BLBL103:

; 717         else
; 718           ulWordCount = pstCFG->lBufferLength;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+0d5h]
	mov	[ebp-08h],eax;	ulWordCount
@BLBL102:

; 719       WriteCaptureFile(szDataFileSpec,pwCaptureBuffer,ulWordCount,FOPEN_NORMAL,HLPP_MB_OVERWRT_FILE);
	push	09caah
	push	0h
	push	dword ptr [ebp-08h];	ulWordCount
	push	dword ptr  pwCaptureBuffer
	push	offset FLAT:szDataFileSpec
	call	WriteCaptureFile
	add	esp,014h

; 720       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL258:

; 721     case IDM_MANAGE_CFG:
; 722       if (hProfileInstance != NULL)
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL105

; 723         if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-060h];	hMod
	push	eax
	push	offset FLAT:@STAT14
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL105

; 724           {
; 725           if (DosQueryProcAddr(hMod,0,"ManageProfile",(PFN *)&pfnManageProfile) == NO_ERROR)
	push	offset FLAT:pfnManageProfile
	push	offset FLAT:@STAT15
	push	0h
	push	dword ptr [ebp-060h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL107

; 726             if (pfnManageProfile(hWnd,hProfileInstance))
	push	dword ptr  hProfileInstance
	push	dword ptr [ebp+08h];	hWnd
	call	dword ptr  pfnManageProfile
	add	esp,08h
	test	eax,eax
	je	@BLBL107

; 727               StartSystem(pstCFG,TRUE);
	push	01h
	push	dword ptr [ebp+010h];	pstCFG
	call	StartSystem
	add	esp,08h
@BLBL107:

; 728           DosFreeModule(hMod);
	push	dword ptr [ebp-060h];	hMod
	call	DosFreeModule
	add	esp,04h

; 729           }
@BLBL105:

; 730       break;
	jmp	@BLBL204
	align 04h
@BLBL259:

; 731     case IDM_LOADDAT:
; 732       if (!GetFileName(hWnd,szDataFileSpec,"Select file to Load.",COMscopeOpenFilterProc))
	push	offset FLAT: COMscopeOpenFilterProc
	push	offset FLAT:@STAT16
	push	offset FLAT:szDataFileSpec
	push	dword ptr [ebp+08h];	hWnd
	call	GetFileName
	add	esp,010h
	test	eax,eax
	jne	@BLBL109

; 733         return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL109:

; 734       hPointer = WinQuerySysPointer(HWND_DESKTOP,SPTR_WAIT,FALSE);
	push	0h
	push	03h
	push	01h
	call	WinQuerySysPointer
	add	esp,0ch
	mov	[ebp-05ch],eax;	hPointer

; 735       WinSetPointer(HWND_DESKTOP,hPointer);
	push	dword ptr [ebp-05ch];	hPointer
	push	01h
	call	WinSetPointer
	add	esp,08h

; 736       if (strcmp(szEntryDataFileSpec,szDataFileSpec) != 0)
	mov	edx,offset FLAT:szDataFileSpec
	mov	eax,offset FLAT:szEntryDataFileSpec
	call	strcmp
	test	eax,eax
	je	@BLBL110

; 737         {
; 738         if (hProfileInstance != NULL)
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL111

; 739           if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-060h];	hMod
	push	eax
	push	offset FLAT:@STAT17
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL111

; 740             {
; 741             if (DosQueryProcAddr(hMod,0,"SaveProfileString",(PFN *)&pfnSaveProfileString) == NO_ERROR)
	push	offset FLAT:pfnSaveProfileString
	push	offset FLAT:@STAT18
	push	0h
	push	dword ptr [ebp-060h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL113

; 742               pfnSaveProfileString(hProfileInstance,"Data File",szDataFileSpec);
	push	offset FLAT:szDataFileSpec
	push	offset FLAT:@STAT19
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnSaveProfileString
	add	esp,0ch
@BLBL113:

; 743             DosFreeModule(hMod);
	push	dword ptr [ebp-060h];	hMod
	call	DosFreeModule
	add	esp,04h

; 744             }
@BLBL111:

; 745         strcpy(szEntryDataFileSpec,szDataFileSpec);
	mov	edx,offset FLAT:szDataFileSpec
	mov	eax,offset FLAT:szEntryDataFileSpec
	call	strcpy

; 746         }
@BLBL110:

; 747       ulWordCount = pstCFG->lBufferLength;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+0d5h]
	mov	[ebp-08h],eax;	ulWordCount

; 748       if (pwScrollBuffer != NULL)
	cmp	dword ptr  pwScrollBuffer,0h
	je	@BLBL114

; 749         DosFreeMem(pwScrollBuffer);
	push	dword ptr  pwScrollBuffer
	call	DosFreeMem
	add	esp,04h
@BLBL114:

; 750       if (DosAllocMem((PPVOID)&pwScrollBuffer,(ulWordCount * 2),PAG_COMMIT | PAG_READ | PAG_WRITE) == NO_ERROR)
	push	013h
	mov	eax,[ebp-08h];	ulWordCount
	add	eax,eax
	push	eax
	push	offset FLAT:pwScrollBuffer
	call	DosAllocMem
	add	esp,0ch
	test	eax,eax
	jne	@BLBL115

; 751         {
; 752         if (ReadCaptureFile(szDataFileSpec,&pwScrollBuffer,&ulWordCount,FOPEN_AUTO_ALLOC))
	push	0h
	lea	eax,[ebp-08h];	ulWordCount
	push	eax
	push	offset FLAT:pwScrollBuffer
	push	offset FLAT:szDataFileSpec
	call	ReadCaptureFile
	add	esp,010h
	test	eax,eax
	je	@BLBL116

; 753           {
; 754           lWriteIndex = ulWordCount;
	mov	eax,[ebp-08h];	ulWordCount
	mov	dword ptr  lWriteIndex,eax

; 755           lScrollCount = ulWordCount;
	mov	eax,[ebp-08h];	ulWordCount
	mov	dword ptr  lScrollCount,eax

; 756           pstCFG->fDisplaying |= DISP_FILE;
	mov	eax,[ebp+010h];	pstCFG
	mov	[ebp-06ch],eax;	@CBE69
	mov	eax,[ebp-06ch];	@CBE69
	mov	dl,[eax+01bh]
	and	edx,01fh
	shr	edx,02h
	or	dl,04h
	mov	cl,[eax+01bh]
	and	cl,0e3h
	sal	edx,02h
	and	dl,01fh
	or	cl,dl
	mov	[eax+01bh],cl

; 757           MenuItemCheck(hwndFrame,IDM_VIEWDAT,FALSE);
	push	0h
	push	07d6h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 758           MenuItemEnable(hwndFrame,IDM_VIEWDAT,FALSE);
	push	0h
	push	07d6h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 759           MenuItemEnable(hwndFrame,IDM_SAVEDAT,FALSE);
	push	0h
	push	07d4h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 760           MenuItemEnable(hwndFrame,IDM_SAVEDATAS,FALSE);
	push	0h
	push	07d7h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 761           goto gtViewData;
	jmp	gtViewData117
	align 010h
@BLBL116:

; 762           }
; 763         DosFreeMem(pwScrollBuffer);
	push	dword ptr  pwScrollBuffer
	call	DosFreeMem
	add	esp,04h

; 764         pwScrollBuffer = NULL;
	mov	dword ptr  pwScrollBuffer,0h

; 765         }
	jmp	@BLBL118
	align 010h
@BLBL115:

; 766       else
; 767         {
; 768         sprintf(szMessage,"Unable to allocate Scroll Buffer (Loading Data).");
	mov	edx,offset FLAT:@STAT1a
	lea	eax,[ebp-058h];	szMessage
	call	_sprintfieee

; 769         ErrorNotify(szMessage);
	lea	eax,[ebp-058h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 770         }
@BLBL118:

; 771       WinDestroyPointer(hPointer);
	push	dword ptr [ebp-05ch];	hPointer
	call	WinDestroyPointer
	add	esp,04h

; 772       break;
	jmp	@BLBL204
	align 04h
@BLBL260:

; 773     case IDM_VIEWDAT:
; 774       if (pstCFG->fDisplaying & DISP_DATA)
	mov	eax,[ebp+010h];	pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	test	al,02h
	je	@BLBL119

; 775         {
; 776         if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL120

; 777           {
; 778           WinSendMsg(stRead.hwndClient,UM_HIDEWIN,0L,0L);
	push	0h
	push	0h
	push	08011h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 779           WinSendMsg(stWrite.hwndClient,UM_HIDEWIN,0L,0L);
	push	0h
	push	0h
	push	08011h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h

; 780           }
	jmp	@BLBL121
	align 010h
@BLBL120:

; 781         else
; 782           ClearRowScrollBar(&stRow);
	push	offset FLAT:stRow
	call	ClearRowScrollBar
	add	esp,04h
@BLBL121:

; 783         if (pwScrollBuffer != NULL)
	cmp	dword ptr  pwScrollBuffer,0h
	je	@BLBL122

; 784           DosFreeMem(pwScrollBuffer);
	push	dword ptr  pwScrollBuffer
	call	DosFreeMem
	add	esp,04h
@BLBL122:

; 785         pstCFG->fDisplaying = 0;
	mov	eax,[ebp+010h];	pstCFG
	and	byte ptr [eax+01bh],0e3h

; 786         MenuItemCheck(hwndFrame,IDM_VIEWDAT,FALSE);
	push	0h
	push	07d6h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 787         }
	jmp	@BLBL123
	align 010h
@BLBL119:

; 788       else
; 789         {
; 790         KillDisplayThread();
	call	KillDisplayThread

; 791         KillMonitorThread();
	call	KillMonitorThread

; 792         pstCFG->bMonitoringStream = FALSE;
	mov	eax,[ebp+010h];	pstCFG
	and	byte ptr [eax+017h],0dfh

; 793         if (bBufferWrapped)
	cmp	dword ptr  bBufferWrapped,0h
	je	@BLBL124

; 794           lScrollCount = pstCFG->lBufferLength;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+0d5h]
	mov	dword ptr  lScrollCount,eax
	jmp	@BLBL125
	align 010h
@BLBL124:

; 795         else
; 796           lScrollCount = lWriteIndex;
	mov	eax,dword ptr  lWriteIndex
	mov	dword ptr  lScrollCount,eax
@BLBL125:

; 797         if (pwScrollBuffer != NULL)
	cmp	dword ptr  pwScrollBuffer,0h
	je	@BLBL126

; 798           DosFreeMem(pwScrollBuffer);
	push	dword ptr  pwScrollBuffer
	call	DosFreeMem
	add	esp,04h
@BLBL126:

; 799         if (DosAllocMem((PPVOID)&pwScrollBuffer,(lScrollCount * 2),(PAG_COMMIT | PAG_READ | PAG_WRITE)) == NO_ERROR)
	push	013h
	mov	eax,dword ptr  lScrollCount
	add	eax,eax
	push	eax
	push	offset FLAT:pwScrollBuffer
	call	DosAllocMem
	add	esp,0ch
	test	eax,eax
	jne	@BLBL127

; 800           {
; 801           if (bBufferWrapped)
	cmp	dword ptr  bBufferWrapped,0h
	je	@BLBL128

; 802             {
; 803             ulWordCount = lScrollCount - lWriteIndex;
	mov	eax,dword ptr  lScrollCount
	sub	eax,dword ptr  lWriteIndex
	mov	[ebp-08h],eax;	ulWordCount

; 804             memcpy(pwScrollBuffer,&pwCaptureBuffer[lWriteIndex],(ulWordCount * 2));
	mov	ecx,[ebp-08h];	ulWordCount
	add	ecx,ecx
	mov	eax,dword ptr  pwCaptureBuffer
	mov	edx,dword ptr  lWriteIndex
	lea	edx,dword ptr [eax+edx*02h]
	mov	eax,dword ptr  pwScrollBuffer
	call	memcpy

; 805             memcpy(&pwScrollBuffer[ulWordCount],pwCaptureBuffer,(lWriteIndex * 2));
	mov	ecx,dword ptr  lWriteIndex
	add	ecx,ecx
	mov	edx,dword ptr  pwCaptureBuffer
	mov	eax,dword ptr  pwScrollBuffer
	mov	ebx,[ebp-08h];	ulWordCount
	lea	eax,dword ptr [eax+ebx*02h]
	call	memcpy

; 806             }
	jmp	@BLBL130
	align 010h
@BLBL128:

; 807           else
; 808             memcpy(pwScrollBuffer,pwCaptureBuffer,(lScrollCount * 2));
	mov	ecx,dword ptr  lScrollCount
	add	ecx,ecx
	mov	edx,dword ptr  pwCaptureBuffer
	mov	eax,dword ptr  pwScrollBuffer
	call	memcpy

; 809           }
	jmp	@BLBL130
	align 010h
@BLBL127:

; 810         else
; 811           {
; 812           sprintf(szMessage,"Unable to allocate Scroll Buffer (View Data).");
	mov	edx,offset FLAT:@STAT1b
	lea	eax,[ebp-058h];	szMessage
	call	_sprintfieee

; 813           ErrorNotify(szMessage);
	lea	eax,[ebp-058h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 814           break;
	jmp	@BLBL204
	align 04h
@BLBL130:

; 815           }
; 816         pstCFG->fDisplaying |= DISP_DATA;
	mov	eax,[ebp+010h];	pstCFG
	mov	[ebp-068h],eax;	@CBE68
	mov	eax,[ebp-068h];	@CBE68
	mov	cl,[eax+01bh]
	and	ecx,01fh
	shr	ecx,02h
	or	cl,02h
	mov	bl,[eax+01bh]
	and	bl,0e3h
	sal	ecx,02h
	and	cl,01fh
	or	bl,cl
	mov	[eax+01bh],bl

; 817         MenuItemCheck(hwndFrame,IDM_VIEWDAT,TRUE);
	push	01h
	push	07d6h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 818 gtViewData:
gtViewData117:

; 819         stRead.lScrollIndex = 0;
	mov	dword ptr  stRead+06fh,0h

; 820         stRead.lScrollRow = 0;
	mov	dword ptr  stRead+06bh,0h

; 821         stWrite.lScrollIndex = 0;
	mov	dword ptr  stWrite+06fh,0h

; 822         stWrite.lScrollRow = 0;
	mov	dword ptr  stWrite+06bh,0h

; 823         stRow.lScrollIndex = 0;
	mov	dword ptr  stRow+06fh,0h

; 824         stRow.lScrollRow = 0;
	mov	dword ptr  stRow+06bh,0h

; 825         MenuItemEnable(hwndFrame,IDM_SEARCH,TRUE);
	push	01h
	push	0826h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 826         MenuItemEnable(hwndFrame,IDM_SEARCH_NEXT,TRUE);
	push	01h
	push	0827h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 827         MenuItemEnable(hwndFrame,IDM_QUERY_INDEX,TRUE);
	push	01h
	push	0828h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 828         if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL131

; 829           {
; 830           WinSendMsg(stWrite.hwndClient,UM_SHOWAGAIN,0L,0L);
	push	0h
	push	0h
	push	08010h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h

; 831           WinSendMsg(stRead.hwndClient,UM_SHOWAGAIN,0L,0L);
	push	0h
	push	0h
	push	08010h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 832           ClearRowScrollBar(&stRow);
	push	offset FLAT:stRow
	call	ClearRowScrollBar
	add	esp,04h

; 833           if (!pstCFG->bSyncToWrite)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+019h],01h
	jne	@BLBL132

; 834             SetupColScrolling(&stRead);
	push	offset FLAT:stRead
	call	SetupColScrolling
	add	esp,04h
@BLBL132:

; 835           if (!pstCFG->bSyncToRead)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+019h],02h
	jne	@BLBL133

; 836             SetupColScrolling(&stWrite);
	push	offset FLAT:stWrite
	call	SetupColScrolling
	add	esp,04h
@BLBL133:

; 837           WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stRead+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 838           WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stWrite+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 839           }
	jmp	@BLBL123
	align 010h
@BLBL131:

; 840         else
; 841           {
; 842           WinSendMsg(stWrite.hwndClient,UM_HIDEWIN,0L,0L);
	push	0h
	push	0h
	push	08011h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h

; 843           WinSendMsg(stRead.hwndClient,UM_HIDEWIN,0L,0L);
	push	0h
	push	0h
	push	08011h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 844           SetupRowScrolling(&stRow);
	push	offset FLAT:stRow
	call	SetupRowScrolling
	add	esp,04h

; 845           WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 846           }

; 847         }
@BLBL123:

; 848       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL261:

; 849     case IDM_MDISPLAY:
; 850       if (KillDisplayThread())
	call	KillDisplayThread
	test	eax,eax
	je	@BLBL135

; 851         {
; 852         pstCFG->fDisplaying = 0;
	mov	eax,[ebp+010h];	pstCFG
	and	byte ptr [eax+01bh],0e3h

; 853         if (pstCFG->ulUserSleepCount == 0)
	mov	eax,[ebp+010h];	pstCFG
	cmp	dword ptr [eax+0d1h],0h
	jne	@BLBL136

; 854           ulMonitorSleepCount = ulCalcSleepCount;
	mov	eax,dword ptr  ulCalcSleepCount
	mov	dword ptr  ulMonitorSleepCount,eax
@BLBL136:

; 855         MenuItemCheck(hwndFrame,IDM_MDISPLAY,FALSE);
	push	0h
	push	07e3h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 856         }
	jmp	@BLBL137
	align 010h
@BLBL135:

; 857       else
; 858         {
; 859         if (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE))
	mov	eax,[ebp+010h];	pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL138

; 860           {
; 861           if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL139

; 862             {
; 863             ClearColScrollBar(&stRead);
	push	offset FLAT:stRead
	call	ClearColScrollBar
	add	esp,04h

; 864             ClearColScrollBar(&stWrite);
	push	offset FLAT:stWrite
	call	ClearColScrollBar
	add	esp,04h

; 865             }
	jmp	@BLBL138
	align 010h
@BLBL139:

; 866           else
; 867             ClearRowScrollBar(&stRow);
	push	offset FLAT:stRow
	call	ClearRowScrollBar
	add	esp,04h

; 868           }
@BLBL138:

; 869         if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL141

; 870           {
; 871           WinSendMsg(stWrite.hwndClient,UM_SHOWNEW,0L,0L);
	push	0h
	push	0h
	push	0800fh
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h

; 872  
; 872          WinSendMsg(stRead.hwndClient,UM_SHOWNEW,0L,0L);
	push	0h
	push	0h
	push	0800fh
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 873           }
	jmp	@BLBL142
	align 010h
@BLBL141:

; 874         else
; 875           WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch
@BLBL142:

; 876         pstCFG->fDisplaying = DISP_STREAM;
	mov	eax,[ebp+010h];	pstCFG
	mov	bl,[eax+01bh]
	and	bl,0e3h
	or	bl,04h
	mov	[eax+01bh],bl

; 877         MenuItemCheck(hwndFrame,IDM_MDISPLAY,TRUE);
	push	01h
	push	07e3h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 878         if (pstCFG->ulUserSleepCount != 0)
	mov	eax,[ebp+010h];	pstCFG
	cmp	dword ptr [eax+0d1h],0h
	je	@BLBL143

; 879           ulMonitorSleepCount = pstCFG->ulUserSleepCount;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+0d1h]
	mov	dword ptr  ulMonitorSleepCount,eax
	jmp	@BLBL144
	align 010h
@BLBL143:

; 880         else
; 881           ulMonitorSleepCount = 200;
	mov	dword ptr  ulMonitorSleepCount,0c8h
@BLBL144:

; 882         stRow.lLeadIndex = 0;
	mov	dword ptr  stRow+073h,0h

; 883         bStopDisplayThread = FALSE;
	mov	dword ptr  bStopDisplayThread,0h

; 884         if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL145

; 885           DosCreateThread(&tidDisplayThread,(PFNTHREAD)ColumnDisplayThread,0L,0L,4096);
	push	01000h
	push	0h
	push	0h
	push	offset FLAT: ColumnDisplayThread
	push	offset FLAT:tidDisplayThread
	call	DosCreateThread
	add	esp,014h
	jmp	@BLBL146
	align 010h
@BLBL145:

; 886         else
; 887           DosCreateThread(&tidDisplayThread,(PFNTHREAD)RowDisplayThread,0L,0L,4096);
	push	01000h
	push	0h
	push	0h
	push	offset FLAT: RowDisplayThread
	push	offset FLAT:tidDisplayThread
	call	DosCreateThread
	add	esp,014h
@BLBL146:

; 888         DosPostEventSem(hevWaitCOMiDataSem);
	push	dword ptr  hevWaitCOMiDataSem
	call	DosPostEventSem
	add	esp,04h

; 889         WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 890         }
@BLBL137:

; 891       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL262:

; 892     case IDM_MSTREAM:
; 893       KillDisplayThread();
	call	KillDisplayThread

; 894       if (!KillMonitorThread())
	call	KillMonitorThread
	test	eax,eax
	jne	@BLBL147

; 895         {
; 896         MenuItemEnable(hwndFrame,IDM_SEARCH,FALSE);
	push	0h
	push	0826h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 897         MenuItemEnable(hwndFrame,IDM_SEARCH_NEXT,FALSE);
	push	0h
	push	0827h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 898         MenuItemEnable(hwndFrame,IDM_QUERY_INDEX,FALSE);
	push	0h
	push	0828h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 899         if (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE))
	mov	eax,[ebp+010h];	pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL148

; 900           {
; 901           if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL149

; 902             {
; 903 //            WinSendMsg(stWrite.hwndClient,UM_SHOWNEW,0L,0L);
; 904 //            WinSendMsg(stRead.hwndClient,UM_SHOWNEW,0L,0L);
; 905             ClearColScrollBar(&stRead);
	push	offset FLAT:stRead
	call	ClearColScrollBar
	add	esp,04h

; 906             ClearColScrollBar(&stWrite);
	push	offset FLAT:stWrite
	call	ClearColScrollBar
	add	esp,04h

; 907             WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stRead+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 908             WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stWrite+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 909             }
	jmp	@BLBL148
	align 010h
@BLBL149:

; 910           else
; 911             {
; 912             ClearRowScrollBar(&stRow);
	push	offset FLAT:stRow
	call	ClearRowScrollBar
	add	esp,04h

; 913 //            WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
; 914             }

; 915           }
@BLBL148:

; 916         if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL151

; 917           {
; 918           WinSendMsg(stWrite.hwndClient,UM_SHOWNEW,0L,0L);
	push	0h
	push	0h
	push	0800fh
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h

; 919           WinSendMsg(stRead.hwndClient,UM_SHOWNEW,0L,0L);
	push	0h
	push	0h
	push	0800fh
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 920           }
	jmp	@BLBL152
	align 010h
@BLBL151:

; 921         else
; 922           WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch
@BLBL152:

; 923         if (pstCFG->bCaptureToFile)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+016h],020h
	je	@BLBL153

; 924           {
; 925           if (szCaptureFileName[0] == 0)
	cmp	byte ptr  szCaptureFileName,0h
	jne	@BLBL154

; 926             {
; 927             strcpy(szCaptureFileName,szCaptureFileSpec);
	mov	edx,offset FLAT:szCaptureFileSpec
	mov	eax,offset FLAT:szCaptureFileName
	call	strcpy

; 928             IncrementFileExt(szCaptureFileName,TRUE);
	push	01h
	push	offset FLAT:szCaptureFileName
	call	IncrementFileExt
	add	esp,08h

; 929             }
@BLBL154:

; 930           strcpy(szTempPath,szCaptureFileName);
	mov	edx,offset FLAT:szCaptureFileName
	mov	eax,offset FLAT:szTempPath
	call	strcpy

; 931           if (!WriteCaptureFile(szCaptureFileName,pwCaptureBuffer,0,FOPEN_NORMAL,HLPP_MB_OVERWRT_FILE))
	push	09caah
	push	0h
	push	0h
	push	dword ptr  pwCaptureBuffer
	push	offset FLAT:szCaptureFileName
	call	WriteCaptureFile
	add	esp,014h
	test	eax,eax
	jne	@BLBL155

; 932             return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL155:

; 933           if (strcmp(szTempPath,szCaptureFileName) != 0)
	mov	edx,offset FLAT:szCaptureFileName
	mov	eax,offset FLAT:szTempPath
	call	strcmp
	test	eax,eax
	je	@BLBL153

; 934             {
; 935             strcpy(szCaptureFileSpec,szCaptureFileName);
	mov	edx,offset FLAT:szCaptureFileName
	mov	eax,offset FLAT:szCaptureFileSpec
	call	strcpy

; 936             IncrementFileExt(szCaptureFileSpec,TRUE);
	push	01h
	push	offset FLAT:szCaptureFileSpec
	call	IncrementFileExt
	add	esp,08h

; 937             szCaptureFileSpec[strlen(szCaptureFileSpec) - 4] = 0;
	mov	eax,offset FLAT:szCaptureFileSpec
	call	strlen
	mov	byte ptr [eax+ szCaptureFileSpec-04h],0h

; 938             if (hProfileInstance != NULL)
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL157

; 939               if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-060h];	hMod
	push	eax
	push	offset FLAT:@STAT1c
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL157

; 940                 {
; 941                 if (DosQueryProcAddr(hMod,0,"SaveProfileString",(PFN *)&pfnSaveProfileString) == NO_ERROR)
	push	offset FLAT:pfnSaveProfileString
	push	offset FLAT:@STAT1d
	push	0h
	push	dword ptr [ebp-060h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL159

; 942                   pfnSaveProfileString(hProfileInstance,"Capture File",szCaptureFileSpec);
	push	offset FLAT:szCaptureFileSpec
	push	offset FLAT:@STAT1e
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnSaveProfileString
	add	esp,0ch
@BLBL159:

; 943                 DosFreeModule(hMod);
	push	dword ptr [ebp-060h];	hMod
	call	DosFreeModule
	add	esp,04h

; 944                 }
@BLBL157:

; 945             strcpy(szEntryCaptureFileSpec,szCaptureFileSpec);
	mov	edx,offset FLAT:szCaptureFileSpec
	mov	eax,offset FLAT:szEntryCaptureFileSpec
	call	strcpy

; 946             }

; 947           }
@BLBL153:

; 948         pstCFG->bMonitoringStream = TRUE;
	mov	eax,[ebp+010h];	pstCFG
	or	byte ptr [eax+017h],020h

; 949         bStopMonitorThread = FALSE;
	mov	dword ptr  bStopMonitorThread,0h

; 950         DosCreateThread(&tidMonitorThread,(PFNTHREAD)MonitorThread,(ULONG)hCom,0L,4096);
	push	01000h
	push	0h
	push	dword ptr  hCom
	push	offset FLAT: MonitorThread
	push	offset FLAT:tidMonitorThread
	call	DosCreateThread
	add	esp,014h

; 951         if (pstCFG->fDisplaying & DISP_STREAM)
	mov	eax,[ebp+010h];	pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	test	al,01h
	je	@BLBL160

; 952           {
; 953           pstCFG->fDisplaying = DISP_STREAM;
	mov	eax,[ebp+010h];	pstCFG
	mov	bl,[eax+01bh]
	and	bl,0e3h
	or	bl,04h
	mov	[eax+01bh],bl

; 954           if (pstCFG->ulUserSleepCount != 0)
	mov	eax,[ebp+010h];	pstCFG
	cmp	dword ptr [eax+0d1h],0h
	je	@BLBL161

; 955             ulMonitorSleepCount = pstCFG->ulUserSleepCount;
	mov	eax,[ebp+010h];	pstCFG
	mov	eax,[eax+0d1h]
	mov	dword ptr  ulMonitorSleepCount,eax
	jmp	@BLBL162
	align 010h
@BLBL161:

; 956           else
; 957             if (ulMonitorSleepCount > 200)
	cmp	dword ptr  ulMonitorSleepCount,0c8h
	jbe	@BLBL162

; 958               ulMonitorSleepCount = 200;
	mov	dword ptr  ulMonitorSleepCount,0c8h
@BLBL162:

; 959           DosPostEventSem(hevWaitCOMiDataSem);
	push	dword ptr  hevWaitCOMiDataSem
	call	DosPostEventSem
	add	esp,04h

; 960           stRow.lLeadIndex = 0;
	mov	dword ptr  stRow+073h,0h

; 961           bStopDisplayThread = FALSE;
	mov	dword ptr  bStopDisplayThread,0h

; 962           if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL164

; 963             DosCreateThread(&tidDisplayThread,(PFNTHREAD)ColumnDisplayThread,0L,0L,4096);
	push	01000h
	push	0h
	push	0h
	push	offset FLAT: ColumnDisplayThread
	push	offset FLAT:tidDisplayThread
	call	DosCreateThread
	add	esp,014h
	jmp	@BLBL165
	align 010h
@BLBL164:

; 964           else
; 965             DosCreateThread(&tidDisplayThread,(PFNTHREAD)RowDisplayThread,0L,0L,4096);
	push	01000h
	push	0h
	push	0h
	push	offset FLAT: RowDisplayThread
	push	offset FLAT:tidDisplayThread
	call	DosCreateThread
	add	esp,014h
@BLBL165:

; 966           WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 967           }
	jmp	@BLBL167
	align 010h
@BLBL160:

; 968         else
; 969           pstCFG->fDisplaying = 0;
	mov	eax,[ebp+010h];	pstCFG
	and	byte ptr [eax+01bh],0e3h

; 970         }
	jmp	@BLBL167
	align 010h
@BLBL147:

; 971       else
; 972         pstCFG->bMonitoringStream = FALSE;
	mov	eax,[ebp+010h];	pstCFG
	and	byte ptr [eax+017h],0dfh
@BLBL167:

; 973       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL263:

; 974     case IDM_SHOWCOUNTS:
; 975       WinDlgBox(HWND_DESKTOP,hWnd,(PFNWP)fnwpCountsSetupDlgProc,0,DLG_COUNTS,MPFROMP(pstCFG));
	push	dword ptr [ebp+010h];	pstCFG
	push	0238ch
	push	0h
	push	offset FLAT: fnwpCountsSetupDlgProc
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h

; 976       break;
	jmp	@BLBL204
	align 04h
@BLBL264:

; 977     case IDM_SENDBRK:
; 978       if (!bBreakOn)
	cmp	dword ptr  bBreakOn,0h
	jne	@BLBL168

; 979         {
; 980         MenuItemCheck(hwndFrame,IDM_SENDBRK,TRUE);
	push	01h
	push	07f6h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 981         bBreakOn = TRUE;
	mov	dword ptr  bBreakOn,01h

; 982         BreakOn(&stIOctl,hCom,&wStatus);
	lea	eax,[ebp-02h];	wStatus
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	BreakOn
	add	esp,0ch

; 983         }
	jmp	@BLBL169
	align 010h
@BLBL168:

; 984       else
; 985         {
; 986         MenuItemCheck(hwndFrame,IDM_SENDBRK,FALSE);
	push	0h
	push	07f6h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 987         bBreakOn = FALSE;
	mov	dword ptr  bBreakOn,0h

; 988         BreakOff(&stIOctl,hCom,&wStatus);
	lea	eax,[ebp-02h];	wStatus
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	BreakOff
	add	esp,0ch

; 989         }
@BLBL169:

; 990       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL265:

; 991     case IDM_SENDIMM:
; 992       if (!bSendNextKeystroke)
	cmp	dword ptr  bSendNextKeystroke,0h
	jne	@BLBL170

; 993         {
; 994         bSendNextKeystroke = TRUE;
	mov	dword ptr  bSendNextKeystroke,01h

; 995         MenuItemCheck(hwndFrame,IDM_SENDIMM,TRUE);
	push	01h
	push	07fbh
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 996         }
@BLBL170:

; 997       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL266:

; 998     case IDM_OUT1:
; 999       WinDlgBox(HWND_DESKTOP,hWnd,(PFNWP)fnwpHdwModemControlDlg,0,HWM_DLG,MPFROMP(pstCFG));
	push	dword ptr [ebp+010h];	pstCFG
	push	02328h
	push	0h
	push	offset FLAT: fnwpHdwModemControlDlg
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h

; 1000       break;
	jmp	@BLBL204
	align 04h
@BLBL267:

; 1001     case IDM_FXON:
; 1002       ForceXon(&stIOctl,hCom);
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	ForceXon
	add	esp,08h

; 1003       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL268:

; 1004     case IDM_FXOFF:
; 1005       ForceXoff(&stIOctl,hCom);
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	ForceXoff
	add	esp,08h

; 1006       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL269:

; 1007     case IDM_SXON:
; 1008       SendXonXoff(SEND_XON);
	push	01h
	call	SendXonXoff
	add	esp,04h

; 1009       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL270:

; 1010     case IDM_SXOFF:
; 1011       SendXonXoff(SEND_XOFF);
	push	02h
	call	SendXonXoff
	add	esp,04h

; 1012       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL271:

; 1013     case IDM_FINPUT:
; 1014       FlushComBuffer(&stIOctl,hCom,INPUT);
	push	01h
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	FlushComBuffer
	add	esp,0ch

; 1015       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL272:

; 1016     case IDM_FOUTPUT:
; 1017       FlushComBuffer(&stIOctl,hCom,OUTPUT);
	push	02h
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	FlushComBuffer
	add	esp,0ch

; 1018       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL273:

; 1019     case IDM_FBOTH:
; 1020       FlushComBuffer(&stIOctl,hCom,INPUT);
	push	01h
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	FlushComBuffer
	add	esp,0ch

; 1021       FlushComBuffer(&stIOctl,hCom,OUTPUT);
	push	02h
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	FlushComBuffer
	add	esp,0ch

; 1022       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL274:

; 1023     case IDM_BAUDRATE:
; 1024       if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-060h];	hMod
	push	eax
	push	offset FLAT:@STAT1f
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL171

; 1025         {
; 1026         if (DosQueryProcAddr(hMod,0,"HdwBaudRateDialog",(PFN *)&pfnDialog) == NO_ERROR)
	push	offset FLAT:pfnDialog
	push	offset FLAT:@STAT20
	push	0h
	push	dword ptr [ebp-060h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL172

; 1027           {
; 1028 //          MessageBox(hWnd,"Calling \"HdwBaudRateDialog\"");
; 1029           stComCtl.hwndHelpInstance = hwndHelpInstance;
	mov	eax,dword ptr  hwndHelpInstance
	mov	dword ptr  stComCtl+0ah,eax

; 1030           stComCtl.usHelpId = HLPP_BAUD_DLG;
	mov	word ptr  stComCtl+0eh,0753eh

; 1031           pfnDialog(hWnd,&stComCtl);
	push	offset FLAT:stComCtl
	push	dword ptr [ebp+08h];	hWnd
	call	dword ptr  pfnDialog
	add	esp,08h

; 1032           }
	jmp	@BLBL173
	align 010h
@BLBL172:

; 1033         else
; 1034           MessageBox(hWnd,"COM control function \"HdwBaudRateDialog\" not found");
	push	offset FLAT:@STAT21
	push	dword ptr [ebp+08h];	hWnd
	call	MessageBox
	add	esp,08h
@BLBL173:

; 1035         DosFreeModule(hMod);
	push	dword ptr [ebp-060h];	hMod
	call	DosFreeModule
	add	esp,04h

; 1036         }
	jmp	@BLBL174
	align 010h
@BLBL171:

; 1037       else
; 1038         MessageBox(hWnd,"Unable to load COM control library");
	push	offset FLAT:@STAT22
	push	dword ptr [ebp+08h];	hWnd
	call	MessageBox
	add	esp,08h
@BLBL174:

; 1039       break;
	jmp	@BLBL204
	align 04h
@BLBL275:

; 1040     case IDM_PROTO:
; 1041       if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-060h];	hMod
	push	eax
	push	offset FLAT:@STAT23
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL175

; 1042         {
; 1043         if (DosQueryProcAddr(hMod,0,"HdwProtocolDialog",(PFN *)&pfnDialog) == NO_ERROR)
	push	offset FLAT:pfnDialog
	push	offset FLAT:@STAT24
	push	0h
	push	dword ptr [ebp-060h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL176

; 1044           {
; 1045           stComCtl.hwndHelpInstance = hwndHelpInstance;
	mov	eax,dword ptr  hwndHelpInstance
	mov	dword ptr  stComCtl+0ah,eax

; 1046           stComCtl.usHelpId = HLPP_LINE_PROTOCOL_DLG;
	mov	word ptr  stComCtl+0eh,0753dh

; 1047           pfnDialog(hWnd,&stComCtl);
	push	offset FLAT:stComCtl
	push	dword ptr [ebp+08h];	hWnd
	call	dword ptr  pfnDialog
	add	esp,08h

; 1048           }
	jmp	@BLBL177
	align 010h
@BLBL176:

; 1049         else
; 1050           MessageBox(hWnd,"COM control function \"HdwProtocolDialog\" not found");
	push	offset FLAT:@STAT25
	push	dword ptr [ebp+08h];	hWnd
	call	MessageBox
	add	esp,08h
@BLBL177:

; 1051         DosFreeModule(hMod);
	push	dword ptr [ebp-060h];	hMod
	call	DosFreeModule
	add	esp,04h

; 1052         }
	jmp	@BLBL178
	align 010h
@BLBL175:

; 1053       else
; 1054         MessageBox(hWnd,"Unable to load COM control library");
	push	offset FLAT:@STAT26
	push	dword ptr [ebp+08h];	hWnd
	call	MessageBox
	add	esp,08h
@BLBL178:

; 1055       break;
	jmp	@BLBL204
	align 04h
@BLBL276:

; 1056     case IDM_FILTER:
; 1057       if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-060h];	hMod
	push	eax
	push	offset FLAT:@STAT27
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL179

; 1058         {
; 1059         if (DosQueryProcAddr(hMod,0,"HdwFilterDialog",(PFN *)&pfnDialog) == NO_ERROR)
	push	offset FLAT:pfnDialog
	push	offset FLAT:@STAT28
	push	0h
	push	dword ptr [ebp-060h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL180

; 1060           {
; 1061           stComCtl.hwndHelpInstance = hwndHelpInstance;
	mov	eax,dword ptr  hwndHelpInstance
	mov	dword ptr  stComCtl+0ah,eax

; 1062           stComCtl.usHelpId = HLPP_FILTER_DLG;
	mov	word ptr  stComCtl+0eh,07555h

; 1063           pfnDialog(hWnd,&stComCtl);
	push	offset FLAT:stComCtl
	push	dword ptr [ebp+08h];	hWnd
	call	dword ptr  pfnDialog
	add	esp,08h

; 1064           }
	jmp	@BLBL181
	align 010h
@BLBL180:

; 1065         else
; 1066           MessageBox(hWnd,"COM control function \"HdwFilterDialog\" not found");
	push	offset FLAT:@STAT29
	push	dword ptr [ebp+08h];	hWnd
	call	MessageBox
	add	esp,08h
@BLBL181:

; 1067         DosFreeModule(hMod);
	push	dword ptr [ebp-060h];	hMod
	call	DosFreeModule
	add	esp,04h

; 1068         }
	jmp	@BLBL182
	align 010h
@BLBL179:

; 1069       else
; 1070         MessageBox(hWnd,"Unable to load COM control library");
	push	offset FLAT:@STAT2a
	push	dword ptr [ebp+08h];	hWnd
	call	MessageBox
	add	esp,08h
@BLBL182:

; 1071       break;
	jmp	@BLBL204
	align 04h
@BLBL277:

; 1072     case IDM_FIFO:
; 1073       if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-060h];	hMod
	push	eax
	push	offset FLAT:@STAT2b
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL183

; 1074       {
; 1075         if (DosQueryProcAddr(hMod,0,"HdwFIFOsetupDialog",(PFN *)&pfnDialog) == NO_ERROR)
	push	offset FLAT:pfnDialog
	push	offset FLAT:@STAT2c
	push	0h
	push	dword ptr [ebp-060h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL184

; 1076           {
; 1077           stComCtl.hwndHelpInstance = hwndHelpInstance;
	mov	eax,dword ptr  hwndHelpInstance
	mov	dword ptr  stComCtl+0ah,eax

; 1078           stComCtl.usHelpId = HLPP_FIFO_DLG;
	mov	word ptr  stComCtl+0eh,07556h

; 1079           pfnDialog(hWnd,&stComCtl);
	push	offset FLAT:stComCtl
	push	dword ptr [ebp+08h];	hWnd
	call	dword ptr  pfnDialog
	add	esp,08h

; 1080           }
	jmp	@BLBL185
	align 010h
@BLBL184:

; 1081         else
; 1082           MessageBox(hWnd,"COM control function \"HdwFIFOsetupDialog\" not found");
	push	offset FLAT:@STAT2d
	push	dword ptr [ebp+08h];	hWnd
	call	MessageBox
	add	esp,08h
@BLBL185:

; 1083         DosFreeModule(hMod);
	push	dword ptr [ebp-060h];	hMod
	call	DosFreeModule
	add	esp,04h

; 1084         }
	jmp	@BLBL186
	align 010h
@BLBL183:

; 1085       else
; 1086         MessageBox(hWnd,"Unable to load COM control library");
	push	offset FLAT:@STAT2e
	push	dword ptr [ebp+08h];	hWnd
	call	MessageBox
	add	esp,08h
@BLBL186:

; 1087       break;
	jmp	@BLBL204
	align 04h
@BLBL278:

; 1088     case IDM_HANDSHAKE:
; 1089       if (DosLoadModule(0,0,COMCTL_
; 1089 LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-060h];	hMod
	push	eax
	push	offset FLAT:@STAT2f
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL187

; 1090         {
; 1091         if (DosQueryProcAddr(hMod,0,"HdwHandshakeDialog",(PFN *)&pfnDialog) == NO_ERROR)
	push	offset FLAT:pfnDialog
	push	offset FLAT:@STAT30
	push	0h
	push	dword ptr [ebp-060h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL188

; 1092           {
; 1093           stComCtl.hwndHelpInstance = hwndHelpInstance;
	mov	eax,dword ptr  hwndHelpInstance
	mov	dword ptr  stComCtl+0ah,eax

; 1094           stComCtl.usHelpId = HLPP_HANDSHAKE_DLG;
	mov	word ptr  stComCtl+0eh,07557h

; 1095           pfnDialog(hWnd,&stComCtl);
	push	offset FLAT:stComCtl
	push	dword ptr [ebp+08h];	hWnd
	call	dword ptr  pfnDialog
	add	esp,08h

; 1096           }
	jmp	@BLBL189
	align 010h
@BLBL188:

; 1097         else
; 1098           MessageBox(hWnd,"COM control function \"HdwHandshakeDialog\" not found");
	push	offset FLAT:@STAT31
	push	dword ptr [ebp+08h];	hWnd
	call	MessageBox
	add	esp,08h
@BLBL189:

; 1099         DosFreeModule(hMod);
	push	dword ptr [ebp-060h];	hMod
	call	DosFreeModule
	add	esp,04h

; 1100         }
	jmp	@BLBL190
	align 010h
@BLBL187:

; 1101       else
; 1102         MessageBox(hWnd,"Unable to load COM control library");
	push	offset FLAT:@STAT32
	push	dword ptr [ebp+08h];	hWnd
	call	MessageBox
	add	esp,08h
@BLBL190:

; 1103       break;
	jmp	@BLBL204
	align 04h
@BLBL279:

; 1104     case IDM_TIMEOUT:
; 1105       if (DosLoadModule(0,0,COMCTL_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-060h];	hMod
	push	eax
	push	offset FLAT:@STAT33
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL191

; 1106         {
; 1107         if (DosQueryProcAddr(hMod,0,"HdwTimeoutDialog",(PFN *)&pfnDialog) == NO_ERROR)
	push	offset FLAT:pfnDialog
	push	offset FLAT:@STAT34
	push	0h
	push	dword ptr [ebp-060h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL192

; 1108           {
; 1109           stComCtl.hwndHelpInstance = hwndHelpInstance;
	mov	eax,dword ptr  hwndHelpInstance
	mov	dword ptr  stComCtl+0ah,eax

; 1110           stComCtl.usHelpId = HLPP_TIMEOUT_DLG;
	mov	word ptr  stComCtl+0eh,07554h

; 1111           pfnDialog(hWnd,&stComCtl);
	push	offset FLAT:stComCtl
	push	dword ptr [ebp+08h];	hWnd
	call	dword ptr  pfnDialog
	add	esp,08h

; 1112           }
	jmp	@BLBL193
	align 010h
@BLBL192:

; 1113         else
; 1114           MessageBox(hWnd,"COM control function \"HdwTimeoutDialog\" not found");
	push	offset FLAT:@STAT35
	push	dword ptr [ebp+08h];	hWnd
	call	MessageBox
	add	esp,08h
@BLBL193:

; 1115         DosFreeModule(hMod);
	push	dword ptr [ebp-060h];	hMod
	call	DosFreeModule
	add	esp,04h

; 1116         }
	jmp	@BLBL194
	align 010h
@BLBL191:

; 1117       else
; 1118         MessageBox(hWnd,"Unable to load COM control library");
	push	offset FLAT:@STAT36
	push	dword ptr [ebp+08h];	hWnd
	call	MessageBox
	add	esp,08h
@BLBL194:

; 1119       break;
	jmp	@BLBL204
	align 04h
@BLBL280:

; 1120     case IDM_QUERY_INDEX:
; 1121       if (!pstCFG->bColumnDisplay && (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE)))
	mov	eax,[ebp+010h];	pstCFG
	test	byte ptr [eax+018h],080h
	jne	@BLBL195
	mov	eax,[ebp+010h];	pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL195

; 1122         DisplayCharacterInfo(hWnd,0);
	push	0h
	push	dword ptr [ebp+08h];	hWnd
	call	DisplayCharacterInfo
	add	esp,08h
@BLBL195:

; 1123       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL281:

; 1124     case IDM_SEARCH_NEXT:
; 1125       ErrorNotify("  ");
	push	offset FLAT:@STAT37
	call	ErrorNotify
	add	esp,04h

; 1126       if (!(pstCFG->fDisplaying & (DISP_DATA | DISP_FILE)))
	mov	eax,[ebp+010h];	pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	and	eax,06h
	test	eax,eax
	jne	@BLBL196

; 1127         break;
	jmp	@BLBL204
	align 04h
@BLBL196:

; 1128       if (bSearchInit)
	cmp	dword ptr  bSearchInit,0h
	je	@BLBL197

; 1129         {
; 1130         if ((lFoundIndex = SearchCaptureBuffer(pwScrollBuffer,lScrollCount)) == -1)
	push	dword ptr  lScrollCount
	push	dword ptr  pwScrollBuffer
	call	SearchCaptureBuffer
	add	esp,08h
	mov	[ebp-064h],eax;	lFoundIndex
	cmp	dword ptr [ebp-064h],0ffffffffh;	lFoundIndex
	jne	@BLBL198

; 1131           {
; 1132           sprintf(szMessage,"Pattern not Found");
	mov	edx,offset FLAT:@STAT38
	lea	eax,[ebp-058h];	szMessage
	call	_sprintfieee

; 1133           ErrorNotify(szMessage);
	lea	eax,[ebp-058h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1134           }
	jmp	@BLBL199
	align 010h
@BLBL198:

; 1135         else
; 1136 //          if (pstCFG->bShowCounts)
; 1137             {
; 1138             sprintf(szMessage,"Pattern found at Index %u",lFoundIndex);
	push	dword ptr [ebp-064h];	lFoundIndex
	mov	edx,offset FLAT:@STAT39
	lea	eax,[ebp-058h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1139             ErrorNotify(szMessage);
	lea	eax,[ebp-058h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1140             }
@BLBL199:

; 1141         break;
	jmp	@BLBL204
	align 04h
@BLBL197:
@BLBL282:

; 1142         }
; 1143     case IDM_SEARCH:
; 1144       ErrorNotify("  ");
	push	offset FLAT:@STAT3a
	call	ErrorNotify
	add	esp,04h

; 1145       if (!(pstCFG->fDisplaying & (DISP_DATA | DISP_FILE)))
	mov	eax,[ebp+010h];	pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	and	eax,06h
	test	eax,eax
	jne	@BLBL200

; 1146         break;
	jmp	@BLBL204
	align 04h
@BLBL200:

; 1147       if (WinDlgBox(HWND_DESKTOP,hWnd,(PFNWP)fnwpSearchConfigDlgProc,0,FIND_DLG,MPFROMP(pstCFG)))
	push	dword ptr [ebp+010h];	pstCFG
	push	01964h
	push	0h
	push	offset FLAT: fnwpSearchConfigDlgProc
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL201

; 1148         {
; 1149         if ((lFoundIndex = SearchCaptureBuffer(pwScrollBuffer,lScrollCount)) == -1)
	push	dword ptr  lScrollCount
	push	dword ptr  pwScrollBuffer
	call	SearchCaptureBuffer
	add	esp,08h
	mov	[ebp-064h],eax;	lFoundIndex
	cmp	dword ptr [ebp-064h],0ffffffffh;	lFoundIndex
	jne	@BLBL202

; 1150           {
; 1151           sprintf(szMessage,"Pattern not Found");
	mov	edx,offset FLAT:@STAT3b
	lea	eax,[ebp-058h];	szMessage
	call	_sprintfieee

; 1152           ErrorNotify(szMessage);
	lea	eax,[ebp-058h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1153           }
	jmp	@BLBL201
	align 010h
@BLBL202:

; 1154         else
; 1155 //          if (pstCFG->bShowCounts)
; 1156             {
; 1157             sprintf(szMessage,"Pattern found at Index %u",lFoundIndex);
	push	dword ptr [ebp-064h];	lFoundIndex
	mov	edx,offset FLAT:@STAT3c
	lea	eax,[ebp-058h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1158             ErrorNotify(szMessage);
	lea	eax,[ebp-058h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1159             }

; 1160         }
@BLBL201:

; 1161       break;
	jmp	@BLBL204
	align 04h
@BLBL283:

; 1162     case IDM_MSLEEP:
; 1163       WinDlgBox(HWND_DESKTOP,hWnd,(PFNWP)fnwpMonitorSleepDlg,0,MSLEEP_DLG,MPFROMP(pstCFG));
	push	dword ptr [ebp+010h];	pstCFG
	push	0bb8h
	push	0h
	push	offset FLAT: fnwpMonitorSleepDlg
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h

; 1164       break;
	jmp	@BLBL204
	align 04h
@BLBL284:

; 1165     case IDM_HELPABOUT:
; 1166       WinDlgBox(HWND_DESKTOP,hWnd,(PFNWP)AboutBoxDlgProc,0,DLG_ABOUTBOX,MPFROMP(pstCFG));
	push	dword ptr [ebp+010h];	pstCFG
	push	0baeh
	push	0h
	push	offset FLAT: AboutBoxDlgProc
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h

; 1167       break;
	jmp	@BLBL204
	align 04h
@BLBL285:

; 1168     case IDM_STUPDATE:
; 1169       WinDlgBox(HWND_DESKTOP,hWnd,(PFNWP)fnwpUpdateStatusDlg,0,HWSUD_DLG,MPFROMP(pstCFG));
	push	dword ptr [ebp+010h];	pstCFG
	push	0657h
	push	0h
	push	offset FLAT: fnwpUpdateStatusDlg
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h

; 1170       break;
	jmp	@BLBL204
	align 04h
@BLBL286:

; 1171     case IDM_BUFFSIZE:
; 1172       WinDlgBox(HWND_DESKTOP,hWnd,(PFNWP)fnwpBufferSizeDlg,0,BSZ_DLG,MPFROMP(pstCFG));
	push	dword ptr [ebp+010h];	pstCFG
	push	0258h
	push	0h
	push	offset FLAT: fnwpBufferSizeDlg
	push	dword ptr [ebp+08h];	hWnd
	push	01h
	call	WinDlgBox
	add	esp,018h

; 1173       break;
	jmp	@BLBL204
	align 04h
@BLBL287:

; 1174     case IDM_SSELECT:
; 1175       SelectDevice(hWnd,pstCFG);
	push	dword ptr [ebp+010h];	pstCFG
	push	dword ptr [ebp+08h];	hWnd
	call	SelectDevice
	add	esp,08h

; 1176       break;
	jmp	@BLBL204
	align 04h
@BLBL288:

; 1177     default:
; 1178       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL204
	align 04h
@BLBL205:
	cmp	eax,080fh
	je	@BLBL206
	cmp	eax,080eh
	je	@BLBL207
	cmp	eax,080dh
	je	@BLBL208
	cmp	eax,0811h
	je	@BLBL209
	cmp	eax,0230h
	je	@BLBL210
	cmp	eax,07ddh
	je	@BLBL211
	cmp	eax,07e6h
	je	@BLBL212
	cmp	eax,081ch
	je	@BLBL213
	cmp	eax,081dh
	je	@BLBL214
	cmp	eax,081ah
	je	@BLBL215
	cmp	eax,081fh
	je	@BLBL216
	cmp	eax,0fb2h
	je	@BLBL217
	cmp	eax,0fb1h
	je	@BLBL218
	cmp	eax,0fa3h
	je	@BLBL219
	cmp	eax,0fa4h
	je	@BLBL220
	cmp	eax,0fcch
	je	@BLBL221
	cmp	eax,0fcdh
	je	@BLBL222
	cmp	eax,0fc9h
	je	@BLBL223
	cmp	eax,0fc8h
	je	@BLBL224
	cmp	eax,0fbfh
	je	@BLBL225
	cmp	eax,0fbeh
	je	@BLBL226
	cmp	eax,0fc1h
	je	@BLBL227
	cmp	eax,0fc0h
	je	@BLBL228
	cmp	eax,0fbdh
	je	@BLBL229
	cmp	eax,0fbch
	je	@BLBL230
	cmp	eax,081eh
	je	@BLBL231
	cmp	eax,0816h
	je	@BLBL232
	cmp	eax,0fa8h
	je	@BLBL233
	cmp	eax,0fa9h
	je	@BLBL234
	cmp	eax,0815h
	je	@BLBL235
	cmp	eax,0813h
	je	@BLBL236
	cmp	eax,0814h
	je	@BLBL237
	cmp	eax,0fb4h
	je	@BLBL238
	cmp	eax,0fb8h
	je	@BLBL239
	cmp	eax,0fb9h
	je	@BLBL240
	cmp	eax,0fbah
	je	@BLBL241
	cmp	eax,0fb5h
	je	@BLBL242
	cmp	eax,0fb6h
	je	@BLBL243
	cmp	eax,0fbbh
	je	@BLBL244
	cmp	eax,0fb7h
	je	@BLBL245
	cmp	eax,0fach
	je	@BLBL246
	cmp	eax,0fadh
	je	@BLBL247
	cmp	eax,0821h
	je	@BLBL248
	cmp	eax,0820h
	je	@BLBL249
	cmp	eax,07ffh
	je	@BLBL250
	cmp	eax,0800h
	je	@BLBL251
	cmp	eax,07fdh
	je	@BLBL252
	cmp	eax,0802h
	je	@BLBL253
	cmp	eax,0801h
	je	@BLBL254
	cmp	eax,07feh
	je	@BLBL255
	cmp	eax,07d4h
	je	@BLBL256
	cmp	eax,07d7h
	je	@BLBL257
	cmp	eax,0812h
	je	@BLBL258
	cmp	eax,07d3h
	je	@BLBL259
	cmp	eax,07d6h
	je	@BLBL260
	cmp	eax,07e3h
	je	@BLBL261
	cmp	eax,07d9h
	je	@BLBL262
	cmp	eax,0819h
	je	@BLBL263
	cmp	eax,07f6h
	je	@BLBL264
	cmp	eax,07fbh
	je	@BLBL265
	cmp	eax,0818h
	je	@BLBL266
	cmp	eax,07f1h
	je	@BLBL267
	cmp	eax,07f2h
	je	@BLBL268
	cmp	eax,07f4h
	je	@BLBL269
	cmp	eax,07f5h
	je	@BLBL270
	cmp	eax,07f8h
	je	@BLBL271
	cmp	eax,07f9h
	je	@BLBL272
	cmp	eax,07fah
	je	@BLBL273
	cmp	eax,07dah
	je	@BLBL274
	cmp	eax,07e9h
	je	@BLBL275
	cmp	eax,07dbh
	je	@BLBL276
	cmp	eax,07e8h
	je	@BLBL277
	cmp	eax,07e7h
	je	@BLBL278
	cmp	eax,07dch
	je	@BLBL279
	cmp	eax,0828h
	je	@BLBL280
	cmp	eax,0827h
	je	@BLBL281
	cmp	eax,0826h
	je	@BLBL282
	cmp	eax,07e4h
	je	@BLBL283
	cmp	eax,0810h
	je	@BLBL284
	cmp	eax,0803h
	je	@BLBL285
	cmp	eax,0805h
	je	@BLBL286
	cmp	eax,07e5h
	je	@BLBL287
	jmp	@BLBL288
	align 04h
@BLBL204:

; 1179     }
; 1180   WinInvalidateRect(hWnd, NULL, FALSE );/* Update client area        */
	push	0h
	push	0h
	push	dword ptr [ebp+08h];	hWnd
	call	WinInvalidateRect
	add	esp,0ch

; 1181   return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
WinCommand	endp

; 1185   {
	align 010h

	public SelectDevice
SelectDevice	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0b4h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,02dh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 1218   if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-010h];	hMod
	push	eax
	push	offset FLAT:@STAT3d
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL289

; 1219     {
; 1220     if (DosQueryProcAddr(hMod,0,"PortSelectDialog",(PFN *)&pfnDialog) == NO_ERROR)
	push	offset FLAT:pfnDialog
	push	offset FLAT:@STAT3e
	push	0h
	push	dword ptr [ebp-010h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL290

; 1221       {
; 1222       stCOMiCFG.bEnumCOMscope = TRUE;
	or	byte ptr  stCOMiCFG+04bh,08h

; 1223       strcpy(szPortName,pstCFG->szPortName);
	mov	edx,[ebp+0ch];	pstCFG
	add	edx,02h
	lea	eax,[ebp-0b0h];	szPortName
	call	strcpy

; 1224       stCOMiCFG.pszPortName = szPortName;
	lea	eax,[ebp-0b0h];	szPortName
	mov	dword ptr  stCOMiCFG+014h,eax

; 1225       stCOMiCFG.bPortActive = bPortActive;
	mov	ecx,dword ptr  bPortActive
	mov	al,byte ptr  stCOMiCFG+04bh
	and	al,0dfh
	sal	ecx,05h
	and	cl,03fh
	or	al,cl
	mov	byte ptr  stCOMiCFG+04bh,al

; 1226       rc = pfnDialog(hwnd,&stCOMiCFG);
	push	offset FLAT:stCOMiCFG
	push	dword ptr [ebp+08h];	hwnd
	call	dword ptr  pfnDialog
	add	esp,08h
	mov	[ebp-0b4h],eax;	rc

; 1227       switch (rc)
	mov	eax,[ebp-0b4h];	rc
	jmp	@BLBL300
	align 04h
@BLBL301:

; 1228         {
; 1229         case PORT_SELECTED:
; 1230           if ((strcmp(szPortName,pstCFG->szPortName) != 0) || (hCom == 0xffffffff))
	mov	edx,[ebp+0ch];	pstCFG
	add	edx,02h
	lea	eax,[ebp-0b0h];	szPortName
	call	strcmp
	test	eax,eax
	jne	@BLBL291
	cmp	dword ptr  hCom,0ffffffffh
	jne	@BLBL292
@BLBL291:

; 1231             {
; 1232             strcpy(pstCFG->szPortName,szPortName);
	lea	edx,[ebp-0b0h];	szPortName
	mov	eax,[ebp+0ch];	pstCFG
	add	eax,02h
	call	strcpy

; 1233             KillDisplayThread();
	call	KillDisplayThread

; 1234             KillMonitorThread();
	call	KillMonitorThread

; 1235             pstCFG->bMonitoringStream = FALSE;
	mov	eax,[ebp+0ch];	pstCFG
	and	byte ptr [eax+017h],0dfh

; 1236             WinSendMsg(hwndStatAll,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0L);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndStatAll
	call	WinSendMsg
	add	esp,010h

; 1237             MenuItemEnable(hwndFrame,IDM_SETUP,FALSE);
	push	0h
	push	07d5h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1238             MenuItemEnable(hwndFrame,IDM_STATUS,FALSE);
	push	0h
	push	07fch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1239             MenuItemEnable(hwndFrame,IDM_IOCTL,FALSE);
	push	0h
	push	07efh
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1240             if (hCom != 0xffffffff)
	cmp	dword ptr  hCom,0ffffffffh
	je	@BLBL293

; 1241               {
; 1242               DosClose(hCom);
	push	dword ptr  hCom
	call	DosClose
	add	esp,04h

; 1243               hCom = -1;
	mov	dword ptr  hCom,0ffffffffh

; 1244               }
@BLBL293:

; 1245             if (!OpenPort(hwndFrame,&hCom,pstCFG))
	push	dword ptr [ebp+0ch];	pstCFG
	push	offset FLAT:hCom
	push	dword ptr  hwndFrame
	call	OpenPort
	add	esp,0ch
	test	eax,eax
	jne	@BLBL294

; 1246               {
; 1247               pstCFG->szPortName[0] = 0;
	mov	eax,[ebp+0ch];	pstCFG
	mov	byte ptr [eax+02h],0h

; 1248               WinSendMsg(hwndStatDev,UM_KILL_MONITOR,0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatDev
	call	WinSendMsg
	add	esp,010h

; 1249               WinSendMsg(hwndStatRcvBuf,UM_KILL_MONITOR,0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatRcvBuf
	call	WinSendMsg
	add	esp,010h

; 1250               WinSendMsg(hwndStatXmitBuf,UM_KILL_MONITOR,0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatXmitBuf
	call	WinSendMsg
	add	esp,010h

; 1251               WinSendMsg(hwndStatModemIn,UM_KILL_MONITOR,0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatModemIn
	call	WinSendMsg
	add	esp,010h

; 1252               WinSendMsg(hwndStatModemOut,UM_KILL_MONITOR,0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatModemOut
	call	WinSendMsg
	add	esp,010h

; 1253               WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 1254               }
	jmp	@BLBL292
	align 010h
@BLBL294:

; 1255             else
; 1256               {
; 1257               WinSendMsg(hwndStatDev,UM_RESET_NAME,0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08022h
	push	dword ptr  hwndStatDev
	call	WinSendMsg
	add	esp,010h

; 1258               WinSendMsg(hwndStatRcvBuf,UM_RESET_NAME,0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08022h
	push	dword ptr  hwndStatRcvBuf
	call	WinSendMsg
	add	esp,010h

; 1259               WinSendMsg(hwndStatXmitBuf,UM_RESET_NAME,0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08022h
	push	dword ptr  hwndStatXmitBuf
	call	WinSendMsg
	add	esp,010h

; 1260               WinSendMsg(hwndStatModemIn,UM_RESET_NAME,0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08022h
	push	dword ptr  hwndStatModemIn
	call	WinSendMsg
	add	esp,010h

; 1261               WinSendMsg(hwndStatModemOut,UM_RESET_NAME,0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08022h
	push	dword ptr  hwndStatModemOut
	call	WinSendMsg
	add	esp,010h

; 1262               if (GetDCB(&stIOctl,hCom,&stDCB) == NO_ERROR)
	lea	eax,[ebp-0bh];	stDCB
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetDCB
	add	esp,0ch
	test	eax,eax
	jne	@BLBL292

; 1263                 {
; 1264                 MenuItemEnable(hwndFrame,IDM_MSTREAM,TRUE);
	push	01h
	push	07d9h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1265                 MenuItemEnable(hwndFrame,IDM_SETUP,TRUE);
	push	01h
	push	07d5h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1266                 MenuItemEnable(hwndFrame,IDM_STATUS,TRUE);
	push	01h
	push	07fch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1267                 MenuItemEnable(hwndFrame,IDM_IOCTL,TRUE);
	push	01h
	push	07efh
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 1268                 if ((stDCB.Flags3 & F3_HDW_BUFFER_APO) == 0) // mask only
	test	byte ptr [ebp-05h],018h;	stDCB
	jne	@BLBL297

; 1269                   MenuItemEnable(hwndFrame,IDM_FIFO,FALSE);
	push	0h
	push	07e8h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
	jmp	@BLBL298
	align 010h
@BLBL297:

; 1270                 else
; 1271                   MenuItemEnable(hwndFrame,IDM_FIFO,TRUE);
	push	01h
	push	07e8h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
@BLBL298:

; 1272                 sprintf(szCaption,"COMscope -> %s",pstCFG->szPortName);
	mov	eax,[ebp+0ch];	pstCFG
	add	eax,02h
	push	eax
	mov	edx,offset FLAT:@STAT3f
	lea	eax,[ebp-09ch];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1273                 strcpy(szCurrentPortName,pstCFG->szPortName);
	mov	edx,[ebp+0ch];	pstCFG
	add	edx,02h
	mov	eax,offset FLAT:szCurrentPortName
	call	strcpy

; 1274                 WinSetWindowText(hwndFrame,szCaption);
	lea	eax,[ebp-09ch];	szCaption
	push	eax
	push	dword ptr  hwndFrame
	call	WinSetWindowText
	add	esp,08h

; 1275                 }

; 1276               }

; 1277             }
@BLBL292:

; 1278           break;
	jmp	@BLBL299
	align 04h
@BLBL302:

; 1279         case NO_COMSCOPE_AVAIL:
; 1280           sprintf(szCaption,"No Available COMscope Devices");
	mov	edx,offset FLAT:@STAT40
	lea	eax,[ebp-09ch];	szCaption
	call	_sprintfieee

; 1281           sprintf(szMessage,"All COMscope accessable ports have been activated by other COMscope sessions.");
	mov	edx,offset FLAT:@STAT41
	lea	eax,[ebp-074h];	szMessage
	call	_sprintfieee

; 1282           WinMessageBox(HWND_DESKTOP,
	push	02020h
	push	075aeh
	lea	eax,[ebp-09ch];	szCaption
	push	eax
	lea	eax,[ebp-074h];	szMessage
	push	eax
	push	dword ptr  hwndFrame
	push	01h
	call	WinMessageBox
	add	esp,018h

; 1283                         hwndFrame,
; 1284                         szMessage,
; 1285                         szCaption,
; 1286                         HLPP_MB_NO_COMSCOPE_LEFT,
; 1287                         (MB_OK | MB_HELP | MB_ICONEXCLAMATION));
; 1288           break;
	jmp	@BLBL299
	align 04h
@BLBL303:

; 1289         case NO_PORT_AVAILABLE:
; 1290           sprintf(szCaption,"No COM Devices Defined");
	mov	edx,offset FLAT:@STAT42
	lea	eax,[ebp-09ch];	szCaption
	call	_sprintfieee

; 1291           sprintf(szMessage,"Select \"Device | Device Install\" to install COM support");
	mov	edx,offset FLAT:@STAT43
	lea	eax,[ebp-074h];	szMessage
	call	_sprintfieee

; 1292           WinMessageBox(HWND_DESKTOP,
	push	02020h
	push	075aeh
	lea	eax,[ebp-09ch];	szCaption
	push	eax
	lea	eax,[ebp-074h];	szMessage
	push	eax
	push	dword ptr  hwndFrame
	push	01h
	call	WinMessageBox
	add	esp,018h

; 1293                         hwndFrame,
; 1294                         szMessage,
; 1295                         szCaption,
; 1296                         HLPP_MB_NO_COMSCOPE_LEFT,
; 1297                         (MB_OK | MB_HELP | MB_ICONEXCLAMATION));
; 1298           break;
	jmp	@BLBL299
	align 04h
@BLBL304:

; 1299         default:
; 1300           break;
	jmp	@BLBL299
	align 04h
	jmp	@BLBL299
	align 04h
@BLBL300:
	cmp	eax,03h
	je	@BLBL301
	cmp	eax,05h
	je	@BLBL302
	cmp	eax,04h
	je	@BLBL303
	jmp	@BLBL304
	align 04h
@BLBL299:

; 1301         }
; 1302       }
@BLBL290:

; 1303     DosFreeModule(hMod);
	push	dword ptr [ebp-010h];	hMod
	call	DosFreeModule
	add	esp,04h

; 1304     }
@BLBL289:

; 1305   }
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
SelectDevice	endp
CODE32	ends
end
