Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

# NOTE: c_ms are clang -O2 reference times measured 2026-05-22 on this machine.
# For an always-accurate comparison use measure_perf.ps1, which recompiles the
# C reference fresh instead of trusting these hardcoded numbers.
$bench_dir = "..\bench"
$benches = @(
    @{ name="primes_seq"; file="bench_g5_primes_seq.nova"; c_ms=118 },
    @{ name="sieve10m";   file="bench_g5_sieve10m.nova";   c_ms=271 },
    @{ name="matmul";     file="bench_g5_matmul.nova";     c_ms=73 }
)

foreach ($b in $benches) {
    $name = $b.name
    $src = Join-Path $bench_dir $b.file
    $local_nova = "$name.nova"

    if (-not (Test-Path $src)) {
        Write-Host "$name : SKIP (source not found at $src)"
        continue
    }
    Copy-Item $src $local_nova -Force

    # Compile — killed if it hangs.
    $cr = Invoke-Timed -FilePath (Resolve-Path ".\gen1_final_ipt.exe").Path `
                       -Arguments $local_nova -TimeoutMs 30000
    $ll = "$name.ll"
    if ($cr.TimedOut -or (-not (Test-Path $ll))) {
        Write-Host "$name : COMPILE FAILED (timedout=$($cr.TimedOut) exit=$($cr.ExitCode))"
        Remove-Item $local_nova -Force -ErrorAction SilentlyContinue
        continue
    }

    # Link
    $lr = Invoke-Timed -FilePath $ClangPath `
                       -Arguments "-O2 -o $name.exe $ll nova_runtime.c -lws2_32" -TimeoutMs 60000
    if ($lr.TimedOut -or (-not (Test-Path "$name.exe"))) {
        Write-Host "$name : LINK FAILED"
        Remove-Item $ll -Force -ErrorAction SilentlyContinue
        Remove-Item $local_nova -Force -ErrorAction SilentlyContinue
        continue
    }

    # Run 3 times, take best — each run killed if it hangs.
    $best = 999999
    $exe = (Resolve-Path ".\$name.exe").Path
    for ($i = 0; $i -lt 3; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $rr = Invoke-Timed -FilePath $exe -Arguments "" -TimeoutMs 60000
        $sw.Stop()
        if ($rr.TimedOut) { Write-Host "$name : RUN TIMED OUT (killed)"; $best = -1; break }
        $ms = $sw.ElapsedMilliseconds
        if ($ms -lt $best) { $best = $ms }
    }

    if ($best -ge 0) {
        $c_ms = $b.c_ms
        $ratio = [math]::Round($best / $c_ms, 2)
        Write-Host "$name : ${best}ms (C ref: ${c_ms}ms, ratio: ${ratio}x)"
    }

    Remove-Item $ll -Force -ErrorAction SilentlyContinue
    Remove-Item "$name.exe" -Force -ErrorAction SilentlyContinue
    Remove-Item $local_nova -Force -ErrorAction SilentlyContinue
}

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
