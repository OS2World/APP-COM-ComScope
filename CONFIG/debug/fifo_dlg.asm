	title	p:\config\fifo_dlg.c
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
	extrn	WinPostMsg:proc
	extrn	WinWindowFromID:proc
	extrn	WinSetFocus:proc
	extrn	WinDefDlgProc:proc
	extrn	CheckButton:proc
	extrn	ControlEnable:proc
	extrn	Checked:proc
	extrn	_fullDump:dword
	extrn	bInsertNewDevice:dword
	extrn	hwndNoteBookDlg:dword
DATA32	segment
@STAT1	db "S~ave",0h
	align 04h
@STAT2	db "Port hardware buffer (FI"
db "FO) configuration",0h
	dd	_dllentry
DATA32	ends
BSS32	segment
@7pstPage	dd 0h
@8bAllowClick	dd 0h
@9pstComDCB	dd 0h
@awFlags	dw 0h
@bwTxFIFOload	dw 0h
BSS32	ends
CODE32	segment

; 22   {
	align 010h

	public fnwpHdwDefFIFOsetupDlg
fnwpHdwDefFIFOsetupDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 29   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL7
	align 04h
@BLBL8:

; 30     {
; 31     case WM_INITDLG:
; 32       if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL1

; 33         WinSetDlgItemText(hwnd,DID_INSERT,"S~ave");
	push	offset FLAT:@STAT1
	push	0130h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL1:

; 34 //        ControlEnable(hwnd,DID_INSERT,FALSE);
; 35 //      CenterDlgBox(hwnd);
; 36 //      WinSetFocus(HWND_DESKTOP,hwnd);
; 37       bAllowClick = FALSE;
	mov	dword ptr  @8bAllowClick,0h

; 38       pstPage = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @7pstPage,eax

; 39       pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @7pstPage
	and	byte ptr [eax+02ah],0feh

; 40       pstComDCB = pstPage->pVoidPtrOne;
	mov	eax,dword ptr  @7pstPage
	mov	eax,[eax+06h]
	mov	dword ptr  @9pstComDCB,eax

; 41       wFlags = pstComDCB->wFlags3;
	mov	eax,dword ptr  @9pstComDCB
	mov	ax,[eax+012h]
	mov	word ptr  @awFlags,ax

; 42       wTxFIFOload = pstComDCB->wTxFIFOload;
	mov	eax,dword ptr  @9pstComDCB
	mov	ax,[eax+0ch]
	mov	word ptr  @bwTxFIFOload,ax

; 43       FillCfgFIFOsetupDlg(hwnd,wFlags,wTxFIFOload);
	mov	ax,word ptr  @bwTxFIFOload
	push	eax
	mov	ax,word ptr  @awFlags
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	FillCfgFIFOsetupDlg
	add	esp,0ch

; 44       if (pstPage->bSpoolerConfig)
	mov	eax,dword ptr  @7pstPage
	test	byte ptr [eax+02ah],010h
	je	@BLBL2

; 45         WinSetDlgItemText(hwnd,ST_TITLE,"Port hardware buffer (FIFO) configuration");
	push	offset FLAT:@STAT2
	push	0578h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL2:

; 46       WinPostMsg(hwnd,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	02710h
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 47       break;
	jmp	@BLBL6
	align 04h
@BLBL9:

; 48     case UM_INITLS:
; 49       bAllowClick = TRUE;
	mov	dword ptr  @8bAllowClick,01h

; 50       break;
	jmp	@BLBL6
	align 04h
@BLBL10:

; 51     case UM_SET_FOCUS:
; 52       WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwnd,SHORT1FROMMP(mp1)));
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinWindowFromID
	add	esp,08h
	push	eax
	push	01h
	call	WinSetFocus
	add	esp,08h

; 53       break;
	jmp	@BLBL6
	align 04h
@BLBL11:

; 54     case WM_COMMAND:
; 55       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL13
	align 04h
@BLBL14:

; 56         {
; 57         case DID_INSERT:
; 58            WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
	push	0h
	push	0h
	push	02714h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 59            break;
	jmp	@BLBL12
	align 04h
@BLBL15:

; 60         case DID_CANCEL:
; 61           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 62           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL16:

; 63         case DID_HELP:
; 64            WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
	push	0h
	push	012dh
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 65            return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL17:

; 66         case DID_UNDO:
; 67           bAllowClick = FALSE;
	mov	dword ptr  @8bAllowClick,0h

; 68           pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @7pstPage
	and	byte ptr [eax+02ah],0feh

; 69           FillCfgFIFOsetupDlg(hwnd,wFlags,wTxFIFOload);
	mov	ax,word ptr  @bwTxFIFOload
	push	eax
	mov	ax,word ptr  @awFlags
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	FillCfgFIFOsetupDlg
	add	esp,0ch

; 70           bAllowClick = TRUE;
	mov	dword ptr  @8bAllowClick,01h

; 71         }
	jmp	@BLBL12
	align 04h
@BLBL13:
	cmp	eax,0130h
	je	@BLBL14
	cmp	eax,02h
	je	@BLBL15
	cmp	eax,012dh
	je	@BLBL16
	cmp	eax,0135h
	je	@BLBL17
@BLBL12:

; 72       break;
	jmp	@BLBL6
	align 04h
@BLBL18:

; 73     case WM_CONTROL:
; 74       if (SHORT2FROMMP(mp1) == BN_CLICKED)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL3

; 75         if (bAllowClick)
	cmp	dword ptr  @8bAllowClick,0h
	je	@BLBL3

; 76           {
; 77           pstPage->bDirtyBit = TRUE;
	mov	eax,dword ptr  @7pstPage
	or	byte ptr [eax+02ah],01h

; 78           TCCfgFIFOsetupDlg(hwnd,SHORT1FROMMP(mp1));
	mov	ax,[ebp+010h];	mp1
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	TCCfgFIFOsetupDlg
	add	esp,08h

; 79           }
@BLBL3:

; 80       break;
	jmp	@BLBL6
	align 04h
@BLBL19:

; 81     case UM_SAVE_DATA:
; 82       if (pstPage->bDirtyBit)
	mov	eax,dword ptr  @7pstPage
	test	byte ptr [eax+02ah],01h
	je	@BLBL5

; 83         {
; 84         UnloadCfgFIFOsetupDlg(hwnd,&pstComDCB->wFlags3,&pstComDCB->wTxFIFOload);
	mov	eax,dword ptr  @9pstComDCB
	add	eax,0ch
	push	eax
	mov	eax,dword ptr  @9pstComDCB
	add	eax,012h
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	UnloadCfgFIFOsetupDlg
	add	esp,0ch

; 85         pstComDCB->wConfigFlags2 &= ~CFG_FLAG2_EXPLICIT_TX_LOAD;
	mov	eax,dword ptr  @9pstComDCB
	mov	[ebp-04h],eax;	@CBE3
	mov	eax,[ebp-04h];	@CBE3
	xor	ecx,ecx
	mov	cx,[eax+02h]
	and	ch,0bfh
	mov	[eax+02h],cx

; 86         }
@BLBL5:

; 87       return((MRESULT)TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL20:

; 88     default:
; 89       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefDlgProc
	add	esp,010h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL6
	align 04h
@BLBL7:
	cmp	eax,03bh
	je	@BLBL8
	cmp	eax,02710h
	je	@BLBL9
	cmp	eax,02716h
	je	@BLBL10
	cmp	eax,020h
	je	@BLBL11
	cmp	eax,030h
	je	@BLBL18
	cmp	eax,02711h
	je	@BLBL19
	jmp	@BLBL20
	align 04h
@BLBL6:

; 90     }
; 91   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpHdwDefFIFOsetupDlg	endp

; 95   {
	align 010h

FillCfgFIFOsetupDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 99   if ((wFlags & F3_HDW_BUFFER_APO) != 0)
	test	byte ptr [ebp+0ch],018h;	wFlags
	je	@BLBL21

; 100     {
; 101     switch ((wFlags & F3_HDW_BUFFER_APO) >> 3)
	xor	eax,eax
	mov	ax,[ebp+0ch];	wFlags
	and	eax,018h
	sar	eax,03h
	jmp	@BLBL32
	align 04h
@BLBL33:

; 102       {
; 103       case 1:
; 104         CheckButton(hwnd,HWF_DISABFIFO,TRUE);
	push	01h
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 105         CheckButton(hwnd,HWF_ENABFIFO,FALSE);
	push	0h
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 106         CheckButton(hwnd,HWF_APO,FALSE);
	push	0h
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 107         break;
	jmp	@BLBL31
	align 04h
@BLBL34:

; 108       case 2:
; 109         CheckButton(hwnd,HWF_DISABFIFO,FALSE);
	push	0h
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 110         CheckButton(hwnd,HWF_ENABFIFO,TRUE);
	push	01h
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 111         CheckButton(hwnd,HWF_APO,FALSE);
	push	0h
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 112         break;
	jmp	@BLBL31
	align 04h
@BLBL35:

; 113       case 3:
; 114         CheckButton(hwnd,HWF_DISABFIFO,FALSE);
	push	0h
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 115         CheckButton(hwnd,HWF_ENABFIFO,FALSE);
	push	0h
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 116         CheckButton(hwnd,HWF_APO,TRUE);
	push	01h
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 117         break;
	jmp	@BLBL31
	align 04h
@BLBL36:

; 118       default:
; 119         CheckButton(hwnd,HWF_DISABFIFO,TRUE);
	push	01h
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 120         CheckButton(hwnd,HWF_ENABFIFO,FALSE);
	push	0h
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 121         CheckButton(hwnd,HWF_APO,FALSE);
	push	0h
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 122         break;
	jmp	@BLBL31
	align 04h
	jmp	@BLBL31
	align 04h
@BLBL32:
	cmp	eax,01h
	je	@BLBL33
	cmp	eax,02h
	je	@BLBL34
	cmp	eax,03h
	je	@BLBL35
	jmp	@BLBL36
	align 04h
@BLBL31:

; 123       }
; 124     switch ((wFlags & F3_14_CHARACTER_FIFO) >> 5)
	xor	eax,eax
	mov	ax,[ebp+0ch];	wFlags
	and	eax,060h
	sar	eax,05h
	jmp	@BLBL38
	align 04h
@BLBL39:

; 125       {
; 126       case 0:
; 127         idEntryField = HWF_1TRIG;
	mov	word ptr [ebp-02h],01abh;	idEntryField

; 128         break;
	jmp	@BLBL37
	align 04h
@BLBL40:

; 129       case 1:
; 130         idEntryField = HWF_4TRIG;
	mov	word ptr [ebp-02h],01aah;	idEntryField

; 131         break;
	jmp	@BLBL37
	align 04h
@BLBL41:

; 132       case 2:
; 133         idEntryField = HWF_8TRIG;
	mov	word ptr [ebp-02h],01a9h;	idEntryField

; 134         break;
	jmp	@BLBL37
	align 04h
@BLBL42:

; 135       default:
; 136         idEntryField = HWF_14TRIG;
	mov	word ptr [ebp-02h],01a8h;	idEntryField

; 137         break;
	jmp	@BLBL37
	align 04h
	jmp	@BLBL37
	align 04h
@BLBL38:
	test	eax,eax
	je	@BLBL39
	cmp	eax,01h
	je	@BLBL40
	cmp	eax,02h
	je	@BLBL41
	jmp	@BLBL42
	align 04h
@BLBL37:

; 138       }
; 139     CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-02h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 140 
; 141     if (((wFlags & F3_USE_TX_BUFFER) == 0) || (wTxFIFOload == 1))
	test	byte ptr [ebp+0ch],080h;	wFlags
	je	@BLBL22
	cmp	word ptr [ebp+010h],01h;	wTxFIFOload
	jne	@BLBL23
@BLBL22:

; 142       idEntryField = HWF_TX_MIN;
	mov	word ptr [ebp-02h],02c3h;	idEntryField
	jmp	@BLBL24
	align 010h
@BLBL23:

; 143     else
; 144       if (wTxFIFOload == 2)
	cmp	word ptr [ebp+010h],02h;	wTxFIFOload
	jne	@BLBL25

; 145         idEntryField = HWF_TX_HALF;
	mov	word ptr [ebp-02h],02c2h;	idEntryField
	jmp	@BLBL24
	align 010h
@BLBL25:

; 146       else
; 147         if (wTxFIFOload == 3)
	cmp	word ptr [ebp+010h],03h;	wTxFIFOload
	jne	@BLBL27

; 148           idEntryField = HWF_TX_HIHALF;
	mov	word ptr [ebp-02h],02c5h;	idEntryField
	jmp	@BLBL24
	align 010h
@BLBL27:

; 149         else
; 150           idEntryField = HWF_TX_MAX;
	mov	word ptr [ebp-02h],02c4h;	idEntryField
@BLBL24:

; 151 
; 152     CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-02h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 153     }
@BLBL21:

; 154   if ((wFlags & F3_HDW_BUFFER_ENABLE) != F3_HDW_BUFFER_ENABLE)
	mov	ax,[ebp+0ch];	wFlags
	and	ax,010h
	cmp	ax,010h
	je	@BLBL29

; 155     bEnable = FALSE;
	mov	dword ptr [ebp-08h],0h;	bEnable
	jmp	@BLBL30
	align 010h
@BLBL29:

; 156   else
; 157     bEnable = TRUE;
	mov	dword ptr [ebp-08h],01h;	bEnable
@BLBL30:

; 158   ControlEnable(hwnd,HWF_1TRIG,bEnable);
	push	dword ptr [ebp-08h];	bEnable
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 159   ControlEnable(hwnd,HWF_4TRIG,bEnable);
	push	dword ptr [ebp-08h];	bEnable
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 160   ControlEnable(hwnd,HWF_8TRIG,bEnable);
	push	dword ptr [ebp-08h];	bEnable
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 161   ControlEnable(hwnd,HWF_14TRIG,bEnable);
	push	dword ptr [ebp-08h];	bEnable
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 162   ControlEnable(hwnd,HWF_TX_HALF,bEnable);
	push	dword ptr [ebp-08h];	bEnable
	push	02c2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 163   ControlEnable(hwnd,HWF_TX_MIN,bEnable);
	push	dword ptr [ebp-08h];	bEnable
	push	02c3h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 164   ControlEnable(hwnd,HWF_TX_HIHALF,bEnable);
	push	dword ptr [ebp-08h];	bEnable
	push	02c5h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 165   ControlEnable(hwnd,HWF_TX_MAX,bEnable);
	push	dword ptr [ebp-08h];	bEnable
	push	02c4h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 166   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
FillCfgFIFOsetupDlg	endp

; 170   {
	align 010h

UnloadCfgFIFOsetupDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,028h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,0ah
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 171   *pwFlags &= ~F3_FIFO_MASK;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-028h],eax;	@CBE13
	mov	eax,[ebp-028h];	@CBE13
	xor	ecx,ecx
	mov	cx,[eax]
	and	cl,07h
	mov	[eax],cx

; 172   if (Checked(hwnd,HWF_DISABFIFO))
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL43

; 173     *pwFlags |= F3_HDW_BUFFER_DISABLE;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-024h],eax;	@CBE12
	mov	eax,[ebp-024h];	@CBE12
	mov	cx,[eax]
	or	cl,08h
	mov	[eax],cx
	jmp	@BLBL44
	align 010h
@BLBL43:

; 174   else
; 175     {
; 176     if (Checked(hwnd,HWF_ENABFIFO))
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL45

; 177       *pwFlags |= F3_HDW_BUFFER_ENABLE;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-020h],eax;	@CBE11
	mov	eax,[ebp-020h];	@CBE11
	mov	cx,[eax]
	or	cl,010h
	mov	[eax],cx
	jmp	@BLBL46
	align 010h
@BLBL45:

; 178     else
; 179       if (Checked(hwnd,HWF_APO))
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL46

; 180         *pwFlags |= F3_HDW_BUFFER_APO;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-01ch],eax;	@CBE10
	mov	eax,[ebp-01ch];	@CBE10
	mov	cx,[eax]
	or	cl,018h
	mov	[eax],cx
