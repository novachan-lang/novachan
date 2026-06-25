. "$PSScriptRoot\_proc_util.ps1"
$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$name = $args[0]
# runtime obj
$rt = "$PSScriptRoot\nova_runtime_test.o"
if (-not (Test-Path $rt)) {
    Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 `"$PSScriptRoot\output\nova_runtime.c`" -o `"$rt`" -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot | Out-Null
}
# compile
$c = Invoke-Timed -FilePath $compiler -Arguments "$name.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
Write-Host "COMPILE exit=$($c.ExitCode) llExists=$(Test-Path "$PSScriptRoot\$name.ll")"
if ($c.ExitCode -ne 0) { Write-Host "--- compile stderr ---"; Write-Host $c.StdErr; exit 1 }
if (-not (Test-Path "$PSScriptRoot\$name.ll")) { exit 1 }
# link -O2 (same as regression) WITH stderr captured
$exe = "$PSScriptRoot\${name}_repro.exe"
$la = "-O2 -o `"$exe`" `"$PSScriptRoot\$name.ll`" `"$rt`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
$l = Invoke-Timed -FilePath $ClangPath -Arguments $la -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
Write-Host "LINK exit=$($l.ExitCode) timedOut=$($l.TimedOut) exeExists=$(Test-Path $exe)"
Write-Host "--- link stderr ---"; Write-Host $l.StdErr
Write-Host "--- link stdout ---"; Write-Host $l.StdOut
