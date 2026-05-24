Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$compiler = (Resolve-Path ".\gen2_move.exe").Path

$cr = Invoke-Timed -FilePath $compiler -Arguments "buffer_test.nova" -TimeoutMs 30000
if (Test-Path "buffer_test.ll") {
    Write-Host "=== buffer_append calls ==="
    Select-String -Path "buffer_test.ll" -Pattern "buffer_append|set_arena" |
        ForEach-Object { Write-Host $_.Line.Trim() }
    Write-Host ""
    Write-Host "=== void declarations ==="
    Select-String -Path "buffer_test.ll" -Pattern "declare void" |
        ForEach-Object { Write-Host $_.Line.Trim() }
    Remove-Item "buffer_test.ll" -Force
}

$cr2 = Invoke-Timed -FilePath $compiler -Arguments "arena_test.nova" -TimeoutMs 30000
if (Test-Path "arena_test.ll") {
    Write-Host "`n=== arena calls ==="
    Select-String -Path "arena_test.ll" -Pattern "arena_mode" |
        ForEach-Object { Write-Host $_.Line.Trim() }
    Remove-Item "arena_test.ll" -Force
}
