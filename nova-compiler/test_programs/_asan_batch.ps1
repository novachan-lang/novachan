param([string]$t)
$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1"
$ps=New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName="$dir\gen4_test.exe";$ps.Arguments="$t.nova";$ps.WorkingDirectory=$dir
$ps.UseShellExecute=$false;$ps.RedirectStandardOutput=$true;$ps.RedirectStandardError=$true;$ps.CreateNoWindow=$true
$pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$ps;$pr.Start()|Out-Null
$co=$pr.StandardOutput.ReadToEndAsync();$ce=$pr.StandardError.ReadToEndAsync()
if(-not $pr.WaitForExit(60000)){$pr.Kill();Write-Host "$t compile TIMEOUT";exit 1}
[System.Threading.Tasks.Task]::WaitAll($co,$ce)
if($pr.ExitCode -ne 0){Write-Host "$t COMPILE FAIL $($ce.Result)";exit 1}
& clang -fsanitize=address -g -O1 -o "$dir\${t}_asan.exe" "$dir\$t.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
$env:ASAN_OPTIONS="abort_on_error=0"
$crash=0;$ok=0
for($i=1;$i -le 5;$i++){
  $p2=New-Object System.Diagnostics.ProcessStartInfo
  $p2.FileName="$dir\${t}_asan.exe";$p2.WorkingDirectory=$dir
  $p2.UseShellExecute=$false;$p2.RedirectStandardOutput=$true;$p2.RedirectStandardError=$true;$p2.CreateNoWindow=$true
  $pp=[System.Diagnostics.Process]::new();$pp.StartInfo=$p2;$pp.Start()|Out-Null
  $o=$pp.StandardOutput.ReadToEndAsync();$ee=$pp.StandardError.ReadToEndAsync()
  if(-not $pp.WaitForExit(15000)){$pp.Kill();Write-Host "TIMEOUT";continue}
  [System.Threading.Tasks.Task]::WaitAll($o,$ee)
  if($pp.ExitCode -eq 0){$ok++}else{$crash++; if($ee.Result.Length -gt 0 -and $i -eq 1){Write-Host "ASAN:"; Write-Host ($ee.Result.Substring(0,[Math]::Min(1500,$ee.Result.Length)))}}
}
Write-Host "${t}: ok=$ok crash=$crash"
