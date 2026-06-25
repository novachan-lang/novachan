# Race-proof gen4 build (the canonical "build the new compiler to test it" path).
#
# Hardening (2026-06-25): this build cannot be corrupted by an orphaned/concurrent build:
#   1. Stop-StrayCompilers kills any leftover build process before we start.
#   2. We compile to a UNIQUE per-process output (nova_compiler.<pid>.ll) via `compile -o`,
#      then atomically Move it onto nova_compiler.ll. So even if a stray slips through, the
#      published nova_compiler.ll is always a COMPLETE file — never a 0-byte/partial race.
#   3. Invoke-Timed guarantees the compiler is dead (not just abandoned) on timeout.
#   4. We link the runtime .c (not the possibly-stale prebuilt .o) so gen4.exe always
#      reflects the current output/nova_runtime.c.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Stop-StrayCompilers

$tmp = "nova_compiler.$PID.ll"
Remove-Item $tmp -Force -ErrorAction SilentlyContinue

Write-Host "Compiling nova_compiler.nova -> $tmp (gen3_test.exe)..."
$r = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments "compile -o $tmp nova_compiler.nova" -TimeoutMs 600000 -WorkingDirectory $PSScriptRoot
if ($r.TimedOut) { Write-Host "COMPILE TIMEOUT (process killed)"; Remove-Item $tmp -Force -ErrorAction SilentlyContinue; exit 1 }
if ($r.ExitCode -ne 0) {
    Write-Host "COMPILE FAIL exit=$($r.ExitCode)"
    if ($r.StdOut) { Write-Host ($r.StdOut.Substring(0, [Math]::Min(2000, $r.StdOut.Length))) }
    Remove-Item $tmp -Force -ErrorAction SilentlyContinue
    exit 1
}
if (!(Test-Path $tmp) -or (Get-Item $tmp).Length -lt 1000000) {
    Write-Host "BAD OUTPUT: $tmp missing or implausibly small"
    Remove-Item $tmp -Force -ErrorAction SilentlyContinue
    exit 1
}
# Atomic publish: a complete file replaces nova_compiler.ll in one move.
Move-Item -Force $tmp nova_compiler.ll
Write-Host "nova_compiler.ll built ($((Get-Item nova_compiler.ll).Length) bytes)"

Write-Host "Linking gen4.exe (against the current output/nova_runtime.c)..."
$link = "-O2 -o gen4.exe nova_compiler.ll output\nova_runtime.c -lws2_32 -ladvapi32 -lkernel32 -D_CRT_SECURE_NO_WARNINGS -w"
$cr = Invoke-Timed -FilePath $ClangPath -Arguments $link -TimeoutMs 300000 -WorkingDirectory $PSScriptRoot
if ($cr.TimedOut) { Write-Host "LINK TIMEOUT (process killed)"; exit 1 }
if ($cr.ExitCode -ne 0) {
    Write-Host "LINK FAIL exit=$($cr.ExitCode)"
    if ($cr.StdOut) { Write-Host $cr.StdOut }
    if ($cr.StdErr) { Write-Host $cr.StdErr }
    exit 1
}
Write-Host "gen4.exe built ($((Get-Item gen4.exe).Length) bytes) OK"
exit 0
