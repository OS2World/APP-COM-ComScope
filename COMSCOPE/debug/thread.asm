	title	p:\COMscope\thread.c
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
	public	bAbort
	public	lWriteIndex
	public	lReadIndex
	public	bBufferWrapped
	extrn	WinPostMsg:proc
	extrn	DosSetPriority:proc
	extrn	DosWaitEventSem:proc
	extrn	DosResetEventSem:proc
	extrn	DosRequestMutexSem:proc
	extrn	WinGetPS:proc
	extrn	GpiCreateLogFont:proc
	extrn	GpiSetCharSet:proc
	extrn	GpiSetBackMix:proc
	extrn	WinReleasePS:proc
	extrn	DosReleaseMutexSem:proc
	extrn	DosSleep:proc
	extrn	WinFillRect:proc
	extrn	GpiSetBackColor:proc
	extrn	GpiSetColor:proc
	extrn	GpiCharStringAt:proc
	extrn	DosPostEventSem:proc
	extrn	CharPrintable:proc
	extrn	EnableCOMscope:proc
	extrn	DosAllocMem:proc
	extrn	_sprintfieee:proc
	extrn	ErrorNotify:proc
	extrn	DosExit:proc
	extrn	GetBaudRate:proc
	extrn	CalcThreadSleepCount:proc
	extrn	memset:proc
	extrn	AccessCOMscope:proc
	extrn	DosFreeMem:proc
	extrn	WriteCaptureFile:proc
	extrn	DosStartSession:proc
	extrn	DosTransactNPipe:proc
	extrn	DosClose:proc
	extrn	DosCallNPipe:proc
	extrn	DosCreateNPipe:proc
	extrn	DosCreateEventSem:proc
	extrn	DosSetNPipeSem:proc
	extrn	DosConnectNPipe:proc
	extrn	DosRead:proc
	extrn	DosWrite:proc
	extrn	_debug_malloc:proc
	extrn	memcpy:proc
	extrn	DosDisConnectNPipe:proc
	extrn	DosCloseEventSem:proc
	extrn	_fullDump:dword
	extrn	hwndClient:dword
	extrn	stRow:byte
	extrn	stCell:dword
	extrn	tidDisplayThread:dword
	extrn	bStopDisplayThread:dword
	extrn	hevDisplayWaitDataSem:dword
	extrn	hmtxRowGioBlockedSem:dword
	extrn	astFontAttributes:byte
	extrn	stCFG:byte
	extrn	pwCaptureBuffer:dword
	extrn	bDebuggingCOMscope:dword
	extrn	lStatusHeight:dword
	extrn	hevKillDisplayThreadSem:dword
	extrn	stRead:byte
	extrn	stWrite:byte
	extrn	hmtxColGioBlockedSem:dword
	extrn	hwndFrame:dword
	extrn	stIOctl:byte
	extrn	ulMonitorSleepCount:dword
	extrn	bDataToView:dword
	extrn	stCharCount:byte
	extrn	bCaptureFileWritten:dword
	extrn	tidMonitorThread:dword
	extrn	bStopMonitorThread:dword
	extrn	hevWaitCOMiDataSem:dword
	extrn	szCaptureFileName:byte
	extrn	hevKillMonitorThreadSem:dword
	extrn	tidIPCserverThread:dword
	extrn	bIsTheFirst:dword
	extrn	stSD:byte
	extrn	bShowServerProcess:dword
	extrn	szIPCpipeName:byte
	extrn	szCOMscopeIniPath:byte
	extrn	chPipeDebug:byte
	extrn	ulSessionID:dword
	extrn	pidSession:dword
	extrn	stIPCpipe:byte
	extrn	bIPCpipeOpen:dword
	extrn	hIPCpipe:dword
	extrn	ulBytesRead:dword
	extrn	szIPCpipe:byte
	extrn	ulIPCpipeInstance:dword
	extrn	bStopIPCserverThread:dword
	extrn	hmtxIPCpipeBlockedSem:dword
	extrn	ulServerMessage:dword
	extrn	szCOMscopePipe:byte
	extrn	hCOMscopePipe:dword
	extrn	hevCOMscopeSem:dword
	extrn	stPipeCmd:byte
	extrn	bStopRemotePipe:dword
	extrn	stPipeMsg:byte
DATA32	segment
@STAT1	db "HEXFONTS",0h
	align 04h
@STAT2	db "HEXFONTS",0h
	align 04h
@STAT3	db "HEXFONTS",0h
	align 04h
@STAT4	db "HEXFONTS",0h
	align 04h
@STAT5	db "HEXFONTS",0h
	align 04h
@STAT6	db "HEXFONTS",0h
	align 04h
@STAT7	db "Unable to allocate COMsc"
db "ope/COMi buffer (Monitor"
db " Thread).",0h
	align 04h
@STAT8	db "Unable to allocate new c"
db "apture buffer (Monitor T"
db "hread).",0h
@STAT9	db "OS/tools IPC Server - %s"
db 0h
	align 04h
@STATa	db "%sCONTROL.EXE",0h
	align 04h
@STATb	db "/T%s /D%c",0h
	align 04h
@STATc	db "/T%s",0h
	align 04h
@STATd	db "Invalid Session ID, star"
db "ting IPC server",0h
@STATe	db "Error starting IPC serve"
db "r - Process not parent",0h
	align 04h
@STATf	db "Retry Sub-Allocation, st"
db "arting IPC server",0h
	align 04h
@STAT10	db "Unkown Error = %u - star"
db "ting IPC server",0h
@STAT11	db "Pipe busy, sending watch"
db "dog message",0h
@STAT12	db "Remote Server Started",0h
	align 04h
@STAT13	db "Session Close message re"
db "ceived - Closing this se"
db "ssion",0h
	align 04h
@STAT14	db "p:\COMscope\thread.c",0h
	align 04h
@STAT15	db "Unable to create remote "
db "named pipe",0ah,0h
DATA32	ends
BSS32	segment
bAbort	dd 0h
lWriteIndex	dd 0h
lReadIndex	dd 0h
bBufferWrapped	dd 0h
comm	szServerCommand:byte:064h
comm	stPosition:byte:08h
BSS32	ends
CODE32	segment

; 109   {
	align 010h

	public RowDisplayThread
RowDisplayThread	proc
	push	ebp
	mov	ebp,esp
	sub	esp,064h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,019h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 115   BOOL bScreenWrapped = FALSE;
	mov	dword ptr [ebp-040h],0h;	bScreenWrapped

; 116   USHORT wChar;
; 117   USHORT wDirection;
; 118   ULONG ulPostCount;
; 119   WORD wLastDirection = CS_READ;
	mov	word ptr [ebp-04ah],04000h;	wLastDirection

; 120   BOOL bDisplayCharacter = TRUE;
	mov	dword ptr [ebp-050h],01h;	bDisplayCharacter

; 121   LONG lCharacterCount;
; 122   BOOL bDisplaySignal = FALSE;
	mov	dword ptr [ebp-058h],0h;	bDisplaySignal

; 123   BOOL bLastWasOverflow = FALSE;
	mov	dword ptr [ebp-05ch],0h;	bLastWasOverflow

; 124   LONG lPacketCount;
; 125   LONG lMarker;
; 126 
; 127   WinPostMsg(hwndClient,UM_STARTDISPLAYTHREAD,0L,0L);
	push	0h
	push	0h
	push	08018h
	push	dword ptr  hwndClient
	call	WinPostMsg
	add	esp,010h

; 128   stRow.lCursorReadRow = stRow.lHeight;
	mov	eax,dword ptr  stRow+02fh
	mov	dword ptr  stRow+057h,eax

; 129   stRow.lCursorWriteRow = stRow.lCursorReadRow - stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRow+057h
	sub	eax,ecx
	mov	dword ptr  stRow+05bh,eax

; 130   lMarker = (stCell.cy / 2);
	movsx	eax,word ptr  stCell+02h
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	mov	[ebp-064h],eax;	lMarker

; 131   stRow.lLeadReadRow = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	dword ptr  stRow+07bh,eax

; 132   stRow.lLeadWriteRow = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	dword ptr  stRow+077h,eax

; 133   stRow.Pos.x = 0;
	mov	dword ptr  stRow+04fh,0h

; 134   lReadIndex = lWriteIndex;
	mov	eax,dword ptr  lWriteIndex
	mov	dword ptr  lReadIndex,eax

; 135   DosSetPriority(PRTYS_THREAD,PRTYC_FOREGROUNDSERVER,-4L,tidDisplayThread);
	push	dword ptr  tidDisplayThread
	push	0fffffffch
	push	04h
	push	02h
	call	DosSetPriority
	add	esp,010h

; 136   lCharacterCount = 50;
	mov	dword ptr [ebp-054h],032h;	lCharacterCount

; 137   lPacketCount = 0;
	mov	dword ptr [ebp-060h],0h;	lPacketCount

; 138   while (!bStopDisplayThread)
	cmp	dword ptr  bStopDisplayThread,0h
	jne	@BLBL1
	align 010h
@BLBL2:

; 139     {
; 140     DosWaitEventSem(hevDisplayWaitDataSem,-1);
	push	0ffffffffh
	push	dword ptr  hevDisplayWaitDataSem
	call	DosWaitEventSem
	add	esp,08h

; 141     if (bStopDisplayThread)
	cmp	dword ptr  bStopDisplayThread,0h
	jne	@BLBL1

; 142       break;
; 143     DosResetEventSem(hevDisplayWaitDataSem,&ulPostCount);
	lea	eax,[ebp-048h];	ulPostCount
	push	eax
	push	dword ptr  hevDisplayWaitDataSem
	call	DosResetEventSem
	add	esp,08h

; 144     wLastDirection = CS_READ;
	mov	word ptr [ebp-04ah],04000h;	wLastDirection

; 145 //  DosRequestMutexSem(hmtxRowGioBlockedSem,10000);
; 146     DosRequestMutexSem(hmtxRowGioBlockedSem,-1);
	push	0ffffffffh
	push	dword ptr  hmtxRowGioBlockedSem
	call	DosRequestMutexSem
	add	esp,08h

; 147     hps = WinGetPS(hwndClient);
	push	dword ptr  hwndClient
	call	WinGetPS
	add	esp,04h
	mov	[ebp-04h],eax;	hps

; 148     GpiCreateLogFont(hps,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wRowFont]);
	xor	eax,eax
	mov	ax,word ptr  stCFG+0d9h
	imul	eax,038h
	add	eax,offset FLAT:astFontAttributes
	push	eax
	push	02h
	push	offset FLAT:@STAT1
	push	dword ptr [ebp-04h];	hps
	call	GpiCreateLogFont
	add	esp,010h

; 149     GpiSetCharSet(hps,2);
	push	02h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetCharSet
	add	esp,08h

; 150     GpiSetBackMix(hps,BM_OVERPAINT);
	push	02h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackMix
	add	esp,08h

; 151     while ((lReadIndex != lWriteIndex) && !bStopDisplayThread)
	mov	eax,dword ptr  lWriteIndex
	cmp	dword ptr  lReadIndex,eax
	je	@BLBL7
	cmp	dword ptr  bStopDisplayThread,0h
	jne	@BLBL7
	align 010h
@BLBL8:

; 152       {
; 153       if (lPacketCount == 0)
	cmp	dword ptr [ebp-060h],0h;	lPacketCount
	jne	@BLBL9

; 154         {
; 155         if (--lCharacterCount == 0)
	mov	eax,[ebp-054h];	lCharacterCount
	dec	eax
	mov	[ebp-054h],eax;	lCharacterCount
	cmp	dword ptr [ebp-054h],0h;	lCharacterCount
	jne	@BLBL10

; 156           {
; 157           WinReleasePS(hps);
	push	dword ptr [ebp-04h];	hps
	call	WinReleasePS
	add	esp,04h

; 158           DosReleaseMutexSem(hmtxRowGioBlockedSem);
	push	dword ptr  hmtxRowGioBlockedSem
	call	DosReleaseMutexSem
	add	esp,04h

; 159           DosSleep(0);
	push	0h
	call	DosSleep
	add	esp,04h

; 160           DosRequestMutexSem(hmtxRowGioBlockedSem,-1);
	push	0ffffffffh
	push	dword ptr  hmtxRowGioBlockedSem
	call	DosRequestMutexSem
	add	esp,08h

; 161           if (bStopDisplayThread)
	cmp	dword ptr  bStopDisplayThread,0h
	jne	@BLBL7

; 162             break;
; 163           lCharacterCount = 50;
	mov	dword ptr [ebp-054h],032h;	lCharacterCount

; 164           hps = WinGetPS(hwndClient);
	push	dword ptr  hwndClient
	call	WinGetPS
	add	esp,04h
	mov	[ebp-04h],eax;	hps

; 165           GpiCreateLogFont(hps,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wRowFont]);
	xor	eax,eax
	mov	ax,word ptr  stCFG+0d9h
	imul	eax,038h
	add	eax,offset FLAT:astFontAttributes
	push	eax
	push	02h
	push	offset FLAT:@STAT2
	push	dword ptr [ebp-04h];	hps
	call	GpiCreateLogFont
	add	esp,010h

; 166           GpiSetCharSet(hps,2);
	push	02h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetCharSet
	add	esp,08h

; 167           GpiSetBackMix(hps,BM_OVERPAINT);
	push	02h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackMix
	add	esp,08h

; 168           }
@BLBL10:

; 169         if (lReadIndex >= stCFG.lBufferLength)
	mov	eax,dword ptr  stCFG+0d5h
	cmp	dword ptr  lReadIndex,eax
	jl	@BLBL13

; 170           lReadIndex = 0;
	mov	dword ptr  lReadIndex,0h
@BLBL13:

; 171         wChar = pwCaptureBuffer[lReadIndex++];
	mov	eax,dword ptr  pwCaptureBuffer
	mov	ecx,dword ptr  lReadIndex
	mov	ax,word ptr [eax+ecx*02h]
	mov	[ebp-042h],ax;	wChar
	mov	eax,dword ptr  lReadIndex
	inc	eax
	mov	dword ptr  lReadIndex,eax

; 172         wDirection = (wChar & 0xff00);
	mov	ax,[ebp-042h];	wChar
	and	ax,0ff00h
	mov	[ebp-044h],ax;	wDirection

; 173 #ifdef this_junk
; 174         if (stCFG.bCompressDisplay && (wLastDirection == CS_WRITE) && (wDirection == CS_READ))
; 175           stRow.Pos.x -= stCell.cx;
; 176 #endif
; 177         if (wDirection != CS_READ_BUFF_OVERFLOW)
	cmp	word ptr [ebp-044h],04500h;	wDirection
	je	@BLBL14

; 178           bLastWasOverflow = FALSE;
	mov	dword ptr [ebp-05ch],0h;	bLastWasOverflow
@BLBL14:

; 179         if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL15

; 180           {
; 181           rclBlankerRect.xLeft = stRow.Pos.x;
	mov	eax,dword ptr  stRow+04fh
	mov	[ebp-024h],eax;	rclBlankerRect

; 182           rclBlankerRect.xRight = (stRow.Pos.x + stCell.cx);
	movsx	eax,word ptr  stCell
	add	eax,dword ptr  stRow+04fh
	mov	[ebp-01ch],eax;	rclBlankerRect

; 183           }
@BLBL15:

; 184         switch (wDirection)
	xor	eax,eax
	mov	ax,[ebp-044h];	wDirection
	jmp	@BLBL137
	align 04h
@BLBL138:

; 185           {
; 186           case CS_PACKET_DATA:
; 187             lPacketCount = (wChar & 0xff);
	xor	eax,eax
	mov	ax,[ebp-042h];	wChar
	and	eax,0ffh
	mov	[ebp-060h],eax;	lPacketCount

; 188             bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter

; 189             break;
	jmp	@BLBL136
	align 04h
@BLBL139:

; 190           case CS_READ:
; 191             if (stCFG.bDispRead)
	test	byte ptr  stCFG+01bh,040h
	je	@BLBL16

; 192               {
; 193               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL17

; 194                 {
; 195                 rclBlankerRect.yBottom = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-020h],eax;	rclBlankerRect

; 196                 rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+05bh
	mov	[ebp-018h],eax;	rclBlankerRect

; 197                 WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 198                 }
@BLBL17:

; 199               stPos.y = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-038h],eax;	stPos

; 200               GpiSetBackColor(hps,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 201               GpiSetColor(hps,stCFG.lReadForegrndColor);
	push	dword ptr  stCFG+0a9h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 202               }
	jmp	@BLBL18
	align 010h
@BLBL16:

; 203             else
; 204               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL18:

; 205             break;
	jmp	@BLBL136
	align 04h
@BLBL140:

; 206           case CS_WRITE:
; 207             if (stCFG.bDispWrite)
	test	byte ptr  stCFG+01bh,020h
	je	@BLBL19

; 208               {
; 209               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL20

; 210                 {
; 211                 rclBlankerRect.yBottom = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-020h],eax;	rclBlankerRect

; 212                 rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+057h
	mov	[ebp-018h],eax;	rclBlankerRect

; 213                 WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 214                 }
@BLBL20:

; 215               stPos.y = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-038h],eax;	stPos

; 216               GpiSetBackColor(hps,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 217               GpiSetColor(hps,stCFG.lWriteForegrndColor);
	push	dword ptr  stCFG+0b1h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 218               }
	jmp	@BLBL21
	align 010h
@BLBL19:

; 219             else
; 220               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL21:

; 221             break;
	jmp	@BLBL136
	align 04h
@BLBL141:

; 222           case CS_WRITE_IMM:
; 223             if (stCFG.bDispIMM)
	test	byte ptr  stCFG+01bh,080h
	je	@BLBL22

; 224               {
; 225               wDirection = CS_WRITE;
	mov	word ptr [ebp-044h],08000h;	wDirection

; 226               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL23

; 227                 {
; 228                 rclBlankerRect.yBottom = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-020h],eax;	rclBlankerRect

; 229                 rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+057h
	mov	[ebp-018h],eax;	rclBlankerRect

; 230                 WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 231                 }
@BLBL23:

; 232               stPos.y = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-038h],eax;	stPos

