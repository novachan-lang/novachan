Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$p = $args[0]
Remove-Item "$p.ll","${p}_asan.exe" -Force -ErrorAction SilentlyContinue
$env:NOVA_T8_DROP = "1"
$cr = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "$p.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Remove-Item Env:\NOVA_T8_DROP -ErrorAction SilentlyContinue
if (!(Test-Path "$p.ll")) { Write-Host "$p COMPILE-FAIL"; exit 1 }
$la = "-fsanitize=address -O1 -g -o `"${p}_asan.exe`" `"$p.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
$lr = Invoke-Timed -FilePath $ClangPath -Arguments $la -TimeoutMs 150000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "${p}_asan.exe")) { Write-Host "$p ASAN-LINK-FAIL"; Write-Host (($lr.StdErr -split "`r?`n" | Select-Object -Last 5) -join " | "); exit 1 }
$rr = Invoke-Timed -FilePath "$PSScriptRoot\${p}_asan.exe" -Arguments '' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
Write-Host "=== $p (W5b ON, ASAN): exit=$($rr.ExitCode)"
$err = $rr.StdErr -split "`r?`n"
$rel = $err | Where-Object { $_ -match "ERROR: AddressSanitizer|use-after-free|double-free|freed by|previously allocated|#[0-9]+ .*nova_|#[0-9]+ .*free|SUMMARY" } | Select-Object -First 22
foreach ($l in $rel) { Write-Host $l }
Remove-Item "$p.ll","${p}_asan.exe" -Force -ErrorAction SilentlyContinue
