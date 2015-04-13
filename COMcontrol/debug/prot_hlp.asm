	title	p:\COMcontrol\prot_hlp.c
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
	public	aulStdBaudTable
	public	aul4xBaudTable
	public	aul12xBaudTable
	extrn	_dllentry:proc
	extrn	_sprintfieee:proc
	extrn	WinSetDlgItemText:proc
	extrn	CheckButton:proc
	extrn	ControlEnable:proc
	extrn	WinQueryDlgItemText:proc
	extrn	ASCIItoBin:proc
	extrn	Checked:proc
	extrn	WinSendDlgItemMsg:proc
	extrn	atol:proc
	extrn	WinWindowFromID:proc
	extrn	WinShowWindow:proc
	extrn	_fullDump:dword
DATA32	segment
@STAT1	db "%02X",0h
	align 04h
@STAT2	db "%02X",0h
@STAT3	db "%u",0h
@STAT4	db "%u",0h
	align 04h
@STAT5	db "Using CTS..............."
db ".",0h
	align 04h
@STAT6	db "Input handshaking......."
db ".........",0h
	align 04h
@STAT7	db "%02X",0h
	align 04h
@STAT8	db "%02X",0h
	dd	_dllentry
DATA32	ends
CONST32_RO	segment
aulStdBaudTable	db "2",0h,0h,0h
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
	db 0h,0c2h,01h,0h
	db 0h,0h,0h,0h
aul4xBaudTable	db "2",0h,0h,0h
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
aul12xBaudTable	db "2",0h,0h,0h
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
	db 0h,08ch,0ah,0h
	db 0h,018h,015h,0h
	db 0h,0h,0h,0h
CONST32_RO	ends
CODE32	segment

; 19   {
	align 010h

	public FillHdwFilterDlg
FillHdwFilterDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 22   sprintf(szReplaceChar,"%02X",pstComDCB->ErrChar);
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	al,[ecx+07h]
	push	eax
	mov	edx,offset FLAT:@STAT1
	lea	eax,[ebp-05h];	szReplaceChar
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 23   WinSetDlgItemText(hwnd,HWR_ERRCHAR,szReplaceChar);
	lea	eax,[ebp-05h];	szReplaceChar
	push	eax
	push	04b4h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 24 
; 25   sprintf(szReplaceChar,"%02X",pstComDCB->BrkChar);
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	al,[ecx+08h]
	push	eax
	mov	edx,offset FLAT:@STAT2
	lea	eax,[ebp-05h];	szReplaceChar
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 26   WinSetDlgItemText(hwnd,HWR_BRKCHAR,szReplaceChar);
	lea	eax,[ebp-05h];	szReplaceChar
	push	eax
	push	04b1h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 27 
; 28   if (pstComDCB->Flags2 & F2_ENABLE_ERROR_REPL)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+05h],04h
	je	@BLBL1

; 29     CheckButton(hwnd,HWR_ENABERR,TRUE);
	push	01h
	push	04b7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL2
	align 010h
@BLBL1:

; 30   else
; 31     {
; 32     ControlEnable(hwnd,HWR_ERRTTT,FALSE);
	push	0h
	push	01453h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 33     ControlEnable(hwnd,HWR_ERRTT,FALSE);
	push	0h
	push	01451h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 34     ControlEnable(hwnd,HWR_ERRT,FALSE);
	push	0h
	push	04b3h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 35     ControlEnable(hwnd,HWR_ERRCHAR,FALSE);
	push	0h
	push	04b4h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 36     }
@BLBL2:

; 37   if (pstComDCB->Flags2 & F2_ENABLE_NULL_STRIP)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+05h],08h
	je	@BLBL3

; 38     CheckButton(hwnd,HWR_ENABNUL,TRUE);
	push	01h
	push	04b5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL3:

; 39 
; 40   if (pstComDCB->Flags2 & F2_ENABLE_BREAK_REPL)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+05h],010h
	je	@BLBL4

; 41     CheckButton(hwnd,HWR_ENABBRK,TRUE);
	push	01h
	push	04b6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL4:

; 42   else
; 43     {
; 44     ControlEnable(hwnd,HWR_BRKTTT,FALSE);
	push	0h
	push	01454h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 45     ControlEnable(hwnd,HWR_BRKTT,FALSE);
	push	0h
	push	01452h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 46     ControlEnable(hwnd,HWR_BRKT,FALSE);
	push	0h
	push	04b2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 47     ControlEnable(hwnd,HWR_BRKCHAR,FALSE);
	push	0h
	push	04b1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 48     }

; 49   }
	mov	esp,ebp
	pop	ebp
	ret	
FillHdwFilterDlg	endp

; 52   {
	align 010h

	public UnloadHdwFilterDlg
UnloadHdwFilterDlg	proc
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

; 55   WinQueryDlgItemText(hwnd,HWR_ERRCHAR,3,szReplaceChar);
	lea	eax,[ebp-05h];	szReplaceChar
	push	eax
	push	03h
	push	04b4h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 56   pstComDCB->ErrChar = (BYTE)ASCIItoBin(szReplaceChar,16);
	push	010h
	lea	eax,[ebp-05h];	szReplaceChar
	push	eax
	call	ASCIItoBin
	mov	ecx,eax
	add	esp,08h
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[eax+07h],cl

; 57 
; 58   WinQueryDlgItemText(hwnd,HWR_BRKCHAR,3,szReplaceChar);
	lea	eax,[ebp-05h];	szReplaceChar
	push	eax
	push	03h
	push	04b1h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 59   pstComDCB->BrkChar = (BYTE)ASCIItoBin(szReplaceChar,16);
	push	010h
	lea	eax,[ebp-05h];	szReplaceChar
	push	eax
	call	ASCIItoBin
	mov	ecx,eax
	add	esp,08h
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[eax+08h],cl

; 60 
; 61   if (Checked(hwnd,HWR_ENABERR))
	push	04b7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL6

; 62     pstComDCB->Flags2 |= F2_ENABLE_ERROR_REPL;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-020h],eax;	@CBE14
	mov	eax,[ebp-020h];	@CBE14
	mov	cl,[eax+05h]
	or	cl,04h
	mov	[eax+05h],cl
	jmp	@BLBL7
	align 010h
@BLBL6:

; 63   else
; 64     pstComDCB->Flags2 &= ~F2_ENABLE_ERROR_REPL;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-01ch],eax;	@CBE13
	mov	eax,[ebp-01ch];	@CBE13
	xor	ecx,ecx
	mov	cl,[eax+05h]
	and	cl,0fbh
	mov	[eax+05h],cl
@BLBL7:

; 65 
; 66   if (Checked(hwnd,HWR_ENABBRK))
	push	04b6h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL8

; 67     pstComDCB->Flags2 |= F2_ENABLE_BREAK_REPL;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-018h],eax;	@CBE12
	mov	eax,[ebp-018h];	@CBE12
	mov	cl,[eax+05h]
	or	cl,010h
	mov	[eax+05h],cl
	jmp	@BLBL9
	align 010h
@BLBL8:

; 68   else
; 69     pstComDCB->Flags2 &= ~F2_ENABLE_BREAK_REPL;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-014h],eax;	@CBE11
	mov	eax,[ebp-014h];	@CBE11
	xor	ecx,ecx
	mov	cl,[eax+05h]
	and	cl,0efh
	mov	[eax+05h],cl
@BLBL9:

; 70 
; 71   if (Checked(hwnd,HWR_ENABNUL))
	push	04b5h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL10

; 72     pstComDCB->Flags2 |= F2_ENABLE_NULL_STRIP;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-010h],eax;	@CBE10
	mov	eax,[ebp-010h];	@CBE10
	mov	cl,[eax+05h]
	or	cl,08h
	mov	[eax+05h],cl
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL10:

; 73   else
; 74     pstComDCB->Flags2 &= ~F2_ENABLE_NULL_STRIP;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-0ch],eax;	@CBE9
	mov	eax,[ebp-0ch];	@CBE9
	xor	ecx,ecx
	mov	cl,[eax+05h]
	and	cl,0f7h
	mov	[eax+05h],cl

; 75   }
	mov	esp,ebp
	pop	ebp
	ret	
UnloadHdwFilterDlg	endp

; 78   {
	align 010h

	public FillHdwTimeoutDlg
FillHdwTimeoutDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 81   sprintf(szTimeout,"%u",pstComDCB->ReadTimeout);
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	ax,[ecx+02h]
	push	eax
	mov	edx,offset FLAT:@STAT3
	lea	eax,[ebp-08h];	szTimeout
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 82   WinSetDlgItemText(hwnd,HWT_RTIME,szTimeout);
	lea	eax,[ebp-08h];	szTimeout
	push	eax
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 83   WinSendDlgItemMsg(hwnd,HWT_RTIME,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
	push	0h
	push	05h
	push	0143h
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 84 
; 85   sprintf(szTimeout,"%u",pstComDCB->WrtTimeout);
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT4
	lea	eax,[ebp-08h];	szTimeout
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 86   WinSendDlgItemMsg(hwnd,HWT_WTIME,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
	push	0h
	push	05h
	push	0143h
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 87   WinSetDlgItemText(hwnd,HWT_WTIME,szTimeout);
	lea	eax,[ebp-08h];	szTimeout
	push	eax
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 88 
; 89   if (pstComDCB->Flags3 & F3_INFINITE_WRT_TIMEOUT)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+06h],01h
	je	@BLBL12

; 90     {
; 91     ControlEnable(hwnd,HWT_WTIMET,FALSE);
	push	0h
	push	03eeh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 92     ControlEnable(hwnd,HWT_WTIME,FALSE);
	push	0h
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 93     CheckButton(hwnd,HWT_WINF,TRUE);
	push	01h
	push	03efh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 94     }
	jmp	@BLBL13
	align 010h
@BLBL12:

; 95   else
; 96     CheckButton(hwnd,HWT_WNORM,TRUE);
	push	01h
	push	03f0h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL13:

; 97 
; 98   if ((pstComDCB->Flags3 & F3_RTO_MASK) == F3_WAIT_NONE) // first mask significant bits
	mov	eax,[ebp+0ch];	pstComDCB
	mov	al,[eax+06h]
	and	al,06h
	cmp	al,06h
	jne	@BLBL14

; 99     {
; 100     ControlEnable(hwnd,HWT_RTIMET,FALSE);
	push	0h
	push	03f2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 101     ControlEnable(hwnd,HWT_RTIME,FALSE);
	push	0h
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 102     CheckButton(hwnd,HWT_RNOWAIT,TRUE);
	push	01h
	push	03e9h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 103     }
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL14:

; 104   else
; 105     {
; 106     if ((pstComDCB->Flags3  & F3_RTO_MASK) == F3_WAIT_SOMETHING)
	mov	eax,[ebp+0ch];	pstComDCB
	mov	al,[eax+06h]
	and	al,06h
	cmp	al,04h
	jne	@BLBL16

; 107       CheckButton(hwnd,HWT_RWAITSOME,TRUE);
	push	01h
	push	03eah
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL16:

; 108     else
; 109       CheckButton(hwnd,HWT_RNORM,TRUE);
	push	01h
	push	03ebh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 110     }

; 111   }
	mov	esp,ebp
	pop	ebp
	ret	
FillHdwTimeoutDlg	endp

; 114   {
	align 010h

	public UnloadHdwTimeoutDlg
UnloadHdwTimeoutDlg	proc
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
	sub	esp,04h

; 117   if (Checked(hwnd,HWT_WINF))
	push	03efh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL18

; 118     pstComDCB->Flags3 |= F3_INFINITE_WRT_TIMEOUT;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-024h],eax;	@CBE20
	mov	eax,[ebp-024h];	@CBE20
	mov	cl,[eax+06h]
	or	cl,01h
	mov	[eax+06h],cl
	jmp	@BLBL19
	align 010h
@BLBL18:

; 119   else
; 120     pstComDCB->Flags3 &= ~F3_INFINITE_WRT_TIMEOUT;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-020h],eax;	@CBE19
	mov	eax,[ebp-020h];	@CBE19
	xor	ecx,ecx
	mov	cl,[eax+06h]
	and	cl,0feh
	mov	[eax+06h],cl
