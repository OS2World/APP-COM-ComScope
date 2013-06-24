/* ====================================================================== 
** BuildRelease.cmd
** OmniSupplier Version 4.6.x (Humvee) release build
** This command script will compile and link all executables in the
** release.
** Copyright (C) 1996-2000 Omnicell Technologies, Inc. ALL RIGHTS RESERVED.
** ====================================================================== */
CALL RxFuncAdd  'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
CALL SysLoadFuncs

'@echo off'
'Help off' 
SAY ''

FilesToBuild = 54
SupplierOnlyFilesToBuild = 12

PARSE UPPER ARG ArgVersion ArgBuildDrive ArgVerDir ArgMakeType ArgToolsDrive ArgColumns ArgLogFile Debug junk

VerDir = 'GA'
BuildDrive = 'F:'
ToolsDrive = 'F:'
Columns = '170'
Rows = '48'
LogFile = 'NUL'
MakeType = 'All'
bSupplierOnly = FALSE 

IF LENGTH(ArgVersion) = 0 THEN CALL HelpMsg

IF LENGTH(ArgColumns) <> 0 THEN DO
  IF ArgColumns <> '0' THEN DO
    Rows = 8192/ArgColumns
    Dot = POS('.',Rows)
    IF Dot <> 0 THEN
      Rows = SUBSTR(Rows, 1, (Dot - 1))
    'MODE 'ArgColumns','Rows
   END   
 END
 ELSE
  'MODE 'Columns','Rows

IF LENGTH(ArgMakeType) <> 0 THEN DO
  MakeType = ArgMakeType
  SAY 'MakeType = 'MakeType
 END

IF LENGTH(ArgVerDir) <> 0 THEN DO
  SELECT
    WHEN SUBSTR(ArgVerDir,1,1) = 'S' THEN DO
      IF SUBSTR(ArgVerDir,2,1) = 'D' THEN
        VerDir = 'DEBUG'
      ELSE
        VerDir = 'GA'
      bSupplierOnly = TRUE
      SAY "Build "VerDir" supplier only"
      FilesToBuild = (SupplierOnlyFilesToBuild + 2)
     END
    WHEN SUBSTR(ArgVerDir,1,1) = 'G' THEN DO
      VerDir = "GA"
     END
    WHEN SUBSTR(ArgVerDir,1,1) = 'D' THEN DO
      VerDir = "debug"
     END
    WHEN SUBSTR(ArgVerDir,1,1) = 'X' THEN DO
      VerDir = "X"
     END
   END
  SAY 'VerDir = 'VerDir
 END

IF LENGTH(ArgBuildDrive) <> 0 THEN DO
  IF ArgBuildDrive <> BuildDrive THEN DO
    BuildDrive = ArgBuildDrive
    SAY 'BuildDrive = 'BuildDrive
   END
 END
  
IF LENGTH(ArgToolsDrive) <> 0 THEN DO
  IF ArgToolsDrive <> ToolsDrive THEN DO
    ToolsDrive = ArgToolsDrive
    SAY 'ToolsDrive = 'ToolsDrive
   END
 END
  
IF LENGTH(ArgLogFile) <> 0 THEN DO
  LogFile = ArgLogFile
  SAY 'LogFile = 'LogFile
 END
  
BuildDrive
'cd \Humvee'
SAY 'Building 'ArgVersion' from source in:'
'cd'
SAY ' '
'cd build'

FileCount = FilesToBuild - 1

/* Start Elapsed Timer */

StartTime = time('R')

'cd ..\Lib'

'attrib * -r > NUL'

'cd ..'

'attrib *.map -r /S > NUL'
'attrib *.exe -r /S > NUL'
IF VerDir = 'X' THEN
  'attrib *.sy? -r /S > NUL'

IF SUBSTR(MakeType,1,1) <> 'V' THEN DO

  IF (SUBSTR(VerDir,1,1) = 'G') & (bSupplierOnly <> TRUE) THEN DO
    
    'cd OtiDev'
    
    'attrib *.sy? -r > NUL'
  
    'set INCLUDE='ToolsDrive'\ibmcpp\dtools\h;'ToolsDrive'\ibmcpp\dtools\inc;'
    xPath = ToolsDrive'\ibmcpp\dtools;'ToolsDrive'\ibmcpp\bin'
    'SET PATH='xPath';%PATH%;'

    target = "OtiDD.sys"
    CALL ClearObjects
    'nmake /nologo /f OtiDD.mak'
    IF RC \= 0 then SIGNAL Failure;
    'del NULL >NUL 2>NUL'
    cd '..'
  
    total = time('E')
    Minutes = total % 60
    SAY ''
    if Minutes > 1 THEN
      SAY 'Time elapsed  = 'Minutes 'minutes'
    ELSE
     DO
      Seconds = total % 1
      if Minutes = 1 THEN
       DO
        Seconds = Seconds // 60
        say 'Time elapsed  = 'Minutes 'minute' Seconds 'seconds'
       END
      ELSE
        SAY 'Time elapsed = 'Seconds 'seconds'
     END
  
    target = "OmniRTL.lib"
    cd 'RTL'
    CALL SysFileTree 'OmniRTL.lib', Files, 'F'
    if Files.0 <> 0 THEN del 'OmniRTL.lib'
  
    say ''
    say '----------> Building 'target' ------------------------- 'FileCount' remaining'
    say ''
    FileCount = FileCount - 1;
    nmake '/f OmniRTL.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    cd '..'
  
   END
  ELSE
    FilesToBuild = FilesToBuild - 2

 END

