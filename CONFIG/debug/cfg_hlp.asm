	title	p:\config\cfg_hlp.c
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
	extrn	_dllentry:proc
	extrn	MessageBox:proc
	extrn	WinSendMsg:proc
	extrn	_sprintfieee:proc
	extrn	PrfQueryProfileString:proc
	extrn	WinCreateHelpInstance:proc
	extrn	WinQueryActiveWindow:proc
	extrn	WinQueryWindow:proc
	extrn	WinCreateStdWindow:proc
	extrn	WinQueryAnchorBlock:proc
	extrn	WinGetLastError:proc
	extrn	WinAssociateHelpInstance:proc
	extrn	WinSetHook:proc
	extrn	WinReleaseHook:proc
	extrn	WinDestroyHelpInstance:proc
	extrn	WinDestroyWindow:proc
	extrn	_fullDump:dword
	extrn	bNoDEBUGhelp:dword
DATA32	segment
@STAT1	db "Help is disabled for deb"
db "ugging",0h
	align 04h
@STAT2	db "Unable to display Help P"
db "anel #%u",0h
	align 04h
@STAT3	db "Help is not Initialized",0h
@STAT4	db "COMi_CFG Message Box Hoo"
db "k Entered",0h
	align 04h
@STAT5	db "Device Driver Configurat"
db "ion Help",0h
	align 04h
@STAT6	db "COMi",0h
	align 04h
@STAT7	db "Help",0h
	align 04h
@STAT8	db "Unable to get Help File "
db "name from the user Initi"
db "alization file.",0h
@STAT9	db "Error Creating Frame Win"
db "dow.",0ah,0ah,"%08X",0h
	align 04h
@STATa	db "Frame Created",0h
	align 04h
@STATb	db "Unable to associate help"
db " instance with file %s -"
db " %u",0h
@STATc	db "Unable to load help file"
db " %s",0h
@STATd	db "Frame Destoyed",0h
	dd	_dllentry
DATA32	ends
BSS32	segment
@2bFrameCreated	dd 0h
@16hwndHelpInstance	dd 0h
@20hwndSaveHelp	dd 0h
BSS32	ends
CODE32	segment

