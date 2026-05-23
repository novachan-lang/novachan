Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$compiler = ".\gen2_move.exe"

foreach ($test in @("move_tiny_test", "move_min_test", "move_cap_test", "move_assign_test")) {
    if (!(Test-Path "$test.nova")) { continue }
    $cr = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "$test.nova" -TimeoutMs 30000
    Write-Host "$test compile: exit=$($cr.ExitCode)"
    if (!(Test-Path "$test.ll")) { Write-Host "  FAIL: no .ll"; continue }
    # Check for send_move in generated IR
    $moveCount = (Select-String -Path "$test.ll" -Pattern "channel_send_move" -SimpleMatch).Count
    $sendCount = (Select-String -Path "$test.ll" -Pattern "channel_send" -SimpleMatch).Count
    Write-Host "  IR: send_move=$moveCount total_send=$sendCount"
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $test.exe $test.ll nova_runtime.c -lws2_32" -TimeoutMs 60000
    if (!(Test-Path "$test.exe")) { Write-Host "  FAIL: no .exe"; continue }
    $rr = Invoke-Timed -FilePath (Resolve-Path ".\$test.exe").Path -Arguments "" -TimeoutMs 10000
    Write-Host "  Run: exit=$($rr.ExitCode) out=$($rr.StdOut.TrimEnd())"
    Remove-Item "$test.ll","$test.exe" -Force -ErrorAction SilentlyContinue
}
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
