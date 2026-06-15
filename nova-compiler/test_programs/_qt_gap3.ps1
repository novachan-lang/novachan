$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Remove-Item "$dir\_gap3_probe.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "_gap3_probe.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_g3_err.txt" -RedirectStandardOutput "$dir\_g3_out.txt"
$ok = $p.WaitForExit(60000)
if (-not $ok) { $p.Kill(); Write-Host "TIMEOUT" }
Write-Host "=== STDOUT ==="
if (Test-Path "$dir\_g3_out.txt") { Get-Content "$dir\_g3_out.txt" }
if (-not (Test-Path "$dir\_gap3_probe.ll")) { Write-Host "COMPILE FAILED"; exit 1 }
Write-Host "=== LINK ==="
& clang "$dir\_gap3_probe.ll" $rtSrc -o "$dir\_gap3_probe.exe" -O2 @linkFlags 2>"$dir\_g3_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_g3_lerr.txt"; exit 1 }
$r = Start-Process -FilePath "$dir\_gap3_probe.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_g3_rerr.txt" -RedirectStandardOutput "$dir\_g3_rout.txt"
$rok = $r.WaitForExit(15000)
if (-not $rok) { $r.Kill(); Write-Host "TIMEOUT-RUN"; exit 1 }
Write-Host "OUTPUT:"
if (Test-Path "$dir\_g3_rout.txt") { Get-Content "$dir\_g3_rout.txt" }
Write-Host "STDERR:"
if (Test-Path "$dir\_g3_rerr.txt") { Get-Content "$dir\_g3_rerr.txt" }
