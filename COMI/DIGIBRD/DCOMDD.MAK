PROJ = DCOMDD
PROJFILE = DCOMDD.MAK
DEBUG = 1

BRFLAGS  =  /Es /Em /Iu
PWBRMAKE  = pwbrmake
NMAKEBSC1  = set
NMAKEBSC2  = nmake
BROWSE  = 0
AFLAGS_G  = /Cp /DDigiBoard /nologo /Sg /Zf /Zp1
CFLAGS_G  = /Alfw /G2 /DDigiBoard /Zp /BATCH /nologo /NT_TEXT
CC  = cl
CFLAGS_D  = /Od /Gs
CFLAGS_R  = /Od /Gs
ASM  = ml
AFLAGS_D  = /Sn /Zf /Fl
AFLAGS_R  = /Sn /Fl
MAPFILE_D  = digibrd\$(PROJ).map
MAPFILE_R  = NUL
LFLAGS_G  =  /NOI /NOE /NOD /STACK:0  /BATCH /nologo
LFLAGS_D  = /M /NOF /NOP
LFLAGS_R  = /NOF /NOP
LINKER  = link
ILINK  = ilink
LRF  = echo > NUL
LLIBS_G  = comddLE.lib doscalls.lib rmcalls.lib
CVFLAGS  = /50 /C"n16"
NMFLAGS  = /nologo

DEF_FILE  = COMDD.DEF
OBJS  = digibrd\DATA_SEG.obj digibrd\ExtenFuncs.obj digibrd\ProcessFlags.obj\
        digibrd\COMDD.obj digibrd\IOCTL.obj digibrd\UTIL.obj digibrd\INT.obj\
        digibrd\INIT.obj digibrd\HDW_TEST.obj digibrd\PRELOAD.obj\
        digibrd\UTILITY.obj digibrd\MCA.obj digibrd\INITUTIL.obj\
        digibrd\C_INIT.obj digibrd\RMHELP.obj digibrd\SPRINTF_large.obj\
        digibrd\va_large.obj
SBRS  = digibrd\DATA_SEG.sbr digibrd\ExtenFuncs.sbr digibrd\ProcessFlags.sbr\
        digibrd\COMDD.sbr digibrd\IOCTL.sbr digibrd\UTIL.sbr digibrd\INT.sbr\
        digibrd\INIT.sbr digibrd\HDW_TEST.sbr digibrd\PRELOAD.sbr\
        digibrd\UTILITY.sbr digibrd\MCA.sbr digibrd\INITUTIL.sbr\
        digibrd\C_INIT.sbr digibrd\RMHELP.sbr digibrd\SPRINTF_large.sbr\
        digibrd\va_large.sbr

all: digibrd\$(PROJ).sys

.SUFFIXES:
.SUFFIXES: .obj .sbr .c .asm

digibrd\DATA_SEG.obj : DATA_SEG.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MESSAGE.DEF OEM_MSG.DEF\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodigibrd\DATA_SEG.obj DATA_SEG.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodigibrd\DATA_SEG.obj DATA_SEG.ASM
!ENDIF

digibrd\DATA_SEG.sbr : DATA_SEG.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MESSAGE.DEF OEM_MSG.DEF\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdigibrd\DATA_SEG.sbr DATA_SEG.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdigibrd\DATA_SEG.sbr DATA_SEG.ASM
!ENDIF

digibrd\ExtenFuncs.obj : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodigibrd\ExtenFuncs.obj ExtenFuncs.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodigibrd\ExtenFuncs.obj ExtenFuncs.asm
!ENDIF

digibrd\ExtenFuncs.sbr : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdigibrd\ExtenFuncs.sbr ExtenFuncs.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdigibrd\ExtenFuncs.sbr ExtenFuncs.asm
!ENDIF

digibrd\ProcessFlags.obj : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodigibrd\ProcessFlags.obj ProcessFlags.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodigibrd\ProcessFlags.obj ProcessFlags.asm
!ENDIF

digibrd\ProcessFlags.sbr : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdigibrd\ProcessFlags.sbr ProcessFlags.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdigibrd\ProcessFlags.sbr ProcessFlags.asm
!ENDIF

digibrd\COMDD.obj : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodigibrd\COMDD.obj COMDD.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodigibrd\COMDD.obj COMDD.ASM
!ENDIF

digibrd\COMDD.sbr : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdigibrd\COMDD.sbr COMDD.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdigibrd\COMDD.sbr COMDD.ASM
!ENDIF

digibrd\IOCTL.obj : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodigibrd\IOCTL.obj IOCTL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodigibrd\IOCTL.obj IOCTL.ASM
!ENDIF

digibrd\IOCTL.sbr : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdigibrd\IOCTL.sbr IOCTL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdigibrd\IOCTL.sbr IOCTL.ASM
!ENDIF

digibrd\UTIL.obj : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC\
        DCB.INC DEVHLP.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodigibrd\UTIL.obj UTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodigibrd\UTIL.obj UTIL.ASM
!ENDIF

digibrd\UTIL.sbr : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC\
        DCB.INC DEVHLP.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdigibrd\UTIL.sbr UTIL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdigibrd\UTIL.sbr UTIL.ASM
!ENDIF

digibrd\INT.obj : INT.ASM SEGMENTS.INC COMDD.INC MACRO.INC DEVHLP.INC DCB.INC\
        HDW.INC w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodigibrd\INT.obj INT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodigibrd\INT.obj INT.ASM
!ENDIF

