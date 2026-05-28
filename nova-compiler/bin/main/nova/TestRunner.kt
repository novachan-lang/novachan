package nova

import nova.lexer.Lexer
import nova.parser.*
import nova.types.TypeInferer
import nova.ir.AstToIr
import nova.ir.IrErasure
import nova.ir.IrTypeRefiner
import nova.ir.LlvmCodegen
import nova.error.DiagnosticPrinter
import java.io.File
import java.util.concurrent.TimeUnit

class TestRunner(private val verbose: Boolean = false) {

    data class RunOutput(val stdout: String, val stderr: String, val exitCode: Int)

    data class FileResult(
        val fileName: String,
        val tests: List<FnResult>,
        val compileError: String? = null,
        val elapsedMs: Long = 0
    )

    data class FnResult(
        val name: String,
        val passed: Boolean,
        val failMessage: String? = null
    )

    fun run(path: File): Int {
        val testFiles = discoverTests(path)
        if (testFiles.isEmpty()) {
            println("nova test: no *_test.nova files found in ${path.absolutePath}")
            return 1
        }

        println()
        println("  NOVA TEST RUNNER")
        println("  ${"─".repeat(54)}")
        println("  Found ${testFiles.size} test file(s) in ${path.name}/")
        println()

        val results = mutableListOf<FileResult>()
        val t0 = System.currentTimeMillis()

        for (file in testFiles) {
            results.add(runTestFile(file))
        }

        val totalMs = System.currentTimeMillis() - t0

        // Summary
        val totalTests = results.sumOf { it.tests.size }
        val totalPass = results.sumOf { r -> r.tests.count { it.passed } }
        val totalFail = results.sumOf { r -> r.tests.count { !it.passed } }
        val compileErrors = results.count { it.compileError != null }

        println()
        println("  ${"─".repeat(54)}")
        println("  $totalPass passed, $totalFail failed, $compileErrors compile errors")
        println("  ${testFiles.size} files, $totalTests tests (${totalMs}ms)")
        if (totalFail == 0 && compileErrors == 0) {
            println("  ALL TESTS PASSED")
        } else {
            println("  SOME TESTS FAILED")
        }
        println()

        return if (totalFail == 0 && compileErrors == 0) 0 else 1
    }

    private fun discoverTests(path: File): List<File> {
        if (path.isFile && path.extension == "nova") return listOf(path)
        if (!path.isDirectory) return emptyList()
        return path.listFiles()
            ?.filter { it.isFile && it.extension == "nova" &&
                (it.name.endsWith("_test.nova") || it.name.startsWith("test_")) }
            ?.sortedBy { it.name }
            ?: emptyList()
    }

    private fun runTestFile(file: File): FileResult {
        val start = System.currentTimeMillis()
        val source = file.readText()
        val srcName = file.name

        // Check for expected-failure directive: "// expect: fail" in first 3 lines
        val expectFail = source.lines().take(3).any {
            it.trim().lowercase() == "// expect: fail"
        }

        // Parse to find test functions
        val tokens = try {
            Lexer(source, srcName).tokenize()
        } catch (e: Exception) {
            val msg = "Lex error: ${e.message}"
            println("  COMPILE-FAIL  $srcName  ($msg)")
            return FileResult(srcName, emptyList(), compileError = msg)
        }

        val parser = Parser(tokens)
        val program = parser.parse()
        if (parser.errors.isNotEmpty()) {
            val msg = parser.errors.first().message
            println("  COMPILE-FAIL  $srcName  ($msg)")
            return FileResult(srcName, emptyList(), compileError = msg)
        }

        // Find test_ functions (no parameters or all-default parameters)
        val testFns = program.stmts
            .filterIsInstance<FnDecl>()
            .filter { it.name.startsWith("test_") }
            .map { it.name }

        // Check if there's already a main() call at top level
        val hasMainCall = program.stmts.any { stmt ->
            stmt is ExprStmt && stmt.expr is Call &&
                (stmt.expr as Call).let { call ->
                    call.callee is Ident && (call.callee as Ident).name == "main"
                }
        }

        // Build final source
        val finalSource: String
        val isHarness: Boolean

        if (testFns.isNotEmpty() && !hasMainCall) {
            finalSource = source + generateTestHarness(testFns)
            isHarness = true
        } else {
            finalSource = source
            isHarness = false
        }

        // Compile in a temp dir
        val tempDir = createTempDir("nova_test_")
        try {
            val llFile = File(tempDir, "test.ll")
            val exeFile = File(tempDir, "test.exe")

            // Detect companion C files (e.g., ffi_test.c for ffi_test.nova)
            val companionC = File(file.parentFile, file.nameWithoutExtension + ".c")
            val extraCFiles = if (companionC.exists()) listOf(companionC) else emptyList()

            val compileErr = compileSrc(finalSource, srcName, llFile, exeFile, tempDir, file, extraCFiles)
            if (compileErr != null) {
                println("  COMPILE-FAIL  $srcName  ($compileErr)")
                return FileResult(srcName, emptyList(), compileError = compileErr)
            }

            // Run
            val output = runBinary(exeFile, 30_000)
            val elapsed = System.currentTimeMillis() - start

            if (isHarness && testFns.isNotEmpty()) {
                return parseHarnessOutput(srcName, testFns, output, elapsed)
            } else {
                // File-level test: pass/fail based on exit code
                val rawPassed = output.exitCode == 0
                val passed = if (expectFail) !rawPassed else rawPassed
                val label = if (passed) "PASS" else "FAIL"
                val detail = if (!passed && output.stderr.isNotBlank())
                    "  (${output.stderr.lines().firstOrNull { it.isNotBlank() } ?: "exit ${output.exitCode}"})"
                else ""
                println("  $label  ${srcName.padEnd(42)} ${elapsed}ms$detail")
                if (verbose && !passed) {
                    output.stderr.lines().take(3).forEach { println("         $it") }
                }
                return FileResult(
                    srcName,
                    listOf(FnResult(srcName, passed, if (!passed) output.stderr.ifBlank { null } else null)),
                    elapsedMs = elapsed
                )
            }
        } finally {
            tempDir.deleteRecursively()
        }
    }

