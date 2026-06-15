$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
Remove-Item "$dir\_gap4_probe.ll" -Force -ErrorAction SilentlyContinue
$p = Start-Process -FilePath "$dir\gen4_test.exe" -ArgumentList "_gap4_probe.nova" `
    -NoNewWindow -PassThru -WorkingDirectory $dir `
    -RedirectStandardError "$dir\_g4_err.txt" -RedirectStandardOutput "$dir\_g4_out.txt"
$ok = $p.WaitForExit(60000)
if (-not $ok) { $p.Kill(); Write-Host "TIMEOUT" }
Write-Host "=== STDOUT ==="
if (Test-Path "$dir\_g4_out.txt") { Get-Content "$dir\_g4_out.txt" }
