$dir = $PSScriptRoot
. "$dir\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
Write-Host "[1] gen3 -> compile nova_compiler.nova (parser change)"
$c1 = Invoke-Timed -FilePath "$dir\gen3_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 450000
if ($c1.ExitCode -ne 0) { Write-Host "COMPILE-FAIL gen4 exit=$($c1.ExitCode)"; Write-Host $c1.StdErr.Substring(0,[Math]::Min(2000,$c1.StdErr.Length)); exit 1 }
$l1 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$dir\gen4_sc.exe`" `"$dir\nova_compiler.ll`" `"$dir\output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 150000
if (!(Test-Path "$dir\gen4_sc.exe")) { Write-Host "LINK-FAIL gen4 $($l1.StdErr)"; exit 1 }
Write-Host "  gen4_sc.exe built"
Write-Host "[2] gen4 -> compile set_comp_test.nova"
$c2 = Invoke-Timed -FilePath "$dir\gen4_sc.exe" -Arguments "set_comp_test.nova" -TimeoutMs 60000
if ($c2.ExitCode -ne 0) { Write-Host "COMPILE-FAIL set_comp exit=$($c2.ExitCode)"; Write-Host $c2.StdErr; exit 1 }
$l2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$dir\set_comp_test.exe`" `"$dir\set_comp_test.ll`" `"$dir\output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
if (!(Test-Path "$dir\set_comp_test.exe")) { Write-Host "LINK-FAIL set_comp $($l2.StdErr)"; exit 1 }
Write-Host "[3] run set_comp_test"
$r = Invoke-Timed -FilePath "$dir\set_comp_test.exe" -TimeoutMs 15000
Write-Host "  exit=$($r.ExitCode) timeout=$($r.TimedOut)"
Write-Host "  out: $($r.StdOut)"
if ($r.StdErr) { Write-Host "  err: $($r.StdErr)" }
