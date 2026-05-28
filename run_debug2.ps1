Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
Write-Output "=== Compiling ==="
$proc = Start-Process -FilePath "..\output.exe" -ArgumentList "nova_compiler.nova","gen1_debug.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "dbg2_cstdout.txt" -RedirectStandardError "dbg2_cstderr.txt"
Write-Output "Compile exit: $($proc.ExitCode)"
Get-Content dbg2_cstdout.txt | Select-Object -First 3
if (-not (Test-Path gen1_debug.ll)) { Write-Output "FAIL"; exit }

Write-Output "=== Linking ==="
clang -O2 -o gen1_debug.exe gen1_debug.ll output/nova_runtime.c 2>$null
if (-not (Test-Path gen1_debug.exe)) { Write-Output "FAIL: link"; exit }

Write-Output "=== Running ==="
$proc2 = Start-Process -FilePath ".\gen1_debug.exe" -ArgumentList "test_simple.nova","test_debug_out.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "dbg2_rstdout.txt" -RedirectStandardError "dbg2_rstderr.txt"
Write-Output "Run exit: $($proc2.ExitCode)"
Write-Output "--- STDOUT ---"
Get-Content dbg2_rstdout.txt
