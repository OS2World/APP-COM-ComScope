# OS2LS_ut.mak
# Created by IBM WorkFrame/2 MakeMake at 11:34:36 on 27 Mar 1999
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  MapSym::Map Symbols
#  Lib::Import Lib

.SUFFIXES:

.SUFFIXES: .C .LIB .dll .obj .sym 

.all: \
    f:\work\lib\OS2LS_ut.LIB

{P:\utility}.C.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Fo$*.obj /Sp1 /Sd /Ss /Q /Wall /Fi /Si /O /W2 /Gm /Gd /Ge- /Gs /Gn /Ms /Gf /Gi /Ft- /Gu /C %s

{f:\work\lib}.dll.sym:
    @echo " MapSym::Map Symbols "
    mapsym.exe %s

{f:\work\lib}.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe %|dpfF.LIB %s

f:\work\lib\OS2LS_ut.dll: \
    .\OS2LSRTL.obj \
    .\utility.obj \
    .\cfg_sys.obj \
    .\list.obj \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}OS2386.lib \
    p:\Utility\os2ls_ut.def \
    OS2LS_ut.mak
    @echo " Link::Linker "
    icc.exe @<<
     /Q /B" /exepack:2 /nobase /packd /optfunc /ig /noe /m /nod"
     /Fe"f:\work\lib\OS2LS_ut.dll" 
     OS2LSRTL.lib 
     CPPOM30O.lib 
     OS2386.lib 
     p:\Utility\os2ls_ut.def
     .\OS2LSRTL.obj
     .\utility.obj
     .\cfg_sys.obj
     .\list.obj
<<

!include "OS2LS_ut.DEP"