	title	p:\COMscope\init.c
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
	public	bDriverNotLoaded
	extrn	DosOpen:proc
	extrn	_sprintfieee:proc
	extrn	WinMessageBox:proc
	extrn	MenuItemEnable:proc
	extrn	WinShowWindow:proc
	extrn	DosClose:proc
	extrn	DosLoadModule:proc
	extrn	DosQueryProcAddr:proc
	extrn	DosFreeModule:proc
	extrn	WinSetFocus:proc
	extrn	WinInvalidateRect:proc
	extrn	KillDisplayThread:proc
	extrn	KillMonitorThread:proc
	extrn	DosFreeMem:proc
	extrn	DosAllocMem:proc
	extrn	MenuItemCheck:proc
	extrn	WinSetWindowPos:proc
	extrn	ReadCaptureFile:proc
	extrn	ClearRowScrollBar:proc
	extrn	WinSendMsg:proc
	extrn	DosSleep:proc
	extrn	SetupRowScrolling:proc
	extrn	ErrorNotify:proc
	extrn	strcmp:proc
	extrn	OpenPort:proc
	extrn	strcpy:proc
	extrn	WinSetWindowText:proc
	extrn	IncrementFileExt:proc
	extrn	WriteCaptureFile:proc
	extrn	MonitorThread:proc
	extrn	DosCreateThread:proc
	extrn	DosPostEventSem:proc
	extrn	ColumnDisplayThread:proc
	extrn	RowDisplayThread:proc
	extrn	_fullDump:dword
	extrn	hCom:dword
	extrn	bRemoteServer:dword
	extrn	hwndFrame:dword
	extrn	stCFG:byte
	extrn	pfnFillDeviceNameList:dword
	extrn	stCOMiCFG:byte
	extrn	hwndClient:dword
	extrn	hwndStatus:dword
	extrn	pwCaptureBuffer:dword
	extrn	hProfileInstance:dword
	extrn	pfnGetProfileString:dword
	extrn	szDataFileSpec:byte
	extrn	szCaptureFileSpec:byte
	extrn	stRow:byte
	extrn	stWrite:byte
	extrn	stRead:byte
	extrn	bSkipInitPos:dword
	extrn	swpLastPosition:byte
	extrn	pwScrollBuffer:dword
	extrn	lWriteIndex:dword
	extrn	lScrollCount:dword
	extrn	szTitle:byte
	extrn	hwndStatDev:dword
	extrn	hwndStatModemIn:dword
	extrn	hwndStatModemOut:dword
	extrn	hwndStatRcvBuf:dword
	extrn	hwndStatXmitBuf:dword
	extrn	szCaptureFileName:byte
	extrn	bLaunchShutdownServer:dword
	extrn	bCommandLineDataFile:dword
	extrn	bStopMonitorThread:dword
	extrn	ulMonitorSleepCount:dword
	extrn	ulCalcSleepCount:dword
	extrn	tidMonitorThread:dword
	extrn	hevWaitCOMiDataSem:dword
	extrn	bStopDisplayThread:dword
	extrn	tidDisplayThread:dword
	extrn	stComCtl:byte
	extrn	stIOctl:byte
	extrn	bCOMscopeEnabled:dword
DATA32	segment
@STAT1	db "OS$tools",0h
	align 04h
@STAT2	db "COMi Device Driver not l"
db "oaded",0h
	align 04h
@STAT3	db "You will only be able to"
db " configure (install) dev"
db "ices for a future OS/2 s"
db "ession.",0ah,0ah,"Do you Still wa"
db "nt to run COMscope?",0h
@STAT4	db "CFG_DEB",0h
@STAT5	db "FillDeviceNameList",0h
	align 04h
@STAT6	db "No Available COMscope De"
db "vices",0h
	align 04h
@STAT7	db "There are no COMi contro"
db "lled COM ports available"
db " for COMscope access.",0h
	align 04h
@STAT8	db "There are no COMi contro"
db "lled serial ports define"
db "d.",0h
	align 04h
@STAT9	db "PROFDEB",0h
@STATa	db "GetProfileString",0h
	align 04h
@STATb	db "Data File",0h
	align 04h
@STATc	db "Capture File",0h
	align 04h
@STATd	db "Unable to allocate Scrol"
db "l Buffer (Auto Loading D"
db "ata).",0h
	align 04h
@STATe	db "CFG_DEB",0h
@STATf	db "FillDeviceNameList",0h
	align 04h
@STAT10	db "Port Not Available",0h
	align 04h
@STAT11	db "%s is not accessable.",0h
	align 04h
@STAT12	db "COMscope -> %s",0h
	align 04h
@STAT13	db "COMscope",0h
DATA32	ends
BSS32	segment
bDriverNotLoaded	dd 0h
	align 04h
comm	bBreakOn:dword
comm	szCurrentPortName:byte:014h
BSS32	ends
CODE32	segment

; 81   {
	align 010h

	public InitializeSystem
InitializeSystem	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0184h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,061h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 88   if (DosOpen(SPECIAL_DEVICE,&hCom,&ulAction,0L,0L,0x0001,0x21c2,0L) != 0)
	push	0h
	push	021c2h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-04h];	ulAction
	push	eax
	push	offset FLAT:hCom
	push	offset FLAT:@STAT1
	call	DosOpen
	add	esp,020h
	test	eax,eax
	je	@BLBL1

; 89     {
; 90     bDriverNotLoaded = TRUE;
	mov	dword ptr  bDriverNotLoaded,01h

; 91     if (!bRemoteServer)
	cmp	dword ptr  bRemoteServer,0h
	jne	@BLBL2

; 92       {
; 93       sprintf(szCaption,"COMi Device Driver not loaded");
	mov	edx,offset FLAT:@STAT2
	lea	eax,[ebp-054h];	szCaption
	call	_sprintfieee

; 94       sprintf(szMessage,"You will only be able to configure (install) devices for a future OS/2 session.\n\nDo you Still want to run COMscope?");
	mov	edx,offset FLAT:@STAT3
	lea	eax,[ebp-0180h];	szMessage
	call	_sprintfieee

; 95       if (WinMessageBox(HWND_DESKTOP,
	push	06114h
	push	09ca4h
	lea	eax,[ebp-054h];	szCaption
	push	eax
	lea	eax,[ebp-0180h];	szMessage
	push	eax
	push	dword ptr  hwndFrame
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,06h
	je	@BLBL2

; 96                       hwndFrame,
; 97                       szMessage,
; 98                       szCaption,
; 99                       HLPP_MB_NO_COMI,
; 100                       (MB_MOVEABLE | MB_YESNO | MB_HELP| MB_ICONQUESTION | MB_DEFBUTTON2)) != MBID_YES)
; 101         return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL2:

; 102       }
; 103     MenuItemEnable(hwndFrame,IDM_SSELECT,FALSE);
	push	0h
	push	07e5h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 104     MenuItemEnable(hwndFrame,IDM_OPTION,FALSE);
	push	0h
	push	07ech
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 105     MenuItemEnable(hwndFrame,IDM_ACTION,FALSE);
	push	0h
	push	07deh
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 106     stCFG.bMonitoringStream = FALSE;
	and	byte ptr  stCFG+017h,0dfh

; 107     WinShowWindow(hwndFrame,TRUE);
	push	01h
	push	dword ptr  hwndFrame
	call	WinShowWindow
	add	esp,08h

; 108     }
	jmp	@BLBL4
	align 010h
@BLBL1:

; 109   else
; 110     {
; 111     DosClose(hCom);
	push	dword ptr  hCom
	call	DosClose
	add	esp,04h

; 112     hCom = 0xffffffff;
	mov	dword ptr  hCom,0ffffffffh

; 113     if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-0184h];	hMod
	push	eax
	push	offset FLAT:@STAT4
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL5

