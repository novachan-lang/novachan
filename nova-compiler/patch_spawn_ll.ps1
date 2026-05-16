$dir = "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
$tests = @('spawn_multi_test','spawn_compute_test','spawn_fanin_test','spawn_bidir_test','spawn_block_test','spawn_capture_test')
foreach ($t in $tests) {
    $f = "$dir\$t.ll"
    $content = Get-Content $f -Raw
    if ($content -notmatch 'declare void @nova_rt_init') {
        $content = $content -replace 'declare void @nova_rt_cleanup\(\)', "declare void @nova_rt_cleanup()`ndeclare void @nova_rt_init()"
    }
    if ($content -notmatch 'call void @nova_rt_init') {
        $content = $content -replace '(entry:\s*\r?\n)(  call i64 @nova_main)', "`$1  call void @nova_rt_init()`n`$2"
    }
    Set-Content $f $content -NoNewline
    Write-Host "Patched $t.ll"
}
