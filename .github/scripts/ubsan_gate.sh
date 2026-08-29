#!/usr/bin/env bash
# UNDEFINED BEHAVIOUR GATE.
#
# WHY THIS EXISTS. argon2id returned a DIFFERENT HASH FOR THE SAME INPUT, on macOS and only on
# macOS, intermittently. Three sanitizers said the code was fine:
#     ASAN on Linux            -> clean
#     MemorySanitizer on Linux -> clean (with origin tracking)
#     ASAN on the macOS runner -> REPRODUCED the failure, and reported NO memory error
# The cause was signed integer overflow in nova_rt_add, reached from BLAKE2b -- which is DEFINED
# on unsigned 64-bit wraparound and therefore overflows constantly by design. Signed overflow is
# UNDEFINED BEHAVIOUR in C, so Apple clang 21 and Ubuntu clang 18 were each entitled to compute a
# different answer, and did. ASAN and MSan cannot see that class at all; only UBSan can.
#
# THE KEY PROPERTY: undefined behaviour is a property of the SOURCE, not of a platform. One
# instrumented run here protects Windows, Linux and macOS alike. That is what makes this gate
# cheap enough to run on every push, unlike the platform-specific suites -- and it is why it lives
# on the Linux job rather than being duplicated three times.
#
# BLOCKING on purpose. Casting through uint64_t in nova_rt_add/sub/mul closes the sites we know
# about; this stops the CLASS returning the next time someone adds an arithmetic path. Left
# advisory, the next instance would be found the same way this one was: as a wrong answer, on one
# platform, months later, after three sanitizers had said everything was fine.
set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$REPO_ROOT/nova-compiler"
export NOVA_HOME="$(pwd)"
export NOVA_NO_CACHE=1

# NOVA is overridable so this script can be RUN before it is pushed. Two CI scripts in this repo
# have already shipped broken because they were only exercised in a different environment from the
# one they run in (an unexported variable inside an exported function; `timeout` on a macOS runner
# that has none). A gate that cannot be tested locally is a gate that will be wrong.
NOVA="${NOVA:-$NOVA_HOME/compiler/nova}"
RT="$NOVA_HOME/compiler/nova_runtime.c"
[ -x "$NOVA" ] || { echo "::error title=ubsan::compiler not built at $NOVA"; exit 1; }

cd test_programs

# Arithmetic- and crypto-heavy tests: the paths where wraparound is INTENTIONAL, and therefore
# where signed-overflow UB actually gets exercised rather than merely being possible.
TESTS="_argon2id_kat _argon2id_test _pbkdf2_native_test forge_pg_scram_test int_ptr_soundness_repro _bitpack_test _bittricks_test forge_crypto_sha256_test"

failed=0
ran=0
for t in $TESTS; do
  [ -f "$t.nova" ] || { echo "  [absent]       $t"; continue; }
  if ! "$NOVA" "$t.nova" "/tmp/ub_$t.ll" >/dev/null 2>&1; then
    echo "  [skip-compile] $t"; continue
  fi
  if ! clang -O1 -g -fsanitize=undefined -fno-sanitize-recover=all \
        -o "/tmp/ub_$t" "/tmp/ub_$t.ll" "$RT" -lpthread -ldl -lm -w >/dev/null 2>&1; then
    echo "  [skip-link]    $t"; continue
  fi
  ran=$((ran + 1))
  out=$(UBSAN_OPTIONS=print_stacktrace=1 "/tmp/ub_$t" 2>&1)
  if printf '%s' "$out" | grep -q "runtime error"; then
    failed=$((failed + 1))
    where=$(printf '%s' "$out" | grep -m1 "runtime error" | sed 's|.*/||' | cut -c1-200)
    frame=$(printf '%s' "$out" | grep -m3 -E '^ *#[0-9]' | tr '\n' ' ' | cut -c1-300)
    echo "  [UB]           $t"
    echo "::error title=ubsan::$t :: $where :: $frame"
  else
    echo "  [clean]        $t"
  fi
done

if [ "$failed" -gt 0 ]; then
  echo "::error title=ubsan::$failed of $ran test(s) executed undefined behaviour -- see annotations"
  exit 1
fi
echo "::notice title=ubsan::no undefined behaviour across $ran arithmetic/crypto tests"
exit 0
