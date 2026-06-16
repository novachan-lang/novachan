# Verify the from_json missing-field fix BEFORE reconverge: build gen4 from the edited
# nova_compiler.nova, then compile+run from_json_safety_test (missing/malformed/nested -> safe
# defaults, no crash) AND the existing from_json_test (well-formed must NOT regress). Kill-on-timeout.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "[1] gen3 compiles edited nova_compiler.nova -> gen4_test.exe"
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 900000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path nova_compiler.ll)) { Write-Host "COMPILE FAIL exit=$($c.ExitCode)"; if($c.StdOut){Write-Host ($c.StdOut.Substring(0,[Math]::Min(2500,$c.StdOut.Length)))}; exit 1 }
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen4_test.exe nova_compiler.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path gen4_test.exe)) { Write-Host "LINK gen4 FAIL"; exit 1 }
Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 output\nova_runtime.c -o output\nova_runtime.o -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot | Out-Null
Write-Host "gen4 built OK"

$gen4 = Join-Path $PSScriptRoot "gen4_test.exe"
$fail = 0
foreach ($t in @("from_json_safety_test","from_json_test","auto_json_test","rtti_json_test")) {
    Remove-Item "$t.ll","$t.exe" -Force -ErrorAction SilentlyContinue
    $cc = Invoke-Timed -FilePath $gen4 -Arguments "$t.nova" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path "$t.ll")) { Write-Host "$t COMPILE FAIL"; if($cc.StdOut){Write-Host $cc.StdOut}; $fail=1; continue }
    $lk = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $t.exe $t.ll output\nova_runtime.o -lws2_32 -ladvapi32 -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path "$t.exe")) { Write-Host "$t LINK FAIL"; $fail=1; continue }
    $r = Invoke-Timed -FilePath ".\$t.exe" -Arguments "" -TimeoutMs 15000 -WorkingDirectory $PSScriptRoot
    $o = ([string]$r.StdOut).Trim()
    Write-Host "--- ${t}: exit=$($r.ExitCode) ---"
    Write-Host $o
    if ($r.ExitCode -ne 0 -or $o -notmatch "passed") { Write-Host "*** $t FAIL ***"; $fail=1 }
}
Write-Host ""
if ($fail -eq 0) { Write-Host "=== from_json fix VERIFIED (safety + no regression) ===" } else { Write-Host "=== FAILED ==="; exit 1 }
