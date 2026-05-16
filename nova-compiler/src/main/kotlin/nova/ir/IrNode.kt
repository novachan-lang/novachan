package nova.ir

import nova.lexer.SourceSpan

// ── Value references ─────────────────────────────────────────────────────────

data class IrRef(val id: Int) {
    override fun toString() = "%$id"
}

// A named mutable slot (equivalent to LLVM alloca). All mutable variables get
// a slot; SlotLoad/SlotStore handle reads and writes. LLVM's mem2reg promotes
// these to SSA phi-nodes automatically at code generation time.
data class IrSlot(val name: String, val isGlobal: Boolean = false) {
    override fun toString() = if (isGlobal) "gslot::$name" else "slot::$name"
}

// ── Block identifier ──────────────────────────────────────────────────────────

data class BlockId(val id: Int) {
    override fun toString() = "bb$id"
}

// ── Operator enums ────────────────────────────────────────────────────────────

enum class BinOp {
    ADD, SUB, MUL, DIV, MOD, POW,
    EQ, NE, LT, GT, LE, GE,
    AND, OR, CONCAT
}

enum class UnOp { NEG, NOT }

// ── Instructions ─────────────────────────────────────────────────────────────
//
// Three tiers:
//   High-level: Spawn, ChannelCreate, ChannelSend, ChannelReceive — survive
//               until the abstraction erasure pass (Phase 2.3) which either
//               inlines them (local process) or lowers to runtime calls.
//   Mid-level:  control flow (handled by IrTerminator, not IrInst)
//   Low-level:  arithmetic, slots, calls, collection ops

sealed class IrInst {
    abstract val result: IrRef
    abstract val type: IrType
    abstract val span: SourceSpan

    // ── Constants ────────────────────────────────────────────────────────────

    data class Const(
        override val result: IrRef,
        override val type: IrType,
        val value: IrConst,
        override val span: SourceSpan
    ) : IrInst()

    // ── Mutable variable slots ────────────────────────────────────────────────

    data class SlotAlloc(
        override val result: IrRef,
        override val type: IrType,
        val slot: IrSlot,
        override val span: SourceSpan
    ) : IrInst()

    data class SlotStore(
        override val result: IrRef,   // always Unit
        override val type: IrType,
        val slot: IrSlot,
        val value: IrRef,
        override val span: SourceSpan
    ) : IrInst()

    data class SlotLoad(
        override val result: IrRef,
        override val type: IrType,
        val slot: IrSlot,
        override val span: SourceSpan
    ) : IrInst()

    // ── Arithmetic / logic ────────────────────────────────────────────────────

    data class Binary(
        override val result: IrRef,
        override val type: IrType,
        val op: BinOp,
        val left: IrRef,
        val right: IrRef,
        override val span: SourceSpan
    ) : IrInst()

    data class Unary(
        override val result: IrRef,
        override val type: IrType,
        val op: UnOp,
        val operand: IrRef,
        override val span: SourceSpan
    ) : IrInst()

    // ── Function calls ────────────────────────────────────────────────────────

    // Call through a closure/function value (dynamic dispatch)
    data class Call(
        override val result: IrRef,
        override val type: IrType,
        val callee: IrRef,
        val args: List<IrRef>,
        override val span: SourceSpan
    ) : IrInst()

    // Direct call to a named function (static dispatch, no closure)
    data class CallDirect(
        override val result: IrRef,
        override val type: IrType,
        val funcName: String,
        val args: List<IrRef>,
        override val span: SourceSpan
    ) : IrInst()

    // ── Closures ─────────────────────────────────────────────────────────────
    //
    // Lambda lifting: nested functions and lambdas are hoisted to top-level
    // IrFunction entries. MakeClosure pairs the function reference with its
    // captured values. If captureRefs is empty, no closure record is needed.

    data class MakeClosure(
        override val result: IrRef,
        override val type: IrType,    // IrType.Closure
        val funcName: String,
        val captureRefs: List<IrRef>,
        override val span: SourceSpan
    ) : IrInst()

    // ── Collections ──────────────────────────────────────────────────────────

    data class MakeList(
        override val result: IrRef,
        override val type: IrType,
        val elems: List<IrRef>,
        override val span: SourceSpan
    ) : IrInst()

    // ListAppend is a first-class instruction so the COW optimization pass can
    // see accumulation patterns and ensure in-place mutation where safe.
    data class ListAppend(
        override val result: IrRef,   // Unit
        override val type: IrType,
        val list: IrRef,
        val elem: IrRef,
        override val span: SourceSpan
    ) : IrInst()

    data class MakeTuple(
        override val result: IrRef,
        override val type: IrType,
        val elems: List<IrRef>,
        override val span: SourceSpan
    ) : IrInst()

    data class MakeRecord(
        override val result: IrRef,
        override val type: IrType,
        val fields: List<Pair<String, IrRef>>,
        override val span: SourceSpan
    ) : IrInst()

    data class FieldGet(
        override val result: IrRef,
        override val type: IrType,
        val obj: IrRef,
        val field: String,
        override val span: SourceSpan,
        val objType: IrType = IrType.Any  // explicit struct type hint for field index lookup
    ) : IrInst()

    data class FieldSet(
        override val result: IrRef,   // Unit
        override val type: IrType,
        val obj: IrRef,
        val field: String,
        val value: IrRef,
        override val span: SourceSpan
    ) : IrInst()

    data class IndexGet(
        override val result: IrRef,
        override val type: IrType,
        val target: IrRef,
        val index: IrRef,
        override val span: SourceSpan
    ) : IrInst()

    data class IndexSet(
        override val result: IrRef,   // Unit
        override val type: IrType,
        val target: IrRef,
        val index: IrRef,
        val value: IrRef,
        override val span: SourceSpan
    ) : IrInst()

    // Dict literal: creates an empty dict, then inserts each (key, value) pair.
    // The type is always IrType.Dict so LlvmCodegen can dispatch correctly.
    data class MakeDict(
        override val result: IrRef,
        override val type: IrType,    // IrType.Dict
        val entries: List<Pair<IrRef, IrRef>>,
        override val span: SourceSpan
    ) : IrInst()

    // ── Strings ───────────────────────────────────────────────────────────────

    // String interpolation: joins a list of str fragments. Enables the 3-level
    // string optimization from the pre-phase-2 performance spec.
    data class StringConcat(
        override val result: IrRef,
        override val type: IrType,
        val parts: List<IrRef>,
        override val span: SourceSpan
    ) : IrInst()

    data class ToString(
        override val result: IrRef,
        override val type: IrType,
        val value: IrRef,
        override val span: SourceSpan
    ) : IrInst()

    // ── Ownership ─────────────────────────────────────────────────────────────

    data class Copy(
        override val result: IrRef,
        override val type: IrType,
        val source: IrRef,
        override val span: SourceSpan
    ) : IrInst()

    // ── ElseOp — error-default handling ──────────────────────────────────────
    // Checks if `value` is an Error; if so evaluates the default branch.
    // Kept high-level so the optimizer can eliminate the check when the
    // value is provably non-Error.
    data class IsError(
        override val result: IrRef,   // bool
        override val type: IrType,
        val value: IrRef,
        override val span: SourceSpan
    ) : IrInst()

    data class UnwrapError(
        override val result: IrRef,
        override val type: IrType,
        val value: IrRef,
        override val span: SourceSpan
    ) : IrInst()

    // Reads @__nova_error_msg and clears it. Used in catch-error paths to bind
    // the error message to the user's error variable before running the handler.
    data class LoadErrorMsg(
        override val result: IrRef,
        override val type: IrType,
        override val span: SourceSpan
    ) : IrInst()

    // Re-sets @__nova_error_flag = 1 without touching @__nova_error_msg.
    // Used in try-propagate paths: IsError cleared the flag, this re-raises it
    // so the caller's error check sees the error.
    data class RaiseError(
        override val result: IrRef,
        override val type: IrType,
        override val span: SourceSpan
    ) : IrInst()

    // ── High-level process/channel ops (erased in Phase 2.3) ─────────────────

    data class ChannelCreate(
        override val result: IrRef,
        override val type: IrType,    // IrType.Channel
        override val span: SourceSpan
    ) : IrInst()

    data class ChannelSend(
        override val result: IrRef,   // Unit
        override val type: IrType,
        val channel: IrRef,
        val value: IrRef,
        override val span: SourceSpan
    ) : IrInst()

    data class ChannelReceive(
        override val result: IrRef,
        override val type: IrType,
        val channel: IrRef,
        override val span: SourceSpan
    ) : IrInst()

    data class Spawn(
        override val result: IrRef,
        override val type: IrType,    // IrType.Process
        val funcName: String,
        val args: List<IrRef>,
        override val span: SourceSpan
    ) : IrInst()

    data class ChannelSelect(
        override val result: IrRef,
        override val type: IrType,    // IrType.Tuple([I64, Any])
        val channels: List<IrRef>,
        override val span: SourceSpan
    ) : IrInst()

    data class ChannelClose(
        override val result: IrRef,
        override val type: IrType,    // IrType.Unit
        val channel: IrRef,
        override val span: SourceSpan
    ) : IrInst()

    data class ChannelRecvTimeout(
        override val result: IrRef,
        override val type: IrType,
        val channel: IrRef,
        val timeoutMs: IrRef,
        override val span: SourceSpan
    ) : IrInst()
}

// ── Terminators ───────────────────────────────────────────────────────────────
//
// Every basic block ends with exactly one terminator. Control flow is explicit.

sealed class IrTerminator {
    abstract val span: SourceSpan

    data class Return(val value: IrRef, override val span: SourceSpan) : IrTerminator()
    data class Goto(val target: BlockId, override val span: SourceSpan) : IrTerminator()
    data class Branch(
        val cond: IrRef,
        val thenBlock: BlockId,
        val elseBlock: BlockId,
        override val span: SourceSpan
    ) : IrTerminator()
    // Unreachable — after match with no fallthrough, or return in every arm
    data class Unreachable(override val span: SourceSpan) : IrTerminator()
}

// ── Basic block ───────────────────────────────────────────────────────────────

data class IrBlock(
    val id: BlockId,
    val label: String,
    val instructions: MutableList<IrInst> = mutableListOf(),
    var terminator: IrTerminator? = null
)

// ── Function ──────────────────────────────────────────────────────────────────

data class IrFunction(
    val name: String,
    val params: List<Pair<String, IrType>>,
    val returnType: IrType,
    val blocks: MutableList<IrBlock> = mutableListOf(),
    // For lifted lambdas/closures: captures appear as extra params after regular params.
    val captureCount: Int = 0,
    val span: SourceSpan
) {
    val entryBlock: IrBlock get() = blocks.first()
    private var blockIdCounter = 0

    fun newBlock(label: String = "bb"): IrBlock {
        val id = blockIdCounter++
        val b = IrBlock(BlockId(id), "$label$id")
        blocks.add(b)
        return b
    }
}

// ── Module ────────────────────────────────────────────────────────────────────

data class IrModule(
    val name: String,
    val functions: MutableList<IrFunction> = mutableListOf(),
    val structs: MutableList<Pair<String, List<Pair<String, IrType>>>> = mutableListOf()
)
