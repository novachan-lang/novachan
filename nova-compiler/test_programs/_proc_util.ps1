# ─────────────────────────────────────────────────────────────────────────────
# Shared process runner with MANDATORY kill-on-timeout.
#
# Every script that launches a NOVA compiler or test binary MUST use Invoke-Timed.
#
# WHY THIS EXISTS:
#   [System.Diagnostics.Process].WaitForExit(ms) only RETURNS when the timeout
#   elapses — it does NOT kill the process. A hung binary left alive pins a CPU
#   core forever. During a 68-test run, dozens of hung compilers accumulated and
#   blocked the entire machine (2026-05-22 incident; see safe-binary-testing
#   memory). Invoke-Timed guarantees the process is DEAD before it returns.
#
#   It also reads stdout/stderr asynchronously so a full pipe buffer can never
#   deadlock the child (which would itself look like a hang).
# ─────────────────────────────────────────────────────────────────────────────

function Invoke-Timed {
    param(
        [Parameter(Mandatory = $true)][string]$FilePath,
        [string]$Arguments = "",
        [int]$TimeoutMs = 30000,
        [string]$WorkingDirectory = $PSScriptRoot
    )

    $psi = New-Object System.Diagnostics.ProcessStartInfo
    $psi.FileName               = $FilePath
    $psi.Arguments              = $Arguments
    $psi.WorkingDirectory       = $WorkingDirectory
    $psi.UseShellExecute        = $false
    $psi.RedirectStandardOutput = $true
    $psi.RedirectStandardError  = $true
    $psi.CreateNoWindow         = $true

    $proc = [System.Diagnostics.Process]::Start($psi)

    # Async reads: a full stdout/stderr pipe must never block the child.
    $outTask = $proc.StandardOutput.ReadToEndAsync()
    $errTask = $proc.StandardError.ReadToEndAsync()

    $done = $proc.WaitForExit($TimeoutMs)

    if (-not $done) {
        # Timed out — KILL it. WaitForExit returning is not enough.
        try { $proc.Kill() } catch {}
        try { $proc.WaitForExit(5000) | Out-Null } catch {}
        return [pscustomobject]@{
            TimedOut = $true
            ExitCode = -1
            StdOut   = ""
            StdErr   = ""
        }
    }

    return [pscustomobject]@{
        TimedOut = $false
        ExitCode = $proc.ExitCode
        StdOut   = $outTask.Result
        StdErr   = $errTask.Result
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# Kill ORPHANED build/compiler processes before starting a build.
#
# WHY THIS EXISTS:
#   The NOVA compiler derives its output filename from its input
#   (nova_compiler.nova -> nova_compiler.ll). If two compiler processes build the
#   same source concurrently they CLOBBER that file — it stalls at 0 bytes and
#   every downstream link/test then fails mysteriously (2026-06-25 incident: a
#   build backgrounded with a bare `&` inside a tool call was orphaned when the
#   launching shell returned, then raced the next clean build).
#
#   A build is NEVER legitimately concurrent with another (the gen chain runs one
#   step at a time), so any build binary still RUNNING when a new build starts is
#   an orphan. Kill it first -> a clean, single-writer build every time.
# ─────────────────────────────────────────────────────────────────────────────
function Stop-StrayCompilers {
    # `clang` belongs here: an orphaned LINK holds nova_p*.exe/.ll open just as surely as an
    # orphaned compile does. Its omission was the second half of the 2026-09-06 diagnosis below --
    # killing the stray gen*/nova_p* processes alone still left clang children racing the build.
    foreach ($name in @('gen3_test','gen4','gen4_test','gen5','gen6','gen2_move','nova_p1','nova_p2','nova_p3','clang')) {
        Get-Process -Name $name -ErrorAction SilentlyContinue |
            Where-Object { $_.Id -ne $PID } |
            ForEach-Object { try { Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue } catch {} }
    }
}

# ─────────────────────────────────────────────────────────────────────────────
# ⛔ CONCURRENT-RUN GUARD (added 2026-09-06 after it cost hours of misdiagnosis).
#
# THE BUG THIS PREVENTS: the lib//std/ sync below runs UNCONDITIONALLY every time ANY script
# dot-sources this file. Two concurrent runs therefore each rewrite the very library files the
# other is compiling against. The symptom is NOT an obvious clash -- it is a compile exiting
# -1 with `timedout=False`, at a DIFFERENT pass each time, never reproducible by hand.
#
# On 2026-09-06 that signature was misdiagnosed three times (stray process, then disk, then
# Invoke-Timed) before the real cause was found: an orphaned `nova_ci.ps1` (started by an agent
# that died mid-verification) still running 20+ minutes later, silently corrupting every
# reconverge attempt. It also inflated a perf-tracking bench by 168%, which read as a real
# regression.
#
# So: refuse to start rather than produce a wrong answer. A build that declines to run is a
# minor annoyance; a build that reports a false FAIL (or a false PASS) costs hours and, worse,
# can be believed. Set NOVA_ALLOW_CONCURRENT=1 to override deliberately.
# ─────────────────────────────────────────────────────────────────────────────
function Assert-NoConcurrentNovaRun {
    param([string]$Context = "this script")
    if ($env:NOVA_ALLOW_CONCURRENT -eq "1") { return }
    $me = $PID
    $others = @(Get-CimInstance Win32_Process -Filter "Name='powershell.exe' OR Name='pwsh.exe'" -ErrorAction SilentlyContinue |
        Where-Object {
            $_.ProcessId -ne $me -and
            $_.CommandLine -and
            ($_.CommandLine -match 'nova_ci\.ps1' -or $_.CommandLine -match '_bootstrap_reconverge\.ps1' -or $_.CommandLine -match '_run_final_regression\.ps1')
        })
    if ($others.Count -gt 0) {
        Write-Host ""
        Write-Host "  ##########################################################################"
        Write-Host "  ##  REFUSING TO START: another NOVA build/CI run is already active.     ##"
        Write-Host "  ##  Concurrent runs REWRITE each other's `$NOVA_HOME/lib and /std while  ##"
        Write-Host "  ##  the other is compiling against them -- the result is a compile that ##"
        Write-Host "  ##  exits -1 at a random pass and does NOT reproduce by hand.           ##"
        Write-Host "  ##########################################################################"
        foreach ($o in $others) {
            $cl = $o.CommandLine
            if ($cl.Length -gt 120) { $cl = $cl.Substring(0, 120) + "..." }
            Write-Host ("  active: PID " + $o.ProcessId + "  " + $cl)
        }
        Write-Host ""
        Write-Host "  Wait for it to finish, or kill it, then re-run $Context."
        Write-Host "  (Override deliberately with NOVA_ALLOW_CONCURRENT=1 if you know why.)"
        Write-Host ""
        exit 1
    }
}

# Resolve clang once; callers pass $ClangPath to Invoke-Timed.
$ClangPath = (Get-Command clang -ErrorAction SilentlyContinue).Source
if (-not $ClangPath) { $ClangPath = "clang" }

# Standard link flags for NOVA runtime (ws2_32 for networking, advapi32 for crypto)
$NovaLinkFlags = "-lws2_32 -ladvapi32"

# ─────────────────────────────────────────────────────────────────────────────
# Forge home + toolchain stdlib install.
#
# The framework's canonical source lives at <repo>/forge/forge.nova (its own home, NOT
# test_programs scratch). Every compile site that sources this file resolves `import forge`
# from the INSTALLED toolchain copy at $NOVA_HOME/lib/forge.nova -- exactly as an out-of-tree
# `nova new` project does -- so the regression itself continuously validates install-time
# module resolution (the download-and-go path). NOVA_HOME is the nova-compiler dir (this
# script's parent). forge/forge.nova is synced -> $NOVA_HOME/lib on every run so the installed
# copy can never drift from the single canonical source.
# ─────────────────────────────────────────────────────────────────────────────
$env:NOVA_HOME  = (Resolve-Path "$PSScriptRoot\..").Path
$ForgeSrcDir = Join-Path $env:NOVA_HOME "..\forge"
$LibDir      = Join-Path $env:NOVA_HOME "lib"
if (Test-Path $ForgeSrcDir) {
    New-Item -ItemType Directory -Force -Path $LibDir | Out-Null
    # Install EVERY framework module (forge.nova, forge_db.nova, ...) so an app resolves any of
    # them from $NOVA_HOME/lib -- exactly as an out-of-tree `nova new` project would.
    Get-ChildItem -Path $ForgeSrcDir -Filter *.nova | ForEach-Object {
        Copy-Item -Force $_.FullName (Join-Path $LibDir $_.Name)
    }
}
# Prism (framework #5, presentation layer) -- same install-time contract as forge/ -> lib/
# above. The canonical source lives at <repo>/prism/, organized into subfolders for humans,
# but every module keeps a globally-unique `prism_*` filename (PRISM_STATUS.md: "folders are
# for humans, prefixes are for the linker") -- so unlike std/ below, which mirrors
# hierarchically, prism/ is FLATTENED into $NOVA_HOME/lib alongside forge, letting
# `import prism_ansi` (etc.) resolve from any project exactly like `import forge_html`.
$PrismSrcDir = Join-Path $env:NOVA_HOME "..\prism"
if (Test-Path $PrismSrcDir) {
    New-Item -ItemType Directory -Force -Path $LibDir | Out-Null
    Get-ChildItem -Path $PrismSrcDir -Recurse -Filter *.nova | ForEach-Object {
        Copy-Item -Force $_.FullName (Join-Path $LibDir $_.Name)
    }
}
# NOVA STANDARD LIBRARY (LOCK-1): the std/ tree (<repo>/std, organized by category) is bundled into the
# toolchain at $NOVA_HOME/std, preserving subdirs, so `import std/<category>/<name>` resolves from any
# project -- exactly like forge/ -> lib/, but hierarchical. forge/ is the FRAMEWORK; std/ is the LANGUAGE.
$StdSrcDir = Join-Path $env:NOVA_HOME "..\std"
$StdDstDir = Join-Path $env:NOVA_HOME "std"
if (Test-Path $StdSrcDir) {
    $stdRoot = (Resolve-Path $StdSrcDir).Path
    Get-ChildItem -Path $StdSrcDir -Recurse -Filter *.nova | ForEach-Object {
        $rel = $_.FullName.Substring($stdRoot.Length).TrimStart('\','/')
        $dst = Join-Path $StdDstDir $rel
        New-Item -ItemType Directory -Force -Path (Split-Path $dst) | Out-Null
        Copy-Item -Force $_.FullName $dst
    }
}
# (The curated pure-NOVA stdlib modules — corex/strx/nat/prng/bitset/pvecx/graphemex/etc. — were migrated
#  from the flat test_programs/ dump into the hierarchical std/ tree by category. They now sync recursively
#  above (std/ -> $NOVA_HOME/std) and resolve as `import std/<category>/<name>`. The old flat-list + lib/
#  install is gone; the "dedicated stdlib source dir" the previous cleanup-comment anticipated is now std/.)
