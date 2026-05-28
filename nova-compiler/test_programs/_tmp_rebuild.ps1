Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

# Step 1: Compile fixed source with current gen2_move.exe
$cr = Invoke-Timed -FilePath (Resolve-Path ".\gen2_move.exe").Path -Arguments "nova_compiler.nova" -TimeoutMs 60000
Write-Host "Compile: exit=$($cr.ExitCode)"
if ($cr.ExitCode -ne 0) { Write-Host "COMPILE FAIL"; exit 1 }

# Step 2: Link new compiler
Copy-Item "output\nova_runtime.c" "nova_runtime.c" -Force
$lr = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o gen2_new.exe nova_compiler.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 60000
Write-Host "Link: exit=$($lr.ExitCode)"
if (!(Test-Path "gen2_new.exe")) { Write-Host "LINK FAIL"; exit 1 }
Write-Host "gen2_new.exe built: $((Get-Item gen2_new.exe).Length) bytes"

# Step 3: Test regex_test with the new compiler
$cr2 = Invoke-Timed -FilePath (Resolve-Path ".\gen2_new.exe").Path -Arguments "regex_test.nova" -TimeoutMs 30000
Write-Host "Regex compile: exit=$($cr2.ExitCode)"
if ($cr2.ExitCode -ne 0) { Write-Host "REGEX COMPILE FAIL"; Remove-Item "gen2_new.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue; exit 1 }

$lr2 = Invoke-Timed -FilePath $ClangPath -Arguments "-O2 -o regex_test.exe regex_test.ll nova_runtime.c $NovaLinkFlags" -TimeoutMs 30000
Write-Host "Regex link: exit=$($lr2.ExitCode)"
if (!(Test-Path "regex_test.exe")) {
    # Show link errors
    if ($lr2.StdErr) {
        $errs = $lr2.StdErr -split "`n" | Where-Object { $_ -match "error:|undefined" } | Select-Object -First 10
        foreach ($e in $errs) { Write-Host "  $e" }
    }
    Write-Host "REGEX LINK FAIL"
    Remove-Item "gen2_new.exe","nova_runtime.c","regex_test.ll" -Force -ErrorAction SilentlyContinue
    exit 1
}

$rr = Invoke-Timed -FilePath (Resolve-Path ".\regex_test.exe").Path -Arguments "" -TimeoutMs 15000
Write-Host "Regex run: exit=$($rr.ExitCode)"
if ($rr.StdOut) { Write-Host $rr.StdOut.Trim() }
if ($rr.ExitCode -ne 0) { Write-Host "REGEX RUN FAIL" }

Remove-Item "regex_test.exe","regex_test.ll","gen2_new.exe","nova_runtime.c" -Force -ErrorAction SilentlyContinue
