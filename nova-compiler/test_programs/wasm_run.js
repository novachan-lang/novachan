// Minimal host for NOVA WASM modules.
// Provides the WASI proc_exit import that NOVA's wasm runtime stub calls.

const fs = require('fs');
const path = require('path');

async function main() {
  const wasmPath = process.argv[2] || 'wasm_demo.wasm';
  const bytes = fs.readFileSync(wasmPath);

  let exitCode = null;
  const wasiSnapshotPreview1 = {
    proc_exit: (code) => {
      exitCode = code;
      throw new Error('__nova_exit__');
    },
    fd_write: (fd, iovsPtr, iovsLen, nwrittenPtr) => 0,
    fd_close: () => 0,
    fd_seek: () => 0,
    environ_sizes_get: () => 0,
    environ_get: () => 0,
    args_sizes_get: () => 0,
    args_get: () => 0,
  };

  const { instance } = await WebAssembly.instantiate(bytes, {
    wasi_snapshot_preview1: wasiSnapshotPreview1,
  });

  console.log('WASM exports:', Object.keys(instance.exports).filter(k => !k.startsWith('__')).slice(0, 10).join(', '));

  // NOVA exports `nova_user_main` (for non-extern main) or _start (WASI entry)
  const entry = instance.exports.nova_user_main || instance.exports._start;
  if (!entry) {
    console.error('No nova_user_main or _start export found');
    process.exit(1);
  }

  console.log('Calling NOVA main...');
  try {
    const result = entry();
    console.log('Return value:', result);
    console.log('Exit code:', exitCode);
  } catch (e) {
    if (e.message === '__nova_exit__') {
      console.log('Exited with code:', exitCode);
    } else {
      throw e;
    }
  }
}

main().catch(e => { console.error(e); process.exit(1); });
