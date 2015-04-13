	title	p:\COMscope\scroll.c
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
	public	pwScrollBuffer
	public	bScrolling
	public	fLastScroll
	extrn	WinDestroyWindow:proc
	extrn	WinCreateWindow:proc
	extrn	WinSendMsg:proc
	extrn	DisplayLastWindowError:proc
	extrn	WinInvalidateRect:proc
	extrn	CharPrintable:proc
	extrn	_fullDump:dword
	extrn	stCFG:byte
	extrn	stCell:dword
	extrn	lStatusHeight:dword
	extrn	stWrite:byte
	extrn	stRead:byte
	extrn	stRow:byte
DATA32	segment
@STAT1	db "@ SetupRowScrolling",0h
@STAT2	db "@ SetupColScrolling",0h
DATA32	ends
BSS32	segment
pwScrollBuffer	dd 0h
bScrolling	dd 0h
fLastScroll	dd 0h
	align 04h
comm	lScrollCount:dword
BSS32	ends
CODE32	segment

; 39   {
	align 010h

	public CountTraceElement
CountTraceElement	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 42   if (((wDirection & (CS_READ | CS_WRITE)) == (CS_READ | CS_WRITE)) ||
	mov	ax,[ebp+0ch];	wDirection
	and	ax,0c000h
	cmp	ax,0c000h
	je	@BLBL1

; 43       ((wDirection & 0xff00) == CS_PACKET_DATA))
	mov	ax,[ebp+0ch];	wDirection
	and	ax,0ff00h
	cmp	ax,0ff00h
	jne	@BLBL2
@BLBL1:

; 44     {
; 45     wEvent = (wTraceElement & 0xff00);
	mov	ax,[ebp+08h];	wTraceElement
	and	ax,0ff00h
	mov	[ebp-02h],ax;	wEvent

; 46     switch (wEvent)
	xor	eax,eax
	mov	ax,[ebp-02h];	wEvent
	jmp	@BLBL29
	align 04h
@BLBL30:

; 47       {
; 48       case CS_READ:
; 49         if (stCFG.bDispRead)
	test	byte ptr  stCFG+01bh,040h
	je	@BLBL3

; 50           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL3:

; 51         break;
	jmp	@BLBL28
	align 04h
@BLBL31:
@BLBL32:

; 52       case CS_READ_IMM:
; 53       case CS_WRITE_IMM:
; 54         if (stCFG.bDispIMM)
	test	byte ptr  stCFG+01bh,080h
	je	@BLBL4

; 55           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL4:

; 56         break;
	jmp	@BLBL28
	align 04h
@BLBL33:
@BLBL34:

; 57       case CS_READ_REQ:
; 58       case CS_READ_CMPLT:
; 59         if (stCFG.bDispReadReq)
	test	byte ptr  stCFG+01ch,010h
	je	@BLBL5

; 60           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL5:

; 61         break;
	jmp	@BLBL28
	align 04h
@BLBL35:

; 62       case CS_MODEM_IN:
; 63         if (stCFG.bDispModemIn)
	test	byte ptr  stCFG+01ch,01h
	je	@BLBL6

; 64           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL6:

; 65         break;
	jmp	@BLBL28
	align 04h
@BLBL36:
@BLBL37:
@BLBL38:

; 66       case CS_READ_BUFF_OVERFLOW:
; 67       case CS_HDW_ERROR:
; 68       case CS_BREAK_RX:
; 69         if (stCFG.bDispErrors)
	test	byte ptr  stCFG+01ch,040h
	je	@BLBL7

; 70           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL7:

; 71         break;
	jmp	@BLBL28
	align 04h
@BLBL39:

; 72       case CS_WRITE:
; 73         if (stCFG.bDispWrite)
	test	byte ptr  stCFG+01bh,020h
	je	@BLBL8

; 74           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL8:

; 75         break;
	jmp	@BLBL28
	align 04h
@BLBL40:
@BLBL41:

; 76       case CS_WRITE_REQ:
; 77       case CS_WRITE_CMPLT:
; 78         if (stCFG.bDispWriteReq)
	test	byte ptr  stCFG+01ch,08h
	je	@BLBL9

; 79           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL9:

; 80         break;
	jmp	@BLBL28
	align 04h
@BLBL42:

; 81       case CS_MODEM_OUT:
; 82         if (stCFG.bDispModemOut)
	test	byte ptr  stCFG+01ch,02h
	je	@BLBL10

; 83           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL10:

; 84         break;
	jmp	@BLBL28
	align 04h
@BLBL43:

; 85       case CS_DEVIOCTL:
; 86         if (stCFG.bDispDevIOctl)
	test	byte ptr  stCFG+01ch,020h
	je	@BLBL11

; 87           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL11:

; 88         break;
	jmp	@BLBL28
	align 04h
@BLBL44:
@BLBL45:
@BLBL46:
@BLBL47:

; 89       case CS_OPEN_ONE:
; 90       case CS_OPEN_TWO:
; 91       case CS_CLOSE_ONE:
; 92       case CS_CLOSE_TWO:
; 93         if (stCFG.bDispOpen)
	test	byte ptr  stCFG+01ch,04h
	je	@BLBL12

; 94           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL12:

; 95         break;
	jmp	@BLBL28
	align 04h
@BLBL48:

; 96       case CS_PACKET_DATA:
; 97         /*
; 98         ** Add 1 here to insure that anytime there is packet data, something other that zero or one is returned.
; 99         **
; 100         ** A return value of zero means "don't display", one means display data, anything else means that this element
; 101         ** is packet data and the value returned is the number of words that represent the data, including the packet
; 102         ** data indicator word (this byte).  A packet data size of zero is not supposed to occur.
; 103         **
; 104         ** I am leaving it up to the calling function to adjust an index (if necessary) because: 1) I don't have to pass a
; 105         ** pointer to the index, and 2) the calling function may not need to adjust an index.
; 106         */
; 107         return((ULONG)(wTraceElement & 0x00ff) + 1);
	xor	eax,eax
	mov	ax,[ebp+08h];	wTraceElement
	and	eax,0ffh
	inc	eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL49:

; 108       case CS_BREAK_TX:
; 109         if (stCFG.bDispDevIOctl)
	test	byte ptr  stCFG+01ch,020h
	je	@BLBL13

; 110           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL13:

; 111         break;
	jmp	@BLBL28
	align 04h
	jmp	@BLBL28
	align 04h
@BLBL29:
	cmp	eax,04000h
	je	@BLBL30
	cmp	eax,04100h
	je	@BLBL31
	cmp	eax,08100h
	je	@BLBL32
	cmp	eax,04200h
	je	@BLBL33
	cmp	eax,04300h
	je	@BLBL34
	cmp	eax,04400h
	je	@BLBL35
	cmp	eax,04500h
	je	@BLBL36
	cmp	eax,04600h
	je	@BLBL37
	cmp	eax,04700h
	je	@BLBL38
	cmp	eax,08000h
	je	@BLBL39
	cmp	eax,08200h
	je	@BLBL40
	cmp	eax,08300h
	je	@BLBL41
	cmp	eax,08400h
	je	@BLBL42
	cmp	eax,08500h
	je	@BLBL43
	cmp	eax,08600h
	je	@BLBL44
	cmp	eax,08700h
	je	@BLBL45
	cmp	eax,08800h
	je	@BLBL46
	cmp	eax,08900h
	je	@BLBL47
	cmp	eax,0ff00h
	je	@BLBL48
	cmp	eax,08a00h
	je	@BLBL49
@BLBL28:

; 112       }
; 113     return(0);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL2:

; 114     }
; 115   wEvent = ((wTraceElement & 0x0f00) >> 8);
	xor	eax,eax
	mov	ax,[ebp+08h];	wTraceElement
	and	eax,0f00h
	sar	eax,08h
	mov	[ebp-02h],ax;	wEvent

; 116   if (wDirection & CS_READ)
	test	byte ptr [ebp+0dh],040h;	wDirection
	je	@BLBL14

; 117     {
; 118     switch (wEvent)
	xor	eax,eax
	mov	ax,[ebp-02h];	wEvent
	jmp	@BLBL51
	align 04h
@BLBL52:

; 119       {
; 120       case 0:
; 121         if (stCFG.bDispRead)
	test	byte ptr  stCFG+01bh,040h
	je	@BLBL15

; 122           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL15:

; 123         break;
	jmp	@BLBL50
	align 04h
@BLBL53:

; 124       case 1:
; 125         if (stCFG.bDispIMM)
	test	byte ptr  stCFG+01bh,080h
	je	@BLBL16

; 126           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL16:

; 127         break;
	jmp	@BLBL50
	align 04h
@BLBL54:
@BLBL55:

; 128       case 2:                    // CS_READ_REQ
; 129       case 3:                    // CS_READ_COMPL
; 130         if (stCFG.bDispReadReq)
	test	byte ptr  stCFG+01ch,010h
	je	@BLBL17

; 131           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL17:

; 132         break;
	jmp	@BLBL50
	align 04h
@BLBL56:

; 133       case 4:
; 134         if (stCFG.bDispModemIn)
	test	byte ptr  stCFG+01ch,01h
	je	@BLBL18

; 135           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL18:

; 136         break;
	jmp	@BLBL50
	align 04h
@BLBL57:
@BLBL58:
@BLBL59:

; 137       case 5:                    // CS_READ_BUFF_OVERFLOW
; 138       case 6:                    // CS_HWD_ERROR
; 139       case 7:                    // CS_BREAK_RX
; 140         if (stCFG.bDispErrors)
	test	byte ptr  stCFG+01ch,040h
	je	@BLBL19

; 141           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL19:

; 142         break;
	jmp	@BLBL50
	align 04h
	jmp	@BLBL50
	align 04h
@BLBL51:
	test	eax,eax
	je	@BLBL52
	cmp	eax,01h
	je	@BLBL53
	cmp	eax,02h
	je	@BLBL54
	cmp	eax,03h
	je	@BLBL55
	cmp	eax,04h
	je	@BLBL56
	cmp	eax,05h
	je	@BLBL57
	cmp	eax,06h
	je	@BLBL58
	cmp	eax,07h
	je	@BLBL59
@BLBL50:

; 143       }
; 144     return(0);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL14:

; 145     }
; 146   if (wDirection & CS_WRITE)
	test	byte ptr [ebp+0dh],080h;	wDirection
	je	@BLBL20

; 147     {
; 148     switch (wEvent)
	xor	eax,eax
	mov	ax,[ebp-02h];	wEvent
	jmp	@BLBL61
	align 04h
@BLBL62:

; 149       {
; 150       case 0:
; 151         if (stCFG.bDispWrite)
	test	byte ptr  stCFG+01bh,020h
	je	@BLBL21

; 152           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL21:

; 153         break;
	jmp	@BLBL60
	align 04h
@BLBL63:

; 154       case 1:
; 155         if (stCFG.bDispIMM)
	test	byte ptr  stCFG+01bh,080h
	je	@BLBL22

; 156           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL22:

; 157         break;
	jmp	@BLBL60
	align 04h
@BLBL64:
@BLBL65:

; 158       case 2:                  // CS_WRITE_REQ
; 159       case 3:                  // CS_WRITE_COMPL
; 160         if (stCFG.bDispWriteReq)
	test	byte ptr  stCFG+01ch,08h
	je	@BLBL23

; 161           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL23:

; 162         break;
	jmp	@BLBL60
	align 04h
@BLBL66:

; 163       case 4:
; 164         if (stCFG.bDispModemOut)
	test	byte ptr  stCFG+01ch,02h
	je	@BLBL24

; 165           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL24:

; 166         break;
	jmp	@BLBL60
	align 04h
@BLBL67:

; 167       case 5:                   // CS_DEVIOCTL
; 168         if (stCFG.bDispDevIOctl)
	test	byte ptr  stCFG+01ch,020h
	je	@BLBL25

; 169           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL25:

; 170         break;
	jmp	@BLBL60
	align 04h
@BLBL68:
@BLBL69:
@BLBL70:
@BLBL71:

; 171       case 6:                   // CS_OPEN_ONE
; 172       case 7:                   // CS_OPEN_TWO
; 173       case 8:                   // CS_CLOSE_ONE
; 174       case 9:                   // CS_CLOSE_TWO
; 175         if (stCFG.bDispOpen)
	test	byte ptr  stCFG+01ch,04h
	je	@BLBL26

; 176           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL26:

; 177         break;
	jmp	@BLBL60
	align 04h
@BLBL72:

; 178       case 10:                  // CS_BREAK_TX
; 179         if (stCFG.bDispDevIOctl)
	test	byte ptr  stCFG+01ch,020h
	je	@BLBL27

; 180           return(1);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL27:

; 181         break;
	jmp	@BLBL60
	align 04h
	jmp	@BLBL60
	align 04h
@BLBL61:
	test	eax,eax
	je	@BLBL62
	cmp	eax,01h
	je	@BLBL63
	cmp	eax,02h
	je	@BLBL64
	cmp	eax,03h
	je	@BLBL65
	cmp	eax,04h
	je	@BLBL66
	cmp	eax,05h
	je	@BLBL67
	cmp	eax,06h
	je	@BLBL68
	cmp	eax,07h
	je	@BLBL69
	cmp	eax,08h
	je	@BLBL70
	cmp	eax,09h
	je	@BLBL71
	cmp	eax,0ah
	je	@BLBL72
@BLBL60:

; 182       }
; 183     }
@BLBL20:

; 184   return(0);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
CountTraceElement	endp

; 188   {
	align 010h

	public GetDisplayCount
GetDisplayCount	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax

; 193   if (pwScrollBuffer == NULL)
	cmp	dword ptr  pwScrollBuffer,0h
	jne	@BLBL73

; 194     return(0);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL73:

; 195   lCharCount = 0;
	mov	dword ptr [ebp-08h],0h;	lCharCount

; 196   lIndex = 0;
	mov	dword ptr [ebp-04h],0h;	lIndex

; 197   while (lIndex < lSize)
	mov	eax,[ebp+08h];	lSize
	cmp	[ebp-04h],eax;	lIndex
	jge	@BLBL74
	align 010h
@BLBL75:

; 198     {
; 199     if ((ulIncrement = CountTraceElement(pwScrollBuffer[lIndex],(CS_READ | CS_WRITE))) == 1)
	push	0c000h
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-04h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	push	eax
	call	CountTraceElement
	add	esp,08h
	mov	[ebp-0ch],eax;	ulIncrement
	cmp	dword ptr [ebp-0ch],01h;	ulIncrement
	jne	@BLBL76

; 200       lCharCount++;
	mov	eax,[ebp-08h];	lCharCount
	inc	eax
	mov	[ebp-08h],eax;	lCharCount
@BLBL76:

; 201     if (ulIncrement > 1)
	cmp	dword ptr [ebp-0ch],01h;	ulIncrement
	jbe	@BLBL77

; 202       lIndex += ulIncrement;
	mov	eax,[ebp-04h];	lIndex
	add	eax,[ebp-0ch];	ulIncrement
	mov	[ebp-04h],eax;	lIndex
	jmp	@BLBL78
	align 010h
@BLBL77:

; 203     else
; 204       lIndex++;
	mov	eax,[ebp-04h];	lIndex
	inc	eax
	mov	[ebp-04h],eax;	lIndex
@BLBL78:

; 205     }

; 197   while (lIndex < lSize)
	mov	eax,[ebp+08h];	lSize
	cmp	[ebp-04h],eax;	lIndex
	jl	@BLBL75
@BLBL74:

; 206   return(lCharCount);
	mov	eax,[ebp-08h];	lCharCount
	mov	esp,ebp
	pop	ebp
	ret	
GetDisplayCount	endp

; 210   {
	align 010h

SetScrollRowCount	proc
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

; 219   if (pwScrollBuffer == NULL)
	cmp	dword ptr  pwScrollBuffer,0h
	jne	@BLBL80

; 220     {
; 221     pstScreen->lScrollRowCount = 0;
	mov	eax,[ebp+08h];	pstScreen
	mov	dword ptr [eax+067h],0h

; 222     return;
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL80:

; 223     }
; 224   lActualCharCount = 0;
	mov	dword ptr [ebp-04h],0h;	lActualCharCount

; 225   lRowCount = 0;
	mov	dword ptr [ebp-010h],0h;	lRowCount

; 226   lRowCountedAt = -1;
	mov	dword ptr [ebp-014h],0ffffffffh;	lRowCountedAt

; 227   CalcScrollEndIndex(pstScreen);
	push	dword ptr [ebp+08h];	pstScreen
	call	CalcScrollEndIndex
	add	esp,04h

; 228 #ifdef this_junk
; 229   if (stCFG.bCompressDisplay)
; 230     {
; 231     wLastDirection = CS_READ;
; 232     lIndex = 0;
; 233     while (lIndex < pstScreen->lScrollEndIndex)
; 234       {
; 235       if ((lActualCharCount % pstScreen->lCharWidth) == 0)
; 236         {
; 237         if (lRowCountedAt != lActualCharCount)
; 238           {
; 239           lRowCountedAt = lActualCharCount;
; 240           wLastDirection = CS_READ;
; 241           lRowCount++;
; 242           }
; 243         }
; 244       wDirection = pwScrollBuffer[lIndex];
; 245       if ((ulElementCount = CountTraceElement(wLastDirection,CS_WRITE)) == 1)
; 246         lActualCharCount++;
; 247       else
; 248         if ((ulElementCount = CountTraceElement(wDirection,CS_READ)) == 1)
; 249           lActualCharCount++;
; 250       if (ulElementCount > 1)
; 251          lIndex += ulElementCount;
; 252       else
; 253          lIndex++;
; 254       wLastDirection = (wDirection & 0xf000);
; 255       }
; 256     }
; 257   else
; 258 #endif
; 259     {
; 260     lIndex = 0;
	mov	dword ptr [ebp-08h],0h;	lIndex

; 261     while (lIndex < lScrollCount)
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-08h],eax;	lIndex
	jge	@BLBL81
	align 010h
@BLBL82:

; 262       {
; 263       if ((ulElementCount = CountTraceElement(pwScrollBuffer[lIndex],(CS_READ | CS_WRITE))) == 1)
	push	0c000h
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-08h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	push	eax
	call	CountTraceElement
	add	esp,08h
	mov	[ebp-018h],eax;	ulElementCount
	cmp	dword ptr [ebp-018h],01h;	ulElementCount
	jne	@BLBL83

; 264         lActualCharCount++;
	mov	eax,[ebp-04h];	lActualCharCount
	inc	eax
	mov	[ebp-04h],eax;	lActualCharCount
@BLBL83:

; 265       if (ulElementCount > 1)
	cmp	dword ptr [ebp-018h],01h;	ulElementCount
	jbe	@BLBL84

; 266          lIndex += ulElementCount;
	mov	eax,[ebp-08h];	lIndex
	add	eax,[ebp-018h];	ulElementCount
	mov	[ebp-08h],eax;	lIndex
	jmp	@BLBL85
	align 010h
@BLBL84:

; 267       else
; 268          lIndex++;
	mov	eax,[ebp-08h];	lIndex
	inc	eax
	mov	[ebp-08h],eax;	lIndex
@BLBL85:

; 269       }

; 261     while (lIndex < lScrollCount)
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-08h],eax;	lIndex
	jl	@BLBL82
@BLBL81:

; 270     lRowCount = (lActualCharCount / pstScreen->lCharWidth);
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp-04h];	lActualCharCount
	cdq	
	idiv	dword ptr [ecx+027h]
	mov	[ebp-010h],eax;	lRowCount

; 271     if ((lActualCharCount % pstScreen->lCharWidth) != 0)
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp-04h];	lActualCharCount
	cdq	
	idiv	dword ptr [ecx+027h]
	test	edx,edx
	je	@BLBL87

