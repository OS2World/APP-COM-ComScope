	title	p:\COMscope\csutil.c
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
	public	bPortActive
	extrn	DosLoadModule:proc
	extrn	DosQueryProcAddr:proc
	extrn	DosFreeModule:proc
	extrn	strcpy:proc
	extrn	AppendTripleDS:proc
	extrn	DosOpen:proc
	extrn	_sprintfieee:proc
	extrn	WinMessageBox:proc
	extrn	DosClose:proc
	extrn	MenuItemEnable:proc
	extrn	GetDCB:proc
	extrn	GetBaudRate:proc
	extrn	WinInvalidateRect:proc
	extrn	DosBeep:proc
	extrn	SendByteImmediate:proc
	extrn	strlen:proc
	extrn	strtol:proc
	extrn	COMscopeOpenFilterProc:proc
	extrn	GetFileName:proc
	extrn	DosQueryFileInfo:proc
	extrn	DosSetFileSize:proc
	extrn	DosSetFilePtr:proc
	extrn	DosWrite:proc
	extrn	DosAllocMem:proc
	extrn	DosFreeMem:proc
	extrn	DosRead:proc
	extrn	atoi:proc
	extrn	MenuItemCheck:proc
	extrn	WinSendMsg:proc
	extrn	CountTraceElement:proc
	extrn	DosDevIOCtl:proc
	extrn	fnwpDCBpacketDlgProc:proc
	extrn	WinDlgBox:proc
	extrn	fnwpCOMstatusStatesDlg:proc
	extrn	fnwpXmitStatusStatesDlg:proc
	extrn	fnwpCOMerrorStatesDlg:proc
	extrn	fnwpCOMeventStatesDlg:proc
	extrn	_fullDump:dword
	extrn	bDriverNotLoaded:dword
	extrn	stCOMiCFG:byte
	extrn	pfnInstallDevice:dword
	extrn	ulCOMscopeBufferSize:dword
	extrn	hwndFrame:dword
	extrn	stIOctl:byte
	extrn	hCom:dword
	extrn	stComCtl:byte
	extrn	szErrorMessage:byte
	extrn	hwndStatus:dword
	extrn	stCFG:byte
	extrn	ulCalcSleepCount:dword
	extrn	ulMonitorSleepCount:dword
	extrn	hwndClient:dword
	extrn	bSendNextKeystroke:dword
	extrn	stRead:byte
	extrn	stWrite:byte
	extrn	stRow:byte
	extrn	lScrollCount:dword
	extrn	pwScrollBuffer:dword
	extrn	_ctype:dword
	extrn	bCOMscopeEnabled:dword
DATA32	segment
@STAT1	db "CFG_DEB",0h
@STAT2	db "InstallDevice",0h
	align 04h
@STAT3	db "Device Uninstalled!",0h
@STAT4	db "%s was uninstalled at in"
db "itialization by another "
db "device driver.",0h
	align 04h
@STAT5	db "Device In Use!",0h
	align 04h
@STAT6	db "%s is currently being ac"
db "cessed by another COMsco"
db "pe session.",0h
@STAT7	db "COMscope Resource Unavai"
db "lable",0h
	align 04h
@STAT8	db "A resource required by %"
db "s is not available?",0h
@STAT9	db "COMscope Device Undefine"
db "d",0h
	align 04h
@STATa	db "Do you want to Install C"
db "OMscope support %s?",0h
@STATb	db "CFG_DEB",0h
@STATc	db "InstallDevice",0h
	align 04h
@STATd	db "001",0h
@STATe	db "%03X",0h
	align 04h
@STATf	db ".001",0h
	align 04h
@STAT10	db "Cannot find file %s.",0h
	align 04h
@STAT11	db "Cannot find path %s.",0h
	align 04h
@STAT12	db "Disk is full, unable to "
db "open %s for writing.",0h
	align 04h
@STAT13	db "Access denied for writin"
db "g %s.",0h
	align 04h
@STAT14	db "Failed to open %s. ec = "
db "%u",0h
	align 04h
@STAT15	db "Would you like to select"
db " another?",0h
	align 04h
@STAT16	db "Select a different file."
db 0h
	align 04h
@STAT17	db "File already exists.",0h
	align 04h
@STAT18	db "The designated file %s a"
db "lready exists.",0ah,0ah,"Do you w"
db "ant to overwrite it?",0h
	align 04h
@STAT19	db "Select a different file."
db 0h
	align 04h
@STAT1a	db "Disk is full, capture to"
db " file aborted.",0h
	align 04h
@STAT1b	db "Disk is full, unable to "
db "write to %s.",0h
	align 04h
@STAT1c	db "Write to %s failed. ec ="
db " %u",0h
@STAT1d	db "%u total characters writ"
db "ten to %s",0h
	align 04h
@STAT1e	db "%u characters written to"
db " %s",0h
@STAT1f	db "Cannot find file %s.",0h
	align 04h
@STAT20	db "Cannot find path %s.",0h
	align 04h
@STAT21	db "Access denied for readin"
db "g %s.",0h
	align 04h
@STAT22	db "Failed to open %s. ec = "
db "%u",0h
	align 04h
@STAT23	db "Would you like to select"
db " another?",0h
	align 04h
@STAT24	db "Select a different file."
db 0h
	align 04h
@STAT25	db "%s is larger than Buffer"
db " size.",0h
	align 04h
@STAT26	db "Do you want to increase "
db "buffer size to accomodat"
db "e size of file?",0h
@STAT27	db "Out of Memory",0h
	align 04h
@STAT28	db "Unable to allocate enoug"
db "h memory to read file.",0h
	align 04h
@STAT29	db "Memory allocation error."
db " ec = %u",0h
	align 04h
@STAT2a	db "Unable to allocate memor"
db "y to read file",0h
	align 04h
@STAT2b	db "Read from %s failed. ec "
db "= %u",0h
	align 04h
@STAT2c	db "%u characters read from "
db "%s",0h
	align 04h
@STAT2d	db "%u byte read request",0h
	align 04h
@STAT2e	db "Read request",0h
	align 04h
@STAT2f	db " - %u level packet queue"
db "d",0h
	align 04h
@STAT30	db "%u byte read",0h
	align 04h
@STAT31	db "%u bytes read",0h
	align 04h
@STAT32	db "Read completed",0h
	align 04h
@STAT33	db " - %u level packet deque"
db "ued",0h
@STAT34	db "%u byte write request",0h
	align 04h
@STAT35	db "Write request",0h
	align 04h
@STAT36	db " - %u level packet queue"
db "d",0h
	align 04h
@STAT37	db "%u byte written",0h
@STAT38	db "%u bytes written",0h
	align 04h
@STAT39	db "Write completed",0h
@STAT3a	db " - %u level packet deque"
db "ued",0h
@STAT3b	db "Unknown request -> value"
db " is 0x%04X",0h
	align 04h
@STAT3c	db "DevIOCtl, set baud Rate",0h
@STAT3d	db " -> %u",0h
	align 04h
@STAT3e	db "DevIOCtl, set line chara"
db "cteristics",0h
	align 04h
@STAT3f	db " -> %u, ",0h
	align 04h
@STAT40	db "none, ",0h
	align 04h
@STAT41	db "odd, ",0h
	align 04h
@STAT42	db "even, ",0h
	align 04h
@STAT43	db "one, ",0h
	align 04h
@STAT44	db "zero, ",0h
@STAT45	db "1",0h
	align 04h
@STAT46	db "1.5",0h
@STAT47	db "2",0h
	align 04h
@STAT48	db "DevIOCtl, set extended b"
db "aud rate",0h
	align 04h
@STAT49	db " -> %u",0h
	align 04h
@STAT4a	db "DevIOCtl, transmit byte "
db "immediate",0h
	align 04h
@STAT4b	db " -> 0x%02X",0h
	align 04h
@STAT4c	db "DevIOCtl, set modem outp"
db "ut signals",0h
	align 04h
@STAT4d	db " - DTR->on ",0h
@STAT4e	db " - DTR->off",0h
@STAT4f	db " RTS->on",0h
	align 04h
@STAT50	db " RTS->off",0h
	align 04h
@STAT51	db "DevIOCtl, set DCB parame"
db "ters",0h
	align 04h
@STAT52	db "DevIOCtl, set extended F"
db "IFO processing",0h
	align 04h
@STAT53	db " -> %u",0h
	align 04h
@STAT54	db "DevIOCtl, set thresholds"
db 0h
	align 04h
@STAT55	db " -> %u",0h
	align 04h
@STAT56	db "DevIOCtl, query baud rat"
db "e",0h
	align 04h
@STAT57	db " -> %u",0h
	align 04h
@STAT58	db "DevIOCtl, query line cha"
db "racteristics",0h
	align 04h
@STAT59	db " -> %u, ",0h
	align 04h
@STAT5a	db "none, ",0h
	align 04h
@STAT5b	db "odd, ",0h
	align 04h
@STAT5c	db "even, ",0h
	align 04h
@STAT5d	db "one, ",0h
	align 04h
@STAT5e	db "zero, ",0h
@STAT5f	db "1",0h
	align 04h
@STAT60	db "1.5",0h
@STAT61	db "2",0h
	align 04h
@STAT62	db "DevIOCtl, query extended"
db " baud rate",0h
	align 04h
@STAT63	db " -> %u, min=%u, max=%u",0h
	align 04h
@STAT64	db "DevIOCtl, query COM stat"
db "us",0h
	align 04h
@STAT65	db " -> 0x%02X",0h
	align 04h
@STAT66	db "DevIOCtl, query transmit"
db " data status",0h
	align 04h
@STAT67	db " -> 0x%02X",0h
	align 04h
@STAT68	db "DevIOCtl, query output m"
db "odem signals",0h
	align 04h
@STAT69	db " - DTR->on ",0h
@STAT6a	db " - DTR->off",0h
@STAT6b	db " RTS->on",0h
	align 04h
@STAT6c	db " RTS->off",0h
	align 04h
@STAT6d	db "DevIOCtl, query input mo"
db "dem signals",0h
@STAT6e	db " - CTS->on  ",0h
	align 04h
@STAT6f	db " - CTS->off ",0h
	align 04h
@STAT70	db "DSR->on  ",0h
	align 04h
@STAT71	db "DSR->off ",0h
	align 04h
@STAT72	db "CD->on",0h
	align 04h
@STAT73	db "CD->off",0h
@STAT74	db "DevIOCtl, query receive "
db "queue",0h
	align 04h
@STAT75	db " -> %u in %u byte queue",0h
@STAT76	db "DevIOCtl, query transmit"
db " queue",0h
	align 04h
@STAT77	db " -> %u in %u byte queue",0h
@STAT78	db "DevIOCtl, query COM erro"
db "r",0h
	align 04h
@STAT79	db " -> 0x%04X",0h
	align 04h
@STAT7a	db "DevIOCtl, query COM even"
db "t info",0h
	align 04h
@STAT7b	db " -> 0x%04X",0h
	align 04h
@STAT7c	db "DevIOCtl, query DCB para"
db "meters",0h
	align 04h
@STAT7d	db "DevIOCtl, query FIFO inf"
db "o",0h
	align 04h
@STAT7e	db " -> %u",0h
	align 04h
@STAT7f	db "DevIOCtl, query threshol"
db "d info",0h
	align 04h
@STAT80	db " -> %u",0h
	align 04h
@STAT81	db "Unsupported function -> "
db "0x%02X",0h
	align 04h
@STAT82	db "No information",0h
	align 04h
@STAT83	db "Read stream <- ",0h
@STAT84	db "%c",0h
	align 04h
@STAT85	db "0x%02X ",0h
@STAT86	db "Xon/Xoff character recei"
db "ved <- ",0h
@STAT87	db "%c",0h
	align 04h
@STAT88	db "0x%02X ",0h
@STAT89	db "Write stream -> ",0h
@STAT8a	db "%c",0h
@STAT8b	db "0x%02X ",0h
@STAT8c	db "Xon/Xoff or transmit byt"
db "e immediate -> ",0h
@STAT8d	db "%c",0h
	align 04h
@STAT8e	db "0x%02X ",0h
@STAT8f	db "Output buffer flushed",0h
	align 04h
@STAT90	db "Input buffer flushed",0h
	align 04h
@STAT91	db "DevIOCtl, set line BREAK"
db " off",0h
	align 04h
@STAT92	db "DevIOCtl, act like Xoff "
db "received",0h
	align 04h
@STAT93	db "DevIOCtl, act like Xon s"
db "ignal received",0h
	align 04h
@STAT94	db "DevIOCtl, set line BREAK"
db " on",0h
@STAT95	db "DevIOCtl, set enhanced m"
db "ode (not supported)",0h
@STAT96	db "DevIOCtl, query enhanced"
db " mode (not supported)",0h
	align 04h
@STAT97	db "First level DosOpen requ"
db "est",0h
@STAT98	db "Second level DosOpen req"
db "uest",0h
	align 04h
@STAT99	db "First level DosClose com"
db "plete",0h
	align 04h
@STAT9a	db "Second level DosClose co"
db "mplete",0h
	align 04h
@STAT9b	db "Begin sending line BREAK"
db 0h
	align 04h
@STAT9c	db "Stop sending line BREAK",0h
@STAT9d	db "Receive line BREAK detec"
db "ted",0h
@STAT9e	db "Modem input signal(s) ch"
db "anged - ",0h
	align 04h
@STAT9f	db "CTS->on  ",0h
	align 04h
@STATa0	db "CTS->off ",0h
	align 04h
@STATa1	db "DSR->on  ",0h
	align 04h
@STATa2	db "DSR->off ",0h
	align 04h
@STATa3	db "RI->on  ",0h
	align 04h
@STATa4	db "RI->off ",0h
	align 04h
@STATa5	db "CD->on",0h
	align 04h
@STATa6	db "CD->off",0h
@STATa7	db "Modem output signals cha"
db "nged - ",0h
@STATa8	db "DTR->on  ",0h
	align 04h
@STATa9	db "DTR->off ",0h
	align 04h
@STATaa	db "RTS->on",0h
@STATab	db "RTS->off",0h
	align 04h
@STATac	db "Device driver receive bu"
db "ffer overflow",0h
	align 04h
@STATad	db "Hardware error - ",0h
	align 04h
@STATae	db "Parity ",0h
@STATaf	db "Overrun ",0h
	align 04h
@STATb0	db " Framing",0h
	align 04h
@STATb1	db "Unknown key -> value is "
db "0x%04X",0h
	align 04h
@STATb2	db "Error Reading Port - %X",0h
@STATb3	db "DOS error enabling strea"
db "m monitoring -> 0x%X",0h
	align 04h
@STATb4	db "COMscope monitoring is n"
db "ot supported.",0h
	align 04h
@STATb5	db "This version of COMscope"
db " cannot monitor a device"
db " controlled by the evalu"
db "ation version of COMi (C"
db "OMDDE.SYS).",0ah,0ah,"You may, ho"
db "wever, use this version "
db "of COMscope to create an"
db "d/or edit an initializat"
db "ion file for the evaluat"
db "ion version of COMi.",0h
	align 04h
@STATb6	db "This version of COMscope"
db " is not compatable with "
db "the version of COMi that"
db " is currently loaded.",0ah,0ah,"P"
db "lease contact OS/tools I"
db "ncorporated for upgrade "
db "information.",0ah,0ah,"See the ",022h,"A"
db "bout COMscope",022h," dialog in"
db " the ",022h,"Help",022h," menu for inf"
db "ormation on COMi and COM"
db "scope versions and how t"
db "o contact OS/tools.",0h
@STATb7	db "%s is unable to support "
db "COMscope.",0h
	align 04h
@STATb8	db "This device is not confi"
db "gured for COMscope.  Use"
db " Install function to ena"
db "ble COMscope for next OS"
db "/2 session.",0h
DATA32	ends
BSS32	segment
bPortActive	dd 0h
@84bAltKeyDown	dd 0h
@85iKeyIndex	dd 0h
@88abyKeys	db 04h DUP (0h)
BSS32	ends
CODE32	segment

