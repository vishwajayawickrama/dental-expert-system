@echo off
setlocal
set "DENTAL_DIR=%~dp0"
set "PATH=%DENTAL_DIR%runtime\prolog\bin;%DENTAL_DIR%runtime\java\bin;%DENTAL_DIR%runtime\java\bin\server;%PATH%"
"%DENTAL_DIR%runtime\java\bin\java.exe" -jar "%DENTAL_DIR%DentalExplain.jar" %*
exit /b %errorlevel%
