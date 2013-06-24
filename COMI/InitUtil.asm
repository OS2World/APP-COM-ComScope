;************************************************************************
;
; $Revision:   1.3  $
;
; $Log:   P:/archive/comi/initutil.asv  $
;
;     Rev 1.3   28 Mar 1996 00:20:06   EMMETT
;  Added resource manager.  Began work on VDD support.
;
;     Rev 1.2   18 Feb 1996 14:21:18   EMMETT
;  Added many features.  Notably:
;  Tracing of DosDevIOCtl function calls and packets.
;  Added 16650 and 16750 support.
;  Streamlined interrupt routine.
;
;     Rev 1.1   25 Apr 1995 22:16:46   EMMETT
;  Added Support for DigiBoard PC/16.  Changed interrupt Routine for better adapter independence.
;  Changed interrupt routine to allow user to select interrupting device selection algorithim.  Fixed
;  ABIOS interaction for better "non.INI" initialization in MCA machines.  Fixed various initialization
;  message strings.  COMscope and receive buffer are now allocated from system memory, allowing
;  a 32k (word) COMscope buffer and a 64k (byte) receive buffer.
;
;     Rev 1.0   03 Dec 1994 15:08:40   EMMETT
;  Initial archive.
;  File contains utilities used only during initialization.
;
;************************************************************************

  IFNDEF x16_BIT
.386P
  ELSE
.286P
  ENDIF
.NOLISTMACRO

.XLIST
    INCLUDE SEGMENTS.INC
    INCLUDE COMDD.INC
    INCLUDE PACKET.INC
    INCLUDE INITMACRO.INC
    INCLUDE DCB.INC
    INCLUDE DEVHLP.INC
    INCLUDE Hardware.inc
.LIST

    EXTRN VIOWRTTTY:FAR
    EXTRN KBDCHARIN:FAR

RES_DATA SEGMENT

    EXTRN wMiscControl          :WORD
    EXTRN stDeviceParms         :s_stDeviceParms
    EXTRN wClockRate            :WORD
    EXTRN wClockRate2           :WORD
    EXTRN wSystemDebug          :WORD
    EXTRN wLastEndOfData        :WORD
    EXTRN wEndOfData            :WORD
    EXTRN abyPath               :BYTE
    EXTRN wPCIvendor            :WORD
    EXTRN wPCIdevice            :WORD
  IFDEF DEMO
    EXTRN wWriteCountStart      :WORD
  ENDIF
    EXTRN device_hlp            :DWORD
  IFNDEF NO_4x_CLOCK_SUPPORT
    EXTRN dwTimerCounter        :DWORD
  ENDIF
    EXTRN wInitTimerCount       :WORD

RES_DATA ENDS

_DATA SEGMENT

.XLIST
   INCLUDE MSG.INC
.LIST

    EXTRN _szMessage            :BYTE

  IFNDEF x16_BIT
    EXTRN _awGDTselectors       :WORD
    EXTRN _stConfigParms        :s_stConfigParms
  ENDIF
  IFNDEF RTEST
   IFNDEF x16_BIT
    EXTRN _Ring0Vector          :DWORD
   ENDIF
    EXTRN _bWaitingKey          :WORD
    EXTRN _bDebugDelay          :WORD
    EXTRN _StackPointer         :WORD
    EXTRN _bVerbose             :WORD
    EXTRN _wSelectorCount       :WORD
    EXTRN _bTimerAvailable      :WORD
    EXTRN _abyCOMnumbers        :BYTE
    EXTRN _wCurrentDevice       :WORD
    EXTRN _bPrintLocation       :WORD
  ENDIF
    EXTRN _wInitDebugFlags      :WORD

    EXTRN _bDisableRM           :WORD

    EXTRN _abyNumber            :BYTE
    EXTRN _abyTemp              :BYTE
    EXTRN _abyString            :BYTE

_DATA ENDS

RES_CODE SEGMENT
    ASSUME CS:RCGROUP, ES:nothing, SS:nothing, DS:RDGROUP, GS:DGROUP

 IFNDEF x16_BIT
    EXTRN Ring0Access           :NEAR
 ELSE
    EXTRN _ProcessResponseFile  :NEAR
 ENDIF

  IFNDEF x16_BIT

MemorySetup PROC NEAR C uses ax bx cx dx es di ds si, wSelCount:WORD

