Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

# Compile repl.nova -> repl.exe
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "repl.nova" -TimeoutMs 60000
Write-Host "Compile exit: $($cr.ExitCode)"
if ($cr.StdOut) { Write-Host "stdout: $($cr.StdOut)" }
if ($cr.ExitCode -ne 0) {
    if ($cr.StdErr) { Write-Host "stderr: $($cr.StdErr)" }
    exit 1
}
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o repl.exe repl.ll nova_runtime.c -lws2_32" -TimeoutMs 60000
Write-Host "Link exit: $($lr.ExitCode)"
if (!(Test-Path "repl.exe")) { exit 1 }

# Feed a script of REPL inputs via stdin
$inputs = @(
    "1 + 2",
    "let name = `"NOVA`"",
    '"hello, {name}!"',
    "fn double(x: int) -> int",
    "    return x * 2",
    "",
    "double(21)",
    "fn fib(n: int) -> int",
    "    if n < 2",
    "        return n",
    "    return fib(n - 1) + fib(n - 2)",
    "",
    "fib(10)",
    "let nums = [1, 2, 3]",
    "map(nums, fn(x) double(x))",
    ":session",
    ":quit"
)

# Write script to a temp file, then pipe to repl.exe
$scriptFile = "_repl_input.txt"
$inputs -join "`n" | Set-Content -Path $scriptFile -NoNewline

Write-Host ""
Write-Host "=== REPL session ==="
Get-Content $scriptFile | & ".\repl.exe"
Write-Host "=== End session ==="

Remove-Item "repl.ll","repl.exe","nova_runtime.c",$scriptFile,"repl_session.nova","repl_session.ll","repl_session.exe" -Force -ErrorAction SilentlyContinue
