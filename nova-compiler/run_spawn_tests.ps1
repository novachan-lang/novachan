$dir = "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
$tests = @('spawn_test','spawn_multi_test','spawn_compute_test','spawn_fanin_test','spawn_bidir_test','spawn_block_test','spawn_capture_test')
$pass = 0; $fail = 0
foreach ($t in $tests) {
    $exe = "$dir\$t.exe"
    if (-not (Test-Path $exe)) { Write-Host "SKIP  $t (no exe)"; continue }
    $p = Start-Process -FilePath $exe -NoNewWindow -Wait -PassThru -RedirectStandardOutput "$dir\tmp_out.txt" -RedirectStandardError "$dir\tmp_err.txt"
    if ($p.ExitCode -eq 0) {
        Write-Host "PASS  $t"
        $pass++
    } else {
        Write-Host "FAIL  $t (exit=$($p.ExitCode))"
        $fail++
    }
    Remove-Item "$dir\tmp_out.txt","$dir\tmp_err.txt" -ErrorAction SilentlyContinue
}
Write-Host "`nSpawn tests: $pass passed, $fail failed"
