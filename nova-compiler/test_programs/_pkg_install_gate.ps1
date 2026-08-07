# Package-manager gate. Proves `nova install` actually works END TO END, offline, against the
# registry bundled in this repo (packages/registry) -- no network, no external host.
#
# Covers the four things that were broken or missing before 2026-08-07:
#   1. install resolves a package and writes nova.lock
#   2. an installed package is IMPORTABLE -- compiles and runs with correct output
#   3. TRANSITIVE deps resolve (alpha -> beta -> gamma, only alpha declared)
#   4. a dependency CYCLE terminates instead of hanging
#
# Exits non-zero on any failure so CI can gate on it.
param([string]$Compiler = "gen3_test.exe")   # override to validate a gen4 before it is installed

Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$repo     = (Resolve-Path "$PSScriptRoot\..\..").Path
$compiler = (Resolve-Path "$PSScriptRoot\$Compiler").Path
$registry = Join-Path $repo "packages\registry"
$work     = Join-Path ([System.IO.Path]::GetTempPath()) ("nova_pkg_gate_" + [guid]::NewGuid().ToString("N").Substring(0,8))

$env:NOVA_HOME     = (Resolve-Path "$PSScriptRoot\..").Path
$env:NOVA_REGISTRY = $registry
$env:NOVA_NO_CACHE = "1"

if (-not (Test-Path $registry)) { Write-Host "FAIL: bundled registry missing at $registry"; exit 1 }

$fail = 0
function Check($name, $cond, $detail) {
    if ($cond) { Write-Host "PASS $name" } else { Write-Host "FAIL $name -- $detail"; $script:fail++ }
}

try {
    # ---- 1 + 2: install a real bundled package, then import and run it ----
    $p1 = Join-Path $work "proj1"
    New-Item -ItemType Directory -Force -Path $p1 | Out-Null
    Set-Content -Path (Join-Path $p1 "nova.toml") -Encoding ascii -Value @(
        '[package]', 'name = "gate"', 'version = "0.1.0"', '', '[dependencies]', 'greet = "0.1.0"   # trailing comment must not corrupt the version'
    )
    $r = Invoke-Timed -FilePath $compiler -Arguments "install" -TimeoutMs 120000 -WorkingDirectory $p1
    Check "install exits 0"        ($r.ExitCode -eq 0)                                          "exit=$($r.ExitCode)"
    Check "package source fetched" (Test-Path (Join-Path $p1 "nova_packages\greet\greet.nova")) "greet.nova not written"
    Check "nova.lock written"      (Test-Path (Join-Path $p1 "nova.lock"))                      "no lockfile"
    # The version must be exactly 0.1.0 -- a trailing `#` comment used to be swallowed into it.
    $lock = Get-Content (Join-Path $p1 "nova.lock") -Raw -ErrorAction SilentlyContinue
    Check "version parsed cleanly" ($lock -match 'version\s*=\s*"0\.1\.0"')                     "lock=$lock"

    Set-Content -Path (Join-Path $p1 "app.nova") -Encoding ascii -Value @(
        'import greet', '', 'fn main()', '    print(greet.greet("NOVA"))'
    )
    $b = Invoke-Timed -FilePath $compiler -Arguments "build app.nova" -TimeoutMs 180000 -WorkingDirectory $p1
    $exe = Join-Path $p1 "app.exe"
    Check "installed pkg compiles" (Test-Path $exe) "build exit=$($b.ExitCode)"
    if (Test-Path $exe) {
        $rr = Invoke-Timed -FilePath $exe -Arguments "" -TimeoutMs 30000 -WorkingDirectory $p1
        Check "installed pkg runs correctly" ($rr.StdOut -match "Hello, NOVA!") "stdout=$($rr.StdOut.Trim())"
    }

    # ---- 3 + 4: transitive chain and dependency cycle, via a throwaway fixture registry ----
    $fix = Join-Path $work "fixreg"
    foreach ($pkg in @("alpha","beta","gamma","loopa","loopb")) {
        New-Item -ItemType Directory -Force -Path (Join-Path $fix $pkg) | Out-Null
        Set-Content -Path (Join-Path $fix "$pkg\$pkg.nova") -Encoding ascii -Value @("fn ${pkg}_hi() -> string", "    `"$pkg`"")
    }
    function WriteIdx($pkg, $dep) {
        $lines = @('[package]', "name = `"$pkg`"", 'version = "1.0.0"', "source = `"$pkg/$pkg.nova`"")
        if ($dep) { $lines += @('', '[dependencies]', "$dep = `"1.0.0`"") }
        Set-Content -Path (Join-Path $fix "$pkg\index.toml") -Encoding ascii -Value $lines
    }
    WriteIdx "alpha" "beta"; WriteIdx "beta" "gamma"; WriteIdx "gamma" $null
    WriteIdx "loopa" "loopb"; WriteIdx "loopb" "loopa"     # <- deliberate cycle
    $env:NOVA_REGISTRY = $fix

    $p2 = Join-Path $work "proj2"
    New-Item -ItemType Directory -Force -Path $p2 | Out-Null
    Set-Content -Path (Join-Path $p2 "nova.toml") -Encoding ascii -Value @('[package]','name = "t"','version = "0.1.0"','','[dependencies]','alpha = "1.0.0"')
    $r2 = Invoke-Timed -FilePath $compiler -Arguments "install" -TimeoutMs 120000 -WorkingDirectory $p2
    $got = @("alpha","beta","gamma") | Where-Object { Test-Path (Join-Path $p2 "nova_packages\$_\$_.nova") }
    Check "transitive deps resolved" ($got.Count -eq 3) "only got: $($got -join ',')"

    $p3 = Join-Path $work "proj3"
    New-Item -ItemType Directory -Force -Path $p3 | Out-Null
    Set-Content -Path (Join-Path $p3 "nova.toml") -Encoding ascii -Value @('[package]','name = "t"','version = "0.1.0"','','[dependencies]','loopa = "1.0.0"')
    $r3 = Invoke-Timed -FilePath $compiler -Arguments "install" -TimeoutMs 120000 -WorkingDirectory $p3
    Check "dependency cycle terminates" ((-not $r3.TimedOut) -and $r3.ExitCode -eq 0) "timedout=$($r3.TimedOut) exit=$($r3.ExitCode)"
}
finally {
    Remove-Item -Recurse -Force $work -ErrorAction SilentlyContinue
}

if ($fail -gt 0) { Write-Host "`n=== PACKAGE GATE FAILED ($fail check(s)) ==="; exit 1 }
Write-Host "`n=== PACKAGE GATE PASS ==="
exit 0
