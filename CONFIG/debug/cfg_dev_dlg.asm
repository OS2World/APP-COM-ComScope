	title	p:\config\cfg_dev_dlg.c
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
	public	szDeviceDescriptionFormat
	public	szPCIdeviceDescriptionFormat
	public	szInitDeviceDescription
	extrn	_dllentry:proc
	extrn	WinSetDlgItemText:proc
	extrn	WinSetWindowText:proc
	extrn	FillDeviceDialogNameListBox:proc
	extrn	WinSendDlgItemMsg:proc
	extrn	GetNextAvailableAddress:proc
	extrn	MessageBox:proc
	extrn	WinPostMsg:proc
	extrn	_sprintfieee:proc
	extrn	CheckButton:proc
	extrn	GetNextAvailableInterrupt:proc
	extrn	ControlEnable:proc
	extrn	PrfQueryProfileString:proc
	extrn	strcmp:proc
	extrn	WinWindowFromID:proc
	extrn	WinSetFocus:proc
	extrn	WinQueryDlgItemText:proc
	extrn	ASCIItoBin:proc
	extrn	atoi:proc
	extrn	FindListWordItem:proc
	extrn	FindListByteItem:proc
	extrn	AddListItem:proc
	extrn	RemoveListItem:proc
	extrn	strcpy:proc
	extrn	RemoveSpaces:proc
	extrn	Checked:proc
	extrn	_itoa:proc
	extrn	WinDefDlgProc:proc
	extrn	WinMessageBox:proc
	extrn	_fullDump:dword
	extrn	bInsertNewDevice:dword
	extrn	hwndNoteBookDlg:dword
	extrn	szCurrentConfigDeviceName:byte
	extrn	wLastAddress:word
	extrn	byLastIntLevel:byte
	extrn	fIsMCAmachine:word
	extrn	szPDRlibrarySpec:byte
	extrn	pAddressList:dword
	extrn	pLoadInterruptList:dword
	extrn	pInterruptList:dword
	extrn	pLoadAddressList:dword
	extrn	szLastName:byte
	extrn	astConfigDeviceList:byte
	extrn	pSpoolList:dword
	extrn	bShareAccessWarning:dword
	extrn	bNonExAccessWarning:dword
DATA32	segment
@STAT1	db "S~ave",0h
	align 04h
@STAT2	db "There are no I/O address"
db " blocks available.",0ah,0ah,"You "
db "will have to delete a de"
db "vice to free up an addre"
db "ss block.",0h
@STAT3	db "%u",0h
@STAT4	db "%X",0h
@STAT5	db "There are no more interr"
db "upts available.",0ah,0ah,"You wil"
db "l have to remove one or "
db "more devices to free up "
db "an interrupt.",0h
	align 04h
@STAT6	db "This device is part of P"
db "CI PnP adapter",0h
	align 04h
@STAT7	db "PM_%s",0h
	align 04h
@STAT8	db "PORTDRIVER",0h
	align 04h
@STAT9	db "COMI_SPL;",0h
	align 04h
@STATa	db "A device address space m"
db "ust start on an eight by"
db "te boundry (e.g., 300h, "
db "3228h).  Please enter a "
db "different base address.",0h
@STATb	db "%X",0h
	align 04h
@STATc	db "Device at address %Xh is"
db " already defined.  Pleas"
db "e address a different de"
db "vice.",0h
	align 04h
@STATd	db "Device at address %u is "
db "already defined.  Please"
db " address a different dev"
db "ice.",0h
@STATe	db "%X",0h
@STATf	db "Interrupt Level %u is al"
db "ready taken.  Please sel"
db "ect a different Interrup"
db "t.",0h
	align 04h
@STAT10	db "Interrupt Level %u is al"
db "ready taken.  Please sel"
db "ect a different Interrup"
db "t.",0h
	align 04h
@STAT11	db "A device address space m"
db "ust start on an eight by"
db "te boundry (e.g., 300h, "
db "3228h).  Please enter a "
db "different base address.",0h
@STAT12	db "%X",0h
	align 04h
@STAT13	db "Device at address %Xh is"
db " already defined.  Pleas"
db "e address a different de"
db "vice.",0h
	align 04h
@STAT14	db "Device at address %u is "
db "already defined.  Please"
db " address a different dev"
db "ice.",0h
@STAT15	db "%X",0h
@STAT16	db "Interrupt Level %u is al"
db "ready taken.  Please sel"
db "ect a different Interrup"
db "t.",0h
	align 04h
@STAT17	db "Interrupt Level %u is al"
db "ready taken.  Please sel"
db "ect a different Interrup"
db "t.",0h
@STAT18	db "%X",0h
	align 04h
@STAT19	db "S~ave",0h
	align 04h
@STAT1a	db "Shared Interrupt Connect"
db "ion Selected!",0h
	align 04h
@STAT1b	db "More than one device con"
db "nected to an interrupt l"
db "evel can cause unpredict"
db "able results!",0h
	align 04h
@STAT1c	db "Non-Exclusive Access Sel"
db "ected!",0h
	align 04h
@STAT1d	db "Giving more than one dev"
db "ice access to an interru"
db "pt level can cause unpre"
db "dictable results!",0h
szInitDeviceDescription	db "COMi Device Configuratio"
db "n",0h
	dd	_dllentry
DATA32	ends
CONST32_RO	segment
szDeviceDescriptionFormat	db "Configuring %s at base a"
db "ddress 0x%X, IRQ %u",0h
szPCIdeviceDescriptionFormat	db "Configuring %s in PCI Pn"
db "P adapter",0h
CONST32_RO	ends
BSS32	segment
@11fDisplayBase	db 0h
	align 04h
@19bPCIadapter	dd 0h
comm	szDeviceDescription:byte:03dh
@bbAllowClick	dd 0h
@cszAppName	db 028h DUP (0h)
@dbSpoolEnabled	dd 0h
@epstPage	dd 0h
@fpstCFGheader	dd 0h
@10pstDCBheader	dd 0h
@12wOldAddress	dw 0h
@13byIntLevel	db 0h
	align 04h
@14pstCOMiCFG	dd 0h
@15bAddressNotAdded	dd 0h
@16bCOMscopeEnabled	dd 0h
@17iOrgItemSelected	dd 0h
@18wAddress	dw 0h
	align 04h
@74bAllowClick	dd 0h
@75pstCFGheader	dd 0h
@76wConfigFlags1	dw 0h
@77wConfigFlags2	dw 0h
@78pstPage	dd 0h
@79pstComDCB	dd 0h
BSS32	ends
CODE32	segment

; 44   {
	align 010h

	public fnwpPortConfigDeviceDlgProc
fnwpPortConfigDeviceDlgProc	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0164h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,059h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,0ch

; 73   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL86
	align 04h
@BLBL87:

; 74     {
; 75     case WM_INITDLG:
; 76       if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL1

; 77         WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
	push	offset FLAT:@STAT1
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL1:

; 78 //        ControlEnable(hwndDlg,DID_INSERT,FALSE);
; 79       bAllowClick = FALSE;
	mov	dword ptr  @bbAllowClick,0h

; 80       pstPage = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @epstPage,eax

; 81       pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @epstPage
	and	byte ptr [eax+02ah],0feh

; 82       pstDCBheader = pstPage->pVoidPtrOne;
	mov	eax,dword ptr  @epstPage
	mov	eax,[eax+06h]
	mov	dword ptr  @10pstDCBheader,eax

; 83       pstCFGheader = pstPage->pVoidPtrTwo;
	mov	eax,dword ptr  @epstPage
	mov	eax,[eax+0ah]
	mov	dword ptr  @fpstCFGheader,eax

; 84       pstCOMiCFG = pstPage->pVoidPtrThree;
	mov	eax,dword ptr  @epstPage
	mov	eax,[eax+0eh]
	mov	dword ptr  @14pstCOMiCFG,eax

; 85       WinSetWindowText(hwndNoteBookDlg,szInitDeviceDescription);
	push	offset FLAT:szInitDeviceDescription
	push	dword ptr  hwndNoteBookDlg
	call	WinSetWindowText
	add	esp,08h

; 86       /*
; 87       **  setup device name
; 88       */
; 89       szPortName[0] = 0;
	mov	byte ptr [ebp-011h],0h;	szPortName

; 90       iItemSelected = FillDeviceDialogNameListBox(hwndDlg,szCurrentConfigDeviceName,szPortName);
	lea	eax,[ebp-011h];	szPortName
	push	eax
	push	offset FLAT:szCurrentConfigDeviceName
	push	dword ptr [ebp+08h];	hwndDlg
	call	FillDeviceDialogNameListBox
	add	esp,0ch
	mov	[ebp-08h],eax;	iItemSelected

; 91       iOrgItemSelected = iItemSelected;
	mov	eax,[ebp-08h];	iItemSelected
	mov	dword ptr  @17iOrgItemSelected,eax

; 92       WinSendDlgItemMsg(hwndDlg,PCFG_NAME_LIST,LM_SELECTITEM,MPFROMSHORT(iItemSelected),MPFROMSHORT(TRUE));
	push	01h
	mov	ax,[ebp-08h];	iItemSelected
	and	eax,0ffffh
	push	eax
	push	0164h
	push	0130ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 93       if (!pstCOMiCFG->bPCIadapter)
	mov	eax,dword ptr  @14pstCOMiCFG
	test	byte ptr [eax+04bh],080h
	jne	@BLBL2

; 94         {
; 95         /*
; 96         ** setup device base I/O address
; 97         */
; 98         if ((wAddress = pstDCBheader->stComDCB.wIObaseAddress) == 0)  // is an address defined?
	mov	eax,dword ptr  @10pstDCBheader
	mov	ax,[eax+016h]
	mov	word ptr  @18wAddress,ax
	cmp	word ptr  @18wAddress,0h
	jne	@BLBL3

; 99           {
; 100           wAddress = wLastAddress;  // set search starting point
	mov	ax,word ptr  wLastAddress
	mov	word ptr  @18wAddress,ax

; 101           if (!GetNextAvailableAddress(&wAddress))
	push	offset FLAT:@18wAddress
	call	GetNextAvailableAddress
	add	esp,04h
	test	eax,eax
	jne	@BLBL4

; 102             {
; 103             MessageBox(hwndDlg,"There are no I/O address blocks available.\n\nYou will have to delete a device to free up an address block.");
	push	offset FLAT:@STAT2
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 104             WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 105             return(MRESULT)TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL4:

; 106             }
; 107           pstDCBheader->stComDCB.wIObaseAddress = wAddress;
	mov	eax,dword ptr  @10pstDCBheader
	mov	cx,word ptr  @18wAddress
	mov	[eax+016h],cx

; 108           /*
; 109           ** force this address to appear as changed by user to new address during exit
; 110           ** processing (UM_SAVE_DATA).  Mark as device being inserted.
; 111           */
; 112           wOldAddress = 0xffff;
	mov	word ptr  @12wOldAddress,0ffffh

; 113           }
	jmp	@BLBL5
	align 010h
@BLBL3:

; 114         else
; 115           wOldAddress = wAddress;
	mov	ax,word ptr  @18wAddress
	mov	word ptr  @12wOldAddress,ax
@BLBL5:

; 116         switch (fDisplayBase)
	xor	eax,eax
	mov	al,byte ptr  @11fDisplayBase
	jmp	@BLBL89
	align 04h
@BLBL90:

; 117           {
; 118           case DISP_DEC:
; 119             sprintf(szBuffer,"%u",wAddress);
	xor	eax,eax
	mov	ax,word ptr  @18wAddress
	push	eax
	mov	edx,offset FLAT:@STAT3
	lea	eax,[ebp-085h];	szBuffer
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 120             CheckButton(hwndDlg,PCFG_DISP_DEC,TRUE);
	push	01h
	push	012e7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 121             break;
	jmp	@BLBL88
	align 04h
@BLBL91:
@BLBL92:

; 122           case DISP_CHEX:
; 123           default:
; 124             CheckButton(hwndDlg,PCFG_DISP_CHEX,TRUE);
	push	01h
	push	012e5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 125             sprintf(szBuffer,"%X",wAddress);
	xor	eax,eax
	mov	ax,word ptr  @18wAddress
	push	eax
	mov	edx,offset FLAT:@STAT4
	lea	eax,[ebp-085h];	szBuffer
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 126             break;
	jmp	@BLBL88
	align 04h
	jmp	@BLBL88
	align 04h
@BLBL89:
	cmp	eax,01h
	je	@BLBL90
	cmp	eax,03h
	je	@BLBL91
	jmp	@BLBL92
	align 04h
@BLBL88:

; 127           }
; 128         WinSendDlgItemMsg(hwndDlg,PCFG_BASE_ADDR,EM_SETTEXTLIMIT,MPFROMSHORT(5),(MPARAM)NULL);
	push	0h
	push	05h
	push	0143h
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 129         WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
	lea	eax,[ebp-085h];	szBuffer
	push	eax
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 130         WinSendDlgItemMsg(hwndDlg,PCFG_BASE_ADDR,EM_SETSEL,MPFROM2SHORT(0,5),(MPARAM)NULL);
	push	0h
	push	050000h
	push	0142h
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 131         bAddressNotAdded = TRUE;  // indicate that this address was not added to address linked list
	mov	dword ptr  @15bAddressNotAdded,01h

; 132         /*
; 133         ** setup interrupt level
; 134         */
; 135         if ((byIntLevel = pstCFGheader->byInterruptLevel) == 0)
	mov	eax,dword ptr  @fpstCFGheader
	mov	al,[eax+0bh]
	mov	byte ptr  @13byIntLevel,al
	cmp	byte ptr  @13byIntLevel,0h
	jne	@BLBL6

; 136           {
; 137           if ((byIntLevel = pstDCBheader->stComDCB.byInterruptLevel) == 0)
	mov	eax,dword ptr  @10pstDCBheader
	mov	al,[eax+030h]
	mov	byte ptr  @13byIntLevel,al
	cmp	byte ptr  @13byIntLevel,0h
	jne	@BLBL7

; 138             {
; 139             byIntLevel = byLastIntLevel;
	mov	al,byte ptr  byLastIntLevel
	mov	byte ptr  @13byIntLevel,al

; 140             if (fIsMCAmachine != YES)
	cmp	word ptr  fIsMCAmachine,01h
	je	@BLBL8

; 141               {
; 142               if (!GetNextAvailableInterrupt(&byIntLevel))
	push	offset FLAT:@13byIntLevel
	call	GetNextAvailableInterrupt
	add	esp,04h
	test	eax,eax
	jne	@BLBL8

; 143                 {
; 144                 if ((pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_MULTI_INT) == 0)
	mov	eax,dword ptr  @10pstDCBheader
	test	byte ptr [eax+011h],040h
	jne	@BLBL8

; 145                   {
; 146                   MessageBox(hwndDlg,"There are no more interrupts available.\n\nYou will have to remove one or more devices to free up an interrupt.");
	push	offset FLAT:@STAT5
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 147                   WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 148                   return(MRESULT)TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL8:

; 149                   }
; 150                 }
; 151               }
; 152             pstDCBheader->stComDCB.byInterruptLevel = byIntLevel;
	mov	eax,dword ptr  @10pstDCBheader
	mov	cl,byte ptr  @13byIntLevel
	mov	[eax+030h],cl

; 153             }
@BLBL7:

; 154           WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
	push	02h
	push	0fh
	push	0207h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 155                                     SPBM_SETLIMITS,
; 156                                     (MPARAM)15L,
; 157                                     (MPARAM)MIN_INT_LEVEL);
; 158           }
	jmp	@BLBL11
	align 010h
@BLBL6:

; 159         else
; 160           {
; 161           ControlEnable(hwndDlg,PCFG_INT_LEVEL,FALSE);
	push	0h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 162           ControlEnable(hwndDlg,PCFG_INT_LEVELT,FALSE);
	push	0h
	push	011f9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 163           }
@BLBL11:

; 164 
; 165         WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
	push	0h
	xor	eax,eax
	mov	al,byte ptr  @13byIntLevel
	push	eax
	push	0208h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 166                                   SPBM_SETCURRENTVALUE,
; 167                                  (MPARAM)byIntLevel,
; 168                                   NULL);
; 169         byLastIntLevel = byIntLevel;
	mov	al,byte ptr  @13byIntLevel
	mov	byte ptr  byLastIntLevel,al

; 170         sprintf(szDeviceDescription,szDeviceDescriptionFormat,szCurrentConfigDeviceName,wLastAddress,byLastIntLevel);
	xor	eax,eax
	mov	al,byte ptr  byLastIntLevel
	push	eax
	xor	eax,eax
	mov	ax,word ptr  wLastAddress
	push	eax
	push	offset FLAT:szCurrentConfigDeviceName
	mov	edx,offset FLAT:szDeviceDescriptionFormat
	mov	eax,offset FLAT:szDeviceDescription
	sub	esp,08h
	call	_sprintfieee
	add	esp,014h

; 171         }
	jmp	@BLBL12
	align 010h
