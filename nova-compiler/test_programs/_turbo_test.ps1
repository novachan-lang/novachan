Set-Location $PSScriptRoot
. "$PSScriptRoot\_proc_util.ps1"

$compiler = (Resolve-Path "$PSScriptRoot\gen3_test.exe").Path
$runtimeSrc = "$PSScriptRoot\output\nova_runtime.c"
$runtimeObj = "$PSScriptRoot\output\nova_runtime.o"

# ─── STEP 1: Pre-compile runtime ONCE ───────────────────────────────────────
$sw = [System.Diagnostics.Stopwatch]::StartNew()
$needRecompile = $true
if (Test-Path $runtimeObj) {
    $srcTime = (Get-Item $runtimeSrc).LastWriteTimeUtc
    $objTime = (Get-Item $runtimeObj).LastWriteTimeUtc
    if ($objTime -ge $srcTime) { $needRecompile = $false }
}

if ($needRecompile) {
    Write-Host "Compiling runtime to .o (one-time cost)..."
    $cr = Invoke-Timed -FilePath $ClangPath -Arguments "-c -O2 -o `"$runtimeObj`" `"$runtimeSrc`" -D_CRT_SECURE_NO_WARNINGS -w" -TimeoutMs 120000
    if ($cr.ExitCode -ne 0 -or !(Test-Path $runtimeObj)) {
        Write-Host "FATAL: runtime compilation failed"
        exit 1
    }
    Write-Host "Runtime compiled in $($sw.Elapsed.TotalSeconds.ToString('F1'))s"
} else {
    Write-Host "Runtime .o is up-to-date (skipped)"
}
$sw.Stop()

# ─── STEP 2: Collect all tests ──────────────────────────────────────────────
$allNova = Get-ChildItem "$PSScriptRoot\*.nova" | Where-Object { $_.Name -ne "nova_compiler.nova" -and $_.Name -ne "repl.nova" }

# Filter to only regression tests if specified
$filter = $args[0]
if ($filter) {
    $allNova = $allNova | Where-Object { $_.BaseName -like "*$filter*" }
}

$total = $allNova.Count
Write-Host ""
Write-Host "=== NOVA Turbo Test ($total tests, pre-compiled runtime, parallel) ==="
Write-Host ""

# ─── STEP 3: Parallel test execution ────────────────────────────────────────
$maxParallel = [Math]::Max(1, [Environment]::ProcessorCount - 1)
$results = [System.Collections.Concurrent.ConcurrentBag[psobject]]::new()
$completed = [ref]0

