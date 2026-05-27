. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

Write-Host "=== Compile with gen3 (has error fix) ==="
$r1 = Invoke-Timed -FilePath "$PSScriptRoot\gen3_test.exe" -Arguments "catch_simple.nova" -TimeoutMs 15000
if ($r1.ExitCode -ne 0) { Write-Host "FAIL compile: $($r1.StdOut) $($r1.StdErr)"; exit 1 }

# Show fail() IR
$lines = Get-Content "catch_simple.ll"
$inFail = $false
foreach ($line in $lines) {
    if ($line -match "define.*@fail\(\)") { $inFail = $true }
    if ($inFail) {
        Write-Host $line
        if ($line -match "^\}") { $inFail = $false; break }
    }
}

Write-Host ""
$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o catch_simple.exe catch_simple.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
$r3 = Invoke-Timed -FilePath "$PSScriptRoot\catch_simple.exe" -Arguments "" -TimeoutMs 10000
Write-Host "EXIT=$($r3.ExitCode)"
Write-Host $r3.StdOut
if ($r3.StdErr -ne "") { Write-Host "STDERR: $($r3.StdErr)" }

Remove-Item "catch_simple.ll","catch_simple.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
