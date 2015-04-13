	title	p:\COMscope\dialog.c
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
	extrn	ControlEnable:proc
	extrn	WinSetFocus:proc
	extrn	memcpy:proc
	extrn	_sprintfieee:proc
	extrn	WinSendDlgItemMsg:proc
	extrn	WinSetDlgItemText:proc
	extrn	CheckButton:proc
	extrn	Checked:proc
	extrn	COMscopeOpenFilterProc:proc
	extrn	GetFileName:proc
	extrn	strcmp:proc
	extrn	DosLoadModule:proc
	extrn	DosQueryProcAddr:proc
	extrn	DosFreeModule:proc
	extrn	strcpy:proc
	extrn	IncrementFileExt:proc
	extrn	WriteCaptureFile:proc
	extrn	GetLongIntDlgItem:proc
	extrn	DosFreeMem:proc
	extrn	DosAllocMem:proc
	extrn	MenuItemCheck:proc
	extrn	MenuItemEnable:proc
	extrn	DisplayHelpPanel:proc
	extrn	WinDefDlgProc:proc
	extrn	WinDismissDlg:proc
	extrn	GetBaudRate:proc
	extrn	CalcThreadSleepCount:proc
	extrn	WinPostMsg:proc
	extrn	WinQueryDlgItemText:proc
	extrn	atoi:proc
	extrn	DosPostEventSem:proc
	extrn	ASCIItoBin:proc
	extrn	AdjustScrollBar:proc
	extrn	GetModemOutputSignals:proc
	extrn	TestOUT1:proc
	extrn	GetDCB:proc
	extrn	SetModemSignals:proc
	extrn	WinWindowFromID:proc
	extrn	WinSetPresParam:proc
	extrn	SetupRowScrolling:proc
	extrn	WinInvalidateRect:proc
	extrn	EnableCOMscope:proc
	extrn	_itoa:proc
	extrn	_fullDump:dword
	extrn	hwndClient:dword
	extrn	szCaptureFileSpec:byte
	extrn	hProfileInstance:dword
	extrn	szEntryCaptureFileSpec:byte
	extrn	pfnSaveProfileString:dword
	extrn	szCaptureFileName:byte
	extrn	pwCaptureBuffer:dword
	extrn	hwndFrame:dword
	extrn	lWriteIndex:dword
	extrn	stRow:byte
	extrn	bBufferWrapped:dword
	extrn	hCom:dword
	extrn	stIOctl:byte
	extrn	ulCOMscopeBufferSize:dword
	extrn	ulCalcSleepCount:dword
	extrn	ulMonitorSleepCount:dword
	extrn	hevWaitCOMiDataSem:dword
	extrn	stCFG:byte
	extrn	hwndStatus:dword
	extrn	bCOMscopeEnabled:dword
DATA32	segment
@STAT1	db "%-ld",0h
	align 04h
@STAT2	db "%ld",0h
@STAT3	db "%lu",0h
@STAT4	db "%-lu",0h
	align 04h
@STAT5	db "%-lu",0h
	align 04h
@STAT6	db "%-lu",0h
	align 04h
@STAT7	db "Select file to capture t"
db "o.",0h
	align 04h
@STAT8	db "PROFDEB",0h
@STAT9	db "SaveProfileString",0h
	align 04h
@STATa	db "Capture File",0h
	align 04h
@STATb	db "Device Driver Trace Buff"
db "er Size = %d bytes",0h
	align 04h
@STATc	db "Calculated Update Freque"
db "ncy = %ld milliseconds",0h
	align 04h
@STATd	db "Recommend increasing",0h
	align 04h
@STATe	db "device driver trace buff"
db "er size!",0h
	align 04h
@STATf	db "%ld",0h
@STAT10	db "%02X",0h
	align 04h
@STAT11	db "%02X",0h
	align 04h
@STAT12	db "Deactivate DTR",0h
	align 04h
@STAT13	db "Activate DTR",0h
	align 04h
@STAT14	db "DTR input handshaking",0h
	align 04h
@STAT15	db "Invalid parameter",0h
	align 04h
@STAT16	db "Enable",0h
	align 04h
@STAT17	db "Disable",0h
@STAT18	db "Enable",0h
	align 04h
@STAT19	db "Disable",0h
@STAT1a	db "Enable",0h
	align 04h
@STAT1b	db "Disable",0h
@STAT1c	db "Enable",0h
	align 04h
@STAT1d	db "Disable",0h
@STAT1e	db "Deactivate RTS",0h
	align 04h
@STAT1f	db "Activate RTS",0h
	align 04h
@STAT20	db "RTS input handshaking",0h
	align 04h
@STAT21	db "RTS toggling on tramsmit"
db 0h
	align 04h
@STAT22	db "Enable",0h
	align 04h
@STAT23	db "Disable",0h
@STAT24	db "'\x%02X' )",0h
	align 04h
@STAT25	db "Enable",0h
	align 04h
@STAT26	db "Disable",0h
@STAT27	db "'\x%02X' )",0h
	align 04h
@STAT28	db "Enable",0h
	align 04h
@STAT29	db "Disable",0h
@STAT2a	db "Enable",0h
	align 04h
@STAT2b	db "Disable",0h
@STAT2c	db "( full duplex )",0h
@STAT2d	db "( half duplex )",0h
@STAT2e	db "Enable",0h
	align 04h
@STAT2f	db "Disable",0h
@STAT30	db "'\x%02X'",0h
	align 04h
@STAT31	db "'\x%02X'",0h
	align 04h
@STAT32	db "Disable FIFOs",0h
	align 04h
@STAT33	db "Enable FIFOs",0h
	align 04h
@STAT34	db "Automatic Protocol Overr"
db "ide",0h
@STAT35	db "Low receive FIFO thresho"
db "ld",0h
	align 04h
@STAT36	db "Medium-low receive FIFO "
db "threshold",0h
	align 04h
@STAT37	db "Medium-high receive FIFO"
db " threshold",0h
	align 04h
@STAT38	db "High receive FIFO thresh"
db "old",0h
@STAT39	db "Enable transmit FIFO",0h
	align 04h
@STAT3a	db "Disable transmit FIFO",0h
	align 04h
@STAT3b	db "FIFOs unavailable or no "
db "change to FIFO processin"
db "g",0h
	align 04h
@STAT3c	db "Infinite",0h
	align 04h
@STAT3d	db "Normal",0h
	align 04h
@STAT3e	db "Normal",0h
	align 04h
@STAT3f	db "No wait",0h
@STAT40	db "Wait for something",0h
	align 04h
@STAT41	db "Invalid",0h
@2astBackgrndContrastTable	db 02h,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0c7h,014h
	db 0ah,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0c7h,014h
	db 04h,0h,0h,0h
	db 0ffh,0ffh,0ffh,0ffh
	db 0c8h,014h
	db 0ch,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0c7h,014h
	db 03h,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0c7h,014h
	db 0bh,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0c7h,014h
	db 01h,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0c7h,014h
	db 09h,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0c7h,014h
	db 06h,0h,0h,0h
	db 0ffh,0ffh,0ffh,0ffh
	db 0c8h,014h
	db 0eh,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0c7h,014h
	db 0fh,0h,0h,0h
	db 0ffh,0ffh,0ffh,0ffh
	db 0c8h,014h
	db 08h,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0c7h,014h
	db 0feh,0ffh,0ffh,0ffh
	db 0ffh,0ffh,0ffh,0ffh
	db 0c8h,014h
	db 0ffh,0ffh,0ffh,0ffh
	db 0feh,0ffh,0ffh,0ffh
	db 0c7h,014h
	db 05h,0h,0h,0h
	db 0ffh,0ffh,0ffh,0ffh
	db 0c8h,014h
	db 0dh,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0c7h,014h
@6astForegrndContrastTable	db 02h,0h,0h,0h
	db 0ffh,0ffh,0ffh,0ffh
	db 0b7h,014h
	db 0ah,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0b6h,014h
	db 04h,0h,0h,0h
	db 0ffh,0ffh,0ffh,0ffh
	db 0b7h,014h
	db 0ch,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0b6h,014h
	db 03h,0h,0h,0h
	db 0ffh,0ffh,0ffh,0ffh
	db 0b7h,014h
	db 0bh,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0b6h,014h
	db 01h,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0b6h,014h
	db 09h,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0b6h,014h
	db 06h,0h,0h,0h
	db 0ffh,0ffh,0ffh,0ffh
	db 0b7h,014h
	db 0eh,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0b6h,014h
	db 0fh,0h,0h,0h
	db 0ffh,0ffh,0ffh,0ffh
	db 0b7h,014h
	db 08h,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0b6h,014h
	db 0feh,0ffh,0ffh,0ffh
	db 0ffh,0ffh,0ffh,0ffh
	db 0b7h,014h
	db 0ffh,0ffh,0ffh,0ffh
	db 0feh,0ffh,0ffh,0ffh
	db 0b6h,014h
	db 05h,0h,0h,0h
	db 0ffh,0ffh,0ffh,0ffh
	db 0b7h,014h
	db 0dh,0h,0h,0h
	db 0feh,0ffh,0ffh,0ffh
	db 0b6h,014h
DATA32	ends
BSS32	segment
@20pstCFG	dd 0h
@21stCFGtemp	db 0e3h DUP (0h)
	align 04h
@59ulFrequency	dd 0h
@5apstCFG	dd 0h
@5bbAllowClick	dd 0h
@72bAllowClick	dd 0h
@73pstScreen	dd 0h
@74stScreen	db 07fh DUP (0h)
	align 04h
@8abAllowClick	dd 0h
@8bpstCFG	dd 0h
@99bNoOUT1	dd 0h
@9abNoRTS	dd 0h
@9bbNoDTR	dd 0h
@a8pstColor	dd 0h
@a9lBackgrndColor	dd 0h
@aalForegrndColor	dd 0h
@abbAllowClick	dd 0h
@adhwndSample	dd 0h
@c7pstCFG	dd 0h
@ddpstCFG	dd 0h
@e6pstDCB	dd 0h
BSS32	ends
CODE32	segment

