PROJ = COMDD
PROJFILE = COMDD.MAK
DEBUG = 1

NMAKEBSC1  = set
NMAKEBSC2  = nmake
BROWSE  = 0
AFLAGS_G  = /Cp /DxVDD_support /DxNO_PCI /nologo /Zp1
CFLAGS_G  = /Alfw /G2 /DxVDD_support /DxNO_PCI /Zp /BATCH /nologo /NT_TEXT /Fc
CC  = cl
CFLAGS_D  = /Od /Gs
CFLAGS_R  = /Od /Gs
ASM  = ml
AFLAGS_D  = /Sg /Sn /Zf /Fl
AFLAGS_R  = /Sn
MAPFILE_D  = base\$(PROJ).map
MAPFILE_R  = base\$(PROJ).map
LFLAGS_G  =  /NOI /NOE /NOD /STACK:0  /BATCH /nologo
LFLAGS_D  = /M /NOF /NOP
LFLAGS_R  = /M /NOF /NOP
LINKER  = link
ILINK  = ilink
LRF  = echo > NUL
LLIBS_G  = comddLE.lib doscalls.lib rmcalls.lib OS2286.lib
CVFLAGS  = /50 /C"n16"
NMFLAGS  = /nologo
BIND  = bind

DEF_FILE  = COMDD.DEF
OBJS  = base\Interrupt.obj base\DataSegment.obj base\COMDD.obj\
        base\ExtenFuncs.obj base\ProcessFlags.obj base\Write.obj base\Read.obj\
        base\IOCTL.obj base\UTIL.obj base\INIT.obj base\UTILITY.obj\
        base\MCA.obj base\C_INIT.obj base\RMHELP.obj base\SPRINTF_large.obj\
        base\va_large.obj base\HdwTest.obj base\IniAccess.obj\
        base\InitUtil.obj

all: base\$(PROJ).sys

.SUFFIXES:
.SUFFIXES: .obj .c .asm

base\Interrupt.obj : Interrupt.asm SEGMENTS.INC COMDD.INC MACRO.INC DEVHLP.INC\
        DCB.INC Hardware.inc f:\ibmcpp\dtools\inc\OS2.INC\
        f:\ibmcpp\dtools\inc\os2def.INC f:\ibmcpp\dtools\inc\bse.INC\
        f:\ibmcpp\dtools\inc\pm.INC f:\ibmcpp\dtools\inc\os2def16.INC\
        f:\ibmcpp\dtools\inc\bsedos.INC f:\ibmcpp\dtools\inc\bsedev.INC\
        f:\ibmcpp\dtools\inc\bsesub.INC f:\ibmcpp\dtools\inc\bseerr.INC\
        f:\ibmcpp\dtools\inc\pmwin.INC f:\ibmcpp\dtools\inc\pmgpi.INC\
        f:\ibmcpp\dtools\inc\pmdev.INC f:\ibmcpp\dtools\inc\pmavio.INC\
        f:\ibmcpp\dtools\inc\pmspl.INC f:\ibmcpp\dtools\inc\pmpic.INC\
        f:\ibmcpp\dtools\inc\pmord.INC f:\ibmcpp\dtools\inc\pmfont.INC\
        f:\ibmcpp\dtools\inc\pmstddlg.INC f:\ibmcpp\dtools\inc\bsememf.INC\
        f:\ibmcpp\dtools\inc\bsedos16.INC f:\ibmcpp\dtools\inc\pmtypes.INC\
        f:\ibmcpp\dtools\inc\pmmle.INC f:\ibmcpp\dtools\inc\pmshl.INC\
        f:\ibmcpp\dtools\inc\pmerr.INC f:\ibmcpp\dtools\inc\pmsei.INC\
        f:\ibmcpp\dtools\inc\pmhelp.INC f:\ibmcpp\dtools\inc\pmbitmap.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fobase\Interrupt.obj Interrupt.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fobase\Interrupt.obj Interrupt.asm
!ENDIF

