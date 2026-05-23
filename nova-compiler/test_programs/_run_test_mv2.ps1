Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$compiler = ".\gen2_move.exe"
foreach ($test in @("move_cap_test", "move_assign_test")) {
    $cr = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "$test.nova" -TimeoutMs 30000
    Write-Host "$test : exit=$($cr.ExitCode) timeout=$($cr.TimedOut)"
    if (Test-Path "$test.ll") { Write-Host "  LL OK" } else { Write-Host "  FAIL: no .ll" }
    Remove-Item "$test.ll","$test.exe" -Force -ErrorAction SilentlyContinue
}
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
