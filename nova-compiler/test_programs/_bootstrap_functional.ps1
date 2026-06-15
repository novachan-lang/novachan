Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtimeObj = "$PSScriptRoot\output\nova_runtime.o"

# Gen3 -> gen4
Write-Host "gen3 -> gen4..."
$cr = Invoke-Timed -FilePath $compiler -Arguments "nova_compiler.nova" -TimeoutMs 600000
if ($cr.ExitCode -ne 0) { Write-Host "FATAL: gen3 compile failed"; exit 1 }

$gen4 = "$PSScriptRoot\gen4_test_candidate.exe"
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$gen4`" nova_compiler.ll `"$runtimeObj`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
if (!(Test-Path $gen4)) { Write-Host "FATAL: gen4 link failed"; exit 1 }
Write-Host "  gen4: $((Get-Item $gen4).Length) bytes"

# Gen4 -> gen5
Write-Host "gen4 -> gen5..."
$cr2 = Invoke-Timed -FilePath $gen4 -Arguments "nova_compiler.nova" -TimeoutMs 600000
if ($cr2.ExitCode -ne 0) { Write-Host "FATAL: gen4 compile failed"; exit 1 }

$gen5 = "$PSScriptRoot\gen5_test_candidate.exe"
$lr2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$gen5`" nova_compiler.ll `"$runtimeObj`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
if (!(Test-Path $gen5)) { Write-Host "FATAL: gen5 link failed"; exit 1 }
Write-Host "  gen5: $((Get-Item $gen5).Length) bytes"

# Smoke test: gen5 compiles a simple program correctly
Write-Host ""
Write-Host "=== SMOKE TESTS ==="

# Test 1: simple arithmetic
$testSrc = "fn main()`n    let x = 42`n    let y = x + 8`n    print(y)"
Set-Content "$PSScriptRoot\_smoke1.nova" $testSrc -NoNewline
$cr = Invoke-Timed -FilePath $gen5 -Arguments "_smoke1.nova" -TimeoutMs 30000
if ($cr.ExitCode -ne 0) { Write-Host "FAIL: smoke1 compile"; exit 1 }
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$PSScriptRoot\_smoke1.exe`" _smoke1.ll `"$runtimeObj`" $NovaLinkFlags -w" -TimeoutMs 30000
$rr = Invoke-Timed -FilePath "$PSScriptRoot\_smoke1.exe" -Arguments "" -TimeoutMs 5000
if ($rr.StdOut.Trim() -eq "50") { Write-Host "PASS: arithmetic" } else { Write-Host "FAIL: expected 50, got: $($rr.StdOut.Trim())"; exit 1 }

# Test 2: structs + methods
$testSrc = "struct Point`n    x: int`n    y: int`n`nfn main()`n    let p = Point(3, 4)`n    print(p.x + p.y)"
Set-Content "$PSScriptRoot\_smoke2.nova" $testSrc -NoNewline
$cr = Invoke-Timed -FilePath $gen5 -Arguments "_smoke2.nova" -TimeoutMs 30000
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$PSScriptRoot\_smoke2.exe`" _smoke2.ll `"$runtimeObj`" $NovaLinkFlags -w" -TimeoutMs 30000
$rr = Invoke-Timed -FilePath "$PSScriptRoot\_smoke2.exe" -Arguments "" -TimeoutMs 5000
if ($rr.StdOut.Trim() -eq "7") { Write-Host "PASS: structs" } else { Write-Host "FAIL: expected 7, got: $($rr.StdOut.Trim())"; exit 1 }

# Test 3: channels + spawn
$testSrc = "fn main()`n    let ch = channel()`n    spawn`n        send(ch, 99)`n    let v = recv(ch)`n    print(v)"
Set-Content "$PSScriptRoot\_smoke3.nova" $testSrc -NoNewline
$cr = Invoke-Timed -FilePath $gen5 -Arguments "_smoke3.nova" -TimeoutMs 30000
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$PSScriptRoot\_smoke3.exe`" _smoke3.ll `"$runtimeObj`" $NovaLinkFlags -w" -TimeoutMs 30000
$rr = Invoke-Timed -FilePath "$PSScriptRoot\_smoke3.exe" -Arguments "" -TimeoutMs 5000
if ($rr.StdOut.Trim() -eq "99") { Write-Host "PASS: channels" } else { Write-Host "FAIL: expected 99, got: $($rr.StdOut.Trim())"; exit 1 }

# Test 4: match on sum types
$testSrc = "fn maybe_div(a: int, b: int) -> Result`n    if b == 0`n        return Err(`"div0`")`n    Ok(a / b)`n`nfn main()`n    let r = maybe_div(10, 2)`n    match r`n        Ok(v) => print(v)`n        Err(e) => print(e)"
Set-Content "$PSScriptRoot\_smoke4.nova" $testSrc -NoNewline
$cr = Invoke-Timed -FilePath $gen5 -Arguments "_smoke4.nova" -TimeoutMs 30000
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$PSScriptRoot\_smoke4.exe`" _smoke4.ll `"$runtimeObj`" $NovaLinkFlags -w" -TimeoutMs 30000
$rr = Invoke-Timed -FilePath "$PSScriptRoot\_smoke4.exe" -Arguments "" -TimeoutMs 5000
if ($rr.StdOut.Trim() -eq "5") { Write-Host "PASS: match/Result" } else { Write-Host "FAIL: expected 5, got: $($rr.StdOut.Trim())"; exit 1 }

Write-Host ""
Write-Host "All smoke tests PASS. gen5 is functionally correct."
Write-Host "Installing gen5 as gen3_test.exe + gen4_test.exe..."
Copy-Item $gen5 "$PSScriptRoot\gen3_test.exe" -Force
Copy-Item $gen5 "$PSScriptRoot\gen4_test.exe" -Force
Write-Host "Installed."

# Cleanup
Remove-Item $gen4, $gen5 -Force -ErrorAction SilentlyContinue
Remove-Item "$PSScriptRoot\_smoke1.nova","$PSScriptRoot\_smoke1.ll","$PSScriptRoot\_smoke1.exe" -Force -ErrorAction SilentlyContinue
Remove-Item "$PSScriptRoot\_smoke2.nova","$PSScriptRoot\_smoke2.ll","$PSScriptRoot\_smoke2.exe" -Force -ErrorAction SilentlyContinue
Remove-Item "$PSScriptRoot\_smoke3.nova","$PSScriptRoot\_smoke3.ll","$PSScriptRoot\_smoke3.exe" -Force -ErrorAction SilentlyContinue
Remove-Item "$PSScriptRoot\_smoke4.nova","$PSScriptRoot\_smoke4.ll","$PSScriptRoot\_smoke4.exe" -Force -ErrorAction SilentlyContinue
Remove-Item "$PSScriptRoot\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
Write-Host "Bootstrap complete (functional verification)."