    private fun generateTestHarness(testFns: List<String>): String {
        return buildString {
            appendLine()
            appendLine()
            appendLine("fn __nova_test_harness()")
            for (fn in testFns) {
                appendLine("    print(\"__NOVA_TEST__ $fn\")")
                appendLine("    $fn()")
                appendLine("    print(\"__NOVA_PASS__ $fn\")")
            }
            appendLine("    print(\"__NOVA_DONE__ ${testFns.size}\")")
            appendLine()
            appendLine("__nova_test_harness()")
        }
    }

    private fun compileSrc(
        source: String, srcName: String, llFile: File, exeFile: File,
        tempDir: File, sourceFile: File, extraCFiles: List<File> = emptyList()
    ): String? {
        try {
            DiagnosticPrinter.registerSource(srcName, source)

            val tokens = Lexer(source, srcName).tokenize()
            val parser = Parser(tokens)
            val prog = parser.parse()
            if (parser.errors.isNotEmpty()) {
                return parser.errors.joinToString("; ") { it.message }
            }

            // Check for imports — if present, use multi-file compilation
            val imports = prog.stmts.filterIsInstance<ImportStmt>()
            val llvm: String

            if (imports.isNotEmpty()) {
                val module = compileWithImports(source, srcName, sourceFile, prog)
                    ?: return "module resolution failed"
                llvm = LlvmCodegen().generate(module)
            } else {
                val inferResult = TypeInferer().infer(prog)
                if (inferResult.errors.isNotEmpty()) {
                    return inferResult.errors.joinToString("; ") { it.message }
                }

                val module = AstToIr(inferResult.nodeTypes).lower(prog)
                val erased = IrErasure().erase(module)
                val refined = IrTypeRefiner().refine(erased)
                llvm = LlvmCodegen().generate(refined)
            }

            llFile.writeText(llvm)

            // Write runtime
            val runtimeFile = File(tempDir, "nova_runtime.c")
            val canonicalRuntime = File("runtime/nova_runtime.c")
            if (canonicalRuntime.exists()) {
                runtimeFile.writeText(canonicalRuntime.readText())
            } else {
                val projRuntime = File("nova_runtime.c")
                if (projRuntime.exists()) {
                    runtimeFile.writeText(projRuntime.readText())
                } else {
                    return "nova_runtime.c not found"
                }
            }

            // Copy companion C files to temp dir
            val extraPaths = extraCFiles.map { cFile ->
                val dest = File(tempDir, cFile.name)
                dest.writeText(cFile.readText())
                dest.absolutePath
            }

            // Compile with clang
            val clangResult = runClang(runtimeFile.absolutePath, llFile.absolutePath, exeFile.absolutePath, extraPaths)
            if (clangResult != 0) {
                return "clang failed (exit $clangResult)"
            }
            return null
        } catch (e: Exception) {
            return e.message ?: "unknown compilation error"
        }
    }

