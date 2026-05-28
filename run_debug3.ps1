Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
Write-Output "=== Compiling ==="
$proc = Start-Process -FilePath "..\output.exe" -ArgumentList "nova_compiler.nova","gen1_debug.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "dbg3_cstdout.txt" -RedirectStandardError "dbg3_cstderr.txt"
Write-Output "Compile exit: $($proc.ExitCode)"
Get-Content dbg3_cstdout.txt | Select-Object -First 3

Write-Output "=== Linking ==="
$linkproc = Start-Process -FilePath "clang" -ArgumentList "-O2","-o","gen1_debug.exe","gen1_debug.ll","output/nova_runtime.c" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "dbg3_lstdout.txt" -RedirectStandardError "dbg3_lstderr.txt"
Write-Output "Link exit: $($linkproc.ExitCode)"
Get-Content dbg3_lstderr.txt | Select-Object -First 10

if (-not (Test-Path gen1_debug.exe)) { Write-Output "FAIL: gen1_debug.exe not created"; exit }
Write-Output "gen1_debug.exe: $((Get-Item gen1_debug.exe).Length) bytes"

Write-Output "=== Running ==="
$proc2 = Start-Process -FilePath ".\gen1_debug.exe" -ArgumentList "test_simple.nova","test_debug_out.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "dbg3_rstdout.txt" -RedirectStandardError "dbg3_rstderr.txt"
Write-Output "Run exit: $($proc2.ExitCode)"
Write-Output "--- STDOUT ---"
Get-Content dbg3_rstdout.txt
