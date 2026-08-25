# Classify orphan *_test.nova files (not in the curated regression list) into CLEAN / COMPILE_FAIL /
# LINK_FAIL / RUN_FAIL / TIMEOUT, mirroring the proven regression compile+link+run path. CLEAN = the
# criterion for wiring into a coverage gate: compiles, links, runs, exit 0, no crash/assert/panic.
# Usage: powershell -File _classify_orphans.ps1 -ListFile <file-of-test-names> [-Max N] [-OutManifest <file>]
param([string]$ListFile, [int]$Max = 1000, [string]$OutManifest = "_orphan_clean_manifest.txt")
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler   = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
# LIVE runtime, not the output/ copy. That copy was 16 days and 79 KB stale (2026-08-09 vs
# 2026-08-24), so every CLEAN verdict was measured against a runtime missing every fix since --
# and CLEAN is the criterion for wiring a test INTO the gate. A classifier that adopts tests on
# the strength of the wrong runtime is worse than no classifier: it manufactures confidence.
# Only compiler/ is live; see the stale-runtime-copy note in project memory.
$runtimeSrc = "$PSScriptRoot\..\compiler\nova_runtime.c"
$runtimeObj = "$PSScriptRoot\_orphan_rt.o"
$env:NOVA_NO_CACHE = "1"
$clang = "clang"

Write-Host "Pre-compiling runtime -> _orphan_rt.o ..."
# -fms-extensions: the live runtime uses __try/__except for fiber stack-overflow containment and
# does not compile without it on Windows (the same flag nova_link passes).
$rtFlags = "-c -O2 `"$runtimeSrc`" -o `"$runtimeObj`" -D_CRT_SECURE_NO_WARNINGS -w"
if ($env:OS -eq "Windows_NT") { $rtFlags = $rtFlags + " -fms-extensions" }
$rtc = Invoke-Timed -FilePath $clang -Arguments $rtFlags -TimeoutMs 180000 -WorkingDirectory $PSScriptRoot
if (-not (Test-Path $runtimeObj)) { Write-Host "FATAL: runtime precompile failed"; exit 2 }

$names = Get-Content $ListFile | Where-Object { $_.Trim() -ne "" } | Select-Object -First $Max
$clean=@(); $cfail=@(); $lfail=@(); $rfail=@(); $tout=@()
$lflags = "-lws2_32 -lbcrypt -ladvapi32 -lwinhttp -lole32"
$i=0
foreach ($t in $names) {
    $i++
    $ll = "$PSScriptRoot\$t.ll"; $exe = "$PSScriptRoot\$t.exe"
    Remove-Item $ll,$exe -Force -ErrorAction SilentlyContinue
    # compile
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if ($cr.TimedOut) { $tout += $t; Write-Host "[$i] TIMEOUT(compile) $t"; continue }
    if ($cr.ExitCode -ne 0 -or -not (Test-Path $ll)) { $cfail += $t; Write-Host "[$i] COMPILE_FAIL $t"; continue }
    # extra link libs from LINK_LIB markers
    $xlib=""
    Get-Content $ll | Where-Object { $_ -match '^; LINK_LIB: (\S+)' } | ForEach-Object { if (@('m','pthread','dl','rt') -notcontains $matches[1]) { $xlib += " -l$($matches[1])" } }
    # skip tests needing extra C sources/objects (out of this fast batch's scope)
    if ((Select-String -Path $ll -Pattern '^; LINK_(SOURCE|OBJECT):' -Quiet) -or (Select-String -Path $ll -Pattern '@sqlite3_' -Quiet)) { Write-Host "[$i] SKIP(needs-ffi/sqlite) $t"; continue }
    # link
    $lr = Invoke-Timed -FilePath $clang -Arguments "-O2 -o `"$exe`" `"$ll`" `"$runtimeObj`" $lflags$xlib -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if ($lr.TimedOut -or -not (Test-Path $exe)) { $lfail += $t; Write-Host "[$i] LINK_FAIL $t"; continue }
    # run
    $rr = Invoke-Timed -FilePath $exe -Arguments "" -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
    if ($rr.TimedOut) { $tout += $t; Write-Host "[$i] TIMEOUT(run) $t"; continue }
    if ($rr.ExitCode -ne 0) { $rfail += $t; Write-Host "[$i] RUN_FAIL(exit=$($rr.ExitCode)) $t"; continue }
    # NOVA's assert_* helpers print "FAIL assert" to STDERR and DO NOT exit non-zero, so a soft
    # assertion failure leaves exit=0. Must check BOTH streams (the harness checks stderr for
    # 'FAIL assert'). Checking only stdout under-detects failures — that bug initially mis-marked the
    # 8 wasm/glob/gguf/ml_ops tests CLEAN (they emit "FAIL assert_eq ..." to stderr, exit 0).
    if ($rr.Stdout -match 'FAIL|panic:|Assertion|assert.*fail|error\[' -or $rr.Stderr -match 'FAIL assert|panic:|error\[') { $rfail += $t; Write-Host "[$i] RUN_FAIL(assert/output) $t"; continue }
    $clean += $t
    Write-Host "[$i] CLEAN $t"
    Remove-Item $exe -Force -ErrorAction SilentlyContinue
}
Remove-Item $runtimeObj -Force -ErrorAction SilentlyContinue
$clean | Set-Content $OutManifest
Write-Host ""
Write-Host "=== SUMMARY: CLEAN=$($clean.Count) COMPILE_FAIL=$($cfail.Count) LINK_FAIL=$($lfail.Count) RUN_FAIL=$($rfail.Count) TIMEOUT=$($tout.Count) (of $($names.Count)) ==="
Write-Host "clean manifest -> $OutManifest"
if ($cfail.Count) { Write-Host "COMPILE_FAIL: $($cfail -join ', ')" }
if ($lfail.Count) { Write-Host "LINK_FAIL: $($lfail -join ', ')" }
if ($rfail.Count) { Write-Host "RUN_FAIL: $($rfail -join ', ')" }
if ($tout.Count)  { Write-Host "TIMEOUT: $($tout -join ', ')" }
