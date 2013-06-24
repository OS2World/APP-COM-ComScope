nmake /f base.mak
if errorlevel 1 goto build_error
cd base
..\mapsym comdd
copy comdd.sy? \\oc_gilroy\cee\comm
cd ..
goto end
:build_error
echo.
echo failed to build comdd
echo.
:end

