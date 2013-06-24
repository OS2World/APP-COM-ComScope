/* REXX */
'@echo off'

  call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
  call SysLoadFuncs

/*
** This command file delivers all versions to an archive directory named in the parmaeter
** The prameter should reflect the version of COMi that is being archived
*/
PARSE UPPER ARG TargetDir junk

IF LENGTH(TargetDir) = 0 THEN SIGNAL no_params

'cd \COMi'
CALL SysFileTree TargetDir, 'Dirs', 'D'
IF Dirs.0 = 0 THEN SIGNAL continue
SAY ''
SAY ' The directory already exists and has archives present, do you'
SAY ' wish to overwrite the existing archives?'
SAY ''
pause
SIGNAL copy_only

continue:
'md 'TargetDir' > NUL'
copy_only:
SAY ''
SAY 'COMi Retail'
'cd \COMi\base'
'copy comdd.sys \COMi\'TargetDir'\COMDD.SYS > NUL'
'copy comdd.sym \COMi\'TargetDir'\COMDD.SYM > NUL'
'copy comdd.map \COMi\'TargetDir'\COMDD.MAP > NUL'

SAY 'Connect Tech'
'cd \COMi\ConnectTech'
'copy COMDD.sys \COMi\'TargetDir'\CCOMM.SYS > NUL'
'copy COMDD.sym \COMi\'TargetDir'\CCOMM.SYM > NUL'
'copy COMDD.map \COMi\'TargetDir'\CCOMM.MAP > NUL'

SAY 'Globetek'
'cd \COMi\globe'
'copy COMDD.sys \COMi\'TargetDir'\GCOMDD.SYS > NUL'
'copy COMDD.sym \COMi\'TargetDir'\GCOMDD.SYM > NUL'
'copy COMDD.map \COMi\'TargetDir'\GCOMDD.MAP > NUL'

SAY 'Moxa'
'cd \COMi\Moxa'
'copy COMDD.sys \COMi\'TargetDir'\MCOMDD.SYS > NUL'
'copy COMDD.sym \COMi\'TargetDir'\MCOMDD.SYM > NUL'
'copy COMDD.map \COMi\'TargetDir'\MCOMDD.MAP > NUL'

SAY 'DEMO'
'cd \COMi\eval'
'copy comdde.sys \COMi\'TargetDir'\COMDDE.SYS > NUL'
'copy comdde.sym \COMi\'TargetDir'\COMDDE.SYM > NUL'
'copy comdde.map \COMi\'TargetDir'\COMDDE.MAP > NUL'

SAY 'Sealevel'
'cd \COMi\sealevel'
'copy comdd.sys \COMi\'TargetDir'\SCOMDD.SYS > NUL'
'copy comdd.sym \COMi\'TargetDir'\SCOMDD.SYM > NUL'
'copy comdd.map \COMi\'TargetDir'\SCOMDD.MAP > NUL'
/*
SAY 'Personal COMi'
cd \COMi\share
copy comishar.sys \COMi\'TargetDir'\COMi.SYS > NUL
copy comishar.sym \COMi\'TargetDir'\COMi.SYM > NUL
copy comishar.map \COMi\'TargetDir'\COMi.MAP > NUL

SAY 'Neotech'
cd \COMi\neotech
copy ncomdd.sys \COMi\'TargetDir'\NCOMDD.SYS > NUL
copy ncomdd.sym \COMi\'TargetDir'\NCOMDD.SYM > NUL
copy ncomdd.map \COMi\'TargetDir'\NCOMDD.MAP > NUL
*/
SAY ''
'cd \COMi'
EXIT

no_params:
SAY ''
SAY ' USAGE: DeliverVersion archive_directory'
SAY ''
SAY ' Copies all current versions to archive_directory.'
SAY ''

EXIT
