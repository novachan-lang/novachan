package nova.ir

// ── IR Types ─────────────────────────────────────────────────────────────────
//
// Simplified type hierarchy for the IR layer. Maps from NovaType but stripped
// of inference variables and type schemes — everything is resolved by this point.

sealed class IrType {
    object I64     : IrType() { override fun toString() = "i64" }
    object F64     : IrType() { override fun toString() = "f64" }
    object Bool    : IrType() { override fun toString() = "bool" }
    object Byte    : IrType() { override fun toString() = "byte" }
    object Str     : IrType() { override fun toString() = "str" }
    object Unit    : IrType() { override fun toString() = "unit" }
    object Any     : IrType() { override fun toString() = "any" }   // erased/dynamic
    object Channel : IrType() { override fun toString() = "channel" }
    object Process : IrType() { override fun toString() = "process" }
    object Error   : IrType() { override fun toString() = "error" }

    data class List(val elem: IrType)    : IrType() { override fun toString() = "[$elem]" }
    data class Tuple(val elems: kotlin.collections.List<IrType>) : IrType() {
        override fun toString() = "(${elems.joinToString(", ")})"
    }
    data class Fn(val params: kotlin.collections.List<IrType>, val ret: IrType) : IrType() {
        override fun toString() = "(${params.joinToString(", ")}) -> $ret"
    }
    data class Closure(val fn: Fn, val captureCount: Int) : IrType() {
        override fun toString() = "closure<$fn, captures=$captureCount>"
    }
    data class Struct(val name: String)  : IrType() { override fun toString() = name }
    // Phase 1: ordered key-value store with O(n) lookup. Correct for all inputs.
    // Phase 6 stdlib upgrade: hash table with O(1) amortized lookup.
    data class Dict(val keyType: IrType, val valType: IrType) : IrType() {
        override fun toString() = "dict[$keyType -> $valType]"
    }
}

// ── IR Constants ──────────────────────────────────────────────────────────────

sealed class IrConst {
    data class Int(val v: Long)    : IrConst() { override fun toString() = "$v" }
    data class Float(val v: Double): IrConst() { override fun toString() = "$v" }
    data class Str(val v: String)  : IrConst() { override fun toString() = "\"${v.replace("\"", "\\\"")}\"" }
    data class Bool(val v: Boolean): IrConst() { override fun toString() = "$v" }
    object Byte0 : IrConst()       { override fun toString() = "byte(0)" }
    object Unit  : IrConst()       { override fun toString() = "()" }
}
