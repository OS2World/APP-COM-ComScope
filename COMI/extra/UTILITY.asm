;	Static Name Aliases
;
	TITLE   UTILITY.C
	.286p
_TEXT	SEGMENT  WORD PUBLIC 'CODE'
_TEXT	ENDS
_DATA	SEGMENT  WORD PUBLIC 'DATA'
_DATA	ENDS
$$TYPES	SEGMENT  BYTE PUBLIC 'DEBTYP'
$$TYPES	ENDS
DGROUP  GROUP  _DATA
	ASSUME DS: DGROUP
	ASSUME  SS: NOTHING
EXTRN	__aNulrem:NEAR
EXTRN	__aNuldiv:NEAR
_TEXT      SEGMENT
	ASSUME	CS: _TEXT
; Line 1
; Line 34
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
; Line 35
; Line 36
; Line 37
; Line 44
	PUBLIC	_StringLength
_StringLength	PROC NEAR
	enter	2,0
	push	di
	push	si
;	wIndex = -2
;	abyString = 4
; Line 45
	mov	WORD PTR [bp-2],0	;wIndex
; Line 47
$FC1028:
	mov	bx,WORD PTR [bp+4]	;abyString
	mov	si,WORD PTR [bp-2]	;wIndex
	cmp	BYTE PTR [bx][si],0
	jne	$JCC20
	jmp	$FB1029
$JCC20:
; Line 48
	inc	WORD PTR [bp-2]	;wIndex
	jmp	$FC1028
$FB1029:
; Line 49
	mov	ax,WORD PTR [bp-2]	;wIndex
	jmp	$EX1025
; Line 50
$EX1025:
	pop	si
	pop	di
	leave	
	ret	

_StringLength	ENDP
; Line 53
	PUBLIC	_CalcBaudRate
_CalcBaudRate	PROC NEAR
	enter	0,0
	push	di
	push	si
;	ulBaudRate = 4
; Line 54
	cmp	WORD PTR [bp+6],0
	jbe	$JCC51
	jmp	$L20000
$JCC51:
	cmp	WORD PTR [bp+4],-7936	;ulBaudRate
	ja	$JCC61
	jmp	$I1033
$JCC61:
$L20000:
; Line 55
	push	WORD PTR [bp+6]
	push	WORD PTR [bp+4]	;ulBaudRate
	push	1
	push	-15872
	call	__aNulrem
	cmp	dx,0
	jbe	$JCC83
	jmp	$L20001
$JCC83:
	cmp	ax,12
	ja	$JCC91
	jmp	$I1034
$JCC91:
$L20001:
; Line 56
	mov	ax,0
	jmp	$EX1032
; Line 57
$I1034:
$I1033:
	push	WORD PTR [bp+6]
	push	WORD PTR [bp+4]	;ulBaudRate
	push	1
	push	-15872
	call	__aNuldiv
	jmp	$EX1032
; Line 58
$EX1032:
	pop	si
	pop	di
	leave	
	ret	

_CalcBaudRate	ENDP
_TEXT	ENDS
END
