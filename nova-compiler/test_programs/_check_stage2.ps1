$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1"
$ps=New-Object System.Diagnostics.ProcessStartInfo;$ps.FileName="$dir\gen3_test.exe";$ps.Arguments="nova_compiler.nova";$ps.WorkingDirectory=$dir
$ps.UseShellExecute=$false;$ps.RedirectStandardOutput=$true;$ps.RedirectStandardError=$true;$ps.CreateNoWindow=$true
$pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$ps;$pr.Start()|Out-Null
$co=$pr.StandardOutput.ReadToEndAsync();$ce=$pr.StandardError.ReadToEndAsync()
if(-not $pr.WaitForExit(450000)){$pr.Kill();Write-Host "gen3 TIMEOUT";exit 1}
[System.Threading.Tasks.Task]::WaitAll($co,$ce)
if($pr.ExitCode -ne 0){Write-Host "gen3 FAIL: $($ce.Result)";exit 1}
& clang -O2 -o "$dir\gen4_check.exe" "$dir\nova_compiler.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
$p=New-Object System.Diagnostics.ProcessStartInfo;$p.FileName="$dir\gen4_check.exe";$p.Arguments="_perf_probe.nova";$p.WorkingDirectory=$dir
$p.UseShellExecute=$false;$p.RedirectStandardOutput=$true;$p.RedirectStandardError=$true;$p.CreateNoWindow=$true
$pp=[System.Diagnostics.Process]::new();$pp.StartInfo=$p;$pp.Start()|Out-Null;$pp.WaitForExit(60000)|Out-Null
Write-Host "perf_probe compile exit=$($pp.ExitCode)"
