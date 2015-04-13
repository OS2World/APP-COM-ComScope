	title	p:\config\cfg_prot_hlp.c
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
	public	aulCfgExtBaudTable
	extrn	_dllentry:proc
	extrn	_sprintfieee:proc
	extrn	WinSendDlgItemMsg:proc
	extrn	WinSetDlgItemText:proc
	extrn	CheckButton:proc
	extrn	ControlEnable:proc
	extrn	WinQueryDlgItemText:proc
	extrn	ASCIItoBin:proc
	extrn	Checked:proc
	extrn	WinWindowFromID:proc
	extrn	atol:proc
	extrn	_fullDump:dword
DATA32	segment
@STAT1	db "%02X",0h
	align 04h
@STAT2	db "%02X",0h
@STAT3	db "%u",0h
@STAT4	db "%u",0h
	align 04h
@STAT5	db "%02X",0h
	align 04h
@STAT6	db "%02X",0h
	dd	_dllentry
DATA32	ends
CONST32_RO	segment
aulCfgExtBaudTable	db "2",0h,0h,0h
	db "K",0h,0h,0h
	db "n",0h,0h,0h
	db 096h,0h,0h,0h
	db ",",01h,0h,0h
	db "X",02h,0h,0h
	db 0b0h,04h,0h,0h
	db "`",09h,0h,0h
	db 0c0h,012h,0h,0h
	db " ",01ch,0h,0h
	db 080h,"%",0h,0h
	db "@8",0h,0h
	db 0h,"K",0h,0h
	db 080h,"p",0h,0h
	db 0h,096h,0h,0h
	db 0h,0e1h,0h,0h
	db 0h,",",01h,0h
	db 0h,"h",01h,0h
	db 0h,0c2h,01h,0h
	db 0h,"X",02h,0h
	db 0h,084h,03h,0h
	db 0h,08h,07h,0h
	db 0h,0h,0h,0h
CONST32_RO	ends
CODE32	segment

; 17   {
	align 010h

	public FillCfgFilterDlg
FillCfgFilterDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax

; 21   sprintf(szReplaceChar,"%02X",pstComDCB->byErrorChar);
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	al,[ecx+022h]
	push	eax
	mov	edx,offset FLAT:@STAT1
	lea	eax,[ebp-05h];	szReplaceChar
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 22   WinSendDlgItemMsg(hwnd,HWR_ERRCHAR,EM_SETTEXTLIMIT,MPFROMSHORT(2),(MPARAM)NULL);
	push	0h
	push	02h
	push	0143h
	push	04b4h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 23   WinSetDlgItemText(hwnd,HWR_ERRCHAR,szReplaceChar);
	lea	eax,[ebp-05h];	szReplaceChar
	push	eax
	push	04b4h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 24 
; 25   sprintf(szReplaceChar,"%02X",pstComDCB->byBreakChar);
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	al,[ecx+023h]
	push	eax
	mov	edx,offset FLAT:@STAT2
	lea	eax,[ebp-05h];	szReplaceChar
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 26   WinSendDlgItemMsg(hwnd,HWR_BRKCHAR,EM_SETTEXTLIMIT,MPFROMSHORT(2),(MPARAM)NULL);
	push	0h
	push	02h
	push	0143h
	push	04b1h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 27   WinSetDlgItemText(hwnd,HWR_BRKCHAR,szReplaceChar);
	lea	eax,[ebp-05h];	szReplaceChar
	push	eax
	push	04b1h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 28 
; 29   if (pstComDCB->wFlags2 & F2_ENABLE_ERROR_REPL)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+010h],04h
	je	@BLBL1

; 30     bEnable = TRUE;
	mov	dword ptr [ebp-0ch],01h;	bEnable
	jmp	@BLBL2
	align 010h
@BLBL1:

; 31   else
; 32     bEnable = FALSE;
	mov	dword ptr [ebp-0ch],0h;	bEnable
@BLBL2:

; 33   CheckButton(hwnd,HWR_ENABERR,bEnable);
	push	dword ptr [ebp-0ch];	bEnable
	push	04b7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 34   ControlEnable(hwnd,HWR_ERRTTT,bEnable);
	push	dword ptr [ebp-0ch];	bEnable
	push	01453h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 35   ControlEnable(hwnd,HWR_ERRTT,bEnable);
	push	dword ptr [ebp-0ch];	bEnable
	push	01451h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 36   ControlEnable(hwnd,HWR_ERRT,bEnable);
	push	dword ptr [ebp-0ch];	bEnable
	push	04b3h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 37   ControlEnable(hwnd,HWR_ERRCHAR,bEnable);
	push	dword ptr [ebp-0ch];	bEnable
	push	04b4h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 38 
; 39   if (pstComDCB->wFlags2 & F2_ENABLE_NULL_STRIP)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+010h],08h
	je	@BLBL3

; 40     bEnable = TRUE;
	mov	dword ptr [ebp-0ch],01h;	bEnable
	jmp	@BLBL4
	align 010h
@BLBL3:

; 41   else
; 42     bEnable = FALSE;
	mov	dword ptr [ebp-0ch],0h;	bEnable
@BLBL4:

; 43   CheckButton(hwnd,HWR_ENABNUL,bEnable);
	push	dword ptr [ebp-0ch];	bEnable
	push	04b5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 44 
; 45   if (pstComDCB->wFlags2 & F2_ENABLE_BREAK_REPL)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+010h],010h
	je	@BLBL5

; 46     bEnable = TRUE;
	mov	dword ptr [ebp-0ch],01h;	bEnable
	jmp	@BLBL6
	align 010h
@BLBL5:

; 47   else
; 48     bEnable = FALSE;
	mov	dword ptr [ebp-0ch],0h;	bEnable
@BLBL6:

; 49   CheckButton(hwnd,HWR_ENABBRK,bEnable);
	push	dword ptr [ebp-0ch];	bEnable
	push	04b6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 50   ControlEnable(hwnd,HWR_BRKTTT,bEnable);
	push	dword ptr [ebp-0ch];	bEnable
	push	01454h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 51   ControlEnable(hwnd,HWR_BRKTT,bEnable);
	push	dword ptr [ebp-0ch];	bEnable
	push	01452h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 52   ControlEnable(hwnd,HWR_BRKT,bEnable);
	push	dword ptr [ebp-0ch];	bEnable
	push	04b2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 53   ControlEnable(hwnd,HWR_BRKCHAR,bEnable);
	push	dword ptr [ebp-0ch];	bEnable
	push	04b1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 54   }
	mov	esp,ebp
	pop	ebp
	ret	
FillCfgFilterDlg	endp

; 57   {
	align 010h

	public UnloadCfgFilterDlg
UnloadCfgFilterDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,020h
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
	pop	edi
	pop	eax

; 60   WinQueryDlgItemText(hwnd,HWR_ERRCHAR,3,szReplaceChar);
	lea	eax,[ebp-05h];	szReplaceChar
	push	eax
	push	03h
	push	04b4h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 61   pstComDCB->byErrorChar = (BYTE)ASCIItoBin(szReplaceChar,16);
	push	010h
	lea	eax,[ebp-05h];	szReplaceChar
	push	eax
	call	ASCIItoBin
	mov	ecx,eax
	add	esp,08h
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[eax+022h],cl

; 62 
; 63   WinQueryDlgItemText(hwnd,HWR_BRKCHAR,3,szReplaceChar);
	lea	eax,[ebp-05h];	szReplaceChar
	push	eax
	push	03h
	push	04b1h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 64   pstComDCB->byBreakChar = (BYTE)ASCIItoBin(szReplaceChar,16);
	push	010h
	lea	eax,[ebp-05h];	szReplaceChar
	push	eax
	call	ASCIItoBin
	mov	ecx,eax
	add	esp,08h
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[eax+023h],cl

; 65 
; 66   if (Checked(hwnd,HWR_ENABERR))
	push	04b7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL7

; 67     pstComDCB->wFlags2 |= F2_ENABLE_ERROR_REPL;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-020h],eax;	@CBE12
	mov	eax,[ebp-020h];	@CBE12
	mov	cx,[eax+010h]
	or	cl,04h
	mov	[eax+010h],cx
	jmp	@BLBL8
	align 010h
@BLBL7:

; 68   else
; 69     pstComDCB->wFlags2 &= ~F2_ENABLE_ERROR_REPL;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-01ch],eax;	@CBE11
	mov	eax,[ebp-01ch];	@CBE11
	xor	ecx,ecx
	mov	cx,[eax+010h]
	and	cl,0fbh
	mov	[eax+010h],cx
@BLBL8:

; 70 
; 71   if (Checked(hwnd,HWR_ENABBRK))
	push	04b6h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL9

; 72     pstComDCB->wFlags2 |= F2_ENABLE_BREAK_REPL;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-018h],eax;	@CBE10
	mov	eax,[ebp-018h];	@CBE10
	mov	cx,[eax+010h]
	or	cl,010h
	mov	[eax+010h],cx
	jmp	@BLBL10
	align 010h
@BLBL9:

; 73   else
; 74     pstComDCB->wFlags2 &= ~F2_ENABLE_BREAK_REPL;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-014h],eax;	@CBE9
	mov	eax,[ebp-014h];	@CBE9
	xor	ecx,ecx
	mov	cx,[eax+010h]
	and	cl,0efh
	mov	[eax+010h],cx
@BLBL10:

; 75 
; 76   if (Checked(hwnd,HWR_ENABNUL))
	push	04b5h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL11

; 77     pstComDCB->wFlags2 |= F2_ENABLE_NULL_STRIP;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-010h],eax;	@CBE8
	mov	eax,[ebp-010h];	@CBE8
	mov	cx,[eax+010h]
	or	cl,08h
	mov	[eax+010h],cx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL11:

; 78   else
; 79     pstComDCB->wFlags2 &= ~F2_ENABLE_NULL_STRIP;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-0ch],eax;	@CBE7
	mov	eax,[ebp-0ch];	@CBE7
	xor	ecx,ecx
	mov	cx,[eax+010h]
	and	cl,0f7h
	mov	[eax+010h],cx

; 80   }
	mov	esp,ebp
	pop	ebp
	ret	
UnloadCfgFilterDlg	endp

