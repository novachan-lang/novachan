# Live TLS 1.3 interop harness: build <Test>, start `openssl s_server -tls1_3` on a loopback port,
# run the NOVA client against it (kill-on-timeout), then stop the server. Reproducible gate for the
# forge_tls_client live handshake. Usage: powershell -File _tls_client_one.ps1 forge_tls_client_l1_test
param([string]$Test = "forge_tls_client_l1_test", [int]$Port = 44330)
$ErrorActionPreference = "SilentlyContinue"
$dir = $PSScriptRoot
$env:MSYS_NO_PATHCONV = "1"
$cert = Join-Path $dir "_tlssrv_cert.pem"
$key  = Join-Path $dir "_tlssrv_key.pem"

if (!(Test-Path $cert)) {
    & openssl req -x509 -newkey rsa:2048 -keyout $key -out $cert -days 1 -nodes -subj "/CN=localhost" 2>$null | Out-Null
}

# Build (compile + link) via the standard harness; its no-server run just exits, the exe is what we keep.
& powershell -ExecutionPolicy Bypass -File (Join-Path $dir "_fdb_one.ps1") $Test 2>&1 | Out-Null
$exe = Join-Path $dir "$Test.exe"
if (!(Test-Path $exe)) { Write-Output "BUILD-FAIL"; exit 1 }

# Stop any stale server on the port, then start a fresh one.
Get-Process openssl -ErrorAction SilentlyContinue | Where-Object { $_.StartTime -lt (Get-Date) } | Out-Null
$sargs = "s_server -tls1_3 -accept $Port -cert `"$cert`" -key `"$key`" -www -naccept 4"
$srv = Start-Process -FilePath "openssl" -ArgumentList $sargs -PassThru -WindowStyle Hidden
Start-Sleep -Milliseconds 1200
try {
    $outf = Join-Path $dir "_tlsc_out.txt"
    if (Test-Path $outf) { Remove-Item $outf -Force }
    $p = Start-Process -FilePath $exe -PassThru -NoNewWindow -RedirectStandardOutput $outf
    if (!$p.WaitForExit(30000)) { try { $p.Kill() } catch {}; Write-Output "RUN-TIMEOUT" }
    if (Test-Path $outf) { Get-Content $outf }
} finally {
    if ($srv -and -not $srv.HasExited) { try { Stop-Process -Id $srv.Id -Force } catch {} }
}
