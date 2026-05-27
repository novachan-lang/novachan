. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$r1 = Invoke-Timed -FilePath "$PSScriptRoot\gen2_move.exe" -Arguments "catch_simple.nova" -TimeoutMs 15000
if ($r1.ExitCode -ne 0) { Write-Host "FAIL compile: $($r1.StdOut)"; exit 1 }

Write-Host "=== Generated IR ==="
# Show the relevant part of the IR
$content = Get-Content "catch_simple.ll" -Raw
$lines = $content -split "`n"
$inMain = $false
foreach ($line in $lines) {
    if ($line -match "define.*nova_user_main") { $inMain = $true }
    if ($inMain) {
        Write-Host $line
        if ($line -match "^\}") { break }
    }
}

Write-Host ""
Write-Host "=== Run ==="
$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o catch_simple.exe catch_simple.ll nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
$r3 = Invoke-Timed -FilePath "$PSScriptRoot\catch_simple.exe" -Arguments "" -TimeoutMs 10000
Write-Host "EXIT=$($r3.ExitCode)"
Write-Host $r3.StdOut
if ($r3.StdErr -ne "") { Write-Host "STDERR: $($r3.StdErr)" }

Remove-Item "catch_simple.ll","catch_simple.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
