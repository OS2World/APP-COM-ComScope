	title	p:\utility\utility.C
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
	extrn	memset:proc
	extrn	strcpy:proc
	extrn	WinFileDlg:proc
	extrn	WinWindowFromID:proc
	extrn	WinSendMsg:proc
	extrn	WinQueryDlgItemText:proc
	extrn	atol:proc
	extrn	WinSendDlgItemMsg:proc
	extrn	WinEnableWindow:proc
	extrn	WinMessageBox:proc
	extrn	WinQuerySysValue:proc
	extrn	WinQueryWindowPos:proc
	extrn	WinSetWindowPos:proc
	extrn	_fullDump:dword
DATA32	segment
	dd	_dllentry
DATA32	ends
CODE32	segment

; 6   {
	align 010h

	public GetFileName
GetFileName	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0148h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,052h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 9   memset(&fileDlg,0,sizeof(FILEDLG));
	mov	ecx,0148h
	xor	edx,edx
	lea	eax,[ebp-0148h];	fileDlg
	call	memset

; 10   if (pszFileName[0] != 0)
	mov	eax,[ebp+0ch];	pszFileName
	cmp	byte ptr [eax],0h
	je	@BLBL1

; 11     strcpy(fileDlg.szFullFile,pszFileName);
	mov	edx,[ebp+0ch];	pszFileName
	lea	eax,[ebp-0114h];	fileDlg
	call	strcpy
@BLBL1:

; 12   fileDlg.cbSize = sizeof(FILEDLG);
	mov	dword ptr [ebp-0148h],0148h;	fileDlg

; 13   fileDlg.fl = (FDS_CENTER | FDS_OPEN_DIALOG);
	mov	dword ptr [ebp-0144h],0101h;	fileDlg

; 14   if (OpenFilterProc != NULL)
	cmp	dword ptr [ebp+014h],0h;	OpenFilterProc
	je	@BLBL2

; 15     {
; 16     fileDlg.fl |= FDS_HELPBUTTON;
	mov	eax,[ebp-0144h];	fileDlg
	or	al,08h
	mov	[ebp-0144h],eax;	fileDlg

; 17     fileDlg.pfnDlgProc = (PFNWP)OpenFilterProc;
	mov	eax,[ebp+014h];	OpenFilterProc
	mov	[ebp-012ch],eax;	fileDlg

; 18     }
@BLBL2:

; 19   fileDlg.pszTitle = pszTitle;
	mov	eax,[ebp+010h];	pszTitle
	mov	[ebp-0134h],eax;	fileDlg

; 20   WinFileDlg(HWND_DESKTOP,hwnd,&fileDlg);
	lea	eax,[ebp-0148h];	fileDlg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinFileDlg
	add	esp,0ch

; 21   if (fileDlg.lReturn != DID_OK)
	cmp	dword ptr [ebp-013ch],01h;	fileDlg
	je	@BLBL3

; 22     return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL3:

; 23   strcpy(pszFileName,fileDlg.szFullFile);
	lea	edx,[ebp-0114h];	fileDlg
	mov	eax,[ebp+0ch];	pszFileName
	call	strcpy

; 24   return(TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
GetFileName	endp

; 28   {
	align 010h

	public RemoveLeadingSpaces
RemoveLeadingSpaces	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 32   for (iIndex = 0;iIndex <= 8;iIndex++)
	mov	dword ptr [ebp-04h],0h;	iIndex
	cmp	dword ptr [ebp-04h],08h;	iIndex
	jg	@BLBL4
	align 010h
@BLBL5:

; 33     if (szString[iIndex] != ' ')
	mov	eax,[ebp+08h];	szString
	mov	ecx,[ebp-04h];	iIndex
	cmp	byte ptr [eax+ecx],020h
	jne	@BLBL4

; 32   for (iIndex = 0;iIndex <= 8;iIndex++)
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	cmp	dword ptr [ebp-04h],08h;	iIndex
	jle	@BLBL5
@BLBL4:

; 35   iOffset = 0;
	mov	dword ptr [ebp-08h],0h;	iOffset

; 36   for (;iIndex < 8;iIndex++)
	cmp	dword ptr [ebp-04h],08h;	iIndex
	jge	@BLBL8
	align 010h
@BLBL9:

; 37     szString[iOffset++] = szString[iIndex];
	mov	edx,[ebp+08h];	szString
	mov	eax,[ebp-04h];	iIndex
	mov	dl,byte ptr [edx+eax]
	mov	eax,[ebp+08h];	szString
	mov	ecx,[ebp-08h];	iOffset
	mov	byte ptr [eax+ecx],dl
	mov	eax,[ebp-08h];	iOffset
	inc	eax
	mov	[ebp-08h],eax;	iOffset

; 36   for (;iIndex < 8;iIndex++)
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	cmp	dword ptr [ebp-04h],08h;	iIndex
	jl	@BLBL9
@BLBL8:

; 38  }
	mov	esp,ebp
	pop	ebp
	ret	
RemoveLeadingSpaces	endp

; 41   {
	align 010h

	public RemoveSpaces
RemoveSpaces	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 44   for (iIndex = 0;iIndex <= 8;iIndex++)
	mov	dword ptr [ebp-04h],0h;	iIndex
	cmp	dword ptr [ebp-04h],08h;	iIndex
	jg	@BLBL11
	align 010h
@BLBL12:

; 45     if (szString[iIndex] == ' ')
	mov	eax,[ebp+08h];	szString
	mov	ecx,[ebp-04h];	iIndex
	cmp	byte ptr [eax+ecx],020h
	je	@BLBL11

; 44   for (iIndex = 0;iIndex <= 8;iIndex++)
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	cmp	dword ptr [ebp-04h],08h;	iIndex
	jle	@BLBL12
@BLBL11:

; 47   szString[iIndex] = 0;
	mov	eax,[ebp+08h];	szString
	mov	ecx,[ebp-04h];	iIndex
	mov	byte ptr [eax+ecx],0h

; 48  }
	mov	esp,ebp
	pop	ebp
	ret	
RemoveSpaces	endp

; 51   {
	align 010h

	public ASCIItoBin
ASCIItoBin	proc
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

; 52   int iIndex = 0;
	mov	dword ptr [ebp-04h],0h;	iIndex

; 53   LONG lTemp;
; 54   LONG lMultiplier = 1;
	mov	dword ptr [ebp-0ch],01h;	lMultiplier

; 55   BYTE byTemp;
; 56   LONG lValue = 0;
	mov	dword ptr [ebp-014h],0h;	lValue

; 57   int iBeginIndex;
; 58 
; 59   while ((szNumber[iIndex] == ' ') || (szNumber[iIndex] == '\t'))
	mov	eax,[ebp+08h];	szNumber
	mov	ecx,[ebp-04h];	iIndex
	cmp	byte ptr [eax+ecx],020h
	je	@BLBL19
	mov	eax,[ebp+08h];	szNumber
	mov	ecx,[ebp-04h];	iIndex
	cmp	byte ptr [eax+ecx],09h
	jne	@BLBL18
	align 010h
@BLBL19:

; 60     iIndex++;
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex

; 59   while ((szNumber[iIndex] == ' ') || (szNumber[iIndex] == '\t'))
	mov	eax,[ebp+08h];	szNumber
	mov	ecx,[ebp-04h];	iIndex
	cmp	byte ptr [eax+ecx],020h
	je	@BLBL19
	mov	eax,[ebp+08h];	szNumber
	mov	ecx,[ebp-04h];	iIndex
	cmp	byte ptr [eax+ecx],09h
	je	@BLBL19
@BLBL18:

; 61   iBeginIndex = iIndex;
	mov	eax,[ebp-04h];	iIndex
	mov	[ebp-018h],eax;	iBeginIndex

; 62   byTemp = szNumber[iIndex];
	mov	eax,[ebp+08h];	szNumber
	mov	ecx,[ebp-04h];	iIndex
	mov	al,byte ptr [eax+ecx]
	mov	[ebp-0dh],al;	byTemp

; 63   while ((byTemp != 0) && (byTemp != ' ') && (byTemp != '\t'))
	cmp	byte ptr [ebp-0dh],0h;	byTemp
	je	@BLBL25
	cmp	byte ptr [ebp-0dh],020h;	byTemp
	je	@BLBL25
	cmp	byte ptr [ebp-0dh],09h;	byTemp
	je	@BLBL25
	align 010h
@BLBL26:

; 65     if (byTemp < '0')
	mov	al,[ebp-0dh];	byTemp
	cmp	al,030h
	jb	@BLBL25

; 67     if (byTemp > '9')
	mov	al,[ebp-0dh];	byTemp
	cmp	al,039h
	jbe	@BLBL29

; 69       if (iRadix != 16)
	cmp	dword ptr [ebp+0ch],010h;	iRadix
	jne	@BLBL25

; 71       byTemp &= 0xdf;
	mov	al,[ebp-0dh];	byTemp
	and	al,0dfh
	mov	[ebp-0dh],al;	byTemp

; 72       if ((byTemp < 'A') || (byTemp > 'F'))
	mov	al,[ebp-0dh];	byTemp
	cmp	al,041h
	jb	@BLBL25
	mov	al,[ebp-0dh];	byTemp
	cmp	al,046h
	ja	@BLBL25

; 74       szNumber[iIndex] = byTemp;
	mov	eax,[ebp+08h];	szNumber
	mov	ecx,[ebp-04h];	iIndex
	mov	dl,[ebp-0dh];	byTemp
	mov	byte ptr [eax+ecx],dl

; 75       }
@BLBL29:

; 76     byTemp = szNumber[++iIndex];
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	mov	eax,[ebp+08h];	szNumber
	mov	ecx,[ebp-04h];	iIndex
	mov	al,byte ptr [eax+ecx]
	mov	[ebp-0dh],al;	byTemp

; 77     }

; 63   while ((byTemp != 0) && (byTemp != ' ') && (byTemp != '\t'))
	cmp	byte ptr [ebp-0dh],0h;	byTemp
	je	@BLBL25
	cmp	byte ptr [ebp-0dh],020h;	byTemp
	je	@BLBL25
	cmp	byte ptr [ebp-0dh],09h;	byTemp
	jne	@BLBL26
@BLBL25:

; 78   for (iIndex--;iIndex >= iBeginIndex;iIndex--)
	mov	eax,[ebp-04h];	iIndex
	dec	eax
	mov	[ebp-04h],eax;	iIndex
	mov	eax,[ebp-018h];	iBeginIndex
	cmp	[ebp-04h],eax;	iIndex
	jl	@BLBL34
	align 010h
@BLBL35:

; 80     byTemp = szNumber[iIndex];
	mov	eax,[ebp+08h];	szNumber
	mov	ecx,[ebp-04h];	iIndex
	mov	al,byte ptr [eax+ecx]
	mov	[ebp-0dh],al;	byTemp

; 81     if ((byTemp >= '0') && (byTemp <= '9'))
	mov	al,[ebp-0dh];	byTemp
	cmp	al,030h
	jb	@BLBL36
	mov	al,[ebp-0dh];	byTemp
	cmp	al,039h
	ja	@BLBL36

; 82       lTemp = (LONG)(byTemp - 0x30);
	xor	eax,eax
	mov	al,[ebp-0dh];	byTemp
	sub	eax,030h
	mov	[ebp-08h],eax;	lTemp
	jmp	@BLBL37
	align 010h
@BLBL36:

; 84       lTemp= (LONG)(byTemp - 0x37);
	xor	eax,eax
	mov	al,[ebp-0dh];	byTemp
	sub	eax,037h
	mov	[ebp-08h],eax;	lTemp
@BLBL37:

; 85     lValue += (lTemp * lMultiplier);
	mov	eax,[ebp-0ch];	lMultiplier
	imul	eax,[ebp-08h];	lTemp
	add	eax,[ebp-014h];	lValue
	mov	[ebp-014h],eax;	lValue

; 86     lMultiplier *= iRadix;
	mov	eax,[ebp+0ch];	iRadix
	imul	eax,[ebp-0ch];	lMultiplier
	mov	[ebp-0ch],eax;	lMultiplier

; 87     }