digibrd\INT.sbr : INT.ASM SEGMENTS.INC COMDD.INC MACRO.INC DEVHLP.INC DCB.INC\
        HDW.INC w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdigibrd\INT.sbr INT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdigibrd\INT.sbr INT.ASM
!ENDIF

digibrd\INIT.obj : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MESSAGE.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodigibrd\INIT.obj INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodigibrd\INIT.obj INIT.ASM
!ENDIF

digibrd\INIT.sbr : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MESSAGE.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdigibrd\INIT.sbr INIT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdigibrd\INIT.sbr INIT.ASM
!ENDIF

digibrd\HDW_TEST.obj : HDW_TEST.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MESSAGE.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodigibrd\HDW_TEST.obj HDW_TEST.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodigibrd\HDW_TEST.obj HDW_TEST.ASM
!ENDIF

digibrd\HDW_TEST.sbr : HDW_TEST.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MESSAGE.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdigibrd\HDW_TEST.sbr HDW_TEST.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdigibrd\HDW_TEST.sbr HDW_TEST.ASM
!ENDIF

digibrd\PRELOAD.obj : PRELOAD.C COMDD.H COMDCB.H CUTIL.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fodigibrd\PRELOAD.obj PRELOAD.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fodigibrd\PRELOAD.obj PRELOAD.C
!ENDIF

digibrd\PRELOAD.sbr : PRELOAD.C COMDD.H COMDCB.H CUTIL.H
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRdigibrd\PRELOAD.sbr PRELOAD.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRdigibrd\PRELOAD.sbr PRELOAD.C
!ENDIF

digibrd\UTILITY.obj : UTILITY.C COMDD.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fodigibrd\UTILITY.obj UTILITY.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fodigibrd\UTILITY.obj UTILITY.C
!ENDIF

digibrd\UTILITY.sbr : UTILITY.C COMDD.H
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRdigibrd\UTILITY.sbr UTILITY.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRdigibrd\UTILITY.sbr UTILITY.C
!ENDIF

digibrd\MCA.obj : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MESSAGE.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodigibrd\MCA.obj MCA.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodigibrd\MCA.obj MCA.ASM
!ENDIF

digibrd\MCA.sbr : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MESSAGE.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdigibrd\MCA.sbr MCA.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdigibrd\MCA.sbr MCA.ASM
!ENDIF

digibrd\INITUTIL.obj : INITUTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC HDW.INC MESSAGE.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodigibrd\INITUTIL.obj INITUTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodigibrd\INITUTIL.obj INITUTIL.ASM
!ENDIF

digibrd\INITUTIL.sbr : INITUTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC HDW.INC MESSAGE.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdigibrd\INITUTIL.sbr INITUTIL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdigibrd\INITUTIL.sbr INITUTIL.ASM
!ENDIF

digibrd\C_INIT.obj : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC ABIOS.INC DEVHLP.INC HDW.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodigibrd\C_INIT.obj C_INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodigibrd\C_INIT.obj C_INIT.ASM
!ENDIF

digibrd\C_INIT.sbr : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC ABIOS.INC DEVHLP.INC HDW.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdigibrd\C_INIT.sbr C_INIT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdigibrd\C_INIT.sbr C_INIT.ASM
!ENDIF

digibrd\RMHELP.obj : RMHELP.C w:\ddkx86\src\dev\resource\rsm_h\rmbase.h\
        COMDD.H COMDCB.H rmhelp.h CUTIL.H\
        w:\ddkx86\src\dev\resource\rsm_h\rmcalls.h
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fodigibrd\RMHELP.obj RMHELP.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fodigibrd\RMHELP.obj RMHELP.C
!ENDIF

digibrd\RMHELP.sbr : RMHELP.C w:\ddkx86\src\dev\resource\rsm_h\rmbase.h\
        COMDD.H COMDCB.H rmhelp.h CUTIL.H\
        w:\ddkx86\src\dev\resource\rsm_h\rmcalls.h
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRdigibrd\RMHELP.sbr RMHELP.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRdigibrd\RMHELP.sbr RMHELP.C
!ENDIF

digibrd\SPRINTF_large.obj : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fodigibrd\SPRINTF_large.obj SPRINTF_large.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fodigibrd\SPRINTF_large.obj SPRINTF_large.C
!ENDIF

digibrd\SPRINTF_large.sbr : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRdigibrd\SPRINTF_large.sbr SPRINTF_large.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRdigibrd\SPRINTF_large.sbr SPRINTF_large.C
!ENDIF

digibrd\va_large.obj : va_large.asm SEGMENTS.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodigibrd\va_large.obj va_large.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodigibrd\va_large.obj va_large.asm
!ENDIF

digibrd\va_large.sbr : va_large.asm SEGMENTS.INC
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdigibrd\va_large.sbr va_large.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdigibrd\va_large.sbr va_large.asm
!ENDIF


digibrd\$(PROJ).bsc : $(SBRS)
        $(PWBRMAKE) @<<
$(BRFLAGS) $(SBRS)
<<

digibrd\$(PROJ).sys : $(DEF_FILE) $(OBJS)
!IF $(DEBUG)
        $(LRF) @<<digibrd\$(PROJ).lrf
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
        $(LRF) @<<digibrd\$(PROJ).lrf
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
        $(LINKER) @digibrd\$(PROJ).lrf
!ELSE
        $(LINKER) @digibrd\$(PROJ).lrf
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


run: digibrd\$(PROJ).sys
        digibrd\$(PROJ).exe $(RUNFLAGS)

debug: digibrd\$(PROJ).sys
        CVP $(CVFLAGS) digibrd\$(PROJ).exe $(RUNFLAGS)
