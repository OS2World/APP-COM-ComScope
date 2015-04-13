	title	p:\config\dev_notebk.c
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
	extrn	WinWindowFromID:proc
	extrn	WinQueryPointer:proc
	extrn	WinQuerySysPointer:proc
	extrn	WinSetPointer:proc
	extrn	WinSendMsg:proc
	extrn	memset:proc
	extrn	memcpy:proc
	extrn	fnwpPortConfigDeviceDlgProc:proc
	extrn	fnwpCfgTimeoutDlg:proc
	extrn	strcpy:proc
	extrn	fnwpCfgProtocolDlg:proc
	extrn	fnwpCfgBaudRateDlg:proc
	extrn	fnwpCfgASCIIhandshakeDlg:proc
	extrn	fnwpCfgHDWhandshakeDlg:proc
	extrn	fnwpDefThresholdDlg:proc
	extrn	fnwpCfgFilterDlg:proc
	extrn	fnwpHdwDefFIFOsetupDlg:proc
	extrn	fnwpReceiveBuffDlgProc:proc
	extrn	fnwpTransmitBuffDlgProc:proc
	extrn	fnwpCOMscopeBuffDlgProc:proc
	extrn	fnwpPortExtensionsDlgProc:proc
	extrn	WinPostMsg:proc
	extrn	WinSetWindowText:proc
	extrn	WinSetFocus:proc
	extrn	WinMessageBox:proc
	extrn	WinDismissDlg:proc
	extrn	DisplayHelpPanel:proc
	extrn	WinDefDlgProc:proc
	extrn	WinLoadDlg:proc
	extrn	WinSetWindowPos:proc
	extrn	MessageBox:proc
	extrn	HelpInit:proc
	extrn	_sprintfieee:proc
	extrn	WinDlgBox:proc
	extrn	DestroyHelpInstance:proc
	extrn	_fullDump:dword
	extrn	bWarp4:dword
	extrn	stTempCFGheader:byte
	extrn	stGlobalCFGheader:byte
	extrn	stTempDCBheader:byte
	extrn	stGlobalDCBheader:byte
	extrn	szInitDeviceDescription:byte
	extrn	szDeviceDescription:byte
	extrn	bInsertNewDevice:dword
	extrn	hThisModule:dword
	extrn	bSpoolSetupInUse:dword
DATA32	segment
@STAT1	db "~Interface",0h
	align 04h
@STAT2	db "~Timeouts",0h
	align 04h
@STAT3	db "~Protocols",0h
	align 04h
@STAT4	db "~Protocols",0h
	align 04h
@STAT5	db "~Line Protocol",0h
	align 04h
@STAT6	db "Page 1 of 2 ",0h
	align 04h
@STAT7	db "~Protocols",0h
	align 04h
@STAT8	db "~Baud rate",0h
	align 04h
@STAT9	db "Page 2 of 2 ",0h
	align 04h
@STATa	db "~Handshaking",0h
	align 04h
@STATb	db "~Handshaking",0h
	align 04h
@STATc	db "~ASCII (Xon/Xoff)",0h
	align 04h
@STATd	db "Page 1 of 3 ",0h
	align 04h
@STATe	db "Page 1 of 2 ",0h
	align 04h
@STATf	db "~Handshaking",0h
	align 04h
@STAT10	db "~Hardware (modem)",0h
	align 04h
@STAT11	db "Page 2 of 3 ",0h
	align 04h
@STAT12	db "Page 2 of 2 ",0h
	align 04h
@STAT13	db "~Handshaking",0h
	align 04h
@STAT14	db "~Thresholds",0h
@STAT15	db "Page 3 of 3 ",0h
	align 04h
@STAT16	db "~Stream filters",0h
@STAT17	db "~FIFO setup",0h
@STAT18	db "~COMi buffers",0h
	align 04h
@STAT19	db "~COMi buffers",0h
	align 04h
@STAT1a	db "~Receive",0h
	align 04h
@STAT1b	db "Page 1 of 3 ",0h
	align 04h
@STAT1c	db "Page 1 of 2 ",0h
	align 04h
@STAT1d	db "~Handsahking",0h
	align 04h
@STAT1e	db "~Transmit",0h
	align 04h
@STAT1f	db "Page 2 of 3 ",0h
	align 04h
@STAT20	db "Page 2 of 2 ",0h
	align 04h
@STAT21	db "~COMi buffers",0h
	align 04h
@STAT22	db "Page 3 of 3 ",0h
	align 04h
@STAT23	db "~Extensions",0h
@STAT24	db "Are you sure you want to"
db " exit without saving?",0h
	align 04h
@STAT25	db "Device configuration has"
db " changed!",0h
	align 04h
@STAT26	db "Are you sure you want to"
db " exit without saving?",0h
	align 04h
@STAT27	db "Device configuration has"
db " changed!",0h
	align 04h
@STAT28	db "COMspool Port Configurat"
db "ion process is being acc"
db "essed by another process"
db ".",0ah,0ah,"Try again later.",0h
	dd	_dllentry
DATA32	ends
CONST32_RO	segment
@aszSpoolerDescriptionFormat	db "Serial Port Settings - %"
db "s",0h
CONST32_RO	ends
BSS32	segment
comm	astPages:byte:035ch
	align 04h
comm	hwndNoteBookDlg:dword
	align 04h
comm	lOrgXonHysteresis:dword
	align 04h
comm	lOrgXoffThreshold:dword
	align 04h
comm	lXonHysteresis:dword
	align 04h
comm	lXoffThreshold:dword
	align 04h
comm	ulOrgReadBuffLen:dword
	align 04h
comm	ulReadBuffLen:dword
@10pstCOMiCFG	dd 0h
@11ulTopPageId	dd 0h
@12iPageCount	dd 0h
@13hwndNoteBook	dd 0h
@14ulFocusId	dd 0h
@19iPageIndex	dd 0h
@1cbAllowControls	dd 0h
@57szSpoolerDescription	db 03dh DUP (0h)
BSS32	ends
CODE32	segment

; 61   {
	align 010h

	public fnwpDeviceSetupDlgProc
fnwpDeviceSetupDlgProc	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08ch
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,023h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 78   switch(msg)
	mov	eax,[ebp+0ch];	msg
	jmp	@BLBL90
	align 04h
@BLBL91:

; 79     {
; 80     case WM_INITDLG:
; 81 //      CenterDlgBox(hwnd);
; 82       bAllowControls = FALSE;
	mov	dword ptr  @1cbAllowControls,0h

; 83       hwndNoteBook = WinWindowFromID(hwnd,PCFG_NOTEBOOK);
	push	011f8h
	push	dword ptr [ebp+08h];	hwnd
	call	WinWindowFromID
	add	esp,08h
	mov	dword ptr  @13hwndNoteBook,eax

; 84       hwndNoteBookDlg = hwnd;
	mov	eax,[ebp+08h];	hwnd
	mov	dword ptr  hwndNoteBookDlg,eax

; 85       pstCOMiCFG = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @10pstCOMiCFG,eax

; 86       /*
; 87       ** Set the wait pointer.
; 88       */
; 89       hptrPrev = WinQueryPointer(HWND_DESKTOP);
	push	01h
	call	WinQueryPointer
	add	esp,04h
	mov	[ebp-08h],eax;	hptrPrev

; 90       hptrWait = WinQuerySysPointer(HWND_DESKTOP, SPTR_WAIT, FALSE);
	push	0h
	push	03h
	push	01h
	call	WinQuerySysPointer
	add	esp,0ch
	mov	[ebp-0ch],eax;	hptrWait

; 91       WinSetPointer(HWND_DESKTOP, hptrWait);
	push	dword ptr [ebp-0ch];	hptrWait
	push	01h
	call	WinSetPointer
	add	esp,08h

; 92       /*
; 93       ** set notebook globals
; 94       */
; 95       WinSendMsg(hwndNoteBook, BKM_SETNOTEBOOKCOLORS,
	push	01h
	push	0ffffffdeh
	push	0364h
	push	dword ptr  @13hwndNoteBook
	call	WinSendMsg
	add	esp,010h

; 96                  MPFROMLONG(SYSCLR_DIALOGBACKGROUND),
; 97                  MPFROMLONG(BKA_BACKGROUNDPAGECOLORINDEX));
; 98 
; 99       WinSendMsg(hwndNoteBook, BKM_SETNOTEBOOKCOLORS,
	push	03h
	push	0ffffffdeh
	push	0364h
	push	dword ptr  @13hwndNoteBook
	call	WinSendMsg
	add	esp,010h

; 100                  MPFROMLONG(SYSCLR_DIALOGBACKGROUND),
; 101                  MPFROMLONG(BKA_BACKGROUNDMAJORCOLORINDEX));
; 102 
; 103       WinSendMsg(hwndNoteBook, BKM_SETDIMENSIONS,
	push	01h
	push	0190064h
	push	035eh
	push	dword ptr  @13hwndNoteBook
	call	WinSendMsg
	add	esp,010h

; 104                  MPFROM2SHORT(100, 25), (MPARAM)BKA_MAJORTAB);
; 105 
; 106       if (!bWarp4)
	cmp	dword ptr  bWarp4,0h
	jne	@BLBL1

; 107         WinSendMsg(hwndNoteBook, BKM_SETDIMENSIONS,
	push	02h
	push	0190064h
	push	035eh
	push	dword ptr  @13hwndNoteBook
	call	WinSendMsg
	add	esp,010h
@BLBL1:

; 108                    MPFROM2SHORT(100, 25), (MPARAM)BKA_MINORTAB);
; 109 
; 110       iPageIndex = 0;
	mov	dword ptr  @19iPageIndex,0h

; 111       memset(astPages,0,(sizeof(NBKPAGECTL) * MAX_NOTEBOOK_PAGES));
	mov	ecx,035ch
	xor	edx,edx
	mov	eax,offset FLAT:astPages
	call	memset

; 112       /*************************************************************************************
; 113       **  Insert Device page (MAJOR)
; 114       **
; 115       **  This is the top page for normal COMi configuration.
; 116       **
; 117       **  The top page cannot have sub pages!  This is restricted by the algorithm used
; 118       **  by this process, not the API.  See DID_OK and BKN_PAGESELECTED processing, below.
; 119       */
; 120       if (!pstCOMiCFG->bSpoolerConfig)
	mov	eax,dword ptr  @10pstCOMiCFG
	test	byte ptr [eax+04bh],040h
	jne	@BLBL2

; 121         {
; 122         memcpy(&stTempCFGheader,&stGlobalCFGheader,sizeof(CFGHEAD));
	mov	ecx,03eh
	mov	edx,offset FLAT:stGlobalCFGheader
	mov	eax,offset FLAT:stTempCFGheader
	call	memcpy

; 123         memcpy(&stTempDCBheader,&stGlobalDCBheader,sizeof(DCBHEAD));
	mov	ecx,03ah
	mov	edx,offset FLAT:stGlobalDCBheader
	mov	eax,offset FLAT:stTempDCBheader
	call	memcpy

; 124         astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+06h],offset FLAT:stTempDCBheader

; 125         astPages[iPageIndex].pVoidPtrTwo = &stTempCFGheader;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+0ah],offset FLAT:stTempCFGheader

; 126         astPages[iPageIndex].pVoidPtrThree = pstCOMiCFG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	ecx,dword ptr  @10pstCOMiCFG
	mov	dword ptr [eax+ astPages+0eh],ecx

; 127         astPages[iPageIndex].usHelpId = HLPP_DEVICE_SETUP_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],0753bh

