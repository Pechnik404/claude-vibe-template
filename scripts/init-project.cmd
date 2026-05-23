@echo off
chcp 65001 >nul
powershell.exe -ExecutionPolicy Bypass -NoProfile -File "%~dp0init-project.ps1" %*
echo.
echo Done. Press any key to close.
pause >nul