; 233               if (stCFG.bHiLightImmediateByte)
	test	byte ptr  stCFG+018h,08h
	je	@BLBL24

; 234                 {
; 235                 GpiSetBackColor(hps,stCFG.lWriteForegrndColor);
	push	dword ptr  stCFG+0b1h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 236                 GpiSetColor(hps,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 237                 }
	jmp	@BLBL26
	align 010h
@BLBL24:

; 238               else
; 239                 {
; 240                 GpiSetBackColor(hps,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 241                 GpiSetColor(hps,stCFG.lWriteForegrndColor);
	push	dword ptr  stCFG+0b1h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 242                 }

; 243               }
	jmp	@BLBL26
	align 010h
@BLBL22:

; 244             else
; 245               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL26:

; 246             break;
	jmp	@BLBL136
	align 04h
@BLBL142:

; 247           case CS_READ_IMM:
; 248             if (stCFG.bDispIMM)
	test	byte ptr  stCFG+01bh,080h
	je	@BLBL27

; 249               {
; 250               wDirection = CS_READ;
	mov	word ptr [ebp-044h],04000h;	wDirection

; 251               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL28

; 252                 {
; 253                 rclBlankerRect.yBottom = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-020h],eax;	rclBlankerRect

; 254                 rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+05bh
	mov	[ebp-018h],eax;	rclBlankerRect

; 255                 WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 256                 }
@BLBL28:

; 257               stPos.y = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-038h],eax;	stPos

; 258               if (stCFG.bHiLightImmediateByte)
	test	byte ptr  stCFG+018h,08h
	je	@BLBL29

; 259                 {
; 260                 GpiSetBackColor(hps,stCFG.lReadForegrndColor);
	push	dword ptr  stCFG+0a9h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 261                 GpiSetColor(hps,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 262                 }
	jmp	@BLBL31
	align 010h
@BLBL29:

; 263               else
; 264                 {
; 265                 GpiSetBackColor(hps,stCFG.lReadBackgrndCol
; 265 or);
	push	dword ptr  stCFG+0a5h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 266                 GpiSetColor(hps,stCFG.lReadForegrndColor);
	push	dword ptr  stCFG+0a9h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 267                 }

; 268               }
	jmp	@BLBL31
	align 010h
@BLBL27:

; 269             else
; 270               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL31:

; 271             break;
	jmp	@BLBL136
	align 04h
@BLBL143:

; 272           case CS_MODEM_IN:
; 273             if (stCFG.bDispModemIn)
	test	byte ptr  stCFG+01ch,01h
	je	@BLBL32

; 274               {
; 275               bDisplaySignal = TRUE;
	mov	dword ptr [ebp-058h],01h;	bDisplaySignal

; 276               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL33

; 277                 {
; 278                 rclBlankerRect.yBottom = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-020h],eax;	rclBlankerRect

; 279                 rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+05bh
	mov	[ebp-018h],eax;	rclBlankerRect

; 280                 WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 281                 }
@BLBL33:

; 282               stPos.y = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-038h],eax;	stPos

; 283               GpiSetBackColor(hps,stCFG.lModemInBackgrndColor);
	push	dword ptr  stCFG+075h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 284               GpiSetColor(hps,stCFG.lModemInForegrndColor);
	push	dword ptr  stCFG+079h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 285               if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL37

; 286                 {
; 287                 wChar &= 0xf0;
	mov	ax,[ebp-042h];	wChar
	and	ax,0f0h
	mov	[ebp-042h],ax;	wChar

; 288                 wChar >>= 4;
	mov	ax,[ebp-042h];	wChar
	shr	ax,04h
	mov	[ebp-042h],ax;	wChar

; 289                 if (wChar < 10)
	mov	ax,[ebp-042h];	wChar
	cmp	ax,0ah
	jae	@BLBL35

; 290                   wChar += '0';
	mov	ax,[ebp-042h];	wChar
	add	ax,030h
	mov	[ebp-042h],ax;	wChar
	jmp	@BLBL37
	align 010h
@BLBL35:

; 291                 else
; 292                   wChar += ('A' - 10);
	mov	ax,[ebp-042h];	wChar
	add	ax,037h
	mov	[ebp-042h],ax;	wChar

; 293                 }

; 294               }
	jmp	@BLBL37
	align 010h
@BLBL32:

; 295             else
; 296               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL37:

; 297             break;
	jmp	@BLBL136
	align 04h
@BLBL144:

; 298           case CS_MODEM_OUT:
; 299             if (stCFG.bDispModemOut)
	test	byte ptr  stCFG+01ch,02h
	je	@BLBL38

; 300               {
; 301               bDisplaySignal = TRUE;
	mov	dword ptr [ebp-058h],01h;	bDisplaySignal

; 302               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL39

; 303                 {
; 304                 rclBlankerRect.yBottom = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-020h],eax;	rclBlankerRect

; 305                 rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+057h
	mov	[ebp-018h],eax;	rclBlankerRect

; 306                 WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 307                 }
@BLBL39:

; 308               stPos.y = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-038h],eax;	stPos

; 309               GpiSetBackColor(hps,stCFG.lModemOutBackgrndColor);
	push	dword ptr  stCFG+06dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 310               GpiSetColor(hps,stCFG.lModemOutForegrndColor);
	push	dword ptr  stCFG+071h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 311               wChar &= 0x03;
	mov	ax,[ebp-042h];	wChar
	and	ax,03h
	mov	[ebp-042h],ax;	wChar

; 312               if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL41

; 313                 wChar += '0';
	mov	ax,[ebp-042h];	wChar
	add	ax,030h
	mov	[ebp-042h],ax;	wChar

; 314               }
	jmp	@BLBL41
	align 010h
@BLBL38:

; 315             else
; 316               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL41:

; 317             break;
	jmp	@BLBL136
	align 04h
@BLBL145:

; 318           case CS_DEVIOCTL:
; 319             if (stCFG.bDispDevIOctl)
	test	byte ptr  stCFG+01ch,020h
	je	@BLBL42

; 320               {
; 321               bDisplaySignal = TRUE;
	mov	dword ptr [ebp-058h],01h;	bDisplaySignal

; 322               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL43

; 323                 {
; 324                 rclBlankerRect.yBottom = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-020h],eax;	rclBlankerRect

; 325                 rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+057h
	mov	[ebp-018h],eax;	rclBlankerRect

; 326                 WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 327                 }
@BLBL43:

; 328               stPos.y = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-038h],eax;	stPos

; 329               GpiSetBackColor(hps,stCFG.lDevIOctlBackgrndColor);
	push	dword ptr  stCFG+09dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 330               GpiSetColor(hps,stCFG.lDevIOctlForegrndColor);
	push	dword ptr  stCFG+0a1h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 331               if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL45

; 332                 wChar = 'F';
	mov	word ptr [ebp-042h],046h;	wChar

; 333               }
	jmp	@BLBL45
	align 010h
@BLBL42:

; 334             else
; 335               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL45:

; 336             break;
	jmp	@BLBL136
	align 04h
@BLBL146:

; 337           case CS_READ_BUFF_OVERFLOW:
; 338             if (stCFG.bDispErrors)
	test	byte ptr  stCFG+01ch,040h
	je	@BLBL46

; 339               {
; 340               if (!bLastWasOverflow)
	cmp	dword ptr [ebp-05ch],0h;	bLastWasOverflow
	jne	@BLBL47

; 341                 {
; 342                 bLastWasOverflow = TRUE;
	mov	dword ptr [ebp-05ch],01h;	bLastWasOverflow

; 343                 bDisplaySignal = TRUE;
	mov	dword ptr [ebp-058h],01h;	bDisplaySignal

; 344                 if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL48

; 345                   {
; 346                   rclBlankerRect.yBottom = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-020h],eax;	rclBlankerRect

; 347                   rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+05bh
	mov	[ebp-018h],eax;	rclBlankerRect

; 348                   WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 349                   }
@BLBL48:

; 350                 stPos.y = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-038h],eax;	stPos

; 351                 GpiSetBackColor(hps,stCFG.lErrorBackgrndColor);
	push	dword ptr  stCFG+085h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 352                 GpiSetColor(hps,stCFG.lErrorForegrndColor);
	push	dword ptr  stCFG+089h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 353                 if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL49

; 354                   wChar = 'V';
	mov	word ptr [ebp-042h],056h;	wChar
	jmp	@BLBL52
	align 010h
@BLBL49:

; 355                 else
; 356                   wChar = 0xff;
	mov	word ptr [ebp-042h],0ffh;	wChar

; 357                 }
	jmp	@BLBL52
	align 010h
@BLBL47:

; 358               else
; 359                 bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter

; 360               }
	jmp	@BLBL52
	align 010h
@BLBL46:

; 361             else
; 362               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL52:

; 363             break;
	jmp	@BLBL136
	align 04h
@BLBL147:

; 364           case CS_HDW_ERROR:
; 365             if (stCFG.bDispErrors)
	test	byte ptr  stCFG+01ch,040h
	je	@BLBL53

; 366               {
; 367               bDisplaySignal = TRUE;
	mov	dword ptr [ebp-058h],01h;	bDisplaySignal

; 368               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL54

; 369                 {
; 370                 rclBlankerRect.yBottom = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-020h],eax;	rclBlankerRect

; 371                 rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+05bh
	mov	[ebp-018h],eax;	rclBlankerRect

; 372                 WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 373                 }
@BLBL54:

; 374               stPos.y = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-038h],eax;	stPos

; 375               GpiSetBackColor(hps,stCFG.lErrorBackgrndColor);
	push	dword ptr  stCFG+085h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 376               GpiSetColor(hps,stCFG.lErrorForegrndColor);
	push	dword ptr  stCFG+089h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 377               if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL55

; 378                 wChar = 'E';
	mov	word ptr [ebp-042h],045h;	wChar
	jmp	@BLBL57
	align 010h
@BLBL55:

; 379               else
; 380                 wChar &= 0x1e;
	mov	ax,[ebp-042h];	wChar
	and	ax,01eh
	mov	[ebp-042h],ax;	wChar

; 381               }
	jmp	@BLBL57
	align 010h
@BLBL53:

; 382             else
; 383               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL57:

; 384             break;
	jmp	@BLBL136
	align 04h
@BLBL148:

; 385           case CS_BREAK_RX:
; 386             if (stCFG.bDispErrors)
	test	byte ptr  stCFG+01ch,040h
	je	@BLBL58

; 387               {
; 388               bDisplaySignal = TRUE;
	mov	dword ptr [ebp-058h],01h;	bDisplaySignal

; 389               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL59

; 390                 {
; 391                 rclBlankerRect.yBottom = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-020h],eax;	rclBlankerRect

; 392                 rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+05bh
	mov	[ebp-018h],eax;	rclBlankerRect

; 393                 WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 394                 }
@BLBL59:

; 395               stPos.y = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-038h],eax;	stPos

; 396               GpiSetBackColor(hps,stCFG.lErrorBackgrndColor);
	push	dword ptr  stCFG+085h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 397               GpiSetColor(hps,stCFG.lErrorForegrndColor);
	push	dword ptr  stCFG+089h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 398               if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL60

; 399                 wChar = 'B';
	mov	word ptr [ebp-042h],042h;	wChar
	jmp	@BLBL62
	align 010h
@BLBL60:

; 400               else
; 401                 wChar = 0xBB;
	mov	word ptr [ebp-042h],0bbh;	wChar

; 402               }
	jmp	@BLBL62
	align 010h
@BLBL58:

; 403             else
; 404               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL62:

; 405             break;
	jmp	@BLBL136
	align 04h
@BLBL149:

; 406           case CS_BREAK_TX:
; 407             if (stCFG.bDispModemOut)
	test	byte ptr  stCFG+01ch,02h
	je	@BLBL63

; 408               {
; 409               bDisplaySignal = TRUE;
	mov	dword ptr [ebp-058h],01h;	bDisplaySignal

; 410               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL64

; 411                 {
; 412                 rclBlankerRect.yBottom = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-020h],eax;	rclBlankerRect

; 413                 rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+057h
	mov	[ebp-018h],eax;	rclBlankerRect

; 414                 WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 415                 }
@BLBL64:

; 416               stPos.y = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-038h],eax;	stPos

; 417               GpiSetBackColor(hps,stCFG.lModemOutBackgrndColor);
	push	dword ptr  stCFG+06dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 418               GpiSetColor(hps,stCFG.lModemOutForegrndColor);
	push	dword ptr  stCFG+071h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 419               if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL65

; 420                 if (wChar & LINE_CTL_SEND_BREAK)
	test	byte ptr [ebp-042h],040h;	wChar
	je	@BLBL66

; 421                   wChar = 'B';
	mov	word ptr [ebp-042h],042h;	wChar
	jmp	@BLBL71
	align 010h
@BLBL66:

; 422                 else
; 423                   wChar = 'b';
	mov	word ptr [ebp-042h],062h;	wChar
	jmp	@BLBL71
	align 010h
@BLBL65:

; 424               else
; 425                 if (wChar & LINE_CTL_SEND_BREAK)
	test	byte ptr [ebp-042h],040h;	wChar
	je	@BLBL69

; 426                   wChar = 0xB1;
	mov	word ptr [ebp-042h],0b1h;	wChar
	jmp	@BLBL71
	align 010h
@BLBL69:

; 427                 else
; 428                   wChar = 0xB0;
	mov	word ptr [ebp-042h],0b0h;	wChar

; 429               }
	jmp	@BLBL71
	align 010h
@BLBL63:

; 430             else
; 431               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL71:

; 432             break;
	jmp	@BLBL136
	align 04h
@BLBL150:

; 433           case CS_WRITE_REQ:
; 434             if (stCFG.bDispWriteReq)
	test	byte ptr  stCFG+01ch,08h
	je	@BLBL72

; 435               {
; 436               bDisplaySignal = TRUE;
	mov	dword ptr [ebp-058h],01h;	bDisplaySignal

; 437               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL73

; 438                 {
; 439                 rclBlankerRect.yBottom = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-020h],eax;	rclBlankerRect

; 440                 rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+057h
	mov	[ebp-018h],eax;	rclBlankerRect

; 441                 WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 442                 }
@BLBL73:

; 443               stPos.y = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-038h],eax;	stPos

; 444               GpiSetBackColor(hps,stCFG.lWriteReqBackgrndColor);
	push	dword ptr  stCFG+095h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 445               GpiSetColor(hps,stCFG.lWriteReqForegrndColor);
	push	dword ptr  stCFG+099h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 446               if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL74

; 447                 wChar = 'W';
	mov	word ptr [ebp-042h],057h;	wChar
	jmp	@BLBL77
	align 010h
@BLBL74:

; 448               else
; 449                 if ((wChar & 0xff) == 0)
	test	byte ptr [ebp-042h],0ffh;	wChar
	jne	@BLBL77

; 450                   wChar = 0xD0;
	mov	word ptr [ebp-042h],0d0h;	wChar

; 451               }
	jmp	@BLBL77
	align 010h
@BLBL72:

; 452             else
; 453               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL77:

; 454             break;
	jmp	@BLBL136
	align 04h
@BLBL151:

; 455           case CS_WRITE_CMPLT:
; 456             if (stCFG.bDispWriteReq)
	test	byte ptr  stCFG+01ch,08h
	je	@BLBL78

; 457               {
; 458               bDisplaySignal = TRUE;
	mov	dword ptr [ebp-058h],01h;	bDisplaySignal

; 459               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL79

; 460                 {
; 461                 rclBlankerRect.yBottom = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-020h],eax;	rclBlankerRect

; 462                 rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+057h
	mov	[ebp-018h],eax;	rclBlankerRect

; 463                 WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 464                 }
@BLBL79:

; 465               stPos.y = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-038h],eax;	stPos

