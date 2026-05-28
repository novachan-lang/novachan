package nova.lsp

class LspServer {
    private val rpc = JsonRpc(System.`in`, System.out)
    private val analyzer = LspAnalyzer()
    private var initialized = false
    private var shutdown = false

    fun run() {
        System.err.println("NOVA LSP Server starting...")
        while (!shutdown) {
            val msg = rpc.readMessage() ?: break
            handleMessage(msg)
        }
        System.err.println("NOVA LSP Server stopped.")
    }

    @Suppress("UNCHECKED_CAST")
    private fun handleMessage(msg: Map<String, Any?>) {
        val method = msg["method"] as? String
        val id = msg["id"]
        val params = msg["params"] as? Map<String, Any?> ?: emptyMap()

        when (method) {
            "initialize" -> handleInitialize(id, params)
            "initialized" -> { initialized = true }
            "shutdown" -> { shutdown = true; rpc.sendResponse(id, null) }
            "exit" -> System.exit(if (shutdown) 0 else 1)
            "textDocument/didOpen" -> handleDidOpen(params)
            "textDocument/didChange" -> handleDidChange(params)
            "textDocument/didClose" -> handleDidClose(params)
            "textDocument/didSave" -> handleDidSave(params)
            "textDocument/hover" -> handleHover(id, params)
            "textDocument/definition" -> handleDefinition(id, params)
            "textDocument/completion" -> handleCompletion(id, params)
            "textDocument/documentSymbol" -> handleDocumentSymbol(id, params)
            else -> {
                if (id != null) {
                    rpc.sendError(id, -32601, "Method not found: $method")
                }
            }
        }
    }

    private fun handleInitialize(id: Any?, params: Map<String, Any?>) {
        val capabilities = mapOf(
            "textDocumentSync" to mapOf(
                "openClose" to true,
                "change" to 1,
                "save" to mapOf("includeText" to true)
            ),
            "hoverProvider" to true,
            "definitionProvider" to true,
            "completionProvider" to mapOf(
                "triggerCharacters" to listOf(".", "("),
                "resolveProvider" to false
            ),
            "documentSymbolProvider" to true
        )
        rpc.sendResponse(id, mapOf(
            "capabilities" to capabilities,
            "serverInfo" to mapOf("name" to "nova-lsp", "version" to "0.1.0")
        ))
    }

    @Suppress("UNCHECKED_CAST")
    private fun handleDidOpen(params: Map<String, Any?>) {
        val doc = params["textDocument"] as? Map<String, Any?> ?: return
        val uri = doc["uri"] as? String ?: return
        val text = doc["text"] as? String ?: return
        analyzeAndPublish(uri, text)
    }

    @Suppress("UNCHECKED_CAST")
    private fun handleDidChange(params: Map<String, Any?>) {
        val doc = params["textDocument"] as? Map<String, Any?> ?: return
        val uri = doc["uri"] as? String ?: return
        val changes = params["contentChanges"] as? List<Map<String, Any?>> ?: return
        val text = changes.lastOrNull()?.get("text") as? String ?: return
        analyzeAndPublish(uri, text)
    }

    @Suppress("UNCHECKED_CAST")
    private fun handleDidClose(params: Map<String, Any?>) {
        val doc = params["textDocument"] as? Map<String, Any?> ?: return
        val uri = doc["uri"] as? String ?: return
        analyzer.removeDocument(uri)
        rpc.sendNotification("textDocument/publishDiagnostics", mapOf(
            "uri" to uri, "diagnostics" to emptyList<Any>()
        ))
    }

    @Suppress("UNCHECKED_CAST")
    private fun handleDidSave(params: Map<String, Any?>) {
        val doc = params["textDocument"] as? Map<String, Any?> ?: return
        val uri = doc["uri"] as? String ?: return
        val text = params["text"] as? String ?: return
        analyzeAndPublish(uri, text)
    }

