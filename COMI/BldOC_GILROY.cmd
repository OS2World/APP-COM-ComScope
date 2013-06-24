/* REXX */

'mode 80,60'
SAY ''
SAY 'Building COMDD'

SETLOCAL

"set include=f:\ibmcpp\dtools\h;f:\ibmcpp\dtools\inc;f:\ibmcpp\inc;p:\COMi;"
"set lib=f:\ibmcpp\lib;p:\COMi\lib;"
"set path=f:\ibmcpp\dtools;"

'p:'
'cd \COMi'
'nmake /f comdd.mak'
IF RC <> 0 THEN SIGNAL build_error
'cd base'
'..\mapsym comdd'
SAY 'Moving COMDD to OC_GILROY'
'copy comdd.sy? \\oc_gilroy\cee\comm'
'cd ..'
SIGNAL end_make
build_error:
SAY "RC = "RC
SAY ""
SAY "failed to build debug"
SAY ""
pause
end_make:

ENDLOCAL
