PROJ = COMDDE
PROJFILE = COMDDE.MAK
DEBUG = 1

PWBRMAKE  = pwbrmake
NMAKEBSC1  = set
NMAKEBSC2  = nmake
BROWSE  = 0
AFLAGS_G  = /Cp /DDEMO /nologo /Zp1
CFLAGS_G  = /Alfw /G2 /DDEMO /Zp /BATCH /nologo /NT_TEXT /Fc
CC  = cl
CFLAGS_D  = /Od /Gs
CFLAGS_R  = /Od /Gs
ASM  = ml
AFLAGS_D  = /Sn /Zf /Fl
AFLAGS_R  = /Sn
MAPFILE_D  = eval\$(PROJ).map
MAPFILE_R  = eval\$(PROJ).map
LFLAGS_G  =  /NOI /NOE /NOD /STACK:0  /BATCH /nologo
LFLAGS_D  = /M /NOF /NOP
LFLAGS_R  = /M /NOF /NOP
LINKER  = link
ILINK  = ilink
LRF  = echo > NUL
LLIBS_G  = comddLE.lib doscalls.lib rmcalls.lib
CVFLAGS  = /50 /C"n16"
NMFLAGS  = /nologo
BIND  = bind

DEF_FILE  = COMDD.DEF
OBJS  = eval\DATA_SEG.obj eval\COMDD.obj eval\ExtenFuncs.obj\
        eval\ProcessFlags.obj eval\Write.obj eval\Read.obj eval\INT.obj\
        eval\IOCTL.obj eval\UTIL.obj eval\INIT.obj eval\PRELOAD.obj\
        eval\UTILITY.obj eval\HDW_TEST.obj eval\INITUTIL.obj eval\MCA.obj\
        eval\C_INIT.obj eval\RMHELP.obj eval\SPRINTF_large.obj\
        eval\va_large.obj eval\PCI.obj
SBRS  = eval\DATA_SEG.sbr eval\COMDD.sbr eval\ExtenFuncs.sbr\
        eval\ProcessFlags.sbr eval\Write.sbr eval\Read.sbr eval\INT.sbr\
        eval\IOCTL.sbr eval\UTIL.sbr eval\INIT.sbr eval\PRELOAD.sbr\
        eval\UTILITY.sbr eval\HDW_TEST.sbr eval\INITUTIL.sbr eval\MCA.sbr\
        eval\C_INIT.sbr eval\RMHELP.sbr eval\SPRINTF_large.sbr\
        eval\va_large.sbr eval\PCI.sbr

all: eval\$(PROJ).sys

.SUFFIXES:
.SUFFIXES: .obj .sbr .c .asm

eval\DATA_SEG.obj : DATA_SEG.ASM SEGMENTS.INC COMDD.INC PACKET.INC ABIOS.INC\
        DEVHLP.INC DCB.INC HDW.INC MESSAGE.DEF OEM_MSG.DEF\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\DATA_SEG.obj DATA_SEG.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\DATA_SEG.obj DATA_SEG.ASM
!ENDIF

eval\DATA_SEG.sbr : DATA_SEG.ASM SEGMENTS.INC COMDD.INC PACKET.INC ABIOS.INC\
        DEVHLP.INC DCB.INC HDW.INC MESSAGE.DEF OEM_MSG.DEF\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\DATA_SEG.sbr DATA_SEG.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\DATA_SEG.sbr DATA_SEG.ASM
!ENDIF

eval\COMDD.obj : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\COMDD.obj COMDD.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\COMDD.obj COMDD.ASM
!ENDIF

eval\COMDD.sbr : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\COMDD.sbr COMDD.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\COMDD.sbr COMDD.ASM
!ENDIF

eval\ExtenFuncs.obj : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\ExtenFuncs.obj ExtenFuncs.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\ExtenFuncs.obj ExtenFuncs.asm
!ENDIF

eval\ExtenFuncs.sbr : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\ExtenFuncs.sbr ExtenFuncs.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\ExtenFuncs.sbr ExtenFuncs.asm
!ENDIF

eval\ProcessFlags.obj : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\ProcessFlags.obj ProcessFlags.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\ProcessFlags.obj ProcessFlags.asm
!ENDIF

eval\ProcessFlags.sbr : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\ProcessFlags.sbr ProcessFlags.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\ProcessFlags.sbr ProcessFlags.asm
!ENDIF

eval\Write.obj : Write.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\Write.obj Write.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\Write.obj Write.asm
!ENDIF

eval\Write.sbr : Write.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\Write.sbr Write.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\Write.sbr Write.asm
!ENDIF

eval\Read.obj : Read.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\Read.obj Read.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\Read.obj Read.asm
!ENDIF

eval\Read.sbr : Read.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\Read.sbr Read.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\Read.sbr Read.asm
!ENDIF

eval\INT.obj : INT.ASM SEGMENTS.INC COMDD.INC MACRO.INC DEVHLP.INC DCB.INC\
        HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\INT.obj INT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\INT.obj INT.ASM
!ENDIF

eval\INT.sbr : INT.ASM SEGMENTS.INC COMDD.INC MACRO.INC DEVHLP.INC DCB.INC\
        HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\INT.sbr INT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\INT.sbr INT.ASM
!ENDIF

eval\IOCTL.obj : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\IOCTL.obj IOCTL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\IOCTL.obj IOCTL.ASM
!ENDIF

eval\IOCTL.sbr : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\IOCTL.sbr IOCTL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\IOCTL.sbr IOCTL.ASM
!ENDIF

eval\UTIL.obj : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC DCB.INC\
        DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\UTIL.obj UTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\UTIL.obj UTIL.ASM
!ENDIF

eval\UTIL.sbr : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC DCB.INC\
        DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\UTIL.sbr UTIL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\UTIL.sbr UTIL.ASM
!ENDIF

eval\INIT.obj : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\INIT.obj INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\INIT.obj INIT.ASM
!ENDIF

eval\INIT.sbr : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\INIT.sbr INIT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\INIT.sbr INIT.ASM
!ENDIF

eval\PRELOAD.obj : PRELOAD.C COMDD.H COMDCB.H CUTIL.H RMCALLS.H message.c
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Foeval\PRELOAD.obj PRELOAD.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Foeval\PRELOAD.obj PRELOAD.C
!ENDIF

eval\PRELOAD.sbr : PRELOAD.C COMDD.H COMDCB.H CUTIL.H RMCALLS.H message.c
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FReval\PRELOAD.sbr PRELOAD.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FReval\PRELOAD.sbr PRELOAD.C
!ENDIF

eval\UTILITY.obj : UTILITY.C COMDD.H CUTIL.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Foeval\UTILITY.obj UTILITY.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Foeval\UTILITY.obj UTILITY.C
!ENDIF

eval\UTILITY.sbr : UTILITY.C COMDD.H CUTIL.H
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FReval\UTILITY.sbr UTILITY.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FReval\UTILITY.sbr UTILITY.C
!ENDIF

eval\HDW_TEST.obj : HDW_TEST.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\HDW_TEST.obj HDW_TEST.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\HDW_TEST.obj HDW_TEST.ASM
!ENDIF

eval\HDW_TEST.sbr : HDW_TEST.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\HDW_TEST.sbr HDW_TEST.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\HDW_TEST.sbr HDW_TEST.ASM
!ENDIF

eval\INITUTIL.obj : INITUTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\INITUTIL.obj INITUTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\INITUTIL.obj INITUTIL.ASM
!ENDIF

eval\INITUTIL.sbr : INITUTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\INITUTIL.sbr INITUTIL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\INITUTIL.sbr INITUTIL.ASM
!ENDIF

eval\MCA.obj : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\MCA.obj MCA.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\MCA.obj MCA.ASM
!ENDIF

eval\MCA.sbr : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\MCA.sbr MCA.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\MCA.sbr MCA.ASM
!ENDIF

eval\C_INIT.obj : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        DCB.INC ABIOS.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\C_INIT.obj C_INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\C_INIT.obj C_INIT.ASM
!ENDIF

eval\C_INIT.sbr : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        DCB.INC ABIOS.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\C_INIT.sbr C_INIT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\C_INIT.sbr C_INIT.ASM
!ENDIF

eval\RMHELP.obj : RMHELP.C RMCALLS.H COMDD.H COMDCB.H CUTIL.H rmhelp.h
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Foeval\RMHELP.obj RMHELP.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Foeval\RMHELP.obj RMHELP.C
!ENDIF

eval\RMHELP.sbr : RMHELP.C RMCALLS.H COMDD.H COMDCB.H CUTIL.H rmhelp.h
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FReval\RMHELP.sbr RMHELP.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FReval\RMHELP.sbr RMHELP.C
!ENDIF

eval\SPRINTF_large.obj : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Foeval\SPRINTF_large.obj SPRINTF_large.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Foeval\SPRINTF_large.obj SPRINTF_large.C
!ENDIF

eval\SPRINTF_large.sbr : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FReval\SPRINTF_large.sbr SPRINTF_large.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FReval\SPRINTF_large.sbr SPRINTF_large.C
!ENDIF

eval\va_large.obj : va_large.asm SEGMENTS.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\va_large.obj va_large.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\va_large.obj va_large.asm
!ENDIF

eval\va_large.sbr : va_large.asm SEGMENTS.INC
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\va_large.sbr va_large.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\va_large.sbr va_large.asm
!ENDIF

eval\PCI.obj : PCI.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Foeval\PCI.obj PCI.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Foeval\PCI.obj PCI.asm
!ENDIF

eval\PCI.sbr : PCI.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FReval\PCI.sbr PCI.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FReval\PCI.sbr PCI.asm
!ENDIF


eval\$(PROJ).bsc : $(SBRS)
        $(PWBRMAKE) @<<
$(BRFLAGS) $(SBRS)
<<

eval\$(PROJ).sys : $(DEF_FILE) $(OBJS)
!IF $(DEBUG)
        $(LRF) @<<eval\$(PROJ).lrf
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
        $(LRF) @<<eval\$(PROJ).lrf
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
        $(LINKER) @eval\$(PROJ).lrf
!ELSE
        $(LINKER) @eval\$(PROJ).lrf
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


run: eval\$(PROJ).sys
        eval\$(PROJ).exe $(RUNFLAGS)

debug: eval\$(PROJ).sys
        CVP $(CVFLAGS) eval\$(PROJ).exe $(RUNFLAGS)
