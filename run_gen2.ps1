Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
$proc = Start-Process -FilePath ".\gen1_new.exe" -ArgumentList "nova_compiler.nova","gen2_new.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "gen2_stdout.txt" -RedirectStandardError "gen2_stderr.txt"
Write-Output "Exit code: $($proc.ExitCode)"
Write-Output "--- STDOUT ---"
Get-Content gen2_stdout.txt | Select-Object -First 30
Write-Output "--- STDERR ---"
Get-Content gen2_stderr.txt | Select-Object -First 30
if (Test-Path gen2_new.ll) { Write-Output "gen2_new.ll: $((Get-Item gen2_new.ll).Length) bytes" } else { Write-Output "gen2_new.ll NOT created" }
