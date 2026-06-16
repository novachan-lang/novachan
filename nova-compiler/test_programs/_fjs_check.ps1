# Verify the from_json_safe shadow-gate fix with the ALREADY-BUILT gen4_test.exe (no rebuild).
# Runs shadow_test (the regression that broke) + the from_json_safe guards + the from_json suite.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$gen4 = Join-Path $PSScriptRoot "gen4_test.exe"
$fail = 0
foreach ($t in @("shadow_test","from_json_safe_test","from_json_safe_forge_test","from_json_safety_test","from_json_test","auto_json_test","rtti_json_test")) {
    Remove-Item "$t.ll","$t.exe" -Force -ErrorAction SilentlyContinue
    $cc = Invoke-Timed -FilePath $gen4 -Arguments "$t.nova" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path "$t.ll")) { Write-Host "$t COMPILE FAIL"; if($cc.StdOut){Write-Host $cc.StdOut}; $fail=1; continue }
    $lk = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $t.exe $t.ll output\nova_runtime.o -lws2_32 -ladvapi32 -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path "$t.exe")) { Write-Host "$t LINK FAIL"; $fail=1; continue }
    $r = Invoke-Timed -FilePath (Join-Path $PSScriptRoot "$t.exe") -Arguments "" -TimeoutMs 20000 -WorkingDirectory $PSScriptRoot
    $o = ([string]$r.StdOut).Trim()
    Write-Host "--- ${t}: exit=$($r.ExitCode) ---"
    Write-Host $o
    if ($r.ExitCode -ne 0 -or $o -notmatch "passed") { Write-Host "*** $t FAIL ***"; $fail=1 }
}
Write-Host ""
if ($fail -eq 0) { Write-Host "=== ALL PASS ===" } else { Write-Host "=== FAILED ==="; exit 1 }
