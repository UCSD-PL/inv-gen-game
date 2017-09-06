#!/bin/sh
# Populate data needed for the paper

set -e

db="$1"

# Pull any missing survey data
./survey.py --db "$db"

# Overall solved levels with combined invariants and individuals
#
# We may need to include more experiments here
./verify.py --db "$db" \
  --lvlset ../lvlsets/unsolved-new-benchmarks.lvlset \
  --enames new-benchmarks --lvlsets unsolved-new-benchmarks \
  --modes individual \
  --read --write
