Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$bench = "..\bench"
$novaCompiler = (Resolve-Path ".\gen1_final_ipt.exe").Path

$cases = @(
    @{ name = "primes_seq"; nova = "bench_g5_primes_seq.nova"; c = "bench_g5_primes_seq.c" },
    @{ name = "sieve10m";   nova = "bench_g5_sieve10m.nova";   c = "gate5_sieve10m.c" },
    @{ name = "matmul";     nova = "bench_g5_matmul.nova";     c = "gate5_matmul.c" }
)

function BestMs($exe, $runs, $timeoutMs) {
    $best = -1
    for ($i = 0; $i -lt $runs; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $r = Invoke-Timed -FilePath $exe -Arguments "" -TimeoutMs $timeoutMs
        $sw.Stop()
        if ($r.TimedOut) { return -1 }
        $ms = $sw.ElapsedMilliseconds
        if ($best -lt 0 -or $ms -lt $best) { $best = $ms }
    }
    return $best
}

Write-Host ("{0,-12} {1,12} {2,12} {3,9}" -f "benchmark", "C -O2 ms", "NOVA ms", "ratio")
Write-Host ("-" * 48)

foreach ($cs in $cases) {
    $name = $cs.name

    # --- C reference: recompile fresh with clang -O2 ---
    Copy-Item (Join-Path $bench $cs.c) "${name}_ref.c" -Force
    $cMs = -1
    $cl = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o ${name}_c.exe ${name}_ref.c" -TimeoutMs 60000
    if ((-not $cl.TimedOut) -and (Test-Path "${name}_c.exe")) {
        $cMs = BestMs (Resolve-Path ".\${name}_c.exe").Path 5 60000
    }

    # --- NOVA: compile with current production compiler ---
    Copy-Item (Join-Path $bench $cs.nova) "${name}_n.nova" -Force
    $nMs = -1
    $nc = Invoke-Timed -FilePath $novaCompiler -Arguments "${name}_n.nova" -TimeoutMs 60000
    if ((-not $nc.TimedOut) -and (Test-Path "${name}_n.ll")) {
        $nl = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o ${name}_n.exe ${name}_n.ll nova_runtime.c -lws2_32" -TimeoutMs 60000
        if ((-not $nl.TimedOut) -and (Test-Path "${name}_n.exe")) {
            $nMs = BestMs (Resolve-Path ".\${name}_n.exe").Path 5 60000
        }
    }

    $ratio = "n/a"
    if ($cMs -gt 0 -and $nMs -gt 0) {
        $ratio = ([math]::Round($nMs / $cMs, 2)).ToString() + "x"
    }
    Write-Host ("{0,-12} {1,12} {2,12} {3,9}" -f $name, $cMs, $nMs, $ratio)

    Remove-Item "${name}_ref.c", "${name}_c.exe", "${name}_n.nova", "${name}_n.ll", "${name}_n.exe" -Force -ErrorAction SilentlyContinue
}

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