; 272       lRowCount++;
	mov	eax,[ebp-010h];	lRowCount
	inc	eax
	mov	[ebp-010h],eax;	lRowCount
@BLBL87:

; 273     }

; 274   pstScreen->lScrollRowCount = lRowCount;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-010h];	lRowCount
	mov	[eax+067h],ecx

; 275   }
	mov	esp,ebp
	pop	ebp
	ret	
SetScrollRowCount	endp

; 278   {
	align 010h

	public GetRowScrollRow
GetRowScrollRow	proc
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

; 287   if (pwScrollBuffer == NULL)
	cmp	dword ptr  pwScrollBuffer,0h
	jne	@BLBL88

; 288     return(0);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL88:

; 289   lRowCount = 0;
	mov	dword ptr [ebp-018h],0h;	lRowCount

; 290   lActualCharCount = 0;
	mov	dword ptr [ebp-04h],0h;	lActualCharCount

; 291 #ifdef this_junk
; 292   if (stCFG.bCompressDisplay)
; 293     {
; 294     lRowCountedAt = -1;
; 295     wLastDirection = CS_READ;
; 296     lIndex = 0;
; 297     while (lIndex < pstScreen->lScrollIndex)
; 298       {
; 299       if ((lActualCharCount % pstScreen->lCharWidth) == 0)
; 300         {
; 301         if (lRowCountedAt != lActualCharCount)
; 302           {
; 303           lRowCountedAt = lActualCharCount;
; 304           wLastDirection = 
; 304 CS_READ;
; 305           lRowCount++;
; 306           }
; 307         }
; 308       wDirection = pwScrollBuffer[lIndex];
; 309       if ((ulElementCount = CountTraceElement(wLastDirection,CS_WRITE)) == 1)
; 310         lActualCharCount++;
; 311       else
; 312         if ((ulElementCount = CountTraceElement(wDirection,CS_READ)) == 1)
; 313           lActualCharCount++;
; 314       if (ulElementCount > 1)
; 315         lIndex += ulElementCount;
; 316       else
; 317         lIndex++;
; 318       wLastDirection = (wDirection & 0xf000);
; 319       }
; 320     }
; 321   else
; 322 #endif
; 323     {
; 324     lIndex = 0;
	mov	dword ptr [ebp-08h],0h;	lIndex

; 325     while (lIndex < pstScreen->lScrollIndex)
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-08h];	lIndex
	cmp	[eax+06fh],ecx
	jle	@BLBL89
	align 010h
@BLBL90:

; 326       {
; 327       if ((ulElementCount = CountTraceElement(pwScrollBuffer[lIndex],(CS_READ | CS_WRITE))) == 1)
	push	0c000h
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-08h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	push	eax
	call	CountTraceElement
	add	esp,08h
	mov	[ebp-014h],eax;	ulElementCount
	cmp	dword ptr [ebp-014h],01h;	ulElementCount
	jne	@BLBL91

; 328         lActualCharCount++;
	mov	eax,[ebp-04h];	lActualCharCount
	inc	eax
	mov	[ebp-04h],eax;	lActualCharCount
@BLBL91:

; 329       if (ulElementCount > 1)
	cmp	dword ptr [ebp-014h],01h;	ulElementCount
	jbe	@BLBL92

; 330         lIndex += ulElementCount;
	mov	eax,[ebp-08h];	lIndex
	add	eax,[ebp-014h];	ulElementCount
	mov	[ebp-08h],eax;	lIndex
	jmp	@BLBL93
	align 010h
@BLBL92:

; 331       else
; 332         lIndex++;
	mov	eax,[ebp-08h];	lIndex
	inc	eax
	mov	[ebp-08h],eax;	lIndex
@BLBL93:

; 333       }

; 325     while (lIndex < pstScreen->lScrollIndex)
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-08h];	lIndex
	cmp	[eax+06fh],ecx
	jg	@BLBL90
@BLBL89:

; 334     lRowCount = (lActualCharCount / pstScreen->lCharWidth);
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp-04h];	lActualCharCount
	cdq	
	idiv	dword ptr [ecx+027h]
	mov	[ebp-018h],eax;	lRowCount

; 335     if ((lActualCharCount % pstScreen->lCharWidth) != 0)
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp-04h];	lActualCharCount
	cdq	
	idiv	dword ptr [ecx+027h]
	test	edx,edx
	je	@BLBL95

; 336       lRowCount++;
	mov	eax,[ebp-018h];	lRowCount
	inc	eax
	mov	[ebp-018h],eax;	lRowCount
@BLBL95:

; 337     }

; 338   return(lRowCount);
	mov	eax,[ebp-018h];	lRowCount
	mov	esp,ebp
	pop	ebp
	ret	
GetRowScrollRow	endp

