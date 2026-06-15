$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1"
$tests=@("nn","stats","physics2d","math3d","simdx","geox","tensor","nested_float","auto_show_test","auto_eq_test","auto_json_test","struct_test","vec3_test")
foreach($t in $tests){
  if(-not (Test-Path "$dir\$t.nova")){ continue }
  $c=New-Object System.Diagnostics.ProcessStartInfo;$c.FileName="$dir\gen4_check.exe";$c.Arguments="$t.nova";$c.WorkingDirectory=$dir
  $c.UseShellExecute=$false;$c.RedirectStandardOutput=$true;$c.RedirectStandardError=$true;$c.CreateNoWindow=$true
  $cp=[System.Diagnostics.Process]::new();$cp.StartInfo=$c;$cp.Start()|Out-Null
  if(-not $cp.WaitForExit(60000)){$cp.Kill();Write-Host "$t COMPILE-TIMEOUT";continue}
  if($cp.ExitCode -ne 0){Write-Host "$t COMPILE-FAIL";continue}
  & clang -O2 -o "$dir\$t.exe" "$dir\$t.ll" "$dir\_rtchk.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
  $r=New-Object System.Diagnostics.ProcessStartInfo;$r.FileName="$dir\$t.exe";$r.WorkingDirectory=$dir
  $r.UseShellExecute=$false;$r.RedirectStandardOutput=$true;$r.RedirectStandardError=$true;$r.CreateNoWindow=$true
  $rp=[System.Diagnostics.Process]::new();$rp.StartInfo=$r;$rp.Start()|Out-Null
  $o=$rp.StandardOutput.ReadToEndAsync();$e=$rp.StandardError.ReadToEndAsync()
  if(-not $rp.WaitForExit(15000)){$rp.Kill();Write-Host "$t RUN-TIMEOUT";continue}
  [System.Threading.Tasks.Task]::WaitAll($o,$e)
  $bad=""
  if($e.Result -match "FAIL|Assertion|fault"){$bad=" <<< "+($e.Result -split "`n" | Select-Object -First 1)}
  Write-Host "$t exit=$($rp.ExitCode)$bad"
}
