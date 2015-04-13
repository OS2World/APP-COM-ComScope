	title	p:\COMscope\column.c
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
	public	lColumnOffset
	extrn	ProcessKeystroke:proc
	extrn	WinDefWindowProc:proc
	extrn	WinOpenWindowDC:proc
	extrn	WinSendMsg:proc
	extrn	WinSetFocus:proc
	extrn	WinQueryHelpInstance:proc
	extrn	ColScroll:proc
	extrn	WinInvalidateRect:proc
	extrn	GetColScrollRow:proc
	extrn	GetRowScrollRow:proc
	extrn	_sprintfieee:proc
	extrn	fnwpSetColorDlg:proc
	extrn	WinDlgBox:proc
	extrn	fnwpDisplaySetupDlgProc:proc
	extrn	ClearColScrollBar:proc
	extrn	SetupColScrolling:proc
	extrn	WinLoadMenu:proc
	extrn	WinQueryPointerPos:proc
	extrn	WinQueryWindowPos:proc
	extrn	PopupMenuItemCheck:proc
	extrn	WinPopupMenu:proc
	extrn	WinCopyRect:proc
	extrn	GpiDestroyPS:proc
	extrn	WinShowWindow:proc
	extrn	WinSetWindowPos:proc
	extrn	WinPostMsg:proc
	extrn	WinQueryWindowRect:proc
	extrn	WinTrackRect:proc
	extrn	DosRequestMutexSem:proc
	extrn	WinBeginPaint:proc
	extrn	WinIsWindowShowing:proc
	extrn	WinFillRect:proc
	extrn	GpiCreateLogFont:proc
	extrn	GpiSetCharSet:proc
	extrn	GpiSetColor:proc
	extrn	GpiCharStringAt:proc
	extrn	WinEndPaint:proc
	extrn	DosReleaseMutexSem:proc
	extrn	ErrorNotify:proc
	extrn	WinCreateStdWindow:proc
	extrn	_fullDump:dword
	extrn	bSendNextKeystroke:dword
	extrn	stCFG:byte
	extrn	bFrameActivated:dword
	extrn	hwndFrame:dword
	extrn	hwndClient:dword
	extrn	wASCIIfont:word
	extrn	wHEXfont:word
	extrn	bStopDisplayThread:dword
	extrn	stRow:byte
	extrn	stCell:dword
	extrn	habAnchorBlock:dword
	extrn	hwndStatus:dword
	extrn	hmtxColGioBlockedSem:dword
	extrn	astFontAttributes:byte
	extrn	lScrollCount:dword
	extrn	pwScrollBuffer:dword
	extrn	lStatusHeight:dword
	extrn	_ctype:dword
DATA32	segment
@STAT1	db "Lexical Receive Data Dis"
db "play Colors",0h
@STAT2	db "~Reset Display",0h
	align 04h
@STAT3	db "Lexical Transmit Data Di"
db "splay Colors",0h
	align 04h
@STAT4	db "~Reset Display",0h
	align 04h
@STAT5	db "HEXFONTS",0h
	align 04h
@STAT6	db "HEXFONTS",0h
	align 04h
@STAT7	db "DosRequestMutexSem error"
db " in ColumnSize: return c"
db "ode = %ld",0h
	align 04h
@STAT8	db "DosReleaseMutexSem error"
db " in ColumnSize: return c"
db "ode = %ld",0h
	align 04h
@STAT9	db "WRITE COLUMN",0h
	align 04h
@STATa	db "READ COLUMN",0h
DATA32	ends
BSS32	segment
lColumnOffset	dd 0h
comm	stColTrack:byte:04ch
comm	stRead:byte:07fh
comm	stWrite:byte:07fh
@bhdcPs	dd 0h
@11usMenuStyle	dw 0h
@12stColor	db 05ah DUP (0h)
@13usLastPopupItem	dw 0h
	align 04h
@76hdcPs	dd 0h
@7cstColor	db 05ah DUP (0h)
@7dusLastPopupItem	dw 0h
@7eusMenuStyle	dw 0h
BSS32	ends
CODE32	segment