; 114       {
; 115       if (DosQueryProcAddr(hMod,0,"FillDeviceNameList",(PFN *)&pfnFillDeviceNameList) == NO_ERROR)
	push	offset FLAT:pfnFillDeviceNameList
	push	offset FLAT:@STAT5
	push	0h
	push	dword ptr [ebp-0184h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL6

; 116         {
; 117         stCOMiCFG.pszPortName = stCFG.szPortName;
	mov	dword ptr  stCOMiCFG+014h,offset FLAT:stCFG+02h

; 118         stCOMiCFG.bEnumCOMscope = TRUE;
	or	byte ptr  stCOMiCFG+04bh,08h

; 119         stCOMiCFG.cbDevList = 0;
	mov	dword ptr  stCOMiCFG+02dh,0h

; 120         if (pfnFillDeviceNameList(&stCOMiCFG) == 0)
	push	offset FLAT:stCOMiCFG
	call	dword ptr  pfnFillDeviceNameList
	add	esp,04h
	test	eax,eax
	jne	@BLBL6

; 121           {
; 122           if (!bRemoteServer)
	cmp	dword ptr  bRemoteServer,0h
	jne	@BLBL8

; 123             {
; 124             sprintf(szCaption,"No Available COMscope Devices");
	mov	edx,offset FLAT:@STAT6
	lea	eax,[ebp-054h];	szCaption
	call	_sprintfieee

; 125             if (stCOMiCFG.iDeviceCount != 0)
	cmp	dword ptr  stCOMiCFG+043h,0h
	je	@BLBL9

; 126               {
; 127               sprintf(szMessage,"There are no COMi controlled COM ports available for COMscope access.");
	mov	edx,offset FLAT:@STAT7
	lea	eax,[ebp-0180h];	szMessage
	call	_sprintfieee

; 128               WinMessageBox(HWND_DESKTOP,
	push	02020h
	push	075afh
	lea	eax,[ebp-054h];	szCaption
	push	eax
	lea	eax,[ebp-0180h];	szMessage
	push	eax
	push	dword ptr  hwndFrame
	push	01h
	call	WinMessageBox
	add	esp,018h

; 129                             hwndFrame,
; 130                             szMessage,
; 131                             szCaption,
; 132                             HLPP_MB_NO_COMSCOPE_AVAIL,
; 133                             (MB_OK | MB_HELP | MB_ICONEXCLAMATION));
; 134               }
	jmp	@BLBL8
	align 010h
@BLBL9:

; 135             else
; 136               {
; 137               sprintf(szMessage,"There are no COMi controlled serial ports defined.");
	mov	edx,offset FLAT:@STAT8
	lea	eax,[ebp-0180h];	szMessage
	call	_sprintfieee

; 138               WinMessageBox(HWND_DESKTOP,
	push	02020h
	push	075b0h
	lea	eax,[ebp-054h];	szCaption
	push	eax
	lea	eax,[ebp-0180h];	szMessage
	push	eax
	push	dword ptr  hwndFrame
	push	01h
	call	WinMessageBox
	add	esp,018h

; 139                             hwndFrame,
; 140                             szMessage,
; 141                             szCaption,
; 142                             HLPP_MB_NO_COMSCOPE,
; 143                             (MB_OK | MB_HELP | MB_ICONEXCLAMATION));
; 144               }

; 145             }
@BLBL8:

; 146           MenuItemEnable(hwndFrame,IDM_SSELECT,FALSE);
	push	0h
	push	07e5h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 147           MenuItemEnable(hwndFrame,IDM_MSLEEP,FALSE);
	push	0h
	push	07e4h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 148           MenuItemEnable(hwndFrame,IDM_BUFFSIZE,FALSE);
	push	0h
	push	0805h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 149           MenuItemEnable(hwndFrame,IDM_ACTION,FALSE);
	push	0h
	push	07deh
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 150           MenuItemEnable(hwndFrame,IDM_SETUP,FALSE);
	push	0h
	push	07d5h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 151           MenuItemEnable(hwndFrame,IDM_IOCTL,FALSE);
	push	0h
	push	07efh
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 152           MenuItemEnable(hwndFrame,IDM_STATUS,FALSE);
	push	0h
	push	07fch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 153           MenuItemEnable(hwndFrame,IDM_SAVEDATAS,FALSE);
	push	0h
	push	07d7h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 154           MenuItemEnable(hwndFrame,IDM_SAVEDAT,FALSE);
	push	0h
	push	07d4h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 155           stCFG.szPortName[0] = 0;
	mov	byte ptr  stCFG+02h,0h

; 156           stCFG.bMonitoringStream = FALSE;
	and	byte ptr  stCFG+017h,0dfh

; 157           WinShowWindow(hwndFrame,TRUE);
	push	01h
	push	dword ptr  hwndFrame
	call	WinShowWindow
	add	esp,08h

; 158           DosFreeModule(hMod);
	push	dword ptr [ebp-0184h];	hMod
	call	DosFreeModule
	add	esp,04h

; 159           return(TRUE);
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL6:

; 160           }
; 161         }
; 162       DosFreeModule(hMod);
	push	dword ptr [ebp-0184h];	hMod
	call	DosFreeModule
	add	esp,04h

; 163       }
@BLBL5:

; 164     MenuItemEnable(hwndFrame,IDM_MDISPLAY,FALSE);
	push	0h
	push	07e3h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 165     MenuItemEnable(hwndFrame,IDM_MSTREAM,FALSE);
	push	0h
	push	07d9h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 166     }
@BLBL4:

; 167   MenuItemEnable(hwndFrame,IDM_SURFACE_THIS,FALSE);
	push	0h
	push	081ch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 168   MenuItemEnable(hwndFrame,IDM_VIEWDAT,FALSE);
	push	0h
	push	07d6h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 169   MenuItemEnable(hwndFrame,IDM_SAVEDAT,FALSE);
	push	0h
	push	07d4h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 170   MenuItemEnable(hwndFrame,IDM_SAVEDATAS,FALSE);
	push	0h
	push	07d7h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 171   MenuItemEnable(hwndFrame,IDM_MSLEEP,FALSE);
	push	0h
	push	07e4h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 172   MenuItemEnable(hwndFrame,IDM_SETUP,FALSE);
	push	0h
	push	07d5h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 173   MenuItemEnable(hwndFrame,IDM_IOCTL,FALSE);
	push	0h
	push	07efh
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 174   MenuItemEnable(hwndFrame,IDM_STATUS,FALSE);
	push	0h
	push	07fch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 175   StartSystem(&stCFG,FALSE);
	push	0h
	push	offset FLAT:stCFG
	call	StartSystem
	add	esp,08h

; 176   WinShowWindow(hwndFrame,TRUE);
	push	01h
	push	dword ptr  hwndFrame
	call	WinShowWindow
	add	esp,08h

; 177   WinSetFocus(HWND_DESKTOP,hwndFrame);
	push	dword ptr  hwndFrame
	push	01h
	call	WinSetFocus
	add	esp,08h

; 178   WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 179   WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 180   return(TRUE);
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
InitializeSystem	endp

