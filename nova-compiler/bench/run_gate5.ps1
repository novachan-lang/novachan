$root = "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"

function Bench($label, $exe, $runs) {
    $times = @()
    & $exe | Out-Null  # warmup
    for ($i = 0; $i -lt $runs; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        & $exe | Out-Null
        $sw.Stop()
        $times += $sw.ElapsedMilliseconds
    }
    $sorted = $times | Sort-Object
    $trimmed = $sorted[1..($runs-2)]
    $avg = [math]::Round(($trimmed | Measure-Object -Average).Average, 1)
    $best = $sorted[0]
    $med = $sorted[[math]::Floor($runs/2)]
    Write-Host ("{0,-35} best={1,6}ms  med={2,6}ms  avg={3,7}ms" -f $label, $best, $med, $avg)
    return $avg
}

$runs = 10
Write-Host "=================================================================="
Write-Host "  NOVA GATE 5: Real Programs vs C  ($runs runs, trimmed avg)"
Write-Host "=================================================================="
Write-Host ""

# ── G5-1: Matrix multiply 300x300 ─────────────────────────────────────────
Write-Host "--- G5-1: Matrix Multiply 300x300 (27M multiply-adds) ---"
$c  = Bench "C -O2             " "$root\bench\g5_c_matmul_O2.exe" $runs
$n  = Bench "NOVA -O2          " "$root\bench\g5_nova_matmul_O2.exe" $runs
$oh = [math]::Round(($n - $c) / [math]::Max($c,1) * 100, 1)
$status = if ([math]::Abs($oh) -le 10) { "PASS" } else { "REVIEW" }
Write-Host ("  -> Overhead: {0}%  [{1}]" -f $oh, $status)
Write-Host ""

# ── G5-2: Sieve 10M ───────────────────────────────────────────────────────
Write-Host "--- G5-2: Sieve of Eratosthenes 10M (10x scale from GATE 4) ---"
$c  = Bench "C -O2             " "$root\bench\g5_c_sieve10m_O2.exe" $runs
$n  = Bench "NOVA -O2          " "$root\bench\g5_nova_sieve10m_O2.exe" $runs
$oh = [math]::Round(($n - $c) / [math]::Max($c,1) * 100, 1)
$status = if ([math]::Abs($oh) -le 10) { "PASS" } else { "REVIEW" }
Write-Host ("  -> Overhead: {0}%  [{1}]" -f $oh, $status)
Write-Host ""

# ── G5-3: Sequential prime count — NOVA vs C ──────────────────────────────
Write-Host "--- G5-3a: Sequential Prime Count 1-1M (per-thread computation) ---"
$c  = Bench "C seq -O2         " "$root\bench\g5_c_primes_seq_O2.exe" $runs
$ns = Bench "NOVA seq -O2      " "$root\bench\g5_nova_primes_seq_O2.exe" $runs
$oh = [math]::Round(($ns - $c) / [math]::Max($c,1) * 100, 1)
$status = if ([math]::Abs($oh) -le 10) { "PASS" } else { "REVIEW" }
Write-Host ("  -> NOVA seq overhead vs C: {0}%  [{1}]" -f $oh, $status)
Write-Host ""

# ── G5-3b: Parallel vs sequential speedup ─────────────────────────────────
Write-Host "--- G5-3b: Parallel Prime Count (4 workers via spawn+channel) ---"
$np = Bench "NOVA parallel -O2 " "$root\bench\g5_nova_parallel_O2.exe" $runs
$speedup = [math]::Round($ns / [math]::Max($np, 1), 2)
$pstatus = if ($speedup -gt 2.0) { "PASS" } else { "REVIEW" }
Write-Host ("  -> Sequential: {0}ms | Parallel: {1}ms | Speedup: {2}x  [{3}]" -f $ns, $np, $speedup, $pstatus)
Write-Host ""

# ── Final summary ─────────────────────────────────────────────────────────
Write-Host "=================================================================="
Write-Host "  GATE 5 RESULTS"
Write-Host "=================================================================="
Write-Host "  Target: real programs within 10% of C, parallel > 2x speedup"
Write-Host "=================================================================="
