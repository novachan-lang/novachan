Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
if (-not (Test-Path cluster_leave_node.exe)) {
  $c = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "cluster_leave_node.nova" -TimeoutMs 60000
  if (-not (Test-Path cluster_leave_node.ll)) { Write-Host ("COMPILE FAIL: " + $c.StdErr); exit 1 }
  $l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o cluster_leave_node.exe cluster_leave_node.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
  if (-not (Test-Path cluster_leave_node.exe)) { Write-Host "LINK FAIL"; exit 1 }
}
$exe = (Resolve-Path ".\cluster_leave_node.exe").Path
function AliveSeg($s) { $m = [regex]::Match($s, "alive=\[([^\]]*)\]"); if ($m.Success) { return $m.Groups[1].Value } else { return "<none>" } }

# Phase runner: launches A(observer,19070) + B(observer,19071) + C(19072). C is either a
# graceful leaver (extra "leave" arg) or, in crash mode, a plain observer the harness kills
# at 2.5s. Observers read their liveness view at 4.0s and print FINAL alive=[...].
function Run-Phase($cMode) {
  Remove-Item _lA.txt,_lB.txt,_lC.txt,_lAe.txt,_lBe.txt,_lCe.txt -ErrorAction SilentlyContinue
  $A = Start-Process -FilePath $exe -ArgumentList "19070" -PassThru -NoNewWindow -RedirectStandardOutput "_lA.txt" -RedirectStandardError "_lAe.txt"
  Start-Sleep -Milliseconds 400
  $B = Start-Process -FilePath $exe -ArgumentList "19071","127.0.0.1:19070" -PassThru -NoNewWindow -RedirectStandardOutput "_lB.txt" -RedirectStandardError "_lBe.txt"
  Start-Sleep -Milliseconds 200
  if ($cMode -eq "leave") {
    $C = Start-Process -FilePath $exe -ArgumentList "19072","127.0.0.1:19070","leave" -PassThru -NoNewWindow -RedirectStandardOutput "_lC.txt" -RedirectStandardError "_lCe.txt"
  } else {
    $C = Start-Process -FilePath $exe -ArgumentList "19072","127.0.0.1:19070" -PassThru -NoNewWindow -RedirectStandardOutput "_lC.txt" -RedirectStandardError "_lCe.txt"
    Start-Sleep -Milliseconds 2500   # crash control: kill C at ~2.5s (same instant the leaver departs)
    try { $C.Kill() } catch {}
  }
  $deadline = (Get-Date).AddSeconds(10)
  foreach ($p in @($A,$B,$C)) {
    $rem = ($deadline - (Get-Date)).TotalMilliseconds; if ($rem -le 0) { $rem = 1 }
    if (-not $p.WaitForExit([int]$rem)) { try { $p.Kill() } catch {} }
  }
  Start-Sleep -Milliseconds 200
  $oA = (Get-Content _lA.txt -Raw); if (-not $oA) { $oA = "" }
  $oB = (Get-Content _lB.txt -Raw); if (-not $oB) { $oB = "" }
  $oC = (Get-Content _lC.txt -Raw); if (-not $oC) { $oC = "" }
  return @{ A = (AliveSeg $oA); B = (AliveSeg $oB); C = $oC }
}

$ok = $true

# Phase 1 — graceful leave: C departs at 2.5s; both observers must see C (19072) DOWN by 4.0s.
$g = Run-Phase "leave"
if ($g.C -notmatch "LEFT") { Write-Host ("  [graceful] C did not leave cleanly: " + $g.C.Trim()); $ok = $false }
else { Write-Host "  [graceful] C left cleanly (port=19072)" }
foreach ($pair in @(@("A",$g.A),@("B",$g.B))) {
  $seg = $pair[1]
  if (($seg -match "19070") -and ($seg -match "19071") -and (-not ($seg -match "19072"))) {
    Write-Host ("  [graceful] $($pair[0]) alive=[$seg] (C down via broadcast)")
  } else { Write-Host ("  [graceful] $($pair[0]) WRONG alive=[$seg] (expected 19070+19071, NOT 19072)"); $ok = $false }
}

# Phase 2 — crash control: C is KILLED (no broadcast) at the same 2.5s. At the 4.0s read the
# timeout has NOT fired, so observers must STILL see C alive. This proves the read precedes the
# crash-timeout — hence phase 1's "C down" is the graceful BROADCAST, not a timeout coincidence.
$x = Run-Phase "crash"
foreach ($pair in @(@("A",$x.A),@("B",$x.B))) {
  $seg = $pair[1]
  if (($seg -match "19070") -and ($seg -match "19071") -and ($seg -match "19072")) {
    Write-Host ("  [control] $($pair[0]) alive=[$seg] (crashed C still alive => read precedes timeout)")
  } else { Write-Host ("  [control] $($pair[0]) UNEXPECTED alive=[$seg] (crashed C should still be alive at 4.0s)"); $ok = $false }
}

if ($ok) { Write-Host "cluster_leave_test PASSED" } else { Write-Host "cluster_leave_test FAILED"; exit 1 }
