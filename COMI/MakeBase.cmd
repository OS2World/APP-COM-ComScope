/* REXX */

PARSE UPPER ARG Arg1 Arg2 junk
   
"set include=f:\ibmcpp\dtools\h;f:\ibmcpp\dtools\inc;f:\ibmcpp\inc;p:\COMi;"
"set lib=f:\ibmcpp\lib;p:\COMi\lib;"
"set path=f:\ibmcpp\dtools;"

p:
'cd \COMi'

IF (SUBSTR(Arg1,1,1) = 'A') THEN
  'nmake /A /f comdd.mak'
ELSE
  'nmake /f comdd.mak'

