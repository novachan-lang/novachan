# Kills any process whose executable lives in test_programs (compiler/test binaries).
# Safe: that directory only contains NOVA compiler and test executables.
$dir = "c:\Users\mange\Crypto\AI\New folder\New folder\nova-compiler\test_programs"
$killed = 0
Get-Process | ForEach-Object {
    $p = $_
    $path = $null
    try { $path = $p.Path } catch {}
    if ($path -and $path.StartsWith($dir, [System.StringComparison]::OrdinalIgnoreCase)) {
        try {
            $p.Kill()
            $p.WaitForExit(2000) | Out-Null
            $killed = $killed + 1
            Write-Host "Killed $($p.ProcessName) (PID $($p.Id))"
        } catch {}
    }
}
Write-Host "Total killed: $killed"
