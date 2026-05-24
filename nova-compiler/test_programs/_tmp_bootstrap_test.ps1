Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Step 1: Compile nova_compiler.nova with current gen2_move.exe
Write-Host "Step 1: Compiling nova_compiler.nova..."
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 90000
if ($cr.ExitCode -ne 0) {
    Write-Host "COMPILE FAIL (exit=$($cr.ExitCode))"
    if ($cr.StdOut) { $cr.StdOut -split "`n" | Select-Object -First 20 | ForEach-Object { Write-Host $_ } }
    exit 1
}
Write-Host "  Compile OK"

# Step 2: Copy runtime and link
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen2_new.exe nova_compiler.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 60000
if (!(Test-Path "gen2_new.exe")) {
    Write-Host "LINK FAIL"
    if ($lr.StdErr) { $lr.StdErr -split "`n" | Where-Object { $_ -match "error:" } | Select-Object -First 5 | ForEach-Object { Write-Host $_ } }
    exit 1
}
Write-Host "  Link OK: gen2_new.exe = $((Get-Item gen2_new.exe).Length) bytes"

# Step 3: gen2_new compiles itself -> gen3.ll
Write-Host "Step 2: gen2_new compiles nova_compiler.nova -> gen3.ll..."
$cr2 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_new.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 120000
if ($cr2.ExitCode -ne 0) {
    Write-Host "GEN3 COMPILE FAIL"
    if ($cr2.StdOut) { $cr2.StdOut -split "`n" | Select-Object -First 20 | ForEach-Object { Write-Host $_ } }
    exit 1
}
Move-Item "nova_compiler.ll" "gen3.ll" -Force
Write-Host "  gen3.ll OK"

# Step 4: Link gen3
$lr2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen3.exe gen3.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 60000
if (!(Test-Path "gen3.exe")) { Write-Host "GEN3 LINK FAIL"; exit 1 }
Write-Host "  gen3.exe OK"

# Step 5: gen3 compiles itself -> gen4.ll
Write-Host "Step 3: gen3 compiles nova_compiler.nova -> gen4.ll..."
$cr3 = Invoke-Timed -FilePath (Resolve-Path ".\gen3.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 120000
if ($cr3.ExitCode -ne 0) { Write-Host "GEN4 COMPILE FAIL"; exit 1 }
Move-Item "nova_compiler.ll" "gen4.ll" -Force
Write-Host "  gen4.ll OK"

# Step 6: Check convergence
$g3h = (Get-FileHash "gen3.ll" -Algorithm SHA256).Hash
$g4h = (Get-FileHash "gen4.ll" -Algorithm SHA256).Hash
if ($g3h -eq $g4h) {
    Write-Host "BOOTSTRAP CONVERGED"
    Copy-Item "gen3.exe" "gen2_move.exe" -Force
    Write-Host "  Promoted gen2_move.exe: $((Get-Item gen2_move.exe).Length) bytes"
} else {
    Write-Host "DIVERGED"
    $g3 = Get-Content "gen3.ll"; $g4 = Get-Content "gen4.ll"
    $d = 0
    for ($i = 0; $i -lt [Math]::Min($g3.Count, $g4.Count); $i++) {
        if ($g3[$i] -ne $g4[$i]) { $d++; if ($d -le 5) { Write-Host "  L$($i+1): G3=[$($g3[$i].Trim())] G4=[$($g4[$i].Trim())]" } }
    }
    Write-Host "  Total: $d diffs (G3=$($g3.Count) lines, G4=$($g4.Count) lines)"
    Remove-Item "gen2_new.exe","gen3.exe","gen3.ll","gen4.ll","nova_runtime.c" -Force -ErrorAction SilentlyContinue
    exit 1
}

# Cleanup
Remove-Item "gen2_new.exe","gen3.exe","gen3.ll","gen4.ll" -Force -ErrorAction SilentlyContinue

# Step 7: Quick regression test with promoted compiler
Write-Host "`nRunning regression tests..."
$compiler = (Resolve-Path ".\gen2_move.exe").Path
$tests = @("assert_test","closure_test","combined_test","dict_test","for_test","list_test","math_test","string_test","struct_test","while_test","float_test","range_test","regex_test","set_test","bytes_test","stdlib_collections_test")
$pass = 0; $fail = 0; $failures = @()
foreach ($t in $tests) {
    if (!(Test-Path "$t.nova")) { continue }
    $tc = Invoke-Timed -FilePath $compiler -Arguments "$t.nova" -TimeoutMs 30000
    if ($tc.ExitCode -ne 0) { $failures += "$t (COMPILE)"; $fail++; continue }
    $tl = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o $t.exe $t.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
    if (!(Test-Path "$t.exe")) { $failures += "$t (LINK)"; $fail++; continue }
    $tr = Invoke-Timed -FilePath (Resolve-Path ".\$t.exe").Path -Arguments "" -TimeoutMs 15000
    if ($tr.ExitCode -ne 0) { $failures += "$t (exit=$($tr.ExitCode))"; $fail++ }
    else { $pass++ }
    Remove-Item "$t.exe","$t.ll" -Force -ErrorAction SilentlyContinue
}
Write-Host "Regression: $pass PASS, $fail FAIL"
if ($failures.Count -gt 0) { Write-Host "Failures:"; foreach ($f in $failures) { Write-Host "  $f" } }
Remove-Item "nova_runtime.c" -Force -ErrorAction SilentlyContinue
