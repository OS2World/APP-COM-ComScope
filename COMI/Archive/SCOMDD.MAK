PROJ = SCOMDD
PROJFILE = SCOMDD.MAK
DEBUG = 1

PWBRMAKE  = pwbrmake
NMAKEBSC1  = set
NMAKEBSC2  = nmake
BRFLAGS  =  /Es /Em
BROWSE  = 0
AFLAGS_G  = /Cp /DSealevel /nologo /Zp1
CFLAGS_G  = /Alfw /G2 /DSealevel /Zp /BATCH /nologo /NT_TEXT
CC  = cl
CFLAGS_D  = /Od /Gs /Fc
CFLAGS_R  = /Od /Gs
ASM  = ml
AFLAGS_D  = /Sg /Zf /Fl
AFLAGS_R  = /Sg /Sn /Zf
MAPFILE_D  = sealevel\$(PROJ).map
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
BIND  = bind

DEF_FILE  = COMDD.DEF
OBJS  = sealevel\DATA_SEG.obj sealevel\ExtenFuncs.obj\
        sealevel\ProcessFlags.obj sealevel\COMDD.obj sealevel\IOCTL.obj\
        sealevel\INT.obj sealevel\UTIL.obj sealevel\INIT.obj\
        sealevel\PRELOAD.obj sealevel\UTILITY.obj sealevel\HDW_TEST.obj\
        sealevel\MCA.obj sealevel\INITUTIL.obj sealevel\C_INIT.obj\
        sealevel\RMHELP.obj sealevel\SPRINTF_large.obj sealevel\va_large.obj
SBRS  = sealevel\DATA_SEG.sbr sealevel\ExtenFuncs.sbr\
        sealevel\ProcessFlags.sbr sealevel\COMDD.sbr sealevel\IOCTL.sbr\
        sealevel\INT.sbr sealevel\UTIL.sbr sealevel\INIT.sbr\
        sealevel\PRELOAD.sbr sealevel\UTILITY.sbr sealevel\HDW_TEST.sbr\
        sealevel\MCA.sbr sealevel\INITUTIL.sbr sealevel\C_INIT.sbr\
        sealevel\RMHELP.sbr sealevel\SPRINTF_large.sbr sealevel\va_large.sbr

all: sealevel\$(PROJ).sys

.SUFFIXES:
.SUFFIXES: .obj .sbr .c .asm

sealevel\DATA_SEG.obj : DATA_SEG.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MESSAGE.DEF OEM_MSG.DEF\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fosealevel\DATA_SEG.obj DATA_SEG.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fosealevel\DATA_SEG.obj DATA_SEG.ASM
!ENDIF

sealevel\DATA_SEG.sbr : DATA_SEG.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MESSAGE.DEF OEM_MSG.DEF\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRsealevel\DATA_SEG.sbr DATA_SEG.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRsealevel\DATA_SEG.sbr DATA_SEG.ASM
!ENDIF

sealevel\ExtenFuncs.obj : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fosealevel\ExtenFuncs.obj ExtenFuncs.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fosealevel\ExtenFuncs.obj ExtenFuncs.asm
!ENDIF

sealevel\ExtenFuncs.sbr : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRsealevel\ExtenFuncs.sbr ExtenFuncs.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRsealevel\ExtenFuncs.sbr ExtenFuncs.asm
!ENDIF

sealevel\ProcessFlags.obj : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fosealevel\ProcessFlags.obj ProcessFlags.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fosealevel\ProcessFlags.obj ProcessFlags.asm
!ENDIF

sealevel\ProcessFlags.sbr : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRsealevel\ProcessFlags.sbr ProcessFlags.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRsealevel\ProcessFlags.sbr ProcessFlags.asm
!ENDIF

sealevel\COMDD.obj : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC HDW.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fosealevel\COMDD.obj COMDD.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fosealevel\COMDD.obj COMDD.ASM
!ENDIF

sealevel\COMDD.sbr : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC HDW.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRsealevel\COMDD.sbr COMDD.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRsealevel\COMDD.sbr COMDD.ASM
!ENDIF

sealevel\IOCTL.obj : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fosealevel\IOCTL.obj IOCTL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fosealevel\IOCTL.obj IOCTL.ASM
!ENDIF

sealevel\IOCTL.sbr : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRsealevel\IOCTL.sbr IOCTL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRsealevel\IOCTL.sbr IOCTL.ASM
!ENDIF

sealevel\INT.obj : INT.ASM SEGMENTS.INC COMDD.INC MACRO.INC DEVHLP.INC DCB.INC\
        HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fosealevel\INT.obj INT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fosealevel\INT.obj INT.ASM
!ENDIF

sealevel\INT.sbr : INT.ASM SEGMENTS.INC COMDD.INC MACRO.INC DEVHLP.INC DCB.INC\
        HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRsealevel\INT.sbr INT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRsealevel\INT.sbr INT.ASM
!ENDIF

sealevel\UTIL.obj : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC\
        DCB.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fosealevel\UTIL.obj UTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fosealevel\UTIL.obj UTIL.ASM
!ENDIF

sealevel\UTIL.sbr : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC\
        DCB.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRsealevel\UTIL.sbr UTIL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRsealevel\UTIL.sbr UTIL.ASM
!ENDIF

sealevel\INIT.obj : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fosealevel\INIT.obj INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fosealevel\INIT.obj INIT.ASM
!ENDIF

sealevel\INIT.sbr : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRsealevel\INIT.sbr INIT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRsealevel\INIT.sbr INIT.ASM
!ENDIF

sealevel\PRELOAD.obj : PRELOAD.C COMDD.H COMDCB.H CUTIL.H RMCALLS.H message.c
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fosealevel\PRELOAD.obj PRELOAD.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fosealevel\PRELOAD.obj PRELOAD.C
!ENDIF

sealevel\PRELOAD.sbr : PRELOAD.C COMDD.H COMDCB.H CUTIL.H RMCALLS.H message.c
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRsealevel\PRELOAD.sbr PRELOAD.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRsealevel\PRELOAD.sbr PRELOAD.C
!ENDIF

sealevel\UTILITY.obj : UTILITY.C COMDD.H CUTIL.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fosealevel\UTILITY.obj UTILITY.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fosealevel\UTILITY.obj UTILITY.C
!ENDIF

sealevel\UTILITY.sbr : UTILITY.C COMDD.H CUTIL.H
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRsealevel\UTILITY.sbr UTILITY.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRsealevel\UTILITY.sbr UTILITY.C
!ENDIF

sealevel\HDW_TEST.obj : HDW_TEST.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fosealevel\HDW_TEST.obj HDW_TEST.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fosealevel\HDW_TEST.obj HDW_TEST.ASM
!ENDIF

sealevel\HDW_TEST.sbr : HDW_TEST.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRsealevel\HDW_TEST.sbr HDW_TEST.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRsealevel\HDW_TEST.sbr HDW_TEST.ASM
!ENDIF

sealevel\MCA.obj : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fosealevel\MCA.obj MCA.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fosealevel\MCA.obj MCA.ASM
!ENDIF

sealevel\MCA.sbr : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRsealevel\MCA.sbr MCA.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRsealevel\MCA.sbr MCA.ASM
!ENDIF

sealevel\INITUTIL.obj : INITUTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fosealevel\INITUTIL.obj INITUTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fosealevel\INITUTIL.obj INITUTIL.ASM
!ENDIF

sealevel\INITUTIL.sbr : INITUTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRsealevel\INITUTIL.sbr INITUTIL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRsealevel\INITUTIL.sbr INITUTIL.ASM
!ENDIF

sealevel\C_INIT.obj : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC ABIOS.INC DEVHLP.INC HDW.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fosealevel\C_INIT.obj C_INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fosealevel\C_INIT.obj C_INIT.ASM
!ENDIF

sealevel\C_INIT.sbr : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC ABIOS.INC DEVHLP.INC HDW.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc

sealevel\RMHELP.obj : RMHELP.C RMCALLS.H COMDD.H COMDCB.H CUTIL.H rmhelp.h
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fosealevel\RMHELP.obj RMHELP.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fosealevel\RMHELP.obj RMHELP.C
!ENDIF

sealevel\RMHELP.sbr : RMHELP.C RMCALLS.H COMDD.H COMDCB.H CUTIL.H rmhelp.h
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRsealevel\RMHELP.sbr RMHELP.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRsealevel\RMHELP.sbr RMHELP.C
!ENDIF

sealevel\SPRINTF_large.obj : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fosealevel\SPRINTF_large.obj SPRINTF_large.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fosealevel\SPRINTF_large.obj SPRINTF_large.C
!ENDIF

sealevel\SPRINTF_large.sbr : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRsealevel\SPRINTF_large.sbr SPRINTF_large.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRsealevel\SPRINTF_large.sbr SPRINTF_large.C
!ENDIF

sealevel\va_large.obj : va_large.asm SEGMENTS.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fosealevel\va_large.obj va_large.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fosealevel\va_large.obj va_large.asm
!ENDIF

sealevel\va_large.sbr : va_large.asm SEGMENTS.INC


sealevel\$(PROJ).bsc : $(SBRS)
        $(PWBRMAKE) @<<
$(BRFLAGS) $(SBRS)
<<

sealevel\$(PROJ).sys : $(DEF_FILE) $(OBJS)
!IF $(DEBUG)
        $(LRF) @<<sealevel\$(PROJ).lrf
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
        $(LRF) @<<sealevel\$(PROJ).lrf
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
        $(LINKER) @sealevel\$(PROJ).lrf
!ELSE
        $(LINKER) @sealevel\$(PROJ).lrf
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


run: sealevel\$(PROJ).sys
        sealevel\$(PROJ).exe $(RUNFLAGS)

debug: sealevel\$(PROJ).sys
        CVP $(CVFLAGS) sealevel\$(PROJ).exe $(RUNFLAGS)
