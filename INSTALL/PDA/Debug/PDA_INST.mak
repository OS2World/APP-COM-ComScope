# PDA_DEB.mak
# Created by IBM WorkFrame/2 MakeMake at 22:25:54 on 15 Feb 2001
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Lib::Import Lib

.SUFFIXES:

.SUFFIXES: .LIB .c .dll .obj 

.all: \
    f:\work\lib\PDA_DEB.LIB

{p:\Install\PDA}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Sp1 /Ss /Q /Tx /Fi /Si /Ti /Op- /W1 /Gm /Gd /Ge- /G4 /Gn /Tm /Ms /Gf /Gi /Ft- /Gu /Fa /C %s

{f:\work\lib}.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe /NOLOGO f:\work\lib\%|fF.LIB %s

f:\work\lib\PDA_DEB.dll: \
    .\comi.obj \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}UTIL_DEB.lib \
    .\\..\PDA_DEB.def
    @echo " Link::Linker "
    icc.exe @<<
     /Q /B" /de /nobase /nop      /noe /m /l /nod"
     /Fe"f:\work\lib\PDA_DEB.dll" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     UTIL_DEB.lib 
     .\\..\PDA_DEB.def
     .\comi.obj
<<

!include "PDA_INST.DEP"