; 342   {
	align 010h

CalcScrollEndIndex	proc
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

; 344   LONG lTemp = 0;
	mov	dword ptr [ebp-08h],0h;	lTemp

; 345   SHORT sRowCount;
; 346   SHORT sIndex;
; 347   LONG lScrollEndIndex;
; 348   LONG lDisplayChars;
; 349   ULONG ulElementCount;
; 350 
; 351   lDisplayChars = GetDisplayCount(lScrollCount);
	push	dword ptr  lScrollCount
	call	GetDisplayCount
	add	esp,04h
	mov	[ebp-014h],eax;	lDisplayChars

; 352   lGoal = lDisplayChars;
	mov	eax,[ebp-014h];	lDisplayChars
	mov	[ebp-04h],eax;	lGoal

; 353 //  lGoal = lScrollCount;
; 354   lTemp = pstScreen->lScrollIndex;
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+06fh]
	mov	[ebp-08h],eax;	lTemp

; 355   pstScreen->lScrollIndex = lScrollCount;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,dword ptr  lScrollCount
	mov	[eax+06fh],ecx

; 356   sRowCount = GetRowScrollRow(pstScreen);
	push	dword ptr [ebp+08h];	pstScreen
	call	GetRowScrollRow
	add	esp,04h
	mov	[ebp-0ah],ax;	sRowCount

; 357   pstScreen->lScrollIndex = lTemp;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-08h];	lTemp
	mov	[eax+06fh],ecx

; 358   if (sRowCount <= pstScreen->lCharHeight)
	mov	eax,[ebp+08h];	pstScreen
	movsx	ecx,word ptr [ebp-0ah];	sRowCount
	cmp	[eax+02bh],ecx
	jl	@BLBL96

; 359     {
; 360     lScrollEndIndex = 0;
	mov	dword ptr [ebp-010h],0h;	lScrollEndIndex

; 361     while (lScrollEndIndex < lScrollCount)
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-010h],eax;	lScrollEndIndex
	jge	@BLBL97
	align 010h
@BLBL98:

; 362       {
; 363       if ((ulElementCount = CountTraceElement(pwScrollBuffer[lScrollEndIndex],(CS_READ | CS_WRITE))) == 1)
	push	0c000h
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-010h];	lScrollEndIndex
	mov	ax,word ptr [eax+ecx*02h]
	push	eax
	call	CountTraceElement
	add	esp,08h
	mov	[ebp-018h],eax;	ulElementCount
	cmp	dword ptr [ebp-018h],01h;	ulElementCount
	je	@BLBL97

; 364         break;
; 365       if (ulElementCount > 1)
	cmp	dword ptr [ebp-018h],01h;	ulElementCount
	jbe	@BLBL101

; 366         lScrollEndIndex += ulElementCount;
	mov	eax,[ebp-010h];	lScrollEndIndex
	add	eax,[ebp-018h];	ulElementCount
	mov	[ebp-010h],eax;	lScrollEndIndex
	jmp	@BLBL102
	align 010h
@BLBL101:

; 367       else
; 368         lScrollEndIndex++;
	mov	eax,[ebp-010h];	lScrollEndIndex
	inc	eax
	mov	[ebp-010h],eax;	lScrollEndIndex
@BLBL102:

; 369       }

; 361     while (lScrollEndIndex < lScrollCount)
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-010h],eax;	lScrollEndIndex
	jl	@BLBL98
@BLBL97:

; 370     if (lScrollEndIndex >= lScrollCount)
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-010h],eax;	lScrollEndIndex
	jl	@BLBL103

; 371       lScrollEndIndex = 0;
	mov	dword ptr [ebp-010h],0h;	lScrollEndIndex
@BLBL103:

; 372     return;
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL96:

; 374   if (pstScreen->lCharWidth > 0)
	mov	eax,[ebp+08h];	pstScreen
	cmp	dword ptr [eax+027h],0h
	jle	@BLBL104

; 390       lScrollEndIndex = GetPartialCharCount(pstScreen,lScrollCount,-pstScreen->lCharSize);
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+023h]
	neg	eax
	push	eax
	push	dword ptr  lScrollCount
	push	dword ptr [ebp+08h];	pstScreen
	call	GetPartialCharCount
	add	esp,0ch
	mov	[ebp-010h],eax;	lScrollEndIndex

; 392     if (lScrollEndIndex < 0L)
	cmp	dword ptr [ebp-010h],0h;	lScrollEndIndex
	jge	@BLBL104

; 393       lScrollEndIndex = 0L;
	mov	dword ptr [ebp-010h],0h;	lScrollEndIndex

; 394     }
@BLBL104:

; 395   pstScreen->lScrollEndIndex = lScrollEndIndex;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-010h];	lScrollEndIndex
	mov	[eax+063h],ecx

; 396   }
	mov	esp,ebp
	pop	ebp
	ret	
CalcScrollEndIndex	endp

; 399   {
	align 010h

GetPartialCharCount	proc
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

; 400   LONG lLogicalCharCount = 0;
	mov	dword ptr [ebp-04h],0h;	lLogicalCharCount

; 401   LONG lIndex;
; 402   WORD wDirection;
; 403   WORD wLastDirection;
; 404   WORD *pwBuffer;
; 405   LONG lEndIndex;
; 406   ULONG ulElementCount;
; 407   LONG lRetraceIndex;
; 408   LONG lRetraceCount;
; 409   BOOL bCharValid;
; 410 
; 411   if (pwScrollBuffer == NULL)
	cmp	dword ptr  pwScrollBuffer,0h
	jne	@BLBL106

; 412     return(0);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL106:

; 413  #ifdef this_junk
; 414   if (stCFG.bCompressDisplay)
; 415     {
; 416     if (lCharCount > 0)
; 417       {
; 418       pwBuffer = &pwScrollBuffer[lStartIndex];
; 419       wLastDirection = CS_READ;
; 420       lIndex = 0;
; 421       while (lIndex < (stCFG.lBufferLength - lStartIndex))
; 422         {
; 423         wDirection = (*(pwBuffer++) & 0xff00);
; 424         if ((ulElementCount = CountTraceElement(wLastDirection,CS_WRITE)) == 1)
; 425           lLogicalCharCount++;
; 426         else
; 427           if ((ulElementCount = CountTraceElement(wDirection,CS_READ)) == 1)
; 428             lLogicalCharCount++;
; 429         if (ulElementCount > 1)
; 430           lIndex += ulElementCount;
; 431         else
; 432           lIndex++;
; 433         if (lLogicalCharCount >= lCharCount)
; 434           break;
; 435         wLastDirection = (wDirection & 0xf000);
; 436         }
; 437       lIndex++;
; 438       }
; 439     else
; 440       {
; 441       if (lStartIndex <= 0)
; 442         return(0);
; 443       wLastDirection = CS_WRITE;
; 444       for (lIndex = (lStartIndex - 1);lIndex >= 0;lIndex--)
; 445         {
; 446         wDirection = (pwScrollBuffer[lIndex] & 0xff00);
; 447         bCharValid = FALSE;
; 448         if ((ulElementCount = CountTraceElement(wDirection,CS_READ)) == 1)
; 449           {
; 450           lCharCount++;
; 451           bCharValid = TRUE;
; 452           }
; 453         else
; 454           if (ulElementCount == 0)
; 455             {
; 456             if ((ulElementCount = CountTraceElement(wLastDirection,CS_WRITE)) == 1)
; 457               {
; 458               lCharCount++;
; 459               bCharValid = TRUE;
; 460               }
; 461             else
; 462               wLastDirection = pwScrollBuffer[lIndex];
; 463             }
; 464         if (ulElementCount > 1)
; 465           for (lRetraceIndex = (lIndex + 1);lRetraceIndex < (wLastDirection & 0xff00);lRetraceIndex++)
; 466             if (CountTraceElement((wLastDirection & 0xff00),(CS_WRITE | CS_READ)) == 1)
; 467               lCharCount--;
; 468         if (bCharValid && (lCharCount >= 0))
; 469           {
; 470           if (CountTraceElement(wDirection,CS_READ) == 1)
; 471             if (lIndex > 0)
; 472               if ((pwScrollBuffer[lIndex - 1] & 0xf000) != CS_READ)
; 473                 lIndex--;
; 474           break;
; 475           }
; 476         wLastDirection = (wDirection & 0xf000);
; 477         }
; 478       if (lIndex <= 0)
; 479         lIndex = -lStartIndex;
; 480       else
; 481         lIndex = (lIndex - lStartIndex);
; 482       }
; 483     return(lIndex);
; 484     }
; 485   else
; 486 #endif
; 487     {
; 488     lEndIndex = pstScreen->lScrollEndIndex;
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+063h]
	mov	[ebp-014h],eax;	lEndIndex

; 489     if (lCharCount > 0)
	cmp	dword ptr [ebp+010h],0h;	lCharCount
	jle	@BLBL107

; 490       {
; 491       lIndex = lStartIndex;
	mov	eax,[ebp+0ch];	lStartIndex
	mov	[ebp-08h],eax;	lIndex

; 492       while (lIndex < lEndIndex)
	mov	eax,[ebp-014h];	lEndIndex
	cmp	[ebp-08h],eax;	lIndex
	jge	@BLBL116
	align 010h
@BLBL109:

; 493         {
; 494         if ((ulElementCount = CountTraceElement(pwScrollBuffer[lIndex],(CS_READ | CS_WRITE))) == 1)
	push	0c000h
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-08h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	push	eax
	call	CountTraceElement
	add	esp,08h
	mov	[ebp-018h],eax;	ulElementCount
	cmp	dword ptr [ebp-018h],01h;	ulElementCount
	jne	@BLBL110

; 495           if (lCharCount-- <= 0)
	cmp	dword ptr [ebp+010h],0h;	lCharCount
	jg	@BLBL111
	mov	eax,[ebp+010h];	lCharCount
	dec	eax
	mov	[ebp+010h],eax;	lCharCount

; 496             break;
	jmp	@BLBL116
	align 010h
@BLBL111:
	mov	eax,[ebp+010h];	lCharCount
	dec	eax
	mov	[ebp+010h],eax;	lCharCount
@BLBL110:

; 497         if (ulElementCount > 1)
	cmp	dword ptr [ebp-018h],01h;	ulElementCount
	jbe	@BLBL114

; 498           lIndex += ulElementCount;
	mov	eax,[ebp-08h];	lIndex
	add	eax,[ebp-018h];	ulElementCount
	mov	[ebp-08h],eax;	lIndex
	jmp	@BLBL115
	align 010h
@BLBL114:

; 499         else
; 500           lIndex++;
	mov	eax,[ebp-08h];	lIndex
	inc	eax
	mov	[ebp-08h],eax;	lIndex
@BLBL115:

; 501         }

; 492       while (lIndex < lEndIndex)
	mov	eax,[ebp-014h];	lEndIndex
	cmp	[ebp-08h],eax;	lIndex
	jl	@BLBL109

; 502       }
	jmp	@BLBL116
	align 010h
@BLBL107:

; 505       if (lStartIndex > 0)
	cmp	dword ptr [ebp+0ch],0h;	lStartIndex
	jle	@BLBL117

; 507         for (lIndex = (lStartIndex - 1);lIndex >= 0;lIndex--)
	mov	eax,[ebp+0ch];	lStartIndex
	dec	eax
	mov	[ebp-08h],eax;	lIndex
	cmp	dword ptr [ebp-08h],0h;	lIndex
	jl	@BLBL116
	align 010h
@BLBL119:

; 509           if ((ulElementCount = CountTraceElement(pwScrollBuffer[lIndex],(CS_READ | CS_WRITE))) == 1)
	push	0c000h
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-08h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	push	eax
	call	CountTraceElement
	add	esp,08h
	mov	[ebp-018h],eax;	ulElementCount
	cmp	dword ptr [ebp-018h],01h;	ulElementCount
	jne	@BLBL120

; 510             if (++lCharCount >= 0)
	mov	eax,[ebp+010h];	lCharCount
	inc	eax
	mov	[ebp+010h],eax;	lCharCount
	cmp	dword ptr [ebp+010h],0h;	lCharCount
	jge	@BLBL116

; 511               break;
@BLBL120:

; 512           if (ulElementCount > 1)
	cmp	dword ptr [ebp-018h],01h;	ulElementCount
	jbe	@BLBL123

; 514             lRetraceCount = (pwScrollBuffer[lIndex] & 0x00ff);
	mov	ecx,dword ptr  pwScrollBuffer
	mov	edx,[ebp-08h];	lIndex
	xor	eax,eax
	mov	ax,word ptr [ecx+edx*02h]
	and	eax,0ffh
	mov	[ebp-020h],eax;	lRetraceCount

; 515             for (lRetraceIndex = (lIndex + 1);lRetraceIndex < lRetraceCount;lRetraceIndex++)
	mov	eax,[ebp-08h];	lIndex
	inc	eax
	mov	[ebp-01ch],eax;	lRetraceIndex
	mov	eax,[ebp-020h];	lRetraceCount
	cmp	[ebp-01ch],eax;	lRetraceIndex
	jge	@BLBL123
	align 010h
@BLBL125:

; 516               if (CountTraceElement((pwScrollBuffer[lRetraceIndex] & 0xff00),(CS_WRITE | CS_READ)) == 1)
	push	0c000h
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-01ch];	lRetraceIndex
	mov	ax,word ptr [eax+ecx*02h]
	and	ax,0ff00h
	push	eax
	call	CountTraceElement
	add	esp,08h
	cmp	eax,01h
	jne	@BLBL126

