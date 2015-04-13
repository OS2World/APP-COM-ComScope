	title	p:\COMscope\win_util.c
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
	public	bDDstatusActivated
	public	bMIstatusActivated
	public	bMOstatusActivated
	public	bRBstatusActivated
	public	bTBstatusActivated
	extrn	WinSendMsg:proc
	extrn	WinQueryPointerPos:proc
	extrn	WinQueryWindowPos:proc
	extrn	WinSetWindowPos:proc
	extrn	memcpy:proc
	extrn	_fullDump:dword
	extrn	lcyTitleBar:dword
	extrn	stCFG:byte
	extrn	bMinimized:dword
	extrn	bMaximized:dword
	extrn	swpLastPosition:byte
	extrn	hwndFrame:dword
	extrn	hwndStatDev:dword
	extrn	hwndStatModemIn:dword
	extrn	hwndStatModemOut:dword
	extrn	hwndStatRcvBuf:dword
	extrn	hwndStatXmitBuf:dword
BSS32	segment
bDDstatusActivated	dd 0h
bMIstatusActivated	dd 0h
bMOstatusActivated	dd 0h
bRBstatusActivated	dd 0h
bTBstatusActivated	dd 0h
BSS32	ends
CODE32	segment

; 26   {
	align 010h

	public PopupMenuItemCheck
PopupMenuItemCheck	proc
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

; 27   WinSendMsg(hwnd,
	mov	dword ptr [ebp-08h],02000h;	@CBE1
	xor	eax,eax
	mov	ax,[ebp+0ch];	idItem
	or	eax,010000h
	mov	[ebp-0ch],eax;	@CBE2
	mov	dword ptr [ebp-010h],0192h;	@CBE3
	mov	eax,[ebp+08h];	hwnd
	mov	[ebp-014h],eax;	@CBE4
	cmp	dword ptr [ebp+010h],0h;	bCheck
	je	@BLBL1

; 28              MM_SETITEMATTR,
; 29              MPFROM2SHORT(idItem,TRUE),
; 30              MPFROM2SHORT(MIA_CHECKED, bCheck ? MIA_CHECKED : ~MIA_CHECKED));
	mov	dword ptr [ebp-04h],02000h;	T000000000
	jmp	@BLBL2
	align 010h
@BLBL1:
	mov	dword ptr [ebp-04h],0ffffdfffh;	T000000000
@BLBL2:
	mov	ax,[ebp-04h];	T000000000
	and	eax,0ffffh
	sal	eax,010h
	or	eax,[ebp-08h];	@CBE1
	push	eax
	push	dword ptr [ebp-0ch];	@CBE2
	push	dword ptr [ebp-010h];	@CBE3
	push	dword ptr [ebp-014h];	@CBE4
	call	WinSendMsg
	add	esp,010h

; 31   }
	mov	esp,ebp
	pop	ebp
	ret	
PopupMenuItemCheck	endp

; 34   {
	align 010h

	public MousePosDlgBox
MousePosDlgBox	proc
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

; 38   WinQueryPointerPos(HWND_DESKTOP,&ptlMouse);
	lea	eax,[ebp-08h];	ptlMouse
	push	eax
	push	01h
	call	WinQueryPointerPos
	add	esp,08h

; 39   WinQueryWindowPos(hwnd,&swp);
	lea	eax,[ebp-02ch];	swp
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryWindowPos
	add	esp,08h

; 40 
; 41   // adjust position to bo over title bar
; 42   ptlMouse.x -= (swp.cx / 2);
	mov	eax,[ebp-024h];	swp
	cdq	
	mov	ecx,eax
	and	edx,01h
	add	ecx,edx
	sar	ecx,01h
	mov	eax,[ebp-08h];	ptlMouse
	sub	eax,ecx
	mov	[ebp-08h],eax;	ptlMouse

; 43   ptlMouse.y -= (swp.cy - (lcyTitleBar / 2));
	mov	eax,dword ptr  lcyTitleBar
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	add	eax,[ebp-04h];	ptlMouse
	sub	eax,[ebp-028h];	swp
	mov	[ebp-04h],eax;	ptlMouse

; 44   WinSetWindowPos(hwnd,0L,ptlMouse.x,ptlMouse.y,0L,0L,SWP_MOVE);
	push	02h
	push	0h
	push	0h
	push	dword ptr [ebp-04h];	ptlMouse
	push	dword ptr [ebp-08h];	ptlMouse
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowPos
	add	esp,01ch

; 45   }
	mov	esp,ebp
	pop	ebp
	ret	
