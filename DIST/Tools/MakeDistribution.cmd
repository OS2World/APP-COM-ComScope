/* Make Distribution Disk */
'@echo off'

  call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
  call SysLoadFuncs

PARSE UPPER ARG sSource sDestination sDebug

SourcePath="W:\dist\beta"
bCopyDemo = FALSE
IF LENGTH(sSource) = 0 THEN DO
  SAY "You must supply a version directory as parameter one."
  SAY ''
  SAY "You may also supply a destination path as parameter two"
  SAY "and the word DEBUG as the third parameter, for obvious purposes."
  EXIT "BAD PARAM"
 END
  
sParams = ARG(1)

IF LENGTH(sDebug) <> 0 THEN DO
  SAY "Debug Enabled"
  CmdOut = '> CON'
  bDebug = 1
 END
ELSE DO
  CmdOut = '> NUL'
  bDebug = 0
 END
 
IF bDebug <> 0 THEN
  SAY 'Parameters are: 'sParams
IF LENGTH(sDestination) = 0 THEN DO
  sDestination = 'A:'
  bInstallingDiskette = TRUE
 END
ELSE DO
  bInstallingDiskette = FALSE
  sDestination = STRIP(sDestination,'t','\')
 END
sSource = STRIP(sSource,'t','\')
IF bDebug <> 0 THEN DO
  SAY 'Using file list: 'SourcePath'\_'sSource'\FILES.LST'
  SAY 'Destination is: 'sDestination
 END
sFileList = SourcePath'\_'sSource'\FILES.LST'
IF bDebug <> 0 THEN
  SAY "Setting attributes to un-hide source initialization files"
attrib SourcePath'\_'sSource'\*.ini -h ' CmdOut     
sDisk = SUBSTR(sDestination,1,2)
IF sDisk = 'A:' | sDisk = 'B:' THEN 
  bFloppy = TRUE
IF bFloppy <> TRUE THEN DO
  attrib sDestination'\*.* -h /S ' CmdOut
  call SysFileTree sDestination, 'Files', 'F'
  IF Files.0 > 0 THEN  DO
    IF bDebug <> 0 THEN
      SAY "Resetting attributes to allow deletion of all files in" sDestination
    IF bDebug <> 0 THEN
      SAY 'del' sDestination'\*.* < yes.ans ' CmdOut
    ELSE
      SAY "Deleting all files on "sDestination
    del sDestination'\* < yes.ans ' CmdOut
   END
 END
 
IF bDebug <> 0 THEN
  SAY 'File list is:' sFileList
  
IF LINES( sFileList ) = 0 THEN DO
  SAY sFileList' is empty'
  EXIT "FILE LIST EMPTY"
 END
FileSet = LINEIN(sFileList)
Profile = LINEIN(sFileList)
IF bDebug <> 0 THEN
    SAY 'Processing 'Profile
SourcePath'\Targets\MakeProf /M'SourcePath'\_'sSource'\MAKE.PRF /P'SourcePath'\'Profile' > lastprof.txt'
IF RC <> 0 THEN EXIT "MAKE PROFILE FAILED"

IF bDebug <> 0 THEN
  SAY 'copy 'Profile sDestination CmdOut
ELSE
  SAY 'Copying 'SourcePath'\'Profile' to 'sDestination
copy SourcePath'\'Profile sDestination CmdOut
IF RC<>0 THEN EXIT "FAILED COPY"
 
IF bDebug <> 0 THEN PAUSE

iIndex = 1
DO while LINES( sFileList ) <> 0
  sLine.iIndex = LINEIN(sFileList)
  IF bDebug <> 0 THEN
    SAY 'sLine.'iIndex' = 'sLine.iIndex
  iIndex = iIndex + 1
END
sLIne.0 = iIndex - 1
IF bDebug <> 0 THEN
  pause
verIFy on
zero = CHAROUT(sFileList)
count = iIndex
iIndex = 0
IF bFloppy = TRUE THEN DO
  IF bDebug <> 0 THEN
    SAY 'format ' sDisk '/Q /ONCE ' CmdOut
  ELSE
    SAY 'Formatting' sDisk 'with label 'sLine.iIndex
  format sDisk '/Q /ONCE /V:'sLine.iIndex' ' CmdOut
  IF RC<>0 THEN EXIT "FAILED DISKETTE FORMAT"
 END
iIndex = 1
DO while (iIndex < count)
  sFileName = sLine.iIndex
  iIndex = iIndex + 1
  IF bDebug <> 0 THEN
    SAY 'Processing' sFileName
  IF SUBSTR(sFileName,1,1) = '[' THEN DO
    sDemoDir = STRIP(sFileName,'T',']')
    sDemoDir = STRIP(sDemoDir,'L','[')
    IF bDebug <> 0 THEN DO
      SAY 'Processing new directory' sDemoDir
      'pause'
     END
    IF (iIndex < count) THEN DO
      sFileName = sLine.iIndex
      iIndex = iIndex + 1
      IF bDebug <> 0 THEN
        SAY 'Processing' sFileName
      bCopyDemo = TRUE
      IF bDebug <> 0 THEN
        SAY 'Setting attributes to hide initialization files'
      attrib sDestination'\*.ini +h ' CmdOut
      IF bDebug <> 0 THEN
        SAY 'Setting attributes to hide icon files'
      attrib sDestination'\*.ico +h ' CmdOut
      SAY 'Making 'sDemoDir' directory'
      md sDestination'\'sDemoDir
      sDestination = sDestination'\'sDemoDir
      IF bDebug <> 0 THEN
        SAY 'Setting attributes to un-hide' sFileName
      attrib sFileName' -h ' CmdOut
      IF bDebug <> 0 THEN pause
     END
    IF bFloppy <> TRUE THEN DO
      call SysFileTree sDestination"\*","Files","S"
      IF Files.0 > 0 THEN DO
        IF bDebug <> 0 THEN
          SAY "Resetting attributes to allow deletion of all files in" sDestination
        attrib sDestination'\*.* -h ' CmdOut
        IF bDebug <> 0 THEN
          SAY 'del' sDestination'\*.* < yes.ans ' CmdOut
        ELSE
          SAY "Deleting all files on "sDestination
        del sDestination'\*.* < yes.ans ' CmdOut
       END
     END
   END
  IF bDebug <> 0 THEN pause
  IF (LENGTH(sFileName) <> 0) THEN DO
    PARSE VAR sFileName sFileName sDestFile
    IF LENGTH(sDestFile) <> 0 THEN DO
      IF (LENGTH(sDestFile) <> 0) THEN DO
        sDestSpec = sDestination'\'sDestFile
        IF bDebug <> 0 THEN
          SAY 'copy 'sFileName sDestSpec CmdOut
        ELSE
          SAY 'Copying 'sFileName' to 'sDestFile
       END
     END
  ELSE DO
     sDestSpec = sDestination'\'FILESPEC('name',sFileName)
     IF bDebug <> 0 THEN
       SAY 'copy 'sFileName sDestSpec CmdOut
     ELSE
       SAY 'Copying 'sFileName
    END
   IF SUBSTR(sFileName,1,1) = '\' THEN
     copy sFileName sDestSpec CmdOut
   ELSE
     copy SourcePath'\'sFileName sDestSpec CmdOut
   IF RC<>0 THEN EXIT "FAILED COPY"
  END
 END
'verify off'
IF bDebug <> 0 THEN
  SAY 'Setting attributes to hide initialization files'
  
attrib sDestination'\*.ini +h ' CmdOut
IF bDebug <> 0 THEN
  SAY 'Setting attributes to hide icon files'
attrib sDestination'\*.ico +h ' CmdOut

IF bDebug<> 0 THEN pause

EXIT "OK"
