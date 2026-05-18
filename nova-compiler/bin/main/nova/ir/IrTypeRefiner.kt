package nova.ir

class IrTypeRefiner {

    private val fnParamTypes = mutableMapOf<String, MutableList<IrType>>()
    private val fnReturnTypes = mutableMapOf<String, IrType>()
    private val structFields = mutableMapOf<String, List<Pair<String, IrType>>>()

    fun refine(module: IrModule): IrModule {
        fnParamTypes.clear(); fnReturnTypes.clear(); structFields.clear()

        for ((name, fields) in module.structs)
            structFields[name] = fields

        for (fn in module.functions)
            fnParamTypes[fn.name] = fn.params.map { it.second }.toMutableList()

        var iteration = 0
        var changed = true
        while (changed && iteration < 20) {
            changed = false
            for (fn in module.functions) {
                if (refineFn(fn)) changed = true
            }
            iteration++
        }

        return rewrite(module)
    }

    private fun refineFn(fn: IrFunction): Boolean {
        var changed = false
        val types = mutableMapOf<IrRef, IrType>()
        val slotTypes = mutableMapOf<String, IrType>()
        val closureFns = mutableMapOf<IrRef, String>()

        val paramTypeList = fnParamTypes[fn.name]!!
        for ((i, _) in fn.params.withIndex()) {
            types[IrRef(-(i + 1))] = paramTypeList[i]
        }

        for (block in fn.blocks) {
            for (inst in block.instructions) {
                if (inst is IrInst.MakeClosure)
                    closureFns[inst.result] = inst.funcName

                val refined = refineInst(inst, types, slotTypes, closureFns)
                if (refined != null && refined != IrType.Any && refined != IrType.Unit) {
                    types[inst.result] = refined
                }
            }

            val term = block.terminator
            if (term is IrTerminator.Return) {
                val retType = types[term.value]
                if (retType != null && retType != IrType.Any && retType != IrType.Unit) {
                    if (fnReturnTypes[fn.name] != retType) {
                        fnReturnTypes[fn.name] = retType
                        changed = true
                    }
                }
            }
        }

        for (block in fn.blocks) {
            for (inst in block.instructions) {
                val targetFn: String? = when (inst) {
                    is IrInst.CallDirect -> if (inst.funcName != "print") inst.funcName else null
                    is IrInst.Call -> closureFns[inst.callee]
                        ?: slotClosureFn(inst.callee, fn, closureFns)
                    else -> null
                }
                if (targetFn != null) {
                    val args = when (inst) {
                        is IrInst.CallDirect -> inst.args
                        is IrInst.Call -> inst.args
                        else -> emptyList()
                    }
                    val calleeParams = fnParamTypes[targetFn] ?: continue
                    for ((i, arg) in args.withIndex()) {
                        if (i >= calleeParams.size) continue
                        val argType = types[arg] ?: continue
                        if (argType == IrType.Any || argType == IrType.Unit) continue
                        if (calleeParams[i] == IrType.Any) {
                            calleeParams[i] = argType
                            changed = true
                        } else if (calleeParams[i] != argType) {
                            // Multiple call sites pass different concrete types — revert to Any
                            // so field lookups don't use a stale/wrong struct layout.
                            calleeParams[i] = IrType.Any
                            changed = true
                        }
                    }
                }
            }
        }

        return changed
    }

    private fun slotClosureFn(
        calleeRef: IrRef,
        fn: IrFunction,
        closureFns: MutableMap<IrRef, String>
    ): String? {
        for (block in fn.blocks) {
            for (inst in block.instructions) {
                if (inst is IrInst.SlotLoad && inst.result == calleeRef) {
                    for (b2 in fn.blocks) {
                        for (i2 in b2.instructions) {
                            if (i2 is IrInst.SlotStore && i2.slot == inst.slot) {
                                return closureFns[i2.value]
                            }
                        }
                    }
                }
            }
        }
        return null
    }

    private fun refineInst(
        inst: IrInst,
        types: MutableMap<IrRef, IrType>,
        slotTypes: MutableMap<String, IrType>,
        closureFns: Map<IrRef, String>
    ): IrType? = when (inst) {
        is IrInst.Const -> when (inst.value) {
            is IrConst.Float -> IrType.F64
            is IrConst.Int -> IrType.I64
            is IrConst.Str -> IrType.Str
            is IrConst.Bool -> IrType.Bool
            is IrConst.Unit -> IrType.Unit
            is IrConst.Byte0 -> IrType.Byte
        }

        is IrInst.Binary -> {
            val lt = types[inst.left]
            val rt = types[inst.right]
            when (inst.op) {
                BinOp.ADD, BinOp.SUB, BinOp.MUL, BinOp.DIV, BinOp.MOD, BinOp.POW -> {
                    if (lt == IrType.F64 || rt == IrType.F64) IrType.F64
                    else if (lt == IrType.I64 || rt == IrType.I64) IrType.I64
                    else null
                }
                BinOp.EQ, BinOp.NE, BinOp.LT, BinOp.GT, BinOp.LE, BinOp.GE,
                BinOp.AND, BinOp.OR -> IrType.Bool
                BinOp.CONCAT -> IrType.Str
                BinOp.BIT_AND, BinOp.BIT_OR, BinOp.BIT_XOR, BinOp.SHL, BinOp.SHR -> IrType.I64
            }
        }

        is IrInst.Unary -> when (inst.op) {
            UnOp.NEG -> types[inst.operand]
            UnOp.NOT -> IrType.Bool
            UnOp.BIT_NOT -> IrType.I64
        }

        is IrInst.SlotStore -> {
            val valType = types[inst.value]
            if (valType != null && valType != IrType.Any && valType != IrType.Unit)
                slotTypes[inst.slot.name] = valType
            IrType.Unit
        }

        is IrInst.SlotLoad -> {
            val st = slotTypes[inst.slot.name]
            if (st != null) {
                types[inst.result] = st
                st
            } else null
        }

        is IrInst.CallDirect -> fnReturnTypes[inst.funcName]

        is IrInst.Call -> {
            val origin = closureFns[inst.callee]
            if (origin != null) fnReturnTypes[origin]
            else null
        }

        is IrInst.MakeClosure -> null

        is IrInst.MakeList -> {
            val elemTypes = inst.elems.mapNotNull { types[it] }.filter { it != IrType.Any }.toSet()
            if (elemTypes.size == 1) IrType.List(elemTypes.first()) else IrType.List(IrType.Any)
        }

        is IrInst.ListAppend -> {
            val listType = types[inst.list]
            if (listType is IrType.List) listType
            else {
                val elemType = types[inst.elem]
                if (elemType != null && elemType != IrType.Any) IrType.List(elemType)
                else null
            }
        }

        is IrInst.IndexGet -> {
            val targetType = types[inst.target]
            when {
                targetType is IrType.List && targetType.elem != IrType.Any -> targetType.elem
                targetType is IrType.Dict && targetType.valType != IrType.Any -> targetType.valType
                else -> null
            }
        }

        is IrInst.MakeDict -> if (inst.type is IrType.Dict) inst.type else null

        is IrInst.IndexSet -> IrType.Unit

        is IrInst.MakeTuple -> if (inst.type is IrType.Tuple) inst.type else IrType.Tuple(inst.elems.map { types[it] ?: IrType.Any })

        is IrInst.MakeRecord -> if (inst.type is IrType.Struct) inst.type else null

        is IrInst.FieldGet -> {
            val objType = types[inst.obj]
            if (objType is IrType.Struct) {
                val fields = structFields[objType.name]
                val fieldType = fields?.firstOrNull { it.first == inst.field }?.second
                if (fieldType != null && fieldType != IrType.Any) fieldType else null
            } else null
        }

        is IrInst.FieldSet -> IrType.Unit

        is IrInst.StringConcat -> IrType.Str
        is IrInst.ToString -> IrType.Str

        is IrInst.Copy -> types[inst.source]

        else -> null
    }

    private fun rewrite(module: IrModule): IrModule {
        val result = IrModule(module.name)
        result.structs.addAll(module.structs)
        result.externFunctions.addAll(module.externFunctions)

        for (fn in module.functions) {
            val paramTypeList = fnParamTypes[fn.name]!!
            val newParams = fn.params.mapIndexed { i, (name, _) -> name to paramTypeList[i] }
            val retType = fnReturnTypes[fn.name] ?: fn.returnType
            val newFn = IrFunction(fn.name, newParams, retType, span = fn.span, captureCount = fn.captureCount)

            val types = mutableMapOf<IrRef, IrType>()
            val slotTypes = mutableMapOf<String, IrType>()
            val closureFns = mutableMapOf<IrRef, String>()
            for ((i, _) in newParams.withIndex())
                types[IrRef(-(i + 1))] = paramTypeList[i]

            for (block in fn.blocks) {
                val newBlock = IrBlock(block.id, block.label)
                newBlock.terminator = block.terminator

                for (inst in block.instructions) {
                    if (inst is IrInst.MakeClosure)
                        closureFns[inst.result] = inst.funcName

                    val refined = refineInst(inst, types, slotTypes, closureFns)
                    val newType = if (refined != null && refined != IrType.Any && inst.type == IrType.Any)
                        refined else inst.type
                    if (refined != null && refined != IrType.Any)
                        types[inst.result] = refined

                    newBlock.instructions.add(rewriteInst(inst, newType))
                }
                newFn.blocks.add(newBlock)
            }
            result.functions.add(newFn)
        }
        return result
    }

    private fun rewriteInst(inst: IrInst, newType: IrType): IrInst = when (inst) {
        is IrInst.Const -> inst.copy(type = newType)
        is IrInst.Binary -> inst.copy(type = newType)
        is IrInst.Unary -> inst.copy(type = newType)
        is IrInst.SlotAlloc -> inst.copy(type = newType)
        is IrInst.SlotStore -> inst
        is IrInst.SlotLoad -> inst.copy(type = newType)
        is IrInst.Call -> inst.copy(type = newType)
        is IrInst.CallDirect -> inst.copy(type = newType)
        is IrInst.MakeClosure -> inst
        is IrInst.Copy -> inst.copy(type = newType)
        is IrInst.MakeList -> inst.copy(type = newType)
        is IrInst.ListAppend -> inst
        is IrInst.MakeTuple -> inst.copy(type = if (inst.type is IrType.Tuple) inst.type else newType)
        is IrInst.MakeRecord -> inst.copy(type = newType)
        is IrInst.FieldGet -> inst.copy(type = newType)
        is IrInst.FieldSet -> inst
        is IrInst.IndexGet -> inst.copy(type = newType)
        is IrInst.IndexSet -> inst
        is IrInst.StringConcat -> inst.copy(type = IrType.Str)
        is IrInst.ToString -> inst.copy(type = IrType.Str)
        is IrInst.IsError -> inst
        is IrInst.UnwrapError -> inst
        is IrInst.LoadErrorMsg -> inst.copy(type = IrType.Str)
        is IrInst.RaiseError -> inst
        is IrInst.ChannelCreate -> inst
        is IrInst.ChannelSend -> inst
        is IrInst.ChannelReceive -> inst
        is IrInst.ChannelSelect -> inst
        is IrInst.ChannelClose -> inst
        is IrInst.ChannelRecvTimeout -> inst
        is IrInst.Spawn -> inst
        is IrInst.MakeDict -> if (newType is IrType.Dict) inst.copy(type = newType) else inst
    }
}
