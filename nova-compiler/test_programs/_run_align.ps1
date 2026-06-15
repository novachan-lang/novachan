Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== Compiling align_test.nova ==="
$c = Invoke-Timed -FilePath (Resolve-Path ".\nova.exe").Path -Arguments "compile align_test.nova" -TimeoutMs 30000
Write-Host $c.Stdout
if ($c.Stderr.Length -gt 0) { Write-Host "STDERR: $($c.Stderr)" }
Write-Host "COMPILE EXIT=$($c.ExitCode)"
if ($c.ExitCode -ne 0) { exit 1 }

Write-Host ""
Write-Host "=== Linking ==="
& clang -o align_test.exe align_test.ll output\nova_runtime.o -lws2_32 -ladvapi32 -O2 2>&1 | Out-Null
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; exit 1 }

Write-Host ""
Write-Host "=== Running ==="
$r = Invoke-Timed -FilePath (Resolve-Path ".\align_test.exe").Path -TimeoutMs 15000
Write-Host $r.Stdout
if ($r.Stderr.Length -gt 0) { Write-Host "STDERR: $($r.Stderr)" }
Write-Host "EXIT=$($r.ExitCode)"
