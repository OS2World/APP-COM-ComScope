	title	p:\COMscope\stat_dlg.c
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
	public	szOn
	public	szOff
	public	lStatusWindowCount
	extrn	WinWindowFromID:proc
	extrn	WinSendMsg:proc
	extrn	WinSetWindowText:proc
	extrn	_sprintfieee:proc
	extrn	WinSetDlgItemText:proc
	extrn	WinShowWindow:proc
	extrn	WinSetFocus:proc
	extrn	WinStartTimer:proc
	extrn	WinStopTimer:proc
	extrn	WinDismissDlg:proc
	extrn	WinQueryDlgItemText:proc
	extrn	atol:proc
	extrn	DisplayHelpPanel:proc
	extrn	WinDefDlgProc:proc
	extrn	CheckButton:proc
	extrn	GetCOMevent:proc
	extrn	WinPostMsg:proc
	extrn	GetCOMerror:proc
	extrn	WinSendDlgItemMsg:proc
	extrn	CenterDlgBox:proc
	extrn	MenuItemEnable:proc
	extrn	WinSetWindowPos:proc
	extrn	MousePosDlgBox:proc
	extrn	ASCIItoBin:proc
	extrn	WinDlgBox:proc
	extrn	EnableCOMscope:proc
	extrn	ResetHighWater:proc
	extrn	GetTransmitQueueLen:proc
	extrn	_ltoa:proc
	extrn	GetReceiveQueueCounts:proc
	extrn	GetReceiveQueueLen:proc
	extrn	GetCOMstatus:proc
	extrn	GetNoClearComEvent_ComError:proc
	extrn	GetXmitStatus:proc
	extrn	GetModemOutputSignals:proc
	extrn	strcpy:proc
	extrn	GetModemInputSignals:proc
	extrn	_fullDump:dword
	extrn	stCFG:byte
	extrn	habAnchorBlock:dword
	extrn	stIOctl:byte
	extrn	hCom:dword
	extrn	hwndStatAll:dword
	extrn	hwndStatDev:dword
	extrn	bDDstatusActivated:dword
	extrn	hwndFrame:dword
	extrn	hProfileInstance:dword
	extrn	hwndStatus:dword
	extrn	hwndStatRcvBuf:dword
	extrn	hwndStatXmitBuf:dword
	extrn	hwndStatModemIn:dword
	extrn	hwndStatModemOut:dword
	extrn	bTBstatusActivated:dword
	extrn	bRBstatusActivated:dword
	extrn	bCOMscopeEnabled:dword
	extrn	ulCOMscopeBufferSize:dword
	extrn	bMIstatusActivated:dword
	extrn	bMOstatusActivated:dword
DATA32	segment
@STAT1	db "%u",0h
	align 04h
@STAT2	db "%s - Device Driver Statu"
db "s",0h
@STAT3	db "%u",0h
	align 04h
@STAT4	db "%s - Transmit Buffer",0h
	align 04h
@STAT5	db "%s - Receive Buffer",0h
@STAT6	db "%s - Modem In",0h
	align 04h
@STAT7	db "%s - Modem Out",0h
	align 04h
@STAT8	db "%02X",0h
	align 04h
@STAT9	db "%04X",0h
	align 04h
@STATa	db "%04X",0h
	align 04h
@STATb	db "%02X",0h
szOn	db "On",0h
szOff	db "Off",0h
DATA32	ends
BSS32	segment
lStatusWindowCount	dd 0h
@14idTimer	dd 0h
@16bShowAllActivated	dd 0h
@56idTimer	dd 0h
@59bShowingBits	dd 0h
@5asCurrentFocus	dw 0h
	align 04h
@7aidTimer	dd 0h
@87idTimer	dd 0h
@89sCurrentFocus	dw 0h
	align 04h
@99idTimer	dd 0h
@a3idTimer	dd 0h
BSS32	ends
CODE32	segment

; 53   {
	align 010h

	public SetSystemMenu
SetSystemMenu	proc
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

; 62   if ((hwndSysMenu = WinWindowFromID(hwnd,FID_SYSMENU)) != 0)
	push	08002h
	push	dword ptr [ebp+08h];	hwnd
	call	WinWindowFromID
	add	esp,08h
	mov	[ebp-04h],eax;	hwndSysMenu
	cmp	dword ptr [ebp-04h],0h;	hwndSysMenu
	je	@BLBL1

; 63     {
; 64     if (WinSendMsg( hwndSysMenu,
	lea	eax,[ebp-014h];	miTemp
	push	eax
	push	08007h
	push	0182h
	push	dword ptr [ebp-04h];	hwndSysMenu
	call	WinSendMsg
	add	esp,010h
	test	eax,eax
	je	@BLBL1

; 65                    MM_QUERYITEM,
; 66                    MPFROM2SHORT( SC_SYSMENU, FALSE ),
; 67                    MPFROMP( (PSZ)&miTemp )))
; 68       {
; 69       hwndSysMenu = miTemp.hwndSubMenu;
	mov	eax,[ebp-0ch];	miTemp
	mov	[ebp-04h],eax;	hwndSysMenu

; 70 
; 71       /*******************************************************************/
; 72       /* Remove all items from the system menu pull-down that are no     */
; 73       /* longer wanted.                                                  */
; 74       /*******************************************************************/
; 75       for (sItemIndex = 0,mresItemId = 0L;LONGFROMMP(mresItemId) != (LONG)MIT_ERROR;sItemIndex++)
	mov	word ptr [ebp-01ah],0h;	sItemIndex
	mov	dword ptr [ebp-018h],0h;	mresItemId
	cmp	dword ptr [ebp-018h],0ffffffffh;	mresItemId
	je	@BLBL1
	align 010h
@BLBL4:

; 76         {
; 77         mresItemId = WinSendMsg(hwndSysMenu,
	push	0h
	mov	ax,[ebp-01ah];	sItemIndex
	and	eax,0ffffh
	push	eax
	push	0190h
	push	dword ptr [ebp-04h];	hwndSysMenu
	call	WinSendMsg
	add	esp,010h
	mov	[ebp-018h],eax;	mresItemId

; 78                                 MM_ITEMIDFROMPOSITION,
; 79                                 MPFROMSHORT(sItemIndex),
; 80                                 NULL);
; 81         if (LONGFROMMP(mresItemId) != (LONG)MIT_ERROR &&
	cmp	dword ptr [ebp-018h],0ffffffffh;	mresItemId
	je	@BLBL5

; 82             SHORT1FROMMP(mresItemId) != SC_MOVE   &&
	mov	ax,[ebp-018h];	mresItemId
	cmp	ax,08001h
	je	@BLBL5

; 83             SHORT1FROMMP(mresItemId) != SC_CLOSE  &&
	mov	ax,[ebp-018h];	mresItemId
	cmp	ax,08004h
	je	@BLBL5

; 84             SHORT1FROMMP(mresItemId) != SC_TASKMANAGER)
	mov	ax,[ebp-018h];	mresItemId
	cmp	ax,08011h
	je	@BLBL5

; 85           {
; 86           WinSendMsg(hwndSysMenu,
	push	0h
	mov	ax,[ebp-018h];	mresItemId
	and	eax,0ffffh
	push	eax
	push	0181h
	push	dword ptr [ebp-04h];	hwndSysMenu
	call	WinSendMsg
	add	esp,010h

; 87                      MM_DELETEITEM,
; 88                      MPFROM2SHORT(SHORT1FROMMP(mresItemId),FALSE),
; 89                      NULL);
; 90           sItemIndex--;
	mov	ax,[ebp-01ah];	sItemIndex
	dec	ax
	mov	[ebp-01ah],ax;	sItemIndex

; 91           }
@BLBL5:

; 92         }

; 75       for (sItemIndex = 0,mresItemId = 0L;LONGFROMMP(mresItemId) != (LONG)MIT_ERROR;sItemIndex++)
	mov	ax,[ebp-01ah];	sItemIndex
	inc	ax
	mov	[ebp-01ah],ax;	sItemIndex
	cmp	dword ptr [ebp-018h],0ffffffffh;	mresItemId
	jne	@BLBL4

; 93       }

; 94     }
@BLBL1:

; 95   }
	mov	esp,ebp
	pop	ebp
	ret	
SetSystemMenu	endp

