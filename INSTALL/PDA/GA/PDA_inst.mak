# PDA_inst.mak
# Created by IBM WorkFrame/2 MakeMake at 22:25:22 on 15 Feb 2001
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Lib::Import Lib

.SUFFIXES:

.SUFFIXES: .LIB .c .dll .obj 

.all: \
    f:\work\lib\PDA_inst.LIB

{p:\Install\PDA}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Sp1 /Sd /Ss /Q /Fi /Si /O /W1 /Gm /Gd /Ge- /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /C %s

{f:\work\lib}.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe /NOLOGO f:\work\lib\%|fF.LIB %s

f:\work\lib\PDA_inst.dll: \
    .\comi.obj \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}OS2LS_UT.lib \
    .\\..\PDA_inst.def
    @echo " Link::Linker "
    icc.exe @<<
     /Q /B" /nobase /optfunc /noe /m /nod"
     /Fe"f:\work\lib\PDA_inst.dll" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     OS2LS_UT.lib 
     .\\..\PDA_inst.def
     .\comi.obj
<<

!include "PDA_inst.DEP"