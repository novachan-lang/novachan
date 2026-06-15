$dir = $PSScriptRoot
$h5 = (Get-FileHash "$dir\gen5.ll" -Algorithm SHA256).Hash
$h6 = (Get-FileHash "$dir\gen6.ll" -Algorithm SHA256).Hash
Write-Host "gen5=$h5"
Write-Host "gen6=$h6"
if ($h5 -eq $h6) { Write-Host "CONVERGED" } else { Write-Host "DIVERGED" }
