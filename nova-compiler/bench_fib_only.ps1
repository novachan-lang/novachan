Set-Location $PSScriptRoot
# Quick fib sanity check
for ($i = 0; $i -lt 3; $i++) { & test_programs\output\fib_bench.exe | Out-Null }
$times = @()
for ($i = 0; $i -lt 5; $i++) {
    $t = (Measure-Command { & test_programs\output\fib_bench.exe | Out-Null }).TotalMilliseconds
    $times += [math]::Round($t, 1)
}
Write-Host "fib(40): $($times -join ', ') ms (best: $(($times | Measure-Object -Minimum).Minimum))"
