Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
$env:ASAN_OPTIONS = "detect_stack_use_after_return=0"
$proc = Start-Process -FilePath ".\gen1_asan.exe" -ArgumentList "test_simple.nova","test_asan.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "asan_stdout.txt" -RedirectStandardError "asan_stderr.txt"
Write-Output "Exit: $($proc.ExitCode)"
Write-Output "--- STDERR (first 50 lines) ---"
Get-Content asan_stderr.txt | Select-Object -First 50
Write-Output "--- STDOUT ---"
Get-Content asan_stdout.txt | Select-Object -First 10
