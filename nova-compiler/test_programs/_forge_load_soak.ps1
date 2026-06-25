# Forge N>1 throughput soak driver (NOVA_DESIGN/FORGE_N1_SOAK_PLAN.md). For each route x carrier-count N:
# start the server at NOVA_CARRIERS=N, the client at NOVA_CARRIERS=8 (so the client never bottlenecks),
# K*M requests, measure rps + correctness (bad). Kill-on-timeout MANDATORY (taskkill /F /T). Prints a
# per-cell line + a speedup-vs-N=1 table. Server stays up via its keepalive daemon (even at N=1).
param(
  [string]$Routes = "/cpu/,/ping/,/user/",
  [string]$Ns     = "1,2,4,8",
  [int]$K = 64,
  [int]$M = 200,
  [int]$Rounds = 300000,
  [int]$Warm = 10,
  [int]$ClientCarriers = 8,
  [int]$TimeoutMs = 120000
)
$ErrorActionPreference = "Continue"
$routeList = $Routes -split ","
$nList = ($Ns -split ",") | ForEach-Object { [int]$_ }
Get-Process forge_load_server,forge_load_client -EA SilentlyContinue | Stop-Process -Force
Start-Sleep -Milliseconds 300
$srvExe = (Resolve-Path ./forge_load_server.exe).Path
$cliExe = (Resolve-Path ./forge_load_client.exe).Path
$results = @{}
$cell = 0
foreach ($route in $routeList) {
  foreach ($N in $nList) {
    $port = 19000 + $cell * 7
    $cell++
    $env:NOVA_CARRIERS = "$N"; $env:PORT = "$port"; $env:ROUNDS = "$Rounds"
    $srv = Start-Process -FilePath $srvExe -PassThru -NoNewWindow -RedirectStandardOutput _so.txt -RedirectStandardError _se.txt
    # poll until the server accepts a connection (max 6s)
    $ready = $false; $waited = 0
    while ($waited -lt 6000 -and -not $ready) {
      try { $tc = New-Object Net.Sockets.TcpClient; $tc.Connect("127.0.0.1", $port); $tc.Close(); $ready = $true }
      catch { Start-Sleep -Milliseconds 150; $waited += 150 }
    }
    if (-not $ready) { Write-Host ("route={0,-7} N={1}  SERVER-NOT-READY" -f $route, $N); Stop-Process -Id $srv.Id -Force -EA SilentlyContinue; $results["$route|$N"] = @{ rps = 0; bad = -1 }; continue }
    $env:NOVA_CARRIERS = "$ClientCarriers"; $env:HOST = "127.0.0.1"; $env:PORT = "$port"; $env:ROUTE = "$route"; $env:K = "$K"; $env:M = "$M"; $env:WARM = "$Warm"
    $cli = Start-Process -FilePath $cliExe -PassThru -NoNewWindow -RedirectStandardOutput _co.txt -RedirectStandardError _ce.txt
    $hung = $false
    if (-not $cli.WaitForExit($TimeoutMs)) { cmd /c "taskkill /F /T /PID $($cli.Id)" 2>$null | Out-Null; $hung = $true }
    $out = (Get-Content _co.txt -EA SilentlyContinue) -join " "
    cmd /c "taskkill /F /T /PID $($srv.Id)" 2>$null | Out-Null
    Start-Sleep -Milliseconds 250
    $rps = 0; $bad = -1; $ok = -1; $ems = 0
    if ($out -match "rps=(\d+)") { $rps = [int]$Matches[1] }
    if ($out -match "bad=(\d+)") { $bad = [int]$Matches[1] }
    if ($out -match "ok=(\d+)") { $ok = [int]$Matches[1] }
    if ($out -match "elapsed_ms=(\d+)") { $ems = [int]$Matches[1] }
    $results["$route|$N"] = @{ rps = $rps; bad = $bad; ok = $ok; ems = $ems }
    $tag = if ($hung) { " HUNG" } else { "" }
    Write-Host ("route={0,-7} N={1}  rps={2,-8} ok={3,-6} bad={4,-5} elapsed_ms={5}{6}" -f $route, $N, $rps, $ok, $bad, $ems, $tag)
  }
}
Write-Host ""
Write-Host "=== SPEEDUP vs N=1 (rps(N)/rps(1)) ==="
foreach ($route in $routeList) {
  $base = $results["$route|1"].rps
  $line = "route=" + $route.PadRight(7)
  foreach ($N in $nList) {
    $r = $results["$route|$N"]
    $sp = if ($base -gt 0) { [math]::Round($r.rps / $base, 2) } else { 0 }
    $line += ("  N{0}={1}x(rps={2},bad={3})" -f $N, $sp, $r.rps, $r.bad)
  }
  Write-Host $line
}
Remove-Item _so.txt,_se.txt,_co.txt,_ce.txt -EA SilentlyContinue
