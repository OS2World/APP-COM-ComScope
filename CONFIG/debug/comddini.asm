	title	p:\config\comddini.c
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
	public	ulCOMiSignature
	public	wDDmaxDeviceCount
	public	adwClassCodeTable
	public	bNoDEBUGhelp
	public	bCOMiLoaded
	public	astConfigDeviceList
	public	bLimitLoad
	public	bPDRinstalled
	public	iPCIadapters
	public	bPCImachine
	public	bDeviceIniFileSelected
	public	bWarp4
	public	bSpoolSetupInUse
	public	bInstallInUse
	extrn	_dllentry:proc
	extrn	_CRT_init:proc
	extrn	WinQuerySysValue:proc
	extrn	PrfQueryProfileString:proc
	extrn	DosDevIOCtl:proc
	extrn	MessageBox:proc
	extrn	HelpInit:proc
	extrn	_sprintfieee:proc
	extrn	WinMessageBox:proc
	extrn	GetFileName:proc
	extrn	DestroyHelpInstance:proc
	extrn	strcpy:proc
	extrn	AppendTMP:proc
	extrn	DosQuerySysInfo:proc
	extrn	DosOpen:proc
	extrn	DosClose:proc
	extrn	strlen:proc
	extrn	DosRead:proc
	extrn	DosDelete:proc
	extrn	DosCopy:proc
	extrn	memcpy:proc
	extrn	fnwpPortSimpleDlgProc:proc
	extrn	fnwpPortConfigDlgProc:proc
	extrn	WinDlgBox:proc
	extrn	WinGetLastError:proc
	extrn	memset:proc
	extrn	DosQueryFileInfo:proc
	extrn	DosSetFilePtr:proc
	extrn	DosWrite:proc
	extrn	DosSetFileSize:proc
	extrn	AddListItem:proc
	extrn	strncpy:proc
	extrn	RemoveSpaces:proc
	extrn	atoi:proc
	extrn	AppendTripleDS:proc
	extrn	strcmp:proc
	extrn	MakeDeviceName:proc
	extrn	strncmp:proc
	extrn	WinSendDlgItemMsg:proc
	extrn	GetNextListItem:proc
	extrn	DosAllocMem:proc
	extrn	DosFreeMem:proc
	extrn	AppendINI:proc
	extrn	_fullDump:dword
	extrn	stGlobalCFGheader:byte
	extrn	szLastName:byte
	extrn	pAddressList:dword
	extrn	pInterruptList:dword
	extrn	_ctype:dword
DATA32	segment
@STAT1	db "PM_PORT_DRIVER",0h
	align 04h
@STAT2	db "COMI_SPL",0h
	align 04h
@STAT3	db "PM_PORT_DRIVER",0h
	align 04h
@STAT4	db "SPL_DEMO",0h
	align 04h
@STAT5	db "The COMi Configurartion "
db "Library Install Device f"
db "unction is currently bei"
db "ng accessed by another p"
db "rocess.",0ah,0ah,"Try again later"
db ".",0h
	align 04h
@STAT6	db "COMi",0h
	align 04h
@STAT7	db "Initialization",0h
	align 04h
@STAT8	db 0ah,"You will need to specif"
db "y a device driver initia"
db "lization path and file n"
db "ame.",0h
	align 04h
@STAT9	db "Unknown Configuration Fi"
db "le Name",0h
@STATa	db "COMDD.INI",0h
	align 04h
@STATb	db "Specify Initialization F"
db "ile to Create.",0h
	align 04h
@STATc	db "Installation Has Been Ab"
db "orted",0h
	align 04h
@STATd	db "Installation of %s Has B"
db "een Aborted",0h
@STATe	db "Version is %d.%d",0h
	align 04h
@STATf	db "OEMHLP$",0h
@STAT10	db "TESTCFG$",0h
	align 04h
@STAT11	db "Unable to open or access"
db " TESTCFG",0h
	align 04h
@STAT12	db "Is this a Micro Channel "
db "machine (IBM PS/2 or com"
db "patable)?",0h
	align 04h
@STAT13	db "Invalid device driver in"
db "itialization file specif"
db "ication",0h
@STAT14	db "Unable to open or create"
db " the COMi initialization"
db " file %s",0h
	align 04h
@STAT15	db "COMi",0h
	align 04h
@STAT16	db "Initialization",0h
	align 04h
@STAT17	db "OS$tools",0h
	align 04h
@STAT18	db "Error Allocating Memory "
db "for DD PATH - %X",0h
	align 04h
@STAT19	db "DOS Error Accessing Exte"
db "nsion - %X",0h
	align 04h
@STAT1a	db "Extension Access Error -"
db " %04X-%04X",0h
	align 04h
@STAT1b	db "Unable to get Device Cou"
db "nt Restrictions, COMi EX"
db "T error = %u",0h
	align 04h
@STAT1c	db "Unable to get Device Cou"
db "nt Restrictions, DOS err"
db "or = %u",0h
@STAT1d	db "Unable to get OEM type C"
db "OMi EXT error = %u",0h
	align 04h
@STAT1e	db "Unable to get OEM type D"
db "OS error = %u",0h
	align 04h
@STAT1f	db "DOS Error Accessing COMi"
db " Extension - %X",0h
@STAT20	db "COMi Extension Access Er"
db "ror - %04X-%04X",0h
adwClassCodeTable	db 0h,0h,07h,0h
	db 01h,0h,07h,0h
	db 02h,0h,07h,0h
	db 03h,0h,07h,0h
	db 04h,0h,07h,0h
	db 05h,0h,07h,0h
	db 06h,0h,07h,0h
	db 080h,0h,07h,0h
	db 0h,02h,07h,0h
	db 0h,03h,07h,0h
	db 01h,03h,07h,0h
	db 02h,03h,07h,0h
	db 03h,03h,07h,0h
	db 04h,03h,07h,0h
	db 05h,03h,07h,0h
	db 06h,03h,07h,0h
	db 0h,080h,07h,0h
	db 0h,0h,0h,0h
astConfigDeviceList	db "COM0",0h
	db 05h DUP (00H)
	db 0h,0h,0h,0h
	db "COM1",0h
	db 05h DUP (00H)
	db 01h,0h,0h,0h
	db "COM2",0h
	db 05h DUP (00H)
	db 01h,0h,0h,0h
	db "COM3",0h
	db 05h DUP (00H)
	db 01h,0h,0h,0h
	db "COM4",0h
	db 05h DUP (00H)
	db 01h,0h,0h,0h
	db "COM5",0h
	db 05h DUP (00H)
	db 01h,0h,0h,0h
	db "COM6",0h
	db 05h DUP (00H)
	db 01h,0h,0h,0h
	db "COM7",0h
	db 05h DUP (00H)
	db 01h,0h,0h,0h
	db "COM8",0h
	db 05h DUP (00H)
	db 01h,0h,0h,0h
	db "COM9",0h
	db 05h DUP (00H)
	db 01h,0h,0h,0h
	db "COM10",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM11",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM12",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM13",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM14",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM15",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM16",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM17",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM18",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM19",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM20",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM21",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM22",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM23",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM24",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM25",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM26",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM27",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM28",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM29",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM30",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM31",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM32",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM33",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM34",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM35",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM36",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM37",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM38",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM39",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM40",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM41",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM42",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM43",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM44",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM45",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM46",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM47",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM48",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM49",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM50",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM51",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM52",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM53",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM54",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM55",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM56",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM57",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM58",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM59",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM60",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM61",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM62",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM63",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM64",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM65",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM66",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM67",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM68",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM69",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM70",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM71",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM72",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM73",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM74",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM75",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM76",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM77",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM78",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM79",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM80",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM81",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM82",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM83",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM84",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM85",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM86",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM87",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM88",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM89",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM90",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM91",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM92",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM93",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM94",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM95",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM96",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM97",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM98",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM99",0h
	db 04h DUP (00H)
	db 01h,0h,0h,0h
	db "COM100",0h
	db 03h DUP (00H)
	db 0h,0h,0h,0h
	align 04h
bWarp4	dd 01h
	dd	_dllentry
DATA32	ends
BSS32	segment
ulCOMiSignature	dd 0h
wDDmaxDeviceCount	dw 0h
	align 04h
bNoDEBUGhelp	dd 0h
bCOMiLoaded	dd 0h
bLimitLoad	dd 0h
bPDRinstalled	dd 0h
iPCIadapters	dd 0h
bPCImachine	dd 0h
bDeviceIniFileSelected	dd 0h
bSpoolSetupInUse	dd 0h
bInstallInUse	dd 0h
comm	szConfigHelpFile:byte:0104h
	align 04h
comm	hwndHelpInstance:dword
comm	szMessage:byte:0c8h
comm	szDriverIniPath:byte:0104h
comm	szPDRlibrarySpec:byte:0104h
	align 02h
comm	fIsMCAmachine:word
comm	szTempFilePath:byte:0104h
comm	szDriverVersionString:byte:064h
	align 04h
comm	ulDriverSignature:dword
comm	byDDOEMtype:byte
comm	szOEMname:byte:050h
	align 04h
comm	lYbutton:dword
	align 04h
comm	lXbutton:dword
	align 04h
comm	lXScr:dword
	align 04h
comm	lYScr:dword
comm	xSubFunction:byte
comm	astPCIadapters:byte:060h
comm	stOSversion:byte:0ch
	align 04h
comm	hThisModule:dword
BSS32	ends
CODE32	segment

