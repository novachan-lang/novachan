package nova.ir

// ── Escape Analysis (Value Types / Stack Allocation) ─────────────────────────
//
// Determines which MakeRecord results can be stack-allocated (alloca) instead
// of heap-allocated (malloc + nova_mem_track). A value "escapes" if it could
// outlive the creating function's stack frame.
//
// Escape sources:
//   - Return value (caller needs it after callee returns)
//   - Call argument (callee might store it)
//   - Closure capture (closure outlives the creating scope)
//   - Collection element (list/dict/tuple can be returned or passed)
//   - Channel send (receiver is a different process/thread)
//   - Spawn argument (different thread)
//   - Global slot store (outlives function)
//   - IndexSet target value (stored into collection)
//   - FieldSet on a different record (transitive escape)
//
// Non-escaping uses:
//   - FieldGet (read-only access to the struct)
//   - FieldSet (mutation of the struct's own fields)
//   - SlotStore to a local slot (stays in function scope)
//   - Binary/Unary (comparison etc.)
//   - ToString/Copy (produces new value, doesn't store original)
//
// Algorithm: conservative per-function analysis.
//   1. Collect all MakeRecord results
//   2. Walk all instructions, mark any MakeRecord result used in escape position
//   3. Propagate: if a slot stores only MakeRecord results, and that slot is
//      used in escape position, mark those MakeRecord results as escaping too
//   4. Result: set of IrRef that are safe to stack-allocate

class IrEscapeAnalysis {

    data class EscapeResult(
        val stackAllocatable: Set<IrRef>,
        val heapRequired: Set<IrRef>,
        val nonEscapingLists: Set<IrRef> = emptySet()
    )

    fun analyze(module: IrModule): Map<String, EscapeResult> {
        val results = mutableMapOf<String, EscapeResult>()
        for (fn in module.functions) {
            results[fn.name] = analyzeFunction(fn)
        }
        return results
    }

    private val listCreateFuncs = setOf(
        "nova_rt_list_create", "nova_rt_list_create_filled"
    )

    private fun analyzeFunction(fn: IrFunction): EscapeResult {
        val allInsts = fn.blocks.flatMap { it.instructions }

        val recordRefs = allInsts
            .filterIsInstance<IrInst.MakeRecord>()
            .map { it.result }
            .toSet()

        val nonEscapingLists = analyzeListEscape(fn, allInsts)

        if (recordRefs.isEmpty()) return EscapeResult(emptySet(), emptySet(), nonEscapingLists)

        val escaped = mutableSetOf<IrRef>()

        // Build a map: slot name → set of MakeRecord refs stored into it
        val slotSources = mutableMapOf<String, MutableSet<IrRef>>()
        // Track which slots are used in escape positions
        val escapedSlots = mutableSetOf<String>()

        for (block in fn.blocks) {
            for (inst in block.instructions) {
                markEscapes(inst, recordRefs, escaped, slotSources)
            }
            // Check terminators
            val term = block.terminator
            if (term is IrTerminator.Return && term.value in recordRefs) {
                escaped.add(term.value)
            }
        }

        // Second pass: check if slots containing MakeRecord refs are themselves
        // used in escape positions. Walk all instructions again looking for
        // SlotLoad results that escape.
        val slotLoadMap = mutableMapOf<IrRef, String>() // loadResult → slotName
        for (inst in allInsts) {
            if (inst is IrInst.SlotLoad) {
                slotLoadMap[inst.result] = inst.slot.name
            }
        }

        // Any SlotLoad result used in escape position → the slot escapes
        for (inst in allInsts) {
            val escaping = getEscapingRefs(inst)
            for (ref in escaping) {
                val slotName = slotLoadMap[ref]
                if (slotName != null) escapedSlots.add(slotName)
            }
        }
        // Check terminators for slot loads
        for (block in fn.blocks) {
            val term = block.terminator
            if (term is IrTerminator.Return) {
                val slotName = slotLoadMap[term.value]
                if (slotName != null) escapedSlots.add(slotName)
            }
        }

        // Propagate: if a slot escapes, all MakeRecord refs stored into it escape
        for (slotName in escapedSlots) {
            val sources = slotSources[slotName]
            if (sources != null) escaped.addAll(sources)
        }

        val stackAllocatable = recordRefs - escaped
        return EscapeResult(stackAllocatable, escaped, nonEscapingLists)
    }

