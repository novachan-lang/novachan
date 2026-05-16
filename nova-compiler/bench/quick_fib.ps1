$root = "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler"

for ($i = 0; $i -lt 5; $i++) {
    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    & "$root\bench\gate4_fib_O2.exe" | Out-Null
    $sw.Stop()
    $c = $sw.ElapsedMilliseconds

    $sw = [System.Diagnostics.Stopwatch]::StartNew()
    & "$root\bench\gate4_nova_fib_O2.exe" | Out-Null
    $sw.Stop()
    $n = $sw.ElapsedMilliseconds

    $pct = [math]::Round(($n - $c) / [math]::Max($c, 1) * 100, 1)
    Write-Host "Run $i  C=${c}ms  NOVA=${n}ms  overhead=${pct}%"
}
