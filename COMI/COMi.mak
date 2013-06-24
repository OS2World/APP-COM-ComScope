# COMi.mak
# Created by IBM WorkFrame/2 MakeMake at 22:26:07 on 1 Nov 1997
#
# The actions included in this make file are:
#  Compile::Assembler (ml)
#  Compile::C Compiler (cl)
#  Link::Linker

.SUFFIXES:

.SUFFIXES: \
    .C .asm .obj 

.asm.obj:
    @echo " Compile::Assembler (ml) "
    ml.exe /Cp /DxVDD_support /nologo /Zp1 /Sn /Zf /Fl %s

{P:\COMi}.asm.obj:
    @echo " Compile::Assembler (ml) "
    ml.exe /Cp /DxVDD_support /nologo /Zp1 /Sn /Zf /Fl %s

.C.obj:
    @echo " Compile::C Compiler (cl) "
    cl.exe /Alfw /G2 /DxVDD_support /Zp /BATCH /nologo /NT_TEXT /Fc /Od /Gs %s

{P:\COMi}.C.obj:
    @echo " Compile::C Compiler (cl) "
    cl.exe /Alfw /G2 /DxVDD_support /Zp /BATCH /nologo /NT_TEXT /Fc /Od /Gs %s

all: \
    .\COMDD.SYS

.\COMDD.SYS: \
    .\va_large.obj \
    .\VDDUTIL.obj \
    .\MESSAGE.obj \
    .\PRELOAD.obj \
    .\PROTECT.obj \
    .\RMHELP.obj \
    .\SPRINTF_large.obj \
    .\UTILITY.obj \
    .\VDD.obj \
    .\COMDD.obj \
    .\C_INIT.obj \
    .\DATA_SEG.obj \
    .\ExtenFuncs.obj \
    .\HDW_TEST.obj \
    .\INIT.obj \
    .\INITUTIL.obj \
    .\INT.obj \
    .\IOCTL.obj \
    .\MCA.obj \
    .\ProcessFlags.obj \
    .\UTIL.obj \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}COMDD.def
    @echo " Link::Linker "
    icc.exe @<<
     /B" /noe /m /nod"
     /FeCOMDD.SYS 
     OS2LSRTL.lib 
     CPPOM30O.lib 
     OS2386.lib 
     COMDD.def
     .\va_large.obj
     .\VDDUTIL.obj
     .\MESSAGE.obj
     .\PRELOAD.obj
     .\PROTECT.obj
     .\RMHELP.obj
     .\SPRINTF_large.obj
     .\UTILITY.obj
     .\VDD.obj
     .\COMDD.obj
     .\C_INIT.obj
     .\DATA_SEG.obj
     .\ExtenFuncs.obj
     .\HDW_TEST.obj
     .\INIT.obj
     .\INITUTIL.obj
     .\INT.obj
     .\IOCTL.obj
     .\MCA.obj
     .\ProcessFlags.obj
     .\UTIL.obj
<<

.\va_large.obj: \
    P:\COMi\va_large.asm

.\UTIL.obj: \
    P:\COMi\UTIL.ASM

.\ProcessFlags.obj: \
    P:\COMi\ProcessFlags.asm

.\MCA.obj: \
    P:\COMi\MCA.ASM

.\IOCTL.obj: \
    P:\COMi\IOCTL.ASM

.\INT.obj: \
    P:\COMi\INT.ASM

.\INITUTIL.obj: \
    P:\COMi\INITUTIL.ASM

.\INIT.obj: \
    P:\COMi\INIT.ASM

.\HDW_TEST.obj: \
    P:\COMi\HDW_TEST.ASM

.\ExtenFuncs.obj: \
    P:\COMi\ExtenFuncs.asm

.\DATA_SEG.obj: \
    P:\COMi\DATA_SEG.ASM

.\C_INIT.obj: \
    P:\COMi\C_INIT.ASM

.\COMDD.obj: \
    P:\COMi\COMDD.ASM

.\VDD.obj: \
    P:\COMi\VDD.ASM

.\UTILITY.obj: \
    P:\COMi\UTILITY.C

.\SPRINTF_large.obj: \
    P:\COMi\SPRINTF_large.C

.\RMHELP.obj: \
    P:\COMi\RMHELP.C

.\PROTECT.obj: \
    P:\COMi\PROTECT.C

.\PRELOAD.obj: \
    P:\COMi\PRELOAD.C

.\MESSAGE.obj: \
    P:\COMi\MESSAGE.c

.\VDDUTIL.obj: \
    P:\COMi\VDDUTIL.C
