	title	p:\utility\OS2LSRTL.C
	.386
	.387
CODE32	segment dword use32 public 'CODE'
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
	extrn	_fullDump:dword
DATA32	segment
	dd	_dllentry
DATA32	ends
CODE32	segment
CODE32	ends
end
