/* Make Distribution Disk */
'@echo off'
bCopyDemo = FALSE
count = ARG()
if count = 0 then do
  say "You must supply a version directory as parameter one."
  say ''
  say "You may also supply a destination path as parameter two"
  say "and the word DEBUG as the third parameter, for obvious purposes."
  pause
  return
end
sParams = ARG(1)
PARSE UPPER VAR sParams sSource sDestination sDebug
if LENGTH(sDebug) <> 0 then do
  say "Debug Enabled"
  sNull = CON
  bDebug = 1
end
else do
  sNull = NUL
  bDebug = 0
end
if bDebug <> 0 then
  say 'Parameters are: 'sParams
if LENGTH(sDestination) = 0 then do
  sDestination = 'A:'
  bInstallingDiskette = 'TRUE'
end
else do
  bInstallingDiskette = 'FALSE'
  sDestination = STRIP(sDestination,'t','\')
end
sSource = STRIP(sSource,'t','\')
if bDebug <> 0 then do
  say 'Using file list: 'sSource'\FILES.LST'
  say 'Destination is: 'sDestination
end
sFileList = sSource'\FILES.LST'
sDisk = SUBSTR(sDestination,1,2)
if sDisk = 'A:' | sDisk = 'B:' then do
  if bDebug <> 0 then
    say 'format ' sDisk '/Q /ONCE >' sNull
  else
    say 'Formatting' sDisk
  format sDisk '/Q /ONCE /V:OS_tools >' sNull
  if bDebug <> 0 then
    say 'label' sDisk '<' sSource'\label.dat >' sNull
  else
    say 'Labeling' sDisk
  label sDisk '<' sSource'\label.dat >' sNull
end
else do
  if bDebug <> 0 then
    say "Setting attributes to un-hide source initialization files"
  attrib sSource"\*.ini -h >" sNull
  if bDebug <> 0 then
    say "Setting attributes to delete all files at destination" sDestination
  attrib sDestination'\*.* -h >' sNull
  if bDebug <> 0 then
    say 'del' sDestination'\*.* < yes.ans >' sNull
  else
    say "Deleting all files on "sDestination
  del sDestination'\*.* < yes.ans >' sNull
end
if bDebug <> 0 then do
  pause
  say 'File list is:' sFileList
end
verify on
do while (LINES(sFileList) = 1)
  sLine = LINEIN(sFileList)
  sFileName = sLIne
  if bDebug <> 0 then
    say 'Processing' sLine
  if SUBSTR(sLine,1,1) = '[' then do
    sDemoDir = STRIP(sLine,'T',']')
    sDemoDir = STRIP(sDemoDir,'L','[')
    if bDebug <> 0 then do
      say 'Processing new directory' sDemoDir
      pause
    end
    sLine = LINEIN(sFileList)
    sFileName = sLine
    if bDebug <> 0 then
      say 'Processing' sLine
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
      pause
  end
  if LENGTH(sFileName) <> 0 then do
    if bDebug <> 0 then
      say 'copy 'sFileName sDestination'\'FILESPEC('name',sFIleName) '>' sNull
    else
      say 'Copying 'sFileName
    copy sFileName sDestination'\'FILESPEC('name',sFileName) '>' sNull
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
  pause