; 466               GpiSetBackColor(hps,stCFG.lWriteReqBackgrndColor);
	push	dword ptr  stCFG+095h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 467               GpiSetColor(hps,stCFG.lWriteReqForegrndColor);
	push	dword ptr  stCFG+099h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 468               if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL80

; 469                 wChar = 'w';
	mov	word ptr [ebp-042h],077h;	wChar
	jmp	@BLBL83
	align 010h
@BLBL80:

; 470               else
; 471                 if ((wChar & 0xff) == 0)
	test	byte ptr [ebp-042h],0ffh;	wChar
	jne	@BLBL83

; 472                   wChar = 0xD1;
	mov	word ptr [ebp-042h],0d1h;	wChar

; 473               }
	jmp	@BLBL83
	align 010h
@BLBL78:

; 474             else
; 475               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL83:

; 476             break;
	jmp	@BLBL136
	align 04h
@BLBL152:

; 477           case CS_READ_REQ:
; 478             if (stCFG.bDispReadReq)
	test	byte ptr  stCFG+01ch,010h
	je	@BLBL84

; 479               {
; 480               bDisplaySignal = TRU
; 480 E;
	mov	dword ptr [ebp-058h],01h;	bDisplaySignal

; 481               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL85

; 482                 {
; 483                 rclBlankerRect.yBottom = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-020h],eax;	rclBlankerRect

; 484                 rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+05bh
	mov	[ebp-018h],eax;	rclBlankerRect

; 485                 WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 486                 }
@BLBL85:

; 487               stPos.y = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-038h],eax;	stPos

; 488               GpiSetBackColor(hps,stCFG.lReadReqBackgrndColor);
	push	dword ptr  stCFG+08dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 489               GpiSetColor(hps,stCFG.lReadReqForegrndColor);
	push	dword ptr  stCFG+091h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 490               if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL86

; 491                 wChar = 'R';
	mov	word ptr [ebp-042h],052h;	wChar
	jmp	@BLBL89
	align 010h
@BLBL86:

; 492               else
; 493                 if ((wChar & 0xff) == 0)
	test	byte ptr [ebp-042h],0ffh;	wChar
	jne	@BLBL89

; 494                   wChar = 0xA0;
	mov	word ptr [ebp-042h],0a0h;	wChar

; 495               }
	jmp	@BLBL89
	align 010h
@BLBL84:

; 496             else
; 497               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL89:

; 498             break;
	jmp	@BLBL136
	align 04h
@BLBL153:

; 499           case CS_READ_CMPLT:
; 500             if (stCFG.bDispReadReq)
	test	byte ptr  stCFG+01ch,010h
	je	@BLBL90

; 501               {
; 502               bDisplaySignal = TRUE;
	mov	dword ptr [ebp-058h],01h;	bDisplaySignal

; 503               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL91

; 504                 {
; 505                 rclBlankerRect.yBottom = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-020h],eax;	rclBlankerRect

; 506                 rclBlankerRect.yTop = stRow.lCursorWriteRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+05bh
	mov	[ebp-018h],eax;	rclBlankerRect

; 507                 WinFillRect(hps,&rclBlankerRect,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 508                 }
@BLBL91:

; 509               stPos.y = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-038h],eax;	stPos

; 510               GpiSetBackColor(hps,stCFG.lReadReqBackgrndColor);
	push	dword ptr  stCFG+08dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 511               GpiSetColor(hps,stCFG.lReadReqForegrndColor);
	push	dword ptr  stCFG+091h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 512               if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL92

; 513                 wChar = 'r';
	mov	word ptr [ebp-042h],072h;	wChar
	jmp	@BLBL95
	align 010h
@BLBL92:

; 514               else
; 515                 if ((wChar & 0xff) == 0)
	test	byte ptr [ebp-042h],0ffh;	wChar
	jne	@BLBL95

; 516                   wChar = 0xA1;
	mov	word ptr [ebp-042h],0a1h;	wChar

; 517               }
	jmp	@BLBL95
	align 010h
@BLBL90:

; 518             else
; 519               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL95:

; 520             break;
	jmp	@BLBL136
	align 04h
@BLBL154:

; 521           case CS_OPEN_ONE:
; 522             if (stCFG.bDispOpen)
	test	byte ptr  stCFG+01ch,04h
	je	@BLBL96

; 523               {
; 524               bDisplaySignal = TRUE;
	mov	dword ptr [ebp-058h],01h;	bDisplaySignal

; 525               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL97

; 526                 {
; 527                 rclBlankerRect.yBottom = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-020h],eax;	rclBlankerRect

; 528                 rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+057h
	mov	[ebp-018h],eax;	rclBlankerRect

; 529                 WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 530                 }
@BLBL97:

; 531               stPos.y = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-038h],eax;	stPos

; 532               GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
	push	dword ptr  stCFG+07dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 533               GpiSetColor(hps,stCFG.lOpenForegrndColor);
	push	dword ptr  stCFG+081h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 534               if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL98

; 535                 wChar = 'O';
	mov	word ptr [ebp-042h],04fh;	wChar
	jmp	@BLBL100
	align 010h
@BLBL98:

; 536               else
; 537                 wChar = 0x00;
	mov	word ptr [ebp-042h],0h;	wChar

; 538               }
	jmp	@BLBL100
	align 010h
@BLBL96:

; 539             else
; 540               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL100:

; 541             break;
	jmp	@BLBL136
	align 04h
@BLBL155:

; 542           case CS_OPEN_TWO:
; 543             if (stCFG.bDispOpen)
	test	byte ptr  stCFG+01ch,04h
	je	@BLBL101

; 544               {
; 545               bDisplaySignal = TRUE;
	mov	dword ptr [ebp-058h],01h;	bDisplaySignal

; 546               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL102

; 547                 {
; 548                 rclBlankerRect.yBottom = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-020h],eax;	rclBlankerRect

; 549                 rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+057h
	mov	[ebp-018h],eax;	rclBlankerRect

; 550                 WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 551                 }
@BLBL102:

; 552               stPos.y = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-038h],eax;	stPos

; 553               GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
	push	dword ptr  stCFG+07dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 554               GpiSetColor(hps,stCFG.lOpenForegrndColor);
	push	dword ptr  stCFG+081h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 555               if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL103

; 556                 wChar = 'o';
	mov	word ptr [ebp-042h],06fh;	wChar
	jmp	@BLBL105
	align 010h
@BLBL103:

; 557               else
; 558                 wChar = 0x01;
	mov	word ptr [ebp-042h],01h;	wChar

; 559               }
	jmp	@BLBL105
	align 010h
@BLBL101:

; 560             else
; 561               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL105:

; 562             break;
	jmp	@BLBL136
	align 04h
@BLBL156:

; 563           case CS_CLOSE_ONE:
; 564             if (stCFG.bDispOpen)
	test	byte ptr  stCFG+01ch,04h
	je	@BLBL106

; 565               {
; 566               bDisplaySignal = TRUE;
	mov	dword ptr [ebp-058h],01h;	bDisplaySignal

; 567               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL107

; 568                 {
; 569                 rclBlankerRect.yBottom = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-020h],eax;	rclBlankerRect

; 570                 rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+057h
	mov	[ebp-018h],eax;	rclBlankerRect

; 571                 WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 572                 }
@BLBL107:

; 573               stPos.y = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-038h],eax;	stPos

; 574               GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
	push	dword ptr  stCFG+07dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 575               GpiSetColor(hps,stCFG.lOpenForegrndColor);
	push	dword ptr  stCFG+081h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 576               if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL108

; 577                 wChar = 'C';
	mov	word ptr [ebp-042h],043h;	wChar
	jmp	@BLBL110
	align 010h
@BLBL108:

; 578               else
; 579                 wChar = 0xc0;
	mov	word ptr [ebp-042h],0c0h;	wChar

; 580               }
	jmp	@BLBL110
	align 010h
@BLBL106:

; 581             else
; 582               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL110:

; 583             break;
	jmp	@BLBL136
	align 04h
@BLBL157:

; 584           case CS_CLOSE_TWO:
; 585             if (stCFG.bDispOpen)
	test	byte ptr  stCFG+01ch,04h
	je	@BLBL111

; 586               {
; 587               bDisplaySignal = TRUE;
	mov	dword ptr [ebp-058h],01h;	bDisplaySignal

; 588               if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL112

; 589                 {
; 590                 rclBlankerRect.yBottom = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-020h],eax;	rclBlankerRect

; 591                 rclBlankerRect.yTop = stRow.lCursorReadRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+057h
	mov	[ebp-018h],eax;	rclBlankerRect

; 592                 WinFillRect(hps,&rclBlankerRect,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	lea	eax,[ebp-024h];	rclBlankerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 593                 }
@BLBL112:

; 594               stPos.y = stRow.lCursorWriteRow;
	mov	eax,dword ptr  stRow+05bh
	mov	[ebp-038h],eax;	stPos

; 595               GpiSetBackColor(hps,stCFG.lOpenBackgrndColor);
	push	dword ptr  stCFG+07dh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetBackColor
	add	esp,08h

; 596               GpiSetColor(hps,stCFG.lOpenForegrndColor);
	push	dword ptr  stCFG+081h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 597               if (stCFG.wRowFont & 0x01)
	test	byte ptr  stCFG+0d9h,01h
	je	@BLBL113

; 598                 wChar = 'c';
	mov	word ptr [ebp-042h],063h;	wChar
	jmp	@BLBL115
	align 010h
@BLBL113:

; 599               else
; 600                 wChar = 0x0c;
	mov	word ptr [ebp-042h],0ch;	wChar

; 601               }
	jmp	@BLBL115
	align 010h
@BLBL111:

; 602             else
; 603               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL115:

; 604             break;
	jmp	@BLBL136
	align 04h
@BLBL158:

; 605           default:
; 606             if (bDebuggingCOMscope)
	cmp	dword ptr  bDebuggingCOMscope,0h
	je	@BLBL116

; 607               {
; 608               wChar >>= 8;
	mov	ax,[ebp-042h];	wChar
	shr	ax,08h
	mov	[ebp-042h],ax;	wChar

; 609               GpiSetColor(hps,CLR_RED);
	push	02h
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 610               GpiSetColor(hps,CLR_WHITE);
	push	0fffffffeh
	push	dword ptr [ebp-04h];	hps
	call	GpiSetColor
	add	esp,08h

; 611               }
	jmp	@BLBL117
	align 010h
@BLBL116:

; 612             else
; 613               bDisplayCharacter = FALSE;
	mov	dword ptr [ebp-050h],0h;	bDisplayCharacter
@BLBL117:

; 614             break;
	jmp	@BLBL136
	align 04h
	jmp	@BLBL136
	align 04h
@BLBL137:
	cmp	eax,0ff00h
	je	@BLBL138
	cmp	eax,04000h
	je	@BLBL139
	cmp	eax,08000h
	je	@BLBL140
	cmp	eax,08100h
	je	@BLBL141
	cmp	eax,04100h
	je	@BLBL142
	cmp	eax,04400h
	je	@BLBL143
	cmp	eax,08400h
	je	@BLBL144
	cmp	eax,08500h
	je	@BLBL145
	cmp	eax,04500h
	je	@BLBL146
	cmp	eax,04600h
	je	@BLBL147
	cmp	eax,04700h
	je	@BLBL148
	cmp	eax,08a00h
	je	@BLBL149
	cmp	eax,08200h
	je	@BLBL150
	cmp	eax,08300h
	je	@BLBL151
	cmp	eax,04200h
	je	@BLBL152
	cmp	eax,04300h
	je	@BLBL153
	cmp	eax,08600h
	je	@BLBL154
	cmp	eax,08700h
	je	@BLBL155
	cmp	eax,08800h
	je	@BLBL156
	cmp	eax,08900h
	je	@BLBL157
	jmp	@BLBL158
	align 04h
@BLBL136:

; 615           }
; 616         if (bDisplayCharacter)
	cmp	dword ptr [ebp-050h],0h;	bDisplayCharacter
	je	@BLBL118

