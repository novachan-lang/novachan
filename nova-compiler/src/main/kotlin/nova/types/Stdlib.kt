package nova.types

// ── NOVA standard library type registry ──────────────────────────────────────
//
// Maps function name -> TypeScheme. The inferer looks up names here when they
// are not found in the local scope. Fresh type variables are allocated by the
// caller (TypeInferer) using instantiate() before each use.
//
// Conventions:
//   - Polymorphic functions use placeholder TypeVars with negative ids (< 0).
//     These are never bound by the unifier — they exist only as scheme templates.
//   - The inferer calls TypeScheme.instantiate(env) which replaces each negative-id
//     var with a fresh positive-id var before adding constraints.

object Stdlib {

    // Template vars for scheme definitions — negative ids, never unified directly.
    private fun tv(id: Int) = TypeVar(-id)

    private val T = tv(1)   // generic element
    private val U = tv(2)   // second generic
    private val R = tv(3)   // return / result

    // ── Core I/O ──────────────────────────────────────────────────────────────
    val PRINT       = TypeScheme(setOf(-1), TFn(listOf(T), TUnit))
    val READ_FILE   = TypeScheme(emptySet(), TFn(listOf(TString), TSumType(TString, TStruct("Error", mapOf("msg" to TString)))))
    val WRITE_FILE  = TypeScheme(emptySet(), TFn(listOf(TString, TString), TSumType(TUnit, TStruct("Error", mapOf("msg" to TString)))))
    val ENV         = TypeScheme(emptySet(), TFn(listOf(TString), TSumType(TString, TStruct("Error", mapOf("msg" to TString)))))

    // ── Type conversions ───────────────────────────────────────────────────────
    val STR_FN      = TypeScheme(setOf(-1), TFn(listOf(T), TString))
    val INT_FN      = TypeScheme(setOf(-1), TFn(listOf(T), TInt))
    val FLOAT_FN    = TypeScheme(setOf(-1), TFn(listOf(T), TFloat))
    val BOOL_FN     = TypeScheme(setOf(-1), TFn(listOf(T), TBool))
    val TYPE_FN     = TypeScheme(setOf(-1), TFn(listOf(T), TString))
    val PARSE_INT   = TypeScheme(emptySet(), TFn(listOf(TString), TSumType(TInt,   TStruct("Error", mapOf("msg" to TString)))))
    val PARSE_FLOAT = TypeScheme(emptySet(), TFn(listOf(TString), TSumType(TFloat, TStruct("Error", mapOf("msg" to TString)))))

    // ── Collections / Sequences ────────────────────────────────────────────────
    val LEN_FN   = TypeScheme(setOf(-1), TFn(listOf(T), TInt))
    val RANGE_FN = TypeScheme(emptySet(), TFn(listOf(TInt), TRange))

    // ── Numeric math ───────────────────────────────────────────────────────────
    val ABS_FN   = TypeScheme(setOf(-1), TFn(listOf(T), T))
    val MAX_FN   = TypeScheme(setOf(-1), TFn(listOf(T, T), T))
    val MIN_FN   = TypeScheme(setOf(-1), TFn(listOf(T, T), T))
    val SQRT_FN  = TypeScheme(emptySet(), TFn(listOf(TFloat), TFloat))
    val POW_FN   = TypeScheme(emptySet(), TFn(listOf(TFloat, TFloat), TFloat))
    val ROUND_FN = TypeScheme(emptySet(), TFn(listOf(TFloat), TInt))
    val FLOOR_FN = TypeScheme(emptySet(), TFn(listOf(TFloat), TInt))
    val CEIL_FN  = TypeScheme(emptySet(), TFn(listOf(TFloat), TInt))

    // ── Trig (raw built-ins used by math.nova internally) ─────────────────────
    private val FLOAT1 = TypeScheme(emptySet(), TFn(listOf(TFloat), TFloat))
    private val FLOAT2 = TypeScheme(emptySet(), TFn(listOf(TFloat, TFloat), TFloat))
    val SIN_FN   = FLOAT1; val COS_FN   = FLOAT1; val TAN_FN   = FLOAT1
    val ASIN_FN  = FLOAT1; val ACOS_FN  = FLOAT1; val ATAN_FN  = FLOAT1
    val ATAN2_FN = FLOAT2; val EXP_FN   = FLOAT1; val LOG_FN   = FLOAT1
    val LOG2_FN  = FLOAT1; val LOG10_FN = FLOAT1

