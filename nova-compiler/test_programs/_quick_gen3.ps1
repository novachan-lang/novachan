Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$c1 = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "compile nova_compiler.nova" -TimeoutMs 450000
Write-Host "EXIT=$($c1.ExitCode)"
Write-Host "STDOUT: $($c1.Stdout)"
Write-Host "STDERR: $($c1.Stderr)"
