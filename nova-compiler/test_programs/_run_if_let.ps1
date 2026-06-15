. "$PSScriptRoot\_proc_util.ps1"
$base = $PSScriptRoot

# Step 1: Compile if_let_test.nova with gen4 (workerx.exe)
$r = Invoke-Timed -FilePath "$base\workerx.exe" -Arguments "`"$base\if_let_test.nova`"" -TimeoutMs 60000 -WorkingDirectory $base
Write-Host "=== COMPILE ==="
Write-Host "EXIT: $($r.ExitCode)"
Write-Host "TIMEOUT: $($r.TimedOut)"
Write-Host "STDOUT: $($r.StdOut)"
Write-Host "STDERR: $($r.StdErr)"

if ($r.TimedOut -or $r.ExitCode -ne 0) {
    Write-Host "COMPILE FAILED"
    exit 1
}

# Step 2: Link with clang (using runtime .c source like the standard build)
$r2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$base\if_let_test.exe`" `"$base\if_let_test.ll`" `"$base\output\nova_runtime.c`" -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 60000 -WorkingDirectory $base
Write-Host "=== LINK ==="
Write-Host "EXIT: $($r2.ExitCode)"
Write-Host "TIMEOUT: $($r2.TimedOut)"
Write-Host "STDERR: $($r2.StdErr)"

if ($r2.TimedOut -or $r2.ExitCode -ne 0) {
    Write-Host "LINK FAILED"
    exit 1
}

# Step 3: Run the test
$r3 = Invoke-Timed -FilePath "$base\if_let_test.exe" -Arguments "" -TimeoutMs 15000 -WorkingDirectory $base
Write-Host "=== RUN ==="
Write-Host "EXIT: $($r3.ExitCode)"
Write-Host "TIMEOUT: $($r3.TimedOut)"
Write-Host "STDOUT: $($r3.StdOut)"
Write-Host "STDERR: $($r3.StdErr)"