@BLBL19:

; 121 
; 122   WinQueryDlgItemText(hwnd,HWT_WTIME,6,szTimeout);
	lea	eax,[ebp-09h];	szTimeout
	push	eax
	push	06h
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 123   pstComDCB->WrtTimeout = (WORD)atol(szTimeout);
	lea	eax,[ebp-09h];	szTimeout
	call	atol
	mov	ecx,eax
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[eax],cx

; 124 
; 125   pstComDCB->Flags3 &= ~F3_RTO_MASK;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-01ch],eax;	@CBE18
	mov	eax,[ebp-01ch];	@CBE18
	xor	ecx,ecx
	mov	cl,[eax+06h]
	and	cl,0f9h
	mov	[eax+06h],cl

; 126   if (Checked(hwnd,HWT_RNOWAIT))
	push	03e9h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL20

; 127     pstComDCB->Flags3 |= F3_WAIT_NONE;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-018h],eax;	@CBE17
	mov	eax,[ebp-018h];	@CBE17
	mov	cl,[eax+06h]
	or	cl,06h
	mov	[eax+06h],cl
	jmp	@BLBL21
	align 010h
@BLBL20:

; 128   else
; 129     {
; 130     if (Checked(hwnd,HWT_RWAITSOME))
	push	03eah
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL22

; 131       pstComDCB->Flags3 |= F3_WAIT_SOMETHING;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-014h],eax;	@CBE16
	mov	eax,[ebp-014h];	@CBE16
	mov	cl,[eax+06h]
	or	cl,04h
	mov	[eax+06h],cl
	jmp	@BLBL21
	align 010h
@BLBL22:

; 132     else
; 133       pstComDCB->Flags3 |= F3_WAIT_NORM;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-010h],eax;	@CBE15
	mov	eax,[ebp-010h];	@CBE15
	mov	cl,[eax+06h]
	or	cl,02h
	mov	[eax+06h],cl

; 134     }
@BLBL21:

; 135   WinQueryDlgItemText(hwnd,HWT_RTIME,6,szTimeout);
	lea	eax,[ebp-09h];	szTimeout
	push	eax
	push	06h
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 136   pstComDCB->ReadTimeout = (WORD)atol(szTimeout);
	lea	eax,[ebp-09h];	szTimeout
	call	atol
	mov	ecx,eax
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[eax+02h],cx

; 137   }
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
UnloadHdwTimeoutDlg	endp

; 140   {
	align 010h

	public TCHdwTimeoutDlg
TCHdwTimeoutDlg	proc
	push	ebp
	mov	ebp,esp

; 141   switch(idButton)
	xor	eax,eax
	mov	ax,[ebp+0ch];	idButton
	jmp	@BLBL34
	align 04h
@BLBL35:

; 142     {
; 143     case HWT_RNOWAIT:
; 144       if (Checked(hwnd,HWT_RNOWAIT))
	push	03e9h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL24

; 145         {
; 146         ControlEnable(hwnd,HWT_RTIMET,FALSE);
	push	0h
	push	03f2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 147         ControlEnable(hwnd,HWT_RTIME,FALSE);
	push	0h
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 148         }
	jmp	@BLBL25
	align 010h
@BLBL24:

; 149       else
; 150         {
; 151         ControlEnable(hwnd,HWT_RTIMET,TRUE);
	push	01h
	push	03f2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 152         ControlEnable(hwnd,HWT_RTIME,TRUE);
	push	01h
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 153         }
@BLBL25:

; 154       break;
	jmp	@BLBL33
	align 04h
@BLBL36:
@BLBL37:

; 155     case HWT_RNORM:
; 156     case HWT_RWAITSOME:
; 157       if (Checked(hwnd,HWT_RNORM) || Checked(hwnd,HWT_RWAITSOME))
	push	03ebh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL26
	push	03eah
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL27
@BLBL26:

; 158         {
; 159         ControlEnable(hwnd,HWT_RTIMET,TRUE);
	push	01h
	push	03f2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 160         ControlEnable(hwnd,HWT_RTIME,TRUE);
	push	01h
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 161         }
	jmp	@BLBL28
	align 010h
@BLBL27:

; 162       else
; 163         {
; 164         ControlEnable(hwnd,HWT_RTIMET,FALSE);
	push	0h
	push	03f2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 165         ControlEnable(hwnd,HWT_RTIME,FALSE);
	push	0h
	push	03f1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 166         }
@BLBL28:

; 167       break;
	jmp	@BLBL33
	align 04h
@BLBL38:

; 168     case HWT_WINF:
; 169       if (Checked(hwnd,HWT_WINF))
	push	03efh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL29

; 170         {
; 171         ControlEnable(hwnd,HWT_WTIMET,FALSE);
	push	0h
	push	03eeh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 172         ControlEnable(hwnd,HWT_WTIME,FALSE);
	push	0h
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 173         }
	jmp	@BLBL30
	align 010h
@BLBL29:

; 174       else
; 175         {
; 176         ControlEnable(hwnd,HWT_WTIMET,TRUE);
	push	01h
	push	03eeh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 177         ControlEnable(hwnd,HWT_WTIME,TRUE);
	push	01h
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 178         }
@BLBL30:

; 179       break;
	jmp	@BLBL33
	align 04h
@BLBL39:

; 180     case HWT_WNORM:
; 181       if (Checked(hwnd,HWT_WNORM))
	push	03f0h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL31

; 182         {
; 183         ControlEnable(hwnd,HWT_WTIMET,TRUE);
	push	01h
	push	03eeh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 184         ControlEnable(hwnd,HWT_WTIME,TRUE);
	push	01h
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 185         }
	jmp	@BLBL32
	align 010h
@BLBL31:

; 186       else
; 187         {
; 188         ControlEnable(hwnd,HWT_WTIMET,FALSE);
	push	0h
	push	03eeh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 189         ControlEnable(hwnd,HWT_WTIME,FALSE);
	push	0h
	push	03edh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 190         }
@BLBL32:

; 191       break;
	jmp	@BLBL33
	align 04h
@BLBL40:

; 192     default:
; 193       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL33
	align 04h
@BLBL34:
	cmp	eax,03e9h
	je	@BLBL35
	cmp	eax,03ebh
	je	@BLBL36
	cmp	eax,03eah
	je	@BLBL37
	cmp	eax,03efh
	je	@BLBL38
	cmp	eax,03f0h
	je	@BLBL39
	jmp	@BLBL40
	align 04h
@BLBL33:

; 194     }
; 195   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
TCHdwTimeoutDlg	endp

; 199   {
	align 010h

	public FillHandshakeDlg
FillHandshakeDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax

; 202   BOOL bXHS = FALSE;
	mov	dword ptr [ebp-0ch],0h;	bXHS

; 203 
; 204   if (pstFIFOinfo->wFIFOflags & FIFO_FLG_TYPE_MASK)
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+04h],0fh
	je	@BLBL41

; 205     {
; 206     WinSetDlgItemText(hwnd,HS_CTSOUT,"Using CTS................");
	push	offset FLAT:@STAT5
	push	01c5h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 207     WinShowWindow(WinWindowFromID(hwnd,HWF_HDW_CTS_HS),TRUE);
	push	015aeh
	push	dword ptr [ebp+08h];	hwnd
	call	WinWindowFromID
	add	esp,08h
	push	01h
	push	eax
	call	WinShowWindow
	add	esp,08h

; 208     if (pstFIFOinfo->wFIFOflags & (FIFO_FLG_TYPE_16650 | FIFO_FLG_TYPE_16654))
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+04h],05h
	je	@BLBL41

; 209       {
; 210       WinSetDlgItemText(hwnd,HS_RTSINHS,"Input handshaking................");
	push	offset FLAT:@STAT6
	push	01c0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 211       WinShowWindow(WinWindowFromID(hwnd,HWF_HDW_RTS_HS),TRUE);
	push	015afh
	push	dword ptr [ebp+08h];	hwnd
	call	WinWindowFromID
	add	esp,08h
	push	01h
	push	eax
	call	WinShowWindow
	add	esp,08h

; 212 #ifdef allow_16650_HDW_Xon_HS
; 213       WinSetDlgItemText(hwnd,HS_RXFLOW,"Receive Xon/Xoff................");
; 214       WinShowWindow(WinWindowFromID(hwnd,HWF_HDW_RX_XON_HS),TRUE);
; 215       WinSetDlgItemText(hwnd,HS_TXFLOW,"Transmit Xon/Xoff................");
; 216       WinShowWindow(WinWindowFromID(hwnd,HWF_HDW_TX_XON_HS),TRUE);
; 217 #endif
; 218       }

; 219     }
@BLBL41:

; 220   if (pstFIFOinfo->wFIFOflags & FIFO_FLG_TYPE_MASK)
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+04h],0fh
	je	@BLBL43

; 221     {
; 222     if (pstFIFOinfo->wFIFOflags & FIFO_FLG_HDW_CTS_HS)
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+05h],04h
	je	@BLBL44

; 223       {
; 224       CheckButton(hwnd,HWF_HDW_CTS_HS,TRUE);
	push	01h
	push	015aeh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 225       if ((pstFIFOinfo->wFIFOflags & (FIFO_FLG_TYPE_16750 | FIFO_FLG_TYPE_TI16550C)) &&
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+04h],0ah
	je	@BLBL44

; 226           (pstComDCB->Flags1 & F1_ENABLE_CTS_OUTPUT_HS))
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+04h],08h
	je	@BLBL44

; 227         {
; 228         ControlEnable(hwnd,HS_RTSENAB,FALSE);
	push	0h
	push	01c2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 229         ControlEnable(hwnd,HS_RTSTOG,FALSE);
	push	0h
	push	01bfh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 230         }

; 231       }
@BLBL44:

; 232     if (pstFIFOinfo->wFIFOflags & (FIFO_FLG_TYPE_16650 | FIFO_FLG_TYPE_16654))
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+04h],05h
	je	@BLBL43

; 233       {
; 234       if (pstFIFOinfo->wFIFOflags & FIFO_FLG_HDW_RTS_HS)
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+05h],08h
	je	@BLBL43

; 235         CheckButton(hwnd,HWF_HDW_RTS_HS,TRUE);
	push	01h
	push	015afh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 236 #ifdef allow_16650_HDW_Xon_HS
; 237       if (pstFIFOinfo->wFIFOflags & FIFO_FLG_HDW_RX_XON_HS)
; 238         CheckButton(hwnd,HWF_HDW_RX_XON_HS,TRUE);
; 239       if (pstFIFOinfo->wFIFOflags & FIFO_FLG_HDW_TX_XON_HS)
; 240         CheckButton(hwnd,HWF_HDW_TX_XON_HS,TRUE);
; 241 #endif
; 242       }

; 243     }
@BLBL43:

; 244   sprintf(szXchar,"%02X",pstComDCB->XoffChar);
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	al,[ecx+0ah]
	push	eax
	mov	edx,offset FLAT:@STAT7
	lea	eax,[ebp-05h];	szXchar
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 245   WinSendDlgItemMsg(hwnd,HS_XOFFCHAR,EM_SETTEXTLIMIT,MPFROMSHORT(3),(MPARAM)NULL);
	push	0h
	push	03h
	push	0143h
	push	01c9h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 246   WinSetDlgItemText(hwnd,HS_XOFFCHAR,szXchar);
	lea	eax,[ebp-05h];	szXchar
	push	eax
	push	01c9h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 247 
; 248   sprintf(szXchar,"%02X",pstComDCB->XonChar);
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	al,[ecx+09h]
	push	eax
	mov	edx,offset FLAT:@STAT8
	lea	eax,[ebp-05h];	szXchar
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 249   WinSendDlgItemMsg(hwnd,HS_XONCHAR,EM_SETTEXTLIMIT,MPFROMSHORT(3),(MPARAM)NULL);
	push	0h
	push	03h
	push	0143h
	push	01cah
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 250   WinSetDlgItemText(hwnd,HS_XONCHAR,szXchar);
	lea	eax,[ebp-05h];	szXchar
	push	eax
	push	01cah
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 251 
; 252   if (pstComDCB->Flags2 & F2_ENABLE_XMIT_XON_XOFF_FLOW)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+05h],01h
	je	@BLBL48

; 253     {
; 254     CheckButton(hwnd,HS_TXFLOW,TRUE);
	push	01h
	push	01c8h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 255     bXHS = TRUE;
	mov	dword ptr [ebp-0ch],01h;	bXHS

; 256     }
@BLBL48:

; 257   if (pstComDCB->Flags2 & F2_ENABLE_RCV_XON_XOFF_FLOW)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+05h],02h
	je	@BLBL49

; 258     {
; 259     CheckButton(hwnd,HS_RXFLOW,TRUE);
	push	01h
	push	01c7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 260     bXHS = TRUE;
	mov	dword ptr [ebp-0ch],01h;	bXHS

; 261     if (pstComDCB->Flags2 & F2_ENABLE_FULL_D
; 261 UPLEX)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+05h],020h
	je	@BLBL51

; 262       CheckButton(hwnd,HS_FULLDUP,TRUE);
	push	01h
	push	01c6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 263 #ifdef allow_16650_HDW_Xon_HS
; 264     if (pstFIFOinfo->wFIFOflags & FIFO_FLG_HDW_RX_XON_HS)
; 265       ControlEnable(hwnd,HS_FULLDUP,FALSE);
; 266 #endif
; 267     }
	jmp	@BLBL51
	align 010h
@BLBL49:

; 268   else
; 269     ControlEnable(hwnd,HS_FULLDUP,FALSE);
	push	0h
	push	01c6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch
@BLBL51:

; 270 
; 271   if (!bXHS)
	cmp	dword ptr [ebp-0ch],0h;	bXHS
	jne	@BLBL52

; 272     {
; 273     ControlEnable(hwnd,HS_XOFFCHART,FALSE);
	push	0h
	push	01cbh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 274     ControlEnable(hwnd,HS_XONCHART,FALSE);
	push	0h
	push	01cch
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 275     ControlEnable(hwnd,HS_XOFFCHAR,FALSE);
	push	0h
	push	01c9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 276     ControlEnable(hwnd,HS_XONCHAR,FALSE);
	push	0h
	push	01cah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 277     ControlEnable(hwnd,HS_XONCHARTT,FALSE);
	push	0h
	push	01455h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 278     ControlEnable(hwnd,HS_XONCHARTTT,FALSE);
	push	0h
	push	01456h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 279     ControlEnable(hwnd,HS_XOFFCHARTT,FALSE);
	push	0h
	push	01457h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 280     ControlEnable(hwnd,HS_XOFFCHARTTT,FALSE);
	push	0h
	push	01458h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 281     }
@BLBL52:

; 282 
; 283   switch ((pstComDCB->Flags2 & F2_RTS_MASK) >> 6)
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	al,[ecx+05h]
	and	eax,0c0h
	sar	eax,06h
	jmp	@BLBL58
	align 04h
@BLBL59:

; 284     {
; 285     case 0:
; 286       idEntryField = HS_RTSDISAB;
	mov	word ptr [ebp-08h],01c1h;	idEntryField

; 287       break;
	jmp	@BLBL57
	align 04h
@BLBL60:

; 288     case 1:
; 289       idEntryField = HS_RTSENAB;
	mov	word ptr [ebp-08h],01c2h;	idEntryField

; 290       break;
	jmp	@BLBL57
	align 04h
@BLBL61:

; 291     case 2:
; 292       idEntryField = HS_RTSINHS;
	mov	word ptr [ebp-08h],01c0h;	idEntryField

; 293       break;
	jmp	@BLBL57
	align 04h
@BLBL62:

; 294     case 3:
; 295       idEntryField = HS_RTSTOG;
	mov	word ptr [ebp-08h],01bfh;	idEntryField

; 296       break;
	jmp	@BLBL57
	align 04h
	jmp	@BLBL57
	align 04h
@BLBL58:
	test	eax,eax
	je	@BLBL59
	cmp	eax,01h
	je	@BLBL60
	cmp	eax,02h
	je	@BLBL61
	cmp	eax,03h
	je	@BLBL62
@BLBL57:

; 297     }
; 298   CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-08h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 299   switch (pstComDCB->Flags1 & F1_DTR_MASK)
	mov	ecx,[ebp+0ch];	pstComDCB
	xor	eax,eax
	mov	al,[ecx+04h]
	and	eax,03h
	jmp	@BLBL64
	align 04h
@BLBL65:

; 300     {
; 301     case 0:
; 302       idEntryField = HS_DTRDISAB;
	mov	word ptr [ebp-08h],01bch;	idEntryField

; 303       break;
	jmp	@BLBL63
	align 04h
@BLBL66:

; 304     case 1:
; 305       idEntryField = HS_DTRENAB;
	mov	word ptr [ebp-08h],01bdh;	idEntryField

; 306       break;
	jmp	@BLBL63
	align 04h
@BLBL67:

; 307     case 2:
; 308       idEntryField = HS_DTRINHS;
	mov	word ptr [ebp-08h],01bbh;	idEntryField

; 309       break;
	jmp	@BLBL63
	align 04h
	jmp	@BLBL63
	align 04h
@BLBL64:
	test	eax,eax
	je	@BLBL65
	cmp	eax,01h
	je	@BLBL66
	cmp	eax,02h
	je	@BLBL67
@BLBL63:

; 310     }
; 311   CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-08h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 312   if (pstComDCB->Flags1 & F1_ENABLE_CTS_OUTPUT_HS)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+04h],08h
	je	@BLBL53

; 313     CheckButton(hwnd,HS_CTSOUT,TRUE);
	push	01h
	push	01c5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL53:

; 314   if (pstComDCB->Flags1 & F1_ENABLE_DSR_OUTPUT_HS)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+04h],010h
	je	@BLBL54

; 315     CheckButton(hwnd,HS_DSROUT,TRUE);
	push	01h
	push	01c4h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL54:

; 316   if (pstComDCB->Flags1 & F1_ENABLE_DCD_OUTPUT_HS)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+04h],020h
	je	@BLBL55

; 317     CheckButton(hwnd,HS_DCDOUT,TRUE);
	push	01h
	push	01c3h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL55:

; 318   if (pstComDCB->Flags1 & F1_ENABLE_DSR_INPUT_HS)
	mov	eax,[ebp+0ch];	pstComDCB
	test	byte ptr [eax+04h],040h
	je	@BLBL56

; 319     CheckButton(hwnd,HS_DSRINSENSE,TRUE);
	push	01h
	push	01beh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL56:

; 320  }
	mov	esp,ebp
	pop	ebp
	ret	
FillHandshakeDlg	endp

