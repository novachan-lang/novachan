$p = Start-Process -FilePath '.\test_out_memory_stress_test.exe' -NoNewWindow -Wait -PassThru -RedirectStandardOutput 'diag_out.txt' -RedirectStandardError 'diag_err.txt'
Write-Host "Exit: $($p.ExitCode)"
$err = Get-Content 'diag_err.txt' -ErrorAction SilentlyContinue
if ($err) { Write-Host "STDERR:"; $err | ForEach-Object { Write-Host "  $_" } } else { Write-Host "STDERR: (empty)" }
$out = Get-Content 'diag_out.txt' -ErrorAction SilentlyContinue
if ($out) { Write-Host "Last stdout line: $($out[-1])" }
Remove-Item 'diag_out.txt','diag_err.txt' -ErrorAction SilentlyContinue