base\DataSegment.obj : DataSegment.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MESSAGE.DEF OEM_MSG.DEF\
        f:\ibmcpp\dtools\inc\OS2.INC f:\ibmcpp\dtools\inc\os2def.INC\
        f:\ibmcpp\dtools\inc\bse.INC f:\ibmcpp\dtools\inc\pm.INC\
        f:\ibmcpp\dtools\inc\os2def16.INC f:\ibmcpp\dtools\inc\bsedos.INC\
        f:\ibmcpp\dtools\inc\bsedev.INC f:\ibmcpp\dtools\inc\bsesub.INC\
        f:\ibmcpp\dtools\inc\bseerr.INC f:\ibmcpp\dtools\inc\pmwin.INC\
        f:\ibmcpp\dtools\inc\pmgpi.INC f:\ibmcpp\dtools\inc\pmdev.INC\
        f:\ibmcpp\dtools\inc\pmavio.INC f:\ibmcpp\dtools\inc\pmspl.INC\
        f:\ibmcpp\dtools\inc\pmpic.INC f:\ibmcpp\dtools\inc\pmord.INC\
        f:\ibmcpp\dtools\inc\pmfont.INC f:\ibmcpp\dtools\inc\pmstddlg.INC\
        f:\ibmcpp\dtools\inc\bsememf.INC f:\ibmcpp\dtools\inc\bsedos16.INC\
        f:\ibmcpp\dtools\inc\pmtypes.INC f:\ibmcpp\dtools\inc\pmmle.INC\
        f:\ibmcpp\dtools\inc\pmshl.INC f:\ibmcpp\dtools\inc\pmerr.INC\
        f:\ibmcpp\dtools\inc\pmsei.INC f:\ibmcpp\dtools\inc\pmhelp.INC\
        f:\ibmcpp\dtools\inc\pmbitmap.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fobase\DataSegment.obj DataSegment.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fobase\DataSegment.obj DataSegment.asm
!ENDIF

base\COMDD.obj : COMDD.ASM SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC Hardware.inc f:\ibmcpp\dtools\inc\OS2.INC\
        f:\ibmcpp\dtools\inc\os2def.INC f:\ibmcpp\dtools\inc\bse.INC\
        f:\ibmcpp\dtools\inc\pm.INC f:\ibmcpp\dtools\inc\os2def16.INC\
        f:\ibmcpp\dtools\inc\bsedos.INC f:\ibmcpp\dtools\inc\bsedev.INC\
        f:\ibmcpp\dtools\inc\bsesub.INC f:\ibmcpp\dtools\inc\bseerr.INC\
        f:\ibmcpp\dtools\inc\pmwin.INC f:\ibmcpp\dtools\inc\pmgpi.INC\
        f:\ibmcpp\dtools\inc\pmdev.INC f:\ibmcpp\dtools\inc\pmavio.INC\
        f:\ibmcpp\dtools\inc\pmspl.INC f:\ibmcpp\dtools\inc\pmpic.INC\
        f:\ibmcpp\dtools\inc\pmord.INC f:\ibmcpp\dtools\inc\pmfont.INC\
        f:\ibmcpp\dtools\inc\pmstddlg.INC f:\ibmcpp\dtools\inc\bsememf.INC\
        f:\ibmcpp\dtools\inc\bsedos16.INC f:\ibmcpp\dtools\inc\pmtypes.INC\
        f:\ibmcpp\dtools\inc\pmmle.INC f:\ibmcpp\dtools\inc\pmshl.INC\
        f:\ibmcpp\dtools\inc\pmerr.INC f:\ibmcpp\dtools\inc\pmsei.INC\
        f:\ibmcpp\dtools\inc\pmhelp.INC f:\ibmcpp\dtools\inc\pmbitmap.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fobase\COMDD.obj COMDD.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fobase\COMDD.obj COMDD.ASM
!ENDIF

