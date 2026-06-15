param([string]$TestFile)
$ErrorActionPreference = "Stop"
$dir = Split-Path -Parent $MyInvocation.MyCommand.Path

# Compile with gen4
$proc = Start-Process -FilePath "$dir\gen4_reflect.exe" -ArgumentList $TestFile -WorkingDirectory $dir -NoNewWindow -PassThru -RedirectStandardOutput "$dir\_g4_out.txt" -RedirectStandardError "$dir\_g4_err.txt"
$done = $proc.WaitForExit(60000)
if (-not $done) { $proc.Kill(); Write-Host "TIMEOUT"; exit 1 }
$exitCode = $proc.ExitCode
Get-Content "$dir\_g4_out.txt" -ErrorAction SilentlyContinue
if ($exitCode -ne 0) {
    Write-Host "COMPILE FAILED (exit $exitCode)"
    Get-Content "$dir\_g4_err.txt" -ErrorAction SilentlyContinue | Select-Object -Last 40
    exit 1
}
Write-Host "Compile OK"

# Get test name without extension
$base = [System.IO.Path]::GetFileNameWithoutExtension($TestFile)

# Link
& clang -o "$dir\$base.exe" "$dir\$base.ll" "$dir\output\nova_runtime.o" -lws2_32 -ladvapi32 -O2 2>&1
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; exit 1 }
Write-Host "Link OK"

# Run
$proc2 = Start-Process -FilePath "$dir\$base.exe" -WorkingDirectory $dir -NoNewWindow -PassThru -RedirectStandardOutput "$dir\_run_out.txt" -RedirectStandardError "$dir\_run_err.txt"
$done2 = $proc2.WaitForExit(15000)
if (-not $done2) { $proc2.Kill(); Write-Host "RUN TIMEOUT"; exit 1 }
Get-Content "$dir\_run_out.txt" -ErrorAction SilentlyContinue
if ($proc2.ExitCode -ne 0) {
    Write-Host "RUN FAILED (exit $($proc2.ExitCode))"
    Get-Content "$dir\_run_err.txt" -ErrorAction SilentlyContinue
    exit 1
}
Write-Host "=== PASS ==="
