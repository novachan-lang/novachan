# Verify the `nova new` scaffolder end-to-end: build nova_new.exe, generate ALL FIVE project
# types into a scratch dir, then for each: compile the generated NOVA (proves the templates use
# the REAL forge API + valid NOVA syntax/indentation) and RUN it -- server scaffolds via their
# --check self-test (one dispatch through the full pipeline, no socket; expect status=200), the
# lib scaffold via its generated test (expect "tests passed"). Kill-on-timeout throughout.
# Sources _proc_util.ps1 -> NOVA_HOME set + forge installed to lib, so generated projects
# resolve `import forge` exactly as a real out-of-tree project does.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$gen3 = Join-Path $PSScriptRoot "gen3_test.exe"
$rto  = Join-Path $PSScriptRoot "output\nova_runtime.o"
$novaNew = Join-Path $PSScriptRoot "nova_new.exe"
$fail = 0

Write-Host "[build] nova_new.nova -> nova_new.exe"
Remove-Item nova_new.ll, nova_new.exe -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath $gen3 -Arguments "nova_new.nova" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path nova_new.ll)) { Write-Host "nova_new COMPILE FAIL"; if($c.StdOut){Write-Host $c.StdOut}; exit 1 }
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o nova_new.exe nova_new.ll output\nova_runtime.o -lws2_32 -ladvapi32 -w" -TimeoutMs 90000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path nova_new.exe)) { Write-Host "nova_new LINK FAIL"; if($l.StdOut){Write-Host $l.StdOut}; exit 1 }
# ensure runtime.o is fresh for project links
Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 output\nova_runtime.c -o output\nova_runtime.o -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot | Out-Null
Write-Host "nova_new.exe built OK"

$out = Join-Path $PSScriptRoot "_scaffold_out"
Remove-Item $out -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $out | Out-Null

foreach ($k in @("api","microservice","frontend","fullstack")) {
    Write-Host "=== --$k ==="
    $proj = "app_$k"
    Invoke-Timed -FilePath $novaNew -Arguments "--$k $proj" -TimeoutMs 30000 -WorkingDirectory $out | Out-Null
    $projDir = Join-Path $out $proj
    if (!(Test-Path (Join-Path $projDir "main.nova"))) { Write-Host "  GENERATE FAIL"; $fail = 1; continue }
    Remove-Item (Join-Path $projDir "main.ll"), (Join-Path $projDir "app.exe") -Force -ErrorAction SilentlyContinue
    $cc = Invoke-Timed -FilePath $gen3 -Arguments "main.nova" -TimeoutMs 120000 -WorkingDirectory $projDir
    if (!(Test-Path (Join-Path $projDir "main.ll"))) { Write-Host "  COMPILE FAIL"; if($cc.StdOut){Write-Host $cc.StdOut}; $fail = 1; continue }
    $lk = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o app.exe main.ll `"$rto`" -lws2_32 -ladvapi32 -w" -TimeoutMs 90000 -WorkingDirectory $projDir
    if (!(Test-Path (Join-Path $projDir "app.exe"))) { Write-Host "  LINK FAIL"; if($lk.StdOut){Write-Host $lk.StdOut}; $fail = 1; continue }
    $run = Invoke-Timed -FilePath (Join-Path $projDir "app.exe") -Arguments "--check" -TimeoutMs 15000 -WorkingDirectory $projDir
    $o = ([string]$run.StdOut).Trim()
    Write-Host "  RUN: $o  exit=$($run.ExitCode) timedout=$($run.TimedOut)"
    if ($run.ExitCode -ne 0 -or $o -notmatch "selfcheck status=200") { Write-Host "  *** $k SELFCHECK FAIL ***"; $fail = 1 }
}

Write-Host "=== --lib ==="
Invoke-Timed -FilePath $novaNew -Arguments "--lib mathx" -TimeoutMs 30000 -WorkingDirectory $out | Out-Null
$libDir = Join-Path $out "mathx"
if (!(Test-Path (Join-Path $libDir "mathx_test.nova"))) { Write-Host "  GENERATE FAIL"; $fail = 1 }
else {
    Remove-Item (Join-Path $libDir "mathx_test.ll"), (Join-Path $libDir "mathx_test.exe") -Force -ErrorAction SilentlyContinue
    $cc = Invoke-Timed -FilePath $gen3 -Arguments "mathx_test.nova" -TimeoutMs 120000 -WorkingDirectory $libDir
    if (!(Test-Path (Join-Path $libDir "mathx_test.ll"))) { Write-Host "  COMPILE FAIL"; if($cc.StdOut){Write-Host $cc.StdOut}; $fail = 1 }
    else {
        $lk = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o mathx_test.exe mathx_test.ll `"$rto`" -lws2_32 -ladvapi32 -w" -TimeoutMs 90000 -WorkingDirectory $libDir
        if (!(Test-Path (Join-Path $libDir "mathx_test.exe"))) { Write-Host "  LINK FAIL"; $fail = 1 }
        else {
            $run = Invoke-Timed -FilePath (Join-Path $libDir "mathx_test.exe") -Arguments "" -TimeoutMs 15000 -WorkingDirectory $libDir
            $o = ([string]$run.StdOut).Trim()
            Write-Host "  RUN: $o  exit=$($run.ExitCode)"
            if ($run.ExitCode -ne 0 -or $o -notmatch "tests passed") { Write-Host "  *** lib TEST FAIL ***"; $fail = 1 }
        }
    }
}

Write-Host ""
if ($fail -eq 0) { Write-Host "=== ALL 5 SCAFFOLDS: GENERATE + COMPILE + RUN OK ===" } else { Write-Host "=== SCAFFOLD VERIFY FAILED ==="; exit 1 }
