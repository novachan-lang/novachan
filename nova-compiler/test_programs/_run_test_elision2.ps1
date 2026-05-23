Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$compiler = ".\gen2_move.exe"
$test = "move_elision_test"
$cr = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "$test.nova" -TimeoutMs 30000
Write-Host "Compile exit: $($cr.ExitCode)"
if (Test-Path "$test.ll") {
    $lines = Get-Content "$test.ll" | Select-String "channel_send"
    foreach ($l in $lines) { Write-Host $l.Line.Trim() }
}
Remove-Item "$test.ll","$test.exe" -Force -ErrorAction SilentlyContinue
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
