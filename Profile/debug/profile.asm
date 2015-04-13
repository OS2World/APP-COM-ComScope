	title	p:\profile\profile.c
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
	public	bDLLinUse
	extrn	_dllentry:proc
	extrn	CenterDlgBox:proc
	extrn	WinSetFocus:proc
	extrn	PrfOpenProfile:proc
	extrn	WinDismissDlg:proc
	extrn	_debug_malloc:proc
	extrn	PrfCloseProfile:proc
	extrn	_debug_free:proc
	extrn	strcpy:proc
	extrn	WinSendDlgItemMsg:proc
	extrn	WinWindowFromID:proc
	extrn	WinEnableWindow:proc
	extrn	CheckButton:proc
	extrn	strlen:proc
	extrn	WinSetDlgItemText:proc
	extrn	_sprintfieee:proc
	extrn	strcmp:proc
	extrn	WinMessageBox:proc
	extrn	Checked:proc
	extrn	PrfWriteProfileData:proc
	extrn	memcpy:proc
	extrn	PrfQueryProfileString:proc
	extrn	PrfWriteProfileString:proc
	extrn	PrfQueryProfileData:proc
	extrn	WinDlgBox:proc
	extrn	WinDefDlgProc:proc
	extrn	WinQueryDlgItemText:proc
	extrn	PrfQueryProfileSize:proc
	extrn	WinGetLastError:proc
	extrn	DosDelete:proc
	extrn	_itoa:proc
	extrn	memcmp:proc
	extrn	WinSendMsg:proc
	extrn	MessageBox:proc
	extrn	_fullDump:dword
DATA32	segment
@STAT1	db "p:\profile\profile.c",0h
	align 04h
@STAT2	db "p:\profile\profile.c",0h
	align 04h
@STAT3	db "p:\profile\profile.c",0h
	align 04h
@STAT4	db "%s configuration managem"
db "ent",0h
@STAT5	db "Save Profile Name is Dif"
db "ferent",0h
	align 04h
@STAT6	db "Do you want to overwrite"
db " profile ",022h,"%s",022h," with the c"
db "urrent configuration?",0h
	align 04h
@STAT7	db "Setup",0h
	align 04h
@STAT8	db "Status",0h
	align 04h
@STAT9	db "In Use",0h
	align 04h
@STATa	db "Unable to Load Selected "
db "Profile",0h
@STATb	db "The profile ",022h,"%s",022h," is in u"
db "se by an active session",0h
@STATc	db "Status",0h
	align 04h
@STATd	db "Available",0h
	align 04h
@STATe	db "Status",0h
	align 04h
@STATf	db "In Use",0h
	align 04h
@STAT10	db "Setup",0h
	align 04h
@STAT11	db "Setup",0h
	align 04h
@STAT12	db "Status",0h
	align 04h
@STAT13	db "Available",0h
	align 04h
@STAT14	db "Status",0h
	align 04h
@STAT15	db "In Use",0h
	align 04h
@STAT16	db "Setup",0h
	align 04h
@STAT17	db "Status",0h
	align 04h
@STAT18	db "In Use",0h
	align 04h
@STAT19	db "Unable to Delete Selecte"
db "d Profile",0h
	align 04h
@STAT1a	db "The profile ",022h,"%s",022h," is in u"
db "se by an active session",0h
@STAT1b	db "Deleted",0h
@STAT1c	db "Status",0h
	align 04h
@STAT1d	db "Deleted",0h
@STAT1e	db "~Undelete",0h
	align 04h
@STAT1f	db "Status",0h
	align 04h
@STAT20	db "Available",0h
	align 04h
@STAT21	db "~Delete",0h
@STAT22	db "p:\profile\profile.c",0h
	align 04h
@STAT23	db "p:\profile\profile.c",0h
	align 04h
@STAT24	db "~Undelete",0h
	align 04h
@STAT25	db "~Delete",0h
@STAT26	db "p:\profile\profile.c",0h
	align 04h
@STAT27	db "Invalid Character in Pro"
db "file Name",0h
	align 04h
@STAT28	db "The character ",022h,"%c",022h," canno"
db "t be used as the first c"
db "haracter in a profile na"
db "me.",0h
@STAT29	db "p:\profile\profile.c",0h
	align 04h
@STAT2a	db "p:\profile\profile.c",0h
	align 04h
@STAT2b	db "p:\profile\profile.c",0h
	align 04h
@STAT2c	db "Status",0h
	align 04h
@STAT2d	db "Deleted",0h
@STAT2e	db "p:\profile\profile.c",0h
	align 04h
@STAT2f	db "p:\profile\profile.c",0h
	align 04h
@STAT30	db "Status",0h
	align 04h
@STAT31	db "Deleted",0h
@STAT32	db "p:\profile\profile.c",0h
	align 04h
@STAT33	db "p:\profile\profile.c",0h
	align 04h
@STAT34	db "%s.INI",0h
	align 04h
@STAT35	db "p:\profile\profile.c",0h
	align 04h
@STAT36	db "p:\profile\profile.c",0h
	align 04h
@STAT37	db "p:\profile\profile.c",0h
	align 04h
@STAT38	db "p:\profile\profile.c",0h
	align 04h
@STAT39	db "p:\profile\profile.c",0h
	align 04h
@STAT3a	db "Version",0h
@STAT3b	db "Version",0h
@STAT3c	db "p:\profile\profile.c",0h
	align 04h
@STAT3d	db "p:\profile\profile.c",0h
	align 04h
@STAT3e	db "p:\profile\profile.c",0h
	align 04h
@STAT3f	db "p:\profile\profile.c",0h
	align 04h
@STAT40	db "Status",0h
	align 04h
@STAT41	db "Available",0h
	align 04h
@STAT42	db "p:\profile\profile.c",0h
	align 04h
@STAT43	db "Status",0h
	align 04h
@STAT44	db "Status",0h
	align 04h
@STAT45	db "In Use",0h
	align 04h
@STAT46	db "Setup",0h
	align 04h
@STAT47	db "Available",0h
	align 04h
@STAT48	db "Status",0h
	align 04h
@STAT49	db "In Use",0h
	align 04h
@STAT4a	db "Setup",0h
	align 04h
@STAT4b	db "Setup",0h
	align 04h
@STAT4c	db "Status",0h
	align 04h
@STAT4d	db "In Use",0h
	align 04h
@STAT4e	db "Setup",0h
	align 04h
@STAT4f	db "Setup",0h
	align 04h
@STAT50	db "Status",0h
	align 04h
@STAT51	db "Available",0h
	align 04h
@STAT52	db "Application Profile has "
db "Changed.",0h
	align 04h
@STAT53	db "Do you want to save the "
db "profile ",022h,"%s",022h,"?",0h
	align 04h
@STAT54	db "Setup",0h
	align 04h
@STAT55	db "Setup",0h
	align 04h
@STAT56	db "p:\profile\profile.c",0h
	align 04h
@STAT57	db "p:\profile\profile.c",0h
	align 04h
@STAT58	db "p:\profile\profile.c",0h
	align 04h
@STAT59	db "Unable to display Help P"
db "anel",0h
	align 04h
@STAT5a	db "Help is not Initialized",0h
	dd	_dllentry
DATA32	ends
CONST32_RO	segment
@2chDeletedMark1	db 0aeh
@3szDeletedFormat	db 0aeh,"%s",0afh,0h
CONST32_RO	ends
BSS32	segment
bDLLinUse	dd 0h
comm	szDialogTitle:byte:064h
@9hThisModule	dd 0h
@11iItemSelected	dd 0h
@12hProfile	dd 0h
@14pstInst	dd 0h
@15pstProfile	dd 0h
@17pszEntryAppName	dd 0h
@52pstInst	dd 0h
@53pszName	dd 0h
@54pstProfile	dd 0h
BSS32	ends
CODE32	segment