; 184   {
	align 010h

	public StartSystem
StartSystem	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0b4h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,02dh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 192   KillDisplayThread();
	call	KillDisplayThread

; 193   KillMonitorThread();
	call	KillMonitorThread

; 194 
; 195   if (pwCaptureBuffer != NULL)
	cmp	dword ptr  pwCaptureBuffer,0h
	je	@BLBL11

; 196     DosFreeMem(pwCaptureBuffer);
	push	dword ptr  pwCaptureBuffer
	call	DosFreeMem
	add	esp,04h
@BLBL11:

; 197   DosAllocMem((PPVOID)&pwCaptureBuffer,(pstCFG->lBufferLength * 2),(PAG_COMMIT | PAG_READ | PAG_WRITE));
	push	013h
	mov	eax,[ebp+08h];	pstCFG
	mov	eax,[eax+0d5h]
	add	eax,eax
	push	eax
	push	offset FLAT:pwCaptureBuffer
	call	DosAllocMem
	add	esp,0ch

; 198 
; 199   if (hProfileInstance != NULL)
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL12

; 200     if (DosLoadModule(0,0,PROFILE_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-0ach];	hMod
	push	eax
	push	offset FLAT:@STAT9
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL12

; 201       {
; 202       if (DosQueryProcAddr(hMod,0,"GetProfileString",(PFN *)&pfnGetProfileString) == NO_ERROR)
	push	offset FLAT:pfnGetProfileString
	push	offset FLAT:@STATa
	push	0h
	push	dword ptr [ebp-0ach];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL14

; 203         {
; 204         pfnGetProfileString(hProfileInstance,"Data File",szDataFileSpec,CCHMAXPATH);
	push	0104h
	push	offset FLAT:szDataFileSpec
	push	offset FLAT:@STATb
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnGetProfileString
	add	esp,010h

; 205         pfnGetProfileString(hProfileInstance,"Capture File",szCaptureFileSpec,CCHMAXPATH);
	push	0104h
	push	offset FLAT:szCaptureFileSpec
	push	offset FLAT:@STATc
	push	dword ptr  hProfileInstance
	call	dword ptr  pfnGetProfileString
	add	esp,010h

; 206         }
@BLBL14:

; 207       DosFreeModule(hMod);
	push	dword ptr [ebp-0ach];	hMod
	call	DosFreeModule
	add	esp,04h

; 208       }
@BLBL12:

; 209 
; 210   if (!pstCFG->bColumnDisplay)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+018h],080h
	jne	@BLBL15

; 211     MenuItemCheck(hwndFrame,IDM_ROWS,TRUE);
	push	01h
	push	0813h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch
	jmp	@BLBL16
	align 010h
@BLBL15:

; 212   else
; 213     MenuItemCheck(hwndFrame,IDM_COLUMNS,TRUE);
	push	01h
	push	0814h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch
@BLBL16:

; 214   stRow.hwndClient = hwndClient;
	mov	eax,dword ptr  hwndClient
	mov	dword ptr  stRow+0fh,eax

; 215   if ((stWrite.bTestNewLine = pstCFG->bWriteTestNewLine) == TRUE)
	mov	ecx,[ebp+08h];	pstCFG
	mov	cl,[ecx+019h]
	and	ecx,0fh
	shr	ecx,03h
	mov	al,byte ptr  stWrite+02h
	and	al,0fdh
	sal	ecx,01h
	and	cl,03h
	or	al,cl
	mov	byte ptr  stWrite+02h,al
	mov	al,byte ptr  stWrite+02h
	and	eax,03h
	shr	eax,01h
	cmp	eax,01h
	jne	@BLBL17

; 216     stWrite.bWrap = pstCFG->bWriteWrap;
	mov	ecx,[ebp+08h];	pstCFG
	mov	cl,[ecx+016h]
	and	ecx,0ffh
	shr	ecx,07h
	mov	al,byte ptr  stWrite+02h
	and	al,0f7h
	sal	ecx,03h
	and	cl,0fh
	or	al,cl
	mov	byte ptr  stWrite+02h,al
	jmp	@BLBL18
	align 010h
@BLBL17:

; 217   else
; 218     stWrite.bWrap = TRUE;
	or	byte ptr  stWrite+02h,08h
@BLBL18:

; 219   stWrite.bSkipBlankLines = pstCFG->bSkipWriteBlankLines;
	mov	ecx,[ebp+08h];	pstCFG
	mov	cl,[ecx+018h]
	and	ecx,07fh
	shr	ecx,06h
	mov	al,byte ptr  stWrite+02h
	and	al,0fbh
	sal	ecx,02h
	and	cl,07h
	or	al,cl
	mov	byte ptr  stWrite+02h,al

; 220   stWrite.byNewLineChar = pstCFG->byWriteNewLineChar;
	mov	eax,[ebp+08h];	pstCFG
	mov	al,[eax+0ceh]
	mov	byte ptr  stWrite+03h,al

; 221   stWrite.bFilter = pstCFG->bFilterWrite;
	mov	ecx,[ebp+08h];	pstCFG
	mov	cl,[ecx+019h]
	and	ecx,03fh
	shr	ecx,05h
	mov	al,byte ptr  stWrite+02h
	and	al,0dfh
	sal	ecx,05h
	and	cl,03fh
	or	al,cl
	mov	byte ptr  stWrite+02h,al

; 222   stWrite.fFilterMask = pstCFG->fFilterWriteMask;
	mov	eax,[ebp+08h];	pstCFG
	mov	al,[eax+01ah]
	and	eax,0ffh
	shr	eax,04h
	mov	dword ptr  stWrite+07h,eax

; 223   stWrite.byDisplayMask = pstCFG->byWriteMask;
	mov	eax,[ebp+08h];	pstCFG
	mov	al,[eax+030h]
	mov	byte ptr  stWrite+04h,al

; 224   stWrite.lBackgrndColor = pstCFG->lWriteColBackgrndColor;
	mov	eax,[ebp+08h];	pstCFG
	mov	eax,[eax+0c5h]
	mov	dword ptr  stWrite+037h,eax

; 225   stWrite.lForegrndColor = pstCFG->lWriteColForegrndColor;
	mov	eax,[ebp+08h];	pstCFG
	mov	eax,[eax+0c9h]
	mov	dword ptr  stWrite+03bh,eax

; 226   stWrite.bSync = pstCFG->bSyncToWrite;
	mov	ecx,[ebp+08h];	pstCFG
	mov	cl,[ecx+019h]
	and	ecx,01h
	mov	al,byte ptr  stWrite+02h
	and	al,0efh
	sal	ecx,04h
	and	cl,01fh
	or	al,cl
	mov	byte ptr  stWrite+02h,al

; 227   if ((stRead.bTestNewLine = pstCFG->bReadTestNewLine) == TRUE)
	mov	ecx,[ebp+08h];	pstCFG
	mov	cl,[ecx+019h]
	and	ecx,07h
	shr	ecx,02h
	mov	al,byte ptr  stRead+02h
	and	al,0fdh
	sal	ecx,01h
	and	cl,03h
	or	al,cl
	mov	byte ptr  stRead+02h,al
	mov	al,byte ptr  stRead+02h
	and	eax,03h
	shr	eax,01h
	cmp	eax,01h
	jne	@BLBL19

; 228     stRead.bWrap = pstCFG->bReadWrap;
	mov	ecx,[ebp+08h];	pstCFG
	mov	cl,[ecx+016h]
	and	ecx,07fh
	shr	ecx,06h
	mov	al,byte ptr  stRead+02h
	and	al,0f7h
	sal	ecx,03h
	and	cl,0fh
	or	al,cl
	mov	byte ptr  stRead+02h,al
	jmp	@BLBL20
	align 010h
@BLBL19:

; 229   else
; 230     stRead.bWrap = TRUE;
	or	byte ptr  stRead+02h,08h
@BLBL20:

; 231   stRead.bSkipBlankLines = pstCFG->bSkipReadBlankLines;
	mov	ecx,[ebp+08h];	pstCFG
	mov	cl,[ecx+018h]
	and	ecx,03fh
	shr	ecx,05h
	mov	al,byte ptr  stRead+02h
	and	al,0fbh
	sal	ecx,02h
	and	cl,07h
	or	al,cl
	mov	byte ptr  stRead+02h,al

; 232   stRead.byNewLineChar = pstCFG->byReadNewLineChar;
	mov	eax,[ebp+08h];	pstCFG
	mov	al,[eax+0cdh]
	mov	byte ptr  stRead+03h,al

; 233   stRead.bFilter = pstCFG->bFilterRead;
	mov	ecx,[ebp+08h];	pstCFG
	mov	cl,[ecx+019h]
	and	ecx,01fh
	shr	ecx,04h
	mov	al,byte ptr  stRead+02h
	and	al,0dfh
	sal	ecx,05h
	and	cl,03fh
	or	al,cl
	mov	byte ptr  stRead+02h,al

; 234   stRead.fFilterMask = pstCFG->fFilterReadMask;
	mov	eax,[ebp+08h];	pstCFG
	mov	al,[eax+01ah]
	and	eax,0fh
	mov	dword ptr  stRead+07h,eax

; 235   stRead.byDisplayMask = pstCFG->byReadMask;
	mov	eax,[ebp+08h];	pstCFG
	mov	al,[eax+02fh]
	mov	byte ptr  stRead+04h,al

; 236   stRead.lBackgrndColor = pstCFG->lReadColBackgrndColor;
	mov	eax,[ebp+08h];	pstCFG
	mov	eax,[eax+0bdh]
	mov	dword ptr  stRead+037h,eax

; 237   stRead.lForegrndColor = pstCFG->lReadColForegrndColor;
	mov	eax,[ebp+08h];	pstCFG
	mov	eax,[eax+0c1h]
	mov	dword ptr  stRead+03bh,eax

; 238   stRead.bSync = pstCFG->bSyncToRead;
	mov	ecx,[ebp+08h];	pstCFG
	mov	cl,[ecx+019h]
	and	ecx,03h
	shr	ecx,01h
	mov	al,byte ptr  stRead+02h
	and	al,0efh
	sal	ecx,04h
	and	cl,01fh
	or	al,cl
	mov	byte ptr  stRead+02h,al

; 239   if ((hProfileInstance != NULL) && pstCFG->bLoadWindowPosition && !bRestart && !bSkipInitPos)
	cmp	dword ptr  hProfileInstance,0h
	je	@BLBL21
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+017h],040h
	je	@BLBL21
	cmp	dword ptr [ebp+0ch],0h;	bRestart
	jne	@BLBL21
	cmp	dword ptr  bSkipInitPos,0h
	jne	@BLBL21

