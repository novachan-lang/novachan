. "$PSScriptRoot\_proc_util.ps1"
$name = "forge_chunked_test"
$compiler = (Resolve-Path "$PSScriptRoot\nova.exe").Path
$rtObj = "$PSScriptRoot\nova_runtime.o"
# 1) compile .nova -> .ll
$c = Invoke-Timed -FilePath $compiler -Arguments "$name.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
if (-not (Test-Path "$PSScriptRoot\$name.ll")) { Write-Host "FAIL compile (exit=$($c.ExitCode))"; Write-Host $c.StdErr; exit 1 }
# 2) ensure runtime .o
if (-not (Test-Path $rtObj)) {
    $rtc = Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 `"$PSScriptRoot\output\nova_runtime.c`" -o `"$rtObj`" -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
}
# 3) link
$exe = "$PSScriptRoot\$name.exe"
$lk = Invoke-Timed -FilePath $ClangPath -Arguments "`"$PSScriptRoot\$name.ll`" `"$rtObj`" -o `"$exe`" $NovaLinkFlags -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if (-not (Test-Path $exe)) { Write-Host "FAIL link (exit=$($lk.ExitCode))"; Write-Host $lk.StdErr; exit 1 }
# 4) run with kill-on-timeout
$r = Invoke-Timed -FilePath $exe -TimeoutMs 20000 -WorkingDirectory $PSScriptRoot
Write-Host "=== STDOUT ==="; Write-Host $r.StdOut
if ($r.StdErr) { Write-Host "=== STDERR ==="; Write-Host $r.StdErr }
Write-Host "TimedOut=$($r.TimedOut) ExitCode=$($r.ExitCode)"
