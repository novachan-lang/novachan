$dir = $PSScriptRoot
. "$dir\_proc_util.ps1"
function timeit($exe) {
    if (-not (Test-Path $exe)) { return @{ms="MISSING"; out=""} }
    $best = 1e12; $o=""
    for ($i=0; $i -lt 6; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $r = Invoke-Timed -FilePath $exe -TimeoutMs 60000
        $sw.Stop()
        if ($r.TimedOut) { return @{ms="TIMEOUT"; out=""} }
        if ($sw.Elapsed.TotalMilliseconds -lt $best) { $best = $sw.Elapsed.TotalMilliseconds; $o = $r.StdOut.Trim() }
    }
    return @{ms=[Math]::Round($best,1); out=$o}
}
$c   = timeit "$dir\dotbench_c.exe"
$i64 = timeit "$dir\dotbench_nova.exe"
$nat = timeit "$dir\dotbench_native.exe"
Write-Host "C (clang -O2)      : $($c.ms)ms   out=$($c.out)"
Write-Host "NOVA i64-ABI       : $($i64.ms)ms   out=$($i64.out)  ratio $([Math]::Round($i64.ms/$c.ms,3))x"
Write-Host "NOVA native-ABI    : $($nat.ms)ms   out=$($nat.out)  ratio $([Math]::Round($nat.ms/$c.ms,3))x"
$cm = timeit "$dir\dotbench_combined.exe"
Write-Host "NOVA combined 4b+5 : $($cm.ms)ms   out=$($cm.out)  ratio $([Math]::Round($cm.ms/$c.ms,3))x"
