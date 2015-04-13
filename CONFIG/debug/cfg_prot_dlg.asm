	title	p:\config\cfg_prot_dlg.c
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
	extrn	WinSetDlgItemText:proc
	extrn	FillCfgFilterDlg:proc
	extrn	WinPostMsg:proc
	extrn	WinSendMsg:proc
	extrn	TCCfgFilterDlg:proc
	extrn	UnloadCfgFilterDlg:proc
	extrn	WinDefDlgProc:proc
	extrn	memcpy:proc
	extrn	FillCfgTimeoutDlg:proc
	extrn	WinWindowFromID:proc
	extrn	WinSetFocus:proc
	extrn	TCCfgTimeoutDlg:proc
	extrn	UnloadCfgTimeoutDlg:proc
	extrn	FillCfgProtocolDlg:proc
	extrn	TCCfgProtocolDlg:proc
	extrn	UnloadCfgProtocolDlg:proc
	extrn	WinSendDlgItemMsg:proc
	extrn	_ltoa:proc
	extrn	WinQueryDlgItemText:proc
	extrn	atol:proc
	extrn	FillHDWhandshakDlg:proc
	extrn	UnloadHDWhandshakDlg:proc
	extrn	FillASCIIhandshakingDlg:proc
	extrn	TCASCIIhandshakeDlg:proc
	extrn	UnloadASCIIhandshakeDlg:proc
	extrn	_sprintfieee:proc
	extrn	_fullDump:dword
	extrn	bInsertNewDevice:dword
	extrn	hwndNoteBookDlg:dword
	extrn	aulCfgExtBaudTable:byte
	extrn	lOrgXonHysteresis:dword
	extrn	lOrgXoffThreshold:dword
DATA32	segment
@STAT1	db "S~ave",0h
	align 04h
@STAT2	db "Port stream filter confi"
db "guration",0h
	align 04h
@STAT3	db "S~ave",0h
	align 04h
@STAT4	db "Port timeout configurati"
db "on",0h
	align 04h
@STAT5	db "S~ave",0h
	align 04h
@STAT6	db "Port line characteristic"
db "s configuration",0h
@STAT7	db "S~ave",0h
	align 04h
@STAT8	db "Port baud rate configura"
db "tion",0h
	align 04h
@STAT9	db "S~ave",0h
	align 04h
@STATa	db "Hardware handshake confi"
db "guration",0h
	align 04h
@STATb	db "S~ave",0h
	align 04h
@STATc	db "Port ASCII handshaking c"
db "onfiguration",0h
	align 04h
@STATd	db "S~ave",0h
	dd	_dllentry
DATA32	ends
CONST32_RO	segment
@2szBuffSizeFormat	db "Receive buffer size is %"
db "u bytes",0h
CONST32_RO	ends
BSS32	segment
	align 04h
comm	lXonHysteresis:dword
	align 04h
comm	lXoffThreshold:dword
	align 04h
comm	ulReadBufLen:dword
@bbAllowClick	dd 0h
@cpstPage	dd 0h
@dpstComDCB	dd 0h
@21pstPage	dd 0h
@22pstComDCB	dd 0h
@23stComDCB	db 02ah DUP (0h)
	align 04h
@24bAllowClick	dd 0h
@30bAllowClick	dd 0h
@31pstPage	dd 0h
@32pbyLineChar	dd 0h
@3bbAllowClick	dd 0h
@3cpstPage	dd 0h
@3eszBaud	db 0ch DUP (0h)
@40iCurrentBaudIndex	dd 0h
@41pulBaud	dd 0h
@52pstPage	dd 0h
@53pstComDCB	dd 0h
@54bAllowClick	dd 0h
@5fpstPage	dd 0h
@60pstComDCB	dd 0h
@61bAllowClick	dd 0h
@6apstPage	dd 0h
@6bpstComDCB	dd 0h
@6cbAllowChange	dd 0h
BSS32	ends
CODE32	segment

