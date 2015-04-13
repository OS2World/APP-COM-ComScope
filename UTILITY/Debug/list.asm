	title	p:\utility\list.C
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
	extrn	_debug_malloc:proc
	extrn	_debug_calloc:proc
	extrn	_debug_free:proc
	extrn	memcpy:proc
	extrn	strcmp:proc
	extrn	stricmp:proc
	extrn	strncmp:proc
	extrn	strnicmp:proc
	extrn	_fullDump:dword
DATA32	segment
@STAT1	db "p:\utility\list.C",0h
	align 04h
@STAT2	db "p:\utility\list.C",0h
	align 04h
@STAT3	db "p:\utility\list.C",0h
	align 04h
@STAT4	db "p:\utility\list.C",0h
	align 04h
@STAT5	db "p:\utility\list.C",0h
	align 04h
@STAT6	db "p:\utility\list.C",0h
	align 04h
@STAT7	db "p:\utility\list.C",0h
	align 04h
@STAT8	db "p:\utility\list.C",0h
	align 04h
@STAT9	db "p:\utility\list.C",0h
	align 04h
@STATa	db "p:\utility\list.C",0h
	align 04h
@STATb	db "p:\utility\list.C",0h
	align 04h
@STATc	db "p:\utility\list.C",0h
	dd	_dllentry
DATA32	ends
CODE32	segment