base\ExtenFuncs.obj : ExtenFuncs.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC Hardware.inc\
        f:\ibmcpp\dtools\inc\OS2.INC f:\ibmcpp\dtools\inc\os2def.INC\
        f:\ibmcpp\dtools\inc\bse.INC f:\ibmcpp\dtools\inc\pm.INC\
        f:\ibmcpp\dtools\inc\os2def16.INC f:\ibmcpp\dtools\inc\bsedos.INC\
        f:\ibmcpp\dtools\inc\bsedev.INC f:\ibmcpp\dtools\inc\bsesub.INC\
        f:\ibmcpp\dtools\inc\bseerr.INC f:\ibmcpp\dtools\inc\pmwin.INC\
        f:\ibmcpp\dtools\inc\pmgpi.INC f:\ibmcpp\dtools\inc\pmdev.INC\
        f:\ibmcpp\dtools\inc\pmavio.INC f:\ibmcpp\dtools\inc\pmspl.INC\
        f:\ibmcpp\dtools\inc\pmpic.INC f:\ibmcpp\dtools\inc\pmord.INC\
        f:\ibmcpp\dtools\inc\pmfont.INC f:\ibmcpp\dtools\inc\pmstddlg.INC\
        f:\ibmcpp\dtools\inc\bsememf.INC f:\ibmcpp\dtools\inc\bsedos16.INC\
        f:\ibmcpp\dtools\inc\pmtypes.INC f:\ibmcpp\dtools\inc\pmmle.INC\
        f:\ibmcpp\dtools\inc\pmshl.INC f:\ibmcpp\dtools\inc\pmerr.INC\
        f:\ibmcpp\dtools\inc\pmsei.INC f:\ibmcpp\dtools\inc\pmhelp.INC\
        f:\ibmcpp\dtools\inc\pmbitmap.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fobase\ExtenFuncs.obj ExtenFuncs.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fobase\ExtenFuncs.obj ExtenFuncs.asm
!ENDIF

base\ProcessFlags.obj : ProcessFlags.asm SEGMENTS.INC COMDD.INC MACRO.INC\
        PACKET.INC DEVHLP.INC DCB.INC Hardware.inc\
        f:\ibmcpp\dtools\inc\OS2.INC f:\ibmcpp\dtools\inc\os2def.INC\
        f:\ibmcpp\dtools\inc\bse.INC f:\ibmcpp\dtools\inc\pm.INC\
        f:\ibmcpp\dtools\inc\os2def16.INC f:\ibmcpp\dtools\inc\bsedos.INC\
        f:\ibmcpp\dtools\inc\bsedev.INC f:\ibmcpp\dtools\inc\bsesub.INC\
        f:\ibmcpp\dtools\inc\bseerr.INC f:\ibmcpp\dtools\inc\pmwin.INC\
        f:\ibmcpp\dtools\inc\pmgpi.INC f:\ibmcpp\dtools\inc\pmdev.INC\
        f:\ibmcpp\dtools\inc\pmavio.INC f:\ibmcpp\dtools\inc\pmspl.INC\
        f:\ibmcpp\dtools\inc\pmpic.INC f:\ibmcpp\dtools\inc\pmord.INC\
        f:\ibmcpp\dtools\inc\pmfont.INC f:\ibmcpp\dtools\inc\pmstddlg.INC\
        f:\ibmcpp\dtools\inc\bsememf.INC f:\ibmcpp\dtools\inc\bsedos16.INC\
        f:\ibmcpp\dtools\inc\pmtypes.INC f:\ibmcpp\dtools\inc\pmmle.INC\
        f:\ibmcpp\dtools\inc\pmshl.INC f:\ibmcpp\dtools\inc\pmerr.INC\
        f:\ibmcpp\dtools\inc\pmsei.INC f:\ibmcpp\dtools\inc\pmhelp.INC\
        f:\ibmcpp\dtools\inc\pmbitmap.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fobase\ProcessFlags.obj ProcessFlags.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fobase\ProcessFlags.obj ProcessFlags.asm
!ENDIF

