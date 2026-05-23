Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$pass = 0; $fail = 0

$testSrc = @"
fn fibonacci(n: int) -> int
    if n <= 1
        return n
    fibonacci(n - 1) + fibonacci(n - 2)

fn main()
    let i = 0
    while i < 10
        print(str(fibonacci(i)))
        i = i + 1
"@
Set-Content "cross_test.nova" $testSrc -Encoding UTF8

# --- Test 1: Native (Windows) target ---
Write-Host "=== Test 1: Native (Windows) ==="
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "compile cross_test.nova -o cross_win.ll" -TimeoutMs 30000
Write-Host "Exit: $($cr.ExitCode)"
if ($cr.StdOut) { Write-Host "  $($cr.StdOut.Trim())" }
if ($cr.ExitCode -eq 0 -and (Test-Path "cross_win.ll")) {
    $ll = Get-Content "cross_win.ll" -Raw
    if ($ll -match 'target triple = "x86_64-pc-windows-msvc"') {
        Write-Host "  PASS: Windows triple"; $pass++
    } else { Write-Host "  FAIL: wrong triple"; $fail++ }
    if ($ll -match "e-m:w-") {
        Write-Host "  PASS: Windows datalayout (m:w)"; $pass++
    } else { Write-Host "  FAIL: wrong datalayout"; $fail++ }
    if ($ll -match "CodeView") {
        Write-Host "  PASS: CodeView debug"; $pass++
    } else { Write-Host "  FAIL: no CodeView"; $fail++ }
} else { Write-Host "  FAIL: compile error"; $fail += 3 }

# --- Test 2: Linux x64 target ---
Write-Host "`n=== Test 2: Linux x64 ==="
$cr2 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "compile --target linux cross_test.nova -o cross_linux.ll" -TimeoutMs 30000
Write-Host "Exit: $($cr2.ExitCode)"
if ($cr2.StdOut) { Write-Host "  $($cr2.StdOut.Trim())" }
if ($cr2.ExitCode -eq 0 -and (Test-Path "cross_linux.ll")) {
    $ll = Get-Content "cross_linux.ll" -Raw
    if ($ll -match 'target triple = "x86_64-unknown-linux-gnu"') {
        Write-Host "  PASS: Linux triple"; $pass++
    } else { Write-Host "  FAIL: wrong triple"; $fail++ }
    if ($ll -match "e-m:e-") {
        Write-Host "  PASS: ELF datalayout (m:e)"; $pass++
    } else { Write-Host "  FAIL: wrong datalayout"; $fail++ }
    if ($ll -match "Dwarf Version") {
        Write-Host "  PASS: DWARF debug"; $pass++
    } else { Write-Host "  FAIL: no DWARF"; $fail++ }
    if ($ll -notmatch "CodeView") {
        Write-Host "  PASS: no CodeView on Linux"; $pass++
    } else { Write-Host "  FAIL: CodeView on Linux"; $fail++ }
} else { Write-Host "  FAIL: compile error"; $fail += 4 }

# --- Test 3: macOS x64 target ---
Write-Host "`n=== Test 3: macOS x64 ==="
$cr3 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "compile --target macos cross_test.nova -o cross_macos.ll" -TimeoutMs 30000
Write-Host "Exit: $($cr3.ExitCode)"
if ($cr3.StdOut) { Write-Host "  $($cr3.StdOut.Trim())" }
if ($cr3.ExitCode -eq 0 -and (Test-Path "cross_macos.ll")) {
    $ll = Get-Content "cross_macos.ll" -Raw
    if ($ll -match 'target triple = "x86_64-apple-darwin"') {
        Write-Host "  PASS: macOS triple"; $pass++
    } else { Write-Host "  FAIL: wrong triple"; $fail++ }
    if ($ll -match "e-m:o-") {
        Write-Host "  PASS: Mach-O datalayout (m:o)"; $pass++
    } else { Write-Host "  FAIL: wrong datalayout"; $fail++ }
    if ($ll -match "Dwarf Version") {
        Write-Host "  PASS: DWARF debug"; $pass++
    } else { Write-Host "  FAIL: no DWARF"; $fail++ }
} else { Write-Host "  FAIL: compile error"; $fail += 3 }