; 5   {
	align 010h

	public InitializeList
InitializeList	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah
	sub	esp,0ch

; 8   if ((pList = malloc(sizeof(LINKLIST))) == NULL)
	mov	ecx,08h
	mov	edx,offset FLAT:@STAT1
	mov	eax,0ch
	call	_debug_malloc
	mov	[ebp-04h],eax;	pList
	cmp	dword ptr [ebp-04h],0h;	pList
	jne	@BLBL1

; 9     return(NULL);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL1:

; 10   pList->pHead = NULL;
	mov	eax,[ebp-04h];	pList
	mov	dword ptr [eax],0h

; 11   pList->pData = NULL;
	mov	eax,[ebp-04h];	pList
	mov	dword ptr [eax+08h],0h

; 12   pList->pTail = NULL;
	mov	eax,[ebp-04h];	pList
	mov	dword ptr [eax+04h],0h

; 13   return(pList);
	mov	eax,[ebp-04h];	pList
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
InitializeList	endp

; 17   {
	align 010h

	public AddListItem
AddListItem	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax
	sub	esp,0ch

; 18   LINKLIST *pNewElement = NULL;
	mov	dword ptr [ebp-04h],0h;	pNewElement

; 19   LINKLIST *pLastElement = NULL;
	mov	dword ptr [ebp-08h],0h;	pLastElement

; 20 
; 21   if ((pLastElement = pList) == NULL)
	mov	eax,[ebp+08h];	pList
	mov	[ebp-08h],eax;	pLastElement
	cmp	dword ptr [ebp-08h],0h;	pLastElement
	jne	@BLBL2

; 22     return(NULL);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL2:

; 23   if (pLastElement->pData != NULL)
	mov	eax,[ebp-08h];	pLastElement
	cmp	dword ptr [eax+08h],0h
	je	@BLBL3

; 24     {
; 25     while (pLastElement->pTail != NULL)
	mov	eax,[ebp-08h];	pLastElement
	cmp	dword ptr [eax+04h],0h
	je	@BLBL4
	align 010h
@BLBL5:

; 26       pLastElement = pLastElement->pTail;
	mov	eax,[ebp-08h];	pLastElement
	mov	eax,[eax+04h]
	mov	[ebp-08h],eax;	pLastElement

; 25     while (pLastElement->pTail != NULL)
	mov	eax,[ebp-08h];	pLastElement
	cmp	dword ptr [eax+04h],0h
	jne	@BLBL5
@BLBL4:

; 27     pNewElement = calloc(1,sizeof(LINKLIST));
	push	01bh
	mov	ecx,offset FLAT:@STAT2
	mov	edx,0ch
	mov	eax,01h
	sub	esp,0ch
	call	_debug_calloc
	add	esp,010h
	mov	[ebp-04h],eax;	pNewElement

; 28     if (pNewElement == NULL)
	cmp	dword ptr [ebp-04h],0h;	pNewElement
	jne	@BLBL7

; 29       return(NULL);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL7:

; 30     pNewElement->pHead = pLastElement;
	mov	eax,[ebp-04h];	pNewElement
	mov	ecx,[ebp-08h];	pLastElement
	mov	[eax],ecx

; 31     pNewElement->pTail = NULL;
	mov	eax,[ebp-04h];	pNewElement
	mov	dword ptr [eax+04h],0h

; 32     pLastElement->pTail = pNewElement;
	mov	eax,[ebp-08h];	pLastElement
	mov	ecx,[ebp-04h];	pNewElement
	mov	[eax+04h],ecx

; 33     }
	jmp	@BLBL8
	align 010h
@BLBL3:

; 35     pNewElement = pList;
	mov	eax,[ebp+08h];	pList
	mov	[ebp-04h],eax;	pNewElement
@BLBL8:

; 36   pNewElement->pData = malloc(iSize);
	mov	ecx,024h
	mov	edx,offset FLAT:@STAT3
	mov	eax,[ebp+010h];	iSize
	call	_debug_malloc
	mov	ecx,eax
	mov	eax,[ebp-04h];	pNewElement
	mov	[eax+08h],ecx

; 37   if (pNewElement->pData == NULL)
	mov	eax,[ebp-04h];	pNewElement
	cmp	dword ptr [eax+08h],0h
	jne	@BLBL9

; 39     if (pLastElement != pList)
	mov	eax,[ebp+08h];	pList
	cmp	[ebp-08h],eax;	pLastElement
	je	@BLBL10

; 40       free(pNewElement);
	mov	ecx,028h
	mov	edx,offset FLAT:@STAT4
	mov	eax,[ebp-04h];	pNewElement
	call	_debug_free
@BLBL10:

; 41     pLastElement->pTail = NULL;
	mov	eax,[ebp-08h];	pLastElement
	mov	dword ptr [eax+04h],0h

; 44     return(NULL);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL9:

; 47     memcpy(pNewElement->pData,pData,iSize);
	mov	ecx,[ebp+010h];	iSize
	mov	edx,[ebp+0ch];	pData
	mov	eax,[ebp-04h];	pNewElement
	mov	eax,[eax+08h]
	call	memcpy

; 48   return(pNewElement);
	mov	eax,[ebp-04h];	pNewElement
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
AddListItem	endp

; 52   {
	align 010h

	public GetNextListItem
GetNextListItem	proc
	push	ebp
	mov	ebp,esp

; 53   if (pList->pTail != NULL)
	mov	eax,[ebp+08h];	pList
	cmp	dword ptr [eax+04h],0h
	je	@BLBL12

; 54     return(pList->pTail);
	mov	eax,[ebp+08h];	pList
	mov	eax,[eax+04h]
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL12:

; 55   else
; 56     return(NULL);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
GetNextListItem	endp

; 60   {
	align 010h

	public DestroyList
DestroyList	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax
	sub	esp,0ch

; 61   LINKLIST *pFree = NULL;
	mov	dword ptr [ebp-04h],0h;	pFree

; 62   LINKLIST *pList;
; 63   int iIndex;
; 64 
; 65   if (*ppList == NULL)
	mov	eax,[ebp+08h];	ppList
	cmp	dword ptr [eax],0h
	jne	@BLBL14

; 66     return;
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL14:

; 67   pList = *ppList;
	mov	eax,[ebp+08h];	ppList
	mov	eax,[eax]
	mov	[ebp-08h],eax;	pList

; 68   for (iIndex = 0;iIndex < 400;iIndex++)
	mov	dword ptr [ebp-0ch],0h;	iIndex
	cmp	dword ptr [ebp-0ch],0190h;	iIndex
	jge	@BLBL15
	align 010h
@BLBL16:

; 69     {
; 70     if (pList->pTail == NULL)
	mov	eax,[ebp-08h];	pList
	cmp	dword ptr [eax+04h],0h
	je	@BLBL15

; 71       break;
; 72     pList = pList->pTail;
	mov	eax,[ebp-08h];	pList
	mov	eax,[eax+04h]
	mov	[ebp-08h],eax;	pList

; 73     }

; 68   for (iIndex = 0;iIndex < 400;iIndex++)
	mov	eax,[ebp-0ch];	iIndex
	inc	eax
	mov	[ebp-0ch],eax;	iIndex
	cmp	dword ptr [ebp-0ch],0190h;	iIndex
	jl	@BLBL16
@BLBL15:

; 74   while (pList->pHead != NULL)
	mov	eax,[ebp-08h];	pList
	cmp	dword ptr [eax],0h
	je	@BLBL19
	align 010h
@BLBL20:

; 76     pFree = pList;
	mov	eax,[ebp-08h];	pList
	mov	[ebp-04h],eax;	pFree

; 77     pList = pList->pHead;
	mov	eax,[ebp-08h];	pList
	mov	eax,[eax]
	mov	[ebp-08h],eax;	pList

; 78     if (pFree->pData != NULL)
	mov	eax,[ebp-04h];	pFree
	cmp	dword ptr [eax+08h],0h
	je	@BLBL21

; 79       free(pFree->pData);
	mov	ecx,04fh
	mov	edx,offset FLAT:@STAT5
	mov	eax,[ebp-04h];	pFree
	mov	eax,[eax+08h]
	call	_debug_free
@BLBL21:

; 80     free(pFree);
	mov	ecx,050h
	mov	edx,offset FLAT:@STAT6
	mov	eax,[ebp-04h];	pFree
	call	_debug_free

; 81     }

; 74   while (pList->pHead != NULL)
	mov	eax,[ebp-08h];	pList
	cmp	dword ptr [eax],0h
	jne	@BLBL20
@BLBL19:

; 82   if (pList->pData != NULL)
	mov	eax,[ebp-08h];	pList
	cmp	dword ptr [eax+08h],0h
	je	@BLBL23

; 83     free(pList->pData);
	mov	ecx,053h
	mov	edx,offset FLAT:@STAT7
	mov	eax,[ebp-08h];	pList
	mov	eax,[eax+08h]
	call	_debug_free
@BLBL23:

; 84   if (pList != NULL)
	cmp	dword ptr [ebp-08h],0h;	pList
	je	@BLBL24

; 85     free(pList);
	mov	ecx,055h
	mov	edx,offset FLAT:@STAT8
	mov	eax,[ebp-08h];	pList
	call	_debug_free
@BLBL24:

; 86   *ppList = NULL;
	mov	eax,[ebp+08h];	ppList
	mov	dword ptr [eax],0h

; 87   }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
DestroyList	endp

; 90   {
	align 010h

	public RemoveListItem
RemoveListItem	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax
	sub	esp,0ch

; 91   LINKLIST *pElement = NULL;
	mov	dword ptr [ebp-04h],0h;	pElement

; 92   LINKLIST *pFree = NULL;
	mov	dword ptr [ebp-08h],0h;	pFree

; 93 
; 94   if ((pElement = pList) == NULL)
	mov	eax,[ebp+08h];	pList
	mov	[ebp-04h],eax;	pElement
	cmp	dword ptr [ebp-04h],0h;	pElement
	jne	@BLBL25

; 95     return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL25:

; 96   if (pElement->pHead == NULL)
	mov	eax,[ebp-04h];	pElement
	cmp	dword ptr [eax],0h
	jne	@BLBL26

; 97     {
; 98     free(pElement->pData);
	mov	ecx,062h
	mov	edx,offset FLAT:@STAT9
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax+08h]
	call	_debug_free

; 99     pElement->pData = NULL;
	mov	eax,[ebp-04h];	pElement
	mov	dword ptr [eax+08h],0h

; 100     if (pElement->pTail != NULL)
	mov	eax,[ebp-04h];	pElement
	cmp	dword ptr [eax+04h],0h
	je	@BLBL30

; 101       {
; 102       pElement->pData = pElement->pTail->pData;
	mov	ecx,[ebp-04h];	pElement
	mov	ecx,[ecx+04h]
	mov	ecx,[ecx+08h]
	mov	eax,[ebp-04h];	pElement
	mov	[eax+08h],ecx

; 103       pFree = pElement->pTail;
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax+04h]
	mov	[ebp-08h],eax;	pFree

; 104       if (pElement->pTail->pTail != NULL)
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax+04h]
	cmp	dword ptr [eax+04h],0h
	je	@BLBL28

; 105         {
; 106         pElement->pTail->pTail->pHead = pElement;
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax+04h]
	mov	eax,[eax+04h]
	mov	ecx,[ebp-04h];	pElement
	mov	[eax],ecx

; 107         pElement->pTail = pElement->pTail->pTail;
	mov	ecx,[ebp-04h];	pElement
	mov	ecx,[ecx+04h]
	mov	ecx,[ecx+04h]
	mov	eax,[ebp-04h];	pElement
	mov	[eax+04h],ecx

; 108         }
	jmp	@BLBL29
	align 010h
@BLBL28:

; 109       else
; 110         pElement->pTail = NULL;
	mov	eax,[ebp-04h];	pElement
	mov	dword ptr [eax+04h],0h
@BLBL29:

; 111       free(pFree);
	mov	ecx,06fh
	mov	edx,offset FLAT:@STATa
	mov	eax,[ebp-08h];	pFree
	call	_debug_free

; 112       }

