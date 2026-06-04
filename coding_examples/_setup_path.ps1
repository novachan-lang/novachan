$novaDir = "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"
$currentPath = [System.Environment]::GetEnvironmentVariable("Path", "User")

if ($currentPath -like "*nova-compiler*") {
    Write-Host "Already in PATH"
} else {
    $newPath = $currentPath + ";" + $novaDir
    [System.Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    Write-Host "ADDED: $novaDir"
}

# Verify
$check = [System.Environment]::GetEnvironmentVariable("Path", "User")
$found = $check -split ";" | Where-Object { $_ -like "*nova-compiler*" }
if ($found) {
    Write-Host "VERIFIED: $found"
    Write-Host ""
    Write-Host "Close and reopen your terminal, then run:"
    Write-Host "  nova run snake_game.nova"
} else {
    Write-Host "FAILED to add to PATH"
}
