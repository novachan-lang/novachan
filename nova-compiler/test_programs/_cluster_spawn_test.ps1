Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
if (-not (Test-Path cluster_spawn_node.exe)) {
  $c = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "cluster_spawn_node.nova" -TimeoutMs 60000
  if (-not (Test-Path cluster_spawn_node.ll)) { Write-Host ("COMPILE FAIL: " + $c.StdErr); exit 1 }
  $l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o cluster_spawn_node.exe cluster_spawn_node.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
  if (-not (Test-Path cluster_spawn_node.exe)) { Write-Host "LINK FAIL"; exit 1 }
}
$exe = (Resolve-Path ".\cluster_spawn_node.exe").Path
$ok = $true

# Phase 1 — distributed task placement: A is a worker, B drives. B converges, then cluster_spawns
# add(15,27) on the live peer A; A resolves "add" from its fn registry and replies 42.
Remove-Item _sA.txt,_sB.txt,_sAe.txt,_sBe.txt -ErrorAction SilentlyContinue
$A = Start-Process -FilePath $exe -ArgumentList "19080" -PassThru -NoNewWindow -RedirectStandardOutput "_sA.txt" -RedirectStandardError "_sAe.txt"
Start-Sleep -Milliseconds 400
$B = Start-Process -FilePath $exe -ArgumentList "19081","127.0.0.1:19080","drive" -PassThru -NoNewWindow -RedirectStandardOutput "_sB.txt" -RedirectStandardError "_sBe.txt"
$deadline = (Get-Date).AddSeconds(12)
foreach ($p in @($A,$B)) {
  $rem = ($deadline - (Get-Date)).TotalMilliseconds; if ($rem -le 0) { $rem = 1 }
  if (-not $p.WaitForExit([int]$rem)) { try { $p.Kill() } catch {} }
}
Start-Sleep -Milliseconds 200
$oB = (Get-Content _sB.txt -Raw); if (-not $oB) { $oB = "" }
if ($oB -match "RESULT=42 node=127\.0\.0\.1:19080") { Write-Host ("  [2-node] " + $oB.Trim() + "  (add ran on the live peer)") }
else { Write-Host ("  [2-node] WRONG driver output: " + $oB.Trim()); $ok = $false }

# Phase 2 — no-live-peer edge: a SOLO driver must NOT block; it reports an error and exits.
Remove-Item _sC.txt,_sCe.txt -ErrorAction SilentlyContinue
$C = Start-Process -FilePath $exe -ArgumentList "19082","drive" -PassThru -NoNewWindow -RedirectStandardOutput "_sC.txt" -RedirectStandardError "_sCe.txt"
if (-not $C.WaitForExit(9000)) { try { $C.Kill() } catch {}; Write-Host "  [solo] DRIVER HUNG (no-live-peer should return immediately, not block)"; $ok = $false }
else {
  $oC = (Get-Content _sC.txt -Raw); if (-not $oC) { $oC = "" }
  if ($oC -match "ERROR=no live peer") { Write-Host ("  [solo] " + $oC.Trim() + "  (no peer -> graceful error, no hang)") }
  else { Write-Host ("  [solo] WRONG solo output: " + $oC.Trim()); $ok = $false }
}

if ($ok) { Write-Host "cluster_spawn_test PASSED" } else { Write-Host "cluster_spawn_test FAILED"; exit 1 }
