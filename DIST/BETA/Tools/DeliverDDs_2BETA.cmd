/* rexx */

CmdOut = '1>NUL'
DistSub = 'Dist\Beta'
SourceDrive = 'P:'
DistDrive = 'W:'
DistPath = DistDrive'\'DistSub
SourcePath = SourceDrive'\COMi'
'@echo off'
SAY 'Distribution path = 'DistPath
SAY 'Source path = 'SourcePath

SourceDrive
'cd 'SourcePath
say '==================================='
say 'COMi GA'
'cd base'
'mapsym comdd 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR
'copy comdd.sy? 'DistPath'\_COMi 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR

say 'Globetek'
'cd ..\globe'
'mapsym COMDD 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR
'copy COMDD.sy? 'DistPath'\_Globetek\GCOMDD.sy? 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR

say 'Moxa'
'cd ..\Moxa'
'mapsym COMDD 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR
'copy COMDD.sy? 'DistPath'\_Moxa\MCOMDD.sy? 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR

say 'Connect Tech DFLEX & Blue Heat '
'cd ..\ConnectTech'
'mapsym COMDD 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR
copy 'COMDD.sy? 'DistPath'\_ConnectTech\CCOMM.sy? 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR

say 'DEMO'
'cd ..\eval'
'mapsym comdde 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR
'copy comdde.sy? 'DistPath'\_CSdemo\ 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR

say 'Sealevel'
'cd ..\sealevel'
'mapsym comdd 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR
'copy comdd.sy? 'DistPath'\_Sealevel\SCOMDD.sy? 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR
/*
say 'Comtrol'
'cd ..\Comtrol'
'mapsym COMDD 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR
'copy COMDD.sy? 'DistPath'\_Comtrol\CCOMDD.SY? 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR

say 'Sealevel Retail'
'cd ..\sealevelR'
'mapsym scomdd 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR
'copy scomdd.sy? 'DistPath'\_SealevelR\ 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR

say 'Personal COMi'
'cd ..\share'
'mapsym pCOMi 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR
'copy pcomi.sy? 'DistPath'\pCOMi.sys\ 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR

say 'Neotech'
'cd ..\neotech'
mapsym 'ncomdd 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR
'copy ncomdd.sy? 'DistPath'\NCOMDD.sys\ 'CmdOut
IF RC <> 0 THEN SIGNAL ERROR
say ''
*/

SAY ''
SAY '+=================================+'
SAY '+   DD''s Delivered successfully   +'
SAY '+=================================+'

SIGNAL Deliver_End

Error:

SAY ''
SAY '+=========================+'
SAY '+   DD Delivery failed!   +'
SAY '+=========================+'
PAUSE

Deliver_End:
