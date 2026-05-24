param([string]$exe)
$proc = Start-Process -FilePath $exe -NoNewWindow -PassThru -RedirectStandardOutput "test_stdout.txt" -RedirectStandardError "test_stderr.txt"
$done = $proc.WaitForExit(5000)
if ($done) {
    Write-Host "EXIT: $($proc.ExitCode)"
    Get-Content "test_stdout.txt"
} else {
    $proc.Kill()
    Write-Host "TIMEOUT"
}
