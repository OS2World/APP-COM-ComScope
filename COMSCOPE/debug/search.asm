	title	p:\COMscope\search.c
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
	public	bSearchInit
	public	lSearchStrLen
	extrn	strtol:proc
	extrn	GetDisplayCount:proc
	extrn	WinSendMsg:proc
	extrn	WinInvalidateRect:proc
	extrn	CenterDlgBox:proc
	extrn	WinSendDlgItemMsg:proc
	extrn	CheckButton:proc
	extrn	ControlEnable:proc
	extrn	_sprintfieee:proc
	extrn	WinSetDlgItemText:proc
	extrn	WinPostMsg:proc
	extrn	Checked:proc
	extrn	WinDefDlgProc:proc
	extrn	WinQueryDlgItemText:proc
	extrn	WinMessageBox:proc
	extrn	strcpy:proc
	extrn	MessageBox:proc
	extrn	WinDismissDlg:proc
	extrn	DisplayHelpPanel:proc
	extrn	_fullDump:dword
	extrn	stCFG:byte
	extrn	stRead:byte
	extrn	stWrite:byte
	extrn	stRow:byte
	extrn	_ctype:dword
DATA32	segment
@STAT1	db "%02X",0h
	align 04h
@STAT2	db "No character sequence wi"
db "ll be searched",0h
	align 04h
@STAT3	db "A character sequence was"
db " not entered.",0h
	align 04h
@STAT4	db "A zero will be assumed b"
db "efore the last digit.",0ah,0ah,"%"
db "s will changed to ",0h
	align 04h
@STAT5	db "An even number of digits"
db " were not entered.",0h
	align 04h
@STAT6	db "Invalid charcters in str"
db "ing.",0ah,0ah,"At least on of the"
db " characters in the searc"
db "h string is not a Hexade"
db "cimal number.",0h
DATA32	ends
BSS32	segment
bSearchInit	dd 0h
lSearchStrLen	dd 0h
	align 02h
comm	swSearchString:byte:0400h
@46pstCFG	dd 0h
@47bAllowClick	dd 0h
@49usDirection	dd 0h
BSS32	ends
CODE32	segment

