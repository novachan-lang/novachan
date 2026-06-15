param([string]$t)
$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1"
$ps=New-Object System.Diagnostics.ProcessStartInfo
$ps.FileName="$dir\gen4_test.exe";$ps.Arguments="$t.nova";$ps.WorkingDirectory=$dir
$ps.UseShellExecute=$false;$ps.RedirectStandardOutput=$true;$ps.RedirectStandardError=$true;$ps.CreateNoWindow=$true
$pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$ps;$pr.Start()|Out-Null
$co=$pr.StandardOutput.ReadToEndAsync();$ce=$pr.StandardError.ReadToEndAsync()
if(-not $pr.WaitForExit(60000)){$pr.Kill();$pr.WaitForExit(3000);Write-Host "${t}: COMPILE TIMEOUT";exit 1}
[System.Threading.Tasks.Task]::WaitAll($co,$ce)
if($pr.ExitCode -ne 0){Write-Host "${t}: COMPILE FAIL $($ce.Result)";exit 1}
& clang -O2 -o "$dir\$t.exe" "$dir\$t.ll" "$dir\_rt_cached.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
$ps2=New-Object System.Diagnostics.ProcessStartInfo
$ps2.FileName="$dir\$t.exe";$ps2.WorkingDirectory=$dir
$ps2.UseShellExecute=$false;$ps2.RedirectStandardOutput=$true;$ps2.RedirectStandardError=$true;$ps2.CreateNoWindow=$true
$pr2=[System.Diagnostics.Process]::new();$pr2.StartInfo=$ps2;$pr2.Start()|Out-Null
$so=$pr2.StandardOutput.ReadToEndAsync();$se=$pr2.StandardError.ReadToEndAsync()
if(-not $pr2.WaitForExit(15000)){$pr2.Kill();$pr2.WaitForExit(3000);Write-Host "${t}: RUN TIMEOUT"}
[System.Threading.Tasks.Task]::WaitAll($so,$se)
Write-Host "--- ${t}: OUT ---"; Write-Host $so.Result
if($se.Result){Write-Host "ERR: $($se.Result)"}
Write-Host "exit=$($pr2.ExitCode)"
