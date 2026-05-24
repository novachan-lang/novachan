Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "Step 1: Compile nova_compiler.nova with gen2_move..."
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 90000
Write-Host "Exit: $($cr.ExitCode), TimedOut: $($cr.TimedOut)"
if ($cr.StdOut) { Write-Host "STDOUT:"; $cr.StdOut -split "`n" | Select-Object -First 30 | ForEach-Object { Write-Host "  $_" } }
if ($cr.StdErr) { Write-Host "STDERR:"; $cr.StdErr -split "`n" | Select-Object -First 10 | ForEach-Object { Write-Host "  $_" } }
