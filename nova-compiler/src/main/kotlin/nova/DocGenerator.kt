package nova

import nova.lexer.Lexer
import nova.parser.*
import nova.types.TypeInferer
import nova.types.NovaType
import java.io.File

class DocGenerator {

    data class DocItem(
        val kind: String,
        val name: String,
        val signature: String,
        val doc: String,
        val line: Int,
        val params: List<ParamDoc> = emptyList(),
        val returnType: String? = null,
        val fields: List<FieldDoc> = emptyList(),
        val variants: List<String> = emptyList(),
        val methods: List<String> = emptyList()
    )

    data class ParamDoc(val name: String, val type: String, val default: String? = null)
    data class FieldDoc(val name: String, val type: String)

    data class ModuleDoc(
        val name: String,
        val path: String,
        val items: List<DocItem>,
        val imports: List<String>
    )

    fun generate(path: File, outputDir: File): Int {
        val sourceFiles = discoverSources(path)
        if (sourceFiles.isEmpty()) {
            println("nova doc: no .nova files found in ${path.absolutePath}")
            return 1
        }

        outputDir.mkdirs()
        val modules = mutableListOf<ModuleDoc>()

        for (file in sourceFiles) {
            val mod = extractModule(file) ?: continue
            modules.add(mod)
        }

        val indexHtml = generateIndex(modules, path.name)
        File(outputDir, "index.html").writeText(indexHtml)

        for (mod in modules) {
            val html = generateModulePage(mod)
            File(outputDir, "${mod.name}.html").writeText(html)
        }

        val cssFile = File(outputDir, "style.css")
        cssFile.writeText(CSS)

        println("nova doc: generated ${modules.size} module docs in ${outputDir.absolutePath}")
        println("  ${modules.sumOf { it.items.size }} documented items")
        println("  Open ${File(outputDir, "index.html").absolutePath}")
        return 0
    }

    private fun discoverSources(path: File): List<File> {
        if (path.isFile && path.extension == "nova") return listOf(path)
        if (!path.isDirectory) return emptyList()
        return path.walkTopDown()
            .filter { it.isFile && it.extension == "nova" && !it.name.endsWith("_test.nova") && !it.name.startsWith("test_") }
            .sortedBy { it.name }
            .toList()
    }

    private fun extractModule(file: File): ModuleDoc? {
        val source = file.readText()
        val tokens = try { Lexer(source, file.name).tokenize() } catch (_: Exception) { return null }
        val parser = Parser(tokens)
        val program = parser.parse()
        if (parser.errors.isNotEmpty()) return null

        val nodeTypes = try {
            TypeInferer().infer(program).nodeTypes
        } catch (_: Exception) { emptyMap() }

        val items = mutableListOf<DocItem>()
        val imports = mutableListOf<String>()
        val lines = source.lines()

        for (stmt in program.stmts) {
            when (stmt) {
                is ImportStmt -> imports.add(stmt.path.joinToString("."))
                is FnDecl -> {
                    if (stmt.name.startsWith("_")) continue
                    val doc = extractDocComment(lines, stmt.span.start.line - 1)
                    val params = stmt.params.map { p ->
                        ParamDoc(p.name, prettyType(p.type), if (p.default != null) prettyExpr(p.default) else null)
                    }
                    val ret = if (stmt.returnType != null) prettyType(stmt.returnType) else inferredReturn(stmt, nodeTypes)
                    val sig = buildFnSignature(stmt.name, params, ret)
                    items.add(DocItem("function", stmt.name, sig, doc, stmt.span.start.line,
                        params = params, returnType = ret))
                }
                is TypeDecl -> {
                    if (stmt.name.startsWith("_")) continue
                    val doc = extractDocComment(lines, stmt.span.start.line - 1)
                    val fields = stmt.fields.map { FieldDoc(it.name, prettyType(it.type)) }
                    items.add(DocItem("type", stmt.name,
                        "type ${stmt.name} { ${fields.joinToString(", ") { "${it.name}: ${it.type}" }} }",
                        doc, stmt.span.start.line, fields = fields))
                }
                is EnumDecl -> {
                    if (stmt.name.startsWith("_")) continue
                    val doc = extractDocComment(lines, stmt.span.start.line - 1)
                    val variants = stmt.variants.map { v ->
                        if (v.fields.isEmpty()) v.name
                        else "${v.name}(${v.fields.joinToString(", ") { "${it.name}: ${prettyType(it.type)}" }})"
                    }
                    items.add(DocItem("enum", stmt.name,
                        "enum ${stmt.name} = ${variants.joinToString(" | ")}",
                        doc, stmt.span.start.line, variants = variants))
                }
                is TraitDecl -> {
                    if (stmt.name.startsWith("_")) continue
                    val doc = extractDocComment(lines, stmt.span.start.line - 1)
                    val methods = stmt.methods.map { m ->
                        "fn ${m.name}(${m.params.joinToString(", ") { it.name }})"
                    }
                    items.add(DocItem("trait", stmt.name,
                        "trait ${stmt.name}", doc, stmt.span.start.line, methods = methods))
                }
                else -> {}
            }
        }

        if (items.isEmpty()) return null
        return ModuleDoc(file.nameWithoutExtension, file.path, items, imports)
    }

