$dir = $PSScriptRoot
. "$dir\_proc_util.ps1"
$env:NOVA_NO_CACHE = "1"
$c = Invoke-Timed -FilePath "$dir\gen3_test.exe" -Arguments "dotbench.nova" -TimeoutMs 60000
if ($c.ExitCode -ne 0) { Write-Host "COMPILE-FAIL $($c.StdErr)"; exit 1 }
& clang -O2 -o "$dir\dotbench_nova.exe" "$dir\dotbench.ll" "$dir\output\nova_runtime.c" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w 2>$null
function timeit($exe) {
    $best = 1e12
    for ($i=0; $i -lt 3; $i++) {
        $sw = [System.Diagnostics.Stopwatch]::StartNew()
        $r = Invoke-Timed -FilePath $exe -TimeoutMs 60000
        $sw.Stop()
        if ($r.TimedOut) { return @{ms=-1; out=""} }
        if ($sw.Elapsed.TotalMilliseconds -lt $best) { $best = $sw.Elapsed.TotalMilliseconds; $script:lastout = $r.StdOut.Trim() }
    }
    return @{ms=[Math]::Round($best,1); out=$script:lastout}
}
$nv = timeit "$dir\dotbench_nova.exe"
$cc = timeit "$dir\dotbench_c.exe"
Write-Host "NOVA: $($nv.ms)ms (out=$($nv.out))"
Write-Host "C   : $($cc.ms)ms (out=$($cc.out))"
Write-Host "ratio NOVA/C = $([Math]::Round($nv.ms/$cc.ms, 3))x  (lower is better; <=1.0 means NOVA matches/beats C)"
# also probe the IR for the dot lowering
$fmul = (Select-String -Path "$dir\dotbench.ll" -Pattern "fmul" -AllMatches | Measure-Object).Count
$mulcall = (Select-String -Path "$dir\dotbench.ll" -Pattern "nova_rt_mul|nova_rt_unbox" -AllMatches | Measure-Object).Count
Write-Host "dotbench.ll: fmul lines=$fmul ; nova_rt_mul/unbox lines=$mulcall"
