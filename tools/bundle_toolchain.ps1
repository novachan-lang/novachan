<#
-----------------------------------------------------------------------------
 bundle_toolchain.ps1 -- assemble a self-contained NOVA distribution tree.

 WHY THIS EXISTS (and why it is NOT package_release.sh)

 `nova-compiler/scripts/package_release.sh` already builds the SHIPPING archive:
 it takes a downloaded official-LLVM / llvm-mingw release archive, trims it to
 what NOVA actually invokes, and tars/zips the result. It is driven by
 .github/workflows/release.yml and is the source of truth for the release layout.
 This script does NOT reimplement it -- in `-Mode release` it DELEGATES to it.

 What was missing, and what this script adds, is the DEV bundle: a bundle
 assembled from the clang ALREADY INSTALLED on this machine, with no network
 access and no 400MB download. Two things need that:

   1. `_toolchain_bundle_gate.ps1` -- the gate that proves `nova build` works with
      every clang/LLVM directory scrubbed out of PATH. Without a locally
      buildable bundle, that claim could only ever be checked by hand on a
      release candidate, which is how it stayed unproven for months.
   2. A developer who wants to test install-relative resolution changes without
      waiting on a tagged release.

 HONEST LIMIT OF A DEV BUNDLE ON WINDOWS: a stock LLVM Windows install targets
 x86_64-pc-windows-msvc, so its clang needs MSVC's CRT + the Windows SDK to
 link. clang finds those by probing the registry and standard install paths --
 NOT via PATH -- so a dev bundle is genuinely PATH-INDEPENDENT (which is exactly
 what the gate proves) but it is NOT zero-dependency. Only the release bundle,
 built from llvm-mingw with its bundled UCRT sysroot, is zero-dependency. Do not
 conflate the two.

 LAYOUT PRODUCED -- identical to package_release.sh, because nova_find_clang() /
 nova_find_runtime() / nova_find_version() in nova_compiler.nova probe exactly
 these paths relative to the nova executable:

   <OutDir>/
     bin/nova.exe
     compiler/nova_runtime.c
     lib/                        Forge + Prism modules (flat)
     std/                        NOVA stdlib, by category
     toolchains/clang/
       bin/clang.exe, lld-link.exe, [*.cfg], [runtime DLLs]
       lib/clang/<ver>/include/  builtin headers (stddef.h, ...)
       lib/clang/<ver>/lib/...   compiler-rt builtins
     VERSION

 USAGE
   # Dev bundle from the local clang install (no network):
   tools/bundle_toolchain.ps1 -OutDir C:\tmp\nova-dev-bundle

   # Release bundle (delegates to package_release.sh; needs bash + an archive):
   tools/bundle_toolchain.ps1 -Mode release -Archive .\llvm-mingw-...zip `
                              -OutDir .\dist\nova-windows-x64.zip

   # Same, but let the script download the PINNED archive first (opt-in):
   tools/bundle_toolchain.ps1 -Mode release -Fetch -OutDir .\dist\nova-windows-x64.zip
-----------------------------------------------------------------------------
#>
[CmdletBinding()]
param(
    # Dev mode: directory to stage the bundle into. Release mode: the output archive path.
    [Parameter(Mandatory = $true)][string]$OutDir,

    [ValidateSet('dev', 'release')][string]$Mode = 'dev',

    # The nova binary to bundle. Defaults to the repo's current self-hosted compiler.
    [string]$NovaExe,

    # Source clang. Defaults to $env:NOVA_CLANG, then `clang` on PATH.
    [string]$ClangPath,

    # release mode: a already-downloaded official-LLVM / llvm-mingw release archive.
    [string]$Archive,

    # release mode: EXPLICIT opt-in to download the pinned archive over the network.
    # Nothing in this script touches the network unless this switch is passed.
    [switch]$Fetch,

    [ValidateSet('x64', 'arm64')][string]$Arch = 'x64',

    # Copy every lld personality (lld, ld.lld, lld-link, wasm-ld) rather than just the
    # one clang's driver actually names for the host target. On Windows each is an
    # independent ~71MB binary, so this costs ~210MB. Needed only if you intend to
    # cross-link ELF or build wasm32 from the bundle.
    [switch]$AllLinkers,

    # Keep asan/ubsan/profile compiler-rt libs (NOVA's own gates run sanitized builds;
    # a plain `nova build` never needs them).
    [switch]$IncludeSanitizers,

    # Re-stage even if the bundle looks current.
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
Set-StrictMode -Version Latest

$RepoRoot     = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$CompilerDir  = Join-Path $RepoRoot 'nova-compiler\compiler'
$VersionFile  = Join-Path $RepoRoot 'nova-compiler\VERSION'
$PkgScript    = Join-Path $RepoRoot 'nova-compiler\scripts\package_release.sh'

# Version pins -- kept in sync with .github/workflows/release.yml, which is the source
# of truth. Only used by -Fetch.
$LlvmVersion       = '22.1.8'
$LlvmMingwVersion  = '20260616'
$FetchUrlWindows   = "https://github.com/mstorsjo/llvm-mingw/releases/download/$LlvmMingwVersion/llvm-mingw-$LlvmMingwVersion-ucrt-x86_64.zip"
$FetchUrlLinux     = "https://github.com/llvm/llvm-project/releases/download/llvmorg-$LlvmVersion/LLVM-$LlvmVersion-Linux-X64.tar.xz"

function Say  { param([string]$m) Write-Host "[bundle] $m" }
function Die  { param([string]$m) Write-Host "[bundle] ERROR: $m" -ForegroundColor Red; exit 1 }

function Get-TreeSize {
    param([string]$Path)
    if (-not (Test-Path $Path)) { return 0 }
    $m = Get-ChildItem -LiteralPath $Path -Recurse -File -Force -ErrorAction SilentlyContinue |
         Measure-Object -Property Length -Sum
    if ($null -eq $m.Sum) { return 0 }
    return [int64]$m.Sum
}
function Format-Size { param([int64]$b) '{0:N1} MB' -f ($b / 1MB) }

# --- release mode: delegate, do not duplicate --------------------------------
if ($Mode -eq 'release') {
    if (-not (Test-Path $PkgScript)) { Die "package_release.sh not found at $PkgScript" }
    $bash = (Get-Command bash -ErrorAction SilentlyContinue)
    if (-not $bash) { Die "release mode needs bash (Git Bash / WSL) to run package_release.sh" }

    if ($Fetch) {
        if (-not $Archive) { $Archive = Join-Path $env:TEMP 'nova-toolchain-src.zip' }
        Say "NETWORK FETCH (explicit -Fetch): $FetchUrlWindows"
        Say "  (Linux equivalent, for reference: $FetchUrlLinux)"
        Invoke-WebRequest -Uri $FetchUrlWindows -OutFile $Archive -UseBasicParsing
        Say "downloaded -> $Archive ($(Format-Size (Get-Item $Archive).Length))"
    }
    if (-not $Archive) {
        Die "release mode needs -Archive <llvm-mingw or official-LLVM archive>, or -Fetch to download the pinned one ($FetchUrlWindows)"
    }
    if (-not (Test-Path $Archive)) { Die "archive not found: $Archive" }

    if (-not $NovaExe) { $NovaExe = Join-Path $RepoRoot 'nova-compiler\test_programs\gen3_test.exe' }
    if (-not (Test-Path $NovaExe)) { Die "nova executable not found: $NovaExe" }

    # package_release.sh takes MSYS-style paths; hand it what bash will understand.
    function To-Posix { param([string]$p) '/' + ($p -replace ':', '' -replace '\\', '/') }
    $args = @(
        (To-Posix (Resolve-Path $PkgScript).Path)
        'windows'
        $Arch
        (To-Posix (Resolve-Path $NovaExe).Path)
        (To-Posix (Resolve-Path $Archive).Path)
        (To-Posix $OutDir)
    )
    Say "delegating to package_release.sh ..."
    & bash @args
    if ($LASTEXITCODE -ne 0) { Die "package_release.sh failed with exit code $LASTEXITCODE" }
    Say "release archive written: $OutDir"
    exit 0
}

# --- dev mode ----------------------------------------------------------------
if (-not $NovaExe) { $NovaExe = Join-Path $RepoRoot 'nova-compiler\test_programs\gen3_test.exe' }
if (-not (Test-Path $NovaExe)) { Die "nova executable not found: $NovaExe (build gen3_test.exe first, or pass -NovaExe)" }

if (-not $ClangPath) {
    if ($env:NOVA_CLANG -and (Test-Path $env:NOVA_CLANG)) { $ClangPath = $env:NOVA_CLANG }
    else {
        $c = Get-Command clang -ErrorAction SilentlyContinue
        if ($c) { $ClangPath = $c.Source }
    }
}
if (-not $ClangPath -or -not (Test-Path $ClangPath)) {
    Die "no source clang found. Pass -ClangPath, set NOVA_CLANG, or put clang on PATH.`n" +
        "       A dev bundle can only be assembled from a clang that already exists on this machine;`n" +
        "       use -Mode release -Fetch to build from a downloaded toolchain instead."
}
$ClangPath = (Resolve-Path $ClangPath).Path
$SrcBin    = Split-Path -Parent $ClangPath
Say "source clang : $ClangPath"

# clang computes its resource dir (builtin headers + compiler-rt) RELATIVE TO ITS OWN
# BINARY: <bindir>/../lib/clang/<ver>. Ask clang rather than guessing the version, then
# reproduce the same relative position inside the bundle so the copied clang finds it.
$ResourceDir = (& $ClangPath -print-resource-dir 2>$null | Select-Object -First 1)
if (-not $ResourceDir -or -not (Test-Path $ResourceDir)) {
    Die "clang -print-resource-dir gave no usable path ('$ResourceDir'). Without the resource dir the bundle cannot compile anything ('stddef.h' not found)."
}
$ResourceDir = (Resolve-Path $ResourceDir).Path
$ResVer      = Split-Path -Leaf $ResourceDir
Say "resource dir : $ResourceDir  (version dir '$ResVer')"

# Which linker will the bundled clang invoke? Ask the driver instead of assuming: the
# answer differs by target (lld-link for *-windows-msvc, ld.lld for mingw/ELF) and by
# whether the install ships lld at all. If clang names MSVC's own link.exe, the bundle
# would silently depend on a Visual Studio dir being on PATH -- worth knowing up front.
$LinkerNames = New-Object System.Collections.Generic.List[string]
$probeC   = Join-Path $env:TEMP ("nova_bundle_probe_{0}.c" -f $PID)
$probeOut = Join-Path $env:TEMP ("nova_bundle_probe_{0}.exe" -f $PID)
Set-Content -LiteralPath $probeC -Value 'int main(void){return 0;}' -Encoding ASCII
try {
    # clang -### writes the driver trace to STDERR. Under $ErrorActionPreference='Stop' a
    # native command's stderr lines are promoted to terminating ErrorRecords, which would
    # abort the script on a perfectly successful probe -- so relax EAP for this one call.
    $savedEap = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $drv = (& $ClangPath -### -o $probeOut $probeC 2>&1 | ForEach-Object { $_.ToString() }) -join "`n"
    $ErrorActionPreference = $savedEap
    $global:LASTEXITCODE = 0
    foreach ($cand in @('lld-link', 'ld.lld', 'wasm-ld', 'lld')) {
        if ($drv -match [regex]::Escape($cand)) { $LinkerNames.Add($cand); break }
    }
    if ($LinkerNames.Count -eq 0 -and $drv -match 'link\.exe') {
        Say "WARNING: this clang drives MSVC's link.exe, not lld. The bundle will need"
        Say "         link.exe reachable at build time; it is NOT self-contained."
    }
} finally {
    $ErrorActionPreference = 'Stop'
    Remove-Item -LiteralPath $probeC, $probeOut -Force -ErrorAction SilentlyContinue
}
if ($AllLinkers) { $LinkerNames = [System.Collections.Generic.List[string]]@('lld', 'ld.lld', 'lld-link', 'wasm-ld') }
Say "linker(s)    : $(if ($LinkerNames.Count) { $LinkerNames -join ', ' } else { '<none detected>' })"

# --- stage -------------------------------------------------------------------
$TcRoot = Join-Path $OutDir 'toolchains\clang'
$TcBin  = Join-Path $TcRoot 'bin'
$TcLib  = Join-Path $TcRoot ("lib\clang\$ResVer")

# Cheap freshness check: if the bundled clang is already at least as new as the source
# clang and the same size, re-staging 200MB buys nothing. The gate runs this on every
# invocation, so skipping matters.
$stagedClang = Join-Path $TcBin (Split-Path -Leaf $ClangPath)
if (-not $Force -and (Test-Path $stagedClang)) {
    $s = Get-Item $ClangPath; $d = Get-Item $stagedClang
    if ($d.Length -eq $s.Length -and $d.LastWriteTimeUtc -ge $s.LastWriteTimeUtc) {
        Say "bundle already current at $OutDir ($(Format-Size (Get-TreeSize $OutDir))) -- use -Force to re-stage"
        exit 0
    }
}

foreach ($d in @($OutDir, (Join-Path $OutDir 'bin'), (Join-Path $OutDir 'compiler'), $TcBin, $TcLib)) {
    New-Item -ItemType Directory -Force -Path $d | Out-Null
}

Say "staging into $OutDir ..."

# nova binary -- always named nova.exe in a bundle, whatever the source gen was called.
Copy-Item -Force -LiteralPath $NovaExe -Destination (Join-Path $OutDir 'bin\nova.exe')
Copy-Item -Force -LiteralPath (Join-Path $CompilerDir 'nova_runtime.c') -Destination (Join-Path $OutDir 'compiler\nova_runtime.c')
if (Test-Path $VersionFile) { Copy-Item -Force -LiteralPath $VersionFile -Destination (Join-Path $OutDir 'VERSION') }

# Forge + Prism are flattened into lib/ (globally-unique forge_*/prism_* filenames);
# std/ keeps its category subdirs. This mirrors _proc_util.ps1's install step, which is
# what an out-of-tree `nova new` project resolves against.
$libDst = Join-Path $OutDir 'lib'
New-Item -ItemType Directory -Force -Path $libDst | Out-Null
foreach ($srcName in @('forge', 'prism')) {
    $src = Join-Path $RepoRoot $srcName
    if (Test-Path $src) {
        Get-ChildItem -LiteralPath $src -Recurse -Filter *.nova -File |
            ForEach-Object { Copy-Item -Force -LiteralPath $_.FullName -Destination (Join-Path $libDst $_.Name) }
    }
}
$stdSrc = Join-Path $RepoRoot 'std'
if (Test-Path $stdSrc) {
    $stdDst  = Join-Path $OutDir 'std'
    $stdRoot = (Resolve-Path $stdSrc).Path
    Get-ChildItem -LiteralPath $stdSrc -Recurse -Filter *.nova -File | ForEach-Object {
        $rel = $_.FullName.Substring($stdRoot.Length).TrimStart('\', '/')
        $dst = Join-Path $stdDst $rel
        New-Item -ItemType Directory -Force -Path (Split-Path -Parent $dst) | Out-Null
        Copy-Item -Force -LiteralPath $_.FullName -Destination $dst
    }
}

# clang itself, plus any version-suffixed sibling it execs into. A bare `clang.exe` is
# sometimes a thin driver that re-execs clang-<N>.exe (llvm-mingw does this); copying only
# the wrapper yields "clang-22: No such file or directory" at link time.
Copy-Item -Force -LiteralPath $ClangPath -Destination $TcBin
Get-ChildItem -LiteralPath $SrcBin -Filter 'clang-*' -File -ErrorAction SilentlyContinue |
    Where-Object { $_.BaseName -match '^clang-\d+$' } |
    ForEach-Object { Copy-Item -Force -LiteralPath $_.FullName -Destination $TcBin }

foreach ($l in $LinkerNames) {
    foreach ($ext in @('.exe', '')) {
        $p = Join-Path $SrcBin ($l + $ext)
        if (Test-Path -LiteralPath $p -PathType Leaf) { Copy-Item -Force -LiteralPath $p -Destination $TcBin; break }
    }
}

# Runtime DLLs. A stock LLVM Windows clang.exe is statically linked and needs none;
# llvm-mingw's is dynamically linked against libLLVM/libclang-cpp/libc++/libunwind.
# Copy whichever of that closure actually exists rather than branching on distro.
foreach ($pat in @('libLLVM*.dll', 'libclang-cpp.dll', 'libc++.dll', 'libunwind.dll', 'libwinpthread-*.dll')) {
    Get-ChildItem -LiteralPath $SrcBin -Filter $pat -File -ErrorAction SilentlyContinue |
        ForEach-Object { Copy-Item -Force -LiteralPath $_.FullName -Destination $TcBin }
}

# clang config files. llvm-mingw's per-triple .cfg is LOAD-BEARING: it supplies
# -rtlib=compiler-rt -unwindlib=libunwind -fuse-ld=lld, without which links die on
# -lgcc (llvm-mingw ships no libgcc). Stock LLVM ships none, and its driver would
# reach for the system linker -- so if none were copied, write one pinning lld, which
# is the whole point of bundling lld in the first place.
$cfgCopied = $false
Get-ChildItem -LiteralPath $SrcBin -Filter '*.cfg' -File -ErrorAction SilentlyContinue |
    ForEach-Object { Copy-Item -Force -LiteralPath $_.FullName -Destination $TcBin; $script:cfgCopied = $true }
if (-not $cfgCopied -and ($LinkerNames.Count -gt 0)) {
    Set-Content -LiteralPath (Join-Path $TcBin 'clang.cfg') -Value '-fuse-ld=lld' -Encoding ASCII -NoNewline
    Say "wrote toolchains/clang/bin/clang.cfg (-fuse-ld=lld) -- pins the bundled lld"
}

# Resource dir: builtin headers are mandatory (no stddef.h => nothing compiles at all).
Copy-Item -Recurse -Force -LiteralPath (Join-Path $ResourceDir 'include') -Destination $TcLib
$resLibSrc = Join-Path $ResourceDir 'lib'
if (Test-Path $resLibSrc) {
    Copy-Item -Recurse -Force -LiteralPath $resLibSrc -Destination $TcLib
    $resLibDst = Join-Path $TcLib 'lib'

    # Trim, in descending order of measured payload:
    #  * flang_rt.* -- the Fortran runtime. 64MB in a stock LLVM 22 Windows install,
    #    four near-identical .lib files. NOVA emits no Fortran; this is pure weight.
    #  * *fuzzer*, *stats* -- opt-in instrumentation NOVA never passes a flag for.
    #  * asan/ubsan/profile -- kept only under -IncludeSanitizers.
    #  * foreign-arch libs -- a bundle is per-arch by construction.
    $keepArch = if ($Arch -eq 'arm64') { 'aarch64' } else { 'x86_64' }
    $dropArch = if ($Arch -eq 'arm64') { @('i386', 'x86_64', 'arm', 'armhf') } else { @('i386', 'aarch64', 'arm', 'armhf') }
    Get-ChildItem -LiteralPath $resLibDst -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
        $n = $_.Name
        $drop = $false
        if ($n -like 'flang_rt*')                            { $drop = $true }
        elseif ($n -match 'fuzzer|stats')                    { $drop = $true }
        elseif (-not $IncludeSanitizers -and $n -match 'asan|ubsan|tsan|msan|profile') { $drop = $true }
        else {
            foreach ($a in $dropArch) {
                if ($n -match "[-\.]$([regex]::Escape($a))[-\.]" -and $n -notmatch [regex]::Escape($keepArch)) { $drop = $true; break }
            }
        }
        if ($drop) { Remove-Item -Force -LiteralPath $_.FullName -ErrorAction SilentlyContinue }
    }
    # Drop directories that became empty, and any sibling target dir that is not ours.
    Get-ChildItem -LiteralPath $resLibDst -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        if (-not (Get-ChildItem -LiteralPath $_.FullName -Recurse -File -ErrorAction SilentlyContinue)) {
            Remove-Item -Recurse -Force -LiteralPath $_.FullName -ErrorAction SilentlyContinue
        }
    }
}

# --- report ------------------------------------------------------------------
$total = Get-TreeSize $OutDir
Say "bundle staged: $OutDir"
Say "TOTAL SIZE   : $(Format-Size $total)"
foreach ($part in @('bin', 'compiler', 'lib', 'std', 'toolchains\clang\bin', 'toolchains\clang\lib')) {
    $p = Join-Path $OutDir $part
    if (Test-Path $p) { Say ("  {0,-24} {1}" -f $part, (Format-Size (Get-TreeSize $p))) }
}
Say "verify with: `"$OutDir\bin\nova.exe`" toolchain status"
exit 0