; 57   {
	align 010h

	public fnwpReadColumnClient
fnwpReadColumnClient	proc
	push	ebp
	mov	ebp,esp
	sub	esp,044h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,011h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 68   switch(msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL49
	align 04h
@BLBL50:

; 69     {
; 70     case WM_CHAR:
; 71       if (bSendNextKeystroke)
	cmp	dword ptr  bSendNextKeystroke,0h
	je	@BLBL1

; 72         if (ProcessKeystroke(&stCFG,mp1,mp2))
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	push	offset FLAT:stCFG
	call	ProcessKeystroke
	add	esp,0ch
	test	eax,eax
	je	@BLBL1

; 73           return((MRESULT)TRUE);
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL1:

; 74       return( WinDefWindowProc(hwnd,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefWindowProc
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL51:

; 75     case WM_CREATE:
; 76       hdcPs = WinOpenWindowDC(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	WinOpenWindowDC
	add	esp,04h
	mov	dword ptr  @bhdcPs,eax

; 77       usLastPopupItem = IDMPU_SYNC;
	mov	word ptr  @13usLastPopupItem,0fa6h

; 78       stRead.lBackgrndColor = stCFG.lReadColBackgrndColor;
	mov	eax,dword ptr  stCFG+0bdh
	mov	dword ptr  stRead+037h,eax

; 79       stRead.bActive = FALSE;
	and	byte ptr  stRead+02h,0feh

; 80       stRead.lScrollIndex = 0;
	mov	dword ptr  stRead+06fh,0h

; 81       stRead.hwndScroll = (HWND)NULL;
	mov	dword ptr  stRead+05fh,0h

; 82       stRead.wDirection = CS_READ;
	mov	word ptr  stRead+05h,04000h

; 83       stColor.cbSize = sizeof(CLRDLG);
	mov	word ptr  @12stColor,05ah

; 84       usMenuStyle = (PU_POSITIONONITEM | PU_MOUSEBUTTON2 | PU_HCONSTRAIN | PU_VCONSTRAIN | PU_KEYBOARD | PU_MOUSEBUTTON1);
	mov	word ptr  @11usMenuStyle,02c7h

; 85       WinSendMsg(hwnd,UM_TRACKFRAME,0L,0L);
	push	0h
	push	0h
	push	08012h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendMsg
	add	esp,010h

; 86       break;
	jmp	@BLBL48
	align 04h
@BLBL52:

; 87     case WM_ACTIVATE:
; 88       if(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	test	ax,ax
	je	@BLBL3

; 89         {
; 90         if (!bFrameActivated)
	cmp	dword ptr  bFrameActivated,0h
	jne	@BLBL5

; 91           {
; 92           WinSetFocus(HWND_DESKTOP,hwndFrame);
	push	dword ptr  hwndFrame
	push	01h
	call	WinSetFocus
	add	esp,08h

; 93           WinSendMsg(WinQueryHelpInstance(hwndClient),HM_SET_ACTIVE_WINDOW,0L,0L);
	push	dword ptr  hwndClient
	call	WinQueryHelpInstance
	add	esp,04h
	push	0h
	push	0h
	push	0224h
	push	eax
	call	WinSendMsg
	add	esp,010h

; 94           bFrameActivated = TRUE;
	mov	dword ptr  bFrameActivated,01h

; 95           }

; 96         }
	jmp	@BLBL5
	align 010h
@BLBL3:

; 97       else
; 98         bFrameActivated = FALSE;
	mov	dword ptr  bFrameActivated,0h
@BLBL5:

; 99       break;
	jmp	@BLBL48
	align 04h
@BLBL53:

; 100     case WM_VSCROLL:
; 101       switch(HIUSHORT(mp2))
	mov	eax,[ebp+014h];	mp2
	shr	eax,010h
	and	eax,0ffffh
	and	eax,0ffffh
	jmp	@BLBL55
	align 04h
@BLBL56:

; 102         {
; 103         case SB_LINEDOWN:
; 104           ColScroll(&stRead,1,FALSE);
	push	0h
	push	01h
	push	offset FLAT:stRead
	call	ColScroll
	add	esp,0ch

; 105           break;
	jmp	@BLBL54
	align 04h
@BLBL57:

; 106         case SB_LINEUP:
; 107           ColScroll(&stRead,-1,FALSE);
	push	0h
	push	0ffffffffh
	push	offset FLAT:stRead
	call	ColScroll
	add	esp,0ch

; 108           break;
	jmp	@BLBL54
	align 04h
@BLBL58:

; 109         case SB_PAGEDOWN:
; 110           ColScroll(&stRead,stRead.lCharHeight,FALSE);
	push	0h
	mov	ax,word ptr  stRead+02bh
	push	eax
	push	offset FLAT:stRead
	call	ColScroll
	add	esp,0ch

; 111           break;
	jmp	@BLBL54
	align 04h
@BLBL59:

; 112         case SB_PAGEUP:
; 113           ColScroll(&stRead,-stRead.lCharHeight,FALSE);
	push	0h
	mov	eax,dword ptr  stRead+02bh
	neg	eax
	push	eax
	push	offset FLAT:stRead
	call	ColScroll
	add	esp,0ch

; 114           break;
	jmp	@BLBL54
	align 04h
@BLBL60:

; 115         case SB_SLIDERPOSITION:
; 116           ColScroll(&stRead,LOUSHORT(mp2),TRUE);
	push	01h
	mov	ax,[ebp+014h];	mp2
	push	eax
	push	offset FLAT:stRead
	call	ColScroll
	add	esp,0ch

; 117           break;
	jmp	@BLBL54
	align 04h
	jmp	@BLBL54
	align 04h
@BLBL55:
	cmp	eax,02h
	je	@BLBL56
	cmp	eax,01h
	je	@BLBL57
	cmp	eax,04h
	je	@BLBL58
	cmp	eax,03h
	je	@BLBL59
	cmp	eax,06h
	je	@BLBL60
@BLBL54:

; 118         }
; 119       break;
	jmp	@BLBL48
	align 04h
@BLBL61:

; 120     case WM_COMMAND:
; 121       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL63
	align 04h
@BLBL64:

; 122         {
; 123         case IDMPU_ASCII_FONT:
; 124           if (!stCFG.bStickyMenus)
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL6

; 125             usLastPopupItem = IDMPU_FONT;
	mov	word ptr  @13usLastPopupItem,0fa7h
	jmp	@BLBL7
	align 010h
@BLBL6:

; 126           else
; 127             usLastPopupItem = IDMPU_SYNC;
	mov	word ptr  @13usLastPopupItem,0fa6h
@BLBL7:

; 128           if (stCFG.wColReadFont != wASCIIfont)
	mov	ax,word ptr  wASCIIfont
	cmp	word ptr  stCFG+0dbh,ax
	je	@BLBL8

; 129             {
; 130             stCFG.wColReadFont = wASCIIfont;
	mov	ax,word ptr  wASCIIfont
	mov	word ptr  stCFG+0dbh,ax

; 131             WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stRead+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 132             }
@BLBL8:

; 133           break;
	jmp	@BLBL62
	align 04h
@BLBL65:

; 134         case IDMPU_HEX_FONT:
; 135           if (!stCFG.bStickyMenus)
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL9

; 136             usLastPopupItem = IDMPU_FONT;
	mov	word ptr  @13usLastPopupItem,0fa7h
	jmp	@BLBL10
	align 010h
@BLBL9:

; 137           else
; 138             usLastPopupItem = IDMPU_SYNC;
	mov	word ptr  @13usLastPopupItem,0fa6h
@BLBL10:

; 139           if (stCFG.wColReadFont != wHEXfont)
	mov	ax,word ptr  wHEXfont
	cmp	word ptr  stCFG+0dbh,ax
	je	@BLBL11

; 140             {
; 141             stCFG.wColReadFont = wHEXfont;
	mov	ax,word ptr  wHEXfont
	mov	word ptr  stCFG+0dbh,ax

; 142             WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stRead+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 143             }
@BLBL11:

; 144           break;
	jmp	@BLBL62
	align 04h
@BLBL66:

; 145         case IDMPU_SYNC:
; 146           usLastPopupItem = IDMPU_SYNC;
	mov	word ptr  @13usLastPopupItem,0fa6h

; 147           if (bStopDisplayThread)
	cmp	dword ptr  bStopDisplayThread,0h
	je	@BLBL12

; 148             stRead.lScrollIndex = stWrite.lScrollIndex;
	mov	eax,dword ptr  stWrite+06fh
	mov	dword ptr  stRead+06fh,eax
	jmp	@BLBL13
	align 010h
@BLBL12:

; 149           else
; 150             stRead.lScrollIndex = 0;
	mov	dword ptr  stRead+06fh,0h
@BLBL13:

; 151           stRead.lScrollRow = GetColScrollRow(&stRead,0);
	push	0h
	push	offset FLAT:stRead
	call	GetColScrollRow
	add	esp,08h
	mov	dword ptr  stRead+06bh,eax

; 152           WinSendMsg(stRead.hwndScroll,
	push	0h
	mov	ax,word ptr  stRead+06bh
	and	eax,0ffffh
	push	eax
	push	01a1h
	push	dword ptr  stRead+05fh
	call	WinSendMsg
	add	esp,010h

; 153                      SBM_SETPOS,
; 154                      MPFROMSHORT(stRead.lScrollRow),
; 155                      MPFROMSHORT(0));
; 156           if (stRead.bSync)
	test	byte ptr  stRead+02h,010h
	je	@BLBL14

; 157             {
; 158             stRow.lScrollIndex = stRead.lScrollIndex;
	mov	eax,dword ptr  stRead+06fh
	mov	dword ptr  stRow+06fh,eax

; 159             stRow.lScrollRow = GetRowScrollRow(&stRow);
	push	offset FLAT:stRow
	call	GetRowScrollRow
	add	esp,04h
	mov	dword ptr  stRow+06bh,eax

; 160             }
@BLBL14:

; 161           WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stRead+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 162           break;
	jmp	@BLBL62
	align 04h
@BLBL67:

; 163          case IDMPU_COLORS:
; 164           if (!stCFG.bStickyMenus)
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL15

; 165             usLastPopupItem = IDMPU_COLORS;
	mov	word ptr  @13usLastPopupItem,0fa4h
	jmp	@BLBL16
	align 010h
@BLBL15:

; 166           else
; 167             usLastPopupItem = IDMPU_SYNC;
	mov	word ptr  @13usLastPopupItem,0fa6h
@BLBL16:

; 168           stColor.lForeground = stCFG.lReadColForegrndColor;
	mov	eax,dword ptr  stCFG+0c1h
	mov	dword ptr  @12stColor+06h,eax

; 169           stColor.lBackground = stCFG.lReadColBackgrndColor;
	mov	eax,dword ptr  stCFG+0bdh
	mov	dword ptr  @12stColor+02h,eax

; 170           sprintf(stColor.szCaption,"Lexical Receive Data Display Colors");
	mov	edx,offset FLAT:@STAT1
	mov	eax,offset FLAT:@12stColor+0ah
	call	_sprintfieee

; 171           if (WinDlgBox(HWND_DESKTOP,
	push	offset FLAT:@12stColor
	push	014b4h
	push	0h
	push	offset FLAT: fnwpSetColorDlg
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL17

; 172                         hwnd,
; 173                  (PFNWP)fnwpSetColorDlg,
; 174                 (USHORT)NULL,
; 175                         CLR_DLG,
; 176                 MPFROMP(&stColor)))
; 177             {
; 178             stCFG.lReadColForegrndColor = stColor.lForeground;
	mov	eax,dword ptr  @12stColor+06h
	mov	dword ptr  stCFG+0c1h,eax

; 179             stCFG.lReadColBackgrndColor = stColor.lBackground;
	mov	eax,dword ptr  @12stColor+02h
	mov	dword ptr  stCFG+0bdh,eax

; 180             stRead.lBackgrndColor = stColor.lBackground;
	mov	eax,dword ptr  @12stColor+02h
	mov	dword ptr  stRead+037h,eax

; 181             stRead.lForegrndColor = stColor.lForeground;
	mov	eax,dword ptr  @12stColor+06h
	mov	dword ptr  stRead+03bh,eax

; 182             WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stRead+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 183             }
@BLBL17:

; 184           break;
	jmp	@BLBL62
	align 04h
@BLBL68:

; 185         case IDMPU_LOCK_WIDTH:
; 186           if (!stCFG.bStickyMenus)
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL18

; 187             usLastPopupItem = IDMPU_LOCK_WIDTH;
	mov	word ptr  @13usLastPopupItem,0fabh
	jmp	@BLBL19
	align 010h
@BLBL18:

; 188           else
; 189             usLastPopupItem = IDMPU_SYNC;
	mov	word ptr  @13usLastPopupItem,0fa6h
@BLBL19:

; 190           if (stCFG.fLockWidth == LOCK_READ)
	mov	al,byte ptr  stCFG+01bh
	and	eax,03h
	cmp	eax,01h
	jne	@BLBL20

; 191             stCFG.fLockWidth = LOCK_NONE;
	and	byte ptr  stCFG+01bh,0fch
	jmp	@BLBL21
	align 010h
@BLBL20:

; 192           else
; 193             {
; 194             stCFG.lLockWidth = ((stRead.lWidth / stCell.cx) + 1);
	movsx	ecx,word ptr  stCell
	mov	eax,dword ptr  stRead+033h
	cdq	
	idiv	ecx
	inc	eax
	mov	dword ptr  stCFG+031h,eax

; 195             stCFG.fLockWidth = LOCK_READ;
	mov	al,byte ptr  stCFG+01bh
	and	al,0fch
	or	al,01h
	mov	byte ptr  stCFG+01bh,al

; 196             }
@BLBL21:

; 197           break;
	jmp	@BLBL62
	align 04h
@BLBL69:

; 198         case IDMPU_DISP_FILTERS:
; 199           if (!stCFG.bStickyMenus)
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL22

; 200             usLastPopupItem = IDMPU_DISP_FILTERS;
	mov	word ptr  @13usLastPopupItem,0faah
	jmp	@BLBL23
	align 010h
@BLBL22:

; 201           else
; 202             usLastPopupItem = IDMPU_SYNC;
	mov	word ptr  @13usLastPopupItem,0fa6h
@BLBL23:

; 203           if (WinDlgBox(HWND_DESKTOP,
	push	offset FLAT:stRead
	push	01770h
	push	0h
	push	offset FLAT: fnwpDisplaySetupDlgProc
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL24

; 204                         hwnd,
; 205                  (PFNWP)fnwpDisplaySetupDlgProc,
; 206                 (USHORT)NULL,
; 207                         DISP_FILTER_DLG,
; 208                 MPFROMP(&stRead)))
; 209             {
; 210             stCFG.bReadTestNewLine = stRead.bTestNewLine;
	mov	cl,byte ptr  stRead+02h
	and	ecx,03h
	shr	ecx,01h
	mov	al,byte ptr  stCFG+019h
	and	al,0fbh
	sal	ecx,02h
	and	cl,07h
	or	al,cl
	mov	byte ptr  stCFG+019h,al

; 211             stCFG.bSkipReadBlankLines = stRead.bSkipBlankLines;
	mov	cl,byte ptr  stRead+02h
	and	ecx,07h
	shr	ecx,02h
	mov	al,byte ptr  stCFG+018h
	and	al,0dfh
	sal	ecx,05h
	and	cl,03fh
	or	al,cl
	mov	byte ptr  stCFG+018h,al

; 212             stCFG.byReadNewLineChar = stRead.byNewLineChar;
	mov	al,byte ptr  stRead+03h
	mov	byte ptr  stCFG+0cdh,al

; 213             stCFG.bFilterRead = stRead.bFilter;
	mov	cl,byte ptr  stRead+02h
	and	ecx,03fh
	shr	ecx,05h
	mov	al,byte ptr  stCFG+019h
	and	al,0efh
	sal	ecx,04h
	and	cl,01fh
	or	al,cl
	mov	byte ptr  stCFG+019h,al

; 214             stCFG.fFilterReadMask = stRead.fFilterMask;
	mov	ecx,dword ptr  stRead+07h
	mov	al,byte ptr  stCFG+01ah
	and	al,0f0h
	and	cl,0fh
	or	al,cl
	mov	byte ptr  stCFG+01ah,al

; 215             stCFG.byReadMask = stRead.byDisplayMask;
	mov	al,byte ptr  stRead+04h
	mov	byte ptr  stCFG+02fh,al

; 216             if (stRead.bSync)
	test	byte ptr  stRead+02h,010h
	je	@BLBL25

; 217               {
; 218               if (!stCFG.bSyncToRead)
	test	byte ptr  stCFG+019h,02h
	jne	@BLBL28

; 219                 {
; 220                 stWrite.bSync = FALSE;
	and	byte ptr  stWrite+02h,0efh

; 221                 stCFG.bSyncToWrite = FALSE;
	and	byte ptr  stCFG+019h,0feh

; 222                 stCFG.bSyncToRead = TRUE;
	or	byte ptr  stCFG+019h,02h

; 223                 if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
	mov	al,byte ptr  stCFG+01bh
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL28

; 224                   {
; 225                   ClearColScrollBar(&stWrite);
	push	offset FLAT:stWrite
	call	ClearColScrollBar
	add	esp,04h

; 226                   SetupColScrolling(&stRead);
	push	offset FLAT:stRead
	call	SetupColScrolling
	add	esp,04h

; 227                   }

; 228                 }

; 229               }
	jmp	@BLBL28
	align 010h
@BLBL25:

; 230             else
; 231               {
; 232               if (stCFG.bSyncToRead)
	test	byte ptr  stCFG+019h,02h
	je	@BLBL28

; 233                 {
; 234                 stCFG.bSyncToRead = FALSE;
	and	byte ptr  stCFG+019h,0fdh

; 235                 if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
	mov	al,byte ptr  stCFG+01bh
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL28

; 236                   SetupColScrolling(&stWrite);
	push	offset FLAT:stWrite
	call	SetupColScrolling
	add	esp,04h

; 237                 }

; 238               }
@BLBL28:

; 239             WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stRead+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 240             }
@BLBL24:

; 241           break;
	jmp	@BLBL62
	align 04h
	jmp	@BLBL62
	align 04h
@BLBL63:
	cmp	eax,0fa8h
	je	@BLBL64
	cmp	eax,0fa9h
	je	@BLBL65
	cmp	eax,0fa6h
	je	@BLBL66
	cmp	eax,0fa4h
	je	@BLBL67
	cmp	eax,0fabh
	je	@BLBL68
	cmp	eax,0faah
	je	@BLBL69
@BLBL62:

; 242         }
; 243       break;
	jmp	@BLBL48
	align 04h
@BLBL70:

; 244 //    case WM_CHORD:
; 245     case WM_BUTTON2DOWN:
; 246       if(bFrameActivated)
	cmp	dword ptr  bFrameActivated,0h
	je	@BLBL31

; 247         {
; 248         hwndMenu = WinLoadMenu(stRead.hwnd,(HMODULE)NULL,IDMPU_COL_DISP_POPUP);
	push	0fa2h
	push	0h
	push	dword ptr  stRead+0bh
	call	WinLoadMenu
	add	esp,0ch
	mov	[ebp-044h],eax;	hwndMenu

; 249         if (mp1 != 0)
	cmp	dword ptr [ebp+010h],0h;	mp1
	je	@BLBL32

; 250           {
; 251           WinQueryPointerPos(HWND_DESKTOP,&ptl);
	lea	eax,[ebp-018h];	ptl
	push	eax
	push	01h
	call	WinQueryPointerPos
	add	esp,08h

; 252           if (!stCFG.bStickyMenus)
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL33

; 253             usMenuStyle |= PU_MOUSEBUTTON2DOWN;
	mov	ax,word ptr  @11usMenuStyle
	or	al,010h
	mov	word ptr  @11usMenuStyle,ax
	jmp	@BLBL35
	align 010h
@BLBL33:

; 254           else
; 255             usMenuStyle &= ~PU_MOUSEBUTTON2DOWN;
	xor	eax,eax
	mov	ax,word ptr  @11usMenuStyle
	and	al,0efh
	mov	word ptr  @11usMenuStyle,ax

; 256           }
	jmp	@BLBL35
	align 010h
@BLBL32:

; 257         else
; 257           {
; 258           usMenuStyle &= ~PU_MOUSEBUTTON2DOWN;
; 259           WinQueryWindowPos(hwndFrame,&swp);
	xor	eax,eax
	mov	ax,word ptr  @11usMenuStyle
	and	al,0efh
	mov	word ptr  @11usMenuStyle,ax

; 260           ptl.x = (swp.x + (swp.cx - (swp.cx / 4)));
	lea	eax,[ebp-040h];	swp
	push	eax
	push	dword ptr  hwndFrame
	call	WinQueryWindowPos
	add	esp,08h

; 261           ptl.y = (swp.y + (swp.cy / 2));
	mov	ecx,[ebp-030h];	swp
	add	ecx,[ebp-038h];	swp
	mov	eax,[ebp-038h];	swp
	cdq	
	xchg	ecx,eax
	and	edx,03h
	add	ecx,edx
	sar	ecx,02h
	sub	eax,ecx
	mov	[ebp-018h],eax;	ptl

; 262           }
	mov	eax,[ebp-03ch];	swp
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	add	eax,[ebp-034h];	swp
	mov	[ebp-014h],eax;	ptl

; 263         if (stCFG.wColReadFont == wASCIIfont)
@BLBL35:

; 264           PopupMenuItemCheck(hwndMenu,IDMPU_ASCII_FONT,TRUE);
	mov	ax,word ptr  wASCIIfont
	cmp	word ptr  stCFG+0dbh,ax
	jne	@BLBL36

; 265         else
	push	01h
	push	0fa8h
	push	dword ptr [ebp-044h];	hwndMenu
	call	PopupMenuItemCheck
	add	esp,0ch
	jmp	@BLBL37
	align 010h
@BLBL36:

; 266           PopupMenuItemCheck(hwndMenu,IDMPU_HEX_FONT,TRUE);
; 267         if (stCFG.fLockWidth == LOCK_READ)
	push	01h
	push	0fa9h
	push	dword ptr [ebp-044h];	hwndMenu
	call	PopupMenuItemCheck
	add	esp,0ch
@BLBL37:

; 268           PopupMenuItemCheck(hwndMenu,IDMPU_LOCK_WIDTH,TRUE);
	mov	al,byte ptr  stCFG+01bh
	and	eax,03h
	cmp	eax,01h
	jne	@BLBL38

; 269         if (!bStopDisplayThread)
	push	01h
	push	0fabh
	push	dword ptr [ebp-044h];	hwndMenu
	call	PopupMenuItemCheck
	add	esp,0ch
@BLBL38:

; 270           WinSendMsg(hwndMenu,MM_SETITEMTEXT,(MPARAM)IDMPU_SYNC,"~Reset Display");
	cmp	dword ptr  bStopDisplayThread,0h
	jne	@BLBL39

; 271         WinPopupMenu(HWND_DESKTOP,stRead.hwndClient,hwndMenu,ptl.x,ptl.y,usLastPopupItem,usMenuStyle);
	push	offset FLAT:@STAT2
	push	0fa6h
	push	018eh
	push	dword ptr [ebp-044h];	hwndMenu
	call	WinSendMsg
	add	esp,010h
@BLBL39:

; 272         }
	xor	eax,eax
	mov	ax,word ptr  @11usMenuStyle
	push	eax
	xor	eax,eax
	mov	ax,word ptr  @13usLastPopupItem
	push	eax
	push	dword ptr [ebp-014h];	ptl
	push	dword ptr [ebp-018h];	ptl
	push	dword ptr [ebp-044h];	hwndMenu
	push	dword ptr  stRead+0fh
	push	01h
	call	WinPopupMenu
	add	esp,01ch

; 273       else
	jmp	@BLBL40
	align 010h
@BLBL31:

; 274         return WinDefWindowProc(hwnd,msg,mp1,mp2);
; 275       break;
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefWindowProc
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL40:

; 276     case WM_BUTTON1DOWN:
	jmp	@BLBL48
	align 04h
@BLBL71:

; 277       if(bFrameActivated)
; 278         {
	cmp	dword ptr  bFrameActivated,0h
	je	@BLBL41

; 279         WinCopyRect(habAnchorBlock,&rclRect,&stRead.rcl);
; 280         lSaveEdge = rclRect.xLeft;
	push	offset FLAT:stRead+013h
	lea	eax,[ebp-010h];	rclRect
	push	eax
	push	dword ptr  habAnchorBlock
	call	WinCopyRect
	add	esp,0ch

; 281         if (TrackChildWindow(habAnchorBlock,hwndClient,&rclRect,TF_LEFT))
	mov	eax,[ebp-010h];	rclRect
	mov	[ebp-01ch],eax;	lSaveEdge

; 282           {
	push	01h
	lea	eax,[ebp-010h];	rclRect
	push	eax
	push	dword ptr  hwndClient
	push	dword ptr  habAnchorBlock
	call	TrackChildWindow
	add	esp,010h
	test	eax,eax
	je	@BLBL46

; 283           if (rclRect.xLeft != lSaveEdge)
; 284             {
	mov	eax,[ebp-01ch];	lSaveEdge
	cmp	[ebp-010h],eax;	rclRect
	je	@BLBL46

; 285             WinSendMsg(stWrite.hwndClient,UM_TRACKSIB,0L,(MPARAM)rclRect.xLeft);
; 286             WinSendMsg(stRead.hwndClient,UM_TRACKSIB,(MPARAM)rclRect.xLeft,0L);
	mov	eax,[ebp-010h];	rclRect
	push	eax
	push	0h
	push	08013h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h

; 287             if (stCFG.fLockWidth == LOCK_WRITE)
	push	0h
	mov	eax,[ebp-010h];	rclRect
	push	eax
	push	08013h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 288               stCFG.lLockWidth = ((stWrite.lWidth / stCell.cx) + 1);
	mov	al,byte ptr  stCFG+01bh
	and	eax,03h
	cmp	eax,02h
	jne	@BLBL44

; 289             else
	movsx	ecx,word ptr  stCell
	mov	eax,dword ptr  stWrite+033h
	cdq	
	idiv	ecx
	inc	eax
	mov	dword ptr  stCFG+031h,eax
	jmp	@BLBL46
	align 010h
@BLBL44:

; 290               stCFG.lLockWidth = ((stRead.lWidth / stCell.cx) + 1);
; 291             }
	movsx	ecx,word ptr  stCell
	mov	eax,dword ptr  stRead+033h
	cdq	
	idiv	ecx
	inc	eax
	mov	dword ptr  stCFG+031h,eax

; 292           }

; 293         }

; 294       else
	jmp	@BLBL46
	align 010h
@BLBL41:

; 295         return WinDefWindowProc(hwnd,msg,mp1,mp2);
; 296       break;
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefWindowProc
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL46:

; 297     case WM_DESTROY:
	jmp	@BLBL48
	align 04h
@BLBL72:

; 298       GpiDestroyPS(hdcPs);
; 299       break;
	push	dword ptr  @bhdcPs
	call	GpiDestroyPS
	add	esp,04h

; 300     case UM_SHOWNEW:
	jmp	@BLBL48
	align 04h
@BLBL73:

; 301       stRead.lScrollIndex = 0;
; 302       stRead.lScrollRow = 0;
	mov	dword ptr  stRead+06fh,0h

; 303       ClearColScrollBar(&stRead);
	mov	dword ptr  stRead+06bh,0h

; 304     case UM_SHOWAGAIN:
	push	offset FLAT:stRead
	call	ClearColScrollBar
	add	esp,04h
@BLBL74:

; 305       stRead.bActive = TRUE;
; 306       if ((stCFG.fDisplaying & (DISP_DATA | DISP_FILE)) && !stCFG.bSyncToWrite)
	or	byte ptr  stRead+02h,01h

; 307         SetupColScrolling(&stRead);
	mov	al,byte ptr  stCFG+01bh
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL47
	test	byte ptr  stCFG+019h,01h
	jne	@BLBL47

; 308       WinShowWindow(stRead.hwnd,TRUE);
	push	offset FLAT:stRead
	call	SetupColScrolling
	add	esp,04h
@BLBL47:

; 309       WinSendMsg(hwnd,UM_TRACKFRAME,0L,0L);
	push	01h
	push	dword ptr  stRead+0bh
	call	WinShowWindow
	add	esp,08h

; 310       WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	08012h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendMsg
	add	esp,010h

; 311       WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stRead+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 312       break;
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 313     case UM_HIDEWIN:
	jmp	@BLBL48
	align 04h
@BLBL75:

; 314       ClearColScrollBar(&stRead);
; 315       stRead.bActive = FALSE;
	push	offset FLAT:stRead
	call	ClearColScrollBar
	add	esp,04h

; 316       WinShowWindow(hwnd,FALSE);
	and	byte ptr  stRead+02h,0feh

; 317       WinSetWindowPos(stRead.hwnd,HWND_BOTTOM,0L,0L,0L,0L,(SWP_MOVE | SWP_SIZE | SWP_ZORDER));
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinShowWindow
	add	esp,08h

; 318       break;
	push	07h
	push	0h
	push	0h
	push	0h
	push	0h
	push	04h
	push	dword ptr  stRead+0bh
	call	WinSetWindowPos
	add	esp,01ch

; 319     case WM_PAINT:
	jmp	@BLBL48
	align 04h
@BLBL76:

; 320 #ifdef this_junk
; 321       if (!pstCFG->bDisplayingData && (stCFG.bSyncToRead || stCFG.bSyncToWrite))
; 322         ColumnPaint(&stRead,WinPeekMsg(habAnchorBlock,&stQmsg,stWrite.hwndClient,WM_PAINT,WM_PAINT,PM_REMOVE));
; 323       else
; 324 #endif
; 325         ColumnPaint(&stRead);
; 326       break;
	push	offset FLAT:stRead
	call	ColumnPaint
	add	esp,04h

; 327     case UM_TRACKSIB:
	jmp	@BLBL48
	align 04h
@BLBL77:

; 328       ColumnSize(&stRead,(LONG)mp1,(LONG)mp2,TRUE);
; 329       break;
	push	01h
	mov	eax,[ebp+014h];	mp2
	push	eax
	mov	eax,[ebp+010h];	mp1
	push	eax
	push	offset FLAT:stRead
	call	ColumnSize
	add	esp,010h

; 330     case UM_TRACKFRAME:
	jmp	@BLBL48
	align 04h
@BLBL78:

; 331       ColumnSize(&stRead,(LONG)mp1,(LONG)mp2,FALSE);
; 332       break;
	push	0h
	mov	eax,[ebp+014h];	mp2
	push	eax
	mov	eax,[ebp+010h];	mp1
	push	eax
	push	offset FLAT:stRead
	call	ColumnSize
	add	esp,010h

; 333     case WM_ERASEBACKGROUND:
	jmp	@BLBL48
	align 04h
@BLBL79:

; 334       return (MRESULT)(TRUE);
; 335     case WM_CLOSE:
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL80:

; 336       WinPostMsg(hwnd,WM_QUIT,0L,0L);
; 337     default:
	push	0h
	push	0h
	push	02ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h
@BLBL81:

; 338       return WinDefWindowProc(hwnd,msg,mp1,mp2);
; 339     }
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefWindowProc
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL48
	align 04h
@BLBL49:
	cmp	eax,07ah
	je	@BLBL50
	cmp	eax,01h
	je	@BLBL51
	cmp	eax,0dh
	je	@BLBL52
	cmp	eax,031h
	je	@BLBL53
	cmp	eax,020h
	je	@BLBL61
	cmp	eax,074h
	je	@BLBL70
	cmp	eax,071h
	je	@BLBL71
	cmp	eax,02h
	je	@BLBL72
	cmp	eax,0800fh
	je	@BLBL73
	cmp	eax,08010h
	je	@BLBL74
	cmp	eax,08011h
	je	@BLBL75
	cmp	eax,023h
	je	@BLBL76
	cmp	eax,08013h
	je	@BLBL77
	cmp	eax,08012h
	je	@BLBL78
	cmp	eax,04fh
	je	@BLBL79
	cmp	eax,029h
	je	@BLBL80
	jmp	@BLBL81
	align 04h
@BLBL48:

; 340   return(FALSE);
; 341   }
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
fnwpReadColumnClient	endp

; 345   static HDC hdcPs;
	align 010h

	public fnwpWriteColumnClient
fnwpWriteColumnClient	proc
	push	ebp
	mov	ebp,esp
	sub	esp,044h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,011h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 356     {
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL130
	align 04h
@BLBL131:

; 357     case WM_CHAR:
; 358       if (bSendNextKeystroke)
; 359         if (ProcessKeystroke(&stCFG,mp1,mp2))
	cmp	dword ptr  bSendNextKeystroke,0h
	je	@BLBL82

; 360           return((MRESULT)TRUE);
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	push	offset FLAT:stCFG
	call	ProcessKeystroke
	add	esp,0ch
	test	eax,eax
	je	@BLBL82

; 361       return( WinDefWindowProc(hwnd,msg,mp1,mp2));
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL82:

; 362     case WM_CREATE:
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefWindowProc
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL132:

; 363       hdcPs = WinOpenWindowDC(hwnd);
; 364       usLastPopupItem = IDMPU_SYNC;
	push	dword ptr [ebp+08h];	hwnd
	call	WinOpenWindowDC
	add	esp,04h
	mov	dword ptr  @76hdcPs,eax

; 365       stWrite.lBackgrndColor = stCFG.lWriteColBackgrndColor;
	mov	word ptr  @7dusLastPopupItem,0fa6h

; 366       stWrite.bActive = FALSE;
	mov	eax,dword ptr  stCFG+0c5h
	mov	dword ptr  stWrite+037h,eax

; 367       stWrite.cbSize = sizeof(SCREEN);
	and	byte ptr  stWrite+02h,0feh

; 368       stWrite.lScrollIndex = 0;
	mov	word ptr  stWrite,07fh

; 369       stWrite.hwndScroll = (HWND)NULL;
	mov	dword ptr  stWrite+06fh,0h

; 370       stWrite.wDirection = CS_WRITE;
	mov	dword ptr  stWrite+05fh,0h

; 371       stColor.cbSize = sizeof(CLRDLG);
	mov	word ptr  stWrite+05h,08000h

; 372       usMenuStyle = (PU_POSITIONONITEM | PU_HCONSTRAIN | PU_MOUSEBUTTON2 | PU_VCONSTRAIN | PU_KEYBOARD | PU_MOUSEBUTTON1);
	mov	word ptr  @7cstColor,05ah

; 373       WinSendMsg(hwnd,UM_TRACKFRAME,0L,0L);
	mov	word ptr  @7eusMenuStyle,02c7h

; 374       break;
	push	0h
	push	0h
	push	08012h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendMsg
	add	esp,010h

; 375     case WM_ACTIVATE:
	jmp	@BLBL129
	align 04h
@BLBL133:

; 376       if(SHORT1FROMMP(mp1))
; 377         {
	mov	ax,[ebp+010h];	mp1
	test	ax,ax
	je	@BLBL84

; 378         if (!bFrameActivated)
; 379           {
	cmp	dword ptr  bFrameActivated,0h
	jne	@BLBL86

; 380           WinSetFocus(HWND_DESKTOP,hwndFrame);
; 381           WinSendMsg(WinQueryHelpInstance(hwndClient),HM_SET_ACTIVE_WINDOW,0L,0L);
	push	dword ptr  hwndFrame
	push	01h
	call	WinSetFocus
	add	esp,08h

; 382           bFrameActivated = TRUE;
	push	dword ptr  hwndClient
	call	WinQueryHelpInstance
	add	esp,04h
	push	0h
	push	0h
	push	0224h
	push	eax
	call	WinSendMsg
	add	esp,010h

; 383           }
	mov	dword ptr  bFrameActivated,01h

; 384         }

; 385       else
	jmp	@BLBL86
	align 010h
@BLBL84:

; 386         bFrameActivated = FALSE;
; 387       break;
	mov	dword ptr  bFrameActivated,0h
@BLBL86:

; 388     case WM_VSCROLL:
	jmp	@BLBL129
	align 04h
@BLBL134:

; 389       switch(HIUSHORT(mp2))
; 390         {
	mov	eax,[ebp+014h];	mp2
	shr	eax,010h
	and	eax,0ffffh
	and	eax,0ffffh
	jmp	@BLBL136
	align 04h
@BLBL137:

; 391         case SB_LINEDOWN:
; 392           ColScroll(&stWrite,1,FALSE);
; 393           break;
	push	0h
	push	01h
	push	offset FLAT:stWrite
	call	ColScroll
	add	esp,0ch

; 394         case SB_LINEUP:
	jmp	@BLBL135
	align 04h
@BLBL138:

; 395           ColScroll(&stWrite,-1,FALSE);
; 396           break;
	push	0h
	push	0ffffffffh
	push	offset FLAT:stWrite
	call	ColScroll
	add	esp,0ch

; 397         case SB_PAGEDOWN:
	jmp	@BLBL135
	align 04h
@BLBL139:

; 398           ColScroll(&stWrite,stWrite.lCharHeight,FALSE);
; 399           break;
	push	0h
	mov	ax,word ptr  stWrite+02bh
	push	eax
	push	offset FLAT:stWrite
	call	ColScroll
	add	esp,0ch

; 400         case SB_PAGEUP:
	jmp	@BLBL135
	align 04h
@BLBL140:

; 401           ColScroll(&stWrite,-stWrite.lCharHeight,FALSE);
; 402           break;
	push	0h
	mov	eax,dword ptr  stWrite+02bh
	neg	eax
	push	eax
	push	offset FLAT:stWrite
	call	ColScroll
	add	esp,0ch

; 403         case SB_SLIDERPOSITION:
	jmp	@BLBL135
	align 04h
@BLBL141:

; 404           ColScroll(&stWrite,LOUSHORT(mp2),TRUE);
; 405           break;
	push	01h
	mov	ax,[ebp+014h];	mp2
	push	eax
	push	offset FLAT:stWrite
	call	ColScroll
	add	esp,0ch

; 406         }
	jmp	@BLBL135
	align 04h
	jmp	@BLBL135
	align 04h
@BLBL136:
	cmp	eax,02h
	je	@BLBL137
	cmp	eax,01h
	je	@BLBL138
	cmp	eax,04h
	je	@BLBL139
	cmp	eax,03h
	je	@BLBL140
	cmp	eax,06h
	je	@BLBL141
@BLBL135:

; 407       break;
; 408     case WM_COMMAND:
	jmp	@BLBL129
	align 04h
@BLBL142:

; 409       switch (SHORT1FROMMP(mp1))
; 410         {
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL144
	align 04h
@BLBL145:

; 411         case IDMPU_ASCII_FONT:
; 412           if (!stCFG.bStickyMenus)
; 413             usLastPopupItem = IDMPU_FONT;
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL87

; 414           else
	mov	word ptr  @7dusLastPopupItem,0fa7h
	jmp	@BLBL88
	align 010h
@BLBL87:

; 415             usLastPopupItem = IDMPU_SYNC;
; 416           if (stCFG.wColWriteFont != wASCIIfont)
	mov	word ptr  @7dusLastPopupItem,0fa6h
@BLBL88:

; 417             {
	mov	ax,word ptr  wASCIIfont
	cmp	word ptr  stCFG+0ddh,ax
	je	@BLBL89

; 418             stCFG.wColWriteFont = wASCIIfont;
; 419             WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
	mov	ax,word ptr  wASCIIfont
	mov	word ptr  stCFG+0ddh,ax

; 420             }
	push	0h
	push	0h
	push	dword ptr  stWrite+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 421           break;
@BLBL89:

; 422         case IDMPU_HEX_FONT:
	jmp	@BLBL143
	align 04h
@BLBL146:

; 423           if (!stCFG.bStickyMenus)
; 424             usLastPopupItem = IDMPU_FONT;
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL90

; 425           else
	mov	word ptr  @7dusLastPopupItem,0fa7h
	jmp	@BLBL91
	align 010h
@BLBL90:

; 426             usLastPopupItem = IDMPU_SYNC;
; 427           if (stCFG.wColWriteFont != wHEXfont)
	mov	word ptr  @7dusLastPopupItem,0fa6h
@BLBL91:

; 428             {
	mov	ax,word ptr  wHEXfont
	cmp	word ptr  stCFG+0ddh,ax
	je	@BLBL92

; 429             stCFG.wColWriteFont = wHEXfont;
; 430             WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
	mov	ax,word ptr  wHEXfont
	mov	word ptr  stCFG+0ddh,ax

; 431             }
	push	0h
	push	0h
	push	dword ptr  stWrite+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 432           break;
@BLBL92:

; 433         case IDMPU_SYNC:
	jmp	@BLBL143
	align 04h
@BLBL147:

; 434           usLastPopupItem = IDMPU_SYNC;
; 435           if (bStopDisplayThread)
	mov	word ptr  @7dusLastPopupItem,0fa6h

; 436             stWrite.lScrollIndex = stRead.lScrollIndex;
	cmp	dword ptr  bStopDisplayThread,0h
	je	@BLBL93

; 437           else
	mov	eax,dword ptr  stRead+06fh
	mov	dword ptr  stWrite+06fh,eax
	jmp	@BLBL94
	align 010h
@BLBL93:

; 438             stWrite.lScrollIndex = 0;
; 439           stWrite.lScrollRow = GetColScrollRow(&stWrite,0);
	mov	dword ptr  stWrite+06fh,0h
@BLBL94:

; 440           WinSendMsg(stRead.hwndScroll,
	push	0h
	push	offset FLAT:stWrite
	call	GetColScrollRow
	add	esp,08h
	mov	dword ptr  stWrite+06bh,eax

; 441                      SBM_SETPOS,
	push	0h
	mov	ax,word ptr  stWrite+06bh
	and	eax,0ffffh
	push	eax
	push	01a1h
	push	dword ptr  stRead+05fh
	call	WinSendMsg
	add	esp,010h

; 442                      MPFROMSHORT(stWrite.lScrollRow),
; 443                      MPFROMSHORT(0));
; 444           if (stWrite.bSync)
; 445             {
	test	byte ptr  stWrite+02h,010h
	je	@BLBL95

; 446             stRow.lScrollIndex = stWrite.lScrollIndex;
; 447             stRow.lScrollRow = GetRowScrollRow(&stRow);
	mov	eax,dword ptr  stWrite+06fh
	mov	dword ptr  stRow+06fh,eax

; 448             }
	push	offset FLAT:stRow
	call	GetRowScrollRow
	add	esp,04h
	mov	dword ptr  stRow+06bh,eax

; 449           WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
@BLBL95:

; 450           break;
	push	0h
	push	0h
	push	dword ptr  stWrite+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 451         case IDMPU_COLORS:
	jmp	@BLBL143
	align 04h
@BLBL148:

; 452           if (!stCFG.bStickyMenus)
; 453             usLastPopupItem = IDMPU_COLORS;
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL96

; 454           else
	mov	word ptr  @7dusLastPopupItem,0fa4h
	jmp	@BLBL97
	align 010h
@BLBL96:

; 455             usLastPopupItem = IDMPU_SYNC;
; 456           stColor.lForeground = stCFG.lWriteColForegrndColor;
	mov	word ptr  @7dusLastPopupItem,0fa6h
@BLBL97:

; 457           stColor.lBackground = stCFG.lWriteColBackgrndColor;
	mov	eax,dword ptr  stCFG+0c9h
	mov	dword ptr  @7cstColor+06h,eax

; 458           sprintf(stColor.szCaption,"Lexical Transmit Data Display Colors");
	mov	eax,dword ptr  stCFG+0c5h
	mov	dword ptr  @7cstColor+02h,eax

; 459           if (WinDlgBox(HWND_DESKTOP,
	mov	edx,offset FLAT:@STAT3
	mov	eax,offset FLAT:@7cstColor+0ah
	call	_sprintfieee

; 460                         hwnd,
	push	offset FLAT:@7cstColor
	push	014b4h
	push	0h
	push	offset FLAT: fnwpSetColorDlg
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL98

; 461                   (PFNWP)fnwpSetColorDlg,
; 462                 (USHORT)NULL,
; 463                         CLR_DLG,
; 464                 MPFROMP(&stColor)))
; 465             {
; 466             stCFG.lWriteColForegrndColor = stColor.lForeground;
; 467             stCFG.lWriteColBackgrndColor = stColor.lBackground;
	mov	eax,dword ptr  @7cstColor+06h
	mov	dword ptr  stCFG+0c9h,eax

; 468             stWrite.lBackgrndColor = stColor.lBackground;
	mov	eax,dword ptr  @7cstColor+02h
	mov	dword ptr  stCFG+0c5h,eax

; 469             stWrite.lForegrndColor = stColor.lForeground;
	mov	eax,dword ptr  @7cstColor+02h
	mov	dword ptr  stWrite+037h,eax

; 470             WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
	mov	eax,dword ptr  @7cstColor+06h
	mov	dword ptr  stWrite+03bh,eax

; 471             }
	push	0h
	push	0h
	push	dword ptr  stWrite+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 472           break;
@BLBL98:

; 473         case IDMPU_LOCK_WIDTH:
	jmp	@BLBL143
	align 04h
@BLBL149:

; 474           if (!stCFG.bStickyMenus)
; 475             usLastPopupItem = IDMPU_LOCK_WIDTH;
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL99

; 476           else
	mov	word ptr  @7dusLastPopupItem,0fabh
	jmp	@BLBL100
	align 010h
@BLBL99:

; 477             usLastPopupItem = IDMPU_SYNC;
; 478           if (stCFG.fLockWidth == LOCK_WRITE)
	mov	word ptr  @7dusLastPopupItem,0fa6h
@BLBL100:

; 479             stCFG.fLockWidth = LOCK_NONE;
	mov	al,byte ptr  stCFG+01bh
	and	eax,03h
	cmp	eax,02h
	jne	@BLBL101

; 480           else
	and	byte ptr  stCFG+01bh,0fch
	jmp	@BLBL102
	align 010h
@BLBL101:

; 481             {
; 482             stCFG.lLockWidth = ((stWrite.lWidth / stCell.cx) + 1);
; 483             stCFG.fLockWidth = LOCK_WRITE;
	movsx	ecx,word ptr  stCell
	mov	eax,dword ptr  stWrite+033h
	cdq	
	idiv	ecx
	inc	eax
	mov	dword ptr  stCFG+031h,eax

; 484             }
	mov	al,byte ptr  stCFG+01bh
	and	al,0fch
	or	al,02h
	mov	byte ptr  stCFG+01bh,al

; 485           break;
@BLBL102:

; 486         case IDMPU_DISP_FILTERS:
	jmp	@BLBL143
	align 04h
@BLBL150:

; 487           if (!stCFG.bStickyMenus)
; 488             usLastPopupItem = IDMPU_DISP_FILTERS;
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL103

; 489           else
	mov	word ptr  @7dusLastPopupItem,0faah
	jmp	@BLBL104
	align 010h
@BLBL103:

; 490             usLastPopupItem = 
; 490 IDMPU_SYNC;
; 491           if (WinDlgBox(HWND_DESKTOP,
	mov	word ptr  @7dusLastPopupItem,0fa6h
@BLBL104:

; 492                         hwnd,
	push	offset FLAT:stWrite
	push	01770h
	push	0h
	push	offset FLAT: fnwpDisplaySetupDlgProc
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL105

; 493                  (PFNWP)fnwpDisplaySetupDlgProc,
; 494                 (USHORT)NULL,
; 495                         DISP_FILTER_DLG,
; 496                 MPFROMP(&stWrite)))
; 497             {
; 498             stCFG.bWriteTestNewLine = stWrite.bTestNewLine;
; 499             stCFG.bSkipWriteBlankLines = stWrite.bSkipBlankLines;
	mov	cl,byte ptr  stWrite+02h
	and	ecx,03h
	shr	ecx,01h
	mov	al,byte ptr  stCFG+019h
	and	al,0f7h
	sal	ecx,03h
	and	cl,0fh
	or	al,cl
	mov	byte ptr  stCFG+019h,al

; 500             stCFG.byWriteNewLineChar = stWrite.byNewLineChar;
	mov	cl,byte ptr  stWrite+02h
	and	ecx,07h
	shr	ecx,02h
	mov	al,byte ptr  stCFG+018h
	and	al,0bfh
	sal	ecx,06h
	and	cl,07fh
	or	al,cl
	mov	byte ptr  stCFG+018h,al

; 501             stCFG.bFilterWrite = stWrite.bFilter;
	mov	al,byte ptr  stWrite+03h
	mov	byte ptr  stCFG+0ceh,al

; 502             stCFG.fFilterWriteMask = stWrite.fFilterMask;
	mov	cl,byte ptr  stWrite+02h
	and	ecx,03fh
	shr	ecx,05h
	mov	al,byte ptr  stCFG+019h
	and	al,0dfh
	sal	ecx,05h
	and	cl,03fh
	or	al,cl
	mov	byte ptr  stCFG+019h,al

; 503             stCFG.byWriteMask = stWrite.byDisplayMask;
	mov	ecx,dword ptr  stWrite+07h
	mov	al,byte ptr  stCFG+01ah
	and	al,0fh
	sal	ecx,04h
	or	al,cl
	mov	byte ptr  stCFG+01ah,al

; 504             if (stWrite.bSync)
	mov	al,byte ptr  stWrite+04h
	mov	byte ptr  stCFG+030h,al

; 505               {
	test	byte ptr  stWrite+02h,010h
	je	@BLBL106

; 506               if (!stCFG.bSyncToWrite)
; 507                 {
	test	byte ptr  stCFG+019h,01h
	jne	@BLBL109

; 508                 stRead.bSync = FALSE;
; 509                 stCFG.bSyncToRead = FALSE;
	and	byte ptr  stRead+02h,0efh

; 510                 stCFG.bSyncToWrite = TRUE;
	and	byte ptr  stCFG+019h,0fdh

; 511                 if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
	or	byte ptr  stCFG+019h,01h

; 512                   {
	mov	al,byte ptr  stCFG+01bh
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL109

; 513                   ClearColScrollBar(&stRead);
; 514                   SetupColScrolling(&stWrite);
	push	offset FLAT:stRead
	call	ClearColScrollBar
	add	esp,04h

; 515                   }
	push	offset FLAT:stWrite
	call	SetupColScrolling
	add	esp,04h

; 516                 }

; 517               }

; 518             else
	jmp	@BLBL109
	align 010h
@BLBL106:

; 519               {
; 520               if (stCFG.bSyncToWrite)
; 521                 {
	test	byte ptr  stCFG+019h,01h
	je	@BLBL109

; 522                 stCFG.bSyncToWrite = FALSE;
; 523                 if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
	and	byte ptr  stCFG+019h,0feh

; 524                   SetupColScrolling(&stRead);
	mov	al,byte ptr  stCFG+01bh
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL109

; 525                 }
	push	offset FLAT:stRead
	call	SetupColScrolling
	add	esp,04h

; 526               }

; 527             WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
@BLBL109:

; 528             }
	push	0h
	push	0h
	push	dword ptr  stWrite+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 529           break;
@BLBL105:

; 530         }
	jmp	@BLBL143
	align 04h
	jmp	@BLBL143
	align 04h
@BLBL144:
	cmp	eax,0fa8h
	je	@BLBL145
	cmp	eax,0fa9h
	je	@BLBL146
	cmp	eax,0fa6h
	je	@BLBL147
	cmp	eax,0fa4h
	je	@BLBL148
	cmp	eax,0fabh
	je	@BLBL149
	cmp	eax,0faah
	je	@BLBL150
@BLBL143:

; 531       break;
; 532     case WM_BUTTON2DOWN:
	jmp	@BLBL129
	align 04h
@BLBL151:

; 533       if(bFrameActivated)
; 534         {
	cmp	dword ptr  bFrameActivated,0h
	je	@BLBL112

; 535         hwndMenu = WinLoadMenu(stWrite.hwnd,(HMODULE)NULL,IDMPU_COL_DISP_POPUP);
; 536         if (mp1 != 0)
	push	0fa2h
	push	0h
	push	dword ptr  stWrite+0bh
	call	WinLoadMenu
	add	esp,0ch
	mov	[ebp-020h],eax;	hwndMenu

; 537           {
	cmp	dword ptr [ebp+010h],0h;	mp1
	je	@BLBL113

; 538           WinQueryPointerPos(HWND_DESKTOP,&ptl);
; 539           if (!stCFG.bStickyMenus)
	lea	eax,[ebp-01ch];	ptl
	push	eax
	push	01h
	call	WinQueryPointerPos
	add	esp,08h

; 540             usMenuStyle |= PU_MOUSEBUTTON2DOWN;
	test	byte ptr  stCFG+016h,08h
	jne	@BLBL114

; 541           else
	mov	ax,word ptr  @7eusMenuStyle
	or	al,010h
	mov	word ptr  @7eusMenuStyle,ax
	jmp	@BLBL116
	align 010h
@BLBL114:

; 542             usMenuStyle &= ~PU_MOUSEBUTTON2DOWN;
; 543           }
	xor	eax,eax
	mov	ax,word ptr  @7eusMenuStyle
	and	al,0efh
	mov	word ptr  @7eusMenuStyle,ax

; 544         else
	jmp	@BLBL116
	align 010h
@BLBL113:

; 545           {
; 546           usMenuStyle &= ~PU_MOUSEBUTTON2DOWN;
; 547           WinQueryWindowPos(hwndFrame,&swp);
	xor	eax,eax
	mov	ax,word ptr  @7eusMenuStyle
	and	al,0efh
	mov	word ptr  @7eusMenuStyle,ax

; 548           ptl.x = (swp.x + (swp.cx / 4));
	lea	eax,[ebp-044h];	swp
	push	eax
	push	dword ptr  hwndFrame
	call	WinQueryWindowPos
	add	esp,08h

; 549           ptl.y = (swp.y + (swp.cy / 2));
	mov	eax,[ebp-03ch];	swp
	cdq	
	and	edx,03h
	add	eax,edx
	sar	eax,02h
	add	eax,[ebp-034h];	swp
	mov	[ebp-01ch],eax;	ptl

; 550           }
	mov	eax,[ebp-040h];	swp
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	add	eax,[ebp-038h];	swp
	mov	[ebp-018h],eax;	ptl

; 551         if (stCFG.wColWriteFont == wASCIIfont)
@BLBL116:

; 552           PopupMenuItemCheck(hwndMenu,IDMPU_ASCII_FONT,TRUE);
	mov	ax,word ptr  wASCIIfont
	cmp	word ptr  stCFG+0ddh,ax
	jne	@BLBL117

; 553         else
	push	01h
	push	0fa8h
	push	dword ptr [ebp-020h];	hwndMenu
	call	PopupMenuItemCheck
	add	esp,0ch
	jmp	@BLBL118
	align 010h
@BLBL117:

; 554           PopupMenuItemCheck(hwndMenu,IDMPU_HEX_FONT,TRUE);
; 555         if (stCFG.fLockWidth == LOCK_WRITE)
	push	01h
	push	0fa9h
	push	dword ptr [ebp-020h];	hwndMenu
	call	PopupMenuItemCheck
	add	esp,0ch
@BLBL118:

; 556           PopupMenuItemCheck(hwndMenu,IDMPU_LOCK_WIDTH,TRUE);
	mov	al,byte ptr  stCFG+01bh
	and	eax,03h
	cmp	eax,02h
	jne	@BLBL119

; 557         if (!bStopDisplayThread)
	push	01h
	push	0fabh
	push	dword ptr [ebp-020h];	hwndMenu
	call	PopupMenuItemCheck
	add	esp,0ch
@BLBL119:

; 558           WinSendMsg(hwndMenu,MM_SETITEMTEXT,(MPARAM)IDMPU_SYNC,"~Reset Display");
	cmp	dword ptr  bStopDisplayThread,0h
	jne	@BLBL120

; 559         WinPopupMenu(HWND_DESKTOP,stWrite.hwndClient,hwndMenu,ptl.x,ptl.y,usLastPopupItem,usMenuStyle);
	push	offset FLAT:@STAT4
	push	0fa6h
	push	018eh
	push	dword ptr [ebp-020h];	hwndMenu
	call	WinSendMsg
	add	esp,010h
@BLBL120:

; 560         }
	xor	eax,eax
	mov	ax,word ptr  @7eusMenuStyle
	push	eax
	xor	eax,eax
	mov	ax,word ptr  @7dusLastPopupItem
	push	eax
	push	dword ptr [ebp-018h];	ptl
	push	dword ptr [ebp-01ch];	ptl
	push	dword ptr [ebp-020h];	hwndMenu
	push	dword ptr  stWrite+0fh
	push	01h
	call	WinPopupMenu
	add	esp,01ch

; 561       else
	jmp	@BLBL121
	align 010h
@BLBL112:

; 562         return WinDefWindowProc(hwnd,msg,mp1,mp2);
; 563       break;
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefWindowProc
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL121:

; 564     case WM_BUTTON1DOWN:
	jmp	@BLBL129
	align 04h
@BLBL152:

; 565       if (bFrameActivated)
; 566         {
	cmp	dword ptr  bFrameActivated,0h
	je	@BLBL122

; 567         WinCopyRect(habAnchorBlock,&rclRect,&stWrite.rcl);
; 568         lSaveEdge = rclRect.xRight;
	push	offset FLAT:stWrite+013h
	lea	eax,[ebp-010h];	rclRect
	push	eax
	push	dword ptr  habAnchorBlock
	call	WinCopyRect
	add	esp,0ch

; 569         if (TrackChildWindow(habAnchorBlock,hwndClient,&rclRect,TF_RIGHT))
	mov	eax,[ebp-08h];	rclRect
	mov	[ebp-014h],eax;	lSaveEdge

; 570           {
	push	04h
	lea	eax,[ebp-010h];	rclRect
	push	eax
	push	dword ptr  hwndClient
	push	dword ptr  habAnchorBlock
	call	TrackChildWindow
	add	esp,010h
	test	eax,eax
	je	@BLBL127

; 571           if (rclRect.xRight != lSaveEdge)
; 572             {
	mov	eax,[ebp-014h];	lSaveEdge
	cmp	[ebp-08h],eax;	rclRect
	je	@BLBL127

; 573             WinSendMsg(stWrite.hwndClient,UM_TRACKSIB,0L,(MPARAM)rclRect.xRight);
; 574             WinSendMsg(stRead.hwndClient,UM_TRACKSIB,(MPARAM)rclRect.xRight,0L);
	mov	eax,[ebp-08h];	rclRect
	push	eax
	push	0h
	push	08013h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h

; 575             if (stCFG.fLockWidth == LOCK_WRITE)
	push	0h
	mov	eax,[ebp-08h];	rclRect
	push	eax
	push	08013h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 576               stCFG.lLockWidth = ((stWrite.lWidth / stCell.cx) + 1);
	mov	al,byte ptr  stCFG+01bh
	and	eax,03h
	cmp	eax,02h
	jne	@BLBL125

; 577             else
	movsx	ecx,word ptr  stCell
	mov	eax,dword ptr  stWrite+033h
	cdq	
	idiv	ecx
	inc	eax
	mov	dword ptr  stCFG+031h,eax
	jmp	@BLBL127
	align 010h
@BLBL125:

; 578               stCFG.lLockWidth = ((stRead.lWidth / stCell.cx) + 1);
; 579             }
	movsx	ecx,word ptr  stCell
	mov	eax,dword ptr  stRead+033h
	cdq	
	idiv	ecx
	inc	eax
	mov	dword ptr  stCFG+031h,eax

; 580           }

; 581         }

; 582       else
	jmp	@BLBL127
	align 010h
@BLBL122:

; 583         return WinDefWindowProc(hwnd,msg,mp1,mp2);
; 584       break;
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefWindowProc
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL127:

; 585     case WM_DESTROY:
	jmp	@BLBL129
	align 04h
@BLBL153:

; 586       GpiDestroyPS(hdcPs);
; 587       break;
	push	dword ptr  @76hdcPs
	call	GpiDestroyPS
	add	esp,04h

; 588     case UM_SHOWNEW:
	jmp	@BLBL129
	align 04h
@BLBL154:

; 589       stWrite.lScrollIndex = 0;
; 590       stWrite.lScrollRow = 0;
	mov	dword ptr  stWrite+06fh,0h

; 591       ClearColScrollBar(&stWrite);
	mov	dword ptr  stWrite+06bh,0h

; 592     case UM_SHOWAGAIN:
	push	offset FLAT:stWrite
	call	ClearColScrollBar
	add	esp,04h
@BLBL155:

; 593       stWrite.bActive = TRUE;
; 594       if ((stCFG.fDisplaying & (DISP_DATA | DISP_FILE)) && !stCFG.bSyncToRead)
	or	byte ptr  stWrite+02h,01h

; 595         SetupColScrolling(&stWrite);
	mov	al,byte ptr  stCFG+01bh
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL128
	test	byte ptr  stCFG+019h,02h
	jne	@BLBL128

; 596       WinShowWindow(stWrite.hwnd,TRUE);
	push	offset FLAT:stWrite
	call	SetupColScrolling
	add	esp,04h
@BLBL128:

; 597       WinSendMsg(hwnd,UM_TRACKFRAME,0L,0L);
	push	01h
	push	dword ptr  stWrite+0bh
	call	WinShowWindow
	add	esp,08h

; 598       WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	08012h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendMsg
	add	esp,010h

; 599       WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stWrite+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 600       break;
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 601     case UM_HIDEWIN:
	jmp	@BLBL129
	align 04h
@BLBL156:

; 602       stWrite.bActive = FALSE;
; 603       ClearColScrollBar(&stWrite);
	and	byte ptr  stWrite+02h,0feh

; 604       WinShowWindow(hwnd,FALSE);
	push	offset FLAT:stWrite
	call	ClearColScrollBar
	add	esp,04h

; 605       WinSetWindowPos(stWrite.hwnd,HWND_BOTTOM,0L,0L,0L,0L,(SWP_MOVE | SWP_SIZE | SWP_ZORDER));
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinShowWindow
	add	esp,08h

; 606       break;
	push	07h
	push	0h
	push	0h
	push	0h
	push	0h
	push	04h
	push	dword ptr  stWrite+0bh
	call	WinSetWindowPos
	add	esp,01ch

; 607     case WM_PAINT:
	jmp	@BLBL129
	align 04h
@BLBL157:

; 608 #ifdef this_junk
; 609       if (!pstCFG->bDisplayingData && (stCFG.bSyncToRead || stCFG.bSyncToWrite))
; 610         ColumnPaint(&stWrite,WinPeekMsg(habAnchorBlock,&stQmsg,stRead.hwndClient,WM_PAINT,WM_PAINT,PM_REMOVE));
; 611       else
; 612 #endif
; 613         ColumnPaint(&stWrite);
; 614       break;
	push	offset FLAT:stWrite
	call	ColumnPaint
	add	esp,04h

; 615     case UM_TRACKSIB:
	jmp	@BLBL129
	align 04h
@BLBL158:

; 616       ColumnSize(&stWrite,(LONG)mp1,(LONG)mp2,TRUE);
; 617       break;
	push	01h
	mov	eax,[ebp+014h];	mp2
	push	eax
	mov	eax,[ebp+010h];	mp1
	push	eax
	push	offset FLAT:stWrite
	call	ColumnSize
	add	esp,010h

; 618     case UM_TRACKFRAME:
	jmp	@BLBL129
	align 04h
@BLBL159:

; 619       ColumnSize(&stWrite,(LONG)mp1,(LONG)mp2,FALSE);
; 620       break;
	push	0h
	mov	eax,[ebp+014h];	mp2
	push	eax
	mov	eax,[ebp+010h];	mp1
	push	eax
	push	offset FLAT:stWrite
	call	ColumnSize
	add	esp,010h

; 621     case WM_ERASEBACKGROUND:
	jmp	@BLBL129
	align 04h
@BLBL160:

; 622       return (MRESULT)(TRUE);
; 623     case WM_CLOSE:
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL161:

; 624       WinPostMsg(hwnd,WM_QUIT,0L,0L);
; 625     default:
	push	0h
	push	0h
	push	02ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h
@BLBL162:

; 626       return WinDefWindowProc(hwnd,msg,mp1,mp2);
; 627     }
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefWindowProc
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL129
	align 04h
@BLBL130:
	cmp	eax,07ah
	je	@BLBL131
	cmp	eax,01h
	je	@BLBL132
	cmp	eax,0dh
	je	@BLBL133
	cmp	eax,031h
	je	@BLBL134
	cmp	eax,020h
	je	@BLBL142
	cmp	eax,074h
	je	@BLBL151
	cmp	eax,071h
	je	@BLBL152
	cmp	eax,02h
	je	@BLBL153
	cmp	eax,0800fh
	je	@BLBL154
	cmp	eax,08010h
	je	@BLBL155
	cmp	eax,08011h
	je	@BLBL156
	cmp	eax,023h
	je	@BLBL157
	cmp	eax,08013h
	je	@BLBL158
	cmp	eax,08012h
	je	@BLBL159
	cmp	eax,04fh
	je	@BLBL160
	cmp	eax,029h
	je	@BLBL161
	jmp	@BLBL162
	align 04h
@BLBL129:

; 628   return(FALSE);
; 629   }
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
fnwpWriteColumnClient	endp

; 633 
	align 010h

	public TrackChildWindow
TrackChildWindow	proc
	push	ebp
	mov	ebp,esp

; 635 
	push	dword ptr [ebp+010h];	prcl
	push	offset FLAT:stColTrack+018h
	push	dword ptr [ebp+08h];	hab
	call	WinCopyRect
	add	esp,0ch

; 636   WinQueryWindowRect(hwndClient,&stColTrack.rclBoundary);
; 637 #ifdef this_junk
	push	offset FLAT:stColTrack+028h
	push	dword ptr  hwndClient
	call	WinQueryWindowRect
	add	esp,08h

; 638           stColTrack.cxBorder = 4;
; 639           stColTrack.cyBorder = 4;
; 640           stColTrack.cxGrid = stCell.cx;
; 641           stColTrack.cyGrid = stCell.cy;
; 642           stColTrack.cxKeyboard = stCell.cx;
; 643           stColTrack.cyKeyboard = stCell.cy;
; 644           stColTrack.ptlMinTrackSize.x = (stCell.cx * 4);
; 645           stColTrack.ptlMinTrackSize.y = (stCell.cy * 3);
; 646   stColTrack.ptlMaxTrackSize.x = (stCell.cx * (stRead.lCharWidth + stWrite.lCharWidth - 4));
; 647   stColTrack.ptlMaxTrackSize.y = (stCell.cy * stRead.lCharHeight);
; 648 #endif
; 649 
; 650   stColTrack.fs = (flMoveFrom | TF_ALLINBOUNDARY | TF_SETPOINTERPOS | TF_GRID);
; 651 
	mov	eax,[ebp+014h];	flMoveFrom
	or	al,0b0h
	mov	dword ptr  stColTrack+048h,eax

; 652   if (!WinTrackRect(hwnd,0L,&stColTrack))
; 653     return(FALSE);
	push	offset FLAT:stColTrack
	push	0h
	push	dword ptr [ebp+0ch];	hwnd
	call	WinTrackRect
	add	esp,0ch
	test	eax,eax
	jne	@BLBL163

; 654   WinCopyRect(hab,prcl,&stColTrack.rclTrack);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL163:

; 655   return(TRUE);
	push	offset FLAT:stColTrack+018h
	push	dword ptr [ebp+010h];	prcl
	push	dword ptr [ebp+08h];	hab
	call	WinCopyRect
	add	esp,0ch

; 656   }
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
TrackChildWindow	endp

; 660   HPS hps;
	align 010h

	public ColumnPaint
ColumnPaint	proc
	push	ebp
	mov	ebp,esp
	sub	esp,054h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,015h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 664   WORD wDirection;
	mov	dword ptr [ebp-01ch],0h;	bLastWasNewLine

; 665   LONG lReadIndex;
; 666   WORD wFilterMask;
; 667   BOOL bTestNewLine;
; 668   WORD wNewLine;
; 669   BOOL bWrap;
; 670   BOOL bSkip;
; 671   WORD wFunc;
; 672   LONG lPacketCount;
; 673   LONG lOldTop;
; 674 
; 675   DosRequestMutexSem(hmtxColGioBlockedSem,10000);
; 676   WinInvalidateRect(pstScreen->hwndClient,(PRECTL)NULL,FALSE);
	push	02710h
	push	dword ptr  hmtxColGioBlockedSem
	call	DosRequestMutexSem
	add	esp,08h

; 677   hps = WinBeginPaint(pstScreen->hwndClient,(HPS)NULL,&rclRect);
	push	0h
	push	0h
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+0fh]
	call	WinInvalidateRect
	add	esp,0ch

; 678   if (WinIsWindowShowing(pstScreen->hwndClient))
	lea	eax,[ebp-014h];	rclRect
	push	eax
	push	0h
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+0fh]
	call	WinBeginPaint
	add	esp,0ch
	mov	[ebp-04h],eax;	hps

; 679     {
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+0fh]
	call	WinIsWindowShowing
	add	esp,04h
	test	eax,eax
	je	@BLBL164

; 680     rclRect.yBottom = 0;
; 681     rclRect.yTop = (pstScreen->lHeight + stCell.cy);
	mov	dword ptr [ebp-010h],0h;	rclRect

; 682     rclRect.xLeft = 0;
	movsx	eax,word ptr  stCell+02h
	mov	ecx,[ebp+08h];	pstScreen
	add	eax,[ecx+02fh]
	mov	[ebp-08h],eax;	rclRect

; 683     rclRect.xRight = (pstScreen->lWidth + stCell.cx);
	mov	dword ptr [ebp-014h],0h;	rclRect

; 684     WinFillRect(hps,&rclRect,pstScreen->lBackgrndColor);
	movsx	eax,word ptr  stCell
	mov	ecx,[ebp+08h];	pstScreen
	add	eax,[ecx+033h]
	mov	[ebp-0ch],eax;	rclRect

; 685     if (pstScreen->wDirection == CS_WRITE)
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+037h]
	lea	eax,[ebp-014h];	rclRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 686       {
	mov	eax,[ebp+08h];	pstScreen
	cmp	word ptr [eax+05h],08000h
	jne	@BLBL165

; 687       if ((stRead.lBackgrndColor == stWrite.lBackgrndColor) && (stWrite.hwndScroll == (HWND)NULL))
; 688         {
	mov	eax,dword ptr  stWrite+037h
	cmp	dword ptr  stRead+037h,eax
	jne	@BLBL166
	cmp	dword ptr  stWrite+05fh,0h
	jne	@BLBL166

; 689         rclRect.xRight = stWrite.rcl.xRight;
; 690         rclRect.xLeft = stWrite.rcl.xRight - 1;
	mov	eax,dword ptr  stWrite+01bh
	mov	[ebp-0ch],eax;	rclRect

; 691         rclRect.yBottom = 0;
	mov	eax,dword ptr  stWrite+01bh
	dec	eax
	mov	[ebp-014h],eax;	rclRect

; 692         rclRect.yTop = stWrite.rcl.yTop;
	mov	dword ptr [ebp-010h],0h;	rclRect

; 693         if (stWrite.lBackgrndColor == CLR_WHITE)
	mov	eax,dword ptr  stWrite+01fh
	mov	[ebp-08h],eax;	rclRect

; 694           WinFillRect(hps,&rclRect,CLR_BLACK);
	cmp	dword ptr  stWrite+037h,0fffffffeh
	jne	@BLBL167

; 695         else
	push	0ffffffffh
	lea	eax,[ebp-014h];	rclRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch
	jmp	@BLBL168
	align 010h
@BLBL167:

; 696           WinFillRect(hps,&rclRect,(stWrite.lBackgrndColor ^ stWrite.lBackgrndColor));
; 697         stWrite.rclDisp.xRight = (stWrite.lWidth + stCell.cx - 1);
	mov	eax,dword ptr  stWrite+037h
	xor	eax,dword ptr  stWrite+037h
	push	eax
	lea	eax,[ebp-014h];	rclRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch
@BLBL168:

; 698         }
	movsx	eax,word ptr  stCell
	add	eax,dword ptr  stWrite+033h
	dec	eax
	mov	dword ptr  stWrite+047h,eax

; 699       else
	jmp	@BLBL165
	align 010h
@BLBL166:

; 700         stWrite.rclDisp.xRight = (stWrite.lWidth + stCell.cx);
; 701       }
	movsx	eax,word ptr  stCell
	add	eax,dword ptr  stWrite+033h
	mov	dword ptr  stWrite+047h,eax

