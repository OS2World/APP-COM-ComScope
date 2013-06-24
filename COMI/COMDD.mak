PROJ = COMDD
PROJFILE = COMDD.MAK
DEBUG = 1

AFLAGS  = /Cp /nologo /Zp1 /Sg /Sn /Zf /Fl$*.lst
CFLAGS  = /Alfw /G2 /Zp /BATCH /nologo /NT_TEXT /Fc$*.cod /Od /Zi /Gs
CC      = cl
ASM     = ml
MAPFILE = base\$(PROJ).map
LFLAGS  = /M /NOF /NOP /NOI /NOE /NOD /STACK:0  /BATCH /nologo
LINKER  = link
LRF     = echo > NUL
LLIBS   = comddLE.lib doscalls.lib rmcalls.lib OS2286.lib
NMFLAGS = /nologo
DEF_FILE= COMDD.DEF
OBJS    = base\Interrupt.obj base\DataSegment.obj base\COMDD.obj\
          base\ExtenFuncs.obj base\ProcessFlags.obj base\Write.obj\
          base\Read.obj base\IOCTL.obj base\UTIL.obj base\INIT.obj\
          base\UTILITY.obj base\MCA.obj base\C_INIT.obj base\RMHELP.obj\
          base\SPRINTF_large.obj base\va_large.obj base\PCI.obj\
          base\HdwTest.obj base\IniAccess.obj base\InitUtil.obj
          
all: base\$(PROJ).sys

.SUFFIXES:
.SUFFIXES: .obj .c .asm

base\COMDD.obj : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
                           MACRO.INC ABIOS.INC DEVHLP.INC Hardware.inc

base\Interrupt.obj : Interrupt.asm SEGMENTS.INC COMDD.INC MACRO.INC\
                                   DEVHLP.INC DCB.INC Hardware.inc

base\DataSegment.obj : DataSegment.asm SEGMENTS.INC COMDD.INC PACKET.INC\
                                       ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc\
                                       MESSAGE.DEF OEM_MSG.DEF

base\ExtenFuncs.obj : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
                                     PACKET.INC DEVHLP.INC DCB.INC Hardware.inc

base\ProcessFlags.obj : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
                                         PACKET.INC DEVHLP.INC DCB.INC Hardware.inc

base\Write.obj : Write.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
                           MACRO.INC ABIOS.INC DEVHLP.INC Hardware.inc

base\Read.obj : Read.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
                         ABIOS.INC DEVHLP.INC Hardware.inc

base\IOCTL.obj : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
                           DEVHLP.INC DCB.INC Hardware.inc

base\UTIL.obj : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC DCB.INC\
                         DEVHLP.INC Hardware.inc

base\INIT.obj : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
                         ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC

base\UTILITY.obj : UTILITY.C COMDD.H CUTIL.H

base\MCA.obj : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
                       ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC

base\C_INIT.obj : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
                             DCB.INC ABIOS.INC DEVHLP.INC Hardware.inc

base\RMHELP.obj : RMHELP.C rmcalls.h COMDD.H COMDCB.H CUTIL.H rmhelp.h

base\SPRINTF_large.obj : SPRINTF_large.C COMDD.H

base\va_large.obj : va_large.asm SEGMENTS.INC

base\PCI.obj : PCI.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
                       ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC

base\HdwTest.obj : HdwTest.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
                               ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC

base\IniAccess.obj : IniAccess.c COMDD.H COMDCB.H CUTIL.H rmcalls.h message.c

base\InitUtil.obj : InitUtil.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
                                 DCB.INC DEVHLP.INC Hardware.inc MSG.INC

base\$(PROJ).sys : $(DEF_FILE) $(OBJS)
        $(LRF) @<<base\$(PROJ).lrf
$(OBJS: = +^
)
$@
$(MAPFILE)
$(LLIBS: = +^
)
$(DEF_FILE) $(LFLAGS);
<<
  $(LINKER) @base\$(PROJ).lrf


.c{base}.obj :
  $(CC) /c $(CFLAGS) /Fo$@ $<

.asm{base}.obj :
  $(ASM) /c $(AFLAGS) /Fo$@ $<



