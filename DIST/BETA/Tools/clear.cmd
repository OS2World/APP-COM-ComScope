/* clear destination directory */

  call RxFuncAdd 'SysFileTree', 'RexxUtil', 'SysFileTree'

call SysFileTree ".\TEST\*","Files","S","*****"
IF Files.0 > 0 THEN DO
  "attrib .\test\*.* -h"
  "del .\test\*.* < yes.ans"
 END
ELSE
 SAY "No files to clean up"