; 128         ulTopPageId = InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	012c7h
	push	offset FLAT: fnwpPortConfigDeviceDlgProc
	push	040h
	push	0h
	push	offset FLAT:@STAT1
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h
	mov	dword ptr  @11ulTopPageId,eax

; 129                                         "~Interface",0,
; 130                                          BKA_MAJOR,
; 131                                   (PFNWP)fnwpPortConfigDeviceDlgProc,
; 132                                          PCFG_DEV,
; 133                                         &astPages[iPageIndex]);
; 134         astPages[iPageIndex].usFocusId = PCFG_NAME_LIST;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+04h],0130ah

; 135         iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 136         }
@BLBL2:

; 137       /*********************************************************************************
; 138       **  Insert Timeouts Page (MAJOR)
; 139       **
; 140       **  This is the top page for spooler device configuration.
; 141       */
; 142       astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+06h],offset FLAT:stTempDCBheader+010h

; 143       if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	mov	[ebp-08ch],eax;	@CBE48
	mov	edx,dword ptr  @10pstCOMiCFG
	mov	dl,[edx+04bh]
	and	edx,07fh
	shr	edx,06h
	mov	eax,[ebp-08ch];	@CBE48
	mov	cl,[eax+02ah]
	and	cl,0efh
	sal	edx,04h
	and	dl,01fh
	or	cl,dl
	mov	[eax+02ah],cl
	test	byte ptr [eax+02ah],010h
	jne	@BLBL3

; 144         astPages[iPageIndex].usHelpId = HLPP_DEF_TIMEOUT_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],07541h
	jmp	@BLBL4
	align 010h
@BLBL3:

; 145       else
; 146         astPages[iPageIndex].usHelpId = HLPP_TIMEOUT_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],07554h
@BLBL4:

; 147       ulNewPageId = InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	03e8h
	push	offset FLAT: fnwpCfgTimeoutDlg
	push	040h
	push	0h
	push	offset FLAT:@STAT2
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h
	mov	[ebp-010h],eax;	ulNewPageId

; 148                                    "~Timeouts",0,
; 149                                     BKA_MAJOR,
; 150                              (PFNWP)fnwpCfgTimeoutDlg,
; 151                                     HWT_DLG,
; 152                                    &astPages[iPageIndex]);
; 153       astPages[iPageIndex].usFocusId = HWT_RNORM;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+04h],03ebh

; 154       iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 155 
; 156       if (pstCOMiCFG->bSpoolerConfig)
	mov	eax,dword ptr  @10pstCOMiCFG
	test	byte ptr [eax+04bh],040h
	je	@BLBL5

; 157         {
; 158         ulTopPageId = ulNewPageId;
	mov	eax,[ebp-010h];	ulNewPageId
	mov	dword ptr  @11ulTopPageId,eax

; 159         ulFocusId = HWT_RNORM;
	mov	dword ptr  @14ulFocusId,03ebh

; 160         }
@BLBL5:

; 161        /*********************************************************************************
; 162       ** Insert Protocol pages (MAJOR)
; 163       */
; 164       if (!bWarp4)
	cmp	dword ptr  bWarp4,0h
	jne	@BLBL6

; 165         {
; 166         InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	0h
	push	0h
	push	040h
	push	0h
	push	offset FLAT:@STAT3
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h

; 167                           "~Protocols",0,
; 168                            BKA_MAJOR,
; 169                            0,
; 170                            0,
; 171                            &astPages[iPageIndex]);
; 172         astPages[iPageIndex].ulPrevPageId = astPages[iPageIndex - 1].ulPageId;
	mov	ecx,dword ptr  @19iPageIndex
	imul	ecx,02bh
	mov	ecx,dword ptr [ecx+ astPages-019h]
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+016h],ecx

; 173         iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 174         }
@BLBL6:

; 175       /*************************************************************************************
; 176       **  Insert line porotcol Page (MAJOR/MINOR)
; 177       */
; 178       if (bWarp4)
	cmp	dword ptr  bWarp4,0h
	je	@BLBL7

; 179         {
; 180         usTabType = (BKA_MINOR | BKA_MAJOR | BKA_STATUSTEXTON);
	mov	word ptr [ebp-042h],0c1h;	usTabType

; 181         strcpy(szTabText,"~Protocols");
	mov	edx,offset FLAT:@STAT4
	lea	eax,[ebp-06ah];	szTabText
	call	strcpy

; 182         }
	jmp	@BLBL8
	align 010h
@BLBL7:

; 183       else
; 184         {
; 185         usTabType = (BKA_MINOR | BKA_STATUSTEXTON);
	mov	word ptr [ebp-042h],081h;	usTabType

; 186         strcpy(szTabText,"~Line Protocol");
	mov	edx,offset FLAT:@STAT5
	lea	eax,[ebp-06ah];	szTabText
	call	strcpy

; 187         }
@BLBL8:

; 188       astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB.byLineCharacteristics;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+06h],offset FLAT:stTempDCBheader+031h

; 189       if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	mov	[ebp-088h],eax;	@CBE47
	mov	edx,dword ptr  @10pstCOMiCFG
	mov	dl,[edx+04bh]
	and	edx,07fh
	shr	edx,06h
	mov	eax,[ebp-088h];	@CBE47
	mov	cl,[eax+02ah]
	and	cl,0efh
	sal	edx,04h
	and	dl,01fh
	or	cl,dl
	mov	[eax+02ah],cl
	test	byte ptr [eax+02ah],010h
	jne	@BLBL9

; 190         astPages[iPageIndex].usHelpId = HLPP_DEF_LINE_PROTOCOL_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],07540h
	jmp	@BLBL10
	align 010h
@BLBL9:

; 191       else
; 192         astPages[iPageIndex].usHelpId = HLPP_LINE_PROTOCOL_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],0753dh
@BLBL10:

; 193       ulNewPageId = InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	04e2h
	push	offset FLAT: fnwpCfgProtocolDlg
	mov	ax,[ebp-042h];	usTabType
	push	eax
	push	offset FLAT:@STAT6
	lea	eax,[ebp-06ah];	szTabText
	push	eax
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h
	mov	[ebp-010h],eax;	ulNewPageId

; 194                                        szTabText,"Page 1 of 2 ",
; 195                                        usTabType,
; 196                                 (PFNWP)fnwpCfgProtocolDlg,
; 197                                        HWPT_DLG,
; 198                                       &astPages[iPageIndex]);
; 199       astPages[iPageIndex - 1].ulSubPageId = ulNewPageId;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	ecx,[ebp-010h];	ulNewPageId
	mov	dword ptr [eax+ astPages-011h],ecx

; 200       astPages[iPageIndex].usFocusId = HWP_8BITS;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+04h],0191h

; 201       iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 202       /******************************************************************
; 202 *******************
; 203       **  Insert baud rate Page (MINOR)
; 204       */
; 205       if (bWarp4)
	cmp	dword ptr  bWarp4,0h
	je	@BLBL11

; 206         strcpy(szTabText,"~Protocols");
	mov	edx,offset FLAT:@STAT7
	lea	eax,[ebp-06ah];	szTabText
	call	strcpy
	jmp	@BLBL12
	align 010h
@BLBL11:

; 207       else
; 208         strcpy(szTabText,"~Baud rate");
	mov	edx,offset FLAT:@STAT8
	lea	eax,[ebp-06ah];	szTabText
	call	strcpy
@BLBL12:

; 209       astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB.ulBaudRate;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+06h],offset FLAT:stTempDCBheader+028h

; 210       if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	mov	[ebp-084h],eax;	@CBE46
	mov	edx,dword ptr  @10pstCOMiCFG
	mov	dl,[edx+04bh]
	and	edx,07fh
	shr	edx,06h
	mov	eax,[ebp-084h];	@CBE46
	mov	cl,[eax+02ah]
	and	cl,0efh
	sal	edx,04h
	and	dl,01fh
	or	cl,dl
	mov	[eax+02ah],cl
	test	byte ptr [eax+02ah],010h
	jne	@BLBL13

; 211         astPages[iPageIndex].usHelpId = HLPP_DEF_BAUD_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],0753fh
	jmp	@BLBL14
	align 010h
@BLBL13:

; 212       else
; 213         {
; 214         astPages[iPageIndex].ulSpare = pstCOMiCFG->ulSpare; // set max baud rate
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	ecx,dword ptr  @10pstCOMiCFG
	mov	ecx,[ecx+03fh]
	mov	dword ptr [eax+ astPages+01eh],ecx

; 215         astPages[iPageIndex].usHelpId = HLPP_BAUD_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],0753eh

; 216         }
@BLBL14:

; 217       ulNewPageId = InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	0289ah
	push	offset FLAT: fnwpCfgBaudRateDlg
	push	081h
	push	offset FLAT:@STAT9
	lea	eax,[ebp-06ah];	szTabText
	push	eax
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h
	mov	[ebp-010h],eax;	ulNewPageId

