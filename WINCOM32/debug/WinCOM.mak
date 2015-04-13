# WinCOM.mak
# Created by IBM WorkFrame/2 MakeMake at 20:30:30 on 9 May 2000
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind

.SUFFIXES:

.SUFFIXES: .c .obj 

.all: \
    f:\work\WinCOMbeta.exe

.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /DDEBUG=1 /Sp1 /Sd /Ss /Q /Tx /Fi /Si /Ti /Op- /W1 /Gm /Gd /G4 /Gn /Tm /Ms /Gf /Gi /Ft- /Gu /C %s

{p:\WinCOM32}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /DDEBUG=1 /Sp1 /Sd /Ss /Q /Tx /Fi /Si /Ti /Op- /W1 /Gm /Gd /G4 /Gn /Tm /Ms /Gf /Gi /Ft- /Gu /C %s

{p:\WinCOM32\debug}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /DDEBUG=1 /Sp1 /Sd /Ss /Q /Tx /Fi /Si /Ti /Op- /W1 /Gm /Gd /G4 /Gn /Tm /Ms /Gf /Gi /Ft- /Gu /C %s

f:\work\WinCOMbeta.exe: \
    .\util.obj \
    .\wincom.obj \
    .\comm.obj \
    .\dialog.obj \
    .\init.obj \
    .\strtrans.obj \
    .\terminal.obj \
    .\thread.obj \
    p:\WinCOM32\WINCOM32.Res \
    {$(LIB)}CPPOM30.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}UTIL_DEB.lib \
    {$(LIB)}PROFDEB.lib \
    {$(LIB)}IOCTLDEB.lib \
    .\\..\WinCOM.def
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /de /nobase /pmtype:pm /nop      /noe /m /nod"
     /Fe"f:\work\WinCOMbeta.exe" 
     CPPOM30.lib 
     OS2386.lib 
     CPPOM30O.lib 
     UTIL_DEB.lib 
     PROFDEB.lib 
     IOCTLDEB.lib 
     .\\..\WinCOM.def
     .\util.obj
     .\wincom.obj
     .\comm.obj
     .\dialog.obj
     .\init.obj
     .\strtrans.obj
     .\terminal.obj
     .\thread.obj
<<
    rc.exe p:\WinCOM32\WINCOM32.Res f:\work\WinCOMbeta.exe

!include "WinCOM.DEP"