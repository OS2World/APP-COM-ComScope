	title	p:\config\ddbufdlg.c
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
	extrn	WinSendDlgItemMsg:proc
	extrn	_ltoa:proc
	extrn	WinWindowFromID:proc
	extrn	WinSetFocus:proc
	extrn	WinDefDlgProc:proc
	extrn	_sprintfieee:proc
	extrn	_fullDump:dword
	extrn	lYScr:dword
	extrn	bInsertNewDevice:dword
	extrn	ulReadBuffLen:dword
	extrn	hwndNoteBookDlg:dword
	extrn	ulOrgReadBuffLen:dword
	extrn	lXoffThreshold:dword
	extrn	lXonHysteresis:dword
DATA32	segment
@STAT1	db "S~ave",0h
	align 04h
@STAT2	db "Receive buffer",0h
	align 04h
@STAT3	db "Receive Buffer Length Co"
db "nfiguration",0h
@STAT4	db "S~ave",0h
	align 04h
@STAT5	db "Transmit buffer",0h
@STAT6	db "Transmit Buffer Length C"
db "onfiguration",0h
	align 04h
@STAT7	db "S~ave",0h
	align 04h
@STAT8	db "COMscope buffer",0h
@STAT9	db "COMscope Capture Buffer "
db "Length Configuration",0h
	align 04h
@STATa	db "element",0h
@STATb	db "1K",0h
	align 04h
@STATc	db "%uK",0h
@STATd	db "64K",0h
@STATe	db "128",0h
@STATf	db "%uK",0h
@STAT10	db "8K",0h
@STAT11	db "1k",0h
	align 04h
@STAT12	db "%uK",0h
@STAT13	db "32K",0h
@ciResDevider	dd 01h
@2fiResDevider	dd 01h
@3fiResDevider	dd 01h
	dd	_dllentry
DATA32	ends
BSS32	segment
@9pstPage	dd 0h
@apstComDCB	dd 0h
@dbNotFirst	dd 0h
@2bulBuffLen	dd 0h
@2culOrgBufLen	dd 0h
@2dpstPage	dd 0h
@30bNotFirst	dd 0h
@3bulOrgBuffLen	dd 0h
@3culBuffLen	dd 0h
@3epstPage	dd 0h
@40bNotFirst	dd 0h
BSS32	ends
CODE32	segment

; 25   {
	align 010h

	public fnwpReceiveBuffDlgProc
fnwpReceiveBuffDlgProc	proc
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
	sub	esp,0ch

; 34   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL20
	align 04h
@BLBL21:

; 35     {
; 36     case WM_INITDLG:
; 37       if (lYScr < 768)
	cmp	dword ptr  lYScr,0300h
	jge	@BLBL1

; 38         iResDevider = 2;
	mov	dword ptr  @ciResDevider,02h
@BLBL1:

; 39       if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL2

; 40         WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
	push	offset FLAT:@STAT1
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL2:

; 41 //        ControlEnable(hwndDlg,DID_INSERT,FALSE);
; 42 //      CenterDlgBox(hwndDlg);
; 43 //      WinSetFocus(HWND_DESKTOP,hwndDlg);
; 44       pstPage = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @9pstPage,eax

; 45       pstComDCB = (COMDCB *)pstPage->pVoidPtrOne;
	mov	eax,dword ptr  @9pstPage
	mov	eax,[eax+06h]
	mov	dword ptr  @apstComDCB,eax

; 46 //      pstPage->bDirtyBit = FALSE;
; 47       bNotFirst = FALSE;
	mov	dword ptr  @dbNotFirst,0h

; 48 //      lXonHysteresis = (pstComDCB->wReadBufferLength - pstComDCB->wXonThreshold - pstComDCB->wXoffThreshold);
; 49 //      WinSetDlgItemText(hwndDlg,PCFG_BUFF_NAME,"~Receive buffer");
; 50       WinSetDlgItemText(hwndDlg,PCFG_BUFF_NAME,"Receive buffer");
	push	offset FLAT:@STAT2
	push	01307h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 51       WinSetDlgItemText(hwndDlg,ST_TITLE,"Receive Buffer Length Configuration");
	push	offset FLAT:@STAT3
	push	0578h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 52       InitReadBufferSize(hwndDlg,ulReadBuffLen,iResDevider);
	push	dword ptr  @ciResDevider
	push	dword ptr  ulReadBuffLen
	push	dword ptr [ebp+08h];	hwndDlg
	call	InitReadBufferSize
	add	esp,0ch

; 53       return (MRESULT) TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL22:

; 54     case WM_COMMAND:
; 55       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL24
	align 04h
@BLBL25:

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
	jmp	@BLBL23
	align 04h
@BLBL26:

; 60         case DID_CANCEL:
; 61           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 62            return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL27:

; 63         case DID_HELP:
; 64            WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
	push	0h
	push	012dh
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h
@BLBL28:

; 65         case DID_UNDO:
; 66           pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @9pstPage
	and	byte ptr [eax+02ah],0feh

; 67           ulReadBuffLen = ulOrgReadBuffLen;
	mov	eax,dword ptr  ulOrgReadBuffLen
	mov	dword ptr  ulReadBuffLen,eax

; 68           WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSLIDERINFO,
	mov	eax,dword ptr  ulReadBuffLen
	shr	eax,08h
	sub	eax,04h
	and	eax,0ffffh
	push	eax
	push	03h
	push	0371h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 69                             MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_RANGEVALUE),MPFROMSHORT((ulReadBuffLen / 256) - 4));
; 70           WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,
	mov	ecx,0ah
	lea	edx,[ebp-013h];	acBuffer
	mov	eax,dword ptr  ulReadBuffLen
	call	_ltoa
	push	eax
	push	01306h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 71                            ltoa(ulReadBuffLen,acBuffer,10));
; 72           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL23
	align 04h
@BLBL24:
	cmp	eax,0130h
	je	@BLBL25
	cmp	eax,02h
	je	@BLBL26
	cmp	eax,012dh
	je	@BLBL27
	cmp	eax,0135h
	je	@BLBL28
@BLBL23:

; 73         }
; 74       break;
	jmp	@BLBL19
	align 04h
@BLBL29:

; 75     case UM_SET_FOCUS:
; 76       WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
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

; 77       break;
	jmp	@BLBL19
	align 04h
@BLBL30:

; 78     case UM_SAVE_DATA:
; 79        pstComDCB->wReadBufferLength = ulReadBuffLen;
	mov	ecx,dword ptr  ulReadBuffLen
	mov	eax,dword ptr  @apstComDCB
	mov	[eax+08h],cx

; 80        return((MRESULT)TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL31:

; 81     case WM_CONTROL:
; 82       switch (SHORT2FROMMP(mp1))
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	and	eax,0ffffh
	jmp	@BLBL33
	align 04h
@BLBL34:
@BLBL35:

; 83         {
; 84         case SLN_SLIDERTRACK:
; 85         case SLN_CHANGE:
; 86           if (bNotFirst)
	cmp	dword ptr  @dbNotFirst,0h
	je	@BLBL3

; 87             pstPage->bDirtyBit = TRUE;
	mov	eax,dword ptr  @9pstPage
	or	byte ptr [eax+02ah],01h
	jmp	@BLBL4
	align 010h
@BLBL3:

; 88           else
; 89             bNotFirst = TRUE;
	mov	dword ptr  @dbNotFirst,01h
@BLBL4:

; 90           ulTemp = (ULONG)WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
	push	0h
	push	010003h
	push	036ch
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h
	mov	[ebp-04h],eax;	ulTemp

; 91                                             SLM_QUERYSLIDERINFO,
; 92                                             MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_INCREMENTVALUE),
; 93                                             NULL);
; 94           ulReadBuffLen = ((ulTemp * 256 * iResDevider) + MIN_READ_BUFF_LEN);
	mov	ecx,dword ptr  @ciResDevider
	mov	eax,[ebp-04h];	ulTemp
	sal	eax,08h
	imul	eax,ecx
	add	eax,0400h
	mov	dword ptr  ulReadBuffLen,eax

; 95           WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,ltoa(ulReadBuffLen,acBuffer,10));
	mov	ecx,0ah
	lea	edx,[ebp-013h];	acBuffer
	mov	eax,dword ptr  ulReadBuffLen
	call	_ltoa
	push	eax
	push	01306h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 96           if (SHORT2FROMMP(mp1) != SLN_CHANGE)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	je	@BLBL5

; 97             break;
	jmp	@BLBL32
	align 04h
@BLBL5:

; 98           if (ulReadBuffLen >= MAX_READ_BUFF_LEN)
	cmp	dword ptr  ulReadBuffLen,010000h
	jb	@BLBL6

; 99             ulReadBuffLen = (USHORT)0xffff;
	mov	dword ptr  ulReadBuffLen,0ffffh
@BLBL6:

; 100           if (lXoffThreshold != 0)
	cmp	dword ptr  lXoffThreshold,0h
	je	@BLBL7

; 101             if ((lXonHysteresis + lXoffThreshold) >= ulReadBuffLen)
	mov	eax,dword ptr  lXoffThreshold
	add	eax,dword ptr  lXonHysteresis
	cmp	dword ptr  ulReadBuffLen,eax
	ja	@BLBL7

; 102               if (lXonHysteresis > lXoffThreshold)
	mov	eax,dword ptr  lXoffThreshold
	cmp	dword ptr  lXonHysteresis,eax
	jle	@BLBL9

; 103                 {
; 104                 lTemp = (lXonHysteresis / lXoffThreshold);
	mov	eax,dword ptr  lXonHysteresis
	cdq	
	idiv	dword ptr  lXoffThreshold
	mov	[ebp-018h],eax;	lTemp

; 105                 if (lTemp <= 0)
	cmp	dword ptr [ebp-018h],0h;	lTemp
	jg	@BLBL10

; 106                   lTemp = 1;
	mov	dword ptr [ebp-018h],01h;	lTemp
@BLBL10:

; 107                 while ((lXonHysteresis + lXoffThreshold) >= ulReadBuffLen)
	mov	eax,dword ptr  lXoffThreshold
	add	eax,dword ptr  lXonHysteresis
	cmp	dword ptr  ulReadBuffLen,eax
	ja	@BLBL7
	align 010h
@BLBL12:

; 108                   {
; 109                   lXonHysteresis -= lTemp;
	mov	eax,dword ptr  lXonHysteresis
	sub	eax,[ebp-018h];	lTemp
	mov	dword ptr  lXonHysteresis,eax

; 110                   lXoffThreshold--;
	mov	eax,dword ptr  lXoffThreshold
	dec	eax
	mov	dword ptr  lXoffThreshold,eax

; 111                   }

; 107                 while ((lXonHysteresis + lXoffThreshold) >= ulReadBuffLen)
	mov	eax,dword ptr  lXoffThreshold
	add	eax,dword ptr  lXonHysteresis
	cmp	dword ptr  ulReadBuffLen,eax
	jbe	@BLBL12

; 112                 }
	jmp	@BLBL7
	align 010h
@BLBL9:

; 115                 lTemp = (lXoffThreshold / lXonHysteresis);
	mov	eax,dword ptr  lXoffThreshold
	cdq	
	idiv	dword ptr  lXonHysteresis
	mov	[ebp-018h],eax;	lTemp

; 116                 if (lTemp <= 0)
	cmp	dword ptr [ebp-018h],0h;	lTemp
	jg	@BLBL15

