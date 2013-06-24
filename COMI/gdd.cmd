nmake /f globe.mak
if errorlevel 1 goto build_error
cd globe
..\mapsym globe
copy globe.sy? \\pci_test\dee\comm
cd ..
goto end
:build_error
echo.
echo failed to build globetek
echo.
:end

