package nova.ir

// ── IR Optimizer ─────────────────────────────────────────────────────────────
//
// Four passes run twice per function (two iterations converge most programs):
//
//   Pass 1 — Dead Block Elimination (DBE)
//     Removes basic blocks unreachable from the entry block. The lowering emits
//     a fresh "dead" block after every return/break/continue. These blocks are
//     structurally valid but never execute; removing them shrinks the IR and
//     lets subsequent passes skip useless work.
//
//   Pass 2 — Constant Folding
//     Evaluates constant expressions at compile time. Maintains a constMap
//     (ref → IrConst) as it walks instructions in order. When all operands of
//     a Binary/Unary/StringConcat/ToString are in constMap, the instruction is
//     replaced with a single Const. The result ref is unchanged so downstream
//     instructions need no rewriting.
//
//   Pass 3 — Slot Coalescing (intra-block)
//     Tracks the last value stored to each slot within a block. When a SlotLoad
//     follows a SlotStore for the same slot with no intervening store, the load
//     result is forwarded through a substitution map and the load instruction is
//     dropped. Cross-block analysis is left to LLVM's mem2reg pass.
//
//   Pass 4 — Dead Instruction Elimination (DIE)
//     Removes pure instructions (no observable side effects) whose result ref
//     is not used by any surviving instruction or terminator. Uses a "usedRefs"
//     set computed at the start of each iteration; the second iteration cleans
//     up consts that were only used by instructions eliminated in the first.
//
// All passes are semantics-preserving. The optimizer never reorders instructions
// or removes any instruction with observable side effects (store, call, channel
// op, spawn, list-append, field-set, index-set).

class IrOptimizer {

