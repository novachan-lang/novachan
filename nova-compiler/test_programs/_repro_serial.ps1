. "$PSScriptRoot\_proc_util.ps1"
$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$rt = "$PSScriptRoot\nova_runtime_test.o"
if (-not (Test-Path $rt)) {
    Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 `"$PSScriptRoot\output\nova_runtime.c`" -o `"$rt`" -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot | Out-Null
}
$tests = @('forge_model_route_test','bytes_socket_test','forge_binary_serve_test','forge_multipart_test','forge_ws_echo_test','forge_sse_test','forge_chunked_test')
foreach ($name in $tests) {
    $c = Invoke-Timed -FilePath $compiler -Arguments "$name.nova" -TimeoutMs 60000 -WorkingDirectory $PSScriptRoot
    if ($c.ExitCode -ne 0 -or -not (Test-Path "$PSScriptRoot\$name.ll")) {
        Write-Host "$name : COMPILE FAIL exit=$($c.ExitCode)"; Write-Host ($c.StdErr | Select-Object -First 1); continue
    }
    $exe = "$PSScriptRoot\${name}_r.exe"
    $la = "-O2 -o `"$exe`" `"$PSScriptRoot\$name.ll`" `"$rt`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
    $l = Invoke-Timed -FilePath $ClangPath -Arguments $la -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
    if (-not (Test-Path $exe)) {
        Write-Host "$name : LINK FAIL exit=$($l.ExitCode) timedOut=$($l.TimedOut)"
        Write-Host "  STDERR: $($l.StdErr)"
    } else {
        Write-Host "$name : OK (link exit=$($l.ExitCode))"
        Remove-Item $exe -Force -ErrorAction SilentlyContinue
    }
    Remove-Item "$PSScriptRoot\$name.ll" -Force -ErrorAction SilentlyContinue
}