; 83   {
	align 010h

	public TCCfgFilterDlg
TCCfgFilterDlg	proc
	push	ebp
	mov	ebp,esp

; 84   switch(usButtonId)
	xor	eax,eax
	mov	ax,[ebp+0ch];	usButtonId
	jmp	@BLBL18
	align 04h
@BLBL19:

; 85     {
; 86     case HWR_ENABERR:
; 87       if (!Checked(hwnd,HWR_ENABERR))
	push	04b7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL13

; 88         {
; 89         ControlEnable(hwnd,HWR_ERRTTT,FALSE);
	push	0h
	push	01453h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 90         ControlEnable(hwnd,HWR_ERRTT,FALSE);
	push	0h
	push	01451h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 91         ControlEnable(hwnd,HWR_ERRT,FALSE);
	push	0h
	push	04b3h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 92         ControlEnable(hwnd,HWR_ERRCHAR,FALSE);
	push	0h
	push	04b4h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 93         }
	jmp	@BLBL14
	align 010h
@BLBL13:

; 94       else
; 95         {
; 96         ControlEnable(hwnd,HWR_ERRTTT,TRUE);
	push	01h
	push	01453h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 97         ControlEnable(hwnd,HWR_ERRTT,TRUE);
	push	01h
	push	01451h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 98         ControlEnable(hwnd,HWR_ERRT,TRUE);
	push	01h
	push	04b3h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 99         ControlEnable(hwnd,HWR_ERRCHAR,TRUE);
	push	01h
	push	04b4h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 100         }
@BLBL14:

; 101       break;
	jmp	@BLBL17
	align 04h
@BLBL20:

; 102     case HWR_ENABBRK:
; 103       if (!Checked(hwnd,HWR_ENABBRK))
	push	04b6h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL15

; 104         {
; 105         ControlEnable(hwnd,HWR_BRKTTT,FALSE);
	push	0h
	push	01454h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 106         ControlEnable(hwnd,HWR_BRKTT,FALSE);
	push	0h
	push	01452h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 107         ControlEnable(hwnd,HWR_BRKT,FALSE);
	push	0h
	push	04b2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 108         ControlEnable(hwnd,HWR_BRKCHAR,FALSE);
	push	0h
	push	04b1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 109         }
	jmp	@BLBL16
	align 010h
@BLBL15:

; 110       else
; 111         {
; 112         ControlEnable(hwnd,HWR_BRKTTT,TRUE);
	push	01h
	push	01454h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 113         ControlEnable(hwnd,HWR_BRKTT,TRUE);
	push	01h
	push	01452h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 114         ControlEnable(hwnd,HWR_BRKT,TRUE);
	push	01h
	push	04b2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 115         ControlEnable(hwnd,HWR_BRKCHAR,TRUE);
	push	01h
	push	04b1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 116         }
@BLBL16:

; 117       break;
	jmp	@BLBL17
	align 04h
	jmp	@BLBL17
	align 04h
@BLBL18:
	cmp	eax,04b7h
	je	@BLBL19
	cmp	eax,04b6h
	je	@BLBL20
@BLBL17:

; 118     }
; 119   }
	mov	esp,ebp
	pop	ebp
	ret	
TCCfgFilterDlg	endp

; 122   {
	align 010h

	public FillCfgTimeoutDlg
FillCfgTimeoutDlg	proc
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

; 127   if (pstComDCB->wFlags3 == 0)
	mov	eax,[ebp+0ch];	pstComDCB
	cmp	word ptr [eax+012h],0h
	jne	@BLBL21

; 128     pstComDCB->wFlags3 = F3_DEFAULT;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	word ptr [eax+012h],0f2h
@BLBL21:

; 129   if (pstComDCB->wRdTimeout == 0)
	mov	eax,[ebp+0ch];	pstComDCB
	cmp	word ptr [eax+016h],0h
	jne	@BLBL22

; 130     pstComDCB->wRdTimeout = DEF_READ_TIMEOUT;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	word ptr [eax+016h],01770h
@BLBL22:

; 131   if (pstComDCB->wWrtTimeout == 0)
	mov	eax,[ebp+0ch];	pstComDCB
	cmp	word ptr [eax+014h],0h
	jne	@BLBL23

; 132     pstComDCB->wWrtTimeout = DEF_WRITE_TIMEOUT;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	word ptr [eax+014h],01770h
@BLBL23:

; 133 
; 134   sprintf(szTimeout,"%u",pstComDCB->wRdTimeout);
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	ax,[ecx+016h]
	push	eax
	mov	edx,offset FLAT:@STAT3
	lea	eax,[ebp-08h];	szTimeout
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 135   WinSetDlgItemText(hwnd,HWT_RTIME,szTimeout);
	lea	eax,[ebp-08h];	szTimeout
	push	eax
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 136   WinSendDlgItemMsg(hwnd,HWT_RTIME,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
	push	0h
	push	05h
	push	0143h
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 137 
; 138   sprintf(szTimeout,"%u",pstComDCB->wWrtTimeout);
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	ax,[ecx+014h]
	push	eax
	mov	edx,offset FLAT:@STAT4
	lea	eax,[ebp-08h];	szTimeout
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 139   WinSendDlgItemMsg(hwnd,HWT_WTIME,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
	push	0h
	push	05h
	push	0143h
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 140   WinSetDlgItemText(hwnd,HWT_WTIME,szTimeout);
	lea	eax,[ebp-08h];	szTimeout
	push	eax
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 141 
; 142   if (pstComDCB->wFlags3 & F3_INFINITE_WRT_TIMEOUT)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+012h],01h
	je	@BLBL24

; 143     {
; 144     bEnable = FALSE;
	mov	dword ptr [ebp-010h],0h;	bEnable

; 145     CheckButton(hwnd,HWT_WINF,TRUE);
	push	01h
	push	03efh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 146     }
	jmp	@BLBL25
	align 010h
@BLBL24:

; 147   else
; 148     {
; 149     bEnable = TRUE;
	mov	dword ptr [ebp-010h],01h;	bEnable

; 150     CheckButton(hwnd,HWT_WNORM,TRUE);
	push	01h
	push	03f0h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 151     }
@BLBL25:

; 152 
; 153   ControlEnable(hwnd,HWT_WTIMET,bEnable);
	push	dword ptr [ebp-010h];	bEnable
	push	03eeh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 154   ControlEnable(hwnd,HWT_WTIME,bEnable);
	push	dword ptr [ebp-010h];	bEnable
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 155 
; 156   if ((pstComDCB->wFlags3 & F3_RTO_MASK) == F3_WAIT_NONE) // first mask significant bits
	mov	eax,[ebp+0ch];	pstComDCB
	mov	ax,[eax+012h]
	and	ax,06h
	cmp	ax,06h
	jne	@BLBL26

; 157     {
; 158     bEnable = FALSE;
	mov	dword ptr [ebp-010h],0h;	bEnable

; 159     CheckButton(hwnd,HWT_RNOWAIT,TRUE);
	push	01h
	push	03e9h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 160     usEntryFocusId = HWT_RNOWAIT;
	mov	word ptr [ebp-0ah],03e9h;	usEntryFocusId

; 161     }
	jmp	@BLBL27
	align 010h
@BLBL26:

; 162   else
; 163     {
; 164     bEnable = TRUE;
	mov	dword ptr [ebp-010h],01h;	bEnable

; 165     if ((pstComDCB->wFlags3  & F3_RTO_MASK) == F3_WAIT_SOMETHING)
	mov	eax,[ebp+0ch];	pstComDCB
	mov	ax,[eax+012h]
	and	ax,06h
	cmp	ax,04h
	jne	@BLBL28

; 166       {
; 167       CheckButton(hwnd,HWT_RWAITSOME,TRUE);
	push	01h
	push	03eah
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 168       usEntryFocusId = HWT_RWAITSOME;
	mov	word ptr [ebp-0ah],03eah;	usEntryFocusId

; 169       }
	jmp	@BLBL27
	align 010h
@BLBL28:

; 170     else
; 171       {
; 172       CheckButton(hwnd,HWT_RNORM,TRUE);
	push	01h
	push	03ebh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 173       usEntryFocusId = HWT_RNORM;
	mov	word ptr [ebp-0ah],03ebh;	usEntryFocusId

; 174       }

; 175     }
@BLBL27:

; 176 
; 177   ControlEnable(hwnd,HWT_RTIMET,bEnable);
	push	dword ptr [ebp-010h];	bEnable
	push	03f2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 178   ControlEnable(hwnd,HWT_RTIME,bEnable);
	push	dword ptr [ebp-010h];	bEnable
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 179 
; 180   return(WinWindowFromID(hwnd,usEntryFocusId));
	xor	eax,eax
	mov	ax,[ebp-0ah];	usEntryFocusId
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinWindowFromID
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
FillCfgTimeoutDlg	endp

; 184   {
	align 010h

	public UnloadCfgTimeoutDlg
UnloadCfgTimeoutDlg	proc
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
	sub	esp,04h

; 187   if (Checked(hwnd,HWT_WINF))
	push	03efh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL30

; 188     pstComDCB->wFlags3 |= F3_INFINITE_WRT_TIMEOUT;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-028h],eax;	@CBE19
	mov	eax,[ebp-028h];	@CBE19
	mov	cx,[eax+012h]
	or	cl,01h
	mov	[eax+012h],cx
	jmp	@BLBL31
	align 010h
@BLBL30:

; 189   else
; 190     pstComDCB->wFlags3 &= ~F3_INFINITE_WRT_TIMEOUT;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-024h],eax;	@CBE18
	mov	eax,[ebp-024h];	@CBE18
	xor	ecx,ecx
	mov	cx,[eax+012h]
	and	cl,0feh
	mov	[eax+012h],cx
@BLBL31:

; 191 
; 192   pstComDCB->wFlags3 &= ~F3_RTO_MASK;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-020h],eax;	@CBE17
	mov	eax,[ebp-020h];	@CBE17
	xor	ecx,ecx
	mov	cx,[eax+012h]
	and	cl,0f9h
	mov	[eax+012h],cx

; 193   if (Checked(hwnd,HWT_RNOWAIT))
	push	03e9h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL32

; 194     pstComDCB->wFlags3 |= F3_WAIT_NONE;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-01ch],eax;	@CBE16
	mov	eax,[ebp-01ch];	@CBE16
	mov	cx,[eax+012h]
	or	cl,06h
	mov	[eax+012h],cx
	jmp	@BLBL33
	align 010h
@BLBL32:

; 195   else
; 196     {
; 197     if (Checked(hwnd,HWT_RWAITSOME))
	push	03eah
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL34

; 198       pstComDCB->wFlags3 |= F3_WAIT_SOMETHING;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-018h],eax;	@CBE15
	mov	eax,[ebp-018h];	@CBE15
	mov	cx,[eax+012h]
	or	cl,04h
	mov	[eax+012h],cx
	jmp	@BLBL33
	align 010h
@BLBL34:

; 199     else
; 200       pstComDCB->wFlags3 |= F3_WAIT_NORM;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-014h],eax;	@CBE14
	mov	eax,[ebp-014h];	@CBE14
	mov	cx,[eax+012h]
	or	cl,02h
	mov	[eax+012h],cx

; 201     }
@BLBL33:

; 202   pstComDCB->wFlags3 |= 0x8000;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-010h],eax;	@CBE13
	mov	eax,[ebp-010h];	@CBE13
	mov	cx,[eax+012h]
	or	cx,08000h
	mov	[eax+012h],cx

; 203 
; 204   WinQueryDlgItemText(hwnd,HWT_WTIME,6,szTimeout);
	lea	eax,[ebp-09h];	szTimeout
	push	eax
	push	06h
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 205   pstComDCB->wWrtTimeout = (WORD)atol(szTimeout);
	lea	eax,[ebp-09h];	szTimeout
	call	atol
	mov	ecx,eax
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[eax+014h],cx

; 206 
; 207   WinQueryDlgItemText(hwnd,HWT_RTIME,6,szTimeout);
	lea	eax,[ebp-09h];	szTimeout
	push	eax
	push	06h
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 208   pstComDCB->wRdTimeout = (WORD)atol(szTimeout);
	lea	eax,[ebp-09h];	szTimeout
	call	atol
	mov	ecx,eax
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[eax+016h],cx

; 209   }
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
UnloadCfgTimeoutDlg	endp

