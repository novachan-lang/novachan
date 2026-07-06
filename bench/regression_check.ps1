#requires -Version 5
<#
Read bench/history.jsonl, compare the last two distinct commits per bench,
and fail if any bench got more than $Threshold% slower.

Run after run_bench.ps1 in CI.
#>

param(
    [int]$Threshold = 20,     # percent slower allowed
    [int]$MinCompareMs = 100  # skip benches with baseline < this (too noisy to compare reliably)
)

$ErrorActionPreference = "Stop"

$histFile = Join-Path $PSScriptRoot "history.jsonl"
if (-not (Test-Path $histFile)) {
    Write-Host "no history yet, nothing to compare"
    exit 0
}

$records = Get-Content $histFile | ForEach-Object { $_ | ConvertFrom-Json }
if ($records.Count -lt 2) {
    Write-Host "only $($records.Count) record(s), need at least 2 to compare"
    exit 0
}

# Group by (bench, mode), pick the two most-recent distinct commits
$groups = $records | Group-Object -Property bench, mode
$failures = @()

foreach ($g in $groups) {
    $sorted = $g.Group | Sort-Object ts -Descending
    $distinctCommits = @()
    $byCommit = @{}
    foreach ($r in $sorted) {
        if (-not $byCommit.ContainsKey($r.commit)) {
            $byCommit[$r.commit] = $r
            $distinctCommits += $r.commit
            if ($distinctCommits.Count -ge 2) { break }
        }
    }

    if ($distinctCommits.Count -lt 2) {
        Write-Host "$($g.Name): only 1 commit, skipping"
        continue
    }

    $curr = $byCommit[$distinctCommits[0]]
    $prev = $byCommit[$distinctCommits[1]]

    # Skip benches whose baseline time is too small to compare reliably: at <100 ms, host scheduling
    # jitter (esp. under memory pressure) dominates and a wobble like 42->80 ms reads as "+90%" even
    # with the identical compiler. Comparing noise produces false regressions. (Fix the SIGNAL by
    # making such benches iterate more; until then, don't flag them.)
    if ($prev.elapsed_ms -lt $MinCompareMs) {
        Write-Host "skip $($curr.bench) ($($curr.mode)): baseline $($prev.elapsed_ms) ms < ${MinCompareMs} ms (too noisy to compare)"
        continue
    }

    $delta = 0
    if ($prev.elapsed_ms -gt 0) {
        $delta = [int]((($curr.elapsed_ms - $prev.elapsed_ms) * 100) / $prev.elapsed_ms)
    }

    $sign = if ($delta -ge 0) { "+" } else { "" }
    $msg  = "$($curr.bench) ($($curr.mode)) {0}{1}% ({2} ms -> {3} ms) [{4}..{5}]" -f $sign, $delta, $prev.elapsed_ms, $curr.elapsed_ms, $prev.commit, $curr.commit

    if ($delta -gt $Threshold) {
        Write-Host "FAIL $msg"
        $failures += $msg
    } else {
        Write-Host "OK   $msg"
    }
}

if ($failures.Count -gt 0) {
    Write-Host ""
    Write-Host "REGRESSION: $($failures.Count) bench(es) > $Threshold% slower"
    exit 1
}

Write-Host ""
Write-Host "all benches within $Threshold% of previous commit"
exit 0
