Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Write-Host "=== S4.1 validate: rebuild compiler ==="
$c = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 900000
if ($c.ExitCode -ne 0) { Write-Host "COMPILER COMPILE FAIL exit=$($c.ExitCode)"; exit 1 }
Copy-Item nova_compiler.ll _s4c.ll -Force
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o _s4c.exe _s4c.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000
if (!(Test-Path _s4c.exe)) { Write-Host "COMPILER LINK FAIL"; exit 1 }
Write-Host "compiler rebuilt ($((Get-Item _s4c.exe).Length) bytes)"

function Run-Test($name) {
  $cc = Invoke-Timed -FilePath (Resolve-Path ".\_s4c.exe").Path -Arguments "$name.nova" -TimeoutMs 60000
  if ($cc.ExitCode -ne 0) { Write-Host "FAIL(compile) $name : $($cc.StdErr.Trim())"; return }
  $ld = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $name.exe $name.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
  if (!(Test-Path "$name.exe")) { Write-Host "FAIL(link) $name"; return }
  $rr = Invoke-Timed -FilePath (Resolve-Path ".\$name.exe").Path -Arguments "" -TimeoutMs 20000
  $tail = ($rr.StdOut.Trim() -split "`n" | Select-Object -Last 1)
  $err = ""
  if ($rr.StdErr -match 'FAIL assert') { $err = " [ASSERT FAIL: $($rr.StdErr.Trim())]" }
  $verdict = "PASS"
  if ($rr.ExitCode -ne 0 -or $err) { $verdict = "FAIL" }
  Write-Host "$verdict $name (exit=$($rr.ExitCode)) tail='$tail'$err"
  Remove-Item "$name.ll","$name.exe" -Force -ErrorAction SilentlyContinue
}

Write-Host "=== S4.1 int-taint adversarial + the 2 regressions + spot-check ==="
Run-Test "math3d"
Run-Test "track7_stdlib_full_test"
Run-Test "_s4_adv_int_test"
Run-Test "_s4_adv_int2_test"
Run-Test "_s4_escbug_test"
Run-Test "_s4_adv_test"
Run-Test "_s4_adv_chan_test"
Run-Test "intlist_test"
Run-Test "list_test"
Run-Test "float_list_ops_test"
Run-Test "map_filter_test"
Run-Test "comprehension_test"
Remove-Item _s4c.ll -Force -ErrorAction SilentlyContinue
Write-Host "=== validate done (compiler kept as _s4c.exe) ==="
