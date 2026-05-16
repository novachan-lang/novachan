Set-Location $PSScriptRoot

Write-Host "=== Integer sum_to(1B) ==="
$novaTimes = @()
for ($i = 0; $i -lt 5; $i++) {
    $t = (Measure-Command { & bench\gate4_nova_loop_O2.exe | Out-Null }).TotalMilliseconds
    $novaTimes += [math]::Round($t, 1)
}
$cTimes = @()
for ($i = 0; $i -lt 5; $i++) {
    $t = (Measure-Command { & bench\gate4_loop_O2.exe | Out-Null }).TotalMilliseconds
    $cTimes += [math]::Round($t, 1)
}
$novaBest = ($novaTimes | Measure-Object -Minimum).Minimum
$cBest = ($cTimes | Measure-Object -Minimum).Minimum
Write-Host "NOVA times: $($novaTimes -join ', ') ms (best: $novaBest)"
Write-Host "C -O2 times: $($cTimes -join ', ') ms (best: $cBest)"
Write-Host "Ratio: $([math]::Round($novaBest / $cBest, 2))x"
