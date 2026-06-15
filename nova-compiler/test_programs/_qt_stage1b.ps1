$ErrorActionPreference = "Stop"
$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"

function Invoke-Timed($exe, $argList, $label, $timeout, $wd) {
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $exe; $ps.Arguments = $argList; $ps.WorkingDirectory = $wd
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
    $pr.Start() | Out-Null
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    $stdout = $pr.StandardOutput.ReadToEndAsync()
    $stderr = $pr.StandardError.ReadToEndAsync()
    if (-not $pr.WaitForExit($timeout)) {
        $pr.Kill(); $pr.WaitForExit(5000)
        Write-Host "$label TIMEOUT (killed after $($timeout/1000)s)"
        return @{ exit = -1; time = $sw.Elapsed.TotalSeconds; out = ""; err = "TIMEOUT" }
    }
    [System.Threading.Tasks.Task]::WaitAll($stdout, $stderr)
    return @{ exit = $pr.ExitCode; time = [math]::Round($sw.Elapsed.TotalSeconds); out = $stdout.Result; err = $stderr.Result }
}

Write-Host "=== gen3 -> gen4 ==="
$r = Invoke-Timed "$dir\gen3_test.exe" "nova_compiler.nova" "gen3" 450000 $dir
Write-Host "gen3 $($r.time)s exit=$($r.exit)"
if ($r.exit -ne 0) { Write-Host "gen3 FAILED"; Write-Host $r.err; exit 1 }
& clang -O2 -o "$dir\gen4_test.exe" "$dir\nova_compiler.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
if (-not (Test-Path "$dir\gen4_test.exe")) { Write-Host "clang gen4 failed"; exit 1 }

Write-Host "=== gen4 -> gen5 ==="
$r = Invoke-Timed "$dir\gen4_test.exe" "nova_compiler.nova" "gen4" 450000 $dir
Write-Host "gen4 $($r.time)s exit=$($r.exit)"
if ($r.exit -ne 0) { Write-Host "gen4 FAILED"; Write-Host $r.err; exit 1 }
$g5hash = (Get-FileHash "$dir\nova_compiler.ll" -Algorithm SHA256).Hash
Remove-Item "$dir\gen5.ll" -Force -ErrorAction SilentlyContinue
Rename-Item "$dir\nova_compiler.ll" "gen5.ll" -Force
Write-Host "gen5 SHA: $g5hash"

Write-Host "=== gen5 -> gen6 ==="
& clang -O2 -o "$dir\gen5_test.exe" "$dir\gen5.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
$r = Invoke-Timed "$dir\gen5_test.exe" "nova_compiler.nova" "gen5" 450000 $dir
Write-Host "gen5 $($r.time)s exit=$($r.exit)"
if ($r.exit -ne 0) { Write-Host "gen5 FAILED"; Write-Host $r.err; exit 1 }
$g6hash = (Get-FileHash "$dir\nova_compiler.ll" -Algorithm SHA256).Hash
Write-Host "gen6 SHA: $g6hash"

if ($g5hash -eq $g6hash) {
    Write-Host "CONVERGED"
    Copy-Item "$dir\gen4_test.exe" "$dir\gen4_test_bak.exe" -Force
    Write-Host "Installed gen4_test.exe"
} else {
    Write-Host "DIVERGED - gen5 != gen6"
    exit 1
}

Write-Host ""

# Quick correctness test
$r = Invoke-Timed "$dir\gen4_test.exe" "struct_perf_test.nova" "struct_perf_test" 60000 $dir
if ($r.exit -eq 0) {
    & clang -O2 -o "$dir\struct_perf_test.exe" "$dir\struct_perf_test.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
    $rt = Invoke-Timed "$dir\struct_perf_test.exe" "" "struct_perf_test_run" 10000 $dir
    if ($rt.exit -eq 0) { Write-Host "struct_perf_test : PASS" } else { Write-Host "struct_perf_test : FAIL exit=$($rt.exit)" }
} else {
    Write-Host "struct_perf_test : FAIL exit=$($r.exit)"
}

