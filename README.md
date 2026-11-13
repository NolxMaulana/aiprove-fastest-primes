# fastest-primes — AIProve entry (ready to submit, NOT yet submitted)

Bounty: `fastest-primes`, 1,000,000 PROVE, closes 16 Nov 2026 20:49 WIB, AutoGrade,
metric = wall-clock latency on the grader's hidden N values.
Spec: https://github.com/AIProveRH/aiprove/tree/main/challenges/fastest-primes

## Contract (from spec + cases.json)

- Read one integer N (1 <= N <= 5,000,000) from **stdin**.
- Print the number of primes <= N on **stdout** (single integer + newline).
- Any language; entry = program + run command. Wrong output = disqualified before timing.

## Entry (primary)

- Source: `primes.c` — C, odd-only Sieve of Eratosthenes over a byte array
  (index i represents 2i+1; prime 2 counted separately).
- Build: `gcc -O3 -o primes primes.c` (plain `-O3`, no `-march=native`, so the
  binary is portable to the grader's machine; `-march=native` was only ~0.9 ms
  faster at N=5,000,000 and risks SIGILL on a different CPU).
- Run: `echo <N> | ./primes`

## Correctness (verified locally, 2026-11-13)

All pass, binary `./primes`:

| N | output | expected |
|---|--------|----------|
| 1 | 0 | 0 |
| 2 | 1 | 1 |
| 3 | 2 | 2 |
| 10 | 4 | 4 (cases.json) |
| 100 | 25 | 25 (cases.json) |
| 1000 | 168 | 168 (cases.json) |
| 10000 | 1229 | 1229 |
| 100000 | 9592 | 9592 (cases.json) |
| 1000000 | 78498 | 78498 (cases.json) |
| 5000000 | 348513 | 348513 |

Plus brute-force cross-check for every N = 1..200 against an independent
Python sieve: all match. Test script: `./test_correctness.sh [binary]`.

## Timing (measured locally in this VM, 2026-11-13)

Method: wall-clock per single run, process start to exit, via bash
`$EPOCHREALTIME`, 21 repetitions; also spot-checked with bash `time`.
Machine: this VM (1.5 shared CPU, 6 GB RAM). Grader hardware will differ;
relative ranking vs other entries is what matters.

`./primes` (gcc -O3, portable build):

| N | min | median | mean | bash `time` real |
|---|-----|--------|------|------------------|
| 100000 | 1.41 ms | 1.84 ms | 1.83 ms | 0.002 s |
| 1000000 | 2.39 ms | 2.74 ms | 2.90 ms | 0.003 s |
| 5000000 | 6.90 ms | 7.64 ms | 8.01 ms | 0.007 s |

Bitset variant (`primes_bitset.c`, 1 bit/odd + popcount) was benchmarked too
and is slightly slower at N=5,000,000 (min 7.13 ms vs 6.90 ms), so it is
kept only as a reference, not the entry. Benchmark script: `./benchmark.sh`.

## Files

- `primes.c` — entry source (primary)
- `primes` — compiled entry binary (gcc -O3)
- `primes_bitset.c`, `primes_bitset` — slower reference variant
- `test_correctness.sh` — correctness tests (known pi values + brute force 1..200)
- `benchmark.sh` — timing benchmark (21 runs, min/median/mean)
- `README.md` — this file
- `TRANSCRIPT.md` — build log (no secrets; no token/wallet/key was used)

## Submission status

NOT submitted. No session token, wallet, or key was used or requested.
To submit, the coordinator uploads `primes.c` (or the `primes` binary) with
run command `./primes` via the normal aiprove.fun flow.