; 40   {
	align 010h

	public _DLL_InitTerm
_DLL_InitTerm	proc
	push	ebp
	mov	ebp,esp

; 41   if (ulTermCode == 0)
	cmp	dword ptr [ebp+0ch],0h;	ulTermCode
	jne	@BLBL1

; 42     hThisModule = hMod;
	mov	eax,[ebp+08h];	hMod
	mov	dword ptr  @9hThisModule,eax
@BLBL1:

; 43   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
_DLL_InitTerm	endp

; 47   {
	align 010h

	public fnwpManageConfigDlgProc
fnwpManageConfigDlgProc	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0a8h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,02ah
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 58   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL45
	align 04h
@BLBL46:

; 59     {
; 60     case WM_INITDLG:
; 61       CenterDlgBox(hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	call	CenterDlgBox
	add	esp,04h

; 62       WinSetFocus(HWND_DESKTOP,hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinSetFocus
	add	esp,08h

; 63       iItemSelected = LIT_NONE;
	mov	dword ptr  @11iItemSelected,0ffffffffh

; 64       pstInst = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @14pstInst,eax

; 65       pstProfile = pstInst->pstProfile;
	mov	eax,dword ptr  @14pstInst
	mov	eax,[eax+02h]
	mov	dword ptr  @15pstProfile,eax

; 66       if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) == 0)
	mov	eax,dword ptr  @15pstProfile
	add	eax,0d9h
	push	eax
	mov	eax,dword ptr  @15pstProfile
	push	dword ptr [eax]
	call	PrfOpenProfile
	add	esp,08h
	mov	dword ptr  @12hProfile,eax
	cmp	dword ptr  @12hProfile,0h
	jne	@BLBL2

; 67         WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h
@BLBL2:

; 68       pstInst->pszSelectedAppName = malloc(pstProfile->ulMaxProfileString);
	mov	ecx,044h
	mov	edx,offset FLAT:@STAT1
	mov	eax,dword ptr  @15pstProfile
	mov	eax,[eax+01e6h]
	call	_debug_malloc
	mov	ecx,eax
	mov	eax,dword ptr  @14pstInst
	mov	[eax+012h],ecx

; 69       if (pstInst->pszSelectedAppName == NULL)
	mov	eax,dword ptr  @14pstInst
	cmp	dword ptr [eax+012h],0h
	jne	@BLBL3

; 70         {
; 71         PrfCloseProfile(hProfile);
	push	dword ptr  @12hProfile
	call	PrfCloseProfile
	add	esp,04h

; 72         WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 73         }
@BLBL3:

; 74       if ((pszEntryAppName = malloc(pstProfile->ulMaxProfileString)) == NULL)
	mov	ecx,04ah
	mov	edx,offset FLAT:@STAT2
	mov	eax,dword ptr  @15pstProfile
	mov	eax,[eax+01e6h]
	call	_debug_malloc
	mov	dword ptr  @17pszEntryAppName,eax
	cmp	dword ptr  @17pszEntryAppName,0h
	jne	@BLBL4

; 75         {
; 76         free(pstInst->pszSelectedAppName);
	mov	ecx,04ch
	mov	edx,offset FLAT:@STAT3
	mov	eax,dword ptr  @14pstInst
	mov	eax,[eax+012h]
	call	_debug_free

; 77         PrfCloseProfile(hProfile);
	push	dword ptr  @12hProfile
	call	PrfCloseProfile
	add	esp,04h

; 78         WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 79         }
@BLBL4:

; 80       strcpy(pszEntryAppName,pstProfile->szAppName);
	mov	edx,dword ptr  @15pstProfile
	add	edx,087h
	mov	eax,dword ptr  @17pszEntryAppName
	call	strcpy

; 81 //      WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_SETITEMHEIGHT,(MPARAM)12,(MPARAM)0);
; 82       if (pstProfile->pfnUpdateCallBack != NULL)
	mov	eax,dword ptr  @15pstProfile
	cmp	dword ptr [eax+01deh],0h
	je	@BLBL5

; 83         pstProfile->pfnUpdateCallBack(PROFACTION_ENTER_MANAGE);
	push	07h
	mov	eax,dword ptr  @15pstProfile
	call	dword ptr [eax+01deh]
	add	esp,04h
@BLBL5:

; 84       if ((iItemSelected = (int)FillProfileListBox(hwndDlg,hProfile,pstInst)) != LIT_NONE)
	push	dword ptr  @14pstInst
	push	dword ptr  @12hProfile
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillProfileListBox
	add	esp,0ch
	mov	dword ptr  @11iItemSelected,eax
	cmp	dword ptr  @11iItemSelected,0ffffffffh
	je	@BLBL6

; 85         WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_SELECTITEM,MPFROMSHORT(iItemSelected),MPFROMSHORT(TRUE));
	push	01h
	mov	ax,word ptr  @11iItemSelected
	and	eax,0ffffh
	push	eax
	push	0164h
	push	02ee9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h
	jmp	@BLBL7
	align 010h
@BLBL6:

; 86       else
; 87         {
; 88         WinEnableWindow(WinWindowFromID(hwndDlg,PROF_LOAD),FALSE);
	push	02ee6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	0h
	push	eax
	call	WinEnableWindow
	add	esp,08h

; 89         WinEnableWindow(WinWindowFromID(hwndDlg,PROF_SAVE),FALSE);
	push	02ee7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	0h
	push	eax
	call	WinEnableWindow
	add	esp,08h

; 90         WinEnableWindow(WinWindowFromID(hwndDlg,PROF_DELETE),FALSE);
	push	02eech
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	0h
	push	eax
	call	WinEnableWindow
	add	esp,08h

; 91         }
@BLBL7:

; 92       if (pstProfile->bLoadWindowPosition)
	mov	eax,dword ptr  @15pstProfile
	test	byte ptr [eax+01ddh],01h
	je	@BLBL8

; 93         CheckButton(hwndDlg,PROF_LOADWINPOS,TRUE);
	push	01h
	push	02ee2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL8:

; 94       if (pstProfile->bLoadProcess)
	mov	eax,dword ptr  @15pstProfile
	test	byte ptr [eax+01ddh],02h
	je	@BLBL9

; 95         CheckButton(hwndDlg,PROF_LOADPROCESS,TRUE);
	push	01h
	push	02ee3h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL9:

; 96       if (pstProfile->bAutoSaveProfile)
	mov	eax,dword ptr  @15pstProfile
	test	byte ptr [eax+01ddh],04h
	je	@BLBL10

; 97         CheckButton(hwndDlg,PROF_AUTOSAVE,TRUE);
	push	01h
	push	02ee5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL10:

; 98       if (strlen(pstProfile->szProcessPrompt) != 0)
	mov	eax,dword ptr  @15pstProfile
	add	eax,0b0h
	call	strlen
	test	eax,eax
	je	@BLBL11

; 99         WinSetDlgItemText(hwndDlg,PROF_LOADPROCESS,pstProfile->szProcessPrompt);
	mov	eax,dword ptr  @15pstProfile
	add	eax,0b0h
	push	eax
	push	02ee3h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL11:

; 100       if (strlen(pstProfile->szProfileName) != 0)
	mov	eax,dword ptr  @15pstProfile
	add	eax,05eh
	call	strlen
	test	eax,eax
	je	@BLBL12

; 101         {
; 102         sprintf(szDialogTitle,"%s configuration management",pstProfile->szProfileName);
	mov	eax,dword ptr  @15pstProfile
	add	eax,05eh
	push	eax
	mov	edx,offset FLAT:@STAT4
	mov	eax,offset FLAT:szDialogTitle
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 103         WinSetDlgItemText(hwndDlg,PROF_HEADER,szDialogTitle);
	push	offset FLAT:szDialogTitle
	push	0bb8h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 104         }
@BLBL12:

; 105       if (pstProfile->pfnUpdateCallBack != NULL)
	mov	eax,dword ptr  @15pstProfile
	cmp	dword ptr [eax+01deh],0h
	je	@BLBL13

; 106         pstProfile->pfnUpdateCallBack(PROFACTION_EXIT_MANAGE_INIT);
	push	05h
	mov	eax,dword ptr  @15pstProfile
	call	dword ptr [eax+01deh]
	add	esp,04h
@BLBL13:

; 107       return (MRESULT) TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL47:

; 108     case WM_COMMAND:
; 109       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL49
	align 04h
@BLBL50:

; 110         {
; 111         case PROF_HELP:
; 112           if (pstProfile->phwndHelpInstance != NULL)
	mov	eax,dword ptr  @15pstProfile
	cmp	dword ptr [eax+056h],0h
	je	@BLBL14

; 113             DisplayHelpPanel(*pstProfile->phwndHelpInstance,pstProfile->ulHelpPanel);
	mov	eax,dword ptr  @15pstProfile
	mov	ax,[eax+05ah]
	push	eax
	mov	eax,dword ptr  @15pstProfile
	mov	eax,[eax+056h]
	push	dword ptr [eax]
	call	DisplayHelpPanel
	add	esp,08h
@BLBL14:

; 114           break;
	jmp	@BLBL48
	align 04h
@BLBL51:

; 115         case PROF_SAVE:
; 116           if (iItemSelected != LIT_NONE)
	cmp	dword ptr  @11iItemSelected,0ffffffffh
	je	@BLBL15

; 117             {
; 118             if (strcmp(pstProfile->szAppName,pstInst->pszSelectedAppName) != 0)
	mov	edx,dword ptr  @14pstInst
	mov	edx,[edx+012h]
	mov	eax,dword ptr  @15pstProfile
	add	eax,087h
	call	strcmp
	test	eax,eax
	je	@BLBL16

; 119               {
; 120               sprintf(szString,"Save Profile Name is Different");
	mov	edx,offset FLAT:@STAT5
	lea	eax,[ebp-0a0h];	szString
	call	_sprintfieee

; 121               sprintf(szListString,"Do you want to overwrite profile \"%s\" with the current configuration?",pstInst->pszSelectedAppName);
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+012h]
	mov	edx,offset FLAT:@STAT6
	lea	eax,[ebp-050h];	szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 122               flMessageBoxStyle = (MB_MOVEABLE | MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON2);
	mov	dword ptr [ebp-0a8h],04114h;	flMessageBoxStyle

; 123               if (pstProfile->ulHelpPanel != 0)
	mov	eax,dword ptr  @15pstProfile
	cmp	dword ptr [eax+05ah],0h
	je	@BLBL17

; 124                 flMessageBoxStyle |= MB_HELP;
	mov	eax,[ebp-0a8h];	flMessageBoxStyle
	or	ah,020h
	mov	[ebp-0a8h],eax;	flMessageBoxStyle
@BLBL17:

; 125               if (WinMessageBox(HWND_DESKTOP,
	push	dword ptr [ebp-0a8h];	flMessageBoxStyle
	mov	eax,dword ptr  @15pstProfile
	mov	eax,[eax+05ah]
	inc	eax
	push	eax
	lea	eax,[ebp-0a0h];	szString
	push	eax
	lea	eax,[ebp-050h];	szListString
	push	eax
	mov	eax,dword ptr  @15pstProfile
	push	dword ptr [eax+01e2h]
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,06h
	je	@BLBL16

; 126                                 pstProfile->hwndOwner,
; 127                                 szListString,
; 128                                 szString,
; 129                                (pstProfile->ulHelpPanel + HELP_SAVE),
; 130                                 flMessageBoxStyle) != MBID_YES)
; 131               break;
	jmp	@BLBL48
	align 04h
@BLBL16:

; 132               }
; 133             if (pstProfile->pfnUpdateCallBack != NULL)
	mov	eax,dword ptr  @15pstProfile
	cmp	dword ptr [eax+01deh],0h
	je	@BLBL19

; 134               {
; 135               pstProfile->bLoadWindowPosition = Checked(hwndDlg,PROF_LOADWINPOS);
	push	02ee2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	mov	edx,eax
	add	esp,08h
	mov	eax,dword ptr  @15pstProfile
	mov	cl,[eax+01ddh]
	and	cl,0feh
	and	dl,01h
	or	cl,dl
	mov	[eax+01ddh],cl

; 136               pstProfile->bLoadProcess = Checked(hwndDlg,PROF_LOADPROCESS);
	push	02ee3h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	mov	edx,eax
	add	esp,08h
	mov	eax,dword ptr  @15pstProfile
	mov	cl,[eax+01ddh]
	and	cl,0fdh
	sal	edx,01h
	and	dl,03h
	or	cl,dl
	mov	[eax+01ddh],cl

; 137               pstProfile->bAutoSaveProfile = Checked(hwndDlg,PROF_AUTOSAVE);
	push	02ee5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	mov	edx,eax
	add	esp,08h
	mov	eax,dword ptr  @15pstProfile
	mov	cl,[eax+01ddh]
	and	cl,0fbh
	sal	edx,02h
	and	dl,07h
	or	cl,dl
	mov	[eax+01ddh],cl

; 138               pstProfile->pfnUpdateCallBack(PROFACTION_ENTER_SAVE);
	push	0h
	mov	eax,dword ptr  @15pstProfile
	call	dword ptr [eax+01deh]
	add	esp,04h

; 139               }
@BLBL19:

; 140             PrfWriteProfileData(hProfile,pstInst->pszSelectedAppName,"Setup",pstProfile->pData,pstProfile->ulDataSize);
	mov	eax,dword ptr  @15pstProfile
	push	dword ptr [eax+01eeh]
	mov	eax,dword ptr  @15pstProfile
	push	dword ptr [eax+01f2h]
	push	offset FLAT:@STAT7
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+012h]
	push	dword ptr  @12hProfile
	call	PrfWriteProfileData
	add	esp,014h

; 141             memcpy(pstInst->pStartupData,pstProfile->pData,pstProfile->ulDataSize);
	mov	ecx,dword ptr  @15pstProfile
	mov	ecx,[ecx+01eeh]
	mov	edx,dword ptr  @15pstProfile
	mov	edx,[edx+01f2h]
	mov	eax,dword ptr  @14pstInst
	mov	eax,[eax+0ah]
	call	memcpy

; 142             if (pstProfile->pfnUpdateCallBack != NULL)
	mov	eax,dword ptr  @15pstProfile
	cmp	dword ptr [eax+01deh],0h
	je	@BLBL15

; 143               pstProfile->pfnUpdateCallBack(PROFACTION_EXIT_SAVE);
	push	01h
	mov	eax,dword ptr  @15pstProfile
	call	dword ptr [eax+01deh]
	add	esp,04h

; 144             }
@BLBL15:

; 145           break;
	jmp	@BLBL48
	align 04h
@BLBL52:

; 146         case PROF_LOAD:
; 147           if (iItemSelected != LIT_NONE)
	cmp	dword ptr  @11iItemSelected,0ffffffffh
	je	@BLBL21

; 148             {
; 149             PrfQueryProfileString(hProfile,pstInst->pszSelectedAppName,"Status",0L,pstInst->pszProfileString,pstProfile->ulMaxProfileString);
	mov	eax,dword ptr  @15pstProfile
	push	dword ptr [eax+01e6h]
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+0eh]
	push	0h
	push	offset FLAT:@STAT8
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+012h]
	push	dword ptr  @12hProfile
	call	PrfQueryProfileString
	add	esp,018h

; 150             if (strcmp(pstInst->pszProfileString,"In Use") == 0)
	mov	edx,offset FLAT:@STAT9
	mov	eax,dword ptr  @14pstInst
	mov	eax,[eax+0eh]
	call	strcmp
	test	eax,eax
	jne	@BLBL22

; 151               {
; 152               sprintf(szString,"Unable to Load Selected Profile");
	mov	edx,offset FLAT:@STATa
	lea	eax,[ebp-0a0h];	szString
	call	_sprintfieee

; 153               sprintf(szListString,"The profile \"%s\" is in use by an active session",pstInst->pszSelectedAppName);
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+012h]
	mov	edx,offset FLAT:@STATb
	lea	eax,[ebp-050h];	szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 154               flMessageBoxStyle = (MB_MOVEABLE | MB_INFORMATION);
	mov	dword ptr [ebp-0a8h],04030h;	flMessageBoxStyle

; 155               if (pstProfile->ulHelpPanel != 0)
	mov	eax,dword ptr  @15pstProfile
	cmp	dword ptr [eax+05ah],0h
	je	@BLBL23

; 156                 flMessageBoxStyle |= MB_HELP;
	mov	eax,[ebp-0a8h];	flMessageBoxStyle
	or	ah,020h
	mov	[ebp-0a8h],eax;	flMessageBoxStyle
@BLBL23:

; 157               WinMessageBox(HWND_DESKTOP,
	push	dword ptr [ebp-0a8h];	flMessageBoxStyle
	mov	eax,dword ptr  @15pstProfile
	mov	eax,[eax+05ah]
	add	eax,04h
	push	eax
	lea	eax,[ebp-0a0h];	szString
	push	eax
	lea	eax,[ebp-050h];	szListString
	push	eax
	mov	eax,dword ptr  @15pstProfile
	push	dword ptr [eax+01e2h]
	push	01h
	call	WinMessageBox
	add	esp,018h

; 158                             pstProfile->hwndOwner,
; 159                             szListString,
; 160                             szString,
; 161                            (pstProfile->ulHelpPanel + HELP_LOAD),
; 162                             flMessageBoxStyle);
; 163               break;
	jmp	@BLBL48
	align 04h
@BLBL22:

; 164               }
; 165             if (pstProfile->pfnUpdateCallBack != NULL)
	mov	eax,dword ptr  @15pstProfile
	cmp	dword ptr [eax+01deh],0h
	je	@BLBL24

; 166               pstProfile->pfnUpdateCallBack(PROFACTION_ENTER_LOAD);
	push	02h
	mov	eax,dword ptr  @15pstProfile
	call	dword ptr [eax+01deh]
	add	esp,04h
@BLBL24:

; 167             if (pstProfile->szAppName[0] != 0)
	mov	eax,dword ptr  @15pstProfile
	cmp	byte ptr [eax+087h],0h
	je	@BLBL25

; 168               PrfWriteProfileString(hProfile,pstProfile->szAppName,"Status","Available");
	push	offset FLAT:@STATd
	push	offset FLAT:@STATc
	mov	eax,dword ptr  @15pstProfile
	add	eax,087h
	push	eax
	push	dword ptr  @12hProfile
	call	PrfWriteProfileString
	add	esp,010h
@BLBL25:

; 169             strcpy(pstProfile->szAppName,pstInst->pszSelectedAppName);
	mov	edx,dword ptr  @14pstInst
	mov	edx,[edx+012h]
	mov	eax,dword ptr  @15pstProfile
	add	eax,087h
	call	strcpy

; 170             PrfWriteProfileString(hProfile,pstProfile->szAppName,"Status","In Use");
	push	offset FLAT:@STATf
	push	offset FLAT:@STATe
	mov	eax,dword ptr  @15pstProfile
	add	eax,087h
	push	eax
	push	dword ptr  @12hProfile
	call	PrfWriteProfileString
	add	esp,010h

; 171             ulSize = (pstProfile->ulDataSize);
	mov	eax,dword ptr  @15pstProfile
	mov	eax,[eax+01eeh]
	mov	[ebp-0a4h],eax;	ulSize

; 172             if (!PrfQueryProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,&ulSize))
	lea	eax,[ebp-0a4h];	ulSize
	push	eax
	mov	eax,dword ptr  @15pstProfile
	push	dword ptr [eax+01f2h]
	push	offset FLAT:@STAT10
	mov	eax,dword ptr  @15pstProfile
	add	eax,087h
	push	eax
	push	dword ptr  @12hProfile
	call	PrfQueryProfileData
	add	esp,014h
	test	eax,eax
	jne	@BLBL26

; 173               PrfWriteProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,pstProfile->ulDataSize);
	mov	eax,dword ptr  @15pstProfile
	push	dword ptr [eax+01eeh]
	mov	eax,dword ptr  @15pstProfile
	push	dword ptr [eax+01f2h]
	push	offset FLAT:@STAT11
	mov	eax,dword ptr  @15pstProfile
	add	eax,087h
	push	eax
	push	dword ptr  @12hProfile
	call	PrfWriteProfileData
	add	esp,014h
@BLBL26:

; 174             memcpy(pstInst->pStartupData,pstProfile->pData,pstProfile->ulDataSize);
	mov	ecx,dword ptr  @15pstProfile
	mov	ecx,[ecx+01eeh]
	mov	edx,dword ptr  @15pstProfile
	mov	edx,[edx+01f2h]
	mov	eax,dword ptr  @14pstInst
	mov	eax,[eax+0ah]
	call	memcpy

; 175             if (pstProfile->pfnUpdateCallBack != NULL)
	mov	eax,dword ptr  @15pstProfile
	cmp	dword ptr [eax+01deh],0h
	je	@BLBL27

; 176               {
; 177               pstProfile->pfnUpdateCallBack(PROFACTION_PROFILE_LOADED);
	push	03h
	mov	eax,dword ptr  @15pstProfile
	call	dword ptr [eax+01deh]
	add	esp,04h

; 178               CheckButton(
; 178 hwndDlg,PROF_LOADWINPOS,pstProfile->bLoadWindowPosition);
	mov	eax,dword ptr  @15pstProfile
	mov	al,[eax+01ddh]
	and	eax,01h
	push	eax
	push	02ee2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 179               CheckButton(hwndDlg,PROF_LOADPROCESS,pstProfile->bLoadProcess);
	mov	eax,dword ptr  @15pstProfile
	mov	al,[eax+01ddh]
	and	eax,03h
	shr	eax,01h
	push	eax
	push	02ee3h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 180               CheckButton(hwndDlg,PROF_AUTOSAVE,pstProfile->bAutoSaveProfile);
	mov	eax,dword ptr  @15pstProfile
	mov	al,[eax+01ddh]
	and	eax,07h
	shr	eax,02h
	push	eax
	push	02ee5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 181               }
@BLBL27:

; 182             if (pstProfile->pfnUpdateCallBack != NULL)
	mov	eax,dword ptr  @15pstProfile
	cmp	dword ptr [eax+01deh],0h
	je	@BLBL21

; 183               pstProfile->pfnUpdateCallBack(PROFACTION_EXIT_LOAD);
	push	04h
	mov	eax,dword ptr  @15pstProfile
	call	dword ptr [eax+01deh]
	add	esp,04h

; 184             }
@BLBL21:

; 185           break;
	jmp	@BLBL48
	align 04h
@BLBL53:

; 186         case PROF_NEW:
; 187           if (WinDlgBox(HWND_DESKTOP,
	push	dword ptr  @14pstInst
	push	02ee0h
	push	dword ptr  @9hThisModule
	push	offset FLAT: fnwpAppNameDlgProc
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL29

; 188                     hwndDlg,
; 189              (PFNWP)fnwpAppNameDlgProc,
; 190                     hThisModule,
; 191                     PROF_APPNAME_DLG,
; 192                     pstInst))
; 193             {
; 194             if (pstProfile->szAppName[0] != 0)
	mov	eax,dword ptr  @15pstProfile
	cmp	byte ptr [eax+087h],0h
	je	@BLBL30

; 195               PrfWriteProfileString(hProfile,pstProfile->szAppName,"Status","Available");
	push	offset FLAT:@STAT13
	push	offset FLAT:@STAT12
	mov	eax,dword ptr  @15pstProfile
	add	eax,087h
	push	eax
	push	dword ptr  @12hProfile
	call	PrfWriteProfileString
	add	esp,010h
@BLBL30:

; 196             strcpy(pstProfile->szAppName,pstInst->pszSelectedAppName);
	mov	edx,dword ptr  @14pstInst
	mov	edx,[edx+012h]
	mov	eax,dword ptr  @15pstProfile
	add	eax,087h
	call	strcpy

; 197             PrfWriteProfileString(hProfile,pstInst->pszSelectedAppName,"Status","In Use");
	push	offset FLAT:@STAT15
	push	offset FLAT:@STAT14
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+012h]
	push	dword ptr  @12hProfile
	call	PrfWriteProfileString
	add	esp,010h

; 198             PrfWriteProfileData(hProfile,pstInst->pszSelectedAppName,"Setup",pstProfile->pData,pstProfile->ulDataSize);
	mov	eax,dword ptr  @15pstProfile
	push	dword ptr [eax+01eeh]
	mov	eax,dword ptr  @15pstProfile
	push	dword ptr [eax+01f2h]
	push	offset FLAT:@STAT16
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+012h]
	push	dword ptr  @12hProfile
	call	PrfWriteProfileData
	add	esp,014h

; 199             memcpy(pstInst->pStartupData,pstProfile->pData,pstProfile->ulDataSize);
	mov	ecx,dword ptr  @15pstProfile
	mov	ecx,[ecx+01eeh]
	mov	edx,dword ptr  @15pstProfile
	mov	edx,[edx+01f2h]
	mov	eax,dword ptr  @14pstInst
	mov	eax,[eax+0ah]
	call	memcpy

; 200             WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(pstInst->pszSelectedAppName));
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+012h]
	push	0ffffh
	push	0161h
	push	02ee9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 201             iItemSelected = (SHORT)WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_SEARCHSTRING,MPFROM2SHORT(LSS_CASESENSITIVE,LIT_FIRST),MPFROMP(pstInst->pszSelectedAppName));
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+012h]
	push	0ffff0004h
	push	016bh
	push	02ee9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h
	movsx	eax,ax
	mov	dword ptr  @11iItemSelected,eax

; 202             WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_SELECTITEM,MPFROMSHORT(iItemSelected),MPFROMSHORT(TRUE));
	push	01h
	mov	ax,word ptr  @11iItemSelected
	and	eax,0ffffh
	push	eax
	push	0164h
	push	02ee9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 203             }
@BLBL29:

; 204           break;
	jmp	@BLBL48
	align 04h
@BLBL54:

; 205         case PROF_DELETE:
; 206           if (iItemSelected != LIT_NONE)
	cmp	dword ptr  @11iItemSelected,0ffffffffh
	je	@BLBL31

; 207             {
; 208             PrfQueryProfileString(hProfile,pstInst->pszSelectedAppName,"Status",0L,pstInst->pszProfileString,pstProfile->ulMaxProfileString);
	mov	eax,dword ptr  @15pstProfile
	push	dword ptr [eax+01e6h]
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+0eh]
	push	0h
	push	offset FLAT:@STAT17
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+012h]
	push	dword ptr  @12hProfile
	call	PrfQueryProfileString
	add	esp,018h

; 209             if (strcmp(pstInst->pszProfileString,"In Use") == 0)
	mov	edx,offset FLAT:@STAT18
	mov	eax,dword ptr  @14pstInst
	mov	eax,[eax+0eh]
	call	strcmp
	test	eax,eax
	jne	@BLBL32

; 210               {
; 211               sprintf(szString,"Unable to Delete Selected Profile");
	mov	edx,offset FLAT:@STAT19
	lea	eax,[ebp-0a0h];	szString
	call	_sprintfieee

; 212               sprintf(szListString,"The profile \"%s\" is in use by an active session",pstInst->pszSelectedAppName);
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+012h]
	mov	edx,offset FLAT:@STAT1a
	lea	eax,[ebp-050h];	szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 213               flMessageBoxStyle = (MB_MOVEABLE | MB_INFORMATION);
	mov	dword ptr [ebp-0a8h],04030h;	flMessageBoxStyle

; 214               if (pstProfile->ulHelpPanel != 0)
	mov	eax,dword ptr  @15pstProfile
	cmp	dword ptr [eax+05ah],0h
	je	@BLBL33

; 215                 flMessageBoxStyle |= MB_HELP;
	mov	eax,[ebp-0a8h];	flMessageBoxStyle
	or	ah,020h
	mov	[ebp-0a8h],eax;	flMessageBoxStyle
@BLBL33:

; 216               WinMessageBox(HWND_DESKTOP,
	push	dword ptr [ebp-0a8h];	flMessageBoxStyle
	mov	eax,dword ptr  @15pstProfile
	mov	eax,[eax+05ah]
	add	eax,02h
	push	eax
	lea	eax,[ebp-0a0h];	szString
	push	eax
	lea	eax,[ebp-050h];	szListString
	push	eax
	mov	eax,dword ptr  @15pstProfile
	push	dword ptr [eax+01e2h]
	push	01h
	call	WinMessageBox
	add	esp,018h

; 217                             pstProfile->hwndOwner,
; 218                             szListString,
; 219                             szString,
; 220                            (pstProfile->ulHelpPanel + HELP_DELETE),
; 221                             flMessageBoxStyle);
; 222               break;
	jmp	@BLBL48
	align 04h
@BLBL32:

; 223               }
; 224             if (strcmp(pstInst->pszProfileString,"Deleted") != 0)
	mov	edx,offset FLAT:@STAT1b
	mov	eax,dword ptr  @14pstInst
	mov	eax,[eax+0eh]
	call	strcmp
	test	eax,eax
	je	@BLBL34

; 225               {
; 226               PrfWriteProfileString(hProfile,pstInst->pszSelectedAppName,"Status","Deleted");
	push	offset FLAT:@STAT1d
	push	offset FLAT:@STAT1c
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+012h]
	push	dword ptr  @12hProfile
	call	PrfWriteProfileString
	add	esp,010h

; 227               pstInst->bObjectDeleted = TRUE;
	mov	eax,dword ptr  @14pstInst
	mov	dword ptr [eax+06h],01h

; 228               WinEnableWindow(WinWindowFromID(hwndDlg,PROF_LOAD),FALSE);
	push	02ee6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	0h
	push	eax
	call	WinEnableWindow
	add	esp,08h

; 229               WinEnableWindow(WinWindowFromID(hwndDlg,PROF_SAVE),FALSE);
	push	02ee7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	0h
	push	eax
	call	WinEnableWindow
	add	esp,08h

; 230               WinSetDlgItemText(hwndDlg,PROF_DELETE,"~Undelete");
	push	offset FLAT:@STAT1e
	push	02eech
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 231 //              WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_QUERYITEMTEXT,MPFROM2SHORT(iItemSelected,pstProfile->ulMaxProfileString),MPFROMP(pstInst->pszProfileString));
; 232               sprintf(pstInst->pszProfileString,szDeletedFormat,pstInst->pszSelectedAppName);
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+012h]
	mov	edx,offset FLAT:@3szDeletedFormat
	mov	eax,dword ptr  @14pstInst
	mov	eax,[eax+0eh]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 233               WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_SETITEMTEXT,MPFROMSHORT(iItemSelected),MPFROMP(pstInst->pszProfileString));
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+0eh]
	mov	ax,word ptr  @11iItemSelected
	and	eax,0ffffh
	push	eax
	push	0166h
	push	02ee9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 234               }
	jmp	@BLBL31
	align 010h
