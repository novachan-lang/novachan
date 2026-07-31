# C-level soundness gate for the builtin region (nova_runtime.c lines 24000+).
# Exercises wrong-type handles, negative lengths, and size-arithmetic overflow
# directly against the runtime -- no compiler involved, so it runs even when the
# toolchain is mid-reconverge. 8 of these 10 probe classes segfaulted before the
# 2026-08-01 soundness sweep; all must pass now.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$exe = Join-Path $PSScriptRoot "_builtin_soundness.exe"
Remove-Item $exe -Force -ErrorAction SilentlyContinue
$build = Invoke-Timed -FilePath $ClangPath -Arguments `
  "-O1 -o `"$exe`" `"$PSScriptRoot\_builtin_soundness_harness.c`" `"$PSScriptRoot\..\compiler\nova_runtime.c`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" `
  -TimeoutMs 300000
if ($build.ExitCode -ne 0 -or !(Test-Path $exe)) {
    Write-Host "FAIL: soundness harness did not build (exit=$($build.ExitCode))"
    Write-Host $build.Output
    exit 1
}

$run = Invoke-Timed -FilePath $exe -Arguments "" -TimeoutMs 60000
Write-Host $run.Output
if ($run.ExitCode -ne 0) {
    Write-Host "FAIL: builtin soundness harness exit=$($run.ExitCode) (139 = segfault)"
    exit 1
}
Write-Host "PASS: builtin soundness harness"
exit 0
