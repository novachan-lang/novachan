# W5b RETURN-DROP BLIND-SPOT DIAGNOSIS -- 2026-06-15 (iter-80)

One-line: W5b (the opt-in NOVA_T8_DROP=1 return-time auto-drop of local list/dict slots) is
STILL UNSOUND at HEAD -- 9 of 431 suite tests fail under W5b (6 use-after-free crashes + 3
wrong-output). Root cause pinpointed to a single mechanism: when a local is bound to a fresh
aggregate (let x = []) and then used, the compiler forwards the CONSTRUCTION register via a
copy instead of a slot_load, so the escape-mark (which keys on ire_load_origin, set only by
slot_load) never attributes the escape to x's slot -> W5b frees x even though it escaped into
the returned aggregate. The fix is minimal and additive (link a stored register to its slot in
slot_store). This is investigation-only: NO code change and NO W5b flip was made.

## Status of the leak / W5b

- The headline leak (loop-local reassignment leaks ~1 heap value/iter) is addressed by W5b
  (return-drop) + S3 (total-RC). W5b remains DEFAULT OFF (do_w5b, nova_compiler.nova L15677,
  gated on NOVA_T8_DROP=1). It MUST stay off: a use-after-free is strictly worse than the leak.
- The leak is LEAK-only and tolerable; this diagnosis is the prerequisite to a sound fix, not
  a flip.

## free_local semantics (the LEAK-vs-UAF dividing line) -- VERIFIED

