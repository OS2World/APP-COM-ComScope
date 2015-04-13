PROJ = COMDD
PROJFILE = base.MAK
DEBUG = 1

AFLAGS  = /Cp /nologo /Zp1 /Sg /Sn /Zf /Fl
CFLAGS  = /Alfw /G2 /Zp /BATCH /nologo /NT_TEXT /Fc /Od /Zi /Gs
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

base\Interrupt.obj : Interrupt.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        DEVHLP.INC DCB.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fobase\Interrupt.obj Interrupt.asm

base\DataSegment.obj : DataSegment.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MESSAGE.DEF OEM_MSG.DEF
  $(ASM) /c $(AFLAGS) /Fobase\DataSegment.obj DataSegment.asm

base\COMDD.obj : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fobase\COMDD.obj COMDD.ASM

base\ExtenFuncs.obj : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fobase\ExtenFuncs.obj ExtenFuncs.asm

base\ProcessFlags.obj : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fobase\ProcessFlags.obj ProcessFlags.asm

base\Write.obj : Write.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fobase\Write.obj Write.asm

base\Read.obj : Read.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fobase\Read.obj Read.asm

base\IOCTL.obj : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fobase\IOCTL.obj IOCTL.ASM

base\UTIL.obj : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC DCB.INC\
        DEVHLP.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fobase\UTIL.obj UTIL.ASM

base\INIT.obj : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
  $(ASM) /c $(AFLAGS) /Fobase\INIT.obj INIT.ASM

base\UTILITY.obj : UTILITY.C COMDD.H CUTIL.H
  $(CC) /c $(CFLAGS) /Fobase\UTILITY.obj UTILITY.C

base\MCA.obj : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
  $(ASM) /c $(AFLAGS) /Fobase\MCA.obj MCA.ASM

base\C_INIT.obj : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        DCB.INC ABIOS.INC DEVHLP.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fobase\C_INIT.obj C_INIT.ASM

base\RMHELP.obj : RMHELP.C rmcalls.h COMDD.H COMDCB.H CUTIL.H rmhelp.h
  $(CC) /c $(CFLAGS) /Fobase\RMHELP.obj RMHELP.C

base\SPRINTF_large.obj : SPRINTF_large.C COMDD.H
  $(CC) /c $(CFLAGS) /Fobase\SPRINTF_large.obj SPRINTF_large.C

base\va_large.obj : va_large.asm SEGMENTS.INC
  $(ASM) /c $(AFLAGS) /Fobase\va_large.obj va_large.asm

base\PCI.obj : PCI.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
  $(ASM) /c $(AFLAGS) /Fobase\PCI.obj PCI.asm

base\HdwTest.obj : HdwTest.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
  $(ASM) /c $(AFLAGS) /Fobase\HdwTest.obj HdwTest.asm

base\IniAccess.obj : IniAccess.c COMDD.H COMDCB.H CUTIL.H rmcalls.h message.c
  $(CC) /c $(CFLAGS) /Fobase\IniAccess.obj IniAccess.c

base\InitUtil.obj : InitUtil.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC Hardware.inc MSG.INC
  $(ASM) /c $(AFLAGS) /Fobase\InitUtil.obj InitUtil.asm

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


.c.obj :
  $(CC) /c $(CFLAGS) /Fo$@ $<

.asm.obj :
  $(ASM) /c $(AFLAGS) /Fo$@ $<



