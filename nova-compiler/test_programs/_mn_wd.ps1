$dir = $PSScriptRoot
. "$dir\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
$c = Invoke-Timed -FilePath "$dir\gen4_test.exe" -Arguments "_p2.nova" -TimeoutMs 60000
if ($c.ExitCode -ne 0) { Write-Host "COMPILE-FAIL $($c.StdErr)"; exit 1 }
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$dir\_p2.exe`" `"$dir\_p2.ll`" `"$dir\output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 150000
if ($l.ExitCode -ne 0) { Write-Host "LINK-FAIL $($l.StdErr)"; exit 1 }
Write-Host "built _p2.exe"
$env:NOVA_CARRIERS = "8"; $env:NOVA_SCHED_WATCHDOG = "1"
$errf = "$dir\_wd_err.txt"; $outf = "$dir\_wd_out.txt"
for ($i = 1; $i -le 40; $i++) {
    if (Test-Path $errf) { Remove-Item $errf }
    $p = Start-Process -FilePath "$dir\_p2.exe" -RedirectStandardError $errf -RedirectStandardOutput $outf -PassThru -NoNewWindow
    $exited = $p.WaitForExit(12000)
    if (-not $exited) {
        Write-Host "=== RUN $i HUNG ==="
        Start-Sleep -Milliseconds 300
        try { $p.Kill() } catch {}
        try { $p.WaitForExit(3000) | Out-Null } catch {}
        if (Test-Path $errf) {
            Write-Host "--- POLLUTION/BUG lines ---"
            Get-Content $errf | Where-Object { $_ -match "POLLUTION|BUG|carrier-convert" } | ForEach-Object { Write-Host "  $_" }
            Write-Host "--- last 50 lines ---"
            Get-Content $errf | Select-Object -Last 50 | ForEach-Object { Write-Host "  $_" }
        }
        Write-Host "out: $((Get-Content $outf -Raw))"
        exit 0
    } else {
        Write-Host "run $i ok exit=$($p.ExitCode)"
    }
}
Write-Host "no hang in 40 runs"
