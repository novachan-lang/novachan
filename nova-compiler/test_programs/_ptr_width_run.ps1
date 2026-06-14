Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Remove-Item ptr_width_test.ll, __pw.exe -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath '.\gen4_test.exe' -Arguments 'ptr_width_test.nova' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($c.TimedOut) { Write-Host "COMPILE TIMEOUT"; exit 1 }
if ($c.ExitCode -ne 0) { Write-Host "COMPILE FAIL exit=$($c.ExitCode)"; if ($c.StdOut) { Write-Host $c.StdOut }; exit 1 }
if (!(Test-Path ptr_width_test.ll)) { Write-Host "NO .ll"; exit 1 }
$link = "-O2 -o __pw.exe ptr_width_test.ll output\nova_runtime.o -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w"
$cr = Invoke-Timed -FilePath 'clang' -Arguments $link -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "LINK FAIL"; if ($cr.StdOut) { Write-Host $cr.StdOut }; exit 1 }
$r = Invoke-Timed -FilePath '.\__pw.exe' -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
if ($r.TimedOut) { Write-Host "RUN TIMEOUT (HANG!)"; exit 1 }
Write-Host "STDOUT: $($r.StdOut)"
Write-Host "exit=$($r.ExitCode)"
