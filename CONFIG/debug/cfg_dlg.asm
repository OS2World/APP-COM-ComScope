	title	p:\config\cfg_dlg.c
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
	public	bInsertNewDevice
	public	bShareAccessWarning
	public	bNonExAccessWarning
	public	astISAdeviceDefinition
	public	astMCAdeviceDefinition
	public	astPCIdeviceDefinition
	public	szHeaderString
	public	szListFormat
	public	szLoadFormat
	public	szDeviceDefFormat
	public	szSkipFormat
	public	szPCIdevice
	public	pSpoolList
	public	pAddressList
	public	pInterruptList
	public	pLoadAddressList
	public	pLoadInterruptList
	public	byLastIntLevel
	public	wLastAddress
	public	wLastDelayCount
	public	szLastName
	public	bEmptyINI
	public	iLoadMaxDevice
	public	iOEMloadMaxDevice
	public	iDeviceCount
	extrn	_dllentry:proc
	extrn	_sprintfieee:proc
	extrn	strcpy:proc
	extrn	strcat:proc
	extrn	strlen:proc
	extrn	FindListByteItem:proc
	extrn	RemoveListItem:proc
	extrn	GetNextListItem:proc
	extrn	DestroyList:proc
	extrn	FindListWordItem:proc
	extrn	WinSetFocus:proc
	extrn	InitializeList:proc
	extrn	FillDeviceLists:proc
	extrn	ControlEnable:proc
	extrn	WinSetWindowText:proc
	extrn	WinSetDlgItemText:proc
	extrn	InitializeDCBheader:proc
	extrn	strncpy:proc
	extrn	WinSendDlgItemMsg:proc
	extrn	QueryIniCFGheader:proc
	extrn	CheckButton:proc
	extrn	Checked:proc
	extrn	WinQueryDlgItemText:proc
	extrn	atoi:proc
	extrn	PlaceIniCFGheader:proc
	extrn	DosLoadModule:proc
	extrn	DosQueryProcAddr:proc
	extrn	DosFreeModule:proc
	extrn	AdjustConfigSys:proc
	extrn	ClearAllIntDCBheader:proc
	extrn	WinDismissDlg:proc
	extrn	RemoveIniCFGheader:proc
	extrn	InitializeCFGheader:proc
	extrn	AddIniConfigHeader:proc
	extrn	WinDlgBox:proc
	extrn	RemoveLeadingSpaces:proc
	extrn	RemoveSpaces:proc
	extrn	MakeDeviceName:proc
	extrn	QueryIniDCBheaderName:proc
	extrn	fnwpDeviceSetupDlgProc:proc
	extrn	PlaceIniDCBheader:proc
	extrn	WinGetLastError:proc
	extrn	MessageBox:proc
	extrn	RemoveIniDCBheader:proc
	extrn	DisplayHelpPanel:proc
	extrn	WinDefDlgProc:proc
	extrn	GpiLoadBitmap:proc
	extrn	WinDrawBitmap:proc
	extrn	WinPostMsg:proc
	extrn	DosOpen:proc
	extrn	DosRead:proc
	extrn	DosSetFilePtr:proc
	extrn	AddListItem:proc
	extrn	DosClose:proc
	extrn	CenterDlgBox:proc
	extrn	WinLoadString:proc
	extrn	WinWindowFromID:proc
	extrn	WinShowWindow:proc
	extrn	GetNextAvailableInterrupt:proc
	extrn	ASCIItoBin:proc
	extrn	_itoa:proc
	extrn	_debug_malloc:proc
	extrn	FillDeviceNameList:proc
	extrn	_debug_free:proc
	extrn	QueryIniDCBheader:proc
	extrn	strcmp:proc
	extrn	DosDelete:proc
	extrn	CleanConfigSys:proc
	extrn	_fullDump:dword
	extrn	szDriverIniPath:byte
	extrn	bLimitLoad:dword
	extrn	szDriverVersionString:byte
	extrn	szPDRlibrarySpec:byte
	extrn	astConfigDeviceList:byte
	extrn	hThisModule:dword
	extrn	bWarp4:dword
	extrn	lXbutton:dword
	extrn	lYbutton:dword
	extrn	szOEMname:byte
	extrn	byDDOEMtype:byte
	extrn	fIsMCAmachine:word
	extrn	bPCImachine:dword
DATA32	segment
@STAT1	db "zero",0h
	align 04h
@STAT2	db "one",0h
@STAT3	db "two",0h
@STAT4	db "three",0h
	align 04h
@STAT5	db "four",0h
	align 04h
@STAT6	db "five",0h
	align 04h
@STAT7	db "six",0h
@STAT8	db "seven",0h
	align 04h
@STAT9	db "eight",0h
	align 04h
@STATa	db "nine",0h
	align 04h
@STATb	db "ten",0h
@STATc	db "eleven",0h
	align 04h
@STATd	db "twelve",0h
	align 04h
@STATe	db "thirteen",0h
	align 04h
@STATf	db "fourteen",0h
	align 04h
@STAT10	db "fifteen",0h
@STAT11	db "sixteen",0h
@STAT12	db ", Ext'd modem cntls",0h
@STAT13	db ", No init tests",0h
@STAT14	db ", Normalize baud",0h
	align 04h
@STAT15	db ", Explicit baud",0h
@STAT16	db ", No modem int's",0h
	align 04h
@STAT17	db " <- adapter type ",0h
	align 04h
@STAT18	db "one",0h
@STAT19	db "two",0h
@STAT1a	db "three",0h
	align 04h
@STAT1b	db "four",0h
	align 04h
@STAT1c	db "five",0h
	align 04h
@STAT1d	db "six",0h
@STAT1e	db "seven",0h
	align 04h
@STAT1f	db "UNSUPPORTED!",0h
	align 04h
@STAT20	db " -> interrupt ID registe"
db "r at %Xh",0h
	align 04h
@STAT21	db "Defining %s",0h
@STAT22	db " for COMi %s",0h
@STAT23	db "%u",0h
@STAT24	db "%u",0h
@STAT25	db "%u",0h
	align 04h
@STAT26	db "SPLPDINSTALLPORT",0h
	align 04h
@STAT27	db "SPLPDREMOVEPORT",0h
@STAT28	db "Error loading Port Confi"
db "g Dialog - rc = %08X",0h
@STAT29	db "%u",0h
@STAT2a	db "%u",0h
@STAT2b	db "  ",0h
@STAT2c	db "%u",0h
@STAT2d	db "%X",0h
@STAT2e	db "There are no more interr"
db "upts available.",0ah,0ah,"You wil"
db "l have to delete a devic"
db "e, or remove a load, to "
db "free up an interrupt.",0h
	align 04h
@STAT2f	db "The selected interrupt l"
db "evel is out of range.",0ah,0ah,"O"
db "nly values between 2 and"
db " 15 (inclusive) are vali"
db "d.",0h
	align 04h
@STAT30	db "You must enter an interr"
db "upt ID register address "
db "if you have selected any"
db " adapter type except ",022h,"No"
db "t interrupt sharing",022h,".",0h
	align 04h
@STAT31	db "The interrupt ID registe"
db "r must be at the adapter"
db "'s base I/O address plus"
db " seven (e.g., 0x307) for"
db " the adapter type you ha"
db "ve selected.",0h
	align 04h
@STAT32	db "Interrupt level %u is al"
db "ready taken.  Please sel"
db "ect a different Interrup"
db "t.",0h
	align 04h
@STAT33	db "Globetek model ",0h
@STAT34	db "Moxa model ",0h
@STAT35	db "C104H, four port",0h
	align 04h
@STAT36	db "C168H, eight port",0h
	align 04h
@STAT37	db "U.S.Robotics PCI modem",0h
	align 04h
@STAT38	db "Globetek model ",0h
@STAT39	db "1002, two port",0h
	align 04h
@STAT3a	db "1004, four port",0h
@STAT3b	db "1008, eight port",0h
	align 04h
@STAT3c	db "Sealevel model ",0h
@STAT3d	db "7101, one port",0h
	align 04h
@STAT3e	db "7102, one port",0h
	align 04h
@STAT3f	db "7103, one port",0h
	align 04h
@STAT40	db "7104, one port",0h
	align 04h
@STAT41	db "7105, one port",0h
	align 04h
@STAT42	db "7201, two port",0h
	align 04h
@STAT43	db "7202, two port",0h
	align 04h
@STAT44	db "7203, two port",0h
	align 04h
@STAT45	db "7901, two port",0h
	align 04h
@STAT46	db "7903, two port",0h
	align 04h
@STAT47	db "7401, four port",0h
@STAT48	db "7402, four port",0h
@STAT49	db "7404, four port",0h
@STAT4a	db "7405, four port",0h
@STAT4b	db "7904, four port",0h
@STAT4c	db "7801, eight port",0h
	align 04h
@STAT4d	db "7905, eight port",0h
	align 04h
@STAT4e	db "Blue Heat model ",0h
	align 04h
@STAT4f	db "V960",0h
	align 04h
@STAT50	db "V961, eight port",0h
	align 04h
@STAT51	db "V962",0h
	align 04h
@STAT52	db "V292",0h
	align 04h
@STAT53	db "Undetermined PCI adapter"
db " model",0h
	align 04h
@STAT54	db "p:\config\cfg_dlg.c",0h
@STAT55	db "p:\config\cfg_dlg.c",0h
@STAT56	db "p:\config\cfg_dlg.c",0h
@STAT57	db "Use ISA ports",0h
	align 04h
@STAT58	db "Select one PCI device",0h
	align 04h
@STAT59	db "Select one standard devi"
db "ce",0h
	align 04h
@STAT5a	db "Select up to %s PCI devi"
db "ces",0h
@STAT5b	db "Select up to %s standard"
db " devices",0h
	align 04h
@STAT5c	db "Use ISA ports",0h
	align 04h
@STAT5d	db "Use PCI adapter",0h
@STAT5e	db "Select one PCI device",0h
	align 04h
@STAT5f	db "Select one standard devi"
db "ce",0h
	align 04h
@STAT60	db "Select up to %s PCI devi"
db "ces",0h
@STAT61	db "Select up to %s standard"
db " devices",0h
	align 04h
@2aszOrdinals	dd offset FLAT:@STAT1
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
astISAdeviceDefinition	db "COM1",0h
	db 04h DUP (00H)
	db 0f8h,03h
	db 04h
	db "COM2",0h
	db 04h DUP (00H)
	db 0f8h,02h
	db 03h
	db "COM3",0h
	db 04h DUP (00H)
	db 0e8h,03h
	db 04h
	db "COM4",0h
	db 04h DUP (00H)
	db 0e8h,02h
	db 03h
astMCAdeviceDefinition	db "COM1",0h
	db 04h DUP (00H)
	db 0f8h,03h
	db 04h
	db "COM2",0h
	db 04h DUP (00H)
	db 0f8h,02h
	db 03h
	db "COM3",0h
	db 04h DUP (00H)
	db " 2"
	db 03h
	db "COM4",0h
	db 04h DUP (00H)
	db "(2"
	db 03h
	db "COM5",0h
	db 04h DUP (00H)
	db " B"
	db 03h
	db "COM6",0h
	db 04h DUP (00H)
	db "(B"
	db 03h
	db "COM7",0h
	db 04h DUP (00H)
	db " R"
	db 03h
	db "COM8",0h
	db 04h DUP (00H)
	db "(R"
	db 03h
astPCIdeviceDefinition	db "COM1",0h
	db 04h DUP (00H)
	db 0h,0h
	db 0h
	db "COM2",0h
	db 04h DUP (00H)
	db 0h,0h
	db 0h
	db "COM3",0h
	db 04h DUP (00H)
	db 0h,0h
	db 0h
	db "COM4",0h
	db 04h DUP (00H)
	db 0h,0h
	db 0h
	db "COM5",0h
	db 04h DUP (00H)
	db 0h,0h
	db 0h
	db "COM6",0h
	db 04h DUP (00H)
	db 0h,0h
	db 0h
	db "COM7",0h
	db 04h DUP (00H)
	db 0h,0h
	db 0h
	db "COM8",0h
	db 04h DUP (00H)
	db 0h,0h
	db 0h
szHeaderString	db " ~Name  Address  Interru"
db "pt",0h
szListFormat	db "%5s  0x%04x      %2u",0h
szLoadFormat	db "Load %d %s",0h
szDeviceDefFormat	db "Device definitions, load"
db " %d",0h
szSkipFormat	db "%5s will be not be insta"
db "lled",0h
szPCIdevice	db "%5s is PCI PnP device",0h
byLastIntLevel	db 03h
	align 02h
wLastAddress	dw 03f8h
wLastDelayCount	dw 012ch
szLastName	db "COM0",0h
	db 04h DUP (00H)
	align 04h
iLoadMaxDevice	dd 08h
iOEMloadMaxDevice	dd 04h
	dd	_dllentry
DATA32	ends
BSS32	segment
bInsertNewDevice	dd 0h
bShareAccessWarning	dd 0h
bNonExAccessWarning	dd 0h
pSpoolList	dd 0h
pAddressList	dd 0h
pInterruptList	dd 0h
pLoadAddressList	dd 0h
pLoadInterruptList	dd 0h
bEmptyINI	dd 0h
iDeviceCount	dd 0h
@10afDisplayBase	db 0h
	align 04h
@15cbPCIselected	dd 0h
comm	stConfigDeviceCount:dword
comm	szListString:byte:012ch
comm	stGlobalDCBheader:byte:03ah
comm	stGlobalCFGheader:byte:03eh
comm	stTempDCBheader:byte:03ah
comm	stTempCFGheader:byte:03eh
comm	szCurrentConfigDeviceName:byte:0ah
	align 04h
comm	hwndDeviceList:dword
@63stDCBposition	db 04h DUP (0h)
@65szOEMstring	db 03ch DUP (0h)
@6aiItemSelected	dd 0h
@6cpstCOMiCFG	dd 0h
@6ebOEMselected	dd 0h
@73ptl	db 08h DUP (0h)
@79bIniWasEmpty	dd 0h
@109wLoadFlags	dw 0h
@10ewIntAlgorithim	dw 0h
@111pstCOMiCFG	dd 0h
@113byIntLevel	db 0h
	align 04h
@133pstCOMiCFG	dd 0h
@139pstCOMiCFG	dd 0h
@14dpstCOMiCFG	dd 0h
@14fpstDeviceDef	dd 0h
@151iDeviceCount	dd 0h
@152szDriverIniSpec	db 0104h DUP (0h)
@154stCFGheader	db 03eh DUP (0h)
@155stDCBheader	db 03ah DUP (0h)
@15aulButtonOnCount	dd 0h
@15dusVendorID	dw 0h
@15eusDeviceID	dw 0h
BSS32	ends
CODE32	segment

; 102   {
	align 010h

AppendOptionList	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah
	sub	esp,08h

; 103   int iLen = 0;
	mov	dword ptr [ebp-04h],0h;	iLen

; 104 
; 105   if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_EXT_MODEM_CTL)
	mov	eax,[ebp+08h];	pstDCBheader
	test	byte ptr [eax+011h],01h
	je	@BLBL1

; 106     iLen += sprintf(&szListString[iLen],", Ext'd modem cntls");
	mov	edx,offset FLAT:@STAT12
	mov	eax,[ebp+0ch];	szListString
	mov	ecx,[ebp-04h];	iLen
	add	eax,ecx
	call	_sprintfieee
	add	eax,[ebp-04h];	iLen
	mov	[ebp-04h],eax;	iLen
@BLBL1:

; 107   if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_TESTS_DISABLE)
	mov	eax,[ebp+08h];	pstDCBheader
	test	byte ptr [eax+011h],010h
	je	@BLBL2

; 108     iLen += sprintf(&szListString[iLen],", No init tests");
	mov	edx,offset FLAT:@STAT13
	mov	eax,[ebp+0ch];	szListString
	mov	ecx,[ebp-04h];	iLen
	add	eax,ecx
	call	_sprintfieee
	add	eax,[ebp-04h];	iLen
	mov	[ebp-04h],eax;	iLen
@BLBL2:

; 109 //  if (pstDCBheader->stComDCB.wConfigFlags2 & CFG_FLAG1_HDW_HS_MASK)
; 110 //    iLen += sprintf(&szListString[iLen],", 16650/16750 Hdw HS");
; 111   if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_NORMALIZE_BAUD)
	mov	eax,[ebp+08h];	pstDCBheader
	test	byte ptr [eax+010h],010h
	je	@BLBL3

; 112     iLen += sprintf(&szListString[iLen],", Normalize baud");
	mov	edx,offset FLAT:@STAT14
	mov	eax,[ebp+0ch];	szListString
	mov	ecx,[ebp-04h];	iLen
	add	eax,ecx
	call	_sprintfieee
	add	eax,[ebp-04h];	iLen
	mov	[ebp-04h],eax;	iLen
@BLBL3:

; 113   if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_EXPLICIT_BAUD_DIVISOR)
	mov	eax,[ebp+08h];	pstDCBheader
	test	byte ptr [eax+010h],080h
	je	@BLBL4

; 114     iLen += sprintf(&szListString[iLen],", Explicit baud");
	mov	edx,offset FLAT:@STAT15
	mov	eax,[ebp+0ch];	szListString
	mov	ecx,[ebp-04h];	iLen
	add	eax,ecx
	call	_sprintfieee
	add	eax,[ebp-04h];	iLen
	mov	[ebp-04h],eax;	iLen
@BLBL4:

; 115   if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_NO_MODEM_INT)
	mov	eax,[ebp+08h];	pstDCBheader
	test	byte ptr [eax+011h],08h
	je	@BLBL5

; 116     iLen += sprintf(&szListString[iLen],", No modem int's");
	mov	edx,offset FLAT:@STAT16
	mov	eax,[ebp+0ch];	szListString
	mov	ecx,[ebp-04h];	iLen
	add	eax,ecx
	call	_sprintfieee
	add	eax,[ebp-04h];	iLen
	mov	[ebp-04h],eax;	iLen
@BLBL5:

; 117   }
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
AppendOptionList	endp

; 120   {
	align 010h

FillOEMstring	proc
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
	sub	esp,08h

; 123   if (stGlobalCFGheader.byAdapterType != 0)
	cmp	byte ptr  stGlobalCFGheader+0ah,0h
	je	@BLBL6

; 124     {
; 125     strcpy(szOEMstring," <- adapter type ");
	mov	edx,offset FLAT:@STAT17
	mov	eax,[ebp+08h];	szOEMstring
	call	strcpy

; 126     switch (stGlobalCFGheader.byAdapterType)
	xor	eax,eax
	mov	al,byte ptr  stGlobalCFGheader+0ah
	jmp	@BLBL10
	align 04h
@BLBL11:

; 127       {
; 128       case HDWTYPE_ONE:
; 129         strcat(szOEMstring,"one");
	mov	edx,offset FLAT:@STAT18
	mov	eax,[ebp+08h];	szOEMstring
	call	strcat

; 130         break;
	jmp	@BLBL9
	align 04h
@BLBL12:

; 131       case HDWTYPE_TWO:
; 132         strcat(szOEMstring,"two");
	mov	edx,offset FLAT:@STAT19
	mov	eax,[ebp+08h];	szOEMstring
	call	strcat

; 133         break;
	jmp	@BLBL9
	align 04h
@BLBL13:

; 134       case HDWTYPE_THREE:
; 135         strcat(szOEMstring,"three");
	mov	edx,offset FLAT:@STAT1a
	mov	eax,[ebp+08h];	szOEMstring
	call	strcat

; 136         break;
	jmp	@BLBL9
	align 04h
@BLBL14:

; 137       case HDWTYPE_FOUR:
; 138         strcat(szOEMstring,"four");
	mov	edx,offset FLAT:@STAT1b
	mov	eax,[ebp+08h];	szOEMstring
	call	strcat

; 139         break;
	jmp	@BLBL9
	align 04h
@BLBL15:

; 140       case HDWTYPE_FIVE:
; 141         strcat(szOEMstring,"five");
	mov	edx,offset FLAT:@STAT1c
	mov	eax,[ebp+08h];	szOEMstring
	call	strcat

; 142         break;
	jmp	@BLBL9
	align 04h
@BLBL16:

; 143       case HDWTYPE_SIX:
; 144         strcat(szOEMstring,"six");
	mov	edx,offset FLAT:@STAT1d
	mov	eax,[ebp+08h];	szOEMstring
	call	strcat

; 145         break;
	jmp	@BLBL9
	align 04h
@BLBL17:

; 146       case HDWTYPE_SEVEN:
; 147         strcat(szOEMstring,"seven");
	mov	edx,offset FLAT:@STAT1e
	mov	eax,[ebp+08h];	szOEMstring
	call	strcat

; 148         break;
	jmp	@BLBL9
	align 04h
@BLBL18:

; 149       case HDWTYPE_PCI:
; 150         GetPCIadapterName(szPCIname, byOEMtype);
	mov	al,[ebp+0ch];	byOEMtype
	push	eax
	lea	eax,[ebp-064h];	szPCIname
	push	eax
	call	GetPCIadapterName
	add	esp,08h

; 151         strcat(szOEMstring,szPCIname);
	lea	edx,[ebp-064h];	szPCIname
	mov	eax,[ebp+08h];	szOEMstring
	call	strcat

; 152         break;
	jmp	@BLBL9
	align 04h
@BLBL19:

; 153       default:
; 154         strcat(szOEMstring,"UNSUPPORTED!");
	mov	edx,offset FLAT:@STAT1f
	mov	eax,[ebp+08h];	szOEMstring
	call	strcat

; 155         break;
	jmp	@BLBL9
	align 04h
	jmp	@BLBL9
	align 04h
@BLBL10:
	cmp	eax,01h
	je	@BLBL11
	cmp	eax,02h
	je	@BLBL12
	cmp	eax,03h
	je	@BLBL13
	cmp	eax,04h
	je	@BLBL14
	cmp	eax,05h
	je	@BLBL15
	cmp	eax,06h
	je	@BLBL16
	cmp	eax,07h
	je	@BLBL17
	cmp	eax,09h
	je	@BLBL18
	jmp	@BLBL19
	align 04h
@BLBL9:

; 156       }
; 157     if ((stGlobalCFGheader.byAdapterType != HDWTYPE_PCI) && (stGlobalCFGheader.wIntIDregister != 0))
	cmp	byte ptr  stGlobalCFGheader+0ah,09h
	je	@BLBL8
	cmp	word ptr  stGlobalCFGheader+014h,0h
	je	@BLBL8

; 158       sprintf(&szOEMstring[strlen(szOEMstring)]," -> interrupt ID register at %Xh",stGlobalCFGheader.wIntIDregister);
	mov	eax,[ebp+08h];	szOEMstring
	call	strlen
	mov	ecx,eax
	xor	eax,eax
	mov	ax,word ptr  stGlobalCFGheader+014h
	push	eax
	mov	edx,offset FLAT:@STAT20
	mov	eax,[ebp+08h];	szOEMstring
	add	eax,ecx
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 159     }
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL6:

; 160   else
; 161     {
; 162     stGlobalCFGheader.wIntIDregister = 0;
	mov	word ptr  stGlobalCFGheader+014h,0h

; 163     szOEMstring[0] = 0;
	mov	eax,[ebp+08h];	szOEMstring
	mov	byte ptr [eax],0h

; 164     }
@BLBL8:

; 165   }
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
FillOEMstring	endp

; 168   {
	align 010h

DeleteLoadLists	proc
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

; 169   LINKLIST *pOld = NULL;
	mov	dword ptr [ebp-04h],0h;	pOld

; 170   LINKLIST *pListItem = NULL;
	mov	dword ptr [ebp-08h],0h;	pListItem

; 171   BYTE *pByte;
; 172   WORD *pWord;
; 173 
; 174   if (pLoadInterruptList != NULL)
	cmp	dword ptr  pLoadInterruptList,0h
	je	@BLBL20

; 175     {
; 176     if (pLoadInterruptList->pData != NULL)
	mov	eax,dword ptr  pLoadInterruptList
	cmp	dword ptr [eax+08h],0h
	je	@BLBL21

; 177       {
; 178       if (stGlobalCFGheader.byInterruptLevel != 0)
	cmp	byte ptr  stGlobalCFGheader+0bh,0h
	je	@BLBL22

; 179         {
; 180         pOld = FindListByteItem(pInterruptList,stGlobalCFGheader.byInterruptLevel);
	mov	al,byte ptr  stGlobalCFGheader+0bh
	push	eax
	push	dword ptr  pInterruptList
	call	FindListByteItem
	add	esp,08h
	mov	[ebp-04h],eax;	pOld

; 181         RemoveListItem(pOld);
	push	dword ptr [ebp-04h];	pOld
	call	RemoveListItem
	add	esp,04h

; 182         }
	jmp	@BLBL21
	align 010h
@BLBL22:

; 183       else
; 184         {
; 185         pOld = pLoadInterruptList;
	mov	eax,dword ptr  pLoadInterruptList
	mov	[ebp-04h],eax;	pOld

; 186         do
	align 010h
@BLBL24:

; 187           {
; 188           pByte = (BYTE *)pOld->pData;
	mov	eax,[ebp-04h];	pOld
	mov	eax,[eax+08h]
	mov	[ebp-0ch],eax;	pByte

; 189           if (pByte != NULL)
	cmp	dword ptr [ebp-0ch],0h;	pByte
	je	@BLBL25

; 190             {
; 191             *pByte &= '\x80';
	mov	eax,[ebp-0ch];	pByte
	mov	[ebp-014h],eax;	@CBE98
	mov	eax,[ebp-014h];	@CBE98
	mov	cl,[eax]
	and	cl,080h
	mov	[eax],cl

; 192             if ((pListItem = FindListByteItem(pInterruptList,*pByte)) != NULL)
	mov	eax,[ebp-0ch];	pByte
	mov	al,[eax]
	push	eax
	push	dword ptr  pInterruptList
	call	FindListByteItem
	add	esp,08h
	mov	[ebp-08h],eax;	pListItem
	cmp	dword ptr [ebp-08h],0h;	pListItem
	je	@BLBL25

; 193               RemoveListItem(pListItem);
	push	dword ptr [ebp-08h];	pListItem
	call	RemoveListItem
	add	esp,04h

; 194             }
@BLBL25:

; 195           } while ((pOld = GetNextListItem(pOld)) != NULL);
	push	dword ptr [ebp-04h];	pOld
	call	GetNextListItem
	add	esp,04h
	mov	[ebp-04h],eax;	pOld
	cmp	dword ptr [ebp-04h],0h;	pOld
	jne	@BLBL24

; 196         }

; 197       }
@BLBL21:

; 198     DestroyList(&pLoadInterruptList);
	push	offset FLAT:pLoadInterruptList
	call	DestroyList
	add	esp,04h

; 199     }
@BLBL20:

; 200   if (pLoadAddressList != NULL)
	cmp	dword ptr  pLoadAddressList,0h
	je	@BLBL28

; 201     {
; 202     if (pLoadAddressList->pData != NULL)
	mov	eax,dword ptr  pLoadAddressList
	cmp	dword ptr [eax+08h],0h
	je	@BLBL29

; 203       {
; 204       pOld = pLoadAddressList;
	mov	eax,dword ptr  pLoadAddressList
	mov	[ebp-04h],eax;	pOld

; 205       do
	align 010h
@BLBL30:

; 206         {
; 207         pWord = (WORD *)pOld->pData;
	mov	eax,[ebp-04h];	pOld
	mov	eax,[eax+08h]
	mov	[ebp-010h],eax;	pWord

; 208         if (pWord != 0)
	cmp	dword ptr [ebp-010h],0h;	pWord
	je	@BLBL31

; 209           {
; 210           pListItem = FindListWordItem(pAddressList,*pWord);
	mov	eax,[ebp-010h];	pWord
	mov	ax,[eax]
	push	eax
	push	dword ptr  pAddressList
	call	FindListWordItem
	add	esp,08h
	mov	[ebp-08h],eax;	pListItem

; 211           RemoveListItem(pListItem);
	push	dword ptr [ebp-08h];	pListItem
	call	RemoveListItem
	add	esp,04h

; 212           }
@BLBL31:

; 213         } while ((pOld = GetNextListItem(pOld)) != NULL);
	push	dword ptr [ebp-04h];	pOld
	call	GetNextListItem
	add	esp,04h
	mov	[ebp-04h],eax;	pOld
	cmp	dword ptr [ebp-04h],0h;	pOld
	jne	@BLBL30

; 214       }
@BLBL29:

; 215     DestroyList(&pLoadAddressList);
	push	offset FLAT:pLoadAddressList
	call	DestroyList
	add	esp,04h

; 216     }
@BLBL28:

; 217   }
	mov	esp,ebp
	pop	ebp
	ret	
DeleteLoadLists	endp

; 220   {
	align 010h

DeleteListItems	proc
	push	ebp
	mov	ebp,esp
	sub	esp,08h
	push	eax
	mov	eax,0aaaaaaaah
	mov	[esp+04h],eax
	mov	[esp+08h],eax
	pop	eax

; 221   LINKLIST *pListItem = NULL;
	mov	dword ptr [ebp-04h],0h;	pListItem

; 222   COMDCB *pstDCB = &pDCBheader->stComDCB;
	mov	eax,[ebp+0ch];	pDCBheader
	add	eax,010h
	mov	[ebp-08h],eax;	pstDCB

; 223 
; 224   if (pCFGheader->byInterruptLevel == 0)
	mov	eax,[ebp+08h];	pCFGheader
	cmp	byte ptr [eax+0bh],0h
	jne	@BLBL33

; 225     {
; 226     if ((pListItem = FindListByteItem(pInterruptList,pstDCB->byInterruptLevel)) != NULL)
	mov	eax,[ebp-08h];	pstDCB
	mov	al,[eax+020h]
	push	eax
	push	dword ptr  pInterruptList
	call	FindListByteItem
	add	esp,08h
	mov	[ebp-04h],eax;	pListItem
	cmp	dword ptr [ebp-04h],0h;	pListItem
	je	@BLBL34

; 227       RemoveListItem(pListItem);
	push	dword ptr [ebp-04h];	pListItem
	call	RemoveListItem
	add	esp,04h
@BLBL34:

; 228     if ((pListItem = FindListByteItem(pLoadInterruptList,pstDCB->byInterruptLevel)) != NULL)
	mov	eax,[ebp-08h];	pstDCB
	mov	al,[eax+020h]
	push	eax
	push	dword ptr  pLoadInterruptList
	call	FindListByteItem
	add	esp,08h
	mov	[ebp-04h],eax;	pListItem
	cmp	dword ptr [ebp-04h],0h;	pListItem
	je	@BLBL33

; 229       RemoveListItem(pListItem);
	push	dword ptr [ebp-04h];	pListItem
	call	RemoveListItem
	add	esp,04h

; 230     }
@BLBL33:

; 231   if ((pListItem = FindListWordItem(pAddressList,pstDCB->wIObaseAddress)) != NULL)
	mov	eax,[ebp-08h];	pstDCB
	mov	ax,[eax+06h]
	push	eax
	push	dword ptr  pAddressList
	call	FindListWordItem
	add	esp,08h
	mov	[ebp-04h],eax;	pListItem
	cmp	dword ptr [ebp-04h],0h;	pListItem
	je	@BLBL36

; 232     RemoveListItem(pListItem);
	push	dword ptr [ebp-04h];	pListItem
	call	RemoveListItem
	add	esp,04h
@BLBL36:

; 233   if ((pListItem = FindListWordItem(pLoadAddressList,pstDCB->wIObaseAddress)) != NULL)
	mov	eax,[ebp-08h];	pstDCB
	mov	ax,[eax+06h]
	push	eax
	push	dword ptr  pLoadAddressList
	call	FindListWordItem
	add	esp,08h
	mov	[ebp-04h],eax;	pListItem
	cmp	dword ptr [ebp-04h],0h;	pListItem
	je	@BLBL37

; 234     RemoveListItem(pListItem);
	push	dword ptr [ebp-04h];	pListItem
	call	RemoveListItem
	add	esp,04h
@BLBL37:

; 235   }
	mov	esp,ebp
	pop	ebp
	ret	
DeleteListItems	endp

; 238   {
	align 010h

UnMarkAllDevices	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah

; 241   for (iIndex = 1;iIndex < 100;iIndex++)
	mov	dword ptr [ebp-04h],01h;	iIndex
	cmp	dword ptr [ebp-04h],064h;	iIndex
	jge	@BLBL38
	align 010h
@BLBL39:

; 242     astDeviceList[iIndex].bAvailable = TRUE;
	mov	eax,[ebp+08h];	astDeviceList
	mov	ecx,[ebp-04h];	iIndex
	imul	ecx,0eh
	mov	dword ptr [eax+ecx+0ah],01h

; 241   for (iIndex = 1;iIndex < 100;iIndex++)
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	cmp	dword ptr [ebp-04h],064h;	iIndex
	jl	@BLBL39
@BLBL38:

; 243   }
	mov	esp,ebp
	pop	ebp
	ret	
UnMarkAllDevices	endp

