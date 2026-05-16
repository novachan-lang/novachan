Set-Location $PSScriptRoot
$benches = @('bench_channel','bench_spawn','bench_string','bench_dict','bench_list_ops')

foreach ($b in $benches) {
    $exe = "test_programs\output\$b.exe"
    $times = @()
    for ($i = 0; $i -lt 5; $i++) {
        $t = (Measure-Command { & $exe | Out-Null }).TotalMilliseconds
        $times += [math]::Round($t, 1)
    }
    $avg = [math]::Round(($times | Measure-Object -Average).Average, 1)
    Write-Host "$b times (ms): $($times -join ', ')"
    Write-Host "Average: $avg ms"
    Write-Host ""
}
