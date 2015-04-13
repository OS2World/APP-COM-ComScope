/* rexx */
DistDrive='w:'
SourceDrive='p:'
DistPath='w:\dist\beta'
SourcePath='p:\COMi'
'@echo off'
say ''
SourceDrive
cd SourcePath'\base'
say 'COMi Retail'
mapsym 'comdd > NUL'
copy 'comdd.sys 'DistPath'\COMDD.sys > NUL'
copy 'comdd.sym 'DistPath'\COMDD.sym > NUL'

say 'Personal COMi'
cd SourcePath'\share'
mapsym 'pCOMi > NUL'
copy 'pcomi.sys 'DistPath'\pCOMi.sys > NUL'
copy 'pcomi.sym 'DistPath'\pCOMi.sym > NUL'

say 'DFLEX'
cd SourcePath'\dflex'
mapsym 'dflex > NUL'
copy 'DFLEX.sys 'DistPath'\DFLEX.sys > NUL'
copy 'DFLEX.sym 'DistPath'\DFLEX.sym > NUL'

say 'Globetek'
cd SourcePath'\globe'
mapsym 'GLOBE > NUL'
copy 'GLOBE.sys 'DistPath'\GLOBETEK.sys > NUL'
copy 'GLOBE.sym 'DistPath'\GLOBETEK.sym > NUL'

say 'DEMO'
cd SourcePath'\eval'
mapsym 'comdde > NUL'
copy 'comdde.sys 'DistPath'\COMDDE.sys > NUL'
copy 'comdde.sym 'DistPath'\COMDDE.sym > NUL'

say 'Sealevel'
cd SourcePath'\sealevel'
mapsym 'scomdd > NUL'
copy 'scomdd.sys 'DistPath'\SCOMDD.sys > NUL'
copy 'scomdd.sym 'DistPath'\SCOMDD.sym > NUL'

say 'Neotech'
cd SourcePath'\neotech'
mapsym 'ncomdd > NUL'
copy 'ncomdd.sys 'DistPath'\NCOMDD.sys > NUL'
copy 'ncomdd.sym 'DistPath'\NCOMDD.sym > NUL'
say ''
DistDrive
