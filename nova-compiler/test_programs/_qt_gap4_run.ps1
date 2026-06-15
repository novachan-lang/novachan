$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Remove-Item "$dir\_gap4_probe.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "_gap4_probe.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_g4_err.txt" -RedirectStandardOutput "$dir\_g4_out.txt"
$ok = $p.WaitForExit(60000)
if (-not $ok) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
if (Test-Path "$dir\_g4_out.txt") { $o = Get-Content "$dir\_g4_out.txt" -Raw; if ($o) { Write-Host $o } }
if (-not (Test-Path "$dir\_gap4_probe.ll")) { Write-Host "COMPILE FAILED"; exit 1 }
& clang "$dir\_gap4_probe.ll" $rtSrc -o "$dir\_gap4_probe.exe" -O2 @linkFlags 2>"$dir\_g4_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_g4_lerr.txt"; exit 1 }
$r = Start-Process -FilePath "$dir\_gap4_probe.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_g4_rerr.txt" -RedirectStandardOutput "$dir\_g4_rout.txt"
$r.WaitForExit(15000) | Out-Null
Write-Host "OUTPUT:"
if (Test-Path "$dir\_g4_rout.txt") { Get-Content "$dir\_g4_rout.txt" }
Write-Host "STDERR:"
if (Test-Path "$dir\_g4_rerr.txt") { Get-Content "$dir\_g4_rerr.txt" }
