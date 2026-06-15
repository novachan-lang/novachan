$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1"
$c=New-Object System.Diagnostics.ProcessStartInfo;$c.FileName="$dir\gen4_test.exe";$c.Arguments="_stk_diag.nova";$c.WorkingDirectory=$dir
$c.UseShellExecute=$false;$c.RedirectStandardOutput=$true;$c.RedirectStandardError=$true;$c.CreateNoWindow=$true
$cp=[System.Diagnostics.Process]::new();$cp.StartInfo=$c;$cp.Start()|Out-Null;$cp.WaitForExit(60000)|Out-Null
& clang -O2 -o "$dir\_stk_diag.exe" "$dir\_stk_diag.ll" "$dir\_rt_cached.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
for($i=0;$i -lt 6;$i++){
  $p=New-Object System.Diagnostics.ProcessStartInfo;$p.FileName="$dir\_stk_diag.exe";$p.WorkingDirectory=$dir
  $p.UseShellExecute=$false;$p.RedirectStandardOutput=$true;$p.RedirectStandardError=$true;$p.CreateNoWindow=$true
  $pp=[System.Diagnostics.Process]::new();$pp.StartInfo=$p;$pp.Start()|Out-Null
  $o=$pp.StandardOutput.ReadToEndAsync();$e=$pp.StandardError.ReadToEndAsync();$pp.WaitForExit(15000)|Out-Null
  [System.Threading.Tasks.Task]::WaitAll($o,$e)
  $lines=($o.Result -split "`n") | Where-Object {$_ -match '^\d'}
  Write-Host "run $i exit=$($pp.ExitCode): $($lines -join ' | ')"
}
