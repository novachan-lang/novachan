Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

# Build the demo server with the canonical compiler + current runtime.
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "http_demo.nova" -TimeoutMs 60000
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; Write-Host $cr.StdErr; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o http_demo.exe http_demo.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000
if (!(Test-Path "http_demo.exe")) { Write-Host "link failed"; exit 1 }

$port = 18790
$server = Start-Process -FilePath ".\http_demo.exe" -ArgumentList "$port" -PassThru -WindowStyle Hidden -RedirectStandardOutput "_hp.out" -RedirectStandardError "_hp.err"
Start-Sleep -Milliseconds 700

function Probe([string]$request, [string]$label) {
    Write-Host "=== $label ==="
    try {
        $client = New-Object System.Net.Sockets.TcpClient
        $iar = $client.BeginConnect("127.0.0.1", $port, $null, $null)
        if (-not $iar.AsyncWaitHandle.WaitOne(3000)) { Write-Host "  CONNECT TIMEOUT"; $client.Close(); return }
        $client.EndConnect($iar)
        $stream = $client.GetStream()
        $stream.ReadTimeout = 3000
        $bytes = [System.Text.Encoding]::ASCII.GetBytes($request)
        $stream.Write($bytes, 0, $bytes.Length)
        $stream.Flush()
        Start-Sleep -Milliseconds 200
        $buf = New-Object byte[] 4096
        $sb = New-Object System.Text.StringBuilder
        try {
            while ($true) {
                $n = $stream.Read($buf, 0, $buf.Length)
                if ($n -le 0) { break }
                [void]$sb.Append([System.Text.Encoding]::ASCII.GetString($buf, 0, $n))
                if ($sb.Length -gt 0 -and $n -lt $buf.Length) { break }
            }
        } catch { Write-Host "  READ: $($_.Exception.Message)" }
        $resp = $sb.ToString()
        if ($resp.Length -eq 0) { Write-Host "  NO RESPONSE (empty)" }
        else {
            $firstLine = ($resp -split "`r`n")[0]
            Write-Host "  STATUS LINE: $firstLine"
            Write-Host "  TOTAL BYTES: $($resp.Length)"
            $bodyIdx = $resp.IndexOf("`r`n`r`n")
            if ($bodyIdx -ge 0) { Write-Host "  BODY: $($resp.Substring($bodyIdx + 4))" }
        }
        $client.Close()
    } catch { Write-Host "  EXC: $($_.Exception.Message)" }
}

try {
    Probe "GET / HTTP/1.1`r`nHost: 127.0.0.1`r`nConnection: close`r`n`r`n" "GET /"
    Probe "GET /add?a=40&b=2 HTTP/1.1`r`nHost: 127.0.0.1`r`nConnection: close`r`n`r`n" "GET /add?a=40&b=2"
    Probe "POST /echo HTTP/1.1`r`nHost: 127.0.0.1`r`nContent-Length: 11`r`nConnection: close`r`n`r`nhello world" "POST /echo"
} finally {
    if (-not $server.HasExited) { try { $server.Kill() } catch {} }
    try { $server.WaitForExit(2000) | Out-Null } catch {}
    Get-Process http_demo -ErrorAction SilentlyContinue | ForEach-Object { try { $_.Kill() } catch {} }
    Write-Host "=== server stdout ==="
    if (Test-Path "_hp.out") { Get-Content "_hp.out" | ForEach-Object { Write-Host "  $_" } }
    if (Test-Path "_hp.err") { $e = Get-Content "_hp.err"; if ($e) { Write-Host "=== server stderr ==="; $e | ForEach-Object { Write-Host "  $_" } } }
    Remove-Item "http_demo.exe","http_demo.ll","nova_runtime.c","_hp.out","_hp.err" -Force -ErrorAction SilentlyContinue
}
