Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

# Compile + link + run stdlib_extra_test.nova
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "stdlib_extra_test.nova" -TimeoutMs 60000
Write-Host "Compile exit: $($cr.ExitCode)"
if ($cr.ExitCode -ne 0) {
    Write-Host "stdout: $($cr.StdOut)"
    Write-Host "stderr: $($cr.StdErr)"
    exit 1
}

if (!(Test-Path "stdlib_extra_test.ll")) {
    Write-Host "FAIL: no .ll produced"
    exit 1
}

$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o stdlib_extra_test.exe stdlib_extra_test.ll nova_runtime.c -lws2_32" -TimeoutMs 60000
Write-Host "Link exit: $($lr.ExitCode)"
if (!(Test-Path "stdlib_extra_test.exe")) {
    Write-Host "FAIL: no exe"
    exit 1
}

$rr = Invoke-Timed -FilePath (Resolve-Path ".\stdlib_extra_test.exe").Path -Arguments "" -TimeoutMs 15000
Write-Host "Run exit: $($rr.ExitCode)"
Write-Host "Output:"
Write-Host $rr.StdOut

if ($rr.StdOut -match "All stdlib tests passed") {
    Write-Host "=== ALL PASS ==="
} else {
    Write-Host "FAIL: did not see success marker"
    exit 1
}

Remove-Item "stdlib_extra_test.ll","stdlib_extra_test.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