; 78   for (iIndex--;iIndex >= iBeginIndex;iIndex--)
	mov	eax,[ebp-04h];	iIndex
	dec	eax
	mov	[ebp-04h],eax;	iIndex
	mov	eax,[ebp-018h];	iBeginIndex
	cmp	[ebp-04h],eax;	iIndex
	jge	@BLBL35
@BLBL34:

; 88   return(lValue);
	mov	eax,[ebp-014h];	lValue
	mov	esp,ebp
	pop	ebp
	ret	
ASCIItoBin	endp

; 92   {
	align 010h

	public Checked
Checked	proc
	push	ebp
	mov	ebp,esp

; 93   return(SHORT1FROMMR(WinSendMsg(WinWindowFromID(hwndDlg,idDlgItem),
	movsx	eax,word ptr [ebp+0ch];	idDlgItem
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	0h
	push	0h
	push	0124h
	push	eax
	call	WinSendMsg
	add	esp,010h
	and	eax,0ffffh
	mov	esp,ebp
	pop	ebp
	ret	
Checked	endp

; 98   {
	align 010h

	public MenuItemEnable
MenuItemEnable	proc
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

; 99   WinSendMsg(WinWindowFromID(hwnd,FID_MENU),
	mov	dword ptr [ebp-08h],04000h;	@CBE1
	xor	eax,eax
	mov	ax,[ebp+0ch];	idItem
	or	eax,010000h
	mov	[ebp-0ch],eax;	@CBE2
	mov	dword ptr [ebp-010h],0192h;	@CBE3
	push	08005h
	push	dword ptr [ebp+08h];	hwnd
	call	WinWindowFromID
	add	esp,08h
	mov	[ebp-014h],eax;	@CBE4
	cmp	dword ptr [ebp+010h],0h;	bEnable
	je	@BLBL39

; 100              MM_SETITEMATTR,
; 101              MPFROM2SHORT(idItem,TRUE),
; 102              MPFROM2SHORT(MIA_DISABLED, bEnable ? ~MIA_DISABLED : MIA_DISABLED));
	mov	dword ptr [ebp-04h],0ffffbfffh;	T000000001
	jmp	@BLBL40
	align 010h
@BLBL39:
	mov	dword ptr [ebp-04h],04000h;	T000000001
@BLBL40:
	mov	ax,[ebp-04h];	T000000001
	and	eax,0ffffh
	sal	eax,010h
	or	eax,[ebp-08h];	@CBE1
	push	eax
	push	dword ptr [ebp-0ch];	@CBE2
	push	dword ptr [ebp-010h];	@CBE3
	push	dword ptr [ebp-014h];	@CBE4
	call	WinSendMsg
	add	esp,010h

; 103   }
	mov	esp,ebp
	pop	ebp
	ret	
MenuItemEnable	endp

; 106   {
	align 010h

	public MenuItemCheck
MenuItemCheck	proc
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

; 107   WinSendMsg(WinWindowFromID(hwnd,FID_MENU),
	mov	dword ptr [ebp-08h],02000h;	@CBE5
	xor	eax,eax
	mov	ax,[ebp+0ch];	idItem
	or	eax,010000h
	mov	[ebp-0ch],eax;	@CBE6
	mov	dword ptr [ebp-010h],0192h;	@CBE7
	push	08005h
	push	dword ptr [ebp+08h];	hwnd
	call	WinWindowFromID
	add	esp,08h
	mov	[ebp-014h],eax;	@CBE8
	cmp	dword ptr [ebp+010h],0h;	bCheck
	je	@BLBL41

; 108              MM_SETITEMATTR,
; 109              MPFROM2SHORT(idItem,TRUE),
; 110              MPFROM2SHORT(MIA_CHECKED, bCheck ? MIA_CHECKED : ~MIA_CHECKED));
	mov	dword ptr [ebp-04h],02000h;	T000000002
	jmp	@BLBL42
	align 010h
@BLBL41:
	mov	dword ptr [ebp-04h],0ffffdfffh;	T000000002
@BLBL42:
	mov	ax,[ebp-04h];	T000000002
	and	eax,0ffffh
	sal	eax,010h
	or	eax,[ebp-08h];	@CBE5
	push	eax
	push	dword ptr [ebp-0ch];	@CBE6
	push	dword ptr [ebp-010h];	@CBE7
	push	dword ptr [ebp-014h];	@CBE8
	call	WinSendMsg
	add	esp,010h

; 111   }
	mov	esp,ebp
	pop	ebp
	ret	
MenuItemCheck	endp

; 114   {
	align 010h

	public GetLongIntDlgItem
GetLongIntDlgItem	proc
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

; 118   iLength = WinQueryDlgItemText(hwndDlg,idEntryField,sizeof(szValue),szValue);
	lea	eax,[ebp-0ch];	szValue
	push	eax
	push	0ch
	movsx	eax,word ptr [ebp+0ch];	idEntryField
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinQueryDlgItemText
	add	esp,010h
	mov	[ebp-010h],eax;	iLength

; 119   if (iLength > 10)
	cmp	dword ptr [ebp-010h],0ah;	iLength
	jle	@BLBL43

; 120     return(FALSE);
	xor	eax,eax
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL43:

; 121   szValue[iLength] = 0;
	mov	eax,[ebp-010h];	iLength
	mov	byte ptr [ebp+eax-0ch],0h

; 122   *plValue = atol(szValue);
	lea	eax,[ebp-0ch];	szValue
	call	atol
	mov	ecx,eax
	mov	eax,[ebp+010h];	plValue
	mov	[eax],ecx

; 123   return(TRUE);
	mov	eax,01h
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
GetLongIntDlgItem	endp

; 127   {
	align 010h

	public CheckButton
CheckButton	proc
	push	ebp
	mov	ebp,esp

; 128   if (bCheck != 0)
	cmp	dword ptr [ebp+010h],0h;	bCheck
	je	@BLBL44

; 129     bCheck = 1;
	mov	dword ptr [ebp+010h],01h;	bCheck
@BLBL44:

; 130   return(WinCheckButton(hwndDlg,idItem,(USHORT)bCheck));
	push	0h
	mov	ax,[ebp+010h];	bCheck
	and	eax,0ffffh
	push	eax
	push	0125h
	xor	eax,eax
	mov	ax,[ebp+0ch];	idItem
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h
	mov	esp,ebp
	pop	ebp
	ret	
CheckButton	endp

; 134   {
	align 010h

	public ControlEnable
ControlEnable	proc
	push	ebp
	mov	ebp,esp

; 135   WinEnableWindow(WinWindowFromID(hwndDlg,idItem),bEnable);
	xor	eax,eax
	mov	ax,[ebp+0ch];	idItem
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	dword ptr [ebp+010h];	bEnable
	push	eax
	call	WinEnableWindow
	add	esp,08h

; 136   }
	mov	esp,ebp
	pop	ebp
	ret	
ControlEnable	endp

; 139   {
	align 010h

	public MessageBox
MessageBox	proc
	push	ebp
	mov	ebp,esp

; 141     WinMessageBox(HWND_DESKTOP,
	push	04020h
	push	0h
	push	0h
	push	dword ptr [ebp+0ch];	pszMessage
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h

; 142                   hwnd,
; 143                   pszMessage,
; 144                   NULL,
; 145                   0,
; 146                   MB_MOVEABLE | MB_OK | MB_CUAWARNING);
; 147   }
	mov	esp,ebp
	pop	ebp
	ret	
MessageBox	endp

; 150   {
	align 010h

	public CenterDlgBox
CenterDlgBox	proc
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

; 155   lXScr = (SHORT)WinQuerySysValue(HWND_DESKTOP,SV_CXSCREEN);
	push	014h
	push	01h
	call	WinQuerySysValue
	add	esp,08h
	movsx	eax,ax
	mov	[ebp-028h],eax;	lXScr

; 156   lYScr = (SHORT)WinQuerySysValue(HWND_DESKTOP,SV_CYSCREEN);
	push	015h
	push	01h
	call	WinQuerySysValue
	add	esp,08h
	movsx	eax,ax
	mov	[ebp-02ch],eax;	lYScr

; 157 
; 158   WinQueryWindowPos(hwnd,&swp);
	lea	eax,[ebp-024h];	swp
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryWindowPos
	add	esp,08h

; 159   WinSetWindowPos(hwnd,0L,((lXScr - swp.cx) / 2),((lYScr - swp.cy) / 2),0,0,SWP_MOVE);
	push	02h
	push	0h
	push	0h
	mov	eax,[ebp-02ch];	lYScr
	sub	eax,[ebp-020h];	swp
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	push	eax
	mov	eax,[ebp-028h];	lXScr
	sub	eax,[ebp-01ch];	swp
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	push	eax
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowPos
	add	esp,01ch

; 160   }
	mov	esp,ebp
	pop	ebp
	ret	
CenterDlgBox	endp

; 163   {
	align 010h

	public AppendTMP
AppendTMP	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 164   USHORT wIndex = 0;
	mov	word ptr [ebp-02h],0h;	wIndex

; 165 
; 166   while (szFileSpec[wIndex++] != 0);
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL45
	align 010h
@BLBL46:
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],0h
	jne	@BLBL46
@BLBL45:
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex

; 167   while (szFileSpec[--wIndex] != '.')
	mov	ax,[ebp-02h];	wIndex
	dec	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],02eh
	je	@BLBL49
	align 010h
@BLBL50:

; 168     {
; 169     if (wIndex == 0)
	cmp	word ptr [ebp-02h],0h;	wIndex
	jne	@BLBL51

; 170       {
; 171       while (szFileSpec[wIndex++] != 0);
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL52
	align 010h
@BLBL53:
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],0h
	jne	@BLBL53
@BLBL52:
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex

; 172       szFileSpec[--wIndex] = '.';
	mov	ax,[ebp-02h];	wIndex
	dec	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	mov	byte ptr [eax+ecx],02eh

; 173       break;
	jmp	@BLBL49
	align 010h
@BLBL51:

; 174       }
; 175     }

; 167   while (szFileSpec[--wIndex] != '.')
	mov	ax,[ebp-02h];	wIndex
	dec	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],02eh
	jne	@BLBL50
@BLBL49:

; 176   szFileSpec[++wIndex] = 'T';
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	mov	byte ptr [eax+ecx],054h

; 177   szFileSpec[++wIndex] = 'M';
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	mov	byte ptr [eax+ecx],04dh

; 178   szFileSpec[++wIndex] = 'P';
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	mov	byte ptr [eax+ecx],050h

; 179   szFileSpec[++wIndex] = 0;
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	mov	byte ptr [eax+ecx],0h

; 180   }
	mov	esp,ebp
	pop	ebp
	ret	
AppendTMP	endp

; 183   {
	align 010h

	public AppendINI
AppendINI	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 184   USHORT wIndex = 0;
	mov	word ptr [ebp-02h],0h;	wIndex

; 185 
; 186   while (szFileSpec[wIndex++] != 0);
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL57
	align 010h
@BLBL58:
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],0h
	jne	@BLBL58
@BLBL57:
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex

; 187   while (szFileSpec[--wIndex] != '.')
	mov	ax,[ebp-02h];	wIndex
	dec	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],02eh
	je	@BLBL61
	align 010h
@BLBL62:

; 188     {
; 189     if (wIndex == 0)
	cmp	word ptr [ebp-02h],0h;	wIndex
	jne	@BLBL63

; 190       {
; 191       while (szFileSpec[wIndex++] != 0);
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL64
	align 010h
@BLBL65:
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],0h
	jne	@BLBL65
@BLBL64:
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex

; 192       szFileSpec[--wIndex] = '.';
	mov	ax,[ebp-02h];	wIndex
	dec	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	mov	byte ptr [eax+ecx],02eh

; 193       break;
	jmp	@BLBL61
	align 010h
@BLBL63:

; 194       }
; 195     }

