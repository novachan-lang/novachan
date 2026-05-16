package nova.types

import nova.lexer.SourceSpan
import nova.parser.*

// ── Public result ─────────────────────────────────────────────────────────────

data class TypeError(val message: String, val span: SourceSpan) {
    override fun toString() = "$span: $message"
}

data class InferResult(
    val nodeTypes: Map<Expr, NovaType>,   // inferred type for every expression node
    val errors: List<TypeError>
)

// ── Constraint ────────────────────────────────────────────────────────────────
//
// Every constraint carries provenance (the AST span that generated it) so that
// unification failures produce error messages pointing to source locations.

private data class Constraint(val a: NovaType, val b: NovaType, val span: SourceSpan)

// ── TypeInferer ───────────────────────────────────────────────────────────────

class TypeInferer {

    private var nextId = 1
    private val env = TypeEnv()
    private val constraints = mutableListOf<Constraint>()
    private val errors = mutableListOf<TypeError>()
    private val nodeTypes = mutableMapOf<Expr, NovaType>()   // expr node → assigned TypeVar

    // Scope: variable name → TypeScheme (mutable stack of frames)
    private val scope = ArrayDeque<MutableMap<String, TypeScheme>>()

    // Module scope: alias → (function name → TypeScheme)
    // Populated when an import statement matches a known stdlib module.
    private val moduleScopes = mutableMapOf<String, Map<String, TypeScheme>>()

    // Current function return type variable — set while inferring a FnDecl body
    // so that ReturnExpr can constrain the return type correctly.
    private var currentReturnVar: NovaType? = null
    private var currentProgram: Program? = null

    // Struct field registry: struct name → field map
    private val structRegistry = mutableMapOf<String, Map<String, NovaType>>()
    // Method registry: struct name → (method name → mangled function name)
    val methodRegistry = mutableMapOf<String, MutableMap<String, String>>()

    // ── Entry point ───────────────────────────────────────────────────────────

    fun infer(program: Program): InferResult {
        currentProgram = program
        pushScope()
        for (stmt in program.stmts) inferStmt(stmt)
        popScope()
        solve()
        val resolved = nodeTypes.mapValues { (_, t) -> env.apply(t) }
        return InferResult(resolved, errors.toList())
    }

    // ── Fresh type variables ──────────────────────────────────────────────────

    private fun fresh(): TypeVar = TypeVar(nextId++)

    // Instantiate a TypeScheme: replace each quantified var id with a fresh var.
    private fun instantiate(scheme: TypeScheme): NovaType {
        if (scheme.quantified.isEmpty()) return scheme.body
        val subst = scheme.quantified.associateWith { fresh() }
        return substituteSchemeVars(scheme.body, subst)
    }

    private fun substituteSchemeVars(t: NovaType, subst: Map<Int, TypeVar>): NovaType = when (t) {
        is TypeVar  -> subst[t.id] ?: t   // key is the actual id (negative for Stdlib, positive for generalized)
        is TList    -> TList(substituteSchemeVars(t.elem, subst))
        is TDict    -> TDict(substituteSchemeVars(t.key, subst), substituteSchemeVars(t.value, subst))
        is TTuple   -> TTuple(t.elements.map { substituteSchemeVars(it, subst) })
        is TChannel -> TChannel(substituteSchemeVars(t.payload, subst))
        is TFn      -> TFn(t.params.map { substituteSchemeVars(it, subst) }, substituteSchemeVars(t.ret, subst))
        is TStruct  -> TStruct(t.name, t.fields.mapValues { substituteSchemeVars(it.value, subst) })
        is TRecord  -> TRecord(t.fields.mapValues { substituteSchemeVars(it.value, subst) })
        is TSumType -> TSumType(substituteSchemeVars(t.ok, subst), substituteSchemeVars(t.err, subst))
        is TProcess -> TProcess(substituteSchemeVars(t.yieldType, subst))
        else        -> t
    }

    // ── Scope management ──────────────────────────────────────────────────────

    private fun pushScope() { scope.addFirst(mutableMapOf()) }
    private fun popScope()  { scope.removeFirst() }

    private fun define(name: String, scheme: TypeScheme) {
        scope.first()[name] = scheme
    }

    private fun lookup(name: String): NovaType? {
        for (frame in scope) {
            val s = frame[name] ?: continue
            return instantiate(s)
        }
        return Stdlib.functions[name]?.let { instantiate(it) }
    }

    // ── Constraint emission ───────────────────────────────────────────────────

    private fun constrain(a: NovaType, b: NovaType, span: SourceSpan) {
        constraints.add(Constraint(a, b, span))
    }

    // ── Generalization (let-polymorphism) ─────────────────────────────────────
    //
    // After inferring the body of a function, we generalize all type variables
    // that appear in the inferred type but NOT in the enclosing scope (free vars).
    // This lets the same function be called at multiple types.

    private fun freeVarsInScope(): Set<Int> {
        val ids = mutableSetOf<Int>()
        // Called after popScope() — scope is now the outer scope. Collect free vars
        // from all outer frames so we don't over-generalize vars constrained by context.
        for (frame in scope) {
            for ((_, scheme) in frame) collectFreeVars(scheme.body, ids)
        }
        return ids
    }

    private fun collectFreeVars(t: NovaType, out: MutableSet<Int>) {
        when (val w = env.walk(t)) {
            is TypeVar  -> out.add(w.id)
            is TList    -> collectFreeVars(w.elem, out)
            is TDict    -> { collectFreeVars(w.key, out); collectFreeVars(w.value, out) }
            is TTuple   -> w.elements.forEach { collectFreeVars(it, out) }
            is TChannel -> collectFreeVars(w.payload, out)
            is TFn      -> { w.params.forEach { collectFreeVars(it, out) }; collectFreeVars(w.ret, out) }
            is TStruct  -> w.fields.values.forEach { collectFreeVars(it, out) }
            is TRecord  -> w.fields.values.forEach { collectFreeVars(it, out) }
            is TSumType -> { collectFreeVars(w.ok, out); collectFreeVars(w.err, out) }
            is TProcess -> collectFreeVars(w.yieldType, out)
            else        -> {}
        }
    }

    private fun generalize(t: NovaType): TypeScheme {
        val scopeFree = freeVarsInScope()
        val typeFree = mutableSetOf<Int>()
        collectFreeVars(t, typeFree)
        val quantified = typeFree - scopeFree
        return TypeScheme(quantified, t)
    }

    // ── Statement inference ───────────────────────────────────────────────────

    private fun inferStmt(stmt: Stmt): NovaType = when (stmt) {

        is FnDecl -> {
            val outerFree = mutableSetOf<Int>()
            for (frame in scope) {
                for ((_, s) in frame) collectFreeVars(s.body, outerFree)
            }

            val paramTypes = stmt.params.map { p ->
                val t = if (p.type != null) typeExprToType(p.type) else fresh()
                if (p.default != null) constrain(t, inferExpr(p.default), p.span)
                t
            }
            val retVar = if (stmt.returnType != null) typeExprToType(stmt.returnType) else fresh()

            val isMethod = stmt.receiverType != null
            val mangledName = if (isMethod) "${stmt.receiverType}__${stmt.name}" else stmt.name
            val selfType = if (isMethod) {
                val fields = structRegistry[stmt.receiverType!!]
                if (fields != null) TStruct(stmt.receiverType, fields)
                else TRecord(emptyMap())
            } else null

            val fullParamTypes = if (selfType != null) listOf(selfType) + paramTypes else paramTypes
            val fnType = TFn(fullParamTypes, retVar)

            define(mangledName, TypeScheme.mono(fnType))
            if (isMethod) {
                methodRegistry.getOrPut(stmt.receiverType!!) { mutableMapOf() }[stmt.name] = mangledName
            }

            val savedReturnVar = currentReturnVar
            currentReturnVar = retVar
            pushScope()
            if (selfType != null) {
                define("self", TypeScheme.mono(selfType))
            }
            stmt.params.zip(paramTypes).forEach { (p, pt) ->
                define(p.name, TypeScheme.mono(pt))
            }
            val bodyType = inferBlock(stmt.body)
            if (bodyType != TUnit || !blockContainsReturn(stmt.body)) {
                constrain(retVar, bodyType, stmt.body.span)
            }
            popScope()
            currentReturnVar = savedReturnVar

            solve()

            val typeFree = mutableSetOf<Int>()
            collectFreeVars(fnType, typeFree)
            val quantified = typeFree - outerFree
            val scheme = TypeScheme(quantified, fnType)
            define(mangledName, scheme)
            if (!isMethod) define(stmt.name, scheme)
            TUnit
        }

        is TypeDecl -> {
            val fieldTypes = stmt.fields.associate { f -> f.name to typeExprToType(f.type) }
            val structType = TStruct(stmt.name, fieldTypes)
            structRegistry[stmt.name] = fieldTypes
            define(stmt.name, TypeScheme.mono(TFn(fieldTypes.values.toList(), structType)))
            TUnit
        }

        is EnumDecl -> {
            // Each variant becomes a constructor in scope.
            for (v in stmt.variants) {
                val vFieldTypes = v.fields.map { typeExprToType(it.type) }
                val variantType = TStruct("${stmt.name}.${v.name}", v.fields.associate { it.name to typeExprToType(it.type) })
                val ctorType = TFn(vFieldTypes, variantType)
                define(v.name, TypeScheme.mono(ctorType))
            }
            TUnit
        }

        is ImportStmt -> {
            val moduleName = stmt.path.last()
            val moduleMap = Stdlib.modules[moduleName]
            if (moduleMap != null) {
                if (stmt.selectiveNames != null) {
                    // import math (gcd, lcm) — register functions directly in scope
                    for (fnName in stmt.selectiveNames) {
                        val scheme = moduleMap[fnName] ?: continue
                        define(fnName, scheme)
                    }
                } else {
                    // import math OR import math as m — register module in module scope
                    val alias = stmt.alias ?: moduleName
                    moduleScopes[alias] = moduleMap
                    // put a concrete (non-TypeVar) sentinel so Ident("math") resolves rather than leaving a TypeVar
                    define(alias, TypeScheme.mono(TRecord(emptyMap())))
                }
            }
            TUnit
        }

        is AssignStmt -> {
            val rhsType = inferExpr(stmt.value)
            when {
                stmt.op == "=" && stmt.target is Ident -> {
                    // Check if the variable is already defined in current scope.
                    val existing = scope.first()[stmt.target.name]
                    if (existing != null) {
                        constrain(instantiate(existing), rhsType, stmt.span)
                    } else {
                        define(stmt.target.name, TypeScheme.mono(rhsType))
                    }
                }
                stmt.op == "=" -> {
                    val lhsType = inferExpr(stmt.target)
                    constrain(lhsType, rhsType, stmt.span)
                }
                else -> {
                    // Compound assignment (+=, -=, etc.)
                    val lhsType = inferExpr(stmt.target)
                    constrain(lhsType, rhsType, stmt.span)
                    constrain(lhsType, TInt, stmt.span)   // simplified: only numeric
                }
            }
            TUnit
        }

        is ExprStmt      -> inferExpr(stmt.expr)  // returns expr type for inferBlock implicit-return
        is ReturnStmt    -> {
            val valType = stmt.value?.let { inferExpr(it) }
            if (valType != null && currentReturnVar != null) {
                constrain(currentReturnVar!!, valType, stmt.span)
            }
            TNothing
        }
        is BreakStmt     -> TUnit
        is ContinueStmt  -> TUnit

        is SpawnStmt -> {
            val t = inferExpr(stmt.expr)
            TProcess(t)
        }

        is SpawnBlockStmt -> {
            pushScope()
            inferBlock(stmt.body)
            popScope()
            TProcess(TUnit)
        }

        is ForStmt -> {
            val iterType = inferExpr(stmt.iterable)
            val elemVar = fresh()
            constrainIterable(iterType, elemVar, stmt.iterable.span)
            pushScope()
            bindPattern(stmt.variable, elemVar)
            inferBlock(stmt.body)
            popScope()
            TUnit
        }

        is WhileStmt -> {
            val condType = inferExpr(stmt.condition)
            constrain(condType, TBool, stmt.condition.span)
            pushScope()
            inferBlock(stmt.body)
            popScope()
            TUnit
        }

        is AnnotatedStmt -> inferStmt(stmt.stmt)
        is LowLevelBlock -> { inferBlock(stmt.body); TUnit }
        is ErrorStmt     -> TUnit
    }

    // ── Block inference ───────────────────────────────────────────────────────
    //
    // A block's type is the type of its last expression statement (implicit return).
    // If the last statement is not an ExprStmt, the block has type Unit.

    private fun inferBlock(block: Block): NovaType {
        var last: NovaType = TUnit
        for ((i, stmt) in block.stmts.withIndex()) {
            val t = inferStmt(stmt)
            last = when {
                i == block.stmts.lastIndex && stmt is ExprStmt -> t
                i == block.stmts.lastIndex && stmt is ReturnStmt -> TNothing
                else -> TUnit
            }
        }
        return last
    }

    // ── Expression inference ──────────────────────────────────────────────────

    private fun inferExpr(expr: Expr): NovaType {
        val t = inferExprInner(expr)
        nodeTypes[expr] = t
        return t
    }

    private fun inferExprInner(expr: Expr): NovaType = when (expr) {

        is IntLit    -> TInt
        is FloatLit  -> TFloat
        is StringLit -> TString
        is BoolLit   -> TBool
        is RawStringLit -> TString

        is StringInterp -> {
            for (part in expr.parts) {
                if (part is ExprPart) inferExpr(part.expr)
            }
            TString
        }

        is Ident -> lookup(expr.name) ?: run {
            val v = fresh()
            define(expr.name, TypeScheme.mono(v))
            v
        }

        is BinaryOp  -> inferBinaryOp(expr)

        is UnaryOp -> when (expr.op) {
            "-"    -> { val t = inferExpr(expr.operand); t }
            "not"  -> { constrain(inferExpr(expr.operand), TBool, expr.span); TBool }
            "copy" -> inferExpr(expr.operand)   // copy(x): same type as x
            else   -> inferExpr(expr.operand)
        }

        is ElseOp -> {
            // C4 rule: expr: T or E, default: T, result: T
            val okVar  = fresh()
            val errVar = fresh()
            val exprType = inferExpr(expr.expr)
            constrain(exprType, TSumType(okVar, errVar), expr.expr.span)
            val defaultType = inferExpr(expr.default)
            // default must match the ok branch OR be Nothing (return/diverge)
            constrain(defaultType, okVar, expr.default.span)
            okVar
        }

        is Call -> inferCall(expr)

        is Index -> {
            val targetType = inferExpr(expr.target)
            val indexType = inferExpr(expr.index)
            val elemVar = fresh()
            when (val walked = env.walk(targetType)) {
                is TDict -> {
                    constrain(indexType, walked.key, expr.index.span)
                    constrain(elemVar, walked.value, expr.span)
                }
                is TList -> {
                    constrain(indexType, TInt, expr.index.span)
                    constrain(elemVar, walked.elem, expr.span)
                }
                is TRecord -> {
                    if (expr.index is StringLit) {
                        val fieldName = (expr.index as StringLit).value
                        val fieldType = walked.fields[fieldName]
                        if (fieldType != null) constrain(elemVar, fieldType, expr.span)
                    }
                }
                is TStruct -> {
                    if (expr.index is StringLit) {
                        val fieldName = (expr.index as StringLit).value
                        val fieldType = walked.fields[fieldName]
                        if (fieldType != null) constrain(elemVar, fieldType, expr.span)
                    }
                }
                is TString -> {
                    constrain(indexType, TInt, expr.index.span)
                    constrain(elemVar, TString, expr.span)
                }
                else -> {
                    val resolvedIdx = env.walk(indexType)
                    if (resolvedIdx is TString || expr.index is StringLit) {
                        constrain(indexType, TString, expr.index.span)
                        constrain(targetType, TDict(TString, elemVar), expr.target.span)
                    } else if (resolvedIdx == TInt || expr.index is IntLit ||
                               expr.index is UnaryOp || expr.index is BinaryOp) {
                        constrain(indexType, TInt, expr.index.span)
                        constrain(targetType, TList(elemVar), expr.target.span)
                    }
                }
            }
            elemVar
        }

        is Slice -> {
            val targetType = inferExpr(expr.target)
            if (expr.start != null) constrain(inferExpr(expr.start), TInt, expr.start.span)
            if (expr.end != null) constrain(inferExpr(expr.end), TInt, expr.end.span)
            targetType
        }

        is MemberAccess -> inferMemberAccess(expr)

        is Lambda -> {
            val paramTypes = expr.params.map { fresh() }
            pushScope()
            expr.params.zip(paramTypes).forEach { (p, pt) ->
                define(p.name, TypeScheme.mono(pt))
            }
            val bodyType = when (val b = expr.body) {
                is ExprBody  -> inferExpr(b.expr)
                is BlockBody -> inferBlock(b.block)
            }
            popScope()
            TFn(paramTypes, bodyType)
        }

        is IfExpr -> {
            constrain(inferExpr(expr.condition), TBool, expr.condition.span)
            val thenType = inferExpr(expr.thenExpr)
            if (expr.elseExpr == null) {
                TUnit
            } else {
                val elseType = inferExpr(expr.elseExpr)
                val result = fresh()
                constrain(result, thenType, expr.thenExpr.span)
                constrain(result, elseType, expr.elseExpr.span)
                result
            }
        }

        is IfBlockExpr -> {
            constrain(inferExpr(expr.condition), TBool, expr.condition.span)
            pushScope()
            val thenType = inferBlock(expr.thenBlock)
            popScope()
            val elseType: NovaType = when (val ec = expr.elseClause) {
                null           -> TUnit
                is ElseBlock   -> { pushScope(); val t = inferBlock(ec.body); popScope(); t }
                is ElseIf      -> inferExpr(ec.ifExpr)
            }
            if (expr.elseClause == null) TUnit
            else {
                val result = fresh()
                constrain(result, thenType, expr.thenBlock.span)
                constrain(result, elseType, expr.span)
                result
            }
        }

        is ForExpr -> {
            val iterType = inferExpr(expr.iterable)
            val elemVar = fresh()
            constrainIterable(iterType, elemVar, expr.iterable.span)
            pushScope()
            bindPattern(expr.variable, elemVar)
            val bodyType = when (val b = expr.body) {
                is ExprBody  -> inferExpr(b.expr)
                is BlockBody -> inferBlock(b.block)
            }
            popScope()
            TList(bodyType)   // for-expr collects results into a List
        }

        is MatchExpr -> inferMatchExpr(expr)

        is TupleLit -> TTuple(expr.elements.map { inferExpr(it) })

        is ListLit -> {
            val elemVar = fresh()
            for (e in expr.elements) constrain(inferExpr(e), elemVar, e.span)
            TList(elemVar)
        }

        is RecordLit -> {
            val fields = expr.fields.associate { f -> f.name to inferExpr(f.value) }
            TRecord(fields)
        }

        is DictLit -> {
            if (expr.entries.isNotEmpty() && expr.entries.all { (k, _) -> k is StringLit }) {
                val fields = expr.entries.associate { (k, v) -> (k as StringLit).value to inferExpr(v) }
                TRecord(fields)
            } else {
                val valVar = fresh()
                for ((_, v) in expr.entries) constrain(inferExpr(v), valVar, v.span)
                TDict(TString, valVar)
            }
        }

        is StructLit -> {
            val fields = expr.fields.associate { f -> f.name to inferExpr(f.value) }
            if (expr.typeName in structRegistry) TStruct(expr.typeName, fields) else TRecord(fields)
        }

        is SpawnExpr -> TProcess(inferExpr(expr.expr))

        is ReceiveExpr -> {
            val chType = inferExpr(expr.channel)
            val payloadVar = fresh()
            constrain(chType, TChannel(payloadVar), expr.channel.span)
            payloadVar
        }

        is ReturnExpr -> {
            val valType = expr.value?.let { inferExpr(it) }
            // Constrain the enclosing function's return variable so that callers
            // can resolve the return type through the generalized scheme.
            if (valType != null && currentReturnVar != null) {
                constrain(currentReturnVar!!, valType, expr.span)
            }
            TNothing   // return itself diverges — unifies with any branch type
        }

        is ErrorExpr -> fresh()   // parse error recovery — any type

        is TryExpr -> {
            // try expr — same type as the inner expression; errors propagate to caller
            inferExpr(expr.expr)
        }

        is TryCatchExpr -> {
            // expr catch e { block }
            // The expression may error; if it does, the handler runs with e: Str.
            // Result type unifies the ok-path type and the handler block type.
            val exprType = inferExpr(expr.expr)
            pushScope()
            define(expr.errorVar, TypeScheme.mono(TString))  // e is the error message string
            val handlerType = inferBlock(expr.handler)
            popScope()
            val result = fresh()
            constrain(result, exprType, expr.span)
            // handler type must match too (or diverge via return/TNothing)
            if (handlerType != TNothing) constrain(result, handlerType, expr.handler.span)
            result
        }
    }

    // ── Binary operator inference ─────────────────────────────────────────────

    private fun inferBinaryOp(expr: BinaryOp): NovaType {
        val l = inferExpr(expr.left)
        val r = inferExpr(expr.right)
        return when (expr.op) {
            "+", "-", "*", "/" -> {
                // Numeric: if either side is float, result is float; else int.
                // We model this with a single unification: l = r = result.
                val result = fresh()
                constrain(l, result, expr.left.span)
                constrain(r, result, expr.right.span)
                result
            }
            "%" -> {
                constrain(l, TInt, expr.left.span)
                constrain(r, TInt, expr.right.span)
                TInt
            }
            "**" -> {
                // float ** int or int ** int → float (conservative)
                val result = fresh()
                constrain(l, result, expr.left.span)
                result
            }
            ".." -> {
                constrain(l, TInt, expr.left.span)
                constrain(r, TInt, expr.right.span)
                TRange
            }
            "==", "!=" -> { constrain(l, r, expr.span); TBool }
            "<", ">", "<=", ">=" -> { constrain(l, r, expr.span); TBool }
            "and", "or" -> {
                constrain(l, TBool, expr.left.span)
                constrain(r, TBool, expr.right.span)
                TBool
            }
            "in" -> TBool
            "|>" -> {
                // l |> fn: fn must be callable with l
                val result = fresh()
                constrain(r, TFn(listOf(l), result), expr.span)
                result
            }
            else -> fresh()
        }
    }

    // ── Call inference ────────────────────────────────────────────────────────

    private fun inferCall(expr: Call): NovaType {
        val calleeType = inferExpr(expr.callee)
        val argTypes = expr.args.map { inferExpr(it.value) }.toMutableList()
        // Pad with default value types for functions with defaults
        if (expr.callee is Ident) {
            val fnDecl = currentProgram?.stmts?.filterIsInstance<FnDecl>()
                ?.find { it.name == (expr.callee as Ident).name }
            if (fnDecl != null && argTypes.size < fnDecl.params.size) {
                for (i in argTypes.size until fnDecl.params.size) {
                    val def = fnDecl.params[i].default ?: break
                    argTypes.add(inferExpr(def))
                }
            }
        }
        val retVar = fresh()
        constrain(calleeType, TFn(argTypes, retVar), expr.span)
        if (expr.callee is MemberAccess) {
            val walked = env.walk(calleeType)
            if (walked is TFn) {
                val resolvedRet = env.walk(walked.ret)
                if (resolvedRet !is TypeVar) return resolvedRet
            }
        }
        return retVar
    }

    // ── Member access inference ───────────────────────────────────────────────

    private fun inferMemberAccess(expr: MemberAccess): NovaType {
        // Fast path: qualified module call like math.gcd(...) or list.sum(...)
        if (expr.target is Ident) {
            val modMap = moduleScopes[(expr.target as Ident).name]
            if (modMap != null) {
                inferExpr(expr.target)   // populate nodeTypes for the Ident
                val scheme = modMap[expr.member]
                if (scheme != null) return instantiate(scheme)
            }
        }

        val targetType = inferExpr(expr.target)
        return when (val tw = env.walk(targetType)) {
            TString -> when (expr.member) {
                "length" -> TInt
                "split"  -> Stdlib.STRING_SPLIT
                else     -> fresh()
            }
            TRange -> when (expr.member) {
                "length" -> TInt
                else     -> fresh()
            }
            is TList -> when (expr.member) {
                "length" -> TInt
                "map"    -> { val r = fresh(); Stdlib.listMap(tw.elem, r) }
                "filter" -> Stdlib.listFilter(tw.elem)
                "sum"    -> Stdlib.listSum()
                "top"    -> Stdlib.listTop(tw.elem)
                "push", "append" -> TFn(listOf(tw.elem), TUnit)
                "concat" -> TFn(listOf(TList(tw.elem)), TList(tw.elem))
                "reverse" -> TFn(emptyList(), TList(tw.elem))
                "sort" -> TFn(emptyList(), TList(tw.elem))
                "join" -> TFn(listOf(TString), TString)
                else     -> fresh()
            }
            is TStruct -> {
                val fieldType = tw.fields[expr.member]
                if (fieldType != null) fieldType
                else {
                    val mangledName = methodRegistry[tw.name]?.get(expr.member)
                    if (mangledName != null) {
                        val fnType = lookup(mangledName)
                        if (fnType is TFn && fnType.params.isNotEmpty()) TFn(fnType.params.drop(1), fnType.ret)
                        else fnType ?: fresh()
                    } else fresh()
                }
            }
            is TRecord -> tw.fields[expr.member] ?: fresh()
            else -> fresh()   // unknown — leave as TypeVar for later resolution
        }
    }

    // ── Match expression inference ────────────────────────────────────────────

    private fun inferMatchExpr(expr: MatchExpr): NovaType {
        val subjType = inferExpr(expr.subject)
        val resultVar = fresh()

        for (arm in expr.arms) {
            pushScope()
            bindPattern(arm.pattern, subjType)
            val armType = when (val b = arm.body) {
                is ExprBody  -> inferExpr(b.expr)
                is BlockBody -> inferBlock(b.block)
            }
            constrain(resultVar, armType, arm.span)
            popScope()
        }
        return resultVar
    }

    // ── Pattern binding ───────────────────────────────────────────────────────

    private fun bindPattern(pat: Pattern, type: NovaType) {
        when (pat) {
            is WildcardPat -> {}   // _ binds nothing
            is IdentPat    -> define(pat.name, TypeScheme.mono(type))
            is TuplePat    -> {
                val elemVars = pat.elements.map { fresh() }
                constrain(type, TTuple(elemVars), pat.span)
                pat.elements.zip(elemVars).forEach { (p, v) -> bindPattern(p, v) }
            }
            is ConstructorPat -> {
                // Constructor pattern: binds the inner payload if present.
                if (pat.arg != null) {
                    val payloadVar = fresh()
                    bindPattern(pat.arg, payloadVar)
                }
            }
            is LiteralPat -> {
                val litType = inferExpr(pat.lit)
                constrain(type, litType, pat.span)
            }
        }
    }

    // ── Iterable constraint ───────────────────────────────────────────────────
    //
    // Both List<T> and Range are iterable. We add a disjunctive constraint by
    // trying List first; if the iterable is Range, we use TInt as the element type.

    private fun constrainIterable(iterType: NovaType, elemVar: TypeVar, span: SourceSpan) {
        val walked = env.walk(iterType)
        when (walked) {
            TRange         -> constrain(elemVar, TInt, span)
            is TList       -> constrain(elemVar, walked.elem, span)
            is TDict       -> constrain(elemVar, walked.key, span)
            is TRecord     -> constrain(elemVar, TString, span)
            is TypeVar     -> constrain(walked, TList(elemVar), span)
            else           -> constrain(iterType, TList(elemVar), span)
        }
    }

    // ── Type annotation to NovaType ───────────────────────────────────────────

    private fun typeExprToType(te: TypeExpr): NovaType = when (te) {
        is NamedType  -> when (te.name) {
            "int"    -> TInt;   "float"  -> TFloat;  "string" -> TString
            "bool"   -> TBool;  "byte"   -> TByte;   "Unit"   -> TUnit
            else     -> lookup(te.name) ?: fresh()
        }
        is GenericType -> when (te.name) {
            "List"    -> TList(if (te.args.isNotEmpty()) typeExprToType(te.args[0]) else fresh())
            "Dict"    -> TDict(
                if (te.args.isNotEmpty()) typeExprToType(te.args[0]) else fresh(),
                if (te.args.size > 1) typeExprToType(te.args[1]) else fresh()
            )
            "Channel" -> TChannel(if (te.args.isNotEmpty()) typeExprToType(te.args[0]) else fresh())
            else      -> lookup(te.name) ?: fresh()
        }
        is UnionType  -> TSumType(typeExprToType(te.left), typeExprToType(te.right))
        is OptionalType -> TSumType(typeExprToType(te.inner), TUnit)
    }

    // ── Error hints ───────────────────────────────────────────────────────────

    private fun typeMismatchHint(got: NovaType, expected: NovaType): String? = when {
        got == TInt    && expected == TString -> "use str(value) to convert int to string"
        got == TFloat  && expected == TString -> "use str(value) to convert float to string"
        got == TBool   && expected == TString -> "use str(value) to convert bool to string"
        got == TString && expected == TInt    -> "use parse_int(s) to convert string to int"
        got == TString && expected == TFloat  -> "use parse_float(s) to convert string to float"
        got == TInt    && expected == TFloat  -> "int is automatically promoted to float in arithmetic"
        got == TFloat  && expected == TInt    -> "use int(value) to truncate float to int"
        got is TList   && expected == TString -> "use str(list) or join the list with a separator"
        else -> null
    }

    // ── Unification solver ────────────────────────────────────────────────────

    private var solvedUpTo = 0

    private fun solve() {
        while (solvedUpTo < constraints.size) {
            val c = constraints[solvedUpTo]
            unify(c.a, c.b, c.span)
            solvedUpTo++
        }
    }

    private fun blockContainsReturn(block: Block): Boolean =
        block.stmts.any { stmt -> when (stmt) {
            is ReturnStmt -> true
            is WhileStmt -> blockContainsReturn(stmt.body)
            is ForStmt -> blockContainsReturn(stmt.body)
            is ExprStmt -> exprContainsReturn(stmt.expr)
            else -> false
        }}

    private fun exprContainsReturn(expr: Expr): Boolean = when (expr) {
        is IfBlockExpr -> blockContainsReturn(expr.thenBlock) ||
            (expr.elseClause is ElseBlock && blockContainsReturn((expr.elseClause as ElseBlock).body)) ||
            (expr.elseClause is ElseIf && exprContainsReturn((expr.elseClause as ElseIf).ifExpr))
        is MatchExpr -> expr.arms.any { arm ->
            when (arm.body) {
                is ExprBody -> (arm.body as ExprBody).expr is ReturnExpr
                is BlockBody -> blockContainsReturn((arm.body as BlockBody).block)
            }
        }
        else -> false
    }

    private fun unify(a: NovaType, b: NovaType, span: SourceSpan) {
        val wa = env.walk(a)
        val wb = env.walk(b)

        when {
            // Nothing unifies with anything without binding (bottom type).
            wa is TNothing || wb is TNothing -> return

            // Identical walked types: already unified.
            wa == wb -> return

            // Bind TypeVar (with occurs check).
            wa is TypeVar -> {
                if (env.occurs(wa, wb)) {
                    errors.add(TypeError("infinite type: ${wa} occurs in ${env.apply(wb)}", span))
                    return
                }
                env.bind(wa, wb)
            }
            wb is TypeVar -> {
                if (env.occurs(wb, wa)) {
                    errors.add(TypeError("infinite type: ${wb} occurs in ${env.apply(wa)}", span))
                    return
                }
                env.bind(wb, wa)
            }

            // Structural unification
            wa is TList    && wb is TList    -> unify(wa.elem, wb.elem, span)
            wa is TDict    && wb is TDict    -> { unify(wa.key, wb.key, span); unify(wa.value, wb.value, span) }
            wa is TChannel && wb is TChannel -> unify(wa.payload, wb.payload, span)
            wa is TProcess && wb is TProcess -> unify(wa.yieldType, wb.yieldType, span)

            wa is TTuple && wb is TTuple -> {
                if (wa.elements.size != wb.elements.size) {
                    errors.add(TypeError("tuple size mismatch: ${wa.elements.size} vs ${wb.elements.size}", span))
                    return
                }
                wa.elements.zip(wb.elements).forEach { (x, y) -> unify(x, y, span) }
            }

            wa is TFn && wb is TFn -> {
                if (wa.params.size != wb.params.size) {
                    val takes = wa.params.size
                    val given = wb.params.size
                    val word = if (takes == 1) "argument" else "arguments"
                    errors.add(TypeError("wrong number of arguments: function takes $takes $word but was called with $given", span))
                    return
                }
                wa.params.zip(wb.params).forEach { (x, y) -> unify(x, y, span) }
                unify(wa.ret, wb.ret, span)
            }

            wa is TSumType && wb is TSumType -> {
                unify(wa.ok, wb.ok, span)
                unify(wa.err, wb.err, span)
            }

            // TRecord vs TStruct: structural compatibility (duck typing for named types)
            wa is TRecord && wb is TRecord -> {
                for ((k, va) in wa.fields) {
                    val vb = wb.fields[k]
                    if (vb != null) unify(va, vb, span)
                }
            }

            // int ↔ float promotion: unify both with float
            (wa == TInt && wb == TFloat) || (wa == TFloat && wb == TInt) -> {
                // Both sides accepted: float wins
            }

            // bool ↔ int compatibility: booleans are 0/1 integers at runtime
            (wa == TBool && wb == TInt) || (wa == TInt && wb == TBool) -> {
            }

            // TSumType used where the ok type is expected (ElseOp unwrapping)
            wa is TSumType && wb !is TSumType -> {
                unify(wa.ok, wb, span)
            }
            wb is TSumType && wa !is TSumType -> {
                unify(wa, wb.ok, span)
            }

            else -> {
                val resolvedA = env.apply(wa)
                val resolvedB = env.apply(wb)
                if (resolvedA != resolvedB) {
                    val hint = typeMismatchHint(resolvedA, resolvedB)
                    val msg = "type mismatch: expected $resolvedB, got $resolvedA" + if (hint != null) "\n  hint: $hint" else ""
                    errors.add(TypeError(msg, span))
                }
            }
        }
    }
}
