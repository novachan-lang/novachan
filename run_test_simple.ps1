Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
$proc = Start-Process -FilePath ".\gen1_new.exe" -ArgumentList "test_simple.nova","test_simple.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "test_stdout.txt" -RedirectStandardError "test_stderr.txt"
Write-Output "Exit code: $($proc.ExitCode)"
Write-Output "--- STDOUT ---"
Get-Content test_stdout.txt | Select-Object -First 20
Write-Output "--- STDERR ---"
Get-Content test_stderr.txt | Select-Object -First 20
if (Test-Path test_simple.ll) { Write-Output "test_simple.ll: $((Get-Item test_simple.ll).Length) bytes" } else { Write-Output "test_simple.ll NOT created" }
