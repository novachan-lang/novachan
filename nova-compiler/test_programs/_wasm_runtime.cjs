// _wasm_runtime.cjs -- Reusable JS-managed linear-memory runtime for NOVA wasm32 programs.
//
// Provides every nova_rt_* import needed by the common builtins (lists, strings, floats, print).
// The runtime manages a bump allocator over the wasm instance's exported memory. All NOVA values
// are i64 (BigInt in JS). Pointers are the low 32 bits. Strings are NUL-terminated in linear memory.
//
// USAGE:
//   const { createRuntime } = require("./_wasm_runtime.cjs");
//   const rt = createRuntime();
//   const { instance } = await WebAssembly.instantiate(wasmBytes, { env: rt.imports });
//   rt.init(instance);                     // binds memory + sets bump pointer
//   instance.exports.nova_user_main();     // run the program
//   const lines = rt.getOutput();          // collected printed lines
//
// LAYOUT NOTES:
//   NovaList (wasm32): { data: i32 @+0 (padded to 8), size: i64 @+8, cap: i64 @+16 } = 24 bytes
//   Elements are i64 (8 bytes each).
//   Strings: NUL-terminated bytes at the pointer. Literals live in wasm data section.
//   Float-to-str: "%.15g" format, append ".0" if no '.' or 'e' (matches nova_runtime.c).
//   int-to-str: decimal, supports negative.
//   Bump allocator: never frees (fine for short-lived wasm runs). memory.grow refreshes views.

"use strict";

// ─────────────────────────────────────────────────────────────────────────────
// SOUNDNESS BOUNDARY (read before relying on this in production):
//   This is a BEST-EFFORT JS coverage runtime for the `nova wasm` target, NOT the
//   production runtime. It has NO value tags, so the polymorphic ops (nova_rt_add /
//   any_to_str / contains) cannot always tell a medium/large INTEGER from a STRING
//   POINTER (on wasm32, linear-memory string pointers live at LOW addresses that
//   overlap common integer values). Result: programs that route integers >= 256
//   (whose low-32 bits land on a printable data-section byte) through these untyped
//   polymorphic ops can DIVERGE from native output. SOUND today: structs, all dict
//   ops, small-int values (< 256), and runtime-allocated strings (tracked exactly in
//   bumpStrs). The production fix is the tagged C-runtime-compiled-to-wasm path (m7),
//   which carries NOVA's real value tags. The native runtime is unaffected and sound.
// ─────────────────────────────────────────────────────────────────────────────