; 517                 lCharCount--;
	mov	eax,[ebp+010h];	lCharCount
	dec	eax
	mov	[ebp+010h],eax;	lCharCount
@BLBL126:

; 515             for (lRetraceIndex = (lIndex + 1);lRetraceIndex < lRetraceCount;lRetraceIndex++)
	mov	eax,[ebp-01ch];	lRetraceIndex
	inc	eax
	mov	[ebp-01ch],eax;	lRetraceIndex
	mov	eax,[ebp-020h];	lRetraceCount
	cmp	[ebp-01ch],eax;	lRetraceIndex
	jl	@BLBL125

; 518             }
@BLBL123:

; 519           }

; 507         for (lIndex = (lStartIndex - 1);lIndex >= 0;lIndex--)
	mov	eax,[ebp-08h];	lIndex
	dec	eax
	mov	[ebp-08h],eax;	lIndex
	cmp	dword ptr [ebp-08h],0h;	lIndex
	jge	@BLBL119

; 535         }
	jmp	@BLBL116
	align 010h
@BLBL117:

; 537         lIndex = 0;
	mov	dword ptr [ebp-08h],0h;	lIndex

; 538       }
@BLBL116:

; 539     return(lIndex);
	mov	eax,[ebp-08h];	lIndex
	mov	esp,ebp
	pop	ebp
	ret	
GetPartialCharCount	endp

; 544   {
	align 010h

	public ClearRowScrollBar
ClearRowScrollBar	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 545   if (pstScreen->hwndScroll != (HWND)NULL)
	mov	eax,[ebp+08h];	pstScreen
	cmp	dword ptr [eax+05fh],0h
	je	@BLBL129

; 546     {
; 547     WinDestroyWindow(pstScreen->hwndScroll);
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+05fh]
	call	WinDestroyWindow
	add	esp,04h

; 548     pstScreen->hwndScroll = (HWND)NULL;
	mov	eax,[ebp+08h];	pstScreen
	mov	dword ptr [eax+05fh],0h

; 549     pstScreen->lWidth += stCell.cx;
	mov	eax,[ebp+08h];	pstScreen
	mov	[ebp-08h],eax;	@CBE4
	movsx	ecx,word ptr  stCell
	mov	eax,[ebp-08h];	@CBE4
	add	ecx,[eax+033h]
	mov	[eax+033h],ecx

; 550     pstScreen->lCharWidth += 1;
	mov	eax,[ebp+08h];	pstScreen
	mov	[ebp-04h],eax;	@CBE3
	mov	eax,[ebp-04h];	@CBE3
	mov	ecx,[eax+027h]
	inc	ecx
	mov	[eax+027h],ecx

; 551     pstScreen->lCharSize = (pstScreen->lCharWidth * pstScreen->lCharHeight);
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ecx+02bh]
	imul	ecx,[eax+027h]
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+023h],ecx

; 552     }
@BLBL129:

; 553   }
	mov	esp,ebp
	pop	ebp
	ret	
ClearRowScrollBar	endp

; 556   {
	align 010h

	public SetupRowScrolling
SetupRowScrolling	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 557   ClearRowScrollBar(pstScreen);
	push	dword ptr [ebp+08h];	pstScreen
	call	ClearRowScrollBar
	add	esp,04h

; 558   pstScreen->hwndScroll = WinCreateWindow(pstScreen->hwndClient,
	push	0h
	push	0h
	push	05208h
	push	03h
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+0fh]
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+02fh]
	sub	eax,02h
	push	eax
	movsx	eax,word ptr  stCell
	inc	eax
	push	eax
	mov	eax,dword ptr  lStatusHeight
	dec	eax
	push	eax
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+033h]
	push	080000001h
	push	0h
	push	0ffff0008h
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+0fh]
	call	WinCreateWindow
	mov	ecx,eax
	add	esp,034h
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+05fh],ecx

; 559                                           WC_SCROLLBAR,
; 560                                      (PSZ)NULL,
; 561                                           SBS_VERT | WS_VISIBLE,
; 562                                           pstScreen->lWidth,
; 563                                           (lStatusHeight - 1),
; 564                                           (stCell.cx + 1),
; 565                                           (pstScreen->lHeight - 2),
; 566                                           pstScreen->hwndClient,
; 567                                           HWND_TOP,
; 568                                           WID_VSCROLL_BAR,
; 569                                           NULL,NULL);
; 570   if (pstScreen->hwndScroll != (HWND)NULL)
	mov	eax,[ebp+08h];	pstScreen
	cmp	dword ptr [eax+05fh],0h
	je	@BLBL130

; 571     {
; 572     pstScreen->lWidth -= stCell.cx;
	mov	eax,[ebp+08h];	pstScreen
	mov	[ebp-08h],eax;	@CBE6
	mov	eax,[ebp-08h];	@CBE6
	mov	ecx,[eax+033h]
	movsx	edx,word ptr  stCell
	sub	ecx,edx
	mov	[eax+033h],ecx

; 573     pstScreen->lCharWidth -= 1;
	mov	eax,[ebp+08h];	pstScreen
	mov	[ebp-04h],eax;	@CBE5
	mov	eax,[ebp-04h];	@CBE5
	mov	ecx,[eax+027h]
	dec	ecx
	mov	[eax+027h],ecx

; 574     pstScreen->lCharSize = (pstScreen->lCharWidth * pstScreen->lC
; 574 harHeight);
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ecx+02bh]
	imul	ecx,[eax+027h]
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+023h],ecx

; 575     SetScrollRowCount(pstScreen);
	push	dword ptr [ebp+08h];	pstScreen
	call	SetScrollRowCount
	add	esp,04h

; 576     WinSendMsg(pstScreen->hwndScroll,
	push	dword ptr [ebp+08h];	pstScreen
	call	GetRowScrollRow
	add	esp,04h
	mov	ecx,[ebp+08h];	pstScreen
	mov	cx,[ecx+067h]
	and	ecx,0ffffh
	sal	ecx,010h
	push	ecx
	and	eax,0ffffh
	push	eax
	push	01a0h
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+05fh]
	call	WinSendMsg
	add	esp,010h

; 577                SBM_SETSCROLLBAR,
; 578                MPFROMSHORT(GetRowScrollRow(pstScreen)),
; 579                MPFROM2SHORT(0,pstScreen->lScrollRowCount));
; 580     WinSendMsg(pstScreen->hwndScroll,
	push	0h
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ecx+02bh]
	add	ecx,[eax+067h]
	and	ecx,0ffffh
	sal	ecx,010h
	mov	eax,[ebp+08h];	pstScreen
	mov	ax,[eax+02bh]
	and	eax,0ffffh
	or	eax,ecx
	push	eax
	push	01a6h
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+05fh]
	call	WinSendMsg
	add	esp,010h

; 581                SBM_SETTHUMBSIZE,
; 582 //               MPFROM2SHORT(1,(pstScreen->lScrollRowCount)),
; 583 //               MPFROM2SHORT(pstScreen->lCharHeight,(pstScreen->lScrollRowCount)),
; 584                MPFROM2SHORT(pstScreen->lCharHeight,((pstScreen->lScrollRowCount) + pstScreen->lCharHeight)),
; 585               (MPARAM)NULL);
; 586     }
	jmp	@BLBL131
	align 010h
@BLBL130:

; 587 #if DEBUG > 0
; 588   else
; 589     DisplayLastWindowError("@ SetupRowScrolling");
	push	offset FLAT:@STAT1
	call	DisplayLastWindowError
	add	esp,04h
@BLBL131:

; 590 #endif
; 591  fLastScroll = 0;
	mov	dword ptr  fLastScroll,0h

; 592  }
	mov	esp,ebp
	pop	ebp
	ret	
SetupRowScrolling	endp

; 595   {
	align 010h

	public RowScroll
RowScroll	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax

; 596   LONG lScrollIndex = pstScreen->lScrollIndex;
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+06fh]
	mov	[ebp-04h],eax;	lScrollIndex

; 597   LONG lOldIndex = lScrollIndex;
	mov	eax,[ebp-04h];	lScrollIndex
	mov	[ebp-08h],eax;	lOldIndex

; 598   LONG lScrollRow = pstScreen->lScrollRow;
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+06bh]
	mov	[ebp-0ch],eax;	lScrollRow

; 599 
; 600   if (bIsPosition)
	cmp	dword ptr [ebp+010h],0h;	bIsPosition
	je	@BLBL132

; 601     {
; 602     lScrollIndex = GetPartialCharCount(pstScreen,0L,(pstScreen->lCharWidth * iRows));
	movsx	eax,word ptr [ebp+0ch];	iRows
	mov	ecx,[ebp+08h];	pstScreen
	imul	eax,[ecx+027h]
	push	eax
	push	0h
	push	dword ptr [ebp+08h];	pstScreen
	call	GetPartialCharCount
	add	esp,0ch
	mov	[ebp-04h],eax;	lScrollIndex

; 603     lScrollRow = iRows;
	movsx	eax,word ptr [ebp+0ch];	iRows
	mov	[ebp-0ch],eax;	lScrollRow

; 604     }
	jmp	@BLBL133
	align 010h
@BLBL132:

; 605   else
; 606     {
; 607     lScrollRow += iRows;
	movsx	eax,word ptr [ebp+0ch];	iRows
	add	eax,[ebp-0ch];	lScrollRow
	mov	[ebp-0ch],eax;	lScrollRow

; 608     if (lScrollRow >= pstScreen->lScrollRowCount)
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-0ch];	lScrollRow
	cmp	[eax+067h],ecx
	jg	@BLBL134

; 609       {
; 610       lScrollRow = pstScreen->lScrollRowCount;
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+067h]
	mov	[ebp-0ch],eax;	lScrollRow

; 611       lScrollIndex = pstScreen->lScrollEndIndex;
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+063h]
	mov	[ebp-04h],eax;	lScrollIndex

; 612       }
	jmp	@BLBL133
	align 010h
@BLBL134:

; 613     else
; 614       {
; 615       if (lScrollRow <= 0)
	cmp	dword ptr [ebp-0ch],0h;	lScrollRow
	jg	@BLBL136

; 616         {
; 617         lScrollIndex = 0L;
	mov	dword ptr [ebp-04h],0h;	lScrollIndex

; 618         lScrollRow = 0;
	mov	dword ptr [ebp-0ch],0h;	lScrollRow

; 619         }
	jmp	@BLBL133
	align 010h
@BLBL136:

; 620       else
; 621         {
; 622         lScrollIndex = GetPartialCharCount(pstScreen,lScrollIndex,(pstScreen->lCharWidth * iRows));
	movsx	eax,word ptr [ebp+0ch];	iRows
	mov	ecx,[ebp+08h];	pstScreen
	imul	eax,[ecx+027h]
	push	eax
	push	dword ptr [ebp-04h];	lScrollIndex
	push	dword ptr [ebp+08h];	pstScreen
	call	GetPartialCharCount
	add	esp,0ch
	mov	[ebp-04h],eax;	lScrollIndex

; 623         if (lScrollIndex > pstScreen->lScrollEndIndex)
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-04h];	lScrollIndex
	cmp	[eax+063h],ecx
	jge	@BLBL138

; 624           lScrollIndex = pstScreen->lScrollEndIndex;
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+063h]
	mov	[ebp-04h],eax;	lScrollIndex
	jmp	@BLBL133
	align 010h
@BLBL138:

; 625         else
; 626           if (lScrollIndex < 0L)
	cmp	dword ptr [ebp-04h],0h;	lScrollIndex
	jge	@BLBL133

; 627             lScrollIndex = 0L;
	mov	dword ptr [ebp-04h],0h;	lScrollIndex

; 628         }

; 629       }

; 630     }
@BLBL133:

; 631   if (lOldIndex != lScrollIndex)
	mov	eax,[ebp-04h];	lScrollIndex
	cmp	[ebp-08h],eax;	lOldIndex
	je	@BLBL141

