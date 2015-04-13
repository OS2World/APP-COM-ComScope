	title	p:\COMcontrol\comcontrol.c
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
	extrn	WinSendMsg:proc
	extrn	MessageBox:proc
	extrn	WinSetWindowText:proc
	extrn	GetDCB:proc
	extrn	WinDismissDlg:proc
	extrn	FillHdwFilterDlg:proc
	extrn	Checked:proc
	extrn	ControlEnable:proc
	extrn	UnloadHdwFilterDlg:proc
	extrn	SendDCB:proc
	extrn	WinDefDlgProc:proc
	extrn	WinPostMsg:proc
	extrn	FillHdwTimeoutDlg:proc
	extrn	TCHdwTimeoutDlg:proc
	extrn	UnloadHdwTimeoutDlg:proc
	extrn	GetFIFOinfo:proc
	extrn	FillHandshakeDlg:proc
	extrn	TCHandshakeDlg:proc
	extrn	UnloadHandshakeDlg:proc
	extrn	SetFIFO:proc
	extrn	GetLineCharacteristics:proc
	extrn	FillHdwProtocolDlg:proc
	extrn	TCHdwProtocolDlg:proc
	extrn	UnloadHdwProtocolDlg:proc
	extrn	SetLineCharacteristics:proc
	extrn	GetBaudRates:proc
	extrn	WinSendDlgItemMsg:proc
	extrn	_ltoa:proc
	extrn	WinSetDlgItemText:proc
	extrn	WinQueryDlgItemText:proc
	extrn	atol:proc
	extrn	SetBaudRate:proc
	extrn	FillHdwFIFOsetupDlg:proc
	extrn	TCHdwFIFOsetupDlg:proc
	extrn	UnloadHdwFIFOsetupDlg:proc
	extrn	WinDlgBox:proc
	extrn	_fullDump:dword
	extrn	aul12xBaudTable:byte
	extrn	aul4xBaudTable:byte
	extrn	aulStdBaudTable:byte
DATA32	segment
@STAT1	db "Unable to display Extern"
db "al Help Panel",0h
	align 04h
@STAT2	db "External Help is not Ini"
db "tialized",0h
	dd	_dllentry
DATA32	ends
BSS32	segment
	align 04h
comm	hThisModule:dword
@13stComDCB	db 0bh DUP (0h)
	align 04h
@14pstComCtl	dd 0h
@26stComDCB	db 0bh DUP (0h)
	align 04h
@27bAllowClick	dd 0h
@28pstComCtl	dd 0h
@32stComDCB	db 0bh DUP (0h)
	align 04h
@33bAllowClick	dd 0h
@34pstComCtl	dd 0h
@35stFIFOinfo	db 0ah DUP (0h)
@46stLineChar	db 04h DUP (0h)
	align 04h
@47pstComCtl	dd 0h
@48bAllowClick	dd 0h
@58bAllowClick	dd 0h
@59pstComCtl	dd 0h
@73stComDCB	db 0bh DUP (0h)
	align 04h
@74bAllowClick	dd 0h
@75pstComCtl	dd 0h
@76pstFIFOinfo	dd 0h
BSS32	ends
CODE32	segment

