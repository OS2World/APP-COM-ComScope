PROJ = COMDDE
PROJFILE = COMDDE.MAK
DEBUG = 1

AFLAGS  = /Cp /nologo /DDEMO /Zp1 /Sg /Sn /Zf /Fl$*.lst
CFLAGS  = /Alfw /G2 /DDEMO /Zp /BATCH /nologo /NT_TEXT /Fc$*.cod /Od /Zi /Gs
CC      = cl
ASM     = ml
MAPFILE = eval\$(PROJ).map
LFLAGS  = /M /NOF /NOP /NOI /NOE /NOD /STACK:0  /BATCH /nologo
LINKER  = link
LRF     = echo > NUL
LLIBS   = comddLE.lib doscalls.lib rmcalls.lib OS2286.lib
NMFLAGS = /nologo
DEF_FILE= COMDD.DEF
OBJS    = eval\Interrupt.obj eval\DataSegment.obj eval\COMDD.obj\
          eval\ExtenFuncs.obj eval\ProcessFlags.obj eval\Write.obj\
          eval\Read.obj eval\IOCTL.obj eval\UTIL.obj eval\INIT.obj\
          eval\UTILITY.obj eval\MCA.obj eval\C_INIT.obj eval\RMHELP.obj\
          eval\SPRINTF_large.obj eval\va_large.obj eval\PCI.obj\
          eval\HdwTest.obj eval\IniAccess.obj eval\InitUtil.obj

all: eval\$(PROJ).sys

.SUFFIXES:
.SUFFIXES: .obj .c .asm

eval\Interrupt.obj : Interrupt.asm SEGMENTS.INC COMDD.INC MACRO.INC\
                                   DEVHLP.INC DCB.INC Hardware.inc

eval\DataSegment.obj : DataSegment.asm SEGMENTS.INC COMDD.INC PACKET.INC\
                                       ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc\
                                       MESSAGE.DEF OEM_MSG.DEF

eval\COMDD.obj : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
                           MACRO.INC ABIOS.INC DEVHLP.INC Hardware.inc

eval\ExtenFuncs.obj : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
                                     PACKET.INC DEVHLP.INC DCB.INC Hardware.inc

eval\ProcessFlags.obj : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
                                         PACKET.INC DEVHLP.INC DCB.INC Hardware.inc

eval\Write.obj : Write.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
                           MACRO.INC ABIOS.INC DEVHLP.INC Hardware.inc

eval\Read.obj : Read.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
                         ABIOS.INC DEVHLP.INC Hardware.inc

eval\IOCTL.obj : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
                           DEVHLP.INC DCB.INC Hardware.inc

eval\UTIL.obj : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC DCB.INC\
                         DEVHLP.INC Hardware.inc

eval\INIT.obj : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
                         ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC

eval\UTILITY.obj : UTILITY.C COMDD.H CUTIL.H

eval\MCA.obj : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
                       ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC

eval\C_INIT.obj : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
                             DCB.INC ABIOS.INC DEVHLP.INC Hardware.inc

eval\RMHELP.obj : RMHELP.C rmcalls.h COMDD.H COMDCB.H CUTIL.H rmhelp.h

eval\SPRINTF_large.obj : SPRINTF_large.C COMDD.H

eval\va_large.obj : va_large.asm SEGMENTS.INC

eval\PCI.obj : PCI.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
                       ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC

eval\HdwTest.obj : HdwTest.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
                               ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC

eval\IniAccess.obj : IniAccess.c COMDD.H COMDCB.H CUTIL.H rmcalls.h message.c

eval\InitUtil.obj : InitUtil.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
                                 DCB.INC DEVHLP.INC Hardware.inc MSG.INC

eval\$(PROJ).sys : $(DEF_FILE) $(OBJS)
        $(LRF) @<<eval\$(PROJ).lrf
$(OBJS: = +^
)
$@
$(MAPFILE)
$(LLIBS: = +^
)
$(DEF_FILE) $(LFLAGS);
<<
  $(LINKER) @eval\$(PROJ).lrf


.c{eval}.obj :
  $(CC) /c $(CFLAGS) /Fo$@ $<

.asm{eval}.obj :
  $(ASM) /c $(AFLAGS) /Fo$@ $<