; 23   {
	align 010h

	public SearchTraceEvent
SearchTraceEvent	proc
	push	ebp
	mov	ebp,esp

; 24   switch (wTraceElement & 0xff00)
	xor	eax,eax
	mov	ax,[ebp+08h];	wTraceElement
	and	eax,0ff00h
	jmp	@BLBL13
	align 04h
@BLBL14:

; 25     {
; 26     case CS_READ:
; 27       if (stCFG.bFindRead)
	test	byte ptr  stCFG+01dh,04h
	je	@BLBL1

; 28         return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL1:

; 29       break;
	jmp	@BLBL12
	align 04h
@BLBL15:

; 30     case CS_WRITE:
; 31       if (stCFG.bFindWrite)
	test	byte ptr  stCFG+01dh,08h
	je	@BLBL2

; 32         return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL2:

; 33       break;
	jmp	@BLBL12
	align 04h
@BLBL16:
@BLBL17:

; 34     case CS_READ_IMM:
; 35     case CS_WRITE_IMM:
; 36       if (stCFG.bFindIMM)
	test	byte ptr  stCFG+01dh,010h
	je	@BLBL3

; 37         return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL3:

; 38       break;
	jmp	@BLBL12
	align 04h
@BLBL18:
@BLBL19:

; 39     case CS_READ_REQ:
; 40     case CS_READ_CMPLT:
; 41       if (stCFG.bFindReadReq)
	test	byte ptr  stCFG+01eh,02h
	je	@BLBL4

; 42         return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL4:

; 43       break;
	jmp	@BLBL12
	align 04h
@BLBL20:

; 44     case CS_MODEM_IN:
; 45       if (stCFG.bFindModemIn)
	test	byte ptr  stCFG+01dh,020h
	je	@BLBL5

; 46         return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL5:

; 47       break;
	jmp	@BLBL12
	align 04h
@BLBL21:
@BLBL22:
@BLBL23:

; 48     case CS_READ_BUFF_OVERFLOW:
; 49     case CS_HDW_ERROR:
; 50     case CS_BREAK_RX:
; 51       if (stCFG.bFindErrors)
	test	byte ptr  stCFG+01eh,08h
	je	@BLBL6

; 52         return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL6:

; 53       break;
	jmp	@BLBL12
	align 04h
@BLBL24:
@BLBL25:

; 54     case CS_WRITE_REQ:
; 55     case CS_WRITE_CMPLT:
; 56       if (stCFG.bFindWriteReq)
	test	byte ptr  stCFG+01eh,01h
	je	@BLBL7

; 57         return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL7:

; 58       break;
	jmp	@BLBL12
	align 04h
@BLBL26:

; 59     case CS_MODEM_OUT:
; 60       if (stCFG.bFindModemOut)
	test	byte ptr  stCFG+01dh,040h
	je	@BLBL8

; 61         return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL8:

; 62       break;
	jmp	@BLBL12
	align 04h
@BLBL27:

; 63     case CS_DEVIOCTL:
; 64       if (stCFG.bFindDevIOctl)
	test	byte ptr  stCFG+01eh,04h
	je	@BLBL9

; 65         return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL9:

; 66       break;
	jmp	@BLBL12
	align 04h
@BLBL28:
@BLBL29:
@BLBL30:
@BLBL31:

; 67     case CS_OPEN_ONE:
; 68     case CS_OPEN_TWO:
; 69     case CS_CLOSE_ONE:
; 70     case CS_CLOSE_TWO:
; 71       if (stCFG.bFindOpen)
	test	byte ptr  stCFG+01dh,080h
	je	@BLBL10

; 72         return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL10:

; 73       break;
	jmp	@BLBL12
	align 04h
@BLBL32:

; 74     case CS_BREAK_TX:
; 75       if (stCFG.bFindDevIOctl)
	test	byte ptr  stCFG+01eh,04h
	je	@BLBL11

; 76         return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL11:

; 77       break;
	jmp	@BLBL12
	align 04h
	jmp	@BLBL12
	align 04h
@BLBL13:
	cmp	eax,04000h
	je	@BLBL14
	cmp	eax,08000h
	je	@BLBL15
	cmp	eax,04100h
	je	@BLBL16
	cmp	eax,08100h
	je	@BLBL17
	cmp	eax,04200h
	je	@BLBL18
	cmp	eax,04300h
	je	@BLBL19
	cmp	eax,04400h
	je	@BLBL20
	cmp	eax,04500h
	je	@BLBL21
	cmp	eax,04600h
	je	@BLBL22
	cmp	eax,04700h
	je	@BLBL23
	cmp	eax,08200h
	je	@BLBL24
	cmp	eax,08300h
	je	@BLBL25
	cmp	eax,08400h
	je	@BLBL26
	cmp	eax,08500h
	je	@BLBL27
	cmp	eax,08600h
	je	@BLBL28
	cmp	eax,08700h
	je	@BLBL29
	cmp	eax,08800h
	je	@BLBL30
	cmp	eax,08900h
	je	@BLBL31
	cmp	eax,08a00h
	je	@BLBL32
@BLBL12:

; 78     }
; 79   return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
SearchTraceEvent	endp

; 83   {
	align 010h

	public SearchCaptureBuffer
SearchCaptureBuffer	proc
	push	ebp
	mov	ebp,esp
	sub	esp,020h
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
	pop	edi
	pop	eax
	push	ebx
	sub	esp,0ch

; 94   if (pusBuffer == NULL)
	cmp	dword ptr [ebp+08h],0h;	pusBuffer
	jne	@BLBL33

; 95     return(-1);
	or	eax,0ffffffffh
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL33:

; 96 
; 97   szHex[2] = 0;
	mov	byte ptr [ebp-01bh],0h;	szHex

; 98   if (stCFG.bColumnDisplay)
	test	byte ptr  stCFG+018h,080h
	je	@BLBL34

; 99     {
; 100     if (stCFG.bFindString)
	test	byte ptr  stCFG+01dh,02h
	je	@BLBL35

; 101       usDirection = (pusBuffer[0] & 0xf000);
	mov	eax,[ebp+08h];	pusBuffer
	mov	ax,[eax]
	and	ax,0f000h
	mov	[ebp-0eh],ax;	usDirection
	jmp	@BLBL36
	align 010h
@BLBL35:

; 102     else
; 103       usDirection = 0;
	mov	word ptr [ebp-0eh],0h;	usDirection
@BLBL36:

; 104     if (usDirection == CS_READ)
	cmp	word ptr [ebp-0eh],04000h;	usDirection
	jne	@BLBL37

; 105       lStartIndex = stRead.lScrollIndex;
	mov	eax,dword ptr  stRead+06fh
	mov	[ebp-04h],eax;	lStartIndex
	jmp	@BLBL47
	align 010h
@BLBL37:

; 106     else
; 107       {
; 108       if (usDirection == CS_WRITE)
	cmp	word ptr [ebp-0eh],08000h;	usDirection
	jne	@BLBL39

; 109         lStartIndex = stWrite.lScrollIndex;
	mov	eax,dword ptr  stWrite+06fh
	mov	[ebp-04h],eax;	lStartIndex
	jmp	@BLBL47
	align 010h
@BLBL39:

; 110       else
; 111         {
; 112         if (stRead.lScrollIndex > stWrite.lScrollIndex)
	mov	eax,dword ptr  stWrite+06fh
	cmp	dword ptr  stRead+06fh,eax
	jle	@BLBL41

; 113           {
; 114           if (stCFG.bFindForward)
	test	byte ptr  stCFG+01dh,01h
	je	@BLBL42

; 115             lStartIndex = stWrite.lScrollIndex;
	mov	eax,dword ptr  stWrite+06fh
	mov	[ebp-04h],eax;	lStartIndex
	jmp	@BLBL47
	align 010h
@BLBL42:

; 116           else
; 117             lStartIndex = stRead.lScrollIndex;
	mov	eax,dword ptr  stRead+06fh
	mov	[ebp-04h],eax;	lStartIndex

; 118           }
	jmp	@BLBL47
	align 010h
@BLBL41:

; 119         else
; 120           {
; 121           if (stCFG.bFindForward)
	test	byte ptr  stCFG+01dh,01h
	je	@BLBL45

; 122             lStartIndex = stRead.lScrollIndex;
	mov	eax,dword ptr  stRead+06fh
	mov	[ebp-04h],eax;	lStartIndex
	jmp	@BLBL47
	align 010h
@BLBL45:

; 123           else
; 124             lStartIndex = stWrite.lScrollIndex;
	mov	eax,dword ptr  stWrite+06fh
	mov	[ebp-04h],eax;	lStartIndex

; 125           }

; 126         }

; 127       }

; 128     }
	jmp	@BLBL47
	align 010h
@BLBL34:

; 129   else
; 130     lStartIndex = stRow.lScrollIndex;
	mov	eax,dword ptr  stRow+06fh
	mov	[ebp-04h],eax;	lStartIndex
@BLBL47:

; 131   usDirection = (swSearchString[0] & 0xff00);
	mov	ax,word ptr  swSearchString
	and	ax,0ff00h
	mov	[ebp-0eh],ax;	usDirection

; 132   if (stCFG.bFindForward)
	test	byte ptr  stCFG+01dh,01h
	je	@BLBL48

; 133     {
; 134     lStartIndex++;
	mov	eax,[ebp-04h];	lStartIndex
	inc	eax
	mov	[ebp-04h],eax;	lStartIndex

; 135     if (lStartIndex > lBufLength)
	mov	eax,[ebp+0ch];	lBufLength
	cmp	[ebp-04h],eax;	lStartIndex
	jle	@BLBL49

; 136       return(-1);
	or	eax,0ffffffffh
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL49:

; 137     lStrIndex = 0;
	mov	dword ptr [ebp-08h],0h;	lStrIndex

; 138     for (lIndex = lStartIndex;lIndex < lBufLength;lIndex++)
	mov	eax,[ebp-04h];	lStartIndex
	mov	[ebp-0ch],eax;	lIndex
	mov	eax,[ebp+0ch];	lBufLength
	cmp	[ebp-0ch],eax;	lIndex
	jge	@BLBL71
	align 010h
@BLBL51:

; 139       {
; 140       usEvent = pusBuffer[lIndex];
	mov	eax,[ebp+08h];	pusBuffer
	mov	ecx,[ebp-0ch];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	mov	[ebp-010h],ax;	usEvent

; 141       if (SearchTraceEvent(usEvent))
	mov	ax,[ebp-010h];	usEvent
	push	eax
	call	SearchTraceEvent
	add	esp,04h
	test	eax,eax
	jne	gtGotIndex53

; 142         goto gtGotIndex;
; 143       if (stCFG.bFindString)
	test	byte ptr  stCFG+01dh,02h
	je	@BLBL54

; 144         {
; 145         if ((usEvent & 0xff00) == usDirection)
	mov	ax,[ebp-010h];	usEvent
	and	ax,0ff00h
	cmp	[ebp-0eh],ax;	usDirection
	jne	@BLBL54

; 146           {
; 147           xSearchByte = (BYTE)swSearchString[lStrIndex++];
	mov	eax,[ebp-08h];	lStrIndex
	mov	ax,word ptr [eax*02h+swSearchString]
	mov	[ebp-019h],al;	xSearchByte
	mov	eax,[ebp-08h];	lStrIndex
	inc	eax
	mov	[ebp-08h],eax;	lStrIndex

; 148           if (xSearchByte == '\\')
	cmp	byte ptr [ebp-019h],05ch;	xSearchByte
	jne	@BLBL56

; 149             {
; 150             if ((BYTE)swSearchString[lStrIndex] == 'x')
	mov	eax,[ebp-08h];	lStrIndex
	mov	al,byte ptr [eax*02h+swSearchString]
	cmp	al,078h
	jne	@BLBL57

; 151               {
; 152               lStrIndex++;
	mov	eax,[ebp-08h];	lStrIndex
	inc	eax
	mov	[ebp-08h],eax;	lStrIndex

; 153               szHex[0] = (BYTE)swSearchString[lStrIndex++];
	mov	eax,[ebp-08h];	lStrIndex
	mov	ax,word ptr [eax*02h+swSearchString]
	mov	[ebp-01dh],al;	szHex
	mov	eax,[ebp-08h];	lStrIndex
	inc	eax
	mov	[ebp-08h],eax;	lStrIndex

; 154               szHex[1] = (BYTE)swSearchString[lStrIndex++];
	mov	eax,[ebp-08h];	lStrIndex
	mov	ax,word ptr [eax*02h+swSearchString]
	mov	[ebp-01ch],al;	szHex
	mov	eax,[ebp-08h];	lStrIndex
	inc	eax
	mov	[ebp-08h],eax;	lStrIndex

; 155               xSearchByte = (BYTE)strtol(szHex,NULL,16);
	mov	ecx,010h
	xor	edx,edx
	lea	eax,[ebp-01dh];	szHex
	call	strtol
	mov	[ebp-019h],al;	xSearchByte

; 156               }
	jmp	@BLBL56
	align 010h
@BLBL57:

; 157             else
; 158               if ((BYTE)swSearchString[lStrIndex] == '\\')
	mov	eax,[ebp-08h];	lStrIndex
	mov	al,byte ptr [eax*02h+swSearchString]
	cmp	al,05ch
	jne	@BLBL56

; 159                 lStrIndex++;
	mov	eax,[ebp-08h];	lStrIndex
	inc	eax
	mov	[ebp-08h],eax;	lStrIndex

; 160             }
@BLBL56:

; 161           if (!stCFG.bFindStrNoCase)
	test	byte ptr  stCFG+01eh,020h
	jne	@BLBL60

; 162             {
; 163             if (xSearchByte != (BYTE)usEvent)
	mov	al,[ebp-010h];	usEvent
	cmp	[ebp-019h],al;	xSearchByte
	je	@BLBL61

; 164               lStrIndex = 0;
	mov	dword ptr [ebp-08h],0h;	lStrIndex
	jmp	@BLBL54
	align 010h
@BLBL61:

; 165             else
; 166               {
; 167               if (lStrIndex == 1)
	cmp	dword ptr [ebp-08h],01h;	lStrIndex
	jne	@BLBL63

; 168                 lFoundIndex = lIndex;
	mov	eax,[ebp-0ch];	lIndex
	mov	[ebp-014h],eax;	lFoundIndex
@BLBL63:

; 169               if (lStrIndex >= lSearchStrLen)
	mov	eax,dword ptr  lSearchStrLen
	cmp	[ebp-08h],eax;	lStrIndex
	jl	@BLBL54

; 170                 {
; 171                 lIndex = lFoundIndex;
	mov	eax,[ebp-014h];	lFoundIndex
	mov	[ebp-0ch],eax;	lIndex

; 172                 goto gtGotIndex;
	jmp	gtGotIndex53
	align 010h
@BLBL60:

; 173                 }
; 174               }
; 175             }
; 176           else
; 177             {
; 178             if (toupper((BYTE)swSearchString[lStrIndex++]) != toupper((BYTE)usEvent))
	mov	eax,dword ptr  _ctype
	mov	ecx,[ebp-08h];	lStrIndex
	mov	cl,byte ptr [ecx*02h+swSearchString]
	and	ecx,0ffh
	mov	edx,dword ptr  _ctype
	mov	bl,[ebp-010h];	usEvent
	and	ebx,0ffh
	mov	dx,word ptr [edx+ebx*02h+0202h]
	cmp	word ptr [eax+ecx*02h+0202h],dx
	je	@BLBL66
	mov	eax,[ebp-08h];	lStrIndex
	inc	eax
	mov	[ebp-08h],eax;	lStrIndex

; 179               lStrIndex = 0;
	mov	dword ptr [ebp-08h],0h;	lStrIndex
	jmp	@BLBL54
	align 010h
@BLBL66:
	mov	eax,[ebp-08h];	lStrIndex
	inc	eax
	mov	[ebp-08h],eax;	lStrIndex

; 180             else
; 181               {
; 182               if (lStrIndex == 1)
	cmp	dword ptr [ebp-08h],01h;	lStrIndex
	jne	@BLBL68

; 183                 lFoundIndex = lIndex;
	mov	eax,[ebp-0ch];	lIndex
	mov	[ebp-014h],eax;	lFoundIndex
@BLBL68:

; 184               if (lStrIndex >= lSearchStrLen)
	mov	eax,dword ptr  lSearchStrLen
	cmp	[ebp-08h],eax;	lStrIndex
	jl	@BLBL54

; 185                 {
; 186                 lIndex = lFoundIndex;
	mov	eax,[ebp-014h];	lFoundIndex
	mov	[ebp-0ch],eax;	lIndex

; 187                 goto gtGotIndex;
	jmp	gtGotIndex53
	align 010h
@BLBL54:

; 188                 }
; 189               }
; 190             }
; 191           }
; 192         }
; 193       }

; 138     for (lIndex = lStartIndex;lIndex < lBufLength;lIndex++)
	mov	eax,[ebp-0ch];	lIndex
	inc	eax
	mov	[ebp-0ch],eax;	lIndex
	mov	eax,[ebp+0ch];	lBufLength
	cmp	[ebp-0ch],eax;	lIndex
	jl	@BLBL51

; 194     }
	jmp	@BLBL71
	align 010h
@BLBL48:

; 197     lStartIndex--;
	mov	eax,[ebp-04h];	lStartIndex
	dec	eax
	mov	[ebp-04h],eax;	lStartIndex

; 198     if (lStartIndex < 0)
	cmp	dword ptr [ebp-04h],0h;	lStartIndex
	jge	@BLBL72

; 199       return(-1);
	or	eax,0ffffffffh
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL72:

; 200     lStrIndex = lSearchStrLen;
	mov	eax,dword ptr  lSearchStrLen
	mov	[ebp-08h],eax;	lStrIndex

; 201     for (lIndex = lStartIndex;lIndex >= 0;lIndex--)
	mov	eax,[ebp-04h];	lStartIndex
	mov	[ebp-0ch],eax;	lIndex
	cmp	dword ptr [ebp-0ch],0h;	lIndex
	jl	@BLBL71
	align 010h
@BLBL74:

; 203       usEvent = pusBuffer[lIndex];
	mov	eax,[ebp+08h];	pusBuffer
	mov	ebx,[ebp-0ch];	lIndex
	mov	ax,word ptr [eax+ebx*02h]
	mov	[ebp-010h],ax;	usEvent

; 204       if (SearchTraceEvent(usEvent))
	mov	ax,[ebp-010h];	usEvent
	push	eax
	call	SearchTraceEvent
	add	esp,04h
	test	eax,eax
	jne	gtGotIndex53

; 206       if (stCFG.bFindString)
	test	byte ptr  stCFG+01dh,02h
	je	@BLBL76

; 208         if ((usEvent & 0xff00) == usDirection)
	mov	ax,[ebp-010h];	usEvent
	and	ax,0ff00h
	cmp	[ebp-0eh],ax;	usDirection
	jne	@BLBL76

; 210           if (!stCFG.bFindStrNoCase)
	test	byte ptr  stCFG+01eh,020h
	jne	@BLBL78

; 212             if (swSearchString[--lStrIndex] != pusBuffer[lIndex])
	mov	eax,[ebp-08h];	lStrIndex
	dec	eax
	mov	[ebp-08h],eax;	lStrIndex
	mov	ebx,[ebp+08h];	pusBuffer
	mov	ecx,[ebp-0ch];	lIndex
	mov	eax,[ebp-08h];	lStrIndex
	mov	bx,word ptr [ebx+ecx*02h]
	cmp	word ptr [eax*02h+swSearchString],bx
	je	@BLBL80

; 213               lStrIndex = lSearchStrLen;
	mov	eax,dword ptr  lSearchStrLen
	mov	[ebp-08h],eax;	lStrIndex

; 214             }
	jmp	@BLBL80
	align 010h
@BLBL78:

; 217             if (toupper((BYTE)swSearchString[--lStrIndex]) != toupper((BYTE)pusBuffer[lIndex]))
	mov	eax,[ebp-08h];	lStrIndex
	dec	eax
	mov	[ebp-08h],eax;	lStrIndex
	mov	ecx,dword ptr  _ctype
	mov	edx,[ebp+08h];	pusBuffer
	mov	eax,[ebp-0ch];	lIndex
	mov	dl,byte ptr [edx+eax*02h]
	and	edx,0ffh
	mov	eax,dword ptr  _ctype
	mov	ebx,[ebp-08h];	lStrIndex
	mov	bl,byte ptr [ebx*02h+swSearchString]
	and	ebx,0ffh
	mov	cx,word ptr [ecx+edx*02h+0202h]
	cmp	word ptr [eax+ebx*02h+0202h],cx
	je	@BLBL80

; 218               lStrIndex = lSearchStrLen;
	mov	eax,dword ptr  lSearchStrLen
	mov	[ebp-08h],eax;	lStrIndex

; 219             }
@BLBL80:

; 220           if (lStrIndex <= 0)
	cmp	dword ptr [ebp-08h],0h;	lStrIndex
	jle	gtGotIndex53

; 222           }

; 223         }
@BLBL76:

; 224       }

; 201     for (lIndex = lStartIndex;lIndex >= 0;lIndex--)
	mov	eax,[ebp-0ch];	lIndex
	dec	eax
	mov	[ebp-0ch],eax;	lIndex
	cmp	dword ptr [ebp-0ch],0h;	lIndex
	jge	@BLBL74

; 225     }
@BLBL71:

; 226   if (stCFG.bFindWrap)
	test	byte ptr  stCFG+01ch,080h
	je	@BLBL84

; 228     if (stCFG.bFindForward)
	test	byte ptr  stCFG+01dh,01h
	je	@BLBL85

; 230       lStrIndex = 0;
	mov	dword ptr [ebp-08h],0h;	lStrIndex

; 231       for (lIndex = 0;lIndex <= lStartIndex;lIndex++)
	mov	dword ptr [ebp-0ch],0h;	lIndex
	mov	eax,[ebp-04h];	lStartIndex
	cmp	[ebp-0ch],eax;	lIndex
	jg	@BLBL84
	align 010h
@BLBL87:

; 233         usEvent = pusBuffer[lIndex];
	mov	eax,[ebp+08h];	pusBuffer
	mov	ebx,[ebp-0ch];	lIndex
	mov	ax,word ptr [eax+ebx*02h]
	mov	[ebp-010h],ax;	usEvent

; 234         if (SearchTraceEvent(usEvent))
	mov	ax,[ebp-010h];	usEvent
	push	eax
	call	SearchTraceEvent
	add	esp,04h
	test	eax,eax
	jne	gtGotIndex53

; 236         if (stCFG.bFindString)
	test	byte ptr  stCFG+01dh,02h
	je	@BLBL89

; 238           if ((usEvent & 0xff00) == usDirection)
	mov	ax,[ebp-010h];	usEvent
	and	ax,0ff00h
	cmp	[ebp-0eh],ax;	usDirection
	jne	@BLBL89

; 240             if (!stCFG.bFindStrNoCase)
	test	byte ptr  stCFG+01eh,020h
	jne	@BLBL91

; 242               if (swSearchString[lStrIndex++] != usEvent)
	mov	eax,[ebp-08h];	lStrIndex
	mov	bx,[ebp-010h];	usEvent
	cmp	word ptr [eax*02h+swSearchString],bx
	je	@BLBL92
	mov	eax,[ebp-08h];	lStrIndex
	inc	eax
	mov	[ebp-08h],eax;	lStrIndex

; 243                 lStrIndex = 0;
	mov	dword ptr [ebp-08h],0h;	lStrIndex
	jmp	@BLBL89
	align 010h
@BLBL92:
	mov	eax,[ebp-08h];	lStrIndex
	inc	eax
	mov	[ebp-08h],eax;	lStrIndex

; 246                 if (lStrIndex == 1)
	cmp	dword ptr [ebp-08h],01h;	lStrIndex
	jne	@BLBL94