; 123   {
	align 010h

	public _DLL_InitTerm
_DLL_InitTerm	proc
	push	ebp
	mov	ebp,esp

; 124   if (ulTermCode == 0)
	cmp	dword ptr [ebp+0ch],0h;	ulTermCode
	jne	@BLBL1

; 125     {
; 126 #ifndef __BORLANDC__
; 127     if (_CRT_init() == -1)
	call	_CRT_init
	cmp	eax,0ffffffffh
	jne	@BLBL2

; 128        return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL2:

; 129 #endif
; 130     hThisModule = hMod;
	mov	eax,[ebp+08h];	hMod
	mov	dword ptr  hThisModule,eax

; 131     bCOMiLoaded = GetDriverInfo();
	call	GetDriverInfo
	mov	dword ptr  bCOMiLoaded,eax

; 132     lXScr  = WinQuerySysValue(HWND_DESKTOP,SV_CXSCREEN);
	push	014h
	push	01h
	call	WinQuerySysValue
	add	esp,08h
	mov	dword ptr  lXScr,eax

; 133     if (lXScr > 640)
	cmp	dword ptr  lXScr,0280h
	jle	@BLBL3

; 134       if (lXScr > 800)
	cmp	dword ptr  lXScr,0320h
	jle	@BLBL4

; 135 //        if (lXScr > 1024)
; 136           if (lXScr > 1152)
	cmp	dword ptr  lXScr,0480h
	jle	@BLBL5

; 137             if (lXScr > 1280)
	cmp	dword ptr  lXScr,0500h
	jle	@BLBL6

; 138               lXbutton = (lXScr / 19);// 1600/1200
	mov	eax,dword ptr  lXScr
	mov	ecx,013h
	cdq	
	idiv	ecx
	mov	dword ptr  lXbutton,eax
	jmp	@BLBL10
	align 010h
@BLBL6:

; 139             else
; 140               lXbutton = (lXScr / 17);// 1280/1024
	mov	eax,dword ptr  lXScr
	mov	ecx,011h
	cdq	
	idiv	ecx
	mov	dword ptr  lXbutton,eax
	jmp	@BLBL10
	align 010h
@BLBL5:

; 141           else
; 142             lXbutton = (lXScr / 14);  // 1152/864
	mov	eax,dword ptr  lXScr
	mov	ecx,0eh
	cdq	
	idiv	ecx
	mov	dword ptr  lXbutton,eax
	jmp	@BLBL10
	align 010h
@BLBL4:

; 143         else
; 144           lXbutton = (lXScr / 12);    // 1024/768 and 800/600
	mov	eax,dword ptr  lXScr
	mov	ecx,0ch
	cdq	
	idiv	ecx
	mov	dword ptr  lXbutton,eax
	jmp	@BLBL10
	align 010h
@BLBL3:

; 145 //      else
; 146 //        lXbutton = (lXScr / 12);      // 800/600
; 147     else
; 148       lXbutton = (lXScr / 10);        // 640/480
	mov	eax,dword ptr  lXScr
	mov	ecx,0ah
	cdq	
	idiv	ecx
	mov	dword ptr  lXbutton,eax
@BLBL10:

; 149 
; 150     lYScr  = WinQuerySysValue(HWND_DESKTOP,SV_CYSCREEN);
	push	015h
	push	01h
	call	WinQuerySysValue
	add	esp,08h
	mov	dword ptr  lYScr,eax

; 151     if (lYScr > 480)
	cmp	dword ptr  lYScr,01e0h
	jle	@BLBL11

; 152       if (lYScr > 600)
	cmp	dword ptr  lYScr,0258h
	jle	@BLBL12

; 153 //        if (lYScr > 768)
; 154           if (lYScr > 864)
	cmp	dword ptr  lYScr,0360h
	jle	@BLBL13

; 155             if (lYScr > 1024)
	cmp	dword ptr  lYScr,0400h
	jle	@BLBL14

; 156               lYbutton = (lYScr / 16);// 1600/1200
	mov	eax,dword ptr  lYScr
	cdq	
	and	edx,0fh
	add	eax,edx
	sar	eax,04h
	mov	dword ptr  lYbutton,eax
	jmp	@BLBL18
	align 010h
@BLBL14:

; 157             else
; 158               lYbutton = (lYScr / 14);// 1280/1024
	mov	eax,dword ptr  lYScr
	mov	ecx,0eh
	cdq	
	idiv	ecx
	mov	dword ptr  lYbutton,eax
	jmp	@BLBL18
	align 010h
@BLBL13:

; 159           else
; 160             lYbutton = (lYScr / 11);  // 1152/864
	mov	eax,dword ptr  lYScr
	mov	ecx,0bh
	cdq	
	idiv	ecx
	mov	dword ptr  lYbutton,eax
	jmp	@BLBL18
	align 010h
@BLBL12:

; 161         else
; 162           lYbutton = (lYScr / 9);     // 1024/768 and 800/600
	mov	eax,dword ptr  lYScr
	mov	ecx,09h
	cdq	
	idiv	ecx
	mov	dword ptr  lYbutton,eax
	jmp	@BLBL18
	align 010h
@BLBL11:

; 163 //      else
; 164 //        lYbutton = (lYScr / 9);       // 800/600
; 165     else
; 166       lYbutton = (lYScr / 7);         // 640/480
	mov	eax,dword ptr  lYScr
	mov	ecx,07h
	cdq	
	idiv	ecx
	mov	dword ptr  lYbutton,eax
@BLBL18:

; 167 
; 168     if (PrfQueryProfileString(HINI_SYSTEMPROFILE,"PM_PORT_DRIVER","COMI_SPL",NULL,(PSZ)szPDRlibrarySpec,CCHMAXPATH) == 0)
	push	0104h
	push	offset FLAT:szPDRlibrarySpec
	push	0h
	push	offset FLAT:@STAT2
	push	offset FLAT:@STAT1
	push	0fffffffeh
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	jne	@BLBL1

; 169       PrfQueryProfileString(HINI_SYSTEMPROFILE,"PM_PORT_DRIVER","SPL_DEMO",NULL,(PSZ)szPDRlibrarySpec,CCHMAXPATH);
	push	0104h
	push	offset FLAT:szPDRlibrarySpec
	push	0h
	push	offset FLAT:@STAT4
	push	offset FLAT:@STAT3
	push	0fffffffeh
	call	PrfQueryProfileString
	add	esp,018h

; 170     }
@BLBL1:

; 171   bSpoolSetupInUse = FALSE;
	mov	dword ptr  bSpoolSetupInUse,0h

; 172   bInstallInUse = FALSE;
	mov	dword ptr  bInstallInUse,0h

; 173   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
_DLL_InitTerm	endp

; 177   {
	align 010h

	public GetPCIadapterInfo
GetPCIadapterInfo	proc
	push	ebp
	mov	ebp,esp
	sub	esp,014h
	push	eax
	push	edi
	mov	eax,0aaaaaaaah
	lea	edi,[esp+08h]
	stosd	
	stosd	
	stosd	
	stosd	
	stosd	
	pop	edi
	pop	eax

; 183   pstAdapter->xDevFuncNum = pstDevice->xDevFuncNum;
	mov	ecx,[ebp+010h];	pstDevice
	mov	cl,[ecx+02h]
	mov	eax,[ebp+0ch];	pstAdapter
	mov	[eax],cl

; 184   pstAdapter->xBusNum = pstDevice->xBusNum;
	mov	ecx,[ebp+010h];	pstDevice
	mov	cl,[ecx+01h]
	mov	eax,[ebp+0ch];	pstAdapter
	mov	[eax+01h],cl

; 185   pstAdapter->xIndex = (BYTE)iIndex;
	mov	ecx,[ebp+014h];	iIndex
	mov	eax,[ebp+0ch];	pstAdapter
	mov	[eax+02h],cl

; 186   stConfigParm.xSubFunc = OEMHLP_PCI_GET_DATA;
	mov	byte ptr [ebp-012h],03h;	stConfigParm

; 187   stConfigParm.xDevFuncNum = pstDevice->xDevFuncNum;
	mov	eax,[ebp+010h];	pstDevice
	mov	al,[eax+02h]
	mov	[ebp-010h],al;	stConfigParm

; 188   stConfigParm.xBusNum = pstDevice->xBusNum;
	mov	eax,[ebp+010h];	pstDevice
	mov	al,[eax+01h]
	mov	[ebp-011h],al;	stConfigParm

; 189   stConfigParm.xConfigReg = PCICFG_VEN_DEV_REG;
	mov	byte ptr [ebp-0fh],0h;	stConfigParm

; 190   stConfigParm.xSize = 4;
	mov	byte ptr [ebp-0eh],04h;	stConfigParm

; 191   // get device and vendor IDs
; 192   DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
	lea	eax,[ebp-04h];	ulDataLen
	push	eax
	push	05h
	lea	eax,[ebp-0dh];	stConfigData
	push	eax
	lea	eax,[ebp-08h];	ulParmLen
	push	eax
	push	05h
	lea	eax,[ebp-012h];	stConfigParm
	push	eax
	push	0bh
	push	080h
	push	dword ptr [ebp+08h];	hFile
	call	DosDevIOCtl
	add	esp,024h

; 193   if (stConfigData.xReturnCode != 0)
	cmp	byte ptr [ebp-0dh],0h;	stConfigData
	je	@BLBL20

; 194     return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL20:

; 195   pstAdapter->usVendorID = (USHORT)stConfigData.ulData;
	mov	ecx,[ebp-0ch];	stConfigData
	mov	eax,[ebp+0ch];	pstAdapter
	mov	[eax+04h],cx

; 196   pstAdapter->usDeviceID = (USHORT)(stConfigData.ulData >> 16);
	mov	ecx,[ebp-0ch];	stConfigData
	shr	ecx,010h
	mov	eax,[ebp+0ch];	pstAdapter
	mov	[eax+06h],cx

; 197   // get IRQ
; 198   stConfigParm.xConfigReg = PCICFG_IRQ_REG;
	mov	byte ptr [ebp-0fh],03ch;	stConfigParm

; 199   DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
	lea	eax,[ebp-04h];	ulDataLen
	push	eax
	push	05h
	lea	eax,[ebp-0dh];	stConfigData
	push	eax
	lea	eax,[ebp-08h];	ulParmLen
	push	eax
	push	05h
	lea	eax,[ebp-012h];	stConfigParm
	push	eax
	push	0bh
	push	080h
	push	dword ptr [ebp+08h];	hFile
	call	DosDevIOCtl
	add	esp,024h

; 200   pstAdapter->xIRQ = (BYTE)stConfigData.ulData;
	mov	ecx,[ebp-0ch];	stConfigData
	mov	eax,[ebp+0ch];	pstAdapter
	mov	[eax+03h],cl

; 201   stConfigParm.xConfigReg = PCICFG_BASEADDR_REG;
	mov	byte ptr [ebp-0fh],010h;	stConfigParm

; 202   // get base address 0 through 5
; 203   DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
	lea	eax,[ebp-04h];	ulDataLen
	push	eax
	push	05h
	lea	eax,[ebp-0dh];	stConfigData
	push	eax
	lea	eax,[ebp-08h];	ulParmLen
	push	eax
	push	05h
	lea	eax,[ebp-012h];	stConfigParm
	push	eax
	push	0bh
	push	080h
	push	dword ptr [ebp+08h];	hFile
	call	DosDevIOCtl
	add	esp,024h

; 204   pstAdapter->usBaseAddress0 = (USHORT)stConfigData.ulData;
	mov	ecx,[ebp-0ch];	stConfigData
	mov	eax,[ebp+0ch];	pstAdapter
	mov	[eax+0ch],cx

; 205   stConfigParm.xConfigReg 
; 205 += 4;
	mov	al,[ebp-0fh];	stConfigParm
	add	al,04h
	mov	[ebp-0fh],al;	stConfigParm

; 206   DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
	lea	eax,[ebp-04h];	ulDataLen
	push	eax
	push	05h
	lea	eax,[ebp-0dh];	stConfigData
	push	eax
	lea	eax,[ebp-08h];	ulParmLen
	push	eax
	push	05h
	lea	eax,[ebp-012h];	stConfigParm
	push	eax
	push	0bh
	push	080h
	push	dword ptr [ebp+08h];	hFile
	call	DosDevIOCtl
	add	esp,024h

; 207   pstAdapter->usBaseAddress1 = (USHORT)stConfigData.ulData;
	mov	ecx,[ebp-0ch];	stConfigData
	mov	eax,[ebp+0ch];	pstAdapter
	mov	[eax+0eh],cx

; 208   stConfigParm.xConfigReg += 4;
	mov	al,[ebp-0fh];	stConfigParm
	add	al,04h
	mov	[ebp-0fh],al;	stConfigParm

; 209   DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
	lea	eax,[ebp-04h];	ulDataLen
	push	eax
	push	05h
	lea	eax,[ebp-0dh];	stConfigData
	push	eax
	lea	eax,[ebp-08h];	ulParmLen
	push	eax
	push	05h
	lea	eax,[ebp-012h];	stConfigParm
	push	eax
	push	0bh
	push	080h
	push	dword ptr [ebp+08h];	hFile
	call	DosDevIOCtl
	add	esp,024h

; 210   pstAdapter->usBaseAddress2 = (USHORT)stConfigData.ulData;
	mov	ecx,[ebp-0ch];	stConfigData
	mov	eax,[ebp+0ch];	pstAdapter
	mov	[eax+010h],cx

; 211   stConfigParm.xConfigReg += 4;
	mov	al,[ebp-0fh];	stConfigParm
	add	al,04h
	mov	[ebp-0fh],al;	stConfigParm

; 212   DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
	lea	eax,[ebp-04h];	ulDataLen
	push	eax
	push	05h
	lea	eax,[ebp-0dh];	stConfigData
	push	eax
	lea	eax,[ebp-08h];	ulParmLen
	push	eax
	push	05h
	lea	eax,[ebp-012h];	stConfigParm
	push	eax
	push	0bh
	push	080h
	push	dword ptr [ebp+08h];	hFile
	call	DosDevIOCtl
	add	esp,024h

; 213   pstAdapter->usBaseAddress3 = (USHORT)stConfigData.ulData;
	mov	ecx,[ebp-0ch];	stConfigData
	mov	eax,[ebp+0ch];	pstAdapter
	mov	[eax+012h],cx

; 214   stConfigParm.xConfigReg += 4;
	mov	al,[ebp-0fh];	stConfigParm
	add	al,04h
	mov	[ebp-0fh],al;	stConfigParm

; 215   DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
	lea	eax,[ebp-04h];	ulDataLen
	push	eax
	push	05h
	lea	eax,[ebp-0dh];	stConfigData
	push	eax
	lea	eax,[ebp-08h];	ulParmLen
	push	eax
	push	05h
	lea	eax,[ebp-012h];	stConfigParm
	push	eax
	push	0bh
	push	080h
	push	dword ptr [ebp+08h];	hFile
	call	DosDevIOCtl
	add	esp,024h

; 216   pstAdapter->usBaseAddress4 = (USHORT)stConfigData.ulData;
	mov	ecx,[ebp-0ch];	stConfigData
	mov	eax,[ebp+0ch];	pstAdapter
	mov	[eax+014h],cx

; 217   stConfigParm.xConfigReg += 4;
	mov	al,[ebp-0fh];	stConfigParm
	add	al,04h
	mov	[ebp-0fh],al;	stConfigParm

; 218   DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stConfigParm,sizeof(PCIP_CONFIG),&ulParmLen,(PVOID)&stConfigData,sizeof(PCID_CONFIG),&ulDataLen);
	lea	eax,[ebp-04h];	ulDataLen
	push	eax
	push	05h
	lea	eax,[ebp-0dh];	stConfigData
	push	eax
	lea	eax,[ebp-08h];	ulParmLen
	push	eax
	push	05h
	lea	eax,[ebp-012h];	stConfigParm
	push	eax
	push	0bh
	push	080h
	push	dword ptr [ebp+08h];	hFile
	call	DosDevIOCtl
	add	esp,024h

; 219   pstAdapter->usBaseAddress5 = (USHORT)stConfigData.ulData;
	mov	ecx,[ebp-0ch];	stConfigData
	mov	eax,[ebp+0ch];	pstAdapter
	mov	[eax+016h],cx

; 220   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
GetPCIadapterInfo	endp

; 224   {
	align 010h

	public InstallDevice
InstallDevice	proc
	push	ebp
	mov	ebp,esp
	sub	esp,01e0h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,078h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 236   BOOL bSuccess = TRUE;
	mov	dword ptr [ebp-0168h],01h;	bSuccess

; 237 //  HWND hwndSaveHelp;
; 238   ULONG ulCount;
; 239   APIRET rc;
; 240   CFGHEAD stCFGheader;
; 241   DCBPOS stHeaderPos;
; 242   int iIndex;
; 243   ULONG ulTemp;
; 244   int iPCIindex;
; 245   int iClassCodeIndex;
; 246   BOOL bDone;
; 247 
; 248   PCID_BIOSINFO stBIOSinfo;
; 249   PCID_DEVICE stDeviceData;
; 250   PCIP_DEVICE stDeviceParm;
; 251   PCIP_CLASSCODE stClassCodeParm;
; 252 
; 253   if (bInstallInUse)
	cmp	dword ptr  bInstallInUse,0h
	je	@BLBL21

; 254     {
; 255     MessageBox(HWND_DESKTOP,"The COMi Configurartion Library Install Device function is currently being accessed by another process.\n\nTry again later.");
	push	offset FLAT:@STAT5
	push	01h
	call	MessageBox
	add	esp,08h

; 256     return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL21:

; 257     }
; 258   bInstallInUse = TRUE;
	mov	dword ptr  bInstallInUse,01h

; 259 #if DEBUG > 0
; 260   bNoDEBUGhelp = TRUE;
	mov	dword ptr  bNoDEBUGhelp,01h

; 261 #endif
; 262   HelpInit(pstCOMiCFG);
	push	dword ptr [ebp+08h];	pstCOMiCFG
	call	HelpInit
	add	esp,04h

; 263 
; 264   if (pstCOMiCFG->pszDriverIniSpec == NULL)
	mov	eax,[ebp+08h];	pstCOMiCFG
	cmp	dword ptr [eax+018h],0h
	jne	@BLBL22

; 265     {
; 266     if (szDriverIniPath[0] == 0)
	cmp	byte ptr  szDriverIniPath,0h
	jne	@BLBL28

; 267       {
; 268       if (PrfQueryProfileString(HINI_USERPROFILE,"COMi","Initialization",NULL,(PSZ)szDriverIniPath,CCHMAXPATH) == 0)
	push	0104h
	push	offset FLAT:szDriverIniPath
	push	0h
	push	offset FLAT:@STAT7
	push	offset FLAT:@STAT6
	push	0ffffffffh
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	jne	@BLBL28

; 269         {
; 270         sprintf(szMsgString,"\nYou will need to specify a device driver initialization path and file name.");
	mov	edx,offset FLAT:@STAT8
	lea	eax,[ebp-0cch];	szMsgString
	call	_sprintfieee

; 271         sprintf(szCaption,"Unknown Configuration File Name");
	mov	edx,offset FLAT:@STAT9
	lea	eax,[ebp-011ch];	szCaption
	call	_sprintfieee

; 272         WinMessageBox(HWND_DESKTOP,
	push	02030h
	push	075b2h
	lea	eax,[ebp-011ch];	szCaption
	push	eax
	lea	eax,[ebp-0cch];	szMsgString
	push	eax
	push	01h
	push	01h
	call	WinMessageBox
	add	esp,018h

; 273                       HWND_DESKTOP,
; 274                           szMsgString,
; 275                           szCaption,
; 276                           HLPP_MB_NO_INI_FILENAME,
; 277                           MB_OK | MB_HELP | MB_INFORMATION);
; 278         sprintf(szDriverIniPath,"COMDD.INI");
	mov	edx,offset FLAT:@STATa
	mov	eax,offset FLAT:szDriverIniPath
	call	_sprintfieee

; 279         if (!GetFileName(HWND_DESKTOP,szDriverIniPath,"Specify Initialization File to Create.",0))
	push	0h
	push	offset FLAT:@STATb
	push	offset FLAT:szDriverIniPath
	push	01h
	call	GetFileName
	add	esp,010h
	test	eax,eax
	jne	@BLBL25

; 280           {
; 281           if (pstCOMiCFG->pszPortName == NULL)
	mov	eax,[ebp+08h];	pstCOMiCFG
	cmp	dword ptr [eax+014h],0h
	jne	@BLBL26

; 282             sprintf(szMsgString,"Installation Has Been Aborted");
	mov	edx,offset FLAT:@STATc
	lea	eax,[ebp-0cch];	szMsgString
	call	_sprintfieee
	jmp	@BLBL27
	align 010h
@BLBL26:

; 283           else
; 284             sprintf(szMsgString,"Installation of %s Has Been Aborted",pstCOMiCFG->pszPortName);
	mov	eax,[ebp+08h];	pstCOMiCFG
	push	dword ptr [eax+014h]
	mov	edx,offset FLAT:@STATd
	lea	eax,[ebp-0cch];	szMsgString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
@BLBL27:

; 285           MessageBox(HWND_DESKTOP,szMsgString);
	lea	eax,[ebp-0cch];	szMsgString
	push	eax
	push	01h
	call	MessageBox
	add	esp,08h

; 286           DestroyHelpInstance(pstCOMiCFG);
	push	dword ptr [ebp+08h];	pstCOMiCFG
	call	DestroyHelpInstance
	add	esp,04h

; 287           bInstallInUse = FALSE;
	mov	dword ptr  bInstallInUse,0h

; 288           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL25:

; 289           }
; 290         strcpy(szTempFilePath,szDriverIniPath);
	mov	edx,offset FLAT:szDriverIniPath
	mov	eax,offset FLAT:szTempFilePath
	call	strcpy

; 291         AppendTMP(szTempFilePath);
	push	offset FLAT:szTempFilePath
	call	AppendTMP
	add	esp,04h

; 292         }

; 293       }

; 294     }
	jmp	@BLBL28
	align 010h
@BLBL22:

; 295   else
; 296     strcpy(szDriverIniPath,pstCOMiCFG->pszDriverIniSpec);
	mov	edx,[ebp+08h];	pstCOMiCFG
	mov	edx,[edx+018h]
	mov	eax,offset FLAT:szDriverIniPath
	call	strcpy
@BLBL28:

; 297 
; 298   DosQuerySysInfo(QSV_VERSION_MAJOR,QSV_VERSION_REVISION,&stOSversion,sizeof(OSVER));
	push	0ch
	push	offset FLAT:stOSversion
	push	0dh
	push	0bh
	call	DosQuerySysInfo
	add	esp,010h

; 299   if ((stOSversion.ulMajor < 20) || (stOSversion.ulMinor <= 30))
	cmp	dword ptr  stOSversion,014h
	jb	@BLBL29
	cmp	dword ptr  stOSversion+04h,01eh
	ja	@BLBL30
@BLBL29:

; 300     bWarp4 = FALSE;
	mov	dword ptr  bWarp4,0h
@BLBL30:

; 301 
; 302 #if DEBUG > 0
; 303 sprintf(szMsgString,"Version is %d.%d", stOSversion.ulMajor, stOSversion.ulMinor);
	push	dword ptr  stOSversion+04h
	push	dword ptr  stOSversion
	mov	edx,offset FLAT:@STATe
	lea	eax,[ebp-0cch];	szMsgString
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 304 MessageBox(HWND_DESKTOP, szMsgString);
	lea	eax,[ebp-0cch];	szMsgString
	push	eax
	push	01h
	call	MessageBox
	add	esp,08h

; 305 #endif
; 306 
; 307 //  if (bWarp4)
; 308     {
; 309     if (DosOpen("OEMHLP$",&hFile,&ulAction,0L,0L,0x0001,0x21c2,0L) == NO_ERROR)
	push	0h
	push	021c2h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-0154h];	ulAction
	push	eax
	lea	eax,[ebp-0120h];	hFile
	push	eax
	push	offset FLAT:@STATf
	call	DosOpen
	add	esp,020h
	test	eax,eax
	jne	@BLBL31

; 310       {
; 311       ulTemp = OEMHLP_GET_PCI_BIOS_INFO;
	mov	dword ptr [ebp-01bch],0h;	ulTemp

; 312       if ((DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&ulTemp,1,&ulParmLen,(PVOID)&stBIOSinfo,sizeof(PCID_BIOSINFO),&ulDataLen) == NO_ERROR) &&
	lea	eax,[ebp-0158h];	ulDataLen
	push	eax
	push	05h
	lea	eax,[ebp-01cdh];	stBIOSinfo
	push	eax
	lea	eax,[ebp-015ch];	ulParmLen
	push	eax
	push	01h
	lea	eax,[ebp-01bch];	ulTemp
	push	eax
	push	0bh
	push	080h
	push	dword ptr [ebp-0120h];	hFile
	call	DosDevIOCtl
	add	esp,024h
	test	eax,eax
	jne	@BLBL32

; 313           (stBIOSinfo.xReturnCode == 0))
	cmp	byte ptr [ebp-01cdh],0h;	stBIOSinfo
	jne	@BLBL32

; 314         {
; 315         bPCImachine = TRUE;
	mov	dword ptr  bPCImachine,01h

; 316         if (bWarp4)
	cmp	dword ptr  bWarp4,0h
	je	@BLBL32

; 317           {
; 318           stClassCodeParm.xSubFunc = OEMHLP_PCI_CLASSCODE;
	mov	byte ptr [ebp-01dch],02h;	stClassCodeParm

; 319           iClassCodeIndex = 0;
	mov	dword ptr [ebp-01c4h],0h;	iClassCodeIndex

; 320           bDone = FALSE;
	mov	dword ptr [ebp-01c8h],0h;	bDone

; 321           while ((adwClassCodeTable[iClassCodeIndex] != 0) && !bDone)
	mov	eax,[ebp-01c4h];	iClassCodeIndex
	cmp	dword ptr [eax*04h+adwClassCodeTable],0h
	je	@BLBL32
	cmp	dword ptr [ebp-01c8h],0h;	bDone
	jne	@BLBL32
	align 010h
@BLBL37:

; 322             {
; 323             stClassCodeParm.ulClassCode = adwClassCodeTable[iClassCodeIndex];
	mov	eax,[ebp-01c4h];	iClassCodeIndex
	mov	eax,dword ptr [eax*04h+adwClassCodeTable]
	mov	[ebp-01dbh],eax;	stClassCodeParm

; 324             for (iPCIindex = 0;iPCIindex < MAX_PCI_ADAPTERS; iPCIindex++)
	mov	dword ptr [ebp-01c0h],0h;	iPCIindex
	cmp	dword ptr [ebp-01c0h],04h;	iPCIindex
	jge	@BLBL38
	align 010h
@BLBL39:

; 325               {
; 326               stClassCodeParm.xIndex = (BYTE)iPCIindex;
	mov	eax,[ebp-01c0h];	iPCIindex
	mov	[ebp-01d7h],al;	stClassCodeParm

; 327               if ((DosDevIOCtl(hFile,0x80,0x0b,(PVOID)&stClassCodeParm,sizeof(PCIP_CLASSCODE),&ulParmLen,(PVOID)&stDeviceData,sizeof(PCID_DEVICE),&ulDataLen) != NO_ERROR) ||
	lea	eax,[ebp-0158h];	ulDataLen
	push	eax
	push	03h
	lea	eax,[ebp-01d0h];	stDeviceData
	push	eax
	lea	eax,[ebp-015ch];	ulParmLen
	push	eax
	push	06h
	lea	eax,[ebp-01dch];	stClassCodeParm
	push	eax
	push	0bh
	push	080h
	push	dword ptr [ebp-0120h];	hFile
	call	DosDevIOCtl
	add	esp,024h
	test	eax,eax
	jne	@BLBL38

; 328                   (stDeviceData.xReturnCode != 0))
	cmp	byte ptr [ebp-01d0h],0h;	stDeviceData
	jne	@BLBL38

; 329                 break;
; 330               if (!GetPCIadapterInfo(hFile,&astPCIadapters[iPCIadapters],&stDeviceData,iPCIindex))
	push	dword ptr [ebp-01c0h];	iPCIindex
	lea	eax,[ebp-01d0h];	stDeviceData
	push	eax
	mov	eax,dword ptr  iPCIadapters
	imul	eax,018h
	add	eax,offset FLAT:astPCIadapters
	push	eax
	push	dword ptr [ebp-0120h];	hFile
	call	GetPCIadapterInfo
	add	esp,010h
	test	eax,eax
	jne	@BLBL43

; 331                 {
; 332                 bDone = TRUE;
	mov	dword ptr [ebp-01c8h],01h;	bDone

; 333                 break;
	jmp	@BLBL38
	align 010h
@BLBL43:

; 334                 }
; 335               if (++iPCIadapters == MAX_PCI_ADAPTERS)
	mov	eax,dword ptr  iPCIadapters
	inc	eax
	mov	dword ptr  iPCIadapters,eax
	cmp	dword ptr  iPCIadapters,04h
	jne	@BLBL44

; 336                 {
; 337                 bDone = TRUE;
	mov	dword ptr [ebp-01c8h],01h;	bDone

; 338                 break;
	jmp	@BLBL38
	align 010h
@BLBL44:

; 339                 }
; 340               }

; 324             for (iPCIindex = 0;iPCIindex < MAX_PCI_ADAPTERS; iPCIindex++)
	mov	eax,[ebp-01c0h];	iPCIindex
	inc	eax
	mov	[ebp-01c0h],eax;	iPCIindex
	cmp	dword ptr [ebp-01c0h],04h;	iPCIindex
	jl	@BLBL39
@BLBL38:

; 341             iClassCodeIndex++;
	mov	eax,[ebp-01c4h];	iClassCodeIndex
	inc	eax
	mov	[ebp-01c4h],eax;	iClassCodeIndex

; 342             }

; 321           while ((adwClassCodeTable[iClassCodeIndex] != 0) && !bDone)
	mov	eax,[ebp-01c4h];	iClassCodeIndex
	cmp	dword ptr [eax*04h+adwClassCodeTable],0h
	je	@BLBL32
	cmp	dword ptr [ebp-01c8h],0h;	bDone
	je	@BLBL37

; 343           }

; 344         }
@BLBL32:

; 345       DosClose(hFile);
	push	dword ptr [ebp-0120h];	hFile
	call	DosClose
	add	esp,04h

; 346       }
@BLBL31:

; 347     }

; 349   fIsMCAmachine = NO;
	mov	word ptr  fIsMCAmachine,0h

; 350   if (!bPCImachine)
	cmp	dword ptr  bPCImachine,0h
	jne	@BLBL47

; 352     if (DosOpen("TESTCFG$",&hFile,&ulAction,0L,0L,0x0001,0x21c2,0L) == NO_ERROR)
	push	0h
	push	021c2h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-0154h];	ulAction
	push	eax
	lea	eax,[ebp-0120h];	hFile
	push	eax
	push	offset FLAT:@STAT10
	call	DosOpen
	add	esp,020h
	test	eax,eax
	jne	@BLBL48

; 354       ulAction = 0;
	mov	dword ptr [ebp-0154h],0h;	ulAction

; 355       ulDataLen = 4L;
	mov	dword ptr [ebp-0158h],04h;	ulDataLen

; 356       ulParmLen = 4L;
	mov	dword ptr [ebp-015ch],04h;	ulParmLen

; 357       if (DosDevIOCtl(hFile,0x80,0x60,(PVOID)&ulAction,ulParmLen,&ulParmLen,(PVOID)&ulAction,ulDataLen,&ulDataLen) == NO_ERROR)
	lea	eax,[ebp-0158h];	ulDataLen
	push	eax
	push	dword ptr [ebp-0158h];	ulDataLen
	lea	eax,[ebp-0154h];	ulAction
	push	eax
	lea	eax,[ebp-015ch];	ulParmLen
	push	eax
	push	dword ptr [ebp-015ch];	ulParmLen
	lea	eax,[ebp-0154h];	ulAction
	push	eax
	push	060h
	push	080h
	push	dword ptr [ebp-0120h];	hFile
	call	DosDevIOCtl
	add	esp,024h
	test	eax,eax
	jne	@BLBL49

; 359         if (ulAction == 1)
	cmp	dword ptr [ebp-0154h],01h;	ulAction
	jne	@BLBL51

; 360           fIsMCAmachine = YES;
	mov	word ptr  fIsMCAmachine,01h

; 361         }
	jmp	@BLBL51
	align 010h
@BLBL49:

; 363         fIsMCAmachine = 0xffff;
	mov	word ptr  fIsMCAmachine,0ffffh
@BLBL51:

; 364       DosClose(hFile);
	push	dword ptr [ebp-0120h];	hFile
	call	DosClose
	add	esp,04h

; 365       }
	jmp	@BLBL52
	align 010h
@BLBL48:

; 367       fIsMCAmachine = 0xffff;
	mov	word ptr  fIsMCAmachine,0ffffh
@BLBL52:

; 368     if (fIsMCAmachine == 0xffff)
	cmp	word ptr  fIsMCAmachine,0ffffh
	jne	@BLBL47

; 370       fIsMCAmachine = NO;
	mov	word ptr  fIsMCAmachine,0h

; 371       sprintf(szCaption,"Unable to open or access TESTCFG");
	mov	edx,offset FLAT:@STAT11
	lea	eax,[ebp-011ch];	szCaption
	call	_sprintfieee

; 372       sprintf(szMsgString,"Is this a Micro Channel machine (IBM PS/2 or compatable)?");
	mov	edx,offset FLAT:@STAT12
	lea	eax,[ebp-0cch];	szMsgString
	call	_sprintfieee

; 373       if (WinMessageBox(HWND_DESKTOP,
	push	06114h
	push	075b1h
	lea	eax,[ebp-011ch];	szCaption
	push	eax
	lea	eax,[ebp-0cch];	szMsgString
	push	eax
	push	01h
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,06h
	jne	@BLBL47

; 380         fIsMCAmachine = YES;
	mov	word ptr  fIsMCAmachine,01h

; 381       }

; 382     }
@BLBL47:

; 383   if (strlen(szDriverIniPath) == 0)
	mov	eax,offset FLAT:szDriverIniPath
	call	strlen
	test	eax,eax
	jne	@BLBL55

; 385     MessageBox(HWND_DESKTOP,"Invalid device driver initialization file specification");
	push	offset FLAT:@STAT13
	push	01h
	call	MessageBox
	add	esp,08h

; 386     bSuccess = FALSE;
	mov	dword ptr [ebp-0168h],0h;	bSuccess

; 387     }
	jmp	@BLBL56
	align 010h
@BLBL55:

; 390     stDCBposition.wDCBnumber = 0;
	mov	word ptr [ebp-014eh],0h;	stDCBposition

; 391     stDCBposition.wLoadNumber = 0;
	mov	word ptr [ebp-0150h],0h;	stDCBposition

; 392     while (DosOpen(szDriverIniPath,&hFile,&ulStatus,0L,0,0x0001,0x1312,(PEAOP2)0L) != NO_ERROR)
	push	0h
	push	01312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-04h];	ulStatus
	push	eax
	lea	eax,[ebp-0120h];	hFile
	push	eax
	push	offset FLAT:szDriverIniPath
	call	DosOpen
	add	esp,020h
	test	eax,eax
	je	@BLBL57
	align 010h
@BLBL58:

; 394       if (AddIniConfigHeader(szDriverIniPath,&stDCBposition) == 0)
	lea	eax,[ebp-0150h];	stDCBposition
	push	eax
	push	offset FLAT:szDriverIniPath
	call	AddIniConfigHeader
	add	esp,08h
	test	eax,eax
	jne	@BLBL59

; 396         DestroyHelpInstance(pstCOMiCFG);
	push	dword ptr [ebp+08h];	pstCOMiCFG
	call	DestroyHelpInstance
	add	esp,04h

; 397         bInstallInUse = FALSE;
	mov	dword ptr  bInstallInUse,0h

; 398         return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL59:

; 400       }

; 392     while (DosOpen(szDriverIniPath,&hFile,&ulStatus,0L,0,0x0001,0x1312,(PEAOP2)0L) != NO_ERROR)
	push	0h
	push	01312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-04h];	ulStatus
	push	eax
	lea	eax,[ebp-0120h];	hFile
	push	eax
	push	offset FLAT:szDriverIniPath
	call	DosOpen
	add	esp,020h
	test	eax,eax
	jne	@BLBL58
@BLBL57:

; 401     if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == NO_ERROR)
	lea	eax,[ebp-016ch];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-014ch];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0120h];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL61

; 403       DosClose(hFile);
	push	dword ptr [ebp-0120h];	hFile
	call	DosClose
	add	esp,04h

; 404       if (stConfigInfo.ulSignature != INI_FILE_SIGNATURE)
	cmp	dword ptr [ebp-014ch],019841835h;	stConfigInfo
	je	@BLBL64

; 406         DosDelete(szDriverIniPath);
	push	offset FLAT:szDriverIniPath
	call	DosDelete
	add	esp,04h

; 407         if (AddIniConfigHeader(szDriverIniPath,&stDCBposition) == 0)
	lea	eax,[ebp-0150h];	stDCBposition
	push	eax
	push	offset FLAT:szDriverIniPath
	call	AddIniConfigHeader
	add	esp,08h
	test	eax,eax
	jne	@BLBL64

; 409           DestroyHelpInstance(pstCOMiCFG);
	push	dword ptr [ebp+08h];	pstCOMiCFG
	call	DestroyHelpInstance
	add	esp,04h

; 410           bInstallInUse = FALSE;
	mov	dword ptr  bInstallInUse,0h

; 411           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL61:

; 417       DosClose(hFile);
	push	dword ptr [ebp-0120h];	hFile
	call	DosClose
	add	esp,04h

; 418       DosDelete(szDriverIniPath);
	push	offset FLAT:szDriverIniPath
	call	DosDelete
	add	esp,04h

; 419       if (AddIniConfigHeader(szDriverIniPath,&stDCBposition) == 0)
	lea	eax,[ebp-0150h];	stDCBposition
	push	eax
	push	offset FLAT:szDriverIniPath
	call	AddIniConfigHeader
	add	esp,08h
	test	eax,eax
	jne	@BLBL64

; 421         DestroyHelpInstance(pstCOMiCFG);
	push	dword ptr [ebp+08h];	pstCOMiCFG
	call	DestroyHelpInstance
	add	esp,04h

; 422         bInstallInUse = FALSE;
	mov	dword ptr  bInstallInUse,0h

; 423         return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL64:

; 426     DosCopy(szDriverIniPath,szTempFilePath,0x00000001);
	push	01h
	push	offset FLAT:szTempFilePath
	push	offset FLAT:szDriverIniPath
	call	DosCopy
	add	esp,0ch

; 428     lXScr = WinQuerySysValue(HWND_DESKTOP,SV_CXSCREEN);
	push	014h
	push	01h
	call	WinQuerySysValue
	add	esp,08h
	mov	dword ptr  lXScr,eax

; 430     if (wDDmaxDeviceCount != 0)
	cmp	word ptr  wDDmaxDeviceCount,0h
	je	@BLBL66

; 431       pstCOMiCFG->ulMaxDeviceCount = wDDmaxDeviceCount;
	xor	ecx,ecx
	mov	cx,word ptr  wDDmaxDeviceCount
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	[eax+025h],ecx
@BLBL66:

; 432     stHeaderPos.wLoadNumber = 1;
	mov	word ptr [ebp-01b2h],01h;	stHeaderPos

; 433     if (QueryIniCFGheader(szDriverIniPath,&stCFGheader,&stHeaderPos))
	lea	eax,[ebp-01b2h];	stHeaderPos
	push	eax
	lea	eax,[ebp-01aeh];	stCFGheader
	push	eax
	push	offset FLAT:szDriverIniPath
	call	QueryIniCFGheader
	add	esp,0ch
	test	eax,eax
	je	@BLBL67

; 434       memcpy(&stGlobalCFGheader,&stCFGheader,sizeof(CFGHEAD));
	mov	ecx,03eh
	lea	edx,[ebp-01aeh];	stCFGheader
	mov	eax,offset FLAT:stGlobalCFGheader
	call	memcpy
	jmp	@BLBL68
	align 010h
@BLBL67:

; 436       if (AddIniConfigHeader(szDriverIniP
; 436 ath,&stHeaderPos) == 0)
	lea	eax,[ebp-01b2h];	stHeaderPos
	push	eax
	push	offset FLAT:szDriverIniPath
	call	AddIniConfigHeader
	add	esp,08h
	test	eax,eax
	jne	@BLBL68

; 438         DestroyHelpInstance(pstCOMiCFG);
	push	dword ptr [ebp+08h];	pstCOMiCFG
	call	DestroyHelpInstance
	add	esp,04h

; 439         bInstallInUse = FALSE;
	mov	dword ptr  bInstallInUse,0h

; 440         return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL68:

; 442     if (stCFGheader.byAdapterType == HDWTYPE_PCI)
	cmp	byte ptr [ebp-01a4h],09h;	stCFGheader
	jne	@BLBL70

; 443       pstCOMiCFG->bPCIadapter = TRUE;
	mov	eax,[ebp+08h];	pstCOMiCFG
	or	byte ptr [eax+04bh],080h
	jmp	@BLBL71
	align 010h
@BLBL70:

; 445       pstCOMiCFG->bPCIadapter = FALSE;
	mov	eax,[ebp+08h];	pstCOMiCFG
	and	byte ptr [eax+04bh],07fh
@BLBL71:

; 446     if (((stCFGheader.wLoadFlags & LOAD_FLAG1_ADVANCED_CFG) == 0) || (stCFGheader.wDeviceCount == 0))
	test	byte ptr [ebp-019bh],08h;	stCFGheader
	je	@BLBL72
	cmp	word ptr [ebp-01aeh],0h;	stCFGheader
	jne	@BLBL73
@BLBL72:

; 448       pfnwpDlgProc = fnwpPortSimpleDlgProc;
	mov	dword ptr [ebp-0164h],offset FLAT: fnwpPortSimpleDlgProc;	pfnwpDlgProc

; 449       if (fIsMCAmachine)
	cmp	word ptr  fIsMCAmachine,0h
	je	@BLBL74

; 450         idDlg = MCA_SIMPLE_DLG;
	mov	dword ptr [ebp-0160h],01784h;	idDlg
	jmp	@BLBL78
	align 010h
@BLBL74:

; 452         if (bPCImachine)
	cmp	dword ptr  bPCImachine,0h
	je	@BLBL76

; 453           idDlg = DLG_SIMPLIFIEDDEV;
	mov	dword ptr [ebp-0160h],02cd6h;	idDlg
	jmp	@BLBL78
	align 010h
@BLBL76:

; 455           idDlg = ISA_SIMPLE_DLG;
	mov	dword ptr [ebp-0160h],01770h;	idDlg

; 456       }
	jmp	@BLBL78
	align 010h
@BLBL73:

; 459       pfnwpDlgProc = fnwpPortConfigDlgProc;
	mov	dword ptr [ebp-0164h],offset FLAT: fnwpPortConfigDlgProc;	pfnwpDlgProc

; 460       if (pstCOMiCFG->byOEMtype != OEM_OTHER)
	mov	eax,[ebp+08h];	pstCOMiCFG
	cmp	byte ptr [eax+024h],0h
	je	@BLBL79

; 461         idDlg = DLG_ADVANCEDOEM;
	mov	dword ptr [ebp-0160h],02cdbh;	idDlg
	jmp	@BLBL78
	align 010h
@BLBL79:

; 463         if (fIsMCAmachine)
	cmp	word ptr  fIsMCAmachine,0h
	je	@BLBL81

; 464           idDlg = PCFG_MAIN_MCA;
	mov	dword ptr [ebp-0160h],01205h;	idDlg
	jmp	@BLBL78
	align 010h
@BLBL81:

; 466           idDlg = PCFG_MAIN;
	mov	dword ptr [ebp-0160h],012c9h;	idDlg

; 467       }
@BLBL78:

; 468     if (pstCOMiCFG->byOEMtype != 0)
	mov	eax,[ebp+08h];	pstCOMiCFG
	cmp	byte ptr [eax+024h],0h
	je	@BLBL83

; 469       byDDOEMtype = pstCOMiCFG->byOEMtype;
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	al,[eax+024h]
	mov	byte ptr  byDDOEMtype,al
@BLBL83:

; 471     if ((rc = WinDlgBox(HWND_DESKTOP,
	push	dword ptr [ebp+08h];	pstCOMiCFG
	push	dword ptr [ebp-0160h];	idDlg
	push	dword ptr  hThisModule
	push	dword ptr [ebp-0164h];	pfnwpDlgProc
	mov	eax,[ebp+08h];	pstCOMiCFG
	push	dword ptr [eax+06h]
	push	01h
	call	WinDlgBox
	add	esp,018h
	mov	[ebp-0170h],eax;	rc
	cmp	dword ptr [ebp-0170h],0h;	rc
	jne	@BLBL84

; 478       DosCopy(szTempFilePath,szDriverIniPath,0x00000001);
	push	01h
	push	offset FLAT:szDriverIniPath
	push	offset FLAT:szTempFilePath
	call	DosCopy
	add	esp,0ch

; 479       bSuccess = FALSE;
	mov	dword ptr [ebp-0168h],0h;	bSuccess

; 480       }
@BLBL84:

; 482     if (rc == DID_ERROR)
	cmp	dword ptr [ebp-0170h],0ffffh;	rc
	jne	@BLBL56

; 486       idErr = WinGetLastError(pstCOMiCFG->hab);
	mov	eax,[ebp+08h];	pstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinGetLastError
	add	esp,04h
	mov	[ebp-01e0h],eax;	idErr

; 487       }

; 489     }
@BLBL56:

; 490   DosDelete(szTempFilePath);
	push	offset FLAT:szTempFilePath
	call	DosDelete
	add	esp,04h

; 491   DestroyHelpInstance(pstCOMiCFG);
	push	dword ptr [ebp+08h];	pstCOMiCFG
	call	DestroyHelpInstance
	add	esp,04h

; 492   bInstallInUse = FALSE;
	mov	dword ptr  bInstallInUse,0h

; 493   return(bSuccess);
	mov	eax,[ebp-0168h];	bSuccess
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
InstallDevice	endp

; 497   {
	align 010h

	public InitializeCFGheader
InitializeCFGheader	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch

; 498   memset(pstConfigHeader, 0, sizeof(CFGHEAD));
	mov	ecx,03eh
	xor	edx,edx
	mov	eax,[ebp+08h];	pstConfigHeader
	call	memset

; 499   pstConfigHeader->bHeaderIsInitialized = TRUE;
	mov	eax,[ebp+08h];	pstConfigHeader
	mov	word ptr [eax+018h],01h

; 500   pstConfigHeader->bHeaderIsAvailable = FALSE;
	mov	eax,[ebp+08h];	pstConfigHeader
	mov	word ptr [eax+016h],0h

; 501   pstConfigHeader->wDCBcount = 8;
	mov	eax,[ebp+08h];	pstConfigHeader
	mov	word ptr [eax+02h],08h

; 502   pstConfigHeader->byAdapterType = HDWTYPE_NONE;
	mov	eax,[ebp+08h];	pstConfigHeader
	mov	byte ptr [eax+0ah],0h

; 503   }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
InitializeCFGheader	endp

; 506   {
	align 010h

	public InitializeDCBheader
InitializeDCBheader	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah
	sub	esp,0ch

; 508   memset(&pstDCBheader->stComDCB,0,sizeof(COMDCB));
	mov	ecx,02ah
	xor	edx,edx
	mov	eax,[ebp+08h];	pstDCBheader
	add	eax,010h
	call	memset

; 509   pstDCBheader->stComDCB.byXonChar = '\x11';
	mov	eax,[ebp+08h];	pstDCBheader
	mov	byte ptr [eax+034h],011h

; 510   pstDCBheader->stComDCB.byXoffChar = '\x13';
	mov	eax,[ebp+08h];	pstDCBheader
	mov	byte ptr [eax+035h],013h

; 511   pstDCBheader->stComDCB.wWrtTimeout = 6000;
	mov	eax,[ebp+08h];	pstDCBheader
	mov	word ptr [eax+024h],01770h

; 512   pstDCBheader->stComDCB.wRdTimeout = 4500;
	mov	eax,[ebp+08h];	pstDCBheader
	mov	word ptr [eax+026h],01194h

; 513   pstDCBheader->stComDCB.wFlags1 = (0x8000 | F1_DEFAULT);
	mov	eax,[ebp+08h];	pstDCBheader
	mov	word ptr [eax+01eh],08001h

; 514   pstDCBheader->stComDCB.wFlags2 = (0x8000 | F2_DEFAULT);
	mov	eax,[ebp+08h];	pstDCBheader
	mov	word ptr [eax+020h],08040h

; 515   pstDCBheader->stComDCB.wFlags3 = (0x8000 | F3_DEFAULT);
	mov	eax,[ebp+08h];	pstDCBheader
	mov	word ptr [eax+022h],080f2h

; 516   pstDCBheader->stComDCB.ulBaudRate = 9600;
	mov	eax,[ebp+08h];	pstDCBheader
	mov	dword ptr [eax+028h],02580h

; 517   pstDCBheader->stComDCB.byLineCharacteristics = '\x03';
	mov	eax,[ebp+08h];	pstDCBheader
	mov	byte ptr [eax+031h],03h

; 518   if (bInstallCOMscope)
	cmp	dword ptr [ebp+0ch],0h;	bInstallCOMscope
	je	@BLBL86

; 519     pstDCBheader->stComDCB.wConfigFlags1 |= CFG_FLAG1_COMSCOPE;
	mov	eax,[ebp+08h];	pstDCBheader
	mov	[ebp-04h],eax;	@CBE33
	mov	eax,[ebp-04h];	@CBE33
	mov	cx,[eax+010h]
	or	cl,040h
	mov	[eax+010h],cx
	jmp	@BLBL87
	align 010h
@BLBL86:

; 520   else
; 521     pstDCBheader->stComDCB.wConfigFlags1 = 0;
	mov	eax,[ebp+08h];	pstDCBheader
	mov	word ptr [eax+010h],0h
@BLBL87:

; 522   pstDCBheader->stComDCB.wConfigFlags2 = 0;
	mov	eax,[ebp+08h];	pstDCBheader
	mov	word ptr [eax+012h],0h

; 523   memset(pstDCBheader->abyPortName,' ',8);
	mov	ecx,08h
	mov	edx,020h
	mov	eax,[ebp+08h];	pstDCBheader
	call	memset

; 524   pstDCBheader->bHeaderIsInitialized = FALSE;
	mov	eax,[ebp+08h];	pstDCBheader
	mov	word ptr [eax+08h],0h

; 525   }
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
InitializeDCBheader	endp

; 528   {
	align 010h

	public AddIniConfigHeader
AddIniConfigHeader	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0148h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,052h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 542   BOOL bEarlyHeader = FALSE;
	mov	dword ptr [ebp-0e0h],0h;	bEarlyHeader

; 543   BOOL bInitializeInfoHeader = FALSE;
	mov	dword ptr [ebp-0e4h],0h;	bInitializeInfoHeader

; 544   char szMessage[100];
; 545 
; 546   if (DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,0x11,0x1312,(PEAOP2)0L) == NO_ERROR)
	push	0h
	push	01312h
	push	011h
	push	0h
	push	0h
	lea	eax,[ebp-04h];	ulStatus
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosOpen
	add	esp,020h
	test	eax,eax
	jne	@BLBL88

; 547     {
; 548     DosQueryFileInfo(hFile,1,&stFileInfo,sizeof(FILESTATUS3));
	push	018h
	lea	eax,[ebp-038h];	stFileInfo
	push	eax
	push	01h
	push	dword ptr [ebp-08h];	hFile
	call	DosQueryFileInfo
	add	esp,010h

; 549     if (stFileInfo.cbFile < (sizeof(CFGINFO) + sizeof(CFGHEAD) + (sizeof(DCBHEAD) * 8)))
	cmp	dword ptr [ebp-02ch],023ah;	stFileInfo
	jae	@BLBL89

; 550       bInitializeInfoHeader = TRUE;
	mov	dword ptr [ebp-0e4h],01h;	bInitializeInfoHeader
	jmp	@BLBL90
	align 010h
@BLBL89:

; 551     else
; 552       {
; 553       DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount);
	lea	eax,[ebp-010h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-064h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h

; 554       if (stConfigInfo.ulSignature != INI_FILE_SIGNATURE)
	cmp	dword ptr [ebp-064h],019841835h;	stConfigInfo
	je	@BLBL90

; 555         bInitializeInfoHeader = TRUE;
	mov	dword ptr [ebp-0e4h],01h;	bInitializeInfoHeader

; 556       }
@BLBL90:

; 557     if (bInitializeInfoHeader)
	cmp	dword ptr [ebp-0e4h],0h;	bInitializeInfoHeader
	je	@BLBL92

; 558       {
; 559       memset(&stConfigInfo,0,sizeof(CFGINFO));
	mov	ecx,02ch
	xor	edx,edx
	lea	eax,[ebp-064h];	stConfigInfo
	call	memset

; 560       stConfigInfo.byOEMtype = OEM_OTHER;
	mov	byte ptr [ebp-057h],0h;	stConfigInfo

; 561       stConfigInfo.byNextPCIslot = 0;
	mov	byte ptr [ebp-058h],0h;	stConfigInfo

; 562       stConfigInfo.wCFGheaderCount = 1;
	mov	word ptr [ebp-05eh],01h;	stConfigInfo

; 563       stConfigInfo.oFirstCFGheader = sizeof(CFGINFO);
	mov	word ptr [ebp-05ch],02ch;	stConfigInfo

; 564       stConfigInfo.oCOMscopeIniOffset = 0;
	mov	word ptr [ebp-05ah],0h;	stConfigInfo

; 565       stConfigInfo.ulSignature = INI_FILE_SIGNATURE;
	mov	dword ptr [ebp-064h],019841835h;	stConfigInfo

; 566       InitializeCFGheader(&stConfigHeader);
	lea	eax,[ebp-0a2h];	stConfigHeader
	push	eax
	call	InitializeCFGheader
	add	esp,04h

; 567       stConfigHeader.oFirstDCBheader = (sizeof(CFGINFO) + sizeof(CFGHEAD));
	mov	word ptr [ebp-086h],06ah;	stConfigHeader

; 568       stConfigHeader.oNextCFGheader = (stConfigHeader.oFirstDCBheader + (sizeof(DCBHEAD) * MAX_CFG_DEVICE));
	mov	ax,[ebp-086h];	stConfigHeader
	add	ax,03a0h
	mov	[ebp-088h],ax;	stConfigHeader

; 569       ulSaveConfigHeaderPosition = sizeof(CFGINFO);
	mov	dword ptr [ebp-020h],02ch;	ulSaveConfigHeaderPosition

; 570       }
	jmp	@BLBL93
	align 010h
@BLBL92:

; 571     else
; 572       {
; 573       DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-01ch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-05ch];	stConfigInfo
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 574       if (stConfigInfo.wCFGheaderCount == 0)
	cmp	word ptr [ebp-05eh],0h;	stConfigInfo
	jne	@BLBL94

; 575         {
; 576         stConfigHeader.oFirstDCBheader = (sizeof(CFGINFO) + sizeof(CFGHEAD));
	mov	word ptr [ebp-086h],06ah;	stConfigHeader

; 577         stConfigHeader.oNextCFGheader = (stConfigHeader.oFirstDCBheader + (sizeof(DCBHEAD) * MAX_CFG_DEVICE));
	mov	ax,[ebp-086h];	stConfigHeader
	add	ax,03a0h
	mov	[ebp-088h],ax;	stConfigHeader

; 578         ulSaveConfigHeaderPosition = sizeof(CFGHEAD);
	mov	dword ptr [ebp-020h],03eh;	ulSaveConfigHeaderPosition

; 579         }
	jmp	@BLBL95
	align 010h
@BLBL94:

; 580       else
; 581         {
; 582         for (iIndex = 1;iIndex <= stConfigInfo.wCFGheaderCount;iIndex++)
	mov	dword ptr [ebp-0ch],01h;	iIndex
	xor	eax,eax
	mov	ax,[ebp-05eh];	stConfigInfo
	cmp	[ebp-0ch],eax;	iIndex
	jg	@BLBL95
	align 010h
@BLBL97:

; 583           {
; 584           ulSaveConfigHeaderPosition = ulFilePosition;
	mov	eax,[ebp-01ch];	ulFilePosition
	mov	[ebp-020h],eax;	ulSaveConfigHeaderPosition

; 585           DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
	lea	eax,[ebp-010h];	ulCount
	push	eax
	push	03eh
	lea	eax,[ebp-0a2h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h

; 586           if (!stConfigHeader.bHeaderIsInitialized)
	cmp	word ptr [ebp-08ah],0h;	stConfigHeader
	jne	@BLBL98

; 587             {
; 588             bEarlyHeader = TRUE;
	mov	dword ptr [ebp-0e0h],01h;	bEarlyHeader

; 589             break;
	jmp	@BLBL95
	align 010h
@BLBL98:

; 590             }
; 591           DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-01ch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-088h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 592           }

; 582         for (iIndex = 1;iIndex <= stConfigInfo.wCFGheaderCount;iIndex++)
	mov	eax,[ebp-0ch];	iIndex
	inc	eax
	mov	[ebp-0ch],eax;	iIndex
	xor	eax,eax
	mov	ax,[ebp-05eh];	stConfigInfo
	cmp	[ebp-0ch],eax;	iIndex
	jle	@BLBL97

; 593         }
@BLBL95:

; 594       if (!bEarlyHeader)
	cmp	dword ptr [ebp-0e0h],0h;	bEarlyHeader
	jne	@BLBL100

; 596         if (stConfigHeader.oNextCFGheader == ulSaveConfigHeaderPosition)
	xor	eax,eax
	mov	ax,[ebp-088h];	stConfigHeader
	cmp	[ebp-020h],eax;	ulSaveConfigHeaderPosition
	jne	@BLBL101

; 598           stConfigHeader.oNextCFGheader += (sizeof(CFGHEAD) + (sizeof(DCBHEAD) * MAX_CFG_DEVICE));
	mov	ax,[ebp-088h];	stConfigHeader
	add	ax,03deh
	mov	[ebp-088h],ax;	stConfigHeader
@BLBL101:

; 599         ulSaveConfigHeaderPosition = stConfigHeader.oNextCFGheader;
	xor	eax,eax
	mov	ax,[ebp-088h];	stConfigHeader
	mov	[ebp-020h],eax;	ulSaveConfigHeaderPosition

; 600         oSaveDCBheader = (stConfigHeader.oNextCFGheader + sizeof(CFGHEAD));
	mov	ax,[ebp-088h];	stConfigHeader
	add	ax,03eh
	mov	[ebp-016h],ax;	oSaveDCBheader

; 601         oSaveCFGheader = (oSaveDCBheader + (sizeof(DCBHEAD) * MAX_CFG_DEVICE));
	mov	ax,[ebp-016h];	oSaveDCBheader
	add	ax,03a0h
	mov	[ebp-018h],ax;	oSaveCFGheader

; 602         stConfigInfo.wCFGheaderCount++;
	mov	ax,[ebp-05eh];	stConfigInfo
	inc	ax
	mov	[ebp-05eh],ax;	stConfigInfo

; 603         }
	jmp	@BLBL102
	align 010h
@BLBL100:

; 606         oSaveDCBheader = stConfigHeader.oFirstDCBheader;
	mov	ax,[ebp-086h];	stConfigHeader
	mov	[ebp-016h],ax;	oSaveDCBheader

; 607         oSaveCFGheader = stConfigHeader.oNextCFGheader;
	mov	ax,[ebp-088h];	stConfigHeader
	mov	[ebp-018h],ax;	oSaveCFGheader

; 608         }
@BLBL102:

; 609       InitializeCFGheader(&stConfigHeader);
	lea	eax,[ebp-0a2h];	stConfigHeader
	push	eax
	call	InitializeCFGheader
	add	esp,04h

; 610       stConfigHeader.oFirstDCBheader = oSaveDCBheader;
	mov	ax,[ebp-016h];	oSaveDCBheader
	mov	[ebp-086h],ax;	stConfigHeader

; 611       stConfigHeader.oNextCFGheader = oSaveCFGheader;
	mov	ax,[ebp-018h];	oSaveCFGheader
	mov	[ebp-088h],ax;	stConfigHeader

; 612       pstDCBposition->wLoadNumber = iIndex;
	mov	ecx,[ebp-0ch];	iIndex
	mov	eax,[ebp+0ch];	pstDCBposition
	mov	[eax],cx

; 613       }
@BLBL93:

; 614     DosChgFilePtr(hFile,0L,0,&ulFilePosition);
	lea	eax,[ebp-01ch];	ulFilePosition
	push	eax
	push	0h
	push	0h
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 615     DosWrite(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount);
	lea	eax,[ebp-010h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-064h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosWrite
	add	esp,010h

; 616     DosChgFilePtr(hFile,ulSaveConfigHeaderPosition,0,&ulFilePosition);
	lea	eax,[ebp-01ch];	ulFilePosition
	push	eax
	push	0h
	mov	eax,[ebp-020h];	ulSaveConfigHeaderPosition
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 617     DosWrite(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
	lea	eax,[ebp-010h];	ulCount
	push	eax
	push	03eh
	lea	eax,[ebp-0a2h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosWrite
	add	esp,010h

; 618     DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-01ch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-086h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 619     InitializeDCBheader(&stDCBheader,FALSE);
	push	0h
	lea	eax,[ebp-0dch];	stDCBheader
	push	eax
	call	InitializeDCBheader
	add	esp,08h

; 620     stDCBheader.oNextDCBheader = stConfigHeader.oFirstDCBheader;
	mov	ax,[ebp-086h];	stConfigHeader
	mov	[ebp-0d2h],ax;	stDCBheader

; 621     for (iDCBindex = 0;iDCBindex < MAX_CFG_DEVICE;iDCBindex++)
	mov	dword ptr [ebp-014h],0h;	iDCBindex
	cmp	dword ptr [ebp-014h],010h;	iDCBindex
	jge	@BLBL103
	align 010h
@BLBL104:

; 623       stDCBheader.oNextDCBheader += sizeof(DCBHEAD);
	mov	ax,[ebp-0d2h];	stDCBheader
	add	ax,03ah
	mov	[ebp-0d2h],ax;	stDCBheader

; 624       DosWrite(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
	lea	eax,[ebp-010h];	ulCount
	push	eax
	push	03ah
	lea	eax,[ebp-0dch];	stDCBheader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosWrite
	add	esp,010h

; 625       }

; 621     for (iDCBindex = 0;iDCBindex < MAX_CFG_DEVICE;iDCBindex++)
	mov	eax,[ebp-014h];	iDCBindex
	inc	eax
	mov	[ebp-014h],eax;	iDCBindex
	cmp	dword ptr [ebp-014h],010h;	iDCBindex
	jl	@BLBL104
@BLBL103:

; 626     if (!bEarlyHeader)
	cmp	dword ptr [ebp-0e0h],0h;	bEarlyHeader
	jne	@BLBL106

; 627       DosSetFileSize(hFile,stDCBheader.oNextDCBheader);
	xor	eax,eax
	mov	ax,[ebp-0d2h];	stDCBheader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFileSize
	add	esp,08h
@BLBL106:

; 628     DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 629     return(iIndex);
	mov	eax,[ebp-0ch];	iIndex
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL88:

; 633     sprintf(szMessage,"Unable to open or create the COMi initialization file %s",szFileSpec);
	push	dword ptr [ebp+08h];	szFileSpec
	mov	edx,offset FLAT:@STAT14
	lea	eax,[ebp-0148h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 634     MessageBox(HWND_DESKTOP,szMessage);
	lea	eax,[ebp-0148h];	szMessage
	push	eax
	push	01h
	call	MessageBox
	add	esp,08h

; 635     }

; 636   pstDCBposition->wDCBnumber = 0;
	mov	eax,[ebp+0ch];	pstDCBposition
	mov	word ptr [eax+02h],0h

; 637   return(0);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
AddIniConfigHeader	endp

; 641   {
	align 010h

	public FillDeviceLists
FillDeviceLists	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0d0h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,034h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 653   BOOL bPCIadapter = TRUE;
	mov	dword ptr [ebp-0d0h],01h;	bPCIadapter

; 654 
; 655   while (DosOpen(szDriverIniSpec,&hFile,&ulAction,0L,0,1,0x1312,(PEAOP2)0L) != NO_ERROR)
	push	0h
	push	01312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-04h];	ulAction
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	push	dword ptr [ebp+0ch];	szDriverIniSpec
	call	DosOpen
	add	esp,020h
	test	eax,eax
	je	@BLBL108
	align 010h
@BLBL109:

; 656     if (AddIniConfigHeader(szDriverIniSpec,&stCount) == 0)
	lea	eax,[ebp-0c9h];	stCount
	push	eax
	push	dword ptr [ebp+0ch];	szDriverIniSpec
	call	AddIniConfigHeader
	add	esp,08h
	test	eax,eax
	jne	@BLBL110

; 657       return(stCount);
	mov	eax,[ebp+08h]
	mov	ecx,[ebp-0c9h];	stCount
	mov	[eax],ecx
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL110:

; 655   while (DosOpen(szDriverIniSpec,&hFile,&ulAction,0L,0,1,0x1312,(PEAOP2)0L) != NO_ERROR)
	push	0h
	push	01312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-04h];	ulAction
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	push	dword ptr [ebp+0ch];	szDriverIniSpec
	call	DosOpen
	add	esp,020h
	test	eax,eax
	jne	@BLBL109
@BLBL108:

; 658   stCount.wLoadNumber = 0;
	mov	word ptr [ebp-0c9h],0h;	stCount

; 659   stCount.wDCBnumber = 0;
	mov	word ptr [ebp-0c7h],0h;	stCount

; 660   if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == NO_ERROR)
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-040h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL112

; 662     if (stConfigInfo.wCFGheaderCount != 0)
	cmp	word ptr [ebp-03ah],0h;	stConfigInfo
	je	@BLBL112

; 664       DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-038h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 665       for (iIndex = 1;iIndex <= stConfigInfo.wCFGheaderCount;iIndex++)
	mov	word ptr [ebp-0ah],01h;	iIndex
	mov	ax,[ebp-03ah];	stConfigInfo
	cmp	[ebp-0ah],ax;	iIndex
	ja	@BLBL112
	align 010h
@BLBL115:

; 667         if (DosRead(hFile,(PVOID)&stC
; 667 onfigHeader,sizeof(CFGHEAD),&ulCount) == NO_ERROR)
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03eh
	lea	eax,[ebp-07eh];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL116

; 669           if (!stConfigHeader.bHeaderIsInitialized)
	cmp	word ptr [ebp-066h],0h;	stConfigHeader
	jne	@BLBL117

; 671             DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-064h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 672             continue;
	jmp	@BLBL118
	align 010h
@BLBL117:

; 674           stCount.wLoadNumber++;
	mov	ax,[ebp-0c9h];	stCount
	inc	ax
	mov	[ebp-0c9h],ax;	stCount

; 675           if (stConfigHeader.byAdapterType != HDWTYPE_PCI)
	cmp	byte ptr [ebp-074h],09h;	stConfigHeader
	je	@BLBL119

; 677             bPCIadapter = FALSE;
	mov	dword ptr [ebp-0d0h],0h;	bPCIadapter

; 678             if (stConfigHeader.byInterruptLevel != 0)
	cmp	byte ptr [ebp-073h],0h;	stConfigHeader
	je	@BLBL119

; 679               AddListItem(pstInterruptList,&(stConfigHeader.byInterruptLevel),1);
	push	01h
	lea	eax,[ebp-073h];	stConfigHeader
	push	eax
	push	dword ptr [ebp+014h];	pstInterruptList
	call	AddListItem
	add	esp,0ch

; 680             }
@BLBL119:

; 681           DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-062h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 682           for (iDCBindex = 1;iDCBindex <= stConfigHeader.wDCBcount;iDCBindex++)
	mov	dword ptr [ebp-010h],01h;	iDCBindex
	xor	eax,eax
	mov	ax,[ebp-07ch];	stConfigHeader
	cmp	[ebp-010h],eax;	iDCBindex
	jg	@BLBL116
	align 010h
@BLBL122:

; 684             if (DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount) == 0)
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03ah
	lea	eax,[ebp-0b8h];	stDCBheader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL123

; 686               if (stDCBheader.bHeaderIsInitialized)
	cmp	word ptr [ebp-0b0h],0h;	stDCBheader
	je	@BLBL123

; 688                 stCount.wDCBnumber++;
	mov	ax,[ebp-0c7h];	stCount
	inc	ax
	mov	[ebp-0c7h],ax;	stCount

; 689                 if (!bPCIadapter)
	cmp	dword ptr [ebp-0d0h],0h;	bPCIadapter
	jne	@BLBL125

; 691                   if (stConfigHeader.byInterruptLevel == 0)
	cmp	byte ptr [ebp-073h],0h;	stConfigHeader
	jne	@BLBL126

; 692                     AddListItem(pstInterruptList,&(stDCBheader.stComDCB.byInterruptLevel),1);
	push	01h
	lea	eax,[ebp-088h];	stDCBheader
	push	eax
	push	dword ptr [ebp+014h];	pstInterruptList
	call	AddListItem
	add	esp,0ch
@BLBL126:

; 693                   if (stDCBheader.stComDCB.wIObaseAddress != 0xffff)
	cmp	word ptr [ebp-0a2h],0ffffh;	stDCBheader
	je	@BLBL125

; 694                     AddListItem(pstAddressList,&(stDCBheader.stComDCB.wIObaseAddress),2);
	push	02h
	lea	eax,[ebp-0a2h];	stDCBheader
	push	eax
	push	dword ptr [ebp+010h];	pstAddressList
	call	AddListItem
	add	esp,0ch

; 695                   }
@BLBL125:

; 696                 strncpy(szString,stDCBheader.abyPortName,8);
	mov	ecx,08h
	lea	edx,[ebp-0b8h];	stDCBheader
	lea	eax,[ebp-0c5h];	szString
	call	strncpy

; 697                 RemoveSpaces(szString);
	lea	eax,[ebp-0c5h];	szString
	push	eax
	call	RemoveSpaces
	add	esp,04h

; 698                 astConfigDeviceList[atoi(&szString[DEV_NUM_INDEX])].bAvailable = FALSE;
	lea	eax,[ebp-0c2h];	szString
	call	atoi
	imul	eax,0eh
	mov	dword ptr [eax+ astConfigDeviceList+0ah],0h

; 699                 }

; 700               }
@BLBL123:

; 701             DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-0aeh];	stDCBheader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 702             }

; 682           for (iDCBindex = 1;iDCBindex <= stConfigHeader.wDCBcount;iDCBindex++)
	mov	eax,[ebp-010h];	iDCBindex
	inc	eax
	mov	[ebp-010h],eax;	iDCBindex
	xor	eax,eax
	mov	ax,[ebp-07ch];	stConfigHeader
	cmp	[ebp-010h],eax;	iDCBindex
	jle	@BLBL122

; 703           }
@BLBL116:

; 704         DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-064h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 705         }
@BLBL118:

; 665       for (iIndex = 1;iIndex <= stConfigInfo.wCFGheaderCount;iIndex++)
	mov	ax,[ebp-0ah];	iIndex
	inc	ax
	mov	[ebp-0ah],ax;	iIndex
	mov	ax,[ebp-03ah];	stConfigInfo
	cmp	[ebp-0ah],ax;	iIndex
	jbe	@BLBL115

; 706       }

; 707     }
@BLBL112:

; 708   DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 709   return(stCount);
	mov	eax,[ebp+08h]
	mov	ecx,[ebp-0c9h];	stCount
	mov	[eax],ecx
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
FillDeviceLists	endp

; 713   {
	align 010h

	public FillDeviceNameList
FillDeviceNameList	proc
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
	sub	esp,0ch

; 728   int iCOMscopeAvail = 0;
	mov	dword ptr [ebp-0e0h],0h;	iCOMscopeAvail

; 729   BOOL bCountOnly = FALSE;
	mov	dword ptr [ebp-0e4h],0h;	bCountOnly

; 730   char szDriverIniSpec[CCHMAXPATH];
; 731 
; 732   pstCOMiCFG->iLoadCount = 0;
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	dword ptr [eax+047h],0h

; 733   pstCOMiCFG->iDeviceCount = 0;
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	dword ptr [eax+043h],0h

; 734   if (pstCOMiCFG->cbDevList == 0)
	mov	eax,[ebp+08h];	pstCOMiCFG
	cmp	dword ptr [eax+02dh],0h
	jne	@BLBL130

; 735     bCountOnly = TRUE;
	mov	dword ptr [ebp-0e4h],01h;	bCountOnly
@BLBL130:

; 736   if (pstCOMiCFG->pszDriverIniSpec != NULL)
	mov	eax,[ebp+08h];	pstCOMiCFG
	cmp	dword ptr [eax+018h],0h
	je	@BLBL131

; 737     strcpy(szDriverIniSpec,pstCOMiCFG->pszDriverIniSpec);
	mov	edx,[ebp+08h];	pstCOMiCFG
	mov	edx,[edx+018h]
	lea	eax,[ebp-01e8h];	szDriverIniSpec
	call	strcpy
	jmp	@BLBL132
	align 010h
@BLBL131:

; 738   else
; 739     strcpy(szDriverIniSpec,szDriverIniPath);
	mov	edx,offset FLAT:szDriverIniPath
	lea	eax,[ebp-01e8h];	szDriverIniSpec
	call	strcpy
@BLBL132:

; 740   if (DosOpen(szDriverIniSpec,&hFile,&ulStatus,0L,0,1,0x1312,(PEAOP2)0L) != 0)
	push	0h
	push	01312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-04h];	ulStatus
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	lea	eax,[ebp-01e8h];	szDriverIniSpec
	push	eax
	call	DosOpen
	add	esp,020h
	test	eax,eax
	je	@BLBL133

; 741     return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL133:

; 742   if (!bCountOnly)
	cmp	dword ptr [ebp-0e4h],0h;	bCountOnly
	jne	@BLBL134

; 743     pDeviceList = pstCOMiCFG->pDeviceList;
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	eax,[eax+029h]
	mov	[ebp-0dch],eax;	pDeviceList
@BLBL134:

; 744   if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-040h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL135

; 745     {
; 746     if (stConfigInfo.wCFGheaderCount != 0)
	cmp	word ptr [ebp-03ah],0h;	stConfigInfo
	je	@BLBL135

; 747       {
; 748       DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-038h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 749       for (iIndex = 1;iIndex <= stConfigInfo.wCFGheaderCount;iIndex++)
	mov	dword ptr [ebp-0ch],01h;	iIndex
	xor	eax,eax
	mov	ax,[ebp-03ah];	stConfigInfo
	cmp	[ebp-0ch],eax;	iIndex
	jg	@BLBL135
	align 010h
@BLBL138:

; 750         {
; 751         if (DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount) == 0)
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03eh
	lea	eax,[ebp-07eh];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL139

; 752           {
; 753           if (!stConfigHeader.bHeaderIsInitialized)
	cmp	word ptr [ebp-066h],0h;	stConfigHeader
	jne	@BLBL140

; 754             {
; 755             DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-064h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 756             continue;
	jmp	@BLBL141
	align 010h
@BLBL140:

; 757             }
; 758           pstCOMiCFG->iLoadCount++;
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	[ebp-01f0h],eax;	@CBE35
	mov	eax,[ebp-01f0h];	@CBE35
	mov	ecx,[eax+047h]
	inc	ecx
	mov	[eax+047h],ecx

; 759           DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-062h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 760           for (iDCBindex = 1;iDCBindex <= stConfigHeader.wDCBcount;iDCBindex++)
	mov	dword ptr [ebp-010h],01h;	iDCBindex
	xor	eax,eax
	mov	ax,[ebp-07ch];	stConfigHeader
	cmp	[ebp-010h],eax;	iDCBindex
	jg	@BLBL139
	align 010h
@BLBL143:

; 761             {
; 762             if (DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount) == 0)
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03ah
	lea	eax,[ebp-0b8h];	stDCBheader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL144

; 763               {
; 764               if (stDCBheader.bHeaderIsInitialized)
	cmp	word ptr [ebp-0b0h],0h;	stDCBheader
	je	@BLBL144

; 765                 {
; 766                 if (stDCBheader.stComDCB.wIObaseAddress != 0xffff)
	cmp	word ptr [ebp-0a2h],0ffffh;	stDCBheader
	je	@BLBL144

; 767                   {
; 768                   strncpy(szString,stDCBheader.abyPortName,8);
	mov	ecx,08h
	lea	edx,[ebp-0b8h];	stDCBheader
	lea	eax,[ebp-0c6h];	szString
	call	strncpy

; 769                   strncpy(szTemp,szString,8);
	mov	ecx,08h
	lea	edx,[ebp-0c6h];	szString
	lea	eax,[ebp-0d0h];	szTemp
	call	strncpy

; 770                   RemoveSpaces(szString);
	lea	eax,[ebp-0c6h];	szString
	push	eax
	call	RemoveSpaces
	add	esp,04h

; 771                   pstCOMiCFG->iDeviceCount++;
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	[ebp-01ech],eax;	@CBE34
	mov	eax,[ebp-01ech];	@CBE34
	mov	ecx,[eax+043h]
	inc	ecx
	mov	[eax+043h],ecx

; 772                   if (pstCOMiCFG->bEnumCOMscope)
	mov	eax,[ebp+08h];	pstCOMiCFG
	test	byte ptr [eax+04bh],08h
	je	@BLBL147

; 773                     {
; 774                     AppendTripleDS(szTemp);
	lea	eax,[ebp-0d0h];	szTemp
	push	eax
	call	AppendTripleDS
	add	esp,04h

; 775                     if (DosOpen(szTemp,&hCom,&ulAction,0L,0L,0x0001,0x21c2,0L) == 0)
	push	0h
	push	021c2h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-0d8h];	ulAction
	push	eax
	lea	eax,[ebp-0d4h];	hCom
	push	eax
	lea	eax,[ebp-0d0h];	szTemp
	push	eax
	call	DosOpen
	add	esp,020h
	test	eax,eax
	jne	@BLBL144

; 776                       {
; 777                       DosClose(hCom);
	push	dword ptr [ebp-0d4h];	hCom
	call	DosClose
	add	esp,04h

; 778                       iCOMscopeAvail++;
	mov	eax,[ebp-0e0h];	iCOMscopeAvail
	inc	eax
	mov	[ebp-0e0h],eax;	iCOMscopeAvail

; 779                       if (pstCOMiCFG->bFindCOMscope)
	mov	eax,[ebp+08h];	pstCOMiCFG
	test	byte ptr [eax+04bh],01h
	je	@BLBL149

; 780                         {
; 781                         if (strcmp(szString,pstCOMiCFG->pszPortName) == 0)
	mov	edx,[ebp+08h];	pstCOMiCFG
	mov	edx,[edx+014h]
	lea	eax,[ebp-0c6h];	szString
	call	strcmp
	test	eax,eax
	jne	@BLBL144

; 782                           {
; 783                           DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 784                           if (!bCountOnly)
	cmp	dword ptr [ebp-0e4h],0h;	bCountOnly
	jne	@BLBL151

; 785                             {
; 786                             strcpy(pDeviceList,szString);
	lea	edx,[ebp-0c6h];	szString
	mov	eax,[ebp-0dch];	pDeviceList
	call	strcpy

; 787                             pDeviceList += (strlen(szString) + 1);
	lea	eax,[ebp-0c6h];	szString
	call	strlen
	mov	ecx,eax
	mov	eax,[ebp-0dch];	pDeviceList
	add	eax,ecx
	inc	eax
	mov	[ebp-0dch],eax;	pDeviceList

; 788                             }
@BLBL151:

; 789                           return(TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL149:

; 790                           }
; 791                         }
; 792                       else
; 793                         if (!bCountOnly)
	cmp	dword ptr [ebp-0e4h],0h;	bCountOnly
	jne	@BLBL144

; 794                           {
; 795                           strcpy(pDeviceList,szString);
	lea	edx,[ebp-0c6h];	szString
	mov	eax,[ebp-0dch];	pDeviceList
	call	strcpy

; 796                           pDeviceList += (strlen(szString) + 1);                                }
	lea	eax,[ebp-0c6h];	szString
	call	strlen
	mov	ecx,eax
	mov	eax,[ebp-0dch];	pDeviceList
	add	eax,ecx
	inc	eax
	mov	[ebp-0dch],eax;	pDeviceList

; 797                           }

; 798                     }
	jmp	@BLBL144
	align 010h
@BLBL147:

; 799                   else
; 800                     if (!bCountOnly)
	cmp	dword ptr [ebp-0e4h],0h;	bCountOnly
	jne	@BLBL144

; 801                       {
; 802                       strcpy(pDeviceList,szString);
	lea	edx,[ebp-0c6h];	szString
	mov	eax,[ebp-0dch];	pDeviceList
	call	strcpy

; 803                       pDeviceList += (strlen(szString) + 1);
	lea	eax,[ebp-0c6h];	szString
	call	strlen
	mov	ecx,eax
	mov	eax,[ebp-0dch];	pDeviceList
	add	eax,ecx
	inc	eax
	mov	[ebp-0dch],eax;	pDeviceList

; 804                       }

; 805                   }

; 806                 }

; 807               }
@BLBL144:

; 808             DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-0aeh];	stDCBheader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 809             }

; 760           for (iDCBindex = 1;iDCBindex <= stConfigHeader.wDCBcount;iDCBindex++)
	mov	eax,[ebp-010h];	iDCBindex
	inc	eax
	mov	[ebp-010h],eax;	iDCBindex
	xor	eax,eax
	mov	ax,[ebp-07ch];	stConfigHeader
	cmp	[ebp-010h],eax;	iDCBindex
	jle	@BLBL143

; 810           }
@BLBL139:

; 811         DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-064h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 812         }
@BLBL141:

; 749       for (iIndex = 1;iIndex <= stConfigInfo.wCFGheaderCount;iIndex++)
	mov	eax,[ebp-0ch];	iIndex
	inc	eax
	mov	[ebp-0ch],eax;	iIndex
	xor	eax,eax
	mov	ax,[ebp-03ah];	stConfigInfo
	cmp	[ebp-0ch],eax;	iIndex
	jle	@BLBL138

; 813       }

; 814     }
@BLBL135:

; 815   DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 816   if (pstCOMiCFG->bEnumCOMscope)
	mov	eax,[ebp+08h];	pstCOMiCFG
	test	byte ptr [eax+04bh],08h
	je	@BLBL158

; 817     if (pstCOMiCFG->bFindCOMscope)
	mov	eax,[ebp+08h];	pstCOMiCFG
	test	byte ptr [eax+04bh],01h
	je	@BLBL159

; 818       return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL159:

; 820       return(iCOMscopeAvail);
	mov	eax,[ebp-0e0h];	iCOMscopeAvail
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL158:

; 822     return(pstCOMiCFG->iDeviceCount);
	mov	eax,[ebp+08h];	pstCOMiCFG
	mov	eax,[eax+043h]
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
FillDeviceNameList	endp

; 826   {
	align 010h

	public PlaceIniCFGheader
PlaceIniCFGheader	proc
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

; 827   BOOL bPlaced = FALSE;
	mov	dword ptr [ebp-04h],0h;	bPlaced

; 828 //  ULONG ulStatus;
; 829   HFILE hFile;
; 830   WORD iIndex;
; 831   ULONG ulCount;
; 832   CFGINFO stConfigInfo;
; 833   CFGHEAD stConfigHeader;
; 834   ULONG ulFilePosition;
; 835   ULONG ulSaveConfigHeaderOffset;
; 836   DCBPOS stCount;
; 837   ULONG ulAction;
; 838 
; 839   while (DosOpen(szFileSpec,&hFile,&ulAction,0L,0,1,0x1312,(PEAOP2)0L) != NO_ERROR)
	push	0h
	push	01312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-08ch];	ulAction
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosOpen
	add	esp,020h
	test	eax,eax
	je	@BLBL162
	align 010h
@BLBL163:

; 840     if (AddIniConfigHeader(szFileSpec,&stCount) == 0)
	lea	eax,[ebp-088h];	stCount
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	AddIniConfigHeader
	add	esp,08h
	test	eax,eax
	jne	@BLBL164

; 841       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL164:

; 839   while (DosOpen(szFileSpec,&hFile,&ulAction,0L,0,1,0x1312,(PEAOP2)0L) != NO_ERROR)
	push	0h
	push	01312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-08ch];	ulAction
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosOpen
	add	esp,020h
	test	eax,eax
	jne	@BLBL163
@BLBL162:

; 842   if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
	lea	eax,[ebp-010h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-03ch];	stConfigInfo
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL166

; 844     if (stConfigInfo.wCFGheaderCount >= pstHeaderPosition->wLoadNumber)
	mov	eax,[ebp+010h];	pstHeaderPosition
	mov	cx,[ebp-036h];	stConfigInfo
	cmp	[eax],cx
	ja	@BLBL166

; 846       DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-080h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-034h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 847       for (iIndex = 0;iIndex < pstHeaderPosition->wLoadNumber;iIndex++)
	mov	word ptr [ebp-0ah],0h;	iIndex
	mov	eax,[ebp+010h];	pstHeaderPosition
	mov	cx,[ebp-0ah];	iIndex
	cmp	[eax],cx
	jbe	@BLBL168
	align 010h
@BLBL169:

; 849         ulSaveConfigHeaderOffset = ulFilePosition;
	mov	eax,[ebp-080h];	ulFilePosition
	mov	[ebp-084h],eax;	ulSaveConfigHeaderOffset

; 850         DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
	lea	eax,[ebp-010h];	ulCount
	push	eax
	push	03eh
	lea	eax,[ebp-07ah];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h

; 851         DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-080h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-060h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 852         }

