Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path ".\gen2_move.exe").Path
$cr = Invoke-Timed -FilePath $compiler -Arguments "..\bench\bench_g5_primes_seq.nova" -TimeoutMs 30000

if (Test-Path "bench_g5_primes_seq.ll") {
    Write-Host "=== readonly/readnone declarations ==="
    Select-String -Path "bench_g5_primes_seq.ll" -Pattern "readonly|readnone" |
        Select-Object -First 15 |
        ForEach-Object { Write-Host $_.Line.Trim() }
    Remove-Item "bench_g5_primes_seq.ll" -Force
} else {
    Write-Host "COMPILE FAILED"
    if ($cr.StdOut) { Write-Host $cr.StdOut }
}