; 247                   lFoundIndex = lIndex;
	mov	eax,[ebp-0ch];	lIndex
	mov	[ebp-014h],eax;	lFoundIndex
@BLBL94:

; 248                 if (lStrIndex >= lSearchStrLen)
	mov	eax,dword ptr  lSearchStrLen
	cmp	[ebp-08h],eax;	lStrIndex
	jl	@BLBL89

; 250                   lIndex = lFoundIndex;
	mov	eax,[ebp-014h];	lFoundIndex
	mov	[ebp-0ch],eax;	lIndex

; 251                   goto gtGotIndex;
	jmp	gtGotIndex53
	align 010h
@BLBL91:

; 257               if (toupper((BYTE)swSearchString[lStrIndex++]) != toupper((BYTE)usEvent))
	mov	eax,dword ptr  _ctype
	mov	ebx,[ebp-08h];	lStrIndex
	mov	bl,byte ptr [ebx*02h+swSearchString]
	and	ebx,0ffh
	mov	ecx,dword ptr  _ctype
	mov	dl,[ebp-010h];	usEvent
	and	edx,0ffh
	mov	cx,word ptr [ecx+edx*02h+0202h]
	cmp	word ptr [eax+ebx*02h+0202h],cx
	je	@BLBL97
	mov	eax,[ebp-08h];	lStrIndex
	inc	eax
	mov	[ebp-08h],eax;	lStrIndex

; 258                 lStrIndex = 0;
	mov	dword ptr [ebp-08h],0h;	lStrIndex
	jmp	@BLBL89
	align 010h
@BLBL97:
	mov	eax,[ebp-08h];	lStrIndex
	inc	eax
	mov	[ebp-08h],eax;	lStrIndex

; 261                 if (lStrIndex == 1)
	cmp	dword ptr [ebp-08h],01h;	lStrIndex
	jne	@BLBL99

; 262                   lFoundIndex = lIndex;
	mov	eax,[ebp-0ch];	lIndex
	mov	[ebp-014h],eax;	lFoundIndex
@BLBL99:

; 263                 if (lStrIndex >= lSearchStrLen)
	mov	eax,dword ptr  lSearchStrLen
	cmp	[ebp-08h],eax;	lStrIndex
	jl	@BLBL89

; 265                   lIndex = lFoundIndex;
	mov	eax,[ebp-014h];	lFoundIndex
	mov	[ebp-0ch],eax;	lIndex

; 266                   goto gtGotIndex;
	jmp	gtGotIndex53
	align 010h
@BLBL89:

; 272         }

; 231       for (lIndex = 0;lIndex <= lStartIndex;lIndex++)
	mov	eax,[ebp-0ch];	lIndex
	inc	eax
	mov	[ebp-0ch],eax;	lIndex
	mov	eax,[ebp-04h];	lStartIndex
	cmp	[ebp-0ch],eax;	lIndex
	jle	@BLBL87

; 273       }
	jmp	@BLBL84
	align 010h
@BLBL85:

; 276       lStrIndex = lSearchStrLen;
	mov	eax,dword ptr  lSearchStrLen
	mov	[ebp-08h],eax;	lStrIndex

; 277       for (lIndex = (lBufLength - 1);lIndex >= lStartIndex;lIndex--)
	mov	eax,[ebp+0ch];	lBufLength
	dec	eax
	mov	[ebp-0ch],eax;	lIndex
	mov	eax,[ebp-04h];	lStartIndex
	cmp	[ebp-0ch],eax;	lIndex
	jl	@BLBL84
	align 010h
@BLBL104:

; 279         usEvent = pusBuffer[lIndex];
	mov	eax,[ebp+08h];	pusBuffer
	mov	ebx,[ebp-0ch];	lIndex
	mov	ax,word ptr [eax+ebx*02h]
	mov	[ebp-010h],ax;	usEvent

; 280         if (SearchTraceEvent(usEvent))
	mov	ax,[ebp-010h];	usEvent
	push	eax
	call	SearchTraceEvent
	add	esp,04h
	test	eax,eax
	jne	gtGotIndex53

; 282         if (stCFG.bFindString)
	test	byte ptr  stCFG+01dh,02h
	je	@BLBL106

; 284           if ((usEvent & 0xff00) == usDirection)
	mov	ax,[ebp-010h];	usEvent
	and	ax,0ff00h
	cmp	[ebp-0eh],ax;	usDirection
	jne	@BLBL106

; 286             if (!stCFG.bFindStrNoCase)
	test	byte ptr  stCFG+01eh,020h
	jne	@BLBL108

; 288               if (swSearchString[--lStrIndex] != usEvent)
	mov	eax,[ebp-08h];	lStrIndex
	dec	eax
	mov	[ebp-08h],eax;	lStrIndex
	mov	eax,[ebp-08h];	lStrIndex
	mov	bx,[ebp-010h];	usEvent
	cmp	word ptr [eax*02h+swSearchString],bx
	je	@BLBL110

; 289                 lStrIndex = lSearchStrLen;
	mov	eax,dword ptr  lSearchStrLen
	mov	[ebp-08h],eax;	lStrIndex

; 290               }
	jmp	@BLBL110
	align 010h
@BLBL108:

; 293               if (toupper((BYTE)swSearchString[--lStrIndex]) != toupper((BYTE)usEvent))
	mov	eax,[ebp-08h];	lStrIndex
	dec	eax
	mov	[ebp-08h],eax;	lStrIndex
	mov	eax,dword ptr  _ctype
	mov	ebx,[ebp-08h];	lStrIndex
	mov	bl,byte ptr [ebx*02h+swSearchString]
	and	ebx,0ffh
	mov	ecx,dword ptr  _ctype
	mov	dl,[ebp-010h];	usEvent
	and	edx,0ffh
	mov	cx,word ptr [ecx+edx*02h+0202h]
	cmp	word ptr [eax+ebx*02h+0202h],cx
	je	@BLBL110

; 294                 lStrIndex = lSearchStrLen;
	mov	eax,dword ptr  lSearchStrLen
	mov	[ebp-08h],eax;	lStrIndex

; 295               }
@BLBL110:

; 296             if (lStrIndex <= 0)
	cmp	dword ptr [ebp-08h],0h;	lStrIndex
	jle	gtGotIndex53

; 298             }

; 299           }
@BLBL106:

; 300         }

; 277       for (lIndex = (lBufLength - 1);lIndex >= lStartIndex;lIndex--)
	mov	eax,[ebp-0ch];	lIndex
	dec	eax
	mov	[ebp-0ch],eax;	lIndex
	mov	eax,[ebp-04h];	lStartIndex
	cmp	[ebp-0ch],eax;	lIndex
	jge	@BLBL104

; 301       }

; 302     }
@BLBL84:

; 303   return(-1);
	or	eax,0ffffffffh
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
gtGotIndex53:

; 306   if (stCFG.bColumnDisplay)
	test	byte ptr  stCFG+018h,080h
	je	@BLBL114

; 308     stRead.lScrollIndex = lIndex;
	mov	eax,[ebp-0ch];	lIndex
	mov	dword ptr  stRead+06fh,eax

; 309     lCharCount = GetDisplayCount(lIndex);
	push	dword ptr [ebp-0ch];	lIndex
	call	GetDisplayCount
	add	esp,04h
	mov	[ebp-018h],eax;	lCharCount

; 310     stRead.lScrollRow = (lCharCount / stRead.lCharWidth);
	mov	eax,[ebp-018h];	lCharCount
	cdq	
	idiv	dword ptr  stRead+027h
	mov	dword ptr  stRead+06bh,eax

; 311     if (stRead.hwndScroll != 0)
	cmp	dword ptr  stRead+05fh,0h
	je	@BLBL115

; 312       WinSendMsg(stRead.hwndScroll,SBM_SETSCROLLBAR,MPFROMSHORT(stRead.lScrollRow),MPFROM2SHORT(0,stRead.lScrollRowCount));
	mov	ax,word ptr  stRead+067h
	and	eax,0ffffh
	sal	eax,010h
	push	eax
	mov	ax,word ptr  stRead+06bh
	and	eax,0ffffh
	push	eax
	push	01a0h
	push	dword ptr  stRead+05fh
	call	WinSendMsg
	add	esp,010h
@BLBL115:

; 313     WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE)
; 313 ;
	push	0h
	push	0h
	push	dword ptr  stRead+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 314     stWrite.lScrollIndex = lIndex;
	mov	eax,[ebp-0ch];	lIndex
	mov	dword ptr  stWrite+06fh,eax

; 315     lCharCount = GetDisplayCount(lIndex);
	push	dword ptr [ebp-0ch];	lIndex
	call	GetDisplayCount
	add	esp,04h
	mov	[ebp-018h],eax;	lCharCount

