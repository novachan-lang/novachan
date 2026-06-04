param([string]$Out, [string]$Dest)
$j = (Get-Content -Raw $Out | ConvertFrom-Json).result
$lines = New-Object System.Collections.Generic.List[string]
$lines.Add("# NOVA - Verified Remaining Features (2026-06-02 audit)")
$lines.Add("")
$lines.Add("Generated from the 22-agent verification audit: every PARTIAL/MISSING scorecard row was checked")
$lines.Add("against the REAL self-hosted nova_compiler.nova + output/nova_runtime.c + test_programs (NOT the stale")
$lines.Add("CORE_COMPLETENESS table, NOT the dead Java/Kotlin bootstrap). Only genuinely-remaining items")
$lines.Add("(verified PARTIAL or MISSING) are listed; 24 stale 'missing' rows were corrected to DONE and dropped.")
$lines.Add("Tier order = implementation priority. Batch log of what has LANDED is in memory")
$lines.Add("(project_complete_all_remaining.md). Execute one gated batch at a time; do not ask, self-prioritize")
$lines.Add("toward what makes NOVA special/powerful (feedback_autonomous_high_impact.md).")
$lines.Add("")
$all = @()
foreach ($c in $j) { foreach ($f in $c.features) { if ($f.verified_status -ne 'DONE') { $all += [pscustomobject]@{cat=$c.category; f=$f} } } }
$lines.Add("**Total verified-remaining: " + $all.Count + "**")
$lines.Add("")
foreach ($tier in @('table-stakes','signature','important')) {
    $items = $all | Where-Object { $_.f.tier -eq $tier } | Sort-Object @{e={$_.f.effort}}
    $lines.Add("## " + $tier + " (" + $items.Count + ")")
    $lines.Add("")
    foreach ($it in $items) {
        $f = $it.f
        $lines.Add("### " + $f.name + "  *(" + $it.cat + ")*")
        $lines.Add("- **status:** " + $f.verified_status + " | **effort:** " + $f.effort)
        if ($f.gap) { $lines.Add("- **gap:** " + $f.gap) }
        if ($f.impl_sketch) { $lines.Add("- **NOVA approach:** " + $f.impl_sketch) }
        if ($f.evidence) { $lines.Add("- **evidence (as of audit):** " + $f.evidence) }
        $lines.Add("")
    }
}
Set-Content -Path $Dest -Value $lines -Encoding UTF8
Write-Host ("Wrote " + $all.Count + " remaining features to " + $Dest)
