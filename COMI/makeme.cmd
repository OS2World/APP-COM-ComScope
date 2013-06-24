@echo off
set path=f:\ibmcpp\dtools
set include=f:\ibmcpp\dtools\inc;f:\ibmcpp\dtools\h;p:\COMi;
mode 132,60
echo Build Retail COMi
nmake /nologo /f comdd.mak
if errorlevel==1 goto error:
echo Build Evaluation version
nmake /nologo /f comdde.mak
if errorlevel==1 goto error:
echo Build DFLEX
nmake /nologo /f dflex.mak
if errorlevel==1 goto error:
echo Build Globetek
nmake /nologo /f globe.mak
if errorlevel==1 goto error:
echo Build Personal COMi
nmake /nologo /f pCOMi.mak
if errorlevel==1 goto error:
echo Build OEM Sealevel
nmake /nologo /f scomdd.mak
if errorlevel==1 goto error:
echo Build COMscope personal COMi
nmake /nologo /f share_CS.mak
if errorlevel==1 goto error:
echo Build retail Sealevel
nmake /nologo /f srcomdd.mak
if errorlevel==1 goto error:
goto end
:error
:end
