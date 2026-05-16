$pass=0; $fail=0; $errors=@()
for ($i=1; $i -le 100; $i++) {
    $outFile = "test_mem_out_$i.txt"
    $errFile = "test_mem_err_$i.txt"
    $p = Start-Process -FilePath '.\test_out_memory_stress_test.exe' -NoNewWindow -Wait -PassThru -RedirectStandardOutput $outFile -RedirectStandardError $errFile
    if ($p.ExitCode -eq 0) {
        $pass++
    } else {
        $fail++
        $stdout = Get-Content $outFile -ErrorAction SilentlyContinue
        $lineCount = if ($stdout) { $stdout.Count } else { 0 }
        $lastLine = if ($stdout -and $stdout.Count -gt 0) { $stdout[-1] } else { "(empty)" }
        $errors += "Run $i exit=$($p.ExitCode) lines=$lineCount last='$lastLine'"
    }
    Remove-Item $outFile -ErrorAction SilentlyContinue
    Remove-Item $errFile -ErrorAction SilentlyContinue
}
Write-Host "memory_stress_test: Pass=$pass Fail=$fail out of 100"
foreach ($e in $errors) { Write-Host "  $e" }
