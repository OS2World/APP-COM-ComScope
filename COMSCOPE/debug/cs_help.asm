	title	p:\COMscope\cs_help.c
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
	extrn	WinCreateHelpInstance:proc
	extrn	WinAssociateHelpInstance:proc
	extrn	_sprintfieee:proc
	extrn	MessageBox:proc
	extrn	WinSetHook:proc
	extrn	WinSendMsg:proc
	extrn	WinDlgBox:proc
	extrn	WinReleaseHook:proc
	extrn	WinDestroyHelpInstance:proc
	extrn	CenterDlgBox:proc
	extrn	DosLoadModule:proc
	extrn	DosQueryProcAddr:proc
	extrn	WinSetDlgItemText:proc
	extrn	DosFreeModule:proc
	extrn	WinDismissDlg:proc
	extrn	WinDefDlgProc:proc
	extrn	WinDefFileDlgProc:proc
	extrn	_fullDump:dword
	extrn	habAnchorBlock:dword
	extrn	hwndFrame:dword
	extrn	stCOMiCFG:byte
	extrn	stComCtl:byte
	extrn	szCOMscopeVersion:byte
DATA32	segment
@STAT1	db "Unable to associate help"
db " instance with file %s -"
db " %u",0h
@STAT2	db "Unable to load help file"
db " %s",0h
@STAT3	db "Unable to display Help P"
db "anel",0h
	align 04h
@STAT4	db "Unable to display Help P"
db "anel",0h
	align 04h
@STAT5	db "Unable to display Help P"
db "anel",0h
	align 04h
@STAT6	db "Unable to display Help P"
db "anel",0h
	align 04h
@STAT7	db "Unable to display Help P"
db "anel",0h
	align 04h
@STAT8	db "CFG_DEB",0h
@STAT9	db "GetDriverVersion",0h
	align 04h
@STATa	db "COMi %s",0h
@STATb	db "COMi %s",0h
@STATc	db "CSBETA Help Hook entered"
db 0h
@2szWindowTitle	db "COMscope Help",0h
DATA32	ends
BSS32	segment
@5fHelpEnabled	dd 0h
comm	szDriverVersionString:byte:064h
	align 04h
comm	hwndHelpInstance:dword
BSS32	ends
CODE32	segment

