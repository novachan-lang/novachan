Set-Location $PSScriptRoot

Write-Host "=== Compile monitor_test with gen1_final_ipt ==="
if (Test-Path "monitor_test.ll") { Remove-Item "monitor_test.ll" -Force }
$p1 = Start-Process -FilePath ".\gen1_final_ipt.exe" -ArgumentList "monitor_test.nova" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "mt_g1_out.txt" -RedirectStandardError "mt_g1_err.txt" -PassThru -NoNewWindow
$p1.WaitForExit(15000) | Out-Null
Write-Host "gen1_final_ipt result:"
if (Test-Path "monitor_test.ll") { Write-Host "  SUCCESS: $((Get-Item 'monitor_test.ll').Length) bytes" }
else { Write-Host "  FAILED"; Get-Content "mt_g1_err.txt" -ErrorAction SilentlyContinue }

Write-Host ""
Write-Host "=== Compile monitor_test with gen2_negidx ==="
if (Test-Path "monitor_test.ll") { Remove-Item "monitor_test.ll" -Force }
$p2 = Start-Process -FilePath ".\gen2_negidx.exe" -ArgumentList "monitor_test.nova" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "mt_g2_out.txt" -RedirectStandardError "mt_g2_err.txt" -PassThru -NoNewWindow
$p2.WaitForExit(15000) | Out-Null
Write-Host "gen2_negidx result:"
if (Test-Path "monitor_test.ll") { Write-Host "  SUCCESS: $((Get-Item 'monitor_test.ll').Length) bytes" }
else { Write-Host "  FAILED"; Get-Content "mt_g2_err.txt" -ErrorAction SilentlyContinue }
