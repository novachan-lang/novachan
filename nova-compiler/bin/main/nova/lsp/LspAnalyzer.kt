package nova.lsp

import nova.lexer.Lexer
import nova.lexer.SourceSpan
import nova.parser.*
import nova.parser.NamedType
import nova.parser.GenericType
import nova.parser.UnionType
import nova.parser.OptionalType
import nova.types.TypeInferer
import nova.types.NovaType
import nova.types.Stdlib
import nova.error.DiagnosticPrinter
import java.io.File
import java.net.URI

class LspAnalyzer {

    data class AnalysisResult(
        val diagnostics: List<LspDiagnostic>,
        val program: Program?,
        val nodeTypes: Map<Expr, NovaType>
    )

    data class LspDiagnostic(
        val line: Int,
        val col: Int,
        val endLine: Int,
        val endCol: Int,
        val severity: Int,
        val message: String
    )

    data class SymbolInfo(
        val name: String,
        val kind: Int,
        val line: Int,
        val col: Int,
        val endLine: Int,
        val endCol: Int
    )

    data class HoverInfo(val content: String, val line: Int, val col: Int)

    data class LocationInfo(val uri: String, val line: Int, val col: Int)

    private val documents = mutableMapOf<String, String>()
    private val analyses = mutableMapOf<String, AnalysisResult>()

    fun updateDocument(uri: String, text: String): AnalysisResult {
        documents[uri] = text
        val result = analyze(uri, text)
        analyses[uri] = result
        return result
    }

    fun removeDocument(uri: String) {
        documents.remove(uri)
        analyses.remove(uri)
    }

    fun analyze(uri: String, text: String): AnalysisResult {
        val diagnostics = mutableListOf<LspDiagnostic>()
        val fileName = uriToName(uri)

        DiagnosticPrinter.registerSource(fileName, text)

        val tokens = try {
            Lexer(text, fileName).tokenize()
        } catch (e: Exception) {
            diagnostics.add(LspDiagnostic(0, 0, 0, 1, 1, "Lexer error: ${e.message}"))
            return AnalysisResult(diagnostics, null, emptyMap())
        }

        val parser = Parser(tokens)
        val program = parser.parse()
        for (err in parser.errors) {
            val span = err.span
            diagnostics.add(LspDiagnostic(
                span.start.line - 1, span.start.col - 1,
                span.end.line - 1, span.end.col - 1,
                1, err.message
            ))
        }
        if (parser.errors.isNotEmpty()) {
            return AnalysisResult(diagnostics, program, emptyMap())
        }

        val inferResult = try {
            TypeInferer().infer(program)
        } catch (e: Exception) {
            diagnostics.add(LspDiagnostic(0, 0, 0, 1, 2, "Type inference warning: ${e.message}"))
            return AnalysisResult(diagnostics, program, emptyMap())
        }

        for (err in inferResult.errors) {
            val span = err.span
            diagnostics.add(LspDiagnostic(
                span.start.line - 1, span.start.col - 1,
                span.end.line - 1, span.end.col - 1,
                1, err.message
            ))
        }

        return AnalysisResult(diagnostics, program, inferResult.nodeTypes)
    }

    fun getSymbols(uri: String): List<SymbolInfo> {
        val result = analyses[uri] ?: return emptyList()
        val program = result.program ?: return emptyList()
        val symbols = mutableListOf<SymbolInfo>()

        for (stmt in program.stmts) {
            when (stmt) {
                is FnDecl -> symbols.add(SymbolInfo(
                    stmt.name, 12,
                    stmt.span.start.line - 1, stmt.span.start.col - 1,
                    stmt.span.end.line - 1, stmt.span.end.col - 1
                ))
                is TypeDecl -> symbols.add(SymbolInfo(
                    stmt.name, 23,
                    stmt.span.start.line - 1, stmt.span.start.col - 1,
                    stmt.span.end.line - 1, stmt.span.end.col - 1
                ))
                is EnumDecl -> symbols.add(SymbolInfo(
                    stmt.name, 10,
                    stmt.span.start.line - 1, stmt.span.start.col - 1,
                    stmt.span.end.line - 1, stmt.span.end.col - 1
                ))
                is TraitDecl -> symbols.add(SymbolInfo(
                    stmt.name, 11,
                    stmt.span.start.line - 1, stmt.span.start.col - 1,
                    stmt.span.end.line - 1, stmt.span.end.col - 1
                ))
                is AssignStmt -> {
                    if (stmt.target is Ident) {
                        symbols.add(SymbolInfo(
                            (stmt.target as Ident).name, 13,
                            stmt.span.start.line - 1, stmt.span.start.col - 1,
                            stmt.span.end.line - 1, stmt.span.end.col - 1
                        ))
                    }
                }
                else -> {}
            }
        }
        return symbols
    }

    fun getHover(uri: String, line: Int, col: Int): HoverInfo? {
        val text = documents[uri] ?: return null
        val result = analyses[uri] ?: return null
        val program = result.program ?: return null

        val word = getWordAt(text, line, col) ?: return null

        val nodeType = findNodeTypeAt(result, line + 1, col + 1)
        if (nodeType != null) {
            return HoverInfo("```nova\n${word}: ${nodeType}\n```", line, col)
        }

        for (stmt in program.stmts) {
            if (stmt is FnDecl && stmt.name == word) {
                val params = stmt.params.joinToString(", ") { p ->
                    if (p.type != null) "${p.name}: ${prettyTypeExpr(p.type)}" else p.name
                }
                val ret = if (stmt.returnType != null) " -> ${prettyTypeExpr(stmt.returnType)}" else ""
                return HoverInfo("```nova\nfn ${stmt.name}($params)$ret\n```", line, col)
            }
            if (stmt is TypeDecl && stmt.name == word) {
                val fields = stmt.fields.joinToString(", ") { "${it.name}: ${it.type}" }
                return HoverInfo("```nova\ntype ${stmt.name} { $fields }\n```", line, col)
            }
            if (stmt is EnumDecl && stmt.name == word) {
                val variants = stmt.variants.joinToString(" | ") { it.name }
                return HoverInfo("```nova\nenum ${stmt.name} = $variants\n```", line, col)
            }
        }

        val stdlibType = Stdlib.functions[word]
        if (stdlibType != null) {
            return HoverInfo("```nova\n$word: ${stdlibType.body}\n```\n(stdlib)", line, col)
        }

        return null
    }

