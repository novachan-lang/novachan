Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$r = Invoke-Timed -FilePath (Resolve-Path '.\gen4_test.exe').Path -Arguments '_memo_probe.nova' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
Write-Host "EXIT: $($r.ExitCode)"
if ($r.StdOut) { Write-Host "OUT: $($r.StdOut)" }
if ($r.StdErr) { Write-Host "ERR: $($r.StdErr)" }
