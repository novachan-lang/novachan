Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtimeSrc = "$PSScriptRoot\output\nova_runtime.c"
$runtimeObj = "$PSScriptRoot\output\nova_runtime.o"

# Pre-compile runtime if needed
if (!(Test-Path $runtimeObj) -or (Get-Item $runtimeSrc).LastWriteTimeUtc -gt (Get-Item $runtimeObj).LastWriteTimeUtc) {
    Write-Host "Compiling runtime .o..."
    $cr = Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 -o `"$runtimeObj`" `"$runtimeSrc`" -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
    if (!(Test-Path $runtimeObj)) { Write-Host "FATAL: runtime compile failed"; exit 1 }
}

function Compile-Gen($inputExe, $outputExe, $label) {
    Write-Host "$label..."
    $cr = Invoke-Timed -FilePath $inputExe -Arguments "nova_compiler.nova" -TimeoutMs 600000
    Write-Host "  compile exit=$($cr.ExitCode)"
    if ($cr.ExitCode -ne 0) {
        Write-Host "FATAL: $label compilation failed"
        if ($cr.StdOut) {
            $txt = $cr.StdOut
            if ($txt.Length -gt 2000) { $txt = $txt.Substring(0, 2000) }
            Write-Host $txt
        }
        exit 1
    }
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$outputExe`" nova_compiler.ll `"$runtimeObj`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
    if (!(Test-Path $outputExe)) { Write-Host "FATAL: $label link failed"; exit 1 }
    Write-Host "  ready: $((Get-Item $outputExe).Length) bytes"
}

$gen4 = "$PSScriptRoot\gen4_bootstrap.exe"
$gen5 = "$PSScriptRoot\gen5_bootstrap.exe"

Compile-Gen $compiler $gen4 "gen3 -> gen4"
Compile-Gen $gen4 $gen5 "gen4 -> gen5"

# Smoke tests with gen5
Write-Host ""
Write-Host "=== SMOKE TESTS ==="

function Smoke-Test($name, $src, $expected) {
    Set-Content "$PSScriptRoot\_st_$name.nova" $src -NoNewline -Encoding UTF8
    $cr = Invoke-Timed -FilePath $gen5 -Arguments "_st_$name.nova" -TimeoutMs 30000
    if ($cr.ExitCode -ne 0) {
        Write-Host "FAIL $name (compile): $($cr.StdOut)"
        return $false
    }
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o `"$PSScriptRoot\_st_$name.exe`" `"$PSScriptRoot\_st_$name.ll`" `"$runtimeObj`" $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 30000
    if (!(Test-Path "$PSScriptRoot\_st_$name.exe")) {
        Write-Host "FAIL $name (link)"
        return $false
    }
    $rr = Invoke-Timed -FilePath "$PSScriptRoot\_st_$name.exe" -Arguments "" -TimeoutMs 5000
    $actual = $rr.StdOut.Trim()
    if ($actual -eq $expected) {
        Write-Host "PASS $name"
        return $true
    } else {
        Write-Host "FAIL $name (expected '$expected', got '$actual')"
        return $false
    }
}

$allPass = $true

# Test 1: arithmetic
$r = Smoke-Test "arith" "fn main()`n    let x = 42`n    let y = x + 8`n    print(y)" "50"
if (!$r) { $allPass = $false }

# Test 2: structs
$r = Smoke-Test "struct" "type Pt`n    x: int`n    y: int`n`nfn main()`n    let p = Pt(3, 4)`n    print(p.x + p.y)" "7"
if (!$r) { $allPass = $false }

# Test 3: match
$r = Smoke-Test "match" "fn check(n: int) -> string`n    match n`n        1 => return `"one`"`n        2 => return `"two`"`n        _ => return `"other`"`n`nfn main()`n    print(check(2))" "two"
if (!$r) { $allPass = $false }

# Test 4: list + for
$r = Smoke-Test "list" "fn main()`n    let xs = [10, 20, 30]`n    let s = 0`n    for x in xs`n        s = s + x`n    print(s)" "60"
if (!$r) { $allPass = $false }

# Cleanup smoke test files
Get-ChildItem "$PSScriptRoot\_st_*" | Remove-Item -Force -ErrorAction SilentlyContinue

if ($allPass) {
    Write-Host ""
    Write-Host "All smoke tests PASS. Installing gen5..."
    Copy-Item $gen5 "$PSScriptRoot\gen3_test.exe" -Force
    Copy-Item $gen5 "$PSScriptRoot\gen4_test.exe" -Force
    Write-Host "Installed."
} else {
    Write-Host ""
    Write-Host "SMOKE TESTS FAILED - not installing"
    exit 1
}

# Cleanup
Remove-Item $gen4, $gen5 -Force -ErrorAction SilentlyContinue
Remove-Item "$PSScriptRoot\nova_compiler.ll" -Force -ErrorAction SilentlyContinue
Write-Host "Bootstrap complete."
