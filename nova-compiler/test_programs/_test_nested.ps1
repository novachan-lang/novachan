Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$r = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "nested_fn_test.nova" -TimeoutMs 30000
Write-Host "EXIT=$($r.ExitCode)"
Write-Host $r.StdOut
Write-Host $r.StdErr