# Check fmul in _dot_untyped
$r = Invoke-Timed "$dir\gen4_test.exe" "_dot_untyped.nova" "dot_untyped" 60000 $dir
if ($r.exit -eq 0 -and (Test-Path "$dir\_dot_untyped.ll")) {
    $ll = Get-Content "$dir\_dot_untyped.ll" -Raw
    $has_fmul = $ll -match "fmul"
    $has_rtmul = $ll -match "nova_rt_mul"
    Write-Host "STAGE1: _dot_untyped fmul=$has_fmul nova_rt_mul=$has_rtmul"
} else {
    Write-Host "STAGE1: compile failed"
}

# Also check _dot_typed for comparison
$r = Invoke-Timed "$dir\gen4_test.exe" "_dot_typed.nova" "dot_typed" 60000 $dir
if ($r.exit -eq 0 -and (Test-Path "$dir\_dot_typed.ll")) {
    $ll = Get-Content "$dir\_dot_typed.ll" -Raw
    $has_fmul = $ll -match "fmul"
    $has_rtmul = $ll -match "nova_rt_mul"
    Write-Host "STAGE1: _dot_typed fmul=$has_fmul nova_rt_mul=$has_rtmul"
}

# Run detailed IR comparison
Write-Host ""
Write-Host "=== Detailed @dot body ==="
foreach ($test in @("_dot_typed", "_dot_untyped")) {
    Write-Host "---- $test ----"
    if (Test-Path "$dir\$test.ll") {
        $lines = Get-Content "$dir\$test.ll"
        $inDot = $false
        foreach ($l in $lines) {
            if ($l -match '^define .*@dot\(') { $inDot = $true }
            if ($inDot) {
                if ($l -match 'mul|add|fmul|fadd|nova_rt_mul|nova_rt_add|field|getelementptr|load|call|ret') { Write-Host $l }
                if ($l -match '^\}') { $inDot = $false }
            }
        }
    }
    Write-Host ""
}

Write-Host ""
Write-Host "=== bench (GATE 4/5 proxy) ==="
foreach ($bench in @("num_bench", "fib_bench")) {
    $r = Invoke-Timed "$dir\gen4_test.exe" "$bench.nova" "compile_$bench" 60000 $dir
    if ($r.exit -ne 0) { Write-Host "$bench : COMPILE FAIL"; continue }
    & clang -O2 -o "$dir\$bench.exe" "$dir\$bench.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
    $rt = Invoke-Timed "$dir\$bench.exe" "" "${bench}_run" 30000 $dir
    if ($rt.exit -eq 0) { Write-Host "$bench : PASS" } else { Write-Host "$bench : FAIL exit=$($rt.exit)" }
}

Write-Host ""
Write-Host "=== REGRESSION (selfhost) ==="
$pass = 0; $fail = 0
$tests = @("hello_world","fib","sieve","struct_test","list_ops","dict_ops","string_ops","closure_test","pattern_match","error_handling","import_multi_test","module_test","for_range_test","spawn_channel_test","select_test","async_test","chan_buf_test","pmap_test","yield_test","match_result_test","_exhaust_test","_exhaust_userenum","_exhaust_neg_result","_exhaust_neg_option","green_scale_test","dns_offload_test")
foreach ($t in $tests) {
    $r = Invoke-Timed "$dir\gen4_test.exe" "$t.nova" "compile_$t" 120000 $dir
    if ($r.exit -ne 0) { Write-Host "$t : COMPILE FAIL"; $fail++; continue }
    & clang -O2 -o "$dir\$t.exe" "$dir\$t.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
    if (-not (Test-Path "$dir\$t.exe")) { Write-Host "$t : LINK FAIL"; $fail++; continue }
    $rt = Invoke-Timed "$dir\$t.exe" "" "${t}_run" 30000 $dir
    if ($rt.exit -eq 0) { $pass++ } else { Write-Host "$t : FAIL exit=$($rt.exit)"; $fail++ }
}
Write-Host "Regression: $pass PASS, $fail fail"
if ($fail -eq 0) { Write-Host "ALL GREEN" } else { Write-Host "SOME FAILURES" }
