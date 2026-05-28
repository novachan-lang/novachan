Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
Write-Output "=== Linking with -O0 ==="
clang -O0 -o gen1_debug_o0.exe gen1_debug.ll output/nova_runtime.c 2>$null
if (-not (Test-Path gen1_debug_o0.exe)) { Write-Output "FAIL: link"; exit }
Write-Output "gen1_debug_o0.exe: $((Get-Item gen1_debug_o0.exe).Length) bytes"

Write-Output "=== Running ==="
$proc2 = Start-Process -FilePath ".\gen1_debug_o0.exe" -ArgumentList "test_simple.nova","test_debug_o0.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "dbg_o0_stdout.txt" -RedirectStandardError "dbg_o0_stderr.txt"
Write-Output "Run exit: $($proc2.ExitCode)"
Write-Output "--- STDOUT ---"
Get-Content dbg_o0_stdout.txt
