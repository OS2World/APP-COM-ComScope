# COMi.mak
# Created by IBM WorkFrame/2 MakeMake at 23:38:32 on 1 Nov 1997
#
# The actions included in this make file are:
#  Compile::Assembler (ml)
#  Compile::C Compiler (cl)
#  Link::Device driver link
#  MapSym::Map Symbols

.SUFFIXES:

.SUFFIXES: \
    .ASM .C .map .obj .sym 

.ASM.obj:
    @echo " Compile::Assembler (ml) "
    ml.exe /Cp /DxVDD_support /nologo /Zp1 /Sn /Zf /Fl %s

{p:\COMi\base}.ASM.obj:
    @echo " Compile::Assembler (ml) "
    ml.exe /Cp /DxVDD_support /nologo /Zp1 /Sn /Zf /Fl %s

{P:\COMi}.ASM.obj:
    @echo " Compile::Assembler (ml) "
    ml.exe /Cp /DxVDD_support /nologo /Zp1 /Sn /Zf /Fl %s

.C.obj:
    @echo " Compile::C Compiler (cl) "
    cl.exe /Alfw /G2 /DxVDD_support /Zp /BATCH /nologo /NT_TEXT /Fc /Od /Gs %s

{p:\COMi\base}.C.obj:
    @echo " Compile::C Compiler (cl) "
    cl.exe /Alfw /G2 /DxVDD_support /Zp /BATCH /nologo /NT_TEXT /Fc /Od /Gs %s

{P:\COMi}.C.obj:
    @echo " Compile::C Compiler (cl) "
    cl.exe /Alfw /G2 /DxVDD_support /Zp /BATCH /nologo /NT_TEXT /Fc /Od /Gs %s

.map.sym:
    @echo " MapSym::Map Symbols "
    mapsym.exe %s

{p:\COMi\base}.map.sym:
    @echo " MapSym::Map Symbols "
    mapsym.exe %s

{P:\COMi}.map.sym:
    @echo " MapSym::Map Symbols "
    mapsym.exe %s

all: \
    .\COMDD.sys \
    .\COMDD.sym

.\COMDD.sys: \
    .\SPRINTF_large.obj \
    .\va_large.obj \
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
    .\UTILITY.obj \
    .\MESSAGE.obj \
    .\PRELOAD.obj \
    .\PROTECT.obj \
    .\RMHELP.obj
    @echo " Link::Device driver link "
    link.exe /NOI /NOE /NOD /STACK:0 /BATCH /nologo /M /NOF /NOP .\SPRINTF_large.obj+.\va_large.obj+.\COMDD.obj+.\C_INIT.obj+.\DATA_SEG.obj+.\ExtenFuncs.obj+.\HDW_TEST.obj+.\INIT.obj+.\INITUTIL.obj+.\INT.obj+.\IOCTL.obj+.\MCA.obj+.\ProcessFlags.obj+.\UTIL.obj+.\UTILITY.obj+.\MESSAGE.obj+.\PRELOAD.obj+.\PROTECT.obj+.\RMHELP.obj,  COMDD.SYS, COMDD.map, comddLE.lib+doscalls.lib+rmcalls.lib,COMDD.DEF

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

.\va_large.obj: \
    P:\COMi\va_large.asm

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

.\UTILITY.obj: \
    P:\COMi\UTILITY.C

.\COMDD.sym: \
    p:\COMi\base\COMDD.map