; 617           {
; 618           stPos.x = stRow.Pos.x;
	mov	eax,dword ptr  stRow+04fh
	mov	[ebp-03ch],eax;	stPos

; 619           GpiCharStringAt(hps,&stPos,1,(char *)&wChar);
	lea	eax,[ebp-042h];	wChar
	push	eax
	push	01h
	lea	eax,[ebp-03ch];	stPos
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	GpiCharStringAt
	add	esp,010h

; 620           if (stRow.Pos.x >= stRow.lWidth)
	mov	eax,dword ptr  stRow+033h
	cmp	dword ptr  stRow+04fh,eax
	jl	@BLBL119

; 621             {
; 622 #ifdef this_junk
; 623             if (!bDisplaySignal && stCFG.bCompressDisplay && (lReadIndex < lWriteIndex))
; 624               {
; 625               if (wDirection != CS_READ)
; 626                 {
; 627                 wChar = pwCaptureBuffer[lReadIndex + 1];
; 628                 if (((wChar & 0xff00) == CS_READ) || ((wChar & 0xff00) == CS_READ_IMM))
; 629                   {
; 630                   if ((wChar & 0xff00) == CS_READ)
; 631                     {
; 632                     GpiSetColor(hps,stCFG.lReadForegrndColor);
; 633                     WinFillRect(hps,&rclRect,stCFG.lReadBackgrndColor);
; 634                     }
; 635                   else
; 636                     if (stCFG.bHiLightImmediateByte)
; 637                       {
; 638                       GpiSetColor(hps,stCFG.lWriteForegrndColor);
; 639                       WinFillRect(hps,&rclRect,stCFG.lWriteBackgrndColor);
; 640                       }
; 641                   pwCaptureBuffer[++lWriteIndex] = wChar;
; 642                   stPos.y = stRow.lCursorReadRow;
; 643                   GpiCharStringAt(hps,&stPos,1,(char *)&wChar);
; 644                   wDirection = CS_READ;
; 645                   lReadIndex++;
; 646                   }
; 647                 }
; 648               }
; 649             else
; 650 #endif
; 651               bDisplaySignal = FALSE;
	mov	dword ptr [ebp-058h],0h;	bDisplaySignal

; 652             if (bScreenWrapped)
	cmp	dword ptr [ebp-040h],0h;	bScreenWrapped
	je	@BLBL120

; 653               {
; 654               if (stRow.lLeadWriteRow < (stCell.cy * 2))
	movsx	eax,word ptr  stCell+02h
	add	eax,eax
	cmp	dword ptr  stRow+077h,eax
	jge	@BLBL121

; 655                 stRow.lLeadReadRow = stRow.lHeight;
	mov	eax,dword ptr  stRow+02fh
	mov	dword ptr  stRow+07bh,eax
	jmp	@BLBL122
	align 010h
@BLBL121:

; 656               else
; 657                 stRow.lLeadReadRow -= (stCell.cy * 2);
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRow+07bh
	sub	eax,ecx
	sub	eax,ecx
	mov	dword ptr  stRow+07bh,eax
@BLBL122:

; 658               stRow.lLeadWriteRow = stRow.lLeadReadRow - stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRow+07bh
	sub	eax,ecx
	mov	dword ptr  stRow+077h,eax

; 659               stRow.lLeadIndex += stRow.lCharWidth;
	mov	eax,dword ptr  stRow+027h
	add	eax,dword ptr  stRow+073h
	mov	dword ptr  stRow+073h,eax

; 660               if (stRow.lLeadIndex >= stCFG.lBufferLength)
	mov	eax,dword ptr  stCFG+0d5h
	cmp	dword ptr  stRow+073h,eax
	jl	@BLBL120

; 661                 stRow.lLeadIndex -= stCFG.lBufferLength;
	mov	eax,dword ptr  stRow+073h
	sub	eax,dword ptr  stCFG+0d5h
	mov	dword ptr  stRow+073h,eax

; 662               }
@BLBL120:

; 663             rclRect.xLeft = 0L;
	mov	dword ptr [ebp-014h],0h;	rclRect

; 664             rclRect.xRight = stRow.lWidth + stCell.cx;
	movsx	eax,word ptr  stCell
	add	eax,dword ptr  stRow+033h
	mov	[ebp-0ch],eax;	rclRect

; 665             rclMarkerRect.xLeft = 0L;
	mov	dword ptr [ebp-034h],0h;	rclMarkerRect

; 666             rclMarkerRect.xRight = stRow.lWidth + stCell.cx;
	movsx	eax,word ptr  stCell
	add	eax,dword ptr  stRow+033h
	mov	[ebp-02ch],eax;	rclMarkerRect

; 667             if (stRow.lCursorWriteRow < (stCell.cy * 2))
	movsx	eax,word ptr  stCell+02h
	add	eax,eax
	cmp	dword ptr  stRow+05bh,eax
	jge	@BLBL124

; 668               {
; 669               stRow.lCursorReadRow = stRow.lHeight;
	mov	eax,dword ptr  stRow+02fh
	mov	dword ptr  stRow+057h,eax

; 670               stRow.lCursorWriteRow = stRow.lCursorReadRow - stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRow+057h
	sub	eax,ecx
	mov	dword ptr  stRow+05bh,eax

; 671               rclRect.yBottom = stRow.lCursorReadRow;
	mov	eax,dword ptr  stRow+057h
	mov	[ebp-010h],eax;	rclRect

; 672               rclRect.yTop = stRow.lCursorReadRow + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRow+057h
	mov	[ebp-08h],eax;	rclRect

; 673               bScreenWrapped = TRUE;
	mov	dword ptr [ebp-040h],01h;	bScreenWrapped

; 674               stRow.lLeadReadRow = stRow.lHeight - (stCell.cy * 2);
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRow+02fh
	sub	eax,ecx
	sub	eax,ecx
	mov	dword ptr  stRow+07bh,eax

; 675               stRow.lLeadWriteRow = stRow.lLeadReadRow - stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRow+07bh
	sub	eax,ecx
	mov	dword ptr  stRow+077h,eax

; 676               stRow.lLeadIndex += stRow.lCharWidth;
	mov	eax,dword ptr  stRow+027h
	add	eax,dword ptr  stRow+073h
	mov	dword ptr  stRow+073h,eax

; 677               if (stRow.lLeadIndex >= stCFG.lBufferLength)
	mov	eax,dword ptr  stCFG+0d5h
	cmp	dword ptr  stRow+073h,eax
	jl	@BLBL126

; 678                 stRow.lLeadIndex -= stCFG.lBufferLength;
	mov	eax,dword ptr  stRow+073h
	sub	eax,dword ptr  stCFG+0d5h
	mov	dword ptr  stRow+073h,eax

; 679               }
	jmp	@BLBL126
	align 010h
@BLBL124:

; 680             else
; 681               {
; 682               rclRect.yBottom = stRow.lCursorWriteRow - stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRow+05bh
	sub	eax,ecx
	mov	[ebp-010h],eax;	rclRect

; 683               rclRect.yTop = rclRect.yBottom + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,[ebp-010h];	rclRect
	mov	[ebp-08h],eax;	rclRect

; 684               stRow.lCursorReadRow -= (stCell.cy * 2);
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRow+057h
	sub	eax,ecx
	sub	eax,ecx
	mov	dword ptr  stRow+057h,eax

; 685               stRow.lCursorWriteRow = stRow.lCursorReadRow - stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRow+057h
	sub	eax,ecx
	mov	dword ptr  stRow+05bh,eax

; 686               
; 686 }
@BLBL126:

; 687             WinFillRect(hps,&rclRect,stCFG.lReadBackgrndColor);
	push	dword ptr  stCFG+0a5h
	lea	eax,[ebp-014h];	rclRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 688             rclRect.yBottom -= stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,[ebp-010h];	rclRect
	sub	eax,ecx
	mov	[ebp-010h],eax;	rclRect

; 689             if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL127

; 690               {
; 691               rclMarkerRect.yTop = (rclRect.yTop - lMarker);
	mov	eax,[ebp-08h];	rclRect
	sub	eax,[ebp-064h];	lMarker
	mov	[ebp-028h],eax;	rclMarkerRect

; 692               rclMarkerRect.yBottom = (rclMarkerRect.yTop - 1);
	mov	eax,[ebp-028h];	rclMarkerRect
	dec	eax
	mov	[ebp-030h],eax;	rclMarkerRect

; 693               WinFillRect(hps,&rclMarkerRect,stCFG.lReadForegrndColor);
	push	dword ptr  stCFG+0a9h
	lea	eax,[ebp-034h];	rclMarkerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 694               }
@BLBL127:

; 695             if (rclRect.yBottom <= (lStatusHeight + 2))
	mov	eax,dword ptr  lStatusHeight
	add	eax,02h
	cmp	[ebp-010h],eax;	rclRect
	jg	@BLBL128

; 696               rclRect.yBottom -= 4;
	mov	eax,[ebp-010h];	rclRect
	sub	eax,04h
	mov	[ebp-010h],eax;	rclRect
@BLBL128:

; 697             rclRect.yTop -= stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,[ebp-08h];	rclRect
	sub	eax,ecx
	mov	[ebp-08h],eax;	rclRect

; 698             WinFillRect(hps,&rclRect,stCFG.lWriteBackgrndColor);
	push	dword ptr  stCFG+0adh
	lea	eax,[ebp-014h];	rclRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 699             if (stCFG.bMarkCurrentLine)
	test	byte ptr  stCFG+01eh,040h
	je	@BLBL129

; 700               {
; 701               rclMarkerRect.yTop = (rclRect.yTop - lMarker);
	mov	eax,[ebp-08h];	rclRect
	sub	eax,[ebp-064h];	lMarker
	mov	[ebp-028h],eax;	rclMarkerRect

; 702               rclMarkerRect.yBottom = (rclMarkerRect.yTop - 1);
	mov	eax,[ebp-028h];	rclMarkerRect
	dec	eax
	mov	[ebp-030h],eax;	rclMarkerRect

; 703               WinFillRect(hps,&rclMarkerRect,stCFG.lWriteForegrndColor);
	push	dword ptr  stCFG+0b1h
	lea	eax,[ebp-034h];	rclMarkerRect
	push	eax
	push	dword ptr [ebp-04h];	hps
	call	WinFillRect
	add	esp,0ch

; 704               }
@BLBL129:

; 705             stRow.Pos.x = 0;
	mov	dword ptr  stRow+04fh,0h

; 706             }
	jmp	@BLBL132
	align 010h
@BLBL119:

; 707           else
; 708             {
; 709             stRow.Pos.x += stCell.cx;
	movsx	eax,word ptr  stCell
	add	eax,dword ptr  stRow+04fh
	mov	dword ptr  stRow+04fh,eax

; 710             wLastDirection = wDirection;
	mov	ax,[ebp-044h];	wDirection
	mov	[ebp-04ah],ax;	wLastDirection

; 711             }

; 712           }
	jmp	@BLBL132
	align 010h
@BLBL118:

; 713         else
; 714           bDisplayCharacter = TRUE;
	mov	dword ptr [ebp-050h],01h;	bDisplayCharacter

; 715         }
	jmp	@BLBL132
	align 010h
@BLBL9:

; 716       else
; 717         {
; 718         lPacketCount--;
	mov	eax,[ebp-060h];	lPacketCount
	dec	eax
	mov	[ebp-060h],eax;	lPacketCount

; 719         if (lReadIndex++ >= stCFG.lBufferLength)
	mov	eax,dword ptr  stCFG+0d5h
	cmp	dword ptr  lReadIndex,eax
	jl	@BLBL133
	mov	eax,dword ptr  lReadIndex
	inc	eax
	mov	dword ptr  lReadIndex,eax

; 720           lReadIndex = 0;
	mov	dword ptr  lReadIndex,0h
	jmp	@BLBL132
	align 010h
@BLBL133:
	mov	eax,dword ptr  lReadIndex
	inc	eax
	mov	dword ptr  lReadIndex,eax

; 721         }
@BLBL132:

; 722       }

; 151     while ((lReadIndex != lWriteIndex) && !bStopDisplayThread)
	mov	eax,dword ptr  lWriteIndex
	cmp	dword ptr  lReadIndex,eax
	je	@BLBL7
	cmp	dword ptr  bStopDisplayThread,0h
	je	@BLBL8
@BLBL7:

; 723     WinReleasePS(hps);
	push	dword ptr [ebp-04h];	hps
	call	WinReleasePS
	add	esp,04h

; 724     DosReleaseMutexSem(hmtxRowGioBlockedSem);
	push	dword ptr  hmtxRowGioBlockedSem
	call	DosReleaseMutexSem
	add	esp,04h

; 725     }

; 138   while (!bStopDisplayThread)
	cmp	dword ptr  bStopDisplayThread,0h
	je	@BLBL2
@BLBL1:

; 727   DosPostEventSem(hevKillDisplayThreadSem);
	push	dword ptr  hevKillDisplayThreadSem
	call	DosPostEventSem
	add	esp,04h

; 729   }
	mov	esp,ebp
	pop	ebp
	ret	
RowDisplayThread	endp

; 732   {
	align 010h

	public ColumnDisplayThread
ColumnDisplayThread	proc
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

; 736   LONG lReadSyncLine = 0;
	mov	dword ptr [ebp-010h],0h;	lReadSyncLine

; 737   LONG lWriteSyncLine = 0;
	mov	dword ptr [ebp-014h],0h;	lWriteSyncLine

; 738   BOOL bReadSync = FALSE;
	mov	dword ptr [ebp-018h],0h;	bReadSync

; 739   LONG lOldTop;
; 740   BOOL bWriteSync = FALSE;
	mov	dword ptr [ebp-020h],0h;	bWriteSync

; 741   BOOL bLastWriteWasNewLine = FALSE;
	mov	dword ptr [ebp-024h],0h;	bLastWriteWasNewLine

; 742   BOOL bLastReadWasNewLine= FALSE;
	mov	dword ptr [ebp-028h],0h;	bLastReadWasNewLine

; 743   ULONG ulPostCount;
; 744   LONG lCharacterCount;
; 745   int iPacketCount;
; 746   WORD wFunc;
; 747 
; 748   WinPostMsg(hwndClient,UM_STARTDISPLAYTHREAD,0L,0L);
	push	0h
	push	0h
	push	08018h
	push	dword ptr  hwndClient
	call	WinPostMsg
	add	esp,010h

; 749   stRead.Pos.y = stRead.lHeight;
	mov	eax,dword ptr  stRead+02fh
	mov	dword ptr  stRead+053h,eax

; 750   stWrite.Pos.y = stWrite.lHeight;
	mov	eax,dword ptr  stWrite+02fh
	mov	dword ptr  stWrite+053h,eax

; 751   stRead.Pos.x = 0;
	mov	dword ptr  stRead+04fh,0h

; 752   stWrite.Pos.x = 0;
	mov	dword ptr  stWrite+04fh,0h

; 753   lReadIndex = lWriteIndex;
	mov	eax,dword ptr  lWriteIndex
	mov	dword ptr  lReadIndex,eax

; 754   DosSetPriority(PRTYS_THREAD,PRTYC_FOREGROUNDSERVER,-4L,tidDisplayThread);
	push	dword ptr  tidDisplayThread
	push	0fffffffch
	push	04h
	push	02h
	call	DosSetPriority
	add	esp,010h

; 755   stRead.rclDisp.xLeft = 0L;
	mov	dword ptr  stRead+03fh,0h

; 756   stWrite.rclDisp.xLeft = 0L;
	mov	dword ptr  stWrite+03fh,0h

; 757   lCharacterCount = 50;
	mov	dword ptr [ebp-030h],032h;	lCharacterCount

; 758   iPacketCount = 0;
	mov	dword ptr [ebp-034h],0h;	iPacketCount

; 759   while (!bStopDisplayThread)
	cmp	dword ptr  bStopDisplayThread,0h
	jne	@BLBL159
	align 010h
@BLBL160:

; 760     {
; 761     DosWaitEventSem(hevDisplayWaitDataSem,-1);
	push	0ffffffffh
	push	dword ptr  hevDisplayWaitDataSem
	call	DosWaitEventSem
	add	esp,08h

; 762       if (bStopDisplayThread)
	cmp	dword ptr  bStopDisplayThread,0h
	jne	@BLBL159

; 763         break;
; 764     DosResetEventSem(hevDisplayWaitDataSem,&ulPostCount);
	lea	eax,[ebp-02ch];	ulPostCount
	push	eax
	push	dword ptr  hevDisplayWaitDataSem
	call	DosResetEventSem
	add	esp,08h

; 765     DosRequestMutexSem(hmtxColGioBlockedSem,10000);
	push	02710h
	push	dword ptr  hmtxColGioBlockedSem
	call	DosRequestMutexSem
	add	esp,08h

; 766     hpsRead = WinGetPS(stRead.hwndClient);
	push	dword ptr  stRead+0fh
	call	WinGetPS
	add	esp,04h
	mov	[ebp-04h],eax;	hpsRead

; 767     GpiCreateLogFont(hpsRead,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wColReadFont]);
	xor	eax,eax
	mov	ax,word ptr  stCFG+0dbh
	imul	eax,038h
	add	eax,offset FLAT:astFontAttributes
	push	eax
	push	02h
	push	offset FLAT:@STAT3
	push	dword ptr [ebp-04h];	hpsRead
	call	GpiCreateLogFont
	add	esp,010h

; 768     GpiSetCharSet(hpsRead,2);
	push	02h
	push	dword ptr [ebp-04h];	hpsRead
	call	GpiSetCharSet
	add	esp,08h

; 769     GpiSetColor(hpsRead,stCFG.lReadColForegrndColor);
	push	dword ptr  stCFG+0c1h
	push	dword ptr [ebp-04h];	hpsRead
	call	GpiSetColor
	add	esp,08h

; 770     hpsWrite = WinGetPS(stWrite.hwndClient);
	push	dword ptr  stWrite+0fh
	call	WinGetPS
	add	esp,04h
	mov	[ebp-08h],eax;	hpsWrite

; 771     GpiCreateLogFont(hpsWrite,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wColWriteFont]);
	xor	eax,eax
	mov	ax,word ptr  stCFG+0ddh
	imul	eax,038h
	add	eax,offset FLAT:astFontAttributes
	push	eax
	push	02h
	push	offset FLAT:@STAT4
	push	dword ptr [ebp-08h];	hpsWrite
	call	GpiCreateLogFont
	add	esp,010h

; 772     GpiSetCharSet(hpsWrite,2);
	push	02h
	push	dword ptr [ebp-08h];	hpsWrite
	call	GpiSetCharSet
	add	esp,08h

; 773     GpiSetColor(hpsWrite,stCFG.lWriteColForegrndColor);
	push	dword ptr  stCFG+0c9h
	push	dword ptr [ebp-08h];	hpsWrite
	call	GpiSetColor
	add	esp,08h

; 774     while (lReadIndex != lWriteIndex && !bStopDisplayThread)
	mov	eax,dword ptr  lWriteIndex
	cmp	dword ptr  lReadIndex,eax
	je	@BLBL165
	cmp	dword ptr  bStopDisplayThread,0h
	jne	@BLBL165
	align 010h
@BLBL166:

; 775       {
; 776       if (iPacketCount == 0)
	cmp	dword ptr [ebp-034h],0h;	iPacketCount
	jne	@BLBL167

; 777         {
; 778         if (--lCharacterCount == 0)
	mov	eax,[ebp-030h];	lCharacterCount
	dec	eax
	mov	[ebp-030h],eax;	lCharacterCount
	cmp	dword ptr [ebp-030h],0h;	lCharacterCount
	jne	@BLBL168

; 779           {
; 780           WinReleasePS(hpsRead);
	push	dword ptr [ebp-04h];	hpsRead
	call	WinReleasePS
	add	esp,04h

; 781           WinReleasePS(hpsWrite);
	push	dword ptr [ebp-08h];	hpsWrite
	call	WinReleasePS
	add	esp,04h

; 782           DosReleaseMutexSem(hmtxColGioBlockedSem);
	push	dword ptr  hmtxColGioBlockedSem
	call	DosReleaseMutexSem
	add	esp,04h

; 783           DosSleep(0);
	push	0h
	call	DosSleep
	add	esp,04h

; 784           DosRequestMutexSem(hmtxColGioBlockedSem,-1);
	push	0ffffffffh
	push	dword ptr  hmtxColGioBlockedSem
	call	DosRequestMutexSem
	add	esp,08h

; 785           if (bStopDisplayThread)
	cmp	dword ptr  bStopDisplayThread,0h
	jne	@BLBL165

; 786             break;
; 787           lCharacterCount = 50;
	mov	dword ptr [ebp-030h],032h;	lCharacterCount

; 788           hpsRead = WinGetPS(stRead.hwndClient);
	push	dword ptr  stRead+0fh
	call	WinGetPS
	add	esp,04h
	mov	[ebp-04h],eax;	hpsRead

; 789           GpiCreateLogFont(hpsRead,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wColReadFont]);
	xor	eax,eax
	mov	ax,word ptr  stCFG+0dbh
	imul	eax,038h
	add	eax,offset FLAT:astFontAttributes
	push	eax
	push	02h
	push	offset FLAT:@STAT5
	push	dword ptr [ebp-04h];	hpsRead
	call	GpiCreateLogFont
	add	esp,010h

; 790           GpiSetCharSet(hpsRead,2);
	push	02h
	push	dword ptr [ebp-04h];	hpsRead
	call	GpiSetCharSet
	add	esp,08h

; 791           GpiSetColor(hpsRead,stCFG.lReadColForegrndColor);
	push	dword ptr  stCFG+0c1h
	push	dword ptr [ebp-04h];	hpsRead
	call	GpiSetColor
	add	esp,08h

; 792           hpsWrite = WinGetPS(stWrite.hwndClient);
	push	dword ptr  stWrite+0fh
	call	WinGetPS
	add	esp,04h
	mov	[ebp-08h],eax;	hpsWrite

; 793           GpiCreateLogFont(hpsWrite,(PSTR8)"HEXFONTS",2,&astFontAttributes[stCFG.wColWriteFont]);
	xor	eax,eax
	mov	ax,word ptr  stCFG+0ddh
	imul	eax,038h
	add	eax,offset FLAT:astFontAttributes
	push	eax
	push	02h
	push	offset FLAT:@STAT6
	push	dword ptr [ebp-08h];	hpsWrite
	call	GpiCreateLogFont
	add	esp,010h

; 794           GpiSetCharSet(hpsWrite,2);
	push	02h
	push	dword ptr [ebp-08h];	hpsWrite
	call	GpiSetCharSet
	add	esp,08h

; 795           GpiSetColor(hpsWrite,stCFG.lWriteColForegrndColor);
	push	dword ptr  stCFG+0c9h
	push	dword ptr [ebp-08h];	hpsWrite
	call	GpiSetColor
	add	esp,08h

; 796           }
@BLBL168:

; 797         if (lReadIndex >= stCFG.lBufferLength)
	mov	eax,dword ptr  stCFG+0d5h
	cmp	dword ptr  lReadIndex,eax
	jl	@BLBL171

; 798           lReadIndex = 0;
	mov	dword ptr  lReadIndex,0h
@BLBL171:

; 799         byChar = (BYTE)pwCaptureBuffer[lReadIndex];
	mov	eax,dword ptr  pwCaptureBuffer
	mov	ecx,dword ptr  lReadIndex
	mov	ax,word ptr [eax+ecx*02h]
	mov	[ebp-09h],al;	byChar

; 800         wFunc = (pwCaptureBuffer[lReadIndex++] & 0x0ff00);
	mov	eax,dword ptr  pwCaptureBuffer
	mov	ecx,dword ptr  lReadIndex
	mov	ax,word ptr [eax+ecx*02h]
	and	ax,0ff00h
	mov	[ebp-036h],ax;	wFunc
	mov	eax,dword ptr  lReadIndex
	inc	eax
	mov	dword ptr  lReadIndex,eax

; 801         switch (wFunc)
	xor	eax,eax
	mov	ax,[ebp-036h];	wFunc
	jmp	@BLBL213
	align 04h
@BLBL214:

; 802           {
; 803           case CS_PACKET_DATA:
; 804             iPacketCount = (int)byChar;
	xor	eax,eax
	mov	al,[ebp-09h];	byChar
	mov	[ebp-034h],eax;	iPacketCount

; 805             break;
	jmp	@BLBL212
	align 04h
@BLBL215:
@BLBL216:

; 806           case CS_READ_IMM:
; 807           case CS_READ:
; 808             if (stRead.bFilter)
	test	byte ptr  stRead+02h,020h
	je	@BLBL172

; 809               byChar &= stRead.byDisplayMask;
	mov	al,byte ptr  stRead+04h
	and	al,[ebp-09h];	byChar
	mov	[ebp-09h],al;	byChar
@BLBL172:

; 810             if (stRead.bTestNewLine && (byChar == stRead.byNewLineChar))
	test	byte ptr  stRead+02h,02h
	je	@BLBL173
	mov	al,byte ptr  stRead+03h
	cmp	[ebp-09h],al;	byChar
	jne	@BLBL173

; 811               {
; 812               if (stRead.bSkipBlankLines && bLastReadWasNewLine)
	test	byte ptr  stRead+02h,04h
	je	@BLBL174
	cmp	dword ptr [ebp-028h],0h;	bLastReadWasNewLine
	je	@BLBL174

; 813                 break;
	jmp	@BLBL212
	align 04h
@BLBL174:

; 814               bLastReadWasNewLine = TRUE;
	mov	dword ptr [ebp-028h],01h;	bLastReadWasNewLine

; 815               if (CharPrintable(&byChar,&stRead))
	push	offset FLAT:stRead
	lea	eax,[ebp-09h];	byChar
	push	eax
	call	CharPrintable
	add	esp,08h
	test	eax,eax
	je	@BLBL175

; 816                 if (stRead.bWrap || (stRead.Pos.x <= stRead.lWidth))
	test	byte ptr  stRead+02h,08h
	jne	@BLBL176
	mov	eax,dword ptr  stRead+033h
	cmp	dword ptr  stRead+04fh,eax
	jg	@BLBL175
@BLBL176:

; 817                   GpiCharStringAt(hpsRead,&stRead.Pos,1,&byChar);
	lea	eax,[ebp-09h];	byChar
	push	eax
	push	01h
	push	offset FLAT:stRead+04fh
	push	dword ptr [ebp-04h];	hpsRead
	call	GpiCharStringAt
	add	esp,010h
@BLBL175:

; 818               stRead.Pos.x = 0;
	mov	dword ptr  stRead+04fh,0h

; 819               if (stRead.Pos.y <= 0)
	cmp	dword ptr  stRead+053h,0h
	jg	@BLBL178

; 820                 {
; 821                 stRead.Pos.y = stRead.lHeight;
	mov	eax,dword ptr  stRead+02fh
	mov	dword ptr  stRead+053h,eax

; 822                 stRead.rclDisp.yBottom = stRead.lHeight;
	mov	eax,dword ptr  stRead+02fh
	mov	dword ptr  stRead+043h,eax

; 823                 stRead.rclDisp.yTop = stRead.lHeight + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRead+02fh
	mov	dword ptr  stRead+04bh,eax

; 824                 }
	jmp	@BLBL179
	align 010h
@BLBL178:

; 825               else
; 826                 {
; 827                 stRead.rclDisp.yTop = stRead.Pos.y;
	mov	eax,dword ptr  stRead+053h
	mov	dword ptr  stRead+04bh,eax

; 828                 stRead.Pos.y -= stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRead+053h
	sub	eax,ecx
	mov	dword ptr  stRead+053h,eax

; 829                 stRead.rclDisp.yBottom = stRead.Pos.y;
	mov	eax,dword ptr  stRead+053h
	mov	dword ptr  stRead+043h,eax

; 830                 }
@BLBL179:

; 831               WinFillRect(hpsRead,&stRead.rclDisp,stRead.lBackgrndColor);
	push	dword ptr  stRead+037h
	push	offset FLAT:stRead+03fh
	push	dword ptr [ebp-04h];	hpsRead
	call	WinFillRect
	add	esp,0ch

; 832               if (stWrite.bSync)
	test	byte ptr  stWrite+02h,010h
	je	@BLBL181

; 833                 {
; 834                 bReadSync = TRUE;
	mov	dword ptr [ebp-018h],01h;	bReadSync

; 835                 lWriteSyncLine = stRead.Pos.y;
	mov	eax,dword ptr  stRead+053h
	mov	[ebp-014h],eax;	lWriteSyncLine

; 836                 }

; 837               }
	jmp	@BLBL181
	align 010h
@BLBL173:

; 838             else
; 839               {
; 840               bLastReadWasNewLine = FALSE;
	mov	dword ptr [ebp-028h],0h;	bLastReadWasNewLine

; 841               if (CharPrintable(&byChar,&stRead))
	push	offset FLAT:stRead
	lea	eax,[ebp-09h];	byChar
	push	eax
	call	CharPrintable
	add	esp,08h
	test	eax,eax
	je	@BLBL181

; 842                 {
; 843                 if (bWriteSync && (stRead.Pos.x == 0))
	cmp	dword ptr [ebp-020h],0h;	bWriteSync
	je	@BLBL183
	cmp	dword ptr  stRead+04fh,0h
	jne	@BLBL183

; 844                   {
; 845                   if (stRead.Pos.y > lReadSyncLine)
	mov	eax,[ebp-010h];	lReadSyncLine
	cmp	dword ptr  stRead+053h,eax
	jle	@BLBL184

; 846                     lOldTop = stRead.Pos.y;
	mov	eax,dword ptr  stRead+053h
	mov	[ebp-01ch],eax;	lOldTop
	jmp	@BLBL185
	align 010h
@BLBL184:

; 847                   else
; 848                     lOldTop = (stRead.lHeight + stCell.cy);
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRead+02fh
	mov	[ebp-01ch],eax;	lOldTop
@BLBL185:

; 849                   stRead.Pos.y = lReadSyncLine;
	mov	eax,[ebp-010h];	lReadSyncLine
	mov	dword ptr  stRead+053h,eax

; 850                   stRead.rclDisp.yBottom = (stRead.Pos.y - stCell.cy);
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRead+053h
	sub	eax,ecx
	mov	dword ptr  stRead+043h,eax

; 851                   stRead.rclDisp.yTop = lOldTop;
	mov	eax,[ebp-01ch];	lOldTop
	mov	dword ptr  stRead+04bh,eax

; 852                   WinFillRect(hpsRead,&stRead.rclDisp,stRead.lBackgrndColor);
	push	dword ptr  stRead+037h
	push	offset FLAT:stRead+03fh
	push	dword ptr [ebp-04h];	hpsRead
	call	WinFillRect
	add	esp,0ch

; 853                   bWriteSync = FALSE;
	mov	dword ptr [ebp-020h],0h;	bWriteSync

; 854                   }
@BLBL183:

; 855                 GpiCharStringAt(hpsRead,&stRead.Pos,1,&byChar);
	lea	eax,[ebp-09h];	byChar
	push	eax
	push	01h
	push	offset FLAT:stRead+04fh
	push	dword ptr [ebp-04h];	hpsRead
	call	GpiCharStringAt
	add	esp,010h

; 856                 if (stRead.bWrap && (stRead.Pos.x >= stRead.lWidth))
	test	byte ptr  stRead+02h,08h
	je	@BLBL186
	mov	eax,dword ptr  stRead+033h
	cmp	dword ptr  stRead+04fh,eax
	jl	@BLBL186

; 857                   {
; 858                   if (stRead.Pos.y <= 0)
	cmp	dword ptr  stRead+053h,0h
	jg	@BLBL187

; 859                     {
; 860                     stRead.Pos.y = stRead.lHeight;
	mov	eax,dword ptr  stRead+02fh
	mov	dword ptr  stRead+053h,eax

; 861                     stRead.rclDisp.yBottom = stRead.lHeight;
	mov	eax,dword ptr  stRead+02fh
	mov	dword ptr  stRead+043h,eax

; 862                     stRead.rclDisp.yTop = (stRead.lHeight + stCell.cy);
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stRead+02fh
	mov	dword ptr  stRead+04bh,eax

; 863                     }
	jmp	@BLBL188
	align 010h
@BLBL187:

; 864                   else
; 865                     {
; 866                     stRead.rclDisp.yTop = stRead.Pos.y;
	mov	eax,dword ptr  stRead+053h
	mov	dword ptr  stRead+04bh,eax

; 867                     stRead.Pos.y -= stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stRead+053h
	sub	eax,ecx
	mov	dword ptr  stRead+053h,eax

; 868                     stRead.rclDisp.yBottom = stRead.Pos.y;
	mov	eax,dword ptr  stRead+053h
	mov	dword ptr  stRead+043h,eax

; 869                     }
@BLBL188:

; 870                   WinFillRect(hpsRead,&stRead.rclDisp,stRead.lBackgrndColor);
	push	dword ptr  stRead+037h
	push	offset FLAT:stRead+03fh
	push	dword ptr [ebp-04h];	hpsRead
	call	WinFillRect
	add	esp,0ch

; 871                   stRead.Pos.x  = 0;
	mov	dword ptr  stRead+04fh,0h

; 872                   }
	jmp	@BLBL181
	align 010h
@BLBL186:

; 873                 else
; 874                   stRead.Pos.x += stCell.cx;
	movsx	eax,word ptr  stCell
	add	eax,dword ptr  stRead+04fh
	mov	dword ptr  stRead+04fh,eax

; 875                 }

; 876               }
@BLBL181:

; 877             break;
	jmp	@BLBL212
	align 04h
@BLBL217:
@BLBL218:

; 878           case CS_WRITE_IMM:
; 879           case CS_WRITE:
; 880             if (stWrite.bFilter)
	test	byte ptr  stWrite+02h,020h
	je	@BLBL190

; 881               byChar &= stWrite.byDisplayMask;
	mov	al,byte ptr  stWrite+04h
	and	al,[ebp-09h];	byChar
	mov	[ebp-09h],al;	byChar
@BLBL190:

; 882             if (stWrite.bTestNewLine && (byChar == stWrite.byNewLineChar))
	test	byte ptr  stWrite+02h,02h
	je	@BLBL191
	mov	al,byte ptr  stWrite+03h
	cmp	[ebp-09h],al;	byChar
	jne	@BLBL191

; 883               {
; 884               if (stWrite.bSkipBlankLines && bLastWriteWasNewLine)
	test	byte ptr  stWrite+02h,04h
	je	@BLBL192
	cmp	dword ptr [ebp-024h],0h;	bLastWriteWasNewLine
	je	@BLBL192

; 885                 break;
	jmp	@BLBL212
	align 04h
@BLBL192:

; 886               bLastWriteWasNewLine = TRUE;
	mov	dword ptr [ebp-024h],01h;	bLastWriteWasNewLine

; 887               if (CharPrintable(&byChar,&stWrite))
	push	offset FLAT:stWrite
	lea	eax,[ebp-09h];	byChar
	push	eax
	call	CharPrintable
	add	esp,08h
	test	eax,eax
	je	@BLBL193

; 888                 if (stWrite.bWrap || (stWrite.Pos.x <= stWrite.lWidth))
	test	byte ptr  stWrite+02h,08h
	jne	@BLBL194
	mov	eax,dword ptr  stWrite+033h
	cmp	dword ptr  stWrite+04fh,eax
	jg	@BLBL193
@BLBL194:

; 889                   GpiCharStringAt(hpsWrite,&stWrite.Pos,1,&byChar);
	lea	eax,[ebp-09h];	byChar
	push	eax
	push	01h
	push	offset FLAT:stWrite+04fh
	push	dword ptr [ebp-08h];	hpsWrite
	call	GpiCharStringAt
	add	esp,010h
@BLBL193:

; 890               stWrite.Pos.x = 0L;
	mov	dword ptr  stWrite+04fh,0h

; 891               if (stWrite.Pos.y <= 0)
	cmp	dword ptr  stWrite+053h,0h
	jg	@BLBL196

; 892                 {
; 893                 stWrite.Pos.y = stWrite.lHeight;
	mov	eax,dword ptr  stWrite+02fh
	mov	dword ptr  stWrite+053h,eax

; 894                 stWrite.rclDisp.yBottom = stWrite.lHeight;
	mov	eax,dword ptr  stWrite+02fh
	mov	dword ptr  stWrite+043h,eax

; 895                 stWrite.rclDisp.yTop = stWrite.lHeight + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stWrite+02fh
	mov	dword ptr  stWrite+04bh,eax

; 896                 }
	jmp	@BLBL197
	align 010h
@BLBL196:

; 897               else
; 898                 {
; 899                 stWrite.rclDisp.yTop = stWrite.Pos.y;
	mov	eax,dword ptr  stWrite+053h
	mov	dword ptr  stWrite+04bh,eax

; 900                 stWrite.Pos.y -= stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stWrite+053h
	sub	eax,ecx
	mov	dword ptr  stWrite+053h,eax

; 901                 stWrite.rclDisp.yBottom = stWrite.Pos.y;
	mov	eax,dword ptr  stWrite+053h
	mov	dword ptr  stWrite+043h,eax

; 902      
; 902            }
@BLBL197:

; 903               WinFillRect(hpsWrite,&stWrite.rclDisp,stWrite.lBackgrndColor);
	push	dword ptr  stWrite+037h
	push	offset FLAT:stWrite+03fh
	push	dword ptr [ebp-08h];	hpsWrite
	call	WinFillRect
	add	esp,0ch

; 904               if (stRead.bSync)
	test	byte ptr  stRead+02h,010h
	je	@BLBL199

; 905                 {
; 906                 bWriteSync = TRUE;
	mov	dword ptr [ebp-020h],01h;	bWriteSync

; 907                 lReadSyncLine = stWrite.Pos.y;
	mov	eax,dword ptr  stWrite+053h
	mov	[ebp-010h],eax;	lReadSyncLine

; 908                 }

; 909               }
	jmp	@BLBL199
	align 010h
@BLBL191:

; 910             else
; 911               {
; 912               bLastWriteWasNewLine = FALSE;
	mov	dword ptr [ebp-024h],0h;	bLastWriteWasNewLine

; 913               if (CharPrintable(&byChar,&stWrite))
	push	offset FLAT:stWrite
	lea	eax,[ebp-09h];	byChar
	push	eax
	call	CharPrintable
	add	esp,08h
	test	eax,eax
	je	@BLBL199

; 914                 {
; 915                 if (bReadSync && (stWrite.Pos.x == 0))
	cmp	dword ptr [ebp-018h],0h;	bReadSync
	je	@BLBL201
	cmp	dword ptr  stWrite+04fh,0h
	jne	@BLBL201

; 916                   {
; 917                   if (stWrite.Pos.y > lWriteSyncLine)
	mov	eax,[ebp-014h];	lWriteSyncLine
	cmp	dword ptr  stWrite+053h,eax
	jle	@BLBL202

; 918                     lOldTop = stWrite.Pos.y;
	mov	eax,dword ptr  stWrite+053h
	mov	[ebp-01ch],eax;	lOldTop
	jmp	@BLBL203
	align 010h
@BLBL202:

; 919                   else
; 920                     lOldTop = (stWrite.lHeight + stCell.cy);
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stWrite+02fh
	mov	[ebp-01ch],eax;	lOldTop
@BLBL203:

; 921                   stWrite.Pos.y = lWriteSyncLine;
	mov	eax,[ebp-014h];	lWriteSyncLine
	mov	dword ptr  stWrite+053h,eax

; 922                   stWrite.rclDisp.yBottom = (stWrite.Pos.y - stCell.cy);
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stWrite+053h
	sub	eax,ecx
	mov	dword ptr  stWrite+043h,eax

; 923                   stWrite.rclDisp.yTop = lOldTop;
	mov	eax,[ebp-01ch];	lOldTop
	mov	dword ptr  stWrite+04bh,eax

; 924                   WinFillRect(hpsWrite,&stWrite.rclDisp,stWrite.lBackgrndColor);
	push	dword ptr  stWrite+037h
	push	offset FLAT:stWrite+03fh
	push	dword ptr [ebp-08h];	hpsWrite
	call	WinFillRect
	add	esp,0ch

; 925                   bReadSync = FALSE;
	mov	dword ptr [ebp-018h],0h;	bReadSync

; 926                   }
@BLBL201:

; 927                 GpiCharStringAt(hpsWrite,&stWrite.Pos,1,&byChar);
	lea	eax,[ebp-09h];	byChar
	push	eax
	push	01h
	push	offset FLAT:stWrite+04fh
	push	dword ptr [ebp-08h];	hpsWrite
	call	GpiCharStringAt
	add	esp,010h

; 928                 if (stWrite.bWrap && (stWrite.Pos.x >= stWrite.lWidth))
	test	byte ptr  stWrite+02h,08h
	je	@BLBL204
	mov	eax,dword ptr  stWrite+033h
	cmp	dword ptr  stWrite+04fh,eax
	jl	@BLBL204

; 929                   {
; 930                   if (stWrite.Pos.y <= 0 )
	cmp	dword ptr  stWrite+053h,0h
	jg	@BLBL205

; 931                     {
; 932                     stWrite.Pos.y = stWrite.lHeight;
	mov	eax,dword ptr  stWrite+02fh
	mov	dword ptr  stWrite+053h,eax

; 933                     stWrite.rclDisp.yBottom = stWrite.lHeight;
	mov	eax,dword ptr  stWrite+02fh
	mov	dword ptr  stWrite+043h,eax

; 934                     stWrite.rclDisp.yTop = stWrite.lHeight + stCell.cy;
	movsx	eax,word ptr  stCell+02h
	add	eax,dword ptr  stWrite+02fh
	mov	dword ptr  stWrite+04bh,eax

; 935                     }
	jmp	@BLBL206
	align 010h
@BLBL205:

; 936                  else
; 937                     {
; 938                     stWrite.rclDisp.yTop = stWrite.Pos.y;
	mov	eax,dword ptr  stWrite+053h
	mov	dword ptr  stWrite+04bh,eax

; 939                     stWrite.Pos.y -= stCell.cy;
	movsx	ecx,word ptr  stCell+02h
	mov	eax,dword ptr  stWrite+053h
	sub	eax,ecx
	mov	dword ptr  stWrite+053h,eax

; 940                     stWrite.rclDisp.yBottom = stWrite.Pos.y;
	mov	eax,dword ptr  stWrite+053h
	mov	dword ptr  stWrite+043h,eax

; 941                     }
@BLBL206:

; 942                   WinFillRect(hpsWrite,&stWrite.rclDisp,stWrite.lBackgrndColor);
	push	dword ptr  stWrite+037h
	push	offset FLAT:stWrite+03fh
	push	dword ptr [ebp-08h];	hpsWrite
	call	WinFillRect
	add	esp,0ch

; 943                   stWrite.Pos.x  = 0;
	mov	dword ptr  stWrite+04fh,0h

; 944                   }
	jmp	@BLBL199
	align 010h
@BLBL204:

; 945                 else
; 946                   stWrite.Pos.x += stCell.cx;
	movsx	eax,word ptr  stCell
	add	eax,dword ptr  stWrite+04fh
	mov	dword ptr  stWrite+04fh,eax

; 947                 }

; 948               }
@BLBL199:

; 949             break;
	jmp	@BLBL212
	align 04h
	jmp	@BLBL212
	align 04h
@BLBL213:
	cmp	eax,0ff00h
	je	@BLBL214
	cmp	eax,04100h
	je	@BLBL215
	cmp	eax,04000h
	je	@BLBL216
	cmp	eax,08100h
	je	@BLBL217
	cmp	eax,08000h
	je	@BLBL218
@BLBL212:

; 950 
; 951           }
; 952         }
	jmp	@BLBL208
	align 010h