@BLBL46:

; 181 
; 182     if (Checked(hwnd,HWF_4TRIG))
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL48

; 183       *pwFlags |= F3_4_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-018h],eax;	@CBE9
	mov	eax,[ebp-018h];	@CBE9
	mov	cx,[eax]
	or	cl,020h
	mov	[eax],cx
	jmp	@BLBL49
	align 010h
@BLBL48:

; 184     else
; 185       if (Checked(hwnd,HWF_8TRIG))
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL50

; 186         *pwFlags |= F3_8_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-014h],eax;	@CBE8
	mov	eax,[ebp-014h];	@CBE8
	mov	cx,[eax]
	or	cl,040h
	mov	[eax],cx
	jmp	@BLBL49
	align 010h
@BLBL50:

; 187       else
; 188         if (Checked(hwnd,HWF_14TRIG))
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL49

; 189           *pwFlags |= F3_14_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-010h],eax;	@CBE7
	mov	eax,[ebp-010h];	@CBE7
	mov	cx,[eax]
	or	cl,060h
	mov	[eax],cx
@BLBL49:

; 190     /*
; 191     **  Set default TX load count
; 192     */
; 193     if (Checked(hwnd,HWF_TX_MIN))
	push	02c3h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL53

; 194       {
; 195       *pwFlags &= ~F3_USE_TX_BUFFER;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-0ch],eax;	@CBE6
	mov	eax,[ebp-0ch];	@CBE6
	xor	ecx,ecx
	mov	cx,[eax]
	and	cl,07fh
	mov	[eax],cx