; 47   {
	align 010h

	public OpenPort
OpenPort	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0c8h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,032h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 57   if (bDriverNotLoaded)
	cmp	dword ptr  bDriverNotLoaded,0h
	je	@BLBL1

; 58     {
; 59     if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-0c8h];	hMod
	push	eax
	push	offset FLAT:@STAT1
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL2

; 60       {
; 61       stCOMiCFG.pszPortName = pstCFG->szPortName;
	mov	eax,[ebp+010h];	pstCFG
	add	eax,02h
	mov	dword ptr  stCOMiCFG+014h,eax

; 62       stCOMiCFG.bInstallCOMscope = TRUE;
	or	byte ptr  stCOMiCFG+04bh,02h

; 63       if (DosQueryProcAddr(hMod,0,"InstallDevice",(PFN *)&pfnInstallDevice) == NO_ERROR)
	push	offset FLAT:pfnInstallDevice
	push	offset FLAT:@STAT2
	push	0h
	push	dword ptr [ebp-0c8h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL3

; 64         pfnInstallDevice(&stCOMiCFG);
	push	offset FLAT:stCOMiCFG
	call	dword ptr  pfnInstallDevice
	add	esp,04h
@BLBL3:

; 65       DosFreeModule(hMod);
	push	dword ptr [ebp-0c8h];	hMod
	call	DosFreeModule
	add	esp,04h

; 66       }
@BLBL2:

; 67     return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL1:

; 68     }
; 69   else
; 70     {
; 71     strcpy(szCOMname,pstCFG->szPortName);
	mov	edx,[ebp+010h];	pstCFG
	add	edx,02h
	lea	eax,[ebp-0aeh];	szCOMname
	call	strcpy

; 72     AppendTripleDS(szCOMname);
	lea	eax,[ebp-0aeh];	szCOMname
	push	eax
	call	AppendTripleDS
	add	esp,04h

; 73     if ((rc = DosOpen(szCOMname,phCom,&ulAction,0L,0L,0x0001,0x21c2,0L)) != 0)
	push	0h
	push	021c2h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-04h];	ulAction
	push	eax
	push	dword ptr [ebp+0ch];	phCom
	lea	eax,[ebp-0aeh];	szCOMname
	push	eax
	call	DosOpen
	add	esp,020h
	mov	[ebp-0b8h],eax;	rc
	cmp	dword ptr [ebp-0b8h],0h;	rc
	je	@BLBL5

; 74       {
; 75       switch (rc)
	mov	eax,[ebp-0b8h];	rc
	jmp	@BLBL15
	align 04h
@BLBL16:

; 76         {
; 77         case ERROR_BAD_UNIT:
; 78           sprintf(szCaption,"Device Uninstalled!");
	mov	edx,offset FLAT:@STAT3
	lea	eax,[ebp-0a4h];	szCaption
	call	_sprintfieee

; 79           sprintf(szMessage,"%s was uninstalled at initialization by another device driver.",pstCFG->szPortName);
	mov	eax,[ebp+010h];	pstCFG
	add	eax,02h
	push	eax
	mov	edx,offset FLAT:@STAT4
	lea	eax,[ebp-054h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 80           WinMessageBox(HWND_DESKTOP,
	push	04020h
	push	0h
	lea	eax,[ebp-0a4h];	szCaption
	push	eax
	lea	eax,[ebp-054h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinMessageBox
	add	esp,018h

; 81                         hwndDlg,
; 82                         szMessage,
; 83                         szCaption,
; 84                         0L,
; 85                         MB_MOVEABLE | MB_OK | MB_CUAWARNING);
; 86           break;
	jmp	@BLBL14
	align 04h
@BLBL17:

; 87         case ERROR_DEVICE_IN_USE:
; 88           sprintf(szCaption,"Device In Use!");
	mov	edx,offset FLAT:@STAT5
	lea	eax,[ebp-0a4h];	szCaption
	call	_sprintfieee

; 89           sprintf(szMessage,"%s is currently being accessed by another COMscope session.",pstCFG->szPortName);
	mov	eax,[ebp+010h];	pstCFG
	add	eax,02h
	push	eax
	mov	edx,offset FLAT:@STAT6
	lea	eax,[ebp-054h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 90           WinMessageBox(HWND_DESKTOP,
	push	04020h
	push	0h
	lea	eax,[ebp-0a4h];	szCaption
	push	eax
	lea	eax,[ebp-054h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinMessageBox
	add	esp,018h

; 91                         hwndDlg,
; 92                         szMessage,
; 93                         szCaption,
; 94                         0L,
; 95                         MB_MOVEABLE | MB_OK | MB_CUAWARNING);
; 96           break;
	jmp	@BLBL14
	align 04h
@BLBL18:

; 97         case ERROR_SHARING_VIOLATION:
; 98           sprintf(szCaption,"COMscope Resource Unavailable");
	mov	edx,offset FLAT:@STAT7
	lea	eax,[ebp-0a4h];	szCaption
	call	_sprintfieee

; 99           sprintf(szMessage,"A resource required by %s is not available?",pstCFG->szPortName);
	mov	eax,[ebp+010h];	pstCFG
	add	eax,02h
	push	eax
	mov	edx,offset FLAT:@STAT8
	lea	eax,[ebp-054h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 100           WinMessageBox(HWND_DESKTOP,
	push	06110h
	push	09cb0h
	lea	eax,[ebp-0a4h];	szCaption
	push	eax
	lea	eax,[ebp-054h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinMessageBox
	add	esp,018h

; 101                         hwndDlg,
; 102                         szMessage,
; 103                         szCaption,
; 104                         HLPP_MB_COMSCOPE_SHARE_ERROR,
; 105                         (MB_MOVEABLE | MB_OK | MB_HELP | MB_ICONQUESTION | MB_DEFBUTTON2));
; 106            break;
	jmp	@BLBL14
	align 04h
@BLBL19:

; 107         default:
; 108           sprintf(szCaption,"COMscope Device Undefined");
	mov	edx,offset FLAT:@STAT9
	lea	eax,[ebp-0a4h];	szCaption
	call	_sprintfieee

; 109           sprintf(szMessage,"Do you want to Install COMscope support %s?",pstCFG->szPortName);
	mov	eax,[ebp+010h];	pstCFG
	add	eax,02h
	push	eax
	mov	edx,offset FLAT:@STATa
	lea	eax,[ebp-054h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 110           if (WinMessageBox(HWND_DESKTOP,
	push	06114h
	push	09cafh
	lea	eax,[ebp-0a4h];	szCaption
	push	eax
	lea	eax,[ebp-054h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,06h
	jne	@BLBL6

; 111                             hwndDlg,
; 112                             szMessage,
; 113                             szCaption,
; 114                             HLPP_MB_COMSCOPE_ENABLE,
; 115                             (MB_MOVEABLE | MB_YESNO | MB_HELP | MB_ICONQUESTION | MB_DEFBUTTON2)) == MBID_YES)
; 116             if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-0c8h];	hMod
	push	eax
	push	offset FLAT:@STATb
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL6

; 117               {
; 118               stCOMiCFG.pszPortName = pstCFG->szPortName;
	mov	eax,[ebp+010h];	pstCFG
	add	eax,02h
	mov	dword ptr  stCOMiCFG+014h,eax

; 119               stCOMiCFG.bInstallCOMscope = TRUE;
	or	byte ptr  stCOMiCFG+04bh,02h

; 120               if (DosQueryProcAddr(hMod,0,"InstallDevice",(PFN *)&pfnInstallDevice) == NO_ERROR)
	push	offset FLAT:pfnInstallDevice
	push	offset FLAT:@STATc
	push	0h
	push	dword ptr [ebp-0c8h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL8

; 121                 pfnInstallDevice(&stCOMiCFG);
	push	offset FLAT:stCOMiCFG
	call	dword ptr  pfnInstallDevice
	add	esp,04h
@BLBL8:

; 122               DosFreeModule(hMod);
	push	dword ptr [ebp-0c8h];	hMod
	call	DosFreeModule
	add	esp,04h

; 123               }
@BLBL6:

; 124           break;
	jmp	@BLBL14
	align 04h
	jmp	@BLBL14
	align 04h
@BLBL15:
	cmp	eax,014h
	je	@BLBL16
	cmp	eax,063h
	je	@BLBL17
	cmp	eax,020h
	je	@BLBL18
	jmp	@BLBL19
	align 04h
@BLBL14:

; 125         }
; 126       bPortActive = FALSE;
	mov	dword ptr  bPortActive,0h

; 127       return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL5:

; 128       }
; 129     if (!EnableCOMscope(hwndDlg,*phCom,&ulCOMscopeBufferSize,FALSE))
	push	0h
	push	offset FLAT:ulCOMscopeBufferSize
	mov	eax,[ebp+0ch];	phCom
	push	dword ptr [eax]
	push	dword ptr [ebp+08h];	hwndDlg
	call	EnableCOMscope
	add	esp,010h
	test	eax,eax
	jne	@BLBL9

; 130       {
; 131       DosClose(*phCom);
	mov	eax,[ebp+0ch];	phCom
	push	dword ptr [eax]
	call	DosClose
	add	esp,04h

; 132       *phCom = -1;
	mov	eax,[ebp+0ch];	phCom
	mov	dword ptr [eax],0ffffffffh

; 133       bPortActive = FALSE;
	mov	dword ptr  bPortActive,0h

; 134       return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL9:

; 135       }
; 136     MenuItemEnable(hwndFrame,IDM_MSLEEP,TRUE);
	push	01h
	push	07e4h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 137     if (GetDCB(&stIOctl,hCom,&stComDCB))
	lea	eax,[ebp-0c3h];	stComDCB
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetDCB
	add	esp,0ch
	test	eax,eax
	je	@BLBL10

; 138       return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL10:

; 139     if ((stComDCB.Flags3 & F3_HDW_BUFFER_APO) == 0) // mask only
	test	byte ptr [ebp-0bdh],018h;	stComDCB
	jne	@BLBL11

; 140       MenuItemEnable(hwndFrame,IDM_FIFO,FALSE);
	push	0h
	push	07e8h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
	jmp	@BLBL12
	align 010h
@BLBL11:

; 141     else
; 142       MenuItemEnable(hwndFrame,IDM_FIFO,TRUE);
	push	01h
	push	07e8h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
@BLBL12:

; 143     if (GetBaudRate(&stIOctl,hCom,&lBaud) == 0)
	lea	eax,[ebp-0b4h];	lBaud
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetBaudRate
	add	esp,0ch
	test	eax,eax
	jne	@BLBL13

; 144       CalcThreadSleepCount(lBaud);
	push	dword ptr [ebp-0b4h];	lBaud
	call	CalcThreadSleepCount
	add	esp,04h
@BLBL13:

; 145     stComCtl.hCom = hCom;
	mov	eax,dword ptr  hCom
	mov	dword ptr  stComCtl+06h,eax

; 146     }

; 147   bPortActive = TRUE;
	mov	dword ptr  bPortActive,01h

; 148   return(TRUE);
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
OpenPort	endp

; 152   {
	align 010h

	public ErrorNotify
ErrorNotify	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h

; 157     strcpy(szErrorMessage,szMessage);
	mov	edx,[ebp+08h];	szMessage
	mov	eax,offset FLAT:szErrorMessage
	call	strcpy

; 158     WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 159     if (!stCFG.bSilentStatus)
	test	byte ptr  stCFG+016h,01h
	jne	@BLBL20

; 160       DosBeep(1540,100);
	push	064h
	push	0604h
	call	DosBeep
	add	esp,08h
@BLBL20:

; 161     }

; 162   }
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
ErrorNotify	endp

; 165   {
	align 010h

	public CalcThreadSleepCount
CalcThreadSleepCount	proc
	push	ebp
	mov	ebp,esp

; 173   if (lBaud > 0)
	cmp	dword ptr [ebp+08h],0h;	lBaud
	jle	@BLBL21

; 174     ulCalcSleepCount = ((ulCOMscopeBufferSize * 1000) / ((lBaud / 10) * 2));
	mov	eax,[ebp+08h];	lBaud
	mov	ecx,0ah
	cdq	
	idiv	ecx
	mov	ecx,eax
	add	ecx,ecx
	mov	eax,dword ptr  ulCOMscopeBufferSize
	imul	eax,03e8h
	xor	edx,edx
	div	ecx
	mov	dword ptr  ulCalcSleepCount,eax
	jmp	@BLBL22
	align 010h
@BLBL21:

; 175   else
; 176     ulCalcSleepCount = ((ulCOMscopeBufferSize * 1000) / 1);
	mov	eax,dword ptr  ulCOMscopeBufferSize
	imul	eax,03e8h
	mov	dword ptr  ulCalcSleepCount,eax
@BLBL22:

; 177 //  if (ulCalcSleepCount > 3000)
; 178 //    ulCalcSleepCount = 3000;
; 179   if (stCFG.ulUserSleepCount != 0)
	cmp	dword ptr  stCFG+0d1h,0h
	je	@BLBL23

; 180     ulMonitorSleepCount = stCFG.ulUserSleepCount;
	mov	eax,dword ptr  stCFG+0d1h
	mov	dword ptr  ulMonitorSleepCount,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL23:

; 181   else
; 182     ulMonitorSleepCount = ulCalcSleepCount;
	mov	eax,dword ptr  ulCalcSleepCount
	mov	dword ptr  ulMonitorSleepCount,eax

; 183   }
	mov	esp,ebp
	pop	ebp
	ret	
CalcThreadSleepCount	endp

; 186   {
	align 010h

	public SendXonXoff
SendXonXoff	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax

; 190   GetDCB(&stIOctl,hCom,&stComDCB);
	lea	eax,[ebp-0bh];	stComDCB
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetDCB
	add	esp,0ch

; 191   if (wSignal == SEND_XON)
	cmp	word ptr [ebp+08h],01h;	wSignal
	jne	@BLBL25

; 192     byTemp = stComDCB.XonChar;
	mov	al,[ebp-02h];	stComDCB
	mov	[ebp-0ch],al;	byTemp
	jmp	@BLBL26
	align 010h
@BLBL25:

; 193   else
; 194     byTemp = stComDCB.XoffChar;
	mov	al,[ebp-01h];	stComDCB
	mov	[ebp-0ch],al;	byTemp
@BLBL26:

; 195 
; 196   SendByteImmediate(&stIOctl,hCom,byTemp);
	mov	al,[ebp-0ch];	byTemp
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	SendByteImmediate
	add	esp,0ch

; 197   }
	mov	esp,ebp
	pop	ebp
	ret	
SendXonXoff	endp

; 200   {
	align 010h

	public IncrementFileExt
IncrementFileExt	proc
	push	ebp
	mov	ebp,esp
	sub	esp,010h
	push	eax
	push	edi
	mov	eax,0aaaaaaaah
	lea	edi,[esp+08h]
	stosd	
	stosd	
	stosd	
	stosd	
	pop	edi
	pop	eax
	push	ebx
	sub	esp,0ch

; 206   iEndIndex = (strlen(szFileSpec) - 1);
	mov	eax,[ebp+08h];	szFileSpec
	call	strlen
	dec	eax
	mov	[ebp-08h],eax;	iEndIndex

; 207   for (iIndex = iEndIndex;iIndex >= (iEndIndex - 3);iIndex--)
	mov	eax,[ebp-08h];	iEndIndex
	mov	[ebp-04h],eax;	iIndex
	mov	eax,[ebp-08h];	iEndIndex
	sub	eax,03h
	cmp	[ebp-04h],eax;	iIndex
	jl	@BLBL27
	align 010h
@BLBL28:

; 208     {
; 209     if (szFileSpec[iIndex] == '.')
	mov	eax,[ebp+08h];	szFileSpec
	mov	ecx,[ebp-04h];	iIndex
	cmp	byte ptr [eax+ecx],02eh
	jne	@BLBL29

; 210       {
; 211       iIndex++;
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex

; 212       if (bInit)
	cmp	dword ptr [ebp+0ch],0h;	bInit
	je	@BLBL30

; 213         {
; 214         strcpy(&szFileSpec[iIndex],"001");
	mov	edx,offset FLAT:@STATd
	mov	eax,[ebp+08h];	szFileSpec
	mov	ecx,[ebp-04h];	iIndex
	add	eax,ecx
	call	strcpy

; 215         return;
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL30:

; 216         }
; 217       ulExtNumber = strtol(&szFileSpec[iIndex],&pcEnd,16);
	mov	ecx,010h
	lea	edx,[ebp-010h];	pcEnd
	mov	eax,[ebp+08h];	szFileSpec
	mov	ebx,[ebp-04h];	iIndex
	add	eax,ebx
	call	strtol
	mov	[ebp-0ch],eax;	ulExtNumber

; 218       ulExtNumber++;
	mov	eax,[ebp-0ch];	ulExtNumber
	inc	eax
	mov	[ebp-0ch],eax;	ulExtNumber

; 219       if (ulExtNumber > 0xfff)
	cmp	dword ptr [ebp-0ch],0fffh;	ulExtNumber
	jbe	@BLBL31

; 220         ulExtNumber = 0;
	mov	dword ptr [ebp-0ch],0h;	ulExtNumber
@BLBL31:

; 221       sprintf(&szFileSpec[iIndex],"%03X",ulExtNumber);
	push	dword ptr [ebp-0ch];	ulExtNumber
	mov	edx,offset FLAT:@STATe
	mov	eax,[ebp+08h];	szFileSpec
	mov	ecx,[ebp-04h];	iIndex
	add	eax,ecx
	sub	esp,08h
	call	_sprintfieee

; 222       return;
	add	esp,018h
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL29:

; 223       }
; 224     }

; 207   for (iIndex = iEndIndex;iIndex >= (iEndIndex - 3);iIndex--)
	mov	eax,[ebp-04h];	iIndex
	dec	eax
	mov	[ebp-04h],eax;	iIndex
	mov	eax,[ebp-08h];	iEndIndex
	sub	eax,03h
	cmp	[ebp-04h],eax;	iIndex
	jge	@BLBL28
@BLBL27:

; 225   strcpy(&szFileSpec[iEndIndex + 1],".001");
	mov	edx,offset FLAT:@STATf
	mov	eax,[ebp+08h];	szFileSpec
	mov	ecx,[ebp-08h];	iEndIndex
	add	eax,ecx
	inc	eax
	call	strcpy

; 226   }
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
IncrementFileExt	endp

; 229   {
	align 010h

	public WriteCaptureFile
WriteCaptureFile	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0e8h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,03ah
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 241   if (fWriteMode & FOPEN_NEW_ONLY)
	test	byte ptr [ebp+014h],04h;	fWriteMode
	je	@BLBL33

; 242     ulOpenFlag = (OPEN_ACTION_FAIL_IF_EXISTS | OPEN_ACTION_CREATE_IF_NEW);
	mov	dword ptr [ebp-0e0h],010h;	ulOpenFlag
	jmp	@BLBL34
	align 010h
@BLBL33:

; 243   else
; 244     if (fWriteMode & FOPEN_EXISTS_ONLY)
	test	byte ptr [ebp+014h],08h;	fWriteMode
	je	@BLBL35

; 245       ulOpenFlag = (OPEN_ACTION_OPEN_IF_EXISTS | OPEN_ACTION_FAIL_IF_NEW);
	mov	dword ptr [ebp-0e0h],01h;	ulOpenFlag
	jmp	@BLBL34
	align 010h
@BLBL35:

; 246     else
; 247       ulOpenFlag = (OPEN_ACTION_OPEN_IF_EXISTS | OPEN_ACTION_CREATE_IF_NEW);
	mov	dword ptr [ebp-0e0h],011h;	ulOpenFlag
@BLBL34:

; 248   ulOpenMode = (OPEN_FLAGS_SEQUENTIAL | OPEN_SHARE_DENYREADWRITE | OPEN_ACCESS_WRITEONLY);
	mov	dword ptr [ebp-0dch],0111h;	ulOpenMode

; 249 gtNewFile:
gtNewFile37:

; 250   while ((wFileError = DosOpen(szFileSpec,&hFile,&ulAction,0L,0,ulOpenFlag,ulOpenMode,(PEAOP2)0L)) != 0)
	push	0h
	push	dword ptr [ebp-0dch];	ulOpenMode
	push	dword ptr [ebp-0e0h];	ulOpenFlag
	push	0h
	push	0h
	lea	eax,[ebp-0ch];	ulAction
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosOpen
	add	esp,020h
	mov	[ebp-02h],ax;	wFileError
	cmp	word ptr [ebp-02h],0h;	wFileError
	je	@BLBL38
	align 010h
@BLBL39:

; 251     {
; 252     switch (wFileError)
	xor	eax,eax
	mov	ax,[ebp-02h];	wFileError
	jmp	@BLBL59
	align 04h
@BLBL60:

; 253       {
; 254       case ERROR_FILE_NOT_FOUND:
; 255         sprintf
; 255 (szCaption,"Cannot find file %s.",szFileSpec);
	push	dword ptr [ebp+08h];	szFileSpec
	mov	edx,offset FLAT:@STAT10
	lea	eax,[ebp-0d8h];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 256         break;
	jmp	@BLBL58
	align 04h
@BLBL61:

; 257       case ERROR_PATH_NOT_FOUND:
; 258         sprintf(szCaption,"Cannot find path %s.",szFileSpec);
	push	dword ptr [ebp+08h];	szFileSpec
	mov	edx,offset FLAT:@STAT11
	lea	eax,[ebp-0d8h];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 259         break;
	jmp	@BLBL58
	align 04h
@BLBL62:

; 260       case ERROR_DISK_FULL:
; 261         sprintf(szMessage,"Disk is full, unable to open %s for writing.",szFileSpec);
	push	dword ptr [ebp+08h];	szFileSpec
	mov	edx,offset FLAT:@STAT12
	lea	eax,[ebp-088h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 262         ErrorNotify(szMessage);
	lea	eax,[ebp-088h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 263         return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL63:

; 264       case ERROR_ACCESS_DENIED:
; 265         sprintf(szCaption,"Access denied for writing %s.",szFileSpec);
	push	dword ptr [ebp+08h];	szFileSpec
	mov	edx,offset FLAT:@STAT13
	lea	eax,[ebp-0d8h];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 266         break;
	jmp	@BLBL58
	align 04h
@BLBL64:

; 267       default:
; 268         sprintf(szCaption,"Failed to open %s. ec = %u",szFileSpec,wFileError);
	xor	eax,eax
	mov	ax,[ebp-02h];	wFileError
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	mov	edx,offset FLAT:@STAT14
	lea	eax,[ebp-0d8h];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 269         break;
	jmp	@BLBL58
	align 04h
	jmp	@BLBL58
	align 04h
@BLBL59:
	cmp	eax,02h
	je	@BLBL60
	cmp	eax,03h
	je	@BLBL61
	cmp	eax,070h
	je	@BLBL62
	cmp	eax,05h
	je	@BLBL63
	jmp	@BLBL64
	align 04h
@BLBL58:

; 270       }
; 271     sprintf(szMessage,"Would you like to select another?");
	mov	edx,offset FLAT:@STAT15
	lea	eax,[ebp-088h];	szMessage
	call	_sprintfieee

; 272     if (WinMessageBox(HWND_DESKTOP,
	push	04011h
	push	0h
	lea	eax,[ebp-0d8h];	szCaption
	push	eax
	lea	eax,[ebp-088h];	szMessage
	push	eax
	push	dword ptr  hwndFrame
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,01h
	je	@BLBL40

; 273                       hwndFrame,
; 274                       szMessage,
; 275                       szCaption,
; 276                       0L,
; 277                      (MB_MOVEABLE | MB_OKCANCEL | MB_ICONQUESTION | MB_DEFBUTTON1)) != MBID_OK)
; 278       return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL40:

; 279     if (!GetFileName(hwndClient,szFileSpec,"Select a different file.",COMscopeOpenFilterProc))
	push	offset FLAT: COMscopeOpenFilterProc
	push	offset FLAT:@STAT16
	push	dword ptr [ebp+08h];	szFileSpec
	push	dword ptr  hwndClient
	call	GetFileName
	add	esp,010h
	test	eax,eax
	jne	@BLBL41

; 280       return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL41:

; 281     }

; 250   while ((wFileError = DosOpen(szFileSpec,&hFile,&ulAction,0L,0,ulOpenFlag,ulOpenMode,(PEAOP2)0L)) != 0)
	push	0h
	push	dword ptr [ebp-0dch];	ulOpenMode
	push	dword ptr [ebp-0e0h];	ulOpenFlag
	push	0h
	push	0h
	lea	eax,[ebp-0ch];	ulAction
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosOpen
	add	esp,020h
	mov	[ebp-02h],ax;	wFileError
	cmp	word ptr [ebp-02h],0h;	wFileError
	jne	@BLBL39
@BLBL38:

; 282   if (!(fWriteMode & (FOPEN_APPEND | FOPEN_OVERWRITE)))
	mov	eax,[ebp+014h];	fWriteMode
	and	eax,03h
	test	eax,eax
	jne	@BLBL43

; 284     DosQueryFileInfo(hFile,1,&stFileInfo,sizeof(FILESTATUS3));
	push	018h
	lea	eax,[ebp-024h];	stFileInfo
	push	eax
	push	01h
	push	dword ptr [ebp-08h];	hFile
	call	DosQueryFileInfo
	add	esp,010h

; 285     if ((ulAction == FILE_EXISTED) && (stFileInfo.cbFile > 0))
	cmp	dword ptr [ebp-0ch],01h;	ulAction
	jne	@BLBL46
	cmp	dword ptr [ebp-018h],0h;	stFileInfo
	jbe	@BLBL46

; 287       sprintf(szCaption,"File already exists.");
	mov	edx,offset FLAT:@STAT17
	lea	eax,[ebp-0d8h];	szCaption
	call	_sprintfieee

; 288       sprintf(szMessage,"The designated file %s already exists.\n\nDo you want to overwrite it?",szFileSpec);
	push	dword ptr [ebp+08h];	szFileSpec
	mov	edx,offset FLAT:@STAT18
	lea	eax,[ebp-088h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 289       switch (WinMessageBox(HWND_DESKTOP,
	push	06015h
	mov	eax,[ebp+018h];	lHelp
	push	eax
	lea	eax,[ebp-0d8h];	szCaption
	push	eax
	lea	eax,[ebp-088h];	szMessage
	push	eax
	push	dword ptr  hwndFrame
	push	01h
	call	WinMessageBox
	add	esp,018h
	jmp	@BLBL66
	align 04h
@BLBL67:

; 298           DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 299           return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL68:

; 301           DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 302           if (!GetFileName(hwndClient,szFileSpec,"Select a different file.",COMscopeOpenFilterProc))
	push	offset FLAT: COMscopeOpenFilterProc
	push	offset FLAT:@STAT19
	push	dword ptr [ebp+08h];	szFileSpec
	push	dword ptr  hwndClient
	call	GetFileName
	add	esp,010h
	test	eax,eax
	jne	gtNewFile37

; 303             return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL69:

; 306           DosSetFileSize(hFile,0L);
	push	0h
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFileSize
	add	esp,08h

; 307           break;
	jmp	@BLBL65
	align 04h
	jmp	@BLBL65
	align 04h
@BLBL66:
	cmp	eax,02h
	je	@BLBL67
	cmp	eax,07h
	je	@BLBL68
	cmp	eax,06h
	je	@BLBL69
@BLBL65:

; 309       }

; 310     }
	jmp	@BLBL46
	align 010h
@BLBL43:

; 312     if ((fWriteMode & FOPEN_APPEND) && (ulWordCount != 0))
	test	byte ptr [ebp+014h],02h;	fWriteMode
	je	@BLBL47
	cmp	dword ptr [ebp+010h],0h;	ulWordCount
	je	@BLBL47

; 313       DosSetFilePtr(hFile,0L,FILE_END,&ulFilePosition);
	lea	eax,[ebp-0e4h];	ulFilePosition
	push	eax
	push	02h
	push	0h
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h
	jmp	@BLBL46
	align 010h
@BLBL47:

; 315       if (fWriteMode & FOPEN_OVERWRITE)
	test	byte ptr [ebp+014h],01h;	fWriteMode
	je	@BLBL46

; 316         DosSetFileSize(hFile,0);
	push	0h
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFileSize
	add	esp,08h
@BLBL46:

; 318   ulByteCount = (ulWordCount * 2);
	mov	eax,[ebp+010h];	ulWordCount
	add	eax,eax
	mov	[ebp-0e8h],eax;	ulByteCount

; 319   if (ulByteCount > 0)
	cmp	dword ptr [ebp-0e8h],0h;	ulByteCount
	jbe	@BLBL50

; 321     if ((wFileError = DosWrite(hFile,(PVOID)pwBuffer,ulByteCount,&ulByteCount)) != 0)
	lea	eax,[ebp-0e8h];	ulByteCount
	push	eax
	push	dword ptr [ebp-0e8h];	ulByteCount
	push	dword ptr [ebp+0ch];	pwBuffer
	push	dword ptr [ebp-08h];	hFile
	call	DosWrite
	add	esp,010h
	mov	[ebp-02h],ax;	wFileError
	cmp	word ptr [ebp-02h],0h;	wFileError
	je	@BLBL51

; 323       if (wFileError == ERROR_DISK_FULL)
	cmp	word ptr [ebp-02h],070h;	wFileError
	jne	@BLBL52

; 325         if (stCFG.bCaptureToFile)
	test	byte ptr  stCFG+016h,020h
	je	@BLBL53

; 326           sprintf(szMessage,"Disk is full, capture to file aborted.");
	mov	edx,offset FLAT:@STAT1a
	lea	eax,[ebp-088h];	szMessage
	call	_sprintfieee
	jmp	@BLBL54
	align 010h
@BLBL53:

; 328           sprintf(szMessage,"Disk is full, unable to write to %s.",szFileSpec);
	push	dword ptr [ebp+08h];	szFileSpec
	mov	edx,offset FLAT:@STAT1b
	lea	eax,[ebp-088h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
@BLBL54:

; 329         ErrorNotify(szMessage);
	lea	eax,[ebp-088h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 330         DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 331         return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL52:

; 333       sprintf(szMessage,"Write to %s failed. ec = %u",szFileSpec,wFileError);
	xor	eax,eax
	mov	ax,[ebp-02h];	wFileError
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	mov	edx,offset FLAT:@STAT1c
	lea	eax,[ebp-088h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 334       }
	jmp	@BLBL55
	align 010h
@BLBL51:

; 336       if (fWriteMode & FOPEN_APPEND)
	test	byte ptr [ebp+014h],02h;	fWriteMode
	je	@BLBL56

; 337         sprintf(szMessage,"%u total characters written to %s",((ulByteCount + ulFilePosition) / 2),szFileSpec);
	push	dword ptr [ebp+08h];	szFileSpec
	mov	eax,[ebp-0e4h];	ulFilePosition
	add	eax,[ebp-0e8h];	ulByteCount
	shr	eax,01h
	push	eax
	mov	edx,offset FLAT:@STAT1d
	lea	eax,[ebp-088h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h
	jmp	@BLBL55
	align 010h
@BLBL56:

; 339         sprintf(szMessage,"%u characters written to %s",(ulByteCount / 2),szFileSpec);
	push	dword ptr [ebp+08h];	szFileSpec
	mov	eax,[ebp-0e8h];	ulByteCount
	shr	eax,01h
	push	eax
	mov	edx,offset FLAT:@STAT1e
	lea	eax,[ebp-088h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h
@BLBL55:

; 340     ErrorNotify(szMessage);
	lea	eax,[ebp-088h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 341     }
@BLBL50:

; 342   DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 343   return(TRUE);
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
WriteCaptureFile	endp

; 347   {
	align 010h

	public ReadCaptureFile
ReadCaptureFile	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ech
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,03bh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 360   ulOpenFlag = (OPEN_ACTION_OPEN_IF_EXISTS | OPEN_ACTION_FAIL_IF_NEW);
	mov	dword ptr [ebp-0e4h],01h;	ulOpenFlag

; 361   ulOpenMode = (OPEN_FLAGS_SEQUENTIAL | OPEN_SHARE_DENYWRITE | OPEN_ACCESS_READONLY);
	mov	dword ptr [ebp-0e0h],0120h;	ulOpenMode

; 362   while ((wFileError = DosOpen(szFileSpec,&hFile,&ulAction,0L,0,ulOpenFlag,ulOpenMode,(PEAOP2)0L)) != 0)
	push	0h
	push	dword ptr [ebp-0e0h];	ulOpenMode
	push	dword ptr [ebp-0e4h];	ulOpenFlag
	push	0h
	push	0h
	lea	eax,[ebp-0ch];	ulAction
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosOpen
	add	esp,020h
	mov	[ebp-02h],ax;	wFileError
	cmp	word ptr [ebp-02h],0h;	wFileError
	je	@BLBL70
	align 010h
@BLBL71:

; 363     {
; 364     switch (wFileError)
	xor	eax,eax
	mov	ax,[ebp-02h];	wFileError
	jmp	@BLBL85
	align 04h
@BLBL86:

; 365       {
; 366       case ERROR_FILE_NOT_FOUND:
; 367         sprintf(szCaption,"Cannot find file %s.",szFileSpec);
	push	dword ptr [ebp+08h];	szFileSpec
	mov	edx,offset FLAT:@STAT1f
	lea	eax,[ebp-0d8h];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 368         break;
	jmp	@BLBL84
	align 04h
@BLBL87:

; 369       case ERROR_PATH_NOT_FOUND:
; 370         sprintf(szCaption,"Cannot find path %s.",szFileSpec);
	push	dword ptr [ebp+08h];	szFileSpec
	mov	edx,offset FLAT:@STAT20
	lea	eax,[ebp-0d8h];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 371         break;
	jmp	@BLBL84
	align 04h
@BLBL88:

; 372       case ERROR_ACCESS_DENIED:
; 373         sprintf(szCaption,"Access denied for reading %s.",szFileSpec);
	push	dword ptr [ebp+08h];	szFileSpec
	mov	edx,offset FLAT:@STAT21
	lea	eax,[ebp-0d8h];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 374         break;
	jmp	@BLBL84
	align 04h
@BLBL89:

; 375       default:
; 376         sprintf(szCaption,"Failed to open %s. ec = %u",szFileSpec,wFileError);
	xor	eax,eax
	mov	ax,[ebp-02h];	wFileError
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	mov	edx,offset FLAT:@STAT22
	lea	eax,[ebp-0d8h];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 377         break;
	jmp	@BLBL84
	align 04h
	jmp	@BLBL84
	align 04h
@BLBL85:
	cmp	eax,02h
	je	@BLBL86
	cmp	eax,03h
	je	@BLBL87
	cmp	eax,05h
	je	@BLBL88
	jmp	@BLBL89
	align 04h
@BLBL84:

; 378       }
; 379     sprintf(szMessage,"Would you like to select another?");
	mov	edx,offset FLAT:@STAT23
	lea	eax,[ebp-088h];	szMessage
	call	_sprintfieee

; 380     if (WinMessageBox(HWND_DESKTOP,
	push	04011h
	push	0h
	lea	eax,[ebp-0d8h];	szCaption
	push	eax
	lea	eax,[ebp-088h];	szMessage
	push	eax
	push	dword ptr  hwndFrame
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,01h
	je	@BLBL72

; 381                       hwndFrame,
; 382                       szMessage,
; 383                       szCaption,
; 384                       0L,
; 385                      (MB_MOVEABLE | MB_OKCANCEL | MB_ICONQUESTION | MB_DEFBUTTON1)) != MBID_OK)
; 386       return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL72:

; 387     if (!GetFileName(hwndClient,szFileSpec,"Select a different file.",COMscopeOpenFilterProc))
	push	offset FLAT: COMscopeOpenFilterProc
	push	offset FLAT:@STAT24
	push	dword ptr [ebp+08h];	szFileSpec
	push	dword ptr  hwndClient
	call	GetFileName
	add	esp,010h
	test	eax,eax
	jne	@BLBL73

; 388       return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL73:

; 389     }

; 362   while ((wFileError = DosOpen(szFileSpec,&hFile,&ulAction,0L,0,ulOpenFlag,ulOpenMode,(PEAOP2)0L)) != 0)
	push	0h
	push	dword ptr [ebp-0e0h];	ulOpenMode
	push	dword ptr [ebp-0e4h];	ulOpenFlag
	push	0h
	push	0h
	lea	eax,[ebp-0ch];	ulAction
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosOpen
	add	esp,020h
	mov	[ebp-02h],ax;	wFileError
	cmp	word ptr [ebp-02h],0h;	wFileError
	jne	@BLBL71
@BLBL70:

; 390   DosQueryFileInfo(hFile,1,&stFileInfo,sizeof(FILESTATUS3));
	push	018h
	lea	eax,[ebp-024h];	stFileInfo
	push	eax
	push	01h
	push	dword ptr [ebp-08h];	hFile
	call	DosQueryFileInfo
	add	esp,010h

; 391   ulByteCount = (*pulWordCount * 2);
	mov	eax,[ebp+010h];	pulWordCount
	mov	eax,[eax]
	add	eax,eax
	mov	[ebp-0ech],eax;	ulByteCount

; 392   if (ulByteCount > 0)
	cmp	dword ptr [ebp-0ech],0h;	ulByteCount
	jbe	@BLBL75

; 394     if (stFileInfo.cbFile > ulByteCount)
	mov	eax,[ebp-0ech];	ulByteCount
	cmp	[ebp-018h],eax;	stFileInfo
	jbe	@BLBL76

; 396       if (bAskLength)
	cmp	dword ptr [ebp+014h],0h;	bAskLength
	je	@BLBL77

; 398         sprintf(szCaption,"%s is larger than Buffer size.",szFileSpec);
	push	dword ptr [ebp+08h];	szFileSpec
	mov	edx,offset FLAT:@STAT25
	lea	eax,[ebp-0d8h];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 399         sprintf(szMessage,"Do you want to increase buffer size to accomodate size of file?");
	mov	edx,offset FLAT:@STAT26
	lea	eax,[ebp-088h];	szMessage
	call	_sprintfieee

; 400         if (WinMessageBox(HWND_DESKTOP,
	push	06014h
	push	09ca8h
	lea	eax,[ebp-0d8h];	szCaption
	push	eax
	lea	eax,[ebp-088h];	szMessage
	push	eax
	push	dword ptr  hwndFrame
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,06h
	je	@BLBL77

; 406           return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL77:

; 408       if ((rc = DosAllocMem((PPVOID)&pwTemp,stFileInfo.cbFile,PAG_COMMIT | PAG_READ | PAG_WRITE)) != 0)
	push	013h
	push	dword ptr [ebp-018h];	stFileInfo
	lea	eax,[ebp-0e8h];	pwTemp
	push	eax
	call	DosAllocMem
	add	esp,0ch
	mov	[ebp-0dch],eax;	rc
	cmp	dword ptr [ebp-0dch],0h;	rc
	je	@BLBL79

; 410         if (rc == ERROR_NOT_ENOUGH_MEMORY)
	cmp	dword ptr [ebp-0dch],08h;	rc
	jne	@BLBL80

; 412           sprintf(szCaption,"Out of Memory");
	mov	edx,offset FLAT:@STAT27
	lea	eax,[ebp-0d8h];	szCaption
	call	_sprintfieee

; 413           sprintf(szMessage,"Unable to allocate enough memory to read file.");
	mov	edx,offset FLAT:@STAT28
	lea	eax,[ebp-088h];	szMessage
	call	_sprintfieee

; 414           }
	jmp	@BLBL81
	align 010h
@BLBL80:

; 417           sprintf(szCaption,"Memory allocation error. ec = %u",rc);
	push	dword ptr [ebp-0dch];	rc
	mov	edx,offset FLAT:@STAT29
	lea	eax,[ebp-0d8h];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 418           sprintf(szMessage,"Unable to allocate memory to read file");
	mov	edx,offset FLAT:@STAT2a
	lea	eax,[ebp-088h];	szMessage
	call	_sprintfieee

; 419           }
@BLBL81:

; 420         WinMessageBox(HWND_DESKTOP,
	push	04040h
	push	0h
	lea	eax,[ebp-0d8h];	szCaption
	push	eax
	lea	eax,[ebp-088h];	szMessage
	push	eax
	push	dword ptr  hwndFrame
	push	01h
	call	WinMessageBox
	add	esp,018h

; 426         DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 427         return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL79:

; 429       DosFreeMem(*ppwBuffer);
	mov	eax,[ebp+0ch];	ppwBuffer
	push	dword ptr [eax]
	call	DosFreeMem
	add	esp,04h

; 430       *ppwBuffer = pwTemp;
	mov	eax,[ebp+0ch];	ppwBuffer
	mov	ecx,[ebp-0e8h];	pwTemp
	mov	[eax],ecx

; 431       }
@BLBL76:

; 432     ulByteCount = stFileInfo.cbFile;
	mov	eax,[ebp-018h];	stFileInfo
	mov	[ebp-0ech],eax;	ulByteCount

; 433     if ((wFileError = DosRead(hFile,(PVOID)*ppwBuffer,ulByteCount,&ulByteCount)) != 0)
	lea	eax,[ebp-0ech];	ulByteCount
	push	eax
	push	dword ptr [ebp-0ech];	ulByteCount
	mov	eax,[ebp+0ch];	ppwBuffer
	push	dword ptr [eax]
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h
	mov	[ebp-02h],ax;	wFileError
	cmp	word ptr [ebp-02h],0h;	wFileError
	je	@BLBL82

; 434       sprintf(szMessage,"Read from %s failed. ec = %u",szFileSpec,wFileError);
	xor	eax,eax
	mov	ax,[ebp-02h];	wFileError
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	mov	edx,offset FLAT:@STAT2b
	lea	eax,[ebp-088h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h
	jmp	@BLBL83
	align 010h
@BLBL82:

; 436       sprintf(szMessage,"%u characters read from %s",(ulByteCount / 2),szFileSpec);
	push	dword ptr [ebp+08h];	szFileSpec
	mov	eax,[ebp-0ech];	ulByteCount
	shr	eax,01h
	push	eax
	mov	edx,offset FLAT:@STAT2c
	lea	eax,[ebp-088h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h
@BLBL83:

; 437     ErrorNotify(szMessage);
	lea	eax,[ebp-088h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 438     *pulWordCount = (ulByteCount / 2);
	mov	ecx,[ebp-0ech];	ulByteCount
	shr	ecx,01h
	mov	eax,[ebp+010h];	pulWordCount
	mov	[eax],ecx

; 439     }
@BLBL75:

; 440   DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 441   return(TRUE);
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
ReadCaptureFile	endp

; 445   {
	align 010h

	public ProcessKeystroke
ProcessKeystroke	proc
	push	ebp
	mov	ebp,esp
	sub	esp,010h
	push	eax
	push	edi
	mov	eax,0aaaaaaaah
	lea	edi,[esp+08h]
	stosd	
	stosd	
	stosd	
	stosd	
	pop	edi
	pop	eax
	sub	esp,04h

; 455   usFlags = SHORT1FROMMP(mp1);
	mov	eax,[ebp+0ch];	mp1
	mov	[ebp-0ch],ax;	usFlags

; 456   if (bSendNextKeystroke)
	cmp	dword ptr  bSendNextKeystroke,0h
	je	@BLBL90

; 457     {
; 458     if (usFlags & KC_VIRTUALKEY)
	test	byte ptr [ebp-0ch],02h;	usFlags
	je	@BLBL91

; 459       {
; 460       byChar = SHORT2FROMMP(mp2);
	mov	eax,[ebp+010h];	mp2
	shr	eax,010h
	mov	[ebp-09h],al;	byChar

; 461       if (byChar == VK_ALT)
	cmp	byte ptr [ebp-09h],0bh;	byChar
	jne	@BLBL92

; 462         {
; 463         if (usFlags & KC_KEYUP)
	test	byte ptr [ebp-0ch],040h;	usFlags
	je	@BLBL93

; 464           {
; 465           if (bAltKeyDown)
	cmp	dword ptr  @84bAltKeyDown,0h
	je	@BLBL105

; 466             {
; 467             bAltKeyDown = FALSE;
	mov	dword ptr  @84bAltKeyDown,0h

; 468             if (iKeyIndex != 0)
	cmp	dword ptr  @85iKeyIndex,0h
	je	@BLBL105

; 469               {
; 470               abyKeys[iKeyIndex] = 0;
	mov	eax,dword ptr  @85iKeyIndex
	mov	byte ptr [eax+ @88abyKeys],0h

; 471               SendByteImmediate(&stIOctl,hCom,(BYTE)atoi(abyKeys));
	mov	eax,offset FLAT:@88abyKeys
	call	atoi
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	SendByteImmediate
	add	esp,0ch

; 472               bSendNextKeystroke = FALSE;
	mov	dword ptr  bSendNextKeystroke,0h

; 473               MenuItemCheck(hwndFrame,IDM_SENDIMM,FALSE);
	push	0h
	push	07fbh
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 474               return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL93:

; 475               }
; 476             }
; 477           }
; 478         else
; 479           {
; 480           if (!bAltKeyDown)
	cmp	dword ptr  @84bAltKeyDown,0h
	jne	@BLBL105

; 481             {
; 482             bAltKeyDown = TRUE;
	mov	dword ptr  @84bAltKeyDown,01h

; 483             iKeyIndex = 0;
	mov	dword ptr  @85iKeyIndex,0h

; 484             }

; 485           }

; 486         }
	jmp	@BLBL105
	align 010h
@BLBL92:

; 487       else
; 488         {
; 489         if (bAltKeyDown && (iKeyIndex < 3) && (usFlags & KC_KEYUP))
	cmp	dword ptr  @84bAltKeyDown,0h
	je	@BLBL105
	cmp	dword ptr  @85iKeyIndex,03h
	jge	@BLBL105
	test	byte ptr [ebp-0ch],040h;	usFlags
	je	@BLBL105

; 490           {
; 491           switch (byChar)
	xor	eax,eax
	mov	al,[ebp-09h];	byChar
	jmp	@BLBL143
	align 04h
@BLBL144:

; 492             {
; 493             case VK_PAGEUP:
; 494               abyKeys[iKeyIndex] = '9';
	mov	eax,dword ptr  @85iKeyIndex
	mov	byte ptr [eax+ @88abyKeys],039h

; 495               break;
	jmp	@BLBL142
	align 04h
@BLBL145:

; 496             case VK_UP:
; 497               abyKeys[iKeyIndex] = '8';
	mov	eax,dword ptr  @85iKeyIndex
	mov	byte ptr [eax+ @88abyKeys],038h

; 498               break;
	jmp	@BLBL142
	align 04h
@BLBL146:

; 499             case VK_HOME:
; 500               abyKeys[iKeyIndex] = '7';
	mov	eax,dword ptr  @85iKeyIndex
	mov	byte ptr [eax+ @88abyKeys],037h

; 501               break;
	jmp	@BLBL142
	align 04h
@BLBL147:

; 502             case VK_RIGHT:
; 503               abyKeys[iKeyIndex] = '6';
	mov	eax,dword ptr  @85iKeyIndex
	mov	byte ptr [eax+ @88abyKeys],036h

; 504               break;
	jmp	@BLBL142
	align 04h
@BLBL148:

; 505             case VK_LEFT:
; 506               abyKeys[iKeyIndex] = '4';
	mov	eax,dword ptr  @85iKeyIndex
	mov	byte ptr [eax+ @88abyKeys],034h

; 507               break;
	jmp	@BLBL142
	align 04h
@BLBL149:

; 508             case VK_PAGEDOWN:
; 509               abyKeys[iKeyIndex] = '3';
	mov	eax,dword ptr  @85iKeyIndex
	mov	byte ptr [eax+ @88abyKeys],033h

; 510               break;
	jmp	@BLBL142
	align 04h
@BLBL150:

; 511             case VK_DOWN:
; 512               abyKeys[iKeyIndex] = '2';
	mov	eax,dword ptr  @85iKeyIndex
	mov	byte ptr [eax+ @88abyKeys],032h

; 513               break;
	jmp	@BLBL142
	align 04h
@BLBL151:

; 514             case VK_END:
; 515               abyKeys[iKeyIndex] = '1';
	mov	eax,dword ptr  @85iKeyIndex
	mov	byte ptr [eax+ @88abyKeys],031h

; 516               break;
	jmp	@BLBL142
	align 04h
@BLBL152:

; 517             case VK_INSERT:
; 518               abyKeys[iKeyIndex] = '0';
	mov	eax,dword ptr  @85iKeyIndex
	mov	byte ptr [eax+ @88abyKeys],030h

; 519               break;
	jmp	@BLBL142
	align 04h
@BLBL153:

; 520             default:
; 521               return(FALSE);
	xor	eax,eax
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL142
	align 04h
@BLBL143:
	cmp	eax,011h
	je	@BLBL144
	cmp	eax,016h
	je	@BLBL145
	cmp	eax,014h
	je	@BLBL146
	cmp	eax,017h
	je	@BLBL147
	cmp	eax,015h
	je	@BLBL148
	cmp	eax,012h
	je	@BLBL149
	cmp	eax,018h
	je	@BLBL150
	cmp	eax,013h
	je	@BLBL151
	cmp	eax,01ah
	je	@BLBL152
	jmp	@BLBL153
	align 04h
@BLBL142:

; 522             }
; 523           iKeyIndex++;
	mov	eax,dword ptr  @85iKeyIndex
	inc	eax
	mov	dword ptr  @85iKeyIndex,eax

; 524           return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL91:

; 525           }
; 526         }
; 527       }
; 528     else
; 529       {
; 530       if (usFlags & KC_CHAR)
	test	byte ptr [ebp-0ch],01h;	usFlags
	je	@BLBL101

; 531         {
; 532         byChar = SHORT1FROMMP(mp2);
	mov	eax,[ebp+010h];	mp2
	mov	[ebp-09h],al;	byChar

; 533         SendByteImmediate(&stIOctl,hCom,byChar);
	mov	al,[ebp-09h];	byChar
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	SendByteImmediate
	add	esp,0ch

; 534         bSendNextKeystroke = FALSE;
	mov	dword ptr  bSendNextKeystroke,0h

; 535         MenuItemCheck(hwndFrame,IDM_SENDIMM,FALSE);
	push	0h
	push	07fbh
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 536         return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL101:

; 537         }
; 538       else
; 539         {
; 540         if (bAltKeyDown && (usFlags & KC_KEYUP) && (usFlags & KC_SCANCODE))
	cmp	dword ptr  @84bAltKeyDown,0h
	je	@BLBL105
	test	byte ptr [ebp-0ch],040h;	usFlags
	je	@BLBL105
	test	byte ptr [ebp-0ch],04h;	usFlags
	je	@BLBL105

; 541           {
; 542           if (iKeyIndex < 3)
	cmp	dword ptr  @85iKeyIndex,03h
	jge	@BLBL104

; 543             abyKeys[iKeyIndex++] = '5';
	mov	eax,dword ptr  @85iKeyIndex
	mov	byte ptr [eax+ @88abyKeys],035h
	mov	eax,dword ptr  @85iKeyIndex
	inc	eax
	mov	dword ptr  @85iKeyIndex,eax
@BLBL104:

; 544           return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL90:

; 545           }
; 546         }
; 547       }
; 548     }
; 549   else
; 550     {
; 551     if ((usFlags & KC_KEYUP) == 0)
	test	byte ptr [ebp-0ch],040h;	usFlags
	jne	@BLBL105

; 552       {
; 553       if (usFlags & KC_VIRTUALKEY)
	test	byte ptr [ebp-0ch],02h;	usFlags
	je	@BLBL105

; 554         {
; 555         byChar = SHORT2FROMMP(mp2);
	mov	eax,[ebp+010h];	mp2
	shr	eax,010h
	mov	[ebp-09h],al;	byChar

; 556         if (usFlags & KC_CTRL)
	test	byte ptr [ebp-0ch],010h;	usFlags
	je	@BLBL108

; 557           {
; 558           switch (byChar)
	xor	eax,eax
	mov	al,[ebp-09h];	byChar
	jmp	@BLBL155
	align 04h
@BLBL156:

; 559             {
; 560             case VK_RIGHT:
; 561               if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL109

; 562                 WinSendMsg(stRead.hwndClient,WM_BUTTON2DOWN,0L,0L);
	push	0h
	push	0h
	push	074h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h
@BLBL109:

; 563 //              else
; 564 //                WinSendMsg(hwndClient,WM_BUTTON2DOWN,0L,0L);
; 565               return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL157:

; 566             case VK_LEFT:
; 567               if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL110

; 568                 WinSendMsg(stWrite.hwndClient,WM_BUTTON2DOWN,0L,0L);
	push	0h
	push	0h
	push	074h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h
@BLBL110:

; 569 //              else
; 570 //                WinSendMsg(hwndClient,WM_BUTTON2DOWN,0L,0L);
; 571               return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL158:

; 572             case VK_DOWN:
; 573               WinSendMsg(hwndStatus,WM_BUTTON2DOWN,0L,0L);
	push	0h
	push	0h
	push	074h
	push	dword ptr  hwndStatus
	call	WinSendMsg
	add	esp,010h

; 574               return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL159:

; 575             case VK_UP:
; 576               if (!pstCFG->bColumnDisplay)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+018h],080h
	jne	@BLBL111

; 577                 WinSendMsg(hwndClient,WM_BUTTON2DOWN,0L,0L);
	push	0h
	push	0h
	push	074h
	push	dword ptr  hwndClient
	call	WinSendMsg
	add	esp,010h
@BLBL111:

; 578               return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL160:

; 579             default:
; 580               return(FALSE);
	xor	eax,eax
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL154
	align 04h
@BLBL155:
	cmp	eax,017h
	je	@BLBL156
	cmp	eax,015h
	je	@BLBL157
	cmp	eax,018h
	je	@BLBL158
	cmp	eax,016h
	je	@BLBL159
	jmp	@BLBL160
	align 04h
@BLBL154:

; 581             }
; 582           }
	jmp	@BLBL105
	align 010h
@BLBL108:

; 583         else
; 584           {
; 585           if (pstCFG->fDisplaying & (DISP_FILE | DISP_DATA))
	mov	eax,[ebp+08h];	pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL105

; 586             {
; 587             switch (byChar)
	xor	eax,eax
	mov	al,[ebp-09h];	byChar
	jmp	@BLBL162
	align 04h
@BLBL163:

; 588               {
; 589               case VK_PAGEDOWN:
; 590                 mpScrollDir = MPFROM2SHORT(0,SB_PAGEDOWN);
	mov	dword ptr [ebp-010h],040000h;	mpScrollDir

; 591                 break;
	jmp	@BLBL161
	align 04h
@BLBL164:

; 592               case VK_PAGEUP:
; 593                 mpScrollDir = MPFROM2SHORT(0,SB_PAGEUP);
	mov	dword ptr [ebp-010h],030000h;	mpScrollDir

; 594                 break;
	jmp	@BLBL161
	align 04h
@BLBL165:

; 595               case VK_UP:
; 596                 mpScrollDir = MPFROM2SHORT(0,SB_LINEUP);
	mov	dword ptr [ebp-010h],010000h;	mpScrollDir

; 597                 break;
	jmp	@BLBL161
	align 04h
@BLBL166:

; 598               case VK_DOWN:
; 599                 mpScrollDir = MPFROM2SHORT(0,SB_LINEDOWN);
	mov	dword ptr [ebp-010h],020000h;	mpScrollDir

; 600                 break;
	jmp	@BLBL161
	align 04h
@BLBL167:

; 601               case VK_HOME:
; 602                 mpScrollDir = MPFROM2SHORT(0,SB_SLIDERPOSITION);
	mov	dword ptr [ebp-010h],060000h;	mpScrollDir

; 603                 break;
	jmp	@BLBL161
	align 04h
@BLBL168:

; 604               case VK_END:
; 605                 if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL114

; 606                   {
; 607                   if (!pstCFG->bSyncToRead)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+019h],02h
	jne	@BLBL115

; 608                     WinSendMsg(stWrite.hwndClient,WM_VSCROLL,0L,MPFROM2SHORT(stWrite.lScrollRowCount,SB_SLIDERPOSITION));
	mov	ax,word ptr  stWrite+067h
	and	eax,0ffffh
	or	eax,060000h
	push	eax
	push	0h
	push	031h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h
@BLBL115:

; 609                   if (!pstCFG->bSyncToWrite)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+019h],01h
	jne	@BLBL117

; 610                     WinSendMsg(stRead.hwndClient,WM_VSCROLL,0L,MPFROM2SHORT(stRead.lScrollRowCount,SB_SLIDERPOSITION));
	mov	ax,word ptr  stRead+067h
	and	eax,0ffffh
	or	eax,060000h
	push	eax
	push	0h
	push	031h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 611                   }
	jmp	@BLBL117
	align 010h
@BLBL114:

; 612                 else
; 613                   WinSendMsg(hwndClient,WM_VSCROLL,0L,MPFROM2SHORT(stRow.lScrollRowCount,SB_SLIDERPOSITION));
	mov	ax,word ptr  stRow+067h
	and	eax,0ffffh
	or	eax,060000h
	push	eax
	push	0h
	push	031h
	push	dword ptr  hwndClient
	call	WinSendMsg
	add	esp,010h
@BLBL117:

; 614                 return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL169:

; 615               case VK_RIGHT:
; 616                 if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL118

; 617                   {
; 618                   if ((stWrite.lScrollIndex < lScrollCount) && (stRead.lScrollIndex < lScrollCount))
	mov	eax,dword ptr  lScrollCount
	cmp	dword ptr  stWrite+06fh,eax
	jge	@BLBL120
	mov	eax,dword ptr  lScrollCount
	cmp	dword ptr  stRead+06fh,eax
	jge	@BLBL120

; 619                     {
; 620                     stWrite.lScrollIndex++;
	mov	eax,dword ptr  stWrite+06fh
	inc	eax
	mov	dword ptr  stWrite+06fh,eax

; 621                     stRead.lScrollIndex++;
	mov	eax,dword ptr  stRead+06fh
	inc	eax
	mov	dword ptr  stRead+06fh,eax

; 622                     WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stWrite+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 623                     WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stRead+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 624                     }

; 625                   }
	jmp	@BLBL120
	align 010h
@BLBL118:

; 626                 else
; 627                   {
; 628                   if (stRow.lScrollIndex < lScrollCount)
	mov	eax,dword ptr  lScrollCount
	cmp	dword ptr  stRow+06fh,eax
	jge	@BLBL120

; 629                     {
; 630                     iIndex = (stRow.lScrollIndex + 1);
	mov	eax,dword ptr  stRow+06fh
	inc	eax
	mov	[ebp-04h],eax;	iIndex

; 631                     while (iIndex < lScrollCount)
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-04h],eax;	iIndex
	jge	@BLBL122
	align 010h
@BLBL123:

; 632                       {
; 633                       if ((lIncrement = CountTraceElement(pwScrollBuffer[iIndex],CS_PACKET_DATA)) == 1)
	push	0ff00h
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-04h];	iIndex
	mov	ax,word ptr [eax+ecx*02h]
	push	eax
	call	CountTraceElement
	add	esp,08h
	mov	[ebp-08h],eax;	lIncrement
	cmp	dword ptr [ebp-08h],01h;	lIncrement
	je	@BLBL122

; 634                         break;
; 635                       if (lIncrement != 0)
	cmp	dword ptr [ebp-08h],0h;	lIncrement
	je	@BLBL126

; 636                         iIndex += lIncrement;
	mov	eax,[ebp-08h];	lIncrement
	add	eax,[ebp-04h];	iIndex
	mov	[ebp-04h],eax;	iIndex
	jmp	@BLBL127
	align 010h
@BLBL126:

; 637                       else
; 638                         iIndex++;
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
@BLBL127:

; 639                       }

; 631                     while (iIndex < lScrollCount)
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-04h],eax;	iIndex
	jl	@BLBL123
@BLBL122:

; 640                     if (iIndex < lScrollCount)
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-04h],eax;	iIndex
	jge	@BLBL120

; 642                       stRow.lScrollIndex = iIndex;
	mov	eax,[ebp-04h];	iIndex
	mov	dword ptr  stRow+06fh,eax

; 643                       WinInvalidateRect(stRow.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stRow+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 644                       }

; 645                     }

; 646                   }
@BLBL120:

; 647                 return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL170:

; 649                 if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL129

; 651                   if ((stWrite.lScrollIndex > 0) && (stRead.lScrollIndex > 0))
	cmp	dword ptr  stWrite+06fh,0h
	jle	@BLBL131
	cmp	dword ptr  stRead+06fh,0h
	jle	@BLBL131

; 653                     stWrite.lScrollIndex--;
	mov	eax,dword ptr  stWrite+06fh
	dec	eax
	mov	dword ptr  stWrite+06fh,eax

; 654                     stRead.lScrollIndex--;
	mov	eax,dword ptr  stRead+06fh
	dec	eax
	mov	dword ptr  stRead+06fh,eax

; 655                     WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stWrite+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 656                     WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stRead+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 657                     }

; 658                   }
	jmp	@BLBL131
	align 010h
@BLBL129:

; 661                   if (stRow.lScrollIndex > 0)
	cmp	dword ptr  stRow+06fh,0h
	jle	@BLBL131

; 663                     iIndex = (stRow.lScrollIndex - 1);
	mov	eax,dword ptr  stRow+06fh
	dec	eax
	mov	[ebp-04h],eax;	iIndex

; 664                     while (iIndex >= 0)
	cmp	dword ptr [ebp-04h],0h;	iIndex
	jl	@BLBL133
	align 010h
@BLBL134:

; 666                       if ((lIncrement = CountTraceElement(pwScrollBuffer[iIndex],CS_PACKET_DATA)) == 1)
	push	0ff00h
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-04h];	iIndex
	mov	ax,word ptr [eax+ecx*02h]
	push	eax
	call	CountTraceElement
	add	esp,08h
	mov	[ebp-08h],eax;	lIncrement
	cmp	dword ptr [ebp-08h],01h;	lIncrement
	je	@BLBL133

; 668                       iIndex--;
	mov	eax,[ebp-04h];	iIndex
	dec	eax
	mov	[ebp-04h],eax;	iIndex

; 669                       }

; 664                     while (iIndex >= 0)
	cmp	dword ptr [ebp-04h],0h;	iIndex
	jge	@BLBL134
@BLBL133:

; 670                     if (iIndex >= 0)
	cmp	dword ptr [ebp-04h],0h;	iIndex
	jl	@BLBL131

; 672                       stRow.lScrollIndex = iIndex;
	mov	eax,[ebp-04h];	iIndex
	mov	dword ptr  stRow+06fh,eax

; 673                       WinInvalidateRect(stRow.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stRow+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 674                       }

; 675                     }

; 676                   }
@BLBL131:

; 677                 return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL171:

; 679                 return(FALSE);
	xor	eax,eax
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL161
	align 04h
@BLBL162:
	cmp	eax,012h
	je	@BLBL163
	cmp	eax,011h
	je	@BLBL164
	cmp	eax,016h
	je	@BLBL165
	cmp	eax,018h
	je	@BLBL166
	cmp	eax,014h
	je	@BLBL167
	cmp	eax,013h
	je	@BLBL168
	cmp	eax,017h
	je	@BLBL169
	cmp	eax,015h
	je	@BLBL170
	jmp	@BLBL171
	align 04h
@BLBL161:

; 681             if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL138

; 683               if (!pstCFG->bSyncToRead)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+019h],02h
	jne	@BLBL139

; 684                 WinSendMsg(stWrite.hwndClient,WM_VSCROLL,0L,mpScrollDir);
	push	dword ptr [ebp-010h];	mpScrollDir
	push	0h
	push	031h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h
@BLBL139:

; 685               if (!pstCFG->bSyncToWrite)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+019h],01h
	jne	@BLBL141

; 686                 WinSendMsg(stRead.hwndClient,WM_VSCROLL,0L,mpScrollDir);
	push	dword ptr [ebp-010h];	mpScrollDir
	push	0h
	push	031h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 687               }
	jmp	@BLBL141
	align 010h
@BLBL138:

; 689               WinSendMsg(hwndClient,WM_VSCROLL,0L,mpScrollDir);
	push	dword ptr [ebp-010h];	mpScrollDir
	push	0h
	push	031h
	push	dword ptr  hwndClient
	call	WinSendMsg
	add	esp,010h
@BLBL141:

; 690             return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL105:

; 696   return(FALSE);
	xor	eax,eax
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
ProcessKeystroke	endp

; 700   {
	align 010h

	public GetNoClearComEvent_ComError
GetNoClearComEvent_ComError	proc
	push	ebp
	mov	ebp,esp
	sub	esp,014h
	push	eax
	push	edi
	mov	eax,0aaaaaaaah
	lea	edi,[esp+08h]
	stosd	
	stosd	
	stosd	
	stosd	
	stosd	
	pop	edi
	pop	eax

; 701   ULONG ulDataLen = 4L;
	mov	dword ptr [ebp-04h],04h;	ulDataLen

; 702   ULONG ulParmLen = 2L;
	mov	dword ptr [ebp-08h],02h;	ulParmLen

; 703   APIRET rc;
; 704   struct _stData
; 705     {
; 706     WORD wComError;
; 707     WORD wComEvent;
; 708     }stData;
; 709   WORD wSignature;
; 710 
; 711   wSignature = SIGNATURE;
	mov	word ptr [ebp-012h],02642h;	wSignature

; 712   rc = DosDevIOCtl(hCom,0x01,0x7b,(PVOID)&wSignature,2L,&ulParmLen,(PVOID)&stData,4L,&ulDataLen);
	lea	eax,[ebp-04h];	ulDataLen
	push	eax
	push	04h
	lea	eax,[ebp-010h];	stData
	push	eax
	lea	eax,[ebp-08h];	ulParmLen
	push	eax
	push	02h
	lea	eax,[ebp-012h];	wSignature
	push	eax
	push	07bh
	push	01h
	push	dword ptr [ebp+08h];	hCom
	call	DosDevIOCtl
	add	esp,024h
	mov	[ebp-0ch],eax;	rc

; 713   *pwCOMevent = stData.wComEvent;
	mov	eax,[ebp+0ch];	pwCOMevent
	mov	cx,[ebp-0eh];	stData
	mov	[eax],cx

; 714   *pwCOMerror = stData.wComError;
	mov	eax,[ebp+010h];	pwCOMerror
	mov	cx,[ebp-010h];	stData
	mov	[eax],cx

; 715   return(rc);
	mov	eax,[ebp-0ch];	rc
	mov	esp,ebp
	pop	ebp
	ret	
GetNoClearComEvent_ComError	endp

; 719   {
	align 010h

	public ProcessPacketData
ProcessPacketData	proc
	push	ebp
	mov	ebp,esp
	sub	esp,021ch
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,087h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 730   if ((pwScrollBuffer[lStartIndex] & CS_PACKET_DATA) == CS_PACKET_DATA)
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp+0ch];	lStartIndex
	mov	ax,word ptr [eax+ecx*02h]
	and	ax,0ff00h
	cmp	ax,0ff00h
	jne	@BLBL172

; 731     {
; 732     byCount = (((BYTE)pwScrollBuffer[lStartIndex] & 0x00ff) * 2);
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp+0ch];	lStartIndex
	mov	al,byte ptr [eax+ecx*02h]
	and	al,0ffh
	add	al,al
	mov	[ebp-05h],al;	byCount

; 733     pByte = (BYTE *)&pwScrollBuffer[lStartIndex + 1];
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp+0ch];	lStartIndex
	lea	eax,dword ptr [eax+ecx*02h]
	add	eax,02h
	mov	[ebp-0110h],eax;	pByte

; 734     for (lIndex = 0;lIndex < byCount;lIndex++)
	mov	dword ptr [ebp-04h],0h;	lIndex
	xor	eax,eax
	mov	al,[ebp-05h];	byCount
	cmp	[ebp-04h],eax;	lIndex
	jge	@BLBL176
	align 010h
@BLBL174:

; 735       abyData[lIndex] = pByte[lIndex];
	mov	ecx,[ebp-0110h];	pByte
	mov	eax,[ebp-04h];	lIndex
	mov	cl,byte ptr [ecx+eax]
	mov	eax,[ebp-04h];	lIndex
	mov	byte ptr [ebp+eax-010ch],cl

; 734     for (lIndex = 0;lIndex < byCount;lIndex++)
	mov	eax,[ebp-04h];	lIndex
	inc	eax
	mov	[ebp-04h],eax;	lIndex
	xor	eax,eax
	mov	al,[ebp-05h];	byCount
	cmp	[ebp-04h],eax;	lIndex
	jl	@BLBL174

; 736     }
	jmp	@BLBL176
	align 010h
@BLBL172:

; 738     byCount = 0;
	mov	byte ptr [ebp-05h],0h;	byCount
@BLBL176:

; 742   if ((usFunction & 0
; 742 xff00) != 0)
	test	byte ptr [ebp+011h],0ffh;	usFunction
	je	@BLBL177

; 744     switch (usFunction & 0xff00)
	xor	eax,eax
	mov	ax,[ebp+010h];	usFunction
	and	eax,0ff00h
	jmp	@BLBL239
	align 04h
@BLBL240:

; 747         if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL178

; 749           pUShort = (USHORT *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0214h],eax;	pUShort

; 750           iLen = sprintf(szMessage,"%u byte read request",*pUShort);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT2d
	lea	eax,[ebp-0210h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	mov	[ebp-0ch],eax;	iLen

; 751           }
	jmp	@BLBL179
	align 010h
@BLBL178:

; 753           iLen = sprintf(szMessage,"Read request");
	mov	edx,offset FLAT:@STAT2e
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen
@BLBL179:

; 754         if ((usFunction & 0x00ff) != 0)
	test	byte ptr [ebp+010h],0ffh;	usFunction
	je	@BLBL180

; 755           sprintf(&szMessage[iLen]," - %u level packet queued");
	mov	edx,offset FLAT:@STAT2f
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
@BLBL180:

; 756         break;
	jmp	@BLBL238
	align 04h
@BLBL241:

; 758         if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL181

; 760           pUShort = (USHORT *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0214h],eax;	pUShort

; 761           if (*pUShort == 1)
	mov	eax,[ebp-0214h];	pUShort
	cmp	word ptr [eax],01h
	jne	@BLBL182

; 762             iLen = sprintf(szMessage,"%u byte read",*pUShort);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT30
	lea	eax,[ebp-0210h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	mov	[ebp-0ch],eax;	iLen
	jmp	@BLBL184
	align 010h
@BLBL182:

; 764             iLen = sprintf(szMessage,"%u bytes read",*pUShort);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT31
	lea	eax,[ebp-0210h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	mov	[ebp-0ch],eax;	iLen

; 765           }
	jmp	@BLBL184
	align 010h
@BLBL181:

; 767           iLen = sprintf(szMessage,"Read completed");
	mov	edx,offset FLAT:@STAT32
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen
@BLBL184:

; 768         if ((usFunction & 0x00ff) != 0)
	test	byte ptr [ebp+010h],0ffh;	usFunction
	je	@BLBL185

; 769           sprintf(&szMessage[iLen]," - %u level packet dequeued");
	mov	edx,offset FLAT:@STAT33
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
@BLBL185:

; 770         break;
	jmp	@BLBL238
	align 04h
@BLBL242:

; 772         if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL186

; 774           pUShort = (USHORT *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0214h],eax;	pUShort

; 775           iLen = sprintf(szMessage,"%u byte write request",*pUShort);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT34
	lea	eax,[ebp-0210h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	mov	[ebp-0ch],eax;	iLen

; 776           }
	jmp	@BLBL187
	align 010h
@BLBL186:

; 778           iLen = sprintf(szMessage,"Write request");
	mov	edx,offset FLAT:@STAT35
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen
@BLBL187:

; 779         if ((usFunction & 0x00ff) != 0)
	test	byte ptr [ebp+010h],0ffh;	usFunction
	je	@BLBL188

; 780           sprintf(&szMessage[iLen]," - %u level packet queued");
	mov	edx,offset FLAT:@STAT36
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
@BLBL188:

; 781         break;
	jmp	@BLBL238
	align 04h
@BLBL243:

; 783         if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL189

; 785           pUShort = (USHORT *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0214h],eax;	pUShort

; 786           if (*pUShort == 1)
	mov	eax,[ebp-0214h];	pUShort
	cmp	word ptr [eax],01h
	jne	@BLBL190

; 787             iLen = sprintf(szMessage,"%u byte written",*pUShort);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT37
	lea	eax,[ebp-0210h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	mov	[ebp-0ch],eax;	iLen
	jmp	@BLBL192
	align 010h
@BLBL190:

; 789             iLen = sprintf(szMessage,"%u bytes written",*pUShort);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT38
	lea	eax,[ebp-0210h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	mov	[ebp-0ch],eax;	iLen

; 790           }
	jmp	@BLBL192
	align 010h
@BLBL189:

; 792           iLen = sprintf(szMessage,"Write completed");
	mov	edx,offset FLAT:@STAT39
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen
@BLBL192:

; 793         if ((usFunction & 0x00ff) != 0)
	test	byte ptr [ebp+010h],0ffh;	usFunction
	je	@BLBL193

; 794           sprintf(&szMessage[iLen]," - %u level packet dequeued");
	mov	edx,offset FLAT:@STAT3a
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
@BLBL193:

; 795         break;
	jmp	@BLBL238
	align 04h
@BLBL244:

; 797         sprintf(szMessage,"Unknown request -> value is 0x%04X",usFunction);
	xor	eax,eax
	mov	ax,[ebp+010h];	usFunction
	push	eax
	mov	edx,offset FLAT:@STAT3b
	lea	eax,[ebp-0210h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 798         break;
	jmp	@BLBL238
	align 04h
	jmp	@BLBL238
	align 04h
@BLBL239:
	cmp	eax,03c00h
	je	@BLBL240
	cmp	eax,03d00h
	je	@BLBL241
	cmp	eax,03e00h
	je	@BLBL242
	cmp	eax,03f00h
	je	@BLBL243
	jmp	@BLBL244
	align 04h
@BLBL238:

; 800     ErrorNotify(szMessage);
	lea	eax,[ebp-0210h];	szMessage
	push	eax
	call	ErrorNotify

; 801     return;
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL177:

; 806   switch (usFunction)
	xor	eax,eax
	mov	ax,[ebp+010h];	usFunction
	jmp	@BLBL246
	align 04h
@BLBL247:

; 809       iLen = sprintf(szMessage,"DevIOCtl, set baud Rate");
	mov	edx,offset FLAT:@STAT3c
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 810       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL194

; 812         pUShort = (USHORT *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0214h],eax;	pUShort

; 813         sprintf(&szMessage[iLen]," -> %u",*pUShort);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT3d
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 814         }
@BLBL194:

; 815       break;
	jmp	@BLBL245
	align 04h
@BLBL248:

; 817       iLen = sprintf(szMessage,"DevIOCtl, set line characteristics");
	mov	edx,offset FLAT:@STAT3e
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 818       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL195

; 820         iLen += sprintf(&szMessage[iLen]," -> %u, ",abyData[0]);
	xor	eax,eax
	mov	al,[ebp-010ch];	abyData
	push	eax
	mov	edx,offset FLAT:@STAT3f
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen

; 821         switch (abyData[1])
	xor	eax,eax
	mov	al,[ebp-010bh];	abyData
	jmp	@BLBL250
	align 04h
@BLBL251:

; 824             iLen += sprintf(&szMessage[iLen],"none, ");
	mov	edx,offset FLAT:@STAT40
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen

; 825             break;
	jmp	@BLBL249
	align 04h
@BLBL252:

; 827             iLen += sprintf(&szMessage[iLen],"odd, ");
	mov	edx,offset FLAT:@STAT41
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen

; 828             break;
	jmp	@BLBL249
	align 04h
@BLBL253:

; 830             iLen += sprintf(&szMessage[iLen],"even, ");
	mov	edx,offset FLAT:@STAT42
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen

; 831             break;
	jmp	@BLBL249
	align 04h
@BLBL254:

; 833             iLen += sprintf(&szMessage[iLen],"one, ");
	mov	edx,offset FLAT:@STAT43
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen

; 834             break;
	jmp	@BLBL249
	align 04h
@BLBL255:

; 836             iLen += sprintf(&szMessage[iLen],"zero, ");
	mov	edx,offset FLAT:@STAT44
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen

; 837             break;
	jmp	@BLBL249
	align 04h
	jmp	@BLBL249
	align 04h
@BLBL250:
	test	eax,eax
	je	@BLBL251
	cmp	eax,01h
	je	@BLBL252
	cmp	eax,02h
	je	@BLBL253
	cmp	eax,03h
	je	@BLBL254
	cmp	eax,04h
	je	@BLBL255
@BLBL249:

; 839         switch (abyData[2])
	xor	eax,eax
	mov	al,[ebp-010ah];	abyData
	jmp	@BLBL257
	align 04h
@BLBL258:

; 842             sprintf(&szMessage[iLen],"1");
	mov	edx,offset FLAT:@STAT45
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee

; 843             break;
	jmp	@BLBL256
	align 04h
@BLBL259:

; 845             sprintf(&szMessage[iLen],"1.5");
	mov	edx,offset FLAT:@STAT46
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee

; 846             break;
	jmp	@BLBL256
	align 04h
@BLBL260:

; 848             sprintf(&szMessage[iLen],"2");
	mov	edx,offset FLAT:@STAT47
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee

; 849             break;
	jmp	@BLBL256
	align 04h
	jmp	@BLBL256
	align 04h
@BLBL257:
	test	eax,eax
	je	@BLBL258
	cmp	eax,01h
	je	@BLBL259
	cmp	eax,02h
	je	@BLBL260
@BLBL256:

; 851         }
@BLBL195:

; 852       break;
	jmp	@BLBL245
	align 04h
@BLBL261:

; 854       iLen = sprintf(szMessage,"DevIOCtl, set extended baud rate");
	mov	edx,offset FLAT:@STAT48
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 855       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL196

; 857         pULong = (ULONG *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0218h],eax;	pULong

; 858         sprintf(&szMessage[iLen]," -> %u",*pULong);
	mov	eax,[ebp-0218h];	pULong
	push	dword ptr [eax]
	mov	edx,offset FLAT:@STAT49
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 859         }
@BLBL196:

; 860       break;
	jmp	@BLBL245
	align 04h
@BLBL262:

; 862       iLen = sprintf(szMessage,"DevIOCtl, transmit byte immediate");
	mov	edx,offset FLAT:@STAT4a
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 863       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL197

; 865         pByte = (BYTE *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0110h],eax;	pByte

; 866         sprintf(&szMessage[iLen]," -> 0x%02X",*pByte);
	mov	ecx,[ebp-0110h];	pByte
	xor	eax,eax
	mov	al,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT4b
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 867         }
@BLBL197:

; 868       break;
	jmp	@BLBL245
	align 04h
@BLBL263:

; 870       iLen = sprintf(szMessage,"DevIOCtl, set modem output signals");
	mov	edx,offset FLAT:@STAT4c
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 871       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL198

; 873         if (abyData[0] & 0x01)
	test	byte ptr [ebp-010ch],01h;	abyData
	je	@BLBL199

; 874           iLen += sprintf(&szMessage[iLen]," - DTR->on ");
	mov	edx,offset FLAT:@STAT4d
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen
	jmp	@BLBL200
	align 010h
@BLBL199:

; 876           if ((abyData[1] & 0x01) == 0)
	test	byte ptr [ebp-010bh],01h;	abyData
	jne	@BLBL200

; 877             iLen += sprintf(&szMessage[iLen]," - DTR->off");
	mov	edx,offset FLAT:@STAT4e
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen
@BLBL200:

; 878         if (abyData[0] & 0x02)
	test	byte ptr [ebp-010ch],02h;	abyData
	je	@BLBL202

; 879           sprintf(&szMessage[iLen]," RTS->on");
	mov	edx,offset FLAT:@STAT4f
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	jmp	@BLBL198
	align 010h
@BLBL202:

; 881           if ((abyData[1] & 0x02) == 0)
	test	byte ptr [ebp-010bh],02h;	abyData
	jne	@BLBL198

; 882             sprintf(&szMessage[iLen]," RTS->off");
	mov	edx,offset FLAT:@STAT50
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee

; 883         }
@BLBL198:

; 884       break;
	jmp	@BLBL245
	align 04h
@BLBL264:

; 886       iLen = sprintf(szMessage,"DevIOCtl, set DCB parameters");
	mov	edx,offset FLAT:@STAT51
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 887       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL205

; 888         if (stCFG.bPopupParams)
	test	byte ptr  stCFG+019h,040h
	je	@BLBL205

; 889           WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpDCBpacketDlgProc,NULLHANDLE,DCB_PACKET_DLG,abyData);
	lea	eax,[ebp-010ch];	abyData
	push	eax
	push	0c1ch
	push	0h
	push	offset FLAT: fnwpDCBpacketDlgProc
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
@BLBL205:

; 890       break;
	jmp	@BLBL245
	align 04h
@BLBL265:

; 892       iLen = sprintf(szMessage,"DevIOCtl, set extended FIFO processing");
	mov	edx,offset FLAT:@STAT52
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 893       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL207

; 895         pUShort = (USHORT *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0214h],eax;	pUShort

; 896         sprintf(&szMessage[iLen]," -> %u",*pUShort);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT53
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 897         }
@BLBL207:

; 898       break;
	jmp	@BLBL245
	align 04h
@BLBL266:

; 900       iLen = sprintf(szMessage,"DevIOCtl, set thresholds");
	mov	edx,offset FLAT:@STAT54
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 901       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL208

; 903         pUShort = (USHORT *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0214h],eax;	pUShort

; 904         sprintf(&szMessage[iLen]," -> %u",*pUShort);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT55
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 905         }
@BLBL208:

; 906       break;
	jmp	@BLBL245
	align 04h
@BLBL267:

; 908       iLen = sprintf(szMessage,"DevIOCtl, query baud rate");
	mov	edx,offset FLAT:@STAT56
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 909       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL209

; 911         pUShort = (USHORT *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0214h],eax;	pUShort

; 912         sprintf(&szMessage[iLen]," -> %u",*pUShort);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT57
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 913         }
@BLBL209:

; 914       break;
	jmp	@BLBL245
	align 04h
@BLBL268:

; 916       iLen = sprintf(szMessage,"DevIOCtl, query line characteristics");
	mov	edx,offset FLAT:@STAT58
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 917       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL210

; 919         iLen += sprintf(&szMessage[iLen]," -> %u, ",abyData[0]);
	xor	eax,eax
	mov	al,[ebp-010ch];	abyData
	push	eax
	mov	edx,offset FLAT:@STAT59
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen

; 920         switch (abyData[1])
	xor	eax,eax
	mov	al,[ebp-010bh];	abyData
	jmp	@BLBL270
	align 04h
@BLBL271:

; 923             iLen += sprintf(&szMessage[iLen],"none, ");
	mov	edx,offset FLAT:@STAT5a
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen

; 924             break;
	jmp	@BLBL269
	align 04h
@BLBL272:

; 926             iLen += sprintf(&szMessage[iLen],"odd, ");
	mov	edx,offset FLAT:@STAT5b
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen

; 927             break;
	jmp	@BLBL269
	align 04h
@BLBL273:

; 929             iLen += sprintf(&szMessage[iLen],"even, ");
	mov	edx,offset FLAT:@STAT5c
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen

; 930             break;
	jmp	@BLBL269
	align 04h
@BLBL274:

; 932             iLen += sprintf(&szMessage[iLen],"one, ");
	mov	edx,offset FLAT:@STAT5d
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen

; 933             break;
	jmp	@BLBL269
	align 04h
@BLBL275:

; 935             iLen += sprintf(&szMessage[iLen],"zero, ");
	mov	edx,offset FLAT:@STAT5e
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen

; 936             break;
	jmp	@BLBL269
	align 04h
	jmp	@BLBL269
	align 04h
@BLBL270:
	test	eax,eax
	je	@BLBL271
	cmp	eax,01h
	je	@BLBL272
	cmp	eax,02h
	je	@BLBL273
	cmp	eax,03h
	je	@BLBL274
	cmp	eax,04h
	je	@BLBL275
@BLBL269:

; 938         switch (abyData[2])
	xor	eax,eax
	mov	al,[ebp-010ah];	abyData
	jmp	@BLBL277
	align 04h
@BLBL278:

; 941             sprintf(&szMessage[iLen],"1");
	mov	edx,offset FLAT:@STAT5f
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee

; 942             break;
	jmp	@BLBL276
	align 04h
@BLBL279:

; 944             sprintf(&szMessage[iLen],"1.5");
	mov	edx,offset FLAT:@STAT60
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee

; 945             break;
	jmp	@BLBL276
	align 04h
@BLBL280:

; 947             sprintf(&szMessage[iLen],"2");
	mov	edx,offset FLAT:@STAT61
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee

; 948             break;
	jmp	@BLBL276
	align 04h
	jmp	@BLBL276
	align 04h
@BLBL277:
	test	eax,eax
	je	@BLBL278
	cmp	eax,01h
	je	@BLBL279
	cmp	eax,02h
	je	@BLBL280
@BLBL276:

; 950         }
@BLBL210:

; 951       break;
	jmp	@BLBL245
	align 04h
@BLBL281:

; 953       iLen = sprintf(szMessage,"DevIOCtl, query extended baud rate");
	mov	edx,offset FLAT:@STAT62
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 954       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL211

; 956         pstBaud = (BAUDST *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-021ch],eax;	pstBaud

; 957         sprintf(&szMessage[iLen]," -> %u, min=%u, max=%u",pstBaud->stCurrentBaud.lBaudRate,
	mov	eax,[ebp-021ch];	pstBaud
	push	dword ptr [eax+0ah]
	mov	eax,[ebp-021ch];	pstBaud
	push	dword ptr [eax+05h]
	mov	eax,[ebp-021ch];	pstBaud
	push	dword ptr [eax]
	mov	edx,offset FLAT:@STAT63
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,014h

; 960         }
@BLBL211:

; 961       break;
	jmp	@BLBL245
	align 04h
@BLBL282:

; 963       iLen = sprintf(szMessage,"DevIOCtl, query COM status");
	mov	edx,offset FLAT:@STAT64
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 964       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL212

; 965         sprintf(&szMessage[iLen]," -> 0x%02X",abyData[0]);
	xor	eax,eax
	mov	al,[ebp-010ch];	abyData
	push	eax
	mov	edx,offset FLAT:@STAT65
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
@BLBL212:

; 966       if (stCFG.bPopupParams)
	test	byte ptr  stCFG+019h,040h
	je	@BLBL213

; 967         WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpCOMstatusStatesDlg,NULLHANDLE,CST_DLG,abyData);
	lea	eax,[ebp-010ch];	abyData
	push	eax
	push	0b54h
	push	0h
	push	offset FLAT: fnwpCOMstatusStatesDlg
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
@BLBL213:

; 968       break;
	jmp	@BLBL245
	align 04h
@BLBL283:

; 970       iLen = sprintf(szMessage,"DevIOCtl, query transmit data status");
	mov	edx,offset FLAT:@STAT66
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 971       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL214

; 972         sprintf(&szMessage[iLen]," -> 0x%02X",abyData[0]);
	xor	eax,eax
	mov	al,[ebp-010ch];	abyData
	push	eax
	mov	edx,offset FLAT:@STAT67
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
@BLBL214:

; 973       if (stCFG.bPopupParams)
	test	byte ptr  stCFG+019h,040h
	je	@BLBL215

; 974         WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpXmitStatusStatesDlg,NULLHANDLE,TST_DLG,abyData);
	lea	eax,[ebp-010ch];	abyData
	push	eax
	push	0a8ch
	push	0h
	push	offset FLAT: fnwpXmitStatusStatesDlg
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
@BLBL215:

; 975       break;
	jmp	@BLBL245
	align 04h
@BLBL284:

; 977       iLen = sprintf(szMessage,"DevIOCtl, query output modem signals");
	mov	edx,offset FLAT:@STAT68
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 978       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL216

; 980         if (abyData[0] & 0x01)
	test	byte ptr [ebp-010ch],01h;	abyData
	je	@BLBL217

