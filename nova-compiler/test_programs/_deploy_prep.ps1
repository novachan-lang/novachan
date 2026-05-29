# Regenerate the Linux LLVM IR for ai_serve. Run before `docker build` / `railway up`
# (the NOVA compiler is Windows-hosted, so the Linux IR is produced on the host).
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$r = Invoke-Timed -FilePath (Resolve-Path ".\gen3_test.exe").Path -Arguments "compile --target linux -o ai_serve_linux.ll ai_serve.nova" -TimeoutMs 90000
if ($r.ExitCode -ne 0) { Write-Host "cross-compile failed"; Write-Host $r.StdErr; exit 1 }
Write-Host "ai_serve_linux.ll regenerated for x86_64-unknown-linux-gnu."
