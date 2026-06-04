$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path", "User")
Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\coding_examples"
nova run snake_game.nova
