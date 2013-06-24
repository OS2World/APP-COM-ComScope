/* rexx */
CALL RxFuncAdd  'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
CALL SysLoadFuncs

'@echo off'

SETLOCAL
'set path=f:\ibmcpp\dtools'
'set include=f:\ibmcpp\dtools\inc;f:\ibmcpp\dtools\h;p:\COMi;'

MUT_dir = "\\oc_gilroy\cee\comm"
'cd \COMi'

'nmake /f comdd.mak'
'cd base'
'p:\COMi\mapsym comdd'
'copy comdd.sy?' MUT_dir '> NUL'
SIGNAL ENDFUNC
SAY ''
SAY "Failed to build BASE COMi"
SAY ''
ENDFUNC:
'cd \COMi'

ENDLOCAL

