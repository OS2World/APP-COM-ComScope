# COMscope.mak
# Created by IBM WorkFrame/2 MakeMake at 8:47:48 on 15 Feb 2001
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind

.SUFFIXES:

.SUFFIXES: .Rc .c .obj .res 


.all: \
    f:\work\COMscope.exe

{p:\COMscope}.Rc.res:
    @echo " Compile::Resource Compiler "
    rc.exe -r %s %|fF.RES

{p:\COMscope}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Sp1 /Sd /Ss /Q /Fi /Si /O /W1 /Gm /Gd /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /Gu /C %s

f:\work\COMscope.exe: \
    .\wincmd.obj \
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
    .\COMscope.Res \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}OS2LS_UT.lib \
    {$(LIB)}OS2LS_PR.lib \
    {$(LIB)}OS2LS_IO.lib \
    .\\..\COMscope.def
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /exepack:2 /pmtype:pm /packd /optfunc      /noe /m /nod"
     /Fe"f:\work\COMscope.exe" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     OS2LS_UT.lib 
     OS2LS_PR.lib 
     OS2LS_IO.lib 
     .\\..\COMscope.def
     .\wincmd.obj
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
<<
     rc.exe .\COMscope.res f:\work\COMscope.exe

!include "COMscope.DEP"