; 246   {
	align 010h

	public fnwpPortConfigDlgProc
fnwpPortConfigDlgProc	proc
	push	ebp
	mov	ebp,esp
	sub	esp,011ch
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,047h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 260   BOOL bOkToEditConfigSYS = FALSE;
	mov	dword ptr [ebp-090h],0h;	bOkToEditConfigSYS

; 261   APIRET rc;
; 262   USERBUTTON *pstButton;
; 263   HBITMAP hBitmap;
; 264   static POINTL ptl;
; 265   int iLoadCount;
; 266   LINKLIST *pListItem;
; 267   SPOOLLST *pstSpool;
; 268   PFN pfnProcess;
; 269   HMODULE hMod;
; 270   static BOOL bIniWasEmpty;
; 271   ULONG idDialog;
; 272 
; 273 #if DEBUG > 0
; 274   ERRORID eidError;
; 275   char szMessage[100];
; 276 #endif
; 277   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL144
	align 04h
@BLBL145:

; 278     {
; 279     case WM_INITDLG:
; 280       hwndDeviceList = hwndDlg;
	mov	eax,[ebp+08h];	hwndDlg
	mov	dword ptr  hwndDeviceList,eax

; 281 //      CenterDlgBox(hwndDlg);
; 282       WinSetFocus(HWND_DESKTOP,hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinSetFocus
	add	esp,08h

; 283       pstCOMiCFG = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @6cpstCOMiCFG,eax

; 284       ptl.x = 0;
	mov	dword ptr  @73ptl,0h

; 285       ptl.y = 0;
	mov	dword ptr  @73ptl+04h,0h

; 286       if ((pSpoolList = InitializeList()) == NULL)
	call	InitializeList
	mov	dword ptr  pSpoolList,eax
	cmp	dword ptr  pSpoolList,0h
	jne	@BLBL41

; 287         return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL41:

; 288       if ((pInterruptList = InitializeList()) == NULL)
	call	InitializeList
	mov	dword ptr  pInterruptList,eax
	cmp	dword ptr  pInterruptList,0h
	jne	@BLBL42

; 289         {
; 290         DestroyList(&pSpoolList);
	push	offset FLAT:pSpoolList
	call	DestroyList
	add	esp,04h

; 291         return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL42:

; 292         }
; 293       if ((pAddressList = InitializeList()) == NULL)
	call	InitializeList
	mov	dword ptr  pAddressList,eax
	cmp	dword ptr  pAddressList,0h
	jne	@BLBL43

; 294         {
; 295         DestroyList(&pSpoolList);
	push	offset FLAT:pSpoolList
	call	DestroyList
	add	esp,04h

; 296         DestroyList(&pInterruptList);
	push	offset FLAT:pInterruptList
	call	DestroyList
	add	esp,04h

; 297         return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL43:

; 298         }
; 299       bShareAccessWarning = FALSE;
	mov	dword ptr  bShareAccessWarning,0h

; 300       bNonExAccessWarning = FALSE;
	mov	dword ptr  bNonExAccessWarning,0h

; 301       stConfigDeviceCount = FillDeviceLists(szDriverIniPath,pAddressList,pInterruptList);
	push	dword ptr  pInterruptList
	push	dword ptr  pAddressList
	push	offset FLAT:szDriverIniPath
	push	offset FLAT:stConfigDeviceCount
	call	FillDeviceLists
	add	esp,010h

; 302       stDCBposition.wLoadNumber = 1;
	mov	word ptr  @63stDCBposition,01h

; 303       stDCBposition.wDCBnumber = 1;
	mov	word ptr  @63stDCBposition+02h,01h

; 304       if (pstCOMiCFG->bPCIadapter)
	mov	eax,dword ptr  @6cpstCOMiCFG
	test	byte ptr [eax+04bh],080h
	je	@BLBL44

; 305 //      if (stGlobalCFGheader.byAdapterType == HDWTYPE_PCI)
; 306         {
; 307 //        pstCOMiCFG->bPCIadapter = TRUE;
; 308         iLoadMaxDevice = GetPCIadapterName(NULL, 0);
	push	0h
	push	0h
	call	GetPCIadapterName
	add	esp,08h
	mov	dword ptr  iLoadMaxDevice,eax

; 309         iOEMloadMaxDevice = iLoadMaxDevice;
	mov	eax,dword ptr  iLoadMaxDevice
	mov	dword ptr  iOEMloadMaxDevice,eax

; 310         }
@BLBL44:

; 311 //      else
; 312 //        pstCOMiCFG->bPCIadapter = FALSE;
; 313       if (pstCOMiCFG->ulMaxDeviceCount != 0)
	mov	eax,dword ptr  @6cpstCOMiCFG
	cmp	dword ptr [eax+025h],0h
	je	@BLBL45

; 314         {
; 315         if (pstCOMiCFG->ulMaxDeviceCount <= iOEMloadMaxDevice)
	mov	ecx,dword ptr  iOEMloadMaxDevice
	mov	eax,dword ptr  @6cpstCOMiCFG
	cmp	[eax+025h],ecx
	ja	@BLBL45

; 316           {
; 317           iLoadMaxDevice = pstCOMiCFG->ulMaxDeviceCount;
	mov	eax,dword ptr  @6cpstCOMiCFG
	mov	eax,[eax+025h]
	mov	dword ptr  iLoadMaxDevice,eax

; 318           bLimitLoad = TRUE;
	mov	dword ptr  bLimitLoad,01h

; 319           }

; 320         }
@BLBL45:

; 321 //      if ((pstCOMiCFG->byOEMtype == OEM_SEALEVEL) && (pstCOMiCFG->byOEMtype == OEM_OTHER))
; 322       if (pstCOMiCFG->byOEMtype != OEM_OTHER)
	mov	eax,dword ptr  @6cpstCOMiCFG
	cmp	byte ptr [eax+024h],0h
	je	@BLBL47

; 323         bLimitLoad = TRUE;
	mov	dword ptr  bLimitLoad,01h
@BLBL47:

; 324       if (bLimitLoad)
	cmp	dword ptr  bLimitLoad,0h
	je	@BLBL48

; 325         {
; 326         bIniWasEmpty = FALSE;
	mov	dword ptr  @79bIniWasEmpty,0h

; 327         if (stConfigDeviceCount.wDCBnumber == 0)
	cmp	word ptr  stConfigDeviceCount+02h,0h
	jne	@BLBL49

; 328           bIniWasEmpty = TRUE;
	mov	dword ptr  @79bIniWasEmpty,01h
@BLBL49:

; 329         ControlEnable(hwndDlg,PCFG_ADD_LOAD,FALSE);
	push	0h
	push	0120ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 330         ControlEnable(hwndDlg,PCFG_LOAD,FALSE);
	push	0h
	push	012cch
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 331         stConfigDeviceCount.wLoadNumber = 1;
	mov	word ptr  stConfigDeviceCount,01h

; 332         }
@BLBL48:

; 333       iLen = sprintf(szListString,"Defining %s",szDriverIniPath);
	push	offset FLAT:szDriverIniPath
	mov	edx,offset FLAT:@STAT21
	mov	eax,offset FLAT:szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	mov	[ebp-080h],eax;	iLen

; 334       if (szDriverVersionString != NULL)
; 335         sprintf(&szListString[iLen]," for COMi %s",szDriverVersionString);
	push	offset FLAT:szDriverVersionString
	mov	edx,offset FLAT:@STAT22
	mov	eax,[ebp-080h];	iLen
	add	eax,offset FLAT:szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 336       WinSetWindowText(hwndDlg,szListString);
	push	offset FLAT:szListString
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetWindowText
	add	esp,08h

; 337       WinSetDlgItemText(hwndDlg,PCFG_DEVT1,szHeaderString);
	push	offset FLAT:szHeaderString
	push	012d4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 338       InitializeDCBheader(&stGlobalDCBheader,pstCOMiCFG->bInstallCOMscope);
	mov	eax,dword ptr  @6cpstCOMiCFG
	mov	al,[eax+04bh]
	and	eax,03h
	shr	eax,01h
	push	eax
	push	offset FLAT:stGlobalDCBheader
	call	InitializeDCBheader
	add	esp,08h

; 339       if (pstCOMiCFG->pszPortName != NULL)
	mov	eax,dword ptr  @6cpstCOMiCFG
	cmp	dword ptr [eax+014h],0h
	je	@BLBL51

; 340         {
; 341         strncpy(stGlobalDCBheader.abyPortName,pstCOMiCFG->pszPortName,8);
	mov	ecx,08h
	mov	edx,dword ptr  @6cpstCOMiCFG
	mov	edx,[edx+014h]
	mov	eax,offset FLAT:stGlobalDCBheader
	call	strncpy

; 342         strncpy(szCurrentConfigDeviceName,pstCOMiCFG->pszPortName,8);
	mov	ecx,08h
	mov	edx,dword ptr  @6cpstCOMiCFG
	mov	edx,[edx+014h]
	mov	eax,offset FLAT:szCurrentConfigDeviceName
	call	strncpy

; 343         }
@BLBL51:

; 344       WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_SETITEMHEIGHT,(MPARAM)12,(MPARAM)0);
	push	0h
	push	0ch
	push	016ch
	push	012d6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 345       iItemSelected = LIT_NONE;
	mov	dword ptr  @6aiItemSelected,0ffffffffh

; 346       if (stConfigDeviceCount.wLoadNumber == 0)
	cmp	word ptr  stConfigDeviceCount,0h
	jne	@BLBL52

; 347         {
; 348         stConfigDeviceCount.wLoadNumber = 1;
	mov	word ptr  stConfigDeviceCount,01h

; 349         iDeviceCount = 0;
	mov	dword ptr  iDeviceCount,0h

; 350         stDCBposition.wLoadNumber = 1;
	mov	word ptr  @63stDCBposition,01h

; 351         stDCBposition.wDCBnumber = 0;
	mov	word ptr  @63stDCBposition+02h,0h

; 352         bEmptyINI = TRUE;
	mov	dword ptr  bEmptyINI,01h

; 353         }
	jmp	@BLBL53
	align 010h
@BLBL52:

; 354       else
; 355         {
; 356         if ((iDeviceCount = FillDeviceCfgListBox(hwndDlg,stDCBposition,szDriverIniPath,pstCOMiCFG->ulMaxDeviceCount)) != 0)
	mov	eax,dword ptr  @6cpstCOMiCFG
	push	dword ptr [eax+025h]
	push	offset FLAT:szDriverIniPath
	push	dword ptr  @63stDCBposition
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillDeviceCfgListBox
	add	esp,010h
	mov	dword ptr  iDeviceCount,eax
	cmp	dword ptr  iDeviceCount,0h
	je	@BLBL54

; 357           {
; 358           QueryIniCFGheader(szDriverIniPath,&stGlobalCFGheader,&stDCBposition);
	push	offset FLAT:@63stDCBposition
	push	offset FLAT:stGlobalCFGheader
	push	offset FLAT:szDriverIniPath
	call	QueryIniCFGheader
	add	esp,0ch

; 359           if (stGlobalCFGheader.wLoadFlags & LOAD_FLAG1_VERBOSE)
	test	byte ptr  stGlobalCFGheader+013h,040h
	je	@BLBL55

; 360             CheckButton(hwndDlg,PCFG_VERBOSE,TRUE);
	push	01h
	push	012f5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL55:

; 361           if (stGlobalCFGheader.wLoadFlags & LOAD_FLAG1_PRINT_LOCAL)
	test	byte ptr  stGlobalCFGheader+013h,020h
	je	@BLBL56

; 362             CheckButton(hwndDlg,PCFG_LOCAL,TRUE);
	push	01h
	push	012f6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL56:

; 363           if (!bLimitLoad)
	cmp	dword ptr  bLimitLoad,0h
	jne	@BLBL57

; 364             ControlEnable(hwndDlg,PCFG_ADD_LOAD,TRUE);
	push	01h
	push	0120ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
@BLBL57:

; 365           if (stGlobalCFGheader.wDelayCount != 0)
	cmp	word ptr  stGlobalCFGheader+04h,0h
	je	@BLBL58

; 366             {
; 367             CheckButton(hwndDlg,PCFG_KEY_WAIT,TRUE);
	push	01h
	push	011fch
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 368             wLastDelayCount = stGlobalCFGheader.wDelayCount;
	mov	ax,word ptr  stGlobalCFGheader+04h
	mov	word ptr  wLastDelayCount,ax

; 369             sprintf(szString,"%u",wLastDelayCount);
	xor	eax,eax
	mov	ax,word ptr  wLastDelayCount
	push	eax
	mov	edx,offset FLAT:@STAT23
	lea	eax,[ebp-07ch];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 370             WinSendDlgItemMsg(hwndDlg,PCFG_DELAY,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
	push	0h
	push	05h
	push	0143h
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 371             WinSetDlgItemText(hwndDlg,PCFG_DELAY,szString);
	lea	eax,[ebp-07ch];	szString
	push	eax
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 372             }
	jmp	@BLBL53
	align 010h
@BLBL58:

; 373           else
; 374             {
; 375             wLastDelayCount = 300;
	mov	word ptr  wLastDelayCount,012ch

; 376             sprintf(szString,"%u",wLastDelayCount);
	xor	eax,eax
	mov	ax,word ptr  wLastDelayCount
	push	eax
	mov	edx,offset FLAT:@STAT24
	lea	eax,[ebp-07ch];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 377             WinSendDlgItemMsg(hwndDlg,PCFG_DELAY,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
	push	0h
	push	05h
	push	0143h
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 378             WinSetDlgItemText(hwndDlg,PCFG_DELAY,szString);
	lea	eax,[ebp-07ch];	szString
	push	eax
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 379             ControlEnable(hwndDlg,PCFG_DELAYT,FALSE);
	push	0h
	push	011fdh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 380             ControlEnable(hwndDlg,PCFG_DELAY,FALSE);
	push	0h
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 381             }

; 382           }
	jmp	@BLBL53
	align 010h
@BLBL54:

; 383         else
; 384           {
; 385           wLastDelayCount = 300;
	mov	word ptr  wLastDelayCount,012ch

; 386           sprintf(szString,"%u",wLastDelayCount);
	xor	eax,eax
	mov	ax,word ptr  wLastDelayCount
	push	eax
	mov	edx,offset FLAT:@STAT25
	lea	eax,[ebp-07ch];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 387           WinSendDlgItemMsg(hwndDlg,PCFG_DELAY,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
	push	0h
	push	05h
	push	0143h
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 388           WinSetDlgItemText(hwndDlg,PCFG_DELAY,szString);
	lea	eax,[ebp-07ch];	szString
	push	eax
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 389           ControlEnable(hwndDlg,PCFG_DELAYT,FALSE);
	push	0h
	push	011fdh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 390           ControlEnable(hwndDlg,PCFG_DELAY,FALSE);
	push	0h
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 391           ControlEnable(hwndDlg,PCFG_ADD_LOAD,FALSE);
	push	0h
	push	0120ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 392           bEmptyINI = TRUE;
	mov	dword ptr  bEmptyINI,01h

; 393           }

; 394         }
@BLBL53:

; 395       if (stConfigDeviceCount.wLoadNumber > 1)
	mov	ax,word ptr  stConfigDeviceCount
	cmp	ax,01h
	jbe	@BLBL61

; 396         bOEMselected = TRUE;
	mov	dword ptr  @6ebOEMselected,01h
	jmp	@BLBL62
	align 010h
@BLBL61:

; 397       else
; 398         bOEMselected = FALSE;
	mov	dword ptr  @6ebOEMselected,0h
@BLBL62:

; 399       FillOEMstring(szOEMstring, pstCOMiCFG->byOEMtype);
	mov	eax,dword ptr  @6cpstCOMiCFG
	mov	al,[eax+024h]
	push	eax
	push	offset FLAT:@65szOEMstring
	call	FillOEMstring
	add	esp,08h

; 400       sprintf(szListString,szLoadFormat,stDCBposition.wLoadNumber,szOEMstring);
	push	offset FLAT:@65szOEMstring
	xor	eax,eax
	mov	ax,word ptr  @63stDCBposition
	push	eax
	mov	edx,offset FLAT:szLoadFormat
	mov	eax,offset FLAT:szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 401 #ifdef this_junk
; 402       if (pstCOMiCFG->bPCIadapter)
; 403         {
; 404         strcat(szListString, " -> ");
; 405         GetPCIadapterName(szPCIname);
; 406         strcat(szListString, szPCIname);
; 407         }
; 408 #endif
; 409       WinSetDlgItemText(hwndDlg,PCFG_LOADT,szListString);
	push	offset FLAT:szListString
	push	012ceh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 410       sprintf(szListString,szDeviceDefFormat,stDCBposition.wLoadNumber);
	xor	eax,eax
	mov	ax,word ptr  @63stDCBposition
	push	eax
	mov	edx,offset FLAT:szDeviceDefFormat
	mov	eax,offset FLAT:szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 411       WinSetDlgItemText(hwndDlg,PCFG_DEVT0,szListString);
	push	offset FLAT:szListString
	push	012d7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 412       ControlEnable(hwndDlg,PCFG_DELETE_LOAD,FALSE);
	push	0h
	push	01209h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 413       ControlEnable(hwndDlg,DID_DELETE,FALSE);
	push	0h
	push	012fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 414       ControlEnable(hwndDlg,DID_INSTALL,FALSE);
	push	0h
	push	012eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 415       if (iDeviceCount >= iLoadMaxDevice)
	mov	eax,dword ptr  iLoadMaxDevice
	cmp	dword ptr  iDeviceCount,eax
	jl	@BLBL63

; 416         ControlEnable(hwndDlg,DID_INSERT,FALSE);
	push	0h
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
@BLBL63:

; 417       WinSendDlgItemMsg(hwndDlg,PCFG_LOAD,
	push	01h
	xor	eax,eax
	mov	ax,word ptr  stConfigDeviceCount
	push	eax
	push	0207h
	push	012cch
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 418                                 SPBM_SETLIMITS,
; 419                                 (MPARAM)(stConfigDeviceCount.wLoadNumber),
; 420                                 (MPARAM)1L);
; 421       return (MRESULT) TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL146:

; 422     case WM_COMMAND:
; 423       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL148
	align 04h
@BLBL149:

; 424         {
; 425         case DID_OK:
; 426           if (Checked(hwndDlg,PCFG_KEY_WAIT))
	push	011fch
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL64

; 427             {
; 428             WinQueryDlgItemText(hwndDlg,PCFG_DELAY,6,szString);
	lea	eax,[ebp-07ch];	szString
	push	eax
	push	06h
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinQueryDlgItemText
	add	esp,010h

; 429             if ((stGlobalCFGheader.wDelayCount = (WORD)atoi(szString)) < 10)
	lea	eax,[ebp-07ch];	szString
	call	atoi
	mov	word ptr  stGlobalCFGheader+04h,ax
	mov	ax,word ptr  stGlobalCFGheader+04h
	cmp	ax,0ah
	jae	@BLBL66

; 430               stGlobalCFGheader.wDelayCount = 10;
	mov	word ptr  stGlobalCFGheader+04h,0ah

; 431             }
	jmp	@BLBL66
	align 010h
@BLBL64:

; 432           else
; 433             stGlobalCFGheader.wDelayCount = 0;
	mov	word ptr  stGlobalCFGheader+04h,0h
@BLBL66:

; 434           if (Checked(hwndDlg,PCFG_VERBOSE))
	push	012f5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL67

; 435             stGlobalCFGheader.wLoadFlags |= LOAD_FLAG1_VERBOSE;
	mov	ax,word ptr  stGlobalCFGheader+012h
	or	ax,04000h
	mov	word ptr  stGlobalCFGheader+012h,ax
	jmp	@BLBL68
	align 010h
@BLBL67:

; 436           else
; 437             stGlobalCFGheader.wLoadFlags &= ~LOAD_FLAG1_VERBOSE;
	xor	eax,eax
	mov	ax,word ptr  stGlobalCFGheader+012h
	and	ah,0bfh
	mov	word ptr  stGlobalCFGheader+012h,ax
@BLBL68:

; 438 //          if ((stConfigDeviceCount.wDCBnumber == 0) &&
; 439 //              (stConfigDeviceCount.wLoadNumber == 1))
; 440 //            stGlobalCFGheader.wLoadFlags &= ~LOAD_FLAG1_ADVANCED_CFG;
; 441 //          else
; 442             stGlobalCFGheader.wLoadFlags |= LOAD_FLAG1_ADVANCED_CFG;
	mov	ax,word ptr  stGlobalCFGheader+012h
	or	ax,0800h
	mov	word ptr  stGlobalCFGheader+012h,ax

; 443           PlaceIniCFGheader(szDriverIniPath,&stGlobalCFGheader,&stDCBposition);
	push	offset FLAT:@63stDCBposition
	push	offset FLAT:stGlobalCFGheader
	push	offset FLAT:szDriverIniPath
	call	PlaceIniCFGheader
	add	esp,0ch

; 444           strncpy(szListString,szDriverIniPath,(strlen(szDriverIniPath) - 4));
	mov	eax,offset FLAT:szDriverIniPath
	call	strlen
	sub	eax,04h
	mov	ecx,eax
	mov	edx,offset FLAT:szDriverIniPath
	mov	eax,offset FLAT:szListString
	call	strncpy

; 445           szListString[strlen(szDriverIniPath) - 4] = 0;
	mov	eax,offset FLAT:szDriverIniPath
	call	strlen
	mov	byte ptr [eax+ szListString-04h],0h

; 446           pListItem = pSpoolList;
	mov	eax,dword ptr  pSpoolList
	mov	[ebp-0a4h],eax;	pListItem

; 447           if (pListItem->pData != NULL)
	mov	eax,[ebp-0a4h];	pListItem
	cmp	dword ptr [eax+08h],0h
	je	@BLBL69

; 448             {
; 449             if (DosLoadModule(0,0,szPDRlibrarySpec,&hMod) == NO_ERROR)
	lea	eax,[ebp-0b0h];	hMod
	push	eax
	push	offset FLAT:szPDRlibrarySpec
	push	0h
	push	0h
	call	DosLoadModule
	add	esp,010h
	test	eax,eax
	jne	@BLBL69

; 450               {
; 451               do
	align 010h
@BLBL71:

; 452                 {
; 453                 if (pListItem->pData != NULL)
	mov	eax,[ebp-0a4h];	pListItem
	cmp	dword ptr [eax+08h],0h
	je	@BLBL72

; 454                   {
; 455                   pstSpool = (SPOOLLST *)pListItem->pData;
	mov	eax,[ebp-0a4h];	pListItem
	mov	eax,[eax+08h]
	mov	[ebp-0a8h],eax;	pstSpool

; 456                   if (pstSpool->fAction == INSTALL_SPOOL)
	mov	eax,[ebp-0a8h];	pstSpool
	cmp	dword ptr [eax+0ah],01h
	jne	@BLBL73

; 457                     {
; 458                     if (DosQueryProcAddr(hMod,0,"SPLPDINSTALLPORT",&pfnProcess) == NO_ERROR)
	lea	eax,[ebp-0ach];	pfnProcess
	push	eax
	push	offset FLAT:@STAT26
	push	0h
	push	dword ptr [ebp-0b0h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL72

; 459                       rc = pfnProcess(pstCOMiCFG->hab,pstSpool->szPortName);
	push	dword ptr [ebp-0a8h];	pstSpool
	mov	eax,dword ptr  @6cpstCOMiCFG
	push	dword ptr [eax+02h]
	call	dword ptr [ebp-0ach];	pfnProcess
	add	esp,08h
	mov	[ebp-094h],eax;	rc

; 460                     }
	jmp	@BLBL72
	align 010h
@BLBL73:

; 461                   else
; 462                     {
; 463                     if (DosQueryProcAddr(hMod,0,"SPLPDREMOVEPORT",&pfnPr
; 463 ocess) == NO_ERROR)
	lea	eax,[ebp-0ach];	pfnProcess
	push	eax
	push	offset FLAT:@STAT27
	push	0h
	push	dword ptr [ebp-0b0h];	hMod
	call	DosQueryProcAddr
	add	esp,010h
	test	eax,eax
	jne	@BLBL72

; 464                       rc = pfnProcess(pstCOMiCFG->hab,pstSpool->szPortName);
	push	dword ptr [ebp-0a8h];	pstSpool
	mov	eax,dword ptr  @6cpstCOMiCFG
	push	dword ptr [eax+02h]
	call	dword ptr [ebp-0ach];	pfnProcess
	add	esp,08h
	mov	[ebp-094h],eax;	rc

; 465                     }

; 466                   }
@BLBL72:

; 467                 } while ((pListItem = GetNextListItem(pListItem)) != NULL);
	push	dword ptr [ebp-0a4h];	pListItem
	call	GetNextListItem
	add	esp,04h
	mov	[ebp-0a4h],eax;	pListItem
	cmp	dword ptr [ebp-0a4h],0h;	pListItem
	jne	@BLBL71

; 468               DosFreeModule(hMod);
	push	dword ptr [ebp-0b0h];	hMod
	call	DosFreeModule
	add	esp,04h

; 469               }

; 470             }
@BLBL69:

; 471           bOkToEditConfigSYS = FALSE;
	mov	dword ptr [ebp-090h],0h;	bOkToEditConfigSYS

; 472 //          if (pstCOMiCFG->pszRemoveOldDriverSpec != NULL)
; 473 //            bOkToEditConfigSYS = CleanConfigSys(hwndDlg,pstCOMiCFG->pszRemoveOldDriverSpec,HLPP_MB_CONFIGSYS,TRUE);
; 474           stConfigDeviceCount.wDCBnumber = iDeviceCount;
	mov	eax,dword ptr  iDeviceCount
	mov	word ptr  stConfigDeviceCount+02h,ax

; 475           if ((stConfigDeviceCount.wDCBnumber == 0) &&
	cmp	word ptr  stConfigDeviceCount+02h,0h
	jne	@BLBL78

; 476               (stConfigDeviceCount.wLoadNumber == 1))
	cmp	word ptr  stConfigDeviceCount,01h
	jne	@BLBL78

; 477             iLoadCount = 0;
	mov	dword ptr [ebp-0a0h],0h;	iLoadCount
	jmp	@BLBL79
	align 010h
@BLBL78:

; 478           else
; 479             if (bLimitLoad)
	cmp	dword ptr  bLimitLoad,0h
	je	@BLBL80

; 480               {
; 481               if (!bIniWasEmpty)
	cmp	dword ptr  @79bIniWasEmpty,0h
	jne	@BLBL81

; 482                 bOkToEditConfigSYS = TRUE;
	mov	dword ptr [ebp-090h],01h;	bOkToEditConfigSYS
@BLBL81:

; 483               iLoadCount = 1;
	mov	dword ptr [ebp-0a0h],01h;	iLoadCount

; 484               }
	jmp	@BLBL79
	align 010h
@BLBL80:

; 485             else
; 486               iLoadCount = stConfigDeviceCount.wLoadNumber;
	xor	eax,eax
	mov	ax,word ptr  stConfigDeviceCount
	mov	[ebp-0a0h],eax;	iLoadCount
@BLBL79:

; 487           AdjustConfigSys(hwndDlg,szListString,iLoadCount,bOkToEditConfigSYS,HLPP_MB_CONFIGSYS);
	push	09ca5h
	push	dword ptr [ebp-090h];	bOkToEditConfigSYS
	push	dword ptr [ebp-0a0h];	iLoadCount
	push	offset FLAT:szListString
	push	dword ptr [ebp+08h];	hwndDlg
	call	AdjustConfigSys
	add	esp,014h

; 488           UnMarkAllDevices(astConfigDeviceList);
	push	offset FLAT:astConfigDeviceList
	call	UnMarkAllDevices
	add	esp,04h

; 489           ClearAllIntDCBheader(szDriverIniPath);
	push	offset FLAT:szDriverIniPath
	call	ClearAllIntDCBheader
	add	esp,04h

; 490           DestroyList(&pAddressList);
	push	offset FLAT:pAddressList
	call	DestroyList
	add	esp,04h

; 491           DestroyList(&pInterruptList);
	push	offset FLAT:pInterruptList
	call	DestroyList
	add	esp,04h

; 492           DestroyList(&pSpoolList);
	push	offset FLAT:pSpoolList
	call	DestroyList
	add	esp,04h

; 493           DestroyList(&pLoadAddressList);
	push	offset FLAT:pLoadAddressList
	call	DestroyList
	add	esp,04h

; 494           DestroyList(&pLoadInterruptList);
	push	offset FLAT:pLoadInterruptList
	call	DestroyList
	add	esp,04h

; 495           WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 496           return(MRESULT)TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL150:

; 497         case PCFG_DELETE_LOAD:
; 498           DeleteLoadLists();
	call	DeleteLoadLists

; 499           for (iIndex = 0;iIndex < iDeviceCount;iIndex++)
	mov	dword ptr [ebp-084h],0h;	iIndex
	mov	eax,dword ptr  iDeviceCount
	cmp	[ebp-084h],eax;	iIndex
	jge	@BLBL83
	align 010h
@BLBL84:

; 500             {
; 501             WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_QUERYITEMTEXT,MPFROM2SHORT(iIndex,7),MPFROMP(szCurrentConfigDeviceName));
	push	offset FLAT:szCurrentConfigDeviceName
	mov	ax,[ebp-084h];	iIndex
	and	eax,0ffffh
	or	eax,070000h
	push	eax
	push	0168h
	push	012d6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 502             astConfigDeviceList[atoi(&szCurrentConfigDeviceName[DEV_NUM_INDEX])].bAvailable = TRUE;
	mov	eax,offset FLAT:szCurrentConfigDeviceName+03h
	call	atoi
	imul	eax,0eh
	mov	dword ptr [eax+ astConfigDeviceList+0ah],01h

; 503             }

; 499           for (iIndex = 0;iIndex < iDeviceCount;iIndex++)
	mov	eax,[ebp-084h];	iIndex
	inc	eax
	mov	[ebp-084h],eax;	iIndex
	mov	eax,dword ptr  iDeviceCount
	cmp	[ebp-084h],eax;	iIndex
	jl	@BLBL84
@BLBL83:

; 504           RemoveIniCFGheader(szDriverIniPath,stDCBposition.wLoadNumber);
	mov	ax,word ptr  @63stDCBposition
	push	eax
	push	offset FLAT:szDriverIniPath
	call	RemoveIniCFGheader
	add	esp,08h

; 505           stConfigDeviceCount.wLoadNumber--;
	mov	ax,word ptr  stConfigDeviceCount
	dec	ax
	mov	word ptr  stConfigDeviceCount,ax

; 506           stDCBposition.wLoadNumber = 1;
	mov	word ptr  @63stDCBposition,01h

; 507           if (stConfigDeviceCount.wLoadNumber == 1)
	cmp	word ptr  stConfigDeviceCount,01h
	jne	@BLBL86

; 508             ControlEnable(hwndDlg,PCFG_DELETE_LOAD,FALSE);
	push	0h
	push	01209h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
@BLBL86:

; 509           WinSendDlgItemMsg(hwndDlg,PCFG_LOAD,
	push	01h
	xor	eax,eax
	mov	ax,word ptr  stConfigDeviceCount
	push	eax
	push	0207h
	push	012cch
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 513           WinSendDlgItemMsg(hwndDlg,PCFG_LOAD,
	push	0h
	xor	eax,eax
	mov	ax,word ptr  @63stDCBposition
	push	eax
	push	0208h
	push	012cch
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 517           iDeviceCount = FillDeviceCfgListBox(hwndDlg,stDCBposition,szDriverIniPath,pstCOMiCFG->ulMaxDeviceCount);
	mov	eax,dword ptr  @6cpstCOMiCFG
	push	dword ptr [eax+025h]
	push	offset FLAT:szDriverIniPath
	push	dword ptr  @63stDCBposition
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillDeviceCfgListBox
	add	esp,010h
	mov	dword ptr  iDeviceCount,eax

; 518           QueryIniCFGheader(szDriverIniPath,&stGlobalCFGheader,&stDCBposition);
	push	offset FLAT:@63stDCBposition
	push	offset FLAT:stGlobalCFGheader
	push	offset FLAT:szDriverIniPath
	call	QueryIniCFGheader
	add	esp,0ch

; 519           if (iDeviceCount >= iLoadMaxDevice)
	mov	eax,dword ptr  iLoadMaxDevice
	cmp	dword ptr  iDeviceCount,eax
	jl	@BLBL87

; 520             ControlEnable(hwndDlg,DID_INSERT,FALSE);
	push	0h
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
	jmp	@BLBL88
	align 010h
@BLBL87:

; 522             ControlEnable(hwndDlg,DID_INSERT,TRUE);
	push	01h
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
@BLBL88:

; 523           ControlEnable(hwndDlg,DID_DELETE,FALSE);
	push	0h
	push	012fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 524           ControlEnable(hwndDlg,DID_INSTALL,FALSE);
	push	0h
	push	012eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 525           FillOEMstring(szOEMstring, pstCOMiCFG->byOEMtype);
	mov	eax,dword ptr  @6cpstCOMiCFG
	mov	al,[eax+024h]
	push	eax
	push	offset FLAT:@65szOEMstring
	call	FillOEMstring
	add	esp,08h

; 526           sprintf(szListString,szLoadFormat,stDCBposition.wLoadNumber,szOEMstring);
	push	offset FLAT:@65szOEMstring
	xor	eax,eax
	mov	ax,word ptr  @63stDCBposition
	push	eax
	mov	edx,offset FLAT:szLoadFormat
	mov	eax,offset FLAT:szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 535           WinSetDlgItemText(hwndDlg,PCFG_LOADT,szListString);
	push	offset FLAT:szListString
	push	012ceh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 536           sprintf(szListString,szDeviceDefFormat,stDCBposition.wLoadNumber);
	xor	eax,eax
	mov	ax,word ptr  @63stDCBposition
	push	eax
	mov	edx,offset FLAT:szDeviceDefFormat
	mov	eax,offset FLAT:szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 537           WinSetDlgItemText(hwndDlg,PCFG_DEVT0,szListString);
	push	offset FLAT:szListString
	push	012d7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 538           ControlEnable(hwndDlg,PCFG_ADD_LOAD,TRUE);
	push	01h
	push	0120ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 539           break;
	jmp	@BLBL147
	align 04h
@BLBL151:

; 541           DestroyList(&pLoadAddressList);
	push	offset FLAT:pLoadAddressList
	call	DestroyList
	add	esp,04h

; 542           DestroyList(&pLoadInterruptList);
	push	offset FLAT:pLoadInterruptList
	call	DestroyList
	add	esp,04h

; 543           stConfigDeviceCount.wLoadNumber++;
	mov	ax,word ptr  stConfigDeviceCount
	inc	ax
	mov	word ptr  stConfigDeviceCount,ax

; 544           WinSendDlgItemMsg(hwndDlg,PCFG_LOAD,SPBM_SETLIMITS,(MPARAM)(stConfigDeviceCount.wLoadNumber),(MPARAM)1L);
	push	01h
	xor	eax,eax
	mov	ax,word ptr  stConfigDeviceCount
	push	eax
	push	0207h
	push	012cch
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 545           WinSendDlgItemMsg(hwndDlg,PCFG_LOAD,SPBM_SETCURRENTVALUE,(MPARAM)stConfigDeviceCount.wLoadNumber,NULL);
	push	0h
	xor	eax,eax
	mov	ax,word ptr  stConfigDeviceCount
	push	eax
	push	0208h
	push	012cch
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 546           InitializeCFGheader(&stGlobalCFGheader);
	push	offset FLAT:stGlobalCFGheader
	call	InitializeCFGheader
	add	esp,04h

; 547           AddIniConfigHeader(szDriverIniPath,&stDCBposition);
	push	offset FLAT:@63stDCBposition
	push	offset FLAT:szDriverIniPath
	call	AddIniConfigHeader
	add	esp,08h

; 548           ControlEnable(hwndDlg,PCFG_ADD_LOAD,FALSE);
	push	0h
	push	0120ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 549           ControlEnable(hwndDlg,PCFG_DELETE_LOAD,TRUE);
	push	01h
	push	01209h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 550           ControlEnable(hwndDlg,DID_INSERT,TRUE);
	push	01h
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 551           ControlEnable(hwndDlg,DID_DELETE,FALSE);
	push	0h
	push	012fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 552           ControlEnable(hwndDlg,DID_INSTALL,FALSE);
	push	0h
	push	012eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 553           WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_DELETEALL,0L,0L);
	push	0h
	push	0h
	push	016eh
	push	012d6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 554           szOEMstring[0] = 0;
	mov	byte ptr  @65szOEMstring,0h

; 555           sprintf(szListString,szLoadFormat,stDCBposition.wLoadNumber,szOEMstring);
	push	offset FLAT:@65szOEMstring
	xor	eax,eax
	mov	ax,word ptr  @63stDCBposition
	push	eax
	mov	edx,offset FLAT:szLoadFormat
	mov	eax,offset FLAT:szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 573             pstCOMiCFG->bPCIadapter = FALSE;
	mov	eax,dword ptr  @6cpstCOMiCFG
	and	byte ptr [eax+04bh],07fh

; 574           WinSetDlgItemText(hwndDlg,PCFG_LOADT,szListString);
	push	offset FLAT:szListString
	push	012ceh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 575           sprintf(szListString,szDeviceDefFormat,stDCBposition.wLoadNumber);
	xor	eax,eax
	mov	ax,word ptr  @63stDCBposition
	push	eax
	mov	edx,offset FLAT:szDeviceDefFormat
	mov	eax,offset FLAT:szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 576           WinSetDlgItemText(hwndDlg,PCFG_DEVT0,szListString);
	push	offset FLAT:szListString
	push	012d7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 577           iDeviceCount = 0;
	mov	dword ptr  iDeviceCount,0h

; 578           iItemSelected = LIT_NONE;
	mov	dword ptr  @6aiItemSelected,0ffffffffh

; 579           if (pstCOMiCFG->ulMaxDeviceCount != 0)
	mov	eax,dword ptr  @6cpstCOMiCFG
	cmp	dword ptr [eax+025h],0h
	je	@BLBL89

; 581             iLoadMaxDevice = iOEMloadMaxDevice;
	mov	eax,dword ptr  iOEMloadMaxDevice
	mov	dword ptr  iLoadMaxDevice,eax

; 582             if ((pstCOMiCFG->ulMaxDeviceCount / iOEMloadMaxDevice) > 0)
	mov	eax,dword ptr  @6cpstCOMiCFG
	mov	eax,[eax+025h]
	mov	ecx,dword ptr  iOEMloadMaxDevice
	xor	edx,edx
	div	ecx
	test	eax,eax
	jbe	@BLBL89

; 583               if ((stConfigDeviceCount.wLoadNumber / (pstCOMiCFG->ulMaxDeviceCount / iOEMloadMaxDevice)) == 0)
	mov	eax,dword ptr  @6cpstCOMiCFG
	mov	eax,[eax+025h]
	mov	ecx,dword ptr  iOEMloadMaxDevice
	xor	edx,edx
	div	ecx
	mov	ecx,eax
	xor	eax,eax
	mov	ax,word ptr  stConfigDeviceCount
	xor	edx,edx
	div	ecx
	test	eax,eax
	jne	@BLBL89

; 584                 iLoadMaxDevice = (pstCOMiCFG->ulMaxDeviceCount % iOEMloadMaxDevice);
	mov	eax,dword ptr  @6cpstCOMiCFG
	mov	eax,[eax+025h]
	mov	ecx,dword ptr  iOEMloadMaxDevice
	xor	edx,edx
	div	ecx
	mov	dword ptr  iLoadMaxDevice,edx

; 585             }
@BLBL89:

; 586           break;
	jmp	@BLBL147
	align 04h
@BLBL152:
@BLBL153:

; 596           if (WinDlgBox(HWND_DESKTOP,
	push	dword ptr  @6cpstCOMiCFG
	push	011feh
	mov	eax,dword ptr  hThisModule
	push	eax
	push	offset FLAT: fnwpPortOEMconfigDlgProc
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL92

; 603             FillOEMstring(szOEMstring, pstCOMiCFG->byOEMtype);
	mov	eax,dword ptr  @6cpstCOMiCFG
	mov	al,[eax+024h]
	push	eax
	push	offset FLAT:@65szOEMstring
	call	FillOEMstring
	add	esp,08h

; 604             sprintf(szListString,szLoadFormat,stDCBposition.wLoadNumber,szOEMstring);
	push	offset FLAT:@65szOEMstring
	xor	eax,eax
	mov	ax,word ptr  @63stDCBposition
	push	eax
	mov	edx,offset FLAT:szLoadFormat
	mov	eax,offset FLAT:szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 605             WinSetDlgItemText(hwndDlg,PCFG_LOADT,szListString);
	push	offset FLAT:szListString
	push	012ceh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 606             PlaceIniCFGheader(szDriverIniPath,&stGlobalCFGheader,&stDCBposition);
	push	offset FLAT:@63stDCBposition
	push	offset FLAT:stGlobalCFGheader
	push	offset FLAT:szDriverIniPath
	call	PlaceIniCFGheader
	add	esp,0ch

; 612               iDeviceCount = FillDeviceCfgListBox(hwndDlg,stDCBposition,szDriverIniPath,pstCOMiCFG->ulMaxDeviceCount);
	mov	eax,dword ptr  @6cpstCOMiCFG
	push	dword ptr [eax+025h]
	push	offset FLAT:szDriverIniPath
	push	dword ptr  @63stDCBposition
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillDeviceCfgListBox
	add	esp,010h
	mov	dword ptr  iDeviceCount,eax

; 613               iItemSelected = LIT_NONE;
	mov	dword ptr  @6aiItemSelected,0ffffffffh

; 614               ControlEnable(hwndDlg,DID_DELETE,FALSE);
	push	0h
	push	012fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 615               ControlEnable(hwndDlg,DID_INSTALL,FALSE);
	push	0h
	push	012eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 616               }

; 617             }
@BLBL92:

; 618           break;
	jmp	@BLBL147
	align 04h
@BLBL154:

; 620           stDCBposition.wDCBnumber = 0;
	mov	word ptr  @63stDCBposition+02h,0h

; 621           szCurrentConfigDeviceName[0] = 0;
	mov	byte ptr  szCurrentConfigDeviceName,0h

; 622           bInsertNewDevice = TRUE;
	mov	dword ptr  bInsertNewDevice,01h

; 623           WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_SELECTITEM,MPFROMSHORT(LIT_NONE),MPFROMSHORT(FALSE));
	push	0h
	push	0ffffh
	push	0164h
	push	012d6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 624           InitializeDCBheader(&stGlobalDCBheader,pstCOMiCFG->bInstallCOMscope);
	mov	eax,dword ptr  @6cpstCOMiCFG
	mov	al,[eax+04bh]
	and	eax,03h
	shr	eax,01h
	push	eax
	push	offset FLAT:stGlobalDCBheader
	call	InitializeDCBheader
	add	esp,08h

; 626           ControlEnable(hwndDlg,DID_DELETE,FALSE);
	push	0h
	push	012fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 627           ControlEnable(hwndDlg,DID_INSTALL,FALSE);
	push	0h
	push	012eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
@BLBL155:

; 629           if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL93

; 631             if ((iItemJustSelected = (int)WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_QUERYSELECTION,0L,0L)) == LIT_NONE)
	push	0h
	push	0h
	push	0165h
	push	012d6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h
	mov	[ebp-04h],eax;	iItemJustSelected
	cmp	dword ptr [ebp-04h],0ffffffffh;	iItemJustSelected
	jne	@BLBL94

; 632               break;
	jmp	@BLBL147
	align 04h
@BLBL94:

; 633             if (iItemJustSelected != iItemSelected)
	mov	eax,dword ptr  @6aiItemSelected
	cmp	[ebp-04h],eax;	iItemJustSelected
	je	@BLBL93

; 635               iItemSelected = iItemJustSe
; 635 lected;
	mov	eax,[ebp-04h];	iItemJustSelected
	mov	dword ptr  @6aiItemSelected,eax

; 636               WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_QUERYITEMTEXT,MPFROM2SHORT(iItemSelected,7),MPFROMP(szCurrentConfigDeviceName));
	push	offset FLAT:szCurrentConfigDeviceName
	mov	ax,word ptr  @6aiItemSelected
	and	eax,0ffffh
	or	eax,070000h
	push	eax
	push	0168h
	push	012d6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 637               RemoveLeadingSpaces(szCurrentConfigDeviceName);
	push	offset FLAT:szCurrentConfigDeviceName
	call	RemoveLeadingSpaces
	add	esp,04h

; 638               RemoveSpaces(szCurrentConfigDeviceName);
	push	offset FLAT:szCurrentConfigDeviceName
	call	RemoveSpaces
	add	esp,04h

; 639               strncpy(stGlobalDCBheader.abyPortName,szCurrentConfigDeviceName,8);
	mov	ecx,08h
	mov	edx,offset FLAT:szCurrentConfigDeviceName
	mov	eax,offset FLAT:stGlobalDCBheader
	call	strncpy

; 640               MakeDeviceName(stGlobalDCBheader.abyPortName);
	push	offset FLAT:stGlobalDCBheader
	call	MakeDeviceName
	add	esp,04h

; 641               if (!QueryIniDCBheaderName(szDriverIniPath,&stGlobalCFGheader,&stGlobalDCBheader,&stDCBposition))
	push	offset FLAT:@63stDCBposition
	push	offset FLAT:stGlobalDCBheader
	push	offset FLAT:stGlobalCFGheader
	push	offset FLAT:szDriverIniPath
	call	QueryIniDCBheaderName
	add	esp,010h
	test	eax,eax
	jne	@BLBL96

; 643                 stGlobalDCBheader.abyPortName[0] = '$';
	mov	byte ptr  stGlobalDCBheader,024h

; 644                 QueryIniDCBheaderName(szDriverIniPath,&stGlobalCFGheader,&stGlobalDCBheader,&stDCBposition);
	push	offset FLAT:@63stDCBposition
	push	offset FLAT:stGlobalDCBheader
	push	offset FLAT:stGlobalCFGheader
	push	offset FLAT:szDriverIniPath
	call	QueryIniDCBheaderName
	add	esp,010h

; 645                 }
@BLBL96:

; 646               byLastIntLevel = stGlobalDCBheader.stComDCB.byInterruptLevel;
	mov	al,byte ptr  stGlobalDCBheader+030h
	mov	byte ptr  byLastIntLevel,al

; 647               wLastAddress = stGlobalDCBheader.stComDCB.wIObaseAddress;
	mov	ax,word ptr  stGlobalDCBheader+016h
	mov	word ptr  wLastAddress,ax

; 648               strcpy(szLastName,szCurrentConfigDeviceName);
	mov	edx,offset FLAT:szCurrentConfigDeviceName
	mov	eax,offset FLAT:szLastName
	call	strcpy

; 649               }

; 650             }
@BLBL93:

; 652           if (bWarp4)
	cmp	dword ptr  bWarp4,0h
	je	@BLBL97

; 653             idDialog = DLG_CONFIGURECOMI_40;
	mov	dword ptr [ebp-0b4h],02cd0h;	idDialog
	jmp	@BLBL98
	align 010h
@BLBL97:

; 655             idDialog = DLG_CONFIGURECOMI_30;
	mov	dword ptr [ebp-0b4h],02ccah;	idDialog
@BLBL98:

; 657           if ((rc = WinDlgBox(HWND_DESKTOP,
	push	dword ptr  @6cpstCOMiCFG
	push	dword ptr [ebp-0b4h];	idDialog
	mov	eax,dword ptr  hThisModule
	push	eax
	push	offset FLAT: fnwpDeviceSetupDlgProc
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinDlgBox
	add	esp,018h
	mov	[ebp-094h],eax;	rc
	cmp	dword ptr [ebp-094h],01h;	rc
	jne	@BLBL99

; 664             strncpy(stGlobalDCBheader.abyPortName,szCurrentConfigDeviceName,8);
	mov	ecx,08h
	mov	edx,offset FLAT:szCurrentConfigDeviceName
	mov	eax,offset FLAT:stGlobalDCBheader
	call	strncpy

; 665             MakeDeviceName(stGlobalDCBheader.abyPortName);
	push	offset FLAT:stGlobalDCBheader
	call	MakeDeviceName
	add	esp,04h

; 666             strcpy(szLastName,szCurrentConfigDeviceName);
	mov	edx,offset FLAT:szCurrentConfigDeviceName
	mov	eax,offset FLAT:szLastName
	call	strcpy

; 667             if (stGlobalDCBheader.stComDCB.wIObaseAddress == 0xffff)
	cmp	word ptr  stGlobalDCBheader+016h,0ffffh
	jne	@BLBL100

; 668               stGlobalDCBheader.abyPortName[0] = '$';
	mov	byte ptr  stGlobalDCBheader,024h
@BLBL100:

; 669             if (!PlaceIniDCBheader(szDriverIniPath,&stGlobalCFGheader,&stGlobalDCBheader,&stDCBposition))
	push	offset FLAT:@63stDCBposition
	push	offset FLAT:stGlobalDCBheader
	push	offset FLAT:stGlobalCFGheader
	push	offset FLAT:szDriverIniPath
	call	PlaceIniDCBheader
	add	esp,010h
	test	eax,eax
	jne	@BLBL101

; 671               if (bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	je	@BLBL101

; 673                 stDCBposition.wLoadNumber = 0;
	mov	word ptr  @63stDCBposition,0h

; 674                 if (!PlaceIniDCBheader(szDriverIniPath,&stGlobalCFGheader,&stGlobalDCBheader,&stDCBposition))
	push	offset FLAT:@63stDCBposition
	push	offset FLAT:stGlobalDCBheader
	push	offset FLAT:stGlobalCFGheader
	push	offset FLAT:szDriverIniPath
	call	PlaceIniDCBheader
	add	esp,010h
	test	eax,eax
	jne	@BLBL101

; 676                   bInsertNewDevice = FALSE;
	mov	dword ptr  bInsertNewDevice,0h

; 677                   break;
	jmp	@BLBL147
	align 04h
@BLBL101:

; 681             if (stGlobalDCBheader.stComDCB.wIObaseAddress == 0xffff)
	cmp	word ptr  stGlobalDCBheader+016h,0ffffh
	jne	@BLBL104

; 682               sprintf(szListString,szSkipFormat,szCurrentConfigDeviceName);
	push	offset FLAT:szCurrentConfigDeviceName
	mov	edx,offset FLAT:szSkipFormat
	mov	eax,offset FLAT:szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	jmp	@BLBL105
	align 010h
@BLBL104:

; 685               if (!pstCOMiCFG->bPCIadapter)
	mov	eax,dword ptr  @6cpstCOMiCFG
	test	byte ptr [eax+04bh],080h
	jne	@BLBL106

; 687                 if ((byIntLevel = stGlobalCFGheader.byInterruptLevel) == 0)
	mov	al,byte ptr  stGlobalCFGheader+0bh
	mov	[ebp-089h],al;	byIntLevel
	cmp	byte ptr [ebp-089h],0h;	byIntLevel
	jne	@BLBL107

; 688                   byIntLevel = stGlobalDCBheader.stComDCB.byInterruptLevel;
	mov	al,byte ptr  stGlobalDCBheader+030h
	mov	[ebp-089h],al;	byIntLevel
@BLBL107:

; 689                 iLen = sprintf(szListString,szListFormat,szCurrentConfigDeviceName,
	xor	eax,eax
	mov	al,[ebp-089h];	byIntLevel
	push	eax
	xor	eax,eax
	mov	ax,word ptr  stGlobalDCBheader+016h
	push	eax
	push	offset FLAT:szCurrentConfigDeviceName
	mov	edx,offset FLAT:szListFormat
	mov	eax,offset FLAT:szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,014h
	mov	[ebp-080h],eax;	iLen

; 692                 }
	jmp	@BLBL108
	align 010h
@BLBL106:

; 694                 iLen = sprintf(szListString,szPCIdevice,szCurrentConfigDeviceName);
	push	offset FLAT:szCurrentConfigDeviceName
	mov	edx,offset FLAT:szPCIdevice
	mov	eax,offset FLAT:szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	mov	[ebp-080h],eax;	iLen
@BLBL108:

; 695               AppendOptionList(&stGlobalDCBheader,&szListString[iLen]);
	mov	eax,[ebp-080h];	iLen
	add	eax,offset FLAT:szListString
	push	eax
	push	offset FLAT:stGlobalDCBheader
	call	AppendOptionList
	add	esp,08h

; 696               }
@BLBL105:

; 697             if (bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	je	@BLBL109

; 698               {

; 702                 if (pstCOMiCFG->ulMaxDeviceCount != 0)
	mov	eax,dword ptr  @6cpstCOMiCFG
	cmp	dword ptr [eax+025h],0h
	je	@BLBL110

; 704                   if (stConfigDeviceCount.wLoadNumber < ((pstCOMiCFG->ulMaxDeviceCount / iOEMloadMaxDevice) + 1))
	mov	eax,dword ptr  @6cpstCOMiCFG
	mov	eax,[eax+025h]
	mov	ecx,dword ptr  iOEMloadMaxDevice
	xor	edx,edx
	div	ecx
	inc	eax
	xor	ecx,ecx
	mov	cx,word ptr  stConfigDeviceCount
	cmp	eax,ecx
	jbe	@BLBL112

; 705                     ControlEnable(hwndDlg,PCFG_ADD_LOAD,TRUE);
	push	01h
	push	0120ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 706                   }
	jmp	@BLBL112
	align 010h
@BLBL110:

; 708                   ControlEnable(hwndDlg,PCFG_ADD_LOAD,TRUE);
	push	01h
	push	0120ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
@BLBL112:

; 709                 }

; 713               iDeviceCount = FillDeviceCfgListBox(hwndDlg,stDCBposition,szDriverIniPath,pstCOMiCFG->ulMaxDeviceCount);
	mov	eax,dword ptr  @6cpstCOMiCFG
	push	dword ptr [eax+025h]
	push	offset FLAT:szDriverIniPath
	push	dword ptr  @63stDCBposition
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillDeviceCfgListBox
	add	esp,010h
	mov	dword ptr  iDeviceCount,eax

; 714               if (iDeviceCount >= iLoadMaxDevice)
	mov	eax,dword ptr  iLoadMaxDevice
	cmp	dword ptr  iDeviceCount,eax
	jl	@BLBL115

; 715                 ControlEnable(hwndDlg,DID_INSERT,FALSE);
	push	0h
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 716               }
	jmp	@BLBL115
	align 010h
@BLBL109:

; 719                 WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_SETITEMTEXT,MPFROMSHORT(iItemSelected),MPFROMP(szListString));
	push	offset FLAT:szListString
	mov	ax,word ptr  @6aiItemSelected
	and	eax,0ffffh
	push	eax
	push	0166h
	push	012d6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 720             }
	jmp	@BLBL115
	align 010h
@BLBL99:

; 723             if (rc == DID_ERROR)
	cmp	dword ptr [ebp-094h],0ffffh;	rc
	jne	@BLBL115

; 725               eidError = WinGetLastError(pstCOMiCFG->hab);
	mov	eax,dword ptr  @6cpstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinGetLastError
	add	esp,04h
	mov	[ebp-0b8h],eax;	eidError

; 726               sprintf(szMessage,"Error loading Port Config Dialog - rc = %08X",eidError);
	push	dword ptr [ebp-0b8h];	eidError
	mov	edx,offset FLAT:@STAT28
	lea	eax,[ebp-011ch];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 727               MessageBox(HWND_DESKTOP,szMessage);
	lea	eax,[ebp-011ch];	szMessage
	push	eax
	push	01h
	call	MessageBox
	add	esp,08h

; 728               }
@BLBL115:

; 730             }

; 732           bInsertNewDevice = FALSE;
	mov	dword ptr  bInsertNewDevice,0h

; 733           break;
	jmp	@BLBL147
	align 04h
@BLBL156:

; 735           if ((iItemJustSelected = (int)WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_QUERYSELECTION,0L,0L)) == LIT_NONE)
	push	0h
	push	0h
	push	0165h
	push	012d6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h
	mov	[ebp-04h],eax;	iItemJustSelected
	cmp	dword ptr [ebp-04h],0ffffffffh;	iItemJustSelected
	jne	@BLBL117

; 736             break;
	jmp	@BLBL147
	align 04h
@BLBL117:

; 737           if (iItemJustSelected != iItemSelected)
	mov	eax,dword ptr  @6aiItemSelected
	cmp	[ebp-04h],eax;	iItemJustSelected
	je	@BLBL118

; 739             WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_QUERYITEMTEXT,MPFROM2SHORT(iItemJustSelected,7),MPFROMP(szCurrentConfigDeviceName));
	push	offset FLAT:szCurrentConfigDeviceName
	mov	ax,[ebp-04h];	iItemJustSelected
	and	eax,0ffffh
	or	eax,070000h
	push	eax
	push	0168h
	push	012d6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 740             RemoveLeadingSpaces(szCurrentConfigDeviceName);
	push	offset FLAT:szCurrentConfigDeviceName
	call	RemoveLeadingSpaces
	add	esp,04h

; 741             RemoveSpaces(szCurrentConfigDeviceName);
	push	offset FLAT:szCurrentConfigDeviceName
	call	RemoveSpaces
	add	esp,04h

; 742             strncpy(stGlobalDCBheader.abyPortName,szCurrentConfigDeviceName,8);
	mov	ecx,08h
	mov	edx,offset FLAT:szCurrentConfigDeviceName
	mov	eax,offset FLAT:stGlobalDCBheader
	call	strncpy

; 743             MakeDeviceName(stGlobalDCBheader.abyPortName);
	push	offset FLAT:stGlobalDCBheader
	call	MakeDeviceName
	add	esp,04h

; 744             if (!QueryIniDCBheaderName(szDriverIniPath,&stGlobalCFGheader,&stGlobalDCBheader,&stDCBposition))
	push	offset FLAT:@63stDCBposition
	push	offset FLAT:stGlobalDCBheader
	push	offset FLAT:stGlobalCFGheader
	push	offset FLAT:szDriverIniPath
	call	QueryIniDCBheaderName
	add	esp,010h
	test	eax,eax
	jne	@BLBL118

; 746               stGlobalDCBheader.abyPortName[0] = '$';
	mov	byte ptr  stGlobalDCBheader,024h

; 747               QueryIniDCBheaderName(szDriverIniPath,&stGlobalCFGheader,&stGlobalDCBheader,&stDCBposition);
	push	offset FLAT:@63stDCBposition
	push	offset FLAT:stGlobalDCBheader
	push	offset FLAT:stGlobalCFGheader
	push	offset FLAT:szDriverIniPath
	call	QueryIniDCBheaderName
	add	esp,010h

; 748               }

; 749             }
@BLBL118:

; 750           DeleteListItems(&stGlobalCFGheader,&stGlobalDCBheader);
	push	offset FLAT:stGlobalDCBheader
	push	offset FLAT:stGlobalCFGheader
	call	DeleteListItems
	add	esp,08h

; 751           astConfigDeviceList[atoi(&szCurrentConfigDeviceName[DEV_NUM_INDEX])].bAvailable = TRUE;
	mov	eax,offset FLAT:szCurrentConfigDeviceName+03h
	call	atoi
	imul	eax,0eh
	mov	dword ptr [eax+ astConfigDeviceList+0ah],01h

; 752           szCurrentConfigDeviceName[0] = 0;
	mov	byte ptr  szCurrentConfigDeviceName,0h

; 753           RemoveIniDCBheader(szDriverIniPath,&stDCBposition);
	push	offset FLAT:@63stDCBposition
	push	offset FLAT:szDriverIniPath
	call	RemoveIniDCBheader
	add	esp,08h

; 754           InitializeDCBheader(&stGlobalDCBheader,pstCOMiCFG->bInstallCOMscope);
	mov	eax,dword ptr  @6cpstCOMiCFG
	mov	al,[eax+04bh]
	and	eax,03h
	shr	eax,01h
	push	eax
	push	offset FLAT:stGlobalDCBheader
	call	InitializeDCBheader
	add	esp,08h

; 755           iDeviceCount = FillDeviceCfgListBox(hwndDlg,stDCBposition,szDriverIniPath,pstCOMiCFG->ulMaxDeviceCount);
	mov	eax,dword ptr  @6cpstCOMiCFG
	push	dword ptr [eax+025h]
	push	offset FLAT:szDriverIniPath
	push	dword ptr  @63stDCBposition
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillDeviceCfgListBox
	add	esp,010h
	mov	dword ptr  iDeviceCount,eax

; 756           if (iDeviceCount == 0)
	cmp	dword ptr  iDeviceCount,0h
	jne	@BLBL120

; 757             ControlEnable(hwndDlg,PCFG_ADD_LOAD,FALSE);
	push	0h
	push	0120ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
@BLBL120:

; 758           ControlEnable(hwndDlg,DID_INSERT,TRUE);
	push	01h
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 759           ControlEnable(hwndDlg,DID_INSTALL,FALSE);
	push	0h
	push	012eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 760           ControlEnable(hwndDlg,DID_DELETE,FALSE);
	push	0h
	push	012fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 761           iItemSelected = LIT_NONE;
	mov	dword ptr  @6aiItemSelected,0ffffffffh

; 762           break;
	jmp	@BLBL147
	align 04h
@BLBL157:

; 764           DisplayHelpPanel(pstCOMiCFG,HLPP_INSTALL_DLG);
	push	07547h
	push	dword ptr  @6cpstCOMiCFG
	call	DisplayHelpPanel
	add	esp,08h

; 765           return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL158:

; 767           UnMarkAllDevices(astConfigDeviceList);
	push	offset FLAT:astConfigDeviceList
	call	UnMarkAllDevices
	add	esp,04h

; 768           DestroyList(&pAddressList);
	push	offset FLAT:pAddressList
	call	DestroyList
	add	esp,04h

; 769           DestroyList(&pSpoolList);
	push	offset FLAT:pSpoolList
	call	DestroyList
	add	esp,04h

; 770           DestroyList(&pInterruptList);
	push	offset FLAT:pInterruptList
	call	DestroyList
	add	esp,04h

; 771           DestroyList(&pLoadAddressList);
	push	offset FLAT:pLoadAddressList
	call	DestroyList
	add	esp,04h

; 772           DestroyList(&pLoadInterruptList);
	push	offset FLAT:pLoadInterruptList
	call	DestroyList
	add	esp,04h

; 773           WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 774           return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL159:

; 776           return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
	jmp	@BLBL147
	align 04h
@BLBL148:
	cmp	eax,01h
	je	@BLBL149
	cmp	eax,01209h
	je	@BLBL150
	cmp	eax,0120ah
	je	@BLBL151
	cmp	eax,0134h
	je	@BLBL152
	cmp	eax,0131h
	je	@BLBL153
	cmp	eax,0130h
	je	@BLBL154
	cmp	eax,012eh
	je	@BLBL155
	cmp	eax,012fh
	je	@BLBL156
	cmp	eax,012dh
	je	@BLBL157
	cmp	eax,02h
	je	@BLBL158
	jmp	@BLBL159
	align 04h
@BLBL147:

; 778       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL160:

; 780       switch (SHORT2FROMMP(mp1))
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	and	eax,0ffffh
	jmp	@BLBL162
	align 04h
@BLBL163:

; 783           if (SHORT1FROMMP(mp1) == DID_OEM)
	mov	ax,[ebp+010h];	mp1
	cmp	ax,0131h
	jne	@BLBL121

; 785             pstButton = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	[ebp-098h],eax;	pstButton

; 786             if (pstButton->fsState == BDS_HILITED)
	mov	eax,[ebp-098h];	pstButton
	cmp	dword ptr [eax+08h],0100h
	jne	@BLBL122

; 787                hBitmap = GpiLoadBitmap(pstButton->hps,hThisModule,ID_OEM_BITMAP1,lXbutton,lYbutton);
	push	dword ptr  lYbutton
	push	dword ptr  lXbutton
	push	01cdh
	mov	eax,dword ptr  hThisModule
	push	eax
	mov	eax,[ebp-098h];	pstButton
	push	dword ptr [eax+04h]
	call	GpiLoadBitmap
	add	esp,014h
	mov	[ebp-09ch],eax;	hBitmap
	jmp	@BLBL123
	align 010h
@BLBL122:

; 789                hBitmap = GpiLoadBitmap(pstButton->hps,hThisModule,ID_OEM_BITMAP2,lXbutton,lYbutton);
	push	dword ptr  lYbutton
	push	dword ptr  lXbutton
	push	01d0h
	mov	eax,dword ptr  hThisModule
	push	eax
	mov	eax,[ebp-098h];	pstButton
	push	dword ptr [eax+04h]
	call	GpiLoadBitmap
	add	esp,014h
	mov	[ebp-09ch],eax;	hBitmap
@BLBL123:

; 790             WinDrawBitmap(pstButton->hps,hBitmap,0,&ptl,0,0,DBM_NORMAL);
	push	0h
	push	0h
	push	0h
	push	offset FLAT:@73ptl
	push	0h
	push	dword ptr [ebp-09ch];	hBitmap
	mov	eax,[ebp-098h];	pstButton
	push	dword ptr [eax+04h]
	call	WinDrawBitmap
	add	esp,01ch

; 791             }
@BLBL121:

; 792           break;
	jmp	@BLBL161
	align 04h
@BLBL164:

; 794           WinSendDlgItemMsg(hwndDlg,PCFG_LOAD,
	push	0h
	lea	eax,[ebp-088h];	lNewLoadNumber
	push	eax
	push	0205h
	push	012cch
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 798           if (stDCBposition.wLoadNumber != (WORD)lNewLoadNumber)
	mov	ax,[ebp-088h];	lNewLoadNumber
	cmp	word ptr  @63stDCBposition,ax
	je	@BLBL124

; 800             if (Checked(hwndDlg,PCFG_KEY_WAIT))
	push	011fch
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL125

; 802               WinQueryDlgItemText(hwndDlg,PCFG_DELAY,6,szString);
	lea	eax,[ebp-07ch];	szString
	push	eax
	push	06h
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinQueryDlgItemText
	add	esp,010h

; 803               if ((stGlobalCFGheader.wDelayCount = (WORD)atoi(szString)) < 10)
	lea	eax,[ebp-07ch];	szString
	call	atoi
	mov	word ptr  stGlobalCFGheader+04h,ax
	mov	ax,word ptr  stGlobalCFGheader+04h
	cmp	ax,0ah
	jae	@BLBL127

; 804                 stGlobalCFGheader.wDelayCount = 10;
	mov	word ptr  stGlobalCFGheader+04h,0ah

; 805               }
	jmp	@BLBL127
	align 010h
@BLBL125:

; 807               stGlobalCFGheader.wDelayCount = 0;
	mov	word ptr  stGlobalCFGheader+04h,0h
@BLBL127:

; 808  
; 808            if (Checked(hwndDlg,PCFG_VERBOSE))
	push	012f5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL128

; 809               stGlobalCFGheader.wLoadFlags |= LOAD_FLAG1_VERBOSE;
	mov	ax,word ptr  stGlobalCFGheader+012h
	or	ax,04000h
	mov	word ptr  stGlobalCFGheader+012h,ax
	jmp	@BLBL129
	align 010h
@BLBL128:

; 811               stGlobalCFGheader.wLoadFlags &= ~LOAD_FLAG1_VERBOSE;
	xor	eax,eax
	mov	ax,word ptr  stGlobalCFGheader+012h
	and	ah,0bfh
	mov	word ptr  stGlobalCFGheader+012h,ax
@BLBL129:

; 812             stGlobalCFGheader.wLoadFlags |= LOAD_FLAG1_ADVANCED_CFG;
	mov	ax,word ptr  stGlobalCFGheader+012h
	or	ax,0800h
	mov	word ptr  stGlobalCFGheader+012h,ax

; 813             PlaceIniCFGheader(szDriverIniPath,&stGlobalCFGheader,&stDCBposition);
	push	offset FLAT:@63stDCBposition
	push	offset FLAT:stGlobalCFGheader
	push	offset FLAT:szDriverIniPath
	call	PlaceIniCFGheader
	add	esp,0ch

; 814             stDCBposition.wLoadNumber = (WORD)lNewLoadNumber;
	mov	eax,[ebp-088h];	lNewLoadNumber
	mov	word ptr  @63stDCBposition,ax

; 815             iItemSelected = LIT_NONE;
	mov	dword ptr  @6aiItemSelected,0ffffffffh

; 816             DestroyList(&pLoadAddressList);
	push	offset FLAT:pLoadAddressList
	call	DestroyList
	add	esp,04h

; 817             DestroyList(&pLoadInterruptList);
	push	offset FLAT:pLoadInterruptList
	call	DestroyList
	add	esp,04h

; 818             iDeviceCount = FillDeviceCfgListBox(hwndDlg,stDCBposition,szDriverIniPath,pstCOMiCFG->ulMaxDeviceCount);
	mov	eax,dword ptr  @6cpstCOMiCFG
	push	dword ptr [eax+025h]
	push	offset FLAT:szDriverIniPath
	push	dword ptr  @63stDCBposition
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillDeviceCfgListBox
	add	esp,010h
	mov	dword ptr  iDeviceCount,eax

; 819             QueryIniCFGheader(szDriverIniPath,&stGlobalCFGheader,&stDCBposition);
	push	offset FLAT:@63stDCBposition
	push	offset FLAT:stGlobalCFGheader
	push	offset FLAT:szDriverIniPath
	call	QueryIniCFGheader
	add	esp,0ch

; 820             CheckButton(hwndDlg,PCFG_VERBOSE,(stGlobalCFGheader.wLoadFlags & LOAD_FLAG1_VERBOSE));
	xor	eax,eax
	mov	ax,word ptr  stGlobalCFGheader+012h
	and	eax,04000h
	push	eax
	push	012f5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 821             if (stGlobalCFGheader.wDelayCount != 0)
	cmp	word ptr  stGlobalCFGheader+04h,0h
	je	@BLBL130

; 823               CheckButton(hwndDlg,PCFG_KEY_WAIT,TRUE);
	push	01h
	push	011fch
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 824               wLastDelayCount = stGlobalCFGheader.wDelayCount;
	mov	ax,word ptr  stGlobalCFGheader+04h
	mov	word ptr  wLastDelayCount,ax

; 825               sprintf(szString,"%u",wLastDelayCount);
	xor	eax,eax
	mov	ax,word ptr  wLastDelayCount
	push	eax
	mov	edx,offset FLAT:@STAT29
	lea	eax,[ebp-07ch];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 826               WinSendDlgItemMsg(hwndDlg,PCFG_DELAY,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
	push	0h
	push	05h
	push	0143h
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 827               WinSetDlgItemText(hwndDlg,PCFG_DELAY,szString);
	lea	eax,[ebp-07ch];	szString
	push	eax
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 828               ControlEnable(hwndDlg,PCFG_DELAYT,TRUE);
	push	01h
	push	011fdh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 829               ControlEnable(hwndDlg,PCFG_DELAY,TRUE);
	push	01h
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 830               }
	jmp	@BLBL131
	align 010h
@BLBL130:

; 833               CheckButton(hwndDlg,PCFG_KEY_WAIT,FALSE);
	push	0h
	push	011fch
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 834               wLastDelayCount = 300;
	mov	word ptr  wLastDelayCount,012ch

; 835               sprintf(szString,"%u",wLastDelayCount);
	xor	eax,eax
	mov	ax,word ptr  wLastDelayCount
	push	eax
	mov	edx,offset FLAT:@STAT2a
	lea	eax,[ebp-07ch];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 836               WinSendDlgItemMsg(hwndDlg,PCFG_DELAY,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
	push	0h
	push	05h
	push	0143h
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 837               WinSetDlgItemText(hwndDlg,PCFG_DELAY,szString);
	lea	eax,[ebp-07ch];	szString
	push	eax
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 838               ControlEnable(hwndDlg,PCFG_DELAYT,FALSE);
	push	0h
	push	011fdh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 839               ControlEnable(hwndDlg,PCFG_DELAY,FALSE);
	push	0h
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 840               }
@BLBL131:

; 841             FillOEMstring(szOEMstring, pstCOMiCFG->byOEMtype);
	mov	eax,dword ptr  @6cpstCOMiCFG
	mov	al,[eax+024h]
	push	eax
	push	offset FLAT:@65szOEMstring
	call	FillOEMstring
	add	esp,08h

; 842             sprintf(szListString,szLoadFormat,stDCBposition.wLoadNumber,szOEMstring);
	push	offset FLAT:@65szOEMstring
	xor	eax,eax
	mov	ax,word ptr  @63stDCBposition
	push	eax
	mov	edx,offset FLAT:szLoadFormat
	mov	eax,offset FLAT:szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,010h

; 850             WinSetDlgItemText(hwndDlg,PCFG_LOADT,szListString);
	push	offset FLAT:szListString
	push	012ceh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 851             sprintf(szListString,szDeviceDefFormat,stDCBposition.wLoadNumber);
	xor	eax,eax
	mov	ax,word ptr  @63stDCBposition
	push	eax
	mov	edx,offset FLAT:szDeviceDefFormat
	mov	eax,offset FLAT:szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 852             WinSetDlgItemText(hwndDlg,PCFG_DEVT0,szListString);
	push	offset FLAT:szListString
	push	012d7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 853             if (stDCBposition.wLoadNumber == 1)
	cmp	word ptr  @63stDCBposition,01h
	jne	@BLBL132

; 854               ControlEnable(hwndDlg,PCFG_DELETE_LOAD,FALSE);
	push	0h
	push	01209h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
	jmp	@BLBL133
	align 010h
@BLBL132:

; 856               ControlEnable(hwndDlg,PCFG_DELETE_LOAD,TRUE);
	push	01h
	push	01209h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
@BLBL133:

; 857             if (iDeviceCount < 1)
	cmp	dword ptr  iDeviceCount,01h
	jge	@BLBL134

; 858               ControlEnable(hwndDlg,PCFG_ADD_LOAD,FALSE);
	push	0h
	push	0120ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
	jmp	@BLBL135
	align 010h
@BLBL134:

; 860               ControlEnable(hwndDlg,PCFG_ADD_LOAD,TRUE);
	push	01h
	push	0120ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
@BLBL135:

; 861             if (iDeviceCount < iLoadMaxDevice)
	mov	eax,dword ptr  iLoadMaxDevice
	cmp	dword ptr  iDeviceCount,eax
	jge	@BLBL136

; 862               ControlEnable(hwndDlg,DID_INSERT,TRUE);
	push	01h
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
	jmp	@BLBL137
	align 010h
@BLBL136:

; 864               ControlEnable(hwndDlg,DID_INSERT,FALSE);
	push	0h
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
@BLBL137:

; 865             ControlEnable(hwndDlg,DID_INSTALL,FALSE);
	push	0h
	push	012eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 866             ControlEnable(hwndDlg,DID_DELETE,FALSE);
	push	0h
	push	012fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 867             }
@BLBL124:

; 868           break;
	jmp	@BLBL161
	align 04h
@BLBL165:

; 870           switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL167
	align 04h
@BLBL168:

; 873               if (Checked(hwndDlg,PCFG_KEY_WAIT))
	push	011fch
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL138

; 875                 ControlEnable(hwndDlg,PCFG_DELAY,TRUE);
	push	01h
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 876                 ControlEnable(hwndDlg,PCFG_DELAYT,TRUE);
	push	01h
	push	011fdh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 877                 }
	jmp	@BLBL139
	align 010h
@BLBL138:

; 880                 ControlEnable(hwndDlg,PCFG_DELAY,FALSE);
	push	0h
	push	012f7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 881                 ControlEnable(hwndDlg,PCFG_DELAYT,FALSE);
	push	0h
	push	011fdh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 882                 }
@BLBL139:
@BLBL169:

; 884               ControlEnable(hwndDlg,DID_INSTALL,TRUE);
	push	01h
	push	012eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 885               ControlEnable(hwndDlg,DID_DELETE,TRUE);
	push	01h
	push	012fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 886               break;
	jmp	@BLBL166
	align 04h
	jmp	@BLBL166
	align 04h
@BLBL167:
	cmp	eax,011fch
	je	@BLBL168
	cmp	eax,012d6h
	je	@BLBL169
@BLBL166:

; 888           break;
	jmp	@BLBL161
	align 04h
@BLBL170:

; 890           if (SHORT1FROMMP(mp1) == PCFG_DEV_LIST)
	mov	ax,[ebp+010h];	mp1
	cmp	ax,012d6h
	jne	@BLBL140

; 892             ControlEnable(hwndDlg,DID_INSTALL,TRUE);
	push	01h
	push	012eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 893             ControlEnable(hwndDlg,DID_DELETE,TRUE);
	push	01h
	push	012fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 894             if (iItemSelected == LIT_NONE)
	cmp	dword ptr  @6aiItemSelected,0ffffffffh
	jne	@BLBL141

; 895               WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_SELECTITEM,(MPARAM)0,(MPARAM)TRUE);
	push	01h
	push	0h
	push	0164h
	push	012d6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h
	jmp	@BLBL140
	align 010h
@BLBL141:

; 897               WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_SELECTITEM,(MPARAM)iItemSelected,(MPARAM)TRUE);
	push	01h
	mov	eax,dword ptr  @6aiItemSelected
	push	eax
	push	0164h
	push	012d6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 898             }
@BLBL140:

; 899           break;
	jmp	@BLBL161
	align 04h
@BLBL171:

; 901           WinPostMsg(hwndDlg,WM_COMMAND,MPFROMSHORT(DID_INSTALL),(MPARAM)0);
	push	0h
	push	012eh
	push	020h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinPostMsg
	add	esp,010h

; 902           break;
	jmp	@BLBL161
	align 04h
	jmp	@BLBL161
	align 04h
@BLBL162:
	cmp	eax,03h
	je	@BLBL163
	cmp	eax,020dh
	je	@BLBL164
	cmp	eax,01h
	je	@BLBL165
	cmp	eax,02h
	je	@BLBL170
	cmp	eax,05h
	je	@BLBL171
@BLBL161:

; 904       return((MRESULT)TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL143
	align 04h
@BLBL144:
	cmp	eax,03bh
	je	@BLBL145
	cmp	eax,020h
	je	@BLBL146
	cmp	eax,030h
	je	@BLBL160
@BLBL143:

; 906   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
fnwpPortConfigDlgProc	endp

; 910   {
	align 010h

	public FillDeviceCfgListBox
FillDeviceCfgListBox	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0190h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,064h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 922   int iItemIndex = 0;
	mov	dword ptr [ebp-0c8h],0h;	iItemIndex

; 923   char szListString[80];
; 924   char szPCIname[100];
; 925   DCBPOS stDCBposition;
; 926   char szString[9];
; 927   BYTE byIntLevel;
; 928   WORD wAddress;
; 929   BOOL bPCIadapter = FALSE;
	mov	dword ptr [ebp-0190h],0h;	bPCIadapter

; 930 
; 931   if ((pLoadInterruptList = InitializeList()) == NULL)
	call	InitializeList
	mov	dword ptr  pLoadInterruptList,eax
	cmp	dword ptr  pLoadInterruptList,0h
	jne	@BLBL172

; 932     return(0);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL172:

; 933   if ((pLoadAddressList = InitializeList()) == NULL)
	call	InitializeList
	mov	dword ptr  pLoadAddressList,eax
	cmp	dword ptr  pLoadAddressList,0h
	jne	@BLBL173

; 934     return(0);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL173:

; 935   while (DosOpen(szDriverIniSpec,&hFile,&ulStatus,0L,0,1,0x1312,(PEAOP2)0L) != 0)
	push	0h
	push	01312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-08h];	ulStatus
	push	eax
	lea	eax,[ebp-0ch];	hFile
	push	eax
	push	dword ptr [ebp+010h];	szDriverIniSpec
	call	DosOpen
	add	esp,020h
	test	eax,eax
	je	@BLBL174
	align 010h
@BLBL175:

; 936     if (AddIniConfigHeader(szDriverIniSpec,&stDCBposition) == 0)
	lea	eax,[ebp-0180h];	stDCBposition
	push	eax
	push	dword ptr [ebp+010h];	szDriverIniSpec
	call	AddIniConfigHeader
	add	esp,08h
	test	eax,eax
	jne	@BLBL176

; 937       return(0);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL176:

; 935   while (DosOpen(szDriverIniSpec,&hFile,&ulStatus,0L,0,1,0x1312,(PEAOP2)0L) != 0)
	push	0h
	push	01312h
	push	01h
	push	0h
	push	0h
	lea	eax,[ebp-08h];	ulStatus
	push	eax
	lea	eax,[ebp-0ch];	hFile
	push	eax
	push	dword ptr [ebp+010h];	szDriverIniSpec
	call	DosOpen
	add	esp,020h
	test	eax,eax
	jne	@BLBL175
@BLBL174:

; 938   if (DosRead(hFile,(PVOID)&stConfigInfo,sizeof(CFGINFO),&ulCount) == 0)
	lea	eax,[ebp-01ch];	ulCount
	push	eax
	push	02ch
	lea	eax,[ebp-048h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL178

; 940     WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_DELETEALL,0L,0L);
	push	0h
	push	0h
	push	016eh
	push	012d6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 941     if (stConfigInfo.wCFGheaderCount >= stSelectPosition.wLoadNumber)
	mov	ax,[ebp+0ch];	stSelectPosition
	cmp	[ebp-042h],ax;	stConfigInfo
	jb	@BLBL178

; 943       DosChgFilePtr(hFile,stConfigInfo.oFirstCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0c4h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-040h];	stConfigInfo
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 944       for (iIndex = 1;iIndex <= stSelectPosition.wLoadNumber;iIndex++)
	mov	dword ptr [ebp-010h],01h;	iIndex
	xor	eax,eax
	mov	ax,[ebp+0ch];	stSelectPosition
	cmp	[ebp-010h],eax;	iIndex
	jg	@BLBL180
	align 010h
@BLBL181:

; 946         if (DosRead(hFile,(PVOID)&stConfigHeader,sizeof(CFGHEAD),&ulCount) != 0)
	lea	eax,[ebp-01ch];	ulCount
	push	eax
	push	03eh
	lea	eax,[ebp-086h];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	je	@BLBL182

; 947            return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL182:

; 948         DosChgFilePtr(hFile,stConfigHeader.oNextCFGheader,0,&ulFilePosition);
	lea	eax,[ebp-0c4h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-06ch];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 949         }

; 944       for (iIndex = 1;iIndex <= stSelectPosition.wLoadNumber;iIndex++)
	mov	eax,[ebp-010h];	iIndex
	inc	eax
	mov	[ebp-010h],eax;	iIndex
	xor	eax,eax
	mov	ax,[ebp+0ch];	stSelectPosition
	cmp	[ebp-010h],eax;	iIndex
	jle	@BLBL181
@BLBL180:

; 950       if (stConfigHeader.bHeaderIsInitialized)
	cmp	word ptr [ebp-06eh],0h;	stConfigHeader
	je	@BLBL178

; 952         if (stConfigHeader.byInterruptLevel != 0)
	cmp	byte ptr [ebp-07bh],0h;	stConfigHeader
	je	@BLBL185

; 954           byIntLevel =  stConfigHeader.byInterruptLevel;
	mov	al,[ebp-07bh];	stConfigHeader
	mov	[ebp-018ah],al;	byIntLevel

; 955           AddListItem(pLoadInterruptList,&byIntLevel,1);
	push	01h
	lea	eax,[ebp-018ah];	byIntLevel
	push	eax
	push	dword ptr  pLoadInterruptList
	call	AddListItem
	add	esp,0ch

; 956           }
@BLBL185:

; 957         DosChgFilePtr(hFile,stConfigHeader.oFirstDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0c4h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-06ah];	stConfigHeader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 959         if (stConfigHeader.byAdapterType == HDWTYPE_PCI)
	cmp	byte ptr [ebp-07ch],09h;	stConfigHeader
	jne	@BLBL186

; 961           bPCIadapter = TRUE;
	mov	dword ptr [ebp-0190h],01h;	bPCIadapter

; 962           if ((iMaxCount = GetPCIadapterName(NULL, 0)) != 0)
	push	0h
	push	0h
	call	GetPCIadapterName
	add	esp,08h
	mov	[ebp-014h],eax;	iMaxCount
	cmp	dword ptr [ebp-014h],0h;	iMaxCount
	je	@BLBL188

; 963             iOEMloadMaxDevice = iMaxCount;
	mov	eax,[ebp-014h];	iMaxCount
	mov	dword ptr  iOEMloadMaxDevice,eax

; 964           }
	jmp	@BLBL188
	align 010h
@BLBL186:

; 966           if (ulMaxDeviceCount == 0)
	cmp	dword ptr [ebp+014h],0h;	ulMaxDeviceCount
	jne	@BLBL188

; 967             if (stConfigHeader.wDCBcount == 0)
	cmp	word ptr [ebp-084h],0h;	stConfigHeader
	jne	@BLBL190

; 968               iLoadMaxDevice = iOEMloadMaxDevice;
	mov	eax,dword ptr  iOEMloadMaxDevice
	mov	dword ptr  iLoadMaxDevice,eax
	jmp	@BLBL188
	align 010h
@BLBL190:

; 970               iLoadMaxDevice = stConfigHeader.wDCBcount;
	xor	eax,eax
	mov	ax,[ebp-084h];	stConfigHeader
	mov	dword ptr  iLoadMaxDevice,eax
@BLBL188:

; 971         for (iDCBindex = 1;iDCBindex <= stConfigHeader.wDCBcount;iDCBindex++)
	mov	dword ptr [ebp-018h],01h;	iDCBindex
	xor	eax,eax
	mov	ax,[ebp-084h];	stConfigHeader
	cmp	[ebp-018h],eax;	iDCBindex
	jg	@BLBL178
	align 010h
@BLBL193:

; 973           if (DosRead(hFile,(PVOID)&stDCBheader,sizeof(DCBHEAD),&ulCount) == 0)
	lea	eax,[ebp-01ch];	ulCount
	push	eax
	push	03ah
	lea	eax,[ebp-0c0h];	stDCBheader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosRead
	add	esp,010h
	test	eax,eax
	jne	@BLBL194

; 975             if (stDCBheader.bHeaderIsInitialized)
	cmp	word ptr [ebp-0b8h],0h;	stDCBheader
	je	@BLBL194

; 977               strncpy(szString,stDCBheader.abyPortName,8);
	mov	ecx,08h
	lea	edx,[ebp-0c0h];	stDCBheader
	lea	eax,[ebp-0189h];	szString
	call	strncpy

; 978               RemoveSpaces(szString);
	lea	eax,[ebp-0189h];	szString
	push	eax
	call	RemoveSpaces
	add	esp,04h

; 979               if (!bPCIadapter)
	cmp	dword ptr [ebp-0190h],0h;	bPCIadapter
	jne	@BLBL196

; 981                 if(stConfigHeader.byInterruptLevel == 0)
	cmp	byte ptr [ebp-07bh],0h;	stConfigHeader
	jne	@BLBL197

; 983                     byIntLevel = stDCBheader.stComDCB.byInterruptLevel;
	mov	al,[ebp-090h];	stDCBheader
	mov	[ebp-018ah],al;	byIntLevel

; 984                   if (stDCBheader.stComDCB.wConfigFlags1 & CFG_FLAG1_MULTI_INT)
	test	byte ptr [ebp-0afh],040h;	stDCBheader
	je	@BLBL198

; 986                     if (FindListByteItem(pLoadInterruptList,(byIntLevel | '\x80')) == NULL)
	mov	al,[ebp-018ah];	byIntLevel
	or	al,080h
	push	eax
	push	dword ptr  pLoadInterruptList
	call	FindListByteItem
	add	esp,08h
	test	eax,eax
	jne	@BLBL197

; 987                       AddListItem(pLoadInterruptList,&byIntLevel,1);
	push	01h
	lea	eax,[ebp-018ah];	byIntLevel
	push	eax
	push	dword ptr  pLoadInterruptList
	call	AddListItem
	add	esp,0ch

; 988                     }
	jmp	@BLBL197
	align 010h
@BLBL198:

; 990                     AddListItem(pLoadInterruptList,&byIntLevel,1);
	push	01h
	lea	eax,[ebp-018ah];	byIntLevel
	push	eax
	push	dword ptr  pLoadInterruptList
	call	AddListItem
	add	esp,0ch

; 991                   }
@BLBL197:

; 992                 if (stDCBheader.stComDCB.wIObaseAddress == 0xffff)
	cmp	word ptr [ebp-0aah],0ffffh;	stDCBheader
	jne	@BLBL201

; 994                   szString[0] = 'C';
	mov	byte ptr [ebp-0189h],043h;	szString

; 995                   iLen = sprintf(szListString,szSkipFormat,szString);
	lea	eax,[ebp-0189h];	szString
	push	eax
	mov	edx,offset FLAT:szSkipFormat
	lea	eax,[ebp-0118h];	szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	mov	[ebp-04h],eax;	iLen

; 996                   }
	jmp	@BLBL202
	align 010h
@BLBL201:

; 999                   wAddress =  stDCBheader.stComDCB.wIObaseAddress;
	mov	ax,[ebp-0aah];	stDCBheader
	mov	[ebp-018ch],ax;	wAddress

; 1000                   AddLis
; 1000 tItem(pLoadAddressList,&wAddress,2);
	push	02h
	lea	eax,[ebp-018ch];	wAddress
	push	eax
	push	dword ptr  pLoadAddressList
	call	AddListItem
	add	esp,0ch

; 1001                   iLen = sprintf(szListString,szListFormat,szString,stDCBheader.stComDCB.wIObaseAddress,byIntLevel);
	xor	eax,eax
	mov	al,[ebp-018ah];	byIntLevel
	push	eax
	xor	eax,eax
	mov	ax,[ebp-0aah];	stDCBheader
	push	eax
	lea	eax,[ebp-0189h];	szString
	push	eax
	mov	edx,offset FLAT:szListFormat
	lea	eax,[ebp-0118h];	szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,014h
	mov	[ebp-04h],eax;	iLen

; 1002                   }
@BLBL202:

; 1003                 if (stDCBheader.stComDCB.wIObaseAddress != 0xffff)
	cmp	word ptr [ebp-0aah],0ffffh;	stDCBheader
	je	@BLBL204

; 1004                   AppendOptionList(&stDCBheader,&szListString[iLen]);
	mov	eax,[ebp-04h];	iLen
	lea	eax,dword ptr [ebp+eax-0118h]
	push	eax
	lea	eax,[ebp-0c0h];	stDCBheader
	push	eax
	call	AppendOptionList
	add	esp,08h

; 1005                 }
	jmp	@BLBL204
	align 010h
@BLBL196:

; 1008                 wAddress =  stDCBheader.stComDCB.wIObaseAddress;
	mov	ax,[ebp-0aah];	stDCBheader
	mov	[ebp-018ch],ax;	wAddress

; 1009                 byIntLevel = stDCBheader.stComDCB.byInterruptLevel;
	mov	al,[ebp-090h];	stDCBheader
	mov	[ebp-018ah],al;	byIntLevel

; 1010                 iLen = sprintf(szListString,szPCIdevice,szString);
	lea	eax,[ebp-0189h];	szString
	push	eax
	mov	edx,offset FLAT:szPCIdevice
	lea	eax,[ebp-0118h];	szListString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	mov	[ebp-04h],eax;	iLen

; 1011                 }
@BLBL204:

; 1012               WinSendDlgItemMsg(hwndDlg,PCFG_DEV_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(szListString));
	lea	eax,[ebp-0118h];	szListString
	push	eax
	push	0ffffh
	push	0161h
	push	012d6h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 1013               iItemIndex++;
	mov	eax,[ebp-0c8h];	iItemIndex
	inc	eax
	mov	[ebp-0c8h],eax;	iItemIndex

; 1014               }

; 1015             }
@BLBL194:

; 1016           DosChgFilePtr(hFile,stDCBheader.oNextDCBheader,0,&ulFilePosition);
	lea	eax,[ebp-0c4h];	ulFilePosition
	push	eax
	push	0h
	xor	eax,eax
	mov	ax,[ebp-0b6h];	stDCBheader
	push	eax
	push	dword ptr [ebp-0ch];	hFile
	call	DosSetFilePtr
	add	esp,010h

; 1017           }

; 971         for (iDCBindex = 1;iDCBindex <= stConfigHeader.wDCBcount;iDCBindex++)
	mov	eax,[ebp-018h];	iDCBindex
	inc	eax
	mov	[ebp-018h],eax;	iDCBindex
	xor	eax,eax
	mov	ax,[ebp-084h];	stConfigHeader
	cmp	[ebp-018h],eax;	iDCBindex
	jle	@BLBL193

; 1018         }

; 1019       }

; 1020     }
@BLBL178:

; 1021   sprintf(szListString,"  ");
	mov	edx,offset FLAT:@STAT2b
	lea	eax,[ebp-0118h];	szListString
	call	_sprintfieee

; 1022   DosClose(hFile);
	push	dword ptr [ebp-0ch];	hFile
	call	DosClose
	add	esp,04h

; 1023   return(iItemIndex);
	mov	eax,[ebp-0c8h];	iItemIndex
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
FillDeviceCfgListBox	endp