; 101   {
	align 010h

	public fnwpDeviceAllStatusDlg
fnwpDeviceAllStatusDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax
	sub	esp,04h

; 107   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL12
	align 04h
@BLBL13:

; 108     {
; 109     case WM_INITDLG:
; 110 //      SetSystemMenu(hwnd);
; 111 //      CenterDlgBox(hwnd);
; 112       bShowAllActivated = FALSE;
	mov	dword ptr  @16bShowAllActivated,0h

; 113       idTimer = 0L;
	mov	dword ptr  @14idTimer,0h

; 114       break;
	jmp	@BLBL11
	align 04h
@BLBL14:

; 115     case UM_INITLS:
; 116       if (!bShowAllActivated)
	cmp	dword ptr  @16bShowAllActivated,0h
	jne	@BLBL7

; 117         {
; 118         bShowAllActivated = TRUE;
	mov	dword ptr  @16bShowAllActivated,01h

; 119 //        MousePosDlgBox(hwnd);
; 120         WinSetWindowText(hwnd,stCFG.szPortName);
	push	offset FLAT:stCFG+02h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowText
	add	esp,08h

; 121         sprintf(szCount,"%u",stCFG.wUpdateDelay);
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	mov	edx,offset FLAT:@STAT1
	lea	eax,[ebp-0ah];	szCount
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 122         WinSetDlgItemText(hwnd,HWS_UPDATE,szCount);
	lea	eax,[ebp-0ah];	szCount
	push	eax
	push	0650h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 123         WinShowWindow(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinShowWindow
	add	esp,08h

; 124         WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h

; 125         }
@BLBL7:

; 126       UpdateDeviceStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateDeviceStatusDlg
	add	esp,04h

; 127       UpdateModemInputStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateModemInputStatusDlg
	add	esp,04h

; 128       UpdateModemOutputStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateModemOutputStatusDlg
	add	esp,04h

; 129       UpdateBufferStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateBufferStatusDlg
	add	esp,04h

; 130       idTimer = WinStartTimer(habAnchorBlock,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	push	07ffeh
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStartTimer
	add	esp,010h
	mov	dword ptr  @14idTimer,eax

; 131                               hwnd,
; 132                               TID_STATALL,
; 133                               stCFG.wUpdateDelay);
; 134       break;
	jmp	@BLBL11
	align 04h
@BLBL15:
@BLBL16:

; 135     case WM_CLOSE:
; 136     case UM_KILL_MONITOR:
; 137       if (idTimer != 0)
	cmp	dword ptr  @14idTimer,0h
	je	@BLBL8

; 138         {
; 139         WinStopTimer(habAnchorBlock,
	push	dword ptr  @14idTimer
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStopTimer
	add	esp,0ch

; 140                      hwnd,
; 141                      idTimer);
; 142         idTimer = 0L;
	mov	dword ptr  @14idTimer,0h

; 143         WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 144         }
@BLBL8:

; 145       bShowAllActivated = FALSE;
	mov	dword ptr  @16bShowAllActivated,0h

; 146       break;
	jmp	@BLBL11
	align 04h
@BLBL17:

; 147     case UM_RESETTIMER:
; 148       if (idTimer != 0L)
	cmp	dword ptr  @14idTimer,0h
	je	@BLBL9

; 149         idTimer = WinStartTimer(habAnchorBlock,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	push	dword ptr  @14idTimer
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStartTimer
	add	esp,010h
	mov	dword ptr  @14idTimer,eax
@BLBL9:

; 150                               hwnd,
; 151                               idTimer,
; 152                               stCFG.wUpdateDelay);
; 153       break;
	jmp	@BLBL11
	align 04h
@BLBL18:

; 154     case WM_TIMER:
; 155       UpdateDeviceStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateDeviceStatusDlg
	add	esp,04h

; 156       UpdateModemInputStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateModemInputStatusDlg
	add	esp,04h

; 157       UpdateModemOutputStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateModemOutputStatusDlg
	add	esp,04h

; 158       UpdateBufferStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateBufferStatusDlg
	add	esp,04h

; 159       return(FALSE);
	xor	eax,eax
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL19:

; 160     case WM_COMMAND:
; 161       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL21
	align 04h
@BLBL22:

; 162         {
; 163         case DID_UPDATE:
; 164           WinQueryDlgItemText(hwnd,HWS_UPDATE,sizeof(szCount),szCount);
	lea	eax,[ebp-0ah];	szCount
	push	eax
	push	0ah
	push	0650h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 165           wTemp = atol(szCount);
	lea	eax,[ebp-0ah];	szCount
	call	atol
	mov	[ebp-0ch],ax;	wTemp

; 166           if (wTemp != stCFG.wUpdateDelay)
	mov	ax,word ptr  stCFG+0cfh
	cmp	[ebp-0ch],ax;	wTemp
	je	@BLBL10

; 167             {
; 168             stCFG.wUpdateDelay = wTemp;
	mov	ax,[ebp-0ch];	wTemp
	mov	word ptr  stCFG+0cfh,ax

; 169             WinStartTimer(habAnchorBlock,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	push	dword ptr  @14idTimer
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStartTimer
	add	esp,010h

; 170                           hwnd,
; 171                           idTimer,
; 172                           stCFG.wUpdateDelay);
; 173             }
@BLBL10:

; 174           break;
	jmp	@BLBL20
	align 04h
@BLBL23:

; 175         case DID_OK:
; 176           WinStopTimer(habAnchorBlock,
	push	dword ptr  @14idTimer
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStopTimer
	add	esp,0ch

; 177                        hwnd,
; 178                        idTimer);
; 179           idTimer = 0L;
	mov	dword ptr  @14idTimer,0h

; 180           WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 181           bShowAllActivated = FALSE;
	mov	dword ptr  @16bShowAllActivated,0h

; 182           break;
	jmp	@BLBL20
	align 04h
@BLBL24:

; 183         case DID_HELP:
; 184           DisplayHelpPanel(HLPP_SHOW_ALL_DLG);
	push	07549h
	call	DisplayHelpPanel
	add	esp,04h

; 185           break;
	jmp	@BLBL20
	align 04h
@BLBL25:

; 186         default:
; 187           return WinDefDlgProc(hwnd,msg,mp1,mp2);
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefDlgProc
	add	esp,014h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL20
	align 04h
@BLBL21:
	cmp	eax,0132h
	je	@BLBL22
	cmp	eax,01h
	je	@BLBL23
	cmp	eax,012dh
	je	@BLBL24
	jmp	@BLBL25
	align 04h
@BLBL20:

; 188         }
; 189       return(FALSE);
	xor	eax,eax
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL26:

; 190     default:      return(WinDefDlgProc(hwnd,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefDlgProc
	add	esp,014h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL11
	align 04h
@BLBL12:
	cmp	eax,03bh
	je	@BLBL13
	cmp	eax,08002h
	je	@BLBL14
	cmp	eax,029h
	je	@BLBL15
	cmp	eax,0800ch
	je	@BLBL16
	cmp	eax,08007h
	je	@BLBL17
	cmp	eax,024h
	je	@BLBL18
	cmp	eax,020h
	je	@BLBL19
	jmp	@BLBL26
	align 04h
@BLBL11:

; 191     }
; 192   return FALSE;
	xor	eax,eax
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
fnwpDeviceAllStatusDlg	endp

; 197   {
	align 010h

	public fnwpXmitStatusStatesDlg
fnwpXmitStatusStatesDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 200   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL34
	align 04h
@BLBL35:

; 201     {
; 202     case WM_INITDLG:
; 203       WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h

; 204       pwEvent = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	[ebp-04h],eax;	pwEvent

; 205       if (*pwEvent & 0x0001)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],01h
	je	@BLBL27

; 206         CheckButton(hwnd,TST_BIT0,TRUE);
	push	01h
	push	0a8dh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL27:

; 207       if (*pwEvent & 0x0002)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],02h
	je	@BLBL28

; 208         CheckButton(hwnd,TST_BIT1,TRUE);
	push	01h
	push	0a8eh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL28:

; 209       if (*pwEvent & 0x0004)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],04h
	je	@BLBL29

; 210         CheckButton(hwnd,TST_BIT2,TRUE);
	push	01h
	push	0a8fh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL29:

; 211       if (*pwEvent & 0x0008)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],08h
	je	@BLBL30

; 212         CheckButton(hwnd,TST_BIT3,TRUE);
	push	01h
	push	0a90h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL30:

; 213       if (*pwEvent & 0x0010)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],010h
	je	@BLBL31

; 214         CheckButton(hwnd,TST_BIT4,TRUE);
	push	01h
	push	0a91h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL31:

; 215       if (*pwEvent & 0x0020)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],020h
	je	@BLBL32

; 216         CheckButton(hwnd,TST_BIT5,TRUE);
	push	01h
	push	0a92h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL32:

; 217       break;
	jmp	@BLBL33
	align 04h
@BLBL36:

; 218 //    case WM_BUTTON1DOWN:
; 219 //      WinDismissDlg(hwnd,TRUE);
; 220 //      return(FALSE);
; 221     case WM_COMMAND:
; 222       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL38
	align 04h
@BLBL39:

; 223         {
; 224         case DID_HELP:
; 225           DisplayHelpPanel(HLPP_XMIT_STATUS_BITS);
	push	076c3h
	call	DisplayHelpPanel
	add	esp,04h

; 226           return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL40:
@BLBL41:

; 227         case DID_OK:
; 228         case DID_CANCEL:
; 229           break;
	jmp	@BLBL37
	align 04h
@BLBL42:

; 230         default:
; 231           return WinDefDlgProc(hwnd,msg,mp1,mp2);
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
	jmp	@BLBL37
	align 04h
@BLBL38:
	cmp	eax,012dh
	je	@BLBL39
	cmp	eax,01h
	je	@BLBL40
	cmp	eax,02h
	je	@BLBL41
	jmp	@BLBL42
	align 04h
@BLBL37:

; 232         }
; 233       WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 234       return((MRESULT)TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL43:

; 235     default:
; 236       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
	jmp	@BLBL33
	align 04h
@BLBL34:
	cmp	eax,03bh
	je	@BLBL35
	cmp	eax,020h
	je	@BLBL36
	jmp	@BLBL43
	align 04h
@BLBL33:

; 237     }
; 238   return FALSE;
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpXmitStatusStatesDlg	endp

; 243   {
	align 010h

	public fnwpCOMstatusStatesDlg
fnwpCOMstatusStatesDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 246   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL53
	align 04h
@BLBL54:

; 247     {
; 248     case WM_INITDLG:
; 249 //      CenterDlgBox(hwnd);
; 250       WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h

; 251       pwEvent = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	[ebp-04h],eax;	pwEvent

; 252       if (*pwEvent & 0x0001)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],01h
	je	@BLBL44

; 253         CheckButton(hwnd,CST_BIT0,TRUE);
	push	01h
	push	0b55h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL44:

; 254       if (*pwEvent & 0x0002)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],02h
	je	@BLBL45

; 255         CheckButton(hwnd,CST_BIT1,TRUE);
	push	01h
	push	0b56h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL45:

; 256       if (*pwEvent & 0x0004)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],04h
	je	@BLBL46

; 257         CheckButton(hwnd,CST_BIT2,TRUE);
; 257 
	push	01h
	push	0b57h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL46:

; 258       if (*pwEvent & 0x0008)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],08h
	je	@BLBL47

; 259         CheckButton(hwnd,CST_BIT3,TRUE);
	push	01h
	push	0b58h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL47:

; 260       if (*pwEvent & 0x0010)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],010h
	je	@BLBL48

; 261         CheckButton(hwnd,CST_BIT4,TRUE);
	push	01h
	push	0b59h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL48:

; 262       if (*pwEvent & 0x0020)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],020h
	je	@BLBL49

; 263         CheckButton(hwnd,CST_BIT5,TRUE);
	push	01h
	push	0b5ah
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL49:

; 264       if (*pwEvent & 0x0040)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],040h
	je	@BLBL50

; 265         CheckButton(hwnd,CST_BIT6,TRUE);
	push	01h
	push	0b5bh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL50:

; 266       if (*pwEvent & 0x0080)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],080h
	je	@BLBL51

; 267         CheckButton(hwnd,CST_BIT7,TRUE);
	push	01h
	push	0b5ch
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL51:

; 268       break;
	jmp	@BLBL52
	align 04h
@BLBL55:

; 269 //    case WM_BUTTON1DOWN:
; 270 //      WinDismissDlg(hwnd,TRUE);
; 271 //      return(FALSE);
; 272     case WM_COMMAND:
; 273       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL57
	align 04h
@BLBL58:

; 274         {
; 275         case DID_HELP:
; 276           DisplayHelpPanel(HLPP_COM_STATUS_BITS);
	push	076c1h
	call	DisplayHelpPanel
	add	esp,04h

; 277           return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL59:
@BLBL60:

; 278         case DID_OK:
; 279         case DID_CANCEL:
; 280           break;
	jmp	@BLBL56
	align 04h
@BLBL61:

; 281         default:
; 282           return WinDefDlgProc(hwnd,msg,mp1,mp2);
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
	jmp	@BLBL56
	align 04h
@BLBL57:
	cmp	eax,012dh
	je	@BLBL58
	cmp	eax,01h
	je	@BLBL59
	cmp	eax,02h
	je	@BLBL60
	jmp	@BLBL61
	align 04h
@BLBL56:

; 283         }
; 284       WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 285       return((MRESULT)TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL62:

; 286     default:
; 287       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
	jmp	@BLBL52
	align 04h
@BLBL53:
	cmp	eax,03bh
	je	@BLBL54
	cmp	eax,020h
	je	@BLBL55
	jmp	@BLBL62
	align 04h
@BLBL52:

; 288     }
; 289   return FALSE;
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpCOMstatusStatesDlg	endp

; 294   {
	align 010h

	public fnwpCOMeventStatesDlg
fnwpCOMeventStatesDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 298   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL74
	align 04h
@BLBL75:

; 299     {
; 300     case WM_INITDLG:
; 301 //      CenterDlgBox(hwnd);
; 302       WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h

; 303       pwEvent = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	[ebp-04h],eax;	pwEvent

; 304       if (*pwEvent & 0x0001)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],01h
	je	@BLBL63

; 305         CheckButton(hwnd,CEV_BIT0,TRUE);
	push	01h
	push	0af1h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL63:

; 306       if (*pwEvent & 0x0002)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],02h
	je	@BLBL64

; 307         CheckButton(hwnd,CEV_BIT1,TRUE);
	push	01h
	push	0af2h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL64:

; 308       if (*pwEvent & 0x0004)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],04h
	je	@BLBL65

; 309         CheckButton(hwnd,CEV_BIT2,TRUE);
	push	01h
	push	0af3h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL65:

; 310       if (*pwEvent & 0x0008)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],08h
	je	@BLBL66

; 311         CheckButton(hwnd,CEV_BIT3,TRUE);
	push	01h
	push	0af4h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL66:

; 312       if (*pwEvent & 0x0010)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],010h
	je	@BLBL67

; 313         CheckButton(hwnd,CEV_BIT4,TRUE);
	push	01h
	push	0af5h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL67:

; 314       if (*pwEvent & 0x0020)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],020h
	je	@BLBL68

; 315         CheckButton(hwnd,CEV_BIT5,TRUE);
	push	01h
	push	0af6h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL68:

; 316       if (*pwEvent & 0x0040)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],040h
	je	@BLBL69

; 317         CheckButton(hwnd,CEV_BIT6,TRUE);
	push	01h
	push	0af7h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL69:

; 318       if (*pwEvent & 0x0080)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax],080h
	je	@BLBL70

; 319         CheckButton(hwnd,CEV_BIT7,TRUE);
	push	01h
	push	0af8h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL70:

; 320       if (*pwEvent & 0x0100)
	mov	eax,[ebp-04h];	pwEvent
	test	byte ptr [eax+01h],01h
	je	@BLBL71

; 321         CheckButton(hwnd,CEV_BIT8,TRUE);
	push	01h
	push	0af9h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL71:

; 322       break;
	jmp	@BLBL73
	align 04h
@BLBL76:

; 323 //    case WM_BUTTON1DOWN:
; 324 //      WinDismissDlg(hwnd,TRUE);
; 325 //      return(FALSE);
; 326     case WM_COMMAND:
; 327       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL78
	align 04h
@BLBL79:

; 328         {
; 329         case DID_HELP:
; 330           DisplayHelpPanel(HLPP_COM_EVENT_BITS);
	push	076c0h
	call	DisplayHelpPanel
	add	esp,04h

; 331           return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL80:

; 332         case DID_CLEAR:
; 333           if (GetCOMevent(&stIOctl,hCom,&wEvent) != NO_ERROR)
	lea	eax,[ebp-06h];	wEvent
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetCOMevent
	add	esp,0ch
	test	eax,eax
	je	@BLBL72

; 334             {
; 335             WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatAll
	call	WinPostMsg
	add	esp,010h

; 336             WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatDev
	call	WinPostMsg
	add	esp,010h

; 337             }
@BLBL72:
@BLBL81:
@BLBL82:

; 338         case DID_OK:
; 339         case DID_CANCEL:
; 340           break;
	jmp	@BLBL77
	align 04h
@BLBL83:

; 341         default:
; 342           return WinDefDlgProc(hwnd,msg,mp1,mp2);
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
	jmp	@BLBL77
	align 04h
@BLBL78:
	cmp	eax,012dh
	je	@BLBL79
	cmp	eax,012ch
	je	@BLBL80
	cmp	eax,01h
	je	@BLBL81
	cmp	eax,02h
	je	@BLBL82
	jmp	@BLBL83
	align 04h
@BLBL77:

; 343         }
; 344       WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 345       return((MRESULT)TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL84:

; 346     default:
; 347       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
	jmp	@BLBL73
	align 04h
@BLBL74:
	cmp	eax,03bh
	je	@BLBL75
	cmp	eax,020h
	je	@BLBL76
	jmp	@BLBL84
	align 04h
@BLBL73:

; 348     }
; 349   return FALSE;
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpCOMeventStatesDlg	endp

