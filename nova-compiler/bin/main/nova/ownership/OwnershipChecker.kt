package nova.ownership

import nova.lexer.SourceSpan
import nova.parser.*
import nova.types.*

// ── Public result ─────────────────────────────────────────────────────────────

data class OwnershipError(val message: String, val span: SourceSpan) {
    override fun toString() = "$span: $message"
}

data class OwnershipResult(val errors: List<OwnershipError>)

// ── Variable state ────────────────────────────────────────────────────────────

private sealed class VarState
private object Live : VarState()
private data class Moved(val sendSpan: SourceSpan) : VarState()

// ── Per-variable record ───────────────────────────────────────────────────────
//
// processDepth: the spawn depth at which the variable was defined.
// A variable is only moveable from code at the same depth.
// Variables from shallower depths (outer processes) are implicitly copied — never moved.

private data class VarInfo(val state: VarState, val depth: Int)

// ── OwnershipChecker ──────────────────────────────────────────────────────────
//
// Single-pass AST walk. Tracks per-variable ownership state and reports:
//   - Use-after-send: variable used in expression after being sent.
//   - Double-send: variable sent a second time after already moved.
//
// Integrates with TypeInferer output so channels can be detected (channels are
// always copied, never moved — Rule 2 exception from the spec).

class OwnershipChecker(
    private val nodeTypes: Map<Expr, NovaType> = emptyMap()
) {

    private val errors = mutableListOf<OwnershipError>()

    // Scope stack: variable name → VarInfo. Innermost frame is first.
    private val scope = ArrayDeque<MutableMap<String, VarInfo>>()

    // Current spawn nesting depth. 0 = root process.
    private var processDepth = 0

    // ── Entry point ───────────────────────────────────────────────────────────

    fun check(program: Program): OwnershipResult {
        pushScope()
        for (stmt in program.stmts) checkStmt(stmt)
        popScope()
        return OwnershipResult(errors.toList())
    }

    // ── Scope helpers ─────────────────────────────────────────────────────────

    private fun pushScope() { scope.addFirst(mutableMapOf()) }
    private fun popScope()  { scope.removeFirst() }

    private fun define(name: String) {
        // Fresh definition (or reassignment) resets state to Live at current depth.
        scope.first()[name] = VarInfo(Live, processDepth)
    }

    private fun lookup(name: String): VarInfo? {
        for (frame in scope) {
            frame[name]?.let { return it }
        }
        return null
    }

    // Mark a variable as moved. Only applies if the variable was defined at the
    // current processDepth — outer-process variables are implicitly copied, not moved.
    private fun markMoved(name: String, at: SourceSpan) {
        for (frame in scope) {
            val info = frame[name] ?: continue
            if (info.depth == processDepth) {
                frame[name] = info.copy(state = Moved(at))
            }
            // Else: outer-process variable — implicit copy, leave it Live.
            return
        }
    }

    // ── Type helpers ──────────────────────────────────────────────────────────

    // Channels are always copied, never moved (both sender and receiver need the handle).
    private fun isChannel(expr: Expr): Boolean =
        nodeTypes[expr]?.let { it is TChannel } ?: false

    // Primitives are always bit-copied — no move semantics needed.
    private fun isPrimitive(expr: Expr): Boolean = when (nodeTypes[expr]) {
        TInt, TFloat, TString, TBool, TByte -> true
        else -> false
    }

    // A value is "always safe" (never needs move semantics):
    //   - channels (both sides need the handle)
    //   - primitives (bit copy is free)
    //   - literals (no variable identity)
    private fun isAlwaysCopied(expr: Expr): Boolean =
        isChannel(expr) || isPrimitive(expr) || isLiteral(expr)

    private fun isLiteral(expr: Expr): Boolean = expr is IntLit || expr is FloatLit
        || expr is StringLit || expr is BoolLit || expr is RawStringLit
        || expr is TupleLit  || expr is ListLit  || expr is RecordLit || expr is DictLit
        || expr is StringInterp

    // ── Live-use check ────────────────────────────────────────────────────────

    private fun assertLive(name: String, useSpan: SourceSpan) {
        val info = lookup(name) ?: return  // unknown variable (stdlib, external) — skip
        val state = info.state
        if (state is Moved) {
            errors.add(OwnershipError(
                "can't use `$name` here — it was sent on line ${state.sendSpan.start.line}. " +
                "To keep it, write `copy($name)`",
                useSpan
            ))
        }
    }

    // ── Move semantics ────────────────────────────────────────────────────────
    //
    // Called when 'expr' is passed as the VALUE argument to send(), or as a
    // non-copy spawn argument. If expr is an Ident, mark the variable as moved.

    private fun moveExpr(expr: Expr, sendSpan: SourceSpan) {
        if (isAlwaysCopied(expr)) {
            // Channels, primitives, and literals are never moved — just check they're live.
            checkExpr(expr)
            return
        }
        when (expr) {
            is Ident -> {
                val info = lookup(expr.name)
                if (info != null && info.depth == processDepth) {
                    val state = info.state
                    if (state is Moved) {
                        errors.add(OwnershipError(
                            "`${expr.name}` was already sent on line ${state.sendSpan.start.line} — " +
                            "can't send it again. Use `copy(${expr.name})` to send a copy",
                            sendSpan
                        ))
                        return
                    }
                    // Mark as moved.
                    markMoved(expr.name, sendSpan)
                } else {
                    // Outer-process variable or unknown: implicit copy, assert it's live.
                    assertLive(expr.name, expr.span)
                }
            }
            // Non-Ident complex expressions (tuples, calls, etc.): check sub-expressions.
            // The result is a temporary — no variable identity to track.
            else -> checkExpr(expr)
        }
    }

    // ── Expression checking ───────────────────────────────────────────────────

    private fun checkExpr(expr: Expr) {
        when (expr) {

            is Ident -> assertLive(expr.name, expr.span)

            is Call -> checkCall(expr)

            is MemberAccess -> checkExpr(expr.target)
            is Index        -> { checkExpr(expr.target); checkExpr(expr.index) }
            is Slice        -> { checkExpr(expr.target); expr.start?.let { checkExpr(it) }; expr.end?.let { checkExpr(it) } }

            is BinaryOp -> { checkExpr(expr.left); checkExpr(expr.right) }
            is UnaryOp  -> checkExpr(expr.operand)
            is ElseOp   -> { checkExpr(expr.expr); checkExpr(expr.default) }

            is IfExpr -> {
                checkExpr(expr.condition)
                checkExpr(expr.thenExpr)
                expr.elseExpr?.let { checkExpr(it) }
            }

            is IfBlockExpr -> {
                checkExpr(expr.condition)
                pushScope(); checkBlock(expr.thenBlock); popScope()
                when (val ec = expr.elseClause) {
                    is ElseBlock -> { pushScope(); checkBlock(ec.body); popScope() }
                    is ElseIf    -> checkExpr(ec.ifExpr)
                    null         -> {}
                }
            }

            is ForExpr -> {
                checkExpr(expr.iterable)
                pushScope()
                bindPattern(expr.variable)
                checkForBody(expr.body)
                popScope()
            }

            is MatchExpr -> {
                checkExpr(expr.subject)
                for (arm in expr.arms) {
                    pushScope()
                    bindPattern(arm.pattern)
                    checkForBody(arm.body)
                    popScope()
                }
            }

            is Lambda -> {
                pushScope()
                for (p in expr.params) define(p.name)
                checkForBody(expr.body)
                popScope()
            }

            is TupleLit   -> expr.elements.forEach { checkExpr(it) }
            is ListLit    -> expr.elements.forEach { checkExpr(it) }
            is RecordLit  -> expr.fields.forEach { checkExpr(it.value) }
            is DictLit    -> expr.entries.forEach { (k, v) -> checkExpr(k); checkExpr(v) }
            is StructLit  -> expr.fields.forEach { checkExpr(it.value) }
            is StringInterp -> expr.parts.filterIsInstance<ExprPart>().forEach { checkExpr(it.expr) }

            // spawn in expression position: block capture = implicit copy (no move).
            is SpawnExpr -> {
                processDepth++
                pushScope()
                checkExpr(expr.expr)
                popScope()
                processDepth--
            }

            is ReceiveExpr -> checkExpr(expr.channel)
            is ReturnExpr  -> expr.value?.let { checkExpr(it) }

            is TryExpr -> checkExpr(expr.expr)
            is TryCatchExpr -> {
                checkExpr(expr.expr)
                pushScope()
                checkBlock(expr.handler)
                popScope()
            }

            // Literals and atoms — nothing to check.
            is IntLit, is FloatLit, is StringLit, is BoolLit, is RawStringLit -> {}
            is ErrorExpr -> {}
        }
    }

    // ── Call handling ─────────────────────────────────────────────────────────

    private fun checkCall(expr: Call) {
        val callee = expr.callee
        val args   = expr.args

        when {
            // send(ch, value): channel arg is read-only (never moved), value is moved.
            callee is Ident && callee.name == "send" && args.size >= 2 -> {
                checkExpr(args[0].value)            // channel: check live, never move
                moveExpr(args[1].value, expr.span)  // value: moved
            }

            // copy(x): explicit copy. x is read (asserts live), never moved.
            callee is Ident && callee.name == "copy" && args.size == 1 -> {
                checkExpr(args[0].value)
            }

            // supervise(worker, ...): worker process handle is read, named args are primitives.
            callee is Ident && callee.name == "supervise" -> {
                for (a in args) checkExpr(a.value)
            }

            // Regular call: check callee and all arguments. Arguments are NOT moved —
            // function calls pass by value (COW) within the same process.
            else -> {
                checkExpr(callee)
                for (a in args) checkExpr(a.value)
            }
        }
    }

    // ── Statement checking ────────────────────────────────────────────────────

    private fun checkStmt(stmt: Stmt) {
        when (stmt) {

            is FnDecl -> {
                // Function bodies are checked in their own scope.
                // Outer-scope variables captured by the function are NOT moved
                // (functions are closures — they get copies on call).
                pushScope()
                for (p in stmt.params) define(p.name)
                checkBlock(stmt.body)
                popScope()
            }

            is AssignStmt -> {
                // Check the RHS first (it might use variables about to be re-defined).
                checkExpr(stmt.value)
                when {
                    stmt.op == "=" && stmt.target is Ident -> {
                        // Fresh assignment (or reassignment): reset variable to Live.
                        define(stmt.target.name)
                    }
                    stmt.op == "=" -> {
                        // Complex LHS (member, index): check it's live, no move.
                        checkExpr(stmt.target)
                    }
                    else -> {
                        // Compound assignment (+=, -=, ...): LHS must be live.
                        checkExpr(stmt.target)
                    }
                }
            }

            is ExprStmt -> checkExpr(stmt.expr)

            is ReturnStmt -> stmt.value?.let { checkExpr(it) }

            is ForStmt -> {
                checkExpr(stmt.iterable)
                pushScope()
                bindPattern(stmt.variable)
                checkBlock(stmt.body)
                popScope()
            }

            is WhileStmt -> {
                checkExpr(stmt.condition)
                pushScope()
                checkBlock(stmt.body)
                popScope()
            }

            // spawn expr — `spawn fn(arg1, arg2)`: arguments ARE moved to child.
            // This is spawn-as-expression-call, e.g. `spawn http_worker()`.
            is SpawnStmt -> {
                val innerExpr = stmt.expr
                if (innerExpr is Call) {
                    // Call args cross the process boundary: move each non-channel, non-primitive arg.
                    checkExpr(innerExpr.callee)
                    processDepth++
                    for (a in innerExpr.args) moveExpr(a.value, stmt.span)
                    processDepth--
                } else {
                    // Non-call spawn expression (rare): just check it.
                    processDepth++
                    checkExpr(innerExpr)
                    processDepth--
                }
            }

            // spawn BLOCK: captured variables are implicit copies — no move tracking.
            is SpawnBlockStmt -> {
                processDepth++
                pushScope()
                checkBlock(stmt.body)
                popScope()
                processDepth--
            }

            is AnnotatedStmt -> checkStmt(stmt.stmt)
            is LowLevelBlock -> checkBlock(stmt.body)  // @low_level: handles are opaque, skip move tracking

            is YieldStmt -> checkExpr(stmt.value)
            is BreakStmt, is ContinueStmt -> {}
            is TypeDecl, is EnumDecl, is TraitDecl, is ImportStmt, is ErrorStmt -> {}
        }
    }

    private fun checkBlock(block: Block) {
        for (stmt in block.stmts) checkStmt(stmt)
    }

    private fun checkForBody(body: ForExprBody) = when (body) {
        is ExprBody  -> checkExpr(body.expr)
        is BlockBody -> checkBlock(body.block)
    }

    private fun bindPattern(pat: Pattern) {
        when (pat) {
            is IdentPat      -> define(pat.name)
            is WildcardPat   -> {}
            is TuplePat      -> pat.elements.forEach { bindPattern(it) }
            is ConstructorPat -> pat.arg?.let { bindPattern(it) }
            is LiteralPat    -> {}
        }
    }
}