/*
'cd build'
EXIT 'OK'
*/

SET 'LIB='ToolsDrive'\ibmcpp\lib;'BuildDrive'\Humvee\Lib;'BuildDrive'\Humvee\RTL;'
SET 'INCLUDE='ToolsDrive'\IBMCPP\INCLUDE;'ToolsDrive'\IBMCPP\INCLUDE\OS2;'BuildDrive'\Humvee\Include;'BuildDrive'\Humvee\CodeBase;'

IF SUBSTR(MakeType,1,1) <> 'V' THEN DO

  IF SUBSTR(MakeType,2,1) = '-' THEN DO
    target = "CodeBase.dll"
    cd 'CodeBase\'VerDir
    CALL ClearObjects
    nmake '/f CodeBase.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
   END

  target = 'DataBase.dll'
  cd 'DataBase\'VerDir
  CALL ClearObjects
  nmake '/f DataBase.mak /nologo'
  if RC \= 0 then SIGNAL Failure;
  CALL MapSymbols
  cd '..\..'
  
  target = "Time.dll"
  cd 'Time\'VerDir
  CALL ClearObjects
  nmake '/f Time.mak /nologo'
  if RC \= 0 then SIGNAL Failure;
  CALL MapSymbols
  cd '..\..'
  
  target = "Sounds.dll"
  cd 'Sounds\'VerDir
  CALL ClearObjects
  nmake '/f Sounds.mak /nologo'
  if RC \= 0 then SIGNAL Failure;
  CALL MapSymbols
  cd '..\..'
  
  target = "Logging.dll"
  cd 'Logging\'VerDir
  CALL ClearObjects
  nmake '/f Logging.mak /nologo'
  if RC \= 0 then SIGNAL Failure;
  CALL MapSymbols
  cd '..\..'
  
  target = "Tools.dll"
  cd 'Tools\'VerDir
  CALL ClearObjects
  nmake '/f Tools.mak /nologo'
  if RC \= 0 then SIGNAL Failure;
  CALL MapSymbols
  cd '..\..'
  
  target = "UserIO.dll"
  cd 'UI\'VerDir
  CALL ClearObjects
  nmake '/f UserIO.mak /nologo'
  if RC \= 0 then SIGNAL Failure;
  CALL MapSymbols
  cd '..\..'
  
  target = "Config.dll"
  cd 'Config\'VerDir
  CALL ClearObjects
  nmake '/f Config.mak /nologo'
  if RC \= 0 then SIGNAL Failure;
  CALL MapSymbols
  cd '..\..'
  
  target = "OmniCell.dll"
  cd 'OmniCell\'VerDir
  CALL ClearObjects
  nmake '/f OmniCell.mak /nologo'
  if RC \= 0 then SIGNAL Failure;
  CALL MapSymbols
  cd '..\..'

 END

target = "JW.exe"
cd 'jw\'VerDir
CALL ClearObjects
IF SUBSTR(MakeType,1,1) <> 'M' THEN DO
  CALL SysFileTree 'version.obj', Files, 'F'
  IF Files.0 <> 0 THEN 'del Version.obj > NULL'
 END
'echo. >> 'LogFile
nmake '/f jw.mak /nologo'
if RC \= 0 then SIGNAL Failure;
CALL MapSymbols
cd '..\..'

