;	Static Name Aliases
;
	TITLE   RESPONSE.C
	.286p
_TEXT	SEGMENT  WORD PUBLIC 'CODE'
_TEXT	ENDS
_DATA	SEGMENT  WORD PUBLIC 'DATA'
_DATA	ENDS
DGROUP  GROUP _DATA
	ASSUME DS: DGROUP
	ASSUME  SS: NOTHING
EXTRN	DOSOPEN:FAR
EXTRN	DOSCLOSE:FAR
EXTRN	DOSREAD:FAR
EXTRN	_StringLength:NEAR
EXTRN	VIOWRTTTY:FAR
EXTRN	_response_file_error_return:NEAR
EXTRN	_wEndOfData:WORD
EXTRN	_wCOMstart:WORD
EXTRN	_wCOMlast:WORD
EXTRN	_iStartDevice:WORD
EXTRN	_iEndDevice:WORD
EXTRN	_bWaitForCR:WORD
EXTRN	_wOEMjumpExit:WORD
EXTRN	_pDeviceParms:WORD
EXTRN	_DeviceParms:BYTE
EXTRN	_pStart:WORD
EXTRN	_pPrevious:WORD
EXTRN	_wDeviceStrategy:WORD
EXTRN	_pDeviceStrategy:WORD
EXTRN	_stDummyHeader:BYTE
EXTRN	_wLoadCount:WORD
EXTRN	_wLoadNumber:WORD
EXTRN	_wLoadFlags:WORD
EXTRN	_astComDCB:BYTE
EXTRN	_szDefaultPath:BYTE
EXTRN	_abyString:BYTE
EXTRN	_chFailedOpen:BYTE
EXTRN	_chFailedRead:BYTE
EXTRN	_chProcessing:BYTE
EXTRN	_bContinueParse:WORD
EXTRN	_bVerbose:WORD
EXTRN	_abyPath:BYTE
EXTRN	_abyFileBuffer:BYTE
EXTRN	_wDelayCount:WORD
EXTRN	_iDataIndex:WORD
EXTRN	_abyNumber:BYTE
EXTRN	_usDosIOdelayCount:WORD
EXTRN	_wIntIDregister:WORD
EXTRN	_wDCBcount:WORD
EXTRN	_abyCOMnumbers:BYTE
_TEXT      SEGMENT
	ASSUME	CS: _TEXT
; Line 1
; Line 16
; Line 21
; Line 25
; Line 33
; Line 34
; Line 35
; Line 30
; Line 38
; Line 2235
; Line 39
; Line 40
; Line 18
; Line 19
; Line 73
	PUBLIC	_ErrorExit
_ErrorExit	PROC NEAR
	enter	0,0
	push	di
	push	si
; Line 74
	call	_response_file_error_return
; Line 75
$EX849:
	pop	si
	pop	di
	leave	
	ret	

_ErrorExit	ENDP
; Line 79
	PUBLIC	_ToLowerCase
_ToLowerCase	PROC NEAR
	enter	0,0
	push	di
	push	si
;	byByte = 4
; Line 80
	cmp	BYTE PTR [bp+4],65	;byByte
	jb	$JCC23
	jmp	$I852
$JCC23:
; Line 81
	mov	al,BYTE PTR [bp+4]	;byByte
	jmp	$EX851
; Line 82
$I852:
	cmp	BYTE PTR [bp+4],90	;byByte
	ja	$JCC38
	jmp	$I853
$JCC38:
; Line 83
	mov	al,BYTE PTR [bp+4]	;byByte
	jmp	$EX851
; Line 84
$I853:
	mov	al,BYTE PTR [bp+4]	;byByte
	or	al,32
	jmp	$EX851
; Line 85
$EX851:
	pop	si
	pop	di
	leave	
	ret	

_ToLowerCase	ENDP
; Line 88
	PUBLIC	_SkipWords
_SkipWords	PROC NEAR
	enter	0,0
	push	di
	push	si
;	byByte = 4
; Line 89
$FC857:
; Line 90
; Line 91
$FC860:
	mov	al,BYTE PTR [bp+4]	;byByte
	push	ax
	call	_IsAlphaNumeric
	add	sp,2
	cmp	ax,0
	jne	$JCC80
	jmp	$FB861
$JCC80:
	jmp	$FC860
$FB861:
; Line 92
	cmp	BYTE PTR [bp+4],95	;byByte
	jne	$JCC92
	jmp	$I862
$JCC92:
	cmp	BYTE PTR [bp+4],32	;byByte
	jne	$JCC101
	jmp	$I862
$JCC101:
	cmp	BYTE PTR [bp+4],9	;byByte
	jne	$JCC110
	jmp	$I862
$JCC110:
; Line 93
	jmp	$EX855
; Line 94
$I862:
	jmp	$FC857
$FB858:
; Line 95
$EX855:
	pop	si
	pop	di
	leave	
	ret	

_SkipWords	ENDP
; Line 98
	PUBLIC	_IsAlphaNumeric
_IsAlphaNumeric	PROC NEAR
	enter	0,0
	push	di
	push	si
;	byByte = 4
; Line 99
	cmp	BYTE PTR [bp+4],97	;byByte
	jae	$JCC135
	jmp	$I865
$JCC135:
	cmp	BYTE PTR [bp+4],122	;byByte
	jbe	$JCC144
	jmp	$I865
$JCC144:
; Line 100
	mov	ax,1
	jmp	$EX864
; Line 101
$I865:
	cmp	BYTE PTR [bp+4],48	;byByte
	jae	$JCC159
	jmp	$I866
$JCC159:
	cmp	BYTE PTR [bp+4],57	;byByte
	jbe	$JCC168
	jmp	$I866
$JCC168:
; Line 102
	mov	ax,1
	jmp	$EX864
; Line 103
$I866:
	cmp	BYTE PTR [bp+4],95	;byByte
	je	$JCC183
	jmp	$I867
$JCC183:
; Line 104
	mov	ax,1
	jmp	$EX864
; Line 105
$I867:
	mov	ax,0
	jmp	$EX864
; Line 106
$EX864:
	pop	si
	pop	di
	leave	
	ret	

_IsAlphaNumeric	ENDP
; Line 109
	PUBLIC	_IsXdigit
_IsXdigit	PROC NEAR
	enter	0,0
	push	di
	push	si
;	byByte = 4
; Line 110
	cmp	BYTE PTR [bp+4],48	;byByte
	jae	$JCC214
	jmp	$I870
$JCC214:
	cmp	BYTE PTR [bp+4],57	;byByte
	jbe	$JCC223
	jmp	$I870
$JCC223:
; Line 111
	mov	ax,1
	jmp	$EX869
; Line 112
$I870:
	cmp	BYTE PTR [bp+4],97	;byByte
	jae	$JCC238
	jmp	$I871
$JCC238:
	cmp	BYTE PTR [bp+4],102	;byByte
	jbe	$JCC247
	jmp	$I871
$JCC247:
; Line 113
	mov	ax,1
	jmp	$EX869
; Line 114
$I871:
	mov	ax,0
	jmp	$EX869
; Line 115
$EX869:
	pop	si
	pop	di
	leave	
	ret	

_IsXdigit	ENDP
; Line 118
	PUBLIC	_IsDigit
_IsDigit	PROC NEAR
	enter	0,0
	push	di
	push	si
;	byByte = 4
; Line 119
	cmp	BYTE PTR [bp+4],48	;byByte
	jae	$JCC278
	jmp	$I874
$JCC278:
	cmp	BYTE PTR [bp+4],57	;byByte
	jbe	$JCC287
	jmp	$I874
$JCC287:
; Line 120
	mov	ax,1
	jmp	$EX873
; Line 121
$I874:
	mov	ax,0
	jmp	$EX873
; Line 122
$EX873:
	pop	si
	pop	di
	leave	
	ret	

