/* make zipped version of "Product" */
"@echo off"
/*  call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
    call SysLoadFuncs */

  call RxFuncAdd 'SysFileTree', 'RexxUtil', 'SysFileTree'

PARSE ARG Product Mod1 Mod2 junk

IF LENGTH(Product) = 0 then signal Error

call SysFileTree "\ZIPTEMP\*","Files","S","*****"
IF Files.0 > 0 THEN DO
  "attrib ZIPtemp\* -h"
  "del ZIPtemp\* < YES.ANS"
END

call SysFileTree "\ZIPED\"Product".ZIP","Files","S","*****"
IF Files.0 > 0 THEN
  "del ZIPPED\"Product".zip < YES.ANS"

call "makedisk" Product "ZIPtemp"

"zip -jS9 ZIPPED\"Product".zip ZIPtemp\*"
EXIT
Error:
SAY ""
SAY "You must supply a app name, i.e. COMi"
SAY
SAY "Apply capitalization as you want it to appear in resultant filename"
SAY

