# client.mak
# Created by IBM WorkFrame/2 MakeMake at 13:32:58 on 21 Sept 1996
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Lib::Import Lib

.SUFFIXES: .LIB .c .dll .obj 

.all: \
    .\client.LIB

.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl10 /Sp1 /Ss /Q /Wall /Ti /N40 /W2 /Gm /Gd /Ge- /Gs /Fb /Ft- /Gu /C %s

{p:\results}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl10 /Sp1 /Ss /Q /Wall /Ti /N40 /W2 /Gm /Gd /Ge- /Gs /Fb /Ft- /Gu /C %s

{p:\connect\client}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl10 /Sp1 /Ss /Q /Wall /Ti /N40 /W2 /Gm /Gd /Ge- /Gs /Fb /Ft- /Gu /C %s

.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe %|dpfF.LIB %s

{p:\results}.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe %|dpfF.LIB %s

{p:\connect\client}.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe %|dpfF.LIB %s

.\client.dll: \
    .\client.obj \
    {$(LIB)}OS2LS_UT.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CLIENT.def \
    client.mak
    @echo " Link::Linker "
    icc.exe @<<
     /B" /de /br /pmtype:pm /optfunc /nologo /noe /m /nod"
     /Feclient.dll 
     OS2LS_UT.lib 
     CPPOM30O.lib 
     OS2386.lib 
     CLIENT.def
     .\client.obj
<<

!include "client.DEP"