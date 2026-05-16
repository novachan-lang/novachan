$exe = ".\test_programs\spawn_test.exe"
$p = Start-Process -FilePath $exe -NoNewWindow -Wait -PassThru -RedirectStandardOutput 'sp_out.txt' -RedirectStandardError 'sp_err.txt'
Write-Host "Exit: $($p.ExitCode)"
$o = Get-Content 'sp_out.txt' -ErrorAction SilentlyContinue
if ($o) { Write-Host "STDOUT:"; $o | ForEach-Object { Write-Host "  $_" } } else { Write-Host "STDOUT: (empty)" }
$e = Get-Content 'sp_err.txt' -ErrorAction SilentlyContinue
if ($e) { Write-Host "STDERR:"; $e | ForEach-Object { Write-Host "  $_" } } else { Write-Host "STDERR: (empty)" }
Remove-Item 'sp_out.txt','sp_err.txt' -ErrorAction SilentlyContinue
