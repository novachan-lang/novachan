Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$test = $args[0]
if (-not $test) { $test = '_ld_test' }
$r = Invoke-Timed -FilePath (Resolve-Path '.\gen3_test.exe').Path -Arguments "$test.nova" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
Write-Host "COMPILE EXIT: $($r.ExitCode)"
if ($r.StdErr) { Write-Host $r.StdErr.Substring(0,[Math]::Min(2000,$r.StdErr.Length)) }
if ($r.ExitCode -ne 0) { exit 1 }
$lr = Invoke-Timed -FilePath 'clang' -Arguments "$test.ll output/nova_runtime.o -o $test.exe -O2 -lws2_32 -ladvapi32" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "LINK EXIT: $($lr.ExitCode)"
if ($lr.ExitCode -ne 0) { if ($lr.StdErr) { Write-Host $lr.StdErr }; exit 1 }
$rr = Invoke-Timed -FilePath (Resolve-Path ".\$test.exe").Path -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
Write-Host "RUN EXIT: $($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut }
if ($rr.StdErr) { Write-Host "STDERR: $($rr.StdErr)" }