; 632     {
; 633     pstScreen->lScrollIndex = lScrollIndex;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-04h];	lScrollIndex
	mov	[eax+06fh],ecx

; 634     pstScreen->lScrollRow = lScrollRow;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-0ch];	lScrollRow
	mov	[eax+06bh],ecx

; 635     WinSendMsg(pstScreen->hwndScroll,
	push	0h
	mov	ax,[ebp-0ch];	lScrollRow
	and	eax,0ffffh
	push	eax
	push	01a1h
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+05fh]
	call	WinSendMsg
	add	esp,010h

; 636                SBM_SETPOS,
; 637                MPFROMSHORT(lScrollRow),
; 638                MPFROMSHORT(0));
; 639     WinInvalidateRect(pstScreen->hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+0fh]
	call	WinInvalidateRect
	add	esp,0ch

; 640     if (stWrite.bSync || stRead.bSync)
	test	byte ptr  stWrite+02h,010h
	jne	@BLBL142
	test	byte ptr  stRead+02h,010h
	je	@BLBL141
@BLBL142:

; 641       {
; 642       stWrite.lScrollIndex = lScrollIndex;
	mov	eax,[ebp-04h];	lScrollIndex
	mov	dword ptr  stWrite+06fh,eax

; 643       stWrite.lScrollRow = GetColScrollRow(&stWrite,0);
	push	0h
	push	offset FLAT:stWrite
	call	GetColScrollRow
	add	esp,08h
	mov	dword ptr  stWrite+06bh,eax

; 644       stRead.lScrollIndex = lScrollIndex;
	mov	eax,[ebp-04h];	lScrollIndex
	mov	dword ptr  stRead+06fh,eax

; 645       stRead.lScrollRow = GetColScrollRow(&stRead,0);
	push	0h
	push	offset FLAT:stRead
	call	GetColScrollRow
	add	esp,08h
	mov	dword ptr  stRead+06bh,eax

; 646       }

; 647     }
@BLBL141:

; 648   }
	mov	esp,ebp
	pop	ebp
	ret	
RowScroll	endp

; 687   {
	align 010h

	public ClearColScrollBar
ClearColScrollBar	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax

; 688   if (pstScreen->hwndScroll != (HWND)NULL)
	mov	eax,[ebp+08h];	pstScreen
	cmp	dword ptr [eax+05fh],0h
	je	@BLBL144

; 689     {
; 690     WinDestroyWindow(pstScreen->hwndScroll);
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+05fh]
	call	WinDestroyWindow
	add	esp,04h

; 691     pstScreen->hwndScroll = (HWND)NULL;
	mov	eax,[ebp+08h];	pstScreen
	mov	dword ptr [eax+05fh],0h

; 692 //    pstScreen->lScrollRow = 0;
; 693     pstScreen->lWidth += stCell.cx;
	mov	eax,[ebp+08h];	pstScreen
	mov	[ebp-0ch],eax;	@CBE9
	movsx	ecx,word ptr  stCell
	mov	eax,[ebp-0ch];	@CBE9
	add	ecx,[eax+033h]
	mov	[eax+033h],ecx

; 694     pstScreen->lCharWidth += 1;
	mov	eax,[ebp+08h];	pstScreen
	mov	[ebp-08h],eax;	@CBE8
	mov	eax,[ebp-08h];	@CBE8
	mov	ecx,[eax+027h]
	inc	ecx
	mov	[eax+027h],ecx

; 695     pstScreen->lCharSize = (pstScreen->lCharWidth * pstScreen->lCharHeight);
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ecx+02bh]
	imul	ecx,[eax+027h]
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+023h],ecx

; 696     pstScreen->rclDisp.xRight += stCell.cx;
	mov	eax,[ebp+08h];	pstScreen
	mov	[ebp-04h],eax;	@CBE7
	movsx	ecx,word ptr  stCell
	mov	eax,[ebp-04h];	@CBE7
	add	ecx,[eax+047h]
	mov	[eax+047h],ecx

; 697     }
@BLBL144:

; 698   }
	mov	esp,ebp
	pop	ebp
	ret	
ClearColScrollBar	endp

; 701   {
	align 010h

	public ColScroll
ColScroll	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax

; 702   LONG lScrollIndex = pstScreen->lScrollIndex;
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+06fh]
	mov	[ebp-04h],eax;	lScrollIndex

; 703   LONG lOldIndex = lScrollIndex;
	mov	eax,[ebp-04h];	lScrollIndex
	mov	[ebp-08h],eax;	lOldIndex

; 704   LONG lScrollRow = pstScreen->lScrollRow;
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+06bh]
	mov	[ebp-0ch],eax;	lScrollRow

; 705 
; 706   if (bIsPosition)
	cmp	dword ptr [ebp+010h],0h;	bIsPosition
	je	@BLBL145

; 707     {
; 708     lScrollIndex = GetColScrollIndex(pstScreen,iRows - lScrollRow);
	movsx	eax,word ptr [ebp+0ch];	iRows
	sub	eax,[ebp-0ch];	lScrollRow
	push	eax
	push	dword ptr [ebp+08h];	pstScreen
	call	GetColScrollIndex
	add	esp,08h
	mov	[ebp-04h],eax;	lScrollIndex

; 709     lScrollRow = iRows;
	movsx	eax,word ptr [ebp+0ch];	iRows
	mov	[ebp-0ch],eax;	lScrollRow

; 710     }
	jmp	@BLBL146
	align 010h
@BLBL145:

; 711   else
; 712     {
; 713     lScrollRow += iRows;
	movsx	eax,word ptr [ebp+0ch];	iRows
	add	eax,[ebp-0ch];	lScrollRow
	mov	[ebp-0ch],eax;	lScrollRow

; 714     if (lScrollRow >= pstScreen->lScrollRowCount)
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-0ch];	lScrollRow
	cmp	[eax+067h],ecx
	jg	@BLBL147

; 715       {
; 716       lScrollRow = pstScreen->lScrollRowCount;
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+067h]
	mov	[ebp-0ch],eax;	lScrollRow

; 717       lScrollIndex = pstScreen->lScrollEndIndex;
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+063h]
	mov	[ebp-04h],eax;	lScrollIndex

; 718       }
	jmp	@BLBL146
	align 010h
@BLBL147:

; 719     else
; 720       {
; 721       if (lScrollRow <= 0)
	cmp	dword ptr [ebp-0ch],0h;	lScrollRow
	jg	@BLBL149

; 722         {
; 723         lScrollIndex = 0L;
	mov	dword ptr [ebp-04h],0h;	lScrollIndex

; 724         lScrollRow = 0L;
	mov	dword ptr [ebp-0ch],0h;	lScrollRow

; 725         }
	jmp	@BLBL146
	align 010h
@BLBL149:

; 726       else
; 727         {
; 728         lScrollIndex = GetColScrollIndex(pstScreen,iRows);
	movsx	eax,word ptr [ebp+0ch];	iRows
	push	eax
	push	dword ptr [ebp+08h];	pstScreen
	call	GetColScrollIndex
	add	esp,08h
	mov	[ebp-04h],eax;	lScrollIndex

; 729         if (lScrollIndex > pstScreen->lScrollEndIndex)
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-04h];	lScrollIndex
	cmp	[eax+063h],ecx
	jge	@BLBL151

; 730           lScrollIndex = pstScreen->lScrollEndIndex;
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+063h]
	mov	[ebp-04h],eax;	lScrollIndex
	jmp	@BLBL146
	align 010h
@BLBL151:

; 731         else
; 732           if (lScrollIndex < 0L)
	cmp	dword ptr [ebp-04h],0h;	lScrollIndex
	jge	@BLBL146

; 733             lScrollIndex = 0L;
	mov	dword ptr [ebp-04h],0h;	lScrollIndex

; 734         }

; 735       }

; 736     }
@BLBL146:

; 737   if (lOldIndex != lScrollIndex)
	mov	eax,[ebp-04h];	lScrollIndex
	cmp	[ebp-08h],eax;	lOldIndex
	je	@BLBL154

; 738     {
; 739     pstScreen->lScrollIndex = lScrollIndex;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-04h];	lScrollIndex
	mov	[eax+06fh],ecx

; 740     pstScreen->lScrollRow = lScrollRow;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-0ch];	lScrollRow
	mov	[eax+06bh],ecx

; 741     WinSendMsg(pstScreen->hwndScroll,
	push	0h
	mov	eax,[ebp+08h];	pstScreen
	mov	ax,[eax+06bh]
	and	eax,0ffffh
	push	eax
	push	01a1h
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+05fh]
	call	WinSendMsg
	add	esp,010h

; 742                SBM_SETPOS,
; 743                MPFROMSHORT(pstScreen->lScrollRow),
; 744                MPFROMSHORT(0));
; 745     WinInvalidateRect(pstScreen->hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+0fh]
	call	WinInvalidateRect
	add	esp,0ch

; 746     if (pstScreen->bSync)
	mov	eax,[ebp+08h];	pstScreen
	test	byte ptr [eax+02h],010h
	je	@BLBL155

; 747       if (pstScreen->wDirection & CS_WRITE)
	mov	eax,[ebp+08h];	pstScreen
	test	byte ptr [eax+06h],080h
	je	@BLBL156

; 748         {
; 749         stRead.lScrollIndex = lScrollIndex;
	mov	eax,[ebp-04h];	lScrollIndex
	mov	dword ptr  stRead+06fh,eax

; 750         WinInvalidateRect(stRead.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stRead+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 751         }
	jmp	@BLBL155
	align 010h
@BLBL156:

; 752       else
; 753         {
; 754         stWrite.lScrollIndex = lScrollIndex;
	mov	eax,[ebp-04h];	lScrollIndex
	mov	dword ptr  stWrite+06fh,eax

; 755         WinInvalidateRect(stWrite.hwndClient,(PRECTL)NULL,FALSE);
	push	0h
	push	0h
	push	dword ptr  stWrite+0fh
	call	WinInvalidateRect
	add	esp,0ch

; 756         }
@BLBL155:

; 757     fLastScroll = pstScreen->wDirection;
	mov	ecx,[ebp+08h];	pstScreen
	xor	eax,eax
	mov	ax,[ecx+05h]
	mov	dword ptr  fLastScroll,eax

; 758     if (pstScreen->bSync)
	mov	eax,[ebp+08h];	pstScreen
	test	byte ptr [eax+02h],010h
	je	@BLBL154

; 759       {
; 760       stRow.lScrollIndex = lScrollIndex;
	mov	eax,[ebp-04h];	lScrollIndex
	mov	dword ptr  stRow+06fh,eax

; 761       stRow.lScrollRow = GetRowScrollRow(&stRow);
	push	offset FLAT:stRow
	call	GetRowScrollRow
	add	esp,04h
	mov	dword ptr  stRow+06bh,eax

; 762       }

; 763     }
@BLBL154:

; 764   }
	mov	esp,ebp
	pop	ebp
	ret	
ColScroll	endp

; 767   {
	align 010h

	public AdjustScrollBar
AdjustScrollBar	proc
	push	ebp
	mov	ebp,esp

; 768   SetColScrollRowCount(pstScreen);
	push	dword ptr [ebp+08h];	pstScreen
	call	SetColScrollRowCount
	add	esp,04h

; 769   WinSendMsg(pstScreen->hwndScroll,
	mov	eax,[ebp+08h];	pstScreen
	mov	ax,[eax+067h]
	and	eax,0ffffh
	sal	eax,010h
	push	eax
	mov	eax,[ebp+08h];	pstScreen
	mov	ax,[eax+06bh]
	and	eax,0ffffh
	push	eax
	push	01a0h
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+05fh]
	call	WinSendMsg
	add	esp,010h

; 770              SBM_SETSCROLLBAR,
; 771              MPFROMSHORT(pstScreen->lScrollRow),
; 772              MPFROM2SHORT(0,pstScreen->lScrollRowCount));
; 773   WinSendMsg(pstScreen->hwndScroll,
	push	0h
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ecx+02bh]
	add	ecx,[eax+067h]
	and	ecx,0ffffh
	sal	ecx,010h
	mov	eax,[ebp+08h];	pstScreen
	mov	ax,[eax+02bh]
	and	eax,0ffffh
	or	eax,ecx
	push	eax
	push	01a6h
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+05fh]
	call	WinSendMsg
	add	esp,010h

