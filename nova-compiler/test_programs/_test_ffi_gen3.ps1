Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path ".\gen3_test.exe").Path
$runtimeSrc = "$PSScriptRoot\output\nova_runtime.c"
$helperC = "$PSScriptRoot\ffi_helper.c"

$tests = @(
    'ffi_test'
    'ffi_full_test'
    'ffi_strlen_test'
    'ffi_repr_c_test'
    'ffi_opaque_test'
    'ffi_out_test'
    'ffi_dedupe_test'
    'ffi_libc_test'
    'unsafe_test'
)

$pass = 0; $fail = 0; $skip = 0; $failures = @()

Write-Host "=== FFI TESTS (gen3) ==="

foreach ($t in $tests) {
    $nova = "$PSScriptRoot\$t.nova"
    $ll   = "$PSScriptRoot\$t.ll"
    $exe  = "$PSScriptRoot\$t.exe"
    if (!(Test-Path $nova)) { Write-Host "SKIP $t"; $skip++; continue }
    Remove-Item $ll -Force -ErrorAction SilentlyContinue
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
    if ($cr.TimedOut -or $cr.ExitCode -ne 0) {
        Write-Host "FAIL compile: $t (exit=$($cr.ExitCode))"
        if ($cr.StdOut) { Write-Host $cr.StdOut.Substring(0, [Math]::Min(300, $cr.StdOut.Length)) }
        $failures += "$t (COMPILE)"; $fail++; continue
    }
    if (!(Test-Path $ll)) { Write-Host "FAIL $t (no .ll)"; $failures += "$t (NO .ll)"; $fail++; continue }
    # Link with ffi_helper.c if it exists
    $extraC = ""
    if (Test-Path $helperC) { $extraC = "`"$helperC`"" }
    $linkArgs = "-O2 -o `"$exe`" `"$ll`" `"$runtimeSrc`" $extraC $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
    Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot | Out-Null
    if (!(Test-Path $exe)) { Write-Host "FAIL link: $t"; $failures += "$t (LINK)"; $fail++; Remove-Item $ll -Force -ErrorAction SilentlyContinue; continue }
    $rr = Invoke-Timed -FilePath $exe -Arguments '' -TimeoutMs 10000 -WorkingDirectory $PSScriptRoot
    Remove-Item $exe,$ll -Force -ErrorAction SilentlyContinue
    if ($rr.TimedOut) { Write-Host "FAIL timeout: $t"; $failures += "$t (TIMEOUT)"; $fail++ }
    elseif ($rr.ExitCode -ne 0) {
        Write-Host "FAIL run: $t (exit=$($rr.ExitCode))"
        if ($rr.StdOut) { Write-Host $rr.StdOut.Substring(0, [Math]::Min(300, $rr.StdOut.Length)) }
        $failures += "$t (RUN)"; $fail++
    } else {
        Write-Host "PASS $t"; $pass++
    }
}

Write-Host "`n=== FFI: $pass PASS, $fail FAIL, $skip SKIP ==="
if ($failures.Count -gt 0) { Write-Host "Failures:"; foreach ($f in $failures) { Write-Host "  $f" } }
if ($fail -gt 0) { exit 1 }
