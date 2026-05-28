Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
# Step 1: Compile with output.exe
Write-Output "=== Compiling nova_compiler.nova -> gen1_debug.ll ==="
$proc = Start-Process -FilePath "..\output.exe" -ArgumentList "nova_compiler.nova","gen1_debug.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "dbg_compile_stdout.txt" -RedirectStandardError "dbg_compile_stderr.txt"
Write-Output "Compile exit: $($proc.ExitCode)"
Get-Content dbg_compile_stdout.txt | Select-Object -First 5
if (-not (Test-Path gen1_debug.ll)) { Write-Output "FAIL: gen1_debug.ll not created"; exit }
Write-Output "gen1_debug.ll: $((Get-Item gen1_debug.ll).Length) bytes"

# Step 2: Link
Write-Output "=== Linking gen1_debug.exe ==="
clang -O2 -o gen1_debug.exe gen1_debug.ll output/nova_runtime.c 2>$null
if (-not (Test-Path gen1_debug.exe)) { Write-Output "FAIL: gen1_debug.exe not created"; exit }
Write-Output "gen1_debug.exe: $((Get-Item gen1_debug.exe).Length) bytes"

# Step 3: Run on simple program
Write-Output "=== Running gen1_debug.exe test_simple.nova ==="
$proc2 = Start-Process -FilePath ".\gen1_debug.exe" -ArgumentList "test_simple.nova","test_debug_out.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "dbg_run_stdout.txt" -RedirectStandardError "dbg_run_stderr.txt"
Write-Output "Run exit: $($proc2.ExitCode)"
Write-Output "--- STDOUT ---"
Get-Content dbg_run_stdout.txt | Select-Object -First 20
Write-Output "--- STDERR ---"
Get-Content dbg_run_stderr.txt | Select-Object -First 10
