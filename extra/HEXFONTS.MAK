OBJS = rcstub.obj

.c.obj:
    cl /c /Gs $<

all: FONTS.dll

.SUFFIXES:
.SUFFIXES: .obj .c

fonts.dll: font\rcstub.obj font\hexfonts.def font\hex.fnt font\alpha.fnt
        link font\rcstub.obj, fonts.dll,,/NOD,font\hexfonts.def
        rc font\hexfonts.rc fonts.dll

font\rcstub.obj: rcstub.c
        cl /c /Gs rcstub.c
