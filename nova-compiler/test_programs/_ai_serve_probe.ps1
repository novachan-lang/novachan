Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "ai_serve.nova" -TimeoutMs 60000
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; Write-Host $cr.StdErr; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o ai_serve.exe ai_serve.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000
if (!(Test-Path "ai_serve.exe")) { Write-Host "link failed"; exit 1 }

$port = 18950
$server = Start-Process -FilePath ".\ai_serve.exe" -ArgumentList "$port" -PassThru -WindowStyle Hidden -RedirectStandardOutput "_ai.out" -RedirectStandardError "_ai.err"
Start-Sleep -Milliseconds 700

$pass = $true
function Send-Http([string]$request) {
    $client = New-Object System.Net.Sockets.TcpClient
    $iar = $client.BeginConnect("127.0.0.1", $port, $null, $null)
    if (-not $iar.AsyncWaitHandle.WaitOne(3000)) { $client.Close(); return $null }
    $client.EndConnect($iar)
    $stream = $client.GetStream(); $stream.ReadTimeout = 3000
    $bytes = [System.Text.Encoding]::ASCII.GetBytes($request)
    $stream.Write($bytes, 0, $bytes.Length); $stream.Flush()
    Start-Sleep -Milliseconds 250
    $buf = New-Object byte[] 4096
    $sb = New-Object System.Text.StringBuilder
    try { while ($true) { $n = $stream.Read($buf,0,$buf.Length); if ($n -le 0){break}; [void]$sb.Append([System.Text.Encoding]::ASCII.GetString($buf,0,$n)); if ($n -lt $buf.Length){break} } } catch {}
    $client.Close()
    return $sb.ToString()
}

try {
    # POST /predict with float features. features=[1,2], W gives logits [1,4,2] -> class 1.
    $body = '{"features":[1.0,2.0]}'
    $clen = [System.Text.Encoding]::ASCII.GetByteCount($body)
    $req = "POST /predict HTTP/1.1`r`nHost: 127.0.0.1`r`nContent-Type: application/json`r`nContent-Length: $clen`r`nConnection: close`r`n`r`n$body"
    $resp = Send-Http $req
    Write-Host "POST /predict response:"
    $bodyIdx = $resp.IndexOf("`r`n`r`n")
    $respBody = if ($bodyIdx -ge 0) { $resp.Substring($bodyIdx + 4) } else { $resp }
    Write-Host "  body: $respBody"
    if ($respBody -match '"class"\s*:\s*1') { Write-Host "PREDICTION OK: class=1 (hand-computed)" }
    else { Write-Host "PREDICTION WRONG"; $pass = $false }
} catch { Write-Host "EXC: $($_.Exception.Message)"; $pass = $false }
finally {
    try { Send-Http "GET /stop HTTP/1.1`r`nHost: 127.0.0.1`r`nConnection: close`r`n`r`n" | Out-Null } catch {}
    Start-Sleep -Milliseconds 300
    if (-not $server.HasExited) { try { $server.Kill() } catch {} }
    try { $server.WaitForExit(2000) | Out-Null } catch {}
    Get-Process ai_serve -ErrorAction SilentlyContinue | ForEach-Object { try { $_.Kill() } catch {} }
    Write-Host "=== server stdout ==="
    if (Test-Path "_ai.out") { Get-Content "_ai.out" | ForEach-Object { Write-Host "  $_" } }
    if (Test-Path "_ai.err") { $e = Get-Content "_ai.err"; if ($e) { Write-Host "=== stderr ==="; $e | ForEach-Object { Write-Host "  $_" } } }
    Remove-Item "ai_serve.exe","ai_serve.ll","nova_runtime.c","_ai.out","_ai.err","serve_w.txt" -Force -ErrorAction SilentlyContinue
}
if ($pass) { Write-Host "RESULT: PASS" } else { Write-Host "RESULT: FAIL"; exit 1 }
