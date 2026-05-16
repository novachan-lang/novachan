$root = "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"
$jar = "$root\build\libs\nova-compiler-0.1.0-all.jar"
$testDir = "$root\nova-compiler\test_programs"

$tests = @(
    'showcase_nova',
    'feature_stress_test',
    'power_test',
    'stdlib_math_test',
    'stdlib_string_test',
    'stdlib_list_test',
    'demo_real_program',
    'production_test',
    'mini_lexer_test',
    'selfhost_capability_test',
    'selfhost_stress_test',
    'bench_fib',
    'bench_loop',
    'bench_sieve',
    'memory_stress_test',
    'import_test'
)

$pass = 0; $fail = 0; $total = $tests.Count
Push-Location $root
foreach ($t in $tests) {
    $nova = "$testDir\$t.nova"
    if (-not (Test-Path $nova)) { Write-Host "SKIP  $t (not found)"; continue }

    $outLl = "$root\test_out_$t.ll"
    $outExe = "$root\test_out_$t.exe"

    # Clean previous
    if (Test-Path $outLl) { Remove-Item $outLl }
    if (Test-Path $outExe) { Remove-Item $outExe }

    # Compile NOVA -> .ll -> .exe (compiler resolves imports automatically)
    $allArgs = @("-jar", $jar, $nova, $outLl)
    $compileOut = & java @allArgs 2>&1 | Out-String
    if (-not (Test-Path $outExe)) {
        # Maybe the compiler wrote the exe next to the .ll
        # Or failed entirely
        Write-Host "FAIL  $t (compile): $compileOut"
        $fail++
        continue
    }

    # Run
    try {
        $proc = Start-Process -FilePath $outExe -NoNewWindow -Wait -PassThru -RedirectStandardOutput "$root\test_stdout_$t.txt" -RedirectStandardError "$root\test_stderr_$t.txt"
        if ($proc.ExitCode -ne 0) {
            Write-Host "FAIL  $t (run, exit=$($proc.ExitCode))"
            $fail++
            continue
        }
    } catch {
        Write-Host "FAIL  $t (run exception: $_)"
        $fail++
        continue
    }

    Write-Host "PASS  $t"
    $pass++
}
Pop-Location
Write-Host ""
Write-Host "Results: $pass/$total passed, $fail failed"
