#=============================================================
#
#	SPL_DEMO.MAK - Makefile for project P:\SPOOLER\SPL_DEMO.prj
#		Created on 09/17/95 at 12:34
#
#=============================================================

.AUTODEPEND

#=============================================================
#		Translator Definitions
#=============================================================
CC = bcc +SPL_DEMO.CFG
TASM = tasm.exe
TLIB = tlib.exe
TLINK = tlink
RC = brcc.exe
RB = rc.exe
LIBPATH = W:\BCOS2\LIB;
INCLUDEPATH = W:\BCOS2\INCLUDE;p:\;p:\utility;p:\config;p:\comi;


#=============================================================
#		Implicit Rules
#=============================================================
.c.obj:
  $(CC) -c {demo\$< }

.cpp.obj:
  $(CC) -c {demo\$< }

.asm.obj:
  $(TASM) -Mx $*.asm,demo\$*.obj

.rc.res:
  $(RC) -r $*.rc

#=============================================================
#		List Macros
#=============================================================
LINK_EXCLUDE =  \
 comi_spl.res

LINK_INCLUDE =  \
 spl_demo.def \
 ..\utility\os2ls_io.lib \
 ..\utility\os2ls_ut.lib \
 demo\spooler.obj

#=============================================================
#		Explicit Rules
#=============================================================
spl_demo.dll: spl_demo.cfg $(LINK_INCLUDE) $(LINK_EXCLUDE)
  $(TLINK) /m /wdef /wimt /wmsk /Tod /ap /L$(LIBPATH) @&&|
W:\BCOS2\LIB\C02D.OBJ+
demo\spooler.obj
spl_demo.dll,spl_demo
..\utility\os2ls_io.lib+
..\utility\os2ls_ut.lib+
W:\BCOS2\LIB\C2MTI.LIB+
W:\BCOS2\LIB\OS2.LIB
spl_demo.def
|
  rc.exe COMi_SPL.res spl_demo.dll

#=============================================================
#		Individual File Dependencies
#=============================================================
COMi_SPL.res: spl_demo.cfg COMI_SPL.RC 
	brcc.exe -R -I$(INCLUDEPATH) -FO COMi_SPL.res COMI_SPL.RC

DEMO\spooler.OBJ: spl_demo.cfg spooler.c 

#=============================================================
#		Compiler Configuration File
#=============================================================
spl_demo.cfg: spl_demo.mak
  copy &&|
-DDEMO
-L$(LIBPATH)
-I$(INCLUDEPATH)
-H"OS$tools.h"
-sd
-H=P:\SPOOLER\SPL_DEMO.CSM
-vi-
-sm
-d
-w-
-w-ccc
-wnod
-w-voi
-w-rch
-w-aus
-w-eff
-w-rvl
-wcln
-wasm
-w-par
-wamp
-wamb
-wbbf
-wpin
-w-ret
| spl_demo.cfg


