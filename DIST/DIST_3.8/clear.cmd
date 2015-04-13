/* clear destination directory */

  call RxFuncAdd 'SysFileTree', 'RexxUtil', 'SysFileTree'

call SysFileTree "D:\TEST\*","Files","S","*****"
IF Files.0 > 0 THEN DO
  "attrib d:\test\*.* -h"
  "del d:\test\*.* < yes.ans"
END
