Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== Compiling tzdb.nova ==="
$c = Invoke-Timed -FilePath (Resolve-Path ".\nova.exe").Path -Arguments "compile tzdb.nova" -TimeoutMs 30000
Write-Host $c.Stdout
if ($c.Stderr.Length -gt 0) { Write-Host "STDERR: $($c.Stderr)" }
Write-Host "COMPILE EXIT=$($c.ExitCode)"
if ($c.ExitCode -ne 0) { exit 1 }

Write-Host ""
Write-Host "=== Linking tzdb ==="
$llc = Invoke-Timed -FilePath "clang" -Arguments "tzdb.ll output/nova_runtime.o -o tzdb.exe -lws2_32 -ladvapi32 -O2" -TimeoutMs 30000
Write-Host $llc.Stdout
if ($llc.Stderr.Length -gt 0) { Write-Host "LINK STDERR: $($llc.Stderr)" }
Write-Host "LINK EXIT=$($llc.ExitCode)"
if ($llc.ExitCode -ne 0) { exit 1 }

Write-Host ""
Write-Host "=== Running tzdb.exe ==="
$r = Invoke-Timed -FilePath (Resolve-Path ".\tzdb.exe").Path -TimeoutMs 15000
Write-Host $r.Stdout
if ($r.Stderr.Length -gt 0) { Write-Host "STDERR: $($r.Stderr)" }
Write-Host "EXIT=$($r.ExitCode)"
