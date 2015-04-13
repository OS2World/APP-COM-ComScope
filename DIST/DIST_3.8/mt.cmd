@echo off
if %1.==. goto error
call clear
set SourceDrive=p:
makedisk %1 d:\test
goto end
:error
echo.
echo  You must supply an app name, i.e. COMscope
echo.
:end