# --- Test 4: Linux ARM64 target ---
Write-Host "`n=== Test 4: Linux ARM64 ==="
$cr4 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "compile --target linux-arm64 cross_test.nova -o cross_arm64.ll" -TimeoutMs 30000
Write-Host "Exit: $($cr4.ExitCode)"
if ($cr4.StdOut) { Write-Host "  $($cr4.StdOut.Trim())" }
if ($cr4.ExitCode -eq 0 -and (Test-Path "cross_arm64.ll")) {
    $ll = Get-Content "cross_arm64.ll" -Raw
    if ($ll -match 'target triple = "aarch64-unknown-linux-gnu"') {
        Write-Host "  PASS: ARM64 triple"; $pass++
    } else { Write-Host "  FAIL: wrong triple"; $fail++ }
    if ($ll -match "e-m:e-") {
        Write-Host "  PASS: ELF datalayout"; $pass++
    } else { Write-Host "  FAIL: wrong datalayout"; $fail++ }
} else { Write-Host "  FAIL: compile error"; $fail += 2 }

# --- Test 5: macOS ARM64 target ---
Write-Host "`n=== Test 5: macOS ARM64 ==="
$cr5 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "compile --target macos-arm64 cross_test.nova -o cross_macos_arm.ll" -TimeoutMs 30000
Write-Host "Exit: $($cr5.ExitCode)"
if ($cr5.StdOut) { Write-Host "  $($cr5.StdOut.Trim())" }
if ($cr5.ExitCode -eq 0 -and (Test-Path "cross_macos_arm.ll")) {
    $ll = Get-Content "cross_macos_arm.ll" -Raw
    if ($ll -match 'target triple = "aarch64-apple-darwin"') {
        Write-Host "  PASS: macOS ARM64 triple"; $pass++
    } else { Write-Host "  FAIL: wrong triple"; $fail++ }
    if ($ll -match "e-m:o-") {
        Write-Host "  PASS: Mach-O datalayout"; $pass++
    } else { Write-Host "  FAIL: wrong datalayout"; $fail++ }
} else { Write-Host "  FAIL: compile error"; $fail += 2 }

# --- Test 6: Explicit Windows target ---
Write-Host "`n=== Test 6: Explicit Windows ==="
$cr6 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "compile --target windows cross_test.nova -o cross_win2.ll" -TimeoutMs 30000
Write-Host "Exit: $($cr6.ExitCode)"
if ($cr6.StdOut) { Write-Host "  $($cr6.StdOut.Trim())" }
if ($cr6.ExitCode -eq 0 -and (Test-Path "cross_win2.ll")) {
    $ll = Get-Content "cross_win2.ll" -Raw
    if ($ll -match 'target triple = "x86_64-pc-windows-msvc"') {
        Write-Host "  PASS: Windows triple"; $pass++
    } else { Write-Host "  FAIL: wrong triple"; $fail++ }
} else { Write-Host "  FAIL: compile error"; $fail++ }

# --- Test 7: Custom raw triple ---
Write-Host "`n=== Test 7: Custom triple ==="
$cr7 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "compile --target riscv64-unknown-linux-gnu cross_test.nova -o cross_riscv.ll" -TimeoutMs 30000
Write-Host "Exit: $($cr7.ExitCode)"
if ($cr7.StdOut) { Write-Host "  $($cr7.StdOut.Trim())" }
if ($cr7.ExitCode -eq 0 -and (Test-Path "cross_riscv.ll")) {
    $ll = Get-Content "cross_riscv.ll" -Raw
    if ($ll -match 'target triple = "riscv64-unknown-linux-gnu"') {
        Write-Host "  PASS: custom triple passed through"; $pass++
    } else { Write-Host "  FAIL: wrong triple"; $fail++ }
} else { Write-Host "  FAIL: compile error"; $fail++ }

# --- Test 8: Native compile + link still works ---
Write-Host "`n=== Test 8: Native build + run ==="
$cr8 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "compile cross_test.nova -o cross_native.ll" -TimeoutMs 30000
if ($cr8.ExitCode -eq 0) {
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o cross_native.exe cross_native.ll nova_runtime.c -lws2_32" -TimeoutMs 30000
    if (Test-Path "cross_native.exe") {
        $rr = Invoke-Timed -FilePath (Resolve-Path ".\cross_native.exe").Path -Arguments "" -TimeoutMs 10000
        if ($rr.ExitCode -eq 0 -and $rr.StdOut.Trim() -match "^0") {
            Write-Host "  PASS: native build+run works"; $pass++
        } else {
            Write-Host "  FAIL: run error exit=$($rr.ExitCode)"; $fail++
        }
    } else { Write-Host "  FAIL: link error"; $fail++ }
} else { Write-Host "  FAIL: compile error"; $fail++ }

Write-Host "`n=== Results: $pass passed, $fail failed ==="
Remove-Item "cross_test.nova","cross_win.ll","cross_linux.ll","cross_macos.ll","cross_arm64.ll","cross_macos_arm.ll","cross_win2.ll","cross_riscv.ll","cross_native.ll","cross_native.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