;  int 3
        mov     cx,wSelCount
        or      cx,cx
        jz      error_exit

        mov     ax,DGROUP
        mov     es,ax
        mov     di,OFFSET _awGDTselectors
        mov     cx,wSelCount
  IFNDEF NO_COMscope
        shl     cx,1
  ENDIF
        mov     GS:_wSelectorCount,cx
        mov     dl,DevHlp_AllocGDTSelector
        call    device_hlp
        jc      error_exit

        mov     cx,wSelCount
        mov     si,OFFSET stDeviceParms
        mov     di,OFFSET _stConfigParms

alloc_loop:
        mov     ebx,DEF_READ_BUFF_LEN
        cmp     GS:[di].s_stConfigParms.cwReadBufferLength,ZERO
        je      store_read_buff_size
        xor     ebx,ebx
        mov     bx,GS:[di].s_stConfigParms.cwReadBufferLength
        cmp     bx,0ffffh
        jne     @f
        mov     ebx,MAX_READ_BUFF_LEN
        jmp     store_read_buff_size
@@:
        cmp     ebx,MIN_READ_BUFF_LEN
        jae     store_read_buff_size
        mov     ebx,MIN_READ_BUFF_LEN

store_read_buff_size:
        mov     [si].s_stDeviceParms.dwReadBufferLength,ebx

        mov     eax,ebx
        shr     eax,16
        mov     dx,DevHlp_AllocPhys
        call    device_hlp
        jnc     set_read_selector
        mov     dh,1
        call    device_hlp
        jc      error_exit

set_read_selector:
        push    si
        push    ecx
        push    bx
        mov     bx,cx
        dec     bx
  IFNDEF NO_COMscope
        shl     bx,2
  ELSE
        shl     bx,1
  ENDIF
        mov     ecx,[si].s_stDeviceParms.dwReadBufferLength
        mov     si,GS:_awGDTselectors[bx]
        pop     bx
        mov     dl,DevHlp_PhysToGDTSelector
        call    device_hlp
        pop     ecx
        pop     si
        jc      error_exit
        mov     bx,cx
        dec     bx
  IFNDEF NO_COMscope
        shl     bx,2
  ELSE
        shl     bx,1
  ENDIF
        mov     ax,GS:_awGDTselectors[bx]
        mov     [si].s_stDeviceParms.wRdBuffSelector,ax
        mov     eax,[si].s_stDeviceParms.dwReadBufferLength
        dec     eax
        mov     [si].s_stDeviceParms.dwReadBufferExtent,eax

  IFNDEF NO_COMscope
COMscopeBufferSetup:
        test    GS:[di].s_stConfigParms.cwDeviceFlags1,CFG_FLAG1_COMSCOPE
        jnz     @f
        dec     GS:_wSelectorCount
        mov     bx,cx
        dec     bx
        shl     bx,2
        mov     ax,GS:_awGDTselectors[bx + 2]
        mov     dl,DevHlp_FreeGDTSelector
        call    device_hlp
        mov     [si].s_stDeviceParms.wCOMscopeSelector,ds
        jmp     next

@@:
        mov     ebx,DEF_COMscope_BUFF_LEN
        cmp     GS:[di].s_stConfigParms.cwCOMscopeBuffLen,ZERO
        je      store_COMscope_buff_size
        xor     ebx,ebx
        mov     bx,GS:[di].s_stConfigParms.cwCOMscopeBuffLen
        cmp     ebx,MAX_COMscope_BUFF_LEN
        jbe     @f
        mov     ebx,MAX_COMscope_BUFF_LEN
        jmp     store_COMscope_buff_size

@@:
        cmp     ebx,MIN_COMscope_BUFF_LEN
        jae     store_COMscope_buff_size
        mov     ebx,MIN_COMscope_BUFF_LEN

store_COMscope_buff_size:
        shl     ebx,1
        mov     [si].s_stDeviceParms.dwCOMscopeBuffLen,ebx

        mov     eax,ebx
        shr     eax,16
        and     eax,0ffff0000h
        mov     dx,DevHlp_AllocPhys
        call    device_hlp
        jnc     set_COMscope_selector
        mov     dh,1
        call    device_hlp
        jc      error_exit

