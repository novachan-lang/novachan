Set-Location $PSScriptRoot

Write-Host "=== NOVA Compute Benchmarks ==="
$fibTimes = @()
for ($i = 0; $i -lt 5; $i++) {
    $t = (Measure-Command { & test_programs\output\fib_bench.exe | Out-Null }).TotalMilliseconds
    $fibTimes += [math]::Round($t, 1)
}
$fibAvg = [math]::Round(($fibTimes | Measure-Object -Average).Average, 1)
Write-Host "fib(40) times (ms): $($fibTimes -join ', ')"
Write-Host "Average: $fibAvg ms"
Write-Host ""

$numTimes = @()
for ($i = 0; $i -lt 5; $i++) {
    $t = (Measure-Command { & test_programs\output\num_bench.exe | Out-Null }).TotalMilliseconds
    $numTimes += [math]::Round($t, 1)
}
$numAvg = [math]::Round(($numTimes | Measure-Object -Average).Average, 1)
Write-Host "num_bench times (ms): $($numTimes -join ', ')"
Write-Host "Average: $numAvg ms"
