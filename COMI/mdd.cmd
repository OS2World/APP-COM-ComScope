nmake /f debug.mak
if errorlevel 1 goto build_error
cd debug
..\mapsym debug
copy debug.sy? \\pci_test\dee\comm
cd ..
goto end
:build_error
echo.
echo failed to build debug
echo.
:end

