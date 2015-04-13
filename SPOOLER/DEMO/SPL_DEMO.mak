# SPL_DEMO.mak
# Created by IBM WorkFrame/2 MakeMake at 0:08:49 on 26 Nov 1997
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind
#  Lib::Import Lib

.SUFFIXES:

.SUFFIXES: .LIB .PDR .c .obj 

.all: \
    f:\work\lib\SPL_DEMO.LIB

{P:\spooler}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Fo$*.obj /DINCLUDE_COMDD /DDEMO /Sp1 /Sd /Ss /Q /Wall /Fi /Si /O /W2 /Gm /Gd /Ge- /Gs /Gn /Ms /Gf /Gi /Ft- /Gu /C %s

{f:\work\lib}.PDR.LIB:
    @echo " Lib::Import Lib "
    implib.exe %|dpfF.LIB %s

f:\work\lib\SPL_DEMO.PDR: \
    .\spooler.obj \
    P:\spooler\comi_spl.RES \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2LS_UT.lib \
    {$(LIB)}OS2LS_IO.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}OS2386.lib \
    p:\Spooler\SPL_DEMO.def \
    SPL_DEMO.mak
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /exepack:2 /nobase /packd /optfunc /ig /noe /m /l /nod"
     /Fe"f:\work\lib\SPL_DEMO.PDR" 
     OS2LSRTL.lib 
     OS2LS_UT.lib 
     OS2LS_IO.lib 
     CPPOM30O.lib 
     OS2386.lib 
     p:\Spooler\SPL_DEMO.def
     .\spooler.obj
<<
    rc.exe P:\spooler\comi_spl.RES f:\work\lib\SPL_DEMO.PDR

!include "SPL_DEMO.DEP"