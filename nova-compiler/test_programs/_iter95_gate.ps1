Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
Write-Host "===== iter-95 GATE: serve_n_arena + flat-memory server proof (forge.nova additive; NO reconverge) ====="
Write-Host "===== STEP 1: regression flag-OFF (confirm forge.nova additions break nothing) -- 432/0 ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_run_final_regression.ps1" 2>&1 | Select-String -Pattern "RESULTS:|^FAIL "
Write-Host ""
Write-Host "===== STEP 2: ARENA forge readiness x3 (determinism: delta must stay ~0) ====="
foreach ($k in 1,2,3) {
  $rc = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "_forge_arena_readiness.nova" -TimeoutMs 120000
  if ($rc.ExitCode -ne 0 -or !(Test-Path _forge_arena_readiness.ll)) { Write-Host "  run $k COMPILE FAIL"; continue }
  $null = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o _fa.exe _forge_arena_readiness.ll output\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
  $rr = Invoke-Timed -FilePath (Resolve-Path ".\_fa.exe").Path -Arguments "" -TimeoutMs 90000
  Write-Host ("  run " + $k + ": " + $rr.StdOut.Trim() + " (exit=$($rr.ExitCode))")
  Remove-Item _fa.exe -Force -ErrorAction SilentlyContinue
}
Write-Host ""
Write-Host "===== STEP 3: ASAN the arena round-trip (UAF gate on the response-escape boundary) ====="
& $ClangPath -fsanitize=address -g -O1 -o _fa_asan.exe _forge_arena_readiness.ll output\nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w 2>$null
if (Test-Path _fa_asan.exe) {
  $env:ASAN_OPTIONS = "abort_on_error=0"
  & ".\_fa_asan.exe" 1>_fa_o.txt 2>_fa_e.txt
  $er = Get-Content _fa_e.txt -Raw -ErrorAction SilentlyContinue
  Write-Host ("  stdout: " + ((Get-Content _fa_o.txt -Raw -ErrorAction SilentlyContinue)).Trim())
  if ($er -and ($er -match "ERROR: AddressSanitizer|heap-use-after-free|attempting double-free|heap-buffer-overflow")) { Write-Host "  ASAN *** FINDING ***"; Write-Host $er } else { Write-Host "  ASAN clean" }
} else { Write-Host "  ASAN build failed" }
Remove-Item _fa_asan.exe,_forge_arena_readiness.ll,_fa_o.txt,_fa_e.txt -Force -ErrorAction SilentlyContinue
Write-Host "===== iter-95 GATE DONE ====="