_IsDigit	ENDP
; Line 125
	PUBLIC	_ProcessResponseFile
_ProcessResponseFile	PROC NEAR
	enter	20,0
	push	di
	push	si
;	wStatus = -14
;	wCount = -4
;	Error = -12
;	hFile = -8
;	wPathIndex = -18
;	wNameIndex = -2
;	bUseDefaultPath = -6
;	byChar = -10
;	pbyName = -16
;	abyFileSpec = 4
; Line 126
	mov	WORD PTR [bp-14],0	;wStatus
; Line 132
	mov	WORD PTR [bp-6],1	;bUseDefaultPath
; Line 136
	mov	WORD PTR [bp-18],0	;wPathIndex
; Line 137
	mov	bx,WORD PTR [bp-18]	;wPathIndex
	mov	al,BYTE PTR _abyPath[bx]
	mov	BYTE PTR [bp-10],al	;byChar
; Line 138
$FC887:
	cmp	BYTE PTR [bp-10],32	;byChar
	jne	$JCC343
	jmp	$FB888
$JCC343:
	cmp	BYTE PTR [bp-10],0	;byChar
	jne	$JCC352
	jmp	$FB888
$JCC352:
; Line 139
; Line 140
	mov	al,BYTE PTR [bp-10]	;byChar
	mov	bx,WORD PTR [bp-18]	;wPathIndex
	mov	BYTE PTR _szDefaultPath[bx],al
	inc	WORD PTR [bp-18]	;wPathIndex
; Line 141
	mov	bx,WORD PTR [bp-18]	;wPathIndex
	mov	al,BYTE PTR _abyPath[bx]
	mov	BYTE PTR [bp-10],al	;byChar
; Line 142
	jmp	$FC887
$FB888:
; Line 143
	mov	bx,WORD PTR [bp-18]	;wPathIndex
	mov	BYTE PTR _szDefaultPath[bx],0
; Line 144
	mov	WORD PTR _bContinueParse,0
; Line 148
	mov	WORD PTR [bp-18],0	;wPathIndex
; Line 151
$FC890:
	les	bx,DWORD PTR [bp+4]	;abyFileSpec
	mov	si,WORD PTR [bp-18]	;wPathIndex
	cmp	BYTE PTR es:[bx][si],0
	jne	$JCC412
	jmp	$FB891
$JCC412:
	les	bx,DWORD PTR [bp+4]	;abyFileSpec
	mov	si,WORD PTR [bp-18]	;wPathIndex
	cmp	BYTE PTR es:[bx][si],32
	jne	$JCC427
	jmp	$FB891
$JCC427:
	les	bx,DWORD PTR [bp+4]	;abyFileSpec
	mov	si,WORD PTR [bp-18]	;wPathIndex
	cmp	BYTE PTR es:[bx][si],47
	jne	$JCC442
	jmp	$FB891
$JCC442:
; Line 152
; Line 153
	les	bx,DWORD PTR [bp+4]	;abyFileSpec
	mov	si,WORD PTR [bp-18]	;wPathIndex
	cmp	BYTE PTR es:[bx][si],92
	jne	$JCC457
	jmp	$I893
$JCC457:
	les	bx,DWORD PTR [bp+4]	;abyFileSpec
	mov	si,WORD PTR [bp-18]	;wPathIndex
	cmp	BYTE PTR es:[bx][si],58
	je	$JCC472
	jmp	$I892
$JCC472:
$I893:
; Line 154
; Line 155
	mov	WORD PTR [bp-6],0	;bUseDefaultPath
; Line 156
	jmp	$FB891
; Line 157
; Line 158
$I892:
	inc	WORD PTR [bp-18]	;wPathIndex
; Line 159
	jmp	$FC890
$FB891:
; Line 160
	cmp	WORD PTR [bp-18],0	;wPathIndex
	je	$JCC495
	jmp	$I894
$JCC495:
; Line 161
	jmp	$EX876
; Line 162
$I894:
	mov	WORD PTR [bp-18],0	;wPathIndex
; Line 163
	mov	WORD PTR [bp-2],0	;wNameIndex
; Line 168
	cmp	WORD PTR [bp-6],0	;bUseDefaultPath
	jne	$JCC517
	jmp	$I895
$JCC517:
; Line 169
; Line 170
$FC897:
	mov	bx,WORD PTR [bp-18]	;wPathIndex
	inc	WORD PTR [bp-18]	;wPathIndex
	cmp	BYTE PTR _szDefaultPath[bx],0
	jne	$JCC533
	jmp	$FB898
$JCC533:
	jmp	$FC897
$FB898:
; Line 171
$FC900:
	mov	bx,WORD PTR [bp-18]	;wPathIndex
	cmp	BYTE PTR _szDefaultPath[bx],92
	jne	$JCC549
	jmp	$FB901
$JCC549:
	mov	bx,WORD PTR [bp-18]	;wPathIndex
	cmp	BYTE PTR _szDefaultPath[bx],58
	jne	$JCC562
	jmp	$FB901
$JCC562:
; Line 172
	dec	WORD PTR [bp-18]	;wPathIndex
	jmp	$FC900
$FB901:
; Line 173
	inc	WORD PTR [bp-18]	;wPathIndex
; Line 174
; Line 175
$I895:
; Line 177
$FC903:
	les	bx,DWORD PTR [bp+4]	;abyFileSpec
	mov	si,WORD PTR [bp-2]	;wNameIndex
	cmp	BYTE PTR es:[bx][si],0
	jne	$JCC586
	jmp	$FB904
$JCC586:
	les	bx,DWORD PTR [bp+4]	;abyFileSpec
	mov	si,WORD PTR [bp-2]	;wNameIndex
	cmp	BYTE PTR es:[bx][si],32
	jne	$JCC601
	jmp	$FB904
$JCC601:
	les	bx,DWORD PTR [bp+4]	;abyFileSpec
	mov	si,WORD PTR [bp-2]	;wNameIndex
	cmp	BYTE PTR es:[bx][si],47
	jne	$JCC616
	jmp	$FB904
$JCC616:
; Line 178
	les	bx,DWORD PTR [bp+4]	;abyFileSpec
	mov	si,WORD PTR [bp-2]	;wNameIndex
	mov	al,BYTE PTR es:[bx][si]
	mov	bx,WORD PTR [bp-18]	;wPathIndex
	mov	BYTE PTR _szDefaultPath[bx],al
	inc	WORD PTR [bp-2]	;wNameIndex
	inc	WORD PTR [bp-18]	;wPathIndex
	jmp	$FC903
$FB904:
; Line 179
	mov	bx,WORD PTR [bp-18]	;wPathIndex
	mov	BYTE PTR _szDefaultPath[bx],0
; Line 180
	les	bx,DWORD PTR [bp+4]	;abyFileSpec
	mov	si,WORD PTR [bp-2]	;wNameIndex
	cmp	BYTE PTR es:[bx][si],0
	jne	$JCC664
	jmp	$I905
$JCC664:
; Line 181
	mov	WORD PTR _bContinueParse,1
; Line 182
$I905:
	push	ds
	push	OFFSET _szDefaultPath
	lea	ax,WORD PTR [bp-8]	;hFile
	push	ss
	push	ax
	lea	ax,WORD PTR [bp-14]	;wStatus
	push	ss
	push	ax
	push	0
	push	0
	push	0
	push	1
	push	16784
	push	0
	push	0
	call	FAR PTR DOSOPEN
	mov	WORD PTR [bp-12],ax	;Error
	cmp	ax,0
	jne	$JCC715
	jmp	$I906
$JCC715:
; Line 183
; Line 184
	push	ds
	push	OFFSET _chFailedOpen
	push	OFFSET _chFailedOpen
	call	_StringLength
	add	sp,2
	push	ax
	push	0
	call	FAR PTR VIOWRTTTY
; Line 185
	jmp	$EX876
; Line 186
; Line 187
$I906:
	push	WORD PTR [bp-8]	;hFile
	push	ds
	push	OFFSET _abyFileBuffer
	push	-32768
	lea	ax,WORD PTR [bp-4]	;wCount
	push	ss
	push	ax
	call	FAR PTR DOSREAD
	mov	WORD PTR [bp-12],ax	;Error
	cmp	ax,0
	jne	$JCC770
	jmp	$I907
$JCC770:
; Line 188
; Line 189
	push	ds
	push	OFFSET _chFailedRead
	push	OFFSET _chFailedRead
	call	_StringLength
	add	sp,2
	push	ax
	push	0
	call	FAR PTR VIOWRTTTY
; Line 190
	jmp	$EX876
; Line 191
; Line 192
$I907:
	push	WORD PTR [bp-8]	;hFile
	call	FAR PTR DOSCLOSE
; Line 193
	mov	bx,WORD PTR [bp-4]	;wCount
	mov	BYTE PTR _abyFileBuffer[bx],0
; Line 194
	call	_ParseResponseData
; Line 195
	mov	ax,WORD PTR _wCOMlast
	sub	ax,WORD PTR _wCOMstart
	inc	ax
	mov	WORD PTR _wDCBcount,ax
; Line 196
	cmp	WORD PTR _wDCBcount,8
	ja	$JCC834
	jmp	$I908
$JCC834:
; Line 197
	mov	WORD PTR _wDCBcount,8
; Line 198
$I908:
	imul	ax,WORD PTR _wDCBcount,146
	add	ax,OFFSET _DeviceParms
	mov	WORD PTR _wEndOfData,ax
; Line 199
	mov	WORD PTR _pDeviceParms,OFFSET _DeviceParms
; Line 200
	mov	WORD PTR _wDeviceStrategy,OFFSET _pDeviceStrategy
; Line 201
	mov	WORD PTR _pPrevious,0
; Line 202
	mov	WORD PTR [bp-2],0	;wNameIndex
	jmp	$F909
$FC910:
	inc	WORD PTR [bp-2]	;wNameIndex
$F909:
	mov	ax,WORD PTR _wDCBcount
	cmp	WORD PTR [bp-2],ax	;wNameIndex
	jb	$JCC892
	jmp	$FB911
$JCC892:
; Line 203
; Line 208
	cmp	WORD PTR _pStart,0
	je	$JCC902
	jmp	$I912
$JCC902:
; Line 209
	mov	ax,WORD PTR _pDeviceParms
	add	ax,120
	mov	WORD PTR _pStart,ax
; Line 213
$I912:
	mov	al,BYTE PTR _wLoadFlags
	and	ax,15
	imul	bx,WORD PTR [bp-2],42	;wNameIndex
	or	WORD PTR _astComDCB[bx],ax
; Line 217
	mov	ax,WORD PTR _wDeviceStrategy
	mov	bx,WORD PTR _pDeviceParms
	mov	WORD PTR [bx+126],ax
; Line 218
	mov	al,BYTE PTR _wCOMstart
	mov	bx,WORD PTR [bp-2]	;wNameIndex
	mov	BYTE PTR _abyCOMnumbers[bx],al
; Line 219
	mov	ax,WORD PTR _pDeviceParms
	add	ax,130
	mov	WORD PTR [bp-16],ax	;pbyName
; Line 223
	cmp	WORD PTR _wCOMstart,9
	ja	$JCC964
	jmp	$I913
$JCC964:
; Line 224
; Line 225
	mov	ax,WORD PTR _wCOMstart
	mov	cx,10
	sub	dx,dx
	div	cx
	add	al,48
	mov	bx,WORD PTR [bp-16]	;pbyName
	mov	BYTE PTR [bx+3],al
; Line 226
	mov	ax,WORD PTR _wCOMstart
	sub	dx,dx
	div	cx
	add	dl,48
	mov	bx,WORD PTR [bp-16]	;pbyName
	mov	BYTE PTR [bx+4],dl
; Line 227
; Line 228
	jmp	$I914
$I913:
; Line 229
; Line 230
	mov	al,BYTE PTR _wCOMstart
	and	al,15
	add	al,48
	mov	bx,WORD PTR [bp-16]	;pbyName
	mov	BYTE PTR [bx+3],al
; Line 231
	mov	bx,WORD PTR [bp-16]	;pbyName
	mov	BYTE PTR [bx+4],32
; Line 232
$I914:
; Line 233
	mov	bx,WORD PTR [bp-16]	;pbyName
	mov	BYTE PTR [bx+5],32
; Line 234
	mov	bx,WORD PTR [bp-16]	;pbyName
	mov	BYTE PTR [bx+6],32
; Line 235
	mov	bx,WORD PTR [bp-16]	;pbyName
	mov	BYTE PTR [bx+7],32
; Line 236
	inc	WORD PTR _wCOMstart
; Line 237
	cmp	WORD PTR _pPrevious,0
	jne	$JCC1056
	jmp	$I915
$JCC1056:
; Line 238
	mov	ax,WORD PTR _pDeviceParms
	add	ax,120
	mov	bx,WORD PTR _pPrevious
	mov	WORD PTR [bx],ax
; Line 239
$I915:
	mov	ax,WORD PTR _pDeviceParms
	add	ax,120
	mov	WORD PTR _pPrevious,ax
; Line 240
	mov	bx,WORD PTR _pPrevious
	mov	WORD PTR [bx],-1
; Line 241
	add	WORD PTR _pDeviceParms,146
; Line 242
	add	WORD PTR _wDeviceStrategy,6
; Line 243
	inc	WORD PTR _wLoadCount
; Line 244
	jmp	$FC910
$FB911:
; Line 245
	cmp	WORD PTR _wLoadCount,0
	ja	$JCC1113
	jmp	$I916
$JCC1113:
; Line 246
; Line 247
	sub	WORD PTR _pDeviceParms,146
; Line 248
	mov	ax,WORD PTR _pStart
	mov	WORD PTR _stDummyHeader,ax
; Line 250
	mov	bx,WORD PTR _pDeviceParms
	mov	WORD PTR [bx+122],-1
; Line 251
	mov	WORD PTR _wLoadNumber,1
; Line 252
; Line 253
	jmp	$I917
$I916:
; Line 254
; Line 256
	mov	WORD PTR _wLoadNumber,-32768
; Line 257
$I917:
; Line 258
$EX876:
	pop	si
	pop	di
	leave	
	ret	

_ProcessResponseFile	ENDP
; Line 261
	PUBLIC	_BypassComment
_BypassComment	PROC NEAR
	enter	2,0
	push	di
	push	si
; Line 262
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx+1],42
	je	$JCC1173
	jmp	$I919
$JCC1173:
; Line 263
; Line 264
	add	WORD PTR _iDataIndex,2
; Line 265
$FC921:
; Line 266
; Line 267
$FC924:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],42
	jne	$JCC1192
	jmp	$FB925
$JCC1192:
; Line 268
	mov	bx,WORD PTR _iDataIndex
	inc	WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],0
	je	$JCC1210
	jmp	$I926
$JCC1210:
; Line 269
	call	_ErrorExit
; Line 270
$I926:
	jmp	$FC924
$FB925:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx+1],47
	je	$JCC1230
	jmp	$I927
$JCC1230:
; Line 271
; Line 272
	add	WORD PTR _iDataIndex,2
; Line 273
	mov	ax,1
	jmp	$EX918
; Line 274
; Line 275
	jmp	$I928
$I927:
; Line 276
	inc	WORD PTR _iDataIndex
$I928:
; Line 277
	jmp	$FC921
$FB922:
; Line 278
; Line 279
$I919:
	mov	ax,0
	jmp	$EX918
; Line 280
$EX918:
	pop	si
	pop	di
	leave	
	ret	

_BypassComment	ENDP
; Line 286
	PUBLIC	_FindToken
_FindToken	PROC NEAR
	enter	0,0
	push	di
	push	si
;	bSkipEOL = 6
;	byToken = 4
; Line 287
$FC933:
	mov	al,BYTE PTR [bp+4]	;byToken
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],al
	jne	$JCC1283
	jmp	$FB934
$JCC1283:
; Line 288
; Line 289
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],0
	je	$JCC1297
	jmp	$I935
$JCC1297:
; Line 290
	call	_ErrorExit
; Line 291
$I935:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],10
	je	$JCC1314
	jmp	$I936
$JCC1314:
	cmp	WORD PTR [bp+6],0	;bSkipEOL
	je	$JCC1323
	jmp	$I936
$JCC1323:
; Line 292
	mov	ax,0
	jmp	$EX931
; Line 293
$I936:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],47
	je	$JCC1343
	jmp	$I937
$JCC1343:
; Line 294
; Line 295
	call	_BypassComment
	cmp	ax,0
	je	$JCC1354
	jmp	$I938
$JCC1354:
; Line 296
	inc	WORD PTR _iDataIndex
; Line 297
$I938:
; Line 298
	jmp	$I939
$I937:
; Line 299
	inc	WORD PTR _iDataIndex
$I939:
; Line 300
	jmp	$FC933
$FB934:
; Line 301
	inc	WORD PTR _iDataIndex
; Line 302
	mov	ax,1
	jmp	$EX931
; Line 303
$EX931:
	pop	si
	pop	di
	leave	
	ret	

_FindToken	ENDP
; Line 310
	PUBLIC	_FindDelimiter
_FindDelimiter	PROC NEAR
	enter	2,0
	push	di
	push	si
; Line 311
$FC942:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],0
	jne	$JCC1402
	jmp	$FB943
$JCC1402:
; Line 312
; Line 321
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],13
	jne	$JCC1416
	jmp	$I945
$JCC1416:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],10
	jne	$JCC1430
	jmp	$I945
$JCC1430:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],9
	jne	$JCC1444
	jmp	$I945
$JCC1444:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],40
	jne	$JCC1458
	jmp	$I945
$JCC1458:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],123
	jne	$JCC1472
	jmp	$I945
$JCC1472:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],41
	jne	$JCC1486
	jmp	$I945
$JCC1486:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],125
	jne	$JCC1500
	jmp	$I945
$JCC1500:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],45
	jne	$JCC1514
	jmp	$I945
$JCC1514:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],44
	je	$JCC1528
	jmp	$I944
$JCC1528:
$I945:
; Line 322
	mov	bx,WORD PTR _iDataIndex
	inc	WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	jmp	$EX940
; Line 323
$I944:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],47
	je	$JCC1557
	jmp	$I946
$JCC1557:
; Line 324
	call	_BypassComment
	cmp	ax,0
	je	$JCC1568
	jmp	$I947
$JCC1568:
; Line 325
	mov	bx,WORD PTR _iDataIndex
	inc	WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	jmp	$EX940
; Line 326
$I947:
$I946:
	inc	WORD PTR _iDataIndex
; Line 327
	jmp	$FC942
$FB943:
; Line 328
	call	_ErrorExit
; Line 329
$EX940:
	pop	si
	pop	di
	leave	
	ret	

_FindDelimiter	ENDP
; Line 332
	PUBLIC	_FindDigit
_FindDigit	PROC NEAR
	enter	0,0
	push	di
	push	si
; Line 333
$FC950:
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	push	ax
	call	_IsXdigit
	add	sp,2
	cmp	ax,0
	je	$JCC1626
	jmp	$FB951
$JCC1626:
; Line 334
; Line 335
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],0
	je	$JCC1640
	jmp	$I952
$JCC1640:
; Line 336
	call	_ErrorExit
; Line 337
$I952:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],10
	je	$JCC1657
	jmp	$I953
$JCC1657:
; Line 338
	mov	ax,0
	jmp	$EX948
; Line 339
$I953:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],47
	je	$JCC1677
	jmp	$I954
$JCC1677:
; Line 340
; Line 341
	call	_BypassComment
	cmp	ax,0
	je	$JCC1688
	jmp	$I955
$JCC1688:
; Line 342
	inc	WORD PTR _iDataIndex
; Line 343
$I955:
; Line 344
	jmp	$I956
$I954:
; Line 345
	inc	WORD PTR _iDataIndex
$I956:
; Line 346
	jmp	$FC950
$FB951:
; Line 347
	mov	ax,1
	jmp	$EX948
; Line 348
$EX948:
	pop	si
	pop	di
	leave	
	ret	

_FindDigit	ENDP
; Line 351
	PUBLIC	_FindAnyToken
_FindAnyToken	PROC NEAR
	enter	0,0
	push	di
	push	si
; Line 352
$FC959:
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	push	ax
	call	_IsAlphaNumeric
	add	sp,2
	cmp	ax,0
	je	$JCC1741
	jmp	$FB960
$JCC1741:
; Line 353
; Line 354
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],0
	je	$JCC1755
	jmp	$I961
$JCC1755:
; Line 355
	call	_ErrorExit
; Line 356
$I961:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],40
	je	$JCC1772
	jmp	$I962
$JCC1772:
; Line 357
; Line 358
	inc	WORD PTR _iDataIndex
; Line 359
	mov	al,40
	jmp	$EX957
; Line 360
; Line 361
$I962:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],125
	je	$JCC1795
	jmp	$I963
$JCC1795:
; Line 362
	mov	al,125
	jmp	$EX957
; Line 363
$I963:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],47
	je	$JCC1814
	jmp	$I964
$JCC1814:
; Line 364
; Line 365
	call	_BypassComment
	cmp	ax,0
	je	$JCC1825
	jmp	$I965
$JCC1825:
; Line 366
	inc	WORD PTR _iDataIndex
; Line 367
$I965:
; Line 368
	jmp	$I966
$I964:
; Line 369
	inc	WORD PTR _iDataIndex
$I966:
; Line 370
	jmp	$FC959
$FB960:
; Line 371
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	jmp	$EX957
; Line 372
$EX957:
	pop	si
	pop	di
	leave	
	ret	

_FindAnyToken	ENDP
; Line 375
	PUBLIC	_ParseResponseData
_ParseResponseData	PROC NEAR
	enter	0,0
	push	di
	push	si
; Line 379
	mov	WORD PTR _iDataIndex,0
; Line 380
$FC969:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],0
	jne	$JCC1880
	jmp	$FB970
$JCC1880:
; Line 381
; Line 382
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],34
	je	$JCC1894
	jmp	$I971
$JCC1894:
; Line 383
; Line 384
	inc	WORD PTR _iDataIndex
; Line 385
$FC973:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],34
	jne	$JCC1912
	jmp	$FB974
$JCC1912:
; Line 386
; Line 387
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],92
	je	$JCC1926
	jmp	$I975
$JCC1926:
; Line 388
	inc	WORD PTR _iDataIndex
; Line 389
$I975:
	inc	WORD PTR _iDataIndex
; Line 390
	jmp	$FC973
$FB974:
; Line 391
; Line 392
$I971:
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	push	ax
	call	_ToLowerCase
	add	sp,2
	mov	bx,WORD PTR _iDataIndex
	mov	BYTE PTR _abyFileBuffer[bx],al
; Line 393
	inc	WORD PTR _iDataIndex
; Line 394
	jmp	$FC969
$FB970:
; Line 395
	mov	WORD PTR _iDataIndex,0
; Line 396
	mov	WORD PTR _wCOMstart,3
; Line 397
	mov	WORD PTR _wCOMlast,10
; Line 401
$FC977:
	call	_FindAnyToken
	cmp	al,101
	jne	$JCC1995
	jmp	$FB978
