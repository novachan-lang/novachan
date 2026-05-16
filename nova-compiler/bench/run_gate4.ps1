$root = "C:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"

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
    Write-Host ("{0,-30} best={1,7}ms  avg={2,7}ms  runs={3}" -f $label, $best, $avg, ($times -join ","))
    return $best
}

Write-Host "============================================="
Write-Host "  NOVA GATE 4: Performance Validation"
Write-Host "============================================="
Write-Host ""

$runs = 3

Write-Host "--- BENCHMARK 1: fib(40) - Recursive function calls ---"
$c_fib_o0 = Bench "C -O0" "$root\bench\gate4_fib_O0.exe" $runs
$c_fib_o2 = Bench "C -O2" "$root\bench\gate4_fib_O2.exe" $runs
$n_fib_o0 = Bench "NOVA -O0" "$root\bench\gate4_nova_fib_O0.exe" $runs
$n_fib_o2 = Bench "NOVA -O2 (LLVM opts)" "$root\bench\gate4_nova_fib_O2.exe" $runs
$overhead_fib = [math]::Round(($n_fib_o0 - $c_fib_o0) / [math]::Max($c_fib_o0, 1) * 100, 1)
$overhead_fib_o2 = [math]::Round(($n_fib_o2 - $c_fib_o2) / [math]::Max($c_fib_o2, 1) * 100, 1)
Write-Host "  -> NOVA vs C (-O0): $overhead_fib% overhead"
Write-Host "  -> NOVA vs C (-O2): $overhead_fib_o2% overhead"
Write-Host ""

Write-Host "--- BENCHMARK 2: sum_to(1B) - Tight loop accumulation ---"
$c_loop_o0 = Bench "C -O0" "$root\bench\gate4_loop_O0.exe" $runs
$c_loop_o2 = Bench "C -O2" "$root\bench\gate4_loop_O2.exe" $runs
$n_loop_o0 = Bench "NOVA -O0" "$root\bench\gate4_nova_loop_O0.exe" $runs
$n_loop_o2 = Bench "NOVA -O2 (LLVM opts)" "$root\bench\gate4_nova_loop_O2.exe" $runs
$overhead_loop = [math]::Round(($n_loop_o0 - $c_loop_o0) / [math]::Max($c_loop_o0, 1) * 100, 1)
$overhead_loop_o2 = [math]::Round(($n_loop_o2 - $c_loop_o2) / [math]::Max($c_loop_o2, 1) * 100, 1)
Write-Host "  -> NOVA vs C (-O0): $overhead_loop% overhead"
Write-Host "  -> NOVA vs C (-O2): $overhead_loop_o2% overhead"
Write-Host ""

Write-Host "--- BENCHMARK 3: sieve(1M) - Array-heavy computation ---"
$c_sieve_o0 = Bench "C -O0" "$root\bench\gate4_sieve_1m_O0.exe" $runs
$c_sieve_o2 = Bench "C -O2" "$root\bench\gate4_sieve_1m_O2.exe" $runs
$n_sieve_o0 = Bench "NOVA -O0" "$root\bench\gate4_nova_sieve_O0.exe" $runs
$n_sieve_o2 = Bench "NOVA -O2 (LLVM opts)" "$root\bench\gate4_nova_sieve_O2.exe" $runs
$overhead_sieve = [math]::Round(($n_sieve_o0 - $c_sieve_o0) / [math]::Max($c_sieve_o0, 1) * 100, 1)
$overhead_sieve_o2 = [math]::Round(($n_sieve_o2 - $c_sieve_o2) / [math]::Max($c_sieve_o2, 1) * 100, 1)
Write-Host "  -> NOVA vs C (-O0): $overhead_sieve% overhead"
Write-Host "  -> NOVA vs C (-O2): $overhead_sieve_o2% overhead"
Write-Host ""

Write-Host "============================================="
Write-Host "  GATE 4 SUMMARY"
Write-Host "============================================="
Write-Host "  Target: within 5% of C for pure computation"
Write-Host ""
Write-Host "  fib(40)    -O0: $overhead_fib%   -O2: $overhead_fib_o2%"
Write-Host "  sum_to(1B) -O0: $overhead_loop%   -O2: $overhead_loop_o2%"
Write-Host "  sieve(1M)  -O0: $overhead_sieve%   -O2: $overhead_sieve_o2%"
Write-Host "============================================="