; 106   {
	align 010h

	public FindContrastingColor
FindContrastingColor	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 109   for (iIndex = 0;iIndex < 16;iIndex++)
	mov	dword ptr [ebp-04h],0h;	iIndex
	cmp	dword ptr [ebp-04h],010h;	iIndex
	jge	@BLBL1
	align 010h
@BLBL2:

; 110     {
; 111     if (astBackgrndContrastTable[iIndex].lColor == *plColor)
	mov	eax,[ebp-04h];	iIndex
	imul	eax,0ah
	mov	ecx,[ebp+0ch];	plColor
	mov	ecx,[ecx]
	cmp	dword ptr [eax+ @2astBackgrndContrastTable],ecx
	jne	@BLBL3

; 112       {
; 113       *plColor = astContrastTable[iIndex].lContrastColor;
	mov	ecx,[ebp+08h];	astContrastTable
	mov	eax,[ebp-04h];	iIndex
	imul	eax,0ah
	mov	ecx,dword ptr [ecx+eax+04h]
	mov	eax,[ebp+0ch];	plColor
	mov	[eax],ecx

; 114       return(astContrastTable[iIndex].usContrastID);
	mov	eax,[ebp+08h];	astContrastTable
	mov	ecx,[ebp-04h];	iIndex
	imul	ecx,0ah
	mov	ax,word ptr [eax+ecx+08h]
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL3:

; 115       }
; 116     }

; 109   for (iIndex = 0;iIndex < 16;iIndex++)
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	cmp	dword ptr [ebp-04h],010h;	iIndex
	jl	@BLBL2
@BLBL1:

; 117   return(0);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
FindContrastingColor	endp

; 121   {
	align 010h

	public EnableFilters
EnableFilters	proc
	push	ebp
	mov	ebp,esp

; 122   ControlEnable(hwndDlg,DISP_PUNCT,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	0177eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 123   ControlEnable(hwndDlg,DISP_ALPHA,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	0177ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 124   ControlEnable(hwndDlg,DISP_NUMS,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	0177dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 125   ControlEnable(hwndDlg,DISP_NPRINT,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	0177fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 126   ControlEnable(hwndDlg,DISP_FILTERT,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	01780h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 127   ControlEnable(hwndDlg,DISP_CHAR_MASK,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	01774h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 128   ControlEnable(hwndDlg,DISP_CHAR_MASKT,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	01771h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 129   ControlEnable(hwndDlg,DISP_CHAR_MASKTTT,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	01772h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 130   ControlEnable(hwndDlg,DISP_CHAR_MASKTT,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	01773h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 131   }
	mov	esp,ebp
	pop	ebp
	ret	
EnableFilters	endp

; 134   {
	align 010h

	public EnableNewLine
EnableNewLine	proc
	push	ebp
	mov	ebp,esp

; 135   ControlEnable(hwndDlg,DISP_SKP,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	01779h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 136   ControlEnable(hwndDlg,DISP_NLT,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	01778h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 137   ControlEnable(hwndDlg,DISP_NLTT,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	01776h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 138   ControlEnable(hwndDlg,DISP_NLTTT,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	01775h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 139   ControlEnable(hwndDlg,DISP_NL_CHAR,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	01777h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 140   ControlEnable(hwndDlg,DISP_WRAP,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	01781h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 141   ControlEnable(hwndDlg,DISP_SYNC,bEnable);
	push	dword ptr [ebp+0ch];	bEnable
	push	01783h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 142   }
	mov	esp,ebp
	pop	ebp
	ret	
EnableNewLine	endp

; 145   {
	align 010h

	public fnwpBufferSizeDlg
fnwpBufferSizeDlg	proc
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

; 153   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL31
	align 04h
@BLBL32:

; 154     {
; 155     case WM_INITDLG:
; 156 //      CenterDlgBox(hwnd);
; 157       WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h

; 158       pstCFG = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @20pstCFG,eax

; 159       memcpy(&stCFGtemp,pstCFG,sizeof(CSCFG));
	mov	ecx,0e3h
	mov	edx,dword ptr  @20pstCFG
	mov	eax,offset FLAT:@21stCFGtemp
	call	memcpy

; 160       for (lLength = MIN_CAP_BUFF_LEN;lLength <= MAX_CAP_BUFF_LEN;lLength *= 2)
	mov	dword ptr [ebp-04h],0800h;	lLength
	cmp	dword ptr [ebp-04h],0100000h;	lLength
	jg	@BLBL5
	align 010h
@BLBL6:

; 161         {
; 162         sprintf(szString,"%-ld",lLength);
	push	dword ptr [ebp-04h];	lLength
	mov	edx,offset FLAT:@STAT1
	lea	eax,[ebp-018h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 163         WinSendDlgItemMsg(hwnd,BSZ_LENGTH,LM_INSERTITEM,MPFROM2SHORT(LIT_END,0),MPFROMP(szString));
	lea	eax,[ebp-018h];	szString
	push	eax
	push	0ffffh
	push	0161h
	push	0259h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 164         }

; 160       for (lLength = MIN_CAP_BUFF_LEN;lLength <= MAX_CAP_BUFF_LEN;lLength *= 2)
	mov	eax,[ebp-04h];	lLength
	add	eax,eax
	mov	[ebp-04h],eax;	lLength
	cmp	dword ptr [ebp-04h],0100000h;	lLength
	jle	@BLBL6
@BLBL5:

; 165       sprintf(szString,"%ld",MIN_CAP_BUFF_LEN);
	push	0800h
	mov	edx,offset FLAT:@STAT2
	lea	eax,[ebp-018h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 166       WinSendDlgItemMsg(hwnd,BSZ_MINLEN,LM_INSERTITEM,MPFROM2SHORT(LIT_END,0),MPFROMP(szString));
	lea	eax,[ebp-018h];	szString
	push	eax
	push	0ffffh
	push	0161h
	push	025bh
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 167       sprintf(szString,"%lu",MAX_CAP_BUFF_LEN);
	push	0100000h
	mov	edx,offset FLAT:@STAT3
	lea	eax,[ebp-018h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 168       WinSendDlgItemMsg(hwnd,BSZ_MAXLEN,LM_INSERTITEM,MPFROM2SHORT(LIT_END,0),MPFROMP(szString));
	lea	eax,[ebp-018h];	szString
	push	eax
	push	0ffffh
	push	0161h
	push	025ch
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 169       WinSendDlgItemMsg(hwnd,BSZ_LENGTH,EM_SETTEXTLIMIT,MPFROMSHORT(12),(MPARAM)NULL);
	push	0h
	push	0ch
	push	0143h
	push	0259h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 170       sprintf(szString,"%-lu",stCFGtemp.lBufferLength);
	push	dword ptr  @21stCFGtemp+0d5h
	mov	edx,offset FLAT:@STAT4
	lea	eax,[ebp-018h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 171       WinSetDlgItemText(hwnd,BSZ_LENGTH,szString);
	lea	eax,[ebp-018h];	szString
	push	eax
	push	0259h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 172       sprintf(szString,"%-lu",MIN_CAP_BUFF_LEN);
	push	0800h
	mov	edx,offset FLAT:@STAT5
	lea	eax,[ebp-018h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 173       WinSetDlgItemText(hwnd,BSZ_MINLEN,szString);
	lea	eax,[ebp-018h];	szString
	push	eax
	push	025bh
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 174       sprintf(szString,"%-lu",MAX_CAP_BUFF_LEN);
	push	0100000h
	mov	edx,offset FLAT:@STAT6
	lea	eax,[ebp-018h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 175       WinSetDlgItemText(hwnd,BSZ_MAXLEN,szString);
	lea	eax,[ebp-018h];	szString
	push	eax
	push	025ch
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 176       if (pstCFG->bMonitoringStream)
	mov	eax,dword ptr  @20pstCFG
	test	byte ptr [eax+017h],020h
	je	@BLBL8

; 178         ControlEnable(hwnd,BSZ_LENGTH,FALSE);
	push	0h
	push	0259h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 179         ControlEnable(hwnd,BSZ_LENGTHT,FALSE);
	push	0h
	push	025ah
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 180         }
@BLBL8:

; 181       if (stCFGtemp.bCaptureToFile)
	test	byte ptr  @21stCFGtemp+016h,020h
	je	@BLBL9

; 182         CheckButton(hwnd,BSZ_FILE,TRUE);
	push	01h
	push	025fh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL10
	align 010h
@BLBL9:

; 184         if (stCFGtemp.bOverWriteBuffer)
	test	byte ptr  @21stCFGtemp+018h,02h
	je	@BLBL11

; 185           CheckButton(hwnd,BSZ_WRAP,TRUE);
	push	01h
	push	025dh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL10
	align 010h
@BLBL11:

; 187           CheckButton(hwnd,BSZ_STOP,TRUE);
	push	01h
	push	025eh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL10:

; 188       break;
	jmp	@BLBL30
	align 04h
@BLBL33:

; 190       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL35
	align 04h
@BLBL36:

; 193           if (Checked(hwnd,BSZ_FILE))
	push	025fh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL13

; 195             if (!stCFGtemp.bMonitoringStream || (stCFGtemp.bMonitoringStream && !stCFGtemp.bCaptureToFile))
	test	byte ptr  @21stCFGtemp+017h,020h
	je	@BLBL14
	test	byte ptr  @21stCFGtemp+017h,020h
	je	@BLBL15
	test	byte ptr  @21stCFGtemp+016h,020h
	jne	@BLBL15
@BLBL14:

; 197               if (!GetFileName(hwndClient,szCaptureFileSpec,"Select file to capture to.",COMscopeOpenFilterProc))
	push	offset FLAT: COMscopeOpenFilterProc
	push	offset FLAT:@STAT7
	push	offset FLAT:szCaptureFileSpec
	push	dword ptr  hwndClient
	call	GetFileName
	add	esp,010h
	test	eax,eax
	jne	@BLBL16

; 198                 return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL16:

; 199               if ((hProfileInstance != NULL) && (strcmp(szEntryCaptureFileSpec,szCaptureFileSpec) != 0))
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL17
	mov	edx,offset FLAT:szCaptureFileSpec
	mov	eax,offset FLAT:szEntryCaptureFileSpec
	call	strcmp
	test	eax,eax
	je	@BLBL17

; 200                 if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-01ch];	hMod
	push	eax
	push	offset FLAT:@STAT8
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL17

; 202                   if (DosQueryProcAddr(hMod,0,"SaveProfileSt
; 202 ring",(PFN *)&pfnSaveProfileString) == NO_ERROR)
	push	offset FLAT:pfnSaveProfileString
	push	offset FLAT:@STAT9
	push	0h
	push	dword ptr [ebp-01ch];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL19

; 203                     pfnSaveProfileString(hProfileInstance,"Capture File",szCaptureFileSpec);
	push	offset FLAT:szCaptureFileSpec
	push	offset FLAT:@STATa
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnSaveProfileString
	add	esp,0ch
@BLBL19:

; 204                   DosFreeModule(hMod);
	push	dword ptr [ebp-01ch];	hMod
	call	DosFreeModule
	add	esp,04h

; 205                   }
@BLBL17:

; 206               strcpy(szCaptureFileName,szCaptureFileSpec);
	mov	edx,offset FLAT:szCaptureFileSpec
	mov	eax,offset FLAT:szCaptureFileName
	call	strcpy

; 207               IncrementFileExt(szCaptureFileName,TRUE);
	push	01h
	push	offset FLAT:szCaptureFileName
	call	IncrementFileExt
	add	esp,08h

; 208               if (!WriteCaptureFile(szCaptureFileName,pwCaptureBuffer,0,FOPEN_NORMAL,HLPP_MB_OVERWRT_CAP_FILE))
	push	09ca9h
	push	0h
	push	0h
	push	dword ptr  pwCaptureBuffer
	push	offset FLAT:szCaptureFileName
	call	WriteCaptureFile
	add	esp,014h
	test	eax,eax
	jne	@BLBL15

; 209                 return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL15:

; 211             stCFGtemp.bCaptureToFile = TRUE;
	or	byte ptr  @21stCFGtemp+016h,020h

; 212             }
	jmp	@BLBL21
	align 010h
@BLBL13:

; 215             stCFGtemp.bCaptureToFile = FALSE;
	and	byte ptr  @21stCFGtemp+016h,0dfh

; 216             if (Checked(hwnd,BSZ_WRAP))
	push	025dh
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL22

; 217               stCFGtemp.bOverWriteBuffer = TRUE;
	or	byte ptr  @21stCFGtemp+018h,02h
	jmp	@BLBL21
	align 010h
@BLBL22:

; 219               stCFGtemp.bOverWriteBuffer = FALSE;
	and	byte ptr  @21stCFGtemp+018h,0fdh

; 220             }
@BLBL21:

; 221           if (!stCFGtemp.bMonitoringStream)
	test	byte ptr  @21stCFGtemp+017h,020h
	jne	@BLBL24

; 223             GetLongIntDlgItem(hwnd,BSZ_LENGTH,&lLength);
	lea	eax,[ebp-04h];	lLength
	push	eax
	push	0259h
	push	dword ptr [ebp+08h];	hwnd
	call	GetLongIntDlgItem
	add	esp,0ch

; 224             if (lLength != stCFGtemp.lBufferLength)
	mov	eax,dword ptr  @21stCFGtemp+0d5h
	cmp	[ebp-04h],eax;	lLength
	je	@BLBL24

; 226               if (lLength < MIN_CAP_BUFF_LEN)
	cmp	dword ptr [ebp-04h],0800h;	lLength
	jge	@BLBL26

; 227                 stCFGtemp.lBufferLength = MIN_CAP_BUFF_LEN;
	mov	dword ptr  @21stCFGtemp+0d5h,0800h
	jmp	@BLBL27
	align 010h
@BLBL26:

; 229                 if (lLength > MAX_CAP_BUFF_LEN)
	cmp	dword ptr [ebp-04h],0100000h;	lLength
	jle	@BLBL28

; 230                   stCFGtemp.lBufferLength = MAX_CAP_BUFF_LEN;
	mov	dword ptr  @21stCFGtemp+0d5h,0100000h
	jmp	@BLBL27
	align 010h
@BLBL28:

; 232                   stCFGtemp.lBufferLength = lLength;
	mov	eax,[ebp-04h];	lLength
	mov	dword ptr  @21stCFGtemp+0d5h,eax
@BLBL27:

; 233               DosFreeMem(pwCaptureBuffer);
	push	dword ptr  pwCaptureBuffer
	call	DosFreeMem
	add	esp,04h

; 234                 pwCaptureBuffer = NULL;
	mov	dword ptr  pwCaptureBuffer,0h

; 235               DosAllocMem((PPVOID)&pwCaptureBuffer,(stCFGtemp.lBufferLength * 2),PAG_COMMIT | PAG_READ | PAG_WRITE);
	push	013h
	mov	eax,dword ptr  @21stCFGtemp+0d5h
	add	eax,eax
	push	eax
	push	offset FLAT:pwCaptureBuffer
	call	DosAllocMem
	add	esp,0ch

; 236               MenuItemCheck(hwndFrame,IDM_VIEWDAT,FALSE);
	push	0h
	push	07d6h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 237               MenuItemEnable(hwndFrame,IDM_VIEWDAT,FALSE);
	push	0h
	push	07d6h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 238               lWriteIndex = 0;
	mov	dword ptr  lWriteIndex,0h

; 239               stRow.lLeadIndex = 0;
	mov	dword ptr  stRow+073h,0h

; 240               bBufferWrapped = FALSE;
	mov	dword ptr  bBufferWrapped,0h

; 241               }

; 242             }
@BLBL24:

; 243           memcpy(pstCFG,&stCFGtemp,sizeof(CSCFG));
	mov	ecx,0e3h
	mov	edx,offset FLAT:@21stCFGtemp
	mov	eax,dword ptr  @20pstCFG
	call	memcpy
@BLBL37:

; 245            break;
	jmp	@BLBL34
	align 04h
@BLBL38:

; 247           DisplayHelpPanel(HLPP_BUFFER_SIZE_DLG);
	push	0754ah
	call	DisplayHelpPanel
	add	esp,04h

; 248           return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL39:

; 250           return WinDefDlgProc(hwnd,msg,mp1,mp2);
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefDlgProc
	add	esp,01ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL34
	align 04h
@BLBL35:
	cmp	eax,01h
	je	@BLBL36
	cmp	eax,02h
	je	@BLBL37
	cmp	eax,012dh
	je	@BLBL38
	jmp	@BLBL39
	align 04h
@BLBL34:

; 252       WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 253       break;
	jmp	@BLBL30
	align 04h
@BLBL40:

; 255       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefDlgProc
	add	esp,01ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL30
	align 04h
@BLBL31:
	cmp	eax,03bh
	je	@BLBL32
	cmp	eax,020h
	je	@BLBL33
	jmp	@BLBL40
	align 04h
@BLBL30:

; 257   return FALSE;
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
fnwpBufferSizeDlg	endp

; 261   {
	align 010h

	public fnwpMonitorSleepDlg
fnwpMonitorSleepDlg	proc
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
	sub	esp,08h

; 268   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL53
	align 04h
@BLBL54:

; 269     {
; 270     case WM_INITDLG:
; 271 //      CenterDlgBox(hwnd);
; 272       WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h

; 273       bAllowClick = FALSE;
	mov	dword ptr  @5bbAllowClick,0h

; 274       pstCFG = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @5apstCFG,eax

; 275       if (hCom != 0xffffffff)
	cmp	dword ptr  hCom,0ffffffffh
	je	@BLBL41

; 276         if (GetBaudRate(&stIOctl,hCom,&lBaud) == 0)
	lea	eax,[ebp-068h];	lBaud
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetBaudRate
	add	esp,0ch
	test	eax,eax
	jne	@BLBL41

; 277           CalcThreadSleepCount(lBaud);
	push	dword ptr [ebp-068h];	lBaud
	call	CalcThreadSleepCount
	add	esp,04h
@BLBL41:

; 278       sprintf(szString,"Device Driver Trace Buffer Size = %d bytes",ulCOMscopeBufferSize);
	push	dword ptr  ulCOMscopeBufferSize
	mov	edx,offset FLAT:@STATb
	lea	eax,[ebp-064h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 279       WinSetDlgItemText(hwnd,MSLEEP_BUFF_SIZE,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0bbeh
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 280       sprintf(szString,"Calculated Update Frequency = %ld milliseconds",ulCalcSleepCount);
	push	dword ptr  ulCalcSleepCount
	mov	edx,offset FLAT:@STATc
	lea	eax,[ebp-064h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 281       WinSetDlgItemText(hwnd,MSLEEP_CALC_RATE,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0bbfh
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 282       if (pstCFG->ulUserSleepCount == 0)
	mov	eax,dword ptr  @5apstCFG
	cmp	dword ptr [eax+0d1h],0h
	jne	@BLBL43

; 283         {
; 284         ulFrequency = ulCalcSleepCount;
	mov	eax,dword ptr  ulCalcSleepCount
	mov	dword ptr  @59ulFrequency,eax

; 285         CheckButton(hwnd,MSLEEP_CALC,TRUE);
	push	01h
	push	0bbbh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 286         ControlEnable(hwnd,MSLEEP_USER_COUNT,FALSE);
	push	0h
	push	0bbch
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 287         ControlEnable(hwnd,MSLEEP_USER_COUNTT,FALSE);
	push	0h
	push	0bbdh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 288         }
	jmp	@BLBL44
	align 010h
@BLBL43:

; 289       else
; 290         {
; 291         ulFrequency = pstCFG->ulUserSleepCount;
	mov	eax,dword ptr  @5apstCFG
	mov	eax,[eax+0d1h]
	mov	dword ptr  @59ulFrequency,eax

; 292         CheckButton(hwnd,MSLEEP_USER,TRUE);
	push	01h
	push	0bbah
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 293         }
@BLBL44:

; 294       if (ulFrequency < 100)
	cmp	dword ptr  @59ulFrequency,064h
	jae	@BLBL45

; 295         {
; 296         sprintf(szString,"Recommend increasing");
	mov	edx,offset FLAT:@STATd
	lea	eax,[ebp-064h];	szString
	call	_sprintfieee

; 297         WinSetDlgItemText(hwnd,MSLEEP_WARNING,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0bc1h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 298         sprintf(szString,"device driver trace buffer size!");
	mov	edx,offset FLAT:@STATe
	lea	eax,[ebp-064h];	szString
	call	_sprintfieee

; 299         WinSetDlgItemText(hwnd,MSLEEP_WARNING1,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0bc2h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 300         }
@BLBL45:

; 301       sprintf(szString,"%ld",ulFrequency);
	push	dword ptr  @59ulFrequency
	mov	edx,offset FLAT:@STATf
	lea	eax,[ebp-064h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 302       WinSendDlgItemMsg(hwnd,MSLEEP_USER_COUNT,EM_SETTEXTLIMIT,MPFROMSHORT(6),(MPARAM)NULL);
	push	0h
	push	06h
	push	0143h
	push	0bbch
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 303       WinSetDlgItemText(hwnd,MSLEEP_USER_COUNT,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0bbch
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 304       WinPostMsg(hwnd,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 305       break;
	jmp	@BLBL52
	align 04h
@BLBL55:

; 306     case UM_INITLS:
; 307       bAllowClick = TRUE;
	mov	dword ptr  @5bbAllowClick,01h

; 308       break;
	jmp	@BLBL52
	align 04h
@BLBL56:

; 309     case WM_COMMAND:
; 310       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL58
	align 04h
@BLBL59:

; 311         {
; 312         case DID_OK:
; 313           if (Checked(hwnd,MSLEEP_USER))
	push	0bbah
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL46

; 314             {
; 315             WinQueryDlgItemText(hwnd,MSLEEP_USER_COUNT,6,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	06h
	push	0bbch
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 316             ulMonitorSleepCount = (USHORT)atoi(szString);
	lea	eax,[ebp-064h];	szString
	call	atoi
	and	eax,0ffffh
	mov	dword ptr  ulMonitorSleepCount,eax

; 317             pstCFG->ulUserSleepCount = ulMonitorSleepCount;
	mov	eax,dword ptr  @5apstCFG
	mov	ecx,dword ptr  ulMonitorSleepCount
	mov	[eax+0d1h],ecx

; 318             }
	jmp	@BLBL47
	align 010h
@BLBL46:

; 319           else
; 320             {
; 321             pstCFG->ulUserSleepCount = 0;
	mov	eax,dword ptr  @5apstCFG
	mov	dword ptr [eax+0d1h],0h

; 322             ulMonitorSleepCount = ulCalcSleepCount;
	mov	eax,dword ptr  ulCalcSleepCount
	mov	dword ptr  ulMonitorSleepCount,eax

; 323             }
@BLBL47:

; 324           if (pstCFG->fDisplaying & DISP_STREAM)
	mov	eax,dword ptr  @5apstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	test	al,01h
	je	@BLBL48

; 325             if (pstCFG->ulUserSleepCount == 0)
	mov	eax,dword ptr  @5apstCFG
	cmp	dword ptr [eax+0d1h],0h
	jne	@BLBL48

; 326               if (ulMonitorSleepCount > 200)
	cmp	dword ptr  ulMonitorSleepCount,0c8h
	jbe	@BLBL48

; 327                 ulMonitorSleepCount = 200;
	mov	dword ptr  ulMonitorSleepCount,0c8h
@BLBL48:

; 328           DosPostEventSem(hevWaitCOMiDataSem);
	push	dword ptr  hevWaitCOMiDataSem
	call	DosPostEventSem
	add	esp,04h
@BLBL60:

; 329         case DID_CANCEL:
; 330            break;
	jmp	@BLBL57
	align 04h
@BLBL61:

; 331         case DID_HELP:
; 332           DisplayHelpPanel(HLPP_MONITOR_UPDATE_DLG);
	push	0754bh
	call	DisplayHelpPanel
	add	esp,04h

; 333           return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL62:

; 334         default:
; 335           return WinDefDlgProc(hwnd,msg,mp1,mp2);
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefDlgProc
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL57
	align 04h
@BLBL58:
	cmp	eax,01h
	je	@BLBL59
	cmp	eax,02h
	je	@BLBL60
	cmp	eax,012dh
	je	@BLBL61
	jmp	@BLBL62
	align 04h
@BLBL57:

; 336         }
; 337       WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 338       break;
	jmp	@BLBL52
	align 04h
@BLBL63:

; 339     case WM_CONTROL:
; 340       if ((SHORT2FROMMP(mp1) == BN_CLICKED) && bAllowClick)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL51
	cmp	dword ptr  @5bbAllowClick,0h
	je	@BLBL51

; 341         {
; 342         switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL65
	align 04h
@BLBL66:

; 343           {
; 344           case MSLEEP_CALC:
; 345             CheckButton(hwnd,MSLEEP_CALC,TRUE);
	push	01h
	push	0bbbh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 346             CheckButton(hwnd,MSLEEP_USER,FALSE);
	push	0h
	push	0bbah
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 347             ControlEnable(hwnd,MSLEEP_USER_COUNT,FALSE);
	push	0h
	push	0bbch
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 348             ControlEnable(hwnd,MSLEEP_USER_COUNTT,FALSE);
	push	0h
	push	0bbdh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 349             break;
	jmp	@BLBL64
	align 04h
@BLBL67:

; 350           case MSLEEP_USER:
; 351             CheckButton(hwnd,MSLEEP_CALC,FALSE);
	push	0h
	push	0bbbh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 352             CheckButton(hwnd,MSLEEP_USER,TRUE);
	push	01h
	push	0bbah
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 353             ControlEnable(hwnd,MSLEEP_USER_COUNT,TRUE);
	push	01h
	push	0bbch
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 354             ControlEnable(hwnd,MSLEEP_USER_COUNTT,TRUE);
	push	01h
	push	0bbdh
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 355             break;
	jmp	@BLBL64
	align 04h
	jmp	@BLBL64
	align 04h
@BLBL65:
	cmp	eax,0bbbh
	je	@BLBL66
	cmp	eax,0bbah
	je	@BLBL67
@BLBL64:

; 356           }
; 357         }
@BLBL51:

; 358       break;
	jmp	@BLBL52
	align 04h
@BLBL68:

; 359     default:
; 360       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefDlgProc
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL52
	align 04h
@BLBL53:
	cmp	eax,03bh
	je	@BLBL54
	cmp	eax,08002h
	je	@BLBL55
	cmp	eax,020h
	je	@BLBL56
	cmp	eax,030h
	je	@BLBL63
	jmp	@BLBL68
	align 04h
@BLBL52:

; 361     }
; 362   return FALSE;
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
fnwpMonitorSleepDlg	endp

; 366   {
	align 010h

	public fnwpDisplaySetupDlgProc
fnwpDisplaySetupDlgProc	proc
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
	sub	esp,0ch

; 372   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL94
	align 04h
@BLBL95:

; 373     {
; 374     case WM_INITDLG:
; 375 //      CenterDlgBox(hwndDlg);
; 376       WinSetFocus(HWND_DESKTOP,hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinSetFocus
	add	esp,08h

; 377       pstScreen = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @73pstScreen,eax

; 378       bAllowClick = FALSE;
	mov	dword ptr  @72bAllowClick,0h

; 379       memcpy(&stScreen,pstScreen,sizeof(SCREEN));
	mov	ecx,07fh
	mov	edx,dword ptr  @73pstScreen
	mov	eax,offset FLAT:@74stScreen
	call	memcpy

; 380       WinSendDlgItemMsg(hwndDlg,DISP_NL_CHAR,EM_SETTEXTLIMIT,MPFROMSHORT(2),(MPARAM)NULL);
	push	0h
	push	02h
	push	0143h
	push	01777h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 381       sprintf(szTitle,"%02X",(int)stScreen.byNewLineChar);
	xor	eax,eax
	mov	al,byte ptr  @74stScreen+03h
	push	eax
	mov	edx,offset FLAT:@STAT10
	lea	eax,[ebp-014h];	szTitle
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 382       WinSetDlgItemText(hwndDlg,DISP_NL_CHAR,szTitle);
	lea	eax,[ebp-014h];	szTitle
	push	eax
	push	01777h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 383       WinSendDlgItemMsg(hwndDlg,DISP_CHAR_MASK,EM_SETTEXTLIMIT,MPFROMSHORT(2),(MPARAM)NULL);
	push	0h
	push	02h
	push	0143h
	push	01774h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 384       sprintf(szTitle,"%02X",(int)stScreen.byDisplayMask);
	xor	eax,eax
	mov	al,byte ptr  @74stScreen+04h
	push	eax
	mov	edx,offset FLAT:@STAT11
	lea	eax,[ebp-014h];	szTitle
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 385       WinSetDlgItemText(hwndDlg,DISP_CHAR_MASK,szTitle);
	lea	eax,[ebp-014h];	szTitle
	push	eax
	push	01774h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 386       if (stScreen.bSync)
	test	byte ptr  @74stScreen+02h,010h
	je	@BLBL69

; 387         CheckButton(hwndDlg,DISP_SYNC,TRUE);
	push	01h
	push	01783h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL69:

; 388       if (stScreen.wDirection == CS_WRITE)
	cmp	word ptr  @74stScreen+05h,08000h
	jne	@BLBL70

; 389         {
; 390         if (stCFG.bWriteWrap)
	test	byte ptr  stCFG+016h,080h
	je	@BLBL72

; 391           CheckButton(hwndDlg,DISP_WRAP,TRUE);
	push	01h
	push	01781h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 392         }
	jmp	@BLBL72
	align 010h
@BLBL70:

; 393       else
; 394         if (stCFG.bReadWrap)
	test	byte ptr  stCFG+016h,040h
	je	@BLBL72

; 395           CheckButton(hwndDlg,DISP_WRAP,TRUE);
	push	01h
	push	01781h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL72:

; 396       if (stScreen.bTestNewLine)
	test	byte ptr  @74stScreen+02h,02h
	je	@BLBL74

; 397         CheckButton(hwndDlg,DISP_NL,TRUE);
	push	01h
	push	0177bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL75
	align 010h
@BLBL74:

; 398       else
; 399         {
; 400         EnableNewLine(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	EnableNewLine
	add	esp,08h

; 401         ControlEnable(hwndDlg,DISP_SYNC,FALSE);
	push	0h
	push	01783h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 402         }
@BLBL75:

; 403       if (stScreen.bSkipBlankLines)
	test	byte ptr  @74stScreen+02h,04h
	je	@BLBL76

; 404         CheckButton(hwndDlg,DISP_SKP,TRUE);
	push	01h
	push	01779h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL76:

; 405       CheckButton(hwndDlg,DISP_ALPHA,(stScreen.fFilterMask & FILTER_ALPHA));
	mov	eax,dword ptr  @74stScreen+07h
	and	eax,02h
	push	eax
	push	0177ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 406       CheckButton(hwndDlg,DISP_NUMS,(stScreen.fFilterMask & FILTER_NUMS));
	mov	eax,dword ptr  @74stScreen+07h
	and	eax,04h
	push	eax
	push	0177dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 407       CheckButton(hwndDlg,DISP_PUNCT,(stScreen.fFilterMask & FILTER_PUNCT));
	mov	eax,dword ptr  @74stScreen+07h
	and	eax,08h
	push	eax
	push	0177eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 408       CheckButton(hwndDlg,DISP_NPRINT,(stScreen.fFilterMask & FILTER_NPRINT));
	mov	eax,dword ptr  @74stScreen+07h
	and	eax,01h
	push	eax
	push	0177fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 409       if (stScreen.bFilter)
	test	byte ptr  @74stScreen+02h,020h
	je	@BLBL77

; 410         CheckButton(hwndDlg,DISP_FILTER,TRUE);
	push	01h
	push	0177ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL78
	align 010h
@BLBL77:

; 411       else
; 412         EnableFilters(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	EnableFilters
	add	esp,08h
@BLBL78:

; 413       WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinPostMsg
	add	esp,010h

; 414       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL96:

; 415     case UM_INITLS:
; 416       bAllowClick = TRUE;
	mov	dword ptr  @72bAllowClick,01h

; 417       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL97:

; 418     case WM_COMMAND:
; 419       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL99
	align 04h
@BLBL100:

; 420         {
; 421         case DID_OK:
; 422           if ((stScreen.bTestNewLine = Checked(hwndDlg,DISP_NL)) == TRUE)
	push	0177bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	mov	ecx,eax
	add	esp,08h
	mov	al,byte ptr  @74stScreen+02h
	and	al,0fdh
	sal	ecx,01h
	and	cl,03h
	or	al,cl
	mov	byte ptr  @74stScreen+02h,al
	mov	al,byte ptr  @74stScreen+02h
	and	eax,03h
	shr	eax,01h
	cmp	eax,01h
	jne	@BLBL79

; 423             {
; 424             stScreen.bSkipBlankLines = Checked(hwndDlg,DISP_SKP);
	push	01779h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	mov	ecx,eax
	add	esp,08h
	mov	al,byte ptr  @74stScreen+02h
	and	al,0fbh
	sal	ecx,02h
	and	cl,07h
	or	al,cl
	mov	byte ptr  @74stScreen+02h,al

; 425             WinQueryDlgItemText(hwndDlg,DISP_NL_CHAR,3,szTitle);
	lea	eax,[ebp-014h];	szTitle
	push	eax
	push	03h
	push	01777h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinQueryDlgItemText
	add	esp,010h

; 426             stSc
; 426 reen.byNewLineChar = (BYTE)ASCIItoBin(szTitle,16);
	push	010h
	lea	eax,[ebp-014h];	szTitle
	push	eax
	call	ASCIItoBin
	add	esp,08h
	mov	byte ptr  @74stScreen+03h,al

; 427             stScreen.bSync = Checked(hwndDlg,DISP_SYNC);
	push	01783h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	mov	ecx,eax
	add	esp,08h
	mov	al,byte ptr  @74stScreen+02h
	and	al,0efh
	sal	ecx,04h
	and	cl,01fh
	or	al,cl
	mov	byte ptr  @74stScreen+02h,al

; 428             stScreen.bWrap = Checked(hwndDlg,DISP_WRAP);
	push	01781h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	mov	ecx,eax
	add	esp,08h
	mov	al,byte ptr  @74stScreen+02h
	and	al,0f7h
	sal	ecx,03h
	and	cl,0fh
	or	al,cl
	mov	byte ptr  @74stScreen+02h,al

; 429             if (stScreen.wDirection == CS_WRITE)
	cmp	word ptr  @74stScreen+05h,08000h
	jne	@BLBL80

; 430               stCFG.bWriteWrap = stScreen.bWrap;
	mov	cl,byte ptr  @74stScreen+02h
	and	ecx,0fh
	shr	ecx,03h
	mov	al,byte ptr  stCFG+016h
	and	al,07fh
	sal	ecx,07h
	or	al,cl
	mov	byte ptr  stCFG+016h,al
	jmp	@BLBL82
	align 010h
@BLBL80:

; 431             else
; 432               stCFG.bReadWrap = stScreen.bWrap;
	mov	cl,byte ptr  @74stScreen+02h
	and	ecx,0fh
	shr	ecx,03h
	mov	al,byte ptr  stCFG+016h
	and	al,0bfh
	sal	ecx,06h
	and	cl,07fh
	or	al,cl
	mov	byte ptr  stCFG+016h,al

; 433             }
	jmp	@BLBL82
	align 010h
@BLBL79:

; 434           else
; 435             stScreen.bWrap = TRUE;
	or	byte ptr  @74stScreen+02h,08h
@BLBL82:

; 436           if ((stScreen.bFilter = Checked(hwndDlg,DISP_FILTER)) == TRUE)
	push	0177ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	mov	ecx,eax
	add	esp,08h
	mov	al,byte ptr  @74stScreen+02h
	and	al,0dfh
	sal	ecx,05h
	and	cl,03fh
	or	al,cl
	mov	byte ptr  @74stScreen+02h,al
	mov	al,byte ptr  @74stScreen+02h
	and	eax,03fh
	shr	eax,05h
	cmp	eax,01h
	jne	@BLBL83

; 437             {
; 438             stScreen.fFilterMask = 0;
	mov	dword ptr  @74stScreen+07h,0h

; 439             if (Checked(hwndDlg,DISP_NPRINT))
	push	0177fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL84

; 440               stScreen.fFilterMask |= FILTER_NPRINT;
	mov	eax,dword ptr  @74stScreen+07h
	or	al,01h
	mov	dword ptr  @74stScreen+07h,eax
@BLBL84:

; 441             if (Checked(hwndDlg,DISP_ALPHA))
	push	0177ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL85

; 442               stScreen.fFilterMask |= FILTER_ALPHA;
	mov	eax,dword ptr  @74stScreen+07h
	or	al,02h
	mov	dword ptr  @74stScreen+07h,eax
@BLBL85:

; 443             if (Checked(hwndDlg,DISP_NUMS))
	push	0177dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL86

; 444               stScreen.fFilterMask |= FILTER_NUMS;
	mov	eax,dword ptr  @74stScreen+07h
	or	al,04h
	mov	dword ptr  @74stScreen+07h,eax
@BLBL86:

; 445             if (Checked(hwndDlg,DISP_PUNCT))
	push	0177eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL87

; 446               stScreen.fFilterMask |= FILTER_PUNCT;
	mov	eax,dword ptr  @74stScreen+07h
	or	al,08h
	mov	dword ptr  @74stScreen+07h,eax
@BLBL87:

; 447             WinQueryDlgItemText(hwndDlg,DISP_CHAR_MASK,3,szTitle);
	lea	eax,[ebp-014h];	szTitle
	push	eax
	push	03h
	push	01774h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinQueryDlgItemText
	add	esp,010h

; 448             stScreen.byDisplayMask = (BYTE)ASCIItoBin(szTitle,16);
	push	010h
	lea	eax,[ebp-014h];	szTitle
	push	eax
	call	ASCIItoBin
	add	esp,08h
	mov	byte ptr  @74stScreen+04h,al

; 449             }
@BLBL83:

; 450           memcpy(pstScreen,&stScreen,sizeof(SCREEN));
	mov	ecx,07fh
	mov	edx,offset FLAT:@74stScreen
	mov	eax,dword ptr  @73pstScreen
	call	memcpy

; 451           AdjustScrollBar(pstScreen);
	push	dword ptr  @73pstScreen
	call	AdjustScrollBar
	add	esp,04h

; 452           WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 453           return(MRESULT)TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL101:

; 454         case DID_HELP:
; 455           DisplayHelpPanel(HLPP_DISPLAY_DLG);
	push	075a6h
	call	DisplayHelpPanel
	add	esp,04h

; 456           return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL102:

; 457         case DID_CANCEL:
; 458           WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 459           break;
	jmp	@BLBL98
	align 04h
@BLBL103:

; 460         default:
; 461           return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
	jmp	@BLBL98
	align 04h
@BLBL99:
	cmp	eax,01h
	je	@BLBL100
	cmp	eax,012dh
	je	@BLBL101
	cmp	eax,02h
	je	@BLBL102
	jmp	@BLBL103
	align 04h
@BLBL98:

; 462         }
; 463       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL104:

; 464     case WM_CONTROL:
; 465       if ((SHORT2FROMMP(mp1) == BN_CLICKED) && bAllowClick)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL88
	cmp	dword ptr  @72bAllowClick,0h
	je	@BLBL88

; 466         {
; 467         switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL106
	align 04h
@BLBL107:

; 468           {
; 469           case DISP_NL:
; 470             if (Checked(hwndDlg,DISP_NL))
	push	0177bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL89

; 471               {
; 472               CheckButton(hwndDlg,DISP_NL,FALSE);
	push	0h
	push	0177bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 473               EnableNewLine(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	EnableNewLine
	add	esp,08h

; 474               }
	jmp	@BLBL90
	align 010h
@BLBL89:

; 475             else
; 476               {
; 477               CheckButton(hwndDlg,DISP_NL,TRUE);
	push	01h
	push	0177bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 478               EnableNewLine(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	EnableNewLine
	add	esp,08h

; 479               }
@BLBL90:

; 480             break;
	jmp	@BLBL105
	align 04h
@BLBL108:

; 481           case DISP_FILTER:
; 482             if (!Checked(hwndDlg,DISP_FILTER))
	push	0177ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL91

; 483               {
; 484               CheckButton(hwndDlg,DISP_FILTER,TRUE);
	push	01h
	push	0177ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 485               EnableFilters(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	EnableFilters
	add	esp,08h

; 486               }
	jmp	@BLBL92
	align 010h
@BLBL91:

; 487             else
; 488               {
; 489               CheckButton(hwndDlg,DISP_FILTER,FALSE);
	push	0h
	push	0177ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 490               EnableFilters(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	EnableFilters
	add	esp,08h

; 491               }
@BLBL92:

; 492             break;
	jmp	@BLBL105
	align 04h
@BLBL109:

; 493         default:
; 494            return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
	jmp	@BLBL105
	align 04h
@BLBL106:
	cmp	eax,0177bh
	je	@BLBL107
	cmp	eax,0177ah
	je	@BLBL108
	jmp	@BLBL109
	align 04h
@BLBL105:

; 495           }
; 496         return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL88:

; 497         }
; 498       break;
	jmp	@BLBL93
	align 04h
	jmp	@BLBL93
	align 04h
@BLBL94:
	cmp	eax,03bh
	je	@BLBL95
	cmp	eax,08002h
	je	@BLBL96
	cmp	eax,020h
	je	@BLBL97
	cmp	eax,030h
	je	@BLBL104
@BLBL93:

; 499     }
; 500   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
fnwpDisplaySetupDlgProc	endp

; 504   {
	align 010h

	public fnwpCountsSetupDlgProc
fnwpCountsSetupDlgProc	proc
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

; 510   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL126
	align 04h
@BLBL127:

; 511     {
; 512     case WM_INITDLG:
; 513 //      CenterDlgBox(hwndDlg);
; 514       WinSetFocus(HWND_DESKTOP,hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinSetFocus
	add	esp,08h

; 515       pstCFG = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @8bpstCFG,eax

; 516       WinSendDlgItemMsg(hwndDlg,SPB_SAMPLES,SPBM_SETLIMITS,(MPARAM)MAX_CPS_SAMPLES,(MPARAM)0);
	push	0h
	push	064h
	push	0207h
	push	02394h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 517       if (pstCFG->iSampleCount == 0)
	mov	eax,dword ptr  @8bpstCFG
	cmp	dword ptr [eax+0dfh],0h
	jne	@BLBL110

; 518         iSamples = 1;
	mov	dword ptr [ebp-018h],01h;	iSamples
	jmp	@BLBL111
	align 010h
@BLBL110:

; 519       else
; 520         iSamples = pstCFG->iSampleCount;
	mov	eax,dword ptr  @8bpstCFG
	mov	eax,[eax+0dfh]
	mov	[ebp-018h],eax;	iSamples
@BLBL111:

; 521       WinSendDlgItemMsg(hwndDlg,SPB_SAMPLES,SPBM_SETCURRENTVALUE,(MPARAM)(iSamples - 1),NULL);
	push	0h
	mov	eax,[ebp-018h];	iSamples
	dec	eax
	push	eax
	push	0208h
	push	02394h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 522       bAllowClick = FALSE;
	mov	dword ptr  @8abAllowClick,0h

; 523       if (!pstCFG->bSampleCounts)
	mov	eax,dword ptr  @8bpstCFG
	test	byte ptr [eax+018h],010h
	jne	@BLBL112

; 524         {
; 525         ControlEnable(hwndDlg,SPB_SAMPLES,FALSE);
	push	0h
	push	02394h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 526         ControlEnable(hwndDlg,ST_SAMPLES,FALSE);
	push	0h
	push	04b66h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 527         }
	jmp	@BLBL113
	align 010h
@BLBL112:

; 528       else
; 529         CheckButton(hwndDlg,CB_DISPCPS,TRUE);
	push	01h
	push	0238eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL113:

; 530       if (pstCFG->bShowCounts)
	mov	eax,dword ptr  @8bpstCFG
	test	byte ptr [eax+016h],010h
	je	@BLBL114

; 531         CheckButton(hwndDlg,CB_DISPCOUNTS,TRUE);
	push	01h
	push	02391h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL114:

; 532       WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinPostMsg
	add	esp,010h

; 533       return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL128:

; 534     case UM_INITLS:
; 535       bAllowClick = TRUE;
	mov	dword ptr  @8abAllowClick,01h

; 536       return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL129:

; 537     case WM_COMMAND:
; 538       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL131
	align 04h
@BLBL132:

; 539         {
; 540         case DID_OK:
; 541           if (Checked(hwndDlg,CB_DISPCOUNTS))
	push	02391h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL115

; 542             pstCFG->bShowCounts = TRUE;
	mov	eax,dword ptr  @8bpstCFG
	or	byte ptr [eax+016h],010h
	jmp	@BLBL116
	align 010h
@BLBL115:

; 543           else
; 544             pstCFG->bShowCounts = FALSE;
	mov	eax,dword ptr  @8bpstCFG
	and	byte ptr [eax+016h],0efh
@BLBL116:

; 545           if (Checked(hwndDlg,CB_DISPCPS))
	push	0238eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL117

; 546             {
; 547             WinSendDlgItemMsg(hwndDlg,SPB_SAMPLES,SPBM_QUERYVALUE,&pstCFG->iSampleCount,MPFROM2SHORT(0,SPBQ_DONOTUPDATE));
	push	030000h
	mov	eax,dword ptr  @8bpstCFG
	add	eax,0dfh
	push	eax
	push	0205h
	push	02394h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 548             pstCFG->iSampleCount++;
	mov	eax,dword ptr  @8bpstCFG
	mov	[ebp-01ch],eax;	@CBE66
	mov	eax,[ebp-01ch];	@CBE66
	mov	ecx,[eax+0dfh]
	inc	ecx
	mov	[eax+0dfh],ecx

; 549             pstCFG->bSampleCounts = TRUE;
	mov	eax,dword ptr  @8bpstCFG
	or	byte ptr [eax+018h],010h

; 550             }
	jmp	@BLBL118
	align 010h
@BLBL117:

; 551           else
; 552             pstCFG->bSampleCounts = FALSE;
	mov	eax,dword ptr  @8bpstCFG
	and	byte ptr [eax+018h],0efh
@BLBL118:

; 553 
; 554           if (!pstCFG->bShowCounts && !pstCFG->bSampleCounts)
	mov	eax,dword ptr  @8bpstCFG
	test	byte ptr [eax+016h],010h
	jne	@BLBL119
	mov	eax,dword ptr  @8bpstCFG
	test	byte ptr [eax+018h],010h
	jne	@BLBL119

; 555             WinPostMsg(hwndStatus,UM_STOPTIMER,0L,0L);
	push	0h
	push	0h
	push	08019h
	push	dword ptr  hwndStatus
	call	WinPostMsg
	add	esp,010h
	jmp	@BLBL120
	align 010h
@BLBL119:

; 556           else
; 557             {
; 558             WinPostMsg(hwndStatus,UM_RESET_SAMPLES,0L,0L);
	push	0h
	push	0h
	push	08027h
	push	dword ptr  hwndStatus
	call	WinPostMsg
	add	esp,010h

; 559             WinPostMsg(hwndStatus,UM_STARTTIMER,0L,0L);
	push	0h
	push	0h
	push	0801ah
	push	dword ptr  hwndStatus
	call	WinPostMsg
	add	esp,010h

; 560             }
@BLBL120:

; 561           WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 562           return(MRESULT)TRUE;
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL133:

; 563         case DID_HELP:
; 564           DisplayHelpPanel(HLPP_COUNTS_DLG);
	push	075a5h
	call	DisplayHelpPanel
	add	esp,04h

; 565           return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL134:

; 566         case DID_CANCEL:
; 567           WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 568           break;
	jmp	@BLBL130
	align 04h
@BLBL135:

; 569         default:
; 570           return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
	jmp	@BLBL130
	align 04h
@BLBL131:
	cmp	eax,01h
	je	@BLBL132
	cmp	eax,012dh
	je	@BLBL133
	cmp	eax,02h
	je	@BLBL134
	jmp	@BLBL135
	align 04h
@BLBL130:

; 571         }
; 572       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL136:

; 573     case WM_CONTROL:
; 574       if ((SHORT2FROMMP(mp1) == BN_CLICKED) && bAllowClick)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL121
	cmp	dword ptr  @8abAllowClick,0h
	je	@BLBL121

; 575         {
; 576         if (SHORT1FROMMP(mp1) == CB_DISPCPS)
	mov	ax,[ebp+010h];	mp1
	cmp	ax,0238eh
	jne	@BLBL121

; 577           if (Checked(hwndDlg,CB_DISPCPS))
	push	0238eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL123

; 578             {
; 579             CheckButton(hwndDlg,CB_DISPCPS,FALSE);
	push	0h
	push	0238eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 580             ControlEnable(hwndDlg,SPB_SAMPLES,FALSE);
	push	0h
	push	02394h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 581             ControlEnable(hwndDlg,ST_SAMPLES,FALSE);
	push	0h
	push	04b66h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 582             }
	jmp	@BLBL121
	align 010h
@BLBL123:

; 583           else
; 584             {
; 585             CheckButton(hwndDlg,CB_DISPCPS,TRUE);
	push	01h
	push	0238eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 586             ControlEnable(hwndDlg,SPB_SAMPLES,TRUE);
	push	01h
	push	02394h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 587             ControlEnable(hwndDlg,ST_SAMPLES,TRUE);
	push	01h
	push	04b66h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 588             }

; 589         }
@BLBL121:

; 590       break;
	jmp	@BLBL125
	align 04h
	jmp	@BLBL125
	align 04h
@BLBL126:
	cmp	eax,03bh
	je	@BLBL127
	cmp	eax,08002h
	je	@BLBL128
	cmp	eax,020h
	je	@BLBL129
	cmp	eax,030h
	je	@BLBL136
@BLBL125:

; 591     }
; 592   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
fnwpCountsSetupDlgProc	endp

; 597   {
	align 010h

	public fnwpHdwModemControlDlg
fnwpHdwModemControlDlg	proc
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

; 608   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL160
	align 04h
@BLBL161:

; 609     {
; 610     case WM_INITDLG:
; 611 //      CenterDlgBox(hwndDlg);
; 612       WinSetFocus(HWND_DESKTOP,hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinSetFocus
	add	esp,08h

; 613 //      pstCFG = PVOIDFROMMP(mp2);
; 614       GetModemOutputSignals(&stIOctl,hCom,&byOnStates);
	lea	eax,[ebp-0ch];	byOnStates
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetModemOutputSignals
	add	esp,0ch

; 615       if (byOnStates & 0x01)
	test	byte ptr [ebp-0ch],01h;	byOnStates
	je	@BLBL137

; 616         CheckButton(hwndDlg,HWM_DTR_ON,TRUE);
	push	01h
	push	0232ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL138
	align 010h
@BLBL137:

; 617       else
; 618         CheckButton(hwndDlg,HWM_DTR_OFF,TRUE);
	push	01h
	push	0232bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL138:

; 619       if (byOnStates & 0x02)
	test	byte ptr [ebp-0ch],02h;	byOnStates
	je	@BLBL139

; 620         CheckButton(hwndDlg,HWM_RTS_ON,TRUE);
	push	01h
	push	0232dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL140
	align 010h
@BLBL139:

; 621       else
; 622         CheckButton(hwndDlg,HWM_RTS_OFF,TRUE);
	push	01h
	push	0232eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL140:

; 623       if (!TestOUT1())
	call	TestOUT1
	test	eax,eax
	jne	@BLBL141

; 624         {
; 625         bNoOUT1 = TRUE;
	mov	dword ptr  @99bNoOUT1,01h

; 626         ControlEnable(hwndDlg,HWM_OUT1T,FALSE);
	push	0h
	push	0232fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 627         ControlEnable(hwndDlg,HWM_OUT1_ON,FALSE);
	push	0h
	push	02332h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 628         ControlEnable(hwndDlg,HWM_OUT1_OFF,FALSE);
	push	0h
	push	02333h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 629         }
	jmp	@BLBL142
	align 010h
@BLBL141:

; 630       else
; 631         {
; 632         bNoOUT1 = FALSE;
	mov	dword ptr  @99bNoOUT1,0h

; 633         if (byOnStates & 0x04)
	test	byte ptr [ebp-0ch],04h;	byOnStates
	je	@BLBL143

; 634           CheckButton(hwndDlg,HWM_OUT1_ON,TRUE);
	push	01h
	push	02332h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL142
	align 010h
@BLBL143:

; 635         else
; 636           CheckButton(hwndDlg,HWM_OUT1_OFF,TRUE);
	push	01h
	push	02333h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 637         }
@BLBL142:

; 638       GetDCB(&stIOctl,hCom,&stComDCB);
	lea	eax,[ebp-0bh];	stComDCB
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetDCB
	add	esp,0ch

; 639       if (stComDCB.Flags1 & F1_ENABLE_DTR_INPUT_HS)
	test	byte ptr [ebp-07h],02h;	stComDCB
	je	@BLBL145

; 640         {
; 641         bNoDTR = TRUE;
	mov	dword ptr  @9bbNoDTR,01h

; 642         ControlEnable(hwndDlg,HWM_DTRT,FALSE);
	push	0h
	push	02329h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 643         ControlEnable(hwndDlg,HWM_DTR_ON,FALSE);
	push	0h
	push	0232ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 644         ControlEnable(hwndDlg,HWM_DTR_OFF,FALSE);
	push	0h
	push	0232bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 645         }
	jmp	@BLBL146
	align 010h
@BLBL145:

; 646       else
; 647         bNoDTR = FALSE;
	mov	dword ptr  @9bbNoDTR,0h
@BLBL146:

; 648       if (((stComDCB.Flags2 & F2_RTS_MASK) == F2_ENABLE_RTS_INPUT_HS) ||
	mov	al,[ebp-06h];	stComDCB
	and	al,0c0h
	cmp	al,080h
	je	@BLBL147

; 649           ((stComDCB.Flags2 & F2_RTS_MASK) == F2_ENABLE_RTS_TOG_ON_XMIT))
	mov	al,[ebp-06h];	stComDCB
	and	al,0c0h
	cmp	al,0c0h
	jne	@BLBL148
@BLBL147:

; 650         {
; 651         bNoRTS = TRUE;
	mov	dword ptr  @9abNoRTS,01h

; 652         ControlEnable(hwndDlg,HWM_RTST,FALSE);
	push	0h
	push	0232ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 653         ControlEnable(hwndDlg,HWM_RTS_ON,FALSE);
	push	0h
	push	0232dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 654         ControlEnable(hwndDlg,HWM_RTS_OFF,FALSE);
	push	0h
	push	0232eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 655         }
	jmp	@BLBL149
	align 010h
@BLBL148:

; 656       else
; 657         bNoRTS = FALSE;
	mov	dword ptr  @9abNoRTS,0h
@BLBL149:

; 658       break;
	jmp	@BLBL159
	align 04h
@BLBL162:

; 659     case WM_COMMAND:
; 660       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL164
	align 04h
@BLBL165:

; 661         {
; 662         case DID_OK:
; 663           byOffStates = 0xff;
	mov	byte ptr [ebp-0dh],0ffh;	byOffStates

; 664           byOnStates = 0x00;
	mov	byte ptr [ebp-0ch],0h;	byOnStates

; 665           if (!bNoDTR)
	cmp	dword ptr  @9bbNoDTR,0h
	jne	@BLBL150

; 666             {
; 667             if (Checked(hwndDlg,HWM_DTR_ON))
	push	0232ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL151

; 668               byOnStates |= 0x01;
	mov	al,[ebp-0ch];	byOnStates
	or	al,01h
	mov	[ebp-0ch],al;	byOnStates
	jmp	@BLBL150
	align 010h
@BLBL151:

; 669             else
; 670               byOffStates &= 0xfe;
	mov	al,[ebp-0dh];	byOffStates
	and	al,0feh
	mov	[ebp-0dh],al;	byOffStates

; 671             }
@BLBL150:

; 672           if (!bNoRTS)
	cmp	dword ptr  @9abNoRTS,0h
	jne	@BLBL153

; 673             {
; 674             if (Checked(hwndDlg,HWM_RTS_ON))
	push	0232dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL154

; 675               byOnStates |= 0x02;
	mov	al,[ebp-0ch];	byOnStates
	or	al,02h
	mov	[ebp-0ch],al;	byOnStates
	jmp	@BLBL153
	align 010h
@BLBL154:

; 676             else
; 677               byOffStates &= 0xfd;
	mov	al,[ebp-0dh];	byOffStates
	and	al,0fdh
	mov	[ebp-0dh],al;	byOffStates

; 678             }
@BLBL153:

; 679           if (!bNoOUT1)
	cmp	dword ptr  @99bNoOUT1,0h
	jne	@BLBL156

; 680             {
; 681             if (Checked(hwndDlg,HWM_OUT1_
; 681 ON))
	push	02332h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL157

; 682               byOnStates |= 0x04;
	mov	al,[ebp-0ch];	byOnStates
	or	al,04h
	mov	[ebp-0ch],al;	byOnStates
	jmp	@BLBL156
	align 010h
@BLBL157:

; 683             else
; 684               byOffStates &= 0xfb;
	mov	al,[ebp-0dh];	byOffStates
	and	al,0fbh
	mov	[ebp-0dh],al;	byOffStates

; 685             }
@BLBL156:

; 686           SetModemSignals(&stIOctl,hCom,byOnStates,byOffStates,&wCOMerror);
	lea	eax,[ebp-010h];	wCOMerror
	push	eax
	mov	al,[ebp-0dh];	byOffStates
	push	eax
	mov	al,[ebp-0ch];	byOnStates
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	SetModemSignals
	add	esp,014h
@BLBL166:

; 687         case DID_CANCEL:
; 688           break;
	jmp	@BLBL163
	align 04h
@BLBL167:

; 689         case DID_HELP:
; 690           DisplayHelpPanel(HLPP_MODEM_SIG_DLG);
	push	0c51ah
	call	DisplayHelpPanel
	add	esp,04h

; 691           return((MRESULT)TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL168:

; 692         default:
; 693           return WinDefDlgProc(hwndDlg,msg,mp1,mp2);
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
	jmp	@BLBL163
	align 04h
@BLBL164:
	cmp	eax,01h
	je	@BLBL165
	cmp	eax,02h
	je	@BLBL166
	cmp	eax,012dh
	je	@BLBL167
	jmp	@BLBL168
	align 04h
@BLBL163:

; 694         }
; 695       WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 696       break;
	jmp	@BLBL159
	align 04h
@BLBL169:

; 697     default:
; 698       return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
	jmp	@BLBL159
	align 04h
@BLBL160:
	cmp	eax,03bh
	je	@BLBL161
	cmp	eax,020h
	je	@BLBL162
	jmp	@BLBL169
	align 04h
@BLBL159:

; 699     }
; 700   return FALSE;
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpHdwModemControlDlg	endp

; 706   {
	align 010h

	public fnwpSetColorDlg
fnwpSetColorDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 715   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL175
	align 04h
@BLBL176:

; 716     {
; 717     case WM_INITDLG:
; 718 //      CenterDlgBox(hwndDlg);
; 719       WinSetFocus(HWND_DESKTOP,hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinSetFocus
	add	esp,08h

; 720       bAllowClick = FALSE;
	mov	dword ptr  @abbAllowClick,0h

; 721       pstColor = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @a8pstColor,eax

; 722       WinSetDlgItemText(hwndDlg,CLR_DLG_CAPTION,pstColor->szCaption);
	mov	eax,dword ptr  @a8pstColor
	add	eax,0ah
	push	eax
	push	014b5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 723       lForegrndColor = pstColor->lForeground;
	mov	eax,dword ptr  @a8pstColor
	mov	eax,[eax+06h]
	mov	dword ptr  @aalForegrndColor,eax

; 724       lBackgrndColor = pstColor->lBackground;
	mov	eax,dword ptr  @a8pstColor
	mov	eax,[eax+02h]
	mov	dword ptr  @a9lBackgrndColor,eax

; 725       FillSetColorDlg(hwndDlg,lForegrndColor,lBackgrndColor);
	push	dword ptr  @a9lBackgrndColor
	push	dword ptr  @aalForegrndColor
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillSetColorDlg
	add	esp,0ch

; 726       hwndSample = WinWindowFromID(hwndDlg,CLR_SAMPLE);
	push	01900h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	mov	dword ptr  @adhwndSample,eax

; 727       WinSetPresParam(hwndSample,PP_FOREGROUNDCOLORINDEX,4,&lForegrndColor);
	push	offset FLAT:@aalForegrndColor
	push	04h
	push	02h
	push	dword ptr  @adhwndSample
	call	WinSetPresParam
	add	esp,010h

; 728       WinSetPresParam(hwndSample,PP_BACKGROUNDCOLORINDEX,4,&lBackgrndColor);
	push	offset FLAT:@a9lBackgrndColor
	push	04h
	push	04h
	push	dword ptr  @adhwndSample
	call	WinSetPresParam
	add	esp,010h

; 729       WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinPostMsg
	add	esp,010h

; 730       break;
	jmp	@BLBL174
	align 04h
@BLBL177:

; 731     case UM_INITLS:
; 732       bAllowClick = TRUE;
	mov	dword ptr  @abbAllowClick,01h

; 733       break;
	jmp	@BLBL174
	align 04h
@BLBL178:

; 734 //    case WM_PAINT:
; 735 //      hps WinBeginPaint(
; 736     case WM_CONTROL:
; 737       if ((SHORT2FROMMP(mp1) == BN_CLICKED) && bAllowClick)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL170
	cmp	dword ptr  @abbAllowClick,0h
	je	@BLBL170

; 738         if (!TCColorDlg(hwndDlg,hwndSample,SHORT1FROMMP(mp1),&lForegrndColor,&lBackgrndColor))
	push	offset FLAT:@a9lBackgrndColor
	push	offset FLAT:@aalForegrndColor
	mov	ax,[ebp+010h];	mp1
	push	eax
	push	dword ptr  @adhwndSample
	push	dword ptr [ebp+08h];	hwndDlg
	call	TCColorDlg
	add	esp,014h
	test	eax,eax
	jne	@BLBL170

; 739           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL170:

; 740       break;
	jmp	@BLBL174
	align 04h
@BLBL179:

; 741     case WM_COMMAND:
; 742       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL181
	align 04h
@BLBL182:

; 743         {
; 744         case DID_AUTOFOREGRND:
; 745           lColor = lBackgrndColor;
	mov	eax,dword ptr  @a9lBackgrndColor
	mov	[ebp-08h],eax;	lColor

; 746           if ((usContrastID = FindContrastingColor(astForegrndContrastTable,&lColor)) != 0)
	lea	eax,[ebp-08h];	lColor
	push	eax
	push	offset FLAT:@6astForegrndContrastTable
	call	FindContrastingColor
	add	esp,08h
	mov	[ebp-02h],ax;	usContrastID
	cmp	word ptr [ebp-02h],0h;	usContrastID
	je	@BLBL172

; 747             {
; 748             lForegrndColor = lColor;
	mov	eax,[ebp-08h];	lColor
	mov	dword ptr  @aalForegrndColor,eax

; 749             CheckButton(hwndDlg,usContrastID,TRUE);
	push	01h
	mov	ax,[ebp-02h];	usContrastID
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 750             WinSetPresParam(hwndSample,PP_FOREGROUNDCOLORINDEX,4,&lForegrndColor);
	push	offset FLAT:@aalForegrndColor
	push	04h
	push	02h
	push	dword ptr  @adhwndSample
	call	WinSetPresParam
	add	esp,010h

; 751             }
@BLBL172:

; 752           break;
	jmp	@BLBL180
	align 04h
@BLBL183:

; 753         case DID_AUTOBACKGRND:
; 754           lColor = lForegrndColor;
	mov	eax,dword ptr  @aalForegrndColor
	mov	[ebp-08h],eax;	lColor

; 755           if ((usContrastID = FindContrastingColor(astBackgrndContrastTable,&lColor)) != 0)
	lea	eax,[ebp-08h];	lColor
	push	eax
	push	offset FLAT:@2astBackgrndContrastTable
	call	FindContrastingColor
	add	esp,08h
	mov	[ebp-02h],ax;	usContrastID
	cmp	word ptr [ebp-02h],0h;	usContrastID
	je	@BLBL173

; 756             {
; 757             lBackgrndColor = lColor;
	mov	eax,[ebp-08h];	lColor
	mov	dword ptr  @a9lBackgrndColor,eax

; 758             CheckButton(hwndDlg,usContrastID,TRUE);
	push	01h
	mov	ax,[ebp-02h];	usContrastID
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 759             WinSetPresParam(hwndSample,PP_BACKGROUNDCOLORINDEX,4,&lBackgrndColor);
	push	offset FLAT:@a9lBackgrndColor
	push	04h
	push	04h
	push	dword ptr  @adhwndSample
	call	WinSetPresParam
	add	esp,010h

; 760             }
@BLBL173:

; 761           break;
	jmp	@BLBL180
	align 04h
@BLBL184:

; 762         case DID_HELP:
; 763           DisplayHelpPanel(HLPP_COLOR_DLG);
	push	075a9h
	call	DisplayHelpPanel
	add	esp,04h

; 764           return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL185:

; 765         case DID_OK:
; 766           pstColor->lBackground = lBackgrndColor;
	mov	eax,dword ptr  @a8pstColor
	mov	ecx,dword ptr  @a9lBackgrndColor
	mov	[eax+02h],ecx

; 767           pstColor->lForeground = lForegrndColor;
	mov	eax,dword ptr  @a8pstColor
	mov	ecx,dword ptr  @aalForegrndColor
	mov	[eax+06h],ecx

; 768           WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 769           break;
	jmp	@BLBL180
	align 04h
@BLBL186:

; 770         case DID_CANCEL:
; 771           WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 772           break;
	jmp	@BLBL180
	align 04h
@BLBL187:

; 773         default:
; 774           return WinDefDlgProc(hwndDlg,msg,mp1,mp2);
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
	jmp	@BLBL180
	align 04h
@BLBL181:
	cmp	eax,01519h
	je	@BLBL182
	cmp	eax,0151ah
	je	@BLBL183
	cmp	eax,012dh
	je	@BLBL184
	cmp	eax,01h
	je	@BLBL185
	cmp	eax,02h
	je	@BLBL186
	jmp	@BLBL187
	align 04h
@BLBL180:

; 775         }
; 776       break;
	jmp	@BLBL174
	align 04h
@BLBL188:

; 777     default:
; 778       return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
	jmp	@BLBL174
	align 04h
@BLBL175:
	cmp	eax,03bh
	je	@BLBL176
	cmp	eax,08002h
	je	@BLBL177
	cmp	eax,030h
	je	@BLBL178
	cmp	eax,020h
	je	@BLBL179
	jmp	@BLBL188
	align 04h
@BLBL174:

; 779     }
; 780   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpSetColorDlg	endp

; 784   {
	align 010h

	public TCColorDlg
TCColorDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 786   BOOL bBackground = FALSE;
	mov	dword ptr [ebp-08h],0h;	bBackground

; 787 
; 788   if (Checked(hwndDlg,idButton))
	mov	ax,[ebp+010h];	idButton
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL189

; 789     {
; 790     switch(idButton)
	xor	eax,eax
	mov	ax,[ebp+010h];	idButton
	jmp	@BLBL193
	align 04h
@BLBL194:

; 791       {
; 792       case CLR_BDRED:
; 793         lColor = CLR_DARKRED;
	mov	dword ptr [ebp-04h],0ah;	lColor

; 794         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 795         break;
	jmp	@BLBL192
	align 04h
@BLBL195:

; 796       case CLR_BDBLUE:
; 797         lColor = CLR_DARKBLUE;
	mov	dword ptr [ebp-04h],09h;	lColor

; 798         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 799         break;
	jmp	@BLBL192
	align 04h
@BLBL196:

; 800       case CLR_BDGRAY:
; 801         lColor = CLR_DARKGRAY;
	mov	dword ptr [ebp-04h],08h;	lColor

; 802         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 803         break;
	jmp	@BLBL192
	align 04h
@BLBL197:

; 804       case CLR_BDPINK:
; 805         lColor = CLR_DARKPINK;
	mov	dword ptr [ebp-04h],0bh;	lColor

; 806         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 807         break;
	jmp	@BLBL192
	align 04h
@BLBL198:

; 808       case CLR_BPINK:
; 809         lColor = CLR_PINK;
	mov	dword ptr [ebp-04h],03h;	lColor

; 810         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 811         break;
	jmp	@BLBL192
	align 04h
@BLBL199:

; 812       case CLR_BDGREEN:
; 813         lColor = CLR_DARKGREEN;
	mov	dword ptr [ebp-04h],0ch;	lColor

; 814         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 815         break;
	jmp	@BLBL192
	align 04h
@BLBL200:

; 816       case CLR_BRED:
; 817         lColor = CLR_RED;
	mov	dword ptr [ebp-04h],02h;	lColor

; 818         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 819         break;
	jmp	@BLBL192
	align 04h
@BLBL201:

; 820       case CLR_BBLUE:
; 821         lColor = CLR_BLUE;
	mov	dword ptr [ebp-04h],01h;	lColor

; 822         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 823         break;
	jmp	@BLBL192
	align 04h
@BLBL202:

; 824       case CLR_BGRAY:
; 825         lColor = CLR_PALEGRAY;
	mov	dword ptr [ebp-04h],0fh;	lColor

; 826         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 827         break;
	jmp	@BLBL192
	align 04h
@BLBL203:

; 828       case CLR_BGREEN:
; 829         lColor = CLR_GREEN;
	mov	dword ptr [ebp-04h],04h;	lColor

; 830         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 831         break;
	jmp	@BLBL192
	align 04h
@BLBL204:

; 832       case CLR_BCYAN:
; 833         lColor = CLR_CYAN;
	mov	dword ptr [ebp-04h],05h;	lColor

; 834         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 835         break;
	jmp	@BLBL192
	align 04h
@BLBL205:

; 836       case CLR_BDCYAN:
; 837         lColor = CLR_DARKCYAN;
	mov	dword ptr [ebp-04h],0dh;	lColor

; 838         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 839         break;
	jmp	@BLBL192
	align 04h
@BLBL206:

; 840       case CLR_BYELLOW:
; 841         lColor = CLR_YELLOW;
	mov	dword ptr [ebp-04h],06h;	lColor

; 842         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 843         break;
	jmp	@BLBL192
	align 04h
@BLBL207:

; 844       case CLR_BBROWN:
; 845         lColor = CLR_BROWN;
	mov	dword ptr [ebp-04h],0eh;	lColor

; 846         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 847         break;
	jmp	@BLBL192
	align 04h
@BLBL208:

; 848       case CLR_BWHITE:
; 849         lColor = CLR_WHITE;
	mov	dword ptr [ebp-04h],0fffffffeh;	lColor

; 850         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 851         break;
	jmp	@BLBL192
	align 04h
@BLBL209:

; 852       case CLR_BBLACK:
; 853         lColor = CLR_BLACK;
	mov	dword ptr [ebp-04h],0ffffffffh;	lColor

; 854         bBackground = TRUE;
	mov	dword ptr [ebp-08h],01h;	bBackground

; 855         break;
	jmp	@BLBL192
	align 04h
@BLBL210:

; 856       case CLR_FDRED:
; 857         lColor = CLR_DARKRED;
	mov	dword ptr [ebp-04h],0ah;	lColor

; 858         break;
	jmp	@BLBL192
	align 04h
@BLBL211:

; 859       case CLR_FDBLUE:
; 860         lColor = CLR_DARKBLUE;
	mov	dword ptr [ebp-04h],09h;	lColor

; 861         break;
	jmp	@BLBL192
	align 04h
@BLBL212:

; 862       case CLR_FDPINK:
; 863         lColor = CLR_DARKPINK;
	mov	dword ptr [ebp-04h],0bh;	lColor

; 864         break;
	jmp	@BLBL192
	align 04h
@BLBL213:

; 865       case CLR_FPINK:
; 866         lColor = CLR_PINK;
	mov	dword ptr [ebp-04h],03h;	lColor

; 867         break;
	jmp	@BLBL192
	align 04h
@BLBL214:

; 868       case CLR_FDGRAY:
; 869         lColor = CLR_DARKGRAY;
	mov	dword ptr [ebp-04h],08h;	lColor

; 870         break;
	jmp	@BLBL192
	align 04h
@BLBL215:

; 871       case CLR_FDGREEN:
; 872         lColor = CLR_DARKGREEN;
	mov	dword ptr [ebp-04h],0ch;	lColor

; 873         break;
	jmp	@BLBL192
	align 04h
@BLBL216:

; 874       case CLR_FRED:
; 875         lColor = CLR_RED;
	mov	dword ptr [ebp-04h],02h;	lColor

; 876         break;
	jmp	@BLBL192
	align 04h
@BLBL217:

; 877       case CLR_FBLUE:
; 878         lColor = CLR_BLUE;
	mov	dword ptr [ebp-04h],01h;	lColor

; 879         break;
	jmp	@BLBL192
	align 04h
@BLBL218:

; 880       case CLR_FGRAY:
; 881         lColor = CLR_PALEGRAY;
	mov	dword ptr [ebp-04h],0fh;	lColor

; 882         break;
	jmp	@BLBL192
	align 04h
@BLBL219:

; 883       case CLR_FGREEN:
; 884         lColor = CLR_GREEN;
	mov	dword ptr [ebp-04h],04h;	lColor

; 885         break;
	jmp	@BLBL192
	align 04h
@BLBL220:

; 886       case CLR_FCYAN:
; 887         lColor = CLR_CYAN;
	mov	dword ptr [ebp-04h],05h;	lColor

; 888         break;
	jmp	@BLBL192
	align 04h
@BLBL221:

; 889       case CLR_FDCYAN:
; 890         lColor = CLR_DARKCYAN;
	mov	dword ptr [ebp-04h],0dh;	lColor

; 891         break;
	jmp	@BLBL192
	align 04h
@BLBL222:

; 892       case CLR_FYELLOW:
; 893         lColor = CLR_YELLOW;
	mov	dword ptr [ebp-04h],06h;	lColor

; 894         break;
	jmp	@BLBL192
	align 04h
@BLBL223:

; 895       case CLR_FBROWN:
; 896         lColor = CLR_BROWN;
	mov	dword ptr [ebp-04h],0eh;	lColor

; 897         break;
	jmp	@BLBL192
	align 04h
@BLBL224:

; 898       case CLR_FWHITE:
; 899         lColor = CLR_WHITE;
	mov	dword ptr [ebp-04h],0fffffffeh;	lColor

; 900         break;
	jmp	@BLBL192
	align 04h
@BLBL225:

; 901       case CLR_FBLACK:
; 902         lColor = CLR_BLACK;
	mov	dword ptr [ebp-04h],0ffffffffh;	lColor

; 903         break;
	jmp	@BLBL192
	align 04h
@BLBL226:

; 904       default:
; 905         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL192
	align 04h
@BLBL193:
	cmp	eax,014d3h
	je	@BLBL194
	cmp	eax,014d2h
	je	@BLBL195
	cmp	eax,014d1h
	je	@BLBL196
	cmp	eax,014d4h
	je	@BLBL197
	cmp	eax,014cbh
	je	@BLBL198
	cmp	eax,014d5h
	je	@BLBL199
	cmp	eax,014cah
	je	@BLBL200
	cmp	eax,014c9h
	je	@BLBL201
	cmp	eax,014d7h
	je	@BLBL202
	cmp	eax,014cch
	je	@BLBL203
	cmp	eax,014cdh
	je	@BLBL204
	cmp	eax,014d6h
	je	@BLBL205
	cmp	eax,014ceh
	je	@BLBL206
	cmp	eax,014cfh
	je	@BLBL207
	cmp	eax,014c7h
	je	@BLBL208
	cmp	eax,014c8h
	je	@BLBL209
	cmp	eax,014c2h
	je	@BLBL210
	cmp	eax,014c1h
	je	@BLBL211
	cmp	eax,014c3h
	je	@BLBL212
	cmp	eax,014bah
	je	@BLBL213
	cmp	eax,014c0h
	je	@BLBL214
	cmp	eax,014c4h
	je	@BLBL215
	cmp	eax,014b9h
	je	@BLBL216
	cmp	eax,014b8h
	je	@BLBL217
	cmp	eax,014c6h
	je	@BLBL218
	cmp	eax,014bbh
	je	@BLBL219
	cmp	eax,014bch
	je	@BLBL220
	cmp	eax,014c5h
	je	@BLBL221
	cmp	eax,014bdh
	je	@BLBL222
	cmp	eax,014beh
	je	@BLBL223
	cmp	eax,014b6h
	je	@BLBL224
	cmp	eax,014b7h
	je	@BLBL225
	jmp	@BLBL226
	align 04h
@BLBL192:

; 906       }
; 907     if (!bBackground)
	cmp	dword ptr [ebp-08h],0h;	bBackground
	jne	@BLBL190

; 908       {
; 909       *plForegrndColor = lColor;
	mov	eax,[ebp+014h];	plForegrndColor
	mov	ecx,[ebp-04h];	lColor
	mov	[eax],ecx

; 910       WinSetPresParam(hwndSample,PP_FOREGROUNDCOLORINDEX,4,plForegrndColor);
	push	dword ptr [ebp+014h];	plForegrndColor
	push	04h
	push	02h
	push	dword ptr [ebp+0ch];	hwndSample
	call	WinSetPresParam
	add	esp,010h

; 911       }
	jmp	@BLBL189
	align 010h
@BLBL190:

; 912     else
; 913       {
; 914       *plBackgrndColor = lColor;
	mov	eax,[ebp+018h];	plBackgrndColor
	mov	ecx,[ebp-04h];	lColor
	mov	[eax],ecx

; 915       WinSetPresParam(hwndSample,PP_BACKGROUNDCOLORINDEX,4,plBackgrndColor);
	push	dword ptr [ebp+018h];	plBackgrndColor
	push	04h
	push	04h
	push	dword ptr [ebp+0ch];	hwndSample
	call	WinSetPresParam
	add	esp,010h

; 916       }

; 917     }
@BLBL189:

; 918   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
TCColorDlg	endp

; 922   {
	align 010h

	public FillSetColorDlg
FillSetColorDlg	proc
	push	ebp
	mov	ebp,esp

; 924   switch (lBackground)
	mov	eax,[ebp+010h];	lBackground
	jmp	@BLBL228
	align 04h
@BLBL229:

; 925     {
; 926     case CLR_WHITE:
; 927       CheckButton(hwnd,CLR_BWHITE,TRUE);
	push	01h
	push	014c7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 928       break;
	jmp	@BLBL227
	align 04h
@BLBL230:

; 929     case CLR_BLACK:
; 930       CheckButton(hwnd,CLR_BBLACK,TRUE);
	push	01h
	push	014c8h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 931       break;
	jmp	@BLBL227
	align 04h
@BLBL231:

; 932     case CLR_DARKBLUE:
; 933       CheckButton(hwnd,CLR_BDBLUE,TRUE);
	push	01h
	push	014d2h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 934       break;
	jmp	@BLBL227
	align 04h
@BLBL232:

; 935     case CLR_BLUE:
; 936       CheckButton(hwnd,CLR_BBLUE,TRUE);
	push	01h
	push	014c9h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 937       break;
	jmp	@BLBL227
	align 04h
@BLBL233:

; 938     case CLR_RED:
; 939       CheckButton(hwnd,CLR_BRED,TRUE);
	push	01h
	push	014cah
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 940       break;
	jmp	@BLBL227
	align 04h
@BLBL234:

; 941     case CLR_GREEN:
; 942       CheckButton(hwnd,CLR_BGREEN,TRUE);
	push	01h
	push	014cch
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 943       break;
	jmp	@BLBL227
	align 04h
@BLBL235:

; 944     case CLR_PINK:
; 945       CheckButton(hwnd,CLR_BPINK,TRUE);
	push	01h
	push	014cbh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 946       break;
	jmp	@BLBL227
	align 04h
@BLBL236:

; 947     case CLR_DARKCYAN:
; 948       CheckButton(hwnd,CLR_BDCYAN,TRUE);
	push	01h
	push	014d6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 949       break;
	jmp	@BLBL227
	align 04h
@BLBL237:

; 950     case CLR_CYAN:
; 951       CheckButton(hwnd,CLR_BCYAN,TRUE);
	push	01h
	push	014cdh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 952       break;
	jmp	@BLBL227
	align 04h
@BLBL238:

; 953     case CLR_YELLOW:
; 954       CheckButton(hwnd,CLR_BYELLOW,TRUE);
	push	01h
	push	014ceh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 955       break;
	jmp	@BLBL227
	align 04h
@BLBL239:

; 956     case CLR_PALEGRAY:
; 957       CheckButton(hwnd,CLR_BGRAY,TRUE);
	push	01h
	push	014d7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 958       break;
	jmp	@BLBL227
	align 04h
@BLBL240:

; 959     case CLR_DARKGREEN:
; 960       CheckButton(hwnd,CLR_BDGREEN,TRUE);
	push	01h
	push	014d5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 961       break;
	jmp	@BLBL227
	align 04h
@BLBL241:

; 962     case CLR_DARKRED:
; 963       CheckButton(hwnd,CLR_BDRED,TRUE);
	push	01h
	push	014d3h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 964       break;
	jmp	@BLBL227
	align 04h
@BLBL242:

; 965     case CLR_DARKPINK:
; 966       CheckButton(hwnd,CLR_BDPINK,TRUE);
	push	01h
	push	014d4h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 967       break;
	jmp	@BLBL227
	align 04h
@BLBL243:

; 968     case CLR_BROWN:
; 969       CheckButton(hwnd,CLR_BBROWN,TRUE);
	push	01h
	push	014cfh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 970       break;
	jmp	@BLBL227
	align 04h
@BLBL244:

; 971     case CLR_DARKGRAY:
; 972       CheckButton(hwnd,CLR_BDGRAY,TRUE);
	push	01h
	push	014d1h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 973       break;
	jmp	@BLBL227
	align 04h
	jmp	@BLBL227
	align 04h
@BLBL228:
	cmp	eax,0fffffffeh
	je	@BLBL229
	cmp	eax,0ffffffffh
	je	@BLBL230
	cmp	eax,09h
	je	@BLBL231
	cmp	eax,01h
	je	@BLBL232
	cmp	eax,02h
	je	@BLBL233
	cmp	eax,04h
	je	@BLBL234
	cmp	eax,03h
	je	@BLBL235
	cmp	eax,0dh
	je	@BLBL236
	cmp	eax,05h
	je	@BLBL237
	cmp	eax,06h
	je	@BLBL238
	cmp	eax,0fh
	je	@BLBL239
	cmp	eax,0ch
	je	@BLBL240
	cmp	eax,0ah
	je	@BLBL241
	cmp	eax,0bh
	je	@BLBL242
	cmp	eax,0eh
	je	@BLBL243
	cmp	eax,08h
	je	@BLBL244
@BLBL227:

; 974     }
; 975 
; 976   switch (lForeground)
	mov	eax,[ebp+0ch];	lForeground
	jmp	@BLBL246
	align 04h
@BLBL247:

; 977     {
; 978     case CLR_WHITE:
; 979       CheckButton(hwnd,CLR_FWHITE,TRUE);
	push	01h
	push	014b6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 980       break;
	jmp	@BLBL245
	align 04h
@BLBL248:

; 981     case CLR_BLACK:
; 982       CheckButton(hwnd,CLR_FBLACK,TRUE);
	push	01h
	push	014b7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 983       break;
	jmp	@BLBL245
	align 04h
@BLBL249:

; 984     case CLR_DARKBLUE:
; 985       CheckButton(h
; 985 wnd,CLR_FDBLUE,TRUE);
	push	01h
	push	014c1h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 986       break;
	jmp	@BLBL245
	align 04h
@BLBL250:

; 987     case CLR_BLUE:
; 988       CheckButton(hwnd,CLR_FBLUE,TRUE);
	push	01h
	push	014b8h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 989       break;
	jmp	@BLBL245
	align 04h
@BLBL251:

; 990     case CLR_DARKRED:
; 991       CheckButton(hwnd,CLR_FDRED,TRUE);
	push	01h
	push	014c2h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 992       break;
	jmp	@BLBL245
	align 04h
@BLBL252:

; 993     case CLR_RED:
; 994       CheckButton(hwnd,CLR_FRED,TRUE);
	push	01h
	push	014b9h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 995       break;
	jmp	@BLBL245
	align 04h
@BLBL253:

; 996     case CLR_GREEN:
; 997       CheckButton(hwnd,CLR_FGREEN,TRUE);
	push	01h
	push	014bbh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 998       break;
	jmp	@BLBL245
	align 04h
@BLBL254:

; 999     case CLR_PINK:
; 1000       CheckButton(hwnd,CLR_FPINK,TRUE);
	push	01h
	push	014bah
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 1001       break;
	jmp	@BLBL245
	align 04h
@BLBL255:

; 1002     case CLR_DARKCYAN:
; 1003       CheckButton(hwnd,CLR_FDCYAN,TRUE);
	push	01h
	push	014c5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 1004       break;
	jmp	@BLBL245
	align 04h
@BLBL256:

; 1005     case CLR_CYAN:
; 1006       CheckButton(hwnd,CLR_FCYAN,TRUE);
	push	01h
	push	014bch
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 1007       break;
	jmp	@BLBL245
	align 04h
@BLBL257:

; 1008     case CLR_YELLOW:
; 1009       CheckButton(hwnd,CLR_FYELLOW,TRUE);
	push	01h
	push	014bdh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 1010       break;
	jmp	@BLBL245
	align 04h
@BLBL258:

; 1011     case CLR_PALEGRAY:
; 1012       CheckButton(hwnd,CLR_FGRAY,TRUE);
	push	01h
	push	014c6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 1013       break;
	jmp	@BLBL245
	align 04h
@BLBL259:

; 1014     case CLR_DARKGREEN:
; 1015       CheckButton(hwnd,CLR_FDGREEN,TRUE);
	push	01h
	push	014c4h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 1016       break;
	jmp	@BLBL245
	align 04h
@BLBL260:

; 1017     case CLR_BROWN:
; 1018       CheckButton(hwnd,CLR_FBROWN,TRUE);
	push	01h
	push	014beh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 1019       break;
	jmp	@BLBL245
	align 04h
@BLBL261:

; 1020     case CLR_DARKGRAY:
; 1021       CheckButton(hwnd,CLR_FDGRAY,TRUE);
	push	01h
	push	014c0h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch

; 1022       break;
	jmp	@BLBL245
	align 04h
	jmp	@BLBL245
	align 04h
@BLBL246:
	cmp	eax,0fffffffeh
	je	@BLBL247
	cmp	eax,0ffffffffh
	je	@BLBL248
	cmp	eax,09h
	je	@BLBL249
	cmp	eax,01h
	je	@BLBL250
	cmp	eax,0ah
	je	@BLBL251
	cmp	eax,02h
	je	@BLBL252
	cmp	eax,04h
	je	@BLBL253
	cmp	eax,03h
	je	@BLBL254
	cmp	eax,0dh
	je	@BLBL255
	cmp	eax,05h
	je	@BLBL256
	cmp	eax,06h
	je	@BLBL257
	cmp	eax,0fh
	je	@BLBL258
	cmp	eax,0ch
	je	@BLBL259
	cmp	eax,0eh
	je	@BLBL260
	cmp	eax,08h
	je	@BLBL261
@BLBL245:

; 1023     }
; 1024   }
	mov	esp,ebp
	pop	ebp
	ret	
FillSetColorDlg	endp

; 1027   {
	align 010h

	public fnwpEventDispDlgProc
fnwpEventDispDlgProc	proc
	push	ebp
	mov	ebp,esp

; 1031   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL304
	align 04h
@BLBL305:

; 1032     {
; 1033     case WM_INITDLG:
; 1034 //      CenterDlgBox(hwndDlg);
; 1035       WinSetFocus(HWND_DESKTOP,hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinSetFocus
	add	esp,08h

; 1036       pstCFG = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @c7pstCFG,eax

; 1037       if (pstCFG->bDispModemIn)
	mov	eax,dword ptr  @c7pstCFG
	test	byte ptr [eax+01ch],01h
	je	@BLBL262

; 1038         CheckButton(hwndDlg,EVENT_MODEMIN,TRUE);
	push	01h
	push	01b5ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL262:

; 1039       if (pstCFG->bDispModemOut)
	mov	eax,dword ptr  @c7pstCFG
	test	byte ptr [eax+01ch],02h
	je	@BLBL263

; 1040         CheckButton(hwndDlg,EVENT_MODEMOUT,TRUE);
	push	01h
	push	01b5dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL263:

; 1041       if (pstCFG->bDispWriteReq)
	mov	eax,dword ptr  @c7pstCFG
	test	byte ptr [eax+01ch],08h
	je	@BLBL264

; 1042         CheckButton(hwndDlg,EVENT_WRITE_REQ,TRUE);
	push	01h
	push	01b5fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL264:

; 1043       if (pstCFG->bDispReadReq)
	mov	eax,dword ptr  @c7pstCFG
	test	byte ptr [eax+01ch],010h
	je	@BLBL265

; 1044         CheckButton(hwndDlg,EVENT_READ_REQ,TRUE);
	push	01h
	push	01b60h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL265:

; 1045       if (pstCFG->bPopupParams)
	mov	eax,dword ptr  @c7pstCFG
	test	byte ptr [eax+019h],040h
	je	@BLBL266

; 1046         CheckButton(hwndDlg,EVENT_POPUP_PARAMS,TRUE);
	push	01h
	push	01b66h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL266:

; 1047       if (pstCFG->bDispDevIOctl)
	mov	eax,dword ptr  @c7pstCFG
	test	byte ptr [eax+01ch],020h
	je	@BLBL267

; 1048         CheckButton(hwndDlg,EVENT_DEVIOCTL,TRUE);
	push	01h
	push	01b61h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL267:

; 1049       if (pstCFG->bDispErrors)
	mov	eax,dword ptr  @c7pstCFG
	test	byte ptr [eax+01ch],040h
	je	@BLBL268

; 1050         CheckButton(hwndDlg,EVENT_ERRORS,TRUE);
	push	01h
	push	01b65h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL268:

; 1051       if (pstCFG->bDispOpen)
	mov	eax,dword ptr  @c7pstCFG
	test	byte ptr [eax+01ch],04h
	je	@BLBL269

; 1052         CheckButton(hwndDlg,EVENT_OPEN,TRUE);
	push	01h
	push	01b5eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL269:

; 1053       if (pstCFG->bDispRead)
	mov	eax,dword ptr  @c7pstCFG
	test	byte ptr [eax+01bh],040h
	je	@BLBL270

; 1054         CheckButton(hwndDlg,EVENT_RCV,TRUE);
	push	01h
	push	01b59h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL270:

; 1055       if (pstCFG->bDispWrite)
	mov	eax,dword ptr  @c7pstCFG
	test	byte ptr [eax+01bh],020h
	je	@BLBL271

; 1056         CheckButton(hwndDlg,EVENT_XMIT,TRUE);
	push	01h
	push	01b5ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL271:

; 1057       if (pstCFG->bDispIMM)
	mov	eax,dword ptr  @c7pstCFG
	test	byte ptr [eax+01bh],080h
	je	@BLBL272

; 1058         CheckButton(hwndDlg,EVENT_IMM,TRUE);
	push	01h
	push	01b5bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL272:

; 1059       if (pstCFG->bHiLightImmediateByte)
	mov	eax,dword ptr  @c7pstCFG
	test	byte ptr [eax+018h],08h
	je	@BLBL273

; 1060         CheckButton(hwndDlg,EVENT_DISP_HILIGHT,TRUE);
	push	01h
	push	01b62h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL273:

; 1061 /*
; 1062 **  changed to set current line mark instead of compress display
; 1063 **  compress display is going away
; 1064 */
; 1065       if (pstCFG->bMarkCurrentLine)
	mov	eax,dword ptr  @c7pstCFG
	test	byte ptr [eax+01eh],040h
	je	@BLBL274

; 1066         CheckButton(hwndDlg,EVENT_DISP_COMPRESS,TRUE);
	push	01h
	push	01b63h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL274:

; 1067       return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL306:

; 1068     case WM_COMMAND:
; 1069       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL308
	align 04h
@BLBL309:

; 1070         {
; 1071         case PB_ALL:
; 1072           CheckButton(hwndDlg,EVENT_MODEMIN,TRUE);
	push	01h
	push	01b5ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1073           CheckButton(hwndDlg,EVENT_MODEMOUT,TRUE);
	push	01h
	push	01b5dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1074           CheckButton(hwndDlg,EVENT_WRITE_REQ,TRUE);
	push	01h
	push	01b5fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1075           CheckButton(hwndDlg,EVENT_READ_REQ,TRUE);
	push	01h
	push	01b60h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1076           CheckButton(hwndDlg,EVENT_POPUP_PARAMS,TRUE);
	push	01h
	push	01b66h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1077           CheckButton(hwndDlg,EVENT_DEVIOCTL,TRUE);
	push	01h
	push	01b61h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1078           CheckButton(hwndDlg,EVENT_ERRORS,TRUE);
	push	01h
	push	01b65h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1079           CheckButton(hwndDlg,EVENT_OPEN,TRUE);
	push	01h
	push	01b5eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1080           CheckButton(hwndDlg,EVENT_RCV,TRUE);
	push	01h
	push	01b59h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1081           CheckButton(hwndDlg,EVENT_XMIT,TRUE);
	push	01h
	push	01b5ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1082           CheckButton(hwndDlg,EVENT_IMM,TRUE);
	push	01h
	push	01b5bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1083           break;
	jmp	@BLBL307
	align 04h
@BLBL310:

; 1084         case DID_OK:
; 1085           if (Checked(hwndDlg,EVENT_MODEMIN))
	push	01b5ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL275

; 1086             pstCFG->bDispModemIn = TRUE;
	mov	eax,dword ptr  @c7pstCFG
	or	byte ptr [eax+01ch],01h
	jmp	@BLBL276
	align 010h
@BLBL275:

; 1087           else
; 1088             pstCFG->bDispModemIn = FALSE;
	mov	eax,dword ptr  @c7pstCFG
	and	byte ptr [eax+01ch],0feh
@BLBL276:

; 1089 
; 1090           if (Checked(hwndDlg,EVENT_MODEMOUT))
	push	01b5dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL277

; 1091             pstCFG->bDispModemOut = TRUE;
	mov	eax,dword ptr  @c7pstCFG
	or	byte ptr [eax+01ch],02h
	jmp	@BLBL278
	align 010h
@BLBL277:

; 1092           else
; 1093             pstCFG->bDispModemOut = FALSE;
	mov	eax,dword ptr  @c7pstCFG
	and	byte ptr [eax+01ch],0fdh
@BLBL278:

; 1094 
; 1095           if (Checked(hwndDlg,EVENT_WRITE_REQ))
	push	01b5fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL279

; 1096             pstCFG->bDispWriteReq = TRUE;
	mov	eax,dword ptr  @c7pstCFG
	or	byte ptr [eax+01ch],08h
	jmp	@BLBL280
	align 010h
@BLBL279:

; 1097           else
; 1098             pstCFG->bDispWriteReq = FALSE;
	mov	eax,dword ptr  @c7pstCFG
	and	byte ptr [eax+01ch],0f7h
@BLBL280:

; 1099 
; 1100           if (Checked(hwndDlg,EVENT_READ_REQ))
	push	01b60h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL281

; 1101             pstCFG->bDispReadReq = TRUE;
	mov	eax,dword ptr  @c7pstCFG
	or	byte ptr [eax+01ch],010h
	jmp	@BLBL282
	align 010h
@BLBL281:

; 1102           else
; 1103             pstCFG->bDispReadReq = FALSE;
	mov	eax,dword ptr  @c7pstCFG
	and	byte ptr [eax+01ch],0efh
@BLBL282:

; 1104 
; 1105           if (Checked(hwndDlg,EVENT_DEVIOCTL))
	push	01b61h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL283

; 1106             pstCFG->bDispDevIOctl = TRUE;
	mov	eax,dword ptr  @c7pstCFG
	or	byte ptr [eax+01ch],020h
	jmp	@BLBL284
	align 010h
@BLBL283:

; 1107           else
; 1108             pstCFG->bDispDevIOctl = FALSE;
	mov	eax,dword ptr  @c7pstCFG
	and	byte ptr [eax+01ch],0dfh
@BLBL284:

; 1109 
; 1110           if (Checked(hwndDlg,EVENT_POPUP_PARAMS))
	push	01b66h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL285

; 1111             pstCFG->bPopupParams = TRUE;
	mov	eax,dword ptr  @c7pstCFG
	or	byte ptr [eax+019h],040h
	jmp	@BLBL286
	align 010h
@BLBL285:

; 1112           else
; 1113             pstCFG->bPopupParams = FALSE;
	mov	eax,dword ptr  @c7pstCFG
	and	byte ptr [eax+019h],0bfh
@BLBL286:

; 1114 
; 1115           if (Checked(hwndDlg,EVENT_ERRORS))
	push	01b65h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL287

; 1116             pstCFG->bDispErrors = TRUE;
	mov	eax,dword ptr  @c7pstCFG
	or	byte ptr [eax+01ch],040h
	jmp	@BLBL288
	align 010h
@BLBL287:

; 1117           else
; 1118             pstCFG->bDispErrors = FALSE;
	mov	eax,dword ptr  @c7pstCFG
	and	byte ptr [eax+01ch],0bfh
@BLBL288:

; 1119 
; 1120           if (Checked(hwndDlg,EVENT_OPEN))
	push	01b5eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL289

; 1121             pstCFG->bDispOpen = TRUE;
	mov	eax,dword ptr  @c7pstCFG
	or	byte ptr [eax+01ch],04h
	jmp	@BLBL290
	align 010h
@BLBL289:

; 1122           else
; 1123             pstCFG->bDispOpen = FALSE;
	mov	eax,dword ptr  @c7pstCFG
	and	byte ptr [eax+01ch],0fbh
@BLBL290:

; 1124 
; 1125           if (Checked(hwndDlg,EVENT_RCV))
	push	01b59h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL291

; 1126             pstCFG->bDispRead = TRUE;
	mov	eax,dword ptr  @c7pstCFG
	or	byte ptr [eax+01bh],040h
	jmp	@BLBL292
	align 010h
@BLBL291:

; 1127           else
; 1128             pstCFG->bDispRead = FALSE;
	mov	eax,dword ptr  @c7pstCFG
	and	byte ptr [eax+01bh],0bfh
@BLBL292:

; 1129 
; 1130           if (Checked(hwndDlg,EVENT_XMIT))
	push	01b5ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL293

; 1131             pstCFG->bDispWrite = TRUE;
	mov	eax,dword ptr  @c7pstCFG
	or	byte ptr [eax+01bh],020h
	jmp	@BLBL294
	align 010h
@BLBL293:

; 1132           else
; 1133             pstCFG->bDispWrite = FALSE;
	mov	eax,dword ptr  @c7pstCFG
	and	byte ptr [eax+01bh],0dfh
@BLBL294:

; 1134 
; 1135           if (Checked(hwndDlg,EVENT_IMM))
	push	01b5bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL295

; 1136             pstCFG->bDispIMM = TRUE;
	mov	eax,dword ptr  @c7pstCFG
	or	byte ptr [eax+01bh],080h
	jmp	@BLBL296
	align 010h
@BLBL295:

; 1137           else
; 1138             pstCFG->bDispIMM = FALSE;
	mov	eax,dword ptr  @c7pstCFG
	and	byte ptr [eax+01bh],07fh
@BLBL296:

; 1139 
; 1140           if (Checked(hwndDlg,EVENT_DISP_COMPRESS))
	push	01b63h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL297

; 1141             pstCFG->bMarkCurrentLine = TRUE;
	mov	eax,dword ptr  @c7pstCFG
	or	byte ptr [eax+01eh],040h
	jmp	@BLBL298
	align 010h
@BLBL297:

; 1142           else
; 1143             pstCFG->bMarkCurrentLine = FALSE;
	mov	eax,dword ptr  @c7pstCFG
	and	byte ptr [eax+01eh],0bfh
@BLBL298:

; 1144 
; 1145           if (Checked(hwndDlg,EVENT_DISP_HILIGHT))
	push	01b62h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL299

; 1146             pstCFG->bHiLightImmediateByte = TRUE;
	mov	eax,dword ptr  @c7pstCFG
	or	byte ptr [eax+018h],08h
	jmp	@BLBL300
	align 010h
@BLBL299:

; 1147           else
; 1148             pstCFG->bHiLightImmediateByte = FALSE;
	mov	eax,dword ptr  @c7pstCFG
	and	byte ptr [eax+018h],0f7h
@BLBL300:

; 1149           if (pstCFG->fDisplaying & (DISP_DATA | DISP_FILE))
	mov	eax,dword ptr  @c7pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL301

; 1150             {
; 1151             if (!pstCFG->bColumnDisplay)
	mov	eax,dword ptr  @c7pstCFG
	test	byte ptr [eax+018h],080h
	jne	@BLBL301

; 1152               {
; 1153               SetupRowScrolling(&stRow);
	push	offset FLAT:stRow
	call	SetupRowScrolling
	add	esp,04h

; 1154               WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 1155               }

; 1156             }
@BLBL301:

; 1157           WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 1158           return(MRESULT)TRUE;
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL311:

; 1159         case DID_HELP:
; 1160           DisplayHelpPanel(HLPP_TIME_DISP_DLG);
	push	075f9h
	call	DisplayHelpPanel
	add	esp,04h

; 1161           return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL312:

; 1162         case DID_CANCEL:
; 1163           WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 1164           break;
	jmp	@BLBL307
	align 04h
@BLBL313:

; 1165         default:
; 1166           return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
	jmp	@BLBL307
	align 04h
@BLBL308:
	cmp	eax,04a4eh
	je	@BLBL309
	cmp	eax,01h
	je	@BLBL310
	cmp	eax,012dh
	je	@BLBL311
	cmp	eax,02h
	je	@BLBL312
	jmp	@BLBL313
	align 04h
@BLBL307:

; 1167         }
; 1168       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL303
	align 04h
@BLBL304:
	cmp	eax,03bh
	je	@BLBL305
	cmp	eax,020h
	je	@BLBL306
@BLBL303:

; 1169     }
; 1170   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
fnwpEventDispDlgProc	endp

; 1174   {
	align 010h

	public fnwpTraceEventDlgProc
fnwpTraceEventDlgProc	proc
	push	ebp
	mov	ebp,esp
	sub	esp,030h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,0ch
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 1178   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL338
	align 04h
@BLBL339:

; 1179     {
; 1180     case WM_INITDLG:
; 1181 //      CenterDlgBox(hwndDlg);
; 1182       WinSetFocus(HWND_DESKTOP,hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinSetFocus
	add	esp,08h

; 1183       pstCFG = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @ddpstCFG,eax

; 1184       if (pstCFG->fTraceEvent & CSFUNC_TRACE_MODEM_IN_SIGNALS)
	mov	eax,dword ptr  @ddpstCFG
	test	byte ptr [eax+01fh],010h
	je	@BLBL314

; 1185         CheckButton(hwndDlg,TRACE_MODEM_IN,TRUE);
	push	01h
	push	01f44h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL314:

; 1186 
; 1187       if (pstCFG->fTraceEvent & CSFUNC_TRACE_MODEM_OUT_SIGNALS)
	mov	eax,dword ptr  @ddpstCFG
	test	byte ptr [eax+01fh],020h
	je	@BLBL315

; 1188         CheckButton(hwndDlg,TRACE_MODEM_OUT,TRUE);
	push	01h
	push	01f45h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL315:

; 1189 
; 1190       if (pstCFG->fTraceEvent & CSFUNC_TRACE_OPEN)
	mov	eax,dword ptr  @ddpstCFG
	test	byte ptr [eax+020h],01h
	je	@BLBL316

; 1191         CheckButton(hwndDlg,TRACE_OPEN_CLOSE,TRUE);
	push	01h
	push	01f46h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL316:

; 1192 
; 1193       if (pstCFG->fTraceEvent & CSFUNC_TRACE_ERRORS)
	mov	eax,dword ptr  @ddpstCFG
	test	byte ptr [eax+01fh],080h
	je	@BLBL317

; 1194         CheckButton(hwndDlg,TRACE_ERRORS,TRUE);
	push	01h
	push	01f4ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL317:

; 1195 
; 1196       if (pstCFG->fTraceEvent & CSFUNC_TRACE_WRITE)
	mov	eax,dword ptr  @ddpstCFG
	test	byte ptr [eax+020h],08h
	je	@BLBL318

; 1197         CheckButton(hwndDlg,TRACE_WRITE_REQ,TRUE);
	push	01h
	push	01f47h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL318:

; 1198 
; 1199       if (pstCFG->fTraceEvent & CSFUNC_TRACE_READ)
	mov	eax,dword ptr  @ddpstCFG
	test	byte ptr [eax+020h],04h
	je	@BLBL319

; 1200         CheckButton(hwndDlg,TRACE_READ_REQ,TRUE);
	push	01h
	push	01f48h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL319:

; 1201 
; 1202       if (pstCFG->fTraceEvent & CSFUNC_TRACE_INCLUDE_PACKET)
	mov	eax,dword ptr  @ddpstCFG
	test	byte ptr [eax+020h],040h
	je	@BLBL320

; 1203         CheckButton(hwndDlg,TRACE_FUNC_PARAMS,TRUE);
	push	01h
	push	01f4bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL320:

; 1204 
; 1205       if (pstCFG->fTraceEvent & CSFUNC_TRACE_DEVIOCTL)
	mov	eax,dword ptr  @ddpstCFG
	test	byte ptr [eax+01fh],040h
	je	@BLBL321

; 1206         CheckButton(hwndDlg,TRACE_DEVIOCTL,TRUE);
	push	01h
	push	01f49h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL321:

; 1207 
; 1208       if (pstCFG->fTraceEvent & CSFUNC_TRACE_IMM_STREAM)
	mov	eax,dword ptr  @ddpstCFG
	test	byte ptr [eax+01fh],08h
	je	@BLBL322

; 1209         CheckButton(hwndDlg,TRACE_IMM,TRUE);
	push	01h
	push	01f43h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL322:

; 1210 
; 1211       if (pstCFG->fTraceEvent & CSFUNC_TRACE_INPUT_STREAM)
	mov	eax,dword ptr  @ddpstCFG
	test	byte ptr [eax+01fh],02h
	je	@BLBL323

; 1212         CheckButton(hwndDlg,TRACE_RCV,TRUE);
	push	01h
	push	01f41h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL323:

; 1213 
; 1214       if (pstCFG->fTraceEvent & CSFUNC_TRACE_OUTPUT_STREAM)
	mov	eax,dword ptr  @ddpstCFG
	test	byte ptr [eax+01fh],04h
	je	@BLBL324

; 1215         CheckButton(hwndDlg,TRACE_XMIT,TRUE);
	push	01h
	push	01f42h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL324:

; 1216       return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL340:

; 1217     case WM_COMMAND:
; 1218       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL342
	align 04h
@BLBL343:

; 1219         {
; 1220         case PB_ALL:
; 1221           CheckButton(hwndDlg,TRACE_MODEM_IN,TRUE);
	push	01h
	push	01f44h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1222           CheckButton(hwndDlg,TRACE_MODEM_OUT,TRUE);
	push	01h
	push	01f45h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1223           CheckButton(hwndDlg,TRACE_OPEN_CLOSE,TRUE);
	push	01h
	push	01f46h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1224           CheckButton(hwndDlg,TRACE_ERRORS,TRUE);
	push	01h
	push	01f4ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1225           CheckButton(hwndDlg,TRACE_WRITE_REQ,TRUE);
	push	01h
	push	01f47h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1226           CheckButton(hwndDlg,TRACE_READ_REQ,TRUE);
	push	01h
	push	01f48h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1227           CheckButton(hwndDlg,TRACE_FUNC_PARAMS,TRUE);
	push	01h
	push	01f4bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1228           CheckButton(hwndDlg,TRACE_DEVIOCTL,TRUE);
	push	01h
	push	01f49h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1229           CheckButton(hwndDlg,TRACE_IMM,TRUE);
	push	01h
	push	01f43h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1230           CheckButton(hwndDlg,TRACE_RCV,TRUE);
	push	01h
	push	01f41h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1231           CheckButton(hwndDlg,TRACE_XMIT,TRUE);
	push	01h
	push	01f42h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1232           return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL344:

; 1233         case DID_OK:
; 1234           pstCFG->fTraceEvent &= ~CSFUNC_TRACE_STREAMS_MASK;
	mov	eax,dword ptr  @ddpstCFG
	mov	[ebp-030h],eax;	@CBE78
	mov	eax,[ebp-030h];	@CBE78
	mov	ecx,[eax+01fh]
	and	ecx,0ffffb001h
	mov	[eax+01fh],ecx

; 1235         
; 1235   if (Checked(hwndDlg,TRACE_RCV))
	push	01f41h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL325

; 1236             pstCFG->fTraceEvent |= CSFUNC_TRACE_INPUT_STREAM;
	mov	eax,dword ptr  @ddpstCFG
	mov	[ebp-02ch],eax;	@CBE77
	mov	eax,[ebp-02ch];	@CBE77
	mov	ecx,[eax+01fh]
	or	cl,02h
	mov	[eax+01fh],ecx
@BLBL325:

; 1237 
; 1238           if (Checked(hwndDlg,TRACE_XMIT))
	push	01f42h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL326

; 1239             pstCFG->fTraceEvent |= CSFUNC_TRACE_OUTPUT_STREAM;
	mov	eax,dword ptr  @ddpstCFG
	mov	[ebp-028h],eax;	@CBE76
	mov	eax,[ebp-028h];	@CBE76
	mov	ecx,[eax+01fh]
	or	cl,04h
	mov	[eax+01fh],ecx
@BLBL326:

; 1240 
; 1241           if (Checked(hwndDlg,TRACE_IMM))
	push	01f43h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL327

; 1242             pstCFG->fTraceEvent |= CSFUNC_TRACE_IMM_STREAM;
	mov	eax,dword ptr  @ddpstCFG
	mov	[ebp-024h],eax;	@CBE75
	mov	eax,[ebp-024h];	@CBE75
	mov	ecx,[eax+01fh]
	or	cl,08h
	mov	[eax+01fh],ecx
@BLBL327:

; 1243 
; 1244           if (Checked(hwndDlg,TRACE_MODEM_IN))
	push	01f44h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL328

; 1245             pstCFG->fTraceEvent |= CSFUNC_TRACE_MODEM_IN_SIGNALS;
	mov	eax,dword ptr  @ddpstCFG
	mov	[ebp-020h],eax;	@CBE74
	mov	eax,[ebp-020h];	@CBE74
	mov	ecx,[eax+01fh]
	or	cl,010h
	mov	[eax+01fh],ecx
@BLBL328:

; 1246 
; 1247           if (Checked(hwndDlg,TRACE_MODEM_OUT))
	push	01f45h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL329

; 1248             pstCFG->fTraceEvent |= CSFUNC_TRACE_MODEM_OUT_SIGNALS;
	mov	eax,dword ptr  @ddpstCFG
	mov	[ebp-01ch],eax;	@CBE73
	mov	eax,[ebp-01ch];	@CBE73
	mov	ecx,[eax+01fh]
	or	cl,020h
	mov	[eax+01fh],ecx
@BLBL329:

; 1249 
; 1250           if (Checked(hwndDlg,TRACE_ERRORS))
	push	01f4ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL330

; 1251             pstCFG->fTraceEvent |= CSFUNC_TRACE_ERRORS;
	mov	eax,dword ptr  @ddpstCFG
	mov	[ebp-018h],eax;	@CBE72
	mov	eax,[ebp-018h];	@CBE72
	mov	ecx,[eax+01fh]
	or	cl,080h
	mov	[eax+01fh],ecx
@BLBL330:

; 1252 
; 1253           if (Checked(hwndDlg,TRACE_OPEN_CLOSE))
	push	01f46h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL331

; 1254             pstCFG->fTraceEvent |= CSFUNC_TRACE_OPEN;
	mov	eax,dword ptr  @ddpstCFG
	mov	[ebp-014h],eax;	@CBE71
	mov	eax,[ebp-014h];	@CBE71
	mov	ecx,[eax+01fh]
	or	ch,01h
	mov	[eax+01fh],ecx
@BLBL331:

; 1255 
; 1256           if (Checked(hwndDlg,TRACE_READ_REQ))
	push	01f48h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL332

; 1257             pstCFG->fTraceEvent |= CSFUNC_TRACE_READ;
	mov	eax,dword ptr  @ddpstCFG
	mov	[ebp-010h],eax;	@CBE70
	mov	eax,[ebp-010h];	@CBE70
	mov	ecx,[eax+01fh]
	or	ch,04h
	mov	[eax+01fh],ecx
@BLBL332:

; 1258 
; 1259           if (Checked(hwndDlg,TRACE_WRITE_REQ))
	push	01f47h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL333

; 1260             pstCFG->fTraceEvent |= CSFUNC_TRACE_WRITE;
	mov	eax,dword ptr  @ddpstCFG
	mov	[ebp-0ch],eax;	@CBE69
	mov	eax,[ebp-0ch];	@CBE69
	mov	ecx,[eax+01fh]
	or	ch,08h
	mov	[eax+01fh],ecx
@BLBL333:

; 1261 
; 1262           if (Checked(hwndDlg,TRACE_DEVIOCTL))
	push	01f49h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL334

; 1263             pstCFG->fTraceEvent |= CSFUNC_TRACE_DEVIOCTL;
	mov	eax,dword ptr  @ddpstCFG
	mov	[ebp-08h],eax;	@CBE68
	mov	eax,[ebp-08h];	@CBE68
	mov	ecx,[eax+01fh]
	or	cl,040h
	mov	[eax+01fh],ecx
@BLBL334:

; 1264 
; 1265           if (Checked(hwndDlg,TRACE_FUNC_PARAMS))
	push	01f4bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL335

; 1266             pstCFG->fTraceEvent |= CSFUNC_TRACE_INCLUDE_PACKET;
	mov	eax,dword ptr  @ddpstCFG
	mov	[ebp-04h],eax;	@CBE67
	mov	eax,[ebp-04h];	@CBE67
	mov	ecx,[eax+01fh]
	or	ch,040h
	mov	[eax+01fh],ecx
@BLBL335:

; 1267 
; 1268           if (bCOMscopeEnabled && (hCom != 0xffffffff))
	cmp	dword ptr  bCOMscopeEnabled,0h
	je	@BLBL336
	cmp	dword ptr  hCom,0ffffffffh
	je	@BLBL336

; 1269             EnableCOMscope(hwndDlg,hCom,&ulCOMscopeBufferSize,pstCFG->fTraceEvent);
	mov	eax,dword ptr  @ddpstCFG
	mov	ax,[eax+01fh]
	push	eax
	push	offset FLAT:ulCOMscopeBufferSize
	push	dword ptr  hCom
	push	dword ptr [ebp+08h];	hwndDlg
	call	EnableCOMscope
	add	esp,010h
@BLBL336:

; 1270           WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 1271           return(MRESULT)TRUE;
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL345:

; 1272         case DID_HELP:
; 1273           DisplayHelpPanel(HLPP_EVENTS_DLG);
	push	075fah
	call	DisplayHelpPanel
	add	esp,04h

; 1274           return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL346:

; 1275         case DID_CANCEL:
; 1276           WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 1277           break;
	jmp	@BLBL341
	align 04h
@BLBL347:

; 1278         default:
; 1279           return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
	jmp	@BLBL341
	align 04h
@BLBL342:
	cmp	eax,04a4eh
	je	@BLBL343
	cmp	eax,01h
	je	@BLBL344
	cmp	eax,012dh
	je	@BLBL345
	cmp	eax,02h
	je	@BLBL346
	jmp	@BLBL347
	align 04h
@BLBL341:

; 1280         }
; 1281       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL337
	align 04h
@BLBL338:
	cmp	eax,03bh
	je	@BLBL339
	cmp	eax,020h
	je	@BLBL340
@BLBL337:

; 1282     }
; 1283   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
fnwpTraceEventDlgProc	endp

; 1287   {
	align 010h

	public fnwpDCBpacketDlgProc
fnwpDCBpacketDlgProc	proc
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
	push	ebx
	sub	esp,0ch

; 1292   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL375
	align 04h
@BLBL376:

; 1293     {
; 1294     case WM_INITDLG:
; 1295 //      CenterDlgBox(hwndDlg);
; 1296       WinSetFocus(HWND_DESKTOP,hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinSetFocus
	add	esp,08h

; 1297       pstDCB = (DCB *)mp2;
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @e6pstDCB,eax

; 1298       byTemp = pstDCB->Flags1;
	mov	eax,dword ptr  @e6pstDCB
	mov	al,[eax+04h]
	mov	[ebp-065h],al;	byTemp

; 1299       switch (byTemp & F1_DTR_MASK)
	xor	eax,eax
	mov	al,[ebp-065h];	byTemp
	and	eax,03h
	jmp	@BLBL378
	align 04h
@BLBL379:

; 1300         {
; 1301         case 0: //F1_DISABLE_DTR:
; 1302           strcpy(szString,"Deactivate DTR");
	mov	edx,offset FLAT:@STAT12
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1303           break;
	jmp	@BLBL377
	align 04h
@BLBL380:

; 1304         case F1_ENABLE_DTR:
; 1305           strcpy(szString,"Activate DTR");
	mov	edx,offset FLAT:@STAT13
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1306           break;
	jmp	@BLBL377
	align 04h
@BLBL381:

; 1307         case F1_ENABLE_DTR_INPUT_HS:
; 1308           strcpy(szString,"DTR input handshaking");
	mov	edx,offset FLAT:@STAT14
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1309           break;
	jmp	@BLBL377
	align 04h
@BLBL382:

; 1310         default:
; 1311           strcpy(szString,"Invalid parameter");
	mov	edx,offset FLAT:@STAT15
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1312           break;
	jmp	@BLBL377
	align 04h
	jmp	@BLBL377
	align 04h
@BLBL378:
	test	eax,eax
	je	@BLBL379
	cmp	eax,01h
	je	@BLBL380
	cmp	eax,02h
	je	@BLBL381
	jmp	@BLBL382
	align 04h
@BLBL377:

; 1313         }
; 1314       WinSetDlgItemText(hwndDlg,DCB_DTR_HS,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c3bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1315       if (byTemp & F1_ENABLE_DSR_OUTPUT_HS)
	test	byte ptr [ebp-065h],010h;	byTemp
	je	@BLBL348

; 1316         strcpy(szString,"Enable");
	mov	edx,offset FLAT:@STAT16
	lea	eax,[ebp-064h];	szString
	call	strcpy
	jmp	@BLBL349
	align 010h
@BLBL348:

; 1317       else
; 1318         strcpy(szString,"Disable");
	mov	edx,offset FLAT:@STAT17
	lea	eax,[ebp-064h];	szString
	call	strcpy
@BLBL349:

; 1319       WinSetDlgItemText(hwndDlg,DCB_DSR_OUT_HS,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c32h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1320       if (byTemp & F1_ENABLE_DCD_OUTPUT_HS)
	test	byte ptr [ebp-065h],020h;	byTemp
	je	@BLBL350

; 1321         strcpy(szString,"Enable");
	mov	edx,offset FLAT:@STAT18
	lea	eax,[ebp-064h];	szString
	call	strcpy
	jmp	@BLBL351
	align 010h
@BLBL350:

; 1322       else
; 1323         strcpy(szString,"Disable");
	mov	edx,offset FLAT:@STAT19
	lea	eax,[ebp-064h];	szString
	call	strcpy
@BLBL351:

; 1324       WinSetDlgItemText(hwndDlg,DCB_DCD_OUT_HS,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c33h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1325       if (byTemp & F1_ENABLE_CTS_OUTPUT_HS)
	test	byte ptr [ebp-065h],08h;	byTemp
	je	@BLBL352

; 1326         strcpy(szString,"Enable");
	mov	edx,offset FLAT:@STAT1a
	lea	eax,[ebp-064h];	szString
	call	strcpy
	jmp	@BLBL353
	align 010h
@BLBL352:

; 1327       else
; 1328         strcpy(szString,"Disable");
	mov	edx,offset FLAT:@STAT1b
	lea	eax,[ebp-064h];	szString
	call	strcpy
@BLBL353:

; 1329       WinSetDlgItemText(hwndDlg,DCB_CTS_OUT_HS,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c31h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1330       if (byTemp & F1_ENABLE_DSR_INPUT_HS)
	test	byte ptr [ebp-065h],040h;	byTemp
	je	@BLBL354

; 1331         strcpy(szString,"Enable");
	mov	edx,offset FLAT:@STAT1c
	lea	eax,[ebp-064h];	szString
	call	strcpy
	jmp	@BLBL355
	align 010h
@BLBL354:

; 1332       else
; 1333         strcpy(szString,"Disable");
	mov	edx,offset FLAT:@STAT1d
	lea	eax,[ebp-064h];	szString
	call	strcpy
@BLBL355:

; 1334       WinSetDlgItemText(hwndDlg,DCB_DSR_IN_SENSE,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c35h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1335       byTemp = pstDCB->Flags2;
	mov	eax,dword ptr  @e6pstDCB
	mov	al,[eax+05h]
	mov	[ebp-065h],al;	byTemp

; 1336       switch (byTemp & F2_RTS_MASK)
	xor	eax,eax
	mov	al,[ebp-065h];	byTemp
	and	eax,0c0h
	jmp	@BLBL384
	align 04h
@BLBL385:

; 1337         {
; 1338         case 0: //F2_DISABLE_RTS:
; 1339           strcpy(szString,"Deactivate RTS");
	mov	edx,offset FLAT:@STAT1e
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1340           break;
	jmp	@BLBL383
	align 04h
@BLBL386:

; 1341         case F2_ENABLE_RTS:
; 1342           strcpy(szString,"Activate RTS");
	mov	edx,offset FLAT:@STAT1f
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1343           break;
	jmp	@BLBL383
	align 04h
@BLBL387:

; 1344         case F2_ENABLE_RTS_INPUT_HS:
; 1345           strcpy(szString,"RTS input handshaking");
	mov	edx,offset FLAT:@STAT20
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1346           break;
	jmp	@BLBL383
	align 04h
@BLBL388:

; 1347         case F2_ENABLE_RTS_TOG_ON_XMIT:
; 1348           strcpy(szString,"RTS toggling on tramsmit");
	mov	edx,offset FLAT:@STAT21
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1349           break;
	jmp	@BLBL383
	align 04h
	jmp	@BLBL383
	align 04h
@BLBL384:
	test	eax,eax
	je	@BLBL385
	cmp	eax,040h
	je	@BLBL386
	cmp	eax,080h
	je	@BLBL387
	cmp	eax,0c0h
	je	@BLBL388
@BLBL383:

; 1350         }
; 1351       WinSetDlgItemText(hwndDlg,DCB_RTS_HS,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c3ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1352       if (byTemp & F2_ENABLE_BREAK_REPL)
	test	byte ptr [ebp-065h],010h;	byTemp
	je	@BLBL356

; 1353         strcpy(szString,"Enable");
	mov	edx,offset FLAT:@STAT22
	lea	eax,[ebp-064h];	szString
	call	strcpy
	jmp	@BLBL357
	align 010h
@BLBL356:

; 1354       else
; 1355         strcpy(szString,"Disable");
	mov	edx,offset FLAT:@STAT23
	lea	eax,[ebp-064h];	szString
	call	strcpy
@BLBL357:

; 1356       WinSetDlgItemText(hwndDlg,DCB_BRK_REP,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c45h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1357       sprintf(szString,"'\\x%02X' )",pstDCB->BrkChar);
	mov	ecx,dword ptr  @e6pstDCB
	xor	eax,eax
	mov	al,[ecx+08h]
	push	eax
	mov	edx,offset FLAT:@STAT24
	lea	eax,[ebp-064h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1358       WinSetDlgItemText(hwndDlg,DCB_BRK_CHAR,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c4ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1359       if (byTemp & F2_ENABLE_ERROR_REPL)
	test	byte ptr [ebp-065h],04h;	byTemp
	je	@BLBL358

; 1360         strcpy(szString,"Enable");
	mov	edx,offset FLAT:@STAT25
	lea	eax,[ebp-064h];	szString
	call	strcpy
	jmp	@BLBL359
	align 010h
@BLBL358:

; 1361       else
; 1362         strcpy(szString,"Disable");
	mov	edx,offset FLAT:@STAT26
	lea	eax,[ebp-064h];	szString
	call	strcpy
@BLBL359:

; 1363       WinSetDlgItemText(hwndDlg,DCB_ERR_REP,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c44h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1364       sprintf(szString,"'\\x%02X' )",pstDCB->ErrChar);
	mov	ecx,dword ptr  @e6pstDCB
	xor	eax,eax
	mov	al,[ecx+07h]
	push	eax
	mov	edx,offset FLAT:@STAT27
	lea	eax,[ebp-064h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1365       WinSetDlgItemText(hwndDlg,DCB_ERR_CHAR,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c49h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1366       if (byTemp & F2_ENABLE_NULL_STRIP)
	test	byte ptr [ebp-065h],08h;	byTemp
	je	@BLBL360

; 1367         strcpy(szString,"Enable");
	mov	edx,offset FLAT:@STAT28
	lea	eax,[ebp-064h];	szString
	call	strcpy
	jmp	@BLBL361
	align 010h
@BLBL360:

; 1368       else
; 1369         strcpy(szString,"Disable");
	mov	edx,offset FLAT:@STAT29
	lea	eax,[ebp-064h];	szString
	call	strcpy
@BLBL361:

; 1370       WinSetDlgItemText(hwndDlg,DCB_NULL_STRIP,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c48h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1371       if (byTemp & F2_ENABLE_RCV_XON_XOFF_FLOW)
	test	byte ptr [ebp-065h],02h;	byTemp
	je	@BLBL362

; 1372         strcpy(szString,"Enable");
	mov	edx,offset FLAT:@STAT2a
	lea	eax,[ebp-064h];	szString
	call	strcpy
	jmp	@BLBL363
	align 010h
@BLBL362:

; 1373       else
; 1374         strcpy(szString,"Disable");
	mov	edx,offset FLAT:@STAT2b
	lea	eax,[ebp-064h];	szString
	call	strcpy
@BLBL363:

; 1375       WinSetDlgItemText(hwndDlg,DCB_RX_XON_HS,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c4fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1376       if (byTemp & F2_ENABLE_FULL_DUPLEX)
	test	byte ptr [ebp-065h],020h;	byTemp
	je	@BLBL364

; 1377         strcpy(szString,"( full duplex )");
	mov	edx,offset FLAT:@STAT2c
	lea	eax,[ebp-064h];	szString
	call	strcpy
	jmp	@BLBL365
	align 010h
@BLBL364:

; 1378       else
; 1379         strcpy(szString,"( half duplex )");
	mov	edx,offset FLAT:@STAT2d
	lea	eax,[ebp-064h];	szString
	call	strcpy
@BLBL365:

; 1380       WinSetDlgItemText(hwndDlg,DCB_FULLDUP,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c4dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1381       if (byTemp & F2_ENABLE_XMIT_XON_XOFF_FLOW)
	test	byte ptr [ebp-065h],01h;	byTemp
	je	@BLBL366

; 1382         strcpy(szString,"Enable");
	mov	edx,offset FLAT:@STAT2e
	lea	eax,[ebp-064h];	szString
	call	strcpy
	jmp	@BLBL367
	align 010h
@BLBL366:

; 1383       else
; 1384         strcpy(szString,"Disable");
	mov	edx,offset FLAT:@STAT2f
	lea	eax,[ebp-064h];	szString
	call	strcpy
@BLBL367:

; 1385       WinSetDlgItemText(hwndDlg,DCB_TX_XON_HS,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c4eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1386       sprintf(szString,"'\\x%02X'",pstDCB->XonChar);
	mov	ecx,dword ptr  @e6pstDCB
	xor	eax,eax
	mov	al,[ecx+09h]
	push	eax
	mov	edx,offset FLAT:@STAT30
	lea	eax,[ebp-064h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1387       WinSetDlgItemText(hwndDlg,DCB_XON_CHAR,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c4ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1388       sprintf(szString,"'\\x%02X'",pstDCB->XoffChar);
	mov	ecx,dword ptr  @e6pstDCB
	xor	eax,eax
	mov	al,[ecx+0ah]
	push	eax
	mov	edx,offset FLAT:@STAT31
	lea	eax,[ebp-064h];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1389       WinSetDlgItemText(hwndDlg,DCB_XOFF_CHAR,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c4bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1390       byTemp = pstDCB->Flags3;
	mov	eax,dword ptr  @e6pstDCB
	mov	al,[eax+06h]
	mov	[ebp-065h],al;	byTemp

; 1391       if (byTemp & F3_HDW_BUFFER_MASK)
	test	byte ptr [ebp-065h],018h;	byTemp
	je	@BLBL368

; 1392         {
; 1393         switch (byTemp & F3_HDW_BUFFER_MASK)
	xor	eax,eax
	mov	al,[ebp-065h];	byTemp
	and	eax,018h
	jmp	@BLBL390
	align 04h
@BLBL391:

; 1394           {
; 1395           case F3_HDW_BUFFER_DISABLE:
; 1396             strcpy(szString,"Disable FIFOs");
	mov	edx,offset FLAT:@STAT32
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1397             break;
	jmp	@BLBL389
	align 04h
@BLBL392:

; 1398           case F3_HDW_BUFFER_ENABLE:
; 1399             strcpy(szString,"Enable FIFOs");
	mov	edx,offset FLAT:@STAT33
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1400             break;
	jmp	@BLBL389
	align 04h
@BLBL393:

; 1401           case F3_HDW_BUFFER_APO:
; 1402             strcpy(szString,"Automatic Protocol Override");
	mov	edx,offset FLAT:@STAT34
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1403             break;
	jmp	@BLBL389
	align 04h
	jmp	@BLBL389
	align 04h
@BLBL390:
	cmp	eax,08h
	je	@BLBL391
	cmp	eax,010h
	je	@BLBL392
	cmp	eax,018h
	je	@BLBL393
@BLBL389:

; 1404           }
; 1405         WinSetDlgItemText(hwndDlg,DCB_FIFO,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c58h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1406         switch (byTemp & F3_RECEIVE_TRIG_MASK)
	xor	eax,eax
	mov	al,[ebp-065h];	byTemp
	and	eax,060h
	jmp	@BLBL395
	align 04h
@BLBL396:

; 1407           {
; 1408           case F3_1_CHARACTER_FIFO:
; 1409             strcpy(szString,"Low receive FIFO threshold");
	mov	edx,offset FLAT:@STAT35
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1410             break;
	jmp	@BLBL394
	align 04h
@BLBL397:

; 1411           case F3_4_CHARACTER_FIFO:
; 1412             strcpy(szString,"Medium-low receive FIFO threshold");
	mov	edx,offset FLAT:@STAT36
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1413             break;
	jmp	@BLBL394
	align 04h
@BLBL398:

; 1414           case F3_8_CHARACTER_FIFO:
; 1415             strcpy(szString,"Medium-high receive FIFO threshold");
	mov	edx,offset FLAT:@STAT37
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1416             break;
	jmp	@BLBL394
	align 04h
@BLBL399:

; 1417           case F3_14_CHARACTER_FIFO:
; 1418             strcpy(szString,"High receive FIFO threshold");
	mov	edx,offset FLAT:@STAT38
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1419             break;
	jmp	@BLBL394
	align 04h
	jmp	@BLBL394
	align 04h
@BLBL395:
	test	eax,eax
	je	@BLBL396
	cmp	eax,020h
	je	@BLBL397
	cmp	eax,040h
	je	@BLBL398
	cmp	eax,060h
	je	@BLBL399
@BLBL394:

; 1420           }
; 1421         WinSetDlgItemText(hwndDlg,DCB_RX_FIFO,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c59h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1422         if (byTemp & F3_USE_TX_BUFFER)
	test	byte ptr [ebp-065h],080h;	byTemp
	je	@BLBL369

; 1423           strcpy(szString,"Enable transmit FIFO");
	mov	edx,offset FLAT:@STAT39
	lea	eax,[ebp-064h];	szString
	call	strcpy
	jmp	@BLBL370
	align 010h
@BLBL369:

; 1424         else
; 1425           strcpy(szString,"Disable transmit FIFO");
	mov	edx,offset FLAT:@STAT3a
	lea	eax,[ebp-064h];	szString
	call	strcpy
@BLBL370:

; 1426         WinSetDlgItemText(hwndDlg,DCB_TX_FIFO,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c5bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1427         }
	jmp	@BLBL371
	align 010h
@BLBL368:

; 1428       else
; 1429         {
; 1430         strcpy(szString,"FIFOs unavailable or no change to FIFO processing");
	mov	edx,offset FLAT:@STAT3b
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1431         WinSetDlgItemText(hwndDlg,DCB_FIFO,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c58h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1432         }
@BLBL371:

; 1433       if (byTemp & F3_INFINITE_WRT_TIMEOUT)
	test	byte ptr [ebp-065h],01h;	byTemp
	je	@BLBL372

; 1434         strcpy(szString,"Infinite");
	mov	edx,offset FLAT:@STAT3c
	lea	eax,[ebp-064h];	szString
	call	strcpy
	jmp	@BLBL373
	align 010h
@BLBL372:

; 1435       else
; 1436         strcpy(szString,"Normal");
	mov	edx,offset FLAT:@STAT3d
	lea	eax,[ebp-064h];	szString
	call	strcpy
@BLBL373:

; 1437       WinSetDlgItemText(hwndDlg,DCB_WRT_TOPROC,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c21h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1438       itoa(pstDCB->WrtTimeout,szString,10);
	mov	ecx,0ah
	lea	edx,[ebp-064h];	szString
	mov	ebx,dword ptr  @e6pstDCB
	xor	eax,eax
	mov	ax,[ebx]
	call	_itoa

; 1439       WinSetDlgItemText(hwndDlg,DCB_WRT_TO,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c1dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1440       switch (byTemp & F3_RTO_MASK)
	xor	eax,eax
	mov	al,[ebp-065h];	byTemp
	and	eax,06h
	jmp	@BLBL401
	align 04h
@BLBL402:

; 1441         {
; 1442         case F3_WAIT_NORM:
; 1443           strcpy(szString,"Normal");
	mov	edx,offset FLAT:@STAT3e
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1444           break;
	jmp	@BLBL400
	align 04h
@BLBL403:

; 1445         case F3_WAIT_NONE:
; 1446           strcpy(szString,"No wait");
	mov	edx,offset FLAT:@STAT3f
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1447           break;
	jmp	@BLBL400
	align 04h
@BLBL404:

; 1448         case F3_WAIT_SOMETHING:
; 1449           strcpy(szString,"Wait for something");
	mov	edx,offset FLAT:@STAT40
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1450           break;
	jmp	@BLBL400
	align 04h
@BLBL405:

; 1451         default:
; 1452           strcpy(szString,"Invalid");
	mov	edx,offset FLAT:@STAT41
	lea	eax,[ebp-064h];	szString
	call	strcpy

; 1453           break;
	jmp	@BLBL400
	align 04h
	jmp	@BLBL400
	align 04h
@BLBL401:
	cmp	eax,02h
	je	@BLBL402
	cmp	eax,06h
	je	@BLBL403
	cmp	eax,04h
	je	@BLBL404
	jmp	@BLBL405
	align 04h
@BLBL400:

; 1454         }
; 1455       WinSetDlgItemText(hwndDlg,DCB_READ_TOPROC,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c25h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1456       itoa(pstDCB->ReadTimeout,szString,10);
	mov	ecx,0ah
	lea	edx,[ebp-064h];	szString
	mov	ebx,dword ptr  @e6pstDCB
	xor	eax,eax
	mov	ax,[ebx+02h]
	call	_itoa

; 1457       WinSetDlgItemText(hwndDlg,DCB_READ_TO,szString);
	lea	eax,[ebp-064h];	szString
	push	eax
	push	0c1fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1458       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL406:

; 1459     case WM_COMMAND:
; 1460       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL408
	align 04h
@BLBL409:

; 1461         {
; 1462         case DID_OK:
; 1463           WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 1464           return(MRESULT)TRUE;
	mov	eax,01h
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL410:

; 1465         case DID_HELP:
; 1466           DisplayHelpPanel(HLPP_DCB_DLG);
	push	075fch
	call	DisplayHelpPanel
	add	esp,04h

; 1467           return(
; 1467 (MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL411:

; 1468         case DID_CANCEL:
; 1469           WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 1470           break;
	jmp	@BLBL407
	align 04h
@BLBL412:

; 1471         default:
; 1472           return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDefDlgProc
	add	esp,01ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL407
	align 04h
@BLBL408:
	cmp	eax,01h
	je	@BLBL409
	cmp	eax,012dh
	je	@BLBL410
	cmp	eax,02h
	je	@BLBL411
	jmp	@BLBL412
	align 04h
@BLBL407:

; 1473         }
; 1474       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL374
	align 04h
@BLBL375:
	cmp	eax,03bh
	je	@BLBL376
	cmp	eax,020h
	je	@BLBL406
@BLBL374:

; 1475     }
; 1476   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDefDlgProc
	add	esp,01ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
fnwpDCBpacketDlgProc	endp
CODE32	ends
end