    private fun markEscapes(
        inst: IrInst,
        recordRefs: Set<IrRef>,
        escaped: MutableSet<IrRef>,
        slotSources: MutableMap<String, MutableSet<IrRef>>
    ) {
        when (inst) {
            // SlotStore to global → escapes
            is IrInst.SlotStore -> {
                if (inst.slot.isGlobal && inst.value in recordRefs) {
                    escaped.add(inst.value)
                } else if (!inst.slot.isGlobal && inst.value in recordRefs) {
                    slotSources.getOrPut(inst.slot.name) { mutableSetOf() }.add(inst.value)
                }
            }
            // Call args → escape (callee may store them)
            is IrInst.Call -> {
                for (arg in inst.args) {
                    if (arg in recordRefs) escaped.add(arg)
                }
                if (inst.callee in recordRefs) escaped.add(inst.callee)
            }
            is IrInst.CallDirect -> {
                for (arg in inst.args) {
                    if (arg in recordRefs) escaped.add(arg)
                }
            }
            // Closure capture → escapes
            is IrInst.MakeClosure -> {
                for (cap in inst.captureRefs) {
                    if (cap in recordRefs) escaped.add(cap)
                }
            }
            // Collection element → escapes
            is IrInst.MakeList -> {
                for (elem in inst.elems) {
                    if (elem in recordRefs) escaped.add(elem)
                }
            }
            is IrInst.MakeTuple -> {
                for (elem in inst.elems) {
                    if (elem in recordRefs) escaped.add(elem)
                }
            }
            is IrInst.MakeDict -> {
                for ((k, v) in inst.entries) {
                    if (k in recordRefs) escaped.add(k)
                    if (v in recordRefs) escaped.add(v)
                }
            }
            is IrInst.ListAppend -> {
                if (inst.elem in recordRefs) escaped.add(inst.elem)
            }
            is IrInst.IndexSet -> {
                if (inst.value in recordRefs) escaped.add(inst.value)
            }
            // Channel send → escapes (crosses thread boundary)
            is IrInst.ChannelSend -> {
                if (inst.value in recordRefs) escaped.add(inst.value)
            }
            // Spawn arg → escapes
            is IrInst.Spawn -> {
                for (arg in inst.args) {
                    if (arg in recordRefs) escaped.add(arg)
                }
            }
            // FieldGet, FieldSet on the record itself → does NOT escape
            // (FieldSet stores INTO the record, doesn't make the record escape)
            is IrInst.FieldSet -> {
                // The value being stored INTO a record doesn't make the record escape,
                // but if the record ref itself is used as the VALUE of a FieldSet
                // on a DIFFERENT record, that's covered by slotSource tracking
                if (inst.value in recordRefs) {
                    // Storing a record as a field of another object → escapes
                    escaped.add(inst.value)
                }
            }
            // These don't cause escape
            is IrInst.FieldGet -> { /* read-only, non-escaping */ }
            is IrInst.Const -> {}
            is IrInst.SlotAlloc -> {}
            is IrInst.SlotLoad -> {}
            is IrInst.Binary -> {}
            is IrInst.Unary -> {}
            is IrInst.MakeRecord -> {}
            is IrInst.StringConcat -> {}
            is IrInst.ToString -> {}
            is IrInst.Copy -> {}
            is IrInst.IsError -> {}
            is IrInst.UnwrapError -> {}
            is IrInst.LoadErrorMsg -> {}
            is IrInst.RaiseError -> {}
            is IrInst.IndexGet -> {}
            is IrInst.ChannelCreate -> {}
            is IrInst.ChannelReceive -> {}
            is IrInst.ChannelSelect -> {}
            is IrInst.ChannelClose -> {}
            is IrInst.ChannelRecvTimeout -> {}
        }
    }

