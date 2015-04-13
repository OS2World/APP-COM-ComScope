# connect.mak
# Created by IBM WorkFrame/2 MakeMake at 13:26:12 on 21 Sept 1996
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind

.SUFFIXES: .c .obj 

.all: \
    .\connect.exe

.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl10 /Sp1 /Ss /Q /Wall /Ti /N40 /W2 /Gm /Gs /Fb /Ft- /C %s

{p:\include}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl10 /Sp1 /Ss /Q /Wall /Ti /N40 /W2 /Gm /Gs /Fb /Ft- /C %s

{p:\connect\results}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl10 /Sp1 /Ss /Q /Wall /Ti /N40 /W2 /Gm /Gs /Fb /Ft- /C %s

{p:\connect}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl10 /Sp1 /Ss /Q /Wall /Ti /N40 /W2 /Gm /Gs /Fb /Ft- /C %s

.\connect.exe: \
    .\request.obj \
    .\response.obj \
    .\connect.obj \
    .\conn_dlg.obj \
    .\data.obj \
    p:\connect\CONNECT.Res \
    {$(LIB)}os2ls_ut.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}connect.def \
    connect.mak
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /B" /de /pmtype:pm /optfunc /nologo /noe /m /nod"
     /Feconnect.exe 
     os2ls_ut.lib 
     OS2386.lib 
     CPPOM30O.lib 
     connect.def
     .\request.obj
     .\response.obj
     .\connect.obj
     .\conn_dlg.obj
     .\data.obj
<<
    rc.exe p:\connect\CONNECT.Res connect.exe

!include "connect.DEP"