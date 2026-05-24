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

# Resolve clang once; callers pass $ClangPath to Invoke-Timed.
$ClangPath = (Get-Command clang -ErrorAction SilentlyContinue).Source
if (-not $ClangPath) { $ClangPath = "clang" }

# Standard link flags for NOVA runtime (ws2_32 for networking, advapi32 for crypto)
$NovaLinkFlags = "-lws2_32 -ladvapi32"