; 45   {
	align 010h

	public _DLL_InitTerm
_DLL_InitTerm	proc
	push	ebp
	mov	ebp,esp

; 46   if (ulTermCode == 0)
	cmp	dword ptr [ebp+0ch],0h;	ulTermCode
	jne	@BLBL1

; 47     hThisModule = hMod;
	mov	eax,[ebp+08h];	hMod
	mov	dword ptr  hThisModule,eax
@BLBL1:

; 48   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
_DLL_InitTerm	endp

; 52   {
	align 010h

	public DisplayHelpPanel
DisplayHelpPanel	proc
	push	ebp
	mov	ebp,esp

; 53   if (pstComCtl->hwndHelpInstance != 0)
	mov	eax,[ebp+08h];	pstComCtl
	cmp	dword ptr [eax+0ah],0h
	je	@BLBL2

; 54     {
; 55     if (WinSendMsg(pstComCtl->hwndHelpInstance,HM_DISPLAY_HELP,
	push	0h
	mov	ecx,[ebp+08h];	pstComCtl
	xor	eax,eax
	mov	ax,[ecx+0eh]
	push	eax
	push	0222h
	mov	eax,[ebp+08h];	pstComCtl
	push	dword ptr [eax+0ah]
	call	WinSendMsg
	add	esp,010h
	test	eax,eax
	je	@BLBL4

; 56                    MPFROM2SHORT(pstComCtl->usHelpId,NULL),
; 57                    MPFROMSHORT(HM_RESOURCEID)))
; 58       MessageBox(HWND_DESKTOP,"Unable to display External Help Panel");
	push	offset FLAT:@STAT1
	push	01h
	call	MessageBox
	add	esp,08h

; 59     }
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL2:

; 60   else
; 61     MessageBox(HWND_DESKTOP,"External Help is not Initialized");
	push	offset FLAT:@STAT2
	push	01h
	call	MessageBox
	add	esp,08h
@BLBL4:

; 62   }
	mov	esp,ebp
	pop	ebp
	ret	
DisplayHelpPanel	endp

; 65   {
	align 010h

	public fnwpHdwFilterDlg
fnwpHdwFilterDlg	proc
	push	ebp
	mov	ebp,esp

; 69   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL13
	align 04h
@BLBL14:

; 70     {
; 71     case WM_INITDLG:
; 72 //      CenterDlgBox(hwnd);
; 73 //      WinSetFocus(HWND_DESKTOP,hwnd);
; 74       pstComCtl = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @14pstComCtl,eax

; 75       if (pstComCtl->pszPortName != NULL)
	mov	eax,dword ptr  @14pstComCtl
	cmp	dword ptr [eax+02h],0h
	je	@BLBL5

; 76         WinSetWindowText(hwnd,pstComCtl->pszPortName);
	mov	eax,dword ptr  @14pstComCtl
	push	dword ptr [eax+02h]
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowText
	add	esp,08h
@BLBL5:

; 77       if (GetDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB))
	push	offset FLAT:@13stComDCB
	mov	eax,dword ptr  @14pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,dword ptr  @14pstComCtl
	push	dword ptr [eax+010h]
	call	GetDCB
	add	esp,0ch
	test	eax,eax
	je	@BLBL6

; 78         {
; 79         WinDismissDlg(hwnd,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 80         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL6:

; 81         }
; 82       FillHdwFilterDlg(hwnd,&stComDCB);
	push	offset FLAT:@13stComDCB
	push	dword ptr [ebp+08h];	hwnd
	call	FillHdwFilterDlg
	add	esp,08h

; 83       break;
	jmp	@BLBL12
	align 04h
@BLBL15:

; 84     case WM_CONTROL:
; 85       if(SHORT2FROMMP(mp1) == BN_CLICKED)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL7

; 86         {
; 87         switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL17
	align 04h
@BLBL18:

; 88           {
; 89           case HWR_ENABERR:
; 90             if (!Checked(hwnd,HWR_ENABERR))
	push	04b7h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL8

; 91               {
; 92               ControlEnable(hwnd,HWR_ERRTTT,FALSE);
	push	0h
	push	01453h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 93               ControlEnable(hwnd,HWR_ERRTT,FALSE);
	push	0h
	push	01451h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 94               ControlEnable(hwnd,HWR_ERRT,FALSE);
	push	0h
	push	04b3h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 95               ControlEnable(hwnd,HWR_ERRCHAR,FALSE);
	push	0h
	push	04b4h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 96               }
	jmp	@BLBL9
	align 010h
@BLBL8:

; 97             else
; 98               {
; 99               ControlEnable(hwnd,HWR_ERRTTT,TRUE);
	push	01h
	push	01453h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 100               ControlEnable(hwnd,HWR_ERRTT,TRUE);
	push	01h
	push	01451h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 101               ControlEnable(hwnd,HWR_ERRT,TRUE);
	push	01h
	push	04b3h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 102               ControlEnable(hwnd,HWR_ERRCHAR,TRUE);
	push	01h
	push	04b4h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 103               }
@BLBL9:

; 104             break;
	jmp	@BLBL16
	align 04h
@BLBL19:

; 105           case HWR_ENABBRK:
; 106             if (!Checked(hwnd,HWR_ENABBRK))
	push	04b6h
	push	dword ptr [ebp+08h];	hwnd
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL10

; 107               {
; 108               ControlEnable(hwnd,HWR_BRKTTT,FALSE);
	push	0h
	push	01454h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 109               ControlEnable(hwnd,HWR_BRKTT,FALSE);
	push	0h
	push	01452h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 110               ControlEnable(hwnd,HWR_BRKT,FALSE);
	push	0h
	push	04b2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 111               ControlEnable(hwnd,HWR_BRKCHAR,FALSE);
	push	0h
	push	04b1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 112               }
	jmp	@BLBL11
	align 010h
@BLBL10:

; 113             else
; 114               {
; 115               ControlEnable(hwnd,HWR_BRKTTT,TRUE);
	push	01h
	push	01454h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 116               ControlEnable(hwnd,HWR_BRKTT,TRUE);
	push	01h
	push	01452h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 117               ControlEnable(hwnd,HWR_BRKT,TRUE);
	push	01h
	push	04b2h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 118               ControlEnable(hwnd,HWR_BRKCHAR,TRUE);
	push	01h
	push	04b1h
	push	dword ptr [ebp+08h];	hwnd
	call	ControlEnable
	add	esp,0ch

; 119               }
@BLBL11:

; 120             break;
	jmp	@BLBL16
	align 04h
@BLBL20:

; 121           default:
; 122            return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL16
	align 04h
@BLBL17:
	cmp	eax,04b7h
	je	@BLBL18
	cmp	eax,04b6h
	je	@BLBL19
	jmp	@BLBL20
	align 04h
@BLBL16:

; 123           }
; 124         }
@BLBL7:

; 125       break;
	jmp	@BLBL12
	align 04h
@BLBL21:

; 126     case WM_COMMAND:
; 127       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL23
	align 04h
@BLBL24:

; 128         {
; 129         case DID_OK:
; 130           UnloadHdwFilterDlg(hwnd,&stComDCB);
	push	offset FLAT:@13stComDCB
	push	dword ptr [ebp+08h];	hwnd
	call	UnloadHdwFilterDlg
	add	esp,08h

; 131           SendDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB);
	push	offset FLAT:@13stComDCB
	mov	eax,dword ptr  @14pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,dword ptr  @14pstComCtl
	push	dword ptr [eax+010h]
	call	SendDCB
	add	esp,0ch

; 132           WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 133           break;
	jmp	@BLBL22
	align 04h
@BLBL25:

; 134         case DID_CANCEL:
; 135           WinDismissDlg(hwnd,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 136           break;
	jmp	@BLBL22
	align 04h
@BLBL26:

; 137         case DID_HELP:
; 138           DisplayHelpPanel(pstComCtl);
	push	dword ptr  @14pstComCtl
	call	DisplayHelpPanel
	add	esp,04h

; 139           break;
	jmp	@BLBL22
	align 04h
@BLBL27:

; 140         default:
; 141           return WinDefDlgProc(hwnd,msg,mp1,mp2);
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
	jmp	@BLBL22
	align 04h
@BLBL23:
	cmp	eax,01h
	je	@BLBL24
	cmp	eax,02h
	je	@BLBL25
	cmp	eax,012dh
	je	@BLBL26
	jmp	@BLBL27
	align 04h
@BLBL22:

; 142         }
; 143       break;
	jmp	@BLBL12
	align 04h
@BLBL28:

; 144     default:
; 145       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
	jmp	@BLBL12
	align 04h
@BLBL13:
	cmp	eax,03bh
	je	@BLBL14
	cmp	eax,030h
	je	@BLBL15
	cmp	eax,020h
	je	@BLBL21
	jmp	@BLBL28
	align 04h
@BLBL12:

; 146     }
; 147   return FALSE;
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpHdwFilterDlg	endp

; 154   {
	align 010h

	public fnwpHdwTimeoutDlg
fnwpHdwTimeoutDlg	proc
	push	ebp
	mov	ebp,esp

; 159   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL35
	align 04h
@BLBL36:

; 160     {
; 161     case WM_INITDLG:
; 162 //      CenterDlgBox(hwnd);
; 163 //      WinSetFocus(HWND_DESKTOP,hwnd);
; 164       bAllowClick = FALSE;
	mov	dword ptr  @27bAllowClick,0h

; 165       pstComCtl = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @28pstComCtl,eax

; 166       if (GetDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB))
	push	offset FLAT:@26stComDCB
	mov	eax,dword ptr  @28pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,dword ptr  @28pstComCtl
	push	dword ptr [eax+010h]
	call	GetDCB
	add	esp,0ch
	test	eax,eax
	je	@BLBL29

; 167         {
; 168         WinDismissDlg(hwnd,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 169         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL29:

; 170         }
; 171       if (pstComCtl->pszPortName != NULL)
	mov	eax,dword ptr  @28pstComCtl
	cmp	dword ptr [eax+02h],0h
	je	@BLBL30

; 172         WinSetWindowText(hwnd,pstComCtl->pszPortName);
	mov	eax,dword ptr  @28pstComCtl
	push	dword ptr [eax+02h]
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowText
	add	esp,08h
@BLBL30:

; 173       WinPostMsg(hwnd,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	02710h
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 174       break;
	jmp	@BLBL34
	align 04h
@BLBL37:

; 175     case UM_INITLS:
; 176       FillHdwTimeoutDlg(hwnd,&stComDCB);
	push	offset FLAT:@26stComDCB
	push	dword ptr [ebp+08h];	hwnd
	call	FillHdwTimeoutDlg
	add	esp,08h

; 177       bAllowClick = TRUE;
	mov	dword ptr  @27bAllowClick,01h

; 178       break;
	jmp	@BLBL34
	align 04h
@BLBL38:

; 179     case WM_CONTROL:
; 180       if (SHORT2FROMMP(mp1) == BN_CLICKED)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL31

; 181         if (bAllowClick)
	cmp	dword ptr  @27bAllowClick,0h
	je	@BLBL31

; 182           if (!TCHdwTimeoutDlg(hwnd,SHORT1FROMMP(mp1)))
	mov	ax,[ebp+010h];	mp1
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	TCHdwTimeoutDlg
	add	esp,08h
	test	eax,eax
	jne	@BLBL31

; 183             return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL31:

; 184       break;
	jmp	@BLBL34
	align 04h
@BLBL39:

; 185     case WM_COMMAND:
; 186       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL41
	align 04h
@BLBL42:

; 187         {
; 188         case DID_OK:
; 189           UnloadHdwTimeoutDlg(hwnd,&stComDCB);
	push	offset FLAT:@26stComDCB
	push	dword ptr [ebp+08h];	hwnd
	call	UnloadHdwTimeoutDlg
	add	esp,08h

; 190           SendDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB);
	push	offset FLAT:@26stComDCB
	mov	eax,dword ptr  @28pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,dword ptr  @28pstComCtl
	push	dword ptr [eax+010h]
	call	SendDCB
	add	esp,0ch

; 191           WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 192           break;
	jmp	@BLBL40
	align 04h
@BLBL43:

; 193         case DID_CANCEL:
; 194           WinDismissDlg(hwnd,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 195           break;
	jmp	@BLBL40
	align 04h
@BLBL44:

; 196         case DID_HELP:
; 197           DisplayHelpPanel(pstComCtl);
	push	dword ptr  @28pstComCtl
	call	DisplayHelpPanel
	add	esp,04h

; 198           break;
	jmp	@BLBL40
	align 04h
@BLBL45:

; 199         default:
; 200           return WinDefDlgProc(hwnd,msg,mp1,mp2);
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
	jmp	@BLBL40
	align 04h
@BLBL41:
	cmp	eax,01h
	je	@BLBL42
	cmp	eax,02h
	je	@BLBL43
	cmp	eax,012dh
	je	@BLBL44
	jmp	@BLBL45
	align 04h
@BLBL40:

; 201         }
; 202       break;
	jmp	@BLBL34
	align 04h
@BLBL46:

; 203     default:
; 204       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
	jmp	@BLBL34
	align 04h
@BLBL35:
	cmp	eax,03bh
	je	@BLBL36
	cmp	eax,02710h
	je	@BLBL37
	cmp	eax,030h
	je	@BLBL38
	cmp	eax,020h
	je	@BLBL39
	jmp	@BLBL46
	align 04h
@BLBL34:

; 205     }
; 206   return FALSE;
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpHdwTimeoutDlg	endp

; 213   {
	align 010h

	public fnwpHandshakeDlg
fnwpHandshakeDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 220   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL54
	align 04h
@BLBL55:

; 221     {
; 222     case WM_INITDLG:
; 223 //      CenterDlgBox(hwnd);
; 224 //      WinSetFocus(HWND_DESKTOP,hwnd);
; 225       bAllowClick = FALSE;
	mov	dword ptr  @33bAllowClick,0h

; 226       pstComCtl = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @34pstComCtl,eax

; 227       if (GetDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB))
	push	offset FLAT:@32stComDCB
	mov	eax,dword ptr  @34pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,dword ptr  @34pstComCtl
	push	dword ptr [eax+010h]
	call	GetDCB
	add	esp,0ch
	test	eax,eax
	je	@BLBL47

; 228         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL47:

; 229       if (GetFIFOinfo(pstComCtl->pstIOctl,pstComCtl->hCom,&stFIFOinfo) != NO_ERROR)
	push	offset FLAT:@35stFIFOinfo
	mov	eax,dword ptr  @34pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,dword ptr  @34pstComCtl
	push	dword ptr [eax+010h]
	call	GetFIFOinfo
	add	esp,0ch
	test	eax,eax
	je	@BLBL48

; 230         {
; 231         stFIFOinfo.wFIFOsize = 16;
	mov	word ptr  @35stFIFOinfo,010h

; 232         stFIFOinfo.wTxFIFOload = 16;
	mov	word ptr  @35stFIFOinfo+02h,010h

; 233         stFIFOinfo.wFIFOflags = 0;
	mov	word ptr  @35stFIFOinfo+04h,0h

; 234         }
@BLBL48:

; 235       if (pstComCtl->pszPortName != NULL)
	mov	eax,dword ptr  @34pstComCtl
	cmp	dword ptr [eax+02h],0h
	je	@BLBL49

; 236         WinSetWindowText(hwnd,pstComCtl->pszPortName);
	mov	eax,dword ptr  @34pstComCtl
	push	dword ptr [eax+02h]
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowText
	add	esp,08h
@BLBL49:

; 237       WinPostMsg(hwnd,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	02710h
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 238       break;
	jmp	@BLBL53
	align 04h
@BLBL56:

; 239     case UM_INITLS:
; 240       FillHandshakeDlg(hwnd,&stComDCB,&stFIFOinfo);
	push	offset FLAT:@35stFIFOinfo
	push	offset FLAT:@32stComDCB
	push	dword ptr [ebp+08h];	hwnd
	call	FillHandshakeDlg
	add	esp,0ch

; 241       bAllowClick = TRUE;
	mov	dword ptr  @33bAllowClick,01h

; 242       break;
	jmp	@BLBL53
	align 04h
@BLBL57:

; 243     case WM_CONTROL:
; 244       if (SHORT2FROMMP(mp1) == BN_CLICKED)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL50

; 245         {
; 246         if (bAllowClick)
	cmp	dword ptr  @33bAllowClick,0h
	je	@BLBL50

; 247           if (!TCHandshakeDlg(hwnd,SHORT1FROMMP(mp1),&stComDCB,&stFIFOinfo))
	push	offset FLAT:@35stFIFOinfo
	push	offset FLAT:@32stComDCB
	mov	ax,[ebp+010h];	mp1
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	TCHandshakeDlg
	add	esp,010h
	test	eax,eax
	jne	@BLBL50

; 248             return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL50:

; 249         }
; 250       break;
	jmp	@BLBL53
	align 04h
@BLBL58:

; 251     case WM_COMMAND:
; 252       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL60
	align 04h
@BLBL61:

; 253         {
; 254         case DID_OK:
; 255           UnloadHandshakeDlg(hwnd,&stComDCB,&stFIFOinfo);
	push	offset FLAT:@35stFIFOinfo
	push	offset FLAT:@32stComDCB
	push	dword ptr [ebp+08h];	hwnd
	call	UnloadHandshakeDlg
	add	esp,0ch

; 256           stFIFOcontrol.wFIFOflags = stFIFOinfo.wFIFOflags;
	mov	ax,word ptr  @35stFIFOinfo+04h
	mov	[ebp-06h],ax;	stFIFOcontrol

; 257           stFIFOcontrol.wFIFOflags |= FIFO_FLG_NO_DCB_UPDATE;
	mov	ax,[ebp-06h];	stFIFOcontrol
	or	ax,02000h
	mov	[ebp-06h],ax;	stFIFOcontrol

; 258           stFIFOcontrol.wTxFIFOload = stFIFOinfo.wTxFIFOload;
	mov	ax,word ptr  @35stFIFOinfo+02h
	mov	[ebp-08h],ax;	stFIFOcontrol

; 259           SetFIFO(pstComCtl->pstIOctl,pstComCtl->hCom,&stFIFOcontrol);
	lea	eax,[ebp-08h];	stFIFOcontrol
	push	eax
	mov	eax,dword ptr  @34pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,dword ptr  @34pstComCtl
	push	dword ptr [eax+010h]
	call	SetFIFO
	add	esp,0ch

; 260           SendDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB);
	push	offset FLAT:@32stComDCB
	mov	eax,dword ptr  @34pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,dword ptr  @34pstComCtl
	push	dword ptr [eax+010h]
	call	SendDCB
	add	esp,0ch

; 261           WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 262           break;
	jmp	@BLBL59
	align 04h
@BLBL62:

; 263         case DID_CANCEL:
; 264           WinDismissDlg(hwnd,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 265           break;
	jmp	@BLBL59
	align 04h
@BLBL63:

; 266         case DID_HELP:
; 267           DisplayHelpPanel(pstComCtl);
	push	dword ptr  @34pstComCtl
	call	DisplayHelpPanel
	add	esp,04h

; 268           break;
	jmp	@BLBL59
	align 04h
@BLBL64:

; 269         default:
; 270           return WinDefDlgProc(hwnd,msg,mp1,mp2);
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
	jmp	@BLBL59
	align 04h
@BLBL60:
	cmp	eax,01h
	je	@BLBL61
	cmp	eax,02h
	je	@BLBL62
	cmp	eax,012dh
	je	@BLBL63
	jmp	@BLBL64
	align 04h
@BLBL59:

; 271         }
; 272       break;
	jmp	@BLBL53
	align 04h
@BLBL65:

; 273     default:
; 274       return(WinDefDl
; 274 gProc(hwnd,msg,mp1,mp2));
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
	jmp	@BLBL53
	align 04h
@BLBL54:
	cmp	eax,03bh
	je	@BLBL55
	cmp	eax,02710h
	je	@BLBL56
	cmp	eax,030h
	je	@BLBL57
	cmp	eax,020h
	je	@BLBL58
	jmp	@BLBL65
	align 04h
@BLBL53:

; 275     }
; 276   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpHandshakeDlg	endp

; 283   {
	align 010h

	public fnwpHdwProtocolDlg
fnwpHdwProtocolDlg	proc
	push	ebp
	mov	ebp,esp

; 288   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL71
	align 04h
@BLBL72:

; 289     {
; 290     case WM_INITDLG:
; 291 //      CenterDlgBox(hwnd);
; 292 //      WinSetFocus(HWND_DESKTOP,hwnd);
; 293       bAllowClick = FALSE;
	mov	dword ptr  @48bAllowClick,0h

; 294       pstComCtl = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @47pstComCtl,eax

; 295       if (GetLineCharacteristics(pstComCtl->pstIOctl,pstComCtl->hCom,&stLineChar))
	push	offset FLAT:@46stLineChar
	mov	eax,dword ptr  @47pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,dword ptr  @47pstComCtl
	push	dword ptr [eax+010h]
	call	GetLineCharacteristics
	add	esp,0ch
	test	eax,eax
	je	@BLBL66

; 296         {
; 297         WinDismissDlg(hwnd,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 298         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL66:

; 299         }
; 300       if (pstComCtl->pszPortName != NULL)
	mov	eax,dword ptr  @47pstComCtl
	cmp	dword ptr [eax+02h],0h
	je	@BLBL67

; 301         WinSetWindowText(hwnd,pstComCtl->pszPortName);
	mov	eax,dword ptr  @47pstComCtl
	push	dword ptr [eax+02h]
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowText
	add	esp,08h
@BLBL67:

; 302       WinPostMsg(hwnd,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	02710h
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 303       break;
	jmp	@BLBL70
	align 04h
@BLBL73:

; 304     case UM_INITLS:
; 305       FillHdwProtocolDlg(hwnd,&stLineChar);
	push	offset FLAT:@46stLineChar
	push	dword ptr [ebp+08h];	hwnd
	call	FillHdwProtocolDlg
	add	esp,08h

; 306       bAllowClick = TRUE;
	mov	dword ptr  @48bAllowClick,01h

; 307       break;
	jmp	@BLBL70
	align 04h
@BLBL74:

; 308     case WM_CONTROL:
; 309       switch (SHORT2FROMMP(mp1))
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	and	eax,0ffffh
	jmp	@BLBL76
	align 04h
@BLBL77:

; 310         {
; 311         case BN_CLICKED:
; 312           if (bAllowClick)
	cmp	dword ptr  @48bAllowClick,0h
	je	@BLBL68

; 313             if (!TCHdwProtocolDlg(hwnd,SHORT1FROMMP(mp1)))
	mov	ax,[ebp+010h];	mp1
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	TCHdwProtocolDlg
	add	esp,08h
	test	eax,eax
	jne	@BLBL68

; 314               return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL68:

; 315           break;
	jmp	@BLBL75
	align 04h
@BLBL78:

; 316         default:
; 317           break;
	jmp	@BLBL75
	align 04h
	jmp	@BLBL75
	align 04h
@BLBL76:
	cmp	eax,01h
	je	@BLBL77
	jmp	@BLBL78
	align 04h
@BLBL75:

; 318         }
; 319       break;
	jmp	@BLBL70
	align 04h
@BLBL79:

; 320     case WM_COMMAND:
; 321       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL81
	align 04h
@BLBL82:

; 322         {
; 323         case DID_OK:
; 324           UnloadHdwProtocolDlg(hwnd,&stLineChar);
	push	offset FLAT:@46stLineChar
	push	dword ptr [ebp+08h];	hwnd
	call	UnloadHdwProtocolDlg
	add	esp,08h

; 325           SetLineCharacteristics(pstComCtl->pstIOctl,pstComCtl->hCom,&stLineChar);
	push	offset FLAT:@46stLineChar
	mov	eax,dword ptr  @47pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,dword ptr  @47pstComCtl
	push	dword ptr [eax+010h]
	call	SetLineCharacteristics
	add	esp,0ch

; 326           WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 327           break;
	jmp	@BLBL80
	align 04h
@BLBL83:

; 328         case DID_CANCEL:
; 329           WinDismissDlg(hwnd,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 330           break;
	jmp	@BLBL80
	align 04h
@BLBL84:

; 331         case DID_HELP:
; 332           DisplayHelpPanel(pstComCtl);
	push	dword ptr  @47pstComCtl
	call	DisplayHelpPanel
	add	esp,04h

; 333           return((MRESULT)TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL85:

; 334         default:
; 335           return WinDefDlgProc(hwnd,msg,mp1,mp2);
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
	jmp	@BLBL80
	align 04h
@BLBL81:
	cmp	eax,01h
	je	@BLBL82
	cmp	eax,02h
	je	@BLBL83
	cmp	eax,012dh
	je	@BLBL84
	jmp	@BLBL85
	align 04h
@BLBL80:

; 336         }
; 337       break;
	jmp	@BLBL70
	align 04h
@BLBL86:

; 338     default:
; 339       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
	jmp	@BLBL70
	align 04h
@BLBL71:
	cmp	eax,03bh
	je	@BLBL72
	cmp	eax,02710h
	je	@BLBL73
	cmp	eax,030h
	je	@BLBL74
	cmp	eax,020h
	je	@BLBL79
	jmp	@BLBL86
	align 04h
@BLBL70:

; 340     }
; 341   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpHdwProtocolDlg	endp

; 345   {
	align 010h

	public fnwpHdwBaudRateDlg
fnwpHdwBaudRateDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,034h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,0dh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	push	ebx
	sub	esp,0ch

; 357   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL103
	align 04h
@BLBL104:

; 358     {
; 359     case WM_INITDLG:
; 360 //      CenterDlgBox(hwnd);
; 361 //      WinSetFocus(HWND_DESKTOP,hwnd);
; 362       bAllowClick = FALSE;
	mov	dword ptr  @58bAllowClick,0h

; 363       pstComCtl = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @59pstComCtl,eax

; 364       if (GetBaudRates(pstComCtl->pstIOctl,pstComCtl->hCom,&stBaudRates))
	lea	eax,[ebp-033h];	stBaudRates
	push	eax
	mov	eax,dword ptr  @59pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,dword ptr  @59pstComCtl
	push	dword ptr [eax+010h]
	call	GetBaudRates
	add	esp,0ch
	test	eax,eax
	je	@BLBL87

; 365         {
; 366         WinDismissDlg(hwnd,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 367         return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL87:

; 368         }
; 369       if (pstComCtl->pszPortName != NULL)
	mov	eax,dword ptr  @59pstComCtl
	cmp	dword ptr [eax+02h],0h
	je	@BLBL88

; 370         WinSetWindowText(hwnd,pstComCtl->pszPortName);
	mov	eax,dword ptr  @59pstComCtl
	push	dword ptr [eax+02h]
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowText
	add	esp,08h
@BLBL88:

; 371       lBaud = stBaudRates.stCurrentBaud.lBaudRate;
	mov	eax,[ebp-033h];	stBaudRates
	mov	[ebp-04h],eax;	lBaud

; 372       lMaxBaud = stBaudRates.stHighestBaud.lBaudRate;
	mov	eax,[ebp-029h];	stBaudRates
	mov	[ebp-024h],eax;	lMaxBaud

; 373       if (lMaxBaud > 469800)
	cmp	dword ptr [ebp-024h],072b28h;	lMaxBaud
	jle	@BLBL89

; 374         pulBaudTable = (ULONG *)aul12xBaudTable;
	mov	dword ptr [ebp-020h],offset FLAT:aul12xBaudTable;	pulBaudTable
	jmp	@BLBL90
	align 010h
@BLBL89:

; 375       else
; 376         if (lMaxBaud > 115200)
	cmp	dword ptr [ebp-024h],01c200h;	lMaxBaud
	jle	@BLBL91

; 377           pulBaudTable = (ULONG *)aul4xBaudTable;
	mov	dword ptr [ebp-020h],offset FLAT:aul4xBaudTable;	pulBaudTable
	jmp	@BLBL90
	align 010h
@BLBL91:

; 378         else
; 379           pulBaudTable = (ULONG *)aulStdBaudTable;
	mov	dword ptr [ebp-020h],offset FLAT:aulStdBaudTable;	pulBaudTable
@BLBL90:

; 380       if (lBaud == 0)
	cmp	dword ptr [ebp-04h],0h;	lBaud
	jne	@BLBL93

; 381         lBaud = DEF_BAUD;
	mov	dword ptr [ebp-04h],02580h;	lBaud
@BLBL93:

; 382       WinSendDlgItemMsg(hwnd,HWB_BAUD,EM_SETTEXTLIMIT,MPFROMSHORT(6),(MPARAM)NULL);
	push	0h
	push	06h
	push	0143h
	push	0515h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 383       iCurrentBaudIndex = -1;
	mov	dword ptr [ebp-018h],0ffffffffh;	iCurrentBaudIndex

; 384       iIndex = 0;
	mov	dword ptr [ebp-014h],0h;	iIndex

; 385       while (pulBaudTable[iIndex] != 0)
	mov	eax,[ebp-020h];	pulBaudTable
	mov	ecx,[ebp-014h];	iIndex
	cmp	dword ptr [eax+ecx*04h],0h
	je	@BLBL94
	align 010h
@BLBL95:

; 386         {
; 387         ltoa(pulBaudTable[iIndex],szBaud,10);
	mov	ecx,0ah
	lea	edx,[ebp-010h];	szBaud
	mov	eax,[ebp-020h];	pulBaudTable
	mov	ebx,[ebp-014h];	iIndex
	mov	eax,dword ptr [eax+ebx*04h]
	call	_ltoa

; 388         WinSendDlgItemMsg(hwnd,HWB_BAUD,LM_INSERTITEM,MPFROM2SHORT(LIT_END,0),MPFROMP(szBaud));
	lea	eax,[ebp-010h];	szBaud
	push	eax
	push	0ffffh
	push	0161h
	push	0515h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 389         if (pulBaudTable[iIndex] == lBaud)
	mov	eax,[ebp-020h];	pulBaudTable
	mov	ecx,[ebp-014h];	iIndex
	mov	edx,[ebp-04h];	lBaud
	cmp	dword ptr [eax+ecx*04h],edx
	jne	@BLBL96

; 390           iCurrentBaudIndex = iIndex;
	mov	eax,[ebp-014h];	iIndex
	mov	[ebp-018h],eax;	iCurrentBaudIndex
@BLBL96:

; 391         iIndex++;
	mov	eax,[ebp-014h];	iIndex
	inc	eax
	mov	[ebp-014h],eax;	iIndex

; 392         }

; 385       while (pulBaudTable[iIndex] != 0)
	mov	eax,[ebp-020h];	pulBaudTable
	mov	ebx,[ebp-014h];	iIndex
	cmp	dword ptr [eax+ebx*04h],0h
	jne	@BLBL95
@BLBL94:

; 393       if (iCurrentBaudIndex >= 0)
	cmp	dword ptr [ebp-018h],0h;	iCurrentBaudIndex
	jl	@BLBL98

; 394         WinSendDlgItemMsg(hwnd,HWB_BAUD,LM_SELECTITEM,MPFROMSHORT((SHORT)iCurrentBaudIndex),(MPARAM)TRUE);
	push	01h
	mov	ax,[ebp-018h];	iCurrentBaudIndex
	and	eax,0ffffh
	push	eax
	push	0164h
	push	0515h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h
@BLBL98:

; 395       ltoa(lBaud,szBaud,10);
	mov	ecx,0ah
	lea	edx,[ebp-010h];	szBaud
	mov	eax,[ebp-04h];	lBaud
	call	_ltoa

; 396       WinSetDlgItemText(hwnd,HWB_BAUD,szBaud);
	lea	eax,[ebp-010h];	szBaud
	push	eax
	push	0515h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 397       WinPostMsg(hwnd,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	02710h
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 398       break;
	jmp	@BLBL102
	align 04h
@BLBL105:

; 400       bAllowClick = TRUE;
	mov	dword ptr  @58bAllowClick,01h

; 401       break;
	jmp	@BLBL102
	align 04h
@BLBL106:

; 403       if (SHORT2FROMMP(mp1) == BN_CLICKED)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL99

; 404         if (bAllowClick)
	cmp	dword ptr  @58bAllowClick,0h
	je	@BLBL99

; 405           if (!TCHdwProtocolDlg(hwnd,SHORT1FROMMP(mp1)))
	mov	ax,[ebp+010h];	mp1
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	TCHdwProtocolDlg
	add	esp,08h
	test	eax,eax
	jne	@BLBL99

; 406             return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL99:

; 407       break;
	jmp	@BLBL102
	align 04h
@BLBL107:

; 409       switch( SHORT1FROMMP( mp1 ) )
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL109
	align 04h
@BLBL110:

; 412           WinQueryDlgItemText(hwnd,HWB_BAUD,sizeof(szBaud),szBaud);
	lea	eax,[ebp-010h];	szBaud
	push	eax
	push	0ch
	push	0515h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 413           SetBaudRate(pstComCtl->pstIOctl,pstComCtl->hCom,atol(szBaud));
	lea	eax,[ebp-010h];	szBaud
	call	atol
	push	eax
	mov	eax,dword ptr  @59pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,dword ptr  @59pstComCtl
	push	dword ptr [eax+010h]
	call	SetBaudRate
	add	esp,0ch

; 414           WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 415           break;
	jmp	@BLBL108
	align 04h
@BLBL111:

; 417           WinDismissDlg(hwnd,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 418           break;
	jmp	@BLBL108
	align 04h
@BLBL112:

; 420           DisplayHelpPanel(pstComCtl);
	push	dword ptr  @59pstComCtl
	call	DisplayHelpPanel
	add	esp,04h

; 421           return((MRESULT)TRUE);
	mov	eax,01h
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL113:

; 423           return WinDefDlgProc(hwnd,msg,mp1,mp2);
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefDlgProc
	add	esp,01ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL108
	align 04h
@BLBL109:
	cmp	eax,01h
	je	@BLBL110
	cmp	eax,02h
	je	@BLBL111
	cmp	eax,012dh
	je	@BLBL112
	jmp	@BLBL113
	align 04h
@BLBL108:

; 425       break;
	jmp	@BLBL102
	align 04h
@BLBL114:

; 427       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefDlgProc
	add	esp,01ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL102
	align 04h
@BLBL103:
	cmp	eax,03bh
	je	@BLBL104
	cmp	eax,02710h
	je	@BLBL105
	cmp	eax,030h
	je	@BLBL106
	cmp	eax,020h
	je	@BLBL107
	jmp	@BLBL114
	align 04h
@BLBL102:

; 429   return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
fnwpHdwBaudRateDlg	endp

; 436   {
	align 010h

	public fnwpHdwFIFOsetupDlg
fnwpHdwFIFOsetupDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 443   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL126
	align 04h
@BLBL127:

; 444     {
; 445     case WM_INITDLG:
; 446 //      CenterDlgBox(hwnd);
; 447       bAllowClick = FALSE;
	mov	dword ptr  @74bAllowClick,0h

; 448 //      WinSetFocus(HWND_DESKTOP,hwnd);
; 449       pstComCtl = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @75pstComCtl,eax

; 450       pstFIFOinfo = pstComCtl->pVoidPtrOne;
	mov	eax,dword ptr  @75pstComCtl
	mov	eax,[eax+014h]
	mov	dword ptr  @76pstFIFOinfo,eax

; 451       if (GetDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB))
	push	offset FLAT:@73stComDCB
	mov	eax,dword ptr  @75pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,dword ptr  @75pstComCtl
	push	dword ptr [eax+010h]
	call	GetDCB
	add	esp,0ch
	test	eax,eax
	je	@BLBL115

; 452         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL115:

; 453       if (pstComCtl->pszPortName != NULL)
	mov	eax,dword ptr  @75pstComCtl
	cmp	dword ptr [eax+02h],0h
	je	@BLBL116

; 454         WinSetWindowText(hwnd,pstComCtl->pszPortName);
	mov	eax,dword ptr  @75pstComCtl
	push	dword ptr [eax+02h]
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowText
	add	esp,08h
@BLBL116:

; 455       FillHdwFIFOsetupDlg(hwnd,stComDCB.Flags3,pstFIFOinfo);
	push	dword ptr  @76pstFIFOinfo
	mov	al,byte ptr  @73stComDCB+06h
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	FillHdwFIFOsetupDlg
	add	esp,0ch

; 456       WinPostMsg(hwnd,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	02710h
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 457       break;
	jmp	@BLBL125
	align 04h
@BLBL128:

; 458     case UM_INITLS:
; 459       bAllowClick = TRUE;
	mov	dword ptr  @74bAllowClick,01h

; 460       break;
	jmp	@BLBL125
	align 04h
@BLBL129:

; 461     case WM_CONTROL:
; 462       switch (SHORT2FROMMP(mp1))
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	and	eax,0ffffh
	jmp	@BLBL131
	align 04h
@BLBL132:

; 463         {
; 464         case BN_CLICKED:
; 465           if (bAllowClick)
	cmp	dword ptr  @74bAllowClick,0h
	je	@BLBL117

; 466             if (!TCHdwFIFOsetupDlg(hwnd,SHORT1FROMMP(mp1),pstFIFOinfo))
	push	dword ptr  @76pstFIFOinfo
	mov	ax,[ebp+010h];	mp1
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	TCHdwFIFOsetupDlg
	add	esp,0ch
	test	eax,eax
	jne	@BLBL117

; 467               return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL117:

; 468           break;
	jmp	@BLBL130
	align 04h
@BLBL133:

; 469         default:
; 470           break;
	jmp	@BLBL130
	align 04h
	jmp	@BLBL130
	align 04h
@BLBL131:
	cmp	eax,01h
	je	@BLBL132
	jmp	@BLBL133
	align 04h
@BLBL130:

; 471         }
; 472       break;
	jmp	@BLBL125
	align 04h
@BLBL134:

; 473     case WM_COMMAND:
; 474       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL136
	align 04h
@BLBL137:

; 475         {
; 476         case DID_OK:
; 477           UnloadHdwFIFOsetupDlg(hwnd,&stComDCB,pstFIFOinfo);
	push	dword ptr  @76pstFIFOinfo
	push	offset FLAT:@73stComDCB
	push	dword ptr [ebp+08h];	hwnd
	call	UnloadHdwFIFOsetupDlg
	add	esp,0ch

; 478           stFIFOcontrol.wFIFOflags = pstFIFOinfo->wFIFOflags;
	mov	eax,dword ptr  @76pstFIFOinfo
	mov	ax,[eax+04h]
	mov	[ebp-06h],ax;	stFIFOcontrol

; 479           stFIFOcontrol.wFIFOflags |= FIFO_FLG_NO_DCB_UPDATE;
	mov	ax,[ebp-06h];	stFIFOcontrol
	or	ax,02000h
	mov	[ebp-06h],ax;	stFIFOcontrol

; 480           stFIFOcontrol.wTxFIFOload = pstFIFOinfo->wTxFIFOload;
	mov	eax,dword ptr  @76pstFIFOinfo
	mov	ax,[eax+02h]
	mov	[ebp-08h],ax;	stFIFOcontrol

; 481           SetFIFO(pstComCtl->pstIOctl,pstComCtl->hCom,&stFIFOcontrol);
	lea	eax,[ebp-08h];	stFIFOcontrol
	push	eax
	mov	eax,dword ptr  @75pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,dword ptr  @75pstComCtl
	push	dword ptr [eax+010h]
	call	SetFIFO
	add	esp,0ch

; 482           SendDCB(pstComCtl->pstIOctl,pstComCtl->hCom,&stComDCB);
	push	offset FLAT:@73stComDCB
	mov	eax,dword ptr  @75pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,dword ptr  @75pstComCtl
	push	dword ptr [eax+010h]
	call	SendDCB
	add	esp,0ch

; 483           WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 484           break;
	jmp	@BLBL135
	align 04h
@BLBL138:

; 485         case DID_CANCEL:
; 486           WinDismissDlg(hwnd,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 487           break;
	jmp	@BLBL135
	align 04h
@BLBL139:

; 488         case DID_HELP:
; 489           if (pstFIFOinfo->wFIFOflags & FIFO_FLG_TYPE_16750)
	mov	eax,dword ptr  @76pstFIFOinfo
	test	byte ptr [eax+04h],02h
	je	@BLBL119

; 490             pstComCtl->usHelpId = HLPP_16750_FIFO_DLG;
	mov	eax,dword ptr  @75pstComCtl
	mov	word ptr [eax+0eh],07550h
	jmp	@BLBL120
	align 010h
@BLBL119:

; 491           else
; 492             if (pstFIFOinfo->wFIFOflags & FIFO_FLG_TYPE_16650)
	mov	eax,dword ptr  @76pstFIFOinfo
	test	byte ptr [eax+04h],01h
	je	@BLBL121

; 493               pstComCtl->usHelpId = HLPP_16650_FIFO_DLG;
	mov	eax,dword ptr  @75pstComCtl
	mov	word ptr [eax+0eh],0754fh
	jmp	@BLBL120
	align 010h
@BLBL121:

; 494             else
; 495               if (pstFIFOinfo->wFIFOflags & FIFO_FLG_TYPE_16654)
	mov	eax,dword ptr  @76pstFIFOinfo
	test	byte ptr [eax+04h],04h
	je	@BLBL123

; 496                 pstComCtl->usHelpId = HLPP_16654_FIFO_DLG;
	mov	eax,dword ptr  @75pstComCtl
	mov	word ptr [eax+0eh],07551h
	jmp	@BLBL120
	align 010h
@BLBL123:

; 497               else
; 498                 pstComCtl->usHelpId = HLPP_16550_FIFO_DLG;
	mov	eax,dword ptr  @75pstComCtl
	mov	word ptr [eax+0eh],0754eh
@BLBL120:

; 499           DisplayHelpPanel(pstComCtl);
	push	dword ptr  @75pstComCtl
	call	DisplayHelpPanel
	add	esp,04h

; 500           break;
	jmp	@BLBL135
	align 04h
@BLBL140:

; 501         default:
; 502           return WinDefDlgProc(hwnd,msg,mp1,mp2);
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
	jmp	@BLBL135
	align 04h
@BLBL136:
	cmp	eax,01h
	je	@BLBL137
	cmp	eax,02h
	je	@BLBL138
	cmp	eax,012dh
	je	@BLBL139
	jmp	@BLBL140
	align 04h
@BLBL135:

; 503         }
; 504       break;
	jmp	@BLBL125
	align 04h
@BLBL141:

; 505     default:
; 506       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
	jmp	@BLBL125
	align 04h
@BLBL126:
	cmp	eax,03bh
	je	@BLBL127
	cmp	eax,02710h
	je	@BLBL128
	cmp	eax,030h
	je	@BLBL129
	cmp	eax,020h
	je	@BLBL134
	jmp	@BLBL141
	align 04h
@BLBL125:

; 507     }
; 508   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpHdwFIFOsetupDlg	endp

; 512   {
	align 010h

	public HdwFIFOsetupDialog
HdwFIFOsetupDialog	proc
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

; 516   if (GetFIFOinfo(pstComCtl->pstIOctl,pstComCtl->hCom,&stFIFOinfo) != NO_ERROR)
	lea	eax,[ebp-0eh];	stFIFOinfo
	push	eax
	mov	eax,[ebp+0ch];	pstComCtl
	push	dword ptr [eax+06h]
	mov	eax,[ebp+0ch];	pstComCtl
	push	dword ptr [eax+010h]
	call	GetFIFOinfo
	add	esp,0ch
	test	eax,eax
	je	@BLBL142

; 517     {
; 518     stFIFOinfo.wFIFOsize = 16;
	mov	word ptr [ebp-0eh],010h;	stFIFOinfo

; 519     stFIFOinfo.wTxFIFOload = 16;
	mov	word ptr [ebp-0ch],010h;	stFIFOinfo

; 520     stFIFOinfo.wFIFOflags = 0;
	mov	word ptr [ebp-0ah],0h;	stFIFOinfo

; 521     iDlgID = HWF_16550_DLG;
	mov	dword ptr [ebp-04h],0384h;	iDlgID

; 522     }
	jmp	@BLBL143
	align 010h
@BLBL142:

; 523   else
; 524     if (stFIFOinfo.wFIFOflags & FIFO_FLG_TYPE_16750)
	test	byte ptr [ebp-0ah],02h;	stFIFOinfo
	je	@BLBL144

; 525       iDlgID = HWF_16750_DLG;
	mov	dword ptr [ebp-04h],0320h;	iDlgID
	jmp	@BLBL143
	align 010h
@BLBL144:

; 526     else
; 527       if (stFIFOinfo.wFIFOflags & FIFO_FLG_TYPE_16650)
	test	byte ptr [ebp-0ah],01h;	stFIFOinfo
	je	@BLBL146

; 528         iDlgID = HWF_16650_DLG;
	mov	dword ptr [ebp-04h],02bch;	iDlgID
	jmp	@BLBL143
	align 010h
@BLBL146:

; 529       else
; 530         if (stFIFOinfo.wFIFOflags & FIFO_FLG_TYPE_16654)
	test	byte ptr [ebp-0ah],04h;	stFIFOinfo
	je	@BLBL148

; 531           iDlgID = HWF_16654_DLG;
	mov	dword ptr [ebp-04h],0258h;	iDlgID
	jmp	@BLBL143
	align 010h
@BLBL148:

; 532         else
; 533           iDlgID = HWF_16550_DLG;
	mov	dword ptr [ebp-04h],0384h;	iDlgID
@BLBL143:

; 534 
; 535   pstComCtl->pVoidPtrOne = &stFIFOinfo;
	mov	eax,[ebp+0ch];	pstComCtl
	lea	ecx,[ebp-0eh];	stFIFOinfo
	mov	[eax+014h],ecx

; 536   return(WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpHdwFIFOsetupDlg,hThisModule,iDlgID,MPFROMP(pstComCtl)));
	push	dword ptr [ebp+0ch];	pstComCtl
	mov	eax,[ebp-04h];	iDlgID
	push	eax
	push	dword ptr  hThisModule
	push	offset FLAT: fnwpHdwFIFOsetupDlg
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
HdwFIFOsetupDialog	endp

; 540   {
	align 010h

	public HdwFilterDialog
HdwFilterDialog	proc
	push	ebp
	mov	ebp,esp

; 541   return(WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpHdwFilterDlg,hThisModule,HWR_DLG,MPFROMP(pstComCtl)));
	push	dword ptr [ebp+0ch];	pstComCtl
	push	04b0h
	push	dword ptr  hThisModule
	push	offset FLAT: fnwpHdwFilterDlg
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
HdwFilterDialog	endp

; 545   {
	align 010h

	public HdwHandshakeDialog
HdwHandshakeDialog	proc
	push	ebp
	mov	ebp,esp

; 546   return(WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpHandshakeDlg,hThisModule,HS_ALL_DLG,MPFROMP(pstComCtl)));
	push	dword ptr [ebp+0ch];	pstComCtl
	push	01b7h
	push	dword ptr  hThisModule
	push	offset FLAT: fnwpHandshakeDlg
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
HdwHandshakeDialog	endp

; 550   {
	align 010h

	public HdwTimeoutDialog
HdwTimeoutDialog	proc
	push	ebp
	mov	ebp,esp

; 551   return(WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpHdwTimeoutDlg,hThisModule,HWT_DLG,MPFROMP(pstComCtl)));
	push	dword ptr [ebp+0ch];	pstComCtl
	push	03e8h
	push	dword ptr  hThisModule
	push	offset FLAT: fnwpHdwTimeoutDlg
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
HdwTimeoutDialog	endp

; 555   {
	align 010h

	public HdwProtocolDialog
HdwProtocolDialog	proc
	push	ebp
	mov	ebp,esp

; 556   return(WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpHdwProtocolDlg,hThisModule,HWP_DLG,MPFROMP(pstComCtl)));
	push	dword ptr [ebp+0ch];	pstComCtl
	push	0190h
	push	dword ptr  hThisModule
	push	offset FLAT: fnwpHdwProtocolDlg
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
HdwProtocolDialog	endp

; 560   {
	align 010h

	public HdwBaudRateDialog
HdwBaudRateDialog	proc
	push	ebp
	mov	ebp,esp

; 561   return (WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpHdwBaudRateDlg,hThisModule,HWB_DLG,MPFROMP(pstComCtl)));
	push	dword ptr [ebp+0ch];	pstComCtl
	push	0514h
	push	dword ptr  hThisModule
	push	offset FLAT: fnwpHdwBaudRateDlg
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
HdwBaudRateDialog	endp
CODE32	ends
end
