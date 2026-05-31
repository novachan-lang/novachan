Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "=== BUILD TOOL TEST ==="

# Step 1: Compile nova_build.nova
Write-Host "[1/5] Compiling nova_build.nova..."
Remove-Item nova_build.ll -Force -ErrorAction SilentlyContinue
$cr = Invoke-Timed -FilePath '.\gen3_test.exe' -Arguments 'nova_build.nova' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
if ($cr.ExitCode -ne 0) { Write-Host "FAIL: compile nova_build"; Write-Host $cr.StdOut; exit 1 }

# Step 2: Link nova_build.exe
Write-Host "[2/5] Linking nova_build.exe..."
$linkArgs = "-O2 -o `"nova_build.exe`" `"nova_build.ll`" `"output\nova_runtime.c`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot | Out-Null
if (!(Test-Path ".\nova_build.exe")) { Write-Host "FAIL: link nova_build"; exit 1 }
Write-Host "  OK"

# Step 3: Test init
Write-Host "[3/5] Testing init..."
if (Test-Path "test_project") { Remove-Item "test_project" -Recurse -Force }
New-Item -ItemType Directory -Path "test_project" -Force | Out-Null
$r = Invoke-Timed -FilePath "$PSScriptRoot\nova_build.exe" -Arguments 'init hello_test' -TimeoutMs 10000 -WorkingDirectory "$PSScriptRoot\test_project"
if (!(Test-Path "test_project\nova.toml")) { Write-Host "FAIL: init didn't create nova.toml"; exit 1 }
if (!(Test-Path "test_project\src\main.nova")) { Write-Host "FAIL: init didn't create src/main.nova"; exit 1 }
Write-Host "  OK"

# Step 4: Test build
Write-Host "[4/5] Testing build..."
Copy-Item ".\gen3_test.exe" "test_project\" -Force
Copy-Item ".\output" "test_project\output" -Recurse -Force
$br = Invoke-Timed -FilePath '.\nova_build.exe' -Arguments 'build test_project' -TimeoutMs 30000 -WorkingDirectory $PSScriptRoot
if ($br.ExitCode -ne 0) { Write-Host "FAIL: build"; Write-Host $br.StdOut; exit 1 }
if (!(Test-Path "test_project\build\hello_test.exe")) { Write-Host "FAIL: no output binary"; exit 1 }
Write-Host "  OK"

# Step 5: Test run
Write-Host "[5/5] Testing built binary..."
$rr = Invoke-Timed -FilePath '.\test_project\build\hello_test.exe' -Arguments '' -TimeoutMs 5000 -WorkingDirectory $PSScriptRoot
if ($rr.ExitCode -ne 0) { Write-Host "FAIL: run"; exit 1 }
if (!($rr.StdOut -match "Hello from hello_test")) { Write-Host "FAIL: wrong output: $($rr.StdOut)"; exit 1 }
Write-Host "  OK - Output: $($rr.StdOut.Trim())"

# Cleanup
Remove-Item "test_project" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item nova_build.ll, nova_build.exe -Force -ErrorAction SilentlyContinue

Write-Host "`n=== BUILD TOOL: ALL PASS ==="
