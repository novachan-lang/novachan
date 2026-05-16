package nova.repl

import nova.interpreter.Interpreter
import nova.interpreter.NUnit
import nova.interpreter.NovaValue
import nova.interpreter.RuntimeError
import nova.lexer.Lexer
import nova.lexer.TokenType
import nova.parser.Parser
import nova.types.TypeInferer

class Repl(
    private val interp: Interpreter = Interpreter(),
    private val showTypes: Boolean = true
) {
    private val inferer = TypeInferer()

    fun start() {
        println("NOVA v0.1.0 — Type expressions to evaluate. Type :quit to exit.")
        val buffer = StringBuilder()
        var continuing = false

        while (true) {
            print(if (continuing) "... " else ">>> ")
            val line = readlnOrNull() ?: break
            if (line.trim() == ":quit" || line.trim() == ":exit") break
            if (line.trim() == ":reset") {
                println("Environment reset.")
                continue
            }

            buffer.appendLine(line)
            val source = buffer.toString().trimEnd()

            if (isIncomplete(source)) {
                continuing = true
                continue
            }

            val result = eval(source)
            buffer.clear()
            continuing = false

            if (result != null) {
                println(result)
            }
        }
    }

    fun eval(source: String): String? {
        val tokens = try {
            Lexer(source, "<repl>").tokenize()
        } catch (e: Exception) {
            return "Lex error: ${e.message}"
        }

        val parser = Parser(tokens)
        val program = parser.parse()

        if (parser.errors.isNotEmpty()) {
            return parser.errors.joinToString("\n") { "Parse error: ${it.message} at ${it.span}" }
        }

        var typeStr: String? = null
        if (showTypes) {
            try {
                val result = inferer.infer(program)
                if (result.errors.isEmpty() && program.stmts.isNotEmpty()) {
                    val lastStmt = program.stmts.last()
                    if (lastStmt is nova.parser.ExprStmt) {
                        val t = result.nodeTypes[lastStmt.expr]
                        if (t != null) typeStr = t.toString()
                    }
                }
            } catch (_: Exception) {
                // Type inference failure is non-fatal in REPL
            }
        }

        val value = try {
            interp.runRepl(program)
        } catch (e: RuntimeError) {
            return "Runtime error: ${e.message}"
        } catch (e: Exception) {
            return "Error: ${e.message}"
        }

        if (value == NUnit && interp.output.isEmpty()) return null

        val printed = if (interp.output.isNotEmpty()) {
            val lines = interp.output.toList()
            interp.output.clear()
            lines.joinToString("\n")
        } else null

        return buildString {
            if (printed != null) append(printed)
            if (value != NUnit) {
                if (printed != null) appendLine()
                append("= $value")
                if (typeStr != null) append(" : $typeStr")
            }
        }.ifEmpty { null }
    }

    companion object {
        fun isIncomplete(source: String): Boolean {
            val trimmed = source.trimEnd()
            if (trimmed.isEmpty()) return false

            val lastChar = trimmed.last()
            if (lastChar in listOf('\\')) return true

            var parens = 0; var brackets = 0; var braces = 0
            var inString = false; var escaped = false
            for (c in trimmed) {
                if (escaped) { escaped = false; continue }
                if (c == '\\') { escaped = true; continue }
                if (c == '"') { inString = !inString; continue }
                if (inString) continue
                when (c) {
                    '(' -> parens++; ')' -> parens--
                    '[' -> brackets++; ']' -> brackets--
                    '{' -> braces++; '}' -> braces--
                }
            }
            if (parens > 0 || brackets > 0 || braces > 0) return true

            val tokens = try {
                Lexer(trimmed, "<repl>").tokenize()
            } catch (_: Exception) { return false }

            val meaningful = tokens.filter { it.type != TokenType.NEWLINE && it.type != TokenType.EOF
                    && it.type != TokenType.INDENT && it.type != TokenType.DEDENT }
            if (meaningful.isEmpty()) return false

            val lastToken = meaningful.last()
            if (lastToken.type in listOf(
                    TokenType.FAT_ARROW, TokenType.THIN_ARROW, TokenType.PIPE_GT,
                    TokenType.PLUS, TokenType.MINUS, TokenType.STAR, TokenType.SLASH,
                    TokenType.COMMA, TokenType.ASSIGN,
                    TokenType.PLUS_ASSIGN, TokenType.MINUS_ASSIGN,
                    TokenType.STAR_ASSIGN, TokenType.SLASH_ASSIGN
                )) return true

            val hasIndent = tokens.any { it.type == TokenType.INDENT }
            val hasDedent = tokens.any { it.type == TokenType.DEDENT }
            if (hasIndent && !hasDedent) return true

            return false
        }
    }
}
