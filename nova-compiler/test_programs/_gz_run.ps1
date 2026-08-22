. "$PSScriptRoot\_proc_util.ps1"
Remove-Item -Force _gen_zerocost.ll,_gen_zerocost.exe,_gen_zerocost.o -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "build _gen_zerocost.nova" -TimeoutMs 240000
Write-Host "compile exit=$($c.ExitCode)"
if ($c.ExitCode -ne 0) { Write-Host $c.StdOut; Write-Host $c.StdErr; exit 1 }
$r = Invoke-Timed -FilePath ".\_gen_zerocost.exe" -Arguments "" -TimeoutMs 240000
Write-Host "run exit=$($r.ExitCode)"
Write-Host $r.StdOut
if ($r.StdErr) { Write-Host "ERR: $($r.StdErr)" }
