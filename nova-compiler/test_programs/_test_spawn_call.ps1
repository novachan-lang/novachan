Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "`"$PSScriptRoot\test_spawn_call.nova`"" -TimeoutMs 30000
Write-Host "COMPILE EXIT: $($cr.ExitCode)"
if ($cr.StdOut) { $cr.StdOut | ForEach-Object { Write-Host $_ } }
if ($cr.ExitCode -ne 0) { exit 1 }

Copy-Item "$PSScriptRoot\output\nova_runtime.c" "$PSScriptRoot\rt_tmp.c" -Force
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$PSScriptRoot\test_spawn_call.exe`" `"$PSScriptRoot\test_spawn_call.ll`" `"$PSScriptRoot\rt_tmp.c`" $NovaLinkFlags" -TimeoutMs 60000
if (!(Test-Path "$PSScriptRoot\test_spawn_call.exe")) {
    Write-Host "LINK FAIL:"
    if ($lr.StdErr) { $lr.StdErr | ForEach-Object { Write-Host $_ } }
    exit 1
}

Write-Host "--- RUN ---"
$rr = Invoke-Timed -FilePath (Resolve-Path "$PSScriptRoot\test_spawn_call.exe").Path -Arguments "" -TimeoutMs 10000
Write-Host "RUN EXIT: $($rr.ExitCode)"
if ($rr.StdOut) { $rr.StdOut | ForEach-Object { Write-Host $_ } }
Remove-Item "$PSScriptRoot\test_spawn_call.ll","$PSScriptRoot\test_spawn_call.exe","$PSScriptRoot\rt_tmp.c" -Force -ErrorAction SilentlyContinue