    // ── I/O ───────────────────────────────────────────────────────────────────
    val INPUT_FN    = TypeScheme(emptySet(), TFn(emptyList(), TString))
    val READ_LINE_FN = TypeScheme(emptySet(), TFn(emptyList(), TString))

    // ── Channels ──────────────────────────────────────────────────────────────
    val CHANNEL_FN = TypeScheme(setOf(-1), TFn(emptyList(), TChannel(T)))
    val SEND_FN    = TypeScheme(setOf(-1), TFn(listOf(TChannel(T), T), TUnit))
    val RECEIVE_FN = TypeScheme(setOf(-1), TFn(listOf(TChannel(T)), T))

    // ── Concurrency ───────────────────────────────────────────────────────────
    val CPU_COUNT   = TypeScheme(emptySet(), TFn(emptyList(), TInt))
    val SUPERVISE_FN = TypeScheme(setOf(-1), TFn(listOf(TProcess(T), TString, TInt, TInt), TUnit))

    // ── Network ───────────────────────────────────────────────────────────────
    val FETCH_FN  = TypeScheme(emptySet(), TFn(listOf(TString), TSumType(TString, TStruct("Error", mapOf("msg" to TString)))))
    val PARSE_JSON = TypeScheme(setOf(-1), TFn(listOf(TString), TSumType(T, TStruct("Error", mapOf("msg" to TString)))))

    // ── JSON / File I/O (error-flag style — no sum type wrapping) ─────────────
    val JSON_PARSE     = TypeScheme(setOf(-1), TFn(listOf(TString), T))
    val JSON_STRINGIFY = TypeScheme(setOf(-1), TFn(listOf(T), TString))
    val APPEND_FILE    = TypeScheme(emptySet(), TFn(listOf(TString, TString), TUnit))
    val FILE_EXISTS    = TypeScheme(emptySet(), TFn(listOf(TString), TBool))

    // ── HTTP (error-flag style) ──────────────────────────────────────────────
    val HTTP_GET  = TypeScheme(emptySet(), TFn(listOf(TString), TString))
    val HTTP_POST = TypeScheme(emptySet(), TFn(listOf(TString, TString, TString), TString))

    // ── Character operations ─────────────────────────────────────────────────
    val ORD_FN  = TypeScheme(emptySet(), TFn(listOf(TString), TInt))
    val CHR_FN  = TypeScheme(emptySet(), TFn(listOf(TInt), TString))

    // ── Time operations ─────────────────────────────────────────────────────
    val TIME_MS   = TypeScheme(emptySet(), TFn(emptyList(), TInt))
    val CLOCK_NS  = TypeScheme(emptySet(), TFn(emptyList(), TInt))
    val SLEEP_FN  = TypeScheme(emptySet(), TFn(listOf(TInt), TUnit))

    // ── Process control ──────────────────────────────────────────────────────
    val EXIT_FN = TypeScheme(emptySet(), TFn(listOf(TInt), TNothing))
    val ASSERT_FN = TypeScheme(emptySet(), TFn(listOf(TBool, TString), TUnit))
    val SYSTEM_FN = TypeScheme(emptySet(), TFn(listOf(TString), TInt))
    val EXEC_FN = TypeScheme(emptySet(), TFn(listOf(TString), TString))

    // ── Filesystem ────────────────────────────────────────────────────────────
    val MKDIR_FN      = TypeScheme(emptySet(), TFn(listOf(TString), TInt))
    val MKDIR_P_FN    = TypeScheme(emptySet(), TFn(listOf(TString), TInt))
    val PATH_JOIN_FN  = TypeScheme(emptySet(), TFn(listOf(TString, TString), TString))
    val PATH_EXISTS_FN = TypeScheme(emptySet(), TFn(listOf(TString), TInt))
    val PATH_PARENT_FN = TypeScheme(emptySet(), TFn(listOf(TString), TString))
    val PATH_NAME_FN  = TypeScheme(emptySet(), TFn(listOf(TString), TString))

