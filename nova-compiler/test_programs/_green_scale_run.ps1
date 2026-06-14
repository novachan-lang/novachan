Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Remove-Item green_scale_test.ll, __gs.exe -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments 'green_scale_test.nova' -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if ($c.ExitCode -ne 0) { Write-Host "COMPILE FAIL exit=$($c.ExitCode)"; if ($c.StdOut) { Write-Host $c.StdOut }; exit 1 }
$link = "-O2 -o __gs.exe green_scale_test.ll output\nova_runtime.o -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w"
$cr = Invoke-Timed -FilePath 'clang' -Arguments $link -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "LINK FAIL"; if ($cr.StdOut) { Write-Host $cr.StdOut }; exit 1 }
$r = Invoke-Timed -FilePath '.\__gs.exe' -Arguments '' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
if ($r.TimedOut) { Write-Host "RUN TIMEOUT (HANG!)"; exit 1 }
Write-Host $r.StdOut
Write-Host "exit=$($r.ExitCode)"
