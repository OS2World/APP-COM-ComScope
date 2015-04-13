@echo off
if %1.==. goto error
call clear
makedisk %1 c:\test
goto end
:error
echo.
echo  You must supply a app name, i.e. RETAIL_CS
echo.
:end
