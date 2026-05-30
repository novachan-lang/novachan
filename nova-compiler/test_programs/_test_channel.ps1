Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

foreach ($mode in @('default','t8')) {
    if ($mode -eq 't8') { $env:NOVA_TRACK8 = '1' } else { $env:NOVA_TRACK8 = $null }
    $r1 = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "t8_channel_test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    $r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o t8_channel_test.exe t8_channel_test.ll output\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    $r3 = Invoke-Timed -FilePath "$PSScriptRoot\t8_channel_test.exe" -Arguments "" -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
    Write-Host "[$mode] compile=$($r1.ExitCode) link=$($r2.ExitCode) run=$($r3.ExitCode) stdout=$($r3.StdOut.Trim())"
}
Remove-Item "$PSScriptRoot\t8_channel_test.exe","$PSScriptRoot\t8_channel_test.ll" -Force -ErrorAction SilentlyContinue
$env:NOVA_TRACK8 = $null
