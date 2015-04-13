# OS2LS_UT.mak
# Created by IBM WorkFrame/2 MakeMake at 0:00:30 on 14 Feb 2001
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Lib::Import Lib

.SUFFIXES:

.SUFFIXES: .C .LIB .dll .obj 

.all: f:\work\lib\\UTIL_DEB.LIB

{p:\utility}.C.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Sp1 /Sd /Ss /Q /Fi /Si /O /W1 /Gm /Gd /Ge- /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /C %s

{f:\work\lib}.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe /NOLOGO f:\work\lib\%|fF.LIB %s

f:\work\lib\UTIL_DEB.dll: \
    .\utility.obj \
    .\cfg_sys.obj \
    .\list.obj \
    .\OS2LSRTL.obj \
    {$(LIB)}os2lsrtl.lib \
    {$(LIB)}os2386.lib \
    {$(LIB)}CPPOM30O.lib \
    .\\..\UTIL_DEB.def
    @echo " Link::Linker "
    icc.exe @<<
     /Q /B" /nobase /nop /optfunc /noe /m /nod"
     /Fe"f:\work\lib\UTIL_DEB.dll" 
     os2lsrtl.lib 
     os2386.lib 
     CPPOM30O.lib 
     .\\..\UTIL_DEB.def
     .\utility.obj
     .\cfg_sys.obj
     .\list.obj
     .\OS2LSRTL.obj
<<

!include "OS2LS_UT.DEP"