@BLBL2:

; 172       else
; 173         {
; 174         ControlEnable(hwndDlg,GB_IOBASEADDRESS,FALSE);
	push	0h
	push	02896h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 175         ControlEnable(hwndDlg,PCFG_BASE_ADDR,FALSE);
	push	0h
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 176         ControlEnable(hwndDlg,GB_ENTRYBASE,FALSE);
	push	0h
	push	02898h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 177         ControlEnable(hwndDlg,PCFG_DISP_CHEX,FALSE);
	push	0h
	push	012e5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 178         ControlEnable(hwndDlg,PCFG_DISP_DEC,FALSE);
	push	0h
	push	012e7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 179         ControlEnable(hwndDlg,PCFG_INT_LEVEL,FALSE);
	push	0h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 180         ControlEnable(hwndDlg,PCFG_INT_LEVELT,FALSE);
	push	0h
	push	011f9h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 181         WinSetDlgItemText(hwndDlg,ST_ADAPTERNOTE,"This device is part of PCI PnP adapter");
	push	offset FLAT:@STAT6
	push	02cc5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 182         sprintf(szDeviceDescription,szPCIdeviceDescriptionFormat,szCurrentConfigDeviceName);
	push	offset FLAT:szCurrentConfigDeviceName
	mov	edx,offset FLAT:szPCIdeviceDescriptionFormat
	mov	eax,offset FLAT:szDeviceDescription
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 183         }
@BLBL12:

; 184       /*
; 185       ** test and setup COMscope option
; 186       */
; 187       bCOMscopeEnabled = TRUE;
	mov	dword ptr  @16bCOMscopeEnabled,01h

; 188       if (!pstCOMiCFG->bInstallCOMscope)
	mov	eax,dword ptr  @14pstCOMiCFG
	test	byte ptr [eax+04bh],02h
	jne	@BLBL13

; 189         {
; 190         bCOMscopeEnabled = FALSE;
	mov	dword ptr  @16bCOMscopeEnabled,0h

; 191         ControlEnable(hwndDlg,PCFG_ENA_COMSCOPE,FALSE);
	push	0h
	push	012e8h
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 192         }
	jmp	@BLBL14
	align 010h
@BLBL13:

; 193       else
; 194         if (pstCOMiCFG->bInitInstall)
	mov	eax,dword ptr  @14pstCOMiCFG
	test	byte ptr [eax+04bh],04h
	je	@BLBL15

; 195           CheckButton(hwndDlg,PCFG_ENA_COMSCOPE,TRUE);
	push	01h
	push	012e8h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL14
	align 010h
@BLBL15:

; 196         else
; 197           if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_COMSCOPE)
	mov	eax,dword ptr  @10pstDCBheader
	test	byte ptr [eax+010h],040h
	je	@BLBL14

; 198             CheckButton(hwndDlg,PCFG_ENA_COMSCOPE,TRUE);
	push	01h
	push	012e8h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL14:

; 199       /*
; 200       ** test and setup spooler option
; 201       */
; 202       bSpoolEnabled = FALSE;
	mov	dword ptr  @dbSpoolEnabled,0h

; 203       if ((szPDRlibrarySpec[0] == 0))// || !bCOMiLoaded)
	cmp	byte ptr  szPDRlibrarySpec,0h
	jne	@BLBL18

; 204         ControlEnable(hwndDlg,PCFG_DEV_PDR,FALSE);
	push	0h
	push	011fbh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
	jmp	@BLBL19
	align 010h
@BLBL18:

; 205       else
; 206         {
; 207         sprintf(szAppName,"PM_%s",szPortName);
	lea	eax,[ebp-011h];	szPortName
	push	eax
	mov	edx,offset FLAT:@STAT7
	mov	eax,offset FLAT:@cszAppName
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 208         if (PrfQueryProfileString(HINI_SYSTEMPROFILE,szAppName,"PORTDRIVER",0,szPortDriver,40) != 0)
	push	028h
	lea	eax,[ebp-039h];	szPortDriver
	push	eax
	push	0h
	push	offset FLAT:@STAT8
	push	offset FLAT:@cszAppName
	push	0fffffffeh
	call	PrfQueryProfileString
	add	esp,018h
	test	eax,eax
	je	@BLBL19

; 209           {
; 210           if (strcmp(szPortDriver,"COMI_SPL;") == 0)
	mov	edx,offset FLAT:@STAT9
	lea	eax,[ebp-039h];	szPortDriver
	call	strcmp
	test	eax,eax
	jne	@BLBL21

; 211             {
; 212             bSpoolEnabled = TRUE;
	mov	dword ptr  @dbSpoolEnabled,01h

; 213             CheckButton(hwndDlg,PCFG_DEV_PDR,TRUE);
	push	01h
	push	011fbh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 214             }
	jmp	@BLBL19
	align 010h
@BLBL21:

; 215           else
; 216             ControlEnable(hwndDlg,PCFG_DEV_PDR,FALSE);
	push	0h
	push	011fbh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 217           }

; 218         }
@BLBL19:

; 219       WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	02710h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinPostMsg
	add	esp,010h

; 220       return (MRESULT) TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL93:

; 221     case UM_INITLS:
; 222       bAllowClick = TRUE;
	mov	dword ptr  @bbAllowClick,01h

; 223       break;
	jmp	@BLBL85
	align 04h
@BLBL94:

; 224     case UM_SET_FOCUS:
; 225       WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	eax
	push	01h
	call	WinSetFocus
	add	esp,08h

; 226       break;
	jmp	@BLBL85
	align 04h
@BLBL95:

; 227     case UM_VALIDATE_DATA:
; 228       if (!pstCO
; 228 MiCFG->bPCIadapter)
	mov	eax,dword ptr  @14pstCOMiCFG
	test	byte ptr [eax+04bh],080h
	jne	@BLBL23