; 212   {
	align 010h

	public TCCfgTimeoutDlg
TCCfgTimeoutDlg	proc
	push	ebp
	mov	ebp,esp

; 213   switch(idButton)
	xor	eax,eax
	mov	ax,[ebp+0ch];	idButton
	jmp	@BLBL46
	align 04h
@BLBL47:

; 214     {
; 215     case HWT_RNOWAIT:
; 216       if (Checked(hwnd,HWT_RNOWAIT))
	push	03e9h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL36

; 217         {
; 218         ControlEnable(hwnd,HWT_RTIMET,FALSE);
	push	0h
	push	03f2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 219         ControlEnable(hwnd,HWT_RTIME,FALSE);
	push	0h
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 220         }
	jmp	@BLBL37
	align 010h
@BLBL36:

; 221       else
; 222         {
; 223         ControlEnable(hwnd,HWT_RTIMET,TRUE);
	push	01h
	push	03f2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 224         ControlEnable(hwnd,HWT_RTIME,TRUE);
	push	01h
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 225         }
@BLBL37:

; 226       break;
	jmp	@BLBL45
	align 04h
@BLBL48:
@BLBL49:

; 227     case HWT_RNORM:
; 228     case HWT_RWAITSOME:
; 229       if (Checked(hwnd,HWT_RNORM) || Checked(hwnd,HWT_RWAITSOME))
	push	03ebh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL38
	push	03eah
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL39
@BLBL38:

; 230         {
; 231         ControlEnable(hwnd,HWT_RTIMET,TRUE);
	push	01h
	push	03f2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 232         ControlEnable(hwnd,HWT_RTIME,TRUE);
	push	01h
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 233         }
	jmp	@BLBL40
	align 010h
@BLBL39:

; 234       else
; 235         {
; 236         ControlEnable(hwnd,HWT_RTIMET,FALSE);
	push	0h
	push	03f2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 237         ControlEnable(hwnd,HWT_RTIME,FALSE);
	push	0h
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 238         }
@BLBL40:

; 239       break;
	jmp	@BLBL45
	align 04h
@BLBL50:

; 240     case HWT_WINF:
; 241       if (Checked(hwnd,HWT_WINF))
	push	03efh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL41

; 242         {
; 243         ControlEnable(hwnd,HWT_WTIMET,FALSE);
	push	0h
	push	03eeh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 244         ControlEnable(hwnd,HWT_WTIME,FALSE);
	push	0h
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 245         }
	jmp	@BLBL42
	align 010h
@BLBL41:

; 246       else
; 247         {
; 248         ControlEnable(hwnd,HWT_WTIMET,TRUE);
	push	01h
	push	03eeh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 249         ControlEnable(hwnd,HWT_WTIME,TRUE);
	push	01h
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 250         }
@BLBL42:

; 251       break;
	jmp	@BLBL45
	align 04h
@BLBL51:

; 252     case HWT_WNORM:
; 253       if (Checked(hwnd,HWT_WNORM))
	push	03f0h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL43

; 254         {
; 255         ControlEnable(hwnd,HWT_WTIMET,TRUE);
	push	01h
	push	03eeh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 256         ControlEnable(hwnd,HWT_WTIME,TRUE);
	push	01h
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 257         }
	jmp	@BLBL44
	align 010h
@BLBL43:

; 258       else
; 259         {
; 260         ControlEnable(hwnd,HWT_WTIMET,FALSE);
	push	0h
	push	03eeh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 261         ControlEnable(hwnd,HWT_WTIME,FALSE);
	push	0h
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 262         }
@BLBL44:

; 263       break;
	jmp	@BLBL45
	align 04h
@BLBL52:

; 264     default:
; 265       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL45
	align 04h
@BLBL46:
	cmp	eax,03e9h
	je	@BLBL47
	cmp	eax,03ebh
	je	@BLBL48
	cmp	eax,03eah
	je	@BLBL49
	cmp	eax,03efh
	je	@BLBL50
	cmp	eax,03f0h
	je	@BLBL51
	jmp	@BLBL52
	align 04h
@BLBL45:

; 266     }
; 267   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
TCCfgTimeoutDlg	endp

; 271   {
	align 010h

	public FillCfgProtocolDlg
FillCfgProtocolDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 275   if (byLineChar == 0)
	cmp	byte ptr [ebp+0ch],0h;	byLineChar
	jne	@BLBL53

; 276     {
; 277     CheckButton(hwnd,HWP_8BITS,TRUE);
	push	01h
	push	0191h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 278     CheckButton(hwnd,HWP_1BIT,TRUE);
	push	01h
	push	0195h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 279     CheckButton(hwnd,HWP_EVEN,TRUE);
	push	01h
	push	0198h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 280     ControlEnable(hwnd,HWP_15BITS,FALSE);
	push	0h
	push	0196h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 281     }
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL53:

; 282   else
; 283     {
; 284     idDisableField = HWP_15BITS;
	mov	word ptr [ebp-02h],0196h;	idDisableField

; 285     switch (byLineChar & 0x03)
	xor	eax,eax
	mov	al,[ebp+0ch];	byLineChar
	and	eax,03h
	jmp	@BLBL62
	align 04h
@BLBL63:

; 286       {
; 287       case 3:
; 288         idEntryField = HWP_8BITS;
	mov	word ptr [ebp-04h],0191h;	idEntryField

; 289         break;
	jmp	@BLBL61
	align 04h
@BLBL64:

; 290       case 2:
; 291         idEntryField = HWP_7BITS;
	mov	word ptr [ebp-04h],0192h;	idEntryField

; 292         break;
	jmp	@BLBL61
	align 04h
@BLBL65:

; 293       case 1:
; 294         idEntryField = HWP_6BITS;
	mov	word ptr [ebp-04h],0193h;	idEntryField

; 295         break;
	jmp	@BLBL61
	align 04h
@BLBL66:

; 296       case 0:
; 297         idEn
; 297 tryField = HWP_5BITS;
	mov	word ptr [ebp-04h],0194h;	idEntryField

; 298         idDisableField = HWP_2BITS;
	mov	word ptr [ebp-02h],0197h;	idDisableField

; 299         break;
	jmp	@BLBL61
	align 04h
	jmp	@BLBL61
	align 04h
@BLBL62:
	cmp	eax,03h
	je	@BLBL63
	cmp	eax,02h
	je	@BLBL64
	cmp	eax,01h
	je	@BLBL65
	test	eax,eax
	je	@BLBL66
@BLBL61:

; 300       }
; 301     CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-04h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 302 
; 303     if (idEntryField == HWP_5BITS)
	cmp	word ptr [ebp-04h],0194h;	idEntryField
	jne	@BLBL55

; 304       if ((byLineChar & 0x04) != 0)
	test	byte ptr [ebp+0ch],04h;	byLineChar
	je	@BLBL56

; 305         CheckButton(hwnd,HWP_15BITS,TRUE);
	push	01h
	push	0196h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL58
	align 010h
@BLBL56:

; 306       else
; 307         CheckButton(hwnd,HWP_1BIT,TRUE);
	push	01h
	push	0195h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL58
	align 010h
@BLBL55:

; 308     else
; 309       if ((byLineChar & 0x04) != 0)
	test	byte ptr [ebp+0ch],04h;	byLineChar
	je	@BLBL59

; 310         CheckButton(hwnd,HWP_2BITS,TRUE);
	push	01h
	push	0197h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL58
	align 010h
@BLBL59:

; 311       else
; 312         CheckButton(hwnd,HWP_1BIT,TRUE);
	push	01h
	push	0195h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL58:

; 313 
; 314     ControlEnable(hwnd,idDisableField,FALSE);
	push	0h
	mov	ax,[ebp-02h];	idDisableField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 315     CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-04h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 316     switch (byLineChar & 0x38)
	xor	eax,eax
	mov	al,[ebp+0ch];	byLineChar
	and	eax,038h
	jmp	@BLBL68
	align 04h
@BLBL69:

; 317       {
; 318       case 0x00:
; 319         idEntryField = HWP_NONE;
	mov	word ptr [ebp-04h],019ah;	idEntryField

; 320         break;
	jmp	@BLBL67
	align 04h
@BLBL70:

; 321       case 0x08:
; 322         idEntryField = HWP_ODD;
	mov	word ptr [ebp-04h],0199h;	idEntryField

; 323         break;
	jmp	@BLBL67
	align 04h
@BLBL71:

; 324       case 0x18:
; 325         idEntryField = HWP_EVEN;
	mov	word ptr [ebp-04h],0198h;	idEntryField

; 326         break;
	jmp	@BLBL67
	align 04h
@BLBL72:

; 327       case 0x38:
; 328         idEntryField = HWP_ZERO;
	mov	word ptr [ebp-04h],019ch;	idEntryField

; 329         break;
	jmp	@BLBL67
	align 04h
@BLBL73:

; 330       case 0x28:
; 331         idEntryField = HWP_ONE;
	mov	word ptr [ebp-04h],019bh;	idEntryField

; 332         break;
	jmp	@BLBL67
	align 04h
	jmp	@BLBL67
	align 04h
@BLBL68:
	test	eax,eax
	je	@BLBL69
	cmp	eax,08h
	je	@BLBL70
	cmp	eax,018h
	je	@BLBL71
	cmp	eax,038h
	je	@BLBL72
	cmp	eax,028h
	je	@BLBL73
@BLBL67:

; 333       }
; 334     CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-04h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 335     }

; 336   }
	mov	esp,ebp
	pop	ebp
	ret	
FillCfgProtocolDlg	endp

; 339   {
	align 010h

	public UnloadCfgProtocolDlg
UnloadCfgProtocolDlg	proc
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

; 340   if (Checked(hwnd,HWP_8BITS))
	push	0191h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL74

; 341     *pbyLineChar = 0x03;
	mov	eax,[ebp+0ch];	pbyLineChar
	mov	byte ptr [eax],03h
	jmp	@BLBL75
	align 010h
@BLBL74:

; 342   else
; 343     if (Checked(hwnd,HWP_7BITS))
	push	0192h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL76

; 344       *pbyLineChar = 0x02;
	mov	eax,[ebp+0ch];	pbyLineChar
	mov	byte ptr [eax],02h
	jmp	@BLBL75
	align 010h
@BLBL76:

; 345     else
; 346       if (Checked(hwnd,HWP_6BITS))
	push	0193h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL78

; 347         *pbyLineChar = 0x01;
	mov	eax,[ebp+0ch];	pbyLineChar
	mov	byte ptr [eax],01h
	jmp	@BLBL75
	align 010h
@BLBL78:

; 348       else
; 349         *pbyLineChar = 0x00;
	mov	eax,[ebp+0ch];	pbyLineChar
	mov	byte ptr [eax],0h
@BLBL75:

; 350 
; 351   if (!Checked(hwnd,HWP_1BIT))
	push	0195h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL80

; 352     *pbyLineChar |= 0x04;
	mov	eax,[ebp+0ch];	pbyLineChar
	mov	[ebp-018h],eax;	@CBE25
	mov	eax,[ebp-018h];	@CBE25
	mov	cl,[eax]
	or	cl,04h
	mov	[eax],cl
@BLBL80:

; 353 
; 354   if (!Checked(hwnd,HWP_NONE))
	push	019ah
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL81

; 355     if (Checked(hwnd,HWP_ODD))
	push	0199h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL82

; 356       *pbyLineChar |= 0x08;
	mov	eax,[ebp+0ch];	pbyLineChar
	mov	[ebp-014h],eax;	@CBE24
	mov	eax,[ebp-014h];	@CBE24
	mov	cl,[eax]
	or	cl,08h
	mov	[eax],cl
	jmp	@BLBL81
	align 010h
@BLBL82:

; 357     else
; 358       if (Checked(hwnd,HWP_EVEN))
	push	0198h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL84

; 359         *pbyLineChar |= 0x18;
	mov	eax,[ebp+0ch];	pbyLineChar
	mov	[ebp-010h],eax;	@CBE23
	mov	eax,[ebp-010h];	@CBE23
	mov	cl,[eax]
	or	cl,018h
	mov	[eax],cl
	jmp	@BLBL81
	align 010h
@BLBL84:

; 360       else
; 361         if (Checked(hwnd,HWP_ZERO))
	push	019ch
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL86

; 362           *pbyLineChar |= 0x38;
	mov	eax,[ebp+0ch];	pbyLineChar
	mov	[ebp-0ch],eax;	@CBE22
	mov	eax,[ebp-0ch];	@CBE22
	mov	cl,[eax]
	or	cl,038h
	mov	[eax],cl
	jmp	@BLBL81
	align 010h
@BLBL86:

; 363         else
; 364           *pbyLineChar |= 0x28;
	mov	eax,[ebp+0ch];	pbyLineChar
	mov	[ebp-08h],eax;	@CBE21
	mov	eax,[ebp-08h];	@CBE21
	mov	cl,[eax]
	or	cl,028h
	mov	[eax],cl
@BLBL81:

; 365 
; 366   *pbyLineChar |= 0xc0;
	mov	eax,[ebp+0ch];	pbyLineChar
	mov	[ebp-04h],eax;	@CBE20
	mov	eax,[ebp-04h];	@CBE20
	mov	cl,[eax]
	or	cl,0c0h
	mov	[eax],cl

; 367   }
	mov	esp,ebp
	pop	ebp
	ret	
UnloadCfgProtocolDlg	endp

; 370   {
	align 010h

	public TCCfgProtocolDlg
TCCfgProtocolDlg	proc
	push	ebp
	mov	ebp,esp

; 371   switch(idButton)
	xor	eax,eax
	mov	ax,[ebp+0ch];	idButton
	jmp	@BLBL91
	align 04h
@BLBL92:

; 372     {
; 373     case HWP_5BITS:
; 374 //      CheckButton(hwnd,idButton,~Checked(hwnd,idButton));
; 375       ControlEnable(hwnd,HWP_15BITS,TRUE);
	push	01h
	push	0196h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 376       ControlEnable(hwnd,HWP_2BITS,FALSE);
	push	0h
	push	0197h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 377       if (Checked(hwnd,HWP_2BITS))
	push	0197h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL88

; 378         {
; 379         CheckButton(hwnd,HWP_2BITS,FALSE);
	push	0h
	push	0197h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 380         CheckButton(hwnd,HWP_15BITS,TRUE);
	push	01h
	push	0196h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 381         }
@BLBL88:

; 382       break;
	jmp	@BLBL90
	align 04h
@BLBL93:
@BLBL94:
@BLBL95:

; 383     case HWP_8BITS:
; 384     case HWP_7BITS:
; 385     case HWP_6BITS:
; 386 //      CheckButton(hwnd,idButton,~Checked(hwnd,idButton));
; 387       ControlEnable(hwnd,HWP_15BITS,FALSE);
	push	0h
	push	0196h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 388       ControlEnable(hwnd,HWP_2BITS,TRUE);
	push	01h
	push	0197h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 389       if (Checked(hwnd,HWP_15BITS))
	push	0196h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL89

; 390         {
; 391         CheckButton(hwnd,HWP_15BITS,FALSE);
	push	0h
	push	0196h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 392         CheckButton(hwnd,HWP_2BITS,TRUE);
	push	01h
	push	0197h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 393         }
@BLBL89:
@BLBL96:

; 394     default:
; 395       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL90
	align 04h
@BLBL91:
	cmp	eax,0194h
	je	@BLBL92
	cmp	eax,0191h
	je	@BLBL93
	cmp	eax,0192h
	je	@BLBL94
	cmp	eax,0193h
	je	@BLBL95
	jmp	@BLBL96
	align 04h
@BLBL90:

; 396     }
; 397    return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
TCCfgProtocolDlg	endp

; 401   {
	align 010h

	public FillCfgFIFOsetupDlg
FillCfgFIFOsetupDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 422   if ((wFlags & F3_HDW_BUFFER_APO) != 0)
	test	byte ptr [ebp+0ch],018h;	wFlags
	je	@BLBL97

; 423     {
; 424     switch ((wFlags & F3_HDW_BUFFER_APO) >> 3)
	xor	eax,eax
	mov	ax,[ebp+0ch];	wFlags
	and	eax,018h
	sar	eax,03h
	jmp	@BLBL112
	align 04h
@BLBL113:

; 425       {
; 426       case 1:
; 427         idEntryField = HWF_DISABFIFO;
	mov	word ptr [ebp-02h],01a7h;	idEntryField

; 428         break;
	jmp	@BLBL111
	align 04h
@BLBL114:

; 429       case 2:
; 430         idEntryField = HWF_ENABFIFO;
	mov	word ptr [ebp-02h],01a6h;	idEntryField

; 431         break;
	jmp	@BLBL111
	align 04h
@BLBL115:

; 432       case 3:
; 433         idEntryField = HWF_APO;
	mov	word ptr [ebp-02h],01a5h;	idEntryField

; 434         break;
	jmp	@BLBL111
	align 04h
@BLBL116:

; 435       default:
; 436         idEntryField = 0;
	mov	word ptr [ebp-02h],0h;	idEntryField

; 437       }
	jmp	@BLBL111
	align 04h
@BLBL112:
	cmp	eax,01h
	je	@BLBL113
	cmp	eax,02h
	je	@BLBL114
	cmp	eax,03h
	je	@BLBL115
	jmp	@BLBL116
	align 04h
@BLBL111:

; 438     if (idEntryField != 0)
	cmp	word ptr [ebp-02h],0h;	idEntryField
	je	@BLBL98

; 439       CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-02h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL98:

; 440 
; 441     if ((pstFIFOinfo->wFIFOflags & FIFO_FLG_LOW_16750_TRIG) ||
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+05h],080h
	jne	@BLBL99

; 442         (pstFIFOinfo->wFIFOsize <= 32))
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	ax,[eax]
	cmp	ax,020h
	ja	@BLBL100
@BLBL99:

; 443       {
; 444       switch ((wFlags & F3_14_CHARACTER_FIFO) >> 5)
	xor	eax,eax
	mov	ax,[ebp+0ch];	wFlags
	and	eax,060h
	sar	eax,05h
	jmp	@BLBL118
	align 04h
@BLBL119:

; 445         {
; 446         case 0:
; 447           idEntryField = HWF_1TRIG;
	mov	word ptr [ebp-02h],01abh;	idEntryField

; 448           break;
	jmp	@BLBL117
	align 04h
@BLBL120:

; 449         case 1:
; 450           idEntryField = HWF_4TRIG;
	mov	word ptr [ebp-02h],01aah;	idEntryField

; 451           break;
	jmp	@BLBL117
	align 04h
@BLBL121:

; 452         case 2:
; 453           idEntryField = HWF_8TRIG;
	mov	word ptr [ebp-02h],01a9h;	idEntryField

; 454           break;
	jmp	@BLBL117
	align 04h
@BLBL122:

; 455         default:
; 456           idEntryField = HWF_14TRIG;
	mov	word ptr [ebp-02h],01a8h;	idEntryField

; 457           break;
	jmp	@BLBL117
	align 04h
	jmp	@BLBL117
	align 04h
@BLBL118:
	test	eax,eax
	je	@BLBL119
	cmp	eax,01h
	je	@BLBL120
	cmp	eax,02h
	je	@BLBL121
	jmp	@BLBL122
	align 04h
@BLBL117:

; 458         }
; 459       }
	jmp	@BLBL101
	align 010h
@BLBL100:

; 460     else
; 461       {
; 462       switch ((wFlags & F3_14_CHARACTER_FIFO) >> 5)
	xor	eax,eax
	mov	ax,[ebp+0ch];	wFlags
	and	eax,060h
	sar	eax,05h
	jmp	@BLBL124
	align 04h
@BLBL125:

; 463         {
; 464         case 0:
; 465           idEntryField = HWF_1TRIG;
	mov	word ptr [ebp-02h],01abh;	idEntryField

; 466           break;
	jmp	@BLBL123
	align 04h
@BLBL126:

; 467         case 1:
; 468           idEntryField = HWF_16TRIG;
	mov	word ptr [ebp-02h],02ceh;	idEntryField

; 469           break;
	jmp	@BLBL123
	align 04h
@BLBL127:

; 470         case 2:
; 471           idEntryField = HWF_32TRIG;
	mov	word ptr [ebp-02h],02d5h;	idEntryField

; 472           break;
	jmp	@BLBL123
	align 04h
@BLBL128:

; 473         default:
; 474           idEntryField = HWF_56TRIG;
	mov	word ptr [ebp-02h],02d6h;	idEntryField

; 475           break;
	jmp	@BLBL123
	align 04h
	jmp	@BLBL123
	align 04h
@BLBL124:
	test	eax,eax
	je	@BLBL125
	cmp	eax,01h
	je	@BLBL126
	cmp	eax,02h
	je	@BLBL127
	jmp	@BLBL128
	align 04h
@BLBL123:

; 476         }
; 477       }
@BLBL101:

; 478     CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-02h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 479 
; 480     if (pstFIFOinfo->wFIFOsize > 32)
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	ax,[eax]
	cmp	ax,020h
	jbe	@BLBL102

; 481       usMaxFIFOload = 64;
	mov	word ptr [ebp-04h],040h;	usMaxFIFOload
	jmp	@BLBL103
	align 010h
@BLBL102:

; 482     else
; 483       if (pstFIFOinfo->wFIFOsize > 16)
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	ax,[eax]
	cmp	ax,010h
	jbe	@BLBL104

; 484         usMaxFIFOload = 25;
	mov	word ptr [ebp-04h],019h;	usMaxFIFOload
	jmp	@BLBL103
	align 010h
@BLBL104:

; 485       else
; 486         usMaxFIFOload = 16;
	mov	word ptr [ebp-04h],010h;	usMaxFIFOload
@BLBL103:

; 487     if ((wFlags & F3_USE_TX_BUFFER) == 0)
	test	byte ptr [ebp+0ch],080h;	wFlags
	jne	@BLBL106

; 488       usCurrentFIFOload = 1;
	mov	word ptr [ebp-06h],01h;	usCurrentFIFOload
	jmp	@BLBL107
	align 010h
@BLBL106:

; 489     else
; 490       usCurrentFIFOload = pstFIFOinfo->wTxFIFOload;
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	ax,[eax+02h]
	mov	[ebp-06h],ax;	usCurrentFIFOload
@BLBL107:

; 491 
; 492     WinSendDlgItemMsg(hwnd,HWF_TXFIFO_LOAD,
	push	01h
	xor	eax,eax
	mov	ax,[ebp-04h];	usMaxFIFOload
	push	eax
	push	0207h
	push	02d8h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 493                               SPBM_SETLIMITS,
; 494                       (MPARAM)usMaxFIFOload,
; 495                       (MPARAM)1);
; 496 
; 497     if (usCurrentFIFOload > usMaxFIFOload)
	mov	ax,[ebp-04h];	usMaxFIFOload
	cmp	[ebp-06h],ax;	usCurrentFIFOload
	jbe	@BLBL108

; 498       usCurrentFIFOload = usMaxFIFOload;
	mov	ax,[ebp-04h];	usMaxFIFOload
	mov	[ebp-06h],ax;	usCurrentFIFOload
@BLBL108:

; 499     WinSendDlgItemMsg(hwnd,HWF_TXFIFO_LOAD,
	push	0h
	xor	eax,eax
	mov	ax,[ebp-06h];	usCurrentFIFOload
	push	eax
	push	0208h
	push	02d8h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 500                               SPBM_SETCURRENTVALUE,
; 501                       (MPARAM)usCurrentFIFOload,
; 502                               NULL);
; 503     }
@BLBL97:

; 504   if ((wFlags & F3_HDW_BUFFER_ENABLE) != F3_HDW_BUFFER_ENABLE)
	mov	ax,[ebp+0ch];	wFlags
	and	ax,010h
	cmp	ax,010h
	je	@BLBL109

; 505     {
; 506     ControlEnable(hwnd,HWF_1TRIG,FALSE);
	push	0h
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 507     ControlEnable(hwnd,HWF_4TRIG,FALSE);
	push	0h
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 508     ControlEnable(hwnd,HWF_8TRIG,FALSE);
	push	0h
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 509     ControlEnable(hwnd,HWF_14TRIG,FALSE);
	push	0h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 510     ControlEnable(hwnd,HWF_TXLOADT,FALSE);
	push	0h
	push	02c9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 511     ControlEnable(hwnd,HWF_TXLOADTT,FALSE);
	push	0h
	push	02d9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 512     ControlEnable(hwnd,HWF_TXFIFO_LOAD,FALSE);
	push	0h
	push	02d8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 513     if (usMaxFIFOload == 64)
	cmp	word ptr [ebp-04h],040h;	usMaxFIFOload
	jne	@BLBL109

; 514       {
; 515       ControlEnable(hwnd,HWF_32TRIG,FALSE);
	push	0h
	push	02d5h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 516       ControlEnable(hwnd,HWF_56TRIG,FALSE);
	push	0h
	push	02d6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 517       }

; 518     }
@BLBL109:

; 519   }
	mov	esp,ebp
	pop	ebp
	ret	
FillCfgFIFOsetupDlg	endp

; 522   {
	align 010h

	public UnloadCfgFIFOsetupDlg
UnloadCfgFIFOsetupDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,040h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,010h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 525   *pwFlags &= ~F3_FIFO_MASK;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-040h],eax;	@CBE40
	mov	eax,[ebp-040h];	@CBE40
	xor	ecx,ecx
	mov	cx,[eax]
	and	cl,07h
	mov	[eax],cx

; 526   if (Checked(hwnd,HWF_DISABFIFO))
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL129

; 527     *pwFlags |= F3_HDW_BUFFER_DISABLE;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-03ch],eax;	@CBE39
	mov	eax,[ebp-03ch];	@CBE39
	mov	cx,[eax]
	or	cl,08h
	mov	[eax],cx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL129:

; 528   else
; 529     {
; 530     if (Checked(hwnd,HWF_ENABFIFO))
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL131

; 531       *pwFlags |= F3_HDW_BUFFER_ENABLE;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-038h],eax;	@CBE38
	mov	eax,[ebp-038h];	@CBE38
	mov	cx,[eax]
	or	cl,010h
	mov	[eax],cx
	jmp	@BLBL132
	align 010h
@BLBL131:

; 532     else
; 533       *pwFlags |= F3_HDW_BUFFER_APO;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-034h],eax;	@CBE37
	mov	eax,[ebp-034h];	@CBE37
	mov	cx,[eax]
	or	cl,018h
	mov	[eax],cx
@BLBL132:

; 534 
; 535     *pwFlags |= F3_USE_TX_BUFFER;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-030h],eax;	@CBE36
	mov	eax,[ebp-030h];	@CBE36
	mov	cx,[eax]
	or	cl,080h
	mov	[eax],cx

; 536     WinSendDlgItemMsg(hwnd,
	push	030000h
	lea	eax,[ebp-04h];	lTemp
	push	eax
	push	0205h
	push	02d8h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 537                       HWF_TXFIFO_LOAD,
; 538                       SPBM_QUERYVALUE,
; 539                       &lTemp,
; 540                       MPFROM2SHORT(0,SPBQ_DONOTUPDATE));
; 541 
; 542     pstFIFOinfo->wTxFIFOload = (USHORT)lTemp;
	mov	ecx,[ebp-04h];	lTemp
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	[eax+02h],cx