; 323   {
	align 010h

	public TCHandshakeDlg
TCHandshakeDlg	proc
	push	ebp
	mov	ebp,esp

; 324   switch(idButton)
	xor	eax,eax
	mov	ax,[ebp+0ch];	idButton
	jmp	@BLBL90
	align 04h
@BLBL91:

; 325     {
; 326 #ifdef allow_16650_HDW_Xon_HS
; 327     case HWF_HDW_RX_XON_HS:
; 328       if (Checked(hwnd,HWF_HDW_RX_XON_HS))
; 329         {
; 330 //        CheckButton(hwnd,HWF_HDW_RX_XON_HS,TRUE);
; 331         ControlEnable(hwnd,HS_FULLDUP,FALSE);
; 332         }
; 333       else
; 334         {
; 335 //        CheckButton(hwnd,HWF_HDW_RX_XON_HS,FALSE);
; 336         if (Checked(hwnd,HS_RXFLOW))
; 337           ControlEnable(hwnd,HS_FULLDUP,TRUE);
; 338         }
; 339       break;
; 340 #endif
; 341       case HS_CTSOUT:
; 342         if (!Checked(hwnd,HS_CTSOUT))
	push	01c5h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL68

; 343           {
; 344           CheckButton(hwnd,HS_CTSOUT,TRUE);
	push	01h
	push	01c5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 345           if (pstFIFOinfo->wFIFOflags & (FIFO_FLG_TYPE_16750 | FIFO_FLG_TYPE_TI16550C))
	mov	eax,[ebp+014h];	pstFIFOinfo
	test	byte ptr [eax+04h],0ah
	je	@BLBL74

; 346             if (Checked(hwnd,HWF_HDW_CTS_HS))
	push	015aeh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL74

; 347               {
; 348               ControlEnable(hwnd,HS_RTSENAB,FALSE);
	push	0h
	push	01c2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 349               ControlEnable(hwnd,HS_RTSTOG,FALSE);
	push	0h
	push	01bfh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 350               if (Checked(hwnd,HS_RTSENAB))
	push	01c2h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL71

; 351                 CheckButton(hwnd,HS_RTSINHS,TRUE);
	push	01h
	push	01c0h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL74
	align 010h
@BLBL71:

; 352               else
; 353                 if (Checked(hwnd,HS_RTSTOG))
	push	01bfh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL74

; 354                   CheckButton(hwnd,HS_RTSDISAB,TRUE);
	push	01h
	push	01c1h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 355               }

; 356           }
	jmp	@BLBL74
	align 010h
@BLBL68:

; 357         else
; 358           {
; 359           CheckButton(hwnd,HS_CTSOUT,FALSE);
	push	0h
	push	01c5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 360           if (pstFIFOinfo->wFIFOflags & (FIFO_FLG_TYPE_16750 | FIFO_FLG_TYPE_TI16550C))
	mov	eax,[ebp+014h];	pstFIFOinfo
	test	byte ptr [eax+04h],0ah
	je	@BLBL74

; 361             {
; 362             ControlEnable(hwnd,HS_RTSENAB,TRUE);
	push	01h
	push	01c2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 363             ControlEnable(hwnd,HS_RTSTOG,TRUE);
	push	01h
	push	01bfh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 364             }

; 365           }
@BLBL74:

; 366        break;
	jmp	@BLBL89
	align 04h
@BLBL92:

; 367       case HWF_HDW_CTS_HS:
; 368         if (!Checked(hwnd,HWF_HDW_CTS_HS))
	push	015aeh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL76

; 369           {
; 370           CheckButton(hwnd,HWF_HDW_CTS_HS,TRUE);
	push	01h
	push	015aeh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 371           if (pstFIFOinfo->wFIFOflags & (FIFO_FLG_TYPE_16750 | FIFO_FLG_TYPE_TI16550C))
	mov	eax,[ebp+014h];	pstFIFOinfo
	test	byte ptr [eax+04h],0ah
	je	@BLBL82

; 372             if (Checked(hwnd,HS_CTSOUT))
	push	01c5h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL82

; 373               {
; 374               ControlEnable(hwnd,HS_RTSENAB,FALSE);
	push	0h
	push	01c2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 375               ControlEnable(hwnd,HS_RTSTOG,FALSE);
	push	0h
	push	01bfh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 376               if (Checked(hwnd,HS_RTSENAB))
	push	01c2h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL79

; 377                 CheckButton(hwnd,HS_RTSINHS,TRUE);
	push	01h
	push	01c0h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL82
	align 010h
@BLBL79:

; 378               else
; 379                 if (Checked(hwnd,HS_RTSTOG))
	push	01bfh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL82

; 380                   CheckButton(hwnd,HS_RTSDISAB,TRUE);
	push	01h
	push	01c1h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 381               }

; 382           }
	jmp	@BLBL82
	align 010h
@BLBL76:

; 383         else
; 384           {
; 385           CheckButton(hwnd,HWF_HDW_CTS_HS,FALSE);
	push	0h
	push	015aeh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 386           if (pstFIFOinfo->wFIFOflags & (FIFO_FLG_TYPE_16750 | FIFO_FLG_TYPE_TI16550C))
	mov	eax,[ebp+014h];	pstFIFOinfo
	test	byte ptr [eax+04h],0ah
	je	@BLBL82

; 387             {
; 388             ControlEnable(hwnd,HS_RTSENAB,TRUE);
	push	01h
	push	01c2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 389             ControlEnable(hwnd,HS_RTSTOG,TRUE);
	push	01h
	push	01bfh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 390             }

; 391           }
@BLBL82:

; 392        break;
	jmp	@BLBL89
	align 04h
@BLBL93:
@BLBL94:

; 393     case HS_RXFLOW:
; 394     case HS_TXFLOW:
; 395       if (Checked(hwnd,HS_RXFLOW) ||
	push	01c7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL84

; 396           Checked(hwnd,HS_TXFLOW))
	push	01c8h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL85
@BLBL84:

; 397         {
; 398         ControlEnable(hwnd,HS_XOFFCHART,TRUE);
	push	01h
	push	01cbh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 399         ControlEnable(hwnd,HS_XONCHART,TRUE);
	push	01h
	push	01cch
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 400         ControlEnable(hwnd,HS_XOFFCHAR,TRUE);
	push	01h
	push	01c9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 401         ControlEnable(hwnd,HS_XONCHAR,TRUE);
	push	01h
	push	01cah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 402         ControlEnable(hwnd,HS_XONCHARTT,TRUE);
	push	01h
	push	01455h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 403         ControlEnable(hwnd,HS_XONCHARTTT,TRUE);
	push	01h
	push	01456h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 404         ControlEnable(hwnd,HS_XOFFCHARTT,TRUE);
	push	01h
	push	01457h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 405         ControlEnable(hwnd,HS_XOFFCHARTTT,TRUE);
	push	01h
	push	01458h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 406         }
	jmp	@BLBL86
	align 010h
@BLBL85:

; 407       else
; 408         {
; 409         ControlEnable(hwnd,HS_XOFFCHART,FALSE);
	push	0h
	push	01cbh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 410         ControlEnable(hwnd,HS_XONCHART,FALSE);
	push	0h
	push	01cch
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 411         ControlEnable(hwnd,HS_XOFFCHAR,FALSE);
	push	0h
	push	01c9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 412         ControlEnable(hwnd,HS_XONCHAR,FALSE);
	push	0h
	push	01cah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 413         ControlEnable(hwnd,HS_XONCHARTT,FALSE);
	push	0h
	push	01455h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 414         ControlEnable(hwnd,HS_XONCHARTTT,FALSE);
	push	0h
	push	01456h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 415         ControlEnable(hwnd,HS_XOFFCHARTT,FALSE);
	push	0h
	push	01457h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 416         ControlEnable(hwnd,HS_XOFFCHARTTT,FALSE);
	push	0h
	push	01458h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 417         }
@BLBL86:

; 418       if (!Checked(hwnd,HS_RXFLOW))
	push	01c7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL87

; 419         ControlEnable(hwnd,HS_FULLDUP,FALSE);
	push	0h
	push	01c6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch
	jmp	@BLBL88
	align 010h
@BLBL87:

; 420       else
; 421         {
; 422 #ifdef allow_16650_HDW_Xon_HS
; 423         if (!Checked(hwnd,HWF_HDW_RX_XON_HS))
; 424 #endif
; 425           ControlEnable(hwnd,HS_FULLDUP,TRUE);
	push	01h
	push	01c6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 426         }
@BLBL88:

; 427       break;
	jmp	@BLBL89
	align 04h
@BLBL95:

; 428     default:
; 429       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL89
	align 04h
@BLBL90:
	cmp	eax,01c5h
	je	@BLBL91
	cmp	eax,015aeh
	je	@BLBL92
	cmp	eax,01c7h
	je	@BLBL93
	cmp	eax,01c8h
	je	@BLBL94
	jmp	@BLBL95
	align 04h
@BLBL89:

; 430     }
; 431   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
TCHandshakeDlg	endp

; 435   {
	align 010h

	public UnloadHandshakeDlg
UnloadHandshakeDlg	proc
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

; 437   BOOL bXHS = FALSE;
	mov	dword ptr [ebp-0ch],0h;	bXHS

; 438 
; 439   pstFIFOinfo->wFIFOflags &= ~FIFO_FLG_HDW_HS_MASK;
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	[ebp-070h],eax;	@CBE45
	mov	eax,[ebp-070h];	@CBE45
	xor	ecx,ecx
	mov	cx,[eax+04h]
	and	ch,0f3h
	mov	[eax+04h],cx

; 440   if (pstFIFOinfo->wFIFOflags & FIFO_FLG_TYPE_MASK)
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+04h],0fh
	je	@BLBL96

; 441     {
; 442     if (Checked(hwnd,HWF_HDW_CTS_HS))
	push	015aeh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL97

; 443       {
; 444       pstFIFOinfo->wFIFOflags |= FIFO_FLG_HDW_CTS_HS;
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	[ebp-06ch],eax;	@CBE44
	mov	eax,[ebp-06ch];	@CBE44
	mov	cx,[eax+04h]
	or	cx,0400h
	mov	[eax+04h],cx

; 445       if (pstFIFOinfo->wFIFOflags & (FIFO_FLG_TYPE_16750 | FIFO_FLG_TYPE_TI16550C))
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+04h],0ah
	je	@BLBL97

; 446         pstFIFOinfo->wFIFOflags |= FIFO_FLG_HDW_RTS_HS;
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	[ebp-068h],eax;	@CBE43
	mov	eax,[ebp-068h];	@CBE43
	mov	cx,[eax+04h]
	or	cx,0800h
	mov	[eax+04h],cx

; 447       }
@BLBL97:

; 448     if (Checked(hwnd,HWF_HDW_RTS_HS))
	push	015afh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL96

; 449       pstFIFOinfo->wFIFOflags |= FIFO_FLG_HDW_RTS_HS;
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	[ebp-064h],eax;	@CBE42
	mov	eax,[ebp-064h];	@CBE42
	mov	cx,[eax+04h]
	or	cx,0800h
	mov	[eax+04h],cx

; 450 #ifdef allow_16650_HDW_Xon_HS
; 451     if (Checked(hwnd,HWF_HDW_RX_XON_HS))
; 452       pstFIFOinfo->wFIFOflags |= FIFO_FLG_HDW_RX_XON_HS;
; 453     if (Checked(hwnd,HWF_HDW_TX_XON_HS))
; 454       pstFIFOinfo->wFIFOflags |= FIFO_FLG_HDW_TX_XON_HS;
; 455 #endif
; 456     }
@BLBL96:

; 457   if (Checked(hwnd,HS_TXFLOW))
	push	01c8h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL100

; 458     {
; 459     bXHS = TRUE;
	mov	dword ptr [ebp-0ch],01h;	bXHS

; 460     pstComDCB->Flags2 |= F2_ENABLE_XMIT_XON_XOFF_FLOW;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-060h],eax;	@CBE41
	mov	eax,[ebp-060h];	@CBE41
	mov	cl,[eax+05h]
	or	cl,01h
	mov	[eax+05h],cl

; 461     }
	jmp	@BLBL101
	align 010h
@BLBL100:

; 462   else
; 463     pstComDCB->Flags2 &= ~F2_ENABLE_XMIT_XON_XOFF_FLOW;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-05ch],eax;	@CBE40
	mov	eax,[ebp-05ch];	@CBE40
	xor	ecx,ecx
	mov	cl,[eax+05h]
	and	cl,0feh
	mov	[eax+05h],cl
@BLBL101:

; 464 
; 465   pstComDCB->Flags2 &= ~F2_ENABLE_FULL_DUPLEX;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-058h],eax;	@CBE39
	mov	eax,[ebp-058h];	@CBE39
	xor	ecx,ecx
	mov	cl,[eax+05h]
	and	cl,0dfh
	mov	[eax+05h],cl

; 466   if (Checked(hwnd,HS_RXFLOW))
	push	01c7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL102

; 467     {
; 468     bXHS = TRUE;
	mov	dword ptr [ebp-0ch],01h;	bXHS

; 469     pstComDCB->Flags2 |= F2_ENABLE_RCV_XON_XOFF_FLOW;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-054h],eax;	@CBE38
	mov	eax,[ebp-054h];	@CBE38
	mov	cl,[eax+05h]
	or	cl,02h
	mov	[eax+05h],cl

; 470     if (Checked(hwnd,HS_FULLDUP))
	push	01c6h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL104

; 471 #ifdef allow_16650_HDW_Xon_HS
; 472       if ((pstFIFOinfo->wFIFOflags & FIFO_FLG_HDW_RX_XON_HS) == 0);
; 473 #endif
; 474         pstComDCB->Flags2 |= F2_ENABLE_FULL_DUPLEX;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-050h],eax;	@CBE37
	mov	eax,[ebp-050h];	@CBE37
	mov	cl,[eax+05h]
	or	cl,020h
	mov	[eax+05h],cl

; 475     }
	jmp	@BLBL104
	align 010h
@BLBL102:

; 476   else
; 477     pstComDCB->Flags2 &= ~F2_ENABLE_RCV_XON_XOFF_FLOW;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-04ch],eax;	@CBE36
	mov	eax,[ebp-04ch];	@CBE36
	xor	ecx,ecx
	mov	cl,[eax+05h]
	and	cl,0fdh
	mov	[eax+05h],cl
@BLBL104:

; 478 
; 479   if (bXHS)
	cmp	dword ptr [ebp-0ch],0h;	bXHS
	je	@BLBL105