    private fun extractDocComment(lines: List<String>, lineIdx: Int): String {
        val docLines = mutableListOf<String>()
        var i = lineIdx - 1
        while (i >= 0) {
            val trimmed = lines[i].trim()
            if (trimmed.startsWith("//")) {
                val content = trimmed.removePrefix("//").trimStart()
                docLines.add(0, content)
                i--
            } else break
        }
        return docLines.joinToString("\n")
    }

    private fun prettyType(t: TypeExpr?): String = when (t) {
        null -> "any"
        is NamedType -> t.name
        is GenericType -> "${t.name}<${t.args.joinToString(", ") { prettyType(it) }}>"
        is UnionType -> "${prettyType(t.left)} | ${prettyType(t.right)}"
        is OptionalType -> "${prettyType(t.inner)}?"
        else -> t.toString()
    }

    private fun prettyExpr(e: Expr?): String = when (e) {
        is IntLit -> e.value.toString()
        is FloatLit -> e.value.toString()
        is StringLit -> "\"${e.value}\""
        is BoolLit -> e.value.toString()
        is Ident -> e.name
        null -> "?"
        else -> "..."
    }

    private fun inferredReturn(fn: FnDecl, nodeTypes: Map<Expr, NovaType>): String? {
        return null
    }

    private fun buildFnSignature(name: String, params: List<ParamDoc>, ret: String?): String {
        val paramStr = params.joinToString(", ") { p ->
            val d = if (p.default != null) " = ${p.default}" else ""
            "${p.name}: ${p.type}$d"
        }
        val retStr = if (ret != null) " -> $ret" else ""
        return "fn $name($paramStr)$retStr"
    }

    private fun prettyType(t: Field): String = prettyType(t.type)

