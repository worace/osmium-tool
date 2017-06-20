@ECHO OFF
SETLOCAL
SET EL=0

ECHO ~~~~~~ %~f0 ~~~~~~

SET destdir=osmium-tool

IF EXIST %destdir% ECHO deleting existing directory %destdir% && RD /S /Q %destdir%
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

MD %destdir%
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

COPY build\src\%config%\*.exe %destdir%\
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

FOR /R libosmium-deps %%f in (*.dll) do copy %%f %destdir%\

ECHO trying to run osmium.exe
CD %destdir%

osmium.exe
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

CD ..

IF EXIST osmium-tool.zip ECHO deleting existing osmium-tool.zip && DEL osmium-tool.zip
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

ECHO packaging osmium-tool
7z a -tzip -mx=9 osmium-tool.zip %destdir%\
IF %ERRORLEVEL% NEQ 0 GOTO ERROR

GOTO DONE

:ERROR
ECHO ~~~~~~ ERROR %~f0 ~~~~~~
SET EL=%ERRORLEVEL%

:DONE
IF %EL% NEQ 0 ECHO. && ECHO !!! ERRORLEVEL^: %EL% !!! && ECHO.
ECHO ~~~~~~ DONE %~f0 ~~~~~~

EXIT /b %EL%
