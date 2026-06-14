Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Remove-Item anyread_probe.ll, __ar.exe -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments 'anyread_probe.nova' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if ($c.ExitCode -ne 0) { Write-Host "COMPILE FAIL exit=$($c.ExitCode)"; if ($c.StdOut) { Write-Host $c.StdOut }; exit 1 }
$cr = Invoke-Timed -FilePath 'clang' -Arguments "-O2 -o __ar.exe anyread_probe.ll output\nova_runtime.o -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "LINK FAIL"; if ($cr.StdOut) { Write-Host $cr.StdOut }; exit 1 }
$r = Invoke-Timed -FilePath '.\__ar.exe' -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
if ($r.TimedOut) { Write-Host "RUN TIMEOUT"; exit 1 }
Write-Host $r.StdOut
