Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Verifies the Phase 11/13 domain stdlib modules. Each is a self-contained
# .nova file with a main() running asserts + printing "<name> ok".

$modules = @('math3d', 'ecs', 'crypto_util', 'netutil', 'compress_rle', 'nn', 'physics2d', 'stats', 'router', 'validate')

$pass = 0; $fail = 0; $failures = @()
Write-Host "=== DOMAIN MODULES TEST ==="

foreach ($m in $modules) {
    $nova = "$PSScriptRoot\$m.nova"
    if (!(Test-Path $nova)) { Write-Host "SKIP $m (no file)"; continue }
    Remove-Item "$m.ll","$m.exe" -Force -ErrorAction SilentlyContinue
    $cr = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments "$m.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if ($cr.ExitCode -ne 0) {
        Write-Host "FAIL compile: $m"
        if ($cr.StdOut) { Write-Host $cr.StdOut.Substring(0,[Math]::Min(400,$cr.StdOut.Length)) }
        $failures += "$m (COMPILE)"; $fail++; continue
    }
    if (!(Test-Path "$m.ll")) { Write-Host "FAIL $m (no .ll)"; $failures += "$m (NO .ll)"; $fail++; continue }
    $linkArgs = "-O2 -o `"$m.exe`" `"$m.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
    Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot | Out-Null
    if (!(Test-Path "$m.exe")) { Write-Host "FAIL link: $m"; $failures += "$m (LINK)"; $fail++; Remove-Item "$m.ll" -Force -ErrorAction SilentlyContinue; continue }
    $rr = Invoke-Timed -FilePath ".\$m.exe" -Arguments '' -TimeoutMs 10000 -WorkingDirectory $PSScriptRoot
    Remove-Item "$m.ll","$m.exe" -Force -ErrorAction SilentlyContinue
    if ($rr.TimedOut) { Write-Host "FAIL timeout: $m"; $failures += "$m (TIMEOUT)"; $fail++ }
    elseif ($rr.ExitCode -ne 0) { Write-Host "FAIL run: $m (exit=$($rr.ExitCode))"; if ($rr.StdOut) { Write-Host $rr.StdOut } ; $failures += "$m (RUN)"; $fail++ }
    elseif ($rr.StdErr -and $rr.StdErr -match "FAIL") { Write-Host "FAIL assert: $m"; Write-Host $rr.StdErr; $failures += "$m (ASSERT)"; $fail++ }
    else { Write-Host "PASS $m  -  $($rr.StdOut.Trim())"; $pass++ }
}

Write-Host "`n=== DOMAIN MODULES: $pass PASS, $fail FAIL ==="
if ($failures.Count -gt 0) { foreach ($f in $failures) { Write-Host "  $f" } }
if ($fail -gt 0) { exit 1 }
