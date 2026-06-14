"use strict";
const fs = require("fs");
const { createRuntime } = require("./_wasm_runtime.cjs");
let flag = 0;
const rt = createRuntime();
rt.imports.host_flag = (v) => { flag = Number(v); return 0n; };
WebAssembly.instantiate(fs.readFileSync("_wasm_cb_probe.wasm"), { env: rt.imports })
  .then(({instance})=>{
    rt.init(instance);
    console.log("exports has on_click: " + (typeof instance.exports.on_click === "function"));
    instance.exports.nova_user_main();        // sets flag=1
    const afterMain = flag;
    instance.exports.on_click();               // HOST calls back into NOVA -> sets flag=42
    const afterClick = flag;
    if (afterMain===1 && afterClick===42) { console.log("CB_OK afterMain="+afterMain+" afterClick="+afterClick); process.exit(0); }
    console.log("CB_FAIL afterMain="+afterMain+" afterClick="+afterClick); process.exit(1);
  }).catch(e=>{ console.error("err",e); process.exit(1); });