; 196       *pwTxFIFOload = 1;
	mov	eax,[ebp+010h];	pwTxFIFOload
	mov	word ptr [eax],01h

; 197       }
	jmp	@BLBL54
	align 010h
@BLBL53:

; 198     else
; 199       {
; 200       *pwFlags |= F3_USE_TX_BUFFER;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-08h],eax;	@CBE5
	mov	eax,[ebp-08h];	@CBE5
	mov	cx,[eax]
	or	cl,080h
	mov	[eax],cx

; 201       if (Checked(hwnd,HWF_TX_HALF))
	push	02c2h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL55

; 202         *pwTxFIFOload = 2;
	mov	eax,[ebp+010h];	pwTxFIFOload
	mov	word ptr [eax],02h
	jmp	@BLBL54
	align 010h
@BLBL55:

; 203       else
; 204         if (Checked(hwnd,HWF_TX_HIHALF))
	push	02c5h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL57

; 205           *pwTxFIFOload = 3;
	mov	eax,[ebp+010h];	pwTxFIFOload
	mov	word ptr [eax],03h
	jmp	@BLBL54
	align 010h
@BLBL57:

; 206         else
; 207           *pwTxFIFOload = 4;
	mov	eax,[ebp+010h];	pwTxFIFOload
	mov	word ptr [eax],04h

