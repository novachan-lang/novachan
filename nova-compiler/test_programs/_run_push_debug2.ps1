Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "push_debug.nova" -TimeoutMs 30000
Write-Host "Exit: $($cr.ExitCode)"
if ($cr.StdOut) { Write-Host "STDOUT: $($cr.StdOut.Substring(0, [Math]::Min(500, $cr.StdOut.Length)))" }
if ($cr.StdErr) { Write-Host "STDERR: $($cr.StdErr.Substring(0, [Math]::Min(500, $cr.StdErr.Length)))" }
