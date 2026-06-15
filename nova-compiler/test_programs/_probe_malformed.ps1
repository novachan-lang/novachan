$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1"
$cases=@("_m_fn_eof","_m_paren_eof","_m_type_eof","_m_type_kw","_m_field_eof","_m_trait_eof","_m_param_nl","_m_dict_eof","_m_str_eof","_m_match_eof")
foreach($name in $cases){
  $p=New-Object System.Diagnostics.ProcessStartInfo
  $p.FileName="$dir\gen4_check.exe";$p.Arguments="$name.nova";$p.WorkingDirectory=$dir
  $p.UseShellExecute=$false;$p.RedirectStandardOutput=$true;$p.RedirectStandardError=$true;$p.CreateNoWindow=$true
  $pp=[System.Diagnostics.Process]::new();$pp.StartInfo=$p;$pp.Start()|Out-Null
  $o=$pp.StandardOutput.ReadToEndAsync();$e=$pp.StandardError.ReadToEndAsync()
  if(-not $pp.WaitForExit(15000)){$pp.Kill();$pp.WaitForExit(2000);Write-Host "${name}: HANG";continue}
  [System.Threading.Tasks.Task]::WaitAll($o,$e)
  $ec=$pp.ExitCode
  $tag = if($ec -eq -1073741819){"CRASH"}elseif($ec -eq 0){"ok-compiled"}elseif($ec -eq 1){"clean-error"}else{"exit=$ec"}
  Write-Host "${name}: $tag"
}