@BLBL167:

; 953       else
; 954         {
; 955         iPacketCount--;
	mov	eax,[ebp-034h];	iPacketCount
	dec	eax
	mov	[ebp-034h],eax;	iPacketCount

; 956         if (lReadIndex++ >= stCFG.lBufferLength)
	mov	eax,dword ptr  stCFG+0d5h
	cmp	dword ptr  lReadIndex,eax
	jl	@BLBL209
	mov	eax,dword ptr  lReadIndex
	inc	eax
	mov	dword ptr  lReadIndex,eax

; 957           lReadIndex = 0;
	mov	dword ptr  lReadIndex,0h
	jmp	@BLBL208
	align 010h
@BLBL209:
	mov	eax,dword ptr  lReadIndex
	inc	eax
	mov	dword ptr  lReadIndex,eax

; 958         }
@BLBL208:

; 959       }

; 774     while (lReadIndex != lWriteIndex && !bStopDisplayThread)
	mov	eax,dword ptr  lWriteIndex
	cmp	dword ptr  lReadIndex,eax
	je	@BLBL165
	cmp	dword ptr  bStopDisplayThread,0h
	je	@BLBL166
@BLBL165:

; 960     WinReleasePS(hpsRead);
	push	dword ptr [ebp-04h];	hpsRead
	call	WinReleasePS
	add	esp,04h

; 961     WinReleasePS(hpsWrite);
	push	dword ptr [ebp-08h];	hpsWrite
	call	WinReleasePS
	add	esp,04h

; 962     DosReleaseMutexSem(hmtxColGioBlockedSem);
	push	dword ptr  hmtxColGioBlockedSem
	call	DosReleaseMutexSem
	add	esp,04h

; 963     }

; 759   while (!bStopDisplayThread)
	cmp	dword ptr  bStopDisplayThread,0h
	je	@BLBL160
@BLBL159:

; 965   DosPostEventSem(hevKillDisplayThreadSem);
	push	dword ptr  hevKillDisplayThreadSem
	call	DosPostEventSem
	add	esp,04h

; 967   }
	mov	esp,ebp
	pop	ebp
	ret	
ColumnDisplayThread	endp