set_COMscope_selector:
        push    si
        push    ecx
        push    bx
        mov     bx,cx
        dec     bx
        shl     bx,2
        mov     ecx,[si].s_stDeviceParms.dwCOMscopeBuffLen
        mov     si,GS:_awGDTselectors[bx + 2]
        pop     bx
        mov     dl,DevHlp_PhysToGDTSelector
        call    device_hlp
        pop     ecx
        pop     si
        jc      error_exit
        mov     bx,cx
        dec     bx
        shl     bx,2
        mov     ax,GS:_awGDTselectors[bx + 2]
        mov     [si].s_stDeviceParms.wCOMscopeSelector,ax
        mov     eax,[si].s_stDeviceParms.dwCOMscopeBuffLen
        sub     eax,2
        mov     [si].s_stDeviceParms.dwCOMscopeBuffExtent,eax
  ENDIF ; NO_COMscope
next:
        add     si,TYPE s_stDeviceParms
        add     di,TYPE s_stConfigParms
        dec     cx
        jnz     alloc_loop

exit:
        clc
        ret

error_exit:
        stc
        ret

MemorySetup ENDP
  ENDIF

 IFNDEF RTEST
PrintString PROC USES cx bx es; AX to contain offset to string to print

        mov     bx,_DATA
        mov     es,bx
        mov     cx,600    ; limit characters to write (just in case)
        mov     bx,ax
        push    ax
        xor     ax,ax

count_loop:
        cmp     BYTE PTR ES:[bx],0
        je      print_string
        inc     bx
        inc     ax
        loop    count_loop

print_string:
        pop     bx
        push    es
        push    bx
        push    ax
        push    0
        call    FAR PTR VIOWRTTTY

        ret

PrintString ENDP

;--------------------------- binac_10 -------------------------------------

; converts byte to base 10 ASCII characters

binac_10 PROC USES cx    ;al = byte to convert
                         ;dl returns LSB, dh returns MSB
        cmp     al,0
        je      zero_all
        xor     ah,ah
        mov     cl,100
        div     cl            ;MOD 100 - TWO DIGITS MAX
        cmp     ah,0
        je      zero_all
        xchg    al,ah
        xor     ah,ah
        mov     cl,10
        div     cl
        mov     dl,ah
        add     dl,30h
        cmp     al,0
        je      zero_MSB
        xor     ah,ah
        div     cl
        mov     dh,ah
        add     dh,30h
        jmp     base_10_end

zero_all:
        mov     dl,'0'

zero_MSB:
        mov     dh,'0'

base_10_end:
        ret

binac_10 ENDP

; converts byte to base 16 ASCII characters

binac PROC NEAR USES ax bx cx ;al = byte to convert
                              ;dl returns LSB, dh returns MSB
        push    ax              ;save byte
        and     al,0fh          ;mask bottom four
        cmp     al,9            ;<= 9 ?
        jbe     numeral1        ;  then do number
        and     al,7            ;  else mask insignificant bits
        dec     al
        or      al,40h          ;append necessary bits
        jmp     $+4
numeral1:
        or      al,30h          ;append necessary bits
        pop     bx              ;get byte
        and     bl,0f0h         ;mask   top four bits
        shr     bl,4           ;shift four
        cmp     bl,9            ;<= 9 ?
        jbe     numeral2
        and     bl,7            ;mask insig bits
        dec     bl
        or      bl,40h          ;append necessary bits
        jmp     $+5
numeral2:
        or      bl,30h          ;append necessary bits
        mov     ah,bl           ;store top byte
        mov     dx,ax
        ret

binac ENDP

; converts ASCII string to binary WORD

ASCIItoBinary PROC NEAR USES bx si es

    LOCAL iIndex        :WORD
    LOCAL bBase16       :WORD
    LOCAL iIncIndex     :WORD
    LOCAL wTemp         :WORD
    LOCAL byTemp        :BYTE
    LOCAL wPower        :WORD
    LOCAL wAccumulator  :WORD

        mov     iIndex,0
        xor     ax,ax
        mov     cx,3
        lea     di,_abyTemp
        push    ds
        pop     es
        rep     stosw
        add     iIndex,6
        sub     si,si
$L20001:
        mov     bx,si
        inc     si
        cmp     GS:_abyNumber[bx],0
        jne     $L20001
        mov     iIndex,si
        sub     iIndex,2
        mov     bx,iIndex
        mov     al,GS:_abyNumber[bx]
        and     al,223
        cmp     al,72
        jne     $I137
        mov     bBase16,TRUE
        dec     iIndex
        jmp     $I138
$I137:
        mov     bBase16,FALSE
