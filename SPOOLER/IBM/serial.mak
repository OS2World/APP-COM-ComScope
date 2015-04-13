PROJ = serial
PROJFILE = serial.mak
DEBUG = 0

PWBRMAKE  = pwbrmake
NMAKEBSC1  = set
NMAKEBSC2  = nmake
CC  = cl
CFLAGS_G  = /W2 /Zp /ML /ALw /G2 /D_MT /BATCH
CFLAGS_D  = /Gs /Gi$(PROJ).mdt /Zi /Od /FPa
CFLAGS_R  = /Ot /Oi /Ol /Oe /Og /Gs /FPa
ASM  = ml
AFLAGS_G  = /Cx /W2 /WX
AFLAGS_D  = /Zi
AFLAGS_R  = /nologo
MAPFILE_D  = NUL
MAPFILE_R  = NUL
LFLAGS_G  = /STACK:8192 /NOI /BATCH
LFLAGS_D  = /CO /INC /FAR /PACKC /PACKD /PMTYPE:PM
LFLAGS_R  = /EXE /FAR /PACKC /PACKD /PMTYPE:PM
LINKER  = link
ILINK  = ilink
LRF  = echo > NUL
RC  = rc
IMPLIB  = implib
LLIBS_R  = /NOD:LLIBCA LLIBCDLL
LLIBS_D  = /NOD:LLIBCA LLIBCDLL

DEF_FILE  = serial.def
OBJS  = serial.obj
SBRS  = serial.sbr

all: $(PROJ).dll

.SUFFIXES:
.SUFFIXES: .sbr .obj .c

serial.obj : serial.c serial.h port.h

serial.sbr : serial.c serial.h port.h


$(PROJ).bsc : $(SBRS)
        $(PWBRMAKE) @<<
$(BRFLAGS) $(SBRS)
<<

$(PROJ).dll : $(DEF_FILE) $(OBJS)
!IF $(DEBUG)
        $(LRF) @<<$(PROJ).lrf
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
        $(LRF) @<<$(PROJ).lrf
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
        $(ILINK) -a -e "$(LINKER) @$(PROJ).lrf" $@
!ELSE
        $(LINKER) @$(PROJ).lrf
!ENDIF
        $(IMPLIB) $*.lib $@


.c.sbr :
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FR$@ $<
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FR$@ $<
!ENDIF

.c.obj :
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fo$@ $<
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fo$@ $<
!ENDIF


run: $(PROJ).dll
        

debug: $(PROJ).dll
        
