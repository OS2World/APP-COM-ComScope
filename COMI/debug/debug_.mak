# debug_.mak
# Created by IBM WorkFrame/2 MakeMake at 9:07:19 on 23 April 2000
#
# The actions included in this make file are:
#  Compile::C Compiler (cl)
#  Compile::Assembler (ml)
#  Link::Linker (16 bit)

.SUFFIXES:

.SUFFIXES: .asm .c .obj 

.all: \
    .\va_large.sys

.c.obj:
    @echo " Compile::C Compiler (cl) "
    cl.exe cl.exe /c  /Fo$*.obj /Gs /Od /Asfw /G2 /Zp /BATCH /nologo /NT_TEXT /Fc %s

{p:\comi}.c.obj:
    @echo " Compile::C Compiler (cl) "
    cl.exe cl.exe /c  /Fo$*.obj /Gs /Od /Asfw /G2 /Zp /BATCH /nologo /NT_TEXT /Fc %s

{p:\comi\debug}.c.obj:
    @echo " Compile::C Compiler (cl) "
    cl.exe cl.exe /c  /Fo$*.obj /Gs /Od /Asfw /G2 /Zp /BATCH /nologo /NT_TEXT /Fc %s

.asm.obj:
    @echo " Compile::Assembler (ml) "
    ml.exe /c /Cp /W2 /Sn /Fl /Zf /Zp1 /nologo /Fo$*.obj %s

{p:\comi}.asm.obj:
    @echo " Compile::Assembler (ml) "
    ml.exe /c /Cp /W2 /Sn /Fl /Zf /Zp1 /nologo /Fo$*.obj %s

{p:\comi\debug}.asm.obj:
    @echo " Compile::Assembler (ml) "
    ml.exe /c /Cp /W2 /Sn /Fl /Zf /Zp1 /nologo /Fo$*.obj %s

.\va_large.sys: \
    .\va_large.obj \
    .\Utility.obj \
    .\IniAccess.obj \
    .\Message.obj \
    .\RMhelp.obj \
    .\sprintf_large.obj \
    .\Write.obj \
    .\COMDD.obj \
    .\C_Init.obj \
    .\DataSegment.obj \
    .\ExtenFuncs.obj \
    .\HdwTest.obj \
    .\Init.obj \
    .\InitUtil.obj \
    .\Interrupt.obj \
    .\IOCTL.obj \
    .\MCA.obj \
    .\PCI.obj \
    .\ProcessFlags.obj \
    .\Read.obj \
    .\Util.obj
    @echo " Link::Linker (16 bit) "
    f:\ibmcpp\dtools\link.exe /NOI /NOE /NOD /STACK:0  /BATCH /nologo /NOP /M /NOF .\va_large.obj .\Utility.obj .\IniAccess.obj .\Message.obj .\RMhelp.obj .\sprintf_large.obj .\Write.obj .\COMDD.obj .\C_Init.obj .\DataSegment.obj .\ExtenFuncs.obj .\HdwTest.obj .\Init.obj .\InitUtil.obj .\Interrupt.obj .\IOCTL.obj .\MCA.obj .\PCI.obj .\ProcessFlags.obj .\Read.obj .\Util.obj, Debug_.sys,,,

!include "debug_.DEP"