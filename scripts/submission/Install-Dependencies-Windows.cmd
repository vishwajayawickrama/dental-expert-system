@echo off
setlocal
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\install\windows.ps1" -Action Dependencies %*
if errorlevel 1 (
  echo Installation failed. See the message above and run this script again after correction.
  pause
  exit /b 1
)
