PROJ = pCOMi
PROJFILE = pCOMi.MAK
DEBUG = 1

PWBRMAKE  = pwbrmake
NMAKEBSC1  = set
NMAKEBSC2  = nmake
BROWSE  = 0
CFLAGS_G  = /Alfw /W3 /G2 /DSHARE /Zp /BATCH /nologo /Fc /NT_TEXT
CC  = cl
CFLAGS_D  = /Od /Gs
CFLAGS_R  = /Od /Gs
ASM  = ml
AFLAGS_D  = /Sn /Zf /Fl
AFLAGS_R  = /Sn /Zf
MAPFILE_D  = SHARE\$(PROJ).map
MAPFILE_R  = NUL
LFLAGS_G  =  /NOI /NOE /NOD /STACK:0  /BATCH /nologo
LFLAGS_D  =  /M /NOF /NOP
LFLAGS_R  =  /NOF /NOP
LINKER  = link
ILINK  = ilink
LRF  = echo > NUL
CVFLAGS  =  /50 /C"n16"
AFLAGS_G  = /Cp /W2 /DSHARE /nologo /Zp1
NMFLAGS  = /nologo
BIND  = bind
LLIBS_G  = doscalls.lib comddLE.lib rmcalls.lib

DEF_FILE  = COMDD.DEF
OBJS  = SHARE\DATA_SEG.obj SHARE\ExtenFuncs.obj SHARE\ProcessFlags.obj\
        SHARE\COMDD.obj SHARE\IOCTL.obj SHARE\UTIL.obj SHARE\INT.obj\
        SHARE\INIT.obj SHARE\PRELOAD.obj SHARE\HDW_TEST.obj SHARE\MCA.obj\
        SHARE\INITUTIL.obj SHARE\UTILITY.obj SHARE\C_INIT.obj SHARE\RMHELP.obj\
        SHARE\SPRINTF_large.obj SHARE\va_large.obj
SBRS  = SHARE\DATA_SEG.sbr SHARE\ExtenFuncs.sbr SHARE\ProcessFlags.sbr\
        SHARE\COMDD.sbr SHARE\IOCTL.sbr SHARE\UTIL.sbr SHARE\INT.sbr\
        SHARE\INIT.sbr SHARE\PRELOAD.sbr SHARE\HDW_TEST.sbr SHARE\MCA.sbr\
        SHARE\INITUTIL.sbr SHARE\UTILITY.sbr SHARE\C_INIT.sbr SHARE\RMHELP.sbr\
        SHARE\SPRINTF_large.sbr SHARE\va_large.sbr

all: SHARE\$(PROJ).sys

.SUFFIXES:
.SUFFIXES: .obj .sbr .c .asm

SHARE\DATA_SEG.obj : DATA_SEG.ASM SEGMENTS.INC COMDD.INC PACKET.INC ABIOS.INC\
        DEVHLP.INC DCB.INC HDW.INC MESSAGE.DEF OEM_MSG.DEF\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /FoSHARE\DATA_SEG.obj DATA_SEG.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /FoSHARE\DATA_SEG.obj DATA_SEG.ASM
!ENDIF

SHARE\DATA_SEG.sbr : DATA_SEG.ASM SEGMENTS.INC COMDD.INC PACKET.INC ABIOS.INC\
        DEVHLP.INC DCB.INC HDW.INC MESSAGE.DEF OEM_MSG.DEF\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRSHARE\DATA_SEG.sbr DATA_SEG.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRSHARE\DATA_SEG.sbr DATA_SEG.ASM
!ENDIF

SHARE\ExtenFuncs.obj : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /FoSHARE\ExtenFuncs.obj ExtenFuncs.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /FoSHARE\ExtenFuncs.obj ExtenFuncs.asm
!ENDIF

SHARE\ExtenFuncs.sbr : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRSHARE\ExtenFuncs.sbr ExtenFuncs.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRSHARE\ExtenFuncs.sbr ExtenFuncs.asm
!ENDIF

