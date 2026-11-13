#!/bin/bash
# Correctness check vs known pi(N) values + public cases.json values.
# Usage: ./test_correctness.sh [binary]
BIN=${1:-./primes}
declare -A EXPECT=( [1]=0 [2]=1 [3]=2 [10]=4 [100]=25 [1000]=168 [10000]=1229 [100000]=9592 [1000000]=78498 [5000000]=348513 )
FAIL=0
for N in 1 2 3 10 100 1000 10000 100000 1000000 5000000; do
  GOT=$(echo "$N" | "$BIN")
  EXP=${EXPECT[$N]}
  if [ "$GOT" = "$EXP" ]; then echo "PASS pi($N)=$GOT"; else echo "FAIL pi($N): got $GOT expected $EXP"; FAIL=1; fi
done
# brute-force cross-check for all N 1..200 with a tiny python sieve
python3 - <<'PY' > /tmp/brute_expected.txt
def primes_upto(n):
    s=[True]*(n+1); s[0]=s[1]=False
    for i in range(2,int(n**0.5)+1):
        if s[i]:
            for j in range(i*i,n+1,i): s[j]=False
    return sum(s)
for n in range(1,201):
    print(n, primes_upto(n))
PY
while read -r N EXP; do
  GOT=$(echo "$N" | "$BIN")
  if [ "$GOT" != "$EXP" ]; then echo "FAIL brute N=$N got $GOT expected $EXP"; FAIL=1; fi
done < /tmp/brute_expected.txt
[ $FAIL -eq 0 ] && echo "ALL CORRECTNESS CHECKS PASSED ($BIN)" || echo "FAILURES PRESENT ($BIN)"
exit $FAIL