IF SUBSTR(MakeType,1,1) <> 'V' THEN DO

  target = "ocShell.exe"
  cd 'ocShell\'VerDir
  CALL ClearObjects
  nmake '/f ocShell.mak /nologo'
  if RC \= 0 then SIGNAL Failure;
  CALL MapSymbols
  cd '..\..'
  
  IF bSupplierOnly = FALSE THEN DO

    target = "Choice.exe"
    cd 'Choice\'VerDir
    CALL ClearObjects
    nmake '/f Choice.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "ocShellX.exe"
    cd 'ocShellX\'VerDir
    CALL ClearObjects
    nmake '/f ocShellX.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "OmniInst.exe"
    cd 'Install\'VerDir
    CALL ClearObjects
    nmake '/f omniinst.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "MakeProf.exe"
    cd 'MakeProfile\'VerDir
    CALL ClearObjects
    nmake '/f makeprof.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "CheckInf.exe"
    cd 'CheckInf\'VerDir
    CALL ClearObjects
    nmake '/f CheckInf.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "MakeInf.exe"
    cd 'MakeInf\'VerDir
    CALL ClearObjects
    nmake '/f makeinf.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "Jmx2Itms.exe"
    cd 'jmx2itms\'VerDir
    CALL ClearObjects
    nmake '/f jmx2itms.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "OmniCfg.exe"
    cd 'omnicfg\'VerDir
    CALL ClearObjects
    nmake '/f omnicfg.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "Password.exe"
    cd 'Password\'VerDir
    CALL ClearObjects
    nmake '/f Password.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "ocShut.exe"
    cd 'Shutdown\'VerDir
    CALL ClearObjects
    nmake '/f ocShut.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "Pack.exe"
    cd 'Pack\'VerDir
    CALL ClearObjects
    nmake '/f pack.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "Reboot.exe"
    cd 'Reboot\'VerDir
    CALL ClearObjects
    nmake '/f Reboot.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "Compress.exe"
    cd 'Compress\'VerDir
    CALL ClearObjects
    nmake '/f Compress.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "TextEdit.exe"
    cd 'TextEdit\'VerDir
    CALL ClearObjects
    nmake '/f TextEdit.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "TblUpgrd.dll"
    cd 'TUpgrade\'VerDir
    CALL ClearObjects
    nmake '/f TblUpgrd.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "CvtTable.exe"
    cd 'Convert\'VerDir
    CALL ClearObjects
    nmake '/f CvtTable.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "D0W0.dll"
    cd 'z_D0W0\'VerDir
    CALL ClearObjects
    nmake '/f D0W0.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "D1W1.dll"
    cd 'z_d1w1\'VerDir
    CALL ClearObjects
    nmake '/f d1w1.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W0D0.dll"
    cd 'z_w0d0\'VerDir
    CALL ClearObjects
    nmake '/f w0d0.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W0W1.dll"
    cd 'z_w0w1\'VerDir
    CALL ClearObjects
    nmake '/f w0w1.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W1D1.dll"
    cd 'z_w1d1\'VerDir
    CALL ClearObjects
    nmake '/f w1d1.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W1W0.dll"
    cd 'z_w1w0\'VerDir
    CALL ClearObjects
    nmake '/f w1w0.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W1W2.dll"
    cd 'z_w1w2\'VerDir
    CALL ClearObjects
    nmake '/f w1w2.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W2W1.dll"
    cd 'z_w2w1\'VerDir
    CALL ClearObjects
    nmake '/f w2w1.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W3W2.dll"
    cd 'z_w3w2\'VerDir
    CALL ClearObjects
    nmake '/f w3w2.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W2W3.dll"
    cd 'z_w2w3\'VerDir
    CALL ClearObjects
    nmake '/f w2w3.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W4W3.dll"
    cd 'z_w4w3\'VerDir
    CALL ClearObjects
    nmake '/f w4w3.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W3W4.dll"
    cd 'z_w3w4\'VerDir
    CALL ClearObjects
    nmake '/f w3w4.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W4W5.dll"
    cd 'z_w4w5\'VerDir
    CALL ClearObjects
    nmake '/f w4w5.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W5W4.dll"
    cd 'z_w5w4\'VerDir
    CALL ClearObjects
    nmake '/f w5w4.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W5W6.dll"
    cd 'z_w5w6\'VerDir
    CALL ClearObjects
    nmake '/f w5w6.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W6W5.dll"
    cd 'z_w6w5\'VerDir
    CALL ClearObjects
    nmake '/f w6w5.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W6W7.dll"
    cd 'z_w6w7\'VerDir
    CALL ClearObjects
    nmake '/f w6w7.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W7W6.dll"
    cd 'z_w7w6\'VerDir
    CALL ClearObjects
    nmake '/f w7w6.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W7W8.dll"
    cd 'z_w7w8\'VerDir
    CALL ClearObjects
    nmake '/f w7w8.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'
    
    target = "W8W9.dll"
    cd 'z_w8w9\'VerDir
    CALL ClearObjects
    nmake '/f w8w9.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'

    target = "W9W8.dll"
    cd 'z_w9w8\'VerDir
    CALL ClearObjects
    nmake '/f w9w8.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'

    target = "W9W10.dll"
    cd 'z__w9w10\'VerDir
    CALL ClearObjects
    nmake '/f w9w10.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'

    target = "W10W9.dll"
    cd 'z__w10w9\'VerDir
    CALL ClearObjects
    nmake '/f w10w9.mak /nologo'
    if RC \= 0 then SIGNAL Failure;
    CALL MapSymbols
    cd '..\..'

    target = "SelNIC"
    cd 'SelNIC'
    setup.cmd
    cd '..'

   END
  
 END

CALL SayTotalTime

say ''
say '+===========================+'
say '| Release make successful!  |'
say '+===========================+'
say   FilesToBuild' targets built'
say ''
cd 'build'

EXIT 'OK'

SayTotalTime:

total = time('E')
Minutes = total % 60
if Minutes > 1 THEN
  say 'Total time to build  = 'Minutes 'minutes'
ELSE
 DO
  Seconds = total % 1
  if Minutes = 1 THEN
   DO
    Seconds = Seconds // 60
    say 'Total time to build  = 'Minutes 'minute' Seconds 'seconds'
   END
  ELSE
    say 'Total time to build = 'Seconds 'seconds'
 END
RETURN

Failure:

CALL SayTotalTime

say '+--------------------------+'
say '|   Release make failed!   |'
say '+--------------------------+'
say ' Failed building: ' target

CALL Beep 1000,1000
cd '..\..\build'
EXIT 'FAIL'

/****************************************************
  make symbols if building exception handler pack
*****************************************************/

MapSymbols:

IF SUBSTR(VerDir,1,1) = 'X' THEN DO

  DOT = POS('.',target)
  SymFileName = SUBSTR(target,1,(DOT - 1))
  'mapsym 'SymFileName'.map > NUL'
  
 END

RETURN 'OK'

/****************************************************
  do this for each module and return
****************************************************/

ClearObjects:

IF SUBSTR(MakeType,1,1) = 'V' THEN DO
  say ''
  say '----------> Setting version to 'ArgVersion
  say ''
  RETURN 'OK'
 END

IF SUBSTR(MakeType,1,1) = 'A' THEN DO

  total = time('E')
  Minutes = total % 60
  SAY ''
  if Minutes > 1 THEN
    say 'Time elapsed  = 'Minutes 'minutes'
  ELSE
   DO
    Seconds = total % 1
    if Minutes = 1 THEN
     DO
      Seconds = Seconds // 60
      say 'Time elapsed  = 'Minutes 'minute' Seconds 'seconds'
     END
    ELSE
      say 'Time elapsed = 'Seconds 'seconds'
   END

  CALL SysFileTree '*.pch', Files, 'F'
  if Files.0 <> 0 THEN del '*.pch'
  
  CALL SysFileTree '*.obj', Files, 'F'
  if Files.0 <> 0 THEN del '*.obj'

  IF VerDir = 'debug' THEN DO
    CALL SysFileTree '*.asm', Files, 'F'
    if Files.0 <> 0 THEN del '*.asm'

    CALL SysFileTree '*.cod', Files, 'F'
    if Files.0 <> 0 THEN del '*.cod'

    CALL SysFileTree '*.lst', Files, 'F'
    if Files.0 <> 0 THEN del '*.lst'
   END

  IF SUBSTR(VerDir,1,1) = 'X' THEN DO
    CALL SysFileTree '*.sym', Files, 'F'
    if Files.0 <> 0 THEN del '*.sym'
   END

 END

say ''
IF FileCount <> 0 THEN
  say '----------> Building 'target' ------------------------- 'FileCount' modules remaining'
 ELSE
  say '----------> Building 'target' ------------------------- Last module to build'
say ''

FileCount = FileCount - 1

RETURN 'OK'

HelpMsg:

  'mode 100,24'
  SAY 'Version is required'
  SAY '  1 = Version, e.g., 4.6.2.0 (REQUIRED)'
  SAY '  2 = build drive, e.g., w:, default is f:'
  SAY '  3 = Version to build, Ga = GA release, X = exception handler build,'
  SAY '      Debug = debug build, S = Supplier only, SD = Debug supplier only.'
  SAY '      Default is GA.  Only the characters in caps are required.'
  SAY '  4 = Make type, All = build all, Make = build outdated targets only, V = version only'
  SAY '      Default is All.  Only first character is significant.'
  SAY '  5 = Tools drive, e.g., P:, default is F:'
  SAY '  6 = Number of columns to display window, default is 170'
  SAY '  7 = Log file name, default is NUL (no log).'
  SAY '  8 = Turn on debug of this file, any value will enable, default is off.'
  EXIT 'HELP'

RETURN
