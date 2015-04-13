PROJ = m16_bit
PROJFILE = m16_bit.MAK
DEBUG = 1

BRFLAGS  =  /Es /Em
PWBRMAKE  = pwbrmake
NMAKEBSC1  = set
NMAKEBSC2  = nmake
BROWSE  = 0
BREXCLUDE  = i:\include\os2.h i:\masm\include\os2.inc\
        i:\masm\include\bseerr.inc I:\MASM\INCLUDE\BSEDEV.INC\
        I:\MASM\INCLUDE\BSEDOS.INC I:\MASM\INCLUDE\BSEERR.INC\
        I:\MASM\INCLUDE\BSESUB.INC I:\MASM\INCLUDE\OS2.INC\
        I:\MASM\INCLUDE\OS2DEF.INC I:\MASM\INCLUDE\BSE.INC I:\INCLUDE\BSE.H\
        I:\INCLUDE\BSEDEV.H I:\INCLUDE\BSEDOS.H I:\INCLUDE\BSESUB.H\
        I:\INCLUDE\DOS.H
CC  = cl
CFLAGS_G  = /Asnw /W2 /G2 /Dx16_BIT /Zp /BATCH /Fa
CFLAGS_D  = /Od /FPa /Zi /Gs
CFLAGS_R  = /Od /FPa /Gs
ASM  = ml
AFLAGS_G  = /Cp /W2 /DRTEST /Dx16_BIT
AFLAGS_D  = /Zi /Zf /Fl
AFLAGS_R  = /Zf /nologo
MAPFILE_D  = m16_BIT\$(PROJ).map
MAPFILE_R  = NUL
LFLAGS_G  =  /NOI /NOE
LFLAGS_D  =  /CO /M /NOF /NOP  /PMTYPE:VIO
LFLAGS_R  =  /EXE /FAR /PACKC /PACKD  /PMTYPE:VIO
LINKER  = link
ILINK  = ilink
LRF  = echo > NUL
LLIBS_G  = p:\comi\doscalls.lib
RUNFLAGS  = c:\comm\comdd.sys Version

OBJS  = m16_BIT\MAIN.obj m16_BIT\PRELOAD.obj m16_BIT\UTILITY.obj\
        m16_BIT\RESPONSE.obj m16_BIT\INITUTIL.obj m16_BIT\m16_bit.obj

all: m16_BIT\$(PROJ).exe

.SUFFIXES:
.SUFFIXES: .obj .c .asm

m16_BIT\MAIN.obj : MAIN.C w:\v60\include\os2.h COMDD.H COMDCB.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fom16_BIT\MAIN.obj MAIN.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fom16_BIT\MAIN.obj MAIN.C
!ENDIF

m16_BIT\PRELOAD.obj : PRELOAD.C COMDD.H COMDCB.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fom16_BIT\PRELOAD.obj PRELOAD.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fom16_BIT\PRELOAD.obj PRELOAD.C
!ENDIF

m16_BIT\UTILITY.obj : UTILITY.C COMDD.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fom16_BIT\UTILITY.obj UTILITY.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fom16_BIT\UTILITY.obj UTILITY.C
!ENDIF

m16_BIT\RESPONSE.obj : RESPONSE.C COMDD.H COMDCB.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fom16_BIT\RESPONSE.obj RESPONSE.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fom16_BIT\RESPONSE.obj RESPONSE.C
!ENDIF

m16_BIT\INITUTIL.obj : INITUTIL.ASM COMDD.INC PACKET.INC MACRO.INC DCB.INC\
        DEVHLP.INC HDW.INC MESSAGE.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fom16_BIT\INITUTIL.obj INITUTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fom16_BIT\INITUTIL.obj INITUTIL.ASM
!ENDIF

m16_BIT\m16_bit.obj : m16_bit.asm
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fom16_BIT\m16_bit.obj m16_bit.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fom16_BIT\m16_bit.obj m16_bit.asm
!ENDIF


m16_BIT\$(PROJ).bsc : 

m16_BIT\$(PROJ).exe : $(OBJS)
!IF $(DEBUG)
        $(LRF) @<<m16_BIT\$(PROJ).lrf
$(RT_OBJS: = +^
) $(OBJS: = +^
)
$@
$(MAPFILE_D)
$(LLIBS_G: = +^
) +
$(LLIBS_D: = +^
) +
$(LIBS: = +^
)
$(DEF_FILE) $(LFLAGS_G) $(LFLAGS_D);
<<
!ELSE
        $(LRF) @<<m16_BIT\$(PROJ).lrf
$(RT_OBJS: = +^
) $(OBJS: = +^
)
$@
$(MAPFILE_R)
$(LLIBS_G: = +^
) +
$(LLIBS_R: = +^
) +
$(LIBS: = +^
)
$(DEF_FILE) $(LFLAGS_G) $(LFLAGS_R);
<<
!ENDIF
!IF $(DEBUG)
        $(LINKER) @m16_BIT\$(PROJ).lrf
!ELSE
        $(LINKER) @m16_BIT\$(PROJ).lrf
!ENDIF


.c.obj :
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fo$@ $<
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fo$@ $<
!ENDIF

.asm.obj :
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fo$@ $<
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fo$@ $<
!ENDIF


run: m16_BIT\$(PROJ).exe
        m16_BIT\$(PROJ).exe $(RUNFLAGS)

debug: m16_BIT\$(PROJ).exe
        CVP $(CVFLAGS) m16_BIT\$(PROJ).exe $(RUNFLAGS)
