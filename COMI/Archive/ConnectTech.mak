PROJ = dflex
PROJFILE = dflex.mak
DEBUG = 1

PWBRMAKE  = pwbrmake
NMAKEBSC1  = set
NMAKEBSC2  = nmake
BROWSE  = 0
CFLAGS_G  = /Alfw /W3 /G2 /DConnecTech /Zp /BATCH /nologo /Zl /Od /Fc /NT_TEXT
CC  = cl
CFLAGS_D  = /Od /Gs
CFLAGS_R  = /Od /Gs
ASM  = ml
AFLAGS_D  = /Sg /Sn /Zf /Fl
AFLAGS_R  = /Sn
MAPFILE_D  = dflex\$(PROJ).map
MAPFILE_R  = NUL
LFLAGS_G  =  /NOI /NOE /NOD /STACK:0  /BATCH /nologo
LFLAGS_D  =  /M /NOF /NOP
LFLAGS_R  =  /NOF /NOP
LINKER  = link
ILINK  = ilink
LRF  = echo > NUL
CVFLAGS  =  /50 /C"n16"
AFLAGS_G  = /Cp /W2 /DConnecTech /nologo /Zp1
NMFLAGS  = /nologo
BIND  = bind
LLIBS_G  = doscalls.lib comddLE.lib rmcalls.lib

DEF_FILE  = COMDD.DEF
OBJS  = dflex\DATA_SEG.obj dflex\COMDD.obj dflex\ProcessFlags.obj\
        dflex\ExtenFuncs.obj dflex\Read.obj dflex\Write.obj dflex\INT.obj\
        dflex\IOCTL.obj dflex\UTIL.obj dflex\INIT.obj dflex\PRELOAD.obj\
        dflex\HDW_TEST.obj dflex\MCA.obj dflex\INITUTIL.obj dflex\UTILITY.obj\
        dflex\C_INIT.obj dflex\RMHELP.obj dflex\SPRINTF_large.obj\
        dflex\va_large.obj dflex\PCI.obj
SBRS  = dflex\DATA_SEG.sbr dflex\COMDD.sbr dflex\ProcessFlags.sbr\
        dflex\ExtenFuncs.sbr dflex\Read.sbr dflex\Write.sbr dflex\INT.sbr\
        dflex\IOCTL.sbr dflex\UTIL.sbr dflex\INIT.sbr dflex\PRELOAD.sbr\
        dflex\HDW_TEST.sbr dflex\MCA.sbr dflex\INITUTIL.sbr dflex\UTILITY.sbr\
        dflex\C_INIT.sbr dflex\RMHELP.sbr dflex\SPRINTF_large.sbr\
        dflex\va_large.sbr dflex\PCI.sbr

all: dflex\$(PROJ).sys

.SUFFIXES:
.SUFFIXES: .obj .sbr .c .asm

dflex\DATA_SEG.obj : DATA_SEG.ASM SEGMENTS.INC COMDD.INC PACKET.INC ABIOS.INC\
        DEVHLP.INC DCB.INC HDW.INC MESSAGE.DEF OEM_MSG.DEF\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\DATA_SEG.obj DATA_SEG.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\DATA_SEG.obj DATA_SEG.ASM
!ENDIF

dflex\DATA_SEG.sbr : DATA_SEG.ASM SEGMENTS.INC COMDD.INC PACKET.INC ABIOS.INC\
        DEVHLP.INC DCB.INC HDW.INC MESSAGE.DEF OEM_MSG.DEF\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\DATA_SEG.sbr DATA_SEG.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\DATA_SEG.sbr DATA_SEG.ASM
!ENDIF

dflex\COMDD.obj : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC HDW.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\COMDD.obj COMDD.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\COMDD.obj COMDD.ASM
!ENDIF

dflex\COMDD.sbr : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC HDW.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\COMDD.sbr COMDD.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\COMDD.sbr COMDD.ASM
!ENDIF

dflex\ProcessFlags.obj : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\ProcessFlags.obj ProcessFlags.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\ProcessFlags.obj ProcessFlags.asm
!ENDIF

dflex\ProcessFlags.sbr : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\ProcessFlags.sbr ProcessFlags.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\ProcessFlags.sbr ProcessFlags.asm
!ENDIF

dflex\ExtenFuncs.obj : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\ExtenFuncs.obj ExtenFuncs.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\ExtenFuncs.obj ExtenFuncs.asm
!ENDIF

dflex\ExtenFuncs.sbr : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\ExtenFuncs.sbr ExtenFuncs.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\ExtenFuncs.sbr ExtenFuncs.asm
!ENDIF

dflex\Read.obj : Read.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\Read.obj Read.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\Read.obj Read.asm
!ENDIF

dflex\Read.sbr : Read.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\Read.sbr Read.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\Read.sbr Read.asm
!ENDIF

dflex\Write.obj : Write.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC HDW.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\Write.obj Write.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\Write.obj Write.asm
!ENDIF

dflex\Write.sbr : Write.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC HDW.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\Write.sbr Write.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\Write.sbr Write.asm
!ENDIF

dflex\INT.obj : INT.ASM SEGMENTS.INC COMDD.INC MACRO.INC DEVHLP.INC DCB.INC\
        HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\INT.obj INT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\INT.obj INT.ASM
!ENDIF

dflex\INT.sbr : INT.ASM SEGMENTS.INC COMDD.INC MACRO.INC DEVHLP.INC DCB.INC\
        HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\INT.sbr INT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\INT.sbr INT.ASM
