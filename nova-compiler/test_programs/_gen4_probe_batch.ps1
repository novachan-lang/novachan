param([string]$Compiler = "gen4_test.exe")
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
$probes = @(
  '_struct_field_leak_test',
  '_struct_alias_field_test',
  '_struct_float_field_test',
  '_struct_enum_payload_test',
  '_struct_field_reassign_test',
  '_struct_field_read_stress_test'
)
$comp = "$PSScriptRoot\$Compiler"
foreach ($t in $probes) {
  $ll = "$PSScriptRoot\$t.ll"; $exe = "$PSScriptRoot\$t.exe"
  Remove-Item $ll,$exe -ErrorAction SilentlyContinue
  $cr = Invoke-Timed -FilePath $comp -Arguments "$t.nova" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
  if (!(Test-Path $ll)) { Write-Host "[$t] COMPILE FAIL exit=$($cr.ExitCode)"; if ($cr.StdErr) { Write-Host "  CERR: $($cr.StdErr)" }; ($cr.StdOut -split "`n" | Select-Object -Last 4) | ForEach-Object { Write-Host "  $_" }; continue }
  $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$exe`" `"$ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
  if (!(Test-Path $exe)) { Write-Host "[$t] LINK FAIL"; continue }
  $rr = Invoke-Timed -FilePath $exe -Arguments '' -TimeoutMs 20000 -WorkingDirectory $PSScriptRoot
  $out = ($rr.StdOut -split "`n" | Where-Object { $_ -match 'passed|FAILED|delta|n=' } | Select-Object -Last 2) -join ' | '
  Write-Host "[$t] run_exit=$($rr.ExitCode) timedout=$($rr.TimedOut) :: $out"
  if ($rr.StdErr) { Write-Host "  ERR: $($rr.StdErr)" }
  Remove-Item $ll,$exe -ErrorAction SilentlyContinue
}
Write-Host "=== probe batch done ==="
