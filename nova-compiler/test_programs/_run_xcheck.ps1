$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1"
$ps=New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName="$dir\gen4_check.exe";$ps.Arguments="normx_xcheck.nova";$ps.WorkingDirectory=$dir
$ps.UseShellExecute=$false;$ps.RedirectStandardOutput=$true;$ps.RedirectStandardError=$true;$ps.CreateNoWindow=$true
$pp=[System.Diagnostics.Process]::new();$pp.StartInfo=$ps;$pp.Start()|Out-Null
$o=$pp.StandardOutput.ReadToEndAsync();$e=$pp.StandardError.ReadToEndAsync()
if(-not $pp.WaitForExit(40000)){$pp.Kill();Write-Host "compile TIMEOUT";exit 1}
[System.Threading.Tasks.Task]::WaitAll($o,$e)
if($pp.ExitCode -ne 0){Write-Host "COMPILE FAIL: $($e.Result)";exit 1}
& clang -O2 -o "$dir\normx_xcheck.exe" "$dir\normx_xcheck.ll" "$dir\_rtchk.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
$p2=New-Object System.Diagnostics.ProcessStartInfo
$p2.FileName="$dir\normx_xcheck.exe";$p2.WorkingDirectory=$dir
$p2.UseShellExecute=$false;$p2.RedirectStandardOutput=$true;$p2.RedirectStandardError=$true;$p2.CreateNoWindow=$true
$pp2=[System.Diagnostics.Process]::new();$pp2.StartInfo=$p2;$pp2.Start()|Out-Null
$o2=$pp2.StandardOutput.ReadToEndAsync();$e2=$pp2.StandardError.ReadToEndAsync()
if(-not $pp2.WaitForExit(15000)){$pp2.Kill();Write-Host "run TIMEOUT";exit 1}
[System.Threading.Tasks.Task]::WaitAll($o2,$e2)
Write-Host "OUT: $($o2.Result)"
if($e2.Result){Write-Host "ERR: $($e2.Result)"}
Write-Host "exit=$($pp2.ExitCode)"
