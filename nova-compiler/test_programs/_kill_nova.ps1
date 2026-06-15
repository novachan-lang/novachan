Get-Process | Where-Object { $_.ProcessName -match 'gen[0-9]|memo_test|nova_comp|clang' } | ForEach-Object {
    Write-Host "Killing $($_.ProcessName) PID=$($_.Id)"
    Stop-Process -Id $_.Id -Force
}
Write-Host "Done - no NOVA processes running"
