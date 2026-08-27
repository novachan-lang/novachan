# 5.5 SINGLE-COMMAND TOOLCHAIN GATE (bundled clang discovery)
#
# THE PROMISE: `nova build` works on a machine with no clang, no LLVM and no MSVC on
# PATH, by discovering a toolchain bundled alongside the nova executable. Go and Zig
# ship one command that works on a clean machine; this is the gate that keeps NOVA's
# version of that claim honest.
#
# WHY THIS GATE IS SHAPED THE WAY IT IS
#
# The obvious gate -- "assert toolchains/clang/bin/clang.exe exists in the bundle" --
# is worthless: it passes with the resolution logic in nova_find_clang() completely
# broken, because the real build would just silently fall through to the system clang
# on PATH and succeed anyway. Every assertion here is therefore behavioural, and the
# load-bearing one is a build run in a child process whose PATH has had every
# clang/LLVM/MSVC directory stripped out.
#
# That still is not enough on its own. A PATH scrub that failed to remove anything
# would ALSO make case 1 pass. So case 2 is a negative control: the identical scrubbed
# environment, with the bundle absent, MUST fail to produce a working binary. Case 1
# only means something because case 2 fails. If both pass, the scrub is a no-op and the
# gate is lying -- which is exactly the failure mode that let this claim sit unverified.
#
# CASES
#   1  bundle present  + PATH scrubbed  -> builds, binary prints the sentinel   (THE CLAIM)
#   2  bundle ABSENT   + PATH scrubbed  -> must NOT produce a working binary    (SCRUB IS REAL)
#   3  bundle absent   + PATH normal    -> builds                              (NO REGRESSION)
#   4  NOVA_CLANG set  + bundle present -> explicit override wins over bundle   (PRECEDENCE)
#   5  NOVA_CLANG bogus+ PATH scrubbed  -> ignored, falls through to bundle      (ROBUSTNESS)
#   6  NOVA_HOME=bundle, nova from elsewhere, PATH scrubbed -> resolves via NOVA_HOME
#
# COST: staging a real dev bundle copies ~200MB (a stock LLVM Windows clang.exe is
# 104MB and lld-link.exe is 71MB). It is cached between runs at $env:TEMP and re-staged
# only when the source clang changes, so only the first run pays. -Force re-stages.
#
# A REAL bundle is used rather than a stub or a directory junction on purpose: it also
# proves the TRIMMED file set the bundler produces is actually sufficient to compile and
# link, which nothing else in the tree checks.

[CmdletBinding()]
param(
    [switch]$Force,          # re-stage the cached bundle
    [switch]$KeepArtifacts   # leave the staging dirs behind for inspection
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$repoRoot   = (Resolve-Path "$PSScriptRoot\..\..").Path
$bundler    = Join-Path $repoRoot 'tools\bundle_toolchain.ps1'
$novaSrcExe = if (Test-Path "$PSScriptRoot\_gen4.exe") { (Resolve-Path "$PSScriptRoot\_gen4.exe").Path } else { (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path }
$runtimeSrc = (Resolve-Path "$repoRoot\nova-compiler\compiler\nova_runtime.c").Path

$stageRoot  = Join-Path $env:TEMP 'nova_tc_gate'
$bundleDir  = Join-Path $stageRoot 'bundle'    # cached across runs (expensive)
$bareDir    = Join-Path $stageRoot 'bare'      # nova with NO bundle next to it
$workRoot   = Join-Path $stageRoot 'work'      # per-case build dirs (always fresh)

$SENTINEL = 'TOOLCHAIN_OK=42'
$PROBE = @'
fn main()
    let a = 6
    let b = 7
    print("TOOLCHAIN_OK=" + str(a * b))
'@

$fail = 0
$origPath = $env:PATH
$origHome = $env:NOVA_HOME
$origClang = $env:NOVA_CLANG

function Note { param([string]$m) Write-Host "  $m" }
function Pass { param([string]$m) Write-Host "  ok   $m" }
function Fail { param([string]$m) Write-Host "  FAIL $m"; $script:fail++ }

# ---------------------------------------------------------------------------
# Build the scrubbed PATH once, and prove it removed something.
#
# A directory is dropped if it CONTAINS a C toolchain driver or linker, or if its name
# mentions LLVM/clang. Probing for the actual executables (rather than only matching on
# the directory name) is what makes this robust: a clang installed under a name like
# C:\dev\tools\bin would survive a name-only filter and quietly invalidate case 1.
#
# Note this is deliberately over-broad -- Git's usr\bin ships a coreutils `link.exe` and
# so gets dropped too. Over-broad only makes the scrub STRICTER, so it can only ever
# make case 1 harder to pass, never easier.
# ---------------------------------------------------------------------------
$toolNames = @('clang.exe','clang++.exe','clang-cl.exe','lld-link.exe','ld.lld.exe','lld.exe',
               'llvm-config.exe','cl.exe','link.exe','gcc.exe','cc.exe')
$keptDirs = @(); $droppedDirs = @()
foreach ($d in ($origPath -split ';')) {
    if ([string]::IsNullOrWhiteSpace($d)) { continue }
    $isToolDir = $false
    foreach ($n in $toolNames) {
        if (Test-Path -LiteralPath (Join-Path $d $n) -ErrorAction SilentlyContinue) { $isToolDir = $true; break }
    }
    if ($isToolDir -or $d -match 'LLVM|[Cc]lang|MSVC|Microsoft Visual Studio|Windows Kits') { $droppedDirs += $d }
    else { $keptDirs += $d }
}
$scrubbedPath = ($keptDirs -join ';')

Write-Host "[5.5] Toolchain bundle gate"
Note "PATH dirs dropped by the scrub: $($droppedDirs.Count)"
foreach ($d in $droppedDirs) { Note "   - $d" }
if ($droppedDirs.Count -eq 0) {
    # No clang anywhere on PATH to begin with. Cases 1/5/6 would still be meaningful, but
    # case 3 (no-regression) cannot be tested and case 2 proves nothing about the scrub.
    Fail "the scrub dropped NOTHING from PATH -- no C toolchain was on PATH, so this gate cannot distinguish bundled resolution from PATH resolution. Install clang on PATH and re-run."
}

# ---------------------------------------------------------------------------
# Stage: a real bundle (cached), and a 'bare' tree with no toolchain anywhere above it.
# ---------------------------------------------------------------------------
if (-not (Test-Path $bundler)) { Fail "bundler not found at $bundler"; exit 1 }

$bundleArgs = @('-NoProfile','-ExecutionPolicy','Bypass','-File',$bundler,'-OutDir',$bundleDir,'-NovaExe',$novaSrcExe)
if ($Force) { $bundleArgs += '-Force' }
Note "staging bundle at $bundleDir (cached; -Force to re-stage) ..."
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$bs = Invoke-Timed -FilePath (Get-Command powershell).Source -Arguments (($bundleArgs | ForEach-Object { if ($_ -match '\s') { "`"$_`"" } else { $_ } }) -join ' ') -TimeoutMs 900000 -WorkingDirectory $repoRoot
$sw.Stop()
if ($bs.TimedOut -or $bs.ExitCode -ne 0) {
    Fail "bundle_toolchain.ps1 failed (exit=$($bs.ExitCode) timedout=$($bs.TimedOut))"
    Write-Host $bs.StdOut; Write-Host $bs.StdErr
    exit 1
}
Note "bundler took $([int]$sw.Elapsed.TotalSeconds)s"
foreach ($line in ($bs.StdOut -split "`r?`n")) { if ($line -match 'TOTAL SIZE|^\[bundle\]\s{3}') { Note $line.Trim() } }

$bundleNova = Join-Path $bundleDir 'bin\nova.exe'
$bundleClang = Join-Path $bundleDir 'toolchains\clang\bin\clang.exe'
if (-not (Test-Path $bundleNova))  { Fail "bundle missing bin\nova.exe"; exit 1 }
if (-not (Test-Path $bundleClang)) { Fail "bundle missing toolchains\clang\bin\clang.exe"; exit 1 }

# The 'bare' tree: nova.exe + its runtime, and deliberately NO toolchains/ directory at
# any level above it. This is what a user with a system clang and no bundle looks like.
Remove-Item -Recurse -Force $bareDir -ErrorAction SilentlyContinue
New-Item -ItemType Directory -Force -Path (Join-Path $bareDir 'bin'), (Join-Path $bareDir 'compiler') | Out-Null
Copy-Item -Force -LiteralPath $novaSrcExe -Destination (Join-Path $bareDir 'bin\nova.exe')
Copy-Item -Force -LiteralPath $runtimeSrc -Destination (Join-Path $bareDir 'compiler\nova_runtime.c')
$bareNova = Join-Path $bareDir 'bin\nova.exe'

# ---------------------------------------------------------------------------
# Helpers. Each case gets a FRESH work dir: a stale tiny.exe left by a previous case
# would make a failing build look like a passing one, which is the single easiest way
# to write a gate that reports green while the feature is broken.
# ---------------------------------------------------------------------------
function New-Case {
    param([string]$Name)
    $d = Join-Path $workRoot $Name
    Remove-Item -Recurse -Force $d -ErrorAction SilentlyContinue
    New-Item -ItemType Directory -Force -Path $d | Out-Null
    Set-Content -LiteralPath (Join-Path $d 'tiny.nova') -Value $PROBE -Encoding ascii
    return $d
}

# Returns @{ Built=<bool>; Ran=<bool>; Sentinel=<bool>; BuildExit=<int>; Out=<string> }
function Invoke-NovaBuild {
    param([string]$Nova, [string]$WorkDir, [int]$TimeoutMs = 420000)
    $exe = Join-Path $WorkDir 'tiny.exe'
    Remove-Item -Force $exe -ErrorAction SilentlyContinue
    $b = Invoke-Timed -FilePath $Nova -Arguments 'build tiny.nova' -TimeoutMs $TimeoutMs -WorkingDirectory $WorkDir
    $res = @{ Built = (Test-Path $exe); Ran = $false; Sentinel = $false; BuildExit = $b.ExitCode
              Out = (($b.StdOut + "`n" + $b.StdErr).Trim()) }
    if ($res.Built) {
        $x = Invoke-Timed -FilePath $exe -Arguments '' -TimeoutMs 60000 -WorkingDirectory $WorkDir
        $res.Ran = (-not $x.TimedOut -and $x.ExitCode -eq 0)
        $res.Sentinel = ($x.StdOut -match [regex]::Escape($SENTINEL))
        $res.Out = $res.Out + "`n[run] " + ($x.StdOut).Trim()
    }
    return $res
}

function Get-ToolchainStatus {
    param([string]$Nova)
    $r = Invoke-Timed -FilePath $Nova -Arguments 'toolchain status' -TimeoutMs 60000 -WorkingDirectory $stageRoot
    return ($r.StdOut).Trim()
}

try {
# ===========================================================================
# CASE 1 -- THE CLAIM: bundle present, PATH scrubbed of every C toolchain.
# ===========================================================================
$env:PATH = $scrubbedPath
Remove-Item Env:NOVA_CLANG -ErrorAction SilentlyContinue
Remove-Item Env:NOVA_HOME  -ErrorAction SilentlyContinue

# Sanity: with NOVA_HOME unset, resolution must come from the executable's own location.
# If clang is somehow still reachable on the scrubbed PATH, case 1 proves nothing.
$leak = Get-Command clang -ErrorAction SilentlyContinue
if ($leak) { Fail "clang is STILL reachable on the scrubbed PATH ($($leak.Source)) -- scrub incomplete, cases 1/2/5/6 are invalid" }

$st1 = Get-ToolchainStatus $bundleNova
if ($st1 -notmatch 'bundled toolchain') {
    Fail "case 1 status: expected '(bundled toolchain)', got: $st1"
} elseif ($st1 -notmatch [regex]::Escape($bundleDir)) {
    Fail "case 1 status: resolved clang is not inside the bundle: $st1"
} else {
    Pass "case 1 status: $st1"
}

$w1 = New-Case 'c1_bundle_scrubbed'
$r1 = Invoke-NovaBuild -Nova $bundleNova -WorkDir $w1
if (-not $r1.Built)         { Fail "case 1 (THE CLAIM): no binary produced with PATH scrubbed. exit=$($r1.BuildExit)`n$($r1.Out)" }
elseif (-not $r1.Ran)       { Fail "case 1 (THE CLAIM): binary built but did not run cleanly`n$($r1.Out)" }
elseif (-not $r1.Sentinel)  { Fail "case 1 (THE CLAIM): binary ran but did not print $SENTINEL`n$($r1.Out)" }
else                        { Pass "case 1 (THE CLAIM): built + ran + printed $SENTINEL with no clang on PATH" }

# ===========================================================================
# CASE 2 -- NEGATIVE CONTROL: identical scrubbed PATH, bundle absent.
# Case 1 is only evidence if this FAILS. If a build succeeds here, some C toolchain is
# still reachable and case 1's pass was an artifact of an ineffective scrub.
# ===========================================================================
$w2 = New-Case 'c2_bare_scrubbed'
$r2 = Invoke-NovaBuild -Nova $bareNova -WorkDir $w2 -TimeoutMs 240000
if ($r2.Sentinel) {
    Fail "case 2 (NEGATIVE CONTROL): a build SUCCEEDED with no bundle and a scrubbed PATH. The scrub is not effective, so case 1 proves nothing.`n$($r2.Out)"
} else {
    Pass "case 2 (NEGATIVE CONTROL): no working binary without the bundle (build exit=$($r2.BuildExit)) -- the scrub is real"
    # Secondary, non-fatal: the failure should be a clean diagnostic, not exit 0. A build
    # that reports success while producing nothing is a worse bug than a failed build.
    if ($r2.BuildExit -eq 0) {
        Note "NOTE: `nova build` exited 0 while producing no runnable binary. Reported, not gated here."
    }
}

# ===========================================================================
# CASE 3 -- NO REGRESSION: no bundle, normal PATH. Today's behaviour must be untouched.
# ===========================================================================
$env:PATH = $origPath
$w3 = New-Case 'c3_bare_syspath'
$r3 = Invoke-NovaBuild -Nova $bareNova -WorkDir $w3
if (-not $r3.Sentinel) {
    Fail "case 3 (NO REGRESSION): system-clang build broke. exit=$($r3.BuildExit)`n$($r3.Out)"
} else {
    Pass "case 3 (NO REGRESSION): system clang on PATH still builds + runs"
}
$st3 = Get-ToolchainStatus $bareNova
if ($st3 -notmatch 'system PATH') { Fail "case 3 status: expected 'system PATH', got: $st3" }
else { Pass "case 3 status: $st3" }

# ===========================================================================
# CASE 4 -- PRECEDENCE: an explicit NOVA_CLANG must beat a present bundle.
# This is the escape hatch a user reaches for when the bundled toolchain is wrong for
# their machine; if the bundle silently won instead, the override would be undebuggable.
# ===========================================================================
$sysClang = (Get-Command clang -ErrorAction SilentlyContinue)
if (-not $sysClang) {
    Note "case 4 SKIPPED: no system clang to override with"
} else {
    $env:NOVA_CLANG = $sysClang.Source
    $st4 = Get-ToolchainStatus $bundleNova
    Remove-Item Env:NOVA_CLANG -ErrorAction SilentlyContinue
    if ($st4 -match [regex]::Escape($bundleDir)) {
        Fail "case 4 (PRECEDENCE): NOVA_CLANG=$($sysClang.Source) was IGNORED; bundle won: $st4"
    } elseif ($st4 -notmatch [regex]::Escape($sysClang.Source)) {
        Fail "case 4 (PRECEDENCE): NOVA_CLANG not honoured: $st4"
    } else {
        Pass "case 4 (PRECEDENCE): explicit NOVA_CLANG beats the bundle"
    }
}

# ===========================================================================
# CASE 5 -- ROBUSTNESS: a NOVA_CLANG pointing at nothing must be ignored, not fatal.
# nova_find_clang() guards the override with path_exists(); a future refactor that
# trusted the variable blindly would turn one stale env var into an unbuildable machine.
# ===========================================================================
$env:PATH = $scrubbedPath
$env:NOVA_CLANG = (Join-Path $stageRoot 'no_such_clang_here.exe')
$w5 = New-Case 'c5_bogus_override'
$r5 = Invoke-NovaBuild -Nova $bundleNova -WorkDir $w5
Remove-Item Env:NOVA_CLANG -ErrorAction SilentlyContinue
if (-not $r5.Sentinel) {
    Fail "case 5 (ROBUSTNESS): a non-existent NOVA_CLANG broke the build instead of falling through to the bundle. exit=$($r5.BuildExit)`n$($r5.Out)"
} else {
    Pass "case 5 (ROBUSTNESS): bogus NOVA_CLANG ignored, bundle used"
}

# ===========================================================================
# CASE 6 -- NOVA_HOME rung: nova.exe from the BARE tree (no bundle above it), with
# NOVA_HOME pointing at the bundle. Isolates the second rung of the ladder from the
# install-relative one, so a regression in either is attributable.
# ===========================================================================
$env:NOVA_HOME = $bundleDir
$w6 = New-Case 'c6_novahome'
$r6 = Invoke-NovaBuild -Nova $bareNova -WorkDir $w6
Remove-Item Env:NOVA_HOME -ErrorAction SilentlyContinue
if (-not $r6.Sentinel) {
    Fail "case 6 (NOVA_HOME): NOVA_HOME-relative toolchain discovery failed. exit=$($r6.BuildExit)`n$($r6.Out)"
} else {
    Pass "case 6 (NOVA_HOME): NOVA_HOME/toolchains/clang/bin resolved with PATH scrubbed"
}

} finally {
    $env:PATH = $origPath
    if ($null -ne $origHome)  { $env:NOVA_HOME = $origHome }  else { Remove-Item Env:NOVA_HOME -ErrorAction SilentlyContinue }
    if ($null -ne $origClang) { $env:NOVA_CLANG = $origClang } else { Remove-Item Env:NOVA_CLANG -ErrorAction SilentlyContinue }
    if (-not $KeepArtifacts) {
        Remove-Item -Recurse -Force $workRoot -ErrorAction SilentlyContinue
        Remove-Item -Recurse -Force $bareDir  -ErrorAction SilentlyContinue
        # $bundleDir is intentionally KEPT: re-staging 200MB on every CI run is the one
        # cost that would make this gate not worth running.
    }
}

if ($fail -gt 0) {
    Write-Host "`n[5.5] TOOLCHAIN BUNDLE GATE: $fail FAILURE(S)"
    exit 1
}
Write-Host "`n[5.5] TOOLCHAIN BUNDLE GATE: ALL GREEN (bundled discovery proven under a scrubbed PATH; negative control failed as required)"
exit 0
