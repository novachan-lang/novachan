Set-Location $PSScriptRoot

$times = @()
for ($i = 0; $i -lt 5; $i++) {
    $t = (Measure-Command { & test_programs\output\num_bench_O3.exe | Out-Null }).TotalMilliseconds
    $times += [math]::Round($t, 1)
}
$best = ($times | Measure-Object -Minimum).Minimum
Write-Host "num_bench -O3 times: $($times -join ', ') ms"
Write-Host "Best: $best ms"

$times2 = @()
for ($i = 0; $i -lt 5; $i++) {
    $t = (Measure-Command { & test_programs\output\num_bench.exe | Out-Null }).TotalMilliseconds
    $times2 += [math]::Round($t, 1)
}
$best2 = ($times2 | Measure-Object -Minimum).Minimum
Write-Host "num_bench -O2 times: $($times2 -join ', ') ms"
Write-Host "Best: $best2 ms"
