# MakeProf.mak
# Created by IBM WorkFrame/2 MakeMake at 18:31:24 on 14 Mar 1999
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker

.SUFFIXES:

.SUFFIXES: .c .obj 

.all: \
    f:\work\MakeProf.exe

{P:\install\makeprofile}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Fo$*.obj /Sp1 /Sd /Ss /Q /Wall /Tx /Fi /Si /Ti /W2 /Gm /Tm /Ms /Gf /Gi /Ft- /Gu /C %s

f:\work\MakeProf.exe: \
    .\makeprof.obj \
    .\makeprof.def \
    MakeProf.mak
    @echo " Link::Linker "
    icc.exe @<<
     /Q /B" /de /dbgpack /nobase /nop /m /l"
     /Fef:\work\MakeProf.exe 
     .\makeprof.def
     .\makeprof.obj
<<

!include "MakeProf.DEP"