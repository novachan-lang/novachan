Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
$proc = Start-Process -FilePath "..\output.exe" -ArgumentList "test_ntype.nova","test_ntype.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "tn_cstdout.txt" -RedirectStandardError "tn_cstderr.txt"
Write-Output "Compile exit: $($proc.ExitCode)"
if (-not (Test-Path test_ntype.ll)) { Write-Output "FAIL: compile"; exit }

clang -O0 -o test_ntype.exe test_ntype.ll output/nova_runtime.c 2>$null
if (-not (Test-Path test_ntype.exe)) { Write-Output "FAIL: link"; exit }

$proc2 = Start-Process -FilePath ".\test_ntype.exe" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "tn_rstdout.txt" -RedirectStandardError "tn_rstderr.txt"
Write-Output "Run exit: $($proc2.ExitCode)"
Get-Content tn_rstdout.txt