; 702     if (stCFG.fDisplaying & (DISP_DATA | DISP_FILE))
@BLBL165:

; 703       {
	mov	al,byte ptr  stCFG+01bh
	and	eax,01fh
	shr	eax,02h
	test	al,06h
	je	@BLBL170

; 704       pstScreen->Pos.y = pstScreen->lHeight;
; 705       pstScreen->Pos.x = 0;
	mov	ecx,[ebp+08h];	pstScreen
	mov	ecx,[ecx+02fh]
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+053h],ecx

; 706       lReadIndex = pstScreen->lScrollIndex;
	mov	eax,[ebp+08h];	pstScreen
	mov	dword ptr [eax+04fh],0h

; 707       pstScreen->rclDisp.xLeft = 0L;
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+06fh]
	mov	[ebp-024h],eax;	lReadIndex

; 708       if (pstScreen->wDirection == CS_READ)
	mov	eax,[ebp+08h];	pstScreen
	mov	dword ptr [eax+03fh],0h

; 709         GpiCreateLogFont(hps,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wColReadFont]);
	mov	eax,[ebp+08h];	pstScreen
	cmp	word ptr [eax+05h],04000h
	jne	@BLBL171

; 710       else
	xor	eax,eax
	mov	ax,word ptr  stCFG+0dbh
	imul	eax,038h
	add	eax,offset FLAT:astFontAttributes
	push	eax
	push	02h
	push	offset FLAT:@STAT5
	push	dword ptr [ebp-04h];	hps
	call	GpiCreateLogFont
	add	esp,010h
	jmp	@BLBL172
	align 010h
