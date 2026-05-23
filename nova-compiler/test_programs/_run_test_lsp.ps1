Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

# Compile lsp_server.nova -> lsp_server.exe
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "lsp_server.nova" -TimeoutMs 60000
Write-Host "Compile exit: $($cr.ExitCode)"
if ($cr.StdOut) { Write-Host "Compile stdout: $($cr.StdOut.Substring(0, [Math]::Min(2000, $cr.StdOut.Length)))" }
if ($cr.ExitCode -ne 0) { exit 1 }

$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o lsp_server.exe lsp_server.ll nova_runtime.c -lws2_32" -TimeoutMs 60000
Write-Host "Link exit: $($lr.ExitCode)"
if ($lr.ExitCode -ne 0) {
    if ($lr.StdErr) { Write-Host "STDERR: $($lr.StdErr.Substring(0, [Math]::Min(2000, $lr.StdErr.Length)))" }
    exit 1
}

# Run the LSP client test against the server
Write-Host ""
Write-Host "=== Running LSP client test ==="
node lsp_client_test.js

Remove-Item "lsp_server.ll","nova_runtime.c","lsp_check.nova","lsp_check.ll" -Force -ErrorAction SilentlyContinue
