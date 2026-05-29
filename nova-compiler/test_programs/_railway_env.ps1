# Loads the Railway token from .env into the environment (without printing it),
# then runs `railway` with the given arguments. Usage:
#   powershell -File _railway_env.ps1 whoami
#   powershell -File _railway_env.ps1 up
param([Parameter(ValueFromRemainingArguments = $true)] $RailwayArgs)
$envFile = Join-Path $PSScriptRoot ".env"
if (!(Test-Path $envFile)) { Write-Host ".env not found at $envFile"; exit 1 }
$loaded = $false
Get-Content $envFile | ForEach-Object {
    $line = $_.Trim()
    if ($line -and -not $line.StartsWith("#") -and $line.Contains("=")) {
        $idx = $line.IndexOf("=")
        $k = $line.Substring(0, $idx).Trim()
        $v = $line.Substring($idx + 1).Trim()
        if ($v) { Set-Item -Path "Env:$k" -Value $v; $loaded = $true }
    }
}
if (-not $loaded) { Write-Host "No token set in .env (RAILWAY_API_TOKEN= or RAILWAY_TOKEN=)."; exit 1 }
if ($env:RAILWAY_API_TOKEN) { Write-Host "Loaded RAILWAY_API_TOKEN (hidden)." }
if ($env:RAILWAY_TOKEN)     { Write-Host "Loaded RAILWAY_TOKEN (hidden)." }
if (-not $RailwayArgs) { Write-Host "No railway command given."; exit 0 }
& railway @RailwayArgs
exit $LASTEXITCODE