$I138:
        mov     iIncIndex,0
        cmp     iIndex,0
        jl      $FB141
        mov     di,iIncIndex
        mov     si,iIndex
$L20004:
        mov     al,GS:_abyNumber[si]
        mov     GS:_abyTemp[di],al
        dec     si
        inc     di
        or      si,si
        jge     $L20004
        mov     iIncIndex,di
        mov     iIndex,si
$FB141:
        mov     iIndex,0
        jmp     $L20020
$FC143:
        mov     bx,iIndex
        mov     al,GS:_abyTemp[bx]
        mov     byTemp,al
        sub     ah,ah
        cmp     ax,48
        jb      $L20017
        cmp     ax,57
        jbe     $SC149
        cmp     ax,65
        jb      $L20017
        cmp     ax,70
        jbe     $SC151
        cmp     ax,97
        jb      $L20017
        cmp     ax,102
        jbe     $SC150
        jmp     $L20017
$SC149:
        mov     al,byTemp
        sub     ah,ah
        sub     ax,48
$L20018:
        mov     wTemp,ax
$SB146:
        cmp     iIndex,0
        jne     $I154
        mov     ax,wTemp
        mov     wAccumulator,ax
        jmp     $I155
$SC150:
        and     byTemp,223
$SC151:
        cmp     bBase16,FALSE
        jne     $I152
$L20017:
        mov     wTemp,0
        jmp     $SB146
$I152:
        mov     al,byTemp
        sub     ah,ah
        sub     ax,55
        jmp     $L20018
$I154:
        mov     wPower,1
        cmp     bBase16,FALSE
        je      $I156
        mov     ax,iIndex
        mov     iIncIndex,ax
        jmp     $F157
$FC158:
        dec     iIncIndex
$F157:
        cmp     iIncIndex,0
        jle     $I160
        shl     wPower,4
        jmp     $FC158
$I156:
        mov     ax,iIndex
        mov     iIncIndex,ax
        jmp     $F161
$FC162:
        mov     ax,10
        mul     wPower
        mov     wPower,ax
        dec     iIncIndex
$F161:
        cmp     iIncIndex,0
        jg      $FC162
$I160:
        mov     ax,wTemp
        mul     wPower
        add     wAccumulator,ax
$I155:
        inc     iIndex
$L20020:
        mov     bx,iIndex
        cmp     GS:_abyTemp[bx],0
        je      $JCC331
        jmp     $FC143
$JCC331:
        mov     ax,wAccumulator
        ret

ASCIItoBinary  ENDP

;---------------------------- GetNumber --------------------------------

; extracts numeric value from command line

GetNumber      PROC NEAR

        push    di
        push    cx
        mov     di,0
byte_loop:
        mov     al,ES:[bx]
        cmp     al,0
        je      got_num_arg
        cmp     al,' '
        jne     @f
        jmp     got_num_arg
@@:
        cmp     al,','
        jne     @f
        jmp     got_num_arg
@@:
        cmp     al,'-'
        jne     @f
        jmp     got_num_arg
@@:
        cmp     al,'/'
        jne     @f
        jmp     got_num_arg
@@:
        mov     ah,al
        and     al,0dfh
        cmp     al,'T'
        je      got_num_arg
        cmp     al,'M'
        je      got_num_arg
        cmp     al,'Q'
        je      got_num_arg
        cmp     al,'P'
        je      got_num_arg
        cmp     al,'I'
        je      got_num_arg
        cmp     al,'R'
        je      got_num_arg
        cmp     al,'D'
        je      got_num_arg
        mov     GS:_abyNumber[di],ah
        inc     bx
        inc     di
        cmp     di,4
        ja      got_num_arg
        jmp     byte_loop

got_num_arg:
        mov     GS:_abyNumber[di],ZERO
        cmp     di,0
        je      @f
        call    ASCIItoBinary
        clc
        pop     cx
        pop     di
        ret
@@:
        stc
        pop     cx
        pop     di
        xor     ax,ax
        ret

GetNumber      ENDP ; AX=value - carry set and AX=0 if no number found

;--------------------------- ParseArguments -----------------------------

; parses device driver command line

ParseArguments PROC NEAR     ; ES:BX = address of command line
   IFDEF x16_BIT
        LOCAL bValidResponseFile:WORD

        mov     bValidResponseFile,FALSE
   ENDIF

