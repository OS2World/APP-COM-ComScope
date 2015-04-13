# CSBeta.mak
# Created by IBM WorkFrame/2 MakeMake at 14:05:48 on 14 Sept 2001
#
# The actions included in this make file are:
#  Compile::Resource Compiler
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind

.SUFFIXES:

.SUFFIXES: .Rc .c .obj .res 

.all: \
    f:\work\CSdebug.exe

{p:\COMscope}.Rc.res:
    @echo " Compile::Resource Compiler "
    rc.exe -r %s %|fF.RES

{p:\COMscope}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /DDEBUG=1 /Sp1 /Sd /Ss /Q /Tx /Fi /Si /Ti /Op- /W1 /Gm /Gd /G4 /Gn /Tm /Ms /Gf /Gi /Ft- /Fa /C %s

f:\work\CSdebug.exe: \
    .\win_util.obj \
    .\column.obj \
    .\comscope.obj \
    .\csutil.obj \
    .\cs_help.obj \
    .\dialog.obj \
    .\init.obj \
    .\scroll.obj \
    .\search.obj \
    .\stat_dlg.obj \
    .\thread.obj \
    .\wincmd.obj \
    .\COMscope.res \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}UTIL_DEB.lib \
    {$(LIB)}PROFDEB.lib \
    {$(LIB)}IOCTLDEB.lib \
    .\\..\COMscope.def \
    COMscope.mak
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /de /pmtype:pm /nop /noe /m /nod"
     /Fe"f:\work\CSdebug.exe" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     UTIL_DEB.lib 
     PROFDEB.lib 
     IOCTLDEB.lib 
     .\\..\COMscope.def
     .\win_util.obj
     .\column.obj
     .\comscope.obj
     .\csutil.obj
     .\cs_help.obj
     .\dialog.obj
     .\init.obj
     .\scroll.obj
     .\search.obj
     .\stat_dlg.obj
     .\thread.obj
     .\wincmd.obj
<<
    rc.exe .\COMscope.res f:\work\CSdebug.exe

!include "COMscope.dep"