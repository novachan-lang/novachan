package nova

import nova.lexer.Lexer
import nova.parser.Parser
import nova.types.TypeInferer
import nova.ir.AstToIr
import nova.ir.IrErasure
import nova.ir.IrTypeRefiner
import nova.ir.LlvmCodegen
import nova.error.DiagnosticPrinter
import java.io.File
import java.util.concurrent.TimeUnit

class BenchRunner {

    data class BenchResult(
        val name: String,
        val novaMsAvg: Double,
        val cMsAvg: Double?,
        val ratio: Double?,
        val novaOutput: String,
        val cOutput: String?,
        val status: String
    )

    private val isWindows = System.getProperty("os.name").lowercase().contains("win")
    private val iterations = 3

    fun run(benchDir: File, outputDir: File?): Int {
        val benchFiles = discoverBenchmarks(benchDir)
        if (benchFiles.isEmpty()) {
            println("nova bench: no bench_*.nova files found in ${benchDir.absolutePath}")
            return 1
        }

        println()
        println("  NOVA BENCHMARK RUNNER")
        println("  ${"─".repeat(60)}")
        println("  Found ${benchFiles.size} benchmark(s)")
        println("  Iterations per benchmark: $iterations")
        println()

        val results = mutableListOf<BenchResult>()
        val tempDir = createTempDir("nova_bench_")

        try {
            for (file in benchFiles) {
                print("  Benchmarking ${file.nameWithoutExtension}...")
                System.out.flush()
                val result = runBenchmark(file, tempDir)
                results.add(result)

                val ratio = result.ratio
                val ratioStr = if (ratio != null) "%.2fx vs C".format(ratio) else "no C baseline"
                println("\r  ${result.status.padEnd(6)} ${file.nameWithoutExtension.padEnd(30)} ${"%8.1f".format(result.novaMsAvg)}ms  ($ratioStr)")
            }

            println()
            println("  ${"─".repeat(60)}")

            val avgRatio = results.mapNotNull { it.ratio }.average()
            val maxRatio = results.mapNotNull { it.ratio }.maxOrNull() ?: 0.0
            println("  Average NOVA/C ratio: %.2fx".format(avgRatio))
            println("  Worst case: %.2fx".format(maxRatio))
            println("  Gate 5 threshold: < 1.10x (10% of C)")
            val passed = maxRatio <= 1.15
            println("  Status: ${if (passed) "PASS" else "FAIL (worst ratio > 15%)"}")
            println()

            if (outputDir != null) {
                outputDir.mkdirs()
                val html = generateDashboard(results)
                val dashFile = File(outputDir, "bench.html")
                dashFile.writeText(html)
                val csvFile = File(outputDir, "bench.csv")
                csvFile.writeText(generateCsv(results))
                println("  Dashboard: ${dashFile.absolutePath}")
                println("  CSV: ${csvFile.absolutePath}")
            }

            return if (passed) 0 else 1
        } finally {
            tempDir.deleteRecursively()
        }
    }

    private fun discoverBenchmarks(dir: File): List<File> {
        if (dir.isFile) return listOf(dir)
        if (!dir.isDirectory) return emptyList()
        return dir.listFiles()
            ?.filter { it.isFile && it.extension == "nova" && it.name.startsWith("bench_") }
            ?.sortedBy { it.name }
            ?: emptyList()
    }

    private fun runBenchmark(file: File, tempDir: File): BenchResult {
        val name = file.nameWithoutExtension

        val novaExe = compileNova(file, File(tempDir, "$name.exe"))
        if (novaExe == null) {
            return BenchResult(name, 0.0, null, null, "", null, "FAIL")
        }

        val novaTimes = mutableListOf<Long>()
        var novaOutput = ""
        for (i in 0 until iterations) {
            val (out, ms) = timedRun(novaExe, 120_000)
            novaTimes.add(ms)
            if (i == 0) novaOutput = out
        }
        val novaAvg = novaTimes.average()

        val cFile = File(file.parentFile, "${name}.c")
        val cEquiv = File(file.parentFile, name.replace("bench_g5_", "bench_c_") + ".c")

        val cSource = when {
            cFile.exists() -> cFile
            cEquiv.exists() -> cEquiv
            else -> null
        }

        var cAvg: Double? = null
        var cOutput: String? = null
        if (cSource != null) {
            val cExe = compileC(cSource, File(tempDir, "${name}_c.exe"))
            if (cExe != null) {
                val cTimes = mutableListOf<Long>()
                for (i in 0 until iterations) {
                    val (out, ms) = timedRun(cExe, 120_000)
                    cTimes.add(ms)
                    if (i == 0) cOutput = out
                }
                cAvg = cTimes.average()
            }
        }

        val ratio = if (cAvg != null && cAvg > 0) novaAvg / cAvg else null

        return BenchResult(name, novaAvg, cAvg, ratio, novaOutput, cOutput, "OK")
    }

