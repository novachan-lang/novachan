$pass=0; $fail=0; $errors=@()
for ($i=1; $i -le 50; $i++) {
    $p = Start-Process -FilePath '.\test_out_memory_stress_test.exe' -NoNewWindow -Wait -PassThru -RedirectStandardOutput "test_mem_out_$i.txt" -RedirectStandardError "test_mem_err_$i.txt"
    if ($p.ExitCode -eq 0) {
        $pass++
        Remove-Item "test_mem_out_$i.txt" -ErrorAction SilentlyContinue
        Remove-Item "test_mem_err_$i.txt" -ErrorAction SilentlyContinue
    } else {
        $fail++
        $stdout = Get-Content "test_mem_out_$i.txt" -ErrorAction SilentlyContinue
        $lastLine = if ($stdout) { $stdout[-1] } else { "(empty)" }
        $errors += "Run $i exit=$($p.ExitCode) last_output='$lastLine'"
        Remove-Item "test_mem_out_$i.txt" -ErrorAction SilentlyContinue
        Remove-Item "test_mem_err_$i.txt" -ErrorAction SilentlyContinue
    }
}
Write-Host "memory_stress_test: Pass=$pass Fail=$fail"
foreach ($e in $errors) { Write-Host "  $e" }
