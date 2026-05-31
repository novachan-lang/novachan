Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "demo_frameworks_v2_test.nova" -TimeoutMs 60000
Write-Host "Compile exit: $($cr.ExitCode)"
if ($cr.StdOut) { Write-Host $cr.StdOut }
if ($cr.ExitCode -ne 0) {
    if ($cr.StdErr) { Write-Host "stderr: $($cr.StdErr)" }
    exit 1
}

$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o demo_frameworks_v2_test.exe demo_frameworks_v2_test.ll nova_runtime.c -lws2_32 -ladvapi32" -TimeoutMs 60000
Write-Host "Link exit: $($lr.ExitCode)"
if ($lr.StdErr -match "lld-link: error") {
    $lines = $lr.StdErr -split "`n" | Where-Object { $_ -match "error" }
    foreach ($l in $lines) { Write-Host "  $l" }
    exit 1
}

$rr = Invoke-Timed -FilePath (Resolve-Path ".\demo_frameworks_v2_test.exe").Path -TimeoutMs 15000
Write-Host "Run exit: $($rr.ExitCode) Timeout: $($rr.TimedOut)"
Write-Host "Output:"
Write-Host $rr.StdOut
if ($rr.StdErr) { Write-Host "stderr: $($rr.StdErr)" }

Remove-Item "demo_frameworks_v2_test.ll","demo_frameworks_v2_test.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
