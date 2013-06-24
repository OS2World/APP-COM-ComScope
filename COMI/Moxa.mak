PROJ = COMDD
PROJFILE = moxa.mak

AFLAGS  = /Cp /nologo /Zp1 /Sg /Sn /Zf /Fl /DMoxa 
CFLAGS  = /Alfw /G2 /Zp /BATCH /nologo /NT_TEXT /Fc /Od /Zi /Gs /DMoxa 
CC      = cl
ASM     = ml
MAPFILE = moxa\$(PROJ).map
LFLAGS  = /M /NOF /NOP /NOI /NOE /NOD /STACK:0 /BATCH /nologo
LINKER  = link
LRF     = echo > NUL
LLIBS   = comddLE.lib doscalls.lib rmcalls.lib OS2286.lib
DEF_FILE  = COMDD.DEF

OBJS  = moxa\Interrupt.obj moxa\DataSegment.obj moxa\COMDD.obj\
        moxa\ExtenFuncs.obj moxa\ProcessFlags.obj moxa\Write.obj\
        moxa\Read.obj moxa\IOCTL.obj moxa\UTIL.obj moxa\INIT.obj\
        moxa\UTILITY.obj moxa\MCA.obj moxa\C_INIT.obj moxa\RMHELP.obj\
        moxa\SPRINTF_large.obj moxa\va_large.obj moxa\PCI.obj\
        moxa\HdwTest.obj moxa\IniAccess.obj moxa\InitUtil.obj

all: moxa\$(PROJ).sys

.SUFFIXES:
.SUFFIXES: .obj .c .asm

moxa\Interrupt.obj : Interrupt.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        DEVHLP.INC DCB.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fomoxa\Interrupt.obj Interrupt.asm

moxa\DataSegment.obj : DataSegment.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MESSAGE.DEF OEM_MSG.DEF
  $(ASM) /c $(AFLAGS) /Fomoxa\DataSegment.obj DataSegment.asm

moxa\COMDD.obj : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fomoxa\COMDD.obj COMDD.ASM

moxa\ExtenFuncs.obj : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fomoxa\ExtenFuncs.obj ExtenFuncs.asm

moxa\ProcessFlags.obj : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fomoxa\ProcessFlags.obj ProcessFlags.asm

moxa\Write.obj : Write.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fomoxa\Write.obj Write.asm

moxa\Read.obj : Read.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fomoxa\Read.obj Read.asm

moxa\IOCTL.obj : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fomoxa\IOCTL.obj IOCTL.ASM

moxa\UTIL.obj : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC DCB.INC\
        DEVHLP.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fomoxa\UTIL.obj UTIL.ASM

moxa\INIT.obj : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
  $(ASM) /c $(AFLAGS) /Fomoxa\INIT.obj INIT.ASM

moxa\UTILITY.obj : UTILITY.C COMDD.H CUTIL.H
  $(CC) /c $(CFLAGS) /Fomoxa\UTILITY.obj UTILITY.C

moxa\MCA.obj : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
  $(ASM) /c $(AFLAGS) /Fomoxa\MCA.obj MCA.ASM

moxa\C_INIT.obj : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        DCB.INC ABIOS.INC DEVHLP.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Fomoxa\C_INIT.obj C_INIT.ASM

moxa\RMHELP.obj : RMHELP.C rmcalls.h COMDD.H COMDCB.H CUTIL.H rmhelp.h
  $(CC) /c $(CFLAGS) /Fomoxa\RMHELP.obj RMHELP.C

moxa\SPRINTF_large.obj : SPRINTF_large.C COMDD.H
  $(CC) /c $(CFLAGS) /Fomoxa\SPRINTF_large.obj SPRINTF_large.C

moxa\va_large.obj : va_large.asm SEGMENTS.INC
  $(ASM) /c $(AFLAGS) /Fomoxa\va_large.obj va_large.asm

moxa\PCI.obj : PCI.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
  $(ASM) /c $(AFLAGS) /Fomoxa\PCI.obj PCI.asm

moxa\HdwTest.obj : HdwTest.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
  $(ASM) /c $(AFLAGS) /Fomoxa\HdwTest.obj HdwTest.asm

moxa\IniAccess.obj : IniAccess.c COMDD.H COMDCB.H CUTIL.H rmcalls.h message.c
  $(CC) /c $(CFLAGS) /Fomoxa\IniAccess.obj IniAccess.c

moxa\InitUtil.obj : InitUtil.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC Hardware.inc MSG.INC
  $(ASM) /c $(AFLAGS) /Fomoxa\InitUtil.obj InitUtil.asm

moxa\$(PROJ).sys : $(DEF_FILE) $(OBJS)
        $(LRF) @<<moxa\$(PROJ).lrf
$(OBJS: = +^
)
$@
$(MAPFILE)
$(LLIBS: = +^
)
$(DEF_FILE) $(LFLAGS);
<<
  $(LINKER) @moxa\$(PROJ).lrf


.c.obj :
  $(CC) /c $(CFLAGS) /Fo$@ $<

.asm.obj :
  $(ASM) /c $(AFLAGS) /Fo$@ $<


