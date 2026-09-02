Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
$t = "_argon2id_test"
Remove-Item "$t.ll","${t}_car.exe" -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "$t.nova $t.ll" -TimeoutMs 240000
if ($c.ExitCode -ne 0) { Write-Host "COMPILE FAILED"; exit 1 }
$l = Invoke-Timed -FilePath "clang" -Arguments "-O1 -o ${t}_car.exe $t.ll ..\compiler\nova_runtime.c $NovaLinkFlags -w" -TimeoutMs 300000
if ($l.ExitCode -ne 0) { Write-Host "LINK FAILED"; exit 1 }
$exe = (Resolve-Path ".\${t}_car.exe").Path
foreach ($nc in @(1,4,8)) {
  $env:NOVA_CARRIERS = "$nc"
  $hang = 0; $fail = 0; $ok = 0
  foreach ($i in 1..20) {
    $r = Invoke-Timed -FilePath $exe -Arguments "" -TimeoutMs 30000
    if ($r.TimedOut) { $hang++ }
    elseif ($r.ExitCode -ne 0) { $fail++ }
    else { $ok++ }
  }
  Write-Host "CARRIERS=$nc  ok=$ok  fail=$fail  HANG=$hang  (of 20, 30s cap on a ms-scale workload)"
}
Remove-Item "${t}_car.exe" -Force -ErrorAction SilentlyContinue