$JCC1995:
; Line 402
; Line 403
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	sub	ah,ah
	jmp	$S979
; Line 404
; Line 405
$SC983:
; Line 406
	push	0
	push	40
	call	_FindToken
	add	sp,4
	cmp	ax,0
	je	$JCC2026
	jmp	$I984
$JCC2026:
; Line 407
	jmp	$SB980
; Line 408
$I984:
	call	_FindDigit
	cmp	ax,0
	je	$JCC2040
	jmp	$I985
$JCC2040:
; Line 409
	jmp	$SB980
; Line 410
$I985:
	call	_GetValue
	mov	WORD PTR _usDosIOdelayCount,ax
; Line 411
	cmp	WORD PTR _usDosIOdelayCount,0
	je	$JCC2059
	jmp	$I986
$JCC2059:
; Line 412
	mov	WORD PTR _usDosIOdelayCount,1
; Line 413
$I986:
	jmp	$SB980
; Line 414
$SC987:
; Line 415
	push	ds
	push	OFFSET _chProcessing
	push	OFFSET _chProcessing
	call	_StringLength
	add	sp,2
	push	ax
	push	0
	call	FAR PTR VIOWRTTTY
; Line 416
	mov	WORD PTR _bVerbose,1
; Line 417
	jmp	$SB980
; Line 418
$SC988:
; Line 425
	push	0
	push	40
	call	_FindToken
	add	sp,4
	cmp	ax,0
	je	$JCC2116
	jmp	$I989
$JCC2116:
; Line 426
	jmp	$SB980
; Line 427
$I989:
	call	_FindDigit
	cmp	ax,0
	je	$JCC2130
	jmp	$I990
$JCC2130:
; Line 428
	jmp	$SB980
; Line 429
$I990:
	call	_GetValue
	mov	WORD PTR _wCOMstart,ax
; Line 430
	cmp	WORD PTR _wCOMstart,0
	je	$JCC2149
	jmp	$I991
$JCC2149:
; Line 431
; Line 432
	mov	WORD PTR _wCOMstart,1
; Line 433
	mov	WORD PTR _wCOMlast,8
; Line 434
	jmp	$SB980
; Line 435
; Line 436
$I991:
$FC993:
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	push	ax
	call	_IsDigit
	add	sp,2
	cmp	ax,0
	je	$JCC2187
	jmp	$FB994
$JCC2187:
; Line 437
; Line 438
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],41
	je	$JCC2201
	jmp	$I995
$JCC2201:
; Line 439
	jmp	$FB994
; Line 440
$I995:
	inc	WORD PTR _iDataIndex
; Line 441
	jmp	$FC993
$FB994:
; Line 442
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	push	ax
	call	_IsDigit
	add	sp,2
	cmp	ax,0
	je	$JCC2234
	jmp	$I996
$JCC2234:
; Line 443
	mov	ax,WORD PTR _wCOMstart
	add	ax,7
	mov	WORD PTR _wCOMlast,ax
; Line 444
	jmp	$I997
$I996:
; Line 445
	call	_GetValue
	mov	WORD PTR _wCOMlast,ax
$I997:
; Line 446
	jmp	$SB980
; Line 447
$SC998:
; Line 448
	call	_ProcessDeviceParams
; Line 449
	jmp	$SB980
; Line 450
$SC999:
; Line 451
	push	0
	push	40
	call	_FindToken
	add	sp,4
	cmp	ax,0
	je	$JCC2279
	jmp	$I1000
$JCC2279:
; Line 452
	jmp	$SB980
; Line 453
$I1000:
	call	_FindDigit
	cmp	ax,0
	je	$JCC2293
	jmp	$I1001
$JCC2293:
; Line 454
	jmp	$SB980
; Line 455
$I1001:
	call	_GetValue
	mov	WORD PTR _wDelayCount,ax
; Line 456
	cmp	WORD PTR _wDelayCount,0
	je	$JCC2312
	jmp	$I1002
$JCC2312:
; Line 457
	mov	WORD PTR _wDelayCount,20
; Line 458
$I1002:
	mov	WORD PTR _bWaitForCR,1
; Line 459
	jmp	$SB980
; Line 460
	jmp	$SB980
$S979:
	sub	ax,99
	jne	$JCC2338
	jmp	$SC988
$JCC2338:
	dec	ax
	jne	$JCC2344
	jmp	$SC998
$JCC2344:
	sub	ax,5
	jne	$JCC2352
	jmp	$SC983
$JCC2352:
	sub	ax,11
	jne	$JCC2360
	jmp	$SC999
$JCC2360:
	dec	ax
	dec	ax
	jne	$JCC2367
	jmp	$SC987
$JCC2367:
	jmp	$SB980
$SB980:
; Line 461
	push	0
	push	10
	call	_FindToken
	add	sp,4
; Line 462
	jmp	$FC977
$FB978:
; Line 463
$EX967:
	pop	si
	pop	di
	leave	
	ret	

_ParseResponseData	ENDP
; Line 466
	PUBLIC	_ProcessDeviceParams
_ProcessDeviceParams	PROC NEAR
	enter	0,0
	push	di
	push	si
; Line 467
	push	0
	push	40
	call	_FindToken
	add	sp,4
	cmp	ax,0
	je	$JCC2411
	jmp	$I1004
$JCC2411:
; Line 468
; Line 469
	mov	WORD PTR _iStartDevice,1
; Line 470
	mov	WORD PTR _iEndDevice,8
; Line 471
; Line 472
	jmp	$I1005
$I1004:
; Line 473
; Line 474
	call	_FindDigit
	cmp	ax,0
	je	$JCC2437
	jmp	$I1006
$JCC2437:
; Line 475
	jmp	$EX1003
; Line 476
$I1006:
	call	_GetValue
	mov	WORD PTR _iStartDevice,ax
; Line 477
$FC1008:
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	push	ax
	call	_IsDigit
	add	sp,2
	cmp	ax,0
	je	$JCC2469
	jmp	$FB1009
$JCC2469:
; Line 478
; Line 479
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],41
	je	$JCC2483
	jmp	$I1010
$JCC2483:
; Line 480
	jmp	$FB1009
; Line 481
$I1010:
	inc	WORD PTR _iDataIndex
; Line 482
	jmp	$FC1008
$FB1009:
; Line 483
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	push	ax
	call	_IsDigit
	add	sp,2
	cmp	ax,0
	je	$JCC2516
	jmp	$I1011
$JCC2516:
; Line 484
	mov	ax,WORD PTR _iStartDevice
	mov	WORD PTR _iEndDevice,ax
; Line 485
	jmp	$I1012
$I1011:
; Line 486
	call	_GetValue
	mov	WORD PTR _iEndDevice,ax
$I1012:
; Line 487
$I1005:
; Line 488
	push	1
	push	123
	call	_FindToken
	add	sp,4
	cmp	ax,0
	je	$JCC2549
	jmp	$I1013
$JCC2549:
; Line 489
	jmp	$EX1003
; Line 490
$I1013:
	call	_ParseParms
; Line 491
$EX1003:
	pop	si
	pop	di
	leave	
	ret	

_ProcessDeviceParams	ENDP
; Line 494
	PUBLIC	_ParseParms
_ParseParms	PROC NEAR
	enter	10,0
	push	di
	push	si
;	iIndex = -2
;	wTemp = -8
;	lTemp = -6
; Line 506
$FC1019:
	call	_FindAnyToken
	cmp	al,125
	jne	$JCC2575
	jmp	$FB1020
$JCC2575:
; Line 507
; Line 508
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	sub	ah,ah
	jmp	$S1021
; Line 509
; Line 510
$SC1025:
; Line 533
	push	0
	push	34
	call	_FindToken
	add	sp,4
	cmp	ax,0
	je	$JCC2606
	jmp	$I1026
$JCC2606:
; Line 534
	jmp	$SB1022
