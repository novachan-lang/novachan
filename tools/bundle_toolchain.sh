#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────────────────────
# bundle_toolchain.sh — POSIX twin of tools/bundle_toolchain.ps1.
#
# WHY THIS EXISTS (and why it is NOT package_release.sh)
#
# nova-compiler/scripts/package_release.sh builds the SHIPPING archive from a
# downloaded official-LLVM / llvm-mingw release. It is the source of truth for the
# release layout and is driven by .github/workflows/release.yml. This script does not
# reimplement it: `--mode release` DELEGATES to it.
#
# What this adds is the DEV bundle — assembled from the clang already installed on
# this machine, no network, no 400MB download. That is what makes the PATH-scrubbed
# gate (_toolchain_bundle_gate.ps1 on Windows, the same recipe under sh on Linux)
# runnable on a developer machine instead of only on a release candidate.
#
# HONEST LIMIT OF A DEV BUNDLE ON LINUX: official LLVM ships no libc, so a bundle
# built from it still needs the distro's glibc headers + Scrt1.o/crti.o (libc6-dev)
# to link, plus libstdc++/zlib for clang itself. It is PATH-INDEPENDENT (which is
# what the gate proves) but not zero-dependency. Same caveat as the release bundle;
# see project-bundled-toolchain-installer.
#
# LAYOUT — must match what nova_find_clang()/nova_find_runtime()/nova_find_version()
# in nova_compiler.nova probe relative to the nova executable:
#
#   <outdir>/
#     bin/nova
#     compiler/nova_runtime.c
#     lib/                        Forge + Prism modules (flat)
#     std/                        NOVA stdlib, by category
#     toolchains/clang/
#       bin/clang, ld.lld, [clang.cfg], [shared libs]
#       lib/clang/<ver>/include/  builtin headers
#       lib/clang/<ver>/lib/...   compiler-rt builtins
#     VERSION
#
# USAGE
#   tools/bundle_toolchain.sh --out /tmp/nova-dev-bundle
#   tools/bundle_toolchain.sh --mode release --archive ./LLVM-22.1.8-Linux-X64.tar.xz \
#                             --out ./dist/nova-linux-x64.tar.xz
#   tools/bundle_toolchain.sh --mode release --fetch --out ./dist/nova-linux-x64.tar.xz
# ─────────────────────────────────────────────────────────────────────────────
set -euo pipefail

mode="dev"
out=""
nova_exe=""
clang_path="${NOVA_CLANG:-}"
archive=""
do_fetch=0
arch="x64"
all_linkers=0
include_sanitizers=0
force=0

# Version pins — kept in sync with .github/workflows/release.yml (the source of truth).
# Used ONLY by --fetch. Nothing here touches the network without that flag.
LLVM_VERSION="22.1.8"
LLVM_MINGW_VERSION="20260616"
FETCH_URL_LINUX="https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/LLVM-${LLVM_VERSION}-Linux-X64.tar.xz"
FETCH_URL_MACOS="https://github.com/llvm/llvm-project/releases/download/llvmorg-${LLVM_VERSION}/LLVM-${LLVM_VERSION}-macOS-ARM64.tar.xz"
FETCH_URL_WINDOWS="https://github.com/mstorsjo/llvm-mingw/releases/download/${LLVM_MINGW_VERSION}/llvm-mingw-${LLVM_MINGW_VERSION}-ucrt-x86_64.zip"

say()  { printf '[bundle] %s\n' "$*"; }
die()  { printf '[bundle] ERROR: %s\n' "$*" >&2; exit 1; }

while [ "$#" -gt 0 ]; do
    case "$1" in
        --mode)     mode="$2"; shift 2 ;;
        --out)      out="$2"; shift 2 ;;
        --nova)     nova_exe="$2"; shift 2 ;;
        --clang)    clang_path="$2"; shift 2 ;;
        --archive)  archive="$2"; shift 2 ;;
        --arch)     arch="$2"; shift 2 ;;
        --fetch)    do_fetch=1; shift ;;
        --all-linkers) all_linkers=1; shift ;;
        --include-sanitizers) include_sanitizers=1; shift ;;
        --force)    force=1; shift ;;
        -h|--help)  sed -n '2,45p' "$0"; exit 0 ;;
        *) die "unknown argument: $1" ;;
    esac
done
[ -n "$out" ] || die "--out is required"

script_dir="$(cd "$(dirname "$0")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
compiler_dir="$repo_root/nova-compiler/compiler"
pkg_script="$repo_root/nova-compiler/scripts/package_release.sh"

case "$(uname -s)" in
    Darwin) platform="macos"; fetch_url="$FETCH_URL_MACOS" ;;
    Linux)  platform="linux"; fetch_url="$FETCH_URL_LINUX" ;;
    *)      platform="windows"; fetch_url="$FETCH_URL_WINDOWS" ;;
esac

tree_size() { du -sk "$1" 2>/dev/null | awk '{printf "%.1f MB", $1/1024}'; }