; 117                   lTemp = 1;
	mov	dword ptr [ebp-018h],01h;	lTemp
@BLBL15:

; 118                 while ((lXonHysteresis + lXoffThreshold) >= ulReadBuffLen)
	mov	eax,dword ptr  lXoffThreshold
	add	eax,dword ptr  lXonHysteresis
	cmp	dword ptr  ulReadBuffLen,eax
	ja	@BLBL7
	align 010h
@BLBL17:

; 120                   lXonHysteresis--;
	mov	eax,dword ptr  lXonHysteresis
	dec	eax
	mov	dword ptr  lXonHysteresis,eax

; 121                   lXoffThreshold -= lTemp;
	mov	eax,dword ptr  lXoffThreshold
	sub	eax,[ebp-018h];	lTemp
	mov	dword ptr  lXoffThreshold,eax

; 122                   }

; 118                 while ((lXonHysteresis + lXoffThreshold) >= ulReadBuffLen)
	mov	eax,dword ptr  lXoffThreshold
	add	eax,dword ptr  lXonHysteresis
	cmp	dword ptr  ulReadBuffLen,eax
	jbe	@BLBL17

; 123                 }
@BLBL7:

; 124           break;
	jmp	@BLBL32
	align 04h
	jmp	@BLBL32
	align 04h
@BLBL33:
	cmp	eax,02h
	je	@BLBL34
	cmp	eax,01h
	je	@BLBL35
@BLBL32:

; 126       return (MRESULT) TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL19
	align 04h
@BLBL20:
	cmp	eax,03bh
	je	@BLBL21
	cmp	eax,020h
	je	@BLBL22
	cmp	eax,02716h
	je	@BLBL29
	cmp	eax,02711h
	je	@BLBL30
	cmp	eax,030h
	je	@BLBL31
@BLBL19:

; 128   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
fnwpReceiveBuffDlgProc	endp

; 132   {
	align 010h

	public fnwpTransmitBuffDlgProc
fnwpTransmitBuffDlgProc	proc
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
	sub	esp,0ch

; 142   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL43
	align 04h
@BLBL44:

; 143     {
; 144     case WM_INITDLG:
; 145       if (lYScr < 768)
	cmp	dword ptr  lYScr,0300h
	jge	@BLBL36

; 146         iResDevider = 2;
	mov	dword ptr  @2fiResDevider,02h
@BLBL36:

; 147       if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL37

; 148         WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
	push	offset FLAT:@STAT4
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL37:

; 149 //        ControlEnable(hwndDlg,DID_INSERT,FALSE);
; 150 //      CenterDlgBox(hwndDlg);
; 151 //      WinSetFocus(HWND_DESKTOP,hwndDlg);
; 152       pstPage = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @2dpstPage,eax

; 153 //      pstPage->bDirtyBit = FALSE;
; 154       bNotFirst = FALSE;
	mov	dword ptr  @30bNotFirst,0h

; 155       ulBuffLen = *(USHORT *)pstPage->pVoidPtrOne;
	mov	ecx,dword ptr  @2dpstPage
	mov	ecx,[ecx+06h]
	xor	eax,eax
	mov	ax,[ecx]
	mov	dword ptr  @2bulBuffLen,eax

; 156       if (ulBuffLen == 0)
	cmp	dword ptr  @2bulBuffLen,0h
	jne	@BLBL38

; 157         ulBuffLen = DEF_WRITE_BUFF_LEN;
	mov	dword ptr  @2bulBuffLen,0100h
@BLBL38:

; 158       ulOrgBufLen = ulBuffLen;
	mov	eax,dword ptr  @2bulBuffLen
	mov	dword ptr  @2culOrgBufLen,eax

; 159 //      WinSetDlgItemText(hwndDlg,PCFG_BUFF_NAME,"~Transmit buffer");
; 160       WinSetDlgItemText(hwndDlg,PCFG_BUFF_NAME,"Transmit buffer");
	push	offset FLAT:@STAT5
	push	01307h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 161       WinSetDlgItemText(hwndDlg,ST_TITLE,"Transmit Buffer Length Configuration");
	push	offset FLAT:@STAT6
	push	0578h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 162       InitWriteBufferSize(hwndDlg,ulBuffLen,iResDevider);
	push	dword ptr  @2fiResDevider
	push	dword ptr  @2bulBuffLen
	push	dword ptr [ebp+08h];	hwndDlg
	call	InitWriteBufferSize
	add	esp,0ch

; 163       return (MRESULT) TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL45:

; 164     case UM_SET_FOCUS:
; 165       WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
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

; 166       break;
	jmp	@BLBL42
	align 04h
@BLBL46:

; 167     case WM_COMMAND:
; 168       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL48
	align 04h
@BLBL49:

; 169         {
; 170         case DID_INSERT:
; 171            WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
	push	0h
	push	0h
	push	02714h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 172            break;
	jmp	@BLBL47
	align 04h
@BLBL50:

; 173         case DID_CANCEL:
; 174           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 175           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL51:

; 176         case DID_HELP:
; 177            WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
	push	0h
	push	012dh
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h
@BLBL52:

; 178         case DID_UNDO:
; 179           pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @2dpstPage
	and	byte ptr [eax+02ah],0feh

; 180           ulBuffLen = ulOrgBufLen;
	mov	eax,dword ptr  @2culOrgBufLen
	mov	dword ptr  @2bulBuffLen,eax

; 181           WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSLIDERINFO,
	mov	eax,dword ptr  @2bulBuffLen
	shr	eax,05h
	sub	eax,04h
	and	eax,0ffffh
	push	eax
	push	03h
	push	0371h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 182                             MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_RANGEVALUE),MPFROMSHORT((ulBuffLen / 32) - 4));
; 183           WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,
	mov	ecx,0ah
	lea	edx,[ebp-013h];	acBuffer
	mov	eax,dword ptr  @2bulBuffLen
	call	_ltoa
	push	eax
	push	01306h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 184                            ltoa(ulBuffLen,acBuffer,10));
