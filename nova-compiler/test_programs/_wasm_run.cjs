// WASM milestone-1 harness: instantiate the NOVA-compiled wasm32 module and verify
// a real f64 computation through it. The single import nova_rt_unbox is the minimal
// runtime shim: a raw double (passed as its i64 bit pattern) unboxes to itself.
const fs = require('fs');
const dv = new DataView(new ArrayBuffer(8));
const f2b = f => { dv.setFloat64(0, f, true); return dv.getBigInt64(0, true); };
const b2f = b => { dv.setBigInt64(0, b, true); return dv.getFloat64(0, true); };
const imports = { env: { nova_rt_unbox: (x) => x } };
WebAssembly.instantiate(fs.readFileSync('wasm_m1.wasm'), imports).then(({ instance }) => {
  const got = b2f(instance.exports.compute(f2b(1.5), f2b(2.5)));
  const want = 1.5 * 2.5 + 1.5;
  console.log("NOVA->wasm32 compute(1.5,2.5) =", got, "(want " + want + ")");
  process.exit(Math.abs(got - want) < 1e-12 ? 0 : 1);
}).catch(e => { console.error(e); process.exit(1); });
