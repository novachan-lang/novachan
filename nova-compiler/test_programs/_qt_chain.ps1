$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"

Remove-Item "$dir\_chain_probe.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "_chain_probe.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_cp_err.txt" -RedirectStandardOutput "$dir\_cp_out.txt"
$ok = $p.WaitForExit(60000)
if (-not $ok) { $p.Kill(); Write-Host "TIMEOUT"; exit 1 }
if (Test-Path "$dir\_cp_out.txt") { $o = Get-Content "$dir\_cp_out.txt" -Raw; if ($o) { Write-Host $o } }
if (-not (Test-Path "$dir\_chain_probe.ll")) { Write-Host "COMPILE FAILED"; exit 1 }
& clang "$dir\_chain_probe.ll" $rtSrc -o "$dir\_chain_probe.exe" -O2 @linkFlags 2>"$dir\_cp_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; exit 1 }
$r = Start-Process -FilePath "$dir\_chain_probe.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_cp_rerr.txt" -RedirectStandardOutput "$dir\_cp_rout.txt"
$r.WaitForExit(15000) | Out-Null
Write-Host "OUTPUT:"
if (Test-Path "$dir\_cp_rout.txt") { Get-Content "$dir\_cp_rout.txt" }
