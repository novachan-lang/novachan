# Usage: .\run.ps1 snake_game.nova
param([string]$File)

if (-not $File) {
    Write-Host "Usage: .\run.ps1 <file.nova>"
    Write-Host "Example: .\run.ps1 snake_game.nova"
    exit 1
}

if (-not (Test-Path $File)) {
    Write-Host "File not found: $File"
    exit 1
}

$ScriptDir   = Split-Path -Parent $MyInvocation.MyCommand.Path
$ProjectRoot = Split-Path -Parent $ScriptDir
$Compiler    = Join-Path $ProjectRoot "nova-compiler\test_programs\gen3_test.exe"
$Runtime     = Join-Path $ProjectRoot "nova-compiler\test_programs\output\nova_runtime.c"
$BaseName    = [System.IO.Path]::GetFileNameWithoutExtension($File)
$LlFile      = "$BaseName.ll"
$ExeFile     = "$BaseName.exe"

# Step 1: Compile .nova -> .ll
Write-Host "[1/3] Compiling $File ..."
$fullPath = (Resolve-Path $File).Path
& $Compiler $fullPath
if ($LASTEXITCODE -ne 0) { Write-Host "COMPILE FAILED"; exit 1 }

# The .ll may land in current dir or next to the source — find it
if (-not (Test-Path $LlFile)) {
    if (Test-Path (Join-Path $ScriptDir $LlFile)) {
        $LlFile = Join-Path $ScriptDir $LlFile
    } else {
        Write-Host "ERROR: No .ll file produced"
        exit 1
    }
}

# Step 2: Link .ll + runtime -> .exe
Write-Host "[2/3] Linking $LlFile ..."
clang -O2 -D_CRT_SECURE_NO_WARNINGS -w -o $ExeFile $LlFile $Runtime -lws2_32 -ladvapi32
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; exit 1 }

# Cleanup .ll
Remove-Item $LlFile -Force -ErrorAction SilentlyContinue

# Step 3: Run
Write-Host "[3/3] Running $ExeFile ..."
Write-Host "----------------------------------------"
& ".\$ExeFile"
$rc = $LASTEXITCODE
Write-Host "----------------------------------------"
Write-Host "Exit code: $rc"

# Cleanup .exe
Remove-Item $ExeFile -Force -ErrorAction SilentlyContinue
