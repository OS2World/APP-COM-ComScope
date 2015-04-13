# spooltest.mak
# Created by IBM WorkFrame/2 MakeMake at 7:57:53 on 27 Oct 1996
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind
#  Compile::Resource Compiler

.SUFFIXES: .c .obj .rc .res 

.all: \
    .\spooltest.exe

.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl1 /DINCLUDE_COMDD /DDEBUGGER=1 /Sp1 /Sd /Ss /Q /Wall /Tx /Ti /W2 /Gm /Gd /Tm /Ms /Gf /Ft- /Gu /C %s

{P:\spooler\extra}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Tl1 /DINCLUDE_COMDD /DDEBUGGER=1 /Sp1 /Sd /Ss /Q /Wall /Tx /Ti /W2 /Gm /Gd /Tm /Ms /Gf /Ft- /Gu /C %s

.rc.res:
    @echo " Compile::Resource Compiler "
    rc.exe -r %s %|dpfF.RES

{P:\spooler\extra}.rc.res:
    @echo " Compile::Resource Compiler "
    rc.exe -r %s %|dpfF.RES

.\spooltest.exe: \
    .\serialt.obj \
    .\serialt.res \
    {$(LIB)}UTIL_DEB.lib \
    {$(LIB)}IOCTLDEB.lib \
    {$(LIB)}spooltest.def \
    spooltest.mak
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /B" /de /dbgpack /m"
     /Fespooltest.exe 
     UTIL_DEB.lib 
     IOCTLDEB.lib 
     spooltest.def
     .\serialt.obj
<<
    rc.exe .\serialt.res spooltest.exe

!include "spooltest.DEP"