    @Suppress("UNCHECKED_CAST")
    private fun handleHover(id: Any?, params: Map<String, Any?>) {
        val doc = params["textDocument"] as? Map<String, Any?> ?: run { rpc.sendResponse(id, null); return }
        val uri = doc["uri"] as? String ?: run { rpc.sendResponse(id, null); return }
        val pos = params["position"] as? Map<String, Any?> ?: run { rpc.sendResponse(id, null); return }
        val line = (pos["line"] as? Number)?.toInt() ?: run { rpc.sendResponse(id, null); return }
        val col = (pos["character"] as? Number)?.toInt() ?: run { rpc.sendResponse(id, null); return }

        val hover = analyzer.getHover(uri, line, col)
        if (hover != null) {
            rpc.sendResponse(id, mapOf(
                "contents" to mapOf("kind" to "markdown", "value" to hover.content)
            ))
        } else {
            rpc.sendResponse(id, null)
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun handleDefinition(id: Any?, params: Map<String, Any?>) {
        val doc = params["textDocument"] as? Map<String, Any?> ?: run { rpc.sendResponse(id, null); return }
        val uri = doc["uri"] as? String ?: run { rpc.sendResponse(id, null); return }
        val pos = params["position"] as? Map<String, Any?> ?: run { rpc.sendResponse(id, null); return }
        val line = (pos["line"] as? Number)?.toInt() ?: run { rpc.sendResponse(id, null); return }
        val col = (pos["character"] as? Number)?.toInt() ?: run { rpc.sendResponse(id, null); return }

        val loc = analyzer.getDefinition(uri, line, col)
        if (loc != null) {
            rpc.sendResponse(id, mapOf(
                "uri" to loc.uri,
                "range" to rangeOf(loc.line, loc.col, loc.line, loc.col + 1)
            ))
        } else {
            rpc.sendResponse(id, null)
        }
    }

    @Suppress("UNCHECKED_CAST")
    private fun handleCompletion(id: Any?, params: Map<String, Any?>) {
        val doc = params["textDocument"] as? Map<String, Any?> ?: run { rpc.sendResponse(id, emptyList<Any>()); return }
        val uri = doc["uri"] as? String ?: run { rpc.sendResponse(id, emptyList<Any>()); return }
        val pos = params["position"] as? Map<String, Any?> ?: run { rpc.sendResponse(id, emptyList<Any>()); return }
        val line = (pos["line"] as? Number)?.toInt() ?: 0
        val col = (pos["character"] as? Number)?.toInt() ?: 0

        val items = analyzer.getCompletions(uri, line, col)
        rpc.sendResponse(id, items)
    }

    @Suppress("UNCHECKED_CAST")
    private fun handleDocumentSymbol(id: Any?, params: Map<String, Any?>) {
        val doc = params["textDocument"] as? Map<String, Any?> ?: run { rpc.sendResponse(id, emptyList<Any>()); return }
        val uri = doc["uri"] as? String ?: run { rpc.sendResponse(id, emptyList<Any>()); return }

        val symbols = analyzer.getSymbols(uri)
        val result = symbols.map { sym ->
            mapOf(
                "name" to sym.name,
                "kind" to sym.kind,
                "range" to rangeOf(sym.line, sym.col, sym.endLine, sym.endCol),
                "selectionRange" to rangeOf(sym.line, sym.col, sym.line, sym.col + sym.name.length)
            )
        }
        rpc.sendResponse(id, result)
    }

    private fun analyzeAndPublish(uri: String, text: String) {
        val result = analyzer.updateDocument(uri, text)
        val diagnostics = result.diagnostics.map { d ->
            mapOf(
                "range" to rangeOf(d.line, d.col, d.endLine, d.endCol),
                "severity" to d.severity,
                "source" to "nova",
                "message" to d.message
            )
        }
        rpc.sendNotification("textDocument/publishDiagnostics", mapOf(
            "uri" to uri, "diagnostics" to diagnostics
        ))
    }

    private fun rangeOf(sl: Int, sc: Int, el: Int, ec: Int) = mapOf(
        "start" to mapOf("line" to sl, "character" to sc),
        "end" to mapOf("line" to el, "character" to ec)
    )
}
