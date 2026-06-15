import unicodedata
HANGUL=range(0xAC00,0xD7A4)
decomps=[];cccs=[];comps=[]
for cp in range(0x110000):
    c=chr(cp)
    cc=unicodedata.combining(c)
    if cc: cccs.append((cp,cc))
    if cp in HANGUL: continue
    nfd=unicodedata.normalize('NFD',c)
    if nfd!=c:
        ds=[ord(x) for x in nfd]
        while len(ds)<4: ds.append(0)
        decomps.append((cp,ds))
    d=unicodedata.decomposition(c)
    if d and not d.startswith('<'):
        parts=[int(x,16) for x in d.split()]
        if len(parts)==2:
            a,b=parts
            if a not in HANGUL and unicodedata.normalize('NFC',chr(a)+chr(b))==c:
                comps.append((a,b,cp))
decomps.sort(key=lambda e:e[0])
cccs.sort(key=lambda e:e[0])
comps.sort(key=lambda e:(e[0],e[1]))
out=[]
out.append("/* Unicode %s canonical normalization tables - GENERATED (do not edit by hand)."%unicodedata.unidata_version)
out.append("   decomp: full canonical NFD (Hangul excluded, handled algorithmically), sorted by cp.")
out.append("   ccc: canonical combining class, sorted by cp. comp: primary composites, sorted by (a,b). */")
out.append("typedef struct { int32_t cp, d0, d1, d2, d3; } NovaDecompEntry;")
out.append("static const NovaDecompEntry nova_decomp_table[] = {")
line="  "
for cp,ds in decomps:
    s="{%d,%d,%d,%d,%d},"%(cp,ds[0],ds[1],ds[2],ds[3])
    if len(line)+len(s)>110: out.append(line); line="  "
    line+=s
out.append(line); out.append("};")
out.append("#define NOVA_DECOMP_COUNT %d"%len(decomps))
out.append("typedef struct { int32_t cp, ccc; } NovaCCCEntry;")
out.append("static const NovaCCCEntry nova_ccc_table[] = {")
line="  "
for cp,cc in cccs:
    s="{%d,%d},"%(cp,cc)
    if len(line)+len(s)>110: out.append(line); line="  "
    line+=s
out.append(line); out.append("};")
out.append("#define NOVA_CCC_COUNT %d"%len(cccs))
out.append("typedef struct { int32_t a, b, cp; } NovaCompEntry;")
out.append("static const NovaCompEntry nova_comp_table[] = {")
line="  "
for a,b,cp in comps:
    s="{%d,%d,%d},"%(a,b,cp)
    if len(line)+len(s)>110: out.append(line); line="  "
    line+=s
out.append(line); out.append("};")
out.append("#define NOVA_COMP_COUNT %d"%len(comps))
open("_unorm_tables.c","w",encoding="ascii").write("\n".join(out)+"\n")
import os
print("wrote _unorm_tables.c bytes:",os.path.getsize("_unorm_tables.c"),"lines:",len(out))
