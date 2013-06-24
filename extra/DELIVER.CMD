@ECHO OFF
COPY %1.EXE G:\CLIENT\OSTOOLS\DIST
COPY %2.hlp g:\client\ostools\dist
if %3..==..  goto end
  %3.ico g:\client\ostools\dist
:end