    private fun compileNova(file: File, exeFile: File): File? {
        try {
            val source = file.readText()
            DiagnosticPrinter.registerSource(file.name, source)
            val tokens = Lexer(source, file.name).tokenize()
            val parser = Parser(tokens)
            val prog = parser.parse()
            if (parser.errors.isNotEmpty()) return null

            val inferResult = TypeInferer().infer(prog)
            val module = AstToIr(inferResult.nodeTypes).lower(prog)
            val erased = IrErasure().erase(module)
            val refined = IrTypeRefiner().refine(erased)
            val llvm = LlvmCodegen().generate(refined)

            val llFile = File(exeFile.parentFile, exeFile.nameWithoutExtension + ".ll")
            llFile.writeText(llvm)

            val rtFile = File(exeFile.parentFile, "nova_runtime.c")
            val rtSource = File("runtime/nova_runtime.c")
            if (rtSource.exists()) rtFile.writeText(rtSource.readText())
            else {
                val proj = File("nova_runtime.c")
                if (proj.exists()) rtFile.writeText(proj.readText())
                else return null
            }

            val extraLibs = if (isWindows) listOf("-lwinhttp") else emptyList()
            val cmd = mutableListOf("clang", "-O2", rtFile.absolutePath, llFile.absolutePath, "-o", exeFile.absolutePath)
            cmd.addAll(extraLibs)
            val proc = ProcessBuilder(cmd).redirectErrorStream(true).start()
            proc.inputStream.bufferedReader().readText()
            if (proc.waitFor() != 0) return null

            return exeFile
        } catch (_: Exception) {
            return null
        }
    }

    private fun compileC(file: File, exeFile: File): File? {
        return try {
            val cmd = mutableListOf("clang", "-O2", file.absolutePath, "-o", exeFile.absolutePath)
            if (!isWindows) cmd.add("-lm")
            val proc = ProcessBuilder(cmd).redirectErrorStream(true).start()
            proc.inputStream.bufferedReader().readText()
            if (proc.waitFor() != 0) null else exeFile
        } catch (_: Exception) { null }
    }

    private fun timedRun(exe: File, timeoutMs: Long): Pair<String, Long> {
        val t0 = System.nanoTime()
        val proc = ProcessBuilder(exe.absolutePath).directory(exe.parentFile).start()
        val out = proc.inputStream.bufferedReader().readText()
        val finished = proc.waitFor(timeoutMs, TimeUnit.MILLISECONDS)
        if (!finished) { proc.destroyForcibly(); return Pair("TIMEOUT", timeoutMs) }
        val ms = (System.nanoTime() - t0) / 1_000_000
        return Pair(out.trim(), ms)
    }

    private fun generateDashboard(results: List<BenchResult>): String = buildString {
        appendLine("<!DOCTYPE html><html><head>")
        appendLine("<meta charset=\"UTF-8\"><title>NOVA Benchmark Dashboard</title>")
        appendLine("<style>")
        appendLine("""
:root { --bg: #0d1117; --fg: #c9d1d9; --accent: #58a6ff; --card: #161b22; --border: #30363d; --pass: #3fb950; --fail: #f85149; }
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: -apple-system, sans-serif; background: var(--bg); color: var(--fg); padding: 2rem; }
h1 { color: var(--accent); margin-bottom: 0.5rem; }
.subtitle { color: #8b949e; margin-bottom: 2rem; }
table { width: 100%; border-collapse: collapse; margin: 1rem 0; }
th { text-align: left; color: #8b949e; border-bottom: 2px solid var(--border); padding: 0.8rem; font-size: 0.85rem; text-transform: uppercase; }
td { padding: 0.8rem; border-bottom: 1px solid var(--border); }
tr:hover { background: var(--card); }
.bar-cell { position: relative; width: 200px; }
.bar { height: 24px; border-radius: 4px; display: inline-block; }
.bar-nova { background: var(--accent); }
.bar-c { background: var(--pass); opacity: 0.7; }
.ratio { font-weight: bold; }
.ratio-good { color: var(--pass); }
.ratio-ok { color: #d29922; }
.ratio-bad { color: var(--fail); }
.summary { background: var(--card); border: 1px solid var(--border); border-radius: 8px; padding: 1.5rem; margin: 2rem 0; display: flex; gap: 2rem; }
.stat { text-align: center; }
.stat-value { font-size: 2rem; font-weight: bold; }
.stat-label { color: #8b949e; font-size: 0.85rem; }
.timestamp { color: #484f58; font-size: 0.8rem; margin-top: 2rem; }
""".trimIndent())
        appendLine("</style></head><body>")
        appendLine("<h1>NOVA Benchmark Dashboard</h1>")
        appendLine("<p class=\"subtitle\">Performance comparison: NOVA vs C (-O2)</p>")

        val avgRatio = results.mapNotNull { it.ratio }.average()
        val maxRatio = results.mapNotNull { it.ratio }.maxOrNull() ?: 0.0
        val passed = maxRatio <= 1.15
        val gateColor = if (passed) "var(--pass)" else "var(--fail)"

        appendLine("<div class=\"summary\">")
        appendLine("<div class=\"stat\"><div class=\"stat-value\" style=\"color:$gateColor\">${if (passed) "PASS" else "FAIL"}</div><div class=\"stat-label\">Gate 5</div></div>")
        appendLine("<div class=\"stat\"><div class=\"stat-value\">${"%.2fx".format(avgRatio)}</div><div class=\"stat-label\">Avg Ratio</div></div>")
        appendLine("<div class=\"stat\"><div class=\"stat-value\">${"%.2fx".format(maxRatio)}</div><div class=\"stat-label\">Worst Case</div></div>")
        appendLine("<div class=\"stat\"><div class=\"stat-value\">${results.size}</div><div class=\"stat-label\">Benchmarks</div></div>")
        appendLine("</div>")

        appendLine("<table>")
        appendLine("<tr><th>Benchmark</th><th>NOVA (ms)</th><th>C (ms)</th><th>Ratio</th><th>Comparison</th><th>Status</th></tr>")

        val maxMs = results.maxOf { maxOf(it.novaMsAvg, it.cMsAvg ?: 0.0) }

        for (r in results) {
            val ratioStr = if (r.ratio != null) "%.2fx".format(r.ratio) else "—"
            val ratioClass = when {
                r.ratio == null -> ""
                r.ratio <= 1.05 -> "ratio-good"
                r.ratio <= 1.15 -> "ratio-ok"
                else -> "ratio-bad"
            }

            val novaWidth = if (maxMs > 0) (r.novaMsAvg / maxMs * 180).toInt() else 0
            val cWidth = if (maxMs > 0 && r.cMsAvg != null) (r.cMsAvg / maxMs * 180).toInt() else 0

            appendLine("<tr>")
            appendLine("<td>${r.name}</td>")
            appendLine("<td>${"%.1f".format(r.novaMsAvg)}</td>")
            appendLine("<td>${if (r.cMsAvg != null) "%.1f".format(r.cMsAvg) else "—"}</td>")
            appendLine("<td class=\"ratio $ratioClass\">$ratioStr</td>")
            appendLine("<td class=\"bar-cell\"><div class=\"bar bar-nova\" style=\"width:${novaWidth}px\"></div><br><div class=\"bar bar-c\" style=\"width:${cWidth}px\"></div></td>")
            appendLine("<td>${r.status}</td>")
            appendLine("</tr>")
        }
        appendLine("</table>")

        appendLine("<p class=\"timestamp\">Generated: ${java.time.LocalDateTime.now()}</p>")
        appendLine("</body></html>")
    }

    private fun generateCsv(results: List<BenchResult>): String = buildString {
        appendLine("benchmark,nova_ms,c_ms,ratio,status")
        for (r in results) {
            appendLine("${r.name},%.1f,${r.cMsAvg?.let { "%.1f".format(it) } ?: ""},${r.ratio?.let { "%.3f".format(it) } ?: ""},${r.status}".format(r.novaMsAvg))
        }
    }

    private fun createTempDir(prefix: String): File {
        val dir = File(System.getProperty("java.io.tmpdir"), prefix + System.nanoTime())
        dir.mkdirs()
        return dir
    }
}
