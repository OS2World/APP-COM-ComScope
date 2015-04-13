# CSDEMO.mak
# Created by IBM WorkFrame/2 MakeMake at 5:46:05 on 15 May 2000
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind
#  Compile::Resource Compiler

.SUFFIXES:

.SUFFIXES: .Rc .c .obj .res 

.all: \
    f:\work\CSDEMO.exe

.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Fo$*.obj /DINCLUDE_COMDD /DDEMO /DDEBUG /Sp1 /Sd /Ss /Q /Fi /Si /Ti /Op- /W1 /Gm /Gd /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /Gu /C %s

{P:\COMscope}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Fo$*.obj /DINCLUDE_COMDD /DDEMO /DDEBUG /Sp1 /Sd /Ss /Q /Fi /Si /Ti /Op- /W1 /Gm /Gd /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /Gu /C %s

{P:\COMscope\Demo}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Fo$*.obj /DINCLUDE_COMDD /DDEMO /DDEBUG /Sp1 /Sd /Ss /Q /Fi /Si /Ti /Op- /W1 /Gm /Gd /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /Gu /C %s

.Rc.res:
    @echo " Compile::Resource Compiler "
    rc.exe -r %s %|fF.RES

{P:\COMscope}.Rc.res:
    @echo " Compile::Resource Compiler "
    rc.exe -r %s %|fF.RES

{P:\COMscope\Demo}.Rc.res:
    @echo " Compile::Resource Compiler "
    rc.exe -r %s %|fF.RES

f:\work\CSDEMO.exe: \
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
    .\COMscope.res \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2LS_UT.lib \
    {$(LIB)}OS2LS_PR.lib \
    {$(LIB)}OS2LS_IO.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}OS2386.lib \
    .\\..\COMscope.def
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /de /exepack:2 /nobase /pmtype:pm /packd /optfunc      /noe /m /l /nod"
     /Fe"f:\work\CSDEMO.exe" 
     OS2LSRTL.lib 
     OS2LS_UT.lib 
     OS2LS_PR.lib 
     OS2LS_IO.lib 
     CPPOM30O.lib 
     OS2386.lib 
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
    rc.exe .\COMscope.res f:\work\CSDEMO.exe

!include "CSDEMO.DEP"