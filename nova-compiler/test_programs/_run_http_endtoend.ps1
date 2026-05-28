Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

# Compile + link
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "http_demo.nova" -TimeoutMs 60000
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o http_demo.exe http_demo.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000
if ($lr.ExitCode -ne 0) { Write-Host "link failed"; exit 1 }

# Pick a free port
$port = 18765

# Start the server in background
Write-Host "Starting server on port $port..."
$server = Start-Process -FilePath ".\http_demo.exe" -ArgumentList "$port" -PassThru -WindowStyle Hidden -RedirectStandardOutput "_http_server.out" -RedirectStandardError "_http_server.err"

# Wait briefly for the server to bind
Start-Sleep -Milliseconds 800

try {
    Write-Host ""
    Write-Host "=== GET / ==="
    $r1 = Invoke-WebRequest -Uri "http://127.0.0.1:$port/" -UseBasicParsing -TimeoutSec 5
    Write-Host "  Status: $($r1.StatusCode)"
    Write-Host "  Body: $($r1.Content)"

    Write-Host ""
    Write-Host "=== GET /hello?name=Mangesh ==="
    $r2 = Invoke-WebRequest -Uri "http://127.0.0.1:$port/hello?name=Mangesh" -UseBasicParsing -TimeoutSec 5
    Write-Host "  Status: $($r2.StatusCode)"
    Write-Host "  Content-Type: $($r2.Headers['Content-Type'])"
    Write-Host "  Body: $($r2.Content)"

    Write-Host ""
    Write-Host "=== GET /add?a=40&b=2 ==="
    $r3 = Invoke-WebRequest -Uri "http://127.0.0.1:$port/add?a=40&b=2" -UseBasicParsing -TimeoutSec 5
    Write-Host "  Status: $($r3.StatusCode)"
    Write-Host "  Body: $($r3.Content)"

    Write-Host ""
    Write-Host "=== POST /echo (body: hello world) ==="
    $r4 = Invoke-WebRequest -Uri "http://127.0.0.1:$port/echo" -Method POST -Body "hello world" -UseBasicParsing -TimeoutSec 5
    Write-Host "  Status: $($r4.StatusCode)"
    Write-Host "  Body: $($r4.Content)"

    Write-Host ""
    Write-Host "=== GET /missing (should be 404) ==="
    try {
        $r5 = Invoke-WebRequest -Uri "http://127.0.0.1:$port/missing" -UseBasicParsing -TimeoutSec 5
        Write-Host "  Status: $($r5.StatusCode)"
        Write-Host "  Body: $($r5.Content)"
    } catch {
        $err = $_.Exception.Response
        if ($err) {
            Write-Host "  Status: $([int]$err.StatusCode) $($err.StatusCode)"
            $reader = New-Object System.IO.StreamReader($err.GetResponseStream())
            Write-Host "  Body: $($reader.ReadToEnd())"
        } else {
            Write-Host "  Error: $($_.Exception.Message)"
        }
    }

    Write-Host ""
    Write-Host "=== GET /stop (graceful shutdown) ==="
    try {
        $r6 = Invoke-WebRequest -Uri "http://127.0.0.1:$port/stop" -UseBasicParsing -TimeoutSec 5
        Write-Host "  Status: $($r6.StatusCode)"
        Write-Host "  Body: $($r6.Content)"
    } catch {
        Write-Host "  (stopped: $($_.Exception.Message))"
    }
} finally {
    Start-Sleep -Milliseconds 300
    if (-not $server.HasExited) {
        try { $server.Kill() } catch {}
    }
    try { $server.WaitForExit(2000) | Out-Null } catch {}

    Write-Host ""
    Write-Host "=== Server stdout ==="
    if (Test-Path "_http_server.out") { Get-Content "_http_server.out" | ForEach-Object { Write-Host "  $_" } }
    if (Test-Path "_http_server.err") {
        $errContent = Get-Content "_http_server.err"
        if ($errContent) {
            Write-Host "=== Server stderr ==="
            $errContent | ForEach-Object { Write-Host "  $_" }
        }
    }

    Remove-Item "http_demo.ll","http_demo.exe","_http_server.out","_http_server.err","nova_runtime.c" -Force -ErrorAction SilentlyContinue
}
