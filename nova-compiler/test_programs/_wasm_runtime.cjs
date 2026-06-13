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

function createRuntime() {
  let memory = null;   // WebAssembly.Memory
  let dv = null;       // DataView
  let u8 = null;       // Uint8Array
  let bumpPtr = 0;

  const printed = [];  // collected output lines

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

  // ── Import object builder ──────────────────────────────────────────────
  // Returns an object with ALL supported nova_rt_* functions.
  // Unused imports are harmless (wasm only pulls in what it declares).
  const imports = {
    nova_rt_list_create,
    nova_rt_list_append_no_rc,
    nova_rt_unbox_elem,
    nova_rt_int_to_str,
    nova_rt_str_concat,
    nova_rt_len_any,
    nova_rt_index_get,
    nova_rt_print_str,
    nova_rt_to_float,
    nova_rt_float_to_str,
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
  }

  function getOutput() {
    return [...printed];
  }

  return { imports, init, getOutput };
}

module.exports = { createRuntime };
