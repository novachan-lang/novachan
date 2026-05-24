Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== Compile test_crypto_stdlib.nova ==="
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "`"test_crypto_stdlib.nova`"" -TimeoutMs 30000
Write-Host "Compile exit: $($cr.ExitCode) Timeout: $($cr.TimedOut)"
if ($cr.ExitCode -ne 0) {
    Write-Host "COMPILE FAILED:"
    Write-Host $cr.StdOut
    exit 1
}

if (!(Test-Path "test_crypto_stdlib.ll")) {
    Write-Host "FAIL: no .ll file produced"
    exit 1
}

Write-Host "=== Link ==="
Copy-Item "output\nova_runtime.c" "nova_runtime_tmp.c" -Force
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o test_crypto.exe test_crypto_stdlib.ll nova_runtime_tmp.c -lws2_32 -ladvapi32" -TimeoutMs 60000
Write-Host "Link exit: $($lr.ExitCode)"
if (!(Test-Path "test_crypto.exe")) {
    Write-Host "LINK FAILED:"
    if ($lr.StdErr) { Write-Host $lr.StdErr }
    Remove-Item "test_crypto_stdlib.ll","nova_runtime_tmp.c" -Force -ErrorAction SilentlyContinue
    exit 1
}

Write-Host "=== Run ==="
$rr = Invoke-Timed -FilePath (Resolve-Path ".\test_crypto.exe").Path -Arguments "" -TimeoutMs 15000
Write-Host "Run exit: $($rr.ExitCode) Timeout: $($rr.TimedOut)"
Write-Host $rr.StdOut

Remove-Item "test_crypto_stdlib.ll","nova_runtime_tmp.c","test_crypto.exe" -Force -ErrorAction SilentlyContinue
