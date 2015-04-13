@echo off
echo.
echo Copying beta/debug Versions
echo.
echo -------- Configuration --------
echo CFG_DEB.DLL
copy \config\extra\CFG_DEB.DLL > NUL
echo -------- Spooler --------
echo SPL_DEB.PDR
copy \spooler\SPL_DEB.DLL COMi_SPL.PDR > NUL
echo -------- Utilities ----------
echo IOCTLDEB.DLL
copy \utility\extra\IOCTLDEB.DLL > NUL
echo PROFDEB.DLL
copy \utility\extra\PROFDEB.DLL > NUL
echo UTIL_DEB.DLL
copy \utility\extra\UTIL_DEB.DLL > NUL
echo -------- COMscope --------
echo CSBETA.EXE
copy \COMscope\extra\CSBETA.EXE > NUL
echo -------- Install --------
echo INSTBETA.EXE
copy \install\INSTBETA.EXE > NUL
echo.