; 185           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL47
	align 04h
@BLBL48:
	cmp	eax,0130h
	je	@BLBL49
	cmp	eax,02h
	je	@BLBL50
	cmp	eax,012dh
	je	@BLBL51
	cmp	eax,0135h
	je	@BLBL52
@BLBL47:

; 186         }
; 187       break;
	jmp	@BLBL42
	align 04h
@BLBL53:

; 188     case WM_CONTROL:
; 189       if (SHORT2FROMMP(mp1) & (SLN_SLIDERTRACK | SLN_CHANGE))
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	test	al,03h
	je	@BLBL39

; 190         {
; 191         if (bNotFirst)
	cmp	dword ptr  @30bNotFirst,0h
	je	@BLBL40

; 192           pstPage->bDirtyBit = TRUE;
	mov	eax,dword ptr  @2dpstPage
	or	byte ptr [eax+02ah],01h
	jmp	@BLBL41
	align 010h
@BLBL40:

; 193         else
; 194           bNotFirst = TRUE;
	mov	dword ptr  @30bNotFirst,01h
@BLBL41:

; 195         ulTemp = (ULONG)WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
	push	0h
	push	010003h
	push	036ch
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h
	mov	[ebp-04h],eax;	ulTemp

; 196                                           SLM_QUERYSLIDERINFO,
; 197                                           MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_INCREMENTVALUE),
; 198                                           NULL);
; 199         ulBuffLen = ((ulTemp * 32 * iResDevider) + MIN_WRITE_BUFF_LEN);
	mov	ecx,dword ptr  @2fiResDevider
	mov	eax,[ebp-04h];	ulTemp
	sal	eax,05h
	imul	eax,ecx
	add	eax,080h
	mov	dword ptr  @2bulBuffLen,eax

; 200         WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,ltoa(ulBuffLen,acBuffer,10));
	mov	ecx,0ah
	lea	edx,[ebp-013h];	acBuffer
	mov	eax,dword ptr  @2bulBuffLen
	call	_ltoa
	push	eax
	push	01306h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 201         }
@BLBL39:

; 202       return((MRESULT)TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL54:

; 203     case UM_SAVE_DATA:
; 204       pusLen = pstPage->pVoidPtrOne;
	mov	eax,dword ptr  @2dpstPage
	mov	eax,[eax+06h]
	mov	[ebp-018h],eax;	pusLen

; 205       *pusLen = (USHORT)ulBuffLen;
	mov	ecx,dword ptr  @2bulBuffLen
	mov	eax,[ebp-018h];	pusLen
	mov	[eax],cx

; 206       return (MRESULT) TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL42
	align 04h
@BLBL43:
	cmp	eax,03bh
	je	@BLBL44
	cmp	eax,02716h
	je	@BLBL45
	cmp	eax,020h
	je	@BLBL46
	cmp	eax,030h
	je	@BLBL53
	cmp	eax,02711h
	je	@BLBL54
@BLBL42:

; 207     }
; 208   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
fnwpTransmitBuffDlgProc	endp

; 212   {
	align 010h

	public fnwpCOMscopeBuffDlgProc
fnwpCOMscopeBuffDlgProc	proc
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
	sub	esp,0ch

; 222   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL63
	align 04h
@BLBL64:

; 223     {
; 224     case WM_INITDLG:
; 225       if (lYScr < 768)
	cmp	dword ptr  lYScr,0300h
	jge	@BLBL55

; 226         iResDevi
; 226 der = 2;
	mov	dword ptr  @3fiResDevider,02h
@BLBL55:

; 227       if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL56

; 228         WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
	push	offset FLAT:@STAT7
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL56:

; 229 //        ControlEnable(hwndDlg,DID_INSERT,FALSE);
; 230 //      CenterDlgBox(hwndDlg);
; 231 //      WinSetFocus(HWND_DESKTOP,hwndDlg);
; 232       pstPage = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @3epstPage,eax

; 233 //      pstPage->bDirtyBit = FALSE;
; 234       bNotFirst = FALSE;
	mov	dword ptr  @40bNotFirst,0h

; 235       ulBuffLen = *(USHORT *)pstPage->pVoidPtrOne;
	mov	ecx,dword ptr  @3epstPage
	mov	ecx,[ecx+06h]
	xor	eax,eax
	mov	ax,[ecx]
	mov	dword ptr  @3culBuffLen,eax

; 236       if (ulBuffLen == 0)
	cmp	dword ptr  @3culBuffLen,0h
	jne	@BLBL57

; 237         ulBuffLen = DEF_COMscope_BUFF_LEN;
	mov	dword ptr  @3culBuffLen,01000h
@BLBL57:

; 238       ulOrgBuffLen = ulBuffLen;
	mov	eax,dword ptr  @3culBuffLen
	mov	dword ptr  @3bulOrgBuffLen,eax

; 239 //      WinSetDlgItemText(hwndDlg,PCFG_BUFF_NAME,"~COMscope buffer");
; 240       WinSetDlgItemText(hwndDlg,PCFG_BUFF_NAME,"COMscope buffer");
	push	offset FLAT:@STAT8
	push	01307h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 241       WinSetDlgItemText(hwndDlg,ST_TITLE,"COMscope Capture Buffer Length Configuration");
	push	offset FLAT:@STAT9
	push	0578h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 242       WinSetDlgItemText(hwndDlg,ST_DEVICEINTERFACECONFIGURATION,"element");
	push	offset FLAT:@STATa
	push	0271ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 243       InitCOMscopeBufferSize(hwndDlg,ulBuffLen,iResDevider);
	push	dword ptr  @3fiResDevider
	push	dword ptr  @3culBuffLen
	push	dword ptr [ebp+08h];	hwndDlg
	call	InitCOMscopeBufferSize
	add	esp,0ch

; 244       return (MRESULT) TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL65:

; 245     case WM_COMMAND:
; 246       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL67
	align 04h
@BLBL68:

; 247         {
; 248         case DID_INSERT:
; 249            WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
	push	0h
	push	0h
	push	02714h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 250            break;
	jmp	@BLBL66
	align 04h
@BLBL69:

; 251         case DID_CANCEL:
; 252           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 253           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL70:

; 254         case DID_HELP:
; 255            WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
	push	0h
	push	012dh
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h
@BLBL71:

; 256         case DID_UNDO:
; 257           if (pstPage->bDirtyBit)
	mov	eax,dword ptr  @3epstPage
	test	byte ptr [eax+02ah],01h
	je	@BLBL58

; 258             {
; 259             pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @3epstPage
	and	byte ptr [eax+02ah],0feh

; 260             ulBuffLen = ulOrgBuffLen;
	mov	eax,dword ptr  @3bulOrgBuffLen
	mov	dword ptr  @3culBuffLen,eax

; 261             WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSLIDERINFO,
	mov	eax,dword ptr  @3culBuffLen
	shr	eax,07h
	sub	eax,08h
	and	eax,0ffffh
	push	eax
	push	03h
	push	0371h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 262                               MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_RANGEVALUE),MPFROMSHORT((ulBuffLen / 128) - 8));
; 263             WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,
	mov	ecx,0ah
	lea	edx,[ebp-013h];	acBuffer
	mov	eax,dword ptr  @3culBuffLen
	call	_ltoa
	push	eax
	push	01306h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 264                              ltoa(ulBuffLen,acBuffer,10));
; 265             }
@BLBL58:

; 266           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL66
	align 04h
@BLBL67:
	cmp	eax,0130h
	je	@BLBL68
	cmp	eax,02h
	je	@BLBL69
	cmp	eax,012dh
	je	@BLBL70
	cmp	eax,0135h
	je	@BLBL71
@BLBL66:

; 267         }
; 268       break;
	jmp	@BLBL62
	align 04h
@BLBL72:

; 269     case UM_SET_FOCUS:
; 270       WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
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

; 271       break;
	jmp	@BLBL62
	align 04h
@BLBL73:

; 272     case WM_CONTROL:
; 273       if (SHORT2FROMMP(mp1) & (SLN_SLIDERTRACK | SLN_CHANGE))
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	test	al,03h
	je	@BLBL59

; 274         {
; 275         if (bNotFirst)
	cmp	dword ptr  @40bNotFirst,0h
	je	@BLBL60

; 276           pstPage->bDirtyBit = TRUE;
	mov	eax,dword ptr  @3epstPage
	or	byte ptr [eax+02ah],01h
	jmp	@BLBL61
	align 010h
@BLBL60:

; 277         else
; 278           bNotFirst = TRUE;
	mov	dword ptr  @40bNotFirst,01h
@BLBL61:

; 279         ulTemp = (ULONG)WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
	push	0h
	push	010003h
	push	036ch
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h
	mov	[ebp-04h],eax;	ulTemp

; 280                                           SLM_QUERYSLIDERINFO,
; 281                                           MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_INCREMENTVALUE),
; 282                                           NULL);
; 283         ulBuffLen = ((ulTemp * 128 * iResDevider) + MIN_COMscope_BUFF_LEN);
	mov	ecx,dword ptr  @3fiResDevider
	mov	eax,[ebp-04h];	ulTemp
	sal	eax,07h
	imul	eax,ecx
	add	eax,0400h
	mov	dword ptr  @3culBuffLen,eax

; 284         WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,ltoa(ulBuffLen,acBuffer,10));
	mov	ecx,0ah
	lea	edx,[ebp-013h];	acBuffer
	mov	eax,dword ptr  @3culBuffLen
	call	_ltoa
	push	eax
	push	01306h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 285         }
@BLBL59:

; 286       return((MRESULT)TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL74:

; 287     case UM_SAVE_DATA:
; 288       pusLen = pstPage->pVoidPtrOne;
	mov	eax,dword ptr  @3epstPage
	mov	eax,[eax+06h]
	mov	[ebp-018h],eax;	pusLen

; 289       *pusLen = (USHORT)ulBuffLen;
	mov	ecx,dword ptr  @3culBuffLen
	mov	eax,[ebp-018h];	pusLen
	mov	[eax],cx

; 290       return (MRESULT) TRUE;
	mov	eax,01h
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
	cmp	eax,02716h
	je	@BLBL72
	cmp	eax,030h
	je	@BLBL73
	cmp	eax,02711h
	je	@BLBL74
@BLBL62:

; 291     }
; 292   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
fnwpCOMscopeBuffDlgProc	endp

