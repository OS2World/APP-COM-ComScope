# CFG_DEB.mak
# Created by IBM WorkFrame/2 MakeMake at 20:03:39 on 14 Feb 2001
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind
#  Lib::Import Lib

.SUFFIXES:

.SUFFIXES: .LIB .c .dll .obj .rc .res

.all: \
    f:\work\lib\CFG_DEB.LIB

{p:\config}.Rc.res:
    @echo " Compile::Resource Compiler "
    rc.exe -r %s %|fF.RES

{p:\config}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /DINCLUDE_COMDD /DDEBUG=1 /Sp1 /Sd /Ss /Q /Tx /Fi /Si /Ti /Op- /W1 /Gm /Gd /Ge- /G4 /Gn /Tm /Ms /Gf /Gi /Ft- /Fa /C %s

{f:\work\lib}.dll.LIB:
    @echo " Lib::Import Lib "
    implib.exe /NOLOGO %|dpF\%|fF.LIB %s

f:\work\lib\CFG_DEB.dll: \
    .\fifo_dlg.obj \
    .\cfg_dev_dlg.obj \
    .\cfg_dlg.obj \
    .\cfg_hlp.obj \
    .\cfg_prot_dlg.obj \
    .\cfg_prot_hlp.obj \
    .\comddini.obj \
    .\ddbufdlg.obj \
    .\dev_notebk.obj \
    p:\config\Config.Res \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}UTIL_DEB.lib \
    .\\..\CFG_DEB.def
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /de /nobase /nop      /noe /m /l /nod"
     /Fe"f:\work\lib\CFG_DEB.dll" 
     OS2LSRTL.lib 
     CPPOM30O.lib 
     OS2386.lib 
     UTIL_DEB.lib 
     .\\..\CFG_DEB.def
     .\fifo_dlg.obj
     .\cfg_dev_dlg.obj
     .\cfg_dlg.obj
     .\cfg_hlp.obj
     .\cfg_prot_dlg.obj
     .\cfg_prot_hlp.obj
     .\comddini.obj
     .\ddbufdlg.obj
     .\dev_notebk.obj
<<
    rc.exe .\Config.Res f:\work\lib\CFG_DEB.dll

!include "COMi_CFG.DEP"