; 543 
; 544     if (pstFIFOinfo->wTxFIFOload == 1)
	mov	eax,[ebp+010h];	pstFIFOinfo
	cmp	word ptr [eax+02h],01h
	jne	@BLBL133

; 545       *pwFlags &= ~F3_USE_TX_BUFFER;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-02ch],eax;	@CBE35
	mov	eax,[ebp-02ch];	@CBE35
	xor	ecx,ecx
	mov	cx,[eax]
	and	cl,07fh
	mov	[eax],cx
@BLBL133:

; 546 
; 547     pstFIFOinfo->wFIFOflags |= FIFO_FLG_LOW_16750_TRIG;
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	[ebp-028h],eax;	@CBE34
	mov	eax,[ebp-028h];	@CBE34
	mov	cx,[eax+04h]
	or	cx,08000h
	mov	[eax+04h],cx

; 548     *pwFlags &= ~F3_14_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-024h],eax;	@CBE33
	mov	eax,[ebp-024h];	@CBE33
	xor	ecx,ecx
	mov	cx,[eax]
	and	cl,09fh
	mov	[eax],cx

; 549     if (!Checked(hwnd,HWF_1TRIG))
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL130

; 550       {
; 551       if (Checked(hwnd,HWF_4TRIG))
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL135

; 552         *pwFlags |= F3_4_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-020h],eax;	@CBE32
	mov	eax,[ebp-020h];	@CBE32
	mov	cx,[eax]
	or	cl,020h
	mov	[eax],cx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL135:

; 553       else
; 554         if (Checked(hwnd,HWF_8TRIG))
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL137

; 555           *pwFlags |= F3_8_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-01ch],eax;	@CBE31
	mov	eax,[ebp-01ch];	@CBE31
	mov	cx,[eax]
	or	cl,040h
	mov	[eax],cx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL137:

; 556         else
; 557           if (Checked(hwnd,HWF_14TRIG))
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL139

; 558             *pwFlags |= F3_14_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-018h],eax;	@CBE30
	mov	eax,[ebp-018h];	@CBE30
	mov	cx,[eax]
	or	cl,060h
	mov	[eax],cx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL139:

; 559           else
; 560             {
; 561             if (pstFIFOinfo->wFIFOsize > 32)
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	ax,[eax]
	cmp	ax,020h
	jbe	@BLBL141

; 562               pstFIFOinfo->wFIFOflags &= ~FIFO_FLG_LOW_16750_TRIG;
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	[ebp-014h],eax;	@CBE29
	mov	eax,[ebp-014h];	@CBE29
	xor	ecx,ecx
	mov	cx,[eax+04h]
	and	ch,07fh
	mov	[eax+04h],cx
@BLBL141:

; 563             if (Checked(hwnd,HWF_56TRIG))
	push	02d6h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL142

; 564               *pwFlags |= F3_14_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-010h],eax;	@CBE28
	mov	eax,[ebp-010h];	@CBE28
	mov	cx,[eax]
	or	cl,060h
	mov	[eax],cx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL142:

; 565             else
; 566               if (Checked(hwnd,HWF_16TRIG))
	push	02ceh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL144

; 567                 *pwFlags |= F3_4_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-0ch],eax;	@CBE27
	mov	eax,[ebp-0ch];	@CBE27
	mov	cx,[eax]
	or	cl,020h
	mov	[eax],cx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL144:

; 568               else
; 569                 *pwFlags |= F3_8_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pwFlags
	mov	[ebp-08h],eax;	@CBE26
	mov	eax,[ebp-08h];	@CBE26
	mov	cx,[eax]
	or	cl,040h
	mov	[eax],cx

; 570             }

; 571       }

; 572     }
@BLBL130:

; 573   }
	mov	esp,ebp
	pop	ebp
	ret	
UnloadCfgFIFOsetupDlg	endp

