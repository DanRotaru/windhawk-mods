@echo off
rem Compile and deploy a mod to Windhawk.
rem   build.bat                         pick the mod from a menu
rem   build.bat -CompileOnly            menu, options passed to build.ps1
rem   build.bat start-menu-groups       build that mod directly
rem   build.bat start-menu-groups -Release
setlocal
set "PS=powershell"
where pwsh >nul 2>nul && set "PS=pwsh"

set "FIRST=%~1"
if not defined FIRST goto menu
if "%FIRST:~0,1%"=="-" goto menu

"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0build\build.ps1" %*
exit /b %ERRORLEVEL%

:menu
"%PS%" -NoProfile -ExecutionPolicy Bypass -File "%~dp0build\menu.ps1" %*
set "CODE=%ERRORLEVEL%"
rem Keep a double-clicked window open to read the output.
echo.
pause
exit /b %CODE%
