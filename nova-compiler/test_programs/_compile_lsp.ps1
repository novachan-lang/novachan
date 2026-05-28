Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$r = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "lsp_server.nova" -TimeoutMs 60000
Write-Host "Exit: $($r.ExitCode)"
Write-Host "TimedOut: $($r.TimedOut)"
if ($r.StdOut) { Write-Host "stdout: $($r.StdOut)" }
if ($r.StdErr) { Write-Host "stderr: $($r.StdErr)" }

if ($r.ExitCode -ne 0) {
    Write-Host "COMPILE FAILED"
    exit 1
}

if (!(Test-Path "lsp_server.ll")) {
    Write-Host "NO .ll FILE PRODUCED"
    exit 1
}

Write-Host "COMPILE OK - lsp_server.ll produced"

# Link
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o lsp_server.exe lsp_server.ll output\nova_runtime.c -lws2_32" -TimeoutMs 60000
Write-Host "Link exit: $($lr.ExitCode)"
if ($lr.StdErr) { Write-Host "Link stderr: $($lr.StdErr)" }
if (Test-Path "lsp_server.exe") {
    Write-Host "BUILD OK - lsp_server.exe produced"
} else {
    Write-Host "LINK FAILED"
    exit 1
}
