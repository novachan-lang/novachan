Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$t = $args[0]
if (!$t) { Write-Host "Usage: _link_run.ps1 <test_name>"; exit 1 }

$ll = "$t.ll"
$exe = "$t.exe"

# Link
$rtO = "output\nova_runtime.o"
if (!(Test-Path $rtO)) {
    Write-Host "Compiling runtime..."
    $cr = Invoke-Timed -FilePath "clang" -Arguments "-c nova_runtime.c -O2 -o $rtO" -TimeoutMs 30000
    if ($cr.ExitCode -ne 0) { Write-Host "Runtime compile failed"; exit 1 }
}
$lr = Invoke-Timed -FilePath "clang" -Arguments "$ll $rtO -o $exe -lws2_32 -ladvapi32" -TimeoutMs 30000
if ($lr.ExitCode -ne 0) {
    Write-Host "LINK FAILED (exit=$($lr.ExitCode))"
    if ($lr.StdErr) { Write-Host $lr.StdErr }
    exit 1
}

# Run
$rr = Invoke-Timed -FilePath ".\$exe" -Arguments "" -TimeoutMs 10000
Write-Host "exit=$($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut }
if ($rr.StdErr) { Write-Host "STDERR: $($rr.StdErr)" }
