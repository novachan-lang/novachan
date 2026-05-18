@echo off
cd /d "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"
call gradlew.bat shadowJar 2>&1
echo BUILD_RESULT: %ERRORLEVEL%
