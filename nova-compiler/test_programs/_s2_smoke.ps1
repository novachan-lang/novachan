# S2 smoke: validate runtime.c compiles + the keystone proof test (rtti_json_test) passes
# with the new runtime, BEFORE the full gate. gen3_test.exe (gen5) compiler is unchanged
# by S2 (runtime-only), so it just produces the .ll; the test exe links the fresh runtime.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$rt = Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 `"$PSScriptRoot\output\nova_runtime.c`" -o `"$PSScriptRoot\output\nova_runtime.o`" -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if ($rt.ExitCode -ne 0) { Write-Host "RUNTIME COMPILE FAIL"; if ($rt.StdErr) { Write-Host $rt.StdErr }; exit 1 }
Write-Host "runtime.o OK"

Remove-Item rtti_json_test.ll, rtti_json_test.exe -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "rtti_json_test.nova" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if ($c.ExitCode -ne 0) { Write-Host "COMPILE FAIL exit=$($c.ExitCode)"; if ($c.StdOut) { Write-Host $c.StdOut }; exit 1 }
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o rtti_json_test.exe rtti_json_test.ll output\nova_runtime.o -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path rtti_json_test.exe)) { Write-Host "LINK FAIL"; if ($l.StdOut) { Write-Host $l.StdOut }; exit 1 }
$r = Invoke-Timed -FilePath ".\rtti_json_test.exe" -Arguments "" -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
Write-Host "STDOUT: $($r.StdOut)"
Write-Host "STDERR: $($r.StdErr)"
Write-Host "exit=$($r.ExitCode) timedout=$($r.TimedOut)"