; 1027   {
	align 010h

	public fnwpPortOEMconfigDlgProc
fnwpPortOEMconfigDlgProc	proc
	push	ebp
	mov	ebp,esp
	sub	esp,013ch
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,04fh
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 1044   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL288
	align 04h
@BLBL289:

; 1045     {
; 1046     case WM_INITDLG:
; 1047       CenterDlgBox(hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	call	CenterDlgBox
	add	esp,04h

; 1048       WinSetFocus(HWND_DESKTOP,hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinSetFocus
	add	esp,08h

; 1049       pstCOMiCFG = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @111pstCOMiCFG,eax

; 1050       byOEMtype = pstCOMiCFG->byOEMtype;
	mov	eax,dword ptr  @111pstCOMiCFG
	mov	al,[eax+024h]
	mov	[ebp-01h],al;	byOEMtype

; 1051       wIntAlgorithim = stGlobalCFGheader.wIntAlgorithim;
	mov	ax,word ptr  stGlobalCFGheader+010h
	mov	word ptr  @10ewIntAlgorithim,ax

; 1052       wAddress = stGlobalCFGheader.wIntIDregister;
	mov	ax,word ptr  stGlobalCFGheader+014h
	mov	[ebp-0130h],ax;	wAddress

; 1053       byAdapterType = stGlobalCFGheader.byAdapterType;
	mov	al,byte ptr  stGlobalCFGheader+0ah
	mov	[ebp-02h],al;	byAdapterType

; 1054 //      byOEMtype = stGlobalCFGinfo.byOEMtype;
; 1055       byIntLevel = stGlobalCFGheader.byInterruptLevel;
	mov	al,byte ptr  stGlobalCFGheader+0bh
	mov	byte ptr  @113byIntLevel,al

; 1056       wLoadFlags = stGlobalCFGheader.wLoadFlags;
	mov	ax,word ptr  stGlobalCFGheader+012h
	mov	word ptr  @109wLoadFlags,ax

; 1057       // test if COMi is OEM build
; 1058       if (byOEMtype != 0)
	cmp	byte ptr [ebp-01h],0h;	byOEMtype
	je	@BLBL206

; 1059         {
; 1060         switch (byOEMtype)
	xor	eax,eax
	mov	al,[ebp-01h];	byOEMtype
	jmp	@BLBL291
	align 04h
@BLBL292:
@BLBL293:

; 1061           {
; 1062           case OEM_DIGIBOARD08:
; 1063           case OEM_DIGIBOARD16:
; 1064 //            if (byOEMtype != OEM_OTHER)
; 1065 //              byOEMtype = byOEMtype;
; 1066 //            else
; 1067               byAdapterType = HDWTYPE_FOUR;
	mov	byte ptr [ebp-02h],04h;	byAdapterType

; 1068             break;
	jmp	@BLBL290
	align 04h
@BLBL294:

; 1069           case OEM_COMTROL:
; 1070             byAdapterType = HDWTYPE_TWO;
	mov	byte ptr [ebp-02h],02h;	byAdapterType

; 1071             break;
	jmp	@BLBL290
	align 04h
@BLBL295:

; 1072           case OEM_MOXA:
; 1073             byAdapterType = HDWTYPE_PCI;
	mov	byte ptr [ebp-02h],09h;	byAdapterType

; 1074             break;
	jmp	@BLBL290
	align 04h
@BLBL296:

; 1075           case OEM_QUATECH:
; 1076             if (!bLimitLoad)
	cmp	dword ptr  bLimitLoad,0h
	jne	@BLBL207

; 1077               byAdapterType = HDWTYPE_ONE;
	mov	byte ptr [ebp-02h],01h;	byAdapterType
@BLBL207:

; 1078             break;
	jmp	@BLBL290
	align 04h
@BLBL297:

; 1079           case OEM_GLOBETEK:
; 1080             if (byAdapterType != HDWTYPE_PCI)
	cmp	byte ptr [ebp-02h],09h;	byAdapterType
	je	@BLBL208

; 1081               if (!bLimitLoad)
	cmp	dword ptr  bLimitLoad,0h
	jne	@BLBL208

; 1082                 byAdapterType = HDWTYPE_ONE;
	mov	byte ptr [ebp-02h],01h;	byAdapterType
@BLBL208:

; 1083             break;
	jmp	@BLBL290
	align 04h
@BLBL298:

; 1084           case OEM_CONNECTECH:
; 1085             if (byAdapterType != HDWTYPE_PCI)
	cmp	byte ptr [ebp-02h],09h;	byAdapterType
	je	@BLBL210

; 1086               if (!bLimitLoad)
	cmp	dword ptr  bLimitLoad,0h
	jne	@BLBL210

; 1087                 byAdapterType = HDWTYPE_THREE;
	mov	byte ptr [ebp-02h],03h;	byAdapterType
@BLBL210:

; 1088             break;
	jmp	@BLBL290
	align 04h
@BLBL299:

; 1089           case OEM_BOCA:
; 1090             byAdapterType = HDWTYPE_SIX;
	mov	byte ptr [ebp-02h],06h;	byAdapterType

; 1091             break;
	jmp	@BLBL290
	align 04h
@BLBL300:

; 1092           case OEM_SEALEVEL_RET:
; 1093             byAdapterType = HDWTYPE_SEVEN;
	mov	byte ptr [ebp-02h],07h;	byAdapterType

; 1094             break;
	jmp	@BLBL290
	align 04h
@BLBL301:

; 1095           case OEM_SEALEVEL:
; 1096             if (byAdapterType != HDWTYPE_PCI)
	cmp	byte ptr [ebp-02h],09h;	byAdapterType
	je	@BLBL212

; 1097               if (!bLimitLoad)
	cmp	dword ptr  bLimitLoad,0h
	jne	@BLBL212

; 1098                 byAdapterType = HDWTYPE_ONE;
	mov	byte ptr [ebp-02h],01h;	byAdapterType
@BLBL212:

; 1099           }
	jmp	@BLBL290
	align 04h
@BLBL291:
	cmp	eax,03h
	je	@BLBL292
	cmp	eax,05h
	je	@BLBL293
	cmp	eax,02h
	je	@BLBL294
	cmp	eax,0bh
	je	@BLBL295
	cmp	eax,04h
	je	@BLBL296
	cmp	eax,08h
	je	@BLBL297
	cmp	eax,07h
	je	@BLBL298
	cmp	eax,09h
	je	@BLBL299
	cmp	eax,0ah
	je	@BLBL300
	cmp	eax,01h
	je	@BLBL301
@BLBL290:

; 1100         if (stConfigDeviceCount.wLoadNumber == 1)
	cmp	word ptr  stConfigDeviceCount,01h
	jne	@BLBL214

; 1101           {
; 1102           ControlEnable(hwndDlg,PCFG_OEM_ONE,FALSE);
	push	0h
	push	0122bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1103           ControlEnable(hwndDlg,PCFG_OEM_TWO,FALSE);
	push	0h
	push	0122ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1104           ControlEnable(hwndDlg,PCFG_OEM_THREE,FALSE);
	push	0h
	push	0122dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1105           ControlEnable(hwndDlg,PCFG_OEM_FOUR,FALSE);
	push	0h
	push	0122eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1106           ControlEnable(hwndDlg,PCFG_OEM_FIVE,FALSE);
	push	0h
	push	0122fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1107           ControlEnable(hwndDlg,PCFG_OEM_SIX,FALSE);
	push	0h
	push	01230h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1108           ControlEnable(hwndDlg,PCFG_OEM_SEVEN,FALSE);
	push	0h
	push	01231h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1109 //          ControlEnable(hwndDlg,RB_TYPEPCI,FALSE);
; 1110           ControlEnable(hwndDlg,PCFG_OEM_OTHER,FALSE);
	push	0h
	push	0122ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1111           if (byAdapterType == HDWTYPE_DIGIBOARD)
	cmp	byte ptr [ebp-02h],064h;	byAdapterType
	jne	@BLBL215

; 1112             {
; 1113             ControlEnable(hwndDlg,PCFG_OEM_FOUR,TRUE);
	push	01h
	push	0122eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1114             ControlEnable(hwndDlg,PCFG_OEM_FIVE,TRUE);
	push	01h
	push	0122fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1115             }
	jmp	@BLBL214
	align 010h
@BLBL215:

; 1116           else
; 1117             {
; 1118             if (byAdapterType == HDWTYPE_CONNECTECH )
	cmp	byte ptr [ebp-02h],063h;	byAdapterType
	jne	@BLBL217

; 1119               {
; 1120               ControlEnable(hwndDlg,RB_TYPEPCI,TRUE);
	push	01h
	push	01232h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1121               ControlEnable(hwndDlg,PCFG_OEM_TWO,TRUE);
	push	01h
	push	0122ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1122               }
	jmp	@BLBL214
	align 010h
@BLBL217:

; 1123             else
; 1124               {
; 1125               switch (byOEMtype)
	xor	eax,eax
	mov	al,[ebp-01h];	byOEMtype
	jmp	@BLBL303
	align 04h
@BLBL304:

; 1126                 {
; 1127                 case OEM_SEALEVEL:
; 1128                   ControlEnable(hwndDlg,RB_TYPEPCI,TRUE);
	push	01h
	push	01232h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1129                   ControlEnable(hwndDlg,PCFG_OEM_OTHER,TRUE);
	push	01h
	push	0122ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1130                   ControlEnable(hwndDlg,PCFG_OEM_ONE,TRUE);
	push	01h
	push	0122bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1131                   break;
	jmp	@BLBL302
	align 04h
@BLBL305:

; 1132                 case OEM_GLOBETEK:
; 1133                   ControlEnable(hwndDlg,RB_TYPEPCI,TRUE);
	push	01h
	push	01232h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1134                   ControlEnable(hwndDlg,PCFG_OEM_ONE,TRUE);
	push	01h
	push	0122bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1135                   break;
	jmp	@BLBL302
	align 04h
@BLBL306:

; 1136                 case OEM_CONNECTECH:
; 1137                   ControlEnable(hwndDlg,RB_TYPEPCI,TRUE);
	push	01h
	push	01232h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1138                   ControlEnable(hwndDlg,PCFG_OEM_TWO,TRUE);
	push	01h
	push	0122ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1139                   break;
	jmp	@BLBL302
	align 04h
@BLBL307:

; 1140                 case OEM_MOXA:
; 1141                   ControlEnable(hwndDlg,RB_TYPEPCI,TRUE);
	push	01h
	push	01232h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1142                   break;
	jmp	@BLBL302
	align 04h
	jmp	@BLBL302
	align 04h
@BLBL303:
	cmp	eax,01h
	je	@BLBL304
	cmp	eax,08h
	je	@BLBL305
	cmp	eax,07h
	je	@BLBL306
	cmp	eax,0bh
	je	@BLBL307
@BLBL302:

; 1143                 deault:
; 1144                   ControlEnable(hwndDlg,(PCFG_OEM_OTHER + byAdapterType),TRUE);
; 1145                   ControlEnable(hwndDlg,PCFG_OEM_OTHER,TRUE);
; 1146                   break;
; 1147                 }
; 1148               }

; 1149             }

; 1150           }
@BLBL214:

; 1151         if ((byOEMtype == OEM_DIGIBOARD08) || (byOEMtype == OEM_DIGIBOARD16))
	cmp	byte ptr [ebp-01h],03h;	byOEMtype
	je	@BLBL220
	cmp	byte ptr [ebp-01h],05h;	byOEMtype
	jne	@BLBL221
@BLBL220:

; 1152           {
; 1153           WinLoadString(pstCOMiCFG->hab,hThisModule,(LONG)ATM_OEM_DIGIBOARD08,39,(PSZ)szOEMname);
	push	offset FLAT:szOEMname
	push	027h
	push	0f06h
	mov	eax,dword ptr  hThisModule
	push	eax
	mov	eax,dword ptr  @111pstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinLoadString
	add	esp,014h

; 1154           WinSetDlgItemText(hwndDlg,PCFG_OEM_FOUR,szOEMname);
	push	offset FLAT:szOEMname
	push	0122eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1155           WinLoadString(pstCOMiCFG->hab,hThisModule,(LONG)ATM_OEM_DIGIBOARD16,39,(PSZ)szOEMname);
	push	offset FLAT:szOEMname
	push	027h
	push	0f07h
	mov	eax,dword ptr  hThisModule
	push	eax
	mov	eax,dword ptr  @111pstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinLoadString
	add	esp,014h

; 1156           WinSetDlgItemText(hwndDlg,PCFG_OEM_FIVE,szOEMname);
	push	offset FLAT:szOEMname
	push	0122fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1157           }
	jmp	@BLBL206
	align 010h
@BLBL221:

; 1158         else
; 1159           {
; 1160           if (byOEMtype == OEM_CONNECTECH)
	cmp	byte ptr [ebp-01h],07h;	byOEMtype
	jne	@BLBL223

; 1161             {
; 1162             WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_CONNECTECH_PCI,39,(PSZ)szOEMname);
	push	offset FLAT:szOEMname
	push	027h
	push	0f0ch
	mov	eax,dword ptr  hThisModule
	push	eax
	mov	eax,dword ptr  @111pstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinLoadString
	add	esp,014h

; 1163             WinSetDlgItemText(hwndDlg,RB_TYPEPCI,szOEMname);
	push	offset FLAT:szOEMname
	push	01232h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1164             WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_CONNECTECH_SP,39,(PSZ)szOEMname);
	push	offset FLAT:szOEMname
	push	027h
	push	0f0ah
	mov	eax,dword ptr  hThisModule
	push	eax
	mov	eax,dword ptr  @111pstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinLoadString
	add	esp,014h

; 1165             WinSetDlgItemText(hwndDlg,PCFG_OEM_TWO,szOEMname);
	push	offset FLAT:szOEMname
	push	0122ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1166             }
	jmp	@BLBL206
	align 010h
@BLBL223:

; 1167           else
; 1168           if (byOEMtype == OEM_MOXA)
	cmp	byte ptr [ebp-01h],0bh;	byOEMtype
	jne	@BLBL225

; 1169             {
; 1170             WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_MOXA_PCI,39,(PSZ)szOEMname);
	push	offset FLAT:szOEMname
	push	027h
	push	0f12h
	mov	eax,dword ptr  hThisModule
	push	eax
	mov	eax,dword ptr  @111pstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinLoadString
	add	esp,014h

; 1171             WinSetDlgItemText(hwndDlg,RB_TYPEPCI,szOEMname);
	push	offset FLAT:szOEMname
	push	01232h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1172 //            WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_MOXA,39,(PSZ)szOEMname);
; 1173 //            WinSetDlgItemText(hwndDlg,PCFG_OEM_ONE,szOEMname);
; 1174             }
	jmp	@BLBL206
	align 010h
@BLBL225:

; 1175           else
; 1176           if (byOEMtype == OEM_GLOBETEK)
	cmp	byte ptr [ebp-01h],08h;	byOEMtype
	jne	@BLBL227

; 1177             {
; 1178             WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_GLOBETEK_PCI,39,(PSZ)szOEMname);
	push	offset FLAT:szOEMname
	push	027h
	push	0f10h
	mov	eax,dword ptr  hThisModule
	push	eax
	mov	eax,dword ptr  @111pstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinLoadString
	add	esp,014h

; 1179             WinSetDlgItemText(hwndDlg,RB_TYPEPCI,szOEMname);
	push	offset FLAT:szOEMname
	push	01232h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1180             WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_GLOBETEK_SP,39,(PSZ)szOEMname);
	push	offset FLAT:szOEMname
	push	027h
	push	0f0eh
	mov	eax,dword ptr  hThisModule
	push	eax
	mov	eax,dword ptr  @111pstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinLoadString
	add	esp,014h

; 1181             WinSetDlgItemText(hwndDlg,PCFG_OEM_ONE,szOEMname);
	push	offset FLAT:szOEMname
	push	0122bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1182             }
	jmp	@BLBL206
	align 010h
@BLBL227:

; 1183           else
; 1184             {
; 1185             if (bLimitLoad || (byOEMtype == OEM_SEALEVEL))
	cmp	dword ptr  bLimitLoad,0h
	jne	@BLBL229
	cmp	byte ptr [ebp-01h],01h;	byOEMtype
	jne	@BLBL230
@BLBL229:

; 1186               {

; 1187 //              if (byAdapterType == HDWTYPE_PCI)
; 1188                 {
; 1189                 WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_SEALEVEL_PCI,39,(PSZ)szOEMname);
	push	offset FLAT:szOEMname
	push	027h
	push	0f03h
	mov	eax,dword ptr  hThisModule
	push	eax
	mov	eax,dword ptr  @111pstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinLoadString
	add	esp,014h

; 1190                 WinSetDlgItemText(hwndDlg,RB_TYPEPCI,szOEMname);
	push	offset FLAT:szOEMname
	push	01232h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1191                 }

; 1192               WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_SEALEVEL_OTHER,39,(PSZ)szOEMname);
	push	offset FLAT:szOEMname
	push	027h
	push	0f00h
	mov	eax,dword ptr  hThisModule
	push	eax
	mov	eax,dword ptr  @111pstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinLoadString
	add	esp,014h

; 1193               WinSetDlgItemText(hwndDlg,PCFG_OEM_OTHER,szOEMname);
	push	offset FLAT:szOEMname
	push	0122ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1194               WinLoadString(pstCOMiCFG->hab,hThisModule,ATM_OEM_SEALEVEL_SP,39,(PSZ)szOEMname);
	push	offset FLAT:szOEMname
	push	027h
	push	0f01h
	mov	eax,dword ptr  hThisModule
	push	eax
	mov	eax,dword ptr  @111pstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinLoadString
	add	esp,014h

; 1195               WinSetDlgItemText(hwndDlg,PCFG_OEM_ONE,szOEMname);
	push	offset FLAT:szOEMname
	push	0122bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1196               }
	jmp	@BLBL206
	align 010h
@BLBL230:

; 1197             else
; 1198               {
; 1199               WinLoadString(pstCOMiCFG->hab,hThisModule,(LONG)(ATM_OEM_SEALEVEL + (byDDOEMtype - 1)),39,(PSZ)szOEMname);
	push	offset FLAT:szOEMname
	push	027h
	xor	eax,eax
	mov	al,byte ptr  byDDOEMtype
	add	eax,0f01h
	push	eax
	mov	eax,dword ptr  hThisModule
	push	eax
	mov	eax,dword ptr  @111pstCOMiCFG
	push	dword ptr [eax+02h]
	call	WinLoadString
	add	esp,014h

; 1200               WinSetDlgItemText(hwndDlg,(PCFG_OEM_OTHER + byAdapterType),szOEMname);
	push	offset FLAT:szOEMname
	xor	eax,eax
	mov	al,[ebp-02h];	byAdapterType
	add	eax,0122ah
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1201               }

; 1202             }

; 1203           }

; 1204         }
@BLBL206:

; 1205       if ((byAdapterType == HDWTYPE_PCI) || (byOEMtype == OEM_OTHER))
	cmp	byte ptr [ebp-02h],09h;	byAdapterType
	je	@BLBL232
	cmp	byte ptr [ebp-01h],0h;	byOEMtype
	jne	@BLBL233
@BLBL232:

; 1206         {
; 1207         ControlEnable(hwndDlg,PCFG_BASE_ADDR,FALSE);
	push	0h
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1208         Con
; 1208 trolEnable(hwndDlg,PCFG_DISP_CHEX,FALSE);
	push	0h
	push	012e5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1209         ControlEnable(hwndDlg,PCFG_DISP_DEC,FALSE);
	push	0h
	push	012e7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1210         ControlEnable(hwndDlg,GB_INTERRUPTSTATUSIDADDRESS,FALSE);
	push	0h
	push	0288fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1211         ControlEnable(hwndDlg,GB_ENTRYBASE,FALSE);
	push	0h
	push	02898h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1212         ControlEnable(hwndDlg,PCFG_INT_LEVEL,FALSE);
	push	0h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1213         ControlEnable(hwndDlg,PCFG_INT_LEVELT,FALSE);
	push	0h
	push	011f9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1214         ControlEnable(hwndDlg,DID_OEM_ALGO,FALSE);
	push	0h
	push	0132h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1215         if (byAdapterType != HDWTYPE_PCI)
	cmp	byte ptr [ebp-02h],09h;	byAdapterType
	je	@BLBL234

; 1216           CheckButton(hwndDlg,PCFG_OEM_OTHER,TRUE);
	push	01h
	push	0122ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL236
	align 010h
@BLBL234:

; 1217         else
; 1218           {
; 1219           GetPCIadapterName(szPCIname, byOEMtype);
	mov	al,[ebp-01h];	byOEMtype
	push	eax
	lea	eax,[ebp-066h];	szPCIname
	push	eax
	call	GetPCIadapterName
	add	esp,08h

; 1220           WinSetDlgItemText(hwndDlg,ST_PCIADAPTERNAME,szPCIname);
	lea	eax,[ebp-066h];	szPCIname
	push	eax
	push	0289bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1221           WinShowWindow(WinWindowFromID(hwndDlg,ST_PCIADAPTERNAME),TRUE);
	push	0289bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	01h
	push	eax
	call	WinShowWindow
	add	esp,08h

; 1222           CheckButton(hwndDlg,RB_TYPEPCI,TRUE);
	push	01h
	push	01232h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1223           }

; 1224         }
	jmp	@BLBL236
	align 010h
@BLBL233:

; 1225       else
; 1226         {
; 1227         CheckButton(hwndDlg,(PCFG_OEM_OTHER + byAdapterType),TRUE);
	push	01h
	xor	eax,eax
	mov	al,[ebp-02h];	byAdapterType
	add	eax,0122ah
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1228         WinSendDlgItemMsg(hwndDlg,PCFG_BASE_ADDR,EM_SETTEXTLIMIT,MPFROMSHORT(12),(MPARAM)NULL);
	push	0h
	push	0ch
	push	0143h
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 1229         switch (fDisplayBase)
	xor	eax,eax
	mov	al,byte ptr  @10afDisplayBase
	jmp	@BLBL309
	align 04h
@BLBL310:

; 1230           {
; 1231           case DISP_DEC:
; 1232             sprintf(szTitle,"%u",wAddress);
	xor	eax,eax
	mov	ax,[ebp-0130h];	wAddress
	push	eax
	mov	edx,offset FLAT:@STAT2c
	lea	eax,[ebp-012eh];	szTitle
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1233             CheckButton(hwndDlg,PCFG_DISP_DEC,TRUE);
	push	01h
	push	012e7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1234             break;
	jmp	@BLBL308
	align 04h
@BLBL311:
@BLBL312:

; 1235           case DISP_CHEX:
; 1236           default:
; 1237             CheckButton(hwndDlg,PCFG_DISP_CHEX,TRUE);
	push	01h
	push	012e5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1238             sprintf(szTitle,"%X",wAddress);
	xor	eax,eax
	mov	ax,[ebp-0130h];	wAddress
	push	eax
	mov	edx,offset FLAT:@STAT2d
	lea	eax,[ebp-012eh];	szTitle
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1239             break;
	jmp	@BLBL308
	align 04h
	jmp	@BLBL308
	align 04h
@BLBL309:
	cmp	eax,01h
	je	@BLBL310
	cmp	eax,03h
	je	@BLBL311
	jmp	@BLBL312
	align 04h
@BLBL308:

; 1240           }
; 1241         if (wAddress != 0)
	cmp	word ptr [ebp-0130h],0h;	wAddress
	je	@BLBL237

; 1242           WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szTitle);
	lea	eax,[ebp-012eh];	szTitle
	push	eax
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL237:

; 1243         if (byIntLevel == 0)
	cmp	byte ptr  @113byIntLevel,0h
	jne	@BLBL236

; 1244           if ((byIntLevel = stGlobalDCBheader.stComDCB.byInterruptLevel) == 0)
	mov	al,byte ptr  stGlobalDCBheader+030h
	mov	byte ptr  @113byIntLevel,al
	cmp	byte ptr  @113byIntLevel,0h
	jne	@BLBL236

; 1245             {
; 1246             byIntLevel = byLastIntLevel;
	mov	al,byte ptr  byLastIntLevel
	mov	byte ptr  @113byIntLevel,al

; 1247             if (!GetNextAvailableInterrupt(&byIntLevel))
	push	offset FLAT:@113byIntLevel
	call	GetNextAvailableInterrupt
	add	esp,04h
	test	eax,eax
	jne	@BLBL236

; 1248               {
; 1249               MessageBox(hwndDlg,"There are no more interrupts available.\n\nYou will have to delete a device, or remove a load, to free up an interrupt.");
	push	offset FLAT:@STAT2e
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 1250               WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 1251               return(MRESULT)TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL236:

; 1252               }
; 1253             }
; 1254         }
; 1255       WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,SPBM_SETLIMITS,(MPARAM)15L,(MPARAM)MIN_INT_LEVEL);
	push	02h
	push	0fh
	push	0207h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 1256       WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,SPBM_SETCURRENTVALUE,(MPARAM)byIntLevel,NULL);
	push	0h
	xor	eax,eax
	mov	al,byte ptr  @113byIntLevel
	push	eax
	push	0208h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 1257       return (MRESULT) TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL313:

; 1258     case WM_COMMAND:
; 1259       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL315
	align 04h
@BLBL316:

; 1260         {
; 1261         case DID_HELP:
; 1262           DisplayHelpPanel(pstCOMiCFG,HLPP_OEM_DLG);
	push	0754dh
	push	dword ptr  @111pstCOMiCFG
	call	DisplayHelpPanel
	add	esp,08h

; 1263           return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL317:

; 1264         case DID_OEM_ALGO:
; 1265           pstCOMiCFG->usValue = wIntAlgorithim;
	mov	eax,dword ptr  @111pstCOMiCFG
	mov	cx,word ptr  @10ewIntAlgorithim
	mov	[eax+03dh],cx

; 1266           if (WinDlgBox(HWND_DESKTOP,
	push	dword ptr  @111pstCOMiCFG
	push	01201h
	mov	eax,dword ptr  hThisModule
	push	eax
	push	offset FLAT: fnwpOEMIntAlgorithimDlgProc
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL241

; 1267                         hwndDlg,
; 1268                  (PFNWP)fnwpOEMIntAlgorithimDlgProc,
; 1269                         hThisModule,
; 1270                         PCFG_OEM_ALGO_DLG,
; 1271                         pstCOMiCFG))
; 1272             wIntAlgorithim = pstCOMiCFG->usValue;
	mov	eax,dword ptr  @111pstCOMiCFG
	mov	ax,[eax+03dh]
	mov	word ptr  @10ewIntAlgorithim,ax
@BLBL241:

; 1273           break;
	jmp	@BLBL314
	align 04h
@BLBL318:

; 1274         case DID_OK:
; 1275           pstCOMiCFG->bPCIadapter = FALSE;
	mov	eax,dword ptr  @111pstCOMiCFG
	and	byte ptr [eax+04bh],07fh

; 1276           if (!Checked(hwndDlg,RB_TYPEPCI) && !Checked(hwndDlg,PCFG_OEM_OTHER))
	push	01232h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL242
	push	0122ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL242

; 1277             {
; 1278             WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,SPBM_QUERYVALUE,&ulNewIntLevel,MPFROM2SHORT(0,SPBQ_DONOTUPDATE));
	push	030000h
	lea	eax,[ebp-0134h];	ulNewIntLevel
	push	eax
	push	0205h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 1279             if ((ulNewIntLevel <= 1) || (ulNewIntLevel > 15))
	cmp	dword ptr [ebp-0134h],01h;	ulNewIntLevel
	jbe	@BLBL243
	cmp	dword ptr [ebp-0134h],0fh;	ulNewIntLevel
	jbe	@BLBL244
@BLBL243:

; 1280               {
; 1281               MessageBox(hwndDlg,"The selected interrupt level is out of range.\n\nOnly values between 2 and 15 (inclusive) are valid.");
	push	offset FLAT:@STAT2f
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 1282               break;
	jmp	@BLBL314
	align 04h
@BLBL244:

; 1283               }
; 1284 //            pstCOMiCFG->bPCIadapter = FALSE;
; 1285             wLoadFlags &= ~(LOAD_FLAG1_INT_ID_LOAD_MASK | LOAD_FLAG1_ENABLE_ALL_OUT2);
	xor	eax,eax
	mov	ax,word ptr  @109wLoadFlags
	and	eax,0ffff7bf0h
	mov	word ptr  @109wLoadFlags,ax

; 1286             stGlobalCFGheader.wIntAlgorithim = wIntAlgorithim;
	mov	ax,word ptr  @10ewIntAlgorithim
	mov	word ptr  stGlobalCFGheader+010h,ax

; 1287             if (Checked(hwndDlg,PCFG_OEM_ONE))
	push	0122bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL245

; 1288               {
; 1289               byAdapterType = HDWTYPE_ONE;
	mov	byte ptr [ebp-02h],01h;	byAdapterType

; 1290               wLoadFlags |= LOAD_FLAG1_SCRATCH_IS_INT_ID;
	mov	ax,word ptr  @109wLoadFlags
	or	al,01h
	mov	word ptr  @109wLoadFlags,ax

; 1291               iOEMloadMaxDevice = 8;
	mov	dword ptr  iOEMloadMaxDevice,08h

; 1292               switch (wIntAlgorithim)
	xor	eax,eax
	mov	ax,word ptr  @10ewIntAlgorithim
	jmp	@BLBL320
	align 04h
@BLBL321:

; 1293                 {
; 1294                 case ALGO_POLL:
; 1295                   wOEMentryVector = ALGO_VECT_TEST_ZERO;
	mov	word ptr [ebp-0136h],06h;	wOEMentryVector

; 1296                   wOEMexitVector = ALGO_VECT_TEST_ZERO;
	mov	word ptr [ebp-0138h],06h;	wOEMexitVector

; 1297                   break;
	jmp	@BLBL319
	align 04h
@BLBL322:

; 1298                 case ALGO_SELECT:
; 1299                   wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
	mov	word ptr [ebp-0136h],02h;	wOEMentryVector

; 1300                   wOEMexitVector = ALGO_VECT_ID_IS_BITS_ON;
	mov	word ptr [ebp-0138h],02h;	wOEMexitVector

; 1301                   break;
	jmp	@BLBL319
	align 04h
@BLBL323:

; 1302                 case ALGO_HYBRID:
; 1303                   wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
	mov	word ptr [ebp-0136h],02h;	wOEMentryVector

; 1304                   wOEMexitVector = ALGO_VECT_TEST_ZERO;
	mov	word ptr [ebp-0138h],06h;	wOEMexitVector

; 1305                   break;
	jmp	@BLBL319
	align 04h
	jmp	@BLBL319
	align 04h
@BLBL320:
	test	eax,eax
	je	@BLBL321
	cmp	eax,01h
	je	@BLBL322
	cmp	eax,02h
	je	@BLBL323
@BLBL319:

; 1306                 }
; 1307               }
	jmp	@BLBL259
	align 010h
@BLBL245:

; 1308             else
; 1309               if (Checked(hwndDlg,PCFG_OEM_TWO))
	push	0122ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL247

; 1310                 {
; 1311                 byAdapterType = HDWTYPE_TWO;
	mov	byte ptr [ebp-02h],02h;	byAdapterType

; 1312                 wLoadFlags |= (LOAD_FLAG1_SCRATCH_IS_INT_ID | LOAD_FLAG1_TIB_UART);
	mov	ax,word ptr  @109wLoadFlags
	or	al,09h
	mov	word ptr  @109wLoadFlags,ax

; 1313                 iOEMloadMaxDevice = 8;
	mov	dword ptr  iOEMloadMaxDevice,08h

; 1314                 switch (wIntAlgorithim)
	xor	eax,eax
	mov	ax,word ptr  @10ewIntAlgorithim
	jmp	@BLBL325
	align 04h
@BLBL326:

; 1315                   {
; 1316                   case ALGO_POLL:
; 1317                     wOEMentryVector = ALGO_VECT_TEST_ZERO;
	mov	word ptr [ebp-0136h],06h;	wOEMentryVector

; 1318                     wOEMexitVector = ALGO_VECT_TEST_ZERO;
	mov	word ptr [ebp-0138h],06h;	wOEMexitVector

; 1319                     break;
	jmp	@BLBL324
	align 04h
@BLBL327:

; 1320                   case ALGO_SELECT:
; 1321                     wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
	mov	word ptr [ebp-0136h],02h;	wOEMentryVector

; 1322                     wOEMexitVector = ALGO_VECT_ID_IS_BITS_ON;
	mov	word ptr [ebp-0138h],02h;	wOEMexitVector

; 1323                     break;
	jmp	@BLBL324
	align 04h
@BLBL328:

; 1324                   case ALGO_HYBRID:
; 1325                     wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
	mov	word ptr [ebp-0136h],02h;	wOEMentryVector

; 1326                     wOEMexitVector = ALGO_VECT_TEST_ZERO;
	mov	word ptr [ebp-0138h],06h;	wOEMexitVector

; 1327                     break;
	jmp	@BLBL324
	align 04h
	jmp	@BLBL324
	align 04h
@BLBL325:
	test	eax,eax
	je	@BLBL326
	cmp	eax,01h
	je	@BLBL327
	cmp	eax,02h
	je	@BLBL328
@BLBL324:

; 1328                   }
; 1329                 }
	jmp	@BLBL259
	align 010h
@BLBL247:

; 1330               else
; 1331                 if (Checked(hwndDlg,PCFG_OEM_THREE))
	push	0122dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL249

; 1332                   {
; 1333                   byAdapterType = HDWTYPE_THREE;
	mov	byte ptr [ebp-02h],03h;	byAdapterType

; 1334 //                  wLoadFlags |= LOAD_FLAG1_SCRATCH_IS_INT_ID;
; 1335                   iOEMloadMaxDevice = 8;
	mov	dword ptr  iOEMloadMaxDevice,08h

; 1336                   switch (wIntAlgorithim)
	xor	eax,eax
	mov	ax,word ptr  @10ewIntAlgorithim
	jmp	@BLBL330
	align 04h
@BLBL331:

; 1337                     {
; 1338                     case ALGO_POLL:
; 1339                       wOEMentryVector = ALGO_VECT_TEST_ZERO;
	mov	word ptr [ebp-0136h],06h;	wOEMentryVector

; 1340                       wOEMexitVector = ALGO_VECT_TEST_ZERO;
	mov	word ptr [ebp-0138h],06h;	wOEMexitVector

; 1341                       break;
	jmp	@BLBL329
	align 04h
@BLBL332:

; 1342                     case ALGO_SELECT:
; 1343                       wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
	mov	word ptr [ebp-0136h],02h;	wOEMentryVector

; 1344                       wOEMexitVector = ALGO_VECT_ID_IS_BITS_ON;
	mov	word ptr [ebp-0138h],02h;	wOEMexitVector

; 1345                       break;
	jmp	@BLBL329
	align 04h
@BLBL333:

; 1346                     case ALGO_HYBRID:
; 1347                       wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
	mov	word ptr [ebp-0136h],02h;	wOEMentryVector

; 1348                       wOEMexitVector = ALGO_VECT_TEST_ZERO;
	mov	word ptr [ebp-0138h],06h;	wOEMexitVector

; 1349                       break;
	jmp	@BLBL329
	align 04h
	jmp	@BLBL329
	align 04h
@BLBL330:
	test	eax,eax
	je	@BLBL331
	cmp	eax,01h
	je	@BLBL332
	cmp	eax,02h
	je	@BLBL333
@BLBL329:

; 1350                     }
; 1351                   }
	jmp	@BLBL259
	align 010h
@BLBL249:

; 1352                 else
; 1353                     if (Checked(hwndDlg,PCFG_OEM_FOUR))
	push	0122eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL251

; 1354                       {
; 1355                       byAdapterType = HDWTYPE_FOUR;
	mov	byte ptr [ebp-02h],04h;	byAdapterType

; 1356                       wLoadFlags |= LOAD_FLAG1_DIGIBOARD08_INT_ID;
	mov	ax,word ptr  @109wLoadFlags
	or	al,02h
	mov	word ptr  @109wLoadFlags,ax

; 1357                       iOEMloadMaxDevice = 8;
	mov	dword ptr  iOEMloadMaxDevice,08h

; 1358                       switch (wIntAlgorithim)
	xor	eax,eax
	mov	ax,word ptr  @10ewIntAlgorithim
	jmp	@BLBL335
	align 04h
@BLBL336:

; 1359                         {
; 1360                         case ALGO_POLL:
; 1361                           wOEMentryVector = ALGO_VECT_TEST_FF;
	mov	word ptr [ebp-0136h],08h;	wOEMentryVector

; 1362                           wOEMexitVector = ALGO_VECT_TEST_FF;
	mov	word ptr [ebp-0138h],08h;	wOEMexitVector

; 1363                           break;
	jmp	@BLBL334
	align 04h
@BLBL337:

; 1364                         case ALGO_SELECT:
; 1365                           wOEMentryVector = ALGO_VECT_DigiBoard_ID;
	mov	word ptr [ebp-0136h],04h;	wOEMentryVector

; 1366                           wOEMexitVector = ALGO_VECT_DigiBoard_ID;
	mov	word ptr [ebp-0138h],04h;	wOEMexitVector

; 1367                           break;
	jmp	@BLBL334
	align 04h
@BLBL338:

; 1368                         case ALGO_HYBRID:
; 1369                           wOEMentryVector = ALGO_VECT_DigiBoard_ID;
	mov	word ptr [ebp-0136h],04h;	wOEMentryVector

; 1370                           wOEMexitVector = ALGO_VECT_TEST_FF;
	mov	word ptr [ebp-0138h],08h;	wOEMexitVector

; 1371                           break;
	jmp	@BLBL334
	align 04h
	jmp	@BLBL334
	align 04h
@BLBL335:
	test	eax,eax
	je	@BLBL336
	cmp	eax,01h
	je	@BLBL337
	cmp	eax,02h
	je	@BLBL338
@BLBL334:

; 1372                         }
; 1373                       }
	jmp	@BLBL259
	align 010h
@BLBL251:

; 1374                     else
; 1375                       if (Checked(hwndDlg,PCFG_OEM_FIVE))
	push	0122fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL253

; 1376                         {
; 1377                         byAdapterType = HDWTYPE_FIVE;
	mov	byte ptr [ebp-02h],05h;	byAdapterType

; 1378                         wLoadFlags |= LOAD_FLAG1_DIGIBOARD16_INT_ID;
	mov	ax,word ptr  @109wLoadFlags
	or	al,04h
	mov	word ptr  @109wLoadFlags,ax

; 1379                         iOEMloadMaxDevice = 16;
	mov	dword ptr  iOEMloadMaxDevice,010h

; 1380                         switch (wIntAlgorithim)
	xor	eax,eax
	mov	ax,word ptr  @10ewIntAlgorithim
	jmp	@BLBL340
	align 04h
@BLBL341:

; 1381                           {
; 1382                           case ALGO_POLL:
; 1383                             wOEMentryVector = ALGO_VECT_TEST_FF;
	mov	word ptr [ebp-0136h],08h;	wOEMentryVector

; 1384                             wOEMexitVector = ALGO_VECT_TEST_FF;
	mov	word ptr [ebp-0138h],08h;	wOEMexitVector

; 1385                             break;
	jmp	@BLBL339
	align 04h
@BLBL342:

; 1386                           case ALGO_SELECT:
; 1387                             wOEMentryVector = ALGO_VECT_DigiBoard_ID;
	mov	word ptr [ebp-0136h],04h;	wOEMentryVector

; 1388                             wOEMexitVector = ALGO_VECT_DigiBoard_ID;
	mov	word ptr [ebp-0138h],04h;	wOEMexitVector

; 1389                             break;
	jmp	@BLBL339
	align 04h
@BLBL343:

; 1390                           case ALGO_HYBRID:
; 1391                             wOEMentryVector = ALGO_VECT_DigiBoard_ID;
	mov	word ptr [ebp-0136h],04h;	wOEMentryVector

; 1392                             wOEMexitVector = ALGO_VECT_TEST_FF;
	mov	word ptr [ebp-0138h],08h;	wOEMexitVector

; 1393           
; 1393                   break;
	jmp	@BLBL339
	align 04h
	jmp	@BLBL339
	align 04h
@BLBL340:
	test	eax,eax
	je	@BLBL341
	cmp	eax,01h
	je	@BLBL342
	cmp	eax,02h
	je	@BLBL343
@BLBL339:

; 1394                           }
; 1395                         }
	jmp	@BLBL259
	align 010h
@BLBL253:

; 1396                       else
; 1397                         if (Checked(hwndDlg,PCFG_OEM_SIX))
	push	01230h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL255

; 1398                           {
; 1399                           byAdapterType = HDWTYPE_SIX;
	mov	byte ptr [ebp-02h],06h;	byAdapterType

; 1400 //                          wLoadFlags |= LOAD_FLAG1_SCRATCH_IS_INT_ID;
; 1401                           iOEMloadMaxDevice = 8;
	mov	dword ptr  iOEMloadMaxDevice,08h

; 1402                           switch (wIntAlgorithim)
	xor	eax,eax
	mov	ax,word ptr  @10ewIntAlgorithim
	jmp	@BLBL345
	align 04h
@BLBL346:

; 1403                             {
; 1404                             case ALGO_POLL:
; 1405                               wOEMentryVector = ALGO_VECT_TEST_FF;
	mov	word ptr [ebp-0136h],08h;	wOEMentryVector

; 1406                               wOEMexitVector = ALGO_VECT_TEST_FF;
	mov	word ptr [ebp-0138h],08h;	wOEMexitVector

; 1407                               break;
	jmp	@BLBL344
	align 04h
@BLBL347:

; 1408                             case ALGO_SELECT:
; 1409                               wOEMentryVector = ALGO_VECT_ID_IS_BITS_OFF;
	mov	word ptr [ebp-0136h],0ah;	wOEMentryVector

; 1410                               wOEMexitVector = ALGO_VECT_ID_IS_BITS_OFF;
	mov	word ptr [ebp-0138h],0ah;	wOEMexitVector

; 1411                               break;
	jmp	@BLBL344
	align 04h
@BLBL348:

; 1412                             case ALGO_HYBRID:
; 1413                               wOEMentryVector = ALGO_VECT_ID_IS_BITS_OFF;
	mov	word ptr [ebp-0136h],0ah;	wOEMentryVector

; 1414                               wOEMexitVector = ALGO_VECT_TEST_FF;
	mov	word ptr [ebp-0138h],08h;	wOEMexitVector

; 1415                               break;
	jmp	@BLBL344
	align 04h
	jmp	@BLBL344
	align 04h
@BLBL345:
	test	eax,eax
	je	@BLBL346
	cmp	eax,01h
	je	@BLBL347
	cmp	eax,02h
	je	@BLBL348
@BLBL344:

; 1416                             }
; 1417                           }
	jmp	@BLBL259
	align 010h
@BLBL255:

; 1418                         else
; 1419                           if (Checked(hwndDlg,PCFG_OEM_SEVEN))
	push	01231h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL257

; 1420                             {
; 1421                             byAdapterType = HDWTYPE_SEVEN;
	mov	byte ptr [ebp-02h],07h;	byAdapterType

; 1422                             wLoadFlags |= (LOAD_FLAG1_SCRATCH_IS_INT_ID | LOAD_FLAG1_ENABLE_ALL_OUT2);
	mov	ax,word ptr  @109wLoadFlags
	or	ax,0401h
	mov	word ptr  @109wLoadFlags,ax

; 1423                             iOEMloadMaxDevice = 8;
	mov	dword ptr  iOEMloadMaxDevice,08h

; 1424                             switch (wIntAlgorithim)
	xor	eax,eax
	mov	ax,word ptr  @10ewIntAlgorithim
	jmp	@BLBL350
	align 04h
@BLBL351:

; 1425                               {
; 1426                               case ALGO_POLL:
; 1427                                 wOEMentryVector = ALGO_VECT_TEST_ZERO;
	mov	word ptr [ebp-0136h],06h;	wOEMentryVector

; 1428                                 wOEMexitVector = ALGO_VECT_TEST_ZERO;
	mov	word ptr [ebp-0138h],06h;	wOEMexitVector

; 1429                                 break;
	jmp	@BLBL349
	align 04h
@BLBL352:

; 1430                               case ALGO_SELECT:
; 1431                                 wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
	mov	word ptr [ebp-0136h],02h;	wOEMentryVector

; 1432                                 wOEMexitVector = ALGO_VECT_ID_IS_BITS_ON;
	mov	word ptr [ebp-0138h],02h;	wOEMexitVector

; 1433                                 break;
	jmp	@BLBL349
	align 04h
@BLBL353:

; 1434                               case ALGO_HYBRID:
; 1435                                 wOEMentryVector = ALGO_VECT_ID_IS_BITS_ON;
	mov	word ptr [ebp-0136h],02h;	wOEMentryVector

; 1436                                 wOEMexitVector = ALGO_VECT_TEST_ZERO;
	mov	word ptr [ebp-0138h],06h;	wOEMexitVector

; 1437                                 break;
	jmp	@BLBL349
	align 04h
	jmp	@BLBL349
	align 04h
@BLBL350:
	test	eax,eax
	je	@BLBL351
	cmp	eax,01h
	je	@BLBL352
	cmp	eax,02h
	je	@BLBL353
@BLBL349:

; 1438                               }
; 1439                             }
	jmp	@BLBL259
	align 010h
@BLBL257:

; 1440                           else
; 1441                             {
; 1442                             iOEMloadMaxDevice = 8;
	mov	dword ptr  iOEMloadMaxDevice,08h

; 1443                             wOEMentryVector = ALGO_VECT_POLL;
	mov	word ptr [ebp-0136h],0h;	wOEMentryVector

; 1444                             wOEMexitVector = ALGO_VECT_POLL;
	mov	word ptr [ebp-0138h],0h;	wOEMexitVector

; 1445                             }

; 1446             }
	jmp	@BLBL259
	align 010h
