$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1"
$LINK="-lws2_32","-ladvapi32","-D_CRT_SECURE_NO_WARNINGS","-w"
Write-Host "gen3 -> gen4_check..."
$ps=New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName="$dir\gen3_test.exe";$ps.Arguments="nova_compiler.nova";$ps.WorkingDirectory=$dir
$ps.UseShellExecute=$false;$ps.RedirectStandardOutput=$true;$ps.RedirectStandardError=$true;$ps.CreateNoWindow=$true
$pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$ps;$pr.Start()|Out-Null
$co=$pr.StandardOutput.ReadToEndAsync();$ce=$pr.StandardError.ReadToEndAsync()
if(-not $pr.WaitForExit(450000)){$pr.Kill();$pr.WaitForExit(3000);Write-Host "gen3 TIMEOUT";exit 1}
[System.Threading.Tasks.Task]::WaitAll($co,$ce)
if($pr.ExitCode -ne 0){Write-Host "gen3 FAIL: $($ce.Result)";exit 1}
& clang -O2 -o "$dir\gen4_check.exe" "$dir\nova_compiler.ll" "$dir\output\nova_runtime.c" @LINK 2>$null
if(-not(Test-Path "$dir\gen4_check.exe")){Write-Host "gen4 LINK FAIL";exit 1}
& clang -O2 -c -o "$dir\_rtchk.o" "$dir\output\nova_runtime.c" -D_CRT_SECURE_NO_WARNINGS -w 2>$null
$ps2=New-Object System.Diagnostics.ProcessStartInfo
$ps2.FileName="$dir\gen4_check.exe";$ps2.Arguments="normx_test.nova";$ps2.WorkingDirectory=$dir
$ps2.UseShellExecute=$false;$ps2.RedirectStandardOutput=$true;$ps2.RedirectStandardError=$true;$ps2.CreateNoWindow=$true
$pp=[System.Diagnostics.Process]::new();$pp.StartInfo=$ps2;$pp.Start()|Out-Null
$o=$pp.StandardOutput.ReadToEndAsync();$e2=$pp.StandardError.ReadToEndAsync()
if(-not $pp.WaitForExit(40000)){$pp.Kill();Write-Host "compile TIMEOUT";exit 1}
[System.Threading.Tasks.Task]::WaitAll($o,$e2)
if($pp.ExitCode -ne 0){Write-Host "normx COMPILE FAIL: $($e2.Result)";exit 1}
& clang -O2 -o "$dir\normx_test.exe" "$dir\normx_test.ll" "$dir\_rtchk.o" @LINK 2>$null
$ps3=New-Object System.Diagnostics.ProcessStartInfo
$ps3.FileName="$dir\normx_test.exe";$ps3.WorkingDirectory=$dir
$ps3.UseShellExecute=$false;$ps3.RedirectStandardOutput=$true;$ps3.RedirectStandardError=$true;$ps3.CreateNoWindow=$true
$pp3=[System.Diagnostics.Process]::new();$pp3.StartInfo=$ps3;$pp3.Start()|Out-Null
$o3=$pp3.StandardOutput.ReadToEndAsync();$e3=$pp3.StandardError.ReadToEndAsync()
if(-not $pp3.WaitForExit(15000)){$pp3.Kill();Write-Host "run TIMEOUT";exit 1}
[System.Threading.Tasks.Task]::WaitAll($o3,$e3)
Write-Host "OUT: $($o3.Result)"
if($e3.Result){Write-Host "ERR: $($e3.Result)"}
Write-Host "exit=$($pp3.ExitCode)"
