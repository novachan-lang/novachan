Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$r = Invoke-Timed -FilePath (Resolve-Path '.\gen3_test.exe').Path -Arguments 'memo_test.nova' -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
Write-Host "EXIT: $($r.ExitCode)"
if ($r.StdOut) { Write-Host "STDOUT: $($r.StdOut)" }
if ($r.StdErr) { Write-Host "STDERR: $($r.StdErr)" }