MousePosDlgBox	endp

; 48   {
	align 010h

	public SaveWindowPositions
SaveWindowPositions	proc
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

; 51   if (stCFG.bLoadWindowPosition)
	test	byte ptr  stCFG+017h,040h
	je	@BLBL3

; 52     {
; 53     if (bMinimized || bMaximized)
	cmp	dword ptr  bMinimized,0h
	jne	@BLBL4
	cmp	dword ptr  bMaximized,0h
	je	@BLBL5
@BLBL4:

; 54       memcpy(&swp,&swpLastPosition,sizeof(SWP));
	mov	ecx,024h
	mov	edx,offset FLAT:swpLastPosition
	lea	eax,[ebp-024h];	swp
	call	memcpy
	jmp	@BLBL6
	align 010h
@BLBL5:

; 55     else
; 56       WinQueryWindowPos(hwndFrame,&swp);
	lea	eax,[ebp-024h];	swp
	push	eax
	push	dword ptr  hwndFrame
	call	WinQueryWindowPos
	add	esp,08h
@BLBL6:

; 57     stCFG.ptlFramePos.x = swp.x;
	mov	eax,[ebp-014h];	swp
	mov	dword ptr  stCFG+03dh,eax

; 58     stCFG.ptlFramePos.y = swp.y;
	mov	eax,[ebp-018h];	swp
	mov	dword ptr  stCFG+041h,eax

; 59     stCFG.ptlFrameSize.x = swp.cx;
	mov	eax,[ebp-01ch];	swp
	mov	dword ptr  stCFG+035h,eax

; 60     stCFG.ptlFrameSize.y = swp.cy;
	mov	eax,[ebp-020h];	swp
	mov	dword ptr  stCFG+039h,eax

; 61     if (bDDstatusActivated)
	cmp	dword ptr  bDDstatusActivated,0h
	je	@BLBL7

; 62       {
; 63       stCFG.bDDstatusActivated = TRUE;
	or	byte ptr  stCFG+017h,01h

; 64       WinQueryWindowPos(hwndStatDev,&swp);
	lea	eax,[ebp-024h];	swp
	push	eax
	push	dword ptr  hwndStatDev
	call	WinQueryWindowPos
	add	esp,08h

; 65       stCFG.ptlDDstatusPos.x = swp.x;
	mov	eax,[ebp-014h];	swp
	mov	dword ptr  stCFG+045h,eax

; 66       stCFG.ptlDDstatusPos.y = swp.y;
	mov	eax,[ebp-018h];	swp
	mov	dword ptr  stCFG+049h,eax

; 67       }
	jmp	@BLBL8
	align 010h
@BLBL7:

; 68     else
; 69       stCFG.bDDstatusActivated = FALSE;
	and	byte ptr  stCFG+017h,0feh
@BLBL8:

; 70     if (bMIstatusActivated)
	cmp	dword ptr  bMIstatusActivated,0h
	je	@BLBL9

; 71       {
; 72       stCFG.bMIstatusActivated = TRUE;
	or	byte ptr  stCFG+017h,02h

; 73       WinQueryWindowPos(hwndStatModemIn,&swp);
	lea	eax,[ebp-024h];	swp
	push	eax
	push	dword ptr  hwndStatModemIn
	call	WinQueryWindowPos
	add	esp,08h

; 74       stCFG.ptlMIstatusPos.x = swp.x;
	mov	eax,[ebp-014h];	swp
	mov	dword ptr  stCFG+04dh,eax

; 75       stCFG.ptlMIstatusPos.y = swp.y;
	mov	eax,[ebp-018h];	swp
	mov	dword ptr  stCFG+051h,eax

; 76       }
	jmp	@BLBL10
	align 010h
@BLBL9:

; 77     else
; 78       stCFG.bMIstatusActivated = FALSE;
	and	byte ptr  stCFG+017h,0fdh
@BLBL10:

; 79     if (bMOstatusActivated)
	cmp	dword ptr  bMOstatusActivated,0h
	je	@BLBL11

; 80       {
; 81       stCFG.bMOstatusActivated = TRUE;
	or	byte ptr  stCFG+017h,04h

; 82       WinQueryWindowPos(hwndStatModemOut,&swp);
	lea	eax,[ebp-024h];	swp
	push	eax
	push	dword ptr  hwndStatModemOut
	call	WinQueryWindowPos
	add	esp,08h

; 83       stCFG.ptlMOstatusPos.x = swp.x;
	mov	eax,[ebp-014h];	swp
	mov	dword ptr  stCFG+055h,eax

; 84       stCFG.ptlMOstatusPos.y = swp.y;
	mov	eax,[ebp-018h];	swp
	mov	dword ptr  stCFG+059h,eax

; 85       }
	jmp	@BLBL12
	align 010h
@BLBL11:

; 86     else
; 87       stCFG.bMOstatusActivated = FALSE;
	and	byte ptr  stCFG+017h,0fbh
@BLBL12:

; 88     if (bRBstatusActivated)
	cmp	dword ptr  bRBstatusActivated,0h
	je	@BLBL13

; 89       {
; 90       stCFG.bRBstatusActivated = TRUE;
	or	byte ptr  stCFG+017h,08h

; 91       WinQueryWindowPos(hwndStatRcvBuf,&swp);
	lea	eax,[ebp-024h];	swp
	push	eax
	push	dword ptr  hwndStatRcvBuf
	call	WinQueryWindowPos
	add	esp,08h

; 92       stCFG.ptlRBstatusPos.x = swp.x;
	mov	eax,[ebp-014h];	swp
	mov	dword ptr  stCFG+05dh,eax

; 93       stCFG.ptlRBstatusPos.y = swp.y;
	mov	eax,[ebp-018h];	swp
	mov	dword ptr  stCFG+061h,eax

; 94       }
	jmp	@BLBL14
	align 010h
@BLBL13:

; 95     else
; 96       stCFG.bRBstatusActivated = FALSE;
	and	byte ptr  stCFG+017h,0f7h
@BLBL14:

; 97     if (bTBstatusActivated)
	cmp	dword ptr  bTBstatusActivated,0h
	je	@BLBL15

; 98       {
; 99       stCFG.bTBstatusActivated = TRUE;
	or	byte ptr  stCFG+017h,010h

; 100       WinQueryWindowPos(hwndStatXmitBuf,&swp);
	lea	eax,[ebp-024h];	swp
	push	eax
	push	dword ptr  hwndStatXmitBuf
	call	WinQueryWindowPos
	add	esp,08h

; 101       stCFG.ptlTBstatusPos.x = swp.x;
	mov	eax,[ebp-014h];	swp
	mov	dword ptr  stCFG+065h,eax

; 102       stCFG.ptlTBstatusPos.y = swp.y;
	mov	eax,[ebp-018h];	swp
	mov	dword ptr  stCFG+069h,eax

; 103       }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL15:

; 104     else
; 105       stCFG.bTBstatusActivated = FALSE;
	and	byte ptr  stCFG+017h,0efh

; 106     }
@BLBL3:

; 107   }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
SaveWindowPositions	endp
CODE32	ends
end