; 240     {
; 241     swpLastPosition.x = pstCFG->ptlFramePos.x;
	mov	eax,[ebp+08h];	pstCFG
	mov	eax,[eax+03dh]
	mov	dword ptr  swpLastPosition+010h,eax

; 242     swpLastPosition.y = pstCFG->ptlFramePos.y;
	mov	eax,[ebp+08h];	pstCFG
	mov	eax,[eax+041h]
	mov	dword ptr  swpLastPosition+0ch,eax

; 243     swpLastPosition.cx = pstCFG->ptlFrameSize.x;
	mov	eax,[ebp+08h];	pstCFG
	mov	eax,[eax+035h]
	mov	dword ptr  swpLastPosition+08h,eax

; 244     swpLastPosition.cy = pstCFG->ptlFrameSize.y;
	mov	eax,[ebp+08h];	pstCFG
	mov	eax,[eax+039h]
	mov	dword ptr  swpLastPosition+04h,eax

; 245     WinSetWindowPos(hwndFrame,HWND_TOP,pstCFG->ptlFramePos.x,
	push	03h
	mov	eax,[ebp+08h];	pstCFG
	push	dword ptr [eax+039h]
	mov	eax,[ebp+08h];	pstCFG
	push	dword ptr [eax+035h]
	mov	eax,[ebp+08h];	pstCFG
	push	dword ptr [eax+041h]
	mov	eax,[ebp+08h];	pstCFG
	push	dword ptr [eax+03dh]
	push	03h
	push	dword ptr  hwndFrame
	call	WinSetWindowPos
	add	esp,01ch

; 246                                        pstCFG->ptlFramePos.y,
; 247                            
; 247             pstCFG->ptlFrameSize.x,
; 248                                        pstCFG->ptlFrameSize.y,
; 249                                       (SWP_MOVE | SWP_SIZE));
; 250     }
@BLBL21:

; 251   bSkipInitPos = FALSE;
	mov	dword ptr  bSkipInitPos,0h

; 252   if (pstCFG->fDisplaying & DISP_DATA)
	mov	eax,[ebp+08h];	pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	test	al,02h
	je	@BLBL22

; 253     pstCFG->fDisplaying = 0;
	mov	eax,[ebp+08h];	pstCFG
	and	byte ptr [eax+01bh],0e3h
@BLBL22:

; 254   MenuItemEnable(hwndFrame,IDM_SEARCH,FALSE);
	push	0h
	push	0826h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 255   MenuItemEnable(hwndFrame,IDM_SEARCH_NEXT,FALSE);
	push	0h
	push	0827h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 256   MenuItemEnable(hwndFrame,IDM_QUERY_INDEX,FALSE);
	push	0h
	push	0828h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 257   if (pstCFG->bLoadMonitor)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+017h],080h
	je	@BLBL23

