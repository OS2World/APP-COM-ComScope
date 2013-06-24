PROJ = COMDD
PROJFILE = globe.mak

AFLAGS  = /Cp /nologo /Zp1 /Sg /Sn /Zf /Fl /DGlobetek 
CFLAGS  = /Alfw /G2 /Zp /BATCH /nologo /NT_TEXT /Fc /Od /Zi /Gs /DGlobetek 
CC      = cl
ASM     = ml
MAPFILE = globe\$(PROJ).map
LFLAGS  = /M /NOF /NOP /NOI /NOE /NOD /STACK:0 /BATCH /nologo
LINKER  = link
LRF     = echo > NUL
LLIBS   = comddLE.lib doscalls.lib rmcalls.lib OS2286.lib
DEF_FILE  = COMDD.DEF

OBJS  = globe\Interrupt.obj globe\DataSegment.obj globe\COMDD.obj\
        globe\ExtenFuncs.obj globe\ProcessFlags.obj globe\Write.obj\
        globe\Read.obj globe\IOCTL.obj globe\UTIL.obj globe\INIT.obj\
        globe\UTILITY.obj globe\MCA.obj globe\C_INIT.obj globe\RMHELP.obj\
        globe\SPRINTF_large.obj globe\va_large.obj globe\PCI.obj\
        globe\HdwTest.obj globe\IniAccess.obj globe\InitUtil.obj

all: globe\$(PROJ).sys

.SUFFIXES:
.SUFFIXES: .obj .c .asm

globe\Interrupt.obj : Interrupt.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        DEVHLP.INC DCB.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Foglobe\Interrupt.obj Interrupt.asm

globe\DataSegment.obj : DataSegment.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MESSAGE.DEF OEM_MSG.DEF
  $(ASM) /c $(AFLAGS) /Foglobe\DataSegment.obj DataSegment.asm

globe\COMDD.obj : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Foglobe\COMDD.obj COMDD.ASM

globe\ExtenFuncs.obj : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Foglobe\ExtenFuncs.obj ExtenFuncs.asm

globe\ProcessFlags.obj : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Foglobe\ProcessFlags.obj ProcessFlags.asm

globe\Write.obj : Write.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Foglobe\Write.obj Write.asm

globe\Read.obj : Read.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Foglobe\Read.obj Read.asm

globe\IOCTL.obj : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Foglobe\IOCTL.obj IOCTL.ASM

globe\UTIL.obj : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC DCB.INC\
        DEVHLP.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Foglobe\UTIL.obj UTIL.ASM

globe\INIT.obj : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
  $(ASM) /c $(AFLAGS) /Foglobe\INIT.obj INIT.ASM

globe\UTILITY.obj : UTILITY.C COMDD.H CUTIL.H
  $(CC) /c $(CFLAGS) /Foglobe\UTILITY.obj UTILITY.C

globe\MCA.obj : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
  $(ASM) /c $(AFLAGS) /Foglobe\MCA.obj MCA.ASM

globe\C_INIT.obj : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        DCB.INC ABIOS.INC DEVHLP.INC Hardware.inc
  $(ASM) /c $(AFLAGS) /Foglobe\C_INIT.obj C_INIT.ASM

globe\RMHELP.obj : RMHELP.C rmcalls.h COMDD.H COMDCB.H CUTIL.H rmhelp.h
  $(CC) /c $(CFLAGS) /Foglobe\RMHELP.obj RMHELP.C

globe\SPRINTF_large.obj : SPRINTF_large.C COMDD.H
  $(CC) /c $(CFLAGS) /Foglobe\SPRINTF_large.obj SPRINTF_large.C

globe\va_large.obj : va_large.asm SEGMENTS.INC
  $(ASM) /c $(AFLAGS) /Foglobe\va_large.obj va_large.asm

globe\PCI.obj : PCI.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
  $(ASM) /c $(AFLAGS) /Foglobe\PCI.obj PCI.asm

globe\HdwTest.obj : HdwTest.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC
  $(ASM) /c $(AFLAGS) /Foglobe\HdwTest.obj HdwTest.asm

globe\IniAccess.obj : IniAccess.c COMDD.H COMDCB.H CUTIL.H rmcalls.h message.c
  $(CC) /c $(CFLAGS) /Foglobe\IniAccess.obj IniAccess.c

globe\InitUtil.obj : InitUtil.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC Hardware.inc MSG.INC
  $(ASM) /c $(AFLAGS) /Foglobe\InitUtil.obj InitUtil.asm

globe\$(PROJ).sys : $(DEF_FILE) $(OBJS)
        $(LRF) @<<globe\$(PROJ).lrf
$(OBJS: = +^
)
$@
$(MAPFILE)
$(LLIBS: = +^
)
$(DEF_FILE) $(LFLAGS);
<<
  $(LINKER) @globe\$(PROJ).lrf


.c.obj :
  $(CC) /c $(CFLAGS) /Fo$@ $<

.asm.obj :
  $(ASM) /c $(AFLAGS) /Fo$@ $<


