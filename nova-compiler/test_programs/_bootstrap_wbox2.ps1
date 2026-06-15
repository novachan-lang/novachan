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
if ($r.exit -ne 0) { Write-Host "gen3 FAILED"; Write-Host $r.err.Substring(0, [Math]::Min(500, $r.err.Length)); exit 1 }
& clang -O2 -o "$dir\gen4_test.exe" "$dir\nova_compiler.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
if (-not (Test-Path "$dir\gen4_test.exe")) { Write-Host "clang gen4 failed"; exit 1 }

Write-Host "=== gen4 -> gen5 ==="
$r = Invoke-Timed "$dir\gen4_test.exe" "nova_compiler.nova" "gen4" 450000 $dir
Write-Host "gen4 $($r.time)s exit=$($r.exit)"
if ($r.exit -ne 0) { Write-Host "gen4 FAILED"; Write-Host $r.err.Substring(0, [Math]::Min(500, $r.err.Length)); exit 1 }
$g5hash = (Get-FileHash "$dir\nova_compiler.ll" -Algorithm SHA256).Hash
Remove-Item "$dir\gen5.ll" -Force -ErrorAction SilentlyContinue
Rename-Item "$dir\nova_compiler.ll" "gen5.ll" -Force
Write-Host "gen5 SHA: $g5hash"

Write-Host "=== gen5 -> gen6 ==="
& clang -O2 -o "$dir\gen5_test.exe" "$dir\gen5.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
$r = Invoke-Timed "$dir\gen5_test.exe" "nova_compiler.nova" "gen5" 450000 $dir
Write-Host "gen5 $($r.time)s exit=$($r.exit)"
if ($r.exit -ne 0) { Write-Host "gen5 FAILED"; Write-Host $r.err.Substring(0, [Math]::Min(500, $r.err.Length)); exit 1 }
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
Write-Host "=== TARGET TESTS ==="
$tests = @("mathfx", "simdx", "embedx", "geox")
foreach ($t in $tests) {
    $r = Invoke-Timed "$dir\gen4_test.exe" "$t.nova" "compile_$t" 60000 $dir
    if ($r.exit -ne 0) { Write-Host "$t : COMPILE FAIL"; continue }
    & clang -O2 -o "$dir\$t.exe" "$dir\$t.ll" "$dir\_rt_cached.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
    if (-not (Test-Path "$dir\$t.exe")) { Write-Host "$t : LINK FAIL"; continue }
    $rt = Invoke-Timed "$dir\$t.exe" "" "${t}_run" 15000 $dir
    if ($rt.exit -eq 0) { Write-Host "$t : PASS" } else {
        Write-Host "$t : FAIL exit=$($rt.exit)"
        if ($rt.err.Length -gt 0) { Write-Host "  ERR: $($rt.err.Substring(0, [Math]::Min(300, $rt.err.Length)))" }
    }
}

Write-Host ""
Write-Host "=== CORE REGRESSION ==="
$pass = 0; $fail = 0; $failures = @()
$core = @(
    "fib","num_bench","fib_bench",
    "selfhost_test1","selfhost_test2","selfhost_test3","selfhost_test4","selfhost_test5",
    "selfhost_test6","selfhost_test7","selfhost_test8","selfhost_test9","selfhost_testA",
    "selfhost_testB","selfhost_testC","selfhost_testD","selfhost_testE","selfhost_testF",
    "selfhost_testG","selfhost_testH","selfhost_testI","selfhost_testK","selfhost_testL",
    "selfhost_testP",
    "selfhost_tiny","selfhost_tiny2","selfhost_tiny3","selfhost_tiny4","selfhost_tiny5",
    "selfhost_tiny9","selfhost_tinyD","selfhost_tinyE","selfhost_tinyH",
    "match_result_test","closure_test",
    "spawn_test","select_test","monitor_test","fiber_test",
    "struct_perf_test","float_test","dict_test","string_test","match_test","range_test",
    "math_test","floatmath_test","float_list_ops_test"
)
foreach ($t in $core) {
    if (-not (Test-Path "$dir\$t.nova")) { continue }
    $r = Invoke-Timed "$dir\gen4_test.exe" "$t.nova" "compile_$t" 120000 $dir
    if ($r.exit -ne 0) { $fail++; $failures += "$t(COMPILE)"; continue }
    & clang -O2 -o "$dir\$t.exe" "$dir\$t.ll" "$dir\_rt_cached.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
    if (-not (Test-Path "$dir\$t.exe")) { $fail++; $failures += "$t(LINK)"; continue }
    $rt = Invoke-Timed "$dir\$t.exe" "" "${t}_run" 30000 $dir
    if ($rt.exit -eq 0) { $pass++ } else { $fail++; $failures += "$t(exit=$($rt.exit))" }
}
Write-Host "Core: $pass PASS, $fail FAIL"
if ($failures.Count -gt 0) { foreach ($f in $failures) { Write-Host "  FAIL: $f" } }