; 576   {
	align 010h

	public TCCfgFIFOsetupDlg
TCCfgFIFOsetupDlg	proc
	push	ebp
	mov	ebp,esp

; 577   switch(idButton)
	xor	eax,eax
	mov	ax,[ebp+0ch];	idButton
	jmp	@BLBL155
	align 04h
@BLBL156:

; 578     {
; 579     case HWF_DISABFIFO:
; 580       if (!Checked(hwnd,HWF_DISABFIFO))
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL146

; 581         {
; 582         CheckButton(hwnd,HWF_1TRIG,TRUE);
	push	01h
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 583         CheckButton(hwnd,HWF_TX_MIN,TRUE);
	push	01h
	push	02c3h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 584         CheckButton(hwnd,HWF_DISABFIFO,TRUE);
	push	01h
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 585         CheckButton(hwnd,HWF_APO,FALSE);
	push	0h
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 586         CheckButton(hwnd,HWF_ENABFIFO,FALSE);
	push	0h
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 587         ControlEnable(hwnd,HWF_1TRIG,FALSE);
	push	0h
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 588         ControlEnable(hwnd,HWF_4TRIG,FALSE);
	push	0h
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 589         ControlEnable(hwnd,HWF_8TRIG,FALSE);
	push	0h
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 590         ControlEnable(hwnd,HWF_14TRIG,FALSE);
	push	0h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 591         if (pstFIFOinfo->wFIFOsize > 32)
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	ax,[eax]
	cmp	ax,020h
	jbe	@BLBL147

; 592           {
; 593           ControlEnable(hwnd,HWF_16TRIG,FALSE);
	push	0h
	push	02ceh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 594   
; 594         ControlEnable(hwnd,HWF_32TRIG,FALSE);
	push	0h
	push	02d5h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 595           ControlEnable(hwnd,HWF_56TRIG,FALSE);
	push	0h
	push	02d6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 596           }
@BLBL147:

; 597         ControlEnable(hwnd,HWF_TXLOADT,FALSE);
	push	0h
	push	02c9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 598         ControlEnable(hwnd,HWF_TXLOADTT,FALSE);
	push	0h
	push	02d9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 599         ControlEnable(hwnd,HWF_TXFIFO_LOAD,FALSE);
	push	0h
	push	02d8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 600         }
@BLBL146:

; 601       break;
	jmp	@BLBL154
	align 04h
@BLBL157:

; 602     case HWF_APO:
; 603       if (!Checked(hwnd,HWF_APO))
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL148

; 604         {
; 605         if (Checked(hwnd,HWF_DISABFIFO))
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL149

; 606           {
; 607           CheckButton(hwnd,HWF_14TRIG,TRUE);
	push	01h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 608           CheckButton(hwnd,HWF_TX_MAX,TRUE);
	push	01h
	push	02c4h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 609           WinSendDlgItemMsg(hwnd,HWF_TXFIFO_LOAD,
	push	0h
	mov	ecx,[ebp+010h];	pstFIFOinfo
	xor	eax,eax
	mov	ax,[ecx+02h]
	push	eax
	push	0208h
	push	02d8h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 610                                     SPBM_SETCURRENTVALUE,
; 611                             (MPARAM)pstFIFOinfo->wTxFIFOload,
; 612                                     NULL);
; 613           }
@BLBL149:

; 614         CheckButton(hwnd,HWF_APO,TRUE);
	push	01h
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 615         CheckButton(hwnd,HWF_ENABFIFO,FALSE);
	push	0h
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 616         CheckButton(hwnd,HWF_DISABFIFO,FALSE);
	push	0h
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 617         ControlEnable(hwnd,HWF_1TRIG,TRUE);
	push	01h
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 618         ControlEnable(hwnd,HWF_4TRIG,TRUE);
	push	01h
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 619         ControlEnable(hwnd,HWF_8TRIG,TRUE);
	push	01h
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 620         ControlEnable(hwnd,HWF_14TRIG,TRUE);
	push	01h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 621         if (pstFIFOinfo->wFIFOsize > 32)
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	ax,[eax]
	cmp	ax,020h
	jbe	@BLBL150

; 622           {
; 623           ControlEnable(hwnd,HWF_16TRIG,TRUE);
	push	01h
	push	02ceh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 624           ControlEnable(hwnd,HWF_32TRIG,TRUE);
	push	01h
	push	02d5h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 625           ControlEnable(hwnd,HWF_56TRIG,TRUE);
	push	01h
	push	02d6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 626           }
@BLBL150:

; 627         ControlEnable(hwnd,HWF_TXLOADT,TRUE);
	push	01h
	push	02c9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 628         ControlEnable(hwnd,HWF_TXLOADTT,TRUE);
	push	01h
	push	02d9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 629         ControlEnable(hwnd,HWF_TXFIFO_LOAD,TRUE);
	push	01h
	push	02d8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 630         }
@BLBL148:

; 631       break;
	jmp	@BLBL154
	align 04h
@BLBL158:

; 632     case HWF_ENABFIFO:
; 633       if (!Checked(hwnd,HWF_ENABFIFO))
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL151

; 634         {
; 635         if (Checked(hwnd,HWF_DISABFIFO))
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL152

; 636           {
; 637           CheckButton(hwnd,HWF_14TRIG,TRUE);
	push	01h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 638           CheckButton(hwnd,HWF_TX_MAX,TRUE);
	push	01h
	push	02c4h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 639           WinSendDlgItemMsg(hwnd,HWF_TXFIFO_LOAD,
	push	0h
	mov	ecx,[ebp+010h];	pstFIFOinfo
	xor	eax,eax
	mov	ax,[ecx+02h]
	push	eax
	push	0208h
	push	02d8h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 640                                     SPBM_SETCURRENTVALUE,
; 641                             (MPARAM)pstFIFOinfo->wTxFIFOload,
; 642                                     NULL);
; 643           }
@BLBL152:

; 644         CheckButton(hwnd,HWF_ENABFIFO,TRUE);
	push	01h
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 645         CheckButton(hwnd,HWF_APO,FALSE);
	push	0h
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 646         CheckButton(hwnd,HWF_DISABFIFO,FALSE);
	push	0h
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 647         ControlEnable(hwnd,HWF_1TRIG,TRUE);
	push	01h
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 648         ControlEnable(hwnd,HWF_4TRIG,TRUE);
	push	01h
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 649         ControlEnable(hwnd,HWF_8TRIG,TRUE);
	push	01h
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 650         ControlEnable(hwnd,HWF_14TRIG,TRUE);
	push	01h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 651         if (pstFIFOinfo->wFIFOsize > 32)
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	ax,[eax]
	cmp	ax,020h
	jbe	@BLBL153

; 652           {
; 653           ControlEnable(hwnd,HWF_16TRIG,TRUE);
	push	01h
	push	02ceh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 654           ControlEnable(hwnd,HWF_32TRIG,TRUE);
	push	01h
	push	02d5h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 655           ControlEnable(hwnd,HWF_56TRIG,TRUE);
	push	01h
	push	02d6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 656           }
@BLBL153:

; 657         ControlEnable(hwnd,HWF_TXLOADT,TRUE);
	push	01h
	push	02c9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 658         ControlEnable(hwnd,HWF_TXLOADTT,TRUE);
	push	01h
	push	02d9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 659         ControlEnable(hwnd,HWF_TXFIFO_LOAD,TRUE);
	push	01h
	push	02d8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 660         }
@BLBL151:

; 661       break;
	jmp	@BLBL154
	align 04h
@BLBL159:

; 662     default:
; 663       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL154
	align 04h
@BLBL155:
	cmp	eax,01a7h
	je	@BLBL156
	cmp	eax,01a5h
	je	@BLBL157
	cmp	eax,01a6h
	je	@BLBL158
	jmp	@BLBL159
	align 04h
@BLBL154:

; 664     }
; 665   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
TCCfgFIFOsetupDlg	endp

; 669   {
	align 010h

	public FillHDWhandshakDlg
FillHDWhandshakDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 672   if (pstComDCB->wConfigFlags2 & FIFO_FLG_HDW_CTS_HS)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+03h],04h
	je	@BLBL160

; 673     CheckButton(hwnd,HWF_HDW_CTS_HS,TRUE);
	push	01h
	push	02bch
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL161
	align 010h
@BLBL160:

; 674   else
; 675     CheckButton(hwnd,HWF_HDW_CTS_HS,FALSE);
	push	0h
	push	02bch
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL161:

; 676 
; 677   if (pstComDCB->wConfigFlags2 & FIFO_FLG_HDW_RTS_HS)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+03h],08h
	je	@BLBL162

; 678     CheckButton(hwnd,HWF_HDW_RTS_HS,TRUE);
	push	01h
	push	02bdh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL163
	align 010h
@BLBL162:

; 679   else
; 680     CheckButton(hwnd,HWF_HDW_RTS_HS,FALSE);
	push	0h
	push	02bdh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL163:

; 681 
; 682   switch ((pstComDCB->wFlags2 & F2_RTS_MASK) >> 6)
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	ax,[ecx+010h]
	and	eax,0c0h
	sar	eax,06h
	jmp	@BLBL173
	align 04h
@BLBL174:

; 683     {
; 684     case 0:
; 685       idEntryField = HS_RTSDISAB;
	mov	word ptr [ebp-02h],01c1h;	idEntryField

; 686       break;
	jmp	@BLBL172
	align 04h
@BLBL175:

; 687     case 1:
; 688       idEntryField = HS_RTSENAB;
	mov	word ptr [ebp-02h],01c2h;	idEntryField

; 689       break;
	jmp	@BLBL172
	align 04h
@BLBL176:

; 690     case 2:
; 691       idEntryField = HS_RTSINHS;
	mov	word ptr [ebp-02h],01c0h;	idEntryField

; 692       break;
	jmp	@BLBL172
	align 04h
@BLBL177:

; 693     case 3:
; 694       idEntryField = HS_RTSTOG;
	mov	word ptr [ebp-02h],01bfh;	idEntryField

; 695       break;
	jmp	@BLBL172
	align 04h
	jmp	@BLBL172
	align 04h
@BLBL173:
	test	eax,eax
	je	@BLBL174
	cmp	eax,01h
	je	@BLBL175
	cmp	eax,02h
	je	@BLBL176
	cmp	eax,03h
	je	@BLBL177
@BLBL172:

; 696     }
; 697   CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-02h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 698 
; 699   switch (pstComDCB->wFlags1 & F1_DTR_MASK)
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	ax,[ecx+0eh]
	and	eax,03h
	jmp	@BLBL179
	align 04h
@BLBL180:

; 700     {
; 701     case 0:
; 702       idEntryField = HS_DTRDISAB;
	mov	word ptr [ebp-02h],01bch;	idEntryField

; 703       break;
	jmp	@BLBL178
	align 04h
@BLBL181:

; 704     case 1:
; 705       idEntryField = HS_DTRENAB;
	mov	word ptr [ebp-02h],01bdh;	idEntryField

; 706       break;
	jmp	@BLBL178
	align 04h
@BLBL182:

; 707     case 2:
; 708       idEntryField = HS_DTRINHS;
	mov	word ptr [ebp-02h],01bbh;	idEntryField

; 709       break;
	jmp	@BLBL178
	align 04h
	jmp	@BLBL178
	align 04h
@BLBL179:
	test	eax,eax
	je	@BLBL180
	cmp	eax,01h
	je	@BLBL181
	cmp	eax,02h
	je	@BLBL182
@BLBL178:

; 710     }
; 711   CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-02h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 712 
; 713   if (pstComDCB->wFlags1 & F1_ENABLE_CTS_OUTPUT_HS)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+0eh],08h
	je	@BLBL164

; 714     CheckButton(hwnd,HS_CTSOUT,TRUE);
	push	01h
	push	01c5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL165
	align 010h
@BLBL164:

; 715   else
; 716     CheckButton(hwnd,HS_CTSOUT,FALSE);
	push	0h
	push	01c5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL165:

; 717   if (pstComDCB->wFlags1 & F1_ENABLE_DSR_OUTPUT_HS)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+0eh],010h
	je	@BLBL166

; 718     CheckButton(hwnd,HS_DSROUT,TRUE);
	push	01h
	push	01c4h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL167
	align 010h
@BLBL166:

; 719   else
; 720     CheckButton(hwnd,HS_DSROUT,FALSE);
	push	0h
	push	01c4h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL167:

; 721   if (pstComDCB->wFlags1 & F1_ENABLE_DCD_OUTPUT_HS)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+0eh],020h
	je	@BLBL168

; 722     CheckButton(hwnd,HS_DCDOUT,TRUE);
	push	01h
	push	01c3h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL169
	align 010h
@BLBL168:

; 723   else
; 724     CheckButton(hwnd,HS_DCDOUT,FALSE);
	push	0h
	push	01c3h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL169:

; 725   if (pstComDCB->wFlags1 & F1_ENABLE_DSR_INPUT_HS)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+0eh],040h
	je	@BLBL170

; 726     CheckButton(hwnd,HS_DSRINSENSE,TRUE);
	push	01h
	push	01beh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL170:

; 727   else
; 728     CheckButton(hwnd,HS_DSRINSENSE,FALSE);
	push	0h
	push	01beh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 729   }
	mov	esp,ebp
	pop	ebp
	ret	
FillHDWhandshakDlg	endp

; 732   {
	align 010h

	public UnloadHDWhandshakDlg
UnloadHDWhandshakDlg	proc
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

; 733   pstComDCB->wConfigFlags2 &= ~FIFO_FLG_HDW_HS_MASK;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-050h],eax;	@CBE60
	mov	eax,[ebp-050h];	@CBE60
	xor	ecx,ecx
	mov	cx,[eax+02h]
	and	ch,0f3h
	mov	[eax+02h],cx

; 734   if (Checked(hwnd,HWF_HDW_CTS_HS))
	push	02bch
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL183

; 735     pstComDCB->wConfigFlags2 |= FIFO_FLG_HDW_CTS_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-04ch],eax;	@CBE59
	mov	eax,[ebp-04ch];	@CBE59
	mov	cx,[eax+02h]
	or	cx,0400h
	mov	[eax+02h],cx
@BLBL183:

; 736   if (Checked(hwnd,HWF_HDW_RTS_HS))
	push	02bdh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL184

; 737     pstComDCB->wConfigFlags2 |= FIFO_FLG_HDW_RTS_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-048h],eax;	@CBE58
	mov	eax,[ebp-048h];	@CBE58
	mov	cx,[eax+02h]
	or	cx,0800h
	mov	[eax+02h],cx
@BLBL184:

; 738   pstComDCB->wFlags2 &= ~F2_RTS_MASK;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-044h],eax;	@CBE57
	mov	eax,[ebp-044h];	@CBE57
	xor	ecx,ecx
	mov	cx,[eax+010h]
	and	cl,03fh
	mov	[eax+010h],cx