; 229         {
; 230         /*
; 231         **  validate base I/O address
; 232         */
; 233         WinQueryDlgItemText(hwndDlg,PCFG_BASE_ADDR,6,szBuffer);
	lea	eax,[ebp-085h];	szBuffer
	push	eax
	push	06h
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinQueryDlgItemText
	add	esp,010h

; 234         if (fDisplayBase == DISP_HEX)
	cmp	byte ptr  @11fDisplayBase,0h
	jne	@BLBL24

; 235           wNewAddress = ASCIItoBin(szBuffer,16);
	push	010h
	lea	eax,[ebp-085h];	szBuffer
	push	eax
	call	ASCIItoBin
	add	esp,08h
	mov	[ebp-02h],ax;	wNewAddress
	jmp	@BLBL25
	align 010h
@BLBL24:

; 236         else
; 237           wNewAddress = atoi(szBuffer);
	lea	eax,[ebp-085h];	szBuffer
	call	atoi
	mov	[ebp-02h],ax;	wNewAddress
@BLBL25:

; 238         if (wNewAddress % 8)
	xor	eax,eax
	mov	ax,[ebp-02h];	wNewAddress
	cdq	
	xor	eax,edx
	sub	eax,edx
	and	eax,07h
	xor	eax,edx
	sub	eax,edx
	test	eax,eax
	je	@BLBL26

; 239           {
; 240           sprintf(szString,"A device address space must start on an eight byte boundry (e.g., 300h, 3228h).  Please enter a different base address.");
	mov	edx,offset FLAT:@STATa
	lea	eax,[ebp-014dh];	szString
	call	_sprintfieee

; 241           MessageBox(hwndDlg,szString);
	lea	eax,[ebp-014dh];	szString
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 242           sprintf(szBuffer,"%X",wAddress);
	xor	eax,eax
	mov	ax,word ptr  @18wAddress
	push	eax
	mov	edx,offset FLAT:@STATb
	lea	eax,[ebp-085h];	szBuffer
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 243           CheckButton(hwndDlg,PCFG_DISP_CHEX,TRUE);
	push	01h
	push	012e5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 244           CheckButton(hwndDlg,PCFG_DISP_DEC,FALSE);
	push	0h
	push	012e7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 245           fDisplayBase = DISP_HEX;
	mov	byte ptr  @11fDisplayBase,0h

; 246           WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
	lea	eax,[ebp-085h];	szBuffer
	push	eax
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 247           pstPage->usFocusId = PCFG_BASE_ADDR;
	mov	eax,dword ptr  @epstPage
	mov	word ptr [eax+04h],012e4h

; 248           return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL26:

; 249           }
; 250         if (wNewAddress != wOldAddress)
	mov	ax,word ptr  @12wOldAddress
	cmp	[ebp-02h],ax;	wNewAddress
	je	@BLBL27

; 251           {
; 252           /*
; 253           ** either the user changed the address or a new device is to be defined
; 254           */
; 255           if (FindListWordItem(pAddressList,wNewAddress) != NULL)
	mov	ax,[ebp-02h];	wNewAddress
	push	eax
	push	dword ptr  pAddressList
	call	FindListWordItem
	add	esp,08h
	test	eax,eax
	je	@BLBL28

; 256             {
; 257             // the new address is already in use
; 258             if (fDisplayBase == DISP_HEX)
	cmp	byte ptr  @11fDisplayBase,0h
	jne	@BLBL29

; 259               sprintf(szString,"Device at address %Xh is already defined.  Please address a different device.",wNewAddress);
	xor	eax,eax
	mov	ax,[ebp-02h];	wNewAddress
	push	eax
	mov	edx,offset FLAT:@STATc
	lea	eax,[ebp-014dh];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	jmp	@BLBL30
	align 010h
@BLBL29:

; 260             else
; 261               sprintf(szString,"Device at address %u is already defined.  Please address a different device.",wNewAddress);
	xor	eax,eax
	mov	ax,[ebp-02h];	wNewAddress
	push	eax
	mov	edx,offset FLAT:@STATd
	lea	eax,[ebp-014dh];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
@BLBL30:

; 262             MessageBox(hwndDlg,szString);
	lea	eax,[ebp-014dh];	szString
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 263             sprintf(szBuffer,"%X",wAddress);
	xor	eax,eax
	mov	ax,word ptr  @18wAddress
	push	eax
	mov	edx,offset FLAT:@STATe
	lea	eax,[ebp-085h];	szBuffer
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 264             CheckButton(hwndDlg,PCFG_DISP_CHEX,TRUE);
	push	01h
	push	012e5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 265             CheckButton(hwndDlg,PCFG_DISP_DEC,FALSE);
	push	0h
	push	012e7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 266             fDisplayBase = DISP_HEX;
	mov	byte ptr  @11fDisplayBase,0h

; 267             WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
	lea	eax,[ebp-085h];	szBuffer
	push	eax
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 268             pstPage->usFocusId = PCFG_BASE_ADDR;
	mov	eax,dword ptr  @epstPage
	mov	word ptr [eax+04h],012e4h

; 269             return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL28:

; 270             }
; 271           wOldAddress = wNewAddress;
	mov	ax,[ebp-02h];	wNewAddress
	mov	word ptr  @12wOldAddress,ax

; 272           }
@BLBL27:

; 273         /*
; 274         ** validate interrupt level
; 275         */
; 276         if ((fIsMCAmachine != YES) && (pstCFGheader->byInterruptLevel == 0))
	cmp	word ptr  fIsMCAmachine,01h
	je	@BLBL23
	mov	eax,dword ptr  @fpstCFGheader
	cmp	byte ptr [eax+0bh],0h
	jne	@BLBL23

; 277           {
; 278           WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,SPBM_QUERYVALUE,&lTemp,MPFROM2SHORT(0,SPBQ_DONOTUPDATE));
	push	030000h
	lea	eax,[ebp-0154h];	lTemp
	push	eax
	push	0205h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 279           byTemp = (BYTE)lTemp;
	mov	eax,[ebp-0154h];	lTemp
	mov	[ebp-0155h],al;	byTemp

; 280           if (byTemp != byIntLevel)
	mov	al,byte ptr  @13byIntLevel
	cmp	[ebp-0155h],al;	byTemp
	je	@BLBL23

; 281             {
; 282             if ((FindListByteItem(pLoadInterruptList,(byTemp | '\x80'))) != NULL)
	mov	al,[ebp-0155h];	byTemp
	or	al,080h
	push	eax
	push	dword ptr  pLoadInterruptList
	call	FindListByteItem
	add	esp,08h
	test	eax,eax
	je	@BLBL33

; 283               {
; 284               if ((pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_MULTI_INT) == 0)
	mov	eax,dword ptr  @10pstDCBheader
	test	byte ptr [eax+011h],040h
	jne	@BLBL23

; 285                 {
; 286                 sprintf(szString,"Interrupt Level %u is already taken.  Please select a different Interrupt.",byTemp);
	xor	eax,eax
	mov	al,[ebp-0155h];	byTemp
	push	eax
	mov	edx,offset FLAT:@STATf
	lea	eax,[ebp-014dh];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 287                 MessageBox(hwndDlg,szString);
	lea	eax,[ebp-014dh];	szString
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 288                 WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
	push	0h
	xor	eax,eax
	mov	al,byte ptr  @13byIntLevel
	push	eax
	push	0208h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 289                                           SPBM_SETCURRENTVALUE,
; 290                                   (MPARAM)byIntLevel,
; 291                                           NULL);
; 292                 pstPage->usFocusId = PCFG_INT_LEVEL;
	mov	eax,dword ptr  @epstPage
	mov	word ptr [eax+04h],012e2h

; 293                 return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL33:

; 294                 }
; 295               }
; 296             else
; 297               {
; 298               if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_MULTI_INT)
	mov	eax,dword ptr  @10pstDCBheader
	test	byte ptr [eax+011h],040h
	je	@BLBL36

; 299                 byTemp |= '\x80';
	mov	al,[ebp-0155h];	byTemp
	or	al,080h
	mov	[ebp-0155h],al;	byTemp
@BLBL36:

; 300               if ((FindListByteItem(pInterruptList,byTemp)) != NULL)
	mov	al,[ebp-0155h];	byTemp
	push	eax
	push	dword ptr  pInterruptList
	call	FindListByteItem
	add	esp,08h
	test	eax,eax
	je	@BLBL23

; 301                 {
; 302                 sprintf(szString,"Interrupt Level %u is already taken.  Please select a different Interrupt.",byTemp);
	xor	eax,eax
	mov	al,[ebp-0155h];	byTemp
	push	eax
	mov	edx,offset FLAT:@STAT10
	lea	eax,[ebp-014dh];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 303                 MessageBox(hwndDlg,szString);
	lea	eax,[ebp-014dh];	szString
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 304                 WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
	push	0h
	xor	eax,eax
	mov	al,byte ptr  @13byIntLevel
	push	eax
	push	0208h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 305                                           SPBM_SETCURRENTVALUE,
; 306                                   (MPARAM)byIntLevel,
; 307                                           NULL);
; 308                 pstPage->usFocusId = PCFG_INT_LEVEL;
	mov	eax,dword ptr  @epstPage
	mov	word ptr [eax+04h],012e2h

; 309                 return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL23:

; 310                 }
; 311               }
; 312             }
; 313           }
; 314         }
; 315       return (MRESULT) TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL96:

; 316     case UM_SAVE_DATA:
; 317       if (!pstCOMiCFG->bPCIadapter)
	mov	eax,dword ptr  @14pstCOMiCFG
	test	byte ptr [eax+04bh],080h
	jne	@BLBL38

