$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1"
$ps=New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName="$dir\gen4_test.exe";$ps.Arguments="stacktracex.nova";$ps.WorkingDirectory=$dir
$ps.UseShellExecute=$false;$ps.RedirectStandardOutput=$true;$ps.RedirectStandardError=$true;$ps.CreateNoWindow=$true
$pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$ps;$pr.Start()|Out-Null
$co=$pr.StandardOutput.ReadToEndAsync();$ce=$pr.StandardError.ReadToEndAsync()
if(-not $pr.WaitForExit(60000)){$pr.Kill();Write-Host "compile TIMEOUT";exit 1}
[System.Threading.Tasks.Task]::WaitAll($co,$ce)
if($pr.ExitCode -ne 0){Write-Host "compile FAIL";exit 1}
Write-Host "compiled. Linking with ASAN..."
& clang -fsanitize=address -g -O1 -o "$dir\_stk_asan.exe" "$dir\stacktracex.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>&1 | Select-Object -First 5
if(-not(Test-Path "$dir\_stk_asan.exe")){Write-Host "ASAN LINK FAIL (asan may be unavailable)";exit 2}
$env:ASAN_OPTIONS="abort_on_error=0:halt_on_error=1"
for($i=1;$i -le 6;$i++){
  $p2=New-Object System.Diagnostics.ProcessStartInfo
  $p2.FileName="$dir\_stk_asan.exe";$p2.WorkingDirectory=$dir
  $p2.UseShellExecute=$false;$p2.RedirectStandardOutput=$true;$p2.RedirectStandardError=$true;$p2.CreateNoWindow=$true
  $pp=[System.Diagnostics.Process]::new();$pp.StartInfo=$p2;$pp.Start()|Out-Null
  $o=$pp.StandardOutput.ReadToEndAsync();$ee=$pp.StandardError.ReadToEndAsync()
  if(-not $pp.WaitForExit(20000)){$pp.Kill();Write-Host "run $i TIMEOUT";continue}
  [System.Threading.Tasks.Task]::WaitAll($o,$ee)
  Write-Host "run $i exit=$($pp.ExitCode)"
  if($ee.Result -match "ERROR|overflow|use-after|heap|stack-buffer"){Write-Host "--- ASAN report ---"; Write-Host ($ee.Result.Substring(0,[Math]::Min(2000,$ee.Result.Length)))}
}
