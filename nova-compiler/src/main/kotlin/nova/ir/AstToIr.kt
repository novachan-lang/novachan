package nova.ir

import nova.lexer.SourceSpan
import nova.parser.*
import nova.types.NovaType
import nova.types.TBool
import nova.types.TFloat
import nova.types.TInt
import nova.types.TList
import nova.types.TString
import nova.types.TUnit

// ── AST → IR Lowering ─────────────────────────────────────────────────────────
//
// Converts a typed NOVA AST into a NOVA IR module. The lowering uses the alloca
// approach: mutable variables become SlotAlloc + SlotStore/Load pairs. LLVM's
// mem2reg pass promotes these to SSA phi-nodes during code generation.
//
// Key decisions:
//   - Lambda lifting: all lambdas/nested fns are hoisted to top-level IrFunctions.
//   - For-expression collect: desugars to empty-list + loop + ListAppend.
//   - Process/channel ops remain as high-level instructions for the erasure pass.
//   - ElseOp lowers to IsError + Branch pattern.

class AstToIr(private val typeEnv: Map<Expr, NovaType> = emptyMap()) {

    // ── NovaType → IrType conversion ─────────────────────────────────────────

    private fun novaTypeToIrType(t: NovaType): IrType = when (t) {
        TInt    -> IrType.I64
        TFloat  -> IrType.F64
        TString -> IrType.Str
        TBool   -> IrType.Bool
        TUnit   -> IrType.Unit
        is TList -> IrType.List(novaTypeToIrType(t.elem))
        else    -> IrType.Any
    }

    private fun typeOf(expr: Expr): IrType =
        typeEnv[expr]?.let { novaTypeToIrType(it) } ?: IrType.Any

    private fun typeExprToIrType(t: TypeExpr?): IrType = when {
        t == null -> IrType.Any
        t is NamedType -> when (t.name) {
            "int" -> IrType.I64
            "float" -> IrType.F64
            "string" -> IrType.Str
            "bool" -> IrType.Bool
            "list" -> IrType.List(IrType.Any)
            "dict" -> IrType.Dict(IrType.Str, IrType.Any)
            else -> IrType.Any
        }
        t is GenericType -> when (t.name) {
            "list" -> IrType.List(if (t.args.isNotEmpty()) typeExprToIrType(t.args[0]) else IrType.Any)
            "dict" -> IrType.Dict(
                if (t.args.isNotEmpty()) typeExprToIrType(t.args[0]) else IrType.Str,
                if (t.args.size > 1) typeExprToIrType(t.args[1]) else IrType.Any
            )
            else -> IrType.Any
        }
        else -> IrType.Any
    }

    // ── Module state ─────────────────────────────────────────────────────────

    private val module = IrModule("nova")
    private var lambdaCounter = 0
    private var matchCounter = 0
    private var ifbCounter = 0
    private var scCounter = 0
    private val knownFunctions = mutableSetOf<String>()
    private val externFunctions = mutableSetOf<String>()
    private val functionDefaults = mutableMapOf<String, List<Expr?>>()
    // struct name → (method name → mangled function name)
    private val methodRegistry = mutableMapOf<String, MutableMap<String, String>>()
    // enum variant name → payload fields (name, type) in declaration order (excludes __variant)
    private val enumVariants = mutableMapOf<String, List<Pair<String, IrType>>>()

    // Module system: maps module alias → set of function names from that module
    private val importedModules = mutableMapOf<String, MutableSet<String>>()
    // Maps selective-imported names → original function name (for unqualified access)
    private val selectiveImports = mutableSetOf<String>()

    // ── Per-function state ────────────────────────────────────────────────────

    private var refCounter = 0
    private var currentFn: IrFunction? = null
    private var currentBlock: IrBlock? = null

    // Maps variable name → (IrSlot, IrType) for mutable slots in this function.
    // Variables that are only ever defined once and never reassigned still get
    // a slot for uniformity; the erasure pass can optimize them away.
    private val slots = mutableMapOf<String, IrSlot>()

    // Global (module-level) slots: variables defined at top level that need
    // to be accessible from all functions. These become LLVM global variables.
    private val globalSlots = mutableMapOf<String, IrSlot>()

    // Entry block of current function: all SlotAllocs go here.
    private var entryBlock: IrBlock? = null

    // Loop context for break/continue
    private val loopStack = ArrayDeque<LoopContext>()
    private data class LoopContext(val header: BlockId, val exit: BlockId)

    // ── Module registration (called before lower()) ────────────────────────

    fun registerModule(alias: String, functionNames: Set<String>) {
        importedModules.getOrPut(alias) { mutableSetOf() }.addAll(functionNames)
        knownFunctions.addAll(functionNames)
    }

    fun registerSelectiveImports(names: Set<String>) {
        selectiveImports.addAll(names)
        knownFunctions.addAll(names)
    }

    // ── Public entry point ────────────────────────────────────────────────────

    fun lower(program: Program): IrModule {
        // Pre-register type/enum declarations so functions that reference them
        // resolve correctly even before the declaration appears in statement order.
        for (stmt in program.stmts) {
            when (stmt) {
                is TypeDecl -> {
                    val tpSet = stmt.typeParams.toSet()
                    module.structs.add(stmt.name to stmt.fields.map { f ->
                        val ft = if (f.type is NamedType && (f.type as NamedType).name in tpSet) IrType.Any
                                 else mapTypeExpr(f.type)
                        f.name to ft
                    })
                }
                is EnumDecl -> {
                    for (v in stmt.variants) {
                        module.structs.add(v.name to (listOf("__variant" to IrType.Str as IrType) +
                            v.fields.map { it.name to mapTypeExpr(it.type) }))
                        enumVariants[v.name] = v.fields.map { it.name to mapTypeExpr(it.type) }
                    }
                }
                else -> {}
            }
        }

        // Pre-scan top-level assignments to identify module-level variables.
        // Only variables that escape into top-level function bodies need LLVM global
        // storage. Variables used only in nova_main's sequential code become local
        // allocas — letting LLVM mem2reg register-allocate them across call boundaries.
        val topLevelFnNames = program.stmts.filterIsInstance<FnDecl>()
            .filter { it.receiverType == null }.map { it.name }.toSet()
        val topLevelVarNames = program.stmts
            .filterIsInstance<AssignStmt>()
            .mapNotNull { if (it.target is Ident) (it.target as Ident).name else null }
            .filter { it !in topLevelFnNames }
            .toSet()
        val escapedVars = mutableSetOf<String>()
        for (stmt in program.stmts) {
            if (stmt is FnDecl) {
                val paramNames = stmt.params.map { it.name }.toSet()
                val free = freeVarsBlock(stmt.body, paramNames + topLevelFnNames)
                escapedVars.addAll(free.intersect(topLevelVarNames))
            }
        }
        for (name in topLevelVarNames) {
            globalSlots[name] = IrSlot(name, isGlobal = name in escapedVars)
        }

        // Hoist all top-level fn declarations into module functions first
        // so forward references resolve correctly.
        for (stmt in program.stmts) {
            val fnDecl = when {
                stmt is FnDecl -> stmt
                stmt is AnnotatedStmt && stmt.stmt is FnDecl -> stmt.stmt as FnDecl
                else -> null
            }
            if (fnDecl != null) {
                val isExtern = stmt is AnnotatedStmt &&
                    (stmt as AnnotatedStmt).annotation.name == "extern"
                if (fnDecl.receiverType != null) {
                    val mangledName = "${fnDecl.receiverType}__${fnDecl.name}"
                    knownFunctions.add(mangledName)
                    methodRegistry.getOrPut(fnDecl.receiverType) { mutableMapOf() }[fnDecl.name] = mangledName
                    val defaults = fnDecl.params.map { it.default }
                    if (defaults.any { it != null }) functionDefaults[mangledName] = defaults
                    if (isExtern) {
                        externFunctions.add(mangledName)
                        module.externFunctions.add(mangledName to fnDecl.params.size)
                    }
                } else {
                    knownFunctions.add(fnDecl.name)
                    val defaults = fnDecl.params.map { it.default }
                    if (defaults.any { it != null }) functionDefaults[fnDecl.name] = defaults
                    if (isExtern) {
                        externFunctions.add(fnDecl.name)
                        module.externFunctions.add(fnDecl.name to fnDecl.params.size)
                    }
                }
                if (!isExtern) lowerFnDecl(fnDecl, enclosingName = null)
            }
        }

        // Top-level non-fn statements go into nova_main.
        val mainStmts = program.stmts.filter {
            it !is FnDecl && !(it is AnnotatedStmt && it.stmt is FnDecl)
        }
        if (mainStmts.isNotEmpty() || program.stmts.isEmpty()) {
            val mainFn = IrFunction("nova_main", emptyList(), IrType.Unit, span = program.span)
            module.functions.add(mainFn)
            withFunction(mainFn) {
                for (stmt in mainStmts) lowerStmt(stmt)
                terminateIfNeeded(IrTerminator.Return(unitRef(program.span), program.span))
            }
        }

        return module
    }

    // ── Function lowering ────────────────────────────────────────────────────

    private fun hasYield(block: Block): Boolean =
        block.stmts.any { stmtHasYield(it) }

    private fun stmtHasYield(stmt: Stmt): Boolean = when (stmt) {
        is YieldStmt -> true
        is WhileStmt -> hasYield(stmt.body)
        is ForStmt -> hasYield(stmt.body)
        is ExprStmt -> exprHasYield(stmt.expr)
        is AnnotatedStmt -> stmtHasYield(stmt.stmt)
        else -> false
    }

    private fun exprHasYield(expr: Expr): Boolean = when (expr) {
        is IfBlockExpr -> {
            hasYield(expr.thenBlock) || when (val ec = expr.elseClause) {
                is ElseBlock -> hasYield(ec.body)
                is ElseIf -> exprHasYield(ec.ifExpr)
                null -> false
            }
        }
        is ForExpr -> when (val b = expr.body) {
            is BlockBody -> hasYield(b.block)
            is ExprBody -> false
        }
        else -> false
    }

    // Name of the yield-accumulator slot for the current generator function (null if not a generator)
    private var yieldSlotName: String? = null

    private fun lowerFnDecl(fn: FnDecl, enclosingName: String?): IrFunction {
        val isMethod = fn.receiverType != null
        val name = if (isMethod) "${fn.receiverType}__${fn.name}"
                   else if (enclosingName != null) "${enclosingName}\$${fn.name}" else fn.name
        val explicitParams = fn.params.map { it.name to typeExprToIrType(it.type) }
        val params = if (isMethod) listOf("self" to IrType.Any) + explicitParams else explicitParams
        val isGenerator = hasYield(fn.body)
        val retType = if (isGenerator) IrType.List(IrType.Any) else IrType.Any
        val irFn = IrFunction(name, params, retType, span = fn.span)
        module.functions.add(irFn)
        withFunction(irFn) {
            // Parameters are available as direct refs; no slot needed for params
            // since they're immutable at the function boundary.
            for ((paramName, _) in params) {
                val slot = IrSlot(paramName)
                slots[paramName] = slot
                val allocRef = emit(IrInst.SlotAlloc(freshRef(), IrType.Any, slot, fn.span))
                val paramRef = paramRef(paramName, irFn)
                emit(IrInst.SlotStore(freshRef(), IrType.Unit, slot, paramRef, fn.span))
            }
            // Generator setup: create accumulation list
            if (isGenerator) {
                val ySlot = IrSlot("__yield_list")
                slots["__yield_list"] = ySlot
                emit(IrInst.SlotAlloc(freshRef(), IrType.Any, ySlot, fn.span))
                val listRef = emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_list_create", emptyList(), fn.span))
                emit(IrInst.SlotStore(freshRef(), IrType.Unit, ySlot, listRef, fn.span))
                yieldSlotName = "__yield_list"
            }
            // Nested fn declarations: hoist to module AND make callable from this scope.
            for (stmt in fn.body.stmts) {
                if (stmt is FnDecl) {
                    lowerFnDecl(stmt, enclosingName = name)
                    val liftedName = "${name}\$${stmt.name}"
                    val closureRef = emit(IrInst.MakeClosure(freshRef(), IrType.Any, liftedName, emptyList(), stmt.span))
                    writeSlot(stmt.name, closureRef, stmt.span)
                }
            }
            val result = lowerBlock(fn.body, skipFnDecls = true)
            if (isGenerator) {
                // Return the accumulated yield list
                val yList = emit(IrInst.SlotLoad(freshRef(), IrType.Any, slots["__yield_list"]!!, fn.span))
                terminateIfNeeded(IrTerminator.Return(yList, fn.body.span))
                yieldSlotName = null
            } else {
                terminateIfNeeded(IrTerminator.Return(result, fn.body.span))
            }
        }
        return irFn
    }

    // Lower an anonymous lambda, lifting it to a top-level function.
    // Captured variables become extra parameters appended after explicit params,
    // so the lambda body can reference them via normal slot machinery.
    private fun lowerLambda(lambda: Lambda, enclosingName: String): IrRef {
        val liftedName = "${enclosingName}\$lambda${lambdaCounter++}"

        // Detect free variables (captures) — variables referenced in body but not params.
        // Must be computed before withFunction clears the outer slots map.
        val paramNames = lambda.params.map { it.name }.toSet()
        val captures = freeVars(lambda.body, paramNames).filter { slots.containsKey(it) }

        // Build param list: explicit params first, then capture params appended at end.
        val explicitParams = lambda.params.map { it.name to IrType.Any }
        val allParams = explicitParams + captures.map { it to IrType.Any }

        val irFn = IrFunction(liftedName, allParams, IrType.Any,
            captureCount = captures.size, span = lambda.span)
        module.functions.add(irFn)

        withFunction(irFn) {
            // Explicit parameters as slots
            for ((paramName, _) in explicitParams) {
                val slot = IrSlot(paramName)
                slots[paramName] = slot
                emit(IrInst.SlotAlloc(freshRef(), IrType.Any, slot, lambda.span))
                emit(IrInst.SlotStore(freshRef(), IrType.Unit, slot, paramRef(paramName, irFn), lambda.span))
            }
            // Capture parameters as slots — makes them visible inside the lambda body.
            // paramRef(capName, irFn) gives the negative IrRef for the extra param.
            for (capName in captures) {
                val slot = IrSlot(capName)
                slots[capName] = slot
                emit(IrInst.SlotAlloc(freshRef(), IrType.Any, slot, lambda.span))
                emit(IrInst.SlotStore(freshRef(), IrType.Unit, slot, paramRef(capName, irFn), lambda.span))
            }
            val result = when (val b = lambda.body) {
                is ExprBody  -> lowerExpr(b.expr)
                is BlockBody -> lowerBlock(b.block)
            }
            terminateIfNeeded(IrTerminator.Return(result, lambda.span))
        }

        // Build capture ref list from the CALLER'S perspective (outer slots restored).
        // The IrOptimizer will substitute these refs through slot coalescing.
        val captureRefs = captures.map { name ->
            val s = slots[name]
            if (s != null) emit(IrInst.SlotLoad(freshRef(), IrType.Any, s, lambda.span))
            else freshRef()
        }

        return emit(IrInst.MakeClosure(freshRef(), IrType.Any, liftedName, captureRefs, lambda.span))
    }

    // ── Statement lowering ────────────────────────────────────────────────────

    private fun lowerStmt(stmt: Stmt): IrRef {
        return when (stmt) {
            is FnDecl -> {
                // Nested fn — already lifted in pass 1 if top-level, do it now if nested.
                val enclosing = currentFn?.name ?: "nova_main"
                lowerFnDecl(stmt, enclosingName = enclosing)
                // Make it callable from this scope by storing a closure ref in a slot.
                val liftedName = "${enclosing}\$${stmt.name}"
                val closureRef = emit(IrInst.MakeClosure(freshRef(), IrType.Any, liftedName, emptyList(), stmt.span))
                writeSlot(stmt.name, closureRef, stmt.span)
                unitRef(stmt.span)
            }

            is AssignStmt -> lowerAssign(stmt)

            is ExprStmt -> lowerExpr(stmt.expr)

            is ReturnStmt -> {
                val v = stmt.value?.let { lowerExpr(it) } ?: unitRef(stmt.span)
                terminateIfNeeded(IrTerminator.Return(v, stmt.span))
                // Unreachable code after return gets a fresh block
                val dead = currentFn!!.newBlock("dead")
                currentBlock = dead
                v
            }

            is YieldStmt -> {
                val value = lowerExpr(stmt.value)
                val ySlot = slots[yieldSlotName ?: "__yield_list"]
                if (ySlot != null) {
                    val listRef = emit(IrInst.SlotLoad(freshRef(), IrType.Any, ySlot, stmt.span))
                    emit(IrInst.ListAppend(freshRef(), IrType.Unit, listRef, value, stmt.span))
                }
                unitRef(stmt.span)
            }

            is BreakStmt -> {
                val ctx = loopStack.last()
                terminateIfNeeded(IrTerminator.Goto(ctx.exit, stmt.span))
                val dead = currentFn!!.newBlock("dead")
                currentBlock = dead
                unitRef(stmt.span)
            }

            is ContinueStmt -> {
                val ctx = loopStack.last()
                terminateIfNeeded(IrTerminator.Goto(ctx.header, stmt.span))
                val dead = currentFn!!.newBlock("dead")
                currentBlock = dead
                unitRef(stmt.span)
            }

            is ForStmt -> lowerForStmt(stmt)

            is WhileStmt -> lowerWhileStmt(stmt)

            is SpawnBlockStmt -> {
                val enclosing = currentFn?.name ?: "nova_main"
                val liftedName = "${enclosing}\$spawn${lambdaCounter++}"
                val captures = freeVarsBlock(stmt.body, emptySet()).filter { slots.containsKey(it) }
                val params = captures.map { it to IrType.Any }
                val irFn = IrFunction(liftedName, params, IrType.Unit, span = stmt.span)
                module.functions.add(irFn)
                withFunction(irFn) {
                    for (capName in captures) {
                        val slot = IrSlot(capName)
                        slots[capName] = slot
                        emit(IrInst.SlotAlloc(freshRef(), IrType.Any, slot, stmt.span))
                        emit(IrInst.SlotStore(freshRef(), IrType.Unit, slot, paramRef(capName, irFn), stmt.span))
                    }
                    lowerBlock(stmt.body)
                    terminateIfNeeded(IrTerminator.Return(unitRef(stmt.span), stmt.span))
                }
                val captureRefs = captures.map { name ->
                    val s = slots[name]
                    if (s != null) emit(IrInst.SlotLoad(freshRef(), IrType.Any, s, stmt.span))
                    else freshRef()
                }
                emit(IrInst.Spawn(freshRef(), IrType.Process, liftedName, captureRefs, stmt.span))
            }

            is SpawnStmt -> {
                val enclosing = currentFn?.name ?: "nova_main"
                val liftedName = "${enclosing}\$spawn${lambdaCounter++}"
                val lambda = stmt.expr as? Lambda
                if (lambda != null) {
                    val bodyFreeVars = freeVars(lambda.body, lambda.params.map { it.name }.toSet())
                    val captures = bodyFreeVars.filter { slots.containsKey(it) }
                    val params = captures.map { it to IrType.Any }
                    val irFn = IrFunction(liftedName, params, IrType.Unit, span = stmt.span)
                    module.functions.add(irFn)
                    withFunction(irFn) {
                        for (capName in captures) {
                            val slot = IrSlot(capName)
                            slots[capName] = slot
                            emit(IrInst.SlotAlloc(freshRef(), IrType.Any, slot, stmt.span))
                            emit(IrInst.SlotStore(freshRef(), IrType.Unit, slot, paramRef(capName, irFn), stmt.span))
                        }
                        val result = when (val b = lambda.body) {
                            is ExprBody  -> lowerExpr(b.expr)
                            is BlockBody -> lowerBlock(b.block)
                        }
                        terminateIfNeeded(IrTerminator.Return(result, stmt.span))
                    }
                    val captureRefs = captures.map { name ->
                        val s = slots[name]
                        if (s != null) emit(IrInst.SlotLoad(freshRef(), IrType.Any, s, stmt.span))
                        else freshRef()
                    }
                    emit(IrInst.Spawn(freshRef(), IrType.Process, liftedName, captureRefs, stmt.span))
                } else {
                    val captures = freeVarsExpr(stmt.expr, emptySet()).filter { slots.containsKey(it) }
                    val params = captures.map { it to IrType.Any }
                    val irFn = IrFunction(liftedName, params, IrType.Unit, span = stmt.span)
                    module.functions.add(irFn)
                    withFunction(irFn) {
                        for (capName in captures) {
                            val slot = IrSlot(capName)
                            slots[capName] = slot
                            emit(IrInst.SlotAlloc(freshRef(), IrType.Any, slot, stmt.span))
                            emit(IrInst.SlotStore(freshRef(), IrType.Unit, slot, paramRef(capName, irFn), stmt.span))
                        }
                        lowerExpr(stmt.expr)
                        terminateIfNeeded(IrTerminator.Return(unitRef(stmt.span), stmt.span))
                    }
                    val captureRefs = captures.map { name ->
                        val s = slots[name]
                        if (s != null) emit(IrInst.SlotLoad(freshRef(), IrType.Any, s, stmt.span))
                        else freshRef()
                    }
                    emit(IrInst.Spawn(freshRef(), IrType.Process, liftedName, captureRefs, stmt.span))
                }
            }

            is TypeDecl -> {
                // Already registered in the pre-pass; skip duplicate insertion.
                unitRef(stmt.span)
            }

            is EnumDecl -> {
                // Already registered in the pre-pass; skip duplicate insertion.
                unitRef(stmt.span)
            }

            is TraitDecl -> {
                unitRef(stmt.span)
            }

            is ImportStmt      -> unitRef(stmt.span)
            is AnnotatedStmt   -> {
                if (stmt.annotation.name == "extern" && stmt.stmt is FnDecl) {
                    unitRef(stmt.span)
                } else {
                    lowerStmt(stmt.stmt)
                }
            }
            is LowLevelBlock   -> lowerBlock(stmt.body)
            is ErrorStmt       -> unitRef(stmt.span)
        }
    }

    private fun lowerAssign(stmt: AssignStmt): IrRef {
        val value: IrRef = when (stmt.op) {
            "=" -> lowerExpr(stmt.value)
            else -> {
                // Compound assignment: load current, apply op, store
                val current = lowerExpr(stmt.target)
                val delta = lowerExpr(stmt.value)
                val binOp = when (stmt.op) {
                    "+=" -> BinOp.ADD; "-=" -> BinOp.SUB
                    "*=" -> BinOp.MUL; "/=" -> BinOp.DIV
                    "%=" -> BinOp.MOD
                    else -> BinOp.ADD
                }
                emit(IrInst.Binary(freshRef(), IrType.Any, binOp, current, delta, stmt.span))
            }
        }

        when (val target = stmt.target) {
            is Ident -> writeSlot(target.name, value, stmt.span)
            is MemberAccess -> {
                val obj = lowerExpr(target.target)
                emit(IrInst.FieldSet(freshRef(), IrType.Unit, obj, target.member, value, stmt.span))
            }
            is Index -> {
                val tgt = lowerExpr(target.target)
                val idx = if (target.index is UnaryOp && (target.index as UnaryOp).op == "-"
                             && (target.index as UnaryOp).operand is IntLit) {
                    val n = ((target.index as UnaryOp).operand as IntLit).value
                    val lenRef = emit(IrInst.CallDirect(freshRef(), IrType.I64, "len", listOf(tgt), stmt.span))
                    val negConst = emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(-n), stmt.span))
                    emit(IrInst.Binary(freshRef(), IrType.I64, BinOp.ADD, lenRef, negConst, stmt.span))
                } else {
                    lowerExpr(target.index)
                }
                emit(IrInst.IndexSet(freshRef(), IrType.Unit, tgt, idx, value, stmt.span))
            }
            is TupleLit -> {
                // Tuple destructuring: (a, b) = pair
                target.elements.forEachIndexed { i, elem ->
                    val idxRef = emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(i.toLong()), stmt.span))
                    val elemVal = emit(IrInst.IndexGet(freshRef(), IrType.Any, value, idxRef, stmt.span))
                    if (elem is Ident) writeSlot(elem.name, elemVal, stmt.span)
                }
            }
            else -> {}
        }
        return unitRef(stmt.span)
    }

    // ── For / While loop lowering ────────────────────────────────────────────

    private fun lowerForStmt(stmt: ForStmt): IrRef {
        val span = stmt.span

        // Optimized range iteration: for i in start..end (inclusive, zero allocation)
        if (stmt.iterable is BinaryOp && (stmt.iterable as BinaryOp).op == "..") {
            return lowerForRange(stmt, stmt.iterable as BinaryOp)
        }

        val iterVal = lowerExpr(stmt.iterable)
        val iterType = typeEnv[stmt.iterable]

        val headerBlock = currentFn!!.newBlock("for_header")
        val bodyBlock   = currentFn!!.newBlock("for_body")
        val exitBlock   = currentFn!!.newBlock("for_exit")

        // Store iter in a slot so it's available across basic blocks.
        val iterSlot = IrSlot("__for_iter_${slots.size}")
        emit(IrInst.SlotAlloc(freshRef(), IrType.Any, iterSlot, span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, iterSlot, iterVal, span))

        // Slot for the loop index
        val indexSlot = IrSlot("__for_idx_${slots.size}")
        emit(IrInst.SlotAlloc(freshRef(), IrType.I64, indexSlot, span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, indexSlot,
            emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(0), span)), span))

        // For string iteration, compute length once and store it
        val lenSlot: IrSlot?
        if (iterType is nova.types.TString) {
            lenSlot = IrSlot("__for_len_${slots.size}")
            emit(IrInst.SlotAlloc(freshRef(), IrType.I64, lenSlot, span))
            val lenVal = emit(IrInst.CallDirect(freshRef(), IrType.I64, "len", listOf(iterVal), span))
            emit(IrInst.SlotStore(freshRef(), IrType.Unit, lenSlot, lenVal, span))
        } else {
            lenSlot = null
        }

        terminateIfNeeded(IrTerminator.Goto(headerBlock.id, span))
        currentBlock = headerBlock

        // has_next check — reload iter and index from slots each iteration
        val iter0   = emit(IrInst.SlotLoad(freshRef(), IrType.Any, iterSlot, span))
        val hasNext = if (iterType is nova.types.TString) {
            val idx = emit(IrInst.SlotLoad(freshRef(), IrType.I64, indexSlot, span))
            val len = emit(IrInst.SlotLoad(freshRef(), IrType.I64, lenSlot!!, span))
            emit(IrInst.Binary(freshRef(), IrType.Bool, BinOp.LT, idx, len, span))
        } else {
            val hasNextFn = if (iterType is nova.types.TList) "nova_rt_list_iter_has_next" else "nova_rt_iter_has_next"
            emit(IrInst.CallDirect(freshRef(), IrType.Bool, hasNextFn,
                listOf(iter0, emit(IrInst.SlotLoad(freshRef(), IrType.I64, indexSlot, span))), span))
        }
        terminateIfNeeded(IrTerminator.Branch(hasNext, bodyBlock.id, exitBlock.id, span))

        currentBlock = bodyBlock
        loopStack.addLast(LoopContext(headerBlock.id, exitBlock.id))

        // Get current element
        val iter1  = emit(IrInst.SlotLoad(freshRef(), IrType.Any, iterSlot, span))
        val idxRef = emit(IrInst.SlotLoad(freshRef(), IrType.I64, indexSlot, span))
        val elem = when {
            iterType is nova.types.TString -> {
                emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_str_char_at", listOf(iter1, idxRef), span))
            }
            iterType is nova.types.TList -> {
                emit(IrInst.IndexGet(freshRef(), IrType.Any, iter1, idxRef, span))
            }
            else -> {
                emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_iter_get", listOf(iter1, idxRef), span))
            }
        }
        bindPattern(stmt.variable, elem, span)

        lowerBlock(stmt.body)

        // Increment index
        val nextIdx = emit(IrInst.Binary(freshRef(), IrType.I64, BinOp.ADD, idxRef,
            emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(1), span)), span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, indexSlot, nextIdx, span))
        terminateIfNeeded(IrTerminator.Goto(headerBlock.id, span))

        loopStack.removeLast()
        currentBlock = exitBlock
        return unitRef(span)
    }

    private fun lowerForRange(stmt: ForStmt, range: BinaryOp): IrRef {
        val span = stmt.span
        val startVal = lowerExpr(range.left)
        val endVal = lowerExpr(range.right)

        val headerBlock = currentFn!!.newBlock("range_header")
        val bodyBlock   = currentFn!!.newBlock("range_body")
        val exitBlock   = currentFn!!.newBlock("range_exit")

        val indexSlot = IrSlot("__range_idx_${slots.size}")
        emit(IrInst.SlotAlloc(freshRef(), IrType.I64, indexSlot, span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, indexSlot, startVal, span))

        val endSlot = IrSlot("__range_end_${slots.size}")
        emit(IrInst.SlotAlloc(freshRef(), IrType.I64, endSlot, span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, endSlot, endVal, span))

        terminateIfNeeded(IrTerminator.Goto(headerBlock.id, span))
        currentBlock = headerBlock

        val idx0 = emit(IrInst.SlotLoad(freshRef(), IrType.I64, indexSlot, span))
        val end0 = emit(IrInst.SlotLoad(freshRef(), IrType.I64, endSlot, span))
        val cond = emit(IrInst.Binary(freshRef(), IrType.Bool, BinOp.LE, idx0, end0, span))
        terminateIfNeeded(IrTerminator.Branch(cond, bodyBlock.id, exitBlock.id, span))

        currentBlock = bodyBlock
        loopStack.addLast(LoopContext(headerBlock.id, exitBlock.id))

        val idx1 = emit(IrInst.SlotLoad(freshRef(), IrType.I64, indexSlot, span))
        bindPattern(stmt.variable, idx1, span)

        lowerBlock(stmt.body)

        val idx2 = emit(IrInst.SlotLoad(freshRef(), IrType.I64, indexSlot, span))
        val nextIdx = emit(IrInst.Binary(freshRef(), IrType.I64, BinOp.ADD, idx2,
            emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(1), span)), span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, indexSlot, nextIdx, span))
        terminateIfNeeded(IrTerminator.Goto(headerBlock.id, span))

        loopStack.removeLast()
        currentBlock = exitBlock
        return unitRef(span)
    }

    private fun lowerWhileStmt(stmt: WhileStmt): IrRef {
        val span = stmt.span
        val headerBlock = currentFn!!.newBlock("while_header")
        val bodyBlock   = currentFn!!.newBlock("while_body")
        val exitBlock   = currentFn!!.newBlock("while_exit")

        terminateIfNeeded(IrTerminator.Goto(headerBlock.id, span))
        currentBlock = headerBlock

        val cond = lowerExpr(stmt.condition)
        terminateIfNeeded(IrTerminator.Branch(cond, bodyBlock.id, exitBlock.id, span))

        currentBlock = bodyBlock
        loopStack.addLast(LoopContext(headerBlock.id, exitBlock.id))
        lowerBlock(stmt.body)
        terminateIfNeeded(IrTerminator.Goto(headerBlock.id, span))
        loopStack.removeLast()

        currentBlock = exitBlock
        return unitRef(span)
    }

    // ── Expression lowering ──────────────────────────────────────────────────

    private fun lowerExpr(expr: Expr): IrRef = when (expr) {
        is IntLit    -> emit(IrInst.Const(freshRef(), IrType.I64,  IrConst.Int(expr.value),    expr.span))
        is FloatLit  -> emit(IrInst.Const(freshRef(), IrType.F64,  IrConst.Float(expr.value),  expr.span))
        is StringLit -> emit(IrInst.Const(freshRef(), IrType.Str,  IrConst.Str(expr.value),    expr.span))
        is RawStringLit -> emit(IrInst.Const(freshRef(), IrType.Str, IrConst.Str(expr.value),  expr.span))
        is BoolLit   -> emit(IrInst.Const(freshRef(), IrType.Bool, IrConst.Bool(expr.value),   expr.span))

        is Ident -> readSlot(expr.name, expr.span)

        is StringInterp -> {
            val parts = expr.parts.map { part ->
                when (part) {
                    is StringPart -> emit(IrInst.Const(freshRef(), IrType.Str, IrConst.Str(part.value), part.span))
                    is ExprPart   -> {
                        val v = lowerExpr(part.expr)
                        emit(IrInst.ToString(freshRef(), IrType.Str, v, part.span))
                    }
                }
            }
            emit(IrInst.StringConcat(freshRef(), IrType.Str, parts, expr.span))
        }

        is BinaryOp -> lowerBinaryOp(expr)

        is UnaryOp -> when (expr.op) {
            "-"    -> emit(IrInst.Unary(freshRef(), IrType.Any, UnOp.NEG, lowerExpr(expr.operand), expr.span))
            "not"  -> emit(IrInst.Unary(freshRef(), IrType.Bool, UnOp.NOT, lowerExpr(expr.operand), expr.span))
            "~"    -> emit(IrInst.Unary(freshRef(), IrType.I64, UnOp.BIT_NOT, lowerExpr(expr.operand), expr.span))
            "copy" -> emit(IrInst.Copy(freshRef(), IrType.Any, lowerExpr(expr.operand), expr.span))
            else   -> lowerExpr(expr.operand)
        }

        is ElseOp -> lowerElseOp(expr)

        is Call -> lowerCall(expr)

        is Index -> {
            val target = lowerExpr(expr.target)
            val idx = if (expr.index is UnaryOp && (expr.index as UnaryOp).op == "-"
                         && (expr.index as UnaryOp).operand is IntLit) {
                // Negative literal index: list[-1] → list[len(list) - 1]
                val n = ((expr.index as UnaryOp).operand as IntLit).value
                val lenRef = emit(IrInst.CallDirect(freshRef(), IrType.I64, "len", listOf(target), expr.span))
                val negConst = emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(-n), expr.span))
                emit(IrInst.Binary(freshRef(), IrType.I64, BinOp.ADD, lenRef, negConst, expr.span))
            } else {
                lowerExpr(expr.index)
            }
            emit(IrInst.IndexGet(freshRef(), IrType.Any, target, idx, expr.span))
        }

        is Slice -> {
            val target = lowerExpr(expr.target)
            val start = if (expr.start != null) lowerExpr(expr.start)
                        else emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(0), expr.span))
            val end = if (expr.end != null) lowerExpr(expr.end)
                      else emit(IrInst.CallDirect(freshRef(), IrType.I64, "len", listOf(target), expr.span))
            val targetType = typeEnv[expr.target]
            val fnName = if (targetType is nova.types.TString) "nova_rt_slice" else "nova_rt_list_slice"
            emit(IrInst.CallDirect(freshRef(), IrType.Any, fnName, listOf(target, start, end), expr.span))
        }

        is MemberAccess -> {
            val target = lowerExpr(expr.target)
            val targetNovaType = typeEnv[expr.target]
            val fieldIrType = if (targetNovaType is nova.types.TStruct) {
                val structFields = module.structs.firstOrNull { it.first == targetNovaType.name }?.second
                structFields?.firstOrNull { it.first == expr.member }?.second ?: IrType.Any
            } else IrType.Any
            emit(IrInst.FieldGet(freshRef(), fieldIrType, target, expr.member, expr.span))
        }

        is Lambda -> {
            val enclosing = currentFn?.name ?: "nova_main"
            lowerLambda(expr, enclosing)
        }

        is IfExpr -> lowerIfExpr(expr)
        is IfBlockExpr -> lowerIfBlockExpr(expr)
        is ForExpr -> lowerForExpr(expr)
        is MatchExpr -> lowerMatchExpr(expr)

        is TupleLit -> {
            val elems = expr.elements.map { lowerExpr(it) }
            emit(IrInst.MakeTuple(freshRef(), IrType.Tuple(List(elems.size) { IrType.Any }), elems, expr.span))
        }

        is ListLit -> {
            val elems = expr.elements.map { lowerExpr(it) }
            val listType = typeOf(expr).let { if (it is IrType.List) it else IrType.List(IrType.Any) }
            emit(IrInst.MakeList(freshRef(), listType, elems, expr.span))
        }

        is RecordLit -> {
            val entries = expr.fields.map { f ->
                val key = emit(IrInst.Const(freshRef(), IrType.Str, IrConst.Str(f.name), f.span))
                key to lowerExpr(f.value)
            }
            emit(IrInst.MakeDict(freshRef(), IrType.Dict(IrType.Str, IrType.Any), entries, expr.span))
        }

        is DictLit -> {
            val entries = expr.entries.map { (k, v) -> lowerExpr(k) to lowerExpr(v) }
            emit(IrInst.MakeDict(freshRef(), IrType.Dict(IrType.Str, IrType.Any), entries, expr.span))
        }

        is StructLit -> {
            val span = expr.span
            val payloadFields = expr.fields.map { it.name to lowerExpr(it.value) }
            val allFields = if (expr.typeName in enumVariants) {
                // Enum variant: prepend __variant tag automatically
                val tag = emit(IrInst.Const(freshRef(), IrType.Str, IrConst.Str(expr.typeName), span))
                listOf("__variant" to tag) + payloadFields
            } else {
                payloadFields
            }
            emit(IrInst.MakeRecord(freshRef(), IrType.Struct(expr.typeName), allFields, span))
        }

        is SpawnExpr -> {
            val enclosing = currentFn?.name ?: "nova_main"
            val liftedName = "${enclosing}\$spawn${lambdaCounter++}"
            val lambda = expr.expr as? Lambda
            if (lambda != null) {
                val bodyFreeVars = freeVars(lambda.body, lambda.params.map { it.name }.toSet())
                val captures = bodyFreeVars.filter { slots.containsKey(it) }
                val params = captures.map { it to IrType.Any }
                val irFn = IrFunction(liftedName, params, IrType.Unit, span = expr.span)
                module.functions.add(irFn)
                withFunction(irFn) {
                    for (capName in captures) {
                        val slot = IrSlot(capName)
                        slots[capName] = slot
                        emit(IrInst.SlotAlloc(freshRef(), IrType.Any, slot, expr.span))
                        emit(IrInst.SlotStore(freshRef(), IrType.Unit, slot, paramRef(capName, irFn), expr.span))
                    }
                    val result = when (val b = lambda.body) {
                        is ExprBody  -> lowerExpr(b.expr)
                        is BlockBody -> lowerBlock(b.block)
                    }
                    terminateIfNeeded(IrTerminator.Return(result, expr.span))
                }
                val captureRefs = captures.map { name ->
                    val s = slots[name]
                    if (s != null) emit(IrInst.SlotLoad(freshRef(), IrType.Any, s, expr.span))
                    else freshRef()
                }
                emit(IrInst.Spawn(freshRef(), IrType.Process, liftedName, captureRefs, expr.span))
            } else {
                val captures = freeVarsExpr(expr.expr, emptySet()).filter { slots.containsKey(it) }
                val params = captures.map { it to IrType.Any }
                val irFn = IrFunction(liftedName, params, IrType.Unit, span = expr.span)
                module.functions.add(irFn)
                withFunction(irFn) {
                    for (capName in captures) {
                        val slot = IrSlot(capName)
                        slots[capName] = slot
                        emit(IrInst.SlotAlloc(freshRef(), IrType.Any, slot, expr.span))
                        emit(IrInst.SlotStore(freshRef(), IrType.Unit, slot, paramRef(capName, irFn), expr.span))
                    }
                    lowerExpr(expr.expr)
                    terminateIfNeeded(IrTerminator.Return(unitRef(expr.span), expr.span))
                }
                val captureRefs = captures.map { name ->
                    val s = slots[name]
                    if (s != null) emit(IrInst.SlotLoad(freshRef(), IrType.Any, s, expr.span))
                    else freshRef()
                }
                emit(IrInst.Spawn(freshRef(), IrType.Process, liftedName, captureRefs, expr.span))
            }
        }

        is ReceiveExpr -> {
            val ch = lowerExpr(expr.channel)
            emit(IrInst.ChannelReceive(freshRef(), IrType.Any, ch, expr.span))
        }

        is ReturnExpr -> {
            val v = expr.value?.let { lowerExpr(it) } ?: unitRef(expr.span)
            terminateIfNeeded(IrTerminator.Return(v, expr.span))
            val dead = currentFn!!.newBlock("dead")
            currentBlock = dead
            v
        }

        is ErrorExpr -> emit(IrInst.Const(freshRef(), IrType.Any, IrConst.Str("parse_error"), expr.span))

        is TryExpr -> lowerTryExpr(expr)
        is TryCatchExpr -> lowerTryCatchExpr(expr)
    }

    // ── Binary ops ───────────────────────────────────────────────────────────

    private fun lowerBinaryOp(expr: BinaryOp): IrRef {
        val span = expr.span
        return when (expr.op) {
            ".." -> {
                val l = lowerExpr(expr.left)
                val r = lowerExpr(expr.right)
                emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_range", listOf(l, r), span))
            }
            "|>" -> {
                val l = lowerExpr(expr.left)
                val r = lowerExpr(expr.right)
                emit(IrInst.Call(freshRef(), IrType.Any, r, listOf(l), span))
            }
            "and" -> {
                // Short-circuit: if left is false, skip right
                val l = lowerExpr(expr.left)
                val resultSlot = IrSlot("__sc_and_${scCounter++}")
                emit(IrInst.SlotAlloc(freshRef(), IrType.Any, resultSlot, span))
                emit(IrInst.SlotStore(freshRef(), IrType.Unit, resultSlot, emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(0), span)), span))
                val evalRight = currentFn!!.newBlock("sc_and_right")
                val mergeBlock = currentFn!!.newBlock("sc_and_merge")
                val cond = emit(IrInst.Binary(freshRef(), IrType.Bool, BinOp.NE, l,
                    emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(0), span)), span))
                terminateIfNeeded(IrTerminator.Branch(cond, evalRight.id, mergeBlock.id, span))
                currentBlock = evalRight
                val r = lowerExpr(expr.right)
                emit(IrInst.SlotStore(freshRef(), IrType.Unit, resultSlot, r, span))
                terminateIfNeeded(IrTerminator.Goto(mergeBlock.id, span))
                currentBlock = mergeBlock
                emit(IrInst.SlotLoad(freshRef(), IrType.Any, resultSlot, span))
            }
            "or" -> {
                // Short-circuit: if left is true, skip right
                val l = lowerExpr(expr.left)
                val resultSlot = IrSlot("__sc_or_${scCounter++}")
                emit(IrInst.SlotAlloc(freshRef(), IrType.Any, resultSlot, span))
                emit(IrInst.SlotStore(freshRef(), IrType.Unit, resultSlot, emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(1), span)), span))
                val evalRight = currentFn!!.newBlock("sc_or_right")
                val mergeBlock = currentFn!!.newBlock("sc_or_merge")
                val cond = emit(IrInst.Binary(freshRef(), IrType.Bool, BinOp.NE, l,
                    emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(0), span)), span))
                terminateIfNeeded(IrTerminator.Branch(cond, mergeBlock.id, evalRight.id, span))
                currentBlock = evalRight
                val r = lowerExpr(expr.right)
                emit(IrInst.SlotStore(freshRef(), IrType.Unit, resultSlot, r, span))
                terminateIfNeeded(IrTerminator.Goto(mergeBlock.id, span))
                currentBlock = mergeBlock
                emit(IrInst.SlotLoad(freshRef(), IrType.Any, resultSlot, span))
            }
            "in" -> {
                val item = lowerExpr(expr.left)
                val container = lowerExpr(expr.right)
                emit(IrInst.CallDirect(freshRef(), IrType.Bool, "nova_rt_contains", listOf(container, item), span))
            }
            "matches" -> {
                val text = lowerExpr(expr.left)
                val pattern = lowerExpr(expr.right)
                emit(IrInst.CallDirect(freshRef(), IrType.Bool, "nova_rt_regex_match", listOf(text, pattern), span))
            }
            else -> {
                // Check if `+` is string concatenation before lowering operands
                val isStringConcat = expr.op == "+" &&
                    (typeOf(expr.left) == IrType.Str || typeOf(expr.right) == IrType.Str ||
                     typeOf(expr) == IrType.Str)
                val l = lowerExpr(expr.left)
                val r = lowerExpr(expr.right)
                if (isStringConcat) {
                    return emit(IrInst.StringConcat(freshRef(), IrType.Str, listOf(l, r), span))
                }
                val irType = typeOf(expr)
                val op = when (expr.op) {
                    "+"   -> BinOp.ADD; "-"   -> BinOp.SUB
                    "*"   -> BinOp.MUL; "/"   -> BinOp.DIV
                    "%"   -> BinOp.MOD; "**"  -> BinOp.POW
                    "=="  -> BinOp.EQ;  "!="  -> BinOp.NE
                    "<"   -> BinOp.LT;  ">"   -> BinOp.GT
                    "<="  -> BinOp.LE;  ">="  -> BinOp.GE
                    "&"   -> BinOp.BIT_AND; "|" -> BinOp.BIT_OR
                    "^"   -> BinOp.BIT_XOR
                    "<<"  -> BinOp.SHL; ">>"  -> BinOp.SHR
                    else  -> BinOp.ADD
                }
                emit(IrInst.Binary(freshRef(), irType, op, l, r, span))
            }
        }
    }

    // ── If expressions ───────────────────────────────────────────────────────

    private fun lowerIfExpr(expr: IfExpr): IrRef {
        val span = expr.span
        val cond = lowerExpr(expr.condition)

        val thenBlock  = currentFn!!.newBlock("if_then")
        val elseBlock  = currentFn!!.newBlock("if_else")
        val mergeBlock = currentFn!!.newBlock("if_merge")

        terminateIfNeeded(IrTerminator.Branch(cond, thenBlock.id, elseBlock.id, span))

        // Result slot for the if-expression value
        val resultSlot = IrSlot("__if_${ifbCounter++}")
        emit(IrInst.SlotAlloc(freshRef(), IrType.Any, resultSlot, span))

        currentBlock = thenBlock
        val thenVal = lowerExpr(expr.thenExpr)
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, resultSlot, thenVal, span))
        terminateIfNeeded(IrTerminator.Goto(mergeBlock.id, span))

        currentBlock = elseBlock
        val elseVal = expr.elseExpr?.let { lowerExpr(it) } ?: unitRef(span)
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, resultSlot, elseVal, span))
        terminateIfNeeded(IrTerminator.Goto(mergeBlock.id, span))

        currentBlock = mergeBlock
        return emit(IrInst.SlotLoad(freshRef(), IrType.Any, resultSlot, span))
    }

    private fun lowerIfBlockExpr(expr: IfBlockExpr): IrRef {
        val span = expr.span
        val cond = lowerExpr(expr.condition)

        val thenBlock  = currentFn!!.newBlock("ifb_then")
        val elseBlock  = currentFn!!.newBlock("ifb_else")
        val mergeBlock = currentFn!!.newBlock("ifb_merge")

        terminateIfNeeded(IrTerminator.Branch(cond, thenBlock.id, elseBlock.id, span))

        val resultSlot = IrSlot("__ifb_${ifbCounter++}")
        emit(IrInst.SlotAlloc(freshRef(), IrType.Any, resultSlot, span))

        currentBlock = thenBlock
        val thenVal = lowerBlock(expr.thenBlock)
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, resultSlot, thenVal, span))
        terminateIfNeeded(IrTerminator.Goto(mergeBlock.id, span))

        currentBlock = elseBlock
        val elseVal: IrRef = when (val ec = expr.elseClause) {
            null       -> unitRef(span)
            is ElseBlock -> lowerBlock(ec.body)
            is ElseIf  -> lowerExpr(ec.ifExpr)
        }
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, resultSlot, elseVal, span))
        terminateIfNeeded(IrTerminator.Goto(mergeBlock.id, span))

        currentBlock = mergeBlock
        return emit(IrInst.SlotLoad(freshRef(), IrType.Any, resultSlot, span))
    }

    // ── For-expression (collects results into a list) ─────────────────────────

    private fun lowerForExpr(expr: ForExpr): IrRef {
        val span = expr.span

        // Range comprehension: [expr for x in start..end]
        if (expr.iterable is BinaryOp && (expr.iterable as BinaryOp).op == "..") {
            return lowerForExprRange(expr, expr.iterable as BinaryOp)
        }

        val iterVal = lowerExpr(expr.iterable)

        // Accumulator list
        val listSlot = IrSlot("__for_result_${slots.size}")
        emit(IrInst.SlotAlloc(freshRef(), IrType.Any, listSlot, span))
        val emptyList = emit(IrInst.MakeList(freshRef(), IrType.List(IrType.Any), emptyList(), span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, listSlot, emptyList, span))

        // Store iter in a slot so it survives optimizer block boundaries
        val iterSlot = IrSlot("__fore_iter_${slots.size}")
        emit(IrInst.SlotAlloc(freshRef(), IrType.Any, iterSlot, span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, iterSlot, iterVal, span))

        // Index slot
        val indexSlot = IrSlot("__fore_idx_${slots.size}")
        emit(IrInst.SlotAlloc(freshRef(), IrType.I64, indexSlot, span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, indexSlot,
            emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(0), span)), span))

        val headerBlock = currentFn!!.newBlock("fore_header")
        val bodyBlock   = currentFn!!.newBlock("fore_body")
        val exitBlock   = currentFn!!.newBlock("fore_exit")

        terminateIfNeeded(IrTerminator.Goto(headerBlock.id, span))
        currentBlock = headerBlock

        val iter0   = emit(IrInst.SlotLoad(freshRef(), IrType.Any, iterSlot, span))
        val idxRef  = emit(IrInst.SlotLoad(freshRef(), IrType.I64, indexSlot, span))
        val foreIterType = typeEnv[expr.iterable]
        val foreHasNextFn = if (foreIterType is nova.types.TList) "nova_rt_list_iter_has_next" else "nova_rt_iter_has_next"
        val hasNext = emit(IrInst.CallDirect(freshRef(), IrType.Bool, foreHasNextFn,
            listOf(iter0, idxRef), span))
        terminateIfNeeded(IrTerminator.Branch(hasNext, bodyBlock.id, exitBlock.id, span))

        currentBlock = bodyBlock
        loopStack.addLast(LoopContext(headerBlock.id, exitBlock.id))

        val iter1   = emit(IrInst.SlotLoad(freshRef(), IrType.Any, iterSlot, span))
        val idxRef2 = emit(IrInst.SlotLoad(freshRef(), IrType.I64, indexSlot, span))
        val elem    = emit(IrInst.IndexGet(freshRef(), IrType.Any, iter1, idxRef2, span))
        bindPattern(expr.variable, elem, span)

        val bodyVal = when (val b = expr.body) {
            is ExprBody  -> lowerExpr(b.expr)
            is BlockBody -> lowerBlock(b.block)
        }

        val listRef = emit(IrInst.SlotLoad(freshRef(), IrType.Any, listSlot, span))
        emit(IrInst.ListAppend(freshRef(), IrType.Unit, listRef, bodyVal, span))

        val nextIdx = emit(IrInst.Binary(freshRef(), IrType.I64, BinOp.ADD, idxRef2,
            emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(1), span)), span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, indexSlot, nextIdx, span))
        terminateIfNeeded(IrTerminator.Goto(headerBlock.id, span))

        loopStack.removeLast()
        currentBlock = exitBlock
        return emit(IrInst.SlotLoad(freshRef(), IrType.Any, listSlot, span))
    }

    private fun lowerForExprRange(expr: ForExpr, range: BinaryOp): IrRef {
        val span = expr.span
        val startVal = lowerExpr(range.left)
        val endVal = lowerExpr(range.right)

        val listSlot = IrSlot("__for_result_${slots.size}")
        emit(IrInst.SlotAlloc(freshRef(), IrType.Any, listSlot, span))
        val emptyList = emit(IrInst.MakeList(freshRef(), IrType.List(IrType.Any), emptyList(), span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, listSlot, emptyList, span))

        val indexSlot = IrSlot("__fore_idx_${slots.size}")
        emit(IrInst.SlotAlloc(freshRef(), IrType.I64, indexSlot, span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, indexSlot, startVal, span))

        val endSlot = IrSlot("__fore_end_${slots.size}")
        emit(IrInst.SlotAlloc(freshRef(), IrType.I64, endSlot, span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, endSlot, endVal, span))

        val headerBlock = currentFn!!.newBlock("fore_header")
        val bodyBlock   = currentFn!!.newBlock("fore_body")
        val exitBlock   = currentFn!!.newBlock("fore_exit")

        terminateIfNeeded(IrTerminator.Goto(headerBlock.id, span))
        currentBlock = headerBlock

        val idx0 = emit(IrInst.SlotLoad(freshRef(), IrType.I64, indexSlot, span))
        val end0 = emit(IrInst.SlotLoad(freshRef(), IrType.I64, endSlot, span))
        val cond = emit(IrInst.Binary(freshRef(), IrType.Bool, BinOp.LE, idx0, end0, span))
        terminateIfNeeded(IrTerminator.Branch(cond, bodyBlock.id, exitBlock.id, span))

        currentBlock = bodyBlock
        loopStack.addLast(LoopContext(headerBlock.id, exitBlock.id))

        val idx1 = emit(IrInst.SlotLoad(freshRef(), IrType.I64, indexSlot, span))
        bindPattern(expr.variable, idx1, span)

        val bodyVal = when (val b = expr.body) {
            is ExprBody  -> lowerExpr(b.expr)
            is BlockBody -> lowerBlock(b.block)
        }

        val listRef = emit(IrInst.SlotLoad(freshRef(), IrType.Any, listSlot, span))
        emit(IrInst.ListAppend(freshRef(), IrType.Unit, listRef, bodyVal, span))

        val idx2 = emit(IrInst.SlotLoad(freshRef(), IrType.I64, indexSlot, span))
        val nextIdx = emit(IrInst.Binary(freshRef(), IrType.I64, BinOp.ADD, idx2,
            emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(1), span)), span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, indexSlot, nextIdx, span))
        terminateIfNeeded(IrTerminator.Goto(headerBlock.id, span))

        loopStack.removeLast()
        currentBlock = exitBlock
        return emit(IrInst.SlotLoad(freshRef(), IrType.Any, listSlot, span))
    }

    // ── Match expression ─────────────────────────────────────────────────────

    private fun lowerMatchExpr(expr: MatchExpr): IrRef {
        val span = expr.span
        val subject = lowerExpr(expr.subject)
        val mergeBlock = currentFn!!.newBlock("match_merge")
        // Move merge block to end after arms are emitted (ensures type refiner sees stores first)
        currentFn!!.blocks.remove(mergeBlock)
        val resultSlot = IrSlot("__match_${matchCounter++}")
        emit(IrInst.SlotAlloc(freshRef(), IrType.Any, resultSlot, span))

        for ((i, arm) in expr.arms.withIndex()) {
            val nextCheckBlock = if (i < expr.arms.lastIndex)
                currentFn!!.newBlock("arm${i}_next") else null
            val elseTarget = nextCheckBlock?.id ?: mergeBlock.id

            if (arm.guard != null) {
                val armGuardBlock = currentFn!!.newBlock("arm${i}_guard")
                val armBodyBlock = currentFn!!.newBlock("arm${i}_body")

                val matched = testPattern(arm.pattern, subject, span)
                if (matched != null) {
                    terminateIfNeeded(IrTerminator.Branch(matched, armGuardBlock.id, elseTarget, span))
                } else {
                    terminateIfNeeded(IrTerminator.Goto(armGuardBlock.id, span))
                }

                currentBlock = armGuardBlock
                bindPatternVars(arm.pattern, subject, span)
                val guardVal = lowerExpr(arm.guard)
                terminateIfNeeded(IrTerminator.Branch(guardVal, armBodyBlock.id, elseTarget, span))

                currentBlock = armBodyBlock
            } else {
                val armBodyBlock = currentFn!!.newBlock("arm${i}_body")
                val matched = testPattern(arm.pattern, subject, span)
                if (matched != null) {
                    terminateIfNeeded(IrTerminator.Branch(matched, armBodyBlock.id, elseTarget, span))
                } else {
                    terminateIfNeeded(IrTerminator.Goto(armBodyBlock.id, span))
                }
                currentBlock = armBodyBlock
                bindPatternVars(arm.pattern, subject, span)
            }

            val armVal = when (val b = arm.body) {
                is ExprBody  -> lowerExpr(b.expr)
                is BlockBody -> lowerBlock(b.block)
            }
            emit(IrInst.SlotStore(freshRef(), IrType.Unit, resultSlot, armVal, span))
            terminateIfNeeded(IrTerminator.Goto(mergeBlock.id, span))

            if (nextCheckBlock != null) {
                currentBlock = nextCheckBlock
            }
        }

        currentFn!!.blocks.add(mergeBlock)
        currentBlock = mergeBlock
        return emit(IrInst.SlotLoad(freshRef(), IrType.Any, resultSlot, span))
    }

    // Returns a bool IrRef testing if `subject` matches `pat`, or null for wildcard.
    private fun testPattern(pat: Pattern, subject: IrRef, span: SourceSpan): IrRef? = when (pat) {
        is WildcardPat -> null
        is IdentPat    -> null  // bind-only, always matches
        is LiteralPat  -> {
            val lit = lowerExpr(pat.lit)
            emit(IrInst.Binary(freshRef(), IrType.Bool, BinOp.EQ, subject, lit, span))
        }
        is TuplePat -> null  // Tuples always match structurally; binding extracts elements
        is ConstructorPat -> {
            val structType = IrType.Struct(pat.name)
            val hashRef = emit(IrInst.FieldGet(freshRef(), IrType.I64, subject, "__type_hash", span, objType = structType))
            val expectedHash = typeNameHash(pat.name)
            val expectedRef = emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(expectedHash), span))
            emit(IrInst.Binary(freshRef(), IrType.Bool, BinOp.EQ, hashRef, expectedRef, span))
        }
    }

    private fun typeNameHash(name: String): Long {
        var h = 5381L
        for (c in name) {
            h = h * 33 + c.code
        }
        return h
    }

    // Bind pattern variables into slots (called after the pattern test passes).
    private fun bindPatternVars(pat: Pattern, subject: IrRef, span: SourceSpan) {
        when (pat) {
            is IdentPat -> writeSlot(pat.name, subject, span)
            is TuplePat -> pat.elements.forEachIndexed { i, p ->
                val idxRef = emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(i.toLong()), span))
                val elem = emit(IrInst.IndexGet(freshRef(), IrType.Any, subject, idxRef, span))
                bindPatternVars(p, elem, span)
            }
            is ConstructorPat -> pat.arg?.let { arg ->
                val fields = enumVariants[pat.name]
                    ?: module.structs.firstOrNull { it.first == pat.name }?.second
                    ?: emptyList()
                val structType = IrType.Struct(pat.name)
                when {
                    arg is IdentPat && fields.size == 1 -> {
                        val (fname, ftype) = fields[0]
                        val field = emit(IrInst.FieldGet(freshRef(), ftype, subject, fname, span, objType = structType))
                        writeSlot(arg.name, field, span)
                    }
                    arg is TuplePat -> {
                        for ((i, subPat) in arg.elements.withIndex()) {
                            if (i >= fields.size) break
                            val (fname, ftype) = fields[i]
                            val field = emit(IrInst.FieldGet(freshRef(), ftype, subject, fname, span, objType = structType))
                            bindPatternVars(subPat, field, span)
                        }
                    }
                    else -> bindPatternVars(arg, subject, span)
                }
            }
            else -> {}
        }
    }

    // For-loop pattern binding (always matches, just extracts)
    private fun bindPattern(pat: Pattern, value: IrRef, span: SourceSpan) {
        bindPatternVars(pat, value, span)
    }

    // ── ElseOp (error-default) ────────────────────────────────────────────────

    private fun lowerElseOp(expr: ElseOp): IrRef {
        val span = expr.span
        val value = lowerExpr(expr.expr)

        val isErr = emit(IrInst.IsError(freshRef(), IrType.Bool, value, span))
        val errBlock = currentFn!!.newBlock("else_err")
        val okBlock  = currentFn!!.newBlock("else_ok")
        val mergeBlock = currentFn!!.newBlock("else_merge")
        val resultSlot = IrSlot("__else_${slots.size}")
        emit(IrInst.SlotAlloc(freshRef(), IrType.Any, resultSlot, span))

        terminateIfNeeded(IrTerminator.Branch(isErr, errBlock.id, okBlock.id, span))

        currentBlock = errBlock
        val defaultVal = lowerExpr(expr.default)
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, resultSlot, defaultVal, span))
        terminateIfNeeded(IrTerminator.Goto(mergeBlock.id, span))

        currentBlock = okBlock
        val okVal = emit(IrInst.UnwrapError(freshRef(), IrType.Any, value, span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, resultSlot, okVal, span))
        terminateIfNeeded(IrTerminator.Goto(mergeBlock.id, span))

        currentBlock = mergeBlock
        return emit(IrInst.SlotLoad(freshRef(), IrType.Any, resultSlot, span))
    }

    // ── try expr (error propagation) ─────────────────────────────────────────
    // Evaluates expr; if it errored, re-raises the error and returns early from
    // the current function. Callers see the error flag set and handle it with
    // `else` / `catch`.

    private fun lowerTryExpr(expr: TryExpr): IrRef {
        val span = expr.span
        val value = lowerExpr(expr.expr)

        val isErr = emit(IrInst.IsError(freshRef(), IrType.Bool, value, span))
        val errBlock  = currentFn!!.newBlock("try_err")
        val okBlock   = currentFn!!.newBlock("try_ok")

        terminateIfNeeded(IrTerminator.Branch(isErr, errBlock.id, okBlock.id, span))

        // Error path: re-raise so caller sees the error, then return 0 immediately.
        currentBlock = errBlock
        emit(IrInst.RaiseError(freshRef(), IrType.Unit, span))
        val zeroRef = emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(0), span))
        terminateIfNeeded(IrTerminator.Return(zeroRef, span))

        // OK path: continue with the unwrapped value.
        currentBlock = okBlock
        return emit(IrInst.UnwrapError(freshRef(), IrType.Any, value, span))
    }

    // ── expr catch e { block } (error handling with binding) ─────────────────
    // Evaluates expr; if it errored, binds the error message string to errorVar
    // and runs the handler block. The result is the handler result (error path)
    // or the unwrapped value (ok path).

    private fun lowerTryCatchExpr(expr: TryCatchExpr): IrRef {
        val span = expr.span
        val value = lowerExpr(expr.expr)

        // IsError reads + clears @__nova_error_flag. @__nova_error_msg is left intact
        // so LoadErrorMsg can read it in the error branch.
        val isErr = emit(IrInst.IsError(freshRef(), IrType.Bool, value, span))
        val errBlock   = currentFn!!.newBlock("catch_err")
        val okBlock    = currentFn!!.newBlock("catch_ok")
        val mergeBlock = currentFn!!.newBlock("catch_merge")
        val resultSlot = IrSlot("__catch_${slots.size}")
        // Hoist alloca to entry block (required by LLVM mem2reg / alloca hoisting pass).
        val savedBlock = currentBlock
        currentBlock = entryBlock
        emit(IrInst.SlotAlloc(freshRef(), IrType.Any, resultSlot, span))
        currentBlock = savedBlock

        terminateIfNeeded(IrTerminator.Branch(isErr, errBlock.id, okBlock.id, span))

        // Error branch: load the error message, bind it to errorVar, run handler.
        currentBlock = errBlock
        val msgSlot = IrSlot("__err_${expr.errorVar}_${slots.size}")
        val savedBlock2 = currentBlock
        currentBlock = entryBlock
        emit(IrInst.SlotAlloc(freshRef(), IrType.Str, msgSlot, span))
        currentBlock = savedBlock2
        val msgVal = emit(IrInst.LoadErrorMsg(freshRef(), IrType.Str, span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, msgSlot, msgVal, span))
        // Temporarily bind errorVar in the slots map so the handler can read it.
        val prevSlot: IrSlot? = slots[expr.errorVar]
        slots[expr.errorVar] = msgSlot
        val handlerResult = lowerBlock(expr.handler)
        if (prevSlot != null) slots[expr.errorVar] = prevSlot else slots.remove(expr.errorVar)
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, resultSlot, handlerResult, span))
        terminateIfNeeded(IrTerminator.Goto(mergeBlock.id, span))

        // OK branch: use the value directly.
        currentBlock = okBlock
        val okVal = emit(IrInst.UnwrapError(freshRef(), IrType.Any, value, span))
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, resultSlot, okVal, span))
        terminateIfNeeded(IrTerminator.Goto(mergeBlock.id, span))

        currentBlock = mergeBlock
        return emit(IrInst.SlotLoad(freshRef(), IrType.Any, resultSlot, span))
    }

    // ── Call lowering ─────────────────────────────────────────────────────────

    private fun lowerCall(expr: Call): IrRef {
        val span = expr.span
        val callee = expr.callee

        // Special-case channel/process builtins so they map to typed IR ops.
        if (callee is Ident) {
            when (callee.name) {
                "error" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, "error", args, span))
                }
                "len" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "len", args, span))
                }
                "print" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, "print", args, span))
                }
                // Math stdlib — emit as CallDirect so emitCallDirect can inline them
                "abs", "max", "min", "sqrt", "floor", "ceil",
                // Extended math (trig, log, exp) — route to C runtime
                "sin", "cos", "tan", "asin", "acos", "atan", "atan2",
                "log", "log2", "log10", "exp", "fabs", "fmod", "round" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, callee.name, args, span))
                }
                // Type conversions — emit as CallDirect for type-aware dispatch
                "int", "float", "str" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, callee.name, args, span))
                }
                // IO stdlib
                "read_line" -> return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_read_line", emptyList(), span))
                "read_file" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_read_file", args, span))
                }
                "write_file" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Unit, "nova_rt_write_file", args, span))
                }
                "append_file" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Unit, "nova_rt_append_file", args, span))
                }
                "file_exists" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Bool, "nova_rt_file_exists", args, span))
                }
                "json_parse" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_json_parse", args, span))
                }
                "json_stringify" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_json_stringify", args, span))
                }
                "http_get" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_http_get", args, span))
                }
                "http_post" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_http_post", args, span))
                }
                "mkdir" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_mkdir", args, span))
                }
                "mkdir_p" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_mkdir_p", args, span))
                }
                "path_join" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_path_join", args, span))
                }
                "path_exists" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_path_exists", args, span))
                }
                "path_parent" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_path_parent", args, span))
                }
                "path_name" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_path_name", args, span))
                }
                "channel" -> return emit(IrInst.ChannelCreate(freshRef(), IrType.Channel, span))
                "send" -> {
                    val ch  = lowerExpr(expr.args[0].value)
                    val v   = lowerExpr(expr.args[1].value)
                    return emit(IrInst.ChannelSend(freshRef(), IrType.Unit, ch, v, span))
                }
                "receive" -> {
                    val ch = lowerExpr(expr.args[0].value)
                    return emit(IrInst.ChannelReceive(freshRef(), IrType.Any, ch, span))
                }
                "select" -> {
                    val channels = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.ChannelSelect(freshRef(),
                        IrType.Tuple(listOf(IrType.I64, IrType.Any)), channels, span))
                }
                "close" -> {
                    val ch = lowerExpr(expr.args[0].value)
                    return emit(IrInst.ChannelClose(freshRef(), IrType.Unit, ch, span))
                }
                "recv_timeout" -> {
                    val ch = lowerExpr(expr.args[0].value)
                    val ms = lowerExpr(expr.args[1].value)
                    return emit(IrInst.ChannelRecvTimeout(freshRef(), IrType.Any, ch, ms, span))
                }
                "monitor" -> {
                    val proc = lowerExpr(expr.args[0].value)
                    return emit(IrInst.CallDirect(freshRef(), IrType.Channel, "nova_rt_monitor", listOf(proc), span))
                }
                // String stdlib — free-function calls route to nova_rt_*
                "upper", "lower", "trim", "chars", "reverse", "is_empty", "repeat" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_${callee.name}", args, span))
                }
                "split", "join", "replace", "starts_with", "ends_with", "find", "contains", "slice" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_${callee.name}", args, span))
                }
                // Character operations
                "ord" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_ord", args, span))
                }
                "chr" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_chr", args, span))
                }
                // Process control
                "exit" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Unit, "nova_rt_exit", args, span))
                }
                // Time stdlib
                "time_ms" -> return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_time_ms", emptyList(), span))
                "clock_ns" -> return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_clock_ns", emptyList(), span))
                "sleep" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Unit, "nova_rt_sleep_ms", args, span))
                }
                "assert" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Unit, "nova_rt_assert", args, span))
                }
                "system" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_system", args, span))
                }
                "exec" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_exec", args, span))
                }
                // System stdlib — args, env, random, shell
                "args" -> return emit(IrInst.CallDirect(freshRef(), IrType.List(IrType.Str), "nova_rt_args", emptyList(), span))
                "env" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_env", args, span))
                }
                "random" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return if (args.isEmpty()) {
                        emit(IrInst.CallDirect(freshRef(), IrType.F64, "nova_rt_random_float", emptyList(), span))
                    } else {
                        emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_random_int", args, span))
                    }
                }
                "shell" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_shell", args, span))
                }
                // Path stdlib
                "path_join" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_path_join", args, span))
                }
                "path_parent" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_path_parent", args, span))
                }
                "path_name" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_path_name", args, span))
                }
                "path_ext" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_path_ext", args, span))
                }
                // Regex stdlib
                "regex_find" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_regex_find", args, span))
                }
                "regex_replace" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_regex_replace", args, span))
                }
                "regex_split" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_regex_split", args, span))
                }
                // Network stdlib — TCP/UDP
                "tcp_connect" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_tcp_connect", args, span))
                }
                "tcp_listen" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_tcp_listen", args, span))
                }
                "tcp_accept" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_tcp_accept", args, span))
                }
                "tcp_send" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_tcp_send", args, span))
                }
                "tcp_recv" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_tcp_recv", args, span))
                }
                "tcp_close" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Unit, "nova_rt_tcp_close", args, span))
                }
                "udp_bind" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_udp_bind", args, span))
                }
                "udp_send" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_udp_send", args, span))
                }
                "udp_recv" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_udp_recv", args, span))
                }
                // HTTP server stdlib
                "http_listen" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_http_listen", args, span))
                }
                "http_accept" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_http_accept", args, span))
                }
                "http_respond" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Unit, "nova_rt_http_respond", args, span))
                }
                // Byte array stdlib
                "bytes" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_bytes_create", args, span))
                }
                "bytes_get" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_bytes_get", args, span))
                }
                "bytes_set" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Unit, "nova_rt_bytes_set", args, span))
                }
                "bytes_len" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_bytes_len", args, span))
                }
                "bytes_slice" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_bytes_slice", args, span))
                }
                "bytes_to_str" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_bytes_to_str", args, span))
                }
                "str_to_bytes" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_str_to_bytes", args, span))
                }
                // List stdlib — free-function calls
                "push", "concat", "sort", "map", "filter" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_${callee.name}", args, span))
                }
                "list_concat" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_list_concat", args, span))
                }
                "list_reverse" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_list_reverse", args, span))
                }
                "list_sort" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_list_sort", args, span))
                }
                "list_slice" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, "nova_rt_list_slice", args, span))
                }
                // Dict stdlib — free-function calls
                "keys", "dict_keys" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.List(IrType.Str), "nova_rt_keys", args, span))
                }
                "values", "dict_values" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.List(IrType.Any), "nova_rt_values", args, span))
                }
                "dict_items" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.List(IrType.Any), "nova_rt_items", args, span))
                }
                // Conversion/introspection stdlib
                "type_of" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_type_of", args, span))
                }
                "any_to_str" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Str, "nova_rt_any_to_str", args, span))
                }
                "range" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.List(IrType.I64), "nova_rt_range", args, span))
                }
                "parse_int" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.I64, "nova_rt_parse_int", args, span))
                }
                "parse_float" -> {
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.F64, "nova_rt_parse_float", args, span))
                }
                "spawn" -> {
                    val enclosing = currentFn?.name ?: "nova_main"
                    val liftedName = "${enclosing}\$spawn${lambdaCounter++}"
                    val bodyExpr = expr.args[0].value

                    // Capture free variables (channels, data) from outer scope.
                    // Same pattern as lambda lifting — must be computed before
                    // withFunction clears the outer slots map.
                    val captures = freeVarsExpr(bodyExpr, emptySet())
                        .filter { slots.containsKey(it) }
                    val params = captures.map { it to IrType.Any }

                    val irFn = IrFunction(liftedName, params, IrType.Unit, span = span)
                    module.functions.add(irFn)
                    withFunction(irFn) {
                        for (capName in captures) {
                            val slot = IrSlot(capName)
                            slots[capName] = slot
                            emit(IrInst.SlotAlloc(freshRef(), IrType.Any, slot, span))
                            emit(IrInst.SlotStore(freshRef(), IrType.Unit, slot,
                                paramRef(capName, irFn), span))
                        }
                        lowerExpr(bodyExpr)
                        terminateIfNeeded(IrTerminator.Return(unitRef(span), span))
                    }

                    // Load captured values from caller's scope for spawn args
                    val captureRefs = captures.map { name ->
                        val s = slots[name]
                        if (s != null) emit(IrInst.SlotLoad(freshRef(), IrType.Any, s, span))
                        else freshRef()
                    }
                    return emit(IrInst.Spawn(freshRef(), IrType.Process, liftedName, captureRefs, span))
                }
            }
        }

        // Enum variant positional constructor: Circle(5.0) → MakeRecord with __variant tag.
        if (callee is Ident && callee.name in enumVariants) {
            val variantName = callee.name
            val fieldDefs = enumVariants[variantName]!!
            val args = expr.args.map { lowerExpr(it.value) }
            val tag = emit(IrInst.Const(freshRef(), IrType.Str, IrConst.Str(variantName), span))
            val fields = mutableListOf<Pair<String, IrRef>>("__variant" to tag)
            for ((i, fieldDef) in fieldDefs.withIndex()) {
                if (i < args.size) fields.add(fieldDef.first to args[i])
            }
            return emit(IrInst.MakeRecord(freshRef(), IrType.Struct(variantName), fields, span))
        }

        // Struct positional constructor: Pair(10, "ten") → MakeRecord.
        if (callee is Ident) {
            val structFieldDefs = module.structs.firstOrNull { it.first == callee.name }
            if (structFieldDefs != null) {
                val args = expr.args.map { lowerExpr(it.value) }
                val fields = structFieldDefs.second.mapIndexed { i, (fname, _) ->
                    fname to if (i < args.size) args[i] else emit(IrInst.Const(freshRef(), IrType.I64, IrConst.Int(0), span))
                }
                return emit(IrInst.MakeRecord(freshRef(), IrType.Struct(callee.name), fields, span))
            }
        }

        // Module-qualified call: module.func(args) → CallDirect to the function
        if (callee is MemberAccess && callee.target is Ident) {
            val moduleName = (callee.target as Ident).name
            val funcName = callee.member
            if (moduleName in importedModules && funcName in (importedModules[moduleName] ?: emptySet())) {
                val args = expr.args.map { lowerExpr(it.value) }
                return emit(IrInst.CallDirect(freshRef(), IrType.Any, funcName, args, span))
            }
        }

        // Member call: obj.method(args)
        if (callee is MemberAccess) {
            // Struct method dispatch: check if target is a struct with a registered method
            val targetType = typeEnv[callee.target]
            if (targetType is nova.types.TStruct) {
                val mangledName = methodRegistry[targetType.name]?.get(callee.member)
                if (mangledName != null) {
                    val target = lowerExpr(callee.target)
                    val args = expr.args.map { lowerExpr(it.value) }
                    return emit(IrInst.CallDirect(freshRef(), IrType.Any, mangledName, listOf(target) + args, span))
                }
            }
            // Stdlib method fallback
            val target = lowerExpr(callee.target)
            val args   = expr.args.map { lowerExpr(it.value) }
            return emit(IrInst.CallDirect(freshRef(), IrType.Any,
                "nova_rt_${callee.member}", listOf(target) + args, span))
        }

        // Direct call to a known function by name — avoids unnecessary MakeClosure.
        if (callee is Ident && callee.name in knownFunctions && callee.name !in slots) {
            val args = expr.args.map { lowerExpr(it.value) }.toMutableList()
            val defaults = functionDefaults[callee.name]
            if (defaults != null) {
                for (i in args.size until defaults.size) {
                    val def = defaults[i] ?: break
                    args.add(lowerExpr(def))
                }
            }
            return emit(IrInst.CallDirect(freshRef(), IrType.Any, callee.name, args, span))
        }

        // Closure or indirect call — callee is a value holding a function reference.
        val calleeRef = lowerExpr(callee)
        val args = expr.args.map { lowerExpr(it.value) }
        return emit(IrInst.Call(freshRef(), IrType.Any, calleeRef, args, span))
    }

    // ── Block lowering ────────────────────────────────────────────────────────

    private fun lowerBlock(block: Block, skipFnDecls: Boolean = false): IrRef {
        var last: IrRef = unitRef(block.span)
        for (stmt in block.stmts) {
            if (skipFnDecls && stmt is FnDecl) continue
            last = if (stmt is ExprStmt) lowerExpr(stmt.expr) else lowerStmt(stmt)
        }
        return last
    }

    // ── Slot helpers ──────────────────────────────────────────────────────────

    private fun readSlot(name: String, span: SourceSpan): IrRef {
        val slot = slots[name]
        return if (slot != null) {
            emit(IrInst.SlotLoad(freshRef(), IrType.Any, slot, span))
        } else {
            val gs = globalSlots[name]
            if (gs != null) {
                emit(IrInst.SlotLoad(freshRef(), IrType.Any, gs, span))
            } else {
                // Function reference (closure)
                emit(IrInst.MakeClosure(freshRef(), IrType.Any, name, emptyList(), span))
            }
        }
    }

    private fun writeSlot(name: String, value: IrRef, span: SourceSpan) {
        val slot = slots.getOrPut(name) {
            // In nova_main, use the global slot if this is a module-level variable.
            // In any other function, always create a local slot (shadowing globals).
            val gs = globalSlots[name]
            val s = if (gs != null && currentFn?.name == "nova_main") gs else IrSlot(name)
            // Alloca goes in entry block, not current block.
            val saved = currentBlock
            currentBlock = entryBlock
            emit(IrInst.SlotAlloc(freshRef(), IrType.Any, s, span))
            currentBlock = saved
            s
        }
        emit(IrInst.SlotStore(freshRef(), IrType.Unit, slot, value, span))
    }

    // ── Builder helpers ───────────────────────────────────────────────────────

    private fun freshRef(): IrRef = IrRef(refCounter++)

    private fun emit(inst: IrInst): IrRef {
        currentBlock!!.instructions.add(inst)
        return inst.result
    }

    private fun terminateIfNeeded(term: IrTerminator) {
        val block = currentBlock ?: return
        if (block.terminator == null) block.terminator = term
    }

    private fun unitRef(span: SourceSpan): IrRef =
        emit(IrInst.Const(freshRef(), IrType.Unit, IrConst.Unit, span))

    private fun paramRef(name: String, fn: IrFunction): IrRef {
        val idx = fn.params.indexOfFirst { it.first == name }
        return IrRef(-(idx + 1))  // negative IDs for params; printer handles them specially
    }

    private fun <T> withFunction(fn: IrFunction, block: () -> T): T {
        val savedFn    = currentFn
        val savedBlock = currentBlock
        val savedSlots = slots.toMutableMap()
        val savedEntry = entryBlock
        val savedRef   = refCounter
        val savedIfb   = ifbCounter

        currentFn = fn
        slots.clear()
        ifbCounter = 0
        val entry = fn.newBlock("entry")
        entryBlock   = entry
        currentBlock = entry

        val result = block()

        currentFn    = savedFn
        currentBlock = savedBlock
        slots.clear(); slots.putAll(savedSlots)
        entryBlock   = savedEntry
        refCounter   = savedRef
        ifbCounter   = savedIfb

        return result
    }

    // ── Free variable analysis (for closure capture detection) ───────────────

    private fun freeVars(body: ForExprBody, bound: Set<String>): Set<String> = when (body) {
        is ExprBody  -> freeVarsExpr(body.expr, bound)
        is BlockBody -> freeVarsBlock(body.block, bound)
    }

    private fun freeVarsBlock(block: Block, bound: Set<String>): Set<String> {
        val result = mutableSetOf<String>()
        var scope = bound
        for (stmt in block.stmts) {
            result += freeVarsStmt(stmt, scope)
            if (stmt is AssignStmt && stmt.target is Ident) scope = scope + stmt.target.name
            if (stmt is FnDecl) scope = scope + stmt.name
        }
        return result
    }

    private fun freeVarsStmt(stmt: Stmt, bound: Set<String>): Set<String> = when (stmt) {
        is ExprStmt        -> freeVarsExpr(stmt.expr, bound)
        is AssignStmt      -> freeVarsExpr(stmt.value, bound)
        is ReturnStmt      -> stmt.value?.let { freeVarsExpr(it, bound) } ?: emptySet()
        is ForStmt         -> freeVarsExpr(stmt.iterable, bound) + freeVarsBlock(stmt.body, bound)
        is WhileStmt       -> freeVarsExpr(stmt.condition, bound) + freeVarsBlock(stmt.body, bound)
        is SpawnStmt       -> freeVarsExpr(stmt.expr, bound)
        is SpawnBlockStmt  -> freeVarsBlock(stmt.body, bound)
        else               -> emptySet()
    }

    private fun mapTypeExpr(te: TypeExpr): IrType = when (te) {
        is NamedType -> when (te.name.lowercase()) {
            "int"    -> IrType.I64
            "float"  -> IrType.F64
            "string" -> IrType.Str
            "bool"   -> IrType.Bool
            "byte"   -> IrType.Byte
            "list"   -> IrType.List(IrType.Any)
            "dict"   -> IrType.Dict(IrType.Any, IrType.Any)
            else     -> IrType.Struct(te.name)
        }
        else -> IrType.Any
    }

    private fun freeVarsExpr(expr: Expr, bound: Set<String>): Set<String> = when (expr) {
        is Ident      -> if (expr.name in bound) emptySet() else setOf(expr.name)
        is BinaryOp   -> freeVarsExpr(expr.left, bound) + freeVarsExpr(expr.right, bound)
        is UnaryOp    -> freeVarsExpr(expr.operand, bound)
        is Call       -> freeVarsExpr(expr.callee, bound) + expr.args.flatMap { freeVarsExpr(it.value, bound) }.toSet()
        is Lambda -> {
            val newBound = bound + expr.params.map { it.name }
            when (val b = expr.body) {
                is ExprBody  -> freeVarsExpr(b.expr, newBound)
                is BlockBody -> freeVarsBlock(b.block, newBound)
            }
        }
        is IfExpr     -> freeVarsExpr(expr.condition, bound) + freeVarsExpr(expr.thenExpr, bound) +
                        (expr.elseExpr?.let { freeVarsExpr(it, bound) } ?: emptySet())
        is MemberAccess -> freeVarsExpr(expr.target, bound)
        is ListLit    -> expr.elements.flatMap { freeVarsExpr(it, bound) }.toSet()
        is TupleLit   -> expr.elements.flatMap { freeVarsExpr(it, bound) }.toSet()
        is RecordLit  -> expr.fields.flatMap { freeVarsExpr(it.value, bound) }.toSet()
        is StructLit  -> expr.fields.flatMap { freeVarsExpr(it.value, bound) }.toSet()
        is ElseOp     -> freeVarsExpr(expr.expr, bound) + freeVarsExpr(expr.default, bound)
        is DictLit    -> expr.entries.flatMap { (k, v) -> freeVarsExpr(k, bound) + freeVarsExpr(v, bound) }.toSet()
        is SpawnExpr  -> freeVarsExpr(expr.expr, bound)
        is ReceiveExpr -> freeVarsExpr(expr.channel, bound)
        is TryExpr    -> freeVarsExpr(expr.expr, bound)
        is TryCatchExpr -> freeVarsExpr(expr.expr, bound) +
                           freeVarsBlock(expr.handler, bound + expr.errorVar)
        is Index      -> freeVarsExpr(expr.target, bound) + freeVarsExpr(expr.index, bound)
        is Slice      -> freeVarsExpr(expr.target, bound) +
                         (expr.start?.let { freeVarsExpr(it, bound) } ?: emptySet()) +
                         (expr.end?.let { freeVarsExpr(it, bound) } ?: emptySet())
        else          -> emptySet()
    }
}
