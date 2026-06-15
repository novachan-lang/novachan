$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Remove-Item "$dir\_interp_test.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "_interp_test.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_ip_err.txt" -RedirectStandardOutput "$dir\_ip_out.txt"
$ok = $p.WaitForExit(60000)
if (-not $ok) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
if (Test-Path "$dir\_ip_out.txt") { $out = Get-Content "$dir\_ip_out.txt" -Raw; if ($out) { Write-Host $out } }
if (-not (Test-Path "$dir\_interp_test.ll")) { Write-Host "COMPILE FAILED"; exit 1 }
Write-Host "Compile OK, linking..."
& clang "$dir\_interp_test.ll" $rtSrc -o "$dir\_interp_test.exe" -O2 @linkFlags 2>"$dir\_ip_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; exit 1 }
$r = Start-Process -FilePath "$dir\_interp_test.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_ip_rerr.txt" -RedirectStandardOutput "$dir\_ip_rout.txt"
$rok = $r.WaitForExit(15000)
if (-not $rok) { $r.Kill(); Write-Host "TIMEOUT-RUN"; exit 1 }
Write-Host "OUTPUT:"
if (Test-Path "$dir\_ip_rout.txt") { Get-Content "$dir\_ip_rout.txt" }
