Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"

Write-Output "=== Compiling nova_compiler.nova -> gen1_fixed.ll ==="
$proc = Start-Process -FilePath "..\output.exe" -ArgumentList "nova_compiler.nova","gen1_fixed.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "fix_cstdout.txt" -RedirectStandardError "fix_cstderr.txt"
Write-Output "Compile exit: $($proc.ExitCode)"
Get-Content fix_cstdout.txt | Select-Object -First 3
if (-not (Test-Path gen1_fixed.ll)) { Write-Output "FAIL: compile"; exit }
Write-Output "gen1_fixed.ll: $((Get-Item gen1_fixed.ll).Length) bytes"

Write-Output "=== Linking ==="
clang -O2 -o gen1_fixed.exe gen1_fixed.ll output/nova_runtime.c 2>$null
if (-not (Test-Path gen1_fixed.exe)) { Write-Output "FAIL: link"; exit }
Write-Output "gen1_fixed.exe: $((Get-Item gen1_fixed.exe).Length) bytes"

Write-Output "=== Running on test_simple.nova ==="
$proc2 = Start-Process -FilePath ".\gen1_fixed.exe" -ArgumentList "test_simple.nova","test_fixed.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "fix_rstdout.txt" -RedirectStandardError "fix_rstderr.txt"
Write-Output "Run exit: $($proc2.ExitCode)"
Get-Content fix_rstdout.txt | Select-Object -First 10
if (Test-Path test_fixed.ll) { Write-Output "test_fixed.ll: $((Get-Item test_fixed.ll).Length) bytes" }