;  int 3
parse_loop:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exit
        inc     bx

        cmp     al,'/'
        je      got_arg
        cmp     al,'-'
        je      got_arg

        cmp     al,'@'
        je      do_response
        jmp     parse_loop

got_arg:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exit
        inc     bx
        jmp     test_extension

parse_exit:
   IFDEF x16_BIT
        clc
        cmp     bValidResponseFile,TRUE
        je      @f
        stc
@@:
   ENDIF
        ret

test_extension:
        cmp     al,'L'                  ;print memory map
        jne     @f
        jmp     print_local
@@:
        cmp     al,'R'                  ;disable resoure manager
        jne     @f
        jmp     disable_RM
@@:
        cmp     al,'M'                  ;misc control,M#
        jne     @f
        jmp     set_misc_control
@@:
        cmp     al,'E'                  ;EXT-
        jne     @f
        jmp     set_extention
@@:
        cmp     al,'A'                  ;AG-TESTS
        jne     @f
        jmp     set_aggressive_tests
@@:
  IFDEF DEMO
        cmp     al,'W'                  ;W#
        jne     @f
        jmp     set_write_count
@@:
  ENDIF
        and     al,0dfh
        cmp     al,'Z'                  ;Z#
        jne     @f
        jmp     set_clock
@@:
        jmp     parse_loop

  IFDEF DEMO
set_write_count:
        call    GetNumber
        mov     wWriteCountStart,ax
        jmp     parse_loop
  ENDIF

set_clock:
        call    GetNumber
        mov     wClockRate,ax
        shl     ax,1
        mov     wClockRate2,ax
        jmp     parse_loop

set_aggressive_tests:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'G'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'-'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'T'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'E'
        je      @f
        jmp     test_sys
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'S'
        je      @f
        jmp     test_sys
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'T'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'S'
        je      set_test_flag
        jmp     parse_loop

set_test_flag:
        or      GS:_wInitDebugFlags,INIT_DEB_AGGRESSIVE_TESTS
        jmp     parse_loop

set_extention:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'X'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'T'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'-'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'I'
        je      @f
        jmp     test_sys
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'N'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'I'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'T'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'D'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'E'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'L'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'A'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        or      al,al
        je      parse_exitX
        inc     bx
        cmp     al,'Y'
        je      init_deb
        jmp     parse_loop

init_deb:
        mov     GS:_bDebugDelay,TRUE
        jmp     parse_loop

parse_exitX:
        ret

test_sys:
        cmp     al,'D'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        cmp     al,0
        je      parse_exitX
        inc     bx
        cmp     al,'E'
        je      @f
        jmp     parse_loop
@@:
        mov     al,ES:[bx]
        cmp     al,0
        je      parse_exitX
        inc     bx
        cmp     al,'B'
        je      ext_deb
        jmp     parse_loop

ext_deb:
        call    GetNumber
        mov     wSystemDebug,ax
        jmp     parse_loop

print_local:
        mov     GS:_bPrintLocation,TRUE
        jmp     parse_loop

disable_RM:
        mov     GS:_bDisableRM,TRUE
        jmp     parse_loop

set_misc_control:
        call    GetNumber
        mov     wMiscControl,ax
        jmp     parse_loop

do_response:
  IFDEF x16_BIT
        push    es
        push    bx
    SetDS     DGROUP
        mov     _StackPointer,sp
;  int 3
        call    _ProcessResponseFile
        mov     bx,_StackPointer
    SetDS     RDGROUP
        mov     sp,bx
        pop     bx
        pop     es
        inc     bx
        mov     GS:_bValidResponseFile,TRUE
        jmp     parse_loop

_response_file_error_return LABEL NEAR
;  int 3
        mov     bx,GS:_StackPointer
        mov     sp,bx
        pop     bx
        pop     es
  ELSE
        call    ChangeINIname
  ENDIF
        inc     bx
        jmp     parse_loop

ParseArguments ENDP

 IFNDEF x16_BIT
ChangeINIname PROC NEAR USES AX BX CX DX ES DI

        mov     di,OFFSET abyPath
        mov     cx,CCHMAXPATH
        xor     dx,dx

end_loop:
        cmp     BYTE PTR [di],' '
        je      found_end
        cmp     BYTE PTR [di],0
        je      found_end
        inc     dx
        cmp     BYTE PTR [di],'\'
        jne     @f
        xor     dx,dx
@@:
        inc     di
        loop    end_loop
        jmp     exit