; 44   {
	align 010h

	public fnwpCfgFilterDlg
fnwpCfgFilterDlg	proc
	push	ebp
	mov	ebp,esp

; 49   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL6
	align 04h
@BLBL7:

; 50     {
; 51     case WM_INITDLG:
; 52       if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL1

; 53         WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
	push	offset FLAT:@STAT1
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL1:

; 54 //        ControlEnable(hwndDlg,DID_INSERT,FALSE);
; 55 //      CenterDlgBox(hwndDlg);
; 56       bAllowClick = FALSE;
	mov	dword ptr  @bbAllowClick,0h

; 57       pstPage = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @cpstPage,eax

; 58       pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @cpstPage
	and	byte ptr [eax+02ah],0feh

; 59       pstComDCB = pstPage->pVoidPtrOne;
	mov	eax,dword ptr  @cpstPage
	mov	eax,[eax+06h]
	mov	dword ptr  @dpstComDCB,eax

; 60       FillCfgFilterDlg(hwndDlg,pstComDCB);
	push	dword ptr  @dpstComDCB
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillCfgFilterDlg
	add	esp,08h

; 61       if (pstPage->bSpoolerConfig)
	mov	eax,dword ptr  @cpstPage
	test	byte ptr [eax+02ah],010h
	je	@BLBL2

; 62         WinSetDlgItemText(hwndDlg,ST_TITLE,"Port stream filter configuration");
	push	offset FLAT:@STAT2
	push	0578h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL2:

; 63       WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	02710h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinPostMsg
	add	esp,010h

; 64       break;
	jmp	@BLBL5
	align 04h
@BLBL8:

; 65     case UM_INITLS:
; 66       bAllowClick = TRUE;
	mov	dword ptr  @bbAllowClick,01h

; 67       break;
	jmp	@BLBL5
	align 04h
@BLBL9:

; 68     case WM_COMMAND:
; 69       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL11
	align 04h
@BLBL12:

; 70         {
; 71         case DID_INSERT:
; 72            WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
	push	0h
	push	0h
	push	02714h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 73            break;
	jmp	@BLBL10
	align 04h
@BLBL13:

; 74         case DID_CANCEL:
; 75           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 76           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL14:

; 77         case DID_HELP:
; 78           WinSendMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
	push	0h
	push	012dh
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinSendMsg
	add	esp,010h

; 79           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL15:

; 80         case DID_UNDO:
; 81           pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @cpstPage
	and	byte ptr [eax+02ah],0feh

; 82           bAllowClick = FALSE;
	mov	dword ptr  @bbAllowClick,0h

; 83           FillCfgFilterDlg(hwndDlg,pstComDCB);
	push	dword ptr  @dpstComDCB
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillCfgFilterDlg
	add	esp,08h

; 84           bAllowClick = TRUE;
	mov	dword ptr  @bbAllowClick,01h

; 85           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL10
	align 04h
@BLBL11:
	cmp	eax,0130h
	je	@BLBL12
	cmp	eax,02h
	je	@BLBL13
	cmp	eax,012dh
	je	@BLBL14
	cmp	eax,0135h
	je	@BLBL15
@BLBL10:

; 86         }
; 87       break;
	jmp	@BLBL5
	align 04h
@BLBL16:

; 88     case WM_CONTROL:
; 89       if(SHORT2FROMMP(mp1) == BN_CLICKED)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL3

; 90         {
; 91         if (bAllowClick)
	cmp	dword ptr  @bbAllowClick,0h
	je	@BLBL3

; 92           {
; 93           pstPage->bDirtyBit = TRUE;
	mov	eax,dword ptr  @cpstPage
	or	byte ptr [eax+02ah],01h

; 94           TCCfgFilterDlg(hwndDlg,SHORT1FROMMP(mp1));
	mov	ax,[ebp+010h];	mp1
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	TCCfgFilterDlg
	add	esp,08h

; 95           }

; 96         }
@BLBL3:

; 97       break;
	jmp	@BLBL5
	align 04h
@BLBL17:

; 98     case UM_SAVE_DATA:
; 99       UnloadCfgFilterDlg(hwndDlg,pstComDCB);
	push	dword ptr  @dpstComDCB
	push	dword ptr [ebp+08h];	hwndDlg
	call	UnloadCfgFilterDlg
	add	esp,08h

; 100       return((MRESULT)TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL18:

; 101     default:
; 102       return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDefDlgProc
	add	esp,010h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL5
	align 04h
@BLBL6:
	cmp	eax,03bh
	je	@BLBL7
	cmp	eax,02710h
	je	@BLBL8
	cmp	eax,020h
	je	@BLBL9
	cmp	eax,030h
	je	@BLBL16
	cmp	eax,02711h
	je	@BLBL17
	jmp	@BLBL18
	align 04h
@BLBL5:

; 103     }
; 104   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpCfgFilterDlg	endp

; 111   {
	align 010h

	public fnwpCfgTimeoutDlg
fnwpCfgTimeoutDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch

; 117   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL23
	align 04h
@BLBL24:

; 118     {
; 119     case WM_INITDLG:
; 120       if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL19

; 121         WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
	push	offset FLAT:@STAT3
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL19:

; 122 //        ControlEnable(hwndDlg,DID_INSERT,FALSE);
; 123       bAllowClick = FALSE;
	mov	dword ptr  @24bAllowClick,0h

; 124       pstPage = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @21pstPage,eax

; 125       pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @21pstPage
	and	byte ptr [eax+02ah],0feh

; 126       pstComDCB = pstPage->pVoidPtrOne;
	mov	eax,dword ptr  @21pstPage
	mov	eax,[eax+06h]
	mov	dword ptr  @22pstComDCB,eax

; 127       memcpy(&stComDCB,pstComDCB,sizeof(COMDCB));
	mov	ecx,02ah
	mov	edx,dword ptr  @22pstComDCB
	mov	eax,offset FLAT:@23stComDCB
	call	memcpy

; 128       FillCfgTimeoutDlg(hwndDlg,&stComDCB);      // required for potential TOP pages only (so far)
	push	offset FLAT:@23stComDCB
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillCfgTimeoutDlg
	add	esp,08h

; 129       if (pstPage->bSpoolerConfig)
	mov	eax,dword ptr  @21pstPage
	test	byte ptr [eax+02ah],010h
	je	@BLBL20

; 130         WinSetDlgItemText(hwndDlg,ST_TITLE,"Port timeout configuration");
	push	offset FLAT:@STAT4
	push	0578h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL20:

; 131       WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	02710h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinPostMsg
	add	esp,010h

; 132       break;
	jmp	@BLBL22
	align 04h
@BLBL25:

; 133     case UM_INITLS:
; 134       bAllowClick = TRUE;
	mov	dword ptr  @24bAllowClick,01h

; 135       break;
	jmp	@BLBL22
	align 04h
@BLBL26:

; 136     case UM_SET_FOCUS:
; 137       WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	eax
	push	01h
	call	WinSetFocus
	add	esp,08h

; 138       break;
	jmp	@BLBL22
	align 04h
@BLBL27:

; 139     case WM_COMMAND:
; 140       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL29
	align 04h
@BLBL30:

; 141         {
; 142         case DID_INSERT:
; 143            WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
	push	0h
	push	0h
	push	02714h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 144            break;
	jmp	@BLBL28
	align 04h
@BLBL31:

; 145         case DID_CANCEL:
; 146           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 147           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL32:

; 148         case DID_HELP:
; 149           WinSendMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
	push	0h
	push	012dh
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinSendMsg
	add	esp,010h

; 150           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL33:

; 151         case DID_UNDO:
; 152           bAllowClick = FALSE;
	mov	dword ptr  @24bAllowClick,0h

; 153           pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @21pstPage
	and	byte ptr [eax+02ah],0feh

; 154           FillCfgTimeoutDlg(hwndDlg,&stComDCB);
	push	offset FLAT:@23stComDCB
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillCfgTimeoutDlg
	add	esp,08h

; 155           bAllowClick = TRUE;
	mov	dword ptr  @24bAllowClick,01h

; 156           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL28
	align 04h
@BLBL29:
	cmp	eax,0130h
	je	@BLBL30
	cmp	eax,02h
	je	@BLBL31
	cmp	eax,012dh
	je	@BLBL32
	cmp	eax,0135h
	je	@BLBL33
@BLBL28:

; 157         }
; 158       break;
	jmp	@BLBL22
	align 04h
@BLBL34:

; 159     case WM_CONTROL:
; 160       if (bAllowClick)
	cmp	dword ptr  @24bAllowClick,0h
	je	@BLBL21

; 161         {
; 162         switch (SHORT2FROMMP(mp1))
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	and	eax,0ffffh
	jmp	@BLBL36
	align 04h
@BLBL37:

; 163           {
; 164           case BN_CLICKED:
; 165               {
; 166               pstPage->bDirtyBit = TRUE;
	mov	eax,dword ptr  @21pstPage
	or	byte ptr [eax+02ah],01h

; 167               TCCfgTimeoutDlg(hwndDlg,SHORT1FROMMP(mp1));
	mov	ax,[ebp+010h];	mp1
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	TCCfgTimeoutDlg
	add	esp,08h

; 168               }

; 169             break;
	jmp	@BLBL35
	align 04h
@BLBL38:

; 170           case EN_CHANGE:
; 171             pstPage->bDirtyBit = TRUE;
	mov	eax,dword ptr  @21pstPage
	or	byte ptr [eax+02ah],01h

; 172             break;
	jmp	@BLBL35
	align 04h
	jmp	@BLBL35
	align 04h
@BLBL36:
	cmp	eax,01h
	je	@BLBL37
	cmp	eax,04h
	je	@BLBL38
@BLBL35:

; 173           }
; 174         }
@BLBL21:

; 175       break;
	jmp	@BLBL22
	align 04h
@BLBL39:

; 176     case UM_SAVE_DATA:
; 177       UnloadCfgTimeoutDlg(hwndDlg,pstComDCB);
	push	dword ptr  @22pstComDCB
	push	dword ptr [ebp+08h];	hwndDlg
	call	UnloadCfgTimeoutDlg
	add	esp,08h

; 178       return((MRESULT)TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL40:

; 179     default:
; 180       return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
	jmp	@BLBL22
	align 04h
@BLBL23:
	cmp	eax,03bh
	je	@BLBL24
	cmp	eax,02710h
	je	@BLBL25
	cmp	eax,02716h
	je	@BLBL26
	cmp	eax,020h
	je	@BLBL27
	cmp	eax,030h
	je	@BLBL34
	cmp	eax,02711h
	je	@BLBL39
	jmp	@BLBL40
	align 04h
@BLBL22:

; 181     }
; 182   return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
fnwpCfgTimeoutDlg	endp

; 186   {
	align 010h

	public fnwpCfgProtocolDlg
fnwpCfgProtocolDlg	proc
	push	ebp
	mov	ebp,esp

; 191   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL46
	align 04h
@BLBL47:

; 192     {
; 193     case WM_INITDLG:
; 194       if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL41

; 195         WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
	push	offset FLAT:@STAT5
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL41:

; 196 //        ControlEnable(hwndDlg,DID_INSERT,FALSE);
; 197       bAllowClick = FALSE;
	mov	dword ptr  @30bAllowClick,0h

; 198       pstPage = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @31pstPage,eax

; 199       pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @31pstPage
	and	byte ptr [eax+02ah],0feh

; 200       pbyLineChar = pstPage->pVoidPtrOne;
	mov	eax,dword ptr  @31pstPage
	mov	eax,[eax+06h]
	mov	dword ptr  @32pbyLineChar,eax

; 201       FillCfgProtocolDlg(hwndDlg,*pbyLineChar);
	mov	eax,dword ptr  @32pbyLineChar
	mov	al,[eax]
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillCfgProtocolDlg
	add	esp,08h

; 202       if (pstPage->bSpoolerConfig)
	mov	eax,dword ptr  @31pstPage
	test	byte ptr [eax+02ah],010h
	je	@BLBL42

; 203         WinSetDlgItemText(hwndDlg,ST_TITLE,"Port line characteristics configuration");
	push	offset FLAT:@STAT6
	push	0578h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL42:

; 204       WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	02710h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinPostMsg
	add	esp,010h

; 205       break;
	jmp	@BLBL45
	align 04h
@BLBL48:

; 206     case UM_INITLS:
; 207       bAllowClick = TRUE;
	mov	dword ptr  @30bAllowClick,01h

; 208       break;
	jmp	@BLBL45
	align 04h
@BLBL49:

; 209     case UM_SET_FOCUS:
; 210       WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	eax
	push	01h
	call	WinSetFocus
	add	esp,08h

; 211       break;
	jmp	@BLBL45
	align 04h
@BLBL50:

; 212     case WM_COMMAND:
; 213       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL52
	align 04h
@BLBL53:

; 214         {
; 215         case DID_INSERT:
; 216            WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
	push	0h
	push	0h
	push	02714h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 217            break;
	jmp	@BLBL51
	align 04h
@BLBL54:

; 218         case DID_CANCEL:
; 219           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 220           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL55:

; 221         case DID_HELP:
; 222           WinSendMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
	push	0h
	push	012dh
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinSendMsg
	add	esp,010h

; 223           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL56:

; 224         case DID_UNDO:
; 225           bAllowClick = FALSE;
	mov	dword ptr  @30bAllowClick,0h

; 226           pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @31pstPage
	and	byte ptr [eax+02ah],0feh

; 227           FillCfgProtocolDlg(hwndDlg,*pbyLineChar);
	mov	eax,dword ptr  @32pbyLineChar
	mov	al,[eax]
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillCfgProtocolDlg
	add	esp,08h

; 228           bAllowClick = TRUE;
	mov	dword ptr  @30bAllowClick,01h

; 229           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL51
	align 04h
@BLBL52:
	cmp	eax,0130h
	je	@BLBL53
	cmp	eax,02h
	je	@BLBL54
	cmp	eax,012dh
	je	@BLBL55
	cmp	eax,0135h
	je	@BLBL56
@BLBL51:

; 230         }
; 231       break;
	jmp	@BLBL45
	align 04h
@BLBL57:

; 232     case WM_CONTROL:
; 233       if (SHORT2FROMMP(mp1) == BN_CLICKED)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL43

; 234         {
; 235         if (bAllowClick)
	cmp	dword ptr  @30bAllowClick,0h
	je	@BLBL43

; 236           {
; 237           pstPage->bDirtyBit = TRUE;
	mov	eax,dword ptr  @31pstPage
	or	byte ptr [eax+02ah],01h

; 238           TCCfgProtocolDlg(hwndDlg,SHORT1FROMMP(mp1));
	mov	ax,[ebp+010h];	mp1
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	TCCfgProtocolDlg
	add	esp,08h

; 239           }

; 240         }
@BLBL43:

; 241       break;
	jmp	@BLBL45
	align 04h
@BLBL58:

; 242     case UM_SAVE_DATA:
; 243       UnloadCfgProtocolDlg(hwndDlg,pbyLineChar);
	push	dword ptr  @32pbyLineChar
	push	dword ptr [ebp+08h];	hwndDlg
	call	UnloadCfgProtocolDlg
	add	esp,08h

; 244       return((MRESULT)TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL59:

; 245     default:
; 246       return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDefDlgProc
	add	esp,010h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL45
	align 04h
@BLBL46:
	cmp	eax,03bh
	je	@BLBL47
	cmp	eax,02710h
	je	@BLBL48
	cmp	eax,02716h
	je	@BLBL49
	cmp	eax,020h
	je	@BLBL50
	cmp	eax,030h
	je	@BLBL57
	cmp	eax,02711h
	je	@BLBL58
	jmp	@BLBL59
	align 04h
@BLBL45:

; 247     }
; 248   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpCfgProtocolDlg	endp

; 252   {
	align 010h

	public fnwpCfgBaudRateDlg
fnwpCfgBaudRateDlg	proc
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
	sub	esp,0ch

; 264   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL75
	align 04h
@BLBL76:

; 265     {
; 266     case WM_INITDLG:
; 267       if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL60

; 268         WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
	push	offset FLAT:@STAT7
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL60:

; 269 //        ControlEnable(hwndDlg,DID_INSERT,FALSE);
; 270       bAllowClick 
; 270 = FALSE;
	mov	dword ptr  @3bbAllowClick,0h

; 271       pstPage = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @3cpstPage,eax

; 272       pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @3cpstPage
	and	byte ptr [eax+02ah],0feh

; 273       pulBaud = pstPage->pVoidPtrOne;
	mov	eax,dword ptr  @3cpstPage
	mov	eax,[eax+06h]
	mov	dword ptr  @41pulBaud,eax

; 274       lBaud = *pulBaud;
	mov	eax,dword ptr  @41pulBaud
	mov	eax,[eax]
	mov	[ebp-04h],eax;	lBaud

; 275       if (lBaud == 0)
	cmp	dword ptr [ebp-04h],0h;	lBaud
	jne	@BLBL61

; 276         lBaud = DEF_BAUD;
	mov	dword ptr [ebp-04h],02580h;	lBaud
@BLBL61:

; 277       WinSendDlgItemMsg(hwndDlg,HWB_BAUD,EM_SETTEXTLIMIT,MPFROMSHORT(6),(MPARAM)NULL);
	push	0h
	push	06h
	push	0143h
	push	0515h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 278       iCurrentBaudIndex = -1;
	mov	dword ptr  @40iCurrentBaudIndex,0ffffffffh

; 279       iIndex = 0;
	mov	dword ptr [ebp-08h],0h;	iIndex

; 280       if (pstPage->bSpoolerConfig)
	mov	eax,dword ptr  @3cpstPage
	test	byte ptr [eax+02ah],010h
	je	@BLBL62

; 281         {
; 282         bTestMax = TRUE;
	mov	dword ptr [ebp-010h],01h;	bTestMax

; 283         ulMaxBaud = pstPage->ulSpare;
	mov	eax,dword ptr  @3cpstPage
	mov	eax,[eax+01eh]
	mov	[ebp-0ch],eax;	ulMaxBaud

; 284         }
	jmp	@BLBL63
	align 010h
@BLBL62:

; 285       else
; 286         bTestMax = FALSE;
	mov	dword ptr [ebp-010h],0h;	bTestMax
@BLBL63:

; 287       while (aulCfgExtBaudTable[iIndex] != 0)
	mov	eax,[ebp-08h];	iIndex
	cmp	dword ptr [eax*04h+aulCfgExtBaudTable],0h
	je	@BLBL64
	align 010h
@BLBL65:

; 288         {
; 289         ltoa(aulCfgExtBaudTable[iIndex],szBaud,10);
	mov	ecx,0ah
	mov	edx,offset FLAT:@3eszBaud
	mov	eax,[ebp-08h];	iIndex
	mov	eax,dword ptr [eax*04h+aulCfgExtBaudTable]
	call	_ltoa

; 290         WinSendDlgItemMsg(hwndDlg,HWB_BAUD,LM_INSERTITEM,MPFROM2SHORT(LIT_END,0),MPFROMP(szBaud));
	push	offset FLAT:@3eszBaud
	push	0ffffh
	push	0161h
	push	0515h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 291         if (aulCfgExtBaudTable[iIndex] == lBaud)
	mov	eax,[ebp-08h];	iIndex
	mov	ecx,[ebp-04h];	lBaud
	cmp	dword ptr [eax*04h+aulCfgExtBaudTable],ecx
	jne	@BLBL66

; 292           iCurrentBaudIndex = iIndex;
	mov	eax,[ebp-08h];	iIndex
	mov	dword ptr  @40iCurrentBaudIndex,eax
@BLBL66:

; 293         if (bTestMax)
	cmp	dword ptr [ebp-010h],0h;	bTestMax
	je	@BLBL67

; 294           if (aulCfgExtBaudTable[iIndex] >= ulMaxBaud)
	mov	eax,[ebp-08h];	iIndex
	mov	ecx,[ebp-0ch];	ulMaxBaud
	cmp	dword ptr [eax*04h+aulCfgExtBaudTable],ecx
	jae	@BLBL64

; 295             break;
@BLBL67:

; 296         iIndex++;
	mov	eax,[ebp-08h];	iIndex
	inc	eax
	mov	[ebp-08h],eax;	iIndex

; 297         }

; 287       while (aulCfgExtBaudTable[iIndex] != 0)
	mov	eax,[ebp-08h];	iIndex
	cmp	dword ptr [eax*04h+aulCfgExtBaudTable],0h
	jne	@BLBL65
@BLBL64:

; 298       if (iCurrentBaudIndex >= 0)
	cmp	dword ptr  @40iCurrentBaudIndex,0h
	jl	@BLBL70

; 299         WinSendDlgItemMsg(hwndDlg,HWB_BAUD,LM_SELECTITEM,MPFROMSHORT((SHORT)iCurrentBaudIndex),(MPARAM)TRUE);
	push	01h
	mov	ax,word ptr  @40iCurrentBaudIndex
	and	eax,0ffffh
	push	eax
	push	0164h
	push	0515h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h
@BLBL70:

; 300       ltoa(lBaud,szBaud,10);
	mov	ecx,0ah
	mov	edx,offset FLAT:@3eszBaud
	mov	eax,[ebp-04h];	lBaud
	call	_ltoa

; 301       WinSetDlgItemText(hwndDlg,HWB_BAUD,szBaud);
	push	offset FLAT:@3eszBaud
	push	0515h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 302       if (pstPage->bSpoolerConfig)
	mov	eax,dword ptr  @3cpstPage
	test	byte ptr [eax+02ah],010h
	je	@BLBL71

; 303         WinSetDlgItemText(hwndDlg,ST_TITLE,"Port baud rate configuration");
	push	offset FLAT:@STAT8
	push	0578h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL71:

; 304       WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	02710h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinPostMsg
	add	esp,010h

; 305       break;
	jmp	@BLBL74
	align 04h
@BLBL77:

; 307       bAllowClick = TRUE;
	mov	dword ptr  @3bbAllowClick,01h

; 308       break;
	jmp	@BLBL74
	align 04h
@BLBL78:

; 310       WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	eax
	push	01h
	call	WinSetFocus
	add	esp,08h

; 311       break;
	jmp	@BLBL74
	align 04h
@BLBL79:

; 313       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL81
	align 04h
@BLBL82:

; 316            WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
	push	0h
	push	0h
	push	02714h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 317            break;
	jmp	@BLBL80
	align 04h
@BLBL83:

; 319           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 320           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL84:

; 322           WinSendMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
	push	0h
	push	012dh
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinSendMsg
	add	esp,010h

; 323           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL85:

; 325           bAllowClick = FALSE;
	mov	dword ptr  @3bbAllowClick,0h

; 326           pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @3cpstPage
	and	byte ptr [eax+02ah],0feh

; 327           WinSetDlgItemText(hwndDlg,HWB_BAUD,szBaud);
	push	offset FLAT:@3eszBaud
	push	0515h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 328           if (iCurrentBaudIndex >= 0)
	cmp	dword ptr  @40iCurrentBaudIndex,0h
	jl	@BLBL72

; 329             WinSendDlgItemMsg(hwndDlg,HWB_BAUD,LM_SELECTITEM,MPFROMSHORT((SHORT)iCurrentBaudIndex),(MPARAM)TRUE);
	push	01h
	mov	ax,word ptr  @40iCurrentBaudIndex
	and	eax,0ffffh
	push	eax
	push	0164h
	push	0515h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h
@BLBL72:

; 330           bAllowClick = TRUE;
	mov	dword ptr  @3bbAllowClick,01h

; 331           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL80
	align 04h
@BLBL81:
	cmp	eax,0130h
	je	@BLBL82
	cmp	eax,02h
	je	@BLBL83
	cmp	eax,012dh
	je	@BLBL84
	cmp	eax,0135h
	je	@BLBL85
@BLBL80:

; 333       break;
	jmp	@BLBL74
	align 04h
@BLBL86:

; 335       switch (SHORT2FROMMP(mp1))
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	and	eax,0ffffh
	jmp	@BLBL88
	align 04h
@BLBL89:
@BLBL90:
@BLBL91:

; 340           if (bAllowClick)
	cmp	dword ptr  @3bbAllowClick,0h
	je	@BLBL73

; 341             pstPage->bDirtyBit = TRUE;
	mov	eax,dword ptr  @3cpstPage
	or	byte ptr [eax+02ah],01h
@BLBL73:

; 342           break;
	jmp	@BLBL87
	align 04h
	jmp	@BLBL87
	align 04h
@BLBL88:
	cmp	eax,01h
	je	@BLBL89
	cmp	eax,04h
	je	@BLBL90
	cmp	eax,07h
	je	@BLBL91
@BLBL87:

; 344       break;
	jmp	@BLBL74
	align 04h
@BLBL92:

; 346       WinQueryDlgItemText(hwndDlg,HWB_BAUD,sizeof(szBaud),szBaud);
	push	offset FLAT:@3eszBaud
	push	0ch
	push	0515h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinQueryDlgItemText
	add	esp,010h

; 347       *pulBaud = (ULONG)atol(szBaud);
	mov	eax,offset FLAT:@3eszBaud
	call	atol
	mov	ecx,eax
	mov	eax,dword ptr  @41pulBaud
	mov	[eax],ecx

; 348       return((MRESULT)TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL93:

; 350       return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
	jmp	@BLBL74
	align 04h
@BLBL75:
	cmp	eax,03bh
	je	@BLBL76
	cmp	eax,02710h
	je	@BLBL77
	cmp	eax,02716h
	je	@BLBL78
	cmp	eax,020h
	je	@BLBL79
	cmp	eax,030h
	je	@BLBL86
	cmp	eax,02711h
	je	@BLBL92
	jmp	@BLBL93
	align 04h
@BLBL74:

; 352   return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
fnwpCfgBaudRateDlg	endp

; 356   {
	align 010h

	public fnwpCfgHDWhandshakeDlg
fnwpCfgHDWhandshakeDlg	proc
	push	ebp
	mov	ebp,esp

; 362   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL101
	align 04h
@BLBL102:

; 363     {
; 364     case WM_INITDLG:
; 365       if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL94

; 366         WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
	push	offset FLAT:@STAT9
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL94:

; 367 //        ControlEnable(hwndDlg,DID_INSERT,FALSE);
; 368       bAllowClick = FALSE;
	mov	dword ptr  @54bAllowClick,0h

; 369       pstPage = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @52pstPage,eax

; 370       pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @52pstPage
	and	byte ptr [eax+02ah],0feh

; 371       pstComDCB = pstPage->pVoidPtrOne;
	mov	eax,dword ptr  @52pstPage
	mov	eax,[eax+06h]
	mov	dword ptr  @53pstComDCB,eax

; 372       if (pstComDCB->wFlags1 == 0)
	mov	eax,dword ptr  @53pstComDCB
	cmp	word ptr [eax+0eh],0h
	jne	@BLBL95

; 373         pstComDCB->wFlags1 = F1_DEFAULT;
	mov	eax,dword ptr  @53pstComDCB
	mov	word ptr [eax+0eh],01h
@BLBL95:

; 374       if (pstComDCB->wFlags2 == 0)
	mov	eax,dword ptr  @53pstComDCB
	cmp	word ptr [eax+010h],0h
	jne	@BLBL96

; 375         pstComDCB->wFlags2 = F2_DEFAULT;
	mov	eax,dword ptr  @53pstComDCB
	mov	word ptr [eax+010h],040h
@BLBL96:

; 376       FillHDWhandshakDlg(hwndDlg,pstComDCB);
	push	dword ptr  @53pstComDCB
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillHDWhandshakDlg
	add	esp,08h

; 377       if (pstPage->bSpoolerConfig)
	mov	eax,dword ptr  @52pstPage
	test	byte ptr [eax+02ah],010h
	je	@BLBL97

; 378         WinSetDlgItemText(hwndDlg,ST_TITLE,"Hardware handshake configuration");
	push	offset FLAT:@STATa
	push	0578h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL97:

; 379       WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	02710h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinPostMsg
	add	esp,010h

; 380       break;
	jmp	@BLBL100
	align 04h
@BLBL103:

; 381     case UM_INITLS:
; 382       bAllowClick = TRUE;
	mov	dword ptr  @54bAllowClick,01h

; 383       break;
	jmp	@BLBL100
	align 04h
@BLBL104:

; 384     case UM_SET_FOCUS:
; 385       WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	eax
	push	01h
	call	WinSetFocus
	add	esp,08h

; 386       break;
	jmp	@BLBL100
	align 04h
@BLBL105:

; 387     case WM_COMMAND:
; 388       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL107
	align 04h
@BLBL108:

; 389         {
; 390         case DID_INSERT:
; 391            WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
	push	0h
	push	0h
	push	02714h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 392            break;
	jmp	@BLBL106
	align 04h
@BLBL109:

; 393         case DID_CANCEL:
; 394           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 395           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL110:

; 396         case DID_HELP:
; 397           WinSendMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
	push	0h
	push	012dh
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinSendMsg
	add	esp,010h

; 398           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL111:

; 399         case DID_UNDO:
; 400           bAllowClick = FALSE;
	mov	dword ptr  @54bAllowClick,0h

; 401           pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @52pstPage
	and	byte ptr [eax+02ah],0feh

; 402           FillHDWhandshakDlg(hwndDlg,pstComDCB);
	push	dword ptr  @53pstComDCB
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillHDWhandshakDlg
	add	esp,08h

; 403           bAllowClick = TRUE;
	mov	dword ptr  @54bAllowClick,01h

; 404           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL106
	align 04h
@BLBL107:
	cmp	eax,0130h
	je	@BLBL108
	cmp	eax,02h
	je	@BLBL109
	cmp	eax,012dh
	je	@BLBL110
	cmp	eax,0135h
	je	@BLBL111
@BLBL106:

; 405         }
; 406       break;
	jmp	@BLBL100
	align 04h
@BLBL112:

; 407     case WM_CONTROL:
; 408       if (SHORT2FROMMP(mp1) == BN_CLICKED)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL98

; 409         if (bAllowClick)
	cmp	dword ptr  @54bAllowClick,0h
	je	@BLBL98

; 410           pstPage->bDirtyBit = TRUE;
	mov	eax,dword ptr  @52pstPage
	or	byte ptr [eax+02ah],01h
@BLBL98:

; 411       break;
	jmp	@BLBL100
	align 04h
@BLBL113:

; 412     case UM_SAVE_DATA:
; 413       UnloadHDWhandshakDlg(hwndDlg,pstComDCB);
	push	dword ptr  @53pstComDCB
	push	dword ptr [ebp+08h];	hwndDlg
	call	UnloadHDWhandshakDlg
	add	esp,08h

; 414       return((MRESULT)TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL114:

; 415     default:
; 416       return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDefDlgProc
	add	esp,010h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL100
	align 04h
@BLBL101:
	cmp	eax,03bh
	je	@BLBL102
	cmp	eax,02710h
	je	@BLBL103
	cmp	eax,02716h
	je	@BLBL104
	cmp	eax,020h
	je	@BLBL105
	cmp	eax,030h
	je	@BLBL112
	cmp	eax,02711h
	je	@BLBL113
	jmp	@BLBL114
	align 04h
@BLBL100:

; 417     }
; 418   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpCfgHDWhandshakeDlg	endp

; 422   {
	align 010h

	public fnwpCfgASCIIhandshakeDlg
fnwpCfgASCIIhandshakeDlg	proc
	push	ebp
	mov	ebp,esp

; 427   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL119
	align 04h
@BLBL120:

; 428     {
; 429     case WM_INITDLG:
; 430       if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL115

; 431         WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
	push	offset FLAT:@STATb
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL115:

; 432 //        ControlEnable(hwndDlg,DID_INSERT,FALSE);
; 433       bAllowClick = FALSE;
	mov	dword ptr  @61bAllowClick,0h

; 434       pstPage = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @5fpstPage,eax

; 435       pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @5fpstPage
	and	byte ptr [eax+02ah],0feh

; 436       pstComDCB = pstPage->pVoidPtrOne;
	mov	eax,dword ptr  @5fpstPage
	mov	eax,[eax+06h]
	mov	dword ptr  @60pstComDCB,eax

; 437       FillASCIIhandshakingDlg(hwndDlg,pstComDCB);
	push	dword ptr  @60pstComDCB
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillASCIIhandshakingDlg
	add	esp,08h

; 438       if (pstPage->bSpoolerConfig)
	mov	eax,dword ptr  @5fpstPage
	test	byte ptr [eax+02ah],010h
	je	@BLBL116

; 439         WinSetDlgItemText(hwndDlg,ST_TITLE,"Port ASCII handshaking configuration");
	push	offset FLAT:@STATc
	push	0578h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL116:

; 440       WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	02710h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinPostMsg
	add	esp,010h

; 441       break;
	jmp	@BLBL118
	align 04h
@BLBL121:

; 442     case UM_INITLS:
; 443       bAllowClick = TRUE;
	mov	dword ptr  @61bAllowClick,01h

; 444       break;
	jmp	@BLBL118
	align 04h
@BLBL122:

; 445     case UM_SET_FOCUS:
; 446       WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	eax
	push	01h
	call	WinSetFocus
	add	esp,08h

; 447       break;
	jmp	@BLBL118
	align 04h
@BLBL123:

; 448     case WM_COMMAND:
; 449       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL125
	align 04h
@BLBL126:

; 450         {
; 451         case DID_INSERT:
; 452            WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
	push	0h
	push	0h
	push	02714h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 453            break;
	jmp	@BLBL124
	align 04h
@BLBL127:

; 454         case DID_CANCEL:
; 455           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 456           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL128:

; 457         case DID_HELP:
; 458           WinSendMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
	push	0h
	push	012dh
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinSendMsg
	add	esp,010h

; 459           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL129:

; 460         case DID_UNDO:
; 461           bAllowClick = FALSE;
	mov	dword ptr  @61bAllowClick,0h

; 462           pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @5fpstPage
	and	byte ptr [eax+02ah],0feh

; 463           FillASCIIhandshakingDlg(hwndDlg,pstComDCB);
	push	dword ptr  @60pstComDCB
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillASCIIhandshakingDlg
	add	esp,08h

; 464           bAllowClick = TRUE;
	mov	dword ptr  @61bAllowClick,01h

; 465           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL124
	align 04h
@BLBL125:
	cmp	eax,0130h
	je	@BLBL126
	cmp	eax,02h
	je	@BLBL127
	cmp	eax,012dh
	je	@BLBL128
	cmp	eax,0135h
	je	@BLBL129
@BLBL124:

; 466         }
; 467       break;
	jmp	@BLBL118
	align 04h
@BLBL130:

; 468     case WM_CONTROL:
; 469       if (bAllowClick)
	cmp	dword ptr  @61bAllowClick,0h
	je	@BLBL117

; 470         {
; 471         switch (SHORT2FROMMP(mp1))
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	and	eax,0ffffh
	jmp	@BLBL132
	align 04h
@BLBL133:

; 472           {
; 473           case BN_CLICKED:
; 474             pstPage->bDirtyBit = TRUE;
	mov	eax,dword ptr  @5fpstPage
	or	byte ptr [eax+02ah],01h

; 475             TCASCIIhandshakeDlg(hwndDlg,SHORT1FROMMP(mp1));
	mov	ax,[ebp+010h];	mp1
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	TCASCIIhandshakeDlg
	add	esp,08h

; 476             break;
	jmp	@BLBL131
	align 04h
@BLBL134:

; 477           case EN_CHANGE:
; 478             pstPage->bDirtyBit = TRUE;
	mov	eax,dword ptr  @5fpstPage
	or	byte ptr [eax+02ah],01h

; 479             break;
	jmp	@BLBL131
	align 04h
	jmp	@BLBL131
	align 04h
@BLBL132:
	cmp	eax,01h
	je	@BLBL133
	cmp	eax,04h
	je	@BLBL134
@BLBL131:

; 480           }
; 481         }
@BLBL117:

; 482       break;
	jmp	@BLBL118
	align 04h
@BLBL135:

; 483     case UM_SAVE_DATA:
; 484       UnloadASCIIhandshakeDlg(hwndDlg,pstComDCB);
	push	dword ptr  @60pstComDCB
	push	dword ptr [ebp+08h];	hwndDlg
	call	UnloadASCIIhandshakeDlg
	add	esp,08h

; 485       return((MRESULT)TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL136:

; 486     default:
; 487       return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDefDlgProc
	add	esp,010h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL118
	align 04h
@BLBL119:
	cmp	eax,03bh
	je	@BLBL120
	cmp	eax,02710h
	je	@BLBL121
	cmp	eax,02716h
	je	@BLBL122
	cmp	eax,020h
	je	@BLBL123
	cmp	eax,030h
	je	@BLBL130
	cmp	eax,02711h
	je	@BLBL135
	jmp	@BLBL136
	align 04h
@BLBL118:

; 488     }
; 489   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpCfgASCIIhandshakeDlg	endp

; 493   {
	align 010h

	public fnwpDefThresholdDlg
fnwpDefThresholdDlg	proc
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

; 499   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL143
	align 04h
@BLBL144:

; 500     {
; 501     case WM_INITDLG:
; 502       if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL137

; 503         WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
	push	offset FLAT:@STATd
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL137:

; 504 //        ControlEnable(hwndDlg,DID_INSERT,FALSE);
; 505       pstPage = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @6apstPage,eax

; 506       pstComDCB = pstPage->pVoidPtrOne;
	mov	eax,dword ptr  @6apstPage
	mov	eax,[eax+06h]
	mov	dword ptr  @6bpstComDCB,eax

; 507       pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @6apstPage
	and	byte ptr [eax+02ah],0feh

; 508       bAllowChange = FALSE;
	mov	dword ptr  @6cbAllowChange,0h

; 509       WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(pstComDCB->wReadBufferLength - lOrgXonHysteresis),(MPARAM)1);
	push	01h
	mov	ecx,dword ptr  @6bpstComDCB
	xor	eax,eax
	mov	ax,[ecx+08h]
	sub	eax,dword ptr  lOrgXonHysteresis
	push	eax
	push	0207h
	push	01006h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 510       WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_SETCURRENTVALUE,(MPARAM)lOrgXoffThreshold,NULL);
	push	0h
	mov	eax,dword ptr  lOrgXoffThreshold
	push	eax
	push	0208h
	push	01006h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 511       WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(pstComDCB->wReadBufferLength - lOrgXoffThreshold),(MPARAM)1);
	push	01h
	mov	ecx,dword ptr  @6bpstComDCB
	xor	eax,eax
	mov	ax,[ecx+08h]
	sub	eax,dword ptr  lOrgXoffThreshold
	push	eax
	push	0207h
	push	01005h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 512       WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_SETCURRENTVALUE,(MPARAM)lOrgXonHysteresis,NULL);
; 512 
	push	0h
	mov	eax,dword ptr  lOrgXonHysteresis
	push	eax
	push	0208h
	push	01005h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 513       sprintf(szMessage,szBuffSizeFormat,pstComDCB->wReadBufferLength);
	mov	ecx,dword ptr  @6bpstComDCB
	xor	eax,eax
	mov	ax,[ecx+08h]
	push	eax
	mov	edx,offset FLAT:@2szBuffSizeFormat
	lea	eax,[ebp-050h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 514       WinSetDlgItemText(hwndDlg,PCFG_THRESHOLD_BUFF_SIZE,szMessage);
	lea	eax,[ebp-050h];	szMessage
	push	eax
	push	0100ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 515       WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	02710h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinPostMsg
	add	esp,010h

; 516       break;
	jmp	@BLBL142
	align 04h
@BLBL145:

; 517     case UM_RECALCDLG:
; 518       WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(ulReadBufLen - lOrgXonHysteresis),(MPARAM)1);
	push	01h
	mov	ecx,dword ptr  lOrgXonHysteresis
	mov	eax,dword ptr  ulReadBufLen
	sub	eax,ecx
	push	eax
	push	0207h
	push	01006h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 519       WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_SETCURRENTVALUE,(MPARAM)lOrgXoffThreshold,NULL);
	push	0h
	mov	eax,dword ptr  lOrgXoffThreshold
	push	eax
	push	0208h
	push	01006h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 520       WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(ulReadBufLen - lOrgXoffThreshold),(MPARAM)1);
	push	01h
	mov	ecx,dword ptr  lOrgXoffThreshold
	mov	eax,dword ptr  ulReadBufLen
	sub	eax,ecx
	push	eax
	push	0207h
	push	01005h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 521       WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_SETCURRENTVALUE,(MPARAM)lOrgXonHysteresis,NULL);
	push	0h
	mov	eax,dword ptr  lOrgXonHysteresis
	push	eax
	push	0208h
	push	01005h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 522       sprintf(szMessage,szBuffSizeFormat,ulReadBufLen);
	push	dword ptr  ulReadBufLen
	mov	edx,offset FLAT:@2szBuffSizeFormat
	lea	eax,[ebp-050h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 523       WinSetDlgItemText(hwndDlg,PCFG_THRESHOLD_BUFF_SIZE,szMessage);
	lea	eax,[ebp-050h];	szMessage
	push	eax
	push	0100ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 524       break;
	jmp	@BLBL142
	align 04h
@BLBL146:

; 525     case UM_INITLS:
; 526       bAllowChange = TRUE;
	mov	dword ptr  @6cbAllowChange,01h

; 527       break;
	jmp	@BLBL142
	align 04h
@BLBL147:

; 528     case UM_SET_FOCUS:
; 529       WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	eax
	push	01h
	call	WinSetFocus
	add	esp,08h

; 530       break;
	jmp	@BLBL142
	align 04h
@BLBL148:

; 531     case WM_COMMAND:
; 532       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL150
	align 04h
@BLBL151:

; 533         {
; 534         case DID_INSERT:
; 535            WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
	push	0h
	push	0h
	push	02714h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 536            break;
	jmp	@BLBL149
	align 04h
@BLBL152:

; 537         case DID_CANCEL:
; 538           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 539           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL153:

; 540         case DID_HELP:
; 541           WinSendMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
	push	0h
	push	012dh
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinSendMsg
	add	esp,010h

; 542           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL154:

; 543         case DID_UNDO:
; 544           pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @6apstPage
	and	byte ptr [eax+02ah],0feh

; 545           bAllowChange = FALSE;
	mov	dword ptr  @6cbAllowChange,0h

; 546           WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(pstComDCB->wReadBufferLength - lOrgXonHysteresis),(MPARAM)1);
	push	01h
	mov	ecx,dword ptr  @6bpstComDCB
	xor	eax,eax
	mov	ax,[ecx+08h]
	sub	eax,dword ptr  lOrgXonHysteresis
	push	eax
	push	0207h
	push	01006h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 547           WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_SETCURRENTVALUE,(MPARAM)lOrgXoffThreshold,NULL);
	push	0h
	mov	eax,dword ptr  lOrgXoffThreshold
	push	eax
	push	0208h
	push	01006h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 548           WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(pstComDCB->wReadBufferLength - lOrgXoffThreshold),(MPARAM)1);
	push	01h
	mov	ecx,dword ptr  @6bpstComDCB
	xor	eax,eax
	mov	ax,[ecx+08h]
	sub	eax,dword ptr  lOrgXoffThreshold
	push	eax
	push	0207h
	push	01005h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 549           WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_SETCURRENTVALUE,(MPARAM)lOrgXonHysteresis,NULL);
	push	0h
	mov	eax,dword ptr  lOrgXonHysteresis
	push	eax
	push	0208h
	push	01005h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 550           bAllowChange = TRUE;
	mov	dword ptr  @6cbAllowChange,01h

; 551           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL149
	align 04h
@BLBL150:
	cmp	eax,0130h
	je	@BLBL151
	cmp	eax,02h
	je	@BLBL152
	cmp	eax,012dh
	je	@BLBL153
	cmp	eax,0135h
	je	@BLBL154
@BLBL149:

; 552         }
; 553       break;
	jmp	@BLBL142
	align 04h
@BLBL155:

; 554     case UM_SAVE_DATA:
; 555       pstComDCB->wXonHysteresis = lXonHysteresis;
	mov	ecx,dword ptr  lXonHysteresis
	mov	eax,dword ptr  @6bpstComDCB
	mov	[eax+026h],cx

; 556       pstComDCB->wXoffThreshold = lXoffThreshold;
	mov	ecx,dword ptr  lXoffThreshold
	mov	eax,dword ptr  @6bpstComDCB
	mov	[eax+028h],cx

; 557       break;
	jmp	@BLBL142
	align 04h
@BLBL156:

; 558     case WM_CONTROL:
; 559       if (bAllowChange & (SHORT2FROMMP(mp1) == SPBN_CHANGE))
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,020dh
	sete	al
	and	eax,01h
	test	dword ptr  @6cbAllowChange,eax
	je	@BLBL138

; 560         if (SHORT1FROMMP(mp1) == PCFG_XON_THRESHOLD)
	mov	ax,[ebp+010h];	mp1
	cmp	ax,01005h
	jne	@BLBL139

; 561           {
; 562           pstPage->bDirtyBit = TRUE;
	mov	eax,dword ptr  @6apstPage
	or	byte ptr [eax+02ah],01h

; 563           WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_QUERYVALUE,&lXonHysteresis,MPFROM2SHORT(0,SPBQ_ALWAYSUPDATE));
	push	010000h
	push	offset FLAT:lXonHysteresis
	push	0205h
	push	01005h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 564           WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(pstComDCB->wReadBufferLength - lXonHysteresis),(MPARAM)1);
	push	01h
	mov	ecx,dword ptr  @6bpstComDCB
	xor	eax,eax
	mov	ax,[ecx+08h]
	sub	eax,dword ptr  lXonHysteresis
	push	eax
	push	0207h
	push	01006h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 565           }
	jmp	@BLBL138
	align 010h
@BLBL139:

; 566         else
; 567           if (SHORT1FROMMP(mp1) == PCFG_XOFF_THRESHOLD)
	mov	ax,[ebp+010h];	mp1
	cmp	ax,01006h
	jne	@BLBL138

; 568             {
; 569             pstPage->bDirtyBit = TRUE;
	mov	eax,dword ptr  @6apstPage
	or	byte ptr [eax+02ah],01h

; 570             WinSendDlgItemMsg(hwndDlg,PCFG_XOFF_THRESHOLD,SPBM_QUERYVALUE,&lXoffThreshold,MPFROM2SHORT(0,SPBQ_ALWAYSUPDATE));
	push	010000h
	push	offset FLAT:lXoffThreshold
	push	0205h
	push	01006h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 571             WinSendDlgItemMsg(hwndDlg,PCFG_XON_THRESHOLD,SPBM_SETLIMITS,(MPARAM)(pstComDCB->wReadBufferLength - lXoffThreshold),(MPARAM)1);
	push	01h
	mov	ecx,dword ptr  @6bpstComDCB
	xor	eax,eax
	mov	ax,[ecx+08h]
	sub	eax,dword ptr  lXoffThreshold
	push	eax
	push	0207h
	push	01005h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 572             }
@BLBL138:

; 573       break;
	jmp	@BLBL142
	align 04h
@BLBL157:

; 574     default:
; 575       return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDefDlgProc
	add	esp,010h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL142
	align 04h
@BLBL143:
	cmp	eax,03bh
	je	@BLBL144
	cmp	eax,02712h
	je	@BLBL145
	cmp	eax,02710h
	je	@BLBL146
	cmp	eax,02716h
	je	@BLBL147
	cmp	eax,020h
	je	@BLBL148
	cmp	eax,02711h
	je	@BLBL155
	cmp	eax,030h
	je	@BLBL156
	jmp	@BLBL157
	align 04h
@BLBL142:

; 576     }
; 577   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpDefThresholdDlg	endp
CODE32	ends
end
