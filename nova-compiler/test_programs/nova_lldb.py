# nova_lldb.py — NOVA process/value-aware pretty-printer for lldb (#33).
#
#   (lldb) command script import nova_lldb.py
#
# NOVA uses a uniform i64 value model: ints are bare i64; strings/lists/dicts/
# structs/channels/bytes/boxes are heap pointers with an 8-byte RC header
# [rc:i32 | tag_magic:i32] just before the pointed-at payload (magic high half =
# 0x4E56, low half = tag; low 3 bits = kind). For BOTH RAW and FAT_STR strings the
# handle points directly at the null-terminated C bytes (the hash/len/RC headers
# sit before it), so the content is readable at the handle.
#
# The compiler (under NOVA_DWARF_VARS / `nova debug`) types each local `nova_value`,
# so `frame variable` / `v` apply this summary. Decoding reads target memory directly
# (no inferior function calls — those are unreliable from an lldb summary), so it is
# safe to run at any stop.
import lldb

NOVA_MAGIC = 0x4E560000


def _u64(v):
    return v & 0xFFFFFFFFFFFFFFFF


def _render(v_signed, process):
    try:
        v = _u64(v_signed)
        if v < 0x10000:
            return str(v_signed)              # small int / null — not a heap pointer
        err = lldb.SBError()
        magic = process.ReadUnsignedFromMemory(v - 4, 4, err)
        if not err.Success() or (magic & 0xFFFF0000) != NOVA_MAGIC:
            # No RC header: a bare integer, OR a static string literal (literals live in
            # the module image without a heap header). Best-effort for the debugger: if the
            # address reads as a short, fully-printable C string, show it; else the integer.
            serr = lldb.SBError()
            s = process.ReadCStringFromMemory(v, 256, serr)
            if serr.Success() and s and len(s) < 200 and all(32 <= ord(c) < 127 for c in s):
                return '"' + s + '"'
            return str(v_signed)              # bare integer
        tag = magic & 0xFFFF
        if tag == 8:
            return "<bytes>"                  # NOVA_MEM_BYTES (8 & 7 == 0, so check first)
        kind = tag & 0x7
        if kind == 0 or kind == 4:            # RAW / FAT_STR: null-terminated C string at v
            serr = lldb.SBError()
            s = process.ReadCStringFromMemory(v, 8192, serr)
            if serr.Success() and s is not None:
                return '"' + s + '"'
            return "<string>"
        if kind == 1:
            return "<list>"
        if kind == 2:
            return "<dict>"
        if kind == 5:
            return "<struct>"
        if kind == 6:
            return "<iter>"
        if kind == 7:
            return "<boxed>"                  # boxed bool/float/null
        return "<nova heap kind %d>" % kind
    except Exception:
        try:
            return str(v_signed)
        except Exception:
            return "<nova_value>"


def nova_summary(valobj, internal_dict):
    """lldb type-summary provider for the `nova_value` type."""
    try:
        return _render(valobj.GetValueAsSigned(), valobj.GetProcess())
    except Exception:
        try:
            return str(valobj.GetValueAsSigned())
        except Exception:
            return "<nova_value>"


def novap_command(debugger, command, result, internal_dict):
    """`novap <expr>` — evaluate <expr> and render it as a NOVA value."""
    target = debugger.GetSelectedTarget()
    process = target.GetProcess()
    frame = process.GetSelectedThread().GetSelectedFrame()
    val = frame.EvaluateExpression(command)
    if val is None or not val.IsValid() or val.GetError().Fail():
        result.AppendMessage("novap: could not evaluate '%s'" % command)
        return
    result.AppendMessage(_render(val.GetValueAsSigned(), process))


def __lldb_init_module(debugger, internal_dict):
    debugger.HandleCommand('type summary add -F nova_lldb.nova_summary nova_value')
    debugger.HandleCommand('command script add -f nova_lldb.novap_command novap')
    print("[nova_lldb] NOVA value pretty-printer loaded - `nova_value` locals render "
          "structurally; `novap <expr>` renders any expression.")
