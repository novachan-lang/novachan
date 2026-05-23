Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force

$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "nova_doc.nova" -TimeoutMs 60000
Write-Host "Compile exit: $($cr.ExitCode)"
if ($cr.StdOut) { Write-Host "stdout: $($cr.StdOut)" }
if ($cr.ExitCode -ne 0) {
    if ($cr.StdErr) { Write-Host "stderr: $($cr.StdErr)" }
    exit 1
}

$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o nova_doc.exe nova_doc.ll nova_runtime.c -lws2_32" -TimeoutMs 60000
Write-Host "Link exit: $($lr.ExitCode)"
if (!(Test-Path "nova_doc.exe")) {
    if ($lr.StdErr) {
        $lines = $lr.StdErr -split "`n" | Where-Object { $_ -match "error" }
        foreach ($l in $lines) { Write-Host "  $l" }
    }
    exit 1
}

# Test 1: stdout markdown output
$rr = Invoke-Timed -FilePath (Resolve-Path ".\nova_doc.exe").Path -Arguments "doc_sample.nova" -TimeoutMs 10000
Write-Host "Test 1 (stdout md): exit=$($rr.ExitCode)"
$pass = 0; $fail = 0
if ($rr.StdOut -match "## Types" -and $rr.StdOut -match "## Enums" -and $rr.StdOut -match "## Functions") {
    Write-Host "  PASS: sections present"; $pass++
} else { Write-Host "  FAIL: missing sections"; $fail++ }
if ($rr.StdOut -match "Point" -and $rr.StdOut -match "AppError") {
    Write-Host "  PASS: type/enum names"; $pass++
} else { Write-Host "  FAIL: missing names"; $fail++ }
if ($rr.StdOut -match "Adds two numbers") {
    Write-Host "  PASS: doc comments extracted"; $pass++
} else { Write-Host "  FAIL: doc comments missing"; $fail++ }
if ($rr.StdOut -notmatch "no doc comment") {
    Write-Host "  PASS: undocumented fn has no doc text"; $pass++
} else { Write-Host "  FAIL: leaked non-doc comment"; $fail++ }

# Test 2: markdown file output
$rr2 = Invoke-Timed -FilePath (Resolve-Path ".\nova_doc.exe").Path -Arguments "doc_sample.nova test_out.md" -TimeoutMs 10000
Write-Host "Test 2 (file md): exit=$($rr2.ExitCode)"
if (Test-Path "test_out.md") {
    $md = Get-Content "test_out.md" -Raw
    if ($md -match "## Types" -and $md -match "## Functions") {
        Write-Host "  PASS: file written correctly"; $pass++
    } else { Write-Host "  FAIL: file content wrong"; $fail++ }
} else { Write-Host "  FAIL: file not created"; $fail++ }

# Test 3: HTML output
$rr3 = Invoke-Timed -FilePath (Resolve-Path ".\nova_doc.exe").Path -Arguments "doc_sample.nova test_out.html" -TimeoutMs 10000
Write-Host "Test 3 (html): exit=$($rr3.ExitCode)"
if (Test-Path "test_out.html") {
    $html = Get-Content "test_out.html" -Raw
    if ($html -match "<!DOCTYPE html>" -and $html -match "<h2>Types</h2>" -and $html -match "<h2>Functions</h2>") {
        Write-Host "  PASS: valid HTML structure"; $pass++
    } else { Write-Host "  FAIL: HTML structure wrong"; $fail++ }
    if ($html -match "<code>Point</code>" -and $html -match "<code>AppError</code>") {
        Write-Host "  PASS: HTML type/enum names"; $pass++
    } else { Write-Host "  FAIL: HTML missing names"; $fail++ }
    if ($html -match "class=.doc.") {
        Write-Host "  PASS: styled doc blocks"; $pass++
    } else { Write-Host "  FAIL: missing doc blocks"; $fail++ }
} else { Write-Host "  FAIL: HTML not created"; $fail++ }

# Test 4: stress test on compiler source
$rr4 = Invoke-Timed -FilePath (Resolve-Path ".\nova_doc.exe").Path -Arguments "nova_compiler.nova compiler_test.md" -TimeoutMs 30000
Write-Host "Test 4 (compiler): exit=$($rr4.ExitCode)"
if ($rr4.StdOut -match "(\d+) types" -and $rr4.StdOut -match "(\d+) functions") {
    $dummy = $rr4.StdOut -match "(\d+) types"; $t = [int]$Matches[1]
    $dummy = $rr4.StdOut -match "(\d+) functions"; $f = [int]$Matches[1]
    if ($t -ge 10 -and $f -ge 100) {
        Write-Host "  PASS: $t types, $f functions extracted"; $pass++
    } else { Write-Host "  FAIL: too few items ($t types, $f fns)"; $fail++ }
} else { Write-Host "  FAIL: no summary output"; $fail++ }

Write-Host "`n=== Results: $pass passed, $fail failed ==="

Remove-Item "nova_doc.ll","nova_doc.exe","nova_runtime.c","test_out.md","test_out.html","compiler_test.md" -Force -ErrorAction SilentlyContinue
