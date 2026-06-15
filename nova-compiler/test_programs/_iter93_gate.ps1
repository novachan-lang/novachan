Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Write-Host "===== iter-93 GATE: NOVA arena builtins (compiler change -> NEW fixpoint expected) ====="
Write-Host "===== STEP 1: reconverge ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_bootstrap_reconverge_slow.ps1"
if (!(Test-Path "$PSScriptRoot\gen3_test.exe")) { Write-Host "GATE ABORT"; exit 1 }
Write-Host ""
Write-Host "===== STEP 2: NORMAL regression (flag OFF) -- 432/0 ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_run_final_regression.ps1" 2>&1 | Select-String -Pattern "RESULTS:|^FAIL "
Write-Host ""
Write-Host "===== STEP 3: FLAG-ON regression (NOVA_T8_FULLRC=1) -- 432/0 ====="
$env:NOVA_T8_FULLRC = "1"
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_run_final_regression.ps1" 2>&1 | Select-String -Pattern "RESULTS:|^FAIL "
Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue
Write-Host ""
Write-Host "===== STEP 4: arena C harness (struct+list+dict cycles, ASAN) ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_arena_harness_run.ps1" 2>&1 | Select-String -Pattern "ARENA"
Write-Host ""
Write-Host "===== STEP 5: NOVA arena DEMO on the RECONVERGED compiler (flat-memory proof + ASAN) ====="
$env:NOVA_NO_CACHE = "1"
$rd = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "_arena_demo.nova" -TimeoutMs 120000
if ($rd.ExitCode -ne 0 -or !(Test-Path _arena_demo.ll)) { Write-Host "  DEMO COMPILE FAIL (exit=$($rd.ExitCode))"; Write-Host $rd.StdErr } else {
  $ld = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o _arena_demo.exe _arena_demo.ll output\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
  $rr = Invoke-Timed -FilePath (Resolve-Path ".\_arena_demo.exe").Path -Arguments "" -TimeoutMs 60000
  Write-Host ("  " + $rr.StdOut.Trim())
  & $ClangPath -fsanitize=address -g -O1 -o _arena_demo_asan.exe _arena_demo.ll output\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w 2>$null | Out-Null
  if (Test-Path _arena_demo_asan.exe) {
    $env:ASAN_OPTIONS = "abort_on_error=0"
    & ".\_arena_demo_asan.exe" 1>_adm_o.txt 2>_adm_e.txt
    $er = Get-Content _adm_e.txt -Raw -ErrorAction SilentlyContinue
    if ($er -and ($er -match "ERROR: AddressSanitizer|heap-use-after-free|attempting double-free|heap-buffer-overflow")) { Write-Host "  DEMO ASAN *** FINDING ***"; Write-Host $er } else { Write-Host "  DEMO ASAN clean" }
  } else { Write-Host "  DEMO ASAN build failed (skipped)" }
  Remove-Item _arena_demo.exe,_arena_demo.ll,_arena_demo_asan.exe,_adm_o.txt,_adm_e.txt -Force -ErrorAction SilentlyContinue
}
Write-Host ""
Write-Host "===== STEP 6: green_scale flag-off + on ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_green_scale_run.ps1" 2>&1 | Select-String -Pattern "GREEN SCALE|exit="
$env:NOVA_T8_FULLRC = "1"
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_green_scale_run.ps1" 2>&1 | Select-String -Pattern "GREEN SCALE|exit="
Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue
Write-Host "===== iter-93 GATE DONE ====="
