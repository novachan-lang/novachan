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
Write-Host "gen4_check built. Testing parse-error cases:"
function CompileTest($name){
  $p=New-Object System.Diagnostics.ProcessStartInfo
  $p.FileName="$dir\gen4_check.exe";$p.Arguments="$name.nova";$p.WorkingDirectory=$dir
  $p.UseShellExecute=$false;$p.RedirectStandardOutput=$true;$p.RedirectStandardError=$true;$p.CreateNoWindow=$true
  $pp=[System.Diagnostics.Process]::new();$pp.StartInfo=$p;$pp.Start()|Out-Null
  $o=$pp.StandardOutput.ReadToEndAsync();$e=$pp.StandardError.ReadToEndAsync()
  if(-not $pp.WaitForExit(30000)){$pp.Kill();$pp.WaitForExit(2000);Write-Host "  ${name}: HANG/TIMEOUT";return}
  [System.Threading.Tasks.Task]::WaitAll($o,$e)
  $errcount = ([regex]::Matches($o.Result, "error\[")).Count
  Write-Host "  ${name}: exit=$($pp.ExitCode) errors_reported=$errcount"
}
CompileTest "multi_error_test"
CompileTest "_errn_4"
CompileTest "_err_3"
CompileTest "error_test"
CompileTest "float_list_ops_test"
