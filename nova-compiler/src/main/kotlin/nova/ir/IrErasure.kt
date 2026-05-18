package nova.ir

// ── Abstraction Erasure (Step 2.3 / Gate 4) ──────────────────────────────────
//
// Converts high-level channel/spawn IR ops to low-level slot ops for programs
// that use concurrency abstractly but run as a single process.
//
// Classification:
//   LOCAL channel  — created and consumed within the same function, never passed
//                    to any call, closure, collection, or return. Erased to
//                    SlotAlloc/Store/Load.
//   NON-LOCAL      — escapes into a call arg, closure capture, collection element,
//                    return value, or the function spawns processes.
//                    Left unchanged (complex analysis deferred to Step 2.4).
//
// Pipeline: optimize → erase → optimize
//   The first optimize collapses SlotLoad chains so every channel ref in
//   ChannelSend/Receive points directly to its ChannelCreate result. Without this
//   step, channel refs are slot-loaded copies that don't match `allChannelRefs`.
//   The second optimize runs slot coalescing on the newly-created slots so the
//   store→load chain collapses to direct value assignment — zero overhead.
//
// Gate 4 guarantee:
//   Programs 1-5, 7, 9 contain no channel or spawn ops at all. They pass through
//   this pass without modification; optimizer produces C-equivalent IR.

class IrErasure {

    fun erase(module: IrModule): IrModule {
        // First optimize: normalize channel refs so ChannelSend/Receive.channel
        // points directly to the ChannelCreate result (slot coalescing collapses
        // intermediate SlotLoad copies).
        val optimized = IrOptimizer().optimize(module)
        val erased = IrModule(optimized.name)
        erased.structs.addAll(optimized.structs)
        erased.externFunctions.addAll(optimized.externFunctions)
        for (fn in optimized.functions) {
            erased.functions.add(eraseFunction(fn))
        }
        // Second optimize: coalesce the new slot ops created during erasure.
        return IrOptimizer().optimize(erased)
    }

    // ── Function-level analysis and dispatch ──────────────────────────────────

    private fun eraseFunction(fn: IrFunction): IrFunction {
        val allInsts = fn.blocks.flatMap { it.instructions }

        // Gate 4 fast path: no channel ops at all — pass through unchanged
        val channelCreates = allInsts.filterIsInstance<IrInst.ChannelCreate>()
        if (channelCreates.isEmpty()) return fn

        // Conservative: if the function spawns, channel refs may cross process
        // boundaries. Full escape analysis is Step 2.4.
        if (allInsts.any { it is IrInst.Spawn }) return fn

        // After the first optimizer pass, all channel refs in ChannelSend/Receive
        // are normalized to their ChannelCreate results. Collect all escape paths.
        val allChannelRefs = channelCreates.map { it.result }.toSet()
        val escapedRefs = buildSet<IrRef> {
            // Passed as call arguments (dynamic or static dispatch)
            allInsts.filterIsInstance<IrInst.Call>()
                .forEach { addAll(it.args.filter { a -> a in allChannelRefs }) }
            allInsts.filterIsInstance<IrInst.CallDirect>()
                .forEach { addAll(it.args.filter { a -> a in allChannelRefs }) }
            // Captured by a closure — the closure may be called elsewhere
            allInsts.filterIsInstance<IrInst.MakeClosure>()
                .forEach { addAll(it.captureRefs.filter { a -> a in allChannelRefs }) }
            // Embedded in a collection — opaque to erasure
            allInsts.filterIsInstance<IrInst.MakeTuple>()
                .forEach { addAll(it.elems.filter { a -> a in allChannelRefs }) }
            allInsts.filterIsInstance<IrInst.MakeList>()
                .forEach { addAll(it.elems.filter { a -> a in allChannelRefs }) }
            allInsts.filterIsInstance<IrInst.MakeRecord>()
                .forEach { addAll(it.fields.map { f -> f.second }.filter { a -> a in allChannelRefs }) }
            // Returned from the function — caller owns the channel
            for (block in fn.blocks) {
                val term = block.terminator
                if (term is IrTerminator.Return && term.value in allChannelRefs) add(term.value)
            }
        }

        val erasable = allChannelRefs - escapedRefs
        if (erasable.isEmpty()) return fn

        // Each erasable channel gets its own named slot (ref IDs are unique per fn)
        val channelToSlot: Map<IrRef, IrSlot> =
            erasable.associateWith { ref -> IrSlot("__ch${ref.id}") }

        return rewriteFunction(fn, channelToSlot)
    }

    // ── Block-level rewriting ─────────────────────────────────────────────────

    private fun rewriteFunction(fn: IrFunction, channelToSlot: Map<IrRef, IrSlot>): IrFunction {
        val out = IrFunction(
            name         = fn.name,
            params       = fn.params,
            returnType   = fn.returnType,
            captureCount = fn.captureCount,
            span         = fn.span
        )
        for (block in fn.blocks) {
            val newBlock = IrBlock(block.id, block.label, mutableListOf(), block.terminator)
            for (inst in block.instructions) {
                newBlock.instructions.add(rewriteInst(inst, channelToSlot))
            }
            out.blocks.add(newBlock)
        }
        return out
    }

    // ── Instruction-level substitution ────────────────────────────────────────
    //
    // ChannelCreate(%r) → SlotAlloc(%r, slot::__chN)
    //   The result ref is preserved so ChannelSend/Receive can still find the slot
    //   via channelToSlot[inst.channel].
    //
    // ChannelSend(%r, ch, val) → SlotStore(%r, slot::__chN, val)
    // ChannelReceive(%r, ch)   → SlotLoad(%r, slot::__chN)

    private fun rewriteInst(inst: IrInst, channelToSlot: Map<IrRef, IrSlot>): IrInst =
        when (inst) {
            is IrInst.ChannelCreate -> {
                val slot = channelToSlot[inst.result]
                if (slot != null) IrInst.SlotAlloc(inst.result, IrType.Any, slot, inst.span)
                else inst
            }
            is IrInst.ChannelSend -> {
                val slot = channelToSlot[inst.channel]
                if (slot != null) IrInst.SlotStore(inst.result, IrType.Unit, slot, inst.value, inst.span)
                else inst
            }
            is IrInst.ChannelReceive -> {
                val slot = channelToSlot[inst.channel]
                if (slot != null) IrInst.SlotLoad(inst.result, IrType.Any, slot, inst.span)
                else inst
            }
            else -> inst
        }
}
