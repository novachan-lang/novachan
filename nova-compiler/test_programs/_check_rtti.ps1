$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1"
$LINK="-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w"
Write-Host "gen3 -> gen4_check (compiling edited nova_compiler.nova)..."
$ps=New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName="$dir\gen3_test.exe";$ps.Arguments="nova_compiler.nova";$ps.WorkingDirectory=$dir
$ps.UseShellExecute=$false;$ps.RedirectStandardOutput=$true;$ps.RedirectStandardError=$true;$ps.CreateNoWindow=$true
$pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$ps;$pr.Start()|Out-Null
$co=$pr.StandardOutput.ReadToEndAsync();$ce=$pr.StandardError.ReadToEndAsync()
if(-not $pr.WaitForExit(450000)){$pr.Kill();$pr.WaitForExit(3000);Write-Host "gen3 TIMEOUT";exit 1}
[System.Threading.Tasks.Task]::WaitAll($co,$ce)
if($pr.ExitCode -ne 0){Write-Host "gen3 FAIL: $($ce.Result)";exit 1}
& clang -O2 -o "$dir\gen4_check.exe" "$dir\nova_compiler.ll" "$dir\output\nova_runtime.c" @LINK 2>$null
if(-not(Test-Path "$dir\gen4_check.exe")){Write-Host "LINK FAIL";exit 1}
& clang -O2 -c -o "$dir\_rtchk.o" "$dir\output\nova_runtime.c" -D_CRT_SECURE_NO_WARNINGS -w 2>$null
Write-Host "gen4_check built. Testing:"
function RunT($name){
  $p=New-Object System.Diagnostics.ProcessStartInfo
  $p.FileName="$dir\gen4_check.exe";$p.Arguments="$name.nova";$p.WorkingDirectory=$dir
  $p.UseShellExecute=$false;$p.RedirectStandardOutput=$true;$p.RedirectStandardError=$true;$p.CreateNoWindow=$true
  $pp=[System.Diagnostics.Process]::new();$pp.StartInfo=$p;$pp.Start()|Out-Null
  $o=$pp.StandardOutput.ReadToEndAsync();$ee=$pp.StandardError.ReadToEndAsync()
  if(-not $pp.WaitForExit(40000)){$pp.Kill();$pp.WaitForExit(2000);Write-Host "  ${name}: COMPILE-TIMEOUT";return}
  [System.Threading.Tasks.Task]::WaitAll($o,$ee)
  if($pp.ExitCode -ne 0){Write-Host "  ${name}: COMPILE-FAIL $($ee.Result)";return}
  & clang -O2 -o "$dir\$name.exe" "$dir\$name.ll" "$dir\_rtchk.o" @LINK 2>$null
  $p2=New-Object System.Diagnostics.ProcessStartInfo
  $p2.FileName="$dir\$name.exe";$p2.WorkingDirectory=$dir
  $p2.UseShellExecute=$false;$p2.RedirectStandardOutput=$true;$p2.RedirectStandardError=$true;$p2.CreateNoWindow=$true
  $pp2=[System.Diagnostics.Process]::new();$pp2.StartInfo=$p2;$pp2.Start()|Out-Null
  $o2=$pp2.StandardOutput.ReadToEndAsync();$e2=$pp2.StandardError.ReadToEndAsync()
  if(-not $pp2.WaitForExit(15000)){$pp2.Kill();$pp2.WaitForExit(2000);Write-Host "  ${name}: RUN-TIMEOUT";return}
  [System.Threading.Tasks.Task]::WaitAll($o2,$e2)
  $tag = if($pp2.ExitCode -eq 0){"PASS"}else{"FAIL exit=$($pp2.ExitCode) $($e2.Result)"}
  Write-Host "  ${name}: $tag"
}
RunT "typename_test"
RunT "auto_show_test"
RunT "auto_eq_test"
RunT "struct_test"
RunT "newtype_test"
RunT "float_list_ops_test"
