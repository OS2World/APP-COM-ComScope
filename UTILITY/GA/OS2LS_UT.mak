# UTIL_DEB.mak
# Created by IBM WorkFrame/2 MakeMake at 9:48:14 on 23 April 2000
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker

.SUFFIXES:

.SUFFIXES: .C .obj 

.all: \
    f:\work\lib\OS2LS_UT.dll

{p:\utility}.C.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Sp1 /Sd /Ss /Q /Fi /Si /O /W1 /Gm /Gd /Ge- /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /C %s

{f:\work\lib}.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe /NOLOGO f:\work\lib\%|fF.LIB %s

f:\work\lib\OS2LS_UT.dll: \
    .\OS2LSRTL.obj \
    .\utility.obj \
    .\cfg_sys.obj \
    .\list.obj \
    {$(LIB)}os2lsrtl.lib \
    {$(LIB)}os2386.lib \
    {$(LIB)}CPPOM30O.lib \
    .\\..\OS2LS_UT.def
    @echo " Link::Linker "
    icc.exe @<<
     /Q /B" /nobase /nop /optfunc /noe /m /nod"
     /Fe"f:\work\lib\OS2LS_UT.dll" 
     os2lsrtl.lib 
     os2386.lib 
     CPPOM30O.lib 
     .\\..\OS2LS_UT.def
     .\OS2LSRTL.obj
     .\utility.obj
     .\cfg_sys.obj
     .\list.obj
<<

!include "OS2LS_UT.DEP"