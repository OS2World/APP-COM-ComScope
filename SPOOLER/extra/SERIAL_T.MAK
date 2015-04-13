#=============================================================
#
#	SERIAL_T.MAK - Makefile for project P:\SPOOLER\serial_t.PRJ
#		Created on 06/05/95 at 23:38
#
#=============================================================

.AUTODEPEND

#=============================================================
#		Translator Definitions
#=============================================================
CC = bcc +SERIAL_T.CFG
TASM = tasm.exe
TLIB = tlib.exe
TLINK = tlink
RC = brcc.exe
RB = rc.exe
LIBPATH = W:\BCOS2\LIB;
INCLUDEPATH = W:\BCOS2\INCLUDE;p:\comi;p:\;p:\utility;


#=============================================================
#		Implicit Rules
#=============================================================
.c.obj:
  $(CC) -c {$< }

.cpp.obj:
  $(CC) -c {$< }

.asm.obj:
  $(TASM) -Mx $*.asm,$*.obj

.rc.res:
  $(RC) -r $*.rc

#=============================================================
#		List Macros
#=============================================================
LINK_EXCLUDE =  \
 serialt.res

LINK_INCLUDE =  \
 ..\utility\static.lib \
 obj\serialt.obj

#=============================================================
#		Explicit Rules
#=============================================================
serial_t.exe: serial_t.cfg $(LINK_INCLUDE) $(LINK_EXCLUDE)
  $(TLINK) /v /B:0x10000 /c /m /Toe /aa /L$(LIBPATH) @&&|
W:\BCOS2\LIB\C02.OBJ+
obj\serialt.obj
serial_t,serial_t
..\utility\static.lib+
W:\BCOS2\LIB\C2.LIB+
W:\BCOS2\LIB\OS2.LIB

|
  rc.exe SERIALT.res serial_t.exe

#=============================================================
#		Individual File Dependencies
#=============================================================
SERIALT.res: serial_t.cfg SERIALT.RC 
	brcc.exe -R -I$(INCLUDEPATH) -FO SERIALT.res SERIALT.RC

obj\SERIALT.OBJ: serial_t.cfg SERIALT.C 

#=============================================================
#		Compiler Configuration File
#=============================================================
serial_t.cfg: serial_t.mak
  copy &&|
-L$(LIBPATH)
-I$(INCLUDEPATH)
-vi-
-d
-y
-v
| serial_t.cfg


