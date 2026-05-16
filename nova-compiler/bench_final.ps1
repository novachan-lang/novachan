Set-Location $PSScriptRoot

# Warmup
for ($w = 0; $w -lt 3; $w++) {
    & test_programs\output\bench_string.exe | Out-Null
    & test_programs\output\bench_dict.exe | Out-Null
    & test_programs\output\bench_list_ops.exe | Out-Null
    & test_programs\output\bench_channel.exe | Out-Null
    & test_programs\output\bench_spawn.exe | Out-Null
}

Write-Host "=== FINAL BENCHMARKS (after warmup) ==="
$benches = @('bench_channel','bench_spawn','bench_string','bench_dict','bench_list_ops')
foreach ($b in $benches) {
    $times = @()
    for ($i = 0; $i -lt 7; $i++) {
        $t = (Measure-Command { & "test_programs\output\$b.exe" | Out-Null }).TotalMilliseconds
        $times += [math]::Round($t, 1)
    }
    $sorted = $times | Sort-Object
    $median = $sorted[3]
    $best = $sorted[0]
    Write-Host "$b : best=$best median=$median all=($($times -join ', '))"
}