; 296   {
	align 010h

	public InitReadBufferSize
InitReadBufferSize	proc
	push	ebp
	mov	ebp,esp
	sub	esp,038h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,0eh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 301   int iExtent = 253;
	mov	dword ptr [ebp-038h],0fdh;	iExtent

; 302 
; 303   if (iResDevider == 2)
	cmp	dword ptr [ebp+010h],02h;	iResDevider
	jne	@BLBL75

; 304     iExtent = 127;
	mov	dword ptr [ebp-038h],07fh;	iExtent
@BLBL75:

; 305   SliderData.cbSize = sizeof(SLDCDATA);
	mov	dword ptr [ebp-0eh],0ch;	SliderData

; 306   SliderData.usScale1Increments = iExtent;
	mov	eax,[ebp-038h];	iExtent
	mov	[ebp-0ah],ax;	SliderData

; 307   SliderData.usScale1Spacing = 1;
	mov	word ptr [ebp-08h],01h;	SliderData

; 308   SliderData.usScale2Increments = iExtent;
	mov	eax,[ebp-038h];	iExtent
	mov	[ebp-06h],ax;	SliderData

; 309   SliderData.usScale2Spacing = 1;
	mov	word ptr [ebp-04h],01h;	SliderData

; 310 
; 311   wprm.fsStatus = WPM_CTLDATA;
	mov	dword ptr [ebp-02ah],02h;	wprm

; 312   wprm.cchText = 0;
	mov	dword ptr [ebp-026h],0h;	wprm

; 313   wprm.cbPresParams = 0;
	mov	dword ptr [ebp-01eh],0h;	wprm

; 314   wprm.cbCtlData = 0;
	mov	dword ptr [ebp-016h],0h;	wprm

; 315   wprm.pCtlData = &SliderData;
	lea	eax,[ebp-0eh];	SliderData
	mov	[ebp-012h],eax;	wprm

; 316   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
	push	0h
	lea	eax,[ebp-02ah];	wprm
	push	eax
	push	0ah
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 317                     WM_SETWINDOWPARAMS,(MPARAM)&wprm,(MPARAM)NULL ) ;
; 318 
; 319   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSLIDERINFO,
	mov	eax,[ebp+0ch];	ulBuffLen
	shr	eax,08h
	mov	ecx,[ebp+010h];	iResDevider
	xor	edx,edx
	div	ecx
	mov	ecx,eax
	mov	eax,04h
	cdq	
	idiv	dword ptr [ebp+010h];	iResDevider
	xchg	ecx,eax
	sub	eax,ecx
	and	eax,0ffffh
	push	eax
	push	03h
	push	0371h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 320                     MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_RANGEVALUE),MPFROMSHORT((ulBuffLen / 256 / iResDevider) - (4 / iResDevider)));
; 321 
; 322   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
	push	0h
	push	050000h
	push	0372h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 323                     SLM_SETTICKSIZE,MPFROM2SHORT(0,5),NULL);
; 324   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
	push	offset FLAT:@STATb
	push	0h
	push	0370h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 325                     MPFROMSHORT(0), MPFROMP("1K"));
; 326   for (usCount = 1; usCount < 4; usCount++ )
	mov	word ptr [ebp-02h],01h;	usCount
	mov	ax,[ebp-02h];	usCount
	cmp	ax,04h
	jae	@BLBL76
	align 010h
@BLBL77:

; 327     {
; 328     WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
	push	0h
	xor	eax,eax
	mov	ax,[ebp-02h];	usCount
	sal	eax,06h
	cdq	
	idiv	dword ptr [ebp+010h];	iResDevider
	mov	ecx,eax
	mov	eax,04h
	cdq	
	idiv	dword ptr [ebp+010h];	iResDevider
	xchg	ecx,eax
	sub	eax,ecx
	and	eax,0ffffh
	or	eax,050000h
	push	eax
	push	0372h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 329                       SLM_SETTICKSIZE,MPFROM2SHORT(((usCount * 64 / iResDevider) - (4 / iResDevider)),5),NULL);
; 330     sprintf(acBuffer,"%uK",(usCount * 16));
	xor	eax,eax
	mov	ax,[ebp-02h];	usCount
	sal	eax,04h
	push	eax
	mov	edx,offset FLAT:@STATc
	lea	eax,[ebp-034h];	acBuffer
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 331     WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
	lea	eax,[ebp-034h];	acBuffer
	push	eax
	xor	eax,eax
	mov	ax,[ebp-02h];	usCount
	sal	eax,06h
	cdq	
	idiv	dword ptr [ebp+010h];	iResDevider
	mov	ecx,eax
	mov	eax,04h
	cdq	
	idiv	dword ptr [ebp+010h];	iResDevider
	xchg	ecx,eax
	sub	eax,ecx
	and	eax,0ffffh
	push	eax
	push	0370h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 332                       MPFROMSHORT(((usCount * 64 / iResDevider) - (4 / iResDevider))), MPFROMP(acBuffer));
; 333     }

; 326   for (usCount = 1; usCount < 4; usCount++ )
	mov	ax,[ebp-02h];	usCount
	inc	ax
	mov	[ebp-02h],ax;	usCount
	mov	ax,[ebp-02h];	usCount
	cmp	ax,04h
	jb	@BLBL77
@BLBL76:

; 334   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
	push	0h
	mov	eax,[ebp-038h];	iExtent
	dec	eax
	and	eax,0ffffh
	or	eax,050000h
	push	eax
	push	0372h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 336   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
	push	offset FLAT:@STATd
	mov	eax,[ebp-038h];	iExtent
	dec	eax
	and	eax,0ffffh
	push	eax
	push	0370h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 339   WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,
	mov	ecx,0ah
	lea	edx,[ebp-034h];	acBuffer
	mov	eax,[ebp+0ch];	ulBuffLen
	call	_ltoa
	push	eax
	push	01306h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 341   }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
InitReadBufferSize	endp

