$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1"
$ps=New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName="$dir\gen3_test.exe";$ps.Arguments="nova_compiler.nova";$ps.WorkingDirectory=$dir
$ps.UseShellExecute=$false;$ps.RedirectStandardOutput=$true;$ps.RedirectStandardError=$true;$ps.CreateNoWindow=$true
$pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$ps;$pr.Start()|Out-Null
$co=$pr.StandardOutput.ReadToEndAsync();$ce=$pr.StandardError.ReadToEndAsync()
if(-not $pr.WaitForExit(450000)){$pr.Kill();Write-Host "gen3 TIMEOUT";exit 1}
[System.Threading.Tasks.Task]::WaitAll($co,$ce)
if($pr.ExitCode -ne 0){Write-Host "gen3 FAIL: $($ce.Result)";exit 1}
& clang -O2 -o "$dir\gen4_check.exe" "$dir\nova_compiler.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
& clang -O2 -c -o "$dir\_rtchk.o" "$dir\output\nova_runtime.c" -D_CRT_SECURE_NO_WARNINGS -w 2>$null
# compile stacktracex (with sleep) using gen4_check
$p=New-Object System.Diagnostics.ProcessStartInfo
$p.FileName="$dir\gen4_check.exe";$p.Arguments="stacktracex.nova";$p.WorkingDirectory=$dir
$p.UseShellExecute=$false;$p.RedirectStandardOutput=$true;$p.RedirectStandardError=$true;$p.CreateNoWindow=$true
$pp=[System.Diagnostics.Process]::new();$pp.StartInfo=$p;$pp.Start()|Out-Null
$pp.WaitForExit(60000)|Out-Null
& clang -O2 -o "$dir\_stk_uw2.exe" "$dir\stacktracex.ll" "$dir\_rtchk.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
Write-Host "uwtable in stacktracex.ll: $((Select-String -Path "$dir\stacktracex.ll" -Pattern 'nounwind uwtable').Count)"
Write-Host "=== with-sleep stacktracex 50x (post-uwtable) ==="
$crash=0;$fail=0;$ok=0
for($i=0;$i -lt 50;$i++){
  $q=New-Object System.Diagnostics.ProcessStartInfo
  $q.FileName="$dir\_stk_uw2.exe";$q.WorkingDirectory=$dir
  $q.UseShellExecute=$false;$q.RedirectStandardOutput=$true;$q.RedirectStandardError=$true;$q.CreateNoWindow=$true
  $qp=[System.Diagnostics.Process]::new();$qp.StartInfo=$q;$qp.Start()|Out-Null
  $o=$qp.StandardOutput.ReadToEndAsync();$er=$qp.StandardError.ReadToEndAsync()
  if(-not $qp.WaitForExit(15000)){$qp.Kill();continue}
  [System.Threading.Tasks.Task]::WaitAll($o,$er)
  if($qp.ExitCode -eq 0){$ok++}
  elseif(($qp.ExitCode -band 0xFFFFFFFF) -eq 0xC0000028){$crash++}
  else{$fail++}
}
Write-Host "ok=$ok  BAD_STACK_crash=$crash  clean-fail(exit1)=$fail  of 50"