; 316     stWrite.lScrollRow = (lCharCount / stWrite.lCharWidth);
	mov	eax,[ebp-018h];	lCharCount
	cdq	
	idiv	dword ptr  stWrite+027h
	mov	dword ptr  stWrite+06bh,eax

; 317     if (stWrite.hwndScroll != 0)
	cmp	dword ptr  stWrite+05fh,0h
	je	@BLBL116

; 318       WinSendMsg(stWrite.hwndScroll,SBM_SETSCROLLBAR,MPFROMSHORT(stWrite.lScrollRow),MPFROM2SHORT(0,stWrite.lScrollRowCount));
	mov	ax,word ptr  stWrite+067h
	and	eax,0ffffh
	sal	eax,010h
	push	eax
	mov	ax,word ptr  stWrite+06bh
	and	eax,0ffffh
	push	eax
	push	01a0h
	push	dword ptr  stWrite+05fh
	call	WinSendMsg
	add	esp,010h
@BLBL116:

; 319     WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stWrite+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 320     }
	jmp	@BLBL117
	align 010h
@BLBL114:

; 323     stRow.lScrollIndex = lIndex;
	mov	eax,[ebp-0ch];	lIndex
	mov	dword ptr  stRow+06fh,eax

; 324     lCharCount = GetDisplayCount(lIndex);
	push	dword ptr [ebp-0ch];	lIndex
	call	GetDisplayCount
	add	esp,04h
	mov	[ebp-018h],eax;	lCharCount

; 325     stRow.lScrollRow = (lCharCount / stRow.lCharWidth);
	mov	eax,[ebp-018h];	lCharCount
	cdq	
	idiv	dword ptr  stRow+027h
	mov	dword ptr  stRow+06bh,eax

; 326     WinSendMsg(stRow.hwndScroll,SBM_SETSCROLLBAR,MPFROMSHORT(stRow.lScrollRow),MPFROM2SHORT(0,stRow.lScrollRowCount));
	mov	ax,word ptr  stRow+067h
	and	eax,0ffffh
	sal	eax,010h
	push	eax
	mov	ax,word ptr  stRow+06bh
	and	eax,0ffffh
	push	eax
	push	01a0h
	push	dword ptr  stRow+05fh
	call	WinSendMsg
	add	esp,010h

; 327     }
@BLBL117:

; 328   return(lIndex);
	mov	eax,[ebp-0ch];	lIndex
	add	esp,0ch
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret	
SearchCaptureBuffer	endp

; 332   {
	align 010h

	public fnwpSearchConfigDlgProc
fnwpSearchConfigDlgProc	proc
	push	ebp
	mov	ebp,esp
	sub	esp,02dch
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,0b7h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 343   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL207
	align 04h
@BLBL208:

; 344     {
; 345     case WM_INITDLG:
; 346       CenterDlgBox(hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	call	CenterDlgBox
	add	esp,04h

; 347 //      WinSetFocus(HWND_DESKTOP,hwndDlg);
; 348       pstCFG = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @46pstCFG,eax

; 349       bAllowClick = FALSE;
	mov	dword ptr  @47bAllowClick,0h

; 350       WinSendDlgItemMsg(hwndDlg,FIND_STR,EM_SETTEXTLIMIT,MPFROMSHORT(MAX_SEARCH_STRING),(MPARAM)NULL);
	push	0h
	push	0200h
	push	0143h
	push	01968h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 351       usDirection = CS_READ;
	mov	dword ptr  @49usDirection,04000h

; 352       if (pstCFG->bFindStrNoCase)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01eh],020h
	je	@BLBL118

; 353         CheckButton(hwndDlg,FIND_STR_NO_CASE,TRUE);
	push	01h
	push	01982h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL118:

; 354       if (pstCFG->bFindStrHEX)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01eh],010h
	je	@BLBL119

; 355         CheckButton(hwndDlg,FIND_STR_HEX,TRUE);
	push	01h
	push	0196ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL120
	align 010h
@BLBL119:

; 356       else
; 357         CheckButton(hwndDlg,FIND_STR_ASCII,TRUE);
	push	01h
	push	01969h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL120:

; 358       if (lSearchStrLen > 0)
	cmp	dword ptr  lSearchStrLen,0h
	jle	@BLBL121

; 359         {
; 360         if (pstCFG->bFindStrHEX)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01eh],010h
	je	@BLBL122

; 361           {
; 362           ControlEnable(hwndDlg,FIND_STR_NO_CASE,FALSE);
	push	0h
	push	01982h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 363           lHexIndex = 0;
	mov	dword ptr [ebp-0210h],0h;	lHexIndex

; 364           for (lIndex = 0;lIndex < lSearchStrLen;lIndex++)
	mov	dword ptr [ebp-020ch],0h;	lIndex
	mov	eax,dword ptr  lSearchStrLen
	cmp	[ebp-020ch],eax;	lIndex
	jge	@BLBL123
	align 010h
@BLBL124:

; 365             {
; 366             sprintf(&szSearchString[lHexIndex],"%02X",(swSearchString[lIndex] & 0x00ff));
	mov	ecx,[ebp-020ch];	lIndex
	xor	eax,eax
	mov	ax,word ptr [ecx*02h+swSearchString]
	and	eax,0ffh
	push	eax
	mov	edx,offset FLAT:@STAT1
	mov	eax,[ebp-0210h];	lHexIndex
	lea	eax,dword ptr [ebp+eax-0202h]
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 367             lHexIndex += 2;
	mov	eax,[ebp-0210h];	lHexIndex
	add	eax,02h
	mov	[ebp-0210h],eax;	lHexIndex

; 368             }

; 364           for (lIndex = 0;lIndex < lSearchStrLen;lIndex++)
	mov	eax,[ebp-020ch];	lIndex
	inc	eax
	mov	[ebp-020ch],eax;	lIndex
	mov	eax,dword ptr  lSearchStrLen
	cmp	[ebp-020ch],eax;	lIndex
	jl	@BLBL124
@BLBL123:

; 369           szSearchString[lHexIndex] = 0;
	mov	eax,[ebp-0210h];	lHexIndex
	mov	byte ptr [ebp+eax-0202h],0h

; 370           }
	jmp	@BLBL126
	align 010h
@BLBL122:

; 373           for (lIndex = 0;lIndex < lSearchStrLen;lIndex++)
	mov	dword ptr [ebp-020ch],0h;	lIndex
	mov	eax,dword ptr  lSearchStrLen
	cmp	[ebp-020ch],eax;	lIndex
	jge	@BLBL127
	align 010h
@BLBL128:

; 374             szSearchString[lIndex] = (BYTE)swSearchString[lIndex];
	mov	eax,[ebp-020ch];	lIndex
	mov	cx,word ptr [eax*02h+swSearchString]
	mov	eax,[ebp-020ch];	lIndex
	mov	byte ptr [ebp+eax-0202h],cl

; 373           for (lIndex = 0;lIndex < lSearchStrLen;lIndex++)
	mov	eax,[ebp-020ch];	lIndex
	inc	eax
	mov	[ebp-020ch],eax;	lIndex
	mov	eax,dword ptr  lSearchStrLen
	cmp	[ebp-020ch],eax;	lIndex
	jl	@BLBL128
@BLBL127:

; 375           szSearchString[lIndex] = 0;
	mov	eax,[ebp-020ch];	lIndex
	mov	byte ptr [ebp+eax-0202h],0h

; 376           }
@BLBL126:

; 377         WinSetDlgItemText(hwndDlg,FIND_STR,szSearchString);
	lea	eax,[ebp-0202h];	szSearchString
	push	eax
	push	01968h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 378         if (pstCFG->bFindString)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01dh],02h
	je	@BLBL130

; 380           usDirection = (swSearchString[0] & 0xff00);
	xor	eax,eax
	mov	ax,word ptr  swSearchString
	and	eax,0ff00h
	mov	dword ptr  @49usDirection,eax

; 381           if (usDirection == CS_READ)
	cmp	dword ptr  @49usDirection,04000h
	jne	@BLBL131

; 382             CheckButton(hwndDlg,FIND_STR_RX,TRUE);
	push	01h
	push	01967h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL134
	align 010h
@BLBL131:

; 384             CheckButton(hwndDlg,FIND_STR_TX,TRUE);
	push	01h
	push	01966h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 385           }
	jmp	@BLBL134
	align 010h
@BLBL130:

; 388           CheckButton(hwndDlg,FIND_STR_NONE,TRUE);
	push	01h
	push	01965h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 389           ControlEnable(hwndDlg,FIND_STR,FALSE);
	push	0h
	push	01968h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 390           ControlEnable(hwndDlg,FIND_STR_ASCII,FALSE);
	push	0h
	push	01969h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 391           ControlEnable(hwndDlg,FIND_STR_NO_CASE,FALSE);
	push	0h
	push	01982h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 392           ControlEnable(hwndDlg,FIND_STR_HEX,FALSE);
	push	0h
	push	0196ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 393           }

