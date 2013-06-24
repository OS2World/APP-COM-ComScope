PROJ = debug
PROJFILE = debug.MAK
DEBUG = 1

NMAKEBSC1  = set
NMAKEBSC2  = nmake
BROWSE  = 0
AFLAGS_G  = /Cp /DxVDD_support /nologo /Zp1
CFLAGS_G  = /Alfw /G2 /DxVDD_support /Zp /BATCH /nologo /NT_TEXT /Fc
CC  = cl
CFLAGS_D  = /Od /Zi /Gs
CFLAGS_R  = /Od /Zi /Gs
ASM  = ml
AFLAGS_D  = /Sg /Sn /Zf /Fl
AFLAGS_R  = /Sn
MAPFILE_D  = debug\$(PROJ).map
MAPFILE_R  = debug\$(PROJ).map
LFLAGS_G  =  /NOI /NOE /NOD /STACK:0  /BATCH /nologo
LFLAGS_D  = /M /NOF /NOP
LFLAGS_R  = /M /NOF /NOP
LINKER  = link
ILINK  = ilink
LRF  = echo > NUL
LLIBS_G  = comddLE.lib doscalls.lib rmcalls.lib OS2286.lib
CVFLAGS  = /50 /C"n16"
NMFLAGS  = /nologo
BIND  = bind

DEF_FILE  = COMDD.DEF
OBJS  = debug\Interrupt.obj debug\DataSegment.obj debug\COMDD.obj\
        debug\ExtenFuncs.obj debug\ProcessFlags.obj debug\Write.obj\
        debug\Read.obj debug\IOCTL.obj debug\UTIL.obj debug\INIT.obj\
        debug\UTILITY.obj debug\MCA.obj debug\C_INIT.obj debug\RMHELP.obj\
        debug\SPRINTF_large.obj debug\va_large.obj debug\PCI.obj\
        debug\HdwTest.obj debug\IniAccess.obj debug\InitUtil.obj

all: debug\$(PROJ).sys

.SUFFIXES:
.SUFFIXES: .obj .c .asm

debug\Interrupt.obj : Interrupt.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        DEVHLP.INC DCB.INC Hardware.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\Interrupt.obj Interrupt.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\Interrupt.obj Interrupt.asm
!ENDIF

debug\DataSegment.obj : DataSegment.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MESSAGE.DEF OEM_MSG.DEF
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\DataSegment.obj DataSegment.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\DataSegment.obj DataSegment.asm
!ENDIF

debug\COMDD.obj : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC Hardware.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\COMDD.obj COMDD.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\COMDD.obj COMDD.ASM
!ENDIF

debug\ExtenFuncs.obj : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC Hardware.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\ExtenFuncs.obj ExtenFuncs.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\ExtenFuncs.obj ExtenFuncs.asm
!ENDIF

debug\ProcessFlags.obj : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC Hardware.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\ProcessFlags.obj ProcessFlags.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\ProcessFlags.obj ProcessFlags.asm
!ENDIF

debug\Write.obj : Write.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC Hardware.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\Write.obj Write.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\Write.obj Write.asm
!ENDIF

debug\Read.obj : Read.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC Hardware.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\Read.obj Read.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\Read.obj Read.asm
!ENDIF

debug\IOCTL.obj : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC Hardware.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\IOCTL.obj IOCTL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\IOCTL.obj IOCTL.ASM
!ENDIF

debug\UTIL.obj : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC DCB.INC\
        DEVHLP.INC Hardware.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\UTIL.obj UTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\UTIL.obj UTIL.ASM
!ENDIF

debug\INIT.obj : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\INIT.obj INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\INIT.obj INIT.ASM
!ENDIF

debug\UTILITY.obj : UTILITY.C COMDD.H CUTIL.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fodebug\UTILITY.obj UTILITY.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fodebug\UTILITY.obj UTILITY.C
!ENDIF

debug\MCA.obj : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\MCA.obj MCA.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\MCA.obj MCA.ASM
!ENDIF

debug\C_INIT.obj : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        DCB.INC ABIOS.INC DEVHLP.INC Hardware.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\C_INIT.obj C_INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\C_INIT.obj C_INIT.ASM
!ENDIF

debug\RMHELP.obj : RMHELP.C rmcalls.h COMDD.H COMDCB.H CUTIL.H rmhelp.h
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fodebug\RMHELP.obj RMHELP.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fodebug\RMHELP.obj RMHELP.C
!ENDIF

debug\SPRINTF_large.obj : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fodebug\SPRINTF_large.obj SPRINTF_large.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fodebug\SPRINTF_large.obj SPRINTF_large.C
!ENDIF

debug\va_large.obj : va_large.asm SEGMENTS.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\va_large.obj va_large.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\va_large.obj va_large.asm
!ENDIF

debug\PCI.obj : PCI.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\PCI.obj PCI.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\PCI.obj PCI.asm
!ENDIF

debug\HdwTest.obj : HdwTest.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\HdwTest.obj HdwTest.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\HdwTest.obj HdwTest.asm
!ENDIF

debug\IniAccess.obj : IniAccess.c COMDD.H COMDCB.H CUTIL.H rmcalls.h message.c
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fodebug\IniAccess.obj IniAccess.c
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fodebug\IniAccess.obj IniAccess.c
!ENDIF

debug\InitUtil.obj : InitUtil.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC Hardware.inc MSG.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodebug\InitUtil.obj InitUtil.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodebug\InitUtil.obj InitUtil.asm
!ENDIF


debug\$(PROJ).sys : $(DEF_FILE) $(OBJS)
!IF $(DEBUG)
        $(LRF) @<<debug\$(PROJ).lrf
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
        $(LRF) @<<debug\$(PROJ).lrf
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
        $(LINKER) @debug\$(PROJ).lrf
!ELSE
        $(LINKER) @debug\$(PROJ).lrf
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


run: debug\$(PROJ).sys
        debug\$(PROJ).exe $(RUNFLAGS)

debug: debug\$(PROJ).sys
