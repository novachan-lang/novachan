Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "http_min_server.nova" -TimeoutMs 60000
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; Write-Host $cr.StdErr; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o http_min_server.exe http_min_server.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000
if (!(Test-Path "http_min_server.exe")) { Write-Host "link failed"; exit 1 }

$port = 18791
$server = Start-Process -FilePath ".\http_min_server.exe" -ArgumentList "$port" -PassThru -WindowStyle Hidden -RedirectStandardOutput "_hm.out" -RedirectStandardError "_hm.err"
Start-Sleep -Milliseconds 700

try {
    $client = New-Object System.Net.Sockets.TcpClient
    $iar = $client.BeginConnect("127.0.0.1", $port, $null, $null)
    if (-not $iar.AsyncWaitHandle.WaitOne(3000)) { Write-Host "CONNECT TIMEOUT"; $client.Close() }
    else {
        $client.EndConnect($iar)
        $stream = $client.GetStream()
        $stream.ReadTimeout = 3000
        $req = "GET / HTTP/1.1`r`nHost: 127.0.0.1`r`nConnection: close`r`n`r`n"
        $bytes = [System.Text.Encoding]::ASCII.GetBytes($req)
        $stream.Write($bytes, 0, $bytes.Length); $stream.Flush()
        Start-Sleep -Milliseconds 300
        $buf = New-Object byte[] 4096
        try {
            $n = $stream.Read($buf, 0, $buf.Length)
            if ($n -gt 0) { Write-Host "RESPONSE ($n bytes): $([System.Text.Encoding]::ASCII.GetString($buf,0,$n))" }
            else { Write-Host "NO RESPONSE (0 bytes)" }
        } catch { Write-Host "READ EXC: $($_.Exception.Message)" }
        $client.Close()
    }
} catch { Write-Host "EXC: $($_.Exception.Message)" }
finally {
    Start-Sleep -Milliseconds 200
    if (-not $server.HasExited) { try { $server.Kill() } catch {} }
    try { $server.WaitForExit(2000) | Out-Null } catch {}
    Get-Process http_min_server -ErrorAction SilentlyContinue | ForEach-Object { try { $_.Kill() } catch {} }
    Write-Host "=== server stdout ==="
    if (Test-Path "_hm.out") { Get-Content "_hm.out" | ForEach-Object { Write-Host "  $_" } }
    if (Test-Path "_hm.err") { $e = Get-Content "_hm.err"; if ($e) { Write-Host "=== server stderr ==="; $e | ForEach-Object { Write-Host "  $_" } } }
    Remove-Item "http_min_server.exe","http_min_server.ll","nova_runtime.c","_hm.out","_hm.err" -Force -ErrorAction SilentlyContinue
}
