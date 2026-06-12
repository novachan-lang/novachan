param([string]$t = "bench_track8_big")
$dir = $PSScriptRoot
. "$dir\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
# compile .nova -> .ll with current compiler
$c = Invoke-Timed -FilePath "$dir\gen3_test.exe" -Arguments "$t.nova" -TimeoutMs 60000
if ($c.ExitCode -ne 0) { Write-Host "COMPILE-FAIL $($c.StdErr)"; exit 1 }
# baseline -O2
& clang -O2 -o "$dir\_lto_base.exe" "$dir\$t.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
# LTO -O2 -flto -fuse-ld=lld
$ltoStart = Get-Date
& clang -O2 -flto -fuse-ld=lld -o "$dir\_lto_opt.exe" "$dir\$t.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
$ltoLink = ((Get-Date) - $ltoStart).TotalMilliseconds
if (!(Test-Path "$dir\_lto_opt.exe")) { Write-Host "LTO LINK FAILED"; exit 1 }
Write-Host "built both (LTO link ${ltoLink}ms). timing 3 runs each:"
function timeit($exe) {
    $best = 1e12
    for ($i=0; $i -lt 3; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $r = Invoke-Timed -FilePath $exe -TimeoutMs 60000
        $sw.Stop()
        if ($r.TimedOut) { return -1 }
        if ($sw.Elapsed.TotalMilliseconds -lt $best) { $best = $sw.Elapsed.TotalMilliseconds }
    }
    return [Math]::Round($best, 1)
}
$base = timeit "$dir\_lto_base.exe"
$lto = timeit "$dir\_lto_opt.exe"
Write-Host "$t : -O2 = ${base}ms | -O2+LTO = ${lto}ms | speedup = $([Math]::Round($base/$lto,3))x"
