Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

# Clean up any leftover from previous run
if (Test-Path "test_pkg_dir") { Remove-Item "test_pkg_dir" -Recurse -Force }

# Test: nova new
Write-Host "=== nova new test_pkg_dir ==="
$r1 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "new test_pkg_dir" -TimeoutMs 10000
Write-Host "exit=$($r1.ExitCode)"
Write-Host $r1.StdOut
if ($r1.StdErr) { Write-Host "STDERR: $($r1.StdErr)" }

# Verify files created
Write-Host ""
Write-Host "=== Files created ==="
Get-ChildItem -Recurse test_pkg_dir | ForEach-Object { Write-Host "  $($_.FullName.Substring($PSScriptRoot.Length))" }

# Test: nova run (from project dir)
Write-Host ""
Write-Host "=== nova run (project entry) ==="
Push-Location test_pkg_dir
try {
    Copy-Item "..\output\nova_runtime.c" "nova_runtime.c" -Force
    $r2 = Invoke-Timed -FilePath (Resolve-Path "..\gen2_move.exe").Path -Arguments "run" -TimeoutMs 30000 -WorkingDirectory (Get-Location).Path
    Write-Host "exit=$($r2.ExitCode)"
    Write-Host $r2.StdOut
    if ($r2.StdErr) { Write-Host "STDERR: $($r2.StdErr)" }
} finally {
    Pop-Location
}

# Test: nova test
Write-Host ""
Write-Host "=== nova test ==="
Push-Location test_pkg_dir
try {
    Copy-Item "..\output\nova_runtime.c" "nova_runtime.c" -Force
    $r3 = Invoke-Timed -FilePath (Resolve-Path "..\gen2_move.exe").Path -Arguments "test" -TimeoutMs 30000 -WorkingDirectory (Get-Location).Path
    Write-Host "exit=$($r3.ExitCode)"
    Write-Host $r3.StdOut
    if ($r3.StdErr) { Write-Host "STDERR: $($r3.StdErr)" }
} finally {
    Pop-Location
}

# Cleanup
Remove-Item "test_pkg_dir" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
