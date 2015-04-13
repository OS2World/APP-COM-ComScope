# Connect.mak
# Created by IBM WorkFrame/2 MakeMake at 21:08:45 on 14 July 1996
#
# The actions included in this make file are:
#  Compile::Resource Compiler
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind

.SUFFIXES: .c .obj .rc .res 

.all: \
    .\Connect.exe

.rc.res:
    @echo " Compile::Resource Compiler "
    rc.exe -r %s %|dpfF.RES

{p:\connect}.rc.res:
    @echo " Compile::Resource Compiler "
    rc.exe -r %s %|dpfF.RES

.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl10 /DNO_COMDD_INCLUDE /Sp1 /Ss /Q /Wall /Ti /N40 /W2 /Gm /Gs /Gx /Fb /Ft- /C %s

{p:\connect}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl10 /DNO_COMDD_INCLUDE /Sp1 /Ss /Q /Wall /Ti /N40 /W2 /Gm /Gs /Gx /Fb /Ft- /C %s

.\Connect.exe: \
    .\request.obj \
    .\response.obj \
    .\connect.obj \
    .\conn_dlg.obj \
    .\data.obj \
    .\connect.res \
    {$(LIB)}os2ls_ut.lib \
    {$(LIB)}connect.def \
    Connect.mak
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /B" /de /pmtype:pm /optfunc /nologo /m"
     /FeConnect.exe 
     os2ls_ut.lib 
     connect.def
     .\request.obj
     .\response.obj
     .\connect.obj
     .\conn_dlg.obj
     .\data.obj
<<
    rc.exe .\connect.res Connect.exe

!include "Connect.DEP"