; 480     {
; 481     WinQueryDlgItemText(hwnd,HS_XOFFCHAR,3,szXchar);
	lea	eax,[ebp-05h];	szXchar
	push	eax
	push	03h
	push	01c9h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 482     pstComDCB->XoffChar = (BYTE)ASCIItoBin(szXchar,16);
	push	010h
	lea	eax,[ebp-05h];	szXchar
	push	eax
	call	ASCIItoBin
	mov	ecx,eax
	add	esp,08h
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[eax+0ah],cl

; 483 
; 484     WinQueryDlgItemText(hwnd,HS_XONCHAR,3,szXchar);
	lea	eax,[ebp-05h];	szXchar
	push	eax
	push	03h
	push	01cah
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 485     pstComDCB->XonChar = (BYTE)ASCIItoBin(szXchar,16);
	push	010h
	lea	eax,[ebp-05h];	szXchar
	push	eax
	call	ASCIItoBin
	mov	ecx,eax
	add	esp,08h
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[eax+09h],cl

; 486     }
@BLBL105:

; 487 
; 488   pstComDCB->Flags2 &= ~F2_RTS_MASK;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-048h],eax;	@CBE35
	mov	eax,[ebp-048h];	@CBE35
	xor	ecx,ecx
	mov	cl,[eax+05h]
	and	cl,03fh
	mov	[eax+05h],cl

; 489   if (Checked(hwnd,HS_RTSENAB))
	push	01c2h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL106

; 490     pstComDCB->Flags2 |= F2_ENABLE_RTS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-044h],eax;	@CBE34
	mov	eax,[ebp-044h];	@CBE34
	mov	cl,[eax+05h]
	or	cl,040h
	mov	[eax+05h],cl
	jmp	@BLBL107
	align 010h
@BLBL106:

; 491   else
; 492     if (Checked(hwnd,HS_RTSINHS))
	push	01c0h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL108

; 493       pstComDCB->Flags2 |= F2_ENABLE_RTS_INPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-040h],eax;	@CBE33
	mov	eax,[ebp-040h];	@CBE33
	mov	cl,[eax+05h]
	or	cl,080h
	mov	[eax+05h],cl
	jmp	@BLBL107
	align 010h
@BLBL108:

; 494     else
; 495       if (Checked(hwnd,HS_RTSTOG))
	push	01bfh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL107

; 496         pstComDCB->Flags2 |= F2_ENABLE_RTS_TOG_ON_XMIT;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-03ch],eax;	@CBE32
	mov	eax,[ebp-03ch];	@CBE32
	mov	cl,[eax+05h]
	or	cl,0c0h
	mov	[eax+05h],cl
@BLBL107:

; 497 
; 498   pstComDCB->Flags1 &= ~F1_DTR_MASK;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-038h],eax;	@CBE31
	mov	eax,[ebp-038h];	@CBE31
	xor	ecx,ecx
	mov	cl,[eax+04h]
	and	cl,0fch
	mov	[eax+04h],cl

; 499   if (Checked(hwnd,HS_DTRENAB))
	push	01bdh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL111

; 500     pstComDCB->Flags1 |= F1_ENABLE_DTR;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-034h],eax;	@CBE30
	mov	eax,[ebp-034h];	@CBE30
	mov	cl,[eax+04h]
	or	cl,01h
	mov	[eax+04h],cl
	jmp	@BLBL112
	align 010h
@BLBL111:

; 501   else
; 502     if (Checked(hwnd,HS_DTRINHS))
	push	01bbh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL112

; 503       pstComDCB->Flags1 |= F1_ENABLE_DTR_INPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-030h],eax;	@CBE29
	mov	eax,[ebp-030h];	@CBE29
	mov	cl,[eax+04h]
	or	cl,02h
	mov	[eax+04h],cl
@BLBL112:

; 504 
; 505   if (Checked(hwnd,HS_CTSOUT))
	push	01c5h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL114

; 506     pstComDCB->Flags1 |= F1_ENABLE_CTS_OUTPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-02ch],eax;	@CBE28
	mov	eax,[ebp-02ch];	@CBE28
	mov	cl,[eax+04h]
	or	cl,08h
	mov	[eax+04h],cl
	jmp	@BLBL115
	align 010h
@BLBL114:

; 507   else
; 508     pstComDCB->Flags1 &= ~F1_ENABLE_CTS_OUTPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-028h],eax;	@CBE27
	mov	eax,[ebp-028h];	@CBE27
	xor	ecx,ecx
	mov	cl,[eax+04h]
	and	cl,0f7h
	mov	[eax+04h],cl
@BLBL115:

; 509 
; 510   if (Checked(hwnd,HS_DSROUT))
	push	01c4h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL116

; 511     pstComDCB->Flags1 |= F1_ENABLE_DSR_OUTPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-024h],eax;	@CBE26
	mov	eax,[ebp-024h];	@CBE26
	mov	cl,[eax+04h]
	or	cl,010h
	mov	[eax+04h],cl
	jmp	@BLBL117
	align 010h
@BLBL116:

; 512   else
; 513     pstComDCB->Flags1 &= ~F1_ENABLE_DSR_OUTPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-020h],eax;	@CBE25
	mov	eax,[ebp-020h];	@CBE25
	xor	ecx,ecx
	mov	cl,[eax+04h]
	and	cl,0efh
	mov	[eax+04h],cl
@BLBL117:

; 514 
; 515   if (Checked(hwnd,HS_DCDOUT))
	push	01c3h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL118

; 516     pstComDCB->Flags1 |= F1_ENABLE_DCD_OUTPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-01ch],eax;	@CBE24
	mov	eax,[ebp-01ch];	@CBE24
	mov	cl,[eax+04h]
	or	cl,020h
	mov	[eax+04h],cl
	jmp	@BLBL119
	align 010h
@BLBL118:

; 517   else
; 518     pstComDCB->Flags1 &= ~F1_ENABLE_DCD_OUTPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-018h],eax;	@CBE23
	mov	eax,[ebp-018h];	@CBE23
	xor	ecx,ecx
	mov	cl,[eax+04h]
	and	cl,0dfh
	mov	[eax+04h],cl
@BLBL119:

; 519 
; 520   if (Checked(hwnd,HS_DSRINSENSE))
	push	01beh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL120

; 521     pstComDCB->Flags1 |= F1_ENABLE_DSR_INPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-014h],eax;	@CBE22
	mov	eax,[ebp-014h];	@CBE22
	mov	cl,[eax+04h]
	or	cl,040h
	mov	[eax+04h],cl
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL120:

; 522   else
; 523     pstComDCB->Flags1 &= ~F1_ENABLE_DSR_INPUT_HS;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-010h],eax;	@CBE21
	mov	eax,[ebp-010h];	@CBE21
	xor	ecx,ecx
	mov	cl,[eax+04h]
	and	cl,0bfh
	mov	[eax+04h],cl

; 524 
; 525   }
	mov	esp,ebp
	pop	ebp
	ret	
UnloadHandshakeDlg	endp

; 528   {
	align 010h

	public FillHdwProtocolDlg
FillHdwProtocolDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 532   idDisableField = HWP_15BITS;
	mov	word ptr [ebp-02h],0196h;	idDisableField

; 533   switch (pstLineChar->DataBits)
	mov	ecx,[ebp+0ch];	pstLineChar
	xor	eax,eax
	mov	al,[ecx]
	jmp	@BLBL123
	align 04h
@BLBL124:

; 534     {
; 535     case 8:
; 536       idEntryField = HWP_8BITS;
	mov	word ptr [ebp-04h],0191h;	idEntryField

; 537       break;
	jmp	@BLBL122
	align 04h
@BLBL125:

; 538     case 7:
; 539       idEntryField = HWP_7BITS;
	mov	word ptr [ebp-04h],0192h;	idEntryField

; 540       break;
	jmp	@BLBL122
	align 04h
@BLBL126:

; 541     case 6:
; 542       idEntryField = HWP_6BITS;
	mov	word ptr [ebp-04h],0193h;	idEntryField

; 543       break;
	jmp	@BLBL122
	align 04h
@BLBL127:

; 544     case 5:
; 545       idEntryField = HWP_5BITS;
	mov	word ptr [ebp-04h],0194h;	idEntryField

; 546       idDisableField = HWP_2BITS;
	mov	word ptr [ebp-02h],0197h;	idDisableField

; 547       break;
	jmp	@BLBL122
	align 04h
	jmp	@BLBL122
	align 04h
@BLBL123:
	cmp	eax,08h
	je	@BLBL124
	cmp	eax,07h
	je	@BLBL125
	cmp	eax,06h
	je	@BLBL126
	cmp	eax,05h
	je	@BLBL127
@BLBL122:

; 548     }
; 549   CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-04h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 550   ControlEnable(hwnd,idDisableField,FALSE);
	push	0h
	mov	ax,[ebp-02h];	idDisableField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 551   switch (pstLineChar->StopBits)
	mov	ecx,[ebp+0ch];	pstLineChar
	xor	eax,eax
	mov	al,[ecx+02h]
	jmp	@BLBL129
	align 04h
@BLBL130:

; 552     {
; 553     case 0:
; 554       idEntryField = HWP_1BIT;
	mov	word ptr [ebp-04h],0195h;	idEntryField

; 555       break;
	jmp	@BLBL128
	align 04h
@BLBL131:

; 556     case 1:
; 557       idEntryField = HWP_15BITS;
	mov	word ptr [ebp-04h],0196h;	idEntryField

; 558       break;
	jmp	@BLBL128
	align 04h
@BLBL132:

; 559     case 2:
; 560       idEntryField = HWP_2BITS;
	mov	word ptr [ebp-04h],0197h;	idEntryField

; 561       break;
	jmp	@BLBL128
	align 04h
	jmp	@BLBL128
	align 04h
@BLBL129:
	test	eax,eax
	je	@BLBL130
	cmp	eax,01h
	je	@BLBL131
	cmp	eax,02h
	je	@BLBL132
@BLBL128:

; 562     }
; 563   CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-04h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 564   switch (pstLineChar->Parity)
	mov	ecx,[ebp+0ch];	pstLineChar
	xor	eax,eax
	mov	al,[ecx+01h]
	jmp	@BLBL134
	align 04h
@BLBL135:

; 565     {
; 566     case 0:
; 567       idEntryField = HWP_NONE;
	mov	word ptr [ebp-04h],019ah;	idEntryField

; 568       break;
	jmp	@BLBL133
	align 04h
@BLBL136:

; 569     case 1:
; 570       idEntryField = HWP_ODD;
	mov	word ptr [ebp-04h],0199h;	idEntryField

; 571       break;
	jmp	@BLBL133
	align 04h
@BLBL137:

; 572     case 2:
; 573       idEntryField = HWP_EVEN;
	mov	word ptr [ebp-04h],0198h;	idEntryField

; 574       break;
	jmp	@BLBL133
	align 04h
@BLBL138:

; 575     case 3:
; 576       idEntryField = HWP_ZERO;
	mov	word ptr [ebp-04h],019ch;	idEntryField

; 577       break;
	jmp	@BLBL133
	align 04h
@BLBL139:

; 578     case 4:
; 579       idEntryField = HWP_ONE;
	mov	word ptr [ebp-04h],019bh;	idEntryField

; 580       break;
	jmp	@BLBL133
	align 04h
	jmp	@BLBL133
	align 04h
@BLBL134:
	test	eax,eax
	je	@BLBL135
	cmp	eax,01h
	je	@BLBL136
	cmp	eax,02h
	je	@BLBL137
	cmp	eax,03h
	je	@BLBL138
	cmp	eax,04h
	je	@BLBL139
@BLBL133:

; 581     }
; 582   CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-04h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 583   }
	mov	esp,ebp
	pop	ebp
	ret	
FillHdwProtocolDlg	endp