; 187   while (szFileSpec[--wIndex] != '.')
	mov	ax,[ebp-02h];	wIndex
	dec	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],02eh
	jne	@BLBL62
@BLBL61:

; 196   szFileSpec[++wIndex] = 'I';
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	mov	byte ptr [eax+ecx],049h

; 197   szFileSpec[++wIndex] = 'N';
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	mov	byte ptr [eax+ecx],04eh

; 198   szFileSpec[++wIndex] = 'I';
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	mov	byte ptr [eax+ecx],049h

; 199   szFileSpec[++wIndex] = 0;
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	mov	byte ptr [eax+ecx],0h

; 200   }
	mov	esp,ebp
	pop	ebp
	ret	
AppendINI	endp

; 203   {
	align 010h

	public AppendHLP
AppendHLP	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 204   USHORT wIndex = 0;
	mov	word ptr [ebp-02h],0h;	wIndex

; 205 
; 206   while (szFileSpec[wIndex++] != 0);
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL69
	align 010h
@BLBL70:
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],0h
	jne	@BLBL70
@BLBL69:
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex

; 207   while (szFileSpec[--wIndex] != '.')
	mov	ax,[ebp-02h];	wIndex
	dec	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],02eh
	je	@BLBL73
	align 010h
@BLBL74:

; 208     {
; 209     if (wIndex == 0)
	cmp	word ptr [ebp-02h],0h;	wIndex
	jne	@BLBL75

; 210       {
; 211       while (szFileSpec[wIndex++] != 0);
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL76
	align 010h
@BLBL77:
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],0h
	jne	@BLBL77
@BLBL76:
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex

; 212       szFileSpec[--wIndex] = '.';
	mov	ax,[ebp-02h];	wIndex
	dec	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	mov	byte ptr [eax+ecx],02eh

; 213       break;
	jmp	@BLBL73
	align 010h
@BLBL75:

; 214       }
; 215     }

; 207   while (szFileSpec[--wIndex] != '.')
	mov	ax,[ebp-02h];	wIndex
	dec	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	cmp	byte ptr [eax+ecx],02eh
	jne	@BLBL74
@BLBL73:

; 216   szFileSpec[++wIndex] = 'H';
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	mov	byte ptr [eax+ecx],048h

; 217   szFileSpec[++wIndex] = 'L';
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	mov	byte ptr [eax+ecx],04ch

; 218   szFileSpec[++wIndex] = 'P';
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	mov	byte ptr [eax+ecx],050h

; 219   szFileSpec[++wIndex] = 0;
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szFileSpec
	mov	byte ptr [eax+ecx],0h