; 258     {
; 259     if (pstCFG->fDisplaying & DISP_FILE)
	mov	eax,[ebp+08h];	pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	test	al,04h
	je	@BLBL24

; 260       {
; 261       pstCFG->fDisplaying = DISP_FILE;
	mov	eax,[ebp+08h];	pstCFG
	mov	cl,[eax+01bh]
	and	cl,0e3h
	or	cl,010h
	mov	[eax+01bh],cl

; 262       ulWordCount = pstCFG->lBufferLength;
	mov	eax,[ebp+08h];	pstCFG
	mov	eax,[eax+0d5h]
	mov	[ebp-04h],eax;	ulWordCount

; 263       if (pwScrollBuffer != NULL)
	cmp	dword ptr  pwScrollBuffer,0h
	je	@BLBL25

; 264         DosFreeMem(pwScrollBuffer);
	push	dword ptr  pwScrollBuffer
	call	DosFreeMem
	add	esp,04h
@BLBL25:

; 265       MenuItemEnable(hwndFrame,IDM_VIEWDAT,FALSE);
	push	0h
	push	07d6h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 266       if (DosAllocMem((PPVOID)&pwScrollBuffer,(ulWordCount * 2),(PAG_COMMIT | PAG_READ | PAG_WRITE)) == NO_ERROR)
	push	013h
	mov	eax,[ebp-04h];	ulWordCount
	add	eax,eax
	push	eax
	push	offset FLAT:pwScrollBuffer
	call	DosAllocMem
	add	esp,0ch
	test	eax,eax
	jne	@BLBL26

; 267         {
; 268         if (ReadCaptureFile(szDataFileSpec,&pwScrollBuffer,&ulWordCount,TRUE))
	push	01h
	lea	eax,[ebp-04h];	ulWordCount
	push	eax
	push	offset FLAT:pwScrollBuffer
	push	offset FLAT:szDataFileSpec
	call	ReadCaptureFile
	add	esp,010h
	test	eax,eax
	je	@BLBL27

; 269           {
; 270           MenuItemEnable(hwndFrame,IDM_SEARCH,TRUE);
	push	01h
	push	0826h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 271           MenuItemEnable(hwndFrame,IDM_SEARCH_NEXT,TRUE);
	push	01h
	push	0827h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 272           lWriteIndex = ulWordCount;
	mov	eax,[ebp-04h];	ulWordCount
	mov	dword ptr  lWriteIndex,eax

; 273           lScrollCount = ulWordCount;
	mov	eax,[ebp-04h];	ulWordCount
	mov	dword ptr  lScrollCount,eax

; 274           if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL28

; 275             {
; 276             ClearRowScrollBar(&stRow);
	push	offset FLAT:stRow
	call	ClearRowScrollBar
	add	esp,04h

; 277             stRead.lScrollIndex = pstCFG->lReadColScrollIndex;
	mov	eax,[ebp+08h];	pstCFG
	mov	eax,[eax+027h]
	mov	dword ptr  stRead+06fh,eax

; 278             stWrite.lScrollIndex = pstCFG->lWriteColScrollIndex;
	mov	eax,[ebp+08h];	pstCFG
	mov	eax,[eax+02bh]
	mov	dword ptr  stWrite+06fh,eax

; 279             WinSendMsg(stWrite.hwndClient,UM_SHOWAGAIN,0L,0L);
	push	0h
	push	0h
	push	08010h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h

; 280             WinSendMsg(stRead.hwndClient,UM_SHOWAGAIN,0L,0L);
	push	0h
	push	0h
	push	08010h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 281             }
	jmp	@BLBL29
	align 010h
@BLBL28:

; 282           else
; 283             {
; 284             WinSendMsg(stWrite.hwndClient,UM_HIDEWIN,0L,0L);
	push	0h
	push	0h
	push	08011h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h

; 285             WinSendMsg(stRead.hwndClient,UM_HIDEWIN,0L,0L);
	push	0h
	push	0h
	push	08011h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 286             DosSleep(100);
	push	064h
	call	DosSleep
	add	esp,04h

; 287             SetupRowScrolling(&stRow);
	push	offset FLAT:stRow
	call	SetupRowScrolling
	add	esp,04h

; 288             }
@BLBL29:

; 289           pstCFG->bMonitoringStream = FALSE;
	mov	eax,[ebp+08h];	pstCFG
	and	byte ptr [eax+017h],0dfh

; 290           }
	jmp	@BLBL24
	align 010h
@BLBL27:

; 291         else
; 292           {
; 293           DosFreeMem(pwScrollBuffer);
	push	dword ptr  pwScrollBuffer
	call	DosFreeMem
	add	esp,04h

; 294           pwScrollBuffer = NULL;
	mov	dword ptr  pwScrollBuffer,0h

; 295           }

; 296         }
	jmp	@BLBL24
	align 010h
@BLBL26:

; 297       else
; 298         ErrorNotify("Unable to allocate Scroll Buffer (Auto Loading Data).");
	push	offset FLAT:@STATd
	call	ErrorNotify
	add	esp,04h

; 299       }
@BLBL24:

; 300     if (pstCFG->szPortName[0] != 0)
	mov	eax,[ebp+08h];	pstCFG
	cmp	byte ptr [eax+02h],0h
	je	@BLBL23

; 301       {
; 302       if (bRestart)
	cmp	dword ptr [ebp+0ch],0h;	bRestart
	je	@BLBL33

; 303         {
; 304         if (strcmp(szCurrentPortName,stCFG.szPortName) == 0)
	mov	edx,offset FLAT:stCFG+02h
	mov	eax,offset FLAT:szCurrentPortName
	call	strcmp
	test	eax,eax
	jne	@BLBL34

; 305 //          if (hCom != 0xffffffff)
; 306             {
; 307             DosClose(hCom);
	push	dword ptr  hCom
	call	DosClose
	add	esp,04h

; 308             hCom = 0xffffffff;
	mov	dword ptr  hCom,0ffffffffh

; 309             }
@BLBL34:

; 310         if (DosLoadModule(0,0,CONFIG_LIBRARY,&hMod) == NO_ERROR)
	lea	eax,[ebp-0ach];	hMod
	push	eax
	push	offset FLAT:@STATe
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL33

; 311           {
; 312           stCOMiCFG.pszPortName = stCFG.szPortName;
	mov	dword ptr  stCOMiCFG+014h,offset FLAT:stCFG+02h

; 313           stCOMiCFG.bEnumCOMscope = TRUE;
	or	byte ptr  stCOMiCFG+04bh,08h

; 314           stCOMiCFG.bFindCOMscope = TRUE;
	or	byte ptr  stCOMiCFG+04bh,01h

; 315           stCOMiCFG.cbDevList = 0;
	mov	dword ptr  stCOMiCFG+02dh,0h

; 316           if (DosQueryProcAddr(hMod,0,"FillDeviceNameList",(PFN *)&pfnFillDeviceNameList) == NO_ERROR)
	push	offset FLAT:pfnFillDeviceNameList
	push	offset FLAT:@STATf
	push	0h
	push	dword ptr [ebp-0ach];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL36

; 317             bPortAvailable = pfnFillDeviceNameList(&stCOMiCFG);
	push	offset FLAT:stCOMiCFG
	call	dword ptr  pfnFillDeviceNameList
	add	esp,04h
	mov	[ebp-0b0h],eax;	bPortAvailable
@BLBL36:

; 318           DosFreeModule(hMod);
	push	dword ptr [ebp-0ach];	hMod
	call	DosFreeModule
	add	esp,04h

; 319           }

; 320         }
@BLBL33:

; 321       if (!bPortAvailable)
	cmp	dword ptr [ebp-0b0h],0h;	bPortAvailable
	jne	@BLBL37

; 322         {
; 323         if (!bRemoteServer)
	cmp	dword ptr  bRemoteServer,0h
	jne	@BLBL38

; 324           {
; 325           sprintf(szCaption,"Port Not Available");
	mov	edx,offset FLAT:@STAT10
	lea	eax,[ebp-054h];	szCaption
	call	_sprintfieee

; 326           sprintf(szMessage,"%s is not accessable.",pstCFG->szPortName);
	mov	eax,[ebp+08h];	pstCFG
	add	eax,02h
	push	eax
	mov	edx,offset FLAT:@STAT11
	lea	eax,[ebp-0a4h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 327           WinMessageBox(HWND_DESKTOP,
	push	06020h
	push	075b3h
	lea	eax,[ebp-054h];	szCaption
	push	eax
	lea	eax,[ebp-0a4h];	szMessage
	push	eax
	push	dword ptr  hwndFrame
	push	01h
	call	WinMessageBox
	add	esp,018h

; 328                         hwndFrame,
; 329                         szMessage,
; 330                         szCaption,
; 331                         HLPP_MB_COMSCOPE_PORT_NOT_AVAIL,
; 332                         (MB_OK | MB_HELP | MB_MOVEABLE | MB_ICONEXCLAMATION));
; 333           }
@BLBL38:

; 334         pstCFG->szPortName[0] = 0;
	mov	eax,[ebp+08h];	pstCFG
	mov	byte ptr [eax+02h],0h

; 335         pstCFG->bMonitoringStream = FALSE;
	mov	eax,[ebp+08h];	pstCFG
	and	byte ptr [eax+017h],0dfh

; 336         MenuItemCheck(hwndFrame,IDM_MDISPLAY,FALSE);
	push	0h
	push	07e3h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 337         pstCFG->fDisplaying &= ~DISP_STREAM;
	mov	eax,[ebp+08h];	pstCFG
	mov	[ebp-0b4h],eax;	@CBE20
	mov	eax,[ebp-0b4h];	@CBE20
	mov	dl,[eax+01bh]
	and	edx,01fh
	shr	edx,02h
	and	dl,0feh
	mov	cl,[eax+01bh]
	and	cl,0e3h
	sal	edx,02h
	and	dl,01fh
	or	cl,dl
	mov	[eax+01bh],cl

; 338         }
	jmp	@BLBL39
	align 010h
@BLBL37:

; 339       else
; 340         {
; 341         if (OpenPort(hwndFrame,&hCom,&stCFG))
	push	offset FLAT:stCFG
	push	offset FLAT:hCom
	push	dword ptr  hwndFrame
	call	OpenPort
	add	esp,0ch
	test	eax,eax
	je	@BLBL39

; 342           {
; 343           strcpy(szCurrentPortName,pstCFG->szPortName);
	mov	edx,[ebp+08h];	pstCFG
	add	edx,02h
	mov	eax,offset FLAT:szCurrentPortName
	call	strcpy

; 344           MenuItemEnable(hwndFrame,IDM_SETUP,TRUE);
	push	01h
	push	07d5h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 345           MenuItemEnable(hwndFrame,IDM_STATUS,TRUE);
	push	01h
	push	07fch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 346           MenuItemEnable(hwndFrame,IDM_IOCTL,TRUE);
	push	01h
	push	07efh
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 347           MenuItemEnable(hwndFrame,IDM_MSTREAM,TRUE);
	push	01h
	push	07d9h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 348           sprintf(szTitle,"COMscope -> %s",pstCFG->szPortName);
	mov	eax,[ebp+08h];	pstCFG
	add	eax,02h
	push	eax
	mov	edx,offset FLAT:@STAT12
	mov	eax,offset FLAT:szTitle
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 349           WinSetWindowText(hwndFrame,szTitle);
	push	offset FLAT:szTitle
	push	dword ptr  hwndFrame
	call	WinSetWindowText
	add	esp,08h

; 350           if (pstCFG->bLoadWindowPosition)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+017h],040h
	je	@BLBL41

; 351             {
; 352             if (pstCFG->bDDstatusActivated)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+017h],01h
	je	@BLBL42

; 353               WinSendMsg(hwndStatDev,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr  hwndStatDev
	call	WinSendMsg
	add	esp,010h
@BLBL42:

; 354             if (pstCFG->bMIstatusActivated)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+017h],02h
	je	@BLBL43

; 355               WinSendMsg(hwndStatModemIn,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr  hwndStatModemIn
	call	WinSendMsg
	add	esp,010h
@BLBL43:

; 356             if (pstCFG->bMOstatusActivated)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+017h],04h
	je	@BLBL44

; 357               WinSendMsg(hwndStatModemOut,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr  hwndStatModemOut
	call	WinSendMsg
	add	esp,010h
@BLBL44:

; 358             if (pstCFG->bRBstatusActivated)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+017h],08h
	je	@BLBL45

; 359               WinSendMsg(hwndStatRcvBuf,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr  hwndStatRcvBuf
	call	WinSendMsg
	add	esp,010h
@BLBL45:

; 360             if (pstCFG->bTBstatusActivated)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+017h],010h
	je	@BLBL41

; 361               WinSendMsg(hwndStatXmitBuf,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr  hwndStatXmitBuf
	call	WinSendMsg
	add	esp,010h

; 362             }
@BLBL41:

; 363           if (pstCFG->bMonitoringStream)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+017h],020h
	je	@BLBL39

; 364             {
; 365             if (pstCFG->bCaptureToFile)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+016h],020h
	je	@BLBL48

; 366               {
; 367               strcpy(szCaptureFileName,szCaptureFileSpec);
	mov	edx,offset FLAT:szCaptureFileSpec
	mov	eax,offset FLAT:szCaptureFileName
	call	strcpy

; 368               if (bLaunchShutdownServer)
	cmp	dword ptr  bLaunchShutdownServer,0h
	je	@BLBL49

; 369                 IncrementFileExt(szCaptureFileName,FALSE);
	push	0h
	push	offset FLAT:szCaptureFileName
	call	IncrementFileExt
	add	esp,08h
	jmp	@BLBL50
	align 010h
@BLBL49:

; 370               else
; 371                 IncrementFileExt(szCaptureFileName,TRUE);
	push	01h
	push	offset FLAT:szCaptureFileName
	call	IncrementFileExt
	add	esp,08h
@BLBL50:

; 372               if (bCommandLineDataFile || bLaunchShutdownServer)
	cmp	dword ptr  bCommandLineDataFile,0h
	jne	@BLBL51
	cmp	dword ptr  bLaunchShutdownServer,0h
	je	@BLBL52
@BLBL51:

; 373                 fWriteMode = FOPEN_OVERWRITE;
	mov	dword ptr [ebp-0a8h],01h;	fWriteMode
	jmp	@BLBL53
	align 010h
@BLBL52:

; 374               else
; 375                 fWriteMode = FOPEN_NORMAL;
	mov	dword ptr [ebp-0a8h],0h;	fWriteMode
@BLBL53:

; 376               if (!WriteCaptureFile(szCaptureFileName,pwCaptureBuffer,0,fWriteMode,HLPP_MB_OVERWRT_CAP_FILE))
	push	09ca9h
	push	dword ptr [ebp-0a8h];	fWriteMode
	push	0h
	push	dword ptr  pwCaptureBuffer
	push	offset FLAT:szCaptureFileName
	call	WriteCaptureFile
	add	esp,014h
	test	eax,eax
	jne	@BLBL48

; 377                 pstCFG->bCaptureToFile = FALSE;
	mov	eax,[ebp+08h];	pstCFG
	and	byte ptr [eax+016h],0dfh

; 378               }
@BLBL48:

; 379             bStopMonitorThread = FALSE;
	mov	dword ptr  bStopMonitorThread,0h

; 380             if (pstCFG->ulUserSleepCount != 0)
	mov	eax,[ebp+08h];	pstCFG
	cmp	dword ptr [eax+0d1h],0h
	je	@BLBL55

; 381               ulMonitorSleepCount = pstCFG->ulUserSleepCount;
	mov	eax,[ebp+08h];	pstCFG
	mov	eax,[eax+0d1h]
	mov	dword ptr  ulMonitorSleepCount,eax
	jmp	@BLBL56
	align 010h
@BLBL55:

; 382             else
; 383               ulMonitorSleepCount = ulCalcSleepCount;
	mov	eax,dword ptr  ulCalcSleepCount
	mov	dword ptr  ulMonitorSleepCount,eax
@BLBL56:

; 384             DosCreateThread(&tidMonitorThread,(PFNTHREAD)MonitorThread,(ULONG)hCom,0L,4096);            ClearRowScrollBar(&stRow);
	push	01000h
	push	0h
	push	dword ptr  hCom
	push	offset FLAT: MonitorThread
	push	offset FLAT:tidMonitorThread
	call	DosCreateThread
	add	esp,014h
	push	offset FLAT:stRow
	call	ClearRowScrollBar
	add	esp,04h

; 385             if (pstCFG->fDisplaying & DISP_STREAM)
	mov	eax,[ebp+08h];	pstCFG
	mov	al,[eax+01bh]
	and	eax,01fh
	shr	eax,02h
	test	al,01h
	je	@BLBL39

; 386               {
; 387               if (pstCFG->ulUserSleepCount == 0)
	mov	eax,[ebp+08h];	pstCFG
	cmp	dword ptr [eax+0d1h],0h
	jne	@BLBL58

; 388                 if (ulMonitorSleepCount > 200)                  ulMonitorSleepCount = 200;
	cmp	dword ptr  ulMonitorSleepCount,0c8h
	jbe	@BLBL58
	mov	dword ptr  ulMonitorSleepCount,0c8h
@BLBL58:

; 389               DosPostEventSem(hevWaitCOMiDataSem);
	push	dword ptr  hevWaitCOMiDataSem
	call	DosPostEventSem
	add	esp,04h

; 390               stRow.lLeadIndex = 0;
	mov	dword ptr  stRow+073h,0h

; 391               bStopDisplayThread = FALSE;
	mov	dword ptr  bStopDisplayThread,0h

; 392               if (pstCFG->bColumnDisplay)
	mov	eax,[ebp+08h];	pstCFG
	test	byte ptr [eax+018h],080h
	je	@BLBL60

; 393                 {
; 394                 WinSendMsg(stWrite.hwndClient,UM_SHOWNEW,0L,0L);
	push	0h
	push	0h
	push	0800fh
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h

; 395                 WinSendMsg(stRead.hwndClient,UM_SHOWNEW,0L,0L);
	push	0h
	push	0h
	push	0800fh
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 396                 DosCreateThread(&tidDisplayThread,(PFNTHREAD)ColumnDisplayThread,0L,0L,4096);
	push	01000h
	push	0h
	push	0h
	push	offset FLAT: ColumnDisplayThread
	push	offset FLAT:tidDisplayThread
	call	DosCreateThread
	add	esp,014h

; 397                 }
	jmp	@BLBL61
	align 010h
@BLBL60:

; 398               else
; 399                 {
; 400                 WinSendMsg(stWrite.hwndClient,UM_HIDEWIN,0L,0L);
	push	0h
	push	0h
	push	08011h
	push	dword ptr  stWrite+0fh
	call	WinSendMsg
	add	esp,010h

; 401                 WinSendMsg(stRead.hwndClient,UM_HIDEWIN,0L,0L);
	push	0h
	push	0h
	push	08011h
	push	dword ptr  stRead+0fh
	call	WinSendMsg
	add	esp,010h

; 402                 DosCreateThread(&tidDisplayThread,(PFNTHREAD)RowDisplayThread,0L,0L,4096);
	push	01000h
	push	0h
	push	0h
	push	offset FLAT: RowDisplayThread
	push	offset FLAT:tidDisplayThread
	call	DosCreateThread
	add	esp,014h

; 403                 WinInvalidateRect(hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndClient
	call	WinInvalidateRect
	add	esp,0ch

; 404                 }
@BLBL61:

; 405               MenuItemCheck(hwndFrame,IDM_MDISPLAY,TRUE);
	push	01h
	push	07e3h
	push	dword ptr  hwndFrame
	call	MenuItemCheck
	add	esp,0ch

; 406               WinInvalidateRect(hwndStatus,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  hwndStatus
	call	WinInvalidateRect
	add	esp,0ch

; 407               }

; 408             }

; 409           }

; 410         }
@BLBL39:

; 411       if (pstCFG->szPortName[0] == 0)
	mov	eax,[ebp+08h];	pstCFG
	cmp	byte ptr [eax+02h],0h
	jne	@BLBL23

; 412         {
; 413         MenuItemEnable(hwndFrame,IDM_SETUP,FALSE);
	push	0h
	push	07d5h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 414         MenuItemEnable(hwndFrame,IDM_STATUS,FALSE);
	push	0h
	push	07fch
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 415         MenuItemEnable(hwndFrame,IDM_IOCTL,FALSE);
	push	0h
	push	07efh
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 416         MenuItemEnable(hwndFrame,IDM_MSTREAM,FALSE);
	push	0h
	push	07d9h
	push	dword ptr  hwndFrame
	call	MenuItemEnable
	add	esp,0ch

; 417         sprintf(szTitle,"COMscope");
	mov	edx,offset FLAT:@STAT13
	mov	eax,offset FLAT:szTitle
	call	_sprintfieee

; 418         WinSetWindowText(hwndFrame,szTitle);
	push	offset FLAT:szTitle
	push	dword ptr  hwndFrame
	call	WinSetWindowText
	add	esp,08h

; 419         }

; 420       }

; 421     }
@BLBL23:

