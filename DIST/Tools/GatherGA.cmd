/* copy newest versions */
'@echo off'
'mode 50, 40'
SAY ''
SAY 'Gather all GA files'
SAY ''

SourcePath='\\tools1\projects'
LibPath='f:\work\lib'
ExePath='f:\work'
SourcePath='p:'
DestPath='w:\dist\beta'
HelpPath='\\tools1\projects\help'

say '-------- Configuration --------'
say 'COMi_CFG.DLL'
'copy 'LibPath'\COMI_CFG.DLL 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

say 'Config.HLP'
'copy 'HelpPath'\Config.hlp 'DestPath'\HelpFiles > NUL'
IF RC \= 0 THEN SIGNAL Error

say '-------- Spooler --------'
say 'COMi_SPL.PDR'
'copy 'LibPath'\COMi_SPL.PDR 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

say 'SPL_DEMO.PDR'
'copy 'LibPath'\SPL_DEMO.PDR 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

say '-------- Runtime library ------'
say 'OS2LSRTL.DLL'
'copy 'LibPath'\OS2LSRTL.DLL 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

say '-------- Utilities ----------'
say 'OS2LS_IO.DLL'
'copy 'LibPath'\OS2LS_IO.DLL 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

say 'OS2LS_PR.DLL'
'copy 'LibPath'\OS2LS_PR.DLL 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

say 'OS2LS_UT.DLL'
'copy 'LibPath'\OS2LS_UT.DLL 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

say 'COMi_CTL.DLL'
'copy 'LibPath'\COMi_CTL.DLL 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

say 'IniDump.exe'
'copy 'ExePath'\IniDump.exe 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

say 'Control.exe'
'copy 'ExePath'\Control.exe 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

say '-------- COMscope --------'
say 'COMscope.EXE'
'copy 'ExePath'\COMscope.EXE 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

say 'CSDEMO.EXE'
'copy 'ExePath'\CSDEMO.EXE 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

say 'COMscope.HLP'
'copy 'HelpPath'\COMscope.hlp 'DestPath'\HelpFiles > NUL'
IF RC \= 0 THEN SIGNAL Error

say 'COMscope.HLP -> CSDEMO.HLP'
'copy 'HelpPath'\COMscope.HLP 'DestPath'\HelpFiles\CSDEMO.HLP > NUL'
IF RC \= 0 THEN SIGNAL Error

say '-------- Install --------'
say 'INSTALL.EXE'
'copy 'ExePath'\INSTALL.EXE 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

say 'PDA_INST.DLL'
'copy 'LibPath'\pda_inst.dll 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

say 'MakeProf.exe'
'copy 'ExePath'\MakeProf.exe 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

say 'Source files'
'copy 'SourcePath'\extra\Ioctl.c 'DestPath'\Source > NUL'
IF RC \= 0 THEN SIGNAL Error
'copy 'SourcePath'\extra\Ioctl.h 'DestPath'\Source > NUL'
IF RC \= 0 THEN SIGNAL Error
'copy 'SourcePath'\extra\split.c 'DestPath'\Source > NUL'
IF RC \= 0 THEN SIGNAL Error


/*
say 'PDB_INST.DLL'
'copy 'LibPath'\pdb_inst.dll 'DestPath'\Targets > NUL'
IF RC \= 0 THEN SIGNAL Error

*/
say ''

SAY '===================='
SAY '=    All Copied!   ='
SAY '===================='

SIGNAL COPY_END

Error:

SAY '====================='
SAY '=    Copy Failed!   ='
SAY '====================='

COPY_END:
