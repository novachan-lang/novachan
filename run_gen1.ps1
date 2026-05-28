Set-Location "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
$proc = Start-Process -FilePath ".\gen1_final.exe" -ArgumentList "nova_compiler.nova","gen1_new.ll" -Wait -PassThru -NoNewWindow -RedirectStandardOutput "gen1_stdout.txt" -RedirectStandardError "gen1_stderr.txt"
Write-Output "Exit code: $($proc.ExitCode)"
Write-Output "--- STDOUT ---"
Get-Content gen1_stdout.txt | Select-Object -First 20
Write-Output "--- STDERR ---"
Get-Content gen1_stderr.txt | Select-Object -First 20
if (Test-Path gen1_new.ll) { Write-Output "gen1_new.ll: $((Get-Item gen1_new.ll).Length) bytes" } else { Write-Output "gen1_new.ll NOT created" }
