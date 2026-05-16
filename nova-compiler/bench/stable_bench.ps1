$root = "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"

function Bench($label, $exe, $runs) {
    $times = @()
    for ($i = 0; $i -lt $runs; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        & $exe | Out-Null
        $sw.Stop()
        $times += $sw.ElapsedMilliseconds
    }
    $best = ($times | Measure-Object -Minimum).Minimum
    $avg = [math]::Round(($times | Measure-Object -Average).Average, 1)
    $median = ($times | Sort-Object)[[math]::Floor($runs / 2)]
    Write-Host ("{0,-30} best={1,7}ms  median={2,7}ms  avg={3,7}ms" -f $label, $best, $median, $avg)
    return $median
}

$runs = 7

Write-Host "============================================="
Write-Host "  NOVA GATE 4: Final Benchmark (7 runs, median)"
Write-Host "============================================="
Write-Host ""

Write-Host "--- fib(40) ---"
$c = Bench "C -O0" "$root\bench\gate4_fib_O0.exe" $runs
$n = Bench "NOVA -O0" "$root\bench\gate4_nova_fib_O0.exe" $runs
$o = [math]::Round(($n - $c) / [math]::Max($c, 1) * 100, 1)
Write-Host "  -> -O0 overhead: $o%"

$c2 = Bench "C -O2" "$root\bench\gate4_fib_O2.exe" $runs
$n2 = Bench "NOVA -O2" "$root\bench\gate4_nova_fib_O2.exe" $runs
$o2 = [math]::Round(($n2 - $c2) / [math]::Max($c2, 1) * 100, 1)
Write-Host "  -> -O2 overhead: $o2%"
Write-Host ""

Write-Host "--- sum_to(1B) ---"
$c = Bench "C -O0" "$root\bench\gate4_loop_O0.exe" $runs
$n = Bench "NOVA -O0" "$root\bench\gate4_nova_loop_O0.exe" $runs
$o = [math]::Round(($n - $c) / [math]::Max($c, 1) * 100, 1)
Write-Host "  -> -O0 overhead: $o%"

$c2 = Bench "C -O2" "$root\bench\gate4_loop_O2.exe" $runs
$n2 = Bench "NOVA -O2" "$root\bench\gate4_nova_loop_O2.exe" $runs
$o2 = [math]::Round(($n2 - $c2) / [math]::Max($c2, 1) * 100, 1)
Write-Host "  -> -O2 overhead: $o2%"
Write-Host ""

Write-Host "--- sieve(1M) - char* (C advantage: 1B/elem) ---"
$c = Bench "C char* -O0" "$root\bench\gate4_sieve_1m_O0.exe" $runs
$n = Bench "NOVA -O0" "$root\bench\gate4_nova_sieve_O0.exe" $runs
$o = [math]::Round(($n - $c) / [math]::Max($c, 1) * 100, 1)
Write-Host "  -> -O0 overhead: $o%"

$c2 = Bench "C char* -O2" "$root\bench\gate4_sieve_1m_O2.exe" $runs
$n2 = Bench "NOVA -O2" "$root\bench\gate4_nova_sieve_O2.exe" $runs
$o2 = [math]::Round(($n2 - $c2) / [math]::Max($c2, 1) * 100, 1)
Write-Host "  -> -O2 overhead vs char*: $o2%"
Write-Host ""

Write-Host "--- sieve(1M) - FAIR: int64_t* (same element size) ---"
$c = Bench "C int64* -O0" "$root\bench\gate4_sieve_i64_O0.exe" $runs
$n = Bench "NOVA -O0" "$root\bench\gate4_nova_sieve_O0.exe" $runs
$o = [math]::Round(($n - $c) / [math]::Max($c, 1) * 100, 1)
Write-Host "  -> -O0 overhead: $o%"

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