; 318         {
; 319         /*
; 320         **  get base I/O address
; 321         */
; 322         WinQueryDlgItemText(hwndDlg,PCFG_BASE_ADDR,6,szBuffer);
	lea	eax,[ebp-085h];	szBuffer
	push	eax
	push	06h
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinQueryDlgItemText
	add	esp,010h

; 323         if (fDisplayBase == DISP_HEX)
	cmp	byte ptr  @11fDisplayBase,0h
	jne	@BLBL39

; 324           wNewAddress = ASCIItoBin(szBuffer,16);
	push	010h
	lea	eax,[ebp-085h];	szBuffer
	push	eax
	call	ASCIItoBin
	add	esp,08h
	mov	[ebp-02h],ax;	wNewAddress
	jmp	@BLBL40
	align 010h
@BLBL39:

; 325         else
; 326           wNewAddress = atoi(szBuffer);
	lea	eax,[ebp-085h];	szBuffer
	call	atoi
	mov	[ebp-02h],ax;	wNewAddress
@BLBL40:

; 327         if (wNewAddress % 8)
	xor	eax,eax
	mov	ax,[ebp-02h];	wNewAddress
	cdq	
	xor	eax,edx
	sub	eax,edx
	and	eax,07h
	xor	eax,edx
	sub	eax,edx
	test	eax,eax
	je	@BLBL41

; 328           {
; 329           sprintf(szString,"A device address space must start on an eight byte boundry (e.g., 300h, 3228h).  Please enter a different base address.");
	mov	edx,offset FLAT:@STAT11
	lea	eax,[ebp-014dh];	szString
	call	_sprintfieee

; 330           MessageBox(hwndDlg,szString);
	lea	eax,[ebp-014dh];	szString
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 331           sprintf(szBuffer,"%X",wAddress);
	xor	eax,eax
	mov	ax,word ptr  @18wAddress
	push	eax
	mov	edx,offset FLAT:@STAT12
	lea	eax,[ebp-085h];	szBuffer
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 332           CheckButton(hwndDlg,PCFG_DISP_CHEX,TRUE);
	push	01h
	push	012e5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 333           CheckButton(hwndDlg,PCFG_DISP_DEC,FALSE);
	push	0h
	push	012e7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 334           fDisplayBase = DISP_HEX;
	mov	byte ptr  @11fDisplayBase,0h

; 335           WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
	lea	eax,[ebp-085h];	szBuffer
	push	eax
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 336           pstPage->usFocusId = PCFG_BASE_ADDR;
	mov	eax,dword ptr  @epstPage
	mov	word ptr [eax+04h],012e4h

; 337           return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL41:

; 338           }
; 339         if (wNewAddress != wOldAddress)
	mov	ax,word ptr  @12wOldAddress
	cmp	[ebp-02h],ax;	wNewAddress
	je	@BLBL42

; 340           {
; 341           /*
; 342           ** either the user changed the address or a new device is bring inserted
; 343           */
; 344           if (FindListWordItem(pAddressList,wNewAddress) != NULL)
	mov	ax,[ebp-02h];	wNewAddress
	push	eax
	push	dword ptr  pAddressList
	call	FindListWordItem
	add	esp,08h
	test	eax,eax
	je	@BLBL43

; 345             {
; 346             // the new address is already in use
; 347             if (fDisplayBase == DISP_HEX)
	cmp	byte ptr  @11fDisplayBase,0h
	jne	@BLBL44

; 348               sprintf(szString,"Device at address %Xh is already defined.  Please address a different device.",wNewAddress);
	xor	eax,eax
	mov	ax,[ebp-02h];	wNewAddress
	push	eax
	mov	edx,offset FLAT:@STAT13
	lea	eax,[ebp-014dh];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
	jmp	@BLBL45
	align 010h
@BLBL44:

; 349             else
; 350               sprintf(szString,"Device at address %u is already defined.  Please address a different device.",wNewAddress);
	xor	eax,eax
	mov	ax,[ebp-02h];	wNewAddress
	push	eax
	mov	edx,offset FLAT:@STAT14
	lea	eax,[ebp-014dh];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
@BLBL45:

; 351             MessageBox(hwndDlg,szString);
	lea	eax,[ebp-014dh];	szString
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 352             sprintf(szBuffer,"%X",wAddress);
	xor	eax,eax
	mov	ax,word ptr  @18wAddress
	push	eax
	mov	edx,offset FLAT:@STAT15
	lea	eax,[ebp-085h];	szBuffer
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 353             CheckButton(hwndDlg,PCFG_DISP_CHEX,TRUE);
	push	01h
	push	012e5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 354             CheckButton(hwndDlg,PCFG_DISP_DEC,FALSE);
	push	0h
	push	012e7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 355             fDisplayBase = DISP_HEX;
	mov	byte ptr  @11fDisplayBase,0h

; 356             WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
	lea	eax,[ebp-085h];	szBuffer
	push	eax
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 357             pstPage->usFocusId = PCFG_BASE_ADDR;
	mov	eax,dword ptr  @epstPage
	mov	word ptr [eax+04h],012e4h

; 358             return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL43:

; 359             }
; 360           /*
; 361           **  add new address to address lists
; 362           */
; 363           AddListItem(pLoadAddressList,&wNewAddress,2);
	push	02h
	lea	eax,[ebp-02h];	wNewAddress
	push	eax
	push	dword ptr  pLoadAddressList
	call	AddListItem
	add	esp,0ch

; 364           AddListItem(pAddressList,&wNewAddress,2);
	push	02h
	lea	eax,[ebp-02h];	wNewAddress
	push	eax
	push	dword ptr  pAddressList
	call	AddListItem
	add	esp,0ch

; 365           /*
; 366           **  this was not a new (inserted) device then remove the old address from the address lists
; 367           */
; 368           if (wOldAddress != 0xffff)
	cmp	word ptr  @12wOldAddress,0ffffh
	je	@BLBL46

; 369             {
; 370             if ((pListItem = FindListWordItem(pAddressList,wOldAddress)) != NULL)
	mov	ax,word ptr  @12wOldAddress
	push	eax
	push	dword ptr  pAddressList
	call	FindListWordItem
	add	esp,08h
	mov	[ebp-015ch],eax;	pListItem
	cmp	dword ptr [ebp-015ch],0h;	pListItem
	je	@BLBL47

; 371               RemoveListItem(pListItem);
	push	dword ptr [ebp-015ch];	pListItem
	call	RemoveListItem
	add	esp,04h
@BLBL47:

; 372             if ((pListItem = FindListWordItem(pLoadAddressList,wOldAddress)) != NULL)
	mov	ax,word ptr  @12wOldAddress
	push	eax
	push	dword ptr  pLoadAddressList
	call	FindListWordItem
	add	esp,08h
	mov	[ebp-015ch],eax;	pListItem
	cmp	dword ptr [ebp-015ch],0h;	pListItem
	je	@BLBL46

; 373               RemoveListItem(pListItem);
	push	dword ptr [ebp-015ch];	pListItem
	call	RemoveListItem
	add	esp,04h

; 374             }
@BLBL46:

; 375           wOldAddress = wNewAddress;
	mov	ax,[ebp-02h];	wNewAddress
	mov	word ptr  @12wOldAddress,ax

; 376           }
@BLBL42:

; 377         /*
; 378         ** get interrupt level
; 379         */
; 380         if (pstCFGheader->byInterruptLevel == 0)
	mov	eax,dword ptr  @fpstCFGheader
	cmp	byte ptr [eax+0bh],0h
	jne	@BLBL38

; 381           {
; 382           WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,SPBM_QUERYVALUE,&lTemp,MPFROM2SHORT(0,SPBQ_DONOTUPDATE));
	push	030000h
	lea	eax,[ebp-0154h];	lTemp
	push	eax
	push	0205h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 383           byTemp = (BYTE)lTemp;
	mov	eax,[ebp-0154h];	lTemp
	mov	[ebp-0155h],al;	byTemp

; 384           if (byIntLevel != byTemp)
	mov	al,[ebp-0155h];	byTemp
	cmp	byte ptr  @13byIntLevel,al
	je	@BLBL50

; 385             {
; 386             if (fIsMCAmachine != YES)
	cmp	word ptr  fIsMCAmachine,01h
	je	@BLBL51

; 387               {
; 388               if ((FindListByteItem(pLoadInterruptList,(byTemp | '\x80'))) != NULL)
	mov	al,[ebp-0155h];	byTemp
	or	al,080h
	push	eax
	push	dword ptr  pLoadInterruptList
	call	FindListByteItem
	add	esp,08h
	test	eax,eax
	je	@BLBL52

; 389                 {
; 390                 if ((pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_MULTI_INT) == 0)
	mov	eax,dword ptr  @10pstDCBheader
	test	byte ptr [eax+011h],040h
	jne	@BLBL54

; 391                   {
; 392                   sprintf(szString,"Interrupt Level %u is already taken.  Please select a different Interrupt.",byTemp);
	xor	eax,eax
	mov	al,[ebp-0155h];	byTemp
	push	eax
	mov	edx,offset FLAT:@STAT16
	lea	eax,[ebp-014dh];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 393                   MessageBox(hwndDlg,szString);
	lea	eax,[ebp-014dh];	szString
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 394                   WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
	push	0h
	xor	eax,eax
	mov	al,byte ptr  @13byIntLevel
	push	eax
	push	0208h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 395                                             SPBM_SETCURRENTVALUE,
; 396                                     (MPARAM)byIntLevel,
; 397                                             NULL);
; 398                   pstPage->usFocusId = PCFG_INT_LEVEL;
	mov	eax,dword ptr  @epstPage
	mov	word ptr [eax+04h],012e2h

; 399                   return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL52:

; 400                   }
; 401                 }
; 402               else
; 403                 {
; 404                 if (pstDCBheader->stComDCB.wConfigFlags1 & CFG_FLAG1_MULTI_INT)
	mov	eax,dword ptr  @10pstDCBheader
	test	byte ptr [eax+011h],040h
	je	@BLBL55

; 405                   byTemp |= '\x80';
	mov	al,[ebp-0155h];	byTemp
	or	al,080h
	mov	[ebp-0155h],al;	byTemp
@BLBL55:

; 406                 AddListItem(pLoadInterruptList,&byTemp,1);
	push	01h
	lea	eax,[ebp-0155h];	byTemp
	push	eax
	push	dword ptr  pLoadInterruptList
	call	AddListItem
	add	esp,0ch

; 407                 if ((FindListByteItem(pInterruptList,byTemp)) != NULL)
	mov	al,[ebp-0155h];	byTemp
	push	eax
	push	dword ptr  pInterruptList
	call	FindListByteItem
	add	esp,08h
	test	eax,eax
	je	@BLBL54

; 408                   {
; 409                   sprintf(szString,"Interrupt Level %u is already taken.  Please select a different Interrupt.",byTemp);
	xor	eax,eax
	mov	al,[ebp-0155h];	byTemp
	push	eax
	mov	edx,offset FLAT:@STAT17
	lea	eax,[ebp-014dh];	szString
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 410                   MessageBox(hwndDlg,szString);
	lea	eax,[ebp-014dh];	szString
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	MessageBox
	add	esp,08h

; 411                   WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
	push	0h
	xor	eax,eax
	mov	al,byte ptr  @13byIntLevel
	push	eax
	push	0208h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 412                                   
; 412           SPBM_SETCURRENTVALUE,
; 413                                     (MPARAM)byIntLevel,
; 414                                             NULL);
; 415                   pstPage->usFocusId = PCFG_INT_LEVEL;
	mov	eax,dword ptr  @epstPage
	mov	word ptr [eax+04h],012e2h

; 416                   return((MRESULT)FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL54:

; 417                   }
; 418                 }
; 419               AddListItem(pInterruptList,&byTemp,1);
	push	01h
	lea	eax,[ebp-0155h];	byTemp
	push	eax
	push	dword ptr  pInterruptList
	call	AddListItem
	add	esp,0ch

; 420               if ((pListItem = FindListByteItem(pInterruptList,byIntLevel)) != NULL)
	mov	al,byte ptr  @13byIntLevel
	push	eax
	push	dword ptr  pInterruptList
	call	FindListByteItem
	add	esp,08h
	mov	[ebp-015ch],eax;	pListItem
	cmp	dword ptr [ebp-015ch],0h;	pListItem
	je	@BLBL57

; 421                 RemoveListItem(pListItem);
	push	dword ptr [ebp-015ch];	pListItem
	call	RemoveListItem
	add	esp,04h
@BLBL57:

; 422               if ((pListItem = FindListByteItem(pLoadInterruptList,byIntLevel)) != NULL)
	mov	al,byte ptr  @13byIntLevel
	push	eax
	push	dword ptr  pLoadInterruptList
	call	FindListByteItem
	add	esp,08h
	mov	[ebp-015ch],eax;	pListItem
	cmp	dword ptr [ebp-015ch],0h;	pListItem
	je	@BLBL51

; 423                 RemoveListItem(pListItem);
	push	dword ptr [ebp-015ch];	pListItem
	call	RemoveListItem
	add	esp,04h

; 424               }
@BLBL51:

; 425             byIntLevel = (byTemp & ~'\x80');
	xor	eax,eax
	mov	al,[ebp-0155h];	byTemp
	and	al,07fh
	mov	byte ptr  @13byIntLevel,al

; 426             }
@BLBL50:

; 427           byLastIntLevel = byIntLevel;
	mov	al,byte ptr  @13byIntLevel
	mov	byte ptr  byLastIntLevel,al

; 428           pstDCBheader->stComDCB.byInterruptLevel = byIntLevel;
	mov	eax,dword ptr  @10pstDCBheader
	mov	cl,byte ptr  @13byIntLevel
	mov	[eax+030h],cl

; 429           }

; 430         }
@BLBL38:

; 431       /*
; 432       ** get device name
; 433       */
; 434       iItemSelected = (SHORT)WinSendDlgItemMsg(hwndDlg,PCFG_NAME_LIST,LM_QUERYSELECTION,0L,0L);
	push	0h
	push	0h
	push	0165h
	push	0130ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h
	movsx	eax,ax
	mov	[ebp-08h],eax;	iItemSelected

; 435       WinSendDlgItemMsg(hwndDlg,PCFG_NAME_LIST,LM_QUERYITEMTEXT,MPFROM2SHORT(iItemSelected,9),MPFROMP(szPortName));
	lea	eax,[ebp-011h];	szPortName
	push	eax
	mov	ax,[ebp-08h];	iItemSelected
	and	eax,0ffffh
	or	eax,090000h
	push	eax
	push	0168h
	push	0130ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 436       strcpy(szLastName,szPortName);
	lea	edx,[ebp-011h];	szPortName
	mov	eax,offset FLAT:szLastName
	call	strcpy

; 437       RemoveSpaces(szPortName);
	lea	eax,[ebp-011h];	szPortName
	push	eax
	call	RemoveSpaces
	add	esp,04h

; 438       if (strcmp(szCurrentConfigDeviceName,szPortName) != 0)
	lea	edx,[ebp-011h];	szPortName
	mov	eax,offset FLAT:szCurrentConfigDeviceName
	call	strcmp
	test	eax,eax
	je	@BLBL59

