PROJ = COMDD
PROJFILE = ConnectTech.MAK
DEBUG = 1

AFLAGS  = /Cp /nologo /DConnecTech /Zp1 /Sg /Sn /Zf /Fl$*.lst
CFLAGS  = /Alfw /G2 /Zp /DConnecTech /BATCH /nologo /NT_TEXT /Fc$*.cod /Od /Zi /Gs
CC      = cl
ASM     = ml
MAPFILE = ConnectTech\$(PROJ).map
LFLAGS  = /M /NOF /NOP /NOI /NOE /NOD /STACK:0  /BATCH /nologo
LINKER  = link
LRF     = echo > NUL
LLIBS   = comddLE.lib doscalls.lib rmcalls.lib OS2286.lib
NMFLAGS = /nologo
DEF_FILE= COMDD.DEF
OBJS    = ConnectTech\Interrupt.obj ConnectTech\DataSegment.obj ConnectTech\COMDD.obj\
          ConnectTech\ExtenFuncs.obj ConnectTech\ProcessFlags.obj ConnectTech\Write.obj\
          ConnectTech\Read.obj ConnectTech\IOCTL.obj ConnectTech\UTIL.obj ConnectTech\INIT.obj\
          ConnectTech\UTILITY.obj ConnectTech\MCA.obj ConnectTech\C_INIT.obj ConnectTech\RMHELP.obj\
          ConnectTech\SPRINTF_large.obj ConnectTech\va_large.obj ConnectTech\PCI.obj\
          ConnectTech\HdwTest.obj ConnectTech\IniAccess.obj ConnectTech\InitUtil.obj

all: ConnectTech\$(PROJ).sys

.SUFFIXES:
.SUFFIXES: .obj .c .asm

ConnectTech\Interrupt.obj : Interrupt.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        DEVHLP.INC DCB.INC Hardware.inc

ConnectTech\DataSegment.obj : DataSegment.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MESSAGE.DEF OEM_MSG.DEF

ConnectTech\COMDD.obj : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC Hardware.inc

ConnectTech\ExtenFuncs.obj : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC Hardware.inc

ConnectTech\ProcessFlags.obj : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC Hardware.inc

ConnectTech\Write.obj : Write.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC Hardware.inc

ConnectTech\Read.obj : Read.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC Hardware.inc

ConnectTech\IOCTL.obj : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC Hardware.inc

ConnectTech\UTIL.obj : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC DCB.INC\
        DEVHLP.INC Hardware.inc

ConnectTech\INIT.obj : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC

ConnectTech\UTILITY.obj : UTILITY.C COMDD.H CUTIL.H

ConnectTech\MCA.obj : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC

ConnectTech\C_INIT.obj : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        DCB.INC ABIOS.INC DEVHLP.INC Hardware.inc

ConnectTech\RMHELP.obj : RMHELP.C rmcalls.h COMDD.H COMDCB.H CUTIL.H rmhelp.h

ConnectTech\SPRINTF_large.obj : SPRINTF_large.C COMDD.H

ConnectTech\va_large.obj : va_large.asm SEGMENTS.INC

ConnectTech\PCI.obj : PCI.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC

ConnectTech\HdwTest.obj : HdwTest.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC

ConnectTech\IniAccess.obj : IniAccess.c COMDD.H COMDCB.H CUTIL.H rmcalls.h message.c

ConnectTech\InitUtil.obj : InitUtil.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC Hardware.inc MSG.INC

ConnectTech\$(PROJ).sys : $(DEF_FILE) $(OBJS)
        $(LRF) @<<ConnectTech\$(PROJ).lrf
$(OBJS: = +^
)
$@
$(MAPFILE)
$(LLIBS: = +^
)
$(DEF_FILE) $(LFLAGS);
<<
  $(LINKER) @ConnectTech\$(PROJ).lrf


.c{ConnectTech}.obj :
  $(CC) /c $(CFLAGS) /Fo$@ $<

.asm{ConnectTech}.obj :
  $(ASM) /c $(AFLAGS) /Fo$@ $<



