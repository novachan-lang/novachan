Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== PACKAGE MANAGER TEST ==="

# Step 1: Compile nova_pkg.nova
Write-Host "[1/6] Compiling nova_pkg.nova..."
Remove-Item nova_pkg.ll -Force -ErrorAction SilentlyContinue
$cr = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments 'nova_pkg.nova' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "FAIL: compile nova_pkg"; Write-Host $cr.StdOut; exit 1 }

# Step 2: Link nova_pkg.exe
Write-Host "[2/6] Linking nova_pkg.exe..."
$linkArgs = "-O2 -o `"nova_pkg.exe`" `"nova_pkg.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path ".\nova_pkg.exe")) { Write-Host "FAIL: link nova_pkg"; exit 1 }
Write-Host "  OK"

# Step 3: Test version command
Write-Host "[3/6] Testing version..."
$vr = Invoke-Timed -FilePath "$PSScriptRoot\nova_pkg.exe" -Arguments 'version' -TimeoutMs 5000 -WorkingDirectory $PSScriptRoot
if (!($vr.StdOut -match "nova-pkg 0.1.0")) { Write-Host "FAIL: version output wrong: $($vr.StdOut)"; exit 1 }
Write-Host "  OK"

# Step 4: Test publish
Write-Host "[4/6] Testing publish..."
if (Test-Path "test_pkg_project") { Remove-Item "test_pkg_project" -Recurse -Force }
New-Item -ItemType Directory -Path "test_pkg_project/src" -Force | Out-Null
Set-Content "test_pkg_project/nova.toml" @"
[package]
name = "mathlib"
version = "1.2.0"

[dependencies]
"@
Set-Content "test_pkg_project/src/lib.nova" @"
fn add(a: int, b: int) -> int
    a + b

fn mul(a: int, b: int) -> int
    a * b
"@
$pr = Invoke-Timed -FilePath "$PSScriptRoot\nova_pkg.exe" -Arguments 'publish test_pkg_project' -TimeoutMs 10000 -WorkingDirectory $PSScriptRoot
if ($pr.ExitCode -ne 0) { Write-Host "FAIL: publish"; Write-Host $pr.StdOut; exit 1 }
if (!($pr.StdOut -match "Published mathlib v1.2.0")) { Write-Host "FAIL: publish output: $($pr.StdOut)"; exit 1 }
Write-Host "  OK"

# Step 5: Test search + info
Write-Host "[5/6] Testing search and info..."
$sr = Invoke-Timed -FilePath "$PSScriptRoot\nova_pkg.exe" -Arguments 'search math' -TimeoutMs 5000 -WorkingDirectory $PSScriptRoot
if (!($sr.StdOut -match "mathlib")) { Write-Host "FAIL: search didn't find mathlib: $($sr.StdOut)"; exit 1 }
$ir = Invoke-Timed -FilePath "$PSScriptRoot\nova_pkg.exe" -Arguments 'info mathlib' -TimeoutMs 5000 -WorkingDirectory $PSScriptRoot
if (!($ir.StdOut -match "1.2.0")) { Write-Host "FAIL: info missing version: $($ir.StdOut)"; exit 1 }
Write-Host "  OK"

# Step 6: Test get (install into a consumer project)
Write-Host "[6/6] Testing get (install)..."
if (Test-Path "test_consumer") { Remove-Item "test_consumer" -Recurse -Force }
New-Item -ItemType Directory -Path "test_consumer" -Force | Out-Null
Set-Content "test_consumer/nova.toml" @"
[package]
name = "my_app"
version = "0.1.0"
"@
$gr = Invoke-Timed -FilePath "$PSScriptRoot\nova_pkg.exe" -Arguments 'get mathlib' -TimeoutMs 10000 -WorkingDirectory "$PSScriptRoot\test_consumer"
if ($gr.ExitCode -ne 0) { Write-Host "FAIL: get"; Write-Host $gr.StdOut; exit 1 }
if (!(Test-Path "test_consumer/deps/mathlib/lib.nova")) { Write-Host "FAIL: dep source not installed"; exit 1 }
# Verify nova.toml was updated
$toml = Get-Content "test_consumer/nova.toml" -Raw
if (!($toml -match "mathlib")) { Write-Host "FAIL: nova.toml not updated"; exit 1 }
Write-Host "  OK"

# Cleanup
Remove-Item "test_pkg_project" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "test_consumer" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item nova_pkg.ll, nova_pkg.exe -Force -ErrorAction SilentlyContinue

Write-Host "`n=== PACKAGE MANAGER: ALL PASS ==="
