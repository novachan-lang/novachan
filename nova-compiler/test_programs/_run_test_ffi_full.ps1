Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$compiler = ".\gen2_move.exe"
$test = "ffi_full_test"
$cr = Invoke-Timed -FilePath (Resolve-Path $compiler).Path -Arguments "$test.nova" -TimeoutMs 30000
Write-Host "Compile exit: $($cr.ExitCode)"
if ($cr.StdOut) { Write-Host "Compile stdout: $($cr.StdOut)" }
if ($cr.StdErr) { Write-Host "Compile stderr: $($cr.StdErr)" }
if (!(Test-Path "$test.ll")) { exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $test.exe $test.ll nova_runtime.c ffi_helper.c -lws2_32" -TimeoutMs 60000
Write-Host "Link exit: $($lr.ExitCode)"
if ($lr.StdErr) {
    $errors = ($lr.StdErr -split "`n") | Where-Object { $_ -match "error:" }
    foreach ($e in $errors) { Write-Host $e.Trim() }
}
if (!(Test-Path "$test.exe")) { exit 1 }
$rr = Invoke-Timed -FilePath (Resolve-Path ".\$test.exe").Path -Arguments "" -TimeoutMs 10000
Write-Host "Run exit: $($rr.ExitCode)"
Write-Host "Output:"
Write-Host $rr.StdOut
if ($rr.StdErr) { Write-Host "Runtime stderr: $($rr.StdErr)" }
Remove-Item "$test.ll","$test.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
