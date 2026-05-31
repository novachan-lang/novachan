Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== INCREMENTAL BUILD TEST ==="

# Compile + link nova_build.exe
Write-Host "[1/6] Building nova_build.exe..."
Remove-Item nova_build.ll -Force -ErrorAction SilentlyContinue
$cr = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments 'nova_build.nova' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "FAIL compile nova_build"; Write-Host $cr.StdOut; exit 1 }
$linkArgs = "-O2 -o `"nova_build.exe`" `"nova_build.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path nova_build.exe)) { Write-Host "FAIL link nova_build"; exit 1 }
Write-Host "  OK"

# Set up a project
$proj = Join-Path $PSScriptRoot "test_incr"
if (Test-Path $proj) { Remove-Item $proj -Recurse -Force }
New-Item -ItemType Directory -Path $proj -Force | Out-Null
Invoke-Timed -FilePath "$PSScriptRoot\nova_build.exe" -Arguments 'init incrproj' -TimeoutMs 10000 -WorkingDirectory $proj | Out-Null
Copy-Item ".\gen3_test.exe" "$proj\" -Force
Copy-Item ".\output" "$proj\output" -Recurse -Force

# First build — must compile
Write-Host "[2/6] First build (expect compile)..."
$b1 = Invoke-Timed -FilePath '.\nova_build.exe' -Arguments 'build test_incr' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
if ($b1.ExitCode -ne 0 -or !($b1.StdOut -match "Built:")) { Write-Host "FAIL first build: $($b1.StdOut)"; exit 1 }
Write-Host "  OK ($($b1.StdOut.Trim()))"

# Second build, no change — must be Up to date
Write-Host "[3/6] Rebuild unchanged (expect 'Up to date')..."
$b2 = Invoke-Timed -FilePath '.\nova_build.exe' -Arguments 'build test_incr' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
if (!($b2.StdOut -match "Up to date")) { Write-Host "FAIL: expected 'Up to date', got: $($b2.StdOut)"; exit 1 }
Write-Host "  OK"

# Change source — must rebuild
Write-Host "[4/6] Change source (expect rebuild)..."
Set-Content "$proj\src\main.nova" "fn main()`n    print(`"changed output v2`")`n"
$b3 = Invoke-Timed -FilePath '.\nova_build.exe' -Arguments 'build test_incr' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
if (!($b3.StdOut -match "Built:")) { Write-Host "FAIL: expected rebuild after change, got: $($b3.StdOut)"; exit 1 }
$rr = Invoke-Timed -FilePath ".\test_incr\build\incrproj.exe" -Arguments '' -TimeoutMs 5000 -WorkingDirectory $PSScriptRoot
if (!($rr.StdOut -match "changed output v2")) { Write-Host "FAIL: binary not updated: $($rr.StdOut)"; exit 1 }
Write-Host "  OK (binary reflects change)"

# Rebuild unchanged again — Up to date
Write-Host "[5/6] Rebuild unchanged again (expect 'Up to date')..."
$b4 = Invoke-Timed -FilePath '.\nova_build.exe' -Arguments 'build test_incr' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
if (!($b4.StdOut -match "Up to date")) { Write-Host "FAIL: expected 'Up to date', got: $($b4.StdOut)"; exit 1 }
Write-Host "  OK"

# --force bypasses cache
Write-Host "[6/6] Force rebuild (expect compile despite no change)..."
$b5 = Invoke-Timed -FilePath '.\nova_build.exe' -Arguments 'build test_incr --force' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
if (!($b5.StdOut -match "Built:")) { Write-Host "FAIL: --force did not rebuild: $($b5.StdOut)"; exit 1 }
Write-Host "  OK"

# Cleanup
Remove-Item $proj -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item nova_build.ll, nova_build.exe -Force -ErrorAction SilentlyContinue

Write-Host "`n=== INCREMENTAL BUILD: ALL PASS ==="