; 774              SBM_SETTHUMBSIZE,
; 775              MPFROM2SHORT(pstScreen->lCharHeight,(pstScreen->lScrollRowCount + pstScreen->lCharHeight)),
; 776             (MPARAM)NULL);
; 777   }
	mov	esp,ebp
	pop	ebp
	ret	
AdjustScrollBar	endp

; 780   {
	align 010h

	public SetupColScrolling
SetupColScrolling	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax

; 781   ClearColScrollBar(pstScreen);
	push	dword ptr [ebp+08h];	pstScreen
	call	ClearColScrollBar
	add	esp,04h

; 782   pstScreen->hwndScroll = WinCreateWindow(pstScreen->hwndClient,
	push	0h
	push	0h
	push	05208h
	push	03h
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+0fh]
	movsx	eax,word ptr  stCell+02h
	mov	ecx,[ebp+08h];	pstScreen
	add	eax,[ecx+02fh]
	inc	eax
	push	eax
	movsx	eax,word ptr  stCell
	push	eax
	push	0ffffffffh
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+033h]
	push	080000001h
	push	0h
	push	0ffff0008h
	mov	eax,[ebp+08h];	pstScreen
	push	dword ptr [eax+0fh]
	call	WinCreateWindow
	mov	ecx,eax
	add	esp,034h
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+05fh],ecx

; 783                                WC_SCROLLBAR,
; 784                           (PSZ)NULL,
; 785                                SBS_VERT | WS_VISIBLE,
; 786                                pstScreen->lWidth,
; 787                                -1,
; 788                                stCell.cx,
; 789                               (pstScreen->lHeight + stCell.cy + 1),
; 790                                pstScreen->hwndClient,
; 791                                HWND_TOP,
; 792                                WID_VSCROLL_BAR,
; 793                                NULL,NULL);
; 794   if (pstScreen->hwndScroll != (HWND)NULL)
	mov	eax,[ebp+08h];	pstScreen
	cmp	dword ptr [eax+05fh],0h
	je	@BLBL159

; 795     {
; 796     pstScreen->lWidth -= stCell.cx;
	mov	eax,[ebp+08h];	pstScreen
	mov	[ebp-0ch],eax;	@CBE12
	mov	eax,[ebp-0ch];	@CBE12
	mov	ecx,[eax+033h]
	movsx	edx,word ptr  stCell
	sub	ecx,edx
	mov	[eax+033h],ecx

; 797     pstScreen->lCharWidth -= 1;
	mov	eax,[ebp+08h];	pstScreen
	mov	[ebp-08h],eax;	@CBE11
	mov	eax,[ebp-08h];	@CBE11
	mov	ecx,[eax+027h]
	dec	ecx
	mov	[eax+027h],ecx

; 798     pstScreen->lCharSize = (pstScreen->lCharWidth * pstScreen->lCharHeight);
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ecx+02bh]
	imul	ecx,[eax+027h]
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+023h],ecx

; 799     pstScreen->rclDisp.xRight -= stCell.cx;
	mov	eax,[ebp+08h];	pstScreen
	mov	[ebp-04h],eax;	@CBE10
	mov	eax,[ebp-04h];	@CBE10
	mov	ecx,[eax+047h]
	movsx	edx,word ptr  stCell
	sub	ecx,edx
	mov	[eax+047h],ecx

; 800     AdjustScrollBar(pstScreen);
	push	dword ptr [ebp+08h];	pstScreen
	call	AdjustScrollBar
	add	esp,04h

; 801     }
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL159:

; 802 #if DEBUG > 0
; 803   else
; 804     DisplayLastWindowError("@ SetupColScrolling");
	push	offset FLAT:@STAT2
	call	DisplayLastWindowError
	add	esp,04h

; 805 #endif
; 806   }
	mov	esp,ebp
	pop	ebp
	ret	
SetupColScrolling	endp

; 809   {
	align 010h

	public GetColScrollRow
GetColScrollRow	proc
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

; 811   LONG lRowCount = 0;
	mov	dword ptr [ebp-08h],0h;	lRowCount

; 812   LONG lCharCount = 0;
	mov	dword ptr [ebp-0ch],0h;	lCharCount

; 813   BOOL bSkip;
; 814   BOOL bLastWasNewLine = FALSE;
	mov	dword ptr [ebp-014h],0h;	bLastWasNewLine

; 815   WORD wNewLine;
; 816   WORD wDirection;
; 817   WORD wChar;
; 818   WORD wFilterMask;
; 819   ULONG ulElementCount;
; 820 
; 821   if (pwScrollBuffer == NULL)
	cmp	dword ptr  pwScrollBuffer,0h
	jne	@BLBL161

; 822     return(0);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL161:

; 823   wDirection = (pstScreen->wDirection & 0xf000);
	mov	eax,[ebp+08h];	pstScreen
	mov	ax,[eax+05h]
	and	ax,0f000h
	mov	[ebp-018h],ax;	wDirection

; 824   if (pstScreen->bTestNewLine)
	mov	eax,[ebp+08h];	pstScreen
	test	byte ptr [eax+02h],02h
	je	@BLBL162

; 825     {
; 826     if (pstScreen->bFilter)
	mov	eax,[ebp+08h];	pstScreen
	test	byte ptr [eax+02h],020h
	je	@BLBL163

; 827       wFilterMask = (WORD)pstScreen->byDisplayMask;
	mov	ecx,[ebp+08h];	pstScreen
	xor	ax,ax
	mov	al,[ecx+04h]
	mov	[ebp-01ch],ax;	wFilterMask
	jmp	@BLBL164
	align 010h
@BLBL163:

; 828     else
; 829       wFilterMask = 0x00ff;
	mov	word ptr [ebp-01ch],0ffh;	wFilterMask
@BLBL164:

; 830     bSkip = pstScreen->bSkipBlankLines;
	mov	eax,[ebp+08h];	pstScreen
	mov	al,[eax+02h]
	and	eax,07h
	shr	eax,02h
	mov	[ebp-010h],eax;	bSkip

; 831     wNewLine = (WORD)pstScreen->byNewLineChar;
	mov	ecx,[ebp+08h];	pstScreen
	xor	ax,ax
	mov	al,[ecx+03h]
	mov	[ebp-016h],ax;	wNewLine

; 832     for (lIndex = lStartIndex;lIndex < pstScreen->lScrollIndex;lIndex++)
	mov	eax,[ebp+0ch];	lStartIndex
	mov	[ebp-04h],eax;	lIndex
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-04h];	lIndex
	cmp	[eax+06fh],ecx
	jle	@BLBL176
	align 010h
@BLBL166:

; 833       {
; 834       wChar = (pwScrollBuffer[lIndex] & 0xff00);
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-04h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	and	ax,0ff00h
	mov	[ebp-01ah],ax;	wChar

; 835       if ((wChar & 0xf000) != wDirection)
	mov	ax,[ebp-01ah];	wChar
	and	ax,0f000h
	cmp	[ebp-018h],ax;	wDirection
	jne	@BLBL168

; 836         continue;
; 837       wChar &= wFilterMask;
	mov	ax,[ebp-01ch];	wFilterMask
	and	ax,[ebp-01ah];	wChar
	mov	[ebp-01ah],ax;	wChar

; 838       if (wChar == wNewLine)
	mov	ax,[ebp-016h];	wNewLine
	cmp	[ebp-01ah],ax;	wChar
	jne	@BLBL169

; 839         {
; 840         if (bSkip)
	cmp	dword ptr [ebp-010h],0h;	bSkip
	je	@BLBL170

; 841           {
; 842           if (!bLastWasNe
; 842 wLine)
	cmp	dword ptr [ebp-014h],0h;	bLastWasNewLine
	jne	@BLBL168

; 843             {
; 844             bLastWasNewLine = TRUE;
	mov	dword ptr [ebp-014h],01h;	bLastWasNewLine

; 845             lRowCount++;
	mov	eax,[ebp-08h];	lRowCount
	inc	eax
	mov	[ebp-08h],eax;	lRowCount

; 846             }

; 847           }
	jmp	@BLBL168
	align 010h
@BLBL170:

; 848         else
; 849           lRowCount++;
	mov	eax,[ebp-08h];	lRowCount
	inc	eax
	mov	[ebp-08h],eax;	lRowCount

; 850         }
	jmp	@BLBL168
	align 010h
@BLBL169:

; 851       else
; 852         if (CharPrintable((BYTE *)&wChar,pstScreen))
	push	dword ptr [ebp+08h];	pstScreen
	lea	eax,[ebp-01ah];	wChar
	push	eax
	call	CharPrintable
	add	esp,08h
	test	eax,eax
	je	@BLBL168

; 853           bLastWasNewLine = FALSE;
	mov	dword ptr [ebp-014h],0h;	bLastWasNewLine

; 854       }
@BLBL168:

; 832     for (lIndex = lStartIndex;lIndex < pstScreen->lScrollIndex;lIndex++)
	mov	eax,[ebp-04h];	lIndex
	inc	eax
	mov	[ebp-04h],eax;	lIndex
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-04h];	lIndex
	cmp	[eax+06fh],ecx
	jg	@BLBL166

; 855     }
	jmp	@BLBL176
	align 010h
@BLBL162:

; 858     for (lIndex = lStartIndex;lIndex < pstScreen->lScrollIndex;lIndex++)
	mov	eax,[ebp+0ch];	lStartIndex
	mov	[ebp-04h],eax;	lIndex
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-04h];	lIndex
	cmp	[eax+06fh],ecx
	jle	@BLBL177
	align 010h
@BLBL178:

; 860       if ((ulElementCount = CountTraceElement(pwScrollBuffer[lIndex],wDirection)) == 1)
	mov	ax,[ebp-018h];	wDirection
	push	eax
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-04h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	push	eax
	call	CountTraceElement
	add	esp,08h
	mov	[ebp-020h],eax;	ulElementCount
	cmp	dword ptr [ebp-020h],01h;	ulElementCount
	jne	@BLBL179

; 861         lCharCount++;
	mov	eax,[ebp-0ch];	lCharCount
	inc	eax
	mov	[ebp-0ch],eax;	lCharCount
@BLBL179:

; 862       if (ulElementCount > 1)
	cmp	dword ptr [ebp-020h],01h;	ulElementCount
	jbe	@BLBL180

; 863          lIndex += ulElementCount;
	mov	eax,[ebp-04h];	lIndex
	add	eax,[ebp-020h];	ulElementCount
	mov	[ebp-04h],eax;	lIndex
@BLBL180:

; 864       }

; 858     for (lIndex = lStartIndex;lIndex < pstScreen->lScrollIndex;lIndex++)
	mov	eax,[ebp-04h];	lIndex
	inc	eax
	mov	[ebp-04h],eax;	lIndex
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-04h];	lIndex
	cmp	[eax+06fh],ecx
	jg	@BLBL178
@BLBL177:

; 865     lRowCount = (lCharCount / pstScreen->lCharWidth);
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp-0ch];	lCharCount
	cdq	
	idiv	dword ptr [ecx+027h]
	mov	[ebp-08h],eax;	lRowCount

; 866     }
@BLBL176:

; 867   return(lRowCount);
	mov	eax,[ebp-08h];	lRowCount
	mov	esp,ebp
	pop	ebp
	ret	
GetColScrollRow	endp