; 220   }
	mov	esp,ebp
	pop	ebp
	ret	
AppendHLP	endp

; 223     {
	align 010h

	public AppendPath
AppendPath	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 224     USHORT wIndex = 0;
	mov	word ptr [ebp-02h],0h;	wIndex

; 225     CHAR *pStringPtr;
; 226 
; 227     pStringPtr = pszPathEnd;
	mov	eax,[ebp+08h];	pszPathEnd
	mov	[ebp-08h],eax;	pStringPtr

; 228     pStringPtr--;
	mov	eax,[ebp-08h];	pStringPtr
	dec	eax
	mov	[ebp-08h],eax;	pStringPtr

; 229     if ((*pStringPtr != '\\') && (*pStringPtr != '/')  && (*pStringPtr != ':'))
	mov	eax,[ebp-08h];	pStringPtr
	cmp	byte ptr [eax],05ch
	je	@BLBL81
	mov	eax,[ebp-08h];	pStringPtr
	cmp	byte ptr [eax],02fh
	je	@BLBL81
	mov	eax,[ebp-08h];	pStringPtr
	cmp	byte ptr [eax],03ah
	je	@BLBL81

; 230       {
; 231       pStringPtr++;
	mov	eax,[ebp-08h];	pStringPtr
	inc	eax
	mov	[ebp-08h],eax;	pStringPtr

; 232       *pStringPtr = '\\';
	mov	eax,[ebp-08h];	pStringPtr
	mov	byte ptr [eax],05ch

; 233       }
@BLBL81:

; 234     pStringPtr++;
	mov	eax,[ebp-08h];	pStringPtr
	inc	eax
	mov	[ebp-08h],eax;	pStringPtr

; 235     while (pszFileName[wIndex] != 0)
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+0ch];	pszFileName
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL82
	align 010h