    fun optimize(module: IrModule): IrModule {
        inlineFunctions(module)
        devirtualizeCalls(module)
        inlineFunctions(module)
        inlineMultiBlockFunctions(module)
        eliminateUnusedFunctions(module)
        val result = IrModule(module.name)
        result.structs.addAll(module.structs)
        for (fn in module.functions) {
            result.functions.add(optimizeFunction(fn))
        }
        return result
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Module-level: Function Inlining
    //
    // Identifies small single-block functions and inlines them at CallDirect
    // sites. Runs before per-function optimization so the inlined code benefits
    // from constant folding, slot coalescing, LICM, etc.
    // ─────────────────────────────────────────────────────────────────────────

    private fun inlineFunctions(module: IrModule) {
        for (fn in module.functions) eliminateDeadBlocks(fn)
        val candidates = mutableMapOf<String, IrFunction>()
        for (fn in module.functions) {
            if (isInlineCandidate(fn)) candidates[fn.name] = fn
        }
        if (candidates.isEmpty()) return
        for (fn in module.functions) {
            inlineCallsIn(fn, candidates)
        }
    }

    private fun isInlineCandidate(fn: IrFunction): Boolean {
        if (fn.name == "nova_main" || fn.name == "main") return false
        if (fn.blocks.size != 1) return false
        if (fn.captureCount > 0) return false
        val block = fn.blocks[0]
        if (block.instructions.size > 20) return false
        if (block.terminator !is IrTerminator.Return) return false
        if (block.instructions.any { it is IrInst.CallDirect && it.funcName == fn.name }) return false
        return true
    }

    private fun inlineCallsIn(fn: IrFunction, candidates: Map<String, IrFunction>) {
        var maxRefId = 0
        for (b in fn.blocks) for (i in b.instructions) if (i.result.id > maxRefId) maxRefId = i.result.id
        var nextId = maxRefId + 1
        fun freshRef() = IrRef(nextId++)
        var inlineCount = 0
        val globalSubst = mutableMapOf<IrRef, IrRef>()

        for (block in fn.blocks) {
            val newInsts = mutableListOf<IrInst>()
            for (inst in block.instructions) {
                val substInst = applySubst(inst, globalSubst)
                if (substInst is IrInst.CallDirect && substInst.funcName in candidates
                    && substInst.funcName != fn.name) {
                    val callee = candidates[substInst.funcName]!!
                    val calleeBlock = callee.blocks[0]
                    val callTerm = calleeBlock.terminator as IrTerminator.Return

                    val refMap = mutableMapOf<IrRef, IrRef>()
                    for (i in callee.params.indices) {
                        refMap[IrRef(-(i + 1))] = substInst.args[i]
                    }
                    for (ci in calleeBlock.instructions) {
                        refMap[ci.result] = freshRef()
                    }
                    val slotPrefix = "__inl${inlineCount}_"
                    for (ci in calleeBlock.instructions) {
                        newInsts.add(remapInlinedInst(ci, refMap, slotPrefix))
                    }
                    val retVal = refMap[callTerm.value] ?: callTerm.value
                    globalSubst[substInst.result] = retVal
                    inlineCount++
                } else {
                    newInsts.add(substInst)
                }
            }
            block.instructions.clear()
            block.instructions.addAll(newInsts)
            block.terminator = block.terminator?.let { applySubstTerm(it, globalSubst) }
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Module-level: Devirtualization
    //
    // Converts closure-based Call to CallDirect when the callee is a
    // statically-known zero-capture MakeClosure. Traces through single-store
    // slots to handle the common pattern:
    //   MakeClosure(r1, "fn$name", []) → SlotStore(slot, r1)
    //   SlotLoad(r2, slot) → Call(r3, r2, args)
    // After devirtualization: CallDirect(r3, "fn$name", args)
    // ─────────────────────────────────────────────────────────────────────────

    private fun devirtualizeCalls(module: IrModule) {
        for (fn in module.functions) devirtualizeCallsIn(fn)
    }

    private fun devirtualizeCallsIn(fn: IrFunction) {
        val refToFunc = mutableMapOf<IrRef, String>()
        val slotToFunc = mutableMapOf<IrSlot, String>()
        val slotStoreCount = mutableMapOf<IrSlot, Int>()

        for (block in fn.blocks) {
            for (inst in block.instructions) {
                when (inst) {
                    is IrInst.MakeClosure -> {
                        if (inst.captureRefs.isEmpty()) {
                            refToFunc[inst.result] = inst.funcName
                        }
                    }
                    is IrInst.SlotStore -> {
                        slotStoreCount[inst.slot] = (slotStoreCount[inst.slot] ?: 0) + 1
                        val funcName = refToFunc[inst.value]
                        if (funcName != null) slotToFunc[inst.slot] = funcName
                    }
                    else -> {}
                }
            }
        }

        slotStoreCount.forEach { (slot, count) ->
            if (count > 1) slotToFunc.remove(slot)
        }
        if (refToFunc.isEmpty() && slotToFunc.isEmpty()) return

        var changed = false
        for (block in fn.blocks) {
            val newInsts = mutableListOf<IrInst>()
            for (inst in block.instructions) {
                when {
                    inst is IrInst.SlotLoad && inst.slot in slotToFunc -> {
                        refToFunc[inst.result] = slotToFunc[inst.slot]!!
                        newInsts.add(inst)
                    }
                    inst is IrInst.Call && inst.callee in refToFunc -> {
                        newInsts.add(IrInst.CallDirect(
                            inst.result, inst.type,
                            refToFunc[inst.callee]!!, inst.args, inst.span
                        ))
                        changed = true
                    }
                    else -> newInsts.add(inst)
                }
            }
            block.instructions.clear()
            block.instructions.addAll(newInsts)
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Module-level: Multi-Block Function Inlining
    //
    // Inlines functions with 2-5 blocks (if/else, match, early return) by
    // splitting the caller block at the call site and splicing the callee's
    // CFG. Each Return in the callee stores to a merge slot and jumps to a
    // continuation block that loads the return value and continues with the
    // caller's remaining instructions.
    // ─────────────────────────────────────────────────────────────────────────

    private fun inlineMultiBlockFunctions(module: IrModule) {
        for (fn in module.functions) eliminateDeadBlocks(fn)
        val candidates = mutableMapOf<String, IrFunction>()
        for (fn in module.functions) {
            if (isMultiBlockInlineCandidate(fn)) candidates[fn.name] = fn
        }
        if (candidates.isEmpty()) return
        for (fn in module.functions) {
            inlineMultiBlockCallsIn(fn, candidates)
        }
    }

    private fun isMultiBlockInlineCandidate(fn: IrFunction): Boolean {
        if (fn.name == "nova_main" || fn.name == "main") return false
        if (fn.blocks.size <= 1 || fn.blocks.size > 10) return false
        if (fn.captureCount > 0) return false
        val totalInsts = fn.blocks.sumOf { it.instructions.size }
        if (totalInsts > 40) return false
        if (fn.blocks.any { b ->
                b.instructions.any { it is IrInst.CallDirect && it.funcName == fn.name }
            }) return false
        if (fn.blocks.any { b ->
                b.terminator is IrTerminator.Unreachable
            }) return false
        return true
    }

    private fun inlineMultiBlockCallsIn(fn: IrFunction, candidates: Map<String, IrFunction>) {
        var maxBlockId = fn.blocks.maxOfOrNull { it.id.id } ?: 0
        var maxRefId = 0
        for (b in fn.blocks) for (i in b.instructions) if (i.result.id > maxRefId) maxRefId = i.result.id
        var nextRefId = maxRefId + 1
        var nextBlkId = maxBlockId + 1
        fun freshRef() = IrRef(nextRefId++)
        fun freshBlockId() = BlockId(nextBlkId++)
        var inlineCount = 0

        var blockIdx = 0
        while (blockIdx < fn.blocks.size) {
            val block = fn.blocks[blockIdx]
            val callIdx = block.instructions.indexOfFirst { inst ->
                inst is IrInst.CallDirect && inst.funcName in candidates && inst.funcName != fn.name
            }
            if (callIdx < 0) { blockIdx++; continue }

            val callInst = block.instructions[callIdx] as IrInst.CallDirect
            val callee = candidates[callInst.funcName]!!
            val prefix = "__mb${inlineCount}_"
            inlineCount++

            // Build ref and block-id mappings for callee
            val refMap = mutableMapOf<IrRef, IrRef>()
            val blockIdMap = mutableMapOf<BlockId, BlockId>()
            for (i in callee.params.indices) refMap[IrRef(-(i + 1))] = callInst.args[i]
            for (b in callee.blocks) {
                blockIdMap[b.id] = freshBlockId()
                for (inst in b.instructions) refMap[inst.result] = freshRef()
            }

            val retSlot = IrSlot("${prefix}ret")
            val mergeBlockId = freshBlockId()
            val retLoadRef = freshRef()

            // Clone callee blocks with remapped refs/slots/blockIds
            val inlinedBlocks = mutableListOf<IrBlock>()
            for (b in callee.blocks) {
                val newInsts = b.instructions.map { remapInlinedInst(it, refMap, prefix) }.toMutableList()
                val newTerm = when (val t = b.terminator) {
                    is IrTerminator.Return -> {
                        val retVal = refMap[t.value] ?: t.value
                        newInsts.add(IrInst.SlotStore(freshRef(), IrType.Unit, retSlot, retVal, t.span))
                        IrTerminator.Goto(mergeBlockId, t.span)
                    }
                    is IrTerminator.Goto -> IrTerminator.Goto(
                        blockIdMap[t.target] ?: t.target, t.span
                    )
                    is IrTerminator.Branch -> IrTerminator.Branch(
                        refMap[t.cond] ?: t.cond,
                        blockIdMap[t.thenBlock] ?: t.thenBlock,
                        blockIdMap[t.elseBlock] ?: t.elseBlock,
                        t.span
                    )
                    else -> t
                }
                inlinedBlocks.add(IrBlock(blockIdMap[b.id]!!, "${prefix}${b.label}", newInsts, newTerm))
            }

            // Split caller block at call site
            val beforeInsts = block.instructions.subList(0, callIdx).toMutableList()
            val afterInsts = block.instructions.subList(callIdx + 1, block.instructions.size).toMutableList()
            val origTerminator = block.terminator

            // Alloc return slot in before-block
            beforeInsts.add(IrInst.SlotAlloc(freshRef(), IrType.Any, retSlot, callInst.span))

            // Build merge/continuation block
            val mergeInsts = mutableListOf<IrInst>()
            mergeInsts.add(IrInst.SlotLoad(retLoadRef, IrType.Any, retSlot, callInst.span))
            val callSubst = mapOf(callInst.result to retLoadRef)
            for (ai in afterInsts) mergeInsts.add(applySubst(ai, callSubst))
            val mergeTerminator = origTerminator?.let { applySubstTerm(it, callSubst) } ?: origTerminator
            val mergeBlock = IrBlock(mergeBlockId, "${prefix}merge", mergeInsts, mergeTerminator)

            // Rewrite original block: keeps before-insts, jumps to inlined entry
            block.instructions.clear()
            block.instructions.addAll(beforeInsts)
            block.terminator = IrTerminator.Goto(blockIdMap[callee.blocks[0].id]!!, callInst.span)

            // Insert inlined blocks + merge block after current block
            fn.blocks.addAll(blockIdx + 1, inlinedBlocks + mergeBlock)
            blockIdx++
        }
    }

    private fun remapInlinedInst(inst: IrInst, m: Map<IrRef, IrRef>, sp: String): IrInst {
        fun r(ref: IrRef) = m[ref] ?: ref
        fun s(slot: IrSlot) = if (slot.isGlobal) slot else IrSlot(sp + slot.name)
        return when (inst) {
            is IrInst.Const -> inst.copy(result = r(inst.result))
            is IrInst.SlotAlloc -> inst.copy(result = r(inst.result), slot = s(inst.slot))
            is IrInst.SlotStore -> inst.copy(result = r(inst.result), slot = s(inst.slot), value = r(inst.value))
            is IrInst.SlotLoad -> inst.copy(result = r(inst.result), slot = s(inst.slot))
            is IrInst.Binary -> inst.copy(result = r(inst.result), left = r(inst.left), right = r(inst.right))
            is IrInst.Unary -> inst.copy(result = r(inst.result), operand = r(inst.operand))
            is IrInst.Call -> inst.copy(result = r(inst.result), callee = r(inst.callee), args = inst.args.map(::r))
            is IrInst.CallDirect -> inst.copy(result = r(inst.result), args = inst.args.map(::r))
            is IrInst.MakeClosure -> inst.copy(result = r(inst.result), captureRefs = inst.captureRefs.map(::r))
            is IrInst.MakeList -> inst.copy(result = r(inst.result), elems = inst.elems.map(::r))
            is IrInst.ListAppend -> inst.copy(result = r(inst.result), list = r(inst.list), elem = r(inst.elem))
            is IrInst.MakeTuple -> inst.copy(result = r(inst.result), elems = inst.elems.map(::r))
            is IrInst.MakeRecord -> inst.copy(result = r(inst.result), fields = inst.fields.map { it.first to r(it.second) })
            is IrInst.FieldGet -> inst.copy(result = r(inst.result), obj = r(inst.obj))
            is IrInst.FieldSet -> inst.copy(result = r(inst.result), obj = r(inst.obj), value = r(inst.value))
            is IrInst.IndexGet -> inst.copy(result = r(inst.result), target = r(inst.target), index = r(inst.index))
            is IrInst.IndexSet -> inst.copy(result = r(inst.result), target = r(inst.target), index = r(inst.index), value = r(inst.value))
            is IrInst.MakeDict -> inst.copy(result = r(inst.result), entries = inst.entries.map { r(it.first) to r(it.second) })
            is IrInst.StringConcat -> inst.copy(result = r(inst.result), parts = inst.parts.map(::r))
            is IrInst.ToString -> inst.copy(result = r(inst.result), value = r(inst.value))
            is IrInst.Copy -> inst.copy(result = r(inst.result), source = r(inst.source))
            is IrInst.IsError -> inst.copy(result = r(inst.result), value = r(inst.value))
            is IrInst.UnwrapError -> inst.copy(result = r(inst.result), value = r(inst.value))
            is IrInst.LoadErrorMsg -> inst.copy(result = r(inst.result))
            is IrInst.RaiseError -> inst.copy(result = r(inst.result))
            is IrInst.ChannelCreate -> inst.copy(result = r(inst.result))
            is IrInst.ChannelSend -> inst.copy(result = r(inst.result), channel = r(inst.channel), value = r(inst.value))
            is IrInst.ChannelReceive -> inst.copy(result = r(inst.result), channel = r(inst.channel))
            is IrInst.ChannelSelect -> inst.copy(result = r(inst.result), channels = inst.channels.map(::r))
            is IrInst.ChannelClose -> inst.copy(result = r(inst.result), channel = r(inst.channel))
            is IrInst.ChannelRecvTimeout -> inst.copy(result = r(inst.result), channel = r(inst.channel), timeoutMs = r(inst.timeoutMs))
            is IrInst.Spawn -> inst.copy(result = r(inst.result), args = inst.args.map(::r))
        }
    }

    // ── Function-level orchestration ─────────────────────────────────────────

    private fun optimizeFunction(fn: IrFunction): IrFunction {
        val out = deepCopy(fn)
        listFillOpt(out)
        eliminateDeadBlocks(out)
        tailCallOptimize(out)
        localValueOpt(out)   // fold + coalesce + elim
        localValueOpt(out)   // second pass cleans up refs orphaned by first
        deadStoreElimination(out)
        constantBranchFolding(out)
        eliminateDeadBlocks(out)
        loopInvariantCodeMotion(out)
        return out
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Pass 0: List fill loop recognition
    // Detects: list = []; counter = 0; while counter <= limit: list.push(C); counter += 1
    // Replaces with: list = nova_rt_list_create_filled(limit + 1, C)
    // ─────────────────────────────────────────────────────────────────────────

    private fun listFillOpt(fn: IrFunction) {
        val blockMap = fn.blocks.associateBy { it.id }
        var maxRefId = 0
        for (b in fn.blocks) for (i in b.instructions) if (i.result.id > maxRefId) maxRefId = i.result.id
        var nextId = maxRefId + 1
        fun freshRef() = IrRef(nextId++)

        for (block in fn.blocks.toList()) {
            val gotoTerm = block.terminator as? IrTerminator.Goto ?: continue
            val header = blockMap[gotoTerm.target] ?: continue
            val branchTerm = header.terminator as? IrTerminator.Branch ?: continue
            val body = blockMap[branchTerm.thenBlock] ?: continue
            val exitBlockId = branchTerm.elseBlock
            val bodyGoto = body.terminator as? IrTerminator.Goto ?: continue
            if (bodyGoto.target != header.id) continue

            // Find empty MakeList in setup block
            val makeList = block.instructions.filterIsInstance<IrInst.MakeList>()
                .firstOrNull { it.elems.isEmpty() } ?: continue
            val listStore = block.instructions.filterIsInstance<IrInst.SlotStore>()
                .firstOrNull { it.value == makeList.result } ?: continue
            val listSlot = listStore.slot

            // Body must have NO side effects other than push + counter store
            val hasDangerousSideEffects = body.instructions.any {
                it is IrInst.IndexSet || it is IrInst.FieldSet || it is IrInst.ListAppend ||
                it is IrInst.ChannelSend || it is IrInst.Spawn || it is IrInst.Call
            }
            if (hasDangerousSideEffects) continue

            // Find push call in body — must be the only CallDirect
            val callDirects = body.instructions.filterIsInstance<IrInst.CallDirect>()
            if (callDirects.size != 1) continue
            val pushCall = callDirects[0]
            if (pushCall.funcName !in setOf("nova_rt_push", "nova_rt_append")) continue
            if (pushCall.args.size != 2) continue

            // Push target must load from the list slot
            val bodyListLoad = body.instructions.filterIsInstance<IrInst.SlotLoad>()
                .firstOrNull { it.slot == listSlot } ?: continue
            if (pushCall.args[0] != bodyListLoad.result) continue

            // Push value must be a constant (check body first, then setup block)
            val pushValueRef = pushCall.args[1]
            val pushValueConst = body.instructions.filterIsInstance<IrInst.Const>()
                .firstOrNull { it.result == pushValueRef }
                ?: block.instructions.filterIsInstance<IrInst.Const>()
                    .firstOrNull { it.result == pushValueRef }
                ?: continue
            val pushVal = (pushValueConst.value as? IrConst.Int)?.v ?: continue

            // Find counter slot: body must have exactly one SlotStore that isn't the list
            val bodyStores = body.instructions.filterIsInstance<IrInst.SlotStore>()
                .filter { it.slot != listSlot }
            if (bodyStores.size != 1) continue
            val counterSlot = bodyStores[0].slot

            // Verify counter increment: ADD with step 1
            val addInst = body.instructions.filterIsInstance<IrInst.Binary>()
                .firstOrNull { it.op == BinOp.ADD && it.result == bodyStores[0].value }
                ?: continue
            val stepConst = body.instructions.filterIsInstance<IrInst.Const>()
                .firstOrNull { it.result == addInst.right && (it.value as? IrConst.Int)?.v == 1L }
                ?: block.instructions.filterIsInstance<IrInst.Const>()
                    .firstOrNull { it.result == addInst.right && (it.value as? IrConst.Int)?.v == 1L }
                ?: continue

            // Verify counter init: must start at 0
            val counterInitStore = block.instructions.filterIsInstance<IrInst.SlotStore>()
                .firstOrNull { it.slot == counterSlot } ?: continue
            val counterInitConst = block.instructions.filterIsInstance<IrInst.Const>()
                .firstOrNull { it.result == counterInitStore.value
                    && (it.value as? IrConst.Int)?.v == 0L } ?: continue

            // Verify header comparison: counter <= limit
            val cmpInst = header.instructions.filterIsInstance<IrInst.Binary>()
                .firstOrNull { it.result == branchTerm.cond && it.op == BinOp.LE }
                ?: continue
            val limitRef = cmpInst.right
            val limitLoad = header.instructions.filterIsInstance<IrInst.SlotLoad>()
                .firstOrNull { it.result == limitRef }
            val limitSlot = limitLoad?.slot

            // === Pattern matched! Transform ===
            val span = makeList.span
            val newInsts = mutableListOf<IrInst>()
            val skipRefs = setOf(makeList.result, counterInitConst.result)

            // countRef will hold limit+1, reused for both fill call and counter final value
            var countRef: IrRef? = null

            for (inst in block.instructions) {
                when {
                    inst === makeList -> {
                        // Emit: count = limit + 1; list = nova_rt_list_create_filled(count, val)
                        val limitLoadRef = freshRef()
                        if (limitSlot != null) {
                            newInsts.add(IrInst.SlotLoad(limitLoadRef, IrType.I64, limitSlot, span))
                        }
                        val oneRef = freshRef()
                        newInsts.add(IrInst.Const(oneRef, IrType.I64, IrConst.Int(1), span))
                        countRef = freshRef()
                        newInsts.add(IrInst.Binary(countRef!!, IrType.I64, BinOp.ADD,
                            if (limitSlot != null) limitLoadRef else limitRef, oneRef, span))
                        val pushValRef = freshRef()
                        newInsts.add(IrInst.Const(pushValRef, IrType.I64, IrConst.Int(pushVal), span))
                        // Reuse makeList.result so downstream SlotStore still works
                        newInsts.add(IrInst.CallDirect(makeList.result, IrType.List(IrType.Any),
                            "nova_rt_list_create_filled", listOf(countRef!!, pushValRef), span))
                    }
                    inst === listStore -> newInsts.add(inst) // keep the store
                    inst === counterInitStore -> {} // skip counter init store
                    inst.result in skipRefs && inst is IrInst.Const -> {} // skip counter init const
                    else -> newInsts.add(inst)
                }
            }
            // Set counter to its final value (limit + 1) so code after the loop sees the correct value
            if (countRef != null) {
                newInsts.add(IrInst.SlotStore(freshRef(), IrType.Unit, counterSlot, countRef!!, span))
            }
            block.instructions.clear()
            block.instructions.addAll(newInsts)
            block.terminator = IrTerminator.Goto(exitBlockId, span)
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Pass 1: Dead block elimination
    // ─────────────────────────────────────────────────────────────────────────

    private fun eliminateDeadBlocks(fn: IrFunction) {
        val reachable = reachableBlocks(fn)
        fn.blocks.retainAll { it.id in reachable }
    }

    private fun reachableBlocks(fn: IrFunction): Set<BlockId> {
        if (fn.blocks.isEmpty()) return emptySet()
        val seen  = mutableSetOf<BlockId>()
        val queue = ArrayDeque<BlockId>()
        queue.add(fn.blocks.first().id)
        while (queue.isNotEmpty()) {
            val id = queue.removeFirst()
            if (!seen.add(id)) continue
            val block = fn.blocks.find { it.id == id } ?: continue
            when (val t = block.terminator) {
                is IrTerminator.Goto   -> queue.add(t.target)
                is IrTerminator.Branch -> { queue.add(t.thenBlock); queue.add(t.elseBlock) }
                else                   -> {}
            }
        }
        return seen
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Passes 2–4: Local value optimisation (single walk per iteration)
    // ─────────────────────────────────────────────────────────────────────────

    private fun localValueOpt(fn: IrFunction) {
        val usedRefs = computeUsedRefs(fn)
        val crossBlockRefs = computeCrossBlockRefs(fn)
        // constMap survives block boundaries: a Const result is always the same value
        // regardless of which path reached the block.
        val constMap = mutableMapOf<IrRef, IrConst>()

        for (block in fn.blocks) {
            // slotLastStore and substMap are reset per block — cross-block slot
            // forwarding requires dominator analysis we leave to LLVM.
            val slotLastStore = mutableMapOf<IrSlot, IrRef>()
            val substMap      = mutableMapOf<IrRef, IrRef>()
            val cseMap        = mutableMapOf<Long, IrRef>()
            val newInsts      = mutableListOf<IrInst>()

            for (raw in block.instructions) {
                val inst  = applySubst(raw, substMap)
                val kept: IrInst? = when (inst) {

                    // ── Constants ────────────────────────────────────────────
                    is IrInst.Const -> {
                        constMap[inst.result] = inst.value
                        inst.takeIf { inst.result in usedRefs }
                    }

                    // ── Slot store: record last-written value ─────────────────
                    is IrInst.SlotStore -> {
                        slotLastStore[inst.slot] = resolve(inst.value, substMap)
                        inst  // always keep — side effect
                    }

                    // ── Slot load: forward from last store if available ───────
                    is IrInst.SlotLoad -> {
                        val stored = slotLastStore[inst.slot]
                        if (stored != null && inst.result !in crossBlockRefs) {
                            substMap[inst.result] = stored
                            null   // elided; result is forwarded via substMap
                        } else {
                            inst.takeIf { inst.result in usedRefs }
                        }
                    }

                    // ── Binary: fold if both operands are constant ────────────
                    is IrInst.Binary -> {
                        val folded = tryFoldBinary(inst, constMap)
                        if (folded != null) {
                            constMap[folded.result] = folded.value
                            folded.takeIf { folded.result in usedRefs }
                        } else {
                            val simplified = trySimplifyBinary(inst, constMap, substMap)
                            if (simplified != null) {
                                simplified
                            } else {
                                val cseKey = cseKeyBinary(inst.op, inst.left, inst.right)
                                val existing = cseMap[cseKey]
                                if (existing != null) {
                                    substMap[inst.result] = existing
                                    null
                                } else {
                                    if (inst.result in usedRefs) {
                                        cseMap[cseKey] = inst.result
                                        inst
                                    } else null
                                }
                            }
                        }
                    }

                    // ── Unary: fold if operand is constant ───────────────────
                    is IrInst.Unary -> {
                        val folded = tryFoldUnary(inst, constMap)
                        if (folded != null) {
                            constMap[folded.result] = folded.value
                            folded.takeIf { folded.result in usedRefs }
                        } else {
                            val cseKey = cseKeyUnary(inst.op, inst.operand)
                            val existing = cseMap[cseKey]
                            if (existing != null) {
                                substMap[inst.result] = existing
                                null
                            } else {
                                if (inst.result in usedRefs) {
                                    cseMap[cseKey] = inst.result
                                    inst
                                } else null
                            }
                        }
                    }

                    // ── StringConcat: fold if every part is a str constant ───
                    is IrInst.StringConcat -> {
                        val folded = tryFoldStringConcat(inst, constMap)
                        if (folded != null) {
                            constMap[folded.result] = folded.value
                            folded.takeIf { folded.result in usedRefs }
                        } else {
                            inst.takeIf { hasSideEffects(inst) || inst.result in usedRefs }
                        }
                    }

                    // ── ToString: fold if operand is a known constant ─────────
                    is IrInst.ToString -> {
                        val c = constMap[inst.value]
                        if (c != null) {
                            val strVal = when (c) {
                                is IrConst.Str   -> c.v
                                is IrConst.Int   -> "${c.v}"
                                is IrConst.Float -> "${c.v}"
                                is IrConst.Bool  -> "${c.v}"
                                is IrConst.Unit  -> "unit"
                                is IrConst.Byte0 -> "0"
                            }
                            val str    = IrConst.Str(strVal)
                            val folded = IrInst.Const(inst.result, IrType.Str, str, inst.span)
                            constMap[folded.result] = str
                            folded.takeIf { folded.result in usedRefs }
                        } else {
                            inst.takeIf { hasSideEffects(inst) || inst.result in usedRefs }
                        }
                    }

                    // ── Everything else: keep if side-effectful or result used ─
                    else -> inst.takeIf { hasSideEffects(inst) || inst.result in usedRefs }
                }

                if (kept != null) newInsts.add(kept)
            }

            block.instructions.clear()
            block.instructions.addAll(newInsts)
            // Propagate substitutions into the block's terminator
            block.terminator = block.terminator?.let { applySubstTerm(it, substMap) }
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Pass 5: Dead Store Elimination (DSE)
    //
    // Removes SlotAlloc + all SlotStores to slots that are never loaded from
    // anywhere in the function. After devirtualization, closure slots that were
    // only read by the now-eliminated Call become dead stores.
    // ─────────────────────────────────────────────────────────────────────────

    private fun deadStoreElimination(fn: IrFunction) {
        val loadedSlots = mutableSetOf<IrSlot>()
        for (block in fn.blocks) {
            for (inst in block.instructions) {
                if (inst is IrInst.SlotLoad) loadedSlots.add(inst.slot)
            }
        }

        val deadSlots = mutableSetOf<IrSlot>()
        for (block in fn.blocks) {
            for (inst in block.instructions) {
                if (inst is IrInst.SlotAlloc && inst.slot !in loadedSlots)
                    deadSlots.add(inst.slot)
            }
        }
        if (deadSlots.isEmpty()) return

        // Compute refs used by instructions OTHER than stores to dead slots
        val usedByLive = mutableSetOf<IrRef>()
        for (block in fn.blocks) {
            for (inst in block.instructions) {
                if (inst is IrInst.SlotStore && inst.slot in deadSlots) continue
                if (inst is IrInst.SlotAlloc && inst.slot in deadSlots) continue
                usedByLive.addAll(operandsOf(inst))
            }
            block.terminator?.let { usedByLive.addAll(operandsOf(it)) }
        }

        for (block in fn.blocks) {
            block.instructions.removeAll { inst ->
                when (inst) {
                    is IrInst.SlotAlloc -> inst.slot in deadSlots
                    is IrInst.SlotStore -> inst.slot in deadSlots
                    is IrInst.MakeClosure -> inst.result !in usedByLive &&
                            inst.captureRefs.isEmpty()
                    else -> false
                }
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Pass 6: Constant Branch Folding
    //
    // When a Branch condition is a known constant (from a Const instruction or
    // a comparison that folded), replace it with a Goto to the taken target.
    // The unreachable branch target becomes dead and is cleaned up by DBE.
    // ─────────────────────────────────────────────────────────────────────────

    private fun constantBranchFolding(fn: IrFunction) {
        val constMap = mutableMapOf<IrRef, IrConst>()
        for (block in fn.blocks) {
            for (inst in block.instructions) {
                if (inst is IrInst.Const) constMap[inst.result] = inst.value
            }
        }

        for (block in fn.blocks) {
            val br = block.terminator as? IrTerminator.Branch ?: continue
            val c = constMap[br.cond] ?: continue
            val isTruthy = when (c) {
                is IrConst.Bool -> c.v
                is IrConst.Int  -> c.v != 0L
                else -> continue
            }
            block.terminator = IrTerminator.Goto(
                if (isTruthy) br.thenBlock else br.elseBlock, br.span
            )
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Module-level: Unused Function Elimination
    //
    // Removes functions that have zero call sites (no CallDirect or MakeClosure
    // references to them). Runs after inlining + devirtualization which may
    // have removed all call sites for small inlined functions.
    // ─────────────────────────────────────────────────────────────────────────

    private fun eliminateUnusedFunctions(module: IrModule) {
        val calledFunctions = mutableSetOf<String>()
        calledFunctions.add("nova_main")
        calledFunctions.add("main")

        for (fn in module.functions) {
            for (block in fn.blocks) {
                for (inst in block.instructions) {
                    when (inst) {
                        is IrInst.CallDirect -> calledFunctions.add(inst.funcName)
                        is IrInst.MakeClosure -> calledFunctions.add(inst.funcName)
                        is IrInst.Spawn -> calledFunctions.add(inst.funcName)
                        else -> {}
                    }
                }
            }
        }

        // Keep functions referenced by spawn — Spawn stores funcName in its IR
        for (fn in module.functions) {
            if (fn.name.contains("_spawn_") || fn.name.contains("_worker")) {
                calledFunctions.add(fn.name)
            }
        }

        // Also keep trampoline functions (used by closure dispatch at runtime)
        for (fn in module.functions) {
            if (fn.name.endsWith("_tramp")) calledFunctions.add(fn.name)
        }

        module.functions.removeAll { fn ->
            fn.name !in calledFunctions &&
            !fn.name.startsWith("nova_rt_") &&
            fn.name != "nova_main" && fn.name != "main"
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Constant folding helpers
    // ─────────────────────────────────────────────────────────────────────────

    private fun tryFoldBinary(inst: IrInst.Binary, cm: Map<IrRef, IrConst>): IrInst.Const? {
        val l = cm[inst.left]  ?: return null
        val r = cm[inst.right] ?: return null
        val v: IrConst = when {
            l is IrConst.Int && r is IrConst.Int -> when (inst.op) {
                BinOp.ADD  -> IrConst.Int(l.v + r.v)
                BinOp.SUB  -> IrConst.Int(l.v - r.v)
                BinOp.MUL  -> IrConst.Int(l.v * r.v)
                BinOp.DIV  -> if (r.v != 0L) IrConst.Int(l.v / r.v)     else return null
                BinOp.MOD  -> if (r.v != 0L) IrConst.Int(l.v % r.v)     else return null
                BinOp.POW  -> {
                    var result = 1L; var base = l.v; var exp = r.v
                    if (exp < 0) return null
                    while (exp > 0) { if (exp and 1L == 1L) result *= base; base *= base; exp = exp shr 1 }
                    IrConst.Int(result)
                }
                BinOp.EQ   -> IrConst.Bool(l.v == r.v)
                BinOp.NE   -> IrConst.Bool(l.v != r.v)
                BinOp.LT   -> IrConst.Bool(l.v <  r.v)
                BinOp.GT   -> IrConst.Bool(l.v >  r.v)
                BinOp.LE   -> IrConst.Bool(l.v <= r.v)
                BinOp.GE   -> IrConst.Bool(l.v >= r.v)
                else       -> return null
            }
            l is IrConst.Float && r is IrConst.Float -> when (inst.op) {
                BinOp.ADD  -> IrConst.Float(l.v + r.v)
                BinOp.SUB  -> IrConst.Float(l.v - r.v)
                BinOp.MUL  -> IrConst.Float(l.v * r.v)
                BinOp.DIV  -> IrConst.Float(l.v / r.v)
                BinOp.EQ   -> IrConst.Bool(l.v == r.v)
                BinOp.NE   -> IrConst.Bool(l.v != r.v)
                BinOp.LT   -> IrConst.Bool(l.v <  r.v)
                BinOp.GT   -> IrConst.Bool(l.v >  r.v)
                BinOp.LE   -> IrConst.Bool(l.v <= r.v)
                BinOp.GE   -> IrConst.Bool(l.v >= r.v)
                else       -> return null
            }
            l is IrConst.Bool && r is IrConst.Bool -> when (inst.op) {
                BinOp.AND  -> IrConst.Bool(l.v && r.v)
                BinOp.OR   -> IrConst.Bool(l.v || r.v)
                BinOp.EQ   -> IrConst.Bool(l.v == r.v)
                BinOp.NE   -> IrConst.Bool(l.v != r.v)
                else       -> return null
            }
            l is IrConst.Str && r is IrConst.Str -> when (inst.op) {
                BinOp.CONCAT -> IrConst.Str(l.v + r.v)
                BinOp.EQ     -> IrConst.Bool(l.v == r.v)
                BinOp.NE     -> IrConst.Bool(l.v != r.v)
                else         -> return null
            }
            else -> return null
        }
        val outType = when (v) {
            is IrConst.Bool  -> IrType.Bool
            is IrConst.Float -> IrType.F64
            is IrConst.Str   -> IrType.Str
            else             -> inst.type
        }
        return IrInst.Const(inst.result, outType, v, inst.span)
    }

    private fun trySimplifyBinary(
        inst: IrInst.Binary,
        cm: Map<IrRef, IrConst>,
        substMap: MutableMap<IrRef, IrRef>
    ): IrInst? {
        val lc = cm[inst.left]
        val rc = cm[inst.right]
        if (lc == null && rc == null) return null

        // Algebraic identities and strength reduction for integer ops
        if (rc is IrConst.Int) {
            when (inst.op) {
                BinOp.ADD -> if (rc.v == 0L) { substMap[inst.result] = inst.left; return null }
                BinOp.SUB -> if (rc.v == 0L) { substMap[inst.result] = inst.left; return null }
                BinOp.MUL -> {
                    if (rc.v == 0L) return IrInst.Const(inst.result, inst.type, IrConst.Int(0), inst.span)
                    if (rc.v == 1L) { substMap[inst.result] = inst.left; return null }
                    if (rc.v == 2L) return IrInst.Binary(inst.result, inst.type, BinOp.ADD, inst.left, inst.left, inst.span)
                }
                BinOp.DIV -> {
                    if (rc.v == 1L) { substMap[inst.result] = inst.left; return null }
                }
                BinOp.MOD -> {
                    if (rc.v == 1L) return IrInst.Const(inst.result, inst.type, IrConst.Int(0), inst.span)
                }
                else -> {}
            }
        }
        if (lc is IrConst.Int) {
            when (inst.op) {
                BinOp.ADD -> if (lc.v == 0L) { substMap[inst.result] = inst.right; return null }
                BinOp.MUL -> {
                    if (lc.v == 0L) return IrInst.Const(inst.result, inst.type, IrConst.Int(0), inst.span)
                    if (lc.v == 1L) { substMap[inst.result] = inst.right; return null }
                    if (lc.v == 2L) return IrInst.Binary(inst.result, inst.type, BinOp.ADD, inst.right, inst.right, inst.span)
                }
                else -> {}
            }
        }
        // Float identities
        if (rc is IrConst.Float) {
            when (inst.op) {
                BinOp.ADD -> if (rc.v == 0.0) { substMap[inst.result] = inst.left; return null }
                BinOp.SUB -> if (rc.v == 0.0) { substMap[inst.result] = inst.left; return null }
                BinOp.MUL -> if (rc.v == 1.0) { substMap[inst.result] = inst.left; return null }
                BinOp.DIV -> if (rc.v == 1.0) { substMap[inst.result] = inst.left; return null }
                else -> {}
            }
        }
        if (lc is IrConst.Float) {
            when (inst.op) {
                BinOp.ADD -> if (lc.v == 0.0) { substMap[inst.result] = inst.right; return null }
                BinOp.MUL -> if (lc.v == 1.0) { substMap[inst.result] = inst.right; return null }
                else -> {}
            }
        }
        return null
    }

    private fun tryFoldUnary(inst: IrInst.Unary, cm: Map<IrRef, IrConst>): IrInst.Const? {
        val operand = cm[inst.operand] ?: return null
        val v: IrConst = when {
            inst.op == UnOp.NEG && operand is IrConst.Int   -> IrConst.Int(-operand.v)
            inst.op == UnOp.NEG && operand is IrConst.Float -> IrConst.Float(-operand.v)
            inst.op == UnOp.NOT && operand is IrConst.Bool  -> IrConst.Bool(!operand.v)
            else -> return null
        }
        return IrInst.Const(inst.result, inst.type, v, inst.span)
    }

    private fun cseKeyBinary(op: BinOp, left: IrRef, right: IrRef): Long {
        val l = left.id.toLong() and 0xFFFFF
        val r = right.id.toLong() and 0xFFFFF
        return (op.ordinal.toLong() shl 40) or (l shl 20) or r
    }

    private fun cseKeyUnary(op: UnOp, operand: IrRef): Long {
        return (1L shl 60) or (op.ordinal.toLong() shl 40) or (operand.id.toLong() and 0xFFFFF)
    }

    private fun tryFoldStringConcat(inst: IrInst.StringConcat, cm: Map<IrRef, IrConst>): IrInst.Const? {
        val parts = inst.parts.map { cm[it] as? IrConst.Str ?: return null }
        return IrInst.Const(inst.result, IrType.Str,
            IrConst.Str(parts.joinToString("") { it.v }), inst.span)
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Substitution helpers
    // ─────────────────────────────────────────────────────────────────────────

    // Follow substitution chain. Self-reference guard prevents infinite loop
    // in the impossible-but-defensive case of a cycle.
    private fun resolve(ref: IrRef, subst: Map<IrRef, IrRef>): IrRef {
        var cur = ref
        while (true) {
            val next = subst[cur] ?: return cur
            if (next == cur) return cur
            cur = next
        }
    }

    private fun applySubst(inst: IrInst, s: Map<IrRef, IrRef>): IrInst {
        if (s.isEmpty()) return inst
        fun r(ref: IrRef) = resolve(ref, s)
        return when (inst) {
            is IrInst.SlotStore    -> inst.copy(value   = r(inst.value))
            is IrInst.Binary       -> inst.copy(left    = r(inst.left),   right = r(inst.right))
            is IrInst.Unary        -> inst.copy(operand = r(inst.operand))
            is IrInst.Call         -> inst.copy(callee  = r(inst.callee), args  = inst.args.map(::r))
            is IrInst.CallDirect   -> inst.copy(args    = inst.args.map(::r))
            is IrInst.MakeClosure  -> inst.copy(captureRefs = inst.captureRefs.map(::r))
            is IrInst.MakeList     -> inst.copy(elems   = inst.elems.map(::r))
            is IrInst.ListAppend   -> inst.copy(list    = r(inst.list),   elem  = r(inst.elem))
            is IrInst.MakeTuple    -> inst.copy(elems   = inst.elems.map(::r))
            is IrInst.MakeRecord   -> inst.copy(fields  = inst.fields.map { it.first to r(it.second) })
            is IrInst.FieldGet     -> inst.copy(obj     = r(inst.obj))
            is IrInst.FieldSet     -> inst.copy(obj     = r(inst.obj),    value = r(inst.value))
            is IrInst.IndexGet     -> inst.copy(target  = r(inst.target), index = r(inst.index))
            is IrInst.IndexSet     -> inst.copy(target  = r(inst.target), index = r(inst.index), value = r(inst.value))
            is IrInst.StringConcat -> inst.copy(parts   = inst.parts.map(::r))
            is IrInst.ToString     -> inst.copy(value   = r(inst.value))
            is IrInst.Copy         -> inst.copy(source  = r(inst.source))
            is IrInst.IsError      -> inst.copy(value   = r(inst.value))
            is IrInst.UnwrapError  -> inst.copy(value   = r(inst.value))
            is IrInst.ChannelSend  -> inst.copy(channel = r(inst.channel), value = r(inst.value))
            is IrInst.ChannelReceive -> inst.copy(channel = r(inst.channel))
            is IrInst.ChannelSelect -> inst.copy(channels = inst.channels.map(::r))
            is IrInst.ChannelClose -> inst.copy(channel = r(inst.channel))
            is IrInst.ChannelRecvTimeout -> inst.copy(channel = r(inst.channel), timeoutMs = r(inst.timeoutMs))
            is IrInst.Spawn        -> inst.copy(args    = inst.args.map(::r))
            is IrInst.MakeDict     -> inst.copy(entries = inst.entries.map { r(it.first) to r(it.second) })
            else                   -> inst
        }
    }

    private fun applySubstTerm(term: IrTerminator, s: Map<IrRef, IrRef>): IrTerminator {
        if (s.isEmpty()) return term
        fun r(ref: IrRef) = resolve(ref, s)
        return when (term) {
            is IrTerminator.Return -> term.copy(value = r(term.value))
            is IrTerminator.Branch -> term.copy(cond  = r(term.cond))
            else                   -> term
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Use analysis & side-effect classification
    // ─────────────────────────────────────────────────────────────────────────

    private fun hasSideEffects(inst: IrInst): Boolean = when (inst) {
        is IrInst.SlotAlloc,
        is IrInst.SlotStore     -> true
        is IrInst.Call,
        is IrInst.CallDirect    -> true
        is IrInst.ListAppend,
        is IrInst.FieldSet,
        is IrInst.IndexSet      -> true
        is IrInst.ChannelCreate,
        is IrInst.ChannelSend,
        is IrInst.ChannelReceive,
        is IrInst.ChannelSelect,
        is IrInst.ChannelClose,
        is IrInst.ChannelRecvTimeout -> true
        is IrInst.Spawn         -> true
        // Error flag operations: read and/or write the thread-local error state.
        is IrInst.IsError,
        is IrInst.RaiseError,
        is IrInst.LoadErrorMsg  -> true
        else                    -> false
    }

    private fun computeUsedRefs(fn: IrFunction): Set<IrRef> {
        val used = mutableSetOf<IrRef>()
        for (block in fn.blocks) {
            for (inst in block.instructions) used.addAll(operandsOf(inst))
            block.terminator?.let { used.addAll(operandsOf(it)) }
        }
        return used
    }

    private fun computeCrossBlockRefs(fn: IrFunction): Set<IrRef> {
        val definedIn = mutableMapOf<IrRef, BlockId>()
        for (block in fn.blocks) {
            for (inst in block.instructions) definedIn[inst.result] = block.id
        }
        val cross = mutableSetOf<IrRef>()
        for (block in fn.blocks) {
            for (inst in block.instructions) {
                for (op in operandsOf(inst)) {
                    val defBlock = definedIn[op]
                    if (defBlock != null && defBlock != block.id) cross.add(op)
                }
            }
            block.terminator?.let { term ->
                for (op in operandsOf(term)) {
                    val defBlock = definedIn[op]
                    if (defBlock != null && defBlock != block.id) cross.add(op)
                }
            }
        }
        return cross
    }

    private fun operandsOf(inst: IrInst): List<IrRef> = when (inst) {
        is IrInst.SlotStore      -> listOf(inst.value)
        is IrInst.Binary         -> listOf(inst.left, inst.right)
        is IrInst.Unary          -> listOf(inst.operand)
        is IrInst.Call           -> listOf(inst.callee) + inst.args
        is IrInst.CallDirect     -> inst.args
        is IrInst.MakeClosure    -> inst.captureRefs
        is IrInst.MakeList       -> inst.elems
        is IrInst.ListAppend     -> listOf(inst.list, inst.elem)
        is IrInst.MakeTuple      -> inst.elems
        is IrInst.MakeRecord     -> inst.fields.map { it.second }
        is IrInst.FieldGet       -> listOf(inst.obj)
        is IrInst.FieldSet       -> listOf(inst.obj, inst.value)
        is IrInst.IndexGet       -> listOf(inst.target, inst.index)
        is IrInst.IndexSet       -> listOf(inst.target, inst.index, inst.value)
        is IrInst.StringConcat   -> inst.parts
        is IrInst.ToString       -> listOf(inst.value)
        is IrInst.Copy           -> listOf(inst.source)
        is IrInst.IsError        -> listOf(inst.value)
        is IrInst.UnwrapError    -> listOf(inst.value)
        is IrInst.ChannelSend    -> listOf(inst.channel, inst.value)
        is IrInst.ChannelReceive -> listOf(inst.channel)
        is IrInst.ChannelSelect  -> inst.channels
        is IrInst.ChannelClose   -> listOf(inst.channel)
        is IrInst.ChannelRecvTimeout -> listOf(inst.channel, inst.timeoutMs)
        is IrInst.Spawn          -> inst.args
        is IrInst.MakeDict       -> inst.entries.flatMap { listOf(it.first, it.second) }
        else                     -> emptyList()
    }

    private fun operandsOf(term: IrTerminator): List<IrRef> = when (term) {
        is IrTerminator.Return -> listOf(term.value)
        is IrTerminator.Branch -> listOf(term.cond)
        else                   -> emptyList()
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Pass 5: Tail Call Optimization (TCO)
    //
    // Converts self-recursive tail calls into loops. A tail call is a CallDirect
    // to the same function where the result is immediately returned. The call is
    // replaced with stores to the param slots + a branch back to the loop header.
    // ─────────────────────────────────────────────────────────────────────────

    private fun tailCallOptimize(fn: IrFunction) {
        if (fn.blocks.isEmpty() || fn.params.isEmpty()) return

        data class TailCall(val blockId: BlockId, val callInst: IrInst.CallDirect)
        val tailCalls = mutableListOf<TailCall>()

        for (block in fn.blocks) {
            val term = block.terminator as? IrTerminator.Return ?: continue
            val lastCall = block.instructions.lastOrNull {
                it is IrInst.CallDirect && it.funcName == fn.name
            } as? IrInst.CallDirect ?: continue
            if (term.value != lastCall.result) continue
            if (lastCall.args.size != fn.params.size) continue
            tailCalls.add(TailCall(block.id, lastCall))
        }

        if (tailCalls.isEmpty()) return

        val entry = fn.blocks[0]
        val paramNames = fn.params.map { it.first }.toSet()

        // Find end of prologue: SlotAllocs + param stores (value.id < 0)
        var prologueEnd = 0
        while (prologueEnd < entry.instructions.size) {
            val inst = entry.instructions[prologueEnd]
            when {
                inst is IrInst.SlotAlloc -> prologueEnd++
                inst is IrInst.SlotStore && inst.value.id < 0 && inst.slot.name in paramNames -> prologueEnd++
                else -> break
            }
        }

        // Split entry: keep prologue, move body to new tco_loop block
        val bodyInsts = entry.instructions.subList(prologueEnd, entry.instructions.size).toMutableList()
        val maxBlockId = fn.blocks.maxOf { it.id.id }
        val tcoId = BlockId(maxBlockId + 1)
        val tcoBlock = IrBlock(tcoId, "tco_loop", bodyInsts, entry.terminator)

        val prologue = entry.instructions.subList(0, prologueEnd).toMutableList()
        entry.instructions.clear()
        entry.instructions.addAll(prologue)
        entry.terminator = IrTerminator.Goto(tcoId, fn.span)
        fn.blocks.add(1, tcoBlock)

        // Fresh ref counter
        var maxRefId = 0
        for (b in fn.blocks) for (i in b.instructions) if (i.result.id > maxRefId) maxRefId = i.result.id
        var nextId = maxRefId + 1

        for (tc in tailCalls) {
            val block = fn.blocks.find { it.id == tc.blockId } ?: continue
            val callIdx = block.instructions.indexOf(tc.callInst)
            if (callIdx < 0) continue
            val callArgs = tc.callInst.args.toList()
            // Remove call and anything after it
            while (block.instructions.size > callIdx) block.instructions.removeAt(callIdx)
            // Store new args into param slots
            for (i in fn.params.indices) {
                block.instructions.add(IrInst.SlotStore(
                    IrRef(nextId++), IrType.Unit,
                    IrSlot(fn.params[i].first), callArgs[i], fn.span
                ))
            }
            block.terminator = IrTerminator.Goto(tcoId, fn.span)
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Pass 6: Loop-Invariant Code Motion (LICM)
    //
    // Detects natural loops (header block with a backedge from a body block)
    // and hoists SlotLoad instructions for slots that are never written inside
    // the loop body. The hoisted load is placed in the preheader block (the
    // block that jumps to the loop header), and all uses in the loop are
    // rewritten via substitution.
    // ─────────────────────────────────────────────────────────────────────────

    private fun loopInvariantCodeMotion(fn: IrFunction) {
        val blockMap = fn.blocks.associateBy { it.id }
        var maxRefId = 0
        for (b in fn.blocks) for (i in b.instructions) if (i.result.id > maxRefId) maxRefId = i.result.id
        var nextId = maxRefId + 1
        fun freshRef() = IrRef(nextId++)

        // Build predecessor map
        val predMap = mutableMapOf<BlockId, MutableSet<BlockId>>()
        for (b in fn.blocks) {
            val succs = when (val t = b.terminator) {
                is IrTerminator.Goto -> listOf(t.target)
                is IrTerminator.Branch -> listOf(t.thenBlock, t.elseBlock)
                else -> emptyList()
            }
            for (s in succs) predMap.getOrPut(s) { mutableSetOf() }.add(b.id)
        }

        // Natural loop body: reverse reachability from backedge source, stopping at header
        fun computeLoopBody(headerId: BlockId, backedgeSrc: BlockId): Set<BlockId> {
            val body = mutableSetOf(headerId)
            val worklist = ArrayDeque<BlockId>()
            if (backedgeSrc != headerId) {
                body.add(backedgeSrc)
                worklist.add(backedgeSrc)
            }
            while (worklist.isNotEmpty()) {
                val n = worklist.removeFirst()
                for (pred in predMap[n] ?: emptySet()) {
                    if (pred !in body) {
                        body.add(pred)
                        worklist.add(pred)
                    }
                }
            }
            return body
        }

        data class Loop(val preheader: IrBlock, val header: IrBlock, val bodyBlocks: Set<BlockId>)
        val loops = mutableListOf<Loop>()
        val entryId = fn.blocks.firstOrNull()?.id

        for (block in fn.blocks) {
            val term = block.terminator
            val targets = when (term) {
                is IrTerminator.Goto -> listOf(term.target)
                is IrTerminator.Branch -> listOf(term.thenBlock, term.elseBlock)
                else -> emptyList()
            }
            for (targetId in targets) {
                val targetIdx = fn.blocks.indexOfFirst { it.id == targetId }
                val blockIdx = fn.blocks.indexOfFirst { it.id == block.id }
                if (targetIdx < 0 || blockIdx < 0 || targetIdx >= blockIdx) continue

                val header = fn.blocks[targetIdx]
                val bodyBlockIds = computeLoopBody(header.id, block.id)

                // Skip if the body includes the entry block (false loop / whole function)
                if (entryId != null && entryId in bodyBlockIds && entryId != header.id) continue

                var preheader: IrBlock? = null
                for (ph in fn.blocks) {
                    if (ph.id in bodyBlockIds) continue
                    val phTargets = when (val t = ph.terminator) {
                        is IrTerminator.Goto -> listOf(t.target)
                        is IrTerminator.Branch -> listOf(t.thenBlock, t.elseBlock)
                        else -> emptyList()
                    }
                    if (header.id in phTargets) {
                        preheader = ph
                    }
                }
                if (preheader != null) {
                    loops.add(Loop(preheader, header, bodyBlockIds))
                }
            }
        }

        // For each loop, find invariant SlotLoads and pure computations, hoist them
        for (loop in loops) {
            // Collect all slots written inside the loop
            val writtenSlots = mutableSetOf<String>()
            for (blockId in loop.bodyBlocks) {
                val block = blockMap[blockId] ?: continue
                for (inst in block.instructions) {
                    if (inst is IrInst.SlotStore) writtenSlots.add(inst.slot.name)
                }
            }

            // Collect all refs DEFINED inside the loop
            val loopDefs = mutableSetOf<IrRef>()
            for (blockId in loop.bodyBlocks) {
                val block = blockMap[blockId] ?: continue
                for (inst in block.instructions) loopDefs.add(inst.result)
            }

            // Find SlotLoads in the loop that read from unwritten slots
            val hoistable = mutableListOf<Pair<BlockId, IrInst.SlotLoad>>()
            val seenSlots = mutableSetOf<String>()
            for (blockId in loop.bodyBlocks) {
                val block = blockMap[blockId] ?: continue
                for (inst in block.instructions) {
                    if (inst is IrInst.SlotLoad && inst.slot.name !in writtenSlots) {
                        if (inst.slot.name !in seenSlots) {
                            hoistable.add(blockId to inst)
                            seenSlots.add(inst.slot.name)
                        }
                    }
                }
            }

            val substMap = mutableMapOf<IrRef, IrRef>()
            val hoistedInsts = mutableListOf<IrInst>()

            for ((_, loadInst) in hoistable) {
                val newRef = freshRef()
                hoistedInsts.add(IrInst.SlotLoad(newRef, loadInst.type, loadInst.slot, loadInst.span))
                substMap[loadInst.result] = newRef

                // Find all loads of the same slot in the loop and redirect them
                for (bodyBlockId in loop.bodyBlocks) {
                    val bodyBlock = blockMap[bodyBlockId] ?: continue
                    for (inst in bodyBlock.instructions) {
                        if (inst is IrInst.SlotLoad && inst.slot == loadInst.slot && inst.result != loadInst.result) {
                            substMap[inst.result] = newRef
                        }
                    }
                }
            }

            // Also hoist pure Binary/Unary whose operands are all loop-invariant
            // (i.e., defined outside the loop or already hoisted)
            val invariantRefs = mutableSetOf<IrRef>()
            for (blockId in loop.bodyBlocks) {
                val block = blockMap[blockId] ?: continue
                for (inst in block.instructions) {
                    if (inst is IrInst.SlotLoad && inst.result in substMap)
                        invariantRefs.add(inst.result)
                }
            }

            fun isInvariant(r: IrRef): Boolean {
                if (r !in loopDefs) return true
                if (r in substMap) return true
                if (r in invariantRefs) return true
                return false
            }

            for (blockId in loop.bodyBlocks) {
                val block = blockMap[blockId] ?: continue
                for (inst in block.instructions) {
                    val canHoist = when (inst) {
                        is IrInst.Binary -> !hasSideEffects(inst) && isInvariant(inst.left) && isInvariant(inst.right)
                        is IrInst.Unary -> !hasSideEffects(inst) && isInvariant(inst.operand)
                        else -> false
                    }
                    if (canHoist) {
                        val newRef = freshRef()
                        val hoisted = when (inst) {
                            is IrInst.Binary -> IrInst.Binary(newRef, inst.type, inst.op, inst.left, inst.right, inst.span)
                            is IrInst.Unary -> IrInst.Unary(newRef, inst.type, inst.op, inst.operand, inst.span)
                            else -> continue
                        }
                        hoistedInsts.add(applySubst(hoisted, substMap))
                        substMap[inst.result] = newRef
                        invariantRefs.add(inst.result)
                    }
                }
            }

            if (hoistedInsts.isEmpty()) continue

            // Insert hoisted instructions at end of preheader (before terminator)
            loop.preheader.instructions.addAll(hoistedInsts)

            // Remove hoisted instructions from loop blocks and apply substitutions
            for (bodyBlockId in loop.bodyBlocks) {
                val block = blockMap[bodyBlockId] ?: continue
                val newInsts = mutableListOf<IrInst>()
                for (inst in block.instructions) {
                    if (inst.result in substMap) continue
                    newInsts.add(applySubst(inst, substMap))
                }
                block.instructions.clear()
                block.instructions.addAll(newInsts)
                block.terminator = block.terminator?.let { applySubstTerm(it, substMap) }
            }
        }
    }

    // ─────────────────────────────────────────────────────────────────────────
    // Deep copy — optimizer works on a fresh copy, never mutates the original
    // ─────────────────────────────────────────────────────────────────────────

    private fun deepCopy(fn: IrFunction): IrFunction {
        val copy = IrFunction(fn.name, fn.params, fn.returnType,
            captureCount = fn.captureCount, span = fn.span)
        for (block in fn.blocks) {
            copy.blocks.add(IrBlock(block.id, block.label,
                block.instructions.toMutableList(), block.terminator))
        }
        return copy
    }
}
