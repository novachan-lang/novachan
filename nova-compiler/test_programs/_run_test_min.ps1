Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$compiler = ".\gen2_move.exe"
$test = "move_min_test"
$cr = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "$test.nova" -TimeoutMs 30000
Write-Host "Compile exit: $($cr.ExitCode) Timeout: $($cr.TimedOut)"
if ($cr.StdErr) { Write-Host "Stderr: $($cr.StdErr.Substring(0, [Math]::Min(500, $cr.StdErr.Length)))" }
if (Test-Path "$test.ll") {
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $test.exe $test.ll nova_runtime.c -lws2_32" -TimeoutMs 60000
    if (Test-Path "$test.exe") {
        $rr = Invoke-Timed -FilePath (Resolve-Path ".\$test.exe").Path -Arguments "" -TimeoutMs 10000
        Write-Host "Run: exit=$($rr.ExitCode) out=$($rr.StdOut.TrimEnd())"
    }
    Remove-Item "$test.ll","$test.exe" -Force -ErrorAction SilentlyContinue
} else { Write-Host "FAIL: no .ll" }
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
