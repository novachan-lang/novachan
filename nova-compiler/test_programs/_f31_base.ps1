. "$PSScriptRoot\_proc_util.ps1"
Stop-StrayCompilers
$env:NOVA_NO_CACHE = "1"
$flags = "-lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w"
# C reference
Remove-Item -Force _fa_bench_c.exe -ErrorAction SilentlyContinue
Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o _fa_bench_c.exe _fa_bench.c" -TimeoutMs 300000 | Out-Null
# NOVA
Remove-Item -Force _fa_bench.ll,_fa_bench.exe -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "build _fa_bench.nova" -TimeoutMs 300000
if ($c.ExitCode -ne 0) { Write-Host "NOVA COMPILE FAIL"; Write-Host $c.StdErr; exit 1 }
Start-Sleep -Seconds 5
$cs=@(); $ns=@()
foreach ($r in 1..3) {
  $x = Invoke-Timed -FilePath (Resolve-Path ".\_fa_bench_c.exe").Path -Arguments "" -TimeoutMs 300000
  if ($x.StdOut -match "elapsed_ms=(\d+)") { $cs += [int]$Matches[1] }
  $y = Invoke-Timed -FilePath (Resolve-Path ".\_fa_bench.exe").Path -Arguments "" -TimeoutMs 300000
  if ($y.StdOut -match "elapsed_ms=(\d+)") { $ns += [int]$Matches[1] }
}
$cm=($cs|Measure-Object -Minimum).Minimum; $nm=($ns|Measure-Object -Minimum).Minimum
Write-Host ("C    : " + ($cs -join ", ") + "  min=$cm ms")
Write-Host ("NOVA : " + ($ns -join ", ") + "  min=$nm ms")
if ($cm -gt 0) { Write-Host ("float-array ratio NOVA/C = " + [math]::Round($nm/[double]$cm,2) + "x") }
