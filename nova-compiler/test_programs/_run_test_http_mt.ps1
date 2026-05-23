Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "http_mt_demo.nova" -TimeoutMs 60000
Write-Host "Compile exit: $($cr.ExitCode)"
if ($cr.StdOut) { Write-Host "stdout: $($cr.StdOut)" }
if ($cr.ExitCode -ne 0) { exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o http_mt_demo.exe http_mt_demo.ll nova_runtime.c -lws2_32" -TimeoutMs 60000
Write-Host "Link exit: $($lr.ExitCode)"
if (!(Test-Path "http_mt_demo.exe")) { exit 1 }

$port = 18766
Write-Host "Starting MT server on port $port..."
$server = Start-Process -FilePath ".\http_mt_demo.exe" -ArgumentList "$port" -PassThru -WindowStyle Hidden -RedirectStandardOutput "_http_mt.out" -RedirectStandardError "_http_mt.err"
Start-Sleep -Milliseconds 800

try {
    # Test concurrency: fire 3 /slow requests in parallel.
    # Each /slow takes ~1s. Serial would be 3s. Parallel should be ~1s.
    Write-Host ""
    Write-Host "=== Concurrent: 3x /slow in parallel ==="
    $start = Get-Date
    $jobs = @()
    for ($i = 0; $i -lt 3; $i++) {
        $jobs += Start-Job -ScriptBlock {
            param($p)
            $r = Invoke-WebRequest -Uri "http://127.0.0.1:$p/slow" -UseBasicParsing -TimeoutSec 10
            return "$($r.StatusCode) $($r.Content)"
        } -ArgumentList $port
    }
    $jobs | Wait-Job | Out-Null
    $results = $jobs | Receive-Job
    $jobs | Remove-Job
    $elapsed = ((Get-Date) - $start).TotalMilliseconds
    Write-Host "Total elapsed: $([int]$elapsed) ms (single-threaded would be ~3000 ms)"
    foreach ($r in $results) { Write-Host "  Response: $r" }

    Write-Host ""
    Write-Host "=== Mix: /fast while /slow is in flight ==="
    $slowJob = Start-Job -ScriptBlock {
        param($p)
        $r = Invoke-WebRequest -Uri "http://127.0.0.1:$p/slow" -UseBasicParsing -TimeoutSec 10
        return "slow: $($r.Content)"
    } -ArgumentList $port
    Start-Sleep -Milliseconds 100
    $fastStart = Get-Date
    $r2 = Invoke-WebRequest -Uri "http://127.0.0.1:$port/fast" -UseBasicParsing -TimeoutSec 5
    $fastElapsed = ((Get-Date) - $fastStart).TotalMilliseconds
    Write-Host "fast response while slow was in flight: $($r2.Content) ($([int]$fastElapsed) ms)"
    $slowJob | Wait-Job | Out-Null
    $slowResult = $slowJob | Receive-Job
    $slowJob | Remove-Job
    Write-Host "slow finished: $slowResult"

    Write-Host ""
    Write-Host "=== GET /stop ==="
    try {
        $r3 = Invoke-WebRequest -Uri "http://127.0.0.1:$port/stop" -UseBasicParsing -TimeoutSec 5
        Write-Host "stop: $($r3.Content)"
    } catch {}
} finally {
    Start-Sleep -Milliseconds 400
    if (-not $server.HasExited) { try { $server.Kill() } catch {} }
    try { $server.WaitForExit(2000) | Out-Null } catch {}

    if (Test-Path "_http_mt.out") {
        Write-Host ""
        Write-Host "=== Server stdout ==="
        Get-Content "_http_mt.out" | ForEach-Object { Write-Host "  $_" }
    }
    Remove-Item "http_mt_demo.ll","http_mt_demo.exe","_http_mt.out","_http_mt.err","nova_runtime.c" -Force -ErrorAction SilentlyContinue
}
