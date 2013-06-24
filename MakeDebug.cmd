/* REXX */
'@echo off '

PARSE UPPER ARG Arg1 Arg2 Arg3

Command = 'r'

IF (SUBSTR(Arg1, 1, 1) = "A") THEN
  Command = 'A'

IF VALUE("ENVSET", 'SET', 'OS2ENVIRONMENT') \= 'SET' THEN DO
  'set include=%include%;p:\include;p:\comi'
  'set lib=%lib%;p:\lib'
 END

SAY 'Making Utilities DLL'
'cd\utility\debug'
'nmake /'Command' /nologo /f OS2ls_ut.mak'
IF RC \= 0 THEN SIGNAL ErrorOut

SAY 'Making Profile DLL'
'cd\profile\debug'
'nmake /'Command' /nologo /f os2ls_pr.mak'
IF RC \= 0 THEN SIGNAL ErrorOut

SAY 'Making COMi I/O control DLL'
'cd\ioctl\debug'
'nmake /nologo /'Command' /F os2ls_io.mak'
IF RC \= 0 THEN SIGNAL ErrorOut

SAY 'Making COMi Control DLL'
'cd\COMcontrol\debug'
'nmake /'Command' /nologo /f COMi_CTL.mak'
IF RC \= 0 THEN SIGNAL ErrorOut

SAY 'Making Configuration DLL'
'cd\config\debug'
'nmake /'Command' /nologo /f COMi_CFG.mak'
IF RC \= 0 THEN SIGNAL ErrorOut

SAY 'Making Control.exe'
'cd\control\debug'
'nmake /'Command' /nologo /f control.mak'
IF RC \= 0 THEN SIGNAL ErrorOut

SAY 'Making COMscope'
'cd\comscope\debug'
'nmake /nologo /'Command' /f comscope.mak'
IF RC \= 0 THEN SIGNAL ErrorOut
/*
SAY 'Making COMscope DEMO'
'cd ..\demo'
'nmake /'Command' /nologo /f CSDEMO.mak'
IF RC \= 0 THEN SIGNAL ErrorOut
*/
SAY 'Making Spooler DLL'
'cd\spooler\debug'
'nmake /'Command' /nologo /f COMi_SPL.mak'
IF RC \= 0 THEN SIGNAL ErrorOut
/*
SAY 'Making Spooler DEMO DLL'
'cd ..\demo'
'nmake /nologo /'Command' /f SPL_DEMO.mak'
IF RC \= 0 THEN SIGNAL ErrorOut
*/
SAY 'Making Install executable'
'cd\install\debug'
'nmake /nologo /'Command' /F install.mak'
IF RC \= 0 THEN SIGNAL ErrorOut

SAY 'Making COMi install DLL'
'cd ..\PDA\GA '
'nmake /nologo /'Command' /F pda_inst.mak'
IF RC \= 0 THEN SIGNAL ErrorOut

SAY 'Making WinCOM executable'
'cd \WinCOM32\debug'
'nmake /nologo /'Command' /F WinCOM.mak'
IF RC \= 0 THEN SIGNAL ErrorOut

SIGNAL END_MAKE

ErrorOut:

SAY '================='
SAY 'Make failed'
SAY '================='

END_MAKE:
'cd \'
echo.

