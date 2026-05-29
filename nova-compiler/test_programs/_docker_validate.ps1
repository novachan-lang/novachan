# Local Linux validation of ai_serve via Docker (run once Docker Desktop is started).
# Builds the Linux image, runs it, POSTs a real prediction, checks class=1, cleans up.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

powershell -ExecutionPolicy Bypass -File "$PSScriptRoot\_deploy_prep.ps1"
if ($LASTEXITCODE -ne 0) { exit 1 }

Write-Host "=== docker build ==="
docker build -t nova-ai-serve -f Dockerfile .
if ($LASTEXITCODE -ne 0) { Write-Host "docker build FAILED (Linux build of NOVA runtime)"; exit 1 }

Write-Host "=== docker run ==="
$cid = (docker run -d -p 8090:8080 -e PORT=8080 nova-ai-serve).Trim()
Start-Sleep -Seconds 2
$pass = $false
try {
    $body = '{"features":[1.0,2.0]}'
    $resp = Invoke-RestMethod -Uri "http://127.0.0.1:8090/predict" -Method Post -Body $body -ContentType "application/json" -TimeoutSec 6
    $j = $resp | ConvertTo-Json -Compress
    Write-Host "response: $j"
    if ($j -match '"class"\s*:\s*1') { Write-Host "LINUX DEPLOY OK: class=1 (hand-computed)"; $pass = $true } else { Write-Host "PREDICTION WRONG" }
} catch { Write-Host "request failed: $($_.Exception.Message)" }
finally {
    Write-Host "=== container logs (first lines) ==="
    docker logs $cid 2>&1 | Select-Object -First 6 | ForEach-Object { Write-Host "  $_" }
    docker rm -f $cid | Out-Null
}
if ($pass) { Write-Host "RESULT: PASS (NOVA runs on Linux, real HTTP inference)" } else { Write-Host "RESULT: FAIL"; exit 1 }
