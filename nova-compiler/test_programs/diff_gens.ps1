$gen3 = Get-Content "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs\gen3.ll"
$gen4 = Get-Content "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs\gen4.ll"
$diff = Compare-Object $gen3 $gen4

Write-Host "=== Lines ONLY in gen3.ll (first 20) ==="
$diff | Where-Object { $_.SideIndicator -eq '<=' } | Select-Object -First 20 | ForEach-Object { Write-Host $_.InputObject }

Write-Host ""
Write-Host "=== Lines ONLY in gen4.ll (first 20) ==="
$diff | Where-Object { $_.SideIndicator -eq '=>' } | Select-Object -First 20 | ForEach-Object { Write-Host $_.InputObject }

Write-Host ""
Write-Host "gen3 only count: $(($diff | Where-Object { $_.SideIndicator -eq '<=' }).Count)"
Write-Host "gen4 only count: $(($diff | Where-Object { $_.SideIndicator -eq '=>' }).Count)"
