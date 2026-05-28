Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
$proc = Start-Process -FilePath "..\output.exe" -ArgumentList "test_simple.nova","test_output_simple.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "out_stdout.txt" -RedirectStandardError "out_stderr.txt"
Write-Output "Exit code: $($proc.ExitCode)"
Write-Output "--- STDOUT ---"
Get-Content out_stdout.txt | Select-Object -First 20
Write-Output "--- STDERR ---"
Get-Content out_stderr.txt | Select-Object -First 20
if (Test-Path test_output_simple.ll) { Write-Output "test_output_simple.ll: $((Get-Item test_output_simple.ll).Length) bytes" } else { Write-Output "test_output_simple.ll NOT created" }
