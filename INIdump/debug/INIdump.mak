# IniDump.mak
# Created by IBM WorkFrame/2 MakeMake at 19:59:57 on 9 May 2000
#
# The actions included in this make file are:
#  Compile::C++ Compiler
#  Link::Linker

.SUFFIXES:

.SUFFIXES: .c .obj 

.all: \
    F:\work\IniDump_DBG.exe

{p:\inidump}.c.obj:
    @echo " Compile::C++ Compiler "
    icc.exe /DDEBUG=1 /Sp1 /Sd /Ss /Tx /Fi /Si /Ti /Op- /W1 /Gd /G4 /Gn /Tm /Ms /Gf /Gi /Ft- /Gu /C %s

F:\work\IniDump_DBG.exe: \
    .\inidump.obj \
    {$(LIB)}OS2LSRTL.lib \
    {$(LIB)}OS2386.lib \
    {$(LIB)}CPPOM30O.lib \
    {$(LIB)}UTIL_DEB.lib \
    {$(LIB)}IOCTLDEB.lib \
    .\\..\IniDump.def
    @echo " Link::Linker "
    icc.exe @<<
     /Q /B" /de /nop      /noe /m /nod"
     /Fe"F:\work\IniDump_DBG.exe" 
     OS2LSRTL.lib 
     OS2386.lib 
     CPPOM30O.lib 
     UTIL_DEB.lib 
     IOCTLDEB.lib 
     .\\..\IniDump.def
     .\inidump.obj
<<

!include "IniDump.DEP"