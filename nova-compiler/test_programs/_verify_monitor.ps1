$ErrorActionPreference = "Continue"
$env:NOVA_NO_CACHE = "1"
Remove-Item _n1_monitor_race_test.ll,_mon.o,_mon.exe,_mon_asan.exe -EA SilentlyContinue
& ./gen3_test.exe _n1_monitor_race_test.nova *> _mc.txt
if (-not (Test-Path _n1_monitor_race_test.ll)) { Write-Host "COMPILE FAIL"; Get-Content _mc.txt | Select-Object -Last 8; exit 1 }
Write-Host "compiled OK"
# normal runtime .o
& clang -c -O2 output/nova_runtime.c -o _mon.o -D_CRT_SECURE_NO_WARNINGS -w 2> _mo.txt
& clang -O2 -o _mon.exe _n1_monitor_race_test.ll _mon.o -lws2_32 -ladvapi32 -lkernel32 -D_CRT_SECURE_NO_WARNINGS -w 2> _ml.txt
if (-not (Test-Path _mon.exe)) { Write-Host "LINK FAIL"; Get-Content _ml.txt | Select-Object -Last 6; exit 1 }

function RunN($label, $ncar, $exe) {
  $env:NOVA_CARRIERS = "$ncar"
  $p = Start-Process -FilePath (Resolve-Path "./$exe").Path -PassThru -NoNewWindow -RedirectStandardOutput _mo_o.txt -RedirectStandardError _mo_e.txt
  if (-not $p.WaitForExit(40000)) { cmd /c "taskkill /F /T /PID $($p.Id)" 2>$null | Out-Null; Write-Host ("{0}: HUNG (killed)" -f $label); return }
  $out = ((Get-Content _mo_o.txt -EA SilentlyContinue) -join " ")
  $err = ((Get-Content _mo_e.txt -EA SilentlyContinue) -join " ")
  $ok = ($out -match "PASS monitor_race")
  $san = ($err -match "ERROR: AddressSanitizer|runtime error|heap-use-after-free|heap-buffer-overflow")
  Write-Host ("{0}: {1}{2}  {3}" -f $label, $(if($ok){"PASS"}else{"FAIL"}), $(if($san){" +SANITIZER!"}else{""}), $out.Trim())
  if ($san) { Write-Host ("   SAN: " + $err.Substring(0,[Math]::Min(300,$err.Length))) }
}

RunN "N=1 normal" 1 "_mon.exe"
RunN "N=4 normal" 4 "_mon.exe"
# ASAN build (catches the realloc-vs-read heap corruption)
Write-Host "building ASAN (~90s)..."
& clang -O1 -g -fsanitize=address -o _mon_asan.exe _n1_monitor_race_test.ll output/nova_runtime.c -lws2_32 -ladvapi32 -lkernel32 -D_CRT_SECURE_NO_WARNINGS -w 2> _ma.txt
if (Test-Path _mon_asan.exe) { RunN "N=4 ASAN" 4 "_mon_asan.exe" } else { Write-Host "ASAN build failed (skipping):"; Get-Content _ma.txt | Select-Object -Last 4 }
Remove-Item _n1_monitor_race_test.ll,_mon.o,_mon.exe,_mon_asan.exe,_mc.txt,_mo.txt,_ml.txt,_ma.txt,_mo_o.txt,_mo_e.txt -EA SilentlyContinue