base\Write.obj : Write.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC Hardware.inc f:\ibmcpp\dtools\inc\OS2.INC\
        f:\ibmcpp\dtools\inc\os2def.INC f:\ibmcpp\dtools\inc\bse.INC\
        f:\ibmcpp\dtools\inc\pm.INC f:\ibmcpp\dtools\inc\os2def16.INC\
        f:\ibmcpp\dtools\inc\bsedos.INC f:\ibmcpp\dtools\inc\bsedev.INC\
        f:\ibmcpp\dtools\inc\bsesub.INC f:\ibmcpp\dtools\inc\bseerr.INC\
        f:\ibmcpp\dtools\inc\pmwin.INC f:\ibmcpp\dtools\inc\pmgpi.INC\
        f:\ibmcpp\dtools\inc\pmdev.INC f:\ibmcpp\dtools\inc\pmavio.INC\
        f:\ibmcpp\dtools\inc\pmspl.INC f:\ibmcpp\dtools\inc\pmpic.INC\
        f:\ibmcpp\dtools\inc\pmord.INC f:\ibmcpp\dtools\inc\pmfont.INC\
        f:\ibmcpp\dtools\inc\pmstddlg.INC f:\ibmcpp\dtools\inc\bsememf.INC\
        f:\ibmcpp\dtools\inc\bsedos16.INC f:\ibmcpp\dtools\inc\pmtypes.INC\
        f:\ibmcpp\dtools\inc\pmmle.INC f:\ibmcpp\dtools\inc\pmshl.INC\
        f:\ibmcpp\dtools\inc\pmerr.INC f:\ibmcpp\dtools\inc\pmsei.INC\
        f:\ibmcpp\dtools\inc\pmhelp.INC f:\ibmcpp\dtools\inc\pmbitmap.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fobase\Write.obj Write.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fobase\Write.obj Write.asm
!ENDIF

base\Read.obj : Read.asm SEGMENTS.INC COMDD.INC DCB.INC PACKET.INC MACRO.INC\
        ABIOS.INC DEVHLP.INC Hardware.inc f:\ibmcpp\dtools\inc\OS2.INC\
        f:\ibmcpp\dtools\inc\os2def.INC f:\ibmcpp\dtools\inc\bse.INC\
        f:\ibmcpp\dtools\inc\pm.INC f:\ibmcpp\dtools\inc\os2def16.INC\
        f:\ibmcpp\dtools\inc\bsedos.INC f:\ibmcpp\dtools\inc\bsedev.INC\
        f:\ibmcpp\dtools\inc\bsesub.INC f:\ibmcpp\dtools\inc\bseerr.INC\
        f:\ibmcpp\dtools\inc\pmwin.INC f:\ibmcpp\dtools\inc\pmgpi.INC\
        f:\ibmcpp\dtools\inc\pmdev.INC f:\ibmcpp\dtools\inc\pmavio.INC\
        f:\ibmcpp\dtools\inc\pmspl.INC f:\ibmcpp\dtools\inc\pmpic.INC\
        f:\ibmcpp\dtools\inc\pmord.INC f:\ibmcpp\dtools\inc\pmfont.INC\
        f:\ibmcpp\dtools\inc\pmstddlg.INC f:\ibmcpp\dtools\inc\bsememf.INC\
        f:\ibmcpp\dtools\inc\bsedos16.INC f:\ibmcpp\dtools\inc\pmtypes.INC\
        f:\ibmcpp\dtools\inc\pmmle.INC f:\ibmcpp\dtools\inc\pmshl.INC\
        f:\ibmcpp\dtools\inc\pmerr.INC f:\ibmcpp\dtools\inc\pmsei.INC\
        f:\ibmcpp\dtools\inc\pmhelp.INC f:\ibmcpp\dtools\inc\pmbitmap.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fobase\Read.obj Read.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fobase\Read.obj Read.asm
!ENDIF

