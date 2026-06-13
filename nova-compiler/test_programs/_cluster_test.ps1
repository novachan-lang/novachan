Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
$c = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "cluster_node.nova" -TimeoutMs 60000
if (-not (Test-Path cluster_node.ll)) { Write-Host ("COMPILE FAIL: " + $c.Stderr); exit 1 }
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o cluster_node.exe cluster_node.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
if (-not (Test-Path cluster_node.exe)) { Write-Host "LINK FAIL"; exit 1 }
$exe = (Resolve-Path ".\cluster_node.exe").Path
Remove-Item _cA.txt,_cB.txt,_cC.txt -ErrorAction SilentlyContinue
$A = Start-Process -FilePath $exe -ArgumentList "19050" -PassThru -NoNewWindow -RedirectStandardOutput "_cA.txt" -RedirectStandardError "_cAe.txt"
Start-Sleep -Milliseconds 400
$B = Start-Process -FilePath $exe -ArgumentList "19051","127.0.0.1:19050" -PassThru -NoNewWindow -RedirectStandardOutput "_cB.txt" -RedirectStandardError "_cBe.txt"
Start-Sleep -Milliseconds 150
$C = Start-Process -FilePath $exe -ArgumentList "19052","127.0.0.1:19050" -PassThru -NoNewWindow -RedirectStandardOutput "_cC.txt" -RedirectStandardError "_cCe.txt"
$deadline = (Get-Date).AddSeconds(15)
foreach ($p in @($A,$B,$C)) {
  $rem = ($deadline - (Get-Date)).TotalMilliseconds; if ($rem -le 0) { $rem = 1 }
  if (-not $p.WaitForExit([int]$rem)) { try { $p.Kill() } catch {}; Write-Host ("KILLED pid " + $p.Id) }
}
Start-Sleep -Milliseconds 200
$sets = @()
foreach ($f in @("_cA.txt","_cB.txt","_cC.txt")) {
  $out = (Get-Content $f -Raw); if (-not $out) { $out = "" }
  $m = [regex]::Match($out, "CONVERGED:(.+)")
  if ($m.Success) { $sets += $m.Groups[1].Value.Trim() } else { Write-Host ("NODE $f NOT CONVERGED: " + $out.Trim()) }
}
if ($sets.Count -eq 3) {
  $uniq = @($sets | Select-Object -Unique)
  if ($uniq.Count -eq 1) { Write-Host ("cluster_test PASSED: 3 nodes converged to the SAME set: " + $uniq[0]) }
  else { Write-Host "cluster_test FAILED: sets differ:"; $sets | ForEach-Object { Write-Host ("  " + $_) }; exit 1 }
} else { Write-Host ("cluster_test FAILED: only " + $sets.Count + "/3 converged"); exit 1 }