@BLBL171:

; 711         GpiCreateLogFont(hps,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wColWriteFont]);
; 712       GpiSetCharSet(hps,2);
	xor	eax,eax
	mov	ax,word ptr  stCFG+0ddh
	imul	eax,038h
	add	eax,offset FLAT:astFontAttributes
	push	eax
	push	02h
	push	offset FLAT:@STAT6
	push	dword ptr [ebp-04h];	hps
	call	GpiCreateLogFont
	add	esp,010h
@BLBL172:

; 713       GpiSetColor(hps,pstScreen->lForegrndColor);
	push	02h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetCharSet
	add	esp,08h

; 714       if (pstScreen->bFilter)
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+03bh]
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 715         wFilterMask = (WORD)pstScreen->byDisplayMask;
	mov	eax,[ebp+08h];	pstScreen
	test	byte ptr [eax+02h],020h
	je	@BLBL173

; 716       else
	mov	ecx,[ebp+08h];	pstScreen
	xor	ax,ax
	mov	al,[ecx+04h]
	mov	[ebp-026h],ax;	wFilterMask
	jmp	@BLBL174
	align 010h
@BLBL173:

; 717         wFilterMask = 0x00ff;
; 718       wNewLine = (WORD)pstScreen->byNewLineChar;
	mov	word ptr [ebp-026h],0ffh;	wFilterMask