@BLBL34:

; 235             else
; 236               {
; 237               PrfWriteProfileString(hProfile,pstInst->pszSelectedAppName,"Status","Available");
	push	offset FLAT:@STAT20
	push	offset FLAT:@STAT1f
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+012h]
	push	dword ptr  @12hProfile
	call	PrfWriteProfileString
	add	esp,010h

; 238               pstInst->bObjectDeleted = TRUE;
	mov	eax,dword ptr  @14pstInst
	mov	dword ptr [eax+06h],01h

; 239               WinEnableWindow(WinWindowFromID(hwndDlg,PROF_LOAD),FALSE);
	push	02ee6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	0h
	push	eax
	call	WinEnableWindow
	add	esp,08h

; 240               WinEnableWindow(WinWindowFromID(hwndDlg,PROF_SAVE),FALSE);
	push	02ee7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	0h
	push	eax
	call	WinEnableWindow
	add	esp,08h

; 241               WinSetDlgItemText(hwndDlg,PROF_DELETE,"~Delete");
	push	offset FLAT:@STAT21
	push	02eech
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 242               WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_SETITEMTEXT,MPFROMSHORT(iItemSelected),MPFROMP(pstInst->pszSelectedAppName));
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+012h]
	mov	ax,word ptr  @11iItemSelected
	and	eax,0ffffh
	push	eax
	push	0166h
	push	02ee9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 243               }

; 244             }
@BLBL31:

; 245           break;
	jmp	@BLBL48
	align 04h
@BLBL55:

; 246         case PROF_OK:
; 247           PrfCloseProfile(hProfile);
	push	dword ptr  @12hProfile
	call	PrfCloseProfile
	add	esp,04h

; 248           if (pstProfile->pfnUpdateCallBack != NULL)
	mov	eax,dword ptr  @15pstProfile
	cmp	dword ptr [eax+01deh],0h
	je	@BLBL36

; 249             pstProfile->pfnUpdateCallBack(PROFACTION_EXIT_MANAGE);
	push	06h
	mov	eax,dword ptr  @15pstProfile
	call	dword ptr [eax+01deh]
	add	esp,04h
@BLBL36:

; 250           if (strcmp(pszEntryAppName,pstProfile->szAppName) != 0)
	mov	edx,dword ptr  @15pstProfile
	add	edx,087h
	mov	eax,dword ptr  @17pszEntryAppName
	call	strcmp
	test	eax,eax
	je	@BLBL37

; 251             WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h
	jmp	@BLBL38
	align 010h
@BLBL37:

; 252           else
; 253             WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h
@BLBL38:

; 254           free(pstInst->pszSelectedAppName);
	mov	ecx,0feh
	mov	edx,offset FLAT:@STAT22
	mov	eax,dword ptr  @14pstInst
	mov	eax,[eax+012h]
	call	_debug_free

; 255           free(pszEntryAppName);
	mov	ecx,0ffh
	mov	edx,offset FLAT:@STAT23
	mov	eax,dword ptr  @17pszEntryAppName
	call	_debug_free

; 256           return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL56:

; 257         default:
; 258           return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDefDlgProc
	add	esp,01ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL48
	align 04h
@BLBL49:
	cmp	eax,02eebh
	je	@BLBL50
	cmp	eax,02ee7h
	je	@BLBL51
	cmp	eax,02ee6h
	je	@BLBL52
	cmp	eax,02eedh
	je	@BLBL53
	cmp	eax,02eech
	je	@BLBL54
	cmp	eax,02ee4h
	je	@BLBL55
	jmp	@BLBL56
	align 04h
@BLBL48:

; 259         }
; 260       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL57:

; 261     case WM_CONTROL:
; 262       if (SHORT2FROMMP(mp1) == LN_SELECT)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL39

; 263         if (SHORT1FROMMP(mp1) == PROF_LIST)
	mov	ax,[ebp+010h];	mp1
	cmp	ax,02ee9h
	jne	@BLBL39

; 264           {
; 265           iItemSelected = (int)WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_QUERYSELECTION,0L,0L);
	push	0h
	push	0h
	push	0165h
	push	02ee9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h
	mov	dword ptr  @11iItemSelected,eax

; 266           if (iItemSelected != LIT_NONE)
	cmp	dword ptr  @11iItemSelected,0ffffffffh
	je	@BLBL41

; 267             {
; 268             WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_QUERYITEMTEXT,MPFROM2SHORT(iItemSelected,pstProfile->ulMaxProfileString + 8),MPFROMP(pstInst->pszProfileString));
	mov	eax,dword ptr  @14pstInst
	push	dword ptr [eax+0eh]
	mov	ecx,dword ptr  @15pstProfile
	mov	ecx,[ecx+01e6h]
	add	ecx,08h
	and	ecx,0ffffh
	sal	ecx,010h
	mov	ax,word ptr  @11iItemSelected
	and	eax,0ffffh
	or	eax,ecx
	push	eax
	push	0168h
	push	02ee9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 269             if (pstInst->pszProfileString[0] == chDeletedMark1)
	mov	eax,dword ptr  @14pstInst
	mov	eax,[eax+0eh]
	mov	cl,byte ptr  @2chDeletedMark1
	cmp	[eax],cl
	jne	@BLBL42

; 270               {
; 271               strcpy(pstInst->pszSelectedAppName,&pstInst->pszProfileString[1]);
	mov	edx,dword ptr  @14pstInst
	mov	edx,[edx+0eh]
	inc	edx
	mov	eax,dword ptr  @14pstInst
	mov	eax,[eax+012h]
	call	strcpy

; 272               pstInst->pszSelectedAppName[strlen(pstInst->pszSelectedAppName) - 1] = 0;
	mov	eax,dword ptr  @14pstInst
	mov	eax,[eax+012h]
	call	strlen
	mov	ecx,eax
	mov	eax,dword ptr  @14pstInst
	mov	eax,[eax+012h]
	mov	byte ptr [eax+ecx-01h],0h

; 273               WinSetDlgItemText(hwndDlg,PROF_DELETE,"~Undelete");
	push	offset FLAT:@STAT24
	push	02eech
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 274               WinEnableWindow(WinWindowFromID(hwndDlg,PROF_LOAD),FALSE);
	push	02ee6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	0h
	push	eax
	call	WinEnableWindow
	add	esp,08h

; 275               WinEnableWindow(WinWindowFromID(hwndDlg,PROF_SAVE),FALSE);
	push	02ee7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	0h
	push	eax
	call	WinEnableWindow
	add	esp,08h

; 276               }
	jmp	@BLBL43
	align 010h
@BLBL42:

; 277             else
; 278               {
; 279               strcpy(pstInst->pszSelectedAppName,pstInst->pszProfileString);
	mov	edx,dword ptr  @14pstInst
	mov	edx,[edx+0eh]
	mov	eax,dword ptr  @14pstInst
	mov	eax,[eax+012h]
	call	strcpy

; 280               WinSetDlgItemText(hwndDlg,PROF_DELETE,"~Delete");
	push	offset FLAT:@STAT25
	push	02eech
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 281               WinEnableWindow(WinWindowFromID(hwndDlg,PROF_LOAD),TRUE);
	push	02ee6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	01h
	push	eax
	call	WinEnableWindow
	add	esp,08h

; 282               WinEnableWindow(WinWindowFromID(hwndDlg,PROF_SAVE),TRUE);
	push	02ee7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	01h
	push	eax
	call	WinEnableWindow
	add	esp,08h

; 283               }
@BLBL43:

; 284             WinEnableWindow(WinWindowFromID(hwndDlg,PROF_DELETE),TRUE);
	push	02eech
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	01h
	push	eax
	call	WinEnableWindow
	add	esp,08h

; 285             }
@BLBL41:

; 286           return((MRESULT)TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL39:

; 287           }
; 288         break;
	jmp	@BLBL44
	align 04h
	jmp	@BLBL44
	align 04h
@BLBL45:
	cmp	eax,03bh
	je	@BLBL46
	cmp	eax,020h
	je	@BLBL47
	cmp	eax,030h
	je	@BLBL57
@BLBL44:

; 289     }
; 290   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDefDlgProc
	add	esp,01ch
	mov	esp,ebp
	pop	ebp
	ret	
fnwpManageConfigDlgProc	endp

