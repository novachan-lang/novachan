param([switch]$NoKill)
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
if (-not (Test-Path cluster_fd_node.exe)) {
  $c = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "cluster_fd_node.nova" -TimeoutMs 60000
  if (-not (Test-Path cluster_fd_node.ll)) { Write-Host ("COMPILE FAIL: " + $c.StdErr); exit 1 }
  $l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o cluster_fd_node.exe cluster_fd_node.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
  if (-not (Test-Path cluster_fd_node.exe)) { Write-Host "LINK FAIL"; exit 1 }
}
$exe = (Resolve-Path ".\cluster_fd_node.exe").Path
Remove-Item _fA.txt,_fB.txt,_fC.txt -ErrorAction SilentlyContinue
$A = Start-Process -FilePath $exe -ArgumentList "19060" -PassThru -NoNewWindow -RedirectStandardOutput "_fA.txt" -RedirectStandardError "_fAe.txt"
Start-Sleep -Milliseconds 400
$B = Start-Process -FilePath $exe -ArgumentList "19061","127.0.0.1:19060" -PassThru -NoNewWindow -RedirectStandardOutput "_fB.txt" -RedirectStandardError "_fBe.txt"
Start-Sleep -Milliseconds 200
$C = Start-Process -FilePath $exe -ArgumentList "19062","127.0.0.1:19060" -PassThru -NoNewWindow -RedirectStandardOutput "_fC.txt" -RedirectStandardError "_fCe.txt"
Start-Sleep -Milliseconds 3500
if (-not $NoKill) { try { $C.Kill() } catch {}; Write-Host "killed C (19062) ~3.5s in" }
else { Write-Host "NO-KILL control: all 3 stay alive" }
$deadline = (Get-Date).AddSeconds(16)
foreach ($p in @($A,$B,$C)) {
  $rem = ($deadline - (Get-Date)).TotalMilliseconds; if ($rem -le 0) { $rem = 1 }
  if (-not $p.WaitForExit([int]$rem)) { try { $p.Kill() } catch {} }
}
Start-Sleep -Milliseconds 200
$oA = (Get-Content _fA.txt -Raw); if (-not $oA) { $oA = "" }
$oB = (Get-Content _fB.txt -Raw); if (-not $oB) { $oB = "" }
# extract the alive=[...] segment from each survivor's FINAL line
function AliveSeg($s) { $m = [regex]::Match($s, "alive=\[([^\]]*)\]"); if ($m.Success) { return $m.Groups[1].Value } else { return "<none>" } }
$aA = AliveSeg $oA; $aB = AliveSeg $oB
$ok = $true
foreach ($pair in @(@("A",$aA),@("B",$aB))) {
  $seg = $pair[1]
  $has60 = $seg -match "19060"; $has61 = $seg -match "19061"; $has62 = $seg -match "19062"
  if ($NoKill) {
    if ($has60 -and $has61 -and $has62) { Write-Host ("  $($pair[0]) alive=[$seg] (all 3 alive)") }
    else { Write-Host ("  $($pair[0]) FALSE-POSITIVE alive=[$seg] (a live node missing!)"); $ok = $false }
  } else {
    if ($has60 -and $has61 -and (-not $has62)) { Write-Host ("  $($pair[0]) alive=[$seg] (C=19062 correctly down)") }
    else { Write-Host ("  $($pair[0]) WRONG alive=[$seg] (expected 19060+19061, NOT 19062)"); $ok = $false }
  }
}
if ($ok) { Write-Host ("cluster_fd_test " + $(if($NoKill){"[NO-KILL] "}else{""}) + "PASSED") } else { Write-Host "cluster_fd_test FAILED"; exit 1 }
