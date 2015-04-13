/* Make Distribution Disk */
'@echo off'

  call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
  call SysLoadFuncs

"set SourceDrive=W:"
bCopyDemo = FALSE
count = ARG()
if count = 0 then
  do
  say "You must supply a version directory as parameter one."
  say ''
  say "You may also supply a destination path as parameter two"
  say "and the word DEBUG as the third parameter, for obvious purposes."
  'pause'
  return
  end
sParams = ARG(1)
PARSE UPPER VAR sParams sSource sDestination sDebug
if LENGTH(sDebug) <> 0 then
  do
  say "Debug Enabled"
  sNull = CON
  bDebug = 1
  end
else
  do
  sNull = NUL
  bDebug = 0
  end
if bDebug <> 0 then
  say 'Parameters are: 'sParams
if LENGTH(sDestination) = 0 then
  do
  sDestination = 'A:'
  bInstallingDiskette = 'TRUE'
  end
else
  do
  bInstallingDiskette = 'FALSE'
  sDestination = STRIP(sDestination,'t','\')
  end
sSource = STRIP(sSource,'t','\')
if bDebug <> 0 then
  do
  say 'Using file list: 'sSource'\FILES.LST'
  say 'Destination is: 'sDestination
  end
sFileList = sSource'\FILES.LST'
IF bDebug <> 0 THEN
  SAY "Setting attributes to un-hide source initialization files"
attrib sSource"\*.ini -h >" sNull
sDisk = SUBSTR(sDestination,1,2)
if sDisk = 'A:' | sDisk = 'B:' then 
  bFloppy = 'TRUE'
if bFloppy <> 'TRUE' then
  do
  call SysFileTree sDestination"\*","Files","S","*****"
  IF Files.0 > 0 THEN
    do
    if bDebug <> 0 then
      say "Resetting attributes to allow deletion of all files in" sDestination
    attrib sDestination'\*.* -h >' sNull
    if bDebug <> 0 then
      say 'del' sDestination'\*.* < yes.ans >' sNull
    else
      say "Deleting all files on "sDestination
    del sDestination'\*.* < yes.ans >' sNull
    end
  end
if bDebug <> 0 then
  do
  'pause'
  say 'File list is:' sFileList
  end
verify on
iIndex = 0
do while (LINES(sFileList) = 1)
  sLine.iIndex = LINEIN(sFileList)
  iIndex = iIndex + 1
end
zero = CHAROUT(sFileList)
count = iIndex
iIndex = 0
if bFloppy = 'TRUE' then
  do
  if bDebug <> 0 then
    say 'format ' sDisk '/Q /ONCE >' sNull
  else
    say 'Formatting' sDisk 'with label 'sLine.iIndex
  format sDisk '/Q /ONCE /V:'sLine.iIndex' >' sNull
  end
iIndex = 1
do while (iIndex < count)
  sFileName = sLine.iIndex
  iIndex = iIndex + 1
  if bDebug <> 0 then
    say 'Processing' sFileName
  if SUBSTR(sFileName,1,1) = '[' then
    do
    sDemoDir = STRIP(sFileName,'T',']')
    sDemoDir = STRIP(sDemoDir,'L','[')
    if bDebug <> 0 then
      do
      say 'Processing new directory' sDemoDir
      'pause'
      end
    if (iIndex < count) then
      do
      sFileName = sLine.iIndex
      iIndex = iIndex + 1
      if bDebug <> 0 then
        say 'Processing' sFileName
      bCopyDemo = TRUE
      if bDebug <> 0 then
        say 'Setting attributes to hide initialization files'
      attrib sDestination'\*.ini +h >' sNull
      if bDebug <> 0 then
        say 'Setting attributes to hide icon files'
      attrib sDestination'\*.ico +h >' sNull
      say 'Making 'sDemoDir' directory'
      md sDestination'\'sDemoDir
      sDestination = sDestination'\'sDemoDir
      if bDebug <> 0 then
        say 'Setting attributes to un-hide' sFileName
      attrib sFileName' -h >' sNull
      if bDebug <> 0 then
        do
        'pause'
        end
      end
    if bFloppy <> 'TRUE' then
      do
      call SysFileTree sDestination"\*","Files","S","*****"
      IF Files.0 > 0 THEN
        do
        if bDebug <> 0 then
          say "Resetting attributes to allow deletion of all files in" sDestination
        attrib sDestination'\*.* -h >' sNull
        if bDebug <> 0 then
          say 'del' sDestination'\*.* < yes.ans >' sNull
        else
          say "Deleting all files on "sDestination
        del sDestination'\*.* < yes.ans >' sNull
        END
      end
    end
  if bDebug <> 0 then
    'pause'
  if (LENGTH(sFileName) <> 0) then
    do
    PARSE VAR sFileName sFileName sDestFile
    if LENGTH(sDestFile) <> 0 then
      do
      if (LENGTH(sDestFile) <> 0) then
        do
        sDestSpec = sDestination'\'sDestFile
        if bDebug <> 0 then
          say 'copy 'sFileName sDestSpec '>' sNull
        else
          say 'Copying 'sFileName' to 'sDestFile
        end
      end
    else
      do
      sDestSpec = sDestination'\'FILESPEC('name',sFileName)
      if bDebug <> 0 then
        say 'copy 'sFileName sDestSpec '>' sNull
      else
        say 'Copying 'sFileName
      end
    copy sFileName sDestSpec '>' sNull
    end
  end
verify off
if bDebug <> 0 then
  say 'Setting attributes to hide initialization files'
attrib sDestination'\*.ini +h >' sNull
if bDebug <> 0 then
  say 'Setting attributes to hide icon files'
attrib sDestination'\*.ico +h >' sNull
if bDebug<> 0 then
  do
  'pause'
  end

