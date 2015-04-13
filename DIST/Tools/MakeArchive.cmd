/* make zipped version of "Product" */
/*
call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
    call SysLoadFuncs
*/
call RxFuncAdd 'SysFileTree', 'RexxUtil', 'SysFileTree'

'@echo off'

'Mode 80,100'

SourcePath = 'W:\Dist\Beta'

PARSE ARG Product junk

IF LENGTH(Product) = 0 then signal Error

ZIPtempSpec = SourcePath'\ZIPTemp'
ZIPPEDSpec = SourcePath'\ZIPPED'

call SysFileTree ZIPtempSpec'\*', 'Files', 'F'
IF Files.0 > 0 THEN DO
  SAY "Clear temporary directory"
  'attrib 'ZIPtempSpec'\* -h -r > NUL'
  'del 'ZIPtempSpec'\* < YES.ANS > NUL'
  IF RC <> 0 THEN DO
    SAY 'Failed to delete 'ZIPPEDSpec' files'
    EXIT "DELETE TEMP FAILED"
   END
END
call SysFileTree ZIPPEDSpec'\'Product'.ZIP', 'Files', 'F'
IF Files.0 > 0 THEN  DO
  SAY 'Deleting old archive for 'Product
  del ZIPPEDSpec'\'Product'.zip < YES.ANS > NUL'
  IF RC <> 0 THEN DO
    SAY 'Failed to delete 'ZIPPEDSpec'\'Product'.zip'
    EXIT "DELETE OLD FAILED"
   END
 END  

call "MakeDistribution" Product ZIPtempSpec

IF RESULT <> "OK" THEN DO
  SAY "MakeDistribution failed"
  EXIT "FAIL"
 END

'zip -jS9 'ZIPPEDSpec'\'Product'.zip 'ZIPtempSpec'\*'

EXIT "OK"

Error:

SAY ""
SAY "You must supply a app name, i.e. COMi"
SAY ''
SAY "Apply capitalization as you want it to appear in resultant filename"
SAY

EXIT "BAD PARAM"