; 847       for (iIndex = 0;iIndex < pstHeaderPosition->wLoadNumber;iIndex++)
	mov	ax,[ebp-0ah];	iIndex
	inc	ax
	mov	[ebp-0ah],ax;	iIndex
	mov	eax,[ebp+010h];	pstHeaderPosition
	mov	cx,[ebp-0ah];	iIndex
	cmp	[eax],cx
	ja	@BLBL169
@BLBL168:

; 853       pstCFGheader->bHeaderIsInitialized = TRUE;
	mov	eax,[ebp+0ch];	pstCFGheader
	mov	word ptr [eax+018h],01h

; 856       pstCFGheader->oNextCFGheader = stConfigHeader.oNextCFGheader;
	mov	eax,[ebp+0ch];	pstCFGheader
	mov	cx,[ebp-060h];	stConfigHeader
	mov	[eax+01ah],cx

; 857       pstCFGheader->oFirstDCBheader = stConfigHeader.oFirstDCBheader;
	mov	eax,[ebp+0ch];	pstCFGheader
	mov	cx,[ebp-05eh];	stConfigHeader
	mov	[eax+01ch],cx

; 858       DosChgFilePtr(hFile,ulSaveConfigHeaderOffset,0,&ulFilePosition);
	lea	eax,[ebp-080h];	ulFilePosition
	push	eax
	push	0h
	mov	eax,[ebp-084h];	ulSaveConfigHeaderOffset
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 859       DosWrite(hFile,(PVOID)pstCFGheader,sizeof(CFGHEAD),&ulCount);
	lea	eax,[ebp-010h];	ulCount
	push	eax
	push	03eh
	push	dword ptr [ebp+0ch];	pstCFGheader
	push	dword ptr [ebp-08h];	hFile
	call	DosWrite
	add	esp,010h

; 860       bPlaced = TRUE;
	mov	dword ptr [ebp-04h],01h;	bPlaced

; 861       }

; 862     }
@BLBL166:

; 863   DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 864   return(bPlaced);
	mov	eax,[ebp-04h];	bPlaced
	mov	esp,ebp
	pop	ebp
	ret	
PlaceIniCFGheader	endp

; 868   {
	align 010h

	public PlaceIniDCBheader
PlaceIniDCBheader	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0d8h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,036h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 869   BOOL bPlaced = FALSE;
	mov	dword ptr [ebp-04h],0h;	bPlaced

; 870 //  ULONG ulStatus;
; 871   HFILE hFile;
; 872   WORD iIndex;
; 873   int iDCBindex;
; 874   ULONG ulCount;
; 875   CFGINFO stConfigInfo;
; 876   CFGHEAD stConfigHeader;
; 877   DCBHEAD stDCBheader;
; 878   ULONG ulFilePosition;
; 879   ULONG ulSaveConfigHeaderOffset;
; 880   ULONG ulSaveDCBheaderOffset;
; 881   BOOL bFindNextLoad = FALSE;
	mov	dword ptr [ebp-0c8h],0h;	bFindNextLoad

; 882   BOOL bFindNextDevice = FALSE;
	mov	dword ptr [ebp-0cch],0h;	bFindNextDevice

; 883   WORD wLoadIndex;
; 884   WORD wDeviceIndex;
; 885   DCBPOS stCount;
; 886   ULONG ulAction;
; 887 
; 888   while (DosOpen(szFileSpec,&hFile,&ulAction,0L,0,1,0x1312,(PEAOP2)0L) != NO_ERROR)
	push	0h
	push	01312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-0d8h];	ulAction
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosOpen
	add	esp,020h
	test	eax,eax
	je	@BLBL171
	align 010h
@BLBL172:

; 889     if (AddIniConfigHeader(szFileSpec,&stCount) == 0)
	lea	eax,[ebp-0d4h];	stCount
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	AddIniConfigHeader
	add	esp,08h
	test	eax,eax
	jne	@BLBL173

; 890       return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL173:

; 888   while (DosOpen(szFileSpec,&hFile,&ulAction,0L,0,1,0x1312,(PEAOP2)0L) != NO_ERROR)
	push	0h
	push	01312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-0d8h];	ulAction
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosOpen
	add	esp,020h
	test	eax,eax
	jne	@BLBL172
@BLBL171:

; 891   if (pstHeaderPosition->wLoadNumber == 0)
	mov	eax,[ebp+014h];	pstHeaderPosition
	cmp	word ptr [eax],0h
	jne	@BLBL175

; 892     
; 892 bFindNextLoad = TRUE;
	mov	dword ptr [ebp-0c8h],01h;	bFindNextLoad
@BLBL175:

; 893   if (pstHeaderPosition->wDCBnumber == 0)
	mov	eax,[ebp+014h];	pstHeaderPosition
	cmp	word ptr [eax+02h],0h
	jne	@BLBL176

; 894     bFindNextDevice = TRUE;
	mov	dword ptr [ebp-0cch],01h;	bFindNextDevice
@BLBL176:

; 895   if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-040h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL177

; 897     if ((stConfigInfo.wCFGheaderCount >= pstHeaderPosition->wLoadNumber) && (stConfigInfo.wCFGheaderCount != 0))
	mov	eax,[ebp+014h];	pstHeaderPosition
	mov	cx,[ebp-03ah];	stConfigInfo
	cmp	[eax],cx
	ja	@BLBL177
	cmp	word ptr [ebp-03ah],0h;	stConfigInfo
	je	@BLBL177

; 899       DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-038h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 900       if (bFindNextLoad)
	cmp	dword ptr [ebp-0c8h],0h;	bFindNextLoad
	je	@BLBL179

; 901         wLoadIndex = MAX_CFG_LOAD;
	mov	word ptr [ebp-0ceh],010h;	wLoadIndex
	jmp	@BLBL180
	align 010h
@BLBL179:

; 903         wLoadIndex = pstHeaderPosition->wLoadNumber;
	mov	eax,[ebp+014h];	pstHeaderPosition
	mov	ax,[eax]
	mov	[ebp-0ceh],ax;	wLoadIndex
@BLBL180:

; 904       for (iIndex = 0;iIndex < wLoadIndex;iIndex++)
	mov	word ptr [ebp-0ah],0h;	iIndex
	mov	ax,[ebp-0ceh];	wLoadIndex
	cmp	[ebp-0ah],ax;	iIndex
	jae	@BLBL181
	align 010h
@BLBL182:

; 906         ulSaveConfigHeaderOffset = ulFilePosition;
	mov	eax,[ebp-0bch];	ulFilePosition
	mov	[ebp-0c0h],eax;	ulSaveConfigHeaderOffset

; 907         DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03eh
	lea	eax,[ebp-07eh];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h

; 908         if (bFindNextLoad && !stConfigHeader.bHeaderIsInitialized)
	cmp	dword ptr [ebp-0c8h],0h;	bFindNextLoad
	je	@BLBL183
	cmp	word ptr [ebp-066h],0h;	stConfigHeader
	jne	@BLBL183

; 910           pstHeaderPosition->wLoadNumber = iIndex  + 1;
	mov	cx,[ebp-0ah];	iIndex
	inc	cx
	mov	eax,[ebp+014h];	pstHeaderPosition
	mov	[eax],cx

; 911           break;
	jmp	@BLBL181
	align 010h
@BLBL183:

; 913         DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-064h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 914         }

; 904       for (iIndex = 0;iIndex < wLoadIndex;iIndex++)
	mov	ax,[ebp-0ah];	iIndex
	inc	ax
	mov	[ebp-0ah],ax;	iIndex
	mov	ax,[ebp-0ceh];	wLoadIndex
	cmp	[ebp-0ah],ax;	iIndex
	jb	@BLBL182
@BLBL181:

; 915       DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-062h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 916       wDeviceIndex = stConfigHeader.wDCBcount;
	mov	ax,[ebp-07ch];	stConfigHeader
	mov	[ebp-0d0h],ax;	wDeviceIndex

; 917       if (!bFindNextDevice)
	cmp	dword ptr [ebp-0cch],0h;	bFindNextDevice
	jne	@BLBL185

; 919         if (pstHeaderPosition->wDCBnumber > wDeviceIndex)
	mov	eax,[ebp+014h];	pstHeaderPosition
	mov	cx,[ebp-0d0h];	wDeviceIndex
	cmp	[eax+02h],cx
	jbe	@BLBL186

; 920           return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL186:

; 921         wDeviceIndex = pstHeaderPosition->wDCBnumber;
	mov	eax,[ebp+014h];	pstHeaderPosition
	mov	ax,[eax+02h]
	mov	[ebp-0d0h],ax;	wDeviceIndex

; 922         }
@BLBL185:

; 923       for (iDCBindex = 0;iDCBindex < wDeviceIndex;iDCBindex++)
	mov	dword ptr [ebp-010h],0h;	iDCBindex
	xor	eax,eax
	mov	ax,[ebp-0d0h];	wDeviceIndex
	cmp	[ebp-010h],eax;	iDCBindex
	jge	@BLBL187
	align 010h
@BLBL188:

; 925         ulSaveDCBheaderOffset = ulFilePosition;
	mov	eax,[ebp-0bch];	ulFilePosition
	mov	[ebp-0c4h],eax;	ulSaveDCBheaderOffset

; 926         DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03ah
	lea	eax,[ebp-0b8h];	stDCBheader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h

; 927         if (bFindNextDevice && !stDCBheader.bHeaderIsInitialized)
	cmp	dword ptr [ebp-0cch],0h;	bFindNextDevice
	je	@BLBL189
	cmp	word ptr [ebp-0b0h],0h;	stDCBheader
	jne	@BLBL189

; 929           pstHeaderPosition->wDCBnumber = (iDCBindex + 1);
	mov	ecx,[ebp-010h];	iDCBindex
	inc	ecx
	mov	eax,[ebp+014h];	pstHeaderPosition
	mov	[eax+02h],cx

; 930           bPlaced = TRUE;
	mov	dword ptr [ebp-04h],01h;	bPlaced

; 931           break;
	jmp	@BLBL187
	align 010h
@BLBL189:

; 933         DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-0aeh];	stDCBheader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 934         }

; 923       for (iDCBindex = 0;iDCBindex < wDeviceIndex;iDCBindex++)
	mov	eax,[ebp-010h];	iDCBindex
	inc	eax
	mov	[ebp-010h],eax;	iDCBindex
	xor	eax,eax
	mov	ax,[ebp-0d0h];	wDeviceIndex
	cmp	[ebp-010h],eax;	iDCBindex
	jl	@BLBL188
@BLBL187:

; 935       if (bFindNextDevice && bPlaced)
	cmp	dword ptr [ebp-0cch],0h;	bFindNextDevice
	je	@BLBL191
	cmp	dword ptr [ebp-04h],0h;	bPlaced
	je	@BLBL191

; 936         stConfigHeader.wDeviceCount++;
	mov	ax,[ebp-07eh];	stConfigHeader
	inc	ax
	mov	[ebp-07eh],ax;	stConfigHeader
@BLBL191:

; 937       if (!bFindNextDevice || bPlaced)
	cmp	dword ptr [ebp-0cch],0h;	bFindNextDevice
	je	@BLBL192
	cmp	dword ptr [ebp-04h],0h;	bPlaced
	je	@BLBL177
@BLBL192:

; 939         pstDCBheader->bHeaderIsInitialized = TRUE;
	mov	eax,[ebp+010h];	pstDCBheader
	mov	word ptr [eax+08h],01h

; 940         pstDCBheader->oNextDCBheader = stDCBheader.oNextDCBheader;
	mov	eax,[ebp+010h];	pstDCBheader
	mov	cx,[ebp-0aeh];	stDCBheader
	mov	[eax+0ah],cx

; 941         DosChgFilePtr(hFile,ulSaveDCBheaderOffset,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	mov	eax,[ebp-0c4h];	ulSaveDCBheaderOffset
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 942         DosWrite(hFile,(PVOID)pstDCBheader,sizeof(DCBHEAD),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03ah
	push	dword ptr [ebp+010h];	pstDCBheader
	push	dword ptr [ebp-08h];	hFile
	call	DosWrite
	add	esp,010h

; 943         pstCFGheader->bHeaderIsInitialized = TRUE;
	mov	eax,[ebp+0ch];	pstCFGheader
	mov	word ptr [eax+018h],01h

; 944         pstCFGheader->wDeviceCount = stConfigHeader.wDeviceCount;
	mov	eax,[ebp+0ch];	pstCFGheader
	mov	cx,[ebp-07eh];	stConfigHeader
	mov	[eax],cx

; 945         pstCFGheader->wDCBcount = stConfigHeader.wDCBcount;
	mov	eax,[ebp+0ch];	pstCFGheader
	mov	cx,[ebp-07ch];	stConfigHeader
	mov	[eax+02h],cx

; 946         pstCFGheader->oNextCFGheader = stConfigHeader.oNextCFGheader;
	mov	eax,[ebp+0ch];	pstCFGheader
	mov	cx,[ebp-064h];	stConfigHeader
	mov	[eax+01ah],cx

; 947         pstCFGheader->oFirstDCBheader = stConfigHeader.oFirstDCBheader;
	mov	eax,[ebp+0ch];	pstCFGheader
	mov	cx,[ebp-062h];	stConfigHeader
	mov	[eax+01ch],cx

; 948         DosChgFilePtr(hFile,ulSaveConfigHeaderOffset,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	mov	eax,[ebp-0c0h];	ulSaveConfigHeaderOffset
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 949         DosWrite(hFile,(PVOID)pstCFGheader,sizeof(CFGHEAD),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03eh
	push	dword ptr [ebp+0ch];	pstCFGheader
	push	dword ptr [ebp-08h];	hFile
	call	DosWrite
	add	esp,010h

; 950         bPlaced = TRUE;
	mov	dword ptr [ebp-04h],01h;	bPlaced

; 951         }

; 952       }

; 953     }
@BLBL177:

; 954   DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 955   return(bPlaced);
	mov	eax,[ebp-04h];	bPlaced
	mov	esp,ebp
	pop	ebp
	ret	
PlaceIniDCBheader	endp

; 959   {
	align 010h

	public ClearAllIntDCBheader
ClearAllIntDCBheader	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0c0h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,030h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 971   if (DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x1312,(PEAOP2)0L) == 0)
	push	0h
	push	01312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-04h];	ulStatus
	push	eax
	lea	eax,[ebp-08h];	hFile
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosOpen
	add	esp,020h
	test	eax,eax
	jne	@BLBL194

; 972     {
; 973     if (ulStatus == FILE_EXISTED)
	cmp	dword ptr [ebp-04h],01h;	ulStatus
	jne	@BLBL195

; 974       {
; 975       if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
	lea	eax,[ebp-010h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-03ch];	stConfigInfo
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL195

; 976         {
; 977         for (wLoadIndex = 0;wLoadIndex < stConfigInfo.wCFGheaderCount;wLoadIndex++)
	mov	word ptr [ebp-0beh],0h;	wLoadIndex
	mov	ax,[ebp-036h];	stConfigInfo
	cmp	[ebp-0beh],ax;	wLoadIndex
	jae	@BLBL195
	align 010h
@BLBL198:

; 978           {
; 979           DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0b8h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-034h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 980           DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
	lea	eax,[ebp-010h];	ulCount
	push	eax
	push	03eh
	lea	eax,[ebp-07ah];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h

; 981           DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0b8h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-05eh];	stConfigHeader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 982           for (iDCBindex = 0;iDCBindex < stConfigHeader.wDCBcount;iDCBindex++)
	mov	dword ptr [ebp-0ch],0h;	iDCBindex
	xor	eax,eax
	mov	ax,[ebp-078h];	stConfigHeader
	cmp	[ebp-0ch],eax;	iDCBindex
	jge	@BLBL199
	align 010h
@BLBL200:

; 983             {
; 984             ulSaveDCBheaderOffset = ulFilePosition;
	mov	eax,[ebp-0b8h];	ulFilePosition
	mov	[ebp-0bch],eax;	ulSaveDCBheaderOffset

; 985             DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
	lea	eax,[ebp-010h];	ulCount
	push	eax
	push	03ah
	lea	eax,[ebp-0b4h];	stDCBheader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosRead
	add	esp,010h

; 986             if (stConfigHeader.byInterruptLevel != 0)
	cmp	byte ptr [ebp-06fh],0h;	stConfigHeader
	je	@BLBL201

; 987               {
; 988               stDCBheader.stComDCB.wConfigFlags1 |= CFG_FLAG1_MULTI_INT;
	mov	ax,[ebp-0a4h];	stDCBheader
	or	ax,04000h
	mov	[ebp-0a4h],ax;	stDCBheader

; 989               stDCBheader.stComDCB.wConfigFlags1 &= ~CFG_FLAG1_EXCLUSIVE_ACCESS;
	xor	eax,eax
	mov	ax,[ebp-0a4h];	stDCBheader
	and	ah,07fh
	mov	[ebp-0a4h],ax;	stDCBheader

; 990               DosChgFilePtr(hFile,ulSaveDCBheaderOffset,0,&ulFilePosition);
	lea	eax,[ebp-0b8h];	ulFilePosition
	push	eax
	push	0h
	mov	eax,[ebp-0bch];	ulSaveDCBheaderOffset
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 991               DosWrite(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
	lea	eax,[ebp-010h];	ulCount
	push	eax
	push	03ah
	lea	eax,[ebp-0b4h];	stDCBheader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosWrite
	add	esp,010h

; 992               }
@BLBL201:

; 993             DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0b8h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-0aah];	stDCBheader
	push	eax
	push	dword ptr [ebp-08h];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 994             }

; 982           for (iDCBindex = 0;iDCBindex < stConfigHeader.wDCBcount;iDCBindex++)
	mov	eax,[ebp-0ch];	iDCBindex
	inc	eax
	mov	[ebp-0ch],eax;	iDCBindex
	xor	eax,eax
	mov	ax,[ebp-078h];	stConfigHeader
	cmp	[ebp-0ch],eax;	iDCBindex
	jl	@BLBL200
@BLBL199:

; 995           }

; 977         for (wLoadIndex = 0;wLoadIndex < stConfigInfo.wCFGheaderCount;wLoadIndex++)
	mov	ax,[ebp-0beh];	wLoadIndex
	inc	ax
	mov	[ebp-0beh],ax;	wLoadIndex
	mov	ax,[ebp-036h];	stConfigInfo
	cmp	[ebp-0beh],ax;	wLoadIndex
	jb	@BLBL198

; 996         }

; 997       }
@BLBL195:

; 998     DosClose(hFile);
	push	dword ptr [ebp-08h];	hFile
	call	DosClose
	add	esp,04h

; 999     }
@BLBL194:

; 1000   }
	mov	esp,ebp
	pop	ebp
	ret	
ClearAllIntDCBheader	endp

; 1003   {
	align 010h

	public QueryIniCFGheader
QueryIniCFGheader	proc
	push	ebp
	mov	ebp,esp
	sub	esp,084h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,021h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 1004   BOOL bCFGfound = FALSE;
	mov	dword ptr [ebp-04h],0h;	bCFGfound

; 1005   ULONG ulStatus;
; 1006   HFILE hFile;
; 1007   WORD iIndex;
; 1008   ULONG ulCount;
; 1009   CFGINFO stConfigInfo;
; 1010   CFGHEAD stConfigHeader;
; 1011   ULONG ulFilePosition;
; 1012 
; 1013   if (DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0312,(PEAOP2)0L) == 0)
	push	0h
	push	0312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-08h];	ulStatus
	push	eax
	lea	eax,[ebp-0ch];	hFile
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosOpen
	add	esp,020h
	test	eax,eax
	jne	@BLBL204

; 1014     {
; 1015     if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-040h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL205

; 1016       {
; 1017       if (stConfigInfo.wCFGheaderCount >= pstHeaderPosition->wLoadNumber)
	mov	eax,[ebp+010h];	pstHeaderPosition
	mov	cx,[ebp-03ah];	stConfigInfo
	cmp	[eax],cx
	ja	@BLBL205

; 1018         {
; 1019         DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-084h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-038h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1020         iIndex = 0;
	mov	word ptr [ebp-0eh],0h;	iIndex

; 1021 //        while (iIndex < pstHeaderPosition->wLoadNumber)
; 1022         for (iIndex = 0;iIndex < pstHeaderPosition->wLoadNumber;iIndex++)
	mov	word ptr [ebp-0eh],0h;	iIndex
	mov	eax,[ebp+010h];	pstHeaderPosition
	mov	cx,[ebp-0eh];	iIndex
	cmp	[eax],cx
	jbe	@BLBL207
	align 010h
@BLBL208:

; 1023           {
; 1024           DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03eh
	lea	eax,[ebp-07eh];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h

; 1025           if (ulCount < sizeof(CFGHEAD))
	cmp	dword ptr [ebp-014h],03eh;	ulCount
	jae	@BLBL209

; 1026             {
; 1027             stConfigHeader.bHeaderIsInitialized = FALSE;
	mov	word ptr [ebp-066h],0h;	stConfigHeader

; 1028             break;
	jmp	@BLBL207
	align 010h
@BLBL209:

; 1029             }
; 1030 //          if (stConfigHeader.bHeaderIsInitialized)
; 1031 //            iIndex++;
; 1032           DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-084h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-064h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1033           }

; 1022         for (iIndex = 0;iIndex < pstHeaderPosition->wLoadNumber;iIndex++)
	mov	ax,[ebp-0eh];	iIndex
	inc	ax
	mov	[ebp-0eh],ax;	iIndex
	mov	eax,[ebp+010h];	pstHeaderPosition
	mov	cx,[ebp-0eh];	iIndex
	cmp	[eax],cx
	ja	@BLBL208
@BLBL207:

; 1034         if (stConfigHeader.bHeaderIsInitialized)
	cmp	word ptr [ebp-066h],0h;	stConfigHeader
	je	@BLBL211

; 1035           bCFGfound = TRUE;
	mov	dword ptr [ebp-04h],01h;	bCFGfound
@BLBL211:

; 1036         memcpy(pstCFGheader,&stConfigHeader,sizeof(CFGHEAD));
	mov	ecx,03eh
	lea	edx,[ebp-07eh];	stConfigHeader
	mov	eax,[ebp+0ch];	pstCFGheader
	call	memcpy

; 1037         }

; 1038       }
@BLBL205:

; 1039     DosClose(hFile);
	push	dword ptr [ebp-0ch];	hFile
	call	DosClose
	add	esp,04h

; 1040     }
@BLBL204:

; 1041   return(bCFGfound);
	mov	eax,[ebp-04h];	bCFGfound
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
QueryIniCFGheader	endp

; 1045   {
	align 010h

	public QueryIniDCBheader
QueryIniDCBheader	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0bch
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,02fh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 1046   BOOL bDevFound = FALSE;
	mov	dword ptr [ebp-04h],0h;	bDevFound

; 1047   ULONG ulStatus;
; 1048   HFILE hFile;
; 1049   WORD iIndex;
; 1050   ULONG ulCount;
; 1051   CFGINFO stConfigInfo;
; 1052   CFGHEAD stConfigHeader;
; 1053   DCBHEAD stDCBheader;
; 1054   ULONG ulFilePosition;
; 1055 
; 1056   if (DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0312,(PEAOP2)0L) == 0)
	push	0h
	push	0312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-08h];	ulStatus
	push	eax
	lea	eax,[ebp-0ch];	hFile
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosOpen
	add	esp,020h
	test	eax,eax
	jne	@BLBL212

; 1057     {
; 1058     if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-040h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL213

; 1059       {
; 1060       if (stConfigInfo.wCFGheaderCount >= pstHeaderPosition->wLoadNumber)
	mov	eax,[ebp+014h];	pstHeaderPosition
	mov	cx,[ebp-03ah];	stConfigInfo
	cmp	[eax],cx
	ja	@BLBL213

; 1061         {
; 1062         DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-038h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1063         iIndex = 0;
	mov	word ptr [ebp-0eh],0h;	iIndex

; 1064 //        while (iIndex < pstHeaderPosition->wLoadNumber)
; 1065         for (iIndex = 0;iIndex < pstHeaderPosition->wLoadNumber; iIndex++)
	mov	word ptr [ebp-0eh],0h;	iIndex
	mov	eax,[ebp+014h];	pstHeaderPosition
	mov	cx,[ebp-0eh];	iIndex
	cmp	[eax],cx
	jbe	@BLBL215
	align 010h
@BLBL216:

; 1066           {
; 1067           DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03eh
	lea	eax,[ebp-07eh];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h

; 1068           if (ulCount < sizeof(CFGHEAD))
	cmp	dword ptr [ebp-014h],03eh;	ulCount
	jae	@BLBL217

; 1069             {
; 1070             stConfigHeader.bHeaderIsInitialized = FALSE;
	mov	word ptr [ebp-066h],0h;	stConfigHeader

; 1071             break;
	jmp	@BLBL215
	align 010h
@BLBL217:

; 1072             }
; 1073 //          if (stConfigHeader.bHeaderIsInitialized)
; 1074 //            iIndex++;
; 1075           DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-064h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1076           }

; 1065         for (iIndex = 0;iIndex < pstHeaderPosition->wLoadNumber; iIndex++)
	mov	ax,[ebp-0eh];	iIndex
	inc	ax
	mov	[ebp-0eh],ax;	iIndex
	mov	eax,[ebp+014h];	pstHeaderPosition
	mov	cx,[ebp-0eh];	iIndex
	cmp	[eax],cx
	ja	@BLBL216
@BLBL215:

; 1077         if (stConfigHeader.bHeaderIsInitialized)
	cmp	word ptr [ebp-066h],0h;	stConfigHeader
	je	@BLBL213

; 1079           if (pstHeaderPosition->wDCBnumber > stConfigHeader.wDCBcount)
	mov	eax,[ebp+014h];	pstHeaderPosition
	mov	cx,[ebp-07ch];	stConfigHeader
	cmp	[eax+02h],cx
	jbe	@BLBL220

; 1080             return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL220:

; 1081           DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-062h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1082           for (iIndex = 0;iIndex < pstHeaderPosition->wDCBnumber;iIndex++)
	mov	word ptr [ebp-0eh],0h;	iIndex
	mov	eax,[ebp+014h];	pstHeaderPosition
	mov	cx,[ebp-0eh];	iIndex
	cmp	[eax+02h],cx
	jbe	@BLBL221
	align 010h
@BLBL222:

; 1084             DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03ah
	lea	eax,[ebp-0b8h];	stDCBheader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h

; 1085             DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-0aeh];	stDCBheader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1086             }

; 1082           for (iIndex = 0;iIndex < pstHeaderPosition->wDCBnumber;iIndex++)
	mov	ax,[ebp-0eh];	iIndex
	inc	ax
	mov	[ebp-0eh],ax;	iIndex
	mov	eax,[ebp+014h];	pstHeaderPosition
	mov	cx,[ebp-0eh];	iIndex
	cmp	[eax+02h],cx
	ja	@BLBL222
@BLBL221:

; 1087           if (stDCBheader.bHeaderIsInitialized)
	cmp	word ptr [ebp-0b0h],0h;	stDCBheader
	je	@BLBL213

; 1089             memcpy(pstDCBheader,&stDCBheader,sizeof(DCBHEAD));
	mov	ecx,03ah
	lea	edx,[ebp-0b8h];	stDCBheader
	mov	eax,[ebp+010h];	pstDCBheader
	call	memcpy

; 1090             memcpy(pstCFGheader,&stConfigHeader,sizeof(CFGHEAD));
	mov	ecx,03eh
	lea	edx,[ebp-07eh];	stConfigHeader
	mov	eax,[ebp+0ch];	pstCFGheader
	call	memcpy

; 1091             bDevFound = TRUE;
	mov	dword ptr [ebp-04h],01h;	bDevFound

; 1092             }

; 1093           }

; 1094         }

; 1095       }
@BLBL213:

; 1096     DosClose(hFile);
	push	dword ptr [ebp-0ch];	hFile
	call	DosClose
	add	esp,04h

; 1097     }
@BLBL212:

; 1098   return(bDevFound);
	mov	eax,[ebp-04h];	bDevFound
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
QueryIniDCBheader	endp

; 1102   {
	align 010h

	public GetPortConfig
GetPortConfig	proc
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

; 1110   if (PrfQueryProfileString(HINI_USERPROFILE,"COMi","Initialization",NULL,(PSZ)szDriverIniSpec,CCHMAXPATH) == 0)
	push	0104h
	lea	eax,[ebp-0181h];	szDriverIniSpec
	push	eax
	push	0h
	push	offset FLAT:@STAT16
	push	offset FLAT:@STAT15
	push	0ffffffffh
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	jne	@BLBL225

; 1111     return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL225:

; 1112   InitializeCFGheader(&stCFGheader);
	lea	eax,[ebp-03eh];	stCFGheader
	push	eax
	call	InitializeCFGheader
	add	esp,04h

; 1113   InitializeDCBheader(&stDCBheader,FALSE);
	push	0h
	lea	eax,[ebp-078h];	stDCBheader
	push	eax
	call	InitializeDCBheader
	add	esp,08h

; 1114   
; 1114 strcpy(stDCBheader.abyPortName,pszPortName);
	mov	edx,[ebp+08h];	pszPortName
	lea	eax,[ebp-078h];	stDCBheader
	call	strcpy

; 1115   MakeDeviceName(stDCBheader.abyPortName);
	lea	eax,[ebp-078h];	stDCBheader
	push	eax
	call	MakeDeviceName
	add	esp,04h

; 1116   stDCBpos.wLoadNumber = 0;
	mov	word ptr [ebp-07ch],0h;	stDCBpos

; 1117   stDCBpos.wDCBnumber = 0;
	mov	word ptr [ebp-07ah],0h;	stDCBpos

; 1118   if (QueryIniDCBheaderName(szDriverIniSpec,&stCFGheader,&stDCBheader,&stDCBpos))
	lea	eax,[ebp-07ch];	stDCBpos
	push	eax
	lea	eax,[ebp-078h];	stDCBheader
	push	eax
	lea	eax,[ebp-03eh];	stCFGheader
	push	eax
	lea	eax,[ebp-0181h];	szDriverIniSpec
	push	eax
	call	QueryIniDCBheaderName
	add	esp,010h
	test	eax,eax
	je	@BLBL226

; 1119     {
; 1120     pstPort->stComDCB.XonChar = stDCBheader.stComDCB.byXonChar;
	mov	eax,[ebp+0ch];	pstPort
	mov	cl,[ebp-044h];	stDCBheader
	mov	[eax+09h],cl

; 1121     pstPort->stComDCB.XoffChar = stDCBheader.stComDCB.byXoffChar;
	mov	eax,[ebp+0ch];	pstPort
	mov	cl,[ebp-043h];	stDCBheader
	mov	[eax+0ah],cl

; 1122     pstPort->stComDCB.ErrChar = stDCBheader.stComDCB.byErrorChar;
	mov	eax,[ebp+0ch];	pstPort
	mov	cl,[ebp-046h];	stDCBheader
	mov	[eax+07h],cl

; 1123     pstPort->stComDCB.BrkChar = stDCBheader.stComDCB.byBreakChar;
	mov	eax,[ebp+0ch];	pstPort
	mov	cl,[ebp-045h];	stDCBheader
	mov	[eax+08h],cl

; 1124     pstPort->stComDCB.WrtTimeout = stDCBheader.stComDCB.wWrtTimeout;
	mov	eax,[ebp+0ch];	pstPort
	mov	cx,[ebp-054h];	stDCBheader
	mov	[eax],cx

; 1125     pstPort->stComDCB.ReadTimeout = stDCBheader.stComDCB.wRdTimeout;
	mov	eax,[ebp+0ch];	pstPort
	mov	cx,[ebp-052h];	stDCBheader
	mov	[eax+02h],cx

; 1126     pstPort->stComDCB.Flags1 = (BYTE)stDCBheader.stComDCB.wFlags1;
	mov	cx,[ebp-05ah];	stDCBheader
	mov	eax,[ebp+0ch];	pstPort
	mov	[eax+04h],cl

; 1127     pstPort->stComDCB.Flags2 = (BYTE)stDCBheader.stComDCB.wFlags2;
	mov	cx,[ebp-058h];	stDCBheader
	mov	eax,[ebp+0ch];	pstPort
	mov	[eax+05h],cl

; 1128     pstPort->stComDCB.Flags3 = (BYTE)stDCBheader.stComDCB.wFlags3;
	mov	cx,[ebp-056h];	stDCBheader
	mov	eax,[ebp+0ch];	pstPort
	mov	[eax+06h],cl

; 1129     pstPort->ulBaudRate = stDCBheader.stComDCB.ulBaudRate;
	mov	eax,[ebp+0ch];	pstPort
	mov	ecx,[ebp-050h];	stDCBheader
	mov	[eax+0bh],ecx

; 1130     byTemp = (stDCBheader.stComDCB.byLineCharacteristics & 0x3f);
	mov	al,[ebp-047h];	stDCBheader
	and	al,03fh
	mov	[ebp-07dh],al;	byTemp

; 1131     pstPort->stLine.DataBits = ((byTemp & LINE_CTL_WORD_LEN_MASK) + 5);
	mov	cl,[ebp-07dh];	byTemp
	and	cl,07h
	add	cl,05h
	mov	eax,[ebp+0ch];	pstPort
	mov	[eax+0fh],cl

; 1132     pstPort->stLine.Parity = ((byTemp >> 3) & 0x0f);
	mov	cl,[ebp-07dh];	byTemp
	shr	cl,03h
	and	cl,0fh
	mov	eax,[ebp+0ch];	pstPort
	mov	[eax+010h],cl

; 1133     if ((byTemp & 0x04) != 0)
	test	byte ptr [ebp-07dh],04h;	byTemp
	je	@BLBL227

; 1134       {
; 1135       if (pstPort->stLine.DataBits == 5)
	mov	eax,[ebp+0ch];	pstPort
	cmp	byte ptr [eax+0fh],05h
	jne	@BLBL228

; 1136         pstPort->stLine.StopBits = 1;
	mov	eax,[ebp+0ch];	pstPort
	mov	byte ptr [eax+011h],01h
	jmp	@BLBL230
	align 010h
@BLBL228:

; 1137       else
; 1138         pstPort->stLine.StopBits = 2;
	mov	eax,[ebp+0ch];	pstPort
	mov	byte ptr [eax+011h],02h

; 1139       }
	jmp	@BLBL230
	align 010h
@BLBL227:

; 1140     else
; 1141       pstPort->stLine.StopBits = 0;
	mov	eax,[ebp+0ch];	pstPort
	mov	byte ptr [eax+011h],0h
@BLBL230:

; 1142     return(TRUE);
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL226:

; 1143     }
; 1144   return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
GetPortConfig	endp

; 1148   {
	align 010h

	public QueryIniDCBheaderName
QueryIniDCBheaderName	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0c0h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,030h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 1149   BOOL bDevFound = FALSE;
	mov	dword ptr [ebp-04h],0h;	bDevFound

; 1150   ULONG ulStatus;
; 1151   HFILE hFile;
; 1152   WORD iIndex;
; 1153   int iDCBindex;
; 1154   ULONG ulCount;
; 1155   CFGINFO stConfigInfo;
; 1156   CFGHEAD stConfigHeader;
; 1157   DCBHEAD stDCBheader;
; 1158   ULONG ulFilePosition;
; 1159 
; 1160   if (DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0312,(PEAOP2)0L) == NO_ERROR)
	push	0h
	push	0312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-08h];	ulStatus
	push	eax
	lea	eax,[ebp-0ch];	hFile
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosOpen
	add	esp,020h
	test	eax,eax
	jne	@BLBL231

; 1161     {
; 1162     if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == NO_ERROR)
	lea	eax,[ebp-018h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-044h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL232

; 1163       {
; 1164       if (stConfigInfo.wCFGheaderCount != 0)
	cmp	word ptr [ebp-03eh],0h;	stConfigInfo
	je	@BLBL232

; 1165         {
; 1166         DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0c0h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-03ch];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1167         for (iIndex = 0;iIndex < stConfigInfo.wCFGheaderCount;iIndex++)
	mov	word ptr [ebp-0eh],0h;	iIndex
	mov	ax,[ebp-03eh];	stConfigInfo
	cmp	[ebp-0eh],ax;	iIndex
	jae	@BLBL232
	align 010h
@BLBL235:

; 1168           {
; 1169           if (bDevFound)
	cmp	dword ptr [ebp-04h],0h;	bDevFound
	jne	@BLBL232

; 1170             break;
; 1171           DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
	lea	eax,[ebp-018h];	ulCount
	push	eax
	push	03eh
	lea	eax,[ebp-082h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h

; 1172           if (!stConfigHeader.bHeaderIsInitialized)
	cmp	word ptr [ebp-06ah],0h;	stConfigHeader
	je	@BLBL239

; 1173             continue;
; 1174           DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0c0h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-066h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1175           for (iDCBindex = 0;iDCBindex < stConfigHeader.wDCBcount;iDCBindex++)
	mov	dword ptr [ebp-014h],0h;	iDCBindex
	xor	eax,eax
	mov	ax,[ebp-080h];	stConfigHeader
	cmp	[ebp-014h],eax;	iDCBindex
	jge	@BLBL240
	align 010h
@BLBL241:

; 1176             {
; 1177             DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
	lea	eax,[ebp-018h];	ulCount
	push	eax
	push	03ah
	lea	eax,[ebp-0bch];	stDCBheader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h

; 1178             if (!stDCBheader.bHeaderIsInitialized)
	cmp	word ptr [ebp-0b4h],0h;	stDCBheader
	je	@BLBL243

; 1179               continue;
; 1180             if (strncmp(pstDCBheader->abyPortName,stDCBheader.abyPortName,8) == 0)
	mov	ecx,08h
	lea	edx,[ebp-0bch];	stDCBheader
	mov	eax,[ebp+010h];	pstDCBheader
	call	strncmp
	test	eax,eax
	jne	@BLBL244

; 1181               {
; 1182               memcpy(pstDCBheader,&stDCBheader,sizeof(DCBHEAD));
	mov	ecx,03ah
	lea	edx,[ebp-0bch];	stDCBheader
	mov	eax,[ebp+010h];	pstDCBheader
	call	memcpy

; 1183               memcpy(pstCFGheader,&stConfigHeader,sizeof(CFGHEAD));
	mov	ecx,03eh
	lea	edx,[ebp-082h];	stConfigHeader
	mov	eax,[ebp+0ch];	pstCFGheader
	call	memcpy

; 1184               pstHeaderPosition->wDCBnumber = iDCBindex + 1;
	mov	ecx,[ebp-014h];	iDCBindex
	inc	ecx
	mov	eax,[ebp+014h];	pstHeaderPosition
	mov	[eax+02h],cx

; 1185               pstHeaderPosition->wLoadNumber = iIndex + 1;
	mov	cx,[ebp-0eh];	iIndex
	inc	cx
	mov	eax,[ebp+014h];	pstHeaderPosition
	mov	[eax],cx

; 1186               bDevFound = TRUE;
	mov	dword ptr [ebp-04h],01h;	bDevFound

; 1187               break;
	jmp	@BLBL240
	align 010h
@BLBL244:

; 1188               }
; 1189             DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0c0h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-0b2h];	stDCBheader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1190             }
@BLBL243:

; 1175           for (iDCBindex = 0;iDCBindex < stConfigHeader.wDCBcount;iDCBindex++)
	mov	eax,[ebp-014h];	iDCBindex
	inc	eax
	mov	[ebp-014h],eax;	iDCBindex
	xor	eax,eax
	mov	ax,[ebp-080h];	stConfigHeader
	cmp	[ebp-014h],eax;	iDCBindex
	jl	@BLBL241
@BLBL240:

; 1191           DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0c0h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-068h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1192           }
@BLBL239:

; 1167         for (iIndex = 0;iIndex < stConfigInfo.wCFGheaderCount;iIndex++)
	mov	ax,[ebp-0eh];	iIndex
	inc	ax
	mov	[ebp-0eh],ax;	iIndex
	mov	ax,[ebp-03eh];	stConfigInfo
	cmp	[ebp-0eh],ax;	iIndex
	jb	@BLBL235

; 1193         }

; 1194       }
@BLBL232:

; 1195     DosClose(hFile);
	push	dword ptr [ebp-0ch];	hFile
	call	DosClose
	add	esp,04h

; 1196     }
@BLBL231:

; 1197   return(bDevFound);
	mov	eax,[ebp-04h];	bDevFound
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
QueryIniDCBheaderName	endp

; 1201   {
	align 010h

	public RemoveIniCFGheader
RemoveIniCFGheader	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0c8h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,032h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 1202   BOOL bRemoved = FALSE;
	mov	dword ptr [ebp-04h],0h;	bRemoved

; 1203   ULONG ulStatus;
; 1204   HFILE hFile;
; 1205   WORD iIndex;
; 1206   ULONG ulCount;
; 1207   WORD wOffset;
; 1208   CFGINFO stConfigInfo;
; 1209   CFGHEAD stConfigHeader;
; 1210   DCBHEAD stDCBheader;
; 1211   ULONG ulFilePosition;
; 1212   ULONG ulSaveConfigHeaderOffset;
; 1213   ULONG ulSaveDCBheaderOffset;
; 1214 
; 1215   if (DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0312,(PEAOP2)0L) == 0)
	push	0h
	push	0312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-08h];	ulStatus
	push	eax
	lea	eax,[ebp-0ch];	hFile
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosOpen
	add	esp,020h
	test	eax,eax
	jne	@BLBL246

