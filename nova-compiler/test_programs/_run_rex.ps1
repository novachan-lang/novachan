Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$r = Invoke-Timed -FilePath (Resolve-Path ".\rex.exe").Path -TimeoutMs 15000
Write-Host $r.Stdout
if ($r.Stderr.Length -gt 0) { Write-Host "STDERR: $($r.Stderr)" }
Write-Host "EXIT=$($r.ExitCode)"