; 208       }
@BLBL54:

; 209      /*
; 210      **  Turn on bit to tell COMi that user has selected defaults for flag3
; 211      */
; 212     *pwFlags |= 0x8000;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-04h],eax;	@CBE4
	mov	eax,[ebp-04h];	@CBE4
	mov	cx,[eax]
	or	cx,08000h
	mov	[eax],cx

; 213     }
@BLBL44:

; 214   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
UnloadCfgFIFOsetupDlg	endp

; 218   {
	align 010h

TCCfgFIFOsetupDlg	proc
	push	ebp
	mov	ebp,esp

; 219   switch(idButton)
	xor	eax,eax
	mov	ax,[ebp+0ch];	idButton
	jmp	@BLBL63
	align 04h
@BLBL64:

; 220     {
; 221     case HWF_DISABFIFO:
; 222       if (!Checked(hwnd,HWF_DISABFIFO))
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL59

; 223         {
; 224 //        CheckButton(hwnd,HWF_1TRIG,TRUE);
; 225 //        CheckButton(hwnd,HWF_TX_MIN,TRUE);
; 226         CheckButton(hwnd,HWF_DISABFIFO,TRUE);
	push	01h
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 227         CheckButton(hwnd,HWF_APO,FALSE);
	push	0h
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 228         CheckButton(hwnd,HWF_ENABFIFO,FALSE);
	push	0h
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 229         ControlEnable(hwnd,HWF_1TRIG,FALSE);
	push	0h
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 230         ControlEnable(hwnd,HWF_4TRIG,FALSE);
	push	0h
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 231         ControlEnable(hwnd,HWF_8TRIG,FALSE);
	push	0h
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 232         ControlEnable(hwnd,HWF_14TRIG,FALSE);
	push	0h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 233         ControlEnable(hwnd,HWF_TX_HALF,FALSE);
	push	0h
	push	02c2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 234         ControlEnable(hwnd,HWF_TX_MIN,FALSE);
	push	0h
	push	02c3h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 235         ControlEnable(hwnd,HWF_TX_HIHALF,FALSE);
	push	0h
	push	02c5h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 236         ControlEnable(hwnd,HWF_TX_MAX,FALSE);
	push	0h
	push	02c4h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 237         }
@BLBL59:

; 238       break;
	jmp	@BLBL62
	align 04h
@BLBL65:

; 239     case HWF_APO:
; 240       if (!Checked(hwnd,HWF_APO))
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL60

; 241         {
; 242 //        if (Checked(hwnd,HWF_DISABFIFO))
; 243 //          {
; 244 //          CheckButton(hwnd,HWF_14TRIG,TRUE);
; 245 //          CheckButton(hwnd,HWF_TX_MAX,TRUE);
; 246 //          }
; 247         CheckButton(hwnd,HWF_APO,TRUE);
	push	01h
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 248         CheckButton(hwnd,HWF_ENABFIFO,FALSE);
	push	0h
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 249         CheckButton(hwnd,HWF_DISABFIFO,FALSE);
	push	0h
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 250         ControlEnable(hwnd,HWF_1TRIG,TRUE);
	push	01h
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 251         ControlEnable(hwnd,HWF_4TRIG,TRUE);
	push	01h
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 252         ControlEnable(hwnd,HWF_8TRIG,TRUE);
	push	01h
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 253         ControlEnable(hwnd,HWF_14TRIG,TRUE);
	push	01h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 254         ControlEnable(hwnd,HWF_TX_HALF,TRUE);
	push	01h
	push	02c2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 255         ControlEnable(hwnd,HWF_TX_MIN,TRUE);
	push	01h
	push	02c3h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 256         ControlEnable(hwnd,HWF_TX_HIHALF,TRUE);
	push	01h
	push	02c5h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 257         ControlEnable(hwnd,HWF_TX_MAX,TRUE);
	push	01h
	push	02c4h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 258         }
@BLBL60:

; 259       break;
	jmp	@BLBL62
	align 04h
@BLBL66:

; 260     case HWF_ENABFIFO:
; 261       if (!Checked(hwnd,HWF_ENABFIFO))
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL61

; 262         {
; 263 //        if (Checked(hwnd,HWF_DISABFIFO))
; 264 //          {
; 265 //          CheckButton(hwnd,HWF_14TRIG,TRUE);
; 266 //          CheckButton(hwnd,HWF_TX_MAX,TRUE);
; 267 //          }
; 268         CheckButton(hwnd,HWF_ENABFIFO,TRUE);
	push	01h
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 269         CheckButton(hwnd,HWF_APO,FALSE);
	push	0h
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 270         CheckButton(hwnd,HWF_DISABFIFO,FALSE);
	push	0h
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 271         ControlEnable(hwnd,HWF_1TRIG,TRUE);
	push	01h
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 272         ControlEnable(hwnd,HWF_4TRIG,
; 272 TRUE);
	push	01h
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 273         ControlEnable(hwnd,HWF_8TRIG,TRUE);
	push	01h
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 274         ControlEnable(hwnd,HWF_14TRIG,TRUE);
	push	01h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 275         ControlEnable(hwnd,HWF_TX_HALF,TRUE);
	push	01h
	push	02c2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 276         ControlEnable(hwnd,HWF_TX_MIN,TRUE);
	push	01h
	push	02c3h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 277         ControlEnable(hwnd,HWF_TX_HIHALF,TRUE);
	push	01h
	push	02c5h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 278         ControlEnable(hwnd,HWF_TX_MAX,TRUE);
	push	01h
	push	02c4h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 279         }
@BLBL61:

; 280       break;
	jmp	@BLBL62
	align 04h
@BLBL67:

; 281     default:
; 282       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL62
	align 04h
@BLBL63:
	cmp	eax,01a7h
	je	@BLBL64
	cmp	eax,01a5h
	je	@BLBL65
	cmp	eax,01a6h
	je	@BLBL66
	jmp	@BLBL67
	align 04h
@BLBL62:

; 283     }
; 284   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
TCCfgFIFOsetupDlg	endp
CODE32	ends
end
