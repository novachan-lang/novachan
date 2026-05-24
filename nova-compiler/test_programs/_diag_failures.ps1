Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path ".\gen2_move.exe").Path
$failing = @("spawn_block_test", "sys_test", "import_multi_test")

foreach ($t in $failing) {
    Write-Host "=== $t ==="
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000
    Write-Host "Exit: $($cr.ExitCode)"
    if ($cr.StdOut) { $cr.StdOut -split "`n" | Select-Object -First 15 | ForEach-Object { Write-Host "  $_" } }
    Write-Host ""
}