; 871   {
	align 010h

SetColScrollRowCount	proc
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

; 873   LONG lRowCount = 0;
	mov	dword ptr [ebp-08h],0h;	lRowCount

; 874   LONG lCharCount = 0;
	mov	dword ptr [ebp-0ch],0h;	lCharCount

; 875   BOOL bSkip;
; 876   BOOL bLastWasNewLine = FALSE;
	mov	dword ptr [ebp-014h],0h;	bLastWasNewLine

; 877   WORD wNewLine;
; 878   WORD wDirection;
; 879   WORD wChar;
; 880   WORD wFilterMask;
; 881 
; 882   if (pwScrollBuffer == NULL)
	cmp	dword ptr  pwScrollBuffer,0h
	jne	@BLBL182

; 883     {
; 884     pstScreen->lScrollRowCount = 0;
	mov	eax,[ebp+08h];	pstScreen
	mov	dword ptr [eax+067h],0h

; 885     return;
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL182:

; 886     }
; 887   CalcColScrollEndIndex(pstScreen);
	push	dword ptr [ebp+08h];	pstScreen
	call	CalcColScrollEndIndex
	add	esp,04h

; 888   wDirection = pstScreen->wDirection;
	mov	eax,[ebp+08h];	pstScreen
	mov	ax,[eax+05h]
	mov	[ebp-018h],ax;	wDirection

; 889   if (pstScreen->bTestNewLine)
	mov	eax,[ebp+08h];	pstScreen
	test	byte ptr [eax+02h],02h
	je	@BLBL183

; 890     {
; 891     if (pstScreen->bFilter)
	mov	eax,[ebp+08h];	pstScreen
	test	byte ptr [eax+02h],020h
	je	@BLBL184

; 892       wFilterMask = (WORD)pstScreen->byDisplayMask;
	mov	ecx,[ebp+08h];	pstScreen
	xor	ax,ax
	mov	al,[ecx+04h]
	mov	[ebp-01ch],ax;	wFilterMask
	jmp	@BLBL185
	align 010h
@BLBL184:

; 893     else
; 894       wFilterMask = 0x00ff;
	mov	word ptr [ebp-01ch],0ffh;	wFilterMask
@BLBL185:

; 895     bSkip = pstScreen->bSkipBlankLines;
	mov	eax,[ebp+08h];	pstScreen
	mov	al,[eax+02h]
	and	eax,07h
	shr	eax,02h
	mov	[ebp-010h],eax;	bSkip

; 896     wNewLine = (WORD)pstScreen->byNewLineChar;
	mov	ecx,[ebp+08h];	pstScreen
	xor	ax,ax
	mov	al,[ecx+03h]
	mov	[ebp-016h],ax;	wNewLine

; 897     for (lIndex = 0;lIndex < pstScreen->lScrollEndIndex;lIndex++)
	mov	dword ptr [ebp-04h],0h;	lIndex
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-04h];	lIndex
	cmp	[eax+063h],ecx
	jle	@BLBL197
	align 010h
@BLBL187:

; 898       {
; 899       if (((wChar = pwScrollBuffer[lIndex]) & 0xff00) != wDirection)
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-04h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	mov	[ebp-01ah],ax;	wChar
	mov	ax,[ebp-01ah];	wChar
	and	ax,0ff00h
	cmp	[ebp-018h],ax;	wDirection
	jne	@BLBL189

; 900         continue;
; 901       wChar &= wFilterMask;
	mov	ax,[ebp-01ch];	wFilterMask
	and	ax,[ebp-01ah];	wChar
	mov	[ebp-01ah],ax;	wChar

; 902       if (wChar == wNewLine)
	mov	ax,[ebp-016h];	wNewLine
	cmp	[ebp-01ah],ax;	wChar
	jne	@BLBL190

; 903         {
; 904         if (bSkip)
	cmp	dword ptr [ebp-010h],0h;	bSkip
	je	@BLBL191

; 905           {
; 906           if (!bLastWasNewLine)
	cmp	dword ptr [ebp-014h],0h;	bLastWasNewLine
	jne	@BLBL189

; 907             {
; 908             bLastWasNewLine = TRUE;
	mov	dword ptr [ebp-014h],01h;	bLastWasNewLine

; 909             lRowCount++;
	mov	eax,[ebp-08h];	lRowCount
	inc	eax
	mov	[ebp-08h],eax;	lRowCount

; 910             }

; 911           }
	jmp	@BLBL189
	align 010h
@BLBL191:

; 912         else
; 913           lRowCount++;
	mov	eax,[ebp-08h];	lRowCount
	inc	eax
	mov	[ebp-08h],eax;	lRowCount

; 914         }
	jmp	@BLBL189
	align 010h
@BLBL190:

; 915       else
; 916         if (CharPrintable((BYTE *)&wChar,pstScreen))
	push	dword ptr [ebp+08h];	pstScreen
	lea	eax,[ebp-01ah];	wChar
	push	eax
	call	CharPrintable
	add	esp,08h
	test	eax,eax
	je	@BLBL189

; 917           bLastWasNewLine = FALSE;
	mov	dword ptr [ebp-014h],0h;	bLastWasNewLine

; 918       }
@BLBL189:

; 897     for (lIndex = 0;lIndex < pstScreen->lScrollEndIndex;lIndex++)
	mov	eax,[ebp-04h];	lIndex
	inc	eax
	mov	[ebp-04h],eax;	lIndex
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-04h];	lIndex
	cmp	[eax+063h],ecx
	jg	@BLBL187

; 919     }
	jmp	@BLBL197
	align 010h
@BLBL183:

; 922     for (lIndex = 0;lIndex < pstScreen->lScrollEndIndex;lIndex++)
	mov	dword ptr [ebp-04h],0h;	lIndex
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-04h];	lIndex
	cmp	[eax+063h],ecx
	jle	@BLBL198
	align 010h
@BLBL199:

; 924       if ((pwScrollBuffer[lIndex] & 0xff00) == wDirection)
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-04h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	and	ax,0ff00h
	cmp	[ebp-018h],ax;	wDirection
	jne	@BLBL200

; 925         lCharCount++;
	mov	eax,[ebp-0ch];	lCharCount
	inc	eax
	mov	[ebp-0ch],eax;	lCharCount
@BLBL200:

; 926       }

; 922     for (lIndex = 0;lIndex < pstScreen->lScrollEndIndex;lIndex++)
	mov	eax,[ebp-04h];	lIndex
	inc	eax
	mov	[ebp-04h],eax;	lIndex
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-04h];	lIndex
	cmp	[eax+063h],ecx
	jg	@BLBL199
@BLBL198:

; 927     lRowCount = (lCharCount / pstScreen->lCharWidth);
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp-0ch];	lCharCount
	cdq	
	idiv	dword ptr [ecx+027h]
	mov	[ebp-08h],eax;	lRowCount

; 928     }
@BLBL197:

; 929   pstScreen->lScrollRowCount = lRowCount;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-08h];	lRowCount
	mov	[eax+067h],ecx

; 930   }
	mov	esp,ebp
	pop	ebp
	ret	
SetColScrollRowCount	endp

; 933   {
	align 010h

CalcColScrollEndIndex	proc
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

; 943   wDirection = pstScreen->wDirection;
	mov	eax,[ebp+08h];	pstScreen
	mov	ax,[eax+05h]
	mov	[ebp-08h],ax;	wDirection

; 944   if (pstScreen->bTestNewLine)
	mov	eax,[ebp+08h];	pstScreen
	test	byte ptr [eax+02h],02h
	je	@BLBL202

; 945     {
; 946     if (pstScreen->bFilter)
	mov	eax,[ebp+08h];	pstScreen
	test	byte ptr [eax+02h],020h
	je	@BLBL203

; 947       wFilterMask = (WORD)pstScreen->byDisplayMask;
	mov	ecx,[ebp+08h];	pstScreen
	xor	ax,ax
	mov	al,[ecx+04h]
	mov	[ebp-016h],ax;	wFilterMask
	jmp	@BLBL204
	align 010h
@BLBL203:

; 948     else
; 949       wFilterMask = 0x00ff;
	mov	word ptr [ebp-016h],0ffh;	wFilterMask
@BLBL204:

; 950     wNewLine = (WORD)pstScreen->byNewLineChar;
	mov	ecx,[ebp+08h];	pstScreen
	xor	ax,ax
	mov	al,[ecx+03h]
	mov	[ebp-06h],ax;	wNewLine

; 951     bWaitingPrintable = TRUE;
	mov	dword ptr [ebp-010h],01h;	bWaitingPrintable

; 952     lPrintableIndex = 0;
	mov	dword ptr [ebp-014h],0h;	lPrintableIndex

; 953     for (lIndex = (lScrollCount - 1);lIndex >= 0;lIndex--)
	mov	eax,dword ptr  lScrollCount
	dec	eax
	mov	[ebp-04h],eax;	lIndex
	cmp	dword ptr [ebp-04h],0h;	lIndex
	jl	@BLBL205
	align 010h
@BLBL206:

; 954       {
; 955       if (((wChar = pwScrollBuffer[lIndex]) & 0xff00) != wDirection)
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-04h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	mov	[ebp-0ah],ax;	wChar
	mov	ax,[ebp-0ah];	wChar
	and	ax,0ff00h
	cmp	[ebp-08h],ax;	wDirection
	jne	@BLBL208

; 956         continue;
; 957       wChar &= wFilterMask;
	mov	ax,[ebp-016h];	wFilterMask
	and	ax,[ebp-0ah];	wChar
	mov	[ebp-0ah],ax;	wChar

; 958       if (wChar == wNewLine)
	mov	ax,[ebp-06h];	wNewLine
	cmp	[ebp-0ah],ax;	wChar
	jne	@BLBL209

; 959         {
; 960         if (!bWaitingPrintable)
	cmp	dword ptr [ebp-010h],0h;	bWaitingPrintable
	je	@BLBL205

; 961           break;
; 962         }
	jmp	@BLBL208
	align 010h
@BLBL209:

; 963       else
; 964         if (CharPrintable((BYTE *)&wChar,pstScreen))
	push	dword ptr [ebp+08h];	pstScreen
	lea	eax,[ebp-0ah];	wChar
	push	eax
	call	CharPrintable
	add	esp,08h
	test	eax,eax
	je	@BLBL208

; 965           {
; 966           lPrintableIndex = lIndex;
	mov	eax,[ebp-04h];	lIndex
	mov	[ebp-014h],eax;	lPrintableIndex

; 967           bWaitingPrintable = FALSE;
	mov	dword ptr [ebp-010h],0h;	bWaitingPrintable

; 968           }

; 969       }
@BLBL208:

; 953     for (lIndex = (lScrollCount - 1);lIndex >= 0;lIndex--)
	mov	eax,[ebp-04h];	lIndex
	dec	eax
	mov	[ebp-04h],eax;	lIndex
	cmp	dword ptr [ebp-04h],0h;	lIndex
	jge	@BLBL206
@BLBL205:

; 970     if (lPrintableIndex < (lScrollCount - pstScreen->lCharSize))
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,dword ptr  lScrollCount
	sub	eax,[ecx+023h]
	cmp	[ebp-014h],eax;	lPrintableIndex
	jge	@BLBL214

; 971       pstScreen->lScrollEndIndex = (lScrollCount - pstScreen->lCharSize);
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,dword ptr  lScrollCount
	sub	ecx,[eax+023h]
	mov	eax,[ebp+08h];	pstScreen
	mov	[eax+063h],ecx
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL214:

; 973       pstScreen->lScrollEndIndex = lPrintableIndex;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-014h];	lPrintableIndex
	mov	[eax+063h],ecx

; 974     }
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL202:

; 977     for (lIndex = (lScrollCount - 1);lIndex >= 0;lIndex--)
	mov	eax,dword ptr  lScrollCount
	dec	eax
	mov	[ebp-04h],eax;	lIndex
	cmp	dword ptr [ebp-04h],0h;	lIndex
	jl	@BLBL216
	align 010h
@BLBL218:

; 978       if ((pwScrollBuffer[lIndex] & 0xff00) == wDirection)
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-04h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	and	ax,0ff00h
	cmp	[ebp-08h],ax;	wDirection
	jne	@BLBL219

; 980         pstScreen->lScrollEndIndex = lIndex;
	mov	eax,[ebp+08h];	pstScreen
	mov	ecx,[ebp-04h];	lIndex
	mov	[eax+063h],ecx

; 981         break;
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL219:

; 977     for (lIndex = (lScrollCount - 1);lIndex >= 0;lIndex--)
	mov	eax,[ebp-04h];	lIndex
	dec	eax
	mov	[ebp-04h],eax;	lIndex
	cmp	dword ptr [ebp-04h],0h;	lIndex
	jge	@BLBL218

; 983     }
@BLBL216:

; 984   }
	mov	esp,ebp
	pop	ebp
	ret	
CalcColScrollEndIndex	endp

