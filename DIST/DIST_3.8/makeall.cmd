rem @echo off
echo.
echo Deleting previous builds
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
echo Making COMscope
cd\comscope
make /fcomscope.mak -s

echo Making COMscope DEMO
make /fCSDEMO.mak -s

echo Making Utilities DLL
cd\utility
make /fOS2ls_ut.mak -s

echo Making I/O Control DLL
make /fos2ls_io.mak -s

echo Making Profile DLL
make /fos2ls_pr.mak -s

echo Making Spooler DLL
cd \spooler
make /fCOMi_SPL.mak -s

echo Making Spooler DEMO DLL
make /fSPL_DEMO.mak -s

echo Making Configuration DLL
cd \config
make COMi_CFG.mak -s

echo.
cd \dist\beta

