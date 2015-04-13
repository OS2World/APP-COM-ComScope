# COMi_Ctl.mak
# Created by IBM WorkFrame/2 MakeMake at 23:47:29 on 14 Feb 2001
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind
#  Lib::Import Lib

.SUFFIXES:

.SUFFIXES: .LIB .c .dll .obj 

.all: f:\work\lib\COMi_Ctl.LIB

{p:\COMcontrol}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Sp1 /Sd /Ss /Q /Fi /Si /O /W1 /Gm /Gd /Ge- /G4 /Gn /Ms /Gf /Gi /Ft- /C %s

{f:\work\lib}.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe /NOLOGO f:\work\lib\%|fF.LIB %s

f:\work\lib\COMi_Ctl.dll: \
    .\comcontrol.obj \
    .\prot_hlp.obj \
    p:\COMcontrol\COMi_CTL.Res \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}OS2LS_UT.lib \
    {$(LIB)}OS2LS_IO.lib \
    .\\..\COMi_Ctl.def
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /nobase /nop /optfunc /noe /m /nod"
     /Fe"f:\work\lib\COMi_Ctl.dll" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     OS2LS_UT.lib 
     OS2LS_IO.lib 
     .\\..\COMi_Ctl.def
     .\comcontrol.obj
     .\prot_hlp.obj
<<
    rc.exe p:\COMcontrol\COMi_CTL.Res f:\work\lib\COMi_Ctl.dll

!include "COMi_Ctl.DEP"