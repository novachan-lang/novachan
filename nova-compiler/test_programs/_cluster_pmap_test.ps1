Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
if (-not (Test-Path cluster_pmap_node.exe)) {
  $c = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "cluster_pmap_node.nova" -TimeoutMs 60000
  if (-not (Test-Path cluster_pmap_node.ll)) { Write-Host ("COMPILE FAIL: " + $c.StdErr); exit 1 }
  $l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o cluster_pmap_node.exe cluster_pmap_node.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
  if (-not (Test-Path cluster_pmap_node.exe)) { Write-Host "LINK FAIL"; exit 1 }
}
$exe = (Resolve-Path ".\cluster_pmap_node.exe").Path
$ok = $true

function DrainExit($procs, $secs) {
  $deadline = (Get-Date).AddSeconds($secs)
  foreach ($p in $procs) {
    $rem = ($deadline - (Get-Date)).TotalMilliseconds; if ($rem -le 0) { $rem = 1 }
    if (-not $p.WaitForExit([int]$rem)) { try { $p.Kill() } catch {} }
  }
  Start-Sleep -Milliseconds 200
}

# Phase 1 — ordered scatter-gather: W1(seed) + W2 + driver. The driver pmaps add over
# [[1,2],[3,4],[5,6]] round-robin across the 2 live workers; results gather IN INPUT ORDER.
Remove-Item _pD.txt,_pW1.txt,_pW2.txt,_pDe.txt,_pW1e.txt,_pW2e.txt -ErrorAction SilentlyContinue
$W1 = Start-Process -FilePath $exe -ArgumentList "19091" -PassThru -NoNewWindow -RedirectStandardOutput "_pW1.txt" -RedirectStandardError "_pW1e.txt"
Start-Sleep -Milliseconds 400
$W2 = Start-Process -FilePath $exe -ArgumentList "19092","127.0.0.1:19091" -PassThru -NoNewWindow -RedirectStandardOutput "_pW2.txt" -RedirectStandardError "_pW2e.txt"
Start-Sleep -Milliseconds 200
$D  = Start-Process -FilePath $exe -ArgumentList "19090","127.0.0.1:19091","drive" -PassThru -NoNewWindow -RedirectStandardOutput "_pD.txt" -RedirectStandardError "_pDe.txt"
DrainExit @($D,$W1,$W2) 12
$oD = (Get-Content _pD.txt -Raw); if (-not $oD) { $oD = "" }
if ($oD -match "PMAP=3,7,11") { Write-Host ("  [3-node] " + $oD.Trim() + "  (ordered gather across 2 workers)") }
else { Write-Host ("  [3-node] WRONG driver output: " + $oD.Trim()); $ok = $false }

# Phase 2 — no-live-peer: a SOLO driver must report an error and EXIT, not block.
Remove-Item _pS.txt,_pSe.txt -ErrorAction SilentlyContinue
$S = Start-Process -FilePath $exe -ArgumentList "19090","drive" -PassThru -NoNewWindow -RedirectStandardOutput "_pS.txt" -RedirectStandardError "_pSe.txt"
if (-not $S.WaitForExit(9000)) { try { $S.Kill() } catch {}; Write-Host "  [solo] DRIVER HUNG (no live peer should return immediately)"; $ok = $false }
else {
  $oS = (Get-Content _pS.txt -Raw); if (-not $oS) { $oS = "" }
  if ($oS -match "ERROR=no live peer") { Write-Host ("  [solo] " + $oS.Trim() + "  (no peer -> graceful error, no hang)") }
  else { Write-Host ("  [solo] WRONG solo output: " + $oS.Trim()); $ok = $false }
}

# Phase 3 — dead peer mid-batch: kill W2 (19092) at 2.5s, just before the driver's 2.8s batch
# and well within the 4s failure-detection timeout, so W2 is STILL in cluster_alive (believed
# live) and gets a task. Its slot must ERROR while the live worker's slots return -- the batch
# must NOT hang on the dead slot. Round-robin over sorted [19091,19092]: task0->W1, task1->W2
# (dead), task2->W1  =>  PMAP=3,ERR,11.
Remove-Item _pD.txt,_pW1.txt,_pW2.txt,_pDe.txt,_pW1e.txt,_pW2e.txt -ErrorAction SilentlyContinue
$W1 = Start-Process -FilePath $exe -ArgumentList "19091" -PassThru -NoNewWindow -RedirectStandardOutput "_pW1.txt" -RedirectStandardError "_pW1e.txt"
Start-Sleep -Milliseconds 400
$W2 = Start-Process -FilePath $exe -ArgumentList "19092","127.0.0.1:19091" -PassThru -NoNewWindow -RedirectStandardOutput "_pW2.txt" -RedirectStandardError "_pW2e.txt"
Start-Sleep -Milliseconds 200
$D  = Start-Process -FilePath $exe -ArgumentList "19090","127.0.0.1:19091","drive" -PassThru -NoNewWindow -RedirectStandardOutput "_pD.txt" -RedirectStandardError "_pDe.txt"
Start-Sleep -Milliseconds 1900   # ~2.5s after W2 start: converged, W2 still well inside the FD timeout
try { $W2.Kill() } catch {}
DrainExit @($D,$W1) 12
try { if (-not $W2.HasExited) { $W2.Kill() } } catch {}
$oD = (Get-Content _pD.txt -Raw); if (-not $oD) { $oD = "" }
if ($oD -match "PMAP=3,ERR,11") { Write-Host ("  [kill-mid] " + $oD.Trim() + "  (dead peer's slot errored, live slots returned, no hang, order kept)") }
else { Write-Host ("  [kill-mid] WRONG driver output (want PMAP=3,ERR,11): " + $oD.Trim()); $ok = $false }

if ($ok) { Write-Host "cluster_pmap_test PASSED" } else { Write-Host "cluster_pmap_test FAILED"; exit 1 }