; 394         }
	jmp	@BLBL134
	align 010h
@BLBL121:

; 397         CheckButton(hwndDlg,FIND_STR_NONE,TRUE);
	push	01h
	push	01965h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 398         ControlEnable(hwndDlg,FIND_STR,FALSE);
	push	0h
	push	01968h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 399         ControlEnable(hwndDlg,FIND_STR_ASCII,FALSE);
	push	0h
	push	01969h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 400         ControlEnable(hwndDlg,FIND_STR_NO_CASE,FALSE);
	push	0h
	push	01982h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 401         ControlEnable(hwndDlg,FIND_STR_HEX,FALSE);
	push	0h
	push	0196ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 402         }
@BLBL134:

; 403       if (pstCFG->bFindStrHEX)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01eh],010h
	je	@BLBL135

; 404         CheckButton(hwndDlg,FIND_STR_HEX,TRUE);
	push	01h
	push	0196ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL136
	align 010h
@BLBL135:

; 406         CheckButton(hwndDlg,FIND_STR_ASCII,TRUE);
	push	01h
	push	01969h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL136:

; 407       if (pstCFG->bFindWrap)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01ch],080h
	je	@BLBL137

; 408         CheckButton(hwndDlg,FIND_WRAP,TRUE);
	push	01h
	push	0197fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL137:

; 409       if (pstCFG->bFindForward)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01dh],01h
	je	@BLBL138

; 410         CheckButton(hwndDlg,FIND_NEXT,TRUE);
	push	01h
	push	0197eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL139
	align 010h
@BLBL138:

; 412         CheckButton(hwndDlg,FIND_PREVIOUS,TRUE);
	push	01h
	push	0197dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL139:

; 413       if (pstCFG->bFindModemIn)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01dh],020h
	je	@BLBL140

; 414         CheckButton(hwndDlg,FIND_MODEMIN,TRUE);
	push	01h
	push	0196fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL140:

; 415       if (pstCFG->bFindModemOut)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01dh],040h
	je	@BLBL141

; 416         CheckButton(hwndDlg,FIND_MODEMOUT,TRUE);
	push	01h
	push	0196eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL141:

; 417       if (pstCFG->bFindWriteReq)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01eh],01h
	je	@BLBL142

; 418         CheckButton(hwndDlg,FIND_WRITE_REQ,TRUE);
	push	01h
	push	01975h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL142:

; 419       if (pstCFG->bFindReadReq)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01eh],02h
	je	@BLBL143

; 420         CheckButton(hwndDlg,FIND_READ_REQ,TRUE);
	push	01h
	push	01976h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL143:

; 421       if (pstCFG->bFindDevIOctl)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01eh],04h
	je	@BLBL144

; 422         CheckButton(hwndDlg,FIND_DEVIOCTL,TRUE);
	push	01h
	push	01973h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL144:

; 423       if (pstCFG->bFindErrors)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01eh],08h
	je	@BLBL145

; 424         CheckButton(hwndDlg,FIND_ERRORS,TRUE);
	push	01h
	push	01978h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL145:

; 425       if (pstCFG->bFindOpen)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01dh],080h
	je	@BLBL146

; 426         CheckButton(hwndDlg,FIND_OPEN,TRUE);
	push	01h
	push	01979h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL146:

; 427       if (pstCFG->bFindRead)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01dh],04h
	je	@BLBL147

; 428         CheckButton(hwndDlg,FIND_RCV,TRUE);
	push	01h
	push	01981h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL147:

; 429       if (pstCFG->bFindWrite)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01dh],08h
	je	@BLBL148

; 430         CheckButton(hwndDlg,FIND_XMIT,TRUE);
	push	01h
	push	01980h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL148:

; 431       if (pstCFG->bFindIMM)
	mov	eax,dword ptr  @46pstCFG
	test	byte ptr [eax+01dh],010h
	je	@BLBL149

; 432         CheckButton(hwndDlg,FIND_IMM,TRUE);
	push	01h
	push	01974h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL149:

; 433       WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	08002h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinPostMsg
	add	esp,010h

; 434       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL209:

; 436       bAllowClick = TRUE;
	mov	dword ptr  @47bAllowClick,01h

; 437       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL210:

; 439       if ((SHORT2FROMMP(mp1) == BN_CLICKED) && bAllowClick)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL150
	cmp	dword ptr  @47bAllowClick,0h
	je	@BLBL150

; 441         switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL212
	align 04h
@BLBL213:

; 444             if (!Checked(hwndDlg,FIND_STR_HEX))
	push	0196ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL151

; 446               CheckButton(hwndDlg,FIND_STR_HEX,TRUE);
	push	01h
	push	0196ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 447               CheckButton(hwndDlg,FIND_STR_ASCII,FALSE);
	push	0h
	push	01969h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 448               ControlEnable(hwndDlg,FIND_STR_NO_CASE,FALSE);
	push	0h
	push	01982h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 449               }
@BLBL151:

; 450             break;
	jmp	@BLBL211
	align 04h
@BLBL214:

; 452             if (!Checked(hwndDlg,FIND_STR_ASCII))
	push	01969h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL152

; 454               CheckButton(hwndDlg,FIND_STR_ASCII,TRUE);
	push	01h
	push	01969h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 455               CheckButton(hwndDlg,FIND_STR_HEX,FALSE);
	push	0h
	push	0196ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 456               ControlEnable(hwndDlg,FIND_STR_NO_CASE,TRUE);
	push	01h
	push	01982h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 457               }
@BLBL152:

; 458             break;
	jmp	@BLBL211
	align 04h
@BLBL215:

; 460             if (!Checked(hwndDlg,FIND_STR_NONE))
	push	01965h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL153

; 462               CheckButton(hwndDlg,FIND_STR_NONE,TRUE);
	push	01h
	push	01965h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 463               CheckButton(hwndDlg,FIND_STR_RX,FALSE);
	push	0h
	push	01967h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 464               CheckButton(hwndDlg,FIND_STR_TX,FALSE);
	push	0h
	push	01966h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 465               ControlEnable(hwndDlg,FIND_STR,FALSE);
	push	0h
	push	01968h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 466               ControlEnable(hwndDlg,FIND_STR_ASCII,FALSE);
	push	0h
	push	01969h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 467               ControlEnable(hwndDlg,FIND_STR_HEX,FALSE);
	push	0h
	push	0196ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 468               ControlEnable(hwndDlg,FIND_STR_NO_CASE,FALSE);
	push	0h
	push	01982h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 469               }
@BLBL153:

; 470             break;
	jmp	@BLBL211
	align 04h
@BLBL216:

; 472             if (!Checked(hwndDlg,FIND_STR_RX))
	push	01967h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL154

; 474               CheckButton(hwndDlg,FIND_STR_RX,TRUE);
	push	01h
	push	01967h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 475               CheckButton(hwndDlg,FIND_STR_TX,FALSE);
	push	0h
	push	01966h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 476               if (Checked(hwndDlg,FIND_STR_NONE))
	push	01965h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL154

; 478                 if (Checked(hwndDlg,FIND_STR_ASCII))
	push	01969h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL156

; 479                   ControlEnable(hwndDlg,FIND_STR_NO_CASE,TRUE);
	push	01h
	push	01982h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
@BLBL156:

; 480                 CheckButton(hwndDlg,FIND_STR_NONE,FALSE);
	push	0h
	push	01965h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 481                 ControlEnable(hwndDlg,FIND_STR,TRUE);
	push	01h
	push	01968h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 482                 ControlEnable(hwndDlg,FIND_STR_ASCII,TRUE);
	push	01h
	push	01969h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 483                 ControlEnable(hwndDlg,FIND_STR_HEX,TRUE);
	push	01h
	push	0196ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 484                 }

; 485               }
@BLBL154:

; 486             break;
	jmp	@BLBL211
	align 04h
@BLBL217:

; 488             if (!Checked(hwndDlg,FIND_STR_TX))
	push	01966h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL157

; 490               CheckButton(hwndDlg,FIND_STR_TX,TRUE);
	push	01h
	push	01966h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 491               CheckButton(hwndDlg,FIND_STR_RX,FALSE);
	push	0h
	push	01967h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 492               if (Checked(hwndDlg,FIND_STR_NONE))
	push	01965h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL157

; 494                 if (Checked(hwndDlg,FIND_STR_ASCII))
	push	01969h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL159

; 495                   ControlEnable(hwndDlg,FIND_STR_NO_CASE,TRUE);
	push	01h
	push	01982h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
@BLBL159:

; 496                 CheckButton(hwndDlg,FIND_STR_NONE,FALSE);
	push	0h
	push	01965h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 497                 ControlEnable(hwndDlg,FIND_STR,TRUE);
	push	01h
	push	01968h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 498                 ControlEnable(hwndDlg,FIND_STR_ASCII,TRUE);
	push	01h
	push	01969h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 499                 ControlEnable(hwndDlg,FIND_STR_HEX,TRUE);
	push	01h
	push	0196ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 500                 }

; 501               }
@BLBL157:

; 502             break;
	jmp	@BLBL211
	align 04h
@BLBL218:

; 504              return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
	jmp	@BLBL211
	align 04h
@BLBL212:
	cmp	eax,0196ah
	je	@BLBL213
	cmp	eax,01969h
	je	@BLBL214
	cmp	eax,01965h
	je	@BLBL215
	cmp	eax,01967h
	je	@BLBL216
	cmp	eax,01966h
	je	@BLBL217
	jmp	@BLBL218
	align 04h
@BLBL211:

; 506         return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL150:

; 508       break;
	jmp	@BLBL206
	align 04h
@BLBL219:

; 510       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL221
	align 04h
@BLBL222:

; 513           if ((lSearchStrLen = WinQueryDlgItemText(hwndDlg,FIND_STR,MAX_SEARCH_STRING,szSearchString)) == 0)
	lea	eax,[ebp-0202h];	szSearchString
	push	eax
	push	0200h
	push	01968h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinQueryDlgItemText
	add	esp,010h
	mov	dword ptr  lSearchStrLen,eax
	cmp	dword ptr  lSearchStrLen,0h
	jne	@BLBL160

; 515             if (!Checked(hwndDlg,FIND_STR_NONE))
	push	01965h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL161

; 516               if (WinMessageBox(HWND_DESKTOP,hwndDlg,"No character sequence will be searched","A character sequence was not entered.",0,(MB_OKCANCEL | MB_INFORMATION)) == MBID_CANCEL)
	push	031h
	push	0h
	push	offset FLAT:@STAT3
	push	offset FLAT:@STAT2
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,02h
	jne	@BLBL161

; 517                 return((MRESULT)TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL161:

; 518             pstCFG->bFindString = FALSE;
	mov	eax,dword ptr  @46pstCFG
	and	byte ptr [eax+01dh],0fdh

; 519             }
	jmp	@BLBL163
	align 010h
@BLBL160:

; 522             if (Checked(hwndDlg,FIND_STR_NONE))
	push	01965h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL164

; 523               pstCFG->bFindString = FALSE;
	mov	eax,dword ptr  @46pstCFG
	and	byte ptr [eax+01dh],0fdh
	jmp	@BLBL163
	align 010h
@BLBL164:

; 526               pstCFG->bFindString = TRUE;
	mov	eax,dword ptr  @46pstCFG
	or	byte ptr [eax+01dh],02h

; 527               if (Checked(hwndDlg,FIND_STR_NO_CASE))
	push	01982h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL166

; 528                 pstCFG->bFindStrNoCase = TRUE;
	mov	eax,dword ptr  @46pstCFG
	or	byte ptr [eax+01eh],020h
	jmp	@BLBL167
	align 010h
@BLBL166:

; 530                 pstCFG->bFindStrNoCase = FALSE;
	mov	eax,dword ptr  @46pstCFG
	and	byte ptr [eax+01eh],0dfh
@BLBL167:

; 531              
; 531  if (Checked(hwndDlg,FIND_STR_RX))
	push	01967h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL168

; 532                 usDirection = CS_READ;
	mov	dword ptr  @49usDirection,04000h
	jmp	@BLBL169
	align 010h
@BLBL168:

; 534                 usDirection = CS_WRITE;
	mov	dword ptr  @49usDirection,08000h
@BLBL169:

; 535               if (Checked(hwndDlg,FIND_STR_HEX))
	push	0196ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL170

; 537                 if (lSearchStrLen % 2)
	mov	eax,dword ptr  lSearchStrLen
	cdq	
	xor	eax,edx
	sub	eax,edx
	and	eax,01h
	xor	eax,edx
	sub	eax,edx
	test	eax,eax
	je	@BLBL171

; 539                   lLen = sprintf(szMessage,"A zero will be assumed before the last digit.\n\n%s will changed to ",szSearchString);
	lea	eax,[ebp-0202h];	szSearchString
	push	eax
	mov	edx,offset FLAT:@STAT4
	lea	eax,[ebp-02d8h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	mov	[ebp-02dch],eax;	lLen

; 540                   szSearchString[lSearchStrLen] = szSearchString[lSearchStrLen - 1];
	mov	eax,dword ptr  lSearchStrLen
	mov	cl,byte ptr [ebp+eax-0203h]
	mov	eax,dword ptr  lSearchStrLen
	mov	byte ptr [ebp+eax-0202h],cl

; 541                   szSearchString[lSearchStrLen - 1] = '0';
	mov	eax,dword ptr  lSearchStrLen
	mov	byte ptr [ebp+eax-0203h],030h

; 542                   szSearchString[++lSearchStrLen] = 0;
	mov	eax,dword ptr  lSearchStrLen
	inc	eax
	mov	dword ptr  lSearchStrLen,eax
	mov	eax,dword ptr  lSearchStrLen
	mov	byte ptr [ebp+eax-0202h],0h

; 543                   strcpy(&szMessage[lLen],szSearchString);
	lea	edx,[ebp-0202h];	szSearchString
	mov	eax,[ebp-02dch];	lLen
	lea	eax,dword ptr [ebp+eax-02d8h]
	call	strcpy

; 544                   if (WinMessageBox(HWND_DESKTOP,hwndDlg,szMessage,"An even number of digits were not entered.",0,(MB_OKCANCEL | MB_INFORMATION)) == MBID_CANCEL)
	push	031h
	push	0h
	push	offset FLAT:@STAT5
	lea	eax,[ebp-02d8h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,02h
	jne	@BLBL171

; 545                     return((MRESULT)TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL171:

; 547                 stCFG.bFindStrHEX = TRUE;
	or	byte ptr  stCFG+01eh,010h

; 548                 szHexByte[2] = 0;
	mov	byte ptr [ebp-0204h],0h;	szHexByte

; 549                 for (lIndex = 0;lIndex < lSearchStrLen ;lIndex += 2)
	mov	dword ptr [ebp-020ch],0h;	lIndex
	mov	eax,dword ptr  lSearchStrLen
	cmp	[ebp-020ch],eax;	lIndex
	jge	@BLBL173
	align 010h
@BLBL174:

; 551                   if (!isxdigit(szSearchString[lIndex]) || !isxdigit(szSearchString[lIndex + 1]))
	mov	ecx,dword ptr  _ctype
	mov	eax,[ebp-020ch];	lIndex
	xor	edx,edx
	mov	dl,byte ptr [ebp+eax-0202h]
	xor	eax,eax
	mov	ax,word ptr [ecx+edx*02h]
	and	eax,01h
	test	eax,eax
	je	@BLBL175
	mov	ecx,dword ptr  _ctype
	mov	eax,[ebp-020ch];	lIndex
	xor	edx,edx
	mov	dl,byte ptr [ebp+eax-0201h]
	xor	eax,eax
	mov	ax,word ptr [ecx+edx*02h]
	and	eax,01h
	test	eax,eax
	jne	@BLBL176
@BLBL175:

; 553                     MessageBox(hwndDlg,"Invalid charcters in string.\n\nAt least on of the characters in the search string is not a Hexadecimal number.");
	push	offset FLAT:@STAT6
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 554                     return((MRESULT)TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL176:

; 556                   szHexByte[0] = szSearchString[lIndex];
	mov	eax,[ebp-020ch];	lIndex
	mov	al,byte ptr [ebp+eax-0202h]
	mov	[ebp-0206h],al;	szHexByte

; 557                   szHexByte[1] = szSearchString[lIndex + 1];
	mov	eax,[ebp-020ch];	lIndex
	mov	al,byte ptr [ebp+eax-0201h]
	mov	[ebp-0205h],al;	szHexByte

; 558                   swSearchString[lIndex / 2] = (USHORT)(strtol(szHexByte,0,16) | usDirection);
	mov	ecx,010h
	xor	edx,edx
	lea	eax,[ebp-0206h];	szHexByte
	call	strtol
	mov	ecx,eax
	or	ecx,dword ptr  @49usDirection
	mov	eax,[ebp-020ch];	lIndex
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	mov	word ptr [eax*02h+swSearchString],cx

; 559                   }

; 549                 for (lIndex = 0;lIndex < lSearchStrLen ;lIndex += 2)
	mov	eax,[ebp-020ch];	lIndex
	add	eax,02h
	mov	[ebp-020ch],eax;	lIndex
	mov	eax,dword ptr  lSearchStrLen
	cmp	[ebp-020ch],eax;	lIndex
	jl	@BLBL174
@BLBL173:

; 560                 lSearchStrLen /= 2;
	mov	eax,dword ptr  lSearchStrLen
	cdq	
	and	edx,01h
	add	eax,edx
	sar	eax,01h
	mov	dword ptr  lSearchStrLen,eax

; 561                 }
	jmp	@BLBL163
	align 010h
@BLBL170:

; 564                 stCFG.bFindStrHEX = FALSE;
	and	byte ptr  stCFG+01eh,0efh

; 565                 for (lIndex = 0;lIndex < lSearchStrLen;lIndex++)
	mov	dword ptr [ebp-020ch],0h;	lIndex
	mov	eax,dword ptr  lSearchStrLen
	cmp	[ebp-020ch],eax;	lIndex
	jge	@BLBL163
	align 010h
@BLBL180:

; 566                   swSearchString[lIndex] = ((USHORT)(szSearchString[lIndex]) | usDirection);
	mov	eax,[ebp-020ch];	lIndex
	xor	ecx,ecx
	mov	cl,byte ptr [ebp+eax-0202h]
	or	ecx,dword ptr  @49usDirection
	mov	eax,[ebp-020ch];	lIndex
	mov	word ptr [eax*02h+swSearchString],cx

; 565                 for (lIndex = 0;lIndex < lSearchStrLen;lIndex++)
	mov	eax,[ebp-020ch];	lIndex
	inc	eax
	mov	[ebp-020ch],eax;	lIndex
	mov	eax,dword ptr  lSearchStrLen
	cmp	[ebp-020ch],eax;	lIndex
	jl	@BLBL180

; 567                 }

; 568               }

