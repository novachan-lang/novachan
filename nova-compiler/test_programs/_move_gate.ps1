# 2.8 MOVE SEMANTICS GATE — general move(x)
#
# The design this pins down, and why:
#   * move(x) is the IDENTITY at runtime. It emits no call and no copy, because moving a value
#     changes only who may NAME it. Asserting zero runtime calls is the whole point -- the moment
#     move() costs an instruction, it stops being worth having over a comment.
#   * Using x after move(x) is E1003, ALWAYS -- not behind a flag. The developer wrote the word, so
#     they are asking for the guarantee; a guarantee you cannot rely on by default is not one.
#   * send(ch, x) moving x stays OPT-IN (NOVA_TRACK8=1). Thousands of existing lines send-then-read,
#     and making that a hard error by default would break working programs. This gate asserts BOTH
#     halves of that asymmetry, because the tempting "simplification" is to make them uniform.
#   * The diagnostic must name WHICH construct moved the value and WHERE. The first version blamed
#     send() for every move including move()'s own, which sends the reader to the wrong line.
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$root = (Resolve-Path "..").Path
$env:NOVA_NO_CACHE = "1"
$env:NOVA_HOME = $root
$nova = if (Test-Path "$PSScriptRoot\_gen4.exe") { (Resolve-Path "$PSScriptRoot\_gen4.exe").Path } else { (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path }
$fail = 0
$env:NOVA_TRACK8 = ""

# --- 1. positive: correct programs still build and produce correct values -------------------
Remove-Item -Force _move_ok.exe -ErrorAction SilentlyContinue
$b = Invoke-Timed -FilePath $nova -Arguments "build _move_ok.nova" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
if ($b.ExitCode -ne 0) { Write-Host "  FAIL positive build"; $fail++ }
else {
    $r = Invoke-Timed -FilePath (Resolve-Path ".\_move_ok.exe").Path -Arguments "" -TimeoutMs 60000
    $o = $r.StdOut.Trim() -replace "`r",""
    foreach ($want in @("sum=6","boxed=2","c=7","s2=hello","s1b=again")) {
        if ($o -match [regex]::Escape($want)) { Write-Host "  ok   $want" }
        else { Write-Host "  FAIL missing '$want' in output"; $fail++ }
    }
}

# --- 2. ZERO COST -------------------------------------------------------------------------
Remove-Item -Force _move_ok.ll -ErrorAction SilentlyContinue
$e = Invoke-Timed -FilePath $nova -Arguments "_move_ok.nova _move_ok.ll" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
if (-not (Test-Path _move_ok.ll)) { Write-Host "  FAIL emit"; $fail++ }
else {
    $n = @(Get-Content _move_ok.ll | Where-Object { $_ -match "nova_rt_move" }).Count
    if ($n -eq 0) { Write-Host "  ok   move() emits NO runtime call (zero cost)" }
    else { Write-Host "  FAIL move() emitted $n runtime call(s) -- it must be the identity"; $fail++ }
}

# --- 3. use-after-move is rejected BY DEFAULT (no flag) -----------------------------------
$u = Invoke-Timed -FilePath $nova -Arguments "build _move_uaf_neg.nova" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
$uo = ($u.StdOut + $u.StdErr)
if ($u.ExitCode -ne 0 -and $uo -match "E1003") {
    Write-Host "  ok   use-after-move rejected with no flag set"
    if ($uo -match "moved by move\(\)") { Write-Host "  ok   diagnostic names move() as the cause" }
    else { Write-Host "  FAIL diagnostic does not name move() (it used to blame send())"; $fail++ }
} else { Write-Host "  FAIL use-after-move NOT rejected by default (exit=$($u.ExitCode))"; $fail++ }

# --- 4. double move is rejected -----------------------------------------------------------
$d = Invoke-Timed -FilePath $nova -Arguments "build _move_twice_neg.nova" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
$do_ = ($d.StdOut + $d.StdErr)
if ($d.ExitCode -ne 0 -and $do_ -match "moved twice") { Write-Host "  ok   double move rejected" }
else { Write-Host "  FAIL double move NOT rejected (exit=$($d.ExitCode))"; $fail++ }

# --- 5. CROSS-MODULE (the rule that has caught most half-done features here) ---------------
Remove-Item -Force _move_xmod.exe -ErrorAction SilentlyContinue
$x = Invoke-Timed -FilePath $nova -Arguments "build _move_xmod.nova" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
if ($x.ExitCode -eq 0) {
    $xr = Invoke-Timed -FilePath (Resolve-Path ".\_move_xmod.exe").Path -Arguments "" -TimeoutMs 60000
    if ($xr.StdOut.Trim() -eq "n=4") { Write-Host "  ok   move() across a module boundary" }
    else { Write-Host "  FAIL cross-module value '$($xr.StdOut.Trim())' want 'n=4'"; $fail++ }
} else { Write-Host "  FAIL cross-module build"; $fail++ }

# --- 6. send() stays OPT-IN: allowed by default, rejected under NOVA_TRACK8=1 --------------
$env:NOVA_TRACK8 = ""
$s1 = Invoke-Timed -FilePath $nova -Arguments "build _move_send_neg.nova" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
if ($s1.ExitCode -eq 0) { Write-Host "  ok   send-then-use still compiles by default (back-compat)" }
else { Write-Host "  FAIL send-then-use broke without the flag -- that breaks existing programs"; $fail++ }

$env:NOVA_TRACK8 = "1"
$s2 = Invoke-Timed -FilePath $nova -Arguments "build _move_send_neg.nova" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
$s2o = ($s2.StdOut + $s2.StdErr)
if ($s2.ExitCode -ne 0 -and $s2o -match "E1003") {
    Write-Host "  ok   send-then-use rejected under NOVA_TRACK8=1"
    if ($s2o -match "moved by send\(\)") { Write-Host "  ok   diagnostic names send() as the cause" }
    else { Write-Host "  FAIL diagnostic does not name send()"; $fail++ }
} else { Write-Host "  FAIL NOVA_TRACK8=1 no longer enforces send-moves"; $fail++ }
$env:NOVA_TRACK8 = ""

Remove-Item -Force _move_ok.ll -ErrorAction SilentlyContinue
if ($fail -gt 0) { Write-Host "MOVE-GATE FAIL ($fail)"; exit 1 }
Write-Host "MOVE-GATE OK (14/14 assertions)"
exit 0