@BLBL174:

; 719       wDirection
; 719  = pstScreen->wDirection;
	mov	ecx,[ebp+08h];	pstScreen
	xor	ax,ax
	mov	al,[ecx+03h]
	mov	[ebp-02eh],ax;	wNewLine

; 720       bTestNewLine = pstScreen->bTestNewLine;
	mov	eax,[ebp+08h];	pstScreen
	mov	ax,[eax+05h]
	mov	[ebp-01eh],ax;	wDirection

; 721       bSkip = pstScreen->bSkipBlankLines;
	mov	eax,[ebp+08h];	pstScreen
	mov	al,[eax+02h]
	and	eax,03h
	shr	eax,01h
	mov	[ebp-02ch],eax;	bTestNewLine

; 722       bWrap = pstScreen->bWrap;
	mov	eax,[ebp+08h];	pstScreen
	mov	al,[eax+02h]
	and	eax,07h
	shr	eax,02h
	mov	[ebp-038h],eax;	bSkip

; 723       lPacketCount = 0;
	mov	eax,[ebp+08h];	pstScreen
	mov	al,[eax+02h]
	and	eax,0fh
	shr	eax,03h
	mov	[ebp-034h],eax;	bWrap

; 724       while (lReadIndex < lScrollCount)
	mov	dword ptr [ebp-040h],0h;	lPacketCount

