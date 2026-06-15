for i in $(seq 1 40); do
  out=$(lldb --batch -o "run" -o "bt" -o "quit" -- ./_stk_exact.exe 2>&1)
  if echo "$out" | grep -qiE "stop reason|EXC_|exception|0xc0000028|stopped"; then
    echo "=== CRASH on iter $i ==="
    echo "$out" | grep -iE "stop reason|frame #|0xc0|nova|stacktrace" | head -30
    exit 0
  fi
done
echo "no crash captured under lldb in 40 iters (lldb perturbs timing)"
