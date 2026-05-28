Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
$proc = Start-Process -FilePath ".\gen1_final.exe" -ArgumentList "test_simple.nova","test_old_simple.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "old_stdout.txt" -RedirectStandardError "old_stderr.txt"
Write-Output "Exit code: $($proc.ExitCode)"
Write-Output "--- STDOUT ---"
Get-Content old_stdout.txt | Select-Object -First 20
Write-Output "--- STDERR ---"
Get-Content old_stderr.txt | Select-Object -First 20
if (Test-Path test_old_simple.ll) { Write-Output "test_old_simple.ll: $((Get-Item test_old_simple.ll).Length) bytes" } else { Write-Output "test_old_simple.ll NOT created" }
