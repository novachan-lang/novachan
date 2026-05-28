Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_trait.exe").Path -Arguments "tco_test.nova" -TimeoutMs 30000
if ($cr.TimedOut) {
    Write-Host "COMPILE TIMED OUT (killed)"
    Remove-Item nova_runtime.c -Force -ErrorAction SilentlyContinue
    exit 1
}
Write-Host "Compile exit=$($cr.ExitCode)"
if ($cr.StdErr) { Write-Host "STDERR: $($cr.StdErr)" }

if (Test-Path "tco_test.ll") {
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o tco_test.exe tco_test.ll nova_runtime.c -lws2_32" -TimeoutMs 60000
    if ((-not $lr.TimedOut) -and (Test-Path "tco_test.exe")) {
        $rr = Invoke-Timed -FilePath (Resolve-Path ".\tco_test.exe").Path -Arguments "" -TimeoutMs 15000
        if ($rr.TimedOut) {
            Write-Host "RUN TIMED OUT (killed): TCO likely produced an infinite loop"
        } else {
            Write-Host "Run exit=$($rr.ExitCode)"
            Write-Host $rr.StdOut
            if ($rr.StdErr) { Write-Host "RUN STDERR: $($rr.StdErr)" }
        }
        Remove-Item tco_test.exe -Force -ErrorAction SilentlyContinue
    } else {
        Write-Host "LINK FAILED"
    }
    Remove-Item tco_test.ll -Force -ErrorAction SilentlyContinue
} else {
    Write-Host "COMPILE FAILED: no .ll"
}
Remove-Item nova_runtime.c -Force -ErrorAction SilentlyContinue
