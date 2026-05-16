package nova.ir

// ── Human-readable IR printer ─────────────────────────────────────────────────
//
// Produces textual IR that is inspectable without a tool. Format mirrors LLVM IR
// style but uses NOVA terminology. Every instruction is on one line; blocks are
// indented under their function.
//
// Example output:
//
//   function nova_main() -> unit:
//     bb0 (entry):
//       %0 = const i64 42
//       %1 = slot_alloc slot::x : i64
//       store slot::x, %0
//       %2 = load slot::x : i64
//       call_direct "print" (%2) -> unit
//       return ()
//

class IrPrinter {

    fun print(module: IrModule): String = buildString {
        appendLine("module ${module.name}")
        if (module.structs.isNotEmpty()) {
            appendLine()
            for ((name, fields) in module.structs) {
                appendLine("struct $name { ${fields.joinToString(", ") { "${it.first}: ${it.second}" }} }")
            }
        }
        for (fn in module.functions) {
            appendLine()
            append(printFunction(fn))
        }
    }

    fun printFunction(fn: IrFunction): String = buildString {
        val paramStr = fn.params.joinToString(", ") { "${it.first}: ${it.second}" }
        val captureNote = if (fn.captureCount > 0) " [captures: ${fn.captureCount}]" else ""
        appendLine("function ${fn.name}($paramStr) -> ${fn.returnType}$captureNote:")
        for (block in fn.blocks) {
            appendLine(printBlock(block))
        }
    }

    private fun printBlock(block: IrBlock): String = buildString {
        appendLine("  ${block.id} (${block.label}):")
        for (inst in block.instructions) {
            appendLine("    ${printInst(inst)}")
        }
        val term = block.terminator
        if (term != null) appendLine("    ${printTerminator(term)}")
        else appendLine("    ; (no terminator — incomplete block)")
    }

    private fun printInst(inst: IrInst): String = when (inst) {
        is IrInst.Const      -> "${inst.result} = const ${inst.type} ${inst.value}"
        is IrInst.SlotAlloc  -> "${inst.result} = slot_alloc ${inst.slot} : ${inst.type}"
        is IrInst.SlotStore  -> "store ${inst.slot}, ${inst.value}"
        is IrInst.SlotLoad   -> "${inst.result} = load ${inst.slot} : ${inst.type}"
        is IrInst.Binary     -> "${inst.result} = ${inst.op.name.lowercase()} ${inst.type} ${inst.left}, ${inst.right}"
        is IrInst.Unary      -> "${inst.result} = ${inst.op.name.lowercase()} ${inst.type} ${inst.operand}"
        is IrInst.Call       -> "${inst.result} = call ${inst.callee} (${inst.args.joinToString(", ")}) -> ${inst.type}"
        is IrInst.CallDirect -> "${inst.result} = call_direct \"${inst.funcName}\" (${inst.args.joinToString(", ")}) -> ${inst.type}"
        is IrInst.MakeClosure -> {
            val caps = if (inst.captureRefs.isEmpty()) "" else " [${inst.captureRefs.joinToString(", ")}]"
            "${inst.result} = make_closure \"${inst.funcName}\"$caps : ${inst.type}"
        }
        is IrInst.MakeList   -> "${inst.result} = make_list [${inst.elems.joinToString(", ")}] : ${inst.type}"
        is IrInst.ListAppend -> "list_append ${inst.list}, ${inst.elem}"
        is IrInst.MakeTuple  -> "${inst.result} = make_tuple (${inst.elems.joinToString(", ")}) : ${inst.type}"
        is IrInst.MakeRecord -> {
            val fields = inst.fields.joinToString(", ") { "${it.first}: ${it.second}" }
            "${inst.result} = make_record { $fields } : ${inst.type}"
        }
        is IrInst.FieldGet   -> "${inst.result} = field_get ${inst.obj}.${inst.field} : ${inst.type}"
        is IrInst.FieldSet   -> "field_set ${inst.obj}.${inst.field}, ${inst.value}"
        is IrInst.IndexGet   -> "${inst.result} = index_get ${inst.target}[${inst.index}] : ${inst.type}"
        is IrInst.IndexSet   -> "index_set ${inst.target}[${inst.index}], ${inst.value}"
        is IrInst.StringConcat -> "${inst.result} = str_concat [${inst.parts.joinToString(", ")}] : str"
        is IrInst.ToString   -> "${inst.result} = to_string ${inst.value} : str"
        is IrInst.Copy       -> "${inst.result} = copy ${inst.source} : ${inst.type}"
        is IrInst.IsError    -> "${inst.result} = is_error ${inst.value} : bool"
        is IrInst.UnwrapError -> "${inst.result} = unwrap_ok ${inst.value} : ${inst.type}"
        is IrInst.LoadErrorMsg -> "${inst.result} = load_error_msg : str"
        is IrInst.RaiseError -> "${inst.result} = raise_error : ${inst.type}"
        is IrInst.ChannelCreate  -> "${inst.result} = channel_create : ${inst.type}"
        is IrInst.ChannelSend    -> "channel_send ${inst.channel}, ${inst.value}"
        is IrInst.ChannelReceive -> "${inst.result} = channel_recv ${inst.channel} : ${inst.type}"
        is IrInst.ChannelSelect  -> "${inst.result} = channel_select (${inst.channels.joinToString(", ")}) : ${inst.type}"
        is IrInst.ChannelClose   -> "channel_close ${inst.channel}"
        is IrInst.ChannelRecvTimeout -> "${inst.result} = channel_recv_timeout ${inst.channel}, ${inst.timeoutMs} : ${inst.type}"
        is IrInst.Spawn          -> "${inst.result} = spawn \"${inst.funcName}\" (${inst.args.joinToString(", ")}) : process"
        is IrInst.MakeDict -> {
            val entries = inst.entries.joinToString(", ") { "${it.first}: ${it.second}" }
            "${inst.result} = make_dict { $entries } : ${inst.type}"
        }
    }

    private fun printTerminator(term: IrTerminator): String = when (term) {
        is IrTerminator.Return      -> "return ${term.value}"
        is IrTerminator.Goto        -> "goto ${term.target}"
        is IrTerminator.Branch      -> "branch ${term.cond}, ${term.thenBlock}, ${term.elseBlock}"
        is IrTerminator.Unreachable -> "unreachable"
    }
}