; 31   {
	align 010h

	public DisplayHelpPanel
DisplayHelpPanel	proc
	push	ebp
	mov	ebp,esp
	sub	esp,064h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,019h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 34   if (bNoDEBUGhelp)
	cmp	dword ptr  bNoDEBUGhelp,0h
	je	@BLBL1

; 35     {
; 36     MessageBox(HWND_DESKTOP,"Help is disabled for debugging");
	push	offset FLAT:@STAT1
	push	01h
	call	MessageBox
	add	esp,08h

; 37     return;
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL1:

; 38     }
; 39 #endif
; 40   if (pstCOMiCFG->hwndHelpInstance != 0)
	mov	eax,[ebp+08h];	pstCOMiCFG
	cmp	dword ptr [eax+0ah],0h
	je	@BLBL2

; 41     {
; 42     if (WinSendMsg(pstCOMiCFG->hwndHelpInstance,HM_DISPLAY_HELP,
	push	0h
	xor	eax,eax
	mov	ax,[ebp+0ch];	idPanel
	push	eax
	push	0222h
	mov	eax,[ebp+08h];	pstCOMiCFG
	push	dword ptr [eax+0ah]
	call	WinSendMsg
	add	esp,010h
	test	eax,eax
	je	@BLBL4

; 43                    MPFROM2SHORT(idPanel,NULL),MPFROMSHORT(HM_RESOURCEID)))
; 44        {
; 45        sprintf(szMessage,"Unable to display Help Panel #%u",idPanel);
	xor	eax,eax
	mov	ax,[ebp+0ch];	idPanel
	push	eax
	mov	edx,offset FLAT:@STAT2
	lea	eax,[ebp-064h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 46        MessageBox(HWND_DESKTOP,szMessage);
	lea	eax,[ebp-064h];	szMessage
	push	eax
	push	01h
	call	MessageBox
	add	esp,08h

; 47        }

; 48     }
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL2:

; 49   else
; 50     MessageBox(HWND_DESKTOP,"Help is not Initialized");
	push	offset FLAT:@STAT3
	push	01h
	call	MessageBox
	add	esp,08h
@BLBL4:

; 51   }
	mov	esp,ebp
	pop	ebp
	ret	
DisplayHelpPanel	endp

; 55   {
	align 010h

	public pfnMessageBoxHelpHook
pfnMessageBoxHelpHook	proc
	push	ebp
	mov	ebp,esp
	sub	esp,050h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,014h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 59   MessageBox(HWND_DESKTOP,"COMi_CFG Message Box Hook Entered");
	push	offset FLAT:@STAT4
	push	01h
	call	MessageBox
	add	esp,08h

; 60 #endif
; 61   if (sMode == HLPM_WINDOW)
	xor	eax,eax
	mov	ax,[ebp+0ch];	sMode
	cmp	eax,0fffffffeh
	jne	@BLBL5

; 62     {
; 63     stCOMiCFG.hwndHelpInstance = hwndHelpInstance;
	mov	eax,dword ptr  @16hwndHelpInstance
	mov	[ebp-043h],eax;	stCOMiCFG

; 64     DisplayHelpPanel(&stCOMiCFG,sTopic);
	mov	ax,[ebp+010h];	sTopic
	push	eax
	lea	eax,[ebp-04dh];	stCOMiCFG
	push	eax
	call	DisplayHelpPanel
	add	esp,08h

; 65     return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL5:

; 66     }
; 67   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
pfnMessageBoxHelpHook	endp

; 71   {
	align 010h

	public HelpInit
HelpInit	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0204h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,081h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 80   if (bNoDEBUGhelp)
	cmp	dword ptr  bNoDEBUGhelp,0h
	je	@BLBL6

; 81     return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL6:

; 82 #endif
; 83   hwndSaveHelp = pstCOMiCFG->hwndHelpInstance;
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	eax,[eax+0ah]
	mov	dword ptr  @20hwndSaveHelp,eax

; 84   pstCOMiCFG->hwndHelpInstance = 0;
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	dword ptr [eax+0ah],0h

; 85   // if we return because of an error, Help will be disabled
; 86 //  fHelpEnabled = FALSE;
; 87   // inititalize help init structure
; 88   hini.cb = sizeof(HELPINIT);
	mov	dword ptr [ebp-0f4h],02ch;	hini

; 89   hini.ulReturnCode = 0L;
	mov	dword ptr [ebp-0f0h],0h;	hini

; 90   hini.pszTutorialName = (PSZ)NULL;   // if tutorial added, add name here
	mov	dword ptr [ebp-0ech],0h;	hini

; 91 
; 92   hini.phtHelpTable = 0;//(PHELPTABLE)MAKELONG(COMSCOPE_HELP_TABLE, 0xFFFF);
	mov	dword ptr [ebp-0e8h],0h;	hini

; 93   hini.hmodHelpTableModule = (HMODULE)0;
	mov	dword ptr [ebp-0e4h],0h;	hini

; 94   hini.hmodAccelActionBarModule = (HMODULE)0;
	mov	dword ptr [ebp-0e0h],0h;	hini

; 95   hini.idAccelTable = 0;
	mov	dword ptr [ebp-0dch],0h;	hini

; 96   hini.idActionBar = 0;
	mov	dword ptr [ebp-0d8h],0h;	hini

; 97   hini.pszHelpWindowTitle = "Device Driver Configuration Help";
	mov	dword ptr [ebp-0d4h],offset FLAT:@STAT5;	hini

; 98 
; 99   // if debugging, show panel ids, else don't
; 100 #if DEBUG > 0
; 101   hini.fShowPanelId = CMIC_SHOW_PANEL_ID;
	mov	dword ptr [ebp-0d0h],01h;	hini

; 102 #else
; 103   hini.fShowPanelId = CMIC_HIDE_PANEL_ID;
; 104 #endif
; 105   if (PrfQueryProfileString(HINI_USERPROFILE,"COMi","Help",NULL,(PSZ)szLibraryName,CCHMAXPATH) == 0)
	push	0104h
	lea	eax,[ebp-01f8h];	szLibraryName
	push	eax
	push	0h
	push	offset FLAT:@STAT7
	push	offset FLAT:@STAT6
	push	0ffffffffh
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	jne	@BLBL7

; 106     {
; 107     sprintf(szMessage,"Unable to get Help File name from the user Initialization file.");
	mov	edx,offset FLAT:@STAT8
	lea	eax,[ebp-0c8h];	szMessage
	call	_sprintfieee

; 108     MessageBox(HWND_DESKTOP,szMessage);
	lea	eax,[ebp-0c8h];	szMessage
	push	eax
	push	01h
	call	MessageBox
	add	esp,08h

; 109     pstCOMiCFG->hwndHelpInstance = hwndSaveHelp;
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	ecx,dword ptr  @20hwndSaveHelp
	mov	[eax+0ah],ecx

; 110     return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL7:

; 111     }
; 112 
; 113   hini.pszHelpLibraryName = szLibraryName;
	lea	eax,[ebp-01f8h];	szLibraryName
	mov	[ebp-0cch],eax;	hini

; 114 
; 115   // creating help instance
; 116   hwndHelpInstance = WinCreateHelpInstance(pstCOMiCFG->hab,&hini);
	lea	eax,[ebp-0f4h];	hini
	push	eax
	mov	eax,[ebp+08h];	pstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinCreateHelpInstance
	add	esp,08h
	mov	dword ptr  @16hwndHelpInstance,eax

; 117 
; 118   if((hwndHelpInstance != 0)  && (hini.ulReturnCode == 0))
	cmp	dword ptr  @16hwndHelpInstance,0h
	je	@BLBL8
	cmp	dword ptr [ebp-0f0h],0h;	hini
	jne	@BLBL8

; 119     {
; 120     if (pstCOMiCFG->hwndFrame == 0)
	mov	eax,[ebp+08h];	pstCOMiCFG
	cmp	dword ptr [eax+06h],0h
	jne	@BLBL9

; 121       {
; 122       hwndActive = WinQueryActiveWindow(HWND_DESKTOP);
	push	01h
	call	WinQueryActiveWindow
	add	esp,04h
	mov	[ebp-01fch],eax;	hwndActive

; 123       pstCOMiCFG->hwndFrame = WinQueryWindow(hwndActive,QW_OWNER);
	push	04h
	push	dword ptr [ebp-01fch];	hwndActive
	call	WinQueryWindow
	mov	ecx,eax
	add	esp,08h
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	[eax+06h],ecx

; 124       }
@BLBL9:

; 125     if (pstCOMiCFG->hwndFrame == (HWND)NULL)
	mov	eax,[ebp+08h];	pstCOMiCFG
	cmp	dword ptr [eax+06h],0h
	jne	@BLBL10

; 126       {
; 127       /*
; 128       **  Help won't associate if there is no frame window in the chain
; 129       **
; 130       **  IF there is no parent window handle then we create a frame window
; 131       **  for the help association.
; 132       */
; 133       if (!bFrameCreated)
	cmp	dword ptr  @2bFrameCreated,0h
	jne	@BLBL10

; 134         {
; 135         flCreate =  FCF_SHELLPOSITION;
	mov	dword ptr [ebp-0200h],0400h;	flCreate

; 136         pstCOMiCFG->hwndFrame = WinCreateStdWindow(HWND_DESKTOP,0L,&flCreate,0L,0L,0L,0L,1,0L);
	push	0h
	push	01h
	push	0h
	push	0h
	push	0h
	push	0h
	lea	eax,[ebp-0200h];	flCreate
	push	eax
	push	0h
	push	01h
	call	WinCreateStdWindow
	mov	ecx,eax
	add	esp,024h
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	[eax+06h],ecx

; 137     #if DEBUG > 0
; 138         if (pstCOMiCFG->hwndFrame == 0)
	mov	eax,[ebp+08h];	pstCOMiCFG
	cmp	dword ptr [eax+06h],0h
	jne	@BLBL12

; 139           {
; 140           eidError = WinGetLastError(WinQueryAnchorBlock(hwndActive));
	push	dword ptr [ebp-01fch];	hwndActive
	call	WinQueryAnchorBlock
	add	esp,04h
	push	eax
	call	WinGetLastError
	add	esp,04h
	mov	[ebp-0204h],eax;	eidError

; 141           sprintf(szMessage,"Error Creating Frame Window.\n\n%08X",eidError);
	push	dword ptr [ebp-0204h];	eidError
	mov	edx,offset FLAT:@STAT9
	lea	eax,[ebp-0c8h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 142           MessageBox(HWND_DESKTOP,szMessage);
	lea	eax,[ebp-0c8h];	szMessage
	push	eax
	push	01h
	call	MessageBox
	add	esp,08h

; 143           }
	jmp	@BLBL13
	align 010h
@BLBL12:

; 144         else
; 145           MessageBox(HWND_DESKTOP,"Frame Created");
	push	offset FLAT:@STATa
	push	01h
	call	MessageBox
	add	esp,08h
@BLBL13:

; 146     #endif
; 147         bFrameCreated = TRUE;
	mov	dword ptr  @2bFrameCreated,01h

; 148         }

; 149       }
@BLBL10:

; 150     // associate help instance with main frame
; 151     if(!WinAssociateHelpInstance(hwndHelpInstance,pstCOMiCFG->hwndFrame))
	mov	eax,[ebp+08h];	pstCOMiCFG
	push	dword ptr [eax+06h]
	push	dword ptr  @16hwndHelpInstance
	call	WinAssociateHelpInstance
	add	esp,08h
	test	eax,eax
	jne	@BLBL15

; 152       {
; 153       sprintf(szMessage,"Unable to associate help instance with file %s - %u",szLibraryName,pstCOMiCFG->hwndFrame);
	mov	eax,[ebp+08h];	pstCOMiCFG
	push	dword ptr [eax+06h]
	lea	eax,[ebp-01f8h];	szLibraryName
	push	eax
	mov	edx,offset FLAT:@STATb
	lea	eax,[ebp-0c8h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 154       MessageBox(HWND_DESKTOP,szMessage);
	lea	eax,[ebp-0c8h];	szMessage
	push	eax
	push	01h
	call	MessageBox
	add	esp,08h

; 155       return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL8:

; 156       }
; 157     }
; 158   else
; 159     {
; 160     sprintf(szMessage,"Unable to load help file %s",szLibraryName);
	lea	eax,[ebp-01f8h];	szLibraryName
	push	eax
	mov	edx,offset FLAT:@STATc
	lea	eax,[ebp-0c8h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 161     pstCOMiCFG->hwndHelpInstance = 0;
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	dword ptr [eax+0ah],0h

; 162     MessageBox(HWND_DESKTOP,szMessage);
	lea	eax,[ebp-0c8h];	szMessage
	push	eax
	push	01h
	call	MessageBox
	add	esp,08h

; 163     return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL15:

; 164     }
; 165   /*
; 166   ** help manager is successfully initialized so set flag to TRUE
; 167   */
; 168 //  fHelpEnabled = TRUE;
; 169   pstCOMiCFG->hwndHelpInstance = hwndHelpInstance;
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	ecx,dword ptr  @16hwndHelpInstance
	mov	[eax+0ah],ecx

; 170   WinSetHook(pstCOMiCFG->hab,HMQ_CURRENT,HK_HELP,(PFN)pfnMessageBoxHelpHook,0L);
	push	0h
	push	offset FLAT: pfnMessageBoxHelpHook
	push	05h
	push	01h
	mov	eax,[ebp+08h];	pstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinSetHook
	add	esp,014h

; 171   return(TRUE);
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
HelpInit	endp

; 175   {
	align 010h

	public DestroyHelpInstance
DestroyHelpInstance	proc
	push	ebp
	mov	ebp,esp

; 177   if (bNoDEBUGhelp)
	cmp	dword ptr  bNoDEBUGhelp,0h
	je	@BLBL16

; 178     return;
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL16:

; 179 #endif
; 180   WinReleaseHook(pstCOMiCFG->hab,HMQ_CURRENT,HK_HELP,(PFN)pfnMessageBoxHelpHook,0L);
	push	0h
	push	offset FLAT: pfnMessageBoxHelpHook
	push	05h
	push	01h
	mov	eax,[ebp+08h];	pstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinReleaseHook
	add	esp,014h

; 181   if(pstCOMiCFG->hwndHelpInstance)
	mov	eax,[ebp+08h];	pstCOMiCFG
	cmp	dword ptr [eax+0ah],0h
	je	@BLBL17

; 182     WinDestroyHelpInstance(pstCOMiCFG->hwndHelpInstance);
	mov	eax,[ebp+08h];	pstCOMiCFG
	push	dword ptr [eax+0ah]
	call	WinDestroyHelpInstance
	add	esp,04h
@BLBL17:

; 183   if (bFrameCreated)
	cmp	dword ptr  @2bFrameCreated,0h
	je	@BLBL18

; 184     {
; 185     WinDestroyWindow(pstCOMiCFG->hwndFrame);
	mov	eax,[ebp+08h];	pstCOMiCFG
	push	dword ptr [eax+06h]
	call	WinDestroyWindow
	add	esp,04h

; 186 #if DEBUG > 0
; 187     MessageBox(HWND_DESKTOP,"Frame Destoyed");
	push	offset FLAT:@STATd
	push	01h
	call	MessageBox
	add	esp,08h

; 188 #endif
; 189     bFrameCreated = FALSE;
	mov	dword ptr  @2bFrameCreated,0h

; 190     }
@BLBL18:

; 191   pstCOMiCFG->hwndHelpInstance = hwndSaveHelp;
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	ecx,dword ptr  @20hwndSaveHelp
	mov	[eax+0ah],ecx

; 192   }
	mov	esp,ebp
	pop	ebp
	ret	
DestroyHelpInstance	endp
CODE32	ends
end
