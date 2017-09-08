#!/bin/sh
# Populate data needed for the paper

set -e

db="$1"

# Pull any missing survey data
./survey.py --db "$db"

lvlset1_good_lvls="m-S9 m-S10 m-S11 m-non-lin-ineq-1 m-non-lin-ineq-2
  m-non-lin-ineq-3 m-non-lin-ineq-4 m-prod-bin m-cube2"

# Solved levels with individual invariants (both in a single assignment and
# across all of a worker's assignments)
#
# We may need to include more experiments here
./verify.py --db "$db" \
  --lvlset ../lvlsets/unsolved-new-benchmarks.lvlset \
  --enames new-benchmarks \
  --lvls $lvlset1_good_lvls \
  --modes individual-play individual \
  --read --write
./verify.py --db "$db" \
  --lvlset ../lvlsets/unsolved-new-benchmarks-5-auto.lvlset \
  --enames new-benchmarks \
  --modes individual-play individual \
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
      --lvls $lvlset1_good_lvls \
      --workers $workers \
      --tag "$exp-exp-le-$n" \
      --modes combined \
      --read --write
    # We only need levels that differ in levelset2
    ./verify.py --db "$db" \
      --lvlset "../lvlsets/unsolved-new-benchmarks-5-auto.lvlset" \
      --enames new-benchmarks \
      --workers $workers \
      --tag "$exp-exp-le-$n" \
      --modes combined \
      --read --write
  done
done