; 218                                       szTabText,"Page 2 of 2 ",
; 219                                       (BKA_MINOR | BKA_STATUSTEXTON),
; 220                                 (PFNWP)fnwpCfgBaudRateDlg,
; 221                                        BAUD_DLG,
; 222                                       &astPages[iPageIndex]);
; 223       astPages[iPageIndex].usFocusId = HWB_BAUD;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+04h],0515h

; 224       iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 225       /*********************************************************************************
; 226       ** Insert Handshaking page (MAJOR)
; 227       */
; 228       if (!bWarp4)
	cmp	dword ptr  bWarp4,0h
	jne	@BLBL15

; 229         {
; 230         InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	0h
	push	0h
	push	040h
	push	0h
	push	offset FLAT:@STATa
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h

; 231                           "~Handshaking",0,
; 232                            BKA_MAJOR,
; 233                            0,
; 234                            0,
; 235                            &astPages[iPageIndex]);
; 236         astPages[iPageIndex].ulPrevPageId = astPages[iPageIndex - 1].ulPageId;
	mov	ecx,dword ptr  @19iPageIndex
	imul	ecx,02bh
	mov	ecx,dword ptr [ecx+ astPages-019h]
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+016h],ecx

; 237         iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 238         }
@BLBL15:

; 239       /*************************************************************************************
; 240       **  Insert ASCII handshaking Page (MINOR)
; 241       */
; 242       if (bWarp4)
	cmp	dword ptr  bWarp4,0h
	je	@BLBL16

; 243         {
; 244         usTabType = (BKA_MINOR | BKA_MAJOR | BKA_STATUSTEXTON);
	mov	word ptr [ebp-042h],0c1h;	usTabType

; 245         strcpy(szTabText,"~Handshaking");
	mov	edx,offset FLAT:@STATb
	lea	eax,[ebp-06ah];	szTabText
	call	strcpy

; 246         }
	jmp	@BLBL17
	align 010h
@BLBL16:

; 247       else
; 248         {
; 249         usTabType = (BKA_MINOR | BKA_STATUSTEXTON);
	mov	word ptr [ebp-042h],081h;	usTabType

; 250         strcpy(szTabText,"~ASCII (Xon/Xoff)");
	mov	edx,offset FLAT:@STATc
	lea	eax,[ebp-06ah];	szTabText
	call	strcpy

; 251         }
@BLBL17:

; 252       astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+06h],offset FLAT:stTempDCBheader+010h

; 253       if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	mov	[ebp-080h],eax;	@CBE45
	mov	edx,dword ptr  @10pstCOMiCFG
	mov	dl,[edx+04bh]
	and	edx,07fh
	shr	edx,06h
	mov	eax,[ebp-080h];	@CBE45
	mov	cl,[eax+02ah]
	and	cl,0efh
	sal	edx,04h
	and	dl,01fh
	or	cl,dl
	mov	[eax+02ah],cl
	test	byte ptr [eax+02ah],010h
	jne	@BLBL18

; 254         {
; 255         astPages[iPageIndex].usHelpId = HLPP_DEF_HANDSHAKE_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],07544h

; 256         strcpy(szStatusText,"Page 1 of 3 ");
	mov	edx,offset FLAT:@STATd
	lea	eax,[ebp-039h];	szStatusText
	call	strcpy

; 257         }
	jmp	@BLBL19
	align 010h
@BLBL18:

; 258       else
; 259         {
; 260         astPages[iPageIndex].usHelpId = HLPP_HANDSHAKE_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],07557h

; 261         strcpy(szStatusText,"Page 1 of 2 ");
	mov	edx,offset FLAT:@STATe
	lea	eax,[ebp-039h];	szStatusText
	call	strcpy

; 262         }
@BLBL19:

; 263       ulNewPageId = InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	01011h
	push	offset FLAT: fnwpCfgASCIIhandshakeDlg
	mov	ax,[ebp-042h];	usTabType
	push	eax
	lea	eax,[ebp-039h];	szStatusText
	push	eax
	lea	eax,[ebp-06ah];	szTabText
	push	eax
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h
	mov	[ebp-010h],eax;	ulNewPageId

; 264                                    szTabText,szStatusText,
; 265                                    usTabType,
; 266                              (PFNWP)fnwpCfgASCIIhandshakeDlg,
; 267                                     PCFG_ASCII_HS_DLG,
; 268                                    &astPages[iPageIndex]);
; 269       astPages[iPageIndex - 1].ulSubPageId = ulNewPageId;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	ecx,[ebp-010h];	ulNewPageId
	mov	dword ptr [eax+ astPages-011h],ecx

; 270       astPages[iPageIndex].usFocusId = HS_TXFLOW;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+04h],01c8h

; 271       iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 272       /*************************************************************************************
; 273       **  Insert Modem signal handshaking Page (MINOR)
; 274       */
; 275       if (bWarp4)
	cmp	dword ptr  bWarp4,0h
	je	@BLBL20

; 276         strcpy(szTabText,"~Handshaking");
	mov	edx,offset FLAT:@STATf
	lea	eax,[ebp-06ah];	szTabText
	call	strcpy
	jmp	@BLBL21
	align 010h
@BLBL20:

; 277       else
; 278         strcpy(szTabText,"~Hardware (modem)");
	mov	edx,offset FLAT:@STAT10
	lea	eax,[ebp-06ah];	szTabText
	call	strcpy
@BLBL21:

; 279       astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+06h],offset FLAT:stTempDCBheader+010h

; 280       if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	mov	[ebp-07ch],eax;	@CBE44
	mov	edx,dword ptr  @10pstCOMiCFG
	mov	dl,[edx+04bh]
	and	edx,07fh
	shr	edx,06h
	mov	eax,[ebp-07ch];	@CBE44
	mov	cl,[eax+02ah]
	and	cl,0efh
	sal	edx,04h
	and	dl,01fh
	or	cl,dl
	mov	[eax+02ah],cl
	test	byte ptr [eax+02ah],010h
	jne	@BLBL22

; 281         {
; 282         astPages[iPageIndex].usHelpId = HLPP_DEF_HANDSHAKE_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],07544h

; 283         strcpy(szStatusText,"Page 2 of 3 ");
	mov	edx,offset FLAT:@STAT11
	lea	eax,[ebp-039h];	szStatusText
	call	strcpy

; 284         }
	jmp	@BLBL23
	align 010h
@BLBL22:

; 285       else
; 286         {
; 287         astPages[iPageIndex].usHelpId = HLPP_HANDSHAKE_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],07557h

; 288         strcpy(szStatusText,"Page 2 of 2 ");
	mov	edx,offset FLAT:@STAT12
	lea	eax,[ebp-039h];	szStatusText
	call	strcpy

; 289         }
@BLBL23:

; 290       InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	0100fh
	push	offset FLAT: fnwpCfgHDWhandshakeDlg
	push	081h
	lea	eax,[ebp-039h];	szStatusText
	push	eax
	lea	eax,[ebp-06ah];	szTabText
	push	eax
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h

; 291                         szTabText,szStatusText,
; 292                          (BKA_MINOR | BKA_STATUSTEXTON),
; 293                  (PFNWP)fnwpCfgHDWhandshakeDlg,
; 294                          PCFG_HDW_HS_DLG,
; 295                          &astPages[iPageIndex]);
; 296       astPages[iPageIndex].usFocusId = HS_CTSOUT;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+04h],01c5h

; 297       iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 298       if (!pstCOMiCFG->bSpoolerConfig)
	mov	eax,dword ptr  @10pstCOMiCFG
	test	byte ptr [eax+04bh],040h
	jne	@BLBL24

; 299         {
; 300         /*************************************************************************************
; 301         **  Insert Threshold Page (MINOR)
; 302         */
; 303         if (bWarp4)
	cmp	dword ptr  bWarp4,0h
	je	@BLBL25

; 304           strcpy(szTabText,"~Handshaking");
	mov	edx,offset FLAT:@STAT13
	lea	eax,[ebp-06ah];	szTabText
	call	strcpy
	jmp	@BLBL26
	align 010h
@BLBL25:

; 305         else
; 306           strcpy(szTabText,"~Thresholds");
	mov	edx,offset FLAT:@STAT14
	lea	eax,[ebp-06ah];	szTabText
	call	strcpy
@BLBL26:

; 307         astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+06h],offset FLAT:stTempDCBheader+010h

; 308         if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	mov	[ebp-078h],eax;	@CBE43
	mov	edx,dword ptr  @10pstCOMiCFG
	mov	dl,[edx+04bh]
	and	edx,07fh
	shr	edx,06h
	mov	eax,[ebp-078h];	@CBE43
	mov	cl,[eax+02ah]
	and	cl,0efh
	sal	edx,04h
	and	dl,01fh
	or	cl,dl
	mov	[eax+02ah],cl
	test	byte ptr [eax+02ah],010h
	jne	@BLBL27

; 309           astPages[iPageIndex].usHelpId = HLPP_DEF_THRESHOLD_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],07552h
	jmp	@BLBL28
	align 010h
@BLBL27:

; 310         else
; 311           astPages[iPageIndex].usHelpId = HLPP_THRESHOLD_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],07558h
@BLBL28:

; 312         if ((lOrgXoffThreshold = stTempDCBheader.stComDCB.wXoffThreshold) == 0)
	xor	eax,eax
	mov	ax,word ptr  stTempDCBheader+038h
	mov	dword ptr  lOrgXoffThreshold,eax
	cmp	dword ptr  lOrgXoffThreshold,0h
	jne	@BLBL29

; 313           lOrgXoffThreshold = 128;
	mov	dword ptr  lOrgXoffThreshold,080h
@BLBL29:

; 314         if (stTempDCBheader.stComDCB.wXonHysteresis == 0)
	cmp	word ptr  stTempDCBheader+036h,0h
	jne	@BLBL30

; 315           lOrgXonHysteresis = ((stTempDCBheader.stComDCB.wReadBufferLength / 2) - lOrgXoffThreshold);
	xor	eax,eax
	mov	ax,word ptr  stTempDCBheader+018h
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	sub	eax,dword ptr  lOrgXoffThreshold
	mov	dword ptr  lOrgXonHysteresis,eax
	jmp	@BLBL31
	align 010h
@BLBL30:

; 316         else
; 317           lOrgXonHysteresis = stTempDCBheader.stComDCB.wXonHysteresis;
	xor	eax,eax
	mov	ax,word ptr  stTempDCBheader+036h
	mov	dword ptr  lOrgXonHysteresis,eax
@BLBL31:

; 318         lXonHysteresis = lOrgXonHysteresis;
	mov	eax,dword ptr  lOrgXonHysteresis
	mov	dword ptr  lXonHysteresis,eax

; 319         lXoffThreshold = lOrgXoffThreshold;
	mov	eax,dword ptr  lOrgXoffThreshold
	mov	dword ptr  lXoffThreshold,eax

; 320         astPages[iPageIndex].bRecalcEach = TRUE;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	or	byte ptr [eax+ astPages+02ah],08h

; 321         InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	01004h
	push	offset FLAT: fnwpDefThresholdDlg
	push	081h
	push	offset FLAT:@STAT15
	lea	eax,[ebp-06ah];	szTabText
	push	eax
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h

; 322                           szTabText,"Page 3 of 3 ",
; 323                            (BKA_MINOR | BKA_STATUSTEXTON),
; 324                     (PFNWP)fnwpDefThresholdDlg,
; 325                            PCFG_THRESHOLDS_DLG,
; 326                            &astPages[iPageIndex]);
; 327         astPages[iPageIndex].usFocusId = PCFG_XOFF_THRESHOLD;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+04h],01006h

; 328         iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 329         }
@BLBL24:

; 330       /*********************************************************************************
; 331       **  Insert Filters Page (MAJOR)
; 332       */
; 333       astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+06h],offset FLAT:stTempDCBheader+010h

; 334       if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	mov	[ebp-074h],eax;	@CBE42
	mov	edx,dword ptr  @10pstCOMiCFG
	mov	dl,[edx+04bh]
	and	edx,07fh
	shr	edx,06h
	mov	eax,[ebp-074h];	@CBE42
	mov	cl,[eax+02ah]
	and	cl,0efh
	sal	edx,04h
	and	dl,01fh
	or	cl,dl
	mov	[eax+02ah],cl
	test	byte ptr [eax+02ah],010h
	jne	@BLBL32

; 335         astPages[iPageIndex].usHelpId = HLPP_DEF_FILTER_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],07542h
	jmp	@BLBL33
	align 010h
@BLBL32:

; 336       else
; 337         astPages[iPageIndex].usHelpId = HLPP_FILTER_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],07555h
@BLBL33:

; 338       InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	04b0h
	push	offset FLAT: fnwpCfgFilterDlg
	push	040h
	push	0h
	push	offset FLAT:@STAT16
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h

; 339                         "~Stream filters",0,
; 340                          BKA_MAJOR,
; 341                   (PFNWP)fnwpCfgFilterDlg,
; 342                          HWR_DLG,
; 343                          &astPages[iPageIndex]);
; 344       astPages[iPageIndex].usFocusId = HWR_ENABERR;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+04h],04b7h

; 345       iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 346       /*************************************************************************************
; 347       **  Insert FIFO Page (MAJOR)
; 348       */
; 349       astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+06h],offset FLAT:stTempDCBheader+010h

; 350       if ((astPages[iPageIndex].bSpoolerConfig = pstCOMiCFG->bSpoolerConfig) == FALSE)
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	mov	[ebp-070h],eax;	@CBE41
	mov	edx,dword ptr  @10pstCOMiCFG
	mov	dl,[edx+04bh]
	and	edx,07fh
	shr	edx,06h
	mov	eax,[ebp-070h];	@CBE41
	mov	cl,[eax+02ah]
	and	cl,0efh
	sal	edx,04h
	and	dl,01fh
	or	cl,dl
	mov	[eax+02ah],cl
	test	byte ptr [eax+02ah],010h
	jne	@BLBL34

; 351         astPages[iPageIndex].usHelpId = HLPP_DEF_FIFO_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],07543h
	jmp	@BLBL35
	align 010h
@BLBL34:

; 352       else
; 353         astPages[iPageIndex].usHelpId = HLPP_FIFO_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],07556h
@BLBL35:

; 354       InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	01a4h
	push	offset FLAT: fnwpHdwDefFIFOsetupDlg
	push	040h
	push	0h
	push	offset FLAT:@STAT17
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h

; 355                         "~FIFO setup",0,
; 356                          BKA_MAJOR,
; 357                   (PFNWP)fnwpHdwDefFIFOsetupDlg,
; 358                          HWF_DLG,
; 359                          &astPages[iPageIndex]);
; 360       astPages[iPageIndex].usFocusId = HWF_ENABFIFO;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+04h],01a6h

; 361       iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 362       if (!pstCOMiCFG->bSpoolerConfig)
	mov	eax,dword ptr  @10pstCOMiCFG
	test	byte ptr [eax+04bh],040h
	jne	@BLBL36

; 363         {
; 364         /****************************************************************************
; 365         ** Insert COMi Buffers page (MAJOR)
; 366         */
; 367         if (!bWarp4)
	cmp	dword ptr  bWarp4,0h
	jne	@BLBL37

; 368           {
; 369           InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	0h
	push	0h
	push	040h
	push	0h
	push	offset FLAT:@STAT18
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h

; 370                             "~COMi buffers",0,
; 371                              BKA_MAJOR,
; 372                              0,
; 373                              0,
; 374                              &astPages[iPageIndex]);
; 375           astPages[iPageIndex].ulPrevPageId = astPages[iPageIndex - 1].ulPageId;
	mov	ecx,dword ptr  @19iPageIndex
	imul	ecx,02bh
	mov	ecx,dword ptr [ecx+ astPages-019h]
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+016h],ecx

; 376           iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 377           }
@BLBL37:

; 378         /****************************************************************************
; 379         ** Insert Receive COMi Buffers page (MINOR)
; 380         */
; 381         if (bWarp4)
	cmp	dword ptr  bWarp4,0h
	je	@BLBL38

; 382           {
; 383           usTabType = (BKA_MINOR | BKA_MAJOR | BKA_STATUSTEXTON);
	mov	word ptr [ebp-042h],0c1h;	usTabType

; 384           strcpy(szTabText,"~COMi buffers");
	mov	edx,offset FLAT:@STAT19
	lea	eax,[ebp-06ah];	szTabText
	call	strcpy

; 385           }
	jmp	@BLBL39
	align 010h
@BLBL38:

; 386         else
; 387           {
; 388           usTabType = (BKA_MINOR | BKA_STATUSTEXTON);
	mov	word ptr [ebp-042h],081h;	usTabType

; 389           strcpy(szTabText, "~Receive");
	mov	edx,offset FLAT:@STAT1a
	lea	eax,[ebp-06ah];	szTabText
	call	strcpy

; 390           }
@BLBL39:

; 391         astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+06h],offset FLAT:stTempDCBheader+010h

; 392         astPages[iPageIn
; 392 dex].usHelpId = HLPP_BUFFER_SETUP_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],0753ch

; 393         ulReadBuffLen = stTempDCBheader.stComDCB.wReadBufferLength;
	xor	eax,eax
	mov	ax,word ptr  stTempDCBheader+018h
	mov	dword ptr  ulReadBuffLen,eax

; 394         if (ulReadBuffLen == 0)
	cmp	dword ptr  ulReadBuffLen,0h
	jne	@BLBL40

; 395           ulReadBuffLen = DEF_READ_BUFF_LEN;
	mov	dword ptr  ulReadBuffLen,01000h
@BLBL40:

; 396         if (ulReadBuffLen == 0xffff)
	cmp	dword ptr  ulReadBuffLen,0ffffh
	jne	@BLBL41

; 397           ulReadBuffLen = MAX_READ_BUFF_LEN;
	mov	dword ptr  ulReadBuffLen,010000h
@BLBL41:

; 398         ulOrgReadBuffLen = ulReadBuffLen;
	mov	eax,dword ptr  ulReadBuffLen
	mov	dword ptr  ulOrgReadBuffLen,eax

; 399         if (pstCOMiCFG->bInstallCOMscope)
	mov	eax,dword ptr  @10pstCOMiCFG
	test	byte ptr [eax+04bh],02h
	je	@BLBL42

; 400           strcpy(szStatusText,"Page 1 of 3 ");
	mov	edx,offset FLAT:@STAT1b
	lea	eax,[ebp-039h];	szStatusText
	call	strcpy
	jmp	@BLBL43
	align 010h
@BLBL42:

; 401         else
; 402           strcpy(szStatusText,"Page 1 of 2 ");
	mov	edx,offset FLAT:@STAT1c
	lea	eax,[ebp-039h];	szStatusText
	call	strcpy
@BLBL43:

; 403         ulNewPageId = InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	012feh
	push	offset FLAT: fnwpReceiveBuffDlgProc
	mov	ax,[ebp-042h];	usTabType
	push	eax
	lea	eax,[ebp-039h];	szStatusText
	push	eax
	lea	eax,[ebp-06ah];	szTabText
	push	eax
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h
	mov	[ebp-010h],eax;	ulNewPageId

; 404                                      szTabText,szStatusText,
; 405                                      usTabType,
; 406                                (PFNWP)fnwpReceiveBuffDlgProc,
; 407                                       PCFG_BUFF_DLG,
; 408                                      &astPages[iPageIndex]);
; 409         astPages[iPageIndex - 1].ulSubPageId = ulNewPageId;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	ecx,[ebp-010h];	ulNewPageId
	mov	dword ptr [eax+ astPages-011h],ecx

; 410         astPages[iPageIndex].usFocusId = PCFG_BUFF_DATA;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+04h],01306h

; 411         iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 412         /****************************************************************************
; 413         ** Insert Transmit COMi Buffers page (MINOR)
; 414         */
; 415         if (bWarp4)
	cmp	dword ptr  bWarp4,0h
	je	@BLBL44

; 416           strcpy(szTabText,"~Handsahking");
	mov	edx,offset FLAT:@STAT1d
	lea	eax,[ebp-06ah];	szTabText
	call	strcpy
	jmp	@BLBL45
	align 010h
@BLBL44:

; 417         else
; 418           strcpy(szTabText,"~Transmit");
	mov	edx,offset FLAT:@STAT1e
	lea	eax,[ebp-06ah];	szTabText
	call	strcpy
