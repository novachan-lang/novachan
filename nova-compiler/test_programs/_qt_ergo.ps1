$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Remove-Item "$dir\_ergonomics_probe.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "_ergonomics_probe.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_eg_err.txt" -RedirectStandardOutput "$dir\_eg_out.txt"
$ok = $p.WaitForExit(60000)
if (-not $ok) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
if (Test-Path "$dir\_eg_out.txt") { $o = Get-Content "$dir\_eg_out.txt" -Raw; if ($o) { Write-Host $o } }
if (-not (Test-Path "$dir\_ergonomics_probe.ll")) {
    Write-Host "COMPILE FAILED"
    if (Test-Path "$dir\_eg_err.txt") { Get-Content "$dir\_eg_err.txt" }
    exit 1
}
& clang "$dir\_ergonomics_probe.ll" $rtSrc -o "$dir\_ergonomics_probe.exe" -O2 @linkFlags 2>"$dir\_eg_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_eg_lerr.txt"; exit 1 }
$r = Start-Process -FilePath "$dir\_ergonomics_probe.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_eg_rerr.txt" -RedirectStandardOutput "$dir\_eg_rout.txt"
$rok = $r.WaitForExit(15000)
if (-not $rok) { $r.Kill(); Write-Host "TIMEOUT-RUN"; exit 1 }
Write-Host "OUTPUT:"
if (Test-Path "$dir\_eg_rout.txt") { Get-Content "$dir\_eg_rout.txt" }
Write-Host "STDERR:"
if (Test-Path "$dir\_eg_rerr.txt") { Get-Content "$dir\_eg_rerr.txt" }
