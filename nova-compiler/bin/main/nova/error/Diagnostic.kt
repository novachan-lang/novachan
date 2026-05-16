package nova.error

import nova.lexer.SourceSpan

enum class Severity { ERROR, WARNING, NOTE }

data class Diagnostic(
    val severity: Severity,
    val message: String,
    val span: SourceSpan,
    val hint: String? = null,
    val fix: String? = null,
) {
    companion object {
        fun error(msg: String, span: SourceSpan, hint: String? = null, fix: String? = null) =
            Diagnostic(Severity.ERROR, msg, span, hint, fix)

        fun warning(msg: String, span: SourceSpan, hint: String? = null) =
            Diagnostic(Severity.WARNING, msg, span, hint)

        fun note(msg: String, span: SourceSpan) =
            Diagnostic(Severity.NOTE, msg, span)
    }
}

object DiagnosticPrinter {
    private val useColor = System.getenv("NO_COLOR") == null &&
        (System.getenv("TERM") != null || System.getProperty("os.name")?.contains("Windows") == true)

    // ANSI escape codes
    private val RESET  = if (useColor) "[0m"  else ""
    private val BOLD   = if (useColor) "[1m"  else ""
    private val RED    = if (useColor) "[31m"  else ""
    private val YELLOW = if (useColor) "[33m"  else ""
    private val CYAN   = if (useColor) "[36m"  else ""
    private val GREEN  = if (useColor) "[32m"  else ""
    private val DIM    = if (useColor) "[2m"   else ""
    private val BLUE   = if (useColor) "[34m"  else ""

    private val sourceCache = mutableMapOf<String, List<String>>()

    fun registerSource(name: String, text: String) {
        sourceCache[name] = text.lines()
    }

    private fun getSourceLines(file: String): List<String> =
        sourceCache.getOrPut(file) {
            try { java.io.File(file).readLines() }
            catch (_: Exception) { emptyList() }
        }

    fun display(diagnostic: Diagnostic) {
        val (severity, message, span, hint, fix) = diagnostic
        val (sevLabel, sevColor) = when (severity) {
            Severity.ERROR   -> "error" to RED
            Severity.WARNING -> "warning" to YELLOW
            Severity.NOTE    -> "note" to CYAN
        }

        val location = "${span.file}:${span.start.line}:${span.start.col}"
        System.err.println("$BOLD$sevColor$sevLabel$RESET$BOLD: $message$RESET")
        System.err.println("  ${DIM}-->$RESET $location")

        val lines = getSourceLines(span.file)
        val lineNum = span.start.line
        val col = span.start.col
        if (lineNum > 0 && lineNum <= lines.size) {
            val sourceLine = lines[lineNum - 1]
            val gutterWidth = lineNum.toString().length
            val gutter = lineNum.toString().padStart(gutterWidth)
            val emptyGutter = " ".repeat(gutterWidth)

            System.err.println("  $DIM$emptyGutter |$RESET")
            System.err.println("  $DIM$gutter |$RESET $sourceLine")

            val underlineLen = maxOf(1, span.end.col - span.start.col)
                .coerceAtMost(sourceLine.length - col + 1)
                .coerceAtLeast(1)
            val pointer = " ".repeat(col - 1) + "$sevColor${
                if (underlineLen > 1) "^" + "~".repeat(underlineLen - 1)
                else "^"
            }$RESET"
            System.err.println("  $DIM$emptyGutter |$RESET $pointer")

            if (hint != null)
                System.err.println("  $DIM$emptyGutter |$RESET $CYAN= $hint$RESET")
            if (fix != null)
                System.err.println("  $DIM$emptyGutter |$RESET $GREEN+ fix: $fix$RESET")
        } else {
            if (hint != null)
                System.err.println("  $CYAN= $hint$RESET")
            if (fix != null)
                System.err.println("  $GREEN+ fix: $fix$RESET")
        }
        System.err.println()
    }

    fun displayAll(diagnostics: List<Diagnostic>) {
        for (d in diagnostics) display(d)
        val errorCount = diagnostics.count { it.severity == Severity.ERROR }
        val warnCount = diagnostics.count { it.severity == Severity.WARNING }
        if (errorCount > 0) {
            val parts = mutableListOf("$BOLD${RED}$errorCount error${if (errorCount != 1) "s" else ""}$RESET")
            if (warnCount > 0) parts.add("$BOLD${YELLOW}$warnCount warning${if (warnCount != 1) "s" else ""}$RESET")
            System.err.println("${parts.joinToString(", ")} emitted")
        }
    }

    fun clear() { sourceCache.clear() }
}
