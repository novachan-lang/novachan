package nova.interpreter

import java.util.concurrent.LinkedBlockingQueue

// ── NOVA runtime value hierarchy ──────────────────────────────────────────────
//
// Every value the interpreter can produce. Sealed so pattern matching is
// exhaustive. All values are immutable from the interpreter's perspective
// (COW is transparent — the interpreter just copies on mutation).

sealed class NovaValue

// Primitives — always bit-copied, no move semantics
data class NInt(val v: Long)    : NovaValue() { override fun toString() = v.toString() }
data class NFloat(val v: Double): NovaValue() { override fun toString() = v.toBigDecimal().stripTrailingZeros().toPlainString() }
data class NString(val v: String): NovaValue() { override fun toString() = v }
data class NBool(val v: Boolean) : NovaValue() { override fun toString() = v.toString() }
data class NByte(val v: Byte)    : NovaValue() { override fun toString() = v.toString() }

// Unit — void result
object NUnit : NovaValue() { override fun toString() = "Unit" }

// Error value — wraps a message string (returned by fallible functions)
data class NError(val msg: String) : NovaValue() { override fun toString() = "Error($msg)" }

// List — mutable but COW-transparent for the interpreter
data class NList(val elems: MutableList<NovaValue> = mutableListOf()) : NovaValue() {
    override fun toString() = "[${elems.joinToString(", ")}]"
    fun copy() = NList(elems.toMutableList())
}

// Tuple — fixed-size, immutable
data class NTuple(val elems: List<NovaValue>) : NovaValue() {
    override fun toString() = "(${elems.joinToString(", ")})"
}

// Record — named fields (anonymous struct, also used for typed struct instances)
data class NRecord(val fields: MutableMap<String, NovaValue>) : NovaValue() {
    override fun toString() = "{${fields.entries.joinToString(", ") { "${it.key}: ${it.value}" }}}"
    fun copy() = NRecord(fields.toMutableMap())
}

// Dict — ordered key-value map (string keys)
data class NDict(val entries: MutableMap<String, NovaValue>) : NovaValue() {
    override fun toString() = "{${entries.entries.joinToString(", ") { "\"${it.key}\": ${it.value}" }}}"
    fun copy() = NDict(entries.toMutableMap())
}

// Range — lazy iterable of Longs
data class NRange(val start: Long, val end: Long) : NovaValue() {
    override fun toString() = "$start..$end"
    fun asSequence() = (start until end).asSequence()
}

// Function / lambda — captures the environment at definition time
data class NFn(
    val params: List<String>,
    val body: FnBody,
    val closure: Env
) : NovaValue() { override fun toString() = "<fn>" }

// Function body — either an AST node (for user functions) or a native JVM lambda
sealed class FnBody
data class AstBody(val block: nova.parser.Block) : FnBody()
data class ExprFnBody(val expr: nova.parser.Expr) : FnBody()
data class NativeFn(val fn: (List<NovaValue>) -> NovaValue) : FnBody()

// Channel — typed FIFO queue shared between processes
// Uses a capacity of Int.MAX_VALUE (unbounded for interpreter purposes).
class NChannel : NovaValue() {
    val queue = LinkedBlockingQueue<NovaValue>()
    override fun toString() = "<channel>"
}

// Process handle — wraps a Java Thread
data class NProcess(val thread: Thread) : NovaValue() {
    override fun toString() = "<process>"
}

// ── Environment (scope) ───────────────────────────────────────────────────────
//
// Linked list of frames. Lookup walks up the chain. Assignment mutates the
// frame that owns the binding (not always the innermost).

class Env(val parent: Env? = null) {
    val bindings = mutableMapOf<String, NovaValue>()

    fun define(name: String, value: NovaValue) { bindings[name] = value }

    fun lookup(name: String): NovaValue? =
        bindings[name] ?: parent?.lookup(name)

    fun set(name: String, value: NovaValue): Boolean {
        if (name in bindings) { bindings[name] = value; return true }
        return parent?.set(name, value) ?: false
    }

    // Create a child scope
    fun child(): Env = Env(this)
}

// ── Control-flow signals ──────────────────────────────────────────────────────
//
// These are thrown as exceptions to unwind the call stack cleanly.
// The interpreter catches them at the appropriate boundary.

class ReturnSignal(val value: NovaValue) : Throwable()
class BreakSignal : Throwable()
class ContinueSignal : Throwable()
