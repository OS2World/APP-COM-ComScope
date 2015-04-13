	title	p:\utility\cfg_sys.C
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
	extrn	DosOpen:proc
	extrn	_sprintfieee:proc
	extrn	MessageBox:proc
	extrn	DosQueryFileInfo:proc
	extrn	DosAllocMem:proc
	extrn	DosRead:proc
	extrn	DosFreeMem:proc
	extrn	DosClose:proc
	extrn	strlen:proc
	extrn	strnicmp:proc
	extrn	DosQuerySysInfo:proc
	extrn	WinMessageBox:proc
	extrn	memcpy:proc
	extrn	strcpy:proc
	extrn	DosCopy:proc
	extrn	DosSetFileSize:proc
	extrn	DosWrite:proc
	extrn	_fullDump:dword
	extrn	_ctype:dword
DATA32	segment
@STAT1	db "Zero",0h
	align 04h
@STAT2	db "One",0h
@STAT3	db "Two",0h
@STAT4	db "Three",0h
	align 04h
@STAT5	db "Four",0h
	align 04h
@STAT6	db "Five",0h
	align 04h
@STAT7	db "Six",0h
@STAT8	db "Seven",0h
	align 04h
@STAT9	db "Eight",0h
	align 04h
@STATa	db "Nine",0h
	align 04h
@STATb	db "Ten",0h
@STATc	db "Eleven",0h
	align 04h
@STATd	db "Twelve",0h
	align 04h
@STATe	db "Thirteen",0h
	align 04h
@STATf	db "Fourteen",0h
	align 04h
@STAT10	db "Fifteen",0h
@STAT11	db "Sixteen",0h
@STAT12	db "zero",0h
	align 04h
@STAT13	db "one",0h
@STAT14	db "two",0h
@STAT15	db "three",0h
	align 04h
@STAT16	db "four",0h
	align 04h
@STAT17	db "five",0h
	align 04h
@STAT18	db "six",0h
@STAT19	db "seven",0h
	align 04h
@STAT1a	db "eight",0h
	align 04h
@STAT1b	db "nine",0h
	align 04h
@STAT1c	db "ten",0h
@STAT1d	db "eleven",0h
	align 04h
@STAT1e	db "twelve",0h
	align 04h
@STAT1f	db "thirteen",0h
	align 04h
@STAT20	db "fourteen",0h
	align 04h
@STAT21	db "fifteen",0h
@STAT22	db "sixteen",0h
@STAT23	db "Could not open %s - Erro"
db "r = %u",0h
	align 04h
@STAT24	db "Unable to Allocate memor"
db "y to read %s - %u",0h
	align 04h
@STAT25	db "REM ",0h
	align 04h
@STAT26	db "C:\CONFIG.SYS",0h
	align 04h
@STAT27	db "DEVICE=%s.SYS",0h
	align 04h
@STAT28	db "Unable to open system co"
db "nfiguration File",0h
	align 04h
@STAT29	db "You will need to add or "
db "remove %s statement(s) f"
db "rom your CONFIG.SYS file"
db " to complete this config"
db "uration.",0h
	align 04h
@STAT2a	db "Unable to allocate memor"
db "y to adjust system confi"
db "guration file",0h
	align 04h
@STAT2b	db "You will need to add or "
db "remove %s statement(s) f"
db "rom your CONFIG.SYS file"
db " to complete this config"
db "uration.",0h
	align 04h
@STAT2c	db "System configuration fil"
db "e needs to be updated",0h
	align 04h
@STAT2d	db "%s device driver load st"
db "atements need to be remo"
db "ved from your CONFIG.SYS"
db " file.",0ah,0ah,"OK to make chang"
db "es?",0h
@STAT2e	db "One device driver load s"
db "tatement needs to be rem"
db "oved from your CONFIG.SY"
db "S file.",0ah,0ah,"OK to make chan"
db "ges?",0h
	align 04h
@STAT2f	db "You will need to remove "
db "%s %s statements from yo"
db "ur CONFIG.SYS file to co"
db "mplete this configuratio"
db "n.",0h
	align 04h
@STAT30	db "You will need to remove "
db "one %s statement from yo"
db "ur CONFIG.SYS file to co"
db "mplete this configuratio"
db "n.",0h
	align 04h
@STAT31	db "%s COMi load statements "
db "need to be added to your"
db " CONFIG.SYS file.",0ah,0ah,"OK to"
db " make changes?",0h
	align 04h
@STAT32	db "One COMi load statement "
db "needs to be added to you"
db "r CONFIG.SYS file.",0ah,0ah,"OK t"
db "o make changes?",0h
@STAT33	db "You will need to add %s "
db "%s statement lines to yo"
db "ur CONFIG.SYS file to co"
db "mplete this configuratio"
db "n.",0h
	align 04h
@STAT34	db "You will need to add one"
db " %s statement to your CO"
db "NFIG.SYS file to complet"
db "e this configuration.",0h
	align 04h
@STAT35	db "%s",0dh,0ah,0h
	align 04h
@STAT36	db "001",0h
@STAT37	db "%03X",0h
	align 04h
@STAT38	db "%s was not updated!  Cou"
db "ld not make backup",0h
	align 04h
@STAT39	db "The current system confi"
db "guration file, %s, was r"
db "enamed to %s",0h
	align 04h
@STAT3a	db "System configuration fil"
db "e was backed up.",0h
	align 04h
@STAT3b	db "%s was not updated!  Cou"
db "ld not reopen - Error = "
db "%u",0h
	align 04h
@STAT3c	db "C:\CONFIG.SYS",0h
	align 04h
@STAT3d	db "Unable to Open System Co"
db "nfiguration File",0h
	align 04h
@STAT3e	db "You will need to remove "
db "all DEVICE=%s.SYS statem"
db "ent(s) from your CONFIG."
db "SYS file to complete thi"
db "s process.",0h
	align 04h
@STAT3f	db "System configuration fil"
db "e needs to be updated",0h
	align 04h
@STAT40	db "All DEVICE=%s.SYS statem"
db "ents from a previous dev"
db "ice driver version need "
db "to be removed from your "
db "CONFIG.SYS file.",0ah,0ah,"OK to "
db "make changes?",0h
	align 04h
@STAT41	db "You will need to remove "
db "all DEVICE=%s.SYS statem"
db "ents from your CONFIG.SY"
db "S file to complete this "
db "configuration.",0h
	align 04h
@2aszCapOrdinals	dd offset FLAT:@STAT1
	dd offset FLAT:@STAT2
	dd offset FLAT:@STAT3
	dd offset FLAT:@STAT4
	dd offset FLAT:@STAT5
	dd offset FLAT:@STAT6
	dd offset FLAT:@STAT7
	dd offset FLAT:@STAT8
	dd offset FLAT:@STAT9
	dd offset FLAT:@STATa
	dd offset FLAT:@STATb
	dd offset FLAT:@STATc
	dd offset FLAT:@STATd
	dd offset FLAT:@STATe
	dd offset FLAT:@STATf
	dd offset FLAT:@STAT10
	dd offset FLAT:@STAT11
@4aszOrdinals	dd offset FLAT:@STAT12
	dd offset FLAT:@STAT13
	dd offset FLAT:@STAT14
	dd offset FLAT:@STAT15
	dd offset FLAT:@STAT16
	dd offset FLAT:@STAT17
	dd offset FLAT:@STAT18
	dd offset FLAT:@STAT19
	dd offset FLAT:@STAT1a
	dd offset FLAT:@STAT1b
	dd offset FLAT:@STAT1c
	dd offset FLAT:@STAT1d
	dd offset FLAT:@STAT1e
	dd offset FLAT:@STAT1f
	dd offset FLAT:@STAT20
	dd offset FLAT:@STAT21
	dd offset FLAT:@STAT22
	dd	_dllentry
DATA32	ends
CODE32	segment

; 9   {
	align 010h

	public ReadConfigFile
ReadConfigFile	proc
	push	ebp
	mov	ebp,esp
	sub	esp,012ch
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,04bh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 17   if ((rc = DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0022,(PEAOP2)0L)) != 0)
	push	0h
	push	022h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-04h];	ulStatus
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	push	dword ptr [ebp+0ch];	szFileSpec
	call	DosOpen
	add	esp,020h
	mov	[ebp-012ch],eax;	rc
	cmp	dword ptr [ebp-012ch],0h;	rc
	je	@BLBL1