base\IOCTL.obj : IOCTL.ASM SEGMENTS.INC COMDD.INC MACRO.INC PACKET.INC\
        DEVHLP.INC DCB.INC Hardware.inc f:\ibmcpp\dtools\inc\OS2.INC\
        f:\ibmcpp\dtools\inc\os2def.INC f:\ibmcpp\dtools\inc\bse.INC\
        f:\ibmcpp\dtools\inc\pm.INC f:\ibmcpp\dtools\inc\os2def16.INC\
        f:\ibmcpp\dtools\inc\bsedos.INC f:\ibmcpp\dtools\inc\bsedev.INC\
        f:\ibmcpp\dtools\inc\bsesub.INC f:\ibmcpp\dtools\inc\bseerr.INC\
        f:\ibmcpp\dtools\inc\pmwin.INC f:\ibmcpp\dtools\inc\pmgpi.INC\
        f:\ibmcpp\dtools\inc\pmdev.INC f:\ibmcpp\dtools\inc\pmavio.INC\
        f:\ibmcpp\dtools\inc\pmspl.INC f:\ibmcpp\dtools\inc\pmpic.INC\
        f:\ibmcpp\dtools\inc\pmord.INC f:\ibmcpp\dtools\inc\pmfont.INC\
        f:\ibmcpp\dtools\inc\pmstddlg.INC f:\ibmcpp\dtools\inc\bsememf.INC\
        f:\ibmcpp\dtools\inc\bsedos16.INC f:\ibmcpp\dtools\inc\pmtypes.INC\
        f:\ibmcpp\dtools\inc\pmmle.INC f:\ibmcpp\dtools\inc\pmshl.INC\
        f:\ibmcpp\dtools\inc\pmerr.INC f:\ibmcpp\dtools\inc\pmsei.INC\
        f:\ibmcpp\dtools\inc\pmhelp.INC f:\ibmcpp\dtools\inc\pmbitmap.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fobase\IOCTL.obj IOCTL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fobase\IOCTL.obj IOCTL.ASM
!ENDIF

base\UTIL.obj : UTIL.ASM SEGMENTS.INC COMDD.INC PACKET.INC MACRO.INC DCB.INC\
        DEVHLP.INC Hardware.inc f:\ibmcpp\dtools\inc\OS2.INC\
        f:\ibmcpp\dtools\inc\os2def.INC f:\ibmcpp\dtools\inc\bse.INC\
        f:\ibmcpp\dtools\inc\pm.INC f:\ibmcpp\dtools\inc\os2def16.INC\
        f:\ibmcpp\dtools\inc\bsedos.INC f:\ibmcpp\dtools\inc\bsedev.INC\
        f:\ibmcpp\dtools\inc\bsesub.INC f:\ibmcpp\dtools\inc\bseerr.INC\
        f:\ibmcpp\dtools\inc\pmwin.INC f:\ibmcpp\dtools\inc\pmgpi.INC\
        f:\ibmcpp\dtools\inc\pmdev.INC f:\ibmcpp\dtools\inc\pmavio.INC\
        f:\ibmcpp\dtools\inc\pmspl.INC f:\ibmcpp\dtools\inc\pmpic.INC\
        f:\ibmcpp\dtools\inc\pmord.INC f:\ibmcpp\dtools\inc\pmfont.INC\
        f:\ibmcpp\dtools\inc\pmstddlg.INC f:\ibmcpp\dtools\inc\bsememf.INC\
        f:\ibmcpp\dtools\inc\bsedos16.INC f:\ibmcpp\dtools\inc\pmtypes.INC\
        f:\ibmcpp\dtools\inc\pmmle.INC f:\ibmcpp\dtools\inc\pmshl.INC\
        f:\ibmcpp\dtools\inc\pmerr.INC f:\ibmcpp\dtools\inc\pmsei.INC\
        f:\ibmcpp\dtools\inc\pmhelp.INC f:\ibmcpp\dtools\inc\pmbitmap.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fobase\UTIL.obj UTIL.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fobase\UTIL.obj UTIL.ASM
!ENDIF