@BLBL242:

; 1447           else
; 1448             {
; 1449             if (Checked(hwndDlg,PCFG_OEM_OTHER))
	push	0122ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL260

; 1450               {
; 1451               byAdapterType = HDWTYPE_NONE;
	mov	byte ptr [ebp-02h],0h;	byAdapterType

; 1452               iOEMloadMaxDevice = 8;
	mov	dword ptr  iOEMloadMaxDevice,08h

; 1453               wOEMentryVector = ALGO_VECT_POLL;
	mov	word ptr [ebp-0136h],0h;	wOEMentryVector

; 1454               wOEMexitVector = ALGO_VECT_POLL;
	mov	word ptr [ebp-0138h],0h;	wOEMexitVector

; 1455               }
	jmp	@BLBL259
	align 010h
@BLBL260:

; 1456             else
; 1457               {
; 1458               byAdapterType = HDWTYPE_PCI;
	mov	byte ptr [ebp-02h],09h;	byAdapterType

; 1459               pstCOMiCFG->bPCIadapter = TRUE;
	mov	eax,dword ptr  @111pstCOMiCFG
	or	byte ptr [eax+04bh],080h

; 1460               wOEMentryVector = ALGO_VECT_POLL;
	mov	word ptr [ebp-0136h],0h;	wOEMentryVector

; 1461               wOEMexitVector = ALGO_VECT_POLL;
	mov	word ptr [ebp-0138h],0h;	wOEMexitVector

; 1462               }

; 1463             }
@BLBL259:

; 1464           stGlobalCFGheader.byAdapterType = byAdapterType;
	mov	al,[ebp-02h];	byAdapterType
	mov	byte ptr  stGlobalCFGheader+0ah,al

; 1465           stGlobalCFGheader.wLoadFlags = wLoadFlags;
	mov	ax,word ptr  @109wLoadFlags
	mov	word ptr  stGlobalCFGheader+012h,ax

; 1466           stGlobalCFGheader.wDCBcount = iOEMloadMaxDevice;
	mov	eax,dword ptr  iOEMloadMaxDevice
	mov	word ptr  stGlobalCFGheader+02h,ax

; 1467           stGlobalCFGheader.wOEMentryVector = wOEMentryVector;
	mov	ax,[ebp-0136h];	wOEMentryVector
	mov	word ptr  stGlobalCFGheader+0ch,ax

; 1468           stGlobalCFGheader.wOEMexitVector = wOEMexitVector;
	mov	ax,[ebp-0138h];	wOEMexitVector
	mov	word ptr  stGlobalCFGheader+0eh,ax

; 1469           stGlobalCFGheader.wIntAlgorithim = wIntAlgorithim;
	mov	ax,word ptr  @10ewIntAlgorithim
	mov	word ptr  stGlobalCFGheader+010h,ax

; 1470           if ((byAdapterType != HDWTYPE_NONE) && (byAdapterType != HDWTYPE_PCI))
	cmp	byte ptr [ebp-02h],0h;	byAdapterType
	je	@BLBL262
	cmp	byte ptr [ebp-02h],09h;	byAdapterType
	je	@BLBL262

; 1471 //          if ((byOEMtype != OEM_OTHER) && (byAdapterType != HDWTYPE_PCI))
; 1472             {
; 1473             WinQueryDlgItemText(hwndDlg,PCFG_BASE_ADDR,12,szTitle);
	lea	eax,[ebp-012eh];	szTitle
	push	eax
	push	0ch
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinQueryDlgItemText
	add	esp,010h

; 1474             if (fDisplayBase == DISP_HEX)
	cmp	byte ptr  @10afDisplayBase,0h
	jne	@BLBL263

; 1475               wAddress = ASCIItoBin(szTitle,16);
	push	010h
	lea	eax,[ebp-012eh];	szTitle
	push	eax
	call	ASCIItoBin
	add	esp,08h
	mov	[ebp-0130h],ax;	wAddress
	jmp	@BLBL264
	align 010h
@BLBL263:

; 1476             else
; 1477               wAddress = atoi(szTitle);
	lea	eax,[ebp-012eh];	szTitle
	call	atoi
	mov	[ebp-0130h],ax;	wAddress
@BLBL264:

; 1478             if (wAddress == 0)
	cmp	word ptr [ebp-0130h],0h;	wAddress
	jne	@BLBL265

; 1479               {
; 1480               MessageBox(hwndDlg,"You must enter an interrupt ID register address if you have selected any adapter type except \"Not interrupt sharing\".");
	push	offset FLAT:@STAT30
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 1481               return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL265:

; 1482               }
; 1483             switch (byAdapterType)
	xor	eax,eax
	mov	al,[ebp-02h];	byAdapterType
	jmp	@BLBL355
	align 04h
@BLBL356:
@BLBL357:

; 1484               {
; 1485               case HDWTYPE_THREE:  // DigiBoard PC/4
; 1486               case HDWTYPE_FOUR:   // DigiBoard PC/8
; 1487                 break;
	jmp	@BLBL354
	align 04h
@BLBL358:

; 1488               case HDWTYPE_FIVE:   // DigiBoard PC/16
; 1489                 if (wLastAddress == 0x3f8)
	cmp	word ptr  wLastAddress,03f8h
	jne	@BLBL266

; 1490                   switch (wAddress)
	xor	eax,eax
	mov	ax,[ebp-0130h];	wAddress
	jmp	@BLBL360
	align 04h
@BLBL361:

; 1491                     {
; 1492                     case 0x140:
; 1493                       wLastAddress = 0x100;
	mov	word ptr  wLastAddress,0100h

; 1494                       break;
	jmp	@BLBL359
	align 04h
@BLBL362:

; 1495                     case 0x188:
; 1496                       wLastAddress = 0x130;
	mov	word ptr  wLastAddress,0130h

; 1497                       break;
	jmp	@BLBL359
	align 04h
@BLBL363:

; 1498                     case 0x289:
; 1499                       wLastAddress = 0x230;
	mov	word ptr  wLastAddress,0230h

; 1500                       break;
	jmp	@BLBL359
	align 04h
	jmp	@BLBL359
	align 04h
@BLBL360:
	cmp	eax,0140h
	je	@BLBL361
	cmp	eax,0188h
	je	@BLBL362
	cmp	eax,0289h
	je	@BLBL363
@BLBL359:
@BLBL266:

; 1501                     }
; 1502 //                AddListItem(pLoadAddressList,&wLastAddress,2);
; 1503 //                AddListItem(pAddressList,&wLastAddress,2);
; 1504                 if (!pstCOMiCFG->bPCIadapter)
	mov	eax,dword ptr  @111pstCOMiCFG
	test	byte ptr [eax+04bh],080h
	jne	@BLBL267

; 1505                   {
; 1506                   AddListItem(pLoadAddressList,&wAddress,2);
	push	02h
	lea	eax,[ebp-0130h];	wAddress
	push	eax
	push	dword ptr  pLoadAddressList
	call	AddListItem
	add	esp,0ch

; 1507                   AddListItem(pAddressList,&wAddress,2);
	push	02h
	lea	eax,[ebp-0130h];	wAddress
	push	eax
	push	dword ptr  pAddressList
	call	AddListItem
	add	esp,0ch

; 1508                   }
@BLBL267:

; 1509                 break;
	jmp	@BLBL354
	align 04h
@BLBL364:

; 1510               default:
; 1511                 if ((wAddress - 7) % 8)
	xor	eax,eax
	mov	ax,[ebp-0130h];	wAddress
	sub	eax,07h
	cdq	
	xor	eax,edx
	sub	eax,edx
	and	eax,07h
	xor	eax,edx
	sub	eax,edx
	test	eax,eax
	je	@BLBL268

; 1512                   {
; 1513                   MessageBox(hwndDlg,"The interrupt ID register must be at the adapter's base I/O address plus seven (e.g., 0x307) for the adapter type you have selected.");
	push	offset FLAT:@STAT31
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 1514                   return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL268:

; 1515                   }
; 1516                 else
; 1517                   if (wLastAddress == 0x3f8)
	cmp	word ptr  wLastAddress,03f8h
	jne	@BLBL269

; 1518                     wLastAddress = (wAddress - 7);
	mov	ax,[ebp-0130h];	wAddress
	sub	ax,07h
	mov	word ptr  wLastAddress,ax
@BLBL269:

; 1519                 break;
	jmp	@BLBL354
	align 04h
	jmp	@BLBL354
	align 04h
@BLBL355:
	cmp	eax,03h
	je	@BLBL356
	cmp	eax,04h
	je	@BLBL357
	cmp	eax,05h
	je	@BLBL358
	jmp	@BLBL364
	align 04h
@BLBL354:

; 1520               }
; 1521             stGlobalCFGheader.wIntIDregister = wAddress;
	mov	ax,[ebp-0130h];	wAddress
	mov	word ptr  stGlobalCFGheader+014h,ax

; 1522             if ((byIntLevel != 0) && ((BYTE)ulNewIntLevel != byIntLevel))
	cmp	byte ptr  @113byIntLevel,0h
	je	@BLBL271
	mov	al,[ebp-0134h];	ulNewIntLevel
	cmp	byte ptr  @113byIntLevel,al
	je	@BLBL271

; 1523               if ((pListItem = FindListByteItem(pInterruptList,byIntLevel)) != NULL)
	mov	al,byte ptr  @113byIntLevel
	push	eax
	push	dword ptr  pInterruptList
	call	FindListByteItem
	add	esp,08h
	mov	[ebp-013ch],eax;	pListItem
	cmp	dword ptr [ebp-013ch],0h;	pListItem
	je	@BLBL271

; 1524                 RemoveListItem(pListItem);
	push	dword ptr [ebp-013ch];	pListItem
	call	RemoveListItem
	add	esp,04h
@BLBL271:

; 1525             byIntLevel = (BYTE)ulNewIntLevel;
	mov	eax,[ebp-0134h];	ulNewIntLevel
	mov	byte ptr  @113byIntLevel,al

; 1526             if (FindListByteItem(pInterruptList,byIntLevel) != NULL)
	mov	al,byte ptr  @113byIntLevel
	push	eax
	push	dword ptr  pInterruptList
	call	FindListByteItem
	add	esp,08h
	test	eax,eax
	je	@BLBL273

; 1527               if ((FindListByteItem(pLoadInterruptList,byIntLevel) == NULL) &&
	mov	al,byte ptr  @113byIntLevel
	push	eax
	push	dword ptr  pLoadInterruptList
	call	FindListByteItem
	add	esp,08h
	test	eax,eax
	jne	@BLBL273

; 1528                   (FindListByteItem(pLoadInterruptList,(byIntLevel | '\x80')) == NULL))
	mov	al,byte ptr  @113byIntLevel
	or	al,080h
	push	eax
	push	dword ptr  pLoadInterruptList
	call	FindListByteItem
	add	esp,08h
	test	eax,eax
	jne	@BLBL273

; 1529                 {
; 1530                 sprintf(szTitle,"Interrupt level %u is already taken.  Please select a different Interrupt.",byIntLevel);
	xor	eax,eax
	mov	al,byte ptr  @113byIntLevel
	push	eax
	mov	edx,offset FLAT:@STAT32
	lea	eax,[ebp-012eh];	szTitle
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 1531                 MessageBox(hwndDlg,szTitle);
	lea	eax,[ebp-012eh];	szTitle
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 1532                 return((MRESULT)TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL273:

; 1533                 }
; 1534             AddListItem(pInterruptList,&byIntLevel,1);
	push	01h
	push	offset FLAT:@113byIntLevel
	push	dword ptr  pInterruptList
	call	AddListItem
	add	esp,0ch

; 1535             byLastIntLevel = byIntLevel;
	mov	al,byte ptr  @113byIntLevel
	mov	byte ptr  byLastIntLevel,al

; 1536             stGlobalCFGheader.byInterruptLevel = byIntLevel;
	mov	al,byte ptr  @113byIntLevel
	mov	byte ptr  stGlobalCFGheader+0bh,al

; 1537             }
	jmp	@BLBL275
	align 010h
@BLBL262:

; 1538           else
; 1539             {
; 1540             if (byAdapterType == HDWTYPE_NONE)
	cmp	byte ptr [ebp-02h],0h;	byAdapterType
	jne	@BLBL276

; 1541 //            if (Checked(hwndDlg,PCFG_OEM_OTHER))
; 1542               if (byIntLevel != 0)
	cmp	byte ptr  @113byIntLevel,0h
	je	@BLBL276

; 1543                 {
; 1544                 if ((pListItem = FindListByteItem(pInterruptList,byIntLevel)) == NULL)
	mov	al,byte ptr  @113byIntLevel
	push	eax
	push	dword ptr  pInterruptList
	call	FindListByteItem
	add	esp,08h
	mov	[ebp-013ch],eax;	pListItem
	cmp	dword ptr [ebp-013ch],0h;	pListItem
	jne	@BLBL278

; 1545                   pListItem = FindListByteItem(pInterruptList,byIntLevel);
	mov	al,byte ptr  @113byIntLevel
	push	eax
	push	dword ptr  pInterruptList
	call	FindListByteItem
	add	esp,08h
	mov	[ebp-013ch],eax;	pListItem
@BLBL278:

; 1546                 if (pListItem != NULL)
	cmp	dword ptr [ebp-013ch],0h;	pListItem
	je	@BLBL276

; 1547                   RemoveListItem(pListItem);
	push	dword ptr [ebp-013ch];	pListItem
	call	RemoveListItem
	add	esp,04h

; 1548                 }
@BLBL276:

; 1549             stGlobalCFGheader.byInterruptLevel = 0;
	mov	byte ptr  stGlobalCFGheader+0bh,0h

; 1550             stGlobalCFGheader.wIntIDregister = 0;
	mov	word ptr  stGlobalCFGheader+014h,0h

; 1551             }
@BLBL275:

; 1552           WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 1553           return(MRESULT)TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL365:

; 1554         case DID_CANCEL:
; 1555           WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 1556           break;
	jmp	@BLBL314
	align 04h
@BLBL366:

; 1557         default:
; 1558           return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
	jmp	@BLBL314
	align 04h
@BLBL315:
	cmp	eax,012dh
	je	@BLBL316
	cmp	eax,0132h
	je	@BLBL317
	cmp	eax,01h
	je	@BLBL318
	cmp	eax,02h
	je	@BLBL365
	jmp	@BLBL366
	align 04h
@BLBL314:

; 1559         }
; 1560       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL367:

; 1561     case WM_CONTROL:
; 1562       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL369
	align 04h
@BLBL370:
@BLBL371:

; 1563         {
; 1564         case PCFG_DISP_CHEX:
; 1565         case PCFG_DISP_DEC:
; 1566           if (Checked(hwndDlg,PCFG_DISP_CHEX))
	push	012e5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL280

; 1567             {
; 1568             if (fDisplayBase != DISP_HEX)
	cmp	byte ptr  @10afDisplayBase,0h
	je	@BLBL282

; 1569               {
; 1570               fDisplayBase = DISP_HEX;
	mov	byte ptr  @10afDisplayBase,0h

; 1571               WinQueryDlgItemText(hwndDlg,PCFG_BASE_ADDR,12,szTitle);
	lea	eax,[ebp-012eh];	szTitle
	push	eax
	push	0ch
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinQueryDlgItemText
	add	esp,010h

; 1572               wAddress = atoi(szTitle);
	lea	eax,[ebp-012eh];	szTitle
	call	atoi
	mov	[ebp-0130h],ax;	wAddress

; 1573               itoa(wAddress,szTitle,16);
	mov	ecx,010h
	lea	edx,[ebp-012eh];	szTitle
	xor	eax,eax
	mov	ax,[ebp-0130h];	wAddress
	call	_itoa

; 1574               WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szTitle);
	lea	eax,[ebp-012eh];	szTitle
	push	eax
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1575               }

; 1576             }
	jmp	@BLBL282
	align 010h
@BLBL280:

; 1577           else
; 1578             {
; 1579             i
; 1579 f (fDisplayBase != DISP_DEC)
	cmp	byte ptr  @10afDisplayBase,01h
	je	@BLBL282

; 1580               {
; 1581               fDisplayBase = DISP_DEC;
	mov	byte ptr  @10afDisplayBase,01h

; 1582               WinQueryDlgItemText(hwndDlg,PCFG_BASE_ADDR,12,szTitle);
	lea	eax,[ebp-012eh];	szTitle
	push	eax
	push	0ch
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinQueryDlgItemText
	add	esp,010h

; 1583               wAddress = (WORD)ASCIItoBin(szTitle,16);
	push	010h
	lea	eax,[ebp-012eh];	szTitle
	push	eax
	call	ASCIItoBin
	add	esp,08h
	mov	[ebp-0130h],ax;	wAddress

; 1584               itoa(wAddress,szTitle,10);
	mov	ecx,0ah
	lea	edx,[ebp-012eh];	szTitle
	xor	eax,eax
	mov	ax,[ebp-0130h];	wAddress
	call	_itoa

; 1585               WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szTitle);
	lea	eax,[ebp-012eh];	szTitle
	push	eax
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1586               }

; 1587             }
@BLBL282:
@BLBL372:
@BLBL373:
@BLBL374:
@BLBL375:
@BLBL376:
@BLBL377:
@BLBL378:

; 1588         case PCFG_OEM_ONE:
; 1589         case PCFG_OEM_TWO:
; 1590         case PCFG_OEM_THREE:
; 1591         case PCFG_OEM_FOUR:
; 1592         case PCFG_OEM_FIVE:
; 1593         case PCFG_OEM_SIX:
; 1594         case PCFG_OEM_SEVEN:
; 1595 //        case PCFG_OEM_EIGHT:
; 1596           if (Checked(hwndDlg,SHORT1FROMMP(mp1)))
	mov	ax,[ebp+010h];	mp1
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL284

; 1597             {
; 1598             WinShowWindow(WinWindowFromID(hwndDlg,ST_PCIADAPTERNAME),FALSE);
	push	0289bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	0h
	push	eax
	call	WinShowWindow
	add	esp,08h

; 1599 //            CheckButton(hwndDlg,PCFG_OEM_OTHER,TRUE);
; 1600             ControlEnable(hwndDlg,PCFG_BASE_ADDR,TRUE);
	push	01h
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1601             ControlEnable(hwndDlg,PCFG_DISP_CHEX,TRUE);
	push	01h
	push	012e5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1602             ControlEnable(hwndDlg,PCFG_DISP_DEC,TRUE);
	push	01h
	push	012e7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1603             ControlEnable(hwndDlg,GB_INTERRUPTSTATUSIDADDRESS,TRUE);
	push	01h
	push	0288fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1604             ControlEnable(hwndDlg,GB_ENTRYBASE,TRUE);
	push	01h
	push	02898h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1605             ControlEnable(hwndDlg,PCFG_INT_LEVEL,TRUE);
	push	01h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1606             ControlEnable(hwndDlg,PCFG_INT_LEVELT,TRUE);
	push	01h
	push	011f9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1607             ControlEnable(hwndDlg,DID_OEM_ALGO,TRUE);
	push	01h
	push	0132h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1608             }
@BLBL284:

; 1609           break;
	jmp	@BLBL368
	align 04h
@BLBL379:

; 1610         case PCFG_OEM_OTHER:
; 1611           if (Checked(hwndDlg,PCFG_OEM_OTHER))
	push	0122ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL285

; 1612             {
; 1613             WinShowWindow(WinWindowFromID(hwndDlg,ST_PCIADAPTERNAME),FALSE);
	push	0289bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	0h
	push	eax
	call	WinShowWindow
	add	esp,08h

; 1614 //            CheckButton(hwndDlg,PCFG_OEM_OTHER,TRUE);
; 1615             ControlEnable(hwndDlg,PCFG_BASE_ADDR,FALSE);
	push	0h
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1616             ControlEnable(hwndDlg,PCFG_DISP_CHEX,FALSE);
	push	0h
	push	012e5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1617             ControlEnable(hwndDlg,PCFG_DISP_DEC,FALSE);
	push	0h
	push	012e7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1618             ControlEnable(hwndDlg,GB_INTERRUPTSTATUSIDADDRESS,FALSE);
	push	0h
	push	0288fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1619             ControlEnable(hwndDlg,GB_ENTRYBASE,FALSE);
	push	0h
	push	02898h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1620             ControlEnable(hwndDlg,PCFG_INT_LEVEL,FALSE);
	push	0h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1621             ControlEnable(hwndDlg,PCFG_INT_LEVELT,FALSE);
	push	0h
	push	011f9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1622             ControlEnable(hwndDlg,DID_OEM_ALGO,FALSE);
	push	0h
	push	0132h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1623             }
@BLBL285:

; 1624           break;
	jmp	@BLBL368
	align 04h
@BLBL380:

; 1625         case RB_TYPEPCI:
; 1626           if (Checked(hwndDlg,RB_TYPEPCI))
	push	01232h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL286

; 1627             {
; 1628             GetPCIadapterName(szPCIname, byOEMtype);
	mov	al,[ebp-01h];	byOEMtype
	push	eax
	lea	eax,[ebp-066h];	szPCIname
	push	eax
	call	GetPCIadapterName
	add	esp,08h

; 1629             WinSetDlgItemText(hwndDlg,ST_PCIADAPTERNAME,szPCIname);
	lea	eax,[ebp-066h];	szPCIname
	push	eax
	push	0289bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 1630             WinShowWindow(WinWindowFromID(hwndDlg,ST_PCIADAPTERNAME),TRUE);
	push	0289bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	01h
	push	eax
	call	WinShowWindow
	add	esp,08h

; 1631 //            CheckButton(hwndDlg,RB_TYPEPCI,TRUE);
; 1632             ControlEnable(hwndDlg,PCFG_BASE_ADDR,FALSE);
	push	0h
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1633             ControlEnable(hwndDlg,PCFG_DISP_CHEX,FALSE);
	push	0h
	push	012e5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1634             ControlEnable(hwndDlg,PCFG_DISP_DEC,FALSE);
	push	0h
	push	012e7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1635             ControlEnable(hwndDlg,GB_INTERRUPTSTATUSIDADDRESS,FALSE);
	push	0h
	push	0288fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1636             ControlEnable(hwndDlg,GB_ENTRYBASE,FALSE);
	push	0h
	push	02898h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1637             ControlEnable(hwndDlg,PCFG_INT_LEVEL,FALSE);
	push	0h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1638             ControlEnable(hwndDlg,PCFG_INT_LEVELT,FALSE);
	push	0h
	push	011f9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1639             ControlEnable(hwndDlg,DID_OEM_ALGO,FALSE);
	push	0h
	push	0132h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 1640             }
@BLBL286:

; 1641           break;
	jmp	@BLBL368
	align 04h
	jmp	@BLBL368
	align 04h
@BLBL369:
	cmp	eax,012e5h
	je	@BLBL370
	cmp	eax,012e7h
	je	@BLBL371
	cmp	eax,0122bh
	je	@BLBL372
	cmp	eax,0122ch
	je	@BLBL373
	cmp	eax,0122dh
	je	@BLBL374
	cmp	eax,0122eh
	je	@BLBL375
	cmp	eax,0122fh
	je	@BLBL376
	cmp	eax,01230h
	je	@BLBL377
	cmp	eax,01231h
	je	@BLBL378
	cmp	eax,0122ah
	je	@BLBL379
	cmp	eax,01232h
	je	@BLBL380
@BLBL368:

; 1642         }
; 1643       return((MRESULT)TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL287
	align 04h
@BLBL288:
	cmp	eax,03bh
	je	@BLBL289
	cmp	eax,020h
	je	@BLBL313
	cmp	eax,030h
	je	@BLBL367
@BLBL287:

; 1644     }
; 1645   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
fnwpPortOEMconfigDlgProc	endp

