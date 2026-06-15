param([string]$t,[string]$sroa)
$dir=$PSScriptRoot;$env:NOVA_NO_CACHE="1"
if($sroa -eq "off"){$env:NOVA_NO_SROA="1"}else{Remove-Item Env:\NOVA_NO_SROA -ErrorAction SilentlyContinue}
$p=New-Object System.Diagnostics.ProcessStartInfo;$p.FileName="$dir\gen4_test.exe";$p.Arguments="$t.nova";$p.WorkingDirectory=$dir
$p.UseShellExecute=$false;$p.RedirectStandardError=$true;$p.CreateNoWindow=$true
$pr=[System.Diagnostics.Process]::new();$pr.StartInfo=$p;$pr.Start()|Out-Null;$pr.WaitForExit(60000)|Out-Null
Write-Host "$t [$sroa] compile=$($pr.ExitCode)"
$lk = & clang -O2 -o "$dir\_cd.exe" "$dir\$t.ll" "$dir\_rt_cached.o" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>&1
Write-Host "  link rc=$LASTEXITCODE $(($lk | Select-Object -First 1))"