base\INIT.obj : INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC\
        f:\ibmcpp\dtools\inc\OS2.INC f:\ibmcpp\dtools\inc\os2def.INC\
        f:\ibmcpp\dtools\inc\bse.INC f:\ibmcpp\dtools\inc\pm.INC\
        f:\ibmcpp\dtools\inc\os2def16.INC f:\ibmcpp\dtools\inc\bsedos.INC\
        f:\ibmcpp\dtools\inc\bsedev.INC f:\ibmcpp\dtools\inc\bsesub.INC\
        f:\ibmcpp\dtools\inc\bseerr.INC f:\ibmcpp\dtools\inc\pmwin.INC\
        f:\ibmcpp\dtools\inc\pmgpi.INC f:\ibmcpp\dtools\inc\pmdev.INC\
        f:\ibmcpp\dtools\inc\pmavio.INC f:\ibmcpp\dtools\inc\pmspl.INC\
        f:\ibmcpp\dtools\inc\pmpic.INC f:\ibmcpp\dtools\inc\pmord.INC\
        f:\ibmcpp\dtools\inc\pmfont.INC f:\ibmcpp\dtools\inc\pmstddlg.INC\
        f:\ibmcpp\dtools\inc\bsememf.INC f:\ibmcpp\dtools\inc\bsedos16.INC\
        f:\ibmcpp\dtools\inc\pmtypes.INC f:\ibmcpp\dtools\inc\pmmle.INC\
        f:\ibmcpp\dtools\inc\pmshl.INC f:\ibmcpp\dtools\inc\pmerr.INC\
        f:\ibmcpp\dtools\inc\pmsei.INC f:\ibmcpp\dtools\inc\pmhelp.INC\
        f:\ibmcpp\dtools\inc\pmbitmap.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fobase\INIT.obj INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fobase\INIT.obj INIT.ASM
!ENDIF

base\UTILITY.obj : UTILITY.C COMDD.H CUTIL.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fobase\UTILITY.obj UTILITY.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fobase\UTILITY.obj UTILITY.C
!ENDIF

base\MCA.obj : MCA.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC\
        f:\ibmcpp\dtools\inc\OS2.INC f:\ibmcpp\dtools\inc\os2def.INC\
        f:\ibmcpp\dtools\inc\bse.INC f:\ibmcpp\dtools\inc\pm.INC\
        f:\ibmcpp\dtools\inc\os2def16.INC f:\ibmcpp\dtools\inc\bsedos.INC\
        f:\ibmcpp\dtools\inc\bsedev.INC f:\ibmcpp\dtools\inc\bsesub.INC\
        f:\ibmcpp\dtools\inc\bseerr.INC f:\ibmcpp\dtools\inc\pmwin.INC\
        f:\ibmcpp\dtools\inc\pmgpi.INC f:\ibmcpp\dtools\inc\pmdev.INC\
        f:\ibmcpp\dtools\inc\pmavio.INC f:\ibmcpp\dtools\inc\pmspl.INC\
        f:\ibmcpp\dtools\inc\pmpic.INC f:\ibmcpp\dtools\inc\pmord.INC\
        f:\ibmcpp\dtools\inc\pmfont.INC f:\ibmcpp\dtools\inc\pmstddlg.INC\
        f:\ibmcpp\dtools\inc\bsememf.INC f:\ibmcpp\dtools\inc\bsedos16.INC\
        f:\ibmcpp\dtools\inc\pmtypes.INC f:\ibmcpp\dtools\inc\pmmle.INC\
        f:\ibmcpp\dtools\inc\pmshl.INC f:\ibmcpp\dtools\inc\pmerr.INC\
        f:\ibmcpp\dtools\inc\pmsei.INC f:\ibmcpp\dtools\inc\pmhelp.INC\
        f:\ibmcpp\dtools\inc\pmbitmap.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fobase\MCA.obj MCA.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fobase\MCA.obj MCA.ASM
!ENDIF

