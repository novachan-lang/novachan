@echo off
REM NOVA Compiler Toolchain
REM Usage: nova run   file.nova    Compile and run
REM        nova build file.nova    Compile to .exe
REM        nova debug file.nova    Compile with debug symbols (for debugger)
REM        nova check file.nova    Check errors only

setlocal enabledelayedexpansion

set "SCRIPT_DIR=%~dp0"
set "COMPILER=%SCRIPT_DIR%gen2_move.exe"
set "RUNTIME=%SCRIPT_DIR%output\nova_runtime.c"

if "%~1"=="" goto :usage
if "%~2"=="" goto :usage

set "CMD=%~1"
set "SOURCE=%~2"

if not exist "%SOURCE%" (
    echo ERROR: File not found: %SOURCE%
    exit /b 1
)

for %%F in ("%SOURCE%") do set "BASE=%%~nF"

if /i "%CMD%"=="check" (
    "%COMPILER%" "%SOURCE%"
    exit /b %ERRORLEVEL%
)

if /i "%CMD%"=="build" (
    "%COMPILER%" "%SOURCE%"
    if errorlevel 1 exit /b 1
    clang -O2 -o "%BASE%.exe" "%BASE%.ll" "%RUNTIME%" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>nul
    if errorlevel 1 (
        echo [nova] Link failed.
        exit /b 1
    )
    echo Built: %BASE%.exe
    exit /b 0
)

if /i "%CMD%"=="debug" (
    "%COMPILER%" "%SOURCE%"
    if errorlevel 1 exit /b 1
    clang -g -O0 -o "%BASE%.exe" "%BASE%.ll" "%RUNTIME%" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>nul
    if errorlevel 1 (
        echo [nova] Link failed.
        exit /b 1
    )
    echo Built: %BASE%.exe (debug)
    exit /b 0
)

if /i "%CMD%"=="run" (
    "%COMPILER%" "%SOURCE%"
    if errorlevel 1 exit /b 1
    clang -O2 -o "%BASE%.exe" "%BASE%.ll" "%RUNTIME%" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>nul
    if errorlevel 1 (
        echo [nova] Link failed.
        exit /b 1
    )
    "%BASE%.exe"
    exit /b %ERRORLEVEL%
)

:usage
echo NOVA Compiler
echo.
echo   nova run   file.nova    Compile and run
echo   nova build file.nova    Compile to .exe (optimized)
echo   nova debug file.nova    Compile to .exe (with debug symbols)
echo   nova check file.nova    Check errors only
echo.
exit /b 1