; 569             }
@BLBL163:

; 570           if (Checked(hwndDlg,FIND_WRAP))
	push	0197fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL182

; 571             pstCFG->bFindWrap = TRUE;
	mov	eax,dword ptr  @46pstCFG
	or	byte ptr [eax+01ch],080h
	jmp	@BLBL183
	align 010h
@BLBL182:

; 573             pstCFG->bFindWrap = FALSE;
	mov	eax,dword ptr  @46pstCFG
	and	byte ptr [eax+01ch],07fh
@BLBL183:

; 575           if (Checked(hwndDlg,FIND_NEXT))
	push	0197eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL184

; 576             pstCFG->bFindForward = TRUE;
	mov	eax,dword ptr  @46pstCFG
	or	byte ptr [eax+01dh],01h
	jmp	@BLBL185
	align 010h
@BLBL184:

; 578             pstCFG->bFindForward = FALSE;
	mov	eax,dword ptr  @46pstCFG
	and	byte ptr [eax+01dh],0feh
@BLBL185:

; 580           if (Checked(hwndDlg,FIND_MODEMIN))
	push	0196fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL186

; 581             pstCFG->bFindModemIn = TRUE;
	mov	eax,dword ptr  @46pstCFG
	or	byte ptr [eax+01dh],020h
	jmp	@BLBL187
	align 010h
@BLBL186:

; 583             pstCFG->bFindModemIn = FALSE;
	mov	eax,dword ptr  @46pstCFG
	and	byte ptr [eax+01dh],0dfh
@BLBL187:

; 585           if (Checked(hwndDlg,FIND_MODEMOUT))
	push	0196eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL188

; 586             pstCFG->bFindModemOut = TRUE;
	mov	eax,dword ptr  @46pstCFG
	or	byte ptr [eax+01dh],040h
	jmp	@BLBL189
	align 010h
@BLBL188:

; 588             pstCFG->bFindModemOut = FALSE;
	mov	eax,dword ptr  @46pstCFG
	and	byte ptr [eax+01dh],0bfh
@BLBL189:

; 590           if (Checked(hwndDlg,FIND_WRITE_REQ))
	push	01975h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL190

; 591             pstCFG->bFindWriteReq = TRUE;
	mov	eax,dword ptr  @46pstCFG
	or	byte ptr [eax+01eh],01h
	jmp	@BLBL191
	align 010h
@BLBL190:

; 593             pstCFG->bFindWriteReq = FALSE;
	mov	eax,dword ptr  @46pstCFG
	and	byte ptr [eax+01eh],0feh
@BLBL191:

; 595           if (Checked(hwndDlg,FIND_READ_REQ))
	push	01976h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL192

; 596             pstCFG->bFindReadReq = TRUE;
	mov	eax,dword ptr  @46pstCFG
	or	byte ptr [eax+01eh],02h
	jmp	@BLBL193
	align 010h
@BLBL192:

; 598             pstCFG->bFindReadReq = FALSE;
	mov	eax,dword ptr  @46pstCFG
	and	byte ptr [eax+01eh],0fdh
@BLBL193:

; 600           if (Checked(hwndDlg,FIND_DEVIOCTL))
	push	01973h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL194

; 601             pstCFG->bFindDevIOctl = TRUE;
	mov	eax,dword ptr  @46pstCFG
	or	byte ptr [eax+01eh],04h
	jmp	@BLBL195
	align 010h
@BLBL194:

; 603             pstCFG->bFindDevIOctl = FALSE;
	mov	eax,dword ptr  @46pstCFG
	and	byte ptr [eax+01eh],0fbh
@BLBL195:

; 605           if (Checked(hwndDlg,FIND_ERRORS))
	push	01978h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL196

; 606             pstCFG->bFindErrors = TRUE;
	mov	eax,dword ptr  @46pstCFG
	or	byte ptr [eax+01eh],08h
	jmp	@BLBL197
	align 010h
@BLBL196:

; 608             pstCFG->bFindErrors = FALSE;
	mov	eax,dword ptr  @46pstCFG
	and	byte ptr [eax+01eh],0f7h
@BLBL197:

; 610           if (Checked(hwndDlg,FIND_OPEN))
	push	01979h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL198

; 611             pstCFG->bFindOpen = TRUE;
	mov	eax,dword ptr  @46pstCFG
	or	byte ptr [eax+01dh],080h
	jmp	@BLBL199
	align 010h
@BLBL198:

; 613             pstCFG->bFindOpen = FALSE;
	mov	eax,dword ptr  @46pstCFG
	and	byte ptr [eax+01dh],07fh
@BLBL199:

; 615           if (Checked(hwndDlg,FIND_RCV))
	push	01981h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL200

; 616             pstCFG->bFindRead = TRUE;
	mov	eax,dword ptr  @46pstCFG
	or	byte ptr [eax+01dh],04h
	jmp	@BLBL201
	align 010h
@BLBL200:

; 618             pstCFG->bFindRead = FALSE;
	mov	eax,dword ptr  @46pstCFG
	and	byte ptr [eax+01dh],0fbh
@BLBL201:

; 620           if (Checked(hwndDlg,FIND_XMIT))
	push	01980h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL202

; 621             pstCFG->bFindWrite = TRUE;
	mov	eax,dword ptr  @46pstCFG
	or	byte ptr [eax+01dh],08h
	jmp	@BLBL203
	align 010h
@BLBL202:

; 623             pstCFG->bFindWrite = FALSE;
	mov	eax,dword ptr  @46pstCFG
	and	byte ptr [eax+01dh],0f7h
@BLBL203:

; 625           if (Checked(hwndDlg,FIND_IMM))
	push	01974h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL204

; 626             pstCFG->bFindIMM = TRUE;
	mov	eax,dword ptr  @46pstCFG
	or	byte ptr [eax+01dh],010h
	jmp	@BLBL205
	align 010h
@BLBL204:

; 628             pstCFG->bFindIMM = FALSE;
	mov	eax,dword ptr  @46pstCFG
	and	byte ptr [eax+01dh],0efh
@BLBL205:

; 629           bSearchInit = TRUE;
	mov	dword ptr  bSearchInit,01h

; 630           WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 631           return(MRESULT)TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL223:

; 633           DisplayHelpPanel(HLPP_FIND_DLG);
	push	075fbh
	call	DisplayHelpPanel
	add	esp,04h

; 634           return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL224:

; 636           WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 637           break;
	jmp	@BLBL220
	align 04h
@BLBL225:

; 639           return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
	jmp	@BLBL220
	align 04h
@BLBL221:
	cmp	eax,01h
	je	@BLBL222
	cmp	eax,012dh
	je	@BLBL223
	cmp	eax,02h
	je	@BLBL224
	jmp	@BLBL225
	align 04h
@BLBL220:

; 641       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL206
	align 04h
@BLBL207:
	cmp	eax,03bh
	je	@BLBL208
	cmp	eax,08002h
	je	@BLBL209
	cmp	eax,030h
	je	@BLBL210
	cmp	eax,020h
	je	@BLBL219
@BLBL206:

; 643   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
fnwpSearchConfigDlgProc	endp
CODE32	ends
end