; 344   {
	align 010h

	public InitWriteBufferSize
InitWriteBufferSize	proc
	push	ebp
	mov	ebp,esp
	sub	esp,038h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,0eh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 349   int iExtent = 253;
	mov	dword ptr [ebp-038h],0fdh;	iExtent

; 350 
; 351   if (iResDevider == 2)
	cmp	dword ptr [ebp+010h],02h;	iResDevider
	jne	@BLBL79

; 352     iExtent = 127;
	mov	dword ptr [ebp-038h],07fh;	iExtent
@BLBL79:

; 353   SliderData.cbSize = sizeof(SLDCDATA);
	mov	dword ptr [ebp-0eh],0ch;	SliderData

; 354   SliderData.usScale1Increments = iExtent;
	mov	eax,[ebp-038h];	iExtent
	mov	[ebp-0ah],ax;	SliderData

; 355   SliderData.usScale1Spacing = 1;
	mov	word ptr [ebp-08h],01h;	SliderData

; 356   SliderData.usScale2Increments = iExtent;
	mov	eax,[ebp-038h];	iExtent
	mov	[ebp-06h],ax;	SliderData

; 357   SliderData.usScale2Spacing = 1;
	mov	word ptr [ebp-04h],01h;	SliderData

; 358 
; 359   wprm.fsStatus = WPM_CTLDATA;
	mov	dword ptr [ebp-02ah],02h;	wprm

; 360   wprm.cchText = 0;
	mov	dword ptr [ebp-026h],0h;	wprm

; 361   wprm.cbPresParams = 0;
	mov	dword ptr [ebp-01eh],0h;	wprm

; 362   wprm.cbCtlData = 0;
	mov	dword ptr [ebp-016h],0h;	wprm

; 363   wprm.pCtlData = &SliderData;
	lea	eax,[ebp-0eh];	SliderData
	mov	[ebp-012h],eax;	wprm

; 364   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
	push	0h
	lea	eax,[ebp-02ah];	wprm
	push	eax
	push	0ah
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 365                     WM_SETWINDOWPARAMS,(MPARAM)&wprm,(MPARAM)NULL ) ;
; 366 
; 367   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSLIDERINFO,
	mov	eax,[ebp+0ch];	ulBuffLen
	shr	eax,05h
	mov	ecx,[ebp+010h];	iResDevider
	xor	edx,edx
	div	ecx
	mov	ecx,eax
	mov	eax,04h
	cdq	
	idiv	dword ptr [ebp+010h];	iResDevider
	xchg	ecx,eax
	sub	eax,ecx
	and	eax,0ffffh
	push	eax
	push	03h
	push	0371h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 368                     MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_RANGEVALUE),MPFROMSHORT((ulBuffLen / 32 / iResDevider) - (4 / iResDevider)));
; 369 
; 370   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
	push	0h
	push	050000h
	push	0372h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 371                     SLM_SETTICKSIZE,MPFROM2SHORT(0,5),NULL);
; 372   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
	push	offset FLAT:@STATe
	push	0h
	push	0370h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 373                     MPFROMSHORT(0), MPFROMP("128"));
; 374   for (usCount = 1; usCount < 4; usCount++ )
	mov	word ptr [ebp-02h],01h;	usCount
	mov	ax,[ebp-02h];	usCount
	cmp	ax,04h
	jae	@BLBL80
	align 010h
@BLBL81:

; 375     {
; 376     WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
	push	0h
	xor	eax,eax
	mov	ax,[ebp-02h];	usCount
	sal	eax,06h
	cdq	
	idiv	dword ptr [ebp+010h];	iResDevider
	mov	ecx,eax
	mov	eax,04h
	cdq	
	idiv	dword ptr [ebp+010h];	iResDevider
	xchg	ecx,eax
	sub	eax,ecx
	and	eax,0ffffh
	or	eax,050000h
	push	eax
	push	0372h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 377                       SLM_SETTICKSIZE,MPFROM2SHORT(((usCount * 64 / iResDevider) - (4 / iResDevider)),5),NULL);
; 378     sprintf(acBuffer,"%uK",(usCount * 2));
	xor	eax,eax
	mov	ax,[ebp-02h];	usCount
	add	eax,eax
	push	eax
	mov	edx,offset FLAT:@STATf
	lea	eax,[ebp-034h];	acBuffer
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 379     WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
	lea	eax,[ebp-034h];	acBuffer
	push	eax
	xor	eax,eax
	mov	ax,[ebp-02h];	usCount
	sal	eax,06h
	cdq	
	idiv	dword ptr [ebp+010h];	iResDevider
	mov	ecx,eax
	mov	eax,04h
	cdq	
	idiv	dword ptr [ebp+010h];	iResDevider
	xchg	ecx,eax
	sub	eax,ecx
	and	eax,0ffffh
	push	eax
	push	0370h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 380                       MPFROMSHORT(((usCount * 64 / iResDevider) - (4 / iResDevider))), MPFROMP(acBuffer));
; 381     }

; 374   for (usCount = 1; usCount < 4; usCount++ )
	mov	ax,[ebp-02h];	usCount
	inc	ax
	mov	[ebp-02h],ax;	usCount
	mov	ax,[ebp-02h];	usCount
	cmp	ax,04h
	jb	@BLBL81
@BLBL80:

; 382   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
	push	0h
	mov	eax,[ebp-038h];	iExtent
	dec	eax
	and	eax,0ffffh
	or	eax,050000h
	push	eax
	push	0372h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 384   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
	push	offset FLAT:@STAT10
	mov	eax,[ebp-038h];	iExtent
	dec	eax
	and	eax,0ffffh
	push	eax
	push	0370h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 387   WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,
	mov	ecx,0ah
	lea	edx,[ebp-034h];	acBuffer
	mov	eax,[ebp+0ch];	ulBuffLen
	call	_ltoa
	push	eax
	push	01306h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 389   }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
InitWriteBufferSize	endp

