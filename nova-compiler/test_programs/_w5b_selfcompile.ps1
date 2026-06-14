Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
# 1) Build a THROWAWAY W5b-compiled compiler (NOVA_T8_DROP=1 at compile time). NEVER installed.
Remove-Item "_w5b_nc.ll","_gen4_w5b.exe" -Force -ErrorAction SilentlyContinue
$env:NOVA_T8_DROP = "1"
$c1 = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 900000 -WorkingDirectory $PSScriptRoot
Remove-Item Env:\NOVA_T8_DROP -ErrorAction SilentlyContinue
if (!(Test-Path "nova_compiler.ll")) { Write-Host "W5b self-compile-of-source FAILED (exit=$($c1.ExitCode) timedout=$($c1.TimedOut))"; Write-Host (($c1.StdOut -split "`r?`n" | Select-Object -Last 8) -join " | "); exit 1 }
Copy-Item nova_compiler.ll _w5b_nc.ll -Force
$h_w5b = (Get-FileHash _w5b_nc.ll -Algorithm SHA256).Hash
Write-Host "W5b-instrumented nova_compiler.ll SHA: $h_w5b"
$l1 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"_gen4_w5b.exe`" `"_w5b_nc.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "_gen4_w5b.exe")) { Write-Host "link _gen4_w5b FAILED"; Write-Host $l1.StdErr; exit 1 }
Write-Host "_gen4_w5b.exe built ($((Get-Item _gen4_w5b.exe).Length) bytes)"
# 2) Reference: what gen3 (CD05F294) produces compiling nova_compiler.nova (no W5b)
Remove-Item "nova_compiler.ll","_ref_nc.ll" -Force -ErrorAction SilentlyContinue
$c2 = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 900000 -WorkingDirectory $PSScriptRoot
Copy-Item nova_compiler.ll _ref_nc.ll -Force
$h_ref = (Get-FileHash _ref_nc.ll -Algorithm SHA256).Hash
Write-Host "REFERENCE (gen3) nova_compiler.ll SHA: $h_ref"
# 3) THE TEST: does the W5b compiler self-compile to the SAME output? (iter-58 said it could not)
Remove-Item "nova_compiler.ll","_w5bout_nc.ll" -Force -ErrorAction SilentlyContinue
$c3 = Invoke-Timed -FilePath "$PSScriptRoot\_gen4_w5b.exe" -Arguments "nova_compiler.nova" -TimeoutMs 900000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path "nova_compiler.ll")) { Write-Host "W5b-COMPILER self-compile CRASHED/FAILED (exit=$($c3.ExitCode) timedout=$($c3.TimedOut)) -- iter-58 bug REPRODUCED (crash path)"; Write-Host (($c3.StdOut -split "`r?`n" | Select-Object -Last 8) -join " | "); exit 0 }
Copy-Item nova_compiler.ll _w5bout_nc.ll -Force
$h_w5bout = (Get-FileHash _w5bout_nc.ll -Algorithm SHA256).Hash
Write-Host "W5b-COMPILER output nova_compiler.ll SHA: $h_w5bout"
if ($h_w5bout -eq $h_ref) { Write-Host "RESULT: W5b compiler self-compiles to IDENTICAL output -- self-compile is SOUND now (NOT reproduced)" }
else { Write-Host "RESULT: W5b compiler output DIFFERS from reference -- iter-58 corruption REPRODUCED (silent miscompile)" }
