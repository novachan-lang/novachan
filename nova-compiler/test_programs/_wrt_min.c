/* Minimal NOVA wasm runtime: enough for string-LITERAL length. A string literal is a bare char* in wasm
   data memory, so len/len_any just measures it. (Heap string BUILDING -- create_string/concat -- needs the
   value-model port; this is the smallest real string-in-wasm step.) */
typedef long long i64;
static i64 _slen(i64 h){ if(!h) return 0; const char* s=(const char*)(unsigned long)h; i64 n=0; while(s[n]) n++; return n; }
i64 nova_rt_len_any(i64 h){ return _slen(h); }
i64 nova_rt_len(i64 h){ return _slen(h); }
