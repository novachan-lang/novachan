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
    [switch]$NoCommitAppend         # skip writing to history.jsonl (use for one-off runs)
)

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

    # Run
    $rr = Invoke-Timed -FilePath $exePath -Arguments "" -TimeoutMs 30000 -WorkingDirectory $progDir
    if ($rr.TimedOut -or $rr.ExitCode -ne 0) {
        Write-Host "FAIL run: $name (exit=$($rr.ExitCode))"
        $totalFail++
        Remove-Item -Force $llPath, $exePath -ErrorAction SilentlyContinue
        continue
    }

    # Parse 'BENCH <name> elapsed_ms=<n>' from stdout
    $line = ($rr.StdOut -split "`n") | Where-Object { $_ -like "BENCH *" } | Select-Object -First 1
    if (-not $line) {
        Write-Host "FAIL parse: $name (no BENCH line)"
        $totalFail++
        Remove-Item -Force $llPath, $exePath -ErrorAction SilentlyContinue
        continue
    }

    $elapsed = 0
    if ($line -match "elapsed_ms=(\d+)") {
        $elapsed = [int]$Matches[1]
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

    Write-Host "PASS $name  elapsed_ms=$elapsed  rc_inc=$rcInc  rc_dec=$rcDec"
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
