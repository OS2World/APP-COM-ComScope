# Install.mak
# Created by IBM WorkFrame/2 MakeMake at 20:32:17 on 9 May 2000
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind

.SUFFIXES:

.SUFFIXES: .c .obj 

.all: \
    f:\work\Inst_DEB.exe

{p:\Install}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /DDEBUG=1 /Sp1 /Sd /Ss /Q /Fi /Si /Ti /W1 /Gm /Gd /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /Gu /C %s

f:\work\Inst_DEB.exe: \
    .\inst_dlg.obj \
    .\winstall.obj \
    .\help.obj \
    .\instutil.obj \
    p:\Install\INSTALL.RES \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}UTIL_DEB.lib
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /de /nobase /pmtype:pm /nop /noe /m /nod"
     /Fe"f:\work\Inst_DEB.exe" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     UTIL_DEB.lib 
     .\inst_dlg.obj
     .\winstall.obj
     .\help.obj
     .\instutil.obj
<<
    rc.exe p:\Install\INSTALL.RES f:\work\Inst_DEB.exe

!include "Install.DEP"