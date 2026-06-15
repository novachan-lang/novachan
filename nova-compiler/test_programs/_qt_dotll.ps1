$dir = $PSScriptRoot
$env:NOVA_NO_CACHE = "1"
$compiler = "$dir\gen4_test.exe"
foreach ($test in @("_dot_typed", "_dot_untyped")) {
    Remove-Item "$dir\$test.ll" -Force -ErrorAction SilentlyContinue
    $ps = New-Object System.Diagnostics.ProcessStartInfo
    $ps.FileName = $compiler; $ps.Arguments = "$test.nova"; $ps.WorkingDirectory = $dir
    $ps.UseShellExecute = $false; $ps.RedirectStandardOutput = $true; $ps.RedirectStandardError = $true; $ps.CreateNoWindow = $true
    $pr = [System.Diagnostics.Process]::new(); $pr.StartInfo = $ps; $pr.Start() | Out-Null
    $pr.StandardOutput.ReadToEnd() | Out-Null; $pr.StandardError.ReadToEnd() | Out-Null
    $pr.WaitForExit(60000) | Out-Null
    Write-Host "==== $test : @dot body ===="
    if (Test-Path "$dir\$test.ll") {
        $lines = Get-Content "$dir\$test.ll"
        $inDot = $false
        foreach ($l in $lines) {
            if ($l -match '^define .*@dot\(') { $inDot = $true }
            if ($inDot) {
                if ($l -match 'mul|add|fmul|fadd|nova_rt_mul|nova_rt_add|fsub|fdiv|field|getelementptr|load|call|ret') { Write-Host $l }
                if ($l -match '^\}') { $inDot = $false }
            }
        }
    } else { Write-Host "(no .ll)" }
    Write-Host ""
}
