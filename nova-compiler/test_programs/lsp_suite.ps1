Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$LSP_EXE      = (Resolve-Path ".\lsp_server.exe").Path
$COMPILER_EXE = (Resolve-Path ".\gen2_move.exe").Path
$TIMEOUT_MS   = 15000

function Make-Msg($body) {
    $bytes = [System.Text.Encoding]::UTF8.GetBytes($body)
    "Content-Length: $($bytes.Length)`r`n`r`n$body"
}

function Escape-Json($s) {
    $s -replace '\\','\\' -replace '"','\"' -replace "`n",'\n' -replace "`r",'\r' -replace "`t",'\t'
}

function Run-LspSession($testName, $payload) {
    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName               = $LSP_EXE
    $psi.Arguments              = "`"$COMPILER_EXE`""
    $psi.UseShellExecute        = $false
    $psi.RedirectStandardInput  = $true
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError  = $true
    $psi.CreateNoWindow         = $true

    $proc = [System.Diagnostics.Process]::Start($psi)
    $outTask = $proc.StandardOutput.ReadToEndAsync()
    $errTask = $proc.StandardError.ReadToEndAsync()

    $proc.StandardInput.Write($payload)
    $proc.StandardInput.Close()

    $done = $proc.WaitForExit($TIMEOUT_MS)
    if (-not $done) {
        try { $proc.Kill() } catch {}
        try { $proc.WaitForExit(5000) | Out-Null } catch {}
        Write-Host "  [TIMEOUT] $testName process killed after ${TIMEOUT_MS}ms" -ForegroundColor Red
        return $null
    }

    return [pscustomobject]@{
        ExitCode = $proc.ExitCode
        StdOut   = $outTask.Result
        StdErr   = $errTask.Result
    }
}

function Make-Session($novaCode) {
    $e = Escape-Json $novaCode
    $init     = Make-Msg '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":null,"capabilities":{}}}'
    $inited   = Make-Msg '{"jsonrpc":"2.0","method":"initialized","params":{}}'
    $didopen  = Make-Msg "{""jsonrpc"":""2.0"",""method"":""textDocument/didOpen"",""params"":{""textDocument"":{""uri"":""file:///test.nova"",""languageId"":""nova"",""version"":1,""text"":""$e""}}}"
    $shutdown = Make-Msg '{"jsonrpc":"2.0","id":2,"method":"shutdown"}'
    $exitMsg  = Make-Msg '{"jsonrpc":"2.0","method":"exit"}'
    return $init + $inited + $didopen + $shutdown + $exitMsg
}

$passed = 0
$failed = 0

Write-Host ""
Write-Host "=== NOVA LSP Server Test Suite ===" -ForegroundColor Cyan
Write-Host "    LSP:      $LSP_EXE"
Write-Host "    Compiler: $COMPILER_EXE"
Write-Host ""

# Test 1: syntax error (missing closing paren)
Write-Host "Test 1: syntax error file" -ForegroundColor White
$code1    = "fn main()`n    let x = (1 + 2`n    print(x)`n"
$r1       = Run-LspSession "Test1" (Make-Session $code1)
if ($null -ne $r1) {
    $diagArr  = ([regex]::Match($r1.StdOut, '"diagnostics":\[([^\]]*)\]')).Groups[1].Value
    $msgCount = ([regex]::Matches($diagArr, '"message"')).Count
    if ($msgCount -ge 1 -and $r1.StdOut.Contains("expected")) {
        Write-Host "  [PASS] Test1: $msgCount diagnostic(s)" -ForegroundColor Green
        Write-Host "         $diagArr" -ForegroundColor DarkGray
        $passed++
    } else {
        Write-Host "  [FAIL] Test1: expected >=1 diagnostics with 'expected', got $msgCount" -ForegroundColor Red
        Write-Host "         stdout: $($r1.StdOut)" -ForegroundColor DarkGray
        $failed++
    }
} else { $failed++ }

# Test 2: clean file (no errors)
Write-Host "Test 2: clean file (no diagnostics)" -ForegroundColor White
$code2    = "fn main()`n    let x = 42`n    print(x)`n"
$r2       = Run-LspSession "Test2" (Make-Session $code2)
if ($null -ne $r2) {
    $diagArr  = ([regex]::Match($r2.StdOut, '"diagnostics":\[([^\]]*)\]')).Groups[1].Value
    $msgCount = ([regex]::Matches($diagArr, '"message"')).Count
    $hasDiag  = $r2.StdOut.Contains("publishDiagnostics")
    if ($hasDiag -and $msgCount -eq 0) {
        Write-Host "  [PASS] Test2: publishDiagnostics sent with empty array" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "  [FAIL] Test2: hasDiag=$hasDiag msgCount=$msgCount" -ForegroundColor Red
        Write-Host "         stdout: $($r2.StdOut)" -ForegroundColor DarkGray
        $failed++
    }
} else { $failed++ }

# Test 3: multiple errors (2 broken functions)
Write-Host "Test 3: multiple errors (>=2 diagnostics)" -ForegroundColor White
$code3 = "fn good()`n    let x = 1`n`nfn broken1()`n    let y = (1 + 2`n    print(y)`n`nfn broken2()`n    let z = [1, 2`n    print(z)`n"
$r3    = Run-LspSession "Test3" (Make-Session $code3)
if ($null -ne $r3) {
    $diagArr  = ([regex]::Match($r3.StdOut, '"diagnostics":\[([^\]]*)\]')).Groups[1].Value
    $msgCount = ([regex]::Matches($diagArr, '"message"')).Count
    if ($msgCount -ge 2) {
        Write-Host "  [PASS] Test3: $msgCount diagnostic(s)" -ForegroundColor Green
        Write-Host "         $diagArr" -ForegroundColor DarkGray
        $passed++
    } else {
        Write-Host "  [FAIL] Test3: expected >=2 diagnostics, got $msgCount" -ForegroundColor Red
        Write-Host "         stdout: $($r3.StdOut)" -ForegroundColor DarkGray
        $failed++
    }
} else { $failed++ }

# Test 4: server exits cleanly (exit code 0)
Write-Host "Test 4: clean exit (exit code 0)" -ForegroundColor White
$code4 = "fn main()`n    print(1)`n"
$r4    = Run-LspSession "Test4" (Make-Session $code4)
if ($null -ne $r4 -and $r4.ExitCode -eq 0) {
    Write-Host "  [PASS] Test4: exit code 0" -ForegroundColor Green
    $passed++
} else {
    $code = if ($null -eq $r4) { "timeout" } else { $r4.ExitCode }
    Write-Host "  [FAIL] Test4: exit code $code" -ForegroundColor Red
    if ($null -ne $r4) { Write-Host "         stderr: $($r4.StdErr)" -ForegroundColor DarkGray }
    $failed++
}

# Test 5: didChange updates diagnostics (open broken, change to clean -> 2 publishDiagnostics)
Write-Host "Test 5: didChange clears errors" -ForegroundColor White
$eBroken = Escape-Json "fn main()`n    let x = (1 + 2`n    print(x)`n"
$eClean  = Escape-Json "fn main()`n    let x = 42`n    print(x)`n"
$init5     = Make-Msg '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"processId":null,"rootUri":null,"capabilities":{}}}'
$inited5   = Make-Msg '{"jsonrpc":"2.0","method":"initialized","params":{}}'
$didopen5  = Make-Msg "{""jsonrpc"":""2.0"",""method"":""textDocument/didOpen"",""params"":{""textDocument"":{""uri"":""file:///t.nova"",""languageId"":""nova"",""version"":1,""text"":""$eBroken""}}}"
$didchg5   = Make-Msg "{""jsonrpc"":""2.0"",""method"":""textDocument/didChange"",""params"":{""textDocument"":{""uri"":""file:///t.nova"",""version"":2},""contentChanges"":[{""text"":""$eClean""}]}}"
$shutdown5 = Make-Msg '{"jsonrpc":"2.0","id":2,"method":"shutdown"}'
$exit5     = Make-Msg '{"jsonrpc":"2.0","method":"exit"}'
$payload5  = $init5 + $inited5 + $didopen5 + $didchg5 + $shutdown5 + $exit5

$r5 = Run-LspSession "Test5" $payload5
if ($null -ne $r5) {
    $diagCount5 = ([regex]::Matches($r5.StdOut, 'publishDiagnostics')).Count
    if ($diagCount5 -eq 2) {
        Write-Host "  [PASS] Test5: 2 publishDiagnostics (open + change)" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "  [FAIL] Test5: expected 2 publishDiagnostics, got $diagCount5" -ForegroundColor Red
        Write-Host "         stdout: $($r5.StdOut)" -ForegroundColor DarkGray
        $failed++
    }
} else { $failed++ }

# Summary
Write-Host ""
Write-Host "-----------------------------------------" -ForegroundColor Cyan
$total = $passed + $failed
if ($failed -eq 0) {
    Write-Host "  ALL $total TESTS PASSED" -ForegroundColor Green
} else {
    Write-Host "  $passed/$total passed, $failed FAILED" -ForegroundColor Red
}
Write-Host "-----------------------------------------" -ForegroundColor Cyan
Write-Host ""
