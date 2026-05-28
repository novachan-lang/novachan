Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
# Compile with output.exe (Kotlin-compiled compiler)
$proc = Start-Process -FilePath "..\output.exe" -ArgumentList "test_types.nova","test_types.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "tt_stdout.txt" -RedirectStandardError "tt_stderr.txt"
Write-Output "Compile exit code: $($proc.ExitCode)"
Get-Content tt_stdout.txt | Select-Object -First 5
if (-not (Test-Path test_types.ll)) { Write-Output "FAIL: test_types.ll not created"; exit }
Write-Output "test_types.ll: $((Get-Item test_types.ll).Length) bytes"

# Link with clang
clang -O2 -o test_types.exe test_types.ll output/nova_runtime.c 2>$null
if (-not (Test-Path test_types.exe)) { Write-Output "FAIL: test_types.exe not created"; exit }
Write-Output "test_types.exe: $((Get-Item test_types.exe).Length) bytes"

# Run
$proc2 = Start-Process -FilePath ".\test_types.exe" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "tt_run_stdout.txt" -RedirectStandardError "tt_run_stderr.txt"
Write-Output "Run exit code: $($proc2.ExitCode)"
Write-Output "--- OUTPUT ---"
Get-Content tt_run_stdout.txt