; 439         {
; 440         bNameChanged = TRUE;
	mov	dword ptr [ebp-068h],01h;	bNameChanged

; 441         strcpy(szTemp,szCurrentConfigDeviceName);
	mov	edx,offset FLAT:szCurrentConfigDeviceName
	lea	eax,[ebp-061h];	szTemp
	call	strcpy

; 442         astConfigDeviceList[atoi(&szPortName[DEV_NUM_INDEX])].bAvailable = FALSE;
	lea	eax,[ebp-0eh];	szPortName
	call	atoi
	imul	eax,0eh
	mov	dword ptr [eax+ astConfigDeviceList+0ah],0h

; 443         if (szCurrentConfigDeviceName[0] != 0)
	cmp	byte ptr  szCurrentConfigDeviceName,0h
	je	@BLBL60

; 444           astConfigDeviceList[atoi(&szCurrentConfigDeviceName[DEV_NUM_INDEX])].bAvailable = TRUE;
	mov	eax,offset FLAT:szCurrentConfigDeviceName+03h
	call	atoi
	imul	eax,0eh
	mov	dword ptr [eax+ astConfigDeviceList+0ah],01h
@BLBL60:

; 445         strcpy(szCurrentConfigDeviceName,szPortName);
	lea	edx,[ebp-011h];	szPortName
	mov	eax,offset FLAT:szCurrentConfigDeviceName
	call	strcpy

; 446         }
	jmp	@BLBL61
	align 010h
@BLBL59:

; 447       else
; 448         bNameChanged = FALSE;
	mov	dword ptr [ebp-068h],0h;	bNameChanged
@BLBL61:

; 449       /*
; 450       ** get COMscope option
; 451       */
; 452       if (Checked(hwndDlg,PCFG_ENA_COMSCOPE))
	push	012e8h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL62

; 453         pstDCBheader->stComDCB.wConfigFlags1 |= CFG_FLAG1_COMSCOPE;
	mov	eax,dword ptr  @10pstDCBheader
	mov	[ebp-0164h],eax;	@CBE31
	mov	eax,[ebp-0164h];	@CBE31
	mov	cx,[eax+010h]
	or	cl,040h
	mov	[eax+010h],cx
	jmp	@BLBL63
	align 010h
@BLBL62:

; 454       else
; 455         pstDCBheader->stComDCB.wConfigFlags1 &= ~CFG_FLAG1_COMSCOPE;
	mov	eax,dword ptr  @10pstDCBheader
	mov	[ebp-0160h],eax;	@CBE30
	mov	eax,[ebp-0160h];	@CBE30
	xor	ecx,ecx
	mov	cx,[eax+010h]
	and	cl,0bfh
	mov	[eax+010h],cx
@BLBL63:

; 456       /*
; 457       ** get spooler option
; 458       */
; 459       if (Checked(hwndDlg,PCFG_DEV_PDR))
	push	011fbh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL64

; 460         {
; 461         if (!bSpoolEnabled)
	cmp	dword ptr  @dbSpoolEnabled,0h
	jne	@BLBL65

; 462           {
; 463           stSpool.fAction = INSTALL_SPOOL;
	mov	dword ptr [ebp-06ch],01h;	stSpool

; 464           strcpy(stSpool.szPortName,szPortName);
	lea	edx,[ebp-011h];	szPortName
	lea	eax,[ebp-076h];	stSpool
	call	strcpy

; 465           AddListItem(pSpoolList,&stSpool,sizeof(SPOOLLST));
	push	0eh
	lea	eax,[ebp-076h];	stSpool
	push	eax
	push	dword ptr  pSpoolList
	call	AddListItem
	add	esp,0ch

; 466           }
	jmp	@BLBL68
	align 010h
@BLBL65:

; 467         else
; 468           {
; 469           if (bNameChanged)
	cmp	dword ptr [ebp-068h],0h;	bNameChanged
	je	@BLBL68

; 470             {
; 471             stSpool.fAction = REMOVE_SPOOL;
	mov	dword ptr [ebp-06ch],02h;	stSpool

; 472             strcpy(stSpool.szPortName,szTemp);
	lea	edx,[ebp-061h];	szTemp
	lea	eax,[ebp-076h];	stSpool
	call	strcpy

; 473             AddListItem(pSpoolList,&stSpool,sizeof(SPOOLLST));
	push	0eh
	lea	eax,[ebp-076h];	stSpool
	push	eax
	push	dword ptr  pSpoolList
	call	AddListItem
	add	esp,0ch

; 474             stSpool.fAction = INSTALL_SPOOL;
	mov	dword ptr [ebp-06ch],01h;	stSpool

; 475             strcpy(stSpool.szPortName,szPortName);
	lea	edx,[ebp-011h];	szPortName
	lea	eax,[ebp-076h];	stSpool
	call	strcpy

; 476             AddListItem(pSpoolList,&stSpool,sizeof(SPOOLLST));
	push	0eh
	lea	eax,[ebp-076h];	stSpool
	push	eax
	push	dword ptr  pSpoolList
	call	AddListItem
	add	esp,0ch

; 477             }

; 478           }

; 479         }
	jmp	@BLBL68
	align 010h
@BLBL64:

; 480       else
; 481         {
; 482         if (bSpoolEnabled)
	cmp	dword ptr  @dbSpoolEnabled,0h
	je	@BLBL68

; 483           {
; 484           stSpool.fAction = REMOVE_SPOOL;
	mov	dword ptr [ebp-06ch],02h;	stSpool

; 485           if (bNameChanged)
	cmp	dword ptr [ebp-068h],0h;	bNameChanged
	je	@BLBL70

; 486             strcpy(stSpool.szPortName,szTemp);
	lea	edx,[ebp-061h];	szTemp
	lea	eax,[ebp-076h];	stSpool
	call	strcpy
	jmp	@BLBL71
	align 010h
@BLBL70:

; 487           else
; 488             strcpy(stSpool.szPortName,szPortName);
	lea	edx,[ebp-011h];	szPortName
	lea	eax,[ebp-076h];	stSpool
	call	strcpy
@BLBL71:

; 489           AddListItem(pSpoolList,&stSpool,sizeof(SPOOLLST));
	push	0eh
	lea	eax,[ebp-076h];	stSpool
	push	eax
	push	dword ptr  pSpoolList
	call	AddListItem
	add	esp,0ch

; 490           }

; 491         }
@BLBL68:

; 492       if (!pstCOMiCFG->bPCIadapter)
	mov	eax,dword ptr  @14pstCOMiCFG
	test	byte ptr [eax+04bh],080h
	jne	@BLBL72

; 493         {
; 494         pstDCBheader->stComDCB.wIObaseAddress = wNewAddress;
	mov	eax,dword ptr  @10pstDCBheader
	mov	cx,[ebp-02h];	wNewAddress
	mov	[eax+016h],cx

; 495         wLastAddress = wNewAddress;
	mov	ax,[ebp-02h];	wNewAddress
	mov	word ptr  wLastAddress,ax

; 496         pstDCBheader->stComDCB.byInterruptLevel = byLastIntLevel;
	mov	eax,dword ptr  @10pstDCBheader
	mov	cl,byte ptr  byLastIntLevel
	mov	[eax+030h],cl

; 497         sprintf(szDeviceDescription,szDeviceDescriptionFormat,szCurrentConfigDeviceName,wLastAddress,byLastIntLevel);
	xor	eax,eax
	mov	al,byte ptr  byLastIntLevel
	push	eax
	xor	eax,eax
	mov	ax,word ptr  wLastAddress
	push	eax
	push	offset FLAT:szCurrentConfigDeviceName
	mov	edx,offset FLAT:szDeviceDescriptionFormat
	mov	eax,offset FLAT:szDeviceDescription
	sub	esp,08h
	call	_sprintfieee
	add	esp,014h

; 498         }
	jmp	@BLBL73
	align 010h
@BLBL72:

; 499       else
; 500         sprintf(szDeviceDescription,szPCIdeviceDescriptionFormat,szCurrentConfigDeviceName);
	push	offset FLAT:szCurrentConfigDeviceName
	mov	edx,offset FLAT:szPCIdeviceDescriptionFormat
	mov	eax,offset FLAT:szDeviceDescription
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
@BLBL73:

; 501       pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @epstPage
	and	byte ptr [eax+02ah],0feh

; 502       return (MRESULT) TRUE;
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL97:

; 503     case WM_COMMAND:
; 504       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL99
	align 04h
@BLBL100:

; 505         {
; 506         case DID_INSERT:
; 507            WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
	push	0h
	push	0h
	push	02714h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 508            break;
	jmp	@BLBL98
	align 04h
@BLBL101:

; 509         case DID_CANCEL:
; 510           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 511           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL102:

; 512         case DID_HELP:
; 513            WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
	push	0h
	push	012dh
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 514            return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL103:

; 515         case DID_UNDO:
; 516           bAllowClick = FALSE;
	mov	dword ptr  @bbAllowClick,0h

; 517           pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @epstPage
	and	byte ptr [eax+02ah],0feh

; 518           WinSendDlgItemMsg(hwndDlg,PCFG_NAME_LIST,LM_SELECTITEM,MPFROMSHORT(iOrgItemSelected),MPFROMSHORT(TRUE));
	push	01h
	mov	ax,word ptr  @17iOrgItemSelected
	and	eax,0ffffh
	push	eax
	push	0164h
	push	0130ah
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 519           if (!pstCOMiCFG->bPCIadapter)
	mov	eax,dword ptr  @14pstCOMiCFG
	test	byte ptr [eax+04bh],080h
	jne	@BLBL74

; 520             {
; 521             sprintf(szBuffer,"%X",wAddress);
	xor	eax,eax
	mov	ax,word ptr  @18wAddress
	push	eax
	mov	edx,offset FLAT:@STAT18
	lea	eax,[ebp-085h];	szBuffer
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch

; 522             CheckButton(hwndDlg,PCFG_DISP_CHEX,TRUE);
	push	01h
	push	012e5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 523             CheckButton(hwndDlg,PCFG_DISP_DEC,FALSE);
	push	0h
	push	012e7h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 524             fDisplayBase = DISP_HEX;
	mov	byte ptr  @11fDisplayBase,0h

; 525             WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
	lea	eax,[ebp-085h];	szBuffer
	push	eax
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 526             WinSendDlgItemMsg(hwndDlg,PCFG_INT_LEVEL,
	push	0h
	xor	eax,eax
	mov	al,byte ptr  @13byIntLevel
	push	eax
	push	0208h
	push	012e2h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSendDlgItemMsg
	add	esp,014h

; 527                                       SPBM_SETCURRENTVALUE,
; 528                               (MPARAM)byIntLevel,
; 529                                       NULL);
; 530             sprintf(szDeviceDescription,szDeviceDescriptionFormat,szCurrentConfigDeviceName,wLastAddress,byLastIntLevel);
	xor	eax,eax
	mov	al,byte ptr  byLastIntLevel
	push	eax
	xor	eax,eax
	mov	ax,word ptr  wLastAddress
	push	eax
	push	offset FLAT:szCurrentConfigDeviceName
	mov	edx,offset FLAT:szDeviceDescriptionFormat
	mov	eax,offset FLAT:szDeviceDescription
	sub	esp,08h
	call	_sprintfieee
	add	esp,014h

; 531             }
	jmp	@BLBL75
	align 010h
@BLBL74:

; 532           else
; 533             sprintf(szDeviceDescription,szPCIdeviceDescriptionFormat,szCurrentConfigDeviceName);
	push	offset FLAT:szCurrentConfigDeviceName
	mov	edx,offset FLAT:szPCIdeviceDescriptionFormat
	mov	eax,offset FLAT:szDeviceDescription
	sub	esp,08h
	call	_sprintfieee
	add	esp,0ch
@BLBL75:

; 534           if (bCOMscopeEnabled)
	cmp	dword ptr  @16bCOMscopeEnabled,0h
	je	@BLBL76

; 535             CheckButton(hwndDlg,PCFG_ENA_COMSCOPE,TRUE);
	push	01h
	push	012e8h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL77
	align 010h
@BLBL76:

; 536           else
; 537             CheckButton(hwndDlg,PCFG_ENA_COMSCOPE,FALSE);
	push	0h
	push	012e8h
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL77:

; 538           if (bSpoolEnabled)
	cmp	dword ptr  @dbSpoolEnabled,0h
	je	@BLBL78

; 539             CheckButton(hwndDlg,PCFG_DEV_PDR,TRUE);
	push	01h
	push	011fbh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
	jmp	@BLBL79
	align 010h
@BLBL78:

; 540           else
; 541             CheckButton(hwndDlg,PCFG_DEV_PDR,FALSE);
	push	0h
	push	011fbh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL79:

; 542           bAllowClick = TRUE;
	mov	dword ptr  @bbAllowClick,01h

; 543           return(FALSE);
	xor	eax,eax
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL98
	align 04h
@BLBL99:
	cmp	eax,0130h
	je	@BLBL100
	cmp	eax,02h
	je	@BLBL101
	cmp	eax,012dh
	je	@BLBL102
	cmp	eax,0135h
	je	@BLBL103
@BLBL98:

; 544         }
; 545       break;
	jmp	@BLBL85
	align 04h
