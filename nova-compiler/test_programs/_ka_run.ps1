# Deep I/O-throughput test: keep-alive server-saturating load. For each server carrier-count N, launch
# forge_load_server at NOVA_CARRIERS=N + RECLAIM, run _ka_load_client at NOVA_CARRIERS=8 (K keep-alive
# connections x M requests each on a reused socket), capture rps, kill the server. Prints rps per N + speedup.
. "$PSScriptRoot\_proc_util.ps1"
Set-Location $PSScriptRoot
$env:NOVA_HOME = (Resolve-Path "..").Path
$env:NOVA_NO_CACHE = "1"
if (-not $ClangPath) { $ClangPath = "clang" }
Get-Process forge_load_server,_ka_load_client -EA SilentlyContinue | Stop-Process -Force -EA SilentlyContinue

& $ClangPath -c -O2 output/nova_runtime.c -o _ka_rt.o -D_CRT_SECURE_NO_WARNINGS -w 2>$null
if (-not (Test-Path _ka_rt.o)) { Write-Host "RT BUILD FAIL"; exit 1 }
foreach ($t in @("forge_load_server","_ka_load_client")) {
  Remove-Item "$t.ll","$t.exe" -EA SilentlyContinue
  $r = Invoke-Timed -FilePath (Resolve-Path ./gen3_test.exe).Path -Arguments "$t.nova" -TimeoutMs 120000
  if (-not (Test-Path "$t.ll")) { Write-Host "$t COMPILE FAIL"; exit 1 }
  & $ClangPath -O2 -o "$t.exe" "$t.ll" _ka_rt.o -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
  Remove-Item "$t.ll" -EA SilentlyContinue
  if (-not (Test-Path "$t.exe")) { Write-Host "$t LINK FAIL"; exit 1 }
}
$srvExe = (Resolve-Path ./forge_load_server.exe).Path
$cliExe = (Resolve-Path ./_ka_load_client.exe).Path
$K = 256; $M = 80
$rps = @{}
foreach ($N in @(1,4,8)) {
  $port = 19150 + $N
  $env:PORT = "$port"
  $env:NOVA_CARRIERS = "$N"; $env:NOVA_SCHED_RECLAIM_TASK = "1"; $env:ROUNDS = "300000"
  $srv = Start-Process -FilePath $srvExe -PassThru -NoNewWindow -RedirectStandardOutput "_kasrv.txt" -RedirectStandardError "_kasrve.txt"
  Start-Sleep -Milliseconds 700
  $env:NOVA_CARRIERS = "8"; $env:HOST = "127.0.0.1"; $env:K = "$K"; $env:M = "$M"
  $cli = Start-Process -FilePath $cliExe -PassThru -NoNewWindow -RedirectStandardOutput "_kacli.txt" -RedirectStandardError "_kaclie.txt"
  if (-not $cli.WaitForExit(90000)) { cmd /c "taskkill /F /T /PID $($cli.Id)" | Out-Null; Write-Host "N=$N CLIENT HUNG" }
  $line = (Get-Content "_kacli.txt" -EA SilentlyContinue | Where-Object { $_ -match "^KA " })
  cmd /c "taskkill /F /T /PID $($srv.Id)" 2>$null | Out-Null
  Start-Sleep -Milliseconds 300
  if ($line -match "rps=(\d+)") { $rps[$N] = [int]$Matches[1] } else { $rps[$N] = 0 }
  Write-Host ("server N={0}: {1}" -f $N, $line)
}
Write-Host ""
Write-Host "=== KEEP-ALIVE /ping SPEEDUP vs N=1 ==="
$base = $rps[1]
foreach ($N in @(1,4,8)) {
  $sp = if ($base -gt 0) { [math]::Round($rps[$N] / $base, 2) } else { 0 }
  Write-Host ("  N={0}  rps={1}  speedup={2}x" -f $N, $rps[$N], $sp)
}
Remove-Item _ka_rt.o,_kasrv.txt,_kasrve.txt,_kacli.txt,_kaclie.txt -EA SilentlyContinue