base\C_INIT.obj : C_INIT.ASM SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        DCB.INC ABIOS.INC DEVHLP.INC Hardware.inc f:\ibmcpp\dtools\inc\OS2.INC\
        f:\ibmcpp\dtools\inc\os2def.INC f:\ibmcpp\dtools\inc\bse.INC\
        f:\ibmcpp\dtools\inc\pm.INC f:\ibmcpp\dtools\inc\os2def16.INC\
        f:\ibmcpp\dtools\inc\bsedos.INC f:\ibmcpp\dtools\inc\bsedev.INC\
        f:\ibmcpp\dtools\inc\bsesub.INC f:\ibmcpp\dtools\inc\bseerr.INC\
        f:\ibmcpp\dtools\inc\pmwin.INC f:\ibmcpp\dtools\inc\pmgpi.INC\
        f:\ibmcpp\dtools\inc\pmdev.INC f:\ibmcpp\dtools\inc\pmavio.INC\
        f:\ibmcpp\dtools\inc\pmspl.INC f:\ibmcpp\dtools\inc\pmpic.INC\
        f:\ibmcpp\dtools\inc\pmord.INC f:\ibmcpp\dtools\inc\pmfont.INC\
        f:\ibmcpp\dtools\inc\pmstddlg.INC f:\ibmcpp\dtools\inc\bsememf.INC\
        f:\ibmcpp\dtools\inc\bsedos16.INC f:\ibmcpp\dtools\inc\pmtypes.INC\
        f:\ibmcpp\dtools\inc\pmmle.INC f:\ibmcpp\dtools\inc\pmshl.INC\
        f:\ibmcpp\dtools\inc\pmerr.INC f:\ibmcpp\dtools\inc\pmsei.INC\
        f:\ibmcpp\dtools\inc\pmhelp.INC f:\ibmcpp\dtools\inc\pmbitmap.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fobase\C_INIT.obj C_INIT.ASM
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fobase\C_INIT.obj C_INIT.ASM
!ENDIF

base\RMHELP.obj : RMHELP.C rmcalls.h COMDD.H COMDCB.H CUTIL.H rmhelp.h
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fobase\RMHELP.obj RMHELP.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fobase\RMHELP.obj RMHELP.C
!ENDIF

base\SPRINTF_large.obj : SPRINTF_large.C COMDD.H
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fobase\SPRINTF_large.obj SPRINTF_large.C
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fobase\SPRINTF_large.obj SPRINTF_large.C
!ENDIF

base\va_large.obj : va_large.asm SEGMENTS.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fobase\va_large.obj va_large.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fobase\va_large.obj va_large.asm
!ENDIF

base\HdwTest.obj : HdwTest.asm SEGMENTS.INC COMDD.INC PACKET.INC INITMACRO.INC\
        ABIOS.INC DEVHLP.INC DCB.INC Hardware.inc MSG.INC\
        f:\ibmcpp\dtools\inc\OS2.INC f:\ibmcpp\dtools\inc\os2def.INC\
        f:\ibmcpp\dtools\inc\bse.INC f:\ibmcpp\dtools\inc\pm.INC\
        f:\ibmcpp\dtools\inc\os2def16.INC f:\ibmcpp\dtools\inc\bsedos.INC\
        f:\ibmcpp\dtools\inc\bsedev.INC f:\ibmcpp\dtools\inc\bsesub.INC\
        f:\ibmcpp\dtools\inc\bseerr.INC f:\ibmcpp\dtools\inc\pmwin.INC\
        f:\ibmcpp\dtools\inc\pmgpi.INC f:\ibmcpp\dtools\inc\pmdev.INC\
        f:\ibmcpp\dtools\inc\pmavio.INC f:\ibmcpp\dtools\inc\pmspl.INC\
        f:\ibmcpp\dtools\inc\pmpic.INC f:\ibmcpp\dtools\inc\pmord.INC\
        f:\ibmcpp\dtools\inc\pmfont.INC f:\ibmcpp\dtools\inc\pmstddlg.INC\
        f:\ibmcpp\dtools\inc\bsememf.INC f:\ibmcpp\dtools\inc\bsedos16.INC\
        f:\ibmcpp\dtools\inc\pmtypes.INC f:\ibmcpp\dtools\inc\pmmle.INC\
        f:\ibmcpp\dtools\inc\pmshl.INC f:\ibmcpp\dtools\inc\pmerr.INC\
        f:\ibmcpp\dtools\inc\pmsei.INC f:\ibmcpp\dtools\inc\pmhelp.INC\
        f:\ibmcpp\dtools\inc\pmbitmap.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fobase\HdwTest.obj HdwTest.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fobase\HdwTest.obj HdwTest.asm