    // ── Misc ──────────────────────────────────────────────────────────────────
    val BYTE_FN   = TypeScheme(emptySet(), TFn(listOf(TInt), TByte))
    val ERROR_FN  = TypeScheme(emptySet(), TFn(listOf(TString), TStruct("Error", mapOf("msg" to TString))))

    // ── Built-in method types (looked up by receiver type) ────────────────────
    val STRING_SPLIT  = TFn(listOf(TString), TList(TString))
    val STRING_LENGTH = TInt

    fun listMap(elemT: NovaType, retT: NovaType) = TFn(listOf(TFn(listOf(elemT), retT)), TList(retT))
    fun listFilter(elemT: NovaType) = TFn(listOf(TFn(listOf(elemT), TBool)), TList(elemT))
    fun listSum() = TFn(emptyList(), TInt)
    fun listLength() = TInt
    fun listTop(elemT: NovaType) = TFn(listOf(TInt), TList(elemT))

    // ── Full fn registry (name -> TypeScheme) ──────────────────────────────────
    val functions: Map<String, TypeScheme> = mapOf(
        // I/O
        "print"       to PRINT,
        "read_file"   to READ_FILE,
        "write_file"  to WRITE_FILE,
        "env"         to ENV,
        "input"       to INPUT_FN,
        "read_line"   to READ_LINE_FN,
        // Type conversions
        "str"         to STR_FN,
        "int"         to INT_FN,
        "float"       to FLOAT_FN,
        "bool"        to BOOL_FN,
        "byte"        to BYTE_FN,
        "type"        to TYPE_FN,
        "parse_int"   to PARSE_INT,
        "parse_float" to PARSE_FLOAT,
        // Collections
        "len"         to LEN_FN,
        "range"       to RANGE_FN,
        // Numeric
        "abs"         to ABS_FN,
        "max"         to MAX_FN,
        "min"         to MIN_FN,
        "sqrt"        to SQRT_FN,
        "pow"         to POW_FN,
        "round"       to ROUND_FN,
        "floor"       to FLOOR_FN,
        "ceil"        to CEIL_FN,
        // Trig (used inside math.nova)
        "sin"         to SIN_FN,
        "cos"         to COS_FN,
        "tan"         to TAN_FN,
        "asin"        to ASIN_FN,
        "acos"        to ACOS_FN,
        "atan"        to ATAN_FN,
        "atan2"       to ATAN2_FN,
        "exp"         to EXP_FN,
        "log"         to LOG_FN,
        "log2"        to LOG2_FN,
        "log10"       to LOG10_FN,
        // Channels / concurrency
        "channel"     to CHANNEL_FN,
        "send"        to SEND_FN,
        "receive"     to RECEIVE_FN,
        "cpu_count"   to CPU_COUNT,
        "supervise"   to SUPERVISE_FN,
        // Network
        "fetch"       to FETCH_FN,
        "parse_json"  to PARSE_JSON,
        // JSON / File I/O (error-flag style)
        "json_parse"     to JSON_PARSE,
        "json_stringify" to JSON_STRINGIFY,
        "append_file"    to APPEND_FILE,
        "file_exists"    to FILE_EXISTS,
        // HTTP
        "http_get"       to HTTP_GET,
        "http_post"      to HTTP_POST,
        // Character operations
        "ord"         to ORD_FN,
        "chr"         to CHR_FN,
        // Process control
        "exit"        to EXIT_FN,
        "assert"      to ASSERT_FN,
        "system"      to SYSTEM_FN,
        "exec"        to EXEC_FN,
        // Filesystem
        "mkdir"       to MKDIR_FN,
        "mkdir_p"     to MKDIR_P_FN,
        "path_join"   to PATH_JOIN_FN,
        "path_exists" to PATH_EXISTS_FN,
        "path_parent" to PATH_PARENT_FN,
        "path_name"   to PATH_NAME_FN,
        // Time
        "time_ms"     to TIME_MS,
        "clock_ns"    to CLOCK_NS,
        "sleep"       to SLEEP_FN,
        // Misc
        "Error"       to ERROR_FN,
    )

