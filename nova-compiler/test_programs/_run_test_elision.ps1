Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$compiler = ".\gen2_move.exe"
$test = "move_elision_test"
$cr = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "$test.nova" -TimeoutMs 30000
Write-Host "Compile exit: $($cr.ExitCode)"
if (!(Test-Path "$test.ll")) { Write-Host "FAIL: no .ll"; exit 1 }
$moveCount = (Select-String -Path "$test.ll" -Pattern "call.*channel_send_move" -SimpleMatch).Count
$sendCount = (Select-String -Path "$test.ll" -Pattern "call.*channel_send\b" ).Count
Write-Host "IR: send_move calls=$moveCount  regular send calls=$sendCount"
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $test.exe $test.ll nova_runtime.c -lws2_32" -TimeoutMs 60000
if (!(Test-Path "$test.exe")) { Write-Host "FAIL: no .exe"; exit 1 }
$rr = Invoke-Timed -FilePath (Resolve-Path ".\$test.exe").Path -Arguments "" -TimeoutMs 10000
Write-Host "Run: exit=$($rr.ExitCode) timeout=$($rr.TimedOut)"
Write-Host "Output:"
Write-Host $rr.StdOut
Write-Host "Expected: 3 10 30 3 2 7 42 2 2"
Remove-Item "$test.ll","$test.exe" -Force -ErrorAction SilentlyContinue
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
