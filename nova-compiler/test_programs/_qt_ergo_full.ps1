$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"
$sw = [System.Diagnostics.Stopwatch]::StartNew()

Write-Host "=== gen3 -> gen4_new ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen3_test.exe" -ArgumentList "nova_compiler.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_ef_err.txt" -RedirectStandardOutput "$dir\_ef_out.txt"
$ok = $p.WaitForExit(450000)
if (-not $ok) { $p.Kill(); Write-Host "TIMEOUT gen3"; exit 1 }
if (-not (Test-Path "$dir\nova_compiler.ll")) {
    Write-Host "gen3 FAILED"
    if (Test-Path "$dir\_ef_out.txt") { Get-Content "$dir\_ef_out.txt" }
    exit 1
}
Write-Host "gen3 compiled ($($sw.ElapsedMilliseconds)ms)"
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4_new.exe" -O2 @linkFlags 2>"$dir\_ef_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_ef_lerr.txt"; exit 1 }
Write-Host "gen4_new built ($($sw.ElapsedMilliseconds)ms)"

Write-Host "=== Testing _alias_test.nova ==="
Remove-Item "$dir\_alias_test.ll" -Force -ErrorAction SilentlyContinue
$t1 = Start-Process -FilePath "$dir\gen4_new.exe" -ArgumentList "_alias_test.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_t1_err.txt" -RedirectStandardOutput "$dir\_t1_out.txt"
$t1.WaitForExit(60000) | Out-Null
if (-not (Test-Path "$dir\_alias_test.ll")) { Write-Host "ALIAS COMPILE FAILED"; exit 1 }
& clang "$dir\_alias_test.ll" $rtSrc -o "$dir\_alias_test.exe" -O2 @linkFlags 2>$null
$r1 = Start-Process -FilePath "$dir\_alias_test.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardOutput "$dir\_t1_rout.txt" -RedirectStandardError "$dir\_t1_rerr.txt"
$r1.WaitForExit(15000) | Out-Null
Write-Host "ALIAS:"
if (Test-Path "$dir\_t1_rout.txt") { Get-Content "$dir\_t1_rout.txt" }

Write-Host "=== Testing _ergonomics_probe.nova ==="
Remove-Item "$dir\_ergonomics_probe.ll" -Force -ErrorAction SilentlyContinue
$t2 = Start-Process -FilePath "$dir\gen4_new.exe" -ArgumentList "_ergonomics_probe.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_t2_err.txt" -RedirectStandardOutput "$dir\_t2_out.txt"
$t2.WaitForExit(60000) | Out-Null
if (Test-Path "$dir\_t2_out.txt") { $o = Get-Content "$dir\_t2_out.txt" -Raw; if ($o) { Write-Host $o } }
if (-not (Test-Path "$dir\_ergonomics_probe.ll")) {
    Write-Host "ERGO COMPILE FAILED"
    if (Test-Path "$dir\_t2_err.txt") { Get-Content "$dir\_t2_err.txt" }
    exit 1
}
& clang "$dir\_ergonomics_probe.ll" $rtSrc -o "$dir\_ergonomics_probe.exe" -O2 @linkFlags 2>"$dir\_t2_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_t2_lerr.txt"; exit 1 }
$r2 = Start-Process -FilePath "$dir\_ergonomics_probe.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardOutput "$dir\_t2_rout.txt" -RedirectStandardError "$dir\_t2_rerr.txt"
$r2.WaitForExit(15000) | Out-Null
Write-Host "ERGO:"
if (Test-Path "$dir\_t2_rout.txt") { Get-Content "$dir\_t2_rout.txt" }
Write-Host "ERGO STDERR:"
if (Test-Path "$dir\_t2_rerr.txt") { Get-Content "$dir\_t2_rerr.txt" }

Write-Host "=== Testing _pipe_test.nova ==="
Remove-Item "$dir\_pipe_test.ll" -Force -ErrorAction SilentlyContinue
$t3 = Start-Process -FilePath "$dir\gen4_new.exe" -ArgumentList "_pipe_test.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_t3_err.txt" -RedirectStandardOutput "$dir\_t3_out.txt"
$t3.WaitForExit(60000) | Out-Null
if (-not (Test-Path "$dir\_pipe_test.ll")) { Write-Host "PIPE COMPILE FAILED"; exit 1 }
& clang "$dir\_pipe_test.ll" $rtSrc -o "$dir\_pipe_test.exe" -O2 @linkFlags 2>$null
$r3 = Start-Process -FilePath "$dir\_pipe_test.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardOutput "$dir\_t3_rout.txt" -RedirectStandardError "$dir\_t3_rerr.txt"
$r3.WaitForExit(15000) | Out-Null
Write-Host "PIPE:"
if (Test-Path "$dir\_t3_rout.txt") { Get-Content "$dir\_t3_rout.txt" }

Write-Host "`nTotal: $($sw.ElapsedMilliseconds)ms"
