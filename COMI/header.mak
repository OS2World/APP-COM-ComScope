all: comdcb.lst

comdcb.lst: comdcb.h header.mak
  icc /c /ss /DDEBUGGO /Lb+ comdcb.h