!ENDIF

base\IniAccess.obj : IniAccess.c COMDD.H COMDCB.H CUTIL.H rmcalls.h message.c
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fobase\IniAccess.obj IniAccess.c
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fobase\IniAccess.obj IniAccess.c
!ENDIF

base\InitUtil.obj : InitUtil.asm SEGMENTS.INC COMDD.INC PACKET.INC\
        INITMACRO.INC DCB.INC DEVHLP.INC Hardware.inc MSG.INC\
        f:\ibmcpp\dtools\inc\OS2.INC f:\ibmcpp\dtools\inc\os2def.INC\
        f:\ibmcpp\dtools\inc\bse.INC f:\ibmcpp\dtools\inc\pm.INC\
        f:\ibmcpp\dtools\inc\os2def16.INC f:\ibmcpp\dtools\inc\bsedos.INC\
        f:\ibmcpp\dtools\inc\bsedev.INC f:\ibmcpp\dtools\inc\bsesub.INC\
        f:\ibmcpp\dtools\inc\bseerr.INC f:\ibmcpp\dtools\inc\pmwin.INC\
        f:\ibmcpp\dtools\inc\pmgpi.INC f:\ibmcpp\dtools\inc\pmdev.INC\
        f:\ibmcpp\dtools\inc\pmavio.INC f:\ibmcpp\dtools\inc\pmspl.INC\
        f:\ibmcpp\dtools\inc\pmpic.INC f:\ibmcpp\dtools\inc\pmord.INC\
        f:\ibmcpp\dtools\inc\pmfont.INC f:\ibmcpp\dtools\inc\pmstddlg.INC\
        f:\ibmcpp\dtools\inc\bsememf.INC f:\ibmcpp\dtools\inc\bsedos16.INC\
        f:\ibmcpp\dtools\inc\pmtypes.INC f:\ibmcpp\dtools\inc\pmmle.INC\
        f:\ibmcpp\dtools\inc\pmshl.INC f:\ibmcpp\dtools\inc\pmerr.INC\
        f:\ibmcpp\dtools\inc\pmsei.INC f:\ibmcpp\dtools\inc\pmhelp.INC\
        f:\ibmcpp\dtools\inc\pmbitmap.INC
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fobase\InitUtil.obj InitUtil.asm
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fobase\InitUtil.obj InitUtil.asm
!ENDIF


base\$(PROJ).sys : $(DEF_FILE) $(OBJS)
!IF $(DEBUG)
        $(LRF) @<<base\$(PROJ).lrf
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
        $(LRF) @<<base\$(PROJ).lrf
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
        $(LINKER) @base\$(PROJ).lrf
!ELSE
        $(LINKER) @base\$(PROJ).lrf
!ENDIF


.c.obj :
!IF $(DEBUG)
        $(CC) /c $(CFLAGS_G) $(CFLAGS_D) /Fo$@ $<
!ELSE
        $(CC) /c $(CFLAGS_G) $(CFLAGS_R) /Fo$@ $<
!ENDIF

.asm.obj :
!IF $(DEBUG)
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_D) /Fo$@ $<
!ELSE
        $(ASM) /c $(AFLAGS_G) $(AFLAGS_R) /Fo$@ $<
!ENDIF


run: base\$(PROJ).sys
        base\$(PROJ).exe $(RUNFLAGS)

debug: base\$(PROJ).sys