; 392   {
	align 010h

	public InitCOMscopeBufferSize
InitCOMscopeBufferSize	proc
	push	ebp
	mov	ebp,esp
	sub	esp,038h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,0eh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 397   int iExtent = 249;
	mov	dword ptr [ebp-038h],0f9h;	iExtent

; 398 
; 399   if (iResDevider == 2)
	cmp	dword ptr [ebp+010h],02h;	iResDevider
	jne	@BLBL83

; 400     iExtent = 125;
	mov	dword ptr [ebp-038h],07dh;	iExtent
@BLBL83:

; 401   SliderData.cbSize = sizeof(SLDCDATA);
	mov	dword ptr [ebp-0eh],0ch;	SliderData

; 402   SliderData.usScale1Increments = iExtent;
	mov	eax,[ebp-038h];	iExtent
	mov	[ebp-0ah],ax;	SliderData

; 403   SliderData.usScale1Spacing = 1;
	mov	word ptr [ebp-08h],01h;	SliderData

; 404   SliderData.usScale2Increments = iExtent; // 249
	mov	eax,[ebp-038h];	iExtent
	mov	[ebp-06h],ax;	SliderData

; 405   SliderData.usScale2Spacing = 1;
	mov	word ptr [ebp-04h],01h;	SliderData

; 406 
; 407   wprm.fsStatus = WPM_CTLDATA;
	mov	dword ptr [ebp-02ah],02h;	wprm

; 408   wprm.cchText = 0;
	mov	dword ptr [ebp-026h],0h;	wprm

; 409   wprm.cbPresParams = 0;
	mov	dword ptr [ebp-01eh],0h;	wprm

; 410   wprm.cbCtlData = 0;
	mov	dword ptr [ebp-016h],0h;	wprm

; 411   wprm.pCtlData = &SliderData;
	lea	eax,[ebp-0eh];	SliderData
	mov	[ebp-012h],eax;	wprm

; 412   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
	push	0h
	lea	eax,[ebp-02ah];	wprm
	push	eax
	push	0ah
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 413                     WM_SETWINDOWPARAMS,(MPARAM)&wprm,(MPARAM)NULL ) ;
; 414 
; 415   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSLIDERINFO,
	mov	eax,[ebp+0ch];	ulBuffLen
	shr	eax,07h
	mov	ecx,[ebp+010h];	iResDevider
	xor	edx,edx
	div	ecx
	mov	ecx,eax
	mov	eax,08h
	cdq	
	idiv	dword ptr [ebp+010h];	iResDevider
	xchg	ecx,eax
	sub	eax,ecx
	and	eax,0ffffh
	push	eax
	push	03h
	push	0371h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 416                     MPFROM2SHORT(SMA_SLIDERARMPOSITION,SMA_RANGEVALUE),MPFROMSHORT((ulBuffLen / 128 / iResDevider) - (8 / iResDevider)));
; 417 
; 418   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
	push	0h
	push	050000h
	push	0372h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 419                     SLM_SETTICKSIZE,MPFROM2SHORT(0,5),NULL);
; 420   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
	push	offset FLAT:@STAT11
	push	0h
	push	0370h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 421                     MPFROMSHORT(0), MPFROMP("1k"));
; 422   for (usCount = 1; usCount < 4; usCount++ )
	mov	word ptr [ebp-02h],01h;	usCount
	mov	ax,[ebp-02h];	usCount
	cmp	ax,04h
	jae	@BLBL84
	align 010h
@BLBL85:

; 423     {
; 424     WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
	push	0h
	xor	eax,eax
	mov	ax,[ebp-02h];	usCount
	sal	eax,06h
	cdq	
	idiv	dword ptr [ebp+010h];	iResDevider
	mov	ecx,eax
	mov	eax,08h
	cdq	
	idiv	dword ptr [ebp+010h];	iResDevider
	xchg	ecx,eax
	sub	eax,ecx
	and	eax,0ffffh
	or	eax,050000h
	push	eax
	push	0372h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 425                       SLM_SETTICKSIZE,MPFROM2SHORT(((usCount * 64 / iResDevider) - (8 / iResDevider)),5),NULL);
; 426     sprintf(acBuffer,"%uK",(usCount * 8));
	xor	eax,eax
	mov	ax,[ebp-02h];	usCount
	sal	eax,03h
	push	eax
	mov	edx,offset FLAT:@STAT12
	lea	eax,[ebp-034h];	acBuffer
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 427     WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
	lea	eax,[ebp-034h];	acBuffer
	push	eax
	xor	eax,eax
	mov	ax,[ebp-02h];	usCount
	sal	eax,06h
	cdq	
	idiv	dword ptr [ebp+010h];	iResDevider
	mov	ecx,eax
	mov	eax,08h
	cdq	
	idiv	dword ptr [ebp+010h];	iResDevider
	xchg	ecx,eax
	sub	eax,ecx
	and	eax,0ffffh
	push	eax
	push	0370h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 428                       MPFROMSHORT(((usCount * 64 / iResDevider) - (8 / iResDevider))), MP
; 428 FROMP(acBuffer));
; 429     }

; 422   for (usCount = 1; usCount < 4; usCount++ )
	mov	ax,[ebp-02h];	usCount
	inc	ax
	mov	[ebp-02h],ax;	usCount
	mov	ax,[ebp-02h];	usCount
	cmp	ax,04h
	jb	@BLBL85
@BLBL84:

; 430   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,
	push	0h
	mov	eax,[ebp-038h];	iExtent
	dec	eax
	and	eax,0ffffh
	or	eax,050000h
	push	eax
	push	0372h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 432   WinSendDlgItemMsg(hwndDlg,PCFG_BUFF_SLIDER,SLM_SETSCALETEXT,
	push	offset FLAT:@STAT13
	mov	eax,[ebp-038h];	iExtent
	dec	eax
	and	eax,0ffffh
	push	eax
	push	0370h
	push	01305h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 435   WinSetDlgItemText(hwndDlg,PCFG_BUFF_DATA,
	mov	ecx,0ah
	lea	edx,[ebp-034h];	acBuffer
	mov	eax,[ebp+0ch];	ulBuffLen
	call	_ltoa
	push	eax
	push	01306h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 437   }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
InitCOMscopeBufferSize	endp
CODE32	ends
end