; 18     {
; 19     if (hwnd != NULLHANDLE)
	cmp	dword ptr [ebp+08h],0h;	hwnd
	je	@BLBL2

; 20       {
; 21       sprintf(szMessage,"Could not open %s - Error = %u",szFileSpec,rc);
	push	dword ptr [ebp-012ch];	rc
	push	dword ptr [ebp+0ch];	szFileSpec
	mov	edx,offset FLAT:@STAT23
	lea	eax,[ebp-0128h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 22       MessageBox(HWND_DESKTOP,szMessage);
	lea	eax,[ebp-0128h];	szMessage
	push	eax
	push	01h
	call	MessageBox
	add	esp,08h

; 23       }
@BLBL2:

; 24     return(0);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL1:

; 25     }
; 26   DosQueryFileInfo(hFile,1,&stFileInfo,sizeof(FILESTATUS3));
	push	018h
	lea	eax,[ebp-020h];	stFileInfo
	push	eax
	push	01h
	push	dword ptr [ebp-08h];	hFile
	call	DosQueryFileInfo
	add	esp,010h

; 27   iCount = stFileInfo.cbFile;
	mov	eax,[ebp-014h];	stFileInfo
	mov	[ebp-024h],eax;	iCount

; 28   if ((rc = DosAllocMem((PVOID)ppBuffer,(iCount + 10),(PAG_COMMIT | PAG_READ | PAG_WRITE))) != NO_ERROR)
	push	013h
	mov	eax,[ebp-024h];	iCount
	add	eax,0ah
	push	eax
	push	dword ptr [ebp+010h];	ppBuffer
	call	DosAllocMem
	add	esp,0ch
	mov	[ebp-012ch],eax;	rc
	cmp	dword ptr [ebp-012ch],0h;	rc
	je	@BLBL3

; 29     {
; 30     if (hwnd != NULLHANDLE)
	cmp	dword ptr [ebp+08h],0h;	hwnd
	je	@BLBL4

; 31       {
; 32       sprintf(szMessage,"Unable to Allocate memory to read %s - %u",szFileSpec,rc);
	push	dword ptr [ebp-012ch];	rc
	push	dword ptr [ebp+0ch];	szFileSpec
	mov	edx,offset FLAT:@STAT24
	lea	eax,[ebp-0128h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 33       MessageBox(HWND_DESKTOP,szMessage);
	lea	eax,[ebp-0128h];	szMessage
	push	eax
	push	01h
	call	MessageBox
	add	esp,08h

; 34       }
@BLBL4:

; 35     iCount = 0;
	mov	dword ptr [ebp-024h],0h;	iCount

; 36     }
@BLBL3:

; 37   if (DosRead(hFile,(PVOID)*ppBuffer,iCount,(ULONG *)&iCount) != 0)
	lea	eax,[ebp-024h];	iCount
	push	eax
	mov	eax,[ebp-024h];	iCount
	push	eax
	mov	eax,[ebp+010h];	ppBuffer
	push	dword ptr [eax]
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	je	@BLBL5

; 38     {
; 39     DosFreeMem(*ppBuffer);
	mov	eax,[ebp+010h];	ppBuffer
	push	dword ptr [eax]
	call	DosFreeMem
	add	esp,04h

; 40     iCount = 0;
	mov	dword ptr [ebp-024h],0h;	iCount

; 41     }
	jmp	@BLBL6
	align 010h
@BLBL5:

; 42   else
; 43     {
; 44     /*
; 45     ** ignore/remove EOF character, if present
; 46     */
; 47     if ((*ppBuffer)[(iCount) - 1] == '\x1a')
	mov	eax,[ebp+010h];	ppBuffer
	mov	eax,[eax]
	mov	ecx,[ebp-024h];	iCount
	cmp	byte ptr [eax+ecx-01h],01ah
	jne	@BLBL7

; 48       iCount--;
	mov	eax,[ebp-024h];	iCount
	dec	eax
	mov	[ebp-024h],eax;	iCount
@BLBL7:

; 49     /*
; 50     **  Add LF and CR to end of file, if not already there
; 51     */
; 52     if ((*ppBuffer)[iCount - 1] != '\x0a')
	mov	eax,[ebp+010h];	ppBuffer
	mov	eax,[eax]
	mov	ecx,[ebp-024h];	iCount
	cmp	byte ptr [eax+ecx-01h],0ah
	je	@BLBL6

; 53       {
; 54       (*ppBuffer)[(iCount)++] = '\x0d';
	mov	eax,[ebp+010h];	ppBuffer
	mov	eax,[eax]
	mov	ecx,[ebp-024h];	iCount
	mov	byte ptr [eax+ecx],0dh
	mov	eax,[ebp-024h];	iCount
	inc	eax
	mov	[ebp-024h],eax;	iCount

; 55       (*ppBuffer)[(iCount)++] = '\x0a';
	mov	eax,[ebp+010h];	ppBuffer
	mov	eax,[eax]
	mov	ecx,[ebp-024h];	iCount
	mov	byte ptr [eax+ecx],0ah
	mov	eax,[ebp-024h];	iCount
	inc	eax
	mov	[ebp-024h],eax;	iCount

; 56       }

; 57     }
@BLBL6:

; 58   DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 59   return(iCount);
	mov	eax,[ebp-024h];	iCount
	mov	esp,ebp
	pop	ebp
	ret	
ReadConfigFile	endp

; 85   {
	align 010h

	public FindLineWith
FindLineWith	proc
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

; 89   BOOL bDone = FALSE;
	mov	dword ptr [ebp-010h],0h;	bDone

; 90   ULONG ulLen;
; 91   char *pchLine;
; 92   BOOL bSkipLeadingWhiteSpace;
; 93 
; 94   if (DosAllocMem((PVOID)&pchLine,4096,(PAG_COMMIT | PAG_READ | PAG_WRITE)) != NO_ERROR)
	push	013h
	push	01000h
	lea	eax,[ebp-018h];	pchLine
	push	eax
	call	DosAllocMem
	add	esp,0ch
	test	eax,eax
	je	@BLBL9

; 95     return(-1);
	or	eax,0ffffffffh
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL9:

; 96   chChar = szThisString[0];
	mov	eax,[ebp+08h];	szThisString
	mov	al,[eax]
	mov	[ebp-09h],al;	chChar

; 97   if ((chChar == ' ') || (chChar == '\t'))
	cmp	byte ptr [ebp-09h],020h;	chChar
	je	@BLBL10
	cmp	byte ptr [ebp-09h],09h;	chChar
	jne	@BLBL11
@BLBL10:

; 98     bSkipLeadingWhiteSpace = FALSE;
	mov	dword ptr [ebp-01ch],0h;	bSkipLeadingWhiteSpace
	jmp	@BLBL12
	align 010h
@BLBL11:

; 99   else
; 100     bSkipLeadingWhiteSpace = TRUE;
	mov	dword ptr [ebp-01ch],01h;	bSkipLeadingWhiteSpace
@BLBL12:

; 101   while (!bDone)
	cmp	dword ptr [ebp-010h],0h;	bDone
	jne	@BLBL13
	align 010h
@BLBL14:

; 102     {
; 103     ulCount = 0;
	mov	dword ptr [ebp-04h],0h;	ulCount

; 104     ulIndex = iOffset;
	mov	eax,[ebp+010h];	iOffset
	mov	[ebp-08h],eax;	ulIndex

; 105     chChar = pszBuffer[ulIndex++];
	mov	eax,[ebp+0ch];	pszBuffer
	mov	ecx,[ebp-08h];	ulIndex
	mov	al,byte ptr [eax+ecx]
	mov	[ebp-09h],al;	chChar
	mov	eax,[ebp-08h];	ulIndex
	inc	eax
	mov	[ebp-08h],eax;	ulIndex

; 106     while((chChar == ' ') || (chChar  == '\t'))
	cmp	byte ptr [ebp-09h],020h;	chChar
	je	@BLBL19
	cmp	byte ptr [ebp-09h],09h;	chChar
	jne	@BLBL18
	align 010h
@BLBL19:

; 107       {
; 108       if (!bSkipLeadingWhiteSpace)
	cmp	dword ptr [ebp-01ch],0h;	bSkipLeadingWhiteSpace
	jne	@BLBL20

; 109         pchLine[ulCount++] = chChar;
	mov	eax,[ebp-018h];	pchLine
	mov	ecx,[ebp-04h];	ulCount
	mov	dl,[ebp-09h];	chChar
	mov	byte ptr [eax+ecx],dl
	mov	eax,[ebp-04h];	ulCount
	inc	eax
	mov	[ebp-04h],eax;	ulCount
@BLBL20:

; 110       chChar = pszBuffer[ulIndex++];
	mov	eax,[ebp+0ch];	pszBuffer
	mov	ecx,[ebp-08h];	ulIndex
	mov	al,byte ptr [eax+ecx]
	mov	[ebp-09h],al;	chChar
	mov	eax,[ebp-08h];	ulIndex
	inc	eax
	mov	[ebp-08h],eax;	ulIndex

; 111       }

; 106     while((chChar == ' ') || (chChar  == '\t'))
	cmp	byte ptr [ebp-09h],020h;	chChar
	je	@BLBL19
	cmp	byte ptr [ebp-09h],09h;	chChar
	je	@BLBL19
@BLBL18:

; 112     while (chChar != 0)
	cmp	byte ptr [ebp-09h],0h;	chChar
	je	@BLBL24
	align 010h
@BLBL25:

; 114       pchLine[ulCount++] = toupper(chChar);
	mov	edx,dword ptr  _ctype
	xor	eax,eax
	mov	al,[ebp-09h];	chChar
	mov	dx,word ptr [edx+eax*02h+0202h]
	mov	eax,[ebp-018h];	pchLine
	mov	ecx,[ebp-04h];	ulCount
	mov	byte ptr [eax+ecx],dl
	mov	eax,[ebp-04h];	ulCount
	inc	eax
	mov	[ebp-04h],eax;	ulCount

; 115       if (chChar == '\x0a')
	cmp	byte ptr [ebp-09h],0ah;	chChar
	je	@BLBL24

; 117       chChar = pszBuffer[ulIndex++];
	mov	eax,[ebp+0ch];	pszBuffer
	mov	ecx,[ebp-08h];	ulIndex
	mov	al,byte ptr [eax+ecx]
	mov	[ebp-09h],al;	chChar
	mov	eax,[ebp-08h];	ulIndex
	inc	eax
	mov	[ebp-08h],eax;	ulIndex

; 118       }

; 112     while (chChar != 0)
	cmp	byte ptr [ebp-09h],0h;	chChar
	jne	@BLBL25
@BLBL24:

; 119     if (chChar == 0)
	cmp	byte ptr [ebp-09h],0h;	chChar
	jne	@BLBL28

; 121       DosFreeMem(pchLine);
	push	dword ptr [ebp-018h];	pchLine
	call	DosFreeMem
	add	esp,04h

; 122       return(-1);
	or	eax,0ffffffffh
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL28:

; 124     ulLen = strlen(szThisString);
	mov	eax,[ebp+08h];	szThisString
	call	strlen
	mov	[ebp-014h],eax;	ulLen

; 126     *piLength = ulCount;
	mov	ecx,[ebp-04h];	ulCount
	mov	eax,[ebp+014h];	piLength
	mov	[eax],ecx

; 127     if (ulLen <= ulCount)
	mov	eax,[ebp-04h];	ulCount
	cmp	[ebp-014h],eax;	ulLen
	ja	@BLBL29

; 129       if (!bSkipLeadingWhiteSpace)
	cmp	dword ptr [ebp-01ch],0h;	bSkipLeadingWhiteSpace
	jne	@BLBL30

; 131         for (ulIndex = 0;ulIndex < 10;ulIndex++)
	mov	dword ptr [ebp-08h],0h;	ulIndex
	cmp	dword ptr [ebp-08h],0ah;	ulIndex
	jae	@BLBL35
	align 010h
@BLBL32:

; 133           chChar = pchLine[ulIndex];
	mov	eax,[ebp-018h];	pchLine
	mov	ecx,[ebp-08h];	ulIndex
	mov	al,byte ptr [eax+ecx]
	mov	[ebp-09h],al;	chChar

; 134           if ((chChar != ' ') && (chChar != '\t'))
	cmp	byte ptr [ebp-09h],020h;	chChar
	je	@BLBL33
	cmp	byte ptr [ebp-09h],09h;	chChar
	jne	@BLBL35

; 135             break;
@BLBL33:

; 136           }

; 131         for (ulIndex = 0;ulIndex < 10;ulIndex++)
	mov	eax,[ebp-08h];	ulIndex
	inc	eax
	mov	[ebp-08h],eax;	ulIndex
	cmp	dword ptr [ebp-08h],0ah;	ulIndex
	jb	@BLBL32

; 137         }
	jmp	@BLBL35
	align 010h
@BLBL30:

; 139         ulIndex = 0;
	mov	dword ptr [ebp-08h],0h;	ulIndex
@BLBL35:

; 140       if (strnicmp("REM ",&pchLine[ulIndex],4) != 0)
	mov	ecx,04h
	mov	edx,[ebp-018h];	pchLine
	mov	eax,[ebp-08h];	ulIndex
	add	edx,eax
	mov	eax,offset FLAT:@STAT25
	call	strnicmp
	test	eax,eax
	je	@BLBL29

; 142         if (bFromBeginingOnly)
	cmp	dword ptr [ebp+018h],0h;	bFromBeginingOnly
	je	@BLBL37

; 143           ulCount = 0;
	mov	dword ptr [ebp-04h],0h;	ulCount
	jmp	@BLBL38
	align 010h
@BLBL37:

; 145           ulCount = (ulCount - ulLen);
	mov	eax,[ebp-04h];	ulCount
	sub	eax,[ebp-014h];	ulLen
	mov	[ebp-04h],eax;	ulCount
@BLBL38:

; 146         chChar = toupper(szThisString[0]);
	mov	eax,dword ptr  _ctype
	mov	edx,[ebp+08h];	szThisString
	xor	ecx,ecx
	mov	cl,[edx]
	mov	ax,word ptr [eax+ecx*02h+0202h]
	mov	[ebp-09h],al;	chChar

; 147         for (ulIndex = 0;ulIndex <= ulCount;ulIndex++)
	mov	dword ptr [ebp-08h],0h;	ulIndex
	mov	eax,[ebp-04h];	ulCount
	cmp	[ebp-08h],eax;	ulIndex
	ja	@BLBL29
	align 010h
@BLBL40:

; 149           if (pchLine[ulIndex] == chChar)
	mov	eax,[ebp-018h];	pchLine
	mov	ecx,[ebp-08h];	ulIndex
	mov	dl,[ebp-09h];	chChar
	cmp	byte ptr [eax+ecx],dl
	jne	@BLBL41

; 151             if (strnicmp(szThisString,&pchLine[ulIndex],ulLen) == 0)
	mov	ecx,[ebp-014h];	ulLen
	mov	edx,[ebp-018h];	pchLine
	mov	eax,[ebp-08h];	ulIndex
	add	edx,eax
	mov	eax,[ebp+08h];	szThisString
	call	strnicmp
	test	eax,eax
	jne	@BLBL41

; 153               DosFreeMem(pchLine);
	push	dword ptr [ebp-018h];	pchLine
	call	DosFreeMem
	add	esp,04h

; 154               return(iOffset);
	mov	eax,[ebp+010h];	iOffset
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL41:

; 157           }

; 147         for (ulIndex = 0;ulIndex <= ulCount;ulIndex++)
	mov	eax,[ebp-08h];	ulIndex
	inc	eax
	mov	[ebp-08h],eax;	ulIndex
	mov	eax,[ebp-04h];	ulCount
	cmp	[ebp-08h],eax;	ulIndex
	jbe	@BLBL40

; 158         }

; 159       }
@BLBL29:

; 160     iOffset += *piLength;
	mov	ecx,[ebp+014h];	piLength
	mov	eax,[ebp+010h];	iOffset
	add	eax,[ecx]
	mov	[ebp+010h],eax;	iOffset

; 161     }

; 101   while (!bDone)
	cmp	dword ptr [ebp-010h],0h;	bDone
	je	@BLBL14
@BLBL13:

; 162   DosFreeMem(pchLine);
	push	dword ptr [ebp-018h];	pchLine
	call	DosFreeMem
	add	esp,04h

; 163   return(-1);
	or	eax,0ffffffffh
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
FindLineWith	endp

; 167   {
	align 010h

	public AdjustConfigSys
AdjustConfigSys	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0210h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,084h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	push	ebx

; 171   char szFileSpec[CCHMAXPATH] = "C:\\CONFIG.SYS";
	lea	eax,[ebp-020dh];	szFileSpec
	mov	eax,eax
	mov	edx,offset FLAT:@STAT26
	mov	ecx,[edx]
	mov	ebx,[edx+04h]
	mov	[eax],ecx
	mov	[eax+04h],ebx
	mov	ebx,[edx+08h]
	mov	[eax+08h],ebx
	mov	cx,[edx+0ch]
	mov	[eax+0ch],cx
	xor	eax,eax
	mov	ebx,01ch
@BLBL46:
	mov	dword ptr [ebp+ebx*08h-01ffh],eax
	mov	dword ptr [ebp+ebx*08h-01fbh],eax
	mov	dword ptr [ebp+ebx*08h-01f7h],eax
	mov	dword ptr [ebp+ebx*08h-01f3h],eax
	sub	ebx,02h
	jge	@BLBL46
	mov	[ebp-010fh],eax;	szFileSpec
	mov	[ebp-010bh],ax;	szFileSpec
	lea	eax,[ebp-01ffh];	szFileSpec

; 172 
; 173   if (DosQuerySysInfo(QSV_BOOT_DRIVE,QSV_BOOT_DRIVE,&iCount,4L) == 0)
	push	04h
	lea	eax,[ebp-04h];	iCount
	push	eax
	push	05h
	push	05h
	call	DosQuerySysInfo
	add	esp,010h
	test	eax,eax
	jne	@BLBL45

; 174     szFileSpec[0] = ('A' + ((BYTE)iCount - 1));
	mov	al,[ebp-04h];	iCount
	add	al,040h
	mov	[ebp-020dh],al;	szFileSpec
@BLBL45:

; 175   sprintf(szDeviceStatement,"DEVICE=%s.SYS",szDDspec);
	push	dword ptr [ebp+0ch];	szDDspec
	mov	edx,offset FLAT:@STAT27
	lea	eax,[ebp-0109h];	szDeviceStatement
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 176   return(AdjustConfigFile(hwnd, szFileSpec, szDeviceStatement, iLoadCount, bMakeChanges, usHelpID));
	mov	ax,[ebp+018h];	usHelpID
	push	eax
	push	dword ptr [ebp+014h];	bMakeChanges
	push	dword ptr [ebp+010h];	iLoadCount
	lea	eax,[ebp-0109h];	szDeviceStatement
	push	eax
	lea	eax,[ebp-020dh];	szFileSpec
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	AdjustConfigFile
	add	esp,018h
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
AdjustConfigSys	endp

; 180   {
	align 010h

	public AdjustConfigFile
AdjustConfigFile	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0200h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,080h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	push	ebx
	sub	esp,0ch

; 187   int iDDcount = 0;
	mov	dword ptr [ebp-01ch],0h;	iDDcount

; 188   int iLength;
; 189   int iFirstOffset = 0;
	mov	dword ptr [ebp-024h],0h;	iFirstOffset

; 190   int iLastOffset = 0;
	mov	dword ptr [ebp-028h],0h;	iLastOffset

; 191   char szCaption[80];
; 192   char szMessage[120];
; 193   int iLen;
; 194   ULONG ulFilePosition;
; 195   char szDeviceStatement[CCHMAXPATH];
; 196   ULONG flStyle;
; 197 
; 198   if ((iCount = ReadConfigFile(hwnd, szFileSpec,&pchFile)) == 0)
	lea	eax,[ebp-0ch];	pchFile
	push	eax
	push	dword ptr [ebp+0ch];	szFileSpec
	push	dword ptr [ebp+08h];	hwnd
	call	ReadConfigFile
	add	esp,0ch
	mov	[ebp-04h],eax;	iCount
	cmp	dword ptr [ebp-04h],0h;	iCount
	jne	@BLBL47

; 199     {
; 200     if (hwnd != NULLHANDLE)
	cmp	dword ptr [ebp+08h],0h;	hwnd
	je	@BLBL48

; 201       {
; 202       sprintf(szCaption,"Unable to open system configuration File");
	mov	edx,offset FLAT:@STAT28
	lea	eax,[ebp-078h];	szCaption
	call	_sprintfieee

; 203       sprintf(szMessage,"You will need to add or remove %s statement(s) from your CONFIG.SYS file to complete this configuration.",szConfigLine);
	push	dword ptr [ebp+010h];	szConfigLine
	mov	edx,offset FLAT:@STAT29
	lea	eax,[ebp-0f0h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 204       flStyle =  (MB_MOVEABLE | MB_OK | MB_ICONHAND);
	mov	dword ptr [ebp-0200h],04040h;	flStyle

; 205       if (usHelpID != 0)
	cmp	word ptr [ebp+01ch],0h;	usHelpID
	je	@BLBL49

; 206         flStyle |= MB_HELP;
	mov	eax,[ebp-0200h];	flStyle
	or	ah,020h
	mov	[ebp-0200h],eax;	flStyle
@BLBL49:

; 207       WinMessageBox(HWND_DESKTOP,
	push	dword ptr [ebp-0200h];	flStyle
	xor	eax,eax
	mov	ax,[ebp+01ch];	usHelpID
	inc	eax
	push	eax
	lea	eax,[ebp-078h];	szCaption
	push	eax
	lea	eax,[ebp-0f0h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h

; 208                     hwnd,
; 209                     szMessage,
; 210                     szCaption,
; 211                    (usHelpID + 1),
; 212                     flStyle);
; 213       }
@BLBL48:

; 214 //    DosFreeMem(pchLines);
; 215     return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL47:

; 216     }
; 217   if (DosAllocMem((PVOID)&pchLines,(iCount * 2),(PAG_COMMIT | PAG_READ | PAG_WRITE)) != NO_ERROR)
	push	013h
	mov	eax,[ebp-04h];	iCount
	add	eax,eax
	push	eax
	lea	eax,[ebp-010h];	pchLines
	push	eax
	call	DosAllocMem
	add	esp,0ch
	test	eax,eax
	je	@BLBL50

; 218     {
; 219     if (hwnd != NULLHANDLE)
	cmp	dword ptr [ebp+08h],0h;	hwnd
	je	@BLBL51

; 220       {
; 221       sprintf(szCaption,"Unable to allocate memory to adjust system configuration file");
	mov	edx,offset FLAT:@STAT2a
	lea	eax,[ebp-078h];	szCaption
	call	_sprintfieee

; 222       sprintf(szMessage,"You will need to add or remove %s statement(s) from your CONFIG.SYS file to complete this configuration.",szConfigLine);
	push	dword ptr [ebp+010h];	szConfigLine
	mov	edx,offset FLAT:@STAT2b
	lea	eax,[ebp-0f0h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 223       flStyle =  (MB_MOVEABLE | MB_OK | MB_ICONHAND);
	mov	dword ptr [ebp-0200h],04040h;	flStyle

; 224       if (usHelpID != 0)
	cmp	word ptr [ebp+01ch],0h;	usHelpID
	je	@BLBL52

; 225         flStyle |= MB_HELP;
	mov	eax,[ebp-0200h];	flStyle
	or	ah,020h
	mov	[ebp-0200h],eax;	flStyle
@BLBL52:

; 226       WinMessageBox(HWND_DESKTOP,
	push	dword ptr [ebp-0200h];	flStyle
	xor	eax,eax
	mov	ax,[ebp+01ch];	usHelpID
	add	eax,02h
	push	eax
	lea	eax,[ebp-078h];	szCaption
	push	eax
	lea	eax,[ebp-0f0h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h

; 227                     hwnd,
; 228                     szMessage,
; 229                     szCaption,
; 230                    (usHelpID + 2),
; 231                     flStyle);
; 232       }
@BLBL51:

; 233 //    DosFreeMem(pchLines);
; 234     return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL50:

; 235     }
; 236   pchFile[iCount] = 0;
	mov	eax,[ebp-0ch];	pchFile
	mov	ecx,[ebp-04h];	iCount
	mov	byte ptr [eax+ecx],0h

; 237 //  iCount = strlen(pchFile);
; 238   iOffset = 0;
	mov	dword ptr [ebp-018h],0h;	iOffset

; 239   while ((iOffset = FindLineWith(szConfigLine,pchFile,iOffset,&iLength,FALSE)) >= 0)
	push	0h
	lea	eax,[ebp-020h];	iLength
	push	eax
	push	dword ptr [ebp-018h];	iOffset
	push	dword ptr [ebp-0ch];	pchFile
	push	dword ptr [ebp+010h];	szConfigLine
	call	FindLineWith
	add	esp,014h
	mov	[ebp-018h],eax;	iOffset
	cmp	dword ptr [ebp-018h],0h;	iOffset
	jl	@BLBL53
	align 010h
@BLBL54:

; 240     {
; 241     if (iFirstOffset == 0)
	cmp	dword ptr [ebp-024h],0h;	iFirstOffset
	jne	@BLBL55

; 242       iFirstOffset = iOffset;
	mov	eax,[ebp-018h];	iOffset
	mov	[ebp-024h],eax;	iFirstOffset
@BLBL55:

; 243     iDDcount++;
	mov	eax,[ebp-01ch];	iDDcount
	inc	eax
	mov	[ebp-01ch],eax;	iDDcount

; 244     iOffset += iLength;
	mov	eax,[ebp-020h];	iLength
	add	eax,[ebp-018h];	iOffset
	mov	[ebp-018h],eax;	iOffset

; 245     iLastOffset = iOffset;
	mov	eax,[ebp-018h];	iOffset
	mov	[ebp-028h],eax;	iLastOffset

; 246     }

; 239   while ((iOffset = FindLineWith(szConfigLine,pchFile,iOffset,&iLength,FALSE)) >= 0)
	push	0h
	lea	eax,[ebp-020h];	iLength
	push	eax
	push	dword ptr [ebp-018h];	iOffset
	push	dword ptr [ebp-0ch];	pchFile
	push	dword ptr [ebp+010h];	szConfigLine
	call	FindLineWith
	add	esp,014h
	mov	[ebp-018h],eax;	iOffset
	cmp	dword ptr [ebp-018h],0h;	iOffset
	jge	@BLBL54
@BLBL53:

; 247   if (iDDcount != iLineCount)
	mov	eax,[ebp+014h];	iLineCount
	cmp	[ebp-01ch],eax;	iDDcount
	je	@BLBL57

; 250     if (hwnd != NULLHANDLE)
	cmp	dword ptr [ebp+08h],0h;	hwnd
	je	@BLBL58

; 251       sprintf(szCaption,"System configuration file needs to be updated");
	mov	edx,offset FLAT:@STAT2c
	lea	eax,[ebp-078h];	szCaption
	call	_sprintfieee
@BLBL58:

; 252     if (iDDcount > iLineCount)
	mov	eax,[ebp+014h];	iLineCount
	cmp	[ebp-01ch],eax;	iDDcount
	jle	@BLBL59

; 254       iDDcount -= iLineCount;
	mov	eax,[ebp-01ch];	iDDcount
	sub	eax,[ebp+014h];	iLineCount
	mov	[ebp-01ch],eax;	iDDcount

; 255       if (!bNoPrompt)
	cmp	dword ptr [ebp+018h],0h;	bNoPrompt
	jne	@BLBL60

; 257         if (hwnd != NULLHANDLE)
	cmp	dword ptr [ebp+08h],0h;	hwnd
	je	@BLBL60

; 259           if (iDDcount > 1)
	cmp	dword ptr [ebp-01ch],01h;	iDDcount
	jle	@BLBL62

; 260             sprintf(szMessage,"%s device driver load statements need to be removed from your CONFIG.SYS file.\n\nOK to make changes?",aszCapOrdinals[iDDcount]);
	mov	eax,[ebp-01ch];	iDDcount
	push	dword ptr [eax*04h+@2aszCapOrdinals]
	mov	edx,offset FLAT:@STAT2d
	lea	eax,[ebp-0f0h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	jmp	@BLBL63
	align 010h
@BLBL62:

; 262             sprintf(szMessage,"One device driver load statement needs to be removed from your CONFIG.SYS file.\n\nOK to make changes?");
	mov	edx,offset FLAT:@STAT2e
	lea	eax,[ebp-0f0h];	szMessage
	call	_sprintfieee
@BLBL63:

; 263           flStyle =  (MB_MOVEABLE | MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON1);
	mov	dword ptr [ebp-0200h],04014h;	flStyle

; 264           if (usHelpID != 0)
	cmp	word ptr [ebp+01ch],0h;	usHelpID
	je	@BLBL64

; 265             flStyle |= MB_HELP;
	mov	eax,[ebp-0200h];	flStyle
	or	ah,020h
	mov	[ebp-0200h],eax;	flStyle
@BLBL64:

; 266           if (WinMessageBox(HWND_DESKTOP,hwnd,szMessage,szCaption,usHelpID,flStyle) != MBID_YES)
	push	dword ptr [ebp-0200h];	flStyle
	xor	eax,eax
	mov	ax,[ebp+01ch];	usHelpID
	push	eax
	lea	eax,[ebp-078h];	szCaption
	push	eax
	lea	eax,[ebp-0f0h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,06h
	je	@BLBL60

; 268             if (iDDcount > 1)
	cmp	dword ptr [ebp-01ch],01h;	iDDcount
	jle	@BLBL66

; 269               sprintf(szMessage,"You will need to remove %s %s statements from your CONFIG.SYS file to complete this configuration.",aszOrdinals[iDDcount],szConfigLine);
	push	dword ptr [ebp+010h];	szConfigLine
	mov	eax,[ebp-01ch];	iDDcount
	push	dword ptr [eax*04h+@4aszOrdinals]
	mov	edx,offset FLAT:@STAT2f
	lea	eax,[ebp-0f0h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h
	jmp	@BLBL67
	align 010h
@BLBL66:

; 271               sprintf(szMessage,"You will need to remove one %s statement from your CONFIG.SYS file to complete this configuration.",szConfigLine);
	push	dword ptr [ebp+010h];	szConfigLine
	mov	edx,offset FLAT:@STAT30
	lea	eax,[ebp-0f0h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
@BLBL67:

; 272             WinMessageBox(HWND_DESKTOP,hwnd,szMessage,szCaption,0L,(MB_MOVEABLE | MB_OK | MB_ICONASTERISK));
	push	04030h
	push	0h
	lea	eax,[ebp-078h];	szCaption
	push	eax
	lea	eax,[ebp-0f0h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h

; 273             DosFreeMem(pchFile);
	push	dword ptr [ebp-0ch];	pchFile
	call	DosFreeMem
	add	esp,04h

; 274             DosFreeMem(pchLines);
	push	dword ptr [ebp-010h];	pchLines
	call	DosFreeMem
	add	esp,04h

; 275             return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL60:

; 279       iOffset = iFirstOffset;
	mov	eax,[ebp-024h];	iFirstOffset
	mov	[ebp-018h],eax;	iOffset

; 280       for (iIndex = 0;iIndex < iDDcount;iIndex++)
	mov	dword ptr [ebp-014h],0h;	iIndex
	mov	eax,[ebp-01ch];	iDDcount
	cmp	[ebp-014h],eax;	iIndex
	jge	@BLBL68
	align 010h
@BLBL69:

; 282         if ((iOffset = FindLineWith(szConfigLine,pchFile,iOffset,&iLength,FALSE)) < 0)
	push	0h
	lea	eax,[ebp-020h];	iLength
	push	eax
	push	dword ptr [ebp-018h];	iOffset
	push	dword ptr [ebp-0ch];	pchFile
	push	dword ptr [ebp+010h];	szConfigLine
	call	FindLineWith
	add	esp,014h
	mov	[ebp-018h],eax;	iOffset
	cmp	dword ptr [ebp-018h],0h;	iOffset
	jl	@BLBL68

; 284         iCount -= iLength;
	mov	eax,[ebp-04h];	iCount
	sub	eax,[ebp-020h];	iLength
	mov	[ebp-04h],eax;	iCount

; 285         memcpy(&pchFile[iOffset],&pchFile[iOffset + iLength],(iCount - iOffset));
	mov	ecx,[ebp-04h];	iCount
	sub	ecx,[ebp-018h];	iOffset
	mov	eax,[ebp-020h];	iLength
	add	eax,[ebp-018h];	iOffset
	mov	edx,[ebp-0ch];	pchFile
	add	edx,eax
	mov	eax,[ebp-0ch];	pchFile
	mov	ebx,[ebp-018h];	iOffset
	add	eax,ebx
	call	memcpy

; 286         }

; 280       for (iIndex = 0;iIndex < iDDcount;iIndex++)
	mov	eax,[ebp-014h];	iIndex
	inc	eax
	mov	[ebp-014h],eax;	iIndex
	mov	eax,[ebp-01ch];	iDDcount
	cmp	[ebp-014h],eax;	iIndex
	jl	@BLBL69
@BLBL68:

; 290       WriteConfigFile(hwnd,szFileSpec,pchFile,iCount);
	mov	eax,[ebp-04h];	iCount
	push	eax
	push	dword ptr [ebp-0ch];	pchFile
	push	dword ptr [ebp+0ch];	szFileSpec
	push	dword ptr [ebp+08h];	hwnd
	call	WriteConfigFile
	add	esp,010h

; 291       }
	jmp	@BLBL57
	align 010h
@BLBL59:

; 294       iLineCount -= iDDcount;
	mov	eax,[ebp+014h];	iLineCount
	sub	eax,[ebp-01ch];	iDDcount
	mov	[ebp+014h],eax;	iLineCount

; 295       if (!bNoPrompt)
	cmp	dword ptr [ebp+018h],0h;	bNoPrompt
	jne	@BLBL73

; 297         if (hwnd != NULLHANDLE)
	cmp	dword ptr [ebp+08h],0h;	hwnd
	je	@BLBL73

; 299           if (iLineCount > 1)
	cmp	dword ptr [ebp+014h],01h;	iLineCount
	jle	@BLBL75

; 300             sprintf(szMessage,"%s COMi load statements need to be added to your CONFIG.SYS file.\n\nOK to make changes?",aszCapOrdinals[iLineCount]);
	mov	eax,[ebp+014h];	iLineCount
	push	dword ptr [eax*04h+@2aszCapOrdinals]
	mov	edx,offset FLAT:@STAT31
	lea	eax,[ebp-0f0h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	jmp	@BLBL76
	align 010h
@BLBL75:

; 302             sprintf(szMessage,"One COMi load statement needs to be added to your CONFIG.SYS file.\n\nOK to make changes?");
	mov	edx,offset FLAT:@STAT32
	lea	eax,[ebp-0f0h];	szMessage
	call	_sprintfieee
@BLBL76:

; 303           flStyle =  (MB_MOVEABLE | MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON1);
	mov	dword ptr [ebp-0200h],04014h;	flStyle

; 304           if (usHelpID != 0)
	cmp	word ptr [ebp+01ch],0h;	usHelpID
	je	@BLBL77

; 305             flStyle |= MB_HELP;
	mov	eax,[ebp-0200h];	flStyle
	or	ah,020h
	mov	[ebp-0200h],eax;	flStyle
@BLBL77:

; 306           if (WinMessageBox(HWND_DESKTOP,hwnd,szMessage,szCaption,usHelpID,flStyle) != MBID_YES)
	push	dword ptr [ebp-0200h];	flStyle
	xor	eax,eax
	mov	ax,[ebp+01ch];	usHelpID
	push	eax
	lea	eax,[ebp-078h];	szCaption
	push	eax
	lea	eax,[ebp-0f0h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,06h
	je	@BLBL73

; 308             if (iLineCount > 1)
	cmp	dword ptr [ebp+014h],01h;	iLineCount
	jle	@BLBL79

; 309               sprintf(szMessage,"You will need to add %s %s statement lines to your CONFIG.SYS file to complete this configuration.",aszOrdinals[iLineCount],szConfigLine);
	push	dword ptr [ebp+010h];	szConfigLine
	mov	eax,[ebp+014h];	iLineCount
	push	dword ptr [eax*04h+@4aszOrdinals]
	mov	edx,offset FLAT:@STAT33
	lea	eax,[ebp-0f0h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h
	jmp	@BLBL80
	align 010h
@BLBL79:

; 311               sprintf(szMessage,"You will need to add one %s statement to your CONFIG.SYS file to complete this configuration.",szConfigLine);
	push	dword ptr [ebp+010h];	szConfigLine
	mov	edx,offset FLAT:@STAT34
	lea	eax,[ebp-0f0h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
@BLBL80:

; 312             WinMessageBox(HWND_DESKTOP,
	push	04030h
	push	0h
	lea	eax,[ebp-078h];	szCaption
	push	eax
	lea	eax,[ebp-0f0h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h

; 318             DosFreeMem(pchFile);
	push	dword ptr [ebp-0ch];	pchFile
	call	DosFreeMem
	add	esp,04h

; 319             DosFreeMem(pchLines);
	push	dword ptr [ebp-010h];	pchLines
	call	DosFreeMem
	add	esp,04h

; 320             return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL73:

; 324       iLen = 0;
	mov	dword ptr [ebp-0f4h],0h;	iLen

; 327       for (iIndex = 0;iIndex < iLineCount;iIndex++)
	mov	dword ptr [ebp-014h],0h;	iIndex
	mov	eax,[ebp+014h];	iLineCount
	cmp	[ebp-014h],eax;	iIndex
	jge	@BLBL81
	align 010h
@BLBL82:

; 328         iLen += sprintf(&pchLines[iLen],"%s\x0d\x0a",szConfigLine);
	push	dword ptr [ebp+010h];	szConfigLine
	mov	edx,offset FLAT:@STAT35
	mov	eax,[ebp-010h];	pchLines
	mov	ebx,[ebp-0f4h];	iLen
	add	eax,ebx
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	add	eax,[ebp-0f4h];	iLen
	mov	[ebp-0f4h],eax;	iLen

; 327       for (iIndex = 0;iIndex < iLineCount;iIndex++)
	mov	eax,[ebp-014h];	iIndex
	inc	eax
	mov	[ebp-014h],eax;	iIndex
	mov	eax,[ebp+014h];	iLineCount
	cmp	[ebp-014h],eax;	iIndex
	jl	@BLBL82
@BLBL81:

; 329       if (DosAllocMem((PVOID)&pchNew,(iCount + iLen + 20),(PAG_COMMIT | PAG_READ | PAG_WRITE)) == NO_ERROR)
	push	013h
	mov	eax,[ebp-0f4h];	iLen
	add	eax,[ebp-04h];	iCount
	add	eax,014h
	push	eax
	lea	eax,[ebp-08h];	pchNew
	push	eax
	call	DosAllocMem
	add	esp,0ch
	test	eax,eax
	jne	@BLBL57

; 331         memcpy(pchNew,pchFile,iCount);
	mov	ecx,[ebp-04h];	iCount
	mov	edx,[ebp-0ch];	pchFile
	mov	eax,[ebp-08h];	pchNew
	call	memcpy

; 332         if (iDDcount == 0)
	cmp	dword ptr [ebp-01ch],0h;	iDDcount
	jne	@BLBL85

; 334           iLastOffset = iCount;
	mov	eax,[ebp-04h];	iCount
	mov	[ebp-028h],eax;	iLastOffset

; 335           while (pchNew[iLastOffset - 1] == '\x1a')
	mov	eax,[ebp-08h];	pchNew
	mov	ebx,[ebp-028h];	iLastOffset
	cmp	byte ptr [eax+ebx-01h],01ah
	jne	@BLBL89
	align 010h
@BLBL87:

; 336             iLastOffset--;
	mov	eax,[ebp-028h];	iLastOffset
	dec	eax
	mov	[ebp-028h],eax;	iLastOffset

; 335           while (pchNew[iLastOffset - 1] == '\x1a')
	mov	eax,[ebp-08h];	pchNew
	mov	ebx,[ebp-028h];	iLastOffset
	cmp	byte ptr [eax+ebx-01h],01ah
	je	@BLBL87

; 337           }
	jmp	@BLBL89
	align 010h
@BLBL85:

; 339           memcpy(&pchNew[iLastOffset + iLen],&pchFile[iLastOffset],(iCount - iLastOffset));
	mov	ecx,[ebp-04h];	iCount
	sub	ecx,[ebp-028h];	iLastOffset
	mov	edx,[ebp-0ch];	pchFile
	mov	eax,[ebp-028h];	iLastOffset
	add	edx,eax
	mov	ebx,[ebp-0f4h];	iLen
	add	ebx,[ebp-028h];	iLastOffset
	mov	eax,[ebp-08h];	pchNew
	add	eax,ebx
	call	memcpy
@BLBL89:

; 340         memcpy(&pchNew[iLastOffset],pchLines,iLen);
	mov	ecx,[ebp-0f4h];	iLen
	mov	edx,[ebp-010h];	pchLines
	mov	eax,[ebp-08h];	pchNew
	mov	ebx,[ebp-028h];	iLastOffset
	add	eax,ebx
	call	memcpy

; 341         iCount += iLen;
	mov	eax,[ebp-0f4h];	iLen
	add	eax,[ebp-04h];	iCount
	mov	[ebp-04h],eax;	iCount

; 343         WriteConfigFile(hwnd,szFileSpec,pchNew,iCount);
	mov	eax,[ebp-04h];	iCount
	push	eax
	push	dword ptr [ebp-08h];	pchNew
	push	dword ptr [ebp+0ch];	szFileSpec
	push	dword ptr [ebp+08h];	hwnd
	call	WriteConfigFile
	add	esp,010h

; 344         DosFreeMem(pchNew);
	push	dword ptr [ebp-08h];	pchNew
	call	DosFreeMem
	add	esp,04h

; 345         }

; 346       }

; 347     }
@BLBL57:

; 348   DosFreeMem(pchLines);
	push	dword ptr [ebp-010h];	pchLines
	call	DosFreeMem
	add	esp,04h

; 349   DosFreeMem(pchFile);
	push	dword ptr [ebp-0ch];	pchFile
	call	DosFreeMem
	add	esp,04h

; 350   return(TRUE);
	mov	eax,01h
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
AdjustConfigFile	endp

; 354   {
	align 010h

	public WriteConfigFile
WriteConfigFile	proc
	push	ebp
	mov	ebp,esp
	sub	esp,01f0h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,07ch
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 364   strcpy(szBackupSpec,szFileSpec);
	mov	edx,[ebp+0ch];	szFileSpec
	lea	eax,[ebp-010dh];	szBackupSpec
	call	strcpy

; 365   for (iIndex = (strlen(szBackupSpec) - 1);iIndex > 0;iIndex--)
	lea	eax,[ebp-010dh];	szBackupSpec
	call	strlen
	dec	eax
	mov	[ebp-04h],eax;	iIndex
	cmp	dword ptr [ebp-04h],0h;	iIndex
	jle	@BLBL90
	align 010h
@BLBL91:

; 366     if (szBackupSpec[iIndex] == '.')
	mov	eax,[ebp-04h];	iIndex
	cmp	byte ptr [ebp+eax-010dh],02eh
	je	@BLBL90

; 365   for (iIndex = (strlen(szBackupSpec) - 1);iIndex > 0;iIndex--)
	mov	eax,[ebp-04h];	iIndex
	dec	eax
	mov	[ebp-04h],eax;	iIndex
	cmp	dword ptr [ebp-04h],0h;	iIndex
	jg	@BLBL91
@BLBL90:

; 368   iIndex++;
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex

; 369   if (iIndex <= 2)
	cmp	dword ptr [ebp-04h],02h;	iIndex
	jg	@BLBL94

; 371     iIndex = strlen(szFileSpec);
	mov	eax,[ebp+0ch];	szFileSpec
	call	strlen
	mov	[ebp-04h],eax;	iIndex

; 372     szBackupSpec[iIndex++] = '.';
	mov	eax,[ebp-04h];	iIndex
	mov	byte ptr [ebp+eax-010dh],02eh
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex

; 373     }
@BLBL94:

; 374   pchDot = &szBackupSpec[iIndex];
	mov	eax,[ebp-04h];	iIndex
	lea	eax,dword ptr [ebp+eax-010dh]
	mov	[ebp-01e4h],eax;	pchDot

; 375   strcpy(pchDot,"001");
	mov	edx,offset FLAT:@STAT36
	mov	eax,[ebp-01e4h];	pchDot
	call	strcpy

; 376   iIndex = 2;
	mov	dword ptr [ebp-04h],02h;	iIndex

; 377   while ((rc = DosOpen(szBackupSpec,&hFile,&ulStatus,0L,0,0x0010,0x0020,(PEAOP2)0L)) != 0)
	push	0h
	push	020h
	push	010h
	push	0h
	push	0h
	lea	eax,[ebp-0118h];	ulStatus
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	lea	eax,[ebp-010dh];	szBackupSpec
	push	eax
	call	DosOpen
	add	esp,020h
	mov	[ebp-0114h],eax;	rc
	cmp	dword ptr [ebp-0114h],0h;	rc
	je	@BLBL95
	align 010h
@BLBL96:

; 381     sprintf(pchDot,"%03X",iIndex++);
	mov	eax,[ebp-04h];	iIndex
	mov	[ebp-01e8h],eax;	@CBE66
	mov	dword ptr [ebp-01ech],offset FLAT:@STAT37;	@CBE67
	mov	eax,[ebp-01e4h];	pchDot
	mov	[ebp-01f0h],eax;	@CBE68
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	push	dword ptr [ebp-01e8h];	@CBE66
	mov	edx,[ebp-01ech];	@CBE67
	mov	eax,[ebp-01f0h];	@CBE68
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 382     if (iIndex > 0xfff)
	cmp	dword ptr [ebp-04h],0fffh;	iIndex
	jle	@BLBL97

; 384       DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 385       if (hwndParent != NULLHANDLE)
	cmp	dword ptr [ebp+08h],0h;	hwndParent
	je	@BLBL98

; 387         sprintf(szMessage,"%s was not updated!  Could not make backup",szFileSpec,rc);
	push	dword ptr [ebp-0114h];	rc
	push	dword ptr [ebp+0ch];	szFileSpec
	mov	edx,offset FLAT:@STAT38
	lea	eax,[ebp-0190h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 388         MessageBox(HWND_DESKTOP,szMessage);
	lea	eax,[ebp-0190h];	szMessage
	push	eax
	push	01h
	call	MessageBox
	add	esp,08h

; 389         }
@BLBL98:

; 390       return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL97:

; 392     }

; 377   while ((rc = DosOpen(szBackupSpec,&hFile,&ulStatus,0L,0,0x0010,0x0020,(PEAOP2)0L)) != 0)
	push	0h
	push	020h
	push	010h
	push	0h
	push	0h
	lea	eax,[ebp-0118h];	ulStatus
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	lea	eax,[ebp-010dh];	szBackupSpec
	push	eax
	call	DosOpen
	add	esp,020h
	mov	[ebp-0114h],eax;	rc
	cmp	dword ptr [ebp-0114h],0h;	rc
	jne	@BLBL96
@BLBL95:

; 393   DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 394   DosCopy(szFileSpec,szBackupSpec,DCPY_EXISTING);
	push	01h
	lea	eax,[ebp-010dh];	szBackupSpec
	push	eax
	push	dword ptr [ebp+0ch];	szFileSpec
	call	DosCopy
	add	esp,0ch

; 395   if (hwndParent != NULLHANDLE)
	cmp	dword ptr [ebp+08h],0h;	hwndParent
	je	@BLBL100

; 397     sprintf(szMessage,"The current system configuration file, %s, was renamed to %s",szFileSpec,szBackupSpec);
	lea	eax,[ebp-010dh];	szBackupSpec
	push	eax
	push	dword ptr [ebp+0ch];	szFileSpec
	mov	edx,offset FLAT:@STAT39
	lea	eax,[ebp-0190h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 398     sprintf(szCaption,"System configuration file was backed up.");
	mov	edx,offset FLAT:@STAT3a
	lea	eax,[ebp-01e0h];	szCaption
	call	_sprintfieee

; 399     WinMessageBox(HWND_DESKTOP,
	push	030h
	push	0h
	lea	eax,[ebp-01e0h];	szCaption
	push	eax
	lea	eax,[ebp-0190h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwndParent
	push	01h
	call	WinMessageBox
	add	esp,018h

; 405     }
@BLBL100:

; 406   if ((rc = DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0022,(PEAOP2)0L)) != 0)
	push	0h
	push	022h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-0118h];	ulStatus
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	push	dword ptr [ebp+0ch];	szFileSpec
	call	DosOpen
	add	esp,020h
	mov	[ebp-0114h],eax;	rc
	cmp	dword ptr [ebp-0114h],0h;	rc
	je	@BLBL101

; 408     if (hwndParent != NULLHANDLE)
	cmp	dword ptr [ebp+08h],0h;	hwndParent
	je	@BLBL102

; 410       sprintf(szMessage,"%s was not updated!  Could not reopen - Error = %u",szFileSpec,rc);
	push	dword ptr [ebp-0114h];	rc
	push	dword ptr [ebp+0ch];	szFileSpec
	mov	edx,offset FLAT:@STAT3b
	lea	eax,[ebp-0190h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 411       MessageBox(HWND_DESKTOP,szMessage);
	lea	eax,[ebp-0190h];	szMessage
	push	eax
	push	01h
	call	MessageBox
	add	esp,08h

; 412       }
@BLBL102:

; 413     return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL101:

; 415   DosSetFileSize(hFile,cbCount);
	push	dword ptr [ebp+014h];	cbCount
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFileSize
	add	esp,08h

; 416   DosWrite(hFile,pBuffer,cbCount,&cbCount);
	lea	eax,[ebp+014h];	cbCount
	push	eax
	push	dword ptr [ebp+014h];	cbCount
	push	dword ptr [ebp+010h];	pBuffer
	push	dword ptr [ebp-08h];	hFile
	call	DosWrite
	add	esp,010h

; 417   DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 418   return(TRUE);
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
WriteConfigFile	endp

; 422   {
	align 010h

	public CleanConfigSys
CleanConfigSys	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0270h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,09ch
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	push	ebx
	sub	esp,0ch

; 430   BOOL bFileChanged = FALSE;
	mov	dword ptr [ebp-0168h],0h;	bFileChanged

; 431   ULONG flStyle;
; 432   char szFileSpec[CCHMAXPATH] = "C:\\CONFIG.SYS";
	lea	eax,[ebp-0270h];	szFileSpec
	mov	eax,eax
	mov	edx,offset FLAT:@STAT3c
	mov	ecx,[edx]
	mov	ebx,[edx+04h]
	mov	[eax],ecx
	mov	[eax+04h],ebx
	mov	ebx,[edx+08h]
	mov	[eax+08h],ebx
	mov	cx,[edx+0ch]
	mov	[eax+0ch],cx
	xor	eax,eax
	mov	ebx,01ch
@BLBL117:
	mov	dword ptr [ebp+ebx*08h-0262h],eax
	mov	dword ptr [ebp+ebx*08h-025eh],eax
	mov	dword ptr [ebp+ebx*08h-025ah],eax
	mov	dword ptr [ebp+ebx*08h-0256h],eax
	sub	ebx,02h
	jge	@BLBL117
	mov	[ebp-0172h],eax;	szFileSpec
	mov	[ebp-016eh],ax;	szFileSpec
	lea	eax,[ebp-0262h];	szFileSpec

; 433 
; 434   if (DosQuerySysInfo(QSV_BOOT_DRIVE,QSV_BOOT_DRIVE,&iCount,4L) == 0)
	push	04h
	lea	eax,[ebp-04h];	iCount
	push	eax
	push	05h
	push	05h
	call	DosQuerySysInfo
	add	esp,010h
	test	eax,eax
	jne	@BLBL103

; 435     szFileSpec[0] = ('A' + ((BYTE)iCount - 1));
	mov	al,[ebp-04h];	iCount
	add	al,040h
	mov	[ebp-0270h],al;	szFileSpec
@BLBL103:

; 436   if ((iCount = ReadConfigFile(hwnd, szFileSpec,&pchFile)) == 0)
	lea	eax,[ebp-08h];	pchFile
	push	eax
	lea	eax,[ebp-0270h];	szFileSpec
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	ReadConfigFile
	add	esp,0ch
	mov	[ebp-04h],eax;	iCount
	cmp	dword ptr [ebp-04h],0h;	iCount
	jne	@BLBL104

; 437     {
; 438     if (hwnd != NULLHANDLE)
	cmp	dword ptr [ebp+08h],0h;	hwnd
	je	@BLBL105

; 439       {
; 440       sprintf(szCaption,"Unable to Open System Configuration File");
	mov	edx,offset FLAT:@STAT3d
	lea	eax,[ebp-0157h];	szCaption
	call	_sprintfieee

; 441       sprintf(szLine,"You will need to remove all DEVICE=%s.SYS statement(s) from your CONFIG.SYS file to complete this process.",szDDspec);
	push	dword ptr [ebp+0ch];	szDDspec
	mov	edx,offset FLAT:@STAT3e
	lea	eax,[ebp-0107h];	szLine
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 442       flStyle =  (MB_MOVEABLE | MB_OK | MB_ICONHAND);
	mov	dword ptr [ebp-016ch],04040h;	flStyle

; 443       if (usHelpID != 0)
	cmp	word ptr [ebp+010h],0h;	usHelpID
	je	@BLBL106

; 444         flStyle |= MB_HELP;
	mov	eax,[ebp-016ch];	flStyle
	or	ah,020h
	mov	[ebp-016ch],eax;	flStyle
@BLBL106:

; 445       WinMessageBox(HWND_DESKTOP,
	push	dword ptr [ebp-016ch];	flStyle
	xor	eax,eax
	mov	ax,[ebp+010h];	usHelpID
	inc	eax
	push	eax
	lea	eax,[ebp-0157h];	szCaption
	push	eax
	lea	eax,[ebp-0107h];	szLine
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h

; 446                     hwnd,
; 447                     szLine,
; 448                     szCaption,
; 449                     (usHelpID + 1),
; 450                     flStyle);
; 451       }
@BLBL105:

; 452     return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL104:

; 453     }
; 454   pchFile[iCount] = 0;
	mov	eax,[ebp-08h];	pchFile
	mov	ebx,[ebp-04h];	iCount
	mov	byte ptr [eax+ebx],0h

; 455   iOffset = 0;
	mov	dword ptr [ebp-015ch],0h;	iOffset

; 456   if (hwnd != NULLHANDLE)
	cmp	dword ptr [ebp+08h],0h;	hwnd
	je	@BLBL107

; 457     MessageBox(hwnd,szDDspec);
	push	dword ptr [ebp+0ch];	szDDspec
	push	dword ptr [ebp+08h];	hwnd
	call	MessageBox
	add	esp,08h
@BLBL107:

; 458   while ((iOffset = FindLineWith(szDDspec,pchFile,iOffset,&iLength,FALSE)) >= 0)
	push	0h
	lea	eax,[ebp-0160h];	iLength
	push	eax
	push	dword ptr [ebp-015ch];	iOffset
	push	dword ptr [ebp-08h];	pchFile
	push	dword ptr [ebp+0ch];	szDDspec
	call	FindLineWith
	add	esp,014h
	mov	[ebp-015ch],eax;	iOffset
	cmp	dword ptr [ebp-015ch],0h;	iOffset
	jl	@BLBL108
	align 010h
@BLBL109:

; 459     {
; 460     bFileChanged = TRUE;
	mov	dword ptr [ebp-0168h],01h;	bFileChanged

; 461     iCount -= iLength;
	mov	eax,[ebp-04h];	iCount
	sub	eax,[ebp-0160h];	iLength
	mov	[ebp-04h],eax;	iCount

; 462     memcpy(&pchFile[iOffset],&pchFile[iOffset + iLength],(iCount - iOffset));
	mov	ecx,[ebp-04h];	iCount
	sub	ecx,[ebp-015ch];	iOffset
	mov	eax,[ebp-0160h];	iLength
	add	eax,[ebp-015ch];	iOffset
	mov	edx,[ebp-08h];	pchFile
	add	edx,eax
	mov	eax,[ebp-08h];	pchFile
	mov	ebx,[ebp-015ch];	iOffset
	add	eax,ebx
	call	memcpy

; 463     iOffset += iLength;
	mov	eax,[ebp-0160h];	iLength
	add	eax,[ebp-015ch];	iOffset
	mov	[ebp-015ch],eax;	iOffset

; 464     }

; 458   while ((iOffset = FindLineWith(szDDspec,pchFile,iOffset,&iLength,FALSE)) >= 0)
	push	0h
	lea	eax,[ebp-0160h];	iLength
	push	eax
	push	dword ptr [ebp-015ch];	iOffset
	push	dword ptr [ebp-08h];	pchFile
	push	dword ptr [ebp+0ch];	szDDspec
	call	FindLineWith
	add	esp,014h
	mov	[ebp-015ch],eax;	iOffset
	cmp	dword ptr [ebp-015ch],0h;	iOffset
	jge	@BLBL109
@BLBL108:

; 466   if (bFileChanged)
	cmp	dword ptr [ebp-0168h],0h;	bFileChanged
	je	@BLBL111

; 468     if (bAskFirst)
	cmp	dword ptr [ebp+014h],0h;	bAskFirst
	je	@BLBL112

; 470       if (hwnd != NULLHANDLE)
	cmp	dword ptr [ebp+08h],0h;	hwnd
	je	@BLBL112

; 472         sprintf(szCaption,"System configuration file needs to be updated");
	mov	edx,offset FLAT:@STAT3f
	lea	eax,[ebp-0157h];	szCaption
	call	_sprintfieee

; 473         if (szDDspec[strlen(szDDspec) - 4] == '.')
	mov	eax,[ebp+0ch];	szDDspec
	call	strlen
	mov	ebx,eax
	mov	eax,[ebp+0ch];	szDDspec
	cmp	byte ptr [eax+ebx-04h],02eh
	jne	@BLBL114

; 474           szDDspec[strlen(szDDspec) - 4] = 0;
	mov	eax,[ebp+0ch];	szDDspec
	call	strlen
	mov	ebx,eax
	mov	eax,[ebp+0ch];	szDDspec
	mov	byte ptr [eax+ebx-04h],0h
@BLBL114:

; 475         sprintf(szLine,"All ""DEVICE=%s.SYS"" statements from a previous device driver version need to be removed from your CONFIG.SYS file.\n\nOK to make changes?",szDDspec);
	push	dword ptr [ebp+0ch];	szDDspec
	mov	edx,offset FLAT:@STAT40
	lea	eax,[ebp-0107h];	szLine
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 476         flStyle =  (MB_MOVEABLE | MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON1);
	mov	dword ptr [ebp-016ch],04014h;	flStyle

; 477         if (usHelpID != 0)
	cmp	word ptr [ebp+010h],0h;	usHelpID
	je	@BLBL115

; 478           flStyle |= MB_HELP;
	mov	eax,[ebp-016ch];	flStyle
	or	ah,020h
	mov	[ebp-016ch],eax;	flStyle
@BLBL115:

; 479         if (WinMessageBox(HWND_DESKTOP,
	push	dword ptr [ebp-016ch];	flStyle
	xor	eax,eax
	mov	ax,[ebp+010h];	usHelpID
	push	eax
	lea	eax,[ebp-0157h];	szCaption
	push	eax
	lea	eax,[ebp-0107h];	szLine
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,06h
	je	@BLBL112

; 486           sprintf(szLine,"You will need to remove all DEVICE=%s.SYS statements from your CONFIG.SYS file to complete this configuration.",szDDspec);
	push	dword ptr [ebp+0ch];	szDDspec
	mov	edx,offset FLAT:@STAT41
	lea	eax,[ebp-0107h];	szLine
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 487           WinMessageBox(HWND_DESKTOP,
	push	04030h
	push	0h
	lea	eax,[ebp-0157h];	szCaption
	push	eax
	lea	eax,[ebp-0107h];	szLine
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinMessageBox
	add	esp,018h

; 494           DosFreeMem(pchFile);
	push	dword ptr [ebp-08h];	pchFile
	call	DosFreeMem
	add	esp,04h

; 495           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL112:

; 499     WriteConfigFile(hwnd,szFileSpec,pchFile,iCount);
	mov	eax,[ebp-04h];	iCount
	push	eax
	push	dword ptr [ebp-08h];	pchFile
	lea	eax,[ebp-0270h];	szFileSpec
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WriteConfigFile
	add	esp,010h

; 500     }
@BLBL111:

; 501   DosFreeMem(pchFile);
	push	dword ptr [ebp-08h];	pchFile
	call	DosFreeMem
	add	esp,04h

; 502   return(bFileChanged);
	mov	eax,[ebp-0168h];	bFileChanged
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
CleanConfigSys	endp
CODE32	ends
end
