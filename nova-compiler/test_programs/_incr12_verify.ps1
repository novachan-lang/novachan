# Verify the `nova new` Forge scaffolder BEFORE reconverge: build gen4 from the edited
# nova_compiler.nova, then for each project type run `nova new <name> --<kind>` and GENERATE +
# COMPILE + RUN the result (servers via --check -> selfcheck status=200; lib via its test).
# Generated projects resolve `import forge` from $NOVA_HOME/lib (set + installed by _proc_util).
# Kill-on-timeout throughout.
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

Write-Host "[1] gen3 compiles edited nova_compiler.nova -> gen4_test.exe"
Remove-Item nova_compiler.ll -Force -ErrorAction SilentlyContinue
$c = Invoke-Timed -FilePath ".\gen3_test.exe" -Arguments "nova_compiler.nova" -TimeoutMs 900000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path nova_compiler.ll)) { Write-Host "COMPILE FAIL exit=$($c.ExitCode)"; if($c.StdOut){Write-Host ($c.StdOut.Substring(0,[Math]::Min(2500,$c.StdOut.Length)))}; exit 1 }
$l = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen4_test.exe nova_compiler.ll output\nova_runtime.c -lws2_32 -ladvapi32 -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
if (!(Test-Path gen4_test.exe)) { Write-Host "LINK gen4 FAIL"; exit 1 }
Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 output\nova_runtime.c -o output\nova_runtime.o -w" -TimeoutMs 120000 -WorkingDirectory $PSScriptRoot | Out-Null
Write-Host "gen4 built OK"

$gen4 = Join-Path $PSScriptRoot "gen4_test.exe"
$rto  = Join-Path $PSScriptRoot "output\nova_runtime.o"
$out  = Join-Path $PSScriptRoot "_scaffold_out"
Remove-Item $out -Recurse -Force -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path $out | Out-Null
$fail = 0

foreach ($k in @("api","microservice","frontend","fullstack")) {
    Write-Host "=== nova new app_$k --$k ==="
    $proj = "app_$k"
    Invoke-Timed -FilePath $gen4 -Arguments "new $proj --$k" -TimeoutMs 30000 -WorkingDirectory $out | Out-Null
    $projDir = Join-Path $out $proj
    if (!(Test-Path (Join-Path $projDir "src\main.nova"))) { Write-Host "  GENERATE FAIL"; $fail=1; continue }
    Remove-Item (Join-Path $projDir "src\main.ll"), (Join-Path $projDir "app.exe") -Force -ErrorAction SilentlyContinue
    $cc = Invoke-Timed -FilePath $gen4 -Arguments "src\main.nova" -TimeoutMs 120000 -WorkingDirectory $projDir
    if (!(Test-Path (Join-Path $projDir "src\main.ll"))) { Write-Host "  COMPILE FAIL"; if($cc.StdOut){Write-Host $cc.StdOut}; $fail=1; continue }
    $lk = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o app.exe src\main.ll `"$rto`" -lws2_32 -ladvapi32 -w" -TimeoutMs 90000 -WorkingDirectory $projDir
    if (!(Test-Path (Join-Path $projDir "app.exe"))) { Write-Host "  LINK FAIL"; if($lk.StdOut){Write-Host $lk.StdOut}; $fail=1; continue }
    $run = Invoke-Timed -FilePath (Join-Path $projDir "app.exe") -Arguments "--check" -TimeoutMs 15000 -WorkingDirectory $projDir
    $o = ([string]$run.StdOut).Trim()
    Write-Host "  RUN: $o  exit=$($run.ExitCode)"
    if ($run.ExitCode -ne 0 -or $o -notmatch "selfcheck status=200") { Write-Host "  *** $k FAIL ***"; $fail=1 }
}

Write-Host "=== nova new mathx --lib ==="
Invoke-Timed -FilePath $gen4 -Arguments "new mathx --lib" -TimeoutMs 30000 -WorkingDirectory $out | Out-Null
$libDir = Join-Path $out "mathx"
if (!(Test-Path (Join-Path $libDir "mathx_test.nova"))) { Write-Host "  GENERATE FAIL"; $fail=1 }
else {
    Remove-Item (Join-Path $libDir "mathx_test.ll"), (Join-Path $libDir "mathx_test.exe") -Force -ErrorAction SilentlyContinue
    $cc = Invoke-Timed -FilePath $gen4 -Arguments "mathx_test.nova" -TimeoutMs 120000 -WorkingDirectory $libDir
    if (!(Test-Path (Join-Path $libDir "mathx_test.ll"))) { Write-Host "  COMPILE FAIL"; if($cc.StdOut){Write-Host $cc.StdOut}; $fail=1 }
    else {
        Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o mathx_test.exe mathx_test.ll `"$rto`" -lws2_32 -ladvapi32 -w" -TimeoutMs 90000 -WorkingDirectory $libDir | Out-Null
        $run = Invoke-Timed -FilePath (Join-Path $libDir "mathx_test.exe") -Arguments "" -TimeoutMs 15000 -WorkingDirectory $libDir
        $o = ([string]$run.StdOut).Trim()
        Write-Host "  RUN: $o  exit=$($run.ExitCode)"
        if ($o -notmatch "tests passed") { Write-Host "  *** lib FAIL ***"; $fail=1 }
    }
}
Write-Host ""
if ($fail -eq 0) { Write-Host "=== nova new: ALL 5 KINDS GENERATE+COMPILE+RUN OK ===" } else { Write-Host "=== nova new VERIFY FAILED ==="; exit 1 }
