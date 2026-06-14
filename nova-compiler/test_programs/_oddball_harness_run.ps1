Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Remove-Item __odbl.exe -Force -ErrorAction SilentlyContinue
$link = "-O2 -o __odbl.exe _oddball_harness.c output\nova_runtime.o -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w"
$cr = Invoke-Timed -FilePath 'clang' -Arguments $link -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "LINK FAIL"; if ($cr.StdOut) { Write-Host $cr.StdOut }; exit 1 }
$r = Invoke-Timed -FilePath '.\__odbl.exe' -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
if ($r.TimedOut) { Write-Host "RUN TIMEOUT/HANG"; exit 1 }
Write-Host "STDOUT: $($r.StdOut)"
Write-Host "exit=$($r.ExitCode)"
