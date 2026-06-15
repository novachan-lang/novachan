$dir = $PSScriptRoot
$linkFlags = @("-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w")
$rtSrc = "$dir\output\nova_runtime.c"
& clang "$dir\_gap2_probe.ll" $rtSrc -o "$dir\_gap2_probe.exe" -O2 @linkFlags 2>"$dir\_g2_lerr.txt"
if ($LASTEXITCODE -ne 0) { Write-Host "LINK FAILED"; Get-Content "$dir\_g2_lerr.txt"; exit 1 }
$r = Start-Process -FilePath "$dir\_gap2_probe.exe" -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_g2_rerr.txt" -RedirectStandardOutput "$dir\_g2_rout.txt"
$r.WaitForExit(15000) | Out-Null
Write-Host "OUTPUT:"
if (Test-Path "$dir\_g2_rout.txt") { Get-Content "$dir\_g2_rout.txt" }
Write-Host "STDERR:"
if (Test-Path "$dir\_g2_rerr.txt") { Get-Content "$dir\_g2_rerr.txt" }
