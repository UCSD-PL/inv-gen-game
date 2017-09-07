#!/bin/sh
# Populate data needed for the paper

set -e

db="$1"

# Pull any missing survey data
./survey.py --db "$db"

# Solved levels with individual invariants
#
# We may need to include more experiments here
./verify.py --db "$db" \
  --lvlset ../lvlsets/unsolved-new-benchmarks.lvlset \
  --enames new-benchmarks --lvlsets unsolved-new-benchmarks \
  --modes individual \
  --read --write
./verify.py --db "$db" \
  --lvlset ../lvlsets/unsolved-new-benchmarks2.lvlset \
  --enames new-benchmarks --lvlsets unsolved-new-benchmarks2 \
  --modes individual \
  --read --write

# Solved levels with invariants combined by skill level
#
# Multiple levelsets are combined here to share invariants on levels that
# weren't changed in the updated levelset.
for exp in math prog; do
  for n in 1 2 3 4 5; do
    workers="$(sqlite3 "$db" "
      select distinct worker
      from surveydata
      where cast(json_extract(payload, \"$.${exp}_experience\")
        as integer) <= $n;
    " | tr '\n' ' ')"
    if [ -z "$workers" ]; then
      # No workers
      continue
    fi
    ./verify.py --db "$db" \
      --lvlset "../lvlsets/unsolved-new-benchmarks.lvlset" \
      --enames new-benchmarks \
      --lvlsets unsolved-new-benchmarks unsolved-new-benchmarks2 \
      --workers $workers \
      --tag "$exp-exp-le-$n" \
      --modes combined \
      --read --write
    # We only need levels that differ in levelset2
    ./verify.py --db "$db" \
      --lvlset "../lvlsets/unsolved-new-benchmarks2.lvlset" \
      --enames new-benchmarks \
      --lvlsets unsolved-new-benchmarks2 \
      --lvls s-gauss_sum_true-unreach-call-auto m-S5auto \
      --workers $workers \
      --tag "$exp-exp-le-$n" \
      --modes combined \
      --read --write
  done
done
