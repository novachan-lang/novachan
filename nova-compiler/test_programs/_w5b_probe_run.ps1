Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$probes = @("_w5b_probe_a","_w5b_probe_b","_w5b_probe_c","_w5b_probe_d")
foreach ($p in $probes) {
  foreach ($mode in @("OFF","ON")) {
    Remove-Item "$p.ll","$p.exe" -Force -ErrorAction SilentlyContinue
    if ($mode -eq "ON") { $env:NOVA_T8_DROP = "1" } else { Remove-Item Env:\NOVA_T8_DROP -ErrorAction SilentlyContinue }
    $cr = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "$p.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    Remove-Item Env:\NOVA_T8_DROP -ErrorAction SilentlyContinue
    if (!(Test-Path "$p.ll")) { Write-Host ("{0} [{1}] COMPILE-FAIL" -f $p,$mode); continue }
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$p.exe`" `"$p.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path "$p.exe")) { Write-Host ("{0} [{1}] LINK-FAIL" -f $p,$mode); continue }
    $rr = Invoke-Timed -FilePath "$PSScriptRoot\$p.exe" -Arguments '' -TimeoutMs 10000 -WorkingDirectory $PSScriptRoot
    $out = ($rr.StdOut -replace "`r?`n"," | ").Trim()
    Write-Host ("{0} [{1}] exit={2} timedout={3} out=[{4}]" -f $p,$mode,$rr.ExitCode,$rr.TimedOut,$out)
    Remove-Item "$p.ll","$p.exe" -Force -ErrorAction SilentlyContinue
  }
}
