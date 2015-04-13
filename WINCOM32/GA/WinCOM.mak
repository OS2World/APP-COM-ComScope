# WinCOM.mak
# Created by IBM WorkFrame/2 MakeMake at 11:42:27 on 13 Sept 2000
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind

.SUFFIXES:

.SUFFIXES: .c .obj 

.all: \
    f:\work\WinCOM.exe

.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Sp1 /Sd /Ss /Q /Fi /Si /Ti /O /W2 /Gm /Gd /G5 /Gn /Tm /Ms /Gf /Gi /Ft- /Gu /C %s

{p:\WinCOM32}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Sp1 /Sd /Ss /Q /Fi /Si /Ti /O /W2 /Gm /Gd /G5 /Gn /Tm /Ms /Gf /Gi /Ft- /Gu /C %s

{p:\WinCOM32\GA}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Sp1 /Sd /Ss /Q /Fi /Si /Ti /O /W2 /Gm /Gd /G5 /Gn /Tm /Ms /Gf /Gi /Ft- /Gu /C %s

f:\work\WinCOM.exe: \
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
    {$(LIB)}OS2LS_UT.lib \
    {$(LIB)}OS2LS_PR.lib \
    {$(LIB)}OS2LS_IO.lib \
    .\\..\WinCOM.def
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /de /exepack:2 /nobase /pmtype:pm /nop /noe /m /l /nod"
     /Fe"f:\work\WinCOM.exe" 
     CPPOM30.lib 
     OS2386.lib 
     CPPOM30O.lib 
     OS2LS_UT.lib 
     OS2LS_PR.lib 
     OS2LS_IO.lib 
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
    rc.exe p:\WinCOM32\WINCOM32.Res f:\work\WinCOM.exe

!include "WinCOM.DEP"