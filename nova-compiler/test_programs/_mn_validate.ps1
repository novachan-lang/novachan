. "$PSScriptRoot\_proc_util.ps1"
$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$tests = @("mn_stress_test","async_test","select_test","parallel_test","green_transparent","green_scale_test","bounded_chan_test","green_monitor_test","green_netpoll","channel_test")
foreach ($t in $tests) {
    if (-not (Test-Path "$dir\$t.nova")) { Write-Host "SKIP $t (no .nova)"; continue }
    $c = Invoke-Timed -FilePath "$dir\gen4_test.exe" -Arguments "$t.nova" -TimeoutMs 60000
    if ($c.ExitCode -ne 0) { Write-Host "=== $t ===`n  COMPILE-FAIL exit=$($c.ExitCode) $($c.StdErr)"; continue }
    $l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$dir\_mn_$t.exe`" `"$dir\$t.ll`" `"$dir\output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 150000
    if ($l.ExitCode -ne 0) { Write-Host "=== $t ===`n  LINK-FAIL exit=$($l.ExitCode) $($l.StdErr)"; continue }
    Remove-Item Env:\NOVA_CARRIERS -ErrorAction SilentlyContinue
    $r1 = Invoke-Timed -FilePath "$dir\_mn_$t.exe" -TimeoutMs 30000
    $env:NOVA_CARRIERS = "2"; $env:NOVA_CARRIER_STATS = "1"
    $r2 = Invoke-Timed -FilePath "$dir\_mn_$t.exe" -TimeoutMs 30000
    $env:NOVA_CARRIERS = "4"
    $r4 = Invoke-Timed -FilePath "$dir\_mn_$t.exe" -TimeoutMs 30000
    Remove-Item Env:\NOVA_CARRIERS -ErrorAction SilentlyContinue
    Remove-Item Env:\NOVA_CARRIER_STATS -ErrorAction SilentlyContinue
    $o1 = ($r1.StdOut -replace "\s+"," ").Trim(); if ($o1.Length -gt 70) { $o1 = $o1.Substring(0,70) }
    $o2 = ($r2.StdOut -replace "\s+"," ").Trim(); if ($o2.Length -gt 70) { $o2 = $o2.Substring(0,70) }
    $o4 = ($r4.StdOut -replace "\s+"," ").Trim(); if ($o4.Length -gt 70) { $o4 = $o4.Substring(0,70) }
    $car2 = (($r2.StdErr -split "`n") | Where-Object { $_ -match "carriers" }) -join " "
    $car4 = (($r4.StdErr -split "`n") | Where-Object { $_ -match "carriers" }) -join " "
    Write-Host "=== $t ==="
    Write-Host "  N=1 exit=$($r1.ExitCode) to=$($r1.TimedOut) | $o1"
    Write-Host "  N=2 exit=$($r2.ExitCode) to=$($r2.TimedOut) | $o2 || $($car2.Trim())"
    Write-Host "  N=4 exit=$($r4.ExitCode) to=$($r4.TimedOut) | $o4 || $($car4.Trim())"
}
Write-Host "DONE"
