# PDB_DEB.mak
# Created by IBM WorkFrame/2 MakeMake at 20:37:12 on 9 May 2000
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Lib::Import Lib

.SUFFIXES:

.SUFFIXES: .LIB .c .dll .obj 

.all: \
    f:\work\lib\PDB_DEB.LIB \
    f:\work\lib\PDB_INST.LIB

.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /DDEBUG=1 /Sp1 /Ss /Q /Wall /Fi /Si /Ti /W2 /Gm /Gd /Ge- /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /Gu /C %s

{p:\Install\PDB}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /DDEBUG=1 /Sp1 /Ss /Q /Wall /Fi /Si /Ti /W2 /Gm /Gd /Ge- /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /Gu /C %s

{p:\Install\PDB\debug}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /DDEBUG=1 /Sp1 /Ss /Q /Wall /Fi /Si /Ti /W2 /Gm /Gd /Ge- /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /Gu /C %s

.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe /NOLOGO f:\work\lib\%|fF.LIB %s

{p:\Install\PDB}.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe /NOLOGO f:\work\lib\%|fF.LIB %s

{p:\Install\PDB\debug}.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe /NOLOGO f:\work\lib\%|fF.LIB %s

f:\work\lib\PDB_DEB.dll: \
    .\page.obj \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}UTIL_DEB.lib \
    .\\..\PDB_DEB.def
    @echo " Link::Linker "
    icc.exe @<<
     /Q /B" /de /nobase /nop      /noe /m /nod"
     /Fe"f:\work\lib\PDB_DEB.dll" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     UTIL_DEB.lib 
     .\\..\PDB_DEB.def
     .\page.obj
<<

!include "PDB_DEB.DEP"