; 1649   {
	align 010h

GetPCIadapterName	proc
	push	ebp
	mov	ebp,esp
	sub	esp,04h
	mov	dword ptr [esp],0aaaaaaaah
	sub	esp,08h

; 1650   int iMaxPorts = 0;
	mov	dword ptr [ebp-04h],0h;	iMaxPorts

; 1651 
; 1652   switch (stGlobalCFGheader.wPCIvendor)
	xor	eax,eax
	mov	ax,word ptr  stGlobalCFGheader+01eh
	jmp	@BLBL416
	align 04h
@BLBL417:

; 1653     {
; 1654     case PCI_VENDOR_MOXA:
; 1655       if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL381

; 1656         if (byOEMtype == OEM_GLOBETEK)
	cmp	byte ptr [ebp+0ch],08h;	byOEMtype
	jne	@BLBL382

; 1657           strcpy(szPCIname,"Globetek model ");
	mov	edx,offset FLAT:@STAT33
	mov	eax,[ebp+08h];	szPCIname
	call	strcpy
	jmp	@BLBL381
	align 010h
@BLBL382:

; 1658         else
; 1659           strcpy(szPCIname,"Moxa model ");
	mov	edx,offset FLAT:@STAT34
	mov	eax,[ebp+08h];	szPCIname
	call	strcpy
@BLBL381:

; 1660       switch (stGlobalCFGheader.wPCIdevice)
	xor	eax,eax
	mov	ax,word ptr  stGlobalCFGheader+020h
	jmp	@BLBL419
	align 04h
@BLBL420:

; 1661         {
; 1662         case PCI_DEVICE_MX_C104H:
; 1663           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL384

; 1664             strcat(szPCIname, "C104H, four port");
	mov	edx,offset FLAT:@STAT35
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL384:

; 1665           iMaxPorts = 4;
	mov	dword ptr [ebp-04h],04h;	iMaxPorts

; 1666           break;
	jmp	@BLBL418
	align 04h
@BLBL421:

; 1667         case PCI_DEVICE_MX_C168H:
; 1668           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL385

; 1669             strcat(szPCIname, "C168H, eight port");
	mov	edx,offset FLAT:@STAT36
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL385:

; 1670           iMaxPorts = 8;
	mov	dword ptr [ebp-04h],08h;	iMaxPorts

; 1671           break;
	jmp	@BLBL418
	align 04h
	jmp	@BLBL418
	align 04h
@BLBL419:
	cmp	eax,01040h
	je	@BLBL420
	cmp	eax,01680h
	je	@BLBL421
@BLBL418:

; 1672         }
; 1673       break;
	jmp	@BLBL415
	align 04h
@BLBL422:

; 1674     case PCI_VENDOR_3COM:
; 1675 //      if (szPCIname != NULL)
; 1676 //        strcpy(szPCIname,"3COM ");
; 1677       switch (stGlobalCFGheader.wPCIdevice)
	xor	eax,eax
	mov	ax,word ptr  stGlobalCFGheader+020h
	jmp	@BLBL424
	align 04h
@BLBL425:
@BLBL426:

; 1678         {
; 1679         default:
; 1680         case PCI_DEVICE_3COM_MODEM:
; 1681           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL386

; 1682             strcpy(szPCIname, "U.S.Robotics PCI modem");
	mov	edx,offset FLAT:@STAT37
	mov	eax,[ebp+08h];	szPCIname
	call	strcpy
@BLBL386:

; 1683           iMaxPorts = 1;
	mov	dword ptr [ebp-04h],01h;	iMaxPorts

; 1684           break;
	jmp	@BLBL423
	align 04h
	jmp	@BLBL423
	align 04h
@BLBL424:
	cmp	eax,01008h
	je	@BLBL426
	jmp	@BLBL425
	align 04h
@BLBL423:

; 1685         }
; 1686       break;
	jmp	@BLBL415
	align 04h
@BLBL427:

; 1687     case PCI_VENDOR_GLOBETEK:
; 1688       if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL387

; 1689         strcpy(szPCIname,"Globetek model ");
	mov	edx,offset FLAT:@STAT38
	mov	eax,[ebp+08h];	szPCIname
	call	strcpy
@BLBL387:

; 1690       switch (stGlobalCFGheader.wPCIdevice)
	xor	eax,eax
	mov	ax,word ptr  stGlobalCFGheader+020h
	jmp	@BLBL429
	align 04h
@BLBL430:

; 1691         {
; 1692         case PCI_DEVICE_GT_1002:
; 1693           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL388

; 1694             strcat(szPCIname, "1002, two port");
	mov	edx,offset FLAT:@STAT39
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL388:

; 1695           iMaxPorts = 2;
	mov	dword ptr [ebp-04h],02h;	iMaxPorts

; 1696           break;
	jmp	@BLBL428
	align 04h
@BLBL431:

; 1697         case PCI_DEVICE_GT_1004:
; 1698           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL389

; 1699             strcat(szPCIname, "1004, four port");
	mov	edx,offset FLAT:@STAT3a
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL389:

; 1700           iMaxPorts = 4;
	mov	dword ptr [ebp-04h],04h;	iMaxPorts

; 1701           break;
	jmp	@BLBL428
	align 04h
@BLBL432:

; 1702         case PCI_DEVICE_GT_1008:
; 1703           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL390

; 1704             strcat(szPCIname, "1008, eight port");
	mov	edx,offset FLAT:@STAT3b
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL390:

; 1705           iMaxPorts = 8;
	mov	dword ptr [ebp-04h],08h;	iMaxPorts

; 1706           break;
	jmp	@BLBL428
	align 04h
	jmp	@BLBL428
	align 04h
@BLBL429:
	cmp	eax,01002h
	je	@BLBL430
	cmp	eax,01004h
	je	@BLBL431
	cmp	eax,01008h
	je	@BLBL432
@BLBL428:

; 1707         }
; 1708       break;
	jmp	@BLBL415
	align 04h
@BLBL433:

; 1709     case PCI_VENDOR_SEALEVEL:
; 1710       if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL391

; 1711         strcpy(szPCIname,"Sealevel model ");
	mov	edx,offset FLAT:@STAT3c
	mov	eax,[ebp+08h];	szPCIname
	call	strcpy
@BLBL391:

; 1712       switch (stGlobalCFGheader.wPCIdevice)
	xor	eax,eax
	mov	ax,word ptr  stGlobalCFGheader+020h
	jmp	@BLBL435
	align 04h
@BLBL436:

; 1713         {
; 1714         case PCI_DEVICE_SL_7101:
; 1715           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL392

; 1716             strcat(szPCIname,"7101, one port");
	mov	edx,offset FLAT:@STAT3d
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL392:

; 1717           iMaxPorts = 1;
	mov	dword ptr [ebp-04h],01h;	iMaxPorts

; 1718           break;
	jmp	@BLBL434
	align 04h
@BLBL437:

; 1719         case PCI_DEVICE_SL_7102:
; 1720           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL393

; 1721             strcat(szPCIname,"7102, one port");
	mov	edx,offset FLAT:@STAT3e
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL393:

; 1722           iMaxPorts = 1;
	mov	dword ptr [ebp-04h],01h;	iMaxPorts

; 1723           break;
	jmp	@BLBL434
	align 04h
@BLBL438:

; 1724         case PCI_DEVICE_SL_7103:
; 1725           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL394

; 1726             strcat(szPCIname,"7103, one port");
	mov	edx,offset FLAT:@STAT3f
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL394:

; 1727           iMaxPorts = 1;
	mov	dword ptr [ebp-04h],01h;	iMaxPorts

; 1728           break;
	jmp	@BLBL434
	align 04h
@BLBL439:

; 1729         case PCI_DEVICE_SL_7104:
; 1730           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL395

; 1731             strcat(szPCIname,"7104, one port");
	mov	edx,offset FLAT:@STAT40
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL395:

; 1732           iMaxPorts = 1;
	mov	dword ptr [ebp-04h],01h;	iMaxPorts

; 1733           break;
	jmp	@BLBL434
	align 04h
@BLBL440:

; 1734         case PCI_DEVICE_SL_7105:
; 1735           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL396

; 1736             strcat(szPCIname,"7105, one port");
	mov	edx,offset FLAT:@STAT41
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL396:

; 1737           iMaxPorts = 1;
	mov	dword ptr [ebp-04h],01h;	iMaxPorts

; 1738           break;
	jmp	@BLBL434
	align 04h
@BLBL441:

; 1739         case PCI_DEVICE_SL_7201:
; 1740           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL397

; 1741             strcat(szPCIname,"7201, two port");
	mov	edx,offset FLAT:@STAT42
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL397:

; 1742           iMaxPorts = 2;
	mov	dword ptr [ebp-04h],02h;	iMaxPorts

; 1743           break;
	jmp	@BLBL434
	align 04h
@BLBL442:

; 1744         case PCI_DEVICE_SL_7202:
; 1745           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL398

; 1746             strcat(szPCIname,"7202, two port");
	mov	edx,offset FLAT:@STAT43
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL398:

; 1747           iMaxPorts = 2;
	mov	dword ptr [ebp-04h],02h;	iMaxPorts

; 1748           break;
	jmp	@BLBL434
	align 04h
@BLBL443:

; 1749         case PCI_DEVICE_SL_7203:
; 1750           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL399

; 1751             strcat(szPCIname,"7203, two port");
	mov	edx,offset FLAT:@STAT44
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL399:

; 1752           iMaxPorts = 2;
	mov	dword ptr [ebp-04h],02h;	iMaxPorts

; 1753           break;
	jmp	@BLBL434
	align 04h
@BLBL444:

; 1754         case PCI_DEVICE_SL_7901:
; 1755           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL400

; 1756             strcat(szPCIname,"7901, two port");
	mov	edx,offset FLAT:@STAT45
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL400:

; 1757           iMaxPorts = 2;
	mov	dword ptr [ebp-04h],02h;	iMaxPorts

; 1758           break;
	jmp	@BLBL434
	align 04h
@BLBL445:

; 1759         case PCI_DEVICE_SL_7903:
; 1760           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL401

; 1761             strcat(szPCIname,"7903, two port");
	mov	edx,offset FLAT:@STAT46
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL401:

; 1762           iMaxPorts = 2;
	mov	dword ptr [ebp-04h],02h;	iMaxPorts

; 1763           break;
	jmp	@BLBL434
	align 04h
@BLBL446:

; 1764         case PCI_DEVICE_SL_7401:
; 1765           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL402

; 1766             strcat(szPCIname,"7401, four port");
	mov	edx,offset FLAT:@STAT47
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL402:

; 1767           iMaxPorts = 4;
	mov	dword ptr [ebp-04h],04h;	iMaxPorts

; 1768           break;
	jmp	@BLBL434
	align 04h
@BLBL447:

; 1769         case PCI_DEVICE_SL_7402:
; 1770           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL403

; 1771             strcat(szPCIname,"7402, four port");
	mov	edx,offset FLAT:@STAT48
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL403:

; 1772           iMaxPorts = 4;
	mov	dword ptr [ebp-04h],04h;	iMaxPorts

; 1773           break;
	jmp	@BLBL434
	align 04h
@BLBL448:

; 1774         case PCI_DEVICE_SL_7404:
; 1775           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL404

; 1776             strcat(szPCIname,"7404, four port");
	mov	edx,offset FLAT:@STAT49
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL404:

; 1777           iMaxPorts = 4;
	mov	dword ptr [ebp-04h],04h;	iMaxPorts

; 1778           break;
	jmp	@BLBL434
	align 04h
@BLBL449:

; 1779         case PCI_DEVICE_SL_7405:
; 1780           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL405

; 1781             strcat(szPCIname,"7405, four port");
	mov	edx,offset FLAT:@STAT4a
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL405:

; 1782           iMaxPorts = 4;
	mov	dword ptr [ebp-04h],04h;	iMaxPorts

; 1783           break;
	jmp	@BLBL434
	align 04h
@BLBL450:

; 1784         case PCI_DEVICE_SL_7904:
; 1785           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL406

; 1786             strcat(szPCIname,"7904, four port");
	mov	edx,offset FLAT:@STAT4b
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL406:

; 1787           iMaxPorts = 4;
	mov	dword ptr [ebp-04h],04h;	iMaxPorts

; 1788           break;
	jmp	@BLBL434
	align 04h
@BLBL451:

; 1789         case PCI_DEVICE_SL_7801:
; 1790           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL407

; 1791             strcat(szPCIname,"7801, eight port");
	mov	edx,offset FLAT:@STAT4c
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL407:

; 1792           iMaxPorts = 8;
	mov	dword ptr [ebp-04h],08h;	iMaxPorts

; 1793           break;
	jmp	@BLBL434
	align 04h
@BLBL452:

; 1794         case PCI_DEVICE_SL_7905:
; 1795           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL408

; 1796             strcat(szPCIname,"7905, eight port");
	mov	edx,offset FLAT:@STAT4d
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL408:

; 1797           iMaxPorts = 8;
	mov	dword ptr [ebp-04h],08h;	iMaxPorts

; 1798           break;
	jmp	@BLBL434
	align 04h
	jmp	@BLBL434
	align 04h
@BLBL435:
	cmp	eax,07101h
	je	@BLBL436
	cmp	eax,07102h
	je	@BLBL437
	cmp	eax,07103h
	je	@BLBL438
	cmp	eax,07104h
	je	@BLBL439
	cmp	eax,07105h
	je	@BLBL440
	cmp	eax,07201h
	je	@BLBL441
	cmp	eax,07202h
	je	@BLBL442
	cmp	eax,07203h
	je	@BLBL443
	cmp	eax,07901h
	je	@BLBL444
	cmp	eax,07903h
	je	@BLBL445
	cmp	eax,07401h
	je	@BLBL446
	cmp	eax,07402h
	je	@BLBL447
	cmp	eax,07404h
	je	@BLBL448
	cmp	eax,07405h
	je	@BLBL449
	cmp	eax,07904h
	je	@BLBL450
	cmp	eax,07801h
	je	@BLBL451
	cmp	eax,07905h
	je	@BLBL452
@BLBL434:

; 1799         }
; 1800       break;
	jmp	@BLBL415
	align 04h
@BLBL453:

; 1801     case PCI_VENDOR_CONNECTECH:
; 1802       if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL409

; 1803         strcpy(szPCIname,"Blue Heat model ");
	mov	edx,offset FLAT:@STAT4e
	mov	eax,[ebp+08h];	szPCIname
	call	strcpy
@BLBL409:

; 1804       switch (stGlobalCFGheader.wPCIdevice)
	xor	eax,eax
	mov	ax,word ptr  stGlobalCFGheader+020h
	jmp	@BLBL455
	align 04h
@BLBL456:

; 1805         {
; 1806         case PCI_DEVICE_BH_V960:
; 1807           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL410

; 1808             strcat(szPCIname, "V960");
	mov	edx,offset FLAT:@STAT4f
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL410:

; 1809           iMaxPorts = 8;
	mov	dword ptr [ebp-04h],08h;	iMaxPorts

; 1810           break;
	jmp	@BLBL454
	align 04h
@BLBL457:

; 1811         case PCI_DEVICE_BH_V961:
; 1812           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL411

; 1813             strcat(szPCIname, "V961, eight port");
	mov	edx,offset FLAT:@STAT50
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL411:

; 1814           iMaxPorts = 8;
	mov	dword ptr [ebp-04h],08h;	iMaxPorts

; 1815           break;
	jmp	@BLBL454
	align 04h
@BLBL458:

; 1816         case P
; 1816 CI_DEVICE_BH_V962:
; 1817           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL412

; 1818             strcat(szPCIname, "V962");
	mov	edx,offset FLAT:@STAT51
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL412:

; 1819           iMaxPorts = 8;
	mov	dword ptr [ebp-04h],08h;	iMaxPorts

; 1820           break;
	jmp	@BLBL454
	align 04h
@BLBL459:

; 1821         case PCI_DEVICE_BH_V292:
; 1822           if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL413

; 1823             strcat(szPCIname, "V292");
	mov	edx,offset FLAT:@STAT52
	mov	eax,[ebp+08h];	szPCIname
	call	strcat
@BLBL413:

; 1824           iMaxPorts = 8;
	mov	dword ptr [ebp-04h],08h;	iMaxPorts

; 1825           break;
	jmp	@BLBL454
	align 04h
	jmp	@BLBL454
	align 04h
@BLBL455:
	cmp	eax,01h
	je	@BLBL456
	cmp	eax,02h
	je	@BLBL457
	cmp	eax,04h
	je	@BLBL458
	cmp	eax,010h
	je	@BLBL459
@BLBL454:

; 1826         }
; 1827       break;
	jmp	@BLBL415
	align 04h
@BLBL460:

; 1828     default:
; 1829       if (szPCIname != NULL)
	cmp	dword ptr [ebp+08h],0h;	szPCIname
	je	@BLBL414

; 1830         strcpy(szPCIname,"Undetermined PCI adapter model");
	mov	edx,offset FLAT:@STAT53
	mov	eax,[ebp+08h];	szPCIname
	call	strcpy
@BLBL414:

; 1831       iMaxPorts = 8;
	mov	dword ptr [ebp-04h],08h;	iMaxPorts

; 1832       break;
	jmp	@BLBL415
	align 04h
	jmp	@BLBL415
	align 04h
@BLBL416:
	cmp	eax,01393h
	je	@BLBL417
	cmp	eax,012b9h
	je	@BLBL422
	cmp	eax,0151ah
	je	@BLBL427
	cmp	eax,0135eh
	je	@BLBL433
	cmp	eax,011b0h
	je	@BLBL453
	jmp	@BLBL460
	align 04h
@BLBL415:

; 1833     }
; 1834   return(iMaxPorts);
	mov	eax,[ebp-04h];	iMaxPorts
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
GetPCIadapterName	endp

; 1838   {
	align 010h

	public fnwpOEMIntAlgorithimDlgProc
fnwpOEMIntAlgorithimDlgProc	proc
	push	ebp
	mov	ebp,esp

; 1841   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL467
	align 04h
@BLBL468:

; 1842     {
; 1843     case WM_INITDLG:
; 1844       CenterDlgBox(hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	call	CenterDlgBox
	add	esp,04h

; 1845       WinSetFocus(HWND_DESKTOP,hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinSetFocus
	add	esp,08h

; 1846       pstCOMiCFG = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @133pstCOMiCFG,eax

; 1847       switch (pstCOMiCFG->usValue)
	mov	ecx,dword ptr  @133pstCOMiCFG
	xor	eax,eax
	mov	ax,[ecx+03dh]
	jmp	@BLBL470
	align 04h
@BLBL471:

; 1848         {
; 1849         case ALGO_POLL:
; 1850           CheckButton(hwndDlg,PCFG_ALGO_POLL,TRUE);
	push	01h
	push	01202h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1851           break;
	jmp	@BLBL469
	align 04h
@BLBL472:

; 1852         case ALGO_SELECT:
; 1853           CheckButton(hwndDlg,PCFG_ALGO_SELECT,TRUE);
	push	01h
	push	01203h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1854           break;
	jmp	@BLBL469
	align 04h
@BLBL473:

; 1855         case ALGO_HYBRID:
; 1856           CheckButton(hwndDlg,PCFG_ALGO_HYBRID,TRUE);
	push	01h
	push	01204h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 1857           break;
	jmp	@BLBL469
	align 04h
	jmp	@BLBL469
	align 04h
@BLBL470:
	test	eax,eax
	je	@BLBL471
	cmp	eax,01h
	je	@BLBL472
	cmp	eax,02h
	je	@BLBL473
@BLBL469:

; 1858         }
; 1859       break;
	jmp	@BLBL466
	align 04h
@BLBL474:

; 1860     case WM_COMMAND:
; 1861       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL476
	align 04h
@BLBL477:

; 1862         {
; 1863         case DID_HELP:
; 1864           DisplayHelpPanel(pstCOMiCFG,HLPP_OEM_ALGO_DLG);
	push	0c519h
	push	dword ptr  @133pstCOMiCFG
	call	DisplayHelpPanel
	add	esp,08h

; 1865           return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL478:

; 1866         case DID_OK:
; 1867           if (Checked(hwndDlg,PCFG_ALGO_POLL))
	push	01202h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL461

; 1868             pstCOMiCFG->usValue = ALGO_POLL;
	mov	eax,dword ptr  @133pstCOMiCFG
	mov	word ptr [eax+03dh],0h
	jmp	@BLBL462
	align 010h
@BLBL461:

; 1869           else
; 1870             if (Checked(hwndDlg,PCFG_ALGO_SELECT))
	push	01203h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL463

; 1871               pstCOMiCFG->usValue = ALGO_SELECT;
	mov	eax,dword ptr  @133pstCOMiCFG
	mov	word ptr [eax+03dh],01h
	jmp	@BLBL462
	align 010h
@BLBL463:

; 1872             else
; 1873               if (Checked(hwndDlg,PCFG_ALGO_HYBRID))
	push	01204h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL462

; 1874                 pstCOMiCFG->usValue = ALGO_HYBRID;
	mov	eax,dword ptr  @133pstCOMiCFG
	mov	word ptr [eax+03dh],02h
@BLBL462:

; 1875           WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 1876           return(MRESULT)TRUE;
	mov	eax,01h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL479:

; 1877         case DID_CANCEL:
; 1878           WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 1879           break;
	jmp	@BLBL475
	align 04h
@BLBL480:

; 1880         default:
; 1881           return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDefDlgProc
	add	esp,010h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL475
	align 04h
@BLBL476:
	cmp	eax,012dh
	je	@BLBL477
	cmp	eax,01h
	je	@BLBL478
	cmp	eax,02h
	je	@BLBL479
	jmp	@BLBL480
	align 04h
@BLBL475:

; 1882         }
; 1883       return((MRESULT)FALSE);
	xor	eax,eax
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL466
	align 04h
@BLBL467:
	cmp	eax,03bh
	je	@BLBL468
	cmp	eax,020h
	je	@BLBL474
@BLBL466:

; 1884     }
; 1885   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDefDlgProc
	add	esp,010h
	mov	esp,ebp
	pop	ebp
	ret	
fnwpOEMIntAlgorithimDlgProc	endp

; 1889   {
	align 010h

	public fnwpPortSelectDlg
fnwpPortSelectDlg	proc
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

; 1899   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL495
	align 04h
@BLBL496:

; 1900     {
; 1901     case WM_INITDLG:
; 1902       CenterDlgBox(hwnd);
	push	dword ptr [ebp+08h];	hwnd
	call	CenterDlgBox
	add	esp,04h

; 1903       pstCOMiCFG = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @139pstCOMiCFG,eax

; 1904       if ((pDeviceList = (char *)malloc(1000)) == NULL)
	mov	ecx,0770h
	mov	edx,offset FLAT:@STAT54
	mov	eax,03e8h
	call	_debug_malloc
	mov	[ebp-01ch],eax;	pDeviceList
	cmp	dword ptr [ebp-01ch],0h;	pDeviceList
	jne	@BLBL481

; 1905         {
; 1906         WinDismissDlg(hwnd,NO_MEMORY_AVAIL);
	push	06h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 1907         return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL481:

; 1908         }
; 1909       pstCOMiCFG->pDeviceList = pDeviceList;
	mov	eax,dword ptr  @139pstCOMiCFG
	mov	ecx,[ebp-01ch];	pDeviceList
	mov	[eax+029h],ecx

; 1910       pstCOMiCFG->cbDevList = 1000;
	mov	eax,dword ptr  @139pstCOMiCFG
	mov	dword ptr [eax+02dh],03e8h

; 1911       iDeviceCount = FillDeviceNameList(pstCOMiCFG);
	push	dword ptr  @139pstCOMiCFG
	call	FillDeviceNameList
	add	esp,04h
	mov	dword ptr  iDeviceCount,eax

; 1912       pstCOMiCFG->cbDevList = 0;
	mov	eax,dword ptr  @139pstCOMiCFG
	mov	dword ptr [eax+02dh],0h

; 1913       if (iDeviceCount == 0)
	cmp	dword ptr  iDeviceCount,0h
	jne	@BLBL482

; 1914         {
; 1915         free(pDeviceList);
	mov	ecx,077bh
	mov	edx,offset FLAT:@STAT55
	mov	eax,[ebp-01ch];	pDeviceList
	call	_debug_free

; 1916         pstCOMiCFG->pDeviceList = NULL;
	mov	eax,dword ptr  @139pstCOMiCFG
	mov	dword ptr [eax+029h],0h

; 1917         WinDismissDlg(hwnd,NO_PORT_AVAILABLE);
	push	04h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 1918         return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL482:

; 1919         }
; 1920       bItemSelected = TRUE;
	mov	dword ptr [ebp-0ch],01h;	bItemSelected

; 1921       iCOMindex = 0;
	mov	dword ptr [ebp-010h],0h;	iCOMindex

; 1922       if (pstCOMiCFG->bEnumCOMscope)
	mov	eax,dword ptr  @139pstCOMiCFG
	test	byte ptr [eax+04bh],08h
	je	@BLBL483

; 1923         {
; 1924         if (pstCOMiCFG->bPortActive)
	mov	eax,dword ptr  @139pstCOMiCFG
	test	byte ptr [eax+04bh],020h
	je	@BLBL483

; 1925           {
; 1926           iFirstItem = atoi(&pDeviceList[3]);
	mov	eax,[ebp-01ch];	pDeviceList
	add	eax,03h
	call	atoi
	mov	[ebp-018h],eax;	iFirstItem

; 1927           iCOMindex = atoi(&pstCOMiCFG->pszPortName[3]);
	mov	eax,dword ptr  @139pstCOMiCFG
	mov	eax,[eax+014h]
	add	eax,03h
	call	atoi
	mov	[ebp-010h],eax;	iCOMindex

; 1928           bItemSelected = FALSE;
	mov	dword ptr [ebp-0ch],0h;	bItemSelected

; 1929           }

; 1930         }
@BLBL483:

; 1931       iIndex = 0;
	mov	dword ptr [ebp-04h],0h;	iIndex

; 1932       for (iIndex = 0;iIndex < iDeviceCount;iIndex++)
	mov	dword ptr [ebp-04h],0h;	iIndex
	mov	eax,dword ptr  iDeviceCount
	cmp	[ebp-04h],eax;	iIndex
	jge	@BLBL485
	align 010h
@BLBL486:

; 1933         {
; 1934         WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(pDeviceList));
	push	dword ptr [ebp-01ch];	pDeviceList
	push	0ffffh
	push	0161h
	push	0130ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 1935         if (!bItemSelected)
	cmp	dword ptr [ebp-0ch],0h;	bItemSelected
	jne	@BLBL487

; 1936           {
; 1937           iTempIndex = atoi(&pDeviceList[3]);
	mov	eax,[ebp-01ch];	pDeviceList
	add	eax,03h
	call	atoi
	mov	[ebp-014h],eax;	iTempIndex

; 1938           if ((iTempIndex + 1) == iCOMindex)
	mov	eax,[ebp-014h];	iTempIndex
	inc	eax
	cmp	[ebp-010h],eax;	iCOMindex
	jne	@BLBL487

; 1939             {
; 1940             WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(pstCOMiCFG->pszPortName));
	mov	eax,dword ptr  @139pstCOMiCFG
	push	dword ptr [eax+014h]
	push	0ffffh
	push	0161h
	push	0130ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 1941             bItemSelected = TRUE;
	mov	dword ptr [ebp-0ch],01h;	bItemSelected

; 1942             iCOMindex = (iIndex + 1);
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-010h],eax;	iCOMindex

; 1943             }

; 1944           }
@BLBL487:

; 1945         pDeviceList = &pDeviceList[strlen(pDeviceList) + 1];
	mov	eax,[ebp-01ch];	pDeviceList
	call	strlen
	mov	ecx,eax
	mov	eax,[ebp-01ch];	pDeviceList
	add	eax,ecx
	inc	eax
	mov	[ebp-01ch],eax;	pDeviceList

; 1946         }

; 1932       for (iIndex = 0;iIndex < iDeviceCount;iIndex++)
	mov	eax,[ebp-04h];	iIndex
	inc	eax
	mov	[ebp-04h],eax;	iIndex
	mov	eax,dword ptr  iDeviceCount
	cmp	[ebp-04h],eax;	iIndex
	jl	@BLBL486
@BLBL485:

; 1947       free(pstCOMiCFG->pDeviceList);
	mov	ecx,079bh
	mov	edx,offset FLAT:@STAT56
	mov	eax,dword ptr  @139pstCOMiCFG
	mov	eax,[eax+029h]
	call	_debug_free

; 1948       pstCOMiCFG->pDeviceList = NULL;
	mov	eax,dword ptr  @139pstCOMiCFG
	mov	dword ptr [eax+029h],0h

; 1949       if (bItemSelected)
	cmp	dword ptr [ebp-0ch],0h;	bItemSelected
	je	@BLBL490

; 1950         WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_SELECTITEM,MPFROMSHORT(iCOMindex),MPFROMSHORT(TRUE));
	push	01h
	mov	ax,[ebp-010h];	iCOMindex
	and	eax,0ffffh
	push	eax
	push	0164h
	push	0130ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h
	jmp	@BLBL491
	align 010h
@BLBL490:

; 1952         if (iCOMindex < iFirstItem)
	mov	eax,[ebp-018h];	iFirstItem
	cmp	[ebp-010h],eax;	iCOMindex
	jge	@BLBL492

; 1954           WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_INSERTITEM,MPFROMSHORT(0),MPFROMP(pstCOMiCFG->pszPortName));
	mov	eax,dword ptr  @139pstCOMiCFG
	push	dword ptr [eax+014h]
	push	0h
	push	0161h
	push	0130ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 1955           WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_SELECTITEM,MPFROMSHORT(0),MPFROMSHORT(TRUE));
	push	01h
	push	0h
	push	0164h
	push	0130ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 1956           }
	jmp	@BLBL491
	align 010h
@BLBL492:

; 1959           WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_INSERTITEM,MPFROMSHORT(LIT_END),MPFROMP(pstCOMiCFG->pszPortName));
	mov	eax,dword ptr  @139pstCOMiCFG
	push	dword ptr [eax+014h]
	push	0ffffh
	push	0161h
	push	0130ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 1960           WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_SELECTITEM,MPFROMSHORT(iIndex),MPFROMSHORT(TRUE));
	push	01h
	mov	ax,[ebp-04h];	iIndex
	and	eax,0ffffh
	push	eax
	push	0164h
	push	0130ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 1961           }
@BLBL491:

; 1962       break;
	jmp	@BLBL494
	align 04h
@BLBL497:

; 1964       switch(SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL499
	align 04h
@BLBL500:

; 1967           iItemSelected = (SHORT)WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_QUERYSELECTION,0L,0L);
	push	0h
	push	0h
	push	0165h
	push	0130ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h
	movsx	eax,ax
	mov	[ebp-08h],eax;	iItemSelected

; 1968           WinSendDlgItemMsg(hwnd,PCFG_NAME_LIST,LM_QUERYITEMTEXT,MPFROM2SHORT(iItemSelected,9),MPFROMP(pstCOMiCFG->pszPortName));
	mov	eax,dword ptr  @139pstCOMiCFG
	push	dword ptr [eax+014h]
	mov	ax,[ebp-08h];	iItemSelected
	and	eax,0ffffh
	or	eax,090000h
	push	eax
	push	0168h
	push	0130ah
	push	dword ptr [ebp+08h];	hwnd
	call	WinSendDlgItemMsg
	add	esp,014h

; 1969           WinDismissDlg(hwnd,PORT_SELECTED);
	push	03h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 1970           break;
	jmp	@BLBL498
	align 04h
@BLBL501:

