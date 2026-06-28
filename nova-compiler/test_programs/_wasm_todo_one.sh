#!/bin/bash
# WASM frontend todo-list gate: JS writes item strings into wasm memory (wasm_alloc), NOVA splits the joined
# list with the value-model (split) and re-renders the <ul> (dom_clear + dom_create/dom_set_text/dom_append).
# Adding milk/eggs/bread -> the <ul> ends with those 3 <li>. Linked with output/nova_runtime_wasm.o.
cd "$(dirname "$0")" || exit 1
./gen3_test.exe _wasm_todo.nova >/dev/null 2>&1
[ -f _wasm_todo.ll ] || { echo "FAIL wasm_todo: NOVA->LLVM"; exit 1; }
clang --target=wasm32 -ffreestanding -nostdlib -fno-builtin -O2 -c output/nova_runtime_wasm.c -o output/nova_runtime_wasm.o 2>/dev/null || { echo "FAIL wasm_todo: runtime"; exit 1; }
clang --target=wasm32 -O2 -fno-builtin -nostdlib -c _wasm_todo.ll -o _tprog.o 2>/dev/null || { echo "FAIL wasm_todo: prog"; exit 1; }
wasm-ld --no-entry --export-all --allow-undefined --gc-sections _tprog.o output/nova_runtime_wasm.o -o _todo.wasm 2>/dev/null
[ -f _todo.wasm ] || { echo "FAIL wasm_todo: link"; exit 1; }
node -e '
const fs=require("fs");
const m=new WebAssembly.Module(fs.readFileSync("_todo.wasm"));
let mem=null;
function readCStr(p){ const u=new Uint8Array(mem.buffer); let o=Number(BigInt.asUintN(32,BigInt(p))),e=o; while(u[e]!==0&&e<u.length)e++; return Buffer.from(u.subarray(o,e)).toString("utf8"); }
function mkEl(t){ return {tag:t,text:null,children:[]}; }
const ul=mkEl("ul"); const nodes=[null,ul]; const byId={list:1};
const imp={}; for(const i of WebAssembly.Module.imports(m)){ (imp[i.module]=imp[i.module]||{})[i.name]=()=>0n; }
imp.env=imp.env||{};
imp.env.dom_get_by_id=(p)=>BigInt(byId[readCStr(p)]||0);
imp.env.dom_create=(p)=>{ nodes.push(mkEl(readCStr(p))); return BigInt(nodes.length-1); };
imp.env.dom_set_text=(h,p)=>{ const n=nodes[Number(h)]; if(n)n.text=readCStr(p); return 0n; };
imp.env.dom_append=(ph,ch)=>{ const a=nodes[Number(ph)],b=nodes[Number(ch)]; if(a&&b)a.children.push(b); return 0n; };
imp.env.dom_clear=(h)=>{ const n=nodes[Number(h)]; if(n)n.children=[]; return 0n; };
const x=new WebAssembly.Instance(m,imp).exports; mem=x.memory;
function writeStr(s){ const ptr=Number(x.wasm_alloc(s.length+1)); const u8=new Uint8Array(mem.buffer); const b=Buffer.from(s,"utf8"); b.copy(u8,ptr); u8[ptr+b.length]=0; return ptr; }
function render(j){ x.render_items(BigInt(writeStr(j))); }
const items=[]; items.push("milk"); render(items.join("|")); items.push("eggs"); render(items.join("|")); items.push("bread"); render(items.join("|"));
const texts=ul.children.map(li=>li.text);
process.exit(JSON.stringify(texts)===JSON.stringify(["milk","eggs","bread"])?0:1);
' && echo "PASS wasm_todo (string-in + value-model split + DOM render: [milk,eggs,bread])" || echo "FAIL wasm_todo"
