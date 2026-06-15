
/* ── Unicode canonical normalization (NFC/NFD) ────────────────────────────────
   Correct per UAX-15 over the full canonical tables above (Unicode 14.0): Hangul
   handled algorithmically, all other canonical decompositions/compositions from
   the generated tables. Codepoints with no canonical mapping pass through. */
static int nova_unorm_ccc(int32_t cp) {
    int lo=0, hi=NOVA_CCC_COUNT-1;
    while (lo<=hi){ int m=(lo+hi)>>1; int32_t k=nova_ccc_table[m].cp;
        if (k==cp) return nova_ccc_table[m].ccc; if (k<cp) lo=m+1; else hi=m-1; }
    return 0;
}
static const NovaDecompEntry* nova_unorm_decomp_find(int32_t cp) {
    int lo=0, hi=NOVA_DECOMP_COUNT-1;
    while (lo<=hi){ int m=(lo+hi)>>1; int32_t k=nova_decomp_table[m].cp;
        if (k==cp) return &nova_decomp_table[m]; if (k<cp) lo=m+1; else hi=m-1; }
    return NULL;
}
static int32_t nova_unorm_compose_pair(int32_t a, int32_t b) {
    if (a>=0x1100 && a<=0x1112 && b>=0x1161 && b<=0x1175)            /* Hangul L+V */
        return 0xAC00 + ((a-0x1100)*21 + (b-0x1161))*28;
    if (a>=0xAC00 && a<=0xD7A3 && ((a-0xAC00)%28)==0 && b>=0x11A8 && b<=0x11C2) /* LV+T */
        return a + (b-0x11A7);
    int lo=0, hi=NOVA_COMP_COUNT-1;
    while (lo<=hi){ int m=(lo+hi)>>1; int32_t ka=nova_comp_table[m].a, kb=nova_comp_table[m].b;
        if (ka==a && kb==b) return nova_comp_table[m].cp;
        if (ka<a || (ka==a && kb<b)) lo=m+1; else hi=m-1; }
    return -1;
}
static void nova_unorm_decompose_into(int32_t cp, int32_t* out, int* n, int cap) {
    if (cp>=0xAC00 && cp<=0xD7A3) {                                  /* Hangul algorithmic */
        int s=cp-0xAC00, t=s%28;
        if (*n<cap) out[(*n)++]=0x1100 + s/588;
        if (*n<cap) out[(*n)++]=0x1161 + (s%588)/28;
        if (t && *n<cap) out[(*n)++]=0x11A7 + t;
        return;
    }
    const NovaDecompEntry* e = nova_unorm_decomp_find(cp);            /* table = full NFD */
    if (e) {
        if (e->d0 && *n<cap) out[(*n)++]=e->d0;
        if (e->d1 && *n<cap) out[(*n)++]=e->d1;
        if (e->d2 && *n<cap) out[(*n)++]=e->d2;
        if (e->d3 && *n<cap) out[(*n)++]=e->d3;
        return;
    }
    if (*n<cap) out[(*n)++]=cp;
}
static void nova_unorm_canonical_order(int32_t* a, int n) {
    int i=0;
    while (i<n) {
        if (nova_unorm_ccc(a[i])==0) { i++; continue; }
        int j=i; while (j<n && nova_unorm_ccc(a[j])>0) j++;
        for (int p=i+1; p<j; p++) {                                  /* stable insertion sort by CCC */
            int32_t v=a[p]; int vc=nova_unorm_ccc(v); int q=p-1;
            while (q>=i && nova_unorm_ccc(a[q])>vc) { a[q+1]=a[q]; q--; }
            a[q+1]=v;
        }
        i=j;
    }
}
static int nova_unorm_canonical_compose(int32_t* a, int n) {
    if (n==0) return 0;
    int dest=1;
    int starter = (nova_unorm_ccc(a[0])==0) ? 0 : -1;
    int lastCC = nova_unorm_ccc(a[0]);
    for (int i=1; i<n; i++) {
        int32_t ch=a[i]; int cc=nova_unorm_ccc(ch); int32_t comp=-1;
        if (starter>=0 && (lastCC==0 || lastCC<cc)) comp = nova_unorm_compose_pair(a[starter], ch);
        if (comp>=0) { a[starter]=comp; }                            /* ch consumed; lastCC unchanged */
        else { if (cc==0) starter=dest; lastCC=cc; a[dest++]=ch; }
    }
    return dest;
}
static int64_t nova_unorm_run(int64_t s_val, int do_compose) {
    const unsigned char* s=(const unsigned char*)(uintptr_t)s_val;
    if (!s) return (int64_t)(uintptr_t)nova_fat_str_create("", 0);
    size_t len=strlen((const char*)s), i=0; int ncp=0;
    while (i<len){ size_t j=i; int64_t cp=nova_utf8_decode(s,len,&j); if(cp<0){i++;}else{i=j;} ncp++; }
    if (ncp==0) return (int64_t)(uintptr_t)nova_fat_str_create("", 0);
    int cap=ncp*4+8;                                                  /* canonical NFD expands <=4x */
    int32_t* buf=(int32_t*)malloc((size_t)cap*sizeof(int32_t));
    if (!buf) return s_val;                                           /* OOM: pass through */
    int n=0; i=0;
    while (i<len){ size_t j=i; int64_t cp=nova_utf8_decode(s,len,&j); int32_t c;
        if(cp<0){c=(int32_t)s[i];i++;}else{c=(int32_t)cp;i=j;} nova_unorm_decompose_into(c,buf,&n,cap); }
    nova_unorm_canonical_order(buf,n);
    if (do_compose) n=nova_unorm_canonical_compose(buf,n);
    char* out=(char*)malloc((size_t)n*4+1);
    if (!out){ free(buf); return s_val; }
    size_t bl=0;
    for (int k=0;k<n;k++){ char tmp[5]; int w=nova_utf8_encode(buf[k],tmp); for(int q=0;q<w;q++) out[bl++]=tmp[q]; }
    out[bl]='\0';
    int64_t r=(int64_t)(uintptr_t)nova_fat_str_create(out, bl);
    free(out); free(buf);
    return r;
}
int64_t nova_rt_normalize_nfd(int64_t s) { return nova_unorm_run(s, 0); }
int64_t nova_rt_normalize_nfc(int64_t s) { return nova_unorm_run(s, 1); }
