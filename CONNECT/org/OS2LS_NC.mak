# OS2LS_NC.mak
# Created by IBM WorkFrame/2 MakeMake at 18:01:53 on 14 July 1996
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Lib::Import Lib

.SUFFIXES: .DLL .LIB .c .obj 

.all: \
    .\OS2LS_NC.LIB

.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl10 /DNO_COMDD_INCLUDE /Sp1 /Ss /Q /Wall /Ti /N40 /W2 /Gm /Ge- /Gs /Gx /Fb /Ft- /C %s

{p:\connect}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl10 /DNO_COMDD_INCLUDE /Sp1 /Ss /Q /Wall /Ti /N40 /W2 /Gm /Ge- /Gs /Gx /Fb /Ft- /C %s

.DLL.LIB:
    @echo " Lib::Import Lib "
    implib.exe %|dpfF.LIB %s

{p:\connect}.DLL.LIB:
    @echo " Lib::Import Lib "
    implib.exe %|dpfF.LIB %s

.\OS2LS_NC.DLL: \
    .\main.obj \
    .\server.obj \
    .\client.obj \
    {$(LIB)}so32dll.lib \
    {$(LIB)}tcp32dll.lib \
    {$(LIB)}os2ls_nc.def \
    OS2LS_NC.mak
    @echo " Link::Linker "
    icc.exe @<<
     /B" /de /pmtype:pm /optfunc /nologo /m"
     /FeOS2LS_NC.DLL 
     so32dll.lib 
     tcp32dll.lib 
     os2ls_nc.def
     .\main.obj
     .\server.obj
     .\client.obj
<<

!include "OS2LS_NC.DEP"