; 87   {
	align 010h

	public HelpInit
HelpInit	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0f4h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,03dh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 92   fHelpEnabled = FALSE;
	mov	dword ptr  @5fHelpEnabled,0h

; 93   // inititalize help init structure
; 94   hini.cb = sizeof(HELPINIT);
	mov	dword ptr [ebp-0f4h],02ch;	hini

; 95   hini.ulReturnCode = 0L;
	mov	dword ptr [ebp-0f0h],0h;	hini

; 96   hini.pszTutorialName = (PSZ)NULL;   // if tutorial added, add name here
	mov	dword ptr [ebp-0ech],0h;	hini

; 97 
; 98   hini.phtHelpTable = (PHELPTABLE)MAKELONG(COMSCOPE_HELP_TABLE, 0xFFFF);
	mov	dword ptr [ebp-0e8h],0ffff7530h;	hini

; 99   hini.hmodHelpTableModule = (HMODULE)0;
	mov	dword ptr [ebp-0e4h],0h;	hini

; 100   hini.hmodAccelActionBarModule = (HMODULE)0;
	mov	dword ptr [ebp-0e0h],0h;	hini

; 101   hini.idAccelTable = 0;
	mov	dword ptr [ebp-0dch],0h;	hini

; 102   hini.idActionBar = 0;
	mov	dword ptr [ebp-0d8h],0h;	hini

; 103   hini.pszHelpWindowTitle = (PSZ)szWindowTitle;
	mov	dword ptr [ebp-0d4h],offset FLAT:@2szWindowTitle;	hini

; 104 
; 105   // if debugging, show panel ids, else don't
; 106 #ifdef DEBUG
; 107   hini.fShowPanelId = CMIC_SHOW_PANEL_ID;
	mov	dword ptr [ebp-0d0h],01h;	hini

; 108 #else
; 109   hini.fShowPanelId = CMIC_HIDE_PANEL_ID;
; 110 #endif
; 111   hini.pszHelpLibraryName = (PSZ)szLibName;
	mov	eax,[ebp+08h];	szLibName
	mov	[ebp-0cch],eax;	hini

; 112 
; 113   // creating help instance
; 114   hwndHelpInstance = WinCreateHelpInstance(habAnchorBlock,&hini);
	lea	eax,[ebp-0f4h];	hini
	push	eax
	push	dword ptr  habAnchorBlock
	call	WinCreateHelpInstance
	add	esp,08h
	mov	dword ptr  hwndHelpInstance,eax

; 115 
; 116   if((hwndHelpInstance != 0)  && (hini.ulReturnCode == 0))
	cmp	dword ptr  hwndHelpInstance,0h
	je	@BLBL1
	cmp	dword ptr [ebp-0f0h],0h;	hini
	jne	@BLBL1

; 117     {
; 118     // associate help instance with main frame
; 119     if(!WinAssociateHelpInstance(hwndHelpInstance, hwndFrame))
	push	dword ptr  hwndFrame
	push	dword ptr  hwndHelpInstance
	call	WinAssociateHelpInstance
	add	esp,08h
	test	eax,eax
	jne	@BLBL3

; 120       {
; 121       sprintf(szMessage,"Unable to associate help instance with file %s - %u",szLibName,hwndFrame);
	push	dword ptr  hwndFrame
	push	dword ptr [ebp+08h];	szLibName
	mov	edx,offset FLAT:@STAT1
	lea	eax,[ebp-0c8h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 122       MessageBox(hwndFrame,szMessage);
	lea	eax,[ebp-0c8h];	szMessage
	push	eax
	push	dword ptr  hwndFrame
	call	MessageBox
	add	esp,08h

; 123       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL1:

; 124       }
; 125     }
; 126   else
; 127     {
; 128     sprintf(szMessage,"Unable to load help file %s",szLibName);
	push	dword ptr [ebp+08h];	szLibName
	mov	edx,offset FLAT:@STAT2
	lea	eax,[ebp-0c8h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 129     stCOMiCFG.hwndHelpInstance = 0;
	mov	dword ptr  stCOMiCFG+0ah,0h

; 130     MessageBox(hwndFrame,szMessage);
	lea	eax,[ebp-0c8h];	szMessage
	push	eax
	push	dword ptr  hwndFrame
	call	MessageBox
	add	esp,08h

; 131     return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL3:

; 132     }
; 133   /*
; 134   ** help manager is successfully initialized so set flag to TRUE
; 135   */
; 136   fHelpEnabled = TRUE;
	mov	dword ptr  @5fHelpEnabled,01h

; 137   stCOMiCFG.hwndHelpInstance = hwndHelpInstance;
	mov	eax,dword ptr  hwndHelpInstance
	mov	dword ptr  stCOMiCFG+0ah,eax

; 138   stComCtl.hwndHelpInstance = hwndHelpInstance;
	mov	eax,dword ptr  hwndHelpInstance
	mov	dword ptr  stComCtl+0ah,eax

; 139   WinSetHook(habAnchorBlock,HMQ_CURRENT,HK_HELP,(PFN)pfnMessageBoxHelpHook,0L);
	push	0h
	push	offset FLAT: pfnMessageBoxHelpHook
	push	05h
	push	01h
	push	dword ptr  habAnchorBlock
	call	WinSetHook
	add	esp,014h

; 140   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
HelpInit	endp

; 163   {
	align 010h

	public HelpHelpForHelp
HelpHelpForHelp	proc
	push	ebp
	mov	ebp,esp

; 168   if(fHelpEnabled)
	cmp	dword ptr  @5fHelpEnabled,0h
	je	@BLBL4

; 169     if(WinSendMsg(hwndHelpInstance, HM_DISPLAY_HELP, NULL, NULL))
	push	0h
	push	0h
	push	0222h
	push	dword ptr  hwndHelpInstance
	call	WinSendMsg
	add	esp,010h
	test	eax,eax
	je	@BLBL4

; 170        MessageBox(hwndFrame,"Unable to display Help Panel");
	push	offset FLAT:@STAT3
	push	dword ptr  hwndFrame
	call	MessageBox
	add	esp,08h
@BLBL4:

; 171 }
	mov	esp,ebp
	pop	ebp
	ret	
HelpHelpForHelp	endp

; 194   {
	align 010h

	public HelpExtended
HelpExtended	proc
	push	ebp
	mov	ebp,esp

; 199   if(fHelpEnabled)
	cmp	dword ptr  @5fHelpEnabled,0h
	je	@BLBL6

; 200 
; 201 /*
; 202     if (WinSendMsg(hwndHelpInstance,PANEL_EXTENDED_CONTENTS,
; 203                  MPFROMSHORT(PANEL_EXTENDED_CONTENTS), NULL))
; 204        MessageBox(hwndFrame,
; 205              IDS_HELPDISPLAYERROR,
; 206              MB_OK | MB_ERROR,
; 207              FALSE);
; 208 */
; 209     if(WinSendMsg(hwndHelpInstance, HM_EXT_HELP, NULL, NULL))
	push	0h
	push	0h
	push	0223h
	push	dword ptr  hwndHelpInstance
	call	WinSendMsg
	add	esp,010h
	test	eax,eax
	je	@BLBL6

; 210        MessageBox(hwndFrame,"Unable to display Help Panel");
	push	offset FLAT:@STAT4
	push	dword ptr  hwndFrame
	call	MessageBox
	add	esp,08h
@BLBL6:

; 211   }
	mov	esp,ebp
	pop	ebp
	ret	
HelpExtended	endp

; 233   {
	align 010h

	public HelpKeys
HelpKeys	proc
	push	ebp
	mov	ebp,esp

; 237   if(fHelpEnabled)
	cmp	dword ptr  @5fHelpEnabled,0h
	je	@BLBL8

; 238     if(WinSendMsg(hwndHelpInstance, HM_KEYS_HELP, MPFROMSHORT(HM_KEYS_HELP), NULL))
	push	0h
	push	022ch
	push	022ch
	push	dword ptr  hwndHelpInstance
	call	WinSendMsg
	add	esp,010h
	test	eax,eax
	je	@BLBL8

; 239        MessageBox(hwndFrame,"Unable to display Help Panel");
	push	offset FLAT:@STAT5
	push	dword ptr  hwndFrame
	call	MessageBox
	add	esp,08h
@BLBL8:

; 240   }
	mov	esp,ebp
	pop	ebp
	ret	
HelpKeys	endp

; 263   {
	align 010h

	public HelpIndex
HelpIndex	proc
	push	ebp
	mov	ebp,esp

; 268   if(fHelpEnabled)
	cmp	dword ptr  @5fHelpEnabled,0h
	je	@BLBL10

; 269     if(WinSendMsg(hwndHelpInstance, HM_HELP_INDEX, NULL, NULL))
	push	0h
	push	0h
	push	022ah
	push	dword ptr  hwndHelpInstance
	call	WinSendMsg
	add	esp,010h
	test	eax,eax
	je	@BLBL10

; 270        MessageBox(hwndFrame,"Unable to display Help Panel");
	push	offset FLAT:@STAT6
	push	dword ptr  hwndFrame
	call	MessageBox
	add	esp,08h
@BLBL10:

; 271   }
	mov	esp,ebp
	pop	ebp
	ret	
HelpIndex	endp

; 291   {
	align 010h

	public HelpAbout
HelpAbout	proc
	push	ebp
	mov	ebp,esp

; 295   WinDlgBox(HWND_DESKTOP,
	push	0h
	push	0baeh
	push	0h
	push	offset FLAT: AboutBoxDlgProc
	push	dword ptr  hwndFrame
	push	01h
	call	WinDlgBox
	add	esp,018h

; 296          hwndFrame,
; 297          (PFNWP)AboutBoxDlgProc,
; 298          (HMODULE)0,
; 299          DLG_ABOUTBOX,
; 300          (PVOID)NULL);
; 301   }
	mov	esp,ebp
	pop	ebp
	ret	
HelpAbout	endp

; 322   {
	align 010h

	public DisplayHelpPanel
DisplayHelpPanel	proc
	push	ebp
	mov	ebp,esp

; 323   if (fHelpEnabled)
	cmp	dword ptr  @5fHelpEnabled,0h
	je	@BLBL12

; 324     if (WinSendMsg(hwndHelpInstance, HM_DISPLAY_HELP,
	push	0h
	xor	eax,eax
	mov	ax,[ebp+08h];	idPanel
	push	eax
	push	0222h
	push	dword ptr  hwndHelpInstance
	call	WinSendMsg
	add	esp,010h
	test	eax,eax
	je	@BLBL12

; 325                    MPFROM2SHORT(idPanel, NULL), MPFROMSHORT(HM_RESOURCEID)))
; 326        MessageBox(hwndFrame,"Unable to display Help Panel");
	push	offset FLAT:@STAT7
	push	dword ptr  hwndFrame
	call	MessageBox
	add	esp,08h
@BLBL12:

; 327   }
	mov	esp,ebp
	pop	ebp
	ret	
DisplayHelpPanel	endp

; 346   {
	align 010h

	public DestroyHelpInstance
DestroyHelpInstance	proc
	push	ebp
	mov	ebp,esp

; 347   WinReleaseHook(habAnchorBlock,HMQ_CURRENT,HK_HELP,(PFN)pfnMessageBoxHelpHook,0L);
	push	0h
	push	offset FLAT: pfnMessageBoxHelpHook
	push	05h
	push	01h
	push	dword ptr  habAnchorBlock
	call	WinReleaseHook
	add	esp,014h

; 348   if(hwndHelpInstance)
	cmp	dword ptr  hwndHelpInstance,0h
	je	@BLBL14

; 349     WinDestroyHelpInstance(hwndHelpInstance);
	push	dword ptr  hwndHelpInstance
	call	WinDestroyHelpInstance
	add	esp,04h
@BLBL14:

; 350   stCOMiCFG.hwndHelpInstance = 0;
	mov	dword ptr  stCOMiCFG+0ah,0h

; 351   }
	mov	esp,ebp
	pop	ebp
	ret	
DestroyHelpInstance	endp

; 373   {
	align 010h

	public AboutBoxDlgProc
AboutBoxDlgProc	proc
	push	ebp
	mov	ebp,esp
	sub	esp,05ch
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,017h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 379   switch(msg)
	mov	eax,[ebp+0ch];	msg
	jmp	@BLBL21
	align 04h
@BLBL22:

; 380     {
; 381     case WM_INITDLG:
; 382       CenterDlgBox(hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	call	CenterDlgBox
	add	esp,04h

; 383       if (szDriverVersionString[0] == 0)
	cmp	byte ptr  szDriverVersionString,0h
	jne	@BLBL15

; 384         {
; 385         if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-05ch];	hMod
	push	eax
	push	offset FLAT:@STAT8
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL19

; 386           {
; 387           stCOMiCFG.pszPortName = NULL;
	mov	dword ptr  stCOMiCFG+014h,0h

; 388           if (DosQueryProcAddr(hMod,0,"GetDriverVersion",&pfnFunction) == NO_ERROR)
	lea	eax,[ebp-054h];	pfnFunction
	push	eax
	push	offset FLAT:@STAT9
	push	0h
	push	dword ptr [ebp-05ch];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL17

; 389             if (pfnFunction(szDriverVersionString,&ulSignature))
	lea	eax,[ebp-058h];	ulSignature
	push	eax
	push	offset FLAT:szDriverVersionString
	call	dword ptr [ebp-054h];	pfnFunction
	add	esp,08h
	test	eax,eax
	je	@BLBL17

; 390               {
; 391               sprintf(szString,"COMi %s",szDriverVersionString);
	push	offset FLAT:szDriverVersionString
	mov	edx,offset FLAT:@STATa
	lea	eax,[ebp-050h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 392               WinSetDlgItemText(hwndDlg,COMI_VERSION,szString);
	lea	eax,[ebp-050h];	szString
	push	eax
	push	01902h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 393               }
@BLBL17:

; 394           DosFreeModule(hMod);
	push	dword ptr [ebp-05ch];	hMod
	call	DosFreeModule
	add	esp,04h

; 395           }

; 396         }
	jmp	@BLBL19
	align 010h
@BLBL15:

; 397       else
; 398         {
; 399         sprintf(szString,"COMi %s",szDriverVersionString);
	push	offset FLAT:szDriverVersionString
	mov	edx,offset FLAT:@STATb
	lea	eax,[ebp-050h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 400         WinSetDlgItemText(hwndDlg,COMI_VERSION,szString);
	lea	eax,[ebp-050h];	szString
	push	eax
	push	01902h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 401         }
@BLBL19:

; 402       WinSetDlgItemText(hwndDlg,COMSCOPE_VERSION,szCOMscopeVersion);
	push	offset FLAT:szCOMscopeVersion
	push	01004h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 403       break;
	jmp	@BLBL20
	align 04h
@BLBL23:

; 404     case WM_COMMAND:
; 405       WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 406       break;
	jmp	@BLBL20
	align 04h
@BLBL24:

; 407     default:
; 408       return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	push	dword ptr [ebp+0ch];	msg
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDefDlgProc
	add	esp,010h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL20
	align 04h
@BLBL21:
	cmp	eax,03bh
	je	@BLBL22
	cmp	eax,020h
	je	@BLBL23
	jmp	@BLBL24
	align 04h
@BLBL20:

; 409     }
; 410   return 0L;
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
AboutBoxDlgProc	endp

; 418   {
	align 010h

	public COMscopeOpenFilterProc
COMscopeOpenFilterProc	proc
	push	ebp
	mov	ebp,esp

; 419   if(message == WM_HELP)
	cmp	dword ptr [ebp+0ch],022h;	message
	jne	@BLBL25

; 420     {
; 421     DisplayHelpPanel(HLPP_FILE_OPEN);
	push	07545h
	call	DisplayHelpPanel
	add	esp,04h

; 422     return FALSE ;
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL25:

; 423     }
; 424   return WinDefFileDlgProc(hwnd,message,mp1,mp2);
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	push	dword ptr [ebp+0ch];	message
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefFileDlgProc
	add	esp,010h
	mov	esp,ebp
	pop	ebp
	ret	
COMscopeOpenFilterProc	endp

; 516   {
	align 010h

	public pfnMessageBoxHelpHook
pfnMessageBoxHelpHook	proc
	push	ebp
	mov	ebp,esp

; 518   MessageBox(HWND_DESKTOP,"CSBETA Help Hook entered");
	push	offset FLAT:@STATc
	push	01h
	call	MessageBox
	add	esp,08h

; 519 #endif
; 520   if (sMode == HLPM_WINDOW)
	cmp	word ptr [ebp+0ch],0fffeh;	sMode
	jne	@BLBL26

; 521     {
; 522     DisplayHelpPanel(sTopic);
	mov	ax,[ebp+010h];	sTopic
	push	eax
	call	DisplayHelpPanel
	add	esp,04h

; 523     return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL26:

; 524     }
; 525   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
pfnMessageBoxHelpHook	endp
CODE32	ends
end
