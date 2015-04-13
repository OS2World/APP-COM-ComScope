PROJ = CCOMDD
PROJFILE = CCOMDD.MAK
DEBUG = 1

PWBRMAKE  = pwbrmake
NMAKEBSC1  = set
NMAKEBSC2  = nmake
BROWSE  = 0
AFLAGS_G  = /Cp /DComtrol /nologo /Zp1
CFLAGS_G  = /Alfw /G2 /DComtrol /Zp /BATCH /nologo /NT_TEXT /Fc
CC  = cl
CFLAGS_D  = /Od /Gs
CFLAGS_R  = /Od /Gs
ASM  = ml
AFLAGS_D  = /Sg /Sn /Zf /Fl
AFLAGS_R  = /Sg /Sn /Zf /Fl
MAPFILE_D  = comtrol\$(PROJ).map
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
BIND  = bind

DEF_FILE  = COMDD.DEF
OBJS  = comtrol\DATA_SEG.obj comtrol\COMDD.obj comtrol\ExtenFuncs.obj\
        comtrol\ProcessFlags.obj comtrol\IOCTL.obj comtrol\INT.obj\
        comtrol\UTIL.obj comtrol\INIT.obj comtrol\PRELOAD.obj\
        comtrol\UTILITY.obj comtrol\HDW_TEST.obj comtrol\INITUTIL.obj\
        comtrol\MCA.obj comtrol\C_INIT.obj comtrol\RMHELP.obj\
        comtrol\SPRINTF_large.obj comtrol\va_large.obj
SBRS  = comtrol\DATA_SEG.sbr comtrol\COMDD.sbr comtrol\ExtenFuncs.sbr\
        comtrol\ProcessFlags.sbr comtrol\IOCTL.sbr comtrol\INT.sbr\
        comtrol\UTIL.sbr comtrol\INIT.sbr comtrol\PRELOAD.sbr\
        comtrol\UTILITY.sbr comtrol\HDW_TEST.sbr comtrol\INITUTIL.sbr\
        comtrol\MCA.sbr comtrol\C_INIT.sbr comtrol\RMHELP.sbr\
        comtrol\SPRINTF_large.sbr comtrol\va_large.sbr

all: comtrol\$(PROJ).sys

.SUFFIXES:
.SUFFIXES: .obj .sbr .c .asm

comtrol\DATA_SEG.obj : DATA_SEG.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MESSAGE.DEF OEM_MSG.DEF\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Focomtrol\DATA_SEG.obj DATA_SEG.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Focomtrol\DATA_SEG.obj DATA_SEG.ASM
!ENDIF

comtrol\DATA_SEG.sbr : DATA_SEG.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MESSAGE.DEF OEM_MSG.DEF\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRcomtrol\DATA_SEG.sbr DATA_SEG.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRcomtrol\DATA_SEG.sbr DATA_SEG.ASM
!ENDIF

comtrol\COMDD.obj : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Focomtrol\COMDD.obj COMDD.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Focomtrol\COMDD.obj COMDD.ASM
!ENDIF

comtrol\COMDD.sbr : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRcomtrol\COMDD.sbr COMDD.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRcomtrol\COMDD.sbr COMDD.ASM
!ENDIF

comtrol\ExtenFuncs.obj : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Focomtrol\ExtenFuncs.obj ExtenFuncs.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Focomtrol\ExtenFuncs.obj ExtenFuncs.asm
!ENDIF

comtrol\ExtenFuncs.sbr : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRcomtrol\ExtenFuncs.sbr ExtenFuncs.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRcomtrol\ExtenFuncs.sbr ExtenFuncs.asm
!ENDIF

comtrol\ProcessFlags.obj : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Focomtrol\ProcessFlags.obj ProcessFlags.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Focomtrol\ProcessFlags.obj ProcessFlags.asm
!ENDIF

comtrol\ProcessFlags.sbr : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRcomtrol\ProcessFlags.sbr ProcessFlags.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRcomtrol\ProcessFlags.sbr ProcessFlags.asm
!ENDIF

comtrol\IOCTL.obj : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Focomtrol\IOCTL.obj IOCTL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Focomtrol\IOCTL.obj IOCTL.ASM
!ENDIF

comtrol\IOCTL.sbr : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRcomtrol\IOCTL.sbr IOCTL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRcomtrol\IOCTL.sbr IOCTL.ASM
!ENDIF

comtrol\INT.obj : INT.ASM SEGMENTS.INC COMDD.INC MACRO.INC DEVHLP.INC DCB.INC\
        HDW.INC w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Focomtrol\INT.obj INT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Focomtrol\INT.obj INT.ASM
!ENDIF

comtrol\INT.sbr : INT.ASM SEGMENTS.INC COMDD.INC MACRO.INC DEVHLP.INC DCB.INC\
        HDW.INC w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRcomtrol\INT.sbr INT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRcomtrol\INT.sbr INT.ASM
!ENDIF

comtrol\UTIL.obj : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC\
        DCB.INC DEVHLP.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Focomtrol\UTIL.obj UTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Focomtrol\UTIL.obj UTIL.ASM
!ENDIF

comtrol\UTIL.sbr : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC\
        DCB.INC DEVHLP.INC HDW.INC w:\v60\masm\include\OS2.INC\
        w:\v60\masm\include\os2def.inc w:\v60\masm\include\bse.inc\
        w:\v60\masm\include\bsedos.inc w:\v60\masm\include\bsesub.inc\
        w:\v60\masm\include\bseerr.inc w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRcomtrol\UTIL.sbr UTIL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRcomtrol\UTIL.sbr UTIL.ASM
!ENDIF

comtrol\INIT.obj : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Focomtrol\INIT.obj INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Focomtrol\INIT.obj INIT.ASM
!ENDIF

comtrol\INIT.sbr : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRcomtrol\INIT.sbr INIT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRcomtrol\INIT.sbr INIT.ASM
!ENDIF

comtrol\PRELOAD.obj : PRELOAD.C COMDD.H COMDCB.H CUTIL.H message.c
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Focomtrol\PRELOAD.obj PRELOAD.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Focomtrol\PRELOAD.obj PRELOAD.C
!ENDIF

comtrol\PRELOAD.sbr : PRELOAD.C COMDD.H COMDCB.H CUTIL.H message.c
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRcomtrol\PRELOAD.sbr PRELOAD.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRcomtrol\PRELOAD.sbr PRELOAD.C
!ENDIF

comtrol\UTILITY.obj : UTILITY.C COMDD.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Focomtrol\UTILITY.obj UTILITY.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Focomtrol\UTILITY.obj UTILITY.C
!ENDIF

comtrol\UTILITY.sbr : UTILITY.C COMDD.H
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRcomtrol\UTILITY.sbr UTILITY.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRcomtrol\UTILITY.sbr UTILITY.C
!ENDIF

comtrol\HDW_TEST.obj : HDW_TEST.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Focomtrol\HDW_TEST.obj HDW_TEST.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Focomtrol\HDW_TEST.obj HDW_TEST.ASM
!ENDIF

comtrol\HDW_TEST.sbr : HDW_TEST.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRcomtrol\HDW_TEST.sbr HDW_TEST.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRcomtrol\HDW_TEST.sbr HDW_TEST.ASM
!ENDIF

comtrol\INITUTIL.obj : INITUTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Focomtrol\INITUTIL.obj INITUTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Focomtrol\INITUTIL.obj INITUTIL.ASM
!ENDIF

comtrol\INITUTIL.sbr : INITUTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRcomtrol\INITUTIL.sbr INITUTIL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRcomtrol\INITUTIL.sbr INITUTIL.ASM
!ENDIF

comtrol\MCA.obj : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Focomtrol\MCA.obj MCA.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Focomtrol\MCA.obj MCA.ASM
!ENDIF

comtrol\MCA.sbr : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRcomtrol\MCA.sbr MCA.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRcomtrol\MCA.sbr MCA.ASM
!ENDIF

comtrol\C_INIT.obj : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC ABIOS.INC DEVHLP.INC HDW.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Focomtrol\C_INIT.obj C_INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Focomtrol\C_INIT.obj C_INIT.ASM
!ENDIF

comtrol\C_INIT.sbr : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC ABIOS.INC DEVHLP.INC HDW.INC\
        w:\v60\masm\include\OS2.INC w:\v60\masm\include\os2def.inc\
        w:\v60\masm\include\bse.inc w:\v60\masm\include\bsedos.inc\
        w:\v60\masm\include\bsesub.inc w:\v60\masm\include\bseerr.inc\
        w:\v60\masm\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRcomtrol\C_INIT.sbr C_INIT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRcomtrol\C_INIT.sbr C_INIT.ASM
!ENDIF

comtrol\RMHELP.obj : RMHELP.C w:\ddkx86\src\dev\resource\rsm_h\rmbase.h\
        COMDD.H COMDCB.H rmhelp.h CUTIL.H\
        w:\ddkx86\src\dev\resource\rsm_h\rmcalls.h
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Focomtrol\RMHELP.obj RMHELP.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Focomtrol\RMHELP.obj RMHELP.C
!ENDIF

comtrol\RMHELP.sbr : RMHELP.C w:\ddkx86\src\dev\resource\rsm_h\rmbase.h\
        COMDD.H COMDCB.H rmhelp.h CUTIL.H\
        w:\ddkx86\src\dev\resource\rsm_h\rmcalls.h
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRcomtrol\RMHELP.sbr RMHELP.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRcomtrol\RMHELP.sbr RMHELP.C
!ENDIF

comtrol\SPRINTF_large.obj : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Focomtrol\SPRINTF_large.obj SPRINTF_large.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Focomtrol\SPRINTF_large.obj SPRINTF_large.C
!ENDIF

comtrol\SPRINTF_large.sbr : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRcomtrol\SPRINTF_large.sbr SPRINTF_large.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRcomtrol\SPRINTF_large.sbr SPRINTF_large.C
!ENDIF

comtrol\va_large.obj : va_large.asm SEGMENTS.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Focomtrol\va_large.obj va_large.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Focomtrol\va_large.obj va_large.asm
!ENDIF

comtrol\va_large.sbr : va_large.asm SEGMENTS.INC
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRcomtrol\va_large.sbr va_large.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRcomtrol\va_large.sbr va_large.asm
!ENDIF


comtrol\$(PROJ).bsc : $(SBRS)
        $(PWBRMAKE) @<<
$(BRFLAGS) $(SBRS)
<<

comtrol\$(PROJ).sys : $(DEF_FILE) $(OBJS)
!IF $(DEBUG)
        $(LRF) @<<comtrol\$(PROJ).lrf
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
        $(LRF) @<<comtrol\$(PROJ).lrf
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
        $(LINKER) @comtrol\$(PROJ).lrf
!ELSE
        $(LINKER) @comtrol\$(PROJ).lrf
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


run: comtrol\$(PROJ).sys
        comtrol\$(PROJ).exe $(RUNFLAGS)

debug: comtrol\$(PROJ).sys
        CVP $(CVFLAGS) comtrol\$(PROJ).exe $(RUNFLAGS)
