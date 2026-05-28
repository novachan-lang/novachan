Set-Location $PSScriptRoot
clang -O2 -o sieve_c.exe bench_g5_sieve10m.c
if (!(Test-Path "sieve_c.exe")) { Write-Host "C compile failed"; exit 1 }
Write-Host "=== C Sieve Timing ==="
for ($i = 1; $i -le 3; $i++) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    & ".\sieve_c.exe" | Out-Null
    $sw.Stop()
    Write-Host "Run $i : $($sw.ElapsedMilliseconds) ms"
}
Remove-Item "sieve_c.exe" -Force
