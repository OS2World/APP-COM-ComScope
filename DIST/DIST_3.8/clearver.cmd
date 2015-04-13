@echo off
echo.
echo Press any key to continue deleting all executables and DLLs.  Otherwise
echo press ^C to quit.
pause
echo.
echo OS2LS_UT
del \utility\os2ls_ut.dll > NUL
echo OS2LS_IO
del \utility\os2ls_io.dll > NUL
echo OS2LS_PR
del \utility\os2ls_pr.dll > NUL
echo COMi_SPL
del \spool\comi_spl.dll > NUL
echo SPL_DEMO
del \spool\spl_demo.dll > NUL
echo COMI_CFG
del \config\comi_cfg.dll > NUL
echo COMscope
del \comscope\comscope.exe > NUL
echo COMscope DEMO
del \comscope\csdemo.exe > NUL
echo.