; 353   {
	align 010h

	public fnwpCOMerrorStatesDlg
fnwpCOMerrorStatesDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 357   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL91
	align 04h
@BLBL92:

; 358     {
; 359     case WM_INITDLG:
; 360       WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h

; 361       pwError = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	[ebp-04h],eax;	pwError

; 362       if (*pwError & 0x0001)
	mov	eax,[ebp-04h];	pwError
	test	byte ptr [eax],01h
	je	@BLBL85

; 363         CheckButton(hwnd,CER_BIT0,TRUE);
	push	01h
	push	0a29h
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL85:

; 364       if (*pwError & 0x0002)
	mov	eax,[ebp-04h];	pwError
	test	byte ptr [eax],02h
	je	@BLBL86

; 365         CheckButton(hwnd,CER_BIT1,TRUE);
	push	01h
	push	0a2ah
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL86:

; 366       if (*pwError & 0x0004)
	mov	eax,[ebp-04h];	pwError
	test	byte ptr [eax],04h
	je	@BLBL87

; 367         CheckButton(hwnd,CER_BIT2,TRUE);
	push	01h
	push	0a2bh
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL87:

; 368       if (*pwError & 0x0008)
	mov	eax,[ebp-04h];	pwError
	test	byte ptr [eax],08h
	je	@BLBL88

; 369         CheckButton(hwnd,CER_BIT3,TRUE);
	push	01h
	push	0a2ch
	push	dword ptr [ebp+08h];	hwnd
	call	CheckButton
	add	esp,0ch
@BLBL88:

; 370       break;
	jmp	@BLBL90
	align 04h
@BLBL93:

; 371 //    case WM_BUTTON1DOWN:
; 372 //      WinDismissDlg(hwnd,TRUE);
; 373 //      return(FALSE);
; 374     case WM_COMMAND:
; 375       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL95
	align 04h
@BLBL96:

; 376         {
; 377         case DID_HELP:
; 378           DisplayHelpPanel(HLPP_COM_ERROR_BITS);
	push	076c2h
	call	DisplayHelpPanel
	add	esp,04h

; 379           return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL97:

; 380         case DID_CLEAR:
; 381           if (GetCOMerror(&stIOctl,hCom,&wError) != NO_ERROR)
	lea	eax,[ebp-06h];	wError
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetCOMerror
	add	esp,0ch
	test	eax,eax
	je	@BLBL89

; 382             {
; 383             WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatAll
	call	WinPostMsg
	add	esp,010h

; 384             WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatDev
	call	WinPostMsg
	add	esp,010h

; 385             }
@BLBL89:
@BLBL98:
@BLBL99:

; 386         case DID_OK:
; 387         case DID_CANCEL:
; 388           break;
	jmp	@BLBL94
	align 04h
@BLBL100:

; 389         default:
; 390           return WinDefDlgProc(hwnd,msg,mp1,mp2);
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
	jmp	@BLBL94
	align 04h
@BLBL95:
	cmp	eax,012dh
	je	@BLBL96
	cmp	eax,012ch
	je	@BLBL97
	cmp	eax,01h
	je	@BLBL98
	cmp	eax,02h
	je	@BLBL99
	jmp	@BLBL100
	align 04h
@BLBL94:

; 391         }
; 392       WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 393       return((MRESULT)TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL101:

; 394     default:
; 395       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
	jmp	@BLBL90
	align 04h
@BLBL91:
	cmp	eax,03bh
	je	@BLBL92
	cmp	eax,020h
	je	@BLBL93
	jmp	@BLBL101
	align 04h
@BLBL90:

; 396     }
; 397   return FALSE;
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpCOMerrorStatesDlg	endp

; 401   {
	align 010h

	public fnwpDeviceStatusDlg
fnwpDeviceStatusDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,05ch
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,017h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 410   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL117
	align 04h
@BLBL118:

; 411     {
; 412     case WM_INITDLG:
; 413       SetSystemMenu(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	SetSystemMenu
	add	esp,04h

; 414       WinSendDlgItemMsg(hwnd,HWS_COMST,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
	push	0h
	push	01h
	push	014bh
	push	0644h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 415       WinSendDlgItemMsg(hwnd,HWS_COMERROR,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
	push	0h
	push	01h
	push	014bh
	push	0642h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 416       WinSendDlgItemMsg(hwnd,HWS_COMEVENT,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
	push	0h
	push	01h
	push	014bh
	push	0641h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 417       WinSendDlgItemMsg(hwnd,HWS_XMITST,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
	push	0h
	push	01h
	push	014bh
	push	0643h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 418       idTimer = 0L;
	mov	dword ptr  @56idTimer,0h

; 419       bShowingBits = FALSE;
	mov	dword ptr  @59bShowingBits,0h

; 420       sCurrentFocus = 0;
	mov	word ptr  @5asCurrentFocus,0h

; 421       CenterDlgBox(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	CenterDlgBox
	add	esp,04h

; 422       break;
	jmp	@BLBL116
	align 04h
@BLBL119:

; 423     case UM_INITLS:
; 424       if (!bDDstatusActivated)
	cmp	dword ptr  bDDstatusActivated,0h
	jne	@BLBL102

; 425         {
; 426         bDDstatusActivated = TRUE;
	mov	dword ptr  bDDstatusActivated,01h

; 427         if (lStatusWindowCount++ <= 0)
	cmp	dword ptr  lStatusWindowCount,0h
	jg	@BLBL103
	mov	eax,dword ptr  lStatusWindowCount
	inc	eax
	mov	dword ptr  lStatusWindowCount,eax

; 428           MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,TRUE);
	push	01h
	push	081ch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
	jmp	@BLBL104
	align 010h
@BLBL103:
	mov	eax,dword ptr  lStatusWindowCount
	inc	eax
	mov	dword ptr  lStatusWindowCount,eax
@BLBL104:

; 429         if (stCFG.bLoadWindowPosition && (hProfileInstance != NULL) && (stCFG.ptlDDstatusPos.y > -40))
	test	byte ptr  stCFG+017h,040h
	je	@BLBL105
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL105
	cmp	dword ptr  stCFG+049h,0ffffffd8h
	jle	@BLBL105

; 430           WinSetWindowPos(hwnd,HWND_TOP,stCFG.ptlDDstatusPos.x,stCFG.ptlDDstatusPos.y,0L,0L,SWP_MOVE);
	push	02h
	push	0h
	push	0h
	push	dword ptr  stCFG+049h
	push	dword ptr  stCFG+045h
	push	03h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowPos
	add	esp,01ch
	jmp	@BLBL106
	align 010h
@BLBL105:

; 431         else
; 432           MousePosDlgBox(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	MousePosDlgBox
	add	esp,04h
@BLBL106:

; 433         WinShowWindow(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinShowWindow
	add	esp,08h

; 434         WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h

; 435         }
@BLBL102:

; 436       UpdateDeviceStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateDeviceStatusDlg
	add	esp,04h

; 437       idTimer = WinStartTimer(habAnchorBlock,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	push	07ffdh
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStartTimer
	add	esp,010h
	mov	dword ptr  @56idTimer,eax
@BLBL120:

; 438                               hwnd,
; 439                               TID_STATDEV,
; 440                               stCFG.wUpdateDelay);
; 441     case UM_RESET_NAME:
; 442       sprintf(szStatus,"%s - Device Driver Status",stCFG.szPortName);
	push	offset FLAT:stCFG+02h
	mov	edx,offset FLAT:@STAT2
	lea	eax,[ebp-058h];	szStatus
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 443       WinSetWindowText(hwnd,szStatus);
	lea	eax,[ebp-058h];	szStatus
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowText
	add	esp,08h

; 444       break;
	jmp	@BLBL116
	align 04h
@BLBL121:
@BLBL122:

; 445     case WM_CLOSE:
; 446     case UM_KILL_MONITOR:
; 447       bDDstatusActivated = FALSE;
	mov	dword ptr  bDDstatusActivated,0h

; 448       if (--lStatusWindowCount <= 0)
	mov	eax,dword ptr  lStatusWindowCount
	dec	eax
	mov	dword ptr  lStatusWindowCount,eax
	cmp	dword ptr  lStatusWindowCount,0h
	jg	@BLBL107

; 449         MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,FALSE);
	push	0h
	push	081ch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
@BLBL107:

; 450       if (idTimer)
	cmp	dword ptr  @56idTimer,0h
	je	@BLBL108

; 451         {
; 452         WinStopTimer(habAnchorBlock,
	push	dword ptr  @56idTimer
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStopTimer
	add	esp,0ch

; 453                      hwnd,
; 454                      idTimer);
; 455         idTimer = 0L;
	mov	dword ptr  @56idTimer,0h

; 456         }
@BLBL108:

; 457       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
@BLBL123:

; 458     case UM_RESETTIMER:
; 459       if (idTimer != 0L)
	cmp	dword ptr  @56idTimer,0h
	je	@BLBL109

; 460         idTimer = WinStartTimer(habAnchorBlock,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	push	dword ptr  @56idTimer
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStartTimer
	add	esp,010h
	mov	dword ptr  @56idTimer,eax
@BLBL109:

; 461                               hwnd,
; 462                               idTimer,
; 463                               stCFG.wUpdateDelay);
; 464       break;
	jmp	@BLBL116
	align 04h
@BLBL124:

; 465     case WM_CHAR:
; 466       if ((sCurrentFocus != 0) && (!bShowingBits) && (SHORT1FROMMP(mp1) & KC_CHAR) && (SHORT1FROMMP(mp2) == ' '))
	cmp	word ptr  @5asCurrentFocus,0h
	je	@BLBL110
	cmp	dword ptr  @59bShowingBits,0h
	jne	@BLBL110
	mov	ax,[ebp+010h];	mp1
	test	al,01h
	je	@BLBL110
	mov	ax,[ebp+014h];	mp2
	cmp	ax,020h
	jne	@BLBL110

; 467         {
; 468         WinPostMsg(hwnd,UM_SHOWBITS,MPFROMSHORT(sCurrentFocus),(MPARAM)0L);
	push	0h
	mov	ax,word ptr  @5asCurrentFocus
	and	eax,0ffffh
	push	eax
	push	08008h
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 469         bShowingBits = TRUE;
	mov	dword ptr  @59bShowingBits,01h

; 470         }
	jmp	@BLBL111
	align 010h
@BLBL110:

; 471       else
; 472         return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
@BLBL111:

; 473       break;
	jmp	@BLBL116
	align 04h
@BLBL125:

; 474     case WM_BUTTON1UP:
; 475       if ((sCurrentFocus != 0) && (!bShowingBits))
	cmp	word ptr  @5asCurrentFocus,0h
	je	@BLBL112
	cmp	dword ptr  @59bShowingBits,0h
	jne	@BLBL112

; 476         {
; 477         WinPostMsg(hwnd,UM_SHOWBITS,MPFROMSHORT(sCurrentFocus),(MPARAM)0L);
	push	0h
	mov	ax,word ptr  @5asCurrentFocus
	and	eax,0ffffh
	push	eax
	push	08008h
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 478         bShowingBits = TRUE;
	mov	dword ptr  @59bShowingBits,01h

; 479         }
	jmp	@BLBL113
	align 010h
@BLBL112:

; 480       else
; 481         return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
@BLBL113:

; 482       break;
	jmp	@BLBL116
	align 04h
@BLBL126:

; 483     case WM_CONTROL:
; 484       if (!bShowingBits)
	cmp	dword ptr  @59bShowingBits,0h
	jne	@BLBL114

; 485         {
; 486         switch (SHORT2FROMMP(mp1))
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	and	eax,0ffffh
	jmp	@BLBL128
	align 04h
@BLBL129:

; 487           {
; 488           case EN_SETFOCUS:
; 489             sCurrentFocus = SHORT1FROMMP(mp1);
	mov	eax,[ebp+010h];	mp1
	mov	word ptr  @5asCurrentFocus,ax

; 490             break;
	jmp	@BLBL127
	align 04h
@BLBL130:

; 491           case EN_KILLFOCUS:
; 492             sCurrentFocus = 0;
	mov	word ptr  @5asCurrentFocus,0h

; 493             break;
	jmp	@BLBL127
	align 04h
	jmp	@BLBL127
	align 04h
@BLBL128:
	cmp	eax,01h
	je	@BLBL129
	cmp	eax,02h
	je	@BLBL130
@BLBL127:

; 494           }
; 495         }
@BLBL114:

; 496       break;
	jmp	@BLBL116
	align 04h
@BLBL131:

; 497     case UM_SHOWBITS:
; 498         switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL133
	align 04h
@BLBL134:

; 499           {
; 500           case HWS_COMERROR:
; 501             idDlg      = CER_DLG;
	mov	word ptr [ebp-02h],0a28h;	idDlg

; 502             pfnDlgProc = (PFNWP)fnwpCOMerrorStatesDlg;
	mov	dword ptr [ebp-08h],offset FLAT: fnwpCOMerrorStatesDlg;	pfnDlgProc

; 503             WinQueryDlgItemText(hwnd,HWS_COMERROR,sizeof(szStatus),szStatus);
	lea	eax,[ebp-058h];	szStatus
	push	eax
	push	050h
	push	0642h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 504             break;
	jmp	@BLBL132
	align 04h
@BLBL135:

; 505           case HWS_COMEVENT:
; 506             idDlg      = CEV_DLG;
	mov	word ptr [ebp-02h],0af0h;	idDlg

; 507             pfnDlgProc = (PFNWP)fnwpCOMeventStatesDlg;
	mov	dword ptr [ebp-08h],offset FLAT: fnwpCOMeventStatesDlg;	pfnDlgProc

; 508             WinQueryDlgItemText(hwnd,HWS_COMEVENT,sizeof(szStatus),szStatus);
	lea	eax,[ebp-058h];	szStatus
	push	eax
	push	050h
	push	0641h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 509             break;
	jmp	@BLBL132
	align 04h
@BLBL136:

; 510           case HWS_COMST:
; 511             idDlg      = CST_DLG;
	mov	word ptr [ebp-02h],0b54h;	idDlg

; 512             pfnDlgProc = (PFNWP)fnwpCOMstatusStatesDlg;
	mov	dword ptr [ebp-08h],offset FLAT: fnwpCOMstatusStatesDlg;	pfnDlgProc

; 513             WinQueryDlgItemText(hwnd,HWS_COMST,sizeof(szStatus),szStatus);
	lea	eax,[ebp-058h];	szStatus
	push	eax
	push	050h
	push	0644h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 514             break;
	jmp	@BLBL132
	align 04h
@BLBL137:

; 515           case HWS_XMITST:
; 516             idDlg 
; 516      = TST_DLG;
	mov	word ptr [ebp-02h],0a8ch;	idDlg

; 517             pfnDlgProc = (PFNWP)fnwpXmitStatusStatesDlg;
	mov	dword ptr [ebp-08h],offset FLAT: fnwpXmitStatusStatesDlg;	pfnDlgProc

; 518             WinQueryDlgItemText(hwnd,HWS_XMITST,sizeof(szStatus),szStatus);
	lea	eax,[ebp-058h];	szStatus
	push	eax
	push	050h
	push	0643h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 519             break;
	jmp	@BLBL132
	align 04h
@BLBL138:

; 520           default:
; 521             return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL132
	align 04h
@BLBL133:
	cmp	eax,0642h
	je	@BLBL134
	cmp	eax,0641h
	je	@BLBL135
	cmp	eax,0644h
	je	@BLBL136
	cmp	eax,0643h
	je	@BLBL137
	jmp	@BLBL138
	align 04h
@BLBL132:

; 522           }
; 523         wStatus = (WORD)ASCIItoBin(szStatus,16);
	push	010h
	lea	eax,[ebp-058h];	szStatus
	push	eax
	call	ASCIItoBin
	add	esp,08h
	mov	[ebp-05ah],ax;	wStatus

; 524         WinDlgBox(HWND_DESKTOP,
	lea	eax,[ebp-05ah];	wStatus
	push	eax
	xor	eax,eax
	mov	ax,[ebp-02h];	idDlg
	push	eax
	push	0h
	push	dword ptr [ebp-08h];	pfnDlgProc
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h

; 525                   hwnd,
; 526                   pfnDlgProc,
; 527                   NULLHANDLE,
; 528                   idDlg,
; 529                   &wStatus);
; 530         WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h

; 531         bShowingBits = FALSE;
	mov	dword ptr  @59bShowingBits,0h

; 532       break;
	jmp	@BLBL116
	align 04h
@BLBL139:

; 533     case WM_TIMER:
; 534       UpdateDeviceStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateDeviceStatusDlg
	add	esp,04h

; 535       break;
	jmp	@BLBL116
	align 04h
@BLBL140:

; 536     case WM_ACTIVATE:
; 537       if (bDDstatusActivated)
	cmp	dword ptr  bDDstatusActivated,0h
	je	@BLBL115

; 538         WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h
@BLBL115:

; 539       break;
	jmp	@BLBL116
	align 04h
@BLBL141:

; 540     default:
; 541       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
	jmp	@BLBL116
	align 04h
@BLBL117:
	cmp	eax,03bh
	je	@BLBL118
	cmp	eax,08002h
	je	@BLBL119
	cmp	eax,08022h
	je	@BLBL120
	cmp	eax,029h
	je	@BLBL121
	cmp	eax,0800ch
	je	@BLBL122
	cmp	eax,08007h
	je	@BLBL123
	cmp	eax,07ah
	je	@BLBL124
	cmp	eax,072h
	je	@BLBL125
	cmp	eax,030h
	je	@BLBL126
	cmp	eax,08008h
	je	@BLBL131
	cmp	eax,024h
	je	@BLBL139
	cmp	eax,0dh
	je	@BLBL140
	jmp	@BLBL141
	align 04h
@BLBL116:

; 542     }
; 543   return FALSE;
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpDeviceStatusDlg	endp

; 547   {
	align 010h

	public fnwpUpdateStatusDlg
fnwpUpdateStatusDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax
	sub	esp,04h

; 550   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL143
	align 04h
@BLBL144:

; 551     {
; 552     case WM_INITDLG:
; 553       WinSendDlgItemMsg(hwnd,HWS_UPDATE,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
	push	0h
	push	05h
	push	0143h
	push	0650h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 554       sprintf(szCount,"%u",stCFG.wUpdateDelay);
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	mov	edx,offset FLAT:@STAT3
	lea	eax,[ebp-0ah];	szCount
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 555       WinSetDlgItemText(hwnd,HWS_UPDATE,szCount);
	lea	eax,[ebp-0ah];	szCount
	push	eax
	push	0650h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 556 //      CenterDlgBox(hwnd);
; 557       break;
	jmp	@BLBL142
	align 04h
@BLBL145:

; 558     case WM_COMMAND:
; 559       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL147
	align 04h
@BLBL148:

; 560         {
; 561         case DID_OK:
; 562           WinQueryDlgItemText(hwnd,HWS_UPDATE,sizeof(szCount),szCount);
	lea	eax,[ebp-0ah];	szCount
	push	eax
	push	0ah
	push	0650h
	push	dword ptr [ebp+08h];	hwnd
	call	WinQueryDlgItemText
	add	esp,010h

; 563           stCFG.wUpdateDelay = atol(szCount);
	lea	eax,[ebp-0ah];	szCount
	call	atol
	mov	word ptr  stCFG+0cfh,ax

; 564           WinPostMsg(hwndStatus,UM_RESETTIMER,(MPARAM)(0L),(MPARAM)0L);
	push	0h
	push	0h
	push	08007h
	push	dword ptr  hwndStatus
	call	WinPostMsg
	add	esp,010h

; 565           WinPostMsg(hwndStatDev,UM_RESETTIMER,(MPARAM)(0L),(MPARAM)0L);
	push	0h
	push	0h
	push	08007h
	push	dword ptr  hwndStatDev
	call	WinPostMsg
	add	esp,010h

; 566           WinPostMsg(hwndStatAll,UM_RESETTIMER,(MPARAM)(0L),(MPARAM)0L);
	push	0h
	push	0h
	push	08007h
	push	dword ptr  hwndStatAll
	call	WinPostMsg
	add	esp,010h

; 567           WinPostMsg(hwndStatRcvBuf,UM_RESETTIMER,(MPARAM)(0L),(MPARAM)0L);
	push	0h
	push	0h
	push	08007h
	push	dword ptr  hwndStatRcvBuf
	call	WinPostMsg
	add	esp,010h

; 568           WinPostMsg(hwndStatXmitBuf,UM_RESETTIMER,(MPARAM)(0L),(MPARAM)0L);
	push	0h
	push	0h
	push	08007h
	push	dword ptr  hwndStatXmitBuf
	call	WinPostMsg
	add	esp,010h

; 569           WinPostMsg(hwndStatModemIn,UM_RESETTIMER,(MPARAM)(0L),(MPARAM)0L);
	push	0h
	push	0h
	push	08007h
	push	dword ptr  hwndStatModemIn
	call	WinPostMsg
	add	esp,010h

; 570           WinPostMsg(hwndStatModemOut,UM_RESETTIMER,(MPARAM)(0L),(MPARAM)0L);
	push	0h
	push	0h
	push	08007h
	push	dword ptr  hwndStatModemOut
	call	WinPostMsg
	add	esp,010h

; 571           break;
	jmp	@BLBL146
	align 04h
@BLBL149:

; 572         case DID_CANCEL:
; 573           break;
	jmp	@BLBL146
	align 04h
@BLBL150:

; 574         case DID_HELP:
; 575           DisplayHelpPanel(HLPP_UPDATE_FREQ_DLG);
	push	07548h
	call	DisplayHelpPanel
	add	esp,04h

; 576           return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL151:

; 577         default:
; 578           return WinDefDlgProc(hwnd,msg,mp1,mp2);
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefDlgProc
	add	esp,014h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL146
	align 04h
@BLBL147:
	cmp	eax,01h
	je	@BLBL148
	cmp	eax,02h
	je	@BLBL149
	cmp	eax,012dh
	je	@BLBL150
	jmp	@BLBL151
	align 04h
@BLBL146:

; 579         }
; 580       WinDismissDlg(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 581       break;
	jmp	@BLBL142
	align 04h
@BLBL152:

; 582     default:
; 583       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefDlgProc
	add	esp,014h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL142
	align 04h
@BLBL143:
	cmp	eax,03bh
	je	@BLBL144
	cmp	eax,020h
	je	@BLBL145
	jmp	@BLBL152
	align 04h
@BLBL142:

; 584     }
; 585   return FALSE;
	xor	eax,eax
	add	esp,04h
	mov	esp,ebp
	pop	ebp
	ret	
fnwpUpdateStatusDlg	endp

; 589   {
	align 010h

	public fnwpXmitBufferStatusDlg
fnwpXmitBufferStatusDlg	proc
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

; 593   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL163
	align 04h
@BLBL164:

; 594     {
; 595     case WM_INITDLG:
; 596       SetSystemMenu(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	SetSystemMenu
	add	esp,04h

; 597       WinSendDlgItemMsg(hwnd,HWS_BUFLEV,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
	push	0h
	push	01h
	push	014bh
	push	04a94h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 598       WinSendDlgItemMsg(hwnd,HWS_BUFLEN,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
	push	0h
	push	01h
	push	014bh
	push	04a92h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 599       idTimer = 0L;
	mov	dword ptr  @7aidTimer,0h

; 600 //      CenterDlgBox(hwnd);
; 601       break;
	jmp	@BLBL162
	align 04h
@BLBL165:

; 602     case UM_INITLS:
; 603       if (!bTBstatusActivated)
	cmp	dword ptr  bTBstatusActivated,0h
	jne	@BLBL153

; 604         {
; 605         bTBstatusActivated = TRUE;
	mov	dword ptr  bTBstatusActivated,01h

; 606         if (lStatusWindowCount++ <= 0)
	cmp	dword ptr  lStatusWindowCount,0h
	jg	@BLBL154
	mov	eax,dword ptr  lStatusWindowCount
	inc	eax
	mov	dword ptr  lStatusWindowCount,eax

; 607           MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,TRUE);
	push	01h
	push	081ch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
	jmp	@BLBL155
	align 010h
@BLBL154:
	mov	eax,dword ptr  lStatusWindowCount
	inc	eax
	mov	dword ptr  lStatusWindowCount,eax
@BLBL155:

; 608         if (stCFG.bLoadWindowPosition && (hProfileInstance != NULL) && (stCFG.ptlMIstatusPos.y > -40))
	test	byte ptr  stCFG+017h,040h
	je	@BLBL156
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL156
	cmp	dword ptr  stCFG+051h,0ffffffd8h
	jle	@BLBL156

; 609           WinSetWindowPos(hwnd,HWND_TOP,stCFG.ptlTBstatusPos.x,stCFG.ptlTBstatusPos.y,0L,0L,SWP_MOVE);
	push	02h
	push	0h
	push	0h
	push	dword ptr  stCFG+069h
	push	dword ptr  stCFG+065h
	push	03h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowPos
	add	esp,01ch
	jmp	@BLBL157
	align 010h
@BLBL156:

; 610         else
; 611           MousePosDlgBox(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	MousePosDlgBox
	add	esp,04h
@BLBL157:

; 612         WinShowWindow(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinShowWindow
	add	esp,08h

; 613         WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h

; 614         }
@BLBL153:

; 615       UpdateXmitBufferStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateXmitBufferStatusDlg
	add	esp,04h

; 616       idTimer = WinStartTimer(habAnchorBlock,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	push	07ffbh
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStartTimer
	add	esp,010h
	mov	dword ptr  @7aidTimer,eax
@BLBL166:

; 617                               hwnd,
; 618                               TID_STATXMITBUF,
; 619                               stCFG.wUpdateDelay);
; 620     case UM_RESET_NAME:
; 621       sprintf(szCaption,"%s - Transmit Buffer",stCFG.szPortName);
	push	offset FLAT:stCFG+02h
	mov	edx,offset FLAT:@STAT4
	lea	eax,[ebp-050h];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 622       WinSetWindowText(hwnd,szCaption);
	lea	eax,[ebp-050h];	szCaption
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowText
	add	esp,08h

; 623       break;
	jmp	@BLBL162
	align 04h
@BLBL167:
@BLBL168:

; 624     case WM_CLOSE:
; 625     case UM_KILL_MONITOR:
; 626       bTBstatusActivated = FALSE;
	mov	dword ptr  bTBstatusActivated,0h

; 627       if (--lStatusWindowCount <= 0)
	mov	eax,dword ptr  lStatusWindowCount
	dec	eax
	mov	dword ptr  lStatusWindowCount,eax
	cmp	dword ptr  lStatusWindowCount,0h
	jg	@BLBL158

; 628         MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,FALSE);
	push	0h
	push	081ch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
@BLBL158:

; 629       if (idTimer)
	cmp	dword ptr  @7aidTimer,0h
	je	@BLBL159

; 630         {
; 631         WinStopTimer(habAnchorBlock,
	push	dword ptr  @7aidTimer
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStopTimer
	add	esp,0ch

; 632                      hwnd,
; 633                      idTimer);
; 634         idTimer = 0L;
	mov	dword ptr  @7aidTimer,0h

; 635         }
@BLBL159:

; 636       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
@BLBL169:

; 637     case UM_RESETTIMER:
; 638       if (idTimer != 0L)
	cmp	dword ptr  @7aidTimer,0h
	je	@BLBL160

; 639         idTimer = WinStartTimer(habAnchorBlock,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	push	dword ptr  @7aidTimer
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStartTimer
	add	esp,010h
	mov	dword ptr  @7aidTimer,eax
@BLBL160:

; 640                                 hwnd,
; 641                                 idTimer,
; 642                                 stCFG.wUpdateDelay);
; 643       break;
	jmp	@BLBL162
	align 04h
@BLBL170:

; 644     case WM_TIMER:
; 645       UpdateXmitBufferStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateXmitBufferStatusDlg
	add	esp,04h

; 646       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL171:

; 647     case WM_ACTIVATE:
; 648       if (bTBstatusActivated)
	cmp	dword ptr  bTBstatusActivated,0h
	je	@BLBL161

; 649         WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h
@BLBL161:

; 650       break;
	jmp	@BLBL162
	align 04h
@BLBL172:

; 651     default:
; 652       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
	jmp	@BLBL162
	align 04h
@BLBL163:
	cmp	eax,03bh
	je	@BLBL164
	cmp	eax,08002h
	je	@BLBL165
	cmp	eax,08022h
	je	@BLBL166
	cmp	eax,029h
	je	@BLBL167
	cmp	eax,0800ch
	je	@BLBL168
	cmp	eax,08007h
	je	@BLBL169
	cmp	eax,024h
	je	@BLBL170
	cmp	eax,0dh
	je	@BLBL171
	jmp	@BLBL172
	align 04h
@BLBL162:

; 653     }
; 654   return FALSE;
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpXmitBufferStatusDlg	endp

; 658   {
	align 010h

	public fnwpRcvBufferStatusDlg
fnwpRcvBufferStatusDlg	proc
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

; 663   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL190
	align 04h
@BLBL191:

; 664     {
; 665     case WM_INITDLG:
; 666       SetSystemMenu(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	SetSystemMenu
	add	esp,04h

; 667       WinSendDlgItemMsg(hwnd,HWS_BUFLEV,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
	push	0h
	push	01h
	push	014bh
	push	04a94h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 668       WinSendDlgItemMsg(hwnd,HWS_BUFLEN,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
	push	0h
	push	01h
	push	014bh
	push	04a92h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 669 //      CenterDlgBox(hwnd);
; 670       idTimer = 0L;
	mov	dword ptr  @87idTimer,0h

; 671       break;
	jmp	@BLBL189
	align 04h
@BLBL192:

; 672     case UM_INITLS:
; 673       if (!bRBstatusActivated)
	cmp	dword ptr  bRBstatusActivated,0h
	jne	@BLBL173

; 674         {
; 675         bRBstatusActivated = TRUE;
	mov	dword ptr  bRBstatusActivated,01h

; 676         if (lStatusWindowCount++ <= 0)
	cmp	dword ptr  lStatusWindowCount,0h
	jg	@BLBL174
	mov	eax,dword ptr  lStatusWindowCount
	inc	eax
	mov	dword ptr  lStatusWindowCount,eax

; 677           MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,TRUE);
	push	01h
	push	081ch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
	jmp	@BLBL175
	align 010h
@BLBL174:
	mov	eax,dword ptr  lStatusWindowCount
	inc	eax
	mov	dword ptr  lStatusWindowCount,eax
@BLBL175:

; 678         if (stCFG.bLoadWindowPosition && (hProfileInstance != NULL) && (stCFG.ptlRBstatusPos.y > -40))
	test	byte ptr  stCFG+017h,040h
	je	@BLBL176
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL176
	cmp	dword ptr  stCFG+061h,0ffffffd8h
	jle	@BLBL176

; 679           WinSetWindowPos(hwnd,HWND_TOP,stCFG.ptlRBstatusPos.x,stCFG.ptlRBstatusPos.y,0L,0L,SWP_MOVE);
	push	02h
	push	0h
	push	0h
	push	dword ptr  stCFG+061h
	push	dword ptr  stCFG+05dh
	push	03h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowPos
	add	esp,01ch
	jmp	@BLBL177
	align 010h
@BLBL176:

; 680         else
; 681           MousePosDlgBox(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	MousePosDlgBox
	add	esp,04h
@BLBL177:

; 682         WinShowWindow(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinShowWindow
	add	esp,08h

; 683         WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h

; 684         stCFG.fTraceEvent |= CSFUNC_TRACE_RX_BUFF_LEVEL;
	mov	eax,dword ptr  stCFG+01fh
	or	ah,010h
	mov	dword ptr  stCFG+01fh,eax

; 685         if (bCOMscopeEnabled && (hCom != 0xffffffff))
	cmp	dword ptr  bCOMscopeEnabled,0h
	je	@BLBL178
	cmp	dword ptr  hCom,0ffffffffh
	je	@BLBL178

; 686           EnableCOMscope(hwnd,hCom,&ulCOMscopeBufferSize,stCFG.fTraceEvent);
	mov	ax,word ptr  stCFG+01fh
	push	eax
	push	offset FLAT:ulCOMscopeBufferSize
	push	dword ptr  hCom
	push	dword ptr [ebp+08h];	hwnd
	call	EnableCOMscope
	add	esp,010h
@BLBL178:

; 687         ResetHighWater();
	call	ResetHighWater

; 688         }
@BLBL173:

; 689       UpdateRcvBufferStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateRcvBufferStatusDlg
	add	esp,04h

; 690       idTimer = WinStartTimer(habAnchorBlock,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	push	07ffch
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStartTimer
	add	esp,010h
	mov	dword ptr  @87idTimer,eax

; 691                               hwnd,
; 692                               TID_STATRCVBUF,
; 693                               stCFG.wUpdateDelay);
; 694       sCurrentFocus = 0;
	mov	word ptr  @89sCurrentFocus,0h
@BLBL193:

; 695     case UM_RESET_NAME:
; 696       sprintf(szCaption,"%s - Receive Buffer",stCFG.szPortName);
	push	offset FLAT:stCFG+02h
	mov	edx,offset FLAT:@STAT5
	lea	eax,[ebp-050h];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 697       WinSetWindowText(hwnd,szCaption);
	lea	eax,[ebp-050h];	szCaption
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowText
	add	esp,08h

; 698       break;
	jmp	@BLBL189
	align 04h
@BLBL194:
@BLBL195:

; 699     case WM_CLOSE:
; 700     case UM_KILL_MONITOR:
; 701       bRBstatusActivated = FALSE;
	mov	dword ptr  bRBstatusActivated,0h

; 702       stCFG.fTraceEvent &= ~CSFUNC_TRACE_RX_BUFF_LEVEL;
	mov	eax,dword ptr  stCFG+01fh
	and	ah,0efh
	mov	dword ptr  stCFG+01fh,eax

; 703       if (bCOMscopeEnabled && (hCom != 0xffffffff))
	cmp	dword ptr  bCOMscopeEnabled,0h
	je	@BLBL179
	cmp	dword ptr  hCom,0ffffffffh
	je	@BLBL179

; 704         EnableCOMscope(hwnd,hCom,&ulCOMscopeBufferSize,stCFG.fTraceEvent);
	mov	ax,word ptr  stCFG+01fh
	push	eax
	push	offset FLAT:ulCOMscopeBufferSize
	push	dword ptr  hCom
	push	dword ptr [ebp+08h];	hwnd
	call	EnableCOMscope
	add	esp,010h
@BLBL179:

; 705       if (--lStatusWindowCount <= 0)
	mov	eax,dword ptr  lStatusWindowCount
	dec	eax
	mov	dword ptr  lStatusWindowCount,eax
	cmp	dword ptr  lStatusWindowCount,0h
	jg	@BLBL180

; 706         MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,FALSE);
	push	0h
	push	081ch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
@BLBL180:

; 707       if (idTimer)
	cmp	dword ptr  @87idTimer,0h
	je	@BLBL181

; 708         {
; 709         WinStopTimer(habAnchorBlock,
	push	dword ptr  @87idTimer
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStopTimer
	add	esp,0ch

; 710                      hwnd,
; 711                      idTimer);
; 712         idTimer = 0L;
	mov	dword ptr  @87idTimer,0h

; 713         }
@BLBL181:

; 714       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
@BLBL196:

; 715     case UM_RESETTIMER:
; 716       if (idTimer != 0L)
	cmp	dword ptr  @87idTimer,0h
	je	@BLBL182

; 717         idTimer = WinStartTimer(habAnchorBlock,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	push	dword ptr  @87idTimer
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStartTimer
	add	esp,010h
	mov	dword ptr  @87idTimer,eax
@BLBL182:

; 718                               hwnd,
; 719                               idTimer,
; 720                               stCFG.wUpdateDelay);
; 721       break;
	jmp	@BLBL189
	align 04h
@BLBL197:

; 722     case WM_TIMER:
; 723       UpdateRcvBufferStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateRcvBufferStatusDlg
	add	esp,04h

; 724       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL198:

; 725     case WM_CHAR:
; 726       if ((sCurrentFocus != 0) && (SHORT1FROMMP(mp1) & KC_CHAR) && (SHORT1FROMMP(mp2) == ' '))
	cmp	word ptr  @89sCurrentFocus,0h
	je	@BLBL183
	mov	ax,[ebp+010h];	mp1
	test	al,01h
	je	@BLBL183
	mov	ax,[ebp+014h];	mp2
	cmp	ax,020h
	jne	@BLBL183

; 727         ResetHighWater();
	call	ResetHighWater
	jmp	@BLBL184
	align 010h
@BLBL183:

; 728       else
; 729         return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
@BLBL184:

; 730       break;
	jmp	@BLBL189
	align 04h
@BLBL199:

; 731     case WM_BUTTON1UP:
; 732       if (sCurrentFocus != 0)
	cmp	word ptr  @89sCurrentFocus,0h
	je	@BLBL185

; 733         ResetHighWater();
	call	ResetHighWater
	jmp	@BLBL186
	align 010h
@BLBL185:

; 734       else
; 735         return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
@BLBL186:

; 736       break;
	jmp	@BLBL189
	align 04h
@BLBL200:

; 737     case WM_CONTROL:
; 738       switch (SHORT2FROMMP(mp1))
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	and	eax,0ffffh
	jmp	@BLBL202
	align 04h
@BLBL203:

; 739         {
; 740         case EN_SETFOCUS:
; 741           if (SHORT1FROMMP(mp1) == HWS_BUFHIGH)
	mov	ax,[ebp+010h];	mp1
	cmp	ax,04a93h
	jne	@BLBL187

; 742             sCurrentFocus = SHORT1FROMMP(mp1);
	mov	eax,[ebp+010h];	mp1
	mov	word ptr  @89sCurrentFocus,ax
@BLBL187:

; 743           break;
	jmp	@BLBL201
	align 04h
@BLBL204:

; 744         case EN_KILLFOCUS:
; 745           sCurrentFocus = 0;
	mov	word ptr  @89sCurrentFocus,0h

; 746           break;
	jmp	@BLBL201
	align 04h
	jmp	@BLBL201
	align 04h
@BLBL202:
	cmp	eax,01h
	je	@BLBL203
	cmp	eax,02h
	je	@BLBL204
@BLBL201:

; 747         }
; 748       break;
	jmp	@BLBL189
	align 04h
@BLBL205:

; 749     case WM_ACTIVATE:
; 750       if (bRBstatusActivated)
	cmp	dword ptr  bRBstatusActivated,0h
	je	@BLBL188

; 751         WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h
@BLBL188:

; 752       break;
	jmp	@BLBL189
	align 04h
@BLBL206:

; 753     default:
; 754       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
	jmp	@BLBL189
	align 04h
@BLBL190:
	cmp	eax,03bh
	je	@BLBL191
	cmp	eax,08002h
	je	@BLBL192
	cmp	eax,08022h
	je	@BLBL193
	cmp	eax,029h
	je	@BLBL194
	cmp	eax,0800ch
	je	@BLBL195
	cmp	eax,08007h
	je	@BLBL196
	cmp	eax,024h
	je	@BLBL197
	cmp	eax,07ah
	je	@BLBL198
	cmp	eax,072h
	je	@BLBL199
	cmp	eax,030h
	je	@BLBL200
	cmp	eax,0dh
	je	@BLBL205
	jmp	@BLBL206
	align 04h
@BLBL189:

; 755     }
; 756   return FALSE;
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpRcvBufferStatusDlg	endp

; 760   {
	align 010h

	public fnwpModemInStatusDlg
fnwpModemInStatusDlg	proc
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

; 764   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL217
	align 04h
@BLBL218:

; 765     {
; 766     case WM_INITDLG:
; 767       SetSystemMenu(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	SetSystemMenu
	add	esp,04h

; 768       WinSendDlgItemMsg(hwnd,HWS_DCD,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
	push	0h
	push	01h
	push	014bh
	push	0647h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 769       WinSendDlgItemMsg(hwnd,HWS_RING,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
	push	0h
	push	01h
	push	014bh
	push	064fh
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 770       WinSendDlgItemMsg(hwnd,HWS_DSR,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
	push	0h
	push	01h
	push	014bh
	push	0648h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 771       WinSendDlgItemMsg(hwnd,HWS_CTS,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
	push	0h
	push	01h
	push	014bh
	push	0649h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 772 //      CenterDlgBox(hwnd);
; 773       idTimer = 0L;
	mov	dword ptr  @99idTimer,0h

; 774       break;
	jmp	@BLBL216
	align 04h
@BLBL219:

; 775     case UM_INITLS:
; 776       if (!bMIstatusActivated)
	cmp	dword ptr  bMIstatusActivated,0h
	jne	@BLBL207

; 777         {
; 778         bMIstatusActivated = TRUE;
	mov	dword ptr  bMIstatusActivated,01h

; 779         if (lStatusWindowCount++ <= 0)
	cmp	dword ptr  lStatusWindowCount,0h
	jg	@BLBL208
	mov	eax,dword ptr  lStatusWindowCount
	inc	eax
	mov	dword ptr  lStatusWindowCount,eax

; 780           MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,TRUE);
	push	01h
	push	081ch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
	jmp	@BLBL209
	align 010h
@BLBL208:
	mov	eax,dword ptr  lStatusWindowCount
	inc	eax
	mov	dword ptr  lStatusWindowCount,eax
@BLBL209:

; 781         if (stCFG.bLoadWindowPosition && (hProfileInstance != NULL) && (stCFG.ptlMIstatusPos.y > -40))
	test	byte ptr  stCFG+017h,040h
	je	@BLBL210
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL210
	cmp	dword ptr  stCFG+051h,0ffffffd8h
	jle	@BLBL210

; 782           WinSetWindowPos(hwnd,HWND_TOP,stCFG.ptlMIstatusPos.x,stCFG.ptlMIstatusPos.y,0L,0L,SWP_MOVE);
	push	02h
	push	0h
	push	0h
	push	dword ptr  stCFG+051h
	push	dword ptr  stCFG+04dh
	push	03h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowPos
	add	esp,01ch
	jmp	@BLBL211
	align 010h
@BLBL210:

; 783         else
; 784           MousePosDlgBox(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	MousePosDlgBox
	add	esp,04h
@BLBL211:

; 785         WinShowWindow(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinShowWindow
	add	esp,08h

; 786         WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h

; 787         }
@BLBL207:

; 788       UpdateModemInputStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateModemInputStatusDlg
	add	esp,04h

; 789       idTimer = WinStartTimer(habAnchorBlock,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	push	07ffah
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStartTimer
	add	esp,010h
	mov	dword ptr  @99idTimer,eax
@BLBL220:

; 790                               hwnd,
; 791                               TID_STATMDMIN,
; 792                               stCFG.wUpdateDelay);
; 793     case UM_RESET_NAME:
; 794       sprintf(szCaption,"%s - Modem In",stCFG.szPortName);
	push	offset FLAT:stCFG+02h
	mov	edx,offset FLAT:@STAT6
	lea	eax,[ebp-050h];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 795       WinSetWindowText(hwnd,szCaption);
	lea	eax,[ebp-050h];	szCaption
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowText
	add	esp,08h

; 796       break;
	jmp	@BLBL216
	align 04h
@BLBL221:
@BLBL222:

; 797     case WM_CLOSE:
; 798     case UM_KILL_MONITOR:
; 799       if (--lStatusWindowCount <= 0)
	mov	eax,dword ptr  lStatusWindowCount
	dec	eax
	mov	dword ptr  lStatusWindowCount,eax
	cmp	dword ptr  lStatusWindowCount,0h
	jg	@BLBL212

; 800         MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,FALSE);
	push	0h
	push	081ch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
@BLBL212:

; 801       bMIstatusActivated = FALSE;
	mov	dword ptr  bMIstatusActivated,0h

; 802       if (idTimer)
	cmp	dword ptr  @99idTimer,0h
	je	@BLBL213

; 803         {
; 804         WinStopTimer(habAnchorBlock,
	push	dword ptr  @99idTimer
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStopTimer
	add	esp,0ch

; 805                      hwnd,
; 806                      idTimer);
; 807         idTimer = 0L;
	mov	dword ptr  @99idTimer,0h

; 808         }
@BLBL213:

; 809       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
@BLBL223:

; 810     case UM_RESETTIMER:
; 811       if (idTimer != 0L)
	cmp	dword ptr  @99idTimer,0h
	je	@BLBL214

; 812         idTimer = WinStartTimer(habAnchorBlock,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	push	dword ptr  @99idTimer
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStartTimer
	add	esp,010h
	mov	dword ptr  @99idTimer,eax
@BLBL214:

; 813                               hwnd,
; 814                               idTimer,
; 815                               stCFG.wUpdateDelay);
; 816       break;
	jmp	@BLBL216
	align 04h
@BLBL224:

; 817     case WM_TIMER:
; 818       UpdateModemInputStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateModemInputStatusDlg
	add	esp,04h

; 819       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL225:

; 820     case WM_ACTIVATE:
; 821       if (bMIstatusActivated)
	cmp	dword ptr  bMIstatusActivated,0h
	je	@BLBL215

; 822         WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h
@BLBL215:

; 823       break;
	jmp	@BLBL216
	align 04h
@BLBL226:

; 824     default:
; 825       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
	jmp	@BLBL216
	align 04h
@BLBL217:
	cmp	eax,03bh
	je	@BLBL218
	cmp	eax,08002h
	je	@BLBL219
	cmp	eax,08022h
	je	@BLBL220
	cmp	eax,029h
	je	@BLBL221
	cmp	eax,0800ch
	je	@BLBL222
	cmp	eax,08007h
	je	@BLBL223
	cmp	eax,024h
	je	@BLBL224
	cmp	eax,0dh
	je	@BLBL225
	jmp	@BLBL226
	align 04h
@BLBL216:

; 826     }
; 827   return FALSE;
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpModemInStatusDlg	endp

; 831   {
	align 010h

	public fnwpModemOutStatusDlg
fnwpModemOutStatusDlg	proc
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

; 835   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL237
	align 04h
@BLBL238:

; 836     {
; 837     case WM_INITDLG:
; 838       SetSystemMenu(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	SetSystemMenu
	add	esp,04h

; 839       WinSendDlgItemMsg(hwnd,HWS_DTR,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
	push	0h
	push	01h
	push	014bh
	push	0645h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 840       WinSendDlgItemMsg(hwnd,HWS_RTS,EM_SETREADONLY,MPFROMSHORT(TRUE),(MPARAM)NULL);
	push	0h
	push	01h
	push	014bh
	push	0646h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 841 //      CenterDlgBox(hwnd);
; 842       idTimer = 0L;
	mov	dword ptr  @a3idTimer,0h

; 843       break;
	jmp	@BLBL236
	align 04h
@BLBL239:

; 844     case UM_INITLS:
; 845       if (!bMOstatusActivated)
	cmp	dword ptr  bMOstatusActivated,0h
	jne	@BLBL227

; 846         {
; 847         bMOstatusActivated = TRUE;
	mov	dword ptr  bMOstatusActivated,01h

; 848         if (lStatusWindowCount++ <= 0)
	cmp	dword ptr  lStatusWindowCount,0h
	jg	@BLBL228
	mov	eax,dword ptr  lStatusWindowCount
	inc	eax
	mov	dword ptr  lStatusWindowCount,eax

; 849           MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,TRUE);
	push	01h
	push	081ch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
	jmp	@BLBL229
	align 010h
@BLBL228:
	mov	eax,dword ptr  lStatusWindowCount
	inc	eax
	mov	dword ptr  lStatusWindowCount,eax
@BLBL229:

; 850         if (stCFG.bLoadWindowPosition && (hProfileInstance != NULL) && (stCFG.ptlMOstatusPos.y > -40))
	test	byte ptr  stCFG+017h,040h
	je	@BLBL230
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL230
	cmp	dword ptr  stCFG+059h,0ffffffd8h
	jle	@BLBL230

; 851           WinSetWindowPos(hwnd,HWND_TOP,stCFG.ptlMOstatusPos.x,stCFG.ptlMOstatusPos.y,0L,0L,SWP_MOVE);
	push	02h
	push	0h
	push	0h
	push	dword ptr  stCFG+059h
	push	dword ptr  stCFG+055h
	push	03h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowPos
	add	esp,01ch
	jmp	@BLBL231
	align 010h
@BLBL230:

; 852         else
; 853           MousePosDlgBox(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	MousePosDlgBox
	add	esp,04h
@BLBL231:

; 854         WinShowWindow(hwnd,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinShowWindow
	add	esp,08h

; 855         WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h

; 856         }
@BLBL227:

; 857       UpdateModemOutputStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateModemOutputStatusDlg
	add	esp,04h

; 858       idTimer = WinStartTimer(habAnchorBlock,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	push	07ff9h
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStartTimer
	add	esp,010h
	mov	dword ptr  @a3idTimer,eax
@BLBL240:

; 859                               hwnd,
; 860                               TID_STATMDMOUT,
; 861                               stCFG.wUpdateDelay);
; 862     case UM_RESET_NAME:
; 863       sprintf(szCaption,"%s - Modem Out",stCFG.szPortName);
	push	offset FLAT:stCFG+02h
	mov	edx,offset FLAT:@STAT7
	lea	eax,[ebp-050h];	szCaption
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 864       WinSetWindowText(hwnd,szCaption);
	lea	eax,[ebp-050h];	szCaption
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowText
	add	esp,08h

; 865       break;
	jmp	@BLBL236
	align 04h
@BLBL241:
@BLBL242:

; 866     case WM_CLOSE:
; 867     case UM_KILL_MONITOR:
; 868       bMOstatusActivated = FALSE;
	mov	dword ptr  bMOstatusActivated,0h

; 869       if (--lStatusWindowCount <= 0)
	mov	eax,dword ptr  lStatusWindowCount
	dec	eax
	mov	dword ptr  lStatusWindowCount,eax
	cmp	dword ptr  lStatusWindowCount,0h
	jg	@BLBL232

; 870         MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,FALSE);
	push	0h
	push	081ch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch
@BLBL232:

; 871       if (idTimer)
	cmp	dword ptr  @a3idTimer,0h
	je	@BLBL233

; 872         {
; 873         WinStopTimer(habAnchorBlock,
	push	dword ptr  @a3idTimer
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStopTimer
	add	esp,0ch

; 874                      hwnd,
; 875                      idTimer);
; 876         idTimer = 0L;
	mov	dword ptr  @a3idTimer,0h

; 877         }
@BLBL233:

; 878       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
@BLBL243:

; 879     case UM_RESETTIMER:
; 880       if (idTimer != 0L)
	cmp	dword ptr  @a3idTimer,0h
	je	@BLBL234

; 881         idTimer = WinStartTimer(habAnchorBlock,
	xor	eax,eax
	mov	ax,word ptr  stCFG+0cfh
	push	eax
	push	dword ptr  @a3idTimer
	push	dword ptr [ebp+08h];	hwnd
	mov	eax,dword ptr  habAnchorBlock
	push	eax
	call	WinStartTimer
	add	esp,010h
	mov	dword ptr  @a3idTimer,eax
@BLBL234:

; 882                               hwnd,
; 883                               idTimer,
; 884                               stCFG.wUpdateDelay);
; 885       break;
	jmp	@BLBL236
	align 04h
@BLBL244:

; 886     case WM_TIMER:
; 887       UpdateModemOutputStatusDlg(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	UpdateModemOutputStatusDlg
	add	esp,04h

; 888       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL245:

; 889     case WM_ACTIVATE:
; 890       if (bMOstatusActivated)
	cmp	dword ptr  bMOstatusActivated,0h
	je	@BLBL235

; 891         WinSetFocus(HWND_DESKTOP,hwnd);
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinSetFocus
	add	esp,08h
@BLBL235:

; 892       break;
	jmp	@BLBL236
	align 04h
@BLBL246:

; 893     default:
; 894       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
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
	jmp	@BLBL236
	align 04h
@BLBL237:
	cmp	eax,03bh
	je	@BLBL238
	cmp	eax,08002h
	je	@BLBL239
	cmp	eax,08022h
	je	@BLBL240
	cmp	eax,029h
	je	@BLBL241
	cmp	eax,0800ch
	je	@BLBL242
	cmp	eax,08007h
	je	@BLBL243
	cmp	eax,024h
	je	@BLBL244
	cmp	eax,0dh
	je	@BLBL245
	jmp	@BLBL246
	align 04h
@BLBL236:

; 895     }
; 896   return FALSE;
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
fnwpModemOutStatusDlg	endp

; 900   {
	align 010h

	public UpdateXmitBufferStatusDlg
UpdateXmitBufferStatusDlg	proc
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

; 906   if (GetTransmitQueueLen(&stIOctl,hCom,&wQueueLength,&wByteCount) != NO_ERROR)
	lea	eax,[ebp-02h];	wByteCount
	push	eax
	lea	eax,[ebp-04h];	wQueueLength
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetTransmitQueueLen
	add	esp,010h
	test	eax,eax
	je	@BLBL247

; 907     {
; 908     WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatAll
	call	WinPostMsg
	add	esp,010h

; 909     WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatDev
	call	WinPostMsg
	add	esp,010h

; 910     }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL247:

; 911   else
; 912     {
; 913     ulTemp = (ULONG)wByteCount * 100;
	xor	eax,eax
	mov	ax,[ebp-02h];	wByteCount
	imul	eax,064h
	mov	[ebp-08h],eax;	ulTemp

; 914     ulTemp /= (ULONG)wQueueLength;
	xor	ecx,ecx
	mov	cx,[ebp-04h];	wQueueLength
	mov	eax,[ebp-08h];	ulTemp
	xor	edx,edx
	div	ecx
	mov	[ebp-08h],eax;	ulTemp

; 915     ltoa(ulTemp,szSize,10);
	mov	ecx,0ah
	lea	edx,[ebp-012h];	szSize
	mov	eax,[ebp-08h];	ulTemp
	call	_ltoa

; 916     WinSetDlgItemText(hwnd,HWS_BUFLEV,szSize);
	lea	eax,[ebp-012h];	szSize
	push	eax
	push	04a94h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 917     ltoa((LONG)wByteCount,szSize,10);
	mov	ecx,0ah
	lea	edx,[ebp-012h];	szSize
	xor	eax,eax
	mov	ax,[ebp-02h];	wByteCount
	call	_ltoa

; 918     WinSetDlgItemText(hwnd,HWS_BUFLEN,szSize);
	lea	eax,[ebp-012h];	szSize
	push	eax
	push	04a92h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 919     }

; 920   }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
UpdateXmitBufferStatusDlg	endp

; 923   {
	align 010h

	public UpdateRcvBufferStatusDlg
UpdateRcvBufferStatusDlg	proc
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

; 929   if (GetReceiveQueueCounts(&stIOctl,hCom,&stCounts) != NO_ERROR)
	lea	eax,[ebp-08h];	stCounts
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetReceiveQueueCounts
	add	esp,0ch
	test	eax,eax
	je	@BLBL249

; 930     {
; 931     WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatAll
	call	WinPostMsg
	add	esp,010h

; 932     WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatDev
	call	WinPostMsg
	add	esp,010h

; 933     }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL249:

; 934   else
; 935     {
; 936     if (stCounts.wQueueLen == 0)
	cmp	word ptr [ebp-06h],0h;	stCounts
	jne	@BLBL251

; 937       ulQueueLength = 0x10000;
	mov	dword ptr [ebp-0ch],010000h;	ulQueueLength
	jmp	@BLBL252
	align 010h
@BLBL251:

; 938     else
; 939       ulQueueLength = (ULONG)stCounts.wQueueLen;
	xor	eax,eax
	mov	ax,[ebp-06h];	stCounts
	mov	[ebp-0ch],eax;	ulQueueLength
@BLBL252:

; 940     ulTemp = (ULONG)stCounts.wByteCount * 100;
	xor	eax,eax
	mov	ax,[ebp-08h];	stCounts
	imul	eax,064h
	mov	[ebp-010h],eax;	ulTemp

; 941     ulTemp /= ulQueueLength;
	mov	eax,[ebp-010h];	ulTemp
	xor	edx,edx
	div	dword ptr [ebp-0ch];	ulQueueLength
	mov	[ebp-010h],eax;	ulTemp

; 942     ltoa(ulTemp,szSize,10);
	mov	ecx,0ah
	lea	edx,[ebp-024h];	szSize
	mov	eax,[ebp-010h];	ulTemp
	call	_ltoa

; 943     WinSetDlgItemText(hwnd,HWS_BUFLEV,szSize);
	lea	eax,[ebp-024h];	szSize
	push	eax
	push	04a94h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 944     ltoa((LONG)stCounts.wByteCount,szSize,10);
	mov	ecx,0ah
	lea	edx,[ebp-024h];	szSize
	xor	eax,eax
	mov	ax,[ebp-08h];	stCounts
	call	_ltoa

; 945     WinSetDlgItemText(hwnd,HWS_BUFLEN,szSize);
	lea	eax,[ebp-024h];	szSize
	push	eax
	push	04a92h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 946     ltoa((LONG)stCounts.dwQueueHigh,szSize,10);
	mov	ecx,0ah
	lea	edx,[ebp-024h];	szSize
	mov	eax,[ebp-04h];	stCounts
	call	_ltoa

; 947     WinSetDlgItemText(hwnd,HWS_BUFHIGH,szSize);
	lea	eax,[ebp-024h];	szSize
	push	eax
	push	04a93h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 948     }

; 949   }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
UpdateRcvBufferStatusDlg	endp

; 952   {
	align 010h

	public UpdateBufferStatusDlg
UpdateBufferStatusDlg	proc
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

; 959   if (GetTransmitQueueLen(&stIOctl,hCom,&wQueueLength,&wByteCount) != NO_ERROR)
	lea	eax,[ebp-02h];	wByteCount
	push	eax
	lea	eax,[ebp-04h];	wQueueLength
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetTransmitQueueLen
	add	esp,010h
	test	eax,eax
	je	@BLBL253

; 960     {
; 961     WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatAll
	call	WinPostMsg
	add	esp,010h

; 962     WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatDev
	call	WinPostMsg
	add	esp,010h

; 963     }
	jmp	@BLBL254
	align 010h
@BLBL253:

; 964   else
; 965     {
; 966     ulTemp = (ULONG)wByteCount * 100;
	xor	eax,eax
	mov	ax,[ebp-02h];	wByteCount
	imul	eax,064h
	mov	[ebp-0ch],eax;	ulTemp

; 967     ulTemp /= (ULONG)wQueueLength;
	xor	ecx,ecx
	mov	cx,[ebp-04h];	wQueueLength
	mov	eax,[ebp-0ch];	ulTemp
	xor	edx,edx
	div	ecx
	mov	[ebp-0ch],eax;	ulTemp

; 968     ltoa(ulTemp,szSize,10);
	mov	ecx,0ah
	lea	edx,[ebp-016h];	szSize
	mov	eax,[ebp-0ch];	ulTemp
	call	_ltoa

; 969     WinSetDlgItemText(hwnd,HWS_XMITBUFLEV,szSize);
	lea	eax,[ebp-016h];	szSize
	push	eax
	push	064dh
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 970     ltoa((LONG)wByteCount,szSize,10);
	mov	ecx,0ah
	lea	edx,[ebp-016h];	szSize
	xor	eax,eax
	mov	ax,[ebp-02h];	wByteCount
	call	_ltoa

; 971     WinSetDlgItemText(hwnd,HWS_XMITBUFLEN,szSize);
	lea	eax,[ebp-016h];	szSize
	push	eax
	push	064ch
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 972     }
@BLBL254:

; 973   if (GetReceiveQueueLen(&stIOctl,hCom,&wQueueLength,&wByteCount) != NO_ERROR)
	lea	eax,[ebp-02h];	wByteCount
	push	eax
	lea	eax,[ebp-04h];	wQueueLength
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetReceiveQueueLen
	add	esp,010h
	test	eax,eax
	je	@BLBL255

; 974     {
; 975     WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatAll
	call	WinPostMsg
	add	esp,010h

; 976     WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatDev
	call	WinPostMsg
	add	esp,010h

; 977     }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL255:

; 978   else
; 979     {
; 980     if (wQueueLength == 0)
	cmp	word ptr [ebp-04h],0h;	wQueueLength
	jne	@BLBL257

; 981       ulQueueLength = 0x10000;
	mov	dword ptr [ebp-08h],010000h;	ulQueueLength
	jmp	@BLBL258
	align 010h
@BLBL257:

; 982     else
; 983       ulQueueLength = (ULONG)wQueueLength;
	xor	eax,eax
	mov	ax,[ebp-04h];	wQueueLength
	mov	[ebp-08h],eax;	ulQueueLength
@BLBL258:

; 984     ulTemp = (ULONG)wByteCount * 100;
	xor	eax,eax
	mov	ax,[ebp-02h];	wByteCount
	imul	eax,064h
	mov	[ebp-0ch],eax;	ulTemp

; 985     ulTemp /= ulQueueLength;
	mov	eax,[ebp-0ch];	ulTemp
	xor	edx,edx
	div	dword ptr [ebp-08h];	ulQueueLength
	mov	[ebp-0ch],eax;	ulTemp

; 986     ltoa(ulTemp,szSize,10);
	mov	ecx,0ah
	lea	edx,[ebp-016h];	szSize
	mov	eax,[ebp-0ch];	ulTemp
	call	_ltoa

; 987     WinSetDlgItemText(hwnd,HWS_RCVBUFLEV,szSize);
	lea	eax,[ebp-016h];	szSize
	push	eax
	push	0658h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 988     ltoa((LONG)wByteCount,szSize,10);
	mov	ecx,0ah
	lea	edx,[ebp-016h];	szSize
	xor	eax,eax
	mov	ax,[ebp-02h];	wByteCount
	call	_ltoa

; 989     WinSetDlgItemText(hwnd,HWS_RCVBUFLEN,szSize);
	lea	eax,[ebp-016h];	szSize
	push	eax
	push	064bh
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 990     }

; 991   }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
UpdateBufferStatusDlg	endp

; 994   {
	align 010h

	public UpdateDeviceStatusDlg
UpdateDeviceStatusDlg	proc
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

; 1001   if (GetCOMstatus(&stIOctl,hCom,&byStatus) != NO_ERROR)
	lea	eax,[ebp-0fh];	byStatus
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetCOMstatus
	add	esp,0ch
	test	eax,eax
	je	@BLBL259

; 1002     {
; 1003     WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatAll
	call	WinPostMsg
	add	esp,010h

; 1004     WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatDev
	call	WinPostMsg
	add	esp,010h

; 1005     }
	jmp	@BLBL260
	align 010h
@BLBL259:

; 1006   else
; 1007     {
; 1008     sprintf(szStatus,"%02X",byStatus);
	xor	eax,eax
	mov	al,[ebp-0fh];	byStatus
	push	eax
	mov	edx,offset FLAT:@STAT8
	lea	eax,[ebp-0ah];	szStatus
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1009     WinSetDlgItemText(hwnd,HWS_COMST,szStatus);
	lea	eax,[ebp-0ah];	szStatus
	push	eax
	push	0644h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 1010     }
@BLBL260:

; 1011 
; 1012   if ((rc = GetNoClearComEvent_ComError(hCom,&wEvent,&wStatus)) != NO_ERROR)
	lea	eax,[ebp-0eh];	wStatus
	push	eax
	lea	eax,[ebp-0ch];	wEvent
	push	eax
	push	dword ptr  hCom
	call	GetNoClearComEvent_ComError
	add	esp,0ch
	mov	[ebp-014h],eax;	rc
	cmp	dword ptr [ebp-014h],0h;	rc
	je	@BLBL261

; 1013     {
; 1014     if ((rc = GetCOMevent(&stIOctl,hCom,&wEvent)) != NO_ERROR)
	lea	eax,[ebp-0ch];	wEvent
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetCOMevent
	add	esp,0ch
	mov	[ebp-014h],eax;	rc
	cmp	dword ptr [ebp-014h],0h;	rc
	je	@BLBL261

; 1015       rc = GetCOMerror(&stIOctl,hCom,&wStatus);
	lea	eax,[ebp-0eh];	wStatus
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetCOMerror
	add	esp,0ch
	mov	[ebp-014h],eax;	rc

; 1016     }
@BLBL261:

; 1017   if (rc != NO_ERROR)
	cmp	dword ptr [ebp-014h],0h;	rc
	je	@BLBL263

; 1018     {
; 1019     WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatAll
	call	WinPostMsg
	add	esp,010h

; 1020     WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatDev
	call	WinPostMsg
	add	esp,010h

; 1021     }
	jmp	@BLBL264
	align 010h
@BLBL263:

; 1022   else
; 1023     {
; 1024     sprintf(szStatus,"%04X",
; 1024 wStatus);
	xor	eax,eax
	mov	ax,[ebp-0eh];	wStatus
	push	eax
	mov	edx,offset FLAT:@STAT9
	lea	eax,[ebp-0ah];	szStatus
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1025     WinSetDlgItemText(hwnd,HWS_COMERROR,szStatus);
	lea	eax,[ebp-0ah];	szStatus
	push	eax
	push	0642h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 1026 
; 1027     sprintf(szStatus,"%04X",wEvent);
	xor	eax,eax
	mov	ax,[ebp-0ch];	wEvent
	push	eax
	mov	edx,offset FLAT:@STATa
	lea	eax,[ebp-0ah];	szStatus
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1028     WinSetDlgItemText(hwnd,HWS_COMEVENT,szStatus);
	lea	eax,[ebp-0ah];	szStatus
	push	eax
	push	0641h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 1029     }
@BLBL264:

; 1030 
; 1031   if (GetXmitStatus(&stIOctl,hCom,&byStatus) != NO_ERROR)
	lea	eax,[ebp-0fh];	byStatus
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetXmitStatus
	add	esp,0ch
	test	eax,eax
	je	@BLBL265

; 1032     {
; 1033     WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatAll
	call	WinPostMsg
	add	esp,010h

; 1034     WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatDev
	call	WinPostMsg
	add	esp,010h

; 1035     }
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL265:

; 1036   else
; 1037     {
; 1038     sprintf(szStatus,"%02X",byStatus);
	xor	eax,eax
	mov	al,[ebp-0fh];	byStatus
	push	eax
	mov	edx,offset FLAT:@STATb
	lea	eax,[ebp-0ah];	szStatus
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1039     WinSetDlgItemText(hwnd,HWS_XMITST,szStatus);
	lea	eax,[ebp-0ah];	szStatus
	push	eax
	push	0643h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 1040     }

; 1041   }
	mov	esp,ebp
	pop	ebp
	ret	
UpdateDeviceStatusDlg	endp

; 1044   {
	align 010h

	public UpdateModemOutputStatusDlg
UpdateModemOutputStatusDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax
	sub	esp,08h

; 1048   if (GetModemOutputSignals(&stIOctl,hCom,&byOutputSignals) != NO_ERROR)
	lea	eax,[ebp-05h];	byOutputSignals
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetModemOutputSignals
	add	esp,0ch
	test	eax,eax
	je	@BLBL267

; 1049     {
; 1050     WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatAll
	call	WinPostMsg
	add	esp,010h

; 1051     WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatDev
	call	WinPostMsg
	add	esp,010h

; 1052     }
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL267:

; 1053   else
; 1054     {
; 1055     if (byOutputSignals & 0x01)
	test	byte ptr [ebp-05h],01h;	byOutputSignals
	je	@BLBL269

; 1056       strcpy(szState,szOn);
	mov	edx,offset FLAT:szOn
	lea	eax,[ebp-04h];	szState
	call	strcpy
	jmp	@BLBL270
	align 010h
@BLBL269:

; 1057     else
; 1058       strcpy(szState,szOff);
	mov	edx,offset FLAT:szOff
	lea	eax,[ebp-04h];	szState
	call	strcpy
@BLBL270:

; 1059     WinSetDlgItemText(hwnd,HWS_DTR,szState);
	lea	eax,[ebp-04h];	szState
	push	eax
	push	0645h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 1060 
; 1061     if (byOutputSignals & 0x02)
	test	byte ptr [ebp-05h],02h;	byOutputSignals
	je	@BLBL271

; 1062       strcpy(szState,szOn);
	mov	edx,offset FLAT:szOn
	lea	eax,[ebp-04h];	szState
	call	strcpy
	jmp	@BLBL272
	align 010h
@BLBL271:

; 1063     else
; 1064       strcpy(szState,szOff);
	mov	edx,offset FLAT:szOff
	lea	eax,[ebp-04h];	szState
	call	strcpy
@BLBL272:

; 1065     WinSetDlgItemText(hwnd,HWS_RTS,szState);
	lea	eax,[ebp-04h];	szState
	push	eax
	push	0646h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 1066     }

; 1067   }
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
UpdateModemOutputStatusDlg	endp

; 1070   {
	align 010h

	public UpdateModemInputStatusDlg
UpdateModemInputStatusDlg	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax
	sub	esp,08h

; 1074   if (GetModemInputSignals(&stIOctl,hCom,&byInputSignals) != NO_ERROR)
	lea	eax,[ebp-05h];	byInputSignals
	push	eax
	push	dword ptr  hCom
	push	offset FLAT:stIOctl
	call	GetModemInputSignals
	add	esp,0ch
	test	eax,eax
	je	@BLBL273

; 1075     {
; 1076     WinPostMsg(hwndStatAll,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatAll
	call	WinPostMsg
	add	esp,010h

; 1077     WinPostMsg(hwndStatDev,UM_KILL_MONITOR,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	0800ch
	push	dword ptr  hwndStatDev
	call	WinPostMsg
	add	esp,010h

; 1078     }
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL273:

; 1079   else
; 1080     {
; 1081     if (byInputSignals & 0x80)
	test	byte ptr [ebp-05h],080h;	byInputSignals
	je	@BLBL275

; 1082       strcpy(szState,szOn);
	mov	edx,offset FLAT:szOn
	lea	eax,[ebp-04h];	szState
	call	strcpy
	jmp	@BLBL276
	align 010h
@BLBL275:

; 1083     else
; 1084       strcpy(szState,szOff);
	mov	edx,offset FLAT:szOff
	lea	eax,[ebp-04h];	szState
	call	strcpy
@BLBL276:

; 1085     WinSetDlgItemText(hwnd,HWS_DCD,szState);
	lea	eax,[ebp-04h];	szState
	push	eax
	push	0647h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 1086 
; 1087     if (byInputSignals & 0x40)
	test	byte ptr [ebp-05h],040h;	byInputSignals
	je	@BLBL277

; 1088       strcpy(szState,szOn);
	mov	edx,offset FLAT:szOn
	lea	eax,[ebp-04h];	szState
	call	strcpy
	jmp	@BLBL278
	align 010h
@BLBL277:

; 1089     else
; 1090       strcpy(szState,szOff);
	mov	edx,offset FLAT:szOff
	lea	eax,[ebp-04h];	szState
	call	strcpy
@BLBL278:

; 1091     WinSetDlgItemText(hwnd,HWS_RING,szState);
	lea	eax,[ebp-04h];	szState
	push	eax
	push	064fh
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 1092 
; 1093     if (byInputSignals & 0x20)
	test	byte ptr [ebp-05h],020h;	byInputSignals
	je	@BLBL279

; 1094       strcpy(szState,szOn);
	mov	edx,offset FLAT:szOn
	lea	eax,[ebp-04h];	szState
	call	strcpy
	jmp	@BLBL280
	align 010h
@BLBL279:

; 1095     else
; 1096       strcpy(szState,szOff);
	mov	edx,offset FLAT:szOff
	lea	eax,[ebp-04h];	szState
	call	strcpy
@BLBL280:

; 1097     WinSetDlgItemText(hwnd,HWS_DSR,szState);
	lea	eax,[ebp-04h];	szState
	push	eax
	push	0648h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 1098 
; 1099     if (byInputSignals & 0x10)
	test	byte ptr [ebp-05h],010h;	byInputSignals
	je	@BLBL281

; 1100       strcpy(szState,szOn);
	mov	edx,offset FLAT:szOn
	lea	eax,[ebp-04h];	szState
	call	strcpy
	jmp	@BLBL282
	align 010h
@BLBL281:

; 1101     else
; 1102       strcpy(szState,szOff);
	mov	edx,offset FLAT:szOff
	lea	eax,[ebp-04h];	szState
	call	strcpy
@BLBL282:

; 1103     WinSetDlgItemText(hwnd,HWS_CTS,szState);
	lea	eax,[ebp-04h];	szState
	push	eax
	push	0649h
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetDlgItemText
	add	esp,0ch

; 1104     }

; 1105   }
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
UpdateModemInputStatusDlg	endp
CODE32	ends
end
