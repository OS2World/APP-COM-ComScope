@echo off
echo.
echo testing Distribution DLLs
echo.
echo -------- Configuration --------
echo COMi_CFG.DLL
exehdr comi_cfg.dll > NUL
if errorlevel==1 goto badDLL
echo -------- Spooler --------
echo COMi_SPL.PDR
exehdr comi_spl.pdr > NUL
if errorlevel==1 goto badDLL
echo SPL_DEMO.PDR
exehdr SPL_DEMO.PDR > NUL
if errorlevel==1 goto badDLL
echo -------- Utilities ----------
echo OS2LS_IO.DLL
exehdr OS2LS_IO.DLL > NUL
if errorlevel==1 goto badDLL
echo OS2LS_PR.DLL
exehdr OS2LS_PR.DLL > NUL
if errorlevel==1 goto badDLL
echo OS2LS_UT.DLL
exehdr os2ls_ut.dll > NUL
if errorlevel==1 goto badDLL
echo -------- Install ------------
echo PDA_INST.DLL
exehdr pda_inst.dll > NUL
if errorlevel==1 goto badDLL
echo PDB_INST.DLL
exehdr pdb_inst.dll > NUL
if errorlevel==1 goto badDLL
echo.
goto end
:badDLL
echo.
echo At least on DLL was bad
echo.
:end
