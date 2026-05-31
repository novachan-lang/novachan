Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "track7_stdlib_full_test.nova" -TimeoutMs 60000
Write-Host "Compile exit: $($cr.ExitCode)"
if ($cr.StdOut) { Write-Host $cr.StdOut }
if ($cr.ExitCode -ne 0) {
    if ($cr.StdErr) { Write-Host "stderr: $($cr.StdErr)" }
    exit 1
}

$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o track7_stdlib_full_test.exe track7_stdlib_full_test.ll nova_runtime.c $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000
Write-Host "Link exit: $($lr.ExitCode)"
if (!(Test-Path "track7_stdlib_full_test.exe")) {
    if ($lr.StdErr) {
        $lines = $lr.StdErr -split "`n" | Where-Object { $_ -match "error" }
        foreach ($l in $lines) { Write-Host "  $l" }
    }
    exit 1
}

$rr = Invoke-Timed -FilePath (Resolve-Path ".\track7_stdlib_full_test.exe").Path -TimeoutMs 15000
Write-Host "Run exit: $($rr.ExitCode) Timeout: $($rr.TimedOut)"
Write-Host "Output:"
Write-Host $rr.StdOut
if ($rr.StdErr) { Write-Host "stderr: $($rr.StdErr)" }

Remove-Item "track7_stdlib_full_test.ll","track7_stdlib_full_test.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