; 113     }
	jmp	@BLBL30
	align 010h
@BLBL26:

; 114   else
; 115     {
; 116     if (pElement->pTail == NULL)
	mov	eax,[ebp-04h];	pElement
	cmp	dword ptr [eax+04h],0h
	jne	@BLBL31

; 117       pElement->pHead->pTail = NULL;
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax]
	mov	dword ptr [eax+04h],0h
	jmp	@BLBL32
	align 010h
@BLBL31:

; 118     else
; 119       {
; 120       pElement->pHead->pTail = pElement->pTail;
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax]
	mov	ecx,[ebp-04h];	pElement
	mov	ecx,[ecx+04h]
	mov	[eax+04h],ecx

; 121       pElement->pTail->pHead = pElement->pHead;
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax+04h]
	mov	ecx,[ebp-04h];	pElement
	mov	ecx,[ecx]
	mov	[eax],ecx

; 122       }
@BLBL32:

; 123     free(pElement->pData);
	mov	ecx,07bh
	mov	edx,offset FLAT:@STATb
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax+08h]
	call	_debug_free

; 124     free(pElement);
	mov	ecx,07ch
	mov	edx,offset FLAT:@STATc
	mov	eax,[ebp-04h];	pElement
	call	_debug_free

; 125     }
@BLBL30:

; 126   return(TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
RemoveListItem	endp

; 130   {
	align 010h

	public FindListByteItem
FindListByteItem	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 131   LINKLIST *pElement = NULL;
	mov	dword ptr [ebp-04h],0h;	pElement

; 132   BYTE *pByte;
; 133 
; 134   if (pList == NULL)
	cmp	dword ptr [ebp+08h],0h;	pList
	jne	@BLBL33

; 135     return(NULL);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL33:

; 136   if (pList->pData == NULL)
	mov	eax,[ebp+08h];	pList
	cmp	dword ptr [eax+08h],0h
	jne	@BLBL34

; 137     return(NULL);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL34:

; 138   pElement = pList;
	mov	eax,[ebp+08h];	pList
	mov	[ebp-04h],eax;	pElement

; 139   do
	align 010h
@BLBL35:

; 140     {
; 141     pByte = (BYTE *)pElement->pData;
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax+08h]
	mov	[ebp-08h],eax;	pByte

; 142     if (*pByte == byByte)
	mov	eax,[ebp-08h];	pByte
	mov	cl,[ebp+0ch];	byByte
	cmp	[eax],cl
	jne	@BLBL36

; 143       return(pElement);
	mov	eax,[ebp-04h];	pElement
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL36:

; 144     } while ((pElement = pElement->pTail) != NULL);
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax+04h]
	mov	[ebp-04h],eax;	pElement
	cmp	dword ptr [ebp-04h],0h;	pElement
	jne	@BLBL35

; 145   return(NULL);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
FindListByteItem	endp

; 149   {
	align 010h

	public FindListLongItem
FindListLongItem	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 150   LINKLIST *pElement = NULL;
	mov	dword ptr [ebp-04h],0h;	pElement

; 151   ULONG *pulData;
; 152 
; 153   if (pList == NULL)
	cmp	dword ptr [ebp+08h],0h;	pList
	jne	@BLBL38

; 154     return(NULL);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL38:

; 155   if (pList->pData == NULL)
	mov	eax,[ebp+08h];	pList
	cmp	dword ptr [eax+08h],0h
	jne	@BLBL39

; 156     return(NULL);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL39:

; 157   pElement = pList;
	mov	eax,[ebp+08h];	pList
	mov	[ebp-04h],eax;	pElement

; 158   do
	align 010h
@BLBL40:

; 159     {
; 160     pulData = (ULONG *)pElement->pData;
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax+08h]
	mov	[ebp-08h],eax;	pulData

; 161     if (*pulData == ulData)
	mov	eax,[ebp-08h];	pulData
	mov	ecx,[ebp+0ch];	ulData
	cmp	[eax],ecx
	jne	@BLBL41

; 162       return(pElement);
	mov	eax,[ebp-04h];	pElement
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL41:

; 163     } while ((pElement = pElement->pTail) != NULL);
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax+04h]
	mov	[ebp-04h],eax;	pElement
	cmp	dword ptr [ebp-04h],0h;	pElement
	jne	@BLBL40

; 164   return(NULL);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
FindListLongItem	endp

