@echo off
setlocal
set "DENTAL_APP=%~dp0applications\windows\DentalExplain\DentalExplain.exe"
if not exist "%DENTAL_APP%" (
  echo DentalExplain is missing. Extract the complete submission ZIP and keep its folders together.
  pause
  exit /b 1
)
"%DENTAL_APP%" %*
exit /b %errorlevel%
