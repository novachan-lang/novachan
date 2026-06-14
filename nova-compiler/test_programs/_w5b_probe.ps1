Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$LLVM = "C:\Program Files\LLVM\bin"
$env:NOVA_T8_DROP = "1"   # turn W5b ON for every compile below
$rt = "$PSScriptRoot\output\nova_runtime.c"
Remove-Item nova_w5b.ll, nova_w5b2.ll, gen4_w5b.exe -Force -ErrorAction SilentlyContinue
# 1. build a W5b-compiled compiler (gen3 compiles itself WITH drops)
$c = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 450000 -WorkingDirectory $PSScriptRoot
if ($c.ExitCode -ne 0 -or !(Test-Path nova_compiler.ll)) { Write-Host "W5B compile1 FAIL exit=$($c.ExitCode)"; exit 1 }
Copy-Item nova_compiler.ll nova_w5b.ll -Force
$lk = Invoke-Timed -FilePath "$LLVM\clang.exe" -Arguments "-O2 -o gen4_w5b.exe nova_w5b.ll `"$rt`" -lws2_32 -lwinhttp -ladvapi32 -lbcrypt -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path gen4_w5b.exe)) { Write-Host "W5B link FAIL"; exit 1 }
Write-Host "gen4_w5b.exe built"
# 2. does the W5b-compiled compiler reproduce itself? (compile nova_compiler.nova again, with drops)
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
$c2 = Invoke-Timed -FilePath "$PSScriptRoot\gen4_w5b.exe" -Arguments "nova_compiler.nova" -TimeoutMs 450000 -WorkingDirectory $PSScriptRoot
if ($c2.ExitCode -ne 0 -or !(Test-Path nova_compiler.ll)) { Write-Host "W5B self-compile FAIL exit=$($c2.ExitCode) (crash/miscompile)"; exit 1 }
Copy-Item nova_compiler.ll nova_w5b2.ll -Force
$h1 = (Get-FileHash nova_w5b.ll -Algorithm SHA256).Hash
$h2 = (Get-FileHash nova_w5b2.ll -Algorithm SHA256).Hash
if ($h1 -eq $h2) { Write-Host "W5B SELF-REPRODUCE OK ($($h1.Substring(0,8)))" } else { Write-Host "W5B SELF-REPRODUCE DIVERGES ($($h1.Substring(0,8)) vs $($h2.Substring(0,8)))" }
# 3. smoke: does gen4_w5b correctly compile+run the tests that broke bare-W5b?
$tests = @("trait_test","closure_test","generic_test","generics_advanced_test","generics_soundness_test","spread_test","leak_baseline_test")
$fail = 0
foreach ($t in $tests) {
    Remove-Item "$t.ll","__w5bt.exe" -Force -ErrorAction SilentlyContinue
    $tc = Invoke-Timed -FilePath "$PSScriptRoot\gen4_w5b.exe" -Arguments "$t.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if ($tc.ExitCode -ne 0 -or !(Test-Path "$t.ll")) { Write-Host "  $t : COMPILE FAIL"; $fail=1; continue }
    $tl = Invoke-Timed -FilePath "$LLVM\clang.exe" -Arguments "-O2 -o __w5bt.exe $t.ll `"$rt`" -lws2_32 -lwinhttp -ladvapi32 -lbcrypt -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path __w5bt.exe)) { Write-Host "  $t : LINK FAIL"; $fail=1; continue }
    $tr = Invoke-Timed -FilePath "$PSScriptRoot\__w5bt.exe" -Arguments "" -TimeoutMs 20000 -WorkingDirectory $PSScriptRoot
    if ($tr.TimedOut) { Write-Host "  $t : RUN TIMEOUT/HANG"; $fail=1; continue }
    if ($tr.ExitCode -ne 0 -or ($tr.StdOut -match "FAIL|mismatch|assert")) { Write-Host "  $t : RUN FAIL exit=$($tr.ExitCode)"; $fail=1; continue }
    Write-Host "  $t : OK"
}
Remove-Item nova_w5b.ll,nova_w5b2.ll,gen4_w5b.exe,__w5bt.exe -Force -ErrorAction SilentlyContinue
if ($fail -eq 0) { Write-Host "W5B-SMOKE OK" } else { Write-Host "W5B-SMOKE FAIL" }
