# #9 TLS-server oracle. Provisions a self-signed cert in CurrentUser\My + a PFX, builds the NOVA TLS
# server, runs it as its own process, and drives it with a separate-process .NET TLS client (skips
# validation, so the self-signed cert needs no trust store). Verifies the encrypted round-trip, then
# cleans up. SKIPs (exit 0) if cert provisioning is unavailable.
Set-Location $PSScriptRoot
$pass = "novatest"; $port = 18094
$pfxPath = Join-Path $PSScriptRoot "_tls_test.pfx"
$cert = $null
try {
    $cert = New-SelfSignedCertificate -DnsName "127.0.0.1" -CertStoreLocation Cert:\CurrentUser\My `
        -KeyExportPolicy Exportable -NotAfter (Get-Date).AddDays(2) -ErrorAction Stop
    $sec = ConvertTo-SecureString -String $pass -Force -AsPlainText
    Export-PfxCertificate -Cert $cert -FilePath $pfxPath -Password $sec -ErrorAction Stop | Out-Null
} catch {
    Write-Host "TLS_SERVER_SKIP: cert provisioning unavailable ($($_.Exception.Message))"
    if ($cert) { Remove-Item ("Cert:\CurrentUser\My\" + $cert.Thumbprint) -Force -EA SilentlyContinue }
    exit 0
}
function Cleanup { Remove-Item $pfxPath -Force -EA SilentlyContinue; Remove-Item ("Cert:\CurrentUser\My\" + $cert.Thumbprint) -Force -EA SilentlyContinue }

# Build the NOVA server exe via the committed compiler + clang (runtime pragmas pull secur32/crypt32/ws2_32).
& .\gen3_test.exe _tls_server_test.nova 2>&1 | Out-Null
clang -O0 -o _tls_server_test.exe _tls_server_test.ll ..\compiler\nova_runtime.c -lws2_32 -lbcrypt -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>&1 | Out-Null
if (-not (Test-Path _tls_server_test.exe)) { Write-Host "TLS_SERVER_FAIL: server build failed"; Cleanup; exit 1 }

$srv = Start-Process -FilePath .\_tls_server_test.exe -PassThru -NoNewWindow -RedirectStandardOutput _tls_srv_out.txt -RedirectStandardError _tls_srv_err.txt
Start-Sleep -Seconds 2
$resp = ""
try {
    $tcp = New-Object System.Net.Sockets.TcpClient
    $tcp.Connect("127.0.0.1", $port)
    $cb = [System.Net.Security.RemoteCertificateValidationCallback]{ param($s,$c,$ch,$e) $true }
    $ssl = New-Object System.Net.Security.SslStream($tcp.GetStream(), $false, $cb)
    $ssl.AuthenticateAsClient("127.0.0.1")
    $w = [System.Text.Encoding]::ASCII.GetBytes("ping")
    $ssl.Write($w, 0, $w.Length); $ssl.Flush()
    $buf = New-Object byte[] 1024
    $n = $ssl.Read($buf, 0, $buf.Length)
    $resp = [System.Text.Encoding]::ASCII.GetString($buf, 0, $n)
    $ssl.Close(); $tcp.Close()
} catch { Write-Host "TLS client error: $($_.Exception.Message)" }
if (-not $srv.WaitForExit(4000)) { $srv.Kill() }
Write-Host ("server stdout: " + ((Get-Content _tls_srv_out.txt -EA SilentlyContinue) -join ' '))
Remove-Item _tls_srv_out.txt,_tls_srv_err.txt -Force -EA SilentlyContinue
Cleanup
if ($resp -eq "pong:ping") { Write-Host "TLS_SERVER_OK (encrypted round-trip)"; exit 0 }
else { Write-Host "TLS_SERVER_FAIL resp=[$resp]"; exit 1 }
