$root = "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"

function Bench($label, $exe, $runs) {
    $times = @()
    # Warmup run (not counted)
    & $exe | Out-Null
    for ($i = 0; $i -lt $runs; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        & $exe | Out-Null
        $sw.Stop()
        $times += $sw.ElapsedMilliseconds
    }
    $sorted = $times | Sort-Object
    # Drop best and worst (trimmed median)
    $trimmed = $sorted[1..($runs-2)]
    $best = $sorted[0]
    $median = $sorted[[math]::Floor($runs / 2)]
    $avg = [math]::Round(($trimmed | Measure-Object -Average).Average, 1)
    Write-Host ("{0,-30} best={1,7}ms  median={2,7}ms  trimmed_avg={3,7}ms" -f $label, $best, $median, $avg)
    return $avg  # Use trimmed average for more stability
}

$runs = 15

Write-Host "============================================="
Write-Host "  NOVA GATE 4: Robust Benchmark ($runs runs, trimmed avg)"
Write-Host "============================================="
Write-Host ""

Write-Host "--- fib(40) ---"
$c2 = Bench "C -O2" "$root\bench\gate4_fib_O2.exe" $runs
$n2 = Bench "NOVA -O2" "$root\bench\gate4_nova_fib_O2.exe" $runs
$o2 = [math]::Round(($n2 - $c2) / [math]::Max($c2, 1) * 100, 1)
Write-Host "  -> -O2 overhead: $o2%"
Write-Host ""

Write-Host "--- sum_to(1B) ---"
$c2 = Bench "C -O2" "$root\bench\gate4_loop_O2.exe" $runs
$n2 = Bench "NOVA -O2" "$root\bench\gate4_nova_loop_O2.exe" $runs
$o2 = [math]::Round(($n2 - $c2) / [math]::Max($c2, 1) * 100, 1)
Write-Host "  -> -O2 overhead: $o2%"
Write-Host ""

Write-Host "--- sieve(1M) - FAIR: int64_t* (same element size) ---"
$c2 = Bench "C int64* -O2" "$root\bench\gate4_sieve_i64_O2.exe" $runs
$n2 = Bench "NOVA -O2" "$root\bench\gate4_nova_sieve_O2.exe" $runs
$o2 = [math]::Round(($n2 - $c2) / [math]::Max($c2, 1) * 100, 1)
Write-Host "  -> -O2 overhead vs int64*: $o2%"
Write-Host ""

Write-Host "============================================="
Write-Host "  GATE 4 FINAL RESULTS"
Write-Host "============================================="
Write-Host "  Target: within 5% of C for pure computation"
Write-Host "============================================="