@BLBL83:

; 236         *pStringPtr++ = pszFileName[wIndex++];
	xor	eax,eax
	mov	ax,[ebp-02h];	wIndex
	mov	ecx,[ebp+0ch];	pszFileName
	mov	cl,byte ptr [ecx+eax]
	mov	eax,[ebp-08h];	pStringPtr
	mov	[eax],cl
	mov	eax,[ebp-08h];	pStringPtr
	inc	eax
	mov	[ebp-08h],eax;	pStringPtr
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex

; 235     while (pszFileName[wIndex] != 0)
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+0ch];	pszFileName
	cmp	byte ptr [eax+ecx],0h
	jne	@BLBL83
@BLBL82:

; 237     *pStringPtr = 0;
	mov	eax,[ebp-08h];	pStringPtr
	mov	byte ptr [eax],0h

; 238     }
	mov	esp,ebp
	pop	ebp
	ret	
AppendPath	endp

; 241   {
	align 010h

	public RemoveSystemMenuItem
RemoveSystemMenuItem	proc
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

; 248   if ((hwndSysMenu = WinWindowFromID(hwnd,FID_SYSMENU)) != 0)
	push	08002h
	push	dword ptr [ebp+08h];	hwnd
	call	WinWindowFromID
	add	esp,08h
	mov	[ebp-04h],eax;	hwndSysMenu
	cmp	dword ptr [ebp-04h],0h;	hwndSysMenu
	je	@BLBL85

; 249     {
; 250     if (WinSendMsg(hwndSysMenu,MM_QUERYITEM,MPFROM2SHORT(SC_SYSMENU,FALSE),MPFROMP(&miTemp)))
	lea	eax,[ebp-014h];	miTemp
	push	eax
	push	08007h
	push	0182h
	push	dword ptr [ebp-04h];	hwndSysMenu
	call	WinSendMsg
	add	esp,010h
	test	eax,eax
	je	@BLBL85

; 251       WinSendMsg(miTemp.hwndSubMenu,MM_DELETEITEM,MPFROM2SHORT(usMenuItem,FALSE),NULL);
	push	0h
	xor	eax,eax
	mov	ax,[ebp+0ch];	usMenuItem
	push	eax
	push	0181h
	push	dword ptr [ebp-0ch];	miTemp
	call	WinSendMsg
	add	esp,010h

; 252     }
@BLBL85:

; 253   }
	mov	esp,ebp
	pop	ebp
	ret	
