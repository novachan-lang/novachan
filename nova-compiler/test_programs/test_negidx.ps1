Set-Location $PSScriptRoot

# Copy runtime to avoid path-with-spaces issues
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

# Step 1: Build gen2 from updated source (has negative index fix)
Write-Host "Building gen2 with negative index fix..."
if (Test-Path "nova_compiler.ll") { Remove-Item "nova_compiler.ll" -Force }
$p = Start-Process -FilePath ".\gen1_final_ipt.exe" -ArgumentList "nova_compiler.nova" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "negidx_err1.txt" -PassThru -NoNewWindow
$p.WaitForExit(60000) | Out-Null
if (!(Test-Path "nova_compiler.ll")) { Write-Host "FAIL: compile source"; exit 1 }
Move-Item "nova_compiler.ll" "gen2_negidx.ll" -Force

$p2 = Start-Process -FilePath "clang" -ArgumentList "-O2 -o gen2_negidx.exe gen2_negidx.ll nova_runtime.c -lws2_32" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "negidx_cerr1.txt" -PassThru -NoNewWindow
$p2.WaitForExit(120000) | Out-Null
if (!(Test-Path "gen2_negidx.exe")) { Write-Host "FAIL: link gen2"; Get-Content "negidx_cerr1.txt"; exit 1 }
Write-Host "gen2_negidx.exe: $((Get-Item 'gen2_negidx.exe').Length) bytes"

# Step 2: Use gen2 to compile dict_iter_test
Write-Host "Compiling dict_iter_test with gen2..."
if (Test-Path "dict_iter_test.ll") { Remove-Item "dict_iter_test.ll" -Force }
$p3 = Start-Process -FilePath ".\gen2_negidx.exe" -ArgumentList "dict_iter_test.nova" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "negidx_err2.txt" -PassThru -NoNewWindow
$p3.WaitForExit(30000) | Out-Null
if (!(Test-Path "dict_iter_test.ll")) { Write-Host "FAIL: compile dict_iter_test"; Get-Content "negidx_err2.txt"; exit 1 }

# Step 3: Link
$p4 = Start-Process -FilePath "clang" -ArgumentList "-O2 -o dict_iter_test.exe dict_iter_test.ll nova_runtime.c -lws2_32" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "negidx_cerr2.txt" -PassThru -NoNewWindow
$p4.WaitForExit(30000) | Out-Null
if (!(Test-Path "dict_iter_test.exe")) { Write-Host "FAIL: link dict_iter_test"; Get-Content "negidx_cerr2.txt"; exit 1 }

# Step 4: Run with timeout
Write-Host "Running dict_iter_test..."
$psi = New-Object System.Diagnostics.ProcessStartInfo
$psi.FileName = (Resolve-Path ".\dict_iter_test.exe").Path
$psi.UseShellExecute = $false
$psi.RedirectStandardOutput = $true
$psi.RedirectStandardError = $true
$psi.CreateNoWindow = $true
$proc = [System.Diagnostics.Process]::Start($psi)
$stdout = $proc.StandardOutput.ReadToEnd()
$stderr = $proc.StandardError.ReadToEnd()
$done = $proc.WaitForExit(5000)
if (!$done) { $proc.Kill(); Write-Host "TIMEOUT"; exit 1 }
Write-Host "Exit code: $($proc.ExitCode)"
Write-Host "--- Output ---"
Write-Host $stdout
if ($stderr) { Write-Host "--- Stderr ---"; Write-Host $stderr }

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