; 987   {
	align 010h

GetColScrollIndex	proc
	push	ebp
	mov	ebp,esp
	sub	esp,028h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,0ah
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 995   LONG lStartIndex = pstScreen->lScrollIndex;
	mov	eax,[ebp+08h];	pstScreen
	mov	eax,[eax+06fh]
	mov	[ebp-01ch],eax;	lStartIndex

; 996   BOOL bLastWasNewLine = FALSE;
	mov	dword ptr [ebp-020h],0h;	bLastWasNewLine

; 997   LONG lPrintableIndex = lStartIndex;
	mov	eax,[ebp-01ch];	lStartIndex
	mov	[ebp-024h],eax;	lPrintableIndex

; 998   WORD wFilterMask;
; 999 
; 1000   if (lRowCount == 0)
	cmp	dword ptr [ebp+0ch],0h;	lRowCount
	jne	@BLBL221

; 1001     return(lStartIndex);
	mov	eax,[ebp-01ch];	lStartIndex
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL221:

; 1002   wDirection = pstScreen->wDirection;
	mov	eax,[ebp+08h];	pstScreen
	mov	ax,[eax+05h]
	mov	[ebp-016h],ax;	wDirection

; 1003   if (pstScreen->bTestNewLine)
	mov	eax,[ebp+08h];	pstScreen
	test	byte ptr [eax+02h],02h
	je	@BLBL222

; 1004     {
; 1005     if (pstScreen->bFilter)
	mov	eax,[ebp+08h];	pstScreen
	test	byte ptr [eax+02h],020h
	je	@BLBL223

; 1006       wFilterMask = (WORD)pstScreen->byDisplayMask;
	mov	ecx,[ebp+08h];	pstScreen
	xor	ax,ax
	mov	al,[ecx+04h]
	mov	[ebp-026h],ax;	wFilterMask
	jmp	@BLBL224
	align 010h
@BLBL223:

; 1007     else
; 1008       wFilterMask = 0x00ff;
	mov	word ptr [ebp-026h],0ffh;	wFilterMask
@BLBL224:

; 1009     wNewLine = (WORD)pstScreen->byNewLineChar;
	mov	ecx,[ebp+08h];	pstScreen
	xor	ax,ax
	mov	al,[ecx+03h]
	mov	[ebp-0ah],ax;	wNewLine

; 1010     if (lRowCount < 0)
	cmp	dword ptr [ebp+0ch],0h;	lRowCount
	jge	@BLBL225

; 1011       {
; 1012       bWaitingPrintable = TRUE;
	mov	dword ptr [ebp-014h],01h;	bWaitingPrintable

; 1013       for (lIndex = (lStartIndex - 1);lIndex >= 0;lIndex--)
	mov	eax,[ebp-01ch];	lStartIndex
	dec	eax
	mov	[ebp-04h],eax;	lIndex
	cmp	dword ptr [ebp-04h],0h;	lIndex
	jl	@BLBL226
	align 010h
@BLBL227:

; 1014         {
; 1015         if (((wChar = pwScrollBuffer[lIndex]) & 0xff00) != wDirection)
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-04h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	mov	[ebp-018h],ax;	wChar
	mov	ax,[ebp-018h];	wChar
	and	ax,0ff00h
	cmp	[ebp-016h],ax;	wDirection
	jne	@BLBL229

; 1016           continue;
; 1017         wChar &= wFilterMask;
	mov	ax,[ebp-026h];	wFilterMask
	and	ax,[ebp-018h];	wChar
	mov	[ebp-018h],ax;	wChar

; 1018         if (wChar == wNewLine)
	mov	ax,[ebp-0ah];	wNewLine
	cmp	[ebp-018h],ax;	wChar
	jne	@BLBL230

; 1019           {
; 1020           if (!bWaitingPrintable)
	cmp	dword ptr [ebp-014h],0h;	bWaitingPrintable
	jne	@BLBL229

; 1021             {
; 1022             if (++lRowCount >= 0)
	mov	eax,[ebp+0ch];	lRowCount
	inc	eax
	mov	[ebp+0ch],eax;	lRowCount
	cmp	dword ptr [ebp+0ch],0h;	lRowCount
	jge	@BLBL226

; 1023               break;
; 1024             else
; 1025               bWaitingPrintable = TRUE;
	mov	dword ptr [ebp-014h],01h;	bWaitingPrintable

; 1026             }

; 1027           }
	jmp	@BLBL229
	align 010h
@BLBL230:

; 1028         else
; 1029           if (CharPrintable((BYTE *)&wChar,pstScreen))
	push	dword ptr [ebp+08h];	pstScreen
	lea	eax,[ebp-018h];	wChar
	push	eax
	call	CharPrintable
	add	esp,08h
	test	eax,eax
	je	@BLBL229

; 1030             {
; 1031             lPrintableIndex = lIndex;
	mov	eax,[ebp-04h];	lIndex
	mov	[ebp-024h],eax;	lPrintableIndex

; 1032             bWaitingPrintable = FALSE;
	mov	dword ptr [ebp-014h],0h;	bWaitingPrintable

; 1033             }

; 1034         }
@BLBL229:

; 1013       for (lIndex = (lStartIndex - 1);lIndex >= 0;lIndex--)
	mov	eax,[ebp-04h];	lIndex
	dec	eax
	mov	[ebp-04h],eax;	lIndex
	cmp	dword ptr [ebp-04h],0h;	lIndex
	jge	@BLBL227
@BLBL226:

; 1035       lIndex = lPrintableIndex;
	mov	eax,[ebp-024h];	lPrintableIndex
	mov	[ebp-04h],eax;	lIndex

; 1036       }
	jmp	@BLBL253
	align 010h
@BLBL225:

; 1039       bSkip = pstScreen->bSkipBlankLines;
	mov	eax,[ebp+08h];	pstScreen
	mov	al,[eax+02h]
	and	eax,07h
	shr	eax,02h
	mov	[ebp-08h],eax;	bSkip

; 1040       bWaitingPrintable = FALSE;
	mov	dword ptr [ebp-014h],0h;	bWaitingPrintable

; 1041       for (lIndex = (lStartIndex + 1);lIndex < lScrollCount;lIndex++)
	mov	eax,[ebp-01ch];	lStartIndex
	inc	eax
	mov	[ebp-04h],eax;	lIndex
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-04h],eax;	lIndex
	jge	@BLBL253
	align 010h
@BLBL239:

; 1043         if (((wChar = pwScrollBuffer[lIndex]) & 0xff00) != wDirection)
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-04h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	mov	[ebp-018h],ax;	wChar
	mov	ax,[ebp-018h];	wChar
	and	ax,0ff00h
	cmp	[ebp-016h],ax;	wDirection
	jne	@BLBL241

; 1045         wChar &= wFilterMask;
	mov	ax,[ebp-026h];	wFilterMask
	and	ax,[ebp-018h];	wChar
	mov	[ebp-018h],ax;	wChar

; 1046         if (wChar == wNewLine)
	mov	ax,[ebp-0ah];	wNewLine
	cmp	[ebp-018h],ax;	wChar
	jne	@BLBL242

; 1048           if (!bWaitingPrintable)
	cmp	dword ptr [ebp-014h],0h;	bWaitingPrintable
	jne	@BLBL241

; 1050             if (bSkip)
	cmp	dword ptr [ebp-08h],0h;	bSkip
	je	@BLBL244

; 1052               if (!bLastWasNewLine)
	cmp	dword ptr [ebp-020h],0h;	bLastWasNewLine
	jne	@BLBL241

; 1054                 bLastWasNewLine = TRUE;
	mov	dword ptr [ebp-020h],01h;	bLastWasNewLine

; 1055                 if (--lRowCount <= 0)
	mov	eax,[ebp+0ch];	lRowCount
	dec	eax
	mov	[ebp+0ch],eax;	lRowCount
	cmp	dword ptr [ebp+0ch],0h;	lRowCount
	jg	@BLBL241

; 1056                   bWaitingPrintable = TRUE;
	mov	dword ptr [ebp-014h],01h;	bWaitingPrintable

; 1057                 }

; 1058               }
	jmp	@BLBL241
	align 010h
@BLBL244:

; 1060               if (--lRowCount <= 0)
	mov	eax,[ebp+0ch];	lRowCount
	dec	eax
	mov	[ebp+0ch],eax;	lRowCount
	cmp	dword ptr [ebp+0ch],0h;	lRowCount
	jg	@BLBL241

; 1061                 bWaitingPrintable = TRUE;
	mov	dword ptr [ebp-014h],01h;	bWaitingPrintable

; 1062             }

; 1063           }
	jmp	@BLBL241
	align 010h
@BLBL242:

; 1066           if (CharPrintable((BYTE *)&wChar,pstScreen))
	push	dword ptr [ebp+08h];	pstScreen
	lea	eax,[ebp-018h];	wChar
	push	eax
	call	CharPrintable
	add	esp,08h
	test	eax,eax
	je	@BLBL241

; 1068             if (bWaitingPrintable)
	cmp	dword ptr [ebp-014h],0h;	bWaitingPrintable
	jne	@BLBL253

; 1070             bLastWasNewLine = FALSE;
	mov	dword ptr [ebp-020h],0h;	bLastWasNewLine

; 1071             }

; 1072           }

; 1073         }
@BLBL241:

; 1041       for (lIndex = (lStartIndex + 1);lIndex < lScrollCount;lIndex++)
	mov	eax,[ebp-04h];	lIndex
	inc	eax
	mov	[ebp-04h],eax;	lIndex
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-04h],eax;	lIndex
	jl	@BLBL239

; 1074       }

; 1075     }
	jmp	@BLBL253
	align 010h
@BLBL222:

; 1078     lCharCount = (lRowCount * pstScreen->lCharWidth);
	mov	ecx,[ebp+08h];	pstScreen
	mov	eax,[ebp+0ch];	lRowCount
	imul	eax,[ecx+027h]
	mov	[ebp-010h],eax;	lCharCount

; 1079     if (lCharCount > 0)
	cmp	dword ptr [ebp-010h],0h;	lCharCount
	jle	@BLBL254

; 1081       for (lIndex = (lStartIndex + 1);lIndex < lScrollCount;lIndex++)
	mov	eax,[ebp-01ch];	lStartIndex
	inc	eax
	mov	[ebp-04h],eax;	lIndex
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-04h],eax;	lIndex
	jge	@BLBL253
	align 010h
@BLBL256:

; 1082         if ((pwScrollBuffer[lIndex] & 0xff00) == wDirection)
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-04h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	and	ax,0ff00h
	cmp	[ebp-016h],ax;	wDirection
	jne	@BLBL257

; 1083           if (lCharCount-- <= 0)
	cmp	dword ptr [ebp-010h],0h;	lCharCount
	jg	@BLBL258
	mov	eax,[ebp-010h];	lCharCount
	dec	eax
	mov	[ebp-010h],eax;	lCharCount

; 1084             break;
	jmp	@BLBL253
	align 010h
@BLBL258:
	mov	eax,[ebp-010h];	lCharCount
	dec	eax
	mov	[ebp-010h],eax;	lCharCount
@BLBL257:

; 1081       for (lIndex = (lStartIndex + 1);lIndex < lScrollCount;lIndex++)
	mov	eax,[ebp-04h];	lIndex
	inc	eax
	mov	[ebp-04h],eax;	lIndex
	mov	eax,dword ptr  lScrollCount
	cmp	[ebp-04h],eax;	lIndex
	jl	@BLBL256

; 1085       }
	jmp	@BLBL253
	align 010h
@BLBL254:

; 1088       for (lIndex = (lStartIndex - 1);lIndex >= 0;lIndex--)
	mov	eax,[ebp-01ch];	lStartIndex
	dec	eax
	mov	[ebp-04h],eax;	lIndex
	cmp	dword ptr [ebp-04h],0h;	lIndex
	jl	@BLBL253
	align 010h
@BLBL263:

; 1089         if ((pwScrollBuffer[lIndex] & 0xff00) == wDirection)
	mov	eax,dword ptr  pwScrollBuffer
	mov	ecx,[ebp-04h];	lIndex
	mov	ax,word ptr [eax+ecx*02h]
	and	ax,0ff00h
	cmp	[ebp-016h],ax;	wDirection
	jne	@BLBL264

; 1090           if (lCharCount++ >= 0)
	cmp	dword ptr [ebp-010h],0h;	lCharCount
	jl	@BLBL265
	mov	eax,[ebp-010h];	lCharCount
	inc	eax
	mov	[ebp-010h],eax;	lCharCount

; 1091             break;
	jmp	@BLBL253
	align 010h
@BLBL265:
	mov	eax,[ebp-010h];	lCharCount
	inc	eax
	mov	[ebp-010h],eax;	lCharCount
@BLBL264:

; 1088       for (lIndex = (lStartIndex - 1);lIndex >= 0;lIndex--)
	mov	eax,[ebp-04h];	lIndex
	dec	eax
	mov	[ebp-04h],eax;	lIndex
	cmp	dword ptr [ebp-04h],0h;	lIndex
	jge	@BLBL263

; 1092       }

; 1093     }
@BLBL253:

; 1094   return(lIndex);
	mov	eax,[ebp-04h];	lIndex
	mov	esp,ebp
	pop	ebp
	ret	
GetColScrollIndex	endp
CODE32	ends
end
