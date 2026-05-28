Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "node_echo_server.nova" -TimeoutMs 60000
if ($cr.ExitCode -ne 0) { Write-Host "compile failed"; Write-Host $cr.StdErr; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o node_echo_server.exe node_echo_server.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000
if (!(Test-Path "node_echo_server.exe")) { Write-Host "link failed"; exit 1 }

$port = 18920
$server = Start-Process -FilePath ".\node_echo_server.exe" -ArgumentList "$port" -PassThru -WindowStyle Hidden -RedirectStandardOutput "_nd.out" -RedirectStandardError "_nd.err"
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

    # Send a length-framed JSON message: [4-byte BE length][payload]
    $json = '{"cmd":"ping","n":5}'
    $payload = [System.Text.Encoding]::UTF8.GetBytes($json)
    $len = $payload.Length
    $b0 = [byte](($len -shr 24) -band 0xFF)
    $b1 = [byte](($len -shr 16) -band 0xFF)
    $b2 = [byte](($len -shr 8) -band 0xFF)
    $b3 = [byte]($len -band 0xFF)
    $hdr = [byte[]]@($b0, $b1, $b2, $b3)
    $stream.Write($hdr, 0, 4)
    $stream.Write($payload, 0, $payload.Length)
    $stream.Flush()

    # Read the framed response.
    $rh = New-Object byte[] 4
    $g = 0; while ($g -lt 4) { $k = $stream.Read($rh, $g, 4 - $g); if ($k -le 0) { break }; $g += $k }
    if ($g -lt 4) { Write-Host "NO LENGTH HEADER"; $pass = $false }
    else {
        $rlen = ([int]$rh[0] -shl 24) -bor ([int]$rh[1] -shl 16) -bor ([int]$rh[2] -shl 8) -bor [int]$rh[3]
        Write-Host "response length: $rlen"
        $rb = New-Object byte[] $rlen
        $g = 0; while ($g -lt $rlen) { $k = $stream.Read($rb, $g, $rlen - $g); if ($k -le 0) { break }; $g += $k }
        $resp = [System.Text.Encoding]::UTF8.GetString($rb, 0, $g)
        Write-Host "response json: $resp"
        # Oracle: round-trip must preserve the fields (and n:5 must be the int 5, not garbage).
        if ($resp -match '"cmd"' -and $resp -match '"ping"' -and $resp -match '"n"' -and $resp -match '(:|\s)5(,|\})') {
            Write-Host "ROUND-TRIP OK: cmd=ping, n=5 preserved"
        } else { Write-Host "ROUND-TRIP MISMATCH"; $pass = $false }
    }
} catch { Write-Host "EXC: $($_.Exception.Message)"; $pass = $false }
finally {
    if ($client) { try { $client.Close() } catch {} }
    Start-Sleep -Milliseconds 200
    if (-not $server.HasExited) { try { $server.Kill() } catch {} }
    try { $server.WaitForExit(2000) | Out-Null } catch {}
    Get-Process node_echo_server -ErrorAction SilentlyContinue | ForEach-Object { try { $_.Kill() } catch {} }
    Write-Host "=== server stdout ==="
    if (Test-Path "_nd.out") { Get-Content "_nd.out" | ForEach-Object { Write-Host "  $_" } }
    if (Test-Path "_nd.err") { $e = Get-Content "_nd.err"; if ($e) { Write-Host "=== server stderr ==="; $e | ForEach-Object { Write-Host "  $_" } } }
    Remove-Item "node_echo_server.exe","node_echo_server.ll","nova_runtime.c","_nd.out","_nd.err" -Force -ErrorAction SilentlyContinue
}
if ($pass) { Write-Host "RESULT: PASS" } else { Write-Host "RESULT: FAIL"; exit 1 }
