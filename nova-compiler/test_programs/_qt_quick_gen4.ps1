$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"
$sw = [System.Diagnostics.Stopwatch]::StartNew()

Write-Host "=== gen3 -> gen4_new ==="
Remove-Item "$dir\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen3_test.exe" -ArgumentList "nova_compiler.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_qg_err.txt" -RedirectStandardOutput "$dir\_qg_out.txt"
$ok = $p.WaitForExit(450000)
if (-not $ok) { $p.Kill(); Write-Host "TIMEOUT gen3"; exit 1 }
if (-not (Test-Path "$dir\nova_compiler.ll")) {
    Write-Host "gen3 FAILED"; if (Test-Path "$dir\_qg_out.txt") { Get-Content "$dir\_qg_out.txt" }; exit 1
}
Write-Host "gen3 compiled ($($sw.ElapsedMilliseconds)ms)"
& clang "$dir\nova_compiler.ll" $rtSrc -o "$dir\gen4_new.exe" -O2 @linkFlags 2>"$dir\_qg_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; exit 1 }
Write-Host "gen4_new built ($($sw.ElapsedMilliseconds)ms)"

Write-Host "=== Testing _slice_test.nova with gen4_new ==="
Remove-Item "$dir\_slice_test.ll" -Force -ErrorAction SilentlyContinue
$t = Start-Process -FilePath "$dir\gen4_new.exe" -ArgumentList "_slice_test.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_sl_err.txt" -RedirectStandardOutput "$dir\_sl_out.txt"
$tok = $t.WaitForExit(60000)
if (-not $tok) { $t.Kill(); Write-Host "TIMEOUT test"; exit 1 }
if (Test-Path "$dir\_sl_out.txt") { $out = Get-Content "$dir\_sl_out.txt" -Raw; if ($out) { Write-Host $out } }
if (-not (Test-Path "$dir\_slice_test.ll")) { Write-Host "COMPILE FAILED"; exit 1 }
Write-Host "Compile OK"
& clang "$dir\_slice_test.ll" $rtSrc -o "$dir\_slice_test.exe" -O2 @linkFlags 2>"$dir\_sl_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_sl_lerr.txt"; exit 1 }
$r = Start-Process -FilePath "$dir\_slice_test.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_sl_rerr.txt" -RedirectStandardOutput "$dir\_sl_rout.txt"
$rok = $r.WaitForExit(15000)
if (-not $rok) { $r.Kill(); Write-Host "TIMEOUT-RUN"; exit 1 }
Write-Host "OUTPUT:"
if (Test-Path "$dir\_sl_rout.txt") { Get-Content "$dir\_sl_rout.txt" }
Write-Host "STDERR:"
if (Test-Path "$dir\_sl_rerr.txt") { Get-Content "$dir\_sl_rerr.txt" }

Write-Host "=== Testing _comp_range_test.nova ==="
Remove-Item "$dir\_comp_range_test.ll" -Force -ErrorAction SilentlyContinue
$t2 = Start-Process -FilePath "$dir\gen4_new.exe" -ArgumentList "_comp_range_test.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_cr_err.txt" -RedirectStandardOutput "$dir\_cr_out.txt"
$t2ok = $t2.WaitForExit(60000)
if (-not $t2ok) { $t2.Kill(); Write-Host "TIMEOUT comp"; exit 1 }
if (-not (Test-Path "$dir\_comp_range_test.ll")) { Write-Host "COMP RANGE COMPILE FAILED"; exit 1 }
& clang "$dir\_comp_range_test.ll" $rtSrc -o "$dir\_comp_range_test.exe" -O2 @linkFlags 2>"$dir\_cr_lerr.txt"
$r2 = Start-Process -FilePath "$dir\_comp_range_test.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_cr_rerr.txt" -RedirectStandardOutput "$dir\_cr_rout.txt"
$r2.WaitForExit(15000) | Out-Null
Write-Host "COMP RANGE OUTPUT:"
if (Test-Path "$dir\_cr_rout.txt") { Get-Content "$dir\_cr_rout.txt" }

Write-Host "`nTotal: $($sw.ElapsedMilliseconds)ms"
