Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Remove-Item "nova_compiler.ll","_gen4.exe" -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 900000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "nova_compiler.ll")) { Write-Host "PRECHECK FAIL (timedout=$($c.TimedOut))"; Write-Host (($c.StdOut -split "`r?`n" | Select-Object -Last 12) -join " | "); exit 1 }
Write-Host "precheck OK"
Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"_gen4.exe`" `"nova_compiler.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path "_gen4.exe")) { Write-Host "LINK gen4 FAIL"; exit 1 }
Write-Host "_gen4.exe built"
Write-Host "=== INERTNESS (flag off, byte-identical) ==="
$ok=$true
foreach ($p in @("leak_baseline_test","sorted_map_test","pvecx","collatex_test","ecs")) {
  Remove-Item "$p.ll" -Force -ErrorAction SilentlyContinue
  Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "$p.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot | Out-Null
  $h1=(Get-FileHash "$p.ll" -Algorithm SHA256).Hash; Remove-Item "$p.ll" -Force -ErrorAction SilentlyContinue
  Invoke-Timed -FilePath "$PSScriptRoot\_gen4.exe" -Arguments "$p.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot | Out-Null
  $h2=(Get-FileHash "$p.ll" -Algorithm SHA256).Hash; Remove-Item "$p.ll" -Force -ErrorAction SilentlyContinue
  if ($h1 -ne $h2) { $ok=$false; Write-Host "  $p DIFFERS" } else { Write-Host "  $p IDENTICAL" }
}
Write-Host $(if($ok){"INERTNESS_OK"}else{"INERTNESS_FAIL (flag-off codegen changed!)"})
Write-Host "=== FLAG-ON leak reduction (scope_leak + leak_baseline + forge_readiness) ==="
foreach ($p in @("_scope_leak","leak_baseline_test","_forge_readiness")) {
  Remove-Item "$p.ll","$p.exe" -Force -ErrorAction SilentlyContinue
  $env:NOVA_T8_FULLRC="1"
  Invoke-Timed -FilePath "$PSScriptRoot\_gen4.exe" -Arguments "$p.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot | Out-Null
  Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue
  Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$p.exe`" `"$p.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot | Out-Null
  $rr=Invoke-Timed -FilePath "$PSScriptRoot\$p.exe" -Arguments '' -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
  Write-Host ("  [{0}] {1}" -f $p, ($rr.StdOut -replace "`r?`n"," ").Trim())
  Remove-Item "$p.ll","$p.exe" -Force -ErrorAction SilentlyContinue
}
Write-Host "=== FLAG-ON ASAN (UAF gate) ==="
foreach ($p in @("_scope_leak","leak_baseline_test","pvecx","sorted_map_test","ecs","collatex_test")) {
  Remove-Item "$p.ll","${p}_a.exe" -Force -ErrorAction SilentlyContinue
  $env:NOVA_T8_FULLRC="1"
  Invoke-Timed -FilePath "$PSScriptRoot\_gen4.exe" -Arguments "$p.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot | Out-Null
  Remove-Item Env:\NOVA_T8_FULLRC -ErrorAction SilentlyContinue
  Invoke-Timed -FilePath $ClangPath -Arguments "-fsanitize=address -O1 -g -o `"${p}_a.exe`" `"$p.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 150000 -WorkingDirectory $PSScriptRoot | Out-Null
  if (!(Test-Path "${p}_a.exe")) { Write-Host "  $p ASAN-LINK-FAIL"; $ok=$false; continue }
  $rr=Invoke-Timed -FilePath "$PSScriptRoot\${p}_a.exe" -Arguments '' -TimeoutMs 40000 -WorkingDirectory $PSScriptRoot
  $a = if ($rr.StdErr -match "AddressSanitizer|use-after-free|double-free|overflow") { "ASAN-FINDING!!!" } else { "asan-clean" }
  Write-Host ("  {0}: exit={1} {2}" -f $p,$rr.ExitCode,$a)
  Remove-Item "$p.ll","${p}_a.exe" -Force -ErrorAction SilentlyContinue
}
Write-Host "DERISK_DONE"