; 725         {
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-024h],eax;	lReadIndex
	jge	@BLBL164
	align 010h
@BLBL176:

; 726         if (lPacketCount == 0)
; 727           {
	cmp	dword ptr [ebp-040h],0h;	lPacketCount
	jne	@BLBL177

; 728           wChar = pwScrollBuffer[lReadIndex];
; 729           wFunc = (pwScrollBuffer[lReadIndex++] & 0x0ff00);
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-024h];	lReadIndex
	mov	ax,word ptr [eax+ecx*02h]
	mov	[ebp-016h],ax;	wChar

; 730           switch (wFunc)
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-024h];	lReadIndex
	mov	ax,word ptr [eax+ecx*02h]
	and	ax,0ff00h
	mov	[ebp-03ah],ax;	wFunc
	mov	eax,[ebp-024h];	lReadIndex
	inc	eax
	mov	[ebp-024h],eax;	lReadIndex

; 731             {
	xor	eax,eax
	mov	ax,[ebp-03ah];	wFunc
	jmp	@BLBL198
	align 04h
@BLBL199:

; 732             case CS_PACKET_DATA:
; 733               lPacketCount = (wChar & 0x00ff);
; 734               break;
	xor	eax,eax
	mov	ax,[ebp-016h];	wChar
	and	eax,0ffh
	mov	[ebp-040h],eax;	lPacketCount

; 735             case CS_WRITE_IMM:
	jmp	@BLBL197
	align 04h
@BLBL200:

; 736               if (wFunc != CS_READ)
; 737                 wFunc = CS_WRITE;
	cmp	word ptr [ebp-03ah],04000h;	wFunc
	je	@BLBL178

; 738             case CS_READ_IMM:
	mov	word ptr [ebp-03ah],08000h;	wFunc
@BLBL178:
@BLBL201:

; 739               if (wFunc != CS_WRITE)
; 740                 wFunc = CS_READ;
	cmp	word ptr [ebp-03ah],08000h;	wFunc
	je	@BLBL179

; 741             case CS_WRITE:
	mov	word ptr [ebp-03ah],04000h;	wFunc
@BLBL179:
@BLBL202:
@BLBL203:

; 742             case CS_READ:
; 743               if (wFunc != wDirection)
; 744                 continue;
	mov	ax,[ebp-01eh];	wDirection
	cmp	[ebp-03ah],ax;	wFunc
	jne	@BLBL181

; 745               wChar &= wFilterMask;
; 746               if (bTestNewLine && (wChar == wNewLine))
	mov	ax,[ebp-026h];	wFilterMask
	and	ax,[ebp-016h];	wChar
	mov	[ebp-016h],ax;	wChar

; 747                 {
	cmp	dword ptr [ebp-02ch],0h;	bTestNewLine
	je	@BLBL182
	mov	ax,[ebp-02eh];	wNewLine
	cmp	[ebp-016h],ax;	wChar
	jne	@BLBL182

; 748                 if (bSkip && bLastWasNewLine)
; 749                   continue;
	cmp	dword ptr [ebp-038h],0h;	bSkip
	je	@BLBL183
	cmp	dword ptr [ebp-01ch],0h;	bLastWasNewLine
	jne	@BLBL181

; 750                 if (CharPrintable((BYTE *)&wChar,pstScreen))
@BLBL183:

; 751                   if (bWrap || (pstScreen->Pos.x <= pstScreen->lWidth))
	push	dword ptr [ebp+08h];	pstScreen
	lea	eax,[ebp-016h];	wChar
	push	eax
	call	CharPrintable
	add	esp,08h
	test	eax,eax
	je	@BLBL184

; 752                     GpiCharStringAt(hps,&pstScreen->Pos,1,(BYTE *)&wChar);
	cmp	dword ptr [ebp-034h],0h;	bWrap
	jne	@BLBL185
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ecx+033h]
	cmp	[eax+04fh],ecx
	jg	@BLBL184
@BLBL185:

; 753                 if (pstScreen->Pos.y <= 0)
	lea	eax,[ebp-016h];	wChar
	push	eax
	push	01h
	mov	eax,[ebp+08h];	pstScreen
	add	eax,04fh
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	GpiCharStringAt
	add	esp,010h
@BLBL184:

; 754                   break;
	mov	eax,[ebp+08h];	pstScreen
	cmp	dword ptr [eax+053h],0h
	jg	@BLBL187

; 755                 pstScreen->Pos.y -= stCell.cy;
	jmp	@BLBL197
	align 04h
@BLBL187:

; 756                 bLastWasNewLine = TRUE;
	mov	eax,[ebp+08h];	pstScreen
	mov	[ebp-054h],eax;	@CBE14
	mov	eax,[ebp-054h];	@CBE14
	mov	ecx,[eax+053h]
	movsx	edx,word ptr  stCell+02h
	sub	ecx,edx
	mov	[eax+053h],ecx

; 757                 pstScreen->Pos.x = 0L;
	mov	dword ptr [ebp-01ch],01h;	bLastWasNewLine

; 758                 }
	mov	eax,[ebp+08h];	pstScreen
	mov	dword ptr [eax+04fh],0h

; 759               else
	jmp	@BLBL188
	align 010h
@BLBL182:

