$dir = $PSScriptRoot
. "$dir\_proc_util.ps1"
function timeit($exe) {
    if (-not (Test-Path $exe)) { return "MISSING" }
    $best = 1e12
    for ($i=0; $i -lt 5; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $r = Invoke-Timed -FilePath $exe -TimeoutMs 60000
        $sw.Stop()
        if ($r.TimedOut) { return "TIMEOUT" }
        if ($sw.Elapsed.TotalMilliseconds -lt $best) { $best = $sw.Elapsed.TotalMilliseconds }
    }
    return [Math]::Round($best,1)
}
$c   = timeit "$dir\dotbench_c.exe"
$ext = timeit "$dir\dotbench_nova.exe"
$int = timeit "$dir\dotbench_int.exe"
Write-Host "C (clang -O2)        : ${c}ms"
Write-Host "NOVA @dot external   : ${ext}ms  (ratio $([Math]::Round($ext/$c,3))x)"
Write-Host "NOVA @dot internal   : ${int}ms  (ratio $([Math]::Round($int/$c,3))x)"
