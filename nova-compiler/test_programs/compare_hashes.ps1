param([string]$f1, [string]$f2)
$h1 = (Get-FileHash $f1).Hash
$h2 = (Get-FileHash $f2).Hash
Write-Host "File1: $h1"
Write-Host "File2: $h2"
if ($h1 -eq $h2) { Write-Host "CONVERGED" } else { Write-Host "DIVERGED" }