; 970   {
	align 010h

	public MonitorThread
MonitorThread	proc
	push	ebp
	mov	ebp,esp
	sub	esp,074h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,01dh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 977   WORD *pwBuffer = pwCaptureBuffer;
	mov	eax,dword ptr  pwCaptureBuffer
	mov	[ebp-068h],eax;	pwBuffer

; 978   ULONG ulPostCount;
; 979   WORD *pwCOMscopeData;
; 980   WORD wChar;
; 981 
; 982   EnableCOMscope(hwndFrame,hCom,&ulCount,(stCFG.fTraceEvent | CSFUNC_RESET_BUFFERS));
	mov	eax,dword ptr  stCFG+01fh
	or	al,01h
	push	eax
	lea	eax,[ebp-010h];	ulCount
	push	eax
	push	dword ptr [ebp+08h];	hCom
	push	dword ptr  hwndFrame
	call	EnableCOMscope
	add	esp,010h

; 983   if (DosAllocMem((PPVOID)&pstCOMscopeDataSet,((ulCount * 2) + sizeof(ULONG)),PAG_COMMIT | PAG_READ | PAG_WRITE) != NO_ERROR)
	push	013h
	mov	eax,[ebp-010h];	ulCount
	add	eax,eax
	add	eax,04h
	push	eax
	lea	eax,[ebp-0ch];	pstCOMscopeDataSet
	push	eax
	call	DosAllocMem
	add	esp,0ch
	test	eax,eax
	je	@BLBL219

; 984     {
; 985     EnableCOMscope(hwndFrame,hCom,&ulCount,FALSE);
	push	0h
	lea	eax,[ebp-010h];	ulCount
	push	eax
	push	dword ptr [ebp+08h];	hCom
	push	dword ptr  hwndFrame
	call	EnableCOMscope
	add	esp,010h

; 986     sprintf(szMessage,"Unable to allocate COMscope/COMi buffer (Monitor Thread).");
	mov	edx,offset FLAT:@STAT7
	lea	eax,[ebp-060h];	szMessage
	call	_sprintfieee

; 987     ErrorNotify(szMessage);
	lea	eax,[ebp-060h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 988     DosExit(EXIT_THREAD,0);
	push	0h
	push	0h
	call	DosExit
	add	esp,08h

; 989     }
@BLBL219:

; 990   if (GetBaudRate(&stIOctl,hCom,&lBaud) == NO_ERROR)
	lea	eax,[ebp-064h];	lBaud
	push	eax
	push	dword ptr [ebp+08h];	hCom
	push	offset FLAT:stIOctl
	call	GetBaudRate
	add	esp,0ch
	test	eax,eax
	jne	@BLBL220

; 991     CalcThreadSleepCount(lBaud);
	push	dword ptr [ebp-064h];	lBaud
	call	CalcThreadSleepCount
	add	esp,04h
	jmp	@BLBL221
	align 010h
@BLBL220:

; 992   else
; 993     if (stCFG.ulUserSleepCount != 0)
	cmp	dword ptr  stCFG+0d1h,0h
	je	@BLBL221

; 994       ulMonitorSleepCount = stCFG.ulUserSleepCount;
	mov	eax,dword ptr  stCFG+0d1h
	mov	dword ptr  ulMonitorSleepCount,eax
@BLBL221:

; 995   pstCOMscopeDataSet->cbSize = (WORD)ulCount;
	mov	cx,[ebp-010h];	ulCount
	and	ecx,0ffffh
	mov	eax,[ebp-0ch];	pstCOMscopeDataSet
	mov	[eax],ecx

; 996   pwCOMscopeData = (USHORT *)&pstCOMscopeDataSet->awData;
	mov	eax,[ebp-0ch];	pstCOMscopeDataSet
	add	eax,04h
	mov	[ebp-070h],eax;	pwCOMscopeData

; 997   bDataToView = FALSE;
	mov	dword ptr  bDataToView,0h

; 998   lWriteIndex = 0;
	mov	dword ptr  lWriteIndex,0h

; 999   lReadIndex = 0;
	mov	dword ptr  lReadIndex,0h

; 1000   memset(&stCharCount,0,sizeof(CHARCNT));
	mov	ecx,010h
	xor	edx,edx
	mov	eax,offset FLAT:stCharCount
	call	memset

; 1001   bCaptureFileWritten = FALSE;
	mov	dword ptr  bCaptureFileWritten,0h

; 1002   bBufferWrapped = FALSE;
	mov	dword ptr  bBufferWrapped,0h

; 1003   WinPostMsg(hwndClient,UM_STARTMONITORTHREAD,0L,0L);
	push	0h
	push	0h
	push	08017h
	push	dword ptr  hwndClient
	call	WinPostMsg
	add	esp,010h

; 1004   DosSetPriority(PRTYS_THREAD,PRTYC_TIMECRITICAL,4L,tidMonitorThread);
	push	dword ptr  tidMonitorThread
	push	04h
	push	03h
	push	02h
	call	DosSetPriority
	add	esp,010h

; 1005   while (!bStopMonitorThread)
	cmp	dword ptr  bStopMonitorThread,0h
	jne	@BLBL223
	align 010h
@BLBL224:

; 1006     {
; 1007     pstCOMscopeDataSet->cbSize = ulCount;
	mov	eax,[ebp-0ch];	pstCOMscopeDataSet
	mov	ecx,[ebp-010h];	ulCount
	mov	[eax],ecx

; 1008     AccessCOMscope(hCom,pstCOMscopeDataSet);
	push	dword ptr [ebp-0ch];	pstCOMscopeDataSet
	push	dword ptr [ebp+08h];	hCom
	call	AccessCOMscope
	add	esp,08h

; 1009     if (pstCOMscopeDataSet->cbSize == 0)
	mov	eax,[ebp-0ch];	pstCOMscopeDataSet
	cmp	dword ptr [eax],0h
	jne	@BLBL225

; 1010       {
; 1011       DosResetEventSem(hevDisplayWaitDataSem,&ulPostCount);
	lea	eax,[ebp-06ch];	ulPostCount
	push	eax
	push	dword ptr  hevDisplayWaitDataSem
	call	DosResetEventSem
	add	esp,08h

; 1012       DosResetEventSem(hevWaitCOMiDataSem,&ulPostCount);
	lea	eax,[ebp-06ch];	ulPostCount
	push	eax
	push	dword ptr  hevWaitCOMiDataSem
	call	DosResetEventSem
	add	esp,08h

; 1013       DosWaitEventSem(hevWaitCOMiDataSem,ulMonitorSleepCount);
	push	dword ptr  ulMonitorSleepCount
	push	dword ptr  hevWaitCOMiDataSem
	call	DosWaitEventSem
	add	esp,08h

; 1014 //      if (DosWaitEventSem(hevWaitCOMiDataSem,ulMonitorSleepCount) != ERROR_TIMEOUT)
; 1015 //        bStopMonitorThread = TRUE;
; 1016       }
	jmp	@BLBL226
	align 010h
@BLBL225:

; 1017     else
; 1018       {
; 1019       DosPostEventSem(hevDisplayWaitDataSem);
	push	dword ptr  hevDisplayWaitDataSem
	call	DosPostEventSem
	add	esp,04h

; 1020       if (!bDataToView)
	cmp	dword ptr  bDataToView,0h
	jne	@BLBL227

; 1021         {
; 1022         WinPostMsg(hwndClient,UM_VIEWDAT_ON,0L,0L);
	push	0h
	push	0h
	push	0800ah
	push	dword ptr  hwndClient
	call	WinPostMsg
	add	esp,010h

; 1023         bDataToView = TRUE;
	mov	dword ptr  bDataToView,01h

; 1024         }
@BLBL227:

; 1025       lDataLen = pstCOMscopeDataSet->cbSize;
	mov	eax,[ebp-0ch];	pstCOMscopeDataSet
	mov	eax,[eax]
	mov	[ebp-08h],eax;	lDataLen

; 1026       for (lIndex = 0;lIndex < lDataLen;lIndex++)
	mov	dword ptr [ebp-04h],0h;	lIndex
	mov	eax,[ebp-08h];	lDataLen
	cmp	[ebp-04h],eax;	lIndex
	jge	@BLBL226
	align 010h
@BLBL229:

; 1027         {
; 1028         if (lWriteIndex >= stCFG.lBufferLength)
	mov	eax,dword ptr  stCFG+0d5h
	cmp	dword ptr  lWriteIndex,eax
	jl	@BLBL230

; 1029           {
; 1030           if (stCFG.bCaptureToFile)
	test	byte ptr  stCFG+016h,020h
	je	@BLBL231

; 1031             {
; 1032             DosAllocMem((PPVOID)&pwBuffer,(stCFG.lBufferLength * 2),PAG_COMMIT | PAG_READ | PAG_WRITE);
	push	013h
	mov	eax,dword ptr  stCFG+0d5h
	add	eax,eax
	push	eax
	lea	eax,[ebp-068h];	pwBuffer
	push	eax
	call	DosAllocMem
	add	esp,0ch

; 1033             if (pwBuffer != NULL)
	cmp	dword ptr [ebp-068h],0h;	pwBuffer
	je	@BLBL232

; 1034               {
; 1035               WinPostMsg(hwndClient,UM_BUFFER_END,(MPARAM)pwCaptureBuffer,0L);
	push	0h
	push	dword ptr  pwCaptureBuffer
	push	0800bh
	push	dword ptr  hwndClient
	call	WinPostMsg
	add	esp,010h

; 1036               pwCaptureBuffer = pwBuffer;
	mov	eax,[ebp-068h];	pwBuffer
	mov	dword ptr  pwCaptureBuffer,eax

; 1037               lReadIndex = 0;
	mov	dword ptr  lReadIndex,0h

; 1038               }
	jmp	@BLBL235
	align 010h
@BLBL232:

; 1039             else
; 1040               {
; 1041               sprintf(szMessage,"Unable to allocate new capture buffer (Monitor Thread).");
	mov	edx,offset FLAT:@STAT8
	lea	eax,[ebp-060h];	szMessage
	call	_sprintfieee

; 1042               ErrorNotify(szMessage);
	lea	eax,[ebp-060h];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1043               bStopMonitorThread = TRUE;
	mov	dword ptr  bStopMonitorThread,01h

; 1044               break;
	jmp	@BLBL226
	align 010h
@BLBL231:

; 1045               }
; 1046             }
; 1047           else
; 1048             {
; 1049             if (!stCFG.bOverWriteBuffer)
	test	byte ptr  stCFG+018h,02h
	jne	@BLBL236

; 1050               {
; 1051               WinPostMsg(hwndClient,UM_BUFFER_END,0L,0L);
	push	0h
	push	0h
	push	0800bh
	push	dword ptr  hwndClient
	call	WinPostMsg
	add	esp,010h

; 1052               bStopMonitorThread = TRUE;
	mov	dword ptr  bStopMonitorThread,01h

; 1053               break;
	jmp	@BLBL226
	align 010h
@BLBL236:

; 1054               }
; 1055             else
; 1056               bBufferWrapped = TRUE;
	mov	dword ptr  bBufferWrapped,01h

; 1057             }
@BLBL235:

; 1058           lWriteIndex = 0;
	mov	dword ptr  lWriteIndex,0h

; 1059           }
@BLBL230:

; 1060         wChar = pwCOMscopeData[lIndex];
	mov	eax,[ebp-070h];	pwCOMscopeData
	mov	ecx,[ebp-04h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	mov	[ebp-072h],ax;	wChar

; 1061         switch (wChar & 0xff00)
	xor	eax,eax
	mov	ax,[ebp-072h];	wChar
	and	eax,0ff00h
	jmp	@BLBL241
	align 04h
@BLBL242:

; 1062           {
; 1063           case CS_READ:
; 1064             stCharCount.lRead++;
	mov	eax,dword ptr  stCharCount
	inc	eax
	mov	dword ptr  stCharCount,eax

; 1065             break;
	jmp	@BLBL240
	align 04h
@BLBL243:

; 1066           case CS_WRITE:
; 1067             stCharCount.lWrite++;
	mov	eax,dword ptr  stCharCount+04h
	inc	eax
	mov	dword ptr  stCharCount+04h,eax

; 1068             break;
	jmp	@BLBL240
	align 04h
@BLBL244:

; 1069           case CS_WRITE_IMM:
; 1070             stCharCount.lWriteImm++;
	mov	eax,dword ptr  stCharCount+0ch
	inc	eax
	mov	dword ptr  stCharCount+0ch,eax

; 1071             break;
	jmp	@BLBL240
	align 04h
@BLBL245:

; 1072           case CS_READ_IMM:
; 1073             stCharCount.lReadImm++;
	mov	eax,dword ptr  stCharCount+08h
	inc	eax
	mov	dword ptr  stCharCount+08h,eax

; 1074             break;
	jmp	@BLBL240
	align 04h
	jmp	@BLBL240
	align 04h
@BLBL241:
	cmp	eax,04000h
	je	@BLBL242
	cmp	eax,08000h
	je	@BLBL243
	cmp	eax,08100h
	je	@BLBL244
	cmp	eax,04100h
	je	@BLBL245
@BLBL240:

; 1075           }
; 1076         pwBuffer[lWriteIndex++] = wChar;
	mov	eax,[ebp-068h];	pwBuffer
	mov	ecx,dword ptr  lWriteIndex
	mov	dx,[ebp-072h];	wChar
	mov	word ptr [eax+ecx*02h],dx
	mov	eax,dword ptr  lWriteIndex
	inc	eax
	mov	dword ptr  lWriteIndex,eax

; 1077 //        DosEnterCritSec();
; 1078 //        if (lWriteIndex == lReadIndex)
; 1079 //          lReadIndex++;
; 1080 //        DosExitCritSec();
; 1081         }

; 1026       for (lIndex = 0;lIndex < lDataLen;lIndex++)
	mov	eax,[ebp-04h];	lIndex
	inc	eax
	mov	[ebp-04h],eax;	lIndex
	mov	eax,[ebp-08h];	lDataLen
	cmp	[ebp-04h],eax;	lIndex
	jl	@BLBL229

; 1082       }
@BLBL226:

; 1083     }

; 1005   while (!bStopMonitorThread)
	cmp	dword ptr  bStopMonitorThread,0h
	je	@BLBL224
@BLBL223:

; 1084   EnableCOMscope(hwndFrame,hCom,&ulCount,FALSE);
	push	0h
	lea	eax,[ebp-010h];	ulCount
	push	eax
	push	dword ptr [ebp+08h];	hCom
	push	dword ptr  hwndFrame
	call	EnableCOMscope
	add	esp,010h

; 1085   DosFreeMem(pstCOMscopeDataSet);
	push	dword ptr [ebp-0ch];	pstCOMscopeDataSet
	call	DosFreeMem
	add	esp,04h

; 1086   lReadIndex = lWriteIndex;
	mov	eax,dword ptr  lWriteIndex
	mov	dword ptr  lReadIndex,eax

; 1087   if (stCFG.bCaptureToFile && (lWriteIndex != 0))
	test	byte ptr  stCFG+016h,020h
	je	@BLBL239
	cmp	dword ptr  lWriteIndex,0h
	je	@BLBL239

; 1089     WriteCaptureFile(szCaptureFileName,pwCaptureBuffer,lWriteIndex,FOPEN_OVERWRITE,HLPP_MB_OVERWRT_CAP_FILE);
	push	09ca9h
	push	01h
	mov	eax,dword ptr  lWriteIndex
	push	eax
	push	dword ptr  pwCaptureBuffer
	push	offset FLAT:szCaptureFileName
	call	WriteCaptureFile
	add	esp,014h

; 1091     }
@BLBL239:

; 1092   WinPostMsg(hwndClient,UM_KILLMONITORTHREAD,(MPARAM)lWriteIndex,0L);
	push	0h
	mov	eax,dword ptr  lWriteIndex
	push	eax
	push	0800dh
	push	dword ptr  hwndClient
	call	WinPostMsg
	add	esp,010h

; 1093   DosPostEventSem(hevKillMonitorThreadSem);
	push	dword ptr  hevKillMonitorThreadSem
	call	DosPostEventSem
	add	esp,04h

; 1095   }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
MonitorThread	endp

; 1098   {
	align 010h

	public KillMonitorThread
KillMonitorThread	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 1101   if (!bStopMonitorThread)
	cmp	dword ptr  bStopMonitorThread,0h
	jne	@BLBL246

; 1102     {
; 1103     DosResetEventSem(hevKillMonitorThreadSem,&ulPostCount);
	lea	eax,[ebp-04h];	ulPostCount
	push	eax
	push	dword ptr  hevKillMonitorThreadSem
	call	DosResetEventSem
	add	esp,08h

; 1104     bStopMonitorThread = TRUE;
	mov	dword ptr  bStopMonitorThread,01h

; 1105     DosPostEventSem(hevWaitCOMiDataSem);
	push	dword ptr  hevWaitCOMiDataSem
	call	DosPostEventSem
	add	esp,04h

; 1106     DosWaitEventSem(hevKillMonitorThreadSem,10000);
	push	02710h
	push	dword ptr  hevKillMonitorThreadSem
	call	DosWaitEventSem
	add	esp,08h

; 1107     return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL246:

; 1108     }
; 1109   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
KillMonitorThread	endp

; 1113   {
	align 010h

	public KillDisplayThread
KillDisplayThread	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 1116   if (!bStopDisplayThread)
	cmp	dword ptr  bStopDisplayThread,0h
	jne	@BLBL247

; 1117     {
; 1118     DosResetEventSem(hevKillDisplayThreadSem,&ulPostCount);
	lea	eax,[ebp-04h];	ulPostCount
	push	eax
	push	dword ptr  hevKillDisplayThreadSem
	call	DosResetEventSem
	add	esp,08h

; 1119     bStopDisplayThread = TRUE;
	mov	dword ptr  bStopDisplayThread,01h

; 1120     DosPostEventSem(hevDisplayWaitDataSem);
	push	dword ptr  hevDisplayWaitDataSem
	call	DosPostEventSem
	add	esp,04h

; 1121     DosWaitEventSem(hevKillDisplayThreadSem,10000);
	push	02710h
	push	dword ptr  hevKillDisplayThreadSem
	call	DosWaitEventSem
	add	esp,08h

; 1122     return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL247:

; 1123     }
; 1124   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
KillDisplayThread	endp

; 1128   {
	align 010h

	public IPCserverThread
IPCserverThread	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0180h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,060h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 1134   DosSetPriority(PRTYS_THREAD,PRTYC_TIMECRITICAL,10L,tidIPCserverThread);
	push	dword ptr  tidIPCserverThread
	push	0ah
	push	03h
	push	02h
	call	DosSetPriority
	add	esp,010h

; 1135   if (bIsTheFirst)
	cmp	dword ptr  bIsTheFirst,0h
	je	@BLBL248

; 1136     {
; 1137     stSD.Length = sizeof(STARTDATA);
	mov	word ptr  stSD,03ch

; 1138     stSD.Related = SSF_RELATED_INDEPENDENT;
	mov	word ptr  stSD+02h,0h

; 1139     if (bShowServerProcess)
	cmp	dword ptr  bShowServerProcess,0h
	je	@BLBL249

; 1140       stSD.FgBg = SSF_FGBG_FORE;
	mov	word ptr  stSD+04h,0h
	jmp	@BLBL250
	align 010h
@BLBL249:

; 1141     else
; 1142       stSD.FgBg = SSF_FGBG_BACK;
	mov	word ptr  stSD+04h,01h
@BLBL250:

; 1143     stSD.TraceOpt = SSF_TRACEOPT_NONE;
	mov	word ptr  stSD+06h,0h

; 1144     stSD.TermQ = 0;
	mov	dword ptr  stSD+014h,0h

; 1145     stSD.Environment = 0;
	mov	dword ptr  stSD+018h,0h

; 1146     stSD.InheritOpt = SSF_INHERTOPT_SHELL;
	mov	word ptr  stSD+01ch,0h

; 1147     stSD.SessionType = SSF_TYPE_WINDOWABLEVIO;
	mov	word ptr  stSD+01eh,02h

; 1148     stSD.IconFile = 0;
	mov	dword ptr  stSD+020h,0h

; 1149     stSD.PgmHandle = 0;
	mov	dword ptr  stSD+024h,0h

; 1150     stSD.ObjectBuffer = 0;
	mov	dword ptr  stSD+034h,0h

; 1151     stSD.ObjectBuffLen = 0;
	mov	dword ptr  stSD+038h,0h

; 1152     sprintf(szServerTitle,"OS/tools IPC Server - %s",szIPCpipeName);
	push	offset FLAT:szIPCpipeName
	mov	edx,offset FLAT:@STAT9
	lea	eax,[ebp-07ch];	szServerTitle
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1153     sprintf(szServerProgram,"%sCONTROL.EXE",szCOMscopeIniPath);
	push	offset FLAT:szCOMscopeIniPath
	mov	edx,offset FLAT:@STATa
	lea	eax,[ebp-0180h];	szServerProgram
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1154     stSD.PgmTitle = szServerTitle;
	lea	eax,[ebp-07ch];	szServerTitle
	mov	dword ptr  stSD+08h,eax

; 1155     stSD.PgmName = (PSZ)
; 1155 szServerProgram;
	lea	eax,[ebp-0180h];	szServerProgram
	mov	dword ptr  stSD+0ch,eax

; 1156     stSD.PgmInputs = szServerCommand;
	mov	dword ptr  stSD+010h,offset FLAT:szServerCommand

; 1157     if (bShowServerProcess)
	cmp	dword ptr  bShowServerProcess,0h
	je	@BLBL251

; 1158       {
; 1159       stSD.PgmControl = SSF_CONTROL_NOAUTOCLOSE;
	mov	word ptr  stSD+028h,08h

; 1160       stSD.FgBg = SSF_FGBG_FORE;
	mov	word ptr  stSD+04h,0h

; 1161       sprintf(szServerCommand,"/T%s /D%c",szIPCpipeName,chPipeDebug);
	xor	eax,eax
	mov	al,byte ptr  chPipeDebug
	push	eax
	push	offset FLAT:szIPCpipeName
	mov	edx,offset FLAT:@STATb
	mov	eax,offset FLAT:szServerCommand
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 1162       }
	jmp	@BLBL252
	align 010h
@BLBL251:

; 1163     else
; 1164       {
; 1165       stSD.PgmControl = SSF_CONTROL_INVISIBLE;
	mov	word ptr  stSD+028h,01h

; 1166       stSD.FgBg = SSF_FGBG_BACK;
	mov	word ptr  stSD+04h,01h

; 1167       sprintf(szServerCommand,"/T%s",szIPCpipeName);
	push	offset FLAT:szIPCpipeName
	mov	edx,offset FLAT:@STATc
	mov	eax,offset FLAT:szServerCommand
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1168       }
@BLBL252:

; 1169     rc = DosStartSession(&stSD,&ulSessionID,&pidSession);
	push	offset FLAT:pidSession
	push	offset FLAT:ulSessionID
	push	offset FLAT:stSD
	call	DosStartSession
	add	esp,0ch
	mov	[ebp-04h],eax;	rc

; 1170     if ((chPipeDebug > '0') && (rc != NO_ERROR))
	mov	al,byte ptr  chPipeDebug
	cmp	al,030h
	jbe	@BLBL253
	cmp	dword ptr [ebp-04h],0h;	rc
	je	@BLBL253

; 1171       switch (rc)
	mov	eax,[ebp-04h];	rc
	jmp	@BLBL276
	align 04h
@BLBL277:

; 1172         {
; 1173         case ERROR_SMG_INVALID_SESSION_ID:
; 1174           ErrorNotify("Invalid Session ID, starting IPC server");
	push	offset FLAT:@STATd
	call	ErrorNotify
	add	esp,04h

; 1175           break;
	jmp	@BLBL275
	align 04h
@BLBL278:

; 1176         case ERROR_SMG_INVALID_CALL:
; 1177 //          ErrorNotify("Invalid Call, starting IPC server");
; 1178           ErrorNotify(szServerProgram);
	lea	eax,[ebp-0180h];	szServerProgram
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1179           break;
	jmp	@BLBL275
	align 04h
@BLBL279:

; 1180         case ERROR_SMG_PROCESS_NOT_PARENT:
; 1181           ErrorNotify("Error starting IPC server - Process not parent");
	push	offset FLAT:@STATe
	call	ErrorNotify
	add	esp,04h

; 1182           break;
	jmp	@BLBL275
	align 04h
@BLBL280:

; 1183         case ERROR_SMG_RETRY_SUB_ALLOC:
; 1184           ErrorNotify("Retry Sub-Allocation, starting IPC server");
	push	offset FLAT:@STATf
	call	ErrorNotify
	add	esp,04h

; 1185           break;
	jmp	@BLBL275
	align 04h
@BLBL281:

; 1186         default:
; 1187           sprintf(szMessage,"Unkown Error = %u - starting IPC server",rc);
	push	dword ptr [ebp-04h];	rc
	mov	edx,offset FLAT:@STAT10
	lea	eax,[ebp-02ch];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1188           ErrorNotify(szMessage);
	lea	eax,[ebp-02ch];	szMessage
	push	eax
	call	ErrorNotify
	add	esp,04h

; 1189           break;
	jmp	@BLBL275
	align 04h
	jmp	@BLBL275
	align 04h
@BLBL276:
	cmp	eax,0171h
	je	@BLBL277
	cmp	eax,01a2h
	je	@BLBL278
	cmp	eax,01cch
	je	@BLBL279
	cmp	eax,01cfh
	je	@BLBL280
	jmp	@BLBL281
	align 04h
@BLBL275:
@BLBL253:

; 1190         }
; 1191     DosSleep(500);
	push	01f4h
	call	DosSleep
	add	esp,04h

; 1192     }
@BLBL248:

; 1193   stIPCpipe.ulMessage = UM_PIPE_INIT;
	mov	dword ptr  stIPCpipe+02h,0801fh

; 1194   if (bIPCpipeOpen)
	cmp	dword ptr  bIPCpipeOpen,0h
	je	@BLBL254

; 1195     {
; 1196     DosTransactNPipe(hIPCpipe,&stIPCpipe,sizeof(IPCPIPEMSG),&stIPCpipe,sizeof(IPCPIPEMSG),&ulBytesRead);
	push	offset FLAT:ulBytesRead
	push	0ah
	push	offset FLAT:stIPCpipe
	push	0ah
	push	offset FLAT:stIPCpipe
	push	dword ptr  hIPCpipe
	call	DosTransactNPipe
	add	esp,018h

; 1197     DosClose(hIPCpipe);
	push	dword ptr  hIPCpipe
	call	DosClose
	add	esp,04h

; 1198     }
	jmp	@BLBL255
	align 010h
@BLBL254:

; 1199   else
; 1200     while (DosCallNPipe(szIPCpipe,&stIPCpipe,sizeof(IPCPIPEMSG),&stIPCpipe,sizeof(IPCPIPEMSG),&ulBytesRead,10000) == ERROR_PIPE_BUSY);
	push	02710h
	push	offset FLAT:ulBytesRead
	push	0ah
	push	offset FLAT:stIPCpipe
	push	0ah
	push	offset FLAT:stIPCpipe
	push	offset FLAT:szIPCpipe
	call	DosCallNPipe
	add	esp,01ch
	cmp	eax,0e7h
	jne	@BLBL255
	align 010h
@BLBL257:
	push	02710h
	push	offset FLAT:ulBytesRead
	push	0ah
	push	offset FLAT:stIPCpipe
	push	0ah
	push	offset FLAT:stIPCpipe
	push	offset FLAT:szIPCpipe
	call	DosCallNPipe
	add	esp,01ch
	cmp	eax,0e7h
	je	@BLBL257
@BLBL255:

; 1201 
; 1202   WinPostMsg(hwndClient,UM_ENABLE_SERVER_ACCESS,0L,0l);
	push	0h
	push	0h
	push	08025h
	push	dword ptr  hwndClient
	call	WinPostMsg
	add	esp,010h

; 1203   ulIPCpipeInstance = stIPCpipe.ulInstance;
	mov	eax,dword ptr  stIPCpipe+06h
	mov	dword ptr  ulIPCpipeInstance,eax

; 1204   while (!bStopIPCserverThread)
	cmp	dword ptr  bStopIPCserverThread,0h
	jne	@BLBL259
	align 010h
@BLBL260:

; 1205     {
; 1206     DosRequestMutexSem(hmtxIPCpipeBlockedSem,10000);
	push	02710h
	push	dword ptr  hmtxIPCpipeBlockedSem
	call	DosRequestMutexSem
	add	esp,08h

; 1207     stIPCpipe.ulInstance = ulIPCpipeInstance;
	mov	eax,dword ptr  ulIPCpipeInstance
	mov	dword ptr  stIPCpipe+06h,eax

; 1208     if (ulServerMessage != 0)
	cmp	dword ptr  ulServerMessage,0h
	je	@BLBL261

; 1209       {
; 1210       stIPCpipe.ulMessage = ulServerMessage;
	mov	eax,dword ptr  ulServerMessage
	mov	dword ptr  stIPCpipe+02h,eax

; 1211       ulServerMessage = 0;
	mov	dword ptr  ulServerMessage,0h

; 1212       }
	jmp	@BLBL262
	align 010h
@BLBL261:

; 1213     else
; 1214       stIPCpipe.ulMessage = UM_PIPE_WD;
	mov	dword ptr  stIPCpipe+02h,0801ch
@BLBL262:

; 1215     while ((rc = DosCallNPipe(szIPCpipe,&stIPCpipe,sizeof(IPCPIPEMSG),&stIPCpipe,sizeof(IPCPIPEMSG),&ulBytesRead,10000)) == ERROR_PIPE_BUSY)
	push	02710h
	push	offset FLAT:ulBytesRead
	push	0ah
	push	offset FLAT:stIPCpipe
	push	0ah
	push	offset FLAT:stIPCpipe
	push	offset FLAT:szIPCpipe
	call	DosCallNPipe
	add	esp,01ch
	mov	[ebp-04h],eax;	rc
	cmp	dword ptr [ebp-04h],0e7h;	rc
	jne	@BLBL263
	align 010h
@BLBL264:

; 1216       if (chPipeDebug > '0')
	mov	al,byte ptr  chPipeDebug
	cmp	al,030h
	jbe	@BLBL265

; 1217         ErrorNotify("Pipe busy, sending watchdog message");
	push	offset FLAT:@STAT11
	call	ErrorNotify
	add	esp,04h
@BLBL265:

; 1215     while ((rc = DosCallNPipe(szIPCpipe,&stIPCpipe,sizeof(IPCPIPEMSG),&stIPCpipe,sizeof(IPCPIPEMSG),&ulBytesRead,10000)) == ERROR_PIPE_BUSY)
	push	02710h
	push	offset FLAT:ulBytesRead
	push	0ah
	push	offset FLAT:stIPCpipe
	push	0ah
	push	offset FLAT:stIPCpipe
	push	offset FLAT:szIPCpipe
	call	DosCallNPipe
	add	esp,01ch
	mov	[ebp-04h],eax;	rc
	cmp	dword ptr [ebp-04h],0e7h;	rc
	je	@BLBL264
@BLBL263:

; 1218     if (rc == ERROR_INTERRUPT)
	cmp	dword ptr [ebp-04h],05fh;	rc
	jne	@BLBL267

; 1219       bStopIPCserverThread = TRUE;
	mov	dword ptr  bStopIPCserverThread,01h
@BLBL267:

; 1220     if (!bStopIPCserverThread)
	cmp	dword ptr  bStopIPCserverThread,0h
	jne	@BLBL268

; 1221       if (rc == NO_ERROR)
	cmp	dword ptr [ebp-04h],0h;	rc
	jne	@BLBL268

; 1223         ulIPCpipeInstance = stIPCpipe.ulInstance;
	mov	eax,dword ptr  stIPCpipe+06h
	mov	dword ptr  ulIPCpipeInstance,eax

; 1224         if (stIPCpipe.ulMessage == UM_PIPE_QUIT)
	cmp	dword ptr  stIPCpipe+02h,0801eh
	jne	@BLBL270

; 1226           bAbort = TRUE;
	mov	dword ptr  bAbort,01h

; 1227           bStopIPCserverThread = TRUE;
	mov	dword ptr  bStopIPCserverThread,01h

; 1228           WinPostMsg(hwndClient,UM_PIPE_QUIT,0,0);
	push	0h
	push	0h
	push	0801eh
	push	dword ptr  hwndClient
	call	WinPostMsg
	add	esp,010h

; 1229           }
	jmp	@BLBL268
	align 010h
@BLBL270:

; 1231           if (stIPCpipe.ulMessage != UM_PIPE_ACK)
	cmp	dword ptr  stIPCpipe+02h,0801dh
	je	@BLBL268

; 1232             WinPostMsg(hwndClient,(SHORT)stIPCpipe.ulMessage,0,0);
	push	0h
	push	0h
	mov	ax,word ptr  stIPCpipe+02h
	movsx	eax,ax
	push	eax
	push	dword ptr  hwndClient
	call	WinPostMsg
	add	esp,010h

; 1233         }
@BLBL268:

; 1234     DosReleaseMutexSem(hmtxIPCpipeBlockedSem);
	push	dword ptr  hmtxIPCpipeBlockedSem
	call	DosReleaseMutexSem
	add	esp,04h

; 1235     if (!bStopIPCserverThread)
	cmp	dword ptr  bStopIPCserverThread,0h
	jne	@BLBL273

; 1236       DosSleep(2000);
	push	07d0h
	call	DosSleep
	add	esp,04h
@BLBL273:

; 1237     }

; 1204   while (!bStopIPCserverThread)
	cmp	dword ptr  bStopIPCserverThread,0h
	je	@BLBL260
@BLBL259:

; 1239   }
	mov	esp,ebp
	pop	ebp
	ret	
IPCserverThread	endp

; 1246   {
	align 010h

	public RemoteServerThread
RemoteServerThread	proc
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
	sub	esp,0ch

; 1253   ErrorNotify("Remote Server Started");
	push	offset FLAT:@STAT12
	call	ErrorNotify
	add	esp,04h

; 1254   if (DosCreateNPipe(szCOMscopePipe,&hCOMscopePipe,NPopenMode,NPpipeMode,sizeof(PIPEMSG),sizeof(PIPEMSG),NPtimeout) == NO_ERROR)
	push	07d0h
	push	0100ah
	push	0100ah
	push	08501h
	push	04002h
	push	offset FLAT:hCOMscopePipe
	push	offset FLAT:szCOMscopePipe
	call	DosCreateNPipe
	add	esp,01ch
	test	eax,eax
	jne	@BLBL282

; 1255     {
; 1256 //    DosSetPriority(PRTYS_THREAD,PRTYC_TIMECRITICAL,-10L,tidRemoteServerThread);
; 1257     DosCreateEventSem(0L,&hevCOMscopeSem,TRUE,FALSE);
	push	0h
	push	01h
	push	offset FLAT:hevCOMscopeSem
	push	0h
	call	DosCreateEventSem
	add	esp,010h

; 1258     DosSetNPipeSem(hCOMscopePipe,(HSEM)hevCOMscopeSem,0L);
	push	0h
	mov	eax,dword ptr  hevCOMscopeSem
	push	eax
	push	dword ptr  hCOMscopePipe
	call	DosSetNPipeSem
	add	esp,0ch

; 1259     stPipeCmd.cbMsgSize = sizeof(PIPECMD);
	mov	word ptr  stPipeCmd,0ah

; 1260     bStopRemotePipe = FALSE;
	mov	dword ptr  bStopRemotePipe,0h

; 1261     while (!bStopRemotePipe)
	cmp	dword ptr  bStopRemotePipe,0h
	jne	@BLBL283
	align 010h
@BLBL284:

; 1262       {
; 1263       DosConnectNPipe(hCOMscopePipe);
	push	dword ptr  hCOMscopePipe
	call	DosConnectNPipe
	add	esp,04h

; 1264       DosResetEventSem(hevCOMscopeSem,&ulPostCount);
	lea	eax,[ebp-04h];	ulPostCount
	push	eax
	push	dword ptr  hevCOMscopeSem
	call	DosResetEventSem
	add	esp,08h

; 1265       DosWaitEventSem(hevCOMscopeSem,-1);
	push	0ffffffffh
	push	dword ptr  hevCOMscopeSem
	call	DosWaitEventSem
	add	esp,08h

; 1266       DosRead(hCOMscopePipe,&stPipeMsg,sizeof(PIPEMSG),&ulBytesRead);
	lea	eax,[ebp-0ch];	ulBytesRead
	push	eax
	push	0100ah
	push	offset FLAT:stPipeMsg
	push	dword ptr  hCOMscopePipe
	call	DosRead
	add	esp,010h

; 1267       switch (stPipeMsg.ulCommand)
	mov	eax,dword ptr  stPipeMsg+02h
	jmp	@BLBL290
	align 04h
@BLBL291:

; 1268         {
; 1269         case UM_PIPE_END:
; 1270           ErrorNotify("Session Close message received - Closing this session");
	push	offset FLAT:@STAT13
	call	ErrorNotify
	add	esp,04h

; 1271           stPipeCmd.ulCommand = UM_PIPE_ACK;
	mov	dword ptr  stPipeCmd+02h,0801dh

; 1272           stPipeMsg.cbMsgSize = sizeof(PIPEMSG);
	mov	word ptr  stPipeMsg,0100ah

; 1273           DosWrite(hCOMscopePipe,&stPipeCmd,sizeof(PIPECMD),&ulBytesWritten);
	lea	eax,[ebp-08h];	ulBytesWritten
	push	eax
	push	0ah
	push	offset FLAT:stPipeCmd
	push	dword ptr  hCOMscopePipe
	call	DosWrite
	add	esp,010h

; 1274           DosSleep(2000);
	push	07d0h
	call	DosSleep
	add	esp,04h

; 1275           WinPostMsg(hwndClient,UM_PIPE_QUIT,0,0);
	push	0h
	push	0h
	push	0801eh
	push	dword ptr  hwndClient
	call	WinPostMsg
	add	esp,010h

; 1276           bStopRemotePipe = TRUE;
	mov	dword ptr  bStopRemotePipe,01h

; 1277           break;
	jmp	@BLBL289
	align 04h
@BLBL292:

; 1278 #ifdef this_junk
; 1279         case UM_REM_DEVICE_LIST:
; 1280 //          DestroyList(&pstDeviceList);
; 1281 //          pstDeviceList = InitializeList(pstDeviceList);
; 1282 //          if (FillDeviceNameList(pstDeviceList,&stDeviceCount))
; 1283 //            stPipeMsg.ulCommand = UM_PIPE_ACK;
; 1284 //          else
; 1285 //            stPipeMsg.ulCommand = UM_PIPE_NAK;
; 1286           ulCount = 10;
; 1287           if (stDeviceCount.wDCBnumber > 1)
; 1288             {
; 1289             stPipeMsg.Data.wData = stDeviceCount.wDCBnumber;
; 1290             pbyData = &stPipeMsg.Data.abyData[2];
; 1291             pListItem = pstDeviceList;
; 1292             for (wIndex = 0;wIndex < stDeviceCount.wDCBnumber;wIndex++)
; 1293               {
; 1294               strncpy(pstData,pListItem->pData,8);
; 1295               pListItem = pListItem->pTail;
; 1296               pbyData += 8;
; 1297               ulCount += 8;
; 1298               }
; 1299             }
; 1300           else
; 1301             stPipeMsg.Data.wData = 0;
; 1302           DosWrite(hCOMscopePipe,&stPipeMsg,ulCount,&ulBytesWritten);
; 1303           ErrorNotify("Device list received");
; 1304           break;
; 1305 #endif
; 1306         default:
; 1307           if (stPipeMsg.cbDataSize != 0)
	cmp	dword ptr  stPipeMsg+06h,0h
	je	@BLBL285

; 1308             {
; 1309             pstData = malloc(stPipeMsg.cbDataSize + 2);
	mov	ecx,051dh
	mov	edx,offset FLAT:@STAT14
	mov	eax,dword ptr  stPipeMsg+06h
	add	eax,02h
	call	_debug_malloc
	mov	[ebp-010h],eax;	pstData

; 1310             memcpy(pstData,&stPipeMsg.Data.abyData,stPipeMsg.cbDataSize);
	mov	ecx,dword ptr  stPipeMsg+06h
	mov	edx,offset FLAT:stPipeMsg+0ah
	mov	eax,[ebp-010h];	pstData
	call	memcpy

; 1311             WinPostMsg(hwndClient,stPipeMsg.ulCommand,(MPARAM)stPipeMsg.cbDataSize,pstData);
	push	dword ptr [ebp-010h];	pstData
	mov	eax,dword ptr  stPipeMsg+06h
	push	eax
	push	dword ptr  stPipeMsg+02h
	push	dword ptr  hwndClient
	call	WinPostMsg
	add	esp,010h

; 1312             }
	jmp	@BLBL286
	align 010h
@BLBL285:

; 1313           else
; 1314             WinPostMsg(hwndClient,stPipeMsg.ulCommand,0,0);
	push	0h
	push	0h
	push	dword ptr  stPipeMsg+02h
	push	dword ptr  hwndClient
	call	WinPostMsg
	add	esp,010h
@BLBL286:

; 1315           stPipeCmd.ulCommand = UM_PIPE_ACK;
	mov	dword ptr  stPipeCmd+02h,0801dh

; 1316           stPipeMsg.cbMsgSize = sizeof(PIPEMSG);
	mov	word ptr  stPipeMsg,0100ah

; 1317           DosWrite(hCOMscopePipe,&stPipeCmd,sizeof(PIPECMD),&ulBytesWritten);
	lea	eax,[ebp-08h];	ulBytesWritten
	push	eax
	push	0ah
	push	offset FLAT:stPipeCmd
	push	dword ptr  hCOMscopePipe
	call	DosWrite
	add	esp,010h

; 1318           break;
	jmp	@BLBL289
	align 04h
	jmp	@BLBL289
	align 04h
@BLBL290:
	cmp	eax,08020h
	je	@BLBL291
	jmp	@BLBL292
	align 04h
@BLBL289:

; 1319         }
; 1320       DosDisConnectNPipe(hCOMscopePipe);
	push	dword ptr  hCOMscopePipe
	call	DosDisConnectNPipe
	add	esp,04h

; 1321       }

; 1261     while (!bStopRemotePipe)
	cmp	dword ptr  bStopRemotePipe,0h
	je	@BLBL284
@BLBL283:

; 1322     DosDisConnectNPipe(hCOMscopePipe);
	push	dword ptr  hCOMscopePipe
	call	DosDisConnectNPipe
	add	esp,04h

; 1323     DosClose(hCOMscopePipe);
	push	dword ptr  hCOMscopePipe
	call	DosClose
	add	esp,04h

; 1324     DosCloseEventSem(hevCOMscopeSem);
	push	dword ptr  hevCOMscopeSem
	call	DosCloseEventSem
	add	esp,04h

; 1325     }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL282:

; 1327     ErrorNotify("Unable to create remote named pipe\n");
	push	offset FLAT:@STAT15
	call	ErrorNotify
	add	esp,04h

; 1328   }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
RemoteServerThread	endp
CODE32	ends
end
