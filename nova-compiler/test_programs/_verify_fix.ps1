# Verify the cross-module-struct field-resolution fix BEFORE reconverge: build gen4 from the
# fixed nova_compiler.nova, then compile+run the repro (_xs_main, expect x.a=7) + the typed
# core test through gen4. Kill-on-timeout throughout.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "[1] gen3 compiles fixed nova_compiler.nova -> nova_compiler.ll ..."
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 900000 -WorkingDirectory $PSScriptRoot
if ($c.ExitCode -ne 0 -or !(Test-Path nova_compiler.ll)) { Write-Host "COMPILE FAIL exit=$($c.ExitCode)"; if ($c.StdOut) { Write-Host ($c.StdOut.Substring(0,[Math]::Min(1500,$c.StdOut.Length))) }; exit 1 }

Write-Host "[2] link gen4_test.exe (the fixed compiler) ..."
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen4_test.exe nova_compiler.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path gen4_test.exe)) { Write-Host "LINK gen4 FAIL"; exit 1 }
Write-Host "gen4 built OK"

# refresh runtime.o for test links
Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 output\nova_runtime.c -o output\nova_runtime.o -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot | Out-Null

foreach ($t in @("_xs_main", "forge_typed_core_test")) {
    Write-Host "--- $t (via gen4) ---"
    Remove-Item "$t.ll", "$t.exe" -Force -ErrorAction SilentlyContinue
    $tc = Invoke-Timed -FilePath ".\gen4_test.exe" -Arguments "$t.nova" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
    if ($tc.ExitCode -ne 0) { Write-Host "$t COMPILE FAIL"; if ($tc.StdOut) { Write-Host $tc.StdOut }; continue }
    $tl = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $t.exe $t.ll output\nova_runtime.o -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path "$t.exe")) { Write-Host "$t LINK FAIL"; continue }
    $tr = Invoke-Timed -FilePath ".\$t.exe" -Arguments "" -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
    Write-Host "OUT: $($tr.StdOut)"
    Write-Host "ERR: $($tr.StdErr)"
    Write-Host "exit=$($tr.ExitCode)"
}