; Line 535
$I1026:
	mov	WORD PTR [bp-2],0	;iIndex
; Line 536
$FC1028:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],34
	jne	$JCC2628
	jmp	$FB1029
$JCC2628:
	cmp	WORD PTR [bp-2],255	;iIndex
	jl	$JCC2638
	jmp	$FB1029
$JCC2638:
; Line 537
; Line 538
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],92
	je	$JCC2652
	jmp	$I1030
$JCC2652:
; Line 539
; Line 540
	inc	WORD PTR _iDataIndex
; Line 541
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	sub	ah,ah
	jmp	$S1031
; Line 542
; Line 543
$SC1035:
; Line 544
	inc	WORD PTR _iDataIndex
; Line 545
	mov	bx,WORD PTR [bp-2]	;iIndex
	mov	BYTE PTR _abyString[bx],10
	inc	WORD PTR [bp-2]	;iIndex
; Line 546
	mov	bx,WORD PTR [bp-2]	;iIndex
	mov	BYTE PTR _abyString[bx],13
	inc	WORD PTR [bp-2]	;iIndex
; Line 547
	jmp	$SB1032
; Line 548
$SC1036:
; Line 549
	inc	WORD PTR _iDataIndex
; Line 550
	mov	bx,WORD PTR [bp-2]	;iIndex
	mov	BYTE PTR _abyString[bx],13
	inc	WORD PTR [bp-2]	;iIndex
; Line 551
	jmp	$SB1032
; Line 552
$SC1037:
; Line 553
	inc	WORD PTR _iDataIndex
; Line 554
	mov	bx,WORD PTR [bp-2]	;iIndex
	mov	BYTE PTR _abyString[bx],9
	inc	WORD PTR [bp-2]	;iIndex
; Line 555
	jmp	$SB1032
; Line 556
$SC1038:
; Line 558
$FC1040:
	mov	bx,WORD PTR _iDataIndex
	inc	WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],92
	jne	$JCC2752
	jmp	$FB1041
$JCC2752:
	jmp	$FC1040
$FB1041:
; Line 559
	jmp	$SB1032
; Line 560
$SC1042:
; Line 561
	inc	WORD PTR _iDataIndex
; Line 562
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	push	ax
	call	_IsXdigit
	add	sp,2
	cmp	ax,0
	jne	$JCC2785
	jmp	$I1043
$JCC2785:
; Line 563
; Line 564
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	mov	BYTE PTR _abyNumber,al
	inc	WORD PTR _iDataIndex
; Line 565
	mov	BYTE PTR _abyNumber+1,0
; Line 566
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	push	ax
	call	_IsXdigit
	add	sp,2
	cmp	ax,0
	jne	$JCC2828
	jmp	$I1044
$JCC2828:
; Line 567
; Line 568
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	mov	BYTE PTR _abyNumber+1,al
	inc	WORD PTR _iDataIndex
; Line 569
	mov	BYTE PTR _abyNumber+2,0
; Line 570
; Line 571
$I1044:
	push	16
	call	_ASCIItoBin
	add	sp,2
	mov	bx,WORD PTR [bp-2]	;iIndex
	mov	BYTE PTR _abyString[bx],al
	inc	WORD PTR [bp-2]	;iIndex
; Line 572
; Line 573
	jmp	$I1045
$I1043:
; Line 574
	mov	bx,WORD PTR [bp-2]	;iIndex
	mov	BYTE PTR _abyString[bx],120
	inc	WORD PTR [bp-2]	;iIndex
$I1045:
; Line 575
	jmp	$SB1032
; Line 576
$SD1046:
; Line 577
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	mov	bx,WORD PTR [bp-2]	;iIndex
	mov	BYTE PTR _abyString[bx],al
	inc	WORD PTR _iDataIndex
	inc	WORD PTR [bp-2]	;iIndex
; Line 578
	jmp	$SB1032
; Line 579
	jmp	$SB1032
$S1031:
	cmp	ax,110
	jne	$JCC2919
	jmp	$SC1035
$JCC2919:
	jle	$JCC2924
	jmp	$L20000
$JCC2924:
	sub	ax,10
	jne	$JCC2932
	jmp	$SC1038
$JCC2932:
	sub	ax,3
	jne	$JCC2940
	jmp	$SC1038
$JCC2940:
	jmp	$SD1046
$L20000:
	sub	ax,114
	jne	$JCC2951
	jmp	$SC1036
$JCC2951:
	dec	ax
	dec	ax
	jne	$JCC2958
	jmp	$SC1037
$JCC2958:
	sub	ax,4
	jne	$JCC2966
	jmp	$SC1042
$JCC2966:
	jmp	$SD1046
$SB1032:
; Line 580
; Line 581
	jmp	$I1047
$I1030:
; Line 582
; Line 583
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],10
	je	$JCC2986
	jmp	$I1048
$JCC2986:
; Line 584
$FC1050:
	mov	bx,WORD PTR _iDataIndex
	inc	WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],92
	jne	$JCC3004
	jmp	$FB1051
$JCC3004:
	jmp	$FC1050
$FB1051:
; Line 585
$I1048:
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	mov	bx,WORD PTR [bp-2]	;iIndex
	mov	BYTE PTR _abyString[bx],al
	inc	WORD PTR _iDataIndex
	inc	WORD PTR [bp-2]	;iIndex
; Line 586
$I1047:
; Line 587
	jmp	$FC1028
$FB1029:
; Line 588
	push	ds
	push	OFFSET _abyString
	push	WORD PTR [bp-2]	;iIndex
	push	0
	call	FAR PTR VIOWRTTTY
; Line 589
	jmp	$SB1022
; Line 590
$SC1052:
; Line 591
	push	0
	push	40
	call	_FindToken
	add	sp,4
	cmp	ax,0
	je	$JCC3067
	jmp	$I1053
$JCC3067:
; Line 592
	jmp	$SB1022
; Line 593
$I1053:
$FC1055:
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	push	ax
	call	_IsDigit
	add	sp,2
	cmp	ax,0
	je	$JCC3093
	jmp	$FB1056
$JCC3093:
; Line 594
; Line 595
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],41
	je	$JCC3107
	jmp	$I1057
$JCC3107:
; Line 596
	jmp	$FB1056
; Line 597
$I1057:
	inc	WORD PTR _iDataIndex
; Line 598
	jmp	$FC1055
$FB1056:
; Line 599
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	push	ax
	call	_IsDigit
	add	sp,2
	cmp	ax,0
	je	$JCC3140
	jmp	$I1058
$JCC3140:
; Line 600
; Line 601
	imul	bx,WORD PTR [bp-2],42	;iIndex
	and	WORD PTR _astComDCB[bx],-2
; Line 602
	mov	WORD PTR _wOEMjumpExit,0
; Line 603
	mov	WORD PTR _wIntIDregister,0
; Line 604
; Line 605
	jmp	$I1059
$I1058:
; Line 606
; Line 607
	call	_GetValue
	mov	WORD PTR _wIntIDregister,ax
; Line 608
	mov	ax,WORD PTR _iStartDevice
	dec	ax
	mov	WORD PTR [bp-2],ax	;iIndex
	jmp	$F1060
$FC1061:
	inc	WORD PTR [bp-2]	;iIndex
$F1060:
	mov	ax,WORD PTR [bp-2]	;iIndex
	cmp	WORD PTR _iEndDevice,ax
	jg	$JCC3195
	jmp	$FB1062
$JCC3195:
; Line 609
	imul	bx,WORD PTR [bp-2],42	;iIndex
	or	WORD PTR _astComDCB[bx],1
	jmp	$FC1061
$FB1062:
; Line 610
	mov	WORD PTR _wOEMjumpExit,6
; Line 611
$I1059:
; Line 612
	jmp	$SB1022
; Line 613
$SC1063:
; Line 614
	push	0
	push	40
	call	_FindToken
	add	sp,4
	cmp	ax,0
	je	$JCC3234
	jmp	$I1064
$JCC3234:
; Line 615
	jmp	$SB1022
; Line 616
$I1064:
	call	_FindDigit
	cmp	ax,0
	je	$JCC3248
	jmp	$I1065
$JCC3248:
; Line 617
	jmp	$SB1022
; Line 618
$I1065:
	call	_GetValue
	mov	WORD PTR [bp-8],ax	;wTemp
; Line 619
	mov	ax,WORD PTR _iStartDevice
	dec	ax
	mov	WORD PTR [bp-2],ax	;iIndex
	jmp	$F1066
$FC1067:
	inc	WORD PTR [bp-2]	;iIndex
$F1066:
	mov	ax,WORD PTR [bp-2]	;iIndex
	cmp	WORD PTR _iEndDevice,ax
	jg	$JCC3282
	jmp	$FB1068
$JCC3282:
; Line 620
; Line 621
	mov	ax,WORD PTR [bp-8]	;wTemp
	imul	bx,WORD PTR [bp-2],42	;iIndex
	mov	WORD PTR _astComDCB[bx+6],ax
; Line 622
	add	WORD PTR [bp-8],8	;wTemp
; Line 623
	jmp	$FC1067
$FB1068:
; Line 624
	jmp	$SB1022
; Line 625
$SC1069:
; Line 626
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx+1],117
	je	$JCC3317
	jmp	$I1070
$JCC3317:
; Line 627
; Line 628
	push	1
	push	123
	call	_FindToken
	add	sp,4
	cmp	ax,0
	je	$JCC3335
	jmp	$I1071
$JCC3335:
; Line 629
	jmp	$SB1022
; Line 630
$I1071:
	call	_ProcessBufferCommand
; Line 631
; Line 632
$I1070:
	jmp	$SB1022
; Line 633
$SC1072:
; Line 634
	push	0
	push	40
	call	_FindToken
	add	sp,4
	cmp	ax,0
	je	$JCC3362
	jmp	$I1073
$JCC3362:
; Line 635
	jmp	$SB1022
; Line 636
$I1073:
	call	_FindDigit
	cmp	ax,0
	je	$JCC3376
	jmp	$I1074
$JCC3376:
; Line 637
	jmp	$SB1022
; Line 638
$I1074:
	call	_GetValue
	mov	WORD PTR [bp-6],ax	;lTemp
	mov	WORD PTR [bp-4],dx
; Line 639
	mov	ax,WORD PTR _iStartDevice
	dec	ax
	mov	WORD PTR [bp-2],ax	;iIndex
	jmp	$F1075
$FC1076:
	inc	WORD PTR [bp-2]	;iIndex
$F1075:
	mov	ax,WORD PTR [bp-2]	;iIndex
	cmp	WORD PTR _iEndDevice,ax
	jg	$JCC3413
	jmp	$FB1077
$JCC3413:
; Line 640
	mov	al,BYTE PTR [bp-6]	;lTemp
	imul	bx,WORD PTR [bp-2],42	;iIndex
	mov	BYTE PTR _astComDCB[bx+32],al
	jmp	$FC1076
$FB1077:
; Line 641
	jmp	$SB1022
; Line 642
	jmp	$SB1022
$S1021:
	sub	ax,97
	jne	$JCC3441
	jmp	$SC1063
$JCC3441:
	dec	ax
	jne	$JCC3447
	jmp	$SC1069
$JCC3447:
	sub	ax,7
	jne	$JCC3455
	jmp	$SC1072
$JCC3455:
	sub	ax,4
	jne	$JCC3463
	jmp	$SC1025
$JCC3463:
	sub	ax,6
	jne	$JCC3471
	jmp	$SC1052
$JCC3471:
	jmp	$SB1022
$SB1022:
; Line 643
	push	0
	push	125
	call	_FindToken
	add	sp,4
	cmp	ax,0
	jne	$JCC3492
	jmp	$I1078
$JCC3492:
; Line 644
	jmp	$EX1014
; Line 645
$I1078:
	jmp	$FC1019
$FB1020:
; Line 646
	inc	WORD PTR _iDataIndex
; Line 647
$EX1014:
	pop	si
	pop	di
	leave	
	ret	

_ParseParms	ENDP
; Line 650
	PUBLIC	_GetValue
_GetValue	PROC NEAR
	enter	4,0
	push	di
	push	si
;	iIndex = -4
;	iRadix = -2
; Line 651
	mov	WORD PTR [bp-4],0	;iIndex
; Line 652
	mov	WORD PTR [bp-2],10	;iRadix
; Line 654
$FC1083:
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],0
	jne	$JCC3536
	jmp	$FB1084
$JCC3536:
; Line 655
; Line 656
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	push	ax
	call	_IsXdigit
	add	sp,2
	cmp	ax,0
	jne	$JCC3559
	jmp	$I1085
$JCC3559:
; Line 657
; Line 658
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx+1],120
	je	$JCC3573
	jmp	$I1086
$JCC3573:
; Line 659
; Line 660
	mov	WORD PTR [bp-2],16	;iRadix
; Line 661
	add	WORD PTR _iDataIndex,2
; Line 662
; Line 663
$I1086:
$FC1088:
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	push	ax
	call	_IsXdigit
	add	sp,2
	cmp	ax,0
	jne	$JCC3606
	jmp	$FB1089
$JCC3606:
; Line 664
; Line 665
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	mov	bx,WORD PTR [bp-4]	;iIndex
	mov	BYTE PTR _abyNumber[bx],al
	inc	WORD PTR _iDataIndex
	inc	WORD PTR [bp-4]	;iIndex
; Line 666
	cmp	WORD PTR [bp-4],9	;iIndex
	jge	$JCC3637
	jmp	$I1090
$JCC3637:
; Line 667
	jmp	$FB1089
; Line 668
$I1090:
	jmp	$FC1088
$FB1089:
; Line 669
	cmp	WORD PTR [bp-4],0	;iIndex
	jg	$JCC3652
	jmp	$I1091
$JCC3652:
; Line 670
; Line 671
	mov	bx,WORD PTR [bp-4]	;iIndex
	mov	BYTE PTR _abyNumber[bx],0
; Line 672
	mov	bx,WORD PTR _iDataIndex
	cmp	BYTE PTR _abyFileBuffer[bx],104
	je	$JCC3674
	jmp	$I1092
$JCC3674:
; Line 673
	mov	WORD PTR [bp-2],16	;iRadix
; Line 674
$I1092:
	push	WORD PTR [bp-2]	;iRadix
	call	_ASCIItoBin
	add	sp,2
	jmp	$EX1079
; Line 675
; Line 676
$I1091:
; Line 677
$I1085:
	inc	WORD PTR _iDataIndex
; Line 678
	jmp	$FC1083
$FB1084:
; Line 679
	call	_ErrorExit
; Line 680
$EX1079:
	pop	si
	pop	di
	leave	
	ret	

_GetValue	ENDP
; Line 683
	PUBLIC	_ASCIItoBin
_ASCIItoBin	PROC NEAR
	enter	20,0
	push	di
	push	si
;	iIndex = -2
;	lMulIndex = -10
;	lValue = -18
;	lTemp = -6
;	lMultiplier = -14
;	iRadix = 4
; Line 684
	mov	WORD PTR [bp-2],0	;iIndex
; Line 686
	sub	ax,ax
	mov	WORD PTR [bp-16],ax
	mov	WORD PTR [bp-18],ax	;lValue
; Line 688
	mov	WORD PTR [bp-14],1	;lMultiplier
	mov	WORD PTR [bp-12],0
; Line 690
$FC1101:
	mov	bx,WORD PTR [bp-2]	;iIndex
	inc	WORD PTR [bp-2]	;iIndex
	cmp	BYTE PTR _abyNumber[bx],0
	jne	$JCC3750
	jmp	$FB1102
