# TRANSCRIPT — fastest-primes entry build (2026-11-13, WIB)

No secrets involved. No session token, wallet, key, or password was used,
requested, or stored at any point in this build.

1. Read the spec:
   - `browser.open` https://github.com/AIProveRH/aiprove/tree/main/challenges/fastest-primes
     -> "Read an integer N (1 <= N <= 5,000,000) on stdin and print the number
     of primes <= N on stdout. Entry: a program (any language) plus its run
     command. Metric: wall-clock latency on the grader's hidden N values.
     Correct output required; wrong output is disqualified before timing."
   - `curl api.github.com/repos/AIProveRH/aiprove/contents/challenges/fastest-primes`
     -> files: README.md, cases.json.
   - `curl raw.githubusercontent.com/.../cases.json`
     -> [{"n":10,"count":4},{"n":100,"count":25},{"n":1000,"count":168},
         {"n":100000,"count":9592},{"n":1000000,"count":78498}]
   - Toolchain available: gcc 13.3.0, python3 3.12.3 (no pypy3).

2. Wrote `primes.c`: C, odd-only byte-array sieve, `gcc -O3 -march=native`.
   Wrote `primes_bitset.c` as a comparison variant (bitset + popcount).

3. Correctness `./test_correctness.sh`:
   - `./primes`: ALL PASS (pi values 1..5,000,000 incl. all 5 cases.json
     samples, plus brute-force cross-check N=1..200).
   - `./primes_bitset`: FAILED at first (operator-precedence bug in the
     prime test: `!(x) & 1` instead of `!(x & 1)`). Fixed the parentheses,
     rebuilt, re-ran: ALL PASS.

4. Benchmark `./benchmark.sh` (21 runs, $EPOCHREALTIME wall-clock):
   - `./primes` (-O3 -march=native): N=100000 min 1.57 ms; N=1000000 min
     2.13 ms; N=5000000 min 6.86 ms, median 7.26 ms.
   - `./primes_bitset`: N=5000000 min 7.13 ms -> slightly slower, kept as
     reference only.
   - `/usr/bin/time` does not exist in this VM; used bash builtin `time`
     instead for spot checks: N=100000 real 0.002s, N=1000000 real 0.003s,
     N=5000000 real 0.007s.

5. Portability decision: rebuilt the entry binary with plain `gcc -O3`
   (no `-march=native`) to avoid SIGILL if the grader CPU differs.
   Re-benchmarked: N=100000 min 1.41 ms, N=1000000 min 2.39 ms,
   N=5000000 min 6.90 ms (median 7.64 ms, mean 8.01 ms). Re-ran full
   correctness suite on the final binary: ALL PASS. Removed the
   intermediate `primes_generic` binary.

6. Wrote README.md and this TRANSCRIPT.md. Entry NOT submitted to
   aiprove.fun (per task instructions).