SHARE\ProcessFlags.obj : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /FoSHARE\ProcessFlags.obj ProcessFlags.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /FoSHARE\ProcessFlags.obj ProcessFlags.asm
!ENDIF

SHARE\ProcessFlags.sbr : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRSHARE\ProcessFlags.sbr ProcessFlags.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRSHARE\ProcessFlags.sbr ProcessFlags.asm
!ENDIF

SHARE\COMDD.obj : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC HDW.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /FoSHARE\COMDD.obj COMDD.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /FoSHARE\COMDD.obj COMDD.ASM
!ENDIF

SHARE\COMDD.sbr : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC\
        MACRO.INC ABIOS.INC DEVHLP.INC HDW.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRSHARE\COMDD.sbr COMDD.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRSHARE\COMDD.sbr COMDD.ASM
!ENDIF

SHARE\IOCTL.obj : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /FoSHARE\IOCTL.obj IOCTL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /FoSHARE\IOCTL.obj IOCTL.ASM
!ENDIF

SHARE\IOCTL.sbr : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRSHARE\IOCTL.sbr IOCTL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRSHARE\IOCTL.sbr IOCTL.ASM
!ENDIF

SHARE\UTIL.obj : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC DCB.INC\
        DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /FoSHARE\UTIL.obj UTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /FoSHARE\UTIL.obj UTIL.ASM
!ENDIF

SHARE\UTIL.sbr : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC DCB.INC\
        DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRSHARE\UTIL.sbr UTIL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRSHARE\UTIL.sbr UTIL.ASM
!ENDIF

SHARE\INT.obj : INT.ASM SEGMENTS.INC COMDD.INC MACRO.INC DEVHLP.INC DCB.INC\
        HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /FoSHARE\INT.obj INT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /FoSHARE\INT.obj INT.ASM
!ENDIF

SHARE\INT.sbr : INT.ASM SEGMENTS.INC COMDD.INC MACRO.INC DEVHLP.INC DCB.INC\
        HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRSHARE\INT.sbr INT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRSHARE\INT.sbr INT.ASM
!ENDIF

SHARE\INIT.obj : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /FoSHARE\INIT.obj INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /FoSHARE\INIT.obj INIT.ASM
!ENDIF

SHARE\INIT.sbr : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRSHARE\INIT.sbr INIT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRSHARE\INIT.sbr INIT.ASM
!ENDIF

SHARE\PRELOAD.obj : PRELOAD.C COMDD.H COMDCB.H CUTIL.H RMCALLS.H message.c
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /FoSHARE\PRELOAD.obj PRELOAD.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /FoSHARE\PRELOAD.obj PRELOAD.C
!ENDIF

SHARE\PRELOAD.sbr : PRELOAD.C COMDD.H COMDCB.H CUTIL.H RMCALLS.H message.c
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRSHARE\PRELOAD.sbr PRELOAD.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRSHARE\PRELOAD.sbr PRELOAD.C
!ENDIF

SHARE\HDW_TEST.obj : HDW_TEST.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /FoSHARE\HDW_TEST.obj HDW_TEST.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /FoSHARE\HDW_TEST.obj HDW_TEST.ASM
!ENDIF

SHARE\HDW_TEST.sbr : HDW_TEST.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRSHARE\HDW_TEST.sbr HDW_TEST.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRSHARE\HDW_TEST.sbr HDW_TEST.ASM
!ENDIF

SHARE\MCA.obj : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /FoSHARE\MCA.obj MCA.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /FoSHARE\MCA.obj MCA.ASM
!ENDIF

SHARE\MCA.sbr : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRSHARE\MCA.sbr MCA.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRSHARE\MCA.sbr MCA.ASM
!ENDIF

SHARE\INITUTIL.obj : INITUTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /FoSHARE\INITUTIL.obj INITUTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /FoSHARE\INITUTIL.obj INITUTIL.ASM
!ENDIF

