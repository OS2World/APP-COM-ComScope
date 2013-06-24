OBJS = rcstub.obj

FNTS = hex1.fnt ascii1.fnt hex2.fnt ascii2.fnt 6x8.fnt

.c.obj:
    cl /c /Gs /Fo$@ $<

all: HEXFONTS.FON

.SUFFIXES:
.SUFFIXES: .obj .c .fnt .rc

HEXFONTS.FON: rcstub.obj fonts.def $(FNTS)
        link rcstub.obj, fonts.dll,, /NOD, fonts.def
        rc fonts.rc fonts.dll
        copy fonts.dll HEXFONTS.FON

rcstub.obj: rcstub.c