; 760                 {
; 761                 if (CharPrintable((BYTE *)&wChar,pstScreen))
; 762                   {
	push	dword ptr [ebp+08h];	pstScreen
	lea	eax,[ebp-016h];	wChar
	push	eax
	call	CharPrintable
	add	esp,08h
	test	eax,eax
	je	@BLBL188

; 763                   bLastWasNewLine = FALSE;
; 764                   if (pstScreen->Pos.x <= pstScreen->lWidth)
	mov	dword ptr [ebp-01ch],0h;	bLastWasNewLine

; 765                     {
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ecx+033h]
	cmp	[eax+04fh],ecx
	jg	@BLBL190

; 766                     GpiCharStringAt(hps,&pstScreen->Pos,1,(BYTE *)&wChar);
; 767                     pstScreen->Pos.x += stCell.cx;
	lea	eax,[ebp-016h];	wChar
	push	eax
	push	01h
	mov	eax,[ebp+08h];	pstScreen
	add	eax,04fh
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	GpiCharStringAt
	add	esp,010h

; 768                     }
	mov	eax,[ebp+08h];	pstScreen
	mov	[ebp-050h],eax;	@CBE13
	movsx	ecx,word ptr  stCell
	mov	eax,[ebp-050h];	@CBE13
	add	ecx,[eax+04fh]
	mov	[eax+04fh],ecx

; 769                   else
	jmp	@BLBL188
	align 010h
@BLBL190:

; 770                     {
; 771                     if (pstScreen->bWrap)
; 772                       {
	mov	eax,[ebp+08h];	pstScreen
	test	byte ptr [eax+02h],08h
	je	@BLBL192

; 773                       pstScreen->Pos.x  = 0;
; 774                       pstScreen->Pos.y -= stCell.cy;
	mov	eax,[ebp+08h];	pstScreen
	mov	dword ptr [eax+04fh],0h

; 775                       GpiCharStringAt(hps,&pstScreen->Pos,1,(BYTE *)&wChar);
	mov	eax,[ebp+08h];	pstScreen
	mov	[ebp-04ch],eax;	@CBE12
	mov	eax,[ebp-04ch];	@CBE12
	mov	ecx,[eax+053h]
	movsx	edx,word ptr  stCell+02h
	sub	ecx,edx
	mov	[eax+053h],ecx

; 776                       pstScreen->Pos.x += stCell.cx;
	lea	eax,[ebp-016h];	wChar
	push	eax
	push	01h
	mov	eax,[ebp+08h];	pstScreen
	add	eax,04fh
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	GpiCharStringAt
	add	esp,010h

; 777                       }
	mov	eax,[ebp+08h];	pstScreen
	mov	[ebp-048h],eax;	@CBE11
	movsx	ecx,word ptr  stCell
	mov	eax,[ebp-048h];	@CBE11
	add	ecx,[eax+04fh]
	mov	[eax+04fh],ecx

; 778                     if (pstScreen->Pos.y < 0 )
@BLBL192:

; 779                       break;
	mov	eax,[ebp+08h];	pstScreen
	cmp	dword ptr [eax+053h],0h
	jge	@BLBL188

; 780                     }
	jmp	@BLBL197
	align 04h
@BLBL188:

; 781                   }
; 782                 }
; 783             }
; 784           }
	jmp	@BLBL197
	align 04h
@BLBL198:
	cmp	eax,0ff00h
	je	@BLBL199
	cmp	eax,08100h
	je	@BLBL200
	cmp	eax,04100h
	je	@BLBL201
	cmp	eax,08000h
	je	@BLBL202
	cmp	eax,04000h
	je	@BLBL203
@BLBL197:

; 785         else
	jmp	@BLBL181
	align 010h
@BLBL177:

; 786           {
; 787           lPacketCount--;
; 788           lReadIndex++;
	mov	eax,[ebp-040h];	lPacketCount
	dec	eax
	mov	[ebp-040h],eax;	lPacketCount

; 789           }
	mov	eax,[ebp-024h];	lReadIndex
	inc	eax
	mov	[ebp-024h],eax;	lReadIndex

; 790         }

; 791       }
@BLBL181:

; 725       while (lReadIndex < lScrollCount)
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-024h],eax;	lReadIndex
	jl	@BLBL176

; 792       }
	jmp	@BLBL164
	align 010h
@BLBL170:

; 796       pstScreen->Pos.y = pstScreen->lHeight;
	mov	ecx,[ebp+08h];	pstScreen
	mov	ecx,[ecx+02fh]
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+053h],ecx

; 797       pstScreen->Pos.x = 0L;
	mov	eax,[ebp+08h];	pstScreen
	mov	dword ptr [eax+04fh],0h

; 798       }

; 799     }
@BLBL164:

; 800   WinEndPaint(hps);
	push	dword ptr [ebp-04h];	hps
	call	WinEndPaint
	add	esp,04h

; 801   DosReleaseMutexSem(hmtxColGioBlockedSem);
	push	dword ptr  hmtxColGioBlockedSem
	call	DosReleaseMutexSem
	add	esp,04h

; 803   }
	mov	esp,ebp
	pop	ebp
	ret	
ColumnPaint	endp

; 806   {
	align 010h

	public ColumnSize
ColumnSize	proc
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

; 811   BOOL bResetScrollBar = FALSE;
	mov	dword ptr [ebp-06ch],0h;	bResetScrollBar

; 812 
; 813   if (pstScreen->hwndScroll != (HWND)NULL)
	mov	eax,[ebp+08h];	pstScreen
	cmp	dword ptr [eax+05fh],0h
	je	@BLBL204

; 814     {
; 815     ClearColScrollBar(pstScreen);
	push	dword ptr [ebp+08h];	pstScreen
	call	ClearColScrollBar
	add	esp,04h

; 816     bResetScrollBar = TRUE;
	mov	dword ptr [ebp-06ch],01h;	bResetScrollBar

; 817     }
@BLBL204:

; 818   if ((rc = DosRequestMutexSem(hmtxColGioBlockedSem,10000)) != NO_ERROR)
	push	02710h
	push	dword ptr  hmtxColGioBlockedSem
	call	DosRequestMutexSem
	add	esp,08h
	mov	[ebp-04h],eax;	rc
	cmp	dword ptr [ebp-04h],0h;	rc
	je	@BLBL205

; 819     {
; 820     sprintf(szMessage,"DosRequestMutexSem error in ColumnSize: return code = %ld", rc);
	push	dword ptr [ebp-04h];	rc
	mov	edx,offset FLAT:@STAT7
	lea	eax,[ebp-054h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 821     ErrorNotify(szMessage);
	lea	eax,[ebp-054h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 822     }
@BLBL205:

; 823 
; 824   if (bTrackSibling)
	cmp	dword ptr [ebp+014h],0h;	bTrackSibling
	je	@BLBL206

; 825     {
; 826     if (lReadEdge != 0L)
	cmp	dword ptr [ebp+0ch],0h;	lReadEdge
	je	@BLBL207

; 827       pstScreen->rcl.xLeft = lReadEdge;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp+0ch];	lReadEdge
	mov	[eax+013h],ecx
	jmp	@BLBL210
	align 010h
@BLBL207:

; 828     else
; 829       if (lWriteEdge != 0L)
	cmp	dword ptr [ebp+010h],0h;	lWriteEdge
	je	@BLBL210

; 830         pstScreen->rcl.xRight = lWriteEdge;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp+010h];	lWriteEdge
	mov	[eax+01bh],ecx

; 831     }
	jmp	@BLBL210
	align 010h
@BLBL206:

; 832   else
; 833     {
; 834     WinQueryWindowRect(hwndClient,&rclClient);
	lea	eax,[ebp-064h];	rclClient
	push	eax
	push	dword ptr  hwndClient
	call	WinQueryWindowRect
	add	esp,08h

; 835 
; 836     if (stCFG.fLockWidth == LOCK_NONE)
	test	byte ptr  stCFG+01bh,03h
	jne	@BLBL211

; 837       {
; 838       if ((rclClient.xRight / 2) % stCell.cx)
	mov	eax,[ebp-05ch];	rclClient
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	movsx	ecx,word ptr  stCell
	cdq	
	idiv	ecx
	test	edx,edx
	je	@BLBL212

; 839         bOddScreen = TRUE;
	mov	dword ptr [ebp-068h],01h;	bOddScreen
	jmp	@BLBL213
	align 010h
@BLBL212:

; 840       else
; 841         bOddScreen = FALSE;
	mov	dword ptr [ebp-068h],0h;	bOddScreen
@BLBL213:

; 842 
; 843       if (pstScreen->wDirection == CS_WRITE)
	mov	eax,[ebp+08h];	pstScreen
	cmp	word ptr [eax+05h],08000h
	jne	@BLBL214

; 844         {
; 845         if (bOddScreen)
	cmp	dword ptr [ebp-068h],0h;	bOddScreen
	je	@BLBL215

; 846           rclClient.xRight -= stCell.cx;
	movsx	ecx,word ptr  stCell
	mov	eax,[ebp-05ch];	rclClient
	sub	eax,ecx
	mov	[ebp-05ch],eax;	rclClient
@BLBL215:

; 847         pstScreen->rcl.xRight = (rclClient.xRight / 2);
	mov	eax,[ebp-05ch];	rclClient
	cdq	
	mov	ecx,eax
	and	edx,01h
	add	ecx,edx
	sar	ecx,01h
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+01bh],ecx

; 848         pstScreen->rcl.xLeft = rclClient.xLeft;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-064h];	rclClient
	mov	[eax+013h],ecx

; 849         }
	jmp	@BLBL218
	align 010h
@BLBL214:

; 850       else
; 851         {
; 852         pstScreen->rcl.xRight = rclClient.xRight;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-05ch];	rclClient
	mov	[eax+01bh],ecx

; 853         pstScreen->rcl.xLeft = (rclClient.xRight / 2);
	mov	eax,[ebp-05ch];	rclClient
	cdq	
	mov	ecx,eax
	and	edx,01h
	add	ecx,edx
	sar	ecx,01h
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+013h],ecx

; 854         if (bOddScreen)
	cmp	dword ptr [ebp-068h],0h;	bOddScreen
	je	@BLBL218

; 855           pstScreen->rcl.xLeft -= (stCell.cx / 2);
	mov	eax,[ebp+08h];	pstScreen
	mov	[ebp-070h],eax;	@CBE15
	movsx	eax,word ptr  stCell
	cdq	
	xchg	edx,eax
	and	eax,01h
	add	edx,eax
	sar	edx,01h
	mov	eax,[ebp-070h];	@CBE15
	mov	ecx,[eax+013h]
	sub	ecx,edx
	mov	[eax+013h],ecx

; 856         }

; 857       }
	jmp	@BLBL218
	align 010h
@BLBL211:

; 858     else
; 859       {
; 860       if (pstScreen->wDirection == CS_WRITE)
	mov	eax,[ebp+08h];	pstScreen
	cmp	word ptr [eax+05h],08000h
	jne	@BLBL219

; 861         if (stCFG.fLockWidth == LOCK_WRITE)
	mov	al,byte ptr  stCFG+01bh
	and	eax,03h
	cmp	eax,02h
	jne	@BLBL220

; 862           pstScreen->rcl.xRight = (stCFG.lLockWidth * stCell.cx);
	movsx	ecx,word ptr  stCell
	imul	ecx,dword ptr  stCFG+031h
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+01bh],ecx
	jmp	@BLBL218
	align 010h
@BLBL220:

; 863         else
; 864           pstScreen->rcl.xRight = (rclClient.xRight - (stCFG.lLockWidth * stCell.cx));
	movsx	eax,word ptr  stCell
	imul	eax,dword ptr  stCFG+031h
	mov	ecx,[ebp-05ch];	rclClient
	sub	ecx,eax
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+01bh],ecx
	jmp	@BLBL218
	align 010h
@BLBL219:

; 865       else
; 866         {
; 867         if (stCFG.fLockWidth == LOCK_WRITE)
	mov	al,byte ptr  stCFG+01bh
	and	eax,03h
	cmp	eax,02h
	jne	@BLBL223

; 868           pstScreen->rcl.xLeft = (stCFG.lLockWidth * stCell.cx);
	movsx	ecx,word ptr  stCell
	imul	ecx,dword ptr  stCFG+031h
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+013h],ecx
	jmp	@BLBL224
	align 010h
@BLBL223:

; 869         else
; 870           pstScreen->rcl.xLeft = (rclClient.xRight - (stCFG.lLockWidth * stCell.cx));
	movsx	eax,word ptr  stCell
	imul	eax,dword ptr  stCFG+031h
	mov	ecx,[ebp-05ch];	rclClient
	sub	ecx,eax
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+013h],ecx
@BLBL224:

; 871         pstScreen->rcl.xRight = rclClient.xRight;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-05ch];	rclClient
	mov	[eax+01bh],ecx

; 872         }

; 873       }
@BLBL218:

; 874     pstScreen->rcl.yBottom = (rclClient.yBottom + lStatusHeight);
	mov	ecx,dword ptr  lStatusHeight
	add	ecx,[ebp-060h];	rclClient
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+017h],ecx

; 875     pstScreen->rcl.yTop = rclClient.yTop;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-058h];	rclClient
	mov	[eax+01fh],ecx

; 876     pstScreen->lHeight = (pstScreen->rcl.yTop - pstScreen->rcl.yBottom - stCell.cy);
	mov	ecx,[ebp+08h];	pstScreen
	mov	ecx,[ecx+01fh]
	mov	eax,[ebp+08h];	pstScreen
	sub	ecx,[eax+017h]
	movsx	eax,word ptr  stCell+02h
	sub	ecx,eax
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+02fh],ecx

; 877     pstScreen->lCharHeight = ((pstScreen->lHeight / stCell.cy) + 1);
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+02fh]
	movsx	ecx,word ptr  stCell+02h
	cdq	
	idiv	ecx
	mov	ecx,eax
	inc	ecx
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+02bh],ecx

; 878     stColTrack.ptlMaxTrackSize.y = (stCell.cy * pstScreen->lCharHeight);
	mov	ecx,[ebp+08h];	pstScreen
	movsx	eax,word ptr  stCell+02h
	imul	eax,[ecx+02bh]
	mov	dword ptr  stColTrack+044h,eax

; 879 //    SetColScrollRowCount(pstScreen);
; 880     }
@BLBL210:

; 881   pstScreen->lWidth = (pstScreen->rcl.xRight - pstScreen->rcl.xLeft - stCell.cx);
	mov	ecx,[ebp+08h];	pstScreen
	mov	ecx,[ecx+01bh]
	mov	eax,[ebp+08h];	pstScreen
	sub	ecx,[eax+013h]
	movsx	eax,word ptr  stCell
	sub	ecx,eax
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+033h],ecx

; 882   pstScreen->lCharWidth = ((pstScreen->lWidth  / stCell.cx) + 1);
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+033h]
	movsx	ecx,word ptr  stCell
	cdq	
	idiv	ecx
	mov	ecx,eax
	inc	ecx
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+027h],ecx

; 883   pstScreen->lCharSize = (pstScreen->lCharWidth * pstScreen->lCharHeight);
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ecx+02bh]
	imul	ecx,[eax+027h]
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+023h],ecx

; 884   pstScreen->rclDisp.xRight = (pstScreen->lWidth + stCell.cx);
	movsx	ecx,word ptr  stCell
	mov	eax,[ebp+08h];	pstScreen
	add	ecx,[eax+033h]
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+047h],ecx

; 885   stColTrack.ptlMaxTrackSize.x = (stCell.cx * (stRead.lCharWidth + stWrite.lCharWidth - 6));
	mov	ecx,dword ptr  stWrite+027h
	add	ecx,dword ptr  stRead+027h
	sub	ecx,06h
	movsx	eax,word ptr  stCell
	imul	eax,ecx
	mov	dword ptr  stColTrack+040h,eax

; 886 
; 887   WinSetWindowPos(pstScreen->hwnd,
	push	03h
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+01fh]
	mov	ecx,[ebp+08h];	pstScreen
	sub	eax,[ecx+017h]
	push	eax
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+01bh]
	mov	ecx,[ebp+08h];	pstScreen
	sub	eax,[ecx+013h]
	push	eax
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+017h]
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+013h]
	push	0h
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+0bh]
	call	WinSetWindowPos
	add	esp,01ch

; 888                  0L,
; 889                  pstScreen->rcl.xLeft,
; 890                  pstScreen->rcl.yBottom,
; 891                 (pstScreen->rcl.xRight - pstScreen->rcl.xLeft),
; 892                 (pstScreen->rcl.yTop - pstScreen->rcl.yBottom),
; 893                 (SWP_MOVE | SWP_SIZE));
; 894 
; 895   if ((rc = DosReleaseMutexSem(hmtxColGioBlockedSem)) != NO_ERROR)
	push	dword ptr  hmtxColGioBlockedSem
	call	DosReleaseMutexSem
	add	esp,04h
	mov	[ebp-04h],eax;	rc
	cmp	dword ptr [ebp-04h],0h;	rc
	je	@BLBL225

; 896     {
; 897     sprintf(szMessage,"DosReleaseMutexSem error in ColumnSize: return code = %ld", rc);
	push	dword ptr [ebp-04h];	rc
	mov	edx,offset FLAT:@STAT8
	lea	eax,[ebp-054h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 898     ErrorNotify(szMessage);
	lea	eax,[ebp-054h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 899     }
@BLBL225:

; 900   if (bResetScrollBar)
	cmp	dword ptr [ebp-06ch],0h;	bResetScrollBar
	je	@BLBL226

; 901     SetupColScrolling(pstScreen);
	push	dword ptr [ebp+08h];	pstScreen
	call	SetupColScrolling
	add	esp,04h
@BLBL226:

; 902   WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 903   }
	mov	esp,ebp
	pop	ebp
	ret	
ColumnSize	endp

; 906   {
	align 010h

	public CreateColumnWindows
CreateColumnWindows	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 909   flCreateFlags = (FCF_NOBYTEALIGN);
	mov	dword ptr [ebp-04h],01000h;	flCreateFlags

; 910 
; 911   stWrite.hwnd = WinCreateStdWindow(hwndClient,
	push	offset FLAT:stWrite+0fh
	push	07d0h
	push	0h
	push	01c000000h
	push	0h
	push	offset FLAT:@STAT9
	lea	eax,[ebp-04h];	flCreateFlags
	push	eax
	push	0h
	push	dword ptr  hwndClient
	call	WinCreateStdWindow
	add	esp,024h
	mov	dword ptr  stWrite+0bh,eax

; 912                                     0L,
; 913 //                                   (WS_CLIPSIBLINGS | WS_PARENTCLIP | WS_SAVEBITS),
; 914                                    &flCreateFlags,
; 915                                    "WRITE COLUMN",
; 916                                     NULL,
; 917 //                                    0L,
; 918                                    (WS_CLIPSIBLINGS | WS_PARENTCLIP | WS_SAVEBITS),
; 919                            (HMODULE)NULL,
; 920                                     IDM_COMSCOPE,
; 921                            (HWND *)&stWrite.hwndClient);
; 922 
; 923   stRead.hwnd = WinCreateStdWindow(hwndClient,
	push	offset FLAT:stRead+0fh
	push	07d0h
	push	0h
	push	01c000000h
	push	0h
	push	offset FLAT:@STATa
	lea	eax,[ebp-04h];	flCreateFlags
	push	eax
	push	0h
	push	dword ptr  hwndClient
	call	WinCreateStdWindow
	add	esp,024h
	mov	dword ptr  stRead+0bh,eax

; 924                                    0L,
; 925 //                                  (WS_CLIPSIBLINGS | WS_PARENTCLIP | WS_SAVEBITS),
; 926                                   &flCreateFlags,
; 927                                   "READ COLUMN",
; 928                                    NULL,
; 929 //                                   0L,
; 930                                   (WS_CLIPSIBLINGS | WS_PARENTCLIP | WS_SAVEBITS),
; 931                           (HMODULE)NULL,
; 932                                    IDM_COMSCOPE,
; 933                           (HWND *)&stRead.hwndClient);
; 934 
; 935   }
	mov	esp,ebp
	pop	ebp
	ret	
CreateColumnWindows	endp

; 938   {
	align 010h

	public CharPrintable
CharPrintable	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 939   if (!pstScreen->bFilter)
	mov	eax,[ebp+0ch];	pstScreen
	test	byte ptr [eax+02h],020h
	jne	@BLBL227

; 940     return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL227:

; 941   *pbyChar &= pstScreen->byDisplayMask;
	mov	eax,[ebp+08h];	pbyChar
	mov	[ebp-04h],eax;	@CBE16
	mov	ecx,[ebp+0ch];	pstScreen
	mov	eax,[ebp-04h];	@CBE16
	mov	cl,[ecx+04h]
	and	cl,[eax]
	mov	[eax],cl

; 942   switch (pstScreen->fFilterMask)
	mov	eax,[ebp+0ch];	pstScreen
	mov	eax,[eax+07h]
	jmp	@BLBL267
	align 04h
@BLBL268:

; 943     {
; 944     case FILTER_NPRINT:
; 945       if (!isprint(*pbyChar))
	mov	ecx,dword ptr  _ctype
	mov	eax,[ebp+08h];	pbyChar
	xor	edx,edx
	mov	dl,[eax]
	xor	eax,eax
	mov	ax,word ptr [ecx+edx*02h]
	and	eax,0400h
	test	eax,eax
	jne	@BLBL228

; 946         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL228:

; 947       break;
	jmp	@BLBL266
	align 04h
@BLBL269:

; 948     case FILTER_ALPHA:
; 949       if (isalpha(*pbyChar))
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h+01h],01h
	je	@BLBL229

; 950         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL229:

; 951       break;
	jmp	@BLBL266
	align 04h
@BLBL270:

; 952     case (FILTER_ALPHA | FILTER_NPRINT):
; 953       if (!isprint(*pbyChar) || isalpha(*pbyChar))
	mov	ecx,dword ptr  _ctype
	mov	eax,[ebp+08h];	pbyChar
	xor	edx,edx
	mov	dl,[eax]
	xor	eax,eax
	mov	ax,word ptr [ecx+edx*02h]
	and	eax,0400h
	test	eax,eax
	je	@BLBL230
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h+01h],01h
	je	@BLBL231
@BLBL230:

; 954         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL231:

; 955       break;
	jmp	@BLBL266
	align 04h
@BLBL271:

; 956     case FILTER_NUMS:
; 957       if (isdigit(*pbyChar))
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],02h
	je	@BLBL232

; 958         return(FALSE);
; 958 
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL232:

; 959       break;
	jmp	@BLBL266
	align 04h
@BLBL272:

; 960     case (FILTER_NUMS | FILTER_NPRINT):
; 961       if (!isprint(*pbyChar) || isdigit(*pbyChar))
	mov	ecx,dword ptr  _ctype
	mov	eax,[ebp+08h];	pbyChar
	xor	edx,edx
	mov	dl,[eax]
	xor	eax,eax
	mov	ax,word ptr [ecx+edx*02h]
	and	eax,0400h
	test	eax,eax
	je	@BLBL233
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],02h
	je	@BLBL234
@BLBL233:

; 962         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL234:

; 963       break;
	jmp	@BLBL266
	align 04h
@BLBL273:

; 964     case (FILTER_NUMS | FILTER_ALPHA):
; 965       if (isdigit(*pbyChar) || isalpha(*pbyChar))
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],02h
	jne	@BLBL235
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h+01h],01h
	je	@BLBL236
@BLBL235:

; 966         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL236:

; 967       break;
	jmp	@BLBL266
	align 04h
@BLBL274:

; 968     case (FILTER_NUMS | FILTER_ALPHA | FILTER_NPRINT):
; 969       if (!isprint(*pbyChar) || isdigit(*pbyChar) || isalpha(*pbyChar))
	mov	ecx,dword ptr  _ctype
	mov	eax,[ebp+08h];	pbyChar
	xor	edx,edx
	mov	dl,[eax]
	xor	eax,eax
	mov	ax,word ptr [ecx+edx*02h]
	and	eax,0400h
	test	eax,eax
	je	@BLBL239
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],02h
	jne	@BLBL239
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h+01h],01h
	je	@BLBL240
@BLBL239:

; 970         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL240:

; 971       break;
	jmp	@BLBL266
	align 04h
@BLBL275:

; 972     case FILTER_PUNCT:
; 973       if (ispunct(*pbyChar))
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],010h
	je	@BLBL241

; 974         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL241:

; 975       break;
	jmp	@BLBL266
	align 04h
@BLBL276:

; 976     case (FILTER_PUNCT | FILTER_NPRINT):
; 977       if (!isprint(*pbyChar) || ispunct(*pbyChar))
	mov	ecx,dword ptr  _ctype
	mov	eax,[ebp+08h];	pbyChar
	xor	edx,edx
	mov	dl,[eax]
	xor	eax,eax
	mov	ax,word ptr [ecx+edx*02h]
	and	eax,0400h
	test	eax,eax
	je	@BLBL242
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],010h
	je	@BLBL243
@BLBL242:

; 978         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL243:

; 979       break;
	jmp	@BLBL266
	align 04h
@BLBL277:

; 980     case (FILTER_PUNCT | FILTER_ALPHA):
; 981       if (ispunct(*pbyChar) || isalpha(*pbyChar))
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],010h
	jne	@BLBL244
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h+01h],01h
	je	@BLBL245
@BLBL244:

; 982         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL245:

; 983       break;
	jmp	@BLBL266
	align 04h
@BLBL278:

; 984     case (FILTER_PUNCT | FILTER_ALPHA | FILTER_NPRINT):
; 985       if (!isprint(*pbyChar) || isalpha(*pbyChar) || ispunct(*pbyChar))
	mov	ecx,dword ptr  _ctype
	mov	eax,[ebp+08h];	pbyChar
	xor	edx,edx
	mov	dl,[eax]
	xor	eax,eax
	mov	ax,word ptr [ecx+edx*02h]
	and	eax,0400h
	test	eax,eax
	je	@BLBL248
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h+01h],01h
	jne	@BLBL248
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],010h
	je	@BLBL249
@BLBL248:

; 986         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL249:

; 987       break;
	jmp	@BLBL266
	align 04h
@BLBL279:

; 988     case (FILTER_PUNCT | FILTER_NUMS):
; 989       if (ispunct(*pbyChar) || isdigit(*pbyChar))
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],010h
	jne	@BLBL250
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],02h
	je	@BLBL251
@BLBL250:

; 990         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL251:

; 991       break;
	jmp	@BLBL266
	align 04h
@BLBL280:

; 992     case (FILTER_PUNCT | FILTER_NUMS | FILTER_NPRINT):
; 993       if (!isprint(*pbyChar) || ispunct(*pbyChar) || isdigit(*pbyChar))
	mov	ecx,dword ptr  _ctype
	mov	eax,[ebp+08h];	pbyChar
	xor	edx,edx
	mov	dl,[eax]
	xor	eax,eax
	mov	ax,word ptr [ecx+edx*02h]
	and	eax,0400h
	test	eax,eax
	je	@BLBL254
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],010h
	jne	@BLBL254
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],02h
	je	@BLBL255
@BLBL254:

; 994         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL255:

; 995       break;
	jmp	@BLBL266
	align 04h
@BLBL281:

; 996     case (FILTER_PUNCT | FILTER_NUMS | FILTER_ALPHA):
; 997       if (ispunct(*pbyChar) || isalpha(*pbyChar) || isdigit(*pbyChar))
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],010h
	jne	@BLBL258
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h+01h],01h
	jne	@BLBL258
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],02h
	je	@BLBL259
@BLBL258:

; 998         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL259:

; 999       break;
	jmp	@BLBL266
	align 04h
@BLBL282:

; 1000     case (FILTER_NPRINT | FILTER_ALPHA | FILTER_PUNCT | FILTER_NUMS):
; 1001       if (!isprint(*pbyChar) || ispunct(*pbyChar) || isalpha(*pbyChar) || isdigit(*pbyChar))
	mov	ecx,dword ptr  _ctype
	mov	eax,[ebp+08h];	pbyChar
	xor	edx,edx
	mov	dl,[eax]
	xor	eax,eax
	mov	ax,word ptr [ecx+edx*02h]
	and	eax,0400h
	test	eax,eax
	je	@BLBL264
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],010h
	jne	@BLBL264
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h+01h],01h
	jne	@BLBL264
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	pbyChar
	xor	ecx,ecx
	mov	cl,[edx]
	test	byte ptr [eax+ecx*02h],02h
	je	@BLBL265
@BLBL264:

; 1002         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL265:

; 1003       break;
	jmp	@BLBL266
	align 04h
	jmp	@BLBL266
	align 04h
@BLBL267:
	cmp	eax,01h
	je	@BLBL268
	cmp	eax,02h
	je	@BLBL269
	cmp	eax,03h
	je	@BLBL270
	cmp	eax,04h
	je	@BLBL271
	cmp	eax,05h
	je	@BLBL272
	cmp	eax,06h
	je	@BLBL273
	cmp	eax,07h
	je	@BLBL274
	cmp	eax,08h
	je	@BLBL275
	cmp	eax,09h
	je	@BLBL276
	cmp	eax,0ah
	je	@BLBL277
	cmp	eax,0bh
	je	@BLBL278
	cmp	eax,0ch
	je	@BLBL279
	cmp	eax,0dh
	je	@BLBL280
	cmp	eax,0eh
	je	@BLBL281
	cmp	eax,0fh
	je	@BLBL282
@BLBL266:

; 1004     }
; 1005   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
CharPrintable	endp
CODE32	ends
end
