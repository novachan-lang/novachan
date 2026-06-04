Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtimeSrc = "$PSScriptRoot\output\nova_runtime.c"

$env:NOVA_T8_DROP = "1"

$tests = @(
    'demo_sqlite_test','demo_http_server_test','demo_forge_test','demo_forge_v2_test',
    'demo_forge_todo_test','demo_cortex_serve_test','demo_pulse_test','demo_mesh_test',
    'demo_sentinel_test','demo_ops_test','demo_reactor_test','demo_prism_test',
    'demo_edge_test','demo_full_stack_test','demo_frameworks_v2_test',
    'track7_encoding_test','track7_logging_test','track7_random_test',
    'track7_datetime_test','track7_path_test','track7_collections_lib_test',
    'spawn_test','close_test','rc_phase2_test','dict_iter_test',
    'yield_test','supervisor_test','udp_test','read_bytes_test','gpu_vadd_test'
)

$pass = 0; $fail = 0; $skip = 0; $failures = @()

Write-Host "=== W5b DEMOS+MODULES (NOVA_T8_DROP=1) ==="

foreach ($t in $tests) {
    $nova = "$PSScriptRoot\$t.nova"
    $ll   = "$PSScriptRoot\$t.ll"
    $exe  = "$PSScriptRoot\$t.exe"

    if (!(Test-Path $nova)) { $skip++; continue }

    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if ($cr.TimedOut -or $cr.ExitCode -ne 0) {
        Write-Host "FAIL compile: $t"
        $failures += "$t (COMPILE)"
        $fail++; continue
    }
    if (!(Test-Path $ll)) { $skip++; continue }

    $extraLibs = ""
    $skipLibs = @('m','pthread','dl','rt')
    Get-Content $ll | Where-Object { $_ -match '^; LINK_LIB: (\S+)' } | ForEach-Object {
        $libName = $matches[1]
        if ($skipLibs -notcontains $libName) { $extraLibs += " -l$libName" }
    }
    $extraSrc = ""
    if (Select-String -Path $ll -Pattern '@sqlite3_' -Quiet) {
        $sqliteSrc = "$PSScriptRoot\output\sqlite3.c"
        if (Test-Path $sqliteSrc) { $extraSrc = " `"$sqliteSrc`" -DSQLITE_THREADSAFE=0" }
    }

    $linkArgs = "-O2 -o `"$exe`" `"$ll`" `"$runtimeSrc`"$extraSrc $NovaLinkFlags$extraLibs -D_CRT_SECURE_NO_WARNINGS -w"
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path $exe)) {
        Write-Host "FAIL link: $t"
        $failures += "$t (LINK)"
        $fail++; Remove-Item $ll -Force -ErrorAction SilentlyContinue; continue
    }

    $rr = Invoke-Timed -FilePath $exe -Arguments '' -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
    Remove-Item $exe,$ll -Force -ErrorAction SilentlyContinue

    if ($rr.TimedOut) { Write-Host "FAIL timeout: $t"; $failures += "$t (TIMEOUT)"; $fail++ }
    elseif ($rr.ExitCode -ne 0) { Write-Host "FAIL run: $t (exit=$($rr.ExitCode))"; $failures += "$t (RUN)"; $fail++ }
    else { Write-Host "PASS $t"; $pass++ }
}

$env:NOVA_T8_DROP = ""
Write-Host "`n=== W5b DEMOS: $pass PASS, $fail FAIL, $skip SKIP ==="
if ($failures.Count -gt 0) { Write-Host "Failures:"; foreach ($f in $failures) { Write-Host "  $f" } }