; 586   {
	align 010h

	public UnloadHdwProtocolDlg
UnloadHdwProtocolDlg	proc
	push	ebp
	mov	ebp,esp

; 587   if (Checked(hwnd,HWP_8BITS))
	push	0191h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL140

; 588     pstLineChar->DataBits = 8;
	mov	eax,[ebp+0ch];	pstLineChar
	mov	byte ptr [eax],08h
	jmp	@BLBL141
	align 010h
@BLBL140:

; 589   else
; 590     if (Checked(hwnd,HWP_7BITS))
	push	0192h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL142

; 591       pstLineChar->DataBits = 7;
	mov	eax,[ebp+0ch];	pstLineChar
	mov	byte ptr [eax],07h
	jmp	@BLBL141
	align 010h
@BLBL142:

; 592     else
; 593       if (Checked(hwnd,HWP_6BITS))
	push	0193h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL144

; 594         pstLineChar->DataBits = 6;
	mov	eax,[ebp+0ch];	pstLineChar
	mov	byte ptr [eax],06h
	jmp	@BLBL141
	align 010h
@BLBL144:

; 595       else
; 596         if (Checked(hwnd,HWP_5BITS))
	push	0194h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL141

; 597           pstLineChar->DataBits = 5;
	mov	eax,[ebp+0ch];	pstLineChar
	mov	byte ptr [eax],05h
@BLBL141:

; 598 
; 599   if (Checked(hwnd,HWP_1BIT))
	push	0195h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL147

; 600     pstLineChar->StopBits = 0;
	mov	eax,[ebp+0ch];	pstLineChar
	mov	byte ptr [eax+02h],0h
	jmp	@BLBL148
	align 010h
@BLBL147:

; 601   else
; 602     if (Checked(hwnd,HWP_15BITS))
	push	0196h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL149

; 603       pstLineChar->StopBits = 1;
	mov	eax,[ebp+0ch];	pstLineChar
	mov	byte ptr [eax+02h],01h
	jmp	@BLBL148
	align 010h
@BLBL149:

; 604     else
; 605       if (Checked(hwnd,HWP_2BITS))
	push	0197h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL148

; 606         pstLineChar->StopBits = 2;
	mov	eax,[ebp+0ch];	pstLineChar
	mov	byte ptr [eax+02h],02h
@BLBL148:

; 607 
; 608   if (Checked(hwnd,HWP_NONE))
	push	019ah
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL152

; 609     pstLineChar->Parity = 0;
	mov	eax,[ebp+0ch];	pstLineChar
	mov	byte ptr [eax+01h],0h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL152:

; 610   else
; 611     if (Checked(hwnd,HWP_ODD))
	push	0199h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL154

; 612       pstLineChar->Parity = 1;
	mov	eax,[ebp+0ch];	pstLineChar
	mov	byte ptr [eax+01h],01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL154:

; 613     else
; 614       if (Checked(hwnd,HWP_EVEN))
	push	0198h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL156

; 615         pstLineChar->Parity = 2;
	mov	eax,[ebp+0ch];	pstLineChar
	mov	byte ptr [eax+01h],02h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL156:

; 616       else
; 617         if (Checked(hwnd,HWP_ZERO))
	push	019ch
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL158

; 618           pstLineChar->Parity = 3;
	mov	eax,[ebp+0ch];	pstLineChar
	mov	byte ptr [eax+01h],03h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL158:

; 619         else
; 620           if (Checked(hwnd,HWP_ONE))
	push	019bh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL153

; 621             pstLineChar->Parity = 4;
	mov	eax,[ebp+0ch];	pstLineChar
	mov	byte ptr [eax+01h],04h
@BLBL153:

; 622   }
	mov	esp,ebp
	pop	ebp
	ret	
UnloadHdwProtocolDlg	endp

; 625   {
	align 010h

	public TCHdwProtocolDlg
TCHdwProtocolDlg	proc
	push	ebp
	mov	ebp,esp

; 626   switch(idButton)
	xor	eax,eax
	mov	ax,[ebp+0ch];	idButton
	jmp	@BLBL164
	align 04h
@BLBL165:

; 627     {
; 628     case HWP_5BITS:
; 629 //      CheckButton(hwnd,idButton,~Checked(hwnd,idButton));
; 630       ControlEnable(hwnd,HWP_15BITS,TRUE);
	push	01h
	push	0196h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 631       ControlEnable(hwnd,HWP_2BITS,FALSE);
	push	0h
	push	0197h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 632       if (Checked(hwnd,HWP_2BITS))
	push	0197h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL161

; 633         {
; 634         CheckButton(hwnd,HWP_2BITS,FALSE);
	push	0h
	push	0197h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 635         CheckButton(hwnd,HWP_15BITS,TRUE);
	push	01h
	push	0196h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 636         }
@BLBL161:

; 637       break;
	jmp	@BLBL163
	align 04h
@BLBL166:
@BLBL167:
@BLBL168:

; 638     case HWP_8BITS:
; 639     case HWP_7BITS:
; 640     case HWP_6BITS:
; 641 //      CheckButton(hwnd,idButton,~Checked(hwnd,idButton));
; 642       ControlEnable(hwnd,HWP_15BITS,FALSE);
	push	0h
	push	0196h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 643       ControlEnable(hwnd,HWP_2BITS,TRUE);
	push	01h
	push	0197h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 644       if (Checked(hwnd,HWP_15BITS))
	push	0196h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL162

; 645         {
; 646         CheckButton(hwnd,HWP_15BITS,FALSE);
	push	0h
	push	0196h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 647         CheckButton(hwnd,HWP_2BITS,TRUE);
	push	01h
	push	0197h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 648         }
@BLBL162:
@BLBL169:

; 649     default:
; 650       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL163
	align 04h
@BLBL164:
	cmp	eax,0194h
	je	@BLBL165
	cmp	eax,0191h
	je	@BLBL166
	cmp	eax,0192h
	je	@BLBL167
	cmp	eax,0193h
	je	@BLBL168
	jmp	@BLBL169
	align 04h
@BLBL163:

; 651     }
; 652    return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
TCHdwProtocolDlg	endp

; 656   {
	align 010h

	public FillHdwFIFOsetupDlg
FillHdwFIFOsetupDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 661   if ((byFlags & F3_HDW_BUFFER_APO) != 0)
	test	byte ptr [ebp+0ch],018h;	byFlags
	je	@BLBL170

; 662     {
; 663     switch ((byFlags & F3_HDW_BUFFER_APO) >> 3)
	xor	eax,eax
	mov	al,[ebp+0ch];	byFlags
	and	eax,018h
	sar	eax,03h
	jmp	@BLBL183
	align 04h
@BLBL184:

; 664       {
; 665       case 1:
; 666         idEntryField = HWF_DISABFIFO;
	mov	word ptr [ebp-02h],01a7h;	idEntryField

; 667         break;
	jmp	@BLBL182
	align 04h
@BLBL185:
@BLBL186:

; 668       default:
; 669       case 2:
; 670         idEntryField = HWF_ENABFIFO;
	mov	word ptr [ebp-02h],01a6h;	idEntryField

; 671         break;
	jmp	@BLBL182
	align 04h
@BLBL187:

; 672       case 3:
; 673         idEntryField = HWF_APO;
	mov	word ptr [ebp-02h],01a5h;	idEntryField

; 674         break;
	jmp	@BLBL182
	align 04h
	jmp	@BLBL182
	align 04h
@BLBL183:
	cmp	eax,01h
	je	@BLBL184
	cmp	eax,02h
	je	@BLBL186
	cmp	eax,03h
	je	@BLBL187
	jmp	@BLBL185
	align 04h
@BLBL182:

; 675       }
; 676     CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-02h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 677 
; 678     if ((pstFIFOinfo->wFIFOflags & FIFO_FLG_TYPE_16750) &&
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+04h],02h
	je	@BLBL171

; 679        ((pstFIFOinfo->wFIFOflags & FIFO_FLG_LOW_16750_TRIG) == 0))
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+05h],080h
	jne	@BLBL171

; 680       {
; 681       switch ((byFlags & F3_14_CHARACTER_FIFO) >> 5)
	xor	eax,eax
	mov	al,[ebp+0ch];	byFlags
	and	eax,060h
	sar	eax,05h
	jmp	@BLBL189
	align 04h
@BLBL190:

; 682         {
; 683         case 0:
; 684           idEntryField = HWF_1TRIG;
	mov	word ptr [ebp-02h],01abh;	idEntryField

; 685           break;
	jmp	@BLBL188
	align 04h
@BLBL191:

; 686         case 1:
; 687           idEntryField = HWF_16TRIG;
	mov	word ptr [ebp-02h],02d6h;	idEntryField

; 688           break;
	jmp	@BLBL188
	align 04h
@BLBL192:
@BLBL193:

; 689         default:
; 690         case 2:
; 691           idEntryField = HWF_32TRIG;
	mov	word ptr [ebp-02h],02dfh;	idEntryField

; 692           break;
	jmp	@BLBL188
	align 04h
@BLBL194:

; 693         case 3:
; 694           idEntryField = HWF_56TRIG;
	mov	word ptr [ebp-02h],02e0h;	idEntryField

; 695           break;
	jmp	@BLBL188
	align 04h
	jmp	@BLBL188
	align 04h
@BLBL189:
	test	eax,eax
	je	@BLBL190
	cmp	eax,01h
	je	@BLBL191
	cmp	eax,02h
	je	@BLBL193
	cmp	eax,03h
	je	@BLBL194
	jmp	@BLBL192
	align 04h
@BLBL188:

; 696         }
; 697       }
	jmp	@BLBL172
	align 010h
@BLBL171:

; 698     else
; 699       {
; 700       switch ((byFlags & F3_14_CHARACTER_FIFO) >> 5)
	xor	eax,eax
	mov	al,[ebp+0ch];	byFlags
	and	eax,060h
	sar	eax,05h
	jmp	@BLBL196
	align 04h
@BLBL197:

; 701         {
; 702         case 0:
; 703           idEntryField = HWF_1TRIG;
	mov	word ptr [ebp-02h],01abh;	idEntryField

; 704           break;
	jmp	@BLBL195
	align 04h
@BLBL198:

; 705         case 1:
; 706           idEntryField = HWF_4TRIG;
	mov	word ptr [ebp-02h],01aah;	idEntryField

; 707           break;
	jmp	@BLBL195
	align 04h
@BLBL199:
@BLBL200:

; 708         default:
; 709         case 2:
; 710           idEntryField = HWF_8TRIG;
	mov	word ptr [ebp-02h],01a9h;	idEntryField

; 711           break;
	jmp	@BLBL195
	align 04h
@BLBL201:

; 712         case 3:
; 713           idEntryField = HWF_14TRIG;
	mov	word ptr [ebp-02h],01a8h;	idEntryField

; 714           break;
	jmp	@BLBL195
	align 04h
	jmp	@BLBL195
	align 04h
@BLBL196:
	test	eax,eax
	je	@BLBL197
	cmp	eax,01h
	je	@BLBL198
	cmp	eax,02h
	je	@BLBL200
	cmp	eax,03h
	je	@BLBL201
	jmp	@BLBL199
	align 04h
@BLBL195:

; 715         }
; 716       }
@BLBL172:

; 717     CheckButton(hwnd,idEntryField,TRUE);
	push	01h
	mov	ax,[ebp-02h];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 718 
; 719     if (pstFIFOinfo->wFIFOflags & (FIFO_FLG_TYPE_16750 | FIFO_FLG_TYPE_16654))
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+04h],06h
	je	@BLBL173

; 720       usMaxFIFOload = 64;
	mov	word ptr [ebp-04h],040h;	usMaxFIFOload
	jmp	@BLBL174
	align 010h
@BLBL173:

; 721     else
; 722       if (pstFIFOinfo->wFIFOflags & FIFO_FLG_TYPE_16650)
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+04h],01h
	je	@BLBL175

; 723         usMaxFIFOload = 32;
	mov	word ptr [ebp-04h],020h;	usMaxFIFOload
	jmp	@BLBL174
	align 010h
@BLBL175:

; 724       else
; 725         usMaxFIFOload = 16;
	mov	word ptr [ebp-04h],010h;	usMaxFIFOload
@BLBL174:

; 726     if ((byFlags & F3_USE_TX_BUFFER) == 0)
	test	byte ptr [ebp+0ch],080h;	byFlags
	jne	@BLBL177

; 727       usCurrentFIFOload = 1;
	mov	word ptr [ebp-06h],01h;	usCurrentFIFOload
	jmp	@BLBL178
	align 010h
@BLBL177:

; 728     else
; 729       usCurrentFIFOload = pstFIFOinfo->wTxFIFOload;
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	ax,[eax+02h]
	mov	[ebp-06h],ax;	usCurrentFIFOload
@BLBL178:

; 730 
; 731     WinSendDlgItemMsg(hwnd,HWF_TXFIFO_LOAD,
	push	01h
	xor	eax,eax
	mov	ax,[ebp-04h];	usMaxFIFOload
	push	eax
	push	0207h
	push	02e4h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 732                               SPBM_SETLIMITS,
; 733                       (MPARAM)usMaxFIFOload,
; 734                       (MPARAM)1);
; 735 
; 736     if (usCurrentFIFOload > usMaxFIFOload)
	mov	ax,[ebp-04h];	usMaxFIFOload
	cmp	[ebp-06h],ax;	usCurrentFIFOload
	jbe	@BLBL179

; 737       usCurrentFIFOload = usMaxFIFOload;
	mov	ax,[ebp-04h];	usMaxFIFOload
	mov	[ebp-06h],ax;	usCurrentFIFOload
@BLBL179:

; 738     WinSendDlgItemMsg(hwnd,HWF_TXFIFO_LOAD,
	push	0h
	xor	eax,eax
	mov	ax,[ebp-06h];	usCurrentFIFOload
	push	eax
	push	0208h
	push	02e4h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 739                               SPBM_SETCURRENTVALUE,
; 740                       (MPARAM)usCurrentFIFOload,
; 741                               NULL);
; 742     }
@BLBL170:

; 743   if ((byFlags & F3_HDW_BUFFER_ENABLE) != F3_HDW_BUFFER_ENABLE)
	mov	al,[ebp+0ch];	byFlags
	and	al,010h
	cmp	al,010h
	je	@BLBL180

; 744     {
; 745     ControlEnable(hwnd,HWF_1TRIG,FALSE);
	push	0h
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 746     ControlEnable(hwnd,HWF_4TRIG,FALSE);
	push	0h
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 747     ControlEnable(hwnd,HWF_8TRIG,FALSE);
	push	0h
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 748     ControlEnable(hwnd,HWF_14TRIG,FALSE);
	push	0h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 749 //    ControlEnable(hwnd,HWF_TXLOADT,FALSE);
; 750     ControlEnable(hwnd,HWF_TXLOADTT,FALSE);
	push	0h
	push	02e5h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 751     ControlEnable(hwnd,HWF_TXFIFO_LOAD,FALSE);
	push	0h
	push	02e4h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 752     if (usMaxFIFOload == 64)
	cmp	word ptr [ebp-04h],040h;	usMaxFIFOload
	jne	@BLBL180

; 753       {
; 754       ControlEnable(hwnd,HWF_32TRIG,FALSE);
	push	0h
	push	02dfh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 755       ControlEnable(hwnd,HWF_56TRIG,FALSE);
	push	0h
	push	02e0h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 756       }

; 757     }
@BLBL180:

; 758   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
FillHdwFIFOsetupDlg	endp

; 762   {
	align 010h

	public UnloadHdwFIFOsetupDlg
UnloadHdwFIFOsetupDlg	proc
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

; 765   pstComDCB->Flags3 &= ~F3_FIFO_MASK;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-040h],eax;	@CBE60
	mov	eax,[ebp-040h];	@CBE60
	xor	ecx,ecx
	mov	cl,[eax+06h]
	and	cl,07h
	mov	[eax+06h],cl

; 766   if (Checked(hwnd,HWF_DISABFIFO))
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL202

; 767     pstComDCB->Flags3 |= F3_HDW_BUFFER_DISABLE;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-03ch],eax;	@CBE59
	mov	eax,[ebp-03ch];	@CBE59
	mov	cl,[eax+06h]
	or	cl,08h
	mov	[eax+06h],cl
	jmp	@BLBL203
	align 010h
@BLBL202:

; 768   else
; 769     {
; 770     if (Checked(hwnd,HWF_ENABFIFO))
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL204

; 771       pstComDCB->Flags3 |= F3_HDW_BUFFER_ENABLE;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-038h],eax;	@CBE58
	mov	eax,[ebp-038h];	@CBE58
	mov	cl,[eax+06h]
	or	cl,010h
	mov	[eax+06h],cl
	jmp	@BLBL205
	align 010h
@BLBL204:

; 772     else
; 773       pstComDCB->Flags3 |= F3_HDW_BUFFER_APO;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-034h],eax;	@CBE57
	mov	eax,[ebp-034h];	@CBE57
	mov	cl,[eax+06h]
	or	cl,018h
	mov	[eax+06h],cl
@BLBL205:

; 774 
; 775     pstComDCB->Flags3 |= F3_USE_TX_BUFFER;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-030h],eax;	@CBE56
	mov	eax,[ebp-030h];	@CBE56
	mov	cl,[eax+06h]
	or	cl,080h
	mov	[eax+06h],cl

; 776     WinSendDlgItemMsg(hwnd,
	push	030000h
	lea	eax,[ebp-04h];	lTemp
	push	eax
	push	0205h
	push	02e4h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 777                       HWF_TXFIFO_LOAD,
; 778                       SPBM_QUERYVALUE,
; 779                       &lTemp,
; 780                       MPFROM2SHORT(0,SPBQ_DONOTUPDATE));
; 781 
; 782     pstFIFOinfo->wTxFIFOload = (USHORT)lTemp;
	mov	ecx,[ebp-04h];	lTemp
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	[eax+02h],cx

; 783 
; 784     if (pstFIFOinfo->wTxFIFOload == 1)
	mov	eax,[ebp+010h];	pstFIFOinfo
	cmp	word ptr [eax+02h],01h
	jne	@BLBL206

; 785       pstComDCB->Flags3 &= ~F3_USE_TX_BUFFER;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-02ch],eax;	@CBE55
	mov	eax,[ebp-02ch];	@CBE55
	xor	ecx,ecx
	mov	cl,[eax+06h]
	and	cl,07fh
	mov	[eax+06h],cl
@BLBL206:

; 786 
; 787     if (pstFIFOinfo->wFIFOflags & FIFO_FLG_TYPE_16750)
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+04h],02h
	je	@BLBL207

; 788       pstFIFOinfo->wFIFOflags |= FIFO_FLG_LOW_16750_TRIG;
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	[ebp-028h],eax;	@CBE54
	mov	eax,[ebp-028h];	@CBE54
	mov	cx,[eax+04h]
	or	cx,08000h
	mov	[eax+04h],cx
@BLBL207:

; 789     pstComDCB->Flags3 &= ~F3_14_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-024h],eax;	@CBE53
	mov	eax,[ebp-024h];	@CBE53
	xor	ecx,ecx
	mov	cl,[eax+06h]
	and	cl,09fh
	mov	[eax+06h],cl

; 790     if (!Checked(hwnd,HWF_1TRIG))
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL203

; 791       {
; 792       if (Checked(hwnd,HWF_4TRIG))
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL209

; 793         pstComDCB->Flags3 |= F3_4_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-020h],eax;	@CBE52
	mov	eax,[ebp-020h];	@CBE52
	mov	cl,[eax+06h]
	or	cl,020h
	mov	[eax+06h],cl
	jmp	@BLBL203
	align 010h
@BLBL209:

; 794       else
; 795         if (Checked(hwnd,HWF_8TRIG))
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL211

; 796           pstComDCB->Flags3 |= F3_8_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-01ch],eax;	@CBE51
	mov	eax,[ebp-01ch];	@CBE51
	mov	cl,[eax+06h]
	or	cl,040h
	mov	[eax+06h],cl
	jmp	@BLBL203
	align 010h
@BLBL211:

; 797         else
; 798           if (Checked(hwnd,HWF_14TRIG))
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL213

; 799             pstComDCB->Flags3 |= F3_14_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-018h],eax;	@CBE50
	mov	eax,[ebp-018h];	@CBE50
	mov	cl,[eax+06h]
	or	cl,060h
	mov	[eax+06h],cl
	jmp	@BLBL203
	align 010h
@BLBL213:

; 800           else
; 801             {
; 802             if (pstFIFOinfo->wFIFOflags & FIFO_FLG_TYPE_16750)
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+04h],02h
	je	@BLBL215

; 803               pstFIFOinfo->wFIFOflags &= ~FIFO_FLG_LOW_16750_TRIG;
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	[ebp-014h],eax;	@CBE49
	mov	eax,[ebp-014h];	@CBE49
	xor	ecx,ecx
	mov	cx,[eax+04h]
	and	ch,07fh
	mov	[eax+04h],cx
@BLBL215:

; 804             if (Checked(hwnd,HWF_56TRIG))
	push	02e0h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL216

; 805               pstComDCB->Flags3 |= F3_14_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-010h],eax;	@CBE48
	mov	eax,[ebp-010h];	@CBE48
	mov	cl,[eax+06h]
	or	cl,060h
	mov	[eax+06h],cl
	jmp	@BLBL203
	align 010h
@BLBL216:

; 806             else
; 807               if (Checked(hwnd,HWF_32TRIG))
	push	02dfh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL218

; 808                 pstComDCB->Flags3 |= F3_8_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-0ch],eax;	@CBE47
	mov	eax,[ebp-0ch];	@CBE47
	mov	cl,[eax+06h]
	or	cl,040h
	mov	[eax+06h],cl
	jmp	@BLBL203
	align 010h
@BLBL218:

; 809               else
; 810                 pstComDCB->Flags3 |= F3_4_CHARACTER_FIFO;
	mov	eax,[ebp+0ch];	pstComDCB
	mov	[ebp-08h],eax;	@CBE46
	mov	eax,[ebp-08h];	@CBE46
	mov	cl,[eax+06h]
	or	cl,020h
	mov	[eax+06h],cl

; 811             }

; 812       }

; 813     }
@BLBL203:

; 814   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
UnloadHdwFIFOsetupDlg	endp

; 818   {
	align 010h

	public TCHdwFIFOsetupDlg
TCHdwFIFOsetupDlg	proc
	push	ebp
	mov	ebp,esp

; 819   switch(idButton)
	xor	eax,eax
	mov	ax,[ebp+0ch];	idButton
	jmp	@BLBL236
	align 04h
@BLBL237:

; 820     {
; 821     case HWF_DISABFIFO:
; 822       if (!Checked(hwnd,HWF_DISABFIFO))
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL220

; 823         {
; 824         CheckButton(hwnd,HWF_1TRIG,TRUE);
	push	01h
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 825 //        CheckButton(hwnd,HWF_TX_MIN,TRUE);
; 826         CheckButton(hwnd,HWF_DISABFIFO,TRUE);
	push	01h
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 827         CheckButton(hwnd,HWF_APO,FALSE);
	push	0h
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 828         CheckButton(hwnd,HWF_ENABFIFO,FALSE);
	push	0h
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 829         ControlEnable(hwnd,HWF_1TRIG,FALSE);
	push	0h
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 830         ControlEn
; 830 able(hwnd,HWF_4TRIG,FALSE);
	push	0h
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 831         ControlEnable(hwnd,HWF_8TRIG,FALSE);
	push	0h
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 832         ControlEnable(hwnd,HWF_14TRIG,FALSE);
	push	0h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 833         if (pstFIFOinfo->wFIFOsize > 32)
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	ax,[eax]
	cmp	ax,020h
	jbe	@BLBL221

; 834           {
; 835           ControlEnable(hwnd,GB_64BYTEFIFOS,FALSE);
	push	0h
	push	015c8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 836           ControlEnable(hwnd,GB_16BYTEFIFOS,FALSE);
	push	0h
	push	015cah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 837           ControlEnable(hwnd,HWF_16TRIG,FALSE);
	push	0h
	push	02d6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 838           ControlEnable(hwnd,HWF_32TRIG,FALSE);
	push	0h
	push	02dfh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 839           ControlEnable(hwnd,HWF_56TRIG,FALSE);
	push	0h
	push	02e0h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 840           }
@BLBL221:

; 841 //        ControlEnable(hwnd,HWF_TXLOADT,FALSE);
; 842         ControlEnable(hwnd,HWF_TXLOADTT,FALSE);
	push	0h
	push	02e5h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 843         ControlEnable(hwnd,HWF_TXFIFO_LOAD,FALSE);
	push	0h
	push	02e4h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 844         }
@BLBL220:

; 845       break;
	jmp	@BLBL235
	align 04h
@BLBL238:

; 846     case HWF_APO:
; 847       if (!Checked(hwnd,HWF_APO))
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL222

; 848         {
; 849         if (Checked(hwnd,HWF_DISABFIFO))
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL223

; 850           {
; 851           if (pstFIFOinfo->wFIFOsize < 64)
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	ax,[eax]
	cmp	ax,040h
	jae	@BLBL224

; 852             CheckButton(hwnd,HWF_14TRIG,TRUE);
	push	01h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL225
	align 010h
@BLBL224:

; 853           else
; 854             CheckButton(hwnd,HWF_56TRIG,TRUE);
	push	01h
	push	02e0h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL225:

; 855 //          CheckButton(hwnd,HWF_TX_MAX,TRUE);
; 856           WinSendDlgItemMsg(hwnd,HWF_TXFIFO_LOAD,
	push	0h
	mov	ecx,[ebp+010h];	pstFIFOinfo
	xor	eax,eax
	mov	ax,[ecx+02h]
	push	eax
	push	0208h
	push	02e4h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 857                                     SPBM_SETCURRENTVALUE,
; 858                             (MPARAM)pstFIFOinfo->wTxFIFOload,
; 859                                     NULL);
; 860           }
@BLBL223:

; 861         CheckButton(hwnd,HWF_APO,TRUE);
	push	01h
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 862         CheckButton(hwnd,HWF_ENABFIFO,FALSE);
	push	0h
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 863         CheckButton(hwnd,HWF_DISABFIFO,FALSE);
	push	0h
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 864         ControlEnable(hwnd,HWF_1TRIG,TRUE);
	push	01h
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 865         ControlEnable(hwnd,HWF_4TRIG,TRUE);
	push	01h
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 866         ControlEnable(hwnd,HWF_8TRIG,TRUE);
	push	01h
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 867         ControlEnable(hwnd,HWF_14TRIG,TRUE);
	push	01h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 868         if (pstFIFOinfo->wFIFOsize > 32)
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	ax,[eax]
	cmp	ax,020h
	jbe	@BLBL226

; 869           {
; 870           ControlEnable(hwnd,GB_64BYTEFIFOS,TRUE);
	push	01h
	push	015c8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 871           ControlEnable(hwnd,GB_16BYTEFIFOS,TRUE);
	push	01h
	push	015cah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 872           ControlEnable(hwnd,HWF_16TRIG,TRUE);
	push	01h
	push	02d6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 873           ControlEnable(hwnd,HWF_32TRIG,TRUE);
	push	01h
	push	02dfh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 874           ControlEnable(hwnd,HWF_56TRIG,TRUE);
	push	01h
	push	02e0h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 875           }
@BLBL226:

; 876 //        ControlEnable(hwnd,HWF_TXLOADT,TRUE);
; 877         ControlEnable(hwnd,HWF_TXLOADTT,TRUE);
	push	01h
	push	02e5h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 878         ControlEnable(hwnd,HWF_TXFIFO_LOAD,TRUE);
	push	01h
	push	02e4h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 879         }
@BLBL222:

; 880       break;
	jmp	@BLBL235
	align 04h
@BLBL239:

; 881     case HWF_ENABFIFO:
; 882       if (!Checked(hwnd,HWF_ENABFIFO))
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL227

; 883         {
; 884         if (Checked(hwnd,HWF_DISABFIFO))
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL228

; 885           {
; 886           if (pstFIFOinfo->wFIFOsize < 64)
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	ax,[eax]
	cmp	ax,040h
	jae	@BLBL229

; 887             CheckButton(hwnd,HWF_14TRIG,TRUE);
	push	01h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL230
	align 010h
@BLBL229:

; 888           else
; 889             CheckButton(hwnd,HWF_56TRIG,TRUE);
	push	01h
	push	02e0h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL230:

; 890 //          CheckButton(hwnd,HWF_TX_MAX,TRUE);
; 891           WinSendDlgItemMsg(hwnd,HWF_TXFIFO_LOAD,
	push	0h
	mov	ecx,[ebp+010h];	pstFIFOinfo
	xor	eax,eax
	mov	ax,[ecx+02h]
	push	eax
	push	0208h
	push	02e4h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 892                                     SPBM_SETCURRENTVALUE,
; 893                             (MPARAM)pstFIFOinfo->wTxFIFOload,
; 894                                     NULL);
; 895           }
@BLBL228:

; 896         CheckButton(hwnd,HWF_ENABFIFO,TRUE);
	push	01h
	push	01a6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 897         CheckButton(hwnd,HWF_APO,FALSE);
	push	0h
	push	01a5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 898         CheckButton(hwnd,HWF_DISABFIFO,FALSE);
	push	0h
	push	01a7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 899         ControlEnable(hwnd,HWF_1TRIG,TRUE);
	push	01h
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 900         ControlEnable(hwnd,HWF_4TRIG,TRUE);
	push	01h
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 901         ControlEnable(hwnd,HWF_8TRIG,TRUE);
	push	01h
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 902         ControlEnable(hwnd,HWF_14TRIG,TRUE);
	push	01h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 903         if (pstFIFOinfo->wFIFOsize > 32)
	mov	eax,[ebp+010h];	pstFIFOinfo
	mov	ax,[eax]
	cmp	ax,020h
	jbe	@BLBL231

; 904           {
; 905           ControlEnable(hwnd,GB_64BYTEFIFOS,TRUE);
	push	01h
	push	015c8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 906           ControlEnable(hwnd,GB_16BYTEFIFOS,TRUE);
	push	01h
	push	015cah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 907           ControlEnable(hwnd,HWF_16TRIG,TRUE);
	push	01h
	push	02d6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 908           ControlEnable(hwnd,HWF_32TRIG,TRUE);
	push	01h
	push	02dfh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 909           ControlEnable(hwnd,HWF_56TRIG,TRUE);
	push	01h
	push	02e0h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 910           }
@BLBL231:

; 911 //        ControlEnable(hwnd,HWF_TXLOADT,TRUE);
; 912         ControlEnable(hwnd,HWF_TXLOADTT,TRUE);
	push	01h
	push	02e5h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 913         ControlEnable(hwnd,HWF_TXFIFO_LOAD,TRUE);
	push	01h
	push	02e4h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 914         }
@BLBL227:

; 915       break;
	jmp	@BLBL235
	align 04h
@BLBL240:

; 916     case HWF_1TRIG:
; 917       if ((pstFIFOinfo->wFIFOflags & FIFO_FLG_TYPE_16750) == 0)
	mov	eax,[ebp+010h];	pstFIFOinfo
	test	byte ptr [eax+04h],02h
	jne	@BLBL232

; 918         break;
	jmp	@BLBL235
	align 04h
@BLBL232:

; 919       if (Checked(hwnd,HWF_1TRIG))
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL233

; 920         {
; 921         CheckButton(hwnd,HWF_1TRIG,FALSE);
	push	0h
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 922         ControlEnable(hwnd,HWF_4TRIG,TRUE);
	push	01h
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 923         ControlEnable(hwnd,HWF_8TRIG,TRUE);
	push	01h
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 924         ControlEnable(hwnd,HWF_14TRIG,TRUE);
	push	01h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 925         ControlEnable(hwnd,GB_64BYTEFIFOS,TRUE);
	push	01h
	push	015c8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 926         ControlEnable(hwnd,GB_16BYTEFIFOS,TRUE);
	push	01h
	push	015cah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 927         ControlEnable(hwnd,HWF_16TRIG,TRUE);
	push	01h
	push	02d6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 928         ControlEnable(hwnd,HWF_32TRIG,TRUE);
	push	01h
	push	02dfh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 929         ControlEnable(hwnd,HWF_56TRIG,TRUE);
	push	01h
	push	02e0h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 930         }
	jmp	@BLBL234
	align 010h
@BLBL233:

; 931       else
; 932         {
; 933         CheckButton(hwnd,HWF_1TRIG,TRUE);
	push	01h
	push	01abh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 934         ControlEnable(hwnd,HWF_4TRIG,FALSE);
	push	0h
	push	01aah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 935         ControlEnable(hwnd,HWF_8TRIG,FALSE);
	push	0h
	push	01a9h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 936         ControlEnable(hwnd,HWF_14TRIG,FALSE);
	push	0h
	push	01a8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 937         ControlEnable(hwnd,GB_64BYTEFIFOS,FALSE);
	push	0h
	push	015c8h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 938         ControlEnable(hwnd,GB_16BYTEFIFOS,FALSE);
	push	0h
	push	015cah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 939         ControlEnable(hwnd,HWF_16TRIG,FALSE);
	push	0h
	push	02d6h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 940         ControlEnable(hwnd,HWF_32TRIG,FALSE);
	push	0h
	push	02dfh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 941         ControlEnable(hwnd,HWF_56TRIG,FALSE);
	push	0h
	push	02e0h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 942         }
@BLBL234:

; 943       break;
	jmp	@BLBL235
	align 04h
@BLBL241:

; 944     default:
; 945       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL235
	align 04h
@BLBL236:
	cmp	eax,01a7h
	je	@BLBL237
	cmp	eax,01a5h
	je	@BLBL238
	cmp	eax,01a6h
	je	@BLBL239
	cmp	eax,01abh
	je	@BLBL240
	jmp	@BLBL241
	align 04h
@BLBL235:

; 946     }
; 947   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
TCHdwFIFOsetupDlg	endp
CODE32	ends
end
