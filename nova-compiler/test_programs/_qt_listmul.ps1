$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Remove-Item "$dir\_listmul_probe.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "_listmul_probe.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_lm_err.txt" -RedirectStandardOutput "$dir\_lm_out.txt"
$ok = $p.WaitForExit(60000)
if (-not $ok) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
if (-not (Test-Path "$dir\_listmul_probe.ll")) { Write-Host "COMPILE FAILED"; if (Test-Path "$dir\_lm_err.txt") { Get-Content "$dir\_lm_err.txt" }; exit 1 }
& clang "$dir\_listmul_probe.ll" $rtSrc -o "$dir\_listmul_probe.exe" -O2 @linkFlags 2>"$dir\_lm_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_lm_lerr.txt"; exit 1 }
$r = Start-Process -FilePath "$dir\_listmul_probe.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardOutput "$dir\_lm_rout.txt" -RedirectStandardError "$dir\_lm_rerr.txt"
$r.WaitForExit(15000) | Out-Null
Write-Host "OUTPUT:"
if (Test-Path "$dir\_lm_rout.txt") { Get-Content "$dir\_lm_rout.txt" }