; 294   {
	align 010h

	public fnwpAppNameDlgProc
fnwpAppNameDlgProc	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0a4h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,029h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 302   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL63
	align 04h
@BLBL64:

; 303     {
; 304     case WM_INITDLG:
; 305       CenterDlgBox(hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	call	CenterDlgBox
	add	esp,04h

; 306       pstInst = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @52pstInst,eax

; 307       pstProfile = pstInst->pstProfile;
	mov	eax,dword ptr  @52pstInst
	mov	eax,[eax+02h]
	mov	dword ptr  @54pstProfile,eax

; 308       if ((pszName = malloc(pstProfile->ulMaxProfileString)) == NULL)
	mov	ecx,0134h
	mov	edx,offset FLAT:@STAT26
	mov	eax,dword ptr  @54pstProfile
	mov	eax,[eax+01e6h]
	call	_debug_malloc
	mov	dword ptr  @53pszName,eax
	cmp	dword ptr  @53pszName,0h
	jne	@BLBL58

; 309         WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h
@BLBL58:

; 310       WinSendDlgItemMsg(hwndDlg,PROF_APPNAME,EM_SETTEXTLIMIT,MPFROMSHORT(pstProfile->ulMaxProfileString),(MPARAM)NULL);
	push	0h
	mov	eax,dword ptr  @54pstProfile
	mov	ax,[eax+01e6h]
	and	eax,0ffffh
	push	eax
	push	0143h
	push	02ee1h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 311       WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,PROF_APPNAME));
	push	02ee1h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	eax
	push	01h
	call	WinSetFocus
	add	esp,08h

; 312       return (MRESULT) TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL65:

; 313     case WM_COMMAND:
; 314       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL67
	align 04h
@BLBL68:

; 315         {
; 316         case PROF_OK:
; 317           WinQueryDlgItemText(hwndDlg,PROF_APPNAME,pstProfile->ulMaxProfileString,pszName);
	push	dword ptr  @53pszName
	mov	eax,dword ptr  @54pstProfile
	mov	eax,[eax+01e6h]
	push	eax
	push	02ee1h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinQueryDlgItemText
	add	esp,010h

; 318           if (strlen(pszName) > 0)
	mov	eax,dword ptr  @53pszName
	call	strlen
	test	eax,eax
	jbe	@BLBL59

; 319             {
; 320             if (pszName[0] == chDeletedMark1)
	mov	eax,dword ptr  @53pszName
	mov	cl,byte ptr  @2chDeletedMark1
	cmp	[eax],cl
	jne	@BLBL60

; 321               {
; 322               sprintf(szString,"Invalid Character in Profile Name");
	mov	edx,offset FLAT:@STAT27
	lea	eax,[ebp-0a0h];	szString
	call	_sprintfieee

; 323               sprintf(szListString,"The character \"%c\" cannot be used as the first character in a profile name.",chDeletedMark1);
	xor	eax,eax
	mov	al,byte ptr  @2chDeletedMark1
	push	eax
	mov	edx,offset FLAT:@STAT28
	lea	eax,[ebp-050h];	szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 324               flMessageBoxStyle = (MB_MOVEABLE | MB_INFORMATION);
	mov	dword ptr [ebp-0a4h],04030h;	flMessageBoxStyle

; 325               if (pstProfile->ulHelpPanel != 0)
	mov	eax,dword ptr  @54pstProfile
	cmp	dword ptr [eax+05ah],0h
	je	@BLBL61

; 326                 flMessageBoxStyle |= MB_HELP;
	mov	eax,[ebp-0a4h];	flMessageBoxStyle
	or	ah,020h
	mov	[ebp-0a4h],eax;	flMessageBoxStyle
@BLBL61:

; 327               WinMessageBox(HWND_DESKTOP,
	push	dword ptr [ebp-0a4h];	flMessageBoxStyle
	mov	eax,dword ptr  @54pstProfile
	mov	eax,[eax+05ah]
	add	eax,03h
	push	eax
	lea	eax,[ebp-0a0h];	szString
	push	eax
	lea	eax,[ebp-050h];	szListString
	push	eax
	mov	eax,dword ptr  @54pstProfile
	push	dword ptr [eax+01e2h]
	push	01h
	call	WinMessageBox
	add	esp,018h

; 328                             pstProfile->hwndOwner,
; 329                             szListString,
; 330                             szString,
; 331                            (pstProfile->ulHelpPanel + HELP_NAME),
; 332                             flMessageBoxStyle);
; 333               break;
	jmp	@BLBL66
	align 04h
@BLBL60:

; 334               }
; 335             strcpy(pstInst->pszSelectedAppName,pszName);
	mov	edx,dword ptr  @53pszName
	mov	eax,dword ptr  @52pstInst
	mov	eax,[eax+012h]
	call	strcpy

; 336             free(pszName);
	mov	ecx,0150h
	mov	edx,offset FLAT:@STAT29
	mov	eax,dword ptr  @53pszName
	call	_debug_free

; 337             WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 338             return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL59:
@BLBL69:

; 339             }
; 340         case PROF_CANCEL:
; 341           free(pszName);
	mov	ecx,0155h
	mov	edx,offset FLAT:@STAT2a
	mov	eax,dword ptr  @53pszName
	call	_debug_free

; 342           WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 343           break;
	jmp	@BLBL66
	align 04h
@BLBL70:

; 344         default:
; 345           return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDefDlgProc
	add	esp,01ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL66
	align 04h
@BLBL67:
	cmp	eax,02ee4h
	je	@BLBL68
	cmp	eax,02eeah
	je	@BLBL69
	jmp	@BLBL70
	align 04h
@BLBL66:

; 346         }
; 347       return((MRES
; 347 ULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL62
	align 04h
@BLBL63:
	cmp	eax,03bh
	je	@BLBL64
	cmp	eax,020h
	je	@BLBL65
@BLBL62:

; 348     }
; 349   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDefDlgProc
	add	esp,01ch
	mov	esp,ebp
	pop	ebp
	ret	
fnwpAppNameDlgProc	endp

; 353   {
	align 010h

	public FillProfileListBox
FillProfileListBox	proc
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
	sub	esp,0ch

; 359   int iItemToSelect = LIT_NONE;
	mov	dword ptr [ebp-018h],0ffffffffh;	iItemToSelect

; 360   PROFILE *pstProfile = pstInst->pstProfile;
	mov	eax,[ebp+010h];	pstInst
	mov	eax,[eax+02h]
	mov	[ebp-01ch],eax;	pstProfile

; 361 
; 362   PrfQueryProfileSize(hProfile,0L,0L,&ulSize);
	lea	eax,[ebp-014h];	ulSize
	push	eax
	push	0h
	push	0h
	push	dword ptr [ebp+0ch];	hProfile
	call	PrfQueryProfileSize
	add	esp,010h

; 363   if ((pAppNames = malloc(ulSize + 1)) != NULL)
	mov	ecx,016bh
	mov	edx,offset FLAT:@STAT2b
	mov	eax,[ebp-014h];	ulSize
	inc	eax
	call	_debug_malloc
	mov	[ebp-010h],eax;	pAppNames
	cmp	dword ptr [ebp-010h],0h;	pAppNames
	je	@BLBL71

; 364     {
; 365     PrfQueryProfileString(hProfile,0L,0L,0L,pAppNames,ulSize);
	push	dword ptr [ebp-014h];	ulSize
	push	dword ptr [ebp-010h];	pAppNames
	push	0h
	push	0h
	push	0h
	push	dword ptr [ebp+0ch];	hProfile
	call	PrfQueryProfileString
	add	esp,018h

; 366     iIndex = 0;
	mov	dword ptr [ebp-04h],0h;	iIndex

; 367     for (iAppIndex = 0;iAppIndex < pstProfile->ulMaxApps;iAppIndex++)
	mov	dword ptr [ebp-0ch],0h;	iAppIndex
	mov	eax,[ebp-01ch];	pstProfile
	mov	ecx,[ebp-0ch];	iAppIndex
	cmp	[eax+01eah],ecx
	jbe	@BLBL71
	align 010h
@BLBL73:

; 368       {
; 369       iStartIndex = iIndex;
	mov	eax,[ebp-04h];	iIndex
	mov	[ebp-08h],eax;	iStartIndex

; 370       while(pAppNames[iIndex++] != 0);
	mov	eax,[ebp-010h];	pAppNames
	mov	ecx,[ebp-04h];	iIndex
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL74
	align 010h
@BLBL75:
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	mov	eax,[ebp-010h];	pAppNames
	mov	ecx,[ebp-04h];	iIndex
	cmp	byte ptr [eax+ecx],0h
	jne	@BLBL75
@BLBL74:
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex

; 371       if (iItemToSelect == LIT_NONE)
	cmp	dword ptr [ebp-018h],0ffffffffh;	iItemToSelect
	jne	@BLBL78

; 372         if (strcmp(&pAppNames[iStartIndex],pstProfile->szAppName) == 0)
	mov	edx,[ebp-01ch];	pstProfile
	add	edx,087h
	mov	eax,[ebp-010h];	pAppNames
	mov	ecx,[ebp-08h];	iStartIndex
	add	eax,ecx
	call	strcmp
	test	eax,eax
	jne	@BLBL78

; 373           iItemToSelect = iAppIndex;
	mov	eax,[ebp-0ch];	iAppIndex
	mov	[ebp-018h],eax;	iItemToSelect
@BLBL78:

; 374       if (PrfQueryProfileString(hProfile,&pAppNames[iStartIndex],"Status",0L,pstInst->pszProfileString,pstProfile->ulMaxProfileString) != 0)
	mov	eax,[ebp-01ch];	pstProfile
	push	dword ptr [eax+01e6h]
	mov	eax,[ebp+010h];	pstInst
	push	dword ptr [eax+0eh]
	push	0h
	push	offset FLAT:@STAT2c
	mov	eax,[ebp-010h];	pAppNames
	mov	ecx,[ebp-08h];	iStartIndex
	add	eax,ecx
	push	eax
	push	dword ptr [ebp+0ch];	hProfile
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	je	@BLBL80

; 375         if (strcmp(pstInst->pszProfileString,"Deleted") != 0)
	mov	edx,offset FLAT:@STAT2d
	mov	eax,[ebp+010h];	pstInst
	mov	eax,[eax+0eh]
	call	strcmp
	test	eax,eax
	je	@BLBL81

; 376           WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(&pAppNames[iStartIndex]));
	mov	eax,[ebp-010h];	pAppNames
	mov	ecx,[ebp-08h];	iStartIndex
	add	eax,ecx
	push	eax
	push	0ffffh
	push	0161h
	push	02ee9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h
	jmp	@BLBL80
	align 010h
@BLBL81:

; 377         else
; 378           {
; 379           sprintf(pstInst->pszProfileString,szDeletedFormat,&pAppNames[iStartIndex]);
	mov	eax,[ebp-010h];	pAppNames
	mov	ecx,[ebp-08h];	iStartIndex
	add	eax,ecx
	push	eax
	mov	edx,offset FLAT:@3szDeletedFormat
	mov	eax,[ebp+010h];	pstInst
	mov	eax,[eax+0eh]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 380           WinSendDlgItemMsg(hwndDlg,PROF_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(pstInst->pszProfileString));
	mov	eax,[ebp+010h];	pstInst
	push	dword ptr [eax+0eh]
	push	0ffffh
	push	0161h
	push	02ee9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 381           }
@BLBL80:

; 382       if (pAppNames[iIndex] == 0)
	mov	eax,[ebp-010h];	pAppNames
	mov	ecx,[ebp-04h];	iIndex
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL71

; 383         break;
; 384       }

; 367     for (iAppIndex = 0;iAppIndex < pstProfile->ulMaxApps;iAppIndex++)
	mov	eax,[ebp-0ch];	iAppIndex
	inc	eax
	mov	[ebp-0ch],eax;	iAppIndex
	mov	eax,[ebp-01ch];	pstProfile
	mov	ecx,[ebp-0ch];	iAppIndex
	cmp	[eax+01eah],ecx
	ja	@BLBL73

; 385     }
@BLBL71:

; 386   free(pAppNames);
	mov	ecx,0182h
	mov	edx,offset FLAT:@STAT2e
	mov	eax,[ebp-010h];	pAppNames
	call	_debug_free

; 387   return(iItemToSelect);
	mov	eax,[ebp-018h];	iItemToSelect
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
FillProfileListBox	endp

; 391   {
	align 010h

	public DeleteProfileApps
DeleteProfileApps	proc
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
	sub	esp,0ch

; 395   char *pAppNames = NULL;
	mov	dword ptr [ebp-010h],0h;	pAppNames

; 396   HINI hSourceProfile;
; 397   ULONG ulSize;
; 398   PROFILE *pstProfile = pstInst->pstProfile;
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+02h]
	mov	[ebp-01ch],eax;	pstProfile

; 399 
; 400   if ((hSourceProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
	mov	eax,[ebp-01ch];	pstProfile
	add	eax,0d9h
	push	eax
	mov	eax,[ebp-01ch];	pstProfile
	push	dword ptr [eax]
	call	PrfOpenProfile
	add	esp,08h
	mov	[ebp-014h],eax;	hSourceProfile
@BLBL85:

; 401     {
; 402     PrfQueryProfileSize(hSourceProfile,0L,0L,&ulSize);
	lea	eax,[ebp-018h];	ulSize
	push	eax
	push	0h
	push	0h
	push	dword ptr [ebp-014h];	hSourceProfile
	call	PrfQueryProfileSize
	add	esp,010h

; 403     if ((pAppNames = (char *)malloc(ulSize + 1)) != NULL)
	mov	ecx,0193h
	mov	edx,offset FLAT:@STAT2f
	mov	eax,[ebp-018h];	ulSize
	inc	eax
	call	_debug_malloc
	mov	[ebp-010h],eax;	pAppNames
	cmp	dword ptr [ebp-010h],0h;	pAppNames
	je	@BLBL86

; 404       {
; 405       PrfQueryProfileString(hSourceProfile,0L,0L,0L,pAppNames,ulSize);
	push	dword ptr [ebp-018h];	ulSize
	push	dword ptr [ebp-010h];	pAppNames
	push	0h
	push	0h
	push	0h
	push	dword ptr [ebp-014h];	hSourceProfile
	call	PrfQueryProfileString
	add	esp,018h

; 406       iIndex = 0;
	mov	dword ptr [ebp-04h],0h;	iIndex

; 407       for (iAppIndex = 0;iAppIndex < pstProfile->ulMaxApps;iAppIndex++)
	mov	dword ptr [ebp-0ch],0h;	iAppIndex
	mov	eax,[ebp-01ch];	pstProfile
	mov	ecx,[ebp-0ch];	iAppIndex
	cmp	[eax+01eah],ecx
	jbe	@BLBL86
	align 010h
@BLBL88:

; 408         {
; 409         iStartIndex = iIndex;
	mov	eax,[ebp-04h];	iIndex
	mov	[ebp-08h],eax;	iStartIndex

; 410         while(pAppNames[iIndex++] != 0);
	mov	eax,[ebp-010h];	pAppNames
	mov	ecx,[ebp-04h];	iIndex
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL89
	align 010h
@BLBL90:
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	mov	eax,[ebp-010h];	pAppNames
	mov	ecx,[ebp-04h];	iIndex
	cmp	byte ptr [eax+ecx],0h
	jne	@BLBL90
@BLBL89:
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex

; 411         if ((PrfQueryProfileString(hSourceProfile,
	mov	eax,[ebp-01ch];	pstProfile
	push	dword ptr [eax+01e6h]
	mov	eax,[ebp+08h];	pstInst
	push	dword ptr [eax+0eh]
	push	0h
	push	offset FLAT:@STAT30
	mov	eax,[ebp-010h];	pAppNames
	mov	ecx,[ebp-08h];	iStartIndex
	add	eax,ecx
	push	eax
	push	dword ptr [ebp-014h];	hSourceProfile
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	je	@BLBL93

; 412                                   &pAppNames[iStartIndex],
; 413                                   "Status",
; 414                                    0L,
; 415                                    pstInst->pszProfileString,
; 416                                    pstProfile->ulMaxProfileString) == 0) ||
; 417             (strcmp(pstInst->pszProfileString,"Deleted") == 0))
	mov	edx,offset FLAT:@STAT31
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+0eh]
	call	strcmp
	test	eax,eax
	jne	@BLBL94
@BLBL93:

; 418           PrfWriteProfileData(hSourceProfile,&pAppNames[iStartIndex],NULL,NULL,0L);
	push	0h
	push	0h
	push	0h
	mov	eax,[ebp-010h];	pAppNames
	mov	ecx,[ebp-08h];	iStartIndex
	add	eax,ecx
	push	eax
	push	dword ptr [ebp-014h];	hSourceProfile
	call	PrfWriteProfileData
	add	esp,014h
@BLBL94:

; 419         if (pAppNames[iIndex] == 0)
	mov	eax,[ebp-010h];	pAppNames
	mov	ecx,[ebp-04h];	iIndex
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL86

; 420           break;
; 421         }

; 407       for (iAppIndex = 0;iAppIndex < pstProfile->ulMaxApps;iAppIndex++)
	mov	eax,[ebp-0ch];	iAppIndex
	inc	eax
	mov	[ebp-0ch],eax;	iAppIndex
	mov	eax,[ebp-01ch];	pstProfile
	mov	ecx,[ebp-0ch];	iAppIndex
	cmp	[eax+01eah],ecx
	ja	@BLBL88

; 422       }
@BLBL86:

; 423     }

; 424   if (hSourceProfile != 0)
	cmp	dword ptr [ebp-014h],0h;	hSourceProfile
	je	@BLBL97

; 425     PrfCloseProfile(hSourceProfile);
	push	dword ptr [ebp-014h];	hSourceProfile
	call	PrfCloseProfile
	add	esp,04h
@BLBL97:

; 426   if (pAppNames != NULL)
	cmp	dword ptr [ebp-010h],0h;	pAppNames
	je	@BLBL98

; 427     free(pAppNames);
	mov	ecx,01abh
	mov	edx,offset FLAT:@STAT32
	mov	eax,[ebp-010h];	pAppNames
	call	_debug_free
@BLBL98:

; 428   }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
DeleteProfileApps	endp

; 431   {
	align 010h

	public ManageProfile
ManageProfile	proc
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

; 435   rc = WinDlgBox(HWND_DESKTOP,
	push	dword ptr [ebp+0ch];	hInst
	push	02ee8h
	push	dword ptr  @9hThisModule
	push	offset FLAT: fnwpManageConfigDlgProc
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	mov	[ebp-04h],eax;	rc

; 436                  hwnd,
; 437           (PFNWP)fnwpManageConfigDlgProc,
; 438                  hThisModule,
; 439                  PROF_DLG,
; 440                  hInst);
; 441   if (rc == DID_ERROR)
	cmp	dword ptr [ebp-04h],0ffffh;	rc
	jne	@BLBL99

; 442     {
; 443     WinGetLastError(hInst->pstProfile->hab);
	mov	eax,[ebp+0ch];	hInst
	mov	eax,[eax+02h]
	push	dword ptr [eax]
	call	WinGetLastError
	add	esp,04h

; 444     return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL99:

; 445     }
; 446   return(rc);
	mov	eax,[ebp-04h];	rc
	mov	esp,ebp
	pop	ebp
	ret	
ManageProfile	endp

; 450   {
	align 010h

	public InitializeProfile
InitializeProfile	proc
	push	ebp
	mov	ebp,esp
	sub	esp,024h
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
	stosd	
	stosd	
	pop	edi
	pop	eax
	sub	esp,0ch

; 459   if ((pstInst = (PROFINST *)malloc(sizeof(PROFINST))) == NULL)
	mov	ecx,01cbh
	mov	edx,offset FLAT:@STAT33
	mov	eax,016h
	call	_debug_malloc
	mov	[ebp-014h],eax;	pstInst
	cmp	dword ptr [ebp-014h],0h;	pstInst
	jne	@BLBL100

; 460     return(NULL);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL100:

; 461   pstInst->cbInstanceData = sizeof(PROFINST);
	mov	eax,[ebp-014h];	pstInst
	mov	word ptr [eax],016h

; 462   pstInst->pstProfile = pstProfile;
	mov	eax,[ebp-014h];	pstInst
	mov	ecx,[ebp+08h];	pstProfile
	mov	[eax+02h],ecx

; 463   sprintf(&pstProfile->szIniFilePath[strlen(pstProfile->szIniFilePath)],"%s.INI",pstProfile->szProfileName);
	mov	eax,[ebp+08h];	pstProfile
	add	eax,0d9h
	call	strlen
	mov	ecx,eax
	mov	eax,[ebp+08h];	pstProfile
	add	eax,05eh
	push	eax
	mov	edx,offset FLAT:@STAT34
	mov	eax,[ebp+08h];	pstProfile
	add	eax,ecx
	add	eax,0d9h
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 464   pstInst->bObjectDeleted = FALSE;
	mov	eax,[ebp-014h];	pstInst
	mov	dword ptr [eax+06h],0h

; 465 
; 466   if ((pstInst->pStartupData = malloc(pstProfile->ulDataSize)) == 0)
	mov	eax,[ebp-014h];	pstInst
	mov	[ebp-024h],eax;	@CBE92
	mov	ecx,01d2h
	mov	edx,offset FLAT:@STAT35
	mov	eax,[ebp+08h];	pstProfile
	mov	eax,[eax+01eeh]
	call	_debug_malloc
	mov	ecx,eax
	mov	eax,[ebp-024h];	@CBE92
	mov	[eax+0ah],ecx
	cmp	dword ptr [eax+0ah],0h
	jne	@BLBL101

; 467     {
; 468     free(pstInst);
	mov	ecx,01d4h
	mov	edx,offset FLAT:@STAT36
	mov	eax,[ebp-014h];	pstInst
	call	_debug_free

; 469     return(NULL);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL101:

; 470     }
; 471   if ((pstInst->pszProfileString = malloc(pstProfile->ulMaxProfileString + 8)) == NULL)
	mov	eax,[ebp-014h];	pstInst
	mov	[ebp-020h],eax;	@CBE91
	mov	ecx,01d7h
	mov	edx,offset FLAT:@STAT37
	mov	eax,[ebp+08h];	pstProfile
	mov	eax,[eax+01e6h]
	add	eax,08h
	call	_debug_malloc
	mov	ecx,eax
	mov	eax,[ebp-020h];	@CBE91
	mov	[eax+0eh],ecx
	cmp	dword ptr [eax+0eh],0h
	jne	@BLBL102

; 472     {
; 473     free(pstInst->pStartupData);
	mov	ecx,01d9h
	mov	edx,offset FLAT:@STAT38
	mov	eax,[ebp-014h];	pstInst
	mov	eax,[eax+0ah]
	call	_debug_free

; 474     free(pstInst);
	mov	ecx,01dah
	mov	edx,offset FLAT:@STAT39
	mov	eax,[ebp-014h];	pstInst
	call	_debug_free

; 475     return(NULL);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL102:

; 476     }
; 477   if (pstProfile->stUserProfile.szAppName[0] != 0)
	mov	eax,[ebp+08h];	pstProfile
	cmp	byte ptr [eax+04h],0h
	je	@BLBL103

; 478     {
; 479     lIndex = PrfQueryProfileString(HINI_USERPROFILE,pstProfile->szProfileName,"Version",0L,pstInst->pszProfileString,pstProfile->ulMaxProfileString);
	mov	eax,[ebp+08h];	pstProfile
	push	dword ptr [eax+01e6h]
	mov	eax,[ebp-014h];	pstInst
	push	dword ptr [eax+0eh]
	push	0h
	push	offset FLAT:@STAT3a
	mov	eax,[ebp+08h];	pstProfile
	add	eax,05eh
	push	eax
	push	0ffffffffh
	call	PrfQueryProfileString
	add	esp,018h
	mov	[ebp-0ch],eax;	lIndex

; 480     if ((lIndex == 0) || (strcmp(pstInst->pszProfileString,pstProfile->stUserProfile.szVersionString)))
	cmp	dword ptr [ebp-0ch],0h;	lIndex
	je	@BLBL104
	mov	edx,[ebp+08h];	pstProfile
	add	edx,02dh
	mov	eax,[ebp-014h];	pstInst
	mov	eax,[eax+0eh]
	call	strcmp
	test	eax,eax
	je	@BLBL103
@BLBL104:

; 481       {
; 482       PrfWriteProfileString(HINI_USERPROFILE,pstProfile->szProfileName,"Version",pstProfile->stUserProfile.szVersionString);
	mov	eax,[ebp+08h];	pstProfile
	add	eax,02dh
	push	eax
	push	offset FLAT:@STAT3b
	mov	eax,[ebp+08h];	pstProfile
	add	eax,05eh
	push	eax
	push	0ffffffffh
	call	PrfWriteProfileString
	add	esp,010h

; 483       DosDelete(pstProfile->szIniFilePath);
	mov	eax,[ebp+08h];	pstProfile
	add	eax,0d9h
	push	eax
	call	DosDelete
	add	esp,04h

; 484       }

; 485     }
@BLBL103:

; 486   if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
	mov	eax,[ebp+08h];	pstProfile
	add	eax,0d9h
	push	eax
	mov	eax,[ebp+08h];	pstProfile
	push	dword ptr [eax]
	call	PrfOpenProfile
	add	esp,08h
	mov	[ebp-08h],eax;	hProfile
@BLBL106:

; 487     {
; 488     if (pstProfile->bRestart)
	mov	eax,[ebp+08h];	pstProfile
	test	byte ptr [eax+01ddh],020h
	je	@BLBL107

; 489       {
; 490       PrfQueryProfileSize(hProfile,0L,0L,&ulSize);
	lea	eax,[ebp-04h];	ulSize
	push	eax
	push	0h
	push	0h
	push	dword ptr [ebp-08h];	hProfile
	call	PrfQueryProfileSize
	add	esp,010h

; 491       if (ulSize != 0)
	cmp	dword ptr [ebp-04h],0h;	ulSize
	je	@BLBL107

; 492         {
; 493         if ((pAppNames = malloc(ulSize + 1)) == 0)
	mov	ecx,01edh
	mov	edx,offset FLAT:@STAT3c
	mov	eax,[ebp-04h];	ulSize
	inc	eax
	call	_debug_malloc
	mov	[ebp-01ch],eax;	pAppNames
	cmp	dword ptr [ebp-01ch],0h;	pAppNames
	jne	@BLBL109

; 494           {
; 495           free(pstInst->pszProfileString);
	mov	ecx,01efh
	mov	edx,offset FLAT:@STAT3d
	mov	eax,[ebp-014h];	pstInst
	mov	eax,[eax+0eh]
	call	_debug_free

; 496           free(pstInst->pStartupData);
	mov	ecx,01f0h
	mov	edx,offset FLAT:@STAT3e
	mov	eax,[ebp-014h];	pstInst
	mov	eax,[eax+0ah]
	call	_debug_free

; 497           free(pstInst);
	mov	ecx,01f1h
	mov	edx,offset FLAT:@STAT3f
	mov	eax,[ebp-014h];	pstInst
	call	_debug_free

; 498           return(NULL);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL109:

; 499           }
; 500         PrfQueryProfileString(hProfile,0L,0L,0L,pAppNames,ulSize);
	push	dword ptr [ebp-04h];	ulSize
	push	dword ptr [ebp-01ch];	pAppNames
	push	0h
	push	0h
	push	0h
	push	dword ptr [ebp-08h];	hProfile
	call	PrfQueryProfileString
	add	esp,018h

; 501         lIndex = 0;
	mov	dword ptr [ebp-0ch],0h;	lIndex

; 502         while (pAppNames[lIndex] != 0)
	mov	eax,[ebp-01ch];	pAppNames
	mov	ecx,[ebp-0ch];	lIndex
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL110
	align 010h
@BLBL111:

; 503           {
; 504           lStartIndex = lIndex;
	mov	eax,[ebp-0ch];	lIndex
	mov	[ebp-010h],eax;	lStartIndex

; 505           while(pAppNames[lIndex++] != 0)
	mov	eax,[ebp-01ch];	pAppNames
	mov	ecx,[ebp-0ch];	lIndex
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL112
	align 010h
@BLBL113:
	mov	eax,[ebp-0ch];	lIndex
	inc	eax
	mov	[ebp-0ch],eax;	lIndex

; 506             PrfWriteProfileString(hProfile,&pAppNames[lStartIndex],"Status","Available");
	push	offset FLAT:@STAT41
	push	offset FLAT:@STAT40
	mov	eax,[ebp-01ch];	pAppNames
	mov	ecx,[ebp-010h];	lStartIndex
	add	eax,ecx
	push	eax
	push	dword ptr [ebp-08h];	hProfile
	call	PrfWriteProfileString
	add	esp,010h

; 505           while(pAppNames[lIndex++] != 0)
	mov	eax,[ebp-01ch];	pAppNames
	mov	ecx,[ebp-0ch];	lIndex
	cmp	byte ptr [eax+ecx],0h
	jne	@BLBL113
@BLBL112:
	mov	eax,[ebp-0ch];	lIndex
	inc	eax
	mov	[ebp-0ch],eax;	lIndex

; 507           }

; 502         while (pAppNames[lIndex] != 0)
	mov	eax,[ebp-01ch];	pAppNames
	mov	ecx,[ebp-0ch];	lIndex
	cmp	byte ptr [eax+ecx],0h
	jne	@BLBL111
@BLBL110:

; 508         free(pAppNames);
	mov	ecx,01fch
	mov	edx,offset FLAT:@STAT42
	mov	eax,[ebp-01ch];	pAppNames
	call	_debug_free

; 509         }

; 510       }
@BLBL107:

; 511     if (pstProfile->bSearchApps)
	mov	eax,[ebp+08h];	pstProfile
	test	byte ptr [eax+01ddh],08h
	je	@BLBL117

; 513       lTemp = strlen(pstProfile->szAppName);
	mov	eax,[ebp+08h];	pstProfile
	add	eax,087h
	call	strlen
	mov	[ebp-018h],eax;	lTemp

; 514       for (lIndex = 1;lIndex <= pstProfile->ulMaxApps;lIndex++)
	mov	dword ptr [ebp-0ch],01h;	lIndex
	mov	eax,[ebp+08h];	pstProfile
	mov	ecx,[ebp-0ch];	lIndex
	cmp	[eax+01eah],ecx
	jb	@BLBL118
	align 010h
@BLBL119:

; 516         pstProfile->szAppName[lTemp] = ' ';
	mov	eax,[ebp+08h];	pstProfile
	mov	ecx,[ebp-018h];	lTemp
	mov	byte ptr [eax+ecx+087h],020h

; 517         itoa(lIndex,&(pstProfile->szAppName[lTemp + 1]),10);
	mov	ecx,0ah
	mov	edx,[ebp+08h];	pstProfile
	mov	eax,[ebp-018h];	lTemp
	add	edx,eax
	add	edx,088h
	mov	eax,[ebp-0ch];	lIndex
	call	_itoa

; 518         if ((PrfQueryProfileString(hProfile,pstProfile->szAppName,
	mov	eax,[ebp+08h];	pstProfile
	push	dword ptr [eax+01e6h]
	mov	eax,[ebp-014h];	pstInst
	push	dword ptr [eax+0eh]
	push	0h
	push	offset FLAT:@STAT43
	mov	eax,[ebp+08h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-08h];	hProfile
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	jne	@BLBL120

; 521           PrfWriteProfileString(hProfile,pstProfile->szAppName,"Status","In Use");
	push	offset FLAT:@STAT45
	push	offset FLAT:@STAT44
	mov	eax,[ebp+08h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-08h];	hProfile
	call	PrfWriteProfileString
	add	esp,010h

; 522           PrfWriteProfileData(hProfile,pstProfile->szAppName,
	mov	eax,[ebp+08h];	pstProfile
	push	dword ptr [eax+01eeh]
	mov	eax,[ebp+08h];	pstProfile
	push	dword ptr [eax+01f2h]
	push	offset FLAT:@STAT46
	mov	eax,[ebp+08h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-08h];	hProfile
	call	PrfWriteProfileData
	add	esp,014h

; 524           break;
	jmp	@BLBL118
	align 010h
@BLBL120:

; 528           if (strcmp(pstInst->pszProfileString,"Available") == 0)
	mov	edx,offset FLAT:@STAT47
	mov	eax,[ebp-014h];	pstInst
	mov	eax,[eax+0eh]
	call	strcmp
	test	eax,eax
	jne	@BLBL122

; 530             PrfWriteProfileString(hProfile,pstProfile->szAppName,"Status","In Use");
	push	offset FLAT:@STAT49
	push	offset FLAT:@STAT48
	mov	eax,[ebp+08h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-08h];	hProfile
	call	PrfWriteProfileString
	add	esp,010h

; 531             if (!PrfQueryProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,&(pstProfile->ulDataSize)))
	mov	eax,[ebp+08h];	pstProfile
	add	eax,01eeh
	push	eax
	mov	eax,[ebp+08h];	pstProfile
	push	dword ptr [eax+01f2h]
	push	offset FLAT:@STAT4a
	mov	eax,[ebp+08h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-08h];	hProfile
	call	PrfQueryProfileData
	add	esp,014h
	test	eax,eax
	jne	@BLBL118

; 532               PrfWriteProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,pstProfile->ulDataSize);
	mov	eax,[ebp+08h];	pstProfile
	push	dword ptr [eax+01eeh]
	mov	eax,[ebp+08h];	pstProfile
	push	dword ptr [eax+01f2h]
	push	offset FLAT:@STAT4b
	mov	eax,[ebp+08h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-08h];	hProfile
	call	PrfWriteProfileData
	add	esp,014h

; 533             break;
	jmp	@BLBL118
	align 010h
@BLBL122:

; 536         }

; 514       for (lIndex = 1;lIndex <= pstProfile->ulMaxApps;lIndex++)
	mov	eax,[ebp-0ch];	lIndex
	inc	eax
	mov	[ebp-0ch],eax;	lIndex
	mov	eax,[ebp+08h];	pstProfile
	mov	ecx,[ebp-0ch];	lIndex
	cmp	[eax+01eah],ecx
	jae	@BLBL119
@BLBL118:

; 537       if (lIndex > pstProfile->ulMaxApps)
	mov	eax,[ebp+08h];	pstProfile
	mov	ecx,[ebp-0ch];	lIndex
	cmp	[eax+01eah],ecx
	jae	@BLBL126

; 538         pstProfile->szAppName[0] = 0; // if there are no usable apps at the end of the loop then clear "app name"
	mov	eax,[ebp+08h];	pstProfile
	mov	byte ptr [eax+087h],0h

; 539       }
	jmp	@BLBL126
	align 010h
@BLBL117:

; 542       PrfWriteProfileString(hProfile,pstProfile->szAppName,"Status","In Use");
	push	offset FLAT:@STAT4d
	push	offset FLAT:@STAT4c
	mov	eax,[ebp+08h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-08h];	hProfile
	call	PrfWriteProfileString
	add	esp,010h

; 543       ulSize = pstProfile->ulDataSize;
	mov	eax,[ebp+08h];	pstProfile
	mov	eax,[eax+01eeh]
	mov	[ebp-04h],eax;	ulSize

; 544       if (!PrfQueryProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,&ulSize))
	lea	eax,[ebp-04h];	ulSize
	push	eax
	mov	eax,[ebp+08h];	pstProfile
	push	dword ptr [eax+01f2h]
	push	offset FLAT:@STAT4e
	mov	eax,[ebp+08h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-08h];	hProfile
	call	PrfQueryProfileData
	add	esp,014h
	test	eax,eax
	jne	@BLBL126

; 545         PrfWriteProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,pstProfile->ulDataSize);
	mov	eax,[ebp+08h];	pstProfile
	push	dword ptr [eax+01eeh]
	mov	eax,[ebp+08h];	pstProfile
	push	dword ptr [eax+01f2h]
	push	offset FLAT:@STAT4f
	mov	eax,[ebp+08h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-08h];	hProfile
	call	PrfWriteProfileData
	add	esp,014h

; 546       }
@BLBL126:

; 547     PrfCloseProfile(hProfile);
	push	dword ptr [ebp-08h];	hProfile
	call	PrfCloseProfile
	add	esp,04h

; 548     }

; 549   memcpy(pstInst->pStartupData,pstProfile->pData,pstProfile->ulDataSize);
	mov	ecx,[ebp+08h];	pstProfile
	mov	ecx,[ecx+01eeh]
	mov	edx,[ebp+08h];	pstProfile
	mov	edx,[edx+01f2h]
	mov	eax,[ebp-014h];	pstInst
	mov	eax,[eax+0ah]
	call	memcpy

; 550   return(pstInst);
	mov	eax,[ebp-014h];	pstInst
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
InitializeProfile	endp

; 554   {
	align 010h

	public CloseProfile
CloseProfile	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0a8h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,02ah
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 560   if (pstInst != NULL)
	cmp	dword ptr [ebp+08h],0h;	pstInst
	je	@BLBL128

; 561     {
; 562     pstProfile = pstInst->pstProfile;
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+02h]
	mov	[ebp-04h],eax;	pstProfile

; 563     if (pstInst->bObjectDeleted)
	mov	eax,[ebp+08h];	pstInst
	cmp	dword ptr [eax+06h],0h
	je	@BLBL129

; 564       DeleteProfileApps(pstInst);
	push	dword ptr [ebp+08h];	pstInst
	call	DeleteProfileApps
	add	esp,04h
@BLBL129:

; 565     if (pstProfile->szAppName[0] != 0)
	mov	eax,[ebp-04h];	pstProfile
	cmp	byte ptr [eax+087h],0h
	je	@BLBL130

; 566       {
; 567       if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
	mov	eax,[ebp-04h];	pstProfile
	add	eax,0d9h
	push	eax
	mov	eax,[ebp-04h];	pstProfile
	push	dword ptr [eax]
	call	PrfOpenProfile
	add	esp,08h
	mov	[ebp-08h],eax;	hProfile
@BLBL131:

; 568         {
; 569         PrfWriteProfileString(hProfile,pstProfile->szAppName,"Status","Available");
	push	offset FLAT:@STAT51
	push	offset FLAT:@STAT50
	mov	eax,[ebp-04h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-08h];	hProfile
	call	PrfWriteProfileString
	add	esp,010h

; 570         if (pstProfile->pData != NULL)
	mov	eax,[ebp-04h];	pstProfile
	cmp	dword ptr [eax+01f2h],0h
	je	@BLBL132

; 571           {
; 572           if (memcmp(pstInst->pStartupData,pstProfile->pData,pstProfile->ulDataSize) != 0)
	mov	ecx,[ebp-04h];	pstProfile
	mov	ecx,[ecx+01eeh]
	mov	edx,[ebp-04h];	pstProfile
	mov	edx,[edx+01f2h]
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+0ah]
	call	memcmp
	test	eax,eax
	je	@BLBL132

; 573             {
; 574             if (!pstProfile->bAutoSaveProfile)
	mov	eax,[ebp-04h];	pstProfile
	test	byte ptr [eax+01ddh],04h
	jne	@BLBL134

; 575               {
; 576               sprintf(szCaption,"Application Profile has Changed.");
	mov	edx,offset FLAT:@STAT52
	lea	eax,[ebp-058h];	szCaption
	call	_sprintfieee

; 577               sprintf(szMessage,"Do you want to save the profile \"%s\"?",pstProfile->szAppName);
	mov	eax,[ebp-04h];	pstProfile
	add	eax,087h
	push	eax
	mov	edx,offset FLAT:@STAT53
	lea	eax,[ebp-0a8h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 578               if
; 578  (WinMessageBox(HWND_DESKTOP,
	push	04014h
	push	0h
	lea	eax,[ebp-058h];	szCaption
	push	eax
	lea	eax,[ebp-0a8h];	szMessage
	push	eax
	mov	eax,[ebp-04h];	pstProfile
	push	dword ptr [eax+01e2h]
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,06h
	jne	@BLBL132

; 579                                 pstProfile->hwndOwner,
; 580                                 szMessage,
; 581                                 szCaption,
; 582                                 0L,
; 583                                (MB_MOVEABLE | MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON1)) == MBID_YES)
; 584                 PrfWriteProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,pstProfile->ulDataSize);
	mov	eax,[ebp-04h];	pstProfile
	push	dword ptr [eax+01eeh]
	mov	eax,[ebp-04h];	pstProfile
	push	dword ptr [eax+01f2h]
	push	offset FLAT:@STAT54
	mov	eax,[ebp-04h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-08h];	hProfile
	call	PrfWriteProfileData
	add	esp,014h

; 585               }
	jmp	@BLBL132
	align 010h
@BLBL134:

; 586             else
; 587               PrfWriteProfileData(hProfile,pstProfile->szAppName,"Setup",pstProfile->pData,pstProfile->ulDataSize);
	mov	eax,[ebp-04h];	pstProfile
	push	dword ptr [eax+01eeh]
	mov	eax,[ebp-04h];	pstProfile
	push	dword ptr [eax+01f2h]
	push	offset FLAT:@STAT55
	mov	eax,[ebp-04h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-08h];	hProfile
	call	PrfWriteProfileData
	add	esp,014h

; 588             }

; 589           }
@BLBL132:

; 590         PrfCloseProfile(hProfile);
	push	dword ptr [ebp-08h];	hProfile
	call	PrfCloseProfile
	add	esp,04h

; 591         }

; 592       }
@BLBL130:

; 593     free(pstInst->pszProfileString);
	mov	ecx,0251h
	mov	edx,offset FLAT:@STAT56
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+0eh]
	call	_debug_free

