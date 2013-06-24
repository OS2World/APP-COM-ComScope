;************************************************************************
;
; $Revision:   1.5  $
;
; $Log:   P:/archive/comi/devhlp.inv  $
;
;   Rev 1.5   19 Feb 1996 10:48:18   EMMETT
;Added many features, notably:
;Added trace of DosDevOICtl function calls and packets.
;Added 16650 and 16750 support.
;Streamlined interrupt routine.
;
;   Rev 1.4   25 Apr 1995 22:16:32   EMMETT
;Added Support for DigiBoard PC/16.  Changed interrupt Routine for better adapter independence.
;Changed interrupt routine to allow user to select interrupting device selection algorithim.  Fixed
;ABIOS interaction for better "non.INI" initialization in MCA machines.  Fixed various initialization
;message strings.  COMscope and receive buffer are now allocated from system memory, allowing
;a 32k (word) COMscope buffer and a 64k (byte) receive buffer.
;
;   Rev 1.3   03 Dec 1994 14:38:32   EMMETT
;Added items necessary for various upgrates and fixes. duh!
;
;   Rev 1.2   27 Apr 1994 22:56:18   EMMETT
;FIxed ABIOS stuff to work better than before.
;
;   Rev 1.1   18 Apr 1994 23:17:40   EMMETT
;Changed ABIOS processing and added ability to disallow a port to initialize.
;
;   Rev 1.0   16 Apr 1994 08:35:10   EMMETT
;Initial version control archive.
;
;************************************************************************

;   DEVHLP.INC

;These constants define the devhelp commands

DH_VA_READ_ACCESS         EQU 00h
DH_VA_READ_WRT_ACCESS     EQU 01h
DH_SIRQ_SHARED            EQU 01h
DH_SIRQ_NOT_SHARED        EQU 00h

DevHlp_Yield              EQU   02h          ;yield CPU
DevHlp_Block              EQU   04h          ;Block thread
DevHlp_Run                EQU   05h          ;unblock thread
DevHlp_SemRequest         EQU   06h
DevHlp_SemClear           EQU   07h
DevHlp_SemHandle          EQU   08h
DevHlp_PushReqPacket      EQU   09h
DevHlp_PullReqPacket      EQU   0ah
DevHlp_Lock               EQU   13h          ;Lock segment
DevHlp_Unlock             EQU   14h          ;Unlock segment
DevHlp_PhysToVirt         EQU   15h
DevHlp_VirtToPhys         EQU   16h          ;mark completion of PhysToVirt (obsolete)
DevHlp_PhysToUVirt        EQU   17h
DevHlp_AllocPhys          EQU   18h
DevHlp_FreePhys           EQU   19h
DevHlp_SetIRQ             EQU   1bh
DevHlp_ResetTimer         EQU   1eh
DevHlp_SetTimer           EQU   1dh
DevHlp_UnSetIRQ           EQU   1ch
DevHlp_GetDOSVar          EQU   24h
DevHlp_VerifyAccess       EQU   27h          ;Verify access to memory
DevHlp_AttachDD           EQU   2ah
DevHlp_AllocGDTSelector   EQU   2dh
DevHlp_PhysToGDTSelector  EQU   2eh
DevHlp_EOI                EQU   31h
DevHlp_UnPhysToVirt       EQU   32h
DevHlp_TickCount          EQU   33h
DevHlp_GetLIDEntry        EQU   34h
DevHlp_FreeLIDEntry       EQU   35h
DevHlp_ABIOSCall          EQU   36h
DevHlp_GetDeviceBlock     EQU   38h
DevHlp_RegisterStackUsage EQU   3ah
DevHlp_RegisterPDD        EQU   50h
DevHlp_Beep               EQU   52h
DevHlp_FreeGDTSelector    EQU   53h
DevHlp_PhysToGDTSel       EQU   54h
DevHlp_VMAlloc            EQU   57h
DevHlp_VMFree             EQU   58h
DevHlp_LinToGDTSelector   EQU   5ch
DevHlp_GetDescInfo        EQU   5dh
DevHlp_RegisterTmrDD      EQU   61h
DevHlp_VMSetMem           EQU   66h
DevHlp_DynamicAPI         EQU   6ch

s_stStackUsage STRUCT
        wStructLength   DW 14
        wFlags          DW 1
        wIRQlevel       DW ?
        wCLIcount       DW 8
        wSTIcount       DW 8
        wEOIcount       DW 0
        wNestLevel      DW 2
s_stStackUsage ENDS
