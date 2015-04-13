# SPL_DEB.mak
# Created by IBM WorkFrame/2 MakeMake at 20:31:32 on 9 May 2000
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind
#  Lib::Import Lib

.SUFFIXES:

.SUFFIXES: .LIB .PDR .c .obj 

.all: \
    f:\work\lib\SPL_DEB.LIB

{p:\Spooler}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /DDEBUG=1 /Sp1 /Sd /Ss /Q /Tx /Fi /Si /Ti /Op- /W1 /Gm /Gd /Ge- /G4 /Gn /Tm /Ms /Gf /Gi /Ft- /Gu /C %s

{f:\work\lib\}.PDR.LIB:
    @echo " Lib::Import Lib "
    implib.exe /NOLOGO f:\work\lib\%|fF.LIB %s

f:\work\lib\SPL_DEB.PDR: \
    .\spooler.obj \
    p:\Spooler\comi_spl.RES \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}IOCTLDEB.lib \
    .\\..\SPL_DEB.def
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /de /nobase /pmtype:pm /nop      /noe /m /nod"
     /Fe"f:\work\lib\SPL_DEB.PDR" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     IOCTLDEB.lib 
     .\\..\SPL_DEB.def
     .\spooler.obj
<<
    rc.exe p:\Spooler\comi_spl.RES f:\work\lib\SPL_DEB.PDR

!include "COMi_SPL.DEP"