    private fun generateIndex(modules: List<ModuleDoc>, projectName: String): String = buildString {
        appendLine("<!DOCTYPE html><html lang=\"en\"><head>")
        appendLine("<meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">")
        appendLine("<title>$projectName — NOVA Documentation</title>")
        appendLine("<link rel=\"stylesheet\" href=\"style.css\">")
        appendLine("</head><body>")
        appendLine("<header><h1>$projectName</h1><p class=\"subtitle\">NOVA Documentation</p></header>")
        appendLine("<main>")
        appendLine("<section class=\"module-list\">")
        appendLine("<h2>Modules</h2>")
        for (mod in modules) {
            val fnCount = mod.items.count { it.kind == "function" }
            val typeCount = mod.items.count { it.kind == "type" || it.kind == "enum" }
            appendLine("<div class=\"module-card\">")
            appendLine("<a href=\"${mod.name}.html\"><h3>${mod.name}</h3></a>")
            appendLine("<p>$fnCount functions, $typeCount types</p>")
            val firstDoc = mod.items.firstOrNull { it.doc.isNotEmpty() }?.doc?.take(120)
            if (firstDoc != null) appendLine("<p class=\"preview\">$firstDoc</p>")
            appendLine("</div>")
        }
        appendLine("</section>")

        val totalFn = modules.sumOf { m -> m.items.count { it.kind == "function" } }
        val totalType = modules.sumOf { m -> m.items.count { it.kind == "type" || it.kind == "enum" } }
        appendLine("<section class=\"stats\">")
        appendLine("<p>${modules.size} modules &middot; $totalFn functions &middot; $totalType types</p>")
        appendLine("<p>Generated by <code>nova doc</code></p>")
        appendLine("</section>")
        appendLine("</main></body></html>")
    }

    private fun generateModulePage(mod: ModuleDoc): String = buildString {
        appendLine("<!DOCTYPE html><html lang=\"en\"><head>")
        appendLine("<meta charset=\"UTF-8\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\">")
        appendLine("<title>${mod.name} — NOVA Documentation</title>")
        appendLine("<link rel=\"stylesheet\" href=\"style.css\">")
        appendLine("</head><body>")
        appendLine("<header><a href=\"index.html\">&larr; Back</a><h1>${mod.name}</h1></header>")
        appendLine("<main>")

        if (mod.imports.isNotEmpty()) {
            appendLine("<section class=\"imports\"><h2>Imports</h2><ul>")
            for (imp in mod.imports) appendLine("<li><code>import $imp</code></li>")
            appendLine("</ul></section>")
        }

        val functions = mod.items.filter { it.kind == "function" }
        val types = mod.items.filter { it.kind == "type" }
        val enums = mod.items.filter { it.kind == "enum" }
        val traits = mod.items.filter { it.kind == "trait" }

        if (functions.isNotEmpty()) {
            appendLine("<section><h2>Functions</h2>")
            appendLine("<nav class=\"toc\">")
            for (f in functions) appendLine("<a href=\"#${f.name}\">${f.name}</a>")
            appendLine("</nav>")
            for (f in functions) {
                appendLine("<div class=\"item\" id=\"${f.name}\">")
                appendLine("<pre class=\"signature\">${escHtml(f.signature)}</pre>")
                if (f.doc.isNotEmpty()) appendLine("<div class=\"doc\">${markdownToHtml(f.doc)}</div>")
                if (f.params.isNotEmpty()) {
                    appendLine("<table class=\"params\"><tr><th>Parameter</th><th>Type</th><th>Default</th></tr>")
                    for (p in f.params) {
                        val def = p.default ?: ""
                        appendLine("<tr><td><code>${p.name}</code></td><td><code>${escHtml(p.type)}</code></td><td>${escHtml(def)}</td></tr>")
                    }
                    appendLine("</table>")
                }
                if (f.returnType != null) {
                    appendLine("<p class=\"returns\">Returns: <code>${escHtml(f.returnType)}</code></p>")
                }
                appendLine("<p class=\"line\">Line ${f.line}</p>")
                appendLine("</div>")
            }
            appendLine("</section>")
        }

        if (types.isNotEmpty()) {
            appendLine("<section><h2>Types</h2>")
            for (t in types) {
                appendLine("<div class=\"item\" id=\"${t.name}\">")
                appendLine("<pre class=\"signature\">${escHtml(t.signature)}</pre>")
                if (t.doc.isNotEmpty()) appendLine("<div class=\"doc\">${markdownToHtml(t.doc)}</div>")
                if (t.fields.isNotEmpty()) {
                    appendLine("<table class=\"params\"><tr><th>Field</th><th>Type</th></tr>")
                    for (f in t.fields) appendLine("<tr><td><code>${f.name}</code></td><td><code>${escHtml(f.type)}</code></td></tr>")
                    appendLine("</table>")
                }
                appendLine("</div>")
            }
            appendLine("</section>")
        }

        if (enums.isNotEmpty()) {
            appendLine("<section><h2>Enums</h2>")
            for (e in enums) {
                appendLine("<div class=\"item\" id=\"${e.name}\">")
                appendLine("<pre class=\"signature\">${escHtml(e.signature)}</pre>")
                if (e.doc.isNotEmpty()) appendLine("<div class=\"doc\">${markdownToHtml(e.doc)}</div>")
                if (e.variants.isNotEmpty()) {
                    appendLine("<ul class=\"variants\">")
                    for (v in e.variants) appendLine("<li><code>${escHtml(v)}</code></li>")
                    appendLine("</ul>")
                }
                appendLine("</div>")
            }
            appendLine("</section>")
        }

        if (traits.isNotEmpty()) {
            appendLine("<section><h2>Traits</h2>")
            for (tr in traits) {
                appendLine("<div class=\"item\" id=\"${tr.name}\">")
                appendLine("<pre class=\"signature\">${escHtml(tr.signature)}</pre>")
                if (tr.doc.isNotEmpty()) appendLine("<div class=\"doc\">${markdownToHtml(tr.doc)}</div>")
                if (tr.methods.isNotEmpty()) {
                    appendLine("<ul class=\"methods\">")
                    for (m in tr.methods) appendLine("<li><code>${escHtml(m)}</code></li>")
                    appendLine("</ul>")
                }
                appendLine("</div>")
            }
            appendLine("</section>")
        }

        appendLine("</main></body></html>")
    }

    private fun escHtml(s: String) = s
        .replace("&", "&amp;")
        .replace("<", "&lt;")
        .replace(">", "&gt;")
        .replace("\"", "&quot;")

    private fun markdownToHtml(md: String): String {
        return md.lines().joinToString("<br>") { line ->
            var l = escHtml(line)
            l = l.replace(Regex("`([^`]+)`"), "<code>$1</code>")
            l = l.replace(Regex("\\*\\*([^*]+)\\*\\*"), "<strong>$1</strong>")
            l = l.replace(Regex("\\*([^*]+)\\*"), "<em>$1</em>")
            l
        }
    }

    companion object {
        val CSS = """
:root { --bg: #0d1117; --fg: #c9d1d9; --accent: #58a6ff; --card: #161b22; --border: #30363d; --sig: #1f6feb; }
* { margin: 0; padding: 0; box-sizing: border-box; }
body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif; background: var(--bg); color: var(--fg); line-height: 1.6; }
header { padding: 2rem; border-bottom: 1px solid var(--border); }
header h1 { color: var(--accent); font-size: 1.8rem; }
header a { color: var(--accent); text-decoration: none; }
.subtitle { color: #8b949e; }
main { max-width: 960px; margin: 0 auto; padding: 2rem; }
h2 { color: var(--accent); border-bottom: 1px solid var(--border); padding-bottom: 0.5rem; margin: 2rem 0 1rem; }
.module-list { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 1rem; }
.module-list h2 { grid-column: 1 / -1; }
.module-card { background: var(--card); border: 1px solid var(--border); border-radius: 8px; padding: 1.2rem; }
.module-card h3 { color: var(--accent); margin-bottom: 0.3rem; }
.module-card a { color: inherit; text-decoration: none; }
.module-card p { color: #8b949e; font-size: 0.9rem; }
.preview { font-style: italic; margin-top: 0.5rem; }
.stats { text-align: center; margin-top: 3rem; color: #8b949e; }
.item { background: var(--card); border: 1px solid var(--border); border-radius: 8px; padding: 1.2rem; margin-bottom: 1rem; }
.signature { background: #0d1117; color: #79c0ff; padding: 0.8rem; border-radius: 4px; font-size: 0.95rem; overflow-x: auto; }
.doc { margin: 0.8rem 0; color: #c9d1d9; }
.params { width: 100%; border-collapse: collapse; margin: 0.8rem 0; }
.params th { text-align: left; color: #8b949e; border-bottom: 1px solid var(--border); padding: 0.4rem 0.8rem; font-size: 0.85rem; }
.params td { padding: 0.4rem 0.8rem; border-bottom: 1px solid var(--border); }
.returns { color: #8b949e; font-size: 0.9rem; }
.line { color: #484f58; font-size: 0.8rem; text-align: right; }
nav.toc { display: flex; flex-wrap: wrap; gap: 0.5rem; margin-bottom: 1rem; }
nav.toc a { color: var(--accent); background: var(--card); border: 1px solid var(--border); padding: 0.2rem 0.6rem; border-radius: 4px; text-decoration: none; font-size: 0.85rem; }
nav.toc a:hover { background: var(--border); }
.imports ul { list-style: none; }
.imports li { color: #8b949e; }
.variants, .methods { list-style: none; margin: 0.5rem 0; }
.variants li, .methods li { padding: 0.2rem 0; }
code { background: #1f2937; padding: 0.1rem 0.3rem; border-radius: 3px; font-size: 0.9em; }
""".trimIndent()
    }
}
