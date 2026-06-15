Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$rt = "$PSScriptRoot\output\nova_runtime.c"
$wd = $PSScriptRoot
$flags = "-lws2_32 -ladvapi32"

foreach ($t in @('defer_test','lazy_gen_test','const_test','hot_reload_test','io_poll_test','ws_sched_test')) {
    Write-Host "=== $t ==="
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 60000 -WorkingDirectory $wd
    if ($cr.ExitCode -ne 0) { Write-Host "COMPILE FAIL: $($cr.StdErr)"; continue }
    if (!(Test-Path "$PSScriptRoot\$t.ll")) { Write-Host "NO .ll"; continue }

    $linkArgs = "-O2 -o `"$PSScriptRoot\$t.exe`" `"$PSScriptRoot\$t.ll`" `"$rt`" $flags -D_CRT_SECURE_NO_WARNINGS -w"
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 60000 -WorkingDirectory $wd
    if (!(Test-Path "$PSScriptRoot\$t.exe")) { Write-Host "LINK FAIL: $($lr.StdErr)"; continue }

    $rr = Invoke-Timed -FilePath "$PSScriptRoot\$t.exe" -Arguments '' -TimeoutMs 15000 -WorkingDirectory $wd
    if ($rr.TimedOut) { Write-Host "TIMEOUT" }
    elseif ($rr.ExitCode -ne 0) { Write-Host "RUN FAIL exit=$($rr.ExitCode)"; Write-Host $rr.StdErr }
    else { Write-Host $rr.StdOut; Write-Host "PASS" }

    Remove-Item "$PSScriptRoot\$t.exe","$PSScriptRoot\$t.ll" -Force -ErrorAction SilentlyContinue
}