; 422   }
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
StartSystem	endp

; 425   {
	align 010h

	public InitializeData
InitializeData	proc
	push	ebp
	mov	ebp,esp

; 426   stComCtl.cbSize = sizeof(COMCTL);
	mov	word ptr  stComCtl,044h

; 427   stComCtl.pszPortName = stCFG.szPortName;
	mov	dword ptr  stComCtl+02h,offset FLAT:stCFG+02h

; 428   stComCtl.pstIOctl = &stIOctl;
	mov	dword ptr  stComCtl+010h,offset FLAT:stIOctl

; 429 
; 430   stCFG.iSampleCount = 10;
	mov	dword ptr  stCFG+0dfh,0ah

; 431   stCFG.cbCFGsize = sizeof(CSCFG);
	mov	word ptr  stCFG,0e3h

; 432   stCFG.szPortName[0] = 0;
	mov	byte ptr  stCFG+02h,0h

; 433   stCFG.bInsert = FALSE;
	and	byte ptr  stCFG+016h,0fbh

; 434   stCFG.bIsInstall = TRUE;
	or	byte ptr  stCFG+016h,02h

; 435   stCFG.bIsInstall = FALSE;
	and	byte ptr  stCFG+016h,0fdh

; 436   bBreakOn = FALSE;
	mov	dword ptr  bBreakOn,0h

; 437   bCOMscopeEnabled = FALSE;
	mov	dword ptr  bCOMscopeEnabled,0h

; 438   bStopDisplayThread = TRUE;
	mov	dword ptr  bStopDisplayThread,01h

; 439   bStopMonitorThread = TRUE;
	mov	dword ptr  bStopMonitorThread,01h

; 440 
; 441   stCFG.bPopupParams = FALSE;
	and	byte ptr  stCFG+019h,0bfh

; 442   stCFG.bShowCounts = TRUE;
	or	byte ptr  stCFG+016h,010h

; 443   stCFG.bReadWrap = TRUE;
	or	byte ptr  stCFG+016h,040h

; 444   stCFG.bWriteWrap = TRUE;
	or	byte ptr  stCFG+016h,080h

; 445   stCFG.bErrorOut = FALSE;
	and	byte ptr  stCFG+018h,0fbh

; 446   stCFG.wUpdateDelay = 1000;
	mov	word ptr  stCFG+0cfh,03e8h

; 447   stCFG.ulUserSleepCount = 200;
	mov	dword ptr  stCFG+0d1h,0c8h

; 448   stCFG.lBufferLength = DEF_CAP_BUFF_LEN;
	mov	dword ptr  stCFG+0d5h,08000h

; 449   stCFG.wRowFont = HEX_FONT;
	mov	word ptr  stCFG+0d9h,0h

; 450   stCFG.wColReadFont = ASCII_FONT;
	mov	word ptr  stCFG+0dbh,01h

; 451   stCFG.wColWriteFont = ASCII_FONT;
	mov	word ptr  stCFG+0ddh,01h

; 452   stCFG.bHiLightImmediateByte = FALSE;
	and	byte ptr  stCFG+018h,0f7h

; 453   stCFG.bSampleCounts = TRUE;
	or	byte ptr  stCFG+018h,010h

; 454   stCFG.fLockWidth = LOCK_NONE;
	and	byte ptr  stCFG+01bh,0fch

; 455   stCFG.lLockWidth = 0L;
	mov	dword ptr  stCFG+031h,0h

; 456   stCFG.byReadMask = '\xff';
	mov	byte ptr  stCFG+02fh,0ffh

; 457   stCFG.byWriteMask = '\xff'
; 457 ;
	mov	byte ptr  stCFG+030h,0ffh

; 458 
; 459   stCFG.bMarkCurrentLine = TRUE;
	or	byte ptr  stCFG+01eh,040h

; 460   stCFG.bSilentStatus = FALSE;
	and	byte ptr  stCFG+016h,0feh

; 461   stCFG.bOverWriteBuffer = TRUE;
	or	byte ptr  stCFG+018h,02h

; 462   stCFG.bCaptureToFile = FALSE;
	and	byte ptr  stCFG+016h,0dfh

; 463   stCFG.bDDstatusActivated = FALSE;
	and	byte ptr  stCFG+017h,0feh

; 464   stCFG.ptlDDstatusPos.y = -40;
	mov	dword ptr  stCFG+049h,0ffffffd8h

; 465   stCFG.bMIstatusActivated = FALSE;
	and	byte ptr  stCFG+017h,0fdh

; 466   stCFG.ptlMIstatusPos.y = -40;
	mov	dword ptr  stCFG+051h,0ffffffd8h

; 467   stCFG.bMOstatusActivated = FALSE;
	and	byte ptr  stCFG+017h,0fbh

; 468   stCFG.ptlMOstatusPos.y = -40;
	mov	dword ptr  stCFG+059h,0ffffffd8h

; 469   stCFG.bRBstatusActivated = FALSE;
	and	byte ptr  stCFG+017h,0f7h

; 470   stCFG.ptlRBstatusPos.y = -40;
	mov	dword ptr  stCFG+061h,0ffffffd8h

; 471   stCFG.bTBstatusActivated = FALSE;
	and	byte ptr  stCFG+017h,0efh

; 472   stCFG.ptlTBstatusPos.y = -40;
	mov	dword ptr  stCFG+069h,0ffffffd8h

; 473 
; 474   stCFG.fTraceEvent = (CSFUNC_TRACE_INPUT_STREAM |
	mov	dword ptr  stCFG+01fh,06h

; 475                        CSFUNC_TRACE_OUTPUT_STREAM);
; 476   stCFG.bDispWrite = TRUE;
	or	byte ptr  stCFG+01bh,020h

; 477   stCFG.bDispRead = TRUE;
	or	byte ptr  stCFG+01bh,040h

; 478   stCFG.bDispIMM = FALSE;
	and	byte ptr  stCFG+01bh,07fh

; 479   stCFG.bDispModemOut = FALSE;
	and	byte ptr  stCFG+01ch,0fdh

; 480   stCFG.bDispModemIn = FALSE;
	and	byte ptr  stCFG+01ch,0feh

; 481   stCFG.bDispOpen = FALSE;
	and	byte ptr  stCFG+01ch,0fbh

; 482   stCFG.bDispWriteReq = FALSE;
	and	byte ptr  stCFG+01ch,0f7h

; 483   stCFG.bDispReadReq = FALSE;
	and	byte ptr  stCFG+01ch,0efh

; 484   stCFG.bDispDevIOctl = FALSE;
	and	byte ptr  stCFG+01ch,0dfh

; 485   stCFG.bDispErrors = FALSE;
	and	byte ptr  stCFG+01ch,0bfh

; 486 
; 487   stCFG.bFindStrNoCase = FALSE;
	and	byte ptr  stCFG+01eh,0dfh

; 488   stCFG.bFindStrHEX = FALSE;
	and	byte ptr  stCFG+01eh,0efh

; 489   stCFG.bFindForward = TRUE;
	or	byte ptr  stCFG+01dh,01h

; 490   stCFG.bFindWrap = FALSE;
	and	byte ptr  stCFG+01ch,07fh

; 491   stCFG.bFindWrite = FALSE;
	and	byte ptr  stCFG+01dh,0f7h

; 492   stCFG.bFindRead = FALSE;
	and	byte ptr  stCFG+01dh,0fbh

; 493   stCFG.bFindString = FALSE;
	and	byte ptr  stCFG+01dh,0fdh

; 494   stCFG.bFindIMM = FALSE;
	and	byte ptr  stCFG+01dh,0efh

; 495   stCFG.bFindModemOut = FALSE;
	and	byte ptr  stCFG+01dh,0bfh

; 496   stCFG.bFindModemIn = FALSE;
	and	byte ptr  stCFG+01dh,0dfh

; 497   stCFG.bFindOpen = FALSE;
	and	byte ptr  stCFG+01dh,07fh

; 498   stCFG.bFindWriteReq = FALSE;
	and	byte ptr  stCFG+01eh,0feh

; 499   stCFG.bFindReadReq = FALSE;
	and	byte ptr  stCFG+01eh,0fdh

; 500   stCFG.bFindDevIOctl = FALSE;
	and	byte ptr  stCFG+01eh,0fbh

; 501   stCFG.bFindErrors = FALSE;
	and	byte ptr  stCFG+01eh,0f7h

; 502 
; 503   stCFG.lModemInBackgrndColor = CLR_PALEGRAY;
	mov	dword ptr  stCFG+075h,0fh

; 504   stCFG.lModemInForegrndColor = CLR_BLACK;
	mov	dword ptr  stCFG+079h,0ffffffffh

; 505   stCFG.lModemOutBackgrndColor = CLR_PALEGRAY;
	mov	dword ptr  stCFG+06dh,0fh

; 506   stCFG.lModemOutForegrndColor = CLR_BLACK;
	mov	dword ptr  stCFG+071h,0ffffffffh

; 507   stCFG.lWriteReqBackgrndColor = CLR_PALEGRAY;
	mov	dword ptr  stCFG+095h,0fh

; 508   stCFG.lWriteReqForegrndColor = CLR_BLUE;
	mov	dword ptr  stCFG+099h,01h

; 509   stCFG.lErrorBackgrndColor = CLR_RED;
	mov	dword ptr  stCFG+085h,02h

; 510   stCFG.lErrorForegrndColor = CLR_YELLOW;
	mov	dword ptr  stCFG+089h,06h

; 511   stCFG.lReadReqBackgrndColor = CLR_PALEGRAY;
	mov	dword ptr  stCFG+08dh,0fh

; 512   stCFG.lReadReqForegrndColor = CLR_PINK;
	mov	dword ptr  stCFG+091h,03h

; 513   stCFG.lDevIOctlBackgrndColor = CLR_PALEGRAY;
	mov	dword ptr  stCFG+09dh,0fh

; 514   stCFG.lDevIOctlForegrndColor = CLR_DARKGREEN;
	mov	dword ptr  stCFG+0a1h,0ch

; 515   stCFG.lOpenBackgrndColor = CLR_PALEGRAY;
	mov	dword ptr  stCFG+07dh,0fh

; 516   stCFG.lOpenForegrndColor = CLR_RED;
	mov	dword ptr  stCFG+081h,02h

; 517   stCFG.lReadBackgrndColor = CLR_BLACK;
	mov	dword ptr  stCFG+0a5h,0ffffffffh

; 518   stCFG.lReadForegrndColor = CLR_WHITE;
	mov	dword ptr  stCFG+0a9h,0fffffffeh

; 519   stCFG.lWriteBackgrndColor = CLR_WHITE;
	mov	dword ptr  stCFG+0adh,0fffffffeh

; 520   stCFG.lWriteForegrndColor = CLR_BLACK;
	mov	dword ptr  stCFG+0b1h,0ffffffffh

; 521   stCFG.lReadColBackgrndColor = CLR_WHITE;
	mov	dword ptr  stCFG+0bdh,0fffffffeh

; 522   stCFG.lReadColForegrndColor = CLR_BLACK;
	mov	dword ptr  stCFG+0c1h,0ffffffffh

; 523   stCFG.lWriteColBackgrndColor = CLR_WHITE;
	mov	dword ptr  stCFG+0c5h,0fffffffeh

; 524   stCFG.lWriteColForegrndColor = CLR_BLACK;
	mov	dword ptr  stCFG+0c9h,0ffffffffh

; 525   stCFG.lStatusBackgrndColor = CLR_BROWN;
	mov	dword ptr  stCFG+0b5h,0eh

; 526   stCFG.lStatusForegrndColor = CLR_WHITE;
	mov	dword ptr  stCFG+0b9h,0fffffffeh

; 527   stCFG.bStickyMenus = TRUE;
	or	byte ptr  stCFG+016h,08h

; 528   stCFG.bSyncToWrite = TRUE;
	or	byte ptr  stCFG+019h,01h

; 529   stCFG.bSyncToRead = FALSE;
	and	byte ptr  stCFG+019h,0fdh

; 530   stCFG.fDisplaying = 0;
	and	byte ptr  stCFG+01bh,0e3h

; 531   stCFG.bMonitoringStream = FALSE;
	and	byte ptr  stCFG+017h,0dfh

; 532   if (bLaunchShutdownServer)
	cmp	dword ptr  bLaunchShutdownServer,0h
	je	@BLBL63

; 533     {
; 534     stCFG.bLoadMonitor = TRUE;
	or	byte ptr  stCFG+017h,080h

; 535     stCFG.bAutoSaveConfig = TRUE;
	or	byte ptr  stCFG+018h,01h

; 536     }
	jmp	@BLBL64
	align 010h
@BLBL63:

; 537   else
; 538     {
; 539     stCFG.bLoadMonitor = FALSE;
	and	byte ptr  stCFG+017h,07fh

; 540     stCFG.bAutoSaveConfig = FALSE;
	and	byte ptr  stCFG+018h,0feh

; 541     }
@BLBL64:

; 542   stCFG.bLoadWindowPosition = FALSE;
	and	byte ptr  stCFG+017h,0bfh

; 543   stCFG.bFilterRead = TRUE;
	or	byte ptr  stCFG+019h,010h

; 544   stCFG.bFilterWrite = TRUE;
	or	byte ptr  stCFG+019h,020h

; 545   stCFG.fFilterReadMask = FILTER_NPRINT;
	mov	al,byte ptr  stCFG+01ah
	and	al,0f0h
	or	al,01h
	mov	byte ptr  stCFG+01ah,al

; 546   stCFG.fFilterWriteMask = FILTER_NPRINT;
	mov	al,byte ptr  stCFG+01ah
	and	al,0fh
	or	al,010h
	mov	byte ptr  stCFG+01ah,al

; 547   stCFG.bSkipReadBlankLines = TRUE;
	or	byte ptr  stCFG+018h,020h

; 548   stCFG.bSkipWriteBlankLines = TRUE;
	or	byte ptr  stCFG+018h,040h

; 549   stCFG.bColumnDisplay = FALSE;
	and	byte ptr  stCFG+018h,07fh

; 550   stCFG.bReadTestNewLine = TRUE;
	or	byte ptr  stCFG+019h,04h

; 551   stCFG.bWriteTestNewLine = TRUE;
	or	byte ptr  stCFG+019h,08h

; 552   stCFG.byReadNewLineChar = '\x0d';
	mov	byte ptr  stCFG+0cdh,0dh

; 553   stCFG.byWriteNewLineChar = '\x0d';
	mov	byte ptr  stCFG+0ceh,0dh

; 554   }
	mov	esp,ebp
	pop	ebp
	ret	
InitializeData	endp
CODE32	ends
end
