@echo off
echo.
echo Testing Distribution Versions
echo.
echo -------- Configuration --------
echo COMi_CFG.DLL
exehdr \config\COMI_CFG.DLL > CON
if errorlevel 1 goto error
echo -------- Spooler --------
echo COMi_SPL.PDR
exehdr \spooler\COMi_SPL.DLL COMi_SPL.PDR > CON
if errorlevel 1 goto error
echo SPL_DEMO.PDR
exehdr \spooler\SPL_DEMO.DLL SPL_DEMO.PDR > CON
if errorlevel 1 goto error
echo -------- Utilities ----------
echo OS2LS_IO.DLL
exehdr \utility\OS2LS_IO.DLL > CON
if errorlevel 1 goto error
echo OS2LS_PR.DLL
exehdr \utility\OS2LS_PR.DLL > CON
if errorlevel 1 goto error
echo OS2LS_UT.DLL
exehdr \utility\OS2LS_UT.DLL > CON
if errorlevel 1 goto error
echo -------- COMscope --------
echo COMscope.EXE
exehdr \COMscope\COMscope.EXE > CON
if errorlevel 1 goto error
echo CSDEMO.EXE
exehdr \COMscope\CSDEMO.EXE > CON
if errorlevel 1 goto error
echo -------- Install --------
exehdr \install\INSTALL.EXE > CON
if errorlevel 1 goto error
echo.
goto end
:error
echo.
echo Last Executable or DLL failed
echo.
pause
:end
