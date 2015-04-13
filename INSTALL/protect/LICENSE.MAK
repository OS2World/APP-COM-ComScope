PROJ = LICENSE
PROJFILE = LICENSE.MAK
DEBUG = 1

CC  = cl
CFLAGS_G  = /W3 /G2 /Zp /BATCH
CFLAGS_D  = /Od /Zi /Gs
CFLAGS_R  = /Ot /Ol /Og /Oe /Oi /Gs
ASM  = ml
AFLAGS_G  = /Cx /W2 /WX
AFLAGS_D  = /Zi
AFLAGS_R  = /nologo
MAPFILE_D  = NUL
MAPFILE_R  = NUL
LFLAGS_G  =  /NOI /NOE  /BATCH
LFLAGS_D  =  /CO /NOF /NOP
LFLAGS_R  =  /EXE /FAR /PACKC /PACKD
LINKER  = link
ILINK  = ilink
LRF  = echo > NUL
LLIBS_G  = c:\os2\doscalls.lib
CVFLAGS  =  /50 /C"n16"
BIND  = bind
RUNFLAGS  =  /h c:\ostools

OBJS  = LICENSE.obj UTIL.obj

all: $(PROJ).exe

.SUFFIXES:
.SUFFIXES: .obj .c

LICENSE.obj : LICENSE.C install.h

UTIL.obj : UTIL.C install.h


$(PROJ).exe : $(OBJS)
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
        $(LINKER) @$(PROJ).lrf
!ELSE
        $(LINKER) @$(PROJ).lrf
!ENDIF


.c.obj :
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fo$@ $<
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fo$@ $<
!ENDIF


run: $(PROJ).exe
        $(PROJ).exe $(RUNFLAGS)

debug: $(PROJ).exe
        CVP $(CVFLAGS) $(PROJ).exe $(RUNFLAGS)
