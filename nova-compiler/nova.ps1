# NOVA CLI — unified build/test/run/fmt interface
# Usage: nova <command> [args]
#   nova build [file.nova]         Build a NOVA program
#   nova run [file.nova]           Build and run
#   nova test [path]               Run tests (test_*.nova files)
#   nova check [file.nova]         Type-check without building
#   nova fmt [file.nova]           Format source code
#   nova new <name>                Create new project
#   nova clean                     Remove build artifacts
#   nova bench [path]              Run benchmarks
#   nova version                   Show version info

param(
    [Parameter(Position=0)]
    [string]$Command,
    [Parameter(Position=1, ValueFromRemainingArguments=$true)]
    [string[]]$Args
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# ─── Configuration ────────────────────────────────────────────────────
$CompilerExe  = Join-Path $ScriptDir "test_programs\gen3_test.exe"
$CompilerJar  = Join-Path $ScriptDir "build\libs\nova-compiler-0.1.0-all.jar"
$RuntimeSrc   = Join-Path $ScriptDir "test_programs\output\nova_runtime.c"
$SqliteSrc    = Join-Path $ScriptDir "test_programs\output\sqlite3.c"
$CacheDir     = Join-Path $ScriptDir ".nova_cache"
$ClangPath    = "clang"
$DefaultFlags = "-O2 -D_CRT_SECURE_NO_WARNINGS -w"
$LinkLibs     = "-lws2_32 -ladvapi32"
$NovaVersion  = "0.3.0-dev"
# Item #1 — fast inner dev loop: link against a CACHED runtime/sqlite object (compiled once, keyed by
# source SHA) at -O0 by default; --release uses -O2. Was recompiling the 20k-line runtime.c every build
# (~5.8s); cached -O0 link is ~0.3s. -O0 only affects DEV build speed, never correctness.
$script:LinkOpt = "-O0"

# Detect platform
$IsWin = $IsWindows -or ($env:OS -eq 'Windows_NT')
if (-not $IsWin) {
    $LinkLibs = "-lpthread -ldl -lm"
}

# Find compiler
function Get-Compiler {
    if (Test-Path $CompilerExe) {
        return @{ Type = "native"; Path = $CompilerExe }
    }
    if (Test-Path $CompilerJar) {
        $java = Get-Command java -ErrorAction SilentlyContinue
        if ($java) {
            return @{ Type = "jar"; Path = $CompilerJar }
        }
    }
    # Try building from Gradle
    $gradlew = Join-Path $ScriptDir "gradlew.bat"
    if (-not $IsWin) { $gradlew = Join-Path $ScriptDir "gradlew" }
    if (Test-Path $gradlew) {
        Write-Host "Building compiler from source..."
        & $gradlew fatJar --no-daemon -q 2>$null
        if (Test-Path $CompilerJar) {
            return @{ Type = "jar"; Path = $CompilerJar }
        }
    }
    Write-Error "No NOVA compiler found. Place gen3_test.exe in test_programs/ or run gradlew fatJar."
    exit 1
}

function Invoke-NovaCompile {
    param([string]$SourceFile, [string]$WorkDir)
    $compiler = Get-Compiler
    if ($compiler.Type -eq "native") {
        $p = Start-Process -FilePath $compiler.Path -ArgumentList $SourceFile -WorkingDirectory $WorkDir -NoNewWindow -Wait -PassThru -RedirectStandardOutput "$env:TEMP\nova_stdout.txt" -RedirectStandardError "$env:TEMP\nova_stderr.txt"
        $stdout = Get-Content "$env:TEMP\nova_stdout.txt" -Raw -ErrorAction SilentlyContinue
        $stderr = Get-Content "$env:TEMP\nova_stderr.txt" -Raw -ErrorAction SilentlyContinue
        if ($stdout) { Write-Host $stdout }
        return $p.ExitCode
    } else {
        $p = Start-Process -FilePath "java" -ArgumentList "-jar `"$($compiler.Path)`" $SourceFile" -WorkingDirectory $WorkDir -NoNewWindow -Wait -PassThru -RedirectStandardOutput "$env:TEMP\nova_stdout.txt" -RedirectStandardError "$env:TEMP\nova_stderr.txt"
        $stdout = Get-Content "$env:TEMP\nova_stdout.txt" -Raw -ErrorAction SilentlyContinue
        $stderr = Get-Content "$env:TEMP\nova_stderr.txt" -Raw -ErrorAction SilentlyContinue
        if ($stdout) { Write-Host $stdout }
        return $p.ExitCode
    }
}

# Item #1: ensure a cached object for a big C source, compiled ONCE per (source-SHA, opt-level).
# Returns the cached .o path. Rebuilds only when the source content changes (SHA sidecar) — so the
# 20k-line runtime / 9MB sqlite is not recompiled on every `nova run`.
function Ensure-CachedObj {
    param([string]$Src, [string]$Name, [string]$Opt, [string]$ExtraDef = "")
    if (-not (Test-Path $Src)) { return "" }
    if (-not (Test-Path $CacheDir)) { New-Item -ItemType Directory -Path $CacheDir -Force | Out-Null }
    $tag = if ($Opt -like "*-O2*") { "rel" } else { "dev" }
    $obj = Join-Path $CacheDir "$Name`_$tag.o"
    $shaFile = Join-Path $CacheDir "$Name`_$tag.sha"
    # Fast path: if the cached object is newer than the source, the source is unchanged since we built it ->
    # reuse without hashing the (large) source. A modified OR git-checked-out-older source has mtime >= obj,
    # which falls through to the SHA check below (so correctness never depends on mtime alone).
    if (Test-Path $obj) {
        if ((Get-Item $obj).LastWriteTimeUtc -gt (Get-Item $Src).LastWriteTimeUtc) { return $obj }
    }
    $curHash = (Get-FileHash $Src -Algorithm SHA256).Hash
    $cached = if (Test-Path $shaFile) { (Get-Content $shaFile -Raw).Trim() } else { "" }
    if (-not (Test-Path $obj) -or $cached -ne $curHash) {
        Write-Host "Caching $Name ($tag, one-time)..."
        $a = "$Opt -c $ExtraDef `"$Src`" -o `"$obj`" -D_CRT_SECURE_NO_WARNINGS -w"
        $p = Start-Process -FilePath $ClangPath -ArgumentList $a -NoNewWindow -Wait -PassThru -RedirectStandardError "$env:TEMP\nova_obj_err.txt"
        if ($p.ExitCode -ne 0 -or -not (Test-Path $obj)) {
            $e = Get-Content "$env:TEMP\nova_obj_err.txt" -Raw -ErrorAction SilentlyContinue
            Write-Error "Cached object build failed for $Name`: $e"; exit 1
        }
        Set-Content -Path $shaFile -Value $curHash -NoNewline
    }
    return $obj
}

function Invoke-ClangLink {
    param([string]$LlFile, [string]$OutputExe, [string]$WorkDir, [string]$ExtraLibs = "")

    $opt = $script:LinkOpt

    # Extract LINK_LIB comments from .ll file
    $libFlags = ""
    $skipLibs = @()
    if ($IsWin) { $skipLibs = @('m','pthread','dl','rt') }
    Get-Content (Join-Path $WorkDir $LlFile) | Where-Object { $_ -match '^; LINK_LIB: (\S+)' } | ForEach-Object {
        $lib = $matches[1]
        if ($skipLibs -notcontains $lib) { $libFlags += " -l$lib" }
    }

    # Cached runtime object (compiled once, not every build)
    $rtObj = Ensure-CachedObj -Src $RuntimeSrc -Name "nova_runtime" -Opt $opt

    # Cached sqlite object, only when the program uses it
    $extraObj = ""
    if (Select-String -Path (Join-Path $WorkDir $LlFile) -Pattern '@sqlite3_' -Quiet) {
        $sqObj = Ensure-CachedObj -Src $SqliteSrc -Name "sqlite3" -Opt $opt -ExtraDef "-DSQLITE_THREADSAFE=0"
        if ($sqObj) { $extraObj = " `"$sqObj`"" }
    }

    $linkArgs = "$opt -o `"$OutputExe`" `"$LlFile`" `"$rtObj`"$extraObj $LinkLibs$libFlags$ExtraLibs -D_CRT_SECURE_NO_WARNINGS -w"
    $p = Start-Process -FilePath $ClangPath -ArgumentList $linkArgs -WorkingDirectory $WorkDir -NoNewWindow -Wait -PassThru -RedirectStandardError "$env:TEMP\nova_link_err.txt"
    return $p.ExitCode
}

# ─── Commands ─────────────────────────────────────────────────────────

function Nova-Build {
    param([string]$Source)
    if (-not $Source) {
        # Look for main.nova or nova.toml
        if (Test-Path "main.nova") { $Source = "main.nova" }
        elseif (Test-Path "src\main.nova") { $Source = "src\main.nova" }
        else { Write-Error "No source file specified and no main.nova found."; exit 1 }
    }

    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($Source)
    $dir = Split-Path -Parent (Resolve-Path $Source)
    if (-not $dir) { $dir = Get-Location }
    $llFile = "$baseName.ll"
    $exeFile = "$baseName.exe"

    Write-Host "Compiling $Source..."
    $rc = Invoke-NovaCompile -SourceFile ([System.IO.Path]::GetFileName($Source)) -WorkDir $dir
    if ($rc -ne 0) { Write-Error "Compilation failed (exit $rc)"; exit 1 }

    if (-not (Test-Path (Join-Path $dir $llFile))) {
        Write-Error "No .ll file produced"; exit 1
    }

    Write-Host "Linking $llFile..."
    $rc = Invoke-ClangLink -LlFile $llFile -OutputExe $exeFile -WorkDir $dir
    if ($rc -ne 0) {
        $err = Get-Content "$env:TEMP\nova_link_err.txt" -Raw -ErrorAction SilentlyContinue
        if ($err -match "error") { Write-Host $err }
        Write-Error "Link failed"; exit 1
    }

    Remove-Item (Join-Path $dir $llFile) -Force -ErrorAction SilentlyContinue
    $exePath = Join-Path $dir $exeFile
    Write-Host "Built: $exePath ($('{0:N0}' -f (Get-Item $exePath).Length) bytes)"
}

function Nova-Run {
    param([string]$Source)
    Nova-Build -Source $Source

    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($Source)
    if (-not $baseName) { $baseName = "main" }
    $dir = Split-Path -Parent (Resolve-Path $Source -ErrorAction SilentlyContinue)
    if (-not $dir) { $dir = Get-Location }
    $exeFile = Join-Path $dir "$baseName.exe"

    Write-Host ""
    & $exeFile
    $exitCode = $LASTEXITCODE
    Remove-Item $exeFile -Force -ErrorAction SilentlyContinue
    exit $exitCode
}

function Nova-Test {
    param([string]$Path)
    if (-not $Path) { $Path = "." }

    $testFiles = Get-ChildItem -Path $Path -Filter "*_test.nova" -Recurse | Sort-Object Name
    if ($testFiles.Count -eq 0) {
        Write-Host "No test files (*_test.nova) found in $Path"
        exit 0
    }

    Write-Host "=== NOVA Test Suite ==="
    Write-Host "Found $($testFiles.Count) test file(s)"
    Write-Host ""

    $pass = 0; $fail = 0; $failures = @()
    $t0 = [System.Diagnostics.Stopwatch]::StartNew()

    foreach ($tf in $testFiles) {
        $name = $tf.BaseName
        $dir = $tf.DirectoryName
        $llFile = "$name.ll"
        $exeFile = "$name.exe"

        # Compile
        $rc = Invoke-NovaCompile -SourceFile $tf.Name -WorkDir $dir
        if ($rc -ne 0) {
            Write-Host "FAIL compile: $name"
            $failures += "$name (COMPILE)"
            $fail++; continue
        }

        if (-not (Test-Path (Join-Path $dir $llFile))) {
            Write-Host "FAIL compile: $name (no .ll)"
            $failures += "$name (NO .ll)"
            $fail++; continue
        }

        # Link
        $rc = Invoke-ClangLink -LlFile $llFile -OutputExe $exeFile -WorkDir $dir
        if (-not (Test-Path (Join-Path $dir $exeFile))) {
            Write-Host "FAIL link: $name"
            $failures += "$name (LINK)"
            $fail++
            Remove-Item (Join-Path $dir $llFile) -Force -ErrorAction SilentlyContinue
            continue
        }

        # Run
        $exePath = Join-Path $dir $exeFile
        $p = Start-Process -FilePath $exePath -NoNewWindow -Wait -PassThru -RedirectStandardOutput "$env:TEMP\test_out.txt" -RedirectStandardError "$env:TEMP\test_err.txt"
        $stderr = Get-Content "$env:TEMP\test_err.txt" -Raw -ErrorAction SilentlyContinue

        Remove-Item (Join-Path $dir $llFile), $exePath -Force -ErrorAction SilentlyContinue

        if ($p.ExitCode -ne 0) {
            Write-Host "FAIL run: $name (exit=$($p.ExitCode))"
            $failures += "$name (RUN)"
            $fail++
        } elseif ($stderr -match "FAIL assert") {
            Write-Host "FAIL assert: $name"
            $failures += "$name (ASSERT)"
            $fail++
        } else {
            Write-Host "PASS $name"
            $pass++
        }
    }

    $elapsed = $t0.Elapsed
    Write-Host ""
    Write-Host "=== RESULTS: $pass PASS, $fail FAIL in $($elapsed.TotalSeconds.ToString('F1'))s ==="
    if ($failures.Count -gt 0) {
        Write-Host "Failures:"
        foreach ($f in $failures) { Write-Host "  $f" }
        exit 1
    }
}

function Nova-Check {
    param([string]$Source)
    if (-not $Source) { Write-Error "Usage: nova check <file.nova>"; exit 1 }
    $dir = Split-Path -Parent (Resolve-Path $Source)
    if (-not $dir) { $dir = Get-Location }
    $rc = Invoke-NovaCompile -SourceFile ([System.IO.Path]::GetFileName($Source)) -WorkDir $dir
    $llFile = Join-Path $dir ([System.IO.Path]::GetFileNameWithoutExtension($Source) + ".ll")
    Remove-Item $llFile -Force -ErrorAction SilentlyContinue
    if ($rc -eq 0) { Write-Host "OK: $Source type-checks." } else { exit 1 }
}

function Nova-New {
    param([string]$Name)
    if (-not $Name) { Write-Error "Usage: nova new <project-name>"; exit 1 }
    if (Test-Path $Name) { Write-Error "Directory '$Name' already exists."; exit 1 }

    New-Item -ItemType Directory -Path $Name | Out-Null
    New-Item -ItemType Directory -Path "$Name\src" | Out-Null

    @"
[package]
name = "$Name"
version = "0.1.0"

[dependencies]
"@ | Set-Content "$Name\nova.toml"

    @"
fn main()
    print("Hello from $Name!")
"@ | Set-Content "$Name\src\main.nova"

    @"
fn test_hello()
    assert_eq(1 + 1, 2)
    print("test_hello PASS")

fn main()
    test_hello()
    print("All tests passed")
"@ | Set-Content "$Name\src\main_test.nova"

    Write-Host "Created project '$Name'"
    Write-Host "  $Name\nova.toml"
    Write-Host "  $Name\src\main.nova"
    Write-Host "  $Name\src\main_test.nova"
    Write-Host ""
    Write-Host "Get started:"
    Write-Host "  cd $Name"
    Write-Host "  nova run src\main.nova"
}

function Nova-Clean {
    $patterns = @("*.ll", "*.exe", "*.o", "*.obj")
    $removed = 0
    foreach ($p in $patterns) {
        $files = Get-ChildItem -Filter $p -ErrorAction SilentlyContinue
        foreach ($f in $files) {
            Remove-Item $f.FullName -Force
            $removed++
        }
    }
    if (Test-Path "target") {
        Remove-Item "target" -Recurse -Force
        $removed++
    }
    Write-Host "Cleaned $removed artifact(s)."
}

function Nova-Fmt {
    param([string]$Source)
    if (-not $Source) {
        $files = Get-ChildItem -Filter "*.nova" -Recurse
    } else {
        $files = @(Get-Item $Source)
    }

    foreach ($f in $files) {
        $content = Get-Content $f.FullName -Raw
        $lines = $content -split "`n"
        $formatted = @()
        $changed = $false

        foreach ($line in $lines) {
            $original = $line
            # Normalize trailing whitespace
            $line = $line.TrimEnd()
            # Convert tabs to 4 spaces
            $line = $line -replace "`t", "    "
            if ($line -ne $original.TrimEnd("`r")) { $changed = $true }
            $formatted += $line
        }

        # Ensure single trailing newline
        while ($formatted.Count -gt 0 -and $formatted[-1] -eq "") {
            $formatted = $formatted[0..($formatted.Count - 2)]
            $changed = $true
        }
        $formatted += ""

        if ($changed) {
            ($formatted -join "`n") | Set-Content $f.FullName -NoNewline
            Write-Host "Formatted: $($f.Name)"
        } else {
            Write-Host "OK: $($f.Name)"
        }
    }
}

function Nova-Bench {
    param([string]$Path)
    $benchDir = Join-Path $ScriptDir "bench"
    if (Test-Path (Join-Path $benchDir "run_bench.ps1")) {
        & (Join-Path $benchDir "run_bench.ps1")
    } else {
        Write-Host "No benchmark suite found at $benchDir"
    }
}

function Nova-Version {
    Write-Host "NOVA $NovaVersion"
    Write-Host "Compiler: $((Get-Compiler).Type) at $((Get-Compiler).Path)"
    Write-Host "Runtime: $RuntimeSrc"
    & $ClangPath --version 2>$null | Select-Object -First 1
}

# ─── Dispatch ─────────────────────────────────────────────────────────

# Item #1: --release (or -r) → -O2 peak build; default → -O0 cached dev link (fast inner loop).
# Item #5: dev builds add -g so a fatal panic's stack trace resolves to func + file:line (clang DWARF
# read by llvm-symbolizer). --release stays -O2 (no -g; symbolize offline if needed).
$isRelease = ($Args -contains '--release') -or ($Args -contains '-r')
$script:LinkOpt = if ($isRelease) { '-O2' } else { '-O0 -g' }
$srcArg = ($Args | Where-Object { $_ -notlike '-*' } | Select-Object -First 1)

switch ($Command) {
    "build"   { Nova-Build -Source $srcArg }
    "run"     { Nova-Run -Source $srcArg }
    "test"    { Nova-Test -Path $srcArg }
    "check"   { Nova-Check -Source $srcArg }
    "fmt"     { Nova-Fmt -Source ($Args | Select-Object -First 1) }
    "new"     { Nova-New -Name ($Args | Select-Object -First 1) }
    "clean"   { Nova-Clean }
    "bench"   { Nova-Bench -Path ($Args | Select-Object -First 1) }
    "version" { Nova-Version }
    "help"    {
        Write-Host "NOVA $NovaVersion -- Universal Future Computing Language"
        Write-Host ""
        Write-Host 'Usage: nova [command] [args]'
        Write-Host ""
        Write-Host "Commands:"
        Write-Host "  build [file]    Compile a NOVA program to native binary"
        Write-Host "  run [file]      Build and run"
        Write-Host "  test [path]     Run all *_test.nova files"
        Write-Host "  check [file]    Type-check without building"
        Write-Host "  fmt [file]      Format source code"
        Write-Host '  new [name]      Create new project'
        Write-Host "  clean           Remove build artifacts"
        Write-Host "  bench [path]    Run benchmarks"
        Write-Host "  version         Show version info"
    }
    default {
        if ($Command) {
            Write-Host "Unknown command: $Command"
            Write-Host 'Run "nova help" for usage.'
            exit 1
        } else {
            Write-Host "NOVA $NovaVersion"
            Write-Host 'Run "nova help" for usage.'
        }
    }
}
