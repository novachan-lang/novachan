Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$pass = 0; $fail = 0

# --- Test 1: Basic debug metadata in IR ---
Write-Host "=== Test 1: Debug metadata in IR ==="
$src1 = @"
fn add(a: int, b: int) -> int
    a + b

fn main()
    print(str(add(1, 2)))
"@
Set-Content "t_dbg.nova" $src1 -Encoding UTF8
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "t_dbg.nova" -TimeoutMs 30000
if ($cr.ExitCode -ne 0) {
    Write-Host "  FAIL: compile error"; $fail++
} else {
    $ll = Get-Content "t_dbg.ll" -Raw
    if ($ll -match "!DICompileUnit") { Write-Host "  PASS: DICompileUnit"; $pass++ } else { Write-Host "  FAIL: no DICompileUnit"; $fail++ }
    if ($ll -match "!DIFile.*t_dbg.nova") { Write-Host "  PASS: DIFile"; $pass++ } else { Write-Host "  FAIL: no DIFile"; $fail++ }
    if ($ll -match "!DISubprogram.*add") { Write-Host "  PASS: DISubprogram add"; $pass++ } else { Write-Host "  FAIL: no DISubprogram add"; $fail++ }
    if ($ll -match "!DISubprogram.*nova_user_main") { Write-Host "  PASS: DISubprogram main"; $pass++ } else { Write-Host "  FAIL: no DISubprogram main"; $fail++ }
    if ($ll -match "!DILocation") { Write-Host "  PASS: DILocation"; $pass++ } else { Write-Host "  FAIL: no DILocation"; $fail++ }
    if ($ll -match "CodeView") { Write-Host "  PASS: CodeView flag"; $pass++ } else { Write-Host "  FAIL: no CodeView flag"; $fail++ }
    # Check instructions have !dbg
    $lines = $ll -split "`n"
    $inFn = $false; $instrCount = 0; $dbgCount = 0
    foreach ($line in $lines) {
        if ($line -match "^define i64 @(add|nova_user_main)") { $inFn = $true }
        elseif ($line -match "^\}") { $inFn = $false }
        elseif ($inFn -and $line -match "^\s+\S") {
            $instrCount++
            if ($line -match "!dbg") { $dbgCount++ }
        }
    }
    if ($instrCount -gt 0 -and $instrCount -eq $dbgCount) {
        Write-Host "  PASS: all $instrCount instructions have !dbg"; $pass++
    } else {
        Write-Host "  FAIL: $dbgCount/$instrCount instructions have !dbg"; $fail++
    }
}

# --- Test 2: PDB generation ---
Write-Host "`n=== Test 2: PDB with source lines ==="
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-g -O0 -o t_dbg.exe t_dbg.ll nova_runtime.c -lws2_32" -TimeoutMs 30000
if ($lr.ExitCode -ne 0) {
    Write-Host "  FAIL: link error"; $fail++
} else {
    if (Test-Path "t_dbg.pdb") {
        Write-Host "  PASS: PDB created"; $pass++
        $pdbutil = Get-Command "llvm-pdbutil" -ErrorAction SilentlyContinue
        if ($pdbutil) {
            $pd = Invoke-Timed -FilePath $pdbutil.Source -Arguments "dump -modules t_dbg.pdb" -TimeoutMs 10000
            if ($pd.StdOut -match "Mod 0000.*# files: (\d+)") {
                # parse differently
            }
            $modLines = $pd.StdOut -split "`n" | Where-Object { $_ -match "Mod 0000" }
            $filesLine = $pd.StdOut -split "`n" | Where-Object { $_ -match "debug stream: \d+, # files:" } | Select-Object -First 1
            if ($filesLine -match "# files: (\d+)") {
                $nFiles = [int]$Matches[1]
                if ($nFiles -gt 0) {
                    Write-Host "  PASS: Module 0 has $nFiles source file(s)"; $pass++
                } else {
                    Write-Host "  FAIL: Module 0 has 0 files"; $fail++
                }
            }
            # Check line info
            $pd2 = Invoke-Timed -FilePath $pdbutil.Source -Arguments "dump -l t_dbg.pdb" -TimeoutMs 10000
            if ($pd2.StdOut -match "t_dbg\.nova") {
                Write-Host "  PASS: line info references source file"; $pass++
            } else {
                Write-Host "  FAIL: no source file in line info"; $fail++
            }
        }
    } else {
        Write-Host "  FAIL: no PDB"; $fail++
    }
    # Verify it still runs correctly
    $rr = Invoke-Timed -FilePath (Resolve-Path ".\t_dbg.exe").Path -Arguments "" -TimeoutMs 10000
    if ($rr.StdOut.Trim() -eq "3") {
        Write-Host "  PASS: correct output"; $pass++
    } else {
        Write-Host "  FAIL: wrong output: $($rr.StdOut.Trim())"; $fail++
    }
}

# --- Test 3: Runtime functions excluded from debug ---
Write-Host "`n=== Test 3: Runtime fns have no debug ==="
$ll = Get-Content "t_dbg.ll" -Raw
$lines = $ll -split "`n"
$rtFns = $lines | Where-Object { $_ -match "^define i64 @nova_rt_" -and $_ -match "!dbg" }
if ($rtFns.Count -eq 0) {
    Write-Host "  PASS: runtime functions have no !dbg"; $pass++
} else {
    Write-Host "  FAIL: runtime functions have !dbg ($($rtFns.Count))"; $fail++
}

# Check nova_main (the C main wrapper) has no !dbg
$mainWrapper = $lines | Where-Object { $_ -match "^define.*@main\(" -and $_ -match "!dbg" }
if ($mainWrapper.Count -eq 0) {
    Write-Host "  PASS: C main wrapper has no !dbg"; $pass++
} else {
    Write-Host "  FAIL: C main wrapper has !dbg"; $fail++
}

# --- Test 4: Stress test on compiler source ---
Write-Host "`n=== Test 4: Stress - compile compiler with debug ==="
$cr2 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 120000
Write-Host "  Compile exit: $($cr2.ExitCode)"
if ($cr2.ExitCode -eq 0) {
    $ll2 = Get-Content "nova_compiler.ll" -Raw
    $spCount = ([regex]::Matches($ll2, "!DISubprogram")).Count
    $locCount = ([regex]::Matches($ll2, "!DILocation")).Count
    Write-Host "  DISubprogram: $spCount, DILocation: $locCount"
    if ($spCount -gt 100 -and $locCount -eq $spCount) {
        Write-Host "  PASS: $spCount functions with debug info"; $pass++
    } else {
        Write-Host "  FAIL: mismatch or too few"; $fail++
    }
} else {
    Write-Host "  FAIL: compile error"; $fail++
}

# --- Test 5: Correct line numbers ---
Write-Host "`n=== Test 5: Line numbers correct ==="
$src5 = @"
fn foo() -> int
    42

fn bar() -> int
    99

fn main()
    print(str(foo()))
    print(str(bar()))
"@
Set-Content "t_lines.nova" $src5 -Encoding UTF8
$cr5 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "t_lines.nova" -TimeoutMs 30000
if ($cr5.ExitCode -eq 0) {
    $ll5 = Get-Content "t_lines.ll" -Raw
    if ($ll5 -match 'DISubprogram\(name: "foo".*line: 1') {
        Write-Host "  PASS: foo at line 1"; $pass++
    } else { Write-Host "  FAIL: foo wrong line"; $fail++ }
    if ($ll5 -match 'DISubprogram\(name: "bar".*line: 4') {
        Write-Host "  PASS: bar at line 4"; $pass++
    } else { Write-Host "  FAIL: bar wrong line"; $fail++ }
    if ($ll5 -match 'DISubprogram\(name: "nova_user_main".*line: 7') {
        Write-Host "  PASS: main at line 7"; $pass++
    } else { Write-Host "  FAIL: main wrong line"; $fail++ }
} else {
    Write-Host "  FAIL: compile error"; $fail += 3
}

Write-Host "`n=== Results: $pass passed, $fail failed ==="
Remove-Item "t_dbg.nova","t_dbg.ll","t_dbg.exe","t_dbg.pdb","t_lines.nova","t_lines.ll","nova_runtime.c","nova_compiler.ll" -Force -ErrorAction SilentlyContinue
