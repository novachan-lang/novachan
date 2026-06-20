# S4 Stage-0 mechanical guard: assert every NovaList raw element READ in the C runtime is
# kind=2-safe. A NovaList may carry raw int64 (kind=1) or raw double (kind=2) inline; reading
# data[i] as a value and letting it escape WITHOUT an elem_kind check or a nova_list_deopt is the
# exact type-confusion that caused the kind=2 cascade+revert. This gate FAILS the build on any new
# unguarded reader, converting the "negative proof obligation" into a mechanical check.
#
# Rule: any function whose body reads a NovaList element (l->data[i] / list->data[i] / input->data[i]
# used as a VALUE, not a pure LHS write) MUST contain `elem_kind` or `nova_list_deopt` somewhere in
# its body, OR be on the allowlist below (with a justification).
#
# Usage: powershell -ExecutionPolicy Bypass -File _kind2_rawread_guard.ps1   (exit 1 on violation)

$ErrorActionPreference = 'Stop'
$src = Join-Path $PSScriptRoot 'output/nova_runtime.c'
$lines = Get-Content $src

# Functions allowed to read NovaList data WITHOUT a guard, each with a reason.
$allow = @{
  'nova_rt_list_print' = 'DEAD: not emitted by the compiler, not called anywhere (verified); prints raw ints for debug only'
}

# raw element READ of a NovaList (l/list/input ->data[..]) used as a value.
$readRe   = '(\bl->data\[|\blist->data\[|\binput->data\[)'
# a pure LHS write "X->data[..] = ..." with no data read on the RHS (writing into the slot is not an escape).
$writeRe  = '->data\[[^\]]*\]\s*=\s*[^=]'
$rhsReadRe= '=\s*[^=]*->data\['
$guardRe  = '(elem_kind|nova_list_deopt)'
$hdrRe    = '^(static\s+)?[A-Za-z_][A-Za-z0-9_ \*]*\b([A-Za-z_][A-Za-z0-9_]*)\s*\([^;]*\)\s*\{?\s*$'

$depth = 0
$curFn = ''
$fnBody = New-Object System.Collections.Generic.List[string]
$violations = New-Object System.Collections.Generic.List[string]
$pendingFn = ''

function Analyze($fn, [System.Collections.Generic.List[string]]$body) {
  if (-not $fn) { return }
  $text = ($body -join "`n")
  $hasRead = $false
  foreach ($l in $body) {
    if ($l -match $readRe) {
      $isWrite = ($l -match $writeRe) -and -not ($l -match $rhsReadRe)
      if (-not $isWrite) { $hasRead = $true; break }
    }
  }
  if (-not $hasRead) { return }
  if ($text -match $guardRe) { return }
  if ($allow.ContainsKey($fn)) { return }
  $script:violations.Add("UNGUARDED kind=2 raw read in '$fn' (no elem_kind / nova_list_deopt in body)")
}

foreach ($line in $lines) {
  if ($depth -eq 0 -and $line -match $hdrRe) { $pendingFn = $Matches[2] }
  $opens  = ([regex]::Matches($line, '\{')).Count
  $closes = ([regex]::Matches($line, '\}')).Count
  $prevDepth = $depth
  $depth += $opens - $closes
  if ($prevDepth -eq 0 -and $depth -ge 1 -and $pendingFn) {
    $curFn = $pendingFn; $pendingFn = ''; $fnBody.Clear()
  }
  if ($curFn) { $fnBody.Add($line) }
  if ($prevDepth -ge 1 -and $depth -le 0 -and $curFn) {
    Analyze $curFn $fnBody
    $curFn = ''; $fnBody.Clear()
  }
}

if ($violations.Count -gt 0) {
  Write-Host "FAIL: kind=2 raw-read guard found $($violations.Count) unguarded site(s):" -ForegroundColor Red
  $violations | ForEach-Object { Write-Host "  $_" }
  exit 1
}
Write-Host "PASS: all NovaList element reads are kind=2-guarded (elem_kind/deopt) or allowlisted." -ForegroundColor Green
exit 0