@BLBL104:

; 546     case WM_CONTROL:
; 547       switch (SHORT2FROMMP(mp1))
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	and	eax,0ffffh
	jmp	@BLBL106
	align 04h
@BLBL107:

; 548         {
; 549         case  BN_CLICKED:
; 550           if (bAllowClick)
	cmp	dword ptr  @bbAllowClick,0h
	je	@BLBL80

; 551           switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL109
	align 04h
@BLBL110:
@BLBL111:

; 552             {
; 553             case PCFG_DISP_CHEX:
; 554             case PCFG_DISP_DEC:
; 555               if (Checked(hwndDlg,PCFG_DISP_CHEX))
	push	012e5h
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL81

; 556                 {
; 557                 if (fDisplayBase != DISP_HEX)
	cmp	byte ptr  @11fDisplayBase,0h
	je	@BLBL83

; 558                   {
; 559                   fDisplayBase = DISP_HEX;
	mov	byte ptr  @11fDisplayBase,0h

; 560                   WinQueryDlgItemText(hwndDlg,PCFG_BASE_ADDR,12,szBuffer);
	lea	eax,[ebp-085h];	szBuffer
	push	eax
	push	0ch
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinQueryDlgItemText
	add	esp,010h

; 561                   wAddress = atoi(szBuffer);
	lea	eax,[ebp-085h];	szBuffer
	call	atoi
	mov	word ptr  @18wAddress,ax

; 562                   itoa(wAddress,szBuffer,16);
	mov	ecx,010h
	lea	edx,[ebp-085h];	szBuffer
	xor	eax,eax
	mov	ax,word ptr  @18wAddress
	call	_itoa

; 563                   WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
	lea	eax,[ebp-085h];	szBuffer
	push	eax
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 564                   }

; 565                 }
	jmp	@BLBL83
	align 010h
@BLBL81:

; 566               else
; 567                 {
; 568                 if (fDisplayBase != DISP_DEC)
	cmp	byte ptr  @11fDisplayBase,01h
	je	@BLBL83

; 569                   {
; 570                   fDisplayBase = DISP_DEC;
	mov	byte ptr  @11fDisplayBase,01h

; 571                   WinQueryDlgItemText(hwndDlg,PCFG_BASE_ADDR,12,szBuffer);
	lea	eax,[ebp-085h];	szBuffer
	push	eax
	push	0ch
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinQueryDlgItemText
	add	esp,010h

; 572                   wAddress = (WORD)ASCIItoBin(szBuffer,16);
	push	010h
	lea	eax,[ebp-085h];	szBuffer
	push	eax
	call	ASCIItoBin
	add	esp,08h
	mov	word ptr  @18wAddress,ax

; 573                   itoa(wAddress,szBuffer,10);
	mov	ecx,0ah
	lea	edx,[ebp-085h];	szBuffer
	xor	eax,eax
	mov	ax,word ptr  @18wAddress
	call	_itoa

; 574                   WinSetDlgItemText(hwndDlg,PCFG_BASE_ADDR,szBuffer);
	lea	eax,[ebp-085h];	szBuffer
	push	eax
	push	012e4h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch

; 575                   }

; 576                 }
@BLBL83:

; 577               break;
	jmp	@BLBL108
	align 04h
	jmp	@BLBL108
	align 04h
@BLBL109:
	cmp	eax,012e5h
	je	@BLBL110
	cmp	eax,012e7h
	je	@BLBL111
@BLBL108:
@BLBL80:

; 578 #ifdef this_junk
; 579             case PCFG_ENA_COMSCOPE:
; 580             case PCFG_DEV_PDR:
; 581               if (bAllowClick)
; 582                 pstPage->bDirtyBit = TRUE;
; 583               break;
; 584 #endif
; 585             }
; 586           break;
	jmp	@BLBL105
	align 04h
	jmp	@BLBL105
	align 04h
@BLBL106:
	cmp	eax,01h
	je	@BLBL107
@BLBL105:

; 587 #ifdef this_junk
; 588         case SPBN_CHANGE:
; 589         case CBN_ENTER:
; 590         case EN_CHANGE:
; 591           if (bAllowClick)
; 592             pstPage->bDirtyBit = TRUE;
; 593           break;
; 594 #endif
; 595         }
; 596       return((MRESULT)TRUE);
	mov	eax,01h
	add	esp,0ch
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL85
	align 04h
@BLBL86:
	cmp	eax,03bh
	je	@BLBL87
	cmp	eax,02710h
	je	@BLBL93
	cmp	eax,02716h
	je	@BLBL94
	cmp	eax,02715h
	je	@BLBL95
	cmp	eax,02711h
	je	@BLBL96
	cmp	eax,020h
	je	@BLBL97
	cmp	eax,030h
	je	@BLBL104
@BLBL85:

; 597     }
; 598   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
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
fnwpPortConfigDeviceDlgProc	endp

