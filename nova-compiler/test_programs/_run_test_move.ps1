Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$compiler = ".\gen2_move.exe"
$test = "move_elision_test"

# Compile
$cr = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "$test.nova" -TimeoutMs 30000
Write-Host "Compile exit: $($cr.ExitCode) Timeout: $($cr.TimedOut)"
if ($cr.StdErr) { Write-Host "Compile stderr: $($cr.StdErr.Substring(0, [Math]::Min(500, $cr.StdErr.Length)))" }
if (!(Test-Path "$test.ll")) { Write-Host "FAIL: no .ll"; exit 1 }

# Link
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $test.exe $test.ll nova_runtime.c -lws2_32" -TimeoutMs 60000
Write-Host "Link exit: $($lr.ExitCode) Timeout: $($lr.TimedOut)"
if (!(Test-Path "$test.exe")) { Write-Host "FAIL: no .exe"; exit 1 }

# Run
$rr = Invoke-Timed -FilePath (Resolve-Path ".\$test.exe").Path -Arguments "" -TimeoutMs 10000
Write-Host "Run exit: $($rr.ExitCode) Timeout: $($rr.TimedOut)"
Write-Host "OUTPUT:"
Write-Host $rr.StdOut

Remove-Item "$test.ll" -Force -ErrorAction SilentlyContinue
Remove-Item "$test.exe" -Force -ErrorAction SilentlyContinue
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