    private fun compileWithImports(
        source: String, srcName: String, sourceFile: File, mainProg: Program
    ): nova.ir.IrModule? {
        val projectRoot = sourceFile.parentFile ?: File(".")
        val resolver = ModuleResolver(projectRoot)
        val modules = resolver.resolveAll(sourceFile)
        if (modules.isEmpty()) return null

        val mergedModule = nova.ir.IrModule("nova")
        val moduleExports = mutableMapOf<String, Set<String>>()

        for (modInfo in modules) {
            moduleExports[modInfo.name] = modInfo.publicFunctions

            // For the main module, use the (possibly harness-augmented) source
            val program = if (modInfo.file.canonicalPath == sourceFile.canonicalPath) {
                DiagnosticPrinter.registerSource(srcName, source)
                val tokens = Lexer(source, srcName).tokenize()
                val parser = Parser(tokens)
                val prog = parser.parse()
                if (parser.errors.isNotEmpty()) return null
                prog
            } else {
                modInfo.program
            }

            val inferResult = TypeInferer().infer(program)
            if (inferResult.errors.isNotEmpty()) return null

            val lowerer = AstToIr(inferResult.nodeTypes)

            for (imp in modInfo.imports) {
                val impName = imp.alias ?: imp.path.last()
                val exports = moduleExports[imp.path.last()]
                if (exports != null) {
                    if (imp.selectiveNames != null) {
                        lowerer.registerSelectiveImports(exports.intersect(imp.selectiveNames.toSet()))
                    } else {
                        lowerer.registerModule(impName, exports)
                    }
                }
            }

            val ir = lowerer.lower(program)
            val isMain = modInfo.file.canonicalPath == sourceFile.canonicalPath
            for (fn in ir.functions) {
                if (!isMain && fn.name == "nova_main") continue
                mergedModule.functions.add(fn)
            }
            mergedModule.structs.addAll(ir.structs)
            mergedModule.externFunctions.addAll(ir.externFunctions)
        }

        val erased = IrErasure().erase(mergedModule)
        return IrTypeRefiner().refine(erased)
    }

    private fun runClang(
        runtimePath: String, llPath: String, exePath: String,
        extraCPaths: List<String> = emptyList()
    ): Int {
        val candidates = listOf(
            "clang",
            "C:\\Program Files\\LLVM\\bin\\clang.exe",
            "C:\\Program Files (x86)\\LLVM\\bin\\clang.exe"
        )
        val isWindows = System.getProperty("os.name").lowercase().contains("win")
        val extraLibs = if (isWindows) listOf("-lwinhttp") else emptyList()
        for (clang in candidates) {
            return try {
                val cmd = mutableListOf(clang, "-O2", runtimePath, llPath)
                cmd.addAll(extraCPaths)
                cmd.addAll(listOf("-o", exePath))
                cmd.addAll(extraLibs)
                val proc = ProcessBuilder(cmd)
                    .redirectErrorStream(true)
                    .start()
                proc.inputStream.bufferedReader().readText()
                proc.waitFor()
            } catch (_: Exception) { continue }
        }
        return -1
    }

    private fun runBinary(exe: File, timeoutMs: Long): RunOutput {
        if (!exe.exists()) return RunOutput("", "executable not found", -1)
        return try {
            val proc = ProcessBuilder(exe.absolutePath)
                .directory(exe.parentFile)
                .start()
            val stdout = proc.inputStream.bufferedReader().readText()
            val stderr = proc.errorStream.bufferedReader().readText()
            val finished = proc.waitFor(timeoutMs, TimeUnit.MILLISECONDS)
            if (!finished) {
                proc.destroyForcibly()
                RunOutput(stdout, "TIMEOUT after ${timeoutMs}ms", -1)
            } else {
                RunOutput(stdout, stderr, proc.exitValue())
            }
        } catch (e: Exception) {
            RunOutput("", "Run error: ${e.message}", -1)
        }
    }

    private fun parseHarnessOutput(
        fileName: String, testFns: List<String>, output: RunOutput, elapsedMs: Long
    ): FileResult {
        val lines = output.stdout.lines()
        val results = mutableListOf<FnResult>()

        for (fn in testFns) {
            val started = lines.any { it.trim() == "__NOVA_TEST__ $fn" }
            val passed = lines.any { it.trim() == "__NOVA_PASS__ $fn" }

            if (!started) {
                // Test never ran (compile or earlier test failure)
                results.add(FnResult(fn, false, "did not run"))
            } else if (passed) {
                results.add(FnResult(fn, true))
            } else {
                // Started but didn't pass — assert failure
                val failMsg = output.stderr.lines()
                    .firstOrNull { it.contains("Assertion failed") }
                    ?.trim()
                    ?: "assertion failed"
                results.add(FnResult(fn, false, failMsg))
            }
        }

        // Print per-function results
        for (r in results) {
            val label = if (r.passed) "PASS" else "FAIL"
            val detail = if (!r.passed && r.failMessage != null) "  (${r.failMessage})" else ""
            println("  $label  ${fileName}::${r.name.padEnd(34)} ${elapsedMs}ms$detail")
        }

        return FileResult(fileName, results, elapsedMs = elapsedMs)
    }

    private fun createTempDir(prefix: String): File {
        val dir = File(System.getProperty("java.io.tmpdir"), prefix + System.nanoTime())
        dir.mkdirs()
        return dir
    }
}