; 1216     {
; 1217     if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-042h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL247

; 1218       {
; 1219       if ((wLoadNumber == stConfigInfo.wCFGheaderCount) && (stConfigInfo.wCFGheaderCount > 1))
	mov	ax,[ebp-03ch];	stConfigInfo
	cmp	[ebp+0ch],ax;	wLoadNumber
	jne	@BLBL248
	mov	ax,[ebp-03ch];	stConfigInfo
	cmp	ax,01h
	jbe	@BLBL248

; 1220         {
; 1221         stConfigInfo.wCFGheaderCount--;
	mov	ax,[ebp-03ch];	stConfigInfo
	dec	ax
	mov	[ebp-03ch],ax;	stConfigInfo

; 1222         DosChgFilePtr(hFile,0L,0,&ulFilePosition);
	lea	eax,[ebp-0c0h];	ulFilePosition
	push	eax
	push	0h
	push	0h
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1223         DosWrite(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-042h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosWrite
	add	esp,010h

; 1224         DosSetFileSize(hFile,(sizeof(CFGINFO) +
	xor	eax,eax
	mov	ax,[ebp-03ch];	stConfigInfo
	imul	eax,03deh
	add	eax,02ch
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFileSize
	add	esp,08h

; 1225                              (stConfigInfo.wCFGheaderCount *
; 1226                              (sizeof(CFGHEAD) + (sizeof(DCBHEAD) * MAX_CFG_DEVICE)))));
; 1227         DosClose(hFile);
	push	dword ptr [ebp-0ch];	hFile
	call	DosClose
	add	esp,04h

; 1228         return(bRemoved);
	mov	eax,[ebp-04h];	bRemoved
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL248:

; 1229         }
; 1230       if (stConfigInfo.wCFGheaderCount >= wLoadNumber)
	mov	ax,[ebp+0ch];	wLoadNumber
	cmp	[ebp-03ch],ax;	stConfigInfo
	jb	@BLBL247

; 1231         {
; 1232         if (stConfigInfo.wCFGheaderCount > 1)
	mov	ax,[ebp-03ch];	stConfigInfo
	cmp	ax,01h
	jbe	@BLBL250

; 1233           stConfigInfo.wCFGheaderCount--;
	mov	ax,[ebp-03ch];	stConfigInfo
	dec	ax
	mov	[ebp-03ch],ax;	stConfigInfo
@BLBL250:

; 1234         DosChgFilePtr(hFile,0L,0,&ulFilePosition);
	lea	eax,[ebp-0c0h];	ulFilePosition
	push	eax
	push	0h
	push	0h
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1235         DosWrite(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-042h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosWrite
	add	esp,010h

; 1236         DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0c0h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-03ah];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1237         for (iIndex = 0;iIndex < wLoadNumber;iIndex++)
	mov	word ptr [ebp-0eh],0h;	iIndex
	mov	ax,[ebp+0ch];	wLoadNumber
	cmp	[ebp-0eh],ax;	iIndex
	jae	@BLBL251
	align 010h
@BLBL252:

; 1238           {
; 1239           ulSaveConfigHeaderOffset = ulFilePosition;
	mov	eax,[ebp-0c0h];	ulFilePosition
	mov	[ebp-0c4h],eax;	ulSaveConfigHeaderOffset

; 1240           DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03eh
	lea	eax,[ebp-080h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h

; 1241           DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0c0h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-066h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1242           }

; 1237         for (iIndex = 0;iIndex < wLoadNumber;iIndex++)
	mov	ax,[ebp-0eh];	iIndex
	inc	ax
	mov	[ebp-0eh],ax;	iIndex
	mov	ax,[ebp+0ch];	wLoadNumber
	cmp	[ebp-0eh],ax;	iIndex
	jb	@BLBL252
@BLBL251:

; 1243         DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0c0h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-064h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1244         for (iIndex = 0;iIndex < MAX_CFG_DEVICE;iIndex++)
	mov	word ptr [ebp-0eh],0h;	iIndex
	mov	ax,[ebp-0eh];	iIndex
	cmp	ax,010h
	jae	@BLBL254
	align 010h
@BLBL255:

; 1246           ulSaveDCBheaderOffset = ulFilePosition;
	mov	eax,[ebp-0c0h];	ulFilePosition
	mov	[ebp-0c8h],eax;	ulSaveDCBheaderOffset

; 1247           DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03ah
	lea	eax,[ebp-0bah];	stDCBheader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h

; 1248           wOffset = stDCBheader.oNextDCBheader;
	mov	ax,[ebp-0b0h];	stDCBheader
	mov	[ebp-016h],ax;	wOffset

; 1249           if (stDCBheader.bHeaderIsInitialized)
	cmp	word ptr [ebp-0b2h],0h;	stDCBheader
	je	@BLBL256

; 1251             stDCBheader.bHeaderIsInitialized = FALSE;
	mov	word ptr [ebp-0b2h],0h;	stDCBheader

; 1252             InitializeDCBheader(&stDCBheader,FALSE);
	push	0h
	lea	eax,[ebp-0bah];	stDCBheader
	push	eax
	call	InitializeDCBheader
	add	esp,08h

; 1253             DosChgFilePtr(hFile,ulSaveDCBheaderOffset,0,&ulFilePosition);
	lea	eax,[ebp-0c0h];	ulFilePosition
	push	eax
	push	0h
	mov	eax,[ebp-0c8h];	ulSaveDCBheaderOffset
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1254             DosWrite(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03ah
	lea	eax,[ebp-0bah];	stDCBheader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosWrite
	add	esp,010h

; 1255             }
@BLBL256:

; 1256           DosChgFilePtr(hFile,wOffset,0,&ulFilePosition);
	lea	eax,[ebp-0c0h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-016h];	wOffset
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1257           }

; 1244         for (iIndex = 0;iIndex < MAX_CFG_DEVICE;iIndex++)
	mov	ax,[ebp-0eh];	iIndex
	inc	ax
	mov	[ebp-0eh],ax;	iIndex
	mov	ax,[ebp-0eh];	iIndex
	cmp	ax,010h
	jb	@BLBL255
@BLBL254:

; 1258         stConfigHeader.wDeviceCount = 0;
	mov	word ptr [ebp-080h],0h;	stConfigHeader

; 1259         stConfigHeader.wDCBcount = 0;
	mov	word ptr [ebp-07eh],0h;	stConfigHeader

; 1260         stConfigHeader.bHeaderIsInitialized = FALSE;
	mov	word ptr [ebp-068h],0h;	stConfigHeader

; 1261         stConfigHeader.bHeaderIsAvailable = FALSE;
	mov	word ptr [ebp-06ah],0h;	stConfigHeader

; 1262         stConfigHeader.wIntIDregister = 0;
	mov	word ptr [ebp-06ch],0h;	stConfigHeader

; 1263         stConfigHeader.wDelayCount = 0;
	mov	word ptr [ebp-07ch],0h;	stConfigHeader

; 1264         stConfigHeader.wLoadFlags = 0;
	mov	word ptr [ebp-06eh],0h;	stConfigHeader

; 1265         DosChgFilePtr(hFile,ulSaveConfigHeaderOffset,0,&ulFilePosition);
	lea	eax,[ebp-0c0h];	ulFilePosition
	push	eax
	push	0h
	mov	eax,[ebp-0c4h];	ulSaveConfigHeaderOffset
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1266         DosWrite(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03eh
	lea	eax,[ebp-080h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosWrite
	add	esp,010h

; 1267         bRemoved = TRUE;
	mov	dword ptr [ebp-04h],01h;	bRemoved

; 1268         }

; 1269       }
@BLBL247:

; 1270     DosClose(hFile);
	push	dword ptr [ebp-0ch];	hFile
	call	DosClose
	add	esp,04h

; 1271     }
@BLBL246:

; 1272   return(bRemoved);
	mov	eax,[ebp-04h];	bRemoved
	mov	esp,ebp
	pop	ebp
	ret	
RemoveIniCFGheader	endp

; 1276   {
	align 010h

	public RemoveIniDCBheader
RemoveIniDCBheader	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0c4h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,031h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax

; 1277   BOOL bRemoved = FALSE;
	mov	dword ptr [ebp-04h],0h;	bRemoved

; 1278   ULONG ulStatus;
; 1279   HFILE hFile;
; 1280   WORD iIndex;
; 1281   ULONG ulCount;
; 1282   CFGINFO stConfigInfo;
; 1283   CFGHEAD stConfigHeader;
; 1284   DCBHEAD stDCBheader;
; 1285   ULONG ulFilePosition;
; 1286   ULONG ulSaveConfigHeaderOffset;
; 1287   ULONG ulSaveDCBheaderOffset;
; 1288 
; 1289   if (DosOpen(szFileSpec,&hFile,&ulStatus,0L,0,1,0x0312,(PEAOP2)0L) == 0)
	push	0h
	push	0312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-08h];	ulStatus
	push	eax
	lea	eax,[ebp-0ch];	hFile
	push	eax
	push	dword ptr [ebp+08h];	szFileSpec
	call	DosOpen
	add	esp,020h
	test	eax,eax
	jne	@BLBL258

; 1290     {
; 1291     if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-040h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL259

; 1292       {
; 1293       if (stConfigInfo.wCFGheaderCount >= pstHeaderPosition->wLoadNumber)
	mov	eax,[ebp+0ch];	pstHeaderPosition
	mov	cx,[ebp-03ah];	stConfigInfo
	cmp	[eax],cx
	ja	@BLBL259

; 1294         {
; 1295         DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-038h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1296         for (iIndex = 0;iIndex < pstHeaderPosition->wLoadNumber;iIndex++)
	mov	word ptr [ebp-0eh],0h;	iIndex
	mov	eax,[ebp+0ch];	pstHeaderPosition
	mov	cx,[ebp-0eh];	iIndex
	cmp	[eax],cx
	jbe	@BLBL261
	align 010h
@BLBL262:

; 1297           {
; 1298           ulSaveConfigHeaderOffset = ulFilePosition;
	mov	eax,[ebp-0bch];	ulFilePosition
	mov	[ebp-0c0h],eax;	ulSaveConfigHeaderOffset

; 1299           DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03eh
	lea	eax,[ebp-07eh];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h

; 1300           DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-064h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1301           }

; 1296         for (iIndex = 0;iIndex < pstHeaderPosition->wLoadNumber;iIndex++)
	mov	ax,[ebp-0eh];	iIndex
	inc	ax
	mov	[ebp-0eh],ax;	iIndex
	mov	eax,[ebp+0ch];	pstHeaderPosition
	mov	cx,[ebp-0eh];	iIndex
	cmp	[eax],cx
	ja	@BLBL262
@BLBL261:

; 1302         if (stConfigHeader.bHeaderIsInitialized)
	cmp	word ptr [ebp-066h],0h;	stConfigHeader
	je	@BLBL259

; 1304           DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-062h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1305           for (iIndex = 0;iIndex < pstHeaderPosition->wDCBnumber;iIndex++)
	mov	word ptr [ebp-0eh],0h;	iIndex
	mov	eax,[ebp+0ch];	pstHeaderPosition
	mov	cx,[ebp-0eh];	iIndex
	cmp	[eax+02h],cx
	jbe	@BLBL265
	align 010h
@BLBL266:

; 1307             ulSaveDCBheaderOffset = ulFilePosition;
	mov	eax,[ebp-0bch];	ulFilePosition
	mov	[ebp-0c4h],eax;	ulSaveDCBheaderOffset

; 1308             DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03ah
	lea	eax,[ebp-0b8h];	stDCBheader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h

; 1309             DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-0aeh];	stDCBheader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1310             }

; 1305           for (iIndex = 0;iIndex < pstHeaderPosition->wDCBnumber;iIndex++)
	mov	ax,[ebp-0eh];	iIndex
	inc	ax
	mov	[ebp-0eh],ax;	iIndex
	mov	eax,[ebp+0ch];	pstHeaderPosition
	mov	cx,[ebp-0eh];	iIndex
	cmp	[eax+02h],cx
	ja	@BLBL266
@BLBL265:

; 1311           if (stDCBheader.bHeaderIsInitialized)
	cmp	word ptr [ebp-0b0h],0h;	stDCBheader
	je	@BLBL259

; 1313             stConfigHeader.wDeviceCount--;
	mov	ax,[ebp-07eh];	stConfigHeader
	dec	ax
	mov	[ebp-07eh],ax;	stConfigHeader

; 1314             if (stConfigHeader.wDeviceCount == 0)
	cmp	word ptr [ebp-07eh],0h;	stConfigHeader
	jne	@BLBL269

; 1316               if (stConfigInfo.wCFGheaderCount != 1)
	cmp	word ptr [ebp-03ah],01h;	stConfigInfo
	je	@BLBL270

; 1318                 if (pstHeaderPosition->wLoadNumber >= stConfigInfo.wCFGheaderCount)
	mov	eax,[ebp+0ch];	pstHeaderPosition
	mov	cx,[ebp-03ah];	stConfigInfo
	cmp	[eax],cx
	jb	@BLBL271

; 1320                   stConfigInfo.wCFGheaderCount--;
	mov	ax,[ebp-03ah];	stConfigInfo
	dec	ax
	mov	[ebp-03ah],ax;	stConfigInfo

; 1321     
; 1321               DosChgFilePtr(hFile,0L,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	push	0h
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1322                   DosWrite(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-040h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosWrite
	add	esp,010h

; 1323                   DosSetFileSize(hFile,(sizeof(CFGINFO) + (stConfigInfo.wCFGheaderCount * (sizeof(CFGHEAD) + (sizeof(DCBHEAD) * MAX_CFG_DEVICE)))));
	xor	eax,eax
	mov	ax,[ebp-03ah];	stConfigInfo
	imul	eax,03deh
	add	eax,02ch
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFileSize
	add	esp,08h

; 1324                   DosClose(hFile);
	push	dword ptr [ebp-0ch];	hFile
	call	DosClose
	add	esp,04h

; 1325                   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL271:

; 1327                 stConfigInfo.wCFGheaderCount--;
	mov	ax,[ebp-03ah];	stConfigInfo
	dec	ax
	mov	[ebp-03ah],ax;	stConfigInfo

; 1328                 }
@BLBL270:

; 1329               DosChgFilePtr(hFile,0L,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	push	0h
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1330               DosWrite(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-040h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosWrite
	add	esp,010h

; 1331               stConfigHeader.bHeaderIsInitialized = FALSE;
	mov	word ptr [ebp-066h],0h;	stConfigHeader

; 1332               stConfigHeader.bHeaderIsAvailable = FALSE;
	mov	word ptr [ebp-068h],0h;	stConfigHeader

; 1334               stConfigHeader.wDeviceCount = 0;
	mov	word ptr [ebp-07eh],0h;	stConfigHeader

; 1335               stConfigHeader.wIntIDregister = 0;
	mov	word ptr [ebp-06ah],0h;	stConfigHeader

; 1336               stConfigHeader.wDelayCount = FALSE;
	mov	word ptr [ebp-07ah],0h;	stConfigHeader

; 1337               stConfigHeader.wLoadFlags = 0;
	mov	word ptr [ebp-06ch],0h;	stConfigHeader

; 1338               }
@BLBL269:

; 1339             DosChgFilePtr(hFile,ulSaveConfigHeaderOffset,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	mov	eax,[ebp-0c0h];	ulSaveConfigHeaderOffset
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1340             DosWrite(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03eh
	lea	eax,[ebp-07eh];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosWrite
	add	esp,010h

; 1341             InitializeDCBheader(&stDCBheader,FALSE);
	push	0h
	lea	eax,[ebp-0b8h];	stDCBheader
	push	eax
	call	InitializeDCBheader
	add	esp,08h

; 1342             DosChgFilePtr(hFile,ulSaveDCBheaderOffset,0,&ulFilePosition);
	lea	eax,[ebp-0bch];	ulFilePosition
	push	eax
	push	0h
	mov	eax,[ebp-0c4h];	ulSaveDCBheaderOffset
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1343             DosWrite(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount);
	lea	eax,[ebp-014h];	ulCount
	push	eax
	push	03ah
	lea	eax,[ebp-0b8h];	stDCBheader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosWrite
	add	esp,010h

; 1344             bRemoved = TRUE;
	mov	dword ptr [ebp-04h],01h;	bRemoved

; 1345             }

; 1346           }

; 1347         }

; 1348       }
@BLBL259:

; 1349     DosClose(hFile);
	push	dword ptr [ebp-0ch];	hFile
	call	DosClose
	add	esp,04h

; 1350     }
@BLBL258:

; 1351   return(bRemoved);
	mov	eax,[ebp-04h];	bRemoved
	mov	esp,ebp
	pop	ebp
	ret	
RemoveIniDCBheader	endp

; 1355   {
	align 010h

	public FillDeviceDialogNameListBox
FillDeviceDialogNameListBox	proc
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
	sub	esp,0ch

; 1356   int iItemSelected = 0;
	mov	dword ptr [ebp-04h],0h;	iItemSelected

; 1357   int iIndex;
; 1358   int iItemCount = 0;
	mov	dword ptr [ebp-0ch],0h;	iItemCount

; 1359   BOOL bSelectNext = FALSE;
	mov	dword ptr [ebp-010h],0h;	bSelectNext

; 1360   char *pszName;
; 1361   DEVLIST *pstDevList;
; 1362 
; 1363   for (iIndex = 1;iIndex < 100;iIndex++)
	mov	dword ptr [ebp-08h],01h;	iIndex
	cmp	dword ptr [ebp-08h],064h;	iIndex
	jge	@BLBL272
	align 010h
@BLBL273:

; 1364     {
; 1365     pstDevList = &astConfigDeviceList[iIndex];
	mov	eax,[ebp-08h];	iIndex
	imul	eax,0eh
	add	eax,offset FLAT:astConfigDeviceList
	mov	[ebp-018h],eax;	pstDevList

; 1366     pszName = pstDevList->szName;
	mov	eax,[ebp-018h];	pstDevList
	mov	[ebp-014h],eax;	pszName

; 1367     if (pstDevList->bAvailable)
	mov	eax,[ebp-018h];	pstDevList
	cmp	dword ptr [eax+0ah],0h
	je	@BLBL274

; 1368       {
; 1369       WinSendDlgItemMsg(hwndDlg,PCFG_NAME_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(pszName));
	push	dword ptr [ebp-014h];	pszName
	push	0ffffh
	push	0161h
	push	0130ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 1370       if (iItemSelected == 0)
	cmp	dword ptr [ebp-04h],0h;	iItemSelected
	jne	@BLBL275

; 1371         {
; 1372         if (bSelectNext)
	cmp	dword ptr [ebp-010h],0h;	bSelectNext
	je	@BLBL276

; 1373           iItemSelected = iItemCount;
	mov	eax,[ebp-0ch];	iItemCount
	mov	[ebp-04h],eax;	iItemSelected
@BLBL276:

; 1374         if (szCurrentName[0] != 0)
	mov	eax,[ebp+0ch];	szCurrentName
	cmp	byte ptr [eax],0h
	je	@BLBL277

; 1375           {
; 1376           if (strcmp(szCurrentName,pszName) == 0)
	mov	edx,[ebp-014h];	pszName
	mov	eax,[ebp+0ch];	szCurrentName
	call	strcmp
	test	eax,eax
	jne	@BLBL275

; 1377             {
; 1378             strncpy(szPortName,pszName,5);
	mov	ecx,05h
	mov	edx,[ebp-014h];	pszName
	mov	eax,[ebp+010h];	szPortName
	call	strncpy

; 1379             iItemSelected = iItemCount;
	mov	eax,[ebp-0ch];	iItemCount
	mov	[ebp-04h],eax;	iItemSelected

; 1380             }

; 1381           }
	jmp	@BLBL275
	align 010h
@BLBL277:

; 1382         else
; 1383           if (szLastName[0] != 0)
	cmp	byte ptr  szLastName,0h
	je	@BLBL275

; 1384             {
; 1385             if (strcmp(szLastName,pszName) == 0)
	mov	edx,[ebp-014h];	pszName
	mov	eax,offset FLAT:szLastName
	call	strcmp
	test	eax,eax
	jne	@BLBL275

; 1386               bSelectNext = TRUE;
	mov	dword ptr [ebp-010h],01h;	bSelectNext

; 1387             }

; 1388         }
@BLBL275:

; 1389       iItemCount++;
	mov	eax,[ebp-0ch];	iItemCount
	inc	eax
	mov	[ebp-0ch],eax;	iItemCount

; 1390       }
	jmp	@BLBL282
	align 010h
@BLBL274:

; 1391     else
; 1392       {
; 1393       if (iItemSelected == 0)
	cmp	dword ptr [ebp-04h],0h;	iItemSelected
	jne	@BLBL282

; 1394         {
; 1395         if (szCurrentName[0] != 0)
	mov	eax,[ebp+0ch];	szCurrentName
	cmp	byte ptr [eax],0h
	je	@BLBL284

; 1396           {
; 1397           if (strcmp(szCurrentName,pszName) == 0)
	mov	edx,[ebp-014h];	pszName
	mov	eax,[ebp+0ch];	szCurrentName
	call	strcmp
	test	eax,eax
	jne	@BLBL282

; 1398             {
; 1399             strcpy(szPortName,pszName);
	mov	edx,[ebp-014h];	pszName
	mov	eax,[ebp+010h];	szPortName
	call	strcpy

; 1400             WinSendDlgItemMsg(hwndDlg,PCFG_NAME_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(pszName));
	push	dword ptr [ebp-014h];	pszName
	push	0ffffh
	push	0161h
	push	0130ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 1401             iItemSelected = iItemCount;
	mov	eax,[ebp-0ch];	iItemCount
	mov	[ebp-04h],eax;	iItemSelected

; 1402             }

; 1403           }
	jmp	@BLBL282
	align 010h
@BLBL284:

; 1404         else
; 1405           {
; 1406           if (szLastName[0] != 0)
	cmp	byte ptr  szLastName,0h
	je	@BLBL282

; 1407             if (strcmp(szLastName,pszName) == 0)
	mov	edx,[ebp-014h];	pszName
	mov	eax,offset FLAT:szLastName
	call	strcmp
	test	eax,eax
	jne	@BLBL282

; 1408               bSelectNext = TRUE;
	mov	dword ptr [ebp-010h],01h;	bSelectNext

; 1409           }

; 1410         }

; 1411       }
@BLBL282:

; 1412     }

; 1363   for (iIndex = 1;iIndex < 100;iIndex++)
	mov	eax,[ebp-08h];	iIndex
	inc	eax
	mov	[ebp-08h],eax;	iIndex
	cmp	dword ptr [ebp-08h],064h;	iIndex
	jl	@BLBL273
@BLBL272:

; 1413   return(iItemSelected);
	mov	eax,[ebp-04h];	iItemSelected
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
FillDeviceDialogNameListBox	endp

; 1417   {
	align 010h

	public GetNextAvailableAddress
GetNextAvailableAddress	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax

; 1418   LINKLIST *pListItem = NULL;
	mov	dword ptr [ebp-04h],0h;	pListItem

; 1419   WORD *pWord;
; 1420   WORD wAddress;
; 1421 
; 1422   if (pAddressList->pData != NULL)
	mov	eax,dword ptr  pAddressList
	cmp	dword ptr [eax+08h],0h
	je	@BLBL290

; 1423     {
; 1424     for (wAddress = *pwAddress;wAddress <= 0xfff8;wAddress += 8)
	mov	eax,[ebp+08h];	pwAddress
	mov	ax,[eax]
	mov	[ebp-0ah],ax;	wAddress
	mov	ax,[ebp-0ah];	wAddress
	cmp	ax,0fff8h
	ja	@BLBL291
	align 010h
@BLBL292:

; 1425       {
; 1426       pListItem = pAddressList;
	mov	eax,dword ptr  pAddressList
	mov	[ebp-04h],eax;	pListItem

; 1427       do
	align 010h
@BLBL293:

; 1428         {
; 1429         pWord = (WORD *)pListItem->pData;
	mov	eax,[ebp-04h];	pListItem
	mov	eax,[eax+08h]
	mov	[ebp-08h],eax;	pWord

; 1430         if (wAddress == *pWord)
	mov	eax,[ebp-08h];	pWord
	mov	cx,[ebp-0ah];	wAddress
	cmp	[eax],cx
	je	@BLBL295

; 1431           break;
; 1432         } while ((pListItem = GetNextListItem(pListItem)) != NULL);
	push	dword ptr [ebp-04h];	pListItem
	call	GetNextListItem
	add	esp,04h
	mov	[ebp-04h],eax;	pListItem
	cmp	dword ptr [ebp-04h],0h;	pListItem
	jne	@BLBL293
@BLBL295:

; 1433       if (wAddress != *pWord)
	mov	eax,[ebp-08h];	pWord
	mov	cx,[ebp-0ah];	wAddress
	cmp	[eax],cx
	jne	@BLBL291

; 1434         break;
; 1435       }

; 1424     for (wAddress = *pwAddress;wAddress <= 0xfff8;wAddress += 8)
	mov	ax,[ebp-0ah];	wAddress
	add	ax,08h
	mov	[ebp-0ah],ax;	wAddress
	mov	ax,[ebp-0ah];	wAddress
	cmp	ax,0fff8h
	jbe	@BLBL292
@BLBL291:

; 1436     if (wAddress > 0xfff8)
	mov	ax,[ebp-0ah];	wAddress
	cmp	ax,0fff8h
	jbe	@BLBL298

; 1438       for (wAddress = 0x100;wAddress <= *pwAddress;wAddress += 8)
	mov	word ptr [ebp-0ah],0100h;	wAddress
	mov	eax,[ebp+08h];	pwAddress
	mov	cx,[ebp-0ah];	wAddress
	cmp	[eax],cx
	jb	@BLBL299
	align 010h
@BLBL300:

; 1440         pListItem = pAddressList;
	mov	eax,dword ptr  pAddressList
	mov	[ebp-04h],eax;	pListItem

; 1441         do
	align 010h
@BLBL301:

; 1443           pWord = (WORD *)pListItem->pData;
	mov	eax,[ebp-04h];	pListItem
	mov	eax,[eax+08h]
	mov	[ebp-08h],eax;	pWord

; 1444           if (wAddress == *pWord)
	mov	eax,[ebp-08h];	pWord
	mov	cx,[ebp-0ah];	wAddress
	cmp	[eax],cx
	je	@BLBL303

; 1446           } while ((pListItem = GetNextListItem(pListItem)) != NULL);
	push	dword ptr [ebp-04h];	pListItem
	call	GetNextListItem
	add	esp,04h
	mov	[ebp-04h],eax;	pListItem
	cmp	dword ptr [ebp-04h],0h;	pListItem
	jne	@BLBL301
@BLBL303:

; 1447         if (wAddress != *pWord)
	mov	eax,[ebp-08h];	pWord
	mov	cx,[ebp-0ah];	wAddress
	cmp	[eax],cx
	jne	@BLBL299

; 1449         }

; 1438       for (wAddress = 0x100;wAddress <= *pwAddress;wAddress += 8)
	mov	ax,[ebp-0ah];	wAddress
	add	ax,08h
	mov	[ebp-0ah],ax;	wAddress
	mov	eax,[ebp+08h];	pwAddress
	mov	cx,[ebp-0ah];	wAddress
	cmp	[eax],cx
	jae	@BLBL300
@BLBL299:

; 1450       if (wAddress > *pwAddress)
	mov	eax,[ebp+08h];	pwAddress
	mov	cx,[ebp-0ah];	wAddress
	cmp	[eax],cx
	jae	@BLBL298

; 1451         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL298:

; 1453     *pwAddress = wAddress;
	mov	eax,[ebp+08h];	pwAddress
	mov	cx,[ebp-0ah];	wAddress
	mov	[eax],cx

; 1454     }
@BLBL290:

; 1455   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
GetNextAvailableAddress	endp

; 1459   {
	align 010h

	public GetNextAvailableInterrupt
GetNextAvailableInterrupt	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0ch
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	mov	[esp+0ch],eax
	pop	eax

; 1460   LINKLIST *pListItem = NULL;
	mov	dword ptr [ebp-04h],0h;	pListItem

; 1461   BYTE *pByte;
; 1462   BYTE byIntLevel;
; 1463 
; 1464   if (pInterruptList->pData != NULL)
	mov	eax,dword ptr  pInterruptList
	cmp	dword ptr [eax+08h],0h
	je	@BLBL307

; 1465     {
; 1466     for (byIntLevel = *pbyIntLevel;byIntLevel <= 15;byIntLevel++)
	mov	eax,[ebp+08h];	pbyIntLevel
	mov	al,[eax]
	mov	[ebp-09h],al;	byIntLevel
	mov	al,[ebp-09h];	byIntLevel
	cmp	al,0fh
	ja	@BLBL308
	align 010h
@BLBL309:

; 1467       {
; 1468       pListItem = pInterruptList;
	mov	eax,dword ptr  pInterruptList
	mov	[ebp-04h],eax;	pListItem

; 1469       do
	align 010h
@BLBL310:

; 1470         {
; 1471         if ((pByte  = (BYTE *)pListItem->pData) == NULL)
	mov	eax,[ebp-04h];	pListItem
	mov	eax,[eax+08h]
	mov	[ebp-08h],eax;	pByte
	cmp	dword ptr [ebp-08h],0h;	pByte
	je	@BLBL312

; 1472           break;
; 1473         if (byIntLevel == *pByte)
	mov	eax,[ebp-08h];	pByte
	mov	cl,[ebp-09h];	byIntLevel
	cmp	[eax],cl
	je	@BLBL312

; 1474           break;
; 1475         } while ((pListItem = GetNextListItem(pListItem)) != NULL);
	push	dword ptr [ebp-04h];	pListItem
	call	GetNextListItem
	add	esp,04h
	mov	[ebp-04h],eax;	pListItem
	cmp	dword ptr [ebp-04h],0h;	pListItem
	jne	@BLBL310
@BLBL312:

; 1476       if (byIntLevel != *pByte)
	mov	eax,[ebp-08h];	pByte
	mov	cl,[ebp-09h];	byIntLevel
	cmp	[eax],cl
	jne	@BLBL308

; 1477         break;
; 1478       }

; 1466     for (byIntLevel = *pbyIntLevel;byIntLevel <= 15;byIntLevel++)
	mov	al,[ebp-09h];	byIntLevel
	inc	al
	mov	[ebp-09h],al;	byIntLevel
	mov	al,[ebp-09h];	byIntLevel
	cmp	al,0fh
	jbe	@BLBL309
@BLBL308:

; 1479     if (byIntLevel > 15)
	mov	al,[ebp-09h];	byIntLevel
	cmp	al,0fh
	jbe	@BLBL326

; 1481       for (byIntLevel = 2;byIntLevel <= *pbyIntLevel;byIntLevel++)
	mov	byte ptr [ebp-09h],02h;	byIntLevel
	mov	eax,[ebp+08h];	pbyIntLevel
	mov	cl,[ebp-09h];	byIntLevel
	cmp	[eax],cl
	jb	@BLBL317
	align 010h
@BLBL318:

; 1483         pListItem = pInterruptList;
	mov	eax,dword ptr  pInterruptList
	mov	[ebp-04h],eax;	pListItem

; 1484         do                {
	align 010h
@BLBL319:

; 1485           if ((pByte = (BYTE *)pListItem->pData) == NULL)
	mov	eax,[ebp-04h];	pListItem
	mov	eax,[eax+08h]
	mov	[ebp-08h],eax;	pByte
	cmp	dword ptr [ebp-08h],0h;	pByte
	je	@BLBL321

; 1487           if (byIntLevel == *pByte)
	mov	eax,[ebp-08h];	pByte
	mov	cl,[ebp-09h];	byIntLevel
	cmp	[eax],cl
	je	@BLBL321

; 1489           } while ((pListItem = GetNextListItem(pListItem)) != NULL);
	push	dword ptr [ebp-04h];	pListItem
	call	GetNextListItem
	add	esp,04h
	mov	[ebp-04h],eax;	pListItem
	cmp	dword ptr [ebp-04h],0h;	pListItem
	jne	@BLBL319
@BLBL321:

; 1490         if (byIntLevel != *pByte)
	mov	eax,[ebp-08h];	pByte
	mov	cl,[ebp-09h];	byIntLevel
	cmp	[eax],cl
	jne	@BLBL317

; 1492         }

; 1481       for (byIntLevel = 2;byIntLevel <= *pbyIntLevel;byIntLevel++)
	mov	al,[ebp-09h];	byIntLevel
	inc	al
	mov	[ebp-09h],al;	byIntLevel
	mov	eax,[ebp+08h];	pbyIntLevel
	mov	cl,[ebp-09h];	byIntLevel
	cmp	[eax],cl
	jae	@BLBL318
@BLBL317:

; 1493       if (byIntLevel > *pbyIntLevel)
	mov	eax,[ebp+08h];	pbyIntLevel
	mov	cl,[ebp-09h];	byIntLevel
	cmp	[eax],cl
	jae	@BLBL326

; 1494         return(FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL307:

; 1498     byIntLevel = 4;
	mov	byte ptr [ebp-09h],04h;	byIntLevel
@BLBL326:

; 1499   *pbyIntLevel = byIntLevel;
	mov	eax,[ebp+08h];	pbyIntLevel
	mov	cl,[ebp-09h];	byIntLevel
	mov	[eax],cl

; 1500   return(TRUE);
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
GetNextAvailableInterrupt	endp

; 1504   {
	align 010h

	public GetDriverVersion
GetDriverVersion	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h

; 1505   if (szDriverVersionString[0] == 0)
	cmp	byte ptr  szDriverVersionString,0h
	jne	@BLBL327

; 1506     return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL327:

; 1507   strcpy(szVersion,szDriverVersionString);
	mov	edx,offset FLAT:szDriverVersionString
	mov	eax,[ebp+08h];	szVersion
	call	strcpy

; 1508   *pulSignature = ulCOMiSignature;
	mov	eax,[ebp+0ch];	pulSignature
	mov	ecx,dword ptr  ulCOMiSignature
	mov	[eax],ecx

; 1509   return(TRUE);
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
GetDriverVersion	endp

; 1513   {
	align 010h

	public GetDriverInfo
GetDriverInfo	proc
	push	ebp
	mov	ebp,esp
	sub	esp,02ch
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,0bh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 1514   APIRET rc = 0;
	mov	dword ptr [ebp-04h],0h;	rc

; 1515   ULONG ulDataLen;
; 1516   ULONG ulParmLen;
; 1517   EXTPARM stParams;
; 1518   EXTDATA *pstData;
; 1519   int iIndex;
; 1520   BYTE *pByte;
; 1521   WORD *pWord;
; 1522   HFILE hCom;
; 1523   ULONG ulAction;
; 1524 
; 1525   szDriverIniPath[0] = 0;
	mov	byte ptr  szDriverIniPath,0h

; 1526   szDriverVersionString[0] = 0;
	mov	byte ptr  szDriverVersionString,0h

; 1527   byDDOEMtype = 0;
	mov	byte ptr  byDDOEMtype,0h

; 1528   if ((rc = DosOpen(SPECIAL_DEVICE,&hCom,&ulAction,0L,0L,0x0001,0x21c2,0L)) != NO_ERROR)
	push	0h
	push	021c2h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-02ch];	ulAction
	push	eax
	lea	eax,[ebp-028h];	hCom
	push	eax
	push	offset FLAT:@STAT17
	call	DosOpen
	add	esp,020h
	mov	[ebp-04h],eax;	rc
	cmp	dword ptr [ebp-04h],0h;	rc
	je	@BLBL328

; 1529     return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL328:

; 1530   if ((rc = DosAllocMem((PPVOID)&pstData,(sizeof(EXTDATA) + MAX_DD_PATH),PAG_COMMIT | PAG_READ | PAG_WRITE)) != 0)
	push	013h
	push	0206h
	lea	eax,[ebp-018h];	pstData
	push	eax
	call	DosAllocMem
	add	esp,0ch
	mov	[ebp-04h],eax;	rc
	cmp	dword ptr [ebp-04h],0h;	rc
	je	@BLBL329

; 1531 		{
; 1532 #if DEBUG > 0
; 1533     sprintf(szMessage,"Error Allocating Memory for DD PATH - %X",rc);
	push	dword ptr [ebp-04h];	rc
	mov	edx,offset FLAT:@STAT18
	mov	eax,offset FLAT:szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1534     MessageBox(HWND_DESKTOP,szMessage);
	push	offset FLAT:szMessage
	push	01h
	call	MessageBox
	add	esp,08h

; 1535 #endif
; 1536     DosClose(hCom);
	push	dword ptr [ebp-028h];	hCom
	call	DosClose
	add	esp,04h

; 1537     return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL329:

; 1538     }
; 1539   else
; 1540     {
; 1541     /*
; 1542     **  Get device driver path
; 1543     */
; 1544     stParams.wSignature = SIGNATURE;
	mov	word ptr [ebp-014h],02642h;	stParams

; 1545     stParams.wDataCount = MAX_DD_PATH;
	mov	word ptr [ebp-0eh],0200h;	stParams

; 1546     stParams.wCommand = EXT_CMD_GET_PATH;
	mov	word ptr [ebp-012h],02h;	stParams

; 1547     stParams.wModifier = 0;
	mov	word ptr [ebp-010h],0h;	stParams

; 1548     ulDataLen = (ULONG)(sizeof(EXTDATA) + MAX_DD_PATH);
	mov	dword ptr [ebp-08h],0206h;	ulDataLen

; 1549     ulParmLen = (ULONG)sizeof(EXTPARM);
	mov	dword ptr [ebp-0ch],08h;	ulParmLen

; 1550     if ((rc = DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,pstData,(sizeof(EXTDATA) + MAX_DD_PATH),&ulDataLen)) != 0)
	lea	eax,[ebp-08h];	ulDataLen
	push	eax
	push	0206h
	push	dword ptr [ebp-018h];	pstData
	lea	eax,[ebp-0ch];	ulParmLen
	push	eax
	push	08h
	lea	eax,[ebp-014h];	stParams
	push	eax
	push	07ch
	push	01h
	push	dword ptr [ebp-028h];	hCom
	call	DosDevIOCtl
	add	esp,024h
	mov	[ebp-04h],eax;	rc
	cmp	dword ptr [ebp-04h],0h;	rc
	je	@BLBL331

; 1551       {
; 1552 #if DEBUG > 0
; 1553       sprintf(szMessage,"DOS Error Accessing Extension - %X",rc);
	push	dword ptr [ebp-04h];	rc
	mov	edx,offset FLAT:@STAT19
	mov	eax,offset FLAT:szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1554       MessageBox(HWND_DESKTOP,szMessage);
	push	offset FLAT:szMessage
	push	01h
	call	MessageBox
	add	esp,08h

; 1555 #endif
; 1556       DosFreeMem(pstData);
	push	dword ptr [ebp-018h];	pstData
	call	DosFreeMem
	add	esp,04h

; 1557       DosClose(hCom);
	push	dword ptr [ebp-028h];	hCom
	call	DosClose
	add	esp,04h

; 1558       return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL331:

; 1559       }
; 1560     else
; 1561       {
; 1562       if (pstData->wReturnCode != EXT_RSP_SUCCESS)
	mov	eax,[ebp-018h];	pstData
	cmp	word ptr [eax],0f00h
	je	@BLBL332

; 1563         {
; 1564         if ((pstData->wReturnCode & EXT_BAD_SIGNATURE) != EXT_BAD_SIGNATURE)
	mov	eax,[ebp-018h];	pstData
	mov	ax,[eax]
	and	ax,0f000h
	cmp	ax,0f000h
	je	@BLBL334

; 1565           {
; 1566 #if DEBUG > 0
; 1567           sprintf(szMessage,"Extension Access Error - %04X-%04X",stParams.wCommand,pstData->wReturnCode);
	mov	ecx,[ebp-018h];	pstData
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	xor	eax,eax
	mov	ax,[ebp-012h];	stParams
	push	eax
	mov	edx,offset FLAT:@STAT1a
	mov	eax,offset FLAT:szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 1568           MessageBox(HWND_DESKTOP,szMessage);
	push	offset FLAT:szMessage
	push	01h
	call	MessageBox
	add	esp,08h

; 1569 #endif
; 1570           DosFreeMem(pstData);
	push	dword ptr [ebp-018h];	pstData
	call	DosFreeMem
	add	esp,04h

; 1571           DosClose(hCom);
	push	dword ptr [ebp-028h];	hCom
	call	DosClose
	add	esp,04h

; 1572           return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL334:

; 1573           }
; 1574         rc = pstData->wReturnCode;
	mov	ecx,[ebp-018h];	pstData
	xor	eax,eax
	mov	ax,[ecx]
	mov	[ebp-04h],eax;	rc

; 1575         }

; 1576       }
@BLBL332:

; 1577     bDeviceIniFileSelected = TRUE;
	mov	dword ptr  bDeviceIniFileSelected,01h

; 1578     pByte = (BYTE *)(&pstData->wData);
	mov	eax,[ebp-018h];	pstData
	add	eax,04h
	mov	[ebp-020h],eax;	pByte

; 1579     for (iIndex = 0;iIndex < (CCHMAXPATH - 1);iIndex++)
	mov	dword ptr [ebp-01ch],0h;	iIndex
	cmp	dword ptr [ebp-01ch],0103h;	iIndex
	jge	@BLBL335
	align 010h
@BLBL336:

; 1580       {
; 1581       szDriverIniPath[iIndex] = toupper(*pByte);
	mov	ecx,dword ptr  _ctype
	mov	edx,[ebp-020h];	pByte
	xor	eax,eax
	mov	al,[edx]
	mov	cx,word ptr [ecx+eax*02h+0202h]
	mov	eax,[ebp-01ch];	iIndex
	mov	byte ptr [eax+ szDriverIniPath],cl

; 1582       if (*(pByte++) == ' ')
	mov	eax,[ebp-020h];	pByte
	cmp	byte ptr [eax],020h
	jne	@BLBL337
	mov	eax,[ebp-020h];	pByte
	inc	eax
	mov	[ebp-020h],eax;	pByte

; 1583         break;
	jmp	@BLBL335
	align 010h
@BLBL337:
	mov	eax,[ebp-020h];	pByte
	inc	eax
	mov	[ebp-020h],eax;	pByte

; 1584       }

; 1579     for (iIndex = 0;iIndex < (CCHMAXPATH - 1);iIndex++)
	mov	eax,[ebp-01ch];	iIndex
	inc	eax
	mov	[ebp-01ch],eax;	iIndex
	cmp	dword ptr [ebp-01ch],0103h;	iIndex
	jl	@BLBL336
@BLBL335:

; 1585     szDriverIniPath[iIndex] = 0;
	mov	eax,[ebp-01ch];	iIndex
	mov	byte ptr [eax+ szDriverIniPath],0h

; 1586     strcpy(szTempFilePath,szDriverIniPath);
	mov	edx,offset FLAT:szDriverIniPath
	mov	eax,offset FLAT:szTempFilePath
	call	strcpy

; 1587     AppendINI(szDriverIniPath);
	push	offset FLAT:szDriverIniPath
	call	AppendINI
	add	esp,04h

; 1588     AppendTMP(szTempFilePath);
	push	offset FLAT:szTempFilePath
	call	AppendTMP
	add	esp,04h

; 1589     strcpy(szDriverVersionString,pByte);
	mov	edx,[ebp-020h];	pByte
	mov	eax,offset FLAT:szDriverVersionString
	call	strcpy

; 1590     szDriverVersionString[strlen(szDriverVersionString) - 2] = 0;
	mov	eax,offset FLAT:szDriverVersionString
	call	strlen
	mov	byte ptr [eax+ szDriverVersionString-02h],0h

; 1594     stParams.wSignature = SIGNATURE;
	mov	word ptr [ebp-014h],02642h;	stParams

; 1595     stParams.wDataCount = sizeof(USHORT);
	mov	word ptr [ebp-0eh],02h;	stParams

; 1596     stParams.wCommand = EXT_CMD_GET_MAX_DEVICE_COUNT;
	mov	word ptr [ebp-012h],0ah;	stParams

; 1597     stParams.wModifier = 0;
	mov	word ptr [ebp-010h],0h;	stParams

; 1598     ulDataLen = (UL
; 1598 ONG)(sizeof(EXTDATA));
	mov	dword ptr [ebp-08h],06h;	ulDataLen

; 1599     ulParmLen = (ULONG)sizeof(EXTPARM);
	mov	dword ptr [ebp-0ch],08h;	ulParmLen

; 1600     if (DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,pstData,sizeof(EXTDATA),&ulDataLen) == NO_ERROR)
	lea	eax,[ebp-08h];	ulDataLen
	push	eax
	push	06h
	push	dword ptr [ebp-018h];	pstData
	lea	eax,[ebp-0ch];	ulParmLen
	push	eax
	push	08h
	lea	eax,[ebp-014h];	stParams
	push	eax
	push	07ch
	push	01h
	push	dword ptr [ebp-028h];	hCom
	call	DosDevIOCtl
	add	esp,024h
	test	eax,eax
	jne	@BLBL340

; 1602       if (pstData->wReturnCode == EXT_RSP_SUCCESS)
	mov	eax,[ebp-018h];	pstData
	cmp	word ptr [eax],0f00h
	jne	@BLBL341

; 1604         pWord = (WORD *)(&pstData->wData);
	mov	eax,[ebp-018h];	pstData
	add	eax,04h
	mov	[ebp-024h],eax;	pWord

; 1605         wDDmaxDeviceCount = *pWord;
	mov	eax,[ebp-024h];	pWord
	mov	ax,[eax]
	mov	word ptr  wDDmaxDeviceCount,ax

; 1613         }
	jmp	@BLBL343
	align 010h
@BLBL341:

; 1617         sprintf(szMessage,"Unable to get Device Count Restrictions, COMi EXT error = %u",pstData->wReturnCode);
	mov	ecx,[ebp-018h];	pstData
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT1b
	mov	eax,offset FLAT:szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1618         MessageBox(HWND_DESKTOP,szMessage);
	push	offset FLAT:szMessage
	push	01h
	call	MessageBox
	add	esp,08h

; 1619         }

; 1621       }
	jmp	@BLBL343
	align 010h
@BLBL340:

; 1625       sprintf(szMessage,"Unable to get Device Count Restrictions, DOS error = %u",rc);
	push	dword ptr [ebp-04h];	rc
	mov	edx,offset FLAT:@STAT1c
	mov	eax,offset FLAT:szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1626       MessageBox(HWND_DESKTOP,szMessage);
	push	offset FLAT:szMessage
	push	01h
	call	MessageBox
	add	esp,08h

; 1627       }
@BLBL343:

; 1632     stParams.wSignature = SIGNATURE;
	mov	word ptr [ebp-014h],02642h;	stParams

; 1633     stParams.wDataCount = sizeof(USHORT);
	mov	word ptr [ebp-0eh],02h;	stParams

; 1634     stParams.wCommand = EXT_CMD_GET_OEM_TYPE;
	mov	word ptr [ebp-012h],08h;	stParams

; 1635     stParams.wModifier = 0;
	mov	word ptr [ebp-010h],0h;	stParams

; 1636     ulDataLen = sizeof(EXTDATA);
	mov	dword ptr [ebp-08h],06h;	ulDataLen

; 1637     ulParmLen = sizeof(EXTPARM);
	mov	dword ptr [ebp-0ch],08h;	ulParmLen

; 1638     if (DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,pstData,sizeof(EXTDATA),&ulDataLen) == NO_ERROR)
	lea	eax,[ebp-08h];	ulDataLen
	push	eax
	push	06h
	push	dword ptr [ebp-018h];	pstData
	lea	eax,[ebp-0ch];	ulParmLen
	push	eax
	push	08h
	lea	eax,[ebp-014h];	stParams
	push	eax
	push	07ch
	push	01h
	push	dword ptr [ebp-028h];	hCom
	call	DosDevIOCtl
	add	esp,024h
	test	eax,eax
	jne	@BLBL344

; 1640       if (pstData->wReturnCode == EXT_RSP_SUCCESS)
	mov	eax,[ebp-018h];	pstData
	cmp	word ptr [eax],0f00h
	jne	@BLBL345

; 1642         pWord = (WORD *)(&pstData->wData);
	mov	eax,[ebp-018h];	pstData
	add	eax,04h
	mov	[ebp-024h],eax;	pWord

; 1643         byDDOEMtype = (BYTE)*pWord;
	mov	eax,[ebp-024h];	pWord
	mov	ax,[eax]
	mov	byte ptr  byDDOEMtype,al

; 1644         if (byDDOEMtype & 0x80)
	test	byte ptr  byDDOEMtype,080h
	je	@BLBL348

; 1646           bLimitLoad = TRUE;
	mov	dword ptr  bLimitLoad,01h

; 1647           byDDOEMtype &= 0x7f;
	mov	al,byte ptr  byDDOEMtype
	and	al,07fh
	mov	byte ptr  byDDOEMtype,al

; 1648           }

; 1656         }
	jmp	@BLBL348
	align 010h
@BLBL345:

; 1660         sprintf(szMessage,"Unable to get OEM type COMi EXT error = %u",pstData->wReturnCode);
	mov	ecx,[ebp-018h];	pstData
	xor	eax,eax
	mov	ax,[ecx]
	push	eax
	mov	edx,offset FLAT:@STAT1d
	mov	eax,offset FLAT:szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1661         MessageBox(HWND_DESKTOP,szMessage);
	push	offset FLAT:szMessage
	push	01h
	call	MessageBox
	add	esp,08h

; 1662         }

; 1664       }
	jmp	@BLBL348
	align 010h
@BLBL344:

; 1668       sprintf(szMessage,"Unable to get OEM type DOS error = %u",rc);
	push	dword ptr [ebp-04h];	rc
	mov	edx,offset FLAT:@STAT1e
	mov	eax,offset FLAT:szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1669       MessageBox(HWND_DESKTOP,szMessage);
	push	offset FLAT:szMessage
	push	01h
	call	MessageBox
	add	esp,08h

; 1670       }
@BLBL348:

; 1675     stParams.wSignature = SIGNATURE;
	mov	word ptr [ebp-014h],02642h;	stParams

; 1676     stParams.wDataCount = sizeof(USHORT);
	mov	word ptr [ebp-0eh],02h;	stParams

; 1677     stParams.wCommand = EXT_CMD_GET_SIGNATURE;
	mov	word ptr [ebp-012h],07h;	stParams

; 1678     stParams.wModifier = 0;
	mov	word ptr [ebp-010h],0h;	stParams

; 1679     ulDataLen = sizeof(EXTDATA);
	mov	dword ptr [ebp-08h],06h;	ulDataLen

; 1680     ulParmLen = sizeof(EXTPARM);
	mov	dword ptr [ebp-0ch],08h;	ulParmLen

; 1681     if ((rc = DosDevIOCtl(hCom,0x01,0x7c,&stParams,sizeof(EXTPARM),&ulParmLen,pstData,sizeof(EXTDATA),&ulDataLen)) != 0)
	lea	eax,[ebp-08h];	ulDataLen
	push	eax
	push	06h
	push	dword ptr [ebp-018h];	pstData
	lea	eax,[ebp-0ch];	ulParmLen
	push	eax
	push	08h
	lea	eax,[ebp-014h];	stParams
	push	eax
	push	07ch
	push	01h
	push	dword ptr [ebp-028h];	hCom
	call	DosDevIOCtl
	add	esp,024h
	mov	[ebp-04h],eax;	rc
	cmp	dword ptr [ebp-04h],0h;	rc
	je	@BLBL349

; 1684       sprintf(szMessage,"DOS Error Accessing COMi Extension - %X",rc);
	push	dword ptr [ebp-04h];	rc
	mov	edx,offset FLAT:@STAT1f
	mov	eax,offset FLAT:szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1685       MessageBox(HWND_DESKTOP,szMessage);
	push	offset FLAT:szMessage
	push	01h
	call	MessageBox
	add	esp,08h

; 1687       DosFreeMem(pstData);
	push	dword ptr [ebp-018h];	pstData
	call	DosFreeMem
	add	esp,04h

; 1688       DosClose(hCom);
	push	dword ptr [ebp-028h];	hCom
	call	DosClose
	add	esp,04h

; 1689       return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL349:

; 1693       if (pstData->wReturnCode != EXT_RSP_SUCCESS)
	mov	eax,[ebp-018h];	pstData
	cmp	word ptr [eax],0f00h
	je	@BLBL350

; 1696         rc = pstData->wReturnCode;
	mov	ecx,[ebp-018h];	pstData
	xor	eax,eax
	mov	ax,[ecx]
	mov	[ebp-04h],eax;	rc

; 1697         sprintf(szMessage,"COMi Extension Access Error - %04X-%04X",stParams.wCommand,rc);
	push	dword ptr [ebp-04h];	rc
	xor	eax,eax
	mov	ax,[ebp-012h];	stParams
	push	eax
	mov	edx,offset FLAT:@STAT20
	mov	eax,offset FLAT:szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 1698         MessageBox(HWND_DESKTOP,szMessage);
	push	offset FLAT:szMessage
	push	01h
	call	MessageBox
	add	esp,08h

; 1700         DosClose(hCom);
	push	dword ptr [ebp-028h];	hCom
	call	DosClose
	add	esp,04h

; 1701         DosFreeMem(pstData);
	push	dword ptr [ebp-018h];	pstData
	call	DosFreeMem
	add	esp,04h

; 1702         return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL350:

; 1705     pWord = (WORD *)(&pstData->wData);
	mov	eax,[ebp-018h];	pstData
	add	eax,04h
	mov	[ebp-024h],eax;	pWord

; 1706     ulCOMiSignature = (ULONG)*pWord;
	mov	ecx,[ebp-024h];	pWord
	xor	eax,eax
	mov	ax,[ecx]
	mov	dword ptr  ulCOMiSignature,eax

; 1707     DosClose(hCom);
	push	dword ptr [ebp-028h];	hCom
	call	DosClose
	add	esp,04h

; 1708     }

; 1709   DosFreeMem(pstData);
	push	dword ptr [ebp-018h];	pstData
	call	DosFreeMem
	add	esp,04h

; 1710   return(TRUE);
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
GetDriverInfo	endp
CODE32	ends
end
