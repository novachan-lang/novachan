#requires -Version 5
<#
NOVA continuous benchmark harness.

Compiles each program under bench/programs/, runs it once, parses the
'BENCH <name> elapsed_ms=<n>' line and the rc_stats_dump() output, and
appends one JSON record per (bench, mode) to bench/history.jsonl.

Run with:
    powershell -ExecutionPolicy Bypass -File bench/run_bench.ps1
#>

param(
    [string]$Mode = "default",     # default | no_track8 | track8_drop | auto_arena
    [switch]$NoCommitAppend,        # skip writing to history.jsonl (use for one-off runs)
    [int]$Repeat = 3                # samples per bench; the MINIMUM is recorded (see below)
)

# WHY BEST-OF-N: this harness used to record a SINGLE run, which made history.jsonl only as
# trustworthy as the quietest moment on the host. On 2026-08-07 a float_array_sum sample taken
# while six agents + the full CI were saturating the CPU landed at 431 ms against a 178 ms
# baseline -- a phantom "+142% REGRESSION" that cost real investigation time and, worse, was
# APPENDED to history, where it would have poisoned every later comparison against that commit.
# Re-measured on a quiet host the same binary ran 150/153/152 ms.
# Noise on a benchmark is one-directional: contention, scheduling and cache eviction can only
# ever make a run SLOWER, never faster. So min-of-N is the cleanest available estimator of true
# cost -- the same reason hyperfine and Google Benchmark report a minimum/trimmed statistic
# rather than a lone sample. N=3 costs a few extra seconds across 6 sub-second benches.

$ErrorActionPreference = "Stop"

# --- Resolve paths -------------------------------------------------------
$repoRoot   = Split-Path -Parent $PSScriptRoot
$novaDir    = Join-Path $repoRoot "nova-compiler\test_programs"
$compiler   = Join-Path $novaDir  "gen3_test.exe"
$runtime    = Join-Path $novaDir  "..\compiler\nova_runtime.c"
$histFile   = Join-Path $PSScriptRoot "history.jsonl"
$progDir    = Join-Path $PSScriptRoot "programs"

. (Join-Path $novaDir "_proc_util.ps1")

if (-not (Test-Path $compiler)) {
    Write-Error "compiler not found: $compiler"
    exit 1
}

# --- Mode -> env -----------------------------------------------------------
$env:NOVA_NO_TRACK8 = $null
$env:NOVA_T8_DROP   = $null
$env:NOVA_AUTO_ARENA = $null
switch ($Mode) {
    "no_track8"   { $env:NOVA_NO_TRACK8 = "1" }
    "track8_drop" { $env:NOVA_T8_DROP   = "1" }
    "auto_arena"  { $env:NOVA_AUTO_ARENA = "1" }
    "default"     { }
    default       { Write-Error "unknown mode: $Mode"; exit 1 }
}

# --- Commit info ---------------------------------------------------------
$commit = (git -C $repoRoot rev-parse --short HEAD).Trim()
$ts = [DateTime]::UtcNow.ToString("yyyy-MM-ddTHH:mm:ssZ")

# --- Discover benches ----------------------------------------------------
$benches = Get-ChildItem -Path $progDir -Filter "*.nova" | ForEach-Object { $_.BaseName }
Write-Host "NOVA bench harness -- commit $commit, mode $Mode"
Write-Host "  $($benches.Count) bench(es) to run"
Write-Host ""

$totalPass = 0
$totalFail = 0
$results   = @()

foreach ($name in $benches) {
    $srcPath = Join-Path $progDir "$name.nova"
    $llPath  = Join-Path $progDir "$name.ll"
    $exePath = Join-Path $progDir "$name.exe"

    Remove-Item -Force $llPath, $exePath -ErrorAction SilentlyContinue

    # Compile
    $cr = Invoke-Timed -FilePath $compiler -Arguments "$name.nova" -TimeoutMs 60000 -WorkingDirectory $progDir
    if ($cr.TimedOut -or $cr.ExitCode -ne 0) {
        Write-Host "FAIL compile: $name (exit=$($cr.ExitCode))"
        $totalFail++
        continue
    }

    # Link (avoid in-string quote escaping; pass via single-quoted parts)
    $quoteExe = [char]34 + $exePath + [char]34
    $quoteLl  = [char]34 + $llPath  + [char]34
    $quoteRt  = [char]34 + $runtime + [char]34
    $linkArgs = "-O2 -o $quoteExe $quoteLl $quoteRt $NovaLinkFlags -D_CRT_SECURE_NO_WARNINGS -w"
    $lr = Invoke-Timed -FilePath $ClangPath -Arguments $linkArgs -TimeoutMs 60000 -WorkingDirectory $progDir
    if ($lr.TimedOut -or $lr.ExitCode -ne 0) {
        Write-Host "FAIL link: $name (exit=$($lr.ExitCode))"
        $totalFail++
        continue
    }

    # Run $Repeat times and keep the FASTEST sample (see the best-of-N note in the param block).
    $samples = @()
    $rr      = $null
    $runFailed = $false
    for ($rep = 1; $rep -le $Repeat; $rep++) {
        $thisRun = Invoke-Timed -FilePath $exePath -Arguments "" -TimeoutMs 30000 -WorkingDirectory $progDir
        if ($thisRun.TimedOut -or $thisRun.ExitCode -ne 0) {
            Write-Host "FAIL run: $name (exit=$($thisRun.ExitCode), sample $rep/$Repeat)"
            $runFailed = $true
            break
        }
        $sLine = ($thisRun.StdOut -split "`n") | Where-Object { $_ -like "BENCH *" } | Select-Object -First 1
        if (-not $sLine) {
            Write-Host "FAIL parse: $name (no BENCH line, sample $rep/$Repeat)"
            $runFailed = $true
            break
        }
        if ($sLine -match "elapsed_ms=(\d+)") { $samples += [int]$Matches[1] }
        # Keep the LAST successful run's streams for the rc_stats parse below. RC counts are
        # deterministic for a given binary, so any sample is equivalent for that purpose.
        $rr = $thisRun
    }
    if ($runFailed -or $samples.Count -eq 0) {
        $totalFail++
        Remove-Item -Force $llPath, $exePath -ErrorAction SilentlyContinue
        continue
    }

    $elapsed = ($samples | Measure-Object -Minimum).Minimum
    $spread  = ($samples | Measure-Object -Maximum).Maximum - $elapsed
    # A wide spread means the host was busy; the min is still sound, but say so out loud rather
    # than silently recording a number whose provenance nobody can reconstruct later.
    $sampleNote = "min of $($samples.Count) [$($samples -join ', ')]"
    if ($elapsed -gt 0 -and $spread * 100 / $elapsed -gt 25) {
        $sampleNote += " NOISY-HOST(spread ${spread}ms)"
    }

    # Parse RC stats from stderr
    $rcInc = 0
    $rcDec = 0
    foreach ($eln in ($rr.StdErr -split "`n")) {
        if ($eln -match "rc_inc calls:\s*(\d+)") { $rcInc = [int64]$Matches[1] }
        if ($eln -match "rc_dec calls:\s*(\d+)") { $rcDec = [int64]$Matches[1] }
    }

    $rec = [pscustomobject]@{
        ts         = $ts
        commit     = $commit
        bench      = $name
        mode       = $Mode
        elapsed_ms = $elapsed
        rc_inc     = $rcInc
        rc_dec     = $rcDec
    }
    $results += $rec

    Write-Host "PASS $name  elapsed_ms=$elapsed  rc_inc=$rcInc  rc_dec=$rcDec  ($sampleNote)"
    $totalPass++

    Remove-Item -Force $llPath, $exePath -ErrorAction SilentlyContinue
}

Write-Host ""
Write-Host "=== $totalPass PASS, $totalFail FAIL ==="

# --- Append history ------------------------------------------------------
if (-not $NoCommitAppend -and $results.Count -gt 0) {
    foreach ($r in $results) {
        $json = $r | ConvertTo-Json -Compress
        Add-Content -Path $histFile -Value $json
    }
    Write-Host "appended $($results.Count) record(s) to bench/history.jsonl"
}

# Reset env
$env:NOVA_NO_TRACK8 = $null
$env:NOVA_T8_DROP   = $null
$env:NOVA_AUTO_ARENA = $null

if ($totalFail -gt 0) { exit 1 }
exit 0