    fun getDefinition(uri: String, line: Int, col: Int): LocationInfo? {
        val text = documents[uri] ?: return null
        val result = analyses[uri] ?: return null
        val program = result.program ?: return null

        val word = getWordAt(text, line, col) ?: return null

        for (stmt in program.stmts) {
            when (stmt) {
                is FnDecl -> if (stmt.name == word)
                    return LocationInfo(uri, stmt.span.start.line - 1, stmt.span.start.col - 1)
                is TypeDecl -> if (stmt.name == word)
                    return LocationInfo(uri, stmt.span.start.line - 1, stmt.span.start.col - 1)
                is EnumDecl -> if (stmt.name == word)
                    return LocationInfo(uri, stmt.span.start.line - 1, stmt.span.start.col - 1)
                is AssignStmt -> if (stmt.target is Ident && (stmt.target as Ident).name == word)
                    return LocationInfo(uri, stmt.span.start.line - 1, stmt.span.start.col - 1)
                is ForStmt -> if (stmt.variable is IdentPat && (stmt.variable as IdentPat).name == word)
                    return LocationInfo(uri, stmt.span.start.line - 1, stmt.span.start.col - 1)
                else -> {}
            }
            if (stmt is FnDecl) {
                for (p in stmt.params) {
                    if (p.name == word) return LocationInfo(uri, stmt.span.start.line - 1, stmt.span.start.col - 1)
                }
                val localDef = findLocalDef(stmt.body, word)
                if (localDef != null) return LocationInfo(uri, localDef.start.line - 1, localDef.start.col - 1)
            }
        }
        return null
    }

    fun getCompletions(uri: String, line: Int, col: Int): List<Map<String, Any>> {
        val result = analyses[uri]
        val program = result?.program
        val items = mutableListOf<Map<String, Any>>()

        val keywords = listOf("fn", "let", "if", "else", "for", "while", "match", "return",
            "break", "continue", "type", "enum", "trait", "import", "spawn", "try",
            "in", "true", "false", "and", "or", "not", "yield")
        for (kw in keywords) {
            items.add(mapOf("label" to kw, "kind" to 14, "detail" to "keyword"))
        }

        for ((name, scheme) in Stdlib.functions) {
            items.add(mapOf("label" to name, "kind" to 3, "detail" to scheme.body.toString()))
        }

        if (program != null) {
            for (stmt in program.stmts) {
                when (stmt) {
                    is FnDecl -> items.add(mapOf(
                        "label" to stmt.name, "kind" to 3,
                        "detail" to "fn ${stmt.name}(${stmt.params.joinToString(", ") { it.name }})"
                    ))
                    is TypeDecl -> items.add(mapOf(
                        "label" to stmt.name, "kind" to 22, "detail" to "type ${stmt.name}"
                    ))
                    is EnumDecl -> items.add(mapOf(
                        "label" to stmt.name, "kind" to 13, "detail" to "enum ${stmt.name}"
                    ))
                    is AssignStmt -> if (stmt.target is Ident) {
                        items.add(mapOf(
                            "label" to (stmt.target as Ident).name, "kind" to 6, "detail" to "variable"
                        ))
                    }
                    else -> {}
                }
            }
        }
        return items
    }

    private fun findNodeTypeAt(result: AnalysisResult, line: Int, col: Int): NovaType? {
        for ((expr, type) in result.nodeTypes) {
            val s = expr.span
            if (s.start.line == line && col >= s.start.col && col <= s.end.col) return type
        }
        return null
    }

    private fun findLocalDef(body: Block, name: String): SourceSpan? {
        for (stmt in body.stmts) {
            if (stmt is AssignStmt && stmt.target is Ident && (stmt.target as Ident).name == name) {
                return stmt.span
            }
        }
        return null
    }

    private fun getWordAt(text: String, line: Int, col: Int): String? {
        val lines = text.lines()
        if (line < 0 || line >= lines.size) return null
        val ln = lines[line]
        if (col < 0 || col >= ln.length) return null
        var start = col
        while (start > 0 && isIdentChar(ln[start - 1])) start--
        var end = col
        while (end < ln.length && isIdentChar(ln[end])) end++
        if (start == end) return null
        return ln.substring(start, end)
    }

    private fun prettyTypeExpr(t: TypeExpr?): String = when (t) {
        null -> ""
        is NamedType -> t.name
        is GenericType -> "${t.name}<${t.args.joinToString(", ") { prettyTypeExpr(it) }}>"
        is UnionType -> "${prettyTypeExpr(t.left)} | ${prettyTypeExpr(t.right)}"
        is OptionalType -> "${prettyTypeExpr(t.inner)}?"
        else -> t.toString()
    }

    private fun isIdentChar(c: Char) = c.isLetterOrDigit() || c == '_'

    private fun uriToName(uri: String): String {
        return try {
            File(URI(uri)).name
        } catch (_: Exception) {
            uri.substringAfterLast("/").substringAfterLast("\\")
        }
    }
}
