@echo off
setlocal enabledelayedexpansion

set NOVA_JAR=%~dp0nova-compiler\build\libs\nova-compiler-0.1.0-all.jar

if "%~1"=="" (
    echo NOVA - Natively Optimized Versatile Architecture
    echo.
    echo Usage:
    echo   nova run ^<file.nova^>          Run with interpreter
    echo   nova build ^<file.nova^>        Compile to native binary
    echo   nova compile ^<file.nova^>      Generate LLVM IR only
    echo   nova repl                      Start interactive REPL
    echo   nova test ^<file.nova^>         Run tests
    echo   nova lsp                       Start LSP server
    echo.
    exit /b 0
)

if /i "%~1"=="run" (
    if "%~2"=="" (
        echo Error: no file specified. Usage: nova run ^<file.nova^>
        exit /b 1
    )
    java -cp "%NOVA_JAR%" nova.MainKt "%~2"
    exit /b !errorlevel!
)

if /i "%~1"=="build" (
    if "%~2"=="" (
        echo Error: no file specified. Usage: nova build ^<file.nova^>
        exit /b 1
    )
    set "SRC=%~2"
    set "NAME=%~n2"
    set "LLFILE=%~dp2!NAME!.ll"
    set "RUNTIME=%~dp0nova-compiler\bench\nova_runtime.c"

    echo [1/3] Compiling !SRC! ...
    java -cp "%NOVA_JAR%" nova.EmitLlvmKt "!SRC!" "!LLFILE!"
    if !errorlevel! neq 0 (
        echo Compilation failed.
        exit /b 1
    )

    echo [2/3] Building native binary ...
    clang -O2 "!LLFILE!" "!RUNTIME!" -o "%~dp2!NAME!.exe" -lm
    if !errorlevel! neq 0 (
        echo Native build failed. Is clang installed?
        exit /b 1
    )

    echo [3/3] Done! Run with: !NAME!.exe
    exit /b 0
)

if /i "%~1"=="compile" (
    if "%~2"=="" (
        echo Error: no file specified. Usage: nova compile ^<file.nova^>
        exit /b 1
    )
    set "NAME=%~n2"
    java -cp "%NOVA_JAR%" nova.EmitLlvmKt "%~2" "%~dp2!NAME!.ll"
    exit /b !errorlevel!
)

if /i "%~1"=="repl" (
    java -cp "%NOVA_JAR%" nova.MainKt
    exit /b 0
)

if /i "%~1"=="test" (
    if "%~2"=="" (
        echo Error: no file specified. Usage: nova test ^<file.nova^>
        exit /b 1
    )
    java -cp "%NOVA_JAR%" nova.TestRunnerKt "%~2"
    exit /b !errorlevel!
)

if /i "%~1"=="lsp" (
    java -cp "%NOVA_JAR%" nova.lsp.LspServerKt
    exit /b 0
)

echo Unknown command: %~1
echo Run 'nova' with no arguments to see usage.
exit /b 1
