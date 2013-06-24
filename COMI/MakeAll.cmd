/* REXX */
'@echo off '

PARSE UPPER ARG Arg1 Arg2 Arg3

Command = 'r'

IF LENGTH(Arg1) \= 0 THEN
  Command = SUBSTR(Arg1, 1, 1)
  
'mode 132,60'
  
SETLOCAL
'set path=f:\ibmcpp\dtools'
'set include=f:\ibmcpp\dtools\inc;f:\ibmcpp\dtools\h;p:\COMi;'
SAY ''
SAY ' -------------------------- Build Retail COMi -----------------------------------'
'nmake /nologo /'Command' /f comdd.mak'
IF RC \= 0 THEN SIGNAL Error
SAY ''
SAY ' -------------------------- Build Evaluation version ----------------------------'
'nmake /nologo /'Command' /f comdde.mak'
IF RC \= 0 THEN SIGNAL Error
SAY ''
SAY ' -------------------------- Build Connect Tech -----------------------------------------'
'nmake /nologo /'Command' /f ConnectTech.mak'
IF RC \= 0 THEN SIGNAL Error
SAY ''
SAY ' -------------------------- Build Globetek --------------------------------------'
'nmake /nologo /'Command' /f globetek.mak'
IF RC \= 0 THEN SIGNAL Error
SAY ''
SAY ' -------------------------- Build Moxa --------------------------------------'
'nmake /nologo /'Command' /f Moxa.mak'
IF RC \= 0 THEN SIGNAL Error
SAY ''
SAY ' -------------------------- Build OEM Sealevel ----------------------------------'
'nmake /nologo /'Command' /f sealevel.mak'
IF RC \= 0 THEN SIGNAL Error
SAY ''
/*
SAY ''
SAY ' -------------------------- Build Personal COMi ---------------------------------'
'nmake /nologo /'Command' /f pCOMi.mak'
IF RC \= 0 THEN SIGNAL Error
SAY ' -------------------------- Build COMscope personal COMi ------------------------'
'nmake /nologo /'Command' /f share_CS.mak'
IF RC \= 0 THEN SIGNAL Error
SAY ''
SAY ' -------------------------- Build retail Sealevel -------------------------------'
'nmake /nologo /'Command' /f SealevelR.mak'
IF RC \= 0 THEN SIGNAL Error
SAY ''
*/
SAY '+======================+'
SAY '+   Make successful!   +'
SAY '+======================+'
SIGNAL end_makeall
Error:
SAY ''
SAY '+==================+'
SAY '+   Make failed!   +'
SAY '+==================+'

end_makeall:

ENDLOCAL
