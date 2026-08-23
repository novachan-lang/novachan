. "$PSScriptRoot\_proc_util.ps1"
Stop-StrayCompilers
$env:NOVA_NO_CACHE = "1"
Remove-Item -Force _f31_scalar_c.exe,_f31_scalar.ll,_f31_scalar.exe -ErrorAction SilentlyContinue
Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o _f31_scalar_c.exe _f31_scalar.c -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 300000 | Out-Null
$c = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "build _f31_scalar.nova" -TimeoutMs 300000
if ($c.ExitCode -ne 0) { Write-Host "NOVA COMPILE FAIL"; Write-Host $c.StdOut; Write-Host $c.StdErr; exit 1 }
Start-Sleep -Seconds 4
$cs=@(); $ns=@()
foreach ($r in 1..3) {
  $x = Invoke-Timed -FilePath (Resolve-Path ".\_f31_scalar_c.exe").Path -Arguments "" -TimeoutMs 300000
  if ($x.StdOut -match "elapsed_ms=(\d+)") { $cs += [int]$Matches[1] }
  $y = Invoke-Timed -FilePath (Resolve-Path ".\_f31_scalar.exe").Path -Arguments "" -TimeoutMs 300000
  if ($y.StdOut -match "elapsed_ms=(\d+)") { $ns += [int]$Matches[1] }
}
$cm=($cs|Measure-Object -Minimum).Minimum; $nm=($ns|Measure-Object -Minimum).Minimum
Write-Host ("C    : " + ($cs -join ", ") + "  min=$cm ms")
Write-Host ("NOVA : " + ($ns -join ", ") + "  min=$nm ms")
if ($cm -gt 0) { Write-Host ("scalar-float-call ratio NOVA/C = " + [math]::Round($nm/[double]$cm,2) + "x") }
