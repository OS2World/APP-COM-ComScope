# Install.mak
# Created by IBM WorkFrame/2 MakeMake at 8:55:41 on 15 Feb 2001
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind

.SUFFIXES:

.SUFFIXES: .c .obj 

.all: \
    f:\work\Install.exe

{p:\Install}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Sp1 /Sd /Ss /Q /Fi /Si /O /W1 /Gm /Gd /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /Gu /C %s

f:\work\Install.exe: \
    .\inst_dlg.obj \
    .\winstall.obj \
    .\help.obj \
    .\instutil.obj \
    p:\Install\INSTALL.Res \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}OS2LS_UT.lib \
    .\\..\Install.def
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /exepack:2 /pmtype:pm /packd /optfunc      /noe /m /nod"
     /Fe"f:\work\Install.exe" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     OS2LS_UT.lib 
     .\\..\Install.def
     .\inst_dlg.obj
     .\winstall.obj
     .\help.obj
     .\instutil.obj
<<
    rc.exe p:\Install\INSTALL.Res f:\work\Install.exe

!include "Install.DEP"