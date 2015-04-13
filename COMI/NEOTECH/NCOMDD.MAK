PROJ = NCOMDD
PROJFILE = NCOMDD.MAK
DEBUG = 1

BRFLAGS  =  /Es /Em /Iu
PWBRMAKE  = pwbrmake
NMAKEBSC1  = set
NMAKEBSC2  = nmake
BROWSE  = 0
AFLAGS_G  = /Cp /DNeotech /nologo /Sg /Zf /Zp1
CFLAGS_G  = /Alfw /G2 /DNeotech /Zp /BATCH /nologo /NT_TEXT
CC  = cl
CFLAGS_D  = /Od /Gs
CFLAGS_R  = /Od /Gs
ASM  = ml
AFLAGS_D  = /Sn /Zf /Fl
AFLAGS_R  = /Sn /Fl
MAPFILE_D  = neotech\$(PROJ).map
MAPFILE_R  = NUL
LFLAGS_G  =  /NOI /NOE /NOD /STACK:0  /BATCH /nologo
LFLAGS_D  = /M /NOF /NOP
LFLAGS_R  = /NOF /NOP
LINKER  = link
ILINK  = ilink
LRF  = echo > NUL
LLIBS_G  = comddLE.lib doscalls.lib RMCALLS.LIB
CVFLAGS  = /50 /C"n16"
NMFLAGS  = /nologo

DEF_FILE  = COMDD.DEF
OBJS  = neotech\DATA_SEG.obj neotech\ExtenFuncs.obj neotech\ProcessFlags.obj\
        neotech\COMDD.obj neotech\IOCTL.obj neotech\UTIL.obj neotech\INT.obj\
        neotech\INIT.obj neotech\PRELOAD.obj neotech\UTILITY.obj\
        neotech\HDW_TEST.obj neotech\INITUTIL.obj neotech\MCA.obj\
        neotech\C_INIT.obj neotech\RMHELP.obj neotech\SPRINTF_large.obj\
        neotech\va_large.obj
SBRS  = neotech\DATA_SEG.sbr neotech\ExtenFuncs.sbr neotech\ProcessFlags.sbr\
        neotech\COMDD.sbr neotech\IOCTL.sbr neotech\UTIL.sbr neotech\INT.sbr\
        neotech\INIT.sbr neotech\PRELOAD.sbr neotech\UTILITY.sbr\
        neotech\HDW_TEST.sbr neotech\INITUTIL.sbr neotech\MCA.sbr\
        neotech\C_INIT.sbr neotech\RMHELP.sbr neotech\SPRINTF_large.sbr\
        neotech\va_large.sbr

all: neotech\$(PROJ).sys

.SUFFIXES:
.SUFFIXES: .obj .sbr .c .asm

neotech\DATA_SEG.obj : DATA_SEG.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MESSAGE.DEF OEM_MSG.DEF\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foneotech\DATA_SEG.obj DATA_SEG.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foneotech\DATA_SEG.obj DATA_SEG.ASM
!ENDIF

neotech\DATA_SEG.sbr : DATA_SEG.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MESSAGE.DEF OEM_MSG.DEF\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRneotech\DATA_SEG.sbr DATA_SEG.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRneotech\DATA_SEG.sbr DATA_SEG.ASM
!ENDIF

neotech\ExtenFuncs.obj : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foneotech\ExtenFuncs.obj ExtenFuncs.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foneotech\ExtenFuncs.obj ExtenFuncs.asm
!ENDIF

neotech\ExtenFuncs.sbr : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRneotech\ExtenFuncs.sbr ExtenFuncs.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRneotech\ExtenFuncs.sbr ExtenFuncs.asm
!ENDIF

neotech\ProcessFlags.obj : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foneotech\ProcessFlags.obj ProcessFlags.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foneotech\ProcessFlags.obj ProcessFlags.asm
!ENDIF

neotech\ProcessFlags.sbr : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRneotech\ProcessFlags.sbr ProcessFlags.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRneotech\ProcessFlags.sbr ProcessFlags.asm
!ENDIF

neotech\COMDD.obj : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foneotech\COMDD.obj COMDD.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foneotech\COMDD.obj COMDD.ASM
!ENDIF

neotech\COMDD.sbr : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRneotech\COMDD.sbr COMDD.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRneotech\COMDD.sbr COMDD.ASM
!ENDIF

neotech\IOCTL.obj : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foneotech\IOCTL.obj IOCTL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foneotech\IOCTL.obj IOCTL.ASM
!ENDIF

neotech\IOCTL.sbr : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRneotech\IOCTL.sbr IOCTL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRneotech\IOCTL.sbr IOCTL.ASM
!ENDIF

neotech\UTIL.obj : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC\
        DCB.INC DEVHLP.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foneotech\UTIL.obj UTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foneotech\UTIL.obj UTIL.ASM
!ENDIF

neotech\UTIL.sbr : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC\
        DCB.INC DEVHLP.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRneotech\UTIL.sbr UTIL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRneotech\UTIL.sbr UTIL.ASM
!ENDIF

neotech\INT.obj : INT.ASM SEGMENTS.INC COMDD.INC MACRO.INC DEVHLP.INC DCB.INC\
        HDW.INC w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foneotech\INT.obj INT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foneotech\INT.obj INT.ASM
!ENDIF

neotech\INT.sbr : INT.ASM SEGMENTS.INC COMDD.INC MACRO.INC DEVHLP.INC DCB.INC\
        HDW.INC w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRneotech\INT.sbr INT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRneotech\INT.sbr INT.ASM
!ENDIF

neotech\INIT.obj : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foneotech\INIT.obj INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foneotech\INIT.obj INIT.ASM
!ENDIF

neotech\INIT.sbr : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRneotech\INIT.sbr INIT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRneotech\INIT.sbr INIT.ASM
!ENDIF

neotech\PRELOAD.obj : PRELOAD.C COMDD.H COMDCB.H CUTIL.H message.c
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Foneotech\PRELOAD.obj PRELOAD.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Foneotech\PRELOAD.obj PRELOAD.C
!ENDIF

neotech\PRELOAD.sbr : PRELOAD.C COMDD.H COMDCB.H CUTIL.H message.c
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRneotech\PRELOAD.sbr PRELOAD.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRneotech\PRELOAD.sbr PRELOAD.C
!ENDIF

neotech\UTILITY.obj : UTILITY.C COMDD.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Foneotech\UTILITY.obj UTILITY.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Foneotech\UTILITY.obj UTILITY.C
!ENDIF

neotech\UTILITY.sbr : UTILITY.C COMDD.H
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRneotech\UTILITY.sbr UTILITY.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRneotech\UTILITY.sbr UTILITY.C
!ENDIF

neotech\HDW_TEST.obj : HDW_TEST.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foneotech\HDW_TEST.obj HDW_TEST.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foneotech\HDW_TEST.obj HDW_TEST.ASM
!ENDIF

neotech\HDW_TEST.sbr : HDW_TEST.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRneotech\HDW_TEST.sbr HDW_TEST.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRneotech\HDW_TEST.sbr HDW_TEST.ASM
!ENDIF

neotech\INITUTIL.obj : INITUTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foneotech\INITUTIL.obj INITUTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foneotech\INITUTIL.obj INITUTIL.ASM
!ENDIF

neotech\INITUTIL.sbr : INITUTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRneotech\INITUTIL.sbr INITUTIL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRneotech\INITUTIL.sbr INITUTIL.ASM
!ENDIF

neotech\MCA.obj : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foneotech\MCA.obj MCA.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foneotech\MCA.obj MCA.ASM
!ENDIF

neotech\MCA.sbr : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRneotech\MCA.sbr MCA.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRneotech\MCA.sbr MCA.ASM
!ENDIF

neotech\C_INIT.obj : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC ABIOS.INC DEVHLP.INC HDW.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foneotech\C_INIT.obj C_INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foneotech\C_INIT.obj C_INIT.ASM
!ENDIF

neotech\C_INIT.sbr : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC ABIOS.INC DEVHLP.INC HDW.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRneotech\C_INIT.sbr C_INIT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRneotech\C_INIT.sbr C_INIT.ASM
!ENDIF

neotech\RMHELP.obj : RMHELP.C w:\ddkx86\src\dev\resource\rsm_h\rmbase.h\
        COMDD.H COMDCB.H rmhelp.h CUTIL.H\
        w:\ddkx86\src\dev\resource\rsm_h\rmcalls.h
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Foneotech\RMHELP.obj RMHELP.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Foneotech\RMHELP.obj RMHELP.C
!ENDIF

neotech\RMHELP.sbr : RMHELP.C w:\ddkx86\src\dev\resource\rsm_h\rmbase.h\
        COMDD.H COMDCB.H rmhelp.h CUTIL.H\
        w:\ddkx86\src\dev\resource\rsm_h\rmcalls.h
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRneotech\RMHELP.sbr RMHELP.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRneotech\RMHELP.sbr RMHELP.C
!ENDIF

neotech\SPRINTF_large.obj : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Foneotech\SPRINTF_large.obj SPRINTF_large.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Foneotech\SPRINTF_large.obj SPRINTF_large.C
!ENDIF

neotech\SPRINTF_large.sbr : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRneotech\SPRINTF_large.sbr SPRINTF_large.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRneotech\SPRINTF_large.sbr SPRINTF_large.C
!ENDIF

neotech\va_large.obj : va_large.asm SEGMENTS.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foneotech\va_large.obj va_large.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foneotech\va_large.obj va_large.asm
!ENDIF

neotech\va_large.sbr : va_large.asm SEGMENTS.INC
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRneotech\va_large.sbr va_large.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRneotech\va_large.sbr va_large.asm
!ENDIF


neotech\$(PROJ).bsc : $(SBRS)
        $(PWBRMAKE) @<<
$(BRFLAGS) $(SBRS)
<<

neotech\$(PROJ).sys : $(DEF_FILE) $(OBJS)
!IF $(DEBUG)
        $(LRF) @<<neotech\$(PROJ).lrf
$(RT_OBJS: = +^
) $(OBJS: = +^
)
$@
$(MAPFILE_D)
$(LLIBS_G: = +^
) +
$(LLIBS_D: = +^
) +
$(LIBS: = +^
)
$(DEF_FILE) $(LFLAGS_G) $(LFLAGS_D);
<<
!ELSE
        $(LRF) @<<neotech\$(PROJ).lrf
$(RT_OBJS: = +^
) $(OBJS: = +^
)
$@
$(MAPFILE_R)
$(LLIBS_G: = +^
) +
$(LLIBS_R: = +^
) +
$(LIBS: = +^
)
$(DEF_FILE) $(LFLAGS_G) $(LFLAGS_R);
<<
!ENDIF
!IF $(DEBUG)
        $(LINKER) @neotech\$(PROJ).lrf
!ELSE
        $(LINKER) @neotech\$(PROJ).lrf
!ENDIF


.c.obj :
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fo$@ $<
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fo$@ $<
!ENDIF

.c.sbr :
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FR$@ $<
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FR$@ $<
!ENDIF

.asm.obj :
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fo$@ $<
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fo$@ $<
!ENDIF

.asm.sbr :
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FR$@ $<
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FR$@ $<
!ENDIF


run: neotech\$(PROJ).sys
        neotech\$(PROJ).exe $(RUNFLAGS)

debug: neotech\$(PROJ).sys
        CVP $(CVFLAGS) neotech\$(PROJ).exe $(RUNFLAGS)
