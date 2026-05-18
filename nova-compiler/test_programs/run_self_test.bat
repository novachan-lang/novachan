@echo off
cd /d "%~dp0"
nova_compiler.exe
echo EXIT_CODE: %ERRORLEVEL%
