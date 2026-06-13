param([string[]]$Demos = @("wasm_dict_struct_demo","wasm_wordcount_demo","wasm_struct_math_demo"))
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
$gen = (Resolve-Path ".\gen3_test.exe").Path
$allok = $true
foreach ($d in $Demos) {
  Write-Host ("===== " + $d + " =====")
  Remove-Item "$d.ll","$d.exe","$d.wasm","$d.wasm.ll","$d.run.cjs" -Force -ErrorAction SilentlyContinue
  # NATIVE: compile -> link -> run
  $c = Invoke-Timed -FilePath $gen -Arguments "$d.nova" -TimeoutMs 60000
  if (-not (Test-Path "$d.ll")) { Write-Host ("  NATIVE compile FAIL: " + $c.Stderr); $allok=$false; continue }
  $l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $d.exe $d.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
  if (-not (Test-Path "$d.exe")) { Write-Host "  NATIVE link FAIL"; $allok=$false; continue }
  $nr = Invoke-Timed -FilePath (Resolve-Path ".\$d.exe").Path -Arguments "" -TimeoutMs 15000
  $native = ($nr.Stdout -replace "`r`n","`n").TrimEnd("`n")
  # WASM: nova wasm -> node run.cjs
  $w = Invoke-Timed -FilePath $gen -Arguments "wasm $d.nova" -TimeoutMs 120000
  if (-not (Test-Path "$d.run.cjs")) { Write-Host ("  WASM build FAIL: " + $w.Stdout + " " + $w.Stderr); $allok=$false; continue }
  $node = (Get-Command node).Source
  $wr = Invoke-Timed -FilePath $node -Arguments "$d.run.cjs" -TimeoutMs 20000
  $wasm = ($wr.Stdout -replace "`r`n","`n").TrimEnd("`n")
  Write-Host ("  NATIVE: " + ($native -replace "`n"," | "))
  Write-Host ("  WASM  : " + ($wasm -replace "`n"," | "))
  if ($native -eq $wasm -and $native.Length -gt 0) { Write-Host "  => BYTE-IDENTICAL" }
  else { Write-Host "  => MISMATCH"; if ($wr.Stderr) { Write-Host ("  wasm stderr: " + $wr.Stderr) }; $allok=$false }
}
Write-Host ("RESULT: " + $(if ($allok) { "ALL DEMOS MATCH NATIVE" } else { "SOME FAILED" }))
