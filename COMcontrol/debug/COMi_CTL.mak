# COMi_CTL.mak
# Created by IBM WorkFrame/2 MakeMake at 20:03:24 on 14 Feb 2001
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind
#  Lib::Import Lib

.SUFFIXES:

.SUFFIXES: .LIB .c .dll .obj 

.all: f:\Work\lib\\COMi_CTL.LIB

{p:\COMcontrol}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /DDEBUG=1 /Sp1 /Sd /Ss /Q /Tx /Fi /Si /Ti /Op- /W1 /Gm /Gd /Ge- /G4 /Gn /Tm /Ms /Gf /Gi /Ft- /Gu /Fa /C %s

{f:\Work\Lib}.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe /NOLOGO f:\work\lib\%|fF.LIB %s

f:\work\lib\COMi_CTL.dll: \
    .\prot_hlp.obj \
    .\comcontrol.obj \
    p:\COMcontrol\COMi_CTL.Res \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}UTIL_DEB.lib \
    {$(LIB)}IOCTLDEB.lib \
    .\\..\Ctl_DEB.def
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /de /nobase /nop /optfunc      /noe /m /l /nod"
     /Fe"f:\work\lib\COMi_CTL.dll" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     UTIL_DEB.lib 
     IOCTLDEB.lib 
     .\\..\Ctl_DEB.def
     .\prot_hlp.obj
     .\comcontrol.obj
<<
    rc.exe p:\COMcontrol\COMi_CTL.Res f:\work\lib\COMi_CTL.dll

!include "COMi_CTL.DEP"