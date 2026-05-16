$root = "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"
$jar = "$root\build\libs\nova-compiler-0.1.0-all.jar"
$rt = "$root\runtime\nova_runtime.c"
$testDir = "$root\nova-compiler\test_programs"
$benchDir = "$root\bench"

Set-Location $root

# Compile NOVA benchmarks to .ll
Write-Host "=== Compiling NOVA benchmarks ==="
java -jar $jar "$testDir\bench_fib.nova" "$benchDir\gate4_nova_fib.ll"
java -jar $jar "$testDir\bench_loop.nova" "$benchDir\gate4_nova_loop.ll"
java -jar $jar "$testDir\bench_sieve.nova" "$benchDir\gate4_nova_sieve.ll"

# Build NOVA exes at -O0 and -O2
Write-Host "=== Building NOVA executables ==="
clang -Wno-deprecated-declarations -O0 -o "$benchDir\gate4_nova_fib_O0.exe" "$benchDir\gate4_nova_fib.ll" $rt
clang -Wno-deprecated-declarations -O2 -o "$benchDir\gate4_nova_fib_O2.exe" "$benchDir\gate4_nova_fib.ll" $rt
clang -Wno-deprecated-declarations -O0 -o "$benchDir\gate4_nova_loop_O0.exe" "$benchDir\gate4_nova_loop.ll" $rt
clang -Wno-deprecated-declarations -O2 -o "$benchDir\gate4_nova_loop_O2.exe" "$benchDir\gate4_nova_loop.ll" $rt
clang -Wno-deprecated-declarations -O0 -o "$benchDir\gate4_nova_sieve_O0.exe" "$benchDir\gate4_nova_sieve.ll" $rt
clang -Wno-deprecated-declarations -O2 -o "$benchDir\gate4_nova_sieve_O2.exe" "$benchDir\gate4_nova_sieve.ll" $rt

# Build C benchmarks at -O0 and -O2
Write-Host "=== Building C benchmarks ==="
clang -Wno-deprecated-declarations -O0 -o "$benchDir\gate4_fib_O0.exe" "$benchDir\gate4_fib.c"
clang -Wno-deprecated-declarations -O2 -o "$benchDir\gate4_fib_O2.exe" "$benchDir\gate4_fib.c"
clang -Wno-deprecated-declarations -O0 -o "$benchDir\gate4_loop_O0.exe" "$benchDir\gate4_loop.c"
clang -Wno-deprecated-declarations -O2 -o "$benchDir\gate4_loop_O2.exe" "$benchDir\gate4_loop.c"
clang -Wno-deprecated-declarations -O0 -o "$benchDir\gate4_sieve_1m_O0.exe" "$benchDir\gate4_sieve_1m.c"
clang -Wno-deprecated-declarations -O2 -o "$benchDir\gate4_sieve_1m_O2.exe" "$benchDir\gate4_sieve_1m.c"
# Fair sieve: same int64_t element size as NOVA
clang -Wno-deprecated-declarations -O0 -o "$benchDir\gate4_sieve_i64_O0.exe" "$benchDir\gate4_sieve_i64.c"
clang -Wno-deprecated-declarations -O2 -o "$benchDir\gate4_sieve_i64_O2.exe" "$benchDir\gate4_sieve_i64.c"

Write-Host "=== All builds complete ==="
