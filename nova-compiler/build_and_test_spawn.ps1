$dir = "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"
$tests = @('spawn_test','spawn_multi_test','spawn_compute_test','spawn_fanin_test','spawn_bidir_test','spawn_block_test','spawn_capture_test')

Write-Host "=== Compiling ==="
foreach ($t in $tests) {
    $ll = "$dir\test_programs\$t.ll"
    $exe = "$dir\test_programs\$t.exe"
    $result = & clang -O1 -DNDEBUG -w "$dir\runtime\nova_runtime.c" $ll -o $exe -lwinhttp 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "COMPILE FAIL  $t"
        $result | ForEach-Object { Write-Host "  $_" }
    } else {
        Write-Host "COMPILED  $t"
    }
}

Write-Host "`n=== Running ==="
$pass = 0; $fail = 0
foreach ($t in $tests) {
    $exe = "$dir\test_programs\$t.exe"
    $p = Start-Process -FilePath $exe -NoNewWindow -Wait -PassThru -RedirectStandardOutput "$dir\tmp_out.txt" -RedirectStandardError "$dir\tmp_err.txt"
    $out = Get-Content "$dir\tmp_out.txt" -ErrorAction SilentlyContinue
    if ($p.ExitCode -eq 0) {
        Write-Host "PASS  $t"
        if ($out) { $out | ForEach-Object { Write-Host "  $_" } }
        $pass++
    } else {
        Write-Host "FAIL  $t (exit=$($p.ExitCode))"
        if ($out) { Write-Host "  STDOUT:"; $out | ForEach-Object { Write-Host "    $_" } }
        $err = Get-Content "$dir\tmp_err.txt" -ErrorAction SilentlyContinue
        if ($err) { Write-Host "  STDERR:"; $err | ForEach-Object { Write-Host "    $_" } }
        $fail++
    }
    Remove-Item "$dir\tmp_out.txt","$dir\tmp_err.txt" -ErrorAction SilentlyContinue
}
Write-Host "`nSpawn tests: $pass passed, $fail failed"
