$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Remove-Item "$dir\_fp2.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "_fp2.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_fp2_err.txt" -RedirectStandardOutput "$dir\_fp2_out.txt"
$ok = $p.WaitForExit(60000)
if (-not $ok) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
if (Test-Path "$dir\_fp2_out.txt") { $o = Get-Content "$dir\_fp2_out.txt" -Raw; if ($o) { Write-Host $o } }
if (-not (Test-Path "$dir\_fp2.ll")) {
    Write-Host "COMPILE FAILED"
    if (Test-Path "$dir\_fp2_err.txt") { Get-Content "$dir\_fp2_err.txt" }
    exit 1
}
& clang "$dir\_fp2.ll" $rtSrc -o "$dir\_fp2.exe" -O2 @linkFlags 2>"$dir\_fp2_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_fp2_lerr.txt"; exit 1 }
$r = Start-Process -FilePath "$dir\_fp2.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_fp2_rerr.txt" -RedirectStandardOutput "$dir\_fp2_rout.txt"
$rok = $r.WaitForExit(15000)
if (-not $rok) { $r.Kill(); Write-Host "TIMEOUT-RUN"; exit 1 }
Write-Host "OUTPUT:"
if (Test-Path "$dir\_fp2_rout.txt") { Get-Content "$dir\_fp2_rout.txt" }
Write-Host "STDERR:"
if (Test-Path "$dir\_fp2_rerr.txt") { Get-Content "$dir\_fp2_rerr.txt" }
