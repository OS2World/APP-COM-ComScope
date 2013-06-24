# os2ls_ut.mak
# Created by IBM WorkFrame/2 MakeMake at 23:54:28 on 23 Nov 1995
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Lib::Import Lib
#  MapSym::Map Symbols

.SUFFIXES: .LIB .MAP .c .dll .obj .sym

.all: \
    .\os2ls_ut.LIB \
    p:\utility\OS2LS_UT.LIB \
    .\OS2LS_UT.sym

.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl20 /Ip:\ /Sp1 /Ss /Q /Wall /Fi /Si /Ti /W2 /Gm /Gd /Ge- /Gx /Gu /C %s

.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe %|dpfF.LIB %s

.MAP.LIB:
    @echo " Lib::Import Lib "
    implib.exe %|dpfF.LIB %s

.dll.sym:
    @echo " MapSym::Map Symbols "
    mapsym.exe %s

.MAP.sym:
    @echo " MapSym::Map Symbols "
    mapsym.exe %s

.\os2ls_ut.dll: \
    .\utility.obj \
    {$(LIB)}os2ls_ut.def
    @echo " Link::Linker "
    icc.exe @<<
     /B" /pmtype:pm /nologo /m"
     /Feos2ls_ut.dll
     os2ls_ut.def
     .\utility.obj
<<

.\utility.obj: \
    p:\utility\utility.c

.\os2ls_ut.LIB: \
    .\os2ls_ut.dll

p:\utility\OS2LS_UT.LIB: \
    p:\utility\OS2LS_UT.MAP

.\os2ls_ut.sym: \
    .\os2ls_ut.dll

.\OS2LS_UT.sym: \
    p:\utility\OS2LS_UT.MAP