; 981           iLen += sprintf(&szMessage[iLen]," - DTR->on ");
	mov	edx,offset FLAT:@STAT69
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen
	jmp	@BLBL218
	align 010h
@BLBL217:

; 983           iLen += sprintf(&szMessage[iLen]," - DTR->off");
	mov	edx,offset FLAT:@STAT6a
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen
@BLBL218:

; 984         if (abyData[0] & 0x02)
	test	byte ptr [ebp-010ch],02h;	abyData
	je	@BLBL219

; 985           sprintf(&szMessage[iLen]," RTS->on");
	mov	edx,offset FLAT:@STAT6b
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	jmp	@BLBL216
	align 010h
@BLBL219:

; 987           sprintf(&szMessage[iLen]," RTS->off");
	mov	edx,offset FLAT:@STAT6c
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee

; 988         }
@BLBL216:

; 989       break;
	jmp	@BLBL245
	align 04h
@BLBL285:

; 991       iLen = sprintf(szMessage,"DevIOCtl, query input modem signals");
	mov	edx,offset FLAT:@STAT6d
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 992       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL221

; 994         if (abyData[0] & 0x10)
	test	byte ptr [ebp-010ch],010h;	abyData
	je	@BLBL222

; 995           iLen += sprintf(&szMessage[iLen]," - CTS->on  ");
	mov	edx,offset FLAT:@STAT6e
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen
	jmp	@BLBL223
	align 010h
@BLBL222:

; 997           iLen += sprintf(&szMessage[iLen]," - CTS->off ");
	mov	edx,offset FLAT:@STAT6f
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen
@BLBL223:

; 998         if (abyData[0] & 0x20)
	test	byte ptr [ebp-010ch],020h;	abyData
	je	@BLBL224

; 999           iLen += sprint
; 999 f(&szMessage[iLen],"DSR->on  ");
	mov	edx,offset FLAT:@STAT70
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen
	jmp	@BLBL225
	align 010h
@BLBL224:

; 1001           iLen += sprintf(&szMessage[iLen],"DSR->off ");
	mov	edx,offset FLAT:@STAT71
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	add	eax,[ebp-0ch];	iLen
	mov	[ebp-0ch],eax;	iLen
@BLBL225:

; 1008         if (abyData[0] & 0x80)
	test	byte ptr [ebp-010ch],080h;	abyData
	je	@BLBL226

; 1009           sprintf(&szMessage[iLen],"CD->on");
	mov	edx,offset FLAT:@STAT72
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee
	jmp	@BLBL221
	align 010h
@BLBL226:

; 1011           sprintf(&szMessage[iLen],"CD->off");
	mov	edx,offset FLAT:@STAT73
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	call	_sprintfieee

; 1012         }
@BLBL221:

; 1013       break;
	jmp	@BLBL245
	align 04h
@BLBL286:

; 1015       iLen = sprintf(szMessage,"DevIOCtl, query receive queue");
	mov	edx,offset FLAT:@STAT74
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 1016       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL228

; 1018         pUShort = (USHORT *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0214h],eax;	pUShort

; 1019         sprintf(&szMessage[iLen]," -> %u in %u byte queue",pUShort[0],pUShort[1]);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx+02h]
	push	eax
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT75
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 1020         }
@BLBL228:

; 1021       break;
	jmp	@BLBL245
	align 04h
@BLBL287:

; 1023       iLen = sprintf(szMessage,"DevIOCtl, query transmit queue");
	mov	edx,offset FLAT:@STAT76
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 1024       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL229

; 1026         pUShort = (USHORT *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0214h],eax;	pUShort

; 1027         sprintf(&szMessage[iLen]," -> %u in %u byte queue",pUShort[0],pUShort[1]);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx+02h]
	push	eax
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT77
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 1028         }
@BLBL229:

; 1029       break;
	jmp	@BLBL245
	align 04h
@BLBL288:

; 1031       iLen = sprintf(szMessage,"DevIOCtl, query COM error");
	mov	edx,offset FLAT:@STAT78
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 1032       if (byCount == sizeof(SHORT))
	cmp	byte ptr [ebp-05h],02h;	byCount
	jne	@BLBL230

; 1034         pUShort = (USHORT *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0214h],eax;	pUShort

; 1035         sprintf(&szMessage[iLen]," -> 0x%04X",*pUShort);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT79
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1036         if (stCFG.bPopupParams)
	test	byte ptr  stCFG+019h,040h
	je	@BLBL230

; 1037           WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpCOMerrorStatesDlg,NULLHANDLE,CER_DLG,pUShort);
	push	dword ptr [ebp-0214h];	pUShort
	push	0a28h
	push	0h
	push	offset FLAT: fnwpCOMerrorStatesDlg
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h

; 1038         }
@BLBL230:

; 1039       break;
	jmp	@BLBL245
	align 04h
@BLBL289:

; 1041       iLen = sprintf(szMessage,"DevIOCtl, query COM event info");
	mov	edx,offset FLAT:@STAT7a
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 1042       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL232

; 1044         pUShort = (USHORT *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0214h],eax;	pUShort

; 1045         sprintf(&szMessage[iLen]," -> 0x%04X",*pUShort);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT7b
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1046         if (stCFG.bPopupParams)
	test	byte ptr  stCFG+019h,040h
	je	@BLBL232

; 1047           WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpCOMeventStatesDlg,NULLHANDLE,CEV_DLG,pUShort);
	push	dword ptr [ebp-0214h];	pUShort
	push	0af0h
	push	0h
	push	offset FLAT: fnwpCOMeventStatesDlg
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h

; 1048         }
@BLBL232:

; 1049       break;
	jmp	@BLBL245
	align 04h
@BLBL290:

; 1051       iLen = sprintf(szMessage,"DevIOCtl, query DCB parameters");
	mov	edx,offset FLAT:@STAT7c
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 1052       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL234

; 1053         if (stCFG.bPopupParams)
	test	byte ptr  stCFG+019h,040h
	je	@BLBL234

; 1054           WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpDCBpacketDlgProc,NULLHANDLE,DCB_PACKET_DLG,abyData);
	lea	eax,[ebp-010ch];	abyData
	push	eax
	push	0c1ch
	push	0h
	push	offset FLAT: fnwpDCBpacketDlgProc
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
@BLBL234:

; 1055       break;
	jmp	@BLBL245
	align 04h
@BLBL291:

; 1057       iLen = sprintf(szMessage,"DevIOCtl, query FIFO info");
	mov	edx,offset FLAT:@STAT7d
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 1058       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL236

; 1060         pUShort = (USHORT *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0214h],eax;	pUShort

; 1061         sprintf(&szMessage[iLen]," -> %u",*pUShort);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT7e
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1062         }
@BLBL236:

; 1063       break;
	jmp	@BLBL245
	align 04h
@BLBL292:

; 1065       iLen = sprintf(szMessage,"DevIOCtl, query threshold info");
	mov	edx,offset FLAT:@STAT7f
	lea	eax,[ebp-0210h];	szMessage
	call	_sprintfieee
	mov	[ebp-0ch],eax;	iLen

; 1066       if (byCount)
	cmp	byte ptr [ebp-05h],0h;	byCount
	je	@BLBL237

; 1068         pUShort = (USHORT *)abyData;
	lea	eax,[ebp-010ch];	abyData
	mov	[ebp-0214h],eax;	pUShort

; 1069         sprintf(&szMessage[iLen]," -> %u",*pUShort);
	mov	ecx,[ebp-0214h];	pUShort
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT80
	mov	eax,[ebp-0ch];	iLen
	lea	eax,dword ptr [ebp+eax-0210h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1070         }
@BLBL237:

; 1071       break;
	jmp	@BLBL245
	align 04h
@BLBL293:

; 1073       sprintf(szMessage,"Unsupported function -> 0x%02X",(BYTE)usFunction);
	mov	al,[ebp+010h];	usFunction
	and	eax,0ffh
	push	eax
	mov	edx,offset FLAT:@STAT81
	lea	eax,[ebp-0210h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1074       break;
	jmp	@BLBL245
	align 04h
	jmp	@BLBL245
	align 04h
@BLBL246:
	cmp	eax,041h
	je	@BLBL247
	cmp	eax,042h
	je	@BLBL248
	cmp	eax,043h
	je	@BLBL261
	cmp	eax,044h
	je	@BLBL262
	cmp	eax,046h
	je	@BLBL263
	cmp	eax,053h
	je	@BLBL264
	cmp	eax,055h
	je	@BLBL265
	cmp	eax,056h
	je	@BLBL266
	cmp	eax,061h
	je	@BLBL267
	cmp	eax,062h
	je	@BLBL268
	cmp	eax,063h
	je	@BLBL281
	cmp	eax,064h
	je	@BLBL282
	cmp	eax,065h
	je	@BLBL283
	cmp	eax,066h
	je	@BLBL284
	cmp	eax,067h
	je	@BLBL285
	cmp	eax,068h
	je	@BLBL286
	cmp	eax,069h
	je	@BLBL287
	cmp	eax,06dh
	je	@BLBL288
	cmp	eax,072h
	je	@BLBL289
	cmp	eax,073h
	je	@BLBL290
	cmp	eax,075h
	je	@BLBL291
	cmp	eax,076h
	je	@BLBL292
	jmp	@BLBL293
	align 04h
@BLBL245:

; 1076   ErrorNotify(szMessage);
	lea	eax,[ebp-0210h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1077   }
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
ProcessPacketData	endp

; 1080   {
	align 010h

	public DisplayCharacterInfo
DisplayCharacterInfo	proc
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
	sub	esp,08h

; 1089   lIndex = stRow.lScrollIndex;
	mov	eax,dword ptr  stRow+06fh
	mov	[ebp-068h],eax;	lIndex

; 1090   while (lIndex < lScrollCount)
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-068h],eax;	lIndex
	jge	@BLBL294
	align 010h
@BLBL295:

; 1091     {
; 1092     if ((ulIncrement = CountTraceElement(pwScrollBuffer[lIndex],0xff00)) != 0)
	push	0ff00h
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-068h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	push	eax
	call	CountTraceElement
	add	esp,08h
	mov	[ebp-078h],eax;	ulIncrement
	cmp	dword ptr [ebp-078h],0h;	ulIncrement
	je	@BLBL296

; 1093       {
; 1094       if (ulIncrement == 1)
	cmp	dword ptr [ebp-078h],01h;	ulIncrement
	jne	@BLBL297

; 1095         if (lMouseIndex-- == 0)
	cmp	dword ptr [ebp+0ch],0h;	lMouseIndex
	jne	@BLBL298
	mov	eax,[ebp+0ch];	lMouseIndex
	dec	eax
	mov	[ebp+0ch],eax;	lMouseIndex

; 1096           break;
	jmp	@BLBL294
	align 010h
@BLBL298:
	mov	eax,[ebp+0ch];	lMouseIndex
	dec	eax
	mov	[ebp+0ch],eax;	lMouseIndex
@BLBL297:

; 1097       lIndex += ulIncrement;
	mov	eax,[ebp-068h];	lIndex
	add	eax,[ebp-078h];	ulIncrement
	mov	[ebp-068h],eax;	lIndex

; 1098       }
	jmp	@BLBL301
	align 010h
@BLBL296:

; 1099     else
; 1100       lIndex++;
	mov	eax,[ebp-068h];	lIndex
	inc	eax
	mov	[ebp-068h],eax;	lIndex
@BLBL301:

; 1101     }

; 1090   while (lIndex < lScrollCount)
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-068h],eax;	lIndex
	jl	@BLBL295
@BLBL294:

; 1102   if (lIndex >= lScrollCount)
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-068h],eax;	lIndex
	jl	@BLBL302

; 1105     ErrorNotify("No information");
	push	offset FLAT:@STAT82
	call	ErrorNotify

; 1107     return;
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL302:

; 1109   usKey = pwScrollBuffer[lIndex];
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-068h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	mov	[ebp-06ah],ax;	usKey

; 1110   byChar = (BYTE)usKey;
	mov	ax,[ebp-06ah];	usKey
	mov	[ebp-06bh],al;	byChar

; 1111   bIsPrintable = isprint(byChar);
	mov	ecx,dword ptr  _ctype
	xor	edx,edx
	mov	dl,[ebp-06bh];	byChar
	xor	eax,eax
	mov	ax,word ptr [ecx+edx*02h]
	and	eax,0400h
	mov	[ebp-074h],eax;	bIsPrintable

; 1112   switch  (usKey & 0xff00)
	xor	eax,eax
	mov	ax,[ebp-06ah];	usKey
	and	eax,0ff00h
	jmp	@BLBL333
	align 04h
@BLBL334:

; 1115       iLen = sprintf(szMessage,"Read stream <- ");
	mov	edx,offset FLAT:@STAT83
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee
	mov	[ebp-070h],eax;	iLen

; 1116       if (byChar != ' ')
	cmp	byte ptr [ebp-06bh],020h;	byChar
	je	@BLBL303

; 1117         if (bIsPrintable)
	cmp	dword ptr [ebp-074h],0h;	bIsPrintable
	je	@BLBL303

; 1119           sprintf(&szMessage[iLen],"%c",byChar);
	xor	eax,eax
	mov	al,[ebp-06bh];	byChar
	push	eax
	mov	edx,offset FLAT:@STAT84
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1120           break;
	jmp	@BLBL332
	align 04h
@BLBL303:

; 1122       sprintf(&szMessage[iLen],"0x%02X ",byChar);
	xor	eax,eax
	mov	al,[ebp-06bh];	byChar
	push	eax
	mov	edx,offset FLAT:@STAT85
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1123       break;
	jmp	@BLBL332
	align 04h
@BLBL335:

; 1125       iLen = sprintf(szMessage,"Xon/Xoff character received <- ");
	mov	edx,offset FLAT:@STAT86
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee
	mov	[ebp-070h],eax;	iLen

; 1126       if (byChar != ' ')
	cmp	byte ptr [ebp-06bh],020h;	byChar
	je	@BLBL305

; 1127         if (bIsPrintable)
	cmp	dword ptr [ebp-074h],0h;	bIsPrintable
	je	@BLBL305

; 1129           sprintf(&szMessage[iLen],"%c",byChar);
	xor	eax,eax
	mov	al,[ebp-06bh];	byChar
	push	eax
	mov	edx,offset FLAT:@STAT87
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1130           break;
	jmp	@BLBL332
	align 04h
@BLBL305:

; 1132       sprintf(&szMessage[iLen],"0x%02X ",byChar);
	xor	eax,eax
	mov	al,[ebp-06bh];	byChar
	push	eax
	mov	edx,offset FLAT:@STAT88
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1133       break;
	jmp	@BLBL332
	align 04h
@BLBL336:

; 1135       iLen = sprintf(szMessage,"Write stream -> ");
	mov	edx,offset FLAT:@STAT89
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee
	mov	[ebp-070h],eax;	iLen

; 1136       if (byChar != ' ')
	cmp	byte ptr [ebp-06bh],020h;	byChar
	je	@BLBL307

; 1137         if (bIsPrintable)
	cmp	dword ptr [ebp-074h],0h;	bIsPrintable
	je	@BLBL307

; 1139           sprintf(&szMessage[iLen],"%c",byChar);
	xor	eax,eax
	mov	al,[ebp-06bh];	byChar
	push	eax
	mov	edx,offset FLAT:@STAT8a
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1140           break;
	jmp	@BLBL332
	align 04h
@BLBL307:

; 1142       sprintf(&szMessage[iLen],"0x%02X ",byChar);
	xor	eax,eax
	mov	al,[ebp-06bh];	byChar
	push	eax
	mov	edx,offset FLAT:@STAT8b
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1143       break;
	jmp	@BLBL332
	align 04h
@BLBL337:

; 1145       iLen = sprintf(szMessage,"Xon/Xoff or transmit byte immediate -> ");
	mov	edx,offset FLAT:@STAT8c
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee
	mov	[ebp-070h],eax;	iLen

; 1146       if (byChar != ' ')
	cmp	byte ptr [ebp-06bh],020h;	byChar
	je	@BLBL309

; 1147         if (bIsPrintable)
	cmp	dword ptr [ebp-074h],0h;	bIsPrintable
	je	@BLBL309

; 1149           sprintf(&szMessage[iLen],"%c",byChar);
	xor	eax,eax
	mov	al,[ebp-06bh];	byChar
	push	eax
	mov	edx,offset FLAT:@STAT8d
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1150           break;
	jmp	@BLBL332
	align 04h
@BLBL309:

; 1152       sprintf(&szMessage[iLen],"0x%02X ",byChar);
	xor	eax,eax
	mov	al,[ebp-06bh];	byChar
	push	eax
	mov	edx,offset FLAT:@STAT8e
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1153       break;
	jmp	@BLBL332
	align 04h
@BLBL338:

; 1155       switch (byChar)
	xor	eax,eax
	mov	al,[ebp-06bh];	byChar
	jmp	@BLBL340
	align 04h
@BLBL341:

; 1158           sprintf(szMessage,"Output buffer flushed");
	mov	edx,offset FLAT:@STAT8f
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 1159           break;
	jmp	@BLBL339
	align 04h
@BLBL342:

; 1161           sprintf(szMessage,"Input buffer flushed");
	mov	edx,offset FLAT:@STAT90
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 1162           break;
	jmp	@BLBL339
	align 04h
@BLBL343:

; 1164           sprintf(szMessage,"DevIOCtl, set line BREAK off");
	mov	edx,offset FLAT:@STAT91
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 1165           break;
	jmp	@BLBL339
	align 04h
@BLBL344:

; 1167           sprintf(szMessage,"DevIOCtl, act like Xoff received");
	mov	edx,offset FLAT:@STAT92
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 1168           break;
	jmp	@BLBL339
	align 04h
@BLBL345:

; 1170           sprintf(szMessage,"DevIOCtl, act like Xon signal received");
	mov	edx,offset FLAT:@STAT93
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 1171           break;
	jmp	@BLBL339
	align 04h
@BLBL346:

; 1173           sprintf(szMessage,"DevIOCtl, set line BREAK on");
	mov	edx,offset FLAT:@STAT94
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 1174           break;
	jmp	@BLBL339
	align 04h
@BLBL347:

; 1176           sprintf(szMessage,"DevIOCtl, set enhanced mode (not supported)");
	mov	edx,offset FLAT:@STAT95
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 1177           break;
	jmp	@BLBL339
	align 04h
@BLBL348:

; 1179           sprintf(szMessage,"DevIOCtl, query enhanced mode (not supported)");
	mov	edx,offset FLAT:@STAT96
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 1180           break;
	jmp	@BLBL339
	align 04h
@BLBL349:

; 1182           ProcessPacketData(hwnd,(lIndex + 1),byChar);
	xor	ax,ax
	mov	al,[ebp-06bh];	byChar
	push	eax
	mov	eax,[ebp-068h];	lIndex
	inc	eax
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	ProcessPacketData

; 1183           return;
	add	esp,014h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL339
	align 04h
@BLBL340:
	cmp	eax,0f0h
	je	@BLBL341
	cmp	eax,0f1h
	je	@BLBL342
	cmp	eax,045h
	je	@BLBL343
	cmp	eax,047h
	je	@BLBL344
	cmp	eax,048h
	je	@BLBL345
	cmp	eax,04bh
	je	@BLBL346
	cmp	eax,054h
	je	@BLBL347
	cmp	eax,074h
	je	@BLBL348
	jmp	@BLBL349
	align 04h
@BLBL339:

; 1185       break;
	jmp	@BLBL332
	align 04h
@BLBL350:

; 1187       ProcessPacketData(hwnd,(lIndex + 1),(CS_READ_REQUEST | (USHORT)byChar));
	xor	eax,eax
	mov	al,[ebp-06bh];	byChar
	or	ah,03ch
	push	eax
	mov	eax,[ebp-068h];	lIndex
	inc	eax
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	ProcessPacketData

; 1188       return;
	add	esp,014h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL351:

; 1190       ProcessPacketData(hwnd,(lIndex + 1),(CS_READ_COMPLETE | (USHORT)byChar));
	xor	eax,eax
	mov	al,[ebp-06bh];	byChar
	or	ah,03dh
	push	eax
	mov	eax,[ebp-068h];	lIndex
	inc	eax
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	ProcessPacketData

; 1191       return;
	add	esp,014h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL352:

; 1193       ProcessPacketData(hwnd,(lIndex + 1),(CS_WRITE_REQUEST | (USHORT)byChar));
	xor	eax,eax
	mov	al,[ebp-06bh];	byChar
	or	ah,03eh
	push	eax
	mov	eax,[ebp-068h];	lIndex
	inc	eax
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	ProcessPacketData

; 1194       return;
	add	esp,014h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL353:

; 1196       ProcessPacketData(hwnd,(lIndex + 1),(CS_WRITE_COMPLETE | (USHORT)byChar));
	xor	eax,eax
	mov	al,[ebp-06bh];	byChar
	or	ah,03fh
	push	eax
	mov	eax,[ebp-068h];	lIndex
	inc	eax
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	ProcessPacketData

; 1197       return;
	add	esp,014h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL354:

; 1199       sprintf(szMessage,"First level DosOpen request");
	mov	edx,offset FLAT:@STAT97
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 1200       break;
	jmp	@BLBL332
	align 04h
@BLBL355:

; 1202       sprintf(szMessage,"Second level DosOpen request");
	mov	edx,offset FLAT:@STAT98
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 1203       break;
	jmp	@BLBL332
	align 04h
@BLBL356:

; 1205       sprintf(szMessage,"First level DosClose complete");
	mov	edx,offset FLAT:@STAT99
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 1206       break;
	jmp	@BLBL332
	align 04h
@BLBL357:

; 1208       sprintf(szMessage,"Second level DosClose complete");
	mov	edx,offset FLAT:@STAT9a
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 1209       break;
	jmp	@BLBL332
	align 04h
@BLBL358:

; 1211       if (byChar & LINE_CTL_SEND_BREAK)
	test	byte ptr [ebp-06bh],040h;	byChar
	je	@BLBL311

; 1212         sprintf(szMessage,"Begin sending line BREAK");
	mov	edx,offset FLAT:@STAT9b
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee
	jmp	@BLBL312
	align 010h
@BLBL311:

; 1214         sprintf(szMessage,"Stop sending line BREAK");
	mov	edx,offset FLAT:@STAT9c
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee
@BLBL312:

; 1215       break;
	jmp	@BLBL332
	align 04h
@BLBL359:

; 1217       sprintf(szMessage,"Receive line BREAK detected");
	mov	edx,offset FLAT:@STAT9d
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 1218       break;
	jmp	@BLBL332
	align 04h
@BLBL360:

; 1220       iLen = sprintf(szMessage,"Modem input signal(s) changed - ");
	mov	edx,offset FLAT:@STAT9e
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee
	mov	[ebp-070h],eax;	iLen

; 1221       if (byChar & MDM_ST_DELTA_CTS)
	test	byte ptr [ebp-06bh],01h;	byChar
	je	@BLBL313

; 1222         if (byChar & MDM_ST_CTS)
	test	byte ptr [ebp-06bh],010h;	byChar
	je	@BLBL314

; 1223           iLen += sprintf(&szMessage[iLen],"CTS->on  ");
	mov	edx,offset FLAT:@STAT9f
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	call	_sprintfieee
	add	eax,[ebp-070h];	iLen
	mov	[ebp-070h],eax;	iLen
	jmp	@BLBL313
	align 010h
@BLBL314:

; 1225           iLen += sprintf(&szMessage[iLen],"CTS->off ");
	mov	edx,offset FLAT:@STATa0
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	call	_sprintfieee
	add	eax,[ebp-070h];	iLen
	mov	[ebp-070h],eax;	iLen
@BLBL313:

; 1226       if (byChar & MDM_ST_DELTA_DSR)
	test	byte ptr [ebp-06bh],02h;	byChar
	je	@BLBL316

; 1227         if (byChar & MDM_ST_DSR)
	test	byte ptr [ebp-06bh],020h;	byChar
	je	@BLBL317

; 1228           iLen += sprintf(&szMessage[iLen],"DSR->on  ");
	mov	edx,offset FLAT:@STATa1
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	call	_sprintfieee
	add	eax,[ebp-070h];	iLen
	mov	[ebp-070h],eax;	iLen
	jmp	@BLBL316
	align 010h
@BLBL317:

; 1230           iLen += sprintf(&szMessage[iLen],"DSR->off ");
	mov	edx,offset FLAT:@STATa2
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	call	_sprintfieee
	add	eax,[ebp-070h];	iLen
	mov	[ebp-070h],eax;	iLen