@BLBL45:

; 419         astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB.wWrtBufferLength;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+06h],offset FLAT:stTempDCBheader+01ah

; 420         astPages[iPageIndex].usHelpId = HLPP_BUFFER_SETUP_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],0753ch

; 421         if (pstCOMiCFG->bInstallCOMscope)
	mov	eax,dword ptr  @10pstCOMiCFG
	test	byte ptr [eax+04bh],02h
	je	@BLBL46

; 422           strcpy(szStatusText,"Page 2 of 3 ");
	mov	edx,offset FLAT:@STAT1f
	lea	eax,[ebp-039h];	szStatusText
	call	strcpy
	jmp	@BLBL47
	align 010h
@BLBL46:

; 423         else
; 424           strcpy(szStatusText,"Page 2 of 2 ");
	mov	edx,offset FLAT:@STAT20
	lea	eax,[ebp-039h];	szStatusText
	call	strcpy
@BLBL47:

; 425         InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	012feh
	push	offset FLAT: fnwpTransmitBuffDlgProc
	push	081h
	lea	eax,[ebp-039h];	szStatusText
	push	eax
	lea	eax,[ebp-06ah];	szTabText
	push	eax
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h

; 426                           szTabText,szStatusText,
; 427                              (BKA_MINOR | BKA_STATUSTEXTON),
; 428                     (PFNWP)fnwpTransmitBuffDlgProc,
; 429                            PCFG_BUFF_DLG,
; 430                            &astPages[iPageIndex]);
; 431         astPages[iPageIndex].usFocusId = PCFG_BUFF_DATA;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+04h],01306h

; 432         iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 433         /****************************************************************************
; 434         ** Insert COMscope COMi Buffers page (MINOR)
; 435         */
; 436         if (pstCOMiCFG->bInstallCOMscope)
	mov	eax,dword ptr  @10pstCOMiCFG
	test	byte ptr [eax+04bh],02h
	je	@BLBL48

; 437           {
; 438           astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB.wCOMscopeBuffLen;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+06h],offset FLAT:stTempDCBheader+014h

; 439           astPages[iPageIndex].usHelpId = HLPP_BUFFER_SETUP_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],0753ch

; 440           InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	012feh
	push	offset FLAT: fnwpCOMscopeBuffDlgProc
	push	081h
	push	offset FLAT:@STAT22
	push	offset FLAT:@STAT21
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h

; 441                             "~COMi buffers","Page 3 of 3 ",
; 442                              (BKA_MINOR | BKA_STATUSTEXTON),
; 443                       (PFNWP)fnwpCOMscopeBuffDlgProc,
; 444                              PCFG_BUFF_DLG,
; 445                              &astPages[iPageIndex]);
; 446           astPages[iPageIndex].usFocusId = PCFG_BUFF_DATA;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+04h],01306h

; 447           iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 448           }
@BLBL48:

; 449         /*************************************************************************************
; 450         **  Insert Extensions Page (MAJOR)
; 451         */
; 452         astPages[iPageIndex].pVoidPtrOne = &stTempDCBheader.stComDCB;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+06h],offset FLAT:stTempDCBheader+010h

; 453         astPages[iPageIndex].pVoidPtrTwo = &stTempCFGheader;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	dword ptr [eax+ astPages+0ah],offset FLAT:stTempCFGheader

; 454         astPages[iPageIndex].usHelpId = HLPP_EXT_DLG;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+02h],0754ch

; 455         InsertNotebookPage(hwnd,hwndNoteBook,
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	add	eax,offset FLAT:astPages
	push	eax
	push	012c3h
	push	offset FLAT: fnwpPortExtensionsDlgProc
	push	040h
	push	0h
	push	offset FLAT:@STAT23
	push	dword ptr  @13hwndNoteBook
	push	dword ptr [ebp+08h];	hwnd
	call	InsertNotebookPage
	add	esp,020h

; 456                           "~Extensions",0,
; 457                            BKA_MAJOR,
; 458                     (PFNWP)fnwpPortExtensionsDlgProc,
; 459                            PCFG_EXTENSIONS_DLG,
; 460                            &astPages[iPageIndex]);
; 461         astPages[iPageIndex].usFocusId = PCFG_MDM_EXT;
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	word ptr [eax+ astPages+04h],012ebh

; 462         iPageIndex++;
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax

; 463         }
@BLBL36:

; 464       /**********************************************************************************
; 465       **  Turn to top page
; 466       */
; 467       iPageCount = (iPageIndex + 1);
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @12iPageCount,eax

; 468       WinSendMsg(hwndNoteBook,
	push	0h
	mov	eax,dword ptr  astPages+012h
	push	eax
	push	0357h
	push	dword ptr  @13hwndNoteBook
	call	WinSendMsg
	add	esp,010h

; 469                  BKM_TURNTOPAGE,
; 470                  (MPARAM)astPages[0].ulPageId,
; 471                  (MPARAM)0L);
; 472       /*
; 473       ** retstore pointer
; 474       */
; 475       WinSetPointer(HWND_DESKTOP, hptrPrev);
	push	dword ptr [ebp-08h];	hptrPrev
	push	01h
	call	WinSetPointer
	add	esp,08h

; 476       WinPostMsg(hwnd,UM_INIT,(MPARAM)0,(MPARAM)0);
	push	0h
	push	0h
	push	02713h
	push	dword ptr [ebp+08h];	hwnd
	call	WinPostMsg
	add	esp,010h

