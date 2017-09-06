#!/bin/sh
# Extract data from the database for graphing

set -e

db="$1"

mkdir -p data

# Solved levels for workers at or below each experience level
#
# Some workers responded with different answers for experience level:
# =Math
#   select distinct worker,
#     count(distinct json_extract(payload, "$.math_experience"))
#   from surveydata group by worker;
# =Programming
#   select distinct worker,
#     count(distinct json_extract(payload, "$.prog_experience"))
#   from surveydata group by worker;
for exp in math_experience prog_experience; do
  # We may want to include more config parameters here
  sqlite3 -header -separator ' ' "$db" "
    select lvl,
      sum(
        json_extract(payload, \"$.workers[0]\") in (
          select distinct worker from surveydata
          where cast(json_extract(payload, \"$.$exp\") as integer) <= 1
        )
      ) as exp_1,
      sum(
        json_extract(payload, \"$.workers[0]\") in (
          select distinct worker from surveydata
          where cast(json_extract(payload, \"$.$exp\") as integer) <= 2
        )
      ) as exp_2,
      sum(
        json_extract(payload, \"$.workers[0]\") in (
          select distinct worker from surveydata
          where cast(json_extract(payload, \"$.$exp\") as integer) <= 3
        )
      ) as exp_3,
      sum(
        json_extract(payload, \"$.workers[0]\") in (
          select distinct worker from surveydata
          where cast(json_extract(payload, \"$.$exp\") as integer) <= 4
        )
      ) as exp_4,
      sum(
        json_extract(payload, \"$.workers[0]\") in (
          select distinct worker from surveydata
          where cast(json_extract(payload, \"$.$exp\") as integer) <= 5
        )
      ) as exp_5
    from verifydata
    where json_extract(config, \"$.mode\") = \"individual\"
      and provedflag = 1
    group by lvl
  " >"data/lvl_$exp.dat"
done
