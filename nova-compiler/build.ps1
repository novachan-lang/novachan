Set-Location $PSScriptRoot
& "$PSScriptRoot\gradlew.bat" clean fatJar
Write-Host "BUILD_RESULT: $LASTEXITCODE"
