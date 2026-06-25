. "$PSScriptRoot\_proc_util.ps1"
$compiler = (Resolve-Path "$PSScriptRoot\nova.exe").Path
$rt = "$PSScriptRoot\nova_runtime.o"
if (-not (Test-Path $rt)) {
    Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 `"$PSScriptRoot\output\nova_runtime.c`" -o `"$rt`" -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot | Out-Null
}
$tests = @('corex','strx','urlx','csvx','bignum','complexnum','rational','basex','setops','matrixx','collx','getin','prng','uuid','bitset','graphemex','pvecx','coro')
$pass=0; $fail=0; $fails=@()
foreach ($m in $tests) {
    $n = "${m}_lib_test"
    if (-not (Test-Path "$PSScriptRoot\$n.nova")) { $fails += "$n (NO FILE)"; $fail++; continue }
    Remove-Item "$PSScriptRoot\$n.ll","$PSScriptRoot\$n.exe" -Force -ErrorAction SilentlyContinue
    $c = Invoke-Timed -FilePath $compiler -Arguments "$n.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if ($c.ExitCode -ne 0 -or -not (Test-Path "$PSScriptRoot\$n.ll")) {
        $e = ($c.StdOut -split "`n" | Select-String 'error' | Select-Object -First 1)
        $fails += "$n (COMPILE: $e)"; $fail++; continue
    }
    $lk = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$PSScriptRoot\$n.exe`" `"$PSScriptRoot\$n.ll`" `"$rt`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
    if (-not (Test-Path "$PSScriptRoot\$n.exe")) { $fails += "$n (LINK: $($lk.StdErr | Select-Object -First 1))"; $fail++; continue }
    $r = Invoke-Timed -FilePath "$PSScriptRoot\$n.exe" -TimeoutMs 20000 -WorkingDirectory $PSScriptRoot
    if ($r.TimedOut -or $r.ExitCode -ne 0 -or ($r.StdOut -notmatch 'passed')) {
        $fails += "$n (RUN exit=$($r.ExitCode): $((($r.StdOut+$r.StdErr) -split "`n" | Where-Object {$_ -match 'FAIL|assert|error'} | Select-Object -First 1)))"; $fail++
    } else { $pass++ }
    Remove-Item "$PSScriptRoot\$n.exe","$PSScriptRoot\$n.ll" -Force -ErrorAction SilentlyContinue
}
Write-Host "STDLIB SMOKE: $pass pass, $fail fail (of $($tests.Count))"
foreach ($f in $fails) { Write-Host "  FAIL $f" }