function createRuntime() {
  let memory = null;   // WebAssembly.Memory
  let dv = null;       // DataView
  let u8 = null;       // Uint8Array
  let bumpPtr = 0;

  const printed = [];  // collected output lines

  // Every pointer the runtime itself allocates as a STRING is recorded here, so the
  // polymorphic companions (add / any_to_str) identify dynamically-created strings
  // SOUNDLY (no guessing). The only residual string/int ambiguity is data-section
  // string LITERALS (which the linker placed and the runtime never sees allocated) —
  // those fall back to a range+printable-byte heuristic. See isLikelyString.
  const bumpStrs = new Set();

  // ── Memory helpers ─────────────────────────────────────────────────────
  function refreshViews() {
    dv = new DataView(memory.buffer);
    u8 = new Uint8Array(memory.buffer);
  }

  function ensureMemory(needed) {
    while (bumpPtr + needed > memory.buffer.byteLength) {
      memory.grow(1); // +64 KiB
      refreshViews();
    }
  }

  function bumpAlloc(bytes) {
    const aligned = (bumpPtr + 7) & ~7;
    ensureMemory(aligned + bytes - bumpPtr);
    bumpPtr = aligned + bytes;
    return aligned;
  }

  // ── String helpers ─────────────────────────────────────────────────────
  // Read a NUL-terminated string from linear memory at addr (i32).
  function readCStr(addr) {
    // After any alloc the u8 view might be detached, refresh if needed
    if (u8.buffer !== memory.buffer) refreshViews();
    let end = addr;
    while (u8[end] !== 0) end++;
    return Buffer.from(u8.slice(addr, end)).toString("utf-8");
  }

  // Write a JS string into linear memory, NUL-terminated. Returns the i32 pointer.
  function writeCStr(s) {
    const bytes = Buffer.from(s, "utf-8");
    const ptr = bumpAlloc(bytes.length + 1);
    // Views may have been refreshed by bumpAlloc
    if (u8.buffer !== memory.buffer) refreshViews();
    u8.set(bytes, ptr);
    u8[ptr + bytes.length] = 0;
    bumpStrs.add(ptr);   // record: this pointer is a runtime-allocated string
    return ptr;
  }

  // ── Runtime functions ──────────────────────────────────────────────────

  // -- Lists --

  function nova_rt_list_create() {
    const initCap = 8;
    const structPtr = bumpAlloc(24);
    const dataPtr = bumpAlloc(initCap * 8);
    if (dv.buffer !== memory.buffer) refreshViews();
    dv.setUint32(structPtr, dataPtr, true);       // data pointer (i32)
    dv.setBigInt64(structPtr + 8, 0n, true);      // size = 0
    dv.setBigInt64(structPtr + 16, BigInt(initCap), true); // cap
    return BigInt(structPtr);
  }

  function nova_rt_list_append_no_rc(listI64, elemI64) {
    const lp = Number(listI64 & 0xFFFFFFFFn);
    if (dv.buffer !== memory.buffer) refreshViews();
    let size = dv.getBigInt64(lp + 8, true);
    let cap  = dv.getBigInt64(lp + 16, true);
    let dp   = dv.getUint32(lp, true);

    if (size >= cap) {
      const newCap = cap * 2n;
      const newDataPtr = bumpAlloc(Number(newCap) * 8);
      if (u8.buffer !== memory.buffer) refreshViews();
      // Copy old elements
      const oldBytes = Number(size) * 8;
      new Uint8Array(memory.buffer, newDataPtr, oldBytes).set(
        new Uint8Array(memory.buffer, dp, oldBytes)
      );
      dp = newDataPtr;
      dv.setUint32(lp, newDataPtr, true);
      cap = newCap;
      dv.setBigInt64(lp + 16, newCap, true);
    }

    const offset = dp + Number(size) * 8;
    dv.setBigInt64(offset, elemI64, true);
    dv.setBigInt64(lp + 8, size + 1n, true);
    return 0n;
  }

  function nova_rt_unbox_elem(elem) {
    // For raw integer/float elements, identity passthrough.
    return elem;
  }

  // -- Strings --

  function nova_rt_int_to_str(n) {
    const s = n.toString();
    const ptr = writeCStr(s);
    return BigInt(ptr);
  }

  function nova_rt_str_concat(a, b) {
    const addrA = Number(a & 0xFFFFFFFFn);
    const addrB = Number(b & 0xFFFFFFFFn);
    const sA = readCStr(addrA);
    const sB = readCStr(addrB);
    const ptr = writeCStr(sA + sB);
    return BigInt(ptr);
  }

  function nova_rt_len_any(handle) {
    // For strings: return strlen. For lists: return size.
    const addr = Number(handle & 0xFFFFFFFFn);
    if (addr === 0) return 0n;
    // Heuristic: check if it looks like a list struct (data ptr in first 4 bytes pointing
    // within memory, size/cap as reasonable i64). For now, in our simple wasm programs,
    // len() is only called on strings -- use strlen.
    if (u8.buffer !== memory.buffer) refreshViews();
    let end = addr;
    while (end < u8.length && u8[end] !== 0) end++;
    return BigInt(end - addr);
  }

  function nova_rt_index_get(obj, index) {
    // Polymorphic dispatch (the IR optimizer specializes known container types away from
    // this, but an Any-typed container — e.g. d[k] where k came from keys() — lands here).
    if (isDictHandle(obj)) return nova_rt_dict_get(obj, index);   // dict: index is a key ptr (SOUND)
    const addr0 = Number(obj & 0xFFFFFFFFn);
    if (u8.buffer !== memory.buffer) refreshViews();
    // list? data@0(i32), size@8(i64), cap@16(i64). Distinguish from a string by a plausible
    // (size<=cap, cap bounded) header; a string's first 24 bytes rarely satisfy this.
    if (addr0 >= 256 && addr0 + 24 <= u8.length) {
      const size = dv.getBigInt64(addr0 + 8, true), cap = dv.getBigInt64(addr0 + 16, true);
      const dp = dv.getUint32(addr0, true);
      if (size >= 0n && cap > 0n && size <= cap && cap <= 0x100000n && dp >= 256 && dp < u8.length) {
        let i = Number(index); if (i < 0) i += Number(size);
        if (i < 0 || i >= Number(size)) return 0n;
        return dv.getBigInt64(dp + i * 8, true);
      }
    }
    // For strings: return single-character string at index.
    const addr = Number(obj & 0xFFFFFFFFn);
    const idx = Number(index);
    if (u8.buffer !== memory.buffer) refreshViews();
    // strlen
    let end = addr;
    while (end < u8.length && u8[end] !== 0) end++;
    const len = end - addr;
    let realIdx = idx;
    if (realIdx < 0) realIdx += len;
    if (realIdx < 0 || realIdx >= len) {
      const ptr = writeCStr("");
      return BigInt(ptr);
    }
    const ch = u8[addr + realIdx];
    const ptr = bumpAlloc(2);
    if (u8.buffer !== memory.buffer) refreshViews();
    u8[ptr] = ch;
    u8[ptr + 1] = 0;
    bumpStrs.add(ptr);
    return BigInt(ptr);
  }

  function nova_rt_print_str(strPtr) {
    const addr = Number(strPtr & 0xFFFFFFFFn);
    const text = readCStr(addr);
    printed.push(text);
    // Also print to stdout for harness visibility
    console.log(text);
    return 0n;
  }

  // -- Floats --

  function nova_rt_to_float(val) {
    // Convert integer value to float bits (i64). For small ints, this is just (double)val.
    // In wasm context, val is a raw i64 integer, not a pointer/box.
    const n = Number(val);
    const buf = Buffer.alloc(8);
    buf.writeDoubleBE(n, 0);
    // Read back as i64 BigInt (big-endian -> little-endian for wasm)
    const hi = buf.readUInt32BE(0);
    const lo = buf.readUInt32BE(4);
    return (BigInt(hi) << 32n) | BigInt(lo);
  }

  function nova_rt_float_to_str(bits) {
    // bits is an i64 containing the IEEE 754 double bits.
    // Format with %.15g, then append .0 if no '.' or 'e'/'E'.
    const buf = Buffer.alloc(8);
    buf.writeBigInt64LE(bits, 0);
    const v = buf.readDoubleLE(0);

    // Use toPrecision(15) to match %.15g behavior
    let s = formatG15(v);

    // If no '.' and no 'e'/'E', append '.0'
    if (!s.includes('.') && !s.includes('e') && !s.includes('E')) {
      s += '.0';
    }

    const ptr = writeCStr(s);
    return BigInt(ptr);
  }

  // Format a double like C's %.15g
  function formatG15(v) {
    if (!isFinite(v)) {
      if (v !== v) return "nan";
      return v > 0 ? "inf" : "-inf";
    }
    if (Object.is(v, -0)) return "-0";
    // toPrecision with 15 significant digits matches %.15g for most values.
    // However, toPrecision can produce different formatting than C's %g in edge cases.
    // We handle it carefully:
    let s = v.toPrecision(15);

    // Remove trailing zeros after '.' but before 'e', matching %g behavior
    if (s.includes('.') && !s.includes('e') && !s.includes('E')) {
      // Remove trailing zeros
      s = s.replace(/\.?0+$/, (match, offset) => {
        // Keep at least the '.' if all digits after it are zeros -- no, %g removes it
        if (match.startsWith('.')) return '';
        return '';
      });
      // If we removed everything after '.', remove the '.' too
      if (s.endsWith('.')) s = s.slice(0, -1);
    }

    // Handle exponential notation: toPrecision uses e+XX but C uses e+XX too.
    // Actually check: C %g uses e+01 format (at least 2 digits), JS uses e+1.
    // We need to normalize.
    if (s.includes('e+') || s.includes('e-')) {
      s = s.replace(/e([+-])(\d+)/, (_, sign, digits) => {
        // C printf pads exponent to at least 2 digits on some platforms, but
        // on most modern platforms it's minimal digits. Let's match native output.
        return 'e' + sign + digits;
      });
    }

    return s;
  }

  // -- Structs (linear memory, SOUND: no heuristic) --

  // Bump-allocate a struct's slots. Returns an i32 pointer (Number, NOT BigInt):
  // the LLVM IR declares nova_rt_struct_alloc as returning `ptr` (= i32 on wasm32)
  // and follows with `ptrtoint ptr to i64`. Slot 0 = type hash, slots 1.. = fields,
  // all i64; the compiler stores every slot right after, so no zero-init is required.
  function nova_rt_struct_alloc(sizeI64) {
    return bumpAlloc(Number(sizeI64));   // i32 (Number)
  }

  // -- Dicts (JS-side state; SOUND for string keys) --
  // The bump allocator can't realloc, so a NovaDict's growable internals can't live
  // in linear memory. Instead each dict is a JS object identified by a synthetic i64
  // handle (>= 0xF0000000, far above any realistic wasm32 heap pointer). FNV-1a hash +
  // open-addressing linear probe + dense insertion-ordered entries — matching native.
  let nextDictHandle = 0xF0000000n;
  const dicts = new Map();   // handle(BigInt) -> {keys,vals,hashes,size,idxCap,idx}

  function isDictHandle(v) { return v >= 0xF0000000n && dicts.has(v); }

  function dictHash(addr) {
    if (u8.buffer !== memory.buffer) refreshViews();
    let h = 0xCBF29CE484222325n;            // FNV offset basis
    let i = addr;
    while (u8[i] !== 0) { h ^= BigInt(u8[i]); h = BigInt.asUintN(64, h * 0x100000001B3n); i++; }
    return h;
  }
  function dictStrEq(a, b) {
    if (u8.buffer !== memory.buffer) refreshViews();
    let i = a, j = b;
    for (;;) { if (u8[i] !== u8[j]) return false; if (u8[i] === 0) return true; i++; j++; }
  }

  function nova_rt_dict_create() {
    const handle = nextDictHandle; nextDictHandle += 1n;
    dicts.set(handle, { keys: [], vals: [], hashes: [], size: 0, idxCap: 16, idx: new Array(16).fill(-1) });
    return handle;
  }
  function dictSetImpl(handle, keyI64, valI64) {
    const d = dicts.get(handle); if (!d) return 0n;
    const kAddr = Number(keyI64 & 0xFFFFFFFFn);
    const h = dictHash(kAddr); let mask = d.idxCap - 1; let slot = Number(h & BigInt(mask));
    while (d.idx[slot] !== -1) {
      const ei = d.idx[slot];
      if (d.hashes[ei] === h && dictStrEq(Number(d.keys[ei] & 0xFFFFFFFFn), kAddr)) { d.vals[ei] = valI64; return 0n; }
      slot = (slot + 1) & mask;
    }
    const ni = d.size; d.keys.push(keyI64); d.vals.push(valI64); d.hashes.push(h); d.idx[slot] = ni; d.size++;
    if (d.size * 3 >= d.idxCap * 2) {      // grow index at load factor 2/3 (matches native)
      d.idxCap *= 2; d.idx = new Array(d.idxCap).fill(-1); const nm = d.idxCap - 1;
      for (let i = 0; i < d.size; i++) { let s = Number(d.hashes[i] & BigInt(nm)); while (d.idx[s] !== -1) s = (s + 1) & nm; d.idx[s] = i; }
    }
    return 0n;
  }
  function nova_rt_dict_set(handle, k, v) { return dictSetImpl(handle, k, v); }
  function nova_rt_dict_set_no_rc(handle, k, v) { return dictSetImpl(handle, k, v); }  // no RC in wasm
  function nova_rt_dict_get(handle, keyI64) {
    const d = dicts.get(handle); if (!d) return 0n;
    const kAddr = Number(keyI64 & 0xFFFFFFFFn);
    const h = dictHash(kAddr); const mask = d.idxCap - 1; let slot = Number(h & BigInt(mask));
    while (d.idx[slot] !== -1) {
      const ei = d.idx[slot];
      if (d.hashes[ei] === h && dictStrEq(Number(d.keys[ei] & 0xFFFFFFFFn), kAddr)) return d.vals[ei];
      slot = (slot + 1) & mask;
    }
    return 0n;
  }
  function nova_rt_dict_has(handle, keyI64) {
    const d = dicts.get(handle); if (!d) return 0n;
    const kAddr = Number(keyI64 & 0xFFFFFFFFn);
    const h = dictHash(kAddr); const mask = d.idxCap - 1; let slot = Number(h & BigInt(mask));
    while (d.idx[slot] !== -1) {
      const ei = d.idx[slot];
      if (d.hashes[ei] === h && dictStrEq(Number(d.keys[ei] & 0xFFFFFFFFn), kAddr)) return 1n;
      slot = (slot + 1) & mask;
    }
    return 0n;
  }
  function nova_rt_dict_keys(handle) {
    const d = dicts.get(handle); const list = nova_rt_list_create();
    if (d) for (let i = 0; i < d.size; i++) nova_rt_list_append_no_rc(list, d.keys[i]);  // insertion order
    return list;
  }

  // -- Polymorphic companions --
  // string detection: SOUND for runtime-allocated strings (bumpStrs); for data-section
  // string LITERALS we fall back to a range+printable-byte heuristic. This residual
  // ambiguity is the same int/pointer problem the NATIVE runtime had pre-tag-fix
  // (project_int_pointer_soundness); the JS coverage runtime has no value tags. Real
  // programs that route LARGE integers (whose low-32 bits land on a printable data-section
  // byte) through these polymorphic ops can diverge from native — the tagged C-runtime-to-
  // wasm path (future m7) is the production fix. Programs with small ints (the common case)
  // and known-typed ops (which the compiler specializes away from these) are unaffected.
  function isLikelyString(addr) {
    if (bumpStrs.has(addr)) return true;            // SOUND: we allocated it as a string
    if (addr < 256 || addr >= 0xF0000000) return false;  // raw small int / dict-handle range
    if (u8.buffer !== memory.buffer) refreshViews();
    if (addr >= u8.length) return false;
    const c = u8[addr];                              // heuristic for data-section literals only
    return c === 0 || (c >= 0x20 && c < 0x7F);
  }

  function nova_rt_add(a, b) {
    const aAddr = Number(a & 0xFFFFFFFFn), bAddr = Number(b & 0xFFFFFFFFn);
    const aS = isLikelyString(aAddr), bS = isLikelyString(bAddr);
    if (aS || bS) {                                  // string concatenation
      const sa = aS ? readCStr(aAddr) : a.toString();
      const sb = bS ? readCStr(bAddr) : b.toString();
      return BigInt(writeCStr(sa + sb));
    }
    return BigInt.asIntN(64, a + b);                 // integer addition (wrap like native i64)
  }

  function nova_rt_any_to_str(val) {
    if (isDictHandle(val)) {                         // dict -> {"k": v, ...} (note: not full JSON-quoting)
      const d = dicts.get(val); const parts = [];
      for (let i = 0; i < d.size; i++) {
        const kStr = readCStr(Number(d.keys[i] & 0xFFFFFFFFn));
        const vStr = readCStr(Number(nova_rt_any_to_str(d.vals[i]) & 0xFFFFFFFFn));
        parts.push('"' + kStr + '": ' + vStr);
      }
      return BigInt(writeCStr('{' + parts.join(', ') + '}'));
    }
    const addr = Number(val & 0xFFFFFFFFn);
    if (isLikelyString(addr)) return val;            // already a string pointer
    return nova_rt_int_to_str(val);                  // decimal
  }

  function nova_rt_contains(container, item) {
    if (isDictHandle(container)) return nova_rt_dict_has(container, item);
    const addr = Number(container & 0xFFFFFFFFn);
    if (addr === 0) return 0n;
    if (u8.buffer !== memory.buffer) refreshViews();
    // list? (data@0,size@8,cap@16). element compare: for STRING elems compare by content
    // (matches native nova_rt_eq), else by value identity.
    try {
      const size = dv.getBigInt64(addr + 8, true), cap = dv.getBigInt64(addr + 16, true);
      if (size >= 0n && cap > 0n && size <= cap && cap <= 0x100000n) {
        const dp = dv.getUint32(addr, true); const n = Number(size);
        const itemIsStr = isLikelyString(Number(item & 0xFFFFFFFFn));
        for (let i = 0; i < n; i++) {
          const e = dv.getBigInt64(dp + i * 8, true);
          if (e === item) return 1n;
          if (itemIsStr && isLikelyString(Number(e & 0xFFFFFFFFn)) &&
              dictStrEq(Number(e & 0xFFFFFFFFn), Number(item & 0xFFFFFFFFn))) return 1n;
        }
        return 0n;
      }
    } catch (e) { /* not a list */ }
    return readCStr(addr).includes(readCStr(Number(item & 0xFFFFFFFFn))) ? 1n : 0n;  // substring
  }

  function nova_rt_list_append(listI64, elemI64) { return nova_rt_list_append_no_rc(listI64, elemI64); }

  // ── Import object builder ──────────────────────────────────────────────
  // Returns an object with ALL supported nova_rt_* functions.
  // Unused imports are harmless (wasm only pulls in what it declares).
  const imports = {
    nova_rt_list_create,
    nova_rt_list_append_no_rc,
    nova_rt_list_append,
    nova_rt_unbox_elem,
    nova_rt_int_to_str,
    nova_rt_str_concat,
    nova_rt_len_any,
    nova_rt_index_get,
    nova_rt_print_str,
    nova_rt_to_float,
    nova_rt_float_to_str,
    nova_rt_struct_alloc,
    nova_rt_dict_create,
    nova_rt_dict_set,
    nova_rt_dict_set_no_rc,
    nova_rt_dict_get,
    nova_rt_dict_has,
    nova_rt_dict_keys,
    nova_rt_add,
    nova_rt_any_to_str,
    nova_rt_contains,
  };

  // ── Initialization ─────────────────────────────────────────────────────
  function init(instance) {
    memory = instance.exports.memory;
    // Start bump allocator AFTER all static data (string literals etc.).
    // Use __heap_base if exported by wasm-ld; otherwise fall back to scanning.
    if (instance.exports.__heap_base) {
      bumpPtr = instance.exports.__heap_base.value;
    } else {
      // Conservative fallback: start at page 2 (128KiB) to avoid data section.
      bumpPtr = 131072;
    }
    // Align to 8 bytes
    bumpPtr = (bumpPtr + 7) & ~7;
    refreshViews();
    printed.length = 0;
    bumpStrs.clear();
    dicts.clear();
    nextDictHandle = 0xF0000000n;
  }

  function getOutput() {
    return [...printed];
  }

  return { imports, init, getOutput };
}

// Convenience entry for the `nova wasm` CLI's emitted loader: instantiate a wasm
// file with a fresh runtime, run nova_user_main, and report a clear error if the
// program uses a builtin this runtime does not yet provide.
function runFile(wasmPath) {
  const fs = require("fs");
  const rt = createRuntime();
  return WebAssembly.instantiate(fs.readFileSync(wasmPath), { env: rt.imports })
    .then(({ instance }) => { rt.init(instance); instance.exports.nova_user_main(); })
    .catch((e) => {
      if (e instanceof WebAssembly.LinkError) {
        const m = e.message.match(/function="([^"]+)"/);
        if (m) console.error("error: this program uses builtin '" + m[1] + "' which is not yet in _wasm_runtime.cjs.");
        else console.error("error: wasm link failed:", e.message);
      } else {
        console.error("error: wasm runtime error:", e.message || e);
      }
      process.exit(1);
    });
}

module.exports = { createRuntime, runFile };
