# OS2LS_TCPIP_SERVER.mak
# Created by IBM WorkFrame/2 MakeMake at 14:52:34 on 24 July 1996
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Lib::Import Lib

.SUFFIXES: .DLL .LIB .c .obj 

.all: \
    .\OS2LS_TCPIP_SERVER.LIB

.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl10 /Sp1 /Ss /Q /Wall /Ti /N40 /W2 /Gm /Ge- /Gs /Gx /Fb /Ft- /C %s

{p:\connect}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl10 /Sp1 /Ss /Q /Wall /Ti /N40 /W2 /Gm /Ge- /Gs /Gx /Fb /Ft- /C %s

.DLL.LIB:
    @echo " Lib::Import Lib "
    implib.exe %|dpfF.LIB %s

{p:\connect}.DLL.LIB:
    @echo " Lib::Import Lib "
    implib.exe %|dpfF.LIB %s

.\OS2LS_TCPIP_SERVER.DLL: \
    .\server.obj \
    {$(LIB)}tcp32dll.lib \
    {$(LIB)}so32dll.lib \
    {$(LIB)}os2ls_server.def \
    OS2LS_TCPIP_SERVER.mak
    @echo " Link::Linker "
    icc.exe @<<
     /B" /de /optfunc /nologo /m"
     /FeOS2LS_TCPIP_SERVER.DLL 
     tcp32dll.lib 
     so32dll.lib 
     os2ls_server.def
     .\server.obj
<<

!include "OS2LS_TCPIP_SERVER.DEP"