    private fun analyzeListEscape(fn: IrFunction, allInsts: List<IrInst>): Set<IrRef> {
        val listRefs = allInsts
            .filterIsInstance<IrInst.CallDirect>()
            .filter { it.funcName in listCreateFuncs }
            .map { it.result }
            .toSet()
        if (listRefs.isEmpty()) return emptySet()

        val escaped = mutableSetOf<IrRef>()

        // Track which slots hold list refs
        val slotSources = mutableMapOf<String, MutableSet<IrRef>>()
        val escapedSlots = mutableSetOf<String>()

        // Build slot-to-ref and ref-to-slot mappings
        val slotLoadMap = mutableMapOf<IrRef, String>()
        for (inst in allInsts) {
            if (inst is IrInst.SlotLoad) slotLoadMap[inst.result] = inst.slot.name
            if (inst is IrInst.SlotStore && !inst.slot.isGlobal && inst.value in listRefs) {
                slotSources.getOrPut(inst.slot.name) { mutableSetOf() }.add(inst.value)
            }
            if (inst is IrInst.SlotStore && inst.slot.isGlobal && inst.value in listRefs) {
                escaped.add(inst.value)
            }
        }

        // Collect all refs that might be the list (direct ref or loaded from slot)
        val listSlots = slotSources.keys
        val allListRefs = listRefs.toMutableSet()
        for (inst in allInsts) {
            if (inst is IrInst.SlotLoad && inst.slot.name in listSlots) {
                allListRefs.add(inst.result)
            }
        }

        // Check each instruction for escape
        for (block in fn.blocks) {
            for (inst in block.instructions) {
                when (inst) {
                    is IrInst.CallDirect -> {
                        if (inst.funcName !in listCreateFuncs) {
                            for (arg in inst.args) {
                                if (arg in allListRefs) {
                                    val slotName = slotLoadMap[arg]
                                    if (slotName != null) escapedSlots.add(slotName)
                                    if (arg in listRefs) escaped.add(arg)
                                }
                            }
                        }
                    }
                    is IrInst.Call -> {
                        for (arg in inst.args) {
                            if (arg in allListRefs) {
                                val slotName = slotLoadMap[arg]
                                if (slotName != null) escapedSlots.add(slotName)
                                if (arg in listRefs) escaped.add(arg)
                            }
                        }
                    }
                    is IrInst.MakeClosure -> {
                        for (cap in inst.captureRefs)
                            if (cap in allListRefs) {
                                val slotName = slotLoadMap[cap]
                                if (slotName != null) escapedSlots.add(slotName)
                                if (cap in listRefs) escaped.add(cap)
                            }
                    }
                    is IrInst.ChannelSend -> {
                        if (inst.value in allListRefs) {
                            val slotName = slotLoadMap[inst.value]
                            if (slotName != null) escapedSlots.add(slotName)
                            if (inst.value in listRefs) escaped.add(inst.value)
                        }
                    }
                    is IrInst.Spawn -> {
                        for (arg in inst.args)
                            if (arg in allListRefs) {
                                val slotName = slotLoadMap[arg]
                                if (slotName != null) escapedSlots.add(slotName)
                                if (arg in listRefs) escaped.add(arg)
                            }
                    }
                    is IrInst.ListAppend -> {
                        if (inst.elem in allListRefs) {
                            val slotName = slotLoadMap[inst.elem]
                            if (slotName != null) escapedSlots.add(slotName)
                            if (inst.elem in listRefs) escaped.add(inst.elem)
                        }
                    }
                    is IrInst.IndexSet -> {
                        if (inst.value in allListRefs) {
                            val slotName = slotLoadMap[inst.value]
                            if (slotName != null) escapedSlots.add(slotName)
                            if (inst.value in listRefs) escaped.add(inst.value)
                        }
                    }
                    is IrInst.MakeList -> {
                        for (elem in inst.elems)
                            if (elem in allListRefs) {
                                val slotName = slotLoadMap[elem]
                                if (slotName != null) escapedSlots.add(slotName)
                                if (elem in listRefs) escaped.add(elem)
                            }
                    }
                    is IrInst.MakeDict -> {
                        for ((k, v) in inst.entries) {
                            for (ref in listOf(k, v))
                                if (ref in allListRefs) {
                                    val slotName = slotLoadMap[ref]
                                    if (slotName != null) escapedSlots.add(slotName)
                                    if (ref in listRefs) escaped.add(ref)
                                }
                        }
                    }
                    is IrInst.FieldSet -> {
                        if (inst.value in allListRefs) {
                            val slotName = slotLoadMap[inst.value]
                            if (slotName != null) escapedSlots.add(slotName)
                            if (inst.value in listRefs) escaped.add(inst.value)
                        }
                    }
                    else -> {}
                }
            }
            // Return value
            val term = block.terminator
            if (term is IrTerminator.Return) {
                if (term.value in allListRefs) {
                    val slotName = slotLoadMap[term.value]
                    if (slotName != null) escapedSlots.add(slotName)
                    if (term.value in listRefs) escaped.add(term.value)
                }
            }
        }

        // Propagate escaped slots
        for (slotName in escapedSlots) {
            val sources = slotSources[slotName]
            if (sources != null) escaped.addAll(sources)
        }

        return listRefs - escaped
    }

    private fun getEscapingRefs(inst: IrInst): List<IrRef> = when (inst) {
        is IrInst.Call -> inst.args + listOf(inst.callee)
        is IrInst.CallDirect -> inst.args
        is IrInst.MakeClosure -> inst.captureRefs
        is IrInst.MakeList -> inst.elems
        is IrInst.MakeTuple -> inst.elems
        is IrInst.MakeDict -> inst.entries.flatMap { listOf(it.first, it.second) }
        is IrInst.ListAppend -> listOf(inst.elem)
        is IrInst.IndexSet -> listOf(inst.value)
        is IrInst.ChannelSend -> listOf(inst.value)
        is IrInst.Spawn -> inst.args
        is IrInst.FieldSet -> listOf(inst.value)
        else -> emptyList()
    }
}
