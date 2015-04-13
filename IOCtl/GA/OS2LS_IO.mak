# os2ls_io.mak
# Created by IBM WorkFrame/2 MakeMake at 22:13:21 on 15 Feb 2001
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind
#  Lib::Import Lib

.SUFFIXES:

.SUFFIXES: .LIB .c .dll .obj 

.all: f:\work\lib\OS2ls_io.LIB

{p:\ioctl}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Sp1 /Sd /Ss /Q /Fi /Si /O /W1 /Gm /Gd /Ge- /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /Gu /C %s

{f:\work\lib}.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe /NOLOGO f:\work\lib\%|fF.LIB %s

f:\work\lib\OS2ls_io.dll: \
    .\ioctl.obj \
    p:\ioctl\ioctl.RES \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}OS2LS_UT.lib \
    .\\..\OS2LS_IO.def
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /nop /optfunc /noe /m /nod"
     /Fe"f:\work\lib\OS2ls_io.dll" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     OS2LS_UT.lib 
     .\\..\OS2LS_IO.def
     .\ioctl.obj
<<
    rc.exe p:\ioctl\ioctl.RES f:\work\lib\OS2ls_io.dll

!include "os2ls_io.DEP"