# ─── release mode: delegate, do not duplicate ────────────────────────────────
if [ "$mode" = "release" ]; then
    [ -f "$pkg_script" ] || die "package_release.sh not found at $pkg_script"
    if [ "$do_fetch" -eq 1 ]; then
        [ -n "$archive" ] || archive="$(mktemp -d)/toolchain-src.${fetch_url##*.}"
        say "NETWORK FETCH (explicit --fetch): $fetch_url"
        command -v curl >/dev/null 2>&1 || die "--fetch needs curl"
        curl -fsSL -o "$archive" "$fetch_url"
        say "downloaded -> $archive"
    fi
    [ -n "$archive" ] || die "release mode needs --archive <path>, or --fetch to download the pinned archive ($fetch_url)"
    [ -f "$archive" ] || die "archive not found: $archive"
    if [ -z "$nova_exe" ]; then
        for c in "$repo_root/nova-compiler/nova" "$repo_root/nova-compiler/test_programs/gen3_test"; do
            [ -x "$c" ] && nova_exe="$c" && break
        done
    fi
    [ -n "$nova_exe" ] && [ -f "$nova_exe" ] || die "nova executable not found; pass --nova <path>"
    say "delegating to package_release.sh ..."
    exec "$pkg_script" "$platform" "$arch" "$nova_exe" "$archive" "$out"
fi

# ─── dev mode ────────────────────────────────────────────────────────────────
if [ -z "$nova_exe" ]; then
    for c in "$repo_root/nova-compiler/nova" "$repo_root/nova-compiler/test_programs/gen3_test" "$repo_root/nova-compiler/test_programs/gen3_test.exe"; do
        [ -f "$c" ] && nova_exe="$c" && break
    done
fi
[ -n "$nova_exe" ] && [ -f "$nova_exe" ] || die "nova executable not found; build it first or pass --nova <path>"

if [ -z "$clang_path" ] || [ ! -f "$clang_path" ]; then
    clang_path="$(command -v clang || true)"
fi
[ -n "$clang_path" ] && [ -f "$clang_path" ] || die "no source clang found. Pass --clang, set NOVA_CLANG, or put clang on PATH.
       A dev bundle can only be assembled from a clang that already exists here;
       use --mode release --fetch to build from a downloaded toolchain instead."

# Resolve through symlinks: on Linux `clang` is normally a symlink to clang-<N>, and we
# want the REAL binary's directory so siblings (lld, .cfg files) are found.
real_clang="$(readlink -f "$clang_path" 2>/dev/null || echo "$clang_path")"
src_bin="$(dirname "$real_clang")"
say "source clang : $clang_path -> $real_clang"

# clang derives its resource dir from its OWN binary path (<bindir>/../lib/clang/<ver>),
# so ask it rather than guessing the version, and reproduce the same relative position.
resource_dir="$("$clang_path" -print-resource-dir 2>/dev/null | head -1 || true)"
[ -n "$resource_dir" ] && [ -d "$resource_dir" ] || die "clang -print-resource-dir gave no usable path ('$resource_dir'); without it the bundle cannot compile anything ('stddef.h' not found)"
res_ver="$(basename "$resource_dir")"
say "resource dir : $resource_dir  (version dir '$res_ver')"

tc_root="$out/toolchains/clang"
tc_bin="$tc_root/bin"
tc_lib="$tc_root/lib/clang/$res_ver"

# Freshness: re-staging hundreds of MB on every gate run buys nothing.
staged_clang="$tc_bin/$(basename "$clang_path")"
if [ "$force" -eq 0 ] && [ -f "$staged_clang" ] && [ ! "$real_clang" -nt "$staged_clang" ]; then
    say "bundle already current at $out ($(tree_size "$out")) — use --force to re-stage"
    exit 0
fi

mkdir -p "$out/bin" "$out/compiler" "$tc_bin" "$tc_lib"
say "staging into $out ..."

cp "$nova_exe" "$out/bin/nova"; chmod +x "$out/bin/nova"
cp "$compiler_dir/nova_runtime.c" "$out/compiler/nova_runtime.c"
[ -f "$repo_root/nova-compiler/VERSION" ] && cp "$repo_root/nova-compiler/VERSION" "$out/VERSION"

# Forge + Prism flatten into lib/ (globally-unique forge_*/prism_* filenames); std/ keeps
# its category subdirs. Mirrors _proc_util.ps1's install step and package_release.sh.
mkdir -p "$out/lib"
for d in forge prism; do
    if [ -d "$repo_root/$d" ]; then
        find "$repo_root/$d" -name '*.nova' -type f -exec cp {} "$out/lib/" \;
    fi
done
if [ -d "$repo_root/std" ]; then
    mkdir -p "$out/std"
    cp -r "$repo_root/std/." "$out/std/"
fi

# -P preserves symlinks: on Linux bin/clang is a SYMLINK to clang-<N> (271MB). Plain cp
# dereferences it, so the bundle would carry the same 271MB twice once the clang-<N>
# sibling is copied below. Measured, not theoretical (see project-bundled-toolchain-installer).
cp -P "$clang_path" "$tc_bin/"
for f in "$src_bin/"clang-[0-9]*; do
    [ -f "$f" ] && cp "$f" "$tc_bin/"
