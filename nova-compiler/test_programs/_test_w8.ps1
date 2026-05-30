Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

foreach ($mode in @('default','w5b_only','w8')) {
    $env:NOVA_T8_DROP = $null
    $env:NOVA_T8_W8 = $null
    if ($mode -eq 'w5b_only') { $env:NOVA_T8_DROP = '1' }
    if ($mode -eq 'w8') { $env:NOVA_T8_DROP = '1'; $env:NOVA_T8_W8 = '1' }

    Remove-Item "$PSScriptRoot\t8_w8_test.ll","$PSScriptRoot\t8_w8_test.exe" -Force -ErrorAction SilentlyContinue
    $r1 = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "t8_w8_test.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    $r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o t8_w8_test.exe t8_w8_test.ll output\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    $r3 = Invoke-Timed -FilePath "$PSScriptRoot\t8_w8_test.exe" -Arguments "" -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
    $drops = (Get-Content "$PSScriptRoot\t8_w8_test.ll" | Select-String -Pattern "call i64 @nova_rt_list_free_local").Count
    Write-Host "[$mode] compile=$($r1.ExitCode) link=$($r2.ExitCode) run=$($r3.ExitCode) drops_in_ll=$drops stdout=$($r3.StdOut.Trim())"
}
Remove-Item "$PSScriptRoot\t8_w8_test.exe","$PSScriptRoot\t8_w8_test.ll" -Force -ErrorAction SilentlyContinue
$env:NOVA_T8_DROP = $null
$env:NOVA_T8_W8 = $null
