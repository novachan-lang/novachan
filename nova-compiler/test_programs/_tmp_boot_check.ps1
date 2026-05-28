Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Remove-Item "gen2_new.exe","gen3.exe","gen3.ll","gen4.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue

# Step 1: gen2_move -> nova_compiler.ll
$cr0 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 60000
if ($cr0.ExitCode -ne 0) { Write-Host "STEP1 FAIL"; exit 1 }
Write-Host "Step 1: gen2_move compiled source OK"

# Step 2: Link gen2_new
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$lr1 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen2_new.exe nova_compiler.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 60000
if (!(Test-Path "gen2_new.exe")) { Write-Host "LINK FAIL"; exit 1 }
Write-Host "Step 2: gen2_new linked OK ($((Get-Item gen2_new.exe).Length) bytes)"

# Step 3: gen2_new -> gen3.ll
$cr1 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_new.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 120000
if ($cr1.ExitCode -ne 0) { Write-Host "GEN3 COMPILE FAIL"; exit 1 }
Move-Item "nova_compiler.ll" "gen3.ll" -Force
Write-Host "Step 3: gen2_new self-compiled to gen3.ll OK"

# Step 4: Link gen3
$lr2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen3.exe gen3.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 60000
if (!(Test-Path "gen3.exe")) { Write-Host "GEN3 LINK FAIL"; exit 1 }
Write-Host "Step 4: gen3 linked OK ($((Get-Item gen3.exe).Length) bytes)"

# Step 5: gen3 -> gen4.ll
$cr2 = Invoke-Timed -FilePath (Resolve-Path ".\gen3.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 120000
if ($cr2.ExitCode -ne 0) { Write-Host "GEN4 COMPILE FAIL"; exit 1 }
Move-Item "nova_compiler.ll" "gen4.ll" -Force
Write-Host "Step 5: gen3 self-compiled to gen4.ll OK"

# Compare
$g3h = (Get-FileHash "gen3.ll" -Algorithm SHA256).Hash
$g4h = (Get-FileHash "gen4.ll" -Algorithm SHA256).Hash
if ($g3h -eq $g4h) {
    Write-Host "BOOTSTRAP CONVERGED (gen3.ll == gen4.ll)"
    Copy-Item "gen3.exe" "gen2_move.exe" -Force
    Write-Host "gen2_move.exe promoted: $((Get-Item gen2_move.exe).Length) bytes"
} else {
    Write-Host "DIVERGED"
    $g3 = Get-Content "gen3.ll"; $g4 = Get-Content "gen4.ll"
    $d = 0
    for ($i = 0; $i -lt [Math]::Min($g3.Count, $g4.Count); $i++) {
        if ($g3[$i] -ne $g4[$i]) { $d++; if ($d -le 5) { Write-Host "  L$($i+1): G3=[$($g3[$i].Trim())] G4=[$($g4[$i].Trim())]" } }
    }
    Write-Host "  Total: $d diffs (len g3=$($g3.Count) g4=$($g4.Count))"
}
Remove-Item "gen2_new.exe","gen3.exe","gen3.ll","gen4.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue
