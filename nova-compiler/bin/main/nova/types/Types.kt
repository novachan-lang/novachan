package nova.types

// ── NovaType sealed hierarchy ─────────────────────────────────────────────────
//
// Every node in this hierarchy is a structural type. Two types are equal iff
// their structure is identical (data class equality). TypeVar is the exception:
// it is equal only to itself (identity, not structure) — the unifier mutates
// TypeEnv to bind them.

sealed class NovaType

// Primitives
object TInt    : NovaType() { override fun toString() = "int" }
object TFloat  : NovaType() { override fun toString() = "float" }
object TString : NovaType() { override fun toString() = "string" }
object TBool   : NovaType() { override fun toString() = "bool" }
object TByte   : NovaType() { override fun toString() = "byte" }

// Unit: type of expressions with no useful value (void if, statement blocks, etc.)
object TUnit : NovaType() { override fun toString() = "Unit" }

// Nothing: the bottom type. Unifies with any type. Type of `return`, diverging
// expressions. The unifier special-cases this: Nothing unified with T yields T.
object TNothing : NovaType() { override fun toString() = "Nothing" }

// Collections
data class TList(val elem: NovaType) : NovaType() {
    override fun toString() = "List<$elem>"
}

data class TTuple(val elements: List<NovaType>) : NovaType() {
    override fun toString() = "(${elements.joinToString(", ")})"
}

// Channel<T>: typed communication pipe between processes
data class TChannel(val payload: NovaType) : NovaType() {
    override fun toString() = "Channel<$payload>"
}

// Function type: (P1, P2, ...) -> R
data class TFn(val params: List<NovaType>, val ret: NovaType) : NovaType() {
    override fun toString() = "(${params.joinToString(", ")}) -> $ret"
}

// Struct (named type): name + field map (ordered for display, Map for lookup)
data class TStruct(val name: String, val fields: Map<String, NovaType>) : NovaType() {
    override fun toString() = name
}

// Anonymous record: { label: T, ... }  (from RecordLit)
data class TRecord(val fields: Map<String, NovaType>) : NovaType() {
    override fun toString() = "{${fields.entries.joinToString(", ") { "${it.key}: ${it.value}" }}}"
}

// Dict<K, V>: key-value map (currently always string keys in Phase 1)
data class TDict(val key: NovaType, val value: NovaType) : NovaType() {
    override fun toString() = "Dict<$key, $value>"
}

// SumType: T or E — result of fallible operations. ElseOp decomposes this.
// Represents "value is either the success type or one of the error variants".
data class TSumType(val ok: NovaType, val err: NovaType) : NovaType() {
    override fun toString() = "$ok or $err"
}

// Range: the type of `a..b` — iterable of Int
object TRange : NovaType() { override fun toString() = "Range" }

// Process handle: returned by `spawn expr`
data class TProcess(val yieldType: NovaType) : NovaType() {
    override fun toString() = "Process<$yieldType>"
}

// Type variable: unification variable. Mutable binding via TypeEnv.
class TypeVar(val id: Int) : NovaType() {
    override fun toString() = "?T$id"
    // TypeVar equality is identity (default object equals) — two distinct TypeVars
    // with the same id should never exist, but identity is the right semantic.
}

// ── TypeEnv: union-find-style binding map ─────────────────────────────────────
//
// Maps TypeVar.id -> NovaType. walk() resolves chains eagerly.
// This is NOT a scope environment — that lives in TypeInferer.
class TypeEnv {
    private val bindings = mutableMapOf<Int, NovaType>()

    fun bind(v: TypeVar, t: NovaType) {
        bindings[v.id] = t
    }

    // Walk the chain until we reach a non-TypeVar or an unbound var.
    fun walk(t: NovaType): NovaType {
        var cur = t
        while (cur is TypeVar) {
            cur = bindings[cur.id] ?: return cur
        }
        return cur
    }

    // Fully substitute all type variables in a type (deep walk).
    fun apply(t: NovaType): NovaType = when (val w = walk(t)) {
        is TypeVar  -> w            // unbound — leave as-is
        is TList    -> TList(apply(w.elem))
        is TTuple   -> TTuple(w.elements.map { apply(it) })
        is TChannel -> TChannel(apply(w.payload))
        is TFn      -> TFn(w.params.map { apply(it) }, apply(w.ret))
        is TStruct  -> TStruct(w.name, w.fields.mapValues { apply(it.value) })
        is TRecord  -> TRecord(w.fields.mapValues { apply(it.value) })
        is TSumType -> TSumType(apply(w.ok), apply(w.err))
        is TProcess -> TProcess(apply(w.yieldType))
        is TDict    -> TDict(apply(w.key), apply(w.value))
        else        -> w            // primitives, TUnit, TNothing, TRange
    }

    // Check if TypeVar v occurs in type t (occurs check — prevents infinite types).
    fun occurs(v: TypeVar, t: NovaType): Boolean = when (val w = walk(t)) {
        is TypeVar  -> w.id == v.id
        is TList    -> occurs(v, w.elem)
        is TTuple   -> w.elements.any { occurs(v, it) }
        is TChannel -> occurs(v, w.payload)
        is TFn      -> w.params.any { occurs(v, it) } || occurs(v, w.ret)
        is TStruct  -> w.fields.values.any { occurs(v, it) }
        is TRecord  -> w.fields.values.any { occurs(v, it) }
        is TSumType -> occurs(v, w.ok) || occurs(v, w.err)
        is TProcess -> occurs(v, w.yieldType)
        is TDict    -> occurs(v, w.key) || occurs(v, w.value)
        else        -> false
    }
}

// ── TypeScheme: for let-polymorphism ──────────────────────────────────────────
//
// A scheme wraps a type with the set of type variable ids that are generalized
// (quantified). When instantiated, each quantified var is replaced with a fresh var.
data class TypeScheme(val quantified: Set<Int>, val body: NovaType) {
    companion object {
        // Monomorphic scheme — no quantification (variable is still being inferred).
        fun mono(t: NovaType) = TypeScheme(emptySet(), t)
    }
}
