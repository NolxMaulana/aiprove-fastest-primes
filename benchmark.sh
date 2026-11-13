#!/bin/bash
# Benchmark: wall-clock per single run (process start -> exit), 21 reps each.
# Timing via bash $EPOCHREALTIME (microsecond resolution), min/median/mean.
# Usage: ./benchmark.sh [binary] [N...]
BIN=${1:-./primes}; shift
NS=${*:-100000 1000000 5000000}
for N in $NS; do
  TIMES=()
  for i in $(seq 1 21); do
    S=$EPOCHREALTIME
    echo "$N" | "$BIN" > /dev/null
    E=$EPOCHREALTIME
    TIMES+=($(python3 -c "print(f'{$E-$S:.6f}')"))
  done
  python3 - "$N" "${TIMES[@]}" <<'PY'
import sys, statistics
n, ts = sys.argv[1], sorted(float(x) for x in sys.argv[2:])
print(f"N={n:>8}: min={min(ts)*1000:7.3f} ms  median={statistics.median(ts)*1000:7.3f} ms  mean={statistics.mean(ts)*1000:7.3f} ms  max={max(ts)*1000:7.3f} ms  (n=21 runs)")
PY
done
echo "--- (spot checks via bash time done separately; see TRANSCRIPT.md) ---"
