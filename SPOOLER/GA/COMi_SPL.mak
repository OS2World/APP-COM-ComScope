# COMi_SPL.mak
# Created by IBM WorkFrame/2 MakeMake at 9:05:22 on 15 Feb 2001
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind
#  Lib::Import Lib

.SUFFIXES:

.SUFFIXES: .PDR .LIB .c .obj 

.all: \
    f:\work\lib\COMi_SPL.PDR \
    f:\work\lib\COMi_SPL.LIB

{p:\Spooler}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Sp1 /Ss /Q /Wall /Fi /Si /O /W2 /Gm /Gd /Ge- /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /Gu /C %s
    
{f:\work\lib}.PDR.LIB:
    @echo " Lib::Import Lib "
    implib.exe /NOLOGO f:\work\lib\%|fF.LIB %s

f:\work\lib\COMi_SPL.PDR: \
    .\spooler.obj \
    p:\Spooler\comi_spl.RES \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}OS2LS_IO.lib \
    .\\..\COMi_SPL.def
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /nobase /nop      /noe /m /nod"
     /Fe"f:\work\lib\COMi_SPL.PDR" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     OS2LS_IO.lib 
     .\\..\COMi_SPL.def
     .\spooler.obj
<<
    rc.exe p:\Spooler\comi_spl.RES f:\work\lib\COMi_SPL.PDR

!include "COMi_SPL.DEP"