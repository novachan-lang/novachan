# Generic RTTI smoke: recompile runtime.c (validate C + refresh .o) then compile/link/run
# one test with the current gen3_test.exe. Used to validate a runtime-only consumer stage
# fast, before the full gate. Usage: _rtti_smoke.ps1 -t rtti_show_test
param([string]$t = "rtti_json_test")
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$rt = Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 `"$PSScriptRoot\output\nova_runtime.c`" -o `"$PSScriptRoot\output\nova_runtime.o`" -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if ($rt.ExitCode -ne 0) { Write-Host "RUNTIME COMPILE FAIL"; if ($rt.StdErr) { Write-Host $rt.StdErr }; exit 1 }
Write-Host "runtime.o OK"

Remove-Item "$t.ll", "$t.exe" -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "$t.nova" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if ($c.ExitCode -ne 0) { Write-Host "COMPILE FAIL exit=$($c.ExitCode)"; if ($c.StdOut) { Write-Host $c.StdOut }; exit 1 }
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $t.exe $t.ll output\nova_runtime.o -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "$t.exe")) { Write-Host "LINK FAIL"; if ($l.StdOut) { Write-Host $l.StdOut }; exit 1 }
$r = Invoke-Timed -FilePath ".\$t.exe" -Arguments "" -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
Write-Host "STDOUT: $($r.StdOut)"
Write-Host "STDERR: $($r.StdErr)"
Write-Host "exit=$($r.ExitCode) timedout=$($r.TimedOut)"
