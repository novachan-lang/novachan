Set-Location $PSScriptRoot
$CLANG = "C:\Program Files\LLVM\bin\clang.exe"
Write-Host "===== iter-89 GATE: channel-destructor fix (runtime-only) ====="
Write-Host "===== STEP 1: reconverge (runtime change does NOT touch the .ll -> expect 12152E9D) ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_bootstrap_reconverge_slow.ps1"
if (!(Test-Path "$PSScriptRoot\gen3_test.exe")) { Write-Host "GATE ABORT: no gen3_test.exe"; exit 1 }
Write-Host ""
Write-Host "===== STEP 2: NORMAL regression (flag OFF) -- 432/0 ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_run_final_regression.ps1" 2>&1 | Select-String -Pattern "RESULTS:|^FAIL "
Write-Host ""
Write-Host "===== STEP 3: FLAG-ON regression (NOVA_T8_FULLRC=1) -- 432/0 ====="
$env:NOVA_T8_FULLRC = "1"
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_run_final_regression.ps1" 2>&1 | Select-String -Pattern "RESULTS:|^FAIL "
Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue
Write-Host ""
Write-Host "===== STEP 4: ASAN on channel-heavy tests (both flag modes) -- UAF/double-free gate ====="
$chanTests = @("chanx","bounded_chan_test","close_test","actorx","deep_copy_depth_test","bench_channel","leak_baseline_test")
$env:NOVA_NO_CACHE = "1"
foreach ($mode in @("OFF","ON")) {
  if ($mode -eq "ON") { $env:NOVA_T8_FULLRC = "1" } else { Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue }
  Write-Host "  --- ASAN flag $mode ---"
  foreach ($t in $chanTests) {
    if (!(Test-Path "$PSScriptRoot\$t.nova")) { continue }
    & "$PSScriptRoot\gen3_test.exe" "$t.nova" > $null 2>&1
    if (!(Test-Path "$PSScriptRoot\$t.ll")) { Write-Host "    $t : NO .ll (skip)"; continue }
    & $CLANG -fsanitize=address -g -O1 -o "$PSScriptRoot\${t}_asan.exe" "$PSScriptRoot\$t.ll" "$PSScriptRoot\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
    if (!(Test-Path "$PSScriptRoot\${t}_asan.exe")) { Write-Host "    $t : ASAN LINK FAIL"; continue }
    $env:ASAN_OPTIONS = "abort_on_error=0"
    $p = New-Object System.Diagnostics.ProcessStartInfo
    $p.FileName = "$PSScriptRoot\${t}_asan.exe"; $p.WorkingDirectory = $PSScriptRoot
    $p.UseShellExecute = $false; $p.RedirectStandardError = $true; $p.RedirectStandardOutput = $true; $p.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $p; $pr.Start() | Out-Null
    $oe = $pr.StandardError.ReadToEndAsync(); $oo = $pr.StandardOutput.ReadToEndAsync()
    if (-not $pr.WaitForExit(20000)) { $pr.Kill(); Write-Host "    $t : TIMEOUT"; continue }
    [System.Threading.Tasks.Task]::WaitAll($oe,$oo)
    $err = $oe.Result
    if ($err -match "ERROR: AddressSanitizer|heap-use-after-free|double-free|heap-buffer-overflow") {
      Write-Host "    $t : *** ASAN FINDING (flag $mode) ***"
      Write-Host ($err.Substring(0,[Math]::Min(1200,$err.Length)))
    } else {
      Write-Host "    $t : exit=$($pr.ExitCode) asan-clean"
    }
    Remove-Item "$PSScriptRoot\${t}_asan.exe","$PSScriptRoot\$t.ll" -Force -ErrorAction SilentlyContinue
  }
}
Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue
Write-Host ""
Write-Host "===== STEP 5: green_scale (M:N flagship w/ channels) flag-off + on ====="
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_green_scale_run.ps1" 2>&1 | Select-String -Pattern "GREEN SCALE|exit="
$env:NOVA_T8_FULLRC = "1"
& powershell -NoProfile -ExecutionPolicy Bypass -File "$PSScriptRoot\_green_scale_run.ps1" 2>&1 | Select-String -Pattern "GREEN SCALE|exit="
Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue
Write-Host "===== iter-89 GATE DONE ====="