; 168   {
	align 010h

	public FindListWordItem
FindListWordItem	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 169   LINKLIST *pElement = NULL;
	mov	dword ptr [ebp-04h],0h;	pElement

; 170   USHORT *pusData;
; 171 
; 172   if (pList == NULL)
	cmp	dword ptr [ebp+08h],0h;	pList
	jne	@BLBL43

; 173     return(NULL);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL43:

; 174   if (pList->pData == NULL)
	mov	eax,[ebp+08h];	pList
	cmp	dword ptr [eax+08h],0h
	jne	@BLBL44

; 175     return(NULL);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL44:

; 176   pElement = pList;
	mov	eax,[ebp+08h];	pList
	mov	[ebp-04h],eax;	pElement

; 177   do
	align 010h
@BLBL45:

; 178     {
; 179     pusData = (USHORT *)pElement->pData;
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax+08h]
	mov	[ebp-08h],eax;	pusData

; 180     if (*pusData == usData)
	mov	eax,[ebp-08h];	pusData
	mov	cx,[ebp+0ch];	usData
	cmp	[eax],cx
	jne	@BLBL46

; 181       return(pElement);
	mov	eax,[ebp-04h];	pElement
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL46:

; 182     } while ((pElement = pElement->pTail) != NULL);
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax+04h]
	mov	[ebp-04h],eax;	pElement
	cmp	dword ptr [ebp-04h],0h;	pElement
	jne	@BLBL45

; 183   return(NULL);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
FindListWordItem	endp

; 187   {
	align 010h

	public FindListStringItem
FindListStringItem	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax
	sub	esp,0ch

; 188   LINKLIST *pElement = NULL;
	mov	dword ptr [ebp-04h],0h;	pElement

; 189   char *pString;
; 190 
; 191   if (pList == NULL)
	cmp	dword ptr [ebp+08h],0h;	pList
	jne	@BLBL48

; 192     return(NULL);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL48:

; 193   if (pList->pData == NULL)
	mov	eax,[ebp+08h];	pList
	cmp	dword ptr [eax+08h],0h
	jne	@BLBL49

; 194     return(NULL);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL49:

; 195   pElement = pList;
	mov	eax,[ebp+08h];	pList
	mov	[ebp-04h],eax;	pElement

; 196   do
	align 010h
@BLBL50:

; 197     {
; 198     pString = (char *)pElement->pData;
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax+08h]
	mov	[ebp-08h],eax;	pString

; 199     if (iSearchLimit == 0)
	cmp	dword ptr [ebp+010h],0h;	iSearchLimit
	jne	@BLBL51

; 200       {
; 201       if (!bNoCase)
	cmp	dword ptr [ebp+014h],0h;	bNoCase
	jne	@BLBL52

; 202         {
; 203         if ((strcmp(pString,szString)) == 0)
	mov	edx,[ebp+0ch];	szString
	mov	eax,[ebp-08h];	pString
	call	strcmp
	test	eax,eax
	jne	@BLBL56

; 204           return(pElement);
	mov	eax,[ebp-04h];	pElement
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL52:

; 205         }
; 206       else
; 207         if ((stricmp(pString,szString)) == 0)
	mov	edx,[ebp+0ch];	szString
	mov	eax,[ebp-08h];	pString
	call	stricmp
	test	eax,eax
	jne	@BLBL56

; 208           return(pElement);
	mov	eax,[ebp-04h];	pElement
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL51:

; 209       }
; 210     else
; 211       {
; 212       if (!bNoCase)
	cmp	dword ptr [ebp+014h],0h;	bNoCase
	jne	@BLBL57

; 213         {
; 214         if ((strncmp(pString,szString,iSearchLimit)) == 0)
	mov	ecx,[ebp+010h];	iSearchLimit
	mov	edx,[ebp+0ch];	szString
	mov	eax,[ebp-08h];	pString
	call	strncmp
	test	eax,eax
	jne	@BLBL56

; 215           return(pElement);
	mov	eax,[ebp-04h];	pElement
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL57:

; 216         }
; 217       else
; 218         if ((strnicmp(pString,szString,iSearchLimit)) == 0)
	mov	ecx,[ebp+010h];	iSearchLimit
	mov	edx,[ebp+0ch];	szString
	mov	eax,[ebp-08h];	pString
	call	strnicmp
	test	eax,eax
	jne	@BLBL56

; 219           return(pElement);
	mov	eax,[ebp-04h];	pElement
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL56:

; 220       }
; 221     } while ((pElement = pElement->pTail) != NULL);
	mov	eax,[ebp-04h];	pElement
	mov	eax,[eax+04h]
	mov	[ebp-04h],eax;	pElement
	cmp	dword ptr [ebp-04h],0h;	pElement
	jne	@BLBL50

; 222   return(NULL);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
FindListStringItem	endp
CODE32	ends
end
