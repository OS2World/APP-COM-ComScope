# PROFDEB.mak
# Created by IBM WorkFrame/2 MakeMake at 20:02:58 on 14 Feb 2001
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind
#  Lib::Import Lib

.SUFFIXES:

.SUFFIXES: .LIB .c .dll .obj 

.all: \
    f:\work\PROFDEB.LIB

{p:\profile}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /DDEBUG=1 /Sp1 /Sd /Ss /Q /Tx /Fi /Si /Ti /Op- /W1 /Gm /Gd /Ge- /G4 /Gn /Tm /Ms /Gf /Gi /Ft- /Fa /C %s

{f:\work\lib}.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe /NOLOGO %|dpF\%|fF.LIB %s

f:\work\lib\PROFDEB.dll: \
    .\profile.obj \
    p:\profile\Profile.Res \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}UTIL_DEB.lib \
    .\\..\PROFDEB.def
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /de /nop /noe /m /nod"
     /Fe"f:\work\lib\PROFDEB.dll" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     UTIL_DEB.lib 
     .\\..\PROFDEB.def
     .\profile.obj
<<
    rc.exe p:\profile\Profile.Res f:\work\lib\PROFDEB.dll

!include "OS2LS_PR.DEP"