; 1972           WinDismissDlg(hwnd,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwnd
	call	WinDismissDlg
	add	esp,08h

; 1973           break;
	jmp	@BLBL498
	align 04h
@BLBL502:

; 1975           return WinDefDlgProc(hwnd,msg,mp1,mp2);
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefDlgProc
	add	esp,01ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL498
	align 04h
@BLBL499:
	cmp	eax,01h
	je	@BLBL500
	cmp	eax,02h
	je	@BLBL501
	jmp	@BLBL502
	align 04h
@BLBL498:

; 1977       break;
	jmp	@BLBL494
	align 04h
@BLBL503:

; 1979       return(WinDefDlgProc(hwnd,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwnd
	call	WinDefDlgProc
	add	esp,01ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL494
	align 04h
@BLBL495:
	cmp	eax,03bh
	je	@BLBL496
	cmp	eax,020h
	je	@BLBL497
	jmp	@BLBL503
	align 04h
@BLBL494:

; 1981   return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
fnwpPortSelectDlg	endp

; 1985   {
	align 010h

	public fnwpPortSimpleDlgProc
fnwpPortSimpleDlgProc	proc
	push	ebp
	mov	ebp,esp
	sub	esp,080h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,020h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 1998   BOOL bOkToEditConfigSYS = FALSE;
	mov	dword ptr [ebp-078h],0h;	bOkToEditConfigSYS

; 1999   USHORT usButton;
; 2000   static ulButtonOnCount;
; 2001   int iDefIndex;
; 2002   static BOOL bPCIselected = FALSE;
; 2003   static USHORT usVendorID;
; 2004   static USHORT usDeviceID;
; 2005 
; 2006   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL574
	align 04h
@BLBL575:

; 2007     {
; 2008     case WM_INITDLG:
; 2009       CenterDlgBox(hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	call	CenterDlgBox
	add	esp,04h

; 2010       WinSetFocus(HWND_DESKTOP,hwndDlg);
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinSetFocus
	add	esp,08h

; 2011       pstCOMiCFG = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @14dpstCOMiCFG,eax

; 2012       ulButtonOnCount = 0;
	mov	dword ptr  @15aulButtonOnCount,0h

; 2013       if (pstCOMiCFG->pszDriverIniSpec != NULL)
	mov	eax,dword ptr  @14dpstCOMiCFG
	cmp	dword ptr [eax+018h],0h
	je	@BLBL504

; 2014         strcpy(szDriverIniSpec,pstCOMiCFG->pszDriverIniSpec);
	mov	edx,dword ptr  @14dpstCOMiCFG
	mov	edx,[edx+018h]
	mov	eax,offset FLAT:@152szDriverIniSpec
	call	strcpy
	jmp	@BLBL505
	align 010h
@BLBL504:

; 2015       else
; 2016         strcpy(szDriverIniSpec,szDriverIniPath);
	mov	edx,offset FLAT:szDriverIniPath
	mov	eax,offset FLAT:@152szDriverIniSpec
	call	strcpy
@BLBL505:

; 2017       if (pstCOMiCFG->ulMaxDeviceCount != 1)
	mov	eax,dword ptr  @14dpstCOMiCFG
	cmp	dword ptr [eax+025h],01h
	je	@BLBL506

; 2018         {
; 2019         WinShowWindow(WinWindowFromID(hwndDlg,DID_ADVANCED),TRUE);
	push	0133h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	01h
	push	eax
	call	WinShowWindow
	add	esp,08h

; 2020         ControlEnable(hwndDlg,DID_ADVANCED,TRUE);
	push	01h
	push	0133h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 2021         }
@BLBL506:

; 2022       stHeaderPos.wLoadNumber = 1;
	mov	word ptr [ebp-06ch],01h;	stHeaderPos

; 2023       stHeaderPos.wDCBnumber = 1;
	mov	word ptr [ebp-06ah],01h;	stHeaderPos

; 2024       QueryIniCFGheader(szDriverIniPath,&stCFGheader,&stHeaderPos);
	lea	eax,[ebp-06ch];	stHeaderPos
	push	eax
	push	offset FLAT:@154stCFGheader
	push	offset FLAT:szDriverIniPath
	call	QueryIniCFGheader
	add	esp,0ch

; 2025       usVendorID = stCFGheader.wPCIvendor;
	mov	ax,word ptr  @154stCFGheader+01eh
	mov	word ptr  @15dusVendorID,ax

; 2026       usDeviceID = stCFGheader.wPCIdevice;
	mov	ax,word ptr  @154stCFGheader+020h
	mov	word ptr  @15eusDeviceID,ax

; 2027       if (fIsMCAmachine)
	cmp	word ptr  fIsMCAmachine,0h
	je	@BLBL507

; 2028         {
; 2029         pstDeviceDef = &astMCAdeviceDefinition[0];
	mov	dword ptr  @14fpstDeviceDef,offset FLAT:astMCAdeviceDefinition

; 2030         iDeviceCount = 8;
	mov	dword ptr  @151iDeviceCount,08h

; 2031         }
	jmp	@BLBL508
	align 010h
@BLBL507:

; 2032       else
; 2033         if (bPCImachine)
	cmp	dword ptr  bPCImachine,0h
	je	@BLBL509

; 2034           {
; 2035           WinShowWindow(WinWindowFromID(hwndDlg,DID_SELECTADAPTER),TRUE);
	push	0136h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	01h
	push	eax
	call	WinShowWindow
	add	esp,08h

; 2036           ControlEnable(hwndDlg,DID_SELECTADAPTER,TRUE);
	push	01h
	push	0136h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 2037           if ((stCFGheader.byAdapterType == HDWTYPE_PCI) || (stCFGheader.wDeviceCount == 0))
	cmp	byte ptr  @154stCFGheader+0ah,09h
	je	@BLBL510
	cmp	word ptr  @154stCFGheader,0h
	jne	@BLBL511
@BLBL510:

; 2038             {
; 2039             pstDeviceDef = &astPCIdeviceDefinition[0];
	mov	dword ptr  @14fpstDeviceDef,offset FLAT:astPCIdeviceDefinition

; 2040             iDeviceCount = 8;
	mov	dword ptr  @151iDeviceCount,08h

; 2041             bPCIselected = TRUE;
	mov	dword ptr  @15cbPCIselected,01h

; 2042             }
	jmp	@BLBL508
	align 010h
@BLBL511:

; 2043           else
; 2044             {
; 2045             pstDeviceDef = &astISAdeviceDefinition[0];
	mov	dword ptr  @14fpstDeviceDef,offset FLAT:astISAdeviceDefinition

; 2046             iDeviceCount = 4;
	mov	dword ptr  @151iDeviceCount,04h

; 2047             bPCIselected = FALSE;
	mov	dword ptr  @15cbPCIselected,0h

; 2048             ControlEnable(hwndDlg,DEV_COM5,FALSE);
	push	0h
	push	01775h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 2049             ControlEnable(hwndDlg,DEV_COM6,FALSE);
	push	0h
	push	01776h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 2050             ControlEnable(hwndDlg,DEV_COM7,FALSE);
	push	0h
	push	01777h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 2051             ControlEnable(hwndDlg,DEV_COM8,FALSE);
	push	0h
	push	01778h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 2052             WinSetDlgItemText(hwndDlg,DID_SELECTADAPTER,"Use ISA ports");
	push	offset FLAT:@STAT57
	push	0136h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 2053             }

; 2054           }
	jmp	@BLBL508
	align 010h
@BLBL509:

; 2055         else
; 2056           {
; 2057           pstDeviceDef = &astISAdeviceDefinition[0];
	mov	dword ptr  @14fpstDeviceDef,offset FLAT:astISAdeviceDefinition

; 2058           iDeviceCount = 4;
	mov	dword ptr  @151iDeviceCount,04h

; 2059           }
@BLBL508:

; 2060       for (iIndex = 0;iIndex < 8;iIndex++)
	mov	dword ptr [ebp-070h],0h;	iIndex
	cmp	dword ptr [ebp-070h],08h;	iIndex
	jge	@BLBL514
	align 010h
@BLBL515:

; 2061         {
; 2062         if (QueryIniDCBheader(szDriverIniPath,&stCFGheader,&stDCBheader,&stHeaderPos))
	lea	eax,[ebp-06ch];	stHeaderPos
	push	eax
	push	offset FLAT:@155stDCBheader
	push	offset FLAT:@154stCFGheader
	push	offset FLAT:szDriverIniPath
	call	QueryIniDCBheader
	add	esp,010h
	test	eax,eax
	je	@BLBL516

; 2063           {
; 2064           if (strlen(stDCBheader.abyPortName) != 0)
	mov	eax,offset FLAT:@155stDCBheader
	call	strlen
	test	eax,eax
	je	@BLBL516

; 2065             {
; 2066             RemoveSpaces(stDCBheader.abyPortName);
	push	offset FLAT:@155stDCBheader
	call	RemoveSpaces
	add	esp,04h

; 2067             for (iDefIndex = 0;iDefIndex < iDeviceCount;iDefIndex++)
	mov	dword ptr [ebp-080h],0h;	iDefIndex
	mov	eax,dword ptr  @151iDeviceCount
	cmp	[ebp-080h],eax;	iDefIndex
	jge	@BLBL518
	align 010h
@BLBL519:

; 2068               {
; 2069               if (strcmp(stDCBheade
; 2069 r.abyPortName,pstDeviceDef[iDefIndex].szName) == 0)
	mov	edx,dword ptr  @14fpstDeviceDef
	mov	eax,[ebp-080h];	iDefIndex
	imul	eax,0ch
	add	edx,eax
	mov	eax,offset FLAT:@155stDCBheader
	call	strcmp
	test	eax,eax
	je	@BLBL518

; 2070                 break;
; 2071               }

; 2067             for (iDefIndex = 0;iDefIndex < iDeviceCount;iDefIndex++)
	mov	eax,[ebp-080h];	iDefIndex
	inc	eax
	mov	[ebp-080h],eax;	iDefIndex
	mov	eax,dword ptr  @151iDeviceCount
	cmp	[ebp-080h],eax;	iDefIndex
	jl	@BLBL519
@BLBL518:

; 2072             if (iDefIndex < iDeviceCount)
	mov	eax,dword ptr  @151iDeviceCount
	cmp	[ebp-080h],eax;	iDefIndex
	jge	@BLBL516

; 2074               if (bPCImachine)
	cmp	dword ptr  bPCImachine,0h
	je	@BLBL523

; 2076                 astPCIdeviceDefinition[iDefIndex].byInterruptLevel = stDCBheader.stComDCB.byInterruptLevel;
	mov	eax,[ebp-080h];	iDefIndex
	imul	eax,0ch
	mov	cl,byte ptr  @155stDCBheader+030h
	mov	byte ptr [eax+ astPCIdeviceDefinition+0bh],cl

; 2077                 astPCIdeviceDefinition[iDefIndex].wAddress = stDCBheader.stComDCB.wIObaseAddress;
	mov	eax,[ebp-080h];	iDefIndex
	imul	eax,0ch
	mov	cx,word ptr  @155stDCBheader+016h
	mov	word ptr [eax+ astPCIdeviceDefinition+09h],cx

; 2078                 }
@BLBL523:

; 2079               CheckButton(hwndDlg,(DEV_COM1 + iDefIndex),TRUE);
	push	01h
	mov	eax,[ebp-080h];	iDefIndex
	add	eax,01771h
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 2080               if (pstCOMiCFG->ulMaxDeviceCount != 0)
	mov	eax,dword ptr  @14dpstCOMiCFG
	cmp	dword ptr [eax+025h],0h
	je	@BLBL516

; 2081                 if (++ulButtonOnCount >= pstCOMiCFG->ulMaxDeviceCount)
	mov	eax,dword ptr  @15aulButtonOnCount
	inc	eax
	mov	dword ptr  @15aulButtonOnCount,eax
	mov	eax,dword ptr  @14dpstCOMiCFG
	mov	ecx,dword ptr  @15aulButtonOnCount
	cmp	[eax+025h],ecx
	jbe	@BLBL514

; 2083               }

; 2084             }

; 2085           }
@BLBL516:

; 2086         stHeaderPos.wDCBnumber++;
	mov	ax,[ebp-06ah];	stHeaderPos
	inc	ax
	mov	[ebp-06ah],ax;	stHeaderPos

; 2087         }

; 2060       for (iIndex = 0;iIndex < 8;iIndex++)
	mov	eax,[ebp-070h];	iIndex
	inc	eax
	mov	[ebp-070h],eax;	iIndex
	cmp	dword ptr [ebp-070h],08h;	iIndex
	jl	@BLBL515
@BLBL514:

; 2088       szMessage[0] = 0;  
	mov	byte ptr [ebp-064h],0h;	szMessage

; 2089       if (bPCIselected && pstCOMiCFG->byOEMtype != OEM_OTHER)
	cmp	dword ptr  @15cbPCIselected,0h
	je	@BLBL527
	mov	eax,dword ptr  @14dpstCOMiCFG
	cmp	byte ptr [eax+024h],0h
	je	@BLBL527

; 2090         GetPCIadapterName(szMessage, pstCOMiCFG->byOEMtype);
	mov	eax,dword ptr  @14dpstCOMiCFG
	mov	al,[eax+024h]
	push	eax
	lea	eax,[ebp-064h];	szMessage
	push	eax
	call	GetPCIadapterName
	add	esp,08h
	jmp	@BLBL528
	align 010h
@BLBL527:

; 2092         if ((pstCOMiCFG->ulMaxDeviceCount != 0) && (pstCOMiCFG->ulMaxDeviceCount < iDeviceCount))
	mov	eax,dword ptr  @14dpstCOMiCFG
	cmp	dword ptr [eax+025h],0h
	je	@BLBL528
	mov	ecx,dword ptr  @151iDeviceCount
	mov	eax,dword ptr  @14dpstCOMiCFG
	cmp	[eax+025h],ecx
	jae	@BLBL528

; 2094           if (pstCOMiCFG->ulMaxDeviceCount == 1)
	mov	eax,dword ptr  @14dpstCOMiCFG
	cmp	dword ptr [eax+025h],01h
	jne	@BLBL530

; 2095             if (bPCImachine)
	cmp	dword ptr  bPCImachine,0h
	je	@BLBL531

; 2096               sprintf(szMessage,"Select one PCI device");
	mov	edx,offset FLAT:@STAT58
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee
	jmp	@BLBL528
	align 010h
@BLBL531:

; 2098               sprintf(szMessage,"Select one standard device");
	mov	edx,offset FLAT:@STAT59
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee
	jmp	@BLBL528
	align 010h
@BLBL530:

; 2100             if (bPCImachine)
	cmp	dword ptr  bPCImachine,0h
	je	@BLBL534

; 2101               sprintf(szMessage,"Select up to %s PCI devices",aszOrdinals[pstCOMiCFG->ulMaxDeviceCount]);
	mov	eax,dword ptr  @14dpstCOMiCFG
	mov	eax,[eax+025h]
	push	dword ptr [eax*04h+@2aszOrdinals]
	mov	edx,offset FLAT:@STAT5a
	lea	eax,[ebp-064h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	jmp	@BLBL528
	align 010h
@BLBL534:

; 2103               sprintf(szMessage,"Select up to %s standard devices",aszOrdinals[pstCOMiCFG->ulMaxDeviceCount]);
	mov	eax,dword ptr  @14dpstCOMiCFG
	mov	eax,[eax+025h]
	push	dword ptr [eax*04h+@2aszOrdinals]
	mov	edx,offset FLAT:@STAT5b
	lea	eax,[ebp-064h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 2104           }
@BLBL528:

; 2105       if (strlen(szMessage) != 0)
	lea	eax,[ebp-064h];	szMessage
	call	strlen
	test	eax,eax
	je	@BLBL536

; 2106         WinSetDlgItemText(hwndDlg,DEV_MAX,szMessage);
	lea	eax,[ebp-064h];	szMessage
	push	eax
	push	0138fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL536:

; 2107       return (MRESULT) TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL576:

; 2109       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL578
	align 04h
@BLBL579:

; 2112           DosDelete(szDriverIniPath);
	push	offset FLAT:szDriverIniPath
	call	DosDelete
	add	esp,04h

; 2113           stHeaderPos.wLoadNumber = 1;
	mov	word ptr [ebp-06ch],01h;	stHeaderPos

; 2114           stHeaderPos.wDCBnumber = 1;
	mov	word ptr [ebp-06ah],01h;	stHeaderPos

; 2115           InitializeCFGheader(&stCFGheader);
	push	offset FLAT:@154stCFGheader
	call	InitializeCFGheader
	add	esp,04h

; 2116           iDevices = 0;
	mov	dword ptr [ebp-068h],0h;	iDevices

; 2117           for (iIndex = 0;iIndex < iDeviceCount;iIndex++)
	mov	dword ptr [ebp-070h],0h;	iIndex
	mov	eax,dword ptr  @151iDeviceCount
	cmp	[ebp-070h],eax;	iIndex
	jge	@BLBL537
	align 010h
@BLBL538:

; 2118             if (Checked(hwndDlg,(iIndex + DEV_COM1)))
	mov	eax,[ebp-070h];	iIndex
	add	eax,01771h
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL539

; 2120               InitializeDCBheader(&stDCBheader,pstCOMiCFG->bInstallCOMscope);
	mov	eax,dword ptr  @14dpstCOMiCFG
	mov	al,[eax+04bh]
	and	eax,03h
	shr	eax,01h
	push	eax
	push	offset FLAT:@155stDCBheader
	call	InitializeDCBheader
	add	esp,08h

; 2121               strcpy(stDCBheader.abyPortName,pstDeviceDef[iIndex].szName);
	mov	edx,dword ptr  @14fpstDeviceDef
	mov	eax,[ebp-070h];	iIndex
	imul	eax,0ch
	add	edx,eax
	mov	eax,offset FLAT:@155stDCBheader
	call	strcpy

; 2122               MakeDeviceName(stDCBheader.abyPortName);
	push	offset FLAT:@155stDCBheader
	call	MakeDeviceName
	add	esp,04h

; 2123               stDCBheader.stComDCB.byInterruptLevel = pstDeviceDef[iIndex].byInterruptLevel;
	mov	eax,dword ptr  @14fpstDeviceDef
	mov	ecx,[ebp-070h];	iIndex
	imul	ecx,0ch
	mov	al,byte ptr [eax+ecx+0bh]
	mov	byte ptr  @155stDCBheader+030h,al

; 2124               stDCBheader.stComDCB.wIObaseAddress = pstDeviceDef[iIndex].wAddress;
	mov	eax,dword ptr  @14fpstDeviceDef
	mov	ecx,[ebp-070h];	iIndex
	imul	ecx,0ch
	mov	ax,word ptr [eax+ecx+09h]
	mov	word ptr  @155stDCBheader+016h,ax

; 2125               PlaceIniDCBheader(szDriverIniPath,&stCFGheader,&stDCBheader,&stHeaderPos);
	lea	eax,[ebp-06ch];	stHeaderPos
	push	eax
	push	offset FLAT:@155stDCBheader
	push	offset FLAT:@154stCFGheader
	push	offset FLAT:szDriverIniPath
	call	PlaceIniDCBheader
	add	esp,010h

; 2126               iDevices++;
	mov	eax,[ebp-068h];	iDevices
	inc	eax
	mov	[ebp-068h],eax;	iDevices

; 2127               stHeaderPos.wDCBnumber++;
	mov	ax,[ebp-06ah];	stHeaderPos
	inc	ax
	mov	[ebp-06ah],ax;	stHeaderPos

; 2128              }
@BLBL539:

; 2117           for (iIndex = 0;iIndex < iDeviceCount;iIndex++)
	mov	eax,[ebp-070h];	iIndex
	inc	eax
	mov	[ebp-070h],eax;	iIndex
	mov	eax,dword ptr  @151iDeviceCount
	cmp	[ebp-070h],eax;	iIndex
	jl	@BLBL538
@BLBL537:

; 2129           stCFGheader.wDeviceCount = (WORD)iDevices;
	mov	eax,[ebp-068h];	iDevices
	mov	word ptr  @154stCFGheader,ax

; 2130           if (bPCIselected)
	cmp	dword ptr  @15cbPCIselected,0h
	je	@BLBL541

; 2131             stCFGheader.byAdapterType = HDWTYPE_PCI;
	mov	byte ptr  @154stCFGheader+0ah,09h
	jmp	@BLBL542
	align 010h
@BLBL541:

; 2133             stCFGheader.byAdapterType = 0;
	mov	byte ptr  @154stCFGheader+0ah,0h
@BLBL542:

; 2134           stCFGheader.wPCIvendor = usVendorID;
	mov	ax,word ptr  @15dusVendorID
	mov	word ptr  @154stCFGheader+01eh,ax

; 2135           stCFGheader.wPCIdevice = usDeviceID;
	mov	ax,word ptr  @15eusDeviceID
	mov	word ptr  @154stCFGheader+020h,ax

; 2136           stCFGheader.byPCIslot = 0;
	mov	byte ptr  @154stCFGheader+022h,0h

; 2137           PlaceIniCFGheader(szDriverIniPath,&stCFGheader,&stHeaderPos);
	lea	eax,[ebp-06ch];	stHeaderPos
	push	eax
	push	offset FLAT:@154stCFGheader
	push	offset FLAT:szDriverIniPath
	call	PlaceIniCFGheader
	add	esp,0ch

; 2138           if (pstCOMiCFG->pszRemoveOldDriverSpec != NULL)
	mov	eax,dword ptr  @14dpstCOMiCFG
	cmp	dword ptr [eax+01ch],0h
	je	@BLBL543

; 2139             bOkToEditConfigSYS = CleanConfigSys(hwndDlg,pstCOMiCFG->pszRemoveOldDriverSpec,HLPP_MB_CONFIGSYS,TRUE);
	push	01h
	push	09ca5h
	mov	eax,dword ptr  @14dpstCOMiCFG
	push	dword ptr [eax+01ch]
	push	dword ptr [ebp+08h];	hwndDlg
	call	CleanConfigSys
	add	esp,010h
	mov	[ebp-078h],eax;	bOkToEditConfigSYS
@BLBL543:

; 2140           if (stHeaderPos.wDCBnumber != 0)
	cmp	word ptr [ebp-06ah],0h;	stHeaderPos
	je	@BLBL544

; 2142             strncpy(szListString,szDriverIniSpec,(strlen(szDriverIniSpec) - 4));
	mov	eax,offset FLAT:@152szDriverIniSpec
	call	strlen
	sub	eax,04h
	mov	ecx,eax
	mov	edx,offset FLAT:@152szDriverIniSpec
	mov	eax,offset FLAT:szListString
	call	strncpy

; 2143             szListString[strlen(szDriverIniSpec) - 4] = 0;
	mov	eax,offset FLAT:@152szDriverIniSpec
	call	strlen
	mov	byte ptr [eax+ szListString-04h],0h

; 2144             AdjustConfigSys(hwndDlg,szListString,1,bOkToEditConfigSYS,HLPP_MB_CONFIGSYS);
	push	09ca5h
	push	dword ptr [ebp-078h];	bOkToEditConfigSYS
	push	01h
	push	offset FLAT:szListString
	push	dword ptr [ebp+08h];	hwndDlg
	call	AdjustConfigSys
	add	esp,014h

; 2145             }
@BLBL544:

; 2146           WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 2147           return(MRESULT)TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL580:

; 2149           szMessage[0] = 0;
	mov	byte ptr [ebp-064h],0h;	szMessage

; 2150           if (!bPCIselected)
	cmp	dword ptr  @15cbPCIselected,0h
	jne	@BLBL545

; 2152             bPCIselected = TRUE;
	mov	dword ptr  @15cbPCIselected,01h

; 2153             pstDeviceDef = &astPCIdeviceDefinition[0];
	mov	dword ptr  @14fpstDeviceDef,offset FLAT:astPCIdeviceDefinition

; 2154             iDeviceCount = 8;
	mov	dword ptr  @151iDeviceCount,08h

; 2155             ControlEnable(hwndDlg,DEV_COM5,TRUE);
	push	01h
	push	01775h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 2156             ControlEnable(hwndDlg,DEV_COM6,TRUE);
	push	01h
	push	01776h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 2157             ControlEnable(hwndDlg,DEV_COM7,TRUE);
	push	01h
	push	01777h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 2158             ControlEnable(hwndDlg,DEV_COM8,TRUE);
	push	01h
	push	01778h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 2159             WinSetDlgItemText(hwndDlg,DID_SELECTADAPTER,"Use ISA ports");
	push	offset FLAT:@STAT5c
	push	0136h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 2160             if (pstCOMiCFG->byOEMtype != OEM_OTHER)
	mov	eax,dword ptr  @14dpstCOMiCFG
	cmp	byte ptr [eax+024h],0h
	je	@BLBL547

; 2161               GetPCIadapterName(szMessage, pstCOMiCFG->byOEMtype);
	mov	eax,dword ptr  @14dpstCOMiCFG
	mov	al,[eax+024h]
	push	eax
	lea	eax,[ebp-064h];	szMessage
	push	eax
	call	GetPCIadapterName
	add	esp,08h

; 2162             }
	jmp	@BLBL547
	align 010h
@BLBL545:

; 2165             pstDeviceDef = &astISAdeviceDefinition[0];
	mov	dword ptr  @14fpstDeviceDef,offset FLAT:astISAdeviceDefinition

; 2166             iDeviceCount = 4;
	mov	dword ptr  @151iDeviceCount,04h

; 2167             bPCIselected = FALSE;
	mov	dword ptr  @15cbPCIselected,0h

; 2168             ControlEnable(hwndDlg,DEV_COM5,FALSE);
	push	0h
	push	01775h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 2169             ControlEnable(hwndDlg,DEV_COM6,FALSE);
	push	0h
	push	01776h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 2170             ControlEnable(hwndDlg,DEV_COM7,FALSE);
	push	0h
	push	01777h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 2171             ControlEnable(hwndDlg,DEV_COM8,FALSE);
	push	0h
	push	01778h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 2172             WinSetDlgItemText(hwndDlg,DID_SELECTADAPTER,"Use PCI adapter");
	push	offset FLAT:@STAT5d
	push	0136h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 2173             }
@BLBL547:

; 2174           if ((pstCOMiCFG->ulMaxDeviceCount != 0) && (pstCOMiCFG->ulMaxDeviceCount < iDeviceCount))
	mov	eax,dword ptr  @14dpstCOMiCFG
	cmp	dword ptr [eax+025h],0h
	je	@BLBL548
	mov	ecx,dword ptr  @151iDeviceCount
	mov	eax,dword ptr  @14dpstCOMiCFG
	cmp	[eax+025h],ecx
	jae	@BLBL548

; 2176             if (pstCOMiCFG->ulMaxDeviceCount == 1)
	mov	eax,dword ptr  @14dpstCOMiCFG
	cmp	dword ptr [eax+025h],01h
	jne	@BLBL549

; 2178               if (bPCImachine)
	cmp	dword ptr  bPCImachine,0h
	je	@BLBL550

; 2179                 sprintf(szMessage,"Select one PCI device");
	mov	edx,offset FLAT:@STAT5e
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee
	jmp	@BLBL548
	align 010h
@BLBL550:

; 2181                 sprintf(szMessage,"Select one standard device");
	mov	edx,offset FLAT:@STAT5f
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 2182               }
	jmp	@BLBL548
	align 010h
@BLBL549:

; 2185               if (bPCImachine)
	cmp	dword ptr  bPCImachine,0h
	je	@BLBL553

; 2186                 sprintf(szMessage,"Select up to %s PCI devices",aszOrdinals[pstCOMiCFG->ulMaxDeviceCount]);
	mov	eax,dword ptr  @14dpstCOMiCFG
	mov	eax,[eax+025h]
	push	dword ptr [eax*04h+@2aszOrdinals]
	mov	edx,offset FLAT:@STAT60
	lea	eax,[ebp-064h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	jmp	@BLBL548
	align 010h
@BLBL553:

; 2188                 sprintf(szMessage,"Select up to %s standard devices",aszOrdinals[pstCOMiCFG->ulMaxDeviceCount]);
	mov	eax,dword ptr  @14dpstCOMiCFG
	mov	eax,[eax+025h]
	push	dword ptr [eax*04h+@2aszOrdinals]
	mov	edx,offset FLAT:@STAT61
	lea	eax,[ebp-064h];	szMessage
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 2189               }

; 2190             }
@BLBL548:

; 2191           WinSetDlgItemText(hwndDlg,DEV_MAX,szMessage);
	lea	eax,[ebp-064h];	szMessage
	push	eax
	push	0138fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 2192           return(MRESULT)TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL581:

; 2194           DosDelete(szDriverIniPath);
	push	offset FLAT:szDriverIniPath
	call	DosDelete
	add	esp,04h

; 2195           stHeaderPos.wLoadNumber = 1;
	mov	word ptr [ebp-06ch],01h;	stHeaderPos

; 2196           InitializeCFGheader(&stCFGheader);
	push	offset FLAT:@154stCFGheader
	call	InitializeCFGheader
	add	esp,04h

; 2198           if (bPCIselected)
	cmp	dword ptr  @15cbPCIselected,0h
	je	@BLBL555

; 2199             stCFGheader.byAdapterType = HDWTYPE_PCI;
	mov	byte ptr  @154stCFGheader+0ah,09h
@BLBL555:

; 2200           stCFGheader.wPCIvendor = usVendorID;
	mov	ax,word ptr  @15dusVendorID
	mov	word ptr  @154stCFGheader+01eh,ax

; 2201           stCFGheader.wPCIdevice = usDeviceID;
	mov	ax,word ptr  @15eusDeviceID
	mov	word ptr  @154stCFGheader+020h,ax

; 2202           for (iIndex = 0;iIndex < iDeviceCount;iIndex++)
	mov	dword ptr [ebp-070h],0h;	iIndex
	mov	eax,dword ptr  @151iDeviceCount
	cmp	[ebp-070h],eax;	iIndex
	jge	@BLBL556
	align 010h
@BLBL557:

; 2203             if (Checked(hwndDlg,(iIndex + DEV_COM1)))
	mov	eax,[ebp-070h];	iIndex
	add	eax,01771h
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL558

; 2205               stHeaderPos.wDCBnumber = 0;   // use next available DCB header
	mov	word ptr [ebp-06ah],0h;	stHeaderPos

; 2206               InitializeDCBheader(&stDCBheader,pstCOMiCFG->bInstallCOMscope);
	mov	eax,dword ptr  @14dpstCOMiCFG
	mov	al,[eax+04bh]
	and	eax,03h
	shr	eax,01h
	push	eax
	push	offset FLAT:@155stDCBheader
	call	InitializeDCBheader
	add	esp,08h

; 2207               strcpy(stDCBheader.abyPortName,pstDeviceDef[iIndex].szName);
	mov	edx,dword ptr  @14fpstDeviceDef
	mov	eax,[ebp-070h];	iIndex
	imul	eax,0ch
	add	edx,eax
	mov	eax,offset FLAT:@155stDCBheader
	call	strcpy

; 2208               MakeDeviceName(stDCBheader.abyPortName);
	push	offset FLAT:@155stDCBheader
	call	MakeDeviceName
	add	esp,04h

; 2209               stDCBheader.stComDCB.byInterruptLevel = pstDeviceDef[iIndex].byInterruptLevel;
	mov	eax,dword ptr  @14fpstDeviceDef
	mov	ecx,[ebp-070h];	iIndex
	imul	ecx,0ch
	mov	al,byte ptr [eax+ecx+0bh]
	mov	byte ptr  @155stDCBheader+030h,al

; 2210               stDCBheader.stComDCB.wIObaseAddress = pstDeviceDef[iIndex].wAddress;
	mov	eax,dword ptr  @14fpstDeviceDef
	mov	ecx,[ebp-070h];	iIndex
	imul	ecx,0ch
	mov	ax,word ptr [eax+ecx+09h]
	mov	word ptr  @155stDCBheader+016h,ax

; 2211               PlaceIniDCBheader(szDriverIniPath,&stCFGheader,&stDCBheader,&stHeaderPos);
	lea	eax,[ebp-06ch];	stHeaderPos
	push	eax
	push	offset FLAT:@155stDCBheader
	push	offset FLAT:@154stCFGheader
	push	offset FLAT:szDriverIniPath
	call	PlaceIniDCBheader
	add	esp,010h

; 2212               }
@BLBL558:

; 2202           for (iIndex = 0;iIndex < iDeviceCount;iIndex++)
	mov	eax,[ebp-070h];	iIndex
	inc	eax
	mov	[ebp-070h],eax;	iIndex
	mov	eax,dword ptr  @151iDeviceCount
	cmp	[ebp-070h],eax;	iIndex
	jl	@BLBL557
@BLBL556:

; 2213           if (pstCOMiCFG->byOEMtype != OEM_OTHER)
	mov	eax,dword ptr  @14dpstCOMiCFG
	cmp	byte ptr [eax+024h],0h
	je	@BLBL560

; 2214             idDlg = DLG_ADVANCEDOEM;
	mov	word ptr [ebp-072h],02cdbh;	idDlg
	jmp	@BLBL561
	align 010h
@BLBL560:

; 2216             if (fIsMCAmachine)
	cmp	word ptr  fIsMCAmachine,0h
	je	@BLBL562

; 2217               idDlg = PCFG_MAIN_MCA;
	mov	word ptr [ebp-072h],01205h;	idDlg
	jmp	@BLBL561
	align 010h
@BLBL562:

; 2219               idDlg = PCFG_MAIN;
	mov	word ptr [ebp-072h],012c9h;	idDlg
@BLBL561:

; 2221           WinDismissDlg(hwndDlg,TRUE);
	push	01h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 2223           if (WinDlgBox(HWND_DESKTOP,
	push	dword ptr  @14dpstCOMiCFG
	xor	eax,eax
	mov	ax,[ebp-072h];	idDlg
	push	eax
	mov	eax,dword ptr  hThisModule
	push	eax
	push	offset FLAT: fnwpPortConfigDlgProc
	mov	eax,dword ptr  @14dpstCOMiCFG
	push	dword ptr [eax+06h]
	push	01h
	call	WinDlgBox
	add	esp,018h
	test	eax,eax
	je	@BLBL564

; 2230           return(MRESULT)TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL564:
@BLBL582:

; 2232           DisplayHelpPanel(pstCOMiCFG,HLPP_SIMPLE_CFG_DLG);
	push	07594h
	push	dword ptr  @14dpstCOMiCFG
	call	DisplayHelpPanel
	add	esp,08h

; 2233           return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL583:

; 2235           WinDismissDlg(hwndDlg,FALSE);
	push	0h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDismissDlg
	add	esp,08h

; 2236           break;
	jmp	@BLBL577
	align 04h
@BLBL584:

; 2238           return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
	jmp	@BLBL577
	align 04h
@BLBL578:
	cmp	eax,01h
	je	@BLBL579
	cmp	eax,0136h
	je	@BLBL580
	cmp	eax,0133h
	je	@BLBL581
	cmp	eax,012dh
	je	@BLBL582
	cmp	eax,02h
	je	@BLBL583
	jmp	@BLBL584
	align 04h
@BLBL577:

; 2240       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL585:

; 2242       if (SHORT2FROMMP(mp1) == BN_CLICKED)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL565

; 2244         usButton = SHORT1FROMMP(mp1);
	mov	eax,[ebp+010h];	mp1
	mov	[ebp-07ah],ax;	usButton

; 2245         if ((usButton >= DEV_COM1) && (usButton <= DEV_COM8))
	mov	ax,[ebp-07ah];	usButton
	cmp	ax,01771h
	jb	@BLBL565
	mov	ax,[ebp-07ah];	usButton
	cmp	ax,01778h
	ja	@BLBL565

; 2247           if (!Checked(hwndDlg,usButton))
	mov	ax,[ebp-07ah];	usButton
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	jne	@BLBL567

; 2249             if (pstCOMiCFG->ulMaxDeviceCount != 0)
	mov	eax,dword ptr  @14dpstCOMiCFG
	cmp	dword ptr [eax+025h],0h
	je	@BLBL568

; 2251               if (ulButtonOnCount < pstCOMiCFG->ulMaxDeviceCount)
	mov	eax,dword ptr  @14dpstCOMiCFG
	mov	ecx,dword ptr  @15aulButtonOnCount
	cmp	[eax+025h],ecx
	jbe	@BLBL565

; 2253                 ulButtonOnCount++;
	mov	eax,dword ptr  @15aulButtonOnCount
	inc	eax
	mov	dword ptr  @15aulButtonOnCount,eax

; 2254                 CheckButton(hwndDlg,usButton,TRUE);
	push	01h
	mov	ax,[ebp-07ah];	usButton
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 2255                 }

; 2256               }
	jmp	@BLBL565
	align 010h
@BLBL568:

; 2258               CheckButton(hwndDlg,usButton,TRUE);
	push	01h
	mov	ax,[ebp-07ah];	usButton
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 2259             }
	jmp	@BLBL565
	align 010h
@BLBL567:

; 2262             if (pstCOMiCFG->ulMaxDeviceCount != 0)
	mov	eax,dword ptr  @14dpstCOMiCFG
	cmp	dword ptr [eax+025h],0h
	je	@BLBL572

; 2263           
; 2263     ulButtonOnCount--;
	mov	eax,dword ptr  @15aulButtonOnCount
	dec	eax
	mov	dword ptr  @15aulButtonOnCount,eax
@BLBL572:

; 2264             CheckButton(hwndDlg,usButton,FALSE);
	push	0h
	mov	ax,[ebp-07ah];	usButton
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 2265             }

; 2266           }

; 2267         }
@BLBL565:

; 2268       return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL573
	align 04h
@BLBL574:
	cmp	eax,03bh
	je	@BLBL575
	cmp	eax,020h
	je	@BLBL576
	cmp	eax,030h
	je	@BLBL585
@BLBL573:

; 2270   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
fnwpPortSimpleDlgProc	endp

; 2274   {
	align 010h

	public PortSelectDialog
PortSelectDialog	proc
	push	ebp
	mov	ebp,esp

; 2275   return (WinDlgBox(HWND_DESKTOP,hwnd,(PFNWP)fnwpPortSelectDlg,hThisModule,PS_DLG,MPFROMP(pstCOMiCFG)));
	push	dword ptr [ebp+0ch];	pstCOMiCFG
	push	01f4h
	mov	eax,dword ptr  hThisModule
	push	eax
	push	offset FLAT: fnwpPortSelectDlg
	push	dword ptr [ebp+08h];	hwnd
	push	01h
	call	WinDlgBox
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
PortSelectDialog	endp
CODE32	ends
end
