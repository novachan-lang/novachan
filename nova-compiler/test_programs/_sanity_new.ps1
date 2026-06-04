Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path "$PSScriptRoot\gen3_w5b_new.exe").Path
$runtimeSrc = "$PSScriptRoot\output\nova_runtime.c"

$tests = @(
    'float_test','string_test','struct_test','closure_test',
    'dict_test','match_test','enum_test','generics_test',
    'error_test','tuple_test','trait_test','ffi_strlen_test'
)

$pass = 0; $fail = 0; $skip = 0; $failures = @()

Write-Host "=== SANITY (gen3_w5b_new.exe) ==="

foreach ($t in $tests) {
    $nova = "$PSScriptRoot\$t.nova"
    $ll   = "$PSScriptRoot\$t.ll"
    $exe  = "$PSScriptRoot\$t.exe"
    if (!(Test-Path $nova)) { $skip++; continue }
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
    if ($cr.TimedOut -or $cr.ExitCode -ne 0) {
        Write-Host "FAIL compile: $t (exit=$($cr.ExitCode))"
        if ($cr.StdErr) { Write-Host "  stderr: $($cr.StdErr.Substring(0, [Math]::Min(200, $cr.StdErr.Length)))" }
        $failures += "$t (COMPILE)"; $fail++; continue
    }
    if (!(Test-Path $ll)) { Write-Host "FAIL $t (no .ll)"; $failures += "$t (NO .ll)"; $fail++; continue }
    $linkArgs = "-O2 -o `"$exe`" `"$ll`" `"$runtimeSrc`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
    if (!(Test-Path $exe)) { Write-Host "FAIL link: $t"; $failures += "$t (LINK)"; $fail++; Remove-Item $ll -Force -ErrorAction SilentlyContinue; continue }
    $rr = Invoke-Timed -FilePath $exe -Arguments '' -TimeoutMs 10000 -WorkingDirectory $PSScriptRoot
    Remove-Item $exe,$ll -Force -ErrorAction SilentlyContinue
    if ($rr.TimedOut) { Write-Host "FAIL timeout: $t"; $failures += "$t (TIMEOUT)"; $fail++ }
    elseif ($rr.ExitCode -ne 0) { Write-Host "FAIL run: $t (exit=$($rr.ExitCode))"; $failures += "$t (RUN)"; $fail++ }
    else { Write-Host "PASS $t"; $pass++ }
}

Write-Host "`n=== SANITY: $pass PASS, $fail FAIL, $skip SKIP ==="
if ($failures.Count -gt 0) { Write-Host "Failures:"; foreach ($f in $failures) { Write-Host "  $f" } }
if ($fail -gt 0) { exit 1 }