!ENDIF

dflex\IOCTL.obj : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\IOCTL.obj IOCTL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\IOCTL.obj IOCTL.ASM
!ENDIF

dflex\IOCTL.sbr : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\IOCTL.sbr IOCTL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\IOCTL.sbr IOCTL.ASM
!ENDIF

dflex\UTIL.obj : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC DCB.INC\
        DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\UTIL.obj UTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\UTIL.obj UTIL.ASM
!ENDIF

dflex\UTIL.sbr : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC DCB.INC\
        DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\UTIL.sbr UTIL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\UTIL.sbr UTIL.ASM
!ENDIF

dflex\INIT.obj : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\INIT.obj INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\INIT.obj INIT.ASM
!ENDIF

dflex\INIT.sbr : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\INIT.sbr INIT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\INIT.sbr INIT.ASM
!ENDIF

dflex\PRELOAD.obj : PRELOAD.C COMDD.H COMDCB.H CUTIL.H RMCALLS.H message.c
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fodflex\PRELOAD.obj PRELOAD.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fodflex\PRELOAD.obj PRELOAD.C
!ENDIF

dflex\PRELOAD.sbr : PRELOAD.C COMDD.H COMDCB.H CUTIL.H RMCALLS.H message.c
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRdflex\PRELOAD.sbr PRELOAD.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRdflex\PRELOAD.sbr PRELOAD.C
!ENDIF

dflex\HDW_TEST.obj : HDW_TEST.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\HDW_TEST.obj HDW_TEST.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\HDW_TEST.obj HDW_TEST.ASM
!ENDIF

dflex\HDW_TEST.sbr : HDW_TEST.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\HDW_TEST.sbr HDW_TEST.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\HDW_TEST.sbr HDW_TEST.ASM
!ENDIF

dflex\MCA.obj : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\MCA.obj MCA.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\MCA.obj MCA.ASM
!ENDIF

dflex\MCA.sbr : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\MCA.sbr MCA.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\MCA.sbr MCA.ASM
!ENDIF

dflex\INITUTIL.obj : INITUTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\INITUTIL.obj INITUTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\INITUTIL.obj INITUTIL.ASM
!ENDIF

dflex\INITUTIL.sbr : INITUTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\INITUTIL.sbr INITUTIL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\INITUTIL.sbr INITUTIL.ASM
!ENDIF

dflex\UTILITY.obj : UTILITY.C COMDD.H CUTIL.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fodflex\UTILITY.obj UTILITY.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fodflex\UTILITY.obj UTILITY.C
!ENDIF

dflex\UTILITY.sbr : UTILITY.C COMDD.H CUTIL.H
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRdflex\UTILITY.sbr UTILITY.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRdflex\UTILITY.sbr UTILITY.C
!ENDIF

dflex\C_INIT.obj : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        DCB.INC ABIOS.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\C_INIT.obj C_INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\C_INIT.obj C_INIT.ASM
!ENDIF

dflex\C_INIT.sbr : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        DCB.INC ABIOS.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\C_INIT.sbr C_INIT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\C_INIT.sbr C_INIT.ASM
!ENDIF

dflex\RMHELP.obj : RMHELP.C RMCALLS.H COMDD.H COMDCB.H CUTIL.H rmhelp.h
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fodflex\RMHELP.obj RMHELP.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fodflex\RMHELP.obj RMHELP.C
!ENDIF

dflex\RMHELP.sbr : RMHELP.C RMCALLS.H COMDD.H COMDCB.H CUTIL.H rmhelp.h
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRdflex\RMHELP.sbr RMHELP.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRdflex\RMHELP.sbr RMHELP.C
!ENDIF

dflex\SPRINTF_large.obj : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fodflex\SPRINTF_large.obj SPRINTF_large.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fodflex\SPRINTF_large.obj SPRINTF_large.C
!ENDIF

dflex\SPRINTF_large.sbr : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRdflex\SPRINTF_large.sbr SPRINTF_large.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRdflex\SPRINTF_large.sbr SPRINTF_large.C
!ENDIF

dflex\va_large.obj : va_large.asm SEGMENTS.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\va_large.obj va_large.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\va_large.obj va_large.asm
!ENDIF

dflex\va_large.sbr : va_large.asm SEGMENTS.INC
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\va_large.sbr va_large.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\va_large.sbr va_large.asm
!ENDIF

dflex\PCI.obj : PCI.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fodflex\PCI.obj PCI.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fodflex\PCI.obj PCI.asm
!ENDIF

dflex\PCI.sbr : PCI.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRdflex\PCI.sbr PCI.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRdflex\PCI.sbr PCI.asm
!ENDIF


dflex\$(PROJ).bsc : $(SBRS)
        $(PWBRMAKE) @<<
$(BRFLAGS) $(SBRS)
<<

dflex\$(PROJ).sys : $(DEF_FILE) $(OBJS)
!IF $(DEBUG)
        $(LRF) @<<dflex\$(PROJ).lrf
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
        $(LRF) @<<dflex\$(PROJ).lrf
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
        $(LINKER) @dflex\$(PROJ).lrf
!ELSE
        $(LINKER) @dflex\$(PROJ).lrf
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


run: dflex\$(PROJ).sys
        dflex\$(PROJ).exe $(RUNFLAGS)

debug: dflex\$(PROJ).sys
        CVP $(CVFLAGS) dflex\$(PROJ).exe $(RUNFLAGS)
