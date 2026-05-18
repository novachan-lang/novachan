Set-Location $PSScriptRoot
$result = & ".\nova_compiler.exe" 2>&1 | Out-String
Write-Host "ALL: $result"
Write-Host "EXIT: $LASTEXITCODE"