; 739 
; 740   pstComDCB->wFlags2 |= 0x8000;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-040h],eax;	@CBE56
	mov	eax,[ebp-040h];	@CBE56
	mov	cx,[eax+010h]
	or	cx,08000h
	mov	[eax+010h],cx

; 741   if (Checked(hwnd,HS_RTSENAB))
	push	01c2h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL185

; 742     pstComDCB->wFlags2 |= F2_ENABLE_RTS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-03ch],eax;	@CBE55
	mov	eax,[ebp-03ch];	@CBE55
	mov	cx,[eax+010h]
	or	cl,040h
	mov	[eax+010h],cx
	jmp	@BLBL186
	align 010h
@BLBL185:

; 743   else
; 744     if (Checked(hwnd,HS_RTSINHS))
	push	01c0h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL187

; 745       pstComDCB->wFlags2 |= F2_ENABLE_RTS_INPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-038h],eax;	@CBE54
	mov	eax,[ebp-038h];	@CBE54
	mov	cx,[eax+010h]
	or	cl,080h
	mov	[eax+010h],cx
	jmp	@BLBL186
	align 010h
@BLBL187:

; 746     else
; 747       if (Checked(hwnd,HS_RTSTOG))
	push	01bfh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL186

; 748         pstComDCB->wFlags2 |= F2_ENABLE_RTS_TOG_ON_XMIT;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-034h],eax;	@CBE53
	mov	eax,[ebp-034h];	@CBE53
	mov	cx,[eax+010h]
	or	cl,0c0h
	mov	[eax+010h],cx
@BLBL186:

; 749 
; 750   pstComDCB->wFlags1 &= ~F1_DTR_MASK;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-030h],eax;	@CBE52
	mov	eax,[ebp-030h];	@CBE52
	xor	ecx,ecx
	mov	cx,[eax+0eh]
	and	cl,0fch
	mov	[eax+0eh],cx

; 751   pstComDCB->wFlags1 |= 0x8000;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-02ch],eax;	@CBE51
	mov	eax,[ebp-02ch];	@CBE51
	mov	cx,[eax+0eh]
	or	cx,08000h
	mov	[eax+0eh],cx

; 752   if (Checked(hwnd,HS_DTRENAB))
	push	01bdh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL190

; 753     pstComDCB->wFlags1 |= F1_ENABLE_DTR;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-028h],eax;	@CBE50
	mov	eax,[ebp-028h];	@CBE50
	mov	cx,[eax+0eh]
	or	cl,01h
	mov	[eax+0eh],cx
	jmp	@BLBL191
	align 010h
@BLBL190:

; 754   else
; 755     if (Checked(hwnd,HS_DTRINHS))
	push	01bbh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL191

; 756       pstComDCB->wFlags1 |= F1_ENABLE_DTR_INPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-024h],eax;	@CBE49
	mov	eax,[ebp-024h];	@CBE49
	mov	cx,[eax+0eh]
	or	cl,02h
	mov	[eax+0eh],cx
@BLBL191:

; 757 
; 758   if (Checked(hwnd,HS_CTSOUT))
	push	01c5h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL193

; 759     pstComDCB->wFlags1 |= F1_ENABLE_CTS_OUTPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-020h],eax;	@CBE48
	mov	eax,[ebp-020h];	@CBE48
	mov	cx,[eax+0eh]
	or	cl,08h
	mov	[eax+0eh],cx
	jmp	@BLBL194
	align 010h
@BLBL193:

; 760   else
; 761     pstComDCB->wFlags1 &= ~F1_ENABLE_CTS_OUTPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-01ch],eax;	@CBE47
	mov	eax,[ebp-01ch];	@CBE47
	xor	ecx,ecx
	mov	cx,[eax+0eh]
	and	cl,0f7h
	mov	[eax+0eh],cx
@BLBL194:

; 762 
; 763   if (Checked(hwnd,HS_DSROUT))
	push	01c4h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL195

; 764     pstComDCB->wFlags1 |= F1_ENABLE_DSR_OUTPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-018h],eax;	@CBE46
	mov	eax,[ebp-018h];	@CBE46
	mov	cx,[eax+0eh]
	or	cl,010h
	mov	[eax+0eh],cx
	jmp	@BLBL196
	align 010h
@BLBL195:

; 765   else
; 766     pstComDCB->wFlags1 &= ~F1_ENABLE_DSR_OUTPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-014h],eax;	@CBE45
	mov	eax,[ebp-014h];	@CBE45
	xor	ecx,ecx
	mov	cx,[eax+0eh]
	and	cl,0efh
	mov	[eax+0eh],cx
@BLBL196:

; 767 
; 768   if (Checked(hwnd,HS_DCDOUT))
	push	01c3h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL197

; 769     pstComDCB->wFlags1 |= F1_ENABLE_DCD_OUTPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-010h],eax;	@CBE44
	mov	eax,[ebp-010h];	@CBE44
	mov	cx,[eax+0eh]
	or	cl,020h
	mov	[eax+0eh],cx
	jmp	@BLBL198
	align 010h
@BLBL197:

; 770   else
; 771     pstComDCB->wFlags1 &= ~F1_ENABLE_DCD_OUTPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-0ch],eax;	@CBE43
	mov	eax,[ebp-0ch];	@CBE43
	xor	ecx,ecx
	mov	cx,[eax+0eh]
	and	cl,0dfh
	mov	[eax+0eh],cx
@BLBL198:

; 772 
; 773   if (Checked(hwnd,HS_DSRINSENSE))
	push	01beh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL199

; 774     pstComDCB->wFlags1 |= F1_ENABLE_DSR_INPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-08h],eax;	@CBE42
	mov	eax,[ebp-08h];	@CBE42
	mov	cx,[eax+0eh]
	or	cl,040h
	mov	[eax+0eh],cx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL199:

; 775   else
; 776     pstComDCB->wFlags1 &= ~F1_ENABLE_DSR_INPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-04h],eax;	@CBE41
	mov	eax,[ebp-04h];	@CBE41
	xor	ecx,ecx
	mov	cx,[eax+0eh]
	and	cl,0bfh
	mov	[eax+0eh],cx

; 777   }
	mov	esp,ebp
	pop	ebp
	ret	
UnloadHDWhandshakDlg	endp

; 780   {
	align 010h

	public FillASCIIhandshakingDlg
FillASCIIhandshakingDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax

; 782   BOOL bXHS = FALSE;
	mov	dword ptr [ebp-0ch],0h;	bXHS

; 783 
; 784 #ifdef allow_16650_HDW_Xon_HS
; 785   WinSetDlgItemText(hwnd,HS_RXFLOW,"Receive Xon/Xoff................");
; 786   WinShowWindow(WinWindowFromID(hwnd,HWF_HDW_RX_XON_HS),TRUE);
; 787   WinSetDlgItemText(hwnd,HS_TXFLOW,"Transmit Xon/Xoff................");
; 788   WinShowWindow(WinWindowFromID(hwnd,HWF_HDW_TX_XON_HS),TRUE);
; 789   if (pstComDCB->wDeviceFlag2 & FIFO_FLG_HDW_RX_XON_HS)
; 790     CheckButton(hwnd,HWF_HDW_RX_XON_HS,TRUE);
; 791   if (pstComDCB->wDeviceFlag2 & FIFO_FLG_HDW_TX_XON_HS)
; 792     CheckButton(hwnd,HWF_HDW_TX_XON_HS,TRUE);
; 793 #endif
; 794   sprintf(szXchar,"%02X",pstComDCB->byXoffChar);
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	al,[ecx+025h]
	push	eax
	mov	edx,offset FLAT:@STAT5
	lea	eax,[ebp-05h];	szXchar
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 795   WinSendDlgItemMsg(hwnd,HS_XOFFCHAR,EM_SETTEXTLIMIT,MPFROMSHORT(2),(MPARAM)NULL);
	push	0h
	push	02h
	push	0143h
	push	01c9h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 796   WinSetDlgItemText(hwnd,HS_XOFFCHAR,szXchar);
	lea	eax,[ebp-05h];	szXchar
	push	eax
	push	01c9h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 797 
; 798   sprintf(szXchar,"%02X",pstComDCB->byXonChar);
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	al,[ecx+024h]
	push	eax
	mov	edx,offset FLAT:@STAT6
	lea	eax,[ebp-05h];	szXchar
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 799   WinSendDlgItemMsg(hwnd,HS_XONCHAR,EM_SETTEXTLIMIT,MPFROMSHORT(2),(MPARAM)NULL);
	push	0h
	push	02h
	push	0143h
	push	01cah
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 800   WinSetDlgItemText(hwnd,HS_XONCHAR,szXchar);
	lea	eax,[ebp-05h];	szXchar
	push	eax
	push	01cah
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 801 
; 802   if (pstComDCB->wFlags2 & F2_ENABLE_XMIT_XON_XOFF_FLOW)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+010h],01h
	je	@BLBL201

; 803     {
; 804     CheckButton(hwnd,HS_TXFLOW,TRUE);
	push	01h
	push	01c8h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 805     bXHS = TRUE;
	mov	dword ptr [ebp-0ch],01h;	bXHS

; 806     }
	jmp	@BLBL202
	align 010h
@BLBL201:

; 807  else
; 808    CheckButton(hwnd,HS_TXFLOW,FALSE);
	push	0h
	push	01c8h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL202:

; 809 
; 810   if (pstComDCB->wFlags2 & F2_ENABLE_FULL_DUPLEX)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+010h],020h
	je	@BLBL203

; 811     CheckButton(hwnd,HS_FULLDUP,TRUE);
	push	01h
	push	01c6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL204
	align 010h
@BLBL203:

; 812   else
; 813     CheckButton(hwnd,HS_FULLDUP,FALSE);
	push	0h
	push	01c6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL204:

; 814 
; 815   if (pstComDCB->wFlags2 & F2_ENABLE_RCV_XON_XOFF_FLOW)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+010h],02h
	je	@BLBL205

; 816     {
; 817     CheckButton(hwnd,HS_RXFLOW,TRUE);
	push	01h
	push	01c7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 818     bXHS = TRUE;
	mov	dword ptr [ebp-0ch],01h;	bXHS

; 819     ControlEnable(hwnd,HS_FULLDUP,TRUE);
	push	01h
	push	01c6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 820 #ifdef allow_16650_HDW_Xon_HS
; 821     if (pstComDCB->wDeviceFlag2 & FIFO_FLG_HDW_RX_XON_HS)
; 822       ControlEnable(hwnd,HS_FULLDUP,FALSE);
; 823 #endif
; 824     }
	jmp	@BLBL206
	align 010h
@BLBL205:

; 825   else
; 826     {
; 827     CheckButton(hwnd,HS_RXFLOW,FALSE);
	push	0h
	push	01c7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 828     ControlEnable(hwnd,HS_FULLDUP,FALSE);
	push	0h
	push	01c6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 829     }
@BLBL206:

; 830 
; 831   if (bXHS)
	cmp	dword ptr [ebp-0ch],0h;	bXHS
	je	@BLBL207

; 832     {
; 833     ControlEnable(hwnd,HS_XOFFCHART,TRUE);
	push	01h
	push	01cbh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 834     ControlEnable(hwnd,HS_XONCHART,TRUE);
	push	01h
	push	01cch
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 835     ControlEnable(hwnd,HS_XOFFCHAR,TRUE);
	push	01h
	push	01c9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 836     ControlEnable(hwnd,HS_XONCHAR,TRUE);
	push	01h
	push	01cah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 837     ControlEnable(hwnd,HS_XONCHARTT,TRUE);
	push	01h
	push	01455h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 838     ControlEnable(hwnd,HS_XONCHARTTT,TRUE);
	push	01h
	push	01456h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 839     ControlEnable(hwnd,HS_XOFFCHARTT,TRUE);
	push	01h
	push	01457h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 840     ControlEnable(hwnd,HS_XOFFCHARTTT,TRUE);
	push	01h
	push	01458h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 841     }
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL207:

; 842   else
; 843     {
; 844     ControlEnable(hwnd,HS_XOFFCHART,FALSE);
	push	0h
	push	01cbh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 845     ControlEnable(hwnd,HS_XONCHART,FALSE);
	push	0h
	push	01cch
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 846     ControlEnable(hwnd,HS_XOFFCHAR,FALSE);
	push	0h
	push	01c9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 847     ControlEnable(hwnd,HS_XONCHAR,FALSE);
	push	0h
	push	01cah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 848     ControlEnable(hwnd,HS_XONCHARTT,FALSE);
	push	0h
	push	01455h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 849     ControlEnable(hwnd,HS_XONCHARTTT,FALSE);
	push	0h
	push	01456h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 850     ControlEnable(hwnd,HS_XOFFCHARTT,FALSE);
	push	0h
	push	01457h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 851     ControlEnab
; 851 le(hwnd,HS_XOFFCHARTTT,FALSE);
	push	0h
	push	01458h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 852     }

; 853   }
	mov	esp,ebp
	pop	ebp
	ret	
FillASCIIhandshakingDlg	endp

; 856   {
	align 010h

	public TCASCIIhandshakeDlg
TCASCIIhandshakeDlg	proc
	push	ebp
	mov	ebp,esp

; 857   switch(usButtonId)
	xor	eax,eax
	mov	ax,[ebp+0ch];	usButtonId
	jmp	@BLBL215
	align 04h
@BLBL216:
@BLBL217:

; 858     {
; 859 #ifdef allow_16650_HDW_Xon_HS
; 860     case HWF_HDW_RX_XON_HS:
; 861       if (Checked(hwnd,HWF_HDW_RX_XON_HS))
; 862         {
; 863 //        CheckButton(hwnd,HWF_HDW_RX_XON_HS,TRUE);
; 864         ControlEnable(hwnd,HS_FULLDUP,FALSE);
; 865         }
; 866       else
; 867         {
; 868 //        CheckButton(hwnd,HWF_HDW_RX_XON_HS,FALSE);
; 869         if (Checked(hwnd,HS_RXFLOW))
; 870           ControlEnable(hwnd,HS_FULLDUP,TRUE);
; 871         }
; 872       break;
; 873 #endif
; 874     case HS_RXFLOW:
; 875     case HS_TXFLOW:
; 876       if (Checked(hwnd,HS_RXFLOW) || Checked(hwnd,HS_TXFLOW))
	push	01c7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL209
	push	01c8h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL210
@BLBL209:

; 877         {
; 878         ControlEnable(hwnd,HS_XOFFCHART,TRUE);
	push	01h
	push	01cbh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 879         ControlEnable(hwnd,HS_XONCHART,TRUE);
	push	01h
	push	01cch
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 880         ControlEnable(hwnd,HS_XOFFCHAR,TRUE);
	push	01h
	push	01c9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 881         ControlEnable(hwnd,HS_XONCHAR,TRUE);
	push	01h
	push	01cah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 882         ControlEnable(hwnd,HS_XONCHARTT,TRUE);
	push	01h
	push	01455h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 883         ControlEnable(hwnd,HS_XONCHARTTT,TRUE);
	push	01h
	push	01456h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 884         ControlEnable(hwnd,HS_XOFFCHARTT,TRUE);
	push	01h
	push	01457h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 885         ControlEnable(hwnd,HS_XOFFCHARTTT,TRUE);
	push	01h
	push	01458h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 886         }
	jmp	@BLBL211
	align 010h
@BLBL210:

; 887       else
; 888         {
; 889         ControlEnable(hwnd,HS_XOFFCHART,FALSE);
	push	0h
	push	01cbh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 890         ControlEnable(hwnd,HS_XONCHART,FALSE);
	push	0h
	push	01cch
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 891         ControlEnable(hwnd,HS_XOFFCHAR,FALSE);
	push	0h
	push	01c9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 892         ControlEnable(hwnd,HS_XONCHAR,FALSE);
	push	0h
	push	01cah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 893         ControlEnable(hwnd,HS_XONCHARTT,FALSE);
	push	0h
	push	01455h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 894         ControlEnable(hwnd,HS_XONCHARTTT,FALSE);
	push	0h
	push	01456h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 895         ControlEnable(hwnd,HS_XOFFCHARTT,FALSE);
	push	0h
	push	01457h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 896         ControlEnable(hwnd,HS_XOFFCHARTTT,FALSE);
	push	0h
	push	01458h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 897         }
@BLBL211:

; 898       if (!Checked(hwnd,HS_RXFLOW))
	push	01c7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL212

; 899         ControlEnable(hwnd,HS_FULLDUP,FALSE);
	push	0h
	push	01c6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch
	jmp	@BLBL213
	align 010h
@BLBL212:

; 900       else
; 901         {
; 902 #ifdef allow_16650_HDW_Xon_HS
; 903         if (!Checked(hwnd,HWF_HDW_RX_XON_HS))
; 904 #endif
; 905           ControlEnable(hwnd,HS_FULLDUP,TRUE);
	push	01h
	push	01c6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 906         }
@BLBL213:

; 907       break;
	jmp	@BLBL214
	align 04h
	jmp	@BLBL214
	align 04h
@BLBL215:
	cmp	eax,01c7h
	je	@BLBL216
	cmp	eax,01c8h
	je	@BLBL217
@BLBL214:

; 908     }
; 909   }
	mov	esp,ebp
	pop	ebp
	ret	
TCASCIIhandshakeDlg	endp

; 912   {
	align 010h

	public UnloadASCIIhandshakeDlg
UnloadASCIIhandshakeDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,02ch
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,0bh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 914   BOOL bXHS = FALSE;
	mov	dword ptr [ebp-0ch],0h;	bXHS

; 915 
; 916   pstComDCB->wConfigFlags2 &= ~FIFO_FLG_HDW_HS_MASK;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-02ch],eax;	@CBE68
	mov	eax,[ebp-02ch];	@CBE68
	xor	ecx,ecx
	mov	cx,[eax+02h]
	and	ch,0f3h
	mov	[eax+02h],cx

; 917 #ifdef allow_16650_HDW_Xon_HS
; 918   if (Checked(hwnd,HWF_HDW_RX_XON_HS))
; 919     pstComDCB->wConfigFlags2 |= FIFO_FLG_HDW_RX_XON_HS;
; 920   if (Checked(hwnd,HWF_HDW_TX_XON_HS))
; 921     pstComDCB->wConfigFlags2 |= FIFO_FLG_HDW_TX_XON_HS;
; 922 #endif
; 923   pstComDCB->wFlags2 |= 0x8000;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-028h],eax;	@CBE67
	mov	eax,[ebp-028h];	@CBE67
	mov	cx,[eax+010h]
	or	cx,08000h
	mov	[eax+010h],cx

; 924   if (Checked(hwnd,HS_TXFLOW))
	push	01c8h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL218

; 925     {
; 926     bXHS = TRUE;
	mov	dword ptr [ebp-0ch],01h;	bXHS

; 927     pstComDCB->wFlags2 |= F2_ENABLE_XMIT_XON_XOFF_FLOW;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-024h],eax;	@CBE66
	mov	eax,[ebp-024h];	@CBE66
	mov	cx,[eax+010h]
	or	cl,01h
	mov	[eax+010h],cx

; 928     }
	jmp	@BLBL219
	align 010h
@BLBL218:

; 929   else
; 930     pstComDCB->wFlags2 &= ~F2_ENABLE_XMIT_XON_XOFF_FLOW;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-020h],eax;	@CBE65
	mov	eax,[ebp-020h];	@CBE65
	xor	ecx,ecx
	mov	cx,[eax+010h]
	and	cl,0feh
	mov	[eax+010h],cx
@BLBL219:

; 931 
; 932   pstComDCB->wFlags2 &= ~F2_ENABLE_FULL_DUPLEX;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-01ch],eax;	@CBE64
	mov	eax,[ebp-01ch];	@CBE64
	xor	ecx,ecx
	mov	cx,[eax+010h]
	and	cl,0dfh
	mov	[eax+010h],cx

; 933   if (Checked(hwnd,HS_RXFLOW))
	push	01c7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL220

; 934     {
; 935     bXHS = TRUE;
	mov	dword ptr [ebp-0ch],01h;	bXHS

; 936     pstComDCB->wFlags2 |= F2_ENABLE_RCV_XON_XOFF_FLOW;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-018h],eax;	@CBE63
	mov	eax,[ebp-018h];	@CBE63
	mov	cx,[eax+010h]
	or	cl,02h
	mov	[eax+010h],cx

; 937     if (Checked(hwnd,HS_FULLDUP))
	push	01c6h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL222

; 938 #ifdef allow_16650_HDW_Xon_HS
; 939       if ((pstFIFOinfo->wFIFOflags & FIFO_FLG_HDW_RX_XON_HS) == 0);
; 940 #endif
; 941         pstComDCB->wFlags2 |= F2_ENABLE_FULL_DUPLEX;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-014h],eax;	@CBE62
	mov	eax,[ebp-014h];	@CBE62
	mov	cx,[eax+010h]
	or	cl,020h
	mov	[eax+010h],cx

; 942     }
	jmp	@BLBL222
	align 010h
@BLBL220:

; 943   else
; 944     pstComDCB->wFlags2 &= ~F2_ENABLE_RCV_XON_XOFF_FLOW;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-010h],eax;	@CBE61
	mov	eax,[ebp-010h];	@CBE61
	xor	ecx,ecx
	mov	cx,[eax+010h]
	and	cl,0fdh
	mov	[eax+010h],cx
@BLBL222:

; 945 
; 946   if (bXHS)
	cmp	dword ptr [ebp-0ch],0h;	bXHS
	je	@BLBL223

; 947     {
; 948     WinQueryDlgItemText(hwnd,HS_XOFFCHAR,3,szXchar);
	lea	eax,[ebp-05h];	szXchar
	push	eax
	push	03h
	push	01c9h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 949     pstComDCB->byXoffChar = (BYTE)ASCIItoBin(szXchar,16);
	push	010h
	lea	eax,[ebp-05h];	szXchar
	push	eax
	call	ASCIItoBin
	mov	ecx,eax
	add	esp,08h
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[eax+025h],cl

; 950 
; 951     WinQueryDlgItemText(hwnd,HS_XONCHAR,3,szXchar);
	lea	eax,[ebp-05h];	szXchar
	push	eax
	push	03h
	push	01cah
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 952     pstComDCB->byXonChar = (BYTE)ASCIItoBin(szXchar,16);
	push	010h
	lea	eax,[ebp-05h];	szXchar
	push	eax
	call	ASCIItoBin
	mov	ecx,eax
	add	esp,08h
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[eax+024h],cl

; 953     }
@BLBL223:

; 954   }
	mov	esp,ebp
	pop	ebp
	ret	
UnloadASCIIhandshakeDlg	endp
CODE32	ends
end
