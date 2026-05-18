package nova.interpreter

import nova.lexer.SourceSpan
import nova.parser.*
import java.util.concurrent.TimeUnit

// ── RuntimeError ──────────────────────────────────────────────────────────────

class RuntimeError(message: String, val span: SourceSpan? = null) : Exception(message)

// ── Interpreter ───────────────────────────────────────────────────────────────
//
// Tree-walking interpreter. Evaluates NOVA programs in the same JVM thread
// for simple programs; uses Java threads for spawn blocks/calls.
//
// stdout is captured via the `output` list so tests can verify it without
// intercepting System.out.

class Interpreter(
    val output: MutableList<String> = mutableListOf()
) {
    // Root environment: built-in stdlib functions pre-populated.
    private val globals = buildGlobals()

    // ── Entry point ───────────────────────────────────────────────────────────

    fun run(program: Program) {
        val env = globals.child()
        for (stmt in program.stmts) execStmt(stmt, env)
    }

    // Persistent env for REPL mode — survives across evaluations.
    val replEnv: Env = globals.child()

    fun runRepl(program: Program): NovaValue {
        var last: NovaValue = NUnit
        for (stmt in program.stmts) {
            if (stmt is ExprStmt) {
                last = evalExpr(stmt.expr, replEnv)
            } else {
                execStmt(stmt, replEnv)
                last = NUnit
            }
        }
        return last
    }

    // ── Statement execution ───────────────────────────────────────────────────

    fun execStmt(stmt: Stmt, env: Env) {
        when (stmt) {

            is FnDecl -> {
                val fn = NFn(
                    params = stmt.params.map { it.name },
                    body = AstBody(stmt.body),
                    closure = env
                )
                env.define(stmt.name, fn)
            }

            is TypeDecl -> {
                // Register a struct constructor function.
                val fieldNames = stmt.fields.map { it.name }
                val typeName = stmt.name
                env.define(typeName, NFn(
                    params = fieldNames,
                    body = NativeFn { args ->
                        NRecord(fieldNames.zip(args).toMap().toMutableMap())
                    },
                    closure = env
                ))
            }

            is EnumDecl -> {
                for (v in stmt.variants) {
                    val vname = v.name
                    val fieldNames = v.fields.map { it.name }
                    val value: NovaValue = if (fieldNames.isEmpty()) {
                        NRecord(mutableMapOf("__variant" to NString(vname)))
                    } else {
                        NFn(fieldNames, NativeFn { args ->
                            val m = mutableMapOf("__variant" to NString(vname) as NovaValue)
                            fieldNames.zip(args).forEach { (k, v) -> m[k] = v }
                            NRecord(m)
                        }, env)
                    }
                    env.define(vname, value)
                }
            }

            is ImportStmt -> { /* stdlib modules handled in globals — no-op for now */ }

            is TraitDecl -> { /* compile-time only — no runtime effect */ }

            is AssignStmt -> {
                val value = evalExpr(stmt.value, env)
                when {
                    stmt.op == "=" && stmt.target is Ident -> {
                        if (!env.set(stmt.target.name, value)) env.define(stmt.target.name, value)
                    }
                    stmt.op == "=" -> {
                        assignTarget(stmt.target, value, env)
                    }
                    else -> {
                        // Compound assignment (+=, -=, etc.)
                        val current = evalExpr(stmt.target, env)
                        val result = applyCompoundOp(stmt.op, current, value, stmt.span)
                        if (stmt.target is Ident) {
                            if (!env.set(stmt.target.name, result)) env.define(stmt.target.name, result)
                        } else {
                            assignTarget(stmt.target, result, env)
                        }
                    }
                }
            }

            is ExprStmt -> evalExpr(stmt.expr, env)

            is ReturnStmt -> {
                val v = stmt.value?.let { evalExpr(it, env) } ?: NUnit
                throw ReturnSignal(v)
            }

            is YieldStmt    -> { /* yield not supported in interpreter */ }
            is BreakStmt    -> throw BreakSignal()
            is ContinueStmt -> throw ContinueSignal()

            is ForStmt -> {
                val iter = evalExpr(stmt.iterable, env)
                try {
                    iterateValue(iter) { elem ->
                        val inner = env.child()
                        bindPattern(stmt.variable, elem, inner)
                        try { execBlock(stmt.body, inner) }
                        catch (_: ContinueSignal) { /* skip to next element */ }
                        // BreakSignal propagates out of iterateValue — caught below.
                    }
                } catch (_: BreakSignal) {}
            }

            is WhileStmt -> {
                while (true) {
                    val cond = evalExpr(stmt.condition, env)
                    if (cond != NBool(true)) break
                    val inner = env.child()
                    try { execBlock(stmt.body, inner) }
                    catch (_: BreakSignal) { break }
                    catch (_: ContinueSignal) { /* continue */ }
                }
            }

            is SpawnStmt -> {
                val thread = Thread {
                    try {
                        val child = globals.child()
                        evalExpr(stmt.expr, child)
                    } catch (_: ReturnSignal) {}
                    catch (e: RuntimeError) { System.err.println("spawn crashed: ${e.message}") }
                }
                thread.isDaemon = true
                thread.start()
            }

            is SpawnBlockStmt -> {
                val capturedEnv = env  // block captures outer env by reference (implicit copy semantics)
                val thread = Thread {
                    try { execBlock(stmt.body, capturedEnv.child()) }
                    catch (_: ReturnSignal) {}
                    catch (e: RuntimeError) { System.err.println("spawn block crashed: ${e.message}") }
                }
                thread.isDaemon = true
                thread.start()
            }

            is AnnotatedStmt -> execStmt(stmt.stmt, env)
            is LowLevelBlock -> execBlock(stmt.body, env)
            is ErrorStmt     -> throw RuntimeError(stmt.message)
        }
    }

    private fun execBlock(block: Block, env: Env): NovaValue {
        var last: NovaValue = NUnit
        for (stmt in block.stmts) {
            if (stmt is ExprStmt) {
                last = evalExpr(stmt.expr, env)
            } else {
                execStmt(stmt, env)
                last = NUnit
            }
        }
        return last
    }

    // ── Expression evaluation ─────────────────────────────────────────────────

    fun evalExpr(expr: Expr, env: Env): NovaValue = when (expr) {

        is IntLit    -> NInt(expr.value)
        is FloatLit  -> NFloat(expr.value)
        is StringLit -> NString(expr.value)
        is BoolLit   -> NBool(expr.value)
        is RawStringLit -> NString(expr.value)

        is StringInterp -> {
            val sb = StringBuilder()
            for (part in expr.parts) when (part) {
                is StringPart -> sb.append(part.value)
                is ExprPart   -> sb.append(evalExpr(part.expr, env).toString())
            }
            NString(sb.toString())
        }

        is Ident -> env.lookup(expr.name)
            ?: throw RuntimeError("undefined variable '${expr.name}'", expr.span)

        is BinaryOp -> evalBinaryOp(expr, env)

        is UnaryOp -> when (expr.op) {
            "-"    -> negateValue(evalExpr(expr.operand, env), expr.span)
            "not"  -> NBool(!(evalExpr(expr.operand, env) as? NBool
                        ?: throw RuntimeError("not requires bool", expr.span)).v)
            "copy" -> deepCopy(evalExpr(expr.operand, env))
            else   -> evalExpr(expr.operand, env)
        }

        is ElseOp -> {
            val result = evalExpr(expr.expr, env)
            if (result is NError) evalExpr(expr.default, env) else result
        }

        is Call -> evalCall(expr, env)

        is Index -> {
            val target = evalExpr(expr.target, env)
            val idx = evalExpr(expr.index, env)
            indexValue(target, idx, expr.span)
        }

        is Slice -> {
            val target = evalExpr(expr.target, env)
            val start = if (expr.start != null) (evalExpr(expr.start, env) as NInt).v.toInt() else 0
            val end = if (expr.end != null) (evalExpr(expr.end, env) as NInt).v.toInt()
                      else when (target) { is NString -> target.v.length; is NList -> target.elems.size; else -> 0 }
            when (target) {
                is NString -> NString(target.v.substring(start.coerceAtLeast(0), end.coerceAtMost(target.v.length)))
                is NList -> NList(target.elems.subList(start.coerceAtLeast(0), end.coerceAtMost(target.elems.size)).toMutableList())
                else -> throw RuntimeError("cannot slice ${target::class.simpleName}", expr.span)
            }
        }

        is MemberAccess -> evalMemberAccess(expr, env)

        is Lambda -> NFn(
            params = expr.params.map { it.name },
            body = when (val b = expr.body) {
                is ExprBody  -> ExprFnBody(b.expr)
                is BlockBody -> AstBody(b.block)
            },
            closure = env
        )

        is IfExpr -> {
            val cond = evalExpr(expr.condition, env) as? NBool
                ?: throw RuntimeError("if condition must be bool", expr.condition.span)
            if (cond.v) evalExpr(expr.thenExpr, env)
            else expr.elseExpr?.let { evalExpr(it, env) } ?: NUnit
        }

        is IfBlockExpr -> {
            val cond = evalExpr(expr.condition, env) as? NBool
                ?: throw RuntimeError("if condition must be bool", expr.condition.span)
            if (cond.v) {
                execBlock(expr.thenBlock, env.child())
            } else {
                when (val ec = expr.elseClause) {
                    null -> NUnit
                    is ElseBlock -> execBlock(ec.body, env.child())
                    is ElseIf -> evalExpr(ec.ifExpr, env)
                }
            }
        }

        is ForExpr -> {
            val results = mutableListOf<NovaValue>()
            val iter = evalExpr(expr.iterable, env)
            iterateValue(iter) { elem ->
                val inner = env.child()
                bindPattern(expr.variable, elem, inner)
                val result = when (val b = expr.body) {
                    is ExprBody  -> evalExpr(b.expr, inner)
                    is BlockBody -> execBlock(b.block, inner)
                }
                results.add(result)
            }
            NList(results)
        }

        is MatchExpr -> evalMatchExpr(expr, env)

        is TupleLit -> NTuple(expr.elements.map { evalExpr(it, env) })

        is ListLit -> NList(expr.elements.map { evalExpr(it, env) }.toMutableList())

        is RecordLit -> NRecord(
            expr.fields.associate { it.name to evalExpr(it.value, env) }.toMutableMap()
        )

        is DictLit -> NDict(
            expr.entries.associate {
                val k = evalExpr(it.first, env)
                val v = evalExpr(it.second, env)
                k.toString() to v
            }.toMutableMap()
        )

        is StructLit -> NRecord(
            expr.fields.associate { it.name to evalExpr(it.value, env) }.toMutableMap()
        )

        is SpawnExpr -> {
            val capturedEnv = env
            val thread = Thread {
                try { evalExpr(expr.expr, capturedEnv.child()) }
                catch (_: ReturnSignal) {}
                catch (e: RuntimeError) { System.err.println("spawn expr crashed: ${e.message}") }
            }
            thread.isDaemon = true
            thread.start()
            NProcess(thread)
        }

        is ReceiveExpr -> {
            val ch = evalExpr(expr.channel, env) as? NChannel
                ?: throw RuntimeError("receive requires a channel", expr.channel.span)
            ch.queue.take()
        }

        is ReturnExpr -> {
            val v = expr.value?.let { evalExpr(it, env) } ?: NUnit
            throw ReturnSignal(v)
        }

        is ErrorExpr -> NError("parse error: ${expr.message}")

        is TryExpr -> {
            val result = evalExpr(expr.expr, env)
            if (result is NError) throw ReturnSignal(result)
            result
        }

        is TryCatchExpr -> {
            val result = evalExpr(expr.expr, env)
            if (result is NError) {
                val handlerEnv = env.child()
                handlerEnv.define(expr.errorVar, NString(result.msg))
                execBlock(expr.handler, handlerEnv)
            } else {
                result
            }
        }
    }

    // ── Binary operators ──────────────────────────────────────────────────────

    private fun evalBinaryOp(expr: BinaryOp, env: Env): NovaValue {
        val l = evalExpr(expr.left, env)
        val r = evalExpr(expr.right, env)
        return when (expr.op) {
            "+"  -> addValues(l, r, expr.span)
            "-"  -> numericOp(l, r, expr.span, Long::minus, Double::minus)
            "*"  -> numericOp(l, r, expr.span, Long::times, Double::times)
            "/"  -> divideValues(l, r, expr.span)
            "%"  -> when { l is NInt && r is NInt -> NInt(l.v % r.v)
                           else -> throw RuntimeError("% requires int operands", expr.span) }
            "**" -> when {
                l is NInt   && r is NInt   -> NInt(Math.pow(l.v.toDouble(), r.v.toDouble()).toLong())
                l is NFloat || r is NFloat ->
                    NFloat(Math.pow(toDouble(l, expr.span), toDouble(r, expr.span)))
                else -> throw RuntimeError("** requires numeric operands", expr.span)
            }
            ".." -> {
                val start = (l as? NInt)?.v ?: throw RuntimeError("range requires int", expr.span)
                val end   = (r as? NInt)?.v ?: throw RuntimeError("range requires int", expr.span)
                NRange(start, end)
            }
            "==" -> NBool(valuesEqual(l, r))
            "!=" -> NBool(!valuesEqual(l, r))
            "<"  -> NBool(compareValues(l, r, expr.span) < 0)
            ">"  -> NBool(compareValues(l, r, expr.span) > 0)
            "<=" -> NBool(compareValues(l, r, expr.span) <= 0)
            ">=" -> NBool(compareValues(l, r, expr.span) >= 0)
            "and" -> NBool((l as? NBool
                ?: throw RuntimeError("and requires bool", expr.span)).v
                && (r as? NBool ?: throw RuntimeError("and requires bool", expr.span)).v)
            "or"  -> NBool((l as? NBool
                ?: throw RuntimeError("or requires bool", expr.span)).v
                || (r as? NBool ?: throw RuntimeError("or requires bool", expr.span)).v)
            "|>"  -> {
                val fn = r as? NFn ?: throw RuntimeError("right side of |> must be function", expr.span)
                callFn(fn, listOf(l), expr.span)
            }
            else -> throw RuntimeError("unknown operator '${expr.op}'", expr.span)
        }
    }

    private fun addValues(l: NovaValue, r: NovaValue, span: SourceSpan): NovaValue = when {
        l is NInt    && r is NInt    -> NInt(l.v + r.v)
        l is NFloat  || r is NFloat  -> NFloat(toDouble(l, span) + toDouble(r, span))
        l is NString && r is NString -> NString(l.v + r.v)
        l is NList   && r is NList   -> NList((l.elems + r.elems).toMutableList())
        else -> throw RuntimeError("cannot add ${l::class.simpleName} and ${r::class.simpleName}", span)
    }

    private fun numericOp(l: NovaValue, r: NovaValue, span: SourceSpan,
                          iOp: (Long, Long) -> Long, fOp: (Double, Double) -> Double): NovaValue = when {
        l is NInt   && r is NInt   -> NInt(iOp(l.v, r.v))
        l is NFloat || r is NFloat -> NFloat(fOp(toDouble(l, span), toDouble(r, span)))
        else -> throw RuntimeError("numeric operation requires int or float", span)
    }

    private fun divideValues(l: NovaValue, r: NovaValue, span: SourceSpan): NovaValue = when {
        l is NInt   && r is NInt   -> { if (r.v == 0L) throw RuntimeError("division by zero", span); NInt(l.v / r.v) }
        l is NFloat || r is NFloat -> NFloat(toDouble(l, span) / toDouble(r, span))
        else -> throw RuntimeError("/ requires numeric operands", span)
    }

    private fun toDouble(v: NovaValue, span: SourceSpan) = when (v) {
        is NInt   -> v.v.toDouble()
        is NFloat -> v.v
        else -> throw RuntimeError("expected number, got ${v::class.simpleName}", span)
    }

    private fun negateValue(v: NovaValue, span: SourceSpan) = when (v) {
        is NInt   -> NInt(-v.v)
        is NFloat -> NFloat(-v.v)
        else -> throw RuntimeError("cannot negate ${v::class.simpleName}", span)
    }

    private fun valuesEqual(a: NovaValue, b: NovaValue): Boolean = when {
        a is NInt   && b is NInt   -> a.v == b.v
        a is NFloat && b is NFloat -> a.v == b.v
        a is NInt   && b is NFloat -> a.v.toDouble() == b.v
        a is NFloat && b is NInt   -> a.v == b.v.toDouble()
        a is NString && b is NString -> a.v == b.v
        a is NBool && b is NBool -> a.v == b.v
        a is NUnit && b is NUnit -> true
        a is NTuple && b is NTuple -> a.elems.size == b.elems.size &&
            a.elems.zip(b.elems).all { (x, y) -> valuesEqual(x, y) }
        else -> a == b
    }

    private fun compareValues(a: NovaValue, b: NovaValue, span: SourceSpan): Int = when {
        a is NInt   && b is NInt   -> a.v.compareTo(b.v)
        a is NFloat && b is NFloat -> a.v.compareTo(b.v)
        a is NInt   && b is NFloat -> a.v.toDouble().compareTo(b.v)
        a is NFloat && b is NInt   -> a.v.compareTo(b.v.toDouble())
        a is NString && b is NString -> a.v.compareTo(b.v)
        else -> throw RuntimeError("cannot compare ${a::class.simpleName} with ${b::class.simpleName}", span)
    }

    private fun applyCompoundOp(op: String, current: NovaValue, delta: NovaValue, span: SourceSpan): NovaValue = when (op) {
        "+=" -> addValues(current, delta, span)
        "-=" -> numericOp(current, delta, span, Long::minus, Double::minus)
        "*=" -> numericOp(current, delta, span, Long::times, Double::times)
        "/=" -> divideValues(current, delta, span)
        "%=" -> when { current is NInt && delta is NInt -> NInt(current.v % delta.v)
                       else -> throw RuntimeError("%= requires int", span) }
        else -> throw RuntimeError("unknown compound op $op", span)
    }

    // ── Function calls ────────────────────────────────────────────────────────

    private fun evalCall(expr: Call, env: Env): NovaValue {
        // Special built-ins that need access to env or special evaluation:
        val callee = expr.callee
        if (callee is Ident) {
            when (callee.name) {
                "send" -> {
                    if (expr.args.size < 2) throw RuntimeError("send requires 2 args", expr.span)
                    val ch = evalExpr(expr.args[0].value, env) as? NChannel
                        ?: throw RuntimeError("send: first arg must be channel", expr.span)
                    val value = evalExpr(expr.args[1].value, env)
                    ch.queue.put(value)
                    return NUnit
                }
                "receive" -> {
                    if (expr.args.isEmpty()) throw RuntimeError("receive requires channel arg", expr.span)
                    val ch = evalExpr(expr.args[0].value, env) as? NChannel
                        ?: throw RuntimeError("receive: arg must be channel", expr.span)
                    return ch.queue.take()
                }
                "channel" -> return NChannel()
                "spawn" -> {
                    if (expr.args.isEmpty()) throw RuntimeError("spawn requires expression", expr.span)
                    val body = expr.args[0].value
                    val capturedEnv = env
                    val thread = Thread {
                        try { evalExpr(body, capturedEnv.child()) }
                        catch (_: ReturnSignal) {}
                    }
                    thread.isDaemon = true
                    thread.start()
                    return NProcess(thread)
                }
                "supervise" -> {
                    // supervise(worker, restart="always", max_restarts=5, within=60) → NUnit
                    // For interpreter purposes, supervision is a no-op (just wait for the worker).
                    val worker = evalExpr(expr.args[0].value, env)
                    if (worker is NProcess) {
                        try { worker.thread.join(100) } catch (_: InterruptedException) {}
                    }
                    return NUnit
                }
                "cpu_count" -> return NInt(Runtime.getRuntime().availableProcessors().toLong())
            }
        }

        val fn = evalExpr(expr.callee, env)
        val args = expr.args.map { evalExpr(it.value, env) }
        return callFn(fn as? NFn
            ?: throw RuntimeError("${expr.callee} is not a function", expr.span), args, expr.span)
    }

    fun callFn(fn: NFn, args: List<NovaValue>, span: SourceSpan): NovaValue {
        val callEnv = fn.closure.child()
        fn.params.zip(args).forEach { (name, value) -> callEnv.define(name, value) }
        // Extra args are discarded; missing args get NUnit.
        if (args.size < fn.params.size) {
            fn.params.drop(args.size).forEach { callEnv.define(it, NUnit) }
        }
        return when (val body = fn.body) {
            is NativeFn   -> body.fn(args)
            is AstBody    -> {
                try { execBlock(body.block, callEnv) }
                catch (r: ReturnSignal) { r.value }
            }
            is ExprFnBody -> {
                try { evalExpr(body.expr, callEnv) }
                catch (r: ReturnSignal) { r.value }
            }
        }
    }

    // ── Member access ─────────────────────────────────────────────────────────

    private fun evalMemberAccess(expr: MemberAccess, env: Env): NovaValue {
        val target = evalExpr(expr.target, env)
        return when {
            // Record/struct field access
            target is NRecord -> target.fields[expr.member]
                ?: throw RuntimeError("no field '${expr.member}' on record $target", expr.span)

            // String methods
            target is NString -> when (expr.member) {
                "length" -> NInt(target.v.length.toLong())
                "len"    -> NFn(emptyList(), NativeFn { _ -> NInt(target.v.length.toLong()) }, env)
                "split"  -> NFn(listOf("sep"), NativeFn { args ->
                    val sep = (args.getOrNull(0) as? NString)?.v ?: " "
                    NList(target.v.split(sep).map { NString(it) as NovaValue }.toMutableList())
                }, env)
                "trim"   -> NFn(emptyList(), NativeFn { _ -> NString(target.v.trim()) }, env)
                "upper"  -> NFn(emptyList(), NativeFn { _ -> NString(target.v.uppercase()) }, env)
                "lower"  -> NFn(emptyList(), NativeFn { _ -> NString(target.v.lowercase()) }, env)
                "starts_with" -> NFn(listOf("prefix"), NativeFn { args ->
                    val prefix = (args[0] as NString).v
                    NBool(target.v.startsWith(prefix))
                }, env)
                "ends_with" -> NFn(listOf("suffix"), NativeFn { args ->
                    val suffix = (args[0] as NString).v
                    NBool(target.v.endsWith(suffix))
                }, env)
                "find" -> NFn(listOf("sub"), NativeFn { args ->
                    val sub = (args[0] as NString).v
                    NInt(target.v.indexOf(sub).toLong())
                }, env)
                "contains" -> NFn(listOf("sub"), NativeFn { args ->
                    val sub = (args[0] as NString).v
                    NBool(target.v.contains(sub))
                }, env)
                "replace" -> NFn(listOf("old", "new"), NativeFn { args ->
                    val old = (args[0] as NString).v
                    val new_ = (args[1] as NString).v
                    NString(target.v.replace(old, new_))
                }, env)
                "slice" -> NFn(listOf("start", "end"), NativeFn { args ->
                    val start = (args[0] as NInt).v.toInt().coerceAtLeast(0)
                    val end = (args[1] as NInt).v.toInt().coerceAtMost(target.v.length)
                    NString(target.v.substring(start, end))
                }, env)
                "chars" -> NFn(emptyList(), NativeFn { _ ->
                    NList(target.v.map { NString(it.toString()) as NovaValue }.toMutableList())
                }, env)
                else -> throw RuntimeError("string has no member '${expr.member}'", expr.span)
            }

            // List methods
            target is NList -> when (expr.member) {
                "length" -> NInt(target.elems.size.toLong())
                "len"    -> NFn(emptyList(), NativeFn { _ -> NInt(target.elems.size.toLong()) }, env)
                "map" -> NFn(listOf("fn"), NativeFn { args ->
                    val fn = args[0] as? NFn
                        ?: throw RuntimeError("map requires function", expr.span)
                    NList(target.elems.map { callFn(fn, listOf(it), expr.span) }.toMutableList())
                }, env)
                "filter" -> NFn(listOf("fn"), NativeFn { args ->
                    val fn = args[0] as? NFn
                        ?: throw RuntimeError("filter requires function", expr.span)
                    NList(target.elems.filter {
                        (callFn(fn, listOf(it), expr.span) as? NBool)?.v == true
                    }.toMutableList())
                }, env)
                "sum" -> NFn(emptyList(), NativeFn { _ ->
                    var total = 0L
                    var totalF = 0.0
                    var isFloat = false
                    for (e in target.elems) when (e) {
                        is NInt   -> { total += e.v; totalF += e.v }
                        is NFloat -> { isFloat = true; totalF += e.v }
                        else -> throw RuntimeError("sum requires numeric list", expr.span)
                    }
                    if (isFloat) NFloat(totalF) else NInt(total)
                }, env)
                "push" -> NFn(listOf("val"), NativeFn { args ->
                    target.elems.add(args[0]); NUnit
                }, env)
                "pop"  -> NFn(emptyList(), NativeFn { _ ->
                    if (target.elems.isEmpty()) NError("empty list") else target.elems.removeLast()
                }, env)
                "top"  -> NFn(listOf("n"), NativeFn { args ->
                    val n = (args[0] as? NInt)?.v?.toInt() ?: 1
                    NList(target.elems.take(n).toMutableList())
                }, env)
                "sort" -> NFn(emptyList(), NativeFn { _ ->
                    target.elems.sortWith(Comparator { a, b -> compareValues(a, b, expr.span) }); target
                }, env)
                "reverse" -> NFn(emptyList(), NativeFn { _ ->
                    NList(target.elems.reversed().toMutableList())
                }, env)
                "join" -> NFn(listOf("sep"), NativeFn { args ->
                    val sep = (args[0] as NString).v
                    NString(target.elems.joinToString(sep) { it.toString() })
                }, env)
                "contains" -> NFn(listOf("val"), NativeFn { args ->
                    NBool(target.elems.any { valuesEqual(it, args[0]) })
                }, env)
                else -> throw RuntimeError("list has no member '${expr.member}'", expr.span)
            }

            // Dict methods
            target is NDict -> when (expr.member) {
                "len"  -> NFn(emptyList(), NativeFn { _ -> NInt(target.entries.size.toLong()) }, env)
                "has"  -> NFn(listOf("key"), NativeFn { args ->
                    NBool(target.entries.containsKey((args[0] as NString).v))
                }, env)
                "del"  -> NFn(listOf("key"), NativeFn { args ->
                    target.entries.remove((args[0] as NString).v); NUnit
                }, env)
                "keys" -> NFn(emptyList(), NativeFn { _ ->
                    NList(target.entries.keys.map { NString(it) as NovaValue }.toMutableList())
                }, env)
                else -> throw RuntimeError("dict has no member '${expr.member}'", expr.span)
            }

            // Range
            target is NRange -> when (expr.member) {
                "length" -> NInt(maxOf(0, target.end - target.start))
                else -> throw RuntimeError("range has no member '${expr.member}'", expr.span)
            }

            else -> throw RuntimeError("${target::class.simpleName} has no member '${expr.member}'", expr.span)
        }
    }

    // ── Match expression ──────────────────────────────────────────────────────

    private fun evalMatchExpr(expr: MatchExpr, env: Env): NovaValue {
        val subject = evalExpr(expr.subject, env)
        for (arm in expr.arms) {
            val armEnv = env.child()
            if (matchPattern(arm.pattern, subject, armEnv)) {
                return when (val b = arm.body) {
                    is ExprBody  -> evalExpr(b.expr, armEnv)
                    is BlockBody -> execBlock(b.block, armEnv)
                }
            }
        }
        throw RuntimeError("no match arm matched $subject", expr.span)
    }

    // ── Pattern matching ──────────────────────────────────────────────────────

    private fun matchPattern(pat: Pattern, value: NovaValue, env: Env): Boolean {
        return when (pat) {
            is WildcardPat -> true
            is IdentPat    -> { env.define(pat.name, value); true }
            is LiteralPat  -> valuesEqual(evalExpr(pat.lit, env), value)
            is TuplePat    -> {
                if (value !is NTuple || value.elems.size != pat.elements.size) false
                else pat.elements.zip(value.elems).all { (p, v) -> matchPattern(p, v, env) }
            }
            is ConstructorPat -> {
                val rec = value as? NRecord ?: return false
                val variant = (rec.fields["__variant"] as? NString)?.v ?: return false
                if (variant != pat.name) return false
                if (pat.arg != null) {
                    val payload = rec.fields.entries.firstOrNull { it.key != "__variant" }?.value
                        ?: NUnit
                    matchPattern(pat.arg, payload, env)
                } else true
            }
        }
    }

    // ── Iteration ─────────────────────────────────────────────────────────────

    private fun iterateValue(v: NovaValue, action: (NovaValue) -> Unit) {
        when (v) {
            is NRange -> v.asSequence().forEach { action(NInt(it)) }
            is NList  -> v.elems.forEach { action(it) }
            else -> throw RuntimeError("cannot iterate over ${v::class.simpleName}")
        }
    }

    // ── Pattern binding ───────────────────────────────────────────────────────

    private fun bindPattern(pat: Pattern, value: NovaValue, env: Env) {
        when (pat) {
            is IdentPat   -> env.define(pat.name, value)
            is WildcardPat -> {}
            is TuplePat   -> {
                val tup = value as? NTuple
                    ?: throw RuntimeError("expected tuple for pattern, got ${value::class.simpleName}")
                if (tup.elems.size != pat.elements.size)
                    throw RuntimeError("tuple pattern size mismatch: ${pat.elements.size} vs ${tup.elems.size}")
                pat.elements.zip(tup.elems).forEach { (p, v) -> bindPattern(p, v, env) }
            }
            is ConstructorPat -> {
                val rec = value as? NRecord ?: return
                pat.arg?.let { bindPattern(it, rec.fields.entries.firstOrNull { it.key != "__variant" }?.value ?: NUnit, env) }
            }
            is LiteralPat -> {}
        }
    }

    // ── LHS assignment ────────────────────────────────────────────────────────

    private fun assignTarget(target: Expr, value: NovaValue, env: Env) {
        when (target) {
            is MemberAccess -> {
                val rec = evalExpr(target.target, env) as? NRecord
                    ?: throw RuntimeError("member assignment requires record")
                rec.fields[target.member] = value
            }
            is Index -> {
                val list = evalExpr(target.target, env) as? NList
                    ?: throw RuntimeError("index assignment requires list")
                val idx = (evalExpr(target.index, env) as? NInt)?.v?.toInt()
                    ?: throw RuntimeError("list index must be int")
                list.elems[idx] = value
            }
            is TupleLit -> {
                val tup = value as? NTuple
                    ?: throw RuntimeError("tuple destructuring requires tuple value")
                target.elements.zip(tup.elems).forEach { (t, v) -> assignTarget(t, v, env) }
            }
            is Ident -> { if (!env.set(target.name, value)) env.define(target.name, value) }
            else -> throw RuntimeError("invalid assignment target")
        }
    }

    // ── Deep copy ─────────────────────────────────────────────────────────────

    private fun deepCopy(v: NovaValue): NovaValue = when (v) {
        is NList   -> v.copy()
        is NRecord -> v.copy()
        is NTuple  -> NTuple(v.elems.map { deepCopy(it) })
        else       -> v   // primitives, channels, processes — shared by identity
    }

    // ── Index access ──────────────────────────────────────────────────────────

    private fun indexValue(target: NovaValue, idx: NovaValue, span: SourceSpan): NovaValue = when {
        target is NList && idx is NInt -> {
            val i = idx.v.toInt()
            if (i < 0 || i >= target.elems.size) throw RuntimeError("list index out of bounds: $i", span)
            target.elems[i]
        }
        target is NString && idx is NInt -> NString(target.v[idx.v.toInt()].toString())
        target is NRecord && idx is NString -> target.fields[idx.v]
            ?: throw RuntimeError("no field '${idx.v}'", span)
        else -> throw RuntimeError("cannot index ${target::class.simpleName} with ${idx::class.simpleName}", span)
    }

    // ── Globals: built-in stdlib ──────────────────────────────────────────────

    private fun buildGlobals(): Env {
        val env = Env()

        fun native(name: String, fn: (List<NovaValue>) -> NovaValue) {
            env.define(name, NFn(emptyList(), NativeFn(fn), env))
        }

        native("print") { args ->
            val line = args.joinToString(" ") { it.toString() }
            output.add(line)
            println(line)
            NUnit
        }

        native("read_file") { args ->
            (args.getOrNull(0) as? NString)?.v?.let { path ->
                try { NString(java.io.File(path).readText()) }
                catch (e: Exception) { NError(e.message ?: "file read error") }
            } ?: NError("read_file: expected string path")
        }

        native("write_file") { args ->
            val path    = (args.getOrNull(0) as? NString)?.v
            val content = (args.getOrNull(1) as? NString)?.v
            if (path == null || content == null) NError("write_file: expected (string, string)")
            else try { java.io.File(path).writeText(content); NUnit }
                 catch (e: Exception) { NError(e.message ?: "file write error") }
        }

        native("env") { args ->
            (args.getOrNull(0) as? NString)?.v?.let { key ->
                System.getenv(key)?.let { NString(it) } ?: NError("env var not found: $key")
            } ?: NError("env: expected string")
        }

        native("parse_int") { args ->
            (args.getOrNull(0) as? NString)?.v?.let { s ->
                s.toLongOrNull()?.let { NInt(it) } ?: NError("not a valid int: $s")
            } ?: NError("parse_int: expected string")
        }

        native("parse_float") { args ->
            (args.getOrNull(0) as? NString)?.v?.let { s ->
                s.toDoubleOrNull()?.let { NFloat(it) } ?: NError("not a valid float: $s")
            } ?: NError("parse_float: expected string")
        }

        native("byte") { args ->
            (args.getOrNull(0) as? NInt)?.v?.let { n -> NByte(n.toByte()) }
                ?: NError("byte: expected int")
        }

        native("fetch") { args ->
            // For interpreter: not a real HTTP fetch — returns NError (integration tested separately).
            NError("fetch not available in interpreter")
        }

        native("parse_json") { args ->
            // Minimal: not a real JSON parser. Return an NError for now.
            NError("parse_json not available in interpreter")
        }

        native("Error") { args ->
            val msg = (args[0] as? NString)?.v ?: args[0].toString()
            NError(msg)
        }

        native("cpu_count") { _ -> NInt(Runtime.getRuntime().availableProcessors().toLong()) }

        native("alloc") { args ->
            val size = (args[0] as? NInt)?.v ?: 0L
            NInt(size)  // opaque handle for @low_level
        }
        native("register_buffer") { _ -> NInt(0L) }
        native("buffer_push")     { _ -> NBool(true) }
        native("buffer_pop")      { _ -> NByte(0) }
        native("buffer_free")     { _ -> NUnit }
        native("db_query")        { _ -> NRecord(mutableMapOf("result" to NString("mock_data"))) }

        native("error") { _ -> NError("error") }

        native("int") { args ->
            when (val a = args[0]) {
                is NInt    -> a
                is NFloat  -> NInt(a.v.toLong())
                is NString -> a.v.toLongOrNull()?.let { NInt(it) } ?: NError("not a valid int: ${a.v}")
                is NBool   -> NInt(if (a.v) 1L else 0L)
                else       -> NError("int: unsupported type")
            }
        }

        native("float") { args ->
            when (val a = args[0]) {
                is NFloat  -> a
                is NInt    -> NFloat(a.v.toDouble())
                is NString -> a.v.toDoubleOrNull()?.let { NFloat(it) } ?: NError("not a valid float: ${a.v}")
                else       -> NError("float: unsupported type")
            }
        }

        native("str") { args ->
            NString(args[0].toString())
        }

        return env
    }
}