found_end:
        sub     di,dx
        mov     cx,40    ; arbitrary length

fill_loop:
        mov     al,BYTE PTR ES:[bx]
        cmp     al,' '
        je      @f
        cmp     al,0
        je      @f
        cmp     al,'.'
        je      @f
        mov     BYTE PTR [di],al
        inc     bx
        inc     di
        loop    fill_loop

@@:
        mov     BYTE PTR [di],'.'
        inc     di
        mov     BYTE PTR [di],'S'
        inc     di
        mov     BYTE PTR [di],'Y'
        inc     di
        mov     BYTE PTR [di],'S'
        inc     di
        mov     BYTE PTR [di],0
exit:
        ret

ChangeINIname ENDP
 ENDIF

OutputProgress proc

        call    GetCOMnumber
        cmp     GS:_bVerbose,TRUE
        je      verbose_output

        INVOKE  sprintf,ADDR _szMessage,0,ADDR _szCOMmessage_u,bx
        INVOKE  PrintMessage,ADDR _szMessage,ax
        test    [si].s_stDeviceParms.wDeviceFlag2,DEV_FLAG2_FIFO_AVAILABLE
        jnz     @f
        jmp     newline_only
@@:
        mov     ax,OFFSET _szAnd
        call    PrintString
        jmp     send_FIFO_msg

verbose_output:
;        mov     cx,[si].s_stDeviceParms.wIObaseAddress
        xor     dx,dx
        mov     dl,[si].s_stDeviceParms.byInterruptLevel
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szVerboseMessage_uxu,bx,
                                      [si].s_stDeviceParms.wIObaseAddress,dx
        INVOKE PrintMessage,ADDR _szMessage,ax

; output user specified buffer sizes

        cmp     GS:[di].s_stConfigParms.cwReadBufferLength,ZERO
        je      @f
        mov     ebx,[si].s_stDeviceParms.dwReadBufferLength
;        or      ebx,ebx
;        jnz     not_max
;        mov     bx,0ffffh
;not_max:
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szInputBuff_lu,ebx
        INVOKE PrintMessage,ADDR _szMessage,ax
@@:
        cmp     GS:[di].s_stConfigParms.cwWrtBufferLength,ZERO
        je      @f
        xor     ebx,ebx
        mov     bx,[si].s_stDeviceParms.wWrtBufferLength
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szOutputBuff_lu,ebx
        INVOKE PrintMessage,ADDR _szMessage,ax
@@:
        cmp     GS:[di].s_stConfigParms.cwReadBufferLength,ZERO
        jne     @f
        cmp     GS:[di].s_stConfigParms.cwWrtBufferLength,ZERO
        jne     @f
        jmp     test_queue_counts
@@:
        mov     ax,OFFSET _szCR
        call    PrintString

test_queue_counts:

; output user specified queue counts

        cmp     GS:[di].s_stConfigParms.cbyMaxReadPktCount,ZERO
        je      @f
        xor     bx,bx
        mov     bl,[si].s_stDeviceParms.byMaxReadPktCount
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szInputQueue_u,bx
        INVOKE PrintMessage,ADDR _szMessage,ax
@@:
        cmp     GS:[di].s_stConfigParms.cbyMaxWritePktCount,ZERO
        je      @f
        xor     bx,bx
        mov     bl,[si].s_stDeviceParms.byMaxWritePktCount
        INVOKE sprintf,ADDR _szMessage,0,ADDR _szOutputQueue_u,bx
        INVOKE PrintMessage,ADDR _szMessage,ax
@@:
        cmp     GS:[di].s_stConfigParms.cbyMaxReadPktCount,ZERO
        jne     @f
        cmp     GS:[di].s_stConfigParms.cbyMaxWritePktCount,ZERO
        jne     @f
        jmp     test_indent_next
@@:
        mov     ax,OFFSET _szCR
        call    PrintString

test_indent_next:
        test    [si].s_stDeviceParms.wDeviceFlag2,DEV_FLAG2_FIFO_AVAILABLE
        jz      no_FIFO_to_report
        mov     ax,OFFSET _szBlankPad
        call    PrintString

send_FIFO_msg:
        mov     ax,OFFSET _szUART_is
        call    PrintString
        test_DeviceFlag2 DEV_FLAG2_16650_UART
        jz      test_16654
        mov     ax,OFFSET _szExtended16650
        jmp     print_UART_msg

test_16654:
        test_DeviceFlag2 DEV_FLAG2_16654_UART
        jz      test_TI16550C
        mov     ax,OFFSET _szExtended16654
        jmp     print_UART_msg

test_TI16550C:
        test_DeviceFlag2 DEV_FLAG2_TI16550C_UART
        jz      test_16750
        mov     ax,OFFSET _szExtendedTI16550C
        jmp     print_UART_msg

test_16750:
        test_DeviceFlag2 DEV_FLAG2_16750_UART
        jz      print_16550
        mov     ax,OFFSET _szExtended16750
        jmp     print_UART_msg

print_16550:
        mov     ax,OFFSET _szExtended16550

print_UART_msg:
        call    PrintString

  IFNDEF NO_4x_CLOCK_SUPPORT
IFDEF this_junk
        cmp     wPCIvendor,PCI_VENDOR_CONNECTECH
        jne     test_4x
        test    wPCIdevice,PCI_DEVICE_BLUEHEAT_MSK
        jz      test_4x
        mov     ax,OFFSET _szAnd12x
        jmp     baud_clock_msg
test_4x:
        test_DeviceFlag2 DEV_FLAG2_4x_BAUD_CLOCK
        jz      set_period
        mov     ax,OFFSET _szAnd4x
ELSE
        cmp     [si].s_stDeviceParms.xBaudMultiplier,1
        jbe     set_period
        mov     al,[si].s_stDeviceParms.xBaudMultiplier
        cmp     al, 4
        jne     @f
        mov     ax,OFFSET _szAnd4x
        jmp     baud_clock_msg
@@:
        cmp     al, 8
        jne     @f
        mov     ax,OFFSET _szAnd8x
        jmp     baud_clock_msg
@@:
        cmp     al, 12
        jne     @f
        mov     ax,OFFSET _szAnd12x
        jmp     baud_clock_msg
@@:
        cmp     al, 16
        jne     set_period
        mov     ax,OFFSET _szAnd16x
ENDIF
baud_clock_msg:
        call    PrintString
        jmp     newline_only

set_period:
  ENDIF
        mov     ax,OFFSET _szPeriod
        call    PrintString

newline_only:
        mov     ax,OFFSET _szCR
        call    PrintString

no_FIFO_to_report:
        ret

OutputProgress ENDP

CalcDelay PROC NEAR USES cx dx ; AX to contain delay in .1 second increments

        mov     cx,100
        mul     cx
        cmp     ax,wClockRate2
        jnc     @f
        mov     ax,2
        jmp     calc_end
@@:
        mov     cx,wClockRate
        or      cx,cx
        jnz     @f
        mov     ax,2   ;set arbitrary delay for unlikely case - zero clock spec
        jmp     calc_end
@@:
        xor     dx,dx
        div     cx
        shr     cx,1
        cmp     dx,cx
        jb      calc_end
        inc     ax                      ;round off

calc_end:
        ret

CalcDelay ENDP  ; AX to contain adjusted delay count

InitTimer PROC FAR USES DS

        pushf
     SetDS    RDGROUP
        cmp     wInitTimerCount,0
        je      @f
        dec     wInitTimerCount
@@:
  IFNDEF NO_4x_CLOCK_SUPPORT
        inc     dwTimerCounter
  ENDIF
        popf
        ret

InitTimer ENDP

DelayFunction PROC NEAR USES ax dx
; if timer count equals -1 then wait forever

  IFDEF this_junk
        cmp     wInitTimerCount,0ffffh
        je      wait_loop
        mov     ax,OFFSET InitTimer
        mov     dl,DevHlp_SetTimer
        call    init_device_hlp
        jnc     wait_loop
  ELSE
        cmp     GS:_bTimerAvailable,TRUE
        je      wait_loop
  IFNDEF x16_BIT
        mov     ecx,80000
        loop    $
  ELSE
        mov     ax,8
dly_loop:
        mov     cx,0
        loop    $
        dec     ax
        jnz    dly_loop
  ENDIF
        jmp     exit
  ENDIF
wait_loop:
        cmp     wInitTimerCount,0
        je      delay_exit
  IFNDEF _x16_BIT
        cmp     GS:_bWaitingKey,TRUE
        jne     wait_loop
        mov     WORD PTR GS:_abyString,0
        push    gs
        push    OFFSET _abyString
        push    1
        push    0
        call    FAR PTR KBDCHARIN
        cmp     GS:_abyString,ENTER_KEY
        je      delay_exit
        cmp     GS:_abyString,0
        je      wait_loop
        mov     WORD PTR GS:_abyString,0
        mov     bx,1000
        mov     cx,250
        mov     dl,DevHlp_Beep
        call    device_hlp
  ENDIF
        jmp     wait_loop

delay_exit:
  IFDEF this_junk
        cmp     wInitTimerCount,0ffffh
        je      exit
        mov     ax,OFFSET InitTimer
        mov     dl,DevHlp_ResetTimer
        call    device_hlp
  ENDIF
exit:
        ret

DelayFunction ENDP

GetCOMnumber PROC

        mov     bx,GS:_wCurrentDevice
        add     bx,OFFSET _abyCOMnumbers
        xor     ax,ax
        mov     al,GS:[bx]
        mov     bx,ax
        ret

GetCOMnumber ENDP ; BX = COM number (i.e., 1 for COM1)

StorePath PROC NEAR  USES ES DI; ES:BX is pointing to the parameter list

        mov     cx,CCHMAXPATH
        mov     di,bx

find_space_loop:
        cmp     BYTE PTR ES:[bx],' '
        je      @f
        inc     bx
        loop    find_space_loop
@@:
        mov     BYTE PTR ES:[bx],0
        inc     bx
        push    bx

        mov     CX,OFFSET _szVersion
        INVOKE sprintf,ADDR abyPath,0,ADDR _szPath_sss,
                                       di,ES,cx,GS,
                                       OFFSET _szVerMod,GS
        pop     bx
        ret

StorePath ENDP  ; BX will point to first parameyer
  ENDIF

  IFNDEF x16_BIT
SetRing0Access PROC USES ax bx cx dx di gs

;    SetGS     DGROUP
;        stc
;        jmp     exit
        cmp     GS:_Ring0Vector,0
        jne     exit
        mov     ax,SEG Ring0Access
        mov     bx,OFFSET Ring0Access
        mov     cx,6
        mov     dh,3
        mov     dl,DevHlp_DynamicAPI
        call    device_hlp
        jnc     @f
        jmp     exit
@@:
        mov     WORD PTR GS:_Ring0Vector + 2,di
        mov     WORD PTR GS:_Ring0Vector,OFFSET Ring0Access
exit:
        ret

SetRing0Access ENDP
  ENDIF

  IFDEF x16_BIT

_aNuldiv PROC C USES BX CX DX, ulValue:DWORD, ulDivisor:DWORD


        mov     cx,WORD PTR ulDivisor
        mov     ax,WORD PTR ulValue
        mov     dx,WORD PTR (ulValue + 2)
        mov     bx,WORD PTR (ulDivisor + 2)
        or      bx,bx
        jz      do_lower_16bit
        nop

do_lower_16bit:
        idiv    cx
        xor     dx,dx
        pop     dx
        pop     cx
        pop     bx
        pop     bp
        ret     8

_aNuldiv ENDP

_aNulrem PROC C USES BX CX DX, ulDivisor:DWORD, ulValue:DWORD

        mov     cx,WORD PTR (ulDivisor)
        mov     ax,WORD PTR (ulValue)
        mov     dx,WORD PTR (ulValue + 2)
        mov     bx,WORD PTR (ulDivisor + 2)
        or      bx,bx
        jz      do_lower_16bit
        nop

do_lower_16bit:
        idiv    cx
        mov     ax,dx
        pop     dx
        pop     cx
        pop     bx
        pop     bp
        ret     8

_aNulrem ENDP

  ENDIF

  IFDEF this_junk
_aNFauldiv PROC C USES BX CX DX ES, pulValue:FAR PTR,ulDivisor:DWORD

        mov     cx,WORD PTR (ulDivisor)
        les     bx,pulValue
        mov     ax,WORD PTR ES:[bx]
        mov     dx,WORD PTR ES:[bx + 2]
        mov     bx,WORD PTR (ulDivisor + 2)
        or      bx,bx
        jz      do_lower_16bit
        nop

do_lower_16bit:
        idiv    cx
        xor     dx,dx
        mov     WORD PTR [bx],ax
        mov     WORD PTR [bx + 2],dx
        pop     es
        pop     dx
        pop     cx
        pop     bx
        pop     bp
        ret     8

_aNFauldiv ENDP
  ENDIF
;--------------------------- INIT --------------------------------------
RES_CODE ENDS

  END
