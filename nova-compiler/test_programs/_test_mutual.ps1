Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$testFile = "forward_type_err_test.nova"
$r = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments $testFile -TimeoutMs 30000
Write-Host "COMPILE EXIT=$($r.ExitCode)"
if ($r.StdOut -ne "") { Write-Host $r.StdOut }
if ($r.StdErr -ne "") { Write-Host "STDERR: $($r.StdErr)" }

if ($r.ExitCode -eq 0 -and (Test-Path "forward_type_err_test.ll")) {
    $l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o forward_type_err_test.exe forward_type_err_test.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
    Write-Host "LINK EXIT=$($l.ExitCode)"
    if ($l.StdErr -ne "") { Write-Host "LINK STDERR: $($l.StdErr)" }

    if (Test-Path "forward_type_err_test.exe") {
        $t = Invoke-Timed -FilePath (Resolve-Path ".\forward_type_err_test.exe").Path -Arguments "" -TimeoutMs 10000
        Write-Host "RUN EXIT=$($t.ExitCode)"
        Write-Host $t.StdOut
        if ($t.StdErr -ne "") { Write-Host "RUN STDERR: $($t.StdErr)" }
    }
}

Remove-Item "forward_type_err_test.ll","forward_type_err_test.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
