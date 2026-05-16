$root = "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"
$jar = "$root\build\libs\nova-compiler-0.1.0-all.jar"
$rt = "$root\runtime\nova_runtime.c"

$files = @(
    @{nova="bench_g5_primes_seq.nova"; ll="g5_nova_primes_seq.ll"; exe="g5_nova_primes_seq_O2.exe"},
    @{nova="bench_g5_matmul.nova"; ll="g5_nova_matmul.ll"; exe="g5_nova_matmul_O2.exe"},
    @{nova="bench_g5_parallel.nova"; ll="g5_nova_parallel.ll"; exe="g5_nova_parallel_O2.exe"},
    @{nova="bench_g5_sieve10m.nova"; ll="g5_nova_sieve10m.ll"; exe="g5_nova_sieve10m_O2.exe"}
)

foreach ($f in $files) {
    $src = "$root\bench\$($f.nova)"
    $out = "$root\bench\$($f.ll)"
    $exe = "$root\bench\$($f.exe)"

    Write-Host "Compiling $($f.nova)..."
    $result = & java -jar $jar $src $out 2>&1
    if ($LASTEXITCODE -ne 0) { Write-Host "  NOVA compile FAIL: $result"; continue }

    $clangOut = & clang -O2 -o $exe $out $rt 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  -> $($f.exe): OK"
        # Quick sanity check
        $check = & $exe 2>&1
        Write-Host "  -> Output: $check"
    } else {
        Write-Host "  -> clang FAIL: $clangOut"
    }
}
