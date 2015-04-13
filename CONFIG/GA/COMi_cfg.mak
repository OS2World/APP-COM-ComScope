# COMi_cfg.mak
# Created by IBM WorkFrame/2 MakeMake at 22:13:36 on 15 Feb 2001
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker
#  Bind::Resource Bind
#  Lib::Import Lib

.SUFFIXES:

.SUFFIXES: .LIB .c .dll .obj .rc .res

.all: \
    f:\work\lib\COMi_CFG.LIB

{p:\config}.Rc.res:
    @echo " Compile::Resource Compiler "
    rc.exe -r %s %|fF.RES

{p:\config}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Sp1 /Sd /Ss /Q /Fi /Si /O /W1 /Gm /Gd /Ge- /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /C %s

#f:\work\lib\COMi_CFG.LIB: f:\work\lib\COMi_CFG.DLL
{f:\work\lib}.dll.lib:
    @echo " Lib::Import Lib "
    implib.exe /NOLOGO %|dpF\%|fF.LIB %s  

f:\work\lib\COMi_CFG.dll: \
    .\dev_notebk.obj \
    .\fifo_dlg.obj \
    .\cfg_dev_dlg.obj \
    .\cfg_dlg.obj \
    .\cfg_hlp.obj \
    .\cfg_prot_dlg.obj \
    .\cfg_prot_hlp.obj \
    .\comddini.obj \
    .\ddbufdlg.obj \
    p:\config\Config.Res \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}OS2LS_UT.lib \
    .\\..\COMi_CFG.def
    @echo " Link::Linker "
    @echo " Bind::Resource Bind "
    icc.exe @<<
     /Q /B" /nobase /nop /optfunc /noe /m /nod"
     /Fe"f:\work\lib\COMi_CFG.dll" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     OS2LS_UT.lib 
     .\\..\COMi_CFG.def
     .\dev_notebk.obj
     .\fifo_dlg.obj
     .\cfg_dev_dlg.obj
     .\cfg_dlg.obj
     .\cfg_hlp.obj
     .\cfg_prot_dlg.obj
     .\cfg_prot_hlp.obj
     .\comddini.obj
     .\ddbufdlg.obj
<<
    rc.exe .\Config.Res f:\work\lib\COMi_CFG.dll

!include "COMi_cfg.DEP"