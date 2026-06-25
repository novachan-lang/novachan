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
    foreach ($name in @('gen3_test','gen4','gen4_test','gen5','gen6','gen2_move','nova_p1','nova_p2','nova_p3')) {
        Get-Process -Name $name -ErrorAction SilentlyContinue |
            Where-Object { $_.Id -ne $PID } |
            ForEach-Object { try { Stop-Process -Id $_.Id -Force -ErrorAction SilentlyContinue } catch {} }
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
# Install the curated pure-NOVA STDLIB modules into $NOVA_HOME/lib so an out-of-tree project resolves
# `import corex` (etc.) from the toolchain -- exactly like an installed standard library. Canonical source
# lives in test_programs/ for now (validated in-tree by the *_lib_test.nova suite); a dedicated stdlib/
# source dir is a future cleanup. Each is a pure library (its self-test main is ignored on import).
$StdlibModules = @('corex','strx','urlx','csvx','bignum','complexnum','rational','basex','setops','matrixx','collx','getin','prng','uuid','bitset','graphemex','pvecx','coro')
New-Item -ItemType Directory -Force -Path $LibDir | Out-Null
foreach ($m in $StdlibModules) {
    $src = Join-Path $PSScriptRoot "$m.nova"
    if (Test-Path $src) { Copy-Item -Force $src (Join-Path $LibDir "$m.nova") }
}