    // ── Stdlib module registries ──────────────────────────────────────────────
    // Maps module name -> (function name -> TypeScheme).
    // Used by TypeInferer when it processes "import math", "import list", etc.
    // so that qualified calls like math.gcd(a, b) resolve to concrete types.

    private val T1 = tv(1); private val T2 = tv(2)

    val modules: Map<String, Map<String, TypeScheme>> = mapOf(

        "math" to mapOf(
            "pi"         to TypeScheme(emptySet(), TFn(emptyList(), TFloat)),
            "e"          to TypeScheme(emptySet(), TFn(emptyList(), TFloat)),
            "tau"        to TypeScheme(emptySet(), TFn(emptyList(), TFloat)),
            "inf"        to TypeScheme(emptySet(), TFn(emptyList(), TFloat)),
            "sine"       to TypeScheme(emptySet(), TFn(listOf(TFloat), TFloat)),
            "cosine"     to TypeScheme(emptySet(), TFn(listOf(TFloat), TFloat)),
            "tangent"    to TypeScheme(emptySet(), TFn(listOf(TFloat), TFloat)),
            "arc_sin"    to TypeScheme(emptySet(), TFn(listOf(TFloat), TFloat)),
            "arc_cos"    to TypeScheme(emptySet(), TFn(listOf(TFloat), TFloat)),
            "arc_tan"    to TypeScheme(emptySet(), TFn(listOf(TFloat), TFloat)),
            "arc_tan2"   to TypeScheme(emptySet(), TFn(listOf(TFloat, TFloat), TFloat)),
            "exp_val"    to TypeScheme(emptySet(), TFn(listOf(TFloat), TFloat)),
            "ln"         to TypeScheme(emptySet(), TFn(listOf(TFloat), TFloat)),
            "log_2"      to TypeScheme(emptySet(), TFn(listOf(TFloat), TFloat)),
            "log_10"     to TypeScheme(emptySet(), TFn(listOf(TFloat), TFloat)),
            "power"      to TypeScheme(emptySet(), TFn(listOf(TFloat, TFloat), TFloat)),
            "round_val"  to TypeScheme(emptySet(), TFn(listOf(TFloat), TInt)),
            "floor_val"  to TypeScheme(emptySet(), TFn(listOf(TFloat), TInt)),
            "ceil_val"   to TypeScheme(emptySet(), TFn(listOf(TFloat), TInt)),
            "clamp"      to TypeScheme(setOf(-1), TFn(listOf(T1, T1, T1), T1)),
            "lerp"       to TypeScheme(emptySet(), TFn(listOf(TFloat, TFloat, TFloat), TFloat)),
            "sign"       to TypeScheme(emptySet(), TFn(listOf(TFloat), TInt)),
            "is_even"    to TypeScheme(emptySet(), TFn(listOf(TInt), TBool)),
            "is_odd"     to TypeScheme(emptySet(), TFn(listOf(TInt), TBool)),
            "gcd"        to TypeScheme(emptySet(), TFn(listOf(TInt, TInt), TInt)),
            "lcm"        to TypeScheme(emptySet(), TFn(listOf(TInt, TInt), TInt)),
            "factorial"  to TypeScheme(emptySet(), TFn(listOf(TInt), TInt)),
            "fib"        to TypeScheme(emptySet(), TFn(listOf(TInt), TInt)),
            "sum_range"  to TypeScheme(emptySet(), TFn(listOf(TInt, TInt), TInt)),
            "deg_to_rad" to TypeScheme(emptySet(), TFn(listOf(TFloat), TFloat)),
            "rad_to_deg" to TypeScheme(emptySet(), TFn(listOf(TFloat), TFloat)),
        ),

        "list" to mapOf(
            "length"    to TypeScheme(setOf(-1), TFn(listOf(TList(T1)), TInt)),
            "reverse"   to TypeScheme(setOf(-1), TFn(listOf(TList(T1)), TList(T1))),
            "sort"      to TypeScheme(setOf(-1), TFn(listOf(TList(T1)), TList(T1))),
            "sum"       to TypeScheme(emptySet(), TFn(listOf(TList(TInt)), TInt)),
            "product"   to TypeScheme(emptySet(), TFn(listOf(TList(TInt)), TInt)),
            "contains"  to TypeScheme(setOf(-1), TFn(listOf(TList(T1), T1), TBool)),
            "index_of"  to TypeScheme(setOf(-1), TFn(listOf(TList(T1), T1), TInt)),
            "min_val"   to TypeScheme(emptySet(), TFn(listOf(TList(TInt)), TInt)),
            "max_val"   to TypeScheme(emptySet(), TFn(listOf(TList(TInt)), TInt)),
            "take"      to TypeScheme(setOf(-1), TFn(listOf(TList(T1), TInt), TList(T1))),
            "drop"      to TypeScheme(setOf(-1), TFn(listOf(TList(T1), TInt), TList(T1))),
            "range"     to TypeScheme(emptySet(), TFn(listOf(TInt, TInt), TList(TInt))),
            "map"       to TypeScheme(setOf(-1, -2), TFn(listOf(TList(T1), TFn(listOf(T1), T2)), TList(T2))),
            "filter"    to TypeScheme(setOf(-1), TFn(listOf(TList(T1), TFn(listOf(T1), TBool)), TList(T1))),
        ),

        "string" to mapOf(
            "length"      to TypeScheme(emptySet(), TFn(listOf(TString), TInt)),
            "upper"       to TypeScheme(emptySet(), TFn(listOf(TString), TString)),
            "lower"       to TypeScheme(emptySet(), TFn(listOf(TString), TString)),
            "trim"        to TypeScheme(emptySet(), TFn(listOf(TString), TString)),
            "contains"    to TypeScheme(emptySet(), TFn(listOf(TString, TString), TBool)),
            "starts_with" to TypeScheme(emptySet(), TFn(listOf(TString, TString), TBool)),
            "ends_with"   to TypeScheme(emptySet(), TFn(listOf(TString, TString), TBool)),
            "find"        to TypeScheme(emptySet(), TFn(listOf(TString, TString), TInt)),
            "replace"     to TypeScheme(emptySet(), TFn(listOf(TString, TString, TString), TString)),
            "split"       to TypeScheme(emptySet(), TFn(listOf(TString, TString), TList(TString))),
            "join"        to TypeScheme(emptySet(), TFn(listOf(TList(TString), TString), TString)),
            "slice"       to TypeScheme(emptySet(), TFn(listOf(TString, TInt, TInt), TString)),
            "chars"       to TypeScheme(emptySet(), TFn(listOf(TString), TList(TString))),
            "repeat"      to TypeScheme(emptySet(), TFn(listOf(TString, TInt), TString)),
            "reverse"     to TypeScheme(emptySet(), TFn(listOf(TString), TString)),
            "is_empty"    to TypeScheme(emptySet(), TFn(listOf(TString), TBool)),
            "pad_left"    to TypeScheme(emptySet(), TFn(listOf(TString, TInt, TString), TString)),
            "pad_right"   to TypeScheme(emptySet(), TFn(listOf(TString, TInt, TString), TString)),
        ),

        "io" to mapOf(
            "input"       to TypeScheme(emptySet(), TFn(emptyList(), TString)),
            "slurp"       to TypeScheme(emptySet(), TFn(listOf(TString), TString)),
            "spit"        to TypeScheme(emptySet(), TFn(listOf(TString, TString), TUnit)),
            "println"     to TypeScheme(setOf(-1), TFn(listOf(T1), TUnit)),
            "prompt"      to TypeScheme(emptySet(), TFn(listOf(TString), TString)),
            "file_exists" to TypeScheme(emptySet(), TFn(listOf(TString), TBool)),
        ),
    )
}
