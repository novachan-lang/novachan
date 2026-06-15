import unicodedata
HANGUL = range(0xAC00, 0xD7A4)
decomps=[]; cccs=[]; comps=[]; maxlen=0
for cp in range(0x110000):
    c=chr(cp)
    cc=unicodedata.combining(c)
    if cc: cccs.append((cp,cc))
    if cp in HANGUL: continue
    nfd=unicodedata.normalize('NFD',c)
    if nfd!=c:
        ds=[ord(x) for x in nfd]
        maxlen=max(maxlen,len(ds))
        decomps.append((cp,ds))
    d=unicodedata.decomposition(c)
    if d and not d.startswith('<'):
        parts=[int(x,16) for x in d.split()]
        if len(parts)==2:
            a,b=parts
            if a not in HANGUL and unicodedata.normalize('NFC',chr(a)+chr(b))==c:
                comps.append((a,b,cp))
print("decomps:",len(decomps),"max_nfd_len:",maxlen)
print("cccs:",len(cccs))
print("comps:",len(comps))
# how many decomps have len>4?
print("decomps with len>4:", sum(1 for _,ds in decomps if len(ds)>4))
print("sample decomps:", decomps[:3])
print("sample comps:", comps[:3])
