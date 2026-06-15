Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== Building gen4 from nova_compiler.nova ==="
$r = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if ($r.TimedOut) { Write-Host "COMPILE TIMEOUT"; exit 1 }
if ($r.ExitCode -ne 0) { Write-Host "COMPILE FAIL exit=$($r.ExitCode)"; Write-Host $r.StdOut.Substring(0,[Math]::Min(3000,$r.StdOut.Length)); exit 1 }
Write-Host "Compile OK"

if (!(Test-Path "$PSScriptRoot\nova_compiler.ll")) { Write-Host "NO .ll FILE"; exit 1 }

Write-Host "=== Linking gen4_fix.exe ==="
$cr = Invoke-Timed -FilePath "clang" -Arguments "-O2 -o gen4_fix.exe nova_compiler.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "LINK FAIL"; Write-Host $cr.StdErr; exit 1 }
Write-Host "Link OK - gen4_fix.exe built"