$testBlock = {
    param($novaFile, $compiler, $runtimeObj, $clangPath, $novaLinkFlags, $psScriptRoot)

    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($novaFile)
    $ll = Join-Path $psScriptRoot "$baseName.ll"
    $exe = Join-Path $psScriptRoot "$baseName.exe"

    $result = [pscustomobject]@{ Name = $baseName; Status = "FAIL"; Detail = "" }

    try {
        # Compile .nova -> .ll
        $psi = New-Object System.Diagnostics.ProcessStartInfo
        $psi.FileName = $compiler
        $psi.Arguments = "$baseName.nova"
        $psi.WorkingDirectory = $psScriptRoot
        $psi.UseShellExecute = $false
        $psi.RedirectStandardOutput = $true
        $psi.RedirectStandardError = $true
        $psi.CreateNoWindow = $true
        $proc = [System.Diagnostics.Process]::Start($psi)
        $proc.StandardOutput.ReadToEndAsync() | Out-Null
        $proc.StandardError.ReadToEndAsync() | Out-Null
        if (!$proc.WaitForExit(60000)) { try { $proc.Kill() } catch {} ; $result.Detail = "COMPILE TIMEOUT"; return $result }
        if ($proc.ExitCode -ne 0) { $result.Detail = "COMPILE exit=$($proc.ExitCode)"; return $result }
        if (!(Test-Path $ll)) { $result.Detail = "NO .ll"; return $result }

        # Pick up @link libs
        $extraLibs = ""
        $skipLibs = @('m','pthread','dl','rt')
        Get-Content $ll | Where-Object { $_ -match '^; LINK_LIB: (\S+)' } | ForEach-Object {
            $libName = $matches[1]
            if ($skipLibs -notcontains $libName) { $extraLibs += " -l$libName" }
        }

        # SQLite amalgamation
        $extraSrc = ""
        if (Select-String -Path $ll -Pattern '@sqlite3_' -Quiet) {
            $sqliteSrc = Join-Path $psScriptRoot "output\sqlite3.c"
            if (Test-Path $sqliteSrc) { $extraSrc = " `"$sqliteSrc`" -DSQLITE_THREADSAFE=0" }
        }

        # Link against pre-compiled .o (FAST!)
        $linkArgs = "-O2 -o `"$exe`" `"$ll`" `"$runtimeObj`"$extraSrc $novaLinkFlags$extraLibs -D_CRT_SECURE_NO_WARNINGS -w"
        $psi2 = New-Object System.Diagnostics.ProcessStartInfo
        $psi2.FileName = $clangPath
        $psi2.Arguments = $linkArgs
        $psi2.WorkingDirectory = $psScriptRoot
        $psi2.UseShellExecute = $false
        $psi2.RedirectStandardOutput = $true
        $psi2.RedirectStandardError = $true
        $psi2.CreateNoWindow = $true
        $proc2 = [System.Diagnostics.Process]::Start($psi2)
        $proc2.StandardOutput.ReadToEndAsync() | Out-Null
        $proc2.StandardError.ReadToEndAsync() | Out-Null
        if (!$proc2.WaitForExit(60000)) { try { $proc2.Kill() } catch {} ; $result.Detail = "LINK TIMEOUT"; return $result }
        if (!(Test-Path $exe)) { $result.Detail = "LINK FAIL"; return $result }

        # Run
        $psi3 = New-Object System.Diagnostics.ProcessStartInfo
        $psi3.FileName = $exe
        $psi3.Arguments = ""
        $psi3.WorkingDirectory = $psScriptRoot
        $psi3.UseShellExecute = $false
        $psi3.RedirectStandardOutput = $true
        $psi3.RedirectStandardError = $true
        $psi3.CreateNoWindow = $true
        $proc3 = [System.Diagnostics.Process]::Start($psi3)
        $outTask = $proc3.StandardOutput.ReadToEndAsync()
        $errTask = $proc3.StandardError.ReadToEndAsync()
        if (!$proc3.WaitForExit(15000)) {
            try { $proc3.Kill() } catch {}
            try { $proc3.WaitForExit(5000) } catch {}
            $result.Detail = "TIMEOUT"
            return $result
        }
        $stderr = $errTask.Result
        if ($proc3.ExitCode -ne 0) { $result.Detail = "RUN exit=$($proc3.ExitCode)"; return $result }
        if ($stderr -match 'FAIL assert') { $result.Detail = "ASSERT FAIL"; return $result }

        $result.Status = "PASS"
    } finally {
        Remove-Item $exe -Force -ErrorAction SilentlyContinue
        Remove-Item $ll -Force -ErrorAction SilentlyContinue
    }
    return $result
}

$sw2 = [System.Diagnostics.Stopwatch]::StartNew()

# Use PowerShell 5's runspace pool for true parallelism
$pool = [runspacefactory]::CreateRunspacePool(1, $maxParallel)
$pool.Open()

$jobs = @()
foreach ($nova in $allNova) {
    $ps = [powershell]::Create().AddScript($testBlock).AddArgument($nova.FullName).AddArgument($compiler).AddArgument($runtimeObj).AddArgument($ClangPath).AddArgument($NovaLinkFlags).AddArgument($PSScriptRoot)
    $ps.RunspacePool = $pool
    $jobs += [pscustomobject]@{ Pipe = $ps; Handle = $ps.BeginInvoke(); Name = $nova.BaseName }
}

# Collect results
$pass = 0; $fail = 0; $failures = @()
foreach ($job in $jobs) {
    $r = $job.Pipe.EndInvoke($job.Handle)
    $job.Pipe.Dispose()
    if ($r -and $r.Count -gt 0) {
        $res = $r[0]
    } else {
        $res = [pscustomobject]@{ Name = $job.Name; Status = "FAIL"; Detail = "NO RESULT" }
    }
    if ($res.Status -eq "PASS") {
        $pass++
        Write-Host "PASS $($res.Name)"
    } else {
        $fail++
        $failures += "$($res.Name) ($($res.Detail))"
        Write-Host "FAIL $($res.Name) ($($res.Detail))"
    }
}

$pool.Close()
$pool.Dispose()
$sw2.Stop()

Write-Host ""
Write-Host "=== RESULTS: $pass PASS, $fail FAIL (of $total total) in $($sw2.Elapsed.TotalSeconds.ToString('F1'))s ==="
if ($failures.Count -gt 0) {
    Write-Host ""
    Write-Host "Failures:"
    foreach ($f in $failures) { Write-Host "  $f" }
}
if ($fail -gt 0) { exit 1 }