; 477       return MRFROMSHORT(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL92:

; 478     case UM_INIT:
; 479       if (pstCOMiCFG->bSpoolerConfig)
	mov	eax,dword ptr  @10pstCOMiCFG
	test	byte ptr [eax+04bh],040h
	je	@BLBL49

; 480          WinSetWindowText(hwnd,szSpoolerDescription);
	push	offset FLAT:@57szSpoolerDescription
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowText
	add	esp,08h
@BLBL49:

; 481       /*
; 482       **  Set focus to top window field.  Cannot access notebook with keyboard otherwise
; 483       */
; 484       WinSetFocus(HWND_DESKTOP,WinWindowFromID(astPages[0].hwnd,DID_UNDO));
	push	0135h
	push	dword ptr  astPages+022h
	call	WinWindowFromID
	add	esp,08h
	push	eax
	push	01h
	call	WinSetFocus
	add	esp,08h

; 485       bAllowControls = TRUE;
	mov	dword ptr  @1cbAllowControls,01h

; 486       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL93:

; 487     case WM_CONTROL:
; 488       if (bAllowControls)
	cmp	dword ptr  @1cbAllowControls,0h
	je	@BLBL50

; 489         {
; 490         if (SHORT2FROMMP(mp1) == BKN_PAGESELECTEDPENDING)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,086h
	jne	@BLBL51

; 491           {
; 492           pPageSelect = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	[ebp-04h],eax;	pPageSelect

; 493           if ((!pstCOMiCFG->bSpoolerConfig) && (pPageSelect->ulPageIdCur == ulTopPageId))
	mov	eax,dword ptr  @10pstCOMiCFG
	test	byte ptr [eax+04bh],040h
	jne	@BLBL52
	mov	eax,[ebp-04h];	pPageSelect
	mov	ecx,dword ptr  @11ulTopPageId
	cmp	[eax+04h],ecx
	jne	@BLBL52

; 494             {
; 495             /*
; 496             **  If current page is the top page then its data must be validated
; 497             */
; 498             if (pPageSelect->ulPageIdNew != ulTopPageId)
	mov	eax,[ebp-04h];	pPageSelect
	mov	ecx,dword ptr  @11ulTopPageId
	cmp	[eax+08h],ecx
	je	@BLBL52

; 499               {
; 500               if (!WinSendMsg(astPages[0].hwnd,UM_VALIDATE_DATA,(MPARAM)0,(MPARAM)0))
	push	0h
	push	0h
	push	02715h
	push	dword ptr  astPages+022h
	call	WinSendMsg
	add	esp,010h
	test	eax,eax
	jne	@BLBL52

; 501                 {
; 502                 pPageSelect->ulPageIdNew = 0;
	mov	eax,[ebp-04h];	pPageSelect
	mov	dword ptr [eax+08h],0h

; 503                 WinPostMsg(astPages[0].hwnd,UM_SET_FOCUS,MPFROMSHORT(astPages[0].usFocusId),(MPARAM)0L);
	push	0h
	xor	eax,eax
	mov	ax,word ptr  astPages+04h
	push	eax
	push	02716h
	push	dword ptr  astPages+022h
	call	WinPostMsg
	add	esp,010h

; 504                 return (FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL52:

; 505                 }
; 506               }
; 507             }
; 508 //          else
; 509           if (!bWarp4)
	cmp	dword ptr  bWarp4,0h
	jne	@BLBL50

; 510             {
; 511             pstPage = (NBKPAGECTL *)WinSendMsg(hwndNoteBook,BKM_QUERYPAGEDATA,(MPARAM)pPageSelect->ulPageIdNew,(MPARAM)0);
	push	0h
	mov	eax,[ebp-04h];	pPageSelect
	mov	eax,[eax+08h]
	push	eax
	push	035ah
	push	dword ptr  @13hwndNoteBook
	call	WinSendMsg
	add	esp,010h
	mov	[ebp-040h],eax;	pstPage

; 512             if (pstPage->bTopPage)
	mov	eax,[ebp-040h];	pstPage
	test	byte ptr [eax+02ah],02h
	je	@BLBL50

; 513               {
; 514               ulNewPageId = pstPage->ulSubPageId;
	mov	eax,[ebp-040h];	pstPage
	mov	eax,[eax+01ah]
	mov	[ebp-010h],eax;	ulNewPageId

; 515 //              if (ulNewPageId == pPageSelect->ulPageIdCur)
; 516 //                ulNewPageId = pstPage->ulPrevPageId;
; 517               WinPostMsg(hwndNoteBook,
	push	0h
	mov	eax,[ebp-010h];	ulNewPageId
	push	eax
	push	0357h
	push	dword ptr  @13hwndNoteBook
	call	WinPostMsg
	add	esp,010h

; 518                          BKM_TURNTOPAGE,
; 519                  (MPARAM)ulNewPageId,
; 520                  (MPARAM)0L);
; 521               pPageSelect->ulPageIdNew = 0;
	mov	eax,[ebp-04h];	pPageSelect
	mov	dword ptr [eax+08h],0h

; 522               return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL51:

; 523               }
; 524             }
; 525           }
; 526         else
; 527           if (SHORT2FROMMP(mp1) == BKN_PAGESELECTED)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,082h
	jne	@BLBL50

; 528             {
; 529             pPageSelect = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	[ebp-04h],eax;	pPageSelect

; 530             pstPage = (NBKPAGECTL *)WinSendMsg(hwndNoteBook,BKM_QUERYPAGEDATA,(MPARAM)pPageSelect->ulPageIdNew,(MPARAM)0);
	push	0h
	mov	eax,[ebp-04h];	pPageSelect
	mov	eax,[eax+08h]
	push	eax
	push	035ah
	push	dword ptr  @13hwndNoteBook
	call	WinSendMsg
	add	esp,010h
	mov	[ebp-040h],eax;	pstPage

; 531             if (pstPage->bRecalcEach)
	mov	eax,[ebp-040h];	pstPage
	test	byte ptr [eax+02ah],08h
	je	@BLBL59

; 532               WinSendMsg(pstPage->hwnd,UM_RECALCDLG,(MPARAM)0,(MPARAM)pstPage);
	push	dword ptr [ebp-040h];	pstPage
	push	0h
	push	02712h
	mov	eax,[ebp-040h];	pstPage
	push	dword ptr [eax+022h]
	call	WinSendMsg
	add	esp,010h
@BLBL59:

; 533             WinSetFocus(HWND_DESKTOP,WinWindowFromID(pstPage->hwnd,DID_UNDO));
	push	0135h
	mov	eax,[ebp-040h];	pstPage
	push	dword ptr [eax+022h]
	call	WinWindowFromID
	add	esp,08h
	push	eax
	push	01h
	call	WinSetFocus
	add	esp,08h

; 534 //            WinSetFocus(HWND_DESKTOP,WinWindowFromID(pstPage->hwnd,pstPage->usFocusId));
; 535             if (!pstCOMiCFG->bSpoolerConfig)
	mov	eax,dword ptr  @10pstCOMiCFG
	test	byte ptr [eax+04bh],040h
	jne	@BLBL50

; 536               if (pstPage->ulPageId == ulTopPageId)
	mov	eax,[ebp-040h];	pstPage
	mov	ecx,dword ptr  @11ulTopPageId
	cmp	[eax+012h],ecx
	jne	@BLBL61

; 537                 WinSetWindowText(hwnd,szInitDeviceDescription);
	push	offset FLAT:szInitDeviceDescription
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowText
	add	esp,08h
	jmp	@BLBL50
	align 010h
@BLBL61:

; 538               else
; 539                 WinSetWindowText(hwnd,szDeviceDescription);
	push	offset FLAT:szDeviceDescription
	push	dword ptr [ebp+08h];	hwnd
	call	WinSetWindowText
	add	esp,08h

; 540             }

; 541           }
@BLBL50:

; 542       break;
	jmp	@BLBL89
	align 04h
@BLBL94:

; 543     case WM_CLOSE:
; 544       if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL63

; 545         {
; 546         for (iPageIndex = 0;iPageIndex <= iPageCount;iPageIndex++)
	mov	dword ptr  @19iPageIndex,0h
	mov	eax,dword ptr  @12iPageCount
	cmp	dword ptr  @19iPageIndex,eax
	jg	@BLBL64
	align 010h
@BLBL65:

; 547           if (astPages[iPageIndex].bDirtyBit)
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	test	byte ptr [eax+ astPages+02ah],01h
	je	@BLBL66

; 548             {
; 549             pstCOMiCFG->bDirtyPage = TRUE;
	mov	eax,dword ptr  @10pstCOMiCFG
	or	byte ptr [eax+04ch],01h

; 550             break;
	jmp	@BLBL64
	align 010h
@BLBL66:

; 546         for (iPageIndex = 0;iPageIndex <= iPageCount;iPageIndex++)
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax
	mov	eax,dword ptr  @12iPageCount
	cmp	dword ptr  @19iPageIndex,eax
	jle	@BLBL65
@BLBL64:

; 552         if (pstCOMiCFG->bDirtyPage)
	mov	eax,dword ptr  @10pstCOMiCFG
	test	byte ptr [eax+04ch],01h
	je	@BLBL63

; 554           if (WinMessageBox(HWND_DESKTOP,
	push	04024h
	push	0h
	push	offset FLAT:@STAT25
	push	offset FLAT:@STAT24
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,06h
	je	@BLBL63

; 560             return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL63:

; 563       break;
	jmp	@BLBL89
	align 04h
@BLBL95:

; 565       if (!WinSendMsg(astPages[0].hwnd,UM_SAVE_DATA,(MPARAM)0,(MPARAM)0))
	push	0h
	push	0h
	push	02711h
	push	dword ptr  astPages+022h
	call	WinSendMsg
	add	esp,010h
	test	eax,eax
	jne	@BLBL70

; 566          WinSendMsg(hwndNoteBook,
	push	0h
	mov	eax,dword ptr  astPages+012h
	push	eax
	push	0357h
	push	dword ptr  @13hwndNoteBook
	call	WinSendMsg
	add	esp,010h
	jmp	@BLBL71
	align 010h
@BLBL70:

; 572         for (iPageIndex = 0;iPageIndex < iPageCount;iPageIndex++)
	mov	dword ptr  @19iPageIndex,0h
	mov	eax,dword ptr  @12iPageCount
	cmp	dword ptr  @19iPageIndex,eax
	jge	@BLBL72
	align 010h
@BLBL73:

; 573           if (astPages[iPageIndex].bDirtyBit)
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	test	byte ptr [eax+ astPages+02ah],01h
	je	@BLBL74

; 575             pstCOMiCFG->bDirtyPage = TRUE;
	mov	eax,dword ptr  @10pstCOMiCFG
	or	byte ptr [eax+04ch],01h

; 576             if (!WinSendMsg(astPages[iPageIndex].hwnd,UM_SAVE_DATA,(MPARAM)0,(MPARAM)0))
	push	0h
	push	0h
	push	02711h
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	push	dword ptr [eax+ astPages+022h]
	call	WinSendMsg
	add	esp,010h
	test	eax,eax
	jne	@BLBL74

; 578               WinSendMsg(hwndNoteBook,
	push	0h
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	eax,dword ptr [eax+ astPages+012h]
	push	eax
	push	0357h
	push	dword ptr  @13hwndNoteBook
	call	WinSendMsg
	add	esp,010h

; 582               return (FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL74:

; 572         for (iPageIndex = 0;iPageIndex < iPageCount;iPageIndex++)
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax
	mov	eax,dword ptr  @12iPageCount
	cmp	dword ptr  @19iPageIndex,eax
	jl	@BLBL73
@BLBL72:

; 585         if (!pstCOMiCFG->bSpoolerConfig)
	mov	eax,dword ptr  @10pstCOMiCFG
	test	byte ptr [eax+04bh],040h
	jne	@BLBL77

; 587           memcpy(&stGlobalCFGheader,&stTempC
; 587 FGheader,sizeof(CFGHEAD));
	mov	ecx,03eh
	mov	edx,offset FLAT:stTempCFGheader
	mov	eax,offset FLAT:stGlobalCFGheader
	call	memcpy

; 588           memcpy(&stGlobalDCBheader,&stTempDCBheader,sizeof(DCBHEAD));
	mov	ecx,03ah
	mov	edx,offset FLAT:stTempDCBheader
	mov	eax,offset FLAT:stGlobalDCBheader
	call	memcpy

; 589           }
@BLBL77:

; 590         WinDismissDlg(hwnd, TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 591         }
@BLBL71:

; 592        return(TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL96:

; 594       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL98
	align 04h
@BLBL99:

; 597           if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL78

; 599             for (iPageIndex = 0;iPageIndex <= iPageCount;iPageIndex++)
	mov	dword ptr  @19iPageIndex,0h
	mov	eax,dword ptr  @12iPageCount
	cmp	dword ptr  @19iPageIndex,eax
	jg	@BLBL79
	align 010h
@BLBL80:

; 600               if (astPages[iPageIndex].bDirtyBit)
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	test	byte ptr [eax+ astPages+02ah],01h
	je	@BLBL81

; 602                 pstCOMiCFG->bDirtyPage = TRUE;
	mov	eax,dword ptr  @10pstCOMiCFG
	or	byte ptr [eax+04ch],01h

; 603                 break;
	jmp	@BLBL79
	align 010h
@BLBL81:

; 599             for (iPageIndex = 0;iPageIndex <= iPageCount;iPageIndex++)
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax
	mov	eax,dword ptr  @12iPageCount
	cmp	dword ptr  @19iPageIndex,eax
	jle	@BLBL80
@BLBL79:

; 605             if (pstCOMiCFG->bDirtyPage)
	mov	eax,dword ptr  @10pstCOMiCFG
	test	byte ptr [eax+04ch],01h
	je	@BLBL78

; 606               if (WinMessageBox(HWND_DESKTOP,
	push	04024h
	push	0h
	push	offset FLAT:@STAT27
	push	offset FLAT:@STAT26
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,06h
	je	@BLBL78

; 612                 return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL78:

; 614           WinDismissDlg(hwnd, FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 615           return(TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL100:

; 617           ulNewPageId = (ULONG)WinSendMsg(hwndNoteBook,BKM_QUERYPAGEID,(MPARAM)0,MPFROM2SHORT(BKA_TOP,0));
	push	020h
	push	0h
	push	0359h
	push	dword ptr  @13hwndNoteBook
	call	WinSendMsg
	add	esp,010h
	mov	[ebp-010h],eax;	ulNewPageId

; 618           for (iPageIndex = 0;iPageIndex < iPageCount;iPageIndex++)
	mov	dword ptr  @19iPageIndex,0h
	mov	eax,dword ptr  @12iPageCount
	cmp	dword ptr  @19iPageIndex,eax
	jge	@BLBL85
	align 010h
@BLBL86:

; 619             if (astPages[iPageIndex].ulPageId == ulNewPageId)
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	ecx,[ebp-010h];	ulNewPageId
	cmp	dword ptr [eax+ astPages+012h],ecx
	jne	@BLBL87

; 620               DisplayHelpPanel(pstCOMiCFG,astPages[iPageIndex].usHelpId);
	mov	eax,dword ptr  @19iPageIndex
	imul	eax,02bh
	mov	ax,word ptr [eax+ astPages+02h]
	push	eax
	push	dword ptr  @10pstCOMiCFG
	call	DisplayHelpPanel
	add	esp,08h
@BLBL87:

; 618           for (iPageIndex = 0;iPageIndex < iPageCount;iPageIndex++)
	mov	eax,dword ptr  @19iPageIndex
	inc	eax
	mov	dword ptr  @19iPageIndex,eax
	mov	eax,dword ptr  @12iPageCount
	cmp	dword ptr  @19iPageIndex,eax
	jl	@BLBL86
@BLBL85:

; 621           break;
	jmp	@BLBL97
	align 04h
@BLBL101:

; 623           return(WinDefDlgProc(hwnd, msg, mp1, mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	push	dword ptr [ebp+0ch];	msg
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefDlgProc
	add	esp,01ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL97
	align 04h
@BLBL98:
	cmp	eax,02h
	je	@BLBL99
	cmp	eax,012dh
	je	@BLBL100
	jmp	@BLBL101
	align 04h
@BLBL97:

; 625       return MRFROMSHORT(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL89
	align 04h
@BLBL90:
	cmp	eax,03bh
	je	@BLBL91
	cmp	eax,02713h
	je	@BLBL92
	cmp	eax,030h
	je	@BLBL93
	cmp	eax,029h
	je	@BLBL94
	cmp	eax,02714h
	je	@BLBL95
	cmp	eax,020h
	je	@BLBL96
@BLBL89:

; 627   return(WinDefDlgProc(hwnd, msg, mp1, mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	push	dword ptr [ebp+0ch];	msg
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefDlgProc
	add	esp,01ch
	mov	esp,ebp
	pop	ebp
	ret	
fnwpDeviceSetupDlgProc	endp

; 631   {
	align 010h

	public InsertNotebookPage
InsertNotebookPage	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 635   pstPage->cbSize = sizeof(NBKPAGECTL);
	mov	eax,[ebp+024h];	pstPage
	mov	word ptr [eax],02bh

; 636   ulPageId = (ULONG)WinSendMsg(hwndNoteBook,BKM_INSERTPAGE,(MPARAM)NULL,MPFROM2SHORT(usTabType,BKA_LAST));
	xor	eax,eax
	mov	ax,[ebp+018h];	usTabType
	or	eax,020000h
	push	eax
	push	0h
	push	0355h
	push	dword ptr [ebp+0ch];	hwndNoteBook
	call	WinSendMsg
	add	esp,010h
	mov	[ebp-04h],eax;	ulPageId

; 637 
; 638   pstPage->ulPageId = ulPageId;
	mov	eax,[ebp+024h];	pstPage
	mov	ecx,[ebp-04h];	ulPageId
	mov	[eax+012h],ecx

; 639   WinSendMsg(hwndNoteBook,BKM_SETTABTEXT,(MPARAM)ulPageId,MPFROMP(szTabText));
	push	dword ptr [ebp+010h];	szTabText
	mov	eax,[ebp-04h];	ulPageId
	push	eax
	push	0363h
	push	dword ptr [ebp+0ch];	hwndNoteBook
	call	WinSendMsg
	add	esp,010h

; 640   if (szStatusText != NULL)
	cmp	dword ptr [ebp+014h],0h;	szStatusText
	je	@BLBL102

; 641     WinSendMsg(hwndNoteBook,BKM_SETSTATUSLINETEXT,(MPARAM)ulPageId,MPFROMP(szStatusText));
	push	dword ptr [ebp+014h];	szStatusText
	mov	eax,[ebp-04h];	ulPageId
	push	eax
	push	0361h
	push	dword ptr [ebp+0ch];	hwndNoteBook
	call	WinSendMsg
	add	esp,010h
@BLBL102:

; 642 
; 643   if (ulDlgId == 0)
	cmp	dword ptr [ebp+020h],0h;	ulDlgId
	jne	@BLBL103

; 644     pstPage->bTopPage = TRUE;
	mov	eax,[ebp+024h];	pstPage
	or	byte ptr [eax+02ah],02h
	jmp	@BLBL104
	align 010h
@BLBL103:

; 645   else
; 646     {
; 647     hwndPage = WinLoadDlg(hwndDlg,
	push	dword ptr [ebp+024h];	pstPage
	push	dword ptr [ebp+020h];	ulDlgId
	push	dword ptr  hThisModule
	push	dword ptr [ebp+01ch];	fnwpDlgProc
	push	dword ptr [ebp+0ch];	hwndNoteBook
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinLoadDlg
	add	esp,018h
	mov	[ebp-08h],eax;	hwndPage

; 648                           hwndNoteBook,
; 649                           fnwpDlgProc,
; 650                           hThisModule,
; 651                           ulDlgId,
; 652                    (PVOID)pstPage);
; 653 
; 654     pstPage->hwnd = hwndPage;
	mov	eax,[ebp+024h];	pstPage
	mov	ecx,[ebp-08h];	hwndPage
	mov	[eax+022h],ecx

; 655     WinSendMsg(hwndNoteBook,BKM_SETPAGEWINDOWHWND,MPFROMLONG(ulPageId),MPFROMHWND(hwndPage));
	mov	eax,[ebp-08h];	hwndPage
	push	eax
	mov	eax,[ebp-04h];	ulPageId
	push	eax
	push	0360h
	push	dword ptr [ebp+0ch];	hwndNoteBook
	call	WinSendMsg
	add	esp,010h

; 656     WinSetWindowPos(hwndPage,HWND_TOP,0,0,0,0,SWP_MOVE);
	push	02h
	push	0h
	push	0h
	push	0h
	push	0h
	push	03h
	push	dword ptr [ebp-08h];	hwndPage
	call	WinSetWindowPos
	add	esp,01ch

; 657     }
@BLBL104:

; 658   WinSendMsg(hwndNoteBook,BKM_SETPAGEDATA,(MPARAM)ulPageId,(MPARAM)pstPage);
	push	dword ptr [ebp+024h];	pstPage
	mov	eax,[ebp-04h];	ulPageId
	push	eax
	push	035fh
	push	dword ptr [ebp+0ch];	hwndNoteBook
	call	WinSendMsg
	add	esp,010h

; 659   return(ulPageId);
	mov	eax,[ebp-04h];	ulPageId
	mov	esp,ebp
	pop	ebp
	ret	
InsertNotebookPage	endp

; 663   {
	align 010h

	public SpoolerSetupDialog
SpoolerSetupDialog	proc
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

; 669   if (bSpoolSetupInUse)
	cmp	dword ptr  bSpoolSetupInUse,0h
	je	@BLBL105

; 670     {
; 671     MessageBox(HWND_DESKTOP,"COMspool Port Configuration process is being accessed by another process.\n\nTry again later.");
	push	offset FLAT:@STAT28
	push	01h
	call	MessageBox
	add	esp,08h

; 672     return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL105:

; 673     }
; 674   bSpoolSetupInUse = TRUE;
	mov	dword ptr  bSpoolSetupInUse,01h

; 675   HelpInit(pstCOMiCFG);
	push	dword ptr [ebp+0ch];	pstCOMiCFG
	call	HelpInit
	add	esp,04h

; 676 
; 677   stTempDCBheader.stComDCB.ulBaudRate = pstCOMiCFG->ulValue;
	mov	eax,[ebp+0ch];	pstCOMiCFG
	mov	eax,[eax+039h]
	mov	dword ptr  stTempDCBheader+028h,eax

; 678   pstDCB = pstCOMiCFG->pst;
	mov	eax,[ebp+0ch];	pstCOMiCFG
	mov	eax,[eax+031h]
	mov	[ebp-04h],eax;	pstDCB

; 679   stTempDCBheader.stComDCB.wRdTimeout = pstDCB->ReadTimeout;
	mov	eax,[ebp-04h];	pstDCB
	mov	ax,[eax+02h]
	mov	word ptr  stTempDCBheader+026h,ax

; 680   stTempDCBheader.stComDCB.wWrtTimeout = pstDCB->WrtTimeout;
	mov	eax,[ebp-04h];	pstDCB
	mov	ax,[eax]
	mov	word ptr  stTempDCBheader+024h,ax

; 681   stTempDCBheader.stComDCB.wFlags1 = (USHORT)(pstDCB->Flags1 | 0x8000);
	mov	ecx,[ebp-04h];	pstDCB
	xor	eax,eax
	mov	al,[ecx+04h]
	or	ah,080h
	mov	word ptr  stTempDCBheader+01eh,ax

; 682   stTempDCBheader.stComDCB.wFlags2 = (USHORT)(pstDCB->Flags2 | 0x8000);
	mov	ecx,[ebp-04h];	pstDCB
	xor	eax,eax
	mov	al,[ecx+05h]
	or	ah,080h
	mov	word ptr  stTempDCBheader+020h,ax

; 683   stTempDCBheader.stComDCB.wFlags3 = (USHORT)(pstDCB->Flags3 | 0x8000);
	mov	ecx,[ebp-04h];	pstDCB
	xor	eax,eax
	mov	al,[ecx+06h]
	or	ah,080h
	mov	word ptr  stTempDCBheader+022h,ax

; 684   stTempDCBheader.stComDCB.byErrorChar = pstDCB->ErrChar;
	mov	eax,[ebp-04h];	pstDCB
	mov	al,[eax+07h]
	mov	byte ptr  stTempDCBheader+032h,al

; 685   stTempDCBheader.stComDCB.byBreakChar = pstDCB->BrkChar;
	mov	eax,[ebp-04h];	pstDCB
	mov	al,[eax+08h]
	mov	byte ptr  stTempDCBheader+033h,al

; 686   stTempDCBheader.stComDCB.byXonChar = pstDCB->XonChar;
	mov	eax,[ebp-04h];	pstDCB
	mov	al,[eax+09h]
	mov	byte ptr  stTempDCBheader+034h,al

; 687   stTempDCBheader.stComDCB.byXoffChar = pstDCB->XoffChar;
	mov	eax,[ebp-04h];	pstDCB
	mov	al,[eax+0ah]
	mov	byte ptr  stTempDCBheader+035h,al

; 688   pstLine = pstCOMiCFG->pstSpare;
	mov	eax,[ebp+0ch];	pstCOMiCFG
	mov	eax,[eax+035h]
	mov	[ebp-08h],eax;	pstLine

; 689   byLine = 0xc0;
	mov	byte ptr [ebp-09h],0c0h;	byLine

; 690   byLine |= (pstLine->DataBits - 5);
	mov	eax,[ebp-08h];	pstLine
	mov	al,[eax]
	sub	al,05h
	or	al,[ebp-09h];	byLine
	mov	[ebp-09h],al;	byLine

; 691   switch (pstLine->Parity)
	mov	ecx,[ebp-08h];	pstLine
	xor	eax,eax
	mov	al,[ecx+01h]
	jmp	@BLBL112
	align 04h
@BLBL113:

; 692     {
; 693     case 1:
; 694       byLine |= 0x08;
	mov	al,[ebp-09h];	byLine
	or	al,08h
	mov	[ebp-09h],al;	byLine

; 695       break;
	jmp	@BLBL111
	align 04h
@BLBL114:

; 696     case 2:
; 697       byLine |= 0x18;
	mov	al,[ebp-09h];	byLine
	or	al,018h
	mov	[ebp-09h],al;	byLine

; 698       break;
	jmp	@BLBL111
	align 04h
@BLBL115:

; 699     case 3:
; 700       byLine |= 0x38;
	mov	al,[ebp-09h];	byLine
	or	al,038h
	mov	[ebp-09h],al;	byLine

; 701       break;
	jmp	@BLBL111
	align 04h
@BLBL116:

; 702     case 4:
; 703       byLine |= 0x28;
	mov	al,[ebp-09h];	byLine
	or	al,028h
	mov	[ebp-09h],al;	byLine

; 704       break;
	jmp	@BLBL111
	align 04h
	jmp	@BLBL111
	align 04h
@BLBL112:
	cmp	eax,01h
	je	@BLBL113
	cmp	eax,02h
	je	@BLBL114
	cmp	eax,03h
	je	@BLBL115
	cmp	eax,04h
	je	@BLBL116
@BLBL111:

; 705     }
; 706   if ((pstLine->StopBits) != 0)
	mov	eax,[ebp-08h];	pstLine
	cmp	byte ptr [eax+02h],0h
	je	@BLBL106

; 707     byLine |= 0x04;
	mov	al,[ebp-09h];	byLine
	or	al,04h
	mov	[ebp-09h],al;	byLine
@BLBL106:

; 708   stTempDCBheader.stComDCB.byLineCharacteristics = byLine;
	mov	al,[ebp-09h];	byLine
	mov	byte ptr  stTempDCBheader+031h,al

; 709   sprintf(szSpoolerDescription,szSpoolerDescriptionFormat,pstCOMiCFG->pszPortName);
	mov	eax,[ebp+0ch];	pstCOMiCFG
	push	dword ptr [eax+014h]
	mov	edx,offset FLAT:@aszSpoolerDescriptionFormat
	mov	eax,offset FLAT:@57szSpoolerDescription
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 710   bSuccess = WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpDeviceSetupDlgProc,hThisModule,PCFG_NOTEBOOK_DLG,MPFROMP(pstCOMiCFG));
	push	dword ptr [ebp+0ch];	pstCOMiCFG
	push	0100eh
	push	dword ptr  hThisModule
	push	offset FLAT: fnwpDeviceSetupDlgProc
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	mov	[ebp-010h],eax;	bSuccess

; 711 
; 712   pstCOMiCFG->ulValue = stTempDCBheader.stComDCB.ulBaudRate;
	mov	eax,[ebp+0ch];	pstCOMiCFG
	mov	ecx,dword ptr  stTempDCBheader+028h
	mov	[eax+039h],ecx

; 713   pstDCB = pstCOMiCFG->pst;
	mov	eax,[ebp+0ch];	pstCOMiCFG
	mov	eax,[eax+031h]
	mov	[ebp-04h],eax;	pstDCB

; 714   pstDCB->ReadTimeout = stTempDCBheader.stComDCB.wRdTimeout;
	mov	eax,[ebp-04h];	pstDCB
	mov	cx,word ptr  stTempDCBheader+026h
	mov	[eax+02h],cx

; 715   pstDCB->WrtTimeout = stTempDCBheader.stComDCB.wWrtTimeout;
	mov	eax,[ebp-04h];	pstDCB
	mov	cx,word ptr  stTempDCBheader+024h
	mov	[eax],cx

; 716   pstDCB->Flags1 = (BYTE)stTempDCBheader.stComDCB.wFlags1;
	mov	cx,word ptr  stTempDCBheader+01eh
	mov	eax,[ebp-04h];	pstDCB
	mov	[eax+04h],cl

; 717   pstDCB->Flags2 = (BYTE)stTempDCBheader.stComDCB.wFlags2;
	mov	cx,word ptr  stTempDCBheader+020h
	mov	eax,[ebp-04h];	pstDCB
	mov	[eax+05h],cl

; 718   pstDCB->Flags3 = (BYTE)stTempDCBheader.stComDCB.wFlags3;
	mov	cx,word ptr  stTempDCBheader+022h
	mov	eax,[ebp-04h];	pstDCB
	mov	[eax+06h],cl

; 719   pstDCB->ErrChar = stTempDCBheader.stComDCB.byErrorChar;
	mov	eax,[ebp-04h];	pstDCB
	mov	cl,byte ptr  stTempDCBheader+032h
	mov	[eax+07h],cl

; 720   pstDCB->BrkChar = stTempDCBheader.stComDCB.byBreakChar;
	mov	eax,[ebp-04h];	pstDCB
	mov	cl,byte ptr  stTempDCBheader+033h
	mov	[eax+08h],cl

; 721   pstDCB->XonChar = stTempDCBheader.stComDCB.byXonChar;
	mov	eax,[ebp-04h];	pstDCB
	mov	cl,byte ptr  stTempDCBheader+034h
	mov	[eax+09h],cl

; 722   pstDCB->XoffChar = stTempDCBheader.stComDCB.byXoffChar;
	mov	eax,[ebp-04h];	pstDCB
	mov	cl,byte ptr  stTempDCBheader+035h
	mov	[eax+0ah],cl

; 723   pstLine = pstCOMiCFG->pstSpare;
	mov	eax,[ebp+0ch];	pstCOMiCFG
	mov	eax,[eax+035h]
	mov	[ebp-08h],eax;	pstLine

; 724   byLine = stTempDCBheader.stComDCB.byLineCharacteristics;
	mov	al,byte ptr  stTempDCBheader+031h
	mov	[ebp-09h],al;	byLine

; 725   pstLine->DataBits = ((byLine & 0x03) + 5);
	mov	cl,[ebp-09h];	byLine
	and	cl,03h
	add	cl,05h
	mov	eax,[ebp-08h];	pstLine
	mov	[eax],cl

; 726   switch (byLine & 0x38)
	xor	eax,eax
	mov	al,[ebp-09h];	byLine
	and	eax,038h
	jmp	@BLBL118
	align 04h
@BLBL119:

; 727     {
; 728     case 0x00:
; 729       pstLine->Parity = 0;
	mov	eax,[ebp-08h];	pstLine
	mov	byte ptr [eax+01h],0h

; 730       break;
	jmp	@BLBL117
	align 04h
@BLBL120:

; 731     case 0x08:
; 732       pstLine->Parity = 1;
	mov	eax,[ebp-08h];	pstLine
	mov	byte ptr [eax+01h],01h

; 733       break;
	jmp	@BLBL117
	align 04h
@BLBL121:

; 734     case 0x18:
; 735       pstLine->Parity = 2;
	mov	eax,[ebp-08h];	pstLine
	mov	byte ptr [eax+01h],02h

; 736       break;
	jmp	@BLBL117
	align 04h
@BLBL122:

; 737     case 0x38:
; 738       pstLine->Parity = 3;
	mov	eax,[ebp-08h];	pstLine
	mov	byte ptr [eax+01h],03h

; 739       break;
	jmp	@BLBL117
	align 04h
@BLBL123:

; 740     case 0x28:
; 741       pstLine->Parity = 4;
	mov	eax,[ebp-08h];	pstLine
	mov	byte ptr [eax+01h],04h

; 742       break;
	jmp	@BLBL117
	align 04h
	jmp	@BLBL117
	align 04h
@BLBL118:
	test	eax,eax
	je	@BLBL119
	cmp	eax,08h
	je	@BLBL120
	cmp	eax,018h
	je	@BLBL121
	cmp	eax,038h
	je	@BLBL122
	cmp	eax,028h
	je	@BLBL123
@BLBL117:

; 743     }
; 744   if ((byLine & 0x04) == 0)
	test	byte ptr [ebp-09h],04h;	byLine
	jne	@BLBL107

; 745     pstLine->StopBits = 0;
	mov	eax,[ebp-08h];	pstLine
	mov	byte ptr [eax+02h],0h
	jmp	@BLBL108
	align 010h
@BLBL107:

; 746   else
; 747     if (pstLine->DataBits == 5)
	mov	eax,[ebp-08h];	pstLine
	cmp	byte ptr [eax],05h
	jne	@BLBL109

; 748       pstLine->StopBits = 1;
	mov	eax,[ebp-08h];	pstLine
	mov	byte ptr [eax+02h],01h
	jmp	@BLBL108
	align 010h
@BLBL109:

; 749     else
; 750       pstLine->StopBits = 2;
	mov	eax,[ebp-08h];	pstLine
	mov	byte ptr [eax+02h],02h
@BLBL108:

; 751 
; 752   DestroyHelpInstance(pstCOMiCFG);
	push	dword ptr [ebp+0ch];	pstCOMiCFG
	call	DestroyHelpInstance
	add	esp,04h

; 753 
; 754   bSpoolSetupInUse = FALSE;
	mov	dword ptr  bSpoolSetupInUse,0h

; 755   return(bSuccess);
	mov	eax,[ebp-010h];	bSuccess
	mov	esp,ebp
	pop	ebp
	ret	
SpoolerSetupDialog	endp
CODE32	ends
end
