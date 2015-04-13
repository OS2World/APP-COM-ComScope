# IniDump.mak
# Created by IBM WorkFrame/2 MakeMake at 8:58:43 on 15 Feb 2001
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker

.SUFFIXES:

.SUFFIXES: .c .obj 

.all: \
    F:\work\IniDump.exe

{p:\inidump}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /Sp1 /Sd /Ss /Q /Fi /Si /O /W1 /Gd /G4 /Gs /Gn /Ms /Gf /Gi /Ft- /Gu /C %s

F:\work\IniDump.exe: \
    .\inidump.obj \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}OS2LS_UT.lib \
    {$(LIB)}OS2LS_IO.lib \
    .\\..\IniDump.def
    @echo " Link::Linker "
    icc.exe @<<
     /Q /B" /nop /optfunc      /noe /m /nod"
     /Fe"F:\work\IniDump.exe" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     OS2LS_UT.lib 
     OS2LS_IO.lib 
     .\\..\IniDump.def
     .\inidump.obj
<<

!include "IniDump.DEP"