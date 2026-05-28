Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"

Write-Output "=== Compiling ORIGINAL nova_compiler.nova ==="
$proc = Start-Process -FilePath "..\output.exe" -ArgumentList "nova_compiler_original.nova","gen1_orig.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "orig_cstdout.txt" -RedirectStandardError "orig_cstderr.txt"
Write-Output "Compile exit: $($proc.ExitCode)"
Get-Content orig_cstdout.txt | Select-Object -First 3

if (-not (Test-Path gen1_orig.ll)) { Write-Output "FAIL: gen1_orig.ll not created"; exit }
Write-Output "gen1_orig.ll: $((Get-Item gen1_orig.ll).Length) bytes"

clang -O2 -o gen1_orig.exe gen1_orig.ll output/nova_runtime.c 2>$null
if (-not (Test-Path gen1_orig.exe)) { Write-Output "FAIL: link"; exit }
Write-Output "gen1_orig.exe: $((Get-Item gen1_orig.exe).Length) bytes"

$proc2 = Start-Process -FilePath ".\gen1_orig.exe" -ArgumentList "test_simple.nova","test_orig.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "orig_rstdout.txt" -RedirectStandardError "orig_rstderr.txt"
Write-Output "Run exit: $($proc2.ExitCode)"
Get-Content orig_rstdout.txt | Select-Object -First 5
