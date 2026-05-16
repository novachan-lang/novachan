package nova.ir

// ── LLVM IR Code Generation (Step 2.4) ───────────────────────────────────────
//
// Translates a NOVA IrModule (after erasure + optimization) into LLVM IR text.
// The .ll output can be compiled with: clang output.ll -o program
//
// V1 representation: uniform i64
//   All NOVA values are passed and stored as i64 in LLVM IR. This avoids type
//   mismatches at function boundaries (where IrType.Any is common). Type-specific
//   LLVM instructions are selected based on the IrType annotation on each IrInst:
//     - Integer ops: add, sub, mul, sdiv, srem, icmp
//     - Float ops: bitcast i64↔double, fadd, fsub, fmul, fdiv, fcmp
//     - Bool ops: icmp + zext, trunc for branches
//     - Strings: ptrtoint/inttoptr, global constants, puts/printf
//
// Entry point: nova_main() is wrapped by a C-compatible main() that returns i32.
//
// Builtins: print() is recognized and lowered to puts (strings) or printf (ints).
// All other unknown CallDirect targets are emitted as external function calls.

class LlvmCodegen {

    // ── String constant table ────────────────────────────────────────────────

    private val stringValues = mutableListOf<String>()
    private val stringIndex  = mutableMapOf<String, Int>()

    private fun internString(s: String): Int =
        stringIndex.getOrPut(s) { stringValues.size.also { stringValues.add(s) } }

    // ── Per-function codegen state ───────────────────────────────────────────

    private var tmpCounter  = 0
    private val inlineVals  = mutableMapOf<IrRef, String>()
    private val refTypes    = mutableMapOf<IrRef, IrType>()
    private val boolI1Alias = mutableMapOf<IrRef, String>()
    private val doubleAlias = mutableMapOf<IrRef, String>()
    private var branchOnlyRefs = emptySet<IrRef>()
    private var loopHeaders = emptySet<BlockId>()
    private val closureFns  = mutableMapOf<IrRef, String>()
    private val closureCaptures = mutableMapOf<IrRef, List<IrRef>>()
    private var blockLabels = mutableMapOf<BlockId, String>()
    private var moduleFnNames = emptySet<String>()
    private val moduleFnParamCounts = mutableMapOf<String, Int>()
    private val slotTypes   = mutableMapOf<String, IrType>()
    private val fnReturnTypes = mutableMapOf<String, IrType>()
    private val structDefs  = mutableMapOf<String, List<String>>()
    private val globalSlotNames = mutableSetOf<String>()
    private val globalSlotTypes = mutableMapOf<String, IrType>()
    private val spawnArities = mutableSetOf<Int>()
    private var stackAllocRefs = emptySet<IrRef>()
    private var nonEscapingLists = emptySet<IrRef>()
    private var nonEscapingListSlots = mutableSetOf<String>()
    private var rcSlots = mutableSetOf<String>()
    private var aliasRefs = mutableSetOf<IrRef>()
    private var fusedConcatOps = mutableMapOf<IrRef, Pair<IrRef, IrRef>>()

    // ── Module-level trampoline registry ─────────────────────────────────────
    // Trampolines are generated once per closure (capturing or non-capturing) and
    // emitted after all module functions. They bridge dynamic dispatch (which passes
    // env as the first arg) to the underlying function (explicit + cap args).

    private data class TrampolineSpec(val fnName: String, val totalParamCount: Int, val captureCount: Int)
    private val trampolines = mutableListOf<TrampolineSpec>()

    private fun freshTmp(): String = "%t${tmpCounter++}"

    private fun ref(r: IrRef): String =
        if (r.id < 0) "%p${-r.id - 1}" else "%r${r.id}"

    private fun v(r: IrRef): String = inlineVals[r] ?: ref(r)

    private fun labelOf(id: BlockId): String = blockLabels[id] ?: "bb_${id.id}"

    // ── Public API ───────────────────────────────────────────────────────────

    fun generate(module: IrModule): String {
        stringValues.clear(); stringIndex.clear(); fnReturnTypes.clear()
        trampolines.clear(); moduleFnParamCounts.clear(); structDefs.clear()
        globalSlotNames.clear(); globalSlotTypes.clear()
        moduleFnNames = module.functions.map { it.name }.toSet()
        for (fn in module.functions) moduleFnParamCounts[fn.name] = fn.params.size
        for ((name, fields) in module.structs) structDefs[name] = fields.map { it.first }
        collectStrings(module)
        collectFnReturnTypes(module)
        internString("%lld\n")   // .fmt.int
        internString("%f\n")    // .fmt.float
        internString("%s\n")    // .fmt.str
        internString("true")
        internString("false")

        collectGlobalSlots(module)

        val escapeResults = IrEscapeAnalysis().analyze(module)

        return buildString {
            emitHeader()
            appendLine()
            emitExternDecls()
            appendLine()
            emitStringGlobals()
            emitGlobalSlotDecls()
            appendLine()
            for (fn in module.functions) {
                stackAllocRefs = escapeResults[fn.name]?.stackAllocatable ?: emptySet()
                nonEscapingLists = escapeResults[fn.name]?.nonEscapingLists ?: emptySet()
                emitFunction(fn)
            }
            emitTrampolines()
            emitSpawnTrampolines()
            emitMainWrapper(module)
            appendLine()
            emitTbaaMetadata()
        }
    }

    // ── Pre-pass: collect string constants ───────────────────────────────────

    private fun collectStrings(module: IrModule) {
        for (fn in module.functions)
            for (block in fn.blocks)
                for (inst in block.instructions)
                    if (inst is IrInst.Const && inst.value is IrConst.Str)
                        internString((inst.value as IrConst.Str).v)
    }

    private fun collectFnReturnTypes(module: IrModule) {
        for (fn in module.functions) {
            if (fn.returnType != IrType.Any && fn.returnType != IrType.Unit) {
                fnReturnTypes[fn.name] = fn.returnType
                continue
            }
            for (block in fn.blocks) {
                val term = block.terminator
                if (term is IrTerminator.Return) {
                    val retInst = block.instructions.lastOrNull { it.result == term.value }
                    if (retInst != null && retInst.type != IrType.Any && retInst.type != IrType.Unit) {
                        fnReturnTypes[fn.name] = retInst.type
                        break
                    }
                }
            }
        }
    }

    // ── Global slots: module-level variables accessible from all functions ──

    private fun collectGlobalSlots(module: IrModule) {
        globalSlotNames.clear()
        globalSlotTypes.clear()
        for (fn in module.functions)
            for (block in fn.blocks)
                for (inst in block.instructions) {
                    if (inst is IrInst.SlotAlloc && inst.slot.isGlobal)
                        globalSlotNames.add(inst.slot.name)
                    // Pre-collect types for global slots from their first store
                    if (inst is IrInst.SlotStore && inst.slot.isGlobal && inst.slot.name !in globalSlotTypes) {
                        val valueInst = block.instructions.lastOrNull { it.result == inst.value }
                        if (valueInst != null && valueInst.type != IrType.Any && valueInst.type != IrType.Unit)
                            globalSlotTypes[inst.slot.name] = valueInst.type
                    }
                }
    }

    private fun StringBuilder.emitGlobalSlotDecls() {
        for (name in globalSlotNames)
            appendLine("@__nova_g_${escapeName(name)} = global i64 0")
    }

    // ── Module-level emission ────────────────────────────────────────────────

    private fun StringBuilder.emitHeader() {
        appendLine("; Generated by NOVA compiler")
        appendLine("target datalayout = \"e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128\"")
        appendLine("target triple = \"x86_64-pc-windows-msvc\"")
    }

    private fun StringBuilder.emitExternDecls() {
        appendLine("declare i32 @printf(ptr, ...)")
        appendLine("declare i32 @puts(ptr)")
        appendLine("declare noalias ptr @malloc(i64) nounwind allocsize(0)")
        appendLine("declare noalias ptr @calloc(i64, i64) nounwind")
        appendLine("declare ptr @realloc(ptr, i64) nounwind allocsize(1)")
        appendLine("declare void @free(ptr) nounwind")
        appendLine("declare i64 @llvm.smax.i64(i64, i64) nounwind readnone")
        appendLine("; nova runtime — list ops")
        appendLine("declare i64 @nova_rt_list_create() nounwind")
        appendLine("declare i64 @nova_rt_list_create_filled(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_list_append(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_list_get(i64, i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_list_set(i64, i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_list_len(i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_list_print(i64) nounwind")
        appendLine("declare i64 @nova_rt_iter_has_next(i64, i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_iter_get(i64, i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_list_iter_has_next(i64, i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_list_iter_get(i64, i64) nounwind readonly")
        appendLine("; nova runtime — string ops")
        appendLine("declare i64 @nova_rt_str_concat(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_int_to_str(i64) nounwind")
        appendLine("declare i64 @nova_rt_float_to_str(i64) nounwind")
        appendLine("declare i64 @nova_rt_bool_to_str(i64) nounwind")
        appendLine("declare i64 @nova_rt_str_len(i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_len(i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_contains(i64, i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_slice(i64, i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_upper(i64) nounwind")
        appendLine("declare i64 @nova_rt_lower(i64) nounwind")
        appendLine("declare i64 @nova_rt_trim(i64) nounwind")
        appendLine("declare i64 @nova_rt_split(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_replace(i64, i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_starts_with(i64, i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_ends_with(i64, i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_find(i64, i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_join(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_chars(i64) nounwind")
        appendLine("; nova runtime — list stdlib")
        appendLine("declare i64 @nova_rt_list_reverse(i64) nounwind")
        appendLine("declare i64 @nova_rt_list_sort(i64) nounwind")
        appendLine("declare i64 @nova_rt_list_map(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_list_filter(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_list_concat(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_list_slice(i64, i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_list_to_str(i64) nounwind")
        appendLine("declare i64 @nova_rt_len_any(i64) nounwind readonly")
        appendLine("; nova runtime — type conversions")
        appendLine("declare i64 @nova_rt_parse_int(i64) nounwind")
        appendLine("declare i64 @nova_rt_parse_float(i64) nounwind")
        appendLine("; nova runtime — character ops")
        appendLine("declare i64 @nova_rt_ord(i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_chr(i64) nounwind")
        appendLine("; nova runtime — process control")
        appendLine("declare void @nova_rt_exit(i64) noreturn nounwind")
        appendLine("declare i32 @strcmp(ptr, ptr) nounwind readonly")
        appendLine("; nova runtime — dict ops (hash map, O(1) avg lookup)")
        appendLine("declare i64 @nova_rt_dict_create() nounwind")
        appendLine("declare i64 @nova_rt_dict_set(i64, i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_dict_get(i64, i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_dict_get_concat2(i64, i64, i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_dict_set_concat2(i64, i64, i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_dict_has(i64, i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_dict_del(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_dict_len(i64) nounwind readonly")
        appendLine("declare i64 @nova_rt_dict_keys(i64) nounwind")
        appendLine("declare i64 @nova_rt_dict_values(i64) nounwind")
        appendLine("declare i64 @nova_rt_dict_items(i64) nounwind")
        appendLine("; nova runtime — IO ops")
        appendLine("declare i64 @nova_rt_read_line() nounwind")
        appendLine("declare i64 @nova_rt_read_file(i64) nounwind")
        appendLine("declare i64 @nova_rt_write_file(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_append_file(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_file_exists(i64) nounwind readonly")
        appendLine("; nova runtime — JSON ops")
        appendLine("declare i64 @nova_rt_json_parse(i64) nounwind")
        appendLine("declare i64 @nova_rt_json_stringify(i64) nounwind")
        appendLine("; nova runtime — HTTP ops")
        appendLine("declare i64 @nova_rt_http_get(i64) nounwind")
        appendLine("declare i64 @nova_rt_http_post(i64, i64, i64) nounwind")
        appendLine("; nova runtime — type dispatch")
        appendLine("declare i64 @nova_rt_any_to_str(i64) nounwind")
        appendLine("declare i64 @nova_rt_str_concat_safe(i64, i64) nounwind")
        appendLine("declare void @nova_rt_init() nounwind")
        appendLine("; nova runtime — channel/spawn ops")
        appendLine("declare i64 @nova_rt_channel_create() nounwind")
        appendLine("declare i64 @nova_rt_channel_send(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_channel_recv(i64) nounwind")
        appendLine("declare i64 @nova_rt_channel_close(i64) nounwind")
        appendLine("declare i64 @nova_rt_channel_select(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_channel_recv_timeout(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_spawn(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_monitor(i64) nounwind")
        appendLine("declare void @nova_rt_wait_all() nounwind")
        appendLine("; nova runtime — math (trig/log via C runtime for non-intrinsic functions)")
        appendLine("declare i64 @nova_rt_tan(i64) nounwind")
        appendLine("declare i64 @nova_rt_asin(i64) nounwind")
        appendLine("declare i64 @nova_rt_acos(i64) nounwind")
        appendLine("declare i64 @nova_rt_atan(i64) nounwind")
        appendLine("declare i64 @nova_rt_atan2(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_fmod(i64, i64) nounwind")
        appendLine("declare i64 @nova_rt_int_pow(i64, i64) nounwind")
        appendLine("; nova runtime — memory management")
        appendLine("declare void @nova_rt_cleanup() nounwind")
        appendLine("declare void @nova_rt_track_raw(ptr) nounwind")
        appendLine("declare i64 @nova_rt_alloc_count() nounwind readonly")
        appendLine("declare i64 @nova_rt_live_count() nounwind readonly")
        appendLine("; nova runtime — reference counting")
        appendLine("declare void @nova_rc_inc(i64) nounwind")
        appendLine("declare void @nova_rc_dec(i64) nounwind")
        appendLine("; nova error state — thread-local flag (safe for spawn/concurrent programs)")
        appendLine("@__nova_error_flag = thread_local global i64 0")
        appendLine("@__nova_error_msg = thread_local global i64 0")
    }

    private fun StringBuilder.emitStringGlobals() {
        for ((i, s) in stringValues.withIndex()) {
            val bytes = s.toByteArray(Charsets.UTF_8)
            val escaped = escapeLlvm(bytes)
            val len = bytes.size + 1
            appendLine("@.str.$i = private unnamed_addr constant [$len x i8] c\"$escaped\\00\"")
        }
    }

    // ── Function emission ────────────────────────────────────────────────────

    private fun collectNonBranchUses(fn: IrFunction): Set<IrRef> {
        val used = mutableSetOf<IrRef>()
        for (block in fn.blocks) {
            for (inst in block.instructions) {
                when (inst) {
                    is IrInst.SlotStore -> used.add(inst.value)
                    is IrInst.Binary -> { used.add(inst.left); used.add(inst.right) }
                    is IrInst.Unary -> used.add(inst.operand)
                    is IrInst.Call -> { used.add(inst.callee); inst.args.forEach { used.add(it) } }
                    is IrInst.CallDirect -> inst.args.forEach { used.add(it) }
                    is IrInst.MakeClosure -> inst.captureRefs.forEach { used.add(it) }
                    is IrInst.MakeList -> inst.elems.forEach { used.add(it) }
                    is IrInst.ListAppend -> { used.add(inst.list); used.add(inst.elem) }
                    is IrInst.MakeTuple -> inst.elems.forEach { used.add(it) }
                    is IrInst.MakeRecord -> inst.fields.forEach { used.add(it.second) }
                    is IrInst.MakeDict -> inst.entries.forEach { used.add(it.first); used.add(it.second) }
                    is IrInst.FieldGet -> used.add(inst.obj)
                    is IrInst.FieldSet -> { used.add(inst.obj); used.add(inst.value) }
                    is IrInst.IndexGet -> { used.add(inst.target); used.add(inst.index) }
                    is IrInst.IndexSet -> { used.add(inst.target); used.add(inst.index); used.add(inst.value) }
                    is IrInst.StringConcat -> inst.parts.forEach { used.add(it) }
                    is IrInst.ToString -> used.add(inst.value)
                    is IrInst.Copy -> used.add(inst.source)
                    is IrInst.IsError -> used.add(inst.value)
                    is IrInst.UnwrapError -> used.add(inst.value)
                    is IrInst.LoadErrorMsg -> {}
                    is IrInst.RaiseError -> {}
                    is IrInst.ChannelSend -> { used.add(inst.channel); used.add(inst.value) }
                    is IrInst.ChannelReceive -> used.add(inst.channel)
                    is IrInst.Spawn -> inst.args.forEach { used.add(it) }
                    is IrInst.ChannelSelect -> inst.channels.forEach { used.add(it) }
                    is IrInst.ChannelClose -> used.add(inst.channel)
                    is IrInst.ChannelRecvTimeout -> { used.add(inst.channel); used.add(inst.timeoutMs) }
                    is IrInst.Const, is IrInst.SlotAlloc, is IrInst.SlotLoad, is IrInst.ChannelCreate -> {}
                }
            }
            val term = block.terminator
            if (term is IrTerminator.Return) used.add(term.value)
        }
        return used
    }

    private fun StringBuilder.emitFunction(fn: IrFunction) {
        // Reset per-function state
        tmpCounter = 0
        inlineVals.clear(); refTypes.clear(); closureFns.clear(); slotTypes.clear()
        closureCaptures.clear(); boolI1Alias.clear(); doubleAlias.clear()
        blockLabels = fn.blocks.associate { it.id to it.label }.toMutableMap()

        // Identify comparison results that are ONLY used by branch terminators.
        val nonBranchUses = collectNonBranchUses(fn)
        val branchOnlyComparisons = mutableSetOf<IrRef>()
        for (block in fn.blocks)
            for (inst in block.instructions)
                if (inst is IrInst.Binary && inst.op in setOf(BinOp.EQ, BinOp.NE, BinOp.LT, BinOp.GT, BinOp.LE, BinOp.GE, BinOp.AND, BinOp.OR)
                    || inst is IrInst.Unary && inst.op == UnOp.NOT
                    || inst is IrInst.IsError)
                    if (inst.result !in nonBranchUses) branchOnlyComparisons.add(inst.result)
        branchOnlyRefs = branchOnlyComparisons

        // Register param types
        for ((i, p) in fn.params.withIndex())
            refTypes[IrRef(-(i + 1))] = p.second

        val params = fn.params.indices.joinToString(", ") { "i64 %p$it" }
        appendLine("define i64 @${escapeName(fn.name)}($params) nounwind {")

        // Hoist all SlotAlloc to the entry block to prevent stack growth in loops.
        val hoistedSlots = mutableSetOf<String>()
        for (block in fn.blocks)
            for (inst in block.instructions)
                if (inst is IrInst.SlotAlloc && !inst.slot.isGlobal)
                    hoistedSlots.add(inst.slot.name)

        // Identify slots that hold non-escaping lists (explicit free, no RC)
        nonEscapingListSlots = mutableSetOf()
        for (block in fn.blocks)
            for (inst in block.instructions)
                if (inst is IrInst.SlotStore && !inst.slot.isGlobal && inst.value in nonEscapingLists)
                    nonEscapingListSlots.add(inst.slot.name)

        // Identify slots that may hold heap objects and need RC cleanup at return.
        rcSlots = mutableSetOf()
        for (block in fn.blocks)
            for (inst in block.instructions)
                if (inst is IrInst.SlotStore && !inst.slot.isGlobal) {
                    if (inst.slot.name in nonEscapingListSlots) continue
                    val storedType = inst.type
                    if (isHeapType(storedType) || isHeapTypeFromInst(inst, fn))
                        rcSlots.add(inst.slot.name)
                }

        // Identify refs that are aliases — these need rc_inc when stored in a slot.
        // Aliases: values that already have an owner elsewhere (another slot, a container, or a caller).
        // SlotLoad: owned by the source slot. Params: owned by the caller's slot.
        // IndexGet/FieldGet: owned by the container (list/dict/record).
        aliasRefs = mutableSetOf()
        for (i in fn.params.indices)
            aliasRefs.add(IrRef(-(i + 1)))
        for (block in fn.blocks)
            for (inst in block.instructions)
                if (inst is IrInst.SlotLoad || inst is IrInst.IndexGet || inst is IrInst.FieldGet)
                    aliasRefs.add(inst.result)

        // Pre-populate slotTypes by finding the type of values stored into each slot.
        // This ensures hoisted loads (from LICM) get correct type info.
        // Use the most specific (non-scalar) type found, since zero-init stores
        // set I64 before the actual value type.
        slotTypes.clear()
        val instTypeMap = mutableMapOf<IrRef, IrType>()
        for (block in fn.blocks)
            for (inst in block.instructions) {
                if (inst.type != IrType.Unit && inst.type != IrType.Any)
                    instTypeMap[inst.result] = inst.type
            }
        for (block in fn.blocks)
            for (inst in block.instructions)
                if (inst is IrInst.SlotStore) {
                    val valType = instTypeMap[inst.value]
                    if (valType != null && valType != IrType.Any && valType != IrType.Unit) {
                        val existing = slotTypes[inst.slot.name]
                        if (existing == null || isKnownScalar(existing))
                            slotTypes[inst.slot.name] = valType
                    }
                }

        // Detect loop headers (blocks targeted by a back-edge) for branch weight hints
        val loopHdrs = mutableSetOf<BlockId>()
        for (block in fn.blocks) {
            val term = block.terminator
            val targets = when (term) {
                is IrTerminator.Goto -> listOf(term.target)
                is IrTerminator.Branch -> listOf(term.thenBlock, term.elseBlock)
                else -> emptyList()
            }
            for (t in targets) {
                if (t.id <= block.id.id) loopHdrs.add(t)
            }
        }
        loopHeaders = loopHdrs

        // Detect dict[concat(a,b)] patterns for zero-allocation fusion
        fusedConcatOps.clear()
        val fnDefs = mutableMapOf<IrRef, IrInst>()
        for (block in fn.blocks)
            for (inst in block.instructions)
                fnDefs[inst.result] = inst
        for (block in fn.blocks) {
            val blockDefs = mutableMapOf<IrRef, IrInst>()
            val blockUseCount = mutableMapOf<IrRef, Int>()
            for (inst in block.instructions) {
                blockDefs[inst.result] = inst
                for (ref in usedRefs(inst))
                    blockUseCount[ref] = (blockUseCount[ref] ?: 0) + 1
            }
            for (inst in block.instructions) {
                val indexRef: IrRef
                val targetRef: IrRef
                when (inst) {
                    is IrInst.IndexGet -> { indexRef = inst.index; targetRef = inst.target }
                    is IrInst.IndexSet -> { indexRef = inst.index; targetRef = inst.target }
                    else -> continue
                }
                val targetDef = fnDefs[targetRef]
                val targetType = instTypeMap[targetRef]
                    ?: slotTypes[(targetDef as? IrInst.SlotLoad)?.slot?.name]
                if (targetType !is IrType.Dict) continue
                val indexInst = blockDefs[indexRef] ?: continue
                if ((blockUseCount[indexRef] ?: 0) != 1) continue
                val concatParts: Pair<IrRef, IrRef>? = when {
                    indexInst is IrInst.Binary && indexInst.op == BinOp.ADD && indexInst.type == IrType.Str ->
                        Pair(indexInst.left, indexInst.right)
                    indexInst is IrInst.StringConcat && indexInst.parts.size == 2 ->
                        Pair(indexInst.parts[0], indexInst.parts[1])
                    else -> null
                }
                if (concatParts != null)
                    fusedConcatOps[indexRef] = concatParts
            }
        }

        for ((bi, block) in fn.blocks.withIndex()) {
            if (bi > 0) appendLine()
            appendLine("${block.label}:")
            if (bi == 0) {
                for (slotName in hoistedSlots)
                    appendLine("  %slot.$slotName = alloca i64, align 8")
                for (slotName in rcSlots)
                    appendLine("  store i64 0, ptr %slot.$slotName, align 8")
                for (slotName in nonEscapingListSlots)
                    appendLine("  store i64 0, ptr %slot.$slotName, align 8")
            }
            val tempCleanups = computeTempCleanups(block)
            var instIdx = 0
            for (inst in block.instructions) {
                if (inst is IrInst.SlotAlloc && !inst.slot.isGlobal) { instIdx++; continue }
                emitInst(inst, fn)
                tempCleanups[instIdx]?.forEach { ref ->
                    if (!isKnownScalar(refTypes[ref])) {
                        appendLine("  call void @nova_rc_dec(i64 ${v(ref)})")
                    }
                }
                instIdx++
            }
            emitTerminator(block.terminator, block)
        }

        appendLine("}")
        appendLine()

        // Record the function's actual return type for callers generated later
        if (fn.name !in fnReturnTypes || fnReturnTypes[fn.name] == IrType.Any) {
            for (block in fn.blocks) {
                val term = block.terminator
                if (term is IrTerminator.Return) {
                    val rt = refTypes[term.value]
                    if (rt != null && rt != IrType.Any && rt != IrType.Unit) {
                        fnReturnTypes[fn.name] = rt
                        break
                    }
                }
            }
        }
    }

    // ── Instruction dispatch ─────────────────────────────────────────────────

    private fun StringBuilder.emitInst(inst: IrInst, fn: IrFunction) {
        refTypes[inst.result] = inst.type
        when (inst) {
            is IrInst.Const       -> emitConst(inst)
            is IrInst.SlotAlloc   -> {
                // Non-global allocas are hoisted to entry block; globals are at module level.
            }
            is IrInst.SlotStore   -> {
                val ptr = if (inst.slot.isGlobal) "@__nova_g_${escapeName(inst.slot.name)}" else "%slot.${inst.slot.name}"
                val valueType = refTypes[inst.value]
                val slotType = slotTypes[inst.slot.name]
                val bothScalar = isKnownScalar(valueType) && (slotType == null || isKnownScalar(slotType))
                if (!inst.slot.isGlobal && inst.slot.name in rcSlots && !bothScalar) {
                    val oldTmp = freshTmp()
                    appendLine("  $oldTmp = load i64, ptr $ptr, align 8")
                    appendLine("  call void @nova_rc_dec(i64 $oldTmp)")
                    if (inst.value in aliasRefs) {
                        appendLine("  call void @nova_rc_inc(i64 ${v(inst.value)})")
                    }
                }
                appendLine("  store i64 ${v(inst.value)}, ptr $ptr, align 8")
                val storedType = refTypes[inst.value]
                if (storedType != null && storedType != IrType.Any && storedType != IrType.Unit) {
                    slotTypes[inst.slot.name] = storedType
                    if (inst.slot.isGlobal) globalSlotTypes[inst.slot.name] = storedType
                }
            }
            is IrInst.SlotLoad    -> {
                val ptr = if (inst.slot.isGlobal) "@__nova_g_${escapeName(inst.slot.name)}" else "%slot.${inst.slot.name}"
                appendLine("  ${ref(inst.result)} = load i64, ptr $ptr, align 8")
                val tracked = slotTypes[inst.slot.name]
                    ?: if (inst.slot.isGlobal) globalSlotTypes[inst.slot.name] else null
                if (tracked != null) {
                    refTypes[inst.result] = tracked
                    if (tracked == IrType.F64) {
                        val dbl = freshTmp()
                        appendLine("  $dbl = bitcast i64 ${ref(inst.result)} to double")
                        doubleAlias[inst.result] = dbl
                    }
                }
            }
            is IrInst.Binary      -> emitBinary(inst)
            is IrInst.Unary       -> emitUnary(inst)
            is IrInst.CallDirect  -> emitCallDirect(inst)
            is IrInst.Call        -> emitCall(inst)
            is IrInst.MakeClosure  -> emitMakeClosure(inst)
            is IrInst.MakeList     -> emitMakeList(inst)
            is IrInst.MakeDict     -> emitMakeDict(inst)
            is IrInst.ListAppend   -> emitListAppend(inst)
            is IrInst.MakeTuple    -> emitMakeTuple(inst)
            is IrInst.MakeRecord   -> emitMakeRecord(inst)
            is IrInst.FieldGet     -> emitFieldGet(inst)
            is IrInst.FieldSet     -> emitFieldSet(inst)
            is IrInst.IndexGet     -> emitIndexGet(inst)
            is IrInst.IndexSet     -> emitIndexSet(inst)
            is IrInst.StringConcat -> emitStringConcat(inst)
            is IrInst.ToString     -> emitToString(inst)
            is IrInst.Copy        -> { inlineVals[inst.result] = v(inst.source) }
            is IrInst.IsError      -> emitIsError(inst)
            is IrInst.UnwrapError  -> { inlineVals[inst.result] = v(inst.value) }
            is IrInst.LoadErrorMsg -> emitLoadErrorMsg(inst)
            is IrInst.RaiseError   -> emitRaiseError(inst)
            is IrInst.ChannelCreate  -> emitChannelCreate(inst)
            is IrInst.ChannelSend    -> emitChannelSend(inst)
            is IrInst.ChannelReceive -> emitChannelRecv(inst)
            is IrInst.Spawn              -> emitSpawn(inst)
            is IrInst.ChannelSelect      -> emitChannelSelect(inst)
            is IrInst.ChannelClose       -> emitChannelClose(inst)
            is IrInst.ChannelRecvTimeout -> emitChannelRecvTimeout(inst)
        }
    }

    private fun StringBuilder.emitChannelCreate(inst: IrInst.ChannelCreate) {
        appendLine("  ${ref(inst.result)} = call i64 @nova_rt_channel_create()")
        refTypes[inst.result] = IrType.Channel
    }

    private fun StringBuilder.emitChannelSend(inst: IrInst.ChannelSend) {
        val tmp = freshTmp()
        appendLine("  $tmp = call i64 @nova_rt_channel_send(i64 ${v(inst.channel)}, i64 ${v(inst.value)})")
        inlineVals[inst.result] = "0"
    }

    private fun StringBuilder.emitChannelRecv(inst: IrInst.ChannelReceive) {
        appendLine("  ${ref(inst.result)} = call i64 @nova_rt_channel_recv(i64 ${v(inst.channel)})")
    }

    private fun StringBuilder.emitSpawn(inst: IrInst.Spawn) {
        val arity = inst.args.size
        spawnArities.add(arity)

        val ctxSize = (1 + arity) * 8
        val ctx = freshTmp()
        appendLine("  $ctx = call ptr @malloc(i64 $ctxSize)")

        val fnPtr = freshTmp()
        appendLine("  $fnPtr = ptrtoint ptr @${escapeName(inst.funcName)} to i64")
        appendLine("  store i64 $fnPtr, ptr $ctx")

        for ((i, arg) in inst.args.withIndex()) {
            val gep = freshTmp()
            appendLine("  $gep = getelementptr i64, ptr $ctx, i32 ${i + 1}")
            appendLine("  store i64 ${v(arg)}, ptr $gep")
        }

        val trampName = "__nova_spawn_tramp_$arity"
        val trampPtr = freshTmp()
        appendLine("  $trampPtr = ptrtoint ptr @$trampName to i64")
        val ctxI64 = freshTmp()
        appendLine("  $ctxI64 = ptrtoint ptr $ctx to i64")
        appendLine("  ${ref(inst.result)} = call i64 @nova_rt_spawn(i64 $trampPtr, i64 $ctxI64)")
        refTypes[inst.result] = IrType.Process
    }

    private fun StringBuilder.emitChannelSelect(inst: IrInst.ChannelSelect) {
        val count = inst.channels.size
        val arr = freshTmp()
        appendLine("  $arr = alloca [$count x i64], align 8")
        for ((i, ch) in inst.channels.withIndex()) {
            val gep = freshTmp()
            appendLine("  $gep = getelementptr [$count x i64], ptr $arr, i64 0, i64 $i")
            appendLine("  store i64 ${v(ch)}, ptr $gep")
        }
        val arrPtr = freshTmp()
        appendLine("  $arrPtr = ptrtoint ptr $arr to i64")
        appendLine("  ${ref(inst.result)} = call i64 @nova_rt_channel_select(i64 $arrPtr, i64 $count)")
        refTypes[inst.result] = IrType.Tuple(listOf(IrType.I64, IrType.Any))
    }

    private fun StringBuilder.emitChannelClose(inst: IrInst.ChannelClose) {
        val tmp = freshTmp()
        appendLine("  $tmp = call i64 @nova_rt_channel_close(i64 ${v(inst.channel)})")
        inlineVals[inst.result] = "0"
    }

    private fun StringBuilder.emitChannelRecvTimeout(inst: IrInst.ChannelRecvTimeout) {
        appendLine("  ${ref(inst.result)} = call i64 @nova_rt_channel_recv_timeout(i64 ${v(inst.channel)}, i64 ${v(inst.timeoutMs)})")
    }

    // ── Error handling ───────────────────────────────────────────────────────
    // Thread-local error flag: error() sets it, IsError reads + clears it.
    // Thread-local ensures concurrent spawned processes don't share error state.

    private fun StringBuilder.emitIsError(inst: IrInst.IsError) {
        val flagLoad = freshTmp()
        val cmp = freshTmp()
        appendLine("  $flagLoad = load i64, ptr @__nova_error_flag")
        appendLine("  store i64 0, ptr @__nova_error_flag")
        appendLine("  $cmp = icmp ne i64 $flagLoad, 0")
        boolI1Alias[inst.result] = cmp
        if (inst.result !in branchOnlyRefs) {
            appendLine("  ${ref(inst.result)} = zext i1 $cmp to i64")
        }
    }

    // LoadErrorMsg: reads @__nova_error_msg (the message pointer) and clears it.
    // Called in catch-error paths AFTER IsError has already cleared the flag.
    private fun StringBuilder.emitLoadErrorMsg(inst: IrInst.LoadErrorMsg) {
        val msgLoad = freshTmp()
        appendLine("  $msgLoad = load i64, ptr @__nova_error_msg")
        appendLine("  store i64 0, ptr @__nova_error_msg")
        inlineVals[inst.result] = msgLoad
        refTypes[inst.result] = IrType.Str
    }

    // RaiseError: re-sets @__nova_error_flag = 1 without touching @__nova_error_msg.
    // Used in try-propagate paths: IsError cleared the flag, this re-raises it for
    // the caller to see. The message stays intact from the original error() call.
    private fun StringBuilder.emitRaiseError(inst: IrInst.RaiseError) {
        appendLine("  store i64 1, ptr @__nova_error_flag")
        inlineVals[inst.result] = "0"
    }

    // ── Constants ────────────────────────────────────────────────────────────

    private fun StringBuilder.emitConst(inst: IrInst.Const) {
        when (val c = inst.value) {
            is IrConst.Int   -> inlineVals[inst.result] = "${c.v}"
            is IrConst.Bool  -> inlineVals[inst.result] = if (c.v) "1" else "0"
            is IrConst.Unit  -> inlineVals[inst.result] = "0"
            is IrConst.Byte0 -> inlineVals[inst.result] = "0"
            is IrConst.Float -> {
                inlineVals[inst.result] = "${java.lang.Double.doubleToRawLongBits(c.v)}"
                refTypes[inst.result] = IrType.F64
            }
            is IrConst.Str -> {
                val idx = stringIndex[c.v]!!
                val bytes = c.v.toByteArray(Charsets.UTF_8)
                val len = bytes.size + 1
                val tmp = freshTmp()
                appendLine("  $tmp = getelementptr inbounds [$len x i8], ptr @.str.$idx, i64 0, i64 0")
                appendLine("  ${ref(inst.result)} = ptrtoint ptr $tmp to i64")
                refTypes[inst.result] = IrType.Str
            }
        }
    }

    // ── Binary operations ────────────────────────────────────────────────────

    private fun StringBuilder.emitBinary(inst: IrInst.Binary) {
        // Skip str_concat that will be fused into a dict_get/set_concat2 call
        if (inst.result in fusedConcatOps) {
            refTypes[inst.result] = IrType.Str
            return
        }

        val l = v(inst.left); val r = v(inst.right)
        val isFloat = refTypes[inst.left] == IrType.F64 || refTypes[inst.right] == IrType.F64

        when (inst.op) {
            BinOp.ADD, BinOp.SUB, BinOp.MUL, BinOp.DIV, BinOp.MOD -> {
                val leftStr = refTypes[inst.left] == IrType.Str
                val rightStr = refTypes[inst.right] == IrType.Str
                val isStr = leftStr || rightStr
                val leftAny = refTypes[inst.left] == null || refTypes[inst.left] == IrType.Any
                val rightAny = refTypes[inst.right] == null || refTypes[inst.right] == IrType.Any
                val strPlusAny = inst.op == BinOp.ADD && ((leftStr && rightAny) || (rightStr && leftAny))
                if (inst.op == BinOp.ADD && isStr && !leftAny && !rightAny) {
                    appendLine("  ${ref(inst.result)} = call i64 @nova_rt_str_concat(i64 $l, i64 $r)")
                    refTypes[inst.result] = IrType.Str
                } else if (strPlusAny) {
                    appendLine("  ${ref(inst.result)} = call i64 @nova_rt_str_concat_safe(i64 $l, i64 $r)")
                    refTypes[inst.result] = IrType.Str
                } else if (isFloat) emitFloatArith(inst, l, r)
                else {
                    val op = when (inst.op) {
                        BinOp.ADD -> "add"; BinOp.SUB -> "sub"
                        BinOp.MUL -> "mul"; BinOp.DIV -> "sdiv"; BinOp.MOD -> "srem"
                        else -> "add"
                    }
                    appendLine("  ${ref(inst.result)} = $op i64 $l, $r")
                }
            }
            BinOp.POW -> {
                if (isFloat) {
                    val fl = toDouble(l, inst.left); val fr = toDouble(r, inst.right)
                    val powResult = freshTmp()
                    appendLine("  $powResult = call double @llvm.pow.f64(double $fl, double $fr)")
                    appendLine("  ${ref(inst.result)} = bitcast double $powResult to i64")
                    refTypes[inst.result] = IrType.F64
                    doubleAlias[inst.result] = powResult
                } else {
                    appendLine("  ${ref(inst.result)} = call i64 @nova_rt_int_pow(i64 $l, i64 $r)")
                    refTypes[inst.result] = IrType.I64
                }
            }
            BinOp.CONCAT -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_str_concat(i64 ${v(inst.left)}, i64 ${v(inst.right)})")
                refTypes[inst.result] = IrType.Str
            }
            BinOp.EQ, BinOp.NE, BinOp.LT, BinOp.GT, BinOp.LE, BinOp.GE -> {
                val isStr = refTypes[inst.left] == IrType.Str || refTypes[inst.right] == IrType.Str
                if (isFloat) emitFloatCmp(inst, l, r)
                else if (isStr && (inst.op == BinOp.EQ || inst.op == BinOp.NE)) {
                    // String equality: use libc strcmp via ptr conversion
                    val pa = freshTmp(); val pb = freshTmp()
                    val cmp = freshTmp(); val cmpBool = freshTmp()
                    appendLine("  $pa = inttoptr i64 $l to ptr")
                    appendLine("  $pb = inttoptr i64 $r to ptr")
                    appendLine("  $cmp = call i32 @strcmp(ptr $pa, ptr $pb)")
                    if (inst.op == BinOp.EQ) {
                        appendLine("  $cmpBool = icmp eq i32 $cmp, 0")
                    } else {
                        appendLine("  $cmpBool = icmp ne i32 $cmp, 0")
                    }
                    boolI1Alias[inst.result] = cmpBool
                    if (inst.result !in branchOnlyRefs) {
                        appendLine("  ${ref(inst.result)} = zext i1 $cmpBool to i64")
                    }
                } else {
                    val pred = when (inst.op) {
                        BinOp.EQ -> "eq"; BinOp.NE -> "ne"
                        BinOp.LT -> "slt"; BinOp.GT -> "sgt"
                        BinOp.LE -> "sle"; BinOp.GE -> "sge"
                        else -> "eq"
                    }
                    val tmp = freshTmp()
                    appendLine("  $tmp = icmp $pred i64 $l, $r")
                    boolI1Alias[inst.result] = tmp
                    if (inst.result !in branchOnlyRefs) {
                        appendLine("  ${ref(inst.result)} = zext i1 $tmp to i64")
                    }
                }
            }
            BinOp.AND -> {
                val a = freshTmp(); val b = freshTmp(); val c = freshTmp()
                appendLine("  $a = icmp ne i64 $l, 0")
                appendLine("  $b = icmp ne i64 $r, 0")
                appendLine("  $c = and i1 $a, $b")
                boolI1Alias[inst.result] = c
                if (inst.result !in branchOnlyRefs) {
                    appendLine("  ${ref(inst.result)} = zext i1 $c to i64")
                }
            }
            BinOp.OR -> {
                val a = freshTmp(); val b = freshTmp(); val c = freshTmp()
                appendLine("  $a = icmp ne i64 $l, 0")
                appendLine("  $b = icmp ne i64 $r, 0")
                appendLine("  $c = or i1 $a, $b")
                boolI1Alias[inst.result] = c
                if (inst.result !in branchOnlyRefs) {
                    appendLine("  ${ref(inst.result)} = zext i1 $c to i64")
                }
            }
        }
    }

    private fun StringBuilder.toDouble(v: String, ref: IrRef): String {
        val alias = doubleAlias[ref]
        if (alias != null) return alias
        val tmp = freshTmp()
        val t = refTypes[ref]
        if (t == IrType.F64) {
            appendLine("  $tmp = bitcast i64 $v to double")
        } else {
            appendLine("  $tmp = sitofp i64 $v to double")
        }
        return tmp
    }

    private fun StringBuilder.emitFloatArith(inst: IrInst.Binary, l: String, r: String) {
        val fl = toDouble(l, inst.left); val fr = toDouble(r, inst.right)
        val fres = freshTmp()
        val op = when (inst.op) {
            BinOp.ADD -> "fadd"; BinOp.SUB -> "fsub"
            BinOp.MUL -> "fmul"; BinOp.DIV -> "fdiv"
            BinOp.MOD -> "frem"
            else -> "fadd"
        }
        appendLine("  $fres = $op double $fl, $fr")
        appendLine("  ${ref(inst.result)} = bitcast double $fres to i64")
        refTypes[inst.result] = IrType.F64
        doubleAlias[inst.result] = fres
    }

    private fun StringBuilder.emitFloatCmp(inst: IrInst.Binary, l: String, r: String) {
        val fl = toDouble(l, inst.left); val fr = toDouble(r, inst.right)
        val pred = when (inst.op) {
            BinOp.EQ -> "oeq"; BinOp.NE -> "one"
            BinOp.LT -> "olt"; BinOp.GT -> "ogt"
            BinOp.LE -> "ole"; BinOp.GE -> "oge"
            else -> "oeq"
        }
        val tmp = freshTmp()
        appendLine("  $tmp = fcmp $pred double $fl, $fr")
        boolI1Alias[inst.result] = tmp
        if (inst.result !in branchOnlyRefs) {
            appendLine("  ${ref(inst.result)} = zext i1 $tmp to i64")
        }
    }

    // ── Unary operations ─────────────────────────────────────────────────────

    private fun StringBuilder.emitUnary(inst: IrInst.Unary) {
        when (inst.op) {
            UnOp.NEG -> {
                if (refTypes[inst.operand] == IrType.F64) {
                    val f = toDouble(v(inst.operand), inst.operand)
                    val neg = freshTmp()
                    appendLine("  $neg = fneg double $f")
                    appendLine("  ${ref(inst.result)} = bitcast double $neg to i64")
                    refTypes[inst.result] = IrType.F64
                    doubleAlias[inst.result] = neg
                } else {
                    appendLine("  ${ref(inst.result)} = sub i64 0, ${v(inst.operand)}")
                }
            }
            UnOp.NOT -> {
                val tmp = freshTmp()
                appendLine("  $tmp = icmp eq i64 ${v(inst.operand)}, 0")
                boolI1Alias[inst.result] = tmp
                if (inst.result !in branchOnlyRefs) {
                    appendLine("  ${ref(inst.result)} = zext i1 $tmp to i64")
                }
            }
        }
    }

    // ── Function calls ───────────────────────────────────────────────────────

    private fun StringBuilder.emitCallDirect(inst: IrInst.CallDirect) {
        when (inst.funcName) {
            "print" -> { emitPrint(inst.args.firstOrNull(), inst.result); return }
            "len"   -> {
                val fn = when (refTypes[inst.args[0]]) {
                    is IrType.Dict -> "nova_rt_dict_len"
                    is IrType.List -> "nova_rt_list_len"
                    IrType.Str     -> "nova_rt_len"
                    else           -> "nova_rt_len_any"
                }
                appendLine("  ${ref(inst.result)} = call i64 @$fn(i64 ${v(inst.args[0])})")
                return
            }
            "error" -> {
                appendLine("  store i64 1, ptr @__nova_error_flag")
                if (inst.args.isNotEmpty()) {
                    appendLine("  store i64 ${v(inst.args[0])}, ptr @__nova_error_msg")
                }
                inlineVals[inst.result] = "0"
                return
            }
            // ── Math stdlib — inlined LLVM (no C call overhead) ─────────────────
            "abs" -> { emitAbs(inst); return }
            "max" -> { emitMax(inst); return }
            "min" -> { emitMin(inst); return }
            "sqrt"  -> { emitMathFloat1("llvm.sqrt.f64", inst); return }
            "floor" -> { emitMathFloat1("llvm.floor.f64", inst); return }
            "ceil"  -> { emitMathFloat1("llvm.ceil.f64", inst); return }
            "round" -> { emitMathFloat1("llvm.round.f64", inst); return }
            "fabs"  -> { emitMathFloat1("llvm.fabs.f64", inst); return }
            "sin"   -> { emitMathFloat1("llvm.sin.f64", inst); return }
            "cos"   -> { emitMathFloat1("llvm.cos.f64", inst); return }
            "exp"   -> { emitMathFloat1("llvm.exp.f64", inst); return }
            "log"   -> { emitMathFloat1("llvm.log.f64", inst); return }
            "log2"  -> { emitMathFloat1("llvm.log2.f64", inst); return }
            "log10" -> { emitMathFloat1("llvm.log10.f64", inst); return }
            "tan", "asin", "acos", "atan" -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_${inst.funcName}(i64 ${v(inst.args[0])})")
                refTypes[inst.result] = IrType.F64
                return
            }
            "atan2", "fmod" -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_${inst.funcName}(i64 ${v(inst.args[0])}, i64 ${v(inst.args[1])})")
                refTypes[inst.result] = IrType.F64
                return
            }
            // ── Dict method dispatch — generic `nova_rt_X` → typed `nova_rt_dict_X` ──
            // AstToIr emits member calls as nova_rt_${member}; we resolve to the
            // correct prefixed form here where refTypes gives us the receiver's type.
            "nova_rt_del"  -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_dict_del(i64 ${v(inst.args[0])}, i64 ${v(inst.args[1])})")
                return
            }
            "nova_rt_has"  -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_dict_has(i64 ${v(inst.args[0])}, i64 ${v(inst.args[1])})")
                refTypes[inst.result] = IrType.Bool
                return
            }
            "nova_rt_keys" -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_dict_keys(i64 ${v(inst.args[0])})")
                refTypes[inst.result] = IrType.List(IrType.Str)
                return
            }
            "nova_rt_values" -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_dict_values(i64 ${v(inst.args[0])})")
                refTypes[inst.result] = IrType.List(IrType.Any)
                return
            }
            "nova_rt_items" -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_dict_items(i64 ${v(inst.args[0])})")
                refTypes[inst.result] = IrType.List(IrType.Any)
                return
            }
            "nova_rt_len"  -> {
                val fn = when (refTypes[inst.args[0]]) {
                    is IrType.Dict -> "nova_rt_dict_len"
                    is IrType.List -> "nova_rt_list_len"
                    else           -> "nova_rt_len"   // string
                }
                appendLine("  ${ref(inst.result)} = call i64 @$fn(i64 ${v(inst.args[0])})")
                return
            }
            // ── List method dispatch — remap generic names to nova_rt_list_* ─────
            "nova_rt_append", "nova_rt_push" -> {
                val listRef = inst.args[0]
                val elemRef = inst.args[1]
                val lt = refTypes[listRef]
                if (lt is IrType.List) {
                    emitInlineListAppend(listRef, elemRef, inst.result)
                } else {
                    appendLine("  ${ref(inst.result)} = call i64 @nova_rt_list_append(i64 ${v(listRef)}, i64 ${v(elemRef)})")
                }
                return
            }
            "nova_rt_concat" -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_list_concat(i64 ${v(inst.args[0])}, i64 ${v(inst.args[1])})")
                refTypes[inst.result] = refTypes[inst.args[0]] ?: IrType.List(IrType.Any)
                return
            }
            "nova_rt_reverse" -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_list_reverse(i64 ${v(inst.args[0])})")
                refTypes[inst.result] = refTypes[inst.args[0]] ?: IrType.List(IrType.Any)
                return
            }
            "nova_rt_sort" -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_list_sort(i64 ${v(inst.args[0])})")
                refTypes[inst.result] = refTypes[inst.args[0]] ?: IrType.List(IrType.Any)
                return
            }
            "nova_rt_map" -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_list_map(i64 ${v(inst.args[0])}, i64 ${v(inst.args[1])})")
                refTypes[inst.result] = IrType.List(IrType.Any)
                return
            }
            "nova_rt_filter" -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_list_filter(i64 ${v(inst.args[0])}, i64 ${v(inst.args[1])})")
                refTypes[inst.result] = refTypes[inst.args[0]] ?: IrType.List(IrType.Any)
                return
            }
            "nova_rt_list_slice" -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_list_slice(i64 ${v(inst.args[0])}, i64 ${v(inst.args[1])}, i64 ${v(inst.args[2])})")
                refTypes[inst.result] = refTypes[inst.args[0]] ?: IrType.List(IrType.Any)
                return
            }
            // ── Character operations ─────────────────────────────────────────────
            "nova_rt_ord" -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_ord(i64 ${v(inst.args[0])})")
                refTypes[inst.result] = IrType.I64
                return
            }
            "nova_rt_chr" -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_chr(i64 ${v(inst.args[0])})")
                refTypes[inst.result] = IrType.Str
                return
            }
            // ── Process control ──────────────────────────────────────────────────
            "nova_rt_exit" -> {
                appendLine("  call void @nova_rt_exit(i64 ${v(inst.args[0])})")
                inlineVals[inst.result] = "0"
                return
            }
            // ── Type conversion builtins ─────────────────────────────────────────
            "int" -> { emitIntConv(inst); return }
            "float" -> { emitFloatConv(inst); return }
            "str" -> { emitStrConv(inst); return }
            "nova_rt_iter_has_next" -> {
                if (refTypes[inst.args[0]] is IrType.List) {
                    emitInlineIterHasNext(inst)
                    return
                }
            }
            "nova_rt_list_iter_has_next" -> {
                emitInlineIterHasNext(inst)
                return
            }
            "nova_rt_iter_get" -> {
                if (refTypes[inst.args[0]] is IrType.List) {
                    emitInlineIterGet(inst)
                    return
                }
            }
            "nova_rt_list_iter_get" -> {
                emitInlineIterGet(inst)
                return
            }
        }
        // Non-escaping list inline allocation — skip nova_mem_track + RC
        if (inst.result in nonEscapingLists &&
            inst.funcName in setOf("nova_rt_list_create_filled", "nova_rt_list_create")) {
            emitInlineListCreate(inst)
            return
        }
        val args = inst.args.joinToString(", ") { "i64 ${v(it)}" }
        appendLine("  ${ref(inst.result)} = call i64 @${escapeName(inst.funcName)}($args)")
        val retType = fnReturnTypes[inst.funcName] ?: runtimeReturnType(inst.funcName)
        if (retType != null) refTypes[inst.result] = retType
    }

    private fun runtimeReturnType(name: String): IrType? = when (name) {
        "nova_rt_slice", "nova_rt_upper", "nova_rt_lower",
        "nova_rt_trim", "nova_rt_replace", "nova_rt_str_concat",
        "nova_rt_int_to_str", "nova_rt_float_to_str", "nova_rt_bool_to_str",
        "nova_rt_read_line", "nova_rt_read_file", "nova_rt_json_stringify",
        "nova_rt_http_get", "nova_rt_http_post",
        "nova_rt_join" -> IrType.Str
        "nova_rt_starts_with", "nova_rt_ends_with" -> IrType.Bool
        "nova_rt_find" -> IrType.I64
        "nova_rt_chars" -> IrType.List(IrType.Str)
        "nova_rt_contains", "nova_rt_dict_has" -> IrType.Bool
        "nova_rt_iter_has_next" -> IrType.I64
        "nova_rt_str_len", "nova_rt_len", "nova_rt_list_len",
        "nova_rt_dict_len" -> IrType.I64
        "nova_rt_split" -> IrType.List(IrType.Str)
        "nova_rt_dict_keys" -> IrType.List(IrType.Str)
        "nova_rt_dict_values" -> IrType.List(IrType.Any)
        "nova_rt_dict_items" -> IrType.List(IrType.Any)
        "nova_rt_list_create" -> IrType.List(IrType.Any)
        "nova_rt_list_create_filled" -> IrType.List(IrType.Any)
        "nova_rt_list_to_str" -> IrType.Str
        "nova_rt_parse_float" -> IrType.F64
        "nova_rt_dict_create" -> IrType.Dict(IrType.Str, IrType.Any)
        "nova_rt_json_parse" -> IrType.Any
        "nova_rt_file_exists" -> IrType.Bool
        "nova_rt_append_file" -> IrType.Unit
        "nova_rt_monitor" -> IrType.Channel
        else -> null
    }

    private fun StringBuilder.emitCall(inst: IrInst.Call) {
        val origin = closureFns[inst.callee]
        if (origin != null) {
            // Static dispatch: we know the function name from MakeClosure tracking.
            when (origin) {
                "print" -> { emitPrint(inst.args.firstOrNull(), inst.result); return }
                "len"   -> {
                    val fn = when (refTypes[inst.args[0]]) {
                        is IrType.Dict -> "nova_rt_dict_len"
                        is IrType.List -> "nova_rt_list_len"
                        IrType.Str     -> "nova_rt_len"
                        else           -> "nova_rt_len_any"
                    }
                    appendLine("  ${ref(inst.result)} = call i64 @$fn(i64 ${v(inst.args[0])})")
                    return
                }
            }
            // For capturing closures, append the captured values as extra args.
            // closureCaptures is set only for capturing MakeClosure in this function.
            val captureArgs = closureCaptures[inst.callee] ?: emptyList()
            val allArgs = inst.args + captureArgs
            val args = allArgs.joinToString(", ") { "i64 ${v(it)}" }
            appendLine("  ${ref(inst.result)} = call i64 @${escapeName(origin)}($args)")
            val retType = fnReturnTypes[origin]
            if (retType != null) refTypes[inst.result] = retType
        } else {
            // Dynamic dispatch: closure value is a closure record {fn_ptr, cap0, ...}.
            // Load the trampoline pointer from slot [0], call it with (env=record, args...).
            // Note: non-capturing raw fn-ptr values don't go through this path in practice
            // because their MakeClosure is tracked in closureFns via static dispatch above.
            val envPtr = freshTmp()
            val fnI64  = freshTmp()
            val fptr   = freshTmp()
            appendLine("  $envPtr = inttoptr i64 ${v(inst.callee)} to ptr")
            appendLine("  $fnI64 = load i64, ptr $envPtr")
            appendLine("  $fptr = inttoptr i64 $fnI64 to ptr")
            val argsPart = inst.args.joinToString(", ") { "i64 ${v(it)}" }
            val callArgs = if (argsPart.isEmpty()) "i64 ${v(inst.callee)}" else "i64 ${v(inst.callee)}, $argsPart"
            appendLine("  ${ref(inst.result)} = call i64 $fptr($callArgs)")
        }
    }

    private fun StringBuilder.emitMakeClosure(inst: IrInst.MakeClosure) {
        closureFns[inst.result] = inst.funcName
        if (inst.funcName !in moduleFnNames) {
            inlineVals[inst.result] = "0"
            return
        }

        val captureCount = inst.captureRefs.size
        if (captureCount > 0) closureCaptures[inst.result] = inst.captureRefs

        val totalSize = (1 + captureCount) * 8L
        val trampName = "${escapeName(inst.funcName)}_tramp"

        if (trampolines.none { it.fnName == inst.funcName }) {
            val totalParams = moduleFnParamCounts[inst.funcName] ?: captureCount
            trampolines.add(TrampolineSpec(inst.funcName, totalParams, captureCount))
        }

        val mem    = freshTmp()
        val tramPt = freshTmp()
        appendLine("  $mem = call ptr @malloc(i64 $totalSize)")
        appendLine("  call void @nova_rt_track_raw(ptr $mem)")
        appendLine("  $tramPt = ptrtoint ptr @$trampName to i64")
        appendLine("  store i64 $tramPt, ptr $mem")
        for ((i, capRef) in inst.captureRefs.withIndex()) {
            val gep = freshTmp()
            appendLine("  $gep = getelementptr i64, ptr $mem, i64 ${i + 1}")
            appendLine("  store i64 ${v(capRef)}, ptr $gep")
        }
        appendLine("  ${ref(inst.result)} = ptrtoint ptr $mem to i64")
    }

    // ── Collection operations ────────────────────────────────────────────────

    private fun StringBuilder.emitMakeList(inst: IrInst.MakeList) {
        appendLine("  ${ref(inst.result)} = call i64 @nova_rt_list_create()")
        refTypes[inst.result] = inst.type
        for (elem in inst.elems) {
            val tmp = freshTmp()
            appendLine("  $tmp = call i64 @nova_rt_list_append(i64 ${ref(inst.result)}, i64 ${v(elem)})")
        }
    }

    private fun StringBuilder.emitMakeDict(inst: IrInst.MakeDict) {
        appendLine("  ${ref(inst.result)} = call i64 @nova_rt_dict_create()")
        refTypes[inst.result] = inst.type
        for ((keyRef, valRef) in inst.entries) {
            val tmp = freshTmp()
            appendLine("  $tmp = call i64 @nova_rt_dict_set(i64 ${ref(inst.result)}, i64 ${v(keyRef)}, i64 ${v(valRef)})")
        }
    }

    // ── Math builtins (inlined LLVM, no C call) ──────────────────────────────────

    private fun StringBuilder.emitAbs(inst: IrInst.CallDirect) {
        val arg = inst.args[0]
        if (refTypes[arg] == IrType.F64) {
            val f = toDouble(v(arg), arg); val res = freshTmp()
            appendLine("  $res = call double @llvm.fabs.f64(double $f)")
            appendLine("  ${ref(inst.result)} = bitcast double $res to i64")
            refTypes[inst.result] = IrType.F64
            doubleAlias[inst.result] = res
        } else {
            val isNeg = freshTmp(); val neg = freshTmp()
            appendLine("  $isNeg = icmp slt i64 ${v(arg)}, 0")
            appendLine("  $neg = sub i64 0, ${v(arg)}")
            appendLine("  ${ref(inst.result)} = select i1 $isNeg, i64 $neg, i64 ${v(arg)}")
        }
    }

    private fun StringBuilder.emitMax(inst: IrInst.CallDirect) {
        val a = inst.args[0]; val b = inst.args[1]
        if (refTypes[a] == IrType.F64 || refTypes[b] == IrType.F64) {
            val fa = toDouble(v(a), a); val fb = toDouble(v(b), b)
            val cmp = freshTmp(); val fres = freshTmp()
            appendLine("  $cmp = fcmp ogt double $fa, $fb")
            appendLine("  $fres = select i1 $cmp, double $fa, double $fb")
            appendLine("  ${ref(inst.result)} = bitcast double $fres to i64")
            refTypes[inst.result] = IrType.F64
            doubleAlias[inst.result] = fres
        } else {
            val cmp = freshTmp()
            appendLine("  $cmp = icmp sgt i64 ${v(a)}, ${v(b)}")
            appendLine("  ${ref(inst.result)} = select i1 $cmp, i64 ${v(a)}, i64 ${v(b)}")
        }
    }

    private fun StringBuilder.emitMin(inst: IrInst.CallDirect) {
        val a = inst.args[0]; val b = inst.args[1]
        if (refTypes[a] == IrType.F64 || refTypes[b] == IrType.F64) {
            val fa = toDouble(v(a), a); val fb = toDouble(v(b), b)
            val cmp = freshTmp(); val fres = freshTmp()
            appendLine("  $cmp = fcmp olt double $fa, $fb")
            appendLine("  $fres = select i1 $cmp, double $fa, double $fb")
            appendLine("  ${ref(inst.result)} = bitcast double $fres to i64")
            refTypes[inst.result] = IrType.F64
            doubleAlias[inst.result] = fres
        } else {
            val cmp = freshTmp()
            appendLine("  $cmp = icmp slt i64 ${v(a)}, ${v(b)}")
            appendLine("  ${ref(inst.result)} = select i1 $cmp, i64 ${v(a)}, i64 ${v(b)}")
        }
    }

    // sqrt/floor/ceil: always produce a float result; coerce int arg if needed
    private fun StringBuilder.emitMathFloat1(intrinsic: String, inst: IrInst.CallDirect) {
        val arg = inst.args[0]
        val f = toDouble(v(arg), arg)
        val res = freshTmp()
        appendLine("  $res = call double @$intrinsic(double $f)")
        appendLine("  ${ref(inst.result)} = bitcast double $res to i64")
        refTypes[inst.result] = IrType.F64
        doubleAlias[inst.result] = res
    }

    // ── Type conversion builtins ────────────────────────────────────────────

    private fun StringBuilder.emitIntConv(inst: IrInst.CallDirect) {
        val arg = inst.args[0]
        when (refTypes[arg]) {
            IrType.F64 -> {
                val f = freshTmp()
                appendLine("  $f = bitcast i64 ${v(arg)} to double")
                appendLine("  ${ref(inst.result)} = fptosi double $f to i64")
            }
            IrType.Str, IrType.Any, null -> {
                // Any/null: value is dynamically typed (e.g. dict lookup) — parse as string
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_parse_int(i64 ${v(arg)})")
            }
            else -> {
                inlineVals[inst.result] = v(arg)
            }
        }
        refTypes[inst.result] = IrType.I64
    }

    private fun StringBuilder.emitFloatConv(inst: IrInst.CallDirect) {
        val arg = inst.args[0]
        when (refTypes[arg]) {
            IrType.I64 -> {
                val f = freshTmp()
                appendLine("  $f = sitofp i64 ${v(arg)} to double")
                appendLine("  ${ref(inst.result)} = bitcast double $f to i64")
                doubleAlias[inst.result] = f
            }
            IrType.Str -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_parse_float(i64 ${v(arg)})")
            }
            else -> {
                inlineVals[inst.result] = v(arg)
            }
        }
        refTypes[inst.result] = IrType.F64
    }

    private fun StringBuilder.emitStrConv(inst: IrInst.CallDirect) {
        val arg = inst.args[0]
        when (refTypes[arg]) {
            IrType.I64 -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_int_to_str(i64 ${v(arg)})")
            }
            IrType.F64 -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_float_to_str(i64 ${v(arg)})")
            }
            IrType.Bool -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_bool_to_str(i64 ${v(arg)})")
            }
            IrType.Str -> {
                inlineVals[inst.result] = v(arg)
            }
            is IrType.List -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_list_to_str(i64 ${v(arg)})")
            }
            else -> {
                appendLine("  ${ref(inst.result)} = call i64 @nova_rt_any_to_str(i64 ${v(arg)})")
            }
        }
        refTypes[inst.result] = IrType.Str
    }

    private fun StringBuilder.emitInlineListCreate(inst: IrInst.CallDirect) {
        val header = freshTmp()
        appendLine("  $header = call ptr @malloc(i64 24)")
        if (inst.funcName == "nova_rt_list_create_filled" && inst.args.size == 2) {
            val count = v(inst.args[0])
            val value = v(inst.args[1])
            val capTmp = freshTmp()
            appendLine("  $capTmp = call i64 @llvm.smax.i64(i64 $count, i64 8)")
            val data = freshTmp()
            appendLine("  $data = call ptr @calloc(i64 $capTmp, i64 8)")
            appendLine("  store ptr $data, ptr $header, align 8")
            val sizePtr = freshTmp()
            appendLine("  $sizePtr = getelementptr i64, ptr $header, i64 1")
            appendLine("  store i64 $count, ptr $sizePtr, align 8")
            val capPtr = freshTmp()
            appendLine("  $capPtr = getelementptr i64, ptr $header, i64 2")
            appendLine("  store i64 $capTmp, ptr $capPtr, align 8")
            // Fill with non-zero value if needed
            val isZero = freshTmp()
            appendLine("  $isZero = icmp eq i64 $value, 0")
            val fillLabel = "list_fill_${tmpCounter}"
            val doneLabel = "list_done_${tmpCounter}"
            appendLine("  br i1 $isZero, label %$doneLabel, label %$fillLabel")
            appendLine()
            appendLine("$fillLabel:")
            val idxPtr = freshTmp()
            appendLine("  $idxPtr = alloca i64, align 8")
            appendLine("  store i64 0, ptr $idxPtr, align 8")
            val loopLabel = "list_fill_loop_${tmpCounter}"
            appendLine("  br label %$loopLabel")
            appendLine()
            appendLine("$loopLabel:")
            val idx = freshTmp()
            appendLine("  $idx = load i64, ptr $idxPtr, align 8")
            val cmp = freshTmp()
            appendLine("  $cmp = icmp slt i64 $idx, $count")
            val bodyLabel = "list_fill_body_${tmpCounter}"
            appendLine("  br i1 $cmp, label %$bodyLabel, label %$doneLabel")
            appendLine()
            appendLine("$bodyLabel:")
            val elemPtr = freshTmp()
            appendLine("  $elemPtr = getelementptr i64, ptr $data, i64 $idx")
            appendLine("  store i64 $value, ptr $elemPtr, align 8")
            val nextIdx = freshTmp()
            appendLine("  $nextIdx = add i64 $idx, 1")
            appendLine("  store i64 $nextIdx, ptr $idxPtr, align 8")
            appendLine("  br label %$loopLabel")
            appendLine()
            appendLine("$doneLabel:")
        } else {
            // nova_rt_list_create — empty list with capacity 8
            val data = freshTmp()
            appendLine("  $data = call ptr @calloc(i64 8, i64 8)")
            appendLine("  store ptr $data, ptr $header, align 8")
            val sizePtr = freshTmp()
            appendLine("  $sizePtr = getelementptr i64, ptr $header, i64 1")
            appendLine("  store i64 0, ptr $sizePtr, align 8")
            val capPtr = freshTmp()
            appendLine("  $capPtr = getelementptr i64, ptr $header, i64 2")
            appendLine("  store i64 8, ptr $capPtr, align 8")
        }
        appendLine("  ${ref(inst.result)} = ptrtoint ptr $header to i64")
        refTypes[inst.result] = inst.type
    }

    private fun StringBuilder.emitInlineListAppend(listRef: IrRef, elemRef: IrRef, resultRef: IrRef) {
        val listPtr = freshTmp()
        val sizePtr = freshTmp()
        val capPtr = freshTmp()
        val size = freshTmp()
        val cap = freshTmp()
        val needGrow = freshTmp()
        val growLabel = "list_grow_${tmpCounter}"
        val appendLabel = "list_append_${tmpCounter}"
        appendLine("  $listPtr = inttoptr i64 ${v(listRef)} to ptr")
        appendLine("  $sizePtr = getelementptr i64, ptr $listPtr, i64 1")
        appendLine("  $capPtr = getelementptr i64, ptr $listPtr, i64 2")
        appendLine("  $size = load i64, ptr $sizePtr, align 8, !tbaa !6")
        appendLine("  $cap = load i64, ptr $capPtr, align 8, !tbaa !8")
        appendLine("  $needGrow = icmp sge i64 $size, $cap")
        appendLine("  br i1 $needGrow, label %$growLabel, label %$appendLabel")
        appendLine()
        appendLine("$growLabel:")
        val newCap = freshTmp()
        val newCapBytes = freshTmp()
        val dataPtr = freshTmp()
        val newData = freshTmp()
        appendLine("  $newCap = shl i64 $cap, 1")
        appendLine("  $newCapBytes = shl i64 $newCap, 3")
        appendLine("  $dataPtr = load ptr, ptr $listPtr, align 8, !tbaa !2")
        appendLine("  $newData = call ptr @realloc(ptr $dataPtr, i64 $newCapBytes)")
        appendLine("  store ptr $newData, ptr $listPtr, align 8, !tbaa !2")
        appendLine("  store i64 $newCap, ptr $capPtr, align 8, !tbaa !8")
        appendLine("  br label %$appendLabel")
        appendLine()
        appendLine("$appendLabel:")
        val curData = freshTmp()
        val elemPtr = freshTmp()
        val newSize = freshTmp()
        appendLine("  $curData = load ptr, ptr $listPtr, align 8, !tbaa !2")
        appendLine("  $elemPtr = getelementptr i64, ptr $curData, i64 $size")
        appendLine("  store i64 ${v(elemRef)}, ptr $elemPtr, align 8, !tbaa !4")
        if (!isKnownScalar(refTypes[elemRef])) {
            appendLine("  call void @nova_rc_inc(i64 ${v(elemRef)})")
        }
        appendLine("  $newSize = add i64 $size, 1")
        appendLine("  store i64 $newSize, ptr $sizePtr, align 8, !tbaa !6")
        inlineVals[resultRef] = "0"
    }

    private fun StringBuilder.emitInlineIterHasNext(inst: IrInst.CallDirect) {
        val listPtr = freshTmp()
        val sizePtr = freshTmp()
        val size = freshTmp()
        val cmp = freshTmp()
        appendLine("  $listPtr = inttoptr i64 ${v(inst.args[0])} to ptr")
        appendLine("  $sizePtr = getelementptr i64, ptr $listPtr, i64 1")
        appendLine("  $size = load i64, ptr $sizePtr, align 8")
        appendLine("  $cmp = icmp slt i64 ${v(inst.args[1])}, $size")
        appendLine("  ${ref(inst.result)} = zext i1 $cmp to i64")
        refTypes[inst.result] = IrType.I64
    }

    private fun StringBuilder.emitInlineIterGet(inst: IrInst.CallDirect) {
        val listPtr = freshTmp()
        val dataPtr = freshTmp()
        val data = freshTmp()
        val elemPtr = freshTmp()
        appendLine("  $listPtr = inttoptr i64 ${v(inst.args[0])} to ptr")
        appendLine("  $dataPtr = load ptr, ptr $listPtr, align 8")
        appendLine("  $data = getelementptr i64, ptr $dataPtr, i64 ${v(inst.args[1])}")
        appendLine("  ${ref(inst.result)} = load i64, ptr $data, align 8")
    }

    private fun StringBuilder.emitListAppend(inst: IrInst.ListAppend) {
        val listType = refTypes[inst.list]
        if (listType is IrType.List) {
            emitInlineListAppend(inst.list, inst.elem, inst.result)
        } else {
            val tmp = freshTmp()
            appendLine("  $tmp = call i64 @nova_rt_list_append(i64 ${v(inst.list)}, i64 ${v(inst.elem)})")
            inlineVals[inst.result] = "0"
        }
    }

    private fun StringBuilder.emitIndexGet(inst: IrInst.IndexGet) {
        val targetType = refTypes[inst.target]
        when {
            targetType is IrType.Tuple -> {
                val ptr = freshTmp(); val gep = freshTmp()
                appendLine("  $ptr = inttoptr i64 ${v(inst.target)} to ptr")
                appendLine("  $gep = getelementptr i64, ptr $ptr, i64 ${v(inst.index)}")
                appendLine("  ${ref(inst.result)} = load i64, ptr $gep")
            }
            targetType is IrType.Dict -> {
                val fused = fusedConcatOps[inst.index]
                if (fused != null) {
                    appendLine("  ${ref(inst.result)} = call i64 @nova_rt_dict_get_concat2(i64 ${v(inst.target)}, i64 ${v(fused.first)}, i64 ${v(fused.second)})")
                } else {
                    appendLine("  ${ref(inst.result)} = call i64 @nova_rt_dict_get(i64 ${v(inst.target)}, i64 ${v(inst.index)})")
                }
                if (targetType.valType != IrType.Any) refTypes[inst.result] = targetType.valType
            }
            targetType is IrType.List -> {
                // Inline list access — fast path for non-negative indices
                // Negative indices handled by nova_rt_list_get (else branch)
                val listPtr = freshTmp()
                val dataPtr = freshTmp()
                val elemPtr = freshTmp()
                appendLine("  $listPtr = inttoptr i64 ${v(inst.target)} to ptr")
                appendLine("  $dataPtr = load ptr, ptr $listPtr, align 8, !tbaa !2")
                appendLine("  $elemPtr = getelementptr i64, ptr $dataPtr, i64 ${v(inst.index)}")
                appendLine("  ${ref(inst.result)} = load i64, ptr $elemPtr, align 8, !tbaa !4")
                if (targetType.elem != IrType.Any) {
                    refTypes[inst.result] = targetType.elem
                }
            }
            else -> {
                val idxType = refTypes[inst.index]
                if (idxType == IrType.Str) {
                    val fused = fusedConcatOps[inst.index]
                    if (fused != null) {
                        appendLine("  ${ref(inst.result)} = call i64 @nova_rt_dict_get_concat2(i64 ${v(inst.target)}, i64 ${v(fused.first)}, i64 ${v(fused.second)})")
                    } else {
                        appendLine("  ${ref(inst.result)} = call i64 @nova_rt_dict_get(i64 ${v(inst.target)}, i64 ${v(inst.index)})")
                    }
                } else {
                    appendLine("  ${ref(inst.result)} = call i64 @nova_rt_list_get(i64 ${v(inst.target)}, i64 ${v(inst.index)})")
                }
            }
        }
    }

    private fun StringBuilder.emitIndexSet(inst: IrInst.IndexSet) {
        val targetType = refTypes[inst.target]
        if (targetType is IrType.Dict) {
            val tmp = freshTmp()
            val fused = fusedConcatOps[inst.index]
            if (fused != null) {
                appendLine("  $tmp = call i64 @nova_rt_dict_set_concat2(i64 ${v(inst.target)}, i64 ${v(fused.first)}, i64 ${v(fused.second)}, i64 ${v(inst.value)})")
            } else {
                appendLine("  $tmp = call i64 @nova_rt_dict_set(i64 ${v(inst.target)}, i64 ${v(inst.index)}, i64 ${v(inst.value)})")
            }
        } else if (targetType is IrType.List) {
            // Inline list set — fast path for non-negative indices
            val listPtr = freshTmp()
            val dataPtr = freshTmp()
            val elemPtr = freshTmp()
            appendLine("  $listPtr = inttoptr i64 ${v(inst.target)} to ptr")
            appendLine("  $dataPtr = load ptr, ptr $listPtr, align 8, !tbaa !2")
            appendLine("  $elemPtr = getelementptr i64, ptr $dataPtr, i64 ${v(inst.index)}")
            appendLine("  store i64 ${v(inst.value)}, ptr $elemPtr, align 8, !tbaa !4")
        } else {
            val tmp = freshTmp()
            appendLine("  $tmp = call i64 @nova_rt_list_set(i64 ${v(inst.target)}, i64 ${v(inst.index)}, i64 ${v(inst.value)})")
        }
        inlineVals[inst.result] = "0"
    }

    // ── Tuple operations ─────────────────────────────────────────────────────

    private fun StringBuilder.emitMakeTuple(inst: IrInst.MakeTuple) {
        val n = inst.elems.size
        val mem = freshTmp()
        appendLine("  $mem = call ptr @malloc(i64 ${n * 8L})")
        appendLine("  call void @nova_rt_track_raw(ptr $mem)")
        for ((i, elem) in inst.elems.withIndex()) {
            val gep = freshTmp()
            appendLine("  $gep = getelementptr i64, ptr $mem, i64 $i")
            appendLine("  store i64 ${v(elem)}, ptr $gep")
        }
        appendLine("  ${ref(inst.result)} = ptrtoint ptr $mem to i64")
        refTypes[inst.result] = inst.type
    }

    // ── Struct/record operations ─────────────────────────────────────────────

    private fun StringBuilder.emitMakeRecord(inst: IrInst.MakeRecord) {
        val fieldCount = inst.fields.size
        val totalSize = fieldCount * 8L
        val isStackAlloc = inst.result in stackAllocRefs
        val mem = freshTmp()
        if (isStackAlloc) {
            appendLine("  $mem = alloca i64, i64 $fieldCount, align 8")
        } else {
            appendLine("  $mem = call ptr @malloc(i64 $totalSize)")
            appendLine("  call void @nova_rt_track_raw(ptr $mem)")
        }
        val fieldOrder = if (inst.type is IrType.Struct) {
            structDefs[(inst.type as IrType.Struct).name] ?: inst.fields.map { it.first }
        } else {
            inst.fields.map { it.first }
        }
        val fieldMap = inst.fields.toMap()
        for ((i, fieldName) in fieldOrder.withIndex()) {
            val fieldRef = fieldMap[fieldName] ?: continue
            val gep = freshTmp()
            appendLine("  $gep = getelementptr i64, ptr $mem, i64 $i")
            appendLine("  store i64 ${v(fieldRef)}, ptr $gep")
        }
        appendLine("  ${ref(inst.result)} = ptrtoint ptr $mem to i64")
        refTypes[inst.result] = inst.type
    }

    private fun StringBuilder.emitFieldGet(inst: IrInst.FieldGet) {
        val targetType = if (inst.objType != IrType.Any) inst.objType else refTypes[inst.obj]
        if (targetType is IrType.Struct && structDefs.containsKey(targetType.name)) {
            val fieldIdx = fieldIndex(targetType, inst.field)
            val ptr = freshTmp()
            val gep = freshTmp()
            appendLine("  $ptr = inttoptr i64 ${v(inst.obj)} to ptr")
            appendLine("  $gep = getelementptr i64, ptr $ptr, i64 $fieldIdx")
            appendLine("  ${ref(inst.result)} = load i64, ptr $gep")
        } else {
            val keyIdx = internString(inst.field)
            val keyTmp = freshTmp()
            appendLine("  $keyTmp = getelementptr inbounds [${inst.field.length + 1} x i8], ptr @.str.$keyIdx, i64 0, i64 0")
            val keyRef = freshTmp()
            appendLine("  $keyRef = ptrtoint ptr $keyTmp to i64")
            appendLine("  ${ref(inst.result)} = call i64 @nova_rt_dict_get(i64 ${v(inst.obj)}, i64 $keyRef)")
        }
        if (inst.type != IrType.Any) refTypes[inst.result] = inst.type
    }

    private fun StringBuilder.emitFieldSet(inst: IrInst.FieldSet) {
        val targetType = refTypes[inst.obj]
        if (targetType is IrType.Struct && structDefs.containsKey(targetType.name)) {
            val fieldIdx = fieldIndex(targetType, inst.field)
            val ptr = freshTmp()
            val gep = freshTmp()
            appendLine("  $ptr = inttoptr i64 ${v(inst.obj)} to ptr")
            appendLine("  $gep = getelementptr i64, ptr $ptr, i64 $fieldIdx")
            appendLine("  store i64 ${v(inst.value)}, ptr $gep")
        } else {
            val keyIdx = internString(inst.field)
            val keyTmp = freshTmp()
            appendLine("  $keyTmp = getelementptr inbounds [${inst.field.length + 1} x i8], ptr @.str.$keyIdx, i64 0, i64 0")
            val keyRef = freshTmp()
            appendLine("  $keyRef = ptrtoint ptr $keyTmp to i64")
            appendLine("  call i64 @nova_rt_dict_set(i64 ${v(inst.obj)}, i64 $keyRef, i64 ${v(inst.value)})")
        }
        inlineVals[inst.result] = "0"
    }

    private fun fieldIndex(type: IrType?, fieldName: String): Int {
        if (type is IrType.Struct) {
            val fields = structDefs[type.name]
            if (fields != null) return fields.indexOf(fieldName).coerceAtLeast(0)
        }
        return 0
    }

    // ── String operations ────────────────────────────────────────────────────

    private fun StringBuilder.emitStringConcat(inst: IrInst.StringConcat) {
        if (inst.result in fusedConcatOps) {
            refTypes[inst.result] = IrType.Str
            return
        }
        when {
            inst.parts.isEmpty() -> {
                val idx = internString("")
                val tmp = freshTmp()
                appendLine("  $tmp = getelementptr inbounds [1 x i8], ptr @.str.$idx, i64 0, i64 0")
                appendLine("  ${ref(inst.result)} = ptrtoint ptr $tmp to i64")
                refTypes[inst.result] = IrType.Str
            }
            inst.parts.size == 1 -> {
                inlineVals[inst.result] = v(inst.parts[0])
                refTypes[inst.result] = IrType.Str
            }
            else -> {
                var acc = v(inst.parts[0])
                var accIsIntermediate = false
                for (i in 1 until inst.parts.size) {
                    val prevAcc = acc
                    val tmp = freshTmp()
                    appendLine("  $tmp = call i64 @nova_rt_str_concat(i64 $acc, i64 ${v(inst.parts[i])})")
                    if (accIsIntermediate) {
                        appendLine("  call void @nova_rc_dec(i64 $prevAcc)")
                    }
                    acc = tmp
                    accIsIntermediate = true
                }
                inlineVals[inst.result] = acc
                refTypes[inst.result] = IrType.Str
            }
        }
    }

    private fun StringBuilder.emitToString(inst: IrInst.ToString) {
        val srcType = refTypes[inst.value] ?: IrType.Any
        if (srcType == IrType.Str) {
            inlineVals[inst.result] = v(inst.value)
            refTypes[inst.result] = IrType.Str
            return
        }
        val fn = when (srcType) {
            IrType.F64  -> "nova_rt_float_to_str"
            IrType.Bool -> "nova_rt_bool_to_str"
            IrType.I64  -> "nova_rt_int_to_str"
            else        -> "nova_rt_any_to_str"
        }
        appendLine("  ${ref(inst.result)} = call i64 @$fn(i64 ${v(inst.value)})")
        refTypes[inst.result] = IrType.Str
    }

    // ── Print builtin ────────────────────────────────────────────────────────

    private fun StringBuilder.emitPrint(argRef: IrRef?, resultRef: IrRef) {
        if (argRef == null) {
            appendLine("  call i32 @puts(ptr null)")
            inlineVals[resultRef] = "0"
            return
        }
        val argType = refTypes[argRef] ?: IrType.Any
        when (argType) {
            is IrType.List -> {
                appendLine("  call i64 @nova_rt_list_print(i64 ${v(argRef)})")
            }
            IrType.Str -> {
                val ptr = freshTmp()
                appendLine("  $ptr = inttoptr i64 ${v(argRef)} to ptr")
                appendLine("  call i32 @puts(ptr $ptr)")
            }
            IrType.F64 -> {
                val fval = freshTmp(); val fmt = freshTmp()
                val fmtIdx = stringIndex["%f\n"]!!
                val fmtLen = 4
                appendLine("  $fval = bitcast i64 ${v(argRef)} to double")
                appendLine("  $fmt = getelementptr inbounds [$fmtLen x i8], ptr @.str.$fmtIdx, i64 0, i64 0")
                appendLine("  call i32 (ptr, ...) @printf(ptr $fmt, double $fval)")
            }
            IrType.Bool -> {
                val trueIdx = internString("true")
                val falseIdx = internString("false")
                val cmp = freshTmp(); val tp = freshTmp(); val fp = freshTmp(); val sel = freshTmp()
                appendLine("  $cmp = icmp ne i64 ${v(argRef)}, 0")
                appendLine("  $tp = getelementptr inbounds [5 x i8], ptr @.str.$trueIdx, i64 0, i64 0")
                appendLine("  $fp = getelementptr inbounds [6 x i8], ptr @.str.$falseIdx, i64 0, i64 0")
                appendLine("  $sel = select i1 $cmp, ptr $tp, ptr $fp")
                appendLine("  call i32 @puts(ptr $sel)")
            }
            IrType.I64 -> {
                val fmt = freshTmp()
                val fmtIdx = stringIndex["%lld\n"]!!
                val fmtLen = 5
                appendLine("  $fmt = getelementptr inbounds [$fmtLen x i8], ptr @.str.$fmtIdx, i64 0, i64 0")
                appendLine("  call i32 (ptr, ...) @printf(ptr $fmt, i64 ${v(argRef)})")
            }
            else -> {
                val strVal = freshTmp()
                val strPtr = freshTmp()
                appendLine("  $strVal = call i64 @nova_rt_any_to_str(i64 ${v(argRef)})")
                appendLine("  $strPtr = inttoptr i64 $strVal to ptr")
                appendLine("  call i32 @puts(ptr $strPtr)")
            }
        }
        inlineVals[resultRef] = "0"
    }

    // ── Terminators ──────────────────────────────────────────────────────────

    private fun StringBuilder.emitTerminator(term: IrTerminator?, block: IrBlock) {
        when (term) {
            is IrTerminator.Return -> {
                emitRcCleanup(term.value)
                appendLine("  ret i64 ${v(term.value)}")
            }
            is IrTerminator.Goto   -> {
                val isBackEdge = term.target in loopHeaders && term.target.id <= block.id.id
                val loopMeta = if (isBackEdge) ", !llvm.loop !91" else ""
                appendLine("  br label %${labelOf(term.target)}$loopMeta")
            }
            is IrTerminator.Branch -> {
                val isLoopHeader = block.id in loopHeaders
                val profMeta = if (isLoopHeader) ", !prof !90" else ""
                val i1Name = boolI1Alias[term.cond]
                if (i1Name != null) {
                    appendLine("  br i1 $i1Name, label %${labelOf(term.thenBlock)}, label %${labelOf(term.elseBlock)}$profMeta")
                } else {
                    val cond = freshTmp()
                    appendLine("  $cond = trunc i64 ${v(term.cond)} to i1")
                    appendLine("  br i1 $cond, label %${labelOf(term.thenBlock)}, label %${labelOf(term.elseBlock)}$profMeta")
                }
            }
            is IrTerminator.Unreachable -> appendLine("  unreachable")
            null -> appendLine("  unreachable  ; missing terminator")
        }
    }

    private fun StringBuilder.emitRcCleanup(returnValue: IrRef) {
        val retIsAlias = returnValue in aliasRefs
        if (rcSlots.isEmpty() && nonEscapingListSlots.isEmpty() && !retIsAlias) return
        val retType = refTypes[returnValue]
        if (!isKnownScalar(retType)) {
            appendLine("  call void @nova_rc_inc(i64 ${v(returnValue)})")
        }
        for (slotName in rcSlots) {
            val st = slotTypes[slotName]
            if (isKnownScalar(st)) continue
            val tmp = freshTmp()
            appendLine("  $tmp = load i64, ptr %slot.$slotName, align 8")
            appendLine("  call void @nova_rc_dec(i64 $tmp)")
        }
        for (slotName in nonEscapingListSlots) {
            val listVal = freshTmp()
            appendLine("  $listVal = load i64, ptr %slot.$slotName, align 8")
            val headerPtr = freshTmp()
            appendLine("  $headerPtr = inttoptr i64 $listVal to ptr")
            val dataPtr = freshTmp()
            appendLine("  $dataPtr = load ptr, ptr $headerPtr, align 8")
            appendLine("  call void @free(ptr $dataPtr)")
            appendLine("  call void @free(ptr $headerPtr)")
        }
    }

    private fun isHeapType(type: IrType): Boolean = when (type) {
        is IrType.List, is IrType.Dict, is IrType.Struct,
        is IrType.Str, is IrType.Any, is IrType.Channel,
        is IrType.Closure -> true
        else -> false
    }

    private fun isKnownScalar(type: IrType?): Boolean = when (type) {
        is IrType.I64, is IrType.F64, is IrType.Bool, is IrType.Unit -> true
        else -> false
    }

    private fun isHeapTypeFromInst(storeInst: IrInst.SlotStore, fn: IrFunction): Boolean {
        val valueRef = storeInst.value
        for (block in fn.blocks)
            for (inst in block.instructions)
                if (inst.result == valueRef)
                    return isHeapType(inst.type)
        return false
    }

    // ── Temporary RC cleanup: drop heap temporaries after their last use ────

    private fun usedRefs(inst: IrInst): List<IrRef> = when (inst) {
        is IrInst.Const, is IrInst.SlotAlloc, is IrInst.SlotLoad,
        is IrInst.LoadErrorMsg, is IrInst.RaiseError, is IrInst.ChannelCreate -> emptyList()
        is IrInst.SlotStore -> listOf(inst.value)
        is IrInst.Binary -> if (inst.result in fusedConcatOps) emptyList() else listOf(inst.left, inst.right)
        is IrInst.Unary -> listOf(inst.operand)
        is IrInst.CallDirect -> inst.args
        is IrInst.Call -> listOf(inst.callee) + inst.args
        is IrInst.MakeClosure -> inst.captureRefs
        is IrInst.MakeList -> inst.elems
        is IrInst.ListAppend -> listOf(inst.list, inst.elem)
        is IrInst.MakeTuple -> inst.elems
        is IrInst.MakeRecord -> inst.fields.map { it.second }
        is IrInst.FieldGet -> listOf(inst.obj)
        is IrInst.FieldSet -> listOf(inst.obj, inst.value)
        is IrInst.IndexGet -> {
            val fused = fusedConcatOps[inst.index]
            if (fused != null) listOf(inst.target, fused.first, fused.second)
            else listOf(inst.target, inst.index)
        }
        is IrInst.IndexSet -> {
            val fused = fusedConcatOps[inst.index]
            if (fused != null) listOf(inst.target, fused.first, fused.second, inst.value)
            else listOf(inst.target, inst.index, inst.value)
        }
        is IrInst.MakeDict -> inst.entries.flatMap { listOf(it.first, it.second) }
        is IrInst.StringConcat -> if (inst.result in fusedConcatOps) emptyList() else inst.parts
        is IrInst.ToString -> listOf(inst.value)
        is IrInst.Copy -> listOf(inst.source)
        is IrInst.IsError -> listOf(inst.value)
        is IrInst.UnwrapError -> listOf(inst.value)
        is IrInst.ChannelSend -> listOf(inst.channel, inst.value)
        is IrInst.ChannelReceive -> listOf(inst.channel)
        is IrInst.Spawn -> inst.args
        is IrInst.ChannelSelect -> inst.channels
        is IrInst.ChannelClose -> listOf(inst.channel)
        is IrInst.ChannelRecvTimeout -> listOf(inst.channel, inst.timeoutMs)
    }

    private fun isStringTemp(inst: IrInst): Boolean = when (inst) {
        is IrInst.StringConcat, is IrInst.ToString -> true
        is IrInst.CallDirect -> inst.funcName in stringProducingFuncs
        is IrInst.Binary -> inst.type is IrType.Str || inst.op == BinOp.CONCAT
        else -> false
    }

    private fun isHeapTemp(inst: IrInst): Boolean = when (inst) {
        is IrInst.StringConcat, is IrInst.ToString -> true
        is IrInst.MakeList, is IrInst.MakeDict, is IrInst.MakeRecord, is IrInst.MakeTuple -> true
        is IrInst.MakeClosure -> true
        is IrInst.Copy -> true
        is IrInst.CallDirect -> inst.funcName in heapProducingFuncs
        is IrInst.Binary -> inst.type is IrType.Str || inst.op == BinOp.CONCAT
        else -> false
    }

    private val stringProducingFuncs = setOf(
        "nova_rt_str_concat", "nova_rt_int_to_str", "nova_rt_float_to_str",
        "nova_rt_bool_to_str", "nova_rt_value_to_str", "nova_rt_any_to_str",
        "nova_rt_upper", "nova_rt_lower", "nova_rt_trim",
        "nova_rt_replace", "nova_rt_slice", "nova_rt_join",
        "nova_rt_chr", "nova_rt_read_file", "nova_rt_read_line",
        "nova_rt_json_stringify",
        "str"
    )

    private val heapProducingFuncs = stringProducingFuncs + setOf(
        // List producers
        "nova_rt_list_create", "nova_rt_list_create_filled",
        "nova_rt_list_reverse", "nova_rt_list_map", "nova_rt_list_filter",
        "nova_rt_list_concat", "nova_rt_list_slice", "nova_rt_list_to_str",
        "nova_rt_reverse", "nova_rt_map", "nova_rt_filter", "nova_rt_concat",
        "nova_rt_split", "nova_rt_chars",
        // Dict producers
        "nova_rt_dict_create", "nova_rt_dict_keys", "nova_rt_dict_values", "nova_rt_dict_items",
        "nova_rt_values", "nova_rt_items",
        // JSON
        "nova_rt_json_parse"
    )

    private val safeConsumerFuncs = setOf(
        // IR-level names (before codegen translates to nova_rt_*)
        "len", "print",
        // Runtime-level names
        "nova_rt_str_concat", "nova_rt_print", "nova_rt_println",
        "nova_rt_str_len", "nova_rt_str_slice", "nova_rt_str_replace",
        "nova_rt_str_upper", "nova_rt_str_lower", "nova_rt_str_trim",
        "nova_rt_str_split", "nova_rt_str_contains", "nova_rt_str_index_of",
        "nova_rt_str_starts_with", "nova_rt_str_ends_with", "nova_rt_str_repeat",
        "nova_rt_str_char_at", "nova_rt_str_cmp",
        "nova_rt_list_len", "nova_rt_list_print", "nova_rt_list_to_str",
        "nova_rt_list_get", "nova_rt_list_set",
        "nova_rt_list_append", "nova_rt_append", "nova_rt_push",
        "nova_rt_list_reverse", "nova_rt_list_sort",
        "nova_rt_list_map", "nova_rt_list_filter", "nova_rt_list_concat", "nova_rt_list_slice",
        "nova_rt_reverse", "nova_rt_sort", "nova_rt_map", "nova_rt_filter", "nova_rt_concat",
        "nova_rt_dict_len", "nova_rt_dict_get", "nova_rt_dict_has", "nova_rt_dict_del", "nova_rt_dict_set",
        "nova_rt_dict_get_concat2", "nova_rt_dict_set_concat2",
        "nova_rt_dict_keys", "nova_rt_dict_values", "nova_rt_dict_items",
        "nova_rt_keys", "nova_rt_values", "nova_rt_items",
        "nova_rt_len", "nova_rt_len_any",
        "nova_rt_any_to_str", "nova_rt_value_to_str",
        "nova_rt_json_stringify",
        "nova_rt_contains", "nova_rt_find"
    )

    private fun isSafeConsumer(inst: IrInst): Boolean = when (inst) {
        is IrInst.CallDirect -> inst.funcName in safeConsumerFuncs
        is IrInst.ListAppend -> true
        is IrInst.StringConcat, is IrInst.ToString -> true
        is IrInst.Binary -> true
        is IrInst.IndexGet, is IrInst.IndexSet -> true
        else -> false
    }

    private fun computeTempCleanups(block: IrBlock): Map<Int, List<IrRef>> {
        val instructions = block.instructions

        val heapTemps = mutableMapOf<IrRef, Int>()
        val stringRefs = mutableSetOf<IrRef>()
        for ((i, inst) in instructions.withIndex()) {
            if (inst.result in fusedConcatOps) continue
            if (isHeapTemp(inst)) {
                heapTemps[inst.result] = i
                if (isStringTemp(inst)) stringRefs.add(inst.result)
            }
        }
        // Second pass: Binary(ADD) with string operands produces a heap string
        for ((i, inst) in instructions.withIndex()) {
            if (inst.result in fusedConcatOps) continue
            if (inst is IrInst.Binary && inst.op == BinOp.ADD && inst.result !in heapTemps) {
                if (inst.left in stringRefs || inst.right in stringRefs) {
                    heapTemps[inst.result] = i
                    stringRefs.add(inst.result)
                }
            }
        }
        if (heapTemps.isEmpty()) return emptyMap()

        val lastUse = mutableMapOf<IrRef, Pair<Int, IrInst>>()
        val allUses = mutableMapOf<IrRef, MutableList<IrInst>>()
        for ((i, inst) in instructions.withIndex())
            for (ref in usedRefs(inst))
                if (ref in heapTemps) {
                    lastUse[ref] = Pair(i, inst)
                    allUses.getOrPut(ref) { mutableListOf() }.add(inst)
                }

        val termRefs = mutableSetOf<IrRef>()
        when (val t = block.terminator) {
            is IrTerminator.Return -> termRefs.add(t.value)
            is IrTerminator.Branch -> termRefs.add(t.cond)
            else -> {}
        }

        val slotStoreValues = mutableSetOf<IrRef>()
        for (inst in instructions)
            if (inst is IrInst.SlotStore) slotStoreValues.add(inst.value)

        val result = mutableMapOf<Int, MutableList<IrRef>>()
        for ((ref, producerIdx) in heapTemps) {
            if (ref in slotStoreValues) continue
            if (ref in termRefs) continue

            if (ref !in lastUse) {
                result.getOrPut(producerIdx) { mutableListOf() }.add(ref)
                continue
            }

            val (lastIdx, lastInst) = lastUse[ref]!!

            if (ref in stringRefs) {
                if (isSafeConsumer(lastInst))
                    result.getOrPut(lastIdx) { mutableListOf() }.add(ref)
            } else {
                val uses = allUses[ref] ?: continue
                if (uses.all { isSafeConsumer(it) })
                    result.getOrPut(lastIdx) { mutableListOf() }.add(ref)
            }
        }
        return result
    }

    // ── Closure trampolines ──────────────────────────────────────────────────
    // Each capturing lambda gets a trampoline emitted after all module functions.
    // Signature: (env: i64, arg0..argN-1: i64) where env is the closure record pointer.
    // The trampoline loads captures from the record and calls the underlying function
    // with (explicit_args..., cap0, cap1, ...).

    private fun StringBuilder.emitTrampolines() {
        for (spec in trampolines) {
            val escapedName = escapeName(spec.fnName)
            val trampName   = "${escapedName}_tramp"
            val explicitCount = spec.totalParamCount - spec.captureCount
            // p0 = env (closure record ptr), p1..p(explicitCount) = explicit args
            val paramParts = mutableListOf("i64 %p0")
            for (i in 0 until explicitCount) paramParts.add("i64 %p${i + 1}")
            appendLine("define i64 @$trampName(${paramParts.joinToString(", ")}) nounwind {")
            appendLine("entry_tramp:")
            appendLine("  %env_ptr = inttoptr i64 %p0 to ptr")
            for (i in 0 until spec.captureCount) {
                appendLine("  %cap${i}_gep = getelementptr i64, ptr %env_ptr, i64 ${i + 1}")
                appendLine("  %cap$i = load i64, ptr %cap${i}_gep")
            }
            val underlyingArgs = mutableListOf<String>()
            for (i in 0 until explicitCount) underlyingArgs.add("i64 %p${i + 1}")
            for (i in 0 until spec.captureCount) underlyingArgs.add("i64 %cap$i")
            appendLine("  %tramp_result = call i64 @$escapedName(${underlyingArgs.joinToString(", ")})")
            appendLine("  ret i64 %tramp_result")
            appendLine("}")
            appendLine()
        }
    }

    // ── Spawn trampolines ──────────────────────────────────────────────────
    // One trampoline per spawn arity. Unpacks {fn_ptr, arg0, arg1, ...} from
    // the context struct and calls the lifted function with the right args.

    private fun StringBuilder.emitSpawnTrampolines() {
        for (arity in spawnArities.sorted()) {
            appendLine("define void @__nova_spawn_tramp_$arity(ptr %ctx) nounwind {")
            appendLine("entry:")
            appendLine("  %fn_i64 = load i64, ptr %ctx")
            appendLine("  %fn = inttoptr i64 %fn_i64 to ptr")
            for (i in 0 until arity) {
                appendLine("  %p${i + 1} = getelementptr i64, ptr %ctx, i32 ${i + 1}")
                appendLine("  %a$i = load i64, ptr %p${i + 1}")
            }
            val argStr = (0 until arity).joinToString(", ") { "i64 %a$it" }
            appendLine("  call i64 %fn($argStr)")
            appendLine("  call void @free(ptr %ctx)")
            appendLine("  ret void")
            appendLine("}")
        }
    }

    // ── Main wrapper ─────────────────────────────────────────────────────────

    private fun StringBuilder.emitMainWrapper(module: IrModule) {
        val hasNovaMain = module.functions.any { it.name == "nova_main" }
        if (!hasNovaMain) return
        appendLine("define i32 @main() nounwind {")
        appendLine("entry:")
        appendLine("  call void @nova_rt_init()")
        appendLine("  call i64 @nova_main()")
        appendLine("  call void @nova_rt_wait_all()")
        appendLine("  call void @nova_rt_cleanup()")
        appendLine("  ret i32 0")
        appendLine("}")
    }

    // ── String escaping for LLVM IR ──────────────────────────────────────────

    private fun escapeLlvm(bytes: ByteArray): String = buildString {
        for (b in bytes) {
            val c = b.toInt() and 0xFF
            when {
                c == '\\'.code -> append("\\\\")
                c == '"'.code  -> append("\\22")
                c in 0x20..0x7E -> append(c.toChar())
                else -> append("\\${String.format("%02X", c)}")
            }
        }
    }

    private fun escapeName(name: String): String =
        name.replace('$', '_').replace('-', '_')

    // ── TBAA metadata ───────────────────────────────────────────────────────
    // Distinguishes list header reads (data pointer) from element stores so
    // LLVM can hoist the invariant data-pointer load out of inner loops.

    private fun StringBuilder.emitTbaaMetadata() {
        appendLine("!0 = !{!\"NOVA TBAA\"}")
        appendLine("!1 = !{!\"list_data_ptr\", !0}")
        appendLine("!2 = !{!1, !1, i64 0}")
        appendLine("!3 = !{!\"list_elem\", !0}")
        appendLine("!4 = !{!3, !3, i64 0}")
        appendLine("!5 = !{!\"list_size\", !0}")
        appendLine("!6 = !{!5, !5, i64 0}")
        appendLine("!7 = !{!\"list_cap\", !0}")
        appendLine("!8 = !{!7, !7, i64 0}")
        appendLine("!90 = !{!\"branch_weights\", i32 2000, i32 1}")
        appendLine("!91 = distinct !{!91, !92, !93}")
        appendLine("!92 = !{!\"llvm.loop.unroll.enable\"}")
        appendLine("!93 = !{!\"llvm.loop.vectorize.enable\", i1 true}")
    }
}

