Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$env:NOVA_NO_TRACK8 = '1'
Remove-Item "$PSScriptRoot\bench_track8.ll","$PSScriptRoot\bench_track8.exe" -Force -ErrorAction SilentlyContinue
$r1 = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "bench_track8.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o bench_track8.exe bench_track8.ll output\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
$r3 = Invoke-Timed -FilePath "$PSScriptRoot\bench_track8.exe" -Arguments "" -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
Write-Host "stdout: $($r3.StdOut.Trim())"
Write-Host "stderr: $($r3.StdErr.Trim())"
Remove-Item "$PSScriptRoot\bench_track8.ll","$PSScriptRoot\bench_track8.exe" -Force -ErrorAction SilentlyContinue
$env:NOVA_NO_TRACK8 = $null
