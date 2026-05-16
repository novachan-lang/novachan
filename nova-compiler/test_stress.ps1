$tests = @('production_test', 'selfhost_stress_test', 'memory_stress_test')
foreach ($t in $tests) {
    $pass=0; $fail=0
    for ($i=1; $i -le 20; $i++) {
        $p = Start-Process -FilePath ".\test_out_$t.exe" -NoNewWindow -Wait -PassThru -RedirectStandardOutput 'test_tmp_stdout.txt' -RedirectStandardError 'test_tmp_stderr.txt'
        if ($p.ExitCode -eq 0) { $pass++ } else { $fail++ }
    }
    Write-Host "${t}: Pass=$pass Fail=$fail"
}
