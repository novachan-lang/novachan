Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== Track 7 Build & Test ==="

# Step 1: Compile nova_compiler.nova -> nova_compiler.ll using gen2_move.exe
# (nova_compiler.nova is ~10800 lines - needs up to 8 minutes)
Write-Host "`n[1/5] Compiling nova_compiler.nova -> nova_compiler.ll (may take several minutes)"
$r1 = Invoke-Timed -FilePath ".\gen2_move.exe" -Arguments "nova_compiler.nova" -TimeoutMs 480000
if ($r1.TimedOut) { Write-Host "TIMEOUT compiling nova_compiler.nova"; exit 1 }
if ($r1.ExitCode -ne 0) {
    Write-Host "COMPILE FAILED (exit $($r1.ExitCode))"
    Write-Host $r1.StdErr
    exit 1
}
if (!(Test-Path "nova_compiler.ll")) { Write-Host "No nova_compiler.ll produced"; exit 1 }
Write-Host "  OK (ll size: $((Get-Item nova_compiler.ll).Length))"

# Step 2: Link -> gen3_track7.exe
Write-Host "`n[2/5] Linking nova_compiler.ll -> gen3_track7.exe"
$linkArgs = "nova_compiler.ll output\nova_runtime.c -o gen3_track7.exe -O2 $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
$r2 = Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 120000
if ($r2.TimedOut -or !(Test-Path "gen3_track7.exe")) {
    Write-Host "LINK FAILED"
    $r2.StdErr -split "`n" | Where-Object { $_ -match 'error:' } | ForEach-Object { Write-Host "  $_" }
    exit 1
}
Write-Host "  OK (size: $((Get-Item gen3_track7.exe).Length))"

# Step 3: Sanity check - gen3_track7 compiles a simple file
Write-Host "`n[3/5] Sanity: gen3_track7 compiles tiny.nova"
$r3 = Invoke-Timed -FilePath ".\gen3_track7.exe" -Arguments "tiny.nova" -TimeoutMs 60000
if ($r3.TimedOut) { Write-Host "TIMEOUT on sanity compile"; exit 1 }
if ($r3.ExitCode -ne 0) {
    Write-Host "Sanity compile FAILED"
    Write-Host $r3.StdErr
    exit 1
}
Write-Host "  OK"

# Step 4: Compile and run Track 7 collection tests
Write-Host "`n[4/5] track7_collections_test"
$rc = Invoke-Timed -FilePath ".\gen3_track7.exe" -Arguments "track7_collections_test.nova" -TimeoutMs 60000
if ($rc.TimedOut -or $rc.ExitCode -ne 0) {
    Write-Host "  COMPILE FAILED (exit=$($rc.ExitCode))"
    Write-Host "  $($rc.StdOut)"
    Write-Host "  $($rc.StdErr)"
    exit 1
}
$rl = Invoke-Timed -FilePath $ClangPath -Arguments "track7_collections_test.ll output\nova_runtime.c -o track7_coll.exe -O2 $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000
if (!(Test-Path "track7_coll.exe")) {
    Write-Host "  LINK FAILED"
    $rl.StdErr -split "`n" | Where-Object { $_ -match 'error:' } | ForEach-Object { Write-Host "  $_" }
    exit 1
}
$rr = Invoke-Timed -FilePath (Resolve-Path ".\track7_coll.exe").Path -TimeoutMs 15000
Write-Host "  OUT: $($rr.StdOut.Trim())"
if ($rr.ExitCode -ne 0) { Write-Host "  TEST FAILED (exit $($rr.ExitCode)) err=$($rr.StdErr)"; exit 1 }
Write-Host "  PASS"
Remove-Item "track7_coll.exe","track7_collections_test.ll" -Force -ErrorAction SilentlyContinue

# Step 5: Compile and run Track 7 log tests
Write-Host "`n[5/5] track7_log_test"
$rc2 = Invoke-Timed -FilePath ".\gen3_track7.exe" -Arguments "track7_log_test.nova" -TimeoutMs 60000
if ($rc2.TimedOut -or $rc2.ExitCode -ne 0) {
    Write-Host "  COMPILE FAILED (exit=$($rc2.ExitCode))"
    Write-Host "  $($rc2.StdOut)"
    Write-Host "  $($rc2.StdErr)"
    exit 1
}
$rl2 = Invoke-Timed -FilePath $ClangPath -Arguments "track7_log_test.ll output\nova_runtime.c -o track7_log.exe -O2 $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000
if (!(Test-Path "track7_log.exe")) {
    Write-Host "  LINK FAILED"
    $rl2.StdErr -split "`n" | Where-Object { $_ -match 'error:' } | ForEach-Object { Write-Host "  $_" }
    exit 1
}
$rr2 = Invoke-Timed -FilePath (Resolve-Path ".\track7_log.exe").Path -TimeoutMs 15000
Write-Host "  OUT: $($rr2.StdOut.Trim())"
if ($rr2.ExitCode -ne 0) { Write-Host "  TEST FAILED (exit $($rr2.ExitCode)) err=$($rr2.StdErr)"; exit 1 }
Write-Host "  PASS"
Remove-Item "track7_log.exe","track7_log_test.ll" -Force -ErrorAction SilentlyContinue

Write-Host "`n=== Track 7 COMPLETE ==="