RemoveSystemMenuItem	endp

; 256   {
	align 010h

	public MakeDeviceName
MakeDeviceName	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 257   USHORT wIndex = 0;
	mov	word ptr [ebp-02h],0h;	wIndex

; 258 
; 259   while (szName[wIndex++] != 0);
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szName
	cmp	byte ptr [eax+ecx],0h
	je	@BLBL87
	align 010h
@BLBL88:
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szName
	cmp	byte ptr [eax+ecx],0h
	jne	@BLBL88
@BLBL87:
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex

; 260   wIndex--;
	mov	ax,[ebp-02h];	wIndex
	dec	ax
	mov	[ebp-02h],ax;	wIndex

; 261   if (wIndex >= 8)
	mov	ax,[ebp-02h];	wIndex
	cmp	ax,08h
	jae	@BLBL92

; 262     return;
; 263   for (;wIndex < 8;wIndex++)
	mov	ax,[ebp-02h];	wIndex
	cmp	ax,08h
	jae	@BLBL92
	align 010h
@BLBL93:

; 264     szName[wIndex] = ' ';
	xor	ecx,ecx
	mov	cx,[ebp-02h];	wIndex
	mov	eax,[ebp+08h];	szName
	mov	byte ptr [eax+ecx],020h

; 263   for (;wIndex < 8;wIndex++)
	mov	ax,[ebp-02h];	wIndex
	inc	ax
	mov	[ebp-02h],ax;	wIndex
	mov	ax,[ebp-02h];	wIndex
	cmp	ax,08h
	jb	@BLBL93
@BLBL92:

; 265   }
	mov	esp,ebp
	pop	ebp
	ret	
