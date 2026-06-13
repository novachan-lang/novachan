// NOVA WASM Sieve of Eratosthenes -- JS-managed linear-memory runtime harness
// Provides the 5 imported runtime functions over the wasm32 linear memory.

const fs = require("fs");
const wasmPath = __dirname + "/wasm_sieve.wasm";
const wasmBytes = fs.readFileSync(wasmPath);

// ── Bump allocator state ──────────────────────────────────────────────
let bumpPtr = 0; // initialised after instantiation
let memory;      // WebAssembly.Memory
let dv;          // DataView over memory.buffer

function refreshDV() {
  dv = new DataView(memory.buffer);
}

function ensureMemory(needed) {
  while (bumpPtr + needed > memory.buffer.byteLength) {
    memory.grow(1); // +64 KiB
    refreshDV();
  }
}

function bumpAlloc(bytes) {
  // Align to 8 bytes
  const aligned = (bumpPtr + 7) & ~7;
  ensureMemory(aligned + bytes - bumpPtr);
  bumpPtr = aligned + bytes;
  return aligned;
}

// ── Collected output for self-check ───────────────────────────────────
const printed = [];

// ── Runtime functions ─────────────────────────────────────────────────

// NovaList layout on wasm32 (C struct with int64_t* data, int64_t size, int64_t cap):
//   offset 0 : data pointer   (i32, 4 bytes; padded to 8 for alignment)
//   offset 8 : size            (i64, 8 bytes)
//   offset 16: cap             (i64, 8 bytes)
// Total struct: 24 bytes.  Elements in data array are i64 (8 bytes each).

function nova_rt_list_create() {
  const initCap = 8;
  // Allocate struct (24 bytes)
  const structPtr = bumpAlloc(24);
  // Allocate data array (initCap * 8 bytes)
  const dataPtr = bumpAlloc(initCap * 8);
  // Write data pointer at struct+0 (i32)
  dv.setUint32(structPtr, dataPtr, true);
  // Write size = 0 at struct+8 (i64 LE)
  dv.setBigInt64(structPtr + 8, 0n, true);
  // Write cap = initCap at struct+16 (i64 LE)
  dv.setBigInt64(structPtr + 16, BigInt(initCap), true);
  // Return struct pointer as i64 (BigInt)
  return BigInt(structPtr);
}

function nova_rt_list_append_no_rc(listI64, elemI64) {
  const lp = Number(listI64 & 0xFFFFFFFFn);
  let size = dv.getBigInt64(lp + 8, true);
  let cap  = dv.getBigInt64(lp + 16, true);
  let dp   = dv.getUint32(lp, true); // data pointer (i32)

  if (size >= cap) {
    // Grow: allocate new array with 2*cap
    const newCap = cap * 2n;
    const newDataPtr = bumpAlloc(Number(newCap) * 8);
    // Copy old elements
    const oldBytes = Number(size) * 8;
    const src = new Uint8Array(memory.buffer, dp, oldBytes);
    const dst = new Uint8Array(memory.buffer, newDataPtr, oldBytes);
    dst.set(src);
    // Update struct
    dp = newDataPtr;
    dv.setUint32(lp, newDataPtr, true);
    cap = newCap;
    dv.setBigInt64(lp + 16, newCap, true);
  }

  // Store element at data + size*8
  const offset = dp + Number(size) * 8;
  dv.setBigInt64(offset, elemI64, true);
  // Increment size
  size += 1n;
  dv.setBigInt64(lp + 8, size, true);

  return 0n;
}

function nova_rt_unbox_elem(elem) {
  // For raw integer elements (0, 1 in the sieve), identity passthrough
  return elem;
}

function nova_rt_int_to_str(n) {
  const s = n.toString();
  const bytes = Buffer.from(s, "utf-8");
  const ptr = bumpAlloc(bytes.length + 1);
  const arr = new Uint8Array(memory.buffer, ptr, bytes.length + 1);
  arr.set(bytes);
  arr[bytes.length] = 0; // NUL terminator
  return BigInt(ptr);
}

function nova_rt_print_str(strPtr) {
  const addr = Number(strPtr & 0xFFFFFFFFn);
  const mem = new Uint8Array(memory.buffer);
  let end = addr;
  while (mem[end] !== 0) end++;
  const text = Buffer.from(mem.slice(addr, end)).toString("utf-8");
  printed.push(text);   // collect (the program prints each prime; we summarize below)
  return 0n;
}

// ── Instantiate and run ───────────────────────────────────────────────

(async () => {
  const importObject = {
    env: {
      nova_rt_list_create,
      nova_rt_list_append_no_rc,
      nova_rt_unbox_elem,
      nova_rt_int_to_str,
      nova_rt_print_str,
    },
  };

  const { instance } = await WebAssembly.instantiate(wasmBytes, importObject);
  memory = instance.exports.memory;

  // Start bump allocator after any static data.
  // No __heap_base export, so use a safe high offset (page 1 start).
  bumpPtr = 65536;
  ensureMemory(0);
  refreshDV();

  // Run the sieve
  instance.exports.nova_user_main();

  // ── Self-check: primes <= 1000 = 168 of them, first 2, last 997. n=1000 is
  //    too large for clang to const-fold, so the sieve GENUINELY computes in wasm. ─
  const head = ["2","3","5","7","11","13","17","19","23","29"];
  const ok = printed.length === 168 &&
             head.every((v, i) => v === printed[i]) &&
             printed[167] === "997";
  if (ok) {
    console.log("primes <= 1000 from wasm sieve: " + printed.slice(0, 10).join(" ") +
                " ... " + printed[167] + "  (" + printed.length + " total)");
    console.log("PASS: wasm sieve computed " + printed.length + " primes correctly in wasm32.");
    process.exit(0);
  } else {
    console.error("FAIL: expected 168 primes (first 2, last 997); got " + printed.length +
                  " [first=" + printed[0] + ", last=" + printed[printed.length - 1] + "]");
    process.exit(1);
  }
})();