@BLBL316:

; 1231       if (byChar & MDM_ST_DELTA_TRI)
	test	byte ptr [ebp-06bh],04h;	byChar
	je	@BLBL319

; 1232         if (byChar & MDM_ST_TRI)
	test	byte ptr [ebp-06bh],040h;	byChar
	je	@BLBL320

; 1233           iLen += sprintf(&szMessage[iLen],"RI->on  ");
	mov	edx,offset FLAT:@STATa3
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	call	_sprintfieee
	add	eax,[ebp-070h];	iLen
	mov	[ebp-070h],eax;	iLen
	jmp	@BLBL319
	align 010h
@BLBL320:

; 1235           iLen += sprintf(&szMessage[iLen],"RI->off ");
	mov	edx,offset FLAT:@STATa4
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	call	_sprintfieee
	add	eax,[ebp-070h];	iLen
	mov	[ebp-070h],eax;	iLen
@BLBL319:

; 1236       if (byChar & MDM_ST_DELTA_DCD)
	test	byte ptr [ebp-06bh],08h;	byChar
	je	@BLBL322

; 1237         if (byChar & MDM_ST_DCD)
	test	byte ptr [ebp-06bh],080h;	byChar
	je	@BLBL323

; 1238           sprintf(&szMessage[iLen],"CD->on");
	mov	edx,offset FLAT:@STATa5
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	call	_sprintfieee
	jmp	@BLBL322
	align 010h
@BLBL323:

; 1240           sprintf(&szMessage[iLen],"CD->off");
	mov	edx,offset FLAT:@STATa6
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	call	_sprintfieee
@BLBL322:

; 1241       break;
	jmp	@BLBL332
	align 04h
@BLBL361:

; 1243       iLen = sprintf(szMessage,"Modem output signals changed - ");
	mov	edx,offset FLAT:@STATa7
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee
	mov	[ebp-070h],eax;	iLen

; 1244       if (byChar & MDM_CTL_DTR_ACTIVATE)
	test	byte ptr [ebp-06bh],01h;	byChar
	je	@BLBL325

; 1245         iLen += sprintf(&szMessage[iLen],"DTR->on  ");
	mov	edx,offset FLAT:@STATa8
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	call	_sprintfieee
	add	eax,[ebp-070h];	iLen
	mov	[ebp-070h],eax;	iLen
	jmp	@BLBL326
	align 010h
@BLBL325:

; 1247         iLen += sprintf(&szMessage[iLen],"DTR->off ");
	mov	edx,offset FLAT:@STATa9
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	call	_sprintfieee
	add	eax,[ebp-070h];	iLen
	mov	[ebp-070h],eax;	iLen
@BLBL326:

; 1248       if (byChar & MDM_CTL_RTS_ACTIVATE)
	test	byte ptr [ebp-06bh],02h;	byChar
	je	@BLBL327

; 1249         sprintf(&szMessage[iLen],"RTS->on");
	mov	edx,offset FLAT:@STATaa
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	call	_sprintfieee
	jmp	@BLBL328
	align 010h
@BLBL327:

; 1251         sprintf(&szMessage[iLen],"RTS->off");
	mov	edx,offset FLAT:@STATab
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	call	_sprintfieee
@BLBL328:

; 1252       break;
	jmp	@BLBL332
	align 04h
@BLBL362:

; 1254       sprintf(szMessage,"Device driver receive buffer overflow");
	mov	edx,offset FLAT:@STATac
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 1255       break;
	jmp	@BLBL332
	align 04h
@BLBL363:

; 1257       iLen = sprintf(szMessage,"Hardware error - ");
	mov	edx,offset FLAT:@STATad
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee
	mov	[ebp-070h],eax;	iLen

; 1258       if (
; 1258 byChar & LINE_ST_PARITY_ERROR)
	test	byte ptr [ebp-06bh],04h;	byChar
	je	@BLBL329

; 1259         iLen += sprintf(&szMessage[iLen],"Parity ");
	mov	edx,offset FLAT:@STATae
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	call	_sprintfieee
	add	eax,[ebp-070h];	iLen
	mov	[ebp-070h],eax;	iLen
@BLBL329:

; 1260       if (byChar & LINE_ST_OVERRUN_ERROR)
	test	byte ptr [ebp-06bh],02h;	byChar
	je	@BLBL330

; 1261         iLen += sprintf(&szMessage[iLen],"Overrun ");
	mov	edx,offset FLAT:@STATaf
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	call	_sprintfieee
	add	eax,[ebp-070h];	iLen
	mov	[ebp-070h],eax;	iLen
@BLBL330:

; 1262       if (byChar & LINE_ST_FRAMING_ERROR)
	test	byte ptr [ebp-06bh],08h;	byChar
	je	@BLBL331

; 1263         sprintf(&szMessage[iLen]," Framing");
	mov	edx,offset FLAT:@STATb0
	mov	eax,[ebp-070h];	iLen
	lea	eax,dword ptr [ebp+eax-064h]
	call	_sprintfieee
@BLBL331:

; 1264       break;
	jmp	@BLBL332
	align 04h
@BLBL364:

; 1266       sprintf(szMessage,"Unknown key -> value is 0x%04X",pwScrollBuffer[lIndex]);
	mov	ecx,dword ptr  pwScrollBuffer
	mov	edx,[ebp-068h];	lIndex
	xor	eax,eax
	mov	ax,word ptr [ecx+edx*02h]
	push	eax
	mov	edx,offset FLAT:@STATb1
	lea	eax,[ebp-064h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1267       break;
	jmp	@BLBL332
	align 04h
	jmp	@BLBL332
	align 04h
@BLBL333:
	cmp	eax,04000h
	je	@BLBL334
	cmp	eax,04100h
	je	@BLBL335
	cmp	eax,08000h
	je	@BLBL336
	cmp	eax,08100h
	je	@BLBL337
	cmp	eax,08500h
	je	@BLBL338
	cmp	eax,04200h
	je	@BLBL350
	cmp	eax,04300h
	je	@BLBL351
	cmp	eax,08200h
	je	@BLBL352
	cmp	eax,08300h
	je	@BLBL353
	cmp	eax,08600h
	je	@BLBL354
	cmp	eax,08700h
	je	@BLBL355
	cmp	eax,08800h
	je	@BLBL356
	cmp	eax,08900h
	je	@BLBL357
	cmp	eax,08a00h
	je	@BLBL358
	cmp	eax,04700h
	je	@BLBL359
	cmp	eax,04400h
	je	@BLBL360
	cmp	eax,08400h
	je	@BLBL361
	cmp	eax,04500h
	je	@BLBL362
	cmp	eax,04600h
	je	@BLBL363
	jmp	@BLBL364
	align 04h
@BLBL332:

; 1269   ErrorNotify(szMessage);
	lea	eax,[ebp-064h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1270   }
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
DisplayCharacterInfo	endp

; 1273   {
	align 010h

	public TestOUT1
TestOUT1	proc
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

; 1275   ULONG ulDataLen = sizeof(EXTDATA);
	mov	dword ptr [ebp-04h],06h;	ulDataLen

; 1276   ULONG ulParmLen = sizeof(EXTPARM);
	mov	dword ptr [ebp-08h],08h;	ulParmLen

; 1277   EXTPARM stParams;
; 1278   EXTDATA stData;
; 1279 
; 1280   stParams.wSignature = SIGNATURE;
	mov	word ptr [ebp-010h],02642h;	stParams

; 1281   stParams.wDataCount = sizeof(USHORT);
	mov	word ptr [ebp-0ah],02h;	stParams

; 1282   stParams.wCommand = EXT_CMD_GET_CONFIG_FLAGS;
	mov	word ptr [ebp-0eh],06h;	stParams

; 1283   stParams.wModifier = 0;
	mov	word ptr [ebp-0ch],0h;	stParams

; 1284   if (DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,&stData,sizeof(EXTDATA),&ulDataLen) != NO_ERROR)
	lea	eax,[ebp-04h];	ulDataLen
	push	eax
	push	06h
	lea	eax,[ebp-016h];	stData
	push	eax
	lea	eax,[ebp-08h];	ulParmLen
	push	eax
	push	08h
	lea	eax,[ebp-010h];	stParams
	push	eax
	push	07ch
	push	01h
	push	dword ptr  hCom
	call	DosDevIOCtl
	add	esp,024h
	test	eax,eax
	je	@BLBL365

; 1285     return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL365:

; 1286   if (stData.wData & CFG_FLAG1_EXT_MODEM_CTL)
	test	byte ptr [ebp-011h],01h;	stData
	je	@BLBL366

; 1287     return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL366:

; 1288   else
; 1289     return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
TestOUT1	endp

; 1293   {
	align 010h

	public ResetHighWater
ResetHighWater	proc
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

; 1294   ULONG ulDataLen = sizeof(EXTDATA);
	mov	dword ptr [ebp-04h],06h;	ulDataLen

; 1295   ULONG ulParmLen = sizeof(EXTPARM);
	mov	dword ptr [ebp-08h],08h;	ulParmLen

; 1296   EXTPARM stParams;
; 1297   EXTDATA stData;
; 1298 
; 1299   stParams.wSignature = SIGNATURE;
	mov	word ptr [ebp-010h],02642h;	stParams

; 1300   stParams.wDataCount = 0;
	mov	word ptr [ebp-0ah],0h;	stParams

; 1301   stParams.wCommand = EXT_CMD_RESET_RX_HIGH;
	mov	word ptr [ebp-0eh],0fh;	stParams

; 1302   stParams.wModifier = 0;
	mov	word ptr [ebp-0ch],0h;	stParams

; 1303   if (DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,&stData,sizeof(EXTDATA),&ulDataLen) != NO_ERROR)
	lea	eax,[ebp-04h];	ulDataLen
	push	eax
	push	06h
	lea	eax,[ebp-016h];	stData
	push	eax
	lea	eax,[ebp-08h];	ulParmLen
	push	eax
	push	08h
	lea	eax,[ebp-010h];	stParams
	push	eax
	push	07ch
	push	01h
	push	dword ptr  hCom
	call	DosDevIOCtl
	add	esp,024h
	test	eax,eax
	je	@BLBL368

; 1304     return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL368:

; 1305   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
ResetHighWater	endp

; 1309   {
	align 010h

	public AccessCOMscope
AccessCOMscope	proc
	push	ebp
	mov	ebp,esp
	sub	esp,068h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,01ah
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 1315   ULONG ulDataLen = (ULONG)(pstDataSet->cbSize + sizeof(ULONG));
	mov	eax,[ebp+0ch];	pstDataSet
	mov	eax,[eax]
	add	eax,04h
	mov	[ebp-0ch],eax;	ulDataLen

; 1316   ULONG ulParmLen = (ULONG)(sizeof(stCOMscope));
	mov	dword ptr [ebp-010h],06h;	ulParmLen

; 1317   APIRET rc;
; 1318   char szError[81];
; 1319 
; 1320   stCOMscope.usSignature = SIGNATURE;
	mov	word ptr [ebp-06h],02642h;	stCOMscope

; 1321   stCOMscope.ulCount = pstDataSet->cbSize;
	mov	eax,[ebp+0ch];	pstDataSet
	mov	eax,[eax]
	mov	[ebp-04h],eax;	stCOMscope

; 1322   if ((rc = DosDevIOCtl(hCom,0x01,0x7d,&stCOMscope,sizeof(stCOMscope),&ulParmLen,pstDataSet,ulDataLen,&ulDataLen)) != 0)
	lea	eax,[ebp-0ch];	ulDataLen
	push	eax
	push	dword ptr [ebp-0ch];	ulDataLen
	push	dword ptr [ebp+0ch];	pstDataSet
	lea	eax,[ebp-010h];	ulParmLen
	push	eax
	push	06h
	lea	eax,[ebp-06h];	stCOMscope
	push	eax
	push	07dh
	push	01h
	push	dword ptr [ebp+08h];	hCom
	call	DosDevIOCtl
	add	esp,024h
	mov	[ebp-014h],eax;	rc
	cmp	dword ptr [ebp-014h],0h;	rc
	je	@BLBL369

; 1323     {
; 1324     sprintf(szError,"Error Reading Port - %X",rc);
	push	dword ptr [ebp-014h];	rc
	mov	edx,offset FLAT:@STATb2
	lea	eax,[ebp-065h];	szError
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1325     ErrorNotify(szError);
	lea	eax,[ebp-065h];	szError
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1326     }
@BLBL369:

; 1327   return(rc);
	mov	eax,[ebp-014h];	rc
	mov	esp,ebp
	pop	ebp
	ret	
AccessCOMscope	endp

; 1331   {
	align 010h

	public EnableCOMscope
EnableCOMscope	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0194h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,065h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 1349   bCOMscopeEnabled = FALSE;
	mov	dword ptr  bCOMscopeEnabled,0h

; 1350   ulDataLen = sizeof(stData);
	mov	dword ptr [ebp-04h],06h;	ulDataLen

; 1351   ulParmLen = sizeof(stCOMscope);
	mov	dword ptr [ebp-08h],04h;	ulParmLen

; 1352   stCOMscope.usSignature = SIGNATURE;
	mov	word ptr [ebp-018ch],02642h;	stCOMscope

; 1353   stCOMscope.fTraceEvents = fTraceEvent;
	mov	ax,[ebp+014h];	fTraceEvent
	mov	[ebp-018ah],ax;	stCOMscope

; 1354   if ((rc = DosDevIOCtl(hCom,0x01,0x7e,&stCOMscope,sizeof(stCOMscope),&ulParmLen,&stData,sizeof(stData),&ulDataLen)) != 0)
	lea	eax,[ebp-04h];	ulDataLen
	push	eax
	push	06h
	lea	eax,[ebp-0192h];	stData
	push	eax
	lea	eax,[ebp-08h];	ulParmLen
	push	eax
	push	04h
	lea	eax,[ebp-018ch];	stCOMscope
	push	eax
	push	07eh
	push	01h
	push	dword ptr [ebp+0ch];	hCom
	call	DosDevIOCtl
	add	esp,024h
	mov	[ebp-0ch],eax;	rc
	cmp	dword ptr [ebp-0ch],0h;	rc
	je	@BLBL370

; 1355     {
; 1356     sprintf(szMsgString,"DOS error enabling stream monitoring -> 0x%X",rc);
	push	dword ptr [ebp-0ch];	rc
	mov	edx,offset FLAT:@STATb3
	lea	eax,[ebp-0138h];	szMsgString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1357     ErrorNotify(szMsgString);
	lea	eax,[ebp-0138h];	szMsgString
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1358     return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL370:

; 1359     }
; 1360   *pulBuffSize = stData.wCount;
	xor	ecx,ecx
	mov	cx,[ebp-018eh];	stData
	mov	eax,[ebp+010h];	pulBuffSize
	mov	[eax],ecx

; 1361   if (!stData.bCOMscopeAvailable)
	cmp	word ptr [ebp-0190h],0h;	stData
	jne	@BLBL371

; 1362     {
; 1363     if (stData.usSignature != stCOMscope.usSignature)
	mov	ax,[ebp-018ch];	stCOMscope
	cmp	[ebp-0192h],ax;	stData
	je	@BLBL372

; 1364       {
; 1365       sprintf(szCaption,"COMscope monitoring is not supported.");
	mov	edx,offset FLAT:@STATb4
	lea	eax,[ebp-0188h];	szCaption
	call	_sprintfieee

; 1366 #ifdef DEMO
; 1367       if (stData.usSignature == GA_SIGNATURE)
; 1368         sprintf(szMsgString,"This version of COMscope is for EVALUATION ONLY, and can only monitor"
; 1369                             " a port controlled by the evaluation version of COMi (COMDDE.SYS).\n\nYou may,"
; 1370                             " however, use this version to create and/or edit an initialization file for a"
; 1371                             " fully functional version of COMi.");
; 1372 #else
; 1373       if (stData.usSignature == DEMO_SIGNATURE)
	cmp	word ptr [ebp-0192h],02641h;	stData
	jne	@BLBL373

; 1374         sprintf(szMsgString,"This version of COMscope cannot monitor a device controlled by the evaluation"
	mov	edx,offset FLAT:@STATb5
	lea	eax,[ebp-0138h];	szMsgString
	call	_sprintfieee
	jmp	@BLBL375
	align 010h
@BLBL373:

; 1375                             " version of COMi (COMDDE.SYS).\n\nYou may, however, use this version of"
; 1376                             " COMscope to create and/or edit an initialization file for the evaluation"
; 1377                             " version of COMi.");
; 1378 #endif
; 1379       else
; 1380         sprintf(szMsgString,"This version of COMscope is not compatable with the version of COMi that is"
	mov	edx,offset FLAT:@STATb6
	lea	eax,[ebp-0138h];	szMsgString
	call	_sprintfieee

; 1381                             " currently loaded.\n\nPlease contact OS/tools Incorporated for upgrade"
; 1382                             " information.\n\nSee the \"About COMscope\" dialog in the \"Help\" menu"
; 1383                             " for information on COMi and COMscope versions and how to contact OS/tools.");
; 1384       }
	jmp	@BLBL375
	align 010h
@BLBL372:

; 1385     else
; 1386       {
; 1387       sprintf(szCaption,"%s is unable to support COMscope.",stCFG.szPortName);
	push	offset FLAT:stCFG+02h
	mov	edx,offset FLAT:@STATb7
	lea	eax,[ebp-0188h];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1388       sprintf(szMsgString,"This device is not configured for COMscope.  Use Install function to enable COMscope for next OS/2 session.");
	mov	edx,offset FLAT:@STATb8
	lea	eax,[ebp-0138h];	szMsgString
	call	_sprintfieee

; 1389       }
@BLBL375:

; 1390     WinMessageBox(HWND_DESKTOP,
	push	04020h
	push	0h
	lea	eax,[ebp-0188h];	szCaption
	push	eax
	lea	eax,[ebp-0138h];	szMsgString
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h

; 1391                   hwnd,
; 1392                   szMsgString,
; 1393                   szCaption,
; 1394             (LONG)NULL,
; 1395                   MB_MOVEABLE | MB_OK | MB_CUAWARNING);
; 1396     return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL371:

; 1397     }
; 1398   if (fTraceEvent != 0)
	cmp	word ptr [ebp+014h],0h;	fTraceEvent
	je	@BLBL376

; 1399     bCOMscopeEnabled = TRUE;
	mov	dword ptr  bCOMscopeEnabled,01h
@BLBL376:

; 1400   return(TRUE);
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
EnableCOMscope	endp
CODE32	ends
end