done

# Which linker does the driver actually name? Ask it. The answer differs by target
# (ld.lld for ELF, lld-link for windows-msvc) and by whether lld shipped at all.
linkers=""
if [ "$all_linkers" -eq 1 ]; then
    linkers="lld ld.lld lld-link wasm-ld"
else
    probe_c="$(mktemp --suffix=.c 2>/dev/null || mktemp)"
    printf 'int main(void){return 0;}\n' > "$probe_c"
    drv="$("$clang_path" -### -o /dev/null "$probe_c" 2>&1 || true)"
    rm -f "$probe_c"
    for cand in ld.lld lld-link wasm-ld lld; do
        case "$drv" in *"$cand"*) linkers="$cand"; break ;; esac
    done
    if [ -z "$linkers" ]; then
        say "WARNING: this clang drives the SYSTEM linker (/usr/bin/ld), not lld."
        say "         Bundling ld.lld anyway and pinning it via clang.cfg so the bundle"
        say "         does not depend on binutils being installed."
        linkers="ld.lld"
    fi
fi
say "linker(s)    : $linkers"
# On Unix every lld personality is a SYMLINK to one ~200MB `lld`, which dispatches on
# argv[0]. Copy the real binary ONCE, then preserve the symlinks — copying three names
# without -P writes three identical 200MB files (measured: 400MB of pure duplication).
[ -f "$src_bin/lld" ] && cp "$src_bin/lld" "$tc_bin/" || true
for l in $linkers; do
    [ -e "$src_bin/$l" ] && cp -P "$src_bin/$l" "$tc_bin/" || true
done

# Shared libs clang itself needs. A distro clang links against libLLVM/libclang-cpp;
# official LLVM tarballs are mostly static. Copy whatever of the closure exists.
for pat in 'libLLVM*.so*' 'libclang-cpp.so*' 'libc++.so*' 'libunwind.so*'; do
    for f in "$src_bin"/../lib/$pat; do
        [ -f "$f" ] && cp -P "$f" "$tc_bin/" 2>/dev/null || true
    done
done

# clang config files. llvm-mingw's per-triple .cfg is LOAD-BEARING (-rtlib=compiler-rt
# -unwindlib=libunwind -fuse-ld=lld; llvm-mingw ships no libgcc). Official LLVM ships
# none and its driver reaches for /usr/bin/ld — i.e. a silent binutils dependency — so
# if none were copied, write one pinning the lld we just bundled.
cfg_copied=0
for c in "$src_bin/"*.cfg; do
    [ -f "$c" ] && cp "$c" "$tc_bin/" && cfg_copied=1
done
if [ "$cfg_copied" -eq 0 ]; then
    printf -- '-fuse-ld=lld\n' > "$tc_bin/clang.cfg"
    say "wrote toolchains/clang/bin/clang.cfg (-fuse-ld=lld) — pins the bundled lld"
fi

# Resource dir: the builtin headers are mandatory (no stddef.h => nothing compiles).
cp -r "$resource_dir/include" "$tc_lib/"
if [ -d "$resource_dir/lib" ]; then
    cp -r "$resource_dir/lib" "$tc_lib/"
    case "$arch" in
        x64)   keep_arch="x86_64"; drop_archs="i386 aarch64 arm armhf" ;;
        arm64) keep_arch="aarch64"; drop_archs="i386 x86_64 arm armhf" ;;
        *) die "no known compiler-rt arch suffix for arch '$arch'" ;;
    esac
    # Trim in descending order of measured payload: flang_rt (the Fortran runtime — 64MB
    # in a stock LLVM 22 install, and NOVA emits no Fortran), fuzzer/stats instrumentation
    # NOVA never passes a flag for, sanitizers unless asked, then foreign architectures.
    find "$tc_lib/lib" -type f -name 'flang_rt*' -delete 2>/dev/null || true
    find "$tc_lib/lib" -type f \( -name '*fuzzer*' -o -name '*stats*' \) -delete 2>/dev/null || true
    if [ "$include_sanitizers" -eq 0 ]; then
        find "$tc_lib/lib" -type f \( -name '*asan*' -o -name '*ubsan*' -o -name '*tsan*' -o -name '*msan*' -o -name '*profile*' \) -delete 2>/dev/null || true
    fi
    for a in $drop_archs; do
        find "$tc_lib/lib" -type f -name "*[-.]${a}[-.]*" ! -name "*${keep_arch}*" -delete 2>/dev/null || true
    done
    find "$tc_lib/lib" -type d -empty -delete 2>/dev/null || true
fi

say "bundle staged: $out"
say "TOTAL SIZE   : $(tree_size "$out")"
for part in bin compiler lib std toolchains/clang/bin toolchains/clang/lib; do
    [ -d "$out/$part" ] && printf '[bundle]   %-24s %s\n' "$part" "$(tree_size "$out/$part")"
done
say "verify with: \"$out/bin/nova\" toolchain status"