$JCC3750:
	jmp	$FC1101
$FB1102:
; Line 691
	sub	WORD PTR [bp-2],2	;iIndex
	jmp	$F1103
$FC1104:
	dec	WORD PTR [bp-2]	;iIndex
$F1103:
	cmp	WORD PTR [bp-2],0	;iIndex
	jge	$JCC3772
	jmp	$FB1105
$JCC3772:
; Line 692
; Line 693
	mov	bx,WORD PTR [bp-2]	;iIndex
	cmp	BYTE PTR _abyNumber[bx],97
	jae	$JCC3785
	jmp	$I1106
$JCC3785:
; Line 694
; Line 695
	cmp	WORD PTR [bp+4],16	;iRadix
	jne	$JCC3794
	jmp	$I1107
$JCC3794:
; Line 696
	mov	ax,0
	mov	dx,0
	jmp	$EX1094
; Line 697
$I1107:
	mov	bx,WORD PTR [bp-2]	;iIndex
	mov	al,BYTE PTR _abyNumber[bx]
	sub	ah,ah
	sub	ax,87
	mov	WORD PTR [bp-6],ax	;lTemp
	mov	WORD PTR [bp-4],0
; Line 698
; Line 699
	jmp	$I1108
$I1106:
; Line 700
	mov	bx,WORD PTR [bp-2]	;iIndex
	mov	al,BYTE PTR _abyNumber[bx]
	sub	ah,ah
	sub	ax,48
	mov	WORD PTR [bp-6],ax	;lTemp
	mov	WORD PTR [bp-4],0
$I1108:
; Line 701
	cmp	WORD PTR [bp-4],0
	jge	$JCC3855
	jmp	$I1109
$JCC3855:
	jle	$JCC3860
	jmp	$L20001
$JCC3860:
	cmp	WORD PTR [bp-6],0	;lTemp
	ja	$JCC3869
	jmp	$I1109
$JCC3869:
$L20001:
; Line 702
; Line 703
	sub	ax,ax
	mov	WORD PTR [bp-8],ax
	mov	WORD PTR [bp-10],ax	;lMulIndex
	jmp	$F1110
$FC1111:
	add	WORD PTR [bp-10],1	;lMulIndex
	adc	WORD PTR [bp-8],0
$F1110:
	mov	ax,WORD PTR [bp-10]	;lMulIndex
	mov	dx,WORD PTR [bp-8]
	cmp	WORD PTR [bp-12],dx
	jge	$JCC3902
	jmp	$FB1112
$JCC3902:
	jle	$JCC3907
	jmp	$L20002
$JCC3907:
	cmp	WORD PTR [bp-14],ax	;lMultiplier
	ja	$JCC3915
	jmp	$FB1112
$JCC3915:
$L20002:
; Line 704
	mov	ax,WORD PTR [bp-6]	;lTemp
	mov	dx,WORD PTR [bp-4]
	add	WORD PTR [bp-18],ax	;lValue
	adc	WORD PTR [bp-16],dx
	jmp	$FC1111
$FB1112:
; Line 705
; Line 706
$I1109:
	cmp	WORD PTR [bp-2],0	;iIndex
	je	$JCC3939
	jmp	$I1113
$JCC3939:
; Line 707
	mov	ax,WORD PTR [bp-18]	;lValue
	mov	dx,WORD PTR [bp-16]
	jmp	$EX1094
; Line 708
$I1113:
	mov	ax,WORD PTR [bp-14]	;lMultiplier
	mov	dx,WORD PTR [bp-12]
	mov	WORD PTR [bp-6],ax	;lTemp
	mov	WORD PTR [bp-4],dx
; Line 709
	mov	WORD PTR [bp-10],1	;lMulIndex
	mov	WORD PTR [bp-8],0
	jmp	$F1114
$FC1115:
	add	WORD PTR [bp-10],1	;lMulIndex
	adc	WORD PTR [bp-8],0
$F1114:
	mov	ax,WORD PTR [bp+4]	;iRadix
	cwd	
	cmp	dx,WORD PTR [bp-8]
	jge	$JCC3993
	jmp	$FB1116
$JCC3993:
	jle	$JCC3998
	jmp	$L20003
$JCC3998:
	cmp	ax,WORD PTR [bp-10]	;lMulIndex
	ja	$JCC4006
	jmp	$FB1116
$JCC4006:
$L20003:
; Line 710
	mov	ax,WORD PTR [bp-6]	;lTemp
	mov	dx,WORD PTR [bp-4]
	add	WORD PTR [bp-14],ax	;lMultiplier
	adc	WORD PTR [bp-12],dx
	jmp	$FC1115
$FB1116:
; Line 711
	jmp	$FC1104
$FB1105:
; Line 712
$EX1094:
	pop	si
	pop	di
	leave	
	ret	

_ASCIItoBin	ENDP
; Line 715
	PUBLIC	_ProcessBufferCommand
_ProcessBufferCommand	PROC NEAR
	enter	6,0
	push	di
	push	si
;	iIndex = -2
;	wTemp = -6
;	pWord = -4
; Line 720
$FC1122:
	call	_FindAnyToken
	cmp	al,125
	jne	$JCC4044
	jmp	$FB1123
$JCC4044:
; Line 721
; Line 722
	mov	bx,WORD PTR _iDataIndex
	mov	al,BYTE PTR _abyFileBuffer[bx]
	sub	ah,ah
	jmp	$S1124
; Line 723
; Line 724
$SC1128:
; Line 725
	imul	ax,WORD PTR _iStartDevice,42
	add	ax,OFFSET _astComDCB-34
	mov	WORD PTR [bp-4],ax	;pWord
; Line 726
	jmp	$SB1125
; Line 727
$SC1129:
; Line 728
	imul	ax,WORD PTR _iStartDevice,42
	add	ax,OFFSET _astComDCB-32
	mov	WORD PTR [bp-4],ax	;pWord
; Line 729
	jmp	$SB1125
; Line 730
$SD1130:
; Line 731
	jmp	$EX1117
; Line 732
	jmp	$SB1125
$S1124:
	sub	ax,114
	jne	$JCC4099
	jmp	$SC1128
$JCC4099:
	sub	ax,5
	jne	$JCC4107
	jmp	$SC1129
$JCC4107:
	jmp	$SD1130
$SB1125:
; Line 733
	push	0
	push	40
	call	_FindToken
	add	sp,4
	cmp	ax,0
	jne	$JCC4128
	jmp	$I1131
$JCC4128:
	call	_FindDigit
	cmp	ax,0
	jne	$JCC4139
	jmp	$I1131
$JCC4139:
; Line 734
; Line 735
	call	_GetValue
	mov	WORD PTR [bp-6],ax	;wTemp
; Line 736
	mov	ax,WORD PTR _iStartDevice
	dec	ax
	mov	WORD PTR [bp-2],ax	;iIndex
	jmp	$F1132
$FC1133:
	inc	WORD PTR [bp-2]	;iIndex
$F1132:
	mov	ax,WORD PTR [bp-2]	;iIndex
	cmp	WORD PTR _iEndDevice,ax
	jg	$JCC4170
	jmp	$FB1134
$JCC4170:
; Line 737
; Line 738
	mov	ax,WORD PTR [bp-6]	;wTemp
	mov	bx,WORD PTR [bp-4]	;pWord
	mov	WORD PTR [bx],ax
; Line 739
	add	WORD PTR [bp-4],42	;pWord
; Line 740
	jmp	$FC1133
$FB1134:
; Line 741
; Line 742
$I1131:
	jmp	$FC1122
$FB1123:
; Line 743
	inc	WORD PTR _iDataIndex
; Line 744
$EX1117:
	pop	si
	pop	di
	leave	
	ret	

_ProcessBufferCommand	ENDP
_TEXT	ENDS
END
