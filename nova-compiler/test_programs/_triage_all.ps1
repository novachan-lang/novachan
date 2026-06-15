$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"
$rtObj = "$dir\_rt_cached.o"

# Verify prerequisites
if (-not (Test-Path $compiler)) { Write-Host "ERROR: gen4_test.exe not found"; exit 1 }
if (-not (Test-Path $rtObj)) { Write-Host "ERROR: _rt_cached.o not found"; exit 1 }

$pass = 0; $compileFail = 0; $linkFail = 0; $runFail = 0; $timeout = 0; $skip = 0
$compileFailures = @(); $linkFailures = @(); $runFailures = @(); $timeouts = @()

# Get all .nova test files (exclude compiler, repl, lsp, leading underscore, and known non-test files)
$skipNames = @(
    'nova_compiler', 'nova_compiler_before_ipt', 'nova_compiler_min', 'nova_compiler_noti',
    'nova_compiler_original', 'nova_compiler_t2', 'nova_compiler_test_call', 'nova_compiler_test_fields',
    'nova_compiler_test_funcs', 'nova_compiler_test_split', 'nova_compiler_test_stdlib',
    'nova_compiler_test_types', 'nova_compiler_trace', 'nova_compiler_with_method_fix',
    'repl', '__lsp_check__',
    'nova_lsp', 'lsp_server', 'lsp_check',
    'forge', 'ai_serve', 'http_mt_demo', 'http_demo', 'http_min_server',
    'node_echo_server', 'ws_echo_server', 'tls_server_test',
    'real_http_api', 'real_kv_server',
    'nova_build', 'nova_pkg', 'nova_doc', 'nova_fmt', 'nova_ir', 'nova_ir_emit',
    'nova_ir_integrated', 'nova_interpreter', 'nova_lexer', 'nova_parser',
    'showcase', 'demo_forge_test', 'demo_forge_todo_test', 'demo_forge_v2_test',
    'demo_frameworks_v2_test', 'demo_full_stack_test', 'demo_http_server_test',
    'demo_mesh_test', 'demo_ops_test', 'demo_prism_test', 'demo_pulse_test',
    'demo_reactor_test', 'demo_sentinel_test', 'demo_sqlite_test', 'demo_cortex_serve_test',
    'demo_edge_test'
)

$files = Get-ChildItem "$dir\*.nova" | Where-Object {
    $_.Name[0] -ne '_' -and $skipNames -notcontains $_.BaseName
} | Sort-Object Name

Write-Host "Running $($files.Count) tests..."
Write-Host ""

$sw = [System.Diagnostics.Stopwatch]::StartNew()

foreach ($f in $files) {
    $name = $f.BaseName
    $ll = "$dir\$name.ll"
    $exe = "$dir\$name.exe"

    # Compile
    Remove-Item $ll -Force -ErrorAction SilentlyContinue
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$name.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps
    $pr.Start() | Out-Null
    $cout = $pr.StandardOutput.ReadToEndAsync()
    $cerr = $pr.StandardError.ReadToEndAsync()
    if (-not $pr.WaitForExit(120000)) {
        $pr.Kill(); $pr.WaitForExit(5000)
        $timeout++; $timeouts += $name
        continue
    }
    [System.Threading.Tasks.Task]::WaitAll($cout, $cerr)
    if ($pr.ExitCode -ne 0 -or -not (Test-Path $ll)) {
        $compileFail++
        $errText = $cerr.Result
        if ($errText.Length -gt 200) { $errText = $errText.Substring(0, 200) }
        $compileFailures += "$name|$($pr.ExitCode)|$errText"
        continue
    }

    # Link
    & clang $ll $rtObj -o $exe -O2 -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
    if (-not (Test-Path $exe)) {
        $linkFail++; $linkFailures += $name
        continue
    }

    # Run
    $rps = New-Object System.Diagnostics.ProcessStartInfo
    $rps.FileName = $exe; $rps.Arguments = ""; $rps.WorkingDirectory = $dir
    $rps.UseShellExecute = $false; $rps.RedirectStandardOutput = $true; $rps.RedirectStandardError = $true; $rps.CreateNoWindow = $true
    $rpr = [System.Diagnostics.Process]::new(); $rpr.StartInfo = $rps
    $rpr.Start() | Out-Null
    $rout = $rpr.StandardOutput.ReadToEndAsync()
    $rerr = $rpr.StandardError.ReadToEndAsync()
    if (-not $rpr.WaitForExit(30000)) {
        $rpr.Kill(); $rpr.WaitForExit(5000)
        $timeout++; $timeouts += "$name(run)"
        continue
    }
    [System.Threading.Tasks.Task]::WaitAll($rout, $rerr)
    if ($rpr.ExitCode -ne 0) {
        $runFail++
        $errText = $rerr.Result
        if ($errText.Length -gt 200) { $errText = $errText.Substring(0, 200) }
        $runFailures += "$name|exit=$($rpr.ExitCode)|$errText"
        continue
    }

    $pass++
}

$elapsed = [math]::Round($sw.Elapsed.TotalSeconds)
Write-Host ""
Write-Host "=== TRIAGE RESULTS ($elapsed seconds) ==="
Write-Host "PASS: $pass"
Write-Host "COMPILE FAIL: $compileFail"
Write-Host "LINK FAIL: $linkFail"
Write-Host "RUN FAIL: $runFail"
Write-Host "TIMEOUT: $timeout"
Write-Host "Total tested: $($pass + $compileFail + $linkFail + $runFail + $timeout)"

if ($compileFailures.Count -gt 0) {
    Write-Host ""
    Write-Host "=== COMPILE FAILURES ==="
    foreach ($cf in $compileFailures) {
        $parts = $cf -split '\|', 3
        Write-Host "  $($parts[0]) (exit=$($parts[1])): $($parts[2])"
    }
}
if ($linkFailures.Count -gt 0) {
    Write-Host ""
    Write-Host "=== LINK FAILURES ==="
    foreach ($lf in $linkFailures) { Write-Host "  $lf" }
}
if ($runFailures.Count -gt 0) {
    Write-Host ""
    Write-Host "=== RUN FAILURES ==="
    foreach ($rf in $runFailures) {
        $parts = $rf -split '\|', 3
        Write-Host "  $($parts[0]) ($($parts[1])): $($parts[2])"
    }
}
if ($timeouts.Count -gt 0) {
    Write-Host ""
    Write-Host "=== TIMEOUTS ==="
    foreach ($to in $timeouts) { Write-Host "  $to" }
}
