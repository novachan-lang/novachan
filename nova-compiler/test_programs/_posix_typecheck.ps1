# POSIX + OpenSSL TYPE-CHECK, run locally in a Linux container.
#
# WHY THIS EXISTS. Large parts of nova_runtime.c are guarded by BOTH `#else` of `#ifdef _WIN32`
# AND `#ifdef NOVA_HAVE_OPENSSL`. On this Windows dev box neither is active, so that code was
# never compiled locally -- not by the arc, not by a syntax check, not by anything. It could only
# be compiled in CI, 90 minutes away.
#
# The cost of that gap, measured: a call to `SSL_set1_ip_asc` -- a function that DOES NOT EXIST in
# OpenSSL, only X509_VERIFY_PARAM_set1_ip_asc does -- was written, committed and pushed. Modern
# clang treats an implicit function declaration as a hard error, so it took down 20 of 25 CI jobs,
# and the failure surfaced as the unreadable message "runtime pre-compile FAILED" because Actions
# logs are 403 without a token. Diagnosing one undefined symbol cost a full CI cycle.
#
# ANY local compile of that branch would have caught it in seconds. This is that compile.
#
# SKIPS CLEANLY when Docker is unavailable, so it never blocks an arc on a machine without it --
# but when Docker IS up, it turns a 90-minute round trip into about a minute.
Set-Location $PSScriptRoot

$img  = "nova-posix-check:1"
$repo = (Resolve-Path "$PSScriptRoot\..\..").Path

# --- is Docker usable? -----------------------------------------------------------------------
$null = & docker info --format '{{.ServerVersion}}' 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  SKIP posix type-check: Docker daemon not available (start Docker Desktop to enable)"
    exit 0
}

# --- build the toolchain image once ----------------------------------------------------------
$null = & docker image inspect $img 2>&1
if ($LASTEXITCODE -ne 0) {
    Write-Host "  building $img (one time, ~1 min)..."
    $df = @"
FROM ubuntu:24.04
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update -qq && apt-get install -y -qq clang libssl-dev && rm -rf /var/lib/apt/lists/*
"@
    $tmp = Join-Path $env:TEMP "nova_posix_check_ctx"
    New-Item -ItemType Directory -Force -Path $tmp | Out-Null
    Set-Content -Path (Join-Path $tmp "Dockerfile") -Value $df -Encoding ascii
    & docker build -q -t $img $tmp 2>&1 | Select-Object -Last 1 | Out-Null
    if ($LASTEXITCODE -ne 0) { Write-Host "  SKIP posix type-check: image build failed"; exit 0 }
}

# MSYS_NO_PATHCONV stops Git Bash rewriting the container-side /src into a Windows path.
$env:MSYS_NO_PATHCONV = "1"

# TWO configurations, because the bug that prompted this lived in the intersection: the OpenSSL
# block sits inside the POSIX branch, so only "POSIX *and* OpenSSL" reaches it. The no-OpenSSL
# build is kept too -- that is what a user without libssl-dev compiles, and it must also work.
$fail = 0
foreach ($cfg in @(
    @{ name = "POSIX + OpenSSL"; flags = "-DNOVA_HAVE_OPENSSL" },
    @{ name = "POSIX, no OpenSSL"; flags = "" }
)) {
    $out = & docker run --rm -v "${repo}:/src" -w /src/nova-compiler/compiler $img `
             clang -fsyntax-only $($cfg.flags) -w nova_runtime.c 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "  PASS  $($cfg.name)"
    } else {
        Write-Host "  FAIL  $($cfg.name)"
        @($out) | Where-Object { $_ -match 'error' } | Select-Object -First 6 | ForEach-Object { Write-Host "        $_" }
        $fail++
    }
}

# The wasm carve is the third build of the same translation unit and drifts the same way -- it
# #includes nova_runtime.c wholesale under a freestanding shim. It needs no container (clang
# cross-compiles to wasm32 natively), but it belongs in the same check for the same reason.
Push-Location "$PSScriptRoot\..\compiler"
$w = & clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -ferror-limit=200 `
        -c nova_runtime_wasm.c -o "$env:TEMP\_wasm_typecheck.o" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "  PASS  wasm32 freestanding carve"
} else {
    Write-Host "  FAIL  wasm32 freestanding carve"
    @($w) | Where-Object { $_ -match 'error:' } | Select-Object -First 6 | ForEach-Object { Write-Host "        $_" }
    $fail++
}
Remove-Item "$env:TEMP\_wasm_typecheck.o" -Force -ErrorAction SilentlyContinue
Pop-Location

if ($fail -gt 0) { Write-Host "  POSIX type-check: $fail configuration(s) FAILED"; exit 1 }
Write-Host "  POSIX type-check: all 3 configurations compile"
exit 0
