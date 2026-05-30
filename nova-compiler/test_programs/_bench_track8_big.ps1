Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

foreach ($mode in @('default','track8','autoarena')) {
    $env:NOVA_TRACK8 = $null
    $env:NOVA_AUTO_ARENA = $null
    if ($mode -eq 'track8') { $env:NOVA_TRACK8 = '1' }
    if ($mode -eq 'autoarena') { $env:NOVA_TRACK8 = '1'; $env:NOVA_AUTO_ARENA = '1' }

    Remove-Item "$PSScriptRoot\bench_track8_big.ll","$PSScriptRoot\bench_track8_big.exe" -Force -ErrorAction SilentlyContinue
    $r1 = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "bench_track8_big.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    $r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o bench_track8_big.exe bench_track8_big.ll output\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if ($r1.ExitCode -ne 0 -or $r2.ExitCode -ne 0) { Write-Host "[$mode] BUILD FAILED"; continue }

    $r3 = Invoke-Timed -FilePath "$PSScriptRoot\bench_track8_big.exe" -Arguments "" -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
    Write-Host "[$mode] stdout: $($r3.StdOut.Trim())"
    Write-Host "[$mode] stderr: $($r3.StdErr.Trim())"
}
Remove-Item "$PSScriptRoot\bench_track8_big.exe","$PSScriptRoot\bench_track8_big.ll" -Force -ErrorAction SilentlyContinue
$env:NOVA_TRACK8 = $null
$env:NOVA_AUTO_ARENA = $null
