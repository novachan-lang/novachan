Set-Location $PSScriptRoot
$exe = "test_programs\output\fib_bench.exe"
if (-not (Test-Path $exe)) { Write-Host "fib_bench.exe not found"; exit 1 }

$times = @()
for ($i = 0; $i -lt 5; $i++) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    & $exe | Out-Null
    $sw.Stop()
    $times += $sw.ElapsedMilliseconds
}
Write-Host "fib_bench times (ms): $($times -join ', ')"
Write-Host "Average: $([math]::Round(($times | Measure-Object -Average).Average, 1)) ms"

$exe2 = "test_programs\output\num_bench.exe"
if (Test-Path $exe2) {
    $times2 = @()
    for ($i = 0; $i -lt 5; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        & $exe2 | Out-Null
        $sw.Stop()
        $times2 += $sw.ElapsedMilliseconds
    }
    Write-Host "num_bench times (ms): $($times2 -join ', ')"
    Write-Host "Average: $([math]::Round(($times2 | Measure-Object -Average).Average, 1)) ms"
}
