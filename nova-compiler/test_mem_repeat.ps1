$pass=0; $fail=0
for ($i=1; $i -le 40; $i++) {
    $p = Start-Process -FilePath '.\test_out_memory_stress_test.exe' -NoNewWindow -Wait -PassThru -RedirectStandardOutput 'test_tmp_stdout.txt' -RedirectStandardError 'test_tmp_stderr.txt'
    if ($p.ExitCode -eq 0) { $pass++ } else { $fail++ }
}
Write-Host "memory_stress_test: Pass=$pass Fail=$fail"
