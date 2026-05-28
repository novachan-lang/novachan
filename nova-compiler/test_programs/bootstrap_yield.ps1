Set-Location $PSScriptRoot
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

Write-Host "=== Bootstrap: gen1 -> gen2 -> gen3 -> gen4 ==="

# gen1 (production) compiles nova_compiler.nova -> gen2
Write-Host "gen1 -> gen2..."
if (Test-Path "nova_compiler.ll") { Remove-Item "nova_compiler.ll" -Force }
$p = Start-Process -FilePath ".\gen1_final_ipt.exe" -ArgumentList "nova_compiler.nova" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "bs_g2_err.txt" -PassThru -NoNewWindow
$p.WaitForExit(60000) | Out-Null
if (!(Test-Path "nova_compiler.ll")) { Write-Host "FAIL: gen2 compile"; Get-Content "bs_g2_err.txt"; exit 1 }
Move-Item "nova_compiler.ll" "gen2_boot.ll" -Force
$p2 = Start-Process -FilePath "clang" -ArgumentList "-O2 -o gen2_boot.exe gen2_boot.ll nova_runtime.c -lws2_32" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "bs_g2_link.txt" -PassThru -NoNewWindow
$p2.WaitForExit(120000) | Out-Null
if (!(Test-Path "gen2_boot.exe")) { Write-Host "FAIL: gen2 link"; Get-Content "bs_g2_link.txt"; exit 1 }
Write-Host "gen2_boot.exe: $((Get-Item 'gen2_boot.exe').Length) bytes"

# gen2 compiles nova_compiler.nova -> gen3
Write-Host "gen2 -> gen3..."
if (Test-Path "nova_compiler.ll") { Remove-Item "nova_compiler.ll" -Force }
$p3 = Start-Process -FilePath ".\gen2_boot.exe" -ArgumentList "nova_compiler.nova" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "bs_g3_err.txt" -PassThru -NoNewWindow
$p3.WaitForExit(60000) | Out-Null
if (!(Test-Path "nova_compiler.ll")) { Write-Host "FAIL: gen3 compile"; Get-Content "bs_g3_err.txt"; exit 1 }
Move-Item "nova_compiler.ll" "gen3_boot.ll" -Force
$p4 = Start-Process -FilePath "clang" -ArgumentList "-O2 -o gen3_boot.exe gen3_boot.ll nova_runtime.c -lws2_32" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "bs_g3_link.txt" -PassThru -NoNewWindow
$p4.WaitForExit(120000) | Out-Null
if (!(Test-Path "gen3_boot.exe")) { Write-Host "FAIL: gen3 link"; Get-Content "bs_g3_link.txt"; exit 1 }
Write-Host "gen3_boot.exe: $((Get-Item 'gen3_boot.exe').Length) bytes"

# gen3 compiles nova_compiler.nova -> gen4
Write-Host "gen3 -> gen4..."
if (Test-Path "nova_compiler.ll") { Remove-Item "nova_compiler.ll" -Force }
$p5 = Start-Process -FilePath ".\gen3_boot.exe" -ArgumentList "nova_compiler.nova" -WorkingDirectory $PSScriptRoot -RedirectStandardOutput "nul" -RedirectStandardError "bs_g4_err.txt" -PassThru -NoNewWindow
$p5.WaitForExit(60000) | Out-Null
if (!(Test-Path "nova_compiler.ll")) { Write-Host "FAIL: gen4 compile"; Get-Content "bs_g4_err.txt"; exit 1 }
Move-Item "nova_compiler.ll" "gen4_boot.ll" -Force

# Compare gen3 and gen4 IR
Write-Host ""
Write-Host "=== Comparing gen3_boot.ll vs gen4_boot.ll ==="
$g3_hash = (Get-FileHash "gen3_boot.ll" -Algorithm SHA256).Hash
$g4_hash = (Get-FileHash "gen4_boot.ll" -Algorithm SHA256).Hash
Write-Host "gen3: $g3_hash"
Write-Host "gen4: $g4_hash"
if ($g3_hash -eq $g4_hash) {
    Write-Host "CONVERGED: gen3 == gen4"
} else {
    Write-Host "DIVERGED: gen3 != gen4"
    $g3_lines = (Get-Content "gen3_boot.ll").Count
    $g4_lines = (Get-Content "gen4_boot.ll").Count
    Write-Host "gen3: $g3_lines lines, gen4: $g4_lines lines"
}

Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