; 602   {
	align 010h

	public fnwpPortExtensionsDlgProc
fnwpPortExtensionsDlgProc	proc
	push	ebp
	mov	ebp,esp
	sub	esp,0a0h
	push	eax
	push	ecx
	push	edi
	mov	eax,0aaaaaaaah
	mov	ecx,028h
	lea	edi,[esp+0ch]
	rep stosd	
	pop	edi
	pop	ecx
	pop	eax
	sub	esp,08h

; 613   switch (msg)
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	jmp	@BLBL164
	align 04h
@BLBL165:

; 614     {
; 615     case WM_INITDLG:
; 616       if (!bInsertNewDevice)
	cmp	dword ptr  bInsertNewDevice,0h
	jne	@BLBL112

; 617         WinSetDlgItemText(hwndDlg,DID_INSERT,"S~ave");
	push	offset FLAT:@STAT19
	push	0130h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinSetDlgItemText
	add	esp,0ch
@BLBL112:

; 618 //        ControlEnable(hwndDlg,DID_INSERT,FALSE);
; 619 //      CenterDlgBox(hwndDlg);
; 620 //      WinSetFocus(HWND_DESKTOP,hwndDlg);
; 621       bAllowClick = FALSE;
	mov	dword ptr  @74bAllowClick,0h

; 622       pstPage = PVOIDFROMMP(mp2);
	mov	eax,[ebp+014h];	mp2
	mov	dword ptr  @78pstPage,eax

; 623       pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @78pstPage
	and	byte ptr [eax+02ah],0feh

; 624       pstComDCB = pstPage->pVoidPtrOne;
	mov	eax,dword ptr  @78pstPage
	mov	eax,[eax+06h]
	mov	dword ptr  @79pstComDCB,eax

; 625       pstCFGheader = pstPage->pVoidPtrTwo;
	mov	eax,dword ptr  @78pstPage
	mov	eax,[eax+0ah]
	mov	dword ptr  @75pstCFGheader,eax

; 626       wConfigFlags1 = pstComDCB->wConfigFlags1;
	mov	eax,dword ptr  @79pstComDCB
	mov	ax,[eax]
	mov	word ptr  @76wConfigFlags1,ax

; 627       wConfigFlags2 = pstComDCB->wConfigFlags2;
	mov	eax,dword ptr  @79pstComDCB
	mov	ax,[eax+02h]
	mov	word ptr  @77wConfigFlags2,ax

; 628 //      wLoadFlags = pstCFGheader->wLoadFlags;
; 629       CheckButton(hwndDlg,PCFG_FOR_UART,(wConfigFlags1 & CFG_FLAG1_FOREIGN_UART));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,02000h
	push	eax
	push	012eeh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 630       CheckButton(hwndDlg,PCFG_EXP_BAUD,(wConfigFlags1 & CFG_FLAG1_EXPLICIT_BAUD_DIVISOR));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,080h
	push	eax
	push	012edh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 631       CheckButton(hwndDlg,PCFG_MDM_EXT,(wConfigFlags1 & CFG_FLAG1_EX
; 631 T_MODEM_CTL));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,0100h
	push	eax
	push	012ebh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 632       CheckButton(hwndDlg,PCFG_FORCE_4X_TEST,(wConfigFlags1 & CFG_FLAG1_FORCE_4X_TEST));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,01h
	push	eax
	push	012efh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 633       CheckButton(hwndDlg,CB_ALLOW16750RTSCONTROL,(wConfigFlags2 & CFG_FLAG2_ALLOW16750RTSCTL));
	xor	eax,eax
	mov	ax,word ptr  @77wConfigFlags2
	and	eax,01h
	push	eax
	push	0130fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 634       CheckButton(hwndDlg,CB_NOREPORTBRKWITHLINECHAR,(wConfigFlags1 & CFG_FLAG1_NO_BREAK_REPORT));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,0400h
	push	eax
	push	0130eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 635       CheckButton(hwndDlg,PCFG_EXT_4xBAUD,(wConfigFlags1 & CFG_FLAG1_NORMALIZE_BAUD));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,010h
	push	eax
	push	0100ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 636       CheckButton(hwndDlg,PCFG_DIS_TEST,(wConfigFlags1 & CFG_FLAG1_TESTS_DISABLE));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,01000h
	push	eax
	push	0130bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 637       CheckButton(hwndDlg,PCFG_MDM_INT,(wConfigFlags1 & CFG_FLAG1_NO_MODEM_INT));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,0800h
	push	eax
	push	012ech
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 638       if (pstCFGheader->byAdapterType == HDWTYPE_TWO)
	mov	eax,dword ptr  @75pstCFGheader
	cmp	byte ptr [eax+0ah],02h
	jne	@BLBL113

; 639         ControlEnable(hwndDlg,PCFG_EXT_TIB,FALSE);
	push	0h
	push	0130dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch
	jmp	@BLBL114
	align 010h
@BLBL113:

; 640       else
; 641         CheckButton(hwndDlg,PCFG_EXT_TIB,(wConfigFlags1 & CFG_FLAG1_TIB_UART));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,08h
	push	eax
	push	0130dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL114:

; 642       CheckButton(hwndDlg,PCFG_OUT1,(wConfigFlags2 & CFG_FLAG2_ACTIVATE_OUT1));
	xor	eax,eax
	mov	ax,word ptr  @77wConfigFlags2
	and	eax,02h
	push	eax
	push	012dfh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 643       if ((pstCFGheader->byInterruptLevel == 0) &&
	mov	eax,dword ptr  @75pstCFGheader
	cmp	byte ptr [eax+0bh],0h
	jne	@BLBL115

; 644           (pstCFGheader->byAdapterType != HDWTYPE_PCI))
	mov	eax,dword ptr  @75pstCFGheader
	cmp	byte ptr [eax+0ah],09h
	je	@BLBL115

; 645         {
; 646         if (wConfigFlags1 & CFG_FLAG1_MULTI_INT)
	test	byte ptr  @76wConfigFlags1+01h,040h
	je	@BLBL116

; 647           {
; 648           CheckButton(hwndDlg,PCFG_EXT_SHARE_INT,TRUE);
	push	01h
	push	012ddh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 649           if(wConfigFlags1 & CFG_FLAG1_EXCLUSIVE_ACCESS)
	test	byte ptr  @76wConfigFlags1+01h,080h
	je	@BLBL119

; 650             CheckButton(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
	push	01h
	push	012deh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 651           }
	jmp	@BLBL119
	align 010h
@BLBL116:

; 652         else
; 653           {
; 654           CheckButton(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
	push	01h
	push	012deh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 655           ControlEnable(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,FALSE);
	push	0h
	push	012deh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 656           }

; 657         }
	jmp	@BLBL119
	align 010h
@BLBL115:

; 658       else
; 659         {
; 660         CheckButton(hwndDlg,PCFG_EXT_SHARE_INT,TRUE);
	push	01h
	push	012ddh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 661         ControlEnable(hwndDlg,PCFG_EXT_SHARE_INT,FALSE);
	push	0h
	push	012ddh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 662         ControlEnable(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,FALSE);
	push	0h
	push	012deh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 663         }
@BLBL119:

; 664       WinPostMsg(hwndDlg,UM_INITLS,(MPARAM)0L,(MPARAM)0L);
	push	0h
	push	0h
	push	02710h
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinPostMsg
	add	esp,010h

; 665       return (MRESULT) TRUE;
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL166:

; 666     case UM_INITLS:
; 667       bAllowClick = TRUE;
	mov	dword ptr  @74bAllowClick,01h

; 668       break;
	jmp	@BLBL163
	align 04h
@BLBL167:

; 669     case UM_SET_FOCUS:
; 670       WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,SHORT1FROMMP(mp1)));
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	eax
	push	01h
	call	WinSetFocus
	add	esp,08h

; 671       break;
	jmp	@BLBL163
	align 04h
@BLBL168:

; 672     case UM_SAVE_DATA:
; 673       if (Checked(hwndDlg,PCFG_FOR_UART))
	push	012eeh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL120

; 674         wConfigFlags1 |= CFG_FLAG1_FOREIGN_UART;
	mov	ax,word ptr  @76wConfigFlags1
	or	ax,02000h
	mov	word ptr  @76wConfigFlags1,ax
	jmp	@BLBL121
	align 010h
@BLBL120:

; 675       else
; 676         wConfigFlags1 &= ~CFG_FLAG1_FOREIGN_UART;
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	ah,0dfh
	mov	word ptr  @76wConfigFlags1,ax
@BLBL121:

; 677       if (Checked(hwndDlg,PCFG_EXP_BAUD))
	push	012edh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL122

; 678         wConfigFlags1 |= CFG_FLAG1_EXPLICIT_BAUD_DIVISOR;
	mov	ax,word ptr  @76wConfigFlags1
	or	al,080h
	mov	word ptr  @76wConfigFlags1,ax
	jmp	@BLBL123
	align 010h
@BLBL122:

; 679       else
; 680         wConfigFlags1 &= ~CFG_FLAG1_EXPLICIT_BAUD_DIVISOR;
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	al,07fh
	mov	word ptr  @76wConfigFlags1,ax
@BLBL123:

; 681       if (Checked(hwndDlg,PCFG_MDM_EXT))
	push	012ebh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL124

; 682         wConfigFlags1 |= CFG_FLAG1_EXT_MODEM_CTL;
	mov	ax,word ptr  @76wConfigFlags1
	or	ax,0100h
	mov	word ptr  @76wConfigFlags1,ax
	jmp	@BLBL125
	align 010h
@BLBL124:

; 683       else
; 684         wConfigFlags1 &= ~CFG_FLAG1_EXT_MODEM_CTL;
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	ah,0feh
	mov	word ptr  @76wConfigFlags1,ax
@BLBL125:

; 685       if (Checked(hwndDlg,CB_NOREPORTBRKWITHLINECHAR))
	push	0130eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL126

; 686         wConfigFlags1 |= CFG_FLAG1_NO_BREAK_REPORT;
	mov	ax,word ptr  @76wConfigFlags1
	or	ax,0400h
	mov	word ptr  @76wConfigFlags1,ax
	jmp	@BLBL127
	align 010h
@BLBL126:

; 687       else
; 688         wConfigFlags1 &= ~CFG_FLAG1_NO_BREAK_REPORT;
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	ah,0fbh
	mov	word ptr  @76wConfigFlags1,ax
@BLBL127:

; 689       if (Checked(hwndDlg,PCFG_FORCE_4X_TEST))
	push	012efh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL128

; 690         wConfigFlags1 |=CFG_FLAG1_FORCE_4X_TEST;
	mov	ax,word ptr  @76wConfigFlags1
	or	al,01h
	mov	word ptr  @76wConfigFlags1,ax
	jmp	@BLBL129
	align 010h
@BLBL128:

; 691       else
; 692         wConfigFlags1 &= ~CFG_FLAG1_FORCE_4X_TEST;
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	al,0feh
	mov	word ptr  @76wConfigFlags1,ax
@BLBL129:

; 693       if (Checked(hwndDlg,CB_ALLOW16750RTSCONTROL))
	push	0130fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL130

; 694         wConfigFlags2 |= CFG_FLAG2_ALLOW16750RTSCTL;
	mov	ax,word ptr  @77wConfigFlags2
	or	al,01h
	mov	word ptr  @77wConfigFlags2,ax
	jmp	@BLBL131
	align 010h
@BLBL130:

; 695       else
; 696         wConfigFlags2 &= ~CFG_FLAG2_ALLOW16750RTSCTL;
	xor	eax,eax
	mov	ax,word ptr  @77wConfigFlags2
	and	al,0feh
	mov	word ptr  @77wConfigFlags2,ax
@BLBL131:

; 697       if (Checked(hwndDlg,PCFG_EXT_4xBAUD))
	push	0100ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL132

; 698         wConfigFlags1 |= CFG_FLAG1_NORMALIZE_BAUD;
	mov	ax,word ptr  @76wConfigFlags1
	or	al,010h
	mov	word ptr  @76wConfigFlags1,ax
	jmp	@BLBL133
	align 010h
@BLBL132:

; 699       else
; 700         wConfigFlags1 &= ~CFG_FLAG1_NORMALIZE_BAUD;
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	al,0efh
	mov	word ptr  @76wConfigFlags1,ax
@BLBL133:

; 701       if (Checked(hwndDlg,PCFG_DIS_TEST))
	push	0130bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL134

; 702         wConfigFlags1 |= CFG_FLAG1_TESTS_DISABLE;
	mov	ax,word ptr  @76wConfigFlags1
	or	ax,01000h
	mov	word ptr  @76wConfigFlags1,ax
	jmp	@BLBL135
	align 010h
@BLBL134:

; 703       else
; 704         wConfigFlags1 &= ~CFG_FLAG1_TESTS_DISABLE;
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	ah,0efh
	mov	word ptr  @76wConfigFlags1,ax
@BLBL135:

; 705       if (Checked(hwndDlg,PCFG_MDM_INT))
	push	012ech
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL136

; 706         wConfigFlags1 |= CFG_FLAG1_NO_MODEM_INT;
	mov	ax,word ptr  @76wConfigFlags1
	or	ax,0800h
	mov	word ptr  @76wConfigFlags1,ax
	jmp	@BLBL137
	align 010h
@BLBL136:

; 707       else
; 708         wConfigFlags1 &= ~CFG_FLAG1_NO_MODEM_INT;
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	ah,0f7h
	mov	word ptr  @76wConfigFlags1,ax
@BLBL137:

; 709       if (pstCFGheader->byAdapterType != HDWTYPE_TWO)
	mov	eax,dword ptr  @75pstCFGheader
	cmp	byte ptr [eax+0ah],02h
	je	@BLBL138

; 710         if (Checked(hwndDlg,PCFG_EXT_TIB))
	push	0130dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL139

; 711           wConfigFlags1 |= CFG_FLAG1_TIB_UART;
	mov	ax,word ptr  @76wConfigFlags1
	or	al,08h
	mov	word ptr  @76wConfigFlags1,ax
	jmp	@BLBL138
	align 010h
@BLBL139:

; 712         else
; 713           wConfigFlags1 &= ~CFG_FLAG1_TIB_UART;
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	al,0f7h
	mov	word ptr  @76wConfigFlags1,ax
@BLBL138:

; 714       if (Checked(hwndDlg,PCFG_OUT1))
	push	012dfh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL141

; 715         wConfigFlags2 |= CFG_FLAG2_ACTIVATE_OUT1;
	mov	ax,word ptr  @77wConfigFlags2
	or	al,02h
	mov	word ptr  @77wConfigFlags2,ax
	jmp	@BLBL142
	align 010h
@BLBL141:

; 716       else
; 717         wConfigFlags2 &= ~CFG_FLAG2_ACTIVATE_OUT1;
	xor	eax,eax
	mov	ax,word ptr  @77wConfigFlags2
	and	al,0fdh
	mov	word ptr  @77wConfigFlags2,ax
@BLBL142:

; 718       if (pstCFGheader->byInterruptLevel == 0)
	mov	eax,dword ptr  @75pstCFGheader
	cmp	byte ptr [eax+0bh],0h
	jne	@BLBL143

; 719         {
; 720         if ((Checked(hwndDlg,PCFG_EXT_SHARE_INT)) &&
	push	012ddh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL144

; 721             (pstCFGheader->byAdapterType != HDWTYPE_PCI))
	mov	eax,dword ptr  @75pstCFGheader
	cmp	byte ptr [eax+0ah],09h
	je	@BLBL144

; 722           {
; 723           if (!bShareAccessWarning)
	cmp	dword ptr  bShareAccessWarning,0h
	jne	@BLBL145

; 724             {
; 725             sprintf(szCaption,"Shared Interrupt Connection Selected!");
	mov	edx,offset FLAT:@STAT1a
	lea	eax,[ebp-0a0h];	szCaption
	call	_sprintfieee

; 726             sprintf(szMessage,"More than one device connected to an interrupt level can cause unpredictable results!");
	mov	edx,offset FLAT:@STAT1b
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 727             if (WinMessageBox(HWND_DESKTOP,
	push	06021h
	push	09cabh
	lea	eax,[ebp-0a0h];	szCaption
	push	eax
	lea	eax,[ebp-064h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,01h
	je	@BLBL145

; 728                               hwndDlg,
; 729                               szMessage,
; 730                               szCaption,
; 731                               HLPP_MB_SHARE_ACCESS,
; 732                               (MB_OKCANCEL | MB_CUAWARNING | MB_HELP | MB_MOVEABLE)) != MBID_OK)
; 733               {
; 734               CheckButton(hwndDlg,PCFG_EXT_SHARE_INT,FALSE);
	push	0h
	push	012ddh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 735               CheckButton(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
	push	01h
	push	012deh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 736               ControlEnable(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,FALSE);
	push	0h
	push	012deh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 737               WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,PCFG_EXT_SHARE_INT));
	push	012ddh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	eax
	push	01h
	call	WinSetFocus
	add	esp,08h

; 738               return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL145:

; 739               }
; 740             }
; 741           wConfigFlags1 |= CFG_FLAG1_MULTI_INT;
	mov	ax,word ptr  @76wConfigFlags1
	or	ax,04000h
	mov	word ptr  @76wConfigFlags1,ax

; 742           bShareAccessWarning = TRUE;
	mov	dword ptr  bShareAccessWarning,01h

; 743           if (Checked(hwndDlg,PCFG_EXT_EXCLUSIVE_INT))
	push	012deh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL147

; 744             wConfigFlags1 |= CFG_FLAG1_EXCLUSIVE_ACCESS;
	mov	ax,word ptr  @76wConfigFlags1
	or	ax,08000h
	mov	word ptr  @76wConfigFlags1,ax
	jmp	@BLBL143
	align 010h
@BLBL147:

; 745           else
; 746             {
; 747             if (!bNonExAccessWarning)
	cmp	dword ptr  bNonExAccessWarning,0h
	jne	@BLBL149

; 748               {
; 749               sprintf(szCaption,"Non-Exclusive Access Selected!");
	mov	edx,offset FLAT:@STAT1c
	lea	eax,[ebp-0a0h];	szCaption
	call	_sprintfieee

; 750               sprintf(szMessage,"Giving more than one device access to an interrupt level can cause unpredictable results!");
	mov	edx,offset FLAT:@STAT1d
	lea	eax,[ebp-064h];	szMessage
	call	_sprintfieee

; 751               if (WinMessageBox(HWND_DESKTOP,
	push	06021h
	push	09cach
	lea	eax,[ebp-0a0h];	szCaption
	push	eax
	lea	eax,[ebp-064h];	szMessage
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	push	01h
	call	WinMessageBox
	add	esp,018h
	cmp	eax,01h
	je	@BLBL149

; 752                                 hwndDlg,
; 753                                 szMessage,
; 754                                 szCaption,
; 755                                 HLPP_MB_NONEXCLUSIVE_ACCESS,
; 756                                 (MB_OKCANCEL | MB_CUAWARNING | MB_HELP | MB_MOVEABLE)) != MBID_OK)
; 757                 {
; 758                 CheckButton(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
	push	01h
	push	012deh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 759                 WinSetFocus(HWND_DESKTOP,WinWindowFromID(hwndDlg,PCFG_EXT_EXCLUSIVE_INT));
	push	012deh
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinWindowFromID
	add	esp,08h
	push	eax
	push	01h
	call	WinSetFocus
	add	esp,08h

; 760                 return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL149:

; 761                 }
; 762               }
; 763             wConfigFlags1 &= ~CFG_FLAG1_EXCLUSIVE_ACCESS;
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	ah,07fh
	mov	word ptr  @76wConfigFlags1,ax

; 764             bNonExAccessWarning = TRUE;
	mov	dword ptr  bNonExAccessWarning,01h

; 765             }

; 766           }
	jmp	@BLBL143
	align 010h
@BLBL144:

; 767         else
; 768           wConfigFlags1 &= ~(CFG_FLAG1_EXCLUSIVE_ACCESS | CFG_FLAG1_MULTI_INT);
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	ah,03fh
	mov	word ptr  @76wConfigFlags1,ax

; 769         }
@BLBL143:

; 770       pstComDCB->wConfigFlags1 = wConfigFlags1;
	mov	eax,dword ptr  @79pstComDCB
	mov	cx,word ptr  @76wConfigFlags1
	mov	[eax],cx

; 771       pstComDCB->wConfigFlags2 = wConfigFlags2;
	mov	eax,dword ptr  @79pstComDCB
	mov	cx,word ptr  @77wConfigFlags2
	mov	[eax+02h],cx

; 772 //      pstCFGheader->wLoadFlags = wLoadFlags;
; 773       return (MRESULT) TRUE;
	mov	eax,01h
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL169:

; 774     case WM_COMMAND:
; 775       switch (SHORT1FROMMP(mp1))
	mov	ax,[ebp+010h];	mp1
	and	eax,0ffffh
	jmp	@BLBL171
	align 04h
@BLBL172:

; 776         {
; 777         case DID_INSERT:
; 778            WinPostMsg(hwndNoteBookDlg,UM_CLOSE,(MPARAM)0,(MPARAM)0);
	push	0h
	push	0h
	push	02714h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 779            break;
	jmp	@BLBL170
	align 04h
@BLBL173:

; 780         case DID_CANCEL:
; 781           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_CANCEL),(MPARAM)0);
	push	0h
	push	02h
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 782           return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL174:

; 783         case DID_HELP:
; 784           WinPostMsg(hwndNoteBookDlg,WM_COMMAND,MPFROMSHORT(DID_HELP),(MPARAM)0);
	push	0h
	push	012dh
	push	020h
	push	dword ptr  hwndNoteBookDlg
	call	WinPostMsg
	add	esp,010h

; 785           return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
@BLBL175:

; 786         case DID_UNDO:
; 787           bAllowClick = FALSE;
	mov	dword ptr  @74bAllowClick,0h

; 788           pstPage->bDirtyBit = FALSE;
	mov	eax,dword ptr  @78pstPage
	and	byte ptr [eax+02ah],0feh

; 789           CheckButton(hwndDlg,PCFG_FOR_UART,(wConfigFlags1 & CFG_FLAG1_FOREIGN_UART));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,02000h
	push	eax
	push	012eeh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 790           CheckButton(hwndDlg,PCFG_EXP_BAUD,(wConfigFlags1 & CFG_FLAG1_EXPLICIT_BAUD_DIVISOR));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,080h
	push	eax
	push	012edh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 791           CheckButton(hwndDlg,PCFG_MDM_EXT,(wConfigFlags1 & CFG_FLAG1_EXT_MODEM_CTL));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,0100h
	push	eax
	push	012ebh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 792           CheckButton(hwndDlg,PCFG_FORCE_4X_TEST,(wConfigFlags1 & CFG_FLAG1_FORCE_4X_TEST));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,01h
	push	eax
	push	012efh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 793           CheckButton(hwndDlg,CB_ALLOW16750RTSCONTROL,(wConfigFlags2 & CFG_FLAG2_ALLOW16750RTSCTL));
	xor	eax,eax
	mov	ax,word ptr  @77wConfigFlags2
	and	eax,01h
	push	eax
	push	0130fh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 794           CheckButton(hwndDlg,CB_NOREPORTBRKWITHLINECHAR,(wConfigFlags1 & CFG_FLAG1_NO_BREAK_REPORT));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,0400h
	push	eax
	push	0130eh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 795           CheckButton(hwndDlg,PCFG_EXT_4xBAUD,(wConfigFlags1 & CFG_FLAG1_NORMALIZE_BAUD));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,010h
	push	eax
	push	0100ch
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 796           CheckButton(hwndDlg,PCFG_DIS_TEST,(wConfigFlags1 & CFG_FLAG1_TESTS_DISABLE));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,01000h
	push	eax
	push	0130bh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 797           CheckButton(hwndDlg,PCFG_MDM_INT,(wConfigFlags1 & CFG_FLAG1_NO_MODEM_INT));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,0800h
	push	eax
	push	012ech
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 798           if (pstCFGheader->byAdapterType != HDWTYPE_TWO)
	mov	eax,dword ptr  @75pstCFGheader
	cmp	byte ptr [eax+0ah],02h
	je	@BLBL152

; 799             CheckButton(hwndDlg,PCFG_EXT_TIB,(wConfigFlags1 & CFG_FLAG1_TIB_UART));
	xor	eax,eax
	mov	ax,word ptr  @76wConfigFlags1
	and	eax,08h
	push	eax
	push	0130dh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL152:

; 800           CheckButton(hwndDlg,PCFG_OUT1,(wConfigFlags2 & CFG_FLAG2_ACTIVATE_OUT1));
	xor	eax,eax
	mov	ax,word ptr  @77wConfigFlags2
	and	eax,02h
	push	eax
	push	012dfh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 801           if (pstCFGheader->byInterruptLevel == 0)
	mov	eax,dword ptr  @75pstCFGheader
	cmp	byte ptr [eax+0bh],0h
	jne	@BLBL153

; 802             {
; 803             if (wConfigFlags1 & CFG_FLAG1_MULTI_INT)
	test	byte ptr  @76wConfigFlags1+01h,040h
	je	@BLBL154

; 804               {
; 805               CheckButton(hwndDlg,PCFG_EXT_SHARE_INT,TRUE);
	push	01h
	push	012ddh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 806               if(wConfigFlags1 & CFG_FLAG1_EXCLUSIVE_ACCES
; 806 S)
	test	byte ptr  @76wConfigFlags1+01h,080h
	je	@BLBL157

; 807                 CheckButton(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
	push	01h
	push	012deh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 808               }
	jmp	@BLBL157
	align 010h
@BLBL154:

; 809             else
; 810               CheckButton(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
	push	01h
	push	012deh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 811             }
	jmp	@BLBL157
	align 010h
@BLBL153:

; 812           else
; 813             CheckButton(hwndDlg,PCFG_EXT_SHARE_INT,TRUE);
	push	01h
	push	012ddh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch
@BLBL157:

; 814           bAllowClick = TRUE;
	mov	dword ptr  @74bAllowClick,01h

; 815           return(FALSE);
	xor	eax,eax
	add	esp,08h
	mov	esp,ebp
	pop	ebp
	ret	
	jmp	@BLBL170
	align 04h
@BLBL171:
	cmp	eax,0130h
	je	@BLBL172
	cmp	eax,02h
	je	@BLBL173
	cmp	eax,012dh
	je	@BLBL174
	cmp	eax,0135h
	je	@BLBL175
@BLBL170:

; 816         }
; 817       break;
	jmp	@BLBL163
	align 04h
@BLBL176:

; 818     case WM_CONTROL:
; 819       if (SHORT2FROMMP(mp1) == BN_CLICKED)
	mov	eax,[ebp+010h];	mp1
	shr	eax,010h
	cmp	ax,01h
	jne	@BLBL158

; 820         {
; 821         pstPage->bDirtyBit = TRUE;
	mov	eax,dword ptr  @78pstPage
	or	byte ptr [eax+02ah],01h

; 822         if (bAllowClick)
	cmp	dword ptr  @74bAllowClick,0h
	je	@BLBL158

; 823           {
; 824           if (SHORT1FROMMP(mp1) == PCFG_EXT_SHARE_INT)
	mov	ax,[ebp+010h];	mp1
	cmp	ax,012ddh
	jne	@BLBL158

; 825             if (Checked(hwndDlg,PCFG_EXT_SHARE_INT))
	push	012ddh
	push	dword ptr [ebp+08h];	hwndDlg
	call	Checked
	add	esp,08h
	test	eax,eax
	je	@BLBL161

; 826               {
; 827               ControlEnable(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,FALSE);
	push	0h
	push	012deh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 828               CheckButton(hwndDlg,PCFG_EXT_SHARE_INT,FALSE);
	push	0h
	push	012ddh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 829               }
	jmp	@BLBL158
	align 010h
@BLBL161:

; 830             else
; 831               {
; 832               ControlEnable(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
	push	01h
	push	012deh
	push	dword ptr [ebp+08h];	hwndDlg
	call	ControlEnable
	add	esp,0ch

; 833               CheckButton(hwndDlg,PCFG_EXT_SHARE_INT,TRUE);
	push	01h
	push	012ddh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 834               CheckButton(hwndDlg,PCFG_EXT_EXCLUSIVE_INT,TRUE);
	push	01h
	push	012deh
	push	dword ptr [ebp+08h];	hwndDlg
	call	CheckButton
	add	esp,0ch

; 835               }

; 836           }

; 837         }
@BLBL158:

; 838       break;
	jmp	@BLBL163
	align 04h
	jmp	@BLBL163
	align 04h
@BLBL164:
	cmp	eax,03bh
	je	@BLBL165
	cmp	eax,02710h
	je	@BLBL166
	cmp	eax,02716h
	je	@BLBL167
	cmp	eax,02711h
	je	@BLBL168
	cmp	eax,020h
	je	@BLBL169
	cmp	eax,030h
	je	@BLBL176
@BLBL163:

; 839     }
; 840   return(WinDefDlgProc(hwndDlg,msg,mp1,mp2));
	push	dword ptr [ebp+014h];	mp2
	push	dword ptr [ebp+010h];	mp1
	xor	eax,eax
	mov	ax,[ebp+0ch];	msg
	push	eax
	push	dword ptr [ebp+08h];	hwndDlg
	call	WinDefDlgProc
	add	esp,018h
	mov	esp,ebp
	pop	ebp
	ret	
fnwpPortExtensionsDlgProc	endp
CODE32	ends
end
