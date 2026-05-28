Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "ws_echo_server.nova" -TimeoutMs 60000
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; Write-Host $cr.StdErr; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o ws_echo_server.exe ws_echo_server.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000
if (!(Test-Path "ws_echo_server.exe")) { Write-Host "link failed"; exit 1 }

$port = 18890
$server = Start-Process -FilePath ".\ws_echo_server.exe" -ArgumentList "$port" -PassThru -WindowStyle Hidden -RedirectStandardOutput "_ws.out" -RedirectStandardError "_ws.err"
Start-Sleep -Milliseconds 700

$pass = $true
$client = $null
try {
    $client = New-Object System.Net.Sockets.TcpClient
    $iar = $client.BeginConnect("127.0.0.1", $port, $null, $null)
    if (-not $iar.AsyncWaitHandle.WaitOne(3000)) { throw "connect timeout" }
    $client.EndConnect($iar)
    $stream = $client.GetStream()
    $stream.ReadTimeout = 3000

    # 1) Handshake with the RFC 6455 EXAMPLE key -> known accept (published oracle).
    $key = "dGhlIHNhbXBsZSBub25jZQ=="
    $expectedAccept = "s3pPLMBiTxaQ9kYGzzhZRbK+xOo="
    $handshake = "GET / HTTP/1.1`r`nHost: 127.0.0.1`r`nUpgrade: websocket`r`nConnection: Upgrade`r`nSec-WebSocket-Key: $key`r`nSec-WebSocket-Version: 13`r`n`r`n"
    $hb = [System.Text.Encoding]::ASCII.GetBytes($handshake)
    $stream.Write($hb, 0, $hb.Length); $stream.Flush()
    Start-Sleep -Milliseconds 200
    $rbuf = New-Object byte[] 2048
    $rn = $stream.Read($rbuf, 0, $rbuf.Length)
    $resp = [System.Text.Encoding]::ASCII.GetString($rbuf, 0, $rn)
    $statusLine = ($resp -split "`r`n")[0]
    Write-Host "handshake status: $statusLine"
    $acc = ""
    foreach ($ln in ($resp -split "`r`n")) {
        if ($ln -match "(?i)^Sec-WebSocket-Accept:\s*(.+)$") { $acc = $Matches[1].Trim() }
    }
    if ($acc -eq $expectedAccept) { Write-Host "ACCEPT OK: $acc (matches RFC 6455 published vector)" }
    else { Write-Host "ACCEPT MISMATCH: got '$acc' expected '$expectedAccept'"; $pass = $false }

    # Helper: send a masked client text frame
    function Send-WsText([string]$text) {
        $payload = [System.Text.Encoding]::UTF8.GetBytes($text)
        $plen = $payload.Length
        $mask = [byte[]](0x12, 0x34, 0x56, 0x78)
        $frame = New-Object System.Collections.Generic.List[byte]
        $frame.Add([byte]0x81)            # FIN + text
        $frame.Add([byte](0x80 -bor $plen)) # masked + len (len < 126 here)
        $frame.AddRange($mask)
        for ($i = 0; $i -lt $plen; $i++) { $frame.Add([byte]($payload[$i] -bxor $mask[$i % 4])) }
        $arr = $frame.ToArray()
        $stream.Write($arr, 0, $arr.Length); $stream.Flush()
    }
    # Helper: read one server text frame (unmasked) -> string
    function Recv-WsText() {
        $h = New-Object byte[] 2
        $g = 0; while ($g -lt 2) { $k = $stream.Read($h, $g, 2 - $g); if ($k -le 0) { return $null }; $g += $k }
        $len = $h[1] -band 0x7f
        $pl = New-Object byte[] $len
        $g = 0; while ($g -lt $len) { $k = $stream.Read($pl, $g, $len - $g); if ($k -le 0) { break }; $g += $k }
        return [System.Text.Encoding]::UTF8.GetString($pl, 0, $g)
    }

    foreach ($payload in @("hello NOVA", "second-12345")) {
        Send-WsText $payload
        Start-Sleep -Milliseconds 150
        $echo = Recv-WsText
        if ($echo -eq $payload) { Write-Host "ECHO OK: '$echo'" }
        else { Write-Host "ECHO MISMATCH: sent '$payload' got '$echo'"; $pass = $false }
    }
} catch { Write-Host "EXC: $($_.Exception.Message)"; $pass = $false }
finally {
    if ($client) { try { $client.Close() } catch {} }
    Start-Sleep -Milliseconds 200
    if (-not $server.HasExited) { try { $server.Kill() } catch {} }
    try { $server.WaitForExit(2000) | Out-Null } catch {}
    Get-Process ws_echo_server -ErrorAction SilentlyContinue | ForEach-Object { try { $_.Kill() } catch {} }
    Write-Host "=== server stdout ==="
    if (Test-Path "_ws.out") { Get-Content "_ws.out" | ForEach-Object { Write-Host "  $_" } }
    if (Test-Path "_ws.err") { $e = Get-Content "_ws.err"; if ($e) { Write-Host "=== server stderr ==="; $e | ForEach-Object { Write-Host "  $_" } } }
    Remove-Item "ws_echo_server.exe","ws_echo_server.ll","nova_runtime.c","_ws.out","_ws.err" -Force -ErrorAction SilentlyContinue
}
if ($pass) { Write-Host "RESULT: PASS" } else { Write-Host "RESULT: FAIL"; exit 1 }
