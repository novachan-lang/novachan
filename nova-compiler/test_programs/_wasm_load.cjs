// Generic loader: run a NOVA wasm32 program through the REUSABLE JS-managed
// linear-memory runtime (_wasm_runtime.cjs). Prints the program's output (one line
// per nova print). Usage: node _wasm_load.cjs <program.wasm>
"use strict";
const fs = require("fs");
const { createRuntime } = require("./_wasm_runtime.cjs");

const wasmPath = process.argv[2];
if (!wasmPath) { console.error("usage: node _wasm_load.cjs <program.wasm>"); process.exit(2); }

const rt = createRuntime();
WebAssembly.instantiate(fs.readFileSync(wasmPath), { env: rt.imports })
  .then(({ instance }) => {
    rt.init(instance);                  // binds memory + bump pointer (from __heap_base)
    instance.exports.nova_user_main();  // print_str already logs each line
  })
  .catch((e) => { console.error("wasm run error:", e); process.exit(1); });
