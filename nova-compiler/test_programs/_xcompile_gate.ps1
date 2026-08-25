# 5.4 CROSS-COMPILATION GATE
#
# What NOVA actually promises here, and the gate exists to keep the promise honest:
#   * `--target <t>` emits IR with the CORRECT triple and datalayout for every supported target.
#   * That IR lowers to a VALID relocatable object for the target, from any host, with NO sysroot --
#     the IR is already fully lowered, so there is no C and nothing to #include.
#   * A full cross LINK is NOT promised: nova_runtime.c needs target libc headers and NOVA bundles
#     no sysroots (Zig ships ~45 MB of headers to do this; Go sidesteps it with no libc at all).
#     Attempting one must FAIL FAST with the real reason, not with `'stdio.h' file not found` from
#     deep inside the runtime.
#
# The last assertion is the one that matters most for developer experience, and it is the one a
# refactor is most likely to silently undo -- so it is checked as explicitly as the codegen.
$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"
$root = (Resolve-Path "..").Path
$env:NOVA_NO_CACHE = "1"
$env:NOVA_HOME = $root
$nova = if (Test-Path "$PSScriptRoot\_gen4.exe") { (Resolve-Path "$PSScriptRoot\_gen4.exe").Path } else { (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path }
$fail = 0
$src = "_xcompile_probe.nova"

@'
fn main()
    let xs = [1, 2, 3]
    let t = 0
    for x in xs
        t = t + x
    print("sum=" + str(t))
'@ | Set-Content -NoNewline -Encoding ascii "$PSScriptRoot\$src"

# target name -> (expected triple, expected datalayout fragment)
$targets = @(
    @("linux",        "x86_64-unknown-linux-gnu",  "e-m:e"),
    @("linux-arm64",  "aarch64-unknown-linux-gnu", "e-m:e"),
    @("macos",        "x86_64-apple-darwin",       "e-m:o"),
    @("macos-arm64",  "aarch64-apple-darwin",      "e-m:o"),
    @("windows",      "x86_64-pc-windows-msvc",    "e-m:w"),
    @("wasm",         "wasm32-unknown-unknown",    "e-m:e")
)

foreach ($t in $targets) {
    $name = $t[0]; $triple = $t[1]; $dlfrag = $t[2]
    $ll = "_xc_$name.ll"
    Remove-Item -Force $ll -ErrorAction SilentlyContinue
    $e = Invoke-Timed -FilePath $nova -Arguments "compile --target $name -o `"$ll`" `"$src`"" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
    if ($e.ExitCode -ne 0 -or -not (Test-Path $ll)) {
        Write-Host "  FAIL $name : emit exit=$($e.ExitCode)"; $fail++; continue
    }
    $head = Get-Content $ll -TotalCount 40
    if (-not ($head | Where-Object { $_ -match [regex]::Escape("target triple = `"$triple`"") })) {
        Write-Host "  FAIL $name : wrong/missing triple (want $triple)"; $fail++; continue
    }
    if (-not ($head | Where-Object { $_ -match 'target datalayout' -and $_ -match [regex]::Escape($dlfrag) })) {
        # A wrong datalayout is the dangerous case: it still compiles, and then miscomputes
        # struct offsets and alignment on the target. Assert it, do not assume it follows the triple.
        Write-Host "  FAIL $name : datalayout missing '$dlfrag' (endian/mangling mismatch)"; $fail++; continue
    }
    # wasm has its own toolchain path; object lowering here is for the native targets.
    if ($name -eq "wasm") { Write-Host "  ok   $name : triple + datalayout"; continue }
    $obj = "_xc_$name.o"
    Remove-Item -Force $obj -ErrorAction SilentlyContinue
    $o = Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 -w --target=$triple `"$ll`" -o `"$obj`"" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
    if ($o.ExitCode -ne 0 -or -not (Test-Path $obj)) {
        Write-Host "  FAIL $name : IR did not lower to an object"; $fail++; continue
    }
    if ((Get-Item $obj).Length -lt 512) {
        Write-Host "  FAIL $name : object suspiciously small ($((Get-Item $obj).Length)B)"; $fail++; continue
    }
    Write-Host "  ok   $name : triple + datalayout + object"
}

# --- a cross LINK must fail FAST and say why ------------------------------------------------
$r = Invoke-Timed -FilePath $nova -Arguments "build --target linux `"$src`"" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
$out = ($r.StdOut + $r.StdErr)
if ($r.ExitCode -eq 0) {
    Write-Host "  FAIL cross-link SUCCEEDED unexpectedly -- if sysroots are now bundled, update this gate"; $fail++
} elseif ($out -match "no sysroot for that target") {
    Write-Host "  ok   cross-link refused with the real reason"
    if ($out -match "stdio\.h") {
        Write-Host "  FAIL diagnostic still leaks the raw clang 'stdio.h' error"; $fail++
    } else {
        Write-Host "  ok   raw clang header error no longer surfaces"
    }
    if ($out -match "--obj") { Write-Host "  ok   diagnostic points at the route that works" }
    else { Write-Host "  FAIL diagnostic does not mention --obj"; $fail++ }
} else {
    Write-Host "  FAIL cross-link failed for the WRONG reason:"; $fail++
    ($out.Trim() -split "`r?`n") | Select-Object -First 3 | ForEach-Object { Write-Host "        $_" }
}

# --- `nova emit --obj` end-to-end ----------------------------------------------------------
Remove-Item -Force "_xcompile_probe.o" -ErrorAction SilentlyContinue
$eo = Invoke-Timed -FilePath $nova -Arguments "emit `"$src`" --target macos-arm64 --obj" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
if ($eo.ExitCode -eq 0 -and (Test-Path "_xcompile_probe.o")) {
    Write-Host "  ok   nova emit --obj produced a macOS-arm64 object"
} else {
    Write-Host "  FAIL nova emit --obj (exit=$($eo.ExitCode))"; $fail++
}

# --- the NATIVE path must be untouched -----------------------------------------------------
Remove-Item -Force "_xcompile_probe.exe" -ErrorAction SilentlyContinue
$nb = Invoke-Timed -FilePath $nova -Arguments "build `"$src`"" -TimeoutMs 240000 -WorkingDirectory $PSScriptRoot
if ($nb.ExitCode -eq 0 -and (Test-Path "_xcompile_probe.exe")) {
    $run = Invoke-Timed -FilePath (Resolve-Path ".\_xcompile_probe.exe").Path -Arguments "" -TimeoutMs 60000
    if ($run.StdOut.Trim() -eq "sum=6") { Write-Host "  ok   native build still correct (sum=6)" }
    else { Write-Host "  FAIL native output '$($run.StdOut.Trim())' want 'sum=6'"; $fail++ }
} else {
    Write-Host "  FAIL native build broke (exit=$($nb.ExitCode))"; $fail++
}

Remove-Item -Force "_xc_*.ll","_xc_*.o","_xcompile_probe.*" -ErrorAction SilentlyContinue
if ($fail -gt 0) { Write-Host "XCOMPILE-GATE FAIL ($fail)"; exit 1 }
Write-Host "XCOMPILE-GATE OK (13/13 assertions)"
exit 0
