const fs=require('fs');
const mod=new WebAssembly.Module(fs.readFileSync('wasm_demo.wasm'));
const imp={};
for(const i of WebAssembly.Module.imports(mod)){ (imp[i.module]=imp[i.module]||{})[i.name]=()=>0n; }
const x=new WebAssembly.Instance(mod,imp).exports;
const a=x.nova_add(2n,3n), m=x.nova_mul(4n,5n), p=x.nova_poly(6n);
console.log('nova_add(2,3)='+a+' nova_mul(4,5)='+m+' nova_poly(6)='+p);
console.log((a===5n && m===20n && p===43n)?'WASM-PASS':'WASM-FAIL');
