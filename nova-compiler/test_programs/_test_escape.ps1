Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$r = Invoke-Timed -FilePath ".\gen2_move.exe" -Arguments "escape_test_quick.nova" -TimeoutMs 30000
Write-Host "COMPILE EXIT=$($r.ExitCode)"
if ($r.StdOut -ne "") { Write-Host $r.StdOut }
if ($r.StdErr -ne "") { Write-Host $r.StdErr }

if ($r.ExitCode -eq 0 -and (Test-Path "escape_test_quick.ll")) {
    $l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o escape_test_quick.exe escape_test_quick.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
    if (Test-Path "escape_test_quick.exe") {
        $t = Invoke-Timed -FilePath (Resolve-Path ".\escape_test_quick.exe").Path -Arguments "" -TimeoutMs 10000
        Write-Host "RUN EXIT=$($t.ExitCode)"
        Write-Host $t.StdOut
    }
}
Remove-Item "escape_test_quick.ll","escape_test_quick.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
