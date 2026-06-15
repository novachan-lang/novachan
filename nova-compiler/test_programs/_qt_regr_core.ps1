$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"
$rtObj = "$dir\_rt_cached.o"
$pass = 0; $fail = 0; $failures = @()

function Run-Test($name) {
    $ll = "$dir\$name.ll"
    Remove-Item $ll -Force -ErrorAction SilentlyContinue
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$name.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
    $pr.Start() | Out-Null
    $pr.StandardOutput.ReadToEnd() | Out-Null
    $pr.StandardError.ReadToEnd() | Out-Null
    if (-not $pr.WaitForExit(120000)) { $pr.Kill(); return "TIMEOUT" }
    if ($pr.ExitCode -ne 0) { return "COMPILE(exit=$($pr.ExitCode))" }
    if (-not (Test-Path $ll)) { return "NO_LL" }
    & clang $ll $rtObj -o "$dir\$name.exe" -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
    if (-not (Test-Path "$dir\$name.exe")) { return "LINK" }
    $rps = New-Object System.Diagnostics.ProcessStartInfo
    $rps.FileName = "$dir\$name.exe"; $rps.Arguments = ""; $rps.WorkingDirectory = $dir
    $rps.UseShellExecute = $false; $rps.RedirectStandardOutput = $true; $rps.RedirectStandardError = $true; $rps.CreateNoWindow = $true
    $rpr = [System.Diagnostics.Process]::new(); $rpr.StartInfo = $rps
    $rpr.Start() | Out-Null
    $rpr.StandardOutput.ReadToEnd() | Out-Null
    $rpr.StandardError.ReadToEnd() | Out-Null
    if (-not $rpr.WaitForExit(30000)) { $rpr.Kill(); return "RUN_TIMEOUT" }
    if ($rpr.ExitCode -ne 0) { return "FAIL(exit=$($rpr.ExitCode))" }
    return "PASS"
}

$tests = @(
    "fib","num_bench","fib_bench",
    "selfhost_test1","selfhost_test2","selfhost_test3","selfhost_test4","selfhost_test5",
    "selfhost_test6","selfhost_test7","selfhost_test8","selfhost_test9","selfhost_testA",
    "selfhost_testB","selfhost_testC","selfhost_testD","selfhost_testE","selfhost_testF",
    "selfhost_testG","selfhost_testH","selfhost_testI","selfhost_testK","selfhost_testL",
    "selfhost_testP",
    "selfhost_tiny","selfhost_tiny2","selfhost_tiny3","selfhost_tiny4","selfhost_tiny5",
    "selfhost_tiny9","selfhost_tinyD","selfhost_tinyE","selfhost_tinyH",
    "match_result_test","_exhaust_test","_exhaust_userenum",
    "spawn_test","select_test","monitor_test","fiber_test","closure_test",
    "struct_perf_test","_dot_untyped","_dot_typed",
    "float_test","dict_test","string_test","match_test","range_test"
)

foreach ($t in $tests) {
    if (-not (Test-Path "$dir\$t.nova")) { continue }
    $result = Run-Test $t
    if ($result -eq "PASS") { $pass++ } else { $fail++; $failures += "$t ($result)" }
}

Write-Host ""
Write-Host "Core regression: $pass PASS, $fail FAIL"
if ($failures.Count -gt 0) {
    Write-Host "Failures:"
    foreach ($f in $failures) { Write-Host "  $f" }
}