MakeDeviceName	endp

; 268   {
	align 010h

	public AppendTripleDS
AppendTripleDS	proc
	push	ebp
	mov	ebp,esp

; 269   szString[9] = 0;
	mov	eax,[ebp+08h];	szString
	mov	byte ptr [eax+09h],0h

; 270   szString[8] = szString[5];
	mov	ecx,[ebp+08h];	szString
	mov	cl,[ecx+05h]
	mov	eax,[ebp+08h];	szString
	mov	[eax+08h],cl

; 271   szString[7] = szString[4];
	mov	ecx,[ebp+08h];	szString
	mov	cl,[ecx+04h]
	mov	eax,[ebp+08h];	szString
	mov	[eax+07h],cl

; 272   szString[6] = szString[3];
	mov	ecx,[ebp+08h];	szString
	mov	cl,[ecx+03h]
	mov	eax,[ebp+08h];	szString
	mov	[eax+06h],cl

; 273   szString[5] = '$';
	mov	eax,[ebp+08h];	szString
	mov	byte ptr [eax+05h],024h

; 274   szString[4] = '$';
	mov	eax,[ebp+08h];	szString
	mov	byte ptr [eax+04h],024h

; 275   szString[3] = '$';
	mov	eax,[ebp+08h];	szString
	mov	byte ptr [eax+03h],024h

; 276   }
	mov	esp,ebp
	pop	ebp
	ret	
AppendTripleDS	endp
CODE32	ends
end