SHARE\INITUTIL.sbr : INITUTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC HDW.INC MSG.INC\
        f:\ibmcpp\dtools\include\OS2.INC f:\ibmcpp\dtools\include\os2def.inc\
        f:\ibmcpp\dtools\include\bse.inc f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRSHARE\INITUTIL.sbr INITUTIL.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRSHARE\INITUTIL.sbr INITUTIL.ASM
!ENDIF

SHARE\UTILITY.obj : UTILITY.C COMDD.H CUTIL.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /FoSHARE\UTILITY.obj UTILITY.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /FoSHARE\UTILITY.obj UTILITY.C
!ENDIF

SHARE\UTILITY.sbr : UTILITY.C COMDD.H CUTIL.H
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRSHARE\UTILITY.sbr UTILITY.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRSHARE\UTILITY.sbr UTILITY.C
!ENDIF

SHARE\C_INIT.obj : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        DCB.INC ABIOS.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /FoSHARE\C_INIT.obj C_INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /FoSHARE\C_INIT.obj C_INIT.ASM
!ENDIF

SHARE\C_INIT.sbr : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        DCB.INC ABIOS.INC DEVHLP.INC HDW.INC f:\ibmcpp\dtools\include\OS2.INC\
        f:\ibmcpp\dtools\include\os2def.inc f:\ibmcpp\dtools\include\bse.inc\
        f:\ibmcpp\dtools\include\bsedos.inc\
        f:\ibmcpp\dtools\include\bsesub.inc\
        f:\ibmcpp\dtools\include\bseerr.inc\
        f:\ibmcpp\dtools\include\bsedev.inc
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRSHARE\C_INIT.sbr C_INIT.ASM
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRSHARE\C_INIT.sbr C_INIT.ASM
!ENDIF

SHARE\RMHELP.obj : RMHELP.C RMCALLS.H COMDD.H COMDCB.H CUTIL.H rmhelp.h
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /FoSHARE\RMHELP.obj RMHELP.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /FoSHARE\RMHELP.obj RMHELP.C
!ENDIF

SHARE\RMHELP.sbr : RMHELP.C RMCALLS.H COMDD.H COMDCB.H CUTIL.H rmhelp.h
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRSHARE\RMHELP.sbr RMHELP.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRSHARE\RMHELP.sbr RMHELP.C
!ENDIF

SHARE\SPRINTF_large.obj : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /FoSHARE\SPRINTF_large.obj SPRINTF_large.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /FoSHARE\SPRINTF_large.obj SPRINTF_large.C
!ENDIF

SHARE\SPRINTF_large.sbr : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_D) /FRSHARE\SPRINTF_large.sbr SPRINTF_large.C
!ELSE
        $(CC) /Zs $(CFLAGS_G) $(CFLAGS_R) /FRSHARE\SPRINTF_large.sbr SPRINTF_large.C
!ENDIF

SHARE\va_large.obj : va_large.asm SEGMENTS.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /FoSHARE\va_large.obj va_large.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /FoSHARE\va_large.obj va_large.asm
!ENDIF

SHARE\va_large.sbr : va_large.asm SEGMENTS.INC
!IF $(DEBUG)
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_D) /FRSHARE\va_large.sbr va_large.asm
!ELSE
        $(ASM) /Zs $(AFLAGS_G) $(AFLAGS_R) /FRSHARE\va_large.sbr va_large.asm
!ENDIF


SHARE\$(PROJ).bsc : $(SBRS)
        $(PWBRMAKE) @<<
$(BRFLAGS) $(SBRS)
<<

SHARE\$(PROJ).sys : $(DEF_FILE) $(OBJS)
!IF $(DEBUG)
        $(LRF) @<<SHARE\$(PROJ).lrf
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
        $(LRF) @<<SHARE\$(PROJ).lrf
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
        $(LINKER) @SHARE\$(PROJ).lrf
!ELSE
        $(LINKER) @SHARE\$(PROJ).lrf
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


run: SHARE\$(PROJ).sys
        SHARE\$(PROJ).exe $(RUNFLAGS)

debug: SHARE\$(PROJ).sys
        CVP $(CVFLAGS) SHARE\$(PROJ).exe $(RUNFLAGS)
