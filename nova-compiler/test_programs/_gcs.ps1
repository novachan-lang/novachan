param([string]$t)
$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1";$env:NOVA_SROA="1"
$p=New-Object System.Diagnostics.ProcessStartInfo;$p.FileName="$dir\gen4_check.exe";$p.Arguments="$t.nova";$p.WorkingDirectory=$dir
$p.UseShellExecute=$false;$p.RedirectStandardError=$true;$p.CreateNoWindow=$true
$pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$p;$pr.Start()|Out-Null;$pr.WaitForExit(60000)|Out-Null
Write-Host "compile exit=$($pr.ExitCode)"
& clang -O2 -o "$dir\$t`_s.exe" "$dir\$t.ll" "$dir\_rtchk.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
