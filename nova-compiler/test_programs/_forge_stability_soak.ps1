# Forge N>1 STABILITY soak: one long-lived server at NOVA_CARRIERS=N under sustained batched load,
# sampling the server's PrivateMemorySize64 between batches to detect a slow leak (per-request arena =
# flat memory => RSS must PLATEAU, not climb). Also asserts bad=0 throughout (correctness under sustained
# load) and no hang. External RSS is the leak signal (the in-process live_count() probe is racy at N>1
# until C2 lands). Kill-on-timeout mandatory.
param(
  [int]$N = 4,
  [string]$Route = "/ping/",
  [int]$K = 64,
  [int]$M = 300,
  [int]$Batches = 10,
  [int]$Rounds = 50000,
  [int]$TimeoutMs = 60000
)
$ErrorActionPreference = "Continue"
Get-Process forge_load_server,forge_load_client -EA SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 300
$srvExe = (Resolve-Path ./forge_load_server.exe).Path
$cliExe = (Resolve-Path ./forge_load_client.exe).Path
$port = 19500
$env:NOVA_CARRIERS = "$N"; $env:PORT = "$port"; $env:ROUNDS = "$Rounds"
$srv = Start-Process -FilePath $srvExe -PassThru -NoNewWindow -RedirectStandardOutput _sso.txt -RedirectStandardError _sse.txt
$ready = $false; $waited = 0
while ($waited -lt 6000 -and -not $ready) {
  try { $tc = New-Object Net.Sockets.TcpClient; $tc.Connect("127.0.0.1", $port); $tc.Close(); $ready = $true }
  catch { Start-Sleep -Milliseconds 150; $waited += 150 }
}
if (-not $ready) { Write-Host "SERVER-NOT-READY"; Stop-Process -Id $srv.Id -Force -EA SilentlyContinue; exit 1 }
Write-Host ("stability soak: server N={0} route={1} K={2} M={3} x {4} batches = {5} requests" -f $N, $Route, $K, $M, $Batches, ($K*$M*$Batches))
$env:HOST = "127.0.0.1"; $env:PORT = "$port"; $env:ROUTE = "$Route"; $env:K = "$K"; $env:M = "$M"; $env:WARM = "0"; $env:NOVA_CARRIERS = "8"
$rssSamples = @(); $totalBad = 0; $hung = $false
for ($b = 0; $b -lt $Batches; $b++) {
  $cli = Start-Process -FilePath $cliExe -PassThru -NoNewWindow -RedirectStandardOutput _sco.txt -RedirectStandardError _sce.txt
  if (-not $cli.WaitForExit($TimeoutMs)) { cmd /c "taskkill /F /T /PID $($cli.Id)" 2>$null | Out-Null; $hung = $true; break }
  $out = (Get-Content _sco.txt -EA SilentlyContinue) -join " "
  if ($out -match "bad=(\d+)") { $totalBad += [int]$Matches[1] }
  try { $srv.Refresh(); $rss = [math]::Round($srv.PrivateMemorySize64 / 1MB, 1) } catch { $rss = -1 }
  $rssSamples += $rss
  $rpsStr = if ($out -match "rps=(\d+)") { $Matches[1] } else { "?" }
  Write-Host ("  batch {0,2}: rss={1,7} MB  rps={2,-7} bad-so-far={3}" -f $b, $rss, $rpsStr, $totalBad)
}
cmd /c "taskkill /F /T /PID $($srv.Id)" 2>$null | Out-Null
Start-Sleep -Milliseconds 250
Write-Host ""
if ($hung) { Write-Host "=== STABILITY: FAIL (client hung) ==="; exit 1 }
$valid = $rssSamples | Where-Object { $_ -ge 0 }
if ($valid.Count -ge 3) {
  $first = $valid[1]   # skip batch 0 (warmup growth)
  $last = $valid[-1]
  $peak = ($valid | Measure-Object -Maximum).Maximum
  $growth = if ($first -gt 0) { [math]::Round(($last - $first) / $first * 100, 1) } else { 0 }
  Write-Host ("RSS: post-warmup={0}MB  final={1}MB  peak={2}MB  growth={3}%" -f $first, $last, $peak, $growth)
  $leakFree = ($growth -lt 10)
  Write-Host ("=== STABILITY: {0}  (bad={1}, no hang, RSS {2}) ===" -f $(if($leakFree -and $totalBad -eq 0){"PASS"}else{"REVIEW"}), $totalBad, $(if($leakFree){"plateaus"}else{"CLIMBS - investigate"}))
} else { Write-Host "=== STABILITY: RSS samples unavailable ===" }
Remove-Item _sso.txt,_sse.txt,_sco.txt,_sce.txt -EA SilentlyContinue
