param([string]$Name = "float_test")
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$r = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "$Name.nova" -TimeoutMs 240000
Write-Host "Exit: $($r.ExitCode)"
Write-Host "STDOUT:"
Write-Host $r.StdOut
if ($r.StdErr) { Write-Host "STDERR:"; Write-Host $r.StdErr }
Remove-Item "nova_runtime.c","$Name.ll" -Force -ErrorAction SilentlyContinue
