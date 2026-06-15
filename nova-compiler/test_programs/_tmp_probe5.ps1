Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
Remove-Item _memo_probe3.ll -Force -ErrorAction SilentlyContinue
Remove-Item _memo_probe3.exe -Force -ErrorAction SilentlyContinue
Write-Host "gen4_test.exe timestamp: $((Get-Item gen4_test.exe).LastWriteTime)"
$r = Invoke-Timed -FilePath (Resolve-Path '.\gen4_test.exe').Path -Arguments '_memo_probe3.nova' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
Write-Host "COMPILE EXIT: $($r.ExitCode)"
if ($r.StdOut) { Write-Host $r.StdOut }
if ($r.StdErr) { Write-Host $r.StdErr }
if ($r.ExitCode -ne 0) { exit 1 }
Write-Host ""
Write-Host "=== Checking IR dispatch ==="
Select-String 'memo_cache|nova_rt_memo' _memo_probe3.ll | ForEach-Object { Write-Host $_.Line.Trim() }
