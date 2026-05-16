$pass=0; $fail=0
for ($i=1; $i -le 20; $i++) {
    $p = Start-Process -FilePath '.\test_out_production_test.exe' -NoNewWindow -Wait -PassThru -RedirectStandardOutput 'test_tmp_stdout.txt' -RedirectStandardError 'test_tmp_stderr.txt'
    if ($p.ExitCode -eq 0) { $pass++ } else { $fail++ }
}
Write-Host "production_test: Pass=$pass Fail=$fail"