nova_rt_list_free_local (nova_runtime.c L1027) and nova_rt_dict_free_local (L1041):
- HARD free(list->data) the backing array UNCONDITIONALLY, then set data=NULL, size=0, cap=0.
- Then nova_rc_dec(handle) on the container struct.
- They do NOT decref the elements ("caller guarantees they are primitives or not strongly held
  elsewhere") and do NOT RC-gate the array free.

Consequences:
- An escaped ELEMENT is never touched -> at worst a LEAK (the element's RC was inc'd by the
  escaping holder; free_local does not dec it). Never a UAF of an element.
- An escaped CONTAINER's backing array is hard-freed regardless of live holders -> UAF. Because
  free_local zeros cap to 0, a subsequent nova_rt_list_append by the live holder hits
  size(0) >= cap(0) -> cap *= 2 stays 0 -> realloc(NULL, 0) -> data[0] = elem writes out of
  bounds. So the UAF manifests as a heap-buffer-overflow in nova_rt_list_append at L1016, NOT
  as a classic dangling read.

## Escape-marking inventory -- VERIFIED

ire_load_origin[dest] is set in exactly ONE place: slot_load (L14812, dest = load from
%slot.<v>; origin = v). It is propagated by the copy op (L15218). EVERY escape-mark keys on
ire_load_origin[arg]:
- general call catch-all (L14981-14986): marks the origin slot of EVERY slot-loaded arg of any
  non-_no_rc call. This is very conservative and covers most escapes (any container passed to
  any function).
- make_list element (L15066), make_struct field (L15043), field_set value (L15132),
  index_set list/dict/generic value (L15171/15187/15204), make_closure capture (L15239),
  dyn_call args (L15261), list_append/dict_set value (L14965/14973).

The W5b drop (L15684-15713) iterates the function's local slots; for each slot that is (a) not
the returned slot (returned_slot = ire_load_origin[ret_arg]), (b) not in ire_slot_escaped, and
(c) of kind list or dict, it emits nova_rt_list_free_local / nova_rt_dict_free_local.

## Probe results

Targeted probes compiled under NOVA_T8_DROP=1 and run under AddressSanitizer:
- A local-no-escape, B return-direct, C intra-frame alias (let s2 = s), D/G nested container
  built + returned, E return-an-alias: ALL ASAN-CLEAN. The common surface (and intra-frame
  aliasing -- the initial hypothesis) is SOUND. The conservative call catch-all does its job.
  Note: these probes only READ the escaped container after return; reading a freed-and-zeroed
  list (size=0) returns 0 harmlessly, which is why they did not crash.
- H (minimal reproducer) CRASHES: fn mk() -> list { let pairs = []; [pairs] }, then the caller
  does push(sm[0], x). ASAN: heap-buffer-overflow in nova_rt_list_append at L1016.

The differentiator vs the clean probes: H APPENDS to the returned inner container (triggering
the cap=0 overflow), and the inner container is a let-bound FRESH aggregate accessed by
value-forwarding (see root cause).

## Self-compile test (a false "all clear")

A throwaway W5b-compiled compiler (built with NOVA_T8_DROP=1, NEVER installed) self-compiles
nova_compiler.nova to BYTE-IDENTICAL output (SHA CD05F294, equal to the gen3 reference). So the
iter-58 "W5b-compiled compiler cannot self-compile" symptom does NOT reproduce at HEAD -- the
compiler's own code patterns happen to be W5b-safe. This is necessary but NOT sufficient: it
proves only that nova_compiler.nova is W5b-safe, not that all programs are.

## The decisive evidence: full regression under W5b output-drops

Running the full 431-test regression with NOVA_T8_DROP=1 (every test's OUTPUT carries W5b
return-drops; normal installed gen3 as the compiler) yields 422 PASS, 9 FAIL:
- 6 UAF crashes (RUN exit = -1073741819 = 0xC0000005 access violation): sorted_map_test, ecs,
  router, routerx, stacktracex, real_http_api.
- 3 wrong-output (ASSERT FAIL): physics2d, rex, pvecx.

So W5b output-drops are unsound for real user programs. W5b is NOT flippable as-is.

## ROOT CAUSE -- pinpointed in emitted IR

sorted_map_test crashes at the push in sorted_map_set, on the inner list returned by
sorted_map_new: fn sorted_map_new() -> list { let pairs = []; [pairs] }. The W5b-compiled IR of
the minimal-equivalent mk() is:

    define i64 @mk() {
    entry:
      %slot.pairs = alloca i64
      store i64 0, ptr %slot.pairs
      %r0 = call i64 @nova_rt_list_create()      ; pairs = []
      store i64 %r0, ptr %slot.pairs             ; slot_store pairs <- %r0
      %r2 = add i64 %r0, 0                        ; copy of %r0 (value-forwarding), NOT a slot_load
      %r1 = call i64 @nova_rt_list_create()       ; the outer list [ ... ]
      call i64 @nova_rt_list_append(i64 %r1, i64 %r2)  ; append pairs into the returned outer
      %dl.pairs0 = load i64, ptr %slot.pairs
      call i64 @nova_rt_list_free_local(i64 %dl.pairs0)  ; <-- W5b FREES pairs (BUG)
      ret i64 %r1
    }

The mechanism, exactly:
1. let pairs = [] constructs %r0 and stores it into %slot.pairs.
2. The use of pairs in [pairs] is value-forwarded: the compiler emits %r2 = add %r0, 0 (the copy
   op, L15212) instead of a fresh slot_load of pairs.
3. The copy op propagates ire_load_origin from its source (L15218), but its source %r0 is a
   fresh nova_rt_list_create result that has NO ire_load_origin. So %r2 carries NO load_origin.
4. The make_list/append escape-mark (L15066, and the call catch-all L14984) checks
   contains(ire_load_origin, arg). %r2 has none -> the mark never fires -> ire_slot_escaped never
   gets "pairs".
5. At return, W5b sees the local list slot pairs is not the returned slot (the returned value is
   the outer %r1, a make_list temp with no load_origin, so returned_slot = "") and not in
   ire_slot_escaped -> it emits free_local(pairs).
6. pairs (now cap=0) is still referenced by the returned outer list. The caller's push overflows.

So the blind spot is NOT field-read/literal escapes in general (the catch-all covers passing to
functions); it is specifically: a value that escapes via a register WITHOUT load_origin because
value-forwarding replaced a slot_load with a copy of the original construction register, and
that construction register never had a load_origin. The pattern "let x = <fresh aggregate>;
<wrap x into a returned/escaping aggregate>" is the trigger.

## Minimal SOUND fix (for a future gated iter -- NOT done here)

Link the construction register to its slot at the store, so value-forwarded uses still attribute
escapes to the slot. In slot_store (L14818), additionally record:

    e.ire_load_origin[args[0]] = value        ; the stored register now "belongs to" this slot

Then %r0 gets load_origin = pairs; the copy op (L15218) propagates it to %r2; the make_list /
append escape-mark fires; pairs is marked escaped and W5b correctly skips it.

Why this is SOUND (conservative direction): setting load_origin on a stored register can only
cause MORE slots to be considered escaped (a register stored into slot A, later used, now
attributes its escapes to A). More marks => more slots skipped from drop => MORE leaks, NEVER
fewer frees. It can never introduce a use-after-free; at worst it forgoes a drop that would have
been safe. This is exactly the safe side to err on.

Caveats to validate in the fix iter: a register stored into multiple slots (the last store
wins for load_origin -- acceptable, still conservative); interaction with the float-slot raw
path (slot_store has a float-typed fast path at L14831 -- the load_origin record must be added
on the general store path so it does not perturb float codegen / GATE-5).

## Validation gate for the fix iter (iter-81 candidate)

Because it touches nova_compiler.nova: precheck (gen3, kill-on-timeout) -> rebuild gen4 ->
run the W5b probe suite (_w5b_probe_*.nova) under NOVA_T8_DROP=1 + ASAN, especially probe H ->
the FULL regression under NOVA_T8_DROP=1 must go from 422/9 to 431/0 (the 9 reproducers fixed,
nothing else broken) -> the NORMAL (W5b-off) regression must stay 431/0 (the slot_store change
is inert when W5b is off, but verify) -> bootstrap reconverge gen5.ll == gen6.ll (NEW fixpoint
expected, compiler-source change) -> green_scale. Only after ALL 9 W5b reproducers pass AND a
dedicated W5b reconverge (gen5_w5b.ll == gen6_w5b.ll) AND a green_scale-under-W5b would a
DEFAULT FLIP even be considerable -- and that is a separate campaign, gated independently.

## The deeper permanent fix (S3 / S2.5)

The escape-set heuristic will always be a "prove it does not escape, else keep it" approximation.
The principled end state is S2.5: per-value clone-or-transfer OWNERSHIP, so the drop decision is
a fact (this frame owns it) not a heuristic. With ownership, the headline loop-local-reassignment
leak is fixed deterministically and W5b's escape-set becomes unnecessary. S2.5 is the larger
value-model campaign; the minimal fix above unblocks W5b in the meantime without it.

## Artifacts (committed as permanent W5b guards)

- Probes: _w5b_probe_a, b, c, e, g (clean cases) and _w5b_probe_h (the minimal reproducer).
- _w5b_probe_run.ps1 (compile+run probes OFF vs ON), _w5b_asan_repro.ps1 (ASAN one program under
  W5b), _w5b_selfcompile.ps1 (build a throwaway W5b compiler + self-compile diff),
  _w5b_regression.ps1 (full regression under NOVA_T8_DROP=1). None of these install a W5b binary
  as gen3_test.exe.