; 594     free(pstInst->pStartupData);
	mov	ecx,0252h
	mov	edx,offset FLAT:@STAT57
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+0ah]
	call	_debug_free

; 595     free(pstInst);
	mov	ecx,0253h
	mov	edx,offset FLAT:@STAT58
	mov	eax,[ebp+08h];	pstInst
	call	_debug_free

; 596     }
@BLBL128:

; 597   return(NULL);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
CloseProfile	endp

; 601   {
	align 010h

	public SaveProfileString
SaveProfileString	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax
	sub	esp,04h

; 605   if (pstInst == (HPROF)NULL)
	cmp	dword ptr [ebp+08h],0h;	pstInst
	jne	@BLBL137

; 606     return(FALSE);
	xor	eax,eax
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL137:

; 607   pstProfile = pstInst->pstProfile;
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+02h]
	mov	[ebp-08h],eax;	pstProfile

; 608   if (pstProfile->szAppName[0] != 0)
	mov	eax,[ebp-08h];	pstProfile
	cmp	byte ptr [eax+087h],0h
	je	@BLBL138

; 609     {
; 610     if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
	mov	eax,[ebp-08h];	pstProfile
	add	eax,0d9h
	push	eax
	mov	eax,[ebp-08h];	pstProfile
	push	dword ptr [eax]
	call	PrfOpenProfile
	add	esp,08h
	mov	[ebp-04h],eax;	hProfile
@BLBL139:

; 611       {
; 612       if (pszString != NULL)
	cmp	dword ptr [ebp+010h],0h;	pszString
	je	@BLBL140

; 613         if (strlen(pszString) == 0)
	mov	eax,[ebp+010h];	pszString
	call	strlen
	test	eax,eax
	jne	@BLBL140

; 614           pszString = NULL;
	mov	dword ptr [ebp+010h],0h;	pszString
@BLBL140:

; 615       PrfWriteProfileString(hProfile,pstProfile->szAppName,szStringKey,pszString);
	push	dword ptr [ebp+010h];	pszString
	push	dword ptr [ebp+0ch];	szStringKey
	mov	eax,[ebp-08h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-04h];	hProfile
	call	PrfWriteProfileString
	add	esp,010h

; 616       PrfCloseProfile(hProfile);
	push	dword ptr [ebp-04h];	hProfile
	call	PrfCloseProfile
	add	esp,04h

; 617       }

; 618     }
@BLBL138:

; 619   return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
SaveProfileString	endp

; 623   {
	align 010h

	public GetProfileString
GetProfileString	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax

; 628   if (pstInst == (HPROF)NULL)
	cmp	dword ptr [ebp+08h],0h;	pstInst
	jne	@BLBL142

; 629     return(0);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL142:

; 630   pstProfile = pstInst->pstProfile;
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+02h]
	mov	[ebp-08h],eax;	pstProfile

; 631   if (pstProfile->szAppName[0] != 0)
	mov	eax,[ebp-08h];	pstProfile
	cmp	byte ptr [eax+087h],0h
	je	@BLBL143

; 632     {
; 633     if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
	mov	eax,[ebp-08h];	pstProfile
	add	eax,0d9h
	push	eax
	mov	eax,[ebp-08h];	pstProfile
	push	dword ptr [eax]
	call	PrfOpenProfile
	add	esp,08h
	mov	[ebp-04h],eax;	hProfile
@BLBL144:

; 634       {
; 635 
; 636       ulSize = PrfQueryProfileString(hProfile,pstProfile->szAppName,szStringKey,0,pszString,ulMaxSize);
	push	dword ptr [ebp+014h];	ulMaxSize
	push	dword ptr [ebp+010h];	pszString
	push	0h
	push	dword ptr [ebp+0ch];	szStringKey
	mov	eax,[ebp-08h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-04h];	hProfile
	call	PrfQueryProfileString
	add	esp,018h
	mov	[ebp-0ch],eax;	ulSize

; 637       PrfCloseProfile(hProfile);
	push	dword ptr [ebp-04h];	hProfile
	call	PrfCloseProfile
	add	esp,04h

; 638       }

; 639     }
@BLBL143:

; 640   return(ulSize);
	mov	eax,[ebp-0ch];	ulSize
	mov	esp,ebp
	pop	ebp
	ret	
GetProfileString	endp

; 644   {
	align 010h

	public SaveProfileData
SaveProfileData	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax

; 647   BOOL bSuccess = FALSE;
	mov	dword ptr [ebp-0ch],0h;	bSuccess

; 648 
; 649   if (pstInst == (HPROF)NULL)
	cmp	dword ptr [ebp+08h],0h;	pstInst
	jne	@BLBL145

; 650     return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL145:

; 651   pstProfile = pstInst->pstProfile;
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+02h]
	mov	[ebp-08h],eax;	pstProfile

; 652   if (pstProfile->szAppName[0] != 0)
	mov	eax,[ebp-08h];	pstProfile
	cmp	byte ptr [eax+087h],0h
	je	@BLBL146

; 653     {
; 654     if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
	mov	eax,[ebp-08h];	pstProfile
	add	eax,0d9h
	push	eax
	mov	eax,[ebp-08h];	pstProfile
	push	dword ptr [eax]
	call	PrfOpenProfile
	add	esp,08h
	mov	[ebp-04h],eax;	hProfile
@BLBL147:

; 655       {
; 656       if (ulSize == 0)
	cmp	dword ptr [ebp+014h],0h;	ulSize
	jne	@BLBL148

; 657         pData = NULL;
	mov	dword ptr [ebp+010h],0h;	pData
@BLBL148:

; 658       if (PrfWriteProfileData(hProfile,pstProfile->szAppName,szStringKey,pData,ulSize))
	push	dword ptr [ebp+014h];	ulSize
	push	dword ptr [ebp+010h];	pData
	push	dword ptr [ebp+0ch];	szStringKey
	mov	eax,[ebp-08h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-04h];	hProfile
	call	PrfWriteProfileData
	add	esp,014h
	test	eax,eax
	je	@BLBL149

; 659         bSuccess = TRUE;
	mov	dword ptr [ebp-0ch],01h;	bSuccess
@BLBL149:

; 660       PrfCloseProfile(hProfile);
	push	dword ptr [ebp-04h];	hProfile
	call	PrfCloseProfile
	add	esp,04h

; 661       }

; 662     }
@BLBL146:

; 663   return(bSuccess);
	mov	eax,[ebp-0ch];	bSuccess
	mov	esp,ebp
	pop	ebp
	ret	
SaveProfileData	endp

; 667   {
	align 010h

	public GetProfileData
GetProfileData	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax

; 670   ULONG ulSize = 0;
	mov	dword ptr [ebp-0ch],0h;	ulSize

; 671 
; 672   if (pstInst == (HPROF)NULL)
	cmp	dword ptr [ebp+08h],0h;	pstInst
	jne	@BLBL150

; 673     return(0);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL150:

; 674   pstProfile = pstInst->pstProfile;
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+02h]
	mov	[ebp-08h],eax;	pstProfile

; 675   if (pstProfile->szAppName[0] != 0)
	mov	eax,[ebp-08h];	pstProfile
	cmp	byte ptr [eax+087h],0h
	je	@BLBL151

; 676     {
; 677     if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
	mov	eax,[ebp-08h];	pstProfile
	add	eax,0d9h
	push	eax
	mov	eax,[ebp-08h];	pstProfile
	push	dword ptr [eax]
	call	PrfOpenProfile
	add	esp,08h
	mov	[ebp-04h],eax;	hProfile
@BLBL152:

; 678       {
; 679       ulSize = ulMaxSize;
	mov	eax,[ebp+014h];	ulMaxSize
	mov	[ebp-0ch],eax;	ulSize

; 680       if (!PrfQueryProfileData(hProfile,pstProfile->szAppName,szStringKey,pData,&ulSize))
	lea	eax,[ebp-0ch];	ulSize
	push	eax
	push	dword ptr [ebp+010h];	pData
	push	dword ptr [ebp+0ch];	szStringKey
	mov	eax,[ebp-08h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-04h];	hProfile
	call	PrfQueryProfileData
	add	esp,014h
	test	eax,eax
	jne	@BLBL153

; 681         ulSize = 0;
	mov	dword ptr [ebp-0ch],0h;	ulSize
@BLBL153:

; 682       PrfCloseProfile(hProfile);
	push	dword ptr [ebp-04h];	hProfile
	call	PrfCloseProfile
	add	esp,04h

; 683       }

; 684     }
@BLBL151:

; 685   return(ulSize);
	mov	eax,[ebp-0ch];	ulSize
	mov	esp,ebp
	pop	ebp
	ret	
GetProfileData	endp

; 689   {
	align 010h

	public SaveProfileWindowPos
SaveProfileWindowPos	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 691   PROFILE *pstProfile = pstInst->pstProfile;
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+02h]
	mov	[ebp-08h],eax;	pstProfile

; 692 
; 693   if (pstProfile->szAppName[0] != 0)
	mov	eax,[ebp-08h];	pstProfile
	cmp	byte ptr [eax+087h],0h
	je	@BLBL154

; 694     {
; 695     if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
	mov	eax,[ebp-08h];	pstProfile
	add	eax,0d9h
	push	eax
	mov	eax,[ebp-08h];	pstProfile
	push	dword ptr [eax]
	call	PrfOpenProfile
	add	esp,08h
	mov	[ebp-04h],eax;	hProfile
@BLBL155:

; 696       {
; 697       PrfWriteProfileData(hProfile,pstProfile->szAppName,szWindowKey,&swp,sizeof(SWP));
	push	024h
	lea	eax,[ebp+010h];	swp
	push	eax
	push	dword ptr [ebp+0ch];	szWindowKey
	mov	eax,[ebp-08h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-04h];	hProfile
	call	PrfWriteProfileData
	add	esp,014h

; 698       PrfCloseProfile(hProfile);
	push	dword ptr [ebp-04h];	hProfile
	call	PrfCloseProfile
	add	esp,04h

; 699       }

; 700     }
@BLBL154:

; 701   }
	mov	esp,ebp
	pop	ebp
	ret	
SaveProfileWindowPos	endp

; 704   {
	align 010h

	public GetProfileWindowPos
GetProfileWindowPos	proc
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

; 707   BOOL bStatus = FALSE;
	mov	dword ptr [ebp-0ch],0h;	bStatus

; 708   PROFILE *pstProfile = pstInst->pstProfile;
	mov	eax,[ebp+08h];	pstInst
	mov	eax,[eax+02h]
	mov	[ebp-010h],eax;	pstProfile

; 709 
; 710   if (pstProfile->szAppName[0] != 0)
	mov	eax,[ebp-010h];	pstProfile
	cmp	byte ptr [eax+087h],0h
	je	@BLBL156

; 711     {
; 712     if ((hProfile = PrfOpenProfile(pstProfile->hab,pstProfile->szIniFilePath)) != 0);
	mov	eax,[ebp-010h];	pstProfile
	add	eax,0d9h
	push	eax
	mov	eax,[ebp-010h];	pstProfile
	push	dword ptr [eax]
	call	PrfOpenProfile
	add	esp,08h
	mov	[ebp-04h],eax;	hProfile
@BLBL157:

; 713       {
; 714       ulSize = sizeof(SWP);
	mov	dword ptr [ebp-08h],024h;	ulSize

; 715       if (PrfQueryProfileData(hProfile,pstProfile->szAppName,szWindowKey,pswp,&ulSize))
	lea	eax,[ebp-08h];	ulSize
	push	eax
	push	dword ptr [ebp+010h];	pswp
	push	dword ptr [ebp+0ch];	szWindowKey
	mov	eax,[ebp-010h];	pstProfile
	add	eax,087h
	push	eax
	push	dword ptr [ebp-04h];	hProfile
	call	PrfQueryProfileData
	add	esp,014h
	test	eax,eax
	je	@BLBL158

; 716         bStatus = TRUE;
	mov	dword ptr [ebp-0ch],01h;	bStatus
@BLBL158:

; 717       PrfCloseProfile(hProfile);
	push	dword ptr [ebp-04h];	hProfile
	call	PrfCloseProfile
	add	esp,04h

; 718       }

; 719     }
@BLBL156:

; 720   return(bStatus);
	mov	eax,[ebp-0ch];	bStatus
	mov	esp,ebp
	pop	ebp
	ret	
GetProfileWindowPos	endp

; 724   {
	align 010h

	public DisplayHelpPanel
DisplayHelpPanel	proc
	push	ebp
	mov	ebp,esp

; 725   if (hwndHelpInstance != 0)
	cmp	dword ptr [ebp+08h],0h;	hwndHelpInstance
	je	@BLBL159

; 726     {
; 727     if (WinSendMsg(hwndHelpInstance,HM_DISPLAY_HELP,
	push	0h
	mov	ax,[ebp+0ch];	idPanel
	and	eax,0ffffh
	push	eax
	push	0222h
	push	dword ptr [ebp+08h];	hwndHelpInstance
	call	WinSendMsg
	add	esp,010h
	test	eax,eax
	je	@BLBL161

; 728                    MPFROM2SHORT(idPanel,NULL),MPFROMSHORT(HM_RESOURCEID)))
; 729        MessageBox(HWND_DESKTOP,"Unable to display Help Panel");
	push	offset FLAT:@STAT59
	push	01h
	call	MessageBox
	add	esp,08h

; 730     }
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL159:

; 731   else
; 732     MessageBox(HWND_DESKTOP,"Help is not Initialized");
	push	offset FLAT:@STAT5a
	push	01h
	call	MessageBox
	add	esp,08h
@BLBL161:

; 733   }
	mov	esp,ebp
	pop	ebp
	ret	
DisplayHelpPanel	endp
CODE32	ends
end
