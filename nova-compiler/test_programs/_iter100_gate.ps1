Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Write-Host "===== iter-100 GATE: arena correctness fix (nova_arena_new_chunk tracks bounds; runtime-only -> expect D8A18723) ====="
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
Write-Host "===== STEP 4: arena C harness (ASAN) ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_arena_harness_run.ps1" 2>&1 | Select-String -Pattern "ARENA"
Write-Host ""
Write-Host "===== STEP 5: NOVA arena tests on reconverged compiler (CONTENT-correctness + flat + ASAN) ====="
$env:NOVA_NO_CACHE = "1"
foreach ($t in @("_forge_router_test","_arena_demo","_arena_green_probe")) {
  $rc = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "$t.nova" -TimeoutMs 120000
  if ($rc.ExitCode -ne 0 -or !(Test-Path "$t.ll")) { Write-Host "  $t COMPILE FAIL"; continue }
  $null = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o ${t}.exe $t.ll output\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
  $rr = Invoke-Timed -FilePath (Resolve-Path ".\${t}.exe").Path -Arguments "" -TimeoutMs 90000
  Write-Host ("  [" + $t + "] exit=$($rr.ExitCode): " + ($rr.StdOut.Trim() -replace "`r?`n","  |  "))
  & $ClangPath -fsanitize=address -g -O1 -o ${t}_a.exe $t.ll output\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w 2>$null | Out-Null
  if (Test-Path "${t}_a.exe") {
    $env:ASAN_OPTIONS="abort_on_error=0"
    & ".\${t}_a.exe" 1>"${t}_o.txt" 2>"${t}_e.txt"
    $er = Get-Content "${t}_e.txt" -Raw -ErrorAction SilentlyContinue
    if ($er -and ($er -match "ERROR: AddressSanitizer|heap-use-after-free|attempting double-free")) { Write-Host "    [$t] ASAN *** FINDING ***" } else { Write-Host "    [$t] ASAN clean" }
  }
  Remove-Item "${t}.exe","$t.ll","${t}_a.exe","${t}_o.txt","${t}_e.txt" -Force -ErrorAction SilentlyContinue
}
Write-Host ""
Write-Host "===== STEP 6: green_scale flag-off + on ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_green_scale_run.ps1" 2>&1 | Select-String -Pattern "GREEN SCALE|exit="
$env:NOVA_T8_FULLRC="1"
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_green_scale_run.ps1" 2>&1 | Select-String -Pattern "GREEN SCALE|exit="
Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue
Write-Host "===== iter-100 GATE DONE ====="
