/* REXX */

'@echo off'

PARSE UPPER ARG Arg1 Arg2 junk

env = "OS2ENVIRONMENT"

IF VALUE('ENVSET', 'DD', env) \= 'DD' THEN DO
  "set include=f:\ibmcpp\dtools\h;f:\ibmcpp\dtools\inc;f:\ibmcpp\inc;p:\COMi;"
  "set lib=f:\ibmcpp\lib;p:\COMi\lib;"
  "set path=f:\ibmcpp\dtools;%path%"
 END
 
p:
'cd \COMi'

IF (SUBSTR(Arg1,1,1) = 'A') THEN
  'nmake /A /f Sealevel.mak'
ELSE
  'nmake